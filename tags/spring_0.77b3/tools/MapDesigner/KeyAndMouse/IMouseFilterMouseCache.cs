// Copyright Hugh Perkins 2004,2005,2006
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
using SdlDotNet;

// caches values of mouse position, including scroll, and mouse buttons (but prefer to go through KeyFilterConfigMappingsFactory.cs for mouse keys, so
// flexible and easy to configure)
namespace MapDesigner
{
    public delegate void MouseMoveHandler();

    public interface IMouseFilterMouseCache
    {
        event MouseButtonEventHandler MouseDown;
        event MouseMoveHandler MouseMove;
        event MouseButtonEventHandler MouseUp;        
          
        int MouseX
        {
            get;
        }
        int MouseY
        {
            get;
        }
        int Scroll
        {
            get;
        }
        bool LeftMouseDown
        {
            get;
        }
        bool RightMouseDown
        {
            get;
        }
    }
}
