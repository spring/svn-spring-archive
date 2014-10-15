
#ifndef BASE_GROUND_DRAWER_H
#define BASE_GROUND_DRAWER_H

#include <vector>
#include "Rendering/Env/BaseTreeDrawer.h"
#include "float3.h"

struct VisibilityNode;

struct IVisibilityNodeDrawer
{
	virtual void Draw(VisibilityNode* node) = 0;
};

struct VisibilityNode
{
	bool isVisible;
	IVisibilityNodeDrawer *callback;
	void *userData;
};

class CBaseGroundDrawer
{
public:
	CBaseGroundDrawer(void);
	virtual ~CBaseGroundDrawer(void);

	virtual void Draw(bool drawWaterReflection=false,bool drawUnitReflection=false,unsigned int overrideVP=0)=0;
	virtual void DrawShadowPass(void);
	virtual void Update()=0;

	virtual void IncreaseDetail()=0;
	virtual void DecreaseDetail()=0;

	// Visibility of objects
	virtual VisibilityNode* RegisterVisibilityNode (const float3& pos, float range, IVisibilityNodeDrawer* cb)=0;
//	virtual VisibilityNode* MoveVisibilityNode (VisibilityNode *node); // the default just unregisters and registers again
	virtual void UnregisterVisibilityNode (VisibilityNode *node)=0;

	enum DrawMode
	{
		drawNormal,
		drawLos,
		drawMetal,
		drawHeight,
		drawPath
	};

protected:
	virtual void SetDrawMode(DrawMode dm);
public:
	// Everything that deals with drawing extra textures on top
	void DisableExtraTexture();
	void SetHeightTexture();
	void SetMetalTexture(unsigned char* tex,float* extractMap,unsigned char* pal,bool highRes);
	void SetPathMapTexture();
	void ToggleLosTexture();
	void ToggleRadarAndJammer();
	bool UpdateExtraTexture();
	bool DrawExtraTex() { return drawMode!=drawNormal; }

	void SetTexGen(float scalex,float scaley, float offsetx, float offsety);

	bool updateFov;
	bool drawRadarAndJammer;
	bool drawLineOfSight;

	int striptype;
	unsigned int infoTex;

	unsigned char* infoTexMem;
	bool highResInfoTex;
	bool highResInfoTexWanted;

	unsigned char* extraTex;
	unsigned char* extraTexPal;
	float* extractDepthMap;

	int updateTextureState;

	float infoTexAlpha;

	DrawMode drawMode;
};

#endif 

