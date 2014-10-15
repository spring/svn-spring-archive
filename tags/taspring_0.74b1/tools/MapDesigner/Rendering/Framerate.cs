using System;
using System.Collections.Generic;
using System.Text;

namespace MapDesigner
{
    class Framerate
    {
        static Framerate instance = new Framerate();
        public static Framerate GetInstance() { return instance; }

        Framerate()
        {
            RendererFactory.GetInstance().Tick += new TickHandler(Framerate_Tick);
        }

        DateTime lasttick;
        int ticks = 0;
        void Framerate_Tick()
        {
            ticks++;
            if (((TimeSpan)DateTime.Now.Subtract(lasttick)).TotalMilliseconds > 1000)
            {
                lasttick = DateTime.Now;
                Console.WriteLine("fps: " + ticks);
                ticks = 0;
            }
        }


    }
}
