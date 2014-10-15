// Bitmap.h: interface for the CBitmap class.
//
//////////////////////////////////////////////////////////////////////

#ifndef __BITMAP_H__
#define __BITMAP_H__

#include <string>

#include "Platform/Win/win32.h"
#include "Rendering/Textures.h"
#include "Rendering/GL/myGL.h"

using std::string;

class CBitmap  
{
public:
	CBitmap(unsigned char* data,int xsize,int ysize);
	CBitmap();
	CBitmap(const CBitmap& old);
	CBitmap& operator=(const CBitmap& bm);

	virtual ~CBitmap();

	void Alloc(int w,int y);
	bool Load(string const& filename);
	bool LoadGrayscale(string const& filename);
	void Save(string const& filename);

	unsigned int CreateTexture(bool mipmaps=false);
	unsigned int CreateDDSTexture();

	void CreateAlpha(unsigned char red,unsigned char green,unsigned char blue);
	void SetTransparent(unsigned char red, unsigned char green, unsigned char blue);

	void SetAlpha(unsigned char alpha);

	void Renormalize(float3 newCol);

	unsigned char* mem;
	int xsize;
	int ysize;

	enum BitmapType
	{
		BitmapTypeStandardRGBA,
		BitmapTypeStandardAlpha
	};
	int type;

public:
	CBitmap CreateRescaled(int newx, int newy);
	void ReverseYAxis(void);
	void CopyMTXBuffer(const MemTexture &mtx);
	void CopyMTXBuffer(const MemLumTexture &mtx);
};

#endif // __BITMAP_H__
