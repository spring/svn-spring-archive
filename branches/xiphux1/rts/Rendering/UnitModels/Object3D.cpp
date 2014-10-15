/*
 * Object3D.cpp
 * Shared Object3D base implementation
 * Copyright (C) 2006 Christopher Han
 */
#include "Rendering/GL/myGL.h"
#include "Object3D.h"

void object3d::DrawStatic()
{
	glPushMatrix();
	glTranslatef(offset.x,offset.y,offset.z);
	glCallList(displist);
	for(unsigned int i=0; i<childs.size(); i++)
		childs[i]->DrawStatic();
	glPopMatrix();
}

object3d::~object3d()
{
	glDeleteLists(displist,1);
}
