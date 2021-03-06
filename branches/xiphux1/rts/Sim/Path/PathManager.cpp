#include "StdAfx.h"
#include "PathManager.h"
#include "Game/UI/InfoConsole.h"
#include "Sim/MoveTypes/MoveInfo.h"
#include "Sim/MoveTypes/MoveMath/GroundMoveMath.h"
#include "Sim/MoveTypes/MoveMath/HoverMoveMath.h"
#include "Sim/MoveTypes/MoveMath/ShipMoveMath.h"
#include "Rendering/GL/myGL.h"
#include "TimeProfiler.h"
#include <vector>
#include "PathFinder.h"
#include "PathEstimator.h"
#include "SDL_timer.h"
#include "mmgr.h"

const float ESTIMATE_DISTANCE = 55;
const float MIN_ESTIMATE_DISTANCE = 40;
const float DETAILED_DISTANCE = 25;
const float MIN_DETAILED_DISTANCE = 12;
const unsigned int MAX_SEARCHED_NODES_ON_REFINE = 2000;
const unsigned int CPathManager::PATH_RESOLUTION = CPathFinder::PATH_RESOLUTION;

CPathManager* pathManager=0;


/*
Constructor
Creates pathfinder and estimators.
*/
CPathManager::CPathManager() {
	//--TODO: Move to creation of MoveData!--//
	//Create MoveMaths.
	ground = new CGroundMoveMath();
	hover = new CHoverMoveMath();
	sea = new CShipMoveMath();

	float waterDamage=atof(readmap->mapDefParser.SGetValueDef("0","MAP\\WATER\\WaterDamage").c_str());
	if(waterDamage>=1000)
		CGroundMoveMath::waterCost=0;
	else
		CGroundMoveMath::waterCost=1/(1.0+waterDamage*0.1);

	CHoverMoveMath::noWaterMove=waterDamage>=10000;

	//Address movemath and pathtype to movedata.
	int counter = 0;
	std::vector<MoveData*>::iterator mi;
	for(mi = moveinfo->moveData.begin(); mi < moveinfo->moveData.end(); mi++) {
		(*mi)->pathType = counter;
//		(*mi)->crushStrength = 0;
		switch((*mi)->moveType) {
			case MoveData::Ground_Move:
				(*mi)->moveMath = ground;
				break;
			case MoveData::Hover_Move:
				(*mi)->moveMath = hover;
				break;
			case MoveData::Ship_Move:
				(*mi)->moveMath = sea;
				break;
		}
		counter++;
	}
	//---------------------------------------//

	//Create pathfinder and estimators.
	pf = new CPathFinder();
	pe = new CPathEstimator(pf, 8, CMoveMath::BLOCK_STRUCTURE | CMoveMath::BLOCK_TERRAIN, "pe");
	pe2 = new CPathEstimator(pf, 32, CMoveMath::BLOCK_STRUCTURE | CMoveMath::BLOCK_TERRAIN, "pe2");

	//Reset id-counter.
	nextPathId = 0;
}


/*
Destructor
Free used memory.
*/
CPathManager::~CPathManager() {
	delete pe2;
	delete pe;
	delete pf;

	delete ground;
	delete hover;
	delete sea;
}


/*
Help-function.
Turns a start->goal-request into a will defined request.
*/
unsigned int CPathManager::RequestPath(const MoveData* moveData, float3 startPos, float3 goalPos, float goalRadius,CSolidObject* caller) {
	startPos.CheckInBounds();
	goalPos.CheckInBounds();
	if(startPos.x>gs->mapx*SQUARE_SIZE-5)
		startPos.x=gs->mapx*SQUARE_SIZE-5;
	if(goalPos.z>gs->mapy*SQUARE_SIZE-5)
		goalPos.z=gs->mapy*SQUARE_SIZE-5;

	//Create a estimator definition.
	CRangedGoalWithCircularConstraint * rangedGoalPED = new CRangedGoalWithCircularConstraint(startPos,goalPos, goalRadius,3,2000);

	//Make request.
	return RequestPath(moveData, startPos, rangedGoalPED,goalPos,caller);
}


