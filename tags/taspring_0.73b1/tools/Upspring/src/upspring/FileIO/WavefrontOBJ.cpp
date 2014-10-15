//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------

#include "EditorIncl.h"
#include "EditorDef.h"

#include "Model.h"
#include "Util.h"

/* Values for wfPart.parttype */
#define WF_FACE		1
#define WF_LINE		4
#define WF_VERTEX	7
#define WF_NORMAL	8
#define WF_TEXCOORD	9
#define WF_UNSUPPORTED	10

struct wf_face_vert
{
	int vert,tex,norm;
};

struct wf_face
{
	vector<wf_face_vert> verts;
};

struct wf_object
{
	~wf_object() { 
		for (int a=0;a<faces.size();a++)
			delete faces[a];
		faces.clear();
	}
	vector<Vector3> vert;
	vector<Vector3> norm;
	vector<Vector2> texc;
	vector<wf_face*> faces;
};

#define whitespace " \t"

/* Types of lines that may be read from object file */
#define VERTEX 1
#define NORMAL 2
#define TEXTURE 3
#define FACE 4
#define MTLLIB 5
#define USEMTL 6
#define MAPLIB 7
#define USEMAP 8
#define LINE 9
#define COMMENT 99
#define UNSUPPORTED 999

char * wfReadLine(char *buf,int bufsize,FILE *fp)
{
 int len;
 if (!fgets(buf,bufsize,fp)) return NULL;
 len = strlen(buf)-1;
 if (len <= 0)
	return buf;
 while ((len<bufsize) && (buf[len-1] == '\\'))
	{
	if (!fgets(buf+len-1,bufsize-len,fp)) break;
	len = strlen(buf)-1;
	}
 return buf;
}


static void get_vertex(wf_object *obj)
{
	char *v;
	Vector3 pos;
	v = strtok(NULL,whitespace);
	if (v) pos.x = atof(v);
	else pos.x = 0;
	v = strtok(NULL,whitespace);
	if (v) pos.y = atof(v);
	else pos.y = 0;
	v = strtok(NULL,whitespace);
	if (v) pos.z = atof(v);
	else pos.z = 0;
	obj->vert.push_back (pos);
}

/* get_normal - processes a 'vn' line; gets the next vertex normal */
static void get_normal(wf_object *obj)
{
	char *v;
	Vector3 n;
	v = strtok(NULL,whitespace);
	if (v) n.x = atof(v);
	else n.x = 0;
	v = strtok(NULL,whitespace);
	if (v)n.y = atof(v);
	else n.y = 0;
	v = strtok(NULL,whitespace);
	if (v)n.z = atof(v);
	else n.z = 0;
}

/* get_texcoord - processes a 'vt' line; gets the next texture vertex */
static void get_texcoord(wf_object *obj)
{
	char *v;
	Vector3 tc;
	v = strtok(NULL,whitespace);
	if (v) tc.x = atof(v);
	else tc.x = 0;
	v = strtok(NULL,whitespace);
	if (v) tc.y = atof(v);
	else tc.y = 0;
	v = strtok(NULL,whitespace);
	if (v)tc.z = atof(v);
	else tc.z = 0;
	obj->texc.push_back (Vector2(tc.x,tc.y));
}

static void get_face(char *line, wf_object *obj)
{
	int nverts=0,i=0,v,vt,vn;
	char *s,*r;
	/* Count the number of vertices on the line */
	while (strtok(NULL,whitespace)) nverts++;
	/* Create the struct */
	wf_face *f = new wf_face;
	s = strtok(line,whitespace);

	while (s = strtok(NULL,whitespace))
	{
		v = atoi(s);

		wf_face_vert fv;
		if (v>=0) fv.vert = v;
		else fv.vert = obj->vert.size()+1 + v;
	/* Find the vertex texture after the first '/' */
		r = s;
		while ((*r) && (*r != '/')) r++;
		if (*r)
		{
			r++;
			vt = atoi(r);
			if (vt>=0) fv.tex = vt;
			else fv.tex = obj->texc.size()+1 + vt;
		}
		else fv.tex = 0;
	/* Find the vertex normal after the second '/' */
		while ((*r) && (*r != '/')) r++;
		if (*r)
		{
			r++;
			vn = atoi(r);
			if (vn>=0) fv.norm = vn;
			else fv.tex = obj->norm.size()+1 + vn;
		}
		else fv.norm = 0;

		f->verts.push_back (fv);

		i++;
	}
	obj->faces.push_back(f);
}


/* line_type - determines the type of 'command' a line contains. Calls
	strtok() to get the first string on the line, and to prepare it
	for parsing by other routines. */
