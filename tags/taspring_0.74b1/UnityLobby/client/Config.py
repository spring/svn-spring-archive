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
import ConfigParser


# Custom Modules
import GLOBAL

from Misc import create_page, label_create, combobox_setup, spinner_create


class config:

	def __init__(self, status_icon):
		self.spring_logo_pixbuf = status_icon.spring_logo_pixbuf

		self.platform = status_icon.platform
		self.ini = status_icon.ini

		# Make Temp Config File
		self.conf_file = self.ini.get(status_icon.profile, 'SPRING_CONF')
		self.conf_temp_file = self.ini.get(status_icon.profile, 'SPRING_CONF_TEMP')
		self.temp_config(False)

		# Temp Config file
		self.conf_temp = ConfigParser.ConfigParser()
		self.conf_temp.optionxform = lambda x: x
		self.conf_temp.read(self.conf_temp_file)



	def create(self):
		# Load Option Values
		if self.platform == 'win32':
			spring_options = self.windows_load_spring_options()
		else:
			spring_options = self.unix_load_spring_options()

		# Window
		self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		self.window.set_icon_list(self.spring_logo_pixbuf)
		self.window.set_title("Spring Options")
		self.window.connect("delete-event", self.destroy)

			# Table
		table = gtk.Table(rows=2, columns=2, homogeneous=False)
		table.show()
		self.window.add(table)

				# ToolBar
		self.save_button = gtk.ToolButton(gtk.STOCK_SAVE)
