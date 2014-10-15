#include <iostream>
#include <cstdio>

#include "global.h"
#include "Dbase.h"
#include "Net.h"
#include "User.h"
#include "ServerSettings.h"

#include "ChatroomManager.h"
#include "BattleRoomManager.h"
#include "CrashDumpHandler.h"

using namespace std;

bool tcp_listen( int port, SOCKET& sd );
void* conn_listener( void* socket );
void* conn_handler ( void* listener );

CChatroomManager		g_Manager;
CBattleRoomManager		g_BManager;
CDbase					g_Database;
CServerSettings			g_ServerSettings;

int main()
{
	CLog::OpenDebugLog("debug.txt");
	CLog::OpenErrorLog("error.txt");

	// Create a crashdumphandler (it will register itself and stuff by doing this)
	CCrashDumpHandler c;

	g_ServerSettings.Parse("settings.txt");

	if ( g_Database.Connect("localhost", g_ServerSettings.GetMysqlUser().c_str(), 
		g_ServerSettings.GetMysqlPassword().c_str(), g_ServerSettings.GetMysqlDatabase().c_str(), 0) )
		CLog::Record("Connection to database successful");
	else
	{
		CLog::Error("Failed to connect to database using\n\tUser: %s\n\tPassword: %s\n\tDatabase: %s", __FUNCTION__,
			g_ServerSettings.GetMysqlUser().c_str(), g_ServerSettings.GetMysqlPassword().c_str(), g_ServerSettings.GetMysqlDatabase().c_str());
		CLog::CloseDebugLog();
		CLog::CloseErrorLog();
		return 1;
	}
	fclose(stderr);
	FILE* mutexlog = fopen("mutexlog.txt", "w");

	g_Manager.CreateChatroom("Main", false, true);
	g_Manager.CreateChatroom("Help", false, true);
	//	g_Manager.CreateChatroom("Blaaaah!", false, true);

	SOCKET sd;
	
	if ( !tcp_listen(htons(g_ServerSettings.GetPort()), sd) )
	{
		CLog::Error("Listen failed", __FUNCTION__);
		CLog::CloseDebugLog();
		CLog::CloseErrorLog();
		return 1;
	}
	pthread_t listener;
	SOCKET* p_sd = new SOCKET;
	*p_sd = sd;
	Pthread_create(&listener, NULL, &conn_listener, p_sd);

	bool keepgoing = true;
	int name;

	while ( keepgoing )
	{
		char temp = cin.get();
		switch ( temp )
		{
		case 'q':
			CLog::Record("Shutting server down...");
			Closesocket(sd);
			keepgoing = false;
			break;
		case 'k':
			cin >> name;
			if ( CUser::KickUser(name) )
				CLog::Record("%d kicked", name);
			else
				CLog::Record("Failed to kick %d", name);
			break;
		default:
			break;
		}
	}

	fclose(mutexlog);

	CLog::CloseDebugLog();
	CLog::CloseErrorLog();
	return 0;
}

void* conn_listener( void* socket )
{
	sockaddr_in clientAddr;
	SOCKET sd = *(SOCKET*)socket;
	bool keepgoing = true;
	while ( keepgoing )
	{
		socklen_t len = (socklen_t)sizeof(clientAddr);
		SOCKET accepted = Accept(sd, (sockaddr*)&clientAddr, &len);
		
		if ( accepted == INVALID_SOCKET )
		{
			switch ( NETGETERROR() )
			{
			case WSAEINTR:
			  break;
			default:
			  keepgoing = false;
			  break;
			}
			// failed to accept connection
			continue;
		}
		
		CLog::Record("OK");

		SOCKET* listener = new SOCKET;
		*listener = accepted;

		pthread_t idListener;
		int res = Pthread_create(&idListener, NULL, &conn_handler, (void*)listener);
	}
	
	CLog::Record("Listener is done");

	return NULL;
}

void* conn_handler ( void* listener )
{
	CLog::Record("Connected - %d", *(int*)listener);

	CUser user;
	SOCKET conn = *(SOCKET*)listener;

	delete listener;
	listener = NULL;

	user.Init(conn, &g_Manager, &g_BManager);
	user.Do();

	CLog::Record("Disconnected -  %d", (int)conn);
	
	return NULL;
}
