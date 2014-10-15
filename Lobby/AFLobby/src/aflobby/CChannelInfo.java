/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import java.io.File;
import java.net.MalformedURLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.ImageIcon;

/**
 *
 * @author tarendai
 */
public class CChannelInfo {

    private String name;
    private int usercount;
    private String topic;
    private ImageIcon icon;

    /**
     * 
     * @param name
     * @param usercount
     * @param topic
     */
    public CChannelInfo(String name, int usercount, String topic){
        this.name = name;
        this.usercount = usercount;
        this.topic = topic;
        File f  = new File(Misc.GetAbsoluteLobbyFolderPath()+"images/channels/"+name+".png");
        if(f.exists()){
            try {
                icon = new ImageIcon(f.toURL());
            } catch (MalformedURLException ex) {
                Logger.getLogger(CChannelInfo.class.getName()).log(Level.SEVERE, null, ex);
            }
        }else{
            icon = new ImageIcon(Misc.GetAbsoluteLobbyFolderPath()+"images/channels/"+name+".gif");
        }
    }
    
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getUsercount() {
        return usercount;
    }

    public void setUsercount(int usercount) {
        this.usercount = usercount;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public ImageIcon getIcon() {
        return icon;
    }

    public void setIcon(ImageIcon icon) {
        this.icon = icon;
    }
    
}
