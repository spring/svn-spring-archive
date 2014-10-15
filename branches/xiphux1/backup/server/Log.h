#ifndef LOG_H
#define LOG_H

#include "global.h"

#include <fstream>
#include <string>

using namespace std;

// class CLog
//  handles logging.  record is for debugging information, which can be disabled
// by undefining DEBUG
class CLog
{
public:
	static pthread_mutex_t	m_LogMutex;
	static pthread_mutex_t	m_LogErrorMutex;
	static ofstream			m_outStream;
	static ofstream			m_ErrorStream;

	CLog(void);
	~CLog(void);

	static char buffer[255];

	static void OpenDebugLog(const char* filename);
	static void OpenErrorLog(const char* filename);

	static void CloseDebugLog() { m_outStream.close(); }
	static void CloseErrorLog() { m_ErrorStream.close(); }

	static void Record(const char* message, ...);
	static void Error(const char* message, const char* location, ...);
	static void FatalError(const char* message, const char* location, ...);
};

#endif
