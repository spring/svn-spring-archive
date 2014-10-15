#include "BattleRoomManager.h"
#include "User.h"

pthread_mutex_t CBattleRoomManager::m_BRMmutex = PTHREAD_MUTEX_INITIALIZER;

CBattleRoomManager::CBattleRoomManager(void)
{
}

CBattleRoomManager::~CBattleRoomManager(void)
{
}

// function CBattleRoomManager::GetList
//  Sends a list of all battle rooms to user
void CBattleRoomManager::GetList(CUser* user)
{
	Pthread_mutex_lock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);

	// send a PACK_BATTLELIST packet
	CLog::Record("Sending a PACK_BATTLIST to %s", user->GetName());

	size_t perBattleSize = 3+sizeof(int)+MAXBATTLENAME+MAXCLAN+MAXNAME+sizeof(unsigned long)+sizeof(unsigned short)+sizeof(unsigned char)+MAXMAPNAME;
	size_t messageSize = 5+perBattleSize*m_BattleRooms.size();
	unsigned char* message = new unsigned char[messageSize];
	unsigned char* temp = message;
	(*(char*)temp) = PACK_BATTLELIST;
	temp += sizeof(char);
	(*(int*)temp) = (int)m_BattleRooms.size();
	temp += sizeof(int);
	map<int, BattleRoomInfo>::iterator iter = m_BattleRooms.begin();
	while ( iter != m_BattleRooms.end() )
	{
		(*(int*)temp) = (int)iter->second.ID;
		temp += sizeof(int);
		strncpy(reinterpret_cast<char*>(temp), iter->second.name.c_str(), MAXBATTLENAME);
		temp += MAXBATTLENAME;
		CUser* host = CUser::GetUser(iter->second.hosterID);
		if ( host == 0 )
		{
			CLog::Error("Host id %d not found", __FUNCTION__, iter->second.hosterID);
			strncpy(reinterpret_cast<char*>(temp), "", MAXCLAN);
			temp += MAXCLAN;
			strncpy(reinterpret_cast<char*>(temp), "ERROR", MAXNAME);
			temp += MAXNAME;
		}
		else
		{
			strncpy(reinterpret_cast<char*>(temp), host->GetClan(), MAXCLAN);
			temp += MAXCLAN;
			strncpy(reinterpret_cast<char*>(temp), host->GetName(), MAXNAME);
			temp += MAXNAME;
		}
		(*(unsigned short*)temp) = iter->second.port;
		temp += sizeof(unsigned short);
		(*(unsigned char*)temp) = iter->second.maxPlayers;
		temp += sizeof(unsigned char);
		(*(unsigned long*)temp) = iter->second.interfaceAdress;
		temp += sizeof(unsigned long);
		strncpy((char*)temp, iter->second.mapname.c_str(), MAXMAPNAME);
		temp += MAXMAPNAME;
		if ( iter->second.password )
			*temp = 1;
		else
			*temp = 0;
		temp++;
		*temp = iter->second.size;
		temp++;
		*temp = (unsigned char)iter->second.inProgress;
		temp++;
		iter++;
	}

	user->SendTo(reinterpret_cast<const char*>(message), messageSize);
	delete[] message;
	message = 0;
	Pthread_mutex_unlock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
}

