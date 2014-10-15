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
using SdlDotNet;

namespace MapDesigner
{
    // caches mouse attributes, and makes them available via events
    public class MouseFilterSdlMouseCache : IMouseFilterMouseCache
    {
        int _mousex;
        int _mousey;
        int _scroll;

        bool _leftbuttondown;
        bool _rightbuttondown;
        bool _middlebuttondown;

        public event MouseButtonEventHandler MouseDown;
        public event MouseMoveHandler MouseMove;
        public event MouseButtonEventHandler MouseUp;        
            
        static MouseFilterSdlMouseCache instance = new MouseFilterSdlMouseCache();
        public static MouseFilterSdlMouseCache GetInstance()
        {
            return instance;
        }
        
        public MouseFilterSdlMouseCache()
        {
            IRenderer renderer = RendererFactory.GetInstance();
            renderer.MouseMotion += new MouseMotionEventHandler(renderer_MouseMotion);
            renderer.MouseDown += new MouseButtonEventHandler(renderer_MouseDown);
            renderer.MouseUp += new MouseButtonEventHandler(renderer_MouseUp);
        }

        public int MouseX
        {
            get
            {
                return _mousex;
            }
        }        
        public int MouseY
        {
            get
            {
                return _mousey;
            }
        }
        public int Scroll
        {
            get
            {
                return _scroll;
            }
        }
        public bool LeftMouseDown
        {
            get
            {
                return _leftbuttondown;
            }
        }
        public bool MiddleMouseDown
        {
            get
            {
                return _middlebuttondown;
            }
        }
        public bool RightMouseDown
        {
            get
            {
                return _rightbuttondown;
            }
        }

        void renderer_MouseMotion(object sender, MouseMotionEventArgs e)
        {
            _mousex = e.X;
            _mousey = e.Y;
            if( MouseMove != null )
            {
                MouseMove();
            }
        }

        void renderer_MouseDown(object sender, MouseButtonEventArgs e)
        {
            _mousex = e.X;
            _mousey = e.Y;
            switch( e.Button )
            {
                case MouseButton.PrimaryButton:
                    _leftbuttondown = true;
                    if (MouseDown != null)
                    {
                        MouseDown(sender, e);
                    }
                    break;
                case MouseButton.MiddleButton:
                    _middlebuttondown = true;
                    if (MouseDown != null)
                    {
                        MouseDown(sender, e);
                    }
                    break;
                case MouseButton.SecondaryButton:
                    _rightbuttondown = true;
                    if (MouseDown != null)
                    {
                        MouseDown(sender, e);
                    }
                    break;
                case MouseButton.WheelDown:
                    _scroll--;
                    if (MouseMove != null)
                    {
                        MouseMove();
                    }
                    break;
                case MouseButton.WheelUp:
                    _scroll++;
                    if (MouseMove != null)
                    {
                        MouseMove();
                    }
                    break;
            }
        }

        void renderer_MouseUp(object sender, MouseButtonEventArgs e)
        {
            _mousex = e.X;
            _mousey = e.Y;
            switch( e.Button )
            {
                case MouseButton.PrimaryButton:
                    _leftbuttondown = false;
                    if (MouseUp != null)
                    {
                        MouseUp(sender, e);
                    }
                    break;
                case MouseButton.MiddleButton:
                    _middlebuttondown = false;
                    if (MouseUp != null)
                    {
                        MouseUp(sender, e);
                    }
                    break;
                case MouseButton.SecondaryButton:
                    _rightbuttondown = false;
                    if (MouseUp != null)
                    {
                        MouseUp(sender, e);
                    }
                    break;
            }
        }
}
}
