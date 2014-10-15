using System;
using System.Collections.Generic;
using System.Text;

public class Primitive
{
}

public class Triangle : Primitive
{
    public Vertex[] Vertices = new Vertex[3];
}

public class TriangleStrip : Primitive
{
    public Vertex[] Vertices;
}

public class Quad : Primitive
{
    public Vertex[] Vertices = new Vertex[4];
}
