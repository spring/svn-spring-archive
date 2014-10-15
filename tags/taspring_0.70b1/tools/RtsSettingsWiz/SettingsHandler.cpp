#include "StdAfx.h"
#include "SettingsHandler.h"

/*********************************************
 * How does the ini file work?
 *
 * This you should try to do... names and values can be
 * any characture, but ~should~ be enclosed in quotes.
 * Between the quoted names/values have an equal sign.
 * End the expression with a newline.
 * For number, equal sign, char 'n' is used in place of a single "=" sign
 *
 * Be careful! the line: (name=notanumber) will look like a number value...
 * To prevent accidents like this ~always~ quote names and value pairs...
 * the line: ("name"="notanumber") will look like a string value.
 *
 * TAKE GOOD NOTE!!!!!!
 * Straight from MSDN:
 *
 **********************************************
 *
 * Registry Element Size Limits
 *
 *	The following are the size limits for the various registry elements.
 *		- The maximum size of a key name is 255 characters. 
 *		- The maximum size of a value name is as follows: 
 *			> Windows Server 2003 and Windows XP:  16383 characters
 *			> Windows 2000:  260 ANSI characters or 16383 Unicode characters.
 *			> Windows Me/98/95:  255 characters
 *		- Long values (more than 2048 bytes) should be stored as files with the file
 *		names stored in the registry. This helps the registry perform efficiently.
 *		The maximum size of a value is as follows: 
 *			> Available memory. 
 *			> Windows Me/98/95:  16,300 bytes. There is a 64K limit for the total
 *			size of all values of a key.
 *
 **********************************************
 *
 * Keep that in mind, when making entries into the file. The
 * name/value pairs should conform to these standards if they
 * are to be OS independant.
 *
 **********************************************
 * Example of a settings.ini file
********************* settings.ini ***********************
"version"="0.0.0.1"
"name"=""3vi1 n@me wi7h qu0te$ @round |T... ""
"ip"="192.168.154.1"
"GroundDetails"=n"1000"
""3vi1 v@1ue w|th qu0te$ @round :7... ""="67890"
********************* settings.ini ***********************
 *
 * TODO:
 *  - Only save on changes to the file, using m_bDirtyNVPs (to save on disk writes)
 *  - Don't trash all the extra formating when saving the file
 *  - I dono... make the linear list faster? 0.o
 *
 *********************************************************
 *
 * MODIFICATIONS:
 *  - Add support for comments (lines begining with spaces/tabs and then '#')
 *
 *********************************************************
 * Created: Jul 27, 2005
 *  Robert Diamond  <deadram@gmail.com>
 *
 * Please add this data above (it makes you feel good, and keep
 * modifications organized). Add your modifications under
 * the "TODO" list
 *
 * Modified: <date>
 *  <name> <email>
 *********************************************************/

// Only create this object if we're doing a linux build
#ifdef NIX
	SettingsHandler	g_SettingsHandler();
#endif

SettingsHandler::SettingsHandler(bool bConstructorLoadsAndSaves /*= true*/)
	:	m_pFirstNameValuePair		(NULL),
		m_pLastNameValuePair		(NULL),
		m_bConstructorLoadsAndSaves	(bConstructorLoadsAndSaves),
		m_bDirtyNVPs				(true)
{
	//m_bConstructorLoadsAndSaves = bConstructorLoadsAndSaves;

	if (m_bConstructorLoadsAndSaves)
	{
		LoadIniFileData(SETTINGSHANDLER_FILE_PATH);
	}
}

SettingsHandler::~SettingsHandler(void)
{
	if (m_bConstructorLoadsAndSaves)
	{
		SaveIniFileData(SETTINGSHANDLER_FILE_PATH);
	}

	DeleteAllNameValuePairs();
}

// Get's
string SettingsHandler::GetString(string strName, string strDef)
{
	return GetNameValuePairString(strName, strDef);
}

unsigned int SettingsHandler::GetInt(string strName, unsigned int uiDef)
{
	return GetNameValuePairInt(strName, uiDef);
}

// Set's
void SettingsHandler::SetString(string strName, string strValue)
{
	return SetNameValuePairString(strName, strValue);
}

void SettingsHandler::SetInt(string strName, unsigned int uiValue)
{
	return SetNameValuePairInt(strName, uiValue);
}

