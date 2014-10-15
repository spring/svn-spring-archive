/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

/**
 *
 * @author AF-Standard
 */
public interface IChannelModel {

    public abstract void SetName(String channelName);
    public abstract String GetName();
    public abstract void Exit();
    public abstract void Exit(String reason);
    public abstract void Say(String message);
    public abstract void SayAction(String actionMessage);
    
    public abstract String GetTopic();
    public abstract void SetTopic(String topicMessage);
    
    public abstract int GetPlayerCount();
}
