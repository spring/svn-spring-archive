/*
 * IBattleModel.java
 * 
 * Created on 22-Aug-2007, 22:15:03
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import aflobby.framework.IModule;
import java.util.ArrayList;
/**
 *
 * @author Tom
 */
public interface IBattleModel extends IModule{
    
    public ArrayList<String> GetPlayerList();
    
    
    public String GetHost();
    public boolean AmIHost();
    
    public void Host(CBattleInfo i);
    public void Join(CBattleInfo i);
    
    public CBattleInfo GetInfo();
    
    public boolean Start();
    
    public void SetLocked(boolean locked);
    public boolean IsLocked();
    
    public void SendUpdateBattle();
    
    public void SendChatMessage(String message);
    public void SendChatActionMessage(String message);
    
    public void Exit();
}
