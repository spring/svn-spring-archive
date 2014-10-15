/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

import java.util.ArrayList;

/**
 *
 * @author AF-Standard
 */
public interface IBattleInfo {

    int GetPort();
    
    void SetPort(int port);
    
    boolean Active();

    void AddPlayer(CPlayer p);

    String GetDescription();

    CPlayer GetHost();

    int GetID();

    String GetMap();

    String GetMod();

    String GetPlayerNames();

    ArrayList<CPlayer> GetPlayers();

    boolean IsIngame();

    boolean IsPassworded();

    void RemovePlayer(CPlayer p);

    void SetActive(boolean isactive);

    void SetDescription(String desc);

    void SetHost(CPlayer host);

    void SetID(int i);

    void SetIngame(boolean ingame);

    void SetMap(String map);

    void SetMod(String mod);

    void SetPassworded(boolean pass);

    String getEngine();

    boolean isJoinable();

    void setEngine(String engine);

    @Override
    String toString();

}
