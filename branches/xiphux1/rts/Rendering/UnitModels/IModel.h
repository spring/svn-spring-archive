/*
 * IModel.h
 * IModel interface definition
 * Copyright (C) 2006 Christopher Han <xiphux@gmail.com>
 */
#ifndef _IMODEL_H
#define _IMODEL_H

#include <string>
#include <vector>
#include "System/float3.h"

#define IMODEL_TYPE_3DO 0
#define IMODEL_TYPE_S3O 1

class vertex3d
{
public:
	float3 pos;
	float3 normal;
};

class IModel
{
public:
	virtual void DrawStatic() = 0;
	std::string name;
	float radius;
	float height;
	int farTextureNum;
	float maxx, maxy, maxz;
	float minx, miny, minz;
	float3 relMidPos;
	unsigned int imodel_type;
	std::vector<vertex3d> vertices;
	IModel *rootobject;
	unsigned int displist;
};

#endif /* _IMODEL_H */
