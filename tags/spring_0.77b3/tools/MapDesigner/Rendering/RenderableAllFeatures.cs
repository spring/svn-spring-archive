using System;
using System.Collections.Generic;
using System.Text;
using Tao.OpenGl;

namespace MapDesigner
{
    // renders all features
    //
    // for now we assume < 100 features, so no position indexing, just a list of features
    // we check culling on each then render
    // no LoD because S3O doesnt support it (yet)
    public class RenderableAllFeatures
    {
        public class FeatureInfo
        {
            //public Vector3 Position; // ignore height, get height from terrain
            //                         // position is in map coordinates (not gl coordinates)
            public int x;
            public int y;
            public Rot rot; // not used yet really
            public Unit unit;
            public FeatureInfo()
            {
            }
            public FeatureInfo(Unit unit, int x, int y)
            {
                this.unit = unit;
                this.x = x;
                this.y = y;
            }
        }

        Terrain parent;
        List<FeatureInfo> features = new List<FeatureInfo>();

        public RenderableAllFeatures( Terrain parent )
        {
            this.parent = parent;
            RendererFactory.GetInstance().WriteNextFrameEvent += new WriteNextFrameCallback(RenderableAllFeatures_WriteNextFrameEvent);
            parent.TerrainModified += new Terrain.TerrainModifiedHandler(parent_TerrainModified);
            parent.FeatureAdded += new Terrain.FeatureAddedHandler(parent_FeatureAdded);
            parent.FeatureRemoved += new Terrain.FeatureRemovedHandler(parent_FeatureRemoved);
        }

        void parent_FeatureAdded(Unit unit, int x, int y)
        {
            LogFile.GetInstance().WriteLine("raf feature added " + unit.texture1 + " " + x + " " + y);
            features.Add(new FeatureInfo(unit, x, y));
        }

        void parent_FeatureRemoved(Unit unit, int x, int y)
        {
            List<FeatureInfo> featureinfostoremove = new List<FeatureInfo>();
            foreach (FeatureInfo featureinfo in features)
            {
                if (featureinfo.x == x && featureinfo.y == y)
                {
                    featureinfostoremove.Add(featureinfo);
                }
            }
            foreach (FeatureInfo featureinfo in featureinfostoremove)
            {
                features.Remove(featureinfo);
            }
        }

        void parent_TerrainModified()
        {
            LogFile.GetInstance().WriteLine("terrain modified");
            features = new List<FeatureInfo>();
            for (int x = 0; x < parent.MapWidth; x++)
            {
                for (int y = 0; y < parent.MapHeight; y++)
                {
                    if (parent.FeatureMap[x, y] != null)
                    {
                        LogFile.GetInstance().WriteLine("raf feature found: " + parent.FeatureMap[x, y].texture1 + " " + x + " " + y);
                        features.Add(new FeatureInfo(parent.FeatureMap[x, y], x, y));
                    }
                }
            }
        }

        void RenderableAllFeatures_WriteNextFrameEvent(Vector3 camerapos)
        {
            //Console.WriteLine("raf writenextframe");
            GraphicsHelperGl g = new GraphicsHelperGl();
            FrustrumCulling culling = FrustrumCulling.GetInstance();
            foreach (FeatureInfo featureinfo in features)
            {
                Vector3 displaypos = new Vector3( featureinfo.x * Terrain.SquareSize, featureinfo.y * Terrain.SquareSize,
                    parent.Map[ featureinfo.x, featureinfo.y ] );
              //  Console.WriteLine("displaypos: " + displaypos );
                if (culling.IsInsideFrustum(displaypos, featureinfo.unit.Radius))
                {
                //    Console.WriteLine("culling ok");
                    g.PushMatrix();
                    g.Translate(displaypos);
                    featureinfo.unit.Render();
                    g.PopMatrix();
                }
            }
        }
    }
}
