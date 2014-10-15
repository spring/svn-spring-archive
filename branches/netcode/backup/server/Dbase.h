#ifndef DBASE_H
#define DBASE_H

#include "global.h"

#ifdef ARCHDEF_PLATFORM_WIN32
#include "mysql/include/mysql.h"
#else
#include <mysql/mysql.h>
#endif

#include <string>
#include <vector>
#include <map>

using namespace std;

typedef map<string, string, less<string> > SQLRow;
typedef vector<SQLRow> SQLTable;

// class CDbase
// Serves as a front end for mysql connectivity
class CDbase
{
private:
	// are we connected to the mysql server?
	bool			m_bConnected;
	// information needed by the sql api
	MYSQL			m_SQL;
	MYSQL_RES*		m_pLastResult;

	MYSQL_ROW GetRow(unsigned long rownum);
	MYSQL_FIELD* GetFields();

	pthread_mutex_t		m_Mutex;

public:
	CDbase(void);
	~CDbase(void);

	bool Connect(const char* host, const char* user, const char* password,
		const char* database, unsigned int port);
	void Close();

	bool GenericQuery(const char* query, int optsize = 0);
	bool AreMoreResults();
	bool NextResult();

	void Lock() { Pthread_mutex_lock(&m_Mutex, __FUNCTION__); }
	void Unlock() { Pthread_mutex_unlock(&m_Mutex, __FUNCTION__); }
	
	unsigned long RowsReturned();
	unsigned int NumFields();
	unsigned long AffectedRows();
	void Free();

	// will implement pseudo stored procedures LATER
	bool StoredQuery(const char* func, ...) { return false; };

	bool GetAssociativeRow(SQLRow& Row, unsigned long rownum);
	bool GetAssociativeTable(SQLTable& table);
};

#endif
