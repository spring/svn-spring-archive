/*
 * CSmileyManager.java
 *
 * Created on 29-Sep-2007, 13:03:45
 *
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby.UI;

import aflobby.*;
import java.awt.Image;
import java.io.File;
import javax.swing.ImageIcon;

/**
 *
 * @author AF-StandardUsr
 */
public class CSmileyManager {

    public static Integer[] intArray = null;
    public static ImageIcon[] smiley_images = null;
    public static ImageIcon[] small_smiley_images = null;
    public static String[] smileys = null;
    public static boolean loaded = false;

    public static void Init() {

        if (smileys == null) {
            File f = new File(Misc.GetAbsoluteLobbyFolderPath() + "images/smileys/");
            File[] contents = f.listFiles();
            smileys = new String[contents.length];
            //synchronized(smileys){
            for (int i = 0; i < contents.length; i++) {
                String c = contents[i].getName();
                smileys[i] = c.substring(0, c.length() - 4);
            }
            //}
            //java.io.Folder f;// = =FolderMisc.GetLobbyFolderPath ()+"/images/smileys/";
            //
        }

        if (smiley_images == null) {
            smiley_images = new ImageIcon[smileys.length];
            small_smiley_images = new ImageIcon[smileys.length];
            for (int i = 0; i < smileys.length; i++) {
                smiley_images[i] = new ImageIcon(Misc.GetAbsoluteLobbyFolderPath() + "images/smileys/" + smileys[i] + ".gif");
                small_smiley_images[i] = new ImageIcon(smiley_images[i].getImage().getScaledInstance(18, 18, Image.SCALE_REPLICATE));
                if (smiley_images[i] != null) {
                    smiley_images[i].setDescription(smileys[i]);
                }
            }
        }
        if (intArray == null) {
            intArray = new Integer[smileys.length];
            for (int i = 0; i < smileys.length; i++) {
                intArray[i] = new Integer(i);
            }
        }
        loaded = true;
    }
    
    static int SmileyCount(){
        return smileys.length;
    }
}