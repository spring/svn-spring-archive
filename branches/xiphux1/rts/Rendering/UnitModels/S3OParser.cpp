#include "s3o.h"
#include "S3OParser.h"
#include "System/Platform/errorhandler.h"
#include "Rendering/GL/myGL.h"
#include "System/Syncify.h"
#include "System/FileSystem/FileHandler.h"
#include "Rendering/Textures/TextureHandler.h"
#include "Rendering/FartextureHandler.h"

IModel* CS3OParser::LoadModel(string name,float scale,int side)
{
	if(name.find(".")==string::npos)
		name+=".s3o";

	std::transform(name.begin(), name.end(), name.begin(), (int (*)(int))std::tolower);

	map<string,object3d*>::iterator ui;
	if((ui=units.find(name))!=units.end()){
		return ui->second;
	}

	PUSH_CODE_MODE;
	ENTER_SYNCED;

	CFileHandler file(name);
	if(!file.FileExists()){
		handleerror(0,"No file",name.c_str(),0);
		POP_CODE_MODE;
		return 0;
	}
	unsigned char* fileBuf=new unsigned char[file.FileSize()];
	file.Read(fileBuf, file.FileSize());
	S3OHeader header;
	memcpy(&header,fileBuf,sizeof(header));
	
	object3d *model = new object3d;
	model->numobjects=0;
	SS3O* object=LoadPiece(fileBuf,header.rootPiece,model);
	model->rootobject=object;
	object->isEmpty=true;
	model->name=name;
	model->textureType=texturehandler->LoadS3OTexture((char*)&fileBuf[header.texture1],(char*)&fileBuf[header.texture2]);

	FindMinMax(object);

	units[name]=model;

	CreateLists(object);

	model->radius = header.radius*scale;		//this is a hack to make aircrafts less likely to collide and get hit by nontracking weapons
	model->height = header.height;
	model->relMidPos.x=header.midx;
	model->relMidPos.y=header.midy;
	model->relMidPos.z=header.midz;
	if(model->relMidPos.y<1)
		model->relMidPos.y=1;

//	info->AddLine("%s has height %f",name,model->height);
	fartextureHandler->CreateFarTexture(model);

	model->maxx=model->rootobject->maxx;
	model->maxy=model->rootobject->maxy;
	model->maxz=model->rootobject->maxz;

	model->minx=model->rootobject->minx;
	model->miny=model->rootobject->miny;
	model->minz=model->rootobject->minz;

	delete[] fileBuf;
	POP_CODE_MODE;
	return model;
}

Object3DInstance* CS3OParser::CreateLocalModel(IModel *model, vector<struct PieceInfo> *pieces)
{
	object3d *m = (object3d*)model;
	Object3DInstance *lmodel = new Object3DInstance;
	lmodel->numpieces = m->numobjects;

	int piecenum=0;
	lmodel->pieces = new Object3DPiece[m->numobjects];
	lmodel->pieces->parent = NULL;
	lmodel->scritoa = new int[pieces->size()];
	for(int a=0;a<pieces->size();++a)
		lmodel->scritoa[a]=-1;

	CreateLocalModel((object3d*)(m->rootobject), lmodel, pieces, &piecenum);

	return lmodel;
}

void CS3OParser::CreateLocalModel(object3d *model, Object3DInstance *lmodel, vector<struct PieceInfo> *pieces, int *piecenum)
{
	PUSH_CODE_MODE;
	ENTER_SYNCED;
	lmodel->pieces[*piecenum].displist = model->displist;
	lmodel->pieces[*piecenum].offset = model->offset;
	lmodel->pieces[*piecenum].name = model->name;
	lmodel->pieces[*piecenum].original = model;

	lmodel->pieces[*piecenum].anim = NULL;	
	unsigned int cur;

	//Map this piecename to an index in the script's pieceinfo
	for(cur=0; cur<pieces->size(); cur++)
        if(lmodel->pieces[*piecenum].name.compare((*pieces)[cur].name) == 0)
			break;

	//Not found? Try again with partial matching
	if (cur == pieces->size()) {
		string &s1 = lmodel->pieces[*piecenum].name;
		for (cur = 0; cur < pieces->size(); ++cur) {
			string &s2 = (*pieces)[cur].name;
			int maxcompare = min(s1.size(), s2.size());
			int j;
			for (j = 0; j < maxcompare; ++j) {
				if (s1[j] != s2[j])
					break;
			}
			//Match now?
			if (j == maxcompare) {
				break;
			}
		}
	}

	//Did we find it now?
	if (cur < pieces->size()) {
		lmodel->pieces[*piecenum].anim = &((*pieces)[cur]);
		lmodel->scritoa[cur] = *piecenum;
	}
	else {
//		info->AddLine("CreateLocalModel: Could not map %s to script", lmodel->pieces[*piecenum].name.c_str());
	}

	int thispiece = *piecenum;
	for(unsigned int i=0; i<model->childs.size(); i++)
	{

		(*piecenum)++;
		lmodel->pieces[thispiece].childs.push_back(&lmodel->pieces[*piecenum]);
		lmodel->pieces[*piecenum].parent = &lmodel->pieces[thispiece];
		CreateLocalModel(model->childs[i], lmodel, pieces, piecenum);
	}
	POP_CODE_MODE;
}

