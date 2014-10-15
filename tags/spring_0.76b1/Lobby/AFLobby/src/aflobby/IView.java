/*
 * IView.java
 * 
 * Created on 22-Aug-2007, 04:55:18
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

/**
 *
 * @author Tom
 */
public class IView{
    public String Title;
    public String UserTitle;
    public LMain LM;
    public void Initialize(){}

    public void NewEvent(aflobby.CEvent e){}

    public void NewGUIEvent(aflobby.CEvent e){}

    public void Update(){}

    public void ValidatePanel(){}

}
