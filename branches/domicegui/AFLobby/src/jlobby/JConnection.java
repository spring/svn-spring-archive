/*
 * JConnection.java
 *
 * Created on 27 May 2006, 20:51
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jlobby;
import com.sun.org.apache.bcel.internal.classfile.JavaClass;
import java.io.*;
import java.net.*;
import jlobby.JEvent;
import org.w3c.dom.*;

import java.util.*;
import java.util.regex.*;
import java.util.concurrent.*;
import java.lang.*;
/**
 *
 * @author AF
 */
class JCUpdateTask extends TimerTask {
    public JConnection c;
    JCUpdateTask(JConnection jc){
        c = jc;
    }
    public void run() {
        c.Update();
    }
}
class JCPingTask extends TimerTask {
    public JConnection c;
    JCPingTask(JConnection jc){
        c = jc;
    }
    public void run() {
        if(c.IsConnected()==true){
            c.SendLine("PING");
        }
    }
}
public class JConnection extends Thread{
    public LMain LM;
    public String port = "8200";
    public String server = "";
    public String name = "New Connection";
    public String ip = "";
    public boolean logged_in = false;
    public String username = "";
    public String password = "";
    public JTraffic traffic=new JTraffic();
    public int counter=1;

    public ArrayList<String> messages = new ArrayList<String>();

    Socket socket=null;

    BufferedReader sockin=null;

    PrintWriter sockout=null;

    
    public JConnection(LMain L){
        //
        LM = L;
        traffic.Init(this);
        traffic.setVisible(true);
        new Timer().schedule(new JCUpdateTask(this),
                5,        //initial delay
                10);  //subsequent rate
        new Timer().schedule(new JCPingTask(this),
                1000,        //initial delay
                10000);  //subsequent rate
    }
    private boolean available=true;
    synchronized String GetNextLine(){
        while (available == false) {
            try {
                wait();
            } catch (InterruptedException e) { }
        }
        available=false;
        String s = null;
        if(messages.isEmpty()==false){
            s = messages.get(0);
            messages.remove(0);
        }/*else{
            traffic.add("messages.isEmpty()==true");
        }*/
        available=true;
        notifyAll();
        return s;
    }
    /**
     * 
     * @return 
     */
    public boolean IsConnected(){
        if(socket == null) return false;
        return socket.isConnected();
    }
    
    public boolean IsLoggedIn(){
        if(socket == null) return false;
        return logged_in;
    }

    ArrayList<JEvent> events = new ArrayList<JEvent>();
    void ProcessEvents(){
        if(events.isEmpty()){
            return;
        }
        ArrayList<JEvent> temp = new ArrayList<JEvent>();
        temp.addAll(events);
        events.clear();
        Iterator<JEvent> i = temp.iterator();
        while(i.hasNext()){
            JEvent e = i.next();
            if(e.data[0].equalsIgnoreCase("JDISCONNECTED")==true){
                try {
                    wait(50);
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }
                Connect();
            }else if(e.data[0].equalsIgnoreCase("JLOGOUT")==true){
                logged_in = false;
            }else if(e.data[0].equalsIgnoreCase("SHOWTRAFFIC")==true){
                traffic.setVisible(true);
            }else if(e.data[0].equalsIgnoreCase("HIDETRAFFIC")==true){
                traffic.setVisible(false);
            }else if(e.data[0].equalsIgnoreCase("TASSERVER")==true){
                Login(username,password);
            }
        }
    }
    public void NewEvent(JEvent e){
        events.add(e);
    }

