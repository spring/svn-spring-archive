/*
 * JBattleInfo.java
 *
 * Created on 25 June 2006, 21:00
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jlobby;

import java.util.*;

/**
 *
 * @author AF
 */
public class JBattleInfo {
    
    /** Creates a new instance of JBattleInfo */
    public JBattleInfo() {
    }
    String name="";
    ArrayList<String> Players = new ArrayList<String>();
    String mapname="";
    String modname="";
    String modhash ="";
    String maphash = "";
    boolean locked = false;
    int maxplayers=5;
    boolean started;
    boolean passworded;
    String Description="";
    String host = "";
    void AddPlayer(String s){
        //
    }
    void RemovePlayer(String s){
        //
    }
    
}
