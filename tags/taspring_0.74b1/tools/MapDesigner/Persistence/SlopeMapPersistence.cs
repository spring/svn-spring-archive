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
// or FITNESS FOR A PARTICULAR PURVector3E. See the GNU General Public License for
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
using System.Drawing;
using System.Drawing.Imaging;

namespace MapDesigner
{
    public class SlopeMapPersistence
    {
        static SlopeMapPersistence instance = new SlopeMapPersistence();
        public static SlopeMapPersistence GetInstance() { return instance; }

        SlopeMapPersistence()
        {
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand("saveslopemap", new KeyCommandHandler(SaveHandler));
            UICommandQueue.GetInstance().RegisterConsumer(typeof(CmdExportSlopeMap), new UICommandQueue.UICommandHandler(ExportSlopeMapHandler));
        }

        void ExportSlopeMapHandler(UICommand command)
        {
            CmdExportSlopeMap exportcmd = command as CmdExportSlopeMap;
            Save(exportcmd.FilePath);
        }

        void Save()
        {
            Save(Config.GetInstance().defaultSlopeMapFilename);
        }

        void Save( string filename )
        {
            double[,] mesh = SlopeMap.GetInstance().GetSlopeMap();
            int width = mesh.GetUpperBound(0) + 1;
            int height = mesh.GetUpperBound(1) + 1;

            double maxslopetoexport = Config.GetInstance().SlopemapExportMaxSlope;

            Bitmap bitmap = new Bitmap(width, height, PixelFormat.Format24bppRgb);
            Graphics g = Graphics.FromImage(bitmap);
            // cache pencolors;
            List<MovementAreaConfig> movementareas = Config.GetInstance().movementareas;
            Dictionary<Color, Pen[]> penarraybycolor = new Dictionary<Color, Pen[]>();
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
                if( !penarraybycolor.ContainsKey( movementarea.color ) )
                {
                    Vector3 colorvector = new Vector3(movementarea.color.r, movementarea.color.g, movementarea.color.b);
                    penarraybycolor.Add( movementarea.color, new Pen[256] );
                    for (int i = 0; i < 256; i++)
                    {
                        Vector3 thiscolorvector = colorvector * i;
                        penarraybycolor[ movementarea.color ][i] = 
                            new Pen(System.Drawing.Color.FromArgb(
                            (int)thiscolorvector.x, (int)thiscolorvector.y, (int)thiscolorvector.z));
                    }
                }
            }
            for (int area = 0; area < sortedcolorbymaxslope.Count; area++)
            {
                Console.WriteLine(sortedcolorbymaxslope.Keys[area] + " " + sortedcolorbymaxslope.Values[area].ToString());
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
                    g.DrawRectangle( penarraybycolor[ colortouse ][valuetowrite], i, j, 1, 1);
                }
            }
            bitmap.Save(filename, ImageFormat.Bmp);
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
