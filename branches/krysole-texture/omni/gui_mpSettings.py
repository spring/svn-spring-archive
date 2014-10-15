# -*- coding: UTF-8 -*-

#======================================================
 #            gui_mpSettings.py
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

class gui_mpSettings(wx.Dialog):
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_mpSettings.__init__
        kwds["style"] = wx.DEFAULT_DIALOG_STYLE
        wx.Dialog.__init__(self, *args, **kwds)
        self.label_mpSettings_detail_treeViewDist = wx.StaticText(self, -1, "Tree View Distance")
        self.slider_mpSettings_detail_treeViewDist = wx.Slider(self, -1, 1400, 600, 3000, style=wx.SL_HORIZONTAL|wx.SL_LABELS)
        self.label_mpSettings_detail_terrainDetail = wx.StaticText(self, -1, "Terrain Detail")
        self.slider_mpSettings_detail_terrainDetail = wx.Slider(self, -1, 40, 1, 100, style=wx.SL_HORIZONTAL|wx.SL_LABELS)
        self.label_mpSettings_detail_unitDetailDist = wx.StaticText(self, -1, "Unit Detail Distance")
        self.slider_mpSettings_detail_unitDetailDist = wx.Slider(self, -1, 300, 100, 600, style=wx.SL_HORIZONTAL|wx.SL_LABELS)
        self.label_mpSettings_detail_grassDetail = wx.StaticText(self, -1, "Grass Detail")
        self.slider_mpSettings_detail_grassDetail = wx.Slider(self, -1, 40, 1, 100, style=wx.SL_HORIZONTAL|wx.SL_LABELS)
        self.label_mpSettings_detail_particleLimit = wx.StaticText(self, -1, "Particle Limit")
        self.slider_mpSettings_detail_particleLimit = wx.Slider(self, -1, 8000, 1000, 20000, style=wx.SL_HORIZONTAL|wx.SL_LABELS)
        self.label_mpSettings_detail_maxSounds = wx.StaticText(self, -1, "Max Simultaneous Sounds")
        self.slider_mpSettings_detail_maxSounds = wx.Slider(self, -1, 48, 8, 128, style=wx.SL_HORIZONTAL|wx.SL_LABELS)
        self.checkbox_mpSettings_render_3DTrees = wx.CheckBox(self, -1, "Render 3D Trees")
        self.checkbox_mpSettings_render_highResClouds = wx.CheckBox(self, -1, "Render High Resolution Clouds")
        self.checkbox_mpSettings_render_dynamicClouds = wx.CheckBox(self, -1, "Render Dynamic Clouds")
        self.checkbox_mpSettings_render_reflectiveWater = wx.CheckBox(self, -1, "Render Water Reflections")
        self.checkbox_mpSettings_render_fullScreen = wx.CheckBox(self, -1, "Fullscreen")
        self.checkbox_mpSettings_render_coloredElevation = wx.CheckBox(self, -1, "Colorized Elevation Map")
        self.checkbox_mpSettings_render_invertMouse = wx.CheckBox(self, -1, "Invert Mouse")
        self.checkbox_mpSettings_render_shadows = wx.CheckBox(self, -1, "Enable Shadows")
        self.radiobox_mpSettings_render_shadowMaps = wx.RadioBox(self, -1, "Shadow Map Size", choices=["1024", "2048"], majorDimension=1, style=wx.RA_SPECIFY_ROWS)
        self.radiobox_mpSettings_render_unitTextures = wx.RadioBox(self, -1, "Unit Texture Quality", choices=["1x", "2xSal", "2xHQ", "4xHQ"], majorDimension=2, style=wx.RA_SPECIFY_COLS)
        self.label_mpSettings_basics_playerName = wx.StaticText(self, -1, "Lan Name")
        self.text_mpSettings_basics_nameData = wx.TextCtrl(self, -1, "NoName")
        self.label_mpSettings_basics_screenRes = wx.StaticText(self, -1, "Screen Resolution")
        self.choice_mpSettings_basics_screenResData = wx.Choice(self, -1, choices=["640x480", "800x600", "1024x768", "1280x1024", "1600x1200"])
        self.button_mpSettings_basics_save = wx.Button(self, 101, "Save")
        self.button_mpSettings_basics_cancel = wx.Button(self, 102, "Cancel")
        self.button_mpSettings_basics_revertToDefaults = wx.Button(self, 103, "Defaults")

        self.__set_properties()
        self.__do_layout()
        # end wxGlade

    	self.__do_events()
    	self.__do_init()



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

        wx.EVT_BUTTON(self, self.button_mpSettings_basics_save.GetId(), self.OnSaveSettings)
        wx.EVT_BUTTON(self, self.button_mpSettings_basics_cancel.GetId(), self.OnClose)
        wx.EVT_BUTTON(self, self.button_mpSettings_basics_revertToDefaults.GetId(), self.OnDefaults)
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
# /end __do_events() ===============================================================================



