/*
 * Created on 2005.6.17
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 * 
 * ---- NOTES ----
 * - Each account is uniquely identified by its username (I also used int ID in previous versions,
 *   but since all usernames must be unique, we don't need another unique identifier).
 */

/**
 * @author Betalord
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Account {

	/*
	 *
	 * access levels (first 3 bits of int access):
	 * 0 - none (should not be used for logged-in clients)
	 * 1 - normal (limited)
	 * 2 - privileged
	 * 3 - admin 
	 * 4, 5, 6, 7 - "reserved for future use"
	 * 
	 * in-game time bits (next 13 bits) tell how many minutes did client
	 * spend in-game.
	 * 
	 * all other bits are unused ("reserver for future use")
	 * 
	 */
	
	
	/*
	 * current rank categories:
	 * < 5h = newbie
	 * 5h - 15h = beginner
	 * 15h - 30h = avarage player
	 * 30h - 100h = experienced player
	 * > 100h = highly experienced player
	 * 
	 * */
	private static int rank1Limit = 60*5; // in minutes
	private static int rank2Limit = 60*15; // in minutes
	private static int rank3Limit = 60*30; // in minutes
	private static int rank4Limit = 60*100; // in minutes
	
	public String user;
	public String pass;
	public int access; // access type. Bit 31 must be 0 (due to int being signed number - we don't want to use any binary complement conversions).
	
	public Account(String user, String pass, int access)
	{
		this.user = user;
		this.pass = pass;
		this.access = access;
	}
	
	public Account(Account acc) {
		this.user = new String(acc.user);
		this.pass = new String(acc.pass);
		this.access = acc.access;
	}
	
	public String toString() {
		return user + " " + pass + " " + Integer.toString(access, 2); 
	}
	
	public int accessLevel() {
		return access & 0x7;
	}

	public int getInGameTime() {
		return (access & 0xFFF8) >> 3;
	}
	
	public void setInGameTime(int mins) {
		access = (access & 0xFFFF0007) | (mins << 3);
	}

	public int getRank() {
		if (getInGameTime() >= rank4Limit) return 4;
		else if (getInGameTime() > rank3Limit) return 3;
		else if (getInGameTime() > rank2Limit) return 2;
		else if (getInGameTime() > rank1Limit) return 1;
		else return 0;
	}
	
	/* adds mins minutes to client's in-game time (this time is used to calculate 
	 * player's rank). Returns true if player's rank was changed, false otherwise. */
	public boolean addMinsToInGameTime(int mins) {
		if (getInGameTime() >= rank4Limit) return false;
		if (getInGameTime() + mins >= rank4Limit) {
			setInGameTime(rank4Limit);
			return true;
		}
		else {
			int tmp = getRank();
			setInGameTime(getInGameTime() + mins);
			return tmp != getRank();
		}
	}
	
	/* returns access as normal (non-admin) user would have */
	public static int getNormalAccess() {
		return 1;
	}
	
	public static int getPrivilegedAccess() {
		return 2;
	}
		
	public static int getAdminAccess() {
		return 3;
	}
	
}
