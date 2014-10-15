using System;
using System.Collections.Generic;
using System.Text;
using Tao.Sdl;
using Tao.FreeGlut;

    public class DisplayGeometryX11 : IDisplayGeometry
    {
        public int WindowWidth {
            get
            {
                return windowwidth;
            }
        }
        public int WindowHeight
        {
            get
            {
                return windowheight;
            }
        }

        int windowwidth;
        int windowheight;

        public DisplayGeometryX11()
        {
            // placeholder
            windowwidth = MapDesigner.RendererSdl.GetInstance().OuterWindowWidth;
            windowheight = MapDesigner.RendererSdl.GetInstance().OuterWindowHeight;
        }
    }
