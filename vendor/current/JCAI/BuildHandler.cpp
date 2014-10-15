//-------------------------------------------------------------------------
// JCAI version 0.21
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#include "BaseAIDef.h"
#include "GlobalAI.h"
#include "AI_Config.h"
#include "BuildHandler.h"

#include "ResourceUnitHandler.h"

#include "DebugWindow.h"

// half of the resources must be avaiable before it starts building
const float RequiredAllocation=0.5f; 

/*
Todo list:

- calculate threatProximity for the gameinfo map
- make force groups split up when units are stuck
- support/defense building
- resource excess resulting in temporary production increase
- make force units defend while building the group
- support geothermals
*/

/*
buildmap:
	buildings are marked by FindTaskBuildPos,
	and unmarked in UnitDestroyed()
		- when the unit is destroyed
		- when it's lead builder was destroyed but the unit was not yet created
	and by CheckBuildError():
		- when the unit order can't be found in the command list
		- when the builder timed out and a new command is given
*/

using namespace std;
using namespace boost;

static const char *handlerStr[] = { "Resource", "Force", "Support", "Recon" };

bool BuildHandlerConfig::Load(CfgList *sidecfg)
{
	assert (NUM_TASK_TYPES == 4);
	float sum = 0.0f;
	CfgList* cfg = modConfig.root;
	CfgList *weights = dynamic_cast<CfgList*>(cfg->GetValue ("BuildWeights"));
	CfgList *maxtasks = dynamic_cast<CfgList*>(cfg->GetValue ("MaxTasks"));
	for (int a=0;a<NUM_TASK_TYPES;a++)
	{
		BuildWeights[a] = weights ? weights->GetNumeric (handlerStr[a], 1.0f) : 1.0f;
		MaxTasks[a] = maxtasks ? maxtasks->GetInt (handlerStr[a], 1) : 1;
		sum += BuildWeights[a];
	}
	for (int a=0;a<NUM_TASK_TYPES;a++) 
		BuildWeights[a] /= sum;

	logPrintf ("Building weights: Resources=%f, Forces=%f, Defenses=%f\n", 
		BuildWeights [0], BuildWeights[1], BuildWeights [2]);

	BuildSpeedPerMetalIncome = cfg->GetNumeric ("BuildSpeedPerMetalIncome", 33);
	InitialOrders = dynamic_cast<CfgBuildOptions*>(sidecfg->GetValue("InitialBuildOrders"));
	if (InitialOrders) InitialOrders->InitIDs();

	return true;
}


BuildHandler::BuildHandler (MainAI *pAI) : aiHandler(pAI)
{
	if (!config.Load (ai->sidecfg))
		throw "Failed to load build handler configuration";

	for (int a=0;a<NUM_TASK_TYPES;a++)
		taskResources[a]=0.0f;

	buildMap.Init (ai->cb, &ai->metalmap);
	
	initialBuildOrderTask = 0;
	jobFinderIterator = 0;
	initialBuildOrdersFinished=false;
}


BuildHandler::~BuildHandler ()
{}

void BuildHandler::ShowDebugInfo(DbgWindow *wnd)
{
	DbgWndPrintf (wnd, 0, 20, "Build power: %4.1f / %4.1f, %4.1f / %4.1f", 
		totalBuildPower.metal, averageProd.metal, totalBuildPower.energy, averageProd.energy);
	DbgWndPrintf (wnd, 0, 40, "Build multiplier: %2.2f / %2.2f", 
		buildMultiplier.metal, buildMultiplier.energy);

	for (int i=0;i<NUM_TASK_TYPES;i++)
		DbgWndPrintf (wnd, 0, (i + 3) * 23, "%s: resources: %5.1f, weight: %1.3f", ai->taskHandlers[i]->GetName(), taskResources[i], config.BuildWeights[i]);
}

void BuildHandler::Init (int id)
{
	// Add the commander to the builder list
	BuildUnit *b = new BuildUnit;

	ai->InitUnit (b, id);
	b->owner = this;

	builders.add (b);

	// allocate space for the builder types
	currentBuilders.resize (buildTable.numDefs);
	currentUnitBuilds.resize (buildTable.numDefs);

	InitBuilderTypes (ai->cb->GetUnitDef (id));
	DistributeResources();

	averageProd = ResourceInfo(b->def->energyMake, b->def->metalMake);

	// initialize initial build orders
	if (config.InitialOrders) 
		initialBuildOrderState.resize (config.InitialOrders->builds.size(), 0);
}