# OnSaveSettings() =================================================================================
# ==================================================================================================
#  This function is triggered when the user choses to
#  save the settings he changed.

    def OnSaveSettings(self, event):
        self.SaveConfig()
    	self.Close(True)
# /end OnSaveSettings() ============================================================================




# OnDefaults() =====================================================================================
# ==================================================================================================
#  This function is triggered when the user choses to
#  revert to the default settings.

    def OnDefaults(self, event):

        self.slider_mpSettings_detail_treeViewDist.SetValue(DEFAULT_TREEVIEWDIST)
        self.slider_mpSettings_detail_terrainDetail.SetValue(DEFAULT_TERRAINDETAIL)
        self.slider_mpSettings_detail_unitDetailDist.SetValue(DEFAULT_UNITDETAILDIST)
        self.slider_mpSettings_detail_particleLimit.SetValue(DEFAULT_PARTICLELIMIT)
        self.slider_mpSettings_detail_maxSounds.SetValue(DEFAULT_MAXSOUNDS)

        self.checkbox_mpSettings_render_3DTrees.SetValue(DEFAULT_3DTREES)
        self.checkbox_mpSettings_render_highResClouds.SetValue(DEFAULT_HIGHRESCLOUDS)
        self.checkbox_mpSettings_render_dynamicClouds.SetValue(DEFAULT_DYNAMICCLOUDS)
        self.checkbox_mpSettings_render_reflectiveWater.SetValue(DEFAULT_DYNAMICCLOUDS)
        self.checkbox_mpSettings_render_fullScreen.SetValue(DEFAULT_FULLSCREEN)
        self.checkbox_mpSettings_render_invertMouse.SetValue(DEFAULT_INVERTMOUSE)
        self.checkbox_mpSettings_render_coloredElevation.SetValue(DEFAULT_COLOREDELEVATION)
        self.checkbox_mpSettings_render_shadows.SetValue(DEFAULT_SHADOWS)

        self.radiobox_mpSettings_render_shadowMaps.SetSelection(0)
        self.radiobox_mpSettings_render_unitTextures.SetSelection(0)

        self.choice_mpSettings_basics_screenResData.SetSelection(1)
        self.text_mpSettings_basics_nameData.SetValue("NoName")
