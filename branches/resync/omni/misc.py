#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            misc.py
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
 

import os,wx

from GLOBAL import *


def CreateMessageBox(self, msgtype=0, message="", caption="", options=""):
    # Simple wrapper class for creating message boxes

    if msgtype == 0:
        tmp_dialog = wx.MessageDialog(self, message, caption, options, wx.DefaultPosition)
        return tmp_dialog.ShowModal()

    # Special dialogs that are often used more than once

    elif msgtype == MSGBOX_NOTCONNECTED:
        tmp_dialog = wx.MessageDialog(self, "Not connected to the spring server!", "Connection Error", wx.ICON_ERROR | wx.OK, wx.DefaultPosition)
        return tmp_dialog.ShowModal()

    elif msgtype == MSGBOX_NETCODE:
        tmp_dialog = wx.MessageDialog(self, "Currently not implimented. Please wait patiently for netcode!", "Coming soon!", wx.ICON_INFORMATION | wx.OK, wx.DefaultPosition)
        return tmp_dialog.ShowModal()
        
    elif msgtype == MSGBOX_EMPTYPASSWORDFIELDS:
        tmp_dialog = wx.MessageDialog(self, "Username or password field is empty.", "Warning", wx.ICON_ERROR | wx.OK, wx.DefaultPosition)
        return tmp_dialog.ShowModal()
        
    elif msgtype == MSGBOX_EMPTYFIELDS:
        tmp_dialog = wx.MessageDialog(self, "Text entry field is empty!", "Warning", wx.ICON_ERROR | wx.OK, wx.DefaultPosition)
        return tmp_dialog.ShowModal()
        
    elif msgtype == MSGBOX_ERROR:
        tmp_dialog = wx.MessageDialog(self, message, "Error!", wx.ICON_ERROR | wx.OK, wx.DefaultPosition)
        return tmp_dialog.ShowModal()
        
    elif msgtype == MSGBOX_CRITICAL_ERROR:
        tmp_dialog = wx.MessageDialog(self, message, "Critical Error!", wx.ICON_ERROR | wx.OK, wx.DefaultPosition)
        return tmp_dialog.ShowModal()
                
        
def CreateColorPicker(self, currentcolor=wx.NullColour):
    # Simple wrapper class for creating color picker dialogs
    color = wx.ColourData()
    
    if not currentcolor is wx.NullColour: 
        color.SetColour(currentcolor)
    
    tmp_dialog = wx.ColourDialog(self,color)
    evnt = tmp_dialog.ShowModal()
    
    if evnt == wx.ID_OK:
        rawcolordata = tmp_dialog.GetColourData()
        return rawcolordata.GetColour()
    else:
        return wx.NullColour



