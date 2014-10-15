//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------
#ifndef _wave_h_
#define _wave_h_

/*
   libwave - Wavefront/GL rendering library
   Version 1.4.1

   12 January 1996
   Dave Pape (pape@evl.eecs.uic.edu)
   Stripped down and modified by Jelmer Cnossen

 Changes:
	1.4.1:	Corrected scaling option for .map files - uses -s, not -mm
		Added -o (offset) support for .map files
	1.4:	Added WF_DRAW_WIREFRAME option.
		Added wfCopyObjectGeometry(), wfTranslateObject(), wfRotateObject(),
		  wfScaleObject(), wfDeformObject(), wfComputeNormals(),
		  wfRayIntersection(), wfRayHits().
	1.3.3:  Fixed really subtle bug that only showed up with certain big files
	1.3.2:	Added wfEnable() & wfDisable(), with options WF_SHOW_DEFINED_TEXTURES,
			WF_USE_TEXTURES, WF_INCLUDE_ALL_PARTS
	1.3.1:	Added app_data element to wfObject
		Corrected maplib & usemap output of wfWriteObject()
		Optimized texture definition (a given image will only
			be texdef'ed once)
	1.3:	Added wfMaterialLib & wfTextureLib 'parts'
		Added wfWriteObject()
*/

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <malloc.h>

#define WF_MAX_TEXTURES 1024

/* Values for wfPart.parttype */
#define WF_FACE		1
#define WF_LINE		4
#define WF_VERTEX	7
#define WF_NORMAL	8
#define WF_TEXCOORD	9
#define WF_UNSUPPORTED	10

typedef float wfVertex[3];
typedef float wfNormal[3];
typedef float wfTexcoord[3];
typedef struct _wf_face wfFace;
typedef struct _wf_line wfLine;
typedef struct _wf_part wfPart;
typedef struct _wf_object wfObject;

struct _wf_face {
		int nverts;
		int *vert;
		int *tex;
		int *norm;
		};

struct _wf_line {
		int nverts;
		int *vert;
		};

struct _wf_part {
		int parttype;
		union {
			wfFace face;
			wfLine line;
			char *unsupported;
			} part;
		wfPart *next;
		};

struct _wf_object {
		int nverts;
		wfVertex *vert;
		int nnorms;
		wfNormal *norm;
		int ntexcoords;
		wfTexcoord *texc;
		wfPart *parts;
		};


extern wfObject *wfReadObject(char *fname);
extern void wfDrawObject(wfObject *obj);
extern void wfInitObject(wfObject *obj);
extern void wfFreeObject(wfObject *obj);// what stupid library doesn't clean up its objects :S
extern void wfWriteObject(FILE *fp,wfObject *obj);

/* Internally used functions */
extern char *wfReadLine(char *buf,int bufsize,FILE *fp,int *lineNum);

extern void *wfAlloc(size_t n);
extern void wfFree(void *p);

void bzero(void *s,int n);

#ifdef __cplusplus
}
#endif

#endif
