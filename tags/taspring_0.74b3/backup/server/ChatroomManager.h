#ifndef CHATROOMMANAGER_H
#define CHATROOMMANAGER_H

#include "global.h"
#include "ChatRoom.h"

#include <string>
#include <map>

using namespace std;

class CUser;

// class CChatroomManager
//  Manages all open chatrooms in use by the server.

class CChatroomManager
{
private:
	// map from all chatid's to pointers to the chatrooms themselves
	map<int, CChatRoom*> m_ChatRooms;
	// map from all the chatroom names to the chatid's
	map<string, int> m_FindChatRoom;

	static pthread_mutex_t				m_CRMmutex;

public:
	CChatroomManager(void);
	~CChatroomManager(void);
	
	void LeaveChatroom(int userid, int roomid);
	size_t NumChatrooms() { return m_ChatRooms.size(); }

	unsigned int CreateChatroom(string name, bool priv, bool permanent);
	bool RemoveChatroom(string name);
	bool RemoveChatroom(int id);

	bool JoinChatroom(int userid, int chatid);

	void PostChatMessage(int fromid, int chatid, string& message);

	void GetList(CUser* user);
};

#endif
