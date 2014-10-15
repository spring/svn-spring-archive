#ifndef _OBJECT3DINSTANCE_H
#define _OBJECT3DINSTANCE_H

#include "IModelInstance.h"
#include "Object3D.h"
#include <vector>

class Object3DInstance;

class Object3DPiece: public IModelPiece
{
public:
	void Draw();
	void GetPiecePosIter(CMatrix44f* mat);
};

class Object3DInstance: public IModelInstance
{
public:
	~Object3DInstance();
	int numpieces;
	void Draw();
	bool PieceExists(int piecenum);
	float3 GetPiecePos(int piecenum);
	CMatrix44f GetPieceMatrix(int piecenum);
	float3 GetPieceDirection(int piecenum);
};

#endif /* _OBJECT3DINSTANCE_H */
