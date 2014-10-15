// RegHandler.cpp: implementation of the RegHandler class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
//#include "mmgr.h"
#include "RegHandler.h"

// Only compile this if we're in windows :D
#ifdef WIN32

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

RegHandler regHandler("Software\\SJ\\spring");

RegHandler::RegHandler(string keyname, HKEY key)
	:	m_bUseRegistry		(TRUE),
		m_pSettingsHandler	(NULL)
{
	if (RegCreateKey(key, keyname.c_str(), &m_HKeyParent) != ERROR_SUCCESS)
	{
		if (MessageBox(NULL, "Failed to crete registry key.\n\nTry to use settings file?",
				"Registry error", MB_YESNO | MB_ICONERROR)
			== IDYES)
		{
			m_bUseRegistry = FALSE;
			m_pSettingsHandler = new SettingsHandler();
		}
		/*
		else
		{
			// When we try to load values, we'll end up with the defaults...
		}
		*/
	}
	// If we opened the registry sucessfully
	else
	{
		// Check for "bUseRegistry" key
		m_bUseRegistry = GetInt("bUseRegistry", TRUE);

		// If that key is set to "false", use the file
		if (! m_bUseRegistry)
		{
			m_pSettingsHandler = new SettingsHandler();
		}
	}
}

RegHandler::~RegHandler()
{
	RegCloseKey(m_HKeyParent);

	if (m_pSettingsHandler)
	{
		delete m_pSettingsHandler;
	}
}

string RegHandler::GetString(string name, string def, BOOL bForceReg /*= FALSE*/)
{
	if (m_bUseRegistry | bForceReg)
	{
		unsigned char regbuf[100];
		DWORD regLength=100;
		DWORD regType=REG_SZ;

		if (RegQueryValueEx(m_HKeyParent, name.c_str(), 0, &regType, regbuf, &regLength) == ERROR_SUCCESS)
			return string((char*)regbuf);

		return def;
	}
	else return m_pSettingsHandler->GetString(name, def);
}

unsigned int RegHandler::GetInt(string name, unsigned int def, BOOL bForceReg /*= FALSE*/)
{
	if (m_bUseRegistry | bForceReg)
	{
		unsigned char regbuf[100];
		DWORD regLength=100;
		DWORD regType=REG_DWORD;

		if (RegQueryValueEx(m_HKeyParent, name.c_str(), 0, &regType, regbuf, &regLength) == ERROR_SUCCESS)
			return *((unsigned int*)regbuf);

		return def;
	}
	else return m_pSettingsHandler->GetInt(name, def);
}

void RegHandler::SetString(string name, string value, BOOL bForceReg /*= FALSE*/)
{
	if (m_bUseRegistry | bForceReg)
	{
		if (RegSetValueEx(m_HKeyParent, name.c_str(), 0, REG_SZ,
				(unsigned char*)value.c_str(), (DWORD)(value.size()+1))
			== ERROR_SUCCESS
			)
		{
			return /*All ok*/;
		}

		return /*something bad happend (but not critical; Key DNE?)*/;
	}
	else return m_pSettingsHandler->SetString(name, value);
}

void RegHandler::SetInt(string name, unsigned int value, BOOL bForceReg /*= FALSE*/)
{
	if (m_bUseRegistry | bForceReg)
	{
		if (RegSetValueEx(m_HKeyParent, name.c_str(), 0, REG_DWORD,
				(unsigned char*)&value, sizeof(int))
			== ERROR_SUCCESS)
		{
			return /*All ok*/;
		}

		return /*something bad happend (but not critical; Key DNE?)*/;
	}
	else return m_pSettingsHandler->SetInt(name, value);
}

// This copies the data in one location, to the other.
void RegHandler::CopyFileToRegistry(void)
{
	// If we're using the registry... open the file
	if (m_bUseRegistry)
	{
		if (m_pSettingsHandler) delete m_pSettingsHandler;
		m_pSettingsHandler = new SettingsHandler();
	}

	/* Now we have the file loaded, and NVPs set with thier data */

	// Get the first NVP, or NULL at end of list
	SettingsHandler::NVP* pNVP = m_pSettingsHandler->GetNVPIterator(true);

	while (pNVP)
	{
		// Do we have a string in the NVP?
		if (pNVP->bIsString)
		{
			SetString(pNVP->pcharName, pNVP->pcharValue, TRUE); // TRUE = Force reg entry
		}

		// Do we have a number in the NVP?
		if (pNVP->bIsNum)
		{
			SetInt(pNVP->pcharName, pNVP->uiValue, TRUE); // TRUE = Force reg entry
		}

		// Get the next NVP, or NULL at end of list
		pNVP = m_pSettingsHandler->GetNVPIterator();
	}

	/* Now the file data is copied into the registry */

	if (m_bUseRegistry)
	{
		delete m_pSettingsHandler;
		m_pSettingsHandler = NULL;
	}
}

// This copies the data in one location, to the other.
void RegHandler::CopyRegistryToFile(void)
{
	// If we're using the registry... open the file
	if (m_bUseRegistry)
	{
		if (m_pSettingsHandler) delete m_pSettingsHandler;
		m_pSettingsHandler = new SettingsHandler();
	}

	/* Now we have the file loaded, and old NVPs set with thier data from the file */

	// Get the first registry value
	DWORD		dwIndex = 0;
	char		pcharName[16383 + 1/*NULL*/];		// The maximum size of a value name is as follows: 
	DWORD		dwCharsInNameBuffer = 16383 + 1;	// Windows Server 2003 and Windows XP:  16383 characters
	DWORD		dwType;

	LONG lRet = RegEnumValue(m_HKeyParent, dwIndex, pcharName, &dwCharsInNameBuffer,
					NULL/*reserved*/, &dwType, NULL, NULL);

	while (lRet != ERROR_NO_MORE_ITEMS)
	{
		// If there's an error X.X
		if (lRet != ERROR_SUCCESS)
		{
			MessageBox(NULL, "Cannot enumerate registry values.", "Registry error", MB_OK | MB_ICONERROR);
			break;
		}

		// Ok, time to parse the data :D
		switch (dwType)
		{
			case REG_DWORD:
				m_pSettingsHandler->SetInt(pcharName, GetInt(pcharName, 0, TRUE)); // GetInt(x,y, TRUE) to force grabing from registry
			break;

			// Default
			case REG_SZ:
				m_pSettingsHandler->SetString(pcharName, GetString(pcharName, "", TRUE)); // GetString(x,y, TRUE) to force grabing from registry
			break;
		}

		// Now, reset the 'num of chars' and up our index... Grab next reg value
		dwCharsInNameBuffer = 255 + 1;
		dwIndex++;
		lRet = RegEnumValue(m_HKeyParent, dwIndex, pcharName, &dwCharsInNameBuffer,
				NULL/*reserved*/, &dwType, NULL, NULL);
	}

	/* Now the registry data is copied into the file */

	if (m_bUseRegistry)
	{
		delete m_pSettingsHandler;
		m_pSettingsHandler = NULL;
	}
}

#endif // WIN32