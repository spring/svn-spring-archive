#ifndef __FLAME_PROJECTILE_H__
#define __FLAME_PROJECTILE_H__

#include "WeaponProjectile.h"
#include "Sim/Misc/DamageArray.h"

class CFlameProjectile :
	public CWeaponProjectile
{
public:
	CFlameProjectile(const float3& color,const float3& color2, float intensity,const float3& pos,const float3& speed,const float3& spread,CUnit* owner,const DamageArray& damages, WeaponDef *weaponDef, int ttl=50);
	~CFlameProjectile(void);
	float3 color;
	float3 color2;
	float intensity;
	float3 spread;
	float curTime;
	float invttl;
	void Update(void);
	void Draw(void);
	void Collision(CUnit* unit);
	void Collision(void);
	int ShieldRepulse(CPlasmaRepulser* shield,float3 shieldPos, float shieldForce, float shieldMaxSpeed);
};

#endif // __FLAME_PROJECTILE_H__
