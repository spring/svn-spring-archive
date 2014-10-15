using System;
using System.Collections.Generic;
using System.Text;
using Tao.OpenGl;

public class UnitPart
{
    public enum PrimitiveTypeEnum
    {
        Quads,
        TriangleStrips,
        Triangles
    };
    public string Name;
    public Vector3 Offset;
    public List<UnitPart> Children = new List<UnitPart>();

    public PrimitiveTypeEnum PrimitiveType;
    //public Vertex[] Vertices;
    public Primitive[] Primitives;

    public void Render()
    {
        GraphicsHelperGl g = new GraphicsHelperGl();
        Gl.glPushMatrix();
        g.Translate(Offset);
        switch (PrimitiveType)
        {
            case UnitPart.PrimitiveTypeEnum.Triangles:
                {
                    Gl.glBegin(Gl.GL_TRIANGLES);
                    foreach (Primitive primitive in Primitives)
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
                    foreach (Primitive primitive in Primitives)
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
                    foreach (Primitive primitive in Primitives)
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

        foreach (UnitPart childunitpart in Children)
        {
            childunitpart.Render();
        }
        Gl.glPopMatrix();
    }
}

