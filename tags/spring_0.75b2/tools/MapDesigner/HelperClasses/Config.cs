// Copyright Hugh Perkins 2004,2005,2006
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

//! \file
//! \brief Used to read config from config.xml

using System;
using System.Collections.Generic;
using System.Xml;

    public class CommandCombo
    {
        public string command;
        public List<string> keycombo;
        public CommandCombo() { }
        public CommandCombo(string command, List<string> keycombo)
        {
            this.command = command;
            this.keycombo = keycombo;
        }
        public bool Matches(List<string> keynames)
        {
            foreach (string keyname in keycombo)
            {
                if (!keynames.Contains(keyname))
                {
                    return false;
                }
            }
            return true;
        }
    }

    public class MouseMoveConfig
    {
        public string VerticalAxis = "";
        public string HorizontalAxis = "";
        public string Zoom = "";
        public bool InvertVertical = false;
        public bool InvertScroll = false;
        public MouseMoveConfig() { }
        public MouseMoveConfig( string verticalaxis, string horizontalaxis )
        {
            this.VerticalAxis = verticalaxis;
            this.HorizontalAxis = horizontalaxis;
        }
        public MouseMoveConfig( string verticalaxis, string horizontalaxis, string zoom, bool InvertVertical, bool InvertScroll )
        {
            this.VerticalAxis = verticalaxis;
            this.HorizontalAxis = horizontalaxis;
            this.Zoom = zoom;
            this.InvertVertical = InvertVertical;
            this.InvertScroll = InvertScroll;
        }
    }

    public class MovementAreaConfig
    {
        public double MaxSlope;
        public Color color;
        public MovementAreaConfig(double maxslope, Color color)
        {
            this.MaxSlope = maxslope;
            this.color = color;
        }
    }

    public class Config
    {
        string sFilePath = "config.xml";

        public int iDebugLevel;

        public int iMapDefaultWidth = 1024;
        public int iMapDefaultHeight = 1024;

        public string defaultHeightMapFilename = "heightmap.bmp";
        public double minheight = 0;
        public double maxheight = 150;

        public string defaultSlopeMapFilename = "slopemap.bmp";
        public double SlopemapExportMaxSlope = 1.0;
        public List<MovementAreaConfig> movementareas = new List<MovementAreaConfig>();

        public int HeightEditingDefaultBrushSize = 100;
        public double HeightEditingSpeed = 10;
        
        public double cameratranslatespeed = 1;
        public double camerarotatespeed = 0.03;

        public int windowwidth;
        public int windowheight;

        public int mousescrollmultiplier = 50; // makes mouse scroll value comparable with mousex and y movements
            
        public List<CommandCombo> CommandCombos = new List<CommandCombo>();
        
        XmlDocument configdoc;
        public XmlElement clientconfig;
        public Dictionary<string,MouseMoveConfig> MouseMoveConfigsByName = new Dictionary<string,MouseMoveConfig>();
        
        static Config instance = new Config();
        public static Config GetInstance()
        {
            return instance;
        }
        
        public Config()
        {
            RefreshConfig();
        }

        double GetDouble(XmlElement xmlelement, string attributename)
        {            
            try
            {
                double value = Convert.ToDouble(xmlelement.GetAttribute(attributename));
                return value;
            }
            catch
            {
                EmergencyDialog.WarningMessage("In the config.xml file, the value " + attributename + " in section " + xmlelement.Name + " needs to be a number.  MapDesigner may not run correctly.");
                return 0;
            }
        }

        int GetInt(XmlElement xmlelement, string attributename)
        {
            try
            {
                int value = Convert.ToInt32(xmlelement.GetAttribute(attributename));
                return value;
            }
            catch
            {
                EmergencyDialog.WarningMessage("In the config.xml file, the value " + attributename + " in section " + xmlelement.Name + " needs to be a whole number.  MapDesigner may not run correctly.");
                return 0;
            }
        }
        
        public void RefreshConfig()
        {
            configdoc = XmlHelper.OpenDom( sFilePath );
            Diag.Debug("reading config.xml ...");
        
            XmlElement systemnode = (XmlElement)configdoc.DocumentElement.SelectSingleNode( "config");
            iDebugLevel = GetInt( systemnode, "debuglevel");
            Diag.Debug("DebugLevel " + iDebugLevel.ToString() );

            clientconfig = (XmlElement)configdoc.DocumentElement.SelectSingleNode( "client");

            XmlElement displaynode = clientconfig.SelectSingleNode("display") as XmlElement;
            windowwidth = GetInt(displaynode, "width");
            windowheight = GetInt(displaynode, "height");

            XmlElement mapconfig = clientconfig.SelectSingleNode("map") as XmlElement;
            iMapDefaultWidth = GetInt( mapconfig,"defaultwidth");
            iMapDefaultHeight = GetInt( mapconfig, "defaultheight");

            XmlElement heightmapconfig = clientconfig.SelectSingleNode("heightmap") as XmlElement;
            defaultHeightMapFilename = heightmapconfig.GetAttribute("defaultfilename" );
            minheight = GetInt( heightmapconfig, "minheight");
            maxheight = GetInt( heightmapconfig, "maxheight");

            XmlElement heighteditingconfig = clientconfig.SelectSingleNode("heightediting") as XmlElement;
            HeightEditingDefaultBrushSize = GetInt( heighteditingconfig, "defaultbrushsize");
            HeightEditingSpeed = GetDouble( heighteditingconfig, "speed");

            XmlElement slopemapconfig = clientconfig.SelectSingleNode("slopemap") as XmlElement;
            defaultSlopeMapFilename = slopemapconfig.GetAttribute("defaultfilename");
            SlopemapExportMaxSlope =  GetDouble( slopemapconfig, "exportmaxslope");
            foreach( XmlElement movementareanode in slopemapconfig.SelectNodes("movementareas/movementarea") )
            {
                double maxslope = Convert.ToDouble( movementareanode.GetAttribute("maxslope") );
                string colorstring = movementareanode.GetAttribute("color");
                Color color = new Color( 1,1,1);
                if( colorstring == "red" )
                {
                    color = new Color( 1,0,0);
                }
                else if (colorstring == "green")
                {
                    color = new Color( 0,1,0);
                }
                else if( colorstring == "blue" )
                {
                    color = new Color( 0,0,1);
                }
                movementareas.Add( new MovementAreaConfig( maxslope, color ) );
            }

            XmlElement movementconfig = clientconfig.SelectSingleNode("movement") as XmlElement;
            cameratranslatespeed =  GetDouble( movementconfig, "translatespeed");
            camerarotatespeed = GetDouble(movementconfig,"rotatespeed");

            foreach( XmlElement mappingnode in clientconfig.SelectNodes("keymappings/key") )
            {
                string sCommand = mappingnode.GetAttribute("command");
                string sKeyCodes = mappingnode.GetAttribute("keycode");
                string[] KeyCodes = sKeyCodes.Split("-".ToCharArray());
                List<string> keycodelist = new List<string>(KeyCodes);
                CommandCombos.Add( new CommandCombo( sCommand, keycodelist ) );
            }
            foreach (XmlElement mousemovenode in clientconfig.SelectNodes("mousemoveconfigs/mousemove"))
            {
                string name = mousemovenode.GetAttribute("name");
                string vertical = mousemovenode.GetAttribute("vertical");
                string horizontal = mousemovenode.GetAttribute("horizontal");
                string zoom = mousemovenode.GetAttribute("zoom");
                bool invertvertical = false;
                bool invertscroll = false;
                if (mousemovenode.HasAttribute("invertvertical") && mousemovenode.GetAttribute("invertvertical") == "yes")
                {
                    invertvertical = true;
                }
                if (mousemovenode.HasAttribute("invertscroll") && mousemovenode.GetAttribute("invertscroll") == "yes")
                {
                    invertscroll = true;
                }
                if (!MouseMoveConfigsByName.ContainsKey(name))
                {
                    MouseMoveConfigsByName.Add(name, new MouseMoveConfig(vertical, horizontal, zoom, invertvertical, invertscroll));
                }
            }
        
            Diag.Debug("... config.xml read");
        }
        
        public string GetFactoryTargetClassname( string sfactoryname )
        {
            try
            {
                XmlElement factorynode = (XmlElement)configdoc.SelectSingleNode("root/factories/factory[name='" + sfactoryname.ToLower() + "']" );
                return factorynode.GetAttribute("select");
            }
            catch( Exception e )
            {
                LogFile.GetInstance().WriteLine(e.ToString());
                return "";
            }
        }
    }
