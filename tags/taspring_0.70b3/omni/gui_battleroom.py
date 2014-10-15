# -*- coding: UTF-8 -*-

#======================================================
 #            gui_battleroom.py
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

import os,wx,misc,socket,unitsync

from GLOBAL import *
from gui_units import gui_units

ID_BUTTON_SEND = 101
ID_BUTTON_SERVER_STARTGAME = 102
ID_BUTTON_MAP_DEFAULTS = 103
ID_BUTTON_MAP_DISABLEDUNITS = 104
ID_BUTTON_MOD_UPDATESETTING = 105
ID_BUTTON_MOD_DEFAULTSETTING = 106
ID_BUTTON_MOD_DEFAULTS = 107

ID_TEXT_CHATAREA = 201
ID_TEXT_MSG = 202
ID_TEXT_MAXUNITS = 203
ID_TEXT_STARTENERGY = 204
ID_TEXT_STARTMETAL = 205

ID_CHECKBOX_READY1 = 301
ID_CHECKBOX_READY2 = 302
ID_CHECKBOX_READY3 = 303
ID_CHECKBOX_READY4 = 304
ID_CHECKBOX_READY5 = 305
ID_CHECKBOX_READY6 = 306
ID_CHECKBOX_READY7 = 307
ID_CHECKBOX_READY8 = 308
ID_CHECKBOX_READY9 = 309
ID_CHECKBOX_READY10 = 310
ID_CHECKBOX_READY11 = 311
ID_CHECKBOX_READY12 = 312
ID_CHECKBOX_SERVER_HANDICAPS = 313
ID_CHECKBOX_SERVER_MODIFYHANDICAPS = 314
ID_CHECKBOX_SERVER_REMEMBERLOS = 315

#======================================================================
#===========WARNING: Some code below has been modified!================
#======================================================================

# Always read the documentation carefully before updating code from the py.gen folder!

