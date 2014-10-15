/*
 * Created on 2005.6.19
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

import java.util.Vector;

public class Channel {
	public String name;
	private String topic;
	public Vector clients; // clients connected to this channel 
	
	public Channel(String channelName) {
		name = new String(channelName);
		topic = "";
		clients = new Vector();
	}
	
	public String getTopic() {
		return topic;
	}
	
	public boolean setTopic(String newTopic) {
		if (newTopic.trim().equals("*")) {
			topic = "";
			return false;
		}
		topic = newTopic.trim();
		if (TASServer.DEBUG > 1) System.out.println("* Topic for #" + name + " changed to '" + topic + "'");
		return true;
	}
	
	public boolean isTopicSet() {
		return !(topic.equals(""));
	}
	
	/* adds a new client to the listeners of this channel */
	public void addClient(Client client) {
		if (isClientInThisChannel(client)) return ; // already in the channel! 

		clients.add(client);
	}
	
	public boolean removeClient(Client client) {
		return clients.remove(client);
	}
	
	public boolean isClientInThisChannel(Client client) {
		return (clients.indexOf(client) != -1);
	}
	
	/* sends s to all clients in this channel */
	public void sendLineToClients(String s) {
		for (int i = 0; i < clients.size(); i++)
			((Client)clients.get(i)).sendLine(s);
	}
}
