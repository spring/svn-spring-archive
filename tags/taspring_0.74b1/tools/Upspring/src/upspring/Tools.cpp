//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------

#include "EditorIncl.h"
#include "EditorDef.h"
#include "View.h"
#include "Tools.h"
#include "Model.h"
#include "Texture.h"

#include <fltk/ColorChooser.h>
#include <IL/il.h>
#include <fltk/rgbImage.h>
#include <ZipFile.h>

// ------------------------------------------------------------------------------------------------
// CopyBuffer
// ------------------------------------------------------------------------------------------------

CopyBuffer::CopyBuffer ()
{}

CopyBuffer::~CopyBuffer ()
{
	Clear ();
}

void CopyBuffer::Clear ()
{
	for (int a=0;a<buffer.size();a++)
		delete buffer[a];
	buffer.clear();
}

void CopyBuffer::Copy (Model *mdl)
{
	Clear ();

	vector<MdlObject*> sel = mdl->GetSelectedObjects();
	for (int a=0;a<sel.size();a++) {
		if (sel[a]->HasSelectedParent ()) 
			continue; // the parent will be copied anyway

		buffer.push_back (sel[a]->Clone ());
	}
}

void CopyBuffer::Cut (Model *mdl)
{
	Clear ();

	for (;;) {
		vector <MdlObject *> sel = mdl->GetSelectedObjects ();
		if (sel.empty()) 
			break;

		MdlObject *obj = sel.front();
		if (obj->parent) {
			MdlObject *p=obj->parent;
			p->childs.erase(find(p->childs.begin(),p->childs.end(),obj));
			obj->parent = 0;
		} else {
			assert(mdl->root==obj);
			mdl->root=0;
		}

		obj->isSelected=false;
		buffer.push_back(obj);
	}
}

void CopyBuffer::Paste (Model *mdl, MdlObject *where)
{
	for (int a=0;a<buffer.size();a++) {
		if (where) {
			MdlObject *obj = buffer [a]->Clone();
			where->childs.push_back (obj);
			obj->parent = where;
			obj->isOpen=true;
		} else {
			if (mdl->root) {
				fltk::message ("There can only be one root object.");
				return;
			}
			mdl->root = buffer[a]->Clone();
			mdl->root->parent=0;
		}
	}
}

// ------------------------------------------------------------------------------------------------
// Toolbox controls
// ------------------------------------------------------------------------------------------------

void ModifyObjects(MdlObject *obj, Vector3 d, void (*fn)(MdlObject *obj, Vector3 d))
{
	fn (obj, d);
	for (int a=0;a<obj->childs.size();a++)
		ModifyObjects (obj->childs[a], d,fn);
}

static const float SpeedMod = 0.05f;
static const float AngleMod = 1.0f;

struct ECameraTool : Tool
{
	ECameraTool () : Tool()
	{
		isToggle = true;
		image = "camera";
	}

	bool toggle (bool enable)
	{
		return true;
	}

	void mouse (EditorViewWindow *view, int msg, Point move);
} static CameraTool;

// ------------------------- move -----------------------------

struct EMoveTool : Tool
{
	EMoveTool () : Tool()
	{
		isToggle = true;
		image = "move";
	}

	bool toggle(bool enable)
	{
		return true;
	}

	static void apply (MdlObject *obj, Vector3 d)
	{
		if (obj->isSelected)
			obj->position += d;
	}


	void mouse (EditorViewWindow *view, int msg, Point move)
	{
		Point m = move;

		if ((fltk::event_state () & fltk::ALT) && !(fltk::event_state() & fltk::CTRL))
		{
			CameraTool.mouse (view, msg, move);
			return;
		}

		if ((msg == fltk::MOVE || msg == fltk::DRAG) && (fltk::event_state () & fltk::BUTTON1))
		{
			Vector3 d;
			switch (view->GetMode())
			{
			case MAP_3D:
				return;
			case MAP_XY:
				d = Vector3 (m.x, -m.y, 0.0f);
				break;
			case MAP_XZ:
				d = Vector3 (m.x, 0.0f, -m.y);
				break;
			case MAP_YZ:
				d = Vector3 (0.0f, -m.y, m.x);
				break;
			}
			d /= view->cam.zoom;
			d *= SpeedMod;

			if (editor->GetMdl()->root)
				ModifyObjects(editor->GetMdl()->root, d, apply);
			editor->RedrawViews();
		}
		if(fltk::event_state() & fltk::BUTTON2)
			view->cam.MouseEvent(view, msg, move);

	}
}static  MoveTool;


void ECameraTool::mouse (EditorViewWindow *view, int msg, Point move)
{
	int s = fltk::event_state ();

	if ((fltk::event_state () & fltk::CTRL) && !(fltk::event_state() & fltk::ALT))
	{
		MoveTool.mouse (view, msg, move);
		return;
	}

	view->cam.MouseEvent (view, msg, move);
}


