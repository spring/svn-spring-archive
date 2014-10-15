/*
 *  ITextureLoader.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_I_TEXTURE_LOADER_H
#define SPRING_RTS_I_TEXTURE_LOADER_H

#include <string>
#include <stdexcept>

class Texture;
class MemTexture;
class EnvMap;
class MemLumTexture;

class ITextureLoader
{
public:
	virtual Texture LoadTexture(const std::string &filename, bool mipmaps) = 0;
	virtual MemTexture LoadMemTexture(const std::string &filename) = 0;
	virtual EnvMap LoadEnvMap(const std::string &filename) = 0;
	virtual MemLumTexture LoadMemLumTexture(const std::string &filename) = 0;

	virtual bool SaveMemTexture(const MemTexture &, const std::string &filename) = 0;
	virtual bool SaveMemLumTexture(const MemLumTexture &, const std::string &filename) = 0;
	
	virtual ~ITextureLoader() {}; // Force virtual destructor
private:
};

#endif /* SPRING_RTS_I_TEXTURE_LOADER_H */
