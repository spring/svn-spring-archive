# -*- coding: UTF-8 -*-

#======================================================
 #            gui_lobby.py
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

import Queue,os,wx,misc,socket,md5,base64

from net_client import client
from debugHandler import debugHandler
from outputHandler import outputHandler
from tab import *
from tabManager import *
from channel import *
from user import *
from server import *

from GLOBAL import *
from gui_mpSettings import gui_mpSettings
from gui_clSettings import gui_clSettings
from gui_connect import gui_connect
from gui_host import gui_host
from gui_battleroom import gui_battleroom
from gui_units import gui_units
from gui_color import gui_color
from gui_agreement import gui_agreement
from gui_channel import gui_channel
from wx.lib.mixins.listctrl  import ListCtrlAutoWidthMixin

class gui_list(wx.ListCtrl,ListCtrlAutoWidthMixin):

    TYPE_TEXT = "text"      #The type of the column is text (OnGetItemText will return a string)
    TYPE_IMAGE = "image"    #The type of the column is image (OnGetItemImage will return the index 
                            # in the image list of an image. This is determined by searching into 
                            #images_names the field from the object)

    list = None             # The list which contains the data
    mapping = None          # Mapping between columns and fields of objects in list (see init)
    images_names = {}       # Mapping between image names used in object and index in the image list
   
    sort_by = 0             # The column index by which we sort
    sort_order = True       # The order (True = ascending, False = descending)
   
    # TODO obtain it from ListCtrl if it is possible
    virtual_style = True    #If True this uses virtual list, if not it uses SetItem (to be able to have images in each column - this really sems stupid from wx...
    
    def __init__(self, *args, **kwds):
        wx.ListCtrl.__init__(self, *args, **kwds)
        ListCtrlAutoWidthMixin.__init__(self)

        self.il = wx.ImageList(16, 16)
        images={"order_up":"GO_UP","order_down":"GO_DOWN"}
        
        for (k,v) in images.items():
            s="self.%s= self.il.Add(wx.ArtProvider_GetBitmap(wx.ART_%s,wx.ART_TOOLBAR,(16,16)))" % (k,v)
            exec(s)

        self.AssignImageList(self.il, wx.IMAGE_LIST_SMALL)	
        # We add the event used to reorder the table        
        self.Bind(wx.EVT_LIST_COL_CLICK, self.OnColumnClick)

    def init (self, list, object, mapping, virtual_style=True):
        self.list = list
        self.mapping = mapping
        self.virtual_style = virtual_style

        for col in mapping.keys():
            fieldName, type, columnHeader, style, width = mapping.get(col)
            if hasattr(object,fieldName):
                self.InsertColumn(col, columnHeader, style, width)
            else:
                print (" Field " + fieldName + " not found in " + str(object))

    def OnGetItemText(self, item, col):
        fieldName, type, columnHeader, style, width = self.mapping.get(col)
        if type == self.TYPE_TEXT:
            return str(getattr(self.list[item], fieldName))
        else:
            return ""

    def OnGetImage(self, item, col):
        fieldName, type, columnHeader, style, width = self.mapping.get(col)
        if type == self.TYPE_IMAGE:            
        #if self.images_names.has_key(getattr(self.list[item], fieldName)):
            return getattr(self.list[item], fieldName)
        else:               
            return -1
        #else:
        #    return -1
        
    def OnColumnClick(self, event):
        if self.sort_by == event.GetColumn():
            # Clicked on the colmun by which we are sorting - invert the order
            self.sort_order = not self.sort_order
        else:
            # Clear the image in the header
            self.ClearColumnImage(self.sort_by)
            # Default ordering (ascending)
            self.sort_order = True
            self.sort_by = event.GetColumn()

        self.Sort()

        if self.sort_order == True:
            self.SetColumnImage(event.GetColumn(),self.order_up)
        else:
            self.SetColumnImage(event.GetColumn(),self.order_down)

    def Sort(self):   
        fieldName, type, columnHeader, style, width = self.mapping.get(self.sort_by)
        self.list.sort(key=operator.attrgetter(fieldName),reverse= (not self.sort_order))

        if self.virtual_style:
            self.RefreshItems(0,len(self.list))
        else:
            # We have to set manually all the columns - use our own functions
            fieldName, type, columnHeader, style, width = self.mapping.get(0)
            for row in range(0,len(self.list)):                
                for col in range(0,len(self.mapping)):
                    self.SetStringItem(row,col,self.OnGetItemText(row,col),self.OnGetImage(row,col))                    


class gui_lobby(wx.Frame):

    # Variables

    color_channel_text = wx.Colour()
    color_user_text = wx.Colour()
    color_private_text = wx.Colour()
    color_server_text = wx.Colour()
    color_debug_text = wx.Colour()
    color_error_text = wx.Colour(225,0,0)

    state_connected = False
    state_inbattle = False
    state_firstChannelListReceived = False

    omni_version =  "0.3.3"
    
    server_address =  "taspringmaster.clan-sy.com"
    server_port = 8200
    server_motd = ""
    
    password = ""
    
    client = None  # The client class
    agreement = None
    
    springClient_titlebar_connected = "Omni - Connected to " + server_address
    springClient_titlebar_disconnected = "Omni - Not Connected"
   
 
    lobby_welcome = "^3Welcome to build ^0" + omni_version + "^3 of the new portable Spring lobby! \n\n\
This version has join support for both battles and channels built in.  There are still some bugs with both, but nothing that can't be fixed in a future release.  Just connect to the spring server and see for yourself!\n\n\
Remember to report any bugs that you do find to me!  (PM Ace07 on the forums, or email jm6.linux@gmail.com)\n"

    
    debug_handler = None
    tabManager = None
    output_handler = None
    server = None
    battleroom = None       #gui battleroom object
    channel = None          #gui channel object
    lastbattle = None
	
#======================================================================
#===========WARNING: Some code below has been modified!================
#======================================================================

