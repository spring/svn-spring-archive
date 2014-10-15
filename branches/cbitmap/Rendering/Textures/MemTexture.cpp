/*
 *  MemTexture.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "MemTexture.h"

#include <memory>

#include "MemTextureImpl.h"
#include "Texture.h"

MemTexture::MemTexture()
{
}

MemTexture::MemTexture(const unsigned char *mem, 
					   std::size_t width, 
					   std::size_t height, 
					   bool takeMemory)
: pimpl_(new MemTextureImpl(mem, width, height, takeMemory))
{
}

MemTexture::MemTexture(std::size_t width, std::size_t height)
: pimpl_(new MemTextureImpl(width, height))
{
}

unsigned char *MemTexture::Bytes()
{
	assert(pimpl_);

	// Implements copy on *potential* write
	if (!pimpl_.unique()) {
		pimpl_ = boost::shared_ptr<MemTextureImpl>(
			new MemTextureImpl(*pimpl_));
	}

	return pimpl_->Bytes();
}

const unsigned char *MemTexture::Bytes() const
{
	assert(pimpl_);

	return pimpl_->Bytes();
}

std::size_t MemTexture::Width() const
{
	assert(pimpl_);

	return pimpl_->Width();
}

std::size_t MemTexture::Height() const
{
	assert(pimpl_);

	return pimpl_->Height();
}

std::size_t MemTexture::Total() const
{
	assert(pimpl_);

	return pimpl_->Total();
}

std::size_t MemTexture::SizeBytes() const
{
	assert(pimpl_);

	return pimpl_->SizeBytes();
}

Texture MemTexture::CreateTexture(bool mipmaps) const
{
	assert(pimpl_);

	return Texture(pimpl_->Bytes(), 
		pimpl_->Width(), pimpl_->Height(), mipmaps);
}

MemTexture::operator MemTexture::unspecified_bool_type() const
{
	if (pimpl_) {
		return reinterpret_cast<unspecified_bool_type>(1);
	} else {
		return NULL;
	}
}
