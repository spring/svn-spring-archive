#ifndef __VFS_HANDLER_H
#define __VFS_HANDLER_H

#include <map>
#include <string>
#include <vector>

#include "ArchiveBase.h"

using namespace std;

class CVFSHandler
{
protected:
	struct FileData{
		CArchiveBase *ar;
		int size;
	};
	map<string, FileData> files; 
	map<string, CArchiveBase*> archives;
	void FindArchives(const string& pattern, const string& path);
	void SetSlashesBackToForward(string& name);
public:
	CVFSHandler(bool mapArchives = true);
	virtual ~CVFSHandler();

	void MakeLower(char* s);
	void MakeLower(string &s);
	
	int LoadFile(string name, void* buffer);
	int GetFileSize(string name);

	vector<string> GetFilesInDir(string dir);

	void AddArchive(string arName, bool override);
};

extern CVFSHandler* hpiHandler;

#endif
