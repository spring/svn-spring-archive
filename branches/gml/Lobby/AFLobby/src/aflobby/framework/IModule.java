/*
 * IModule.java
 *
 * Created on 30 June 2007, 08:19
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby.framework;

import aflobby.framework.CEvent;
import aflobby.LMain;
import java.util.EventListener;


/**
 *
 * @author Tom
 */
public interface IModule extends EventListener {
    public void Init(LMain L);
    public void Update();
    public void NewEvent(final CEvent e);
    public void NewGUIEvent(final CEvent e);
    public void OnRemove();
}