void BuildHandler::DistributeResources()
{
	// distribute start resources
	ResourceInfo rs(ai->cb->GetEnergy(), ai->cb->GetMetal());
	float v = ai->ResourceValue (rs);

	for (int a=0;a<NUM_TASK_TYPES;a++)
		taskResources[a] = v * config.BuildWeights [a];
}

void BuildHandler::InitBuilderTypes (const UnitDef* commdr)
{
	for (int a=0;a<buildTable.numDefs;a++)
	{
		BuildTable::UDef *d = &buildTable.deflist [a];

		// Builder?
		if (!d->IsBuilder() || d->IsShip())
			continue;

		// Can it be build directly or indirectly?
		BuildPathNode& bpn = buildTable.GetBuildPath (commdr->id, a);

		if (bpn.id >= 0)
			builderTypes.push_back (a + 1);
	}
}

aiTask* BuildHandler::AddTask (const UnitDef* def,int type)
{
	aiTask *t=new aiTask (def, type >= 0 ? ai->taskHandlers[type] : 0);
	t->resourceType = type;
	AddTask (t);
	return t;
}

void BuildHandler::AddTask (aiTask *task)
{
	tasks.add(task);

	if (task->resourceType>=0)
		ai->taskHandlers[task->resourceType]->AddTask (task);

	BuildTable::UDef *cd = buildTable.GetCachedDef (task->def->id);
	if (cd->IsBuilding ())
	{
		task->flags |= BT_BUILDING;
		
		if (task->pos.x >= 0.0f)
			buildMap.Mark (task->def,task->pos,true);
	}

	if (cd->IsBuilder ())
		task->MarkBuilder ();

	if (task->resourceType < 0) {
		TakeResources (ai->ResourceValue (task->def->energyCost, task->def->metalCost));
		task->MarkAllocated ();
	}

	task->startFrame=ai->cb->GetCurrentFrame();

	currentUnitBuilds[task->def->id-1] ++;
	ChatDebugPrintf (ai->cb, "Added task: %s (%s)", task->def->name.c_str(), task->resourceType >= 0 ? ai->taskHandlers[task->resourceType]->GetName() : "BuildHandler");
}

const UnitDef* BuildHandler::FindBestBuilderType (const UnitDef* constr, BuildUnit **builder)
{
	vector<int>& bl = buildTable.buildby [constr->id-1];

	int best=-1;
	int bs;

	for (int a=0;a<bl.size();a++)
	{
		int v = currentBuilders[bl[a]];

        if (currentBuilders[bl[a]] < 0)
		{
			if (builder) 
				*builder=FindInactiveBuilderForTask (constr);

			return buildTable.GetDef (bl[a]+1);
		}

		v=abs(v);

		if (best < 0 || bs<v)
		{
			best = bl[a];
			bs = v;
		}
	}

	return best >= 0 ? buildTable.GetDef (best+1) : 0;
}

void BuildHandler::SetBuilderToTask (BuildUnit*builder, aiTask *task)
{
	builder->tasks.push_back (task);
	builder->AddDeathDependence (task);

	task->constructors.push_back (builder);
	task->AddDeathDependence (builder);

	task->buildSpeed += builder->def->buildSpeed;

	logPrintf ("SetBuilderToTask: builder %s is assigned to do task %s\n",builder->def->name.c_str(),task->def->name.c_str());
}

void BuildHandler::RemoveUnitBlocking (const UnitDef* def, const float3& pos)
{
	if (!buildTable.GetCachedDef (def->id)->IsBuilding ())
		return;

	if (def->extractsMetal) 
	{
		int2 s = ai->metalmap.GetFrom3D (pos);
		ai->metalmap.MarkSpot (s, false);
	}

	buildMap.Mark (def, pos, false);
}

