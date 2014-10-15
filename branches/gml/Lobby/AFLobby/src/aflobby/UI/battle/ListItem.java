/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby.UI.battle;

/**
 * An object to hold data about an item in a lua list option
 */
public class ListItem {

    /**
     * 
     */
    public ListItem(){
        //
    }

    public String key;
    public String name;
    public String description;
    
    @Override
    public String toString(){
        return name;
    }
}