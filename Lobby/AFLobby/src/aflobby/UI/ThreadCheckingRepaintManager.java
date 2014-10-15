/*
 * ThreadCheckignRepaintManager.java
 *
 * Created on 01 July 2007, 02:35
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby.UI;

import javax.swing.JComponent;
import javax.swing.RepaintManager;
import javax.swing.SwingUtilities;

/**
 *
 * @author Tom
 */
public class ThreadCheckingRepaintManager extends RepaintManager {
    @Override
    public synchronized void addInvalidComponent(JComponent jComponent) {
        if(jComponent.getParent () != null){
            checkThread();
        }
        super.addInvalidComponent(jComponent);
    }

    private void checkThread() {
        if (!SwingUtilities.isEventDispatchThread()) {
            System.out.println("Wrong Thread");
            Thread.dumpStack();
        }
    }

    @Override
    public synchronized void addDirtyRegion(JComponent jComponent, int i,
                                            int i1, int i2, int i3) {
        if(jComponent.getParent () != null){
            checkThread();
        }
        //checkThread();
        super.addDirtyRegion(jComponent, i, i1, i2, i3);
    }
}
