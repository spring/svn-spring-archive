#!/usr/bin/env python

#======================================================
 #            main.py
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
import pygtk
pygtk.require('2.0')  # TODO rewrite this so it requires 2.4.x or later i.e using newer file chooser widget
import gtk
import os
import sys


# Custom Modules
import unitsync

import GLOBAL

import Config
import GUI_Config
import GUI_Battle
import Battle
import GUI_Setup
import Index_Map
import Index_Mod


class MainWindow:

	def player_name_update(self):
	# When user selects Battle
	# This gets active text from Player Name in Configure Options
	# And updates the player entries in Player ListStore
		new_player_name = self.player_name.get_text()
		if new_player_name != self.my_player_name:
			treeiter = self.player_liststore.get_iter_first()
			while treeiter != None:
				if self.player_liststore.get_value(treeiter, 1) == self.my_player_name:
					self.player_liststore.set_value(treeiter, 1, new_player_name)
					treeiter = None
				else:
					treeiter = self.player_liststore.iter_next(treeiter)
			self.my_player_name = new_player_name


	def save_window_size(self, battle_notebook, options_notebook):
		width, height = self.window.get_size()
		# Check if Options Table was visible to save its screen size to setup profile
		if battle_notebook.flags() & gtk.VISIBLE  == gtk.VISIBLE:
			Config.set_option(self.ini, self.profile, 'BATTLE_WINDOW_WIDTH', width)
			Config.set_option(self.ini, self.profile, 'BATTLE_WINDOW_HEIGHT', height)
		# Check if Options Table was visible to save its screen size to setup profile
		if options_notebook.flags() & gtk.VISIBLE  == gtk.VISIBLE:
			Config.set_option(self.ini, self.profile, 'OPTIONS_WINDOW_WIDTH', width)
			Config.set_option(self.ini, self.profile, 'OPTIONS_WINDOW_HEIGHT', height)


	def destroy(self, window, event, battle_notebook, options_notebook):
		self.save_window_size(battle_notebook, options_notebook)
		gtk.main_quit()


	def battle(self, widget, event, background, battle_notebook, options_notebook, start_item):
		self.save_window_size(battle_notebook, options_notebook)
		start_item.show()
		background.hide()
		options_notebook.hide()
		battle_height = int(Config.get_option(self.ini, self.profile, 'BATTLE_WINDOW_HEIGHT', '700'))
		battle_width = int(Config.get_option(self.ini, self.profile, 'BATTLE_WINDOW_WIDTH', '1000'))
		self.window.resize(battle_width,battle_height)
		battle_notebook.show()
		self.player_name_update()


	def config(self, widget, event, background, battle_notebook, options_notebook, start_item):
		self.save_window_size(battle_notebook, options_notebook)
		start_item.hide()
		background.hide()
		battle_notebook.hide()
		options_height = int(Config.get_option(self.ini, self.profile, 'OPTIONS_WINDOW_HEIGHT', '320'))
		options_width = int(Config.get_option(self.ini, self.profile, 'OPTIONS_WINDOW_WIDTH', '360'))
		self.window.resize(options_width,options_height)
		options_notebook.show()



	def __init__(self,ini,profile):
		
		self.ini = ini
		self.profile = profile
		self.platform = sys.platform
		self.map_index = Config.get_option(self.ini, self.profile, 'MAP_INDEX', None)
		self.mod_index = Config.get_option(self.ini, self.profile, 'MOD_INDEX', None)

		# Add code to os.chdir  into datadir  IF USER IS USING ADVANCED SETUP
		# Get Datadirs from unitsync
		unitsync.Init(True,1)
		self.datadirs = []
		datadirs = unitsync.GetDataDirectories(False)
		for i in range(0,len(datadirs)):
			if os.path.isdir(datadirs[i]) == True:
				self.datadirs.append(datadirs[i])


		# Make Temp Config File
		self.conf = Config.get_option(self.ini, self.profile, 'SPRING_CONF', '')
		self.conf_temp = Config.get_option(self.ini, self.profile, 'SPRING_CONF_TEMP', '')
		if os.path.isfile(self.conf_temp) == False:
			Config.temp_config(self.conf, self.conf_temp, 'No')

		# Player Name
		self.my_player_name = Config.get_option(Config.get_option(self.ini, self.profile, 'SPRING_CONF_TEMP', ''), 'GAME', 'name', 'Player')

		# Map Index
		if os.path.isfile(self.map_index) == False:
			Index_Map.create_index(self)
			Index_Map.update_index(self)

		# Mod Index
		if os.path.isfile(self.mod_index) == False:
			Index_Mod.create_index(self)
			Index_Mod.update_index(self)


		# Main Window
		self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		self.window.set_title("Spring GUI")
		self.window.set_resizable(True)
		self.window.connect("delete-event", gtk.main_quit)
		self.window.add_events(gtk.gdk.BUTTON_PRESS_MASK)

		# BackGround
		background = gtk.Image()
		background.set_from_file(Config.get_option(self.ini,self.profile,'BACKGROUND', ''))
		background.show()

		# Vertical Box Part 1/2
		vbox = gtk.VBox(False, 0)
		vbox.show()
		self.window.add(vbox)

		# Menu Part 1/2
		menu_bar = gtk.MenuBar()
		menu_bar.show()

		# Battle & Options Notebook
		battle_notebook = gtk.Notebook()
	        battle_notebook.set_tab_pos(gtk.POS_TOP)

	        options_notebook = gtk.Notebook()
		options_notebook.set_tab_pos(gtk.POS_RIGHT)


		# Notebooks
		GUI_Battle.create(self,battle_notebook)
		GUI_Config.create(self,options_notebook)

		#Vertical Box Part 2/2
		vbox.pack_start(menu_bar, False, False, 2)
		vbox.pack_end(background, True, True, 2)
		vbox.pack_start(battle_notebook, True, True, 2)
		vbox.pack_start(options_notebook, True, True, 2)

		self.window.show()

		# Menu Part 2/2
			#Menu Items
		battle_item = gtk.MenuItem("Battle")
		lobby_item = gtk.MenuItem("Lobby")
		config_item = gtk.MenuItem("Options")
		start_item = gtk.MenuItem("Start")
		menu_bar.append(battle_item)
		menu_bar.append(lobby_item)
		menu_bar.append(config_item)
		menu_bar.append(start_item)

		battle_item.show()
		lobby_item.show()
		start_item.set_right_justified(1)
		config_item.show()

			#Menu-Connect
		battle_item.connect("button_press_event", self.battle, background, battle_notebook, options_notebook, start_item)
		config_item.connect("button_press_event", self.config, background, battle_notebook, options_notebook, start_item)
		start_item.connect("button_press_event", Battle.script_create, self)

		# Main Window destory event
		self.window.connect("delete-event", self.destroy, battle_notebook, options_notebook)


	def main(self):
		gtk.main()


class ProfileWindow:


	def destroy(self):
		width, height = self.window.get_size()
		Config.get_option(self.ini, self.profile, 'PROFILE_WINDOW_WIDTH', width)
		Config.get_option(self.ini, self.profile, 'PROFILE_WINDOW_HEIGHT', height)


		self.window.hide()
		main_window = MainWindow(self.ini, self.profile)


	def __init__(self):  #TODO add code to bypass automaticly loading profile if only 1 exists
		self.platform = sys.platform

		# Main Window
		self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		self.window.set_title("Spring GUI -> Profile")
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

		# Battle & Options Notebook
		notebook = gtk.Notebook()
	        notebook.set_tab_pos(gtk.POS_TOP)
		notebook.show()


		# Notebook Tabs
		GUI_Setup.create(self,notebook)


		#Vertical Box Part 2/2
		vbox.pack_start(notebook, True, True, 2)

		self.window.show()


	def main(self):
		gtk.main()


if __name__ == "__main__":
	# Main Loop
	# Add code to check for unitsync.so
		# By attempting to import (using older method i used for 3.09)
	profile_window = ProfileWindow()
	profile_window.main()
