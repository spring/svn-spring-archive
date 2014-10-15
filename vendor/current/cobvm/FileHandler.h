#pragma once

#include <string>
#include <fstream>

using namespace std;

class CFileHandler
{
	ifstream f;
public:
	CFileHandler(string name);
	~CFileHandler(void);
	bool FileExists();
	void Read(void *p, int len);
	int FileSize();
};
