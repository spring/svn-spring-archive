package aflobby.protocol.tasserver;

import aflobby.*;
import java.util.HashMap;
import java.util.List;
import java.util.TreeMap;

/*
 * TeamData.java
 *
 * Created on 20 March 2007, 17:43
 *
 * Initially Created by Rayden for his autohost
 * Heavily modified by AF for AFLobby
 */
public class TeamData {

    private TreeMap<Integer, TeamEntry> teamList;
    HashMap<Integer, Integer> transformMap;
    private int teamCount = 0;

    public TeamData(List<CBattlePlayer> battlePlayers) throws Exception {
        teamList = new TreeMap<Integer, TeamEntry>();
        transformMap = new HashMap<Integer, Integer>();

        try {
            for (int i = 0; i < battlePlayers.size(); i++) {
                CBattlePlayer bp = battlePlayers.get(i);
                if (bp.isSpec()) {
                    continue;
                }
                if (!transformMap.containsKey(bp.getTeamNo())) {
                    transformMap.put(bp.getTeamNo(), teamCount);
                    teamCount++;
                }
            }

            for (int i = 0; i < battlePlayers.size(); i++) {
                CBattlePlayer bp = battlePlayers.get(i);
                if (bp.isSpec()) {
                    continue;
                }
                bp.setTeamNo(transformMap.get(bp.getTeamNo()));

                if (!teamList.containsKey(bp.getTeamNo())) {
                    TeamEntry te = new TeamEntry();
                    
                    te.setAllyNo(bp.getAllyNo());
                    
                    te.setHandicap(bp.getHandicap());
                    te.setSide(bp.getSideNumber());
                    
                    te.setTeamColor(bp.getColor());
                    te.setTeamLeader(i);
                    
                    te.setAI(bp.getAI());
                    te.setAIOwner(bp.getAIOwner());

                    teamList.put(bp.getTeamNo(), te);
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR IN TEAM " + e);
            e.printStackTrace();
        }
    }

    public TreeMap<Integer, TeamEntry> getTeamList() {
        return teamList;
    }

    public int getTeamCount() {
        return teamCount;
    }

    public int GetTeamNo(int i) {
        //
        return this.transformMap.get(i);
    }
}
