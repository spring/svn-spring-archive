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
    public class HeightMapPersistence
    {
        static HeightMapPersistence instance = new HeightMapPersistence();
        public static HeightMapPersistence GetInstance() { return instance; }

        HeightMapPersistence()
        {
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand("saveheightmap", new KeyCommandHandler(SaveHandler));
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand("loadheightmap", new KeyCommandHandler(LoadHandler));
            UICommandQueue.GetInstance().RegisterConsumer(typeof(CmdNewHeightMap), new UICommandQueue.UICommandHandler(NewHeightMapHandler));
            UICommandQueue.GetInstance().RegisterConsumer(typeof(CmdOpenHeightMap), new UICommandQueue.UICommandHandler(OpenHeightMapHandler));
            UICommandQueue.GetInstance().RegisterConsumer(typeof(CmdSaveHeightMap), new UICommandQueue.UICommandHandler(SaveHeightMapHandler));
        }

        void NewHeightMapHandler(UICommand command)
        {
            CmdNewHeightMap thiscommand = command as CmdNewHeightMap;
            HeightMap.GetInstance().Width = thiscommand.width * 64 + 1;
            HeightMap.GetInstance().Height = thiscommand.width * 64 + 1;
            HeightMap.GetInstance().Map = new float[HeightMap.GetInstance().Width, HeightMap.GetInstance().Height];
            lastfilename = "";
        }

        void OpenHeightMapHandler(UICommand command)
        {
            CmdOpenHeightMap thiscommand = command as CmdOpenHeightMap;
            Load(thiscommand.FilePath);
            lastfilename = thiscommand.FilePath;
        }
        string lastfilename = "";

        void SaveHeightMapHandler(UICommand command)
        {
            CmdSaveHeightMap thiscommand = command as CmdSaveHeightMap;
            Save(thiscommand.FilePath);
            lastfilename = thiscommand.FilePath;
        }

        public void Load()
        {
            Load(Config.GetInstance().defaultHeightMapFilename);
        }

        public void Load(string filename)
        {
            Bitmap bitmap = Bitmap.FromFile(filename) as Bitmap;
            int width = bitmap.Width;
            int height = bitmap.Height;
            HeightMap.GetInstance().Width = width;
            HeightMap.GetInstance().Height = height;
            HeightMap.GetInstance().Map = new float[width, height];
            Console.WriteLine("loaded bitmap " + width + " x " + height);
            double minheight = Config.GetInstance().minheight;
            double maxheight = Config.GetInstance().maxheight;
            double heightmultiplier = ( maxheight - minheight ) / 255;
            for (int i = 0; i < width; i++)
            {
                for (int j = 0; j < height; j++)
                {
                    HeightMap.GetInstance().Map[i, j] = (float)( minheight + heightmultiplier * bitmap.GetPixel(i, j).B );
                }
            }
        }

        void Save()
        {
            if (lastfilename != "")
            {
                Save(lastfilename);
            }
            else
            {
                Save(Config.GetInstance().defaultHeightMapFilename);
            }
        }

        void Save(string filename)
        {
            float[,]mesh = HeightMap.GetInstance().Map;
            int width = mesh.GetUpperBound(0) + 1;
            int height = mesh.GetUpperBound(1) + 1;
            Bitmap bitmap = new Bitmap( width, height, PixelFormat.Format24bppRgb );
            Graphics g = Graphics.FromImage(bitmap);
            Pen[] pens = new Pen[256];
            for (int i = 0; i < 256; i++)
            {
                pens[i] = new Pen(System.Drawing.Color.FromArgb(i, i, i));
            }
            double minheight = Config.GetInstance().minheight;
            double maxheight = Config.GetInstance().maxheight;
            double heightmultiplier = 255 / (maxheight - minheight);
            for (int i = 0; i < width; i++)
            {
                for( int j = 0; j < height; j++ )
                {
                    int normalizedmeshvalue = (int)( (mesh[i, j] - minheight) * heightmultiplier );
                    normalizedmeshvalue = Math.Max( 0,normalizedmeshvalue );
                    normalizedmeshvalue = Math.Min( 255,normalizedmeshvalue );
                    g.DrawRectangle(pens[ normalizedmeshvalue ], i, j, 1, 1);
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

        void LoadHandler(string command, bool down)
        {
            if (down)
            {
                Load();
            }
        }
    }
}
