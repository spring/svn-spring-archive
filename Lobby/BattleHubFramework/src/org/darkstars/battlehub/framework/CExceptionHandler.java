/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

import java.awt.Frame;
import java.lang.Thread.UncaughtExceptionHandler;
import javax.swing.JFrame;

/**
 *
 * @author tarendai-std
 */
public class CExceptionHandler  implements UncaughtExceptionHandler {
    
    @Override
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