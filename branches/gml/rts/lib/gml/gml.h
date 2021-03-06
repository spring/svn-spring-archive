// GML - OpenGL Multithreading Library
// for Spring http://spring.clan-sy.com
// Author: Mattias "zerver" Radeskog
// (C) Ware Zerver Tech. http://zerver.net
// Ware Zerver Tech. licenses this library
// to be used freely for any purpose, as
// long as this notice remains unchanged

#ifndef GML_H
#define GML_H

#include <set>
#include <map>
#include <GL/glew.h>

#include "gmlcls.h"

extern gmlQueue gmlQueues[GML_MAX_NUM_THREADS];

#include "gmlfun.h"

extern boost::thread *gmlThreads[GML_MAX_NUM_THREADS];

extern gmlSingleItemServer<GLhandleARB, PFNGLCREATEPROGRAMPROC *> gmlProgramServer;
extern gmlSingleItemServer<GLhandleARB, PFNGLCREATEPROGRAMOBJECTARBPROC *> gmlProgramObjectARBServer;

extern gmlSingleItemServer<GLhandleARB, GLhandleARB (*)(void)> gmlShaderServer_VERTEX;
extern gmlSingleItemServer<GLhandleARB, GLhandleARB (*)(void)> gmlShaderServer_FRAGMENT;

extern gmlSingleItemServer<GLhandleARB, GLhandleARB (*)(void)> gmlShaderObjectARBServer_VERTEX;
extern gmlSingleItemServer<GLhandleARB, GLhandleARB (*)(void)> gmlShaderObjectARBServer_FRAGMENT;
extern gmlSingleItemServer<GLUquadric *, GLUquadric *(GML_GLAPIENTRY *)(void)> gmlQuadricServer;

extern void gmlInit();

EXTERN inline GLhandleARB gmlCreateProgram() {
	return gmlProgramServer.GetItems();
}
EXTERN inline GLhandleARB gmlCreateProgramObjectARB() {
	return gmlProgramObjectARBServer.GetItems();
}
EXTERN inline GLhandleARB gmlCreateShader(GLenum type) {
	if(type==GL_VERTEX_SHADER)
  	  return gmlShaderServer_VERTEX.GetItems();
	if(type==GL_FRAGMENT_SHADER)
  	  return gmlShaderServer_FRAGMENT.GetItems();
	return 0;
}
EXTERN inline GLhandleARB gmlCreateShaderObjectARB(GLenum type) {
	if(type==GL_VERTEX_SHADER_ARB)
  	  return gmlShaderObjectARBServer_VERTEX.GetItems();
	if(type==GL_FRAGMENT_SHADER_ARB)
  	  return gmlShaderObjectARBServer_FRAGMENT.GetItems();
	return 0;
}
EXTERN inline GLUquadric *gmluNewQuadric() {
	return gmlQuadricServer.GetItems();
}


extern gmlMultiItemServer<GLuint, GLsizei, void (GML_GLAPIENTRY *)(GLsizei,GLuint *)> gmlTextureServer;
extern gmlMultiItemServer<GLuint, GLsizei, PFNGLGENBUFFERSARBPROC *> gmlBufferARBServer;
extern gmlMultiItemServer<GLuint, GLsizei, PFNGLGENFENCESNVPROC *> gmlFencesNVServer;
extern gmlMultiItemServer<GLuint, GLsizei, PFNGLGENPROGRAMSARBPROC *> gmlProgramsARBServer;
extern gmlMultiItemServer<GLuint, GLsizei, PFNGLGENRENDERBUFFERSEXTPROC *> gmlRenderbuffersEXTServer;
extern gmlMultiItemServer<GLuint, GLsizei, PFNGLGENFRAMEBUFFERSEXTPROC *> gmlFramebuffersEXTServer;
extern gmlMultiItemServer<GLuint, GLsizei, PFNGLGENQUERIESPROC *> gmlQueryServer;
extern gmlMultiItemServer<GLuint, GLsizei, PFNGLGENBUFFERSPROC *> gmlBufferServer;

EXTERN inline void gmlGenTextures(GLsizei n, GLuint *items) {
	gmlTextureServer.GetItems(n, items);
}
EXTERN inline void gmlGenBuffersARB(GLsizei n, GLuint *items) {
	gmlBufferARBServer.GetItems(n, items);
}
EXTERN inline void gmlGenFencesNV(GLsizei n, GLuint *items) {
	gmlFencesNVServer.GetItems(n, items);
}
EXTERN inline void gmlGenProgramsARB(GLsizei n, GLuint *items) {
	gmlProgramsARBServer.GetItems(n, items);
}
EXTERN inline void gmlGenRenderbuffersEXT(GLsizei n, GLuint *items) {
	gmlRenderbuffersEXTServer.GetItems(n, items);
}
EXTERN inline void gmlGenFramebuffersEXT(GLsizei n, GLuint *items) {
	gmlFramebuffersEXTServer.GetItems(n, items);
}
EXTERN inline void gmlGenQueries(GLsizei n, GLuint *items) {
	gmlQueryServer.GetItems(n, items);
}
EXTERN inline void gmlGenBuffers(GLsizei n, GLuint *items) {
	gmlBufferServer.GetItems(n, items);
}



extern gmlItemSequenceServer<GLuint, GLsizei,GLuint (GML_GLAPIENTRY *)(GLsizei)> gmlListServer;

EXTERN inline GLuint gmlGenLists(GLsizei items) {
  return gmlListServer.GetItems(items);
}

EXTERN inline void gmlUpdateServers() {
	gmlItemsConsumed=0;
	gmlProgramServer.GenerateItems();
	gmlProgramObjectARBServer.GenerateItems();
	gmlShaderServer_VERTEX.GenerateItems();
	gmlShaderServer_FRAGMENT.GenerateItems();
	gmlShaderObjectARBServer_VERTEX.GenerateItems();
	gmlShaderObjectARBServer_FRAGMENT.GenerateItems();
	gmlQuadricServer.GenerateItems();

	gmlTextureServer.GenerateItems();
	gmlBufferARBServer.GenerateItems();
	gmlFencesNVServer.GenerateItems();
	gmlProgramsARBServer.GenerateItems();
	gmlRenderbuffersEXTServer.GenerateItems();
	gmlFramebuffersEXTServer.GenerateItems();
	gmlQueryServer.GenerateItems();
	gmlBufferServer.GenerateItems();

	gmlListServer.GenerateItems();
}

#if GML_ENABLE
#include "gmlimp.h"
#include "gmldef.h"
#define GML_VECTOR gmlVector
#define GML_CLASSVECTOR gmlClassVector
#else
#define GML_VECTOR std::vector
#define GML_CLASSVECTOR std::vector
#endif

#endif
