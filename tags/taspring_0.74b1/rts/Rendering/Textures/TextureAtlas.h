#pragma once

#include <string>
#include <vector>
#include <map>

#include "creg/creg.h"

//Class for combining multiple bitmaps into one large singel bitmap.
struct AtlasedTexture
{
public:
	CR_DECLARE_STRUCT(AtlasedTexture);
	float xstart;
	float xend;
	float ystart;
	float yend;

	int ixstart,iystart;
};

class CTextureAtlas
{
public:

	unsigned int gltex;

	CTextureAtlas(int maxxSize, int maxySize);
	~CTextureAtlas(void);

	enum TextureType {
		RGBA32
	};
	//Add a texture from a memory pointer returns -1 if failed.
	int AddTexFromMem(std::string name, int xsize, int ysize, TextureType texType, void  *data);

	//Add a texture from a file, returns -1 if failed.
	int AddTexFromFile(std::string name, std::string file);

	void Update(std::string name, void  *data);

	//Creates the atlas containing all the specified textures.
	//return true if suceeded, false if all textures didn't fit into the specified maxsize.
	bool Finalize();

	void BindTexture();

	//return a Texture struct of the specified texture
	AtlasedTexture GetTexture(std::string name);

	//return a pointer to a Texture struct of the specified texture, this pointer points to the actuall Texture struct stored, do not delete or modify
	AtlasedTexture* GetTexturePtr(std::string name);

protected:
	struct MemTex
	{
		std::vector<std::string> names;
		int xsize;
		int ysize;
		TextureType texType;
		int xpos,ypos;
		void *data;
	};

	//temporary storage of all textures
	std::vector<MemTex*> memtextures;
	std::map<std::string, MemTex*> files;

	std::map<std::string, AtlasedTexture> textures;
	int maxxsize;
	int maxysize;
	int xsize;
	int ysize;
	int usedPixels;
	bool initialized;

	int GetBPP(TextureType tetxType);
	static int CompareTex(MemTex *tex1, MemTex *tex2);
	bool IncreaseSize();
	void CreateTexture();
};
