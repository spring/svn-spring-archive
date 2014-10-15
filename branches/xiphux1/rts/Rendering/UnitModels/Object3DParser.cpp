/*
 * Object3DParser.cpp
 * Base parser for all Object3D-derived parsers
 * Copyright (C) 2006 Christopher Han
 */
#include "Object3DParser.h"
#include "Rendering/GL/myGL.h"
#include "System/Syncify.h"
#include <string>
#include <map>

Object3DParser::~Object3DParser()
{
	std::map<std::string,object3d*>::iterator ui;
	for(ui=units.begin();ui!=units.end();++ui){
		DeleteObject(ui->second->rootobject);
		delete ui->second;
	}
}

void Object3DParser::DeleteObject(IModel *o)
{
	object3d *o2 = (object3d*)o;
	for (std::vector<object3d*>::iterator di = o2->childs.begin(); di != o2->childs.end(); di++) {
		DeleteObject(*di);
	}
	delete o;
}

void Object3DParser::CreateLists(object3d *o)
{
	o->displist=glGenLists(1);
	PUSH_CODE_MODE;
	ENTER_MIXED;
	glNewList(o->displist,GL_COMPILE);
	DrawSub(o);
	glEndList();
	POP_CODE_MODE;

	for(std::vector<object3d*>::iterator bs=o->childs.begin();bs!=o->childs.end();bs++){
		CreateLists(*bs);
	}
}
