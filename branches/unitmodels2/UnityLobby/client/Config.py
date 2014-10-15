#!/usr/bin/env python

#======================================================
 #            Config.py
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
import gtk
import os
import md5, base64


# Custom Modules
import GLOBAL

from Misc import create_page, label_create, combobox_setup, spinner_create


class config:

	def __init__(self, parent_window):
		self.platform = parent_window.platform

		self.conf_temp = parent_window.conf_temp
		self.conf_temp_file = parent_window.conf_temp_file

		self.lobby_ini = parent_window.lobby_ini
		self.lobby_ini_file = parent_window.lobby_ini_file

		self.temp_config = parent_window.temp_config

		self.gui_lobby = parent_window.gui_lobby



	def create(self, notebook):
		if self.platform == 'win32':
			spring_options = self.windows_load_spring_options()
		else:
			spring_options = self.unix_load_spring_options()
	
	
		# Frame - General
		general_frame = create_page(self, notebook, 'General', 100, 75)
			# Table
		general_table = gtk.Table(rows=2,columns=1, homogeneous=False)
		general_table.show()
		general_frame.add(general_table)
				# Name
		name_label = label_create('Name')
		self.player_name = gtk.Entry(max=0)
		self.player_name.set_text(spring_options['name'])
		self.player_name.set_width_chars(14)
		self.player_name.show()
		general_table.attach(name_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
		general_table.attach(self.player_name, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# Team Nano Spray
		team_nano_spray_label = label_create('Nano Spray')
		team_nano_spray_label.set_max_width_chars(10)
		team_nano_spray_label.set_line_wrap(True)
		self.team_nano_spray_combobox = combobox_setup(GLOBAL.Nano_Team_Colour, spring_options['team_nano_spray'], True)
		general_table.attach(team_nano_spray_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
		general_table.attach(self.team_nano_spray_combobox, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)


		# Frame - Graphics
		graphics_frame = create_page(self, notebook, 'Graphics', 100, 75)
			# Table
		graphics_table = gtk.Table(rows=1,columns=2, homogeneous=False)
		graphics_table.show()
		graphics_frame.add(graphics_table)
				# Resolution
		resolution_label = label_create("Resolution")
		self.resolution_combobox = gtk.combo_box_new_text()
		for i in range (0,len(GLOBAL.Resolution)):
			self.resolution_combobox.append_text(GLOBAL.Resolution[i])
		for i in range (0,len(GLOBAL.Resolution_X)):
			if GLOBAL.Resolution_X[i] == spring_options['resolution_x']:
				self.resolution_combobox.set_active(i)
				break
		self.resolution_combobox.show()
		graphics_table.attach(resolution_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
		graphics_table.attach(self.resolution_combobox, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# Fullscreen
		fullscreen_label = label_create("Fullscreen")
		self.fullscreen_combobox = combobox_setup(GLOBAL.Fullscreen, spring_options['fullscreen'], True)
		graphics_table.attach(fullscreen_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
		graphics_table.attach(self.fullscreen_combobox, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
				# Shadows
		shadows_label = label_create("Shadows")
		self.shadows_combobox = combobox_setup(GLOBAL.Shadows, spring_options['shadows'], True)
		graphics_table.attach(shadows_label, 0,1,2,3, gtk.FILL,gtk.FILL,10,10)
		graphics_table.attach(self.shadows_combobox, 1,2,2,3, gtk.FILL,gtk.FILL,10,10)
				# Fullscreen Anti-Aliasing
		fsaa_label = label_create("FSAA")
		self.fsaa_spinner = spinner_create(GLOBAL.FSAA_Level, spring_options['fsaa'], True)
		graphics_table.attach(fsaa_label, 0,1,3,4, gtk.FILL,gtk.FILL,10,10)
		graphics_table.attach(self.fsaa_spinner, 1,2,3,4, gtk.FILL,gtk.FILL,10,10)


		# Frame - Adv Graphics
		adv_graphics_frame = create_page(self, notebook, 'Adv Graphics', 100,75)
			# Table
		adv_graphics_table = gtk.Table(rows=2, columns=4, homogeneous=False)
		adv_graphics_table.show()
		adv_graphics_frame.add(adv_graphics_table)
				# 'Ground Decals'
		ground_decals_label = label_create("Ground Decals")
		self.ground_decals_spinner = spinner_create(GLOBAL.Ground_Decals, spring_options['ground_decals'], True)
		adv_graphics_table.attach(ground_decals_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
		adv_graphics_table.attach(self.ground_decals_spinner, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# Ground Detail
		ground_detail_label = label_create("Ground Detail")
		self.ground_detail_spinner = spinner_create(GLOBAL.Ground_Detail, spring_options['ground_detail'], True)
		adv_graphics_table.attach(ground_detail_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
		adv_graphics_table.attach(self.ground_detail_spinner, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
				# Grass Detail
		grass_detail_label = label_create("Grass Detail")
		self.grass_detail_spinner = spinner_create(GLOBAL.Grass_Detail, spring_options['grass_detail'], True)
		adv_graphics_table.attach(grass_detail_label, 0,1,2,3, gtk.FILL,gtk.FILL,10,10)
		adv_graphics_table.attach(self.grass_detail_spinner, 1,2,2,3, gtk.FILL,gtk.FILL,10,10)
				# Max Particles
		max_particles_label = label_create("Max Particles")
		self.max_particles_spinner = spinner_create(GLOBAL.Max_Particles, spring_options['max_particles'], True)
		adv_graphics_table.attach(max_particles_label, 0,1,3,4, gtk.FILL,gtk.FILL,10,10)
		adv_graphics_table.attach(self.max_particles_spinner, 1,2,3,4, gtk.FILL,gtk.FILL,10,10)
				# Unit Lod Distance
		unit_lod_distance_label = label_create("Unit Lod Distance")
		self.unit_lod_distance_spinner = spinner_create(GLOBAL.Unit_Lod_Dist, spring_options['unit_lod_dist'], True)
		adv_graphics_table.attach(unit_lod_distance_label, 0,1,4,5, gtk.FILL,gtk.FILL,10,10)
		adv_graphics_table.attach(self.unit_lod_distance_spinner, 1,2,4,5, gtk.FILL,gtk.FILL,10,10)

		# Frame - Adv Shaders
		adv_shaders_frame = create_page(self, notebook, 'Adv Shaders', 100,75)
			# Table
		adv_shaders_table = gtk.Table(rows=1, columns=3, homogeneous=False)
		adv_shaders_table.show()
		adv_shaders_frame.add(adv_shaders_table)
				# Advanced Sky
		adv_sky_label = label_create("Advanced Sky")
		self.adv_sky_combobox = combobox_setup(GLOBAL.Adv_Sky, spring_options['adv_sky'], True)
		adv_shaders_table.attach(adv_sky_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
		adv_shaders_table.attach(self.adv_sky_combobox, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# Dynamic Sky
		dynamic_sky_label = label_create("Dynamic Sky")
		self.dynamic_sky_combobox = combobox_setup(GLOBAL.Dynamic_Sky, spring_options['dynamic_sky'], True)
		adv_shaders_table.attach(dynamic_sky_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
		adv_shaders_table.attach(self.dynamic_sky_combobox, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
				# Advanced Unit Shading
		adv_unit_shading_label = label_create("Adv Unit Shading")
		self.adv_unit_shading_combobox = combobox_setup(GLOBAL.Adv_Unit_Shading, spring_options['adv_unit_shading'], True)
		adv_shaders_table.attach(adv_unit_shading_label, 0,1,2,3, gtk.FILL,gtk.FILL,10,10)
		adv_shaders_table.attach(self.adv_unit_shading_combobox, 1,2,2,3, gtk.FILL,gtk.FILL,10,10)
				# Reflective Water
		reflective_water_label = label_create("Reflective Water")
		self.reflective_water_combobox = combobox_setup(GLOBAL.Reflective_Water, spring_options['reflective_water'], True)
		adv_shaders_table.attach(reflective_water_label, 0,1,3,4, gtk.FILL,gtk.FILL,10,10)
		adv_shaders_table.attach(self.reflective_water_combobox, 1,2,3,4, gtk.FILL,gtk.FILL,10,10)


		# Sound
		sound_frame = create_page(self, notebook, 'Sound', 100,75)
			# Table - Debug
		sound_table = gtk.Table(rows=1, columns=4, homogeneous=False)
		sound_table.show()
		sound_frame.add(sound_table)
				# Sound Volume
		sound_volume_label = label_create("Sound Volume")
		self.sound_volume_spinner = spinner_create(GLOBAL.Sound_Volume, spring_options['sound_volume'], True)
		sound_table.attach(sound_volume_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
		sound_table.attach(self.sound_volume_spinner, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# Max Sounds
		max_sounds_label = label_create("Max Sounds")
		self.max_sounds_spinner = spinner_create(GLOBAL.Max_Sounds, spring_options['max_sounds'], True)
		sound_table.attach(max_sounds_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
		sound_table.attach(self.max_sounds_spinner, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)


		# Debug
		debug_frame = create_page(self, notebook, 'Debug', 100,75)
			# Table - Debug
		debug_table = gtk.Table(rows=1, columns=4, homogeneous=False)
		debug_table.show()
		debug_frame.add(debug_table)
				# VerboseLevel
		verbose_level_label = label_create("Verbose Level")
		self.verbose_level_spinner = spinner_create(GLOBAL.Verbose_Level, spring_options['verbose_level'], True)
		debug_table.attach(verbose_level_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
		debug_table.attach(self.verbose_level_spinner, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# CatchAIExceptions
		catch_ai_exceptions_label = label_create("Catch AI Exceptions")
		self.catch_ai_exceptions_combobox = combobox_setup(GLOBAL.Catch_AI_Exceptions, spring_options['catch_ai_exceptions'], True)
		debug_table.attach(catch_ai_exceptions_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
		debug_table.attach(self.catch_ai_exceptions_combobox, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
	

		# Lobby
		lobby_frame = create_page(self, notebook, 'Lobby', 100,75)
			# Lobby - Notebook
		lobby_notebook = gtk.Notebook()
		lobby_notebook.set_tab_pos(gtk.POS_TOP)
		lobby_notebook.show()
		lobby_frame.add(lobby_notebook)
			# Lobby - Server List
		lobby_server_list_frame = create_page(self, lobby_notebook, 'Server List', 100,75)


		# Select Profile Window (scrolled)
		lobby_server_list_window = gtk.ScrolledWindow()
		lobby_server_list_window.set_border_width(10)
		lobby_server_list_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
		lobby_server_list_window.show()
		lobby_server_list_frame.add(lobby_server_list_window)
			# Select Profile ListStore
			  # Profile Name       = String
	 	self.lobby_server_list_liststore = gtk.ListStore(str)
		self.lobby_server_list_treeview = gtk.TreeView(self.lobby_server_list_liststore)
		self.lobby_server_list_treeview.set_headers_visible(False)
		lobby_server_list_column_1 = gtk.TreeViewColumn('Server')
		self.lobby_server_list_treeview.append_column(lobby_server_list_column_1)
		lobby_server_list_window.add(self.lobby_server_list_treeview)
		self.lobby_server_list_treeview.show()

		server_list = self.lobby_ini.sections()
		for i in range(0,len(server_list)):
			self.lobby_server_list_liststore.append([server_list[i]])


		# Add Mouse Click event to select_profile_treeview
		self.lobby_server_list_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
		self.lobby_server_list_treeview.connect('event', self.server_selection)

        	# create a CellRenderers to render the data
	        cell1  = gtk.CellRendererText()

        	# add the cells to the columns
		lobby_server_list_column_1.pack_start(cell1, False)

        	# set the cell attributes to the appropriate liststore column
		lobby_server_list_column_1.set_attributes(cell1, text=0)


			# Lobby - Add Server 
		lobby_add_server_frame = create_page(self, lobby_notebook, 'Add Server', 100,75)


		# Table
		lobby_add_server_table = gtk.Table(rows=1,columns=1, homogeneous=False)
		lobby_add_server_table.show()
		lobby_add_server_frame.add(lobby_add_server_table)

			# Server Address
		server_address_label = label_create("Server")
		self.server_address_entry = gtk.Entry(max=0)  # taspringmaster.clan-sy.com
		self.server_address_entry.set_text(GLOBAL.Lobby_Server)
		self.server_address_entry.show()
		lobby_add_server_table.attach(server_address_label, 0,1,0,1, gtk.FILL,gtk.FILL,5,5)
		lobby_add_server_table.attach(self.server_address_entry, 1,2,0,1, gtk.FILL,gtk.FILL,5,5)

			#Server Port
		server_port_label = label_create("Port")
		server_port_adjustment = gtk.Adjustment(GLOBAL.Lobby_Server_Port, lower=0, upper=65535, step_incr=100, page_incr=1000, page_size=0)
		self.server_port_spinner = gtk.SpinButton(server_port_adjustment, 0, 0)
		self.server_port_spinner.show()
		lobby_add_server_table.attach(server_port_label, 0,1,1,2, gtk.FILL,gtk.FILL,5,5)
		lobby_add_server_table.attach(self.server_port_spinner, 1,2,1,2, gtk.FILL,gtk.FILL,5,5)

			# User Name
		username_label = label_create("User Name")
		self.username_entry = gtk.Entry(max=0)
		self.username_entry.show()
		lobby_add_server_table.attach(username_label, 0,1,2,3, gtk.FILL,gtk.FILL,5,5)
		lobby_add_server_table.attach(self.username_entry, 1,2,2,3, gtk.FILL,gtk.FILL,5,5)

			# Password
		password_label = label_create("Password")
		self.password_entry = gtk.Entry(max=0)
		self.password_entry.set_visibility(False)
		self.password_entry.show()
		lobby_add_server_table.attach(password_label, 0,1,3,4, gtk.FILL,gtk.FILL,5,5)
		lobby_add_server_table.attach(self.password_entry, 1,2,3,4, gtk.FILL,gtk.FILL,5,5)

			# Button -> Add
		lobby_add_button = gtk.Button(label=None, stock=gtk.STOCK_ADD)
		lobby_add_button.connect("clicked", self.add_lobby_server)
		lobby_add_button.show()
		lobby_add_server_table.attach(lobby_add_button, 0,1,4,5, gtk.FILL,gtk.FILL,5,5)

			# Button -> Registry
		lobby_registry_button = gtk.Button(label="Register Account", stock=None)
		lobby_registry_button.connect("clicked", self.register_account)
		lobby_registry_button.show()
		lobby_add_server_table.attach(lobby_registry_button, 1,2,4,5, gtk.FILL,gtk.FILL,5,5)


	def server_selection(self, widget, event):
		treeselection = self.lobby_server_list_treeview.get_selection()
		(model, iter) = treeselection.get_selected()
		if iter != None:
			if event.type == gtk.gdk.BUTTON_PRESS:
			        if event.button == 3:
					# Main Menu
					menu = gtk.Menu()
					menu.show()
					default_item = gtk.MenuItem("Set as Default Server")
					remove_item = gtk.MenuItem("Remove from Server List")
					menu.append(default_item)
					menu.append(remove_item)
					default_item.show()
					remove_item.show()
					default_item.connect("button_press_event", self.default_lobby_server, iter)
					remove_item.connect("button_press_event", self.delete_lobby_server, iter)
					menu.popup(None, None, None, event.button, event.time)


	def register_account(self, button):
		server_address = self.server_address_entry.get_text()
	        u = md5.new(self.password_entry.get_text()).digest()
	        encoded_password = base64.encodestring(u)
	
		username = self.username_entry.get_text()
		port = int(self.server_port_spinner.get_value())

		self.add_lobby_server(None)
		self.gui_lobby.register_account(server_address, port, username, encoded_password)



	def add_lobby_server(self, widget):
		server_address = self.server_address_entry.get_text()
	        u = md5.new(self.password_entry.get_text()).digest()
	        encoded_password = base64.encodestring(u)

		if self.lobby_ini.has_section(server_address) == False:
			self.lobby_ini.add_section(server_address)
			iter = self.lobby_server_list_liststore.append([server_address])

			self.lobby_ini.set(server_address, 'Port', int(self.server_port_spinner.get_value()))
			self.lobby_ini.set(server_address, 'UserName', self.username_entry.get_text())
			self.lobby_ini.set(server_address, 'UserPassword', encoded_password)
			self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
			self.lobby_ini.read(self.lobby_ini_file)
			if self.lobby_ini.sections()[0] == server_address:
				self.default_lobby_server(None, None, iter)
		else:
			self.lobby_ini.set(server_address, 'Port', int(self.server_port_spinner.get_value()))
			self.lobby_ini.set(server_address, 'UserName', self.username_entry.get_text())
			self.lobby_ini.set(server_address, 'UserPassword', encoded_password)
			self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
			self.lobby_ini.read(self.lobby_ini_file)


	def delete_lobby_server(self, widget, event, iter):
		server_name = self.lobby_server_list_liststore.get_value(iter,0)
		self.lobby_ini.remove_section(server_name)
		self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
		self.lobby_ini.read(self.lobby_ini_file)
		self.lobby_server_list_liststore.remove(iter)


	def default_lobby_server(self, event, widget, iter):
		default_server = self.lobby_server_list_liststore.get_value(iter,0)
		server_list = self.lobby_ini.sections()
		for i in range(0,len(server_list)):
			if server_list[i] != default_server:
				self.lobby_ini.set(server_list[i], 'Default', 'No')
			else:
				self.lobby_ini.set(server_list[i], 'Default', 'Yes')
		self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
		self.lobby_ini.read(self.lobby_ini_file)


	def unix_load_spring_options(self):

		if self.conf_temp.has_option('GAME', 'name') == True:
			options = ({'name':self.conf_temp.get('GAME', 'name')})
		else:
			options = ({'name':'Player'})

		if self.conf_temp.has_option('GAME', 'XResolution') == True:
			options.update({'resolution_x':self.conf_temp.getint('GAME', 'XResolution')})
		else:
			options.update({'resolution_x':GLOBAL.Resolution_X[GLOBAL.Resolution_Default]})

		if self.conf_temp.has_option('GAME', 'Fullscreen') == True:
			options.update({'fullscreen':self.conf_temp.get('GAME', 'Fullscreen')})
		else:
			options.update({'fullscreen':GLOBAL.Fullscreen_Default})

		if self.conf_temp.has_option('GAME', 'Shadows') == True:
			options.update({'shadows':self.conf_temp.get('GAME', 'Shadows')})
		else:
			options.update({'shadows':GLOBAL.Shadows_Default})

		if self.conf_temp.has_option('GAME', 'FSAA') == True:
			options.update({'fsaa':self.conf_temp.get('GAME', 'FSAA')})
		else:
			options.update({'fsaa':GLOBAL.FSAA_Default})

		if options['fsaa'] != 0:
			if self.conf_temp.has_option('GAME', 'FSAALevel') == True:
				options.update({'fsaa':self.conf_temp.get('GAME', 'FSAA')})
			else:
				options.update({'fsaa':GLOBAL.FSAA_Level_Default})

		if self.conf_temp.has_option('GAME', 'GroundDecals') == True:
			options.update({'ground_decals':self.conf_temp.get('GAME', 'GroundDecals')})
		else:
			options.update({'ground_decals':GLOBAL.Ground_Decals_Default})

		if self.conf_temp.has_option('GAME', 'GroundDetail') == True:
			options.update({'ground_detail':self.conf_temp.get('GAME', 'GroundDetail')})
		else:
			options.update({'ground_detail':GLOBAL.Ground_Detail_Default})

		if self.conf_temp.has_option('GAME', 'GrassDetail') == True:
			options.update({'grass_detail':self.conf_temp.get('GAME', 'GrassDetail')})
		else:
			options.update({'grass_detail':GLOBAL.Grass_Detail_Default})

		if self.conf_temp.has_option('GAME', 'MaxParticles') == True:
			options.update({'max_particles':self.conf_temp.get('GAME', 'MaxParticles')})
		else:
			options.update({'max_particles':GLOBAL.Max_Particles_Default})

		if self.conf_temp.has_option('GAME', 'UnitIconDist') == True:
			options.update({'unit_lod_dist':self.conf_temp.get('GAME', 'UnitIconDist')})
		else:
			options.update({'unit_lod_dist':GLOBAL.Unit_Lod_Dist_Default})

		if self.conf_temp.has_option('GAME', 'AdvSky') == True:
			options.update({'adv_sky':self.conf_temp.get('GAME', 'AdvSky')})
		else:
			options.update({'adv_sky':GLOBAL.Adv_Sky_Default})

		if self.conf_temp.has_option('GAME', 'DynamicSky') == True:
			options.update({'dynamic_sky':self.conf_temp.get('GAME', 'DynamicSky')})
		else:
			options.update({'dynamic_sky':GLOBAL.Dynamic_Sky_Default})

		if self.conf_temp.has_option('GAME', 'AdvUnitShading') == True:
			options.update({'adv_unit_shading':self.conf_temp.get('GAME', 'AdvUnitShading')})
		else:
			options.update({'adv_unit_shading':GLOBAL.Adv_Unit_Shading_Default})

		if self.conf_temp.has_option('GAME', 'SoundVolume') == True:
			options.update({'sound_volume':self.conf_temp.get('GAME', 'SoundVolume')})
		else:
			options.update({'sound_volume':GLOBAL.Sound_Volume_Default})

		if self.conf_temp.has_option('GAME', 'MaxSounds') == True:
			options.update({'max_sounds':self.conf_temp.get('GAME', 'MaxSounds')})
		else:
			options.update({'max_sounds':GLOBAL.Max_Sounds_Default})

		if self.conf_temp.has_option('GAME', 'VerboseLevel') == True:
			options.update({'verbose_level':self.conf_temp.get('GAME', 'VerboseLevel')})
		else:
			options.update({'verbose_level':GLOBAL.Verbose_Level_Default})

		if self.conf_temp.has_option('GAME', 'CatchAIExceptions') == True:
			options.update({'catch_ai_exceptions':self.conf_temp.get('GAME', 'CatchAIExceptions')})
		else:
			options.update({'catch_ai_exceptions':GLOBAL.Catch_AI_Exceptions_Default})

		if self.conf_temp.has_option('GAME', 'TeamNanoSpray') == True:
			options.update({'team_nano_spray':self.conf_temp.get('GAME', 'TeamNanoSpray')})
		else:
			options.update({'team_nano_spray':GLOBAL.Nano_Team_Colour_Default})

		if self.conf_temp.has_option('GAME', 'ReflectiveWater') == True:
			temp = self.conf_temp.get('GAME', 'ReflectiveWater')
			options.update({'reflective_water':GLOBAL.Reflective_Water_Values.index(int(temp))})
		else:
			options.update({'reflective_water':GLOBAL.Reflective_Water_Default})

		return options


	def unix_save_spring_options(self):
		self.conf_temp.set('GAME', 'name', self.player_name.get_text())
		self.conf_temp.set('GAME', 'SoundVolume', self.sound_volume_spinner.get_value_as_int())
		self.conf_temp.set('GAME', 'XResolution', GLOBAL.Resolution_X[self.resolution_combobox.get_active()])
		self.conf_temp.set('GAME', 'YResolution', GLOBAL.Resolution_Y[self.resolution_combobox.get_active()])
		self.conf_temp.set('GAME', 'Fullscreen', self.fullscreen_combobox.get_active())

		value = self.fsaa_spinner.get_value_as_int()
		if value > 1:
			self.conf_temp.set('GAME', 'FSAALevel', value)
			self.conf_temp.set('GAME', 'FSAA', '1')
		else:
			self.conf_temp.set('GAME', 'FSAA', '0')
	

		self.conf_temp.set('GAME', 'Shadows', self.shadows_combobox.get_active())
		self.conf_temp.set('GAME', 'GrassDetail', self.grass_detail_spinner.get_value_as_int())
		self.conf_temp.set('GAME', 'GroundDetail', self.ground_detail_spinner.get_value_as_int())
		self.conf_temp.set('GAME', 'GroundDecals', self.ground_decals_spinner.get_value_as_int())
		self.conf_temp.set('GAME', 'MaxParticles', self.max_particles_spinner.get_value_as_int())
		self.conf_temp.set('GAME', 'AdvSky', self.adv_sky_combobox.get_active())
		self.conf_temp.set('GAME', 'DynamicSky', self.dynamic_sky_combobox.get_active())
		self.conf_temp.set('GAME', 'AdvUnitShading', self.adv_unit_shading_combobox.get_active())
		self.conf_temp.set('GAME', 'MaxSounds', self.max_sounds_spinner.get_value_as_int())
		self.conf_temp.set('GAME', 'UnitIconDist', self.unit_lod_distance_spinner.get_value_as_int())
		self.conf_temp.set('GAME', 'VerboseLevel', self.verbose_level_spinner.get_value_as_int())
		self.conf_temp.set('GAME', 'CatchAIExceptions', self.catch_ai_exceptions_combobox.get_active())
		self.conf_temp.set('GAME', 'TeamNanoSpray', self.team_nano_spray_combobox.get_active())
		self.conf_temp.set('GAME', 'ReflectiveWater', GLOBAL.Reflective_Water_Values[self.reflective_water_combobox.get_active()])

		self.conf_temp.write(open(self.conf_temp_file, "w+"))
		self.conf_temp.read(self.conf_temp_file)
	

		self.temp_config('Yes')

	def windows_load_spring_options(self):
		#TODO
		pass

	def windows_save_spring_options(self):
		#TODO
		pass

	def get_player_name(self):
		return self.player_name.get_text()
