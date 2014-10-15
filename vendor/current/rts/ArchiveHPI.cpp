#include "StdAfx.h"
#include "ArchiveHpi.h"
#include <algorithm>
//#include "mmgr.h"

// To avoid remapping the DLL at every new instance, the function pointers are declared here instead
static HINSTANCE m_hDLL = NULL;
static LPVOID (WINAPI *HPIOpen)(const char* FileName);
static LRESULT (WINAPI *HPIGetFiles)(void *hpi, int Next, LPSTR Name, LPINT Type, LPINT Size);
static LRESULT (WINAPI *HPIClose)(void *hpi);
static LPSTR (WINAPI *HPIOpenFile)(void *hpi, const char* FileName);
static void (WINAPI *HPIGet)(void *Dest, void *FileHandle, int offset, int bytecount);
static LRESULT (WINAPI *HPICloseFile)(LPSTR FileHandle);
static LRESULT (WINAPI *HPIDir)(void *hpi, int Next, LPSTR DirName, LPSTR Name, LPINT Type, LPINT Size);

CArchiveHPI::CArchiveHPI(const string& name) :
	CArchiveBuffered(name),
	curSearchHandle(1)
{
	if (m_hDLL == NULL) {
		if((m_hDLL=LoadLibrary("hpiutil.dll"))==0)
			MessageBox(0,"Failed to find hpiutil.dll","",0);

		HPIOpen=	(LPVOID (WINAPI *)(const char*))GetProcAddress(m_hDLL,"HPIOpen");
		HPIGetFiles=(LRESULT (WINAPI *)(void *, int, LPSTR, LPINT, LPINT))GetProcAddress(m_hDLL,"HPIGetFiles");
		HPIClose=(LRESULT (WINAPI *)(void *))GetProcAddress(m_hDLL,"HPIClose");
		HPIOpenFile=(LPSTR (WINAPI *)(void *hpi, const char*))GetProcAddress(m_hDLL,"HPIOpenFile");
		HPIGet=(void (WINAPI *)(void *Dest, void *, int, int))GetProcAddress(m_hDLL,"HPIGet");
		HPICloseFile=(LRESULT (WINAPI *)(LPSTR))GetProcAddress(m_hDLL,"HPICloseFile");
		HPIDir=(LRESULT (WINAPI*)(void *hpi, int Next, LPSTR DirName, LPSTR Name, LPINT Type, LPINT Size))GetProcAddress(m_hDLL,"HPIDir");
	}

	hpi = HPIOpen(name.c_str());
	if (hpi == NULL)
		return;

	// We'll need the filesizes for files later, so get this info from hpiutil now
	// unfortunately this takes some time
	char fname[512];
	int ftype;
	int fsize;
	LRESULT next = HPIGetFiles(hpi, 0, fname, &ftype, &fsize);
	while (next != 0) {
		if (ftype == 0) {
			string name = fname;
			transform(name.begin(), name.end(), name.begin(), (int (*)(int))tolower);
			fileSizes[name] = fsize;
		}
		next = HPIGetFiles(hpi, (int)next, fname, &ftype, &fsize);
	}
}

CArchiveHPI::~CArchiveHPI(void)
{
	if (hpi)
		HPIClose(hpi);
}

bool CArchiveHPI::IsOpen()
{
	return (hpi != NULL);
}

ABOpenFile_t* CArchiveHPI::GetEntireFile(const string& fileName)
{
	string name = fileName;
	transform(name.begin(), name.end(), name.begin(), (int (*)(int))tolower);

	char* f = HPIOpenFile(hpi, name.c_str());
	if (f == NULL)
		return 0;
	
	ABOpenFile_t* of = new ABOpenFile_t;
	of->pos = 0;
	of->size = fileSizes[name];
	of->data = (char*)malloc(of->size);

	HPIGet(of->data, f, 0, of->size);
	HPICloseFile(f);

	return of;
}

int CArchiveHPI::FindFiles(int cur, string* name, int* size)
{
	if (cur == 0) {
		curSearchHandle++;
		cur = curSearchHandle;
		searchHandles[cur] = fileSizes.begin();
	}

	if (searchHandles[cur] == fileSizes.end()) {
		searchHandles.erase(cur);
		return 0;
	}

	*name = searchHandles[cur]->first;
	*size = searchHandles[cur]->second;

	searchHandles[cur]++;
	return cur;
}