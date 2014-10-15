#ifndef SERVERSETTINGS_H
#define SERVERSETTINGS_H

#include "global.h"

using namespace std;

class CServerSettings
{
private:
	int					m_port;
	string				m_mysqlUser;
	string				m_mysqlPassword;
	string				m_mysqlDatabase;
	string				m_mysqlUserTable;

public:
	CServerSettings(void);
	~CServerSettings(void);

	bool Parse(const char* filename);

	string GetMysqlUser() { return m_mysqlUser; }
	string GetMysqlPassword() { return m_mysqlPassword; }
	int GetPort() { return m_port; }
	string GetMysqlDatabase() { return m_mysqlDatabase; }
	string GetMysqlUserTable() { return m_mysqlUserTable; }
};

#endif
