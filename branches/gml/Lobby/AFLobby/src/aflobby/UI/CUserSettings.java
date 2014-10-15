/*
 * CUserSettings.java
 *
 * Created on 31 May 2007, 01:46
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby.UI;

import aflobby.helpers.CFSHelper;
import aflobby.Misc;
import aflobby.helpers.TdfParser;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeMap;

/**
 *
 * @author Tom
 */
public class CUserSettings {
    
    /** Creates a new instance of CUserSettings 
     */
    public CUserSettings () {
    }
    
    public static  String GetStartScript (){
        //
        String s;

        s =  Misc.GetAbsoluteLobbyFolderPath()+"startupscript.txt";

        return CFSHelper.GetFileContents(s);
        /*Scanner read_in;
        try {
            String t = "";
            read_in = new Scanner (new File (s));
            //read_in.useDelimiter ();
            while(read_in.hasNext ()){
                t += read_in.nextLine ()+"\n";
                //t += new String (read_in.next ());
            }
            read_in.close ();
            return t;
        } catch (FileNotFoundException e) {
            return "";//e.printStackTrace ();
        }*/
        //return "";
    }
    
    public static  void SaveStartScript (String script){
        String s =  Misc.GetAbsoluteLobbyFolderPath()+"startupscript.txt";
        
        PrintStream write_out;
        try {
            // Create new file
            write_out = new PrintStream (new File (s));
            write_out.print (script);//.replaceAll("\n", System.getProperty ("line.separator")));
            write_out.close ();
        } catch (FileNotFoundException e) {
            e.printStackTrace ();
        }
    }
    private static TreeMap<String,String> values = new TreeMap<String,String>();
    
    public static String GetValue (String key){
        String k = CorrectKey(key);
        if(values.isEmpty ()){
            Load ();
        }
        if(values.containsKey (k)){
            return values.get (k);
        }else{
            return "";
        }
    }
    public static String GetValue (String key,String Default){
        //
        String k = CorrectKey(key);
        if(values.isEmpty ()){
            Load ();
        }
        if(values.containsKey (k)){
            return values.get (k);
        }else{
            PutValue(k,Default);
            return Default;
        }
    }
    
    public static void PutValue (String key, String value){
        String k = CorrectKey(key);
        values.put (k,value);
        Save ();
    }
    
    /*
     * Sometimes a provided key will contain spaces semi colons and other
     * characters that violate the TDF format.
     * 
     * This method removes the offending characters and replaces them with
     * valid ones.
     */
    public static String CorrectKey(String key){
        String r = key.replaceAll(" ", "-");
        r = r.replaceAll("=", "-");
        r = r.replaceAll(";", "-");
        //r = r.replaceAll("{", "-");
        //r = r.replaceAll("}", "-");
        //r = r.replaceAll("[", "-");
        //r = r.replaceAll("]", "-");
        return r.toLowerCase();//
    }
    
    public static void Load (){
        String f = Misc.GetAbsoluteLobbyFolderPath()+"/settings.tdf";
        String s = CFSHelper.GetFileContents(f);
        
        TdfParser t = new TdfParser (s);
        //System.out.println("values:"+t.RootSection.Values.size ());
        //TdfParser.Section sec = t.RootSection.SubSection ("mainsettings");
        for(String q : t.RootSection.Values.keySet()){
            String v = t.RootSection.Values.get(q);
            PutValue(q.toLowerCase(), v);
        }
        //values = t/*sec*/.RootSection.Values;
    }
    
    public static void Save (){
        //
        String s = "";// = "[mainsettings]{\n";
        Set<String> keys = values.keySet ();
        Iterator<String> i = keys.iterator ();
        while(i.hasNext ()){
            String k = i.next ();
            String v = values.get (k);
            s+= "\t"+k+"="+v+";"+System.getProperty ("line.separator");
        }
        //s += "}";
        
        String f = Misc.GetAbsoluteLobbyFolderPath()+"/settings.tdf";
        
        PrintStream write_out;
        try {
            // Create new file
            write_out = new PrintStream (new File (f));
            write_out.print (s);
            write_out.close ();
        } catch (FileNotFoundException e) {
            e.printStackTrace ();
        }
    }
    
}