/*
 * JSpringAI.java
 *
 * Created on 12 June 2006, 22:36
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jlobby;

/**
 *
 * @author AF
 */
public class JSpringAI {
    int version=1;
    /** Creates a new instance of JSpringAI */
    public JSpringAI() {
    }
    public void LoadAI(String AI){
        // load up the AI!!!
    }
    public native int JVersion(); // get which version of the JSpringAI class this AI has bindings for
    public native String GetName();
    public native String GetDescription(boolean html);
    // false == plaintext
    public native int GetVersion();
    public native int GetInterfaceVersion();
    public native boolean IsGroupAI();
}
