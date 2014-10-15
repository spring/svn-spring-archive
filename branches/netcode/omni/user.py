#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            user.py
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

from GLOBAL import *


class user:
# This class is the abstraction of the user "object".
# It stores data about users and keeps track of status,
# cpu, and what they are doing.

    name = ""
    country = ""
    cpu = 0
    ip = ""
    status = 0                  #default user status

    channelList = []            #the channels that the user belongs to
    
    lan = False
    battle = False              #is the user in a battle?
    battle_status = 16778240    #default battle status
    
    status_image = 2
    
    rank_image = 0
    
    parent_window = None        #gui_lobby instance
    server = None               #server instance that owns this user
 
    
# __init__() =======================================================================================
# ==================================================================================================
#  The function that creates a new user
#  and initializes some variables.
# ==================================================================================================
    def __init__(self, parent, server, name, country, cpu, ip, lan=False):
    
        self.parent_window = parent
        self.server = server
        self.lan = lan
        self.cpu = cpu
        self.name = name
        self.country = country.lower()
        self.ip = ip
        
        self.channelList = []
            
# /end __init__() ==================================================================================



# addChannel() =====================================================================================
# ==================================================================================================
#  This function adds a channel to the
#  channel list that the user belongs to.

    def addChannel(self, channel):
        if channel != "":
            self.channelList.append(channel)
            
# /end addChannel() ================================================================================



# leaveChannel() ===================================================================================
# ==================================================================================================
#  This function adds a channel to the
#  channel list that the user belongs to.

    def leaveChannel(self, channel):
        if channel != "":
            index = self.indexFromChannel(channel)
            if index != -1:
                del self.channelList[index]
            else:
                self.debug_handler.output("Errors removing channel from users channel list (user.py).", DEBUG_ERROR, self.tab.Id)
            
# /end leaveChannel() ==============================================================================



# indexFromName() ==================================================================================
# ==================================================================================================
#  Returns an index from a name.

    def indexFromChannel(self, name):
        inc = 0
        
        for x in self.channelList:
            if x == name:
                return inc
            inc += 1
            
        self.parent_window.output_handler.output("index == -1, error getting index from channel name <" + name + ">: user.py", DEBUG_ERROR)    
        return -1
# /end indexFromName() =============================================================================



# cleanChannels() ==================================================================================
# ==================================================================================================
#  Cleans up the channel list each user has

    def cleanChannels(self):
        for x in self.channelList:
            del x
            
        self.channelList = []

# /end cleanChannels() =============================================================================


  #==========================================================================================================
  #==========================================================================================================
  #=========================================USER FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================
  

# updateStatus() ===================================================================================
# ==================================================================================================
#  This function adds a user to the userlist
#  and notifies the tab class to update its
#  user list.

    def updateStatus(self, status):
        ingame = self.inGame()
        self.status = status
        
        if self.inGame() != ingame:
            battle = self.server.battleFromHostName(self.name)
            if battle != None:
                t = battle.battleStarted()
        
        t = self.getRank()
        
        for x in self.channelList:
            x.tab.tab_listPeople.Sort()
            
        '''
        if self.server.user.name == self.name:
            self.parent_window.list_lobby_1_games.Sort(1)
        '''
            
# /end updateStatus() ==============================================================================



# getClientStatus() ================================================================================
# ==================================================================================================
#  Returns the client_status variable

    def getClientStatus(self):
        return self.status
            
# /end getClientStatus() ===========================================================================




# isAway() =========================================================================================
# ==================================================================================================
#  Returns true if the user is "away",
#  and false if they are not.

    def isAway(self):
        status = self.status
        bitmask = 2
        
        status = bitmask & status
        
        
        #Bitwise AND
        #===================
        #2      = 000010
        #status = 010110
        
        #returns= 000010
        
        
        if status != 0:
            return True
        else:
            return False
            
# /end isAway() ====================================================================================



# inGame() =========================================================================================
# ==================================================================================================
#  Returns true if the user is in a game,
#  and false if they are not.

    def inGame(self):
        status = self.status
        bitmask = 1
        
        status = bitmask & status
        if status != 0:
            return True
        else:
            return False
            
# /end inGame() ====================================================================================


