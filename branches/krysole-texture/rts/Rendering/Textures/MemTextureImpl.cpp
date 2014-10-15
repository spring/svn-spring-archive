/*
 *  MemTextureImpl.cpp
 *  SpringRTS
 */

#include "StdAfx.h"

#include "MemTextureImpl.h"

MemTextureImpl::MemTextureImpl(const unsigned char *bytes, 
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

MemTextureImpl::MemTextureImpl(std::size_t width, 
							   std::size_t height)
: width_(width), height_(height)
{
	bytes_ = new unsigned char[SizeBytes()];
}

MemTextureImpl::MemTextureImpl(const MemTextureImpl &rhs)
: bytes_(NULL), width_(rhs.width_), height_(rhs.height_)
{
	bytes_ = new unsigned char[SizeBytes()];
	std::memcpy(bytes_, rhs.bytes_, SizeBytes());
}

MemTextureImpl::~MemTextureImpl()
{
	delete[] bytes_;
}

unsigned char *MemTextureImpl::Bytes()
{
	return bytes_;
}

const unsigned char *MemTextureImpl::Bytes() const
{
	return bytes_;
}

std::size_t MemTextureImpl::Width() const
{
	return width_;
}

std::size_t MemTextureImpl::Height() const
{
	return height_;
}

std::size_t MemTextureImpl::Total() const
{
	return width_ * height_;
}

std::size_t MemTextureImpl::SizeBytes() const
{
	return width_ * height_ * 4;
}
