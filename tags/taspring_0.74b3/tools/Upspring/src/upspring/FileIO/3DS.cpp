//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------
#include "EditorIncl.h"
#include "EditorDef.h"
#include "Model.h"
#include "Util.h"

#define MAIN3DS 0x4D4D

//>------ Main Chunks
#define EDIT3DS       0x3D3D  // this is the start of the editor config
//>------ sub defines of EDIT3DS 
#define EDIT_OBJECT   0x4000 
//>------ sub defines of EDIT_OBJECT
#define OBJ_TRIMESH   0x4100 
//>------ sub defines of OBJ_TRIMESH
#define TRI_VERTEX    0x4110 
#define TRI_FACELIST  0x4120 
#define TRI_MAPLIST   0x4140

static int read_chunk(FILE *f,int len, MdlObject* parent);
static int write_chunk(FILE *f, ushort id, MdlObject *obj);

static int readTriFaceList(FILE *f, int ch_len, MdlObject* parent);
static int readTriVerts(FILE *f, int ch_len, MdlObject* obj);
static int readEditObject(FILE *f, int ch_len, MdlObject* obj);
static int readTriMapList(FILE *f, int ch_len, MdlObject* obj);
static int readTriMesh(FILE*f, MdlObject *obj);

static int writeEdit3DS(FILE*f, MdlObject *obj);
static int writeMain3DS(FILE*f, MdlObject *obj);
static int writeTriMesh(FILE*f, MdlObject *obj);
static int writeEditObject(FILE*f, MdlObject *obj);
static int writeTriVerts(FILE*f, MdlObject *obj);
static int writeTriMapList(FILE*f, MdlObject *obj);
static int writeTriFaceList(FILE*f, MdlObject *obj);


#pragma pack(push, 2) 

struct chunk_t
{
	ushort id;
	ulong len;   // from start of ID
};

#pragma pack(pop)

struct {
	ushort id;
	int (*save)(FILE *f, MdlObject *obj);
	int (*load)(FILE *f, int ch_len, MdlObject *obj); // returns 0 on success
	char *name;
} chunklist[] = {
	{MAIN3DS, writeMain3DS, 0, "main" },
	{EDIT3DS, writeEdit3DS, 0, "edit" },
	{EDIT_OBJECT, writeEditObject, readEditObject, "object" },
	{OBJ_TRIMESH, writeTriMesh, 0, "trimesh" },
	{TRI_VERTEX,  writeTriVerts, readTriVerts, "meshverts" },
	{TRI_FACELIST, writeTriFaceList, readTriFaceList, "meshfaces" },
	{TRI_MAPLIST, writeTriMapList, readTriMapList, "meshuv" },
	{0,0,0}
};

int find_chunk(ushort id)
{
	int a;
	for(a=0;chunklist[a].id;a++)
		if(chunklist[a].id==id) return a;
	return -1;
}


static int write_chunk(FILE *f, ushort id, MdlObject *obj)
{
	int ind;
	chunk_t ch;
	int pos;
	int ret;

	ind = find_chunk(id);
	assert( ind >= 0 );

	if(chunklist[ind].save)
	{
		pos = ftell(f);
		ch.id = id;
		fseek(f,sizeof(chunk_t), SEEK_CUR);
		ret = chunklist[ind].save(f,obj);
		ch.len = ftell(f) - pos;
		fseek(f,pos,SEEK_SET);
		fwrite(&ch,sizeof(chunk_t),1,f);
		fseek(f,pos+ch.len,SEEK_SET);
	}
	return -1;
}



static int read_chunk(FILE *f, int len, MdlObject* parent)
{
	chunk_t         ch;
	int             a;
	int             ret = 0;
	int             start_pos = ftell(f);
	int             chunkpos;

	while( ftell(f) - start_pos < len )
	{
		chunkpos = ftell(f);
		fread(&ch, sizeof(chunk_t), 1, f);
		a = find_chunk(ch.id);

		if(a!=-1)
		{
			logger.Trace (NL_Msg, "Reading %s chunk. size=%d\n", chunklist[a].name,ch.len);
			if( chunklist[a].load )
				ret = chunklist[a].load( f, ch.len - sizeof(chunk_t), parent );
			else  // read childs
				ret = read_chunk( f, ch.len - sizeof(chunk_t), parent );

			if( ret ) // error?
			{
				logger.Trace (NL_Msg, "Failed to load %s chunk at offset %d", 
					chunklist[a].name, chunkpos);
				break;
			}
		} else 
			logger.Trace (NL_Msg, "Unknown chunk type:%x\n",ch.id);
		chunkpos += ch.len;
		fseek( f, chunkpos, SEEK_SET );
	}
	return ret;
}

static int writeMain3DS(FILE*f, MdlObject *obj)
{
	write_chunk(f,EDIT3DS,obj);
	return 0;
}

