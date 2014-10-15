/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

import org.darkstars.battlehub.framework.protocol.IProtocol;

/**
 *
 * @author AF-Standard
 */
public interface ICentralClass {

    public CCore GetCore();
    public IProtocol GetProtocol();
    public void Shutdown();
    public String GetAbsoluteLobbyFolderPath();
}
