/*
 * CSync.java
 *
 * Created on 19 September 2006, 20:56
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;


/**
 *
 * @author AF
 */
public class CSync {
    
    /**
     * Creates a new instance of CSync
     */
    public CSync () {
    }
    public static HashMap<Integer,String> map_hash = new HashMap<Integer,String>();
    public static HashMap<String,String> map_hash_name = new HashMap<String,String>();
    public static HashMap<Integer,String> map_names = new HashMap<Integer,String>();
    
    public static HashMap<Integer,String> mod_archives = new HashMap<Integer,String>();
    public static HashMap<Integer,String> mod_names = new HashMap<Integer,String>();
    public static HashMap<Integer,String> mod_hash = new HashMap<Integer,String>();
    public static HashMap<String,String> mod_hash_name = new HashMap<String,String>();
    public static HashMap<String,String> mod_name_archive = new HashMap<String,String>();
    
    public static int modcount;
    public static int mapcount;
    
    public static boolean setup = false;
    
    public static LMain LM = null;
    
    public static boolean Setup (LMain L){
        LM = L;
        /*map_hash.clear ();
        map_hash_name.clear ();
        map_names.clear ();

        mod_archives.clear ();
        mod_names.clear ();
        mod_hash.clear ();
        mod_hash_name.clear ();
        mod_name_archive.clear ();*/
        //System.out.println ("JSync Setup");
//        j.ProgressMessage.setText("Loading unitsync library");
        
        if(setup){
            CEvent e = new CEvent (CEvent.LOGINPROGRESS+ " 10 Refreshing unitsync hashes");
            LM.core.NewGUIEvent (e);
            RefreshUnitSync ();
            System.gc (); // for good measure;
            return true;
        }else{
            CEvent e = new CEvent (CEvent.LOGINPROGRESS+ " 10 Loading Unitsync");
            LM.core.NewGUIEvent (e);
        }
        
        if(!CUnitSyncJNIBindings.LoadUnitSync ("")){
            return false;
        }
        RefreshUnitSync();

        setup = true;
        return true;
    }
    