    /**
     * Connects to the server
     */
    public void Connect(){
        try {
            traffic.add("Connecting to " + server + ":" + port + " ...");
            socket = new Socket(server,Integer.parseInt(port));
            sockout = new PrintWriter(socket.getOutputStream(), true);
            sockin = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            if(sockin == null) traffic.add("sockin==null!!!!!");
            if(sockin == null) traffic.add("sockin==null!!!!!");
            ip = socket.getLocalAddress().toString();
            String[] jp = ip.split("/");
            if(jp.length == 2){
                ip = jp[1];
            }else{
                ip = jp[0];
            }
            if(IsConnected()==true){
                traffic.add("socket succesfully opened");
            }
        } catch (UnknownHostException e) {
            //Log.error();
            //closeAndExit(1);
            traffic.add(e.toString());
            traffic.add("Unknown host error: " + server);
            StackTraceElement[] si = e.getStackTrace();
            for(int i = 0; i < si.length; i++){
                traffic.add(si[i].toString());
            }
            JEvent ev = new JEvent();
            ev.connection=this;
            ev.connection_name = name;
            ev.user = username;
            ev.data = new String[1];
            ev.data[0] = "UNKNOWN_HOST";
        } catch (IOException e) {
            //Log.error( + serverAddress);
            traffic.add(e.toString());
            StackTraceElement[] si = e.getStackTrace();
            for(int i = 0; i < si.length; i++){
                traffic.add(si[i].toString());
            }
            traffic.add("Couldn't get I/O for the connection to: " + server + " \n" + e.getMessage() + "\n" + e.getLocalizedMessage());
        }catch(Exception e){
            traffic.add(e.toString());
            StackTraceElement[] si = e.getStackTrace();
            for(int i = 0; i < si.length; i++){
                traffic.add(si[i].toString());
            }
        }    
    }

    // 6QUahzbMfSKtLmy94ZhKow==
    public void Login(String username, String password){
        if(password.equals("")){
            traffic.add("error \" \" in password box");
        }
        traffic.add("sending login command");//
        String s = "LOGIN " + username + " " + Misc.encodePassword(password) + " 2500 " + ip + " AFLobby_0.01a";
        SendLine(s);
        traffic.add(s);
        traffic.add("waiting for ACCEPTED");
    }

    public void LogOut(){
        //
        Disconnect();
        Connect();
    }

    public void Register(String username, String password){
        //
        SendLine("REGISTER " + username + " " + Misc.encodePassword(password));
    }

    /**
     * Disconnects the connection to the server
     */
    public void Disconnect(){
        try {
            //
            socket.close();
            logged_in = false;
        } catch (IOException ex) {
            traffic.add(ex.toString());
            StackTraceElement[] si = ex.getStackTrace();
            for(int i = 0; i < si.length; i++){
                traffic.add(si[i].toString());
            }
            //traffic.add()
            //ex.printStackTrace();
        }
    }
    //boolean available2=true;
    public void Update(){
       // while (available2 == false) {
       //     try {
       //         wait();
       //     } catch (InterruptedException e) { }
       // }
       // available2=false;
        ProcessEvents();
        for(int i = 0; i < 20;i++){
            String s = GetNextLine();
            if(s != null){
                JEvent e = new JEvent();
                e.connection = this;
                e.data = s.split(" ");
                LM.NewEvent(e);
            }
        }
        if(IsConnected() == false){
            if(logged_in==true){
                // DISCONNECTED!!!!!!!!!! AHK AHK AHK AHK
                JEvent e2 = new JEvent();
                e2.connection = null;
                e2.data = new String[1];
                e2.data[0] = "JDISCONNECTED";
                LM.NewEvent(e2);
                logged_in=false;
            }
            //available2=true;
           // notifyAll();
            return;
        }else{
            if(sockin != null){
                try {
                    while(sockin.ready()){
                        String s = sockin.readLine();
                        if(s!= null){
                            messages.add(s);
                            traffic.add("traffic recieved sent for processing:: "+ s);
                            // here would usually be the whoel redirect code but 
                            // I think it's best that be doen in the NewEvent 
                            // function
                        }else{
                            break;
                        }
                    }
                } catch (IOException ex) {
                    traffic.add(ex.toString());
                    StackTraceElement[] si = ex.getStackTrace();
                    for(int i = 0; i < si.length; i++){
                        traffic.add(si[i].toString());
                    }
                }
            }
        }
        
       // available2=true;
       // notifyAll();
    }
    boolean available3 = true;
    public synchronized void SendLine(String message){
        while (available3 == false) {
            try {
                wait();
            } catch (InterruptedException e) { }
        }
        available3 = false;
        if(IsConnected()){
            sockout.println(message);
            traffic.add(message);
        }else{
            traffic.add("Not connected could not send :: " + message);
        }
        available3 = true;
        notifyAll();
    }
    
}