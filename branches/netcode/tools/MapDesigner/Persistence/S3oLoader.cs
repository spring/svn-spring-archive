// Created by Jelmer Cnossen, Hugh Perkins 2006
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
// Created in C++ by Jelmer Cnossen
// Ported to C# by Hugh Perkins
//

using System;
using System.Reflection;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
//using MapDesigner;

[AttributeUsage(AttributeTargets.All, Inherited = false, AllowMultiple = true)]
public class ArraySizeAttribute : Attribute
{
    public int size;
    public ArraySizeAttribute(int size) { this.size = size; }
}

[StructLayout(LayoutKind.Sequential)]
class _S3OPiece
{
    public uint name;		//offset in file to char* name of this piece
    public uint numChilds;		//number of sub pieces this piece has
    public uint childs;		//file offset to table of dwords containing offsets to child pieces
    public uint numVertices;	//number of vertices in this piece
    public uint vertices;		//file offset to vertices in this piece
    public uint vertexType;	//0 for now
    public uint primitiveType;	//type of primitives for this piece, 0=triangles,1 triangle strips,2=quads
    public uint vertexTableSize;	//number of indexes in vertice table
    public uint vertexTable;	//file offset to vertice table, vertice table is made up of dwords indicating vertices for this piece, to indicate end of a triangle strip use 0xffffffff
    public uint collisionData;	//offset in file to collision data, must be 0 for now (no collision data)
    public float xoffset;		//offset from parent piece
    public float yoffset;
    public float zoffset;
}

[StructLayout(LayoutKind.Sequential)]
class _S3OVertex
{
    public float xpos;		//position of vertex relative piece origin
    public float ypos;
    public float zpos;
    public float xnormal;		//normal of vertex relative piece rotation
    public float ynormal;
    public float znormal;
    public float texu;		//texture offset for vertex
    public float texv;
}

[StructLayout(LayoutKind.Sequential)]
class _S3OHeader
{
    [ArraySize(12)]
    public string magic;		//"Spring unit\0"
    public uint version;		//0 for this version
    public float radius;		//radius of collision sphere
    public float height;		//height of whole object
    public float midx;		//these give the offset from origin(which is supposed to lay in the ground plane) to the middle of the unit collision sphere
    public float midy;
    public float midz;
    public uint rootPiece;		//offset in file to root piece
    public uint collisionData;	//offset in file to collision data, must be 0 for now (no collision data)
    public uint texture1;		//offset in file to char* filename of first texture
    public uint texture2;		//offset in file to char* filename of second texture
}

public class S3oLoader
{
    void DumpBytes(byte[] data, int offset, int count)
    {
        for (int i = 0; i < count; i += 10)
        {
            string line = i + ": ";
            for (int j = i; (j < i + 10) && j < count; j++)
            {
                line += (int)data[j + offset] + " ";
            }
            Console.WriteLine(line);
        }
    }

    int GetSizeAttribute(object[] attributes)
    {
        foreach (object attribute in attributes)
        {
            //Console.WriteLine(attribute.GetType().ToString());
            ArraySizeAttribute arraysizeattribute = attribute as ArraySizeAttribute;
            if (arraysizeattribute != null)
            {
                return arraysizeattribute.size;
            }
        }
        return 0;
    }

    object ReadBinary(object targetobject, byte[] data, int offset)
    {
        Type type = targetobject.GetType();
        //Console.WriteLine(type.ToString());
        foreach (FieldInfo fi in targetobject.GetType().GetFields(BindingFlags.Public | BindingFlags.Instance))
        {
            //  Console.WriteLine(fi.Name + " " + fi.FieldType.ToString());
            if (fi.FieldType == typeof(uint))
            {
                uint value = BitConverter.ToUInt32(data, offset);
                //    Console.WriteLine(value);
                fi.SetValue(targetobject, value);
                offset += 4;
            }
            else if (fi.FieldType == typeof(float))
            {
                float value = BitConverter.ToSingle(data, offset);
                //  Console.WriteLine(value);
                fi.SetValue(targetobject, value);
                offset += 4;
            }
            else if (fi.FieldType == typeof(string))
            {
                int len = GetSizeAttribute(fi.GetCustomAttributes(false));
                string value = System.Text.Encoding.UTF8.GetString(data, offset, len - 1);
                //Console.WriteLine(value);
                fi.SetValue(targetobject, value);
                offset += len;
            }
        }
        return targetobject;
    }
    string magiccode = "Spring unit";

    string ReadString(byte[] data, int offset)
    {
        List<byte> bytelist = new List<byte>();
        while (data[offset] != 0)
        {
            bytelist.Add(data[offset]);
            offset++;
        }
        byte[] bytes = bytelist.ToArray();
        return Encoding.UTF8.GetString(bytes);
    }

