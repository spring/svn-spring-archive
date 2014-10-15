/*
 * CLadderProperties.java
 * 
 * Created on 16-Sep-2007, 07:32:35
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import java.util.ArrayList;

/**
 *
 * @author AF-StandardUsr
 */
public class CLadderProperties {

        /**
         * A string representing the mod this ladder uses. This is not a full
         * mod name. To determine which mods the ladder can use, search for mods
         * whose name contains this string.
         */
        public String mod = "";
        
        /**
         * An integer of value 1 or higher. Represents the minimum number of
         * players a battle can have in an ally group.
         */
        public int min_players_per_allyteam = 1;
        
        /**
         * An integer of value 1 or higher. Represents the maximum number of
         * players a battle can have in an ally group.
         */
        public int max_players_per_allyteam = 1;
        
        /**
         * Specifies the required starting position mode of the battle
         * The value -1 is sued to specify that the user can choose any arbitrary option
         */
        public int startpos;
        
        /**
         * 
         */
        public int gamemode;
        
        /**
         * Specifies the limited dgun setting of this ladder.
         * 0 = do not limit dgun to starting positions
         * 1 = limit dgun to starting positions
         * -1 = it's upto the host to decide
         */
        public int dgun = -1;
        
        /**
         * Specifies wether ghosted buildings should be set on or off
         * 0 = do nto show ghosted buildings
         * 1 = Show Ghosted buildings
         * -1 = it's upto the host to decide
         */
        public int ghost = -1;
        
        /**
         * Diminishing metalmaker returns
         */
        public int diminish;
        
        /**
         * 
         */
        public int minmetal;
        
        /**
         * 
         */
        public int maxmetal;
        
        /**
         * 
         */
        public int minenergy;
        
        /**
         * 
         */
        public int maxenergy;
        
        /**
         * 
         */
        public int minunits;
        
        /**
         * 
         */
        public int maxunits;
        
        /**
         * 
         */
        public ArrayList<String> restricted_units = new ArrayList<String>();
        
        /**
         * 
         */
        public String rules;
        
    }
