//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------

#ifndef JC_MODEL_DRAWER_H
#define JC_MODEL_DRAWER_H

#include "Model.h"
#include "VertexBuffer.h"

enum RenderMethod
{
	RM_S3OFULL,
	RM_S3OBASIC,
	RM_TEXTURE0COLOR,
	RM_TEXTURE1COLOR
};

// Cached rendering data for objects
struct RenderData : IRenderData
{
	RenderData() { drawList=0; }
	~RenderData();

	unsigned int drawList;

	void Invalidate ();
};


class ModelDrawer
{
public:
	ModelDrawer ();
	~ModelDrawer ();

	void SetRenderMethod (RenderMethod rm) { renderMethod=rm; }
	void SetModel (Model *mdl);
	void Render (IView *view, const Vector3& teamcolor);
    void RenderObject (MdlObject *o,IView *view, int mapping);
	void RenderPolygon (MdlObject *o, Poly *pl, IView *v, int mapping, bool allowSelect);
	void RenderSelection (IView *view);

protected:
	void RenderSelection_ (MdlObject *o, IView *view);
	void SetupS3OAdvDrawing (const Vector3& teamcol, IView *v);
	void SetupS3OBasicDrawing (const Vector3& teamcol);
	void CleanupS3OBasicDrawing ();
	void CleanupS3OAdvDrawing ();
	int SetupTextureMapping (IView *view, const Vector3& teamcolor);
	int SetupS3OTextureMapping (IView *view, const Vector3& teamcolor);
	void SetupGL ();

	bool glewInitialized;
	int canRenderS3O; // 0=no S3O style rendering, 1=only texture 0, 2=both textures
	RenderMethod renderMethod;
	Model *model;
	uint whiteTexture;

	uint s3oFP;
	uint s3oVP;
	uint s3oFPunlit;
	uint s3oVPunlit;
	uint skyboxTexture;

	uint sphereList; // display list for rendering a sphere
};


#endif // JC_MODEL_DRAWER_H