// function CBattleRoomManager::CreateBattleRoom
//  Creates a battle room for user, with self explanatory parameters
void CBattleRoomManager::CreateBattleRoom(CUser* user, string name, int capacity, unsigned short port, string mapname, bool password)
{
	// indicates that a battle room is already being hosted by this user
	if ( user->m_HostedBattleID != -1 )
	{
		// failed
		CLog::Record("Failed to create battle room for %s - already hosting another", user->GetName());
		char msg = PACK_BATTLECREATEFAILED;
		user->SendTo(&msg, sizeof(char));
		return;
	}

	CLog::Record("%s hosting battle room %s %d %d", user->GetName(), name.c_str(), capacity, port);
	Pthread_mutex_lock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);

	int index = 0;

	// finds the first unused slot in the map
	map<int, BattleRoomInfo>::iterator iter = m_BattleRooms.begin();
	while ( iter != m_BattleRooms.end() && iter->first == index )
		iter++, index++;

	/*
	sockaddr_in clientAddr;
	socklen_t len = (socklen_t)sizeof(clientAddr);
	// gets the ip address of the user making the battle room
	Getpeername(user->GetSocket(), (sockaddr*)&clientAddr, &len);
	*/

	// sets the battle room info
	BattleRoomInfo bri;
	bri.ID = index;
	bri.hosterID = user->GetId();
	bri.name = name;
	bri.port = port;
	bri.maxPlayers = capacity;
	bri.mapname = mapname;
	bri.interfaceAdress = user->GetIP();//clientAddr.sin_addr.S_un.S_addr;
	bri.password = password;
	bri.inProgress = false;
	bri.size = 1;
	// links the hoster to this battle room
	user->m_HostedBattleID = bri.ID;

	m_BattleRooms[index] = bri;

	unsigned char buffer[9+MAXMAPNAME];
	unsigned char* temp = buffer;
	(*(char*)temp) = PACK_BATTLECREATESUCCESS;
	temp++;
	(*(unsigned int*)temp) = bri.ID;
	temp += sizeof(unsigned int);
	(*(unsigned short*)temp) = bri.port;
	temp += sizeof(unsigned short);
	strncpy((char*)temp, bri.mapname.c_str(), MAXMAPNAME);
	temp += MAXMAPNAME;
	if ( password )
		*temp = 1;
	else
		*temp = 0;
	temp++;
	*temp = bri.maxPlayers;
	user->SendTo(reinterpret_cast<const char*>(buffer), sizeof(buffer));

	// here is where we should send a battle created message to every user

	const size_t msg2len = 1+5+MAXBATTLENAME+MAXCLAN+MAXNAME+sizeof(unsigned short)+sizeof(unsigned char)+sizeof(unsigned long)+MAXMAPNAME;
	unsigned char buffer2[msg2len];
	temp = buffer2;
	(*(char*)temp) = PACK_CREATEBATTLE;
	temp++;
	(*(int*)temp) = bri.ID;
	temp += sizeof(bri.ID);
	strncpy(reinterpret_cast<char*>(temp), bri.name.c_str(), MAXBATTLENAME);
	temp += MAXBATTLENAME;
	strncpy(reinterpret_cast<char*>(temp), user->GetClan(), MAXCLAN);
	temp += MAXCLAN;
	strncpy(reinterpret_cast<char*>(temp), user->GetName(), MAXNAME);
	temp += MAXNAME;
	(*(unsigned short*)temp) = bri.port;
	temp += sizeof(unsigned short);
	(*(unsigned char*)temp) = bri.maxPlayers;
	temp += sizeof(unsigned char);
	(*(unsigned long*)temp) = bri.interfaceAdress;
	temp += sizeof(unsigned long);
	strncpy((char*)temp, bri.mapname.c_str(), MAXMAPNAME);
	temp += MAXMAPNAME;
	if ( password )
		*temp = 1;
	else
		*temp = 0;
	temp++;
	*temp = 1;
	map<int, CUser*>::iterator iter2 = CUser::m_Users.begin();
	while ( iter2 != CUser::m_Users.end() )
	{
		CLog::Record("Sending PACK_BATTLECREATED to %s", iter2->second->GetName());
		iter2->second->SendTo(reinterpret_cast<const char*>(buffer2), msg2len);
		iter2++;
	}
	Pthread_mutex_unlock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
}

// function CBattleRoomManager::DestroyRoom
//  Destroys a battle room with the appropriate id, and then notifies all clients
// of the change.
void CBattleRoomManager::DestroyRoom(unsigned int id)
{
	Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);
	Pthread_mutex_lock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);

	map<int, BattleRoomInfo>::iterator iter = m_BattleRooms.find(id);
	if ( iter != m_BattleRooms.end() )
	{
		CLog::Record("Destroying battle room %s id %d\n", iter->second.name.c_str(), iter->second.ID);
		CUser* user = CUser::GetUser(iter->second.hosterID);
		if ( user != 0 )
		{
			user->m_HostedBattleID = -1;
		}
		m_BattleRooms.erase(iter);
	}
	// send destroyed battle room message to all users here

	unsigned char message[5];
	unsigned char* temp = message;
	*temp = PACK_DESTROYBATTLE;
	temp++;
	(*(unsigned int*)temp) = id;
	map<int, CUser*>::iterator iter2 = CUser::m_Users.begin();
	while ( iter2 != CUser::m_Users.end() )
	{
		CLog::Record("Sending PACK_DESTROYBATTLE to %s", iter2->second->GetName());
		iter2->second->SendTo(reinterpret_cast<const char*>(message), sizeof(message));
		iter2++;
	}

	Pthread_mutex_unlock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
	Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
}