# getRank() ========================================================================================
# ==================================================================================================
#  Returns the users rank and updates the self.rank_image variable.

    def getRank(self):
            
        status = self.status
        bitmask = 0x1C
        
        status = bitmask & status
        status = status >> 2
        
        if self.admin() == False:
            self.rank_image = status + 5
        else:
            self.rank_image = 10

        return status
            
# /end getRank() ===================================================================================



# admin() ==========================================================================================
# ==================================================================================================
#  Returns true if the user is admin

    def admin(self):
        status = self.status
        bitmask = 32
        
        status = bitmask & status
        if status != 0:
            return True
        else:
            return False
            
# /end admin() =====================================================================================









  #==========================================================================================================
  #==========================================================================================================
  #=========================================BATTLE FUNCTIONS=================================================
  #==========================================================================================================
  #==========================================================================================================



# updateBattleStatus() =============================================================================
# ==================================================================================================
#  This function updates the battle_status
#  variable with the appropriate int32

    def updateBattleStatus(self, status):
        self.battle_status = status
         
# /end updateBattleStatus() ========================================================================


# getBattleStatus() ================================================================================
# ==================================================================================================
#  Returns the battle_status variable

    def getBattleStatus(self):
        return self.battle_status
            
# /end getBattleStatus() ===========================================================================




# getReady() =======================================================================================
# ==================================================================================================
#  Returns true if the user is
#  "ready."
    def getReady(self):
        status = self.battle_status
        bitmask = 2
        
        status = bitmask & status
        
        if status != 0:
            return True
        else:
            return False
            
# /end getReady() ==================================================================================



# getTeamNumber() ==================================================================================
# ==================================================================================================
#  Returns the team # of the user.
#  b2..b5
#  Number from 0-15 for a total of 16 teams.
    def getTeamNumber(self):
        status = self.battle_status
        bitmask = 60
        
        status = bitmask & status
        status = status >> 2
        
        
        return status
            
# /end getTeamNumber() =============================================================================



# getAllyTeam() ====================================================================================
# ==================================================================================================
#  Returns the ally team # of the user.
#  b6..b9
#  Number from 0-15 for a total of 16 allied teams.
    def getAllyTeam(self):
        status = self.battle_status
        bitmask = 960
        
        status = bitmask & status
        status = status >> 6
        
        
        return status
            
# /end getAllyTeam() ===============================================================================



# getSpectator() ===================================================================================
# ==================================================================================================
#  Returns if the player is a spectator or not.
#  b10
#  0 = spectator, 1 = normal player
    def getSpectator(self):
        status = self.battle_status
        bitmask = 1024
        
        status = bitmask & status
        
        
        if status != 0:
            return True
        else:
            return False
            
# /end getSpectator() ==============================================================================




# getHandicap() ====================================================================================
# ==================================================================================================
#  Returns if the handicap amount

    def getHandicap(self):
        status = self.battle_status
        bitmask = 130048
        
        status = bitmask & status
        status = status >> 10

        return status
            
# /end getHandicap() ===============================================================================



# getTeamColor() ===================================================================================
# ==================================================================================================
#  Returns team color index.
#  b18..b21
#  A number 0-9 that is defined in TAPallete.cpp

    def getTeamColor(self):
        status = self.battle_status
        bitmask = 1966080
        
        status = bitmask & status
        status = status >> 17
        
        
        return status
            
# /end getTeamColor() ==============================================================================




# getSyncStatus() ==================================================================================
# ==================================================================================================
#  Returns the sync status.
#  b22..b23
#  0 = unknown, 1 = synced, 2 = unsynced

    def getSyncStatus(self):
        status = self.battle_status
        bitmask = 6291456
        
        status = bitmask & status
        status = status >> 21
        
        
        return status
            
# /end getSyncStatus() =============================================================================



# getFaction() =====================================================================================
# ==================================================================================================
#  Returns the side index that is currently selected.
#  b24..b27
#  default: 0-arm, 1-core
    def getFaction(self):
        status = self.battle_status
        bitmask = 125829120
        
        status = bitmask & status
        status = status >> 23
        
        
        return status
            
# /end getFaction() ================================================================================
