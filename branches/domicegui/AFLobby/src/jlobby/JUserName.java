/*
 * JUserName.java
 *
 * Created on 28 May 2006, 15:34
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package jlobby;
import java.io.*;
import java.util.*;
/**
 *
 * @author AF
 */
public class JUserName {
    public LMain LM;
    public String UserName;
    public String Password;
    public boolean autologin;
    public boolean RememberPass;
    public JConnection c;
    public boolean reconnect;
    /** Creates a new instance of JUserName */
    public JUserName(LMain L) {
        LM = L;
    }
    public void Init(String user, String pass, boolean auto_login, boolean Remember_pass){
        //
        UserName = user;
        Password = pass;
        autologin = auto_login;
        RememberPass = Remember_pass;
    }
    public void Update(){
        //
        if(reconnect == true){
            if(c.IsConnected()== false){
                Login();
            }
        }
    }
    public void NewEvent(JEvent e){
        //
        if(e.connection == c){
            if(e.data[0].equals("ACCEPTED")){
                reconnect = true;
            }
        }
    }
    public boolean LoggedIn(){
        return c.IsLoggedIn();
    }
    public void Login(){
        reconnect = true;
        c.Connect();
        c.Login(UserName,Password);
    }
    public void Logout(){
        reconnect = false;
        c.Disconnect();
    }
}
