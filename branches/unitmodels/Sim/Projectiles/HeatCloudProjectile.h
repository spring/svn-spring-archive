#ifndef HEATCLOUDPROJECTILE_H
#define HEATCLOUDPROJECTILE_H
// HeatCloudProjectile.h: interface for the CHeatCloudProjectile class.
//
//////////////////////////////////////////////////////////////////////

#include "Projectile.h"

class CHeatCloudProjectile : public CProjectile  
{
	CR_DECLARE(CHeatCloudProjectile);
public:
	virtual void Draw();
	virtual void Update();
	CHeatCloudProjectile();
	CHeatCloudProjectile(const float3 pos,const float3 speed,const float temperature,const float size, CUnit* owner);  //projectile start at size 0 and ends at size size
	virtual ~CHeatCloudProjectile();

	float heat;
	float maxheat;
	float heatFalloff;
	float size;
	float sizeGrowth;
	float sizemod;
	float sizemodmod;
};

#endif /* HEATCLOUDPROJECTILE_H */