static int line_type(char *line)
{
 char *cmd;
 cmd = strtok(line,whitespace);
 if (!cmd) return(COMMENT);
 if (!strcmp(cmd,"v")) return(VERTEX);
 else if (!strcmp(cmd,"vn")) return(NORMAL);
 else if (!strcmp(cmd,"vt")) return(TEXTURE);
 else if (!strcmp(cmd,"l")) return(LINE);
 else if (!strcmp(cmd,"f")) return(FACE);
 else if (!strcmp(cmd,"fo")) return(FACE);
 else if (!strcmp(cmd,"mtllib")) return(MTLLIB);
 else if (!strcmp(cmd,"usemtl")) return(USEMTL);
 else if (!strcmp(cmd,"maplib")) return(MAPLIB);
 else if (!strcmp(cmd,"usemap")) return(USEMAP);
 else if (!strcmp(cmd,"#")) return(COMMENT);
 return(UNSUPPORTED);
}

/* process_line - Determines what 'command' a line contains and adds
	the info to the object */
static void process_line(char *line,wf_object *obj)
{
 int t;
 char linecopy[1024];
/* Save a copy of the line for get_face et al, before line_type() strtok's it */
 strcpy(linecopy,line);
 t = line_type(line);
 switch (t) {
	case VERTEX: 
		get_vertex(obj);
		break;
	case NORMAL: 
		get_normal(obj); 
		break;
	case TEXTURE: 
		get_texcoord(obj);
		break;
	case FACE: 
		get_face(linecopy,obj); 
		break;
	}
}




wf_object *ReadWFObject (char *fname, IProgressCtl& progctl)
{
	FILE *fp;
	char line[1024];
	if ((fp = fopen(fname,"r")) == 0)
		return(NULL);
	int len = 0;
	fseek (fp,0,SEEK_END);
	len=ftell(fp);
	fseek (fp,0,SEEK_SET);

	wf_object *obj = new wf_object;
	while (wfReadLine(line,1024,fp))
	{
		line[strlen(line)-1] = '\0'; /* get rid of newline */
		process_line(line,obj);

		int pos = ftell(fp);
		progctl.Update (pos / (float)len);
	}
	fclose(fp);
	return obj;
}

bool SaveWavefrontObject (const char *fn, MdlObject *obj, IProgressCtl& progctl)
{
	FILE *f = fopen (fn, "w");
	if (!f) 
		return false;

// write verts pos
	fprintf (f, "# %d vertices, %d polygons\n", obj->verts.size(), obj->poly.size());

	for (vector<Vertex>::iterator v=obj->verts.begin();v!=obj->verts.end();++v)
		fprintf(f,"v %f %f %f\n",v->pos.x, v->pos.y, v->pos.z);

// write normals
//	for (vector<Vertex>::iterator v=obj->verts.begin();v!=obj->verts.end();++v)
//		fprintf(f,"vn %f %f %f\n",v->normal.x, v->normal.y, v->normal.z);

// write tc's
	for (vector<Vertex>::iterator v=obj->verts.begin();v!=obj->verts.end();++v)
		fprintf(f,"vt %f %f 0.0\n",v->tc[0].x, v->tc[0].y);

// write faces
	for (int a=0;a<obj->poly.size();a++)
	{
		Poly *p=obj->poly[a];
		fprintf(f,"f");
		for (int v=0; v<p->verts.size(); v++) {
			int i = p->verts[v]+1;
			fprintf(f," %d/%d/%d ", i,i,i);
		}
		fprintf(f,"\n");
	}
	fclose (f);

	return true;
}


MdlObject *LoadWavefrontObject (const char *fn, IProgressCtl& progctl)
{
	wf_object *wfobj = ReadWFObject( (char*)fn, progctl);

	if (!wfobj)
		return 0;

	MdlObject *o = new MdlObject;

	for (int fi=0;fi<wfobj->faces.size();fi++)
	{
		Poly *pl = new Poly;
		wf_face *face = wfobj->faces [fi];
		pl->verts.resize (face->verts.size());

		for (int a=0;a<pl->verts.size();a++)
		{
			o->verts.push_back (Vertex());
			Vertex& v=o->verts.back();
			
			wf_face_vert& fv=face->verts[a];

			if (!wfobj->norm.empty() && fv.norm-1 < wfobj->norm.size())
				v.normal = wfobj->norm [fv.norm-1];
			if (!wfobj->texc.empty() && fv.tex-1 < wfobj->texc.size())
				v.tc [0] = wfobj->texc [fv.tex-1];
			if (!wfobj->vert.empty() && fv.vert-1 < wfobj->vert.size())
				v.pos = wfobj->vert [fv.vert-1];

			pl->verts [a] = o->verts.size()-1;
		}

		o->poly.push_back (pl);
	}

	delete wfobj;

	return o;
}

