/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby.contentdownloader;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Map;
import java.util.TreeMap;

/**
 *
 * @author tarendai
 */
public class CContentInterface {

    public Map<String,String> contenthashmap = null;
    public Map<String,String> hashcontentmap = null;
    public Map<String,CContentDownloadHandler> handlers;
    
    public boolean initialized = false;
    
    public String torurl ="http://tracker.caspring.org/caupdater/torrents.txt";
    
    public CContentInterface(){
        //
        contenthashmap = new TreeMap<String,String>();
        hashcontentmap = new TreeMap<String,String>();
        handlers = new TreeMap<String,CContentDownloadHandler>();
        
        String torrents ="";
        try {
            URL yahoo = new URL(torurl);
            BufferedReader in;
            in = new BufferedReader(new InputStreamReader(yahoo.openStream()));

            String inputLine;

            while ((inputLine = in.readLine()) != null) {
                torrents += inputLine+"\n";
            }
            
            in.close();
        } catch (Exception ex) {
            ex.printStackTrace();
            torrents= "";
        }
        
        String[] fields = torrents.split("\n");
        for(String field : fields){
            
            int s = field.lastIndexOf("|");
            
            String contentname = field.substring(0,s);
            String hashvalue = field.substring(s+1);
            
            contenthashmap.put(contentname, hashvalue);
            hashcontentmap.put(hashvalue, contentname);
        }
        
    }
    
    public String GetContentHash(String contentname){
        return contenthashmap.get(contentname);
    }
    
    public String GetHashContentName(String hash){
        return hashcontentmap.get(hash);
    }
    
    public CContentDownloadHandler GetHandler(String hash){
        //
        if(handlers.containsKey(hash)){
            return handlers.get(hash);
        }
        return null;
    }
    
    public CContentDownloadHandler CreateHandlerViaName(String name){
        //
        String hash = GetContentHash(name);
        CContentDownloadHandler cdh = new CContentDownloadHandler(hash,GetTargetPath(name));
        return cdh;
    }
    
    public CContentDownloadHandler CreateHandlerViaHash(String hash){
        //
        String name = GetHashContentName(hash);
        CContentDownloadHandler cdh = new CContentDownloadHandler(hash,GetTargetPath(name));
        return cdh;
    }
    
    public String GetTargetPath(String name){
        //
        return "";
    }
    
}

