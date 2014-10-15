/*
 * CBaseModule.java
 * 
 * Created on 22-Aug-2007, 22:27:55
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby.framework;

import aflobby.framework.CEvent;
import aflobby.LMain;



/**
 *
 * @author Tom
 */
public class CBaseModule implements IModule{
    public LMain LM;
    public void Init(LMain L) {
        LM = L;
    }

    public void Update() {
        
    }

    public void NewEvent(final CEvent e) {
        
    }

    public void NewGUIEvent(final CEvent e) {
        
    }
    
    public void OnRemove() {
        
    }

}
