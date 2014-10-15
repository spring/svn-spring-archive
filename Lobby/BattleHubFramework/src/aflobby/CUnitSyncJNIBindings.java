/*
 * CUnitSyncJNIBindings.java
 *
 * Created on 31 May 2006, 14:43
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

/**
 * CUnitSyncJNIBindings.java
 *
 *
 *
 * @author AF
 */

class OptionType {
	public static int opt_error  = 0;
	public static int opt_bool   = 1;
	public static int opt_list   = 2;
	public static int opt_number = 3;
	public static int opt_string = 4;
};

//CUnitSyncJNIBindings
public class CUnitSyncJNIBindings {

    /**
     * Creates a new instance of CUnitSyncJNIBindings
     */
    public CUnitSyncJNIBindings() {
    }

    // load up the UnitSync.dll/UnitSync.so library
    /**
     * A boolean signifying if the library is loaded. If the library is
     */
    private static boolean loaded = false;
    
    public static boolean IsLoaded(){
        return loaded;
    }

    public static void LoadUnitSync(String libpath) throws UnsatisfiedLinkError{

//        try {
            /*if (Misc.isWindows()) {
                System.loadLibrary("unitsync");
//                java.lang.Runtime.getRuntime ().load (intendedpath+System.getProperty ("file.separator")+"unitsync.dll");
            } else {*/
                //;
                System.load(libpath);
            //}

            //if(Misc.isWindows() && (!Main.dev_environment)){
            //    Misc.getURLContent("http://www.darkstars.co.uk/linkcounter.php","");
            //}
            
//            if(CContentManager.installed_engines.contains("spring")==false){
//                CContentManager.installed_engines.add("spring");
//            }
//            loaded=true;
//        } catch (final java.lang.UnsatisfiedLinkError e) {
//            if(Misc.isWindows()&& (!Misc.dev_environment)){
//                Misc.getURLContent("http://www.darkstars.co.uk/ulinkcounter.php","");
//            }
//            java.awt.EventQueue.invokeLater(new Runnable() {
//
//                @Override
//                public void run() {
//                    new WarningWindow("<font face=\"Arial\" color=\"" + ColourHelper.ColourToHex(Color.BLACK) + "\"><font size=20> Unsatisfied link error</font><br><br> Make sure you have a JNI aware UnitSync library, and that it is compiled correctly. Such a library should come as standard with spring 0.75+. If under linux, check that you've correctly edited the tags in settings.tdf to point to unitsync.so and spring.<br><br> AFlobby needs the unitsync library to be able to use spring.<br><br>Linux users need unitsync.so<br><br> Windows users need unitsync.dll<br><br> Apple Mac users need unitsync.dylib (Mac is not entirely supported and upto date mac builds of unitsync arent included due to time restrictions)<br><br><br><br>" + e.getLocalizedMessage() + "<br><br><b> path variable =</b> <i>" + System.getProperty("user.dir") + "</i><br> <b> library path = </b><i>" + System.getProperty("java.library.path") +"<br><br><br>"+e.toString()+ "</i></font>", "JNI Error").setVisible(true);
//                }
//            });
//            e.printStackTrace();
//            loaded=false;
//        } /*catch (Exception e){
        //            java.awt.EventQueue.invokeLater (new Runnable () {
        //                public void run () {
        //                    new WarningWindow ("<font face=\"Arial\" color=\""+ColourHelper.ColourToHex (Color.WHITE)+"\"><font size=20>UnitSync Exception error</font><br><br> Make sure you have a JNI aware UnitSync library in the same folder as AFLobby, and that it is compiled correctly using the latest java bindings.<br><br> AFlobby needs the unitsync library to be able to use spring.<br><br>Linux users need libjavaunitsync.so<br><br> Windows users need javaunitsync.dll<br><br> Apple Mac users need libjavaunitsync.dylib (Mac is not entirely supported and upto date mac builds of unitsync arent included due to time restrictions)<br><br><br><br><b> path variable =</b> <i>"+ System.getProperty ("user.dir")+"</i><br> <b> library path = </b><i>"+System.getProperty("java.library.path")+"</i></font>",
        //                        "UnitSync Error"
        //                        ).setVisible (true);
        //                }
        //            });
        //        }*/
        //return loaded;
    }


    public static native String     GetSpringVersion        ();

    public static native void       Message                 (String p_szMessage);

    public static native int        Init                    (boolean isServer, int id);
    public static native void       UnInit                  ();

    public static native int        ProcessUnits            ();
    public static native int        ProcessUnitsNoChecksum  ();

    public static native String     GetCurrentList          ();