// function CBattleRoomManager::LeaveRoom
//  Notifies the battle room that userid has left the room.  if the id is the host
// then the room is destroyed
void CBattleRoomManager::LeaveRoom(int userid, unsigned int id)
{
	Pthread_mutex_lock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);

	CLog::Record("Leaving battle room - %d", userid);
	map<int, BattleRoomInfo>::iterator iter = m_BattleRooms.find(id);
	if ( iter != m_BattleRooms.end() )
	{
		if ( iter->second.hosterID == userid )
		{
			Pthread_mutex_unlock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
			DestroyRoom(id);
			return;
		}
	}

	Pthread_mutex_unlock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
}

void CBattleRoomManager::UpdateMap(unsigned int id, string newmap)
{
	Pthread_mutex_lock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);

	CLog::Record("Updating map for battle room - %d", id);
	map<int, BattleRoomInfo>::iterator iter = m_BattleRooms.find(id);
	if ( iter != m_BattleRooms.end() )
	{
		iter->second.mapname = newmap;
		Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);

		map<int, CUser*>::iterator iter2 = CUser::m_Users.begin();
		static char msg[MAXMAPNAME+5];
		msg[0] = PACK_MAPUPDATE;
		(*(unsigned int*)&msg[1]) = id;
		strncpy(&msg[5], newmap.c_str(), MAXMAPNAME);
		while ( iter2 != CUser::m_Users.end() )
		{
			iter2->second->SendTo(msg, sizeof(msg));
			iter2++;
		}

		Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	}
	Pthread_mutex_unlock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
}

void CBattleRoomManager::UpdateSize(unsigned int id, unsigned char newsize)
{
	Pthread_mutex_lock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);

	CLog::Record("Updating size for battle room - %d", id);
	map<int, BattleRoomInfo>::iterator iter = m_BattleRooms.find(id);
	if ( iter != m_BattleRooms.end() )
	{
		iter->second.size = newsize;
		Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);

		map<int, CUser*>::iterator iter2 = CUser::m_Users.begin();
		static char msg[6];
		msg[0] = PACK_BATTLESIZEUPDATE;
		(*(unsigned int*)&msg[1]) = id;
		msg[5] = newsize;
		while ( iter2 != CUser::m_Users.end() )
		{
			iter2->second->SendTo(msg, sizeof(msg));
			iter2++;
		}

		Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	}

	Pthread_mutex_unlock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
}

void CBattleRoomManager::UpdateInProgress(unsigned int id, bool newState)
{
	Pthread_mutex_lock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
	CLog::Record("Updating InProgress state for battle room - %d", id);
	map<int, BattleRoomInfo>::iterator iter = m_BattleRooms.find(id);
	if ( iter != m_BattleRooms.end() )
	{
		iter->second.inProgress = newState;
		Pthread_mutex_lock(&CUser::m_UserMutex, __FUNCTION__);

		map<int, CUser*>::iterator iter2 = CUser::m_Users.begin();
		static char msg[6];
		msg[0] = PACK_BATTLEPROGRESS;
		(*(unsigned int*)&msg[1]) = id;
		msg[5] = (unsigned char)newState;
		while ( iter2 != CUser::m_Users.end() )
		{
			iter2->second->SendTo(msg, sizeof(msg));
			iter2++;
		}
		Pthread_mutex_unlock(&CUser::m_UserMutex, __FUNCTION__);
	}
	Pthread_mutex_unlock(&CBattleRoomManager::m_BRMmutex, __FUNCTION__);
}
