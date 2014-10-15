// TreeDrawer.h: interface for the CTreeDrawer class.
//
//////////////////////////////////////////////////////////////////////

#ifndef __BASIC_TREE_DRAWER_H__
#define __BASIC_TREE_DRAWER_H__

#include <map>
#include "BaseTreeDrawer.h"
#include "Map/BaseGroundDrawer.h"

#define MAX_TREE_HEIGHT 60

class CBasicTreeDrawer : public CBaseTreeDrawer
{
public:
	CBasicTreeDrawer();
	virtual ~CBasicTreeDrawer();

	void Draw(float treeDistance,bool drawReflection);
	void Update();
	void CreateTreeTex(unsigned int& texnum,unsigned char* data,int xsize,int ysize);
	void AddTree(int type, float3 pos, float size);
	void DeleteTree(float3 pos);

	unsigned int treetex;
	int lastListClean;

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
		VisibilityNode* visibilityNode;
		float3 viewVector;
		std::map<int,TreeStruct> trees;
		TreeSquareStruct() : displist(0), farDisplist(0), lastSeen(0), lastSeenFar(0), visibilityNode(0) {}
	};


	TreeSquareStruct* trees;
	int treesX;
	int treesY;
	std::vector<TreeSquareStruct*> squareDrawList;

	struct DrawCallback : public IVisibilityNodeDrawer {
		void Draw(VisibilityNode *node);
		CBasicTreeDrawer *me;
	} drawCallback;


	void ResetPos(const float3& pos);
};

#endif // __BASIC_TREE_DRAWER_H__
