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

using System.IO;
using System;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Collections.Generic;

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
            instance.LoadAssemblyPlugins();

            Config.GetInstance();
            Terrain.GetInstance();
            HeightMapPersistence.GetInstance();
            SlopeMapPersistence.GetInstance();
            MouseFilterSdlMouseCache.GetInstance();
            KeyFilterSdlKeyCache.GetInstance();
            KeyFilterConfigMappingsFactory.GetInstance();
            //HeightEditor.GetInstance();
            EditController.GetInstance();
            Camera.GetInstance();
            Framerate.GetInstance();
            FrustrumCulling.GetInstance();

            BrushShapeController.GetInstance().Register( new RoundBrush() );
            BrushShapeController.GetInstance().Register( new SquareBrush() );

            BrushEffectController.GetInstance().Register( new RaiseLower() );
            BrushEffectController.GetInstance().Register( new Flatten() );
            BrushEffectController.GetInstance().Register( new PaintTexture() );
            BrushEffectController.GetInstance().Register( new AddFeature() );
            BrushEffectController.GetInstance().Register( new FixedHeight() );

            //Sm3Persistence.GetInstance().LoadSm3("maps/Whakamatunga_Riri.sm3");
            //EditTexture.GetInstance();
            //FeatureEditing.GetInstance();

            MainUI.GetInstance();

            return instance;
        }

        byte[] ReadFile(string filename)
        {
            FileStream fs = new FileStream(filename, FileMode.Open);
            BinaryReader br = new BinaryReader(fs);
            byte[] bytes = br.ReadBytes((int)fs.Length);
            br.Close();
            fs.Close();
            return bytes;
        }

        object LoadPluginObject(byte[] assemblybytes, string targettypename, string methodname)
        {
            Console.WriteLine("LoadPluginObject class " + targettypename + " method " + methodname);
            Assembly a = Assembly.Load(assemblybytes);
            Type t = a.GetType(targettypename);
            object instance = a.CreateInstance(targettypename);
            MethodInfo mi = t.GetMethod(methodname);
            mi.Invoke(instance, null);
            return instance;
        }

        public void LoadAssemblyPlugins()
        {
            if (!Directory.Exists("plugins"))
            {
                return;
            }
            foreach (string file in Directory.GetFiles("plugins"))
            {
                if (file.ToLower().EndsWith(".dll") || file.ToLower().EndsWith(".so") || file.ToLower().EndsWith(".plugin"))
                {
                    try
                    {
                        LogFile.GetInstance().WriteLine("Loading plugin " + file + " ... ");
                        byte[] bytes = ReadFile(file);
                        LoadPluginObject(bytes, Path.GetFileNameWithoutExtension(file), "Load");
                    }
                    catch (Exception e)
                    {
                        LogFile.GetInstance().WriteLine("Failed to load plugin " + file + ": " + e.ToString());
                    }
                }
            }
        }
    }
}
