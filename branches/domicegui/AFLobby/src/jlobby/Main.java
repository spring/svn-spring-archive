/*
 * Main.java
 *
 * Created on 22 May 2006, 18:43
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jlobby;

/**
 *
 * @author AF
 */

public class Main {
    public static LMain L = new LMain();
    /** Creates a new instance of Main */
    public Main() {
        
    }
    public static void CreateGUI(){
        LMain L =new LMain();
        L.start();
    }
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                CreateGUI();
            }
        });
    }
}
