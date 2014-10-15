// Copyright Hugh Perkins 2006
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
//using Tao.Sdl;
using Tao.OpenGl;
using SdlDotNet;

namespace MapDesigner
{
    class DrawGrid
    {
        int sectorsize = 32;
        int detaildistance = 150;
        public const int SquareSize = 8;
        public const int SquareSizeBitShift = 3; // ie * 8 is equivalent to << 3

        static DrawGrid instance = new DrawGrid();
        public static DrawGrid GetInstance() { return instance; }

        bool colorlevelsofdetail = false;

        public DrawGrid()
        {
            IRenderer renderer = RendererFactory.GetInstance();
            renderer.WriteNextFrameEvent += new WriteNextFrameCallback(renderer_WriteNextFrameEvent);
        }

        void DrawSubGrid(int startx, int starty, int xspan, int yspan, int step)
        {
            //Console.WriteLine(startx + " " + starty + " " + xspan + " " + yspan + " " + step);
            float[,] mesh = HeightMap.GetInstance().Map;
            if (startx + xspan >= HeightMap.GetInstance().Width - 1)
            {
                xspan -= step;
            //    Console.WriteLine("setting xspan to " + xspan);
            }
            if (starty + yspan >= HeightMap.GetInstance().Height - 1)
            {
                yspan -= step;
              //  Console.WriteLine("setting yspan to " + yspan);
            }
            //bool swap = true;
            for (int i = startx; i <= startx + xspan; i += step)
            {
             //   if (swap)
               // {
                    Gl.glBegin(Gl.GL_TRIANGLE_STRIP);
                    for (int k = starty + yspan; k >= starty; k -= step)
                    {
                        Vector3 a = new Vector3(step * SquareSize, step * SquareSize,
                            mesh[i + step, k + step] -
                            mesh[i, k]);
                        Vector3 b = new Vector3(step * SquareSize, -step * SquareSize,
                            mesh[i + step, k] -
                            mesh[i, k + step]);
                        Vector3 normal = Vector3.CrossProduct(a, b).Normalize();
                        Gl.glNormal3d(normal.x, normal.y, normal.z);

                        //Gl.glColor3ub(255, 0, 0);
                        Gl.glVertex3f(i * SquareSize, k * SquareSize, mesh[i, k]);
                        //Gl.glColor3ub(0, 255, 0);
                        Gl.glVertex3f(i * SquareSize + step * SquareSize, k * SquareSize, mesh[i + step, k]);
                        if (k == starty)
                        {
                            Gl.glVertex3f(i * SquareSize + step * SquareSize, k * SquareSize, mesh[i + step, k]); // degenerate
                        }
                    }
                    Gl.glEnd();
                //}
                //else
                //{
                //    Gl.glBegin(Gl.GL_TRIANGLE_STRIP);
                //    for (int k = starty; k <= starty + yspan; k += step)
                //    {
                //        Vector3 a = new Vector3(step, step,
                //            mesh[i + step, k + step] -
                //            mesh[i, k]);
                //        Vector3 b = new Vector3(step, -step,
                //            mesh[i + step, k] -
                //            mesh[i, k + step]);
                //        Vector3 normal = Vector3.CrossProduct(a, b).Normalize();
                //        Gl.glNormal3d(normal.x, normal.y, normal.z);

                //        Gl.glVertex3f(i, k, mesh[i, k]);
                //        Gl.glVertex3f(i + step, k, mesh[i + step, k]);
                //        if (k == starty + yspan )
                //        {
                //            Gl.glVertex3f(i + step, k, mesh[i + step, k]); // degenerate
                //        }
                //    }
                //    Gl.glEnd();
                //}
                //swap = !swap;
            }
            //System.Environment.Exit(0);
        }

        public int iSectorsDrawn;

