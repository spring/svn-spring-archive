/*
 * CUpdateChecker.java
 *
 * Created on 12 February 2007, 01:19
 *
 */

package aflobby;

import aflobby.UI.WarningWindow;
import javax.swing.JLabel;
import javax.swing.SwingUtilities;

/**
 *
 * @author Tom
 */
public class CUpdateChecker extends Thread{
    public static String AFLobbyVersion = "Beta 3.9.9";
    
    /**
     * The numerical version number of aflobby
     */
    public static int AFLVNumber = 49;
    
    JLabel label;
    
    /**
     * Creates a new instance of CUpdateChecker
     * @param l 
     */
    public CUpdateChecker (JLabel l) {
        label = l;
    }
    
    @Override
    public void run () {
        String s = Misc.getURLContent ("http://tarendai.googlepages.com/AFLVersion.txt","cuckoo");

        String t = "";
        if(s.equalsIgnoreCase ("cuckoo")){
            t = "Unable to perform update check, darkstars.co.uk may be down";
        }else{
            //String tc = String.valueOf ((char)127);
            String[] lines = s.split ("@@");
            
            int v = Integer.parseInt (lines[0]);
            
            if(AFLVNumber < v){
                
                t = "A new version of aflobby is available:  "+lines[1];
                final String wt = Misc.makeSentence (lines,2);
                final String wttitle = "Update Available " + lines[1];
                javax.swing.SwingUtilities.invokeLater (new Runnable () {
                    public void run () {
                        new WarningWindow (wt,
                            wttitle
                            ).setVisible (true);
                    }
                });

            } else if (v < AFLVNumber){
                t = "Goodness Gracious That versions unreleased!";
            } else {
                t = "Your copy of AFLobby is upto date";
            }
        }
        final String t2 = t;
        Runnable doWorkRunnable = new Runnable () {
            public void run () {
                label.setText (t2);
                if(t2.startsWith ("A new version of aflobby is available:")){
                    label.setIcon (new javax.swing.ImageIcon (getClass ().getResource ("/images/UI/alert.png")));//.getImage (
                }
            }
        };
        SwingUtilities.invokeLater (doWorkRunnable);
    }
    
}
