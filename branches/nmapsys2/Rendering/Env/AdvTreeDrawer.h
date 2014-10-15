// TreeDrawer.h: interface for the CTreeDrawer class.
//
//////////////////////////////////////////////////////////////////////

#ifndef __ADV_TREE_DRAWER_H__
#define __ADV_TREE_DRAWER_H__

#include <map>
#include "BaseTreeDrawer.h"
#include "Map/BaseGroundDrawer.h"

struct VisibilityNode;
class CVertexArray;
class CGrassDrawer;

class CAdvTreeDrawer : public CBaseTreeDrawer
{
public:
	CAdvTreeDrawer();
	virtual ~CAdvTreeDrawer();

	void Draw(float treeDistance,bool drawReflection);
	void Update();
	void ResetPos(const float3& pos);
	void AddTree(int type, float3 pos, float size);
	void DeleteTree(float3 pos);
	int AddFallingTree(float3 pos, float3 dir, int type);
	void DrawGrass(void);
	void AddGrass(float3 pos);
	void RemoveGrass(int x, int z);
	void DrawShadowPass(void);

	int lastListClean;
	float oldTreeDistance;

	struct TreeStruct{
		float3 pos;
		int type;
	};

	struct TreeSquareStruct {
		unsigned int displist;
		unsigned int farDisplist;
		int lastSeen;
		int lastSeenFar;
		int x,y;
		float3 viewVector;
		VisibilityNode* visibilityNode;
		std::map<int,TreeStruct> trees;
	};

	TreeSquareStruct* trees;
	int treesX;
	int treesY;
	std::vector<TreeSquareStruct*> squareDrawList;

	struct DrawCallback : public IVisibilityNodeDrawer {
		void Draw(VisibilityNode *node);
		CAdvTreeDrawer *me;
	} drawCallback;

	CGrassDrawer* grassDrawer;

	struct FallingTree {
		int type;
		float3 pos;
		float3 dir;
		float speed;
		float fallPos;
	};

	std::list<FallingTree> fallingTrees;
};

#endif // __ADV_TREE_DRAWER_H__

