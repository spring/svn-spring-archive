#!/usr/bin/env python

#======================================================
 #            main.py
 #
 #  Thurs September 7 11:20 2006
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
import pygtk
import gtk
import os
import sys
import gc
import ConfigParser

from optparse import OptionParser


# Custom Modules
import unitsync

from Battle import battle
from Config import config
from GUI_Lobby import gui_lobby

from Map_Index import index_map
from Mod_Index import index_mod


class MainWindow:

	def __init__(self, profile):
		gtk.gdk.threads_init()

		self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)

		self.profile = profile
		self.platform = sys.platform

		if self.platform != 'win32':
			# Linux
			HOME = os.environ['HOME']
			self.profile_dir = os.path.join(HOME, '.unity-lobby', 'profiles', profile)
			self.ini_file = os.path.join(HOME, '.unity-lobby', 'profiles', 'setup.ini')
	        else:
	                # Windows
	                APPDATA = os.environ['APPDATA']
	             	self.setup_dir = os.path.join(APPDATA, 'unity-lobby', 'profiles', profile)
	                self.ini_file = os.path.join(APPDATA, 'unity-lobby', 'profiles', 'setup.ini')


		self.ini = ConfigParser.ConfigParser()
		self.ini.optionxform = lambda x: x
		self.ini.read(self.ini_file)
		
		self.map_index_file = self.ini.get(self.profile, 'MAP_INDEX')
		self.mod_index_file = self.ini.get(self.profile, 'MOD_INDEX')

		self.lobby_ini_file = self.ini.get(self.profile, 'LOBBY_CONF')
		self.lobby_ini = ConfigParser.ConfigParser()
		self.lobby_ini.optionxform = lambda x: x
		self.lobby_ini.read(self.lobby_ini_file)

		# Create Lobby .ini if missing
		if os.path.isfile(self.lobby_ini_file) == False:
			dest_fd = open(self.lobby_ini_file,"w+")
			dest_fd.close()

		# Make Temp Config File
		self.conf_file = self.ini.get(self.profile, 'SPRING_CONF')
		self.conf_temp_file = self.ini.get(self.profile, 'SPRING_CONF_TEMP')
		self.temp_config(False)

		self.conf_temp = ConfigParser.ConfigParser()
		self.conf_temp.optionxform = lambda x: x
		self.conf_temp.read(self.conf_temp_file)



	def destroy(self, window, event):
		self.save_window_size()
		try:
			self.client.disconnect('User')
		except:
			pass
		if self.platform != 'win32':
			self.config.unix_save_spring_options()
		else:
			self.config.windows_save_spring_options()
		gc.set_debug(gc.DEBUG_UNCOLLECTABLE)
		gtk.main_quit()


	def save_window_size(self):
		width, height = self.window.get_size()
		# Check if Battle Notebook is visible to save its screen size to setup profile
		if self.battle_notebook.flags() & gtk.VISIBLE  == gtk.VISIBLE:
			self.ini.set(self.profile, 'BATTLE_WINDOW_WIDTH', width)
			self.ini.set(self.profile, 'BATTLE_WINDOW_HEIGHT', height)
		# Check if Lobby Table is visible to save its screen size to setup profile
		elif self.lobby_table.flags() & gtk.VISIBLE  == gtk.VISIBLE:
			self.ini.set(self.profile, 'LOBBY_WINDOW_WIDTH', width)
			self.ini.set(self.profile, 'LOBBY_WINDOW_HEIGHT', height)
		# Check if Options Notebook is visible to save its screen size to setup profile
		elif self.options_notebook.flags() & gtk.VISIBLE  == gtk.VISIBLE:
			self.ini.set(self.profile, 'OPTIONS_WINDOW_WIDTH', width)
			self.ini.set(self.profile, 'OPTIONS_WINDOW_HEIGHT', height)
		self.ini.write(open(self.ini_file, "w+"))
		self.ini.read(self.ini_file)


	def battle_section(self, widget=None, event=None):
		self.battle.player_name_update(self.config.get_player_name())
		self.save_window_size()
		battle_height = self.ini.getint(self.profile, 'BATTLE_WINDOW_HEIGHT')
		battle_width = self.ini.getint(self.profile, 'BATTLE_WINDOW_WIDTH')
		self.start_item.show()
		self.options_notebook.hide()
		self.lobby_table.hide()
		self.battle_notebook.show()
		self.window.resize(battle_width,battle_height)


	def config_section(self, widget=None, event=None):
		self.save_window_size()
		options_height = self.ini.getint(self.profile, 'OPTIONS_WINDOW_HEIGHT')
		options_width = self.ini.getint(self.profile, 'OPTIONS_WINDOW_WIDTH')
		self.start_item.hide()
		self.battle_notebook.hide()
		self.lobby_table.hide()
		self.options_notebook.show()
		self.window.resize(options_width,options_height)


	def lobby_section(self, widget=None, event=None):
		self.save_window_size()
		lobby_height = self.ini.getint(self.profile, 'LOBBY_WINDOW_HEIGHT')
		lobby_width = self.ini.getint(self.profile, 'LOBBY_WINDOW_WIDTH')
		self.start_item.hide()
		self.battle_notebook.hide()
		self.options_notebook.hide()
		self.lobby_table.show()
		self.window.resize(lobby_width,lobby_height)


	def setup(self, progressbar):

		# Get Datadirs from unitsync
		datadir = self.ini.get(self.profile, 'SPRING_DATADIR', None)
		if datadir != None:
			os.chdir(datadir)
		unitsync.Init(True,1)
		self.datadirs = []
		datadirs = unitsync.GetDataDirectories(False)
		for i in range(0,len(datadirs)):
			if os.path.isdir(datadirs[i]) == True:
				self.datadirs.append(datadirs[i])

		# Map Index
		self.map_index = index_map(self.map_index_file, progressbar)
		if os.path.isfile(self.map_index_file) == False:
			self.map_index.create_index()
		self.map_index.check_if_update_needed()

		# Mod Index
		self.mod_index = index_mod(self.mod_index_file, progressbar)
		if os.path.isfile(self.mod_index_file) == False:
			self.mod_index.create_index()
		self.mod_index.check_if_update_needed()


		self.lobby_table = gtk.Table(rows=2, columns=2, homogeneous=False)
		self.gui_lobby = gui_lobby(self)
		self.config = config(self)
		self.battle = battle(self)

		# Main Window
		self.window.set_title("Unity Lobby")
		self.window.set_resizable(True)
		self.window.connect("delete-event", gtk.main_quit)
		self.window.add_events(gtk.gdk.BUTTON_PRESS_MASK)

		# Vertical Box Part 1/2
		vbox = gtk.VBox(False, 0)
		vbox.show()
		self.window.add(vbox)

		# Menu Part 1/2
		menu_bar = gtk.MenuBar()
		menu_bar.show()

		# Battle Notebook
		self.battle_notebook = gtk.Notebook()
	        self.battle_notebook.set_tab_pos(gtk.POS_LEFT)
		self.battle.create(self.battle_notebook)

		# Options Notebook
	        self.options_notebook = gtk.Notebook()
		self.options_notebook.set_tab_pos(gtk.POS_LEFT)
		self.config.create(self.options_notebook)




		#Vertical Box Part 2/2
		vbox.pack_start(menu_bar, False, False, 2)
		vbox.pack_start(self.battle_notebook, True, True, 2)
		vbox.pack_start(self.options_notebook, True, True, 2)
		vbox.pack_start(self.lobby_table, True, True, 2)

		self.window.show()

		# Menu Part 2/2
			#Menu Items
		battle_item = gtk.MenuItem("Battle")
		lobby_item = gtk.MenuItem("Lobby")
		config_item = gtk.MenuItem("Options")
		self.start_item = gtk.MenuItem("Start")
		menu_bar.append(battle_item)
		menu_bar.append(lobby_item)
		menu_bar.append(config_item)
		menu_bar.append(self.start_item)

		battle_item.show()
		lobby_item.show()
		self.start_item.set_right_justified(1)
		config_item.show()

			#Menu-Connect
		battle_item.connect("button_press_event", self.battle_section)
		config_item.connect("button_press_event", self.config_section)
		self.start_item.connect("button_press_event", self.battle.script_create)
		lobby_item.connect("button_press_event", self.lobby_section)

			# Main Window destory event
		self.window.connect("delete-event", self.destroy)

		self.battle_section(None, None)


	def temp_config(self, save):  # self.conf, self.conf_temp
		import re
		import fileinput
	# Save variable is to set it to remove | add hack
	# If Save is set to No  then it adds    the hack
	# If Save is set to Yes then it removes the hack
	#		Hack is adding [MAIN] to temp file  so can use ConfigParser on the temp file
	# If Save is anything else  it just copies the src(file) -> dest(file)
		if save == False:
			src  = self.conf_file
			dest = self.conf_temp_file
		else:
			dest = self.conf_file
			src  = self.conf_temp_file

		dest_fd = open(dest,"w+")
		remove_whitespace = re.compile('( = )')

		empty = True

		if os.path.isfile(src) == True:
			for line in fileinput.input(src):
				empty = False
				line_fixed = remove_whitespace.sub('=',line)
				if fileinput.isfirstline() == True:
					if save == False:
						if line != '[GAME]\n':
							dest_fd.write('[GAME]\n')
						dest_fd.write(line_fixed)
				else:
					dest_fd.write(line_fixed)
		if empty == True:
			dest_fd.write('[GAME]\n')
		dest_fd.close()



	def main(self):
		gtk.threads_enter()

		# Splash
		splash = gtk.Window()
		splash.set_decorated(False)
		splash.set_position(gtk.WIN_POS_CENTER)

			# VBox
		vbox = gtk.VBox(homogeneous=False, spacing=0)	
		vbox.show()
		splash.add(vbox)

				# Background
		background = gtk.Image()
		background.set_from_file(self.ini.get(self.profile, 'BACKGROUND'))
		background.show()
		vbox.pack_start(background, expand=True, fill=True, padding=0)

				# ProgressBar
		progressbar = gtk.ProgressBar()
		progressbar.show()
		progressbar.set_text('Please Wait')
		vbox.pack_end(progressbar, expand=True, fill=True, padding=0)

		splash.show()
		while gtk.events_pending():
			gtk.main_iteration()
		self.setup(progressbar)
#		splash.hide()
		splash.destroy()

		gtk.main()
		gtk.threads_leave()



if __name__ == "__main__":
        parser = OptionParser()
        parser.add_option("-p", "--profile", action="store", type="string", dest="profile", default=None, help="Internal Use Only -> Start Profile")
        (options, args) = parser.parse_args()

	platform = sys.platform

	main_window = MainWindow(options.profile)
	main_window.main()
