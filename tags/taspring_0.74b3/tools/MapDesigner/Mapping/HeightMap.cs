using System;
using System.Collections.Generic;
using System.Text;

namespace MapDesigner
{
    class HeightMap
    {
        public int Width = 1025;
        public int Height = 1025;
        public double[,] Map;

        public double MinHeight = 0;
        public double MaxHeight = 255;

        static HeightMap instance = new HeightMap();
        public static HeightMap GetInstance() { return instance; }

        HeightMap()
        {
            Width = Config.GetInstance().iMapDefaultWidth;
            Height = Config.GetInstance().iMapDefaultHeight;
            MinHeight = Config.GetInstance().minheight;
            MaxHeight = Config.GetInstance().maxheight;
            Map = new double[Width, Height];
            Console.WriteLine( "HeightMap() " + Width + " " + Height);
        } // protected constructor, enforce singleton

        public void DataChanged(int x, int y, int xwidth, int ywidth)
        {
        }
    }
}