/*
Request a new multipath, store the result and return an handle-id to it.
*/
unsigned int CPathManager::RequestPath(const MoveData* moveData, float3 startPos, CPathFinderDef* peDef,float3 goalPos,CSolidObject* caller) {
//	static int calls = 0;
//	*info << "RequestPath() called: " << (++calls) << "\n";	//Debug

	START_TIME_PROFILE;

	//Creates a new multipath.
	MultiPath* newPath = new MultiPath(startPos, peDef, moveData);
	newPath->finalGoal=goalPos;
	newPath->caller=caller;

	if(caller)
		caller->UnBlock();

	unsigned int retValue=0;
	//Choose finder dependent on distance to goal.
	float distanceToGoal = peDef->Heuristic(int(startPos.x / SQUARE_SIZE), int(startPos.z / SQUARE_SIZE));
	if(distanceToGoal < DETAILED_DISTANCE) {
		//Get a detailed path.
		IPath::SearchResult result = pf->GetPath(*moveData, startPos, *peDef, newPath->detailedPath,true);
		if(result == IPath::Ok || result == IPath::GoalOutOfRange) {
			retValue=Store(newPath);
		} else {
			delete newPath;
		}
	} else if(distanceToGoal < ESTIMATE_DISTANCE) {
		//Get an estimate path.
		IPath::SearchResult result = pe->GetPath(*moveData, startPos, *peDef, newPath->estimatedPath);
		if(result == IPath::Ok || result == IPath::GoalOutOfRange) {
			//Turn a part of it into detailed path.
			EstimateToDetailed(*newPath, startPos);
			//Store the path.
			retValue=Store(newPath);
		} else {	//if we fail see if it can work find a better block to start from
			float3 sp=pe->FindBestBlockCenter(moveData,startPos);
			if(sp.x!=0 && (((int)sp.x)/(SQUARE_SIZE*8)!=((int)startPos.x)/(SQUARE_SIZE*8) || ((int)sp.z)/(SQUARE_SIZE*8)!=((int)startPos.z)/(SQUARE_SIZE*8))){
				IPath::SearchResult result = pe->GetPath(*moveData, sp, *peDef, newPath->estimatedPath);
				if(result == IPath::Ok || result == IPath::GoalOutOfRange) {
					EstimateToDetailed(*newPath, startPos);
					retValue=Store(newPath);
				} else {
					delete newPath;
				}
			} else {
				delete newPath;
			}
		}
	} else {
		//Get a low-res. estimate path.
		IPath::SearchResult result = pe2->GetPath(*moveData, startPos, *peDef, newPath->estimatedPath2);
		if(result == IPath::Ok || result == IPath::GoalOutOfRange) {
			//Turn a part of it into hi-res. estimate path.
			Estimate2ToEstimate(*newPath, startPos);
			//And estimate into detailed.
			EstimateToDetailed(*newPath, startPos);
			//Store the path.
			retValue=Store(newPath);
		} else {	//sometimes the 32*32 squares can be wrong so if it fail to get a path also try with 8*8 squares
			IPath::SearchResult result = pe->GetPath(*moveData, startPos, *peDef, newPath->estimatedPath);
			if(result == IPath::Ok || result == IPath::GoalOutOfRange) {
				EstimateToDetailed(*newPath, startPos);
				retValue=Store(newPath);
			} else { //8*8 can also fail rarely, so see if we can find a better 8*8 to start from
				float3 sp=pe->FindBestBlockCenter(moveData,startPos);
				if(sp.x!=0 && (((int)sp.x)/(SQUARE_SIZE*8)!=((int)startPos.x)/(SQUARE_SIZE*8) || ((int)sp.z)/(SQUARE_SIZE*8)!=((int)startPos.z)/(SQUARE_SIZE*8))){
					IPath::SearchResult result = pe->GetPath(*moveData, sp, *peDef, newPath->estimatedPath);
					if(result == IPath::Ok || result == IPath::GoalOutOfRange) {
						EstimateToDetailed(*newPath, startPos);
						retValue=Store(newPath);
					} else {
						delete newPath;
					}
				} else {
					delete newPath;
				}
			}
		}
	}
	if(caller)
		caller->Block();
	END_TIME_PROFILE("AI:PFS");
	return retValue;
}


/*
Store a new multipath into the pathmap.
*/
unsigned int CPathManager::Store(MultiPath* path) 
{
	//Store the path.
	pathMap[++nextPathId] = path;
	return nextPathId;
}


