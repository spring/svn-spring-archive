#include "ServerSettings.h"
#include "SunParser.h"

CServerSettings::CServerSettings(void)
{
	m_port = 4897;
	m_mysqlUser = "root";
	m_mysqlPassword = "baguba1313";
	m_mysqlDatabase = "test";
}

CServerSettings::~CServerSettings(void)
{
}

bool CServerSettings::Parse(const char* filename)
{
	CSunParser parser;
	parser.LoadFile(string(filename));
	if ( !parser.SectionExist("Server") )
	{
		CLog::Error("Failed to open server settings from %s", __FUNCTION__, filename);
		return false;
	}

	map<string, string> values = parser.GetAllValues("Server\\Mysql");

	m_mysqlUser = values["user"];
	m_mysqlPassword = values["password"];
	m_mysqlDatabase = values["database"];
	m_mysqlUserTable = values["usertable"];
	values = parser.GetAllValues("Server");

	m_port = atoi(values["port"].c_str());
	
	return true;
}