# Always read the documentation carefully before updating code from the py.gen folder!

    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_lobby.__init__
        kwds["style"] = wx.DEFAULT_FRAME_STYLE
        wx.Frame.__init__(self, *args, **kwds)
        self.notebook_lobby_main = wx.Notebook(self, -1, style=0)
        self.panel_lobby_1 = wx.Panel(self.notebook_lobby_main, -1, style=wx.NO_BORDER)
        
        # Menu Bar
        self.menubar_lobby = wx.MenuBar()
        self.SetMenuBar(self.menubar_lobby)
        wxglade_tmp_menu = wx.Menu()
        self.menu_lobby_file_connect = wx.MenuItem(wxglade_tmp_menu, 1001, "Connect", "", wx.ITEM_NORMAL)
        wxglade_tmp_menu.AppendItem(self.menu_lobby_file_connect)
        wxglade_tmp_menu.AppendSeparator()
        self.menu_lobby_file_exit = wx.MenuItem(wxglade_tmp_menu, 1002, "Exit", "", wx.ITEM_NORMAL)
        wxglade_tmp_menu.AppendItem(self.menu_lobby_file_exit)
        self.menubar_lobby.Append(wxglade_tmp_menu, "File")
        wxglade_tmp_menu = wx.Menu()
        self.menu_lobby_options_spring = wx.MenuItem(wxglade_tmp_menu, 1003, "Configure Spring", "", wx.ITEM_NORMAL)
        wxglade_tmp_menu.AppendItem(self.menu_lobby_options_spring)
        self.menu_lobby_options_client = wx.MenuItem(wxglade_tmp_menu, 1004, "Configure omni", "", wx.ITEM_NORMAL)
        wxglade_tmp_menu.AppendItem(self.menu_lobby_options_client)
        self.menubar_lobby.Append(wxglade_tmp_menu, "Options")
        wxglade_tmp_menu = wx.Menu()
        self.menu_lobby_game_joinchat = wx.MenuItem(wxglade_tmp_menu, 1006, "Join Chatroom", "", wx.ITEM_NORMAL)
        wxglade_tmp_menu.AppendItem(self.menu_lobby_game_joinchat)
        wxglade_tmp_menu.AppendSeparator()
        self.menu_lobby_game_battle = wx.MenuItem(wxglade_tmp_menu, 1007, "Create Battle", "", wx.ITEM_NORMAL)
        wxglade_tmp_menu.AppendItem(self.menu_lobby_game_battle)
        self.menubar_lobby.Append(wxglade_tmp_menu, "Game")
        wxglade_tmp_menu = wx.Menu()
        self.menu_lobby_about_credits = wx.MenuItem(wxglade_tmp_menu, 1008, "Credits", "", wx.ITEM_NORMAL)
        wxglade_tmp_menu.AppendItem(self.menu_lobby_about_credits)
        self.menubar_lobby.Append(wxglade_tmp_menu, "About")
        # Menu Bar end
        
        # Tool Bar
        self.toolbar_lobby = wx.ToolBar(self, -1, style=wx.TB_HORIZONTAL|wx.TB_3DBUTTONS)
        self.SetToolBar(self.toolbar_lobby)

	#===============================================================================
	# Added os.path.join() to make it so that Windows users can see the icons too!
        self.toolbar_lobby.AddLabelTool(2001, "Connect", wx.Bitmap(os.path.join("resource/toolbar/","connect.png"), wx.BITMAP_TYPE_ANY), wx.NullBitmap, wx.ITEM_NORMAL, "Connect", "")
        self.toolbar_lobby.AddLabelTool(2002, "Disconnect", wx.Bitmap(os.path.join("resource/toolbar/","disconnect.png"), wx.BITMAP_TYPE_ANY), wx.NullBitmap, wx.ITEM_NORMAL, "Disconnect", "")
        self.toolbar_lobby.AddSeparator()
        self.toolbar_lobby.AddLabelTool(2003, "Host Battle", wx.Bitmap(os.path.join("resource/toolbar/","host_battle.png"), wx.BITMAP_TYPE_ANY), wx.NullBitmap, wx.ITEM_NORMAL, "Host a Battle", "")
        self.toolbar_lobby.AddLabelTool(2004, "Configure Spring", wx.Bitmap(os.path.join("resource/toolbar/","spring.png"), wx.BITMAP_TYPE_ANY), wx.NullBitmap, wx.ITEM_NORMAL, "Configure Spring", "")
        self.toolbar_lobby.AddLabelTool(2005, "Configure Client", wx.Bitmap(os.path.join("resource/toolbar/","sync.png"), wx.BITMAP_TYPE_ANY), wx.NullBitmap, wx.ITEM_NORMAL, "Configure omni", "")
	# /end edits ===================================================================
	
        # Tool Bar end

        #self.text_lobby_1_chatArea = wx.TextCtrl(self.panel_lobby_1, 201, "", style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_AUTO_URL)
        self.list_lobby_1_games = gui_list(self, 901, style=wx.LC_REPORT|wx.LC_SINGLE_SEL|wx.SUNKEN_BORDER)
        #self.listbox_lobby_1_people = wx.ListBox(self.panel_lobby_1, 801, choices=[])
        #self.text_lobby_1_chatBox = wx.TextCtrl(self.panel_lobby_1, 202, "", style=wx.TE_PROCESS_ENTER|wx.TE_AUTO_URL)
        #self.button_lobby_1_send = wx.Button(self.panel_lobby_1, 101, "Send")
        #self.button_lobby_1_clear = wx.Button(self.panel_lobby_1, 102, "Clear")
        
        self.tabManager = tabManager(self)
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
    
        #Toolbar and menubar
        wx.EVT_MENU(self, ID_MENU_EXIT, self.OnClose)

        wx.EVT_MENU(self, ID_MENU_CONFIGSPRING, self.OnConfigureSpring)
        wx.EVT_MENU(self, ID_TOOLBAR_CONFIGSPRING, self.OnConfigureSpring)

        wx.EVT_MENU(self, ID_MENU_CONFIGCLIENT, self.OnConfigureClient)
        wx.EVT_MENU(self, ID_TOOLBAR_CONFIGCLIENT, self.OnConfigureClient)

        wx.EVT_MENU(self, ID_MENU_CONNECT, self.OnConnectDialog)
        wx.EVT_MENU(self, ID_TOOLBAR_CONNECT, self.OnForceConnect)
        
        wx.EVT_MENU(self, ID_TOOLBAR_DISCONNECT, self.OnForceDisconnect)

        wx.EVT_MENU(self, ID_MENU_CREATEBATTLE, self.OnCreateBattle)
        wx.EVT_MENU(self, ID_TOOLBAR_CREATEBATTLE, self.OnCreateBattle)
        
        wx.EVT_MENU(self, ID_MENU_JOINCHAT, self.OnJoinChannel)

        wx.EVT_MENU(self, ID_MENU_ABOUT, self.OnCredits)
        #========================
        
        wx.EVT_LIST_ITEM_ACTIVATED(self, self.list_lobby_1_games.GetId(), self.OnSelectBattle)

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
        # Save all configuration changes..
        self.SaveConfig()

        self.Destroy()
# /end OnClose() ===================================================================================




# OnConfigureSpring() ==============================================================================
# ==================================================================================================
#  Opens the gui_mpSettings dialog which allows the user to set
#  settings that affect rendering and other aspects of the Spring
#  engine.  Users can also change their Lan Name (the name used in
#  Lan play) in this dialog.
# ==================================================================================================
    def OnConfigureSpring(self, event):
        self.mpSettings = gui_mpSettings(self, -1, "")
        self.mpSettings.Show()
# /end OnConfigureSpring() =========================================================================




# OnConfigureClient() ==============================================================================
# ==================================================================================================
#  Opens the gui_clSettings dialog which allows the user to set
#  settings that affect the lobby client.  There are various
#  interface tweaks and configuration options in this dialog.
# ==================================================================================================
    def OnConfigureClient(self, event):
        self.clSettings = gui_clSettings(self, -1, "")
        self.clSettings.Show()
# /end OnConfigureClient() =========================================================================




# OnConnectDialog() ================================================================================
# ==================================================================================================
#  Opens the "login" dialog box which allows you to change your
#  login info.  It also allows you to register with the server
#  if you haven't already created a nickname.

    def OnConnectDialog(self, event):
        self.connect = gui_connect(self, -1, "")
        self.connect.Show()
# /end OnConnectDialog() ===========================================================================





