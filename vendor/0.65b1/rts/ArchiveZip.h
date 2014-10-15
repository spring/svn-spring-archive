#ifndef __ARCHIVE_ZIP
#define __ARCHIVE_ZIP

#define ZLIB_WINAPI 

#include "ArchiveBuffered.h"
#include "../zlib/include/unzip.h"

class CArchiveZip :
	public CArchiveBuffered
{
protected:
	struct FileData {
		unz_file_pos fp;
		int size;
		string origName;
	};
	unzFile zip;
	map<string, FileData> fileData;		// using unzLocateFile is quite slow
	int curSearchHandle;
	map<int, map<string, FileData>::iterator> searchHandles;
	virtual ABOpenFile_t* GetEntireFile(const string& fileName);
	void SetSlashesForwardToBack(string& name);
	void SetSlashesBackToForward(string& name);
public:
	CArchiveZip(const string& name);
	virtual ~CArchiveZip(void);
	virtual bool IsOpen();
	virtual int FindFiles(int cur, string* name, int* size);
};

#endif