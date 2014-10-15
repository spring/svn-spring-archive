# -*- coding: UTF-8 -*-

#======================================================
 #            gui_clSettings.py
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

class gui_clSettings(wx.Frame):

    color_channel_text = wx.Colour()
    color_user_text = wx.Colour()
    color_private_text = wx.Colour()
    color_server_text = wx.Colour()
    color_debug_text = wx.Colour()
    
    
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_clSettings.__init__
        kwds["style"] = wx.CAPTION|wx.CLOSE_BOX|wx.MINIMIZE_BOX|wx.SYSTEM_MENU
        wx.Frame.__init__(self, *args, **kwds)
        self.notebook_clSettings_main = wx.Notebook(self, -1, style=0)
        self.notebook_clSettings_advanced = wx.Panel(self.notebook_clSettings_main, -1)
        self.notebook_clSettings_options = wx.Panel(self.notebook_clSettings_main, -1)
        self.notebook_clSettings_interface = wx.Panel(self.notebook_clSettings_main, -1)
        self.label_clsettings_colorPrefs = wx.StaticText(self.notebook_clSettings_interface, -1, "Color Preferences")
        self.label_clSettings_interface_firstColor = wx.StaticText(self.notebook_clSettings_interface, -1, "1st Color Pick:")
        self.button_clSettings_interface_firstColor = wx.Button(self.notebook_clSettings_interface, 103, "None")
        self.label_clSettings_interface_secondColor = wx.StaticText(self.notebook_clSettings_interface, -1, "2nd Color Pick:")
        self.button_clSettings_interface_secondColor = wx.Button(self.notebook_clSettings_interface, 104, "None")
        self.label_clSettings_interface_thirdColor = wx.StaticText(self.notebook_clSettings_interface, -1, "3rd Color Pick:")
        self.button_clSettings_interface_thirdColor = wx.Button(self.notebook_clSettings_interface, 105, "None")
        self.label_clSettings_textColors = wx.StaticText(self.notebook_clSettings_interface, -1, "Text Colors")
        self.label_clSettings_interface_channelText = wx.StaticText(self.notebook_clSettings_interface, -1, "Channel Messages")
        self.button_clSettings_interface_channelText = wx.Button(self.notebook_clSettings_interface, 106, "Default")
        self.label_clSettings_interface_userText = wx.StaticText(self.notebook_clSettings_interface, -1, "User Messages")
        self.button_clSettings_interface_userText = wx.Button(self.notebook_clSettings_interface, 107, "Default")
        self.label_clSettings_interface_privateText = wx.StaticText(self.notebook_clSettings_interface, -1, "Private Messages")
        self.button_clSettings_interface_privateText = wx.Button(self.notebook_clSettings_interface, 108, "Default")
        self.label_clSettings_interface_serverText = wx.StaticText(self.notebook_clSettings_interface, -1, "Server Messages")
        self.button_clSettings_interface_serverText = wx.Button(self.notebook_clSettings_interface, 109, "Default")
        self.label_clSettings_interface_debugText = wx.StaticText(self.notebook_clSettings_interface, -1, "Debug Messages")
        self.button_clSettings_interface_debugText = wx.Button(self.notebook_clSettings_interface, 110, "Default")
        self.checkbox_clSettings_options_customIcon = wx.CheckBox(self.notebook_clSettings_options, 301, "Custom player icon")
        self.text_clSettings_options_customIconPath = wx.TextCtrl(self.notebook_clSettings_options, -1, "")
        self.button_clSettings_options_findCustomIconPath = wx.Button(self.notebook_clSettings_options, -1, "...")
        self.text_clSettings_options_customIconRules = wx.TextCtrl(self.notebook_clSettings_options, -1, "Max Size: 24x24\nMax Size on Disk: 10 kb\nFormats Supported: \npng gif jpg bmp xpm", style=wx.TE_MULTILINE|wx.TE_READONLY)
        self.checkbox_clSettings_options_showCustomIcons = wx.CheckBox(self.notebook_clSettings_options, 302, "")
        self.label_clSettings_options_showCustomIcons = wx.StaticText(self.notebook_clSettings_options, -1, "Download custom icons from the server")
        self.checkbox_clSettings_options_createLanTab = wx.CheckBox(self.notebook_clSettings_options, 303, "")
        self.label_clSettings_options_createLanTab = wx.StaticText(self.notebook_clSettings_options, -1, "Create LAN tab at startup")
        self.label_clSettings_options_defaultFaction = wx.StaticText(self.notebook_clSettings_options, -1, "Default Faction")
        self.choice_clSettings_options_defaultFactionData = wx.Choice(self.notebook_clSettings_options, -1, choices=["Random", "Arm", "Core"])
        self.notebook_1_pane_2_copy = wx.Panel(self.notebook_clSettings_options, -1)
        self.checkbox_clSettings_advanced_rememberAll = wx.CheckBox(self.notebook_clSettings_advanced, 304, "")
        self.label_clSettings_advanced_rememberAll = wx.StaticText(self.notebook_clSettings_advanced, -1, "Remember all choices and settings")
        self.checkbox_clSettings_advanced_blockPrivate = wx.CheckBox(self.notebook_clSettings_advanced, 305, "")
        self.label_clSettings_advanced_blockPrivate = wx.StaticText(self.notebook_clSettings_advanced, -1, "Block incoming private messages")
        self.checkbox_clSettings_advanced_showDebug = wx.CheckBox(self.notebook_clSettings_advanced, 306, "")
        self.label_clSettings_advanced_showDebug = wx.StaticText(self.notebook_clSettings_advanced, -1, "Show all debugging messages")
        self.checkbox_clSettings_advanced_donateBandwidth = wx.CheckBox(self.notebook_clSettings_advanced, 307, "")
        self.label_clSettings_advanced_donateBandwidth = wx.StaticText(self.notebook_clSettings_advanced, -1, "Donate bandwidth if available")
        self.label_clSettings_advanced_maxUpload = wx.StaticText(self.notebook_clSettings_advanced, -1, "Max Upload Speed")
        self.combo_clSettings_advanced_maxUpload = wx.ComboBox(self.notebook_clSettings_advanced, -1, choices=["5", "10", "12", "15", "20", "25", "30", "40", "50"], style=wx.CB_DROPDOWN)
        self.label_kilobytes_copy = wx.StaticText(self.notebook_clSettings_advanced, -1, "KB/s")
        self.label_clSettings_advanced_bitPort = wx.StaticText(self.notebook_clSettings_advanced, -1, "Port")
        self.text_clSettings_advanced_bitPortData = wx.TextCtrl(self.notebook_clSettings_advanced, -1, "8452")
        self.checkbox_clSettings_advanced_ipConfig = wx.CheckBox(self.notebook_clSettings_advanced, 308, "")
        self.label_clSettings_advanced_ipConfig = wx.StaticText(self.notebook_clSettings_advanced, -1, "Bind sockets to a different IP")
        self.text_clSettings_advanced_ipUsedData = wx.TextCtrl(self.notebook_clSettings_advanced, -1, "192.168.0.111", style=wx.TE_PROCESS_TAB)
        self.button_clSettings_main_save = wx.Button(self, 101, "Save Settings")
        self.button_clSettings_main_revertToDefaults = wx.Button(self, 102, "Revert to Defaults")
        self.button_clSettings_main_done = wx.Button(self, -1, "Done")

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
    	
    	wx.EVT_BUTTON(self, self.button_clSettings_main_save.GetId(), self.OnSaveSettings)
    	wx.EVT_BUTTON(self, self.button_clSettings_main_done.GetId(), self.OnClose)
    	wx.EVT_BUTTON(self, self.button_clSettings_main_revertToDefaults.GetId(), self.OnDefaults)
    	
    	wx.EVT_BUTTON(self, self.button_clSettings_interface_channelText.GetId(), self.OnChannelText)   
    	wx.EVT_BUTTON(self, self.button_clSettings_interface_userText.GetId(), self.OnUserText)   
    	wx.EVT_BUTTON(self, self.button_clSettings_interface_privateText.GetId(), self.OnPrivateText)
    	wx.EVT_BUTTON(self, self.button_clSettings_interface_serverText.GetId(), self.OnServerText)
    	wx.EVT_BUTTON(self, self.button_clSettings_interface_debugText.GetId(), self.OnDebugText)
        
    	wx.EVT_CHECKBOX(self, self.checkbox_clSettings_options_customIcon.GetId(), self.OnEnableCustom)
    	wx.EVT_CHECKBOX(self, self.checkbox_clSettings_advanced_donateBandwidth.GetId(), self.OnEnableBWDonation)
    	wx.EVT_CHECKBOX(self, self.checkbox_clSettings_advanced_ipConfig.GetId(), self.OnEnableIpConfig)
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