# OnConnect() ======================================================================================
# ==================================================================================================
#  When the user hits the "connect" button on the toolbar, this function
#  is called.

    def OnForceConnect(self, event):
        self.connectToServer(False)
# /end OnConnect() =================================================================================



# OnForceDisconnect() ==============================================================================
# ==================================================================================================
#  When the user hits the "connect" button on the toolbar, this function
#  is called.

    def OnForceDisconnect(self, event):
        self.client.disconnect("graceful")
# /end OnForceDisconnect() =========================================================================




# OnCreateBattle() =================================================================================
# ==================================================================================================
#  When the user hits the "Host Battle" toolbar button or menu item,
#  this function is triggered.  Currently it only shows a "not connected"
#  messagebox.

    def OnCreateBattle(self, event):
        if self.state_connected == False:
            misc.CreateMessageBox(self, misc.MSGBOX_NOTCONNECTED)
            #NOT DONE // it will probably be disabled when not connected...
        else:
            self.host = gui_host(self, -1, "")
            self.host.Show()
           #NOT DONE
# /end OnCreateBattle() ============================================================================




# OnJoinChat() =====================================================================================
# ==================================================================================================
#  When the user hits the "Join chat" menu item, this function 
#  is triggered.  Currently it only shows a "not connected" messagebox.

    def OnJoinChannel(self, event):
        if self.state_connected == False:
            misc.CreateMessageBox(self, misc.MSGBOX_NOTCONNECTED)
            #NOT DONE // it will probably be disabled when not connected...
        else:
            self.client.send("CHANNELS")
            self.channel = gui_channel(self, -1, "")
            self.channel.Show()
# /end OnJoinChat() ================================================================================



# OnSelectBattle() =================================================================================
# ==================================================================================================
#  When the user selects a battle he wishes to join
#  various checks are made within the server object
#  under the joinBattle() function.

    def OnSelectBattle(self, event):
        self.server.joinBattle(event.GetIndex())
        
# /end OnSelectBattle() ============================================================================




# OnCredits() ======================================================================================
# ==================================================================================================
#  When the user wants to see the credits.
    def OnCredits(self, event):
        misc.CreateMessageBox(self, 0, "Currently being developed by Josh Mattila (AKA Ace07).\nThe credits section is currently being worked on! :o", "omni version " + self.omni_version, wx.OK)
# /end OnCredits() =================================================================================






  #==========================================================================================================
  #==========================================================================================================
  #=========================================NET FUNCTIONS====================================================
  #==========================================================================================================
  #==========================================================================================================
  



# connectToServer() ================================================================================
# ==================================================================================================
#  Updates the connection (connected or disconnected).  If the client
#  recieves the PONG command within an alloted time, the client is deemed
#  "connected."
    def connectToServer(self, register, user="", password=""):
        if not user == "" and not password == "":
            self.client = client(self, user, password)
        else:
            self.client = client(self)
            
            
        if self.client != None and self.client.client_username != "" and self.client.client_password != "":
            self.client.start()
            u = md5.new(password).digest()
            encoded_pass = base64.encodestring(u)
            
            if not user == "" and not password == "" and register == False:
                self.client.send("LOGIN", user + " " + encoded_pass.rstrip("\n") + " " + str(self.client.client_cpu) + " " + self.client.client_localIP + "\tOmni " + self.omni_version)  
            elif not user == "" and not password == "" and register:
                self.client.send("REGISTER", user + " " + encoded_pass.rstrip("\n"))
            elif register:
                self.client.send("REGISTER", self.client.client_username + " " + str(self.client.client_password))
            elif register == False:
                self.client.send("LOGIN", self.client.client_username + " " + str(self.client.client_password) + " " + str(self.client.client_cpu) + " " + self.client.client_localIP + "\tOmni " + self.omni_version)
                    
        
        
# /end connectToServer() ============================================================================





# updateConnectionStatus() =========================================================================
# ==================================================================================================
#  Updates the connection (connected or disconnected).  If the client
#  recieves the PONG command within an alloted time, the client is deemed
#  "connected."
    def updateConnectionStatus(self, connection):
        if self.state_connected == False and connection == True:
            self.state_connected = True
        elif self.state_connected == True and connection == False:
            self.state_connected = False
        
# /end updateConnectionStatus() =====================================================================





  #==========================================================================================================
  #==========================================================================================================
  #=========================================NET EVENTS=======================================================
  #==========================================================================================================
  #==========================================================================================================
  


# onAddAgreement() =================================================================================
# ==================================================================================================
#  When the client recieves the agreement messages,
#  this event is called.
    def onAddAgreement(self, info):
        try:
            if self.agreement == None:
                self.agreement = gui_agreement(self, -1, "")
                self.agreement.Show()
            print(str(info))
            self.agreement.addToAgreement(str(info))
        except Exception, msg:
            print(msg + "\n  in event onMOTDRecieve()")     
        
# /end onAddAgreement() ============================================================================





# onMOTDRecieve() ==================================================================================
# ==================================================================================================
#  When the client recieves the MOTD, this event function is triggered.
#  info = an MOTD line as a string
    def onMOTDRecieve(self, info):
        try:
            self.server_motd = self.server_motd + info + "\n"
        except Exception, msg:
            print(msg + "\n  in event onMOTDRecieve()")
        
        
# /end onMOTDRecieve() =============================================================================



# onConnect() ======================================================================================
# ==================================================================================================
#  Called when the client is successfully connected to
#  the spring server.
    def onConnect(self):
        try:
            self.toolbar_lobby.EnableTool(ID_TOOLBAR_CONNECT, False)
            self.toolbar_lobby.EnableTool(ID_TOOLBAR_DISCONNECT, True)
            
            self.state_connected = True
            self.TitlebarUpdate()
            
            self.state_firstChannelListReceived = False
            self.server.connected = True
        except Exception, msg:
            print(msg + "\n  in event onConnect()")


# /end onConnect() =================================================================================






# onDisconnect() ===================================================================================
# ==================================================================================================
#  When the client becomes disconnected from the server.
#  info = "force": The disconnect was forced by client.
#  info = "graceful": The disconnect was requested by user.
#  info = "server": The disconnect was forced by the server.
    def onDisconnect(self, info):
        try:
            self.server_motd = ""
            
            self.state_connected = False
            
            self.toolbar_lobby.EnableTool(ID_TOOLBAR_CONNECT, True)
            self.toolbar_lobby.EnableTool(ID_TOOLBAR_DISCONNECT, False)
            
            self.TitlebarUpdate()
            
            if info == "graceful":
                self.output_handler.output("Disconnected from server.", SERVER_HIGH)
            elif info == "force":
                self.output_handler.output("Forcefully disconnected from server.  Server not responding.", SERVER_HIGH)
            elif info == "server":
                self.output_handler.output("Disconnected.", SERVER_HIGH)
            
            self.state_firstChannelListReceived = False
            
            self.tabManager.disconnectAllTabs()
            self.server.disconnect()
        except Exception, msg:
            print(msg + "\n  in event onDisconnect()")
            

        
# /end onDisconnect() ==============================================================================



