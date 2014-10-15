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
    // manages editing
    public class EditController
    {
        static EditController instance = new EditController();
        public static EditController GetInstance() { return instance; }

        public EditController()
        {
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand( "increaseheight", new KeyCommandHandler( handler_IncreaseHeight ) );
            KeyFilterConfigMappingsFactory.GetInstance().RegisterCommand( "decreaseheight", new KeyCommandHandler( handler_DecreaseHeight ) );
            RendererFactory.GetInstance().Tick += new TickHandler( renderer_Tick );
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="IsInitialMouseclick">When mouse button is initially pressed, this is true.</param>
        void ApplyBrush( bool IsInitialMouseclick )
        {
            if (!(increaseheight || decreaseheight))
            {
                return;
            }

            if (CurrentEditBrush.GetInstance().BrushEffect == null ||
                CurrentEditBrush.GetInstance().BrushShape == null)
            {
                return;
            }

            if (!(IsInitialMouseclick || CurrentEditBrush.GetInstance().BrushEffect.Repeat))
            {
                return;
            }

            Vector3 intersectpoint = EditingHelper.GetIntersectPoint();
            if (intersectpoint == null)
            {
                return;
            }

            double x = intersectpoint.x;
            double y = intersectpoint.y;
            if (x >= 0 && y >= 0 &&
                x < (Terrain.GetInstance().HeightMapWidth * Terrain.SquareSize) &&
                y < (Terrain.GetInstance().HeightMapHeight * Terrain.SquareSize))
            {
                double milliseconds = DateTime.Now.Subtract( LastDateTime ).TotalMilliseconds;
                LastDateTime = DateTime.Now;
                CurrentEditBrush.GetInstance().BrushEffect.ApplyBrush(
                    CurrentEditBrush.GetInstance().BrushShape, CurrentEditBrush.GetInstance().BrushSize,
                    x, y, increaseheight, milliseconds );
            }
        }

        void renderer_Tick()
        {
            ApplyBrush( false );
        }

        bool increaseheight = false;
        bool decreaseheight = false;
        DateTime LastDateTime;

        void handler_IncreaseHeight( string command, bool down )
        {
            if (down)
            {
                LastDateTime = DateTime.Now;
                increaseheight = true;
                ApplyBrush( true );
            }
            else
            {
                increaseheight = false;
            }
        }

        void handler_DecreaseHeight( string command, bool down )
        {
            if (down)
            {
                LastDateTime = DateTime.Now;
                decreaseheight = true;
                ApplyBrush( true );
            }
            else
            {
                decreaseheight = false;
            }
        }
    }
}
