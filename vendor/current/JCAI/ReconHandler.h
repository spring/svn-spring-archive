//-------------------------------------------------------------------------
// JCAI version 0.21
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#include "ptrvec.h"


struct ScoutSectorHeuristic
{
	// Higher score is better
	float DistanceFactor;
	float TimeFactor;
	float ThreatFactor;
	float SpreadFactor;
};


struct ReconConfig
{
	ReconConfig () { scouts=0; maxForce=0; updateInterval=0; }

	CfgBuildOptions *scouts; // scout units
	int updateInterval; // number of frames between recon updates
	int maxForce;
	ScoutSectorHeuristic searchHeuristic;
	float minMetal, minEnergy;

	bool Load (CfgList *rootcfg);
};

class ReconHandler : public TaskHandler
{
public:
	ReconHandler (MainAI *ai);
	~ReconHandler ();

	void Update ();
	void UnitDestroyed (aiUnit *unit);
	void UnitFinished (aiUnit *unit);

	float LargestTaskValue ();
	aiTask* GetNewTask ();

	const char *GetName () { return "Recon"; }
	aiUnit* CreateUnit (int id); 

	struct Unit : public aiUnit
	{
		Unit() { goal.x=-1; }
		~Unit();
		int index;
		int2 goal;
	};

	ptrvec<Unit> units;

	ReconConfig config;
};

