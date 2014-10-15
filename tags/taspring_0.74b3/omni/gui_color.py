# -*- coding: UTF-8 -*-

#======================================================
 #            gui_units.py
 #
 #  Sat August 21 20:14 2005
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

class gui_color(wx.Dialog):
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_color.__init__
        kwds["style"] = wx.DEFAULT_DIALOG_STYLE
        wx.Dialog.__init__(self, *args, **kwds)
        self.list_color_data = wx.ListBox(self, -1, choices=["Red", "Blue"], style=wx.LB_SINGLE)
        self.button_color_ok = wx.Button(self, -1, "OK")
        self.button_color_cancel = wx.Button(self, -1, "Cancel")

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






# OnListItemSelect() ===============================================================================
# ==================================================================================================
#  This function is called when the user selects
#  a list item from the list of units.  This updates
#  The picture and unit title in the rest of the dialog
#  and allows users to edit limits with particular units.
# ==================================================================================================
    def OnListItemSelect(self, event):
        pass
    	   
# /end OnListItemSelect() ==========================================================================





# OnDefaults() =====================================================================================
# ==================================================================================================
#  This function is called when the program is told
#  to revert to the tried and true defaults.

    def OnDefaults(self, event):
        self.Defaults()
# /end OnUpdateLimit() =============================================================================






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
        self.InitList()
# /end __do_init() =================================================================================






# InitList() =======================================================================================
# ==================================================================================================
#  Populates the list control with units and structures.

    def InitList(self):
        pass
# /end InitList() ==================================================================================





# Defaults() =======================================================================================
# ==================================================================================================
#  Populates the list control with units and structures.

    def Defaults(self):
        pass
# /end Defaults() ==================================================================================





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

        config.Flush()	
# /end SaveConfig() ================================================================================




  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================


    def __set_properties(self):
        # begin wxGlade: gui_color.__set_properties
        self.SetTitle("Change color")
        _icon = wx.EmptyIcon()
        
    #===============================================================================
    # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
    # /end edits ===================================================================
    
        self.SetIcon(_icon)
        self.list_color_data.SetSize((175, 150))
        self.list_color_data.SetSelection(0)
        self.button_color_ok.SetDefault()
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_color.__do_layout
        grid_main = wx.FlexGridSizer(5, 3, 0, 0)
        sizer_okcancel = wx.BoxSizer(wx.HORIZONTAL)
        grid_main.Add((10, 10), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((100, 15), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((10, 10), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((10, 100), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add(self.list_color_data, 0, wx.EXPAND|wx.FIXED_MINSIZE, 0)
        grid_main.Add((10, 100), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((10, 10), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((100, 15), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((10, 10), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((10, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_okcancel.Add(self.button_color_ok, 0, wx.FIXED_MINSIZE, 0)
        sizer_okcancel.Add((20, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_okcancel.Add(self.button_color_cancel, 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add(sizer_okcancel, 1, wx.EXPAND, 0)
        grid_main.Add((10, 20), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((10, 10), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((100, 15), 0, wx.FIXED_MINSIZE, 0)
        grid_main.Add((10, 10), 0, wx.FIXED_MINSIZE, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_main)
        grid_main.Fit(self)
        grid_main.SetSizeHints(self)
        self.Layout()
        self.Centre()
        # end wxGlade

# end of class gui_color


