/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import aflobby.framework.CEvent;
import aflobby.framework.CBaseModule;
import aflobby.UI.CUserSettings;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;


class CGlestTask extends Thread {

    public CGlestBattleModel b;
    

    CGlestTask(CGlestBattleModel battle) {
        b = battle;
    }

    @Override
    public void run() {
        
        Process p;
        try {
            //b.ingame = true;
            String sp = CUserSettings.GetValue("glest.command", "glest");
            if(b.AmIHost()){
                sp += " -server";
            }else{
                sp += " -client ";
                sp += b.GetInfo().ip;
            }
            
            p = Runtime.getRuntime().exec(sp);
            
        
        
            b.LM.protocol.SetAway(false);
            b.LM.protocol.SetIngame(true);

            InputStream out = p.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(out));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }

            try {
                p.waitFor();
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        } catch (IOException ex) {
            //b.ingame = false;
            System.out.println(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.SpringTask.VistaUACError"));
            ex.printStackTrace();
            return;
        }

        b.LM.protocol.SetIngame(false);
//        }
        //b.LM.protocol.SendTraffic("GETINGAMETIME");
//        System.out.println("loop ended");
        //b.LM.protocol.SetIngame(false);
        b.Exit();
//        b.ingame = false;

        
        //if(b.info.isladdergame()){
        //    CMeltraxLadder.ReportGame(b.LM.protocol.GetUsername(), b.LM.protocol.Password());
        //}
    }
}

/**
 *
 * @author tarendai
 */
public class CGlestBattleModel extends CBaseModule implements IBattleModel {

    private CBattleInfo info = null;
    private CGlestBattleWindow battlewindow = null;
    private boolean ingame = false;
    
    public CGlestBattleModel(){
        
    }
    
    @Override
    public void NewEvent(final CEvent e){
        //
        if (e.IsEvent("CLIENTSTATUS")) {
            if (!AmIHost()) {
                if (info != null) {
                    if (e.data[1].equalsIgnoreCase(info.GetHost())) {
                        int status = Integer.parseInt(e.data[2]);
                        if (Misc.getInGameFromStatus(status) > 0) {
                            if (ingame == false) {
                                Start();
                            }
                        } else {
                            ingame = false;
                        }
                    }
                }
            }
        } else if (e.IsEvent("FORCEQUITBATTLE")) {
            LM.Toasts.AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.you_were_kicked_from_the_battle"));
            Exit();
        } else if (e.data[0].equalsIgnoreCase("BATTLECLOSED")) {
            if(info != null){
                if (info.GetID() == Integer.parseInt(e.data[1])) {
                    LM.Toasts.AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.Battle_closed"));
                    Exit();
                }
            }
        } else if (e.IsEvent("LEFTBATTLE")) {
            //LEFTBATTLE BATTLE_ID username
            if (Integer.parseInt(e.data[1]) == info.GetID()) {
                battlewindow.RemovePlayer(e.data[2]);
            }
        } else if (e.IsEvent("JOINEDBATTLE")) {
            int i = info.GetID();
            int j = Integer.parseInt(e.data[1]);
            if (i == j) {
                //JOINEDBATTLE BATTLE_ID username
                battlewindow.AddPlayer(e.data[2]);
            }
        }
        battlewindow.NewEvent(e);
    }

    public ArrayList<String> GetPlayerList() {
        return null;
    }

    public String GetHost() {
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

    public void Host(CBattleInfo i) {
        info = i;
        
        battlewindow = new CGlestBattleWindow(LM,this);
        battlewindow.Init(LM);
        
        battlewindow.AddPlayer(LM.protocol.GetUsername());
        
    }

    public void Join(CBattleInfo i) {
        info = i;
        
        battlewindow = new CGlestBattleWindow(LM,this);
        battlewindow.Init(LM);
        
        for(String n : i.GetPlayerNames()){
            battlewindow.AddPlayer(n);
        }
        
    }

    public void Exit() {
        LM.protocol.SendTraffic("LEAVEBATTLE");
        
        if (info != null) {
            info.SetActive(false);
            info = null;
        }
        battlewindow.dispose();
        battlewindow = null;
        
        LM.core.RemoveModule(LM.battleModel);
        LM.battleModel = null;
    }

    public CBattleInfo GetInfo() {
        return info;
    }

    public boolean Start() {
        
        CGlestTask g = new CGlestTask(this);
        g.start();
        
        return true;
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
        String s = "UPDATEBATTLEINFO 0 ";
        
        if(IsLocked()){
            s += "1 ";
        }else{
            s += "0 ";
        }
        
        s += "0 nomap";

        LM.protocol.SendTraffic(s);
    }

    public void SendChatMessage(String message) {
        LM.protocol.SendTraffic("SAYBATTLE  " + message);
    }

    public void SendChatActionMessage(String message) {
        LM.protocol.SendTraffic("SAYBATTLEEX  " + message);
    }

    public Map<String, Object> GetOptions() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Object GetOption(String option) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean HasOption(String option) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void PutOption(String option, Object value) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void RemoveOption(String option) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void RemoveAllOptions() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    

}
