#ifndef BATTLEROOMMANAGER_H
#define BATTLEROOMMANAGER_H

#include "global.h"
#include <string>

#include <map>

using namespace std;

class CUser;

// class CBattleRoomManager
//  Manages the *information* for each battle room.  Notably the location
// of the battle room, the creator, and whatever stats we wish to send clients

class CBattleRoomManager
{
private:
	// this is pretty self explanatory
	struct BattleRoomInfo
	{
		int		hosterID;
		unsigned int		ID;
		string	name;
		string   mapname;
		unsigned long interfaceAdress;
		unsigned short port;
		unsigned char maxPlayers;
		bool password;
		bool inProgress;
		unsigned char size;
	};

	// maps the battle room id to a BattleRoomInfo struct containing
	// information about the battle room
	map<int, BattleRoomInfo>			m_BattleRooms;
	static pthread_mutex_t				m_BRMmutex;

public:
	CBattleRoomManager(void);
	~CBattleRoomManager(void);

	void GetList(CUser* user);
	void CreateBattleRoom(CUser* user, string name, int capacity, unsigned short port, string mapname, bool password);
	void DestroyRoom(unsigned int id);
	void LeaveRoom(int userid, unsigned int id);

	void UpdateMap(unsigned int id, string newmap);
	void UpdateSize(unsigned int id, unsigned char newsize);
	void UpdateInProgress(unsigned int, bool newState);
};

#endif
