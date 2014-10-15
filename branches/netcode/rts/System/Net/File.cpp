/* Author: Tobi Vollebregt */

//#include "StdAfx.h"
#include "File.h"
#include "internal.h"

namespace net {

/**
 * Open a file for writing.
 */
CFileSink::CFileSink(std::string fname, bool append) :
		filename(fname), stream(fname.c_str(), std::ios_base::binary | std::ios_base::out | (append ? std::ios_base::ate : std::ios_base::trunc))
{
	if (!stream.good())
		throw FileError(filename);
}

/**
 * Write data to the file.
 */
bool CFileSink::Write(const uchar* data, int len)
{
	stream.write((char*) data, len);

	if (!stream.good())
		throw FileError(filename);

	return true;
}

/**
 * Open a file for reading.
 */
CFileSource::CFileSource(std::string fname) :
		filename(fname), stream(fname.c_str(), std::ios_base::binary | std::ios_base::in)
{
	if (!stream.good())
		throw FileError(filename);
}

/**
 * Read data from the file.
 */
bool CFileSource::Read(uchar*& data, int& len)
{
	stream.read((char*) data, len);
	len = stream.gcount();

	if (!stream.good())
		throw FileError(filename);

	return true;
}

}; // end of namespace net
