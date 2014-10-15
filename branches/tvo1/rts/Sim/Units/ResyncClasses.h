#ifndef RESYNCCLASSES_H
#define RESYNCCLASSES_H

#include "Sim/MoveTypes/AirMoveType.h"
#include "Sim/MoveTypes/groundmovetype.h"
#include "Sim/MoveTypes/TAAirMoveType.h"
#include "Sim/Units/Unit.h"


static inline int makeChecksum(int i) { return i; }
static inline int makeChecksum(float f) { return *((int*)&f); }
static inline int makeChecksum(double f) { return *((int*)&f) ^ *(((int*)&f)+1); }
static inline int makeChecksum(const float3& vec) { return *((int*)&(vec.x)) ^ *((int*)&(vec.y)) ^ *((int*)&(vec.z)); }


struct float3_allowed_in_union {
	float3_allowed_in_union& operator=(const float3& vec) { x = vec.x; y = vec.y; z = vec.z; return *this; }
	operator float3() const { return float3(x, y, z); }
	float x, y, z;
};

#define float3 float3_allowed_in_union

//////////////////////////////////////////////////////////////////////
// CResyncTAAirMoveType declaration
//////////////////////////////////////////////////////////////////////

class CResyncTAAirMoveType {
public:
	void copyFromCTAAirMoveType(const CTAAirMoveType& u);
	void copyToCTAAirMoveType(CTAAirMoveType* u) const;
	static int getChecksum(const CTAAirMoveType* u);
private:
	float3 goalPos;
	float3 oldpos;
	float wantedHeight;
	float orgWantedHeight;
	float3 reservedLandingPos;
	float3 circlingPos;
	float goalDistance;
	float3 wantedSpeed;
	float currentBank;
	float currentPitch;
	float turnRate;
	float accRate;
	float decRate;
	float altitudeRate;
	float breakDistance;
	float maxDrift;
	float repairBelowHealth;
	float3 oldGoalPos;
};



//////////////////////////////////////////////////////////////////////
// CResyncAirMoveType declaration
//////////////////////////////////////////////////////////////////////

class CResyncAirMoveType {
public:
	void copyFromCAirMoveType(const CAirMoveType& u);
	void copyToCAirMoveType(CAirMoveType* u) const;
	static int getChecksum(const CAirMoveType* u);
private:
	float wingDrag;
	float wingAngle;
	float invDrag;
	float frontToSpeed;
	float speedToFront;
	float myGravity;
	float maxBank;
	float maxPitch;
	float maxSpeed;
	float turnRadius;
	float wantedHeight;
	float maxAcc;
	float maxAileron;
	float maxElevator;
	float maxRudder;
	float3 goalPos;
	float inSupply;
	float3 reservedLandingPos;
	float mySide;
	float crashAileron;
	float crashElevator;
	float crashRudder;
	float3 oldpos;
	float3 oldGoalPos;
	float3 oldSlowUpdatePos;
	struct RudderInfo{
		float rotation;
	};
	RudderInfo rudder;
	RudderInfo elevator;
	RudderInfo aileronRight;
	RudderInfo aileronLeft;
	float lastRudderUpdate;
	float lastRudderPos;
	float lastElevatorPos;
	float lastAileronPos;
	float inefficientAttackTime;
	float3 exitVector;
	float repairBelowHealth;
};



//////////////////////////////////////////////////////////////////////
// CResyncGroundMoveType declaration
//////////////////////////////////////////////////////////////////////

class CResyncGroundMoveType {
public:
	void copyFromCGroundMoveType(const CGroundMoveType& u);
	void copyToCGroundMoveType(CGroundMoveType* u) const;
	static int getChecksum(const CGroundMoveType* u);
private:
	float baseTurnRate;
	float turnRate;
	float accRate;
	float wantedSpeed;
	float currentSpeed;
	float deltaSpeed;
	float3 oldPos;
	float3 oldSlowUpdatePos;
	float3 flatFrontDir;
	float3 goal;
	float goalRadius;
	float3 waypoint;
	float3 nextWaypoint;
	float terrainSpeed;
	float requestedSpeed;
	float currentDistanceToWaypoint;
	float3 avoidanceVec;
	float3 lastGetPathPos;
	bool floatOnWater;
	float skidRotSpeed;
	float3 skidRotVector;
	float skidRotSpeed2;
	float skidRotPos2;
};



//////////////////////////////////////////////////////////////////////
// CResyncUnit declaration
//////////////////////////////////////////////////////////////////////

class CResyncUnit {
public:
	CResyncUnit(const CUnit& u);
	void copyToCUnit(CUnit* u) const;
	static int getChecksum(const CUnit* u);
	int getID() const { return id; }
private:
	int id;	// not float, but needed to know which unit it is
	float3 frontdir;
	float3 rightdir;
	float3 updir;
	float3 relMidPos;
	float power;
	float maxHealth;
	float health;
	float paralyzeDamage;
	float captureProgress;
	float experience;
	float limExperience;
	float logExperience;
	float buildProgress;
	float reloadSpeed;
	float maxRange;
	float lastMuzzleFlameSize;
	float3 lastMuzzleFlameDir;
	float losHeight;
	float metalUse;
	float energyUse;
	float metalMake;
	float energyMake;
	float metalUseI;
	float energyUseI;
	float metalMakeI;
	float energyMakeI;
	float metalUseold;
	float energyUseold;
	float metalMakeold;
	float energyMakeold;
	float energyTickMake;
	float metalExtract;
	float metalCost;
	float energyCost;
	float buildTime;
	float recentDamage;
	float3 userAttackPos;
	float3 bonusShieldDir;
	float bonusShieldSaved;
	float armoredMultiple;
	float curArmorMultiple;
	float3 posErrorVector;
	float3 posErrorDelta;
	union {
		CResyncAirMoveType airMoveType;
		CResyncTAAirMoveType taAirMoveType;
		CResyncGroundMoveType groundMoveType;
	};
};

#undef float3

#endif // RESYNCCLASSES_H
