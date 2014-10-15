#!/usr/bin/env python

#======================================================
 #            GUI_Battle.py
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
import array

# Custom Modules
import unitsync

import GLOBAL

import Battle
import Config
import Index_Map
import Index_Mod

from GUI_ import combobox_setup, label_create, frame_create, create_page, custom_button


def map_preview_check(widget, event, self, first_run=False):
	if first_run == True:
		map_preview(self)
	elif event.button == 1:
		if event.type == gtk.gdk._2BUTTON_PRESS:
			map_preview(self)


def map_preview(self):
 	treeselection = self.map_treeview.get_selection()
	(model, iter) = treeselection.get_selected()
	map_name = self.map_liststore.get_value(iter, 0)
	map_name = map_name + GLOBAL.MAP_EXTENSION
	map_preview = Config.get_option(self.ini, self.profile, 'SPRING_MAP_PREVIEW', '')
	print ('<<<<<<<<<<<<<>>>>>>>>>>>>>')
	print ('MAP PREVIEW')
	print ('<<<<<<<<<<<<<>>>>>>>>>>>>>')
	unitsync.Init(True,1)
	unitsync.GetMinimap (map_name, GLOBAL.MIP_LEVEL, map_preview)

	map_height = self.map_liststore.get_value(iter, 2)
	map_width = self.map_liststore.get_value(iter, 3)
	if map_height > map_width:
		pixbuf = gtk.gdk.pixbuf_new_from_file(map_preview)
		new_width = ((float(map_width) / map_height) * GLOBAL.PIXEL_SIZE)
		scaled_buf = pixbuf.scale_simple(int(new_width),GLOBAL.PIXEL_SIZE,gtk.gdk.INTERP_BILINEAR)
		self.map_preview.set_from_pixbuf(scaled_buf)
		self.map_preview2.set_from_pixbuf(scaled_buf)
	elif map_height < map_width:
		pixbuf = gtk.gdk.pixbuf_new_from_file(map_preview)
		new_height = ((float(map_height) / map_width) * GLOBAL.PIXEL_SIZE)
		scaled_buf = pixbuf.scale_simple(GLOBAL.PIXEL_SIZE,int(new_height),gtk.gdk.INTERP_BILINEAR)
		self.map_preview.set_from_pixbuf(scaled_buf)
		self.map_preview2.set_from_pixbuf(scaled_buf)
	else:
		self.map_preview.set_from_file(map_preview)
		self.map_preview2.set_from_file(map_preview)
		map_data = unitsync.GetMapInfo(map_name)
		self.map_description.set_text(str(map_data[1]["description"]))
		self.map_description.set_line_wrap(1)




def mod_selection(widget, self):
	sides = Index_Mod.mod_archive_sides(self)
	if self.old_sides != sides:
		treeiter = self.player_liststore.get_iter_first()
		while treeiter != None:
			old_team_side = (self.player_liststore.get_value(treeiter,3))
			for i in range(0,len(self.old_sides)):
				if old_team_side == self.old_sides[i]:
					if (len(sides)) >= i:
						self.player_liststore.set_value(treeiter,3,sides[i])
					else:
						self.player_liststore.set_value(treeiter,3,sides[0])
			treeiter = self.player_liststore.iter_next(treeiter)

	self.old_sides = sides


def player_popup_menu(widget, event, self):

	if event.type == gtk.gdk._2BUTTON_PRESS:
		if event.button == 1:
		 	treeselection = self.player_treeview.get_selection()
			(model, iter) = treeselection.get_selected()

			# TODO
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


			kick_item.connect("button_press_event", Battle.kick_player, self, iter)

			# Side -> Sub Menu
			menu_select_side = gtk.Menu()
			menu_select_side.show()
			p = 0
			while p <= ( len(self.old_sides) - 1 ):
				select_side_item = gtk.MenuItem(self.old_sides[p])
				select_side_item.connect("button_press_event", Battle.change_value, self, iter, 3, self.old_sides[p])
				select_side_item.show()
				menu_select_side.append(select_side_item)
				p = p + 1
			side_item.set_submenu(menu_select_side)

			# Team(Army) -> Sub Menu
			menu_select_team = gtk.Menu()
			menu_select_team.show()
			for i in range(0,GLOBAL.MAX_TEAMS):
				select_team_item = gtk.MenuItem(str(i))
				select_team_item.connect("button_press_event", Battle.change_value, self, iter, 2, i)
				select_team_item.show()
				menu_select_team.append(select_team_item)
			team_item.set_submenu(menu_select_team)

			# Ally -> Sub Menu
			menu_select_ally = gtk.Menu()
			menu_select_ally.show()
			for i in range(0,GLOBAL.MAX_ALLIES):
				select_ally_item = gtk.MenuItem(str(i))
				select_ally_item.connect("button_press_event", Battle.change_value, self, iter, 4, i)
				select_ally_item.show()
				menu_select_ally.append(select_ally_item)
			ally_item.set_submenu(menu_select_ally)



			# Add Code for Sub Menu for Team
				# Add Code for Sub Menu for Ally
				# Add Code for Sub Menu for Colour
				# Add Code for to kick player

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
# TODO temp solution for player_item
#  till code a sub-menu for picking side
			player_item.connect("button_press_event", Battle.add_player, self, self.old_sides[0])
			menu.popup(None, None, None, event.button, event.time)

			ai, ai_location = Battle.find_ai(self.platform, self.datadirs)
			i = 0
			menu_select_ai = gtk.Menu()
			menu_select_ai.show()
			for i in range(0,len(ai)):
				select_ai_item = gtk.MenuItem(ai[i])
				select_ai_item.show()
				menu_select_ai.append(select_ai_item)
				menu_select_ai_side = gtk.Menu()
				menu_select_ai_side.show()
