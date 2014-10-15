// Created by Hugh Perkins 2006
// hughperkins@gmail.com http://manageddreams.com
// 
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
//  more details.
//
// You should have received a copy of the GNU General Public License along
// with this program in the file licence.txt; if not, write to the
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-
// 1307 USA
// You can find the licence also on the web at:
// http://www.opensource.org/licenses/gpl-license.php
//

using System;
using System.Collections.Generic;
using System.Text;

namespace MapDesigner
{
    public class AddFeature : IBrushEffect
    {
        public Unit currentfeature;

        public void ApplyBrush( IBrushShape brushshape, int brushsize, double brushcentre_x, double brushcentre_y, bool israising, double milliseconds )
        {
            if (currentfeature == null)
            {
                return;
            }

            int x = (int)(brushcentre_x / Terrain.SquareSize);
            int y = (int)(brushcentre_y / Terrain.SquareSize);

            if (israising)
            {
                if (Terrain.GetInstance().FeatureMap[x, y] == null)
                {
                    Terrain.GetInstance().FeatureMap[x, y] = currentfeature;
                    LogFile.GetInstance().WriteLine( "feature " + currentfeature.texturename1 + " added to " + x + " " + y );
                    Terrain.GetInstance().OnFeatureAdded( currentfeature, x, y );
                }
            }
            else
            {
                if (Terrain.GetInstance().FeatureMap[x, y] != null)
                {
                    Unit oldunit = Terrain.GetInstance().FeatureMap[x, y];
                    Terrain.GetInstance().FeatureMap[x, y] = null;
                    Terrain.GetInstance().OnFeatureRemoved( oldunit, x, y );
                }
            }
        }

        public void ShowControlBox( Gtk.VBox labels, Gtk.VBox widgets )
        {
        }

        public bool Repeat
        {
            get
            {
                return false;
            }
        }

        public string Name
        {
            get { return "Add/remove features"; }
        }

        public string Description
        {
            get { return "Add or remove features by clicking the map"; }
        }
    }
}
