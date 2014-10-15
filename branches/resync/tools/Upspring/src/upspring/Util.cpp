//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------

#include "EditorIncl.h"
#include "EditorDef.h"

#include "Util.h"

Logger logger;
esMemStack esTemp;


string ReadZStr(FILE *f)
{
	std::string s;
	int c,i=0;
	while((c = fgetc(f)) != EOF && c) 
		s += c;
	return s;
}


void WriteZStr(FILE *f, const string& s)
{
	int c;
	c = s.length ();
	fwrite(&s[0],c+1,1,f);
}


string GetFilePath (const string& fn)
{
	string mdlPath = fn;
#ifdef WIN32
	string::size_type pos = mdlPath.rfind ('\\');
#else
	string::size_type pos = mdlPath.rfind ('/');
#endif
	if (pos!=string::npos)
		mdlPath.erase (pos+1, mdlPath.size());
	return mdlPath;
}


string ReadString (int offset, FILE *f)
{
	int oldofs = ftell(f);
	fseek (f, offset, SEEK_SET);
	string str= ReadZStr (f);
	fseek (f, oldofs, SEEK_SET);
	return str;
}

// ------------------------------------------------------------------------------------------------
// Globals
// ------------------------------------------------------------------------------------------------

void usDebugBreak()
{
#ifdef _DEBUG
	__asm int 3 
#else
	fltk::message ("An error has occured in the program, so it has to abort now.");
#endif
}

void usAssertFailed (const char *condition, const char *file, int line)
{
	d_trace ("%s(%d): Assertion failed (Condition \'%s\')\n", file, line, condition);
	usDebugBreak ();
}

// ------------------------- Logger ------------------------

Logger::Logger ()
{
	filter = NL_DefaultFilter | NL_NoTag;

	numcb = maxcb = 0;
	cb = 0;
}

Logger::~Logger()
{
	filter = NL_DefaultFilter | NL_NoTag;

	if (cb) {
		delete[] cb;
		cb=0;
	}
}

void Logger::AddCallback (CallbackProc proc, void *data)
{
	if (numcb == maxcb)
		Realloc ();

	int c = numcb ++;
	cb[c].proc = proc;
	cb[c].user_data = data;
}

void Logger::Realloc ()
{
	if (maxcb)
		maxcb *= 2;
	else
		maxcb = 8;

	Callback *nc = new Callback [maxcb];
	
	if (cb)
	{
		for (int a=0;a<numcb;a++)
			nc[a] = cb[a];
		delete [] cb;
	}

	cb = nc;
}

void Logger::RemoveCallback (CallbackProc proc, void *data)
{
	for (int a=0;a<numcb;a++)
		if (cb[a].proc == proc && cb[a].user_data == data)
		{
			if (a != numcb-1)
				std::swap (cb[a], cb[numcb-1]);
			numcb --;
		}
}

void Logger::Trace (LogNotifyLevel lev, const char *fmt, ...)
{
	char buf[512];

	if (!(lev & filter) && lev!=NL_NoTag)
		return;

	va_list ap;
	va_start(ap,fmt);
	VSNPRINTF (buf, 512, fmt, ap);
	va_end (ap);

	for (int a=0;a<numcb;a++)
		cb [a].proc (lev,buf, cb[a].user_data);

	PrintBuf (lev, buf);
}

void Logger::PrintBuf (LogNotifyLevel lev, const char *buf)
{
	switch (lev) {
	case NL_Msg: d_puts ("msg: ");break;
	case NL_Debug: d_puts ("dbg: ");break;
	case NL_Error: d_puts ("error: ");break;
	case NL_Warn: d_puts ("warning: ");break;
	}

	d_puts (buf);
}

void Logger::SetDebugMode (bool mask)
{
	if (mask) 
		filter |= NL_Debug;
	else
		filter &= ~NL_Debug;
}

void Logger::Print (const char *fmt,...)
{
	char buf[256];
	va_list ap;
	va_start(ap,fmt);
	VSNPRINTF (buf, 256, fmt, ap);
	va_end (ap);

	for (int a=0;a<numcb;a++)
		cb [a].proc (NL_NoTag,buf, cb[a].user_data);

	PrintBuf (NL_NoTag, buf);
}

// ------------------------------------------------------------------------------------------------
// esMemStack
// ------------------------------------------------------------------------------------------------

esMemStack::esMemStack ()
{
	cur = 0;
	max = 0;
	buf = 0;
}

esMemStack::~esMemStack ()
{
	SAFE_DELETE_ARRAY (buf);
}

#ifndef SCRATCH_DIRECT_ALLOC

void esMemStack::Allocate (int numByte)
{
	SAFE_DELETE_ARRAY(buf);
	buf = new uchar [numByte];
	if(!buf)
	{
		logger.Trace (NL_Msg, "!!! esMemStack failed to allocate %d bytes !!!\n", numByte);
		exit (-1);
	}
	cur = 0;
	max = numByte;
	lastptr = 0;
}

void esMemStack::Reset()
{
	cur = 0;
	peak = 0;
}

void *esMemStack::GetMem (int amount)
{
	// If you hit this assert, the memory stack was not big enough
	assert (!(amount > max-cur));

	void *p = &buf[cur];
	cur += amount;
	lastptr = (uchar*)p + amount;

	if(peak < cur)
		peak = cur;

	return p;
}

void esMemStack::FreeLast (int nB, void *ptr)
{
	uchar *p = (uchar*)ptr;
	p += nB;

	assert(p == lastptr);

	cur -= nB;
	lastptr = &buf[cur];
}

void esMemStack::RestoreSize (int size)
{
	cur = size;
	lastptr = &buf[cur];
}

#else

void esMemStack::FreeLast (int nB, void *ptr)
{
	uchar *p = (uchar*)ptr;
	SAFE_DELETE_ARRAY( p );
}

void *esMemStack::GetMem (int amount)
{
	return (void*)new uchar [amount];
}

void esMemStack::Allocate (int nB)
{
}

#endif
