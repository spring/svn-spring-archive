using System;
using System.Collections.Generic;
using System.Text;

namespace MapDesigner
{
    class UICommand
    {
    }
    class UICommandChangeBrushSize : UICommand
    {
        public int size;
        public UICommandChangeBrushSize(int size)
        {
            this.size = size;
        }
    }
    class UICommandBrushEffect : UICommand
    {
        public enum BrushEffect
        {
            Flatten,
            RaiseLower
        }
        public BrushEffect effect;
        public UICommandBrushEffect(BrushEffect effect)
        {
            this.effect = effect;
        }
    }
    class CmdNewHeightMap : UICommand
    {
        public int width;
        public int height;
        public CmdNewHeightMap(int width, int height) { this.width = width; this.height = height; }
    }
    class CmdSaveHeightMap : UICommand
    {
        public string FilePath;
        public CmdSaveHeightMap(string filepath) { this.FilePath = filepath; }
    }
    class CmdOpenHeightMap : UICommand
    {
        public string FilePath;
        public CmdOpenHeightMap(string filepath) { this.FilePath = filepath; }
    }
    class CmdExportSlopeMap : UICommand
    {
        public string FilePath;
        public CmdExportSlopeMap(string filepath) { this.FilePath = filepath; }
    }
}
