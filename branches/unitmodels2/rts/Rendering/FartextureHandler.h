#ifndef __FARTEXTURE_HANDLER_H__
#define __FARTEXTURE_HANDLER_H__

class CModel;

class CFartextureHandler
{
public:
	unsigned int farTexture;

	CFartextureHandler(void);
	~CFartextureHandler(void);
	void CreateFarTexture(CModel *model);

private:
	unsigned char* farTextureMem;
	int usedFarTextures;
};

extern CFartextureHandler* fartextureHandler;

#endif // __FARTEXTURE_HANDLER_H__
