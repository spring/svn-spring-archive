/*
 *  TextureImpl.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "TextureImpl.h"

#include "Rendering/GL/myGL.h"

TextureImpl::TextureImpl()
{
	glGenTextures(1, &tex_);
}

TextureImpl::~TextureImpl()
{
	glDeleteTextures(1, &tex_);
}

unsigned int TextureImpl::Tex()
{
	return tex_;
}
