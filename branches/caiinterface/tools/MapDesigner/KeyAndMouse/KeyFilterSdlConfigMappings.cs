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
using SdlDotNet;

namespace MapDesigner
{
    // This class points to the renderer obtained by RendererFactory
    // It converts the key codes returned by the renderer, which are assumed to be in System.Windows.Forms format
    // into the commandstrings defined in the configuration file (config.xml, via Config.cs )
    // This is a critical part of the keyboard chain, because it handles keycode combos, eg "shift-escape" is converted into "quit", based on current config.xml
    // This reads the mousebuttons too, so it's possible to include the mousebuttons in these combos, eg "leftmousebutton"
    public class KeyFilterSdlConfigMappings : IKeyFilterConfigMappings
    {
        Config config;
        static KeyFilterSdlConfigMappings instance = new KeyFilterSdlConfigMappings();

        List<string> CurrentPressedKeys = new List<string>();

        public List<CommandCombo> currentcombos = new List<CommandCombo>();
        public Dictionary<string, List<CommandCombo>> currentcombosbycommand = new Dictionary<string, List<CommandCombo>>();
        public List<string> _CurrentPressedKeys = new List<String>();

        KeyFilterSdlConfigMappings()
        {
            config = Config.GetInstance();
            KeyFilterSdlKeyCache keycache = KeyFilterSdlKeyCache.GetInstance();
            keycache.KeyDown += new SdlDotNet.KeyboardEventHandler(keycache_KeyDown);
            keycache.KeyUp += new SdlDotNet.KeyboardEventHandler(keycache_KeyUp);
            MouseFilterSdlMouseCache.GetInstance().MouseDown += new SdlDotNet.MouseButtonEventHandler(KeyFilterSdlConfigMappings_MouseDown);
            MouseFilterSdlMouseCache.GetInstance().MouseUp += new SdlDotNet.MouseButtonEventHandler(KeyFilterSdlConfigMappings_MouseUp);
        }

        void KeyFilterSdlConfigMappings_MouseUp(object sender, SdlDotNet.MouseButtonEventArgs e)
        {
            string mousebuttonname = MouseEventToKeyName(e);
            if (mousebuttonname != "")
            {
                HandleKeyUp(mousebuttonname);
            }
        }

        void KeyFilterSdlConfigMappings_MouseDown(object sender, SdlDotNet.MouseButtonEventArgs e)
        {
            string mousebuttonname = MouseEventToKeyName(e);
            if (mousebuttonname != "")
            {
                HandleKeyDown(mousebuttonname);
            }
        }

        string MouseEventToKeyName(MouseButtonEventArgs e)
        {
            if (e.Button == MouseButton.PrimaryButton)
            {
                return "leftmousebutton";
            }
            if (e.Button == MouseButton.MiddleButton)
            {
                return "middlemousebutton";
            }
            if (e.Button == MouseButton.SecondaryButton)
            {
                return "rightmousebutton";
            }
            return "";
        }

        public static KeyFilterSdlConfigMappings GetInstance()
        {
            return instance;
        }

        public List<String> AllPressedCommandKeys{
            get { return _CurrentPressedKeys; }
        }

        public bool IsPressed( string commandstring )
        {
            if( currentcombosbycommand.ContainsKey( commandstring ) && currentcombosbycommand[ commandstring ].Count > 0 )
            {
                return true;
            }
            return false;
        }

        public string KeyCodeToKeyName( SdlDotNet.KeyboardEventArgs e )
        {
            string skeyname = e.Key.ToString().ToLower();
            if( skeyname.IndexOf( "shift" ) >= 0 )
            {
                skeyname = "shift";
            }                
            else if( skeyname.IndexOf( "control" ) >= 0 )
            {
                skeyname = "ctrl";
            }
            else if (skeyname.IndexOf("alt" ) >= 0 )
            {
                skeyname = "alt";
            }
            //Console.WriteLine(skeyname);
            return skeyname;	 
        }

