//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------
#include "EditorIncl.h"
#include "EditorDef.h"

#include "Util.h"
#include "View.h"
#include "Texture.h"
#include "ModelDrawer.h"

#include "nv_dds.h"

#include <GL/glew.h>

static const float ObjCenterSize=4.0f;

uint LoadVertexProgram (string fn);
uint LoadFragmentProgram (string fn);

void TestGLError()
{
	GLenum err=glGetError();
	if (err != GL_NO_ERROR)
	{
		logger.Trace (NL_Msg, "GL Error: %s\n", gluErrorString(err));
	}
}

void RenderData::Invalidate()
{
	glDeleteLists(drawList, 1);
	drawList=0;
}

RenderData::~RenderData()
{
	if (drawList)
		glDeleteLists(drawList,1);
	drawList=0;
}

ModelDrawer::ModelDrawer ()
{
	glewInitialized=false;
	canRenderS3O=false;
	model = 0;
	sphereList = 0;

	s3oFP=s3oVP=0;
	skyboxTexture=0;
	s3oFPunlit=s3oVPunlit=0;

	renderMethod = RM_S3OFULL;
}

ModelDrawer::~ModelDrawer ()
{	
	if (s3oFP) glDeleteProgramsARB( 1, &s3oFP );
	if (s3oVP) glDeleteProgramsARB( 1, &s3oVP );
	if (s3oFPunlit) glDeleteProgramsARB( 1, &s3oFPunlit );
	if (s3oVPunlit) glDeleteProgramsARB( 1, &s3oVPunlit );
	
	if (skyboxTexture)
		glDeleteTextures(1,&skyboxTexture);

	if (sphereList)
		glDeleteLists (sphereList,1);
}

void ModelDrawer::SetModel(Model *mdl) 
{
	model = mdl;
}

void ModelDrawer::SetupGL()
{
	glewInitialized=true;

	GLenum err;
	if ((err=glewInit ()) != GLEW_OK) {
		fltk::message ("Failed to initialize GLEW: %s", glewGetErrorString (err));
	}
	else {
		canRenderS3O = 0;
		// see if S3O's can be rendered properly
		if (GLEW_ARB_multitexture && GLEW_ARB_texture_env_combine) {
			canRenderS3O = 1;
		} else
			fltk::message ("Basic S3O rendering is not possible with this graphics card");

		if (GLEW_ARB_fragment_program && GLEW_ARB_vertex_program && GLEW_ARB_texture_cube_map) {

			s3oFP = LoadFragmentProgram (applicationPath + "shaders/s3o.fp");
			s3oVP = LoadVertexProgram (applicationPath + "shaders/s3o.vp");
			s3oFPunlit = LoadFragmentProgram (applicationPath + "shaders/s3o_unlit.fp");
			s3oVPunlit = LoadVertexProgram (applicationPath + "shaders/s3o_unlit.vp");

			if (s3oFP && s3oVP && s3oFPunlit && s3oVPunlit) {
				canRenderS3O = 2;

				nv_dds::CDDSImage image;
				if (!image.load (applicationPath + "skybox.dds"))
				{
					fltk::message ("Failed to load skybox.dds");

					canRenderS3O=1;
				}

				glGenTextures (1, &skyboxTexture);
				glBindTexture (GL_TEXTURE_CUBE_MAP_ARB, skyboxTexture);
				if (!image.upload_textureCubemap ()) {
					glDeleteTextures(1,&skyboxTexture);
					skyboxTexture=0;
					fltk::message ("Can't upload cubemap texture skybox.dds");
					canRenderS3O=1;
				}
			} 
			else canRenderS3O=1;
		} else
			fltk::message ("Full S3O rendering is not possible with this graphics card, \nself-illumination and reflection won't be visible");
	}

	GLUquadricObj* sphere = gluNewQuadric ();
	gluQuadricNormals(sphere, GLU_NONE);

	sphereList=glGenLists (1);
	glNewList (sphereList, GL_COMPILE);
	gluSphere (sphere, 1.0f, 16, 8);
	glEndList ();

	gluDeleteQuadric (sphere);

	glGenTextures (1, &whiteTexture);
	glBindTexture (GL_TEXTURE_2D, whiteTexture);
	float pixel=1.0f;
	glTexImage2D (GL_TEXTURE_2D, 0, 3, 1,1,0,GL_LUMINANCE, GL_FLOAT, &pixel);
}


