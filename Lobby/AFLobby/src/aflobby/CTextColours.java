/*
 * To change this template, choose Tools | Templates | Licenses | Default License
 * and open the template in the editor.
 */

package aflobby;

import aflobby.UI.CUserSettings;
import java.awt.Color;
import java.util.HashMap;

/**
 *
 * @author tarendai
 */
public class CTextColours {
    private static boolean loaded=false;
    private static HashMap<String,Color> textcolours = new HashMap<String,Color>();
    
    public static final String[] names = {
        "action chat text","chat text", "usernames", "user joined", "user left", "channel message",
        "system message", "channel topic", "timestamps", "background"
    };

    /*
     * Use this method to initialize the values and load the text values from
     * the settings.tdf file
     */
    public static void load(){
        textcolours.clear();
        for(int i = 0; i < names.length; i++){
            String k = names[i];
            String value = CUserSettings.GetValue("textcolours."+k);
            if(value == null){
                continue;
            }
            if(value.equals("")){
                continue;
            }
            Color c = Color.decode(value);
            textcolours.put(k, c);
        }
        loaded=true;
    }
    
    /* 
     * Call this method to restore the saved settings to those stored in here
     */
    public static void restore(){
        //
    }
    
    public static String GetColor(String value, String defaultvalue){
        if(!loaded){
            load();
        }
        String s = CUserSettings.GetValue("textcolours."+value, defaultvalue);
        if(s == null){
            s = defaultvalue;
        }else if (s.trim().equals("")){
            //
            s = defaultvalue;
        }
        return s;
        //try{
            //Color c = Color.decode(s);
            //return c;
        //}catch(Exception e){
            //
        //    return Color.black;
        //}
    }
}
