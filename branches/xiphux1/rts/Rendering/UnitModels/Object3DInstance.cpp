#include "Rendering/GL/myGL.h"
#include "Object3DInstance.h"
#include "System/GlobalStuff.h"

Object3DInstance::~Object3DInstance()
{
	delete [] pieces;
	delete [] scritoa;
}

void Object3DPiece::Draw()
{
	#define CORDDIV 65536.0f
	#define ANGDIV 182.0f
	//detta kan väl optimeras lite kanske.. men tills vidare
	glPushMatrix();
	glTranslatef(offset.x,offset.y,offset.z);
	if(anim)
	{
		glTranslatef(-anim->coords[0]/CORDDIV, anim->coords[1]/CORDDIV, anim->coords[2]/CORDDIV);
		if(anim->rot[1])
			glRotatef(anim->rot[1]/ANGDIV, 0, 1, 0);
		if(anim->rot[0])
			glRotatef(anim->rot[0]/ANGDIV, 1, 0, 0);
		if(anim->rot[2])
			glRotatef(-anim->rot[2]/ANGDIV, 0, 0, 1);

		if(anim->visible)
			glCallList(displist);
	}
	else
		glCallList(displist);

	for(unsigned int i=0; i<childs.size(); i++)
		childs[i]->Draw();
	glPopMatrix();
}

void Object3DInstance::Draw()
{
	//glPushMatrix();
	//glRotatef(180, 0, 1, 0);
	pieces->Draw();
	//glPopMatrix();
}

bool Object3DInstance::PieceExists(int piecenum)
{
	if(piecenum>=numpieces || piecenum<0)
		return false;

	int p=scritoa[piecenum];

	if(p==-1)
		return false;

	return true;
}

float3 Object3DInstance::GetPiecePos(int piecenum)
{
	if(piecenum>=numpieces || piecenum<0)
		return ZeroVector;

	int p=scritoa[piecenum];

	if(p==-1)
		return ZeroVector;

	CMatrix44f mat;
	Object3DPiece *op = (Object3DPiece*)(&pieces[p]);
	op->GetPiecePosIter(&mat);
	if(op->original && op->original->vertices.size()==2){		//stupid fix for valkyres
		if(op->original->vertices[0].pos.y > op->original->vertices[1].pos.y)
			mat.Translate(op->original->vertices[0].pos.x, op->original->vertices[0].pos.y, -op->original->vertices[0].pos.z);
		else
			mat.Translate(op->original->vertices[1].pos.x, op->original->vertices[1].pos.y, -op->original->vertices[1].pos.z);
	}

/*
	info->AddLine("%f %f %f %f",mat[0],mat[4],mat[8],mat[12]);
	info->AddLine("%f %f %f %f",mat[1],mat[5],mat[9],mat[13]);
	info->AddLine("%f %f %f %f",mat[2],mat[6],mat[10],mat[14]);
	info->AddLine("%f %f %f %f",mat[3],mat[7],mat[11],mat[15]);/**/
	float3 pos=mat.GetPos();
	pos.z*=-1;
	pos.x*=-1;

	return pos;
	//return UpVector;
}

CMatrix44f Object3DInstance::GetPieceMatrix(int piecenum)
{
	int p=scritoa[piecenum];

	if(p==-1)
		return CMatrix44f();

	CMatrix44f mat;
	pieces[p].GetPiecePosIter(&mat);

	return mat;
}

//Only useful for special pieces used for emit-sfx
float3 Object3DInstance::GetPieceDirection(int piecenum)
{
	int p=scritoa[piecenum];

	if(p==-1)
		return float3(1,1,1);

	IModel &orig = *pieces[p].original;
	if (orig.vertices.size() < 2) {
		//info->AddLine("Use of GetPieceDir on strange piece (%d vertices)", orig.vertices.size());
		return float3(1,1,1);
	}
	else if (orig.vertices.size() > 2) {
		//this is strange too, but probably caused by an incorrect 3rd party unit
	}
	//info->AddLine("Vertexes %f %f %f", orig.vertices[0].pos.x, orig.vertices[0].pos.y, orig.vertices[0].pos.z);
	//info->AddLine("Vertexes %f %f %f", orig.vertices[1].pos.x, orig.vertices[1].pos.y, orig.vertices[1].pos.z);
	return orig.vertices[0].pos - orig.vertices[1].pos;

}

void Object3DPiece::GetPiecePosIter(CMatrix44f* mat)
{
	if(parent)
		parent->GetPiecePosIter(mat);

	mat->Translate(offset.x,offset.y,-offset.z);
//	info->AddLine("RelPosSub %f %f %f",offset.x,offset.y,offset.z);

	if(anim)
	{
		mat->Translate(-anim->coords[0]/CORDDIV, anim->coords[1]/CORDDIV, -anim->coords[2]/CORDDIV);
		if(anim->rot[1])
			mat->RotateY(anim->rot[1]*(PI/32768));
		if(anim->rot[0])
			mat->RotateX(anim->rot[0]*(PI/32768));
		if(anim->rot[2])
			mat->RotateZ(anim->rot[2]*(PI/32768));
	}
}
