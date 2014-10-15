#include "User.h"

//#pragma warning(disable:4267)

#include "ChatroomManager.h"
#include "BattleRoomManager.h"
#include "Dbase.h"
#include "Net.h"
#include "ServerSettings.h"
#include "port.h"

#include <cstdio>
#include <iostream>

using namespace std;

extern CDbase g_Database;
extern CServerSettings			g_ServerSettings;

map<int, CUser*> CUser::m_Users;// = map<unsigned int, CUser*>();
pthread_mutex_t CUser::m_UserMutex = PTHREAD_MUTEX_INITIALIZER;

// cuser constructor
CUser::CUser(void)
{
	m_bLoggedIn = false;
	m_Socket = INVALID_SOCKET;
	m_bInitialized = false;
	m_currState.complete = true;
	m_FailedAttempts = 0;
	m_HostedBattleID = -1;
	m_sName = "NotLoggedIn";
	m_bOverrideIP = false;
	m_IP = 0;
}

CUser::~CUser(void)
{
	// if the user is logged in
	if ( this->m_bLoggedIn )
	{
		Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
		map<int, CUser*>::iterator iter = CUser::m_Users.find(this->m_ID);
		if ( iter != CUser::m_Users.end() )
		{
			// remove the current users from the user map
			CUser::m_Users.erase(iter);
		}
		Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
		
		// notifies all chatrooms that this user is leaving
		m_pChatroomManager->LeaveChatroom(this->m_ID, -1);

		// destroys a battle room if this user was hosting and didn't have a chance to send the appropriate kill message
		if ( this->m_HostedBattleID != -1 )
			m_pBattleRoomManager->DestroyRoom(this->m_HostedBattleID);
		
		// closes the connection
		if ( m_Socket != INVALID_SOCKET )
		{
			Closesocket(m_Socket);
			this->m_Socket = INVALID_SOCKET;
		}
	}
	// clears the backbuffer
	EmptyBackBuffer();
#ifdef LOGSEND
	m_SentLog.close(); 
#endif
}

// function CUser::Init
//  Initializes a user by sending its socket, as well as pointers to the 
// chatroom and battleroom managers
void CUser::Init(SOCKET sd, CChatroomManager* crman, CBattleRoomManager* brman )
{
	if ( sd < 0 || crman == NULL || brman == NULL )
		return;
	m_bInitialized = true;
	m_Socket = sd;
	m_pChatroomManager = crman;
	m_pBattleRoomManager = brman;
}

// function CUser::SendTo
//  Sends len bytes from data along the current socket
bool CUser::SendTo(const char* data, size_t len)
{
#ifdef LOGSEND
	if ( m_SentLog.is_open() )
	{
		m_SentLog.write(data, len);
		m_SentLog.flush();
	}
#endif
	send(this->m_Socket, data, len, 0);
	return true;
}

// function Do
// takes over control of the client
void CUser::Do()
{
	CLog::Record("Start listening to messages from %d", this->m_Socket);

	//char* temp = NULL;

	while ( ( m_iSizeBuffer = recv(m_Socket, m_pBuffer, BUFFERLEN, 0)) != 0 )
	{
		if ( (int)m_iSizeBuffer == SOCKET_ERROR )
		{
			/*
			sprintf(CLog::buffer, "NETGETERROR %d\n", NETGETERROR());
			CLog::Error(CLog::buffer, __FUNCTION__);
			*/
			break;
		}
		
		m_iReadFromBuffer = 0;		
		
		CLog::Record("Bytes received from %s-%d: %d", GetName(), this->m_Socket, m_iSizeBuffer);

		while ( HandlePacket() );
	}

	if ( m_bLoggedIn )
	{
		CUser::KickUser(m_ID);
	}
}

// function CUser::AddUser
//  Adds a user to the main user map
bool CUser::AddUser(CUser* newUser)
{
	Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
	m_Users[newUser->GetId()] = newUser;
	Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	return true;
}

// if this function is called, a mutex lock should be acquired
// manually by the caller
CUser* CUser::GetUser(int id)
{
	if ( m_Users.find(id) != m_Users.end() )
		return m_Users[id];
	else
		return NULL;
}