    public static native void       AddClient               (int id, String unitList);
    public static native void       RemoveClient            (int id);

    public static native String     GetClientDiff           (int id);
    public static native void       InstallClientDiff       (String diff);

    public static native int        GetUnitCount            ();
    public static native String     GetUnitName             (int unit);
    public static native String     GetFullUnitName         (int unit);
    public static native int        IsUnitDisabled          (int unit);
    public static native int        IsUnitDisabledByClient  (int unit, int clientId);


    public static native void       AddArchive              (String name);
    public static native void       AddAllArchives          (String root);

    public static native String     GetArchiveChecksum      (String arname); //unsigned integer

    public static native int        GetMapCount             ();
    public static native String     GetMapName              (int index);

    //public static native String     GetMapInfo(String name);

    //public static native void*    GetMinimap(String filename, int miplevel);
    
    public static native int        GetMapArchiveCount      (String mapName);
    public static native String     GetMapArchiveName       (int index);
    public static native String     GetMapChecksum          (int index); // unsigned

    public static native int        GetPrimaryModCount      ();

    public static native String     GetPrimaryModName       (int index);
    public static native String     GetPrimaryModArchive    (int index);
    public static native int        GetPrimaryModArchiveCount(int index);
    public static native String     GetPrimaryModArchiveList(int arnr);

    public static native int        GetPrimaryModIndex      (String name);

    public static native String     GetPrimaryModChecksum   (int index); //unsigned
    public static native String     GetPrimaryModChecksumFromName(String name);
    
    public static native String     GetPrimaryModDescription(int index);
    public static native String     GetPrimaryModMutator    (int index);
    public static native String     GetPrimaryModVersion    (int index);
    public static native String     GetPrimaryModShortGame  (int index);
    public static native String     GetPrimaryModGame       (int index);
    public static native String     GetPrimaryModShortName  (int index);

    public static native int        GetSideCount            ();
    public static native String     GetSideName             (int side);


    public static native int        OpenFileVFS             (String name);
    public static native void       CloseFileVFS            (int handle);
    public static native String     ReadFileVFS             (int handle);
    public static native int        FileSizeVFS             (int handle);

    public static native int        InitFindVFS             ();
    public static native String     SearchVFS               (String pattern);
    
    public static native int        OpenArchive             (String name);
    public static native void       CloseArchive            (int archive);
    public static native int        FindFilesArchive        (int archive, int cur, String nameBuf, int size);

    public static native int        OpenArchiveFile         (int archive, String name);
    public static native String     ReadArchiveFile         (int archive, int handle);
    public static native void       CloseArchiveFile        (int archive, int handle);
    public static native int        SizeArchiveFile         (int archive, int handle);

    public static native String     GetDataDirs             (boolean write);

    public static native boolean    WriteMiniMap            (String mapfile, String imagename, int miplevel);
    
    // 0.76b1+ additions
    
    public static native String     GetMapInfo();
    
    
    // Spring settings and configuration options
    
    public static native void       SetSpringConfigFloat    (String name, float value);
    public static native void       SetSpringConfigInt      (String name, int value);
    public static native void       SetSpringConfigString   (String name, String value);
    
    public static native float      GetSpringConfigFloat    (String name, float defvalue);
    public static native int        GetSpringConfigInt      (String name, int defvalue);
    public static native String     GetSpringConfigString   (String name, String defvalue);
    
    
    // lua custom lobby settings
    
    public static native int        GetMapOptionCount       (String mapName);
    public static native int        GetModOptionCount       ();
    
    public static native String     GetOptionKey            (int optIndex);
    public static native String     GetOptionName           (int optIndex);
    public static native String     GetOptionDesc           (int optIndex);
    public static native int        GetOptionType           (int optIndex);
    
    
    // boolean options
    
    public static native int        GetOptionBoolDef        (int optIndex);
    
    
    // Number Options
    public static native float      GetOptionNumberDef      (int optIndex);
    public static native float      GetOptionNumberMin      (int optIndex);
    public static native float      GetOptionNumberMax      (int optIndex);
    public static native float      GetOptionNumberStep     (int optIndex);
    
    // String options
    public static native String     GetOptionStringDef      (int optIndex);
    public static native int        GetOptionStringMaxLen   (int optIndex);
    
    // List options
    public static native int        GetOptionListCount      (int optIndex);
    public static native String     GetOptionListDef        (int optIndex);
    public static native String     GetOptionListItemKey    (int optIndex, int itemIndex);
    public static native String     GetOptionListItemName   (int optIndex, int itemIndex);
    public static native String     GetOptionListItemDesc   (int optIndex, int itemIndex);
    
    
}
