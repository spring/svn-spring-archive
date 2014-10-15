#!/usr/bin/env python

#======================================================
 #            Battle.py
 #
 #  Sat July 26 11:20 2006
 #  Copyright  2006  Josh Mattila
 #  		     Declan Ireland
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


# Generic Modules
import os
import string

# Custom Modules
import unitsync

import Config
import Index_Mod


def kick_player(widget, event, self, iter):
	# Removes Player / Bot from Player List
	if iter != None:
		self.player_liststore.remove(iter)

def add_bot(widget,event, self, ai, ai_location, side):
	# AI Owner
	ai_owner = Config.get_option(self.conf_temp, 'GAME', 'name', 'Player')

	# Team List
	team_count, ally_count = team_ally_count(self)
	if team_count == -1:
		team = 0
		ally = 0
	else:
		team = team_count[(len(team_count)-1)] + 1
		ally = ally_count[(len(ally_count)-1)] + 1

				  # Ready       = Icon
				  # Name        = String & Icon for Rank
				  # Team        = Number  Need Colour Display Somehow  FIX FIX FIX
				  # Side        = String
				  # Ally        = Number
				  # Bonus	= int
				  # AI          = String
				  # AI Location = String
				  # AI Owner    = String
	self.player_liststore.append(['ready', None, team, side, ally, 0, ai, ai_owner, ai_location])

def add_player(widget,event, self, side):
	# Team List
	team_count, ally_count = team_ally_count(self)
	if team_count == -1:
		team = 0
		ally = 0
	else:
		team = team_count[(len(team_count)-1)] + 1
		ally = ally_count[(len(ally_count)-1)] + 1

	# Ally
	ally = team

	# Bonus
	bonus = 0
				  # Ready       = Icon
				  # Name        = String & Icon for Rank
				  # Team        = Number  Need Colour Display Somehow  FIX FIX FIX
				  # Side        = String
				  # Ally        = Number
				  # Bonus	= int
				  # AI          = String
				  # AI Location = String
				  # AI Owner    = String
	self.player_liststore.append(['ready', self.my_player_name, team, side, ally, bonus, None, None, None])


def change_value(widget,event, self, iter, column, value):
# Changes Value in Player Liststore
	self.player_liststore.set_value(iter, column, value)



def team_ally_list(self):
	# Team List
	team_list = []
	ally_list = []
	treeiter = self.player_liststore.get_iter_first()
	if treeiter != None:
		while treeiter != None:
			team_list.append(self.player_liststore.get_value(treeiter,2))
			ally_list.append(self.player_liststore.get_value(treeiter,4))
			treeiter = self.player_liststore.iter_next(treeiter)
		return team_list, ally_list
	else:
		return -1, -1

def team_ally_count(self):
	team_list, ally_list = team_ally_list(self)
	if team_list != -1:
		team_count = []
		ally_count = []
		team_list.sort()
		ally_list.sort()
		# Team
		temp = None
		for i in range(0,len(team_list)):
			if team_list[i] != temp:
				team_count.append(team_list[i])
				temp = team_list[i]
		# Ally
		temp = None
		for i in range(0,len(ally_list)):
			if ally_list[i] != temp:
				ally_count.append(ally_list[i])
				temp = ally_list[i]

		return team_count, ally_count
	else:
		return -1,1

def team_ally_convert_list(self):
	team_list, ally_list = team_ally_list(self)
	bad_team_list, bad_ally_list = team_ally_list(self)
	team_count, ally_count = team_ally_count(self)
	if team_count != -1:
		temp = 0
		for i in range(0,len(team_count)):
			if team_count[i] > temp:
				voodoo = team_count[i]
				for p in range(0,len(team_list)):
					if team_list[p] == voodoo:
						team_list[p] = temp
				for p in range(0,len(team_count)):
					if team_count[p] == voodoo:
						team_count[p] = temp
				temp = temp + 1
			elif team_count[i] == temp:
				temp = temp + 1

		temp = 0
		for i in range(0,len(ally_count)):
			if ally_count[i] > temp:
				voodoo = ally_count[i]
				for p in range(0,len(ally_list)):
					if ally_list[p] == voodoo:
						ally_list[p] = temp
				for p in range(0,len(ally_count)):
					if ally_count[p] == voodoo:
						ally_count[p] = temp
				temp = temp + 1
			elif ally_count[i] == temp:
				temp = temp + 1

		return team_count, team_list, bad_team_list, ally_count, ally_list, bad_ally_list
	else:
		return -1, -1



def find_ai(platform, datadirs):
	# Used to locate files with a certain extension in a directory i.e AIs
	ai = []
	ai_location = []

	if platform != 'win32':
		extension = '.so'
	else:
		extension = '.dll'
	length = len(extension)
	length = length - ( length + length )

	for i in range (0,len(datadirs)):
		scandir = os.path.join(datadirs[i],'aidll','globalai')
		if os.path.isdir(scandir) == True:
			file_listings = os.listdir(os.path.join(datadirs[i],'aidll','globalai'))
			for p in range (0,(len(file_listings))):
				if file_listings[p][length:] == extension:
					ai.append(file_listings[p][:length])
					ai_location.append(os.path.join(datadirs[i],'aidll','globalai',file_listings[p]))
	return ai, ai_location

