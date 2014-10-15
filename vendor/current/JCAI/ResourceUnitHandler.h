//-------------------------------------------------------------------------
// JCAI version 0.21
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#include "ptrvec.h"

class CfgBuildOptions;

// Resource units are units that produce energy/metal
class ResourceUnit : public aiUnit
{
public:
	ResourceUnit() {index=0; turnedOn=true;}

	bool turnedOn;
	int index;
};

class ExtractorUnit : public ResourceUnit
{
public:
	int2 mexSpot;
};

struct RUHandlerConfig
{
	RUHandlerConfig() { EnergyBuildRatio=MetalBuildRatio=0.0f; }

	bool Load (CfgList *sidecfg);

	float EnergyBuildRatio;
	float MetalBuildRatio;

	struct EnergyBuildHeuristicConfig
	{
		float EnergyCost,MetalCost,BuildTime;
		float MaxUpscale;

		void Load (CfgList *c);
	} EnergyHeuristic;

	struct MetalBuildHeuristicConfig
	{
		float PaybackTimeFactor;
		float EnergyUsageFactor;
		float ThreatConversionFactor;
		float PrefUpscale;
		float UpscaleOvershootFactor;

		void Load (CfgList *c);
	} MetalHeuristic;

	// Metal production enable policy, based on the metal maker AI
	struct {
		float MinUnitEnergyUsage;
		float MinEnergy;
		float MaxEnergy;
	} EnablePolicy;

	struct {
		vector <int> MetalStorage;
		vector <int> EnergyStorage;
		float MaxRatio;
		float MinMetalIncome;
		float MinEnergyIncome;
		float MaxEnergyFactor;
		float MaxMetalFactor;
	} StorageConfig;

	vector <int> EnergyMakers;
	vector <int> MetalMakers;
	vector <int> MetalExtracters;
};

class ResourceUnitHandler : public TaskHandler
{
public:
	ResourceUnitHandler(MainAI *ai);

	void UnitDestroyed (aiUnit *unit);
	void UnitFinished (aiUnit *unit);

	aiUnit* CreateUnit (int id); // should not register the unit - since it's not finished yet
	aiTask* GetNewTask ();

	const char *GetName();
	void Update ();

protected:
	ptrvec <ResourceUnit> units;
	int lastUpdate;
	float lastEnergy;

	friend class BuildHandler;

	RUHandlerConfig config;

	aiTask* CreateStorageTask (UnitDefID id);
	aiTask* CreateMetalExtractorTask (const UnitDef *def);
};

