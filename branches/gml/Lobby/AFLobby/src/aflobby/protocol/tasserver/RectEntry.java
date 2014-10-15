/*
 * RectEntry.java
 *
 * Created on 31 March 2007, 01:52
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby.protocol.tasserver;

import aflobby.*;

/**
 *
 * @author Stefan
 */
public class RectEntry {
    private int numAlly;
    private int startRecLeft = 0;
    private int startRecTop = 0;
    private int startRecRight = 0;
    private int startRecBottom = 0;      
    
    /** Creates a new instance of RectEntry */
    public RectEntry() {
      
    }

    public String[] getRectDataStr() {
        String[] rectData = new String[4];
        
        // 3 Komma Nachstellen 
        rectData[0] = ""+(1d/200d*(double)startRecLeft);
        rectData[1] = ""+(1d/200d*(double)startRecTop);
        rectData[2] = ""+(1d/200d*(double)startRecRight);
        rectData[3] = ""+(1d/200d*(double)startRecBottom);
        
        rectData[0] = Misc.formatDoubleStrToLength(rectData[0],5);
        rectData[1] = Misc.formatDoubleStrToLength(rectData[1],5);
        rectData[2] = Misc.formatDoubleStrToLength(rectData[2],5);
        rectData[3] = Misc.formatDoubleStrToLength(rectData[3],5);
        
        return rectData;
    }
    public void setRectDataStr(String[] rectData) {
        //String[] rectData = new String[4];
        if(rectData.length < 4){
            return;
        }
        startRecLeft = (int)(Double.valueOf(rectData[0])/1d/200d);//1d/200d
        startRecTop=(int)(Double.valueOf(rectData[1])/1d/200d);
        startRecRight=(int)(Double.valueOf(rectData[2])/1d/200d);
        startRecBottom=(int)(Double.valueOf(rectData[3])/1d/200d);
    } 
    
    public int getNumAlly() {
        return numAlly;
    }

    public void setNumAlly(int numAlly) {
        this.numAlly = numAlly;
    }

    public int getStartRecLeft() {
        return startRecLeft;
    }

    public void setStartRecLeft(int startRecLeft) {
        this.startRecLeft = startRecLeft;
    }

    public int getStartRecTop() {
        return startRecTop;
    }

    public void setStartRecTop(int startRecTop) {
        this.startRecTop = startRecTop;
    }

    public int getStartRecRight() {
        return startRecRight;
    }

    public void setStartRecRight(int startRecRight) {
        this.startRecRight = startRecRight;
    }

    public int getStartRecBottom() {
        return startRecBottom;
    }

    public void setStartRecBottom(int startRecBottom) {
        this.startRecBottom = startRecBottom;
    }
}