void ModelDrawer::RenderPolygon (MdlObject *owner, Poly*pl, IView *v, int mapping, bool allowSelect)
{
	if (allowSelect) {
		pl->selector->object = owner;
		v->PushSelector (pl->selector);
	}

	if (mapping == MAPPING_3DO)
	{
		int texture=0;

		if (pl->texture && v->GetRenderMode()>=M3D_TEX) {
			if (pl->verts.size()==3 || pl->verts.size()==4) {
				texture=pl->texture->glIdent;
			}
		}

		if (!pl->texname.empty()) {
			if (texture) {
				glEnable (GL_TEXTURE_2D);
				glBindTexture (GL_TEXTURE_2D, texture);
			}
		} else {
			if (v->GetRenderMode()>=M3D_SOLID)
				glColor3fv ((float*)&pl->color);
		}

		glBegin(GL_POLYGON);
		if(pl->verts.size()==4 || pl->verts.size()==3){
			const float tc[] = {  0.0f,1.0f,  1.0f, 1.0f,   1.0f,0.0f, 0.0f,0.0f};
			for (int a=0;a<pl->verts.size();a++) {
				glTexCoord2f (tc[a*2],tc[a*2+1]);
				glNormal3fv ((float*)&owner->verts[pl->verts[a]].normal);
				glVertex3fv ((float*)&owner->verts[pl->verts[a]].pos);
			}
		} else {
			for (int a=0;a<pl->verts.size();a++) {
				int i = pl->verts [a];
				glNormal3fv ((float*)&owner->verts[i].normal);
				glVertex3fv ((float*)&owner->verts[i].pos);
			}
		}
		glEnd ();

		if (texture)
			glDisable(GL_TEXTURE_2D);
	}
	else {
		glBegin (GL_POLYGON);
		for (int a=0;a<pl->verts.size();a++) {
			int i = pl->verts [a];
			glTexCoord2fv ((float*)&owner->verts[i].tc[0]);
			glNormal3fv ((float*)&owner->verts[i].normal);
			glVertex3fv ((float*)&owner->verts[i].pos);
		}
		glEnd ();
	}

	glColor3ub (255,255,255);
	if (allowSelect) v->PopSelector ();
}


void ModelDrawer::RenderObject (MdlObject *o, IView *v, int mapping) 
{
	// setup selector
	v->PushSelector (o->selector);

	// setup object transformation
	Matrix tmp, mat;
	o->GetTransform (mat);
	mat.transpose (&tmp);
	glPushMatrix ();
	glMultMatrixf ( (float*)&tmp );

	// render object origin
	if (v->GetConfig (CFG_OBJCENTERS)!=0.0f)
	{
		glPointSize (ObjCenterSize);
		if (o->isSelected)	glColor3ub (255,0,0);
		else glColor3ub (255,255,255);
		glBegin(GL_POINTS);
		glVertex3i(0,0,0);
		glEnd();
		glPointSize (1);
		glColor3ub (255,255,255);
	}

	bool polySelect=v->GetConfig(CFG_POLYSELECT) != 0;

//	if(polySelect) {
		// render polygons
		for (int a=0;a<o->poly.size();a++)
			RenderPolygon (o, o->poly[a], v,mapping, polySelect);
/*	}
	else
	{
		// render geometry using drawing list
		if (!o->renderData)
			o->renderData = new RenderData;

		RenderData* rd = (RenderData*)o->renderData;

		if (rd->drawList)
			glCallList(rd->drawList);
		else {
			rd->drawList = glGenLists(1);
			glNewList(rd->drawList, GL_COMPILE_AND_EXECUTE);

			// render polygons
			for (int a=0;a<o->poly.size();a++)
				RenderPolygon (o, o->poly[a], v,mapping, polySelect);

			glEndList ();
		}
	}*/

	for (int a=0;a<o->childs.size();a++)
		RenderObject (o->childs[a], v, mapping);

	glPopMatrix ();
	v->PopSelector ();
}

