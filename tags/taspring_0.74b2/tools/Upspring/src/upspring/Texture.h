//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------
#ifndef JC_TEXTURE_H
#define JC_TEXTURE_H

class ZipFile;
class CfgList;

class Texture
{
	CR_DECLARE(Texture);
public:
	Texture ();
	Texture (const string& filename);
	Texture (const string& filename, const string& hintpath);
	Texture (void *buf, int len, const char *fn);
	~Texture ();

	bool Load (const string& filename, const string& hintpath);
	bool IsLoaded() { return ilIdent!=0; }
	bool VideoInit ();

	uint ilIdent;
	uint glIdent;
	string name;

	static string textureLoadDir;
protected:
	bool InitData();
};

// manages 3do textures
class TextureHandler
{
public:
	TextureHandler ();
	~TextureHandler ();

	bool Load (const char *zip); // load archive
	Texture* GetTexture (const char *name);

protected:
	Texture* LoadTexture (ZipFile *zf, int index, const char *name);

	struct TexRef {
		TexRef (){zip=index=0; texture=0; }

		int zip;
		int index;
		Texture *texture;
	};

	vector <ZipFile *> zips;
	map <string, TexRef> textures;

	friend class TexGroupUI;
};


class TextureGroup
{
public:
	string name;
	set <Texture *> textures;
};

class TextureGroupHandler
{
public:
	TextureGroupHandler(TextureHandler *th);
	~TextureGroupHandler();

	bool Load (const char *fname);
	bool Save (const char *fname);

	CfgList* MakeConfig (TextureGroup *tg);
	TextureGroup* LoadGroup (CfgList *cfg);


	vector <TextureGroup*> groups;
	TextureHandler *textureHandler;
};


#endif // JC_TEXTURE_H
