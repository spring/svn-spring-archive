#!/usr/bin/env python

#======================================================
 #            Setup.py
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
import ConfigParser
import shutil

# Custom Modules
import GLOBAL

import Config



def setup_profile_check(self):
	if self.platform != 'win32':
		# Linux
		self.ini = []
		self.profiles = []

		HOME = os.environ['HOME']
		spring_gui_dir = os.path.join(HOME,'.spring-gui')
		spring_gui_setup_file = os.path.join(spring_gui_dir, 'setup.ini')
		if os.path.isdir(spring_gui_dir) == True:
			if os.path.isfile(spring_gui_setup_file) == True:
				setup_file = ConfigParser.ConfigParser()
				setup_file.optionxform = lambda x: x
				setup_file.read(spring_gui_setup_file)
				profiles = setup_file.sections()
				for i in range(0,len(profiles)):
					self.ini.append(spring_gui_setup_file)
					self.profiles.append(profiles[i])


def create_setup_file(spring_ini_dir, ini):
	if os.path.isdir(spring_ini_dir) != True:
		os.mkdir(spring_ini_dir)
		dest_fd = open(ini, "w+")
		dest_fd.write('\n')  # TODO  Check if i need this line
		dest_fd.close()


def save_setup_file(self, spring_ini_dir, ini):
	HOME = os.environ['HOME']
	profile_name = self.profile_name.get_text()
	if self.platform != 'win32':
		setup = GLOBAL.LINUX_INSTALL_TYPES[(self.install_type_combobox.get_active())]
	else:
		setup = GLOBAL.WINDOWS_INSTALL_TYPES[(self.install_type_combobox.get_active())]
	spring_binary = self.spring_binary.get_text()
#	spring_datadir = self.spring_datadir.get_text()
	spring_gui_background = self.background.get_text()
	spring_gui_profile_dir = os.path.join(spring_ini_dir,profile_name)

	if Config.has_section(ini, profile_name) == True:
		Config.delete_section(ini, profile_name)
	Config.add_section(ini, profile_name)

	Config.set_option(ini, profile_name, 'SETUP', setup)
	Config.set_option(ini, profile_name, 'SPRING_BINARY', spring_binary)
#	Config.set_option(ini, profile_name, 'SPRING_DATADIR', spring_datadir)
	Config.set_option(ini, profile_name, 'BACKGROUND', spring_gui_background)

	if os.path.isdir(spring_gui_profile_dir) == True:
		os.rmdir(spring_gui_profile_dir)
	os.mkdir(spring_gui_profile_dir)

	Config.set_option(ini, profile_name, 'SPRING_CONF', (os.path.join(HOME,'.springrc')))

	Config.set_option(ini, profile_name, 'SPRING_CONF_TEMP', os.path.join(spring_gui_profile_dir,'springrc-temp'))
	Config.set_option(ini, profile_name, 'MAP_INDEX', os.path.join(spring_gui_profile_dir,'map-index.ini'))
	Config.set_option(ini, profile_name, 'MOD_INDEX', os.path.join(spring_gui_profile_dir,'mod-index.ini'))
	Config.set_option(ini, profile_name, 'SPRING_MAP_PREVIEW', os.path.join(spring_gui_profile_dir,'map-preview.tga'))

	Config.set_option(ini, profile_name, 'SPRING_SCRIPT', os.path.join(spring_gui_profile_dir,'script.txt'))
	Config.set_option(ini, profile_name, 'SPRING_SCRIPT_TEMP', (os.path.join(spring_gui_profile_dir,'script-temp.txt')))
	Config.set_option(ini, profile_name, 'GDB_SCRIPT_TEMP', (os.path.join(spring_gui_profile_dir,'gdb_script.txt')))


	Config.set_option(ini, profile_name, 'VERSION', '4.03')
	Config.set_option(ini, profile_name, 'STARTUP', '1')

	# Update Profile Selection
	self.select_profile_liststore.append([profile_name, ini])


def profile_save(widget, self):		# Linux
	if self.platform != 'win32':
		setup = GLOBAL.LINUX_INSTALL_TYPES[(self.install_type_combobox.get_active())]
	else:
		setup = GLOBAL.WINDOWS_INSTALL_TYPES[(self.install_type_combobox.get_active())]

	HOME = os.environ['HOME']

	spring_ini_dir = os.path.join(HOME,'.spring-gui')
	ini = os.path.join(spring_ini_dir,'setup.ini')
	create_setup_file(spring_ini_dir, ini)
	save_setup_file(self, spring_ini_dir, ini)


def profile_delete(widget, event, self):
	treeselection = self.select_profile_treeview.get_selection()
	(model, iter) = treeselection.get_selected()
	if iter != None:
		profile_name = self.select_profile_liststore.get_value(iter,0)
		ini = self.select_profile_liststore.get_value(iter,1)
		spring_gui_profile_dir = ini[:-9]
		spring_gui_profile_dir = os.path.join(spring_gui_profile_dir, profile_name)
		if Config.has_section(ini, profile_name) == True:
			Config.delete_section(ini, profile_name)
		if os.path.isdir(spring_gui_profile_dir) == True:
			shutil.rmtree(spring_gui_profile_dir)
		self.select_profile_liststore.remove(iter)

def index_delete(widget, event, filename):
	if os.path.isfile(filename):
		os.remove(filename)
