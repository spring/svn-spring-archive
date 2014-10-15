#include "Net.h"

bool CNet::m_bErrorInitialized = false;
CNetError CNet::m_Errors = CNetError();

CNet::CNet(void)
{
	m_bInitialized = false;
	m_bConnected = false;
	if ( !CNet::m_bErrorInitialized )
	{
#ifdef ARCHDEF_PLATFORM_WIN32
		CNet::m_Errors[WSAEINTR]="WSAEINTR";
		CNet::m_Errors[WSAEACCES]="WSAEACCES";
		CNet::m_Errors[WSAEFAULT]="WSAEFAULT";
		CNet::m_Errors[WSAEINVAL]="WSAEINVAL";
		CNet::m_Errors[WSAEMFILE]="WSAEMFILE";
		CNet::m_Errors[WSAEWOULDBLOCK]="WSAEWOULDBLOCK";
		CNet::m_Errors[WSAEINPROGRESS]="WSAEINPROGRESS";
		CNet::m_Errors[WSAEALREADY]="WSAEALREADY";
		CNet::m_Errors[WSAENOTSOCK]="WSAENOTSOCK";
		CNet::m_Errors[WSAEDESTADDRREQ]="WSAEDESTADDRREQ";
		CNet::m_Errors[WSAEMSGSIZE]="WSAEMSGSIZE";
		CNet::m_Errors[WSAEPROTOTYPE]="WSAEPROTOTYPE";
		CNet::m_Errors[WSAENOPROTOOPT]="WSAENOPROTOOPT";
		CNet::m_Errors[WSAEPROTONOSUPPORT]="WSAEPROTONOSUPPORT";
		CNet::m_Errors[WSAESOCKTNOSUPPORT]="WSAESOCKTNOSUPPORT";
		CNet::m_Errors[WSAEOPNOTSUPP]="WSAEOPNOTSUPP";
		CNet::m_Errors[WSAEPFNOSUPPORT]="WSAEPFNOSUPPORT";
		CNet::m_Errors[WSAEAFNOSUPPORT]="WSAEAFNOSUPPORT";
		CNet::m_Errors[WSAEADDRINUSE]="WSAEADDRINUSE";
		CNet::m_Errors[WSAEADDRNOTAVAIL]="WSAEADDRNOTAVAIL";
		CNet::m_Errors[WSAENETDOWN]="WSAENETDOWN";
		CNet::m_Errors[WSAENETUNREACH]="WSAENETUNREACH";
		CNet::m_Errors[WSAENETRESET]="WSAENETRESET";
		CNet::m_Errors[WSAECONNABORTED]="WSAECONNABORTED";
		CNet::m_Errors[WSAECONNRESET]="WSAECONNRESET";
		CNet::m_Errors[WSAENOBUFS]="WSAENOBUFS";
		CNet::m_Errors[WSAEISCONN]="WSAEISCONN";
		CNet::m_Errors[WSAENOTCONN]="WSAENOTCONN";
		CNet::m_Errors[WSAESHUTDOWN]="WSAESHUTDOWN";
		CNet::m_Errors[WSAETIMEDOUT]="WSAETIMEDOUT";
		CNet::m_Errors[WSAECONNREFUSED]="WSAECONNREFUSED";
		CNet::m_Errors[WSAEHOSTDOWN]="WSAEHOSTDOWN";
		CNet::m_Errors[WSAEHOSTUNREACH]="WSAEHOSTUNREACH";
		CNet::m_Errors[WSAEPROCLIM]="WSAEPROCLIM";
		CNet::m_Errors[WSASYSNOTREADY]="WSASYSNOTREADY";
		CNet::m_Errors[WSAVERNOTSUPPORTED]="WSAVERNOTSUPPORTED";
		CNet::m_Errors[WSANOTINITIALISED]="WSANOTINITIALISED";
		CNet::m_Errors[WSAEDISCON]="WSAEDISCON";
		CNet::m_Errors[WSATYPE_NOT_FOUND]="WSATYPE_NOT_FOUND";
		CNet::m_Errors[WSAHOST_NOT_FOUND]="WSAHOST_NOT_FOUND";
		CNet::m_Errors[WSATRY_AGAIN]="WSATRY_AGAIN";
		CNet::m_Errors[WSANO_RECOVERY]="WSANO_RECOVERY";
		CNet::m_Errors[WSANO_DATA]="WSANO_DATA";
		/*
		CNet::m_Errors[WSA_INVALID_HANDLE]="WSA_INVALID_HANDLE";
		CNet::m_Errors[WSA_INVALID_PARAMETER]="WSA_INVALID_PARAMETER";
		CNet::m_Errors[WSA_IO_INCOMPLETE]="WSA_IO_INCOMPLETE";
		CNet::m_Errors[WSA_IO_PENDING]="WSA_IO_PENDING";
		CNet::m_Errors[WSA_NOT_ENOUGH_MEMORY]="WSA_NOT_ENOUGH_MEMORY";
		CNet::m_Errors[WSA_OPERATION_ABORTED]="WSA_OPERATION_ABORTED";
		CNet::m_Errors[WSAINVALIDPROCTABLE]="WSAINVALIDPROCTABLE";
		CNet::m_Errors[WSAINVALIDPROVIDER]="WSAINVALIDPROVIDER";
		CNet::m_Errors[WSAPROVIDERFAILEDINIT]="WSAPROVIDERFAILEDINIT";
		CNet::m_Errors[WSASYSCALLFAILURE]="WSASYSCALLFAILURE";
		*/
#endif
		CNet::m_bErrorInitialized = true;
	}
}