# OnSaveSettings() =================================================================================
# ==================================================================================================
#  This function is triggered when the user choses to
#  save the settings he changed.

    def OnSaveSettings(self, event):
        self.SaveConfig()
    	self.Close(True)
# /end OnSaveSettings() ============================================================================






# OnChannelText() ==================================================================================
# ==================================================================================================
#  When a user hits the button to change the color of
#  text sent from other users to the public chat channel.

    def OnChannelText(self, event):
        config = wx.Config.Get()
        
        newcolor = misc.CreateColorPicker(self,wx.Colour(config.ReadInt("/ChannelText/Red"), config.ReadInt("/ChannelText/Green"), config.ReadInt("/ChannelText/Blue")))
        
        if not newcolor == wx.NullColour:
            self.color_channel_text = newcolor
            self.button_clSettings_interface_channelText.SetForegroundColour(newcolor)
# /end OnChannelText() =============================================================================







# OnUserText() =====================================================================================
# ==================================================================================================
#  When a user hits the button to change the color of
#  text sent to the public chat channel by yourself.

    def OnUserText(self, event):
        config = wx.Config.Get()
        
        newcolor = misc.CreateColorPicker(self,wx.Colour(config.ReadInt("/UserText/Red"), config.ReadInt("/UserText/Green"), config.ReadInt("/UserText/Blue")))
        
        if not newcolor == wx.NullColour:
            self.color_user_text = newcolor
            self.button_clSettings_interface_userText.SetForegroundColour(newcolor)
# /end OnUserText() ================================================================================





# OnServerText() ===================================================================================
# ==================================================================================================
#  When a user hits the button to change the color of
#  text sent from the server directly.

    def OnServerText(self, event):
        config = wx.Config.Get()
        
        newcolor = misc.CreateColorPicker(self,wx.Colour(config.ReadInt("/ServerText/Red"), config.ReadInt("/ServerText/Green"), config.ReadInt("/ServerText/Blue")))
        
        if not newcolor == wx.NullColour:
            self.color_server_text = newcolor
            self.button_clSettings_interface_serverText.SetForegroundColour(newcolor)
# /end OnServerText() ==============================================================================






# OnPrivateText() ==================================================================================
# ==================================================================================================
#  When a user hits the button to change the color of
#  text sent privately.

    def OnPrivateText(self, event):
        config = wx.Config.Get()
        
        newcolor = misc.CreateColorPicker(self,wx.Colour(config.ReadInt("/PrivateText/Red"), config.ReadInt("/PrivateText/Green"), config.ReadInt("/PrivateText/Blue")))
        
        if not newcolor == wx.NullColour:
            self.color_private_text = newcolor
            self.button_clSettings_interface_privateText.SetForegroundColour(newcolor)
# /end OnPrivateText() =============================================================================







# OnDebugText() ====================================================================================
# ==================================================================================================
#  When a user hits the button to change the color of
#  text that is sent to the window, but is used for debugging.

    def OnDebugText(self, event):
        config = wx.Config.Get()
        
        newcolor = misc.CreateColorPicker(self,wx.Colour(config.ReadInt("/DebugText/Red"), config.ReadInt("/DebugText/Green"), config.ReadInt("/DebugText/Blue")))
        
        if not newcolor == wx.NullColour:
            self.color_debug_text = newcolor
            self.button_clSettings_interface_debugText.SetForegroundColour(newcolor)
# /end OnDebugText() ===============================================================================






