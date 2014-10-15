#!/usr/bin/env python

#======================================================
 #            GUI_Config.py
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
import gtk
import os

# Custom Modules
import GLOBAL

import Config

from GUI_ import combobox_setup, spinner_create, label_create, frame_create

def create_page(self, notebook, text, x, y):
	frame = gtk.Frame(text)
	frame.set_border_width(10)
	frame.set_size_request(x,y)
	frame.show()

	label = gtk.Label(text)
	notebook.append_page(frame, label)

	return frame


def create(self, notebook):
		# Frame - General
	general_frame = create_page(self, notebook, 'General', 100, 75)
			# Table
	general_table = gtk.Table(rows=2,columns=1, homogeneous=False)
	general_table.show()
	general_frame.add(general_table)
				# Name
	name_label = label_create('Name')
	self.player_name = gtk.Entry(max=0)
	self.player_name.set_text(Config.get_option(self.conf_temp, 'GAME', 'name', 'Player'))
	self.player_name.show()
	general_table.attach(name_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
	general_table.attach(self.player_name, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)

		# Frame - Graphics
	graphics_frame = create_page(self, notebook, 'Graphics', 100, 75)
			# Table
	graphics_table = gtk.Table(rows=1,columns=2, homogeneous=False)
	graphics_table.show()
	graphics_frame.add(graphics_table)
				# Resolution
	resolution_label = label_create("Resolution")
	self.resolution_combobox = combobox_setup(self.conf_temp, 'GAME', 'XResolution', GLOBAL.Resolution_Default, GLOBAL.Resolution)
	graphics_table.attach(resolution_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
	graphics_table.attach(self.resolution_combobox, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# Fullscreen
	fullscreen_label = label_create("Fullscreen")
	self.fullscreen_combobox = combobox_setup(self.conf_temp, 'GAME', 'Fullscreen', GLOBAL.Fullscreen_Default, GLOBAL.Fullscreen)
	graphics_table.attach(fullscreen_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
	graphics_table.attach(self.fullscreen_combobox, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
				# Shadows
	shadows_label = label_create("Shadows")
	self.shadows_combobox = combobox_setup(self.conf_temp, 'GAME', 'Shadows', GLOBAL.Shadows_Default, GLOBAL.Shadows)
	graphics_table.attach(shadows_label, 0,1,2,3, gtk.FILL,gtk.FILL,10,10)
	graphics_table.attach(self.shadows_combobox, 1,2,2,3, gtk.FILL,gtk.FILL,10,10)
				# Fullscreen Anti-Aliasing
	fsaa_label = label_create("FSAA")
	fsaa_value = float(Config.get_option(self.conf_temp, 'GAME', 'FSAA',GLOBAL.FSAA_Default))
	if fsaa_value != 0:
		fsaa_value = float(Config.get_option(self.conf_temp, 'GAME', 'FSAALevel',GLOBAL.FSAALevel_Default))
	fsaa_adjustment = gtk.Adjustment(fsaa_value, GLOBAL.FSAALevel[0], GLOBAL.FSAALevel[1], GLOBAL.FSAALevel[2], GLOBAL.FSAALevel[3], page_size=0)
	self.fsaa_spinner = gtk.SpinButton(fsaa_adjustment, 0, 0)
	self.fsaa_spinner.show()
	graphics_table.attach(fsaa_label, 0,1,3,4, gtk.FILL,gtk.FILL,10,10)
	graphics_table.attach(self.fsaa_spinner, 1,2,3,4, gtk.FILL,gtk.FILL,10,10)


		# Frame - Adv Graphics
	adv_graphics_frame = create_page(self, notebook, 'Adv Graphics', 100,75)
			# Table
	adv_graphics_table = gtk.Table(rows=2, columns=4, homogeneous=False)
	adv_graphics_table.show()
	adv_graphics_frame.add(adv_graphics_table)
				# 'GroundDecals'
	ground_decals_label = label_create("Ground Decals")
	self.ground_decals_spinner = spinner_create(self.conf_temp, 'GroundDecals', GLOBAL.Ground_Decals_Default, GLOBAL.Ground_Decals)
	adv_graphics_table.attach(ground_decals_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
	adv_graphics_table.attach(self.ground_decals_spinner, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# GroundDetail
	ground_detail_label = label_create("Ground Detail")
	self.ground_detail_spinner = spinner_create(self.conf_temp, 'GroundDetail', GLOBAL.Ground_Detail_Default, GLOBAL.Ground_Detail)
	adv_graphics_table.attach(ground_detail_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
	adv_graphics_table.attach(self.ground_detail_spinner, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)

				# GrassDetail
	grass_detail_label = label_create("Grass Detail")
	self.grass_detail_spinner = spinner_create(self.conf_temp, 'GrassDetail', GLOBAL.Grass_Detail_Default, GLOBAL.Grass_Detail)
	adv_graphics_table.attach(grass_detail_label, 0,1,2,3, gtk.FILL,gtk.FILL,10,10)
	adv_graphics_table.attach(self.grass_detail_spinner, 1,2,2,3, gtk.FILL,gtk.FILL,10,10)
				# MaxParticles
	max_particles_label = label_create("Max Particles")
	self.max_particles_spinner = spinner_create(self.conf_temp, 'MaxParticles', GLOBAL.Max_Particles_Default, GLOBAL.Max_Particles)
	adv_graphics_table.attach(max_particles_label, 0,1,3,4, gtk.FILL,gtk.FILL,10,10)
	adv_graphics_table.attach(self.max_particles_spinner, 1,2,3,4, gtk.FILL,gtk.FILL,10,10)
				# UnitLodDist
	unit_lod_distance_label = label_create("Unit Lod Distance")
	self.unit_lod_distance_spinner = spinner_create(self.conf_temp, 'UnitIconDist', GLOBAL.Unit_Lod_Dist_Default, GLOBAL.Unit_Lod_Dist)
	adv_graphics_table.attach(unit_lod_distance_label, 0,1,4,5, gtk.FILL,gtk.FILL,10,10)
	adv_graphics_table.attach(self.unit_lod_distance_spinner, 1,2,4,5, gtk.FILL,gtk.FILL,10,10)


		# Frame - Adv Shaders
	adv_shaders_frame = create_page(self, notebook, 'Adv Shaders', 100,75)
			# Table
	adv_shaders_table = gtk.Table(rows=1, columns=3, homogeneous=False)
	adv_shaders_table.show()
	adv_shaders_frame.add(adv_shaders_table)
				# AdvSky
	adv_sky_label = label_create("Advanced Sky")
	self.adv_sky_combobox = combobox_setup(self.conf_temp, 'GAME', 'AdvSky', GLOBAL.Adv_Sky_Default, GLOBAL.Adv_Sky)
	adv_shaders_table.attach(adv_sky_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
	adv_shaders_table.attach(self.adv_sky_combobox, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# DynamicSky
	dynamic_sky_label = label_create("Dynamic Sky")
	self.dynamic_sky_combobox = combobox_setup(self.conf_temp, 'GAME', 'DynamicSky', GLOBAL.Dynamic_Sky_Default, GLOBAL.Dynamic_Sky)
	adv_shaders_table.attach(dynamic_sky_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
	adv_shaders_table.attach(self.dynamic_sky_combobox, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
				# AdvUnitShading
	adv_unit_shading_label = label_create("Adv Unit Shading")
	self.adv_unit_shading_combobox = combobox_setup(self.conf_temp, 'GAME', 'AdvUnitShading', GLOBAL.Adv_Unit_Shading_Default, GLOBAL.Adv_Unit_Shading)
	adv_shaders_table.attach(adv_unit_shading_label, 0,1,2,3, gtk.FILL,gtk.FILL,10,10)
	adv_shaders_table.attach(self.adv_unit_shading_combobox, 1,2,2,3, gtk.FILL,gtk.FILL,10,10)

				# ReflectiveWater
	reflective_water_label = label_create("Reflective Water")
	self.reflective_water_combobox = combobox_setup(self.conf_temp, 'GAME', 'ReflectiveWater', GLOBAL.Reflective_Water_Default, GLOBAL.Reflective_Water)
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
	self.sound_volume_spinner = spinner_create(self.conf_temp, 'SoundVolume', GLOBAL.Sound_Volume_Default, GLOBAL.Sound_Volume)
	sound_table.attach(sound_volume_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
	sound_table.attach(self.sound_volume_spinner, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# MaxSounds
	max_sounds_label = label_create("Max Sounds")
	self.max_sounds_spinner = spinner_create(self.conf_temp, 'MaxSounds', GLOBAL.Max_Sounds_Default, GLOBAL.Max_Sounds)
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
	self.verbose_level_spinner = spinner_create(self.conf_temp, 'VerboseLevel', GLOBAL.Verbose_Level_Default, GLOBAL.Verbose_Level)
	debug_table.attach(verbose_level_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
	debug_table.attach(self.verbose_level_spinner, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
				# CatchAIExceptions
	catch_ai_exceptions_label = label_create("Catch AI Exceptions")
	self.catch_ai_exceptions_combobox = combobox_setup(self.conf_temp, 'GAME', 'CatchAIExceptions', GLOBAL.Catch_AI_Exceptions_Default, GLOBAL.Catch_AI_Exceptions)
	debug_table.attach(catch_ai_exceptions_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
	debug_table.attach(self.catch_ai_exceptions_combobox, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
