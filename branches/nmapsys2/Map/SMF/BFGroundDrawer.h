// BFGroundDrawer.h
///////////////////////////////////////////////////////////////////////////

#ifndef __BF_GROUND_DRAWER_H__
#define __BF_GROUND_DRAWER_H__

#include "Map/BaseGroundDrawer.h"

class CVertexArray;
class CSmfReadMap;
class CBFGroundTextures;


/**
Map drawer implementation for the CSmfReadMap map system.
*/
class CBFGroundDrawer :
	public CBaseGroundDrawer
{
public:
	CBFGroundDrawer(CSmfReadMap *rm);
	~CBFGroundDrawer(void);
	void Draw(bool drawWaterReflection=false,bool drawUnitReflection=false,unsigned int overrideVP=0);

	// Visibility of objects
	VisibilityNode* RegisterVisibilityNode (const float3& pos, float range, IVisibilityNodeDrawer* cb);
	void MoveVisisibilityNode (VisibilityNode *node);
	void UnregisterVisibilityNode (VisibilityNode *node); // it is assumed that all nodes are unregistered (leakfree)

	void IncreaseDetail();
	void DecreaseDetail();
protected:
	struct NodeLayer;
	struct VisNode : public VisibilityNode
	{
		NodeLayer *layer;
		int2 layerPos; // position on layer
	};
	struct NodeLayer
	{
		std::vector<VisNode*>* nodes;
		int size;
		int w,h;
		float maxdist;
	};
#define NUM_VIS_LAYERS 3
	NodeLayer layers[NUM_VIS_LAYERS];
	void InitVisNodeLayers();

	CSmfReadMap *map;
	CBFGroundTextures *textures;
	int viewRadius;

	int numBigTexX;
	int numBigTexY;

	float* heightData;
	int heightDataX;

	CVertexArray* va;

	struct fline {
		float base;
		float dir;
	};
	std::vector<fline> right,left;

	friend class CSmfReadMap;

	unsigned int groundVP;
	unsigned int groundShadowVP;
	unsigned int groundFPShadow;

	inline void DrawVertexA(int x,int y);
	inline void DrawVertexA(int x,int y,float height);
	inline void EndStrip();
	void DrawGroundVertexArray();
	void SetupTextureUnits(bool drawReflection,unsigned int overrideVP);
	void ResetTextureUnits(bool drawReflection,unsigned int overrideVP);

	void AddFrustumRestraint(float3 side);
	void UpdateCamRestraints();
	void Update();
	void CalcLayerVisibility (NodeLayer *layer);
public:
	void DrawShadowPass();
};

#endif // __BF_GROUND_DRAWER_H__
