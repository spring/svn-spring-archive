#include "ChatroomManager.h"
#include "User.h"

pthread_mutex_t CChatroomManager::m_CRMmutex = PTHREAD_MUTEX_INITIALIZER;

CChatroomManager::CChatroomManager(void)
{
}

CChatroomManager::~CChatroomManager(void)
{
}

// function CChatroomManager::CreateChatroom
//  Creates a chatroom.  priv specifies if it is a private chatroom (not implemented yet)
// and non permanent chatrooms are destroyed when there are no users in it
unsigned int CChatroomManager::CreateChatroom(string name, bool priv, bool permanent)
{
	int index = 0;

	Pthread_mutex_lock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
	if ( m_FindChatRoom.find(name) != m_FindChatRoom.end() )
	{
		CLog::Error("Could not create chat room %s - one already exists by that name", __FUNCTION__, name.c_str());
		index = 0;
	}
	else
	{
		// iterate through the map and find the first available index
		index = 1;

		map<int, CChatRoom*>::iterator iter = m_ChatRooms.begin();
		while ( iter != m_ChatRooms.end() && iter->first == index )
			index++, iter++;

		CChatRoom* newChat = new CChatRoom;
		newChat->Init(name, index, priv, permanent);

		m_ChatRooms[index] = newChat;
		m_FindChatRoom[name] = index;

		// if not private, inform everyone of a new chat room
		if ( !priv )
		{
			Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
			char message[sizeof(char)+sizeof(int)+MAXCHATNAME];
			char* temp = message;
			*temp = PACK_CREATECHAT;            
			temp++;
			(*(int*)temp) = index;
			temp += sizeof(int);
			strncpy(temp, name.c_str(), MAXCHATNAME);
			map<int, CUser*>::iterator iter = CUser::m_Users.begin();
			while ( iter != CUser::m_Users.end() )
			{
				CLog::Record("Sending PACK_CREATECHAT to %s", iter->second->GetName());
				iter->second->SendTo(message, sizeof(message));
				iter++;
			}
			Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
		}
	}
	Pthread_mutex_unlock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
	return index;
}

// function CChatroomManager::LeaveChatoom
//  logs userid out of chatroom roomid
void CChatroomManager::LeaveChatroom(int userid, int roomid)
{
	Pthread_mutex_lock(&m_CRMmutex, __FUNCTION__);
	static char message[7];
	char* temp = message;
	*temp = PACK_CHATSIZEUPDATE;
	temp++;
	(*(int*)temp) = roomid;
	temp += sizeof(int);

	// if roomid is -1, kick from all chatrooms
	if ( roomid == -1 )
	{
		map<int, CChatRoom*>::iterator iter = m_ChatRooms.begin();
		while ( iter != m_ChatRooms.end() )
		{
			map<int, CChatRoom*>::iterator iter2 = iter;
			iter2++;
			//CChatRoom* currRoom = iter->second;
			(*(int*)&message[1]) = iter->first;
			(*(short*)&message[5]) = (short)iter->second->NumUsers();
			iter->second->Kick(userid);
			if ( !iter->second->IsPerm() && iter->second->NumUsers() == 0 )
			{
				CLog::Record("Chat %s id %d killed", iter->second->GetName().c_str(), iter->second->GetId());
				map<string, int>::iterator iter2 = m_FindChatRoom.find(iter->second->GetName());
				iter->second->Kill();
				delete iter->second;
				iter->second = 0;
				m_ChatRooms.erase(iter);
				m_FindChatRoom.erase(iter2);
			}
			else
			{
				Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
				map<int, CUser*>::iterator iter3 = CUser::m_Users.begin();
				while ( iter3 != CUser::m_Users.end() )
				{
					iter3->second->SendTo(message, sizeof(message));
					iter3++;
				}
				Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
			}
			iter = iter2;
		}
	}
	else
	{
		map<int, CChatRoom*>::iterator iter = m_ChatRooms.find(roomid);
		if ( iter != m_ChatRooms.end() )
		{
			iter->second->Kick(userid);
			(*(short*)&message[5]) = (short)iter->second->NumUsers();
			if ( !iter->second->IsPerm() && iter->second->NumUsers() == 0 )
			{
				CLog::Record("Chat %s id %d killed", iter->second->GetName().c_str(), roomid);
				map<string, int>::iterator iter2 = m_FindChatRoom.find(iter->second->GetName());
				iter->second->Kill();
				delete iter->second;
				iter->second = 0;
				m_ChatRooms.erase(iter);
				m_FindChatRoom.erase(iter2);
			}
			else
			{
				Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
				map<int, CUser*>::iterator iter2 = CUser::m_Users.begin();
				
				while ( iter2 != CUser::m_Users.end() )
				{
					iter2->second->SendTo(message, sizeof(message));
					iter2++;
				}
				Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
			}
		}
		else
		{
			CLog::Error("Chatroom id %d not found", __FUNCTION__, roomid);
		}
	}
	Pthread_mutex_unlock(&m_CRMmutex, __FUNCTION__);
}

