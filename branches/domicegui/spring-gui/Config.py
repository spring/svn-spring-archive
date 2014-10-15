#!/usr/bin/env python

#======================================================
 #            Config.py
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
import ConfigParser
import fileinput
import os
import re

# Custom Modules
from GLOBAL import Resolution_X, Resolution_Y  # Only need 2 of them so what the hell :P


def temp_config(src, dest, Save):
# Save variable is to set it to remove | add hack
# If Save is set to No  then it adds    the hack
# If Save is set to Yes then it removes the hack
#		Hack is adding [MAIN] to temp file  so can use ConfigParser on the temp file
# If Save is anything else  it just copies the src(file) -> dest(file)
	dest_fd = open(dest,"w+")
	if os.path.isfile(src) == True:
		remove_whitespace = re.compile('( = )')
		for line in fileinput.input(src):
			line_fixed = remove_whitespace.sub('=',line)
			if fileinput.isfirstline() == True:
				if Save == 'No':
					if line != '[GAME]\n':
						dest_fd.write('[GAME]\n')
					dest_fd.write(line_fixed)
			elif Save == 'Yes':
				dest_fd.write(line_fixed)
			else:
				dest_fd.write(line_fixed)
		dest_fd.close()
	else:
		dest_fd.write('[GAME]\n')
		dest_fd.close()

def save(self, filename, tempfile):
	# Grab Values from Configure Options and save them to temp file
	# Then call on temp_config function to remove hack & save to .springrc
	set_option(tempfile, 'GAME', 'name', self.player_name.get_text())
	set_option(tempfile, 'GAME', 'SoundVolume', self.sound_volume_spinner.get_value_as_int())
	set_option(tempfile, 'GAME', 'XResolution', Resolution_X[self.resolution_combobox.get_active()])
	set_option(tempfile, 'GAME', 'YResolution', Resolution_Y[self.resolution_combobox.get_active()])
	set_option(tempfile, 'GAME', 'Fullscreen', self.fullscreen_combobox.get_active())

	value = self.fsaa_spinner.get_value_as_int()
	if value == 0:
		set_option(tempfile, 'GAME', 'FSAA', value)
	else:
		set_option(tempfile, 'GAME', 'FSAALevel', value)

	set_option(tempfile, 'GAME', 'Shadows', self.shadows_combobox.get_active())
	set_option(tempfile, 'GAME', 'GrassDetail', self.grass_detail_spinner.get_value_as_int())
	set_option(tempfile, 'GAME', 'GroundDetail', self.ground_detail_spinner.get_value_as_int())
	set_option(tempfile, 'GAME', 'GroundDecals', self.ground_decals_spinner.get_value_as_int())
	set_option(tempfile, 'GAME', 'MaxParticles', self.max_particles_spinner.get_value_as_int())
	set_option(tempfile, 'GAME', 'AdvSky', self.adv_sky_combobox.get_active())
	set_option(tempfile, 'GAME', 'DynamicSky', self.dynamic_sky_combobox.get_active())
	set_option(tempfile, 'GAME', 'AdvUnitShading', self.adv_unit_shading_combobox.get_active())
	set_option(tempfile, 'GAME', 'ReflectiveWater', self.reflective_water_combobox.get_active())
	set_option(tempfile, 'GAME', 'MaxSounds', self.max_sounds_spinner.get_value_as_int())
	set_option(tempfile, 'GAME', 'UnitIconDist', self.unit_lod_distance_spinner.get_value_as_int())
	set_option(tempfile, 'GAME', 'VerboseLevel', self.verbose_level_spinner.get_value_as_int())
	set_option(tempfile, 'GAME', 'CatchAIExceptions', self.catch_ai_exceptions_combobox.get_active())

	temp_config(tempfile,filename,'Yes')

def get_option(src, section, option, default_value):
	config = ConfigParser.ConfigParser()
	config.read(src)
	if config.has_option(section,option):
		value = config.get(section,option)
		# Hack for Resolutions
		if option == 'XResolution':
			for i in range (0,(len(Resolution_X))):
				if Resolution_X[i] == value:
					return i
		else:
			return value
	else:
		set_option(src, section, option, default_value)
		return default_value

def set_option(src, section, option, value):
	config = ConfigParser.ConfigParser()
	config.optionxform = lambda x: x
	config.read(src)
	# Hack for Resolutions
	if option == 'Resolution':
		config.set(section, 'XResolution',Resolution_X[value])
		config.set(section, 'YResolution',Resolution_Y[value])
	else:
		config.set(section, option, value)
	config.write(open(src, "w+"))

def add_section(src, section):
	config = ConfigParser.ConfigParser()
	config.optionxform = lambda x: x
	config.read(src)
	config.add_section(section)
	config.write(open(src, "w+"))

def has_section(src,section):
	config = ConfigParser.ConfigParser()
	config.optionxform = lambda x: x
	config.read(src)
	return config.has_section(section)

def delete_section(src,section):
	config = ConfigParser.ConfigParser()
	config.optionxform = lambda x: x
	config.read(src)
	config.remove_section(section)
	config.write(open(src, "w+"))

def list_sections(src):
	config = ConfigParser.ConfigParser()
	config.optionxform = lambda x: x
	config.read(src)
	return config.sections()
