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

namespace MapDesigner
{
    public class Terrain
    {
        public delegate void TerrainModifiedHandler();
        public delegate void FeatureAddedHandler(Unit unit, int x, int y);
        public delegate void FeatureRemovedHandler(Unit unit, int x, int y);
        public delegate void HeightmapInPlaceEditedHandler(int xleft, int ytop, int xright, int ybottom);
        public delegate void BlendmapInPlaceEditedHandler(MapTextureStage maptexturestage, int xleft, int ytop, int xright, int ybottom);

        public event TerrainModifiedHandler TerrainModified;  // any change to terrain, heightmap, mapblendtexture except for
                                                              // heightmap in-place edited, or blend texture in-placed edited
        public event HeightmapInPlaceEditedHandler HeightmapInPlaceEdited;// we edited the heightmap, highfrequency change
        public event BlendmapInPlaceEditedHandler BlendmapInPlaceEdited;  // we edied the blendmap, highfrequency change
        public event FeatureAddedHandler FeatureAdded;
        public event FeatureRemovedHandler FeatureRemoved;

        static Terrain instance = new Terrain();
        public static Terrain GetInstance() { return instance; }

        public string Sm3Filename = "";
        public TdfParser tdfparser;

        public const int SquareSize = 8;

        public string HeightmapFilename = "";
        public int HeightMapWidth
        {
            get { return MapWidth + 1; }
            set { MapWidth = value - 1; }
        }
        public int HeightMapHeight
        {
            get{ return MapHeight + 1; }
            set{ MapHeight = value - 1; }
        }
        //public int HeightMapWidth = 1025;
        //public int HeightMapHeight = 1025;
        public double[,] Map;

        public double MinHeight = 0;
        public double MaxHeight = 255;

        /// <summary>
        /// mapwidth, not including 1 pixel border on heightmap
        /// </summary>
        public int MapWidth;
        /// <summary>
        /// mapheight, not including 1 pixel border on heightmap
        /// </summary>
        public int MapHeight;
        public Unit[,] FeatureMap; // assume max one feature per position.  Seems reasonable?

        RenderableHeightMap renderableheightmap;
        RenderableAllFeatures renderableallfeatures;
        RenderableWater renderablewater;
        public RenderableMinimap renderableminimap;

        public List<MapTextureStage> texturestages = new List<MapTextureStage>();

        public Terrain()
        {
            MapWidth = Config.GetInstance().iMapDefaultWidth - 1;
            MapHeight = Config.GetInstance().iMapDefaultHeight - 1;
            MinHeight = Config.GetInstance().minheight;
            MaxHeight = Config.GetInstance().maxheight;
            Map = new double[HeightMapWidth, HeightMapHeight];
            FeatureMap = new Unit[MapWidth, MapHeight];

            InitMap( MinHeight );
            LogFile.GetInstance().WriteLine("HeightMap() " + HeightMapWidth + " " + HeightMapHeight);

            texturestages = new List<MapTextureStage>();
            texturestages.Add( new MapTextureStage() );

            //texturestages = Sm3Persistence.GetInstance().LoadTextureStages(TdfParser.FromFile("maps/Whakamatunga_Riri.sm3").RootSection.SubSection("map/terrain"));
            //Sm3Persistence.GetInstance().LoadHeightMap(TdfParser.FromFile("maps/Whakamatunga_Riri.sm3").RootSection.SubSection("map/terrain"));

            renderableheightmap = new RenderableHeightMap(this, Map, SquareSize, SquareSize, texturestages);
            renderableallfeatures = new RenderableAllFeatures(this);
            // water must be last, otherwise you cant see through it ;-)
            renderablewater = new RenderableWater(new Vector3(), new Vector2(HeightMapWidth * SquareSize, HeightMapHeight * SquareSize));
            // minimap last, covers everything else
            renderableminimap = new RenderableMinimap(this, renderableheightmap);
            
            //OnTerrainModified();
        }

        // scale or clip defined by Scale
        // mapsize is not including the +1 pixel border for heightmaps
        public void ChangeMapSize(int newmapsizex, int newmapsizey, bool Scale)
        {
            double[,] newmap = new double[newmapsizex + 1, newmapsizey + 1];
            for (int x = 0; x < newmapsizex + 1; x++)
            {
                for (int y = 0; y < newmapsizey + 1; y++)
                {
                    if (Scale)
                    {
                        int oldx = (x * HeightMapWidth) / (newmapsizex + 1);
                        int oldy = (y * HeightMapHeight) / (newmapsizey + 1);
                        newmap[x, y] = Map[oldx, oldy];
                    }
                    else
                    {
                        if (x < HeightMapWidth && y < HeightMapHeight)
                        {
                            newmap[x, y] = Map[x, y];
                        }
                        else
                        {
                            newmap[x, y] = MinHeight;
                        }
                    }
                }
            }
            Map = newmap;
            HeightMapWidth = newmapsizex + 1;
            HeightMapHeight = newmapsizey + 1;
            OnTerrainModified();
        }

