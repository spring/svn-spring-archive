/*
 * CUpdateChecker.java
 *
 * Created on 12 February 2007, 01:19
 *
 */

package aflobby;

import aflobby.UI.WarningWindow;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.SwingUtilities;

/**
 *
 * @author Tom
 */
public class CUpdateChecker extends Thread{
    public static String AFLobbyVersion = "Beta 4.3 wip";
    
    /**
     * The numerical version number of aflobby
     */
    public static int AFLVNumber = 56;
    
    /**
     * An enum describing the current status of this version of AFLobby and
     * how upto date it is. Used to determine whether this AFLobby is
     * experimental, out of date, or current
     */
    public enum versionStatus {
        uptodate,
        outofdate,
        unknown,
        experimental
    }
    
    private static versionStatus uptodate = versionStatus.unknown;
    
    public static versionStatus IsUpToDate(){
        return uptodate;
    }
    
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

        final ImageIcon i;
        
        String t = "";
        if(s.equalsIgnoreCase ("cuckoo")){
            t = "Unable to perform update check, darkstars.co.uk may be down";
            i = null;
            uptodate = versionStatus.unknown;
        }else{
            //String tc = String.valueOf ((char)127);
            String[] lines = s.split ("@@");
            
            int v = Integer.parseInt (lines[0]);
            
            if(AFLVNumber < v){
                uptodate = versionStatus.outofdate;
                i = new ImageIcon (getClass ().getResource ("/images/UI/alert.png"));
                
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
                i = null;
                t = "Goodness Gracious That versions unreleased!";
                uptodate = versionStatus.experimental;
            } else {
                i = null;
                t = "Your copy of AFLobby is upto date";
                uptodate = versionStatus.uptodate;
            }
        }
        
        final String t2 = t;
        
        
        Runnable doWorkRunnable = new Runnable () {
            public void run () {
                label.setText (t2);
                label.setIcon (i);
            }
        };
        SwingUtilities.invokeLater (doWorkRunnable);
    }
    
}
