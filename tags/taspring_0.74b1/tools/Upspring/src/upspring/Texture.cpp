//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------
#include "EditorIncl.h"
#include "EditorDef.h"
#include "Texture.h"
#include "ZipFile.h"
#include "Util.h"
#include "CfgParser.h"

#include <IL/il.h>
#include <IL/ilu.h>
#include <IL/ilut.h>

// ------------------------------------------------------------------------------------------------
// Texture
// ------------------------------------------------------------------------------------------------

CR_BIND(Texture);
CR_REG_METADATA(Texture, (CR_MEMBER(name), CR_MEMBER(glIdent), CR_MEMBER(ilIdent)));

string Texture::textureLoadDir;

Texture::Texture() {}

Texture::Texture (const string& fn) {
	Load (fn, string());
}

Texture::Texture (const string& fn, const string& hintpath) {
	Load (fn, hintpath);
}

bool Texture::Load (const string& fn, const string& hintpath)
{
	name = fltk::filename_name(fn.c_str());
	glIdent = 0;

	ilOriginFunc (IL_ORIGIN_UPPER_LEFT);
	ilEnable (IL_ORIGIN_SET);

	ilGenImages (1, &ilIdent);
	ilBindImage (ilIdent);

	vector<string> paths;

	paths.push_back ("");
	if (!hintpath.empty()) paths.push_back (hintpath);
	if (!textureLoadDir.empty ()) paths.push_back (textureLoadDir);

	bool loaded=false;
	for (int a=0;a<paths.size();a++)
	{
		string nfn = paths[a] + fn;

		if (ilLoadImage ((const ILstring)nfn.c_str()))
		{
			loaded=true;
			break;
		}
	}
	if (!loaded)
	{
		ilDeleteImages (1, &ilIdent);
		ilIdent = 0;

		logger.Trace (NL_Error, "Failed to load texture %s\n", fn.c_str());
		return false;
	}

	InitData();
	return true;
}

Texture::Texture (void *buf, int len, const char *_name)
{
	name = _name;
	glIdent = 0;

	ilGenImages (1, &ilIdent);
	ilBindImage (ilIdent);

	if (!ilLoadL (IL_TYPE_UNKNOWN, buf, len)) {
		ilDeleteImages (1, &ilIdent);
		ilIdent = 0;

		logger.Trace (NL_Error, "Failed to load texture %s\n", _name);
		return;
	}
	InitData ();
}

bool Texture::InitData() {
	if (!ilConvertImage (IL_RGBA, IL_UNSIGNED_BYTE))
	{
		logger.Trace(NL_Error, "Failed to convert image to RGBA format.\n");
		return false;
	}
	iluFlipImage ();
	return true;
}


Texture::~Texture()
{
	if (glIdent) {
		glDeleteTextures (1, &glIdent);
		glIdent = 0;
	}

	if (ilIdent) {
		ilDeleteImages (1, &ilIdent);
		ilIdent = 0;
	}
}

bool Texture::VideoInit ()
{
	if (!ilIdent)
		return false;

	ilBindImage (ilIdent);
	ILubyte* data = ilGetData ();

	glGenTextures (1, &glIdent);
	glBindTexture (GL_TEXTURE_2D, glIdent);

	if (!ilutGLBuildMipmaps ()) {
		logger.Trace(NL_Debug, "Failed to create mipmaps\n");
		return false;
	}

    return glIdent != 0;
}


// ------------------------------------------------------------------------------------------------
// TextureHandler
// ------------------------------------------------------------------------------------------------


TextureHandler::TextureHandler ()
{}


TextureHandler::~TextureHandler ()
{
	for (int a=0;a<zips.size();a++) {
		delete zips[a];
	}
	zips.clear();

	for (map<string,TexRef>::iterator ti=textures.begin();ti!=textures.end();++ti)
		SAFE_DELETE(ti->second.texture);
	textures.clear();
}


Texture* TextureHandler::GetTexture(const char *name)
{
	string tmp=name;
	transform(tmp.begin(),tmp.end(),tmp.begin(),tolower);

	map<string,TexRef>::iterator ti = textures.find(tmp);
	if (ti == textures.end()) {
		tmp += "00";
		ti = textures.find(tmp);
		if (ti == textures.end()) {
			logger.Trace(NL_Debug,"Texture %s not found.\n", tmp.c_str());
			return 0;
		}
		return ti->second.texture;
	}


	return ti->second.texture;
}

Texture* TextureHandler::LoadTexture (ZipFile*zf,int index, const char *name)
{
	int len=zf->GetFileLen (index);
	char *buf=new char[len];
	TError r = zf->ReadFile (index, buf);

	if (r==RET_FAIL) {
		logger.Trace (NL_Debug, "Failed to read texture file %s from zip\n",name);
		delete[] buf;
		return 0;
	}

	Texture *tex = new Texture (buf, len, name);
	if (!tex->IsLoaded ()) {
		delete[] buf;
		delete tex;
		return 0;
	}

	//logger.Trace(NL_Debug, "Texture %s loaded.\n", name);

	delete[] buf;
	return tex;
}


