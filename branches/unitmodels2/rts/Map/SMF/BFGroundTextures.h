// BFGroundTextures.h
///////////////////////////////////////////////////////////////////////////

#ifndef __BF_GROUND_TEXTURES_H__
#define __BF_GROUND_TEXTURES_H__

class CFileHandler;
class CSmfReadMap;

class CBFGroundTextures
{
public:
	CBFGroundTextures(CSmfReadMap *srm);
	~CBFGroundTextures(void);
	void SetTexture(int x, int y);
	void DrawUpdate(void);
	void LoadSquare(int x, int y, int level);

protected:
	CSmfReadMap *map;

	int numBigTexX;
	int numBigTexY;

	int* textureOffsets;

	struct GroundSquare{
		int texLevel;
		unsigned int texture;
		int lastUsed;
	};

	GroundSquare* squares;

	//variables controlling background reading of textures
	bool inRead;
	int readProgress;
	int readX;
	int readY;
	GroundSquare* readSquare;
	int readLevel;
	unsigned char* readBuffer;
	unsigned char* readTempLine;

	int *tileMap;
	int tileSize;
	char *tiles;
	int tileMapXSize;
	int tileMapYSize;
};

#endif // __BF_GROUND_TEXTURES_H__
