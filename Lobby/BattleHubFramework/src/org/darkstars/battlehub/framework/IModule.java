/*
 * IModule.java
 *
 * Created on 30 June 2007, 08:19
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

import java.util.EventListener;


/**
 *
 * @author Tom
 */
public interface IModule extends EventListener {
    
    /**
     * 
     * @param L
     */
    public void Init(ICentralClass L);
    
    /**
     * 
     */
    public void Update();
    
    /**
     * 
     * @param e
     * 
     * @see OnEvent(CEvent e)
     */
    @Deprecated
    public void NewEvent(final CEvent e);
    
    /**
     * 
     * @param e
     */
    @Deprecated
    public void NewGUIEvent(final CEvent e);
    
    /**
     * This signifies that an event has been fired and this object has been
     * registered to recieved this event or events of a similar nature.
     * 
     * @param e the event that has been fired
     */
    public void OnEvent(final CEvent e);
    
    /**
     * Called when this object is removed from the messaging system
     */
    public void OnRemove();
    
    /**
     * Called when this object is removed from a message/event channel
     * 
     * @param channel the itneger representing the ID of that message/event 
     * channel
     */
    public void OnRemove(int channel);
}