    UnitPart LoadUnitPart(byte[] data, int offset)
    {
        UnitPart unitpart = new UnitPart();

        _S3OPiece s3opiece = new _S3OPiece();
        s3opiece = ReadBinary(s3opiece, data, offset) as _S3OPiece;
        LogFile.GetInstance().WriteLine("name offset: " + s3opiece.name);
        LogFile.GetInstance().WriteLine(ReadString(data, Convert.ToInt32(s3opiece.name)));
        unitpart.Name = ReadString(data, Convert.ToInt32(s3opiece.name));
        unitpart.Offset = new Vector3(s3opiece.xoffset, s3opiece.yoffset, s3opiece.zoffset);
        //unitpart.Vertices = new Vertex[s3opiece.numVertices];
        //unitpart.Primitives = new int[s3opiece.vertexTableSize];
        if (s3opiece.primitiveType == 0)
        {
            unitpart.PrimitiveType = UnitPart.PrimitiveTypeEnum.Triangles;
        }
        else if (s3opiece.primitiveType == 1)
        {
            unitpart.PrimitiveType = UnitPart.PrimitiveTypeEnum.TriangleStrips;
        }
        else if (s3opiece.primitiveType == 2)
        {
            unitpart.PrimitiveType = UnitPart.PrimitiveTypeEnum.Quads;
        }
        int numvertices = (int)s3opiece.numVertices;
        LogFile.GetInstance().WriteLine("num vertices: " + numvertices);
        Vertex[] Vertices = new Vertex[numvertices];
        //if (unitpart.Name == "barrel")
        //{
            for (int i = 0; i < numvertices; i++)
            {
                uint vertexoffset = (uint)(s3opiece.vertices + i * 8 * sizeof(float)); // note to self: kindof a  hack to hardcode the 8
                _S3OVertex s3overtex = new _S3OVertex();
                s3overtex = ReadBinary(s3overtex, data, (int)vertexoffset) as _S3OVertex;
                Vertex vertex = new Vertex();
                vertex.Pos = new Vector3(s3overtex.xpos, s3overtex.ypos, s3overtex.zpos);
                vertex.Normal = new Vector3(s3overtex.xnormal, s3overtex.ynormal, s3overtex.znormal);
                vertex.Normal.Normalize();
                vertex.TextureCoords = new Vector2(s3overtex.texu, s3overtex.texv);
                Vertices[i] = vertex;
          //      Console.WriteLine(vertex.Pos.ToString() + " " + vertex.Normal.ToString() + " " + vertex.TextureCoords.ToString() );
            }
        //}
        int vertextablesize = (int)s3opiece.vertexTableSize;
        LogFile.GetInstance().WriteLine("vertextablesize: " + vertextablesize);

        switch (unitpart.PrimitiveType)
        {
            case UnitPart.PrimitiveTypeEnum.Triangles:
                {
                    unitpart.Primitives = new Primitive[vertextablesize / 3];
                    for (int i = 0; i < vertextablesize; i += 3)
                    {
                        //if (unitpart.Name == "barrel")
                        //{
                            Triangle triangle = new Triangle();
                            int vertexindex = (int)BitConverter.ToUInt32(data, (int)(s3opiece.vertexTable + i * sizeof(uint)));
                            triangle.Vertices[0] = Vertices[vertexindex];
                            //Console.WriteLine("vertex " + vertexindex);

                            vertexindex = (int)BitConverter.ToUInt32(data, (int)(s3opiece.vertexTable + (i + 1) * sizeof(uint)));
                            triangle.Vertices[1] = Vertices[vertexindex];
                           // Console.WriteLine("vertex " + vertexindex);

                            vertexindex = (int)BitConverter.ToUInt32(data, (int)(s3opiece.vertexTable + (i + 2) * sizeof(uint)));
                            triangle.Vertices[2] = Vertices[vertexindex];
                          //  Console.WriteLine("vertex " + vertexindex);

                            unitpart.Primitives[i / 3] = triangle;
                        //}
                    }
                    LogFile.GetInstance().WriteLine((vertextablesize / 3).ToString() + " triangles");
                    break;
                }
            case UnitPart.PrimitiveTypeEnum.TriangleStrips:
                {
                    List<Primitive> primitives = new List<Primitive>();
                    for (int i = 0; i < vertextablesize; )
                    {
                        List<Vertex> thistrianglestripvertices = new List<Vertex>();
                        while (i < vertextablesize)
                        {
                            uint vertexindex = BitConverter.ToUInt32(data, (int)(s3opiece.vertexTable + i * sizeof(uint)));
                            if (vertexindex == UInt32.MaxValue)
                            {
                                break;
                            }
                            thistrianglestripvertices.Add(Vertices[(int)vertexindex]);
                            i++;
                        }
                        TriangleStrip trianglestrip = new TriangleStrip();
                        trianglestrip.Vertices = thistrianglestripvertices.ToArray();
                        primitives.Add(trianglestrip);
                    }
                    unitpart.Primitives = primitives.ToArray();
                    LogFile.GetInstance().WriteLine(unitpart.Primitives.GetLength(0) + " triangle strips");
                    break;
                }
            case UnitPart.PrimitiveTypeEnum.Quads:
                {
                    unitpart.Primitives = new Primitive[vertextablesize / 4];
                    for (int i = 0; i < vertextablesize; i += 4)
                    {
                        Quad quad = new Quad();
                        int vertexindex = (int)BitConverter.ToUInt32(data, (int)(s3opiece.vertexTable + i * sizeof(uint)));
                        quad.Vertices[0] = Vertices[vertexindex];
                        vertexindex = (int)BitConverter.ToUInt32(data, (int)(s3opiece.vertexTable + (i + 1) * sizeof(uint)));
                        quad.Vertices[1] = Vertices[vertexindex];
                        vertexindex = (int)BitConverter.ToUInt32(data, (int)(s3opiece.vertexTable + (i + 2) * sizeof(uint)));
                        quad.Vertices[2] = Vertices[vertexindex];
                        vertexindex = (int)BitConverter.ToUInt32(data, (int)(s3opiece.vertexTable + (i + 3) * sizeof(uint)));
                        quad.Vertices[3] = Vertices[vertexindex];
                        unitpart.Primitives[i / 4] = quad;
                    }
                    LogFile.GetInstance().WriteLine(unitpart.Primitives.GetLength(0) + " quads");
                    break;
                }
        }

        for (int i = 0; i < (int)s3opiece.numChilds; i++)
        {
            //mdlobject.Children.Add(LoadMdlObject(data, (int)( s3opiece.childs + i * sizeof(uint) )));
            uint childoffset = BitConverter.ToUInt32(data, (int)s3opiece.childs + i * sizeof(uint));
            UnitPart childunitpart = LoadUnitPart(data, (int)childoffset);
            unitpart.Children.Add(childunitpart);
        }
        return unitpart;
    }

