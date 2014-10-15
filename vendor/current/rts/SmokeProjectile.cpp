// SmokeProjectile.cpp: implementation of the CSmokeProjectile class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "SmokeProjectile.h"
#include "mygl.h"	
#include "projectilehandler.h"
#include "camera.h"
#include "vertexarray.h"
#include "ground.h"
#include "wind.h"
//#include "mmgr.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSmokeProjectile::CSmokeProjectile(const float3& pos,const float3& speed,float ttl,float startSize,float sizeExpansion, CUnit* owner, float color)
: CProjectile(pos,speed,owner),
	color(color),
	age(0),
	startSize(startSize),
	size(0),
	sizeExpansion(sizeExpansion)
{
	ageSpeed=1.0/ttl;
	checkCol=false;
	castShadow=true;

	PUSH_CODE_MODE;
	ENTER_MIXED;
	textureNum=gu->usRandFloat()*12;
	POP_CODE_MODE;

	if(pos.y-ground->GetApproximateHeight(pos.x,pos.z)>10)
		useAirLos=true;

	if(!owner)
		alwaysVisible=true;
}

CSmokeProjectile::~CSmokeProjectile()
{

}


void CSmokeProjectile::Update()
{
	pos+=speed;
	pos+=wind.curWind*age*0.05;
	age+=ageSpeed;
	size+=sizeExpansion;
	if(size<startSize)
		size+=(startSize-size)*0.2;
	drawRadius=size;
	if(age>1){
		age=1;
		deleteMe=true;
	}
}

void CSmokeProjectile::Draw()
{
	inArray=true;
	unsigned char col[4];
	const unsigned char alpha=(1-age)*255;
	col[0]=color*alpha;
	col[1]=color*alpha;
	col[2]=color*alpha;
	col[3]=alpha/*-alphaFalloff*gu->timeOffset*/;
	int frame=textureNum;
	float xmod=0.125+(float(int(frame%6)))/16;
	float ymod=(int(frame/6))/16.0;

	const float3 interPos(pos+speed*gu->timeOffset);
	const float interSize=size+sizeExpansion*gu->timeOffset;
	const float3 pos1 ((camera->right - camera->up) * interSize);
	const float3 pos2 ((camera->right + camera->up) * interSize);
	va->AddVertexTC(interPos-pos2,xmod,ymod,col);
	va->AddVertexTC(interPos+pos1,xmod+1.0/16,ymod,col);
	va->AddVertexTC(interPos+pos2,xmod+1.0/16,ymod+1.0/16,col);
	va->AddVertexTC(interPos-pos1,xmod,ymod+1.0/16,col);
}
