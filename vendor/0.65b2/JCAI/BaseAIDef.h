//-------------------------------------------------------------------------
// JCAI version 0.21
//
// A skirmish AI for the TA Spring engine.
// Copyright Jelmer Cnossen
// 
// Released under GPL license: see LICENSE.html for more information.
//-------------------------------------------------------------------------
#ifndef JC_BASE_AI_DEF_H
#define JC_BASE_AI_DEF_H

#include "IGlobalAI.h"
#include "GlobalStuff.h"
#include "IGlobalAICallback.h"
#include "IAICallback.h"
#include "UnitDef.h"
#include "MoveInfo.h"
#include <assert.h> 
#include <algorithm>
#include <hash_map>
#include <map>
#include <set>
#include <vector>
#include <boost/bind.hpp>
#include <stdio.h>

#define SAFE_DELETE(p)  { if(p) { delete (p);     (p)=NULL; } }

using namespace std;

#ifdef _MSC_VER
#pragma warning(disable: 4244 4018) // signed/unsigned and loss of precision...
#endif 

typedef unsigned char uchar;
typedef unsigned long ulong;
typedef unsigned int uint;
typedef unsigned short ushort;

// outputs to testai.log
void logPrintf (const char *fmt, ...);
void logFileOpen ();
void logFileClose ();
void ChatMsgPrintf (IAICallback *cb, const char *fmt, ...);
void ChatDebugPrintf (IAICallback *cb, const char *fmt, ...);

void ReplaceExtension (const char *n, char *dst,int s, const char *ext);

#ifdef _MSC_VER
#define STRCASECMP stricmp
#define SNPRINTF _snprintf
#define VSNPRINTF _vsnprintf
#else
#define STRCASECMP strcasecmp
#define SNPRINTF snprintf
#define VSNPRINTF vsnprintf
#endif


#define NUM_TASK_TYPES 4
#define AI_PATH "aidll\\globalai\\jcai\\"


struct ResourceInfo 
{
	ResourceInfo() { energy=metal=0.0f; } 
	ResourceInfo(float e,float m) : energy(e),metal(m) {}
	ResourceInfo& operator+=(const ResourceInfo &x) { energy+=x.energy; metal+=x.metal; return *this; }
	ResourceInfo& operator-=(const ResourceInfo &x) { energy-=x.energy; metal-=x.metal; return *this; }
	ResourceInfo operator+(const ResourceInfo &x) const { return ResourceInfo (energy+x.energy, metal+x.metal); }
	ResourceInfo& operator*=(const ResourceInfo &x) { energy*=x.energy;  metal*=x.metal; return *this; }
	ResourceInfo operator*(const ResourceInfo &x) const { return ResourceInfo (energy*x.energy, metal*x.metal); }
	ResourceInfo operator*(float x) const { return ResourceInfo (energy*x, metal*x); }
	float energy, metal;
};


typedef int UnitDefID;

#endif // JC_BASE_AI_DEF_H