# onLogin() ========================================================================================
# ==================================================================================================
#  Called when the user has logged into the
#  server and the server has acknowledged this.
    def onLogin(self):
        pass
        #self.output_handler.output("Server: Login accepted.", SERVER_LOW)
        
# /end onLogin() ===================================================================================


# onChannel_Topic() ================================================================================
# ==================================================================================================
#  When the client recieves the MOTD, this event function is triggered.
#  info = [channel, <string>]
    def onChannel_Topic(self, info):
        try:
            self.tabManager.tabFromName(info[0]).channel.topic = info[1]
        except Exception, msg:
            print(msg + "\n  in event onChannelTopic()")


# /end onChannel_Topic() ===========================================================================



# onChannel_ReceiveChannels() ======================================================================
# ==================================================================================================
#  Support functionfor old CHANNELS server command.

#  info = [channel1, channel2, channel3, ...]
    def onChannel_ReceiveChannels(self, info):
        try:
            #if it doesn't exist, make it
            if(self.channel == None):
                self.channel = gui_channel(self, -1, "")
                if self.channel == None:
                    print "error in gui_lobby.onChannel_ReceiveChannels(), self.channel = None"
                    return False
            
            if self.tabManager.getNetTabCount() == 0:
                if(not self.channel.IsShown()):                    
                    self.channel.Show()
                    self.channel.addChannels(info)
            else:
                if(not self.channel.IsShown()):
                    self.channel.Show()
                    self.channel.addChannels(info)
        except Exception, msg:
            print(msg + "\n  in event onChannel_Recieve()")
            
# /end onChannel_ReceiveChannels() =================================================================



# onChannel_Recieved() =============================================================================
# ==================================================================================================
#  When the client recieves the list of channels
#  on the server.
#  info = [channel1, userCount, {topic}]
    def onChannel_Receive(self, info):
        try:
            if(self.channel == None):
                self.channel = gui_channel(self, -1, "")
                
                
            if self.tabManager.getNetTabCount() == 0:
                if(not self.channel.IsShown()):   
                    self.channel.Show()

                self.channel.channels.append(info[0])
                self.channel.numCount.append(int(info[1]))
                
                
            else:
                if(not self.channel.IsShown()):
                    self.channel.Show()
   
                self.channel.channels.append(info[0])
                self.channel.numCount.append(int(info[1]))
                    
        except Exception, msg:
            print(msg + "\n  in event onChannel_Recieve()")
            
# /end onChannel_Recieved() ========================================================================




# onChannel_EndChannels() ==========================================================================
# ==================================================================================================
#  When the client recieves the list of channels
#  on the server.
    def onChannel_EndChannels(self):
        try:
            if(self.channel == None):
                self.channel = gui_channel(self, -1, "")

            if(not self.channel.IsShown()):                
                self.channel.Show()

            self.channel.updateChannels()
                    
        except Exception, msg:
            print(msg + "\n  in event onChannel_EndChannels()")
            
# /end onChannel_EndChannels() =====================================================================




# onChannel_Joined() ===============================================================================
# ==================================================================================================
#  When the client joins the channel specified,
#  this list of clients in the channel is sent.
#  info = channame
    def onChannel_Joined(self, info):
        try:
            self.tabManager.CreateTab(info, "Channel: " + info, channel(self, info))
            
            self.tabManager.GetCurrentChatArea().SetValue("")
      
            self.output_handler.output("^9" + self.server_motd, SERVER_OTHER)
            self.output_handler.output("^5Channel '" + info + "' joined.", OTHER_MSG)
        except Exception, msg:
            print(msg + "\n  in event onChannel_Joined()")


# /end onChannel_Joined() ==========================================================================




# onClientListReceive() ============================================================================
# ==================================================================================================
#  When the client joins the channel specified,
#  this list of clients in the channel is sent.
#  info = [channame, {clients}]
    def onClientListReceive(self, info):
        try:
            for x in info[1:]:
                if self.tabManager.tabFromName(info[0]).channel.addUser(x, True) == False:
                    self.debug_handler.output("Error finding user " + x + " on server", DEBUG_ERROR)
            self.tabManager.tabFromName(info[0]).tab_listPeople.Sort()
        except Exception, msg:
            print(msg + "\n  in event onClientListReceive()")

                
        
# /end onClientListReceive() =======================================================================



# onNewUserLogin() =================================================================================
# ==================================================================================================
#  When a new user joins the server,
#  this command is sent.
#  info = [username, country, cpu, ip]
    def onNewUserLogin(self, info):
        try:            
            self.server.addUser(info[0], info[1], info[2], info[3])
        except Exception, msg:
            print(msg + "\n  in event onNewUserLogin()")
        
        
# /end onNewUserLogin() ============================================================================



# onUserDisconnect() ===============================================================================
# ==================================================================================================
#  When a user disconnects from the server,
#  this event callback is triggered.
#  info = username
    def onUserDisconnect(self, info):
        try:
            self.server.removeUser(info)
        except Exception, msg:
            print(msg + "\n  in event onUserDisconnect()")
        
        
# /end onUserDisconnect() ==========================================================================



# onBattle_Open() ==================================================================================
# ==================================================================================================
#  When a new battle is opened this event
#  is triggered.  The info variable is the
#  full text string of what was recieved from
#  the server.

#  info = BATTLE_ID + type + natType + founder + IP + port + maxplayers + passworded + rank + mapname & {title} & {modname}
# ==================================================================================================
    def onBattle_Open(self, info):
        try:
            cmd_sentences = info.split("\t")
            cmd_1 = cmd_sentences[0].split(" ")
            if len(cmd_1) < 9:
                print("WTFFFFFFF, why does this battle have malformed data")
                return False

            # TODO unknown field 
            self.server.addBattle(cmd_1[0], cmd_1[1], cmd_1[2], cmd_1[3], cmd_1[4], cmd_1[5], cmd_1[6], cmd_1[7], cmd_1[8], cmd_1[9], cmd_sentences[1], cmd_sentences[2])
        except Exception, msg:
            print(str(msg) + "\n  in event onBattle_Open()")
        
        
# /end onBattle_Open() =============================================================================



# onBattle_Closed() ================================================================================
# ==================================================================================================
#  When a battle is closed, the BATTLECLOSED
#  msg is sent to every client on the server.
#  This event is triggered when this msg
#  is recieved from the server.

#  info = BATTLE_ID
# ==================================================================================================
    def onBattle_Closed(self, info):
        try:
            close = False
            if self.battleroom != None and info == self.battleroom.battle.server_id:
                close = True
            self.server.removeBattle(info)
            
            if close == True:
                self.battleroom.Close(True)
        except Exception, msg:
            print(msg + "\n  in event onBattle_Open()")
        
        
# /end onBattle_Closed() ===========================================================================




# onBattle_Joined() ================================================================================
# ==================================================================================================
#  When any user on the server joins
#  a battle, the JOINEDBATTLE msg is sent to
#  every client connected to the server.
#  This event is triggered when this
#  msg is recieved from the server.

#  info = [BATTLE_ID, name]
# ==================================================================================================
    def onBattle_Joined(self, info):
        try:
        
            if self.server.user == None:
                self.server.battleFromBattleId(int(info[0])).addUser(str(info[1]))
            elif info[1] != self.server.user.name:
                self.server.battleFromBattleId(int(info[0])).addUser(str(info[1]))
                
        except Exception, msg:
            print(msg + "\n  in event onBattle_Joined()")
        
