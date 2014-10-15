/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework.spring;

import com.sun.jna.win32.StdCallLibrary;

/*
DLL_EXPORT int          __stdcall Init(bool isServer, int id);
 DLL_EXPORT void         __stdcall UnInit();
 DLL_EXPORT int          __stdcall ProcessUnits(void);
DLL_EXPORT int          __stdcall ProcessUnitsNoChecksum(void);


 */
/**
 *
 * @author AF-Standard
 */
public interface IJNAUnitsync extends StdCallLibrary {
//    String GetSpringVersion();
//    void Message(String p_szMessage);
    
    int Init(boolean isServer, int id);
    void UnInit();
    
//    int ProcessUnits();
//    int ProcessUnitsNoChecksum();
//    
//    String GetCurrentList();
//    void AddClient(int id, String unitList);
//    void RemoveClient(int id);
//    String GetClientDiff(int id);
//    void InstallClientDiff(String diff);
//    
//    
//    int GetUnitCount();
//    String GetUnitName(int unit);
//    String GetFullUnitName(int unit);
//    
//    
//    int IsUnitDisabled(int unit);
//    int IsUnitDisabledByClient(int unit, int clientId);
//    
//    
//    int GetMapCount();
//    
//    
//    
//    int GetPrimaryModCount();
//    
//    
//    
//    int GetPrimaryModArchiveCount(int index);
//    
//    
//    int GetSideCount();
//    
//    
//    void CloseFileVFS(int handle);
//    
//    
//    int FileSizeVFS(int handle);
//    
//    
//    void CloseArchive(int archive);
//    
//    void CloseArchiveFile(int archive, int handle);
//    int SizeArchiveFile(int archive, int handle);
    
}

/*
DLL_EXPORT 




DLL_EXPORT 
DLL_EXPORT void         __stdcall 
DLL_EXPORT 
DLL_EXPORT 
DLL_EXPORT 
DLL_EXPORT const char*  __stdcall 
DLL_EXPORT const char*  __stdcall 
DLL_EXPORT 
DLL_EXPORT 
DLL_EXPORT void         __stdcall AddArchive(const char* name);
DLL_EXPORT void         __stdcall AddAllArchives(const char* root);
DLL_EXPORT unsigned int __stdcall GetArchiveChecksum(const char* arname);
DLL_EXPORT 
DLL_EXPORT const char*  __stdcall GetMapName(int index);
DLL_EXPORT int          __stdcall GetMapInfoEx(const char* name, MapInfo* outInfo, int version);
DLL_EXPORT int          __stdcall GetMapInfo(const char* name, MapInfo* outInfo);
DLL_EXPORT void*        __stdcall GetMinimap(const char* filename, int miplevel);
DLL_EXPORT int          __stdcall GetMapArchiveCount(const char* mapName);
DLL_EXPORT const char*  __stdcall GetMapArchiveName(int index);
DLL_EXPORT unsigned int __stdcall GetMapChecksumFromName(const char* mapName);
DLL_EXPORT unsigned int __stdcall GetMapChecksum(int index);
DLL_EXPORT 
DLL_EXPORT const char*  __stdcall GetPrimaryModName(int index);
DLL_EXPORT const char*	__stdcall GetPrimaryModShortName(int index);
DLL_EXPORT const char*	__stdcall GetPrimaryModGame(int index);
DLL_EXPORT const char*	__stdcall GetPrimaryModShortGame(int index);
DLL_EXPORT const char*	__stdcall GetPrimaryModVersion(int index);
DLL_EXPORT const char*	__stdcall GetPrimaryModMutator(int index);
DLL_EXPORT const char*	__stdcall GetPrimaryModDescription(int index);
DLL_EXPORT const char*  __stdcall GetPrimaryModArchive(int index);
DLL_EXPORT 
DLL_EXPORT const char*  __stdcall GetPrimaryModArchiveList(int arnr);
DLL_EXPORT int           GetPrimaryModIndex(const char* name);
DLL_EXPORT unsigned int  GetPrimaryModChecksum(int index);
DLL_EXPORT unsigned int  GetPrimaryModChecksumFromName(const char* name);
DLL_EXPORT 
DLL_EXPORT const char*   GetSideName(int side);
DLL_EXPORT int           OpenFileVFS(const char* name);
DLL_EXPORT 
DLL_EXPORT void          ReadFileVFS(int handle, void* buf, int length);
DLL_EXPORT 
DLL_EXPORT int           InitFindVFS(const char* pattern);
DLL_EXPORT int           FindFilesVFS(int handle, char* nameBuf, int size);
DLL_EXPORT int           OpenArchive(const char* name);
DLL_EXPORT 
DLL_EXPORT int           FindFilesArchive(int archive, int cur, char* nameBuf, int* size);
DLL_EXPORT int           OpenArchiveFile(int archive, const char* name);
DLL_EXPORT int           ReadArchiveFile(int archive, int handle, void* buffer, int numBytes);
DLL_EXPORT 

// lua custom lobby settings
DLL_EXPORT int          __stdcall GetMapOptionCount(const char* name);
DLL_EXPORT int          __stdcall GetModOptionCount();

DLL_EXPORT const char*  __stdcall GetOptionKey(int optIndex);
DLL_EXPORT const char*  __stdcall GetOptionName(int optIndex);
DLL_EXPORT const char*  __stdcall GetOptionDesc(int optIndex);
DLL_EXPORT int          __stdcall GetOptionType(int optIndex);

// Bool Options
DLL_EXPORT int          __stdcall GetOptionBoolDef(int optIndex);

// Number Options
DLL_EXPORT float        __stdcall GetOptionNumberDef(int optIndex);
DLL_EXPORT float        __stdcall GetOptionNumberMin(int optIndex);
DLL_EXPORT float        __stdcall GetOptionNumberMax(int optIndex);
DLL_EXPORT float        __stdcall GetOptionNumberStep(int optIndex);

// String Options
DLL_EXPORT const char*  __stdcall GetOptionStringDef(int optIndex);
DLL_EXPORT int          __stdcall GetOptionStringMaxLen(int optIndex);

// List Options
DLL_EXPORT int          __stdcall GetOptionListCount(int optIndex);
DLL_EXPORT const char*  __stdcall GetOptionListDef(int optIndex);
DLL_EXPORT const char*  __stdcall GetOptionListItemKey(int optIndex, int itemIndex);
DLL_EXPORT const char*  __stdcall GetOptionListItemName(int optIndex, int itemIndex);
DLL_EXPORT const char*  __stdcall GetOptionListItemDesc(int optIndex, int itemIndex);

// Spring settings callback

DLL_EXPORT const char*	__stdcall GetSpringConfigString( const char* name, const char* defvalue );
DLL_EXPORT int			__stdcall GetSpringConfigInt( const char* name, const int defvalue );
DLL_EXPORT float		__stdcall GetSpringConfigFloat( const char* name, const float defvalue );
DLL_EXPORT void			__stdcall SetSpringConfigString( const char* name, const char* value );
DLL_EXPORT void			__stdcall SetSpringConfigInt( const char* name, const int value );
DLL_EXPORT void			__stdcall SetSpringConfigFloat( const char* name, const float value );
 */