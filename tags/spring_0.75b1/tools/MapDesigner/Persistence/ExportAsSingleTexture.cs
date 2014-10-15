using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Runtime.InteropServices;
using Tao.OpenGl;

namespace MapDesigner
{
    // This class will export the current splatted terrain as a single high-resolution texture
    // This makes the terrain compatible with older map formats
    public class ExportAsSingleTexture
    {
        static ExportAsSingleTexture instance = new ExportAsSingleTexture();
        public static ExportAsSingleTexture GetInstance() { return instance; }

        ExportAsSingleTexture()
        {
        }

        // what we need to do is to render the splatted texture in ortho mode with lighting off
        // or normals off (to be tested)
        // then to export the generated bitmap
        // viewport should be set to heightmapwidth x heightmapheight
        public void Export(string filepath)
        {
            Terrain terrain = Terrain.GetInstance();
            int picturewidth = terrain.MapWidth * Terrain.SquareSize;
            int pictureheight = terrain.MapHeight * Terrain.SquareSize;
            LogFile.GetInstance().WriteLine("Export to " + filepath + " picturewidth " + picturewidth + " pictureheight: " + pictureheight);
            //int windowwidth = RendererSdl.GetInstance().WindowWidth;
            //int windowheight = RendererSdl.GetInstance().WindowHeight;
            int windowwidth = 256;
            int windowheight = 256;

            Gl.glViewport(0, 0, windowwidth, windowheight);

            byte[] buffer = new byte[windowwidth * windowheight * 4];
            //System.Drawing.Bitmap bitmap = new System.Drawing.Bitmap( picturewidth, pictureheight );
            //byte[] imagedata = new byte[picturewidth * pictureheight * 4];
            Image image = new Image(picturewidth, pictureheight);

            List<RendererPass> rendererpasses = new List<RendererPass>();
            bool multipass = true; // force multipass for now for simplicity
            int maxtexels = RendererSdl.GetInstance().MaxTexelUnits;
            if (multipass)
            {
                for (int i = 0; i < terrain.texturestages.Count; i++)
                {
                    MapTextureStage maptexturestage = terrain.texturestages[i];
                    int numtexturestagesrequired = maptexturestage.NumTextureStagesRequired;
                    if (numtexturestagesrequired > 0) // exclude Nops
                    {
                        RendererPass rendererpass = new RendererPass(maxtexels);
                        for (int j = 0; j < maptexturestage.NumTextureStagesRequired; j++)
                        {
                            rendererpass.AddStage(new RendererTextureStage(maptexturestage, j, true, picturewidth, pictureheight));
                        }
                        rendererpasses.Add(rendererpass);
                    }
                }
            }

            GraphicsHelperGl g = new GraphicsHelperGl();

            Gl.glMatrixMode(Gl.GL_PROJECTION);
            Gl.glPushMatrix();
            Gl.glLoadIdentity();
            Gl.glOrtho(0, windowwidth, windowheight, 0, -1, 1);

            Gl.glMatrixMode(Gl.GL_MODELVIEW);
            Gl.glPushMatrix();
            Gl.glLoadIdentity();

            Gl.glDisable(Gl.GL_CULL_FACE);
            Gl.glDisable(Gl.GL_LIGHTING);

            g.EnableBlendSrcAlpha();
            Gl.glDepthFunc( Gl.GL_LEQUAL );

            for (int chunkx = 0; chunkx < Math.Ceiling((double)picturewidth / windowwidth); chunkx++)
            {
                for (int chunky = 0; chunky < Math.Ceiling((double)pictureheight / windowheight); chunky++)
                {
                    Console.WriteLine("chunkx " + chunkx + " chunky " + chunky);

                    Gl.glClear(Gl.GL_COLOR_BUFFER_BIT | Gl.GL_DEPTH_BUFFER_BIT);		// Clear The Screen And Depth Buffer

                    foreach (RendererPass rendererpass in rendererpasses)
                    {
                        rendererpass.Apply();

                        Gl.glBegin(Gl.GL_QUADS);

                        double ul = (chunkx * windowwidth);
                        double ur = (chunkx * windowwidth + windowwidth);
                        double vt = (chunky * windowheight);
                        double vb = (chunky * windowheight + windowheight);
                        Gl.glTexCoord2d( ul,vt );
                        Gl.glMultiTexCoord2dARB(Gl.GL_TEXTURE1_ARB,ul, vt);
                        Gl.glVertex2i(0, 0);

                        Gl.glTexCoord2d( ul,vb );
                        Gl.glMultiTexCoord2dARB(Gl.GL_TEXTURE1_ARB,ul, vb);
                        Gl.glVertex2i(0, windowheight);

                        Gl.glTexCoord2d( ur,vb );
                        Gl.glMultiTexCoord2dARB(Gl.GL_TEXTURE1_ARB,ur, vb);
                        Gl.glVertex2i(windowwidth, windowheight);

                        Gl.glTexCoord2d( ur,vt );
                        Gl.glMultiTexCoord2dARB(Gl.GL_TEXTURE1_ARB,ur, vt);
                        Gl.glVertex2i(windowwidth, 0);

                        Gl.glEnd();
                    }

                    IntPtr ptr = Marshal.AllocHGlobal(windowwidth * windowheight * 4);
                    Gl.glReadPixels(0, 0, windowwidth, windowheight, Gl.GL_RGBA, Gl.GL_UNSIGNED_BYTE, ptr);
                    Marshal.Copy(ptr, buffer, 0, windowwidth * windowheight * 4);
                    Marshal.FreeHGlobal(ptr);

                    for (int x = 0; x < windowwidth; x++)
                    {
                        for (int y = 0; y < windowheight; y++)
                        {
                            if ((chunky * windowheight + y < pictureheight) &&
                                (chunkx * windowwidth + x < picturewidth))
                            {
                                int pixeloffset = (windowheight - y - 1) * windowwidth * 4 + x * 4;
                                //bitmap.SetPixel(x + chunkx * windowwidth, y + chunky * windowheight, System.Drawing.Color.FromArgb(buffer[pixeloffset + 0],
                                    //buffer[pixeloffset + 1], buffer[pixeloffset + 2]));
                                image.SetPixel(x + chunkx * windowwidth, y + chunky * windowheight,
                                    buffer[pixeloffset + 0],
                                    buffer[pixeloffset + 1],
                                    buffer[pixeloffset + 2],
                                    255
                                    );
                            }
                        }
                    }
                }
            }
            if (File.Exists(filepath))
            {
                File.Delete(filepath);
            }
            image.Save(filepath);
            //DevIL.DevIL.SaveBitmap( filepath, bitmap);

            Gl.glPopMatrix();
            Gl.glMatrixMode(Gl.GL_PROJECTION);
            Gl.glPopMatrix();
            Gl.glMatrixMode(Gl.GL_MODELVIEW);

            Gl.glEnable(Gl.GL_LIGHTING);

            g.ActiveTexture(1);
            g.DisableTexture2d();
            g.SetTextureScale(1);
            g.ActiveTexture(0);
            g.SetTextureScale(1);

            Gl.glEnable(Gl.GL_CULL_FACE);
            Gl.glEnable(Gl.GL_LIGHTING);
            Gl.glDisable(Gl.GL_BLEND);

            g.EnableModulate();

            Gl.glViewport(0, 0, RendererSdl.GetInstance().OuterWindowWidth, RendererSdl.GetInstance().OuterWindowHeight);
            g.CheckError();

            MainUI.GetInstance().uiwindow.InfoMessage("Exported blended terrain texture to " + filepath);
        }
    }
}
