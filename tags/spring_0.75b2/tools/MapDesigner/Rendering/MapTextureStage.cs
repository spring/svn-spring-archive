// Copyright Hugh Perkins 2006
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

// Concepts and implementation details based on code by Jelmer Cnossen, 
// in particular, TerrainTexEnvMapping.cpp from the Spring project.
// Licence header from this file:
/*
---------------------------------------------------------------------
   Terrain Renderer using texture splatting and geomipmapping
   Copyright (c) 2006 Jelmer Cnossen

   This software is provided 'as-is', without any express or implied
   warranty. In no event will the authors be held liable for any
   damages arising from the use of this software.

   Permission is granted to anyone to use this software for any
   purpose, including commercial applications, and to alter it and
   redistribute it freely, subject to the following restrictions:

   1. The origin of this software must not be misrepresented; you
      must not claim that you wrote the original software. If you use
      this software in a product, an acknowledgment in the product
      documentation would be appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and
      must not be misrepresented as being the original software.

   3. This notice may not be removed or altered from any source
      distribution.

   Jelmer Cnossen
   j.cnossen at gmail dot com
---------------------------------------------------------------------
*/

using System;
using System.Collections.Generic;
using System.Text;
//using System.Drawing;
using Tao.OpenGl;

namespace MapDesigner
{
    // represents a single maptexture stage, eg one stage from md3
    // this could represent two opengl texture stages, eg for blend
    public class MapTextureStage
    {
        public enum OperationType
        {
            NoTexture,  // hack to allow map to run with no texturestages. note to self: cleanup
            Blend,
            Add,
            Multiply,
            Subtract,
            Replace,
            Nop
        };

        public OperationType Operation = OperationType.NoTexture;
        public ITexture texture;
        public ITexture blendtexture;
        public int Tilesize;

        public string BlendTextureFilename
        {
            get
            {
                if (blendtexture == null)
                {
                    return "";
                }
                return blendtexture.Filename;
            }
        }

        public string SplatTextureFilename{ get {
                if (texture == null)
                {
                    return "";
                }
                return texture.Filename;
            }
        }

        public int NumTextureStagesRequired
        {
            get
            {
                if (Operation == OperationType.Nop)
                {
                    return 0;
                }
                if (Operation == OperationType.Blend)
                {
                    return 2;
                }
                return 1;
            }
        }

        void CreateBlankTexture()
        {
            LogFile.GetInstance().WriteLine("CreateBlankTexture()");
            //Bitmap bitmap = new Bitmap(1, 1, System.Drawing.Imaging.PixelFormat.Format24bppRgb);
            //Graphics g = Graphics.FromImage(bitmap);
            //Pen pen = new Pen(System.Drawing.Color.FromArgb(255,255, 255, 255));
            //g.DrawRectangle(pen, 0, 0, 1, 1);
            //DevIL.DevIL.SaveBitmap("testout.JPG", bitmap);
            Image image = new Image(1, 1);
            image.SetPixel(0, 0, 255, 255, 255, 255);
            this.texture = new GlTexture(image,false);
        }

        void CreateBlankBlendTexture()
        {
            //Bitmap bitmap = new Bitmap(512, 512);
            this.blendtexture = new GlTexture( 512, 512, true);
        }

        // defaults to no texture
        public MapTextureStage()
        {
            this.Operation = OperationType.Replace;
            this.Tilesize = 50;
            CreateBlankTexture();
            CreateBlankBlendTexture();
        }

        public MapTextureStage(OperationType operation)
        {
            LogFile.GetInstance().WriteLine("MapTextureStage(), operation");
            this.Operation = operation;
            this.Tilesize = 50;
            CreateBlankTexture();
            CreateBlankBlendTexture();
        }
        
        public MapTextureStage(OperationType operation, int Tilesize, ITexture texture)
        {
            LogFile.GetInstance().WriteLine("MapTextureStage(), single stages");
            this.Operation = operation;
            this.texture = texture;
            this.Tilesize = Tilesize;
            CreateBlankBlendTexture();
        }

        // blend needs two textures
        public MapTextureStage(OperationType operation, int Tilesize, ITexture texture, ITexture blendtexture)
        {
            LogFile.GetInstance().WriteLine("MapTextureStage(), two stages");
            this.Operation = operation;
            this.texture = texture;
            this.blendtexture = blendtexture;
            this.Tilesize = Tilesize;
        }

        void SetTextureScale(double scale)
        {
            // matrix texture scaling from http://www.kraftwrk.com/multi_texturing.htm
            // Now we want to enter the texture matrix. This will allow us
            // to change the tiling of the detail texture.
            Gl.glMatrixMode(Gl.GL_TEXTURE);
            // Reset the current matrix and apply our chosen scale value
            Gl.glLoadIdentity();
            Gl.glScalef((float)scale, (float)scale, 1);
            // Leave the texture matrix and set us back in the model view matrix
            Gl.glMatrixMode(Gl.GL_MODELVIEW);
        }