int ModelDrawer::SetupS3OTextureMapping (IView *v, const Vector3& teamColor)
{
	int S3ORendering=0;

	switch (renderMethod) {
	case RM_S3OFULL:
	case RM_S3OBASIC:
		if (renderMethod == RM_S3OFULL && canRenderS3O==2 && model->textures[0] && model->textures[1]) {
			S3ORendering=2;
			SetupS3OAdvDrawing (teamColor,v);
		} else if(canRenderS3O>=1 && model->textures [0]) {
			S3ORendering=1;
			SetupS3OBasicDrawing (teamColor);
		} else if (model->textures[0]) {
			uint texture = model->textures [0]->glIdent;
			if (texture) {
				glEnable (GL_TEXTURE_2D);
				glBindTexture (GL_TEXTURE_2D, texture);
			}
		}
		break;
	case RM_TEXTURE0COLOR:
		if (model->textures[0]) {
			glEnable (GL_TEXTURE_2D);
			glBindTexture (GL_TEXTURE_2D, model->textures [0]->glIdent);
		}
		S3ORendering=3;
		break;
	case RM_TEXTURE1COLOR:
		if (model->textures[1]) {
			glEnable (GL_TEXTURE_2D);
			glBindTexture (GL_TEXTURE_2D, model->textures [1]->glIdent);
		}
		S3ORendering=3;
		break;
	}

	return S3ORendering;
}

int ModelDrawer::SetupTextureMapping (IView *v, const Vector3& teamColor)
{
	switch (model->mapping) {
	case MAPPING_S3O:
		return SetupS3OTextureMapping (v, teamColor);
	case MAPPING_3DO:
		model->root->Load3DOTextures (v->GetTextureHandler ());
	}
	return 0;
}

void ModelDrawer::Render(IView *v, const Vector3& teamColor)
{
	if (!glewInitialized) 
		SetupGL();

	if (!model->root)
		return;

	int S3ORendering=0;
	MdlObject *root = model->root;

	if (v->IsSelecting ())
		glDisable(GL_TEXTURE_2D);
	else if (v->GetRenderMode () == M3D_TEX)
		S3ORendering = SetupTextureMapping (v, teamColor);

	Matrix ident;
	ident.identity();
	RenderObject(root, v, model->mapping);

	if (S3ORendering > 0) {
		if (S3ORendering == 2)
			CleanupS3OAdvDrawing ();
		else if (S3ORendering == 1)
			CleanupS3OBasicDrawing ();
		glDisable (GL_TEXTURE_2D);
	}

	if (!v->IsSelecting ())
		RenderSelection (v);

	// draw radius
	if (v->GetConfig (CFG_DRAWRADIUS) != 0.0f)
	{
		glPushMatrix();
		glTranslatef(model->mid.x, model->mid.y, model->mid.z);
		glScalef(model->radius,model->radius,model->radius);
		glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
		glColor3ub(255,255,255);
		glDisable(GL_LIGHTING);
		glDisable(GL_CULL_FACE);
		glDisable(GL_TEXTURE_2D);
		glCallList(sphereList);
		glPopMatrix();
	}

	// draw height
	if (v->GetConfig (CFG_DRAWHEIGHT) != 0.0f)
	{
		glLineWidth (5.0f);

		glColor3ub (255,255,0);
		glBegin (GL_LINES);
		glVertex3i(0,0,0);
		glVertex3f(0.0f,model->height,0.0f);
		glEnd();

		glLineWidth (1.0f);
	}
}


