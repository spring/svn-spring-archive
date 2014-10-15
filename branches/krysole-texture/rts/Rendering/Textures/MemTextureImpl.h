/*
 *  MemTextureImpl.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_MEM_TEXTURE_IMPL_H
#define SPRINT_RTS_MEM_TEXTURE_IMPL_H

class MemTextureImpl
{
public:
	MemTextureImpl(const unsigned char *bytes, std::size_t width, 
		std::size_t height, bool takeMemory);
	MemTextureImpl(std::size_t width, std::size_t height);
	explicit MemTextureImpl(const MemTextureImpl &);
	virtual ~MemTextureImpl();

	unsigned char *Bytes();
	const unsigned char *Bytes() const;

	std::size_t Width() const;
	std::size_t Height() const;
	std::size_t Total() const;
	std::size_t SizeBytes() const;
private:
	MemTextureImpl &operator =(const MemTextureImpl &);

	unsigned char *bytes_;
	std::size_t width_;
	std::size_t height_;
};

#endif /* SPRING_RTS_MEM_TEXTURE_IMPL_H */
