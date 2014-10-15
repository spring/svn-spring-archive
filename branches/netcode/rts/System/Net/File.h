/* Author: Tobi Vollebregt */

#ifndef FILE_H
#define FILE_H

#include <fstream>
#include <string>
#include "ISinkSource.h"

namespace net {

class CFileSink
{
	public:
		CFileSink(std::string fname, bool append = false);
		virtual bool Write(const uchar* data, int len);

	private:
		std::string filename;
		std::ofstream stream;
};

class CFileSource
{
	public:
		CFileSource(std::string fname);
		virtual bool Read(uchar*& data, int& len);

	private:
		std::string filename;
		std::ifstream stream;
};

}; // end of namespace net

#endif // FILE_H
