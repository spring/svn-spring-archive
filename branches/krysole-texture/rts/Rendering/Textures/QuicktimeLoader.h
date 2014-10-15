/*
 *  QuicktimeLoader.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_QUICKTIME_LOADER_H
#define SPRING_RTS_QUICKTIME_LOADER_H

#include "ITextureLoader.h"

class QuicktimeLoader : public ITextureLoader
{
public:
	virtual Texture LoadTexture(const std::string &filename, bool mipmaps);
	virtual MemTexture LoadMemTexture(const std::string &filename);
	virtual EnvMap LoadEnvMap(const std::string &filename);
	
	virtual bool SaveMemTexture(const MemTexture &, const std::string &filename);
private:
	unsigned char *LoadTextureData(const std::string &filename, 
		std::size_t *width, std::size_t *height);

	char **GetPtrDataRef(const unsigned char *mem, std::size_t size, 
		const std::string &filename);
	unsigned char *DecodeTextureData(char **dataRef, 
		std::size_t *width, std::size_t *height, bool *hasAlpha);
	unsigned char *LoadResData(const std::string &filename, 
		std::size_t *size);
	void ChangeBytesToRGBA(unsigned char *data, std::size_t width, 
		std::size_t height);
	void AddAlpha(unsigned char *data, std::size_t width, 
		std::size_t height);
};

#endif /* SPRING_RTS_QUICKTIME_LOADER_H */
