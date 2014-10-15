/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.darkstars.battlehub.framework;

import java.util.HashMap;
import java.util.Map;
import javax.swing.event.EventListenerList;

/**
 *
 * @author tarendai
 */
public class CCore implements IModule {

    //private EventListenerList modules = new EventListenerList();
    
    private Map<Integer,EventListenerList> channelModules;

    /**
     * Glorified error value, and default channel value used when a CEvent 
     * object has not been given a channel in its constructor.
     * 
     * Usually found on events that use the old way fo doing things e.g. 
     * NewEvent NewGUIEvent
     * 
     * @see NewEvent()
     * @see NewGUIEvent()
     */
    public final static int UNDEFINED_CHANNEL = 0;
    
    /**
     * This channel is used for delivering raw server traffic, raw protocol.
     */
    public final static int RCVD_SERVER_TRAFFIC = 1;
    
    /**
     * This channel is used for delivering messages that the lobby has sent to 
     * the end server. If you send "HELLO WORLD" to the server a message 
     * containing "HELLO WORLD" will be sent on this channel.
     */
    public final static int SENT_SERVER_TRAFFIC = 2;
    
    /**
     * This is basically intended to manage the NewGUIEvent() call that is now 
     * deprecated
     * 
     * @see NewGUIEvent()
     * @deprecated
     */
    @Deprecated
    public final static int LOBBY_GUI_EVENTS = 3;
    
    /**
     * These events do not actually occur in the protocol, and are intended to 
     * be protocol agnostic. Ideally this channel would be used rather than 
     * actual protocol, and the only place raw protocol should occur is at the 
     * protocol layer when translated to and from the end server.
     */
    public final static int PROTOCOL_EVENTS = 4;
    
    /**
     * Issues an Update() call
     */
    public final static int TIMER_UPDATE = 5;
    
    /**
     * Used for the creation of UI objects and the messages that add them to 
     * other UI components or remove them. Additions, movements, and removals 
     * basically.
     * 
     * Note: The modification and handling of UI objects that have already been
     * placed, such as click events or other processing is outside the scope of 
     * this event channel.
     */
    public final static int UI_OBJECT_MANAGEMENT = 6;
    
    public CCore(){
        // create our hashmap of event listeners
        channelModules = new HashMap<Integer, EventListenerList>();
        
        // create the old deprecated channels for backwards compatibility.
        CreateChannel(LOBBY_GUI_EVENTS);
        CreateChannel(RCVD_SERVER_TRAFFIC);
        CreateChannel(TIMER_UPDATE);
    }
    /**
     * 
     * @param L
     */
    @Override
    public void Init(final ICentralClass LM) {
        //
    }

    /**
     * A CEvent object created for timer updates once so that it neednt be 
     * recreated and garbage collected every time an Update call is needed.
     */
    private CEvent timeupd = new CEvent("TIMER", false, TIMER_UPDATE);
    
    /**
     * Calls the update method of registered event handlers and dispatches
     * events.
     */
    @Override
    @Deprecated
    public void Update() {
        FireEvent(timeupd, CCore.TIMER_UPDATE);
    }

    /**
     * 
     * @param e
     */
    @Override
    @Deprecated
    public void NewEvent(CEvent e) {
        assert(e != null);
//        if(e.IsValid()){
            FireEvent(e, CCore.RCVD_SERVER_TRAFFIC);
//        }
    }

    /**
     * 
     * @param e
     */
    @Override
    @Deprecated
    public void NewGUIEvent(CEvent e) {
        assert(e != null);
        //if(e.IsValid()){
            FireEvent(e, CCore.LOBBY_GUI_EVENTS);
       // }
    }

    /**
     * Adds a new module to the event system.
     * 
     * @param module the module to be added
     */
    @Deprecated
    public void AddModule(IModule module) {
        AddModule(module, CCore.RCVD_SERVER_TRAFFIC);
        AddModule(module, CCore.LOBBY_GUI_EVENTS);
        AddModule(module, CCore.TIMER_UPDATE);
    }
    
    /**
     * Adds a new module to the given event channel system.
     * 
     * @param module the module to be added
     * @param channel the channel the module is to be registered to
     */
    public void AddModule(IModule module, int channel) {
        if(HasChannel(channel)==false){
            CreateChannel(channel);
        }
        GetChannelModules(channel).add(IModule.class, module);
    }

