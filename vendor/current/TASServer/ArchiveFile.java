/*
 * Created on 2005.8.15
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 * 
 * 
 * All threads should use ArchiveFile to read data from archive file,
 * since it is synchronized. Also, all archive files get open once server
 * is started and get closed once server is stopped.
 * 
 */

/**
 * @author Betalord
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

import java.io.*;

public class ArchiveFile {
	private String filename;
	private File file;
	private RandomAccessFile raf;
	
	/* make sure file actually exists before calling constructor! */
	public ArchiveFile(String filename) {
		this.filename = new String(filename);
		this.file = new File("./files/" + filename);
		try {
			this.raf = new RandomAccessFile(this.file, "r");
		} catch (Exception e) {
			return ;
		}
		
	}
	
	public synchronized String getFilename() {
		return filename;
	}
	
	public synchronized long getFileSize() {
		return file.length();
	}
	
	public synchronized boolean fileExists() {
		return file.exists();
	}
	
	/* to read first byte in the file, pos should be 0 (not 1) */
	public synchronized int readBuffer(byte[] buffer, int pos) {
		try {
			raf.seek(pos);
			int i = raf.read(buffer);
			return i;
		} catch (IOException e) {
			return -1;
		}
	}
	
	protected void finalize() throws Throwable {
	    try {
	    	raf.close();
	    } finally {
	        super.finalize();
	    }
	}	
	

	
}