SS3O* CS3OParser::LoadPiece(unsigned char* buf, int offset,object3d* model)
{
	model->numobjects++;

	SS3O* piece=new SS3O;

	Piece* fp=(Piece*)&buf[offset];

	piece->offset.x=fp->xoffset;
	piece->offset.y=fp->yoffset;
	piece->offset.z=fp->zoffset;
	piece->primitiveType=fp->primitiveType;
	piece->name=(char*)&buf[fp->name];

	int vertexPointer=fp->vertices;
	for(int a=0;a<fp->numVertices;++a){
		piece->vertices.push_back(*(SS3OVertex*)&buf[vertexPointer]);
/*		piece->vertices.back().normal.x=piece->vertices.back().pos.x;
		piece->vertices.back().normal.y=piece->vertices.back().pos.y;
		piece->vertices.back().normal.z=piece->vertices.back().pos.z;
		piece->vertices.back().normal.Normalize();*/
		vertexPointer+=sizeof(Vertex);
	}
	int vertexTablePointer=fp->vertexTable;
	for(int a=0;a<fp->vertexTableSize;++a){
		int num=*(int*)&buf[vertexTablePointer];
		piece->vertexDrawOrder.push_back(num);
		vertexTablePointer+=sizeof(int);

		if(num==-1 && a!=fp->vertexTableSize-1){		//for triangle strips
			piece->vertexDrawOrder.push_back(num);

			num=*(int*)&buf[vertexTablePointer];
			piece->vertexDrawOrder.push_back(num);				
		}
	}
	int childPointer=fp->childs;
	for(int a=0;a<fp->numChilds;++a){
		piece->childs.push_back(LoadPiece(buf,*(int*)&buf[childPointer],model));
		childPointer+=sizeof(int);
	}
	return piece;
}

void CS3OParser::FindMinMax(SS3O *object)
{
	std::vector<object3d*>::iterator si;
	for(si=object->childs.begin();si!=object->childs.end();++si){
		FindMinMax((SS3O*)(*si));
	}

	float maxx=-1000,maxy=-1000,maxz=-1000;
	float minx=10000,miny=10000,minz=10000;

	std::vector<vertex3d>::iterator vi;
	for(vi=object->vertices.begin();vi!=object->vertices.end();++vi){
		maxx=max(maxx,vi->pos.x);
		maxy=max(maxy,vi->pos.y);
		maxz=max(maxz,vi->pos.z);

		minx=min(minx,vi->pos.x);
		miny=min(miny,vi->pos.y);
		minz=min(minz,vi->pos.z);
	}
	for(si=object->childs.begin();si!=object->childs.end();++si){
		maxx=max(maxx,(*si)->offset.x+(*si)->maxx);
		maxy=max(maxy,(*si)->offset.y+(*si)->maxy);
		maxz=max(maxz,(*si)->offset.z+(*si)->maxz);

		minx=min(minx,(*si)->offset.x+(*si)->minx);
		miny=min(miny,(*si)->offset.y+(*si)->miny);
		minz=min(minz,(*si)->offset.z+(*si)->minz);
	}
	object->maxx=maxx;
	object->maxy=maxy;
	object->maxz=maxz;

	object->minx=minx;
	object->miny=miny;
	object->minz=minz;
}

void CS3OParser::DrawSub(object3d* o)
{
	SS3O *o2 = (SS3O*)o;
	SS3OVertex *v = (SS3OVertex*)(&o2->vertices[0]);
	glVertexPointer(3,GL_FLOAT,sizeof(SS3OVertex),&o2->vertices[0].pos.x);
	glTexCoordPointer(2,GL_FLOAT,sizeof(SS3OVertex),&v->textureX);
	glNormalPointer(GL_FLOAT,sizeof(SS3OVertex),&o2->vertices[0].normal.x);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	
	switch(o2->primitiveType){
	case 0:
		glDrawElements(GL_TRIANGLES,o2->vertexDrawOrder.size(),GL_UNSIGNED_INT,&o2->vertexDrawOrder[0]);
		break;
	case 1:
		glDrawElements(GL_TRIANGLE_STRIP,o2->vertexDrawOrder.size(),GL_UNSIGNED_INT,&o2->vertexDrawOrder[0]);
		break;
	case 2:
		glDrawElements(GL_QUADS,o2->vertexDrawOrder.size(),GL_UNSIGNED_INT,&o2->vertexDrawOrder[0]);
		break;
	}
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);						
	glDisableClientState(GL_NORMAL_ARRAY);

}


