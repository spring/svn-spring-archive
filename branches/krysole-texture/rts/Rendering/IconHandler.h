/* Author: Teake Nutma */

#ifndef ICONHANDLER_H
#define ICONHANDLER_H

#include <map>
#include <string>
#include <vector>
#include "Rendering/Textures.h"

class CIcon
{
public:
	Texture texture;
	float size;
	float distance;
	bool radiusAdjust;
	CIcon(const Texture &tex, float siz, float dis, bool radius)
	{
		texture		= tex;
		size		= siz;
		distance	= dis;
		radiusAdjust= radius;
	};
};

class CIconHandler
{
public:
	CIconHandler(void);
	CIcon * GetIcon(const std::string& iconName);
	float GetDistance(const std::string& iconName);
private:
	const Texture &GetStandardTexture();
	Texture standardTexture;
	std::map<std::string, CIcon*> icons;
};

extern CIconHandler* iconHandler;

#endif
