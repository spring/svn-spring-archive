/*
 * Created on 2005.8.14
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
public class SendFileThread extends Thread {
	private Client client;
	private long position;
	private ArchiveFile file;
	private int options; // b0 = execute (1 - run file once downloaded, 0 - don't run file)
		
    public SendFileThread(Client client, ArchiveFile file, int options) {
    	super("SendFileThread");
    	this.client = client;
    	this.client.sendingFile = true;
    	this.client.cancelTransfer = false;
    	this.file = file;
    	this.options = options;
    }
    
    public void run() {

    	position = 0;
    	byte[] buf = new byte[TASServer.UPLOAD_FILE_PACKET_SIZE];
    	
		try
		{
			int count;
			client.sendLine("FILE " + file.getFileSize() + " " + options + " " + file.getFilename());
			while (!client.cancelTransfer) {
				
				//***count = file.readBuffer(buf, new Long(position).intValue(), count);
				count = file.readBuffer(buf, new Long(position).intValue());
				StringBuffer data = new StringBuffer(count * 2);
				
				for (int i = 0; i < count; i++) {
					data.append(Misc.byteToHex(buf[i]));
				}
		
				client.sendLine("DATA " + data);
				position += count;
				if (position >= file.getFileSize()) break;
				
				// limit upload:
				sleep(1000 / (TASServer.MAX_DOWNLOAD_RATE / TASServer.UPLOAD_FILE_PACKET_SIZE));				
			}
			if (client.cancelTransfer) { // user or server cancelled the transfer
				client.sendLine("SERVERMSG Upload has been cancelled.");
			} else client.sendLine("SERVERMSG Upload complete.");
		}
		catch (Exception e)
		{
			if (TASServer.DEBUG > 0) System.out.println ("Sending of file was interrupted!");
		}  
		
		client.sendingFile = false; //*** is this OK? Should I synchronize it?
    }    
    
}
