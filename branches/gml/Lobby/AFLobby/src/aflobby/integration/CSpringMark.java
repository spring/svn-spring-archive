/*
 * CSpringMark.java
 * 
 * Created on 16-Sep-2007, 09:43:19
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby.integration;

import aflobby.*;
import java.util.ArrayList;
import java.util.TreeMap;

/**
 * On may use this class under the LGPL as long as they do not implement
 * discriminatory or elitist features with it to penalize people with lower
 * performance. This is for informative purposes only.
 * @author AF-StandardUsr
 */
public class CSpringMark {
    private static TreeMap<String,String> ram = new TreeMap<String,String>();
    private static TreeMap<String,String> cpumodel = new TreeMap<String,String>();
    private static TreeMap<String,String> springmark = new TreeMap<String,String>();
    private static ArrayList<String> nodata = new ArrayList<String>();
    
    public static void GetData(String username){
        if(username == null){
            return;
        }
        String s = Misc.getURLContent("http://www.jobjol.com/lobby.php?players[0]="+username, "");
        if(s == null){
            nodata.add(username);
            return;
        }
        if(s.contains("Geen resultaten gevonden")){
            nodata.add(username);
            return;
        }
        String[] params = s.replaceAll("<BR>", "").split(" ");
        ram.put(username.toLowerCase(), params[3]);
        cpumodel.put(username.toLowerCase(), Misc.makeSentence(params, 6));
        springmark.put(username.toLowerCase(), params[1]);
    }
    
    public static String GetRAM(String user){
        if(user == null){
            return "n/a";
        }
        if(nodata.contains(user.toLowerCase())==true){
            return "n/a";
        }
        String r = ram.get(user.toLowerCase());
        if(r != null){
            return r;
        }else{
            GetData(user);
            return GetRAM(r);
        }
    }
    
    public static String GetCPUModel(String user){
        if(user == null){
            return "n/a";
        }
        if(nodata.contains(user.toLowerCase())==true){
            return "n/a";
        }
        String r = cpumodel.get(user.toLowerCase());
        if(r != null){
            return r;
        }else{
            GetData(user);
            return GetCPUModel(r);
        }
    }
    
    public static String GetSpringMark(String user){
        if(user == null){
            return "n/a";
        }
        if(nodata.contains(user.toLowerCase())==true){
            return "n/a";
        }
        String r = springmark.get(user.toLowerCase());
        if(r != null){
            return r;
        }else{
            GetData(user);
            return GetSpringMark(r);
        }
    }
}
