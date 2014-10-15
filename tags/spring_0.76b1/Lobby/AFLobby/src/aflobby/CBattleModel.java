/*
 * CBattleModel.java
 * 
 * Created on 22-Aug-2007, 22:14:44
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import aflobby.UI.CUserSettings;
import java.awt.Color;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.SwingUtilities;


class CSpringTask extends Thread {

    public CBattleWindow b;

    CSpringTask(CBattleWindow battle) {
        b = battle;
    }
//    BufferedReader in = null;
//    PrintWriter out = null;

    @Override
    public void run() {
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                b.ReadyToggle.setSelected(false);
                if(b.battlemodel.AmIHost()){
                    b.GameStartButton.setEnabled(false);
                }
            }
        };
        b.battlemodel.GetMe().setReady(false);
        b.SendMyStatus();
        b.UpdateClientsNeeded = true;
        SwingUtilities.invokeLater(doWorkRunnable);
        Process p;
        try {
            b.ingame = true;
            String sp = CUserSettings.GetValue("springpath", "spring");
            p = Runtime.getRuntime().exec(sp + " script.txt"); //"settings.exe"); script.txt
            
            b.LM.protocol.SetAway(false);
            b.LM.protocol.SetIngame(true);
            
            InputStream out = p.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(out));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            
            p.waitFor();
            
        } catch (InterruptedException ex) {
            Logger.getLogger(CSpringTask.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            b.ingame = false;
            System.out.println(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.SpringTask.VistaUACError"));
            ex.printStackTrace();
        }
        
//ch.status = Misc.setReadyStatusOfBattleStatus (b.ch.status,0);
//        boolean loop = true;
//        try {
//            in = new BufferedReader (new InputStreamReader (p.getInputStream ()));
//        } catch (Exception e) {
//            System.out.println ("ERROR E1="+e);
//            loop = false;
//        }
//        if(loop){
//            while (loop==true) {
//                try {
//                    this.sleep (100);
//                    String springOutput = in.readLine ();
//                    if (springOutput != null){// continue;
//
//                    System.out.println ("SPRING OUTPUT="+springOutput);
//                    //                    if (springOutput.equalsIgnoreCase("GAME OVER")) {
//                    //                        shutdown = true;
//                    //                        clientReference.shutdownSpring();
//                    //                        continue;
//                    //                    }
//                    }
//                } catch (Exception e) {
//                    System.out.println ("ERROR="+e);
//                    loop = false;
//                }
//                try{
//                    p.exitValue ();
//                    loop = false;
//                }catch(Exception e){
//                    //
//                }
//            }
//        }else{

        Runnable doWorkRunnable2 = new Runnable() {
            public void run() {
                b.ReadyToggle.setSelected(false);
                if(b.battlemodel.AmIHost()){
                    b.GameStartButton.setEnabled(true);
                }
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable2);
//        }
        b.LM.protocol.SendTraffic("GETINGAMETIME");
//        System.out.println("loop ended");
        b.LM.protocol.SetIngame(false);
//        b.ingame = false;
        // we keep it flagged as ingame untill the host sends his/her status
        // saying they're no longer ingame or we may end up relaunchign spring.'
        b.Redraw();
        
        if(b.info.isladdergame()){
            CMeltraxLadder.ReportGame(b.LM.protocol.GetUsername(), b.LM.protocol.Password());
        }
    }
}

/**
 *
 * @author Tom
 */
public class CBattleModel extends CBaseModule implements IGUIBattleModel {
    CBattleInfo info;
    CBattleWindow battlewindow;
    java.util.TreeMap<String, CBattlePlayer> players = new TreeMap<String, CBattlePlayer>();
    java.util.TreeMap<String, CBattlePlayer> AIplayers = new TreeMap<String, CBattlePlayer>();
    CBattlePlayer me = null;
    
    boolean locked = false;
    
    ArrayList<String> AIs = new ArrayList<String>();
    
//    ArrayList<Strin
    
    public CBattleModel(){
    }
    
    @Override
    public void Init(LMain LM){
        this.LM = LM;
        battlewindow = new CBattleWindow(LM);
        //if()
    }

    /**
     * Sets the battle window proprty used to pass data and handle events
     * 
     * @param b an instance of CBattleWindow
     */
    public void SetBattleWindow(CBattleWindow b) {
        battlewindow = b;
    }

    @Override
    public void Update(){
        if(battlewindow != null){
            battlewindow.Update();
        }
    }
    