// This is use to "travel across" the NVP linear list
SettingsHandler::NVP* SettingsHandler::GetNVPIterator(bool bResetList /*= false*/)
{
	static NVP*	pCurNVP = NULL;

	if (bResetList)
	{
		pCurNVP = m_pFirstNameValuePair;
		return pCurNVP;
	}
	else
	{
		// pCurNVP could be null... be careful...
		if (pCurNVP)
			pCurNVP = pCurNVP->pNextNVP;

		return pCurNVP;
	}
}

/**********************
 * Protected sections *
 **********************/

// Get's for the linear list
string SettingsHandler::GetNameValuePairString(string strName, string strDef)
{
	NVP* pCurNVP = m_pFirstNameValuePair;

	while (pCurNVP)
	{
		if (strcmp(pCurNVP->pcharName, strName.c_str()) == 0)
		{
			// If this NVP has a string, return it
			if (pCurNVP->bIsString)
			{
				// Return a deep copy of the string
				return string(pCurNVP->pcharValue);
			}
			// Else, return the default
			else
			{
				return strDef;
			}
		}

		pCurNVP = pCurNVP->pNextNVP;
	}

	return strDef;
}

unsigned int SettingsHandler::GetNameValuePairInt(string strName, unsigned int uiDef)
{
	NVP* pCurNVP = m_pFirstNameValuePair;

	while (pCurNVP)
	{
		if (strcmp(pCurNVP->pcharName, strName.c_str()) == 0)
		{
			// If this NVP has a number, return it
			if (pCurNVP->bIsNum)
			{
				// Return the number
				return unsigned int(pCurNVP->uiValue);
			}
			// Else, return the default
			else
			{
				// Meh, nothings perfect (the NVP doesn't have a number) XD
				return uiDef;
			}
		}

		pCurNVP = pCurNVP->pNextNVP;
	}

	return uiDef;
}

// Set's for the linear list
void SettingsHandler::SetNameValuePairString(string strName, string strValue)
{
	// Size our char memory
	char*			pcharValue = new char[strValue.length() + 1/*NULL*/];

	// Copy the string into it's new place
	strcpy(pcharValue, strValue.c_str());

	// strName, string value, Are we setting the string?, number value, are we setting the number?
	return SetNameValuePair(strName, pcharValue, true, 0, false);
}

void SettingsHandler::SetNameValuePairInt(string strName, unsigned int uiValue)
{
	// strName, string value, Are we setting the string?, number value, are we setting the number?
	return SetNameValuePair(strName, NULL, false, uiValue, true);
}

// This is used by the sets, to limit code duplication
void SettingsHandler::SetNameValuePair(string strName, char* pcharValue, bool bIsString, unsigned int uiValue, bool bIsNum)
{
	NVP* pCurNVP = m_pFirstNameValuePair;

	// Is this name in the list?
	while (pCurNVP)
	{
		if (strcmp(pCurNVP->pcharName, strName.c_str()) == 0)
		{
			// We're setting the string
			if (bIsString)
			{
				// Remove old memory
				if (pCurNVP->pcharValue)
					delete ((char*)(pCurNVP->pcharValue));

				// set the value
				pCurNVP->pcharValue	= pcharValue;

				// Set the "is string"
				pCurNVP->bIsString = bIsString;
			}

			// We're setting the number
			if (bIsNum)
			{
				// Set the value
				pCurNVP->uiValue	= uiValue;

				// Set the "is num"
				pCurNVP->bIsNum	= bIsNum;
			}

			// The values are all set ^.^
			return /*ALL_OK*/;
		}

		pCurNVP = pCurNVP->pNextNVP;
	}

	// If we get here, we don't have this name in the list, create it
	NVP* pNewNVP = new NVP;
	pNewNVP->pcharName	= new char[strName.length() + 1/*NULL*/];
							strcpy(pNewNVP->pcharName, strName.c_str());
	pNewNVP->pcharValue	= NULL;		// Meh, good habit
	pNewNVP->uiValue	= 0;
	pNewNVP->bIsString	= false;
	pNewNVP->bIsNum		= false;
	pNewNVP->pNextNVP	= NULL;		// Don't remove this you friker!
	pNewNVP->pPrevNVP	= NULL;		// Remove this to let lose memory leaks!

	// Set the string value?
	if (bIsString)
	{
		pNewNVP->pcharValue	= pcharValue;
		pNewNVP->bIsString	= bIsString;
	}

	// Set the num value?
	if (bIsNum)
	{
		pNewNVP->uiValue	= uiValue;
		pNewNVP->bIsNum		= bIsNum;
	}

	// We have a list
	if (m_pLastNameValuePair)	// Do we have a list?
	{
		/* Hummm It's going to come after the current "last item"
		 * and the current "last item" is going to be the second
		 * to last item
		 *
		 * [listItem]<->[listItem]<->[listItem]<->[LastListItem]   [NewLastItem]
		 * [listItem]<->[listItem]<->[listItem]<->[LastListItem]<--[NewLastItem]
		 * [listItem]<->[listItem]<->[listItem]<->[LastListItem]<->[NewLastItem]
		 * [listItem]<->[listItem]<->[listItem]<->[listItem    ]<->[LastListItem]
		 *
		 * See it now? and it happends in that order too XD
		 */
		pNewNVP->pPrevNVP				= m_pLastNameValuePair;
		m_pLastNameValuePair->pNextNVP	= pNewNVP;

		// It's the new last item
		m_pLastNameValuePair			= pNewNVP;
	}
	// We need to make a list to add this item
	else
	{
		// This is the new first and last item
		m_pFirstNameValuePair	= pNewNVP;
		m_pLastNameValuePair	= pNewNVP;
	}

	return /*ALL_OK*/;
}