// function CUser::KickUser
//  kicks the user with the id from the server
bool CUser::KickUser(int id)
{
	bool res = true;
	Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);

	CUser* user = CUser::GetUser(id);
	if ( user == 0 )
		res = false;
	else
	{
		CLog::Record("Kicking %s id %d", user->GetName(), id);
		Closesocket(user->m_Socket);
		user->m_Socket = INVALID_SOCKET;
	}

	Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	return res;
}

// function EmptyBackBuffer
//  Emptys the back buffer in use by the receiver
void CUser::EmptyBackBuffer()
{
	while ( m_pBackBuffer.size() > 0 )
	{
		sBackBufferEntry& entry = m_pBackBuffer.front();
		m_pBackBuffer.pop();
		delete[] entry.data;
	}
}

// function CUser::GetFromBuffer
//  Reads bytes number of bytes from the backbuffer into dest
// returns false if there isn't enough data in the backbuffer
bool CUser::GetFromBuffer(void* dest, size_t bytes)
{
	if ( m_pBackBuffer.size() == 0 )
		return false;
	sBackBufferEntry &entry = m_pBackBuffer.front();
		
	size_t copied = 0;
	while ( copied < bytes )
	{
		if ( m_pBackBuffer.size() == 0 )
		{
			CLog::Error("User %s does not have enough data in the backbuffer", GetName());
			return false;
		}
		size_t toread;
		if ( entry.read + (bytes-copied) <= entry.size )
			toread = bytes-copied;
		else
			toread = entry.size - entry.read;
		memcpy((void*)(&((char*)dest)[copied]), (const void*)(&((char*)entry.data)[entry.read]), toread);
		entry.read += toread;
		copied += toread;
		if ( entry.read == entry.size )
		{
			delete[] entry.data;
			m_pBackBuffer.pop();
			if ( m_pBackBuffer.size() == 0 )
				return true;
			entry = m_pBackBuffer.front();
		}
	}
	return true;
}

// function CUser::ExecutePacketChatMessage
//  Sends a chat message.  Finds all the information in the backbuffer, like in all other packets
void CUser::ExecutePacketChatMessage()
{
	int roomid;
	// gets the room id
	GetFromBuffer((void*)&roomid, sizeof(int));
	string quote;
	// and gets the string.  messageSize-7 is the length of the string
	GetStringFromBuffer(quote, m_currState.messageSize-7);

	// just ignore it
	if ( quote.length() > MAXMESSAGELEN )
		return;
	CLog::Record("Chat sent: %s to %d from %s", quote.c_str(), roomid, GetName());

	m_pChatroomManager->PostChatMessage(this->m_ID, roomid, quote);
}