# OnDefaults() =====================================================================================
# ==================================================================================================
#  This function is triggered when the user choses to
#  revert to the default settings.

    def OnDefaults(self, event):
        # Reset everything to the defaults

        self.button_clSettings_interface_firstColor.SetLabel("None")
        self.button_clSettings_interface_firstColor.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))

        self.button_clSettings_interface_secondColor.SetLabel("None")
        self.button_clSettings_interface_secondColor.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))

        self.button_clSettings_interface_thirdColor.SetLabel("None")
        self.button_clSettings_interface_thirdColor.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))

        self.button_clSettings_interface_channelText.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.color_channel_text = wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT)
        
        self.button_clSettings_interface_userText.SetForegroundColour(wx.Colour(COLOR_USER_RED, COLOR_USER_GREEN, COLOR_USER_BLUE))
        self.color_user_text = wx.Colour(COLOR_USER_RED, COLOR_USER_GREEN, COLOR_USER_BLUE)
        
        self.button_clSettings_interface_privateText.SetForegroundColour(wx.Colour(COLOR_PRIVATE_RED, COLOR_PRIVATE_GREEN, COLOR_PRIVATE_BLUE))
        self.color_private_text = wx.Colour(COLOR_PRIVATE_RED, COLOR_PRIVATE_GREEN, COLOR_PRIVATE_BLUE)
        
        self.button_clSettings_interface_serverText.SetForegroundColour(wx.Colour(COLOR_SERVER_RED, COLOR_SERVER_GREEN, COLOR_SERVER_BLUE))
        self.color_server_text = wx.Colour(COLOR_SERVER_RED, COLOR_SERVER_GREEN, COLOR_SERVER_BLUE)
        
        self.button_clSettings_interface_debugText.SetForegroundColour(wx.Colour(COLOR_DEBUG_RED, COLOR_DEBUG_GREEN, COLOR_DEBUG_BLUE))
        self.color_debug_text = wx.Colour(COLOR_DEBUG_RED, COLOR_DEBUG_GREEN, COLOR_DEBUG_BLUE)

        # Options tab
        self.checkbox_clSettings_options_customIcon.SetValue(DEFAULT_CUSTOMICON)
        self.text_clSettings_options_customIconPath.SetValue("")
        self.OnEnableCustom()

        self.checkbox_clSettings_options_showCustomIcons.SetValue(DEFAULT_SHOWCUSTOM)
        self.checkbox_clSettings_options_createLanTab.SetValue(DEFAULT_CREATELANTAB)
        self.choice_clSettings_options_defaultFactionData.SetSelection(DEFAULT_FACTION)

        #Advanced tab
        self.checkbox_clSettings_advanced_rememberAll.SetValue(DEFAULT_REMEMBERALL)
        self.checkbox_clSettings_advanced_blockPrivate.SetValue(DEFAULT_BLOCKPRIVATE)
        self.checkbox_clSettings_advanced_ipConfig.SetValue(0)
        self.text_clSettings_advanced_ipUsedData.SetValue(DEFAULT_ALTERNATEIP)
        self.OnEnableIpConfig()

        self.checkbox_clSettings_advanced_showDebug.SetValue(DEFAULT_SHOWDEBUG)
        self.checkbox_clSettings_advanced_donateBandwidth.SetValue(DEFAULT_DONATEBANDWIDTH)
        self.OnEnableBWDonation()

        self.combo_clSettings_advanced_maxUpload.SetSelection(DEFAULT_MAXUPLOAD)

        self.text_clSettings_advanced_bitPortData.SetValue(str(DEFAULT_BITPORT))
# /end OnDefaults() ================================================================================




# OnEnableCustom() =================================================================================
# ==================================================================================================
#  This function is triggered when the user choses to
#  enable/disable custom icons.  This enables/disables
#  other controls in the "options" tab.
# ==================================================================================================
    def OnEnableCustom(self, event=None):
        if self.checkbox_clSettings_options_customIcon.IsChecked():
            self.text_clSettings_options_customIconPath.Enable(True)
            self.button_clSettings_options_findCustomIconPath.Enable(True)
        else:
            self.text_clSettings_options_customIconPath.Enable(False)
            self.button_clSettings_options_findCustomIconPath.Enable(False)
# /end OnEnableCustom() ============================================================================


# OnEnableBWDonation() =============================================================================
# ==================================================================================================
#  This function is triggered when the user choses to
#  enable/disable bandwidth donation.  This enables/disables
#  other controls in the "advanced" tab.
# ==================================================================================================
    def OnEnableBWDonation(self, event=None):
        # The checkbox that enables the user to share his bandwidth with others
        if self.checkbox_clSettings_advanced_donateBandwidth.IsChecked():
            self.label_clSettings_advanced_donateBandwidth.Enable(True)
            self.label_clSettings_advanced_maxUpload.Enable(True)
            self.combo_clSettings_advanced_maxUpload.Enable(True)
            self.label_kilobytes_copy.Enable(True)
            self.label_clSettings_advanced_bitPort.Enable(True)
            self.text_clSettings_advanced_bitPortData.Enable(True)
        else:
            self.label_clSettings_advanced_donateBandwidth.Enable(False)
            self.label_clSettings_advanced_maxUpload.Enable(False)
            self.combo_clSettings_advanced_maxUpload.Enable(False)
            self.label_kilobytes_copy.Enable(False)
            self.label_clSettings_advanced_bitPort.Enable(False)
            self.text_clSettings_advanced_bitPortData.Enable(False)
# /end OnEnableBWDonation() =========================================================================




# OnEnableIpConfig() ===============================================================================
# ==================================================================================================
#  This function is triggered when the user choses to
#  enter custom ip configuration data.  This enables/disables
#  other controls in the "advanced" tab.
# ==================================================================================================
    def OnEnableIpConfig(self, event=None):
        # The checkbox that enables the user to change his binding IP
        if self.checkbox_clSettings_advanced_ipConfig.IsChecked():
            self.label_clSettings_advanced_ipConfig.Enable(True)
            self.text_clSettings_advanced_ipUsedData.Enable(True)
        else:
            self.label_clSettings_advanced_ipConfig.Enable(False)
            self.text_clSettings_advanced_ipUsedData.Enable(False)