/*
Turns a part of the estimate path into detailed path.
*/
void CPathManager::EstimateToDetailed(MultiPath& path, float3 startPos) {
	//If there is no estimate path, nothing could be done.
	if(path.estimatedPath.path.empty())
		return;

	path.estimatedPath.path.pop_back();
	//Remove estimate waypoints until
	//the next one is far enought.
	while(!path.estimatedPath.path.empty()
	&& path.estimatedPath.path.back().distance2D(startPos) < DETAILED_DISTANCE * SQUARE_SIZE)
		path.estimatedPath.path.pop_back();

	//Get the goal of the detailed search.
	float3 goalPos;
	if(path.estimatedPath.path.empty())
		goalPos = path.estimatedPath.pathGoal;
	else
		goalPos = path.estimatedPath.path.back();

	//Define the search.
	CRangedGoalWithCircularConstraint rangedGoalPFD(startPos,goalPos, 0,2,1000);

	//Perform the search.
	//If this is the final improvement of the path, then use the original goal.
	IPath::SearchResult result;
	if(path.estimatedPath.path.empty() && path.estimatedPath2.path.empty())
		result = pf->GetPath(*path.moveData, startPos, *path.peDef, path.detailedPath, true);
	else
		result = pf->GetPath(*path.moveData, startPos, rangedGoalPFD, path.detailedPath, true);

	//If no refined path could be found, set goal as desired goal.
	if(result == IPath::CantGetCloser || result == IPath::Error) {
		path.detailedPath.pathGoal = goalPos;
	}
}


/*
Turns a part of the estimate2 path into estimate path.
*/
void CPathManager::Estimate2ToEstimate(MultiPath& path, float3 startPos) {
	//If there is no estimate2 path, nothing could be done.
	if(path.estimatedPath2.path.empty())
		return;

	path.estimatedPath2.path.pop_back();
	//Remove estimate2 waypoints until
	//the next one is far enought.
	while(!path.estimatedPath2.path.empty()
	&& path.estimatedPath2.path.back().distance2D(startPos) < ESTIMATE_DISTANCE * SQUARE_SIZE)
		path.estimatedPath2.path.pop_back();

	//Get the goal of the detailed search.
	float3 goalPos;
	if(path.estimatedPath2.path.empty())
		goalPos = path.estimatedPath2.pathGoal;
	else
		goalPos = path.estimatedPath2.path.back();

	//Define the search.
	CRangedGoalWithCircularConstraint rangedGoal(startPos,goalPos, 0,2,20);

	//Perform the search.
	//If there is no estimate2 path left, use original goal.
	IPath::SearchResult result;
	if(path.estimatedPath2.path.empty())
		result = pe->GetPath(*path.moveData, startPos, *path.peDef, path.estimatedPath, MAX_SEARCHED_NODES_ON_REFINE);
	else {
		result = pe->GetPath(*path.moveData, startPos, rangedGoal, path.estimatedPath, MAX_SEARCHED_NODES_ON_REFINE);
	}

	//If no refined path could be found, set goal as desired goal.
	if(result == IPath::CantGetCloser || result == IPath::Error) {
		path.estimatedPath.pathGoal = goalPos;
	}
}


/*
Removes and return the next waypoint in the multipath corresponding to given id.
*/
float3 CPathManager::NextWaypoint(unsigned int pathId, float3 callerPos, float minDistance, int numRetries) {
	#ifdef PROFILE_TIME
		Uint64 starttime;
		starttime = SDL_GetTicks();
	#endif

	//0 indicate a no-path id.
	if(pathId == 0)
		return float3(-1,-1,-1);

	if(numRetries>4)
		return float3(-1,-1,-1);

	//Find corresponding multipath.
	map<unsigned int, MultiPath*>::iterator pi = pathMap.find(pathId);
	if(pi == pathMap.end())
		return float3(-1,-1,-1);
	MultiPath* multiPath = pi->second;
	
	if(callerPos==ZeroVector){
		if(!multiPath->detailedPath.path.empty())
			callerPos=multiPath->detailedPath.path.back();
	}

	//check if detailed path need bettering
	if(!multiPath->estimatedPath.path.empty()
	&& (multiPath->estimatedPath.path.back().distance2D(callerPos) < MIN_DETAILED_DISTANCE * SQUARE_SIZE
	|| multiPath->detailedPath.path.size() <= 2)){

		if(!multiPath->estimatedPath2.path.empty()		//if so check if estimated path also need bettering
			&& (multiPath->estimatedPath2.path.back().distance2D(callerPos) < MIN_ESTIMATE_DISTANCE * SQUARE_SIZE
			|| multiPath->estimatedPath.path.size() <= 2)){
				Estimate2ToEstimate(*multiPath, callerPos);
		}

		if(multiPath->caller)
			multiPath->caller->UnBlock();
		EstimateToDetailed(*multiPath, callerPos);
		if(multiPath->caller)
			multiPath->caller->Block();
	}

	//Repeat until a waypoint distant enought are found.
	float3 waypoint;
	do {
		//Get next waypoint.
		if(multiPath->detailedPath.path.empty()) {
			if(multiPath->estimatedPath2.path.empty() && multiPath->estimatedPath.path.empty())
				return multiPath->finalGoal;
			else 
				return NextWaypoint(pathId,callerPos,minDistance,numRetries+1);
		} else {
			waypoint = multiPath->detailedPath.path.back();
			multiPath->detailedPath.path.pop_back();
		}
	} while(callerPos.distance2D(waypoint) < minDistance && waypoint != multiPath->detailedPath.pathGoal);

	//Return the result.
	#ifdef PROFILE_TIME
		Uint64 stop;
		stop = SDL_GetTicks();
		profiler.AddTime("AI:PFS",stop - starttime);
	
	#endif
	return waypoint;
}


