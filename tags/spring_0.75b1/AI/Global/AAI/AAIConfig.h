#pragma once

#include "ExternalAI/IAICallback.h"
#include <stdio.h>
#include <list>

class AAI;

class AAIConfig
{
public:
	AAIConfig(void);
	~AAIConfig(void);

	void LoadConfig(AAI *ai);

	bool initialized;
 
	// constants (will be loaded in aaiconfig)

	// mod specific
	float SECTOR_SIZE;
	int MIN_ENERGY;  // min energy make value to be considered beeing a power plant 
	int MAX_UNITS;
	int MAX_SCOUTS;
	int MAX_XROW;
	int MAX_YROW;
	int X_SPACE;
	int Y_SPACE;
	int MAX_GROUP_SIZE;
	int MAX_AIR_GROUP_SIZE;
	int MAX_SUBMARINE_GROUP_SIZE;
	int MAX_NAVAL_GROUP_SIZE;
	int MAX_ANTI_AIR_GROUP_SIZE;
	int MAX_ARTY_GROUP_SIZE;
	float MIN_EFFICIENCY;
	int MAX_BUILDERS;
	int MAX_BUILDERS_PER_TYPE; // max builders of same unit type
	int MAX_FACTORIES_PER_TYPE;
	int MAX_BUILDQUE_SIZE;
	int MAX_ASSISTANTS;
	int MIN_ASSISTANCE_BUILDTIME;
	int MIN_ASSISTANCE_BUILDSPEED;
	int MAX_BASE_SIZE;
	float SCOUT_SPEED;
	float GROUND_ARTY_RANGE;
	float SEA_ARTY_RANGE;
	float HOVER_ARTY_RANGE;
	float STATIONARY_ARTY_RANGE;
	int AIR_DEFENCE;
	int AIRCRAFT_RATE;
	int HIGH_RANGE_UNITS_RATE;
	int FAST_UNITS_RATE;
	int SIDES;			
	int MIN_ENERGY_STORAGE;
	int MIN_METAL_STORAGE;
	int MAX_METAL_COST;
	int MIN_AIR_ATTACK_COST;
	int MAX_AIR_TARGETS;
	char **START_UNITS;
	char **SIDE_NAMES;
	list<int> SCOUTS;
	float METAL_ENERGY_RATIO;
	int MAX_DEFENCES;
	float MIN_SECTOR_THREAT;
	int MAX_STAT_ARTY;
	int MAX_AIR_BASE;
	bool AIR_ONLY_MOD;
	int MAX_STORAGE; 
	int MAX_METAL_MAKERS;
	int MAX_MEX_DISTANCE;
	int MAX_MEX_DEFENCE_DISTANCE;
	int MAX_MEX_DEFENCE_COST;
	float MIN_METAL_MAKER_ENERGY;
	int MIN_FACTORIES_FOR_DEFENCES;
	int MIN_FACTORIES_FOR_STORAGE;
	int MIN_FACTORIES_FOR_RADAR_JAMMER;
	float MIN_AIR_SUPPORT_EFFICIENCY;
	int UNIT_SPEED_SUBGROUPS;
	float MAX_COST_LIGHT_ASSAULT;
	float MAX_COST_MEDIUM_ASSAULT;
	float MAX_COST_HEAVY_ASSAULT;
	float LIGHT_ASSAULT_RATIO;
	float MEDIUM_ASSAULT_RATIO;
	float HEAVY_ASSAULT_RATIO;
	float SUPER_HEAVY_ASSAULT_RATIO;
	int MIN_SUBMARINE_WATERLINE;
	int MAX_ATTACKS;

	// internal
	float CLIFF_SLOPE;  // cells with greater slope will be considered to be cliffs
	int CONSTRUCTION_TIMEOUT;
	int MAX_SECTOR_IMPORTANCE;

	// game specific
	int SCOUT_UPDATE_FREQUENCY;
	float LEARN_SPEED;
	int LEARN_RATE;
	float WATER_MAP_RATIO;
	float LAND_WATER_MAP_RATIO;
};
