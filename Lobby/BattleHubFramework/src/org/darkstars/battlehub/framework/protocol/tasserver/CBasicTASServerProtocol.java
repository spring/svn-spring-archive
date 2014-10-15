/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework.protocol.tasserver;

import java.io.IOException;
import java.net.ConnectException;
import java.net.UnknownHostException;
import java.util.Map;
import java.util.TreeMap;
import org.darkstars.battlehub.framework.CBasicTASChannelModel;
import org.darkstars.battlehub.framework.CConnection;
import org.darkstars.battlehub.framework.CCore;
import org.darkstars.battlehub.framework.CEvent;
import org.darkstars.battlehub.framework.CEventTypes;
import org.darkstars.battlehub.framework.CStringHelper;
import org.darkstars.battlehub.framework.IBattleInfo;
import org.darkstars.battlehub.framework.ICentralClass;
import org.darkstars.battlehub.framework.Misc;
import org.darkstars.battlehub.framework.protocol.IProtocol;

/**
 *
 * @author AF-Standard
 */
public class CBasicTASServerProtocol implements IProtocol{
    
    private int afk = 0;
    private CConnection c = null;
    private Map<Integer, IBattleInfo> battles;
    private String username = "";
    private String password = "";
    private int status;
    private ICentralClass L;
    
    public CBasicTASServerProtocol(){
        battles = new TreeMap<Integer, IBattleInfo>();
    }

    @Override
    public String GetProtocolName() {
        return "TASServer";
    }

    @Override
    public int GetProtocolVersion() {
        return 33;
    }

    @Override
    public void Login(String username, String password, boolean sha_hash) {
        this.username = username;
        this.password = password;
        if (sha_hash) {
            password = CStringHelper.getSHA1Hash(password);
        } else {
            password = Misc.encodePassword(password);
        }
        String s = "LOGIN " + username + " " + password + " 0 " + c.ip + " framework";// + CUpdateChecker.version;
        SendTraffic(s);
    }

    @Override
    public void Logout() {
        Disconnect();
    }

    @Override
    public boolean LoggedIn() {
        return c.IsLoggedIn();
    }

    @Override
    public void UserAFKAction() {
        if (IsAway()) {
            // send an event signifying the user isnt afk anymore.
        }
        SetAway(false);
        afk = 0;
    }

    @Override
    public String GetUsername() {
        return username;
    }

    @Override
    public String Password() {
        return password;
    }

    @Override
    public int GetAccessLevel() {
        return Misc.getAccessFromStatus(status);
    }

    @Override
    public void Register(String username, String password, boolean sha_hash) {
        String p = password;
        if (sha_hash) {
            p = CStringHelper.getSHA1Hash(password);
        } else {
            p = Misc.encodePassword(password);
        }
        SendTraffic("REGISTER " + username + " " + p);
        Login(username, password, sha_hash);
    }

    @Override
    public void Disconnect() {
        if (c != null) {
            c.SendLine("EXIT");
            c.Disconnect();
            c = null;
        }
    }

    @Override
    public boolean Connected() {
        return c.IsConnected();
    }

    @Override
    public void JoinChannel(String channelname, String password) {
        if (password == null) {
            SendTraffic("JOIN " + channelname);
        } else {
            SendTraffic("JOIN " + channelname + " " + password);
        }
    }

    @Override
    public void LeaveChannel(String channelname, String reason) {
        SendTraffic("LEAVE " + channelname);

        CEvent e = new CEvent(CEventTypes.CHANNELCLOSED + " " + channelname);
        L.GetCore().NewGUIEvent(e);
    }

    @Override
    public void SendTraffic(String s) {
        c.SendLine(s);
        if(L.GetCore().HasChannelListeners(CCore.SENT_SERVER_TRAFFIC)){
            L.GetCore().FireEvent(new CEvent(s,false,CCore.SENT_SERVER_TRAFFIC));
        }
    }

    @Override
    public boolean IsIngame() {
        return (Misc.getInGameFromStatus(status) == 1);
    }

    @Override
    public boolean IsAway() {
        return (Misc.getAwayBitFromStatus(status) == 1);
    }

    @Override
    public void SetIngame(boolean ingame) {
        if (ingame) {
            status = Misc.setInGameToStatus(status, 1);
        } else {
            status = Misc.setInGameToStatus(status, 0);
        }
        SendUserStatus();
    //return false;
    }

    @Override
    public void SetAway(boolean away) {
        if (away) {
            status = Misc.setAwayBitToStatus(status, 1);
        } else {
            status = Misc.setAwayBitToStatus(status, 0);
        }
        SendUserStatus();
    }
    
    @Override
    public void SendUserStatus() {
        //
        SendTraffic("MYSTATUS " + status);
    }

    public Map<Integer, IBattleInfo> GetBattles() {
        return battles;
    }

    public void Init(ICentralClass L) {
        assert(L != null);
        this.L = L;
    }

    public void Update() {
        //
    }

    public void NewEvent(final CEvent e) {
        if (e.IsEvent("TASSERVER")) {
            c.UDPSourcePort = Integer.parseInt(e.data[3]);
        } else if (e.IsEvent("JOIN")){
            // we've just joined a channel
            
            // create a basic channel model
            CBasicTASChannelModel cmodel = new CBasicTASChannelModel();
            cmodel.SetName(e.data[1]);
            
            // create a new event signifying a channel has been joined put the 
            // channel model inside it to save us having to look up the channel 
            // model or recreate it later on
            CEvent event = new CEvent(CEventTypes.CHANNELJOINED);
            event.object = cmodel;
            
            // Issue the new event
            L.GetCore().NewEvent(event);
        }
    }

    public void NewGUIEvent(CEvent e) {
        if (e.IsEvent(CEventTypes.DISCONNECT) || e.IsEvent(CEventTypes.DISCONNECTED)) {
            L.GetCore().RemoveModule(this);
        } else if (e.IsEvent(CEventTypes.LOGGEDOUT) || e.IsEvent(CEventTypes.LOGOUT)) {
            c.Disconnect();
        }  else {
            if (c != null) {
                c.NewGUIEvent(e);
            }
        }
    }

    public void OnRemove() {
        battles.clear();
        battles = null;
    }

    @Override
    public boolean Connect(String server, int port) {
        try {
            c = new CConnection(L.GetCore());
            boolean result = c.Connect(server, port);
            return result;
        } catch (UnknownHostException e) {
            //LMain.Toasts.AddMessage("Error, unknown server: " + e.getLocalizedMessage());
            CEvent ev = new CEvent(CEventTypes.DISCONNECTUNKNOWNHOST);
            L.GetCore().NewGUIEvent(ev);
        } catch (ConnectException e) {
            //LMain.Toasts.AddMessage("Error connecting: " + e.getLocalizedMessage());
            CConnection.getTraffic().Add("Couldn't get I/O for the connection to: " + server + " \n" + e.getMessage() + "\n" + e.getLocalizedMessage());
        } catch (IOException e) {
            CConnection.getTraffic().Add("Couldn't get I/O for the connection to: " + server + " \n" + e.getMessage() + "\n" + e.getLocalizedMessage());
        }
//        } catch (Exception e){
//            CConnection.traffic.add("Couldn't get I/O for the connection to: " + server + " \n" + e.getMessage() + "\n" + e.getLocalizedMessage());
//        }
        return false;
    }

    public void OnEvent(CEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void OnRemove(int channel) {
        throw new UnsupportedOperationException("Not supported yet.");
    }



}
