/*
 * CConnection.java
 *
 * Created on 27 May 2006, 20:51
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.darkstars.battlehub.framework;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;


/**
 *
 * @author AF
 */
class JCUpdateTask extends TimerTask {

    public CConnection c;
    public static boolean b = false;

    JCUpdateTask(CConnection jc) {
        c = jc;
        if (b) {
            int a = 4;
        }
        b = true;
    }

    @Override
    public void run() {
        if (c.updatedone) {
            c.Update();
        }
    }
}

class JCPingTask extends TimerTask {

    public CConnection c;

    JCPingTask(CConnection jc) {
        c = jc;
    }

    @Override
    public void run() {
        if (c.IsConnected() == true) {
            c.SendLine("PING");
        }
    }
}

public class CConnection extends Thread {

    public static ITrafficListener getTraffic() {
        return trafficListener;
    }

    public static void setTraffic(ITrafficListener aTraffic) {
        trafficListener = aTraffic;
    }

    boolean connected = false;
    
    public CCore distributor;
    private int port = 8200;
    private String server = "";
    public String name = "New Connection";
    public String ip = "";
    private boolean logged_in = false;
    private static ITrafficListener trafficListener = null;
    public int counter = 1;
    private int max_traffic = 1000;
    public boolean updatedone = true;
    public int UDPSourcePort;
    public ArrayList<String> messages = new ArrayList<String>();
    Socket socket = null;
    BufferedReader sockin = null;
//    DataOutputStream sockout = null;
    PrintWriter sockout = null;
    int second_interim = 0;
    Timer updates = null;
    Timer pingtask = null;

    public CConnection(CCore distributor) {
        //
        
        assert(distributor != null);
        
        this.distributor = distributor;
        if(trafficListener != null){
            trafficListener.Init(this);
        }

    }

    String GetNextLine() {
        String s = null;
        if (messages.isEmpty() == false) {
            synchronized (messages) {
                s = messages.remove(0);
            }
        } /*else{
        traffic.add("messages.isEmpty()==true");
        }*/
        return s;
    }

    /**
     *
     * @return boolean a
     */
    public boolean IsConnected() {
        if (socket == null) {
            return false;
        }
        if (sockout == null) {
            return false;
        }
        return socket.isConnected();
    }

    public boolean IsLoggedIn() {
        if (!IsConnected()) {
            return false;
        }
        return logged_in;
    }
    ArrayList<CEvent> events = new ArrayList<CEvent>();

    public void NewEvent(final CEvent e) {
        if (e.IsEvent("ACCEPTED")) {
            logged_in = true;
        }
    }

    public void NewGUIEvent(final CEvent e) {
        
    }

    /**
     * Connects to the server
     * 
     * @param pserver 
     * @param pport 
     * @return 
     * @throws java.lang.RuntimeException 
     * @throws java.net.UnknownHostException 
     * @throws java.io.IOException 
     */
    public boolean Connect(String pserver, int pport) throws UnknownHostException, UnknownHostException, IOException {
        //try {
        traffic_cache_out.clear();
        server = pserver;
        port = pport;
        
        if(getTraffic() != null){
                getTraffic().Add("Connecting to " + server + ":" + port + " ...");
        }
        socket = new Socket(server, port);
        sockout = new PrintWriter(new OutputStreamWriter(socket.getOutputStream(), "utf-8"), true);
//        sockout = new DataOutputStream(socket.getOutputStream());
        sockin = new BufferedReader(new InputStreamReader(socket.getInputStream(),"utf-8"));

        if (sockin == null) {
            if(getTraffic() != null){
                getTraffic().Add("sockin==null!!!!!");
            }
        }
        if (sockin == null) {
            if(getTraffic() != null){
                getTraffic().Add("sockin==null!!!!!");
            }
        }
        ip = socket.getLocalAddress().toString();
        String[] jp = ip.split("/");
        if (jp.length == 2) {
            ip = jp[1];
        } else {
            ip = jp[0];
        }
        if (IsConnected() == true) {
            connected = true;
            if(getTraffic() != null){
                getTraffic().Add("socket succesfully opened");
            }
            CHolePuncher.server = server;
            updates = new Timer();
            updates.schedule(new JCUpdateTask(this), 5, 10); //subsequent rate
            pingtask = new Timer();
            pingtask.schedule(new JCPingTask(this), 500, 8000); //subsequent rate
            socket.setSoTimeout(2500);
            return true;
        }
        /*} catch (UnknownHostException e) {
            //Log.error();
            //closeAndExit(1);
            traffic.add(e.toString());
            traffic.add("Unknown host error: " + server);
//            StackTraceElement[] si = e.getStackTrace();
//            for (int i = 0; i < si.length; i++) {
//                traffic.add(si[i].toString());
//            }
            
            throw new RuntimeException(e);
        } catch (IOException e) {
            //Log.error( + serverAddress);
            traffic.add(e.toString());
//            StackTraceElement[] si = e.getStackTrace();
//            for (int i = 0; i < si.length; i++) {
//                traffic.add(si[i].toString());
//            }
            
            throw new RuntimeException(e);
        } catch (Exception e) {
            traffic.add(e.toString());
            /*StackTraceElement[] si = e.getStackTrace();
            for (int i = 0; i < si.length; i++) {
                traffic.add(si[i].toString());
            }*/
        /*    throw new RuntimeException(e);
        }*/
        return false;
    }


