//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------
#ifndef EDITOR_DEF_H
#define EDITOR_DEF_H

#define SAFE_DELETE_ARRAY(c) if(c){delete[] (c);(c)=0;}
#define SAFE_DELETE(c) if(c){delete (c);(c)=0;}


#ifdef _MSC_VER
#define for if(1)for                // MSVC 6 ruuless!
#pragma warning(disable: 4244 4018) // signed/unsigned and loss of precision...
#pragma warning(disable: 4312 4311)
#endif 

using namespace std;

typedef unsigned char uchar;
typedef unsigned long ulong;
typedef unsigned int uint;
typedef unsigned short ushort;

#ifdef _MSC_VER
#define STRCASECMP stricmp
#define SNPRINTF _snprintf
#define VSNPRINTF _vsnprintf
#else
#define STRCASECMP strcasecmp
#define SNPRINTF snprintf
#define VSNPRINTF vsnprintf
#endif

void usDebugBreak ();
void usAssertFailed (const char *condition, const char *file, int line);

class Tool;
struct Model;
class IView;
class Texture;
class TextureHandler;
class TextureGroup;
class TextureGroupHandler;
class EditorViewWindow;
class IK_UI;
class TimelineUI;
class Script;
class AnimTrackEditorUI;
class Timer;

#include "IEditor.h"

struct ArchiveList
{
	bool Load ();
	bool Save ();

	set<string> archives;
};



inline void stringlwr(string& str) {
	transform (str.begin(),str.end(), str.begin(), tolower);
}


bool FileSaveDlg (const char *msg, const char *pattern, string& fn);
bool FileOpenDlg (const char *msg, const char *pattern, string& fn);

extern string applicationPath;

template<typename InputIterator, typename EqualityComparable>
int element_index(InputIterator first, InputIterator last, const EqualityComparable& value) {
	for (int index=0, InputIterator i = first; i != last; ++i, ++index) 
		if (*i == value) return index;
	return -1;
}

template<typename InputIterator>
InputIterator element_at(InputIterator first, InputIterator last, int index) {
	while (first != last) {
		if (!index--) break;
		++first;
	}
	return first;
}

// Used to mark declarations that should be ignored by SWIG
#define NO_SCRIPT

#endif