CNet::~CNet(void)
{
	if ( m_bInitialized )
	{
		CloseWinsock();
	}
}

bool CNet::InitWinsock()
{
	// can't initialize twice
	if ( m_bInitialized )
		return false;

#ifdef ARCHDEF_PLATFORM_WIN32
	// here we start up winsock
	WSADATA WSAData;
	int error = WSAStartup(MAKEWORD(2,2), &WSAData);

	if ( error != 0 )
	{
		CLog::Error(CNet::m_Errors[error].c_str(), __FUNCTION__);
		return false;
	}

	if ( WSAData.wVersion != MAKEWORD(2,2) )
	{
		// couldn't get the right version
		CLog::Error("Winsock 2.2 required", __FUNCTION__);
		CloseWinsock();
		return false;
	}
#endif
	m_bInitialized = true;
//	CLog::Error("Winsock initialized", __FUNCTION__);
	return true;
}

string CNet::GetError(long error)
{
	string res = CNet::m_Errors[error];
	if ( res == "" )
		return "Unknown error";
	return res;
}

bool CNet::ShutdownConnection()
{
	if ( m_bConnected == false )
		return true;

	if ( shutdown(m_Socket, SD_SEND) == SOCKET_ERROR)
	{
		CLog::Error("SOCKET_ERROR, failed to shutdown socket", __FUNCTION__);
		return false;
	}

	static char buff[1000];

	// finish reading in every message to clean up nicely
	while ( recv(m_Socket, buff, sizeof(buff), 0) != SOCKET_ERROR );

	if ( closesocket(m_Socket) == SOCKET_ERROR )
	{
		CLog::Error("SOCKET_ERROR, failed to close socket", __FUNCTION__);
		return false;
	}
	m_bConnected = false;
	return true;
}

void CNet::CloseWinsock()
{
	if ( m_bInitialized )
	{
		if ( m_bConnected )
		{
			ShutdownConnection();
		}
#ifdef ARCHDEF_PLATFORM_WIN32
		int res = WSACleanup();
		if ( res == 0 )
		{
//			CLog::Error("Winsock shut down", __FUNCTION__);
			m_bInitialized = false;
			return;
		}
		CLog::Error(GetError(res).c_str(), __FUNCTION__);
#endif
	}
}

bool CNet::StartServer(int port)
{
	if ( m_bConnected )
		return false;

	unsigned long interfaceAddress = inet_addr("0.0.0.0");
	int res = 0;
	if ( interfaceAddress != INADDR_NONE )
	{
		m_Socket = socket(AF_INET, SOCK_STREAM, 0);
		if ( m_Socket != INVALID_SOCKET ) {
			sockaddr_in sockInterface;
			sockInterface.sin_family = AF_INET;
#ifdef ARCHDEF_PLATFORM_WIN32
			sockInterface.sin_addr.S_un.S_addr = interfaceAddress;
#else
			sockInterface.sin_addr.s_addr = interfaceAddress;
#endif
			sockInterface.sin_port = port;
			if ( (res = bind(m_Socket, (sockaddr*)&sockInterface,
				sizeof(sockaddr_in))) != SOCKET_ERROR )
			{
				listen(m_Socket, 64);
				return true;
			}
			else
			{
				CLog::Error(GetError(res).c_str(), __FUNCTION__);
				return false;
			}
		}
		else
		{
#ifdef ARCHDEF_PLATFORM_WIN32
			res = WSAGetLastError();
			CLog::Error(GetError(res).c_str(), __FUNCTION__);
#endif
			return false;
		}
	}
	else
	{
		CLog::Error(GetError(interfaceAddress).c_str(), __FUNCTION__);
		return false;
	}
}
