/*
 * IModelInstance.h
 * IModelInstance interface definition
 * Copyright (C) 2006 Christopher Han <xiphux@gmail.com>
 */
#ifndef _IMODELINSTANCE_H
#define _IMODELINSTANCE_H

#include <string>
#include "System/float3.h"
#include "System/Matrix44f.h"
#include "Sim/Units/COB/CobInstance.h"
#include "IModel.h"

class IModelPiece
{
public:
	std::string name;
	float3 offset;
	unsigned int displist;
	virtual void Draw() = 0;
	std::vector<IModelPiece*> childs;
	IModelPiece* parent;
	IModel *original;
	PieceInfo *anim;
	virtual void GetPiecePosIter(CMatrix44f* mat) = 0;
};

class IModelInstance
{
public:
	virtual void Draw() = 0;
	float3 offset;
	unsigned int displist;
	std::string name;
	virtual float3 GetPiecePos(int piecenum) = 0;
	virtual CMatrix44f GetPieceMatrix(int piecenum) = 0;
	virtual bool PieceExists(int piecenum) = 0;
	virtual float3 GetPieceDirection(int piecenum) = 0;
	int *scritoa;
	IModelPiece *pieces;
};

#endif /* _IMODELINSTANCE_H */
