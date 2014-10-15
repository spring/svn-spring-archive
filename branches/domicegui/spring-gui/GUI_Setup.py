#!/usr/bin/env python

#======================================================
 #            GUI_Setup.py
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

# Python / Pygtk Modules

import fileinput
import gtk
import os
import platform
import sys

# Custom Modules
import GLOBAL

import Config
import Setup

from GUI_ import combobox_setup, spinner_create, label_create, frame_create

class FileSelection:

	def destroy(self, widget):
		gtk.main_quit()

	def __init__(self,outside_self):
		dialog = gtk.FileChooserDialog("Open..",
						None,
						gtk.FILE_CHOOSER_ACTION_OPEN,
						(gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
						gtk.STOCK_OPEN, gtk.RESPONSE_OK))
		dialog.set_default_response(gtk.RESPONSE_OK)

		filter = gtk.FileFilter()
		filter.set_name("All files")
#		filter.add_pattern("*")
#		dialog.add_filter(filter)

		response = dialog.run()
		if response == gtk.RESPONSE_OK:
			outside_self.filename = dialog.get_filename()
		elif response == gtk.RESPONSE_CANCEL:
			outside_self.filename = None
		dialog.destroy()

	def main(self):
		gtk.main()


def spring_binary_location(widget,self):
	profile_window = FileSelection(self)
	self.spring_binary.set_text(self.filename)


def spring_datadir_location(widget,self):
	profile_window = FileSelection(self)
	self.spring_datadir.set_text(self.filename)

def spring_gui_background_location(widget,self):
	profile_window = FileSelection(self)
	self.background.set_text(self.filename)


def create_page(self, notebook, text, x, y):
	frame = gtk.Frame(text)
	frame.set_border_width(10)
	frame.set_size_request(x,y)
	frame.show()

	label = gtk.Label(text)
	notebook.append_page(frame, label)

	return frame


def install_type_selection(combobox, self):
	index = combobox.get_active()

	if sys.platform != 'win32':
		# Linux Datadir
		if GLOBAL.LINUX_INSTALL_TYPES[index] == 'Basic':
			print ('FIX GUI_Setup.py -> install_type_selection')
			self.spring_datadir.hide()
			self.spring_datadir_label.hide()

		if GLOBAL.LINUX_INSTALL_TYPES[index] == 'Advanced':
			self.spring_datadir.show()
			self.spring_datadir_label.show()