# /end OnEnableIpConfig() ===========================================================================




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
        
        config = wx.Config.Get()
        
        if config.ReadBool("/ChannelText/Default"):
            self.color_channel_text = wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT)
        else:
            self.color_channel_text = wx.Colour(config.ReadInt("/ChannelText/Red"), config.ReadInt("/ChannelText/Green"), config.ReadInt("/ChannelText/Blue"))

        self.color_user_text = wx.Colour(config.ReadInt("/UserText/Red"), config.ReadInt("/UserText/Green"), config.ReadInt("/UserText/Blue"))
        self.color_private_text = wx.Colour(config.ReadInt("/PrivateText/Red"), config.ReadInt("/PrivateText/Green"), config.ReadInt("/PrivateText/Blue"))
        self.color_server_text = wx.Colour(config.ReadInt("/ServerText/Red"), config.ReadInt("/ServerText/Green"), config.ReadInt("/ServerText/Blue"))
        self.color_debug_text = wx.Colour(config.ReadInt("/DebugText/Red"), config.ReadInt("/DebugText/Green"), config.ReadInt("/DebugText/Blue"))

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

        # Interface tab
        if config.ReadBool("/FirstChoice/None") == False:
            self.button_clSettings_interface_firstColor.SetForegroundColour(wx.Colour(config.ReadInt("/FirstChoice/Red"), config.ReadInt("/FirstChoice/Green"), config.ReadInt("/FirstChoice/Blue")))
            self.button_clSettings_interface_firstColor.SetLabel("Ready")

        if config.ReadBool("/SecondChoice/None") == False:
            self.button_clSettings_interface_secondColor.SetForegroundColour(wx.Colour(config.ReadInt("/SecondChoice/Red"), config.ReadInt("/SecondChoice/Green"), config.ReadInt("/SecondChoice/Blue")))
            self.button_clSettings_interface_secondColor.SetLabel("Ready")

        if config.ReadBool("/ThirdChoice/None") == False:
            self.button_clSettings_interface_thirdColor.SetForegroundColour(wx.Colour(config.ReadInt("/ThirdChoice/Red"), config.ReadInt("/ThirdChoice/Green"), config.ReadInt("/ThirdChoice/Blue")))
            self.button_clSettings_interface_thirdColor.SetLabel("Ready")

        self.button_clSettings_interface_channelText.SetForegroundColour(wx.Colour(config.ReadInt("/ChannelText/Red"), config.ReadInt("/ChannelText/Green"), config.ReadInt("/ChannelText/Blue")))
        self.button_clSettings_interface_userText.SetForegroundColour(wx.Colour(config.ReadInt("/UserText/Red"), config.ReadInt("/UserText/Green"), config.ReadInt("/UserText/Blue")))
        self.button_clSettings_interface_privateText.SetForegroundColour(wx.Colour(config.ReadInt("/PrivateText/Red"), config.ReadInt("/PrivateText/Green"), config.ReadInt("/PrivateText/Blue")))
        self.button_clSettings_interface_serverText.SetForegroundColour(wx.Colour(config.ReadInt("/ServerText/Red"), config.ReadInt("/ServerText/Green"), config.ReadInt("/ServerText/Blue")))
        self.button_clSettings_interface_debugText.SetForegroundColour(wx.Colour(config.ReadInt("/DebugText/Red"), config.ReadInt("/DebugText/Green"), config.ReadInt("/DebugText/Blue")))

        # Options tab
        self.checkbox_clSettings_options_customIcon.SetValue(config.ReadBool("/Player/CustomIcon"))
        self.text_clSettings_options_customIconPath.SetValue(config.Read("/Player/CustomIconPath"))
        self.checkbox_clSettings_options_showCustomIcons.SetValue(config.ReadBool("/Player/DownloadCustom"))
        self.checkbox_clSettings_options_createLanTab.SetValue(config.ReadBool("/Player/CreateLanTab"))
        self.choice_clSettings_options_defaultFactionData.SetSelection(config.ReadInt("/Player/DefaultFaction"))

        #Advanced tab
        self.checkbox_clSettings_advanced_rememberAll.SetValue(config.ReadBool("/Global/RememberEverything"))
        self.checkbox_clSettings_advanced_blockPrivate.SetValue(config.ReadBool("/Player/BlockPrivate"))
        self.text_clSettings_advanced_ipUsedData.SetValue(config.Read("/Player/AlternateIp"))
        self.checkbox_clSettings_advanced_showDebug.SetValue(config.ReadBool("/Global/ShowDebug"))
        self.checkbox_clSettings_advanced_donateBandwidth.SetValue(config.ReadBool("/Player/DonateBandwidth"))

        if config.ReadInt("/Player/DonateMaxUpload") == 5:
            self.combo_clSettings_advanced_maxUpload.SetSelection(0)
        elif config.ReadInt("/Player/DonateMaxUpload") == 10:
            self.combo_clSettings_advanced_maxUpload.SetSelection(1)
        elif config.ReadInt("/Player/DonateMaxUpload") == 12:
            self.combo_clSettings_advanced_maxUpload.SetSelection(2)
        elif config.ReadInt("/Player/DonateMaxUpload") == 15:
            self.combo_clSettings_advanced_maxUpload.SetSelection(3)
        elif config.ReadInt("/Player/DonateMaxUpload") == 20:
            self.combo_clSettings_advanced_maxUpload.SetSelection(4)
        elif config.ReadInt("/Player/DonateMaxUpload") == 25:
            self.combo_clSettings_advanced_maxUpload.SetSelection(5)
        elif config.ReadInt("/Player/DonateMaxUpload") == 30:
            self.combo_clSettings_advanced_maxUpload.SetSelection(6)
        elif config.ReadInt("/Player/DonateMaxUpload") == 40:
            self.combo_clSettings_advanced_maxUpload.SetSelection(7)
        elif config.ReadInt("/Player/DonateMaxUpload") == 50:
            self.combo_clSettings_advanced_maxUpload.SetSelection(8)
        else:
            self.combo_clSettings_advanced_maxUpload.SetSelection(1)

        self.text_clSettings_advanced_bitPortData.SetValue(str(config.ReadInt("/Player/DonateBitPort")))
# /end InitConfig() ================================================================================




