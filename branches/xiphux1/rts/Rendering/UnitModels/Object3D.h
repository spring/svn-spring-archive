/*
 * Object3D.h
 * Shared Object3D base
 * Copyright (C) 2006 Christopher Han
 */
#ifndef _OBJECT3D_H
#define _OBJECT3D_H

#include "IModel.h"

class object3d: public IModel
{
public:
	object3d() {}
	int numobjects;
	std::vector<object3d*> childs;
	float3 offset;
	bool isEmpty;
	void DrawStatic();
	~object3d();
	int textureType;
};

#endif /* _OBJECT3D_H */
