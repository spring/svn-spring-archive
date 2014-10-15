/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.darkstars.battlehub.framework.spring;

import java.util.EventListener;

/**
 *
 * @author AF-Standard
 */
public interface IAutoHostUDPListener extends EventListener {

    public void NewAutoHostUDPString(String msg);
}
