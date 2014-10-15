//-------------------------------------------------------------------------
// JCAI version 0.20
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


bool BuildHandlerConfig::Load(CfgList *sidecfg)
{
	assert (NUM_TASK_TYPES == 4);
	const char *str[] = { "Resources", "Forces", "Defenses", "Recon" };
	float sum = 0.0f;
	CfgList *weights = dynamic_cast<CfgList*>(sidecfg->GetValue ("BuildWeights"));
	CfgList *maxtasks = dynamic_cast<CfgList*>(sidecfg->GetValue ("MaxTasks"));
	for (int a=0;a<NUM_TASK_TYPES;a++)
	{
		BuildWeights[a] = weights ? weights->GetNumeric (str[a], 1.0f) : 1.0f;
		MaxTasks[a] = maxtasks ? maxtasks->GetInt (str[a], 1) : 1;
		sum += BuildWeights[a];
	}
	for (int a=0;a<NUM_TASK_TYPES;a++) 
		BuildWeights[a] /= sum;

	logPrintf ("Building weights: Resources=%f, Forces=%f, Defenses=%f\n", 
		BuildWeights [0], BuildWeights[1], BuildWeights [2]);

	minAssistBuildTime = sidecfg->GetInt ("MinAssistBuildtime", 300);

	return true;
}


BuildHandler::BuildHandler (MainAI *pAI) : aiHandler(pAI)
{
	if (!config.Load (ai->sidecfg))
		throw "Failed to load build handler configuration";

	for (int a=0;a<NUM_TASK_TYPES;a++)
	{
		taskResources[a]=0.0f;
		buildWeights[a]=0.0f;
	}

	buildMap.Init (ai->cb, &ai->metalmap);
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
		DbgWndPrintf (wnd, 0, (i + 3) * 23, "%s: resources: %5.1f, weight: %1.3f", ai->taskHandlers[i]->GetName(), taskResources[i], buildWeights[i]);
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
}

void BuildHandler::InitBuilderTypes (const UnitDef* commdr)
{
	for (int a=0;a<buildTable.numDefs;a++)
	{
		BuildTable::UDef *d = &buildTable.deflist [a];

		// Builder?
		if (!d->IsBuilder())
			continue;

		// Can it be build directly or indirectly?
		BuildPathNode& bpn = buildTable.GetBuildPath (commdr->id, a);

		if (bpn.id >= 0)
			builderTypes.push_back (a + 1);
	}
}

BuildTask* BuildHandler::AddTask (const UnitDef* def,int type)
{
	BuildTask *t = new BuildTask (def, ai->taskHandlers[type]);
	t->resourceType = type;

	AddTask (t);
	return t;
}

