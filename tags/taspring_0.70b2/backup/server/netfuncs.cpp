#include "netfuncs.h"

#define BACKLOG 15

#ifdef WIN32

void err_sys(const char* output)
{
}
#define MAXCHATNAMELEN				255
#define NETLOGERROR()
#define NETLOGSUCCESS()
#define PTHREADLOGERROR(n)
#define PTHREADLOGSUCCESS()

#else

#define NETLOGERROR()
#define NETLOGSUCCESS()
#define PTHREADLOGERROR(n)
#define PTHREADLOGSUCCESS()

#endif

bool NetStart()
{
#ifdef WIN32
	WSAData wsadata;
	if ( WSAStartup(MAKEWORD(2,2), &wsadata) != 0 )
		return false;
#endif
	return true;
}

bool NetClose()
{
#ifdef WIN32
	if ( WSACleanup() != 0 )
		return false;
#endif
	return true;
}

int Pthread_join(pthread_t id, void** status)
{
	int n;
	if ( (n=pthread_join(id, status)) == 0)
	{
		PTHREADLOGERROR(n);
		return n;
	}

	PTHREADLOGSUCCESS();
	return n;
}

int Pthread_create(pthread_t* id, const pthread_attr_t* attr, void* (*func)(void*), void* arg)
{
	int n;
	if ( (n=pthread_create(id, attr, func, arg)) == 0)
	{
		PTHREADLOGERROR(n);
		return n;
	}

	PTHREADLOGSUCCESS();
	return n;
}

int Pthread_mutex_lock(pthread_mutex_t *mptr, const char* function)
{
#ifdef MUTEX_DEBUG
	fprintf(stderr, "MUTEX_LOCK %p in %s\n", mptr, function);
#endif
	int n;
	if ( (n = pthread_mutex_lock(mptr)) == 0)
	{
		PTHREADLOGERROR(n);
		return n;
	}

	PTHREADLOGSUCCESS();
	return n;
}

int Pthread_mutex_unlock(pthread_mutex_t *mptr, const char* function)
{
#ifdef MUTEX_DEBUG
	fprintf(stderr, "MUTEX_UNLOCK %p in %s\n", mptr, function);
#endif
	int n;
	if ( (n = pthread_mutex_unlock(mptr)) == 0)
	{
		PTHREADLOGERROR(n);
		return n;
	}
	PTHREADLOGSUCCESS();
	return n;
}

SOCKET Socket(int af, int type, int protocol)
{
	SOCKET n;
	if ( ( n = socket(af,type,protocol)) < 0 )
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

int Connect( SOCKET s, const sockaddr* servaddr, socklen_t arrlen)
{
	int n;
	if ( (n=connect(s, servaddr, arrlen)) < 0 )
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

int Shutdown( SOCKET s, int how )
{
	int n;
	if ( (n=shutdown(s, how)) != 0 )
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

int Bind(SOCKET s, const sockaddr* addr, socklen_t addrlen)
{
	int n;
	if ((n=bind(s,addr,addrlen))<0)
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

int Setsockopt( SOCKET s, int level, int optname, const char* optval, int optlen )
{
	int n;
	if ((n=setsockopt(s,level,optname,optval,optlen))!= 0)
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}


int Listen(SOCKET s, int backlog)
{
	int n;
	
	char* ptr;

	// for unix servers, this environment variable can override the
	// backlog variable sent
	if ( (ptr =getenv("LISTENQ"))!= 0)
		backlog = atoi(ptr);
	
	if ((n=listen(s,backlog)))
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

SOCKET Accept(SOCKET s, struct sockaddr* addr, socklen_t* addrlen)
{
	SOCKET n;

	if ( (n=accept(s,addr, addrlen)) < 0)
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

int Closesocket(SOCKET s)
{
	int n;

	if ( (n=closesocket(s))<0)
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

int Getsockname(SOCKET s, sockaddr* name, socklen_t* addrlen)
{
	int n;

	if ( (n=getsockname(s,name,addrlen)) < 0)
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

int Getpeername(SOCKET s, sockaddr* name, socklen_t* addrlen)
{
	int n;

	if ( (n=getpeername(s,name,addrlen)) < 0)
		NETLOGERROR();
	else
		NETLOGSUCCESS();

	return n;
}

bool tcp_listen( int port, SOCKET& sd )
{
	in_addr_t interfaceaddress = INADDR_ANY;
	sd = Socket(AF_INET, SOCK_STREAM, 0);
	int res;
	if ( sd != INVALID_SOCKET )
	{
		const int on = 1;
		Setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, (const char*)&on, sizeof(on));
		sockaddr_in sockIn;
		sockIn.sin_family = AF_INET;
#ifdef ARCHDEF_PLATFORM_WIN32
		sockIn.sin_addr.S_un.S_addr = interfaceaddress;
#else
		sockIn.sin_addr.s_addr = interfaceaddress;
#endif
		sockIn.sin_port = port;
		if ( (res = Bind(sd, (sockaddr*)&sockIn, sizeof(sockIn)))!= SOCKET_ERROR )
		{
			if ( Listen(sd, BACKLOG) != 0 )
				return false;
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	return 0;
}