        // applies texture stage setup to gl.  texturestagenum will be 0 except for blend
        // where it will be either 0 or 1
        // texture coordinates are handled independently (?)
        // either we're using multipass or we're using multitexture.  multipass still uses 2 multitexture units, but not 4, 6, 8, ...
        public void Apply(int texturestagenum, bool UsingMultipass, int mapwidth, int mapheight)
        {
            //Console.WriteLine("Apply");
            GlTextureCombine texturecombine;
            GraphicsHelperGl g = new GraphicsHelperGl();
            switch (Operation)
            {
                case OperationType.NoTexture:
                    g.DisableTexture2d();
                    g.EnableModulate();
                    break;
                case OperationType.Add:
                    texture.Apply();
                    SetTextureScale(1 / (double)Tilesize);
                    texturecombine = new GlTextureCombine();
                    texturecombine.Operation = GlTextureCombine.OperationType.Add;
                    texturecombine.Args[0].SetRgbaSource(GlCombineArg.Source.Previous);
                    texturecombine.Args[1].SetRgbaSource(GlCombineArg.Source.Texture);
                    texturecombine.Apply();
                    break;
                case OperationType.Blend:
                    if (UsingMultipass)
                    {
                        if (texturestagenum == 0)
                        {
                            blendtexture.Apply();
                            SetTextureScale(1 / (double)mapwidth);
                            texturecombine = new GlTextureCombine();
                            texturecombine.Operation = GlTextureCombine.OperationType.Replace;
                            texturecombine.Args[0].SetAlphaSource(GlCombineArg.Source.Texture, GlCombineArg.Operand.Alpha);
                            texturecombine.Apply();
                        }
                        else
                        {
                            texture.Apply();
                            SetTextureScale(1 / (double)Tilesize);
                            new GraphicsHelperGl().EnableModulate();
                        }
                    }
                    else
                    {
                        if (texturestagenum == 0)
                        {
                            blendtexture.Apply();
                            SetTextureScale(1 / (double)mapwidth);
                            texturecombine = new GlTextureCombine();
                            texturecombine.Operation = GlTextureCombine.OperationType.Replace;
                            texturecombine.Args[0].SetRgbSource(GlCombineArg.Source.Previous, GlCombineArg.Operand.Rgb);
                            texturecombine.Args[0].SetAlphaSource(GlCombineArg.Source.Texture, GlCombineArg.Operand.Alpha);
                            texturecombine.Apply();
                        }
                        else
                        {
                            texture.Apply();
                            SetTextureScale(1 / (double)Tilesize);
                            texturecombine = new GlTextureCombine();
                            texturecombine.Operation = GlTextureCombine.OperationType.Interpolate;
                            texturecombine.Args[0].SetRgbaSource(GlCombineArg.Source.Previous);
                            texturecombine.Args[1].SetRgbaSource(GlCombineArg.Source.Texture);
                            texturecombine.Args[2].SetRgbSource(GlCombineArg.Source.Previous, GlCombineArg.Operand.Alpha);
                            texturecombine.Args[2].SetAlphaSource(GlCombineArg.Source.Previous, GlCombineArg.Operand.Alpha);
                            texturecombine.Apply();
                        }
                    }
                    break;
                case OperationType.Multiply:
                    texture.Apply();
                    SetTextureScale(1 / (double)Tilesize);
                    texturecombine = new GlTextureCombine();
                    texturecombine.Operation = GlTextureCombine.OperationType.Modulate;
                    texturecombine.Args[0].SetRgbaSource(GlCombineArg.Source.Previous);
                    texturecombine.Args[1].SetRgbaSource(GlCombineArg.Source.Texture);
                    texturecombine.Apply();
                    break;
                case OperationType.Subtract:
                    texture.Apply();
                    SetTextureScale(1 / (double)Tilesize);
                    texturecombine = new GlTextureCombine();
                    texturecombine.Operation = GlTextureCombine.OperationType.Subtract;
                    texturecombine.Args[0].SetRgbaSource(GlCombineArg.Source.Previous);
                    texturecombine.Args[1].SetRgbaSource(GlCombineArg.Source.Texture);
                    texturecombine.Apply();
                    break;
                case OperationType.Replace:
                    texture.Apply();
                    SetTextureScale(1 / (double)Tilesize);
                    texturecombine = new GlTextureCombine();
                    texturecombine.Operation = GlTextureCombine.OperationType.Modulate;
                    texturecombine.Args[0].SetRgbaSource(GlCombineArg.Source.Texture);
                    texturecombine.Args[1].SetRgbaSource(GlCombineArg.Source.Fragment);
                    texturecombine.Apply();
                    break;
            }
        }

        // determines if this stage affects the map coordinates specified
        // returns true always, except for Blend
        public bool Affects(int mapx, int mapy, int mapwidth, int mapheight)
        {
            //Console.WriteLine("Affects");
            if (Operation == OperationType.Nop)
            {
              //  Console.WriteLine("return false: Nop");
                return false;
            }
            if (Operation != OperationType.Blend)
            {
                //Console.WriteLine("return true: !Blend");
                return true;
            }
            int texturex = ( blendtexture.AlphaData.GetUpperBound(0) * mapx ) / mapwidth;
            int texturey = (blendtexture.AlphaData.GetUpperBound(1) * mapy) / mapheight;
            try
            {
                if (blendtexture.AlphaData[texturex, texturey] > 0)
                {
                    return true;
                }
            }
            catch (Exception)
            {
                throw new Exception("texturex: " + texturex + " " + texturey + " mapx " + mapx + " mapy " + mapy + " mapwidth " + mapwidth + " " + mapheight);
            }
            return false;
        }
    }
}