void BuildHandler::RemoveBuilderTask (BuildUnit *builder, aiTask *task)
{
	if (task->lead == builder)
	{
		if (!task->unit) {
			// unmark
			RemoveUnitBlocking (task->def, task->pos);
		}
	}

	if (builder->activeTask == task)
	{
		Command c;
		c.id=CMD_STOP;
		ai->cb->GiveOrder(builder->id,&c);
	}

	task->DependentDied (builder);
	task->DeleteDeathDependence (builder);

	builder->DependentDied (task);
	builder->DeleteDeathDependence (task);

	task->buildSpeed -= builder->def->buildSpeed;

	logPrintf ("RemoveBuilderTask: task %s is removed from builder %s.\n",task->def->name.c_str(),builder->def->name.c_str());
}

void BuildHandler::FindNewJob (BuildUnit *u)
{
	BuildTable::UDef *cd = buildTable.GetCachedDef (u->def->id);
	int curFrame=ai->cb->GetCurrentFrame();

	if (cd->IsBuilding ()) {
		// factory - find a task that is not yet initialized

		for (int a=0;a<tasks.size();a++) {
			aiTask *t = tasks[a];

			if (!t->depends && t->constructors.empty () && 
				!t->IsBuilding() && buildTable.UnitCanBuild (u->def,t->def))
			{
				SetBuilderToTask (u, t);
				return;
			}
		}
	} else {
		// mobile builder
		float3 builderPos = ai->cb->GetUnitPos(u->id);
		const UnitDef *ud = u->def;
		aiTask *best=0;
		float bestScore;
		float moveSpeed = ai->cb->GetUnitSpeed (u->id);

		for(int a=0;a<tasks.size();a++)
		{
			aiTask *t = tasks[a];

			if (t->depends || !t->AreResourcesAllocated())
				continue;

			float hp = t->unit ? ai->cb->GetUnitHealth(t->unit->id) : 0.0f;
			float buildTimeLeft = u->def->buildTime*((u->def->health-hp)/u->def->health);

			 //can we build this directly or is there someone who can start it for us
			bool canBuildThis=buildTable.UnitCanBuild (u->def, t->def) ;
			if (canBuildThis || t->lead)
			{
				float buildTime=buildTimeLeft/(t->buildSpeed+ud->buildSpeed);
				float distance=0.0f;
				if (t->lead || t->def->extractsMetal) distance = (t->pos-builderPos).Length(); // position has been estimated for metal extractors
				else distance = 40 * SQUARE_SIZE; // assume a constant distance
				float moveTime=max(0.01f,(distance-150)/moveSpeed*10);
				float travelMod=buildTime/(buildTime+moveTime);			//units prefer stuff with low travel time compared to build time
				float finishMod=t->def->buildTime/(buildTimeLeft+t->def->buildTime*0.1f);			//units prefer stuff that is nearly finished
				float canBuildThisMod=canBuildThis?1.5f:1;								//units prefer to do stuff they have in their build options (less risk of guarded unit dying etc)
				float ageMod=20+sqrtf((float)(curFrame+1)-t->startFrame);
//				float buildSpeedMod=info->buildSpeed/(qb->totalBuildSpeed+info->buildSpeed);
				float score=finishMod*canBuildThisMod*travelMod*ageMod;

				if(!best||score>bestScore)
				{
					bestScore=score;
					best = t;
				}
			}
		}

		if (best)
			SetBuilderToTask (u, best);
	}
}

void BuildHandler::OrderNewBuilder()
{
	float bestScore;
	int best=0;

	for (int a=0;a<builderTypes.size();a++)
	{
		assert (builderTypes[a]);
		BuildTable::UDef *cd = buildTable.GetCachedDef (builderTypes[a]);

		if (cd->IsBuilding())
			continue;

		// Find the best unit we can use to build this builder
		const vector<int>& bb = *cd->buildby;
		int numBuilders=0;

		for (int i=0;i<bb.size();i++)
		{
			int n = currentBuilders [bb[i]];
			numBuilders += abs(n) + (n<0)?2:0; // an inactive builder equals 2 extra active builders
		}

		float score = std::min((1+numBuilders),3) * sqrtf(cd->numBuildOptions) * cd->buildSpeed / ai->ResourceValue(cd->cost);
		if (!best || score > bestScore)
		{
			best = builderTypes[a];
			bestScore = score;
		}
	}

	if (best)
	{
		aiTask *t = AddTask (buildTable.GetDef (best),-1);
		ChatDebugPrintf (ai->cb, "Added task to increase build speed: %s\n", t->def->name.c_str());
	}
}

