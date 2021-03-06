#include "StdAfx.h"
// MeleeWeapon.cpp: implementation of the CMeleeWeapon class.
//
//////////////////////////////////////////////////////////////////////

#include "MeleeWeapon.h"
#include "Sim/Units/Unit.h"
#include "Sound.h"
#include "mmgr.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMeleeWeapon::CMeleeWeapon(CUnit* owner)
: CWeapon(owner)
{
}

CMeleeWeapon::~CMeleeWeapon()
{

}

void CMeleeWeapon::Update()
{
	CWeapon::Update();

}

void CMeleeWeapon::Fire(void)
{
	if(targetType==Target_Unit){
		targetUnit->DoDamage(damages,owner,ZeroVector);
		if(fireSoundId)
			sound->PlaySample(fireSoundId,owner,fireSoundVolume);
	}
}
