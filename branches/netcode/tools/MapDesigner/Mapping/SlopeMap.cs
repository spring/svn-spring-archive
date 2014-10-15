// Copyright Spring project, Hugh Perkins 2006
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
// ======================================================================================
//

using System;
using System.IO;
using System.Collections;

namespace MapDesigner
{
    public class SlopeMap
    {
        public int squaresize = 8; // not sure why this is involved in slope calculations?

        static SlopeMap instance = new SlopeMap();
        public static SlopeMap GetInstance() { return instance; }

        int slopemapwidth;
        int slopemapheight;

        public SlopeMap()
        {
        }
        
        // ported from Spring's ReadMap.cpp by Hugh Perkins
        public double[,]GetSlopeMap()
        {
            Terrain terrain = Terrain.GetInstance();
            double[,] mesh = terrain.Map;

            int mapwidth = terrain.HeightMapWidth - 1;
            int mapheight = terrain.HeightMapHeight - 1;
            
            slopemapwidth = mapwidth / 2;
            slopemapheight = mapheight / 2;
            
            //logfile.WriteLine( "Getting heightmap, this could take a while... " );
            
            double[,]SlopeMap = new double[ slopemapwidth, slopemapheight ];

            for(int y = 2; y < mapheight - 2; y+= 2)
            {
                for(int x = 2; x < mapwidth - 2; x+= 2)
                {
                    Vector3 e1 = new Vector3(-squaresize * 4, mesh[x - 1, y - 1] - mesh[x + 3, y - 1], 0);
                    Vector3 e2 = new Vector3(0, mesh[x - 1, y - 1] - mesh[x - 1, y + 3], -squaresize * 4);

                    Vector3 n = Vector3.CrossProduct( e2, e1 );
        
                    n.Normalize();

                    e1 = new Vector3(squaresize * 4, mesh[x + 3, y + 3] - mesh[x - 1, y + 3], 0);
                    e2 = new Vector3(0, mesh[x + 3, y + 3] - mesh[x + 3, y - 1], squaresize * 4);

                    Vector3 n2 = Vector3.CrossProduct( e2, e1 );
                    n2.Normalize();

                    SlopeMap[ x / 2, y / 2 ]= 1 - ( n.y + n2.y ) * 0.5;
                }
            }
            //logfile.WriteLine("... slopes calculated" );
            return SlopeMap;
        }
	}
}