void BuildHandler::AddTask (BuildTask *task)
{
	tasks.add(task);

	TaskHandler *rhd = ai->taskHandlers[task->resourceType];
	rhd->AddTask (task);

	if (buildTable.GetCachedDef (task->def->id)->IsBuilding ())
	{
		task->flags |= BT_BUILDING;
		
		if (task->pos.x >= 0.0f)
			buildMap.Mark (task->def,task->pos,true);
	}

	currentUnitBuilds[task->def->id-1] ++;

	ChatDebugPrintf (ai->cb, "Added task: %s (%s)", task->def->name.c_str(), rhd->GetName());
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

void BuildHandler::SetBuilderToTask (BuildUnit*builder, BuildTask *task)
{
	builder->tasks.push_back (task);
	builder->AddDeathDependence (task);

	task->constructors.push_back (builder);
	task->AddDeathDependence (builder);
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

void BuildHandler::RemoveBuilderTask (BuildUnit *builder, BuildTask *task)
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
}

/*
	float bestValue=0;
	int bestJob=0;

	if(!isFactory){		//mobile builder
		float3 myPos=aicb->GetUnitPos(unit);
		for(map<int,QuedBuilding*>::iterator qbi=quedBuildngs.begin();qbi!=quedBuildngs.end();++qbi){		//check for building to build
			QuedBuilding* qb=qbi->second;
			bool canBuildThis=info->possibleBuildOrders.find(qb->type)!=info->possibleBuildOrders.end();
			if(canBuildThis || !qb->unitsOnThis.empty()){			//can we build this directly or is there someone who can start if for us
				float buildTime=qb->buildTimeLeft/(qb->totalBuildSpeed+info->buildSpeed);
				float moveTime=max(0.01f,((qb->pos-myPos).Length()-150)/info->moveSpeed*10);
				float travelMod=buildTime/(buildTime+moveTime);			//units prefer stuff with low travel time compared to build time
				float finishMod=buildOptions[qb->type]->buildTime/(qb->buildTimeLeft+buildOptions[qb->type]->buildTime*0.1f);			//units prefer stuff that is nearly finished
				float canBuildThisMod=canBuildThis?1.5f:1;								//units prefer to do stuff they have in their build options (less risk of guarded unit dying etc)
				float ageMod=20+sqrtf((float)(frameNum+1)-qb->startFrame);
//				float buildSpeedMod=info->buildSpeed/(qb->totalBuildSpeed+info->buildSpeed);
				float value=finishMod*canBuildThisMod*travelMod*ageMod;
//				char c[80];
//				sprintf(c,"value %f %f",moveTime,buildTime);
//				aicb->SendTextMsg(c,0);
				if(value>bestValue){
					bestValue=value;
					if(!qb->unitsOnThis.empty())
						bestJob=-*qb->unitsOnThis.begin();				//negative number=pick a unit to guard
					else
						bestJob=qbi->first;				//positive number=do this build project
				}
			}
		}
		for(map<int,UnitInfo*>::iterator ui=myUnits.begin();ui!=myUnits.end();++ui){		//find factories to guard
			if(ui->second->moveSpeed==0 && !aicb->GetCurrentUnitCommands(ui->first)->empty()){
				float moveTime=max(1.0f,((aicb->GetUnitPos(ui->first)-myPos).Length()-150)/info->moveSpeed*2);
				float value=3.0f*(ui->second->buildSpeed/(ui->second->totalGuardSpeed+ui->second->buildSpeed))/moveTime;
				if(value>bestValue && ui->second->unitsGuardingMe.size()<5){
					bestValue=value;
					bestJob=-ui->first;
				}
			}
		}
		if(bestJob){										//we have found something to do
//			SendTxt("Best job found %i %i %.2f",unit,bestJob,bestValue);
			info->lastGivenOrder=bestJob;
			Command c;
			if(bestJob>0){		//build building
				QuedBuilding* qb=quedBuildngs[bestJob];
				c.id=qb->type;
				c.params.push_back(qb->pos.x);
				c.params.push_back(qb->pos.y);
				c.params.push_back(qb->pos.z);

				qb->totalBuildSpeed+=info->buildSpeed;
				qb->unitsOnThis.insert(unit);
			} else {		//guard unit
				c.id=CMD_GUARD;
				c.params.push_back((float)-bestJob);

				UnitInfo* guardInfo=myUnits[-bestJob];
				guardInfo->unitsGuardingMe.insert(unit);
				guardInfo->totalGuardSpeed+=info->buildSpeed;

				if(guardInfo->moveSpeed!=0){
					QuedBuilding* qb=quedBuildngs[guardInfo->lastGivenOrder];
					qb->totalBuildSpeed+=info->buildSpeed;
				}
			}
			aicb->GiveOrder(unit,&c);
		}
*/

void BuildHandler::UpdateTaskAssisting ()
{
	BuildUnit *ab = 0;
	float highestTL;

	// find the builder with the most time consuming set of tasks
	for (int a=0;a<builders.size();a++)
	{
		BuildUnit *b = builders[a];

		if (b->tasks.empty())
			continue;

		float tl = b->CalcBusyTime (ai->cb);

		if (b->tasks.front()->flags & BT_ASSIST)
			tl *= 0.1f;

		if (!ab || tl > highestTL)
		{
			ab = b;
			highestTL = tl;
		}
	}

	if (ab && highestTL > config.minAssistBuildTime)
	{
		// select a builder based on build speed and add it to the task
		BuildUnit *builder = FindInactiveAssistBuilder (ab->tasks.front());
		if (builder)
		{
			SetBuilderToTask (builder, ab->tasks.front());
			return;
		}
		else
		{
			OrderAssistBuilder (ab->tasks.front());
			return;
		}
	}
}

BuildUnit* BuildHandler::FindInactiveAssistBuilder (BuildTask *task)
{
	BuildUnit *best=0;

	for (int a=0;a<inactive.size();a++)
	{
		BuildUnit *b = inactive[a];

		if (!b->tasks.empty () || buildTable.GetCachedDef (b->def->id)->IsBuilding())
			continue;

		if (!best || best->def->buildSpeed < b->def->buildSpeed)
			best = b;
	}

	return best;
}

void BuildHandler::OrderAssistBuilder (BuildTask *task)
{
	float bestscore;
	UnitDefID best=-1;

	for (int a=0;a<builderTypes.size();a++)
	{
		BuildTable::UDef* ud = buildTable.GetCachedDef (builderTypes[a]);

		if (!ud->IsBuilder() || ud->IsBuilding())
			continue;

		// it's probably best to make builders that are currently used by other tasks as well
		// those have the highest chance of being reused
		float score = ud->buildSpeed * abs(currentBuilders[a]);

		if (best < 0 || score > bestscore)
		{
			best = builderTypes[a];
			bestscore = score;
		}
	}

	if (best >= 0 && !currentUnitBuilds [best-1])
	{
		BuildTask *t = AddTask (buildTable.GetDef (best), task->resourceType);

		t->MarkBuilder();
		t->flags |= BT_ASSIST;

		ai->taskHandlers [t->resourceType]->AddTask (t);

		ChatDebugPrintf (ai->cb, "Added task for assist builder: %s for task %s, handler: %s\n", 
			t->def->name.c_str(), task->def->name.c_str(), ai->taskHandlers [t->resourceType]->GetName ());
	}
}

BuildUnit* BuildHandler::FindBuilderForTask (const UnitDef *def)
{
	int best = -1;
	float best_score;

	for (int a=0;a<builders.size();a++)
	{
		BuildUnit *b = builders[a];

		if (!buildTable.UnitCanBuild (b->def, def))
			continue;

		BuildPathNode& node = buildTable.GetBuildPath (b->def, def);
		float currentTasksBuildtime = b->CalcBusyTime (ai->cb);

		float score = ai->ResourceValue (node.res.energy, node.res.metal) + node.res.buildtime + currentTasksBuildtime;
		if (best<0 || best_score > score)
		{
			best_score = score;
			best=a;
		}
	}

	
	return best>=0 ? builders[best] : 0;
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
	BuildTask *t = builder->activeTask = builder->tasks.front();

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

bool BuildHandler::FindTaskBuildPos (BuildTask *t, BuildUnit*lead)
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

void BuildHandler::InitiateTask (BuildTask *task)
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
		ChatMsgPrintf (ai->cb, "Error: No lead builder for task %s", task->def->name.c_str());
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
		if (i)
			i->buildstate += cd->IsBuilder () ? BLD_FACTORY : 1;

		if (aiConfig.debug)
			ai->cb->DrawUnit (task->def->name.c_str(), task->pos, 0.0f, 400, ai->cb->GetMyTeam(), true, true);
	}
	else
	{
		task->pos = builderPos;
	}

	c.id = -task->def->id;
	ai->cb->GiveOrder (lead->id, &c);
	task->lead = lead;
}


