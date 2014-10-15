/*
 *  MemLumTextureImpl.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_MEM_LUM_TEXTURE_IMPL_H
#define SPRING_RTS_MEM_LUM_TEXTURE_IMPL_H

class MemLumTextureImpl
{
public:
	MemLumTextureImpl(const unsigned char *bytes, std::size_t width, 
		std::size_t height, bool takeMemory);
	MemLumTextureImpl(std::size_t width, std::size_t height);
	explicit MemLumTextureImpl(const MemLumTextureImpl &);
	virtual ~MemLumTextureImpl();

	unsigned char *Bytes();
	const unsigned char *Bytes() const;

	std::size_t Width() const;
	std::size_t Height() const;
	std::size_t Total() const;
	std::size_t SizeBytes() const; // Returns same as Total since 1bpp
private:
	MemLumTextureImpl &operator =(const MemLumTextureImpl &);

	unsigned char *bytes_;
	std::size_t width_;
	std::size_t height_;
};

#endif /* SPRING_RTS_MEM_LUM_TEXTURE_IMPL_H */
