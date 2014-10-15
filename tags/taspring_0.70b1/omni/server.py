#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            server.py
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

import os,wx,misc,time,operator

from tab import *
from user import *
from battle import *
from GLOBAL import *


class server:
# This class is the server data management class.
# It houses a management system for all the users in the
# server and all of the battles currently in progress.

    userList = []
    battleList = []
    
    address =  ""
    port = 0
    motd = ""
    user = None
    
    connected = False
    
    parent_window = None
    

# __init__() =======================================================================================
# ==================================================================================================
#  The function that initializes the server
#  class.  It initializes the variables in the
#  class and updates the parent_window instance.
# ==================================================================================================
    def __init__(self, parent, address="taspringmaster.clan-sy.com", port=8200):

        self.parent_window = parent
        self.address = address
        self.port = port
        
        self.userList = []
        self.battleList = []
        
# /end __init__() ==================================================================================
   




# disconnect() =====================================================================================
# ==================================================================================================
#  This function deletes the user list and
#  the battleroom when the client is 
#  disconnected from the server.
# ==================================================================================================
    def disconnect(self):
        while len(self.userList) - 1 >= 0:
            del self.userList[0]
            
        while len(self.battleList) - 1 >= 0:
            del self.battleList[0]
            
        self.parent_window.list_lobby_1_games.DeleteAllItems()

        self.connected = False
          
# /end disconnect() ================================================================================







  #==========================================================================================================
  #==========================================================================================================
  #=========================================BATTLE FUNCTIONS=================================================
  #==========================================================================================================
  #==========================================================================================================



# addBattle() ======================================================================================
# ==================================================================================================
#  This function adds a battle to the battlelist

    def addBattle(self, battle_id, battle_type, founder, host_ip, port, maxplayers, password, rank, mapname, name, mod, lan=False):

        exists = False
        
        host = self.userFromName(founder)
        if host == None:
            print(founder)
            return False
            
        #does this battle already exist? if so, do not add it again!
        for x in self.battleList:
            if x.server_id == int(battle_id):
                x.name = name
                x.host = host
                x.host_ip = host_ip
                x.port = int(port)
                x.maxplayers = int(maxplayers)
                x.passworded = bool(int(password))
                x.rank = int(rank)
                x.mapName = mapname
                x.modName = mod
                x.lan = lan
                x.battle_type = int(battle_type)
                exists = True
                
        if not exists:
            self.battleList.append(battle(self.parent_window, self, int(battle_id), int(battle_type), host, host_ip, int(port), int(maxplayers), bool(int(password)), rank, mapname, name, mod, lan))

        index = self.indexFromBattleId(int(battle_id))
        if index == -1:
            return False
        self.battleList[index].Id = index  
        
        # Update the list display (set more elements, and sort which also refreshes)
        self.parent_window.list_lobby_1_games.SetItemCount(len(self.battleList))
        self.parent_window.list_lobby_1_games.Sort()
            
        return True
            
# /end addBattle() =================================================================================




# removeBattle() ===================================================================================
# ==================================================================================================
#  This function removes a battle frome
#  the battleList.

    def removeBattle(self, battle_id):
        try:
            if battle_id != 0:
                index = self.indexFromBattleId(battle_id)
                battle = self.battleFromBattleId(battle_id)
                
                if battle == None or index == -1:
                    return False
                        
                battle.clean_up()
                # Eliminate the battle from the list display (by changing here the count and
                # refreshing)
                self.parent_window.list_lobby_1_games.SetItemCount(len(self.battleList[index]-1))
                
                del self.battleList[index]
                
                self.parent_window.list_lobby_1_games.RefreshItems(0,len(self.battleList))
                
                return True
            else:
                return False   
        except:
            raise
            return False
# /end removeBattle() ==============================================================================




# indexFromBattleId() ==============================================================================
# ==================================================================================================
#  Returns the index of the battle
#  in the self.battleList variable.

    def indexFromBattleId(self, battle_id):
        inc = 0

        for x in self.battleList:
            if x.server_id == int(battle_id):
                return inc
            inc += 1
            
        self.parent_window.output_handler.output("index == -1, error finding index from battle_id: server.py", DEBUG_ERROR)
        return -1
# /end indexFromBattleId() =========================================================================





# battleFromBattleId() =============================================================================
# ==================================================================================================
#  Returns an index from a name.

    def battleFromBattleId(self, battle_id):
    
        for x in self.battleList:
            if x.server_id == int(battle_id):
                return x
                
        self.parent_window.output_handler.output("battle \""+str(battle_id)+"\" not found", DEBUG_ERROR)
        return None

# /end battleFromBattleId() ========================================================================





# joinBattle() =====================================================================================
# ==================================================================================================
#  Returns an index from a name.

    def joinBattle(self, index):
        battle = self.battleList[index]
        
        if battle == None:
            misc.CreateMessageBox(self.parent_window, MSGBOX_ERROR, str(index))
            
        if battle.passworded == True:
            #ask for the password using a dialog
            getpass = wx.TextEntryDialog(self.parent_window, "Password needed to join \"" + battle.name + "\":", "Enter password", "", wx.OK|wx.CANCEL)
            choice = getpass.ShowModal()
            
            if choice == wx.ID_OK:
            
                if getpass.GetValue() != "":
                
                    password = getpass.GetValue()
                    #config.Write("/Player/Name", self.client_username)

                    getpass.Close(True)
                
                else:
                    misc.CreateMessageBox(self.parent_window, MSGBOX_ERROR, "Password entered is invalid.")
                    getpass.Close(True)
                    return None
                    
            else:
                getpass.Close(True)
                return False
                
            self.parent_window.client.send("JOINBATTLE " + str(battle.server_id) + " " + password)
        else:
            self.parent_window.client.send("JOINBATTLE " + str(battle.server_id))
        return True
        
# /end joinBattle() ================================================================================







  #==========================================================================================================
  #==========================================================================================================
  #=========================================USER FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================


# addUser() ========================================================================================
# ==================================================================================================
#  This function adds a user to the userlist

    def addUser(self, name, country, cpu, ip, lan=False):
        if name != "":
        
            #does this user already exist? if so, do not add it again!
            for x in self.userList:
                if x.name == name:
                    x.country = country
                    x.cpu = cpu
                    x.ip = ip
                    x.lan = lan
                    return True
                    
            self.userList.append(user(self.parent_window, self, name, country, cpu, ip, lan))
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
            self.parent_window.output_handler.output("user == NoneType, cannot find user from name <" + name + ">: server.py", DEBUG_ERROR)
            return None
        else:
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
                
        self.parent_window.output_handler.output("index == -1, cannot find index from name <" + name + ">: server.py", DEBUG_ERROR)
        return -1
# /end indexFromName() =============================================================================
   
 