bool BuildHandler::AllocateForTask (BuildTask *t)
{
	assert (!t->AreResourcesAllocated());

	float required = ai->ResourceValue (t->def->energyCost, t->def->metalCost);
	float& reserve = taskResources [t->resourceType];

	if (reserve >= required) {
		reserve -= required;

		t->MarkAllocated ();
	}

	return t->AreResourcesAllocated ();
}


/* Orders new tasks until all resources have been allocated for the current task type */
void BuildHandler::BalanceResourceUsage (int type, const ResourceInfo& use, const ResourceInfo& real)
{
	TaskHandler *h = ai->taskHandlers [type];

	BuildTask *unalloc = 0;
	for (int a=0;a<tasks.size();a++)
		if (tasks[a]->resourceType == type) {
			if (!tasks[a]->AreResourcesAllocated ())
			{
				unalloc = tasks[a];
				break;
			}
		}

	if (unalloc)
		AllocateForTask (unalloc);
	else {
		if (h->activeTasks.size() >= config.MaxTasks [type])
			return;

        BuildTask* task = h->GetNewTask ();
		if (task)
		{
			task->resourceType = type;

			if (!task->destHandler)
				task->destHandler = h;

			AddTask (task);

			AllocateForTask (task);
		}
	}
}


void BuildHandler::Update ()
{
	ResourceInfo real, use[NUM_TASK_TYPES];
	totalBuildPower = real;

	// update average resource production
	const float weight = 0.005;
	ResourceInfo curIncome (ai->cb->GetEnergyIncome (), ai->cb->GetMetalIncome ());
	averageProd = averageProd * (1.0f - weight) + curIncome * weight;

	// update average resource usage
	const float weightU = 0.02;
	ResourceInfo curUsage = ResourceInfo(ai->cb->GetEnergyUsage (), ai->cb->GetMetalUsage ());
	averageUse = averageUse * (1.0f - weightU) + curUsage * weightU;

	// update per-type resource reserves
	float income = ai->ResourceValue (curIncome);
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
		BuildTask *t = tasks[tIndex];

		if (t->unit && t->unit->flags & UNIT_FINISHED)
		{
			FinishTask(t);
			continue;
		}

		t->currentUsage = ResourceInfo ();
		t->buildSpeed = 0.0f;

		currentUnitBuilds[t->def->id - 1] ++;
		tIndex ++;
	}

	// put all the empty builders in the inactive list
	for (ptrvec<BuildUnit>::iterator i = builders.begin();i != builders.end(); i++)
	{
		int nb = currentBuilders[i->def->id-1];

		if (nb < 0) nb--;
		else nb++;

		if (i->tasks.empty())
		{
			inactive.push_back (&*i);
			if (nb > 0) nb=-nb;
		} 
		else {
			ResourceInfo res = i->GetResourceUse ();
			BuildTask *t = i->tasks.front();

			assert (t->resourceType >= 0);
			use [t->resourceType] += res;
			t->currentUsage += res;
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

	for (int type=0;type<NUM_TASK_TYPES;type++)
	{
		buildWeights [type] = config.BuildWeights [type];
		BalanceResourceUsage (type, use[type], real);
	}

//	UpdateTaskAssisting ();

	for (int a=0;a<tasks.size();a++)
	{
		// make sure tasks are either being executed or queued
		BuildTask *t = tasks[a];

		if (t->depends || !t->constructors.empty())
			continue;

		BuildUnit *inactiveBuilder = 0;
		const UnitDef* bestBuilder = FindBestBuilderType (t->def, &inactiveBuilder);

		if (inactiveBuilder)
		{
			SetBuilderToTask (inactiveBuilder, t);
			continue;
		}

		BuildUnit *activeBuilder = FindBuilderForTask (t->def);
		if (activeBuilder)
		{
			SetBuilderToTask (activeBuilder, t);
			continue;
		}

		if (bestBuilder) // no active builder either, a new builder has to be made
		{
			// see if this order for the new builder is already in the tasks,
			// in that case there is no need to build another one.
			if (currentUnitBuilds[bestBuilder->id-1])
				continue;

			BuildTask *nb = AddTask (bestBuilder, t->resourceType);
			nb->MarkBuilder();

			t->depends = nb;
			t->AddDeathDependence (nb);

			ai->taskHandlers [t->resourceType]->AddTask (nb);
		}
	}

	for (int a=0;a<builders.size();a++)
	{
		BuildUnit *u = builders[a];

		if (u->activeTask && u->activeTask->lead == u)
			CheckBuildError (u);

		if (u->tasks.empty() || u->activeTask == u->tasks.front())
			continue;

		UpdateBuilderTask (u);
	}

	// inactive is not valid outside Update()
	inactive.clear ();
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
	BuildTask *best=0, *t;
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

void BuildHandler::FinishTask(BuildTask *t)
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

	Command c;
	c.id=CMD_STOP;

	for (int a=0;a<t->constructors.size();a++)
	{
		BuildUnit *u = t->constructors [a];
		ai->cb->GiveOrder (u->id, &c);
	}

	tasks.del (t);
}

// -----------------------------------------
// BuildUnit
// -----------------------------------------


BuildUnit::BuildUnit()
{ 
	index=0; 
	activeTask = 0;
}

BuildUnit::~BuildUnit()
{}

void BuildUnit::UnitFinished ()
{}

void BuildUnit::DependentDied (aiObject *obj)
{
	if (obj == activeTask)
		activeTask = 0;

	vector<BuildTask*>::iterator i = remove_if (tasks.begin(),tasks.end(), bind(equal_to<aiObject*>(), _1, obj));
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

#define TASK_SETUP_TIME 0

float BuildUnit::CalcBusyTime (IAICallback *cb)
{
	float t = 0.0f;

	for (int a=0;a<tasks.size();a++)
	{
		BuildTask *task = tasks[a];
		t += TASK_SETUP_TIME + task->TimeLeft (cb);
	}

	return t;
}


void BuildUnit::UpdateTimeout(IAICallback *cb)
{
	lastErrorCheckFrame = cb->GetCurrentFrame ();
	lastPos = cb->GetUnitPos (id);
}

// -----------------------------------------
// BuildTask
// -----------------------------------------

BuildTask::BuildTask (const UnitDef* unitDef, aiHandler* dst)
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

void BuildTask::DependentDied (aiObject *obj)
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

float BuildTask::TimeLeft (IAICallback *cb)
{
	float hp = unit ? cb->GetUnitHealth (unit->id) : 0.0f;
	float buildTime = (1.0f - hp / def->health) * def->buildTime;

	if (!buildSpeed) 
		UpdateBuildSpeed ();

	if (!buildSpeed)
		return -1.0f;

	return buildTime / buildSpeed;
}

void BuildTask::UpdateBuildSpeed ()
{
	buildSpeed = 0.0f;

	for (int a=0;a<constructors.size();a++)
		buildSpeed += constructors[a]->def->buildSpeed;
}

// -----------------------------------------
// TaskHandler
// -----------------------------------------

void TaskHandler::AddTask (BuildTask *t)
{
	AddDeathDependence (t);
	activeTasks.push_back (t);
}

void TaskHandler::DependentDied (aiObject *obj)
{
	vector<BuildTask*>::iterator i = remove_if (activeTasks.begin(),activeTasks.end(), bind(equal_to<aiObject*>(),_1,obj));
	assert(i != activeTasks.end());
	activeTasks.erase (i,activeTasks.end());
}
