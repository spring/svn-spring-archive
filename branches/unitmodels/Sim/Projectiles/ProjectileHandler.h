#ifndef PROJECTILEHANDLER_H
#define PROJECTILEHANDLER_H
// ProjectileHandler.h: interface for the CProjectileHandler class.
//
//////////////////////////////////////////////////////////////////////

#pragma warning(disable:4786)

class CProjectileHandler;
class CProjectile;

#include <list>
#include <vector>

#include <set>
#include <stack>
#include "MemPool.h"

typedef std::list<CProjectile*> Projectile_List;

class CGroundFlash;
class IFramebuffer;

class CProjectileHandler  
{
public:
	CProjectileHandler();
	virtual ~CProjectileHandler();

	void CheckUnitCol();
	void LoadSmoke(unsigned char tex[512][512][4],int xoffs,int yoffs,char* filename,char* alphafile);

	void Draw(bool drawReflection,bool drawRefraction=false);
	void UpdateTextures();
	void AddProjectile(CProjectile* p);
	void Update();
	void AddGroundFlash(CGroundFlash* flash);
	void DrawGroundFlashes(void);

	void ConvertTex(unsigned char tex[512][512][4], int startx, int starty, int endx, int endy, float absorb);
	void DrawShadowPass(void);
//	void AddFlyingPiece(float3 pos,float3 speed,C3DOPiece* object,C3DOPrimitive* piece);
//	void AddFlyingPiece(int textureType, int team, float3 pos, float3 speed, S3OVertex * verts);

	struct projdist{
		float dist;
		CProjectile* proj;
	};

	Projectile_List ps;

	std::vector<projdist> distlist;

	unsigned int projectileShadowVP;

	int maxParticles;					//different effects should start to cut down on unnececary(unsynced) particles when this number is reached
	int currentParticles;			//number of particles weighted by how complex they are
	float particleSaturation;	//currentParticles/maxParticles

	int numPerlinProjectiles;
private:
	void UpdatePerlin();
	void GenerateNoiseTex(unsigned int tex,int size);

	unsigned int perlinTex[8];
	float perlinBlend[4];
	IFramebuffer *perlinFB;
	bool drawPerlinTex;
	std::vector<CGroundFlash*> groundFlashes;
};
extern CProjectileHandler* ph;

#endif /* PROJECTILEHANDLER_H */
