   // GUIimage.h: interface for the GUIimage class.
//
//////////////////////////////////////////////////////////////////////

#ifndef GUIIMAGE_H
#define GUIIMAGE_H

#include "GUIframe.h"
#include "Rendering/Textures.h"

class GUIimage : public GUIframe  
{
public:
	GUIimage(int x, int y, int w, int h, const std::string& image);
	
	void SetImage(const std::string& image);
protected:
	Texture texture;

	void PrivateDraw();
};

#endif // GUIIMAGE_H