def create(self, notebook):
	Setup.setup_profile_check(self)
	self.window.set_size_request(450,310)   # TODO Correct size

	# Frame - Select Profile Frame
	select_profile_frame = create_page(self, notebook, 'Select Profile', 100, 75)


		# Select Profile Window (scrolled)
	select_profile_window = gtk.ScrolledWindow()
	select_profile_window.set_border_width(10)
	select_profile_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
	select_profile_window.show()
	select_profile_frame.add(select_profile_window)
			# Select Profile ListStore
			  # Profile Name       = String
 	self.select_profile_liststore = gtk.ListStore(str,str)
	self.select_profile_treeview = gtk.TreeView(self.select_profile_liststore)
	select_profile_column_1 = gtk.TreeViewColumn('Profile')
	self.select_profile_treeview.append_column(select_profile_column_1)
	select_profile_window.add(self.select_profile_treeview)
	self.select_profile_treeview.show()

	for i in range(0,len(self.profiles)):
		self.select_profile_liststore.append([self.profiles[i],self.ini[i]])


		# Add Mouse Click event to select_profile_treeview
	self.select_profile_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
	self.select_profile_treeview.connect('event',profile_selection, self)

        	# create a CellRenderers to render the data
        self.cell1  = gtk.CellRendererText()

        	# set background color property
        self.cell1.set_property('cell-background', 'white')

        	# add the cells to the columns
	select_profile_column_1.pack_start(self.cell1, False)

        	# set the cell attributes to the appropriate liststore column
        select_profile_column_1.set_attributes(self.cell1, text=0)


	# INSTALL SETUP INFO
	if sys.platform != 'win32':
		install_types = GLOBAL.LINUX_INSTALL_TYPES
		install_types_default = GLOBAL.LINUX_INSTALL_TYPES_DEFAULT
	else:
		install_types = GLOBAL.WINDOWS_INSTALL_TYPES
		install_types_default = GLOBAL.WINDOWS_INSTALL_TYPES_DEFAULT


	# Frame - Create Profile Frame
	create_profile_frame = create_page(self, notebook, 'Create Profile', 100, 75)

		# Table
	create_profile_table = gtk.Table(rows=1,columns=1, homogeneous=False)
	create_profile_table.show()
	create_profile_frame.add(create_profile_table)

			# Profile Name
	profile_name_label = label_create("Profile Name")
	self.profile_name = gtk.Entry(max=0)
	self.profile_name.show()
	create_profile_table.attach(profile_name_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
	create_profile_table.attach(self.profile_name, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
			# Install Type
	install_type_label = label_create("Install Type")
	self.install_type_combobox = combobox_setup(None, None, None, install_types_default, install_types)
	self.install_type_combobox.connect("changed", install_type_selection, self)
	create_profile_table.attach(install_type_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
	create_profile_table.attach(self.install_type_combobox, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
			# Spring Binary
	spring_binary_label = label_create('Spring Binary')
	self.spring_binary = gtk.Entry(max=0)
	self.spring_binary.set_text('spring')
	self.spring_binary.show()
	create_profile_table.attach(spring_binary_label, 0,1,2,3, gtk.FILL,gtk.FILL,10,10)
	create_profile_table.attach(self.spring_binary, 1,2,2,3, gtk.FILL,gtk.FILL,10,10)
			# Datadir Location
	self.spring_datadir_label = label_create('Spring Datadir')
	self.spring_datadir = gtk.Entry(max=0)
	self.spring_datadir.show()
	create_profile_table.attach(self.spring_datadir_label, 0,1,3,4, gtk.FILL,gtk.FILL,10,10)
	create_profile_table.attach(self.spring_datadir, 1,2,3,4, gtk.FILL,gtk.FILL,10,10)
			# Spring-GUI Background
	background_label = label_create('Spring GUI Background')
	self.background = gtk.Entry(max=0)
	self.background.show()
	create_profile_table.attach(background_label, 0,1,4,5, gtk.FILL,gtk.FILL,10,10)
	create_profile_table.attach(self.background, 1,2,4,5, gtk.FILL,gtk.FILL,10,10)
				# Default -> Background
	if os.path.isfile (GLOBAL.SPRING_GUI_BACKGROUND):
		self.background.set_text(GLOBAL.SPRING_GUI_BACKGROUND)


			# Button -> Save
	save_button = gtk.Button(label=None, stock=gtk.STOCK_SAVE)
	save_button.connect("clicked", Setup.profile_save, self)
	save_button.show()
	create_profile_table.attach(save_button, 2,3,0,1, 0,0,0,0)

			# Button -> Spring Binary
	spring_binary_button = gtk.Button(label=None, stock=gtk.STOCK_OPEN)
	spring_binary_button.connect("clicked", spring_binary_location, self)
	spring_binary_button.show()
	create_profile_table.attach(spring_binary_button, 2,3,2,3, 0,0,0,0)

			# Button -> Spring GUI Background
	background_button = gtk.Button(label=None, stock=gtk.STOCK_OPEN)
	background_button.connect("clicked", spring_gui_background_location, self)
	background_button.show()
	create_profile_table.attach(background_button, 2,3,4,5, 0,0,0,0)

	# Default Selection
	install_type_selection(self.install_type_combobox, self)




def profile_selection(widget, event, self):
	treeselection = self.select_profile_treeview.get_selection()
	(model, iter) = treeselection.get_selected()
	if iter != None:
		if event.type == gtk.gdk.BUTTON_PRESS:
			if event.button == 1:
				self.profile = self.select_profile_liststore.get_value(iter, 0)
				self.ini = self.select_profile_liststore.get_value(iter, 1)
				self.destroy()
		        if event.button == 3:
				self.profile = self.select_profile_liststore.get_value(iter, 0)
				self.ini = self.select_profile_liststore.get_value(iter, 1)
				self.map_index = Config.get_option(self.ini, self.profile, 'MAP_INDEX', None)
				self.mod_index = Config.get_option(self.ini, self.profile, 'MOD_INDEX', None)
				# Main Menu
				menu = gtk.Menu()
				menu.show()
				delete_profile_item = gtk.MenuItem("Delete Profile")
				delete_index_item = gtk.MenuItem("Delete Index")
				menu.append(delete_profile_item)
				menu.append(delete_index_item)
				delete_profile_item.show()
				delete_index_item.show()
				delete_profile_item.connect("button_press_event", Setup.profile_delete, self)
				menu.popup(None, None, None, event.button, event.time)


				menu_remove_index = gtk.Menu()
				menu_remove_index.show()
				remove_index_map_item = gtk.MenuItem('Map')
				remove_index_map_item.connect("button_press_event", Setup.index_delete, self.map_index)
				menu_remove_index.append(remove_index_map_item)
				remove_index_map_item.show()


				remove_index_mod_item = gtk.MenuItem('Mod')
				remove_index_mod_item.connect("button_press_event", Setup.index_delete, self.mod_index)
				menu_remove_index.append(remove_index_mod_item)
				remove_index_mod_item.show()

				delete_index_item.set_submenu(menu_remove_index)
