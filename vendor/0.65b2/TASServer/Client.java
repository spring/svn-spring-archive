/*
 * Created on 2005.6.17
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

/**
 * @author Betalord
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

import java.io.*;
import java.net.*;
//import java.util.*;

public class Client {

	public Account account;
	public String IP;
	public int status; // see MYSTATUS command for actual values of status
	public int battleStatus; // see MYBATTLESTATUS command for actual values of battleStatus
	public int battleID; // battle ID in which client is participating. Must be -1 if not participating in any battle.
	public boolean sendingFile; // true if we are sending some file to this client
	public boolean cancelTransfer; // we use it to signal the SendFileThread to stop sending file
	public Socket socket;
    private PrintWriter out;
    private BufferedReader in;	
	public ClientThread thread;
	public long inGameTime;
	public String country;
	public int cpu; // in MHz if possible, or in MHz*1.4 if AMD. 0 means the client can't figure out it's CPU speed.
	
	public Client(Socket socket) {
		account = new Account("", "", 0); // no info on user/pass, zero access
		sendingFile = false;
		this.socket = socket;
		IP = socket.getInetAddress().getHostAddress();
		// this fixes the issue with local user connecting to server as "127.0.0.1" (he can't host battles with that IP):
		if (IP.equals("127.0.0.1") || IP.equals("localhost")) {
			String newIP = Misc.getLocalIPAddress();
			if (newIP != null) IP = newIP; else {
				System.out.println("Could not resolve local IP address. User may have problems \n" +
								   "with hosting battles.");
			}
		}
		status = 0;
		country = IP2Country.getCountryCode(Misc.IP2Long(IP));
		battleStatus = 0;
		inGameTime = 0;
	    try {
	    	out = new PrintWriter(socket.getOutputStream(), true);
	    	in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
	    } catch (IOException e) {
    	    System.out.println("Error: cannot associate input/output with client socket!");
    	    System.exit(1);
    	}
	    battleID = -1;
	    cpu = 0;
	}
	
	/* only client's own thread is allowed to call this method! */
	public String readLine() throws IOException {
		return in.readLine();
	}
	
	public synchronized void sendLine(String text) {
		if (TASServer.DEBUG > 1) 
			if (account.accessLevel() != 0) System.out.println("[->" + account.user + "]" + " \"" + text + "\"");
			else System.out.println("[->" + IP + "]" + " \"" + text + "\"");
		try {
			out.println(text);
		} catch (Exception e) {
			System.out.println("Error writing to socket. Line not sent! Killing the client ...");
			TASServer.killClient(this);
		}
	}

	public synchronized void sendWelcomeMessage() {
		sendLine("TASServer " + TASServer.VERSION);
	}
	
	/* should only be called by TASServer.killClient() method! */
	public synchronized void disconnect() {
		try {
			if (!socket.isClosed()) {
	    	    out.close();
	    	    in.close();
	    	    socket.close();
			}
		} catch (IOException e) {
			System.out.println("Error: cannot disconnect socket!");
		}
	}
}