# /end onBattle_Joined() ===========================================================================



# onBattle_Leave() =================================================================================
# ==================================================================================================
#  When any user in a battle decides to
#  leave the battle, the LEFTBATTLE message is
#  sent to every client in the server. This
#  event is triggered when that message is
#  recieved from the server.

#  info = [BATTLE_ID, name]
# ==================================================================================================
    def onBattle_Leave(self, info):
        try:
            self.server.battleFromBattleId(int(info[0])).removeUser(info[1])
        except Exception, msg:
            print(msg + "\n  in event onBattle_Leave()")
# /end onBattle_Leave() ============================================================================




# onBattle_Join() ==================================================================================
# ==================================================================================================
#  When the client sends the JOINBATTLE
#  command, and the JOINBATTLE command is recieved
#  afterwards, this event is triggered.

#  info = [BATTLE_ID, startingmetal, startingenery, maxunits, startpos, gameendcondition, limitdgun, diminishingMMs, ghostedBuildings, hashcode]
# ==================================================================================================
    def onBattle_Join(self, info):
        try:
            self.battleroom = gui_battleroom(self, -1, "")
            self.battleroom.Show()
            self.server.battleFromBattleId(int(info[0])).addUser(self.server.user.name)
            self.battleroom.joinBattle(info)
        except Exception, msg:
            print(msg + "\n  in event onBattle_Join()")
# /end onBattle_Join() =============================================================================



# onBattle_ClientStatus() ==========================================================================
# ==================================================================================================
#  When someone in the battle changes
#  his status, this event is triggered.
#  info =  [username, battle_status]
    def onBattle_ClientStatus(self, info):
        try:
            self.battleroom.battle.userFromName(info[0]).updateBattleStatus(int(info[1]))
            self.battleroom.updateGUI(False)
        except Exception, msg:
            print(msg + "\n  in event onBattle_ClientStatus()")

        
# /end onBattle_ClientStatus() =====================================================================



# onBattle_RequestStatus() =========================================================================
# ==================================================================================================
#  When the server requests a battle
#  status from the current user.

    def onBattle_RequestStatus(self):
        try:
            self.client.send("MYBATTLESTATUS", str(self.battleroom.currentUser.getBattleStatus()))
        except Exception, msg:
            print(msg + "\n  in event onBattle_RequestStatus()")

        
# /end onBattle_RequestStatus() ====================================================================




# onBattle_Said() ==================================================================================
# ==================================================================================================
#  When someone in the battle says
#  something this event is triggered.
#  info =  [username, msg_in_pieces ..]
    def onBattle_Said(self, info):
        try:
            self.battleroom.battle.onReceiveMessage(info[1:], "SAIDBATTLE")
        except Exception, msg:
            print(msg + "\n  in event onBattle_Said()")

        
# /end onBattle_Said() =============================================================================




# onBattle_SaidEx() ================================================================================
# ==================================================================================================
#  When someone in the battle sends 
#  a /me this event is triggered.
#  info =  [username, msg_in_pieces ..]
    def onBattle_SaidEx(self, info):
        try:
            self.battleroom.battle.onReceiveMessage(info[1:], "SAIDBATTLEEX")
        except Exception, msg:
            print(msg + "\n  in event onBattle_SaidEx()")

        
# /end onBattle_SaidEx() ===========================================================================



# onNewUserJoin() ==================================================================================
# ==================================================================================================
#  When a new user joins the channel, this
#  event is triggered.
#  info = [channame, username]
    def onNewUserJoin(self, info):
        try:
            if self.tabManager.tabFromName(info[0]).channel.addUser(info[1]) == False:
                self.debug_handler.output("Error adding user " + info[1], DEBUG_ERROR)
        except Exception, msg:
            print(msg + "\n  in event onNewUserJoin()")

        
# /end onNewUserJoin() =============================================================================




# onUserLeaves() ===================================================================================
# ==================================================================================================
#  When a user leaves a channel, this event
#  is triggered.
#  info = [channel, username]
    def onUserLeaves(self, info):
        try:
            if self.tabManager.tabFromName(info[0]).channel.removeUser(info[1]) == False:
                self.debug_handler.output("Error removing user " + info[1], DEBUG_ERROR)
        except Exception, msg:
            print(msg + "\n  in event onUserLeaves()")

        
# /end onUserLeaves() ==============================================================================




# onSaidEx() =======================================================================================
# ==================================================================================================
#  When someone in a channel says
#  something this event is triggered.
#  info = [channame, username, msg_in_pieces ..]
    def onSaidEx(self, info):
        try:
            self.tabManager.tabFromName(info[0]).channel.onReceiveMessage(info[1:], "SAIDEX")
        except Exception, msg:
            print(msg + "\n  in event onSaidEx()")

# /end onSaidEx() ==================================================================================




# onSaid() =========================================================================================
# ==================================================================================================
#  When someone in a channel says
#  something this event is triggered.
#  info = [channame, username, msg_in_pieces ..]
    def onSaid(self, info):
        try:
            self.tabManager.tabFromName(info[0]).channel.onReceiveMessage(info[1:], "SAID")
        except Exception, msg:
            print(msg + "\n  in event onSaid()")

        
# /end onSaid() ====================================================================================




# onSayPrivate() ===================================================================================
# ==================================================================================================
#  When you send a private message to a user,
#  this command is sent to you from the server
#  acknowledging it.
#  info = [username, msg_in_pieces ..]
    def onSayPrivate(self, info):
        try:
            self.tabManager.GetCurrentTab().channel.onReceiveMessage(info, "SAYPRIVATE")  
        except Exception, msg:
            print(msg + "\n  in event onSayPrivate()")
        
# /end onSayPrivate() ==============================================================================


# onSaidPrivate() ==================================================================================
# ==================================================================================================
#  When you send a private message to a user,
#  this command is sent to you from the server
#  acknowledging it.
#  info = [username, msg_in_pieces ..]
    def onSaidPrivate(self, info):
        try:
            self.tabManager.GetCurrentTab().channel.onReceiveMessage(info, "SAIDPRIVATE")
        except Exception, msg:
            print(msg + "\n  in event onSayPrivate()")
        
# /end onSaidPrivate() =============================================================================



# onClientStatus() =================================================================================
# ==================================================================================================
#  When a CLIENTSTATUS command is sent, this
#  event is triggered.
#  info = [username, status]
    def onClientStatus(self, info):
        try:
            self.server.userFromName(info[0]).updateStatus(int(info[1]))
            
            for tab in self.tabManager.tabList:
                if tab.channel != None:
                    tab.channel.updateUser(info[0])

            if info[0] == self.client.client_username:
                self.client.send("CHANNELS")
                self.server.user = self.server.userFromName(self.client.client_username)
                
        except Exception, msg:
            print(msg + "\n  in event onClientStatus()")
        
        