# TODO add folowing code to def
#  So Join Fight can use similar sub Menu for picks Sides
				p = 0
				while p <= ( len(self.old_sides) - 1 ):
					select_ai_side_item = gtk.MenuItem(self.old_sides[p])
					select_ai_side_item.connect("button_press_event", Battle.add_bot, self, ai[i], ai_location[i], self.old_sides[p])
					select_ai_side_item.show()
					menu_select_ai_side.append(select_ai_side_item)
					p = p + 1
				select_ai_item.set_submenu(menu_select_ai_side)
				i = i + 2
			ai_item.set_submenu(menu_select_ai)




def create(self, notebook):
	unitsync.Init(True,1)

	player_name = Config.get_option(self.conf_temp, 'GAME', 'name', 'Player')

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
	player_table.attach(player_window,0,1,0,2, gtk.SHRINK|gtk.FILL|gtk.EXPAND,gtk.SHRINK|gtk.FILL|gtk.EXPAND,10,10)
				# Player ListStore
				  # Ready       = Icon
				  # Name        = String & Icon for Rank
				  # Team        = Number  Need Colour Display Somehow  FIX FIX FIX
				  # Side        = String
				  # Ally        = Number
				  # Bonus	= int
				  # AI          = String
				  # AI Owner    = String
				  # AI Location = String
#	self.player_liststore = gtk.ListStore(gtk.gdk.Pixbuf, str, gtk.gdk.Pixbuf, int, int, str, str, int)
# FIX player_liststore to also use images for rank & side image along with side in text & Ready Icon Status
 	self.player_liststore = gtk.ListStore(str, str, int, str, int, int, str, str, str)
	self.player_treeview = gtk.TreeView(self.player_liststore)
	self.player_column_0 = gtk.TreeViewColumn('Ready')
	self.player_column_1 = gtk.TreeViewColumn('Name')
	self.player_column_2 = gtk.TreeViewColumn('Army')
	self.player_column_3 = gtk.TreeViewColumn('Side')
	self.player_column_4 = gtk.TreeViewColumn('Ally')
	self.player_column_5 = gtk.TreeViewColumn('Bonus')
	self.player_column_6 = gtk.TreeViewColumn('AI')
	self.player_column_7 = gtk.TreeViewColumn('AI Owner')
	self.player_column_8 = gtk.TreeViewColumn('AI Location')

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
#	self.player_treeview.connect('cursor-changed',player_popup_menu, self)
	self.player_treeview.connect('event',player_popup_menu, self)

        # create a CellRenderers to render the data
        self.cell0  = gtk.CellRendererPixbuf()
        self.cell1  = gtk.CellRendererText()
#        self.cell1a = gtk.CellRendererPixbuf()   # TODO Image for Rank
        self.cell2  = gtk.CellRendererText()
        self.cell3  = gtk.CellRendererText()
#        self.cell3a = gtk.CellRendererPixbuf()   # TODO Image for Side
        self.cell4  = gtk.CellRendererText()
        self.cell5  = gtk.CellRendererText()
        self.cell6  = gtk.CellRendererText()
        self.cell7  = gtk.CellRendererText()
        self.cell8  = gtk.CellRendererText()

        # set background color property
		# add code to define background colour if peep = ai ?
        self.cell0.set_property('cell-background', 'white')
        self.cell1.set_property('cell-background', 'white')
#        self.cell1a.set_property('cell-background', 'white')
        self.cell2.set_property('cell-background', 'white')
        self.cell3.set_property('cell-background', 'white')
