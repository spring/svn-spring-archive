#include "StdAfx.h"
#include "3DModelParser.h"
#include <algorithm>
#include <cctype>

C3DModelParser* modelParser=0;

C3DModelParser::C3DModelParser(void)
{
	units3oparser = new CS3OParser();
	unit3doparser = new C3DOParser();
}

C3DModelParser::~C3DModelParser(void)
{
	delete units3oparser;
	delete unit3doparser;
}

unsigned int C3DModelParser::identify_modeltype(std::string name)
{
	std::transform(name.begin(), name.end(), name.begin(), (int (*)(int))std::tolower);
	if(name.find(".s3o")!=string::npos)
		return IMODEL_TYPE_S3O;
	else
		return IMODEL_TYPE_3DO;
}

IModel* C3DModelParser::LoadModel(string name,float scale,int side)
{
	if(identify_modeltype(name) == IMODEL_TYPE_S3O)
		return units3oparser->LoadModel(name,scale,side);
	else
		return unit3doparser->LoadModel(name,scale,side);
}

IModelInstance *C3DModelParser::CreateLocalModel(IModel *model, vector<struct PieceInfo> *pieces)
{
	if(model->imodel_type == IMODEL_TYPE_S3O)
		return unit3doparser->CreateLocalModel(model,pieces);
	else
		return units3oparser->CreateLocalModel(model,pieces);
}
