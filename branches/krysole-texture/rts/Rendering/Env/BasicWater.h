// DrawWater.h: interface for the CDrawWater class.
//
//////////////////////////////////////////////////////////////////////

#ifndef __BASIC_WATER_H__
#define __BASIC_WATER_H__

#include "BaseWater.h"

#include "Rendering/Textures.h"

class CBasicWater : public CBaseWater  
{
public:
	void Draw();
	void UpdateWater(CGame* game){};
	CBasicWater();

	Texture texture;
	unsigned int displist;
};

#endif // __BASIC_WATER_H__
