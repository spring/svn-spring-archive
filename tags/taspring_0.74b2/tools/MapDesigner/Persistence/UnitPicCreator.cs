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
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
using Tao.OpenGl;

namespace MapDesigner
{
    // uses OpenGL to render unitpics of S3Os
    public class UnitPicCreator
    {
        // returns byte buffer in raw RGBA format, 32bits per pixel
        // opengl needs to be initialized for this to run
        // normally the renderer is initialized before anything else (in MapDesigner.cs), so this should be ok
        public byte[] CreateUnitPic(string s3ofilepath, int width, int height )
        {
            int picturewidth = 96;
            int pictureheight = 96;

            GraphicsHelperGl g = new GraphicsHelperGl();

            Unit unit = new S3oLoader().LoadS3o(s3ofilepath);

            Gl.glViewport(0, 0, picturewidth, pictureheight);					// Set Our Viewport (Match Texture Size)
            //Gl.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);				// Set The Clear Color To Medium Blue

            Gl.glMatrixMode(Gl.GL_PROJECTION);
            Gl.glPushMatrix();
            Gl.glLoadIdentity();
            Glu.gluPerspective(60.0, (float)picturewidth / (float)pictureheight, 0.1, 1000.0);
            Gl.glMatrixMode(Gl.GL_MODELVIEW);
            /*
            float[] ambientLight = new float[] { 1.0f, 1.0f, 1.0f, 1.0f };
            float[] diffuseLight = new float[] { 0.6f, 0.6f, 0.6f, 1.0f };
            float[] specularLight = new float[] { 0.2f, 0.2f, 0.2f, 1.0f };
            float[] position = new float[] { -1.5f, 1.0f, -4.0f, 1.0f };

            Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_AMBIENT, ambientLight);
            Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_DIFFUSE, diffuseLight);
            Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_SPECULAR, specularLight);
            Gl.glLightfv(Gl.GL_LIGHT0, Gl.GL_POSITION, position);
             */
            Gl.glClear(Gl.GL_COLOR_BUFFER_BIT | Gl.GL_DEPTH_BUFFER_BIT);		// Clear The Screen And Depth Buffer

            Gl.glPushMatrix();
            Gl.glLoadIdentity();

            Gl.glRotated(-20, 0, 1, 0);
            Gl.glTranslated(-8, -8, -27);

            Gl.glRotated(-90, 1, 0, 0);

            Gl.glEnable(Gl.GL_LIGHTING);

            unit.Render();

            Gl.glPopMatrix();
            //g.Bind2DTexture(0);
            //Gl.glDeleteTextures(2, new int[] { unittexture1, unittexture2 });
            Gl.glViewport(0, 0, RendererSdl.GetInstance().OuterWindowWidth, RendererSdl.GetInstance().OuterWindowHeight);
            Gl.glMatrixMode(Gl.GL_PROJECTION);
            Gl.glPopMatrix();
            Gl.glMatrixMode(Gl.GL_MODELVIEW);
            g.CheckError();

            byte[] buffer = new byte[pictureheight * picturewidth * 4];
            IntPtr ptr = Marshal.AllocHGlobal(picturewidth * pictureheight * 4);
            Gl.glReadPixels(0, 0, picturewidth, pictureheight, Gl.GL_RGBA, Gl.GL_UNSIGNED_BYTE, ptr);
            Marshal.Copy(ptr, buffer, 0, picturewidth * pictureheight * 4);
            Marshal.FreeHGlobal(ptr);

            // flip
            /* or not
            byte[] newbuffer = new byte[pictureheight * picturewidth * 4];
            for (int x = 0; x < picturewidth; x++)
            {
                for (int y = 0; y < picturewidth; y++)
                {
                    for (int i = 0; i < 4; i++)
                    {
                        newbuffer[( pictureheight - y - 1 ) * picturewidth * 4 + x * 4 + i] = buffer[y * picturewidth * 4 + x * 4 + i];
                    }
                }
            }
             */

            return buffer;
        }
    }
}