void ModelDrawer::RenderSelection_ (MdlObject *o, IView *view)
{
	// setup object transformation
	Matrix tmp, mat;
	o->GetTransform (mat);
	mat.transpose (&tmp);
	glPushMatrix ();
	glMultMatrixf ( (float*)&tmp );

	glColor3ub (0,0,255);

	bool psel=view->GetConfig(CFG_POLYSELECT)!=0.0f;
	for (int a=0;a<o->poly.size();a++)
	{
		Poly *pl = o->poly[a];

		if ((o->isSelected && !psel) || (pl->isSelected && psel))
		{
			glBegin(GL_POLYGON);
			for (int b=0;b<pl->verts.size();b++)
				glVertex3fv ((float *)&o->verts[pl->verts[b]].pos);
			glEnd ();
		}
	}
	for (int a=0;a<o->childs.size();a++)
		RenderSelection_ (o->childs[a], view);

	glPopMatrix ();
}

void ModelDrawer::RenderSelection (IView *view)
{
	glEnable (GL_POLYGON_OFFSET_FILL);
	glPolygonOffset (0.0f, -10.0f);
	glDepthMask (GL_FALSE);

	ulong pattern[32], *i = pattern;
	ulong val = 0xCCCCCCCC;
	for (;i < pattern+32;) {
		*(i++)=val; *(i++)=val;
		val = ~val;
	}
	glPolygonStipple ((GLubyte *)&pattern[0]);
	glEnable (GL_POLYGON_STIPPLE);
	glDisable (GL_LIGHTING);
	glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
	glDisable (GL_CULL_FACE);

	if (model->root)
		RenderSelection_ (model->root, view);

	glDisable (GL_POLYGON_STIPPLE);
	glDisable (GL_POLYGON_OFFSET_FILL);
	glDepthMask (GL_TRUE);
	glPolygonOffset (0.0f, 0.0f);
}

void ModelDrawer::SetupS3OBasicDrawing (const Vector3& teamcol)
{
	glColor3f(1,1,1);

	// RGB = Texture * Alpha + Teamcolor * (1-Alpha)
	glActiveTextureARB(GL_TEXTURE0_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB_ARB, GL_INTERPOLATE_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE0_RGB_ARB, GL_TEXTURE);
	glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE1_RGB_ARB, GL_CONSTANT_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE2_RGB_ARB, GL_TEXTURE);
	glTexEnvi(GL_TEXTURE_ENV,GL_OPERAND2_RGB_ARB, GL_ONE_MINUS_SRC_ALPHA);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE_ARB);
	glEnable(GL_TEXTURE_2D);

	// set team color
	float tc[4]={teamcol.x,teamcol.y,teamcol.z,1.0f};
	glTexEnvfv(GL_TEXTURE_ENV,GL_TEXTURE_ENV_COLOR, tc);

	// bind texture 0
	glBindTexture (GL_TEXTURE_2D, model->textures[0]->glIdent);

	// RGB = Primary Color * Previous
	glActiveTextureARB(GL_TEXTURE1_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB_ARB, GL_MODULATE);
	glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE0_RGB_ARB, GL_PRIMARY_COLOR_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE1_RGB_ARB, GL_PREVIOUS_ARB);
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, whiteTexture);

	glActiveTextureARB(GL_TEXTURE0_ARB);

	glDisable(GL_ALPHA_TEST);
	glDisable(GL_BLEND);

	TestGLError ();
}