# /end onClientStatus() ============================================================================





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
    
        self.server = server(self)
        
        self.InitConfig()

        config = wx.Config.Get()
        self.SetSize(wx.Size(config.ReadInt("/Global/WinSizeX"), config.ReadInt("/Global/WinSizeY")))

        self.toolbar_lobby.EnableTool(ID_TOOLBAR_DISCONNECT, False)

        # Changeable in the "gui_mpSettings" dialog
        #self.listbox_lobby_1_people.InsertItems([config.Read("/Spring/LanName")], 0) 
        if len(self.tabManager.tabList) != 0: self.tabManager.GetCurrentChatBox().SetFocus()
    
        self.output_handler = outputHandler(self)
        
        if self.output_handler is None:
            print("Could not initialize the output handler!")    
                  
        self.debug_handler = debugHandler(self, self.output_handler)
        
        if self.debug_handler is None:
            self.output_handler.output("Could not initialize the debug handler!", DEBUG_ERROR)
            
        self.output_handler.output(self.lobby_welcome, OTHER_MSG)
        
        images = self.list_lobby_1_games.GetImageList(wx.IMAGE_LIST_SMALL)
        images_names = self.list_lobby_1_games.images_names
        
        images_names["password"] = images.Add(wx.Bitmap(os.path.join("resource/lobby/","password.png"), wx.BITMAP_TYPE_ANY))

        list_games = {
            0:("passworded_int",gui_list.TYPE_IMAGE," ",wx.LIST_FORMAT_LEFT,33),
            1:("name",gui_list.TYPE_TEXT,"Name",wx.LIST_FORMAT_LEFT,300),
            2:("host_name",gui_list.TYPE_TEXT,"Host",wx.LIST_FORMAT_LEFT,130),
            3:("mapName",gui_list.TYPE_TEXT,"Map",wx.LIST_FORMAT_LEFT,115),
            4:("modName",gui_list.TYPE_TEXT,"Mod",wx.LIST_FORMAT_LEFT,130),
            5:("players_string",gui_list.TYPE_TEXT,"Players",wx.LIST_FORMAT_LEFT,60)
        }
        
        self.list_lobby_1_games.init(list = self.server.battleList,object = battle,mapping = list_games, virtual_style=False)
        
# /end __do_init() =================================================================================



# TitleBarUpdate() =================================================================================
# ==================================================================================================
#  Updates the titlebar based on the self.state_connected class
#  variable.  If the client is connected, it displays something
#  different than when it is disconnected.
# ==================================================================================================
    def TitlebarUpdate(self):
        config = wx.Config.Get()
        
        self.springClient_titlebar_connected = "omni " + self.omni_version + " - Connected to " + self.server_address
        self.springClient_titlebar_disconnected = "omni " + self.omni_version + " - Not Connected"

        if self.state_connected == False: 
           self.SetTitle(self.springClient_titlebar_disconnected)
        else:
           self.SetTitle(self.springClient_titlebar_connected) 
# /end TitleBarUpdate() ============================================================================




# UpdateColors() ===================================================================================
# ==================================================================================================
#  Used for updating the various text colors used by
#  the program.

    def UpdateColors(self):
        config = wx.Config.Get()
    
        if config.ReadBool("/ChannelText/Default"):
            self.color_channel_text = wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT)
        else:
            self.color_channel_text = wx.Colour(config.ReadInt("/ChannelText/Red"), config.ReadInt("/ChannelText/Green"), config.ReadInt("/ChannelText/Blue"))

        self.color_user_text = wx.Colour(config.ReadInt("/UserText/Red"), config.ReadInt("/UserText/Green"), config.ReadInt("/UserText/Blue"))
        self.color_private_text = wx.Colour(config.ReadInt("/PrivateText/Red"), config.ReadInt("/PrivateText/Green"), config.ReadInt("/PrivateText/Blue"))
        self.color_server_text = wx.Colour(config.ReadInt("/ServerText/Red"), config.ReadInt("/ServerText/Green"), config.ReadInt("/ServerText/Blue"))
        self.color_debug_text = wx.Colour(config.ReadInt("/DebugText/Red"), config.ReadInt("/DebugText/Green"), config.ReadInt("/DebugText/Blue"))
        
