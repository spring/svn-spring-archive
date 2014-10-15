/*
 * CTASServerProtocol.java
 *
 * Created on 10 June 2007, 01:23
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby.protocol.tasserver;

import aflobby.CBattleInfo;
import aflobby.CBattleModel;
import aflobby.CChannelPassword;
import aflobby.CConnection;
import aflobby.framework.CEvent;
import aflobby.CGlestBattleModel;
import aflobby.CUnitSyncJNIBindings;
import aflobby.CUpdateChecker;
import aflobby.JRegView;
import aflobby.LMain;
import aflobby.Main;
import aflobby.Misc;
import aflobby.helpers.CStringHelper;
import aflobby.UI.CView;
import aflobby.UI.WarningWindow;
import aflobby.protocol.IProtocol;
import java.io.IOException;
import java.net.ConnectException;
import java.net.UnknownHostException;
import java.util.TreeMap;

/**
 *
 * @author Tom
 */
public class CTASServerProtocol implements IProtocol{
    private LMain LM;
    CConnection c = null;
    private String username="";
    private String password="";
    int status;
    int afk=0;
    private TreeMap<Integer, CBattleInfo> battles;
    
    /** Creates a new instance of CTASServerProtocol */
    public CTASServerProtocol () {
        battles = new TreeMap<Integer, CBattleInfo>();
    }
    
    public void Init (LMain L) {
        LM = L;
        
        
    }
    
