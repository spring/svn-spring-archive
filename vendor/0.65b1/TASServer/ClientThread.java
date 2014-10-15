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

public class ClientThread extends Thread {
	private Client client;
	
    public ClientThread(Client client) {
    	super("ClientThread");
    	this.client = client;
    }
    
    public void run() {

   	    String inputLine;
   	    
		try
		{
	   	    client.sendWelcomeMessage();
			
			while (true) {
				inputLine = client.readLine();
				
				if (inputLine == null) throw new IOException();
				TASServer.tryToExecCommand(inputLine, client);
			}
		}
		catch (InterruptedIOException e)
		{
			if (TASServer.DEBUG > 0) System.out.println ("Timeout occurred - killing connection");
			TASServer.killClient(client); 
		}    	    
		catch (IOException e)
		{
			if (TASServer.DEBUG > 0) System.out.println ("Socket disconnected - killing connection");
			TASServer.killClient(client); 
		}   
		catch (Exception e)
		{
			if (TASServer.DEBUG > 0) System.out.println ("Unknown socket error - killing connection");
			TASServer.killClient(client); 
		}   
    }    

}
