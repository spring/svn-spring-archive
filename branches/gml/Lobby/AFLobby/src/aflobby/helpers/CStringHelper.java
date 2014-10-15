/*
 * To change this template, choose Tools | Templates | Licenses | Default License
 * and open the template in the editor.
 */

package aflobby.helpers;

import aflobby.CTextColours;
import aflobby.Misc;
import aflobby.UI.CUserSettings;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author tarendai
 */
public class CStringHelper {
    
    public static String getTimestamp(){
        return "[" + Misc.easyDateFormat("hh:mm:ss") + "] ";
    }
    
    public static String getHTMLTimestamp(){
        return "<font face=\"Arial, Helvetica, sans-serif\" size=\"3\" color=\"" + CTextColours.GetColor("timestamps", "#aaaaaa") + "\">" + getTimestamp() + "</font>";
    }
    
    public static String getUserChat(String user){
        if(CUserSettings.GetValue("ui.chat.says","true").equalsIgnoreCase("true")){
            return user +" "+java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow._says:");
        }else{
            return user+" ";
            
        }
        //
    }
    
    public static String getUserChatHTML(String user){
        String c = CTextColours.GetColor("usernames", "#000000");
        return "<font face=\"Arial, Helvetica, sans-serif\" size=\"3\" color=\""+c +"\"><b><i>"+getUserChat(user)+"</i></b></font>";
    }
    
    public static String getChatHTML(String message, boolean action){
        String c = " color=\"";
        if(action){
            c += CTextColours.GetColor("action chat text", "#ffffff");
        } else {
            c += CTextColours.GetColor("chat text", "#000000");
        }
        c += "\"";
        String m = "<font face=\"Arial, Helvetica, sans-serif\" size=\"3\" "+c+" >" +Misc.toHTML(message)+"</font>";
        if(action){
            m = "<b>"+m + "</b>";
        }
        return m;
    }

    public static String getSHA1Hash(String password){
        try {
            return new String(CBase64Coder.encode(getHash(password)));
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(CStringHelper.class.getName()).log(Level.SEVERE, null, ex);
        }
        return "";
    }

    public static byte[] getHash(String password) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-1");
        digest.reset();
        byte[] input = digest.digest(password.getBytes());
        return input;
    }


}