# /end UpdateColors() ===============================================================================




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

    # [Global] defines settings that are used to identify SpringClient specific data
        if not config.Exists("/Global/AppVersion"): config.Write("/Global/AppVersion", self.omni_version)
        if not config.Exists("/Global/SpringServer"): config.Write("/Global/SpringServer", "taspringmaster.clan-sy.com")
        if not config.Exists("/Global/SpringServerPort"): config.WriteInt("/Global/SpringServerPort", 8200)
        if not config.Exists("/Global/RememberEverything"): config.WriteBool("/Global/RememberEverything", True)
        if not config.Exists("/Global/ShowDebug"): config.WriteBool("/Global/ShowDebug", False)
        if not config.Exists("/Global/WinSizeX"): config.WriteInt("/Global/WinSizeX", 804)
        if not config.Exists("/Global/WinSizeY"): config.WriteInt("/Global/WinSizeY", 496)
        if not config.Exists("/Global/LastCommand01"): config.Write("/Global/LastCommand01", "")
        if not config.Exists("/Global/LastCommand02"): config.Write("/Global/LastCommand02", "")
        if not config.Exists("/Global/LastCommand03"): config.Write("/Global/LastCommand03", "")
        if not config.Exists("/Global/LastCommand04"): config.Write("/Global/LastCommand04", "")
        if not config.Exists("/Global/LastCommand05"): config.Write("/Global/LastCommand05", "")
        if not config.Exists("/Global/LastCommand06"): config.Write("/Global/LastCommand06", "")
        if not config.Exists("/Global/LastCommand07"): config.Write("/Global/LastCommand07", "")
        if not config.Exists("/Global/LastCommand08"): config.Write("/Global/LastCommand08", "")
        if not config.Exists("/Global/LastCommand09"): config.Write("/Global/LastCommand09", "")
        if not config.Exists("/Global/LastCommand10"): config.Write("/Global/LastCommand10", "")
        

    # [Player] defines custom settings for use online 
        if not config.Exists("/Player/Name"): config.Write("/Player/Name", "")
        if not config.Exists("/Player/Password"): config.Write("/Player/Password", "")
        if not config.Exists("/Player/RememberPass"): config.WriteBool("/Player/RememberPass", False)

        if not config.Exists("/Player/CustomIcon"): config.WriteBool("/Player/CustomIcon", False)
        if not config.Exists("/Player/CustomIconPath"): config.Write("/Player/CustomIconPath", "")
        if not config.Exists("/Player/DownloadCustom"): config.WriteBool("/Player/DownloadCustom", True)
        if not config.Exists("/Player/CreateLanTab"): config.WriteBool("/Player/CreateLanTab", True)
        if not config.Exists("/Player/DefaultFaction"): config.WriteInt("/Player/DefaultFaction", 0)
        if not config.Exists("/Player/GamePort"): config.WriteInt("/Player/GamePort", 8452)
        
        if not config.Exists("/Player/BlockPrivate"): config.WriteBool("/Player/BlockPrivate", False)
        if not config.Exists("/Player/AlternateIp"): config.Write("/Player/AlternateIp", "")
        if not config.Exists("/Player/DonateBandwidth"): config.WriteBool("/Player/DonateBandwidth", False)
        if not config.Exists("/Player/DonateMaxUpload"): config.WriteInt("/Player/DonateMaxUpload", 10)
        if not config.Exists("/Player/DonateBitPort"): config.WriteInt("/Player/DonateBitPort", 8452)

    # [Spring] defines custom settings for in-game use, whether it be for LAN or online
        if not config.Exists("/Spring/TreeViewDist"): config.WriteInt("/Spring/TreeViewDist", 1400)
        if not config.Exists("/Spring/TerrainDetail"): config.WriteInt("/Spring/TerrainDetail", 40)
        if not config.Exists("/Spring/UnitDetailDist"): config.WriteInt("/Spring/UnitDetailDist", 300)
        if not config.Exists("/Spring/ParticleLimit"): config.WriteInt("/Spring/ParticleLimit", 8000)
        if not config.Exists("/Spring/MaxSounds"): config.WriteInt("/Spring/MaxSounds", 48)

        if not config.Exists("/Spring/Render3dTrees"): config.WriteInt("/Spring/Render3dTrees", True)
        if not config.Exists("/Spring/HighResClouds"): config.WriteBool("/Spring/HighResClouds", False)
        if not config.Exists("/Spring/DynamicClouds"): config.WriteBool("/Spring/DynamicClouds", False)
        if not config.Exists("/Spring/ReflectiveWater"): config.WriteInt("/Spring/ReflectiveWater", False)
        if not config.Exists("/Spring/FullScreen"): config.WriteBool("/Spring/FullScreen", True)
        if not config.Exists("/Spring/ColorizedElevationMap"): config.WriteBool("/Spring/ColorizedElevationMap", False)
        if not config.Exists("/Spring/InvertMouse"): config.WriteBool("/Spring/InvertMouse", False)
        if not config.Exists("/Spring/EnableUnitShadows"): config.WriteBool("/Spring/EnableUnitShadows", False)
        if not config.Exists("/Spring/ShadowMapSize"): config.WriteInt("/Spring/ShadowMapSize", 1024)

        
        # 1 for 1x, 2 for 2xSal, 3 for 2xHQ, 4 for 4xHQ
        if not config.Exists("/Spring/TextureQuality"): config.WriteInt("/Spring/TextureQuality", 1)
        
        # 640 = 640x480, 800 = 800x600, 1024 = 1024x768, 1280 = 1280x1024, 1600 = 1600x1200
        if not config.Exists("/Spring/Resolution"): config.WriteInt("/Spring/Resolution", 800)
        if not config.Exists("/Spring/LanName"): config.Write("/Spring/LanName", "NoName")
        
        #Dynmamically detect it later
        if not config.Exists("/Spring/DataDirectory"): config.Write("/Spring/DataDirectory", SPRING_DATADIR)



        #================================
        #==========Colors================
        #================================

        if not config.Exists("/FirstChoice/Red") or not config.Exists("/FirstChoice/Green") or not config.Exists("/FirstChoice/Blue"): 
            config.WriteInt("/FirstChoice/Red", 0)
            config.WriteInt("/FirstChoice/Green", 0)
            config.WriteInt("/FirstChoice/Blue", 0)

            # Has the user definied the first color choice yet?
            config.WriteBool("/FirstChoice/None", True)


        if not config.Exists("/SecondChoice/Red") or not config.Exists("/SecondChoice/Green") or not config.Exists("/SecondChoice/Blue"): 
            config.WriteInt("/SecondChoice/Red", 0)
            config.WriteInt("/SecondChoice/Green", 0)
            config.WriteInt("/SecondChoice/Blue", 0)

            # Has the user definied the second color choice yet?
            config.WriteBool("/SecondChoice/None", True)


        if not config.Exists("/ThirdChoice/Red") or not config.Exists("/ThirdChoice/Green") or not config.Exists("/ThirdChoice/Blue"): 
            config.WriteInt("/ThirdChoice/Red", 0)
            config.WriteInt("/ThirdChoice/Green", 0)
            config.WriteInt("/ThirdChoice/Blue", 0)
            
            # Has the user defined the second color choice yet?
            config.WriteBool("/ThirdChoice/None", True)


        if not config.Exists("/ChannelText/Red") or not config.Exists("/ChannelText/Green") or not config.Exists("/ChannelText/Blue"): 
            config.WriteInt("/ChannelText/Red", wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT).Red())
            config.WriteInt("/ChannelText/Green", wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT).Green())
            config.WriteInt("/ChannelText/Blue", wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT).Blue())

            # Will be used later for determining if the system is using "System" colors defined by the operating system
            config.WriteBool("/ChannelText/Default", True)


        if not config.Exists("/UserText/Red") or not config.Exists("/UserText/Green") or not config.Exists("/UserText/Blue"): 
            config.WriteInt("/UserText/Red", COLOR_USER_RED)
            config.WriteInt("/UserText/Green", COLOR_USER_GREEN)
            config.WriteInt("/UserText/Blue", COLOR_USER_BLUE)
            config.WriteBool("/UserText/Default", True)
 

        if not config.Exists("/PrivateText/Red") or not config.Exists("/PrivateText/Green") or not config.Exists("/PrivateText/Blue"): 
            config.WriteInt("/PrivateText/Red", COLOR_PRIVATE_RED)
            config.WriteInt("/PrivateText/Green", COLOR_PRIVATE_GREEN)
            config.WriteInt("/PrivateText/Blue", COLOR_PRIVATE_BLUE)
            config.WriteBool("/PrivateText/Default", True)
            

        if not config.Exists("/ServerText/Red") or not config.Exists("/ServerText/Green") or not config.Exists("/ServerText/Blue"): 
            config.WriteInt("/ServerText/Red", COLOR_SERVER_RED)
            config.WriteInt("/ServerText/Green", COLOR_SERVER_GREEN)
            config.WriteInt("/ServerText/Blue", COLOR_SERVER_BLUE)
            config.WriteBool("/ServerText/Default", True)


        if not config.Exists("/DebugText/Red") or not config.Exists("/DebugText/Green") or not config.Exists("/DebugText/Blue"): 
            config.WriteInt("/DebugText/Red", COLOR_DEBUG_RED)
            config.WriteInt("/DebugText/Green", COLOR_DEBUG_GREEN)
            config.WriteInt("/DebugText/Blue", COLOR_DEBUG_BLUE)
            config.WriteBool("/DebugText/Default", True)

        #================================
        #========End Colors==============
        #================================

        # Begin setting the color settings retrieved from the color file/config
        if config.ReadBool("/ChannelText/Default"):
            self.color_channel_text = wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT)
        else:
            self.color_user_text = wx.Colour(config.ReadInt("/ChannelText/Red"), config.ReadInt("/ChannelText/Green"), config.ReadInt("/ChannelText/Blue"))

        self.color_user_text = wx.Colour(config.ReadInt("/UserText/Red"), config.ReadInt("/UserText/Green"), config.ReadInt("/UserText/Blue"))
        self.color_private_text = wx.Colour(config.ReadInt("/PrivateText/Red"), config.ReadInt("/PrivateText/Green"), config.ReadInt("/PrivateText/Blue"))
        self.color_server_text = wx.Colour(config.ReadInt("/ServerText/Red"), config.ReadInt("/ServerText/Green"), config.ReadInt("/ServerText/Blue"))
        self.color_debug_text = wx.Colour(config.ReadInt("/DebugText/Red"), config.ReadInt("/DebugText/Green"), config.ReadInt("/DebugText/Blue"))
        

        #if not config.Read("/Global/LastCommand01") == "":
        #    self.last_messages.append(config.Read("/Global/LastCommand01"))
        #    self.last_messages.append(config.Read("/Global/LastCommand02"))
        #    self.last_messages.append(config.Read("/Global/LastCommand03"))
        #    self.last_messages.append(config.Read("/Global/LastCommand04"))
        #    self.last_messages.append(config.Read("/Global/LastCommand05"))
        #    self.last_messages.append(config.Read("/Global/LastCommand06"))
        #    self.last_messages.append(config.Read("/Global/LastCommand07"))
        #    self.last_messages.append(config.Read("/Global/LastCommand08"))
        #    self.last_messages.append(config.Read("/Global/LastCommand09"))
        #    self.last_messages.append(config.Read("/Global/LastCommand10"))
        #    self.next_message = 9


        # Read the location of the server from the file/config
        self.server.address = config.Read("/Global/SpringServer")
        self.server.port = config.ReadInt("/Global/SpringServerPort")

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

        # [Global] defines settings that are used to identify SpringClient specific data
        if config.ReadBool("/Global/RememberEverything") == True:
            config.WriteInt("/Global/WinSizeX", self.GetSize().GetWidth())
            config.WriteInt("/Global/WinSizeY", self.GetSize().GetHeight())
            
            
        # In case you might be confused by this, just know that it is backwards
        # self.last_messages[0] is always the first message entered into the chat
        # -box.  len(self.last_messages) - 1 is the last thing entered into the
        # chatbox.     
        '''   
        if len(self.last_messages) >= 1:
            config.Write("/Global/LastCommand01", self.last_messages[len(self.last_messages) - 10])
        if len(self.last_messages) >= 2:
            config.Write("/Global/LastCommand02", self.last_messages[len(self.last_messages) - 9]) 
        if len(self.last_messages) >= 3:
            config.Write("/Global/LastCommand03", self.last_messages[len(self.last_messages) - 8]) 
        if len(self.last_messages) >= 4:
            config.Write("/Global/LastCommand04", self.last_messages[len(self.last_messages) - 7]) 
        if len(self.last_messages) >= 5:
            config.Write("/Global/LastCommand05", self.last_messages[len(self.last_messages) - 6]) 
        if len(self.last_messages) >= 6:
            config.Write("/Global/LastCommand06", self.last_messages[len(self.last_messages) - 5]) 
        if len(self.last_messages) >= 7:
            config.Write("/Global/LastCommand07", self.last_messages[len(self.last_messages) - 4]) 
        if len(self.last_messages) >= 8:
            config.Write("/Global/LastCommand08", self.last_messages[len(self.last_messages) - 3]) 
        if len(self.last_messages) >= 9:
            config.Write("/Global/LastCommand09", self.last_messages[len(self.last_messages) - 2]) 
        if len(self.last_messages) >= 10:
            config.Write("/Global/LastCommand10", self.last_messages[len(self.last_messages) - 1]) 
        '''
        # /end [Global] 

        config.Flush()	
