/*
 * CPlayer.java
 *
 * Created on 28 May 2006, 12:12
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

/**
 *
 * @author AF
 */
public class CPlayer implements IModule{

    //extends Thread
    public  String  name;
    public  boolean hasIP       = false;
    private String  ip          = "?";
    public  boolean logged_in;
    private int     status      = 0;
    private String  statString  = "unknown";
    private String  cpu         = "?Mhz";
    private String  country     = "??";
    public  int     battleID    = 0;
    public  int     rank        = 0;

    /**
     * Creates a new instance of CPlayer
     * @param L 
     * @param pname 
     */
    public CPlayer(String pname) {
        name = pname;
        logged_in = true;
    }

    public void Update() {
    }

    public String GetStatushtml() {
        return statString;
    }

    public String GetRankHTML(ICentralClass c) {
        return "<img src = \"file:/"+ c.GetAbsoluteLobbyFolderPath() + "images/ranks_small/" + rank + ".png\"></img>";
    }

    public String GetSmallRankHTML(ICentralClass c) {
        return "<img src = \"file:/"+ c.GetAbsoluteLobbyFolderPath() + "images/ranks_small/" + rank + ".png\"></img>";
    }

    public String GetNormalRankHTML(ICentralClass c) {
        return "<img src = \"file:/"+ c.GetAbsoluteLobbyFolderPath() + "images/ranks/" + rank + ".png\"></img>";
    }

    public String GetFlagHTML(ICentralClass c) {
        return "<img src = \"file:/"+ c.GetAbsoluteLobbyFolderPath() + "images/flags/" + getCountry() + ".png\"></img>";
//        return "<img src=\"\"></img>";
    }

    public String GetSmallFlagHTML(ICentralClass c) {
        return "<img src = \"file:/"+ c.GetAbsoluteLobbyFolderPath() + "images/flags/" + getCountry() + ".png\"></img>";
//        return "<img src=\"\"></img>";
    }

    public String GetNormalFlagHTML(ICentralClass c) {
        return "<img src = \"file:/"+ c.GetAbsoluteLobbyFolderPath() + "images/flags/" + getCountry() + ".png\"></img>";
//        return "<img src=\"\"></img>";
    }

    public boolean IsIngame(){
        return (Misc.getInGameFromStatus(getStatus())==1);
    }
    
    
    public void NewEvent(final CEvent e) {
        //privmsg.NewEvent(e);
        if (e.IsEvent("CLIENTSTATUS")) {
            if (e.data[1].equalsIgnoreCase(name)) {
                setStatus(Integer.parseInt(e.data[2]));
                
            }
        } else if (e.IsEvent("CLIENTIPPORT")) {
            //  * CLIENTIPPORT username ip port
            setIp(e.data[2]);
        }
    }

    public void NewGUIEvent(final CEvent e) {
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        hasIP=true;
        this.ip = ip;
    }

    public String getCpu() {
        return cpu;
    }

    public void setCpu(String cpu) {
        this.cpu = cpu;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public boolean isBot(){
        //
        return Misc.getBotModeFromStatus(getStatus());
    }
    
    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
        rank = Misc.getRankFromStatus(status);
        if ((Misc.getAwayBitFromStatus(status) == 1) && (Misc.getInGameFromStatus(status) == 0)) {
            statString = "Away";
        } else if ((Misc.getAwayBitFromStatus(status) == 0) && (Misc.getInGameFromStatus(status) == 0)) {
            statString = "Online";
        } else {
            statString = "Ingame";
        }
    }

    public void Init(ICentralClass L) {
        //throw new UnsupportedOperationException("Not supported yet.");
    }

    public void OnRemove() {
        //throw new UnsupportedOperationException("Not supported yet.");
    }

    public void OnEvent(CEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void OnRemove(int channel) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
