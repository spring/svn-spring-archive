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

import os,wx,misc

from GLOBAL import *


#======================================================================
#===========WARNING: Some code below has been modified!================
#======================================================================

# Always read the documentation carefully before updating code from the py.gen folder!


class gui_agreement(wx.Frame):

    agreement = ""      #The agreement as it is getting accumulated
    
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_agreement.__init__
        kwds["style"] = wx.DEFAULT_FRAME_STYLE
        wx.Frame.__init__(self, *args, **kwds)
        self.text_agreement_data = wx.TextCtrl(self, -1, "", style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_RICH)
        self.radio_agreement_agree = wx.RadioButton(self, -1, "I have read the above agreement and agree to its terms.", style=wx.RB_GROUP)
        self.radio_agreement_disagree = wx.RadioButton(self, -1, "I do not agree to these terms.")
        self.button_agreement_continue = wx.Button(self, -1, "Continue")

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

    	wx.EVT_BUTTON(self, self.button_agreement_continue.GetId(), self.OnContinue)
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



# OnContinue() =====================================================================================
# ==================================================================================================
#  When the user hits the "Agree" button this
#  event is triggered.

    def OnContinue(self, event):
        if self.radio_agreement_agree.GetValue() == True:
            self.GetParent().client.send("CONFIRMAGREEMENT")
            self.GetParent().client.reLogin()
            self.Close()
        else:
            self.GetParent().output_handler.output("Server: You must accept the agreement to join this server!", SERVER_HIGH)
            self.GetParent().client.disconnect("graceful")
            self.Close()

# /end OnContinue() ================================================================================



# addToAgreement() =================================================================================
# ==================================================================================================
#  Add part of the agreement to the agreement variable
    def addToAgreement(self, text):
        self.agreement = self.agreement + text
# /end addToAgreement() ============================================================================



# updateAgreement() ================================================================================
# ==================================================================================================
#  Update the text control with the agreement
    def updateAgreement(self):
        self.text_agreement_data.SetValue(self.agreement)
# /end updateAgreement() ===========================================================================



  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================

    def __set_properties(self):
        # begin wxGlade: gui_agreement.__set_properties
        self.SetTitle("Server Agreement")
        _icon = wx.EmptyIcon()
        
        #===============================================================================
        # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
        	_icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
        # /end edits ===================================================================
        
        self.SetIcon(_icon)
        self.SetSize((629, 389))
        self.text_agreement_data.SetMinSize((486, 265))
        self.radio_agreement_disagree.SetValue(1)
        self.button_agreement_continue.SetDefault()
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_agreement.__do_layout
        grid_sizer_3 = wx.FlexGridSizer(5, 3, 0, 0)
        grid_sizer_4 = wx.FlexGridSizer(2, 1, 0, 0)
        sizer_9 = wx.BoxSizer(wx.VERTICAL)
        grid_sizer_3.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((20, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((10, 20), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add(self.text_agreement_data, 0, wx.EXPAND, 0)
        grid_sizer_3.Add((10, 20), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((5, 5), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((20, 5), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((10, 20), 0, wx.ADJUST_MINSIZE, 0)
        sizer_9.Add(self.radio_agreement_agree, 0, 0, 0)
        sizer_9.Add(self.radio_agreement_disagree, 0, 0, 0)
        sizer_9.Add((50, 20), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_4.Add(sizer_9, 1, wx.EXPAND, 0)
        grid_sizer_4.Add(self.button_agreement_continue, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_sizer_4.AddGrowableRow(0)
        grid_sizer_4.AddGrowableRow(1)
        grid_sizer_4.AddGrowableCol(0)
        grid_sizer_3.Add(grid_sizer_4, 1, wx.EXPAND, 0)
        grid_sizer_3.Add((10, 20), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((20, 10), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_3.Add((10, 10), 0, wx.ADJUST_MINSIZE, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_sizer_3)
        grid_sizer_3.AddGrowableRow(1)
        grid_sizer_3.AddGrowableCol(1)
        self.Layout()
        self.Centre()
        # end wxGlade

# end of class gui_agreement


