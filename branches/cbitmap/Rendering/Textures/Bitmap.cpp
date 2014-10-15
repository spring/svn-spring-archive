#include "StdAfx.h"
// Bitmap.cpp: implementation of the CBitmap class.
//
//////////////////////////////////////////////////////////////////////

#include "Rendering/GL/myGL.h"
#include <ostream>
#include <fstream>
#include "FileSystem/FileHandler.h"
#include "Platform/FileSystem.h"
#include "Rendering/Textures/Bitmap.h"
#include "bitops.h"
#include "mmgr.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CBitmap::CBitmap()
  : xsize(0), ysize(0)
{
	mem=0;
	type = BitmapTypeStandardRGBA;
}

CBitmap::~CBitmap()
{
	delete[] mem;
}

CBitmap::CBitmap(const CBitmap& old)
{
	type = old.type;
	xsize=old.xsize;
	ysize=old.ysize;
	int size;
	if(type == BitmapTypeStandardRGBA) 	size = xsize*ysize*4;
	else size = xsize*ysize; // Alpha

	mem=SAFE_NEW unsigned char[size];
	memcpy(mem,old.mem,size);
}

CBitmap::CBitmap(unsigned char *data, int xsize, int ysize)
  : xsize(xsize), ysize(ysize)
{
	type = BitmapTypeStandardRGBA;
	mem=SAFE_NEW unsigned char[xsize*ysize*4];
	memcpy(mem,data,xsize*ysize*4);
}

CBitmap& CBitmap::operator=(const CBitmap& bm)
{
	if( this != &bm ){
		delete[] mem;
		xsize=bm.xsize;
		ysize=bm.ysize;
		int size;
		if(type == BitmapTypeStandardRGBA) 	size = xsize*ysize*4;
		else size = xsize*ysize; // Alpha

		mem=SAFE_NEW unsigned char[size];
		memcpy(mem,bm.mem,size);
	}
	return *this;
}

void CBitmap::Alloc (int w,int h)
{
	delete[] mem;
	xsize=w;
	ysize=h;
	type=BitmapTypeStandardRGBA;
	mem=SAFE_NEW unsigned char[w*h*4];
	memset(mem, 0, w*h*4);
}

bool CBitmap::Load(string const& filename)
{
	MemTexture mtx = TextureLoader::Instance().LoadMemTexture(filename);

	if (!mtx) {
		return false;
	}

	CopyMTXBuffer(mtx);

	return true;
}

bool CBitmap::LoadGrayscale (const string& filename)
{
	MemLumTexture mtx = TextureLoader::Instance().LoadMemLumTexture(filename);

	if (!mtx) {
		return false;
	}

	CopyMTXBuffer(mtx);

	return true;
}


void CBitmap::Save(string const& filename)
{
	if (type == BitmapTypeStandardRGBA) {
		MemTexture mtx(mem, xsize, ysize);
		TextureLoader::Instance().SaveMemTexture(mtx, filename);
	} else { // Assume its BitmapTypeStandardAlpha
		MemLumTexture mltx(mem, xsize, ysize);
		TextureLoader::Instance().SaveMemLumTexture(mltx, filename);
	}
}

#ifndef BITMAP_NO_OPENGL

