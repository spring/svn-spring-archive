/*
 *  MemLumTexture.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_MEM_LUM_TEXTURE_H
#define SPRING_RTS_MEM_LUM_TEXTURE_H

#include <cstddef>

#include <boost/shared_ptr.hpp>

class Texture;
class MemLumTextureImpl;

class MemLumTexture
{
public:
	MemLumTexture(); // Asserts are used to prevent accessing an uninitialized object (does not check if NDEBUG)
	// Note: although mem is const, if takeMemory is true then mem should not be
	//       modified outside of MemTexture afterwards. MemTexture will call delete[] mem
	MemLumTexture(const unsigned char *mem, std::size_t width, std::size_t height, 
		bool takeMemory = false);
	MemLumTexture(std::size_t width, std::size_t height);
	
	// TODO: find out if the non-const version of Bytes()
	//       is prefered by the compiler...if so change sig
	//       name to BytesAllowModify.

	unsigned char *Bytes(); // Note: Will copy if shared (psuedo copy on write)
	const unsigned char *Bytes() const; // This one is ok, however
	std::size_t Width() const;
	std::size_t Height() const;
	std::size_t Total() const; // TotalPixels
	std::size_t SizeBytes() const;
	
	std::size_t NumberBytes() const; // size of bytes uchar array
	
	Texture CreateTexture(bool mipmaps) const;

	// Indicates if this texture has been bound at least once
	// Usually this is used to determine if the texture hasn't been loaded
	typedef struct unspecified_bool_type_struct {} *unspecified_bool_type;
	operator unspecified_bool_type() const;
private:
	boost::shared_ptr<MemLumTextureImpl> pimpl_;
};

#endif /* SPRING_RTS_MEM_LUM_TEXTURE_H */