    /**
     * Removes a module from the event system.
     * 
     * @param module the module to be removed
     */
    @Deprecated
    public void RemoveModule(IModule module) {
        if(module != null){
            module.OnRemove();
            
            // make sure the object is removed from the default backwards compat channels
            channelModules.get(RCVD_SERVER_TRAFFIC).remove(IModule.class, module);
            channelModules.get(LOBBY_GUI_EVENTS).remove(IModule.class, module);
            channelModules.get(TIMER_UPDATE).remove(IModule.class, module);
        }
    }
    
    /**
     * Removes a module from the event system.
     * 
     * @param module the module to be removed
     * @param channel the event channel this objects to be removed from
     */
    public void RemoveModule(IModule module, int channel) {
        if(module != null){
            module.OnRemove(channel);
            channelModules.get(channel).remove(IModule.class, module);
        }
    }

    /**
     * Empties all modules from this event system
     */
    @Deprecated
    public void RemoveAllModules() {
        //
        RemoveAllChannelModules(CCore.RCVD_SERVER_TRAFFIC);
        RemoveAllChannelModules(CCore.LOBBY_GUI_EVENTS);
        RemoveAllChannelModules(CCore.TIMER_UPDATE);
    }
    
    /**
     * Empties all modules from a given message channel
     */
    public void RemoveAllChannelModules(int channel) {
        //
        Object[] listeners = GetChannelModules(channel).getListenerList().clone();
        if (listeners != null) {
            for (int i = 0; i < listeners.length; i++) {
                Object o = listeners[i];
                if (o.getClass() == IModule.class) {
                    RemoveModule((IModule) o,channel);
                }
            }
        }
    }

    @Override
    public void OnRemove() {
    }
//synchronized
    @Deprecated
    private  void FireEvent(CEvent e, int channel) {
        
        assert(e != null);
        if(channel != CCore.RCVD_SERVER_TRAFFIC){
            
            if( channel != CCore.LOBBY_GUI_EVENTS){
                if(channel != CCore.TIMER_UPDATE){
                    FireEvent(e);
                    return;
                }
            }
        }
        if(!HasChannel(channel)){
            return;
        }
        Object[] listeners = GetChannelModules(channel).getListenerList();
        // loop through each listener and pass on the event if needed
        int numListeners = listeners.length;
        for (int i = 0; i < numListeners; i += 2) {
            if(!e.IsValid()){
                break;
            }
            if (listeners[i] == IModule.class) {
                // pass the event to the listeners event dispatch method
                if (channel == CCore.LOBBY_GUI_EVENTS) {
                    ((IModule) listeners[i + 1]).NewGUIEvent(e);
                } else if (channel == CCore.RCVD_SERVER_TRAFFIC) {
                    ((IModule) listeners[i + 1]).NewEvent(e);
                } else if (channel == CCore.TIMER_UPDATE) {
                    ((IModule) listeners[i + 1]).Update();
                }

            }
        }
    }
    
    //synchronized
    
    public  void FireEvent(CEvent e) {
        int channel = e.GetMessageChannel();
        if(channel == CCore.UNDEFINED_CHANNEL){
            throw new RuntimeException("undefined channel used for event");
        }
        if(!HasChannel(channel)){
            return;
        }
        Object[] listeners = GetChannelModules(channel).getListenerList();
        // loop through each listener and pass on the event if needed
        int numListeners = listeners.length;
        for (int i = 0; i < numListeners; i += 2) {
            if(!e.IsValid()){
                break;
            }
            if (listeners[i] == IModule.class) {
                // pass the event to the listeners event dispatch method
                ((IModule) listeners[i + 1]).OnEvent(e);
            }
        }
    }
    
    public boolean HasChannel(int channel){
        return channelModules.containsKey(channel);
    }
    
    public boolean HasChannelListeners(int channel){
        //
        if(!HasChannel(channel)){
            return false;
        }
        return (GetChannelModules(channel).getListenerCount()> 0);
    }
    
    public void CreateChannel(int channel){
        if(!HasChannel(channel)){
            channelModules.put(channel, new EventListenerList());
        }
    }
    
    protected EventListenerList GetChannelModules(int channel){
        //
        return channelModules.get(channel);
    }

    public void OnEvent(CEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void OnRemove(int channel) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}

