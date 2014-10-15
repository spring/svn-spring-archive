/*
 *  DDSLoader.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "DDSLoader.h"

#include "Texture.h"
#include "MemTexture.h"
#include "MemLumTexture.h"
#include "EnvMap.h"
#include "nv_dds.h"

#include "Rendering/GL/myGL.h"
#include "System/bitops.h"

Texture DDSLoader::LoadTexture(const std::string &filename, bool mipmaps)
{
	// NOTE: normally mipmaps is ignored here since they're probably already generated

	nv_dds::CDDSImage ddsimage;
	
	// Make sure the image isn't flipped, that way its still in the DX coord system
	// which is what we use!
	ddsimage.load(filename, false);
	
	if (ddsimage.get_type() != nv_dds::TextureFlat) {
		//throw LoadTextureFailed("DDS texture is not a 2D flat texture!", filename);
		// TODO: generate warning message!
		return Texture();
	}

	if (ddsimage.get_width() != next_power_of_2(ddsimage.get_width()) ||
			ddsimage.get_height() != next_power_of_2(ddsimage.get_height())) {
		// TODO: generate warning message!
		return Texture();
	}
	
	Texture tex;
	
	glPushAttrib(GL_TEXTURE_BIT);
	glEnable(GL_TEXTURE_2D);
	tex.Bind(); // Make this texture the current texture
	
	if (!ddsimage.upload_texture2D()) {
		// throw LoadTextureFailed("DDS texture could not be loaded into OpenGL!", filename);
		// TODO: generate warning message!
		return Texture();
	}
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	
	glPopAttrib();
	
	return tex;
}

MemTexture DDSLoader::LoadMemTexture(const std::string &filename)
{
	// throw LoadTextureFailed("DDS textures cannot be loaded as MemTexture objects!", filename);
	// TODO: generate warning message!
	return MemTexture();
}

MemLumTexture DDSLoader::LoadMemLumTexture(const std::string &filename)
{
	// throw LoadTextureFailed("DDS textures cannot be loaded as MemTexture objects!", filename);
	// TODO: generate warning message!
	return MemLumTexture();
}

EnvMap DDSLoader::LoadEnvMap(const std::string &filename)
{
	nv_dds::CDDSImage ddsimage;
	
	// TODO: Find out if this one should be loaded upside down since, afaik this code
	//       is exactly the same as what we were earlier using, which would indicate
	//       that the code expected it to be flipped anyway!
	ddsimage.load(filename, true); // currently we allow nv_dds to flip it for us like before
	
	if (ddsimage.get_type() != nv_dds::TextureCubemap) {
		// throw LoadTextureFailed("DDS texture is not a Cube Map texture!", filename);
		// TODO: generate warning message!
		return EnvMap();
	}
	
	EnvMap tex;
	
	glPushAttrib(GL_TEXTURE_CUBE_MAP_ARB);
	glEnable(GL_TEXTURE_CUBE_MAP_ARB);
	tex.Bind();
	
	if (!ddsimage.upload_textureCubemap()) {
		// throw LoadTextureFailed("DDS texture could not be loaded into OpenGL!", filename);
		// TODO: generate warning message!
		return EnvMap();
	}

	// TODO: find out if we need to set texparameters for these cube maps to work
	
	glPopAttrib();
	
	return tex;
}

bool DDSLoader::SaveMemTexture(const MemTexture &mtx, const std::string &filename)
{
	// TODO: generate warning message!
	return false;
}

bool DDSLoader::SaveMemLumTexture(const MemLumTexture &mtx, const std::string &filename)
{
	// TODO: generate warning message!
	return false;
}
