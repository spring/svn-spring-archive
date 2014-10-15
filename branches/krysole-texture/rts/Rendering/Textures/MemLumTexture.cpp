/*
 *  MemTexture.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "MemLumTexture.h"

#include <memory>

#include "MemLumTextureImpl.h"
#include "Texture.h"

MemLumTexture::MemLumTexture()
{
}


MemLumTexture::MemLumTexture(const unsigned char *mem, 
					   std::size_t width, 
					   std::size_t height, 
					   bool takeMemory)
: pimpl_(new MemLumTextureImpl(mem, width, height, takeMemory))
{
}

MemLumTexture::MemLumTexture(std::size_t width, std::size_t height)
: pimpl_(new MemLumTextureImpl(width, height))
{
}

unsigned char *MemLumTexture::Bytes()
{
	assert(pimpl_);

	// Implements copy on *potential* write
	if (!pimpl_.unique()) {
		pimpl_ = boost::shared_ptr<MemLumTextureImpl>(
			new MemLumTextureImpl(*pimpl_));
	}

	return pimpl_->Bytes();
}

const unsigned char *MemLumTexture::Bytes() const
{
	assert(pimpl_);

	return pimpl_->Bytes();
}

std::size_t MemLumTexture::Width() const
{
	assert(pimpl_);

	return pimpl_->Width();
}

std::size_t MemLumTexture::Height() const
{
	assert(pimpl_);

	return pimpl_->Height();
}

std::size_t MemLumTexture::Total() const
{
	assert(pimpl_);

	return pimpl_->Total();
}

std::size_t MemLumTexture::SizeBytes() const
{
	assert(pimpl_);

	return pimpl_->SizeBytes();
}

Texture MemLumTexture::CreateTexture(bool mipmaps) const
{
	assert(pimpl_);

	return Texture(pimpl_->Bytes(), 
		pimpl_->Width(), pimpl_->Height(), mipmaps, Texture::Luminance);
}

MemLumTexture::operator MemLumTexture::unspecified_bool_type() const
{
	if (pimpl_) {
		return reinterpret_cast<unspecified_bool_type>(1);
	} else {
		return NULL;
	}
}
