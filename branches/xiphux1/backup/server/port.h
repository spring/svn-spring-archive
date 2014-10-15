#include <string.h>

#ifndef ARCHDEF_PLATFORM_WIN32
#define strcmpi strcasecmp
#define ZeroMemory(s, c) memset(s, c, 1) 
#endif
