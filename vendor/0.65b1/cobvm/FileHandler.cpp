#include "StdAfx.h"
#include ".\filehandler.h"

CFileHandler::CFileHandler(string name)
{
	f.open(name.c_str(), ios::in | ios::binary);
}

CFileHandler::~CFileHandler(void)
{
}

bool CFileHandler::FileExists()
{
	return f.is_open();
}

void CFileHandler::Read(void *p, int len)
{
	f.read((char *)p, len);
}

int CFileHandler::FileSize()
{
	f.seekg(0, ios::end);
	long size = f.tellg();
	f.seekg(0, ios::beg);

	return size;
}
