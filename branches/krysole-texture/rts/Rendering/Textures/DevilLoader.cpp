/*
 *  DevilLoader.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "DevilLoader.h"

#include <IL/il.h>

#include "FileSystem/FileHandler.h"

#include "Texture.h"
#include "MemTexture.h"
#include "MemLumTexture.h"
#include "EnvMap.h"
#include "MemTextureEffects.h"

DevilLoader::DevilLoader()
{
	ilInit();
}

DevilLoader::~DevilLoader()
{
	ilShutDown();
}

Texture DevilLoader::LoadTexture(const std::string &filename, bool mipmaps)
{
	std::size_t width = 0, height = 0;
	bool hasAlpha = false;

	// Load Texture Data
	unsigned char *data = LoadTextureData(filename, 
		width, height, hasAlpha);
	if (!data) {
		return Texture();
	}

	// If we don't yet have an alpha channel the fix the bytes
	// TODO: remove this if possible after i determine where
	//       its needed outside this subsystem
	MemTexture mtx(data, width, height, true);
	if (!hasAlpha) {
		mtxeffect::SetAlpha(mtx, 255);
	}

	return Texture(mtx.Bytes(), mtx.Width(), 
		mtx.Height(), mipmaps);
}

MemTexture DevilLoader::LoadMemTexture(const std::string &filename)
{
	std::size_t width = 0, height = 0;
	bool hasAlpha = false;

	// Load Texture Data
	unsigned char *data = LoadTextureData(filename, 
		width, height, hasAlpha);
	if (!data) {
		return MemTexture();
	}

	MemTexture mtx(data, width, height);

	// If we don't yet have an alpha channel then clear the bytes
	// TODO: remove this if possible after i determine where
	//       its needed outside this subsystem
	if (!hasAlpha) {
		mtxeffect::SetAlpha(mtx, 255);
	}

	return mtx;
}

MemLumTexture DevilLoader::LoadMemLumTexture(const std::string &filename)
{
	std::size_t width = 0, height = 0;

	// Load Bytes From File
	std::size_t sz = 0;
	unsigned char *resData = LoadResData(filename, sz);
	if (!resData) {
		return MemLumTexture();
	}

	// Decode the raw bytes in to usable texture data
	unsigned char *textureBytes = DecodeLumTextureData(
		resData, width, height, sz);

	// Clean up memory (texture memory is managed by Texture)
	delete[] resData;

	return MemLumTexture(textureBytes, width, height, true); // returns NULL if DecodeTex... fails
}

EnvMap DevilLoader::LoadEnvMap(const std::string &filename)
{
	// throw LoadTextureFailed("Devil Texture Loader Cannot Load Cube Maps!", filename);
	// TODO: generate warning message!
	return EnvMap();
}

bool DevilLoader::SaveMemTexture(const MemTexture &mtx, const std::string &filename)
{
	// We try to keep compression on and set the jpeg lossy quality level
	// These will be ignored if a different file format is used
	ilHint(IL_COMPRESSION_HINT, IL_USE_COMPRESSION);
	ilSetInteger (IL_JPG_QUALITY, 80);

	ILuint img = 0;
	ilGenImages(1, &img);
	ilBindImage(img);

	ilTexImage(mtx.Width(), mtx.Height(), 1, 4, IL_RGBA, IL_UNSIGNED_BYTE, NULL);
	 // we cast to prevent MemTexture from trying to copy memory
	ilSetData((void *)(const unsigned char *)mtx.Bytes());
	ilSaveImage((const ILstring)filename.c_str()); // ILstring == (wchar_t *)
	ilDeleteImages(1,&img);

	return true; // We currently aren't error checking...
}

bool DevilLoader::SaveMemLumTexture(const MemLumTexture &mtx, const std::string &filename)
{
	// We try to keep compression on and set the jpeg lossy quality level
	// These will be ignored if a different file format is used
	ilHint(IL_COMPRESSION_HINT, IL_USE_COMPRESSION);
	ilSetInteger (IL_JPG_QUALITY, 80);

	ILuint img = 0;
	ilGenImages(1, &img);
	ilBindImage(img);

	ilTexImage(mtx.Width(), mtx.Height(), 1, 1, IL_LUMINANCE, IL_UNSIGNED_BYTE, NULL);
	 // we cast to prevent MemTexture from trying to copy memory
	ilSetData((void *)(const unsigned char *)mtx.Bytes());
	ilSaveImage((const ILstring)filename.c_str()); // ILstring == (wchar_t *)
	ilDeleteImages(1,&img);

	return true; // We currently aren't error checking...
}

unsigned char *DevilLoader::LoadTextureData(const std::string &resName, 
	std::size_t &width, std::size_t &height, bool &hasAlpha)
{
	// Load Bytes From File
	std::size_t sz = 0;
	unsigned char *resData = LoadResData(resName, sz);
	if (!resData) {
		return NULL;
	}

	// Decode the raw bytes in to usable texture data
	unsigned char *textureBytes = DecodeTextureData(
		resData, width, height, hasAlpha, sz);

	// Clean up memory (texture memory is managed by Texture)
	delete[] resData;

	return textureBytes; // returns NULL if DecodeTex... fails
}

unsigned char *DevilLoader::LoadResData(const std::string &resName, std::size_t &resSize)
{
	CFileHandler file(resName);
	if  (!file.FileExists()) {
		return NULL;
	}

	unsigned char *mem = new unsigned char[file.FileSize() + 2]; // TODO: why + 2?
	file.Read(mem, file.FileSize());
	resSize = file.FileSize();
	
	return mem;
}

unsigned char *DevilLoader::DecodeTextureData(unsigned char *resData, 
	std::size_t &width, std::size_t &height, 
	bool &hasAlpha, std::size_t sz)
{
	ilOriginFunc(IL_ORIGIN_UPPER_LEFT);
	ilEnable(IL_ORIGIN_SET);

	ILuint img = 0;
	ilGenImages(1, &img);
	ilBindImage(img);

	// Load the data into our devil image
	if (!ilLoadL(IL_TYPE_UNKNOWN, resData, sz)) {
		return NULL;
	}

	// Get image stats
	hasAlpha = ilGetInteger(IL_IMAGE_BYTES_PER_PIXEL) == 4;
	width = ilGetInteger(IL_IMAGE_WIDTH);
	height = ilGetInteger(IL_IMAGE_HEIGHT);

	// Convert to RGBA to make our lives easy
	ilConvertImage(IL_RGBA, IL_UNSIGNED_BYTE);

	// Get memory out of devil
	unsigned char *data = new unsigned char[width * height * 4];
	std::memcpy(data, ilGetData(), width * height * 4);

	// Cleanup devil image used for this load
	ilDeleteImages(1, &img);

	return data;
}

unsigned char *DevilLoader::DecodeLumTextureData(unsigned char *resData, 
	std::size_t &width, std::size_t &height, 
	std::size_t sz)
{
	ilOriginFunc(IL_ORIGIN_UPPER_LEFT);
	ilEnable(IL_ORIGIN_SET);

	ILuint img = 0;
	ilGenImages(1, &img);
	ilBindImage(img);

	// Load the data into our devil image
	if (!ilLoadL(IL_TYPE_UNKNOWN, resData, sz)) {
		return NULL;
	}

	// Get image stats
	width = ilGetInteger(IL_IMAGE_WIDTH);
	height = ilGetInteger(IL_IMAGE_HEIGHT);

	// Convert to RGBA to make our lives easy
	ilConvertImage(IL_LUMINANCE, IL_UNSIGNED_BYTE);

	// Get memory out of devil
	unsigned char *data = new unsigned char[width * height];
	std::memcpy(data, ilGetData(), width * height);

	// Cleanup devil image used for this load
	ilDeleteImages(1, &img);

	return data;
}
