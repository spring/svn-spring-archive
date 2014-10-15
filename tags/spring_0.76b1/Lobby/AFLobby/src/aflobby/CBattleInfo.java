/*
 * CBattleInfo.java
 *
 * Created on 25 June 2006, 21:00
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import java.util.ArrayList;


/**
 *
 * @author AF
 */
public class CBattleInfo {
    LMain LM;
    /**
     * Creates a new instance of CBattleInfo
     * @param L 
     */
    public CBattleInfo (LMain L) {
        LM = L;
    }
    //public String name="";
    private ArrayList<String> Players = new ArrayList<String>();
    private String mapname="";
    private String modname="";
    public String modhash ="";
    public String maphash = "";
    public boolean locked = false;
    public boolean isprivate = false;
    
    private boolean isladdergame=false;
    private CLadderProperties ladderproperties = null;
    
    public int maxplayers = 4;
    private boolean started;
    private boolean passworded;
    private String description="";
    private String host = "";
    public int natType=0;
    
    /**
     * If 0, no rank limit is set. If 1 or higher, only players with this rank
     * (or higher) can join the battle (Note: rank index 1 means seconds rank,
     * not the first one, since you can't limit game to players of the first
     * rank because that means game is open to all players and you don't have to limit it in that case).
     */
    public int rank;

    public int spectatorcount=0;

    private int ID;
    private boolean active=false;
    
    public String ip = "localhost";
    public int port = 8452;
    public int type=0;
    
    public int maxunits = 500;//new Integer (500); // max. units
    
    public boolean limitDGun;
    public boolean diminishingMMs;
    public boolean ghostedBuildings;
    
    public int metal = 1000;//new Integer (1000); // starting metal
    public int energy = 1000; // starting energy
    public int startPos; // 0 = fixed, 1 = random, 2 = choose in game
    public int gameEndCondition; // 0 = game continues if commander dies, 1 = game ends if commander dies
    
    private String engine = "spring"; // assume the engine is spring for now

    public boolean isJoinable(){
        if(Main.chat_only_mode){
            return false;
        }
        return aflobby.CContentManager.SupportsEngine(engine);

    }
    
    public String getEngine() {
        return engine;
    }

    public void setEngine(String engine) {
        this.engine = engine;
    }
    
    @Override
    public String toString(){
        //
        return description;
    }
    public boolean Active (){
        return active;
    }
    
    public void SetActive (boolean isactive){
        active=isactive;
    }
    
    private void Check (){
        if(Active ()){
            CEvent e = new CEvent(CEvent.BATTLEINFO_CHANGED);
            LM.core.NewGUIEvent(e);
        }
    }
    
    @SuppressWarnings("unchecked")
    public ArrayList<String> GetPlayerNames (){
        return (ArrayList<String>) Players.clone ();
    }
    
    public String GetHost (){
        return host;
    }
    
    public void SetHost (String s){
        host = s;
        AddPlayer (s);
    }
    
    public void SetMap (String map){
        if(mapname.equals (map)==false){
            mapname = map;
            Check ();
        }
    }
    
    public String GetMap (){
        return mapname;
    }
    
    public void SetMod (String mod){
        if(modname.equals (mod)==false){
            modname = mod;
            Check ();
        }
    }
    
    public String GetMod (){
        return modname;
    }
    
    public void SetPassworded (boolean pass){
        if(passworded != pass){
            passworded = pass;
            Check ();
        }
    }
    
    public boolean IsPassworded (){
        return passworded;
    }
    
    public void SetID (int i){
        ID = i;
        Check ();
    }
    
    public int GetID (){
        return ID;
    }
    
    public boolean IsIngame (){
        return started;
    }
    
    public void SetIngame (boolean ingame){
        if(started != ingame){
            started = ingame;
            Check ();
        }
    }
    
    public void SetDescription (String desc){
        if(desc.equalsIgnoreCase (description)==false){
            description = desc;
            Check ();
        }
    }
    
    public String GetDescription (){
        return description;
    }
    
    public void AddPlayer (String s){
        if(Players.contains (s)==false){
            Players.add (s);
            Check ();
        }
    }
    
    public void RemovePlayer (String s){
        Players.remove (s);
        Check ();
    }

    public boolean isladdergame() {
        return isladdergame;
    }

    public void setIsladdergame(boolean isladdergame) {
        this.isladdergame = isladdergame;
    }

    public CLadderProperties getLadderproperties() {
        if(isladdergame()){
            return null;
        }
        return ladderproperties;
    }

    public void setLadderproperties(CLadderProperties ladderproperties) {
        this.ladderproperties = ladderproperties;
        setIsladdergame(true);
    }
    
}