// ------------------------------ rotate ------------------------------

struct ERotateTool : public Tool
{
	ERotateTool () : Tool ()
	{
		image = "rotate";
		isToggle = true;
	}

	bool toggle (bool enabletool)
	{
		return true;
	}

	static void apply (MdlObject *n, Vector3 rot)
	{
		if (n->isSelected)
			n->rotation.AddEulerAbsolute(rot);
	}

	void mouse (EditorViewWindow *view, int msg, Point move)
	{
		if ((fltk::event_state () & fltk::ALT) && !(fltk::event_state() & fltk::CTRL))
		{
			CameraTool.mouse (view, msg, move);
			return;
		}

		if ((msg == fltk::DRAG || msg == fltk::MOVE) && (fltk::event_state () & fltk::BUTTON1))
		{
			Vector3 rot;
			float r = AngleMod * move.x / 180.0f * M_PI;
			switch (view->GetMode())
			{
			case MAP_3D:
				return;
			case MAP_XY:
				rot.set(0, 0, -r);
				break;
			case MAP_XZ:
				rot.set(0, -r, 0);
				break;
			case MAP_YZ:
				rot.set(-r, 0, 0);
				break;
			}

			if (editor->GetMdl()->root)
				ModifyObjects(editor->GetMdl()->root, rot, apply);
			editor->RedrawViews();
		}
		else if(fltk::event_state() & fltk::BUTTON2)
			view->cam.MouseEvent(view, msg, move);
	}
} static RotateTool;

// --------------------------------- scale --------------------------------------

struct EScaleTool : public Tool
{
	EScaleTool () : Tool ()
	{
		image = "scale";
		isToggle=true;
	}

	bool toggle(bool enabletool)
	{
		return true;
	}

	static void limitscale (Vector3 *s)
	{
		if(fabs(s->x) < EPSILON) s->x = (s->x >= 0) ? EPSILON : -EPSILON;
		if(fabs(s->y) < EPSILON) s->y = (s->y >= 0) ? EPSILON : -EPSILON;
		if(fabs(s->z) < EPSILON) s->z = (s->z >= 0) ? EPSILON : -EPSILON;
	}

	static void apply (MdlObject *obj, Vector3 scale)
	{
		if (obj->isSelected) {
			obj->scale *= scale;
			limitscale(&obj->scale);
		}
	}

	void mouse (EditorViewWindow *view, int msg, Point move)
	{
		if ((fltk::event_state () & fltk::ALT) && !(fltk::event_state() & fltk::CTRL))
		{
			CameraTool.mouse (view, msg, move);
			return;
		}

		if ((msg == fltk::DRAG || msg == fltk::MOVE) && ( fltk::event_state () & fltk::BUTTON1))
		{
			Vector3 s;
			float sx = 1.0f + move.x * 0.01f;
			float sy = 1.0f - move.y * 0.01f;

			switch (view->GetMode())
			{
			case MAP_3D:
				return;
			case MAP_XY:
				s = Vector3 (sx, sy, 1.0f);
				break;
			case MAP_XZ:
				s = Vector3 (sx, 1.0f, sy);
				break;
			case MAP_YZ:
				s = Vector3 (1.0f, sy, sx);
				break;
			}

			if (editor->GetMdl()->root)
				ModifyObjects(editor->GetMdl()->root, s, apply);
			editor->RedrawViews();
		}
		else if(fltk::event_state() & fltk::BUTTON2)
			view->cam.MouseEvent(view, msg, move);
	}

} static ScaleTool;

// --------------------------------- apply texture tool --------------------------------------

struct ETextureTool : Tool
{
	bool enabled;
	ETextureTool () : Tool()
	{
		image = "texture";
		isToggle = true;
		enabled=false;
	}

	static void applyTexture(MdlObject *o, Texture *tex)
	{
		for(int a=0;a<o->poly.size();a++) {
			if (o->poly[a]->isSelected) {
				o->poly[a]->texture = tex;
				o->poly[a]->texname = tex->name;
			}
		}
		for (int a=0;a<o->childs.size();a++)
			applyTexture(o->childs[a],tex);
	}

	static void callback(Texture *tex, void *data)
	{
		ETextureTool *tool = (ETextureTool *)data;
		Model *model = tool->editor->GetMdl();
		if (model->root) applyTexture(model->root,tex);
		tool->editor->RedrawViews();
	}

	static void deselect(MdlObject *o) {
		for (int a=0;a<o->poly.size();a++)
			o->poly[a]->isSelected=false;
	}

