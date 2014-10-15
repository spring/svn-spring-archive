/*
 *  EnvMap.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "EnvMap.h"

#include "TextureImpl.h"

#include "Rendering/GL/myGL.h"

EnvMap::EnvMap()
{
}

void EnvMap::Bind() const
{
	if (!pimpl_) {
		pimpl_.reset(new TextureImpl());
	}

	glBindTexture(GL_TEXTURE_CUBE_MAP_ARB, pimpl_->Tex());
}

EnvMap::operator EnvMap::unspecified_bool_type() const
{
	if (pimpl_) {
		return reinterpret_cast<unspecified_bool_type>(1);
	} else {
		return NULL;
	}
}