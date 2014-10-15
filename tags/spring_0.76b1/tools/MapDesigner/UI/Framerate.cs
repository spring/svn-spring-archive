// Copyright Hugh Perkins 2006
// hughperkins@gmail.com http://manageddreams.com
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License version 2 as published by the
// Free Software Foundation;
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
                LogFile.GetInstance().WriteLine("fps: " + ticks);
                ticks = 0;
            }
        }


    }
}
