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
// or FITNESS FOR A PARTICULAR PURVector3E. See the GNU General Public License for
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
    public class HeightEditor
    {
        static HeightEditor instance = new HeightEditor();
        public static HeightEditor GetInstance() { return instance; }

        HeightEditor() // protected constructor to enforce singleton pattern
        {
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand("increaseheight", new KeyCommandHandler(handler_IncreaseHeight));
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand("decreaseheight", new KeyCommandHandler(handler_DecreaseHeight));
            RendererFactory.GetInstance().Tick += new TickHandler(renderer_Tick);
            brushsize = Config.GetInstance().HeightEditingDefaultBrushSize;
            speed = Config.GetInstance().HeightEditingSpeed;

            UICommandQueue.GetInstance().RegisterConsumer(typeof(UICommandChangeBrushSize), new UICommandQueue.UICommandHandler(ChangeBrushSize));
            UICommandQueue.GetInstance().RegisterConsumer(typeof(UICommandBrushEffect), new UICommandQueue.UICommandHandler(ChangeBrushEffect));
        }

        int brushsize = 100;
        double speed = 0.1;

        // note to self: horrible hack; shoulddefine these here
        // in fact, should have multiple brush classes that register and do this for us
        UICommandBrushEffect.BrushEffect brusheffect = UICommandBrushEffect.BrushEffect.RaiseLower;

        void ChangeBrushSize(UICommand command)
        {
            brushsize = (command as UICommandChangeBrushSize).size;
        }

        void ChangeBrushEffect(UICommand command)
        {
            brusheffect = (command as UICommandBrushEffect).effect;
        }

        // This is a conical brush, that changes height more strongly in centre than at edges, with a linear dropoff
        // effect on surrounding areas is cumulative, rather than at-least, so even if the surroundings are higher than the centre, they'll still be added to
        // note to self: ideally these brushes could be pluggable
        // direction = true means we are increasing height
        void ApplyBrush( int x, int y, bool direction )
        {
            float[,] mesh = HeightMap.GetInstance().Map;

            double timemultiplier = ((TimeSpan)(DateTime.Now.Subtract(LastDateTime))).Milliseconds * speed;
            int meshsize = mesh.GetUpperBound(0) + 1;
            for( int i = - brushsize; i <= brushsize; i++ )
            {
                for( int j = - brushsize; j <= brushsize; j++ )
                {
                    int thisx = x + i;
                    int thisy = y + j;
                    if (thisx >= 0 && thisy >= 0 && thisx < meshsize &&
                        thisy < meshsize )
                    {
                        double distance = Math.Sqrt(i * i + j * j);
                        if (distance < brushsize)
                        {
                            double brushshapecontribution = 0;
                            brushshapecontribution = 1.0 - distance / brushsize;

                            if (brusheffect == UICommandBrushEffect.BrushEffect.RaiseLower)
                            {
                                double directionmultiplier  =  1.0;
                                if( !direction )
                                {
                                    directionmultiplier = -1.0;
                                }
                                mesh[thisx, thisy] += (float)(brushshapecontribution * directionmultiplier * timemultiplier);
                                if (mesh[thisx, thisy] >= HeightMap.GetInstance().MaxHeight)
                                {
                                    mesh[thisx, thisy] = (float)HeightMap.GetInstance().MaxHeight;
                                }
                                else if (mesh[thisx, thisy] < HeightMap.GetInstance().MinHeight)
                                {
                                    mesh[thisx, thisy] = (float)HeightMap.GetInstance().MinHeight;
                                }
                            }
                            else if( brusheffect == UICommandBrushEffect.BrushEffect.Flatten)
                            {
                                mesh[thisx, thisy] = (float)( mesh[thisx, thisy] + (mesh[x, y] - mesh[thisx, thisy]) * brushshapecontribution * timemultiplier / 50 );
                            }
                        }
                    }
                }
            }
        }

        void renderer_Tick()
        {
            if (increaseheight || decreaseheight)
            {
                Vector3 intersectpoint = GetIntersectPoint();
                if (intersectpoint != null)
                {
                    int x = (int)intersectpoint.x / DrawGrid.SquareSize;
                    int y = (int)intersectpoint.y / DrawGrid.SquareSize;
                    if (x >= 0 && y >= 0 && 
                        x < HeightMap.GetInstance().Width &&
                        y < HeightMap.GetInstance().Height )
                    {
                        if (increaseheight)
                        {
                            ApplyBrush(x, y, true);
                        }
                        else
                        {
                            ApplyBrush(x, y, false);
                        }
                    }
                }
            }
        }

        bool increaseheight = false;
        bool decreaseheight = false;
        DateTime LastDateTime;

        public Vector3 GetIntersectPoint()
        {
            // intersect mousevector with x-z plane.
            HeightMap heightmap = HeightMap.GetInstance();
            Vector3 mousevector = GraphicsHelperFactory.GetInstance().GetMouseVector(Camera.GetInstance().RoamingCameraPos, Camera.GetInstance().RoamingCameraRot, MouseFilterMouseCacheFactory.GetInstance().MouseX, MouseFilterMouseCacheFactory.GetInstance().MouseY);
            Vector3 camerapos = Camera.GetInstance().RoamingCameraPos;
            int width = heightmap.Width;
            int height = heightmap.Height;
            Vector3 planenormal = mvMath.ZAxis;
            mousevector.Normalize();
            if (mousevector.z < - 0.0005)
            {
                //Vector3 intersectionpoint = camerapos + mousevector * (Vector3.DotProduct(camerapos, planenormal) + 0) /
                //  (Vector3.DotProduct(mousevector, planenormal));
                Vector3 intersectpoint = camerapos - mousevector * (camerapos.z / mousevector.z);
                //Console.WriteLine("intersection: " + intersectionpoint.ToString());
                double heightmapx = intersectpoint.x / DrawGrid.SquareSize;
                double heightmapy = intersectpoint.y / DrawGrid.SquareSize;
                if (heightmapx >= 0 && heightmapy >= 0 &&
                    heightmapx < width && heightmapy < height)
                {
                    intersectpoint.z = HeightMap.GetInstance().Map[(int)heightmapx, (int)heightmapy ];
                    return intersectpoint;
                }
                else
                {
                    return null;
                }
            }
            else
            {
                Console.WriteLine("no intersection");
                return null;
            }
        }
        public void handler_IncreaseHeight( string command, bool down )
        {
            if (down)
            {
                LastDateTime = DateTime.Now;
                increaseheight = true;
            }
            else
            {
                increaseheight = false;
            }
        }

        public void handler_DecreaseHeight(string command, bool down)
        {
            if (down)
            {
                LastDateTime = DateTime.Now;
                decreaseheight = true;
            }
            else
            {
                decreaseheight = false;
            }
        }
    }
}
