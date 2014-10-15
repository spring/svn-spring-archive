/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package aflobby.framework;

import aflobby.framework.CEvent;
import aflobby.LMain;
import java.util.ArrayList;
import javax.swing.event.EventListenerList;

/**
 *
 * @author tarendai
 */
public class CCore implements IModule {

    private EventListenerList modules = new EventListenerList();
    private ArrayList<CEvent> GUIeventqueue = new ArrayList<CEvent>();
    private ArrayList<CEvent> eventqueue = new ArrayList<CEvent>();

    /**
     * 
     * @param L
     */
    public void Init(LMain L) {
        
    }

    /**
     * Calls the update method of registered event handlers and dispatches
     * events.
     */
    public void Update() {

        // check if a previous Update call is still running
        //if(isUpdating){
        // we're already running an update!
        //    return;
        //}

        // specify that the update method is now running
        /*isUpdating = true;


        if (eventqueue.isEmpty() == false) {
            Object[] queue = eventqueue.toArray();
            eventqueue.clear();
            
            int eCount = queue.length;

            for (int ie = 0; ie < eCount; ie++) {
                CEvent e = (CEvent) queue[ie];

                if (e == null) {
                    continue;
                }
                


                fireEvent(e, 1);
            }

            eventqueue.clear();
        }

        if (GUIeventqueue.isEmpty() == false) {

            Object[] queue = GUIeventqueue.toArray();
            GUIeventqueue.clear();
            
            int eCount = queue.length;

            for (int ie = 0; ie < eCount; ie++) {
                CEvent e = (CEvent) queue[ie];

                if (e == null) {
                    continue;
                }
                

                fireEvent(e, 0);
            }
        }*/

        //synchronized(modules)

        /*ArrayList<IModule> tm = new ArrayList<IModule>();
        synchronized(modules){
        tm.addAll(modules);
        }*/


        fireEvent(null,2);
    //

    // specify that the update method is no longer running
    //isUpdating = false;
    }
    //public boolean isUpdating = false;

    /**
     * 
     * @param e
     */
    public void NewEvent(CEvent e) {
        fireEvent(e, 1);
/*        synchronized (eventqueue) {
            eventqueue.add(e);
        }
*/    }

    /**
     * 
     * @param e
     */
    public void NewGUIEvent(CEvent e) {
        fireEvent(e, 0);
//        synchronized (GUIeventqueue) {
//            GUIeventqueue.add(e);
  //      }
    }

    /**
     * Adds a new module to the event system.
     * 
     * @param module the module to be added
     */
    public void AddModule(IModule module) {
        //
        //synchronized(modules){
        modules.add(IModule.class, module);
    //if(modules.contains(module)==false){
    //    modules.add(module);
    //}
    //}
    }

    /**
     * Removes a module from the event system.
     * 
     * @param module the module to be removed
     */
    public void RemoveModule(IModule module) {
        //synchronized(modules){
        module.OnRemove();
        modules.remove(IModule.class, module);
    //}
    }

    public void OnRemove() {

    }

    private synchronized void fireEvent(final CEvent e, int type) {
        Object[] listeners = modules.getListenerList();
        // loop through each listener and pass on the event if needed
        int numListeners = listeners.length;
        for (int i = 0; i < numListeners; i += 2) {
            if (listeners[i] == IModule.class) {
                // pass the event to the listeners event dispatch method
                if (type == 0) {
                    ((IModule) listeners[i + 1]).NewGUIEvent(e);
                } else if (type == 1) {
                    ((IModule) listeners[i + 1]).NewEvent(e);
                } else if (type == 2) {
                    ((IModule) listeners[i + 1]).Update();
                }

            }
        }
    }
}

