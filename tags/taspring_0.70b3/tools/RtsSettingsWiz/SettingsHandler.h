#ifndef SETTINGSHANDLER_H
#define SETTINGSHANDLER_H

/* This object is OS independant
 *
 * If you add anything to it, make sure your only using the std libs
 *
 * For things, like paths, use SETTINGSHANDLER_FILE_PATH as a template
 */

// Meh, let's just be sure we're not compiling for windows :D
#if defined(_WIN32) || defined(WIN32) || defined(_WINDOWS) || defined(WINDOWS)
	#ifndef WIN32
		// This just makes sure "WIN32" is defined, on windows builds
		#define WIN32
	#endif
#else
	#ifndef NIX
		// Make it easy to see if we're building for linux
		#define NIX
	#endif
#endif

// This is the default path to the settings file
#ifdef WIN32
	#define SETTINGSHANDLER_FILE_PATH	".\\settings.ini"
#else // If def NIX
	#define SETTINGSHANDLER_FILE_PATH	"~/.taspring/settings"
#endif

#include <string>	// I don't know who decided string was a good thing to include, but I hate string!, string is the worst type in the world!

using std::string;

#define FOPEN_MODE_TEXTREAD				"rt"	// Open a file for reading. The file must exist.
#define FOPEN_MODE_TEXTREADWRITECREATE	"w+t"	// Create an empty file for reading and writing. If a file with the same name already exists its content is erased before it is opened.

// Ok... UINT64 = 18446744073709551616 || INT64 = -9223372036854775808
//                123456789a123456789bN           123456789a123456789bN
// That's 21, so let's make it 210 to be safe ^.^
#define	SHANDLER_MAX_NUMCHARS				210	// The max size in chars, of a number converted to string

class SettingsHandler
{
public:
	SettingsHandler(bool bConstructorLoadsAndSaves = true);
	virtual ~SettingsHandler(void);

	// Get's
	string GetString(string strName, string strDef);
	unsigned int GetInt(string strName, unsigned int uiDef);

	// Set's
	void SetString(string strName, string strValue);
	void SetInt(string strName, unsigned int uiValue);

	/* This struct is used as "linear list".
	 *
	 * (pNVP->pPrevNVP == NULL); if true, this is the first item in the list.
	 *
	 * (pNVP->pPrevNVP == 0x80808080); It's value is a pointer to the NVP structure that comes before it
	 * (pNVP->pNextNVP == 0x8080A080); It's value is a pointer to the NVP structure that comes after it
	 *
	 * (pNVP->pNextNVP == NULL); if true, this is the last item in the list.
	 *
	 ****************************************
	 * So the "list" can quickly add or remove items
	 * The slow part is finding the item...
	 *
	 * How to improve on that? Add in sorting, and maintain a separate list of
	 * first letter "a" names, first letter "b" names... etc...
	 *
	 * How to improve on that? Add in sorting, and have each item maintain a
	 * reference to the next and prev major letter. ie: name="MyName" has a
	 * reference to the next first letter and next last letter, so
	 * pPrevMajorNVP == {name="GIsBeforeM", ...}, and
	 * pNextMajorNVP == {name="NIsAfterM", ...}. This will speed up
	 * sorting/finding, without slowing down "adding" or "removing" of items.
	 *
	 * Or change the list into a tree, with each item on the tree having 2
	 * branches and 1 "parent branch" reference. each "sub branch" splits the
	 * remaining list in half. This is fast 'sorting' but slow adding and
	 * removing of items.
	 */
	typedef struct tag_SettingsHandler_NVP
	{
		// The name id
		char*						pcharName;

		// The string value
		char*						pcharValue;

		// The number value
		unsigned int				uiValue;

		// Is this a string? Is this a number? (can be both)
		bool						bIsString;
		bool						bIsNum;

		// References to next prev list items
		tag_SettingsHandler_NVP*	pNextNVP;
		tag_SettingsHandler_NVP*	pPrevNVP;
	} NVP;

	/* This is use to "travel across" the NVP linear list
	 *
	 * Here's how to use it:
	 *
	 * functionname()
	 * {
	 *    NVP* pointerToAnNVP;
	 *
	 *    pointerToAnNVP = GetNVPIterator(true); // true to get first item
	 *
	 *    while (pointerToAnNVP)
	 *    {
	 *       // Do stuff to pointerToAnNVP
	 *       pointerToAnNVP = GetNVPIterator(false); // continue from last returned NVP
	 *    }
	 * }
	 */
	NVP* GetNVPIterator(bool bResetList = false);

protected:
	// Get's for the linear list
	string GetNameValuePairString(string strName, string strDef);
	unsigned int GetNameValuePairInt(string strName, unsigned int uiDef);

	// Set's for the linear list
	void SetNameValuePairString(string strName, string strValue);
	void SetNameValuePairInt(string strName, unsigned int uiValue);

	// This is used by the sets, to limit code duplication
	void SetNameValuePair(string strName, char* pcharValue, bool bIsString, unsigned int uiValue, bool bIsNum);

	// Delete's the entire linear list
	void DeleteAllNameValuePairs(void);

	// OS Independant loads and saves
	void LoadIniFileData(string strIniFilePath = SETTINGSHANDLER_FILE_PATH);
	void SaveIniFileData(string strIniFilePath = SETTINGSHANDLER_FILE_PATH);

	// data members
	NVP*	m_pFirstNameValuePair;
	NVP*	m_pLastNameValuePair;

	bool	m_bDirtyNVPs;
	bool	m_bConstructorLoadsAndSaves;
};

#ifdef NIX
	extern SettingsHandler g_SettingsHandler;
#endif

#endif // SETTINGSHANDLER_H