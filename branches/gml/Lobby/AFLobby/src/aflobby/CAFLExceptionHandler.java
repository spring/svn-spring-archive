/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import aflobby.UI.CErrorWindow;
import java.awt.Frame;
import java.lang.Thread.UncaughtExceptionHandler;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

/**
 *
 * @author tarendai-std
 */
public class CAFLExceptionHandler  implements UncaughtExceptionHandler {
    
  public void uncaughtException(Thread t, Throwable e) {
    // Here you should have a more robust, permanent record of problems
    //JOptionPane.showMessageDialog(findActiveFrame(),
    //    e.toString(), "Exception Occurred", JOptionPane.OK_OPTION);
    CErrorWindow ew = new CErrorWindow(e);
    e.printStackTrace();
  }
  private Frame findActiveFrame() {
    Frame[] frames = JFrame.getFrames();
    for (int i = 0; i < frames.length; i++) {
      if (frames[i].isVisible()) {
        return frames[i];
      }
    }
    return null;
  }
}