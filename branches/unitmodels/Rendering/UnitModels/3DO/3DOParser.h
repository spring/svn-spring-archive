// 3DOParser.h: interface for the C3DOParser class.
//
//////////////////////////////////////////////////////////////////////
#ifndef SPRING_3DOPARSER_H
#define SPRING_3DOPARSER_H

#pragma warning(disable:4786)

#include <vector>
#include <string>
#include "float3.h"
#include "Rendering/Textures/TextureHandler.h"
#include <map>
#include <set>
#include "../UnitModel.h"

class CMatrix44f;

class CFileHandler;
class C3DModel;

class C3DOVertex
{
public:
	float3 pos;
	float3 normal;
	std::vector<int> prims;
};

class C3DOPrimitive
{
public:
	std::vector<int> vertices;
	std::vector<float3> normals;		//normals per vertex
	float3 normal;
	int numVertex;
	CTextureHandler::UnitTexture* texture;
};

class C3DOPiece
{
public:
	std::string name;
	std::vector<C3DOPiece*> childs;
	std::vector<C3DOPrimitive> prims;
	std::vector<C3DOVertex> vertices;
	float3 offset;
	unsigned int displist;
	bool isEmpty;
	float radius;
	float3 relMidPos;
	float maxx,maxy,maxz;
	float minx,miny,minz;

	void DrawStatic();
	~C3DOPiece();
};

class C3DOModelInstance : public IModelInstance
{
public:
	C3DModel *model;
	std::vector<ModelInstancePiece> pieces; 

	ModelInstancePiece* GetPiece(int piece);
	int GetNumPieces();
	float3 GetPiecePos(int piece);
	float3 GetPieceDirection(int piece);
	void Draw() {}
	void DrawBeingBuilt() {}
};

class C3DOModel  : public IModel
{
public:
	C3DOPiece *rootobj;
	int numobjects;
	float radius;
	float height;
	string name;
	float maxx,maxy,maxz;
	float minx,miny,minz;
	float3 relMidPos;

	float GetHeight() {return height; }
	float GetRadius() { return radius; }
	void DrawStatic();
	float3 GetRelMidPos() { return relMidPos; }
	BBox GetBBox();
};

class C3DOParser : public IModelParser
{
	typedef struct _3DObject
	{
		int VersionSignature;
		int NumberOfVertices;
		int NumberOfPrimitives;
		int SelectionPrimitive;
		int XFromParent;
		int YFromParent;
		int ZFromParent;
		int OffsetToObjectName;
		int Always_0;
		int OffsetToVertexArray;
		int OffsetToPrimitiveArray;
		int OffsetToSiblingObject;
		int OffsetToChildObject;
	} _3DObject;

	typedef struct _Vertex
	{
		int x;
		int y;
		int z;
	} _Vertex;

	typedef struct _Primitive
	{
		int PaletteEntry;
		int NumberOfVertexIndexes;
		int Always_0;
		int OffsetToVertexIndexArray;
		int OffsetToTextureName;
		int Unknown_1;
		int Unknown_2;
		int Unknown_3;    
	} _Primitive;

	typedef std::vector<float3> vertex_vector;

public:
	CR_DECLARE(C3DOParser);

	C3DOParser();
	virtual ~C3DOParser();

	IModel* Load(std::string name);
	//C3DOModel* Load3DO(string name,float scale=1,int side=1);
	//LocalS3DOModel *CreateLocalModel(C3DOModel *model, vector<struct PieceInfo> *pieces);
	
private:
	void FindCenter(C3DOPiece* object);
	float FindRadius(C3DOPiece* object,float3 offset);
	float FindHeight(C3DOPiece* object,float3 offset);
	void CalcNormals(C3DOPiece* o);

	void DeleteS3DO(C3DOPiece* o);
	void CreateLists(C3DOPiece* o);
	float scaleFactor;

	void GetPrimitives(C3DOPiece* obj,int pos,int num,vertex_vector* vv,int excludePrim,int side);
	void GetVertexes(_3DObject* o,C3DOPiece* object);
	std::string GetText(int pos);
	bool ReadChild(int pos,C3DOPiece* root,int side, int *numobj);
	void DrawSub(C3DOPiece* o);
	string GetLine(CFileHandler& fh);

	set<string> teamtex;

	int curOffset;
	unsigned char* fileBuf;
	void SimStreamRead(void* buf,int length);
};

#endif // SPRING_3DOPARSER_H
