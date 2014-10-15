# -*- coding: UTF-8 -*-

#======================================================
 #            gui_host.py
 #
 #  Sat July 23 18:07 2005
 #  Copyright  2005  Josh Mattila
 #
 #  Other authors may add their names above!
 #
 #  jm6.linux@gmail.com
#======================================================
 
#
 #  This program is free software; you can redistribute it and/or modify
 #  it under the terms of the GNU General Public License as published by
 #  the Free Software Foundation; either version 2 of the License, or
 #  (at your option) any later version.
 #
 #  This program is distributed in the hope that it will be useful,
 #  but WITHOUT ANY WARRANTY; without even the implied warranty of
 #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #  GNU Library General Public License for more details.
 #
 #  You should have received a copy of the GNU General Public License
 #  along with this program; if not, write to the Free Software
 #  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#

import os,wx,misc,socket

from GLOBAL import *

#======================================================================
#===========WARNING: Some code below has been modified!================
#======================================================================

# Always read the documentation carefully before updating code from the py.gen folder!

class gui_host(wx.Dialog):
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_host.__init__
        kwds["style"] = wx.DEFAULT_DIALOG_STYLE
        wx.Dialog.__init__(self, *args, **kwds)
        self.label_host_server_name = wx.StaticText(self, -1, "Battle Name")
        self.text_host_server_nameData = wx.TextCtrl(self, 201, "", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.label_host_server_modType = wx.StaticText(self, -1, "Mod")
        self.choice_host_server_modData = wx.Choice(self, -1, choices=["Spring - v0.51b1", ""])
        self.label_host_server_port = wx.StaticText(self, -1, "Port")
        self.text_host_server_portData = wx.TextCtrl(self, 202, "8452", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.checkbox_host_server_privateGameData = wx.CheckBox(self, 301, "Private Game")
        self.checkbox_host_server_lanGameData = wx.CheckBox(self, 302, "Lan Game")
        self.label_host_server_maxPlayers = wx.StaticText(self, -1, "Max Players")
        self.slider_host_server_maxPlayersData = wx.Slider(self, -1, 2, 2, 12, style=wx.SL_HORIZONTAL|wx.SL_AUTOTICKS)
        self.label_host_battle_maxUnitsData_copy = wx.StaticText(self, -1, "2")
        self.label_host_server_maxUnits = wx.StaticText(self, -1, "Max Units")
        self.text_host_server_maxUnitsData = wx.TextCtrl(self, 203, "300", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.label_host_server_startEnergy = wx.StaticText(self, -1, "Start Energy")
        self.text_host_server_startEnergyData = wx.TextCtrl(self, 204, "1000", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.label_host_server_startMetal = wx.StaticText(self, -1, "Start Metal")
        self.text_host_server_startMetalData = wx.TextCtrl(self, 205, "1000", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.button_host_server_ok = wx.Button(self, 101, "OK")
        self.button_host_server_cancel = wx.Button(self, 102, "Cancel")
        self.button_host_server_testHost = wx.Button(self, 103, "Test")

    #===============================================================================
    # Added os.path.join() to make it so that Windows users can see the icons too!
        self.bitmap_host_map_preview = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/","minimap-placeholder.png"), wx.BITMAP_TYPE_ANY))
    # /end edits ===================================================================

        self.choice_host_map_mapData = wx.Choice(self, -1, choices=["FloodedDesert - 10x10", ""])
        self.label_host_map_description_copy_2_copy_copy = wx.StaticText(self, -1, "Description:")
        self.text_host_map_description = wx.TextCtrl(self, -1, "", style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_AUTO_URL)

        self.__set_properties()
        self.__do_layout()
        # end wxGlade

        self.__do_events()
	
	
  #==========================================================================================================
  #==========================================================================================================
  #======================================BEGIN EVENTS========================================================
  #==========================================================================================================
  #==========================================================================================================

# __do_events() ====================================================================================
# ==================================================================================================
#  This function maps events to callback functions 
#  defined within this class. Note that ID's are 
#  only used for menu items for which they are necessary.
# ==================================================================================================
    def __do_events(self):
        wx.EVT_CLOSE(self, self.OnClose)
# /end __do_events() ===============================================================================




# OnClose() ========================================================================================
# ==================================================================================================
#  Needed for destroying the window when the user
#  hits the X in the corner.  If this event is not
#  implimented, when the gui_lobby window is closed, 
#  this window will become the new top window even 
#  though the user cannot see it.  

#  Destroying the top window in wxWidgets is the 
#  only way to end the program.
# ==================================================================================================
    def OnClose(self, event):
        self.Destroy()
# /end OnClose() ===================================================================================



  #==========================================================================================================
  #==========================================================================================================
  #=========================================OTHER FUNCTIONS==================================================
  #==========================================================================================================
  #==========================================================================================================
  
  

# __do_init() ======================================================================================
# ==================================================================================================
#  Do other init that is not already done by the
#  wxGlade generated code.  This makes integrating the 
#  wxGlade code much easier (if it needs to change).

#  Initializes the wxConfig class to store and retrieve
#  data from files "portably".
# ==================================================================================================
    def __do_init(self):
        self.InitConfig
# /end __do_init() =================================================================================




  #==========================================================================================================
  #==========================================================================================================
  #======================================WXCONFIG FUNCTIONS==================================================
  #==========================================================================================================
  #==========================================================================================================




# InitConfig() =====================================================================================
# ==================================================================================================
#  This function sets up the wxConfig class so that it can
#  be used by SpringClient.  All config initialization should
#  go here.
# ==================================================================================================
    def InitConfig(self):
        config = wx.Config().Get()

        # Write all changes to the file
        config.Flush()
# /end InitConfig() ================================================================================




# SaveConfig() =====================================================================================
# ==================================================================================================
#  This function saves the configuration settings that
#  need to be saved.  This is usually called when the
#  window is being destroyed.
# ==================================================================================================
    def SaveConfig(self):
        config = wx.Config.Get()
        
        # Write all changes to the file
        config.Flush()	
# /end SaveConfig() ================================================================================




  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================



    def __set_properties(self):
        # begin wxGlade: gui_host.__set_properties
        self.SetTitle("Spring - Host Battle")
        _icon = wx.EmptyIcon()

        #===============================================================================
        # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
        # /end edits ===================================================================
        
        
        self.SetIcon(_icon)
        self.label_host_server_name.SetSize((92, 17))
        self.text_host_server_nameData.SetSize((150, 25))
        self.text_host_server_nameData.SetToolTipString("The name of the battle that will show up on the battle list in the lobby")
        self.label_host_server_modType.SetSize((77, 17))
        self.choice_host_server_modData.SetSize((150, 25))
        self.choice_host_server_modData.SetSelection(0)
        self.label_host_server_port.SetSize((77, 17))
        self.text_host_server_portData.SetSize((150, 25))
        self.text_host_server_portData.SetToolTipString("Enter the port that the game will use to accept incoming connections")
        self.checkbox_host_server_privateGameData.SetToolTipString("Private games do not show up on the server list")
        self.checkbox_host_server_lanGameData.SetToolTipString("Lan games show up in the lan tab of your client (if it is enabled)")
        self.label_host_server_maxPlayers.SetSize((77, 17))
        self.slider_host_server_maxPlayersData.SetSize((130, 35))
        self.slider_host_server_maxPlayersData.SetToolTipString("Select the max number of players you wish to allow to join")
        self.label_host_battle_maxUnitsData_copy.SetSize((30, 17))
        self.label_host_server_maxUnits.SetSize((77, 25))
        self.text_host_server_maxUnitsData.SetSize((150, 25))
        self.text_host_server_maxUnitsData.SetToolTipString("Enter the max units per player")
        self.label_host_server_startEnergy.SetSize((77, 25))
        self.text_host_server_startEnergyData.SetSize((150, 25))
        self.text_host_server_startEnergyData.SetToolTipString("Enter the starting energy for every player")
        self.label_host_server_startMetal.SetSize((77, 17))
        self.text_host_server_startMetalData.SetSize((150, 25))
        self.text_host_server_startMetalData.SetToolTipString("Enter the starting metal for each player")
        self.button_host_server_ok.SetDefault()
        self.button_host_server_testHost.SetToolTipString("Test your configuration to see whether you can host a battle or not")
        self.choice_host_map_mapData.SetSize((167, 25))
        self.choice_host_map_mapData.SetSelection(0)
        self.text_host_map_description.SetSize((200, 115))
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_host.__do_layout
        grid_host_main = wx.FlexGridSizer(3, 5, 0, 0)
        grid_host_map = wx.FlexGridSizer(17, 1, 0, 0)
        grid_host_mapSettings = wx.FlexGridSizer(3, 1, 0, 0)
        sizer_host_map_description = wx.BoxSizer(wx.VERTICAL)
        grid_host_server = wx.FlexGridSizer(24, 1, 0, 0)
        sizer_host_battle_buttons = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_startMetal = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_startEnergy = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_maxUnits = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_maxPlayers = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_lanGame = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_private = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_port = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_modType = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_server_name = wx.BoxSizer(wx.HORIZONTAL)
        grid_host_main.Add((10, 10), 0, 0, 0)
        grid_host_main.Add((200, 10), 0, 0, 0)
        grid_host_main.Add((10, 10), 0, 0, 0)
        grid_host_main.Add((150, 10), 0, 0, 0)
        grid_host_main.Add((10, 10), 0, 0, 0)
        grid_host_main.Add((10, 300), 0, 0, 0)
        sizer_host_server_name.Add(self.label_host_server_name, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_host_server_name.Add(self.text_host_server_nameData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        grid_host_server.Add(sizer_host_server_name, 1, 0, 0)
        grid_host_server.Add((200, 5), 0, 0, 0)
        sizer_host_server_modType.Add(self.label_host_server_modType, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_host_server_modType.Add((15, 20), 0, 0, 0)
        sizer_host_server_modType.Add(self.choice_host_server_modData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_host_server.Add(sizer_host_server_modType, 1, 0, 0)
        grid_host_server.Add((200, 5), 0, 0, 0)
        sizer_host_server_port.Add(self.label_host_server_port, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_host_server_port.Add((15, 20), 0, 0, 0)
        sizer_host_server_port.Add(self.text_host_server_portData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        grid_host_server.Add(sizer_host_server_port, 1, 0, 0)
        grid_host_server.Add((200, 20), 0, 0, 0)
        sizer_host_server_private.Add((15, 20), 0, 0, 0)
        sizer_host_server_private.Add(self.checkbox_host_server_privateGameData, 0, 0, 0)
        grid_host_server.Add(sizer_host_server_private, 1, 0, 0)
        sizer_host_server_lanGame.Add((15, 20), 0, 0, 0)
        sizer_host_server_lanGame.Add(self.checkbox_host_server_lanGameData, 0, wx.EXPAND, 0)
        grid_host_server.Add(sizer_host_server_lanGame, 1, 0, 0)
        grid_host_server.Add((200, 20), 0, 0, 0)
        sizer_host_server_maxPlayers.Add(self.label_host_server_maxPlayers, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_host_server_maxPlayers.Add((15, 20), 0, 0, 0)
        sizer_host_server_maxPlayers.Add(self.slider_host_server_maxPlayersData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_host_server_maxPlayers.Add(self.label_host_battle_maxUnitsData_copy, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_host_server.Add(sizer_host_server_maxPlayers, 1, 0, 0)
        grid_host_server.Add((200, 5), 0, 0, 0)
        sizer_host_server_maxUnits.Add(self.label_host_server_maxUnits, 0, wx.FIXED_MINSIZE, 0)
        sizer_host_server_maxUnits.Add((15, 20), 0, 0, 0)
        sizer_host_server_maxUnits.Add(self.text_host_server_maxUnitsData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        grid_host_server.Add(sizer_host_server_maxUnits, 1, 0, 0)
        grid_host_server.Add((200, 5), 0, 0, 0)
        sizer_host_server_startEnergy.Add(self.label_host_server_startEnergy, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_host_server_startEnergy.Add((15, 20), 0, 0, 0)
        sizer_host_server_startEnergy.Add(self.text_host_server_startEnergyData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        grid_host_server.Add(sizer_host_server_startEnergy, 1, 0, 0)
        grid_host_server.Add((200, 5), 0, 0, 0)
        sizer_host_server_startMetal.Add(self.label_host_server_startMetal, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_host_server_startMetal.Add((15, 20), 0, 0, 0)
        sizer_host_server_startMetal.Add(self.text_host_server_startMetalData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        grid_host_server.Add(sizer_host_server_startMetal, 1, 0, 0)
        grid_host_server.Add((200, 10), 0, 0, 0)
        sizer_host_battle_buttons.Add(self.button_host_server_ok, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_buttons.Add(self.button_host_server_cancel, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_buttons.Add(self.button_host_server_testHost, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_host_server.Add(sizer_host_battle_buttons, 1, 0, 0)
        grid_host_main.Add(grid_host_server, 1, wx.ALL|wx.EXPAND, 1)
        grid_host_main.Add((10, 300), 0, 0, 0)
        grid_host_map.Add(self.bitmap_host_map_preview, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_host_map.Add((135, 15), 0, 0, 0)
        grid_host_map.Add(self.choice_host_map_mapData, 0, wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_host_map.Add((100, 15), 0, 0, 0)
        sizer_host_map_description.Add(self.label_host_map_description_copy_2_copy_copy, 0, 0, 0)
        sizer_host_map_description.Add(self.text_host_map_description, 0, wx.ALL|wx.FIXED_MINSIZE, 1)
        grid_host_mapSettings.Add(sizer_host_map_description, 1, wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_host_map.Add(grid_host_mapSettings, 1, wx.EXPAND, 0)
        grid_host_main.Add(grid_host_map, 1, wx.ALL|wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL, 1)
        grid_host_main.Add((10, 300), 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_host_main.Add((10, 10), 0, 0, 0)
        grid_host_main.Add((200, 10), 0, 0, 0)
        grid_host_main.Add((10, 10), 0, 0, 0)
        grid_host_main.Add((150, 10), 0, 0, 0)
        grid_host_main.Add((10, 10), 0, 0, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_host_main)
        grid_host_main.Fit(self)
        grid_host_main.SetSizeHints(self)
        self.Layout()
        self.Centre()
        # end wxGlade

# end of class gui_host


