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
//using System.Drawing;

namespace MapDesigner
{
    public class Sm3Persistence
    {
        static Sm3Persistence instance = new Sm3Persistence();
        public static Sm3Persistence GetInstance() { return instance; }

        Terrain terrain;

        public Sm3Persistence()
        {
            terrain = Terrain.GetInstance();
        }

        //TdfParser tdfparser = null;

        public void NewSm3()
        {
            //terrain.tdfparser = null;
            //terrain.Sm3Filename = "";
            terrain.NewMap();
            //terrain.OnTerrainModified();
        }

        public void SaveSm3(string filename)
        {
        }

        public void LoadSm3(string filename)
        {
            terrain.tdfparser = TdfParser.FromFile(filename);
            TdfParser.Section terrainsection = terrain.tdfparser.RootSection.SubSection("map/terrain");
            string tdfdirectory = Path.GetDirectoryName(Path.GetDirectoryName(filename));
            LoadTextureStages( tdfdirectory, terrainsection );
            LoadHeightMap(tdfdirectory, terrainsection);
            terrain.OnTerrainModified();
            MainUI.GetInstance().uiwindow.InfoMessage("SM3 load completed");
        }

        void LoadHeightMap( string sm3directory, TdfParser.Section terrainsection)
        {
            string filename = Path.Combine( sm3directory, terrainsection.GetStringValue("heightmap") );
            double heightoffset = terrainsection.GetDoubleValue("heightoffset");
            double heightscale = terrainsection.GetDoubleValue("heightscale");
            LogFile.GetInstance().WriteLine("heightoffset: " + heightoffset + " heightscale " + heightscale);
            Terrain.GetInstance().MinHeight = heightoffset;
            Terrain.GetInstance().MaxHeight = heightoffset + heightscale; // I guess???

            Image image = new Image(filename);
            //Bitmap bitmap = DevIL.DevIL.LoadBitmap(filename);
            int width = image.Width;
            int height = image.Height;
            Terrain.GetInstance().HeightMapWidth = width;
            Terrain.GetInstance().HeightMapHeight = height;
            Terrain.GetInstance().Map = new double[width, height];
            LogFile.GetInstance().WriteLine("loaded bitmap " + width + " x " + height);
            double minheight = Terrain.GetInstance().MinHeight;
            double maxheight = Terrain.GetInstance().MaxHeight;
            double heightmultiplier = (maxheight - minheight) / 255;
            LogFile.GetInstance().WriteLine("heightmultiplier: " + heightmultiplier + " minheight: " + minheight);
            for (int i = 0; i < width; i++)
            {
                for (int j = 0; j < height; j++)
                {
                    Terrain.GetInstance().Map[i, j] = 
                        (float)(minheight + heightmultiplier * 
                        image.GetBlue(i,j) );
                }
            }
            terrain.HeightmapFilename = filename;
        }

        List<MapTextureStage> LoadTextureStages(string sm3directory, TdfParser.Section terrainsection)
        {
            int numstages = terrainsection.GetIntValue("numtexturestages");
            List<MapTextureStage> stages = new List<MapTextureStage>();
            for (int i = 0; i < numstages; i++)
            {
                TdfParser.Section texstagesection = terrainsection.SubSection("texstage" + i);
                string texturename = texstagesection.GetStringValue("source");
                string blendertexturename = texstagesection.GetStringValue("blender");
                string operation = texstagesection.GetStringValue("operation").ToLower();

                int tilesize;
                ITexture texture = LoadTexture( sm3directory, terrainsection, texturename, out tilesize );
                if (operation == "blend")
                {
                    ITexture blendtexture = LoadTextureAsAlpha(sm3directory, terrainsection, blendertexturename);
                    stages.Add( new MapTextureStage(MapTextureStage.OperationType.Blend, tilesize, texture, blendtexture) );
                }
                else // todo: add other operations
                {
                    stages.Add( new MapTextureStage(MapTextureStage.OperationType.Replace, tilesize, texture ) );
                }
            }
            Terrain.GetInstance().texturestages = stages;
            return stages;
        }

        ITexture LoadTexture( string sm3directory, TdfParser.Section terrainsection, string texturesectionname, out int tilesize )
        {
            TdfParser.Section texturesection = terrainsection.SubSection(texturesectionname);
            string texturename = Path.Combine( sm3directory, texturesection.GetStringValue("file") );
            LogFile.GetInstance().WriteLine(texturename);
            tilesize = texturesection.GetIntValue("tilesize");
            return GlTexture.FromFile(texturename);
        }

        ITexture LoadTextureAsAlpha(string sm3directory, TdfParser.Section terrainsection, string texturesectionname)
        {
            TdfParser.Section texturesection = terrainsection.SubSection(texturesectionname);
            string texturename = Path.Combine( sm3directory, texturesection.GetStringValue("file") );
            LogFile.GetInstance().WriteLine(texturename);
            return GlTexture.FromAlphamapFile(texturename);
        }
    }
}
