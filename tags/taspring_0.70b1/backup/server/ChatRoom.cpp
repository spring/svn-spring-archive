#include "ChatRoom.h"
#include "User.h"

// have mutex for access prevention during writing
//pthread_mutex_t CChatRoom::m_InsideUsersMutex = PTHREAD_MUTEX_INITIALIZER;

CChatRoom::CChatRoom(void)
{
	m_bPrivate = false;
	m_sName = "";
	m_bActive = false;


	/* Quick fix for a strange initialization. - gramuxius */
#ifdef ARCHDEF_PLATFORM_WIN32
	m_InsideUsersMutex = PTHREAD_MUTEX_INITIALIZER;
#else
	pthread_mutex_init(&m_InsideUsersMutex, NULL);
#endif
}

CChatRoom::~CChatRoom(void)
{
	Kill();
}

// function CChatRoom::Init
//  Initializes a chatroom.  This must be called before the chatroom can be used
void CChatRoom::Init(string name, int id, bool priv, bool perm)
{
	m_sName = name;
	this->m_ChatID = id;
	m_bPrivate = priv;
	m_bActive = true;
	m_bPermanent = perm;
}

#include <iostream>
using namespace std;

// function CChatRoom::Post
//  posts a chat message to this chat room
void CChatRoom::Post(int from, const char* message, size_t msglen )
{
	if ( !m_bActive )
	{
		CLog::Error("Could not send a chat message - Chat not intialized", __FUNCTION__);
		return;
	}
	Pthread_mutex_lock(&m_InsideUsersMutex, __FUNCTION__);
	
	list<int>::iterator iter;
	Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
	
	for ( iter = m_UsersInside.begin(); iter != m_UsersInside.end(); iter++ )
	{
		CUser* curr = CUser::GetUser(*iter);
		if ( curr != NULL )
		{
			char pack = PACK_CHATMESSAGE;
			unsigned short sendlen = (unsigned short)msglen;
			
			//unsigned short stuff = 13;
	//		CLog::Record("Sending PACK_CHATMESSAGE to %s", curr->GetName());
			curr->SendTo((const char*)&pack, sizeof(char));
			// prepend the message length
			curr->SendTo((const char*)&sendlen, sizeof(unsigned short));

			curr->SendTo((const char*)&from, sizeof(int));
			curr->SendTo((const char*)&this->m_ChatID, sizeof(int));
			curr->SendTo(message, msglen);
		}
	}
	Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	Pthread_mutex_unlock(&m_InsideUsersMutex, __FUNCTION__);
}

// function CChatRoom::Join
//  Joins a user to this chatroom
bool CChatRoom::Join(int user)
{
	if ( !m_bActive )
	{
		CLog::Error("Could not join chat room - Chat not intialized", __FUNCTION__);
		return false;
	}
	Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
	CUser* currUser = CUser::GetUser(user);
	if ( currUser == 0 )
	{
		CLog::Error("User id %d not found", __FUNCTION__, user);
		Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
		return false;
	}
	Pthread_mutex_lock(&m_InsideUsersMutex, __FUNCTION__);

	// the only time this is a linear search is when someone logs in and logs out

	list<int>::iterator iter = m_UsersInside.begin();

	while ( iter != m_UsersInside.end() )
	{
		if ( *iter == user )
		{
			// if user is already in the chat room, refuse entry
			CLog::Record("Failed to login to chat room %s - %d already in there", GetName().c_str(), *iter );
			Pthread_mutex_unlock(&m_InsideUsersMutex, __FUNCTION__);
			Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
			return false;
		}
		iter++;
	}
/*
	//	size_t BufferSize = 9 + (MAXNAME+7)*users, namelen;
	if ( m_sName.length() >= MAXCHATNAMELEN )
		namelen = MAXCHATNAMELEN;
	else
		namelen = m_sName.length()+1;
//	BufferSize += namelen;
*/
//	char* LoggedInBuffer = new char[BufferSize];
	size_t users = m_UsersInside.size();

	char LoggedInBuffer[9];
	char* temp = LoggedInBuffer;
	*temp = PACK_JOINCHAT;
	temp++;
	*(int*)temp = this->m_ChatID;
	temp += 4;
	*(int*)temp = (int)users;
	temp += 4;

	currUser->SendTo(LoggedInBuffer, 9);

	vector<int> toKick;
	char CurrUserData[MAXNAME+MAXCLAN+9];
	temp = CurrUserData;
	*temp = PACK_USERENTERCHAT;
	temp++;
	*(int*)temp = this->m_ChatID;
	temp += sizeof(int);
	*(int*)temp = currUser->GetId();
	temp += sizeof(int);
	strncpy(temp, currUser->GetName(), MAXNAME);
	temp += MAXNAME;
	strncpy(temp, currUser->GetClan(), MAXCLAN);
	
	for ( iter = m_UsersInside.begin(); iter != m_UsersInside.end(); iter++ )
	{
		char UserData[MAXNAME+MAXCLAN+4];
		temp = UserData;
		CUser* currUser2 = CUser::GetUser(*iter);
		// this really shouldnt happen either, we checked for it earlier
		if ( *iter == user ) //|| currUser == 0 )
		{
			Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
			Pthread_mutex_unlock(&m_InsideUsersMutex, __FUNCTION__);
			return false;
		}
		// this shouldn't happen, but if we come across a user with a null pointer, we kick him/her from the room
		if ( currUser2 == 0 )
		{
			//**** Send a boot message to everyone in the chatroom
			toKick.push_back(*iter);
			m_UsersInside.erase(iter);
			continue;
		}
		CLog::Record("Sending PACK_USERENTERCHAT to %s", currUser2->GetName());
		currUser2->SendTo(CurrUserData, MAXNAME+MAXCLAN+9);
		*(int*)temp = currUser2->GetId();
		temp += sizeof(int);
		strncpy(temp, currUser2->GetName(), MAXNAME);
		temp += MAXNAME;
		// in here goes the clan
		strncpy(temp, currUser2->GetClan(), MAXCLAN);
		temp += MAXCLAN;
		currUser->SendTo(UserData, MAXNAME+MAXCLAN+4);
	}
	m_UsersInside.push_back(user);
	Pthread_mutex_unlock(&m_InsideUsersMutex, __FUNCTION__);

//	currUser->SendTo(LoggedInBuffer, BufferSize);
	Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);

	if ( toKick.size() > 0 )
		Kicked(toKick);
	