class gui_battleroom(wx.Frame):

    battle = None
    battle_id = 0
    
    startMetal = 0
    startEnergy = 0
    maxUnits = 0
    startPos = 0
    gameEnd = 0
    limitdgun = 0
    diminishingMM = 0
    ghostBuildings = 0
    
    host_hashcode = 0
    
    currentUser = None
    host = None
    
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_battleroom.__init__
        kwds["style"] = wx.DEFAULT_FRAME_STYLE
        wx.Frame.__init__(self, *args, **kwds)
        self.notebook_battleroom_settings = wx.Notebook(self, -1, style=0)
        self.panel_battleroom_mod = wx.Panel(self.notebook_battleroom_settings, -1)
        self.panel_battleroom_map = wx.Panel(self.notebook_battleroom_settings, -1)
        self.panel_battleroom_server = wx.Panel(self.notebook_battleroom_settings, -1)

	#===============================================================================
	# Added os.path.join() to make it so that Windows users can see the images too!
        self.label_battleroom_players_status = wx.StaticText(self, -1, "Name")
        self.bitmap_battleroom_players_icon_player1 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player1 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player2 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player2 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player3 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player3 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player4 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player4 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player5 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player5 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player6 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player6 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player7 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player7 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player8 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player8 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player9 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player9 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player10 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player10 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player11 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player11 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player12 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player12 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player13 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player13 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player14 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player14 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player15 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player15 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.bitmap_battleroom_players_icon_player16 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","arm.png"), wx.BITMAP_TYPE_ANY))
        self.combo_battleroom_players_status_player16 = wx.ComboBox(self, -1, choices=["Open", "Closed"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        
	# /end edits ===================================================================


        self.label_battleroom_players_faction = wx.StaticText(self, -1, "Faction")
        self.combo_battleroom_players_faction_player1 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player2 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player3 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player4 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player5 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player6 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player7 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player8 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player9 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player10 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player11 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player12 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player13 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player14 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player15 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_faction_player16 = wx.ComboBox(self, -1, choices=["Arm", "Core", "Random", "Observer"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        
        self.label_battleroom_players_sharedArmy = wx.StaticText(self, -1, "Shared Army")
        self.combo_battleroom_players_sharedArmy_player1 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player2 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player3 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player4 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player5 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player6 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player7 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player8 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player9 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player10 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player11 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player12 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player13 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player14 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player15 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_sharedArmy_player16 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
    
        self.label_battleroom_players_team = wx.StaticText(self, -1, "Alliance")
        self.combo_battleroom_players_team_player1 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player2 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player3 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player4 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player5 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player6 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player7 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player8 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player9 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player10 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player11 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player12 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player13 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player14 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player15 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        self.combo_battleroom_players_team_player16 = wx.ComboBox(self, -1, choices=["None", "1", "2", "3", "4", "5", "6","7","8","9","10","11","12","13","14","15","16"], style=wx.CB_DROPDOWN|wx.CB_READONLY)
        
        self.label_battleroom_players_handicap = wx.StaticText(self, -1, "Handicap")
        self.spin_battleroom_players_handicap_player1 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player2 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player3 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player4 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player5 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player6 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player7 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player8 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player9 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player10 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player11 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player12 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player13 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player14 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player15 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        self.spin_battleroom_players_handicap_player16 = wx.SpinCtrl(self, -1, "0", min=-10, max=10)
        
        self.label_battleroom_players_ready = wx.StaticText(self, -1, "Ready")
        self.checkbox_battleroom_ready_player1 = wx.CheckBox(self, 301, "")
        self.checkbox_battleroom_ready_player2 = wx.CheckBox(self, 302, "")
        self.checkbox_battleroom_ready_player3 = wx.CheckBox(self, 303, "")
        self.checkbox_battleroom_ready_player4 = wx.CheckBox(self, 304, "")
        self.checkbox_battleroom_ready_player5 = wx.CheckBox(self, 305, "")
        self.checkbox_battleroom_ready_player6 = wx.CheckBox(self, 306, "")
        self.checkbox_battleroom_ready_player7 = wx.CheckBox(self, 307, "")
        self.checkbox_battleroom_ready_player8 = wx.CheckBox(self, 308, "")
        self.checkbox_battleroom_ready_player9 = wx.CheckBox(self, 309, "")
        self.checkbox_battleroom_ready_player10 = wx.CheckBox(self, 310, "")
        self.checkbox_battleroom_ready_player11 = wx.CheckBox(self, 311, "")
        self.checkbox_battleroom_ready_player12 = wx.CheckBox(self, 312, "")
        self.checkbox_battleroom_ready_player13 = wx.CheckBox(self, 312, "")
        self.checkbox_battleroom_ready_player14 = wx.CheckBox(self, 312, "")
        self.checkbox_battleroom_ready_player15 = wx.CheckBox(self, 312, "")
        self.checkbox_battleroom_ready_player16 = wx.CheckBox(self, 312, "")
        

	#===============================================================================
	# Added os.path.join() to make it so that Windows users can see the images too!
        self.label_battleroom_players_sync = wx.StaticText(self, -1, "Sync")
        self.bitmap_battleroom_players_sync_player1 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player2 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player3 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player4 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player5 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player6 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player7 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player8 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player9 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player10 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player11 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player12 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player13 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player14 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player15 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_sync_player16 = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/battleroom/","sync-trying.png"), wx.BITMAP_TYPE_ANY))
        

        self.label_battleroom_players_ping = wx.StaticText(self, -1, "Ping")
        self.bitmap_battleroom_players_ping_player1 = wx.StaticBitmap(self, 201, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player2 = wx.StaticBitmap(self, 202, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player3 = wx.StaticBitmap(self, 203, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player4 = wx.StaticBitmap(self, 204, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player5 = wx.StaticBitmap(self, 205, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player6 = wx.StaticBitmap(self, 206, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player7 = wx.StaticBitmap(self, 207, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player8 = wx.StaticBitmap(self, 208, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player9 = wx.StaticBitmap(self, 209, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player10 = wx.StaticBitmap(self, 210, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player11 = wx.StaticBitmap(self, 211, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player12 = wx.StaticBitmap(self, 212, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player13 = wx.StaticBitmap(self, 212, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player14 = wx.StaticBitmap(self, 212, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player15 = wx.StaticBitmap(self, 212, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        self.bitmap_battleroom_players_ping_player16 = wx.StaticBitmap(self, 212, wx.Bitmap(os.path.join("resource/battleroom/","good-ping-final.png"), wx.BITMAP_TYPE_ANY))
        
	# /end edits ===================================================================



        self.text_battleroom_players_chatarea = wx.TextCtrl(self, 201, "", style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_AUTO_URL)
        self.text_battleroom_players_msgbox = wx.TextCtrl(self, 202, "", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.button_battleroom_players_sendmsg = wx.Button(self, 101, "Send")
        self.label_battleroom_server_battleName = wx.StaticText(self.panel_battleroom_server, -1, "Battle")
        self.text_battleroom_server_nameData = wx.TextCtrl(self.panel_battleroom_server, -1, "YOYOYOYO join ups!", style=wx.TE_PROCESS_TAB)
        self.label_battleroom_server_mapName = wx.StaticText(self.panel_battleroom_server, -1, "Map")
        self.text_battleroom_server_map = wx.TextCtrl(self.panel_battleroom_server, -1, "Flooded Desert 10x10", style=wx.TE_PROCESS_TAB|wx.TE_READONLY)
        self.label_battleroom_server_modName = wx.StaticText(self.panel_battleroom_server, -1, "Mod")
        self.text_battleroom_server_mod = wx.TextCtrl(self.panel_battleroom_server, -1, "Spring", style=wx.TE_PROCESS_TAB|wx.TE_READONLY)
        self.label_battleroom_server_maxUnits = wx.StaticText(self.panel_battleroom_server, -1, "Max Units")
        self.text_battleroom_server_maxUnitsData = wx.TextCtrl(self.panel_battleroom_server, 203, "500", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.label_battleroom_server_startEnergy = wx.StaticText(self.panel_battleroom_server, -1, "Start Energy")
        self.text_battleroom_server_startEnergyData = wx.TextCtrl(self.panel_battleroom_server, 204, "1000", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.label_battleroom_server_startMetal = wx.StaticText(self.panel_battleroom_server, -1, "Start Metal")
        self.text_battleroom_server_startMetalData = wx.TextCtrl(self.panel_battleroom_server, 205, "1000", style=wx.TE_PROCESS_ENTER|wx.TE_PROCESS_TAB)
        self.checkbox_battleroom_server_handicap = wx.CheckBox(self.panel_battleroom_server, 313, "Enable handicaps")
        self.checkbox_battleroom_server_hostModifiesHandicaps = wx.CheckBox(self.panel_battleroom_server, 314, "Only host can modify handicaps")
        self.label_battleroom_map_startPos = wx.StaticText(self.panel_battleroom_server, -1, "Start Position")
        self.choice_battleroom_map_startPosData = wx.Choice(self.panel_battleroom_server, -1, choices=["Fixed", "Random", "Choose in-game"])
        self.label_battleroom_map_winConditions = wx.StaticText(self.panel_battleroom_server, -1, "Win Condition")
        self.choice_battleroom_map_winConditionData = wx.Choice(self.panel_battleroom_server, -1, choices=["Normal", "All units"])
        self.checkbox_battleroom_server_rememberBuildingsLOS = wx.CheckBox(self.panel_battleroom_server, 315, "Remember buildings out of LOS")
        self.checkbox_battleroom_server_limitdgunData = wx.CheckBox(self.panel_battleroom_server, 315, "Limit dgun")
        self.button_battleroom_server_startGame = wx.Button(self.panel_battleroom_server, 102, "Start Game")


	#===============================================================================
	# Added os.path.join() to make it so that Windows users can see the images too!
        self.bitmap_battleroom_map_preview = wx.StaticBitmap(self.panel_battleroom_map, -1, wx.Bitmap(os.path.join("resource/", "minimap-placeholder.png"), wx.BITMAP_TYPE_ANY))
	# /end edits ===================================================================


        self.choice_battleroom_map_mapData = wx.Choice(self.panel_battleroom_map, -1, choices=["FloodedDesert.smf", ""])
        self.label_battleroom_map_positions = wx.StaticText(self.panel_battleroom_map, -1, "Positions: ")
        self.label_battleroom_map_positionsData = wx.StaticText(self.panel_battleroom_map, -1, "4")
        self.label_battleroom_map_size = wx.StaticText(self.panel_battleroom_map, -1, "Map Size: ")
        self.label_battleroom_map_sizeData = wx.StaticText(self.panel_battleroom_map, -1, "8192 x 8192")
        self.label_battleroom_map_description = wx.StaticText(self.panel_battleroom_map, -1, "Description:")
        self.text_battleroom_map_description = wx.TextCtrl(self.panel_battleroom_map, -1, "", style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_AUTO_URL)
        self.label_battleroom_map_tidal = wx.StaticText(self.panel_battleroom_map, -1, "Tidal Strength")
        self.spin_battleroom_map_tidalData = wx.SpinCtrl(self.panel_battleroom_map, -1, "25", min=0, max=40)
        self.label_battleroom_map_gravity = wx.StaticText(self.panel_battleroom_map, -1, "Gravity")
        self.spin_battleroom_map_gravityData = wx.SpinCtrl(self.panel_battleroom_map, -1, "150", min=25, max=300)
        self.label_battleroom_map_maxMetal = wx.StaticText(self.panel_battleroom_map, -1, "Max Metal")
        self.spin_battleroom_map_maxMetalData = wx.SpinCtrl(self.panel_battleroom_map, -1, "4", min=0, max=7)
        self.label_battleroom_map_extractorRadius = wx.StaticText(self.panel_battleroom_map, -1, "Extractor Radius")
        self.spin_battleroom_map_extractorRadiusData = wx.SpinCtrl(self.panel_battleroom_map, -1, "500", min=50, max=1000)
        self.label_battleroom_map_minWind = wx.StaticText(self.panel_battleroom_map, -1, "Min Wind")
        self.spin_battleroom_map_minWindData = wx.SpinCtrl(self.panel_battleroom_map, -1, "5", min=0, max=20)
        self.label_battleroom_map_maxWind = wx.StaticText(self.panel_battleroom_map, -1, "Max Wind")
        self.spin_battleroom_map_maxWindData = wx.SpinCtrl(self.panel_battleroom_map, -1, "20", min=20, max=40)
        self.button_battleroom_map_revertToDefaults = wx.Button(self.panel_battleroom_map, 103, "Revert to Defaults")
        self.button_battleroom_map_disabledUnits = wx.Button(self.panel_battleroom_map, 104, "Disabled Units")


	#===============================================================================
	# Added os.path.join() to make it so that Windows users can see the images too!
        self.bitmap_battleroom_mod_preview = wx.StaticBitmap(self.panel_battleroom_mod, -1, wx.Bitmap(os.path.join("resource/", "mod-spring-logo.png"), wx.BITMAP_TYPE_ANY))
	# /end edits ===================================================================


        self.choice_battleroom_mod_modData = wx.Choice(self.panel_battleroom_mod, -1, choices=["Spring - Version 1.0", ""])
        self.label_battleroom_mod_fileList = wx.StaticText(self.panel_battleroom_mod, -1, "Files used:")
        self.tree_battleroom_mod_fileList = wx.TreeCtrl(self.panel_battleroom_mod, -1, style=wx.TR_HAS_BUTTONS|wx.TR_NO_LINES|wx.TR_LINES_AT_ROOT|wx.TR_MULTIPLE|wx.TR_MULTIPLE|wx.TR_DEFAULT_STYLE|wx.SUNKEN_BORDER)
        self.label_battleroom_mod_description = wx.StaticText(self.panel_battleroom_mod, -1, "Description:")
        self.text_battleroom_mod_description = wx.TextCtrl(self.panel_battleroom_mod, -1, "", style=wx.TE_MULTILINE|wx.TE_READONLY|wx.TE_AUTO_URL)
        self.label_battleroom_mod_settings = wx.StaticText(self.panel_battleroom_mod, -1, "Mod settings:")
        self.list_battleroom_mod_settings = wx.ListCtrl(self.panel_battleroom_mod, -1, style=wx.LC_REPORT|wx.LC_SINGLE_SEL|wx.SUNKEN_BORDER)
        self.text_battleroom_mod_settingInputData = wx.TextCtrl(self.panel_battleroom_mod, -1, "", style=wx.TE_PROCESS_ENTER)
        self.button_battleroom_mod_updateSetting = wx.Button(self.panel_battleroom_mod, 105, "Update")
        self.button_battleroom_mod_defaultSetting = wx.Button(self.panel_battleroom_mod, 106, "Default")
        self.button_battleroom_mod_revertToDefaults = wx.Button(self.panel_battleroom_mod, 107, "Revert to Defaults")

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

    	#wx.EVT_SCROLL_THUMBTRACK(self, self.OnSliderScroll)
    	#wx.EVT_SCROLL_THUMBTRACK(self, self.OnSliderScroll)
    	
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_server_handicap.GetId(), self.OnHandicap)
    	
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player1.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player2.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player3.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player4.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player5.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player6.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player7.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player8.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player9.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player10.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player11.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player12.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player13.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player14.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player15.GetId(), self.OnReady)
    	wx.EVT_CHECKBOX(self, self.checkbox_battleroom_ready_player16.GetId(), self.OnReady)
        
    	wx.EVT_BUTTON(self, self.button_battleroom_map_disabledUnits.GetId(), self.OnOpenDisabledUnits)
    	
    	wx.EVT_TEXT_ENTER(self, self.text_battleroom_players_msgbox.GetId(), self.OnSendMessage)
    	
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
    	self.SaveConfig()
    	if self.GetParent().server.battleFromBattleId(self.battle.server_id) != None:
    	   self.GetParent().client.send("LEAVEBATTLE")
    	   
        self.battle = None
        
    	self.Destroy()
# /end OnClose() ===================================================================================




# OnHandicap() =====================================================================================
# ==================================================================================================
#  Event fires when the "enable handicaps" checkbox is checked...

    def OnHandicap(self, event):
    	if self.checkbox_battleroom_server_handicap.GetValue() == True:
    		self.checkbox_battleroom_server_hostModifiesHandicaps.Enable(True)
    	else:
    		self.checkbox_battleroom_server_hostModifiesHandicaps.Enable(False)
    		self.checkbox_battleroom_server_hostModifiesHandicaps.SetValue(False)
    		
# /end OnHandicap() ================================================================================



# OnReady() ========================================================================================
# ==================================================================================================
#  Event fires when the "Ready" checkbox is clicked.

    def OnReady(self, event):
        userNumber = self.battle.indexFromName(self.currentUser.name)
        
        exec("ready = self.checkbox_battleroom_ready_player" + str(userNumber))
        exec("status = self.combo_battleroom_players_status_player" + str(userNumber))
        exec("faction = self.combo_battleroom_players_faction_player" + str(userNumber))
        exec("sharedArmy = self.combo_battleroom_players_sharedArmy_player" + str(userNumber))
        exec("team = self.combo_battleroom_players_team_player" + str(userNumber))
        exec("handicap = self.spin_battleroom_players_handicap_player" + str(userNumber))

        status.Enable(not ready.GetValue())
        faction.Enable(not ready.GetValue())
        sharedArmy.Enable(not ready.GetValue())
        team.Enable(not ready.GetValue())

        status = self.battle.userList[userNumber - 1].battle_status
        bitmask = 2

        self.GetParent().client.send("MYBATTLESTATUS " + str(bitmask ^ status))
    		
# /end OnReady() ===================================================================================



# OnOpenDisabledUnits() ============================================================================
# ==================================================================================================
#  Opens the "gui_units" dialog box which allows the
#  user to enable, disable, and limit certain units
#  in-game.

    def OnOpenDisabledUnits(self, event):
        self.units = gui_units(self, -1, "")
        self.units.Show()
# /end OnOpenDisabledUnits() =======================================================================




# OnSendMessage() ==================================================================================
# ==================================================================================================
#  When the user hits the enter button when a chatbox 
#  is focused, or when the user explicitly hits the "Send"
#  button, this function is triggered.

#  The current behavior is for it to parse the message 
#  and act accordingly.
# ==================================================================================================
    def OnSendMessage(self, event):
        self.ParseMessage(self.text_battleroom_players_msgbox.GetValue(), True)
           
        self.text_battleroom_players_msgbox.SetFocus()
# /end OnSendMessage() =============================================================================




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
    
        self.battle = None
        self.currentUser = None
        self.host = None
        
        self.InitConfig()
# /end __do_init() =================================================================================




# updateGUI() ======================================================================================
# ==================================================================================================
#  When the battleroom is first opened,
#  this function must be called with the
#  JOINBATTLE data sent to it.
#  
#  If first is true then it does all
#  updates.
# ==================================================================================================
    def updateGUI(self, first=True):
        try:
            config = wx.Config().Get()
            cwd = os.getcwd()

            if self.currentUser == self.host:
                userIsHost = True
            else:
                userIsHost = False
                
            if first == True:
            
                if os.path.exists(config.Read("/Spring/DataDirectory")):
                    map_path = os.path.join(config.Read("/Spring/DataDirectory"),'maps/')
                    
                # HACK need to fix this
                os.chdir(config.Read("/Spring/DataDirectory"))
                
                unitsync.Init(False, 0)
                unitsync.InitArchiveScanner()
                
                self.text_battleroom_server_nameData.SetValue(self.battle.name)
                self.text_battleroom_server_map.SetValue(self.battle.mapName)
                self.text_battleroom_server_mod.SetValue(self.battle.modName)
                self.text_battleroom_server_maxUnitsData.SetValue(str(self.maxUnits))
                self.text_battleroom_server_startEnergyData.SetValue(str(self.startEnergy))
                self.text_battleroom_server_startMetalData.SetValue(str(self.startMetal))
                self.choice_battleroom_map_startPosData.SetSelection(self.startPos)
                self.choice_battleroom_map_winConditionData.SetSelection(self.gameEnd)
                self.checkbox_battleroom_server_rememberBuildingsLOS.SetValue(bool(self.ghostBuildings))
                self.checkbox_battleroom_server_limitdgunData.SetValue(bool(self.limitdgun))
                
                #map stuff-==========================================

                count = unitsync.GetMapCount()
                mapList = []
                
                self.choice_battleroom_map_mapData.Clear()
                
                selection = False
                
                for i in range(0, count):
                    mapname = unitsync.GetMapName(i)
                    self.choice_battleroom_map_mapData.Append(mapname)
                    if mapname == self.text_battleroom_server_map:
                        self.choice_battleroom_map_mapData.SetSelection(i)
                        selection = True
                    mapList.append(mapname)
                    
                if not selection:
                    self.choice_battleroom_map_mapData.SetSelection(0)
                
                if userIsHost:    
                    self.choice_battleroom_map_mapData.Enable(True)
                else:
                    self.choice_battleroom_map_mapData.Enable(False)
                    
                
                mapInfo = unitsync.GetMapInfo(mapList[self.choice_battleroom_map_mapData.GetSelection()])
                if mapInfo[0]:
                    mapInfo = mapInfo[1]
                    self.label_battleroom_map_sizeData.SetLabel(str(mapInfo['width']) + " x " + str(mapInfo['height']))
                    self.label_battleroom_map_positionsData.SetLabel(str(mapInfo['posCount']))
                    self.text_battleroom_map_description.SetValue(mapInfo['description'])
                    self.spin_battleroom_map_tidalData.SetValue(mapInfo['tidalStrength'])
                    self.spin_battleroom_map_gravityData.SetValue(mapInfo['gravity'])
                    self.spin_battleroom_map_maxMetalData.SetValue(int(mapInfo['maxMetal']))
                    self.spin_battleroom_map_extractorRadiusData.SetValue(mapInfo['maxMetal'])
                    self.spin_battleroom_map_minWindData.SetValue(mapInfo['minWind'])
                    self.spin_battleroom_map_maxWindData.SetValue(mapInfo['maxWind'])
                    
                    if userIsHost:
                        self.text_battleroom_map_description.Enable(True)
                        self.spin_battleroom_map_tidalData.Enable(True)
                        self.spin_battleroom_map_gravityData.Enable(True)
                        self.spin_battleroom_map_maxMetalData.Enable(True)
                        self.spin_battleroom_map_extractorRadiusData.Enable(True)
                        self.spin_battleroom_map_minWindData.Enable(True)
                        self.spin_battleroom_map_maxWindData.Enable(True)
                    else:
                        self.text_battleroom_map_description.Enable(False)
                        self.spin_battleroom_map_tidalData.Enable(False)
                        self.spin_battleroom_map_gravityData.Enable(False)
                        self.spin_battleroom_map_maxMetalData.Enable(False)
                        self.spin_battleroom_map_extractorRadiusData.Enable(False)
                        self.spin_battleroom_map_minWindData.Enable(False)
                        self.spin_battleroom_map_maxWindData.Enable(False)
                        
                # END /map stuff-==========================================   
                
                
                
                #mod stuff-==========================================
                
                count = unitsync.GetPrimaryModCount()
                modList = []
                fileList = []
                
                selection = False
                self.choice_battleroom_mod_modData.Clear()

                for i in range(0, count):
                    modname = unitsync.GetPrimaryModName(i)
                    self.choice_battleroom_mod_modData.Append(modname)
                    if modname == self.battle.modName:
                        self.choice_battleroom_mod_modData.SetSelection(i)
                        selection = True
                        primaryArchive = unitsync.GetPrimaryModArchive(i)
                        
                        archiveCount = unitsync.GetPrimaryModArchiveCount(i)   
                        for j in range(0, archiveCount):
                            fileList.append(unitsync.GetPrimaryModArchiveList(j))
                            
                    modList.append(modname)
                
                if not selection:
                    self.choice_battleroom_mod_modData.SetSelection(0)
                    primaryArchive = unitsync.GetPrimaryModArchive(0)
                    archiveCount = unitsync.GetPrimaryModArchiveCount(0)   
                    for j in range(0, archiveCount):
                        fileList.append(unitsync.GetPrimaryModArchiveList(j))
                
                if userIsHost:        
                    self.choice_battleroom_mod_modData.Enable(True)
                else:
                    self.choice_battleroom_mod_modData.Enable(False)
                
                # Tree control    
                self.tree_battleroom_mod_fileList.SetIndent(10)
                rootd = self.tree_battleroom_mod_fileList.AddRoot(primaryArchive)
                
                item = []
                
                for j in fileList:
                    item.append(self.tree_battleroom_mod_fileList.AppendItem(rootd, j))
                    
                self.tree_battleroom_mod_fileList.EnsureVisible(item[0])
                self.text_battleroom_mod_description.SetValue("N/A")
                
                unitsync.AddAllArchives(primaryArchive)
                sideCount = unitsync.GetSideCount()
                
                self.sides = ["Random"]
                
                for i in range(0, sideCount):
                	self.sides.append(unitsync.GetSideName(i))
                	
                self.sides.append("Observer")
                        
                # END /mod stuff-==========================================  
                
                unitsync.UnInit()
                os.chdir(cwd)  

            inc = 1

            for user in self.battle.userList:
            
                exec("status = self.combo_battleroom_players_status_player" + str(inc))
                exec("icon = self.bitmap_battleroom_players_icon_player" + str(inc))
                exec("faction = self.combo_battleroom_players_faction_player" + str(inc))
                exec("sharedArmy = self.combo_battleroom_players_sharedArmy_player" + str(inc))
                exec("team = self.combo_battleroom_players_team_player" + str(inc))
                exec("handicap = self.spin_battleroom_players_handicap_player" + str(inc))
                exec("ready = self.checkbox_battleroom_ready_player" + str(inc))
                exec("sync = self.bitmap_battleroom_players_sync_player" + str(inc))
                exec("ping = self.bitmap_battleroom_players_ping_player" + str(inc))
                
                status.Show(True)
                icon.Show(True)
                faction.Show(True)
                sharedArmy.Show(True)
                team.Show(True)
                handicap.Show(True)
                ready.Show(True)
                sync.Show(True)
                ping.Show(True)
                
                if userIsHost:
                    status.SetString(0, user.name)
                    status.SetString(1, "Open")
                    status.AppendString("Closed")
                    status.SetSelection(0)
                    ready.Enable(False)
                else:
                    status.SetString(0, user.name)
                    status.SetString(1, "Open")
                    status.SetSelection(0)
                    
                    faction.Clear()
                    for i in self.sides:
                        faction.Append(i)

                    if user.name != self.currentUser.name:
                        status.Enable(False)
                        faction.Enable(False)
                        sharedArmy.Enable(False)
                        team.Enable(False)
                        handicap.Enable(False)
                        ready.Enable(False)
                    else:
                        handicap.Enable(False)
                        status.Enable(False)

                faction.SetSelection(user.getFaction() + 1)
                sharedArmy.SetSelection(user.getTeamNumber() + 1)
                team.SetSelection(user.getAllyTeam() + 1)
                handicap.SetValue(int(user.getHandicap()) / 10)
                ready.SetValue(user.getReady())

                inc +=1
                
            # Do not show players that do not exist!
            #
            # "inc" increases in the previous loop to the number
            # of players in the game, and when it reaches this loop
            # it hides all controls that aren't necessary.    
            while inc <= 16:
                exec("self.combo_battleroom_players_status_player" + str(inc) + ".Show(False)")
                exec("self.bitmap_battleroom_players_icon_player" + str(inc) + ".Show(False)")
                exec("self.combo_battleroom_players_faction_player" + str(inc) + ".Show(False)")
                exec("self.combo_battleroom_players_sharedArmy_player" + str(inc) + ".Show(False)")
                exec("self.combo_battleroom_players_team_player" + str(inc) + ".Show(False)")
                exec("self.spin_battleroom_players_handicap_player" + str(inc) + ".Show(False)")
                exec("self.checkbox_battleroom_ready_player" + str(inc) + ".Show(False)")
                exec("self.bitmap_battleroom_players_sync_player" + str(inc) + ".Show(False)")
                exec("self.bitmap_battleroom_players_ping_player" + str(inc) + ".Show(False)")
                inc +=1
        except Exception, msg:
            print(msg + "\n  in function gui_battleroom.joinBattle()")
            

# /end updateGUI() =================================================================================




# joinBattle() =====================================================================================
# ==================================================================================================
#  When the battleroom is first opened,
#  this function must be called with the
#  JOINBATTLE data sent to it.
#
#  data = [BATTLE_ID, startingmetal, startingenery, maxunits, startpos, gameendcondition, limitdgun, diminishingMMs, ghostedBuildings, hashcode]
# ==================================================================================================
    def joinBattle(self, data):
        try:
            self.battle_id = int(data[0])
            self.startMetal = int(data[1])
            self.startEnergy = int(data[2])
            self.maxUnits = int(data[3])
            self.startPos = int(data[4])
            self.gameEnd = int(data[5])
            self.limitdgun = int(data[6])
            self.diminishingMM = int(data[7])
            self.ghostBuildings = int(data[8])
            
            self.host_hashcode = int(data[9])
            
            self.battle = self.GetParent().server.battleFromBattleId(data[0])
            
            self.currentUser = self.battle.server.user
            self.host = self.battle.host
            
            if self.battle == None:
                self.Close(True)
                self.GetParent().debug_handler.output("self.battle is NoneType in gui_battleroom.joinBattle()", DEBUG_ERROR)
                return False
            
            self.updateGUI(True)
            
            
        except Exception, msg:
            print(msg + "\n  in function gui_battleroom.joinBattle()")

# /end joinBattle() ================================================================================




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

            # [Battleroom] defines settings that are used when the "/Global/RememberEverything" entry is true
    	if config.ReadBool("/Global/RememberEverything") == True:

    		if not config.Exists("/Battleroom/LastMap"): config.Write("/Battleroom/LastMap", DEFAULT_MAP)
        	if not config.Exists("/Battleroom/LastMod"): config.Write("/Battleroom/LastMod", DEFAULT_MOD)
        	if not config.Exists("/Battleroom/LastName"): config.Write("/Battleroom/LastName", "")

        	if not config.Exists("/Battleroom/MaxUnits"): config.WriteInt("/Battleroom/MaxUnits", DEFAULT_MAXUNITS)
        	if not config.Exists("/Battleroom/StartEnergy"): config.WriteInt("/Battleroom/StartEnergy", DEFAULT_STARTENERGY)
        	if not config.Exists("/Battleroom/StartMetal"): config.WriteInt("/Battleroom/StartMetal", DEFAULT_STARTMETAL)
        	if not config.Exists("/Battleroom/Handicaps"): config.WriteBool("/Battleroom/Handicaps", DEFAULT_HANDICAPS)
        	if not config.Exists("/Battleroom/HandicapsHost"): config.WriteBool("/Battleroom/HandicapsHost", DEFAULT_HANDICAPS_HOST)

        	if not config.Exists("/Battleroom/MinSpeed"): config.WriteInt("/Battleroom/MinSpeed", DEFAULT_MINSPEED)
        	if not config.Exists("/Battleroom/MaxSpeed"): config.WriteInt("/Battleroom/MaxSpeed", DEFAULT_MAXSPEED)
        	#if not config.Exists("/Battleroom/LOS"): config.WriteBool("/Battleroom/LOS", DEFAULT_LOS)
        	#if not config.Exists("/Battleroom/Terrain"): config.Write("/Battleroom/Terrain", DEFAULT_TERRAIN)
        	if not config.Exists("/Battleroom/RememberStructures"): config.WriteBool("/Battleroom/RememberStructures", DEFAULT_REMEMBERSTRUCTURES)

        	if not config.Exists("/Battleroom/Tidal"): config.WriteInt("/Battleroom/Tidal", DEFAULT_TIDAL)
        	if not config.Exists("/Battleroom/Gravity"): config.WriteInt("/Battleroom/Gravity", DEFAULT_GRAVITY)
        	if not config.Exists("/Battleroom/MaxMetal"): config.WriteInt("/Battleroom/MaxMetal", DEFAULT_MAXMETAL)
        	if not config.Exists("/Battleroom/ExtractRadius"): config.WriteInt("/Battleroom/ExtractRadius", DEFAULT_EXTRACTRADIUS)
        	if not config.Exists("/Battleroom/MinWind"): config.WriteInt("/Battleroom/MinWind", DEFAULT_MINWIND)
        	if not config.Exists("/Battleroom/MaxWind"): config.WriteInt("/Battleroom/MaxWind", DEFAULT_MAXWIND)

        	if not config.Exists("/Battleroom/StartPos"): config.WriteInt("/Battleroom/StartPos", DEFAULT_STARTPOS)
        	if not config.Exists("/Battleroom/WinCondition"): config.WriteInt("/Battleroom/WinCondition", DEFAULT_WINCONDITION)
    		

    		# Still need to impliment map/mod loading and whatnot...

    		self.text_battleroom_server_maxUnitsData.SetValue(str(config.ReadInt("/Battleroom/MaxUnits")))
    		self.text_battleroom_server_startEnergyData.SetValue(str(config.ReadInt("/Battleroom/StartEnergy")))
    		self.text_battleroom_server_startMetalData.SetValue(str(config.ReadInt("/Battleroom/StartMetal")))

    		self.checkbox_battleroom_server_handicap.SetValue(config.ReadBool("/Battleroom/Handicaps"))

    		if config.ReadBool("/Battleroom/Handicaps") == True:
    			self.checkbox_battleroom_server_hostModifiesHandicaps.Enable(True)
    			self.checkbox_battleroom_server_hostModifiesHandicaps.SetValue(config.ReadBool("/Battleroom/HandicapsHost"))
    		else:
    			self.checkbox_battleroom_server_hostModifiesHandicaps.Enable(False)
    			self.checkbox_battleroom_server_hostModifiesHandicaps.SetValue(config.ReadBool("/Battleroom/HandicapsHost"))

    		self.checkbox_battleroom_server_rememberBuildingsLOS.SetValue(config.ReadBool("/Battleroom/RememberStructures"))

    		#self.slider_battleroom_server_gameSpeedMin.SetValue(config.ReadInt("/Battleroom/MinSpeed"))
    		#self.slider_battleroom_server_gameSpeedMax.SetValue(config.ReadInt("/Battleroom/MaxSpeed"))

    		#self.UpdateGameSpeed()
            
    		#if config.ReadBool("/Battleroom/LOS") == False:
    		#	self.radiobox_battleroom_server_losData.SetSelection(0)
    		#else:
    		#	self.radiobox_battleroom_server_losData.SetSelection(1)

    		#if config.Read("/Battleroom/Terrain") == "Visible":
    		#	self.radiobox_battleroom_server_losData.SetSelection(0)
    		#else:
    		#	self.radiobox_battleroom_server_losData.SetSelection(1)

    		self.spin_battleroom_map_tidalData.SetValue(config.ReadInt("/Battleroom/Tidal"))
    		self.spin_battleroom_map_gravityData.SetValue(config.ReadInt("/Battleroom/Gravity"))
    		self.spin_battleroom_map_maxMetalData.SetValue(config.ReadInt("/Battleroom/MaxMetal"))
    		self.spin_battleroom_map_extractorRadiusData.SetValue(config.ReadInt("/Battleroom/ExtractRadius"))
    		self.spin_battleroom_map_minWindData.SetValue(config.ReadInt("/Battleroom/MinWind"))
    		self.spin_battleroom_map_maxWindData.SetValue(config.ReadInt("/Battleroom/MaxWind"))

    		self.choice_battleroom_map_startPosData.SetSelection(config.ReadInt("/Battleroom/StartPos"))
    		self.choice_battleroom_map_winConditionData.SetSelection(config.ReadInt("/Battleroom/WinCondition"))

    	else:
    		# Remember everything is not enabled
    		if not config.Exists("/Battleroom/LastMap"): config.Write("/Battleroom/LastMap", DEFAULT_MAP)
        	if not config.Exists("/Battleroom/LastMod"): config.Write("/Battleroom/LastMod", DEFAULT_MOD)
        	if not config.Exists("/Battleroom/LastName"): config.Write("/Battleroom/LastName", "")
    		
    	
        # Write all changes to the file
        config.Flush()
    # /end AppendToChat() ==============================================================================



# SaveConfig() =====================================================================================
# ==================================================================================================
#  This function saves the configuration settings that
#  need to be saved.  This is usually called when the
#  window is being destroyed.
# ==================================================================================================
    def SaveConfig(self):
        config = wx.Config.Get()

    	if config.ReadBool("/Global/RememberEverything") == True:

    		# not done yet: 
    		#config.Write("/Battleroom/LastMap", DEFAULT_MAP)
        	#config.Write("/Battleroom/LastMod", DEFAULT_MOD)
        	#config.Write("/Battleroom/LastName", "")

        	config.WriteInt("/Battleroom/MaxUnits", int(self.text_battleroom_server_maxUnitsData.GetValue()))
        	config.WriteInt("/Battleroom/StartEnergy", int(self.text_battleroom_server_startEnergyData.GetValue()))
        	config.WriteInt("/Battleroom/StartMetal", int(self.text_battleroom_server_startMetalData.GetValue()))
        	config.WriteBool("/Battleroom/Handicaps", self.checkbox_battleroom_server_handicap.GetValue())
        	config.WriteBool("/Battleroom/HandicapsHost", self.checkbox_battleroom_server_hostModifiesHandicaps.GetValue())

        	#config.WriteInt("/Battleroom/MinSpeed", self.slider_battleroom_server_gameSpeedMin.GetValue())
        	#config.WriteInt("/Battleroom/MaxSpeed", self.slider_battleroom_server_gameSpeedMax.GetValue())


      		#if self.radiobox_battleroom_server_losData.GetSelection() == 0:
    		#	config.WriteBool("/Battleroom/LOS", False)
    		#else:
    		#	config.WriteBool("/Battleroom/LOS", True)
    		#if self.radiobox_battleroom_server_losData.GetSelection() == 0:
    		#	config.Write("/Battleroom/Terrain", "Visible")
    		#else:
    		#	config.Write("/Battleroom/Terrain", "Dark")

    		config.WriteBool("/Battleroom/RememberStructures", self.checkbox_battleroom_server_rememberBuildingsLOS.GetValue())

        	config.WriteInt("/Battleroom/Tidal", self.spin_battleroom_map_tidalData.GetValue())
        	config.WriteInt("/Battleroom/Gravity", self.spin_battleroom_map_gravityData.GetValue())
    		config.WriteInt("/Battleroom/MaxMetal", self.spin_battleroom_map_maxMetalData.GetValue())
    		config.WriteInt("/Battleroom/ExtractRadius", self.spin_battleroom_map_extractorRadiusData.GetValue())
    		config.WriteInt("/Battleroom/MinWind", self.spin_battleroom_map_minWindData.GetValue())
    		config.WriteInt("/Battleroom/MaxWind", self.spin_battleroom_map_maxWindData.GetValue())

    		config.WriteInt("/Battleroom/StartPos", self.choice_battleroom_map_startPosData.GetSelection())
    		config.WriteInt("/Battleroom/WinCondition", self.choice_battleroom_map_winConditionData.GetSelection())

    	else:
    		# Remember everything is not enabled
    		pass
    		# not done yet: 
    		#config.Write("/Battleroom/LastMap", DEFAULT_MAP)
        	#config.Write("/Battleroom/LastMod", DEFAULT_MOD)
        	#config.Write("/Battleroom/LastName", "")

            # Write all changes to the file
        config.Flush()	
# /end SaveConfig() ==============================================================================




# ParseMessage() ===================================================================================
# ==================================================================================================
#  Parses a message entered into the current chat box so
#  that it can be interpreted as meaningful commands.  Without
#  this function, slash (/) commands would not be possible.
# ==================================================================================================
    def ParseMessage(self, message, netParse=False):

        # Are we parsing a command or a chat message to the server?
        if message != "" and message[0] == "/":
            
            cmd = message[1:].split(" ")
            
            if len(cmd) > 1:
                cmd_parsed = cmd[1]
                
                for x in cmd[2:]:
                    cmd_parsed =  cmd_parsed + " " + x
            else:
                cmd_parsed = cmd

        # =STATS========================
            if cmd[0] == "stats":
                
                # The /stats command requests statistical (win/loss/tie) data about <username> from the spring server
                # Syntax: "/stats <username>"
                if netParse == True:
                    
                    if len(cmd_parsed) < 2 or cmd_parsed[1] == "":
                        self.GetParent().output_handler.output("^5Error parsing command.", DEBUG_ERROR, -1)
                        self.text_battleroom_players_msgbox.SetValue("")
                        self.text_battleroom_players_msgbox.SetFocus()
                        return 0

                    try: pass
                    	# get the stats of the specified "user"
                    except:
                        self.GetParent().output_handler.output("Player ^0" + str(cmd_parsed[1]) + "^3 does not exist.", SERVER_OTHER, -1)
                        self.text_battleroom_players_msgbox.SetValue("")
                        self.text_battleroom_players_msgbox.SetFocus()
                        return 0

                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus()
                else:
                    self.GetParent().output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, -1)

        # =TIME========================
            elif cmd[0] == "time":
                # The /time command requests the official server time
                # Syntax: "/time"
                if netParse == True:
                    try: pass
                    	# Get current time from the server
                    except:
                        self.GetParent().output_handler.output("Could not get time data from server.", SERVER_OTHER, -1)
                        self.text_battleroom_players_msgbox.SetValue("")
                        self.text_battleroom_players_msgbox.SetFocus()
                        return 0

                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus()
                else:
                    self.GetParent().output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, -1)

        # =R==========================
            elif cmd_parsed[0] == "r":
                # The /r command returns the last person you whispered to
                # Syntax: "/r"
                if netParse == True:
                
                    try: pass
                    	# return last person whispered (ie -> "/w LastPersonWhispered <blinkingcursor>"
                    except:
                        #self.AppendToChat("Not implimented yet.", self.color_channel_text)
                        self.text_battleroom_players_msgbox.SetValue("")
                        self.text_battleroom_players_msgbox.SetFocus()
                        return 0

                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus()
                else:
                    self.GetParent().output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, -1)
                
        # =ME=========================
            elif cmd[0] == "me":
                # The /me command returns the last person you whispered to
                # Syntax: "/me"
                if netParse == True:
                    try: 
                        if cmd_parsed[1] != "":
                            self.GetParent().client.send("SAYBATTLEEX " + cmd_parsed)
                    except:
                        self.GetParent().output_handler.output("^5Error parsing command.", DEBUG_ERROR, -1)
                        self.text_battleroom_players_msgbox.SetValue("")
                        self.text_battleroom_players_msgbox.SetFocus()
                        return 0

                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus()
                else:
                    self.GetParent().output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, -1)

        # =WHISPER======================
            elif cmd[0] == "w" or cmd[0] == "whisper" or cmd[0] == "msg":
                # The /w, /whisper, and /msg commands send a private <message> to the specified <username>
                # Syntax: "/w <username> <message>"
                if netParse == True:
                    if len(cmd_parsed) < 3 or cmd_parsed[1] == "":
                    	self.GetParent().output_handler.output("^5Error parsing command.", DEBUG_ERROR, -1)
                    	self.text_battleroom_players_msgbox.SetValue("")
                    	self.text_battleroom_players_msgbox.SetFocus()
                    	return 0

                    user = self.GetParent().server.userFromName(cmd_parsed[1])
            	    if user == None:
                        self.GetParent().output_handler.output("Player ^0" + str(cmd_parsed[1]) + "^3 does not exist.", SERVER_OTHER, -1)
                        self.text_battleroom_players_msgbox.SetValue("")
                        self.text_battleroom_players_msgbox.SetFocus()
                        return 0
                    
                    if len(cmd_parsed) - 1 >= 3:
                        unstriped_msg = cmd_parsed[2]
                        for x in cmd_parsed[3:]:
                            unstriped_msg = unstriped_msg + " " + x
                    else:
                        unstriped_msg = cmd_parsed[2]
                        
                    self.GetParent().client.send("SAYPRIVATE " + user.name + " " + unstriped_msg)
                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus()
                    
                else:
                    self.GetParent().output_handler.output("^5Must be connected or in a tab that accepts network commands.", DEBUG_ERROR, -1)
                    
        # =HELP=========================
            elif cmd[0] == "?" or cmd[0] == "help" or cmd[0] == "h":
                # The /?, /help, and /h commands show help information on how to use commands
                # Syntax: "/h <command>"

                if len(cmd_parsed) == 1:
                    self.GetParent().output_handler.output("^5Usage:\n/help <command-without-slash> - shows help info for specified command\n\
/help list - lists all commands\n", OTHER_MSG, -1)

                elif cmd[1] == "list":
                    self.GetParent().output_handler.output("^5Available commands:\n\
/help - shows help info (aliases: /? /h)\n\
/print - prints the value of an internal variable you specify\n\
/set - assigns an internal variable value specified\n\
/open - opens a window from the specified module\n\
/stats - requests the win/los/tie records for the specified player from the server\n\
/time - requests the official server time\n\
/w - sends a private message to the specified player (aliases: /whisper /msg)\n\
/r - \"/whisper\" the last person you whispered\n", OTHER_MSG, -1)

                elif cmd[1] == "print":
                    self.GetParent().output_handler.output("^5Usage: prints the value of the specified variable\n\
/print <internal_variable_name>\n\
Example:\n\
/print self.springClient_version\n", OTHER_MSG, -1)

                elif cmd[1] == "set":
                    self.GetParent().output_handler.output("^5Usage: sets an internal variable a specified value\n\
/set <internal_variable_name> <value_to_assign>\n\
Example:\n\
/set self.server_address \"google.com\"\n", OTHER_MSG, -1)

                elif cmd[1] == "open":
                    self.GetParent().output_handler.output("^5Usage: opens a window from the specified module\n\
/open <module>\n\
Example:\n\
/open gui_units\n", OTHER_MSG, -1)

                elif cmd[1] == "stats":
                    self.GetParent().output_handler.output("^5Usage: requests the win/los/tie records for the specified player from the server\n\
/stats <playername>\n\
Example:\n\
/stats Ace07\n", OTHER_MSG, -1)

                elif cmd[1] == "time":
                    self.GetParent().output_handler.output("^5Usage: requests the official server time\n\
/time\n", OTHER_MSG, -1)

                elif cmd[1] == "w" or cmd_parsed[1] == "whisper" or cmd_parsed[1] == "msg":
                    self.GetParent().output_handler.output("^5Usage: sends a private message to the specified player (aliases: /whisper /msg)\n\
/w <playername> <message>\n\
Example:\n\
/w Ace07 hi whats up?\n", OTHER_MSG, -1)

                elif cmd[1] == "r":
                    self.GetParent().output_handler.output("^5Usage: \"/whisper <last_playername>\"s the last person you whispered\n\
/r\n\
Example:\n\
/r -> /w Ace07\n", OTHER_MSG, -1)

                else:
                    self.GetParent().output_handler.output("^5Usage:\n\"/help <command-without-slash>\"\n\
\"/help list\" lists commands\n\
Example:\n\
/help print\n", OTHER_MSG, -1)
                self.text_battleroom_players_msgbox.SetValue("")
                self.text_battleroom_players_msgbox.SetFocus()

        # =INVALID======================
            else:
                # This is when the command specified cannot be found
                if message != "/" and message[1] != " ":
                    self.GetParent().output_handler.output("^5Command " + "^4/" + str(cmd_parsed[0]) + "^5 does not exist.", DEBUG_ERROR, -1)

                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus()
                else:
                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus()
        else:
            # User does not want to use a command.  They simply
            # want to send a chat message to the server.

            # Updates the message saving feature of this client--
            # where the user hits the up and down buttons to retrieve
            # messages already entered previously.
            if netParse != True:
                if message != "":
                    self.GetParent().output_handler.output(message, USER_MSG, -1)
                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus() 
            else:
                if message != "":
                    self.GetParent().client.send("SAYBATTLE " + message)
                    self.text_battleroom_players_msgbox.SetValue("")
                    self.text_battleroom_players_msgbox.SetFocus() 
                    

# /end ParseMessage() ==============================================================================



  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================


    def __set_properties(self):
        # begin wxGlade: gui_battleroom.__set_properties
        self.SetTitle("omni - Battleroom")
        _icon = wx.EmptyIcon()

    	#===============================================================================
    	# Added os.path.join() and added os.name to get Windows Icons to work!
    	if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
    	else:
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
    	# /end edits ===================================================================


        self.SetIcon(_icon)
        self.label_battleroom_players_status.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.combo_battleroom_players_status_player1.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player1.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player1.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player1.SetSelection(0)
        self.combo_battleroom_players_status_player2.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player2.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player2.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player2.SetSelection(0)
        self.combo_battleroom_players_status_player3.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player3.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player3.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player3.SetSelection(0)
        self.combo_battleroom_players_status_player4.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player4.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player4.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player4.SetSelection(0)
        self.combo_battleroom_players_status_player5.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player5.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player5.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player5.SetSelection(0)
        self.combo_battleroom_players_status_player6.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player6.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player6.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player6.SetSelection(0)
        self.combo_battleroom_players_status_player7.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player7.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player7.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player7.SetSelection(0)
        self.combo_battleroom_players_status_player8.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player8.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player8.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player8.SetSelection(0)
        self.combo_battleroom_players_status_player9.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player9.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player9.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player9.SetSelection(0)
        self.combo_battleroom_players_status_player10.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player10.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player10.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player10.SetSelection(0)
        self.combo_battleroom_players_status_player11.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player11.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player11.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player11.SetSelection(0)
        self.combo_battleroom_players_status_player12.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player12.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player12.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player12.SetSelection(0)
        self.combo_battleroom_players_status_player13.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player13.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player13.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player13.SetSelection(0)
        self.combo_battleroom_players_status_player14.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player14.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player14.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player14.SetSelection(0)
        self.combo_battleroom_players_status_player15.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player15.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player15.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player15.SetSelection(0)
        self.combo_battleroom_players_status_player16.SetMinSize((125, 25))
        self.combo_battleroom_players_status_player16.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_status_player16.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_status_player16.SetSelection(0)
        self.label_battleroom_players_faction.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.combo_battleroom_players_faction_player1.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player1.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player1.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player1.SetSelection(2)
        self.combo_battleroom_players_faction_player2.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player2.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player2.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player2.SetSelection(2)
        self.combo_battleroom_players_faction_player3.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player3.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player3.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player3.SetSelection(2)
        self.combo_battleroom_players_faction_player4.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player4.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player4.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player4.SetSelection(2)
        self.combo_battleroom_players_faction_player5.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player5.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player5.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player5.SetSelection(2)
        self.combo_battleroom_players_faction_player6.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player6.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player6.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player6.SetSelection(2)
        self.combo_battleroom_players_faction_player7.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player7.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player7.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player7.SetSelection(2)
        self.combo_battleroom_players_faction_player8.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player8.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player8.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player8.SetSelection(2)
        self.combo_battleroom_players_faction_player9.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player9.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player9.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player9.SetSelection(2)
        self.combo_battleroom_players_faction_player10.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player10.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player10.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player10.SetSelection(2)
        self.combo_battleroom_players_faction_player11.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player11.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player11.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player11.SetSelection(2)
        self.combo_battleroom_players_faction_player12.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player12.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player12.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player12.SetSelection(2)
        self.combo_battleroom_players_faction_player13.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player13.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player13.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player13.SetSelection(2)
        self.combo_battleroom_players_faction_player14.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player14.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player14.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player14.SetSelection(2)
        self.combo_battleroom_players_faction_player15.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player15.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player15.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player15.SetSelection(2)
        self.combo_battleroom_players_faction_player16.SetMinSize((85, 25))
        self.combo_battleroom_players_faction_player16.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_faction_player16.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_faction_player16.SetSelection(2)
        self.label_battleroom_players_sharedArmy.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.label_battleroom_players_sharedArmy.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player1.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player1.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player1.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player1.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player1.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player2.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player2.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player2.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player2.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player2.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player3.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player3.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player3.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player3.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player3.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player4.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player4.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player4.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player4.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player4.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player5.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player5.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player5.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player5.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player5.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player6.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player6.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player6.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player6.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player6.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player7.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player7.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player7.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player7.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player7.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player8.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player8.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player8.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player8.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player8.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player9.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player9.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player9.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player9.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player9.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player10.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player10.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player10.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player10.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player10.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player11.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player11.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player11.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player11.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player11.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player12.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player12.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player12.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player12.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player12.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player13.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player13.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player13.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player13.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player13.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player14.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player14.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player14.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player14.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player14.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player15.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player15.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player15.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player15.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player15.SetSelection(0)
        self.combo_battleroom_players_sharedArmy_player16.SetMinSize((65, 25))
        self.combo_battleroom_players_sharedArmy_player16.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_sharedArmy_player16.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_sharedArmy_player16.SetToolTipString("Allows multiple players to share the same army")
        self.combo_battleroom_players_sharedArmy_player16.SetSelection(0)
        self.label_battleroom_players_team.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.label_battleroom_players_team.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player1.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player1.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player1.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player1.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player1.SetSelection(0)
        self.combo_battleroom_players_team_player2.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player2.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player2.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player2.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player2.SetSelection(0)
        self.combo_battleroom_players_team_player3.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player3.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player3.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player3.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player3.SetSelection(0)
        self.combo_battleroom_players_team_player4.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player4.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player4.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player4.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player4.SetSelection(0)
        self.combo_battleroom_players_team_player5.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player5.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player5.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player5.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player5.SetSelection(0)
        self.combo_battleroom_players_team_player6.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player6.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player6.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player6.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player6.SetSelection(0)
        self.combo_battleroom_players_team_player7.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player7.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player7.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player7.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player7.SetSelection(0)
        self.combo_battleroom_players_team_player8.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player8.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player8.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player8.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player8.SetSelection(0)
        self.combo_battleroom_players_team_player9.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player9.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player9.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player9.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player9.SetSelection(0)
        self.combo_battleroom_players_team_player10.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player10.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player10.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player10.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player10.SetSelection(0)
        self.combo_battleroom_players_team_player11.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player11.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player11.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player11.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player11.SetSelection(0)
        self.combo_battleroom_players_team_player12.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player12.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player12.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player12.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player12.SetSelection(0)
        self.combo_battleroom_players_team_player13.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player13.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player13.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player13.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player13.SetSelection(0)
        self.combo_battleroom_players_team_player14.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player14.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player14.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player14.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player14.SetSelection(0)
        self.combo_battleroom_players_team_player15.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player15.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player15.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player15.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player15.SetSelection(0)
        self.combo_battleroom_players_team_player16.SetMinSize((65, 25))
        self.combo_battleroom_players_team_player16.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.combo_battleroom_players_team_player16.SetForegroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
        self.combo_battleroom_players_team_player16.SetToolTipString("Allows players to \"team up\" against other teams")
        self.combo_battleroom_players_team_player16.SetSelection(0)
        self.label_battleroom_players_handicap.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.label_battleroom_players_handicap.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player1.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player1.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player2.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player2.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player3.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player3.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player4.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player4.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player5.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player5.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player6.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player6.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player7.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player7.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player8.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player8.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player9.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player9.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player10.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player10.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player11.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player11.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player12.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player12.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player13.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player13.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player14.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player14.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player15.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player15.SetToolTipString("Affects the amount of starting money a player starts with")
        self.spin_battleroom_players_handicap_player16.SetMinSize((40, 25))
        self.spin_battleroom_players_handicap_player16.SetToolTipString("Affects the amount of starting money a player starts with")
        self.label_battleroom_players_ready.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.checkbox_battleroom_ready_player1.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player2.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player3.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player4.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player5.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player6.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player7.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player8.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player9.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player10.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player11.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player12.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player13.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player14.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player15.SetMinSize((21, 25))
        self.checkbox_battleroom_ready_player16.SetMinSize((21, 25))
        self.label_battleroom_players_sync.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.bitmap_battleroom_players_sync_player1.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player1.SetToolTipString("Player1's units are synced")
        self.bitmap_battleroom_players_sync_player2.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player2.SetToolTipString("Player2's units are synced")
        self.bitmap_battleroom_players_sync_player3.SetToolTipString("Player3's units are synced")
        self.bitmap_battleroom_players_sync_player4.SetToolTipString("Player4's units are synced")
        self.bitmap_battleroom_players_sync_player5.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player5.SetToolTipString("Player5's units are synced")
        self.bitmap_battleroom_players_sync_player6.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player6.SetToolTipString("Player6's units are synced")
        self.bitmap_battleroom_players_sync_player7.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player7.SetToolTipString("Player7's units are synced")
        self.bitmap_battleroom_players_sync_player8.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player8.SetToolTipString("Player8's units are synced")
        self.bitmap_battleroom_players_sync_player9.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player9.SetToolTipString("Player9's units are synced")
        self.bitmap_battleroom_players_sync_player10.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player10.SetToolTipString("Player10's units are synced")
        self.bitmap_battleroom_players_sync_player11.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player11.SetToolTipString("Player11's units are synced")
        self.bitmap_battleroom_players_sync_player12.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player12.SetToolTipString("Player12's units are synced")
        self.bitmap_battleroom_players_sync_player13.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player13.SetToolTipString("Player13's units are synced")
        self.bitmap_battleroom_players_sync_player14.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player14.SetToolTipString("Player14's units are synced")
        self.bitmap_battleroom_players_sync_player15.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player15.SetToolTipString("Player15's units are synced")
        self.bitmap_battleroom_players_sync_player16.SetMinSize((25, 25))
        self.bitmap_battleroom_players_sync_player16.SetToolTipString("Player16's units are synced")
        self.label_battleroom_players_ping.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.bitmap_battleroom_players_ping_player1.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player1.SetToolTipString("Player1 Ping")
        self.bitmap_battleroom_players_ping_player2.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player2.SetToolTipString("Player2 Ping")
        self.bitmap_battleroom_players_ping_player3.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player3.SetToolTipString("Player3 Ping")
        self.bitmap_battleroom_players_ping_player4.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player4.SetToolTipString("Player4 Ping")
        self.bitmap_battleroom_players_ping_player5.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player5.SetToolTipString("Player5 Ping")
        self.bitmap_battleroom_players_ping_player6.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player6.SetToolTipString("Player6 Ping")
        self.bitmap_battleroom_players_ping_player7.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player7.SetToolTipString("Player7 Ping")
        self.bitmap_battleroom_players_ping_player8.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player8.SetToolTipString("Player8 Ping")
        self.bitmap_battleroom_players_ping_player9.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player9.SetToolTipString("Player9 Ping")
        self.bitmap_battleroom_players_ping_player10.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player10.SetToolTipString("Player10 Ping")
        self.bitmap_battleroom_players_ping_player11.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player11.SetToolTipString("Player11 Ping")
        self.bitmap_battleroom_players_ping_player12.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player12.SetToolTipString("Player12 Ping")
        self.bitmap_battleroom_players_ping_player13.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player13.SetToolTipString("Player13 Ping")
        self.bitmap_battleroom_players_ping_player14.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player14.SetToolTipString("Player14 Ping")
        self.bitmap_battleroom_players_ping_player15.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player15.SetToolTipString("Player15 Ping")
        self.bitmap_battleroom_players_ping_player16.SetMinSize((25, 25))
        self.bitmap_battleroom_players_ping_player16.SetToolTipString("Player16 Ping")
        self.text_battleroom_players_chatarea.SetBackgroundColour(wx.SystemSettings_GetColour(wx.SYS_COLOUR_BACKGROUND))
        self.button_battleroom_players_sendmsg.SetDefault()
        self.label_battleroom_server_battleName.SetMinSize((50, 17))
        self.text_battleroom_server_nameData.SetMinSize((170, 25))
        self.label_battleroom_server_mapName.SetMinSize((50, 17))
        self.text_battleroom_server_map.SetMinSize((170, 25))
        self.label_battleroom_server_modName.SetMinSize((50, 17))
        self.text_battleroom_server_mod.SetMinSize((170, 25))
        self.text_battleroom_server_mod.SetToolTipString("The name of the battle that will show up on the battle list in the lobby")
        self.label_battleroom_server_maxUnits.SetMinSize((85, 17))
        self.text_battleroom_server_maxUnitsData.SetMinSize((125, 25))
        self.text_battleroom_server_maxUnitsData.SetToolTipString("Enter the max units per player")
        self.label_battleroom_server_startEnergy.SetMinSize((85, 17))
        self.text_battleroom_server_startEnergyData.SetMinSize((125, 25))
        self.text_battleroom_server_startEnergyData.SetToolTipString("Enter the starting energy for every player")
        self.label_battleroom_server_startMetal.SetMinSize((85, 17))
        self.text_battleroom_server_startMetalData.SetMinSize((125, 25))
        self.text_battleroom_server_startMetalData.SetToolTipString("Enter the starting metal for each player")
        self.checkbox_battleroom_server_handicap.SetToolTipString("Do you want the game to give advantages and disadvantages to certain players?")
        self.checkbox_battleroom_server_hostModifiesHandicaps.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.checkbox_battleroom_server_hostModifiesHandicaps.SetToolTipString("Makes it so that only the host can change handicaps")
        self.checkbox_battleroom_server_hostModifiesHandicaps.Enable(False)
        self.label_battleroom_map_startPos.SetMinSize((90, 15))
        self.label_battleroom_map_startPos.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.choice_battleroom_map_startPosData.SetMinSize((125, 27))
        self.choice_battleroom_map_startPosData.SetToolTipString("Fixed- positions are chosen in the battleroom dialog\nRandom- users don't know where they will start until the game starts\nChoose ingame- in game you choose")
        self.choice_battleroom_map_startPosData.SetSelection(0)
        self.label_battleroom_map_winConditions.SetMinSize((90, 15))
        self.label_battleroom_map_winConditions.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.choice_battleroom_map_winConditionData.SetMinSize((125, 27))
        self.choice_battleroom_map_winConditionData.SetToolTipString("Normal- commander dies to end game\nAll units- all units must die for game to end")
        self.choice_battleroom_map_winConditionData.SetSelection(0)
        self.checkbox_battleroom_server_rememberBuildingsLOS.SetMinSize((224, 20))
        self.checkbox_battleroom_server_rememberBuildingsLOS.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.checkbox_battleroom_server_rememberBuildingsLOS.SetToolTipString("Remember buildings that have been seen by units in the past")
        self.checkbox_battleroom_server_rememberBuildingsLOS.SetValue(1)
        self.checkbox_battleroom_server_limitdgunData.SetMinSize((224, 20))
        self.checkbox_battleroom_server_limitdgunData.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.checkbox_battleroom_server_limitdgunData.SetToolTipString("Limit d-gun usage to starting positions only")
        self.button_battleroom_server_startGame.SetMinSize((200, 27))
        self.bitmap_battleroom_map_preview.SetToolTipString("Flooded Desert Minimap Preview")
        self.choice_battleroom_map_mapData.SetSelection(0)
        self.label_battleroom_map_positions.SetMinSize((66, 17))
        self.label_battleroom_map_size.SetMinSize((66, 17))
        self.label_battleroom_map_sizeData.SetFont(wx.Font(10, wx.DEFAULT, wx.NORMAL, wx.BOLD, 0, ""))
        self.text_battleroom_map_description.SetMinSize((215, 75))
        self.label_battleroom_map_tidal.SetMinSize((100, 17))
        self.spin_battleroom_map_tidalData.SetMinSize((60, 25))
        self.spin_battleroom_map_tidalData.SetToolTipString("The tidal strength value affects all tide-based energy systems")
        self.spin_battleroom_map_tidalData.Enable(False)
        self.label_battleroom_map_gravity.SetMinSize((100, 17))
        self.spin_battleroom_map_gravityData.SetMinSize((60, 25))
        self.spin_battleroom_map_gravityData.SetToolTipString("The gravity value used when determining how units move in fluids")
        self.spin_battleroom_map_gravityData.Enable(False)
        self.label_battleroom_map_maxMetal.SetMinSize((100, 17))
        self.spin_battleroom_map_maxMetalData.SetMinSize((60, 25))
        self.spin_battleroom_map_maxMetalData.Enable(False)
        self.label_battleroom_map_extractorRadius.SetMinSize((110, 17))
        self.spin_battleroom_map_extractorRadiusData.SetMinSize((60, 25))
        self.spin_battleroom_map_extractorRadiusData.Enable(False)
        self.label_battleroom_map_minWind.SetMinSize((100, 17))
        self.spin_battleroom_map_minWindData.SetMinSize((60, 25))
        self.spin_battleroom_map_minWindData.SetToolTipString("The minimum speed of the wind in the game")
        self.spin_battleroom_map_minWindData.Enable(False)
        self.label_battleroom_map_maxWind.SetMinSize((100, 17))
        self.spin_battleroom_map_maxWindData.SetMinSize((60, 25))
        self.spin_battleroom_map_maxWindData.SetToolTipString("The maximum speed of the wind in the game")
        self.spin_battleroom_map_maxWindData.Enable(False)
        self.button_battleroom_map_revertToDefaults.SetToolTipString("Revert to map defaults")
        self.button_battleroom_map_disabledUnits.SetMinSize((200, 27))
        self.choice_battleroom_mod_modData.SetSelection(0)
        self.tree_battleroom_mod_fileList.SetMinSize((218, 100))
        self.tree_battleroom_mod_fileList.SetToolTipString("The files used by this mod")
        self.text_battleroom_mod_description.SetMinSize((218, 70))
        self.list_battleroom_mod_settings.SetMinSize((215, 105))
        self.list_battleroom_mod_settings.SetToolTipString("Various mod settings that may be changed")
        self.list_battleroom_mod_settings.Enable(False)
        self.text_battleroom_mod_settingInputData.SetMinSize((85, 25))
        self.text_battleroom_mod_settingInputData.Enable(False)
        self.button_battleroom_mod_updateSetting.SetMinSize((70, 25))
        self.button_battleroom_mod_updateSetting.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.button_battleroom_mod_updateSetting.SetToolTipString("Update the mod setting ")
        self.button_battleroom_mod_updateSetting.Enable(False)
        self.button_battleroom_mod_defaultSetting.SetMinSize((60, 25))
        self.button_battleroom_mod_defaultSetting.SetFont(wx.Font(9, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.button_battleroom_mod_defaultSetting.SetToolTipString("Revert to the current default setting")
        self.button_battleroom_mod_defaultSetting.Enable(False)
        self.button_battleroom_mod_revertToDefaults.SetToolTipString("Revert the mod settings to their defaults")
        self.button_battleroom_mod_revertToDefaults.Enable(False)
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_battleroom.__do_layout
        grid_battleroom_main = wx.FlexGridSizer(3, 5, 0, 0)
        grid_battleroom_mod = wx.FlexGridSizer(9, 1, 0, 0)
        grid_battleroom_mod_settings = wx.FlexGridSizer(14, 1, 0, 0)
        sizer_battleroom_mod_settingInput = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_mod_description = wx.BoxSizer(wx.VERTICAL)
        sizer_battleroom_mod_fileList = wx.BoxSizer(wx.VERTICAL)
        grid_battleroom_map = wx.FlexGridSizer(14, 1, 0, 0)
        grid_battleroom_map_settings = wx.FlexGridSizer(13, 1, 0, 0)
        sizer_battleroom_map_maxWind = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_map_minWind = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_map_extract = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_map_metal = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_map_gravity = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_map_tidal = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_map_description = wx.BoxSizer(wx.VERTICAL)
        sizer_3 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_3_copy = wx.BoxSizer(wx.HORIZONTAL)
        grid_battleroom_server = wx.FlexGridSizer(38, 1, 0, 0)
        sizer_battleroom_map_winConditions = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_map_startPos = wx.BoxSizer(wx.HORIZONTAL)
        sizer_battleroom_server_handicaps = wx.BoxSizer(wx.VERTICAL)
        sizer_host_battle_startMetal_copy = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_battle_startEnergy_copy = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_battle_maxUnits_copy = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_battle_name_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_battle_name_copy_copy = wx.BoxSizer(wx.HORIZONTAL)
        sizer_host_battle_name_copy = wx.BoxSizer(wx.HORIZONTAL)
        sizer_8 = wx.BoxSizer(wx.VERTICAL)
        grid_sizer_2 = wx.FlexGridSizer(2, 1, 0, 0)
        sizer_5 = wx.FlexGridSizer(1, 2, 0, 0)
        grid_battleroom_players = wx.FlexGridSizer(1, 16, 0, 0)
        sizer_battleroom_players_ping = wx.BoxSizer(wx.VERTICAL)
        sizer_battleroom_players_sync = wx.BoxSizer(wx.VERTICAL)
        sizer_battleroom_players_ready = wx.BoxSizer(wx.VERTICAL)
        sizer_battleroom_players_handicap = wx.BoxSizer(wx.VERTICAL)
        sizer_battleroom_players_team = wx.BoxSizer(wx.VERTICAL)
        sizer_battleroom_players_team_copy = wx.BoxSizer(wx.VERTICAL)
        sizer_battleroom_players_faction = wx.BoxSizer(wx.VERTICAL)
        sizer_battleroom_players_name = wx.BoxSizer(wx.VERTICAL)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_3 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_2 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_11_copy_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_11_copy_1_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_10_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_9_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_8_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_7_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_6_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_5_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_4_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_3_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_2_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_2_copy_1_copy_1_copy_copy_1 = wx.BoxSizer(wx.HORIZONTAL)
        grid_battleroom_main.Add((10, 15), 0, 0, 0)
        grid_battleroom_main.Add((400, 15), 0, 0, 0)
        grid_battleroom_main.Add((15, 15), 0, 0, 0)
        grid_battleroom_main.Add((175, 15), 0, 0, 0)
        grid_battleroom_main.Add((10, 15), 0, 0, 0)
        grid_battleroom_main.Add((10, 500), 0, wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_name.Add(self.label_battleroom_players_status, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_2_copy_1_copy_1_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player1, 0, 0, 0)
        sizer_2_copy_1_copy_1_copy_copy_1.Add(self.combo_battleroom_players_status_player1, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_1_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_2_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player2, 0, 0, 0)
        sizer_2_copy_1_copy_2_copy_copy_1.Add(self.combo_battleroom_players_status_player2, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_2_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_3_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player3, 0, 0, 0)
        sizer_2_copy_1_copy_3_copy_copy_1.Add(self.combo_battleroom_players_status_player3, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_3_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_4_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player4, 0, 0, 0)
        sizer_2_copy_1_copy_4_copy_copy_1.Add(self.combo_battleroom_players_status_player4, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_4_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_5_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player5, 0, 0, 0)
        sizer_2_copy_1_copy_5_copy_copy_1.Add(self.combo_battleroom_players_status_player5, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_5_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_6_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player6, 0, 0, 0)
        sizer_2_copy_1_copy_6_copy_copy_1.Add(self.combo_battleroom_players_status_player6, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_6_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_7_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player7, 0, 0, 0)
        sizer_2_copy_1_copy_7_copy_copy_1.Add(self.combo_battleroom_players_status_player7, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_7_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_8_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player8, 0, 0, 0)
        sizer_2_copy_1_copy_8_copy_copy_1.Add(self.combo_battleroom_players_status_player8, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_8_copy_copy_1, 1, wx.EXPAND, 0)
        sizer_2_copy_1_copy_9_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player9, 0, 0, 0)
        sizer_2_copy_1_copy_9_copy_copy_1.Add(self.combo_battleroom_players_status_player9, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_9_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_10_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player10, 0, 0, 0)
        sizer_2_copy_1_copy_10_copy_copy_1.Add(self.combo_battleroom_players_status_player10, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_10_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_11_copy_1_copy_1.Add(self.bitmap_battleroom_players_icon_player11, 0, 0, 0)
        sizer_2_copy_1_copy_11_copy_1_copy_1.Add(self.combo_battleroom_players_status_player11, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_11_copy_1_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1.Add(self.bitmap_battleroom_players_icon_player12, 0, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1.Add(self.combo_battleroom_players_status_player12, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_11_copy_copy_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy.Add(self.bitmap_battleroom_players_icon_player13, 0, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy.Add(self.combo_battleroom_players_status_player13, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_11_copy_copy_copy_1_copy, 1, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_1.Add(self.bitmap_battleroom_players_icon_player14, 0, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_1.Add(self.combo_battleroom_players_status_player14, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_1, 1, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_2.Add(self.bitmap_battleroom_players_icon_player15, 0, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_2.Add(self.combo_battleroom_players_status_player15, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_2, 1, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_3.Add(self.bitmap_battleroom_players_icon_player16, 0, 0, 0)
        sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_3.Add(self.combo_battleroom_players_status_player16, 0, 0, 0)
        sizer_battleroom_players_name.Add(sizer_2_copy_1_copy_11_copy_copy_copy_1_copy_3, 1, 0, 0)
        grid_battleroom_players.Add(sizer_battleroom_players_name, 0, wx.EXPAND, 0)
        grid_battleroom_players.Add((15, 300), 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.label_battleroom_players_faction, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player1, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player2, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player3, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player4, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player5, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player6, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player7, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player8, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player9, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player10, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player11, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player12, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player13, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player14, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player15, 0, 0, 0)
        sizer_battleroom_players_faction.Add(self.combo_battleroom_players_faction_player16, 0, 0, 0)
        grid_battleroom_players.Add(sizer_battleroom_players_faction, 0, wx.EXPAND, 0)
        grid_battleroom_players.Add((15, 300), 0, 0, 0)
        sizer_battleroom_players_team_copy.Add(self.label_battleroom_players_sharedArmy, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player1, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player2, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player3, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player4, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player5, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player6, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player7, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player8, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player9, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player10, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player11, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player12, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player13, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player14, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player15, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team_copy.Add(self.combo_battleroom_players_sharedArmy_player16, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_players.Add(sizer_battleroom_players_team_copy, 0, wx.EXPAND, 0)
        grid_battleroom_players.Add((15, 300), 0, 0, 0)
        sizer_battleroom_players_team.Add(self.label_battleroom_players_team, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player1, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player2, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player3, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player4, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player5, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player6, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player7, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player8, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player9, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player10, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player11, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player12, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player13, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player14, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player15, 0, 0, 0)
        sizer_battleroom_players_team.Add(self.combo_battleroom_players_team_player16, 0, 0, 0)
        grid_battleroom_players.Add(sizer_battleroom_players_team, 0, wx.EXPAND, 0)
        grid_battleroom_players.Add((15, 300), 0, 0, 0)
        sizer_battleroom_players_handicap.Add(self.label_battleroom_players_handicap, 0, 0, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player1, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player2, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player3, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player4, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player5, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player6, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player7, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player8, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player9, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player10, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player11, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player12, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player13, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player14, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player15, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_handicap.Add(self.spin_battleroom_players_handicap_player16, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_players.Add(sizer_battleroom_players_handicap, 0, wx.EXPAND, 0)
        grid_battleroom_players.Add((15, 300), 0, 0, 0)
        sizer_battleroom_players_ready.Add(self.label_battleroom_players_ready, 0, 0, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player1, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player2, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player3, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player4, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player5, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player6, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player7, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player8, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player9, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player10, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player11, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player12, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player13, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player14, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player15, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_players_ready.Add(self.checkbox_battleroom_ready_player16, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_players.Add(sizer_battleroom_players_ready, 1, wx.EXPAND, 0)
        grid_battleroom_players.Add((15, 300), 0, 0, 0)
        sizer_battleroom_players_sync.Add(self.label_battleroom_players_sync, 0, 0, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player1, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player2, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL|wx.FIXED_MINSIZE, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player3, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player4, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player5, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player6, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player7, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player8, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player9, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player10, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player11, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player12, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player13, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player14, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player15, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_sync.Add(self.bitmap_battleroom_players_sync_player16, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_players.Add(sizer_battleroom_players_sync, 1, wx.EXPAND, 0)
        grid_battleroom_players.Add((15, 300), 0, 0, 0)
        sizer_battleroom_players_ping.Add(self.label_battleroom_players_ping, 0, 0, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player1, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player2, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player3, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player4, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player5, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player6, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player7, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player8, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player9, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player10, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player11, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player12, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player13, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player14, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player15, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_players_ping.Add(self.bitmap_battleroom_players_ping_player16, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_players.Add(sizer_battleroom_players_ping, 1, wx.EXPAND, 0)
        grid_battleroom_players.AddGrowableRow(0)
        grid_battleroom_players.AddGrowableCol(0)
        grid_battleroom_players.AddGrowableCol(1)
        grid_battleroom_players.AddGrowableCol(2)
        grid_battleroom_players.AddGrowableCol(3)
        grid_battleroom_players.AddGrowableCol(4)
        grid_battleroom_players.AddGrowableCol(5)
        grid_battleroom_players.AddGrowableCol(6)
        grid_battleroom_players.AddGrowableCol(7)
        grid_battleroom_players.AddGrowableCol(8)
        grid_battleroom_players.AddGrowableCol(9)
        grid_battleroom_players.AddGrowableCol(10)
        grid_battleroom_players.AddGrowableCol(11)
        grid_battleroom_players.AddGrowableCol(12)
        grid_battleroom_players.AddGrowableCol(13)
        grid_battleroom_players.AddGrowableCol(14)
        grid_battleroom_players.AddGrowableCol(15)
        sizer_8.Add(grid_battleroom_players, 0, wx.ADJUST_MINSIZE, 0)
        sizer_8.Add((100, 15), 0, wx.ADJUST_MINSIZE, 0)
        grid_sizer_2.Add(self.text_battleroom_players_chatarea, 0, wx.EXPAND, 0)
        sizer_5.Add(self.text_battleroom_players_msgbox, 0, wx.EXPAND, 0)
        sizer_5.Add(self.button_battleroom_players_sendmsg, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_5.AddGrowableRow(0)
        sizer_5.AddGrowableCol(0)
        grid_sizer_2.Add(sizer_5, 1, wx.EXPAND, 0)
        grid_sizer_2.AddGrowableRow(0)
        grid_sizer_2.AddGrowableCol(0)
        sizer_8.Add(grid_sizer_2, 1, wx.EXPAND, 0)
        grid_battleroom_main.Add(sizer_8, 1, wx.EXPAND, 0)
        grid_battleroom_main.Add((15, 500), 0, wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_name_copy.Add(self.label_battleroom_server_battleName, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_name_copy.Add(self.text_battleroom_server_nameData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_server.Add(sizer_host_battle_name_copy, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_server.Add((200, 5), 0, 0, 0)
        sizer_host_battle_name_copy_copy.Add(self.label_battleroom_server_mapName, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_name_copy_copy.Add(self.text_battleroom_server_map, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_server.Add(sizer_host_battle_name_copy_copy, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_server.Add((200, 5), 0, 0, 0)
        sizer_host_battle_name_copy_copy_1.Add(self.label_battleroom_server_modName, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_name_copy_copy_1.Add(self.text_battleroom_server_mod, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_server.Add(sizer_host_battle_name_copy_copy_1, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_server.Add((200, 15), 0, 0, 0)
        sizer_host_battle_maxUnits_copy.Add(self.label_battleroom_server_maxUnits, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_maxUnits_copy.Add(self.text_battleroom_server_maxUnitsData, 0, 0, 0)
        grid_battleroom_server.Add(sizer_host_battle_maxUnits_copy, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_server.Add((200, 12), 0, 0, 0)
        sizer_host_battle_startEnergy_copy.Add(self.label_battleroom_server_startEnergy, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_startEnergy_copy.Add(self.text_battleroom_server_startEnergyData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_server.Add(sizer_host_battle_startEnergy_copy, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_server.Add((200, 12), 0, 0, 0)
        sizer_host_battle_startMetal_copy.Add(self.label_battleroom_server_startMetal, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_host_battle_startMetal_copy.Add(self.text_battleroom_server_startMetalData, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_server.Add(sizer_host_battle_startMetal_copy, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_server.Add((200, 15), 0, 0, 0)
        sizer_battleroom_server_handicaps.Add(self.checkbox_battleroom_server_handicap, 0, 0, 0)
        sizer_battleroom_server_handicaps.Add(self.checkbox_battleroom_server_hostModifiesHandicaps, 0, wx.ALIGN_RIGHT, 0)
        grid_battleroom_server.Add(sizer_battleroom_server_handicaps, 1, wx.ALL|wx.EXPAND, 1)
        grid_battleroom_server.Add((200, 15), 0, 0, 0)
        sizer_battleroom_map_startPos.Add(self.label_battleroom_map_startPos, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_map_startPos.Add((9, 20), 0, 0, 0)
        sizer_battleroom_map_startPos.Add(self.choice_battleroom_map_startPosData, 0, 0, 0)
        grid_battleroom_server.Add(sizer_battleroom_map_startPos, 1, 0, 0)
        grid_battleroom_server.Add((200, 5), 0, 0, 0)
        sizer_battleroom_map_winConditions.Add(self.label_battleroom_map_winConditions, 0, wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_map_winConditions.Add((9, 20), 0, 0, 0)
        sizer_battleroom_map_winConditions.Add(self.choice_battleroom_map_winConditionData, 0, wx.EXPAND, 0)
        grid_battleroom_server.Add(sizer_battleroom_map_winConditions, 1, 0, 0)
        grid_battleroom_server.Add((200, 15), 0, 0, 0)
        grid_battleroom_server.Add(self.checkbox_battleroom_server_rememberBuildingsLOS, 0, wx.EXPAND, 0)
        grid_battleroom_server.Add((200, 5), 0, 0, 0)
        grid_battleroom_server.Add(self.checkbox_battleroom_server_limitdgunData, 0, wx.EXPAND, 0)
        grid_battleroom_server.Add((200, 15), 0, wx.EXPAND, 0)
        grid_battleroom_server.Add(self.button_battleroom_server_startGame, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        self.panel_battleroom_server.SetAutoLayout(True)
        self.panel_battleroom_server.SetSizer(grid_battleroom_server)
        grid_battleroom_server.Fit(self.panel_battleroom_server)
        grid_battleroom_server.SetSizeHints(self.panel_battleroom_server)
        grid_battleroom_server.AddGrowableRow(21)
        grid_battleroom_server.AddGrowableCol(0)
        grid_battleroom_map.Add(self.bitmap_battleroom_map_preview, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_map.Add((135, 15), 0, 0, 0)
        grid_battleroom_map.Add(self.choice_battleroom_map_mapData, 0, wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_map.Add((135, 15), 0, 0, 0)
        sizer_3_copy.Add(self.label_battleroom_map_positions, 0, wx.FIXED_MINSIZE, 0)
        sizer_3_copy.Add((55, 20), 0, 0, 0)
        self.label_battleroom_map_positionsData.SetFont(wx.Font(10, wx.DEFAULT, wx.NORMAL, wx.BOLD, 0, ""))
        sizer_3_copy.Add(self.label_battleroom_map_positionsData, 0, wx.EXPAND, 0)
        grid_battleroom_map_settings.Add(sizer_3_copy, 1, wx.EXPAND, 0)
        grid_battleroom_map_settings.Add((135, 0), 0, 0, 0)
        sizer_3.Add(self.label_battleroom_map_size, 0, wx.FIXED_MINSIZE, 0)
        sizer_3.Add((20, 20), 0, 0, 0)
        sizer_3.Add(self.label_battleroom_map_sizeData, 0, wx.ADJUST_MINSIZE, 0)
        grid_battleroom_map_settings.Add(sizer_3, 1, wx.EXPAND, 0)
        grid_battleroom_map_settings.Add((135, 15), 0, 0, 0)
        sizer_battleroom_map_description.Add(self.label_battleroom_map_description, 0, 0, 0)
        sizer_battleroom_map_description.Add(self.text_battleroom_map_description, 0, wx.ALL, 1)
        grid_battleroom_map_settings.Add(sizer_battleroom_map_description, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_map_settings.Add((135, 15), 0, 0, 0)
        sizer_battleroom_map_tidal.Add(self.label_battleroom_map_tidal, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_map_tidal.Add((60, 20), 0, 0, 0)
        sizer_battleroom_map_tidal.Add(self.spin_battleroom_map_tidalData, 0, 0, 0)
        grid_battleroom_map_settings.Add(sizer_battleroom_map_tidal, 1, wx.ALIGN_CENTER_HORIZONTAL, 1)
        sizer_battleroom_map_gravity.Add(self.label_battleroom_map_gravity, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_map_gravity.Add((60, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_battleroom_map_gravity.Add(self.spin_battleroom_map_gravityData, 0, 0, 0)
        grid_battleroom_map_settings.Add(sizer_battleroom_map_gravity, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_battleroom_map_metal.Add(self.label_battleroom_map_maxMetal, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_map_metal.Add((60, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_battleroom_map_metal.Add(self.spin_battleroom_map_maxMetalData, 0, 0, 0)
        grid_battleroom_map_settings.Add(sizer_battleroom_map_metal, 1, wx.EXPAND, 0)
        sizer_battleroom_map_extract.Add(self.label_battleroom_map_extractorRadius, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_map_extract.Add((50, 20), 0, 0, 0)
        sizer_battleroom_map_extract.Add(self.spin_battleroom_map_extractorRadiusData, 0, 0, 0)
        grid_battleroom_map_settings.Add(sizer_battleroom_map_extract, 1, wx.EXPAND, 0)
        sizer_battleroom_map_minWind.Add(self.label_battleroom_map_minWind, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_map_minWind.Add((60, 20), 0, 0, 0)
        sizer_battleroom_map_minWind.Add(self.spin_battleroom_map_minWindData, 0, 0, 0)
        grid_battleroom_map_settings.Add(sizer_battleroom_map_minWind, 1, wx.EXPAND, 0)
        sizer_battleroom_map_maxWind.Add(self.label_battleroom_map_maxWind, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_battleroom_map_maxWind.Add((60, 20), 0, 0, 0)
        sizer_battleroom_map_maxWind.Add(self.spin_battleroom_map_maxWindData, 0, 0, 0)
        grid_battleroom_map_settings.Add(sizer_battleroom_map_maxWind, 1, wx.EXPAND, 0)
        grid_battleroom_map_settings.Add(self.button_battleroom_map_revertToDefaults, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_map.Add(grid_battleroom_map_settings, 1, wx.ALIGN_CENTER_HORIZONTAL, 1)
        grid_battleroom_map.Add((135, 22), 0, wx.EXPAND, 0)
        grid_battleroom_map.Add(self.button_battleroom_map_disabledUnits, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        self.panel_battleroom_map.SetAutoLayout(True)
        self.panel_battleroom_map.SetSizer(grid_battleroom_map)
        grid_battleroom_map.Fit(self.panel_battleroom_map)
        grid_battleroom_map.SetSizeHints(self.panel_battleroom_map)
        grid_battleroom_map.AddGrowableRow(5)
        grid_battleroom_map.AddGrowableCol(0)
        grid_battleroom_mod.Add(self.bitmap_battleroom_mod_preview, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_mod.Add((135, 15), 0, 0, 0)
        grid_battleroom_mod.Add(self.choice_battleroom_mod_modData, 0, wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_mod.Add((135, 15), 0, 0, 0)
        sizer_battleroom_mod_fileList.Add(self.label_battleroom_mod_fileList, 0, 0, 0)
        sizer_battleroom_mod_fileList.Add(self.tree_battleroom_mod_fileList, 1, wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_mod.Add(sizer_battleroom_mod_fileList, 1, wx.EXPAND, 0)
        grid_battleroom_mod.Add((135, 15), 0, 0, 0)
        sizer_battleroom_mod_description.Add(self.label_battleroom_mod_description, 0, 0, 0)
        sizer_battleroom_mod_description.Add(self.text_battleroom_mod_description, 0, wx.ALL|wx.ALIGN_CENTER_HORIZONTAL, 1)
        grid_battleroom_mod_settings.Add(sizer_battleroom_mod_description, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_mod_settings.Add((100, 15), 0, 0, 0)
        grid_battleroom_mod_settings.Add(self.label_battleroom_mod_settings, 0, 0, 0)
        grid_battleroom_mod_settings.Add(self.list_battleroom_mod_settings, 1, wx.EXPAND|wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_mod_settings.Add((100, 8), 0, 0, 0)
        sizer_battleroom_mod_settingInput.Add(self.text_battleroom_mod_settingInputData, 0, 0, 0)
        sizer_battleroom_mod_settingInput.Add(self.button_battleroom_mod_updateSetting, 0, 0, 0)
        sizer_battleroom_mod_settingInput.Add(self.button_battleroom_mod_defaultSetting, 0, 0, 0)
        grid_battleroom_mod_settings.Add(sizer_battleroom_mod_settingInput, 1, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_mod_settings.Add((150, 15), 0, 0, 0)
        grid_battleroom_mod_settings.Add(self.button_battleroom_mod_revertToDefaults, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_battleroom_mod.Add(grid_battleroom_mod_settings, 1, wx.EXPAND, 1)
        self.panel_battleroom_mod.SetAutoLayout(True)
        self.panel_battleroom_mod.SetSizer(grid_battleroom_mod)
        grid_battleroom_mod.Fit(self.panel_battleroom_mod)
        grid_battleroom_mod.SetSizeHints(self.panel_battleroom_mod)
        grid_battleroom_mod.AddGrowableRow(0)
        grid_battleroom_mod.AddGrowableRow(1)
        grid_battleroom_mod.AddGrowableRow(2)
        grid_battleroom_mod.AddGrowableRow(3)
        grid_battleroom_mod.AddGrowableRow(4)
        grid_battleroom_mod.AddGrowableRow(5)
        grid_battleroom_mod.AddGrowableRow(6)
        grid_battleroom_mod.AddGrowableRow(7)
        grid_battleroom_mod.AddGrowableRow(8)
        grid_battleroom_mod.AddGrowableCol(0)
        self.notebook_battleroom_settings.AddPage(self.panel_battleroom_server, "Server")
        self.notebook_battleroom_settings.AddPage(self.panel_battleroom_map, "Map")
        self.notebook_battleroom_settings.AddPage(self.panel_battleroom_mod, "Mod")
        grid_battleroom_main.Add(self.notebook_battleroom_settings, 1, 0, 0)
        grid_battleroom_main.Add((10, 500), 0, wx.ALIGN_CENTER_VERTICAL, 0)
        grid_battleroom_main.Add((10, 10), 0, 0, 0)
        grid_battleroom_main.Add((400, 10), 0, 0, 0)
        grid_battleroom_main.Add((15, 10), 0, 0, 0)
        grid_battleroom_main.Add((175, 10), 0, 0, 0)
        grid_battleroom_main.Add((10, 10), 0, 0, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_battleroom_main)
        grid_battleroom_main.Fit(self)
        grid_battleroom_main.SetSizeHints(self)
        grid_battleroom_main.AddGrowableRow(1)
        grid_battleroom_main.AddGrowableCol(1)
        self.Layout()
        self.Centre()
        # end wxGlade

# end of class gui_battleroom