        // The terrain rendering code is adapted from some example code in sdl or glut
        void renderer_WriteNextFrameEvent()
        {
            Gl.glPushMatrix();
            //Gl.glTranslatef(-MAXMESH / 2, MAXMESH * 2, 0);

            float[,] mesh = HeightMap.GetInstance().Map;
            int width = HeightMap.GetInstance().Width;
            int height = HeightMap.GetInstance().Height;

            FrustrumCulling culling = FrustrumCulling.GetInstance();

            IGraphicsHelper g = GraphicsHelperFactory.GetInstance();

            iSectorsDrawn = 0;

            //Gl.glColor3ub(255, 255, 255);
            //g.SetMaterialColor(new Color(1, 0, 0));
            g.SetMaterialColor(new Color(0.3, 0.8, 0.3));
            for (int sectorx = 0; sectorx < (width / sectorsize) - 1; sectorx++)
            {
                for (int sectory = 0; sectory < (height / sectorsize) - 1; sectory++)
                {
                    //if (iSectorsDrawn == 0)
                    //{
                        int sectorposx = sectorx * sectorsize;
                        int sectorposy = sectory * sectorsize;
                        int displayposx = sectorposx * SquareSize;
                        int displayposy = sectorposy * SquareSize;
                        Vector3 sectorpos = new Vector3(sectorposx, sectorposy, mesh[sectorposx, sectorposy]);
                        Vector3 displaypos = new Vector3(displayposx, displayposy, mesh[sectorposx, sectorposy]);
                        if (culling.IsInsideFrustum(displaypos + new Vector3(sectorsize * SquareSize / 2, sectorsize * SquareSize / 2, 0), sectorsize * SquareSize))
                        {
                            iSectorsDrawn++;

                            // check how far away sector is
                            // if nearby we render it in detail
                            // otherwise just render a few points from it
                            double distancesquared = Vector3.DistanceSquared(displaypos, Camera.GetInstance().RoamingCameraPos);
                            //if ( distancesquared > detaildistance * detaildistance)
                            if( false )
                            {
                                g.SetMaterialColor(new Color(1, 0, 0));
                                Vector3 a = new Vector3(sectorsize * SquareSize, sectorsize * SquareSize,
                                    mesh[sectorposx + sectorsize, sectorposy + sectorsize] -
                                    mesh[sectorposx, sectorposy]);
                                Vector3 b = new Vector3(sectorsize * SquareSize, -sectorsize * SquareSize,
                                    mesh[sectorposx + sectorsize, sectorposy] -
                                    mesh[sectorposx, sectorposy + sectorsize]);

                                Vector3 normal = Vector3.CrossProduct(a, b).Normalize();
                                Gl.glNormal3d(normal.x, normal.y, normal.z);
                                Gl.glBegin(Gl.GL_TRIANGLE_STRIP);
                                Gl.glVertex3f(sectorposx * SquareSize, sectorposy * SquareSize, mesh[sectorposx, sectorposy]);
                                Gl.glVertex3f(sectorposx * SquareSize, sectorposy * SquareSize + sectorsize * SquareSize, mesh[sectorposx, sectorposy + sectorsize]);
                                Gl.glVertex3f(sectorposx * SquareSize + sectorsize * SquareSize, sectorposy * SquareSize, mesh[sectorposx + sectorsize, sectorposy]);
                                Gl.glVertex3f(sectorposx * SquareSize + sectorsize * SquareSize, sectorposy * SquareSize + sectorsize * SquareSize, mesh[sectorposx + sectorsize, sectorposy + sectorsize]);
                                Gl.glEnd();
                            }
                            else
                            {
                                int stepsize = 16;
                                if (distancesquared < 1200 * 1200)
                                {
                                    stepsize = 1;
                                }
                                else if (distancesquared < 2400 * 2400)
                                {
                                    stepsize = 2;
                                }
                                else if (distancesquared < 4000 * 4000)
                                {
                                    stepsize = 4;
                                }
                                else if (distancesquared < 7200 * 7200)
                                {
                                    stepsize = 8;
                                }
                                //else if (distancesquared < 1600 * 1600)
                                //{
                                 //   stepsize = 16;
                                //}
                                if (colorlevelsofdetail)
                                {
                                    g.SetMaterialColor(new Color(0, 0.5 + (float)stepsize * 8 / 255, 0));
                                }
                                DrawSubGrid(sectorposx, sectorposy, sectorsize, sectorsize, stepsize);
                            }
                        }
                    //}
                }
            }
            Gl.glPopMatrix();
            //Console.WriteLine( "sectors drawn: " + iSectorsDrawn );
        }
    }
}