# /end OnDefaults() ================================================================================


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
    	self.InitConfig()
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
        config = wx.Config.Get()

        self.slider_mpSettings_detail_treeViewDist.SetValue(config.ReadInt("/Spring/TreeViewDist"))
        self.slider_mpSettings_detail_terrainDetail.SetValue(config.ReadInt("/Spring/TerrainDetail"))
        self.slider_mpSettings_detail_unitDetailDist.SetValue(config.ReadInt("/Spring/UnitDetailDist"))
        self.slider_mpSettings_detail_particleLimit.SetValue(config.ReadInt("/Spring/ParticleLimit"))
        self.slider_mpSettings_detail_maxSounds.SetValue(config.ReadInt("/Spring/MaxSounds"))

        self.checkbox_mpSettings_render_3DTrees.SetValue(config.ReadBool("/Spring/Render3dTrees"))
        self.checkbox_mpSettings_render_highResClouds.SetValue(config.ReadBool("/Spring/HighResClouds"))
        self.checkbox_mpSettings_render_dynamicClouds.SetValue(config.ReadBool("/Spring/DynamicClouds"))
        self.checkbox_mpSettings_render_reflectiveWater.SetValue(config.ReadBool("/Spring/ReflectiveWater"))
        self.checkbox_mpSettings_render_fullScreen.SetValue(config.ReadBool("/Spring/FullScreen"))
        self.checkbox_mpSettings_render_invertMouse.SetValue(config.ReadBool("/Spring/InvertMouse"))
        self.checkbox_mpSettings_render_coloredElevation.SetValue(config.ReadBool("/Spring/ColorizedElevationMap"))
        self.checkbox_mpSettings_render_shadows.SetValue(config.ReadBool("/Spring/EnableUnitShadows"))

        if config.ReadInt("/Spring/ShadowMapSize") == 1024:
            self.radiobox_mpSettings_render_shadowMaps.SetSelection(0)
        else:
            self.radiobox_mpSettings_render_shadowMaps.SetSelection(1)


        # 1 for 1x, 2 for 2xSal, 3 for 2xHQ, 4 for 4xHQ
        if config.ReadInt("/Spring/TextureQuality") == 1:
            self.radiobox_mpSettings_render_unitTextures.SetSelection(0)
        elif config.ReadInt("/Spring/TextureQuality") == 2:
            self.radiobox_mpSettings_render_unitTextures.SetSelection(1)
        elif config.ReadInt("/Spring/TextureQuality") == 3:
            self.radiobox_mpSettings_render_unitTextures.SetSelection(2)
        elif config.ReadInt("/Spring/TextureQuality") == 4:
            self.radiobox_mpSettings_render_unitTextures.SetSelection(3)

        if config.ReadInt("/Spring/Resolution") == 640:
            self.choice_mpSettings_basics_screenResData.SetSelection(0)
        elif config.ReadInt("/Spring/Resolution") == 800:
            self.choice_mpSettings_basics_screenResData.SetSelection(1)
        elif config.ReadInt("/Spring/Resolution") == 1024:
            self.choice_mpSettings_basics_screenResData.SetSelection(2)
        elif config.ReadInt("/Spring/Resolution") == 1280:
            self.choice_mpSettings_basics_screenResData.SetSelection(3)
        elif config.ReadInt("/Spring/Resolution") == 1600:
            self.choice_mpSettings_basics_screenResData.SetSelection(4)

        self.text_mpSettings_basics_nameData.SetValue(config.Read("/Spring/LanName"))
# /end InitConfig() ================================================================================