// Is there a builder that can build this unit
bool BuildHandler::CanBuildUnit (const UnitDef *def)
{
	BuildTable::UDef* cd = buildTable.GetCachedDef (def->id);
	const vector<int>& bb = *cd->buildby;

	for (int a=0;a<bb.size();a++) {
		if (currentBuilders[bb[a]])
			return true;
	}
	return false;
}


// Should only be called inside Update()
BuildUnit* BuildHandler::FindInactiveBuilderForTask (const UnitDef *def)
{
	int best = -1;
	float best_score;

	for (int a=0;a<inactive.size();a++)
	{
		BuildUnit *b = inactive[a];

		// It's already set
		if (!b->tasks.empty ())
			continue; 

		if (!buildTable.UnitCanBuild (b->def, def))
			continue;

		BuildPathNode& node = buildTable.GetBuildPath (b->def, def);

		float score = ai->ResourceValue (node.res.energy, node.res.metal) + node.res.buildtime;
		if (best<0 || best_score > score)
		{
			best_score = score;
			best=a;
		}
	}

	if (best >= 0)
		return inactive [best];

	return 0;
}

void BuildHandler::UpdateBuilderTask(BuildUnit *builder)
{
	aiTask *t = builder->activeTask = builder->tasks.front();

	if (t->unit)
	{
		// make the builder repair the unfinished unit
		Command c;
		c.id = CMD_REPAIR;
		c.params.push_back (t->unit->id);

		ai->cb->GiveOrder (builder->id, &c);
	}
	else
	{
		if (!t->lead)
			InitiateTask (t);

		if (builder != t->lead && t->lead)
		{
			Command c;
			c.id = CMD_GUARD;
			c.params.push_back (t->lead->id);
			ai->cb->GiveOrder(builder->id, &c);
		}
	}

	builder->UpdateTimeout (ai->cb);
}

bool BuildHandler::FindTaskBuildPos (aiTask *t, BuildUnit*lead)
{
	float3 pos;
	BuildTable::UDef* cd = buildTable.GetCachedDef (t->def->id);
	float3 builderPos = ai->cb->GetUnitPos (lead->id);

	// Find a sector to build in
	if (t->def->extractsMetal > 0)
	{
		while(1) {
			// Find an empty metal spot
			float3 st (ai->map.baseCenter.x, 0.0f, ai->map.baseCenter.y);
			int2 msect = ai->metalmap.GetEmptySpot (st, &ai->map, false);
			if(msect.x < 0) {
				// no spots left
				return false;
			}

			MetalSpotInfo *info = ai->metalmap.Get (msect.x,msect.y);

			pos = float3(info->spotpos.x, 0.0f, info->spotpos.y) * SQUARE_SIZE;

			if (buildMap.FindBuildPosition (t->def, pos, t->pos))
			{
				ai->metalmap.MarkSpot (msect, true);
				pos = t->pos;
//				logPrintf ("Estimated metal production of extractor: %f\n", def->extractsMetal * info->metalProduction);
				break;
			}
			ai->metalmap.MarkSpot (msect, true);// spill the metalspot as it seems it can't be used anyway
		}
	}
	else // it's a non-metal extractor
	{
		int2 sector = ai->map.RequestSafeBuildingSector (builderPos, aiConfig.safeSectorRadius, cd->IsBuilder () ? BLD_FACTORY : 1);

		if (sector.x < 0)
			return false;

		// find a position for the unit
		pos = float3(sector.x+0.5f,0.0f,sector.y+0.5f)*ai->map.mblocksize;
		if(!buildMap.FindBuildPosition (t->def, pos, t->pos))
			return false;

		pos = t->pos;
	}

	// Mark the unit on the buildmap
	buildMap.Mark (t->def, pos, true);

	return true;
}