// Delete's the entire linear list
void SettingsHandler::DeleteAllNameValuePairs(void)
{
	// If a list exists, let's delete it...
	while (m_pFirstNameValuePair)
	{
		NVP* pCurNVP = m_pFirstNameValuePair;

		// Delete the name char array
		if (pCurNVP->pcharName)
			delete ((char*)(pCurNVP->pcharName));

		// Delete the value char array
		if (pCurNVP->pcharValue)
			delete ((char*)(pCurNVP->pcharValue));

		// Move our "index" up
		m_pFirstNameValuePair = m_pFirstNameValuePair->pNextNVP;

		// Delete this NVP
		delete pCurNVP;
	}

	/* Now m_pFirstNameValuePair == NULL
	 *
	 * And all entries in the list have been "free"'d
	 */

	// Meh, force of good habit ^.^
	m_pLastNameValuePair = NULL;

	return /*ALL_OK*/;
}

// Loading ini file
void SettingsHandler::LoadIniFileData(string strIniFilePath /*= SETTINGSHANDLER_FILE_PATH*/)
{
	// Load the file into a buffer
	FILE*	pIniFile = fopen(strIniFilePath.c_str(), FOPEN_MODE_TEXTREAD);	// Open in text mode for r, or return NULL if file DNE
	long	lFileByteSize;
	size_t	nBufferByteSize;
	char*	pcharBuffer;

	// File DNE or bad permissions
	if (! pIniFile)
	{
		// Well, nothing to load...
		return /*File DNE, or bad permissions*/;
	}

	// obtain file size
	fseek(pIniFile, 0, SEEK_END);
	lFileByteSize = ftell(pIniFile);
	rewind(pIniFile);

	// 0 size file?
	if (! lFileByteSize)
	{
		// Well, nothing to load...
		fclose(pIniFile);
		return /*0 size file*/;
	}

	// Allocate memory for holding the file
	nBufferByteSize = /*file size*/lFileByteSize;

	pcharBuffer = (char*)malloc(nBufferByteSize);
	// Low memory?
	if (pcharBuffer == NULL)
	{
		fclose(pIniFile);
		return /*Critical, low memory*/;
	}

	// Copy the file into the buffer
	// Because of text mode translations, etc... this is the new 'end of file'
	size_t nNewFileByteSize = fread(pcharBuffer, sizeof(char), lFileByteSize, pIniFile);

	// Copy a "NULL" into the last chunk of the string (since fread won't do it automatically for us)
	strcpy(pcharBuffer + nNewFileByteSize, "");

	/* the whole file is loaded in the buffer. */

	// Close the file
	fclose(pIniFile);

	// Turn tabs into spaces (No sizeof(char) here, cause we're using pcharBuffer as an array
	for (size_t i = 0; i < strlen(pcharBuffer); i++)
		if ( (pcharBuffer[i] == '\t') || (pcharBuffer[i] == '\v') ) pcharBuffer[i]=' ';

	// For each line
	char* pcharLine = strtok(pcharBuffer, "\n");
	while (pcharLine != NULL)
	{
		// Do we have an '=' char?
		char* pEqual = strchr(pcharLine, '=');

		if (pEqual)
		{
			char*	pName = pcharLine;				// Here's the RAW name
			char*	pValue = pEqual + sizeof(char);	// Here's the RAW value
			bool	bIsNum = false;

			// Null the equal sign to separate name from value
			strcpy(pEqual, "");

			// Is this a number value?
			if (pValue[0] == 'n')
			{
				bIsNum = true;
				pValue += sizeof(char);
			}

			// Remove leading spaces
			while (pName[0] == ' ')		pName += sizeof(char);
			while (pValue[0] == ' ')	pValue += sizeof(char);

			// Remove Trailing spaces
			while (pName[strlen(pName) - 1] == ' ')
				strcpy(pName + ((strlen(pName) - 1) * sizeof(char)), "");
			while (pValue[strlen(pValue) - 1] == ' ')
				strcpy(pValue + ((strlen(pValue) - 1) * sizeof(char)), "");

			// Is the first 'real' char a comment? '#'
			if (pName[0] != '#')
			{
				// Remove quotes, if there is a set
				if ((pName[0] == '"') && (pName[strlen(pName) - 1] == '"'))
					{ pName += sizeof(char);	strcpy(pName + ((strlen(pName) - 1) * sizeof(char)), "");}
				if ((pValue[0] == '"') && (pValue[strlen(pValue) - 1] == '"'))
					{ pValue += sizeof(char);	strcpy(pValue + ((strlen(pValue) - 1) * sizeof(char)), "");}

				/* Now we have the final name/value pair */

				// Is this a number value?
				if (bIsNum)
				{
					SetNameValuePairInt(pName, (unsigned int)atoi(pValue));
				}
				// Is this a string value?
				else
				{
					SetNameValuePairString(pName, pValue);
				}
			}
		}

		// Get next line, or NULL at end of buffer
		pcharLine = strtok (NULL, "\n");
	}

	// We're done with the buffer
	free(pcharBuffer);

	return /*All ok*/;
}