// function ExecutePacketLogin
//  Handles user authentication.  Currently does not allow for anon login, but that will be changed
void CUser::ExecutePacketLogin()
{
	string name, passwd;
	char version[2];
	GetFromBuffer(version, sizeof(version));
	GetStringFromBuffer(name, MAXNAME);
	GetStringFromBuffer(passwd, MAXPASSWD);
	
	if ( version[0] != VERMAJOR || version[1] != VERMINOR )
	{
		char message[2];
		message[0] = PACK_LOGINFAILED;
		message[1] = LOGINERROR_VERSION;
		SendTo(message, sizeof(message));
		Closesocket(this->m_Socket);
		this->m_Socket = INVALID_SOCKET;

//		CLog::Error("User booted, bad version", __FUNCTION__);
		return;
	}

	for ( unsigned int i = 0; i < name.length(); i++ )
	{
		if ( !( name[i] >= 'a' && name[i] <= 'z') && !(name[i] >= 'A' && name[i] <= 'Z')
			&& !(name[i] >= '0' && name[i] <= '9' ))
		{
			char message[2];
			message[0] = PACK_LOGINFAILED;
			message[1] = LOGINERROR_USER;
			SendTo(message, sizeof(message));
			Closesocket(this->m_Socket);
			this->m_Socket = INVALID_SOCKET;

//			CLog::Error("User booted, bad username", __FUNCTION__);
			return;
		}
	}

	for ( unsigned int i = 0; i < passwd.length(); i++ )
	{
		if ( !( passwd[i] >= 'a' && passwd[i] <= 'z') && !(passwd[i] >= 'A' && passwd[i] <= 'Z')
			&& !(passwd[i] >= '0' && passwd[i] <= '9' ))
		{
			char message[2];
			message[0] = PACK_LOGINFAILED;
			message[1] = LOGINERROR_PASSWORD;
			SendTo(message, sizeof(message));
			Closesocket(this->m_Socket);
			this->m_Socket = INVALID_SOCKET;

//			CLog::Error("User booted, bad username", __FUNCTION__);
			return;
		}
	}

	// make the name lower case
	for ( unsigned int i = 0; i < name.length(); i++ )
		name[i] = (char)tolower(name[i]);

	char query[255];

	sprintf(query, "SELECT * FROM %s WHERE Username=\'%s\'", g_ServerSettings.GetMysqlUserTable().c_str(), name.c_str());
	// run a select query on the given username
	if ( !g_Database.GenericQuery(query) || g_Database.RowsReturned() == 0)
	{
		char message[2];
		message[1] = LOGINERROR_USER;
		if ( ++m_FailedAttempts < MAXATTEMPTS )
		{
			CLog::Record("Failed for the %d time - User %s not found", m_FailedAttempts, name.c_str());
			message[0] = PACK_LOGINFAILED;
			SendTo(message, sizeof(message));
		}
		// and boot the user...
		else
		{
			CLog::Record("User %s not found.  Login attempts exceeded - blocked", name.c_str());
			message[0] = PACK_BLOCKED;
			SendTo(message, sizeof(message));
			Closesocket(this->m_Socket);
			this->m_Socket = INVALID_SOCKET;
		}
//		CLog::Error("Failed to execute query %s", __FUNCTION__, query);
		return;
	}
	SQLRow row;

	CLog::Record("Attempting to login %s with password %s", name.c_str(), passwd.c_str());
	// checks to see if the passwords match up
	if ( g_Database.GetAssociativeRow(row, 0) && row["Password"] == passwd )
	{
		int id = atoi(row["UserID"].c_str());
		map<int, CUser*>::iterator iter;
		Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
		if ( (iter = m_Users.find(id)) != m_Users.end() )
		{
			Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
			// login failed, user logged in already, send message back to user
			char message[2];
			message[1] = LOGINERROR_USER;
			if ( ++m_FailedAttempts < MAXATTEMPTS )
			{
				CLog::Record("%s failed to login with %s - Already logged in", name.c_str(), passwd.c_str()); 
				message[0] = PACK_LOGINFAILED;
				SendTo(message, sizeof(message));
			}
			// and boot the user...
			else
			{
				message[0] = PACK_BLOCKED;
				CLog::Record("%s login attempts exceeded - Already logged in.  Booting", name.c_str());
				SendTo(message, sizeof(message));
				Closesocket(this->m_Socket);
				this->m_Socket = INVALID_SOCKET;
			}

			return;
		}
		Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);

		char message = PACK_LOGGEDIN;
		SendTo(&message, sizeof(char));
		SendTo((char*)&id, sizeof(int));
		m_sName = row["FormattedName"];
		SendTo(m_sName.c_str(), m_sName.length());
		char null = 0;
		for ( int i = m_sName.length(); i < MAXNAME; i++ )
			SendTo(&null, sizeof(char));
		m_ID = id;

		// handle clan information later
		m_sClan = "";
		m_bLoggedIn = true;	
		Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
		m_Users[m_ID] = this;
		// acquires a chatroom list to send to the user
		m_pChatroomManager->GetList(this);

//************************  ADD BACK IN
		m_pBattleRoomManager->GetList(this);
//*************************************		
		
		Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);

		CLog::Record("%s logged in", name.c_str());

#ifdef SENTLOG
		string file = "C:\\";
		file += name;
		file += ".txt";
		m_SentLog.open(file.c_str(), ofstream::binary);
