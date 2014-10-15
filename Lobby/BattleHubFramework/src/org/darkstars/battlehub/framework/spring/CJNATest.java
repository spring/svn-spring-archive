/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework.spring;

import com.sun.jna.Native;

/**
 *
 * @author AF-Standard
 */
public class CJNATest {

    public CJNATest(String lib){
        //
        IJNAUnitsync ius = null;
        ius = (IJNAUnitsync) Native.loadLibrary(lib, IJNAUnitsync.class);
        ius.Init(true, 0);
//        ius.Message("boo");
        ius.UnInit();
        ius = null;
    }
}
