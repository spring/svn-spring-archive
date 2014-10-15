/*
 * ObjectS3O.h
 * S3O object definition
 * Copyright (C) 2006 Christopher Han
 */
#ifndef _OBJECTS3O_H
#define _OBJECTS3O_H

#include "Object3D.h"

class SS3OVertex: public vertex3d
{
public:
	float textureX;
	float textureY;
};

class SS3O: public object3d
{
public:
	SS3O() { imodel_type = IMODEL_TYPE_S3O; }
	std::vector<unsigned int> vertexDrawOrder;
	int primitiveType;
	~SS3O();
};

#endif /* _OBJECTS3O_H */
