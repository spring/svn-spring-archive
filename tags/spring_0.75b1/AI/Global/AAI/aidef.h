// AAI          alexander.seizinger@gmx.net	 
// 
// standard headers 


#include "ExternalAI/IAICheats.h"
#include "ExternalAI/IGlobalAI.h"
#include "ExternalAI/IGlobalAICallback.h"
#include "ExternalAI/IAICallback.h"
#include "ExternalAI/aibase.h"
#include "Sim/Units/UnitDef.h"
#include "Sim/MoveTypes/MoveInfo.h"
#include "GlobalStuff.h"
#include "Sim/Weapons/WeaponDefHandler.h"
#include "Sim/Weapons/Weapon.h"
#include "Sim/Units/CommandAI/CommandQueue.h"
#include "AAIConfig.h"
#include <set>
#include <list>
#include <vector>
#include <stdio.h>
#include <time.h>
#include <string>


#ifdef _MSC_VER
#pragma warning(disable: 4244 4018) // signed/unsigned and loss of precision...
#endif 

void ReplaceExtension (const char *n, char *dst,int s, const char *ext);

#ifndef AIDEF_H
#define AIDEF_H

#define AAI_VERSION "0.81"
#define MAP_FILE_VERSION "MAP_LEARN_0_80"
#define TABLE_FILE_VERSION "MOD_LEARN_0_80"
#define MAP_DATA_VERSION "MAP_DATA_0_60"

// all paths 
#define MAIN_PATH "AI/AAI/"
#define AILOG_PATH "log/"
#define MOD_CFG_PATH "cfg/mod/"
#define GENERAL_CFG_FILE "cfg/general.cfg"
#define MOD_LEARN_PATH "learn/mod/"
#define MAP_CFG_PATH "cfg/map/"
#define MAP_CACHE_PATH "cache/"
#define MAP_LEARN_PATH "learn/map/"


extern AAIConfig *cfg;

class AAIMetalSpot
{
public:
	AAIMetalSpot(float3 pos, float amount) {this->pos = pos; this->amount = amount; occupied = false; extractor = -1; extractor_def = -1;}
	AAIMetalSpot() {pos = ZeroVector; amount = 0; occupied = false; extractor = -1; extractor_def = -1;}
	
	float3 pos;
	bool occupied;
	int extractor;		// -1 if unocuppied
	int extractor_def;	// -1 if unocuppied
	float amount;
};

// movement types (for bitfield)
#define MOVE_TYPE_GROUND (unsigned int) 1
#define MOVE_TYPE_AIR (unsigned int) 2
#define MOVE_TYPE_HOVER (unsigned int) 4
#define MOVE_TYPE_SEA (unsigned int) 8
#define MOVE_TYPE_STATIC (unsigned int) 16
#define MOVE_TYPE_FLOATER (unsigned int) 32
#define MOVE_TYPE_UNDERWATER (unsigned int) 64
#define MOVE_TYPE_STATIC_LAND (unsigned int) 128
#define MOVE_TYPE_STATIC_WATER (unsigned int) 256


// unit types (for bitfield)
#define UNIT_TYPE_BUILDER (unsigned int) 1
#define UNIT_TYPE_FACTORY (unsigned int) 2
#define UNIT_TYPE_ASSISTER (unsigned int) 4
#define UNIT_TYPE_RESURRECTOR (unsigned int) 8
#define UNIT_TYPE_COMMANDER (unsigned int) 16
#define UNIT_TYPE_ASSAULT (unsigned int) 32
#define UNIT_TYPE_ANTI_AIR (unsigned int) 64
#define UNIT_TYPE_ARTY (unsigned int) 128
#define UNIT_TYPE_FIGHTER (unsigned int) 256
#define UNIT_TYPE_BOMBER (unsigned int) 512
#define UNIT_TYPE_GUNSHIP (unsigned int) 1024

enum Direction {WEST, EAST, SOUTH, NORTH, CENTER, NO_DIRECTION};

enum UnitMoveType {GROUND, AIR, HOVER,  SEA};

enum MapType {UNKNOWN_MAP, LAND_MAP, AIR_MAP, LAND_WATER_MAP, WATER_MAP};

enum SectorType {UNKNOWN_SECTOR, LAND_SECTOR, LAND_WATER_SECTOR, WATER_SECTOR};

enum UnitCategory {UNKNOWN, STATIONARY_DEF, STATIONARY_ARTY, STORAGE, STATIONARY_CONSTRUCTOR, AIR_BASE,
STATIONARY_RECON, STATIONARY_JAMMER, STATIONARY_LAUNCHER, DEFLECTION_SHIELD, POWER_PLANT, EXTRACTOR, METAL_MAKER, 
COMMANDER, GROUND_ASSAULT, AIR_ASSAULT, HOVER_ASSAULT, SEA_ASSAULT, SUBMARINE_ASSAULT, GROUND_ARTY, SEA_ARTY, HOVER_ARTY, GROUND_SCOUT, AIR_SCOUT, HOVER_SCOUT, 
SEA_SCOUT, MOBILE_JAMMER, MOBILE_LAUNCHER, MOBILE_CONSTRUCTOR}; 

enum GroupTask {GROUP_IDLE, GROUP_ATTACKING, GROUP_DEFENDING, GROUP_BOMBING, GROUP_RETREATING};

enum UnitType {UNKNOWN_UNIT, ASSAULT_UNIT, ANTI_AIR_UNIT, BOMBER_UNIT, ARTY_UNIT};

enum UnitTask {UNIT_IDLE, UNIT_ATTACKING, DEFENDING, GUARDING, MOVING, BUILDING, SCOUTING, ASSISTING, RECLAIMING, HEADING_TO_RALLYPOINT, UNIT_KILLED, ENEMY_UNIT};

enum AttackType {NO_ATTACK, BASE_ATTACK, OUTPOST_ATTACK};

enum BuildOrderStatus {BUILDORDER_FAILED, BUILDORDER_NOBUILDPOS, BUILDORDER_NOBUILDER, BUILDORDER_SUCCESFUL};

struct AAIDefence
{
	int unit_id;
	int def_id;
	Direction direction;
};

struct AAIAirTarget
{
	float3 pos;
	int def_id;
	float cost;
	float health;
	UnitCategory category;
};

struct UnitTypeDynamic
{
	int requested;			// how many units of that type have been requested
	int active;				// how many units of that type are currently alive
	int buildersAvailable;	// how many factories/builders available being able to build that unit
	int buildersRequested;	// how many factories/builders requested being able to build that unit
};

struct UnitTypeStatic
{
	int def_id;
	int side;				// 0 if side has not been set 
	list<int> canBuildList;
	list<int> builtByList;
	vector<float> efficiency;		// 0 -> ground assault, 1 -> air assault, 2 -> hover assault
							// 3 -> sea assault, 4 -> submarine , 5 -> stat. defences
	float range;
	float cost;
	float builder_cost;
	UnitCategory category;

	unsigned int unit_type;
	unsigned int movement_type;
};

class AAIGroup;
class AAIBuilder;
class AAIFactory;
class AAIConstructor;

struct AAIUnit
{
	int unit_id;
	int def_id;
	AAIGroup *group;
	AAIConstructor *cons;
	UnitTask status;
};


struct ProductionRequest
{
	int builder_id;		// id of that building/builder/mine layer etc.
	int built;			// how many facs/builder of that type have been build
	int requested;		// how many units/buildings need this fac. to be built
};

typedef unsigned char uchar;

#endif
