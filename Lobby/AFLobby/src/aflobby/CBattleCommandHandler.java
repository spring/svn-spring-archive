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
import java.util.ArrayList;
import java.util.Iterator;

/**
 *
 * @author Tom
 */
public class CBattleCommandHandler {
    CUserCommandHandler c = null;
    CBattleWindow b = null;
    ArrayList<String> prefixes = new ArrayList<String>();
    ArrayList<String> commands = new ArrayList<String>();
    LMain LM;

    /** Creates a new instance of CUserCommandHandler 
     * @param LM 
     * @param b 
     * @param c 
     */
    public CBattleCommandHandler(LMain LM, CBattleWindow b, CUserCommandHandler c) {
        this.LM = LM;
        this.c = c;
        this.b = b;
        prefixes.add("/");
        prefixes.add(".");
        commands.add("kick");
        commands.add("spec");
        commands.add("spectate");
        commands.add("spectator");
        commands.add("forcespec");
        //commands.add("lock");
        //commands.add("ring");
        commands.add("team");
        commands.add("ally");
        commands.add("forceteam");
        commands.add("forceally");
    }

    public void NewGUIEvent(CEvent e) {
    }

    public void NewEvent(CEvent e) {
    }

    void Update() {
    }

    public boolean IsCommand(String line) {
        if(c.IsCommand(line)){
            return true;
        }
        Iterator<String> i = prefixes.iterator();
        while (i.hasNext()) {
            String s = i.next();
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
            /*
        commands.add("forcespec");
        commands.add("lock");
        commands.add("ring");
             */
            command = command.substring(1);
            String[] params = command.split(" ");
            if (params[0].equalsIgnoreCase("team")||params[0].equalsIgnoreCase("forceteam")) {
                //FORCETEAMNO username teamno
                CPlayer p = LM.playermanager.GetPlayer(params[1]);
                if(p == null){
                    String msg = java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleCommandHandler.errors.forceteamparam1");
                    msg = msg.replaceAll("{player}", params[1]);
                    LM.Toasts.AddMessage(msg);
                    return false;
                }
                int i;
                try {
                    i = Integer.parseInt(params[2]);
                    
                } catch (NumberFormatException numberFormatException) {
                    LM.Toasts.AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleCommandHandler.errors.forceteamparam2"));
                    return false;
                }

                String q = "FORCETEAMNO "+p.name+" "+i;//+;
                LM.protocol.SendTraffic(q);
                return true;
            } else if (params[0].equalsIgnoreCase("ally")||params[0].equalsIgnoreCase("forceally")) {
                //FORCETEAMNO username teamno
                CPlayer p = LM.playermanager.GetPlayer(params[1]);
                if(p == null){
                    String msg = java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleCommandHandler.errors.forceallyparam1");
                    msg = msg.replaceAll("{player}", params[1]);
                    LM.Toasts.AddMessage(msg);
                    return false;
                }
                int i;
                try {
                    i = Integer.parseInt(params[2]);
                    
                } catch (NumberFormatException numberFormatException) {
                    LM.Toasts.AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleCommandHandler.errors.forceallyparam2"));
                    return false;
                }

                String q = "FORCEALLYNO "+p.name+" "+i;//+;
                LM.protocol.SendTraffic(q);
                return true;
            } else if (params[0].equalsIgnoreCase("kick")){
                CPlayer p = LM.playermanager.GetPlayer(params[1]);
                if(p == null){
                    /*String msg = java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleCommandHandler.errors.forceallyparam1");
                    msg = msg.replaceAll("{player}", params[1]);
                    LM.Toasts.AddMessage(msg);*/
                    return false;
                }
                String q = "KICKFROMBATTLE "+p.name;
                LM.protocol.SendTraffic(q);
                return true;
            } else if (params[0].equalsIgnoreCase("spec")||params[0].equalsIgnoreCase("spectate")||params[0].equalsIgnoreCase("spectator")||params[0].equalsIgnoreCase("forcespec")){
                CPlayer p = LM.playermanager.GetPlayer(params[1]);
                if(p == null){
                    /*String msg = java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleCommandHandler.errors.forceallyparam1");
                    msg = msg.replaceAll("{player}", params[1]);
                    LM.Toasts.AddMessage(msg);*/
                    return false;
                }
                String q = "FORCESPECTATORMODE "+p.name;
                LM.protocol.SendTraffic(q);
                return true;
            }else {
                /*commands.add("spec");
        commands.add("spectate");
        commands.add("spectator");
        commands.add("forcespec");*/
                return false;
            }
        }
    }
}
