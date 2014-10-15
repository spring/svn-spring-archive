#include "CrashDumpHandler.h"

#ifdef ARCHDEF_PLATFORM_WIN32
#include <windows.h>
#include <dbghelp.h>

#pragma comment (lib,"dbghelp.lib")

LONG WINAPI CustomUnhandledExceptionFilter(PEXCEPTION_POINTERS pExInfo)
{
   if (EXCEPTION_BREAKPOINT == pExInfo->ExceptionRecord->ExceptionCode)
   {
	   // Breakpoint. Don't treat this as a normal crash.
	   return EXCEPTION_CONTINUE_SEARCH;
   }

   // Create a file for the minidump
   HANDLE hFile = CreateFile(
      "crash.dmp",
      GENERIC_WRITE,
      0,
      NULL,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      NULL);

   // Now write the dump to file
   MINIDUMP_EXCEPTION_INFORMATION eInfo;
   eInfo.ThreadId = GetCurrentThreadId();
   eInfo.ExceptionPointers = pExInfo;
   eInfo.ClientPointers = FALSE;

   MiniDumpWriteDump(
      GetCurrentProcess(),
      GetCurrentProcessId(),
      hFile,
      MiniDumpWithIndirectlyReferencedMemory,
      &eInfo,
	  NULL,
      NULL);

   CloseHandle(hFile);

   //printf("noo crash\n");
   //BOOL result = _crashStateMap.Lookup(GetCurrentProcessId())->GenerateErrorReport(pExInfo, NULL);

   return EXCEPTION_EXECUTE_HANDLER;
}
#endif

CCrashDumpHandler::CCrashDumpHandler(void)
{
#ifdef ARCHDEF_PLATFORM_WIN32
	SetUnhandledExceptionFilter(CustomUnhandledExceptionFilter);
	SetErrorMode(SEM_FAILCRITICALERRORS);
#endif
}

CCrashDumpHandler::~CCrashDumpHandler(void)
{
}

