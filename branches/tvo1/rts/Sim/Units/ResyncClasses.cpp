#include "ResyncClasses.h"


#if 0

Most part of this file was generated and hand edited afterwards
scripts follows:

(for f in `find rts -iname *[a-z]movetype.h`; do ./header_to_member_list.sh "$f"; done) > rts/Sim/Units/ResyncClasses.h

with ./header_to_member_list.sh being:

#!/bin/sh
# Figure out name of the MoveType class
classname=`grep class $1 | grep MoveType | sed "s/class//g;s/://g;s/[ \t]//g;s/^C//g"`
echo "$classname"
# Do some pregeneration
cat $1 | grep -v "std::" | grep -v "<" | grep -v ">" | grep -v "(" | grep -v ")" | grep "float" > temp
cat temp | sed "s|^[ \t]*|\t|g;s|[ \t]*//[^\n]*||g" | grep float > temp2
# Output the class declaration
echo "//////////////////////////////////////////////////////////////////////"
echo "// CResync$classname declaration"
echo "//////////////////////////////////////////////////////////////////////"
echo ""
echo "class CResync$classname {"
echo "public:"
echo "  CResync$classname(const C$classname& u);"
echo "  void copyToC$classname(C$classname* u) const;"
echo "  static int getChecksum(const C$classname* u);"
echo "private:"
cat temp2
echo "};"
# Output the class implementation
echo "//////////////////////////////////////////////////////////////////////"
echo "// CResync$classname implementation"
echo "//////////////////////////////////////////////////////////////////////"
# Output the defines
echo "#define FOR_EACH \\"
cat temp2 | sed "s/^[ \t]*float.[ ]*/\tFOR_ONE(/g; s/;[^\n]*/) \\\/g"
echo ""
# Output the copy ctor
echo "CResync$classname::CResync$classname(const C$classname& u)"
echo "{"
echo "#define FOR_ONE(m) m = u.m;"
echo "  FOR_EACH"
echo "#undef FOR_ONE"
echo "};"
echo ""
# Output the copyTo function
echo "void CResync$classname::copyToC$classname(C$classname* u) const"
echo "{"
echo "#define FOR_ONE(m) u->m = m;"
echo "  FOR_EACH"
echo "#undef FOR_ONE"
echo "}"
echo ""
# Output the getChecksum function
echo "int CResync$classname::getChecksum(const C$classname* u)"
echo "{"
echo "  int checksum = 0;"
echo "#define FOR_ONE(m) checksum ^= makeChecksum(u->m);"
echo "  FOR_EACH"
echo "#undef FOR_ONE"
echo "  return checksum;"
echo "}"
echo ""
echo "#undef FOR_EACH"
echo ""

#endif


//////////////////////////////////////////////////////////////////////
// CResyncUnit implementation
//////////////////////////////////////////////////////////////////////

// made with: cat temp |sed "s/^[ \t]*float.[ ]*/FOR_ONE(/g; s/;[^\n]*/) \\\/g"
// where temp contains copy of all members of CResyncUnit
#define FOR_EACH \
	FOR_ONE(id) \
	FOR_ONE(frontdir) \
	FOR_ONE(rightdir) \
	FOR_ONE(updir) \
	FOR_ONE(relMidPos) \
	FOR_ONE(power) \
	FOR_ONE(maxHealth) \
	FOR_ONE(health) \
	FOR_ONE(paralyzeDamage) \
	FOR_ONE(captureProgress) \
	FOR_ONE(experience) \
	FOR_ONE(limExperience) \
	FOR_ONE(logExperience) \
	FOR_ONE(buildProgress) \
	FOR_ONE(reloadSpeed) \
	FOR_ONE(maxRange) \
	FOR_ONE(lastMuzzleFlameSize) \
	FOR_ONE(lastMuzzleFlameDir) \
	FOR_ONE(losHeight) \
	FOR_ONE(metalUse) \
	FOR_ONE(energyUse) \
	FOR_ONE(metalMake) \
	FOR_ONE(energyMake) \
	FOR_ONE(metalUseI) \
	FOR_ONE(energyUseI) \
	FOR_ONE(metalMakeI) \
	FOR_ONE(energyMakeI) \
	FOR_ONE(metalUseold) \
	FOR_ONE(energyUseold) \
	FOR_ONE(metalMakeold) \
	FOR_ONE(energyMakeold) \
	FOR_ONE(energyTickMake) \
	FOR_ONE(metalExtract) \
	FOR_ONE(metalCost) \
	FOR_ONE(energyCost) \
	FOR_ONE(buildTime) \
	FOR_ONE(recentDamage) \
	FOR_ONE(userAttackPos) \
	FOR_ONE(bonusShieldDir) \
	FOR_ONE(bonusShieldSaved) \
	FOR_ONE(armoredMultiple) \
	FOR_ONE(curArmorMultiple) \
	FOR_ONE(posErrorVector) \
	FOR_ONE(posErrorDelta)