# /end SaveConfig() ==============================================================================




  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================




    def __set_properties(self):
        # begin wxGlade: gui_lobby.__set_properties
        self.SetTitle("omni - Not Connected")
        _icon = wx.EmptyIcon()

        #===============================================================================
        # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
        # /end edits ===================================================================


        self.SetIcon(_icon)
        self.SetSize((789, 541))
        self.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BTNFACE))
        self.toolbar_lobby.SetToolBitmapSize((16, 16))
        self.toolbar_lobby.Realize()

        #self.text_lobby_1_chatArea.SetSize((400, 429))
        
        self.list_lobby_1_games.SetSize((1, 140))
        
        '''
        self.button_lobby_1_send.Enable(False)
        self.button_lobby_1_send.SetDefault()
        '''
        
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_lobby.__do_layout
        grid_lobby_main = wx.FlexGridSizer(2, 3, 0, 0)
        grid_lobby_1 = wx.FlexGridSizer(2, 3, 0, 0)
        sizer_2 = wx.BoxSizer(wx.HORIZONTAL)
        grid_lobby_1_right = wx.FlexGridSizer(3, 1, 0, 0)
        grid_lobby_main.Add((1, 100), 0, wx.ADJUST_MINSIZE, 0)
        grid_lobby_main.Add(self.list_lobby_1_games, 1, wx.EXPAND | wx.FIXED_MINSIZE, 0)
        grid_lobby_main.Add((1, 100), 0, wx.ADJUST_MINSIZE, 0)
        grid_lobby_main.Add((1, 150), 0, wx.FIXED_MINSIZE, 0)
        '''
        grid_lobby_1.Add(self.text_lobby_1_chatArea, 0, wx.EXPAND|wx.ADJUST_MINSIZE, 0)
        grid_lobby_1.Add((5, 300), 0, 0, 0)
        grid_lobby_1_right.Add(self.list_lobby_1_games, 1, wx.EXPAND, 0)
        grid_lobby_1_right.Add((200, 5), 0, 0, 0)
        grid_lobby_1_right.Add(self.listbox_lobby_1_people, 0, wx.EXPAND, 0)
        grid_lobby_1_right.AddGrowableRow(0)
        grid_lobby_1_right.AddGrowableRow(2)
        grid_lobby_1_right.AddGrowableCol(0)
        grid_lobby_1.Add(grid_lobby_1_right, 1, wx.EXPAND, 0)
        grid_lobby_1.Add(self.text_lobby_1_chatBox, 0, wx.EXPAND, 0)
        grid_lobby_1.Add((5, 20), 0, 0, 0)
        sizer_2.Add(self.button_lobby_1_send, 0, wx.EXPAND, 0)
        sizer_2.Add(self.button_lobby_1_clear, 0, wx.EXPAND, 0)
        grid_lobby_1.Add(sizer_2, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        self.panel_lobby_1.SetAutoLayout(True)
        self.panel_lobby_1.SetSizer(grid_lobby_1)
        grid_lobby_1.Fit(self.panel_lobby_1)
        grid_lobby_1.SetSizeHints(self.panel_lobby_1)
        grid_lobby_1.AddGrowableRow(0)
        grid_lobby_1.AddGrowableCol(0)
        self.notebook_lobby_main.AddPage(self.panel_lobby_1, "LAN")
        '''
        grid_lobby_main.Add(self.notebook_lobby_main, 1, wx.EXPAND, 0)
        grid_lobby_main.Add((2, 150), 0, 0, 0)
        grid_lobby_main.Add((1, 5), 0, 0, 0)
        grid_lobby_main.Add((150, 5), 0, 0, 0)
        grid_lobby_main.Add((1, 5), 0, 0, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_lobby_main)
        grid_lobby_main.AddGrowableRow(1)
        grid_lobby_main.AddGrowableCol(1)
        self.Layout()
        self.Centre()
        # end wxGlade

# end of class gui_lobby


