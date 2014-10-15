/*
 *  TextureLoader.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_TEXTURE_LOADER_H
#define SPRING_RTS_TEXTURE_LOADER_H

#include "ITextureLoader.h"

#include <boost/shared_ptr.hpp>

class TextureLoader : public ITextureLoader
{
public:
	static TextureLoader &Instance();
	
	virtual Texture LoadTexture(const std::string &filename, bool mipmaps);
	virtual MemTexture LoadMemTexture(const std::string &filename);
	virtual EnvMap LoadEnvMap(const std::string &filename);

	// NOTE: to load a Luminance Texture directly into opengl use this class and call
	// CreateTexture on it...this will properly load the luminance texture!
	virtual MemLumTexture LoadMemLumTexture(const std::string &filename);

	virtual bool SaveMemTexture(const MemTexture &, const std::string &filename);
	virtual bool SaveMemLumTexture(const MemLumTexture &, const std::string &filename);
private:
	boost::shared_ptr<ITextureLoader> general_;
	boost::shared_ptr<ITextureLoader> dds_;

	TextureLoader();

	ITextureLoader *CreateGeneralLoader();

	ITextureLoader &SelectLoader(const std::string &filename);

	TextureLoader &operator =(const TextureLoader &);
};

#endif /* SPRING_RTS_TEXTURE_LOADER_H */
