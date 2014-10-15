/*
 * CBattlePlayer.java
 *
 * Created on 20 September 2006, 22:38
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import aflobby.UI.CUserSettings;
import java.awt.Color;

/**
 *
 * @author AF
 */
public class CBattlePlayer {
    
    /**
     * Creates a new instance of CBattlePlayer
     */
    public CBattlePlayer() {
        battlestatus = 0;
        color = Color.decode(CUserSettings.GetValue("lastbattle.colour", String.valueOf(Color.blue.getRGB())));
    }
    
    /**
     * 
     * @param a
     */
    public CBattlePlayer(CBattlePlayer a) {
        
        this.setPlayername (a.getPlayername ());
        this.setPlayerData(a.getPlayerdata ());
        this.setBattlestatus(a.getBattlestatus ());
        this.setColor (a.getColor ());
        this.setIP (a.getIP ());
        this.setAI(a.getAI());
        this.setAIOwner(a.getAIOwner());
    }
    
    private String playername="";
    private CPlayer playerdata=null;//= new CPlayer();
    private String IP = "";
    
    /**
     * 
     */
    public int port = 8452;
    
    private Color color = Color.blue;
    private int battlestatus=0;
    private String AI = "";
    private String AIOwner = "";
    
    /**
     * 
     * @param ready
     */
    public void setReady(boolean ready) {
        if(ready){
            setBattlestatus(Misc.setReadyStatusOfBattleStatus(getBattlestatus(),1));
        }else{
            setBattlestatus(Misc.setReadyStatusOfBattleStatus(getBattlestatus(),0));
        }
    }
    /**
     * 
     * @return
     */
    public int getTeamNo(){
        return Misc.getTeamNoFromBattleStatus (getBattlestatus());
    }
    
    /**
     * 
     * @param team
     */
    public void setTeamNo(int team){
        setBattlestatus(Misc.setTeamNoOfBattleStatus (getBattlestatus(),team));
    }

    /**
     * 
     * @param playerdata
     */
    public void setPlayerdata(CPlayer playerdata) {
        this.playerdata = playerdata;
    }

    /**
     * 
     * @param playername
     */
    public void setPlayername(String playername) {
        this.playername = playername;
    }

    /**
     * 
     * @return
     */
    public int getHandicap() {
        return Misc.getHandicapFromBattleStatus(getBattlestatus());
    }

    /**
     * 
     * @param handicap
     */
    public void setHandicap(int handicap) {
        setBattlestatus(Misc.setHandicapOfBattleStatus(getBattlestatus(),handicap));
    }

    /**
     * 
     * @param color
     */
    public void setColor(Color color) {
        this.color = color;
    }

    /**
     * 
     * @param newbattlestatus
     */
    public void setBattlestatus(int newbattlestatus) {

        battlestatus = newbattlestatus;
    }

    /**
     * 
     * @return
     */
    public int getBattlestatus() {
        return battlestatus;
    }

    /**
     * 
     * @return
     */
    public boolean isReady() {
        if(Misc.getReadyStatusFromBattleStatus(getBattlestatus())==1){
            return true;
        }else{
            return false;
        }
    }

    /**
     * 
     * @param synced
     */
    public void SetSync(int synced){
        setBattlestatus(Misc.setSyncOfBattleStatus(getBattlestatus(), synced));
    }
    
    /**
     * 
     * @return
     */
    public String getPlayername() {
        return playername;
    }

    /**
     * 
     * @return
     */
    public CPlayer getPlayerdata() {
        return playerdata;
    }

    /**
     * 
     * @return
     */
    public Color getColor() {
        return color;
    }
    
    

    /**
     * 
     * @return
     */
    public boolean isSpec() {
        return Misc.getModeFromBattleStatus(getBattlestatus())==0;
    }
    
    /**
     * 
     * @return
     */
    public boolean IsAI(){
        return (getAI().equals("")==false);
    }

    /**
     * 
     * @param spectator
     */
    public void setSpectator(Boolean spectator) {
        //System.out.println("before:"+getBattlestatus());
        setBattlestatus(Misc.setModeOfBattleStatus(getBattlestatus(),spectator ? 0: 1));
        //System.out.println("after:"+getBattlestatus());
    }

    /**
     * 
     * @return
     */
    public String getSide() {
        return CSync.GetSideName(Misc.getSideFromBattleStatus (getBattlestatus()));
    }
    
    /**
     * 
     * @return
     */
    public int getSideNumber() {
        return Misc.getSideFromBattleStatus (getBattlestatus());
    }

    /**
     * 
     * @param side
     */
    public void setSide(int side) {
        setBattlestatus(Misc.setSideOfBattleStatus (getBattlestatus(),side));//this.side = side;
    }

    /**
     * 
     * @return
     */
    public int getAllyNo() {
        return Misc.getAllyNoFromBattleStatus (getBattlestatus());
    }

    /**
     * 
     * @param allynum
     */
    public void setAllyNo(int allynum) {
        setBattlestatus(Misc.setAllyNoOfBattleStatus (getBattlestatus(),allynum));
//        throw new UnsupportedOperationException("Not yet implemented");
    }

    /**
     * 
     * @return
     */
    public String getIP() {
        return IP;
    }

    /**
     * 
     * @param IP
     */
    public void setIP(String IP) {
        this.IP = IP;
    }

    private void setPlayerData (CPlayer p) {
        playerdata = p;
    }

    /**
     * 
     * @return
     */
    public String getAI() {
        return AI;
    }

    /**
     * 
     * @param AI
     */
    public void setAI(String AI) {
        this.AI = AI;
    }

    /**
     * 
     * @return
     */
    public String getAIOwner() {
        return AIOwner;
    }

    /**
     * 
     * @param AIOwner
     */
    public void setAIOwner(String AIOwner) {
        this.AIOwner = AIOwner;
    }
}