// function CChatroomManager::RemoveChatroom
//  Removes a chatroom by its name
bool CChatroomManager::RemoveChatroom(string name)
{
	Pthread_mutex_lock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
	const map<string, int>::iterator iter = m_FindChatRoom.find(name);
	if ( iter == m_FindChatRoom.end() )
	{
		CLog::Error("Failed to remove chat room %s - Not found", __FUNCTION__, name.c_str());
		Pthread_mutex_unlock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
		return false;
	}
	int id = iter->second;
	Pthread_mutex_unlock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
	return RemoveChatroom(id);
}

// function CChatroomManager::RemoveChatroom
//  removes a chatroom by its id
bool CChatroomManager::RemoveChatroom(int id)
{
	Pthread_mutex_lock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
	const map<int, CChatRoom*>::iterator iter2 = m_ChatRooms.find(id);

	if ( iter2 == m_ChatRooms.end() )
	{
		CLog::Error("Failed to remove chat room %d by id - Not found", __FUNCTION__, id);
		Pthread_mutex_unlock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
		return false;
	}

	// kill the chatroom
	iter2->second->Kill();

	// and remove the reverse map from string name to id
	bool ret = false;
	map<string, int>::iterator iter;
	while ( iter != m_FindChatRoom.end() )
	{
		if ( iter->second == id )
		{
			m_FindChatRoom.erase(iter);
			ret = true;
			break;
		}
	}
	Pthread_mutex_unlock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
	return ret;
}

// function CChatroomManager::JoinChatroom
//  logs in a user into a chatroom
bool CChatroomManager::JoinChatroom(int userid, int chatid)
{
	Pthread_mutex_lock(&m_CRMmutex, __FUNCTION__);
	bool res = false;
	map<int, CChatRoom*>::iterator iter2 = m_ChatRooms.find(chatid);

	if ( iter2 != m_ChatRooms.end() )
	{
		CChatRoom* chatroom = iter2->second;
		res = chatroom->Join(userid);
		if ( res )
		{
			// let everyone know of the new chatroom size
			static char message[7];
			char* temp = message;
			*temp = PACK_CHATSIZEUPDATE;
			temp++;
			(*(int*)temp) = chatid;
			temp += sizeof(int);
			(*(short*)temp) = (short)chatroom->NumUsers();
			
			Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
			map<int, CUser*>::iterator iter = CUser::m_Users.begin();
			while ( iter != CUser::m_Users.end() )
			{
				iter->second->SendTo(message, sizeof(message));
				iter++;
			}
			Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
		}
	}
	else
		CLog::Error("Trying to join user %d into chat %d - could not find chat room", __FUNCTION__, userid, chatid);
	Pthread_mutex_unlock(&m_CRMmutex, __FUNCTION__);

	return res;
}

// function CChatroomManager::PostChatMessage
//  Sends a chat room message
void CChatroomManager::PostChatMessage(int fromid, int chatid, string& message)
{
	Pthread_mutex_lock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
	map<int, CChatRoom*>::iterator iter = m_ChatRooms.find(chatid);
	if ( iter != m_ChatRooms.end() )
	{
		CChatRoom* chatroom = iter->second;
		chatroom->Post(fromid, message.c_str(), message.length());
	}
	else
		CLog::Error("Tried posting a message to %d from user %d - Failed, chat room not found", __FUNCTION__, chatid, fromid);
	Pthread_mutex_unlock(&CChatroomManager::m_CRMmutex, __FUNCTION__);
}

// function CChatroomManager::GetList
//  Sends a list of all chatrooms currently active to user
void CChatroomManager::GetList(CUser* user)
{
	Pthread_mutex_lock(&m_CRMmutex, __FUNCTION__);
	size_t bufflen = m_FindChatRoom.size()*(6+MAXCHATNAME)+3;
	char* buff = new char[bufflen];
	
	char* temp = buff;
	*temp = PACK_CHATLIST;
	temp++;
	*(short*)temp = (short)m_FindChatRoom.size();
	temp+=2;
	map<string, int>::iterator iter = m_FindChatRoom.begin();
	for ( unsigned int i = 0; i < m_FindChatRoom.size(); i++ )
	{
		const string& str = iter->first;
		*(int*)temp = iter->second;
		temp += 4;
		CChatRoom* currChat = m_ChatRooms[iter->second];
		*(short*)temp = (short)currChat->NumUsers();
		temp += 2;
		strncpy(temp, str.c_str(), MAXCHATNAME);
		/*
		if ( str.length() >= MAXCHATNAME )
			memcpy(temp, str.c_str(), MAXCHATNAME);
		else
			memcpy(temp, str.c_str(), str.length()+1);
		*/
		temp += MAXCHATNAME;
		iter++;
	}
	CLog::Record("Sending PACK_CHATLIST to %s", user->GetName());
	user->SendTo(buff, bufflen);
	delete[] buff;
	buff = 0;
	Pthread_mutex_unlock(&m_CRMmutex, __FUNCTION__);
}
