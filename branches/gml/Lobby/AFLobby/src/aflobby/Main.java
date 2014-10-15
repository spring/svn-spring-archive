/*
 * Main.java
 *
 * Created on 22 May 2006, 18:43
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import aflobby.UI.CUserSettings;
import aflobby.UI.WarningWindow;
import aflobby.helpers.BrowserLauncher;
import java.awt.Color;
import java.awt.Toolkit;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import org.jvnet.substance.SubstanceLookAndFeel;

/**
 *
 * @author AF
 */

public class Main {
    
    /**
     * A rference to the LMain core class of AFLobby.
     */
    public  LMain L;
    
   
    /**
     * A flag storing wether the user used the 'netbeans' command line
     * parameter. See Main() for more information.
     */
    public static boolean dev_environment = false;
    
    /**
     * A flag storing wethr the user used the 'chat' command line parameter. See
     * Main() for more information.
     */
    public static boolean chat_only_mode = false;
    
    public static boolean ignorespringversion = true;
    
    public static boolean ignoreautologin = false;
    
    /**
     * Creates the lobby GUI after performing compatability checks. If the
     * current runtime environment is incompatible with aflobby action is taken
     * and AFLobby either warns the user or shutsdown.
     * 
     * Should AFLobby find tis unable to continue it should open a webpage in
     * the system browser explainign the issues involved or output an error to
     * the command line. Command line error messages are not preferable however
     * as when running in window mode via javaw.exe udnr windows or using the
     * UI, these error emssages are not shown to the user giving no clue to the
     * user as to what happened, whereas a web browser can give detailed
     * information and be updated regularly.
     */
    public static void CreateGUI (){
        
        // Check for GCJ, GCJ is unsupported and is incompatible with AFLobby UI code.
        if(System.getProperty("java.vm.name").toLowerCase().contains("libgcj")){
            System.out.println("GCJ found, AFLobby is only for Sun Java 6 or later. GCJ is not official java and as such is not supported");
            System.out.println("Opening http://spring.clan-sy.com/phpbb/viewtopic.php?p=216831#216831");
            BrowserLauncher.openURL("http://spring.clan-sy.com/phpbb/viewtopic.php?p=216831#216831");
            return;
        }
        if(Misc.isJava6 ()==false){
            System.out.println("You must be running Sun Java 6 or later! If you're running Java 7 please send me (AF) a private message to update the next few lines of code using the spring forums.");
            BrowserLauncher.openURL("http://www.java.com");//Misc.GetAbsoluteLobbyFolderPath()+"html/java6.html");
            /*javax.swing.SwingUtilities.invokeLater (new Runnable () {
                public void run () {
                    new WarningWindow ("<font face=\"Arial\" color=\""+ColourHelper.ColourToHex (Color.BLACK)+"\"><font size=20> Unsupported Java VM</font><br><br> Its been detected that your version of Java may be out of date. This could cause Unsatisfied link errors, random crashes, slow performance and GUI glitches.<br><br> You're currently running java version:"+System.getProperty ("java.version")+"<br><br> Make sure you get Sun Java v6</font>",
                        "Unsupported Java VM"
                        ).setVisible (true);
                }
            });*/
        }
        
        
        //RepaintManager.setCurrentManager(new ThreadCheckingRepaintManager());
        String looknfeel = CUserSettings.GetValue("looknfeel", UIManager.getSystemLookAndFeelClassName());
        if(looknfeel.equals("defjava")==false){
            try {
                //UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName ());
                UIManager.setLookAndFeel(looknfeel);
                //UIManager.put(LafWidget.TEXT_EDIT_CONTEXT_MENU, true); <- Balks when severl channels are open
                //UIManager.setLookAndFeel ("org.jvnet.substance.skin.SubstanceBusinessBlueSteelLookAndFeel");//"org.jvnet.substance.skin.SubstanceBusinessBlackSteelLookAndFeel");////org.jvnet.substance.skin.SubstanceNebulaLookAndFeel");
                if (Boolean.valueOf(CUserSettings.GetValue("angledtabs", "true"))) {
                    UIManager.put(SubstanceLookAndFeel.TABBED_PANE_VERTICAL_ORIENTATION, true);
                }
            } catch (ClassNotFoundException ex) {
                System.out.println("If you're running an svn version of AFLobby, please create a lib folder and put substance.jar in it, the devreadme.txt file has a download link for Substance v4+.");
                System.out.println(ex.getLocalizedMessage());
                ex.printStackTrace();
            } catch (UnsupportedLookAndFeelException ex) {
                ex.printStackTrace();
            } catch (InstantiationException ex) {
                ex.printStackTrace();
            } catch (IllegalAccessException ex) {
                ex.printStackTrace();
            }
        }

        // relayout components on resize while the resizing is occuring
        Toolkit.getDefaultToolkit().setDynamicLayout(true);
        
        // dont erase window contents while resizing
        System.setProperty("sun.awt.noerasebackground", "true");
        
        LMain L =new LMain ();
        L.start ();
/*        if(Misc.isWindows ()==false){
            String s = System.getProperty ("java.library.path");
            String[] t = s.split (";");
            boolean good = false;
            for(int i = 0; i< t.length; i++){
                if(t[i].trim ().equalsIgnoreCase (".")){
                    good = true;
                    break;
                }
            }
            if(!good){
                javax.swing.SwingUtilities.invokeLater (new Runnable () {
                    public void run () {
                        new WarningWindow ("<font face=\"Arial\" color=\""+ColourHelper.ColourToHex (Color.BLACK)+"\"><font size=20> <img src=\""+getClass ().getResource ("/images/UI/info.png").toExternalForm ()+"\"></img>Incorrect startup</font><br><br> Its been detected that you're not a windows user and the current working directory is <b>not</b> in the library path. The most probable cause of this is using methods such as double clicking from a file manager, running from within an archiving tool, or using java -jar aflobby.jar. This is incorrect. A bash script was provided with AFLobby named aflobby.sh, which contains the correct method of starting AFLobby. Its suggested you exit AFLobby and follow this advice.<br><br><br><br><b> path variable =</b> <i>"+ System.getProperty ("user.dir")+"</i><br> <b> library path = </b><i>"+System.getProperty ("java.library.path")+"</i></font>",
                            "Bad user start up"
                            ).setVisible (true);
                    }
                });
            }
            /*File f = new File("spring");
            if(f.exists ()==false){
                javax.swing.SwingUtilities.invokeLater (new Runnable () {
                    public void run () {
                        new WarningWindow ("<font face=\"Arial\" color=\""+ColourHelper.ColourToHex (Color.BLACK)+"\"><font size=20> <img src=\""+getClass ().getResource ("/images/UI/info.png").toExternalForm ()+"\"></img>Incorrect Installation</font><br><br> Its been detected that you're a linux user and the current working directory is <b>not</b> the spring folder. The most probable cause of this is using methods such as running from within an archiving tool such as xarchiver, installing to a standalone folder, or installing to a subfolder of the spring install such as /spring/AFlobby/. Its suggested you exit AFLobby and reinstall AFLobby correctly.<br><br><br><br><b> path variable =</b> <i>"+ System.getProperty ("user.dir")+"</i><br> <b> library path = </b><i>"+System.getProperty ("java.library.path")+"</i></font>",
                            "Bad user installation"
                            ).setVisible (true);
                    }
                });
            }*/
        //}else{
            //System.setProperty ("sun.awt.noerasebackground", "true");
        /*    File f = new File ("spring.exe");
            if(f.exists ()==false){
                javax.swing.SwingUtilities.invokeLater (new Runnable () {
                    public void run () {
                        new WarningWindow ("<font face=\"Arial\" color=\""+ColourHelper.ColourToHex (Color.BLACK)+"\"><font size=20> <img src=\""+getClass ().getResource ("/images/UI/info.png").toExternalForm ()+"\"></img>Incorrect Installation</font><br><br> Its been detected that you're a windows user and the current working directory is <b>not</b> the spring folder. The most probable cause of this is using methods such as running from within an archiving tool such as winrar, installing to a standalone folder, or installing to a subfolder of the spring install such as /spring/AFlobby/. Its suggested you exit AFLobby and reinstall AFLobby correctly.<br><br><br><br><b> path variable =</b> <i>"+ System.getProperty ("user.dir")+"</i><br> <b> library path = </b><i>"+System.getProperty ("java.library.path")+"</i></font>",
                            "Bad user installation"
                            ).setVisible (true);
                    }
                });
            }
        }*/
        long heapMaxSize = Runtime.getRuntime ().maxMemory ();
        if(heapMaxSize <66650112){
            javax.swing.SwingUtilities.invokeLater (new Runnable () {
                public void run () {
                    new WarningWindow ("<font face=\"Arial\" color=\""+ColourHelper.ColourToHex (Color.BLACK)+"\"><font size=20> Small Heap size</font><br><br> Its been detected that the java maximum heap value is less than 64MB. This can be changed via the comamnd parameters in the scripts aflobby.sh and aflobby.bat. This does not mean AFLobby is broken but if AFLobby reaches 128MB in memory or higher for a single moment, AFLobby will lockup and cease functioning. As always, work continues to reduce AFLobbys memory footprint further and further but its better to be safe than sorry.</font>",
                        "Possible Heap Size Issue"
                        ).setVisible (true);
                }
            });
        }
        if(Boolean.parseBoolean(CUserSettings.GetValue("showfirstrun", "True"))){
            //
            javax.swing.SwingUtilities.invokeLater (new Runnable () {
                public void run () {
                    new CStartupWizard ();
                }
            });
        }
    }
    
