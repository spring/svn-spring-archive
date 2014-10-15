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

import os,wx,misc,socket,md5,base64

from GLOBAL import *


#======================================================================
#===========WARNING: Some code below has been modified!================
#======================================================================

# Always read the documentation carefully before updating code from the py.gen folder!

class gui_connect(wx.Dialog):
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_connect.__init__
        kwds["style"] = wx.DEFAULT_DIALOG_STYLE
        wx.Dialog.__init__(self, *args, **kwds)
        self.label_connect_name = wx.StaticText(self, -1, "Name: ", style=wx.ALIGN_RIGHT)
        self.text_connect_nameData = wx.TextCtrl(self, 201, "", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.label_connect_password = wx.StaticText(self, -1, "Password: ")
        self.text_connect_passwordData = wx.TextCtrl(self, 202, "", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB|wx.TE_PASSWORD)
        self.checkbox_connect_rememberLogin = wx.CheckBox(self, -1, "")
        self.label_connect_rememberLogin = wx.StaticText(self, -1, "Remember login")
        self.button_connect_login = wx.Button(self, 101, "Log In")
        self.button_connect_register = wx.Button(self, 102, "Register")
        self.static_line_1 = wx.StaticLine(self, -1)
        self.text_connect_helpBox = wx.TextCtrl(self, -1, "Enter your username and password to log into the Master Server.\n\nIf you do not have a username and password, enter your desired username and password, and hit the \"Register\" button.  This will register your nickname and send you to the Spring Lobby. ", style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_AUTO_URL)

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

    	wx.EVT_BUTTON(self, self.button_connect_login.GetId(), self.OnLogin)
    	wx.EVT_BUTTON(self, self.button_connect_register.GetId(), self.OnRegister)
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
        config = wx.Config.Get()
        
        u = md5.new(self.text_connect_passwordData.GetValue()).digest()
        encoded_pass = base64.encodestring(u)
        
        #Save configuration data
        config.Write("/Player/Name", self.text_connect_nameData.GetValue())
        config.WriteBool("/Player/RememberPass", self.checkbox_connect_rememberLogin.GetValue())
        if str(config.ReadBool("/Player/RememberPass")) == "True":
            config.Write("/Player/Password", encoded_pass.rstrip("\n"))
        else:
            config.Write("/Player/Password", "")

        self.Destroy()
# /end OnClose() ===================================================================================




# OnLogin() ========================================================================================
# ==================================================================================================
#  This function is called when the user wants to log-
#  in with the given login data.

    def OnLogin(self, event):

        if(self.text_connect_nameData.GetValue() == "" or self.text_connect_passwordData.GetValue() == ""):
            misc.CreateMessageBox(self, MSGBOX_EMPTYPASSWORDFIELDS)

        elif self.text_connect_passwordData.GetValue() == "************":
            self.GetParent().connectToServer(False, self.text_connect_nameData.GetValue())
            self.Close()
        else:
            self.GetParent().connectToServer(False, self.text_connect_nameData.GetValue(), self.text_connect_passwordData.GetValue())
            self.Close()
# /end OnLogin() ===================================================================================




# OnRegister() =====================================================================================
# ==================================================================================================
#  This function is called when the user wants to register
#  with the given nickname and password.

    def OnRegister(self, event):

        if(self.text_connect_nameData.GetValue() == "" or self.text_connect_passwordData.GetValue() == ""): 
            misc.CreateMessageBox(self, misc.MSGBOX_EMPTYPASSWORDFIELDS)
            
        username = self.text_connect_nameData.GetValue().split(" ")
        
        if len(username) > 1:
            misc.CreateMessageBox(self, MSGBOX_ERROR, "Usernames cannot contain spaces.")
            return False


        password = self.text_connect_passwordData.GetValue().split(" ")
        
        if len(password) > 1:
            misc.CreateMessageBox(self, MSGBOX_ERROR, "Passwords cannot contain spaces.")
            return False

        else:
            self.GetParent().connectToServer(True, self.text_connect_nameData.GetValue(), self.text_connect_passwordData.GetValue())
            self.Close()
# /end OnLogin() ===================================================================================




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



# InitConfig() =====================================================================================
# ==================================================================================================
#  Do other init that is not already done by the
#  wxGlade generated code.  This makes integrating the 
#  wxGlade code much easier (if it needs to change).

#  Initializes the wxConfig class to store and retrieve
#  data from files "portably".
# ==================================================================================================
    def InitConfig(self):
        config = wx.Config.Get()

        self.text_connect_nameData.SetValue(config.Read("/Player/Name"))
        
        if str(config.ReadBool("/Player/RememberPass")) == "True":
            self.text_connect_passwordData.SetValue("************")
            
        self.checkbox_connect_rememberLogin.SetValue(config.ReadBool("/Player/RememberPass"))

# /end InitConfig() ================================================================================

	

  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================




    def __set_properties(self):
        # begin wxGlade: gui_connect.__set_properties
        self.SetTitle("Omni - Connect/Register")
        _icon = wx.EmptyIcon()

        #===============================================================================
        # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
        	_icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
        # /end edits ===================================================================

        self.SetIcon(_icon)
        self.text_connect_nameData.SetSize((100, 25))
        self.text_connect_passwordData.SetSize((100, 25))
        self.checkbox_connect_rememberLogin.SetSize((22, 21))
        self.button_connect_login.SetToolTipString("Login with the username and password entered above")
        self.button_connect_register.SetToolTipString("Register the username and password above and login")
        self.text_connect_helpBox.SetSize((275, 150))
        self.button_connect_login.SetDefault()
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_connect.__do_layout
        grid_connect_main = wx.FlexGridSizer(4, 3, 0, 0)
        sizer_connect_helpBox = wx.BoxSizer(wx.VERTICAL)
        grid_connect_loginInfo = wx.GridSizer(6, 2, 3, 0)
        grid_connect_main.Add((10, 10), 0, 0, 0)
        grid_connect_main.Add((200, 10), 0, 0, 0)
        grid_connect_main.Add((10, 10), 0, 0, 0)
        grid_connect_main.Add((10, 100), 0, 0, 0)
        grid_connect_loginInfo.Add(self.label_connect_name, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_connect_loginInfo.Add(self.text_connect_nameData, 0, wx.FIXED_MINSIZE, 0)
        grid_connect_loginInfo.Add(self.label_connect_password, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_connect_loginInfo.Add(self.text_connect_passwordData, 0, wx.FIXED_MINSIZE, 0)
        grid_connect_loginInfo.Add(self.checkbox_connect_rememberLogin, 0, wx.ALIGN_RIGHT|wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_connect_loginInfo.Add(self.label_connect_rememberLogin, 0, 0, 0)
        grid_connect_loginInfo.Add(self.button_connect_login, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_connect_loginInfo.Add(self.button_connect_register, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_connect_main.Add(grid_connect_loginInfo, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.SHAPED, 0)
        grid_connect_main.Add((10, 100), 0, 0, 0)
        grid_connect_main.Add((10, 100), 0, 0, 0)
        sizer_connect_helpBox.Add((20, 5), 0, 0, 0)
        sizer_connect_helpBox.Add(self.static_line_1, 0, wx.EXPAND|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_connect_helpBox.Add((20, 8), 0, 0, 0)
        sizer_connect_helpBox.Add(self.text_connect_helpBox, 0, wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_connect_main.Add(sizer_connect_helpBox, 2, wx.EXPAND, 0)
        grid_connect_main.Add((10, 100), 0, 0, 0)
        grid_connect_main.Add((10, 10), 0, 0, 0)
        grid_connect_main.Add((200, 10), 0, 0, 0)
        grid_connect_main.Add((10, 10), 0, 0, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_connect_main)
        grid_connect_main.Fit(self)
        grid_connect_main.SetSizeHints(self)
        self.Layout()
        self.Centre()
        # end wxGlade


# end of class gui_connect


