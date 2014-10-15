#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            SpringClient.py
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
 

import wxversion
wxversion.ensureMinimal("2.6")

import wx

from gui_lobby import gui_lobby

class wxGUI(wx.App):
    def OnInit(self):
    
        self.config = wx.Config("omni")
        wx.Config.Set(self.config) 

        wx.InitAllImageHandlers()
        lobby = gui_lobby(None, -1, "")
        self.SetTopWindow(lobby)
        lobby.Show()

        
        return 1

    def OnExit(self):
        del self.config
        wx.Config.Set(None)

# end of class wxGUI

if __name__ == "__main__":
    omni = wxGUI(0)
    omni.MainLoop()