unsigned int CBitmap::CreateTexture(bool mipmaps)
{
	if(mem==NULL)
		return 0;

	// jcnossen: Some drivers return "2.0" as a version string, 
	// but switch to software rendering for non-power-of-two textures.
	// GL_ARB_texture_non_power_of_two indicates that the hardware will actually support it.
	if ((xsize != next_power_of_2(xsize) || ysize != next_power_of_2(ysize)) && !GLEW_ARB_texture_non_power_of_two)
		 //&& strcmp(reinterpret_cast<const char*>(glGetString(GL_VERSION)), "2.0") < 0 )
	{
		CBitmap bm = CreateRescaled(next_power_of_2(xsize), next_power_of_2(ysize));
		return bm.CreateTexture(mipmaps);
	}

	unsigned int texture;

	glGenTextures(1, &texture);			
	glBindTexture(GL_TEXTURE_2D, texture);

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	if(mipmaps)
	{
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);

		// create mipmapped texture
		if (strcmp(reinterpret_cast<const char*>(glGetString(GL_VERSION)), "1.4") >= 0) {
			// This required GL-1.4
			// instead of using glu, we rely on glTexImage2D to create the Mipmaps.
			glTexParameteri(GL_TEXTURE_2D,GL_GENERATE_MIPMAP,true);
			glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA8 ,xsize, ysize, 0,GL_RGBA, GL_UNSIGNED_BYTE, mem);
		} else
			gluBuild2DMipmaps(GL_TEXTURE_2D,GL_RGBA8 ,xsize, ysize,GL_RGBA, GL_UNSIGNED_BYTE, mem);
	}
	else
	{
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
		//glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA8 ,xsize, ysize, 0,GL_RGBA, GL_UNSIGNED_BYTE, mem);
		//gluBuild2DMipmaps(GL_TEXTURE_2D,GL_RGBA8 ,xsize, ysize, GL_RGBA, GL_UNSIGNED_BYTE, mem);

		glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA8 ,xsize, ysize, 0,GL_RGBA, GL_UNSIGNED_BYTE, mem);
	}
	return texture;
}

#endif // !BITMAP_NO_OPENGL

void CBitmap::CreateAlpha(unsigned char red,unsigned char green,unsigned char blue)
{
	MemTexture mtx(mem, xsize, ysize, true); // will delete mem for us

	mtxeffect::AlphaWithColorKey(mtx, red, green, blue);

	CopyMTXBuffer(mtx); // save new buffer
}

void CBitmap::SetAlpha(unsigned char alpha)
{
	MemTexture mtx(mem, xsize, ysize, true); // will delete mem for us

	mtxeffect::SetAlpha(mtx, alpha);

	CopyMTXBuffer(mtx);
}

// Depreciated (Only used by GUI which will be replaced by CEGUI anyway)
void CBitmap::SetTransparent( unsigned char red, unsigned char green, unsigned char blue )
{
	MemTexture mtx(mem, xsize, ysize, true); // will delete mem for us

	mtxeffect::AlphaWithColorKeyWithoutFix(mtx, red, green, blue);

	CopyMTXBuffer(mtx); // save new buffer
}

void CBitmap::Renormalize(float3 newCol)
{
	MemTexture mtx(mem, xsize, ysize, true); // will delete mem for us

	mtxeffect::Renormalize(mtx, newCol);

	CopyMTXBuffer(mtx); // save new buffer
}

CBitmap CBitmap::CreateRescaled(int newx, int newy)
{
	CBitmap bm(*this);

	MemTexture mtx(bm.mem, bm.xsize, bm.ysize, true);

	bm.CopyMTXBuffer(mtxeffect::ScaleToSize(mtx, newx, newy));

	return bm;
}

void CBitmap::ReverseYAxis(void)
{
	MemTexture mtx(mem, xsize, ysize, true); // will delete mem for us

	CopyMTXBuffer(mtxeffect::Flip(mtx)); // save new buffer
}

void CBitmap::CopyMTXBuffer(const MemTexture &mtx)
{
	xsize = mtx.Width();
	ysize = mtx.Height();
	mem = new unsigned char[xsize * ysize * 4];
	memcpy(mem, mtx.Bytes(), xsize*ysize*4);

	type = BitmapTypeStandardRGBA;
}

void CBitmap::CopyMTXBuffer(const MemLumTexture &mtx)
{
	xsize = mtx.Width();
	ysize = mtx.Height();
	mem = new unsigned char[xsize * ysize];
	memcpy(mem, mtx.Bytes(), xsize*ysize);

	type = BitmapTypeStandardAlpha;
}