void BuildHandler::InitiateTask (aiTask *task)
{
	BuildUnit *lead = 0;

	assert (!task->constructors.empty());
	assert (!task->lead);

	// Find a new lead builder
	for (int a=0;a<task->constructors.size();a++)
	{
		BuildUnit *b = task->constructors [a];
		if (task->constructors[a]->tasks.front () != task)
			continue;

		if (buildTable.UnitCanBuild (b->def, task->def))
		{
			lead = b;
			break;
		}
	}

	if (!lead)
	{
		for (int a=0;a<task->constructors.size();a++)
		{
			BuildUnit *u = task->constructors[a];
			task->DeleteDeathDependence (u);

			u->DependentDied (task);
			u->DeleteDeathDependence (task);
		}
		task->constructors.clear();
		task->buildSpeed = 0.0f;
		return;
	}

	float3 builderPos = ai->cb->GetUnitPos (lead->id);

	Command c;
	BuildTable::UDef* cd = buildTable.GetCachedDef (task->def->id);
	if (cd->IsBuilding())
	{
		if (!FindTaskBuildPos (task,lead))
			return;

		c.params.resize(3);
		c.params[0]=task->pos.x;
		c.params[1]=task->pos.y;
		c.params[2]=task->pos.z;

		MapInfo *i = ai->map.GetMapInfo (task->pos);
		if (i)i->buildstate += cd->IsBuilder () ? BLD_FACTORY : 1;

		if (aiConfig.debug)
			ai->cb->DrawUnit (task->def->name.c_str(), task->pos, 0.0f, 800, ai->cb->GetMyTeam(), true, true);
	} else
		task->pos = builderPos;

	c.id = -task->def->id;
	ai->cb->GiveOrder (lead->id, &c);
	task->lead = lead;
}


bool BuildHandler::AllocateForTask (aiTask *t)
{
	assert (!t->AreResourcesAllocated() && t->resourceType>=0);

	float required = ai->ResourceValue (t->def->energyCost, t->def->metalCost);
	float& reserve = taskResources [t->resourceType];

	if (reserve + required * (1.0f-RequiredAllocation) >= required) {
		reserve -= required;

		t->MarkAllocated ();
	}

	return t->AreResourcesAllocated ();
}


/* Orders new tasks until all resources have been allocated for the current task type */
void BuildHandler::BalanceResourceUsage (int type,float totalIncome)
{
	TaskHandler *h = ai->taskHandlers [type];

	aiTask *unalloc = 0;
	for (int a=0;a<tasks.size();a++) {
		if (tasks[a]->resourceType == type) {
			if (!tasks[a]->AreResourcesAllocated ())
			{
				unalloc = tasks[a];
				break;
			}
		}
	}

	if (unalloc) {
		AllocateForTask (unalloc);
	} else {
		if (h->activeTasks.size() >= config.MaxTasks [type])
			return;

        aiTask* task = h->GetNewTask ();
		if (task) {
			task->resourceType = type;
			if (!task->destHandler) task->destHandler = h;
			AddTask (task);
			AllocateForTask (task);
		} else {
			// give the resources to other handlers
			float spill = totalIncome * config.BuildWeights [type];

			float totalw = 0.0f;
			for (int a=0;a<NUM_TASK_TYPES;a++)
				if (a != type) totalw += config.BuildWeights [a];

            for (int a=0;a<NUM_TASK_TYPES;a++)
				if (a != type) taskResources [a] += spill * config.BuildWeights[a] / totalw;
		}
	}
}

void BuildHandler::TakeResources(float r)
{
	for (int a=0;a<NUM_TASK_TYPES;a++)
		taskResources[a] -= r * config.BuildWeights[a];
}


