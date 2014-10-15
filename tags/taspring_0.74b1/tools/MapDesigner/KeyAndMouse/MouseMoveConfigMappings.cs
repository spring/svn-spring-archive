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

// applies the mappings in mousemoveconfigs/mousemove, in the config file
// provides a way of obtaining values for mouse movement, that are configurable via the config file
// example usage: GetVertical("cameratranslate")  The config file could map this to mouse up-down movement, or to the mouse scroll wheel, or to mouse sideways movement
namespace MapDesigner
{
    public class MouseMoveConfigMappings
    {
        static MouseMoveConfigMappings instance = new MouseMoveConfigMappings();
        public static MouseMoveConfigMappings GetInstance() { return instance; }

        Dictionary<string, MouseMoveConfig> MouseMoveConfigsByName;
        IMouseFilterMouseCache mousefiltermousecache;

        Config config;

        MouseMoveConfigMappings() // protected constructor, to enforce singleton
        {
            MouseMoveConfigsByName = Config.GetInstance().MouseMoveConfigsByName;
            mousefiltermousecache = MouseFilterMouseCacheFactory.GetInstance();
            config = Config.GetInstance();
        }

        int GetAxis(string axisname)
        {
            if (axisname == "mouseupdown")
            {
                return mousefiltermousecache.MouseY;
            }
            if (axisname == "mousesideways")
            {
                return mousefiltermousecache.MouseX;
            }
            if (axisname == "mousescroll")
            {
                return mousefiltermousecache.Scroll * config.mousescrollmultiplier ;
            }
            return 0;
        }

        public int GetVertical(string mousemovename)
        {
            if (!MouseMoveConfigsByName.ContainsKey(mousemovename))
            {
                return 0;
            }
            MouseMoveConfig mousemoveconfig = MouseMoveConfigsByName[mousemovename];
            return GetAxis(mousemoveconfig.VerticalAxis);
        }

        public int GetHorizontal(string mousemovename)
        {
            if (!MouseMoveConfigsByName.ContainsKey(mousemovename))
            {
                return 0;
            }
            MouseMoveConfig mousemoveconfig = MouseMoveConfigsByName[mousemovename];
            return GetAxis(mousemoveconfig.HorizontalAxis);
        }

        public int GetZoom(string mousemovename)
        {
            if (!MouseMoveConfigsByName.ContainsKey(mousemovename))
            {
                return 0;
            }
            MouseMoveConfig mousemoveconfig = MouseMoveConfigsByName[mousemovename];
            return GetAxis(mousemoveconfig.Zoom);
        }

        public Vector3 GetMouseStateVector(string mousemovename)
        {
            if (!MouseMoveConfigsByName.ContainsKey(mousemovename))
            {
                return null;
            }
            MouseMoveConfig mousemoveconfig = MouseMoveConfigsByName[mousemovename];
            return new Vector3(GetAxis(mousemoveconfig.HorizontalAxis), GetAxis(mousemoveconfig.VerticalAxis), GetAxis(mousemoveconfig.Zoom));
        }
    }
}
