#!/usr/bin/env python

#======================================================
 #            Battle.py
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
import array
import ConfigParser
import os
import gtk

# Additional Modules
import Image

# Custom Modules
import unitsync

import GLOBAL

from Misc import create_page, label_create, combobox_setup, frame_create


def treeview_team_image(column, cell, model, iter):
	pixbuf = model.get_value(iter, 6)
	cell.set_property('pixbuf', pixbuf)
	return


class color_selector:

	def __init__(self):
		pass


	# Color changed handler
	def color_changed_cb(self, widget):
		# Get drawingarea colormap
		colormap = self.drawingarea.get_colormap()
		# Get current color
		color = self.colorseldlg.colorsel.get_current_color()
		# Set window color
		self.drawingarea.modify_bg(gtk.STATE_NORMAL, color)



	# Close down and exit handler
	def color_destroy_window(self, widget, event):
		self.colorseldlg.destroy()
		self.drawingarea.destroy()
		return False

	def color_selector(self, red, green, blue):
		self.colorseldlg = None
  
		# Create drawingarea, set size and catch button events
		self.drawingarea = gtk.DrawingArea()

		color = self.drawingarea.get_colormap().alloc_color(red, green, blue)

		handled = False

		# Check if we've received a button pressed event
		handled = True

		# Create color selection dialog
		if self.colorseldlg == None:
			self.colorseldlg = gtk.ColorSelectionDialog("Select Color")

		# Get the ColorSelection widget
		colorsel = self.colorseldlg.colorsel

		colorsel.set_current_color(color)
		colorsel.set_has_palette(True)

		# Connect to the "color_changed" signal
		colorsel.connect("color_changed", self.color_changed_cb)
		# Show the dialog
		response = self.colorseldlg.run()

		if response == gtk.RESPONSE_OK:
			color = colorsel.get_current_color()
			self.color_destroy_window(None,None)
			red = color.red
			green =  color.green
			blue =  color.blue
			update = True
			return update, red, green, blue
		else:
			self.drawingarea.modify_bg(gtk.STATE_NORMAL, color)
			self.color_destroy_window(None,None)
			update = False
			return update, red, green, blue



