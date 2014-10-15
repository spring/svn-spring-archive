/*
 * Object3DParser.h
 * Base parser for all Object3D-derived parsers
 * Copyright (C) 2006 Christopher Han
 */
#ifndef _OBJECT3DPARSER_H
#define _OBJECT3DPARSER_H

#include "IModel.h"
#include "IModelInstance.h"
#include "Object3D.h"
#include "Object3DInstance.h"
#include <string>
#include <vector>
#include <map>

class Object3DParser
{
public:
	~Object3DParser();
	virtual IModel* LoadModel(std::string name, float scale = 1, int team = 1) = 0;
	void DeleteObject(IModel *o);
protected:
	virtual void DrawSub(object3d *o) = 0;
	void CreateLists(object3d *o);
	void CreateLocalModel(object3d *model, Object3DInstance *lmodel, std::vector<struct PieceInfo> *pieces, int *piecenum);
	std::map<std::string,object3d*> units;
};

#endif /* _OBJECT3DPARSER_H */
