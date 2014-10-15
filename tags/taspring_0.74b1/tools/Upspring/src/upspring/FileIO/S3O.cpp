//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------

#include "EditorIncl.h"
#include "EditorDef.h"
#include "Util.h"
#include "Model.h"
#include "Texture.h"

#include "s3o.h"

#define S3O_ID "Spring unit"

static void MirrorX(MdlObject *o)
{
	o->position.x *= -1.0f;
	for (int a=0;a<o->verts.size();a++)
		o->verts[a].pos.x *= -1.0f;

	for (int a=0;a<o->poly.size();a++)
		o->poly[a]->Flip();

	o->CalculateNormals();

	for (int a=0;a<o->childs.size();a++)
		MirrorX(o->childs[a]);
}

static MdlObject *S3O_LoadObject (FILE *f, ulong offset)
{
	int oldofs = ftell(f);
	MdlObject *obj = new MdlObject;

	// Read piece header
	S3OPiece piece;
	fseek (f, offset, SEEK_SET);
	fread (&piece, sizeof(S3OPiece), 1, f);

	// Read name
	obj->name = ReadString (piece.name, f);
	obj->position.set(piece.xoffset,piece.yoffset,piece.zoffset);

	// Read child objects
	fseek (f, piece.childs, SEEK_SET);
	for (int a=0;a<piece.numChilds;a++) {
		ulong chOffset;
		fread (&chOffset, sizeof(ulong), 1, f);
		MdlObject *child = S3O_LoadObject (f, chOffset);
		if (child) {
			child->parent = obj;
			obj->childs.push_back (child);
		}
	}

	// Read vertices
	obj->verts.resize (piece.numVertices);
	fseek (f, piece.vertices, SEEK_SET);
	for (int a=0;a<piece.numVertices;a++) {
		S3OVertex sv;
		fread (&sv, sizeof(S3OVertex), 1, f);
		obj->verts [a].normal.set (sv.xnormal, sv.ynormal, sv.znormal);
		obj->verts [a].pos.set (sv.xpos, sv.ypos, sv.zpos);
		obj->verts [a].tc[0] = Vector2(sv.texu, sv.texv);
	}

	// Read primitives - 0=triangles,1 triangle strips,2=quads
	fseek (f, piece.vertexTable, SEEK_SET);
	switch (piece.primitiveType) { 
		case 0: { // triangles
			for (int i=0;i<piece.vertexTableSize;i+=3) {
				ulong index;
                Poly *pl = new Poly;
				pl->verts.resize(3);
				for (int a=0;a<3;a++) {
					fread (&index,4,1,f);
					pl->verts [a] = index;
				}
				obj->poly.push_back (pl);
			}
			break;}
		case 1: { // tristrips
			ulong *data=new ulong[piece.vertexTableSize];
			fread (data,4,piece.vertexTableSize, f);
			for (int i=0;i<piece.vertexTableSize;) {
				// find out how long this strip is
				int first=i;
				while (i<piece.vertexTableSize && data[i]!=-1) 
					i++;
				// create triangles from it
				for (int a=2;a<i-first;a++) {
					Poly *pl = new Poly;
					pl->verts.resize(3);
					for (int x=0;x<3;x++)
						pl->verts[(a&1)?x:2-x]=data[first+a+x-2];
					obj->poly.push_back(pl);
				}
			}
			delete[] data;
			break;}
		case 2: { // quads
			for (int i=0;i<piece.vertexTableSize;i+=4) {
				ulong index;
                Poly *pl = new Poly;
				pl->verts.resize(4);
				for (int a=0;a<4;a++) {
					fread (&index,4,1,f);
					pl->verts [a] = index;
				}
				obj->poly.push_back (pl);
			}
			break;}
	}

//	fltk::message("object %s has %d polygon and %d vertices", obj->name.c_str(), obj->poly.size(),obj->verts.size());

	fseek (f, oldofs, SEEK_SET);
	return obj;
}

bool Model::LoadS3O (const char *filename, IProgressCtl& progctl)
{
	S3OHeader header;
	FILE *file = fopen (filename, "rb");
	if (!file)
		return false;

	fread (&header, sizeof(S3OHeader), 1, file);

	if (memcmp (header.magic, S3O_ID, 12)) {
		logger.Trace (NL_Error, "S3O model %s has wrong identification", filename);
		fclose (file);
		return false;
	}

	if (header.version != 0) {
		logger.Trace (NL_Error, "S3O model %s has wrong version (%d, wanted: %d)", filename, header.version, 0);
		fclose (file);
		return false;
	}

	radius = header.radius;
	mid.set (-header.midx, header.midy, header.midz);
	height = header.height;

	root = S3O_LoadObject (file, header.rootPiece);
	MirrorX(root);

	string mdlPath = GetFilePath (filename);

	// load textures
	for (int tex=0;tex<2;tex++) {
		if ( !(tex ? header.texture2 : header.texture1))
			continue;

		textureNames[tex] = ReadString (tex ? header.texture2 : header.texture1, file);
		textures[tex] = new Texture (textureNames[tex], mdlPath);
		if (!textures[tex]->IsLoaded ()) {
			SAFE_DELETE(textures[tex]);
		}
	}

	mapping = MAPPING_S3O;

	fclose (file);
	return true;
}