class battle:

	def __init__(self, parent_window):
		self.parent_window = parent_window

		self.platform = self.parent_window.platform
		self.datadirs = self.parent_window.datadirs

		self.ini =  self.parent_window.ini
		self.profile = self.parent_window.profile

		self.start_metal = 2000
		self.start_energy = 2000
		self.max_units = 500
		self.game_type = 0
		self.game_mode = 0
		self.start_pos_type = 0

		self.my_player_name = 'Player'

		self.map_index_file = self.parent_window.map_index_file
		self.mod_index_file = self.parent_window.map_index_file


		self.map_index = parent_window.map_index
		self.mod_index = parent_window.mod_index

		self.config = self.parent_window.config

		self.profile_dir = self.parent_window.profile_dir


	def create(self, notebook):
			# Frame - Players
		player_frame = create_page(self, notebook, 'Players', 100,75)
				# Table - Player
		player_table = gtk.Table(rows=2, columns=2, homogeneous=False)
		player_table.show()
		player_frame.add(player_table)
				# Player Window (scrolled)
		player_window = gtk.ScrolledWindow()
		player_window.set_border_width(10)
		player_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
		player_window.show()
		player_table.attach(player_window,0,1,0,2, gtk.SHRINK|gtk.FILL|gtk.EXPAND,gtk.SHRINK|gtk.FILL|gtk.EXPAND,5,5)
					# Player ListStore
					  # 0  Ready       = gtk.gdk.Pixbuf
					  # 1  Name        = String
					  # 2  Team        = int
					  # 3  RGB -> R    = String
					  # 4  RGB -> G    = String
					  # 5  RGB -> B    = String
					  # 6  Color Image = gtk.gdk.Pixbuf
					  # 7  Side        = String
					  # 8  Ally        = int
					  # 9  Bonus       = int
					  # 10 AI          = String
					  # 11 AI Owner    = String
					  # 12 AI Location = String
	 	self.player_liststore = gtk.ListStore(gtk.gdk.Pixbuf, str, int, str, str, str, gtk.gdk.Pixbuf, str, int, int, str, str, str)
		self.player_treeview = gtk.TreeView(self.player_liststore)
		self.player_column_0 = gtk.TreeViewColumn('Ready')
		self.player_column_1 = gtk.TreeViewColumn('Name')
		self.player_column_2 = gtk.TreeViewColumn('Army')
		self.player_column_3 = gtk.TreeViewColumn('Color')
		self.player_column_4 = gtk.TreeViewColumn('Side')
		self.player_column_5 = gtk.TreeViewColumn('Ally')
		self.player_column_6 = gtk.TreeViewColumn('Bonus')
		self.player_column_7 = gtk.TreeViewColumn('AI')
		self.player_column_8 = gtk.TreeViewColumn('AI Owner')
	
		self.player_treeview.append_column(self.player_column_0)
		self.player_treeview.append_column(self.player_column_1)
		self.player_treeview.append_column(self.player_column_2)
		self.player_treeview.append_column(self.player_column_3)
		self.player_treeview.append_column(self.player_column_4)
		self.player_treeview.append_column(self.player_column_5)
		self.player_treeview.append_column(self.player_column_6)
		self.player_treeview.append_column(self.player_column_7)
		self.player_treeview.append_column(self.player_column_8)
		player_window.add(self.player_treeview)
		self.player_treeview.show()

		# Add Mouse Click event to player_treeview
		self.player_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
		self.player_treeview.connect('event',self.player_popup_menu)
	
	        # create a CellRenderers to render the data
	        self.cell0  = gtk.CellRendererPixbuf()
	        self.cell1  = gtk.CellRendererText()
	        self.cell2  = gtk.CellRendererText()
	        self.cell3  = gtk.CellRendererPixbuf()
	        self.cell4  = gtk.CellRendererText()
	        self.cell5  = gtk.CellRendererText()
	        self.cell6  = gtk.CellRendererText()
	        self.cell7  = gtk.CellRendererText()
	        self.cell8  = gtk.CellRendererText()

        	# add the cells to the columns
		self.player_column_0.pack_start(self.cell0, False)
		self.player_column_1.pack_start(self.cell1, False)
		self.player_column_2.pack_start(self.cell2, False)
		self.player_column_3.pack_start(self.cell3, False)
		self.player_column_4.pack_start(self.cell4, False)
		self.player_column_5.pack_start(self.cell5, False)
		self.player_column_6.pack_start(self.cell6, False)
		self.player_column_7.pack_start(self.cell7, False)
		self.player_column_8.pack_start(self.cell8, False)

	        # set the cell attributes to the appropriate liststore column
	        self.player_column_0.set_attributes(self.cell0)
	        self.player_column_1.set_attributes(self.cell1, text=1)
	        self.player_column_2.set_attributes(self.cell2, text=2)
	        self.player_column_4.set_attributes(self.cell4, text=7)
	        self.player_column_5.set_attributes(self.cell5, text=8)
	        self.player_column_6.set_attributes(self.cell6, text=9)
	        self.player_column_7.set_attributes(self.cell7, text=10)
	        self.player_column_8.set_attributes(self.cell8, text=11)

	        # Allow sorting on the column
	        self.player_column_1.set_sort_column_id(1)
	        self.player_column_2.set_sort_column_id(2)
	        self.player_column_3.set_sort_column_id(3)
	        self.player_column_4.set_sort_column_id(4)
	        self.player_column_5.set_sort_column_id(5)
	        self.player_column_6.set_sort_column_id(6)
	        self.player_column_7.set_sort_column_id(7)
	        self.player_column_8.set_sort_column_id(8)


				# Map Preview 2
		self.map_preview_2 = gtk.Image()
		self.map_preview_2.show()
		player_table.attach(self.map_preview_2, 1,2,0,1, gtk.FILL, gtk.FILL,0,0)


	        # Options NoteBook
        	options_notebook = gtk.Notebook()
	        options_notebook.set_tab_pos(gtk.POS_TOP)
	        player_table.attach(options_notebook, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
	        options_notebook.show()
			# Frame - Options
		options_frame = create_page(self, options_notebook, 'Options', 350, 50)
					# Table
		options_table = gtk.Table(rows=1, columns=1, homogeneous=False)
		options_table.show()
		options_frame.add(options_table)
						# GameMode
		game_mode_label = label_create("Commander Dies")
		options_table.attach(game_mode_label,0,2,0,1, 0,0,10,10)
	
		self.game_mode = combobox_setup(GLOBAL.GAME_MODES, GLOBAL.GAME_MODES_DEFAULT, True)
		options_table.attach(self.game_mode, 2,4,0,1, gtk.FILL,gtk.FILL,10,10)
						# Starting Positions
		starting_positions_label = label_create("Starting Position")
		options_table.attach(starting_positions_label,0,2,1,2, gtk.FILL,gtk.FILL,10,10)
		self.starting_positions = combobox_setup(GLOBAL.STARTING_POSITIONS, GLOBAL.STARTING_POSITIONS_DEFAULT, True)
		options_table.attach(self.starting_positions, 2,4,1,2, gtk.FILL,gtk.FILL,10,10)
			# Frame - Resources
		resources_frame = create_page(self, options_notebook, 'Resources', 100, 50)
					# Table
		resources_table = gtk.Table(rows=1, columns=1, homogeneous =False)
		resources_table.show()
		resources_frame.add(resources_table)
						# Start Metal
		start_metal_label = label_create("Metal")
		resources_table.attach(start_metal_label, 0,1,0,1, gtk.FILL,gtk.FILL,10,10)
		start_metal_adjustment = gtk.Adjustment(self.start_metal, lower=0, upper=12000, step_incr=100, page_incr=1000, page_size=0)
		self.start_metal_spinner = gtk.SpinButton(start_metal_adjustment, 0, 0)
		self.start_metal_spinner.show()
		resources_table.attach(self.start_metal_spinner, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
						# Start Energy
		start_energy_label = label_create("Energy")
		resources_table.attach(start_energy_label, 2,3,0,1, gtk.FILL,gtk.FILL,10,10)
		start_energy_adjustment = gtk.Adjustment(self.start_energy, lower=0, upper=12000, step_incr=100, page_incr=1000, page_size=0)
		self.start_energy_spinner = gtk.SpinButton(start_energy_adjustment, 0, 0)
		self.start_energy_spinner.show()
		resources_table.attach(self.start_energy_spinner, 3,4,0,1, gtk.FILL,gtk.FILL,10,10)
						# Max Units
		max_units_label = label_create("Max Units")
		resources_table.attach(max_units_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
		max_units_adjustment = gtk.Adjustment(self.max_units, lower=0, upper=5000, step_incr=100, page_incr=1000, page_size=0)
		self.max_units_spinner = gtk.SpinButton(max_units_adjustment, 0, 0)
		self.max_units_spinner.show()
		resources_table.attach(self.max_units_spinner, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
			# Frame - Debug
		debug_frame = create_page(self, options_notebook, 'Debug', 100, 50)
					# Table
		debug_table = gtk.Table(rows=1, columns=1, homogeneous =False)
		debug_table.show()
		debug_frame.add(debug_table)
						# Gdb Backtrace
		gdb_backtrace_label = label_create("Gdb Backtrace")
		debug_table.attach(gdb_backtrace_label,0,1,0,1, gtk.FILL,gtk.FILL,10,10)

		self.gdb_backtrace = combobox_setup(GLOBAL.GDB_BACKTRACE, GLOBAL.GDB_BACKTRACE_DEFAULT, True)
		debug_table.attach(self.gdb_backtrace, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)


			# Notebook - Map / Mod
		map_frame = create_page(self, notebook, 'Map', 100, 75)
				# Table - Map
		map_table = gtk.Table(rows=2, columns=2, homogeneous=False)
		map_table.show()
		map_frame.add(map_table)
					# Map Preview
		self.map_preview_1 = gtk.Image()
		self.map_preview_1.show()
		map_table.attach(self.map_preview_1, 0,1,0,1, 0,0,60,10) # FIX
						# Map Description
		self.map_description = label_create("")
		self.map_description.set_line_wrap(1)
		map_table.attach(self.map_description, 0,1,1,2, gtk.SHRINK,gtk.SHRINK,0,0)
							# Map

					# Map Window (scrolled)
		map_window = gtk.ScrolledWindow()
		map_window.set_border_width(10)
		map_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
		map_window.show()
		map_table.attach(map_window, 0,1,2,3, gtk.EXPAND|gtk.FILL,gtk.EXPAND|gtk.FILL,0,0)  # FIX
						# Map ListStore
						  # Name             = str
						  # Players          = int
						  # Height           = int
						  # Width            = int
						  # Min Wind         = int
						  # Max Wind         = int
						  # Tidal            = int
						  # Extractor Radius = int
						  # Max Metal        = str
						  # Gravity          = str
	 	self.map_liststore = gtk.ListStore(str, int, int, int, int, int, int, int, str, str)
		self.map_treeview = gtk.TreeView(self.map_liststore)
		self.map_column_1 = gtk.TreeViewColumn('Name')
		self.map_column_2 = gtk.TreeViewColumn('Players')
		self.map_column_3 = gtk.TreeViewColumn('Height')
		self.map_column_4 = gtk.TreeViewColumn('Width')
		self.map_column_5 = gtk.TreeViewColumn('Min Wind')
		self.map_column_6 = gtk.TreeViewColumn('Max Wind')
		self.map_column_7 = gtk.TreeViewColumn('Tidal')
		self.map_column_8 = gtk.TreeViewColumn('Extractor Radius')
		self.map_column_9 = gtk.TreeViewColumn('Max Metal')
		self.map_column_10 = gtk.TreeViewColumn('Gravity')
		self.map_treeview.append_column(self.map_column_1)
		self.map_treeview.append_column(self.map_column_2)
		self.map_treeview.append_column(self.map_column_3)
		self.map_treeview.append_column(self.map_column_4)
		self.map_treeview.append_column(self.map_column_5)
		self.map_treeview.append_column(self.map_column_6)
		self.map_treeview.append_column(self.map_column_7)
		self.map_treeview.append_column(self.map_column_8)
		self.map_treeview.append_column(self.map_column_9)
		self.map_treeview.append_column(self.map_column_10)
		map_window.add(self.map_treeview)
		self.map_treeview.show()

		# Add Mouse Click event to map_treeview
		self.map_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
		self.map_treeview.connect('button_press_event', self.map_preview_check)

	        # create CellRenderers to render the data
        	self.map_cell_1  = gtk.CellRendererText()
	        self.map_cell_2  = gtk.CellRendererText()
	        self.map_cell_3  = gtk.CellRendererText()
	        self.map_cell_4  = gtk.CellRendererText()
	        self.map_cell_5  = gtk.CellRendererText()
	        self.map_cell_6  = gtk.CellRendererText()
	        self.map_cell_7  = gtk.CellRendererText()
	        self.map_cell_8  = gtk.CellRendererText()
	        self.map_cell_9  = gtk.CellRendererText()
	        self.map_cell_10  = gtk.CellRendererText()

        	# add the cells to the columns
		self.map_column_1.pack_start(self.map_cell_1, False)
		self.map_column_2.pack_start(self.map_cell_2, True)
		self.map_column_3.pack_start(self.map_cell_3, True)
		self.map_column_4.pack_start(self.map_cell_4, True)
		self.map_column_5.pack_start(self.map_cell_5, True)
		self.map_column_6.pack_start(self.map_cell_6, True)
		self.map_column_7.pack_start(self.map_cell_7, True)
		self.map_column_8.pack_start(self.map_cell_8, True)
		self.map_column_9.pack_start(self.map_cell_9, True)
		self.map_column_10.pack_start(self.map_cell_10, True)

	        # set the cell attributes to the appropriate liststore column
	        self.map_column_1.set_attributes(self.map_cell_1, text=0)
	        self.map_column_2.set_attributes(self.map_cell_2, text=1)
	        self.map_column_3.set_attributes(self.map_cell_3, text=2)
	        self.map_column_4.set_attributes(self.map_cell_4, text=3)
	        self.map_column_5.set_attributes(self.map_cell_5, text=4)
	        self.map_column_6.set_attributes(self.map_cell_6, text=5)
        	self.map_column_7.set_attributes(self.map_cell_7, text=6)
        	self.map_column_8.set_attributes(self.map_cell_8, text=7)
        	self.map_column_9.set_attributes(self.map_cell_9, text=8)
	        self.map_column_10.set_attributes(self.map_cell_10, text=8)

	        # Allow sorting on the column
        	self.map_column_1.set_sort_column_id(0)
	        self.map_column_2.set_sort_column_id(1)
	        self.map_column_3.set_sort_column_id(2)
	        self.map_column_4.set_sort_column_id(3)
	        self.map_column_5.set_sort_column_id(4)
	       	self.map_column_6.set_sort_column_id(5)
	        self.map_column_7.set_sort_column_id(6)
	        self.map_column_8.set_sort_column_id(7)
        	self.map_column_9.set_sort_column_id(8)
	        self.map_column_10.set_sort_column_id(9)

	        self.map_treeview.set_search_column(0)


		# Map List
		self.map_index.list_checksums()
		map_info = self.map_index.all_map_info()		
		for i in range (0,len(map_info)):
			self.map_liststore.append(map_info[i])


		map_treeselection = self.map_treeview.get_selection()
		map_treeselection.select_iter(self.map_liststore.get_iter_first())


			# Frame - Mod
		mod_frame = create_page(self, notebook, 'Mod', 100, 75)
					# Table - Mod
		mod_table = gtk.Table(rows=2, columns=2, homogeneous=False)
		mod_table.show()
		mod_frame.add(mod_table)
						# Mod Window (scrolled)
		mod_window = gtk.ScrolledWindow()
		mod_window.set_border_width(10)
		mod_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
		mod_window.show()
		mod_table.attach(mod_window, 0,1,0,1)
					# mod ListStore
					  # Mod Name       = String
					  # Mod Checksum   = String
	 	self.mod_liststore = gtk.ListStore(str,str)
		self.mod_treeview = gtk.TreeView(self.mod_liststore)
		self.mod_treeview.set_headers_visible(False)
		self.mod_column_1 = gtk.TreeViewColumn('Mod Name')
		self.mod_treeview.append_column(self.mod_column_1)
		mod_window.add(self.mod_treeview)
		self.mod_treeview.show()

		# Read Map Index & Add Map List
		mod_checksum_list = self.mod_index.list_checksums()
		for i in range(0,len(mod_checksum_list)):
			self.mod_liststore.append([self.mod_index.mod_archive_name(mod_checksum_list[i]), mod_checksum_list[i]])


		mod_treeselection = self.mod_treeview.get_selection()
		mod_treeselection.select_iter(self.mod_liststore.get_iter_first())


		self.mod_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
		self.mod_treeview.connect('cursor-changed', self.mod_selection)

		self.old_sides = self.mod_archive_sides()

	        self.cell_1  = gtk.CellRendererText()
		self.mod_column_1.pack_start(self.cell_1, False)
	        self.mod_column_1.set_attributes(self.cell_1, text=0)
	        self.mod_treeview.set_search_column(0)


			# Frame - Unit Browser
		unit_browser_frame = frame_create("Unit Browser")
		unit_browser_frame.show()
		mod_table.attach(unit_browser_frame, 0,2,1,2)

			# Frame - Restricted Units
		disabled_units_frame = create_page(self, notebook, 'Restricted Units', 100, 75)

		self.map_preview()


	def map_preview_check(self, widget, event):
		if event.button == 1:
			if event.type == gtk.gdk._2BUTTON_PRESS:
				self.map_preview()


	def map_preview(self):
	 	treeselection = self.map_treeview.get_selection()
		(model, iter) = treeselection.get_selected()
		map_name = self.map_liststore.get_value(iter, 0)
		map_name = map_name + GLOBAL.MAP_EXTENSION


		map_preview = self.ini.get(self.profile, 'SPRING_MAP_PREVIEW')

		unitsync.Init(True,1)
		unitsync.GetMinimap (map_name, GLOBAL.MIP_LEVEL, map_preview)

		map_height = self.map_liststore.get_value(iter, 2)
		map_width = self.map_liststore.get_value(iter, 3)
		if map_height > map_width:
			pixbuf = gtk.gdk.pixbuf_new_from_file(map_preview)
			new_width = ((float(map_width) / map_height) * GLOBAL.PIXEL_SIZE)
			scaled_buf = pixbuf.scale_simple(int(new_width),GLOBAL.PIXEL_SIZE,gtk.gdk.INTERP_BILINEAR)
			self.map_preview_1.set_from_pixbuf(scaled_buf)
			self.map_preview_2.set_from_pixbuf(scaled_buf)
		elif map_height < map_width:
			pixbuf = gtk.gdk.pixbuf_new_from_file(map_preview)
			new_height = ((float(map_height) / map_width) * GLOBAL.PIXEL_SIZE)
			scaled_buf = pixbuf.scale_simple(GLOBAL.PIXEL_SIZE,int(new_height),gtk.gdk.INTERP_BILINEAR)
			self.map_preview_1.set_from_pixbuf(scaled_buf)
			self.map_preview_2.set_from_pixbuf(scaled_buf)
		else:
			self.map_preview_1.set_from_file(map_preview)
			self.map_preview_2.set_from_file(map_preview)
			map_data = unitsync.GetMapInfo(map_name)
			self.map_description.set_text(str(map_data[1]["description"]))
			self.map_description.set_line_wrap(1)


	def mod_selection(self, widget):
		sides = self.mod_archive_sides()
		if self.old_sides != sides:
			treeiter = self.player_liststore.get_iter_first()
			while treeiter != None:
				old_team_side = (self.player_liststore.get_value(treeiter,7))
				for i in range(0,len(self.old_sides)):
					if old_team_side == self.old_sides[i]:
						if (len(sides)) >= i:
							self.player_liststore.set_value(treeiter,7,sides[i])
						else:
							self.player_liststore.set_value(treeiter,7,sides[0])
				treeiter = self.player_liststore.iter_next(treeiter)
	
		self.old_sides = sides


	def player_popup_menu(self, widget, event):
		if event.type == gtk.gdk._2BUTTON_PRESS:
			if event.button == 1:
			 	treeselection = self.player_treeview.get_selection()
				(model, iter) = treeselection.get_selected()

				if iter != None:
					menu = gtk.Menu()
					menu.show()
					side_item = gtk.MenuItem("Side")
					team_item = gtk.MenuItem("Army")
					ally_item = gtk.MenuItem("Ally")
					colour_item = gtk.MenuItem("Colour")
					kick_item = gtk.MenuItem("Kick")
					menu.append(side_item)
					menu.append(team_item)
					menu.append(ally_item)
					menu.append(colour_item)
					menu.append(kick_item)
					side_item.show()
					team_item.show()
					ally_item.show()
					colour_item.show()
					kick_item.show()
					menu.popup(None, None, None, event.button, event.time)

					colour_item.connect("button_press_event", self.change_color, iter)
					kick_item.connect("button_press_event", self.kick_player, iter)

					# Side -> Sub Menu
					menu_select_side = gtk.Menu()
					menu_select_side.show()
					p = 0
					while p <= ( len(self.old_sides) - 1 ):
						select_side_item = gtk.MenuItem(self.old_sides[p])
						select_side_item.connect("button_press_event", self.change_value, iter, 7, self.old_sides[p])
						select_side_item.show()
						menu_select_side.append(select_side_item)
						p = p + 1
					side_item.set_submenu(menu_select_side)
	
					# Team(Army) -> Sub Menu
					menu_select_team = gtk.Menu()
					menu_select_team.show()
					for i in range(0,GLOBAL.MAX_TEAMS):
						select_team_item = gtk.MenuItem(str(i))
						select_team_item.connect("button_press_event", self.change_value, iter, 2, i)
						select_team_item.show()
						menu_select_team.append(select_team_item)
					team_item.set_submenu(menu_select_team)
	
					# Ally -> Sub Menu
					menu_select_ally = gtk.Menu()
					menu_select_ally.show()
					for i in range(0,GLOBAL.MAX_ALLIES):
						select_ally_item = gtk.MenuItem(str(i))
						select_ally_item.connect("button_press_event", self.change_value, iter, 8, i)
						select_ally_item.show()
						menu_select_ally.append(select_ally_item)
					ally_item.set_submenu(menu_select_ally)

	
					menu_add_bot = gtk.Menu()
					menu_add_bot.show()

		elif event.type == gtk.gdk.BUTTON_PRESS:
		        if event.button == 3:
				# Main Menu
				menu = gtk.Menu()
				menu.show()
				ai_item = gtk.MenuItem("Add AI")
				player_item = gtk.MenuItem("Join Fight")
				menu.append(ai_item)
				menu.append(player_item)
				ai_item.show()
				player_item.show()
				player_item.connect("button_press_event", self.add_player, self.old_sides[0])
				menu.popup(None, None, None, event.button, event.time)

				ai, ai_location = self.find_ai()
				i = 0
				menu_select_ai = gtk.Menu()
				menu_select_ai.show()
				for i in range(0,len(ai)):
					select_ai_item = gtk.MenuItem(ai[i])
					select_ai_item.show()
					menu_select_ai.append(select_ai_item)
					menu_select_ai_side = gtk.Menu()
					menu_select_ai_side.show()
					p = 0
					while p <= ( len(self.old_sides) - 1 ):
						select_ai_side_item = gtk.MenuItem(self.old_sides[p])
						select_ai_side_item.connect("button_press_event", self.add_bot, ai[i], ai_location[i], self.old_sides[p])
						select_ai_side_item.show()
						menu_select_ai_side.append(select_ai_side_item)
						p = p + 1
					select_ai_item.set_submenu(menu_select_ai_side)
					i = i + 2
				ai_item.set_submenu(menu_select_ai)


	def mod_archive_sides(self):
	        treeselection = self.mod_treeview.get_selection()
	        (model, iter) = treeselection.get_selected()
	        if iter == None:
	                iter = self.mod_liststore.get_iter_first()
	
	        checksum = self.mod_liststore.get_value(iter, 1)

		sides = self.mod_index.mod_archive_sides(checksum)
		return sides


	def kick_player(self, widget, event, iter):
		# Removes Player / Bot from Player List
		if iter != None:
			self.player_liststore.remove(iter)


	def add_bot(self, widget, event, ai, ai_location, side):
		# AI Owner
		ai_owner = self.my_player_name

		# Team List
		team_count, ally_count = self.team_ally_count()
		if team_count == -1:
			team = 0
			ally = 0
		else:
			team = team_count[(len(team_count)-1)] + 1

		red, green, blue, pixbuf = self.default_color(team)
		self.player_liststore.append([None, None, team, red, green, blue, pixbuf, side, team, 0, ai, ai_owner, ai_location])


	def add_player(self, widget, event, side):
		# Team List
		team_count, ally_count = self.team_ally_count()
		if team_count == -1:
			team = 0
			ally = 0
		else:
			team = team_count[(len(team_count)-1)] + 1

		red, green, blue, pixbuf = self.default_color(team)
		self.player_liststore.append([None, self.my_player_name, team, red, green, blue, pixbuf, side, team, 0, None, None, None])


	def change_value(self, widget, event, iter, column, value):
	# Changes Value in Player Liststore
		# Add Code to check if column == Team Column
		# If it is update the color image
		if column == 2:
			red, green, blue, pixbuf = self.scan_for_team(value)
			self.player_liststore.set_value(iter, 3, red)
			self.player_liststore.set_value(iter, 4, green)
			self.player_liststore.set_value(iter, 5, blue)
			self.player_liststore.set_value(iter, 6, pixbuf)
		self.player_liststore.set_value(iter, column, value)


	def create_team_color(self, team, red, green, blue):
		team = str(team)
		team_colour_image = Image.new('RGB', [25,25], (red, green, blue))
		team_image = os.path.join(self.profile_dir, (team + '.jpeg'))
		team_colour_image.save(team_image, "JPEG")
		pixbuf = gtk.gdk.pixbuf_new_from_file(team_image)
		self.player_column_3.set_cell_data_func(self.cell3, treeview_team_image)
		return pixbuf


	def default_color(self, team):
		red = GLOBAL.COLOR_TEAM[team][0]
		green = GLOBAL.COLOR_TEAM[team][1]
		blue = GLOBAL.COLOR_TEAM[team][2]
		pixbuf = self.create_team_color(team, red, green, blue)
		return red, green, blue, pixbuf
	

	def change_color(self, widget, event, iter):
		if iter != None:
			red = int(self.player_liststore.get_value(iter, 3))
			green = int(self.player_liststore.get_value(iter, 4))
			blue = int(self.player_liststore.get_value(iter, 5))
			red = ((red * 65535) / 255)
			green = ((green * 65535) / 255)
			blue = ((blue * 65535) / 255)
			color_dialog = color_selector()
			update, red, green, blue = color_dialog.color_selector(red, green, blue)

			if update == True:
				red = ((red * 255) / 65535)
				green = ((green * 255) / 65535)
				blue = ((blue * 255) / 65535)

				team = str(self.player_liststore.get_value(iter,2))
				pixbuf = self.create_team_color(team, red, green, blue)
				team = int(team)
				scan_iter = self.player_liststore.get_iter_first()
				while scan_iter != None:
					if self.player_liststore.get_value(scan_iter,2) == team:
						self.player_liststore.set_value(scan_iter, 3, red)
						self.player_liststore.set_value(scan_iter, 4, green)
						self.player_liststore.set_value(scan_iter, 5, blue)
						self.player_liststore.set_value(scan_iter, 6, pixbuf)
						self.player_column_3.set_cell_data_func(self.cell3, treeview_team_image)
					scan_iter = self.player_liststore.iter_next(scan_iter)


	def player_name_update(self, new_player_name):
        # When user selects Battle
        # This gets active text from Player Name in Configure Options
        # And updates the player entries in Player ListStore
                if new_player_name != self.my_player_name:
                        treeiter = self.player_liststore.get_iter_first()
                        while treeiter != None:
                                if self.player_liststore.get_value(treeiter, 1) == self.my_player_name:
                                        self.player_liststore.set_value(treeiter, 1, new_player_name)
                                        treeiter = None
                                else:
                                        treeiter = self.player_liststore.iter_next(treeiter)
                        self.my_player_name = new_player_name


	def scan_for_team(self, team):
		scan_iter = self.player_liststore.get_iter_first()
		red, green, blue, pixbuf = self.default_color(team)

		while scan_iter != None:
			if self.player_liststore.get_value(scan_iter,2) == team:
				red = self.player_liststore.get_value(scan_iter, 3)
				green = self.player_liststore.get_value(scan_iter, 4)
				blue = self.player_liststore.get_value(scan_iter, 5)
				pixbuf = self.player_liststore.get_value(scan_iter, 6)
				break
			scan_iter = self.player_liststore.iter_next(scan_iter)
		return red, green, blue, pixbuf
	

	def team_ally_list(self):
		# Team List
		team_list = []
		ally_list = []
		treeiter = self.player_liststore.get_iter_first()
		if treeiter != None:
			while treeiter != None:
				team_list.append(self.player_liststore.get_value(treeiter,2))
				ally_list.append(self.player_liststore.get_value(treeiter,8))
				treeiter = self.player_liststore.iter_next(treeiter)
			return team_list, ally_list
		else:
			return -1, -1


	def team_ally_count(self):
		team_list, ally_list = self.team_ally_list()
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
		team_list, ally_list = self.team_ally_list()
		bad_team_list, bad_ally_list = self.team_ally_list()
		team_count, ally_count = self.team_ally_count()
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


	def find_ai(self):
		# Used to locate files with a certain extension in a directory i.e AIs
		ai = []
		ai_location = []

		if self.platform != 'win32':
			extension = '.so'
		else:
			extension = '.dll'
		length = len(extension)
		length = length - ( length + length )

		for i in range (0,len(self.datadirs)):
			scandir = os.path.join(self.datadirs[i],'AI','Bot-libs')
			if os.path.isdir(scandir) == True:
				file_listings = os.listdir(os.path.join(self.datadirs[i],'AI','Bot-libs'))
				for p in range (0,(len(file_listings))):
					if file_listings[p][length:] == extension:
						ai.append(file_listings[p][:length])
						ai_location.append(os.path.join(self.datadirs[i],'AI','Bot-libs',file_listings[p]))
		return ai, ai_location


	def script_create(self, widget, event):
		# Save Config Values
		if self.platform != 'win32':
			self.config.unix_save_spring_options()
		else:
			self.config.windows_save_spring_options()

		# Player Name
#		my_player_name = Config.get_option(self.conf_temp, 'GAME', 'name', 'Player')
		# Player Number
		my_player_number = '0' # TODO -> HardCoded till get Lobby added
		# Number of Players
		num_of_players = '1'   # TODO -> HardCoded till get Lobby added
		# Team Data
		team_count, team_list, bad_team_list, ally_count, ally_list, bad_ally_list = self.team_ally_convert_list()
		if team_count != -1:

				# Map Name
		 	treeselection = self.map_treeview.get_selection()
			(model, iter) = treeselection.get_selected()
			map_name = self.map_liststore.get_value(iter, 0)
	
				# Mod Name
		 	treeselection = self.mod_treeview.get_selection()
			(model, iter) = treeselection.get_selected()
			mod_name = self.mod_index.mod_archive(self.mod_liststore.get_value(iter, 1))
	
	
				# Player / AI info
			ai_location = []
			bonus = []
			sides = []
		
			red = []
			green = []
			blue = []

			spectator = '1'
			treeiter = self.player_liststore.get_iter_first()
	
			while treeiter != None:
				if self.player_liststore.get_value(treeiter, 1) == self.my_player_name:
					my_player_team = str(self.player_liststore.get_value(treeiter,2))
					for i in range(0,len(bad_team_list)):
						if bad_team_list[i] == int(my_player_team):
							my_player_team = str(team_list[i])
					spectator = '0'
	
				sides.append(self.player_liststore.get_value(treeiter, 7))
				bonus.append(self.player_liststore.get_value(treeiter, 9))
				ai_location.append(self.player_liststore.get_value(treeiter, 12))
			
				red.append(self.player_liststore.get_value(treeiter, 3))
				green.append(self.player_liststore.get_value(treeiter, 4))
				blue.append(self.player_liststore.get_value(treeiter, 5))

				treeiter = self.player_liststore.iter_next(treeiter)

	
			# Making Script.txt
			fd_game = open(self.ini.get(self.profile, 'SPRING_SCRIPT'),'w+')
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
			fd_game.write ('NumAllyTeams=' + str(len(ally_count)) + ';\n')

			# Player
			fd_game.write ('[PLAYER0]\n')
			fd_game.write ('{\n')
			fd_game.write ('name=' + self.my_player_name + ';\n')
			fd_game.write ('Spectator='+ spectator + ';\n')
			if spectator == '0':
				fd_game.write ('team=' + my_player_team + ';\n')
			fd_game.write ('}\n')

			# Teams
			for i in range(0,len(team_count)):
				fd_game.write ('[TEAM' + str(i) + ']\n')
				fd_game.write ('{\n')
				fd_game.write ('TeamLeader=0;\n')
				for p in range(0,len(team_list)):
					if team_list[p] == team_count[i]:
						team_color = str(float(red[p]) / 255) + ' ' + str(float(green[p]) / 255) + ' ' + str(float(blue[p]) / 255)
						side = sides[p]
						ally = ally_list[p]
						break
				fd_game.write ('RgbColor=' + team_color + ';\n')
				fd_game.write ('Handicap=' + str(bonus[i]) + ';\n')
	

				fd_game.write ('AllyTeam=' + str(ally) + ';\n')
				fd_game.write ('Side='+ side + ';\n')

				for p in range(0,len(team_list)):
					if team_list[p] == team_count[i]:
						if ai_location[p] != None:
							fd_game.write('AiDLL=' + ai_location[p] + ';\n')
						break
				fd_game.write ('}\n')


			# Ally Teams
			for i in range(0,len(ally_count)):
				fd_game.write ('[ALLYTEAM' + str(ally_count[i]) + ']\n')
				fd_game.write ('{\n')
				fd_game.write ('NumAllies=0;\n') # What the hell is this for??????/
				fd_game.write ('}\n')


			fd_game.write ('}\n')
			fd_game.close()
			self.start()


	def start(self):
		spring = self.ini.get(self.profile, 'SPRING_BINARY')
		script = self.ini.get(self.profile, 'SPRING_SCRIPT')
	
		if self.platform != 'win32':
			if self.gdb_backtrace.get_active() == 1:
				# TODO: need better checks... maybe test for existance of gdb, whether spring has been compiled with debugging info, etc.
	                        gdb_script = self.ini.get(self.profile, 'GDB_SCRIPT_TEMP')
	                        f = file(gdb_script, 'w')
	                        f.write('run %s\nbacktrace\nquit\n' % (script))
	                        f.close()
        	                os.spawnlp(os.P_NOWAIT, 'gdb', 'gdb', spring, '-x', gdb_script, '-n', '-q', '-batch')

		       	elif self.gdb_backtrace.get_active() == 0:
				os.spawnlp(os.P_NOWAIT, spring, spring, script)

		else:
			# TODO Add Windows Code
			print ('TODO Add Windows Code to start spring \path\to\script.txt')
			print ('Look in Battle.py   in  def start(self):')