#endif
		return;
	}
	else
	{
		// login failed, send message back to user
		char message[2];
		message[1] = LOGINERROR_PASSWORD;
		if ( ++m_FailedAttempts < MAXATTEMPTS )
		{
			CLog::Record("Failed for the %d time - Password %s wrong", m_FailedAttempts, passwd.c_str());
			message[0] = PACK_LOGINFAILED;
			SendTo(message, sizeof(message));
		}
		// and boot the user...
		else
		{
			CLog::Record("Password %s wrong.  Login attempts exceeded - blocked", passwd.c_str());
			message[0] = PACK_BLOCKED;
			SendTo(message, sizeof(message));
			Closesocket(this->m_Socket);
			this->m_Socket = INVALID_SOCKET;
		}
	}
}

void CUser::ExecutePacketRegister()
{
	try
	{
		string name, passwd, formatted;
		if ( !GetStringFromBuffer(name, MAXNAME) ||
			!GetStringFromBuffer(formatted, MAXNAME) ||
			!GetStringFromBuffer(passwd, MAXPASSWD) )
		{
			char msg = PACK_REGISTERFAILED;
			char reason = REGISTER_GENERIC;
			SendTo(&msg, 1);
			SendTo(&reason, 1);
			Closesocket(this->m_Socket);
			this->m_Socket = INVALID_SOCKET;
			CLog::Error("Failed to get strings from buffer", __FUNCTION__);
			return;
		}

		// make the name lower case
		for ( unsigned int i = 0; i < name.length(); i++ )
		{
			if ( !isalnum(name[i]) )
			{
				char msg = PACK_REGISTERFAILED;
				char reason = REGISTER_BADUSERNAME;
				SendTo(&msg, 1);
				SendTo(&reason, 1);
				Closesocket(this->m_Socket);
				this->m_Socket = INVALID_SOCKET;
				CLog::Error("%s is not an appropriate username", __FUNCTION__, name.c_str());
				return;
			}
			name[i] = (char)tolower(name[i]);
		}

		if ( strcmpi(name.c_str(), formatted.c_str()) != 0 )
		{
			char msg = PACK_REGISTERFAILED;
			char reason = REGISTER_FORMATMISMATCH;
			SendTo(&msg, 1);
			SendTo(&reason, 1);
			Closesocket(this->m_Socket);
			this->m_Socket = INVALID_SOCKET;
			CLog::Error("Format string %s does not match original %s", __FUNCTION__, formatted.c_str(), name.c_str());
			return;
		}

		for ( unsigned int i = 0; i < passwd.length(); i++ )
		{
			if ( !isalnum(passwd[i]))
			{
				char msg = PACK_REGISTERFAILED;
				char reason = REGISTER_BADPASSWORD;
				SendTo(&msg, 1);
				SendTo(&reason, 1);
				Closesocket(this->m_Socket);
				this->m_Socket = INVALID_SOCKET;
				CLog::Error("Bad password %s", __FUNCTION__, passwd.c_str());
				return;
			}
		}

		// validation done.  now we check to see if the user already exists in the database
		char query[255];
		sprintf(query, "SELECT * FROM %s WHERE Username=\'%s\'", g_ServerSettings.GetMysqlUserTable().c_str(), name.c_str());
		// run a select query on the given username
		// thread safe the database instance
		g_Database.Lock();
		g_Database.GenericQuery(query);

		CLog::Record("Attempting to find user %s", name.c_str());
		if ( g_Database.RowsReturned() > 0 )
		{
			char msg = PACK_REGISTERFAILED;
			char reason = REGISTER_USEREXISTS;
			SendTo(&msg, 1);
			SendTo(&reason, 1);
			Closesocket(this->m_Socket);
			this->m_Socket = INVALID_SOCKET;
			CLog::Record("User %s found.  Registration failed", name.c_str());
			return;
		}
		g_Database.Free();
		g_Database.Unlock();

		// registration can now proceed.  Add user to database
		sprintf(query, "INSERT INTO %s(`Username`,`FormattedName`,`Password`) VALUES ('%s','%s','%s')", g_ServerSettings.GetMysqlUserTable().c_str(), name.c_str(), formatted.c_str(), passwd.c_str());
		g_Database.Lock();
		g_Database.GenericQuery(query);
		if ( g_Database.AffectedRows() == 0 )
		{
			// failed update
			char msg = PACK_REGISTERFAILED;
			char reason = REGISTER_GENERIC;
			SendTo(&msg, 1);
			SendTo(&reason, 1);
			Closesocket(this->m_Socket);
			this->m_Socket = INVALID_SOCKET;
			CLog::Error("Insert query %s failed", __FUNCTION__, query);
			g_Database.Free();
			g_Database.Unlock();
			return;
		}
		// success

		g_Database.Free();
		g_Database.Unlock();
		char msg = PACK_REGISTERSUCCESS;
		SendTo(&msg, 1);
		Closesocket(this->m_Socket);
		this->m_Socket = INVALID_SOCKET;
	}
	catch (...)
	{
		CLog::Error("Exception", __FUNCTION__);
	}
}

