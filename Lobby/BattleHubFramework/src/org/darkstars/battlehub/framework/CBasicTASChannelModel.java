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
public class CBasicTASChannelModel implements IChannelModel, IModule {

    public String channelName = "";
    
    public ArrayList<CPlayer> players = new ArrayList<CPlayer>();
    public String topic = "";
    protected ICentralClass central;
    
    @Override
    public void SetName(String channelName) {
        this.channelName = channelName;
    }

    @Override
    public String GetName() {
        return channelName;
    }

    public void Exit() {
        central.GetProtocol().LeaveChannel(channelName, topic);
        central.GetCore().RemoveModule(this);
    }

    public void Exit(String reason) {
        central.GetProtocol().LeaveChannel(channelName, reason);
    }

    public void Say(String message) {
        central.GetProtocol().SendTraffic("SAY "+channelName+" "+message);
    }

    public void SayAction(String actionMessage) {
        central.GetProtocol().SendTraffic("SAYEX "+channelName+" "+actionMessage);
    }

    @Override
    public String GetTopic() {
        return topic;
    }

    @Override
    public void SetTopic(String topicMessage) {
        this.topic = topicMessage;
    }

    @Override
    public int GetPlayerCount() {
        return players.size();
    }

    public void Init(ICentralClass L) {
        this.central = L;
    }

    public void Update() {
        //
    }

    public void NewEvent(CEvent e) {
        //
    }

    public void NewGUIEvent(CEvent e) {
        //
    }

    public void OnRemove() {
        //
    }

    public void OnEvent(CEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void OnRemove(int channel) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

}
