#ifndef USER_H
#define USER_H

#define BUFFERLEN		4089

#include "global.h"
#include <queue>
#include <map>
#include <string>

#include <fstream>

class CChatroomManager;
class CBattleRoomManager;

using namespace std;

// Class CUser
//  Maintains all information needed by the server about a single
// client logged in

class CUser
{
private:

	// name of the user
	string				m_sName;
	// clan the user belongs to.  isn't really implemented yet
	string				m_sClan;

	// pointer to the chatroom manager
	CChatroomManager*	m_pChatroomManager;
	// pointer to the battleroom manager
	CBattleRoomManager*	m_pBattleRoomManager;
	// tcp socket connecting this user to the server
	SOCKET				m_Socket;
	// is the user logged in?  the user may be connected prior to logging
	// in.  this flag allows a user to only register or login while connected
	// if false
	bool				m_bLoggedIn;
	// after a certain number of failed log in attempts, the user is booted
	short				m_FailedAttempts;
	// buffer containing the message received by this user
	char				m_pBuffer[BUFFERLEN];
	// size of the message in memory
	size_t				m_iSizeBuffer;
	// how much of this buffer has been read and handled
	size_t				m_iReadFromBuffer;
	// has the user been initialized?
	bool				m_bInitialized;
	// the id of the person logged in.  grabbed by mysql if the user is registered
	int					m_ID;
	// ovverride the ip the server sees.  this is to bypass proxies, and the fact that fnord
	// is connecting locally :P
	bool				m_bOverrideIP;
	unsigned long		m_IP;

	// this logs ALL messages sent to this client
#ifdef LOGSEND
	ofstream			m_SentLog;
#endif

	struct sBackBufferEntry
	{
		size_t	read;
		size_t	size;
		char* data;
	};
	// this queues up the messages received by the client prior
	// to their being handled.  Get from buffer reads from the top entry
	// and then dequeues
	queue<sBackBufferEntry>		m_pBackBuffer;

	inline bool GetFromBuffer(void* dest, size_t bytes);
	void EmptyBackBuffer();

	bool GetStringFromBuffer(string& ret);
	bool GetStringFromBuffer(string& ret, int maxlen, bool consume = true);

	bool HandlePacket();
	void ReadGenericPacket();

	void ExecutePacketLogin();
	void ExecutePacketRegister();
	void ExecutePacketChatMessage();
	void ExecutePacketReqJoinChat();
	void ExecutePacketLeaveChat();
	void ExecutePacketReqJoinBattle();
	void ExecutePacketCreateChat();
	void ExecutePacketCreateBattle();
	void ExecutePacketLeaveBattle();
	void ExecutePacketDestroyBattle();
	void ExecutePacketIPOverride();
	void ExecutePacketMapUpdate();
	void ExecutePacketBattleSizeUpdate();
	void ExecutePacketBattleProgress();
	void ExecutePacketBattleTest();

	void HandleMessageFamily();

	struct STATE
	{
		char message;
		size_t bytesreceived;
		size_t messageSize;
		bool complete;
		bool badpacket;
	} m_currState;

	void ReadLoginFamily();
	void HandleLoginFamily();

public:
	// a static map of userids to the pointers representing the user
	static map<int, CUser*>				m_Users;
	// if the user is hosting a battle, this is the id of that battle
	// -1 otherwise.
	int									m_HostedBattleID;

	// pthread mutex used to obtain exclusive access to m_Users
	static pthread_mutex_t				m_UserMutex;

	const char* GetName() { return m_sName.c_str(); }
	const char* GetClan() { return m_sClan.c_str(); }
	SOCKET GetSocket() { return m_Socket; }
	void SetName(string name) { m_sName = name; }

	int GetId() { return m_ID; }
	CUser(void);
	~CUser(void);

	static CUser* GetUser(int id);
	static bool AddUser(CUser* newUser);
	static bool KickUser(int id);

	void Init(SOCKET sd, CChatroomManager* crman, CBattleRoomManager* brman );
	void Do();
	unsigned long GetIP();

	bool SendTo(const char* data, size_t len);
};

#endif
