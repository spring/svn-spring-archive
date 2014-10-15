// Created by Hugh Perkins 2006
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
using Tao.OpenGl;

namespace MapDesigner
{
    // capable of rendering an S3O
    // Note to self: these Renderable classes should probably derive from a common interface
    public class RenderableS3o
    {
        Unit unit;
        GraphicsHelperGl g;
        GlTexture texture1;
        //ITexture texture2;

        ~RenderableS3o()
        {
            // note to self: do something about this
         //   Gl.glDeleteTextures(1, new int[] { texture1.GlReference });
        }

        public RenderableS3o( string s3opath )
        {
            g = new GraphicsHelperGl();
            unit = new S3oLoader().LoadS3o(s3opath);
            if (unit.texturename1 == "Spring unit")
            {
               unit.texturename1 = "Default.tga";
               unit.texturename2 = "Default.tga";
            }
            string texturedirectory = Path.Combine(Path.GetDirectoryName(Path.GetDirectoryName(s3opath)), "unittextures");
            LogFile.GetInstance().WriteLine( texturedirectory + "\\" + unit.texturename1 + "]");
            texture1 = GlTexture.FromFile(texturedirectory + "/" + unit.texturename1);
        }

        // performance benchmarks show rendering directly not much slower than VertexArray or VBO)
        // (but we really ought to think about using at least a vertexarray, or ideally a vbo)
        public void Render()
        {
            g.PushMatrix();
            texture1.Apply();
            RenderUnitPart(unit.unitpart);
            g.PopMatrix();
            g.Bind2DTexture(0);
        }

        void RenderUnitPart( UnitPart unitpart )
        {
            Gl.glPushMatrix();
            g.Translate(unitpart.Offset);
            switch (unitpart.PrimitiveType)
            {
                case UnitPart.PrimitiveTypeEnum.Triangles:
                    {
                        Gl.glBegin(Gl.GL_TRIANGLES);
                        foreach (Primitive primitive in unitpart.Primitives)
                        {
                            Triangle triangle = primitive as Triangle;
                            g.Normal(triangle.Vertices[0].Normal);
                            g.TexCoord(triangle.Vertices[0].TextureCoords);
                            g.Vertex(triangle.Vertices[0].Pos);

                            g.Normal(triangle.Vertices[1].Normal);
                            g.TexCoord(triangle.Vertices[1].TextureCoords);
                            g.Vertex(triangle.Vertices[1].Pos);

                            g.Normal(triangle.Vertices[2].Normal);
                            g.TexCoord(triangle.Vertices[2].TextureCoords);
                            g.Vertex(triangle.Vertices[2].Pos);
                        }
                        Gl.glEnd();
                        break;
                    }
                case UnitPart.PrimitiveTypeEnum.Quads:
                    {
                        Gl.glBegin(Gl.GL_QUADS);
                        foreach (Primitive primitive in unitpart.Primitives)
                        {
                            Quad quad = primitive as Quad;
                            g.Normal(quad.Vertices[0].Normal);
                            g.TexCoord(quad.Vertices[0].TextureCoords);
                            g.Vertex(quad.Vertices[0].Pos);

                            g.Normal(quad.Vertices[1].Normal);
                            g.TexCoord(quad.Vertices[1].TextureCoords);
                            g.Vertex(quad.Vertices[1].Pos);

                            g.Normal(quad.Vertices[2].Normal);
                            g.TexCoord(quad.Vertices[2].TextureCoords);
                            g.Vertex(quad.Vertices[2].Pos);

                            g.Normal(quad.Vertices[3].Normal);
                            g.TexCoord(quad.Vertices[3].TextureCoords);
                            g.Vertex(quad.Vertices[3].Pos);
                        }
                        Gl.glEnd();
                        break;
                    }
                case UnitPart.PrimitiveTypeEnum.TriangleStrips:
                    {
                        foreach (Primitive primitive in unitpart.Primitives)
                        {
                            TriangleStrip trianglestrip = primitive as TriangleStrip;
                            Gl.glBegin(Gl.GL_TRIANGLE_STRIP);
                            foreach (Vertex vertex in trianglestrip.Vertices)
                            {
                                g.Normal(vertex.Normal);
                                g.TexCoord(vertex.TextureCoords);
                                g.Vertex(vertex.Pos);
                            }
                            Gl.glEnd();
                        }
                        break;
                    }
            }

            foreach (UnitPart childunitpart in unitpart.Children)
            {
                RenderUnitPart(childunitpart);
            }
            Gl.glPopMatrix();
        }
    }
}
