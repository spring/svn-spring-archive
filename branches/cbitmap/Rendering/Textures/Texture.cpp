/*
 *  Texture.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "Texture.h"

#include "TextureImpl.h"
#include "MemTexture.h"
#include "MemTextureEffects.h"

#include "System/bitops.h"
#include "Rendering/GL/myGL.h"

const Texture::Luminance_t Texture::Luminance;

Texture::Texture()
{
}

Texture::Texture(const unsigned char *mem, std::size_t width, std::size_t height, 
	bool mipmaps)
: pimpl_(new TextureImpl())
{
	glPushAttrib(GL_TEXTURE_BIT);
	glEnable(GL_TEXTURE_2D);
	Bind();
	LoadData(mem, width, height, mipmaps);
	glPopAttrib();
}

Texture::Texture(const unsigned char *mem, std::size_t width, std::size_t height, 
				 bool mipmaps, const Luminance_t &)
{
	glPushAttrib(GL_TEXTURE_BIT);
	glEnable(GL_TEXTURE_2D);
	Bind();
	LoadLumData(mem, width, height, mipmaps);
	glPopAttrib();
}

void Texture::Bind() const
{
	if (!pimpl_) {
		pimpl_.reset(new TextureImpl());
	}

	glBindTexture(GL_TEXTURE_2D, pimpl_->Tex());
}

void Texture::SetRepeatMode(bool repX, bool repY)
{
	glPushAttrib(GL_TEXTURE_BIT);
	glEnable(GL_TEXTURE_2D);
	Bind();

	if (repX) {
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
	} else {
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
	}

	if (repY) {
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
	} else {
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
	}

	glPopAttrib();
}

Texture::operator Texture::unspecified_bool_type() const
{
	if (pimpl_) {
		return reinterpret_cast<unspecified_bool_type>(1);
	} else {
		return NULL;
	}
}

void Texture::LoadData(const unsigned char *tmem, std::size_t width, 
					   std::size_t height, bool mipmaps)
{
	MemTexture rsztex;
	const unsigned char *mem = tmem; // This changes if the texture is not a power of two
	
	// ARB_non_power_of_two indicates that we can load npot textures with mipmapping chains
	if ((width != next_power_of_2(width) || height != next_power_of_2(height)) && !GLEW_ARB_texture_non_power_of_two)
	{
		rsztex = MemTexture(mem, width, height);
		
		std::size_t nextWidth = next_power_of_2(width);
		std::size_t nextHeight = next_power_of_2(height);
		
		rsztex = mtxeffect::ScaleToSize(rsztex, nextWidth, nextHeight);
		
		mem = rsztex.Bytes();
		width = rsztex.Width();
		height = rsztex.Height();
	}

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	if (mipmaps) {
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, 
			GL_LINEAR_MIPMAP_LINEAR);
		
		// If we can simply let gl generate mipmaps it might save the
		// cpu some work depending on the gl idc driver;)
		if (GLEW_SGIS_generate_mipmap) {
			glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, true);
			
			// Hint GL to generate 'nicest' mipmaps
			glHint(GL_GENERATE_MIPMAP_HINT_SGIS, GL_NICEST);

			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, mem);
		} else {
			gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA8, width, height, GL_RGBA, GL_UNSIGNED_BYTE, mem);
		}
	} else {
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);

		glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, mem);
	}
}

void Texture::LoadLumData(const unsigned char *tmem, std::size_t width, 
					   std::size_t height, bool mipmaps)
{
	MemTexture rsztex;
	const unsigned char *mem = tmem; // This changes if the texture is not a power of two
	
#if 0 // This stuff needs to be fixed at some point, but I'm not going to write the scaling alg yet
	//   so for now it will remain a non feature.
	// ARB_non_power_of_two indicates that we can load npot textures with mipmapping chains
	if ((width != next_power_of_2(width) || height != next_power_of_2(height)) && !GLEW_ARB_texture_non_power_of_two)
	{
		rsztex = MemTexture(mem, width, height);
		
		std::size_t nextWidth = next_power_of_2(width);
		std::size_t nextHeight = next_power_of_2(height);
		
		rsztex = mtxeffect::ScaleToSize(rsztex, nextWidth, nextHeight);
		
		mem = rsztex.Bytes();
		width = rsztex.Width();
		height = rsztex.Height();
	}
#else
	if (width != next_power_of_2(width) || height != next_power_of_2(height))
	{
		// TODO: Generate warning
		return; // Just completely ignore the load for now
	}
#endif

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	if (mipmaps) {
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, 
			GL_LINEAR_MIPMAP_LINEAR);
		
		// If we can simply let gl generate mipmaps it might save the
		// cpu some work depending on the gl idc driver;)
		if (GLEW_SGIS_generate_mipmap) {
			glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, true);
			
			// Hint GL to generate 'nicest' mipmaps
			glHint(GL_GENERATE_MIPMAP_HINT_SGIS, GL_NICEST);

			glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, width, height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, mem);
		} else {
			gluBuild2DMipmaps(GL_TEXTURE_2D, GL_LUMINANCE, width, height, GL_LUMINANCE, GL_UNSIGNED_BYTE, mem);
		}
	} else {
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);

		glTexImage2D(GL_TEXTURE_2D,0,GL_LUMINANCE, width, height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, mem);
	}
}
