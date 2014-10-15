#include "Dbase.h"

#include "MYSQLerrmsg.h"
#include <cstdio>

using namespace std;

static char genbuffer[256];

CDbase::CDbase(void)
{
	m_bConnected = false;
	m_pLastResult = 0;
	mysql_init(&m_SQL);
}

CDbase::~CDbase(void)
{
	if ( m_bConnected )
	{
		mysql_close(&m_SQL);
	}
}

// function Connect
// takes the appropriate information needed to connect to a mysql database
// and makes the connection
// returns false if there is a connection already, or if the connection fails
// returns true on success
bool CDbase::Connect(const char* host, const char* user, const char* password,
		const char* database, unsigned int port)
{
	if ( m_bConnected || !host || !user || !password )
		return false;
	if ( mysql_real_connect(&m_SQL, host, user, password, database, port, 0, 0) )
	{
		m_bConnected = true;
		return true;
	}
	return false;
}

// function Close
// pretty obvious
void CDbase::Close()
{
	if ( m_bConnected )
	{
		if ( m_pLastResult )
		{
			mysql_free_result(m_pLastResult);
			m_pLastResult = 0;
		}
		mysql_close(&m_SQL);
		mysql_init(&m_SQL);
	}
	m_bConnected = false;
}

// function GenericQuery
// does a generic query and leaves it to the user to call the appropriate function
// to obtain results
// if multiple queries are done with this, you have access to only the first one
// call "NextResult" to get access to the next query result, if one exists
bool CDbase::GenericQuery(const char* query, int optsize)
{
	// return false if there is no connection or for a null query sting
	if ( query == 0 || !m_bConnected )
		return false;
	if ( m_pLastResult != 0 )
	{
		mysql_free_result(m_pLastResult);
		m_pLastResult = 0;
	}
	// if the query contains binary data you MUST put in a correct value for optsize
	// strlen won't do it properly
	if ( optsize == 0 )
	{
		optsize = (int)strlen(query);
	}
	int res = mysql_real_query(&m_SQL, query, optsize);
	if ( res == 0 )
	{
		m_pLastResult = mysql_store_result(&m_SQL);
		return true;
	}

	// here's where logging should be done... a log class would be most useful
	switch ( res )
	{
	case CR_COMMANDS_OUT_OF_SYNC:
		sprintf(genbuffer, "CR_COMMANDS_OUT_OF_SYNC");
		break;
	case CR_SERVER_GONE_ERROR:
		sprintf(genbuffer, "CR_SERVER_GONE_ERROR");
		break;
	case CR_SERVER_LOST:
		sprintf(genbuffer, "CR_SERVER_LOST");
		break;
	default:
		sprintf(genbuffer, "CR_UNKNOWN_ERROR %d", res);
		break;
	}

	CLog::Error("Query: %s has error %s", __FUNCTION__, query, genbuffer);
	return false;
};

// function RowsReturned
// returns the number of rows returned in the last query
// will be 0 if it wasn't a select or something of the sort or if there is no connection!
unsigned long CDbase::RowsReturned()
{
	if ( !m_bConnected || !m_pLastResult )
		return 0;
	return (unsigned long)mysql_num_rows(m_pLastResult);
}

// function NumFields
// returns the number of columns in the last query
// will be 0 if there is no connection
unsigned int CDbase::NumFields()
{
	if ( !m_bConnected || !m_pLastResult )
		return 0;
	return mysql_num_fields(m_pLastResult);
}

// function Free
// frees the current result set
// handy if you want to keep the connection open but not keep the last query in memory
void CDbase::Free()
{
	if ( m_pLastResult )
	{
		mysql_free_result(m_pLastResult);
		m_pLastResult = 0;
	}
}

// function GetRow
// returns a char** of the row returned from the last query
// returns null if the row number is invalid or no rows were returned
MYSQL_ROW CDbase::GetRow(unsigned long row)
{
	if ( !m_pLastResult || row < 0 || row >= RowsReturned() )
		return 0;
	mysql_data_seek(m_pLastResult, row);
	return mysql_fetch_row(m_pLastResult);
}

// function GetFields
// Returns the column information of the last table returned
MYSQL_FIELD* CDbase::GetFields()
{
	if ( !m_bConnected || !m_pLastResult )
		return 0;
	return mysql_fetch_fields(m_pLastResult);
}

// function GetAssociativeRow
// returns false if no row was returned (not counting a 0 row return)
// Maps the column name to its value
bool CDbase::GetAssociativeRow(SQLRow& Row, unsigned long rownum)
{
	MYSQL_ROW currrow = GetRow(rownum);
	if ( currrow == 0 )
		return false;

	MYSQL_FIELD* fields = GetFields();
	Row.clear();
	unsigned int numfields = mysql_num_fields(m_pLastResult);


	for ( unsigned int i = 0; i < numfields; i++ )
	{
		Row[ fields[i].name ] = currrow[i];
	}

	return true;
}

// function GetAssociativeTable
// Does the same as the function above except it returns
// ALL rows stored as a vector of rows
bool CDbase::GetAssociativeTable(SQLTable& table)
{
	if ( !m_bConnected || !m_pLastResult )
		return false;

	table.clear();
	MYSQL_FIELD* fields = GetFields();
	unsigned int numfields = mysql_num_fields(m_pLastResult);
	mysql_data_seek(m_pLastResult, 0);
	
	unsigned long numrows = (unsigned long)mysql_num_rows(m_pLastResult);
	for ( unsigned long i = 0; i < numrows; i++ )
	{
		MYSQL_ROW currrow = mysql_fetch_row(m_pLastResult);
		SQLRow Row;
		for ( unsigned int i = 0; i < numfields; i++ )
		{
			Row[ fields[i].name ] = currrow[i];
		}
		table.push_back(Row);
	}

	return true;
}

// function AffectedRows
// this is useful when doing non returning queries, like update
// finds out how many rows are affected by the operation
unsigned long CDbase::AffectedRows()
{
	if ( !m_bConnected )
	{
		CLog::Record("Affected rows error");
		return 0;
	}
	CLog::Record("Affected Rows: %d", (int)mysql_affected_rows(&m_SQL));
	return (unsigned long)mysql_affected_rows(&m_SQL);
}

// function AreMoreResults
// returns whether or not there are more results waiting
bool CDbase::AreMoreResults()
{
	if ( !m_bConnected || !m_pLastResult )
		return false;
	return ( (mysql_more_results(&m_SQL) == 1) ? true : false );
}

// function NextResult
// if another query is available from the last call to real_query
//  then execute the query and refill the MYSQL_RES structure
// returns true on success, false if no more results or fail
bool CDbase::NextResult()
{
	if ( !m_bConnected || !m_pLastResult )
		return false;
	int res = mysql_next_result(&m_SQL);
	if ( res == -1 )
		return false;
	if ( res == 0 )
	{
		mysql_free_result(m_pLastResult);
		m_pLastResult = mysql_store_result(&m_SQL);
		return true;
	}

	// else an error occured
	switch ( res )
	{
	case CR_COMMANDS_OUT_OF_SYNC:
		sprintf(genbuffer, "CR_COMMANDS_OUT_OF_SYNC");
		break;
	case CR_SERVER_GONE_ERROR:
		sprintf(genbuffer, "CR_SERVER_GONE_ERROR");
		break;
	case CR_SERVER_LOST:
		sprintf(genbuffer, "CR_SERVER_LOST");
		break;
	default:
		sprintf(genbuffer, "CR_UNKNOWN_ERROR %d", res);
		break;
	}

	CLog::Error(genbuffer, __FUNCTION__);
	return false;
}