    /**
     * The program entry point referenced in the manifest file.
     * 
     * Command line parameters are parsed and appropriate static values are set
     * here. When this si compelte a Runnable object is dispatched for execution
     * on the GUI thread to create the main lobby GUI by calling CreateGUI();
     * 
     * Accepted command line parameters are
     * 
     * netbeans - puts AFLobby into developer mode. Numerous tabs become visible
     * displaying debug data, and the filesystem functions change behaviour to
     * use the active workign directory to prevent IDEs suffering.
     * 
     * chat - This places AFLobby in chatmode. All tabs referencing battles are
     * removed and all attempts to load and use unitsync are skipped. This
     * should be used by users running fof of usb drives or who want a lobby
     * client without requiring a spring install.
     * 
     * @param args the command line arguments
     */
    public static void main (String[] args) {

        for (String s : args){
            if(s.equalsIgnoreCase("netbeans")){
                dev_environment = true;
            }else if(s.equalsIgnoreCase("chat")){
                chat_only_mode = true;
            } else if ( s.equalsIgnoreCase("version")){
                System.out.println(CUpdateChecker.AFLVNumber);
                System.out.println(CUpdateChecker.AFLobbyVersion);
                return;
            }
        }
        Thread.setDefaultUncaughtExceptionHandler(new CAFLExceptionHandler());
        
        javax.swing.SwingUtilities.invokeLater (new Runnable () {
            public void run () {
                CreateGUI ();
            }
        });
    }
}