static void S3O_WritePrimitives(S3OPiece *p, FILE *f, MdlObject *obj)
{
	bool allQuads=true;
	int a=0;
	for (;a<obj->poly.size();a++) {
		if (obj->poly[a]->verts.size()!=4)
			allQuads=false;
	}

	p->vertexTable = ftell(f);
	if (allQuads) {
		for (int a=0;a<obj->poly.size();a++) {
			Poly *pl = obj->poly[a];
			for (int b=0;b<4;b++) {
				ulong i=pl->verts[b];
				fwrite (&i, 4,1,f);
			}
		}
		p->vertexTableSize = 4 * (uint)obj->poly.size();
		p->primitiveType=2;
	} else {
		vector<Triangle> tris = obj->MakeTris ();
		for (int a=0;a<tris.size();a++)
		{
			for (int b=0;b<3;b++) {
				ulong i=tris[a].vrt[b];
				fwrite (&i,4,1,f);
			}
		}
		p->vertexTableSize = 3 * (uint)tris.size();
		p->primitiveType=0;
	}
}

static void S3O_SaveObject (FILE *f, MdlObject *obj)
{
	int startpos = ftell(f);
	S3OPiece piece;

	fseek (f, sizeof(S3OPiece), SEEK_CUR);
	piece.name = ftell(f);
	WriteZStr(f, obj->name);
	
	piece.xoffset = obj->position.x;
	piece.yoffset = obj->position.y;
	piece.zoffset = obj->position.z;
	piece.collisionData = 0;
	piece.vertexType = 0;
	S3O_WritePrimitives (&piece, f, obj);

	piece.numVertices = (uint) obj->verts.size();
	piece.vertices = ftell(f);
	for (int a=0;a<obj->verts.size();a++)
	{
		Vertex *myVert=&obj->verts[a];
		S3OVertex v;
		v.texu=myVert->tc[0].x;
		v.texv=myVert->tc[0].y;
		v.xnormal=myVert->normal.x;
		v.ynormal=myVert->normal.y;
		v.znormal=myVert->normal.z;
		v.xpos=myVert->pos.x;
		v.ypos=myVert->pos.y;
		v.zpos=myVert->pos.z;
		fwrite(&v,sizeof(S3OVertex),1,f);
	}

	piece.numChilds = (uint)obj->childs.size();
	ulong *childpos=new ulong[piece.numChilds];
	for (int a=0;a<obj->childs.size();a++)
	{
		childpos[a] = ftell(f);
		S3O_SaveObject (f,obj->childs[a]);
	}
	piece.childs=ftell(f);
	fwrite (childpos,4,piece.numChilds,f);
	delete[] childpos;

	int endpos=ftell(f);
	fseek (f,startpos,SEEK_SET);
	fwrite (&piece,sizeof(S3OPiece),1,f);
	fseek (f,endpos,SEEK_SET);
}


// S3O supports position saving, but no rotation or scaling
static inline void ApplyOrientationAndScaling (MdlObject *o) 
{
	o->ApplyTransform(true,true,false);
}

bool Model::SaveS3O (const char *filename, IProgressCtl& progctl)
{
	S3OHeader header;
	memset (&header,0,sizeof(S3OHeader));
	memcpy (header.magic, S3O_ID, 12);

	if (!root)
		return false;
	
	FILE *f = fopen (filename, "wb");
	if (!f) 
		return false;

	fseek (f, sizeof(S3OHeader), SEEK_SET);
	header.rootPiece = ftell(f);

	if (root) {
		MdlObject *cloned = root->Clone();
		IterateObjects (cloned, ApplyOrientationAndScaling);
		MirrorX(cloned);
		S3O_SaveObject (f, cloned);
		delete cloned;
	}

	for (int tex=0;tex<2;tex++) {
		if (!textureNames[tex].empty()) {
			if (tex==0) header.texture1 = ftell(f);
			if (tex==1) header.texture2 = ftell(f);
			WriteZStr (f, textureNames[tex]);
		}
	}

	header.radius = radius;
	header.height = height;
	header.midx = -mid.x;
	header.midy = mid.y;
	header.midz = mid.z;

	fseek (f, 0, SEEK_SET);
	fwrite (&header, sizeof(S3OHeader), 1, f);
	fclose (f);

	return true;
}

