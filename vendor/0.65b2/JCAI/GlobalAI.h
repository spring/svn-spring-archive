//-------------------------------------------------------------------------
// JCAI version 0.21
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#ifndef JC_GLOBAL_AI_H
#define JC_GLOBAL_AI_H

#include "InfoMap.h"
#include "MetalSpotMap.h"
#include "BuildTable.h"

const char AI_NAME[]="JCAI";

class AIConfig;
class MainAI;
class DbgWindow;
struct UnitDef;

class ForceHandler;
class BuildHandler;
class ResourceUnitHandler;
class SupportHandler;
class ReconHandler;

struct ReconConfig;
struct ForceConfig;

class CfgList;

class IAICheats;

class aiHandler;
struct aiUnit;

// renamed CObject from spring source - to prevent namespace collision
class aiObject
{
public:
	void DeleteDeathDependence(aiObject* o);
	void AddDeathDependence(aiObject* o);
	virtual void DependentDied(aiObject* o);
	inline aiObject(){};
	virtual ~aiObject();

	set<aiObject*> listeners,listening;
};

class aiHandler : public aiObject
{
public:
	aiHandler (MainAI *AI) { ai=AI; }

	virtual void Update () {}
	virtual void UnitDestroyed (aiUnit *unit) {}
	virtual void UnfinishedUnitDestroyed (aiUnit *unit) {}
	virtual void UnitFinished (aiUnit *unit) {}

	// should not register the unit - since it's not finished yet - this is done by dstHandler
	virtual aiUnit* CreateUnit (int id) {return 0;} 

	virtual const char *GetName () { return "aiHandler"; }

	MainAI *ai;
};

class BuildUnit;

enum BuildTaskType
{
	BTF_Resource = 0,
	BTF_Force	= 1,
	BTF_Defense	= 2,
	BTF_Recon	= 3
};

class aiTask;

class TaskHandler : public aiHandler
{
public:
	TaskHandler(MainAI *AI) : aiHandler(AI){}
	virtual aiTask* GetNewTask () = 0;

	// Automatically called by the build handler, no need to do it in GetNewTask()
	void DependentDied (aiObject *o);
	void AddTask (aiTask *t);

	vector<aiTask *> activeTasks;
};

#define UNIT_FINISHED	1
#define UNIT_ENABLED	2
#define UNIT_IDLE		4

struct aiUnit : public aiObject
{
public:
	aiUnit () { 
		def=0; 
		id=0; 
		owner=0; 
		flags=0;
	}

	virtual void UnitFinished () {}
    virtual aiUnit* CreateConstructedUnit (int id) { return 0; }

	void DependentDied (aiObject *o);

	const UnitDef *def;
	int id;
	aiHandler *owner;
	unsigned long flags;
};

class MainAI : public IGlobalAI  
{
public:
	MainAI(int aiID);
	virtual ~MainAI();

	void InitAI(IGlobalAICallback* callback, int team);

	void UnitCreated(int unit);									//called when a new unit is created on ai team
	void UnitFinished(int unit);								//called when an unit has finished building
	void UnitIdle(int unit);										//called when a unit go idle and is not assigned to any group
	void UnitDestroyed(int unit);								//called when a unit is destroyed
	void UnitDamaged(int damaged,int attacker,float damage,float3 dir);					//called when one of your units are damaged
	void UnitMoveFailed(int unit);

	void EnemyEnterLOS(int enemy);
	void EnemyLeaveLOS(int enemy);

	void EnemyEnterRadar(int enemy);						//called when an enemy enters radar coverage (not called if enemy go directly from not known -> los)
	void EnemyLeaveRadar(int enemy);						//called when an enemy leaves radar coverage (not called if enemy go directly from inlos -> now known)

	void GotChatMsg(const char* msg,int player);					//called when someone writes a chat msg

	void EnemyDestroyed (int enemy);

	// called every frame
	void Update();

	void InitUnit (aiUnit *u, int id);

	void AddHandler (aiHandler *handler);
	void RemoveHandler (aiHandler *handler);

	void Startup (int cmdr);

	void DumpBuildOrders ();
	float3 ClosestBuildSite(const UnitDef* unitdef,float3 pos,int minDist);
	void InitDebugWindow();

	static bool LoadCommonData(IGlobalAICallback *cb);
	static void FreeCommonData();

	float GetEnergyIncome () { return cb->GetEnergyIncome(); }
	float GetMetalIncome () { return cb->GetMetalIncome(); }
	
	int aiIndex;
	bool cfgLoaded, skip;
	IAICallback* cb;
	IGlobalAICallback* aicb;
	stdext::hash_map <int, aiUnit*> units;
	DbgWindow *dbgWindow;

	typedef stdext::hash_map <int, aiUnit*>::iterator UnitIterator;

	InfoMap map;
	MetalSpotMap metalmap;

	typedef set <aiHandler*> HandlerList;
	HandlerList handlers;

	TaskHandler* taskHandlers [NUM_TASK_TYPES]; // handlers that create tasks
	BuildHandler *buildHandler;
	ForceHandler *forceHandler;

	CfgList *sidecfg; // side specific info

	inline float ResourceValue (float energy, float metal)
	{
		return energy * 0.05f + metal;
	}

	inline float ResourceValue (const ResourceInfo& res)
	{
		return res.energy * 0.05f + res.metal;
	}
};


#endif
