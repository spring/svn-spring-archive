#ifndef SPRING_3DMODELPARSER_H
#define SPRING_3DMODELPARSER_H

#include <vector>
#include <string>
#include "Matrix44f.h"

class IModelAnimator;
struct S3DO;
struct SS3O;
class C3DOParser;
class CS3OParser;

struct ModelPieceInfo
{
	std::string name;
	int parent;
	float3 offset;
};

class CModel
{
public:
	S3DO* rootobject3do;
	SS3O* rootobjects3o;
	int numobjects;
	float radius;
	float height;
	std::string name;
	int farTextureNum;
	float maxx,maxy,maxz;
	float minx,miny,minz;
	float3 relMidPos;
	int textureType;		//0=3do, otherwise s3o

	std::vector<ModelPieceInfo> pieceInfo;
	void DrawStatic();

	// Nodes/Pieces/Bones
	int GetNumPieces();
	ModelPieceInfo* GetPieceInfo(int piece);
};

struct CobPieceInfo;

struct LocalS3DO
{
	float3 offset;
	unsigned int displist;
	std::string name;
	std::vector<LocalS3DO*> childs;
	LocalS3DO *parent;
	S3DO *original3do;
	SS3O *originals3o;
	int pieceIndex;

	void Draw(IModelAnimator *animator); // if animator=0, offset is used for drawing the a static model
};

struct CModelInstance
{
	int numpieces;
	//LocalS3DO *rootobject;
	LocalS3DO *pieces;
	IModelAnimator *animator;

	CModelInstance() {pieces=0; animator=0; numpieces=0; }
	~CModelInstance();
	void Draw();
	float3 GetPiecePos(int piecenum);
	CMatrix44f GetPieceMatrix(int piecenum);
	float3 GetPieceDirection(int piecenum);
};

class C3DModelParser
{
public:
	C3DModelParser(void);
	~C3DModelParser(void);

	CModel* Load3DO(std::string name,float scale=1,int side=1);
	CModelInstance *CreateLocalModel(CModel *model, IModelAnimator *animator);

	C3DOParser* unit3doparser;
	CS3OParser* units3oparser;
};

extern C3DModelParser* modelParser;

#endif /* SPRING_3DMODELPARSER_H */