    public void NewEvent (final CEvent e) {
        if(e.IsEvent("TASSERVER")){
            //c.Login (c.username,c.password);
            c.UDPSourcePort = Integer.parseInt (e.data[3]);
            String s = e.data[2];
            if(s.equals ("*")==false){
                //System.out.println ("TASSERVER "+e.parameters);
                /*if(CUnitSyncJNIBindings.loaded==false){
                    //
                    CSync.Setup(LM);
                }*/
                if(Main.ignorespringversion==false){
                    if(CUnitSyncJNIBindings.loaded){
                        String myversion = CUnitSyncJNIBindings.GetSpringVersion();
                        if(myversion.equalsIgnoreCase (s)==false){
                            //
                            SendTraffic ("REQUESTUPDATEFILE Spring "+myversion);//
                            //System.out.println("REQUESTUPDATE Spring "+myversion);
                        }
                    }
                }
                
            }
            CEvent e2 = new CEvent (CEvent.CONNECTED);
            LM.core.NewGUIEvent (e2);
        }else if(e.IsEvent ("OFFERFILE")){
            //OFFERFILE options {filename} {url} {description}
            
            final String[] t = e.parameters.split ("\t");
            System.out.println ("OFFERFILE "+e.parameters+" || "+t[1]);
            javax.swing.SwingUtilities.invokeLater (new Runnable () {
                public void run () {
                    new WarningWindow ("The server is offering us this file: <a href=\""+t[1]+"\">"+t[1]+"</a><br><br><br>"+t[2],
                        "Server Offering File"
                        ).setVisible (true);
                }
            });
            Disconnect ();
        }else if (e.IsEvent ("SERVERMSGBOX")){
            //System.out.println("SERVERMSGBOX "+e.parameters);
            javax.swing.SwingUtilities.invokeLater (new Runnable () {
                public void run () {
                    new WarningWindow ("Server Message: "+e.parameters,
                        "Server Message"
                        ).setVisible (true);
                }
            });
        }else if(e.IsEvent ("RING")){
            String ringer = e.parameters;
            String s = "<img src=\""+Misc.GetAbsoluteLobbyFolderPath ()+"/images/UI/alarm.gif\"></img><br><br><font face=\"Arial, Helvetica,Sans Serif\"> User: "+ringer+" wants your attention</font>";
            final WarningWindow w = new WarningWindow (s,ringer+ " Ringing",true);
            java.awt.EventQueue.invokeLater (new Runnable () {
                public void run () {
                    w.setVisible (true);
                }
            });
        } else if(e.IsEvent ("JOINFAILED")){
            if(e.parameters.contains("Wrong key")){
                javax.swing.SwingUtilities.invokeLater (new Runnable () {
                    public void run () {
                        CChannelPassword c = new CChannelPassword(LM,e.data[1]);
                        c.setVisible(true);
                    }
                });
            }else{
                LM.Toasts.AddMessage("ChannelJoin failed: "+e.parameters);
            }
                    //Toasts.AddMessage (Misc.makeSentence (e.data,0));
        } else if (e.IsEvent("OPENBATTLE")) {
            //if(!CUnitSyncJNIBindings.loaded){
            //    return;
            //}
            // create a battleinfo structure and pass it to the battle window and open it.
            Integer i = new Integer(e.data[1].trim());
            CBattleInfo b = GetBattles().get(i);
            if (b != null) {
                b.SetHost(GetUsername());
                
                if(b.getEngine().equals("spring")){
                    b.port = 8452;
                    LM.battleModel = new CBattleModel();
                } else if (b.getEngine().equals("glest")){
                    b.port = 61357;
                    LM.battleModel = new CGlestBattleModel();
                }
                
                LM.core.AddModule(LM.battleModel);
                
                LM.battleModel.Init(LM);
                LM.battleModel.Host(b);
            }
        } else if (e.IsEvent("JOINBATTLE")) {
            //if(!CUnitSyncJNIBindings.loaded){
            //    return;
            //}
            int i = Integer.parseInt(e.data[1]);
            CBattleInfo b = GetBattles().get(i);
            // JOINBATTLE BATTLE_ID startingmetal startingenery maxunits startpos gameendcondition limitdgun diminishingMMs ghostedBuildings hashcode
            // JOINBATTLE BATTLE_ID hashcode
            /*b.metal = Integer.parseInt(e.data[2]);
            b.energy = Integer.parseInt(e.data[3]);
            b.maxunits = Integer.parseInt(e.data[4]);
            b.startPos = Integer.parseInt(e.data[5]);
            b.gameEndCondition = Integer.parseInt(e.data[6]);
            b.limitDGun = CBattleWindow.InttoBool(Integer.parseInt(e.data[7]));
            b.diminishingMMs = CBattleWindow.InttoBool(Integer.parseInt(e.data[8]));
            b.ghostedBuildings = CBattleWindow.InttoBool(Integer.parseInt(e.data[9]));*/
            b.modhash = e.data[2];
            
            if (b != null) {
                
                if(b.getEngine().equals("spring")){
                    b.port = 8452;
                    LM.battleModel = new CBattleModel();
                } else if (b.getEngine().equals("glest")){
                    b.port = 61357;
                    LM.battleModel = new CGlestBattleModel();
                }
                
                LM.core.AddModule(LM.battleModel);
                
                LM.battleModel.Init(LM);
                LM.battleModel.Join(b);
            }
        } else if (e.IsEvent("JOINEDBATTLE")) {
            //if(!CUnitSyncJNIBindings.loaded){
            //    return;
            //}
            Integer i = new Integer(e.data[1]);
            if (i != null) {
                CBattleInfo b = GetBattles().get(i);
                if (b != null) {
                    b.AddPlayer(e.data[2]);
                }
            }
        } else if (e.IsEvent("LEFTBATTLE")) {
            //if(!CUnitSyncJNIBindings.loaded){
            //    return;
            //}
            Integer i = new Integer(e.data[1]);
            if (i != null) {
                CBattleInfo b = GetBattles().get(i);
                if (b != null) {
                    b.RemovePlayer(e.data[2]);
                }
            }
        } else if (e.IsEvent("JOINBATTLEFAILED")) {
            LM.Toasts.AddMessage(Misc.makeSentence(e.data, 0));
        } else if (e.IsEvent("OPENBATTLEFAILED")) {
            LM.Toasts.AddMessage(Misc.makeSentence(e.data, 0));
        } else if (e.data[0].equalsIgnoreCase("BATTLEOPENED")) {
            // Add!!!!!
            //if(!CUnitSyncJNIBindings.loaded){
            //    return;
            //}
            if (e.data[1] == null) {
                System.out.println("e.data[1] == null for:" + Misc.makeSentence(e.data, 0));
                return;
            }
            /*Integer i = new Integer (e.data[1].trim ());// Integer.getInteger(e.data[1].trim());
            if(i == null){
            LM.Toasts.AddMessage ("i == null for battles \""+e.data[1].trim ()+" \" in ::\n"+Misc.makeSentence (e.data,0));
            return;
            }*/
            /*Integer i = new Integer (e.data[1].trim ());// Integer.getInteger(e.data[1].trim());
            if(i == null){
            LM.Toasts.AddMessage ("i == null for battles \""+e.data[1].trim ()+" \" in ::\n"+Misc.makeSentence (e.data,0));
            return;
            }*/
            int i = Integer.parseInt(e.data[1]);

            //  BATTLEOPENED BATTLE_ID type natType founder IP port maxplayers passworded rank maphash {mapname} {title} {modname}
            final CBattleInfo b = new CBattleInfo(LM);
            //if(e.data[2].equalsIgnoreCase ("1")) return;
            b.type = Integer.parseInt(e.data[2]);
            b.natType = Integer.parseInt(e.data[3]);
            b.SetHost(e.data[4]);
            b.ip = e.data[5];
            b.port = Integer.parseInt(e.data[6]);
            b.maxplayers = Integer.parseInt(e.data[7]);
            b.SetPassworded(Misc.strToBool(e.data[8]));
            b.rank = Integer.parseInt(e.data[9]);
            b.maphash = e.data[10];
            

            String[] data = Misc.makeSentence(e.data, 0).split("\t");
            
            b.SetDescription(data[1]);
            
            if(data[1].startsWith("glest:")){
                b.setEngine("glest");
            }
            
            
            String m = Misc.makeSentence(data[0].split(" "), 11);
            b.SetMap(m);
            b.SetMod(data[2]);
            
//            if(b.GetMod().startsWith("glest:")){
//                //
//                b.setEngine("glest");
//            }
            
            b.SetID(i);
            GetBattles().put(new Integer(i), b);
            CEvent ev = new CEvent(CEvent.ADDEDBATTLE);
            ev.a = b;
            LM.core.NewEvent(ev);
            
        }if (e.IsEvent("BATTLECLOSED")) {
            //BATTLEOPENED
            // Add!!!!!
            //if(!CUnitSyncJNIBindings.loaded){
            //    return;
            //}
            if (e.data[1] == null) {
                return;
            }
            int k = Integer.parseInt(e.data[1].trim());
            GetBattles().remove(k); // BATTLE_ID username
        }
    }
    
