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

namespace MapDesigner
{
    // Note to self : might be cool to (a) use Reflection and/or (b) use the config file
    public class PluginsLoader
    {
        static PluginsLoader instance = new PluginsLoader();
        CurrentEditSpot currenteditspot = new CurrentEditSpot();
        QuitHandler quit = new QuitHandler();

        public static PluginsLoader GetInstance()
        {
            Config.GetInstance();
            DrawGrid.GetInstance();
            UICommandQueue.GetInstance().InitFromGlThread();
            HeightMapPersistence.GetInstance();
            SlopeMapPersistence.GetInstance();
            MouseFilterSdlMouseCache.GetInstance();
            KeyFilterSdlKeyCache.GetInstance();
            KeyFilterConfigMappingsFactory.GetInstance();
            MainUI.GetInstance();
            HeightEditor.GetInstance();
            Camera.GetInstance();
            Framerate.GetInstance();
            FrustrumCulling.GetInstance();
            return instance;
        }
        public void LoadPlugins()
        {
        }
    }
}
