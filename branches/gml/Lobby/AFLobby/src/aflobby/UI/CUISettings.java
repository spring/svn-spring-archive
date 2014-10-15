/*
 * CUISettings.java
 *
 * Created on 10 March 2007, 21:16
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby.UI;

import aflobby.*;
import java.awt.Font;
import java.awt.Image;
import java.io.File;
import java.net.MalformedURLException;

/**
 *
 * @author Tom
 */
public class CUISettings {
    
    /**
     * Creates a new instance of CUISettings
     */
    public CUISettings () {
    }
    
    
    public java.util.ResourceBundle GetLanguage(){
        return java.util.ResourceBundle.getBundle("aflobby/languages");
    }
    public static Font GetFont (){
        //
        return new Font ( "SansSerif", Font.PLAIN, 12 );
        //return null;
    }
    
    public static Font GetFont (int size){
        return new Font ( "SansSerif", Font.PLAIN, size );
        //return null;
    }
    
    public static Font GetFont (int size, boolean bold){
        if( bold){
            return new Font ( "SansSerif", Font.BOLD, size );
        }else{
            return new Font ( "SansSerif", Font.PLAIN, size );
        }
        //return null;
    }
    
    public static Image GetWindowIcon(){
        Image i = null;
        try {
            File f = new File(Misc.GetAbsoluteLobbyFolderPath() + "images/UI/icon.png");
            i = new javax.swing.ImageIcon (f.toURI().toURL()).getImage ();
        } catch (MalformedURLException ex) {
            ex.printStackTrace();
        }
        return i;
    }
    
}