        void HandleKeyDown(string thiskeyname)
        {
            if (!_CurrentPressedKeys.Contains(thiskeyname))
            {
                // handle "none" keycode, eg for mouse scroll button zoom
                if (_CurrentPressedKeys.Count == 0)
                {
                    foreach (CommandCombo commandcombo in config.CommandCombos)
                    {
                        if (commandcombo.keycombo.Count == 1 && commandcombo.keycombo[0] == "none")
                        {
                            LogFile.GetInstance().WriteLine("combo up: " + commandcombo.command);
                            if (CommandHandlers.ContainsKey(commandcombo.command))
                            {
                                foreach (KeyCommandHandler handler in CommandHandlers[commandcombo.command])
                                {
                                    handler(commandcombo.command, false);
                                }
                            }

                        }
                    }
                }
                _CurrentPressedKeys.Add(thiskeyname);
                foreach( CommandCombo commandcombo in config.CommandCombos )
                {
                    if( !currentcombos.Contains( commandcombo )
                        && commandcombo.Matches( _CurrentPressedKeys ) )
                    {
                        currentcombos.Add(commandcombo);
                        if (!currentcombosbycommand.ContainsKey( commandcombo.command ) )
                        {
                            currentcombosbycommand.Add( commandcombo.command, new List<CommandCombo>() );
                        }
                        currentcombosbycommand[ commandcombo.command ].Add( commandcombo );
                        if( currentcombosbycommand[ commandcombo.command ].Count == 1 )
                        {
                            LogFile.GetInstance().WriteLine("new combo: " + commandcombo.command);
                            if (CommandHandlers.ContainsKey(commandcombo.command))
                            {
                                foreach (KeyCommandHandler handler in CommandHandlers[commandcombo.command])
                                {
                                    handler(commandcombo.command, true);
                                }
                            }
                        }
                    }
                }
            }
        }

        void HandleKeyUp(string thiskeyname)
        {
            if (_CurrentPressedKeys.Contains(thiskeyname))
            {
                _CurrentPressedKeys.Remove(thiskeyname);
                foreach (CommandCombo commandcombo in config.CommandCombos)
                {
                    if (currentcombos.Contains(commandcombo)
                        && !commandcombo.Matches(_CurrentPressedKeys))
                    {
                        currentcombos.Remove(commandcombo);
                        currentcombosbycommand[commandcombo.command].Remove(commandcombo);
                        if (currentcombosbycommand[commandcombo.command].Count == 0)
                        {
                            LogFile.GetInstance().WriteLine("combo up: " + commandcombo.command);
                            if (CommandHandlers.ContainsKey(commandcombo.command))
                            {
                                foreach (KeyCommandHandler handler in CommandHandlers[commandcombo.command])
                                {
                                    handler(commandcombo.command, false);
                                }
                            }
                        }
                    }
                }
                // handle "none" keycode, eg for mouse scroll button zoom
                if (_CurrentPressedKeys.Count == 0)
                {
                    foreach (CommandCombo commandcombo in config.CommandCombos)
                    {
                        if (commandcombo.keycombo.Count == 1 && commandcombo.keycombo[0] == "none")
                        {
                            LogFile.GetInstance().WriteLine("combo down: " + commandcombo.command);
                            if (CommandHandlers.ContainsKey(commandcombo.command))
                            {
                                foreach (KeyCommandHandler handler in CommandHandlers[commandcombo.command])
                                {
                                    handler(commandcombo.command, true);
                                }
                            }

                        }
                    }
                }
            }
        }

        void keycache_KeyDown(object sender, SdlDotNet.KeyboardEventArgs e)
        {
            string thiskeyname = KeyCodeToKeyName( e );
            HandleKeyDown(thiskeyname);
        }

        void keycache_KeyUp(object sender, SdlDotNet.KeyboardEventArgs e)
        {
            string thiskeyname = KeyCodeToKeyName(e);
            HandleKeyUp(thiskeyname);
        }

        Dictionary<string, List<KeyCommandHandler>> CommandHandlers = new Dictionary<string, List<KeyCommandHandler>>();

        public void RegisterCommand(string command, KeyCommandHandler handler)
        {
            if (!CommandHandlers.ContainsKey(command))
            {
                CommandHandlers.Add(command, new List<KeyCommandHandler>());
            }
            if (!CommandHandlers[command].Contains(handler))
            {
                CommandHandlers[command].Add(handler);
            }
        }
    }
}
