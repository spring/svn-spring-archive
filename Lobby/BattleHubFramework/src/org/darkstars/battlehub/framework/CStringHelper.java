/*
 * To change this template, choose Tools | Templates | Licenses | Default License
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;


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
