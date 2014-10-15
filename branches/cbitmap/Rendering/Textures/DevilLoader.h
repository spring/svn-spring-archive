/*
 *  DevilLoader.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_DEVIL_LOADER_H
#define SPRING_RTS_DEVIL_LOADER_H

#include "ITextureLoader.h"

class DevilLoader : public ITextureLoader
{
public:
	DevilLoader();
	virtual ~DevilLoader();

	virtual Texture LoadTexture(const std::string &filename, bool mipmaps);
	virtual MemTexture LoadMemTexture(const std::string &filename);
	virtual EnvMap LoadEnvMap(const std::string &filename);
	virtual MemLumTexture LoadMemLumTexture(const std::string &filename);

	virtual bool SaveMemTexture(const MemTexture &, const std::string &filename);
	virtual bool SaveMemLumTexture(const MemLumTexture &, const std::string &filename);
private:
	unsigned char *LoadTextureData(const std::string &resName, 
		std::size_t &width, std::size_t &height, bool &hasAlpha);

	unsigned char *LoadResData(const std::string &resName, std::size_t &resSize);
	unsigned char *DecodeTextureData(unsigned char *resData, 
		std::size_t &width, std::size_t &height, 
		bool &hasAlpha, std::size_t sz);
	unsigned char *DecodeLumTextureData(unsigned char *resData, 
		std::size_t &width, std::size_t &height, 
		std::size_t sz);
};

#endif /* SPRING_RTS_DEVIL_LOADER_H */
