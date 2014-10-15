//  Bare Bones Browser Launch                          //
//  Version 1.5                                        //
//  December 10, 2005                                  //
//  Supports: Mac OS X, GNU/Linux, Unix, Windows XP    //
//  Example Usage:                                     //
//     String url = "http://www.centerkey.com/";       //
//     BareBonesBrowserLaunch.openURL(url);            //
//  Public Domain Software -- Free to Use as You Like  //
/////////////////////////////////////////////////////////
// numerous functiosn ahve been rplaced or modified with replacement versions for windows from:
package org.darkstars.battlehub.framework;

import java.net.URI;
import javax.swing.JOptionPane;

public class BrowserLauncher {

    private static final String errMsg = java.util.ResourceBundle.getBundle("org.darkstars.battlehub.languages").getString("BrowserLauncher.Error_attempting_to_launch_web_browser");

    public static void openURL(String url) {
        java.awt.Desktop desktop = java.awt.Desktop.getDesktop();
        if (desktop.isSupported(java.awt.Desktop.Action.BROWSE)) {
            URI uri = null;
            try {
                uri = new URI(url);
                desktop.browse(uri);
            }
            catch(Exception e) {
                JOptionPane.showMessageDialog(null, errMsg + ":\n" + e.getLocalizedMessage());
            }
        }
        
        /*String osName = System.getProperty("os.name");
        try {
            if (osName.startsWith("Mac OS")) {
                Class fileMgr = Class.forName("com.apple.eio.FileManager");
                @SuppressWarnings(value = "unchecked")
                Method openURL = fileMgr.getDeclaredMethod("openURL", new Class[]{String.class});
                openURL.invoke(null, new Object[]{url});
            } else if (osName.startsWith("Windows")) {
                Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + url);
            } else {
                //assume Unix or Linux
                String[] browsers = {"opera", "firefox", "konqueror", "epiphany", "mozilla", "netscape"};
                String browser = null;
                for (int count = 0; count < browsers.length && browser == null; count++) {
                    if (Runtime.getRuntime().exec(new String[]{"which", browsers[count]}).waitFor() == 0) {
                        browser = browsers[count];
                    }
                }
                if (browser == null) {
                    throw new Exception(java.util.ResourceBundle.getBundle("org.darkstars.battlehub.languages").getString("BrowserLauncher.Could_not_find_web_browser"));
                } else {
                    Runtime.getRuntime().exec(new String[]{browser, url});
                }
            }
        } catch (Exception e) {
            
        }*/
    }
}
