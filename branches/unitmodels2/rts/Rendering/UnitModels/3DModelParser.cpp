#include "StdAfx.h"
#include "3DModelParser.h"
#include "3DOParser.h"
#include "s3oParser.h"
#include <algorithm>
#include <cctype>

C3DModelParser* modelParser=0;

int CModel::GetNumPieces ()
{
	return numobjects;
}

ModelPieceInfo* CModel::GetPieceInfo(int piece)
{
	return &pieceInfo[piece];
}


C3DModelParser::C3DModelParser(void)
{
	unit3doparser=new C3DOParser();
	units3oparser=new CS3OParser();
}

C3DModelParser::~C3DModelParser(void)
{
	delete unit3doparser;
	delete units3oparser;
}

CModel* C3DModelParser::Load3DO(string name,float scale,int side)
{
	CModel *mdl;
	StringToLowerInPlace(name);
	if(name.find(".s3o")!=string::npos)
		mdl = units3oparser->Load3DO(name,scale,side);
	else
		mdl = unit3doparser->Load3DO(name,scale,side);
	return mdl;
}

CModelInstance *C3DModelParser::CreateLocalModel(CModel *model, IModelAnimator *animator)
{
	CModelInstance *mi;
	if(model->rootobject3do)
		mi = unit3doparser->CreateLocalModel(model, animator);
	else
		mi = units3oparser->CreateLocalModel(model, animator);

	if (mi) mi->animator = animator;
	return mi;
}

void CModel::DrawStatic()
{
	if(rootobject3do)
		rootobject3do->DrawStatic();
	else
		rootobjects3o->DrawStatic();
}
