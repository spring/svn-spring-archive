#ifndef NET_H
#define NET_H

#include "global.h"

#include <map>
#include <string>

using namespace std;

typedef map<long, string> CNetError;

class CNet
{
private:
	static bool			m_bErrorInitialized;
	static CNetError	m_Errors;
	bool				m_bConnected;
	bool				m_bInitialized;
	SOCKET				m_Socket;

public:
	CNet(void);
	~CNet(void);

	static string GetError(long error);

	bool InitWinsock();
	void CloseWinsock();

	bool StartServer(int port);
	bool ShutdownConnection();
};

#endif
