#ifndef CHATROOM_H
#define CHATROOM_H

#include "global.h"

#include <list>
#include <vector>

using namespace std;

// class CChatRoom
//  A single, open chatroom accessible by clients.

class CChatRoom
{
private:
	// a list containing the ids of each user inside
	list<int>						m_UsersInside;

	// the name of the chatroom
	string							m_sName;
	// is the chatroom private?  not implemented yet
	bool							m_bPrivate;
	// is the chatroom active?  (ie, initialized)
	bool							m_bActive;
	// is the chatroom permanent?  if its false, then the chatroom
	// is deleted when there are no users inside of it
	bool							m_bPermanent;
	// id of the chatroom used by chatroommanager
	int m_ChatID;

	/* Is that supposed to be static? - gramuxius */
	//static pthread_mutex_t	m_InsideUsersMutex;
	pthread_mutex_t	m_InsideUsersMutex;

public:
	CChatRoom(void);
	~CChatRoom(void);

	size_t NumUsers() { return m_UsersInside.size(); }
	bool IsPerm() { return m_bPermanent; }
	string GetName() { return m_sName; }
	int GetId() { return m_ChatID; }

	void Init(string name, int id, bool priv, bool perm);
	void Post(int from, const char* message, size_t msglen);
	bool Join(int user);
	void Kicked(int user);
	void Kicked(vector<int>& users);

	void Kick(int user, bool notify = true);

	void Kill();
};

#endif
