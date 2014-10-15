/*
 * Created on 2005.6.16
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 * 
 * 
 * *** should any of the methods here be synchronized since they are used by different threads?
 * 
 * 
 */

/**
 * @author Betalord
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

import java.util.*;
import java.text.*;
import java.net.*;

public class Misc {
 	static public final byte EOL = 13;
 	static private String hex = "0123456789ABCDEF"; 
	
	public static String easyDateFormat (String format) {
		Date today = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		String datenewformat = formatter.format(today);
		return datenewformat;
    }
	
	/* puts together strings from sl, starting at sl[startIndex] */
	public static String makeSentence(String[] sl, int startIndex) {
		if (startIndex > sl.length-1) return "";
		
		String res = new String(sl[startIndex]);
		for (int i = startIndex+1; i < sl.length; i++) res = res.concat(" " + sl[i]);
		
		return res;
	}
	
	/* returns false if char is not an allowed character in the name of a channel, nickname, username, password, ... */
	public static boolean isValidChar(char c) {
		if (
		   ((c >= 48) && (c <= 57))  || // numbers
		   ((c >= 65) && (c <= 90))  || // capital letters
		   ((c >= 97) && (c <= 122)) || // letters
		   (c == 95) // underscore
		   ) return true; else return false;
	}
	
	/* returns false if name (of a channel, nickname, username, password, ...) is invalid */
	public static boolean isValidName(String name) {
		for (int i = 0; i < name.length(); i++) if (!isValidChar(name.charAt(i))) return false;
		return true;
	}
	
	public static String boolToStr(boolean b) {
		if (b) return "1"; else return "0";
	}
	
	public static boolean strToBool(String s) {
		if (s.equals("1")) return true; else return false;
	}

	public static char[] byteToHex(byte b) {
		char[] res = new char[2];
		res[0] = hex.charAt((b & 0xF0) >> 4);
		res[1] = hex.charAt(b & 0x0F);
		return res;
	}
	
	/* this method will return local IP address such as "192.168.1.100" instead of "127.0.0.1".
	 * Found it here: http://forum.java.sun.com/thread.jspa?threadID=619056&messageID=3477258
	 *  */
	public static String getLocalIPAddress() {
		try 
	    {
			Enumeration e = NetworkInterface.getNetworkInterfaces();
	 
	        while(e.hasMoreElements()) {
	        	NetworkInterface netface = (NetworkInterface) e.nextElement();
	            Enumeration e2 = netface.getInetAddresses();
	 
	            while (e2.hasMoreElements()) {
	            	InetAddress ip = (InetAddress) e2.nextElement();
			        if(!ip.isLoopbackAddress() && ip.getHostAddress().indexOf(":")==-1) {
			        	return ip.getHostAddress();
		    	    }
                }
	        }
	    } 
	    catch (Exception e) {
	    	return null;
	    }
	    return null;
	}
	
	public static long IP2Long(String IP) {
		long f1, f2, f3, f4;
		String tokens[] = IP.split("\\.");
		if (tokens.length != 4) return -1;
		try {
			f1 = Long.parseLong(tokens[0]) << 24;
			f2 = Long.parseLong(tokens[1]) << 16;
			f3 = Long.parseLong(tokens[2]) << 8;
			f4 = Long.parseLong(tokens[3]);
			return f1+f2+f3+f4;
		} catch (Exception e) {
			return -1;
		}
		
	}
	
	/* converts time (in miliseconds) to "<x> days, <y> hours and <z> minutes" string */
	public static String timeToDHM(long duration) {
		long temp = duration / (1000 * 60 * 60 * 24);
		String res = temp + " days, ";
		duration -= temp * (1000 * 60 * 60 * 24);
		temp = duration / (1000 * 60 * 60);
		res += temp + " hours and ";
		duration -= temp * (1000 * 60 * 60);
		temp = duration / (1000 * 60);
		res += temp + " minutes";
		return res;
	}
	
	/* various methods dealing with battleStatus: */
	
	public static int getSideFromBattleStatus(int battleStatus) {
	  return battleStatus & 0x1;
	}
	
	public static int getReadyStatusFromBattleStatus(int battleStatus) {
		return (battleStatus & 0x2) >> 1;
	}
	
	public static int getTeamNoFromBattleStatus(int battleStatus) {
		return (battleStatus & 0x3C) >> 2;
	}	
	
	public static int getAllyNoFromBattleStatus(int battleStatus) {
		return (battleStatus & 0x3C0) >> 6;
	}	
	
	public static int getModeFromBattleStatus(int battleStatus) {
		  return (battleStatus & 0x400) >> 10;
	}
	
	public static int getHandicapFromBattleStatus(int battleStatus) {
		return (battleStatus & 0x3F800) >> 11;
	}	
	
	public static int getTeamColorFromBattleStatus(int battleStatus) {
		return (battleStatus & 0x3C0000) >> 18;
	}
	
	public static int getSyncFromBattleStatus(int battleStatus) {
		return (battleStatus & 0xC00000) >> 22;
	}
	
	public static int setSideOfBattleStatus(int battleStatus, int side) {
		return (battleStatus & 0xFFFFFFFE) | side;
	}
	  
	public static int setReadyStatusOfBattleStatus(int battleStatus, int ready) {
		return (battleStatus & 0xFFFFFFFD) | (ready << 1);
	}

	public static int setTeamNoOfBattleStatus(int battleStatus, int team) {
		return (battleStatus & 0xFFFFFFC3) | (team << 2);
	}
	  
	public static int setAllyNoOfBattleStatus(int battleStatus, int ally) {
		return (battleStatus & 0xFFFFFC3F) | (ally << 6);
	}

	public static int setModeOfBattleStatus(int battleStatus, int mode) {
		return (battleStatus & 0xFFFFFBFF) | (mode << 10);
	}

	public static int setHandicapOfBattleStatus(int battleStatus, int handicap) {
		return (battleStatus & 0xFFFC07FF) | (handicap << 11);
	}
	
	public static int setTeamColorOfBattleStatus(int battleStatus, int color) {
		return (battleStatus & 0xFFC3FFFF) | (color << 18);
	}
	
	public static int setSyncOfBattleStatus(int battleStatus, int sync) {
		return (battleStatus & 0xFF3FFFFF) | (sync << 22);
	}
	
	/* various methods dealing with status: */
	
	public static int getInGameFromStatus(int status) {
		return status & 0x1;
	}
	
	public static int getAwayBitFromStatus(int status) {
		return (status & 0x2) >> 1;
	}
	
	public static int getRankFromStatus(int status) {
		return (status & 0x1C) >> 2;
	}

	public static int setInGameToStatus(int status, int inGame) {
		return (status & 0xFFFFFFFE) | inGame;
	}
	
	public static int setAwayBitToStatus(int status, int away) {
		return (status & 0xFFFFFFFD) | (away << 1);
	}
	
	public static int setRankToStatus(int status, int rank) {
		return (status & 0xFFFFFFE3) | (rank << 2);
	}

}