    public static void RefreshUnitSync (){
        
        //CUnitSyncJNIBindings.AddAllArchives("");
        map_hash.clear ();
        map_hash_name.clear ();
        map_names.clear ();

        mod_archives.clear ();
        mod_names.clear ();
        mod_hash.clear ();
        mod_hash_name.clear ();
        mod_name_archive.clear ();
        CUnitSyncJNIBindings.Init (true,0);
        ////////
        
        //CUnitSyncJNIBindings.AddAllArchives("");
        modcount = CUnitSyncJNIBindings.GetPrimaryModCount ();
        //System.out.println("modcount = "+ modcount);
        double r = 20.0f/(double)modcount;
        for(int i = 0; i < modcount; i++){
            int  k = 10+(int)(i*r);
            
            String mx = CUnitSyncJNIBindings.GetPrimaryModArchive (i);

            mod_archives.put (i,mx);
            //
            String m = CUnitSyncJNIBindings.GetPrimaryModName (i);
            mod_names.put (i,m);
            mod_name_archive.put(m, mx);
            
            //System.out.println();
            String c = CUnitSyncJNIBindings.GetPrimaryModChecksum (i);
            mod_hash.put (i,c);
            mod_hash_name.put (m,c);
        }
//        j.ProgressMessage.setText("handling maps");
        mapcount = CUnitSyncJNIBindings.GetMapCount ();
        //System.out.println("mapcount = "+ mapcount);
        r = 40.0f/(double)mapcount;
        //System.out.println ("r = "+r);
        for(int i = 0; i < mapcount; i++){
            //System.out.println(i);
            int k = 30+(int)(i*r);
            //System.out.println (k);
            
            String m = CUnitSyncJNIBindings.GetMapName (i);
            if(m.startsWith ("maps\\")){
                m = m.substring (5);//replaceAll ("maps\\","");
            }
//            j.ProgressMessage.setText("hashing "+m +" ("+i+" of "+mapcount+")");
            map_names.put (i,m);
            //System.out.println(i + " :  map = "+m);
            String c = CUnitSyncJNIBindings.GetMapChecksum (i);
            map_hash.put (i,c);
            map_hash_name.put (m,c);
            
            String msf = Misc.GetMinimapPath ()+m.toLowerCase ()+".jpg";
            File f = new File (msf);
            if(!f.exists ()){
                CUnitSyncJNIBindings.WriteMiniMap (m,msf,1);// a mipmap of 2 is a 256x256 image
            }
        }
        
        //////////
    
    
        modcount = CUnitSyncJNIBindings.GetPrimaryModCount ();
        //System.out.println("modcount = "+ modcount);
        for(int i = 0; i < modcount; i++){
            String mx = CUnitSyncJNIBindings.GetPrimaryModArchive (i);
            mod_archives.put (i,mx);
            //System.out.println("modarchive = "+ mx);
            String m = CUnitSyncJNIBindings.GetPrimaryModName (i);
            mod_names.put (i,m);
            
            //System.out.println("modname = "+ m);
            String c = CUnitSyncJNIBindings.GetPrimaryModChecksum (i);
            mod_hash.put (i,c);
            mod_hash_name.put (m,c);
        }
        mapcount = CUnitSyncJNIBindings.GetMapCount ();
        
        //System.out.println("mapcount = "+ mapcount);
        for(int i = 0; i < mapcount; i++){
            //System.out.println(i);
            
            String m = CUnitSyncJNIBindings.GetMapName (i);
            if(m.startsWith ("maps\\")){
                m = m.substring (5);//replaceAll ("maps\\","");
            }
            map_names.put (i,m);
            //System.out.println(i + " :  map = "+m);
            String c = CUnitSyncJNIBindings.GetMapChecksum (i);
            map_hash.put (i,c);
            map_hash_name.put (m,c);
            
            String msf = Misc.GetMinimapPath ()+m.toLowerCase ()+".jpg";
            File f = new File (msf);
            if(!f.exists ()){
                CUnitSyncJNIBindings.WriteMiniMap (m,msf,1);// a mipmap of 2 is a 256x256 image
            }
        }
        CEvent e = new CEvent (CEvent.CONTENTREFRESH);
        LM.core.NewGUIEvent (e);
    }
    
    public static boolean IsReady (){
        return true;
    }
    
    public static boolean HasMap (String mapname){
        return true;
    }
    
    public static boolean HasMod (String modname){
        return mod_names.values ().contains (modname);// true;
    }
    
    public static String current_workingmod = "";
    
    public static boolean SetWorkingMod (String modname){
        //CUnitSyncJNIBindings.
        if(HasMod (modname)==false){
            return false;
        }
        
        
        int mod_index = CUnitSyncJNIBindings.GetPrimaryModIndex (modname);
        String archive = CUnitSyncJNIBindings.GetPrimaryModArchive (mod_index);
        
        if(archive.equals(current_workingmod)){
            return true;
        }else{
            CUnitSyncJNIBindings.Init(true, 0);
            mod_index = CUnitSyncJNIBindings.GetPrimaryModIndex (modname);
            archive = CUnitSyncJNIBindings.GetPrimaryModArchive (mod_index);
        }
        
        CUnitSyncJNIBindings.AddAllArchives (archive);
        
        
        //System.out.println ("units: " + unitcount);
        
        
        while(CUnitSyncJNIBindings.ProcessUnits ()>0){}
        
        units.clear ();
        
        unitcount = CUnitSyncJNIBindings.GetUnitCount ();
        
        for(int i = 0; i < unitcount; i++){
//            int i = CUnitSyncJNIBindings.GetUnitCount ();
            String s = CUnitSyncJNIBindings.GetUnitName (i);//+" - "+CUnitSyncJNIBindings.GetFullUnitName (i);
            //System.out.println(s);
            units.add (s);
        }
        
        //String q = CUnitSyncJNIBindings.GetCurrentList ();
        //System.out.print (q);
        /*for(int i = 0; i < unitcount; i++){
            CUnitSyncJNIBindings.ProcessUnits ();
         
        }*/
        
        //System.out.println("n# of sides: "+sidecount);
        sides.clear ();
        sidecount = CUnitSyncJNIBindings.GetSideCount();
        for(int i = 0; i<sidecount; i++){
            String sname = CUnitSyncJNIBindings.GetSideName (i);
            //System.out.println("side "+i+" : "+ sname);
            sides.put (i,sname);
        }
        return true;
    }
    public static int unitcount = 0;
    public static int sidecount=0;
    public static HashMap<Integer,String> sides = new HashMap<Integer,String>();
    public static ArrayList<String> units = new ArrayList<String>();
    public static int GetSideCount (){
        return sidecount;
    }
    