# SaveConfig() =====================================================================================
# ==================================================================================================
#  This function saves the configuration settings that
#  need to be saved.  This is usually called when the
#  window is being destroyed.
# ==================================================================================================
    def SaveConfig(self):   
        config = wx.Config.Get()

        # Interface tab
        if config.ReadBool("/FirstChoice/None") == False:
            config.WriteInt("/FirstChoice/Red", self.button_clSettings_interface_firstColor.GetForegroundColour().Red())
            config.WriteInt("/FirstChoice/Green", self.button_clSettings_interface_firstColor.GetForegroundColour().Green())
            config.WriteInt("/FirstChoice/Blue", self.button_clSettings_interface_firstColor.GetForegroundColour().Blue())

        if config.ReadBool("/SecondChoice/None") == False:
            config.WriteInt("/SecondChoice/Red", self.button_clSettings_interface_secondColor.GetForegroundColour().Red())
            config.WriteInt("/SecondChoice/Green", self.button_clSettings_interface_secondColor.GetForegroundColour().Green())
            config.WriteInt("/SecondChoice/Blue", self.button_clSettings_interface_secondColor.GetForegroundColour().Blue())

        if config.ReadBool("/ThirdChoice/None") == False:
            config.WriteInt("/ThirdChoice/Red", self.button_clSettings_interface_thirdColor.GetForegroundColour().Red())
            config.WriteInt("/ThirdChoice/Green", self.button_clSettings_interface_thirdColor.GetForegroundColour().Green())
            config.WriteInt("/ThirdChoice/Blue", self.button_clSettings_interface_thirdColor.GetForegroundColour().Blue())

        # Channel Text
        if not wx.Colour(config.ReadInt("/ChannelText/Red"), config.ReadInt("/ChannelText/Green"), config.ReadInt("/ChannelText/Blue")) is self.color_channel_text:
            config.WriteInt("/ChannelText/Red", self.color_channel_text.Red())
            config.WriteInt("/ChannelText/Green", self.color_channel_text.Green())
            config.WriteInt("/ChannelText/Blue", self.color_channel_text.Blue())

        # User Text
        config.WriteInt("/UserText/Red", self.color_user_text.Red())
        config.WriteInt("/UserText/Green", self.color_user_text.Green())
        config.WriteInt("/UserText/Blue", self.color_user_text.Blue())

        # Private Text
        config.WriteInt("/PrivateText/Red", self.color_private_text.Red())
        config.WriteInt("/PrivateText/Green", self.color_private_text.Green())
        config.WriteInt("/PrivateText/Blue", self.color_private_text.Blue())

        # Server Text
        config.WriteInt("/ServerText/Red", self.color_server_text.Red())
        config.WriteInt("/ServerText/Green", self.color_server_text.Green())
        config.WriteInt("/ServerText/Blue", self.color_server_text.Blue())

        # Debug Text
        config.WriteInt("/DebugText/Red", self.color_debug_text.Red())
        config.WriteInt("/DebugText/Green", self.color_debug_text.Green())
        config.WriteInt("/DebugText/Blue", self.color_debug_text.Blue())

        # Options tab
        config.WriteBool("/Player/CustomIcon", self.checkbox_clSettings_options_customIcon.GetValue())
        config.Write("/Player/CustomIconPath", self.text_clSettings_options_customIconPath.GetValue())
        config.WriteBool("/Player/DownloadCustom", self.checkbox_clSettings_options_showCustomIcons.GetValue())
        config.WriteBool("/Player/CreateLanTab", self.checkbox_clSettings_options_createLanTab.GetValue())
        config.WriteInt("/Player/DefaultFaction", self.choice_clSettings_options_defaultFactionData.GetSelection())

        #Advanced tab
        config.WriteBool("/Global/RememberEverything", self.checkbox_clSettings_advanced_rememberAll.GetValue())
        config.WriteBool("/Player/BlockPrivate", self.checkbox_clSettings_advanced_blockPrivate.GetValue())
        config.Write("/Player/AlternateIp", self.text_clSettings_advanced_ipUsedData.GetValue())
        config.WriteBool("/Global/ShowDebug", self.checkbox_clSettings_advanced_showDebug.GetValue())
        config.WriteBool("/Player/DonateBandwidth", self.checkbox_clSettings_advanced_donateBandwidth.GetValue())

        if self.combo_clSettings_advanced_maxUpload.GetSelection() == 0:
            config.WriteInt("/Player/DonateMaxUpload", 5)
        elif self.combo_clSettings_advanced_maxUpload.GetSelection() == 1:
            config.WriteInt("/Player/DonateMaxUpload", 10)
        elif self.combo_clSettings_advanced_maxUpload.GetSelection() == 2:
            config.WriteInt("/Player/DonateMaxUpload", 12)
        elif self.combo_clSettings_advanced_maxUpload.GetSelection() == 3:
            config.WriteInt("/Player/DonateMaxUpload", 15)
        elif self.combo_clSettings_advanced_maxUpload.GetSelection() == 4:
            config.WriteInt("/Player/DonateMaxUpload", 20)
        elif self.combo_clSettings_advanced_maxUpload.GetSelection() == 5:
            config.WriteInt("/Player/DonateMaxUpload", 25)
        elif self.combo_clSettings_advanced_maxUpload.GetSelection() == 6:
            config.WriteInt("/Player/DonateMaxUpload", 30)
        elif self.combo_clSettings_advanced_maxUpload.GetSelection() == 7:
            config.WriteInt("/Player/DonateMaxUpload", 40)
        elif self.combo_clSettings_advanced_maxUpload.GetSelection() == 8:
            config.WriteInt("/Player/DonateMaxUpload", 50)

        config.WriteInt("/Player/DonateBitPort", int(self.text_clSettings_advanced_bitPortData.GetValue()))

        config.Flush()
        self.GetParent().UpdateColors()
