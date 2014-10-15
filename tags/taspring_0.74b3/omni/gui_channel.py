# -*- coding: UTF-8 -*-

#======================================================
 #            gui_connect.py
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

class gui_channel(wx.Frame):

    channels = []       #channels in the listbox
    channel_names = []  #channel names that are arranged like "channels"
    numCount = []       #the number of people in each channel
    
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_channel.__init__
        kwds["style"] = wx.DEFAULT_FRAME_STYLE
        wx.Frame.__init__(self, *args, **kwds)
        self.list_channel_channels = wx.ListBox(self, -1, choices=[], style=wx.LB_SINGLE)
        self.text_channel_channel = wx.TextCtrl(self, -1, "", style=wx.TE_PROCESS_ENTER)
        self.button_channel_join = wx.Button(self, -1, "Join")

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

    	wx.EVT_BUTTON(self, self.button_channel_join.GetId(), self.OnJoinClick)
    	wx.EVT_LISTBOX_DCLICK(self, self.list_channel_channels.GetId(), self.OnJoinDoubleClick)
    	wx.EVT_LISTBOX(self, self.list_channel_channels.GetId(), self.OnListSelect)
    	
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
    
        while len(self.numCount) - 1 >= 0:
            del self.numCount[0]
                
        while len(self.channel_names) - 1 >= 0:
            del self.channel_names[0]
            
        while len(self.channels) - 1 >= 0:
            del self.channels[0]
            
        self.list_channel_channels.Set([])

        self.Destroy()
# /end OnClose() ===================================================================================




# OnJoinClick() ====================================================================================
# ==================================================================================================
#  When the user hits the join channel
#  button.

    def OnJoinClick(self, event):
        channel = self.text_channel_channel.GetValue()
        
        if channel != "":
            self.GetParent().client.send("JOIN", channel) 
            self.Close(True)
        else:
            misc.CreateMessageBox(self, MSGBOX_EMPTYFIELDS)
            
# /end OnJoinClick() ===============================================================================




# OnJoinDoubleClick() ==============================================================================
# ==================================================================================================
#  When the user double clicks an
#  existing channel on the list.

    def OnJoinDoubleClick(self, event):
        index = event.GetSelection()
        channel = self.channel_names[index]
        
        self.GetParent().client.send("JOIN", channel)
        
        self.Close(True)
        
# /end OnJoinDoubleClick() =========================================================================



# OnListSelect() ===================================================================================
# ==================================================================================================
#  When the user selects a channel
#  from the preset list.

    def OnListSelect(self, event):
        self.text_channel_channel.SetValue(self.channel_names[self.list_channel_channels.GetSelection()])
        self.text_channel_channel.SetFocus()
        
# /end OnListSelect() ==============================================================================




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
# ==================================================================================================
    def __do_init(self):
        pass
# /end __do_init() =================================================================================
  
  
  
  
# updateChannels() =================================================================================
# ==================================================================================================
#  Updates the channel list.

    def updateChannels(self):

        inc = 0
        if len(self.channels) < len(self.channel_names):
            while inc < len(self.channel_names):
                self.channels.append( str(self.channel_names[inc]) + " (" + str(self.numCount[inc]) + ")")
                inc += 1
        else:    
            while inc < len(self.channels):
                self.channels[inc] = str(self.channel_names[inc]) + " (" + str(self.numCount[inc]) + ")"
                inc += 1

        self.list_channel_channels.Set(self.channels)
        self.list_channel_channels.SetSelection(0)
        
        if self.GetParent().tabManager.getNetTabCount() == 0:
            self.text_channel_channel.SetValue(self.channel_names[self.list_channel_channels.GetSelection()])
            self.text_channel_channel.SetFocus()
        
# /end updateChannels() ============================================================================
  
  
  
# addChannels() ====================================================================================
# ==================================================================================================
#  Updates the channel list. Support function
#  for old CHANNELS server command.
#
#  data = [chan1, chan2, chan3 ...]

    def addChannels(self, data):
    
        self.channels = []
        main = False
        
        for x in data:
            if x == "main":
                main = True
            self.channels.append(x)
        
        if main == False:
            self.channels.insert(0, "main")
            
        self.list_channel_channels.Set(self.channels)
        self.list_channel_channels.SetSelection(0)
        
        if self.GetParent().tabManager.getNetTabCount() == 0:
            self.text_channel_channel.SetValue(self.list_channel_channels.GetStringSelection())
            self.text_channel_channel.SetFocus()
        
# /end addChannels() ===============================================================================



  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================


    def __set_properties(self):
        # begin wxGlade: gui_channel.__set_properties
        self.SetTitle("Omni - Join Channel")
        _icon = wx.EmptyIcon()
        
        #===============================================================================
        # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
        	_icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
        # /end edits ===================================================================

        self.SetIcon(_icon)
        self.SetSize((429, 265))
        self.button_channel_join.SetDefault()
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_channel.__do_layout
        grid_channel_main = wx.FlexGridSizer(5, 3, 0, 0)
        sizer_10 = wx.FlexGridSizer(1, 2, 0, 0)
        grid_channel_main.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((50, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((10, 20), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add(self.list_channel_channels, 0, wx.EXPAND, 0)
        grid_channel_main.Add((10, 20), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((50, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((10, 20), 0, wx.ADJUST_MINSIZE, 0)
        sizer_10.Add(self.text_channel_channel, 0, wx.EXPAND, 0)
        sizer_10.Add(self.button_channel_join, 0, 0, 0)
        sizer_10.AddGrowableCol(0)
        grid_channel_main.Add(sizer_10, 1, wx.EXPAND, 0)
        grid_channel_main.Add((10, 20), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((50, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_channel_main.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_channel_main)
        grid_channel_main.AddGrowableRow(1)
        grid_channel_main.AddGrowableCol(1)
        self.Layout()
        self.Centre()
        # end wxGlade

# end of class gui_channel


