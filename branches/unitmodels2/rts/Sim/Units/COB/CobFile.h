#ifndef __COB_FILE_H__
#define __COB_FILE_H__

#include <iostream>
#include <vector>
#include <string>
#include <map>

//0 = none
//1 = script calls
//2 = show every instruction
#define COB_DEBUG	0

// Should return true for scripts that should have debug output. 
#define COB_DEBUG_FILTER (script.name == "scripts/ARMJETH.cob")

using namespace std;

class CFileHandler;

class CCobFile
{
public:
	vector<string> scriptNames;
	vector<int> scriptOffsets;
	vector<int> scriptLengths;			//Assumes that the scripts are sorted by offset in the file
	vector<string> pieceNames;
	vector<int> scriptIndex;
	vector<int> sounds;
	map<string, int> scriptMap;
	int* code;
	int numStaticVars;
	string name;
public:
	CCobFile(CFileHandler &in, string name);
	~CCobFile(void);
	int getFunctionId(const string &name);
};

#endif // __COB_FILE_H__
