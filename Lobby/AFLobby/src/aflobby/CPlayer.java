/*
 * CPlayer.java
 *
 * Created on 28 May 2006, 12:12
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import aflobby.framework.CEvent;

/**
 *
 * @author AF
 */
public class CPlayer {

    //extends Thread
    public String name;
    public LMain LM;
    public boolean hasIP=false;
    private String ip = "?";
    public boolean logged_in;
    private int status = 0;
    public String statString = "unknown";
    private String cpu = "?Mhz";
    private String country = "??";
    public int battleID = 0;
    public int rank = 0;

    /**
     * Creates a new instance of CPlayer
     * @param L 
     * @param pname 
     */
    public CPlayer(LMain L, String pname) {
        LM = L;
        name = pname;
        logged_in = true;
    }

    public void Update() {
    }

    public String GetStatushtml() {
        return statString;
    }

    public String GetRankHTML() {
        return "<img src = \"file:/"+ Misc.GetAbsoluteLobbyFolderPath() + "images/ranks_small/" + rank + ".png\"></img>";
    }

    public String GetSmallRankHTML() {
        return "<img src = \"file:/"+ Misc.GetAbsoluteLobbyFolderPath() + "images/ranks_small/" + rank + ".png\"></img>";
    }

    public String GetNormalRankHTML() {
        return "<img src = \"file:/"+ Misc.GetAbsoluteLobbyFolderPath() + "images/ranks/" + rank + ".png\"></img>";
    }

    public String GetFlagHTML() {
        return "<img src = \"file:/"+ Misc.GetAbsoluteLobbyFolderPath() + "images/flags/" + getCountry() + ".png\"></img>";
//        return "<img src=\"\"></img>";
    }

    public String GetSmallFlagHTML() {
        return "<img src = \"file:/"+ Misc.GetAbsoluteLobbyFolderPath() + "images/flags/" + getCountry() + ".png\"></img>";
//        return "<img src=\"\"></img>";
    }

    public String GetNormalFlagHTML() {
        return "<img src = \"file:/"+ Misc.GetAbsoluteLobbyFolderPath() + "images/flags/" + getCountry() + ".png\"></img>";
//        return "<img src=\"\"></img>";
    }

    public boolean IsIngame(){
        return (Misc.getInGameFromStatus(getStatus())==1);
    }
    
    
    public void NewEvent(final CEvent e) {
        //privmsg.NewEvent(e);
        if (e.data[0].equalsIgnoreCase("CLIENTSTATUS")) {
            if (e.data[1].equalsIgnoreCase(name)) {
                setStatus(Integer.parseInt(e.data[2]));
                
            }
        } else if (e.data[0].equalsIgnoreCase("CLIENTIPPORT")) {
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
}
