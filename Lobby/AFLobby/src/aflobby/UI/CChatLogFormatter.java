/*
 * CChatLogFormatter.java
 * 
 * Created on 19-Aug-2007, 01:48:10
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby.UI;

import aflobby.Misc;
import java.util.logging.LogRecord;

/**
 *
 * @author Tom
 */
public class CChatLogFormatter extends java.util.logging.Formatter{
    public CChatLogFormatter(){
    }
    
    public String format(LogRecord record) {
        String s =Misc.easyDateFormat(record.getMillis(),"[hh:mm:ss] ");
        s += record.getMessage();
        s += System.getProperty ("line.separator");
        return s;
        //
    }

}
