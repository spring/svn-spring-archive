/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import aflobby.UI.CUserSettings;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import org.jvnet.substance.SubstanceLookAndFeel;

/**
 *
 * @author tarendai
 */
public class CLooknfeelHelper {

    public static LMain LM;
    /**
     * 
     * @param looknfeel 
     */
    public static void SetLooknfeel(final String looknfeel){
        //
        if(looknfeel.equals("defjava")==false){
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
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
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        }
    }
}
