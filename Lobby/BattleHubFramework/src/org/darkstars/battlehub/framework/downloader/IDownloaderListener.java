/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework.downloader;

import java.io.File;
import java.util.EventListener;

/**
 *
 * @author AF-Standard
 */
public interface IDownloaderListener extends EventListener {

    public void DownloadFinished(File f);
}