CResyncUnit::CResyncUnit(const CUnit& u)
{
#define FOR_ONE(m) m = u.m;
	FOR_EACH
#undef FOR_ONE
	// Pick the right MoveType and store that in the union.
	CAirMoveType* air = dynamic_cast<CAirMoveType*>(u.moveType);
	CTAAirMoveType* taair = dynamic_cast<CTAAirMoveType*>(u.moveType);
	CGroundMoveType* ground = dynamic_cast<CGroundMoveType*>(u.moveType);
	if (air) airMoveType.copyFromCAirMoveType(*air);
	else if (taair) taAirMoveType.copyFromCTAAirMoveType(*taair);
	else if (ground) groundMoveType.copyFromCGroundMoveType(*ground);
};

void CResyncUnit::copyToCUnit(CUnit* u) const
{
#define FOR_ONE(m) u->m = m;
	FOR_EACH
#undef FOR_ONE
	// Pick the right MoveType from the union and copy it to the unit's MoveType.
	CAirMoveType* air = dynamic_cast<CAirMoveType*>(u->moveType);
	CTAAirMoveType* taair = dynamic_cast<CTAAirMoveType*>(u->moveType);
	CGroundMoveType* ground = dynamic_cast<CGroundMoveType*>(u->moveType);
	if (air) airMoveType.copyToCAirMoveType(air);
	else if (taair) taAirMoveType.copyToCTAAirMoveType(taair);
	else if (ground) groundMoveType.copyToCGroundMoveType(ground);
}

int CResyncUnit::getChecksum(const CUnit* u)
{
	int checksum = 0;
#define FOR_ONE(m) checksum ^= makeChecksum(u->m);
	FOR_EACH
#undef FOR_ONE
	return checksum;
}

#undef FOR_EACH



//////////////////////////////////////////////////////////////////////
// CResyncTAAirMoveType implementation
//////////////////////////////////////////////////////////////////////
#define FOR_EACH \
	FOR_ONE(goalPos) \
	FOR_ONE(oldpos) \
	FOR_ONE(wantedHeight) \
	FOR_ONE(orgWantedHeight) \
	FOR_ONE(reservedLandingPos) \
	FOR_ONE(circlingPos) \
	FOR_ONE(goalDistance) \
	FOR_ONE(wantedSpeed) \
	FOR_ONE(currentBank) \
	FOR_ONE(currentPitch) \
	FOR_ONE(turnRate) \
	FOR_ONE(accRate) \
	FOR_ONE(decRate) \
	FOR_ONE(altitudeRate) \
	FOR_ONE(breakDistance) \
	FOR_ONE(maxDrift) \
	FOR_ONE(repairBelowHealth) \
	FOR_ONE(oldGoalPos) \

void CResyncTAAirMoveType::copyFromCTAAirMoveType(const CTAAirMoveType& u)
{
#define FOR_ONE(m) m = u.m;
	FOR_EACH
#undef FOR_ONE
};

void CResyncTAAirMoveType::copyToCTAAirMoveType(CTAAirMoveType* u) const
{
#define FOR_ONE(m) u->m = m;
	FOR_EACH
#undef FOR_ONE
}

int CResyncTAAirMoveType::getChecksum(const CTAAirMoveType* u)
{
	int checksum = 0;
#define FOR_ONE(m) checksum ^= makeChecksum(u->m);
	FOR_EACH
#undef FOR_ONE
	return checksum;
}

#undef FOR_EACH