/*
Delete a given multipath from the collection.
*/
void CPathManager::DeletePath(unsigned int pathId) {
	//0 indicate a no-path id.
	if(pathId == 0)
		return;

	//Find the multipath.
	map<unsigned int, MultiPath*>::iterator pi = pathMap.find(pathId);
	if(pi == pathMap.end())
		return;
	MultiPath* multiPath = pi->second;

	//Erase and delete the multipath.
	pathMap.erase(pathId);
	delete multiPath;
}


/*
Convert a 2xfloat3-defined rectangle into a square-based rectangle.
*/
void CPathManager::TerrainChange(float3 upperCorner, float3 lowerCorner) {
	TerrainChange((unsigned int)(upperCorner.x / SQUARE_SIZE), (unsigned int)(upperCorner.z / SQUARE_SIZE), (unsigned int)(lowerCorner.x / SQUARE_SIZE), (int)(lowerCorner.z / SQUARE_SIZE));
}


/*
Tells estimators about changes in or on the map.
*/
void CPathManager::TerrainChange(unsigned int x1, unsigned int z1, unsigned int x2, unsigned int z2) {
//	*info << "Terrain changed: (" << int(x1) << int(z1) << int(x2) << int(z2) << "\n";	//Debug
	pe->MapChanged(x1, z1, x2, z2);
	pe2->MapChanged(x1, z1, x2, z2);
}


/*
Runned every 1/30sec during runtime.
*/
void CPathManager::Update() {
START_TIME_PROFILE;
	pe->Update();
	pe2->Update();

END_TIME_PROFILE("AI:PFS:Update");
}


/*
Draw path-lines for each path in pathmap.
*/
void CPathManager::Draw() {
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_LIGHTING);
	glLineWidth(3);
	map<unsigned int, MultiPath*>::iterator pi;
	for(pi = pathMap.begin(); pi != pathMap.end(); pi++) {
		MultiPath* path = pi->second;
		list<float3>::iterator pvi;
		
		//Start drawing a line.
		glBegin(GL_LINE_STRIP);

		//Drawing estimatePath2.
		glColor4f(0,0,1,1);
		for(pvi = path->estimatedPath2.path.begin(); pvi != path->estimatedPath2.path.end(); pvi++) {
			float3 pos = *pvi;
			pos.y += 5;
			glVertexf3(pos);
		}

		//Drawing estimatePath.
		glColor4f(0,1,0,1);
		for(pvi = path->estimatedPath.path.begin(); pvi != path->estimatedPath.path.end(); pvi++) {
			float3 pos = *pvi;
			pos.y += 5;
			glVertexf3(pos);
		}

		//Drawing detailPath
		glColor4f(1,0,0,1);
		for(pvi = path->detailedPath.path.begin(); pvi != path->detailedPath.path.end(); pvi++) {
			float3 pos = *pvi;
			pos.y += 5;
			glVertexf3(pos);
		}

		//Stop drawing a line.
		glEnd();

		//Tell the CPathFinderDef to visualise it self.
		path->peDef->Draw();
	}
	glLineWidth(1);
	pf->Draw();
	pe->Draw();
	pe2->Draw();
}

CPathManager::MultiPath::MultiPath(const float3 start, const CPathFinderDef* peDef, const MoveData* moveData) :
	start(start),
	peDef(peDef),
	moveData(moveData) 
{
}

CPathManager::MultiPath::~MultiPath()
{
	delete peDef;
}
