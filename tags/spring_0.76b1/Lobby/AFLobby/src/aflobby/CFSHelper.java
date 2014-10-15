/*
 * CFSHelper.java
 *
 * Created on 08-Aug-2007, 19:10:51
 *
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URL;
import java.util.Scanner;

/**
 *
 * @author Tom
 */
public class CFSHelper {

    public CFSHelper() {
    }

    public static String GetFileContents(String filepath) {
        return GetFileContents(new File(filepath));
    }
    
    public static String GetFileContents(File f) {
        Scanner read_in;
        try {
            String t = "";
            read_in = new Scanner(f);
            //read_in.useDelimiter ();
            while (read_in.hasNext()) {
                t += read_in.nextLine() + System.getProperty("line.separator");
                //t += new String (read_in.next ());
            }
            read_in.close();
            return t;
        } catch (FileNotFoundException e) {
            //e.printStackTrace();
            return ""; //
        }
    }
    
    public static URL GetResourceURL(String file){
        String s = "a";
        return s.getClass().getResource(file);
        //return null;
    }
}
