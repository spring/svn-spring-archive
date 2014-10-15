#!/usr/bin/env python

#======================================================
 #            Profile.py
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

# Standard Modules
import ConfigParser
import gtk
import os
import sys
import shutil


class profile:
	def __init__(self, unity_location, show):
		self.platform = sys.platform
		self.show = show

		self.unity_location = unity_location


		# Detect Profiles
		self.setup_profiles = []
		if self.platform != 'win32':
			# Linux
			self.home = os.environ['HOME']
			self.setup_dir = os.path.join(self.home, '.unity-lobby', 'profiles')
			self.setup_ini = os.path.join(self.setup_dir, 'setup.ini')
	        else:
	                # Windows
	                self.appdata = os.environ['APPDATA']
	             	self.setup_dir = os.path.join(self.appdata, 'unity-lobby', 'profiles')
	                self.setup_ini = os.path.join(self.setup_dir, 'setup.ini')

		if os.path.isdir(self.setup_dir) == True:
			if os.path.isfile(self.setup_ini) == True:
				setup_file = ConfigParser.ConfigParser()
				setup_file.optionxform = lambda x: x
				setup_file.read(self.setup_ini)
				profiles = setup_file.sections()
				for i in range(0,len(profiles)):
					self.setup_profiles.append(profiles[i])

		# Remove Old Profiles
		old_profiles = []
	
		for i in range(0,len(self.setup_profiles)):
			if setup_file.has_option(self.setup_profiles[i], 'VERSION') == False:
				setup_file.set(self.setup_profiles[i], 'VERSION', '0')
			version_check = setup_file.get(self.setup_profiles[i], 'VERSION')

			if version_check != '2.00':
				old_profiles.append(self.setup_profiles[i])
				profile_dir = os.path.join(self.setup_dir, self.setup_profiles[i])	
				setup_file.remove_section(self.setup_profiles[i])
				if os.path.isdir(profile_dir) == True:
					shutil.rmtree(profile_dir)

		for i in range(0,len(old_profiles)):
			self.setup_profiles.remove(old_profiles[i])


		if self.setup_profiles == []:
			if os.path.isfile(os.path.join(self.unity_location, 'profiles', 'setup.ini')) == True:
				self.create_default_profile()


	def main(self):
		if len(self.setup_profiles) != 1 or self.show == True:
			self.window.show()
			gtk.main()
		else:
			unity = os.path.join(self.unity_location, 'client', 'main.py')
			os.spawnlp(os.P_NOWAIT, unity, unity, '-p', self.setup_profiles[0])


	def spring_binary_location(widget,self):
		profile_window = FileSelection(self)
		if self.filename != None:
			self.spring_binary.set_text(self.filename)


	def create_page(self, notebook, text, x, y):
		frame = gtk.Frame(text)
		frame.set_border_width(10)
		frame.set_size_request(x,y)
		frame.show()

		label = gtk.Label(text)
		notebook.append_page(frame, label)
		return frame


	def create(self):
		if len(self.setup_profiles) != 1 or self.show == True:

			# Main Window
			self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
			self.window.set_title("Unity Lobby -> Profile")
			self.window.connect("delete-event", gtk.main_quit)
			self.window.add_events(gtk.gdk.BUTTON_PRESS_MASK)

			# Vertical Box Part 1/2
			vbox = gtk.VBox(False, 0)
			vbox.show()
			self.window.add(vbox)

			# Menu Part 1/2
			menu_bar = gtk.MenuBar()
			menu_bar.show()

			# Setup Notebook
			notebook = gtk.Notebook()
		        notebook.set_tab_pos(gtk.POS_TOP)
			notebook.show()

			#Vertical Box Part 2/2
			vbox.pack_start(notebook, True, True, 2)

			# Frame - Select Profile Frame
			select_profile_frame = self.create_page(notebook, 'Select Profile', 100, 75)

			# Select Profile Window (scrolled)
			select_profile_window = gtk.ScrolledWindow()
			select_profile_window.set_border_width(10)
			select_profile_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
			select_profile_window.show()
			select_profile_frame.add(select_profile_window)
				# Select Profile ListStore
				  # Profile Name       = String
		 	self.select_profile_liststore = gtk.ListStore(str)
			self.select_profile_treeview = gtk.TreeView(self.select_profile_liststore)
			select_profile_column_1 = gtk.TreeViewColumn('Profile')
			self.select_profile_treeview.append_column(select_profile_column_1)
			select_profile_window.add(self.select_profile_treeview)
			self.select_profile_treeview.show()

			for i in range(0,len(self.setup_profiles)):
				self.select_profile_liststore.append([self.setup_profiles[i]])

				# Add Mouse Click event to select_profile_treeview
			self.select_profile_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
			self.select_profile_treeview.connect('event', self.profile_selection)

		        	# create a CellRenderers to render the data
		        self.cell1  = gtk.CellRendererText()

		        	# add the cells to the columns
			select_profile_column_1.pack_start(self.cell1, False)

		        	# set the cell attributes to the appropriate liststore column
		        select_profile_column_1.set_attributes(self.cell1, text=0)

			# Frame - Create Profile Frame
			create_profile_frame = self.create_page(notebook, 'Create Profile', 100, 75)

				# Table
			create_profile_table = gtk.Table(rows=1,columns=1, homogeneous=False)
			create_profile_table.show()
			create_profile_frame.add(create_profile_table)

					# Profile Name
			profile_name_label = gtk.Label("Profile Name")
			profile_name_label.set_justify(gtk.JUSTIFY_LEFT)
			profile_name_label.show()
			self.profile_name = gtk.Entry(max=0)
			self.profile_name.show()
			create_profile_table.attach(profile_name_label, 0,1,0,1)#, gtk.EXPAND,gtk.EXPAND,5,5)
			create_profile_table.attach(self.profile_name, 1,2,0,1)#, gtk.EXPAND,gtk.EXPAND,5,5)
					# Spring Binary
			spring_binary_label = gtk.Label("Spring Binary")
			spring_binary_label.set_justify(gtk.JUSTIFY_LEFT)
			spring_binary_label.show()
			self.spring_binary = gtk.Entry(max=0)
			self.spring_binary.set_text('spring')
			self.spring_binary.show()
			create_profile_table.attach(spring_binary_label, 0,1,2,3)#, gtk.EXPAND,gtk.EXPAND,5,5)
			create_profile_table.attach(self.spring_binary, 1,2,2,3)#, gtk.EXPAND,gtk.EXPAND,5,5)
					# Datadir Location
			spring_datadir_label = gtk.Label("Spring Datadir")
			spring_datadir_label.set_justify(gtk.JUSTIFY_LEFT)
			spring_datadir_label.show()
			self.spring_datadir = gtk.Entry(max=0)
			self.spring_datadir.show()
			create_profile_table.attach(spring_datadir_label, 0,1,3,4)#, gtk.EXPAND,gtk.EXPAND,5,5)
			create_profile_table.attach(self.spring_datadir, 1,2,3,4)#, gtk.EXPAND,gtk.EXPAND,5,5)

					# Button -> Save
			save_button = gtk.Button(label=None, stock=gtk.STOCK_SAVE)
			save_button.connect("clicked", self.profile_save)
			save_button.show()
			create_profile_table.attach(save_button, 0,2,4,5, gtk.FILL,gtk.FILL,0,0)
	

	def profile_selection(self, widget, event):
		treeselection = self.select_profile_treeview.get_selection()
		(model, iter) = treeselection.get_selected()
		if iter != None:
			if event.type == gtk.gdk.BUTTON_PRESS:
				if event.button == 1:
					profile = self.select_profile_liststore.get_value(iter, 0)
					unity = os.path.join(self.unity_location, 'client', 'main.py')
					os.spawnlp(os.P_NOWAIT, unity, unity, '-p', profile)
					gtk.main_quit()
			        if event.button == 3:
					config = ConfigParser.ConfigParser()
					config.optionxform = lambda x: x
					config.read(self.setup_ini)

					self.profile = self.select_profile_liststore.get_value(iter, 0)
					self.map_index = config.get(self.profile, 'MAP_INDEX', None)
					self.mod_index = config.get(self.profile, 'MOD_INDEX', None)
					# Main Menu
					menu = gtk.Menu()
					menu.show()
					delete_profile_item = gtk.MenuItem("Delete Profile")
					delete_index_item = gtk.MenuItem("Delete Index")
					menu.append(delete_profile_item)
					menu.append(delete_index_item)
					delete_profile_item.show()
					delete_index_item.show()
					delete_profile_item.connect("button_press_event", self.profile_delete)
					menu.popup(None, None, None, event.button, event.time)


					menu_remove_index = gtk.Menu()
					menu_remove_index.show()
					remove_index_map_item = gtk.MenuItem('Map')
					remove_index_map_item.connect("button_press_event", self.index_delete, self.map_index)
					menu_remove_index.append(remove_index_map_item)
					remove_index_map_item.show()


					remove_index_mod_item = gtk.MenuItem('Mod')
					remove_index_mod_item.connect("button_press_event", self.index_delete, self.mod_index)
					menu_remove_index.append(remove_index_mod_item)
					remove_index_mod_item.show()

					delete_index_item.set_submenu(menu_remove_index)


	def create_setup_file(self):
		if os.path.isdir(self.setup_dir) != True:
			os.makedirs(self.setup_dir)
			dest_fd = open(self.setup_ini, "w+")
			dest_fd.write('\n')
			dest_fd.close()


	def save_setup_file(self):
		profile_name = self.profile_name.get_text()
		setup_profile_dir = os.path.join(self.setup_dir, profile_name)

		config = ConfigParser.ConfigParser()
		config.optionxform = lambda x: x
		config.read(self.setup_ini)

		if config.has_section(profile_name) == True:
			config.remove_section(profile_name)
		else:
			self.select_profile_liststore.append([profile_name])
		config.add_section(profile_name)
		if os.path.isdir(setup_profile_dir) == True:
			os.rmdir(setup_profile_dir)
		os.mkdir(setup_profile_dir)

		config.set(profile_name, 'LOBBY_CONF', os.path.join(self.setup_dir, 'lobby.ini'))
		config.set(profile_name, 'SPRING_BINARY', self.spring_binary.get_text())
		config.set(profile_name, 'SPRING_DATADIR',  self.spring_datadir.get_text())
		config.set(profile_name, 'SPRING_CONF_TEMP', os.path.join(setup_profile_dir, 'springrc-temp'))
		config.set(profile_name, 'SPRING_SCRIPT', os.path.join(setup_profile_dir, 'script.txt'))
		config.set(profile_name, 'DOCKAPP', os.path.join(self.unity_location,'resources', 'spring.png'))
		config.set(profile_name, 'MAP_INDEX', os.path.join(setup_profile_dir, 'map-index.ini'))
		config.set(profile_name, 'MOD_INDEX', os.path.join(setup_profile_dir, 'mod-index.ini'))
		config.set(profile_name, 'SPRING_MAP_PREVIEW', os.path.join(setup_profile_dir, 'map-preview.jpeg'))
		config.set(profile_name, 'GDB_SCRIPT_TEMP', os.path.join(setup_profile_dir, 'gdb_script.txt'))
		config.set(profile_name, 'UNITY_INSTALL_DIR', sys.path[0])

		config.set(profile_name, 'BATTLE_WINDOW_HEIGHT', 553)
		config.set(profile_name, 'BATTLE_WINDOW_WIDTH', 977)
		config.set(profile_name, 'LOBBY_WINDOW_HEIGHT', 553)
		config.set(profile_name, 'LOBBY_WINDOW_WIDTH', 977)
		config.set(profile_name, 'OPTIONS_WINDOW_HEIGHT', 254)
		config.set(profile_name, 'OPTIONS_WINDOW_WIDTH', 359)


		if self.platform != 'win32':
	                # Linux
			config.set(profile_name, 'SPRING_CONF', os.path.join(self.home, '.springrc'))
		else:
	                # Windows
			pass

		config.set(profile_name, 'VERSION', '2.00')
		config.set(profile_name, 'STARTUP', '1')
		config.write(open(self.setup_ini, "w+"))


	def create_default_profile(self):
		self.create_setup_file()


	def profile_save(self, widget):
		self.create_setup_file()
		self.save_setup_file()


	def profile_delete(self, widget, event):
		import shutil
		treeselection = self.select_profile_treeview.get_selection()
		(model, iter) = treeselection.get_selected()
		if iter != None:
			profile_name = self.select_profile_liststore.get_value(iter,0)
			profile_dir = os.path.join(self.setup_dir, profile_name)

			config = ConfigParser.ConfigParser()
			config.optionxform = lambda x: x
			config.read(self.setup_ini)
			config.remove_section(profile_name)
			config.write(open(self.setup_ini, "w+"))

			if os.path.isdir(profile_dir) == True:
				shutil.rmtree(profile_dir)

			self.select_profile_liststore.remove(iter)


	def index_delete(self, widget, event, filename):
		if os.path.isfile(filename):
			os.remove(filename)


if __name__ == "__main__":
	print 'Profile Launched'
	from optparse import OptionParser
	import sys

	unity_location = sys.path[0]

        parser = OptionParser()
        parser.add_option("-s", "--profile-selection", action="store_true", dest="profile_selection", default=False, help="Startup Profile Setup")
        (options, args) = parser.parse_args()

	profile = profile(unity_location, options.profile_selection)
	profile.create()
	profile.main()
