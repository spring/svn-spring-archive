package aflobby.protocol.tasserver;

import aflobby.helpers.TdfParser;
import aflobby.*;
import java.util.ArrayList;

/*
 * RectHandler.java
 *
 * Created on 14. March 2007, 22:43
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
import java.util.TreeMap;


public class RectHandler {
    private static ArrayList<RectEntry> rectList = new ArrayList<RectEntry>();
    
    public RectHandler () {
    }
    
    public static void clearRects () {
        rectList.clear ();
    }
    
    public static void RemoveRect (int allynum){
        RectEntry re = getRectForAlly (allynum);
        rectList.remove (re);
    }
    
    public static void SetRect (int allynum, int left, int top, int right, int bottom){
        RectEntry re = getRectForAlly (allynum);
        if(re != null){
            re.setStartRecLeft (left);
            re.setStartRecTop (top);
            re.setStartRecRight (right);
            re.setStartRecBottom (bottom);
        }else{
            addRect (allynum, left,top,right,bottom);
        }
    }
    
    public static void SetRect (int allynum, String[] data){
        RectEntry re = getRectForAlly (allynum);
        if(re != null){
            re.setRectDataStr(data);
        }else{
            addRect (allynum, data);
        }
        //
    }
    
    public static void addRect (int left, int top, int right, int bottom) {
        RectEntry re = new RectEntry ();
        
        re.setNumAlly (rectList.size ());
        re.setStartRecLeft (left);
        re.setStartRecTop (top);
        re.setStartRecRight (right);
        re.setStartRecBottom (bottom);
        
        rectList.add (re);
    }
    
    public static void addRect (int allynum, int left, int top, int right, int bottom) {
        RectEntry re = new RectEntry ();
        
        re.setNumAlly (allynum);
        re.setStartRecLeft (left);
        re.setStartRecTop (top);
        re.setStartRecRight (right);
        re.setStartRecBottom (bottom);
        
        rectList.add (re);
    }
    
    public static void addRect (int allynum, String[] data) {
        RectEntry re = new RectEntry ();
        
        re.setNumAlly (allynum);
        re.setRectDataStr(data);
        
        rectList.add (re);
    }
    
    public static ArrayList<RectEntry> getRectList () {
        return rectList;
    }
    
    public static RectEntry getRectForAlly (int allyNo) {
        RectEntry actRect = null;
        
        for (int i=0;i<rectList.size ();i++) {
            actRect = rectList.get (i);
            if (actRect.getNumAlly () == allyNo) return actRect;
        }
        
        return null;
    }
    
    public static String SaveBoxes(){
        String s = "";
        int i = 0;
        for(RectEntry r : rectList){
            s+= "[RECT"+i+"]{\n";
            i++;
            s+="\tallynum="+r.getNumAlly();
            String[] rects =r.getRectDataStr();
            s += "\tdata="+rects[0]+","+rects[1]+","+rects[2]+","+rects[3];
        }
        return s;
    }
    
    public static boolean LoadBoxes(String filecontents){
        TdfParser t = new TdfParser(filecontents);
        TreeMap<String,TdfParser.Section> sections = t.RootSection.SubSections;
        for(TdfParser.Section sec : sections.values()){
            int ally = sec.GetIntValue("allynum");
            String[] rectData = sec.GetStringValue("data").split(",");
            addRect(ally,rectData);
        }
        return true;
    }
}
