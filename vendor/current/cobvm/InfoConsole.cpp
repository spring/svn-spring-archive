#include "StdAfx.h"
#include ".\infoconsole.h"
#include "stdarg.h"

CInfoConsole::CInfoConsole(void)
{
}

void CInfoConsole::AddLine(char const *fmt, ...)
{
		char text[500];
	va_list		ap;										// Pointer To List Of Arguments

	if (fmt == NULL)									// If There's No Text
		return;											// Do Nothing

	va_start(ap, fmt);									// Parses The String For Variables
	    vsprintf(text, fmt, ap);						// And Converts Symbols To Actual Numbers
	va_end(ap);											// Results Are Stored In Text

	char text2[500];
	strcpy(text2,text);
	printf(text2);
	printf("\n");
}


CInfoConsole::~CInfoConsole(void)
{
}

CInfoConsole *info;