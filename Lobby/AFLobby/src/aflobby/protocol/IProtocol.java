/*
 * IProtocol.java
 *
 * Created on 10 June 2007, 01:00
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby.protocol;

import aflobby.framework.IModule;
import aflobby.UI.CView;
import aflobby.*;
import java.util.TreeMap;

/**
 *
 * @author Tom
 */
public interface IProtocol extends IModule {
    
    String GetProtocolName();
    int GetProtocolVersion();
    
    void Login (String username, String password, boolean sha_hash);
    void Logout ();
    boolean LoggedIn ();
    
    void UserAFKAction();
    
    String GetUsername();
    String Password();
    
    int GetAccessLevel();
    
    CView GetRegisterView ();
    
    /**

    @param username 
    @param password 
    @param sha_hash 
    */
    void Register (String username,String password, boolean sha_hash);
    
    boolean Connect (String server, int port);
    void Disconnect ();
    boolean Connected ();
    
    void JoinChannel (String channelname, String password);
    void LeaveChannel (String channelname, String reason);
    
    void SendTraffic(String s);
    
    boolean IsIngame();
    boolean IsAway();
    
    void SetIngame(boolean ingame);
    void SetAway(boolean away);
    
    void SendUserStatus();
    
    TreeMap<Integer, CBattleInfo> GetBattles();
    
}
