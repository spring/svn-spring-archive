/*
 *  MemTextureImpl.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "MemLumTextureImpl.h"

MemLumTextureImpl::MemLumTextureImpl(const unsigned char *bytes, 
							   std::size_t width, 
							   std::size_t height, 
							   bool takeMemory)
: bytes_(NULL), width_(width), height_(height)
{
	if (takeMemory) {
		bytes_ = const_cast<unsigned char *>(bytes);
	} else {
		bytes_ = new unsigned char[SizeBytes()];
		std::memcpy(bytes_, bytes, SizeBytes());
	}
}

MemLumTextureImpl::MemLumTextureImpl(std::size_t width, 
							   std::size_t height)
: width_(width), height_(height)
{
	bytes_ = new unsigned char[SizeBytes()];
}

MemLumTextureImpl::MemLumTextureImpl(const MemLumTextureImpl &rhs)
: bytes_(NULL), width_(rhs.width_), height_(rhs.height_)
{
	bytes_ = new unsigned char[SizeBytes()];
	std::memcpy(bytes_, rhs.bytes_, SizeBytes());
}

MemLumTextureImpl::~MemLumTextureImpl()
{
	delete[] bytes_;
}

unsigned char *MemLumTextureImpl::Bytes()
{
	return bytes_;
}

const unsigned char *MemLumTextureImpl::Bytes() const
{
	return bytes_;
}

std::size_t MemLumTextureImpl::Width() const
{
	return width_;
}

std::size_t MemLumTextureImpl::Height() const
{
	return height_;
}

std::size_t MemLumTextureImpl::Total() const
{
	return width_ * height_;
}

std::size_t MemLumTextureImpl::SizeBytes() const
{
	return width_ * height_ * 1; // 1 byte per pixel for Grayscale
}