// function CUser::ReadGenericPacket
//  Reads any packet into the backbuffer.  Relies on the messageSize being precalculated
// by the pack handlers loop
void CUser::ReadGenericPacket()
{
	if ( m_currState.messageSize == m_currState.bytesreceived )
	{
		m_currState.complete = true;
		return;
	}
	if ( m_iReadFromBuffer == m_iSizeBuffer )
		return;
	if ( m_iReadFromBuffer + (m_currState.messageSize-m_currState.bytesreceived) <= m_iSizeBuffer )
	{
		sBackBufferEntry entry;
		entry.read = 0;
		entry.size = m_currState.messageSize-m_currState.bytesreceived;
		entry.data = new char[m_currState.messageSize-m_currState.bytesreceived];
		memcpy(entry.data, &m_pBuffer[m_iReadFromBuffer], m_currState.messageSize-m_currState.bytesreceived);
		m_pBackBuffer.push(entry);
		m_iReadFromBuffer += m_currState.messageSize-m_currState.bytesreceived;
		m_currState.bytesreceived += m_currState.messageSize-m_currState.bytesreceived;
		m_currState.complete = true;
	}
	else
	{
		sBackBufferEntry entry;
		entry.data = new char[m_iSizeBuffer-m_iReadFromBuffer];
		entry.read = 0;
		entry.size = m_iSizeBuffer-m_iReadFromBuffer;
		memcpy(entry.data, &m_pBuffer[m_iReadFromBuffer], m_iSizeBuffer-m_iReadFromBuffer);
		m_pBackBuffer.push(entry);
		m_currState.bytesreceived += m_iSizeBuffer-m_iReadFromBuffer;
		m_iReadFromBuffer = m_iSizeBuffer;
	}
}

// function CUser::ExecutePacketCreateChat
// Creates a chatroom
void CUser::ExecutePacketCreateChat()
{
	string name;
	if ( !GetStringFromBuffer(name, MAXCHATNAME, true) )
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}

	CLog::Record("Create chat packet %s from %s", name.c_str(), GetName());

	unsigned int index = m_pChatroomManager->CreateChatroom(name, false, false);

	if ( index == 0 )
	{
		// failed to create chatroom.
		char message = PACK_FAILEDCREATECHAT;
		SendTo(&message, sizeof(char));
		return;
	}

	// and add the creator to the room
	m_pChatroomManager->JoinChatroom(this->m_ID, index);
}

// function ExecutePacketCreateBattle
void CUser::ExecutePacketCreateBattle()
{
	string name;
	unsigned short port;
	unsigned char capacity;
	string mapname;
	unsigned char password;
	CLog::Record("Create battle packet from %s", GetName());
	if ( !GetStringFromBuffer(name, MAXBATTLENAME) ||
		!GetFromBuffer(&capacity, sizeof(capacity)) ||
		!GetFromBuffer(&port, sizeof(port)) ||
		!GetStringFromBuffer(mapname, MAXMAPNAME) ||
		!GetFromBuffer(&password, sizeof(password)))
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}

	Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
	if ( password == 0 )
		m_pBattleRoomManager->CreateBattleRoom(this, name, capacity, port, mapname, false);
	else
		m_pBattleRoomManager->CreateBattleRoom(this, name, capacity, port, mapname, true);
	Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	/*
	if ( index == 0 )
	{
		// failed to create chatroom. DEAL WITH LATER
		return;
	}*/
}