//	delete[] LoggedInBuffer;
//	LoggedInBuffer = 0;

	return true;
}

// function CChatRoom::Kill
//  Destroys the current chat room by sending boot messages to everyone
void CChatRoom::Kill()
{
	// set mutex here
	Pthread_mutex_lock(&m_InsideUsersMutex, __FUNCTION__);
	m_bActive = false;

	list<int>::iterator iter = m_UsersInside.begin();
	char buff[5];
	char* temp = buff;
	*temp = PACK_BOOTFROMCHAT;
	temp++;
	(*(int*)temp) = this->m_ChatID;
	Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
	while ( iter != m_UsersInside.end() )
	{
		CUser* pUser = CUser::GetUser(*iter);
		if ( pUser != NULL )
		{
			CLog::Record("Sending PACK_BOOTFROMCHAT to %s", pUser->GetName());
			pUser->SendTo(buff, sizeof(buff));
		}
		iter++;
	}

	map<int, CUser*>::iterator iter2 = CUser::m_Users.begin();
	buff[0] = PACK_CHATDESTROYED;

	while ( iter2 != CUser::m_Users.end() )
	{
		CLog::Record("Sending PACKCHATDESTROYED to %s", iter2->second->GetName());
		iter2->second->SendTo(buff, sizeof(buff));
		iter2++;
	}
	Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	m_UsersInside.empty();
	Pthread_mutex_unlock(&m_InsideUsersMutex, __FUNCTION__);
}

// function CChatRoom::Kick
//  boots a user from this chatroom.  if notify is true, then send a message to everyone else in the chatroom of this event
void CChatRoom::Kick(int user, bool notify )
{
	Pthread_mutex_lock(&m_InsideUsersMutex, __FUNCTION__);
	list<int>::iterator iter = m_UsersInside.begin();
	while ( iter != m_UsersInside.end() && (*iter) != user )
		iter++;
	if ( iter != m_UsersInside.end() )
	{
		CLog::Record("User %d kicked from %s", user, m_sName.c_str());

		m_UsersInside.erase(iter);
		
		char buff[5];
		char* temp = buff;
		*temp = PACK_BOOTFROMCHAT;
		temp++;
		(*(int*)temp) = this->m_ChatID;
		Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
		CUser* pUser = CUser::GetUser(user);
		if ( pUser != NULL )
		{
			CLog::Record("Sending PACK_BOOTFROMCHAT to %s", pUser->GetName());
			pUser->SendTo(buff, sizeof(buff));
		}
		Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	}
	else
		notify = false;
	Pthread_mutex_unlock(&m_InsideUsersMutex, __FUNCTION__);
	if ( notify )
		Kicked(user);
}

// function CChatRoom::Kicked
//  notifies everyone in the room that user has left
void CChatRoom::Kicked(int user)
{
	char message[1+2*sizeof(int)];
	list<int>::iterator iter;
	vector<int> toKick;

	message[0] = PACK_USERLEAVECHAT;
	*((int*)&message[1]) = this->m_ChatID;
	*((int*)&message[5]) = user;

	Pthread_mutex_lock(&m_InsideUsersMutex, __FUNCTION__);
	Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
	for ( iter = m_UsersInside.begin(); iter != m_UsersInside.end(); iter++ )
	{
		CUser* currUser = CUser::GetUser(*iter);
		// this shouldn't happen, but if a null user is found, just get rid of them from the room
		if ( currUser == 0 )
		{
			toKick.push_back(*iter);
			m_UsersInside.erase(iter);
			continue;
		}
		CLog::Record("Sending PACK_USERLEAVECHAT to %s", currUser->GetName());
		currUser->SendTo(message, sizeof(message));
	}
	Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	Pthread_mutex_unlock(&m_InsideUsersMutex, __FUNCTION__);

	if ( toKick.size() > 0 )
		Kicked(toKick);
}

// function CChatRoom::Kicked
//  This just handles mass kicking of users that have null references.  shouldn't really ever be called
void CChatRoom::Kicked(vector<int>& users)
{
	vector<int>::iterator iter = users.begin();
	for ( iter = users.begin(); iter != users.end(); iter++ )
		Kicked(*iter);
}
