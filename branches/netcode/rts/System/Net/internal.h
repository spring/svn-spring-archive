/* Author: Tobi Vollebregt */

#ifndef INTERNAL_H
#define INTERNAL_H

#include <assert.h>
#include <stdarg.h>
#include <stdexcept>
#include <stdio.h>
#include <string>
#include <string.h>
#include <SDL.h>

static inline void LOG(const char* fmt, ...) __attribute__((format(printf, 1, 2)));
static inline void LOG(const char* fmt, ...)
{
	va_list argp;
	va_start(argp, fmt);
	vfprintf(stderr, fmt, argp);
	va_end(argp);
}

#ifdef WIN32

#include <sstream>
#include <winsock2.h>

static inline int GetLastError() { return WSAGetLastError(); }
static inline std::string GetErrorString(int e) { return (std::stringstream() << e).str(); }
static inline bool IsFakeError(int e) { return e == WSAEWOULDBLOCK || e == WSAECONNRESET || err == WSAEINTR; }

#else // !WIN32

#ifndef __BEOS__
#include <arpa/inet.h>
#endif // !__BEOS__
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define closesocket    close

static inline int GetLastError() { return errno; }
static inline std::string GetErrorString(int e) { return strerror(e); }
static inline bool IsFakeError(int e) { return e == EWOULDBLOCK || e == ECONNRESET || e == EINTR; }

#endif // !WIN32

namespace net {

typedef unsigned char uchar;

static inline int GetTime() { return SDL_GetTicks(); }

/** Write a 24 bit big endian integer to a character stream. */
static inline uchar* Write24(uchar* p, int x)
{
	p[0] = (x >> 16) & 255;
	p[1] = (x >> 8) & 255;
	p[2] = x & 255;
	return p + 3;
}

/** Read a 24 bit big endian integer from a character stream. */
static inline int Read24(const uchar* p)
{
	return p[0] << 16 | p[1] << 8 | p[2];
}

/** Write a 32 bit big endian integer to a character stream. */
static inline uchar* Write32(uchar* p, int x)
{
	p[0] = (x >> 24) & 255;
	p[1] = (x >> 16) & 255;
	p[2] = (x >> 8) & 255;
	p[3] = x & 255;
	return p + 4;
}

/** Read a 32 bit big endian integer from a character stream. */
static inline int Read32(const uchar* p)
{
	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
}

/** Generic error. */
struct Error : public std::runtime_error
{
	Error(const char* msg, int e) :
			std::runtime_error(std::string(msg) + ": " + GetErrorString(e)) {}
};

/** Error in socket(). */
struct SocketError : public Error
{
	SocketError(int e) :
			Error("socket error", e) {}
};

/** Error in bind(). */
struct BindError : public Error
{
	BindError(int e) :
			Error("bind error", e) {}
};

/** Error in recv() or recvfrom(). */
struct ReceiveError : public Error
{
	ReceiveError(int e) :
			Error("receive error", e) {}
};

/** Error in send() or sendto(). */
struct SendError : public Error
{
	SendError(int e) :
			Error("send error", e) {}
};

class IConnection;

/** Connection timed out. Includes pointer to connection
so appropriate action can be taken. */
struct TimeoutError: public std::runtime_error
{
	TimeoutError(IConnection* conn) :
			std::runtime_error("timeout error"), connection(conn) {}
	IConnection* connection;
};

/** Error in CFileSource or CFileSink. */
struct FileError: public std::runtime_error
{
	FileError(std::string filename) :
			std::runtime_error(filename) {}
};

/** Irrecoverable buffer overflow, data has been lost. */
struct OverflowError: public std::runtime_error
{
	OverflowError(IConnection* conn) :
			std::runtime_error("overflow error"), connection(conn) {}
	IConnection* connection;
};

}; // end of namespace net

#endif // !INTERNAL_H
