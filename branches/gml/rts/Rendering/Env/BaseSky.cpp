#include "StdAfx.h"
#include "BaseSky.h"
#include "BasicSky.h"
#include "AdvSky.h"
#include "Rendering/GL/myGL.h"
#include "Platform/ConfigHandler.h"
#include "SkyBox.h"
#include "Map/MapInfo.h"
#include "Map/ReadMap.h"
#include "mmgr.h"

CBaseSky* sky=0;

CBaseSky::CBaseSky(void)
{
	wireframe = false;
}

CBaseSky::~CBaseSky(void)
{
}

CBaseSky* CBaseSky::GetSky()
{
	if(!mapInfo->atmosphere.skyBox.empty())
		return SAFE_NEW CSkyBox("maps/" + mapInfo->atmosphere.skyBox);
	else if(GLEW_ARB_fragment_program && configHandler.GetInt("AdvSky",1) && ProgramStringIsNative(GL_FRAGMENT_PROGRAM_ARB,"clouds.fp"))
		return SAFE_NEW CAdvSky();
	else
		return SAFE_NEW CBasicSky();
}