#        self.cell3a.set_property('cell-background', 'white')
        self.cell4.set_property('cell-background', 'white')
        self.cell5.set_property('cell-background', 'white')
        self.cell6.set_property('cell-background', 'white')
        self.cell7.set_property('cell-background', 'white')
        self.cell8.set_property('cell-background', 'white')

        # add the cells to the columns
	self.player_column_0.pack_start(self.cell0, False)
	self.player_column_1.pack_start(self.cell1, False)
#	self.player_column_1.pack_start(self.cell1a, True)
	self.player_column_2.pack_start(self.cell2, False)
	self.player_column_3.pack_start(self.cell3, False)
#	self.player_column_3a.pack_start(self.cell3, True)
	self.player_column_4.pack_start(self.cell4, False)
	self.player_column_5.pack_start(self.cell5, False)
	self.player_column_6.pack_start(self.cell6, False)
	self.player_column_7.pack_start(self.cell7, False)
	self.player_column_8.pack_start(self.cell8, False)

        # set the cell attributes to the appropriate liststore column
#        self.player_column_0.set_attributes(self.cell0, text=0)
        self.player_column_1.set_attributes(self.cell1, text=1)
        self.player_column_2.set_attributes(self.cell2, text=2)
        self.player_column_3.set_attributes(self.cell3, text=3)
        self.player_column_4.set_attributes(self.cell4, text=4)
        self.player_column_5.set_attributes(self.cell5, text=5)
        self.player_column_6.set_attributes(self.cell6, text=6)
        self.player_column_7.set_attributes(self.cell7, text=7)
        self.player_column_8.set_attributes(self.cell8, text=8)

        # make treeview searchable
        self.player_treeview.set_search_column(0)

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
	self.map_preview2 = gtk.Image()
	self.map_preview2.show()
	player_table.attach(self.map_preview2, 1,2,0,1, gtk.FILL, gtk.FILL,0,0)




        # Options NoteBook
        options_notebook = gtk.Notebook()
        options_notebook.set_tab_pos(gtk.POS_TOP)
        player_table.attach(options_notebook, 1,2,1,2, gtk.FILL,gtk.FILL,10,10)
        options_notebook.show()
		# Frame - Options
	options_frame = create_page(self, options_notebook, 'Options', 350, 50)
				# Table
	options_table = gtk.Table(rows=1, columns=1, homogeneous =False)
	options_table.show()
	options_frame.add(options_table)
					# GameMode
	game_mode_label = label_create("Commander Dies")
	options_table.attach(game_mode_label,0,2,0,1, gtk.FILL,gtk.FILL,10,10)

	self.game_mode = combobox_setup(None, None, None, GLOBAL.GAME_MODES_DEFAULT, GLOBAL.GAME_MODES)
	options_table.attach(self.game_mode, 2,4,0,1, gtk.FILL,gtk.FILL,10,10)
					# Starting Positions
	starting_positions_label = label_create("Starting Position")
	options_table.attach(starting_positions_label,0,2,1,2, gtk.FILL,gtk.FILL,10,10)
	self.starting_positions = combobox_setup(None, None, None, GLOBAL.STARTING_POSITIONS_DEFAULT, GLOBAL.STARTING_POSITIONS)
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
# FIX add default values to GLOBAL.py
	start_metal_value = 2000
	start_metal_adjustment = gtk.Adjustment(start_metal_value, lower=0, upper=12000, step_incr=100, page_incr=1000, page_size=0)
	self.start_metal_spinner = gtk.SpinButton(start_metal_adjustment, 0, 0)
	self.start_metal_spinner.show()
	resources_table.attach(self.start_metal_spinner, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)
					# Start Energy
	start_energy_label = label_create("Energy")
	resources_table.attach(start_energy_label, 2,3,0,1, gtk.FILL,gtk.FILL,10,10)
# FIX add default values to GLOBAL.py
	start_energy_value = 2000
	start_energy_adjustment = gtk.Adjustment(start_energy_value, lower=0, upper=12000, step_incr=100, page_incr=1000, page_size=0)
	self.start_energy_spinner = gtk.SpinButton(start_energy_adjustment, 0, 0)
	self.start_energy_spinner.show()
	resources_table.attach(self.start_energy_spinner, 3,4,0,1, gtk.FILL,gtk.FILL,10,10)
					# Max Units
	max_units_label = label_create("Max Units")
	resources_table.attach(max_units_label, 0,1,1,2, gtk.FILL,gtk.FILL,10,10)
