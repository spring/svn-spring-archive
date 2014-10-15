/*
 * CUserCommandHandler.java
 *
 * Created on 23 April 2007, 19:18
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import aflobby.framework.CEvent;
import aflobby.framework.IModule;
import java.util.ArrayList;
import java.util.Iterator;

/**
 *
 * @author Tom
 */
public class CUserCommandHandler implements IModule{

    ArrayList<String> prefixes = new ArrayList<String>();
    ArrayList<String> commands = new ArrayList<String>();
    LMain LM;

    /** Creates a new instance of CUserCommandHandler 
     */
    public CUserCommandHandler() {
        
        prefixes.add("/");
        prefixes.add(".");
        commands.add("j");
        commands.add("join");
        commands.add("msg");
        commands.add("say");
        commands.add("sendtraffic");
        commands.add("rename");
        commands.add("ring");
        //if(LM.protocol.GetAccessLevel()>0){
            commands.add("findip");
            commands.add("ip");
            commands.add("lastip");
            commands.add("kickuser");
        //}
    }

    public void NewGUIEvent(CEvent e) {
    }

    public void NewEvent(CEvent e) {
    }

    public void Update() {
    }

    public boolean IsCommand(String line) {
        line = line.toLowerCase();
        Iterator<String> i = prefixes.iterator();
        while (i.hasNext()) {
            String s = i.next().toLowerCase();
            if (line.startsWith(s)) {
                return true;
            }
        }
        return false;
    }

    public boolean ExecuteCommand(String command) {
        //
        if (IsCommand(command) == false) {
            return false;
        } else {
            //
            command = command.substring(1);
            String[] params = command.split(" ");
            if (params[0].equalsIgnoreCase("join") || params[0].equalsIgnoreCase("j")) {
                String q = Misc.makeSentence(params, 1).replaceAll("#", "");
                String[] channels = q.split(",");
                for (int i = 0; i < channels.length; i++) {
                    LM.protocol.SendTraffic("JOIN " + channels[i].trim());
                }
                return true;
            } else if (params[0].equalsIgnoreCase("msg")) {
                String q = Misc.makeSentence(params, 1);
                //q = q.replaceAll ("#","");
                //String[] channels = q.split (",");
                //for(int i = 0; i <channels.length; i++){
                if (params.length < 2) {
                    LM.Toasts.AddMessage("you must use the correct syntax /msg person message content");
                    return false;
                }
                CEvent e = new CEvent(CEvent.OPENPRIVATEMSG + " " + params[0]);
                LM.core.NewGUIEvent(e);
                LM.protocol.SendTraffic("SAYPRIVATE " + q);
                //}
                return true;
            } else if (params[0].equalsIgnoreCase("say")) {
                String q = Misc.makeSentence(params, 1);
                q = q.replaceAll("#", "");
                //String[] channels = q.split (",");
                //for(int i = 0; i <channels.length; i++){
                if (params.length < 3) {
                    LM.Toasts.AddMessage("you must use the correct syntax /say channel message content");
                    return false;
                }
                LM.protocol.SendTraffic("SAY " + q);
                //}
                return true; //RENAMEACCOUNT newUsername
            } else if (params[0].equalsIgnoreCase("rename")) {
                if (params.length != 2) {
                    LM.Toasts.AddMessage("you must use the correct syntax! /rename newusername");
                    return false;
                }
                LM.protocol.SendTraffic("RENAMEACCOUNT " + params[1]);
                return true;
            } else if (params[0].equalsIgnoreCase("sendtraffic")) {
                String q = Misc.makeSentence(params, 1);
                //q = q.replaceAll ("#","");
                //String[] channels = q.split (",");
                //for(int i = 0; i <channels.length; i++){
                if (params.length < 2) {
                    LM.Toasts.AddMessage("you must use the correct syntax /say channel message content");
                    return false;
                }
                LM.protocol.SendTraffic(q);
                //}
                return true;
            } else if (params[0].equalsIgnoreCase("sendtraffic")) {

                //q = q.replaceAll ("#","");
                //String[] channels = q.split (",");
                //for(int i = 0; i <channels.length; i++){
                if (params.length != 1) {
                    LM.Toasts.AddMessage("you must use the correct syntax /ring username");
                    return false;
                }
                String q = "RING " + Misc.makeSentence(params, 1);
                LM.protocol.SendTraffic(q);
                return true;
            } else if(params[0].equalsIgnoreCase("findip")){
                if(params.length==2){
                    LM.protocol.SendTraffic("FINDIP "+params[1]);
                    return true;
                }else{
                    LM.Toasts.AddMessage("error you must use the following syntax /findip ip");
                    return false;
                }
            } else if(params[0].equalsIgnoreCase("lastip")){
                if(params.length==2){
                    LM.protocol.SendTraffic("GETLASTIP "+params[1]);
                    return true;
                }else{
                    LM.Toasts.AddMessage("error you must use the following syntax /lastip username");
                    return false;
                }
            } else if(params[0].equalsIgnoreCase("kick")){
                if(params.length>2){
                    LM.protocol.SendTraffic("KICKUSER "+params[1]+" "+Misc.makeSentence(params, 2));
                    return true;
                }else{
                    LM.Toasts.AddMessage("error you must use the following syntax /kick username");
                    return false;
                }
            } else if(params[0].equalsIgnoreCase("ip")){
                if(params.length==2){
                    LM.protocol.SendTraffic("GETIP "+params[1]);
                    return true;
                }else{
                    LM.Toasts.AddMessage("error you must use the following syntax /ip username");
                    return false;
                }
            } else {
                return false;
            }
        }
    }

    public void Init(LMain L) {
        this.LM = L;
    }

    public void OnRemove() {
    }
}
