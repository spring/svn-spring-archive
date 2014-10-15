/*
 * IBattleModel.java
 * 
 * Created on 22-Aug-2007, 22:15:03
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import java.util.ArrayList;
import java.util.TreeMap;
/**
 *
 * @author Tom
 */
public interface IGUIBattleModel extends IBattleModel{
    public void SetBattleWindow(CBattleWindow b);
    public ArrayList<CBattlePlayer> GetAllPlayers();
    
    public ArrayList<String> GetPlayerList();
    public ArrayList<String> GetAIList();
    
    public TreeMap<String, CBattlePlayer> GetPlayers();
    public TreeMap<String, CBattlePlayer> GetAIPlayers();
    public CBattlePlayer GetMe();
    public void SetMe(CBattlePlayer p);
    
    public CBattlePlayer GetPlayer(String player);
    public CBattlePlayer GetAI(String ai);
    
    public String GetHost();
    public boolean AmIHost();
    
    public void AddAI(String name, CBattlePlayer p);
    public void RemoveAI(String name);
    
    public int GetFirstFreeTeam();
    public int GetFirstFreeAlly();
    
    public void CheckSync();
}
