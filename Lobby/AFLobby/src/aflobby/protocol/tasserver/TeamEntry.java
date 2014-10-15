/*
 * TeamEntry.java
 *
 * Created on 20 March 2007, 17:45
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby.protocol.tasserver;

import java.awt.Color;

public class TeamEntry {
    private int teamLeader;
    private int allyNo;
    private Color teamColor;
    private int side;
    private String sideName;
    private int handicap;
    private String AI = "";
    private String AIOwner = "";
    
    public TeamEntry() {
        
    }

    public int getTeamLeader() {
        return teamLeader;
    }

    public void setTeamLeader(int teamLeader) {
        this.teamLeader = teamLeader;
    }

    public int getAllyNo() {
        return allyNo;
    }

    public void setAllyNo(int allyNo) {
        this.allyNo = allyNo;
    }

    public Color getTeamColor() {
        return teamColor;
    }

    public void setTeamColor(Color teamColor) {
        this.teamColor = teamColor;
    }

    public int getSide() {
        return side;
    }

    public void setSide(int side) {
        this.side = side;
    }

    public String getSideName() {
        return sideName;
    }

    public void setSideName(String sideName) {
        this.sideName = sideName;
    }

    public int getHandicap() {
        return handicap;
    }

    public void setHandicap(int handicap) {
        this.handicap = handicap;
    }
    
    public String getAI() {
        return AI;
    }

    public void setAI(String AI) {
        this.AI = AI;
    }

    public String getAIOwner() {
        return AIOwner;
    }

    public void setAIOwner(String AIOwner) {
        this.AIOwner = AIOwner;
    }
    
}
