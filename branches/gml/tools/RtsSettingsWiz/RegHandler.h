// RegHandler.h: interface for the RegHandler class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_REGHANDLER_H__508F534F_9F3D_11D6_AD55_DE4DC0775D55__INCLUDED_)
#define AFX_REGHANDLER_H__508F534F_9F3D_11D6_AD55_DE4DC0775D55__INCLUDED_

// This is the SettingsHandler object, which is OS independant
#include "SettingsHandler.h"

// NIX compatible section
#ifdef NIX
	// Meh, makes it easier on the convertion from WIN32 to OS Independant :D
	#define regHandler	(g_SettingsHandler)

	#warning "You've included RegHandler in this build. RegHandler has been replaced by SettingsHandler."

// Windows section
#else // if def WIN32

	#if _MSC_VER > 1000
	#pragma once
	#endif // _MSC_VER > 1000

	#include <string>
	#include <windows.h>
	#include <winreg.h>
	#include "SettingsHandler.h"

	using std::string;

	class RegHandler  
	{
	public:
		RegHandler(string keyname, HKEY key = HKEY_CURRENT_USER);
		virtual ~RegHandler();

		// This is used to get a value in the registry/file
		string			GetString	(string name,	string def,			BOOL bForceReg = FALSE);
		unsigned int	GetInt		(string name,	unsigned int def,	BOOL bForceReg = FALSE);

		// This is used to add/change a value in the registry/file
		void			SetString	(string name,	string value,		BOOL bForceReg = FALSE);
		void			SetInt		(string name,	unsigned int value,	BOOL bForceReg = FALSE);

		// This copies the data in one location, to the other.
		void CopyFileToRegistry(void);
		void CopyRegistryToFile(void);

		HKEY				m_HKeyParent;
		BOOL				m_bUseRegistry;
		SettingsHandler*	m_pSettingsHandler;
	};

	extern RegHandler regHandler;

#endif // if def WIN32

#endif // !defined(AFX_REGHANDLER_H__508F534F_9F3D_11D6_AD55_DE4DC0775D55__INCLUDED_)