static char *FixTextureName (char *temp)
{
	// make it lowercase
	strlwr (temp);

	// remove extension
	int i=strlen (temp)-1;
	char *ext=0;
	while (i>0) {
		if ( temp[i] == '.'){
			temp[i]=0;
			ext=&temp[i+1];
			break;
		}
		i--;
	}

	string fn;

	i=strlen(temp)-1;
	while (i>0) {
		if (temp[i]=='/' || temp[i] =='\\') {
			fn = &temp[i+1];
			break;
		}
		i--;
	}
	strcpy (temp,fn.c_str());
	return ext;
}

bool TextureHandler::Load (const char *zip) 
{
	FILE *f = fopen (zip, "rb");

	if (f) {
		ZipFile *zf = new ZipFile;
		if (zf->Init (f) == RET_FAIL) {
			logger.Trace (NL_Error, "Failed to load zip archive %s\n", zip);
			fclose (f);
			return false;
		}

		const char *imgExt[]={ "bmp", "jpg", "tga", "png", "dds", "pcx", "pic", "gif", "ico", 0 };

		// Add the zip entries to the texture set
		for (int a=0;a<zf->GetNumFiles ();a++)
		{
			char tempFile[64];
			zf->GetFilename (a, tempFile, sizeof(tempFile));

			char *ext=FixTextureName (tempFile);
			if (ext)
			{
				int x=0;
				for (x=0;imgExt[x];x++)
					if (!strcmp(imgExt[x],ext)) break;

				if (!imgExt[x])
					continue;

				if (textures.find(tempFile) != textures.end())
					continue;

				TexRef ref;
				ref.zip = zips.size();
				ref.index = a;
				ref.texture = LoadTexture (zf,a, tempFile);

				textures[tempFile]=ref;
			}
		}

		fclose (f);

		zips.push_back (zf);
	}

	return false;
}

// ------------------------------------------------------------------------------------------------
// TextureGroupHandler
// ------------------------------------------------------------------------------------------------

TextureGroupHandler::TextureGroupHandler (TextureHandler *th) 
{
	textureHandler = th;
}

TextureGroupHandler::~TextureGroupHandler ()
{
	for (int a=0;a<groups.size();a++) {
		delete groups[a];
	}
	groups.clear();
}

bool TextureGroupHandler::Load(const char *fn)
{
	CfgList *cfg = CfgValue::LoadFile (fn);

	if (!cfg) 
		return false;

	for (list<CfgListElem>::iterator li = cfg->childs.begin(); li != cfg->childs.end(); ++li) {
		CfgList *gc = dynamic_cast<CfgList*>(li->value);
		if (!gc) continue;

		LoadGroup (gc);
	}

	delete cfg;
	return true;
}

bool TextureGroupHandler::Save(const char *fn)
{
	// open a cfg writer
	CfgWriter writer(fn);
	if (writer.IsFailed()) {
		fltk::message ("Unable to save texture groups to %s\n", fn);
		return false;
	}

	// create a config list and save it
	CfgList cfg;

	for (int a=0;a<groups.size();a++) {
		CfgList *gc=MakeConfig(groups[a]);

		char n [10];
		sprintf (n, "group%d", a);
		cfg.AddValue (n, gc);
	}

	cfg.Write(writer,true);
	return true;
}

TextureGroup* TextureGroupHandler::LoadGroup (CfgList *gc) {
	CfgList *texlist = dynamic_cast<CfgList*>(gc->GetValue("textures"));
	if (!texlist) return 0;

	TextureGroup *texGroup=new TextureGroup;
	texGroup->name = gc->GetLiteral("name", "unnamed");

	for (list<CfgListElem>::iterator i=texlist->childs.begin();i!=texlist->childs.end();i++) {
		CfgLiteral *l=dynamic_cast<CfgLiteral*>(i->value);
		if (l && !l->value.empty()) {
			Texture *texture = textureHandler->GetTexture(l->value.c_str());
			if (texture) 
				texGroup->textures.insert(texture);
			else {
				logger.Trace(NL_Debug, "Discarded texture name: %s\n", l->value.c_str());
			}
		}
	}
	groups.push_back(texGroup);
	return texGroup;
}

CfgList* TextureGroupHandler::MakeConfig (TextureGroup *tg)
{
	CfgList *gc = new CfgList;
	char n [10];

	CfgList *texlist=new CfgList;
	int index=0;
	for (set<Texture*>::iterator t=tg->textures.begin();t!=tg->textures.end();++t) {
		sprintf (n,"tex%d", index++);
		texlist->AddLiteral (n, (*t)->name.c_str());
	}
	gc->AddValue ("textures", texlist);
	gc->AddLiteral ("name", tg->name.c_str());
	return gc;
}

