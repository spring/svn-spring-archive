#ifndef _S3OPARSER_H
#define _S3OPARSER_H

#include "Object3DParser.h"
#include "ObjectS3O.h"

class CS3OParser: public Object3DParser
{
public:
	CS3OParser() {};
	IModel *LoadModel(std::string name, float scale = 1, int side = 1);
	Object3DInstance *CreateLocalModel(IModel *model, std::vector<struct PieceInfo> *pieces);
private:
	SS3O* LoadPiece(unsigned char* buf, int offset,object3d* model);
	void FindMinMax(SS3O *object);
	void DrawSub(object3d* o);
	void CreateLocalModel(object3d *model, Object3DInstance *lmodel, std::vector<struct PieceInfo> *pieces, int *piecenum);
};

#endif /* _S3OPARSER_H */
