/*
 *  MemTextureEffects.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "MemTextureEffects.h"

#include "Texture.h"
#include "MemTexture.h"

#include "System/bitops.h"

namespace mtxeffect {

	void AlphaWithColorKey(MemTexture &mtx, 
		unsigned char red, unsigned char green, unsigned char blue)
	{
		std::size_t width = mtx.Width();
		std::size_t height = mtx.Height();
		std::size_t total = mtx.SizeBytes(); // not npixels
		unsigned char *mem = mtx.Bytes();

		// This function was taken from the orig CBitmap class...
		float3 aCol;
		unsigned int cCol[3] = {0, 0, 0};
		unsigned int numCounted = 0;

		for (int i = 0; i < total; i += 4) {
			if(mem[i + 3]!=0 && !(mem[i + 0] == red && 
					mem[i + 1] == green && mem[i + 2] == blue)) {
				for (int j = 0; j < 3; ++j) {
					cCol[j] += mem[i + j];
				}
				++numCounted;
			}
		}
		if (numCounted > 0) {
			for (int i = 0; i < 3; ++i) {
				aCol[i] = cCol[i] / 255.0f / numCounted;
			}
		}
		for (int i = 0; i < total; i += 4)
		{
			if(mem[i + 0] == red && mem[i + 1] == green && 
					mem[i + 2] == blue) {
				mem[i + 0] = (unsigned char)(aCol.x*255);
				mem[i + 1] = (unsigned char)(aCol.y*255);
				mem[i + 2] = (unsigned char)(aCol.z*255);
				mem[i + 3] = 0;
			}
		}
	}

	void AlphaWithColorKeyWithoutFix(MemTexture &mtx, 
		unsigned char red, unsigned char green, unsigned char blue)
	{
		std::size_t total = mtx.SizeBytes(); // note npixels

		unsigned char *bytes = mtx.Bytes();

		for (std::size_t i = 0; i < total; i += 4) {
			if (	bytes[i + 0] == red &&
					bytes[i + 1] == green &&
					bytes[i + 2] == blue) {
				bytes[i + 3] = 0;
			}
		}
	}

	MemTexture ScaleToSize(const MemTexture &mtx, 
		std::size_t newWidth, std::size_t newHeight)
	{
		// Taken from the orig CBitmap class
		MemTexture tm(newWidth, newHeight);

		const unsigned char *mem = mtx.Bytes();
		unsigned char *newmem = tm.Bytes();

		float dx= float(mtx.Width()) / newWidth;
		float dy= float(mtx.Height()) / newHeight;

		float cy=0;
		for(int y=0;y<newHeight;++y){
			int sy=(int)cy;
			cy+=dy;
			int ey=(int)cy;
			if(ey==sy)
				ey=sy+1;

			float cx=0;
			for(int x=0;x<newWidth;++x){
				int sx=(int)cx;
				cx+=dx;
				int ex=(int)cx;
				if(ex==sx)
					ex=sx+1;

				int r=0,g=0,b=0,a=0;
				for(int y2=sy;y2<ey;++y2){
					for(int x2=sx;x2<ex;++x2){
						r+=mem[(y2*mtx.Width()+x2)*4+0];
						g+=mem[(y2*mtx.Width()+x2)*4+1];
						b+=mem[(y2*mtx.Width()+x2)*4+2];
						a+=mem[(y2*mtx.Width()+x2)*4+3];
					}
				}
				newmem[(y*newWidth+x)*4+0]=r/((ex-sx)*(ey-sy));
				newmem[(y*newWidth+x)*4+1]=g/((ex-sx)*(ey-sy));
				newmem[(y*newWidth+x)*4+2]=b/((ex-sx)*(ey-sy));
				newmem[(y*newWidth+x)*4+3]=a/((ex-sx)*(ey-sy));
			}	
		}

		return tm;
	}

	void SetAlpha(MemTexture &mtx, unsigned char alpha)
	{
		std::size_t total = mtx.SizeBytes();

		unsigned char *bytes = mtx.Bytes();

		for (std::size_t i = 0; i < total; i += 4) {
			bytes[i + 3] = alpha;
		}
	}

	Texture Create1x1Texture(unsigned char red, unsigned char green, 
		unsigned char blue, unsigned char alpha)
	{
		unsigned char raw[4];

		raw[0] = red;
		raw[1] = green;
		raw[2] = blue;
		raw[3] = alpha;

		return Texture(raw, 1, 1, false);
	}

	MemTexture Create1x1MemTexture(unsigned char red, unsigned char green, 
		unsigned char blue, unsigned char alpha)
	{
		unsigned char raw[4];

		raw[0] = red;
		raw[1] = green;
		raw[2] = blue;
		raw[3] = alpha;

		return MemTexture(raw, 1, 1);
	}
	
	MemTexture Flip(const MemTexture &mtx)
	{
		std::size_t width = mtx.Width();
		std::size_t height = mtx.Height();

		MemTexture nm(width, height);

		const unsigned char *src = mtx.Bytes();
		unsigned char *dst = nm.Bytes();

		for (int y = 0; y < height; ++y){
			for (int x = 0; x < width; ++x){
				std::size_t srcPixel = (y * width + x) * 4;
				std::size_t dstPixel = ((height - 1 - y) * width + x) * 4;

				dst[dstPixel + 0] = src[srcPixel + 0];
				dst[dstPixel + 1] = src[srcPixel + 1];
				dst[dstPixel + 2] = src[srcPixel + 2];
				dst[dstPixel + 3] = src[srcPixel + 3];
			}
		}

		return nm;
	}
	
	void Renormalize(MemTexture mtx, const float3 &newCol)
	{
		// NOTE: this algorithm was copied from the old CBitmap class
		unsigned char *mem = mtx.Bytes();
		std::size_t xsize = mtx.Width();
		std::size_t ysize = mtx.Height();

		float3 aCol;
		//	float3 aSpread;

		float3 colorDif;
		//	float3 spreadMul;
		for(int a=0;a<3;++a){
			int cCol=0;
			int numCounted=0;
			for(int y=0;y<ysize;++y){
				for(int x=0;x<xsize;++x){
					if(mem[(y*xsize+x)*4+3]!=0){
						cCol+=mem[(y*xsize+x)*4+a];
						++numCounted;
					}
				}
			}
			aCol[a]=cCol/255.0f/numCounted;
			cCol/=xsize*ysize;
			colorDif[a]=newCol[a]-aCol[a];

	/*		int spread=0;
			for(int y=0;y<ysize;++y){
			for(int x=0;x<xsize;++x){
			if(mem[(y*xsize+x)*4+3]!=0){
			int dif=mem[(y*xsize+x)*4+a]-cCol;
			spread+=abs(dif);
			}
			}
			}
			aSpread.xyz[a]=spread/255.0f/numCounted;
			spreadMul.xyz[a]=(float)(newSpread[a]/aSpread[a]);*/
		}
		for(int a=0;a<3;++a){
			for(int y=0;y<ysize;++y){
				for(int x=0;x<xsize;++x){
					float nc=float(mem[(y*xsize+x)*4+a])/255.0f+colorDif[a];
					/*				float r=newCol.xyz[a]+(nc-newCol.xyz[a])*spreadMul.xyz[a];*/
					mem[(y*xsize+x)*4+a]=(unsigned char)(std::min(255.f,std::max(0.f,nc*255)));
				}
			}
		}
	}
	
	MemTexture CreatePow2Aligned(const MemTexture &old)
	{
		MemTexture mtx(next_power_of_2(old.Width()), 
			next_power_of_2(old.Height()));

		// Clear to transparent and black
		memset(mtx.Bytes(), 0, mtx.SizeBytes());

		// This puts the old bitmap in the bottom left corner of our new
		// power of two oversized bitmap... or the 0,0 tex coord in opengl
		const unsigned char *src = old.Bytes();
		unsigned char *dst = mtx.Bytes();
		std::size_t width = old.Width();
		std::size_t height = old.Height();
		std::size_t vOffset = mtx.Height() - old.Height();
		std::size_t stride = mtx.Width();
		for (std::size_t y = 0; y < old.Height(); ++y) {
			for (std::size_t x = 0; x < old.Width(); ++x) {
				std::size_t dstIndex = (y + vOffset) * stride + x;
				std::size_t srcIndex = (y * width) + x;

				dst[dstIndex * 4 + 0] = src[srcIndex * 4 + 0];
				dst[dstIndex * 4 + 1] = src[srcIndex * 4 + 1];
				dst[dstIndex * 4 + 2] = src[srcIndex * 4 + 2];
				dst[dstIndex * 4 + 3] = src[srcIndex * 4 + 3];
			}
		}

		return mtx;
	}

}
