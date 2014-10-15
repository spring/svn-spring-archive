#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            channel.py
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

from user import *
from GLOBAL import *


class channel:
# This class is the abstraction of the channel "object".
# It contains a list of users currently in the channel,
# and their respective statuses.  It also handles sending
# and receiving chat messages.

    name = ""               #always lowercase
    
    topic = ""
    
    lan = False
    battle = False
    
    userList = []
    
    parent_window = None    #gui_lobby instance
    tab = None              #tab that owns this channel instance
    
    
    
# __init__() =======================================================================================
# ==================================================================================================
#  The function that creates a new channel
#  and imports various data needed for the
#  class to function properly.

    def __init__(self, parent, name, lan=False, battle_id=-1):
    
        self.parent_window = parent
        self.lan = lan
        self.name = name
        
        self.userList = []
        
        if battle_id != -1:
            self.battle_id = battle_id
            self.battle = True
            
# /end __init__() ==================================================================================




# disconnect() =====================================================================================
# ==================================================================================================
#  The function that deletes the users in the channel.

    def disconnect(self):
        while len(self.userList) - 1 >= 0:
            del self.userList[0]
        
        self.userList = []
        
        self.name = self.name + " " + str(self.tab.Id)
        self.lan = True
            
# /end disconnect() ================================================================================



# addUser() ========================================================================================
# ==================================================================================================
#  This function adds a user to the userlist
#  and notifies the tab class to update its
#  user list.
# ==================================================================================================
    def addUser(self, name, firstJoin=False):
        if self.parent_window.server.userFromName(name) != None:
        
            if self.name == "sex":
                print self.parent_window.server.userFromName(name)
                
            self.userList.append(self.parent_window.server.userFromName(name))
            self.userList[len(self.userList) - 1].addChannel(self.name)
            self.tab.addUser(self.userList[len(self.userList) - 1], len(self.userList) - 1, firstJoin)
            return True
            
        else:
            return False

            
# /end addUser() ===================================================================================




# removeUser() =====================================================================================
# ==================================================================================================
#  This function removes a user from the
#  userlist and notifies the parent tab that
#  a user has been removed from the channel.
# ==================================================================================================
    def removeUser(self, name):

        if name != "":
        
            user_id = self.indexFromName(name)
            
            if user_id == -1:
                self.debug_handler.output("User <" + name + "> does not exist.", DEBUG_ERROR, self.tab.Id)
                return False

            try:  
                self.tab.removeUser(user_id)
                self.userList[user_id].leaveChannel(self.name)
                del self.userList[user_id] 
            except:
                self.debug_handler.output("Errors removing the user.", DEBUG_ERROR, self.tab.Id)
                return False   
                
            return True
        else:
            self.debug_handler.output("Invalid username to remove.", DEBUG_ERROR, self.tab.Id)
            return False   
# /end removeUser() ================================================================================



# updateUser() =====================================================================================
# ==================================================================================================
#  This function removes a user from the
#  userlist and notifies the parent tab that
#  a user has been removed from the channel.
# ==================================================================================================
    def updateUser(self, name):
        if name != "":
            if self.userFromName(name) == None:
                return False
            self.tab.updateUser(self.userFromName(name), self.indexFromName(name))
            return True
        else:
            return False
# /end updateUser() ================================================================================



# userFromName() ===================================================================================
# ==================================================================================================
#  Returns a user from the given
#  name (as a string).

    def userFromName(self, name):
    
        if name != "":
            for x in self.userList:
                if x.name == name:
                    return x
            return None
        else:
            self.parent_window.output_handler.output("user == NoneType, error getting user from name: channel.py", DEBUG_ERROR)
            return None
# /end userFromName() ===============================================================================



# indexFromName() ==================================================================================
# ==================================================================================================
#  Returns an index from a name.

    def indexFromName(self, name):
        increment = 0
        
        while len(self.userList) - 1 >= increment:
            if self.userList[increment].name == name:
                return increment
            else:
                increment = increment + 1
        self.parent_window.output_handler.output("index == -1, error getting index from username: channel.py", DEBUG_ERROR)
        return -1
# /end indexFromName() =============================================================================



# sendMessage() ====================================================================================
# ==================================================================================================
#  This function sends a "SAY" message to
#  a channel that the user is in.  This command
#  is always called by the owning tab.
# ==================================================================================================
    def sendMessage(self, msg):
        pass
            
# /end sendMessage() ===============================================================================



# sendExMessage() ==================================================================================
# ==================================================================================================
#  This function sends a "SAYEX" message to
#  a channel that the user is in.  This command
#  is always called by the owning tab.
# ==================================================================================================
    def sendExMessage(self, msg):
        pass
            
# /end sendExMessage() =============================================================================





# onReceiveMessage() ===============================================================================
# ==================================================================================================
#  This event is called when the channel
#  is sent a message from the server.  Anything
#  that the channel recieves from the server
#  that needs to be displayed will be sent
#  to this method.
# ==================================================================================================
    def onReceiveMessage(self, msg, command):
    
        if len(msg) > 2:
            unstriped_msg = msg[1]
            for x in msg[2:]:
                unstriped_msg = unstriped_msg + " " + x
        else:
            unstriped_msg = msg[1]    
           
        if command == "SAID":
            if self.parent_window.client.client_username == msg[0]:
                self.parent_window.output_handler.output(msg[0] + ": " + unstriped_msg, USER_MSG, self.tab.Id)
            else:
                self.parent_window.output_handler.output(msg[0] + ": ^0" + unstriped_msg, CHANNEL_MSG, self.tab.Id)
                
        elif command == "SAIDEX":
            self.parent_window.output_handler.output("^0" + msg[0] + " " + unstriped_msg, USER_MSG, self.tab.Id)
            
        elif command == "SAYPRIVATE":
            self.parent_window.output_handler.output("Sent to <" + msg[0] + ">: " + unstriped_msg, PRIVATE_MSG, self.tab.Id)
            if self.parent_window.battleroom != None:
                self.parent_window.output_handler.output("Sent to <" + msg[0] + ">: " + unstriped_msg, PRIVATE_MSG, -1)
        elif command == "SAIDPRIVATE":
            self.parent_window.output_handler.output("<" + msg[0] + ">: " + unstriped_msg, PRIVATE_MSG, self.tab.Id)
            if self.parent_window.battleroom != None:
                self.parent_window.output_handler.output("<" + msg[0] + ">: " + unstriped_msg, PRIVATE_MSG, -1)
        elif command == "SAIDBATTLE":
            if self.parent_window.client.client_username == msg[0]:
                self.parent_window.output_handler.output(msg[0] + ": " + unstriped_msg, USER_MSG, -1)
            else:
                self.parent_window.output_handler.output(msg[0] + ": ^0" + unstriped_msg, CHANNEL_MSG, -1)
                
        elif command == "SAIDBATTLEEX":
            self.parent_window.output_handler.output("^0" + msg[0] + " " + unstriped_msg, USER_MSG, -1)
            

            
# /end onReceiveMessage() ==========================================================================





