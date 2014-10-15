/*
 *  Texture.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_TEXTURE_H
#define SPRING_RTS_TEXTURE_H

#include <cstddef>

#include <boost/shared_ptr.hpp>

class TextureImpl;
class FBO;

class Texture
{
public:
	typedef struct {} Luminance_t;
	static const Luminance_t Luminance;

	Texture(); // GL texture created on first call to Bind()
	Texture(const unsigned char *mem, std::size_t width, std::size_t height, 
		bool mipmaps);
	// NOTE: To create luminance version call like this:
	// Texture(mem, width, height, mipmaps, Texture::Luminance);
	Texture(const unsigned char *mem, std::size_t width, std::size_t height, 
		bool mipmaps, const Luminance_t &);
	
	void Bind() const; // Bind to GL_TEXTURE_2D

	// Set to true by loader and memtex fn...use this to change that settings
	void SetRepeatMode(bool repX, bool repY );

	// Indicates if this texture has been bound at least once
	// Usually this is used to determine if the texture hasn't been loaded
	typedef struct unspecified_bool_type_struct {} *unspecified_bool_type;
	operator unspecified_bool_type() const;
private:
	void LoadData(const unsigned char *mem, std::size_t width, 
		std::size_t height, bool mipmaps);
	void LoadLumData(const unsigned char *mem, std::size_t width, 
		std::size_t height, bool mipmaps);

	// Mutable makes Bind definition simpler
	mutable boost::shared_ptr<TextureImpl> pimpl_;

	friend FBO; // Temporary Workaround
};

#endif /* SPRING_RTS_TEXTURE_H */
