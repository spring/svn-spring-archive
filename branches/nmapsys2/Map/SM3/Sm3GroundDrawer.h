
#include "Map/BaseGroundDrawer.h"
#include "terrain/TerrainBase.h"
#include "terrain/Terrain.h"
#include "Frustum.h"

class CSm3ReadMap;

class CSm3GroundDrawer : public CBaseGroundDrawer
{
public:
	CSm3GroundDrawer(CSm3ReadMap *map);
	~CSm3GroundDrawer();

	void Draw(bool drawWaterReflection,bool drawUnitReflection,unsigned int overrideVP);
	void DrawShadowPass(void);
	void Update();

	// Visibility of objects
	VisibilityNode *RegisterVisibilityNode (const float3& pos, float range, IVisibilityNodeDrawer* cb);
	void UnregisterVisibilityNode (VisibilityNode *visNode);

	void IncreaseDetail();
	void DecreaseDetail();

protected:
	void DrawObjects(bool drawWaterReflection,bool drawUnitReflection);

	CSm3ReadMap *map;

	terrain::Terrain *tr;
	terrain::RenderContext *rc, *shadowrc, *reflectrc;
	terrain::Camera cam, shadowCam, reflectCam;
	Frustum frustum;

	unsigned int groundShadowVP;
};

