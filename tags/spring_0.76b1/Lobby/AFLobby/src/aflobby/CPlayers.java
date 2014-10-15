/*
 * CPlayers.java
 *
 * Created on 28 May 2006, 12:17
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import aflobby.framework.IModule;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;

/**
 *
 * @author AF
 */

public class CPlayers extends Thread implements IModule {//
    public ArrayList<CPlayer> players = new ArrayList<CPlayer>();
    public ArrayList<String> activeplayers = new ArrayList<String>();
    public ArrayList<String> inactiveplayers = new ArrayList<String>();
    public TreeMap<String,CPrivateMsgWindow> pmwindows = new TreeMap<String,CPrivateMsgWindow>();
    public LMain LM;
    
    public ArrayList<CEvent> events = new ArrayList<CEvent>();
    public ArrayList<CEvent> GUIevents = new ArrayList<CEvent>();
    
    
    /**
     * Creates a new instance of CPlayers
     * @param L 
     */
    public CPlayers () {
        /*new Timer().schedule(new PMUpdateTask(this),
                11,        //initial delay
                24);  //subsequent rate*/
    }
    
    public  CPlayer GetPlayer (String name){
        synchronized(players){
            Iterator<CPlayer> i = players.iterator ();
            while(i.hasNext ()){
                CPlayer p = i.next ();
                if(p.name.equalsIgnoreCase (name)){
                    return p;
                }
            }
        }
        return null;
    }
    
    public  String GetPlayerStatus (String name){
        
        if(players.isEmpty ()==true){
            return "unknown status";
        }
        synchronized(players){
            Iterator<CPlayer> i = players.iterator ();
            while(i.hasNext ()){
                CPlayer p = i.next ();
                if(p.name.equalsIgnoreCase (name)){
                    return p.GetStatushtml ();
                }
            }
        }
        return "unknown status";
    }
    
    public boolean GetPlayerInGame(String playername){
        CPlayer p = this.GetPlayer (playername);
        
        if(p == null){
            return false;
        }
        
        if(Misc.getInGameFromStatus (p.getStatus())==1){
            return true;
        }else{
            return false;
        }
    }
    
    public void Update (){
    }
    
    
    public void NewEvent (final CEvent e){
        if(e.IsEvent("ADDUSER")==true){
            activeplayers.add (e.data[1]);
            if(inactiveplayers.contains (e.data[1])==false){
                inactiveplayers.remove (e.data[1]);
                CPlayer p = new CPlayer (LM,e.data[1]);
                p.setCpu(e.data[3] + "Mhz");
                p.setCountry(e.data[2]);
                players.add (p);
            }
        }else if(e.IsEvent("REMOVEUSER")){
            activeplayers.remove (e.data[1]);
            inactiveplayers.add (e.data[1]);
        }else if(e.IsEvent("SAIDPRIVATE")){
            if(this.pmwindows.containsKey (e.data[1])){
                pmwindows.get (e.data[1]).Open ();
                //Open ();
            }else{
                CPrivateMsgWindow privmsg = new CPrivateMsgWindow ();
                privmsg.Init (LM,this.GetPlayer (e.data[1]));
                pmwindows.put (e.data[1],privmsg);
                privmsg.Open ();
                //privmsg.NewEvent (e);
            }
        }
        synchronized(players){
            Iterator<CPlayer> q = players.iterator ();
            while(q.hasNext ()==true){
                CPlayer k = q.next ();
                k.NewEvent (e);
            }
        }
        Iterator<CPrivateMsgWindow> pmi = pmwindows.values ().iterator ();
        while(pmi.hasNext ()==true){
            CPrivateMsgWindow k = pmi.next ();
            k.NewEvent (e);
        }
    }
    
    public  void NewGUIEvent (final CEvent e){
        if(e.IsEvent (CEvent.OPENPRIVATEMSG)){
            if(e.data[1] == null){
                return;
            }
            if(this.pmwindows.containsKey (e.data[1])){
                pmwindows.get (e.data[1]).Open ();
                //Open ();
            }else{
                CPrivateMsgWindow privmsg = new CPrivateMsgWindow ();
                privmsg.Init (LM,this.GetPlayer (e.data[1]));
                pmwindows.put (e.data[1],privmsg);
                privmsg.Open ();
            }
        }
        synchronized(players){
            Iterator<CPlayer> q = players.iterator ();
            while(q.hasNext ()==true){
                CPlayer h = q.next ();
                h.NewGUIEvent (e);
            }
        }
        Iterator<CPrivateMsgWindow> pmi = pmwindows.values ().iterator ();
        while(pmi.hasNext ()==true){
            CPrivateMsgWindow p = pmi.next ();
            p.NewEvent (e);
        }
    }

    public void Init(LMain L) {
        LM = L;
    }

    public void OnRemove() {
    }
    
    
}