#		self.save_button.connect("clicked", self.player_update_status, self.my_player_name)
		self.save_button.show()

		toolbar = gtk.Toolbar()	
		toolbar.insert(self.save_button, 0)
		toolbar.set_style(gtk.TOOLBAR_ICONS)
		toolbar.show()
		table.attach(toolbar,0,1,0,1, gtk.FILL, gtk.FILL,0,0)

			# Notebook
	        notebook = gtk.Notebook()
		notebook.set_tab_pos(gtk.POS_LEFT)
		notebook.show()
		table.attach(notebook,0,1,1,2)

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
		general_table.attach(name_label, 0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		general_table.attach(self.player_name, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Team Nano Spray
		team_nano_spray_label = label_create('Nano Spray')
		team_nano_spray_label.set_max_width_chars(10)
		team_nano_spray_label.set_line_wrap(True)
		self.team_nano_spray_combobox = combobox_setup(GLOBAL.Nano_Team_Colour, spring_options['team_nano_spray'], True)
		general_table.attach(team_nano_spray_label, 0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		general_table.attach(self.team_nano_spray_combobox, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)


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
		graphics_table.attach(resolution_label, 0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		graphics_table.attach(self.resolution_combobox, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Fullscreen
		fullscreen_label = label_create("Fullscreen")
		self.fullscreen_combobox = combobox_setup(GLOBAL.Fullscreen, spring_options['fullscreen'], True)
		graphics_table.attach(fullscreen_label, 0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		graphics_table.attach(self.fullscreen_combobox, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Shadows
		shadows_label = label_create("Shadows")
		self.shadows_combobox = combobox_setup(GLOBAL.Shadows, spring_options['shadows'], True)
		graphics_table.attach(shadows_label, 0,1,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		graphics_table.attach(self.shadows_combobox, 1,2,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Fullscreen Anti-Aliasing
		fsaa_label = label_create("FSAA")
		self.fsaa_spinner = spinner_create(GLOBAL.FSAA_Level, spring_options['fsaa'], True)
		graphics_table.attach(fsaa_label, 0,1,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		graphics_table.attach(self.fsaa_spinner, 1,2,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)


			# Frame - Adv Graphics
		adv_graphics_frame = create_page(self, notebook, 'Adv Graphics', 100,75)
				# Table
		adv_graphics_table = gtk.Table(rows=2, columns=4, homogeneous=False)
		adv_graphics_table.show()
		adv_graphics_frame.add(adv_graphics_table)
					# 'Ground Decals'
		ground_decals_label = label_create("Ground Decals")
		self.ground_decals_spinner = spinner_create(GLOBAL.Ground_Decals, spring_options['ground_decals'], True)
		adv_graphics_table.attach(ground_decals_label, 0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_graphics_table.attach(self.ground_decals_spinner, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Ground Detail
		ground_detail_label = label_create("Ground Detail")
		self.ground_detail_spinner = spinner_create(GLOBAL.Ground_Detail, spring_options['ground_detail'], True)
		adv_graphics_table.attach(ground_detail_label, 0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_graphics_table.attach(self.ground_detail_spinner, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Grass Detail
		grass_detail_label = label_create("Grass Detail")
		self.grass_detail_spinner = spinner_create(GLOBAL.Grass_Detail, spring_options['grass_detail'], True)
		adv_graphics_table.attach(grass_detail_label, 0,1,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_graphics_table.attach(self.grass_detail_spinner, 1,2,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Max Particles
		max_particles_label = label_create("Max Particles")
		self.max_particles_spinner = spinner_create(GLOBAL.Max_Particles, spring_options['max_particles'], True)
		adv_graphics_table.attach(max_particles_label, 0,1,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_graphics_table.attach(self.max_particles_spinner, 1,2,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Unit Lod Distance
		unit_lod_distance_label = label_create("Unit Lod Distance")
		self.unit_lod_distance_spinner = spinner_create(GLOBAL.Unit_Lod_Dist, spring_options['unit_lod_dist'], True)
		adv_graphics_table.attach(unit_lod_distance_label, 0,1,4,5, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_graphics_table.attach(self.unit_lod_distance_spinner, 1,2,4,5, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)

			# Frame - Adv Shaders
		adv_shaders_frame = create_page(self, notebook, 'Adv Shaders', 100,75)
				# Table
		adv_shaders_table = gtk.Table(rows=1, columns=3, homogeneous=False)
		adv_shaders_table.show()
		adv_shaders_frame.add(adv_shaders_table)
					# Advanced Sky
		adv_sky_label = label_create("Advanced Sky")
		self.adv_sky_combobox = combobox_setup(GLOBAL.Adv_Sky, spring_options['adv_sky'], True)
		adv_shaders_table.attach(adv_sky_label, 0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_shaders_table.attach(self.adv_sky_combobox, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Dynamic Sky
		dynamic_sky_label = label_create("Dynamic Sky")
		self.dynamic_sky_combobox = combobox_setup(GLOBAL.Dynamic_Sky, spring_options['dynamic_sky'], True)
		adv_shaders_table.attach(dynamic_sky_label, 0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_shaders_table.attach(self.dynamic_sky_combobox, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Advanced Unit Shading
		adv_unit_shading_label = label_create("Adv Unit Shading")
		self.adv_unit_shading_combobox = combobox_setup(GLOBAL.Adv_Unit_Shading, spring_options['adv_unit_shading'], True)
		adv_shaders_table.attach(adv_unit_shading_label, 0,1,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_shaders_table.attach(self.adv_unit_shading_combobox, 1,2,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Reflective Water
		reflective_water_label = label_create("Reflective Water")
		self.reflective_water_combobox = combobox_setup(GLOBAL.Reflective_Water, spring_options['reflective_water'], True)
		adv_shaders_table.attach(reflective_water_label, 0,1,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		adv_shaders_table.attach(self.reflective_water_combobox, 1,2,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)


			# Sound
		sound_frame = create_page(self, notebook, 'Sound', 100,75)
				# Table
		sound_table = gtk.Table(rows=1, columns=4, homogeneous=False)
		sound_table.show()
		sound_frame.add(sound_table)
					# Sound Volume
		sound_volume_label = label_create("Sound Volume")
		self.sound_volume_spinner = spinner_create(GLOBAL.Sound_Volume, spring_options['sound_volume'], True)
		sound_table.attach(sound_volume_label, 0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		sound_table.attach(self.sound_volume_spinner, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# Max Sounds
		max_sounds_label = label_create("Max Sounds")
		self.max_sounds_spinner = spinner_create(GLOBAL.Max_Sounds, spring_options['max_sounds'], True)
		sound_table.attach(max_sounds_label, 0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		sound_table.attach(self.max_sounds_spinner, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)


			# Debug
		debug_frame = create_page(self, notebook, 'Debug', 100,75)
				# Table
		debug_table = gtk.Table(rows=1, columns=4, homogeneous=False)
		debug_table.show()
		debug_frame.add(debug_table)
					# VerboseLevel
		verbose_level_label = label_create("Verbose Level")
		self.verbose_level_spinner = spinner_create(GLOBAL.Verbose_Level, spring_options['verbose_level'], True)
		debug_table.attach(verbose_level_label, 0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		debug_table.attach(self.verbose_level_spinner, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
					# CatchAIExceptions
		catch_ai_exceptions_label = label_create("Catch AI Exceptions")
		self.catch_ai_exceptions_combobox = combobox_setup(GLOBAL.Catch_AI_Exceptions, spring_options['catch_ai_exceptions'], True)
		debug_table.attach(catch_ai_exceptions_label, 0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
		debug_table.attach(self.catch_ai_exceptions_combobox, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)


	def temp_config(self, save):
	# Save variable is to set it to remove | add hack
	# If Save is set to No  then it adds    the hack
	# If Save is set to Yes then it removes the hack
	#		Hack is adding [MAIN] to temp file  so can use ConfigParser on the temp file
	# If Save is anything else  it just copies the src(file) -> dest(file)
		import re
		import fileinput

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

	def show(self):
		self.window.show()

	def hide(self):
		self.window.hide()

	def destroy(self, window, event):
		self.hide()
		return True