// Saving ini file
void SettingsHandler::SaveIniFileData(string strIniFilePath /*= SETTINGSHANDLER_FILE_PATH*/)
{
	// Meh, if nothings dirty, don't save XD
	if (m_bDirtyNVPs)
	{
		// Load the file into a buffer
		FILE*	pIniFile = fopen(strIniFilePath.c_str(), FOPEN_MODE_TEXTREADWRITECREATE);	// Open in text mode for r/w, and force "create" (ie: overwrite old file)

		// bad permissions?
		if (! pIniFile)
		{
			return /*Bad permissions?*/;
		}

		// Make sure we're at the top of the file XD
		rewind(pIniFile);

		// write each NVP into the file
		NVP*	pCurNVP = m_pFirstNameValuePair;
		while (pCurNVP) {
			if (pCurNVP->bIsString)
			{
				fwrite("\"",				sizeof(char), strlen("\""),					pIniFile);	// Leading quote (")
				fwrite(pCurNVP->pcharName,	sizeof(char), strlen(pCurNVP->pcharName),	pIniFile);	// name
				fwrite("\"=\"",				sizeof(char), strlen("\"=\""),				pIniFile);	// Trailing quote, equal, leading quote ("=")
				fwrite(pCurNVP->pcharValue,	sizeof(char), strlen(pCurNVP->pcharValue),	pIniFile);	// value
				fwrite("\"\n",				sizeof(char), strlen("\"\n"),				pIniFile);	// Trailing quote, newline ("\n)
			}

			if (pCurNVP->bIsNum)
			{
				char	pcharNumBuffer[SHANDLER_MAX_NUMCHARS];

				// Convert num to string
				itoa(pCurNVP->uiValue, pcharNumBuffer, 10);

				fwrite("\"",				sizeof(char), strlen("\""),					pIniFile);	// Leading quote (")
				fwrite(pCurNVP->pcharName,	sizeof(char), strlen(pCurNVP->pcharName),	pIniFile);	// name
				fwrite("\"=n\"",			sizeof(char), strlen("\"=n\""),				pIniFile);	// Trailing quote, equal, 'n', leading quote ("=n")
				fwrite(pcharNumBuffer,		sizeof(char), strlen(pcharNumBuffer),		pIniFile);	// value
				fwrite("\"\n",				sizeof(char), strlen("\"\n"),				pIniFile);	// Trailing quote, newline ("\n)
			}

			pCurNVP = pCurNVP->pNextNVP;														// This makes (pCurNVP == NULL) if we reach last item
		}

		/* the whole linear list is loaded in the file. */

		// Close the file
		fclose(pIniFile);
	}

	return /*All Ok*/;
}
