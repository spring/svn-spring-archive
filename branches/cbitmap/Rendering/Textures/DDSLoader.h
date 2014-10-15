/*
 *  DDSLoader.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_DDS_LOADER_H
#define SPRING_RTS_DDS_LOADER_H

#include "ITextureLoader.h"

class DDSLoader : public ITextureLoader
{
public:
	virtual Texture LoadTexture(const std::string &filename, bool mipmaps);
	virtual MemTexture LoadMemTexture(const std::string &filename);
	virtual EnvMap LoadEnvMap(const std::string &filename);
	virtual MemLumTexture LoadMemLumTexture(const std::string &filename);

	virtual bool SaveMemTexture(const MemTexture &, const std::string &filename);
	virtual bool SaveMemLumTexture(const MemLumTexture &, const std::string &filename);
private:
};

#endif /* SPRING_RTS_DDS_LOADER_H */