    @Override
    public void NewEvent(final CEvent e){
         if (e.IsEvent("UPDATEBATTLEINFO")) {
            if(!CUnitSyncJNIBindings.loaded){
                return;
            }
            // UPDATEBATTLEINFO BATTLE_ID SpectatorCount locked maphash {mapname}
            int i = Integer.parseInt(e.data[1].trim());
            
            CBattleInfo b = LM.protocol.GetBattles().get(i);
            
            if (b != null) {
                b.SetMap(Misc.makeSentence(e.data, 5));
                b.maphash = e.data[4]; //;//s[1];
                b.locked = CBattleWindow.InttoBool(Integer.valueOf(e.data[3]));
                b.spectatorcount = Integer.valueOf(e.data[2]);
                battlewindow.UpdateBattle();
            }
            //
        } else if (e.IsEvent("CLIENTBATTLESTATUS")) {
            
            // check if this user is already in the battle
            // if so then update details, else create a new CBattlePlayer object and put it in the treemap

            CBattlePlayer player = GetPlayer(e.data[1]);

                
            final int bstatus = Integer.parseInt(e.data[2]);
            final Color c = ColourHelper.IntegerToColor(Integer.parseInt(e.data[3]));

            player.setBattlestatus(bstatus);
            player.setColor(c);


            if(player == GetMe()){
                battlewindow.UpdateMyUIControls();
            }

            if(AmIHost()){
                SendUpdateBattle();
            }

            battlewindow.Redraw();
        } else if (e.IsEvent("HOSTPORT")) {
            info.port = Integer.parseInt(e.data[1]);
        } else if (e.IsEvent("CLIENTIPPORT")) {
            //  * CLIENTIPPORT username ip port
            GetPlayer(e.data[1]).port = Integer.parseInt(e.data[3]);

        } else if (e.IsEvent("REQUESTBATTLESTATUS")) {
            
            // send MYBATTLESTATUS
            
            int firstteam = GetFirstFreeTeam();
            int firstally = GetFirstFreeAlly();

            me.setAllyNo(firstally);
            me.setTeamNo(firstteam);
            me.setSpectator(false);
            me.setReady(false);
            
            battlewindow.cansend = true;
            
            battlewindow.SendMyStatus();
            
        } else if (e.IsEvent("UPDATEBOT")) {
            //UPDATEBOT BATTLE_ID name battlestatus teamcolor
            
            CBattlePlayer bp = GetAIPlayers().get(e.data[2]);
            
            if (bp == null) {
                return;
            }
            
            bp.setBattlestatus(Integer.valueOf(e.data[3]));
            bp.setColor(ColourHelper.IntegerToColor(Integer.valueOf(e.data[4])));
            battlewindow.Redraw();
            
        } else if (e.IsEvent("LEFTBATTLE")) {
            //LEFTBATTLE BATTLE_ID username
            
            if (Integer.parseInt(e.data[1]) == info.GetID()) {
                
                CBattlePlayer player = GetPlayer(e.data[2]);
                GetPlayers().remove(e.data[2]);

                if (info != null) {
                    if (info.Active()) {
                        SendUpdateBattle();
                        //Redraw();
                        battlewindow.Redraw();
                    }
                }
            }
            
        } else if (e.IsEvent("FORCEQUITBATTLE")) {
            LM.Toasts.AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.you_were_kicked_from_the_battle"));
            battlewindow.LeaveBattle();
            
        } else if (e.IsEvent("BATTLECLOSED")) {
            if (info.GetID() == Integer.parseInt(e.data[1])) {
                LM.Toasts.AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.Battle_closed"));
                battlewindow.LeaveBattle();
            }
            
        } else if (e.IsEvent("JOINEDBATTLE")) {
            if(!CUnitSyncJNIBindings.loaded){
                return;
            }
            
            int i = Integer.parseInt(e.data[1]);
            if (i == info.GetID()) {
                CBattlePlayer pl = new CBattlePlayer();
                pl.setPlayername(e.data[2]);
                pl.setBattlestatus(0);
                pl.setPlayerdata(LM.playermanager.GetPlayer(e.data[2]));
                pl.setColor(Color.BLUE);
                GetPlayers().put(e.data[2], pl);
                
                battlewindow.AddPlayer(pl);
                
                if(e.data[2].equals(LM.protocol.GetUsername())){
                    //
                    SetMe(pl);
                }
//                b.AddPlayer(e.data[2]);
            }
            
        } else if (e.IsEvent("UPDATEBATTLEDETAILS")) {
            // update the battle details
            // * UPDATEBATTLEDETAILS startingmetal startingenergy maxunits startpos gameendcondition limitdgun diminishingMMs ghostedBuildings
            
            battlewindow.setStartingMetal(Integer.parseInt(e.data[1]));
            battlewindow.setStartingEnergy(Integer.parseInt(e.data[2]));
            
            battlewindow.setMaxUnits(Integer.parseInt(e.data[3]));
            battlewindow.setStartPosType(Integer.parseInt(e.data[4]));
            
            battlewindow.setGameEnd(Integer.parseInt(e.data[5]));
            battlewindow.setLimitDGUN(Integer.parseInt(e.data[6])==1);
            battlewindow.setDiminMM(Integer.parseInt(e.data[7])==1);
            battlewindow.setGhostedBuildings(Integer.parseInt(e.data[8])==1);
            
        } else if (e.IsEvent("SETSCRIPTTAGS")){
            
            String[] pairs = e.parameters.split("\t");
            
            for(int i = 0; i< pairs.length; i++){
                
                String[] pair = pairs[i].split(" ");
                
                String key = pair[0];
                String value = pairs[i].substring(key.length());
                
                if(key.equalsIgnoreCase("GAME/StartMetal")){
                    battlewindow.setStartingMetal(Integer.parseInt(value));
                    
                } else if(key.equalsIgnoreCase("GAME/StartEnergy")){
                    battlewindow.setStartingEnergy(Integer.parseInt(value));
                    
                } else if(key.equalsIgnoreCase("GAME/MaxUnits")){
                    battlewindow.setMaxUnits(Integer.parseInt(value));
                    
                } else if(key.equalsIgnoreCase("GAME/StartPosType")){
                    battlewindow.setStartPosType(Integer.parseInt(value));
                    
                } else if(key.equalsIgnoreCase("GAME/GameMode")){
                    battlewindow.setGameEnd(Integer.parseInt(value));
                    
                } else if(key.equalsIgnoreCase("GAME/LimitDGun")){
                    battlewindow.setLimitDGUN(Integer.parseInt(value)==1);
                    
                } else if(key.equalsIgnoreCase("GAME/DiminishingMMs")){
                    battlewindow.setDiminMM(Integer.parseInt(value)==1);
                    
                } else if(key.equalsIgnoreCase("GAME/GhostedBuildings")){
                    battlewindow.setGhostedBuildings(Integer.parseInt(value)==1);
                    
                }
                
            }
        }
        if(battlewindow != null){
            battlewindow.NewEvent(e);
        }
    }
    
