#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            battle.py
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


class battle:
# This class is the abstraction of the battle "object".
# It stores data about battles and is owned by the
# tabmanager object.

    name = ""               #The visible name of the server
    Id = 0                  #The internal ID used to identify this battle's location on the main list
    
    server_id = 0           #The battle id that the server uses to keep track of the battle
    battle_type = 0         #0= normal, 1=battle replay
    host = None             #The user hosting the game (see: user class)
    host_name = ""
    host_ip = ""            #Host ip
    port = 0                #Port that the host uses to accept connections
    natType = 0             #0=no nat transversal, 1=use some type of it
    
    maxplayers = 0          #Max number of players allowed in game
    players_string = ""     #String composed of number of players/max number of players - used for display
   
    passworded = False      #Is this game passworded?
    passworded_int = 0 
    
    hidden = 0              #Not implimented yet
    rank = 0                #Minimum rank?
    
    userList = []           #A list of instaces of the user class
    factionList = []        #The various factions (or sides) that this particular mod has
    
    mapName = ""            #Map being used
    modName = ""            #Mod being used
    
    lan = False             #Is this game a lan game?

    spectators = 0          #Number of spectators in game
    
    parent_window = None    #gui_lobby instance
    server = None           #server instance that owns this class
    
    
    
# __init__() =======================================================================================
# ==================================================================================================
#  The function that creates an instance
#  of the battle class.

    def __init__(self, parent, server, battle_id, battle_type, natType, host, hostip, port, maxplayers, password, rank, mapname, name, mod, lan=False):
    
        self.parent_window = parent
        self.server = server
        
        self.name = name
        self.server_id = battle_id
        self.battle_type = battle_type
        self.host = host
        self.host_name = host.name
        self.host_ip = hostip
        self.port = port
        self.natType = natType
        self.maxplayers = maxplayers

        self.passworded = password
        
        self.rank = rank
        self.mapName = mapname
        self.modName = mod
        
        self.userList = []
        self.factionList = []
        self.lan = lan
        self.userList.append(self.host)

        self.players_string = str(len(self.userList)) + "/" + str(self.maxplayers)
        
        images_names = self.parent_window.list_lobby_1_games.images_names
        
        if self.passworded:
            self.passworded_int = images_names["password"]
        else:
            self.passworded_int = images_names["password"] + 1
            
# /end __init__() ==================================================================================



# updateStatus() ===================================================================================
# ==================================================================================================
#  This function updates the battlestatus
#  of the battle.

    def updateStatus(self, status):
        pass
            
# /end updateStatus() ==============================================================================


# clean_up() =======================================================================================
# ==================================================================================================
#  This function cleans up the userlist

    def clean_up(self):
        while len(self.userList) - 1 >= 0:
            del self.userList[0]
        userList = []

          
# /end clean_up() ==================================================================================



# battleStarted() ==================================================================================
# ==================================================================================================
#  This returns True of the game is already started

    def battleStarted(self):
        return host.inGame()

          
# /end battleStarted() =============================================================================






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

        if command == "SAIDBATTLE":
            
            if self.parent_window.server.user.name == msg[0]:
                self.parent_window.output_handler.output(msg[0] + ": " + unstriped_msg, USER_MSG, -1)
            else:
                self.parent_window.output_handler.output(msg[0] + ": ^0" + unstriped_msg, CHANNEL_MSG, -1)
                
        elif command == "SAIDBATTLEEX":
            self.parent_window.output_handler.output("^0" + msg[0] + " " + unstriped_msg, USER_MSG, -1)
  

            
# /end onReceiveMessage() ==========================================================================



  #==========================================================================================================
  #==========================================================================================================
  #=========================================USER FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================




# addUser() ========================================================================================
# ==================================================================================================
#  This function adds a user to the userlist

    def addUser(self, name):
        
        if self.server.userFromName(name) != False:
            self.userList.append(self.server.userFromName(name))
            self.userList[len(self.userList) - 1].battle = True
            self.players_string = str(len(self.userList)) + "/" + str(self.maxplayers);
            
            self.parent_window.list_lobby_1_games.Sort()
            #self.parent_window.list_lobby_1_games.RefreshItem(self.parent_window.list_lobby_1_games.list.index(self))
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
                return False
            del self.userList[user_id]
            
            self.userList[len(self.userList) - 1].battle = False
   
            self.players_string = str(len(self.userList)) + "/" + str(self.maxplayers);
            self.parent_window.list_lobby_1_games.Sort()
            
            #self.parent_window.list_lobby_1_games.RefreshItem(self.parent_window.list_lobby_1_games.list.index(self))

            return True
        else:
            return False   
# /end removeUser() ================================================================================






# userFromName() ===================================================================================
# ==================================================================================================
#  Returns a user from the given
#  name (as a string).

    def userFromName(self, name):
    
        if name != "":
            for x in self.userList:
                if x.name == name:
                    return x
                    
        self.parent_window.output_handler.output("user == NoneType, error getting user from name: battle.py", DEBUG_ERROR)
        return None
# /end userFromName() ===============================================================================



# indexFromName() ==================================================================================
# ==================================================================================================
#  Returns an index from a name.

    def indexFromName(self, name):
    
        inc = 0

        for x in self.userList:
            if x.name == name:
                return inc
            inc += 1
            
        self.parent_window.output_handler.output("index == -1, error getting index from user <" + name + ">: battle.py", DEBUG_ERROR)  
        return -1
# /end indexFromName() =============================================================================
   
 

