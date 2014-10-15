#ifndef S3OPARSER_H
#define S3OPARSER_H

#include <map>

#include "Rendering/UnitModels/UnitModel.h"

struct S3OPiece;

struct S3OVertex {
	float3 pos;
	float3 normal;
	float textureX;
	float textureY;
};

struct S3OPiece
{
	std::string name;
	std::vector<S3OPiece*> childs;
	std::vector<S3OVertex> vertices;
	std::vector<unsigned int> vertexDrawOrder;
	float3 offset;
	int primitiveType;
	unsigned int displist;
	bool isEmpty;
	float maxx,maxy,maxz;
	float minx,miny,minz;

	void DrawStatic();
	~S3OPiece();
};


class CS3OModel : public IModel
{
public:
	S3OPiece *rootobj;
	int numobjects;
	float radius;
	float height;
	string name;
	float maxx,maxy,maxz;
	float minx,miny,minz;
	float3 relMidPos;
	int textureType;		//0=3do, otherwise s3o

	void DrawStatic();
	BBox GetBBox();
	float GetHeight() { return height; }
	float GetRadius() { return radius; }
	float3 GetRelMidPos() { return relMidPos; }
};

class CS3OModelType : public IModelParser
{
public:
	CR_DECLARE(CS3OModelType);

	CS3OModelType();
	~CS3OModelType();

	IModel* Load(std::string name);
	std::string GetExtension() { return "s3o"; }

private:
	S3OPiece* LoadPiece(unsigned char* buf, int offset,C3DOModel* model);
	void DeleteCS3OModel(S3OPiece* o);
	void FindMinMax(S3OPiece *object);
	void DrawSub(S3OPiece* o);
	void CreateLists(S3OPiece *o);
	void CreateLocalModel(S3OPiece *model, LocalS3DOModel *lmodel, vector<struct PieceInfo> *pieces, int *piecenum);
};

#endif /* S3OPARSER_H */