    public static String GetSideName (int side){
        return sides.get (side);
        /*if(side == 1){
            return "Arm";
        }else{
            return "Core";
        }*/
    }
    
    /*public static Process StartSpring(String command){
        try {
            return Runtime.getRuntime().exec(command);
        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
     
    }*/
    
    public static String GetMapHash (String map){
        //int map_index = CUnitSyncJNIBindings.getmGetPrimaryModIndex(modname);
        //String archive = CUnitSyncJNIBindings.GetPrimaryModArchive(mod_index);
        String h = map_hash_name.get (map);
        if(h == null){
            h = "0";
        }
        return h;
    }
    
    public static String GetModHash (String mod){
        //int map_index = CUnitSyncJNIBindings.getmGetPrimaryModIndex(modname);
        //String archive = CUnitSyncJNIBindings.GetPrimaryModArchive(mod_index);
        //return this.modmap_hash_name.get(map);
        //return "";
        int mod_index = CUnitSyncJNIBindings.GetPrimaryModIndex (mod);
        return mod_hash.get (mod_index);
    }
    
    public static String GetModHashbyName (String modname){
        //int map_index = CUnitSyncJNIBindings.getmGetPrimaryModIndex(modname);
        //String archive = CUnitSyncJNIBindings.GetPrimaryModArchive(mod_index);
        //return this.modmap_hash_name.get(map);
        //return "";
        return mod_hash_name.get (modname);
    }
    
    public static ArrayList<String> GetUnitList (){
        return units;
    }
    
    /*public static Vector<String> loadFromArchive(String archive,String file) {
        Vector<String> v;
     
        if(archive.toLowerCase().endsWith(".sd7")) {
            try {
                Process p=Runtime.getRuntime().exec(new String[]{"7za","e","-i!"+file,"-so",archive});
                BufferedReader dis=new BufferedReader(new InputStreamReader(p.getInputStream()));
                String lr="";
                v=new Vector<String>();
     
                while (true) {
                    lr=dis.readLine();
     
                    if(lr==null)
                        break;
     
                    v.add(lr);
                }
     
                p.waitFor();
     
            } catch(IOException e) {
                return null;
            } catch(InterruptedException e) {
                return null;
            }
     
            return v;
        } else
            if(archive.toLowerCase().endsWith(".sdz")) {
            try {
                ZipFile zf=new ZipFile(archive);
                ZipEntry ze=zf.getEntry(file.replace('\\','/'));
     
                if(ze==null)
                    return null;
     
                BufferedReader dis=new BufferedReader(new InputStreamReader(zf.getInputStream(ze)));
                String lr="";
                v=new Vector<String>();
     
                while (true) {
                    lr=dis.readLine();
     
                    if(lr==null)
                        break;
     
                    v.add(lr);
                }
     
                zf.close();
            }catch(IOException e){
                return null;
            }
            return v;
            }
        return null;
    }*/
}
