/**
 * @file FBO.cpp
 * @brief EXT_framebuffer_object implementation
 * @author Christopher Han <xiphux@gmail.com>
 *
 * EXT_framebuffer_object class implementation
 * Copyright (C) 2005.  Licensed under the terms of the
 * GNU GPL, v2 or later.
 */
#include <assert.h>
#include "IFramebuffer.h"
#include "Rendering/Textures/TextureImpl.h" // Temporary Workaround

/**
 * Tests for support of the EXT_framebuffer_object
 * extension, and generates a framebuffer if supported
 */
FBO::FBO()
{
	g_frameBuffer = 0;
	if (!GLEW_EXT_framebuffer_object)
		return;
	assert(glGenFramebuffersEXT != 0);
	glGenFramebuffersEXT(1,&g_frameBuffer);
	select();
	// Other init stuff
	deselect();
}

/**
 * Unbinds the framebuffer and deletes it
 */
FBO::~FBO()
{
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	if (g_frameBuffer)
		glDeleteFramebuffersEXT(1,&g_frameBuffer);
}

/**
 * Tests whether or not we have a valid framebuffer
 */
bool FBO::valid(void)
{
	return g_frameBuffer != 0;
}

/**
 * Makes the framebuffer the active framebuffer context
 */
void FBO::select(void)
{
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, g_frameBuffer);
}

/**
 * Unbinds the framebuffer from the current context
 */
void FBO::deselect(void)
{
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
}

/**
 * Tests if the framebuffer is a complete and
 * legitimate framebuffer
 */
void FBO::checkFBOStatus(void)
{
	GLenum status;
	status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
	if (status != GL_FRAMEBUFFER_COMPLETE_EXT)
		assert(0);
}

/**
 * Attaches a GL texture to the framebuffer
 */
void FBO::attachTexture(Texture tex, FramebufferAttachType attachtype)
{
	GLenum glattachtype;

	select();
	if (attachtype == FBO_ATTACH_DEPTH) {
		glattachtype = GL_DEPTH_ATTACHMENT_EXT;
		glDrawBuffer(GL_NONE);
		glReadBuffer(GL_NONE);
	} else if (attachtype == FBO_ATTACH_COLOR)
		glattachtype = GL_COLOR_ATTACHMENT0_EXT;

	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, glattachtype, GL_TEXTURE_2D, tex.pimpl_->Tex(), 0);
	deselect();
}
