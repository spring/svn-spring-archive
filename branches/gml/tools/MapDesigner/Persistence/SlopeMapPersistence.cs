// Copyright Hugh Perkins 2006
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
using System.IO;
//using DevIL;
//using System.Drawing;
//using System.Drawing.Imaging;

namespace MapDesigner
{
    public class SlopeMapPersistence
    {
        static SlopeMapPersistence instance = new SlopeMapPersistence();
        public static SlopeMapPersistence GetInstance() { return instance; }

        SlopeMapPersistence()
        {
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand("saveslopemap", new KeyCommandHandler(SaveHandler));
        }

        void Save()
        {
            if (exportheightmapfilename != "")
            {
                Save(exportheightmapfilename);
            }
            else
            {
                Save(Config.GetInstance().defaultSlopeMapFilename);
            }
        }

        string exportheightmapfilename = "";

        public void Save( string filename )
        {
            double[,] mesh = SlopeMap.GetInstance().GetSlopeMap();
            int width = mesh.GetUpperBound(0) + 1;
            int height = mesh.GetUpperBound(1) + 1;

            double maxslopetoexport = Config.GetInstance().SlopemapExportMaxSlope;

            Image image = new Image(width, height);
            //Bitmap bitmap = new Bitmap(width, height, PixelFormat.Format24bppRgb);
            //Graphics g = Graphics.FromImage(bitmap);
            // cache pencolors;
            List<MovementAreaConfig> movementareas = Config.GetInstance().movementareas;
            SortedList<double, Color> sortedcolorbymaxslope = new SortedList<double, Color>();
            foreach (MovementAreaConfig movementarea in movementareas)
            {
                if (movementarea.MaxSlope >= 0)
                {
                    sortedcolorbymaxslope.Add(movementarea.MaxSlope, movementarea.color);
                }
                else
                {
                    sortedcolorbymaxslope.Add(double.PositiveInfinity, movementarea.color);
                }
            }
            for (int area = 0; area < sortedcolorbymaxslope.Count; area++)
            {
                LogFile.GetInstance().WriteLine(sortedcolorbymaxslope.Keys[area] + " " + sortedcolorbymaxslope.Values[area].ToString());
            }
            for (int i = 0; i < width; i++)
            {
                for (int j = 0; j < height; j++)
                {
                    Color colortouse = new Color(1, 1, 1);
                    for (int area = 0; area < sortedcolorbymaxslope.Count; area++)
                    {
                        if (mesh[i, j] < sortedcolorbymaxslope.Keys[area])
                        {
                            colortouse = sortedcolorbymaxslope.Values[area];
                            break;
                        }
                    }
                    int valuetowrite = (int)(mesh[i, j] * 255 / maxslopetoexport);
                    valuetowrite = Math.Max(0, valuetowrite);
                    valuetowrite = Math.Min(255, valuetowrite);
                    image.SetPixel(i, j, (byte)(colortouse.r * 255 * valuetowrite),
                        (byte)( colortouse.g * 255 * valuetowrite ),
                        (byte)( colortouse.b * 255 * valuetowrite ),
                        255
                    );
                }
            }
            image.Save(filename);
            exportheightmapfilename = filename;
            MainUI.GetInstance().uiwindow.InfoMessage("Slopemap exported");
        }

        void SaveHandler(string command, bool down)
        {
            if (down)
            {
                Save();
            }
        }
    }
}
