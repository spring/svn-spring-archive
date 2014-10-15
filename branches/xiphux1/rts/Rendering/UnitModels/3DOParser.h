#ifndef _3DOPARSER_H
#define _3DOPARSER_H

#include "Object3DParser.h"
#include "Object3DO.h"
#include "Object3DInstance.h"
#include "System/FileSystem/FileHandler.h"
#include <set>

class C3DOParser: public Object3DParser
{
public:
	C3DOParser();
	IModel *LoadModel(std::string name, float scale = 1, int side = 1);
	Object3DInstance *CreateLocalModel(IModel *model, std::vector<struct PieceInfo> *pieces);
private:
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

	void FindCenter(S3DO* object);
	float FindRadius(S3DO* object,float3 offset);
	float FindHeight(S3DO* object,float3 offset);
	void CalcNormals(S3DO* o);

	float scaleFactor;

	void GetPrimitives(S3DO* obj,int pos,int num,vertex_vector* vv,int excludePrim,int side);
	void GetVertexes(_3DObject* o,S3DO* object);
	std::string GetText(int pos);
	bool ReadChild(int pos,S3DO* root,int side, int *numobj);
	void DrawSub(object3d* o);
	std::string C3DOParser::GetLine(CFileHandler& fh);
	void CreateLocalModel(object3d *model, Object3DInstance *lmodel, std::vector<struct PieceInfo> *pieces, int *piecenum);
	
	std::set<std::string> teamtex;

	int curOffset;
	unsigned char* fileBuf;
	void SimStreamRead(void* buf,int length);
};

#endif /* _3DOPARSER_H */