void BuildHandler::Update ()
{
	float totalBuildSpeed = 0.0f;
	totalBuildPower=ResourceInfo();

	// update average resource production
	const float weight = 0.005;
	ResourceInfo curIncome (ai->cb->GetEnergyIncome (), ai->cb->GetMetalIncome ());
	averageProd = averageProd * (1.0f - weight) + curIncome * weight;

	// update average resource usage
	const float weightU = 0.02;
	ResourceInfo curUsage = ResourceInfo(ai->cb->GetEnergyUsage (), ai->cb->GetMetalUsage ());
	averageUse = averageUse * (1.0f - weightU) + curUsage * weightU;

	// update per-type resource reserves
	float income = ai->ResourceValue (curIncome)/30.0f;
	for (int a=0;a<NUM_TASK_TYPES;a++)
		taskResources [a] += income * config.BuildWeights [a];

	// clear the current set of unit builds
	fill(currentUnitBuilds.begin(), currentUnitBuilds.end(), 0);

	// clear builder type counts
	fill(currentBuilders.begin(), currentBuilders.end(), 0);

	// update tasks and remove finished tasks
	int tIndex = 0;
	while (tIndex < tasks.size())
	{
		aiTask *t = tasks[tIndex];

		if (t->unit && t->unit->flags & UNIT_FINISHED)
		{
			FinishTask(t);
			continue;
		}

		if (t->IsBuilder()) // the build speed of the unfinished builders is also counted, 
		{	                // so the OrderNewBuilder() is stable
			totalBuildSpeed += t->def->buildSpeed;
		}
		currentUnitBuilds[t->def->id - 1] ++;
		tIndex ++;
	}

	// put all the empty builders in the inactive list
	for (ptrvec<BuildUnit>::iterator i = builders.begin();i != builders.end(); i++)
	{
		int nb = currentBuilders[i->def->id-1];

		totalBuildSpeed += i->def->buildSpeed;

		if (nb < 0) nb--;
		else nb++;

		if (i->tasks.empty())
		{
			inactive.push_back (&*i);
			if (nb > 0) nb=-nb;
		} 
		else {
			ResourceInfo res = i->GetResourceUse ();
			aiTask *t = i->tasks.front();

			totalBuildPower += res;
		}

		currentBuilders [i->def->id-1] = nb;
	}

	// just for safety
	if (totalBuildPower.metal > 0.0f && totalBuildPower.energy > 0.0f)
	{
		buildMultiplier.metal = averageProd.metal / totalBuildPower.metal;
		buildMultiplier.energy = averageProd.energy / totalBuildPower.energy;
	} else 
		buildMultiplier = ResourceInfo();

	if (!config.InitialOrders || !DoInitialBuildOrders ())
	{
		for (int type=0;type<NUM_TASK_TYPES;type++)
			BalanceResourceUsage (type, income);

		if (totalBuildSpeed < averageProd.metal * config.BuildSpeedPerMetalIncome)
			OrderNewBuilder ();
	}

	for (int a=0;a<tasks.size();a++)
	{
		// make sure tasks are either being executed or queued
		aiTask *t = tasks[a];

		if (t->depends || !t->constructors.empty() || !t->AreResourcesAllocated())
			continue;

		BuildUnit *inactiveBuilder = 0;
		const UnitDef* bestBuilder = FindBestBuilderType (t->def, &inactiveBuilder);

		if (inactiveBuilder)
		{
			SetBuilderToTask (inactiveBuilder, t);
			continue;
		}

		if (CanBuildUnit (t->def)) // unit will be build once the builder is free
			continue;

		if (bestBuilder) // no active builder either, a new builder has to be made
		{
			// see if this order for the new builder is already in the tasks,
			// in that case there is no need to build another one.
			if (currentUnitBuilds[bestBuilder->id-1])
				continue;

			aiTask *nb = AddTask (bestBuilder, t->resourceType);

			t->depends = nb;
			t->AddDeathDependence (nb);
		}
	}

	for (int a=0;a<builders.size();a++)
	{
		BuildUnit *u = builders[a];

		if (u->activeTask && u->activeTask->lead == u)
			CheckBuildError (u);

		if (!u->tasks.empty())
		{
			if (u->tasks.front()->AreResourcesAllocated() && u->activeTask != u->tasks.front())
				UpdateBuilderTask (u);
		}
	}

	// perform FindNewJob on inactive builders
	if (jobFinderIterator >= builders.size())
		jobFinderIterator = 0;

	int num = 1+builders.size()/8;
	for (;jobFinderIterator<builders.size() && num>0;jobFinderIterator++)
		if (builders[jobFinderIterator]->tasks.empty())
		{
			FindNewJob (builders[jobFinderIterator]);
			num--;
		}

	// inactive is not valid outside Update()
	inactive.clear ();
}