    /**
     * Disconnects the connection to the server
     */
    public void Disconnect() {
        if (IsConnected()) {
            try {
                traffic_cache_out.clear();
                sockout.flush();
                socket.close();
                
                if(updates != null){
                    updates.cancel();
                    updates = null;
                }
                
                if(pingtask != null){
                    pingtask.cancel();
                    pingtask = null;
                }
                
                logged_in = false;
                CEvent e2 = new CEvent(CEventTypes.DISCONNECT);
                distributor.NewGUIEvent(e2);
            } catch (IOException ex) {
                if(getTraffic() != null){
                    getTraffic().Add(ex.toString());
                }
                StackTraceElement[] si = ex.getStackTrace();
                if(getTraffic() != null){
                    for (int i = 0; i < si.length; i++) {
                        getTraffic().Add(si[i].toString());
                    }
                }
            //traffic.add()
                //ex.printStackTrace();
            }
        }
    }

    //boolean available2=true;

    public void Update() {
        updatedone = false;
        second_interim++;
        if (this.second_interim == 101) {
            second_interim = 0;
        }

        for (int i = 0; i < 20; i++) {
            String s = GetNextLine();
            if (s != null) {
                if(getTraffic() != null){
                    getTraffic().Add("<<" + s);
                }
                CEvent e = new CEvent(s);
                distributor.NewEvent(e);
            }
        }
        if (!IsConnected()) {
            if (connected) {
                // DISCONNECTED!!!!!!!!!! AHK AHK AHK AHK
                CEvent e2 = new CEvent(CEventTypes.DISCONNECTED);
                distributor.NewGUIEvent(e2);
                logged_in = false;
            }
            //available2=true;
            // notifyAll();
            updatedone = true;
            return;
        } else {
            if (sockin != null) {
                try {
                    while (sockin.ready()) {
                        String s;
                        s = sockin.readLine();
                        if (s != null) {
                            messages.add(s);
                        //traffic.add("traffic recieved sent for processing:: " + s);
                            // here would usually be the whoel redirect code but
                            // I think it's best that be doen in the NewEvent
                            // function
                        } else {
                            break;
                        }
                    }
                } catch (SocketException ex) {
                    if(getTraffic() != null){
                        getTraffic().Add(ex.toString());
                        StackTraceElement[] si = ex.getStackTrace();
                        for (int i = 0; i < si.length; i++) {
                            getTraffic().Add(si[i].toString());
                        }
                    }
                    CEvent e2 = new CEvent(CEventTypes.DISCONNECTED);
                    distributor.NewGUIEvent(e2);
                    logged_in = false;
                } catch (IOException ex) {
                    if(getTraffic() != null){
                        getTraffic().Add(ex.toString());
                        StackTraceElement[] si = ex.getStackTrace();
                        for (int i = 0; i < si.length; i++) {
                            getTraffic().Add(si[i].toString());
                        }
                    }
                    CEvent e2 = new CEvent(CEventTypes.DISCONNECTED);
                    distributor.NewGUIEvent(e2);
                    logged_in = false;
                    
                }
                if (second_interim == 0) {
                    traffic_out_sent = 0;
                } else {
                    if (traffic_out_sent > max_traffic) {
                        updatedone = true;
                        return;
                    }
                }
                //synchronized(sockout){
                int i = 0;

                if(!socket.isClosed()){
//                    try {
                        while (traffic_cache_out.isEmpty() == false) {


                            if (i > 4) {
                                break;
                            }
                            i++;
                            String msg = traffic_cache_out.get(0);
                            traffic_out_sent += msg.length();
                            if (traffic_out_sent + msg.length() > max_traffic) {
                                break;
                            }
                            //synchronized (sockout) {
                            
                            // recheck the socket to see if it hasnt closed while the loops active
                            if(socket.isConnected()){
                                
                                sockout.println(msg);
                                if(sockout.checkError()){
                                    //
                                    CEvent e2 = new CEvent(CEvent.DISCONNECTED);
                                    distributor.NewGUIEvent(e2);
                                    logged_in = false;
                                }
//                                sockout.writeBytes(msg + "\n"); //println(msg);
                            }else{
                                break;
                            }
                            //}
    //                    if(sockout.checkError()){
    //                        int a = 5;
    //                    }
                            traffic_cache_out.remove(0);
                            if(getTraffic() != null){
                                getTraffic().Add(">>" + msg);
                            }

                        }
                        sockout.flush();
//                    } catch (java.net.SocketException e){
//                        //
//                        CEvent e2 = new CEvent(CEvent.DISCONNECTED);
//                        distributor.NewGUIEvent(e2);
//                        logged_in = false;
//                    }catch (IOException ex) {
//                        Logger.getLogger(CConnection.class.getName()).log(Level.SEVERE, null, ex);
//                        CEvent e2 = new CEvent(CEvent.DISCONNECTED);
//                        distributor.NewGUIEvent(e2);
//                        logged_in = false;
//                    }
                }

            //}
            }
        }
        updatedone = true;

    // available2=true;
        // notifyAll();
    }
    ArrayList<String> traffic_cache_out = new ArrayList<String>();
    int traffic_out_sent = 0;
    //boolean available3 = true;

    public void SendLine(String message) {
        //        while (available3 == false) {
//            try {
//                wait();
//            } catch (InterruptedException e) { }
//        }
//        available3 = false;
        if (IsConnected()) {
            traffic_cache_out.add(message);
        } else {
            if(getTraffic() != null){
                getTraffic().Add("Not connected could not send :: " + message);
            }
        }
    //        available3 = true;
    }
}