# FIX add default values to GLOBAL.py
	max_units_value = 500
	max_units_adjustment = gtk.Adjustment(max_units_value, lower=0, upper=5000, step_incr=100, page_incr=1000, page_size=0)
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

	self.gdb_backtrace = combobox_setup(None, None, None, GLOBAL.GDB_BACKTRACE_DEFAULT, GLOBAL.GDB_BACKTRACE)
	debug_table.attach(self.gdb_backtrace, 1,2,0,1, gtk.FILL,gtk.FILL,10,10)


		# Notebook - Map / Mod
	map_frame = create_page(self, notebook, 'Map', 100, 75)
					# Table - Map
	map_table = gtk.Table(rows=2, columns=2, homogeneous=False)
	map_table.show()
	map_frame.add(map_table)
						# Map Preview
	self.map_preview = gtk.Image()
	self.map_preview.show()
	map_table.attach(self.map_preview, 0,1,0,1, 0,0,60,10) # FIX
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
	self.map_treeview.connect('button_press_event',map_preview_check, self)

        # create a CellRenderers to render the data
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

        # set background color property
		# add code to define background colour if peep = ai ?
        self.map_cell_1.set_property('cell-background', 'white')
        self.map_cell_2.set_property('cell-background', 'white')
        self.map_cell_3.set_property('cell-background', 'white')
        self.map_cell_4.set_property('cell-background', 'white')
        self.map_cell_5.set_property('cell-background', 'white')
        self.map_cell_6.set_property('cell-background', 'white')
        self.map_cell_7.set_property('cell-background', 'white')
        self.map_cell_8.set_property('cell-background', 'white')
        self.map_cell_9.set_property('cell-background', 'white')
        self.map_cell_10.set_property('cell-background', 'white')

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


	# Read Map Index & Add Map List
	map_checksum_list = Config.list_sections(self.map_index)
	for i in range(0,len(map_checksum_list)):
		count = int(Config.get_option(self.map_index, map_checksum_list[i], 'MAP_COUNT', None))
		for p in range(1,count+1):
			map_data = Index_Map.map_info(self, map_checksum_list[i], p)
			i = str(i)
			self.map_liststore.append([ map_data[("NAME")][:-4],
						map_data[("PLAYERS")],
						map_data[("HEIGHT")],
						map_data[("WIDTH")],
						map_data[("MIN WIND")],
						map_data[("MAX WIND")],
						map_data[("TIDAL STRENGTH")],
						map_data[("EXTRACTOR RADIUS")],
						map_data[("MAX METAL")],
						map_data[("GRAVITY")] ])
			i = int(i)



#FIX Add Code for profiles
# This line is just defaulting mod selection to first iter

	map_treeselection = self.map_treeview.get_selection()
	map_treeselection.select_iter(self.map_liststore.get_iter_first())
	map_preview_check(None, None, self, True)


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
	self.mod_column_1 = gtk.TreeViewColumn('Mod Name')
	self.mod_treeview.append_column(self.mod_column_1)
	mod_window.add(self.mod_treeview)
	self.mod_treeview.show()

#	mod_names = Battle.mod_names(self)
#	for i in range (0,len(mod_names)):
#		self.mod_liststore.append([mod_names[i]])


	# Read Map Index & Add Map List
	mod_checksum_list = Config.list_sections(self.mod_index)
	for i in range(0,len(mod_checksum_list)):
		self.mod_liststore.append([Index_Mod.mod_archive_name(self,mod_checksum_list[i]), mod_checksum_list[i]])



#FIX Add Code for profiles
# This line is just defaulting mod selection to first iter

	mod_treeselection = self.mod_treeview.get_selection()
	mod_treeselection.select_iter(self.mod_liststore.get_iter_first())

	# Add Mouse Click event to mod_treeview
	self.mod_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
	self.mod_treeview.connect('cursor-changed',mod_selection, self)
# FIX ^^

# Add code to get unit sides and apply to self.old_sides
	self.old_sides = Index_Mod.mod_archive_sides(self)

        # create a CellRenderers to render the data
        self.cell1  = gtk.CellRendererText()

        # set background color property
		# add code to define background colour if peep = ai ?
        self.cell1.set_property('cell-background', 'white')

        # add the cells to the columns
	self.mod_column_1.pack_start(self.cell1, False)

        # set the cell attributes to the appropriate liststore column
        self.mod_column_1.set_attributes(self.cell1, text=0)

        # make treeview searchable
        self.mod_treeview.set_search_column(0)



						# Frame - Unit Browser
	unit_browser_frame = frame_create("Unit Browser")
	unit_browser_frame.show()
	mod_table.attach(unit_browser_frame, 0,2,1,2)


		# Frame - Restricted Units
	disabled_units_frame = create_page(self, notebook, 'Restricted Units', 100, 75)
		# Frame - Download Maps/Mods
	download_map_mods_frame = create_page(self, notebook, 'Download Maps / Mods', 100, 75)
					# Table - Download Maps/Mods
	download_map_mods_table = gtk.Table(rows=2, columns=2, homogeneous=False)
	download_map_mods_table.show()
	download_map_mods_frame.add(download_map_mods_table)