//////////////////////////////////////////////////////////////////////
// CResyncAirMoveType implementation
//////////////////////////////////////////////////////////////////////
#define FOR_EACH \
	FOR_ONE(wingDrag) \
	FOR_ONE(wingAngle) \
	FOR_ONE(invDrag) \
	FOR_ONE(frontToSpeed) \
	FOR_ONE(speedToFront) \
	FOR_ONE(myGravity) \
	FOR_ONE(maxBank) \
	FOR_ONE(maxPitch) \
	FOR_ONE(maxSpeed) \
	FOR_ONE(turnRadius) \
	FOR_ONE(wantedHeight) \
	FOR_ONE(maxAcc) \
	FOR_ONE(maxAileron) \
	FOR_ONE(maxElevator) \
	FOR_ONE(maxRudder) \
	FOR_ONE(goalPos) \
	FOR_ONE(inSupply) \
	FOR_ONE(reservedLandingPos) \
	FOR_ONE(mySide) \
	FOR_ONE(crashAileron) \
	FOR_ONE(crashElevator) \
	FOR_ONE(crashRudder) \
	FOR_ONE(oldpos) \
	FOR_ONE(oldGoalPos) \
	FOR_ONE(oldSlowUpdatePos) \
	FOR_ONE(rudder.rotation) \
	FOR_ONE(elevator.rotation) \
	FOR_ONE(aileronRight.rotation) \
	FOR_ONE(aileronLeft.rotation) \
	FOR_ONE(lastRudderUpdate) \
	FOR_ONE(lastRudderPos) \
	FOR_ONE(lastElevatorPos) \
	FOR_ONE(lastAileronPos) \
	FOR_ONE(inefficientAttackTime) \
	FOR_ONE(exitVector) \
	FOR_ONE(repairBelowHealth) \

void CResyncAirMoveType::copyFromCAirMoveType(const CAirMoveType& u)
{
#define FOR_ONE(m) m = u.m;
	FOR_EACH
#undef FOR_ONE
};

void CResyncAirMoveType::copyToCAirMoveType(CAirMoveType* u) const
{
#define FOR_ONE(m) u->m = m;
	FOR_EACH
#undef FOR_ONE
}

int CResyncAirMoveType::getChecksum(const CAirMoveType* u)
{
	int checksum = 0;
#define FOR_ONE(m) checksum ^= makeChecksum(u->m);
	FOR_EACH
#undef FOR_ONE
	return checksum;
}

#undef FOR_EACH



//////////////////////////////////////////////////////////////////////
// CResyncGroundMoveType implementation
//////////////////////////////////////////////////////////////////////
#define FOR_EACH \
	FOR_ONE(baseTurnRate) \
	FOR_ONE(turnRate) \
	FOR_ONE(accRate) \
	FOR_ONE(wantedSpeed) \
	FOR_ONE(currentSpeed) \
	FOR_ONE(deltaSpeed) \
	FOR_ONE(oldPos) \
	FOR_ONE(oldSlowUpdatePos) \
	FOR_ONE(flatFrontDir) \
	FOR_ONE(goal) \
	FOR_ONE(goalRadius) \
	FOR_ONE(waypoint) \
	FOR_ONE(nextWaypoint) \
	FOR_ONE(terrainSpeed) \
	FOR_ONE(requestedSpeed) \
	FOR_ONE(currentDistanceToWaypoint) \
	FOR_ONE(avoidanceVec) \
	FOR_ONE(lastGetPathPos) \
	FOR_ONE(skidRotSpeed) \
	FOR_ONE(skidRotVector) \
	FOR_ONE(skidRotSpeed2) \
	FOR_ONE(skidRotPos2) \

void CResyncGroundMoveType::copyFromCGroundMoveType(const CGroundMoveType& u)
{
#define FOR_ONE(m) m = u.m;
	FOR_EACH
#undef FOR_ONE
};

void CResyncGroundMoveType::copyToCGroundMoveType(CGroundMoveType* u) const
{
#define FOR_ONE(m) u->m = m;
	FOR_EACH
#undef FOR_ONE
}

int CResyncGroundMoveType::getChecksum(const CGroundMoveType* u)
{
	int checksum = 0;
#define FOR_ONE(m) checksum ^= makeChecksum(u->m);
	FOR_EACH
#undef FOR_ONE
	return checksum;
}

#undef FOR_EACH