# SaveConfig() =====================================================================================
# ==================================================================================================
#  This function saves the configuration settings that
#  need to be saved.  This is usually called when the
#  window is being destroyed.
# ==================================================================================================
    def SaveConfig(self):
            
        config = wx.Config.Get()

        config.WriteInt("/Spring/TreeViewDist", self.slider_mpSettings_detail_treeViewDist.GetValue())
        config.WriteInt("/Spring/TerrainDetail", self.slider_mpSettings_detail_terrainDetail.GetValue())
        config.WriteInt("/Spring/UnitDetailDist", self.slider_mpSettings_detail_unitDetailDist.GetValue())
        config.WriteInt("/Spring/ParticleLimit", self.slider_mpSettings_detail_particleLimit.GetValue())
        config.WriteInt("/Spring/MaxSounds", self.slider_mpSettings_detail_maxSounds.GetValue())

        config.WriteBool("/Spring/Render3dTrees", self.checkbox_mpSettings_render_3DTrees.GetValue())
        config.WriteBool("/Spring/HighResClouds", self.checkbox_mpSettings_render_highResClouds.GetValue())
        config.WriteBool("/Spring/DynamicClouds", self.checkbox_mpSettings_render_dynamicClouds.GetValue())
        config.WriteBool("/Spring/ReflectiveWater", self.checkbox_mpSettings_render_reflectiveWater.GetValue())
        config.WriteBool("/Spring/FullScreen", self.checkbox_mpSettings_render_fullScreen.GetValue())
        config.WriteBool("/Spring/InvertMouse", self.checkbox_mpSettings_render_invertMouse.GetValue())
        config.WriteBool("/Spring/ColorizedElevationMap", self.checkbox_mpSettings_render_coloredElevation.GetValue())
        config.WriteBool("/Spring/EnableUnitShadows", self.checkbox_mpSettings_render_shadows.GetValue())

        if self.radiobox_mpSettings_render_shadowMaps.GetSelection() == 0:
            config.WriteInt("/Spring/ShadowMapSize", 1024)
        else:
            config.WriteInt("/Spring/ShadowMapSize", 2048)

        if self.radiobox_mpSettings_render_unitTextures.GetSelection() == 0:
            config.WriteInt("/Spring/TextureQuality", 1)
        elif self.radiobox_mpSettings_render_unitTextures.GetSelection() == 1:
            config.WriteInt("/Spring/TextureQuality", 2)
        elif self.radiobox_mpSettings_render_unitTextures.GetSelection() == 2:
            config.WriteInt("/Spring/TextureQuality", 3)
        elif self.radiobox_mpSettings_render_unitTextures.GetSelection() == 3:
            config.WriteInt("/Spring/TextureQuality", 4)

        if self.choice_mpSettings_basics_screenResData.GetSelection() == 0:
            config.WriteInt("/Spring/Resolution", 640)
        elif self.choice_mpSettings_basics_screenResData.GetSelection() == 1:
            config.WriteInt("/Spring/Resolution", 800)
        elif self.choice_mpSettings_basics_screenResData.GetSelection() == 2:
            config.WriteInt("/Spring/Resolution", 1024)
        elif self.choice_mpSettings_basics_screenResData.GetSelection() == 3:
            config.WriteInt("/Spring/Resolution", 1280)
        elif self.choice_mpSettings_basics_screenResData.GetSelection() == 4:
            config.WriteInt("/Spring/Resolution", 1600)

        config.Write("/Spring/LanName", self.text_mpSettings_basics_nameData.GetValue())

        # Write settings to file
        config.Flush()
