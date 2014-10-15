//-------------------------------------------------------------------------
// JCAI version 0.21
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#include "ptrvec.h"
#include "BuildMap.h"

class BuildUnit;
class aiTask;

class DbgWindow;

class ResourceUnitHandler;

/*
resources avaiable:
	see if there is a task with buildtime > maxbuildtime:
		add a builder
		no builder? -> build a builder
			no builders to build the builder? -> task goes into queue
	else
	{
		adding a task:
			find a builder that can perform the task with the lowest buildtime
			no builder?
				search all active builders and put in in the task list for that particular active builder
	}
*/

#define BT_BUILDER 1	// should this be added to the buildhandler?
#define BT_ASSIST 2		// is this an assist builder
#define BT_BUILDING 4
#define BT_ALLOCATED 8	// resources for this task have been allocated

class aiTask : public aiObject
{
public:
	aiTask(const UnitDef* unitDef=0, aiHandler* dst=0);

	void DependentDied (aiObject *obj);
	float TimeLeft (IAICallback*cb);
	void UpdateBuildSpeed ();
	// Order them to guard
	void UpdateAssistBuilders (IAICallback *cb);

	// Inline Helpers
	bool IsBuilder() { return (flags&BT_BUILDER)!=0; }
	void MarkBuilder() { flags |= BT_BUILDER; }
	bool IsBuilding() { return (flags&BT_BUILDING)!=0; }
	bool AreResourcesAllocated() { return (flags&BT_ALLOCATED)!=0; }
	void MarkAllocated() { flags |= BT_ALLOCATED; }

	int resourceType;
	const UnitDef *def;
	aiUnit *unit;// the unit that is being constructed
	BuildUnit *lead; // lead builder
	aiHandler* destHandler; // the unit can be registered by another handler than the one creating the task
	float buildSpeed;
	int index; // index for ptrvec
	int flags;
	aiTask *depends; // depends task will be executed before this will
	float3 pos;
	int startFrame; // frame of when the task was added

	vector <BuildUnit *> constructors;
};


// a unit that can build stuff
class BuildUnit : public aiUnit
{
public:
	BuildUnit();
	~BuildUnit();

	void DependentDied (aiObject *obj);
	void UnitFinished ();
	ResourceInfo GetResourceUse ();
	float CalcBusyTime (IAICallback *cb);
	void UpdateTimeout (IAICallback *cb);

	vector <aiTask *> tasks;
	int index;

	float3 lastPos;
	int lastErrorCheckFrame;
	aiTask *activeTask;
};

struct BuildHandlerConfig
{
	bool Load (CfgList *sidecfg);

	float BuildWeights[NUM_TASK_TYPES];
	int MaxTasks[NUM_TASK_TYPES];
	float BuildSpeedPerMetalIncome;
	CfgBuildOptions *InitialOrders;
};

// Handles all building tasks
class BuildHandler : public aiHandler
{
public:
	BuildHandler (MainAI *ai);
	~BuildHandler ();

	void Init (int id);
	void InitBuilderTypes (const UnitDef *commanderDef);

	void Update ();

	void AddTask (aiTask *t);
	aiTask * AddTask (const UnitDef* def, int type);

	aiUnit* UnitCreated (int id);

	void BalanceResourceUsage (int type,float totalIncome);
	void StopBuilder (BuildUnit *b);
	BuildUnit* FindInactiveBuilderForTask (const UnitDef *def);
	const UnitDef* FindBestBuilderType (const UnitDef* constr, BuildUnit**builder);
	bool CanBuildUnit(const UnitDef* def);
	aiUnit* CreateConstructedUnit (BuildUnit* builder, int id);
	void FinishTask (aiTask *task);
	bool CalcSafeBuildPos (const UnitDef* def, float3& pos, const float3& builderPos, bool isFactory);

	void CheckBuildError (BuildUnit *builder);
	void SetBuilderToTask (BuildUnit *builder, aiTask *t);
	void InitiateTask (aiTask *t);
	void RemoveBuilderTask (BuildUnit *builder, aiTask *task);
	// Make sure the builder is actually doing it's task
	void UpdateBuilderTask (BuildUnit *builder);
	bool FindTaskBuildPos (aiTask *t, BuildUnit *lead);
	void RemoveUnitBlocking (const UnitDef* def, const float3& pos); // called to clean the buildmap and (possible) metal spot
	bool AllocateForTask (aiTask* t); // allocates the resources required for this task
	void BalanceBuildSpeed (float totalBuildSpeed);
	void FindNewJob (BuildUnit *u);
	void OrderNewBuilder ();
	void TakeResources (float v);
	void DistributeResources ();

	bool DoInitialBuildOrders ();
	void InitialBuildOrderFinished (int defID);

	void ShowDebugInfo (DbgWindow *wnd);

	void UnitDestroyed (aiUnit *unit);

	const char* GetName() { return "BuildHandler"; }

	ptrvec<aiTask> tasks;
	ptrvec<BuildUnit> builders;

	// stores inactive builders during Update() - empty when not updating
	vector <BuildUnit *> inactive;
	// builder counts mapped to builder types
	vector <int> currentBuilders;
	vector <int> currentUnitBuilds;

	// precomputed list of builder types for this side
	vector <int> builderTypes;

	ResourceInfo totalBuildPower;
	ResourceInfo buildMultiplier;

	ResourceInfo averageProd, averageUse;

	// What reserves are avaiable per task type?
	float taskResources [NUM_TASK_TYPES];

	BuildHandlerConfig config;
	BuildMap buildMap;

	vector<int> initialBuildOrderState;
	bool initialBuildOrdersFinished;
	aiTask *initialBuildOrderTask;

	int jobFinderIterator;
};