bool BuildHandler::DoInitialBuildOrders ()
{
    // initial build orders completed?
	assert (config.InitialOrders);

	if (initialBuildOrderTask)
		return true;

	for (int a=0;a<initialBuildOrderState.size();a++) {
		int &state = initialBuildOrderState[a];
		if (state < config.InitialOrders->builds[a]->count) {
			int type=-1;
			int id=config.InitialOrders->builds[a]->def;
			BuildTable::UDef *cd = buildTable.GetCachedDef(id);

			CfgList* info = config.InitialOrders->builds[a]->info;
			const char *handler = info ? info->GetLiteral ("Handler") : 0;
			if (handler) {
				for (int h=0;h<NUM_TASK_TYPES;h++) {
					if(!STRCASECMP(handler, handlerStr[h])) {
						type=h;
						break;
					}
				}
				
				if (h == BTF_Force) {
					ChatMsgPrintf (ai->cb, "Error: No force units possible in the initial build orders.\n");
					state=config.InitialOrders->builds[a]->count;
					return false;
				}
			} else {
				if(!cd->IsBuilder())  {
					ChatMsgPrintf (ai->cb, "Error in initial buildorder list: unit %s is not a builder\n", cd->name.c_str());
					state=config.InitialOrders->builds[a]->count;
					return false;
				}
			}

			aiTask *t = initialBuildOrderTask = AddTask (buildTable.GetDef(id), type);
			t->MarkAllocated ();
			state ++;

			return true;
		}
	}

	// all initial build tasks are done
	if (!initialBuildOrdersFinished) {
		ChatDebugPrintf (ai->cb,"Initial build orders finished.");

		DistributeResources ();
		initialBuildOrdersFinished=true;
	}
	return false;
}

// Check for a timeout in the task handling by the builder
// - Is the command actually in the unit's command que?
// - Does the builder move when it's not yet on the building location?
void BuildHandler::CheckBuildError (BuildUnit *builder)
{
	int frame = ai->cb->GetCurrentFrame();

	if (builder->lastErrorCheckFrame < frame - aiConfig.builderMoveTimeout)
	{
		float3 pos = ai->cb->GetUnitPos(builder->id);
		float dist = builder->activeTask->pos.distance2D (pos);
		
		builder->lastErrorCheckFrame = frame;

		const deque <Command> *cmdlist = ai->cb->GetCurrentUnitCommands (builder->id);

		deque<Command>::const_iterator i = cmdlist->begin();
		for (;i != cmdlist->end(); ++i)
			if (i->id == -builder->activeTask->def->id) break;

		if (i == cmdlist->end())
			goto Timeout;

		if (dist > builder->def->buildDistance * 2 + 50)
		{
			dist = pos.distance (builder->lastPos);
			builder->lastPos = pos;

			if (dist < aiConfig.builderMoveMinDistance)
				goto Timeout;
		}

		builder->lastPos = pos;
	}
	return;

Timeout:
	// Builder is not responding correctly, release it from this task
	logPrintf ("Builder %s timed out doing task %s\n", builder->def->name.c_str(),builder->activeTask->def->name.c_str());
	RemoveBuilderTask(builder, builder->activeTask);
}


aiUnit* BuildHandler::UnitCreated (int id)
{
	float bestDis;
	aiTask *best=0, *t;
	aiUnit *unit = 0;

	float3 pos = ai->cb->GetUnitPos (id);
	const UnitDef* def = ai->cb->GetUnitDef (id);

	for (int a=0;a<tasks.size();a++)
		if (!tasks[a]->unit && tasks[a]->lead && tasks[a]->def == def)
		{
			float d = pos.distance2D (tasks[a]->pos);
			if (!best || d < bestDis) {
				best = tasks[a];
				bestDis = d;
			}
		}

	if (!best || bestDis > 200)
	{
		// TODO: Find a way to deal with these outcasts...
		return new aiUnit;
	}

	t = best;
	if (t->IsBuilder())
	{
		BuildUnit *bu = new BuildUnit;
		bu->owner = this;
		t->unit = bu;
		bu->UpdateTimeout(ai->cb);

		t->unit = bu;
		logPrintf ("New builder created. %s\n", t->def->name.c_str());
		return bu;
	}

	assert (t->destHandler);
	unit = t->destHandler->CreateUnit (id);
	unit->owner = this;
	t->AddDeathDependence (unit);
	t->unit = unit;
	return unit;
}


