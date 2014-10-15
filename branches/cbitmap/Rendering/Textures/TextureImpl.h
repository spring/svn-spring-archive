/*
 *  TextureImpl.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_TEXTURE_IMPL_H
#define SPRING_RTS_TEXUTRE_IMPL_H

class TextureImpl
{
public:
	TextureImpl();
	virtual ~TextureImpl();

	unsigned int Tex();
private:
	TextureImpl(const TextureImpl &);
	TextureImpl &operator =(const TextureImpl &);

	unsigned int tex_;
};

#endif /* SPRING_RTS_TEXTURE_IMPL_H */
