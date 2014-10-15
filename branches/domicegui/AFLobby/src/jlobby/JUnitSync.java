/*
 * JUnitSync.java
 *
 * Created on 31 May 2006, 14:43
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jlobby;

import java.util.Vector;

/**
 * JUnitSync.java
 * @author AF
 */
public class JUnitSync {
    
    /** Creates a new instance of JUnitSync */
    public JUnitSync() {
    }
    // load up the UnitSync.dll/UnitSync.so library
    public boolean loaded = false;
    public void LoadUnitSync(){
        //
    }
    // for all intensive purposes any mention of void* has been replaced with
    // byte[], hwoever I have a feeling this is wrong cosnidering why they used
    // void* to begin with.
    
    // this was added ehre so that I could take the QSpring code that generates
    // the MD5 base 64 password hash, rather than use my java implementation
    // which doesnt work the way ti should.
    public static native String GetPassHash(String password);
    public static native void Message(String p_szMessage);
    public static native int Init(boolean isServer, int id);
    public static native void UnInit();
    public static native int ProcessUnits();
    public static native int ProcessUnitsNoChecksum();
    public static native String GetCurrentList();
    public static native void AddClient(int id, String unitList);
    public static native void RemoveClient(int id);
    public static native String GetClientDiff(int id);
    public static native void InstallClientDiff(String diff);
    public static native int GetUnitCount();
    public static native String GetUnitName(int unit);
    public static native String GetFullUnitName(int unit);
    public static native int IsUnitDisabled(int unit);
    public static native int IsUnitDisabledByClient(int unit, int clientId);

    //////////////////////////
    //////////////////////////

    public static native int  InitArchiveScanner();
    public static native void  AddArchive(String name);
    public static native void  AddAllArchives(String root);
    public static native int  GetArchiveChecksum(String arname);
    public static native int  GetMapCount();
    public static native String GetMapName(int index);
    public Vector<String> GetMapList(){
        Vector<String> v = new Vector<String>();
        int j = GetMapCount();
        for(int i = 0; i < j; i++){
            v.add(GetMapName(i));
        }
        return v;
    }

    class StartPos{
        int x;
        int z;
    };
    class MapInfo{
	String description;
	int tidalStrength;
	int gravity;
	float maxMetal;
	int extractorRadius;
	int minWind;
	int maxWind;

	// 0.61b1+
	int width;
	int height;
	int posCount;
    };
    public static native MapInfo GetMapInfo(String name);
    public static native StartPos[] GetSTartingPositions(String name);
/*
    #define RM	0x0000F800
    #define GM  0x000007E0
    #define BM  0x0000001F

    #define RED_RGB565(x) ((x&RM)>>11)
    #define GREEN_RGB565(x) ((x&GM)>>5)
    #define BLUE_RGB565(x) (x&BM)
    #define PACKRGB(r, g, b) (((r<<11)&RM) | ((g << 5)&GM) | (b&BM) )
*/

    public static native byte[]  GetMinimap(String filename, int miplevel);
    public static native boolean WriteMinimap(String mapname, String target);
    /* Write the minimap of the map to a jpeg at the 'target' location*/
    
    public static native int GetIntProperty(String value);
    public static native String GetStringProperty(String value);
    public static native boolean GetBooleanProperty(String value);

    public static native void SetIntProperty(int value);
    public static native void SetStringProperty(String value);
    public static native void SetBooleanProperty(boolean value);
    
    public static native String GetDatapath();
    
    public static native String GetMapHash(String mapname);
    public static native String GetModHash(String modname);

    //////////////////////////
    //////////////////////////

    public static native int  GetPrimaryModCount();
    public static native String   GetPrimaryModName(int index);
    public static native String GetPrimaryModArchive(int index);
    public Vector<String> GetModList(){
        Vector<String> v = new Vector<String>();
        int j = GetPrimaryModCount();
        for(int i = 0; i < j; i++){
            v.add(GetMapName(i));
        }
        return v;
    }

    /*
     * These two funtions are used to get the entire list of archives that a mod
     * requires. Call ..Count with selected mod first to get number of archives,
     * and then use ..List for 0 to count-1 to get the name of each archive.
     */

    public static native int  GetPrimaryModArchiveCount(int index);
    public static native String   GetPrimaryModArchiveList(int arnr);
    public static native int  GetPrimaryModIndex(String name);
    //////////////////////////
    //////////////////////////
    public static native int GetSideCount();
    public static native String GetSideName(int side);
    public Vector<String> GetSideList(){
        Vector<String> v = new Vector<String>();
        int j = GetSideCount();
        for(int i = 0; i < j; i++){
            v.add(GetSideName(i));
        }
        return v;
    }

    public static native int OpenFileVFS(String name);
    public static native void CloseFileVFS(int handle);
    public static native byte[] ReadFileVFS(int handle, int length);
    public static native int FileSizeVFS(int handle);
    
    public static native int OpenArchive(String name);
    public static native void CloseArchive(int archive);
    
    //DLL_EXPORT int __stdcall FindFilesArchive(int archive, int cur, char* nameBuf, int* size)
    public static native int OpenArchiveFile(int archive, String name);
    public static native String ReadArchiveFile(int archive, int handle, int numBytes);
    public static native void CloseArchiveFile(int archive, int handle);
    public static native int SizeArchiveFile(int archive, int handle);
    //
    
}
