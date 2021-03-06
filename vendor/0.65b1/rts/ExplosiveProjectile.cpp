#include "stdafx.h"
// ExplosiveProjectile.cpp: implementation of the CExplosiveProjectile class.
//
//////////////////////////////////////////////////////////////////////

#include "ExplosiveProjectile.h"
#include "gamehelper.h"
#include "unit.h"
#include "synctracer.h"
#include "ground.h"
#include ".\explosiveprojectile.h"
#include "mygl.h"
#include "camera.h"
#include "vertexarray.h"
#include "weapondefhandler.h"
#include "intercepthandler.h"
//#include "mmgr.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CExplosiveProjectile::CExplosiveProjectile(const float3& pos,const float3& speed,CUnit* owner,const DamageArray& damages, WeaponDef *weaponDef, int ttl,float areaOfEffect)
: CWeaponProjectile(pos,speed,owner, 0,ZeroVector,weaponDef,0),
	damages(damages),
	ttl(ttl),
	areaOfEffect(areaOfEffect)
{
	useAirLos=true;

	SetRadius(0.05f);
	drawRadius=2+min(damages[0]*0.0025,weaponDef->areaOfEffect*0.1);

	interceptHandler.AddPlasma(this);
#ifdef TRACE_SYNC
	tracefile << "New explosive: ";
	tracefile << pos.x << " " << pos.y << " " << pos.z << " " << speed.x << " " << speed.y << " " << speed.z << "\n";
#endif
}

CExplosiveProjectile::~CExplosiveProjectile()
{

}

void CExplosiveProjectile::Update()
{	
	pos+=speed;
	speed.y+=gs->gravity;

	if(!--ttl)
		Collision();
}

void CExplosiveProjectile::Collision()
{
	float h=ground->GetHeight2(pos.x,pos.z);
	if(h>pos.y){
		float3 n=ground->GetNormal(pos.x,pos.z);
		pos-=speed*max(0.0f,min(1.0f,float((h-pos.y)*n.y/n.dot(speed)+0.1)));
	}
//	helper->Explosion(pos,damages,areaOfEffect,owner);
	CWeaponProjectile::Collision();
}

void CExplosiveProjectile::Collision(CUnit *unit)
{
//	unit->DoDamage(damages,owner);
//	helper->Explosion(pos,damages,areaOfEffect,owner);

	CWeaponProjectile::Collision(unit);
}

void CExplosiveProjectile::Draw(void)
{
	if(isUnitPart)	//dont draw if a 3d model has been defined for us
		return;

	inArray=true;
	unsigned char col[4];

	float3 dir=speed;
	dir.Normalize();

	for(int a=0;a<5;++a){
		col[0]=(5-a)*51;
		col[1]=(5-a)*25;
		col[2]=0;
		col[3]=(5-a)*10;
		float3 interPos=pos+speed*gu->timeOffset-dir*drawRadius*0.6*a;
		va->AddVertexTC(interPos-camera->right*drawRadius-camera->up*drawRadius,0,0,col);
		va->AddVertexTC(interPos+camera->right*drawRadius-camera->up*drawRadius,0.125,0,col);
		va->AddVertexTC(interPos+camera->right*drawRadius+camera->up*drawRadius,0.125,0.125,col);
		va->AddVertexTC(interPos-camera->right*drawRadius+camera->up*drawRadius,0,0.125,col);
	}
}
