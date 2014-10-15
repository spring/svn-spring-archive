#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            tab.py
 #
 #  Sat Sept 20 18:07 2005
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

import os,wx,misc,time,gui_lobby,glob,re

from channel import *
from GLOBAL import *
from gui_mpSettings import gui_mpSettings
from gui_clSettings import gui_clSettings
from gui_connect import gui_connect
from gui_host import gui_host
from gui_battleroom import gui_battleroom
from gui_units import gui_units
from gui_color import gui_color

class tab:
# This class is the abstraction of the tab "object".
# It contains all objects and data that you would need
# to identify a tab and change its properties and appearance.

    Id = 0                  #The index of the tab in the notebook and the tablist
    name = ""               #Always lowercase
    title = ""              #Title that appears at the top of the tab
    
    netTab = False          #Does this tab function with a connection to a server?
    channel = None          #Channel instance
    
    tab_panel = None        #Instances of the various objects in the tab
    tab_chatArea = None
    tab_listPeople = None   
    tab_chatBox = None
    tab_send = None
    tab_clear = None
    
    last_messages = []
    next_message = 0
    
    default_listboxcolor = None
    
    parent_window = None    #gui_lobby instance
    tabManager = None       #tabManager(parent) object 
    
    
    
    
    
# __init__() =======================================================================================
# ==================================================================================================
#  The function that creates a new tab
#  using various arguments.

    def __init__(self, parent, tabManager, name, tabTitle, channel=None):
    
        self.last_messages = []
        self.next_message = 0
        
        self.tabManager = tabManager
        self.parent_window = parent
        tabNum = len(self.tabManager.tabList)
        tab = str(tabNum)
        
        panel = "self.parent_window.panel_lobby_" + tab
        chatArea = "self.parent_window.text_lobby_" + tab + "_chatArea"
        #listGames = "self.parent_window.list_lobby_" + tab + "_games"
        listPeople = "self.parent_window.list_lobby_" + tab + "_people"
        chatBox = "self.parent_window.text_lobby_" + tab + "_chatBox"
        send = "self.parent_window.button_lobby_" + tab + "_send"
        clear = "self.parent_window.button_lobby_" + tab + "_clear"
        
        exec(panel + " = wx.Panel(self.parent_window.notebook_lobby_main, -1, style=wx.NO_BORDER)")
        exec(chatArea + " = wx.TextCtrl(" + panel + ", -1, \"\", style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_AUTO_URL)")
        #exec(listGames + " = wx.ListCtrl(" + panel + ", -1, style=wx.LC_REPORT|wx.LC_SINGLE_SEL|wx.SUNKEN_BORDER)")
        exec(listPeople + " = gui_lobby.gui_list(" + panel + ", -1, style=wx.LC_REPORT|wx.LC_SINGLE_SEL|wx.SUNKEN_BORDER)")
        #exec(listPeople + " = wx.ListCtrl(" + panel + ", -1, style=wx.LC_REPORT|wx.LC_SINGLE_SEL|wx.SUNKEN_BORDER)")
        exec(chatBox + " = wx.TextCtrl(" + panel + ", -1, \"\", style=wx.TE_PROCESS_ENTER)")
        exec(send + " = wx.Button(" + panel + ", -1, \"Send\")")
        exec(clear + " = wx.Button(" + panel + ", -1, \"Clear\")")
        
        #exec(chatArea + ".SetSize((400, 429))")
        #exec(listGames + ".SetSize((150, 125))")
        exec(listPeople + ".SetMinSize((200, 1))")
        exec(send + ".SetDefault()")
        
        grid_lobby_1 = wx.FlexGridSizer(2, 3, 0, 0)
        sizer_2 = wx.BoxSizer(wx.HORIZONTAL)
        grid_lobby_1_right = wx.FlexGridSizer(3, 1, 0, 0)
        
        exec("grid_lobby_1.Add(" + chatArea + ", 0, wx.EXPAND, 0)")
        grid_lobby_1.Add((5, 150), 0, 0, 0)
        exec("grid_lobby_1_right.Add(" + listPeople + ", 0, wx.EXPAND, 0)")
        grid_lobby_1_right.AddGrowableRow(0)
        grid_lobby_1_right.AddGrowableRow(2)
        grid_lobby_1_right.AddGrowableCol(0)
        exec("grid_lobby_1.Add(grid_lobby_1_right, 1, wx.EXPAND, 0)")
        exec("grid_lobby_1.Add(" + chatBox + ", 0, wx.EXPAND, 0)")
        grid_lobby_1.Add((5, 20), 0, 0, 0)
        exec("sizer_2.Add(" + send + ", 0, wx.EXPAND, 0)")
        exec("sizer_2.Add(" + clear + ", 0, wx.EXPAND, 0)")
        grid_lobby_1.Add(sizer_2, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        exec(panel + ".SetAutoLayout(True)")
        exec(panel + ".SetSizer(grid_lobby_1)")
        exec("grid_lobby_1.Fit(" + panel + ")")
        exec("grid_lobby_1.SetSizeHints(" + panel + ")")
        grid_lobby_1.AddGrowableRow(0)
        grid_lobby_1.AddGrowableCol(0)
        
        
        exec("self.parent_window.notebook_lobby_main.AddPage(" + panel + ", \"" + tabTitle + "\", True)")
        
        exec("self.tab_panel = " + panel)
        exec("self.tab_chatArea = " + chatArea)
        #exec("self.tab_listGames = " + listGames)
        exec("self.tab_listPeople = " + listPeople)
        exec("self.tab_chatBox = " + chatBox)
        exec("self.tab_send = " + send)
        exec("self.tab_clear = " + clear)
        
        self.title = tabTitle
        self.name = name

        
        if channel != None:
            self.channel = channel
            self.channel.tab = self
            if self.channel.lan != True:
                self.netTab = True  
                
                images = self.tab_listPeople.GetImageList(wx.IMAGE_LIST_SMALL)
                images_names = self.tab_listPeople.images_names

                images_names["available-small"] = images.Add(wx.Bitmap(os.path.join("resource/lobby/", "available-small.png"), wx.BITMAP_TYPE_PNG))
                images_names["busy-small"]      = images.Add(wx.Bitmap(os.path.join("resource/lobby/", "busy-small.png"), wx.BITMAP_TYPE_PNG))
                images_names["away-small"]      = images.Add(wx.Bitmap(os.path.join("resource/lobby/", "away-small.png"), wx.BITMAP_TYPE_PNG))
                images_names["rank3-small"]     = images.Add(wx.Bitmap(os.path.join("resource/lobby/", "rank3-small.png"), wx.BITMAP_TYPE_PNG))
                '''
                for file in glob.glob("resource/flags/*.gif"):
                    field = re.compile("[^/.]*/[^/.]*/([^/.]*)").match(file).group(1)
                    images_names[field] = images.Add(wx.Bitmap(file))
                '''    
                list_users = {
                    0:("status_image",gui_lobby.gui_list.TYPE_IMAGE," ",wx.LIST_FORMAT_LEFT,30),
                    1:("name",gui_lobby.gui_list.TYPE_TEXT,"Player",wx.LIST_FORMAT_LEFT,116),
                    2:("rank_image",gui_lobby.gui_list.TYPE_TEXT,"Rank",wx.LIST_FORMAT_LEFT,40),
                }
                self.tab_listPeople.init(list = self.channel.userList,object = user,mapping = list_users,virtual_style=False)
                self.default_listboxcolor = self.tab_listPeople.GetTextColour()
                
        else:
            self.netTab = False
        
        self.__do_events()
# /end __init__() ==================================================================================








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
        wx.EVT_BUTTON(self.parent_window, self.tab_send.GetId(), self.OnSendMessage)
        wx.EVT_BUTTON(self.parent_window, self.tab_clear.GetId(), self.OnClearMessage)
        
        wx.EVT_TEXT_ENTER(self.tab_panel, self.tab_chatBox.GetId(), self.OnSendMessage)
        
        wx.EVT_KEY_DOWN(self.parent_window, self.OnKeyDown)
        
        wx.EVT_LIST_ITEM_RIGHT_CLICK(self.tab_panel, self.tab_listPeople.GetId(), self.OnRightClick_People)
        
        wx.EVT_RIGHT_DOWN(self.tab_chatArea, self.OnRightClick_ChatArea)
        #wx.EVT_RIGHT_DOWN(self.tab_panel, self.tab_chatArea.GetId(), self.OnRightClick_ChatArea)
        
        wx.EVT_MENU(self.tab_panel, ID_POPUP_USERS_PRIVATEMSG, self.OnPrivateMessage)
        wx.EVT_MENU(self.tab_panel, ID_POPUP_USERS_SETAWAY, self.OnSetAway)
        wx.EVT_MENU(self.tab_panel, ID_POPUP_USERS_GETINFO, self.OnGetUserInfo)
        
        wx.EVT_MENU(self.tab_panel, ID_POPUP_CHANNEL_LOGGING, self.OnLogging)
        wx.EVT_MENU(self.tab_panel, ID_POPUP_CHANNEL_TIMESTAMP, self.OnTimeStamps)
        wx.EVT_MENU(self.tab_panel, ID_POPUP_CHANNEL_CLOSE, self.OnCloseTab)
        
# /end __do_events() ===============================================================================




# OnSendMessage() ==================================================================================
# ==================================================================================================
#  When the user hits the enter button when a chatbox 
#  is focused, or when the user explicitly hits the "Send"
#  button, this function is triggered.

#  The current behavior is for it to parse the message 
#  and act accordingly.
# ==================================================================================================
    def OnSendMessage(self, event):
        if self.netTab == False:
           self.ParseMessage(self.tab_chatBox.GetValue())
        else: 
           self.ParseMessage(self.tab_chatBox.GetValue(), True)
           
        self.tab_chatBox.SetFocus()
# /end OnSendMessage() =============================================================================




# OnCloseTab() =====================================================================================
# ==================================================================================================
#  When the user decides he wants to
#  close the tab and leave the channel.

    def OnCloseTab(self, event):
        if self.parent_window.client != None and self.netTab == True:
            self.parent_window.client.send("LEAVE", self.channel.name)
        self.parent_window.tabManager.RemoveTab(self.name)

# /end OnCloseTab() ================================================================================


# OnLogging() ======================================================================================
# ==================================================================================================
#  When the user wants logging to be enabled.

    def OnLogging(self, event):
        pass

# /end OnLogging() =================================================================================



# OnTimeStamps() ===================================================================================
# ==================================================================================================
#  When the wants timestamps to be
#  added to every message.

    def OnTimeStamps(self, event):
        pass

# /end OnTimeStamps() ==============================================================================




# OnSetAway() ======================================================================================
# ==================================================================================================
#  When the user sets themself as "away."

    def OnSetAway(self, event):
        status = self.parent_window.server.user.status
        bitmask = 2
        
        self.parent_window.client.send("MYSTATUS " + str(status ^ bitmask))

# /end OnSetAway() =================================================================================





# OnPrivateMessage() ===============================================================================
# ==================================================================================================
#  When the user says he wants to private
#  message someone in the channel.

    def OnPrivateMessage(self, event):
        i = self.GetSelection(self.tab_listPeople)
        user = self.channel.userList[i]
    	self.tab_chatBox.SetValue("/w " + user.name + " ")
    	self.tab_chatBox.SetFocus()
        self.tab_chatBox.SetInsertionPointEnd()
        
# /end OnPrivateMessage() ==========================================================================



# OnGetUserInfo() ==================================================================================
# ==================================================================================================
#  When the user sets themself as "away."

    def OnGetUserInfo(self, event):
        pass

# /end OnGetUserInfo() =============================================================================





# OnRightClick_People() ============================================================================
# ==================================================================================================
#  When the user right clicks an item on the
#  tab_listPeople listctl.

    def OnRightClick_People(self, event):
    	point = event.GetPosition()
    	index = event.GetIndex()
    	
    	self.popMenu(point, self.tab_listPeople, index)

# /end OnRightClick_People() =======================================================================


# OnRightClick_ChatArea() ==========================================================================
# ==================================================================================================
#  When the user right clicks an item on the
#  tab_listPeople listctl.

    def OnRightClick_ChatArea(self, event):
    	point = event.GetPosition()
    	
    	self.popMenu(point, self.tab_chatArea)
    	

# /end OnRightClick_ChatArea() =====================================================================




# OnClearMessage() =================================================================================
# ==================================================================================================
#  When the user hits the "Clear" button in the lower
#  right corner of the window, this function is called.

    def OnClearMessage(self, event):
    	self.tab_chatBox.SetValue("")
    	self.tab_chatBox.SetFocus()
# /end OnClearMessage() ============================================================================





# OnKeyDown() ======================================================================================
# ==================================================================================================
#  OnKeyDown() catches keyboard events and acts upon them.  
#  For instance, when the user hits the up or down button
#  when the chat box has focus.  That event triggers this
#  function which then acts upon the information given.
# ==================================================================================================
    def OnKeyDown(self, event):
        if event.GetKeyCode() == wx.WXK_UP and self.tab_panel.FindFocus() == self.tab_chatBox:
            if not self.tabManager.tabList:
                event.Skip()
                
          # Updates the message saving feature of this client--
          # The user wants to retrieve an older message

            # Does last_messages have any data?
            if self.last_messages:
            
                # Displays currently stored message at 0
                if self.next_message == 0:

                    self.tab_chatBox.SetValue(self.last_messages[self.next_message])
                    self.tab_chatBox.SetInsertionPointEnd()
                    self.next_message = 0

                # Retrieve the older message and send it to the current MsgBox
                else:
                    self.tab_chatBox.SetValue(self.last_messages[self.next_message])
                    self.tab_chatBox.SetInsertionPointEnd()
                    self.next_message -= 1
                    

        elif event.GetKeyCode() == wx.WXK_DOWN and self.tab_panel.FindFocus() == self.tab_chatBox:
            if not self.tabManager.tabList:
                event.Skip()
          # Updates the message saving feature of this client--
          # The user wants to retrieve a newer message

          # Does last_messages have any data?
            if self.last_messages:

                # Displays currently stored message at the last value in the messages list
                if self.next_message == len(self.last_messages) - 1:
                    self.next_message = len(self.last_messages) - 1
                    self.tab_chatBox.SetValue("")
                
                #covers a weird situation in which you need to hit down twice to reach a blank line
                elif self.next_message == len(self.last_messages) - 2 and self.last_messages[self.next_message + 1] == self.tab_chatBox.GetValue():
                    self.next_message = len(self.last_messages) - 1
                    self.tab_chatBox.SetValue("")
                    
                # Retrieve the newer message and send it to the current MsgBox
                else:
                    self.tab_chatBox.SetValue(self.last_messages[self.next_message + 1])
                    self.tab_chatBox.SetInsertionPointEnd()
                    self.next_message += 1

        else:
            event.Skip()
# /end OnKeyDown() =================================================================================








  #==========================================================================================================
  #==========================================================================================================
  #======================================OTHER FUNCTIONS=====================================================
  #==========================================================================================================
  #==========================================================================================================


# userMenu() =======================================================================================
# ==================================================================================================
#  The function that deletes the tab
#  and removes it from the notebook.

    def popMenu(self, point, window, i=-1):
    	popupmenu = wx.Menu()
    	
    	if i != -1:
            user = self.channel.userList[i]

            self.tab_listPeople.SetItemState(i, wx.LIST_STATE_SELECTED, wx.LIST_STATE_SELECTED)

            if user.isAway() == True and user.inGame() == True:
                status = "Busy"
            elif user.inGame() == True and user.isAway() == False:
                status = "Busy"
            elif user.isAway() == True and user.inGame() == False:
                status = "Away"
            else:
                status = "Available"
                
            popupmenu.Append(ID_POPUP_USERS_NAME, user.name, "", False)
            popupmenu.Append(ID_POPUP_USERS_STATUS, "Status: " + status, "", False)
            popupmenu.Enable(ID_POPUP_USERS_NAME, False)
            popupmenu.Enable(ID_POPUP_USERS_STATUS, False)

            if user.name == self.parent_window.server.user.name:
                popupmenu.AppendSeparator()
                if status == "Available":
                    popupmenu.Append(ID_POPUP_USERS_SETAWAY, "Set Status to Away", "", False)
                else:
                    popupmenu.Append(ID_POPUP_USERS_SETAWAY, "Set Status to Available", "", False)
                popupmenu.Append(ID_POPUP_USERS_PRIVATEMSG, "Send a Private Message", "", False)
                popupmenu.Append(ID_POPUP_USERS_GETINFO, "Get Info..", "", False)
                popupmenu.Enable(ID_POPUP_USERS_PRIVATEMSG, False)
            else:
                popupmenu.AppendSeparator()
                popupmenu.Append(ID_POPUP_USERS_PRIVATEMSG, "Send a Private Message", "", False)
                popupmenu.Append(ID_POPUP_USERS_GETINFO, "Get Info..", "", False)
        else:
            popupmenu.Append(ID_POPUP_CHANNEL_NAME, "#" + self.channel.name, "", False)
            popupmenu.Enable(ID_POPUP_CHANNEL_NAME, False)
            popupmenu.AppendCheckItem(ID_POPUP_CHANNEL_LOGGING, "Enable Logging", "")
            popupmenu.AppendCheckItem(ID_POPUP_CHANNEL_TIMESTAMP, "Enable Timestamps", "")
            popupmenu.Enable(ID_POPUP_CHANNEL_LOGGING, False)
            popupmenu.Enable(ID_POPUP_CHANNEL_TIMESTAMP, False)
            popupmenu.Append(ID_POPUP_CHANNEL_CLOSE, "Close Tab", "", False)
            
        window.PopupMenu(popupmenu, point)
        
# /end userMenu() ==================================================================================




# disconnect() =====================================================================================
# ==================================================================================================
#  The function that deletes the tab
#  and removes it from the notebook.

    def disconnect(self):
        self.channel.disconnect()
        self.setTitle(tab.name + " Disconnected")
        self.name = "disconnected"
        self.netTab = False
        self.tab_listPeople.DeleteAllItems()
            
# /end disconnect() ================================================================================



# remove() =========================================================================================
# ==================================================================================================
#  The function that removes the tab from the notebook.

    def remove(self, Id):
        self.parent_window.notebook_lobby_main.DeletePage(Id)
            
# /end remove() ====================================================================================




# setTitle() =======================================================================================
# ==================================================================================================
#  The function that sets the title of the
#  page.

    def setTitle(self, title):
    
        self.title = title
        exec("self.parent_window.notebook_lobby_main.SetPageText(" + str(self.Id) + ", \"" + title + "\")")
            
# /end setTitle() ==================================================================================



# addUser() ========================================================================================
# ==================================================================================================
#  This function adds a user to the listPeople listbox.
#  This function should not be called by 
#  anything other than the channel object!

    def addUser(self, user, position, firstJoin=False):
    
        if user == None:
            print("user = false" + str(position))
            return False
            
        if user.isAway() == True and user.inGame() == True:
            user.status_image = 3
        elif user.isAway() == False and user.inGame() == True:
            user.status_image = 4
        elif user.isAway() == True and user.inGame() == False:
            user.status_image = 4
            
            self.tab_listPeople.InsertImageItem(position, user.status_image)
            
            if not firstJoin:
                self.tab_listPeople.Sort()
                
            return True
        else:
            user.status_image = 2

        
        #if user.getRank() == -1: rank = 3
        #else: rank = 2 + user.getRank()
        
        
        self.tab_listPeople.InsertImageItem(position, user.status_image)
        
        if not firstJoin:
            self.tab_listPeople.Sort()
            
        self.tab_listPeople.SetItemTextColour(position, self.default_listboxcolor)
        return True
            
# /end addUser() ===================================================================================



# removeUser() =====================================================================================
# ==================================================================================================
#  Removes a user from the listPeople listbox.
#  This function should not be called by 
#  anything other than the channel object!

    def removeUser(self, position):
        self.tab_listPeople.DeleteItem(position)
            
# /end removeUser() ================================================================================



# updateUser() =====================================================================================
# ==================================================================================================
#  Updates the listPeople listbox from
#  a list passed to the function from
#  the channel object.

    def updateUser(self, user, position):
        if user.inGame() == True and user.isAway() == True:
            user.status_image = 3
            self.tab_listPeople.SetItemTextColour(position, self.default_listboxcolor)
        elif user.inGame() == True and user.isAway() == False:
            user.status_image = 4
            self.tab_listPeople.SetItemTextColour(position, self.default_listboxcolor)
        elif user.inGame() == False and user.isAway() == True:
            user.status_image = 4
            self.tab_listPeople.SetItemTextColour(position, wx.Colour(88,88,88))
            self.tab_listPeople.Sort()
            return True
        else:
            user.status_image = 2
            self.tab_listPeople.SetItemTextColour(position, self.default_listboxcolor)
        
        #if user.getRank() == -1: rank = 3
        #else: rank = 2 + user.getRank()
        self.tab_listPeople.Sort()
        
            
# /end updateUser() ================================================================================



# GetSelection() ===================================================================================
# ==================================================================================================
#  Updates the listPeople listbox from
#  a list passed to the function from
#  the channel object.

    def GetSelection(self, listctrl):
        increment = 0
        
        while increment <= listctrl.GetItemCount() - 1:
            if listctrl.GetItemState(increment, wx.LIST_STATE_SELECTED) == wx.LIST_STATE_SELECTED:
                return increment
            increment += 1
        
            
# /end GetSelection() ==============================================================================







# ParseMessage() ===================================================================================
# ==================================================================================================
#  Parses a message entered into the current chat box so
#  that it can be interpreted as meaningful commands.  Without
#  this function, slash (/) commands would not be possible.
# ==================================================================================================
    def ParseMessage(self, message, netParse=False):

        # Are we parsing a command or a chat message to the server?
        if message != "" and message[0] == "/":

            # Updates the message saving feature of this client--
            # where the user hits the up and down buttons to retrieve
            # messages already entered previously.
            if len(self.last_messages) - 1 < 40:
                self.last_messages.append(message)
                self.next_message = len(self.last_messages) - 1
            else:
                del self.last_messages[0]
                self.last_messages.append(message)
                self.next_message = len(self.last_messages) - 1
                

            cmd_parsed = message[1:].split(" ")
            
            if len(cmd_parsed) > 1:
                cmd_sentence = cmd_parsed[1]
                
                for x in cmd_parsed[2:]:
                    cmd_sentence =  cmd_sentence + " " + x
            else:
                cmd_sentence = cmd_parsed


        # =PRINT========================
            if cmd_parsed[0] == "print":
                # The /print command prints a specified internal variable into the current chat area
                # Syntax: "/print <variable>"

                if len(cmd_parsed) < 2 or cmd_parsed[1] == "":
                    self.parent_window.output_handler.output("Not enough arguments given.", DEBUG_ERROR, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    return 0

                try:
                    tmp_var = eval("self.parent_window." +cmd_parsed[1])
                except:
                    self.parent_window.output_handler.output("Variable ^5" + str(cmd_parsed[1]) + "^0 doesn't exist within specified scope.", OTHER_MSG, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    return 0
                

                if type(tmp_var) == str or type(tmp_var) == unicode:
                    self.parent_window.output_handler.output("^5" + cmd_parsed[1] + "^9 = ^7\"^0" + tmp_var + "^7\"", OTHER_MSG, self.Id)
                else:
                    self.parent_window.output_handler.output("^5" + cmd_parsed[1] + "^9 = ^0" + str(tmp_var), OTHER_MSG, self.Id)

                self.tab_chatBox.SetValue("")
                self.tab_chatBox.SetFocus()

        # =SET========================
            elif cmd_parsed[0] == "set":
                # The /set command assigns a <value> to a <variable>
                # Syntax: "/set <variable> <value>"

                if len(cmd_parsed) < 3 or cmd_parsed[1] == "":
                    self.parent_window.output_handler.output("Not enough arguments given.", DEBUG_ERROR, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    return 0
        	
                value = ""
                for string in cmd_parsed[2:]:
                	value = value + string + " "

                try:
                    tmp_var = eval("self.parent_window." +cmd_parsed[1])
                except:
                    self.parent_window.output_handler.output("Variable ^5" + str(cmd_parsed[1]) + "^0 doesn't exist within specified scope.", OTHER_MSG, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    return 0

                try:
                    if type(tmp_var) == int: exec(cmd_parsed[1] + " = " + int(value))
                    elif type(tmp_var) == str: exec(cmd_parsed[1] + " = " + value)
                    else: exec(cmd_parsed[1] + " = " + value)

                except:
                    self.parent_window.output_handler.output("Value ^5" + str(value) + "^0 is incompatible with the variable type.", OTHER_MSG, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    return 0


                if type(tmp_var) is str:
                    self.parent_window.output_handler.output("^5" + cmd_parsed[1] + "^9 = ^7\"^0" + eval(cmd_parsed[1]) + "^7\"", OTHER_MSG, self.Id)
                else:
                    self.parent_window.output_handler.output(str(tmp_var), OTHER_MSG)

                self.tab_chatBox.SetValue("")
                self.tab_chatBox.SetFocus()

        # =OPEN========================
            elif cmd_parsed[0] == "open":

                # The /open command forces <window_className> to open with default init values
                # Syntax: "/open <window_className>"

                if len(cmd_parsed) < 2 or cmd_parsed[1] == "":
                    self.parent_window.output_handler.output("Not enough arguments given.", DEBUG_ERROR, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    return 0

                try:
                    tmp_var = eval(cmd_parsed[1])
                except:
                    #self.AppendToChat("Error:", self.color_error_text, False)
                    self.parent_window.output_handler.output("No such window exists.", DEBUG_ERROR, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    return 0

                try:
                    tmp_win = tmp_var(self.parent_window, -1, "")
                except:
                    self.parent_window.output_handler.output("There were errors opening the window.  They have been dumped to the command line.", DEBUG_ERROR, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    raise
                    return 0

                tmp_win.Show()

                self.tab_chatBox.SetValue("")
                self.tab_chatBox.SetFocus()

        # =STATS========================
            elif cmd_parsed[0] == "stats":
                
                # The /stats command requests statistical (win/loss/tie) data about <username> from the spring server
                # Syntax: "/stats <username>"
                if netParse == True:
                    
                    if len(cmd_parsed) < 2 or cmd_parsed[1] == "":
                        self.parent_window.output_handler.output("^5Error parsing command.", DEBUG_ERROR, self.Id)
                        self.tab_chatBox.SetValue("")
                        self.tab_chatBox.SetFocus()
                        return 0

                    try: pass
                    	# get the stats of the specified "user"
                    except:
                        self.parent_window.output_handler.output("Player ^0" + str(cmd_parsed[1]) + "^3 does not exist.", SERVER_OTHER, self.Id)
                        self.tab_chatBox.SetValue("")
                        self.tab_chatBox.SetFocus()
                        return 0

                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                else:
                    self.parent_window.output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, self.Id)

        # =TIME========================
            elif cmd_parsed[0] == "time":
                # The /time command requests the official server time
                # Syntax: "/time"
                if netParse == True:
                    try: pass
                    	# Get current time from the server
                    except:
                        self.parent_window.output_handler.output("Could not get time data from server.", SERVER_OTHER, self.Id)
                        self.tab_chatBox.SetValue("")
                        self.tab_chatBox.SetFocus()
                        return 0

                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                else:
                    self.parent_window.output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, self.Id)

        # =R==========================
            elif cmd_parsed[0] == "r":
                # The /r command returns the last person you whispered to
                # Syntax: "/r"
                if netParse == True:
                
                    try: pass
                    	# return last person whispered (ie -> "/w LastPersonWhispered <blinkingcursor>"
                    except:
                        #self.AppendToChat("Not implimented yet.", self.color_channel_text)
                        self.tab_chatBox.SetValue("")
                        self.tab_chatBox.SetFocus()
                        return 0

                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                else:
                    self.parent_window.output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, self.Id)
                
        # =ME=========================
            elif cmd_parsed[0] == "me":
                # The /me command returns the last person you whispered to
                # Syntax: "/me"
                if netParse == True:
                    try: 
                        if cmd_parsed[1] != "":
                            self.parent_window.client.send("SAYEX " + self.name + " " + cmd_sentence)
                    except:
                        self.parent_window.output_handler.output("^5Error parsing command.", DEBUG_ERROR, self.Id)
                        self.tab_chatBox.SetValue("")
                        self.tab_chatBox.SetFocus()
                        return 0

                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                else:
                    self.parent_window.output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, self.Id)

        # =WHISPER======================
            elif cmd_parsed[0] == "w" or cmd_parsed[0] == "whisper" or cmd_parsed[0] == "msg":
                # The /w, /whisper, and /msg commands send a private <message> to the specified <username>
                # Syntax: "/w <username> <message>"
                if netParse == True:
                    if len(cmd_parsed) < 3 or cmd_parsed[1] == "":
                    	self.parent_window.output_handler.output("^5Error parsing command.", DEBUG_ERROR, self.Id)
                    	self.tab_chatBox.SetValue("")
                    	self.tab_chatBox.SetFocus()
                    	return 0

                    user = self.parent_window.server.userFromName(cmd_parsed[1])
            	    if user == None:
                        self.parent_window.output_handler.output("Player ^0" + str(cmd_parsed[1]) + "^3 does not exist.", SERVER_OTHER, self.Id)
                        self.tab_chatBox.SetValue("")
                        self.tab_chatBox.SetFocus()
                        return 0
                    
                    if len(cmd_parsed) - 1 >= 3:
                        unstriped_msg = cmd_parsed[2]
                        for x in cmd_parsed[3:]:
                            unstriped_msg = unstriped_msg + " " + x
                    else:
                        unstriped_msg = cmd_parsed[2]
                        
                    self.parent_window.client.send("SAYPRIVATE " + user.name + " " + unstriped_msg)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                    
                else:
                    self.parent_window.output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, self.Id)
                    
        # =HELP=========================
            elif cmd_parsed[0] == "?" or cmd_parsed[0] == "help" or cmd_parsed[0] == "h":
                # The /?, /help, and /h commands show help information on how to use commands
                # Syntax: "/h <command>"

                if len(cmd_parsed) == 1:
                    self.parent_window.output_handler.output("^5Usage:\n/help <command-without-slash> - shows help info for specified command\n\
/help list - lists all commands\n", OTHER_MSG, self.Id)

                elif cmd_parsed[1] == "list":
                    self.parent_window.output_handler.output("^5Available commands:\n\
/help - shows help info (aliases: /? /h)\n\
/print - prints the value of an internal variable you specify\n\
/set - assigns an internal variable value specified\n\
/open - opens a window from the specified module\n\
/stats - requests the win/los/tie records for the specified player from the server\n\
/time - requests the official server time\n\
/w - sends a private message to the specified player (aliases: /whisper /msg)\n\
/r - \"/whisper\" the last person you whispered\n", OTHER_MSG, self.Id)

                elif cmd_parsed[1] == "print":
                    self.parent_window.output_handler.output("^5Usage: prints the value of the specified variable\n\
/print <internal_variable_name>\n\
Example:\n\
/print self.springClient_version\n", OTHER_MSG, self.Id)

                elif cmd_parsed[1] == "set":
                    self.parent_window.output_handler.output("^5Usage: sets an internal variable a specified value\n\
/set <internal_variable_name> <value_to_assign>\n\
Example:\n\
/set self.server_address \"google.com\"\n", OTHER_MSG, self.Id)

                elif cmd_parsed[1] == "open":
                    self.parent_window.output_handler.output("^5Usage: opens a window from the specified module\n\
/open <module>\n\
Example:\n\
/open gui_units\n", OTHER_MSG, self.Id)

                elif cmd_parsed[1] == "stats":
                    self.parent_window.output_handler.output("^5Usage: requests the win/los/tie records for the specified player from the server\n\
/stats <playername>\n\
Example:\n\
/stats Ace07\n", OTHER_MSG, self.Id)

                elif cmd_parsed[1] == "time":
                    self.parent_window.output_handler.output("^5Usage: requests the official server time\n\
/time\n", OTHER_MSG, self.Id)

                elif cmd_parsed[1] == "w" or cmd_parsed[1] == "whisper" or cmd_parsed[1] == "msg":
                    self.parent_window.output_handler.output("^5Usage: sends a private message to the specified player (aliases: /whisper /msg)\n\
/w <playername> <message>\n\
Example:\n\
/w Ace07 hi whats up?\n", OTHER_MSG, self.Id)

                elif cmd_parsed[1] == "r":
                    self.parent_window.output_handler.output("^5Usage: \"/whisper <last_playername>\"s the last person you whispered\n\
/r\n\
Example:\n\
/r -> /w Ace07\n", OTHER_MSG, self.Id)

                else:
                    self.parent_window.output_handler.output("^5Usage:\n\"/help <command-without-slash>\"\n\
\"/help list\" lists commands\n\
Example:\n\
/help print\n", OTHER_MSG, self.Id)
                self.tab_chatBox.SetValue("")
                self.tab_chatBox.SetFocus()

        # =INVALID======================
            else:
                # This is when the command specified cannot be found
                if message != "/" and message[1] != " ":
                    self.parent_window.output_handler.output("^5Command " + "^4/" + str(cmd_parsed[0]) + "^5 does not exist.", DEBUG_ERROR, self.Id)

                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
                else:
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus()
        else:
            # User does not want to use a command.  They simply
            # want to send a chat message to the server.

            # Updates the message saving feature of this client--
            # where the user hits the up and down buttons to retrieve
            # messages already entered previously.
            if netParse != True:
                if message != "":
                    if len(self.last_messages) - 1 < 40:
                        self.last_messages.append(message)
                        self.next_message = len(self.last_messages) - 1
                    else:
                        del self.last_messages[0]
                        self.last_messages.append(message)
                        self.next_message = len(self.last_messages) - 1
                        
                    self.parent_window.output_handler.output(message, USER_MSG, self.Id)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus() 
            else:
                if message != "":
                    if len(self.last_messages) - 1 < 40:
                        self.last_messages.append(message)
                        self.next_message = len(self.last_messages) - 1
                    else:
                        del self.last_messages[0]
                        self.last_messages.append(message)
                        self.next_message = len(self.last_messages) - 1
                        
                    self.parent_window.client.send("SAY " + self.channel.name + " " + message)
                    self.tab_chatBox.SetValue("")
                    self.tab_chatBox.SetFocus() 
                    

# /end ParseMessage() ==============================================================================