# /end SaveConfig() ==============================================================================




  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================



    def __set_properties(self):
        # begin wxGlade: gui_clSettings.__set_properties
        self.SetTitle("Spring - Client Settings")
        _icon = wx.EmptyIcon()

        #===============================================================================
        # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
           _icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
        # /end edits ===================================================================

        self.SetIcon(_icon)
    	self.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BTNFACE))
        self.label_clsettings_colorPrefs.SetFont(wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.BOLD, 0, ""))
        self.button_clSettings_interface_firstColor.SetToolTipString("When you join a battle, the game will request this color be used for you.  If it is already in use, the game will request your 2nd color pick from the server.")
        self.button_clSettings_interface_secondColor.SetToolTipString("If your 1st color pick is already taken, the client will request that the server grant you rights to use this color.  If this color is also in use, the client will request your 3rd color pick to be used.")
        self.button_clSettings_interface_thirdColor.SetToolTipString("Your final color pick will only be utilized if your 1st and 2nd picks are taken.  In the event that the 3rd pick is also taken, the client will randomly assign you one of the remaining colors.")
        self.label_clSettings_textColors.SetFont(wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.BOLD, 0, ""))
        self.button_clSettings_interface_channelText.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.button_clSettings_interface_channelText.SetToolTipString("When someone other than yourself sends a message to the channel, it will appear in this color.")
        self.button_clSettings_interface_userText.SetForegroundColour(wx.Colour(47, 47, 47))
        self.button_clSettings_interface_userText.SetToolTipString("When you send a message to a chatroom, it will appear in this color.")
        self.button_clSettings_interface_privateText.SetForegroundColour(wx.Colour(35, 142, 35))
        self.button_clSettings_interface_privateText.SetToolTipString("Messages sent to individuals from anywhere on the server are projected in this color.")
        self.button_clSettings_interface_serverText.SetForegroundColour(wx.Colour(128, 18, 18))
        self.button_clSettings_interface_serverText.SetToolTipString("Messages from the server will be in this color.")
        self.button_clSettings_interface_debugText.SetForegroundColour(wx.Colour(0, 0, 109))
        self.button_clSettings_interface_debugText.SetToolTipString("Messages to aid in debugging the Spring Client will be in this color.")
        self.checkbox_clSettings_options_customIcon.Enable(False)
        self.text_clSettings_options_customIconPath.SetSize((200, 25))
        self.text_clSettings_options_customIconPath.Enable(False)
        self.button_clSettings_options_findCustomIconPath.SetSize((40, 25))
        self.button_clSettings_options_findCustomIconPath.Enable(False)
        self.text_clSettings_options_customIconRules.SetSize((265, 100))
        self.text_clSettings_options_customIconRules.Enable(False)
        self.checkbox_clSettings_options_showCustomIcons.SetValue(1)
        self.checkbox_clSettings_options_createLanTab.SetValue(1)
        self.label_clSettings_options_defaultFaction.SetSize((120, 17))
        self.choice_clSettings_options_defaultFactionData.SetSelection(0)
        self.checkbox_clSettings_advanced_rememberAll.SetValue(1)
        self.checkbox_clSettings_advanced_donateBandwidth.Enable(False)
        self.label_clSettings_advanced_donateBandwidth.Enable(False)
        self.label_clSettings_advanced_maxUpload.Enable(False)
        self.combo_clSettings_advanced_maxUpload.SetSize((100, 25))
        self.combo_clSettings_advanced_maxUpload.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_clSettings_advanced_maxUpload.Enable(False)
        self.combo_clSettings_advanced_maxUpload.SetSelection(1)
        self.label_kilobytes_copy.Enable(False)
        self.label_clSettings_advanced_bitPort.Enable(False)
        self.text_clSettings_advanced_bitPortData.SetSize((100, 25))
        self.text_clSettings_advanced_bitPortData.Enable(False)
        self.text_clSettings_advanced_ipUsedData.SetSize((150, 25))
        self.text_clSettings_advanced_ipUsedData.Enable(False)
        self.button_clSettings_main_save.SetDefault()
        # end wxGlade



    def __do_layout(self):
        # begin wxGlade: gui_clSettings.__do_layout
        grid_clsettings_main = wx.FlexGridSizer(3, 3, 0, 0)
        sizer_clSettings_main = wx.BoxSizer(wx.HORIZONTAL)
        grid_sizer_3_copy_1 = wx.FlexGridSizer(13, 1, 0, 0)
        sizer_clSettings_advanced_ipUsed = wx.FlexGridSizer(1, 2, 0, 0)
        sizer_clSettings_advanced_ipConfig = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_advanced_bitPort_notNeeded = wx.FlexGridSizer(1, 1, 0, 0)
        sizer_clSettings_advanced_bitPort = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_advanced_maxUpload = wx.FlexGridSizer(1, 5, 0, 0)
        sizer_clSettings_advanced_donateBandwidth = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_advanced_showDebug = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_advanced_blockPrivate = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_advanced_rememberAll = wx.BoxSizer(wx.HORIZONTAL)
        grid_clSettings_options = wx.FlexGridSizer(16, 1, 0, 0)
        sizer_clSettings_options_defaultFaction = wx.BoxSizer(wx.HORIZONTAL)
        sizer_1_copy = wx.BoxSizer(wx.VERTICAL)
        sizer_1_copy_copy_1 = wx.BoxSizer(wx.VERTICAL)
        sizer_clSettings_options_createLanTab = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_options_showCustomIcons = wx.BoxSizer(wx.HORIZONTAL)
        sizer_5_copy = wx.FlexGridSizer(1, 2, 0, 0)
        sizer_clSettings_options_iconPath = wx.FlexGridSizer(1, 3, 0, 0)
        grid_clSettings_interface = wx.FlexGridSizer(6, 1, 0, 0)
        sizer_clSettings_interface_colors = wx.BoxSizer(wx.VERTICAL)
        sizer_clSettings_interface_debugText = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_interface_serverText = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_interface_privateText = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_interface_userText = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_interface_channelText = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_interface_thirdColor = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_interface_secondColor = wx.BoxSizer(wx.HORIZONTAL)
        sizer_clSettings_interface_firstColor = wx.BoxSizer(wx.HORIZONTAL)
        grid_clsettings_main.Add((10, 350), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(self.label_clsettings_colorPrefs, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_clSettings_interface_firstColor.Add((20, 20), 0, 0, 0)
        sizer_clSettings_interface_firstColor.Add(self.label_clSettings_interface_firstColor, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_firstColor.Add((94, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_firstColor.Add(self.button_clSettings_interface_firstColor, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(sizer_clSettings_interface_firstColor, 1, wx.EXPAND, 0)
        sizer_clSettings_interface_secondColor.Add((20, 20), 0, 0, 0)
        sizer_clSettings_interface_secondColor.Add(self.label_clSettings_interface_secondColor, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_secondColor.Add((90, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_secondColor.Add(self.button_clSettings_interface_secondColor, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(sizer_clSettings_interface_secondColor, 1, wx.EXPAND, 0)
        sizer_clSettings_interface_thirdColor.Add((20, 20), 0, 0, 0)
        sizer_clSettings_interface_thirdColor.Add(self.label_clSettings_interface_thirdColor, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_thirdColor.Add((93, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_thirdColor.Add(self.button_clSettings_interface_thirdColor, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(sizer_clSettings_interface_thirdColor, 1, wx.EXPAND, 0)
        sizer_clSettings_interface_colors.Add((200, 20), 0, 0, 0)
        sizer_clSettings_interface_colors.Add(self.label_clSettings_textColors, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_clSettings_interface_channelText.Add((20, 20), 0, 0, 0)
        sizer_clSettings_interface_channelText.Add(self.label_clSettings_interface_channelText, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_channelText.Add((66, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_channelText.Add(self.button_clSettings_interface_channelText, 0, wx.ADJUST_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(sizer_clSettings_interface_channelText, 1, wx.EXPAND, 0)
        sizer_clSettings_interface_userText.Add((20, 20), 0, 0, 0)
        sizer_clSettings_interface_userText.Add(self.label_clSettings_interface_userText, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_userText.Add((88, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_userText.Add(self.button_clSettings_interface_userText, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(sizer_clSettings_interface_userText, 1, wx.EXPAND, 0)
        sizer_clSettings_interface_privateText.Add((20, 20), 0, 0, 0)
        sizer_clSettings_interface_privateText.Add(self.label_clSettings_interface_privateText, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_privateText.Add((74, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_privateText.Add(self.button_clSettings_interface_privateText, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(sizer_clSettings_interface_privateText, 1, wx.EXPAND, 0)
        sizer_clSettings_interface_serverText.Add((20, 20), 0, 0, 0)
        sizer_clSettings_interface_serverText.Add(self.label_clSettings_interface_serverText, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_serverText.Add((76, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_serverText.Add(self.button_clSettings_interface_serverText, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(sizer_clSettings_interface_serverText, 1, wx.EXPAND, 0)
        sizer_clSettings_interface_debugText.Add((20, 20), 0, 0, 0)
        sizer_clSettings_interface_debugText.Add(self.label_clSettings_interface_debugText, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_debugText.Add((76, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_debugText.Add(self.button_clSettings_interface_debugText, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_interface_colors.Add(sizer_clSettings_interface_debugText, 1, wx.EXPAND, 0)
        grid_clSettings_interface.Add(sizer_clSettings_interface_colors, 1, 0, 0)
        grid_clSettings_interface.Add((100, 15), 0, 0, 0)
        self.notebook_clSettings_interface.SetAutoLayout(True)
        self.notebook_clSettings_interface.SetSizer(grid_clSettings_interface)
        grid_clSettings_interface.Fit(self.notebook_clSettings_interface)
        grid_clSettings_interface.SetSizeHints(self.notebook_clSettings_interface)
        grid_clSettings_options.Add(self.checkbox_clSettings_options_customIcon, 0, 0, 0)
        grid_clSettings_options.Add((200, 5), 0, 0, 0)
        sizer_clSettings_options_iconPath.Add((14, 20), 0, 0, 0)
        sizer_clSettings_options_iconPath.Add(self.text_clSettings_options_customIconPath, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_options_iconPath.Add(self.button_clSettings_options_findCustomIconPath, 0, wx.FIXED_MINSIZE, 0)
        grid_clSettings_options.Add(sizer_clSettings_options_iconPath, 1, wx.EXPAND, 0)
        grid_clSettings_options.Add((200, 5), 0, 0, 0)
        sizer_5_copy.Add((14, 20), 0, 0, 0)
        sizer_5_copy.Add(self.text_clSettings_options_customIconRules, 0, wx.FIXED_MINSIZE, 0)
        grid_clSettings_options.Add(sizer_5_copy, 1, 0, 0)
        grid_clSettings_options.Add((200, 10), 0, 0, 0)
        sizer_clSettings_options_showCustomIcons.Add(self.checkbox_clSettings_options_showCustomIcons, 0, 0, 0)
        sizer_clSettings_options_showCustomIcons.Add((20, 20), 0, 0, 0)
        sizer_clSettings_options_showCustomIcons.Add(self.label_clSettings_options_showCustomIcons, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_1_copy.Add(sizer_clSettings_options_showCustomIcons, 1, wx.EXPAND, 0)
        sizer_clSettings_options_createLanTab.Add(self.checkbox_clSettings_options_createLanTab, 0, 0, 0)
        sizer_clSettings_options_createLanTab.Add((20, 20), 0, 0, 0)
        sizer_clSettings_options_createLanTab.Add(self.label_clSettings_options_createLanTab, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_1_copy_copy_1.Add(sizer_clSettings_options_createLanTab, 1, wx.EXPAND, 0)
        sizer_1_copy.Add(sizer_1_copy_copy_1, 1, 0, 0)
        grid_clSettings_options.Add(sizer_1_copy, 1, 0, 0)
        grid_clSettings_options.Add((200, 5), 0, 0, 0)
        sizer_clSettings_options_defaultFaction.Add(self.label_clSettings_options_defaultFaction, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_options_defaultFaction.Add(self.choice_clSettings_options_defaultFactionData, 0, 0, 0)
        grid_clSettings_options.Add(sizer_clSettings_options_defaultFaction, 1, wx.EXPAND, 0)
        grid_clSettings_options.Add(self.notebook_1_pane_2_copy, 0, 0, 0)
        self.notebook_clSettings_options.SetAutoLayout(True)
        self.notebook_clSettings_options.SetSizer(grid_clSettings_options)
        grid_clSettings_options.Fit(self.notebook_clSettings_options)
        grid_clSettings_options.SetSizeHints(self.notebook_clSettings_options)
        sizer_clSettings_advanced_rememberAll.Add(self.checkbox_clSettings_advanced_rememberAll, 0, 0, 0)
        sizer_clSettings_advanced_rememberAll.Add((20, 20), 0, 0, 0)
        sizer_clSettings_advanced_rememberAll.Add(self.label_clSettings_advanced_rememberAll, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_3_copy_1.Add(sizer_clSettings_advanced_rememberAll, 1, wx.EXPAND, 0)
        grid_sizer_3_copy_1.Add((100, 5), 0, 0, 0)
        sizer_clSettings_advanced_blockPrivate.Add(self.checkbox_clSettings_advanced_blockPrivate, 0, 0, 0)
        sizer_clSettings_advanced_blockPrivate.Add((20, 20), 0, 0, 0)
        sizer_clSettings_advanced_blockPrivate.Add(self.label_clSettings_advanced_blockPrivate, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_3_copy_1.Add(sizer_clSettings_advanced_blockPrivate, 1, wx.EXPAND, 0)
        grid_sizer_3_copy_1.Add((100, 5), 0, 0, 0)
        sizer_clSettings_advanced_showDebug.Add(self.checkbox_clSettings_advanced_showDebug, 0, 0, 0)
        sizer_clSettings_advanced_showDebug.Add((20, 20), 0, 0, 0)
        sizer_clSettings_advanced_showDebug.Add(self.label_clSettings_advanced_showDebug, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_3_copy_1.Add(sizer_clSettings_advanced_showDebug, 1, wx.EXPAND, 0)
        grid_sizer_3_copy_1.Add((100, 5), 0, 0, 0)
        sizer_clSettings_advanced_donateBandwidth.Add(self.checkbox_clSettings_advanced_donateBandwidth, 0, 0, 0)
        sizer_clSettings_advanced_donateBandwidth.Add((20, 20), 0, 0, 0)
        sizer_clSettings_advanced_donateBandwidth.Add(self.label_clSettings_advanced_donateBandwidth, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_3_copy_1.Add(sizer_clSettings_advanced_donateBandwidth, 1, wx.EXPAND, 0)
        sizer_clSettings_advanced_maxUpload.Add((20, 20), 0, 0, 0)
        sizer_clSettings_advanced_maxUpload.Add(self.label_clSettings_advanced_maxUpload, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_clSettings_advanced_maxUpload.Add((36, 20), 0, 0, 0)
        sizer_clSettings_advanced_maxUpload.Add(self.combo_clSettings_advanced_maxUpload, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_advanced_maxUpload.Add(self.label_kilobytes_copy, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_sizer_3_copy_1.Add(sizer_clSettings_advanced_maxUpload, 1, 0, 0)
        sizer_clSettings_advanced_bitPort.Add((21, 20), 0, 0, 0)
        sizer_clSettings_advanced_bitPort.Add(self.label_clSettings_advanced_bitPort, 0, wx.EXPAND, 0)
        sizer_clSettings_advanced_bitPort.Add((90, 20), 0, wx.EXPAND, 0)
        sizer_clSettings_advanced_bitPort.Add(self.text_clSettings_advanced_bitPortData, 0, wx.EXPAND, 0)
        sizer_clSettings_advanced_bitPort_notNeeded.Add(sizer_clSettings_advanced_bitPort, 1, wx.EXPAND, 0)
        grid_sizer_3_copy_1.Add(sizer_clSettings_advanced_bitPort_notNeeded, 1, 0, 0)
        grid_sizer_3_copy_1.Add((100, 5), 0, 0, 0)
        sizer_clSettings_advanced_ipConfig.Add(self.checkbox_clSettings_advanced_ipConfig, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_clSettings_advanced_ipConfig.Add((20, 20), 0, 0, 0)
        sizer_clSettings_advanced_ipConfig.Add(self.label_clSettings_advanced_ipConfig, 0, wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        grid_sizer_3_copy_1.Add(sizer_clSettings_advanced_ipConfig, 1, wx.EXPAND, 0)
        sizer_clSettings_advanced_ipUsed.Add((26, 20), 0, 0, 0)
        sizer_clSettings_advanced_ipUsed.Add(self.text_clSettings_advanced_ipUsedData, 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_advanced_ipUsed.AddGrowableCol(1)
        grid_sizer_3_copy_1.Add(sizer_clSettings_advanced_ipUsed, 3, 0, 0)
        self.notebook_clSettings_advanced.SetAutoLayout(True)
        self.notebook_clSettings_advanced.SetSizer(grid_sizer_3_copy_1)
        grid_sizer_3_copy_1.Fit(self.notebook_clSettings_advanced)
        grid_sizer_3_copy_1.SetSizeHints(self.notebook_clSettings_advanced)
        self.notebook_clSettings_main.AddPage(self.notebook_clSettings_interface, "Interface")
        self.notebook_clSettings_main.AddPage(self.notebook_clSettings_options, "Options")
        self.notebook_clSettings_main.AddPage(self.notebook_clSettings_advanced, "Advanced")
        grid_clsettings_main.Add(wx.NotebookSizer(self.notebook_clSettings_main), 1, wx.EXPAND, 0)
        grid_clsettings_main.Add((10, 350), 0, wx.FIXED_MINSIZE, 0)
        grid_clsettings_main.Add((10, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_clSettings_main.Add(self.button_clSettings_main_save, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_clSettings_main.Add(self.button_clSettings_main_revertToDefaults, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_clSettings_main.Add(self.button_clSettings_main_done, 0, wx.LEFT|wx.EXPAND|wx.FIXED_MINSIZE, 6)
        grid_clsettings_main.Add(sizer_clSettings_main, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_clsettings_main.Add((10, 20), 0, wx.FIXED_MINSIZE, 0)
        grid_clsettings_main.Add((10, 10), 0, wx.FIXED_MINSIZE, 0)
        grid_clsettings_main.Add((300, 10), 0, wx.FIXED_MINSIZE, 0)
        grid_clsettings_main.Add((10, 10), 0, wx.FIXED_MINSIZE, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_clsettings_main)
        grid_clsettings_main.Fit(self)
        grid_clsettings_main.SetSizeHints(self)
        self.Layout()
        self.Centre()
        # end wxGlade


# end of class gui_clSettings