static int writeEdit3DS(FILE*f, MdlObject *obj)
{
	write_chunk(f,EDIT_OBJECT,obj);
	return 0;
}

static int writeEditObject(FILE*f, MdlObject *obj)
{
	WriteZStr (f, obj->name);

	if (!obj->verts.empty ())
		write_chunk (f, OBJ_TRIMESH,obj);

	for (int a=0;a<obj->childs.size();a++)
		write_chunk (f,EDIT_OBJECT, obj->childs[a]);

	return 0;
}

static int writeTriMesh(FILE *f, MdlObject *obj)
{
	if(!obj->verts.empty()) {
		write_chunk(f,TRI_VERTEX,obj);
		write_chunk(f,TRI_MAPLIST,obj);
	}

	if(!obj->poly.empty()) 
		write_chunk(f,TRI_FACELIST,obj);
	return 0;
}

static int writeTriVerts(FILE *f, MdlObject *obj)
{
	short num;
	num = obj->verts.size();
	fwrite(&num,sizeof(short),1,f);
	for(int a=0;a<obj->verts.size();a++)
		fwrite(&obj->verts[a].pos, sizeof(float),3,f);
	return 0;
}


static int writeTriFaceList(FILE* f, MdlObject *obj)
{
	int a;
	short num;
	short face[4];

	// make a list of triangles
	std::vector <Triangle> tris = obj->MakeTris ();

	num = tris.size();
	fwrite(&num,sizeof(short),1,f);

	face[3]=0;
	for(int b=0;b<tris.size();b++)
	{
		for(a=0;a<3;a++)
			face[a] = tris[b].vrt[a];
		fwrite(&face,sizeof(short),4,f);
	}
	return 0;
}

static int writeTriMapList(FILE*f, MdlObject *obj)
{
	short num;

	num = obj->verts.size();
	for (int a=0;a<num;a++) {
		fread (&obj->verts[a].tc[0], sizeof(float),2,f);
	}
	return 0;
}

static int readEditObject(FILE *f, int ch_len, MdlObject* parent)
{
	int ret;
	int ppos;
	MdlObject *obj=0;

	if (parent->name.empty()) {
		obj = parent;
	} else {
		obj = new MdlObject;
		parent->childs.push_back (obj);
		obj->parent = parent;
	}

	ppos = ftell(f);
	obj->name = ReadZStr(f);
	ret = read_chunk(f,ch_len-( ftell(f) - ppos ), obj);

	// 3DS doesn't store offsets, so calculate it
	obj->ApproximateOffset ();
	return ret;
}

static int readTriVerts(FILE *f, int ch_len, MdlObject* obj)
{
	short       vnum;
	int         a=0;
	float       pos[3];

	fread(&vnum, sizeof(short), 1, f);
	if(!vnum)	return 0;

	obj->verts.resize (vnum);
	for (int a=0;a<vnum;a++)
	{
		fread( pos, sizeof(float), 3, f );
		obj->verts[a].pos.set(pos [0], pos [1], pos [2]);
	}
	return 0;
}

static int readTriMapList (FILE *f, int ch_len, MdlObject *obj)
{
	short n;

	fread(&n, sizeof(n), 1, f);
	if (obj->verts.size()) assert (obj->verts.size()==n);
	obj->verts.resize(n);
	for(int a=0;a<n;a++)
		fread( &obj->verts[a].tc[0], sizeof(float),2, f );

	return 0;
}

static int readTriFaceList(FILE *f, int ch_len, MdlObject* obj)
{
	short       fnum;
	int         a,b,i=0;
	short       face[4]; // vert[3] + flag

	fread(&fnum, sizeof(short),1,f);
	// alloc trilist
	if( !fnum ) return 0;

	for (a=0;a<fnum;a++)
	{
		fread( face, sizeof(short), 4, f );

		Poly *pl = new Poly;
		pl->verts.resize (3);
		for (b=0;b<3;b++)
			pl->verts [b] = face [b];
		obj->poly.push_back(pl);
	}
	return 0;
}

static inline void removeTransform(MdlObject *obj) 
{ 
	obj->ApplyTransform(true,true,true);
}

bool Save3DSObject(const char *fn, MdlObject *obj, IProgressCtl& progctl)
{
	FILE *f = fopen (fn, "wb");

	if (!f)
		return false;

	MdlObject *cl = obj->Clone ();
	IterateObjects (cl, removeTransform);
	write_chunk (f, MAIN3DS, cl);
	delete cl;

	fclose (f);
	return true;
}

MdlObject *Load3DSObject(const char *fn, IProgressCtl& progctl)
{
	FILE *f = fopen (fn, "rb");

	if (!f)
		return 0;

	MdlObject *obj=new MdlObject;

	fseek (f, 0, SEEK_END);
	int len =ftell(f);
	fseek (f,0,SEEK_SET);
	if (read_chunk (f, len, obj)) {
		delete obj;
		return 0;
	}

	return obj;
}
