/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

/**
 *
 * @author AF-Standard
 */
public class CFrameworkHelper {

    public static void InstallThreadUncaughtExceptionHandler(){
        Thread.setDefaultUncaughtExceptionHandler(new CExceptionHandler());
    }
}
