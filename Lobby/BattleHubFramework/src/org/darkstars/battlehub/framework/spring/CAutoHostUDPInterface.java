/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.darkstars.battlehub.framework.spring;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.event.EventListenerList;

/**
 *
 * @author AF-Standard
 */
public class CAutoHostUDPInterface implements Runnable {

    private EventListenerList listeners = new EventListenerList();
    int port;
    DatagramSocket dsocket;
    DatagramPacket packet;
    byte[] buffer;
    boolean valid = false;
    Thread T;

    public CAutoHostUDPInterface(int port) {
        try {
            //
            this.port = port;

            // Create a socket to listen on the port.
            dsocket = new DatagramSocket(port);

            // Create a buffer to read datagrams into. If a
            // packet is larger than this buffer, the
            // excess will simply be discarded!
            buffer = new byte[2048];

            // Create a packet to receive data into the buffer
            packet = new DatagramPacket(buffer, buffer.length);
            
            T = new Thread(this);
            valid = true;
        } catch (SocketException ex) {
            Logger.getLogger(CAutoHostUDPInterface.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void start(){
        T.start();
    }
    
    public void stop(){
        T.interrupt();
    }
    
    @Override
    public void run() {
        //
        if (!valid) {
            return;
        }
        try {

            // Now loop forever, waiting to receive packets and printing them.
            while (true) {
                // Wait to receive a datagram
                dsocket.receive(packet);

                // Convert the contents to a string, and display them
                String msg = new String(buffer, 0, packet.getLength());
                fireEvent(packet.getAddress().getHostName() + ": " + msg);

                // Reset the length of the packet before reusing it.
                packet.setLength(buffer.length);
            }
        } catch (Exception e) {
            System.err.println(e);
        }
    }

    public synchronized void registerAnyEventListener(IAutoHostUDPListener i) {
        //
        listeners.add(IAutoHostUDPListener.class, i);
    }
    
    public synchronized void unregisterAnyEventListener(IAutoHostUDPListener i) {
        //
        listeners.remove(IAutoHostUDPListener.class, i);
    }

    private synchronized void fireEvent(final String e) {
        Object[] listenersArray = listeners.getListenerList();
        
        // loop through each listener and pass on the event if needed
        int numListeners = listenersArray.length;
        for (int i = 0; i < numListeners; i += 2) {
            if (listenersArray[i] == IAutoHostUDPListener.class) {
                // pass the event to the listeners event dispatch method
                ((IAutoHostUDPListener) listenersArray[i + 1]).NewAutoHostUDPString(e);
            }
        }
    }
}
