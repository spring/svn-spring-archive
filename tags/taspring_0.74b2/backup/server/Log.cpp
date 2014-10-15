#include "Log.h"

#include <cstdio>
#include <cstdarg>

using namespace std;

/* Changed string to char* and altered the iterators accordingly. GCC
   wants va-stuff to be Plain Old Data. - gramuxius
 */

ofstream CLog::m_outStream;
ofstream CLog::m_ErrorStream;

pthread_mutex_t CLog::m_LogMutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t CLog::m_LogErrorMutex = PTHREAD_MUTEX_INITIALIZER;

CLog::CLog(void)
{
}

CLog::~CLog(void)
{
}

void CLog::OpenDebugLog(const char* filename)
{
	m_outStream.open(filename);
}

void CLog::OpenErrorLog(const char* filename)
{
	m_ErrorStream.open(filename);
}

void CLog::Record(const char* message, ...)
{
#ifdef DEBUG
	Pthread_mutex_lock(&CLog::m_LogMutex, __FUNCTION__);
	va_list va;

	va_start(va, message);

	//basic_string<char, char_traits<char>, allocator<char> >::iterator iter = message.begin();
	const char* iter = message;
	//while ( iter != message.end() )
	while ( *iter )
	{
		if ( *iter == '%' )
		{
			iter++;
			switch ( *iter )
			{
			case 'd':
				m_outStream << va_arg(va, int);
				break;
			case 's':
				m_outStream << va_arg(va, const char*);
				break;
			case 'f':
				m_outStream << va_arg(va, double);
				break;
			default:
				break;
			}
		}
		else
			m_outStream.put(*iter);
		iter++;
	}
	m_outStream << endl;
	m_outStream.flush();

	if ( m_outStream.tellp() > MAXLOGSIZE )
	{
		// delete the log and start a new one up
		m_outStream.close();
		m_outStream.open("debug.txt");
	}
	Pthread_mutex_unlock(&CLog::m_LogMutex, __FUNCTION__);
#endif
}

void CLog::Error(const char* message, const char* location, ...)
{
	Pthread_mutex_lock(&CLog::m_LogErrorMutex, __FUNCTION__);
	m_ErrorStream << "Error: ";
	va_list va;
	va_start(va, location);
	//basic_string<char, char_traits<char>, allocator<char> >::iterator iter = message.begin();
	const char* iter = message;
	//while ( iter != message.end() )
	while ( *iter )
	{
		if ( *iter == '%' )
		{
			iter++;
			switch ( *iter )
			{
			case 'd':
				m_ErrorStream << va_arg(va, int);
				break;
			case 's':
				m_ErrorStream << va_arg(va, const char*);
				break;
			case 'f':
				m_ErrorStream << va_arg(va, double);
				break;
			default:
				break;
			}
		}
		else
			m_ErrorStream.put(*iter);
		iter++;
	}
	m_ErrorStream.flush();
	if ( location != NULL )
		m_ErrorStream << " in function " << location << endl;
	else
		m_ErrorStream << endl;
	m_ErrorStream.flush();
	Pthread_mutex_unlock(&CLog::m_LogErrorMutex, __FUNCTION__);
}

void CLog::FatalError(const char* message, const char* location, ...)
{
	Pthread_mutex_lock(&CLog::m_LogErrorMutex, __FUNCTION__);
	m_ErrorStream << "FatalError: ";
	va_list va;
	va_start(va, location);
	//basic_string<char, char_traits<char>, allocator<char> >::iterator iter = message.begin();
	const char* iter = message;
	//while ( iter != message.end() )
	while ( *iter )
	{
		if ( *iter == '%' )
		{
			iter++;
			switch ( *iter )
			{
			case 'd':
				m_ErrorStream << va_arg(va, int);
				break;
			case 's':
				m_ErrorStream << va_arg(va, const char*);
				break;
			case 'f':
				m_ErrorStream << va_arg(va, double);
				break;
			default:
				break;
			}
		}
		else
			m_ErrorStream.put(*iter);
		iter++;
	}
	if ( location != NULL )
		m_ErrorStream << " in function " << location << endl;
	else
		m_ErrorStream << endl;
	m_ErrorStream.close();
	Pthread_mutex_unlock(&CLog::m_LogErrorMutex, __FUNCTION__);
}