	bool toggle (bool enable)
	{
		if (enable) {
			editor->SetTextureSelectCallback (callback, this);
			MdlObject *r = editor->GetMdl()->root;
			if (r) IterateObjects(r,deselect);
		} else
			editor->SetTextureSelectCallback (0, 0);
		enabled=enable;
		return true;
	}

	bool needsPolySelect() {
		return enabled;
	}

	void mouse (EditorViewWindow *view, int msg, Point move)
	{
		CameraTool.mouse(view,msg,move);
	}
} static TextureMapTool;

// --------------------------------- Tools collection --------------------------------------

struct EPolyColorTool : Tool
{
	Vector3 color;

	EPolyColorTool () : Tool()
	{
		image = "color";
		isToggle = false;
	}

	static void applyColor (MdlObject *o, Vector3 color) {
		for (int a=0;a<o->poly.size();a++)
			 if (o->poly[a]->isSelected){
				o->poly[a]->color = color;
				o->poly[a]->texname.clear();
				o->poly[a]->texture=0;
			 }
		for (int a=0;a<o->childs.size();a++)
			applyColor (o->childs[a], color);
	}

	bool toggle (bool enable) { return true; }
	void click (){ 
		if (!fltk::color_chooser("Color for selected polygons", color.x, color.y, color.z))
			return;

		Model *m=editor->GetMdl();
		if (m->root) applyColor (m->root,color);
		editor->RedrawViews();
	}
} static PolygonColorTool;


struct EPolyFlipTool : Tool
{
	EPolyFlipTool () : Tool()
	{
		isToggle = false;
	}

	static void flip(MdlObject *o) {
		for (int a=0;a<o->poly.size();a++)
			 if (o->poly[a]->isSelected){
				 o->poly[a]->Flip ();
			 }
	}

	bool toggle (bool enable) { return true; }
	void click (){ 
		Model *m=editor->GetMdl();
		if (m->root) IterateObjects (m->root,flip);
		editor->RedrawViews();
	}
} static PolygonFlipTool;

// --------------------------------- Tools collection --------------------------------------
Tools::Tools ()
{
	camera = &CameraTool;
	move = &MoveTool;
	rotate = &RotateTool;
	scale = &ScaleTool;
	texmap = &TextureMapTool;
	color = &PolygonColorTool;
	flip = &PolygonFlipTool;
}

Tool* Tools::GetDefaultTool()
{
	return camera;
}

void Tools::Disable()
{
	camera->toggle(false);
	move->toggle(false);
	rotate->toggle(false);
	scale->toggle(false);
	texmap->toggle(false);
}

void Tools::SetEditor(IEditor *editor)
{
	Tool* tools[]={camera,move,rotate,scale,texmap,color,flip,0};
	for(int a=0;tools[a];a++)
		tools[a]->editor=editor;
}

void Tools::LoadImages()
{
	Tool* tools[]={camera,move,rotate,scale,texmap,color,flip,0};

	FILE *f = fopen("data.ups", "rb");
	if (!f) {
		fltk::message("Failed to load data.ups");
		return;
	}

	ZipFile zf;
	zf.Init(f);

	for(int a=0;tools[a];a++) {
		if (!tools[a]->image)
			continue;

		unsigned int id;
		ilGenImages (1, &id);
		ilBindImage (id);
		std::string fn= tools[a]->image;
		fn += ".gif";

		int zipIndex=-1;
		for (int fi=0;fi<zf.GetNumFiles();fi++) {
			char zfn [64];
			zf.GetFilename(fi, zfn, sizeof(zfn));
			if (!STRCASECMP(zfn, fn.c_str())) {
				zipIndex = fi;
				break;
			}
		}

		if (zipIndex>=0) {
			int len = zf.GetFileLen(zipIndex);
			char *buf = new char[len];
			zf.ReadFile(zipIndex, buf);

			if (!ilLoadL (IL_GIF, buf, len)) {
				ilDeleteImages (1, &id);
				fltk::message("Failed to load texture %s\n", fn.c_str());
				delete[] buf;
				continue;
			}
			delete[] buf;
			ilConvertImage (IL_RGBA, IL_UNSIGNED_BYTE);
			void *data = ilGetData();
			int w,h;
			ilGetIntegerv(IL_IMAGE_WIDTH, &w);
			ilGetIntegerv(IL_IMAGE_HEIGHT, &h);

			tools[a]->imageBuffer = new unsigned char[4*w*h];
			memcpy(tools[a]->imageBuffer, data, 4 * w* h);
			fltk::rgbImage *img = new fltk::rgbImage(tools[a]->imageBuffer, fltk::RGBA, w, h, tools[a]->image);
			ilDeleteImages(1, &id);

			tools[a]->button->image(img);
		} else
			fltk::message("Couldn't find %s", fn.c_str());
	}
	fclose(f);
}