void BuildHandler::UnitDestroyed (aiUnit *unit)
{
	if (unit->flags & UNIT_FINISHED)
	{
		BuildUnit *bu = dynamic_cast<BuildUnit*>(unit);

		logPrintf ("UnitDestroyed: Builder %s removed (%p)\n", unit->def->name.c_str(), unit);

		if (bu->activeTask)
		{
			if (bu->activeTask->lead == bu)
				RemoveUnitBlocking (bu->activeTask->def, bu->activeTask->pos);
		}

		assert(bu);
		builders.del (bu);
	} 
	else
	{
		assert (unit->owner);
		
		RemoveUnitBlocking (unit->def, ai->cb->GetUnitPos (unit->id));

		unit->owner->UnfinishedUnitDestroyed (unit);
		delete unit;
	}
}

void BuildHandler::FinishTask(aiTask *t)
{
	if (t->IsBuilder())
	{
		BuildUnit* bu = (BuildUnit *)t->unit;
		logPrintf  ("Builder %s finished: now %d builders\n",bu->def->name.c_str(), builders.size()+1);
		builders.add (bu);
	}
	else {
		t->unit->owner = t->destHandler;
		t->destHandler->UnitFinished (t->unit);
		logPrintf ("Task %s completed for %s\n", t->def->name.c_str(), t->destHandler->GetName ());
	}

	// make sure the assisting builders stop guarding the lead builder
	Command c;
	c.id=CMD_STOP;

	for (int a=0;a<t->constructors.size();a++)
	{
		BuildUnit *u = t->constructors [a];
		ai->cb->GiveOrder (u->id, &c);
	}

	if (t==initialBuildOrderTask)
		initialBuildOrderTask=0;

	tasks.del (t);
}

// -----------------------------------------
// BuildUnit
// -----------------------------------------


BuildUnit::BuildUnit()
{ 
	index=0; 
	activeTask = 0;
	lastErrorCheckFrame=0;
}

BuildUnit::~BuildUnit()
{}

void BuildUnit::UnitFinished ()
{}

void BuildUnit::DependentDied (aiObject *obj)
{
	if (obj == activeTask)
		activeTask = 0;

	vector<aiTask*>::iterator i = remove_if (tasks.begin(),tasks.end(), bind(equal_to<aiObject*>(), _1, obj));
	assert (i != tasks.end());
	tasks.erase (i, tasks.end());
}

ResourceInfo BuildUnit::GetResourceUse ()
{
	if (tasks.empty())
		return ResourceInfo (0.0f,0.0f);

	const UnitDef *constr = tasks.front()->def;

	float speed = def->buildSpeed / constr->buildTime;
	float metal = speed * constr->metalCost;
	float energy = speed * constr->energyCost;

	return ResourceInfo (energy, metal);
}

void BuildUnit::UpdateTimeout(IAICallback *cb)
{
	lastErrorCheckFrame = cb->GetCurrentFrame ();
	lastPos = cb->GetUnitPos (id);
}

// -----------------------------------------
// aiTask
// -----------------------------------------

aiTask::aiTask (const UnitDef* unitDef, aiHandler* dst)
{
	resourceType = -1;
	def = unitDef;
	unit = 0;
	destHandler = dst;
	flags = 0;
	depends = 0;
	pos.x = -1.0f;
	lead = 0;
	buildSpeed=0.0f;
}

void aiTask::DependentDied (aiObject *obj)
{
	if (obj == unit) 
		unit = 0;
	else if (obj == depends)
		depends = 0;
	else {
		if (obj == lead)
			lead = 0;

		vector<BuildUnit*>::iterator i = remove_if (constructors.begin(),constructors.end(), bind(equal_to<aiObject*>(), _1, obj));
		assert (i != constructors.end());
		constructors.erase (i, constructors.end());
	}
}

// -----------------------------------------
// TaskHandler
// -----------------------------------------

void TaskHandler::AddTask (aiTask *t)
{
	AddDeathDependence (t);
	activeTasks.push_back (t);
}

void TaskHandler::DependentDied (aiObject *obj)
{
	vector<aiTask*>::iterator i = remove_if (activeTasks.begin(),activeTasks.end(), bind(equal_to<aiObject*>(),_1,obj));
	assert(i != activeTasks.end());
	activeTasks.erase (i,activeTasks.end());
}
