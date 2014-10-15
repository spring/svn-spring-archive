#ifndef SPRING_3DMODELPARSER_H
#define SPRING_3DMODELPARSER_H

#include <vector>
#include <string>
#include "Matrix44f.h"
#include "3DOParser.h"
#include "S3OParser.h"

class C3DModelParser
{
public:
	C3DModelParser(void);
	~C3DModelParser(void);

	IModel* LoadModel(string name,float scale=1,int side=1);
	IModelInstance *CreateLocalModel(IModel *model, vector<struct PieceInfo> *pieces);

	CS3OParser *units3oparser;
	C3DOParser *unit3doparser;

private:
	unsigned int identify_modeltype(std::string name);
};

extern C3DModelParser* modelParser;

#endif /* SPRING_3DMODELPARSER_H */