        // scale or clip defined by Scale
        public void ChangeHeightScale(double minheight, double maxheight, bool Scale)
        {
            if (Scale)
            {
                //double offset = minheight - this.MinHeight;
                double multiplier = (maxheight - minheight) / (this.MaxHeight - this.MinHeight);
                for (int x = 0; x < HeightMapWidth; x++)
                {
                    for (int y = 0; y < HeightMapHeight; y++)
                    {
                        Map[x, y] = (Map[x, y] - this.MinHeight) * multiplier + minheight;
                    }
                }
            }
            else
            {
                for (int x = 0; x < HeightMapWidth; x++)
                {
                    for (int y = 0; y < HeightMapHeight; y++)
                    {
                        Map[x, y] = Math.Max(minheight, Math.Min(maxheight, Map[x, y]));
                    }
                }
            }
            this.MinHeight = minheight;
            this.MaxHeight = maxheight;
            OnTerrainModified();
        }

        public void NewMap()
        {
            HeightMapWidth = Config.GetInstance().iMapDefaultWidth;
            HeightMapHeight = Config.GetInstance().iMapDefaultHeight;
            MinHeight = Config.GetInstance().minheight;
            MaxHeight = Config.GetInstance().maxheight;
            Map = new double[HeightMapWidth, HeightMapHeight];
            InitMap(MinHeight);
            LogFile.GetInstance().WriteLine("HeightMap() " + HeightMapWidth + " " + HeightMapHeight);

            texturestages.Clear();
            texturestages.Add( new MapTextureStage() );
            FeatureMap = new Unit[MapWidth, MapHeight];

            OnTerrainModified();
        }

        public void InitMap( double height )
        {
            for (int x = 0; x < HeightMapWidth; x++)
            {
                for (int y = 0; y < HeightMapHeight; y++)
                {
                    Map[x, y] = height;
                }
            }
        }

        // in-place blendmaptexture editing
        public void OnBlendMapInPlaceEdited( MapTextureStage maptexturestage, int xleft, int ytop, int xright, int ybottom ) // probably could be a little more specific...
        {
            //renderableheightmap.MapTexturesModified(Math.Max(0, xleft), Math.Max(0, ytop), Math.Min(HeightMapWidth - 1, xright), Math.Min(HeightMapHeight - 1, ybottom));
            if (BlendmapInPlaceEdited != null)
            {
                BlendmapInPlaceEdited(maptexturestage, Math.Max(0, xleft), Math.Max(0, ytop), Math.Min(HeightMapWidth - 2, xright), Math.Min(HeightMapHeight - 2, ybottom));
            }
        }

        // in-place heightmap editing
        public void OnHeightMapInPlaceEdited(int xleft, int ytop, int xright, int ybottom)
        {
            if (HeightmapInPlaceEdited != null)
            {
                HeightmapInPlaceEdited(Math.Max(0, xleft), Math.Max(0, ytop), Math.Min(HeightMapWidth - 2, xright), Math.Min(HeightMapHeight - 2, ybottom));
            }
            // renderablewater.Scale = new Vector2(HeightMapWidth * SquareSize, HeightMapHeight * SquareSize);
        }

        // anything not covered by other handlers
        public void OnTerrainModified()
        {
            if (TerrainModified != null)
            {
                TerrainModified();
            }
            renderablewater.Scale = new Vector2(HeightMapWidth * SquareSize, HeightMapHeight * SquareSize);
        }

        public void OnFeatureAdded(Unit unit, int x, int y)
        {
            if (FeatureAdded != null)
            {
                FeatureAdded(unit, x, y);
            }
        }

        public void OnFeatureRemoved(Unit unit, int x, int y)
        {
            if (FeatureRemoved != null)
            {
                FeatureRemoved(unit, x, y);
            }
        }

        public void SetLod(int[] lod)
        {
            renderableheightmap.loddistances = lod;
        }

        public int[] GetLod()
        {
            return renderableheightmap.loddistances;
        }
    }
}
