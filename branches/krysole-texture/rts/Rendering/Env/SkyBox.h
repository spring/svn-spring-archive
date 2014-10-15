#ifndef SKYBOX_H
#define SKYBOX_H

#include "BaseSky.h"
#include <string>

#include "Rendering/Textures.h"

class CSkyBox : public CBaseSky
{
public:
	CSkyBox(std::string texture);
	void Update();
	void DrawSun(void);

	void Draw();

private:
	EnvMap tex;
	unsigned int displist;
};

#endif