    @Override
    public void NewGUIEvent(final CEvent e){
        if(e.IsEvent(CEvent.BATTLEINFO_CHANGED)){
            battlewindow.Redraw();
        }
        if(battlewindow != null){
            battlewindow.NewGUIEvent(e);
        }
        
    }
    
    /**
     * 
     * @return An ArrayList containing all the players and AIs in the correct order
     */
    public ArrayList<CBattlePlayer> GetAllPlayers() {
        
        ArrayList<CBattlePlayer> a = new ArrayList<CBattlePlayer>();
        for (String z : info.GetPlayerNames()) {
            CBattlePlayer q = GetPlayers().get(z);
            if(q == null) continue;
            CBattlePlayer r = new CBattlePlayer(q);
            a.add(r);
        }
        
        for (String z : AIs) {
            CBattlePlayer q = GetAIPlayers().get(z);
            if(q == null) continue;
            CBattlePlayer r = new CBattlePlayer(q);
            a.add(r);
        }
        return a;
    }

    public TreeMap<String, CBattlePlayer> GetPlayers() {
        return players;
    }

    public TreeMap<String, CBattlePlayer> GetAIPlayers() {
        return AIplayers;
    }

    public CBattlePlayer GetPlayer(String player) {
        return players.get(player);
    }

    /**
     * Retrieves an AI battleplayer by name
     * @param ai - the name of the AI
     * @return the battleplayer object representing the AI or null
     */
    public CBattlePlayer GetAI(String ai) {
        return AIplayers.get(ai);
        //throw new UnsupportedOperationException("Not supported yet.");
    }

    /**
     * 
     * @return the username of the host
     */
    public String GetHost() {
        if(info == null) return "";
        return info.GetHost();
    }
    
    /**
     * 
     * @return a boolean representing wether you are the host of this battle
     */
    public boolean AmIHost(){
        if(info == null){
            return false;
        }
        return GetHost().equalsIgnoreCase(LM.protocol.GetUsername());
    }

    /**
     * 
     * @return an ordered ArrayList of nonAI players 
     */
    public ArrayList<String> GetPlayerList() {
        return info.GetPlayerNames();
    }

    /**
     * 
     * @return an ordered ArrayList of AIs
     */
    public ArrayList<String> GetAIList() {
        return AIs;
    }