// function CUser::ExecutePacketLeaveChat
// attempts to leave a chatroom
void CUser::ExecutePacketLeaveChat()
{
	int id;
	CLog::Record("Leave chat packet from %s", GetName());
	if ( !GetFromBuffer((void*)&id, sizeof(int)))
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}
	m_pChatroomManager->LeaveChatroom(this->m_ID, id);
}

// function CUser::ExecutePacketLeaveBattle
// Attempts to leave a battle room
void CUser::ExecutePacketLeaveBattle()
{
	unsigned int id;
	CLog::Record("Leave battle packet from %s", GetName());
	if ( !GetFromBuffer((void*)&id, sizeof(int)))
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}
	m_pBattleRoomManager->LeaveRoom(this->m_ID, id);
}

// function CUser::ExecutePacketReqJoinChat
//  Requests to enter a chatroom
void CUser::ExecutePacketReqJoinChat()
{
	int id;
	CLog::Record("Request join chat from %s", GetName());
	if (!GetFromBuffer((void*)&id, sizeof(int)))
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}
	m_pChatroomManager->JoinChatroom(this->m_ID, id);
}

// function CUser::ExecutePacketReqJoinBattle
// this is no longer used.
void CUser::ExecutePacketReqJoinBattle()
{
	int id;
	if (!GetFromBuffer((void*)&id, sizeof(int)))
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}
//	m_pBattleRoomManager->JoinBattleRoom(this->m_ID, id, "");
}

// function CUser::ExecutePacketDestroyBattle
void CUser::ExecutePacketDestroyBattle()
{
//	unsigned int id;

	CLog::Record("Destroy battle packet from %s", GetName());
	/*
	if ( !GetFromBuffer((void*)&id, sizeof(int)))
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}*/
	if ( this->m_HostedBattleID == -1 )
		return;
	else
		m_pBattleRoomManager->DestroyRoom(this->m_HostedBattleID);
}

// function CUser::ExecutePacketIPOverride
void CUser::ExecutePacketIPOverride()
{
	CLog::Record("IP Override packet from %s", GetName());
	unsigned long newip;

	if ( !GetFromBuffer(&newip, 4))
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}

	if ( newip == 0 )
	{
		m_bOverrideIP = false;
		m_IP = 0;
	}
	else
	{
		m_bOverrideIP = true;
		m_IP = newip;
	}
}

void CUser::ExecutePacketBattleSizeUpdate()
{
	CLog::Record("BattleSizeUpdate Packet from %s", GetName());
	unsigned char newsize;

	if ( !GetFromBuffer(&newsize, sizeof(newsize)) )
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}

	// do nothing if this user is not hosting 
	if ( this->m_HostedBattleID == -1 )
	{
		return;
	}

	m_pBattleRoomManager->UpdateSize(this->m_HostedBattleID, newsize);
}

void CUser::ExecutePacketMapUpdate()
{
	CLog::Record("MapUpdate Packet from %s", GetName());
	string newmap;

	if ( !GetStringFromBuffer(newmap, MAXMAPNAME) )
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}

	// do nothing if this user is not hosting anything
	if ( this->m_HostedBattleID == -1 )
		return;

	m_pBattleRoomManager->UpdateMap(this->m_HostedBattleID, newmap);
}

void CUser::ExecutePacketBattleProgress()
{
	CLog::Record("BattleProgress Packet from %s", GetName());
	bool state;

	if ( !GetFromBuffer(&state, 1) )
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}

	// do nothing if this user is not hosting anything
	if ( this->m_HostedBattleID == -1 )
		return;

	m_pBattleRoomManager->UpdateInProgress(this->m_HostedBattleID, state);
}