# /end SaveConfig() ==============================================================================



  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================




    def __set_properties(self):
        # begin wxGlade: gui_mpSettings.__set_properties
        self.SetTitle("Spring - Game Settings")
        _icon = wx.EmptyIcon()

        #===============================================================================
        # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
        # /end edits ===================================================================

        self.SetIcon(_icon)
        self.slider_mpSettings_detail_treeViewDist.SetSize((225, 35))
        self.slider_mpSettings_detail_terrainDetail.SetSize((225, 35))
        self.slider_mpSettings_detail_unitDetailDist.SetSize((225, 35))
        self.slider_mpSettings_detail_grassDetail.SetSize((225, 35))
        self.slider_mpSettings_detail_particleLimit.SetSize((225, 35))
        self.slider_mpSettings_detail_maxSounds.SetSize((225, 35))
        self.checkbox_mpSettings_render_3DTrees.SetValue(1)
        self.checkbox_mpSettings_render_fullScreen.SetValue(1)
        self.radiobox_mpSettings_render_shadowMaps.SetSelection(0)
        self.radiobox_mpSettings_render_unitTextures.SetSelection(0)
        self.text_mpSettings_basics_nameData.SetSize((100, 25))
        self.choice_mpSettings_basics_screenResData.SetSize((165, 25))
        self.choice_mpSettings_basics_screenResData.SetSelection(1)
        self.button_mpSettings_basics_save.SetSize((65, 25))
        self.button_mpSettings_basics_cancel.SetSize((65, 25))
        self.button_mpSettings_basics_revertToDefaults.SetSize((65, 25))
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_mpSettings.__do_layout
        grid_mpSettings_main = wx.FlexGridSizer(3, 7, 0, 0)
        grid_mpSettings_basics = wx.FlexGridSizer(19, 1, 0, 0)
        sizer_4 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_mpSettings_basics_screenRes = wx.BoxSizer(wx.VERTICAL)
        sizer_mpSettings_basics_playerName = wx.BoxSizer(wx.HORIZONTAL)
        grid_mpSettings_render = wx.FlexGridSizer(19, 1, 0, 0)
        grid_mpSettings_detail = wx.FlexGridSizer(11, 1, 0, 0)
        sizer_mpSettings_detail_maxSounds = wx.BoxSizer(wx.VERTICAL)
        sizer_mpSettings_detail_particleLimit = wx.BoxSizer(wx.VERTICAL)
        sizer_mpSettings_detail_grassDetail = wx.BoxSizer(wx.VERTICAL)
        sizer_mpSettings_detail_unitDetailDist = wx.BoxSizer(wx.VERTICAL)
        sizer_mpSettings_detail_terrainDetail = wx.BoxSizer(wx.VERTICAL)
        sizer_mpSettings_detail_treeViewDist = wx.BoxSizer(wx.VERTICAL)
        grid_mpSettings_main.Add((10, 10), 0, 0, 0)
        grid_mpSettings_main.Add((150, 10), 0, 0, 0)
        grid_mpSettings_main.Add((15, 10), 0, 0, 0)
        grid_mpSettings_main.Add((150, 10), 0, 0, 0)
        grid_mpSettings_main.Add((15, 10), 0, 0, 0)
        grid_mpSettings_main.Add((150, 10), 0, 0, 0)
        grid_mpSettings_main.Add((10, 10), 0, 0, 0)
        grid_mpSettings_main.Add((10, 350), 0, 0, 1)
        sizer_mpSettings_detail_treeViewDist.Add(self.label_mpSettings_detail_treeViewDist, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_mpSettings_detail_treeViewDist.Add(self.slider_mpSettings_detail_treeViewDist, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_mpSettings_detail.Add(sizer_mpSettings_detail_treeViewDist, 1, wx.EXPAND, 0)
        grid_mpSettings_detail.Add((200, 15), 0, 0, 0)
        sizer_mpSettings_detail_terrainDetail.Add(self.label_mpSettings_detail_terrainDetail, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_mpSettings_detail_terrainDetail.Add(self.slider_mpSettings_detail_terrainDetail, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_mpSettings_detail.Add(sizer_mpSettings_detail_terrainDetail, 1, wx.EXPAND, 0)
        grid_mpSettings_detail.Add((200, 15), 0, 0, 0)
        sizer_mpSettings_detail_unitDetailDist.Add(self.label_mpSettings_detail_unitDetailDist, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_mpSettings_detail_unitDetailDist.Add(self.slider_mpSettings_detail_unitDetailDist, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_mpSettings_detail.Add(sizer_mpSettings_detail_unitDetailDist, 1, wx.EXPAND, 0)
        grid_mpSettings_detail.Add((200, 15), 0, 0, 0)
        sizer_mpSettings_detail_grassDetail.Add(self.label_mpSettings_detail_grassDetail, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_mpSettings_detail_grassDetail.Add(self.slider_mpSettings_detail_grassDetail, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_mpSettings_detail.Add(sizer_mpSettings_detail_grassDetail, 1, wx.EXPAND, 0)
        grid_mpSettings_detail.Add((200, 15), 0, 0, 0)
        sizer_mpSettings_detail_particleLimit.Add(self.label_mpSettings_detail_particleLimit, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_mpSettings_detail_particleLimit.Add(self.slider_mpSettings_detail_particleLimit, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_mpSettings_detail.Add(sizer_mpSettings_detail_particleLimit, 1, wx.EXPAND, 0)
        grid_mpSettings_detail.Add((200, 15), 0, 0, 0)
        sizer_mpSettings_detail_maxSounds.Add(self.label_mpSettings_detail_maxSounds, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_mpSettings_detail_maxSounds.Add(self.slider_mpSettings_detail_maxSounds, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_mpSettings_detail.Add(sizer_mpSettings_detail_maxSounds, 1, wx.EXPAND, 0)
        grid_mpSettings_main.Add(grid_mpSettings_detail, 1, wx.EXPAND, 0)
        grid_mpSettings_main.Add((15, 350), 0, 0, 1)
        grid_mpSettings_render.Add(self.checkbox_mpSettings_render_3DTrees, 0, 0, 0)
        grid_mpSettings_render.Add((200, 5), 0, 0, 0)
        grid_mpSettings_render.Add(self.checkbox_mpSettings_render_highResClouds, 0, 0, 0)
        grid_mpSettings_render.Add((200, 5), 0, 0, 0)
        grid_mpSettings_render.Add(self.checkbox_mpSettings_render_dynamicClouds, 0, 0, 0)
        grid_mpSettings_render.Add((200, 5), 0, 0, 0)
        grid_mpSettings_render.Add(self.checkbox_mpSettings_render_reflectiveWater, 0, 0, 0)
        grid_mpSettings_render.Add((200, 5), 0, 0, 0)
        grid_mpSettings_render.Add(self.checkbox_mpSettings_render_fullScreen, 0, 0, 0)
        grid_mpSettings_render.Add((200, 5), 0, 0, 0)
        grid_mpSettings_render.Add(self.checkbox_mpSettings_render_coloredElevation, 0, 0, 0)
        grid_mpSettings_render.Add((200, 5), 0, 0, 0)
        grid_mpSettings_render.Add(self.checkbox_mpSettings_render_invertMouse, 0, 0, 0)
        grid_mpSettings_render.Add((200, 5), 0, 0, 0)
        grid_mpSettings_render.Add(self.checkbox_mpSettings_render_shadows, 0, 0, 0)
        grid_mpSettings_render.Add((200, 15), 0, 0, 0)
        grid_mpSettings_render.Add(self.radiobox_mpSettings_render_shadowMaps, 0, 0, 0)
        grid_mpSettings_render.Add((200, 15), 0, 0, 0)
        grid_mpSettings_render.Add(self.radiobox_mpSettings_render_unitTextures, 0, 0, 0)
        grid_mpSettings_main.Add(grid_mpSettings_render, 1, wx.EXPAND, 0)
        grid_mpSettings_main.Add((15, 350), 0, 0, 1)
        sizer_mpSettings_basics_playerName.Add(self.label_mpSettings_basics_playerName, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_mpSettings_basics_playerName.Add((20, 20), 0, 0, 0)
        sizer_mpSettings_basics_playerName.Add(self.text_mpSettings_basics_nameData, 0, 0, 0)
        grid_mpSettings_basics.Add(sizer_mpSettings_basics_playerName, 1, wx.EXPAND, 0)
        grid_mpSettings_basics.Add((200, 20), 0, 0, 0)
        sizer_mpSettings_basics_screenRes.Add(self.label_mpSettings_basics_screenRes, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_mpSettings_basics_screenRes.Add(self.choice_mpSettings_basics_screenResData, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_mpSettings_basics.Add(sizer_mpSettings_basics_screenRes, 1, wx.EXPAND, 0)
        grid_mpSettings_basics.Add((200, 5), 0, 0, 0)
        grid_mpSettings_basics.Add((200, 280), 0, 0, 0)
        sizer_4.Add(self.button_mpSettings_basics_save, 0, 0, 0)
        sizer_4.Add(self.button_mpSettings_basics_cancel, 0, 0, 0)
        sizer_4.Add(self.button_mpSettings_basics_revertToDefaults, 0, 0, 0)
        grid_mpSettings_basics.Add(sizer_4, 1, wx.EXPAND, 0)
        grid_mpSettings_main.Add(grid_mpSettings_basics, 1, wx.EXPAND, 0)
        grid_mpSettings_main.Add((10, 350), 0, 0, 1)
        grid_mpSettings_main.Add((10, 10), 0, 0, 0)
        grid_mpSettings_main.Add((150, 10), 0, 0, 0)
        grid_mpSettings_main.Add((15, 10), 0, 0, 0)
        grid_mpSettings_main.Add((150, 10), 0, 0, 0)
        grid_mpSettings_main.Add((10, 10), 0, 0, 0)
        grid_mpSettings_main.Add((150, 10), 0, 0, 0)
        grid_mpSettings_main.Add((10, 10), 0, 0, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_mpSettings_main)
        grid_mpSettings_main.Fit(self)
        grid_mpSettings_main.SetSizeHints(self)
        self.Layout()
        self.Centre()
        # end wxGlade

# end of class gui_mpSettings