    public void NewGUIEvent (final CEvent e) {
        if(e.IsEvent (CEvent.LOGGEDOUT)||e.IsEvent (CEvent.LOGOUT)){
            c.Disconnect ();
        } else if(e.IsEvent(CEvent.DISCONNECT) || e.IsEvent(CEvent.DISCONNECTED)){
            LM.protocol = null;
            LM.core.RemoveModule(this);
        }else {
            if(c != null){
                c.NewGUIEvent (e);
            }
        }
    }
    
    public void Update () {
    }
    
    public String GetProtocolName () {
        return "TASServer";
    }
    
    public int GetProtocolVersion () {
        return 33;
    }
    
    public void Login (String username, String password, boolean sha_hash) {
        this.username = username;
        this.password = password;
        if(sha_hash){
            password = CStringHelper.getSHA1Hash(password);
        }else{
            password = Misc.encodePassword (password);
        }
        String s = "LOGIN " + username + " " + password + " 0 " + c.ip + " "+CUpdateChecker.AFLobbyVersion;
        SendTraffic (s);
    }
    
    public void Logout () {
        Disconnect ();
    }
    
    public boolean LoggedIn () {
        return c.IsLoggedIn ();
    }
    
    public void UserAFKAction (){
        if(IsAway ()){
            // send an event signifying the user isnt afk anymore.
        }
        SetAway (false);
        afk = 0;
    }
    
    public boolean IsIngame (){
        return (Misc.getInGameFromStatus (status)==1);
    }
    
    public boolean IsAway (){
        return (Misc.getAwayBitFromStatus (status)==1);
    }
    
    public void SetIngame (boolean ingame){
        if(ingame){
            status = Misc.setInGameToStatus (status,1);
        }else{
            status = Misc.setInGameToStatus (status,0);
        }
        SendUserStatus ();
        //return false;
    }
    
    public void SetAway (boolean away){
        if(away){
            status = Misc.setAwayBitToStatus (status,1);
        }else{
            status = Misc.setAwayBitToStatus (status,0);
        }
        SendUserStatus ();
    }
    
    public void SendUserStatus (){
        //
        SendTraffic ("MYSTATUS "+status);
    }
    
    public CView GetRegisterView () {
        return new JRegView (LM);
    }
    
    public void Register (String username,String password, boolean sha_hash) {
        String p = password;
        if(sha_hash){
            p = CStringHelper.getSHA1Hash(password);
        }else{
            p = Misc.encodePassword(password);
        }
        SendTraffic ("REGISTER "+username+ " "+ p);
        Login (username,password, sha_hash);
    }
    
    public boolean Connect (String server, int port) {
        try {
            c = new CConnection(LM);
            boolean result = c.Connect(server, port);
            return result;
        } catch (UnknownHostException e) {
            LM.Toasts.AddMessage("Error, unknown server: "+e.getLocalizedMessage());
            CEvent ev = new CEvent(CEvent.DISCONNECTUNKNOWNHOST);
            LM.core.NewGUIEvent(ev);
        } catch (ConnectException e) {
            LM.Toasts.AddMessage("Error connecting: "+e.getLocalizedMessage());
            CConnection.traffic.add("Couldn't get I/O for the connection to: " + server + " \n" + e.getMessage() + "\n" + e.getLocalizedMessage());
        } catch (IOException e) {
            CConnection.traffic.add("Couldn't get I/O for the connection to: " + server + " \n" + e.getMessage() + "\n" + e.getLocalizedMessage());
        }
//        } catch (Exception e){
//            CConnection.traffic.add("Couldn't get I/O for the connection to: " + server + " \n" + e.getMessage() + "\n" + e.getLocalizedMessage());
//        }
        return false;
    }
    
    public void Disconnect () {
        if(c != null){
            c.Disconnect ();
            c = null;
        }
    }
    
    public boolean Connected () {
        return c.IsConnected ();
    }
    
    public void JoinChannel (String channelname, String password) {
        if(password == null){
            SendTraffic ("JOIN "+channelname);
        }else{
            SendTraffic ("JOIN "+channelname+" "+password);
        }
    }
    
    public void LeaveChannel (String channelname, String reason) {
        SendTraffic ("LEAVE "+channelname);
    }
    
    public void SendTraffic (String s) {
        c.SendLine (s);
    }
    
    public String GetUsername () {
        return username;
    }

    public String Password() {
        return password;
    }

    public int GetAccessLevel() {
        return Misc.getAccessFromStatus(status);
    }

    public TreeMap<Integer, CBattleInfo> GetBattles() {
        return battles;
    }
    
    public void OnRemove() {
        
        battles.clear();
        battles = null;
    }


}
