/*
 * IProtocol.java
 *
 * Created on 10 June 2007, 01:00
 *
 * Battle Hub
 */

package org.darkstars.battlehub.framework.protocol;

import java.util.Map;
import org.darkstars.battlehub.framework.IModule;
import org.darkstars.battlehub.framework.IBattleInfo;

/**
 * 
 * @author Tom J. Nowell
 */
public interface IProtocol extends IModule {
    
    /**
     * 
     * @return
     */
    String GetProtocolName();
    
    /**
     * 
     * @return
     */
    int GetProtocolVersion();
    
    /**
     * 
     * @param username
     * @param password
     * @param sha_hash
     */
    void Login (String username, String password, boolean sha_hash);
    
    /**
     * 
     */
    void Logout ();
    
    /**
     * 
     * @return
     */
    boolean LoggedIn ();
    
    /**
     * 
     */
    void UserAFKAction();
    
    /**
     * 
     * @return
     */
    String GetUsername();
    
    /**
     * 
     * @return
     */
    String Password();
    
    /**
     * 
     * @return
     */
    int GetAccessLevel();
    
    
    
    /**
     * 
     * @param username
     * @param password
     * @param sha_hash
     */
    void Register (String username,String password, boolean sha_hash);
    
    /**
     * 
     * @param server
     * @param port
     * @return
     */
    boolean Connect (String server, int port);
    
    /**
     * 
     */
    void Disconnect ();
    
    /**
     * 
     * @return
     */
    boolean Connected ();
    
    /**
     * 
     * @param channelname
     * @param password
     */
    void JoinChannel (String channelname, String password);
    
    /**
     * 
     * @param channelname
     * @param reason
     */
    void LeaveChannel (String channelname, String reason);
    
    /**
     * 
     * @param s
     */
    void SendTraffic(String s);
    
    /**
     * 
     * @return
     */
    boolean IsIngame();
    
    /**
     * 
     * @return
     */
    boolean IsAway();
    
    /**
     * 
     * @param ingame
     */
    void SetIngame(boolean ingame);
    
    /**
     * 
     * @param away
     */
    void SetAway(boolean away);
    
    /**
     * 
     */
    void SendUserStatus();
    
    /**
     * 
     * @return
     */
    Map<Integer, IBattleInfo> GetBattles();
    
}
