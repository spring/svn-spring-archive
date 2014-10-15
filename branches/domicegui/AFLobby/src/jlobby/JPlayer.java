/*
 * JPlayer.java
 *
 * Created on 28 May 2006, 12:12
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jlobby;
import java.io.*;
import java.util.*;
import javax.swing.ListModel;
/**
 *
 * @author AF
 */
class PUpdateTask extends TimerTask {
    public JPlayer LM;
    PUpdateTask(JPlayer L){
        LM = L;
    }
    public void run() {
        LM.Update();
    }
}
public class JPlayer extends Thread{
    public String name;
    public LMain LM;
    public String ip;
    public JConnection connection;
    public JPrivate privmsg;
    public boolean logged_in;
    public boolean addedtopane = false;
    int status = 0;
    int access=0;
    int away=0;
    int ingame=0;
    int rank=0;
    /** Creates a new instance of JPlayer */
    public JPlayer(LMain L, JConnection c,String pname, String ip) {
        LM = L;
        connection=c;
        name = pname;
        privmsg = new JPrivate();
        privmsg.Init(L,this);
        logged_in = true;
        addedtopane=true;
        c.traffic.add("issuing full validation");
        LM.DoValidate();
        new Timer().schedule(new PUpdateTask(this),
                12,        //initial delay
                30);  //subsequent rate
    }
    //boolean available_update = true;
    public void Update(){
       // while (available_update == false) {
       //     try {
       //         wait();
       //     } catch (InterruptedException e) { }
        //}
       // available_update=false;
        privmsg.Update();
       // available_update=true;
        //notifyAll();
    }
    //boolean available_htmlstatus=true;
    public String GetStatushtml(){
       // while (available_htmlstatus == false) {
       //     try {
       //         wait();
       //     } catch (InterruptedException ex) { }
       // }
      //  available_htmlstatus=false;
        String s = " n/a";
       // available_htmlstatus=true;
       // notifyAll();
        return s;
    }
    //boolean available_newevent= true;
    public void NewEvent(JEvent e){
       // while (available_newevent == false) {
       //     try {
     //           wait();
      //      } catch (InterruptedException ex) { }
      //  }
        //available_newevent = false;
        privmsg.NewEvent(e);
        if(e.data[0].equals("REMOVEUSER")){
            if(e.data[1].equals(name)){
                logged_in = false;
            }
        }else if (e.data[0].equalsIgnoreCase("CLIENTSTATUS")){
            status= Integer.parseInt(e.data[2]);
            //access = Misc.getAccessFromStatus(Integer.parseInt(e.data[2]));
            //away = Misc.getAwayBitFromStatus(Integer.parseInt(e.data[2]));
            //ingame = Misc.getRankFromStatus(Integer.parseInt(e.data[2]));
            //rank = Misc.getRankFromStatus(Integer.parseInt(e.data[2]));
            //
        }
        //available_newevent=true;
        //notifyAll();
    }
    public void NewGUIEvent(JEvent e){
        privmsg.NewGUIEvent(e);
    }
    public void OpenPrivMsg(){
        privmsg.Open();
    }
}