    public void RemoveAI(String name) {
        AIs.remove(name);
        AIplayers.remove(name);
    }

    public void AddAI(String name, CBattlePlayer p) {
        AIplayers.put(name, p);
        AIs.add(name);
    }

    public CBattlePlayer GetMe() {
        return me;
    }

    public void SetMe(CBattlePlayer p) {
        me = p;
    }

    public int GetFirstFreeTeam() {
//        if(AmIHost()){
//            return 0;
//        }
        int firstteam = 0;
        ArrayList<CBattlePlayer> a = GetAllPlayers();
        Iterator<CBattlePlayer> i = a.iterator();
        while (i.hasNext()) {
            CBattlePlayer pl = i.next();
            if (pl.isSpec()) {
                continue;
            }
//            if (pl.getPlayername().equals(LM.protocol.GetUsername())) {
////                if(pl.getAI().isEmpty()){
//                    break;
////                }
//            }
            if (pl.getTeamNo() == firstteam) {
                firstteam++;
                i = a.iterator();
            }
        }
        return firstteam;
    }

    public int GetFirstFreeAlly() {
//        if(AmIHost()){
//            return 0;
//        }
        int firstally = 0;
        ArrayList<CBattlePlayer> a = GetAllPlayers();
        Iterator<CBattlePlayer> i = a.iterator();
        while (i.hasNext()) {
            CBattlePlayer pl = i.next();
            if (pl.isSpec()) {
                continue;
            }
//            if (pl.getPlayername().equals(LM.protocol.GetUsername())) {
//                break;
//            }
            if (pl.getAllyNo() == firstally) {
                firstally++;
                i = a.iterator();
            }
        }
        return firstally;
    }
    
    public void CheckSync() {
        int synced = 1;
        if (!AmIHost()) {
            String m = info.GetMod();
            String mh = info.modhash;
            String mh2 = CSync.GetModHashbyName(m);
            if (info == null) {
                synced = 0;
                System.out.println(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.mhinfo_==_null"));
            } else if (m == null) {
                synced = 0;
                System.out.println(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.mh2_==_null"));
            } else if (mh == null) {
                synced = 0;
                System.out.println(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.mh_==_null"));
            } else if (mh2 == null) {
                synced = 0;
                System.out.println(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.mh2_==_null"));
            } else if (mh2.equals("")) {
                synced = 2;
                //System.out.println ("mh2 : "+mh2+" and mh : " + mh);
            }
        }
        GetMe().SetSync(synced);
//        me.setBattlestatus(Misc.setSyncOfBattleStatus(me.getBattlestatus(), synced));
    }

    public void Host(CBattleInfo i) {
        info = i;
        me = new CBattlePlayer();
        battlewindow.HostGame(info);
    }

    public void Join(CBattleInfo i) {
        info = i;
        battlewindow.JoinBattle(info);
    }

    public void Exit() {
        LM.protocol.SendTraffic("LEAVEBATTLE");
        GetPlayers().clear();
        if (info != null) {
            info.SetActive(false);
            info = null;
        }
        LM.core.RemoveModule(LM.battleModel);
        LM.battleModel = null;
        
    }

    public CBattleInfo GetInfo() {
        return info;
    }

    public boolean Start() {
        String s = battlewindow.GetScript();
        //if(Misc.isWindows()){
        // write out script
        try {
            PrintStream out = new PrintStream(new BufferedOutputStream(new FileOutputStream("script.txt", false))); //"file:"springpath.getText()+
            out.print(s);
            out.close();
            new CSpringTask(battlewindow).start();
            return true;
            //java.awt.EventQueue.invokeLater (new CSpringTask (this));
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void SetLocked(boolean locked) {
        if(info.locked != locked){
            info.locked = locked;
            SendUpdateBattle();
        }
    }

    public boolean IsLocked() {
        return info.locked;
    }
    
    public void SendUpdateBattle() {
        //* UPDATEBATTLEINFO BATTLE_ID SpectatorCount locked maphash {mapname}
        String s = "UPDATEBATTLEINFO ";
        //s += info.GetID() + " ";
        info.spectatorcount = battlewindow.GetSpectatorCount();
        s += info.spectatorcount + " ";
        if(IsLocked()){
            s += "1 ";
        }else{
            s += "0 ";
        }
        s += info.maphash + " ";
        String m = info.GetMap();
        s += m;
        LM.protocol.SendTraffic(s);
    }

    public void SendChatMessage(String message) {
        LM.protocol.SendTraffic("SAYBATTLE  " + message);
    }

    public void SendChatActionMessage(String message) {
        LM.protocol.SendTraffic("SAYBATTLEEX  " + message);
    }
    //
}