void CUser::ExecutePacketBattleTest()
{
	CLog::Record("Testing Battle hosting capabilities of %s", GetName());
	unsigned short port;

	if ( !GetFromBuffer(&port, sizeof(port)))
	{
		CLog::Error("Failed to get from buffer", __FUNCTION__);
		return;
	}

	// do nothing if this user IS hosting already
	if ( this->m_HostedBattleID != -1 )
		return;

	SOCKET s = Socket(AF_INET, SOCK_STREAM, 0);
	struct sockaddr_in servaddr;
	ZeroMemory(&servaddr, sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	servaddr.sin_port = htons(port);
#ifdef ARCHDEF_PLATFORM_WIN32
	servaddr.sin_addr.S_un.S_addr = GetIP();
#else
	servaddr.sin_addr.s_addr = GetIP();
#endif

	Connect(s, (sockaddr*)&servaddr, sizeof(servaddr));
	Closesocket(s);
}

unsigned long CUser::GetIP()
{
	if ( m_bOverrideIP )
		return m_IP;
	sockaddr_in clientAddr;
	socklen_t len = (socklen_t)sizeof(clientAddr);
	// gets the ip address of the user making the battle room
	Getpeername(this->GetSocket(), (sockaddr*)&clientAddr, &len);
	/*
	unsigned long ip = clientAddr.sin_addr.S_un.S_addr;
	if ( (clientAddr.sin_addr.S_un.S_un_b.s_b1 == 192) && 
		(clientAddr.sin_addr.S_un.S_un_b.s_b2 == 168) &&
		(clientAddr.sin_addr.S_un.S_un_b.s_b3 == 0 ) &&
		(clientAddr.sin_addr.S_un.S_un_b.s_b4 == 3 ) )
	{
		unsigned char* temp = (unsigned char*)ip;
		temp[0] = 212;
		temp[1] = 214;
		temp[2] = 141;
		temp[3] = 249;
	}
	*/

	/* Some more ugly ifdefing - gramuxius */
#ifdef ARCHDEF_PLATFORM_WIN32
	return clientAddr.sin_addr.S_un.S_addr;
#else
	return clientAddr.sin_addr.s_addr;
#endif
}

// function CUser::GetStringFromBuffer
//  Gets a string from the current location in the backbuffer
// and reads until a null is reached (or the end of the buffer)
bool CUser::GetStringFromBuffer(string& ret)
{
//	string ret;
	ret.clear();
	while ( true )
	{
		char getval;
		if ( !GetFromBuffer(&getval, sizeof(char)) )
			return false;
		if ( getval == '\0' )
			break;
		ret += getval;
	}
	return true;
}

// same as above, except it reads maxlen characters from the back buffer
//  if it reaches a null character, it stops reading from the back buffer
// unless consum is true, in which it keeps reading but not adding to the return string
bool CUser::GetStringFromBuffer(string& ret, int maxlen, bool consume)
{
	ret.clear();
	bool nullfound = false;
	for ( int i = 0; i < maxlen; i++ )
	{
		char getval;
		if ( !GetFromBuffer(&getval, sizeof(char)) )
			return false;
		if ( getval == '\0' )
		{
			if ( !consume )
				break;
			nullfound = true;
		}
		if ( !nullfound )
			ret += getval;
	}

	return true;
}

// function CUser::HandlePacket
// main packet handling loop.
bool CUser::HandlePacket()
{
	// returns false if there is nothing left in the read buffer
	if ( m_iReadFromBuffer == m_iSizeBuffer )
		return false;
	
	// if the last packet has been fully read and executed, we want to get the next one
	if ( m_currState.complete )
	{
		m_currState.message = m_pBuffer[m_iReadFromBuffer++];
		m_currState.bytesreceived = 1;
		m_currState.complete = false;
		m_currState.badpacket = false;
		CLog::Record("Message received from %s - %d", GetName(), m_currState.message);
		// this sets the size of the message so ReadGenericPackets knows how much to get
		switch ( m_currState.message )
		{
			case PACK_CHATMESSAGE:
				{
					size_t received = 0;
					unsigned short len;
					char* temp = (char*)&len;
					while ( received < 2 )
					{
						// get from p_buffer if the data has already been read
						if ( m_iReadFromBuffer < m_iSizeBuffer )
							memcpy(&temp[received++], &m_pBuffer[m_iReadFromBuffer++], 1);
						else
							// but if we get to the end of the buffer, read whats left of the 2 bytes
							// from the socket
							received += recv(m_Socket, &temp[received], sizeof(len)-received, 0);
					}
					m_currState.messageSize = (size_t)len+7;
					m_currState.bytesreceived += 2;
				}
				break;
			case PACK_LOGIN:
				m_currState.messageSize = 3+MAXNAME+MAXPASSWD;
				break;
			case PACK_REGISTER:
				m_currState.messageSize = 1+MAXNAME*2+MAXPASSWD;
				break;
			case PACK_CREATECHAT:
				m_currState.messageSize = 1+MAXCHATNAME;
				break;
			case PACK_CREATEBATTLE:
				m_currState.messageSize = 1+1+MAXBATTLENAME+sizeof(unsigned char)+sizeof(unsigned short)+MAXMAPNAME;
				break;
			case PACK_REQJOINCHAT:
			case PACK_LEAVECHAT:
			case PACK_REQJOINBATTLE:
			case PACK_LEAVEBATTLE:
			case PACK_IPOVERRIDE:
				m_currState.messageSize = 5;
				break;
			case PACK_DESTROYBATTLE:
				m_currState.messageSize = 1;
				break;
			case PACK_KEEPALIVE:
				m_currState.complete = true;
				return true;
			case PACK_MAPUPDATE:
				m_currState.messageSize = 1+MAXMAPNAME;
				break;
			case PACK_BATTLESIZEUPDATE:
			case PACK_BATTLEPROGRESS:
				m_currState.messageSize = 2;
				break;
			case PACK_BATTLETEST:
				m_currState.messageSize = 3;
				break;
			default:
				CUser::KickUser(this->m_ID);
				break;
		}
	}

	// if a packet other than login or register is received and the user is not logged in, then bail
	if ( !m_bLoggedIn && ( m_currState.message != PACK_LOGIN && m_currState.message != PACK_REGISTER) )
	{
		Closesocket(this->m_Socket);
		m_Socket = INVALID_SOCKET;
		return false;
	}

	switch( m_currState.message )
	{
	case PACK_CHATMESSAGE:
	case PACK_LOGIN:
	case PACK_REGISTER:
	case PACK_REQJOINCHAT:
	case PACK_LEAVECHAT:
	case PACK_REQJOINBATTLE:
	case PACK_CREATECHAT:
	case PACK_CREATEBATTLE:
	case PACK_LEAVEBATTLE:
	case PACK_DESTROYBATTLE:
	case PACK_IPOVERRIDE:
	case PACK_MAPUPDATE:
	case PACK_BATTLESIZEUPDATE:
	case PACK_BATTLEPROGRESS:
	case PACK_BATTLETEST:
		ReadGenericPacket();
		break;
	}

	if ( m_currState.complete )
	{
		switch ( m_currState.message )
		{
		case PACK_CHATMESSAGE:
			ExecutePacketChatMessage();
			break;
		case PACK_LOGIN:
			ExecutePacketLogin();
			break;
		case PACK_REGISTER:
			ExecutePacketRegister();
			break;
		case PACK_REQJOINCHAT:
			ExecutePacketReqJoinChat();
			break;
		case PACK_LEAVECHAT:
			ExecutePacketLeaveChat();
			break;
		case PACK_REQJOINBATTLE:
			ExecutePacketReqJoinBattle();
			break;
		case PACK_CREATECHAT:
			ExecutePacketCreateChat();
			break;
		case PACK_CREATEBATTLE:
			ExecutePacketCreateBattle();
			break;
		case PACK_LEAVEBATTLE:
			ExecutePacketLeaveBattle();
			break;
		case PACK_DESTROYBATTLE:
			ExecutePacketDestroyBattle();
			break;
		case PACK_IPOVERRIDE:
			ExecutePacketIPOverride();
			break;
		case PACK_BATTLESIZEUPDATE:
			ExecutePacketBattleSizeUpdate();
			break;
		case PACK_MAPUPDATE:
			ExecutePacketMapUpdate();
			break;
		case PACK_BATTLEPROGRESS:
			ExecutePacketBattleProgress();
			break;
		case PACK_BATTLETEST:
			ExecutePacketBattleTest();
			break;
		}
		EmptyBackBuffer();
		return true;
	}
	return false;
}
