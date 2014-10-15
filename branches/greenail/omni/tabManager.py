#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            tabManager.py
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

import os,wx,misc,time

from tab import tab
from channel import *
from GLOBAL import *


class tabManager:
# This class is the tab manager class.
# It houses a management system for tabs,
# that includes construction and deconstruction
# of tab objects.

    tabList = []
    
    parent_window = None
    

# __init__() =======================================================================================
# ==================================================================================================
#  The function that initializes the tabManager
#  class.  It creates the initial lan tab and
#  otherwise initializes the tabmanager.
# ==================================================================================================
    def __init__(self, parent):
    
        config = wx.Config().Get()
        
        # Initialize variables
        self.parent_window = parent
        
        if config.ReadBool("/Player/CreateLanTab") == True or config.Exists("/Player/CreateLanTab") == False:
            self.CreateTab("lan", "LAN", channel(self.parent_window, "lan", True))
            
        # set up the battles list    
        #images = wx.ImageList(16, 16, False, 1)

        #images.Add(wx.Bitmap(os.path.join("resource/lobby/", "available-small.png"), wx.BITMAP_TYPE_PNG))
        #images.Add(wx.Bitmap(os.path.join("resource/lobby/", "busy-small.png"), wx.BITMAP_TYPE_PNG))
        #images.Add(wx.Bitmap(os.path.join("resource/lobby/", "away-small.png"), wx.BITMAP_TYPE_PNG))
        #images.Add(wx.Bitmap(os.path.join("resource/lobby/", "rank3-small.png"), wx.BITMAP_TYPE_PNG))
        
        #self.tab_listPeople.AssignImageList(images, wx.IMAGE_LIST_SMALL)
       
        self.parent_window.default_listboxcolor = self.parent_window.list_lobby_1_games.GetTextColour()
            
        
# /end __init__() ==================================================================================
   




# CreateTab() ======================================================================================
# ==================================================================================================
#  Creates another tab that can be used by the user.  
#  This just creates the tab and returns the tab number
#  so that whatever created the tab can fill it with 
#  meaningful widgets and data.
# ==================================================================================================
    def CreateTab(self, name, tabTitle, channel=None):
    
        newTabId = len(self.tabList)
        
        if channel != None:
            self.tabList.append(tab(self.parent_window, self, name, tabTitle, channel))
            
            index = self.indexFromTabName(name)
            if index == -1:
                return False
                
            self.tabList[index].Id = index
        else:
            self.tabList.append(tab(self.parent_window, self, name, tabTitle))
            index = self.indexFromTabName(name)
            if index == -1:
                return False
                
            self.tabList[index].Id = index
            
# /end CreateTab() =================================================================================




# RemoveTab() ======================================================================================
# ==================================================================================================
#  Removes a tab in the tab list and from
#  the notebook at the same time.
# ==================================================================================================
    def RemoveTab(self, name):
        tab = self.tabFromName(name)
        index = self.indexFromTabName(name)
        
        if tab != None and index != -1:
            tab.remove(index)
            del self.tabList[index]
            self.updateTabIndexes()
            
            return True
        else:
            return False
# /end RemoveTab() =================================================================================




# disconnectAllTabs() ==============================================================================
# ==================================================================================================
#  Removes a tab in the tab list and from
#  the notebook at the same time.
# ==================================================================================================
    def disconnectAllTabs(self):
        for tab in self.tabList:
            if tab.netTab == True:
                tab.disconnect()
            
# /end disconnectAllTabs() =========================================================================



# updateTabIndexes() ===============================================================================
# ==================================================================================================
#  Removes a tab in the tab list and from
#  the notebook at the same time.
# ==================================================================================================
    def updateTabIndexes(self):
        inc = 0
        for tab in self.tabList:
            tab.Id = inc
            inc += 1
            
# /end updateTabIndexes() ==========================================================================




# getNetTabCount() =================================================================================
# ==================================================================================================
#  Removes a tab in the tab list and from
#  the notebook at the same time.
# ==================================================================================================
    def getNetTabCount(self):
        inc = 0
        for tab in self.tabList:
            if tab.netTab == True:
                inc += 1
        return inc
            
# /end getNetTabCount() ============================================================================



# tabFromName() ====================================================================================
# ==================================================================================================
#  Returns a tab from the given
#  name (as a string).
# ==================================================================================================
    def tabFromName(self, name):
    
        if name != "":
            for x in self.tabList:
                if x.name == name:
                    return x
        self.parent_window.output_handler.output("tabFromName cant't find tab :"+str(name), DEBUG_ERROR)
        return None
# /end tabFromName() ===============================================================================

   
   
   
# indexFromTabName() ===============================================================================
# ==================================================================================================
#  Returns the index of the battle
#  in the self.battleList variable.

    def indexFromTabName(self, name):
        inc = 0

        for x in self.tabList:
            if x.name == name:
                return inc
            inc += 1
            
        self.parent_window.output_handler.output("index == -1, error finding index from tab name <" + name + ">: tabManager.py", DEBUG_ERROR)
        return -1
# /end indexFromTabName() ==========================================================================


   
   
# GetCurrentTab() ==================================================================================
# ==================================================================================================
#  Returns the current tab that is being used by the user.
#  This ensures that the right messages are sent to the right chat area.

    def GetCurrentTab(self):
        if len(self.tabList) == 0:
            self.parent_window.output_handler.output("tab == NoneType, error in GetCurrentTab(): tabManager.py", DEBUG_ERROR)
            return None
        try:
            cur_tab = self.tabList[self.parent_window.notebook_lobby_main.GetSelection()]
        except:
            self.parent_window.output_handler.output("tab == NoneType, error in GetCurrentTab(): tabManager.py", DEBUG_ERROR)
            return None
        return cur_tab
# /end GetCurrentTab() =============================================================================




# GetCurrentChatBox() ==============================================================================
# ==================================================================================================
#  Returns the current chat box that is used to send
#  messages to the server.  

    def GetCurrentChatBox(self, tab=-1):
        # returns the current chat box that is used to type SAY messages in
        if self.GetCurrentTab() == None:
            return None
            
        if tab == -1:
            tmp_widget = self.GetCurrentTab().tab_chatBox
        else:
            try:
                tmp_widget = self.tabList[tab].tab_chatBox
            except:
                self.parent_window.output_handler.output("chatBox == NoneType, error getting the current chatbox: tabManager.py", DEBUG_ERROR)
                return None
            
        return tmp_widget
# /end GetCurrentChatBox() =========================================================================




# GetCurrentChatArea() =============================================================================
# ==================================================================================================
#  Returns the current chat area that is used to show
#  messages from the server.

    def GetCurrentChatArea(self, tab=-1):
        # returns the current chat area that displays messages from the server
        if self.GetCurrentTab() == None:
            return None
            
        if tab == -1:
            tmp_widget = self.GetCurrentTab().tab_chatArea
        else:
            try:
                tmp_widget = self.tabList[tab].tab_chatArea
            except:
                self.parent_window.output_handler.output("chatArea == NoneType, error getting the current chatarea: tabManager.py", DEBUG_ERROR)
                return None
            
        return tmp_widget
# /end GetCurrentChatArea() ========================================================================
   
 
