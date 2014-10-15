#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            GLOBAL.py
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
 

ID_MENU_CONNECT = 1001
ID_MENU_EXIT = 1002
ID_MENU_CONFIGSPRING = 1003
ID_MENU_CONFIGCLIENT = 1004
ID_MENU_CREATECHAT = 1005
ID_MENU_JOINCHAT = 1006
ID_MENU_CREATEBATTLE = 1007
ID_MENU_ABOUT = 1008

ID_POPUP_USERS_NAME = 1101
ID_POPUP_USERS_STATUS = 1102
ID_POPUP_USERS_PRIVATEMSG = 1103
ID_POPUP_USERS_GETINFO = 1104
ID_POPUP_USERS_SETAWAY = 1105

ID_POPUP_CHANNEL_NAME = 1106
ID_POPUP_CHANNEL_LOGGING = 1107
ID_POPUP_CHANNEL_TIMESTAMP = 1108
ID_POPUP_CHANNEL_CLOSE = 1109

ID_TOOLBAR_CONNECT = 2001
ID_TOOLBAR_DISCONNECT = 2002
ID_TOOLBAR_CREATEBATTLE = 2003
ID_TOOLBAR_CONFIGSPRING = 2004
ID_TOOLBAR_CONFIGCLIENT = 2005



#DEBUG msg priority types==========================
#==================================================
DEBUG_CRITICAL = 1
DEBUG_ERROR = 2
DEBUG_MESSAGE = 3
DEBUG_USELESS = 4

#SERVER msg priority types=========================
#==================================================
SERVER_HIGH = 5
SERVER_LOW = 6
SERVER_OTHER = 7
SERVER_USELESS = 8

#CHANNEL msg priority types========================
#==================================================
CHANNEL_MSG = 9


#USER msg priority types===========================
#==================================================
USER_MSG = 10


#PRIVATE msg priority types========================
#==================================================
PRIVATE_MSG = 11


#ERROR msg priority types==========================
#==================================================
ERROR_MSG = 12


#OTHER msg priority types==========================
#==================================================
OTHER_MSG = 13

#MSGBOX types======================================
#==================================================
MSGBOX_NOTCONNECTED = 1
MSGBOX_NETCODE = 2
MSGBOX_EMPTYFIELDS = 3
MSGBOX_ERROR = 4
MSGBOX_CRITICAL_ERROR = 5
MSGBOX_EMPTYPASSWORDFIELDS = 6


#COLOR macros======================================
#==================================================
# ^ in front of any of these numbers will produce
# a different color.  I have no intent of parsing
# this out so that users can't utilize it.
COLOR_MACRO_CHANNEL = 0
COLOR_MACRO_USER = 1
COLOR_MACRO_PRIVATE = 2
COLOR_MACRO_SERVER = 3
COLOR_MACRO_ERROR = 4
COLOR_MACRO_DEBUG = 5
COLOR_MACRO_RED = 6
COLOR_MACRO_ORANGE = 7
COLOR_MACRO_BLUE = 8
COLOR_MACRO_GREEN = 9


#Default colors====================================
#==================================================
COLOR_CHANNEL_RED = 0
COLOR_CHANNEL_GREEN = 0
COLOR_CHANNEL_BLUE = 0

COLOR_USER_RED = 60
COLOR_USER_GREEN = 60
COLOR_USER_BLUE = 60

COLOR_PRIVATE_RED = 6
COLOR_PRIVATE_GREEN = 227
COLOR_PRIVATE_BLUE = 0

COLOR_SERVER_RED = 128
COLOR_SERVER_GREEN = 18
COLOR_SERVER_BLUE = 18

COLOR_DEBUG_RED = 29
COLOR_DEBUG_GREEN = 91
COLOR_DEBUG_BLUE = 193

COLOR_ERROR_RED = 225
COLOR_ERROR_GREEN = 0
COLOR_ERROR_BLUE = 0

#Defaults from gui_clSettings======================
#==================================================
DEFAULT_CUSTOMICON = False
DEFAULT_SHOWCUSTOM = True
DEFAULT_CREATELANTAB = False
DEFAULT_FACTION = False

DEFAULT_REMEMBERALL = True
DEFAULT_BLOCKPRIVATE = False
DEFAULT_ALTERNATEIP = ""
DEFAULT_SHOWDEBUG = False
DEFAULT_DONATEBANDWIDTH = False
DEFAULT_MAXUPLOAD = 10
DEFAULT_GAMEPORT = 8452
DEFAULT_BITPORT = 8452

#Defaults from gui_mpSettings======================
#==================================================
DEFAULT_TREEVIEWDIST = 1400
DEFAULT_TERRAINDETAIL = 40
DEFAULT_UNITDETAILDIST = 300
DEFAULT_GRASSDETAIL = 40
DEFAULT_PARTICLELIMIT = 8000
DEFAULT_MAXSOUNDS = 48

DEFAULT_3DTREES = True
DEFAULT_HIGHRESCLOUDS = False
DEFAULT_DYNAMICCLOUDS = False
DEFAULT_REFLECTIVEWATER = False
DEFAULT_FULLSCREEN = True
DEFAULT_COLOREDELEVATION = False
DEFAULT_INVERTMOUSE = False
DEFAULT_SHADOWS = False

DEFAULT_SHADOWMAP = 1024
DEFAULT_TEXTUREQUALITY = 1
DEFAULT_RESOLUTION = 800

#Defaults from gui_battleroom======================
#==================================================
DEFAULT_MAXUNITS = 500              # Max number of units allowed per player
DEFAULT_STARTENERGY = 1000  		# Starting energy amount
DEFAULT_STARTMETAL = 1000   		# Starting metal amount
DEFAULT_HANDICAPS = False   		# Allow handicaps?
DEFAULT_HANDICAPS_HOST = False  	# Allow only the host to change handicaps
DEFAULT_MINSPEED = -4   			# The minimum speed the game is allowed to operate at
DEFAULT_MAXSPEED = 4    			# The maximum speed the game is allowed to operate at

DEFAULT_MAP = "FloodedDesert.smd"   # Default map used
DEFAULT_MOD = "Spring"              # The unique name of the mod to be loaded
DEFAULT_LOS = False                 # LOS enabled by default?
DEFAULT_TERRAIN = "Visible"         # Not used at the moment
DEFAULT_REMEMBERSTRUCTURES = True	# Remember buildings out of LOS
DEFAULT_TIDAL = 25                  # Tidal strength of the map
DEFAULT_GRAVITY = 150			    # Strength of the gravity on the map
DEFAULT_MAXMETAL = 4                # How much metal exists on the map (0-7, 7 being the most)
DEFAULT_EXTRACTRADIUS = 500 		# Extraction radius of metal extractors
DEFAULT_MINWIND = 5     			# Minimum wind possible on the map
DEFAULT_MAXWIND = 20        		# Maximum wind possible on the map
DEFAULT_HARDNESS = 20    			# Hardness of the map
DEFAULT_STARTPOS = 0                # 0=Map default, 1=In order, 2=Choose in-game
DEFAULT_WINCONDITION = 0    		# 0=Commander death, 1=Buildings razed, 2=Units killed, 3=Map default



