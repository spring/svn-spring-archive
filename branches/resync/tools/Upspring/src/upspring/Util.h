//-----------------------------------------------------------------------
//  Upspring model editor
//  Copyright 2005 Jelmer Cnossen
//  This code is released under GPL license, see LICENSE.HTML for info.
//-----------------------------------------------------------------------

#include "DebugTrace.h"

// ------------------------------------------------------------------------------------------------
// Text Output Interface
// ------------------------------------------------------------------------------------------------
class esTextOutput
{
public:
	virtual void Print (const char *fmt, ...) = 0;
};

// ------------------------------------------------------------------------------------------------
// Text Input Interface
// ------------------------------------------------------------------------------------------------
class esTextInput
{
public:
	virtual bool Read (char *dst, int num) = 0; // returns the number of bytes readed, 0 on EOF
};

// ------------------------------------------------------------------------------------------------
// Global logging device
// ------------------------------------------------------------------------------------------------
enum LogNotifyLevel
{
	NL_Msg	= 1, // normal msg
	NL_Debug= 2, // debug msg
	NL_Warn = 4,
	NL_Error= 8,
	NL_NoTag=16,
	NL_DefaultFilter = NL_Warn | NL_Error,
	NL_DebugFilter = NL_Debug | NL_Warn | NL_Msg | NL_Error
};

class Logger : public esTextOutput
{
public:
	Logger ();
	~Logger ();

	void PrintBuf (LogNotifyLevel lev, const char *buf);
	void Trace (LogNotifyLevel lev, const char *fmt, ...);
	void Print (const char *fmt, ...); // LogNotifyLevel is NL_Msg here

	typedef void (*CallbackProc)(LogNotifyLevel level, const char *str, void *user_data);
	void AddCallback (CallbackProc proc, void *user_data);
	void RemoveCallback (CallbackProc proc, void *user_data);

	void SetDebugMode (bool enable);

	unsigned int filter; // LogNotifyLevel bitmask
protected:
	void Realloc ();

	int numcb, maxcb;
	struct Callback
	{
		CallbackProc proc;
		void *user_data;
	};
	Callback *cb;
};

extern Logger logger;



// directly allocate memory using std allocation routines instead of the ScratchBuffer
// goes extremely slow obviously but is handy when debugging
//#define SCRATCH_DIRECT_ALLOC

// ignore FreeLast calls and only free when Reset is called
//#define SCRATCH_NO_DELETING

// reserve some extra space to check bounds 
//#define SCRATCH_BOUNDCHECK

class esMemStack
{
public:
	esMemStack ();
	~esMemStack ();

	void *GetMem (int amount);
	void Reset ();
	void Allocate (int numByte);
	void FreeLast (int nB, void *ptr);
	int GetCurSize () { return cur; }
	int GetPeak () { return peak; }
	int GetMax () { return max; }
	void ThrowOnOverflow(bool Throw) { use_exc = Throw; }
	unsigned char* GetBuf (){ return buf; }
	void RestoreSize (int s);
	bool IsAvailable(int numBytes) { return cur + numBytes <= max; }

protected:
	int peak;
	int max, cur;
	unsigned char *buf;
	esMemStack *child;
	bool use_exc; // use exceptions at overflow

	unsigned char *lastptr; // pointer to last unused byte
};

/* Template functions for easy allocation on the global scratch buffer
 * Constructors and destructors are ignored
 */
template<class T> T* esTempAlloc (int num)
{
	return (T*)esTemp.GetMem (sizeof(T) * num);
}

template<class T> void esTempFree (T *data, int num)
{
	esTemp.FreeLast (sizeof(T) * num, data);
}

extern esMemStack esTemp;


std::string ReadString (int offset, FILE *f);
std::string ReadZStr (FILE*f);
void WriteZStr (FILE *f, const std::string& s);
std::string GetFilePath (const std::string& fn);