  //  static int count = 0;
    public Unit LoadS3o(string filename)
    {
      //  if (count > 10)
       // {
        //    throw new Exception("");
        //}
       // count++;

        FileStream inStream = new FileStream(filename, FileMode.Open, FileAccess.Read);
        byte[] sdobytes = new byte[inStream.Length];
        inStream.Read(sdobytes, 0, (int)inStream.Length);
        inStream.Seek(0, SeekOrigin.Begin);
        int offset = 0;
        _S3OHeader s3oheader = new _S3OHeader();
        s3oheader = (_S3OHeader)ReadBinary(s3oheader, sdobytes, offset);
        DumpBytes(sdobytes, 0, 30);
        LogFile.GetInstance().WriteLine("[" + s3oheader.magic + "] [" + magiccode + "]");
        if (s3oheader.magic.Trim() != magiccode.Trim())
        {
            throw new Exception("Not an s3o file");
        }
        LogFile.GetInstance().WriteLine("Version: " + s3oheader.version);
        Unit unit = new Unit();
        unit.Height = s3oheader.height;
        unit.Mid = new Vector3(s3oheader.midx, s3oheader.midy, s3oheader.midz);
        unit.Radius = s3oheader.radius;
        LogFile.GetInstance().WriteLine(ReadString(sdobytes, (int)s3oheader.texture1));
        LogFile.GetInstance().WriteLine(ReadString(sdobytes, (int)s3oheader.texture2));
        unit.texturename1 = ReadString(sdobytes, (int)s3oheader.texture1);
        unit.texturename2 = ReadString(sdobytes, (int)s3oheader.texture2);

        if (unit.texturename1 == "Spring unit")
        {
            unit.texturename1 = "Default.JPG";
            unit.texturename2 = "Default.JPG";
        }
        string texturedirectory = Path.Combine(Path.GetDirectoryName(Path.GetDirectoryName(filename)), "unittextures");
        string texture1filepath = texturedirectory + "\\" + unit.texturename1;
        string texture2filepath = texturedirectory + "\\" + unit.texturename2;
        LogFile.GetInstance().WriteLine(texturedirectory + "\\" + unit.texturename1 + "]");
        //System.Drawing.Bitmap blankbitmap = new System.Drawing.Bitmap(1, 1);
        //blankbitmap.SetPixel(0, 0, System.Drawing.Color.FromArgb(255, 255, 255));
        if( File.Exists( texture1filepath ) )
        {
            unit.texture1 = GlTexture.FromFile(texturedirectory + "/" + unit.texturename1);            
        }
        else
        {
            MapDesigner.MainUI.GetInstance().uiwindow.WarningMessage("Couldnt find texture " + texture1filepath + " , whilst loading " + filename + " . The object may not appear correctly");
            unit.texture1 = new GlTexture(false);
        }
        if( File.Exists( texture2filepath ) )
        {
            unit.texture2 = GlTexture.FromFile(texturedirectory + "/" + unit.texturename2);
        }
        else
        {
            MapDesigner.MainUI.GetInstance().uiwindow.WarningMessage("Couldnt find texture " + texture2filepath + " , whilst loading " + filename + " . The object may not appear correctly");
            unit.texture2 = new GlTexture(false);
        }

        unit.unitpart = LoadUnitPart(sdobytes, Convert.ToInt32(s3oheader.rootPiece));

        unit.Name = Path.GetFileNameWithoutExtension(filename).ToLower();
        return unit;
    }
}