void ModelDrawer::CleanupS3OBasicDrawing ()
{
	glActiveTextureARB(GL_TEXTURE1_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
	glDisable(GL_TEXTURE_2D);

	glActiveTextureARB(GL_TEXTURE0_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
	glTexEnvi(GL_TEXTURE_ENV,GL_OPERAND2_RGB_ARB, GL_SRC_ALPHA);
	glDisable(GL_TEXTURE_2D);
}



void ModelDrawer::SetupS3OAdvDrawing (const Vector3& teamcol,IView *v)
{
	glEnable(GL_VERTEX_PROGRAM_ARB);
	glEnable(GL_FRAGMENT_PROGRAM_ARB);
	if (glIsEnabled(GL_LIGHTING)) {
		glBindProgramARB(GL_VERTEX_PROGRAM_ARB, s3oVP);
		glBindProgramARB(GL_FRAGMENT_PROGRAM_ARB, s3oFP);
	} else {
		glBindProgramARB(GL_VERTEX_PROGRAM_ARB, s3oVPunlit);
		glBindProgramARB(GL_FRAGMENT_PROGRAM_ARB, s3oFPunlit);
	}

	glProgramLocalParameter4fARB(GL_FRAGMENT_PROGRAM_ARB,0, teamcol.x, teamcol.y, teamcol.z,1.0f);
	
	glActiveTextureARB(GL_TEXTURE0_ARB);
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, model->textures [0]->glIdent);

	glActiveTextureARB(GL_TEXTURE1_ARB);
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, model->textures [1]->glIdent);

	glActiveTextureARB(GL_TEXTURE2_ARB);
	glEnable(GL_TEXTURE_CUBE_MAP_ARB);
	glBindTexture(GL_TEXTURE_CUBE_MAP_ARB, skyboxTexture);

	glActiveTextureARB(GL_TEXTURE0_ARB);
}

void ModelDrawer::CleanupS3OAdvDrawing ()
{
	glDisable(GL_VERTEX_PROGRAM_ARB);
	glDisable(GL_FRAGMENT_PROGRAM_ARB);

	glActiveTextureARB(GL_TEXTURE2_ARB);
	glDisable(GL_TEXTURE_CUBE_MAP_ARB);

	glActiveTextureARB(GL_TEXTURE1_ARB);
	glDisable(GL_TEXTURE_2D);

	glActiveTextureARB(GL_TEXTURE0_ARB);
	glDisable (GL_TEXTURE_2D);
}

char* LoadTextFile (string fn, int &l) 
{
	FILE *f = fopen(fn.c_str(), "rb");
	if (!f) {
		fltk::message ("Failed to open %s", fn.c_str());
		return 0;
	}
	fseek (f,0,SEEK_END);
	l=ftell(f);
	fseek (f,0,SEEK_SET);
	char *buf=new char[l];
	fread (buf,l,1,f);
	fclose (f);
	return buf;
}

uint LoadVertexProgram(string fn)
{
	int l;
    char *buf=LoadTextFile (fn ,l);
	if(!buf) return 0;

	uint ret;
	glGenProgramsARB( 1, &ret );
	glBindProgramARB( GL_VERTEX_PROGRAM_ARB,ret);

	glProgramStringARB (GL_VERTEX_PROGRAM_ARB,GL_PROGRAM_FORMAT_ASCII_ARB,l, buf);
	delete[] buf;

	if ( GL_INVALID_OPERATION == glGetError() )
	{
		// Find the error position
		GLint errPos;
		glGetIntegerv( GL_PROGRAM_ERROR_POSITION_ARB,&errPos );
		// Print implementation-dependent program
		// errors and warnings string.
		const GLubyte *errString=glGetString( GL_PROGRAM_ERROR_STRING_ARB);
		fltk::message ("Error at position %d when loading vertex program file %s:\n%s",errPos,fn.c_str(), errString);
		return 0;
	}
	return ret;
}

uint LoadFragmentProgram(string fn)
{
	int len;
	char* buf=LoadTextFile (fn, len);
	if(!buf) return 0;

	uint ret;
	glGenProgramsARB( 1, &ret );
	glBindProgramARB( GL_FRAGMENT_PROGRAM_ARB,ret);

	glProgramStringARB( GL_FRAGMENT_PROGRAM_ARB,GL_PROGRAM_FORMAT_ASCII_ARB,len,buf);

	if ( GL_INVALID_OPERATION == glGetError() )
	{
		// Find the error position
		GLint errPos;
		glGetIntegerv( GL_PROGRAM_ERROR_POSITION_ARB,&errPos );
		// Print implementation-dependent program
		// errors and warnings string.
		const GLubyte *errString=glGetString( GL_PROGRAM_ERROR_STRING_ARB);
		fltk::message("Error at position %d when loading fragment program file %s:\n%s",errPos,fn.c_str(),errString);
		return 0;
	}
	return ret;
}
