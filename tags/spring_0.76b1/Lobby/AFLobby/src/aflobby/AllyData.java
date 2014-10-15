/*
 * AllyData.java
 *
 * Created on 20 March 2007, 19:02
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeMap;

public class AllyData {
    private TreeMap<Integer,AllyEntry> allyList;
    private HashMap<Integer,Integer> transformMap;
    private HashMap<Integer,Integer> untransformMap;
    private int allyCount = 0;
    
    public AllyData (ArrayList<CBattlePlayer> battlePlayers) throws Exception {
        allyList = new TreeMap<Integer,AllyEntry>();
        transformMap = new HashMap<Integer,Integer>();
        untransformMap = new HashMap<Integer,Integer>();
        
        try {
            for (int i=0;i<battlePlayers.size ();i++) {
                CBattlePlayer bp = battlePlayers.get (i);
                if (bp.isSpec()){
                    continue;
                }
                
                if (!transformMap.containsKey (bp.getAllyNo ())) {
                    transformMap.put (bp.getAllyNo (),allyCount);
                    untransformMap.put (allyCount, bp.getAllyNo ());
                    allyCount++;
                }
            }
            
            for (int i=0;i<battlePlayers.size ();i++) {
                CBattlePlayer bp = battlePlayers.get (i);
                if (bp.isSpec ()) continue;
                
                bp.setAllyNo (transformMap.get (bp.getAllyNo ()));
                
                if (!allyList.containsKey (bp.getAllyNo ())) {
                    AllyEntry ae = new AllyEntry ();
                    ae.setNumAllies (1);
                    
                    allyList.put (bp.getAllyNo (),ae);
                } else {
                    AllyEntry ae = allyList.get (bp.getAllyNo ());
                    
                    ae.setNumAllies (ae.getNumAllies ()+1);
                }
            }
        } catch (Exception e) {
            System.out.println (java.util.ResourceBundle.getBundle("aflobby/languages").getString("AllyData.ERROR_IN_ALLY_") + e);
        }
    }
    
    public TreeMap<Integer, AllyEntry> getAllyList () {
        return allyList;
    }
    
    public int getAllyCount () {
        return allyCount;
    }
    
    public int transform (int a){
        return transformMap.get (a);
    }
    
    public int untransform (int a){
        return untransformMap.get (a);
    }
}