def script_create(widget, event, self):
	# Save Config Values
	Config.save(self,self.conf,self.conf_temp)

	# Player Name
	my_player_name = Config.get_option(self.conf_temp, 'GAME', 'name', 'Player')
	# Player Number
	my_player_number = '0' # TODO -> HardCoded till get Lobby added
	# Number of Players
	num_of_players = '1'   # TODO -> HardCoded till get Lobby added
	# Team Data
	team_count, team_list, bad_team_list, ally_count, ally_list, bad_ally_list = team_ally_convert_list(self)
	if team_count != -1:

			# Map Name
	 	treeselection = self.map_treeview.get_selection()
		(model, iter) = treeselection.get_selected()
		map_name = self.map_liststore.get_value(iter, 0)

			# Mod Name
	 	treeselection = self.mod_treeview.get_selection()
		(model, iter) = treeselection.get_selected()
		mod_name = Index_Mod.mod_archive(self, self.mod_liststore.get_value(iter, 1))

			# Player / AI info
		treeiter = self.player_liststore.get_iter_first()
		if treeiter != None:
			ai_location = []
			bonus = []
			sides = []
			spectator = '1'
			while treeiter != None:
				if self.player_liststore.get_value(treeiter, 1) == my_player_name:
					my_player_team = str(self.player_liststore.get_value(treeiter,2))
					for i in range(0,len(bad_team_list)):
						if bad_team_list[i] == int(my_player_team):
							my_player_team = str(team_list[i])
					spectator = '0'

				sides.append(self.player_liststore.get_value(treeiter, 3))
				bonus.append(self.player_liststore.get_value(treeiter, 5))
				ai_location.append(self.player_liststore.get_value(treeiter, 8))

				treeiter = self.player_liststore.iter_next(treeiter)

			# Making Script.txt
			fd_game = open(Config.get_option(self.ini, self.profile, 'SPRING_SCRIPT', ''),'w+')
			fd_game.write('[GAME]\n')
			fd_game.write ('{\n')
			fd_game.write ('Mapname=' + map_name + '.smf'+ ';\n')
			fd_game.write ('StartMetal=' + str(self.start_metal_spinner.get_value_as_int()) + ';\n')
			fd_game.write ('StartEnergy=' + str(self.start_energy_spinner.get_value_as_int()) + ';\n')
			fd_game.write ('MaxUnits=' + str(self.max_units_spinner.get_value_as_int()) + ';\n')
			fd_game.write ('GameType=' + mod_name + ';\n')
			fd_game.write ('GameMode=' + str(self.game_mode.get_active()) + ';\n')
			fd_game.write ('StartPosType=' + str(self.starting_positions.get_active()) + ';\n')
			fd_game.write ('MyPlayerNum=' + my_player_number + ';\n')
			fd_game.write ('NumPlayers=' + num_of_players + ';\n')
			fd_game.write ('NumTeams=' + str(len(team_count)) + ';\n')
			fd_game.write ('NumAllyTeams=' + str(len(team_count)) + ';\n')

			# Player
			fd_game.write ('[PLAYER0]\n')
			fd_game.write ('{\n')
			fd_game.write ('name=' + my_player_name + ';\n')
			fd_game.write ('Spectator='+ spectator + '/1;\n')
			if spectator == '0':
				fd_game.write ('team=' + my_player_team + ';\n')
			fd_game.write ('}\n')

			# Teams
			for i in range(0,(len(team_count))):
				fd_game.write ('[TEAM' + str(i) + ']\n')
				fd_game.write ('{\n')
				fd_game.write ('TeamLeader=0;\n') # TODO  Lobby Code / Teams / AI Owner
				fd_game.write ('Color=' + str(i) + ';\n')  # TODO Color
				fd_game.write ('Handicap=' + str(bonus[i]) + ';\n')


				fd_game.write ('AllyTeam=' + str(ally_list[i]) + ';\n')
				fd_game.write ('Side='+ sides[i] + ';\n')
				if ai_location[i] != None:
					fd_game.write('AiDLL=' + ai_location[i] + ';\n')
				fd_game.write ('}\n')


			# Ally Teams
			for i in range(0,len(ally_count)):
				fd_game.write ('[ALLYTEAM' + str(ally_count[i]) + ']\n')
				fd_game.write ('{\n')
				fd_game.write ('NumAllies=0;\n') # What the hell is this for??????/
				fd_game.write ('}\n')


			fd_game.write ('}\n')
			fd_game.close()
	start(self)

def start(self):
	spring = Config.get_option(self.ini, self.profile, 'SPRING_BINARY', '')
	script = Config.get_option(self.ini, self.profile, 'SPRING_SCRIPT', '')

	if self.platform != 'win32':
		if self.gdb_backtrace.get_active() == 1:
			# TODO: need better checks... maybe test for existance of gdb, whether spring has been compiled with debugging info, etc.
                        gdb_script = Config.get_option(self.ini, self.profile, 'GDB_SCRIPT_TEMP', '')
                        f = file(gdb_script, 'w')
                        f.write('run %s\nbacktrace\nquit\n' % (script))
                        f.close()
                        os.spawnlp(os.P_NOWAIT, 'gdb', 'gdb', spring, '-x', gdb_script, '-n', '-q', '-batch')

	       	elif self.gdb_backtrace.get_active() == 0:
			print ('WTH')
			os.spawnlp(os.P_NOWAIT, spring, spring, script)

	else:
		# TODO Add Windows Code
		print ('TODO Add Windows Code to start spring \path\to\script.txt')
		print ('Look in Battle.py   in  def start(self):')
