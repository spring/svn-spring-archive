/*
 *  TextureLoader.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "TextureLoader.h"

#ifdef __APPLE__
	#include "QuicktimeLoader.h"
#else
	#include "DevilLoader.h"
#endif
#include "DDSLoader.h"

#include "Texture.h"
#include "EnvMap.h"
#include "MemTexture.h"
#include "MemLumTexture.h"

#include <boost/algorithm/string.hpp>

TextureLoader &TextureLoader::Instance()
{
	// inst is not initialized until first call of Instance!
	static TextureLoader inst;

	return inst;
}

Texture TextureLoader::LoadTexture(const std::string &filename, bool mipmaps)
{
	return SelectLoader(filename).LoadTexture(filename, mipmaps);
}

MemTexture TextureLoader::LoadMemTexture(const std::string &filename)
{
	return SelectLoader(filename).LoadMemTexture(filename);
}

EnvMap TextureLoader::LoadEnvMap(const std::string &filename)
{
	return SelectLoader(filename).LoadEnvMap(filename);
}

MemLumTexture TextureLoader::LoadMemLumTexture(const std::string &filename)
{
	return SelectLoader(filename).LoadMemLumTexture(filename);
}

bool TextureLoader::SaveMemTexture(const MemTexture &mtx, const std::string &filename)
{
	return SelectLoader(filename).SaveMemTexture(mtx, filename);
}

bool TextureLoader::SaveMemLumTexture(const MemLumTexture &mtx, const std::string &filename)
{
	return SelectLoader(filename).SaveMemLumTexture(mtx, filename);
}

TextureLoader::TextureLoader()
: general_(CreateGeneralLoader()), dds_(new DDSLoader())
{
}

ITextureLoader *TextureLoader::CreateGeneralLoader()
{
#ifdef __APPLE__
	return new QuicktimeLoader();
#else
	return new DevilLoader();
#endif
}

ITextureLoader &TextureLoader::SelectLoader(const std::string &tfilename)
{
	// Find out which loader we need to use
	std::string filename = boost::to_lower_copy(tfilename);
	if (filename.find(".dds", filename.length() - 4) 
			!= std::string::npos) {
		// Load the file using the ddsLoader
		return *dds_;
	}
	
	return *general_;
}
