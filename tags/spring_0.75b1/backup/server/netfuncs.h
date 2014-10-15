#ifndef NETFUNCS_H
#define NETFUNCS_H

#include "global.h"
#include <pthread.h>

/* Moved stuff in from Net.h - gramuxius */

#ifdef ARCHDEF_PLATFORM_WIN32
#include <winsock2.h>
#include <ws2tcpip.h>

typedef unsigned long in_addr_t;

#define EMSGSIZE WSAEMSGSIZE
#define NETGETERROR() WSAGetLastError()
// #define NETGETERRORSTRING() CNet::GetError(WSAGetLastError()).c_str()

void err_sys(const char* output);

#else

#include <arpa/inet.h>
#include <errno.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define INVALID_SOCKET 0
#define SOCKET_ERROR -1

#define NETGETERROR() errno 
#define WSAEINTR      EINTR
//#define close       closesocket;
#define closesocket   close
#define SD_SEND       SHUT_WR
typedef int           SOCKET;

#endif

int Pthread_create(pthread_t* id, const pthread_attr_t* attr, void* (*func)(void*), void* arg);
int Pthread_join(pthread_t id, void** status);
int Pthread_mutex_lock(pthread_mutex_t *mptr, const char* function);
int Pthread_mutex_unlock(pthread_mutex_t *mptr, const char* function);
SOCKET Socket( int af, int type, int protocol);
int Connect( SOCKET s, const sockaddr* servaddr, socklen_t arrlen);
int Shutdown(SOCKET s, int how);
int Bind(SOCKET s, const sockaddr* addr, socklen_t addrlen);
int Listen(SOCKET s, int backlog);
SOCKET Accept(SOCKET s, struct sockaddr* addr, socklen_t* addrlen);
int Closesocket(SOCKET s);
int Getsockname(SOCKET s, sockaddr* name, socklen_t* addrlen);
int Getpeername(SOCKET s, sockaddr* name, socklen_t* addrlen);
int Setsockopt( SOCKET s, int level, int optname, const char* optval, int optlen );
bool tcp_listen( int port, SOCKET& sd );
#endif
