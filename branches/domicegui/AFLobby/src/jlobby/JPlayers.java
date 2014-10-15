/*
 * JPlayers.java
 *
 * Created on 28 May 2006, 12:17
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jlobby;
import java.io.*;
import java.util.*;

class PMUpdateTask extends TimerTask {
    public JPlayers LM;
    PMUpdateTask(JPlayers L){
        LM = L;
    }
    public void run() {
        LM.Update();
    }
}

/**
 *
 * @author AF
 */

public class JPlayers extends Thread{
    public ArrayList<JPlayer> players = new ArrayList<JPlayer>();
    public Vector<String> activeplayers = new Vector<String>();
    public LMain LM;
    
    /** Creates a new instance of JPlayers */
    public JPlayers(LMain L) {
        LM = L;
        new Timer().schedule(new PMUpdateTask(this),
                11,        //initial delay
                24);  //subsequent rate
    }
    boolean playerstat_avail = true;
    String GetPlayerStatus(String name){
        if(players.isEmpty()==true){
            return "unknown status";
        }
        ArrayList<JPlayer> ptemp = new ArrayList<JPlayer>();
        ptemp.addAll(players);
        Iterator<JPlayer> i = ptemp.iterator();
        while(i.hasNext()){
            JPlayer p = i.next();
            if(p.name.equalsIgnoreCase(name)){
                return p.GetStatushtml();
            }
        }
        return "unknown status";
    }
    public void Update(){
        //
        ProcessEvents();
    }
    ArrayList<JEvent> events = new ArrayList<JEvent>();
    ArrayList<JEvent> GUIevents = new ArrayList<JEvent>();
    void ProcessEvents(){
        if(events.isEmpty()==false){
            ArrayList<JEvent> temp = new ArrayList<JEvent>();
            temp.addAll(events);
            events.clear();
            Iterator<JEvent> i = temp.iterator();
            while(i.hasNext()){
                JEvent e = i.next();
                if(e.data[0].equalsIgnoreCase("ADDUSER")==true){
                    activeplayers.add(e.data[1]);
                    JPlayer p = new JPlayer(LM,e.connection,e.data[1],e.data[2]);
                    players.add(p);
                }else if(e.data[0].equals("REMOVEUSER")){
                    activeplayers.remove(e.data[1]);
                }
                Iterator<JPlayer> q = players.iterator();
                while(q.hasNext()==true){
                    JPlayer k = q.next();
                    k.NewEvent(e);
                }
            }
        }
        //////
        if(GUIevents.isEmpty()==false){
            ArrayList<JEvent> temp2 = new ArrayList<JEvent>();
            temp2.addAll(GUIevents);
            GUIevents.clear();
            Iterator<JEvent> k = temp2.iterator();
            while(k.hasNext()){
                JEvent e = k.next();
                Iterator<JPlayer> q = players.iterator();
                while(q.hasNext()==true){
                    JPlayer h = q.next();
                    h.NewGUIEvent(e);
                }
            }
        }
    }
    public void NewEvent(JEvent e){
        events.add(e);
    }
    public void NewGUIEvent(JEvent e){
        GUIevents.add(e);
    }
    
}
