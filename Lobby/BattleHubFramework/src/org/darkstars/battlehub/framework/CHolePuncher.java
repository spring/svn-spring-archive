package org.darkstars.battlehub.framework;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

/*
 * CHolePuncher.java
 *
 * Created on 27 April 2007, 01:52
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

/**
 *
 * @author Tom
 */
public class CHolePuncher {
    public static String server="";
    public static int port=8452;
    
    /** Creates a new instance of CHolePuncher */
    public CHolePuncher () {
    }
    
    public static boolean SendRequest (String username){
        return SendRequest(server, port, username);
    }
    
    public static boolean SendRequest (int myport, String username){
        return SendRequest(server, myport, username);
    }
    
    public static boolean SendRequest (String myServer, int myport, String username){
        try{
            DatagramSocket socket;
            DatagramPacket packet;
            InetAddress address;
            socket = new DatagramSocket ();
            address = InetAddress.getByName (myServer);
            byte message[] = username.getBytes ();
            packet = new DatagramPacket (message, message.length, address, myport);
            socket.send (packet);
            socket.close ();
        } catch(IOException io){
            return false;
        }
        return true;
    }
    
}
