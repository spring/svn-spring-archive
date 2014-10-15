/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby.contentdownloader;

import java.io.IOException;
import org.klomp.snark.Snark;
import org.klomp.snark.cmd.ConsoleStorageReporter;

/**
 *
 * @author tarendai
 */
public class CContentDownloadHandler {

    private Snark torrent;
    private String hash ="";
    private String targetpath="";
    
    public CContentDownloadHandler(String hash, String targetpath){
        //
        this.targetpath = targetpath;
        this.hash = hash;
    }
    
    public void Download(){
        //
        torrent  = new Snark("http://tracker.caspring.org/caupdater/torrents/"+hash+".torrent",null,-1,new ConsoleStorageReporter(),null,targetpath);
        try {
            torrent.setupNetwork();
            torrent.collectPieces();
        } catch (IOException ioe) {
            //System.exit(-1);
            ioe.printStackTrace();
        }
    }
}
