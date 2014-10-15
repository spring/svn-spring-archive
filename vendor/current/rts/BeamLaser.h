#pragma once
#include "weapon.h"

class CBeamLaser :
	public CWeapon
{
public:
	CBeamLaser(CUnit* owner);
	~CBeamLaser(void);

	void Update(void);
	bool TryTarget(const float3& pos,bool userTarget,CUnit* unit);

	void Init(void);
	void Fire(void);

	float3 color;
	float3 oldDir;
};
