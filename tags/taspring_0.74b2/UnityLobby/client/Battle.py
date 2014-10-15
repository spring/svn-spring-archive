#!/usr/bin/env python

#======================================================
 #            Battle.py
 #
 #  Thurs September 7 11:20 2006
 #  Copyright  2006  Josh Mattila
 #  		          Declan Ireland
 #  Other authors may add their names above!
 #
 #  jm6.linux@gmail.com
 #  deco_ireland2@yahoo.ie
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
import os
import gtk
import thread
import time


# Additional Modules
import Image

# Custom Modules
import GLOBAL

from Misc import create_page, label_create, combobox_setup, frame_create

class Timer:
    # Create Timer Object
    def __init__(self, interval, function, *args, **kwargs):
        self.__lock = thread.allocate_lock()
        self.__interval = interval
        self.__function = function
        self.__args = args
        self.__kwargs = kwargs
        self.__loop = False
        self.__alive = False

    # Start Timer Object
    def start(self):
        self.__lock.acquire()
        if not self.__alive:
            self.__loop = True
            self.__alive = True
            thread.start_new_thread(self.__run, ())
        self.__lock.release()

    # Stop Timer Object
    def stop(self):
        self.__lock.acquire()
        self.__loop = False
        self.__lock.release()

    # Private Thread Function
    def __run(self):
        while self.__loop:
            self.__function(*self.__args, **self.__kwargs)
            time.sleep(self.__interval)
        self.__alive = False


class color_selector:

    def __init__(self, spring_logo_pixbuf):
        self.spring_logo_pixbuf = spring_logo_pixbuf


    def color_changed_cb(self, widget):
        # Get drawingarea colormap
        colormap = self.drawingarea.get_colormap()
        # Get current color
        color = self.colorseldlg.colorsel.get_current_color()
        # Set window color
        self.drawingarea.modify_bg(gtk.STATE_NORMAL, color)


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
            self.colorseldlg.set_icon_list(self.spring_logo_pixbuf)

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


    def __init__(self, status_icon):
    ## ==================================================================================================
    ##  Initialise self variables for battle class.
    ## ==================================================================================================

        self.spring_logo_pixbuf = status_icon.spring_logo_pixbuf

        self.platform = status_icon.platform
        self.datadirs = status_icon.datadirs

        self.ini =  status_icon.ini
        self.ini_file = status_icon.ini_file
        self.profile = status_icon.profile

        self.game_settings = {'metal': 2000, 'energy': 2000, 'max units': 500, 'battle type': 0, 'starting position': GLOBAL.STARTING_POSITIONS_DEFAULT, 'nat':0, 'limited dgun':GLOBAL.LIMITED_DGUN_DEFAULT, 'diminishing MMs':GLOBAL.DIMINISHING_MSS_DEFAULT, 'ghosted Buildings':GLOBAL.GHOSTED_BUILDINGS_DEFAULT, 'rank':0, 'game mode': GLOBAL.GAME_MODES_DEFAULT, 'locked': GLOBAL.LOCK_BATTLE_DEFAULT, 'Spectator Count':0}

        # TODO: Finish Code for Player Name
        self.player_name_offline = None
        self.player_name_online = None

        self.ready_pixbuf = []

        self.map_index_file = status_icon.map_index_file
        self.mod_index_file = status_icon.mod_index_file
        self.map_index = status_icon.map_index
        self.mod_index = status_icon.mod_index

        self.profile_dir = status_icon.profile_dir

        self.unitsync_wrapper = status_icon.unitsync_wrapper

        self.sides_model = gtk.ListStore(str)


        self.host = True
        self.ingame = False
        self.online = False

    def IntegrateWithLobby(self, status_icon):
    ## ==================================================================================================
    ##  Integrates Battle Class with Lobby Class
    ## ==================================================================================================

        self.lobby = status_icon.lobby


    def IntegrateWithOptions(self, status_icon):
    ## ==================================================================================================
    ##  Integrates Battle Class with Options Class
    ## ==================================================================================================

        self.options = status_icon.options


#---GUI Code---#000000#FFFFFF---------------------------------------------------
    def Create(self):
    ## ==================================================================================================
    ##  Creates GUI for Battle
    ## ==================================================================================================

        # Window
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_icon_list(self.spring_logo_pixbuf)
        self.window.set_title("Battle")
        self.window.connect("delete-event", self.Destroy)
        
        self.window.resize(self.ini.getint(self.profile, 'BATTLE_WINDOW_WIDTH'), self.ini.getint(self.profile, 'BATTLE_WINDOW_HEIGHT'))

        # Table
        self.table = gtk.Table(rows=2, columns=2, homogeneous=False)
        self.table.show()
        self.window.add(self.table)

            # ToolBar
        self.ready_button = gtk.ToolButton(gtk.STOCK_NO)
        self.ready_button.connect("clicked", self.PlayerUpdateStatus)
        self.ready_button.show()

        toolbar = gtk.Toolbar()	
        toolbar.insert(self.ready_button, 0)		
        toolbar.set_style(gtk.TOOLBAR_ICONS)
        toolbar.show()
        self.table.attach(toolbar,0,1,0,1, gtk.FILL, gtk.FILL,0,0)

        # Notebook
        notebook = gtk.Notebook()
        notebook.set_tab_pos(gtk.POS_TOP)
        notebook.show()
        self.table.attach(notebook, 0,1,1,2)

        # Frame - Players
        player_frame = create_page(self, notebook, 'Players', 100,75)
            # Table - Player
        player_table = gtk.Table(rows=2, columns=2, homogeneous=False)
        player_table.show()
        player_frame.add(player_table)
                # Player Window (scrolled)
        player_window = gtk.ScrolledWindow()
        player_window.set_border_width(0)
        player_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        player_window.show()

        self.player_vpane = gtk.VPaned()
        self.player_vpane.show()
        player_table.attach(self.player_vpane, 0,1,0,2, xoptions=gtk.FILL|gtk.EXPAND|gtk.SHRINK, yoptions=gtk.FILL|gtk.EXPAND|gtk.SHRINK, xpadding=10, ypadding=10)
        self.player_vpane.pack1(player_window, True, True)

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
#        self.player_liststore = gtk.ListStore(str, str, int, str, str, str, gtk.gdk.Pixbuf, str, int, int, str, str, str)
        self.player_liststore = gtk.ListStore(str, str, str, str, str, str, gtk.gdk.Pixbuf, str, str, str, str, str, str)
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
        self.player_treeview.connect('event',self.PlayerPopupMenu)

        # create a CellRenderers to render the data
        self.cell0  = gtk.CellRendererPixbuf()
        self.cell1  = gtk.CellRendererText()
        self.cell2  = gtk.CellRendererSpin()
        self.cell3  = gtk.CellRendererPixbuf()
        self.cell4  = gtk.CellRendererCombo()
        self.cell5  = gtk.CellRendererSpin()
        self.cell6  = gtk.CellRendererSpin()
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
        self.player_column_1.set_attributes(self.cell1, text=1)
        self.player_column_2.set_attributes(self.cell2, text=2)
        self.player_column_4.set_attributes(self.cell4, text=7)
        self.player_column_5.set_attributes(self.cell5, text=8)
        self.player_column_6.set_attributes(self.cell6, text=9)
        self.player_column_7.set_attributes(self.cell7, text=10)
        self.player_column_8.set_attributes(self.cell8, text=11)

        self.cell2.set_property('editable', True)
        self.cell4.set_property('editable', True)
        self.cell5.set_property('editable', True)
        self.cell6.set_property('editable', True)

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
        player_table.attach(self.map_preview_2, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=0, ypadding=0)

        # Options NoteBook
        options_notebook = gtk.Notebook()
        options_notebook.set_tab_pos(gtk.POS_TOP)
        player_table.attach(options_notebook, 1,2,1,2, xoptions=gtk.FILL, yoptions=gtk.FILL, xpadding=0, ypadding=0)
        options_notebook.show()
            # Frame - Online Options
        online_options_frame = create_page(self, options_notebook, 'Online Options', 350, 50)
                # Table
        online_options_table = gtk.Table(rows=1, columns=1, homogeneous=False)
        online_options_table.show()
        online_options_frame.add(online_options_table)
                    # Description
        description_label = label_create("Description")
        online_options_table.attach(description_label,0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        
        self.description_entry = gtk.Entry(max=0)
        self.description_entry.set_text('UnityLobby Linux Test')
        self.description_entry.show()
        online_options_table.attach(self.description_entry, 1,2,0,1)        
                    # Max Players
        max_players_label = label_create("Max Players")
        online_options_table.attach(max_players_label, 0,1,1,2)      
        
        self.max_players_adjustment = gtk.Adjustment(GLOBAL.MAX_PLAYERS, lower=1, upper=GLOBAL.MAX_PLAYERS, step_incr=1, page_incr=2, page_size=0)
        self.max_players_spinner = gtk.SpinButton(self.max_players_adjustment, 0, 0)        
        self.max_players_spinner.show()
        online_options_table.attach(self.max_players_spinner, 1,2,1,2)      
        
                    # Password
        password_label = label_create("Password")
        password_label.show()
        online_options_table.attach(password_label, 0,1,2,3)

        self.password_entry = gtk.Entry(max=0)
        self.password_entry.show()
        online_options_table.attach(self.password_entry, 1,2,2,3)

                    # Lock Battle
        lock_battle_label = label_create("Lock Battle")
        online_options_table.attach(lock_battle_label, 0,1,3,4)

        self.lock_battle_combobox = combobox_setup(GLOBAL.LOCK_BATTLE, GLOBAL.LOCK_BATTLE_DEFAULT, True)
#        self.lock_battle_combobox.connect("changed", self.UpdateBattleDetails)
        online_options_table.attach(self.lock_battle_combobox, 1,2,3,4)
        
        
                    # Host Battle
        self.host_battle_button = gtk.ToggleButton(label="Host Battle")
        self.host_battle_button_handler_id = self.host_battle_button.connect("toggled", self.NetworkGame)
        self.host_battle_button.set_sensitive(False)       
        self.host_battle_button.show()

        online_options_table.attach(self.host_battle_button, 0,2,4,5, xoptions=gtk.FILL, yoptions=gtk.FILL, xpadding=0, ypadding=0)
        
        
            # Frame - Options
        options_frame = create_page(self, options_notebook, 'Options', 350, 50)
                    # Table
        options_table = gtk.Table(rows=1, columns=1, homogeneous=False)
        options_table.show()
        options_frame.add(options_table)
                        # GameMode
        game_mode_label = label_create("Commander Dies")
        options_table.attach(game_mode_label,0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)

        self.game_mode = combobox_setup(GLOBAL.GAME_MODES, GLOBAL.GAME_MODES_DEFAULT, True)
        self.game_mode.connect("changed", self.UpdateBattleDetails)
        options_table.attach(self.game_mode, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
                        # Limited DGun
        limited_dgun_label = label_create("Commander DGun")
        options_table.attach(limited_dgun_label,0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)

        self.limited_dgun = combobox_setup(GLOBAL.LIMITED_DGUN, GLOBAL.LIMITED_DGUN_DEFAULT, True)
        self.limited_dgun.connect("changed", self.UpdateBattleDetails)
        options_table.attach(self.limited_dgun, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
                        # Starting Positions
        starting_positions_label = label_create("Starting Position")
        options_table.attach(starting_positions_label,0,1,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        self.starting_positions = combobox_setup(GLOBAL.STARTING_POSITIONS, GLOBAL.STARTING_POSITIONS_DEFAULT, True)
        self.starting_positions.connect("changed", self.UpdateBattleDetails)
        options_table.attach(self.starting_positions, 1,2,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
                        # Ghosted Buildings
        ghosted_buildings_label = label_create("Ghosted Buildings")
        options_table.attach(ghosted_buildings_label,0,1,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        self.ghosted_buildings = combobox_setup(GLOBAL.GHOSTED_BUILDINGS, GLOBAL.GHOSTED_BUILDINGS_DEFAULT, True)
        self.ghosted_buildings.connect("changed", self.UpdateBattleDetails)
        options_table.attach(self.ghosted_buildings, 1,2,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)

            # Frame - Resources
        resources_frame = create_page(self, options_notebook, 'Resources', 100, 50)
                    # Table
        resources_table = gtk.Table(rows=1, columns=1, homogeneous =False)
        resources_table.show()
        resources_frame.add(resources_table)
                        # Start Metal
        start_metal_label = label_create("Metal")
        resources_table.attach(start_metal_label, 0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        start_metal_adjustment = gtk.Adjustment(self.game_settings['metal'], lower=0, upper=10000, step_incr=100, page_incr=1000, page_size=0)
        self.start_metal_spinner = gtk.SpinButton(start_metal_adjustment, 0, 0)
        self.start_metal_spinner.connect("value-changed", self.UpdateBattleDetails)
        self.start_metal_spinner.show()
        resources_table.attach(self.start_metal_spinner, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
                        # Start Energy
        start_energy_label = label_create("Energy")
        resources_table.attach(start_energy_label, 0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        start_energy_adjustment = gtk.Adjustment(self.game_settings['energy'], lower=0, upper=10000, step_incr=100, page_incr=1000, page_size=0)
        self.start_energy_spinner = gtk.SpinButton(start_energy_adjustment, 0, 0)
        self.start_energy_spinner.connect("value-changed", self.UpdateBattleDetails)
        self.start_energy_spinner.show()
        resources_table.attach(self.start_energy_spinner, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)

                        # Diminishing MMs
        diminishing_mms_label = label_create("Diminishing MMs")
        resources_table.attach(diminishing_mms_label, 0,1,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        self.diminishing_mms_combobox = combobox_setup(GLOBAL.DIMINISHING_MSS, GLOBAL.DIMINISHING_MSS_DEFAULT, True)
        self.diminishing_mms_combobox.connect("changed", self.UpdateBattleDetails)
        resources_table.attach(self.diminishing_mms_combobox, 1,2,2,3, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)

                        # Max Units
        max_units_label = label_create("Max Units")
        resources_table.attach(max_units_label, 0,1,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        max_units_adjustment = gtk.Adjustment(self.game_settings['max units'], lower=0, upper=5000, step_incr=100, page_incr=1000, page_size=0)
        self.max_units_spinner = gtk.SpinButton(max_units_adjustment, 0, 0)
        self.max_units_spinner.connect("value-changed", self.UpdateBattleDetails)
        self.max_units_spinner.show()
        resources_table.attach(self.max_units_spinner, 1,2,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
            # Frame - Debug
        debug_frame = create_page(self, options_notebook, 'Debug', 100, 50)
                    # Table
        debug_table = gtk.Table(rows=1, columns=1, homogeneous =False)
        debug_table.show()
        debug_frame.add(debug_table)
                        # Gdb Backtrace
        gdb_backtrace_label = label_create("Gdb Backtrace")
        debug_table.attach(gdb_backtrace_label,0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)

        self.gdb_backtrace = combobox_setup(GLOBAL.GDB_BACKTRACE, GLOBAL.GDB_BACKTRACE_DEFAULT, True)
        self.gdb_backtrace.connect("changed", self.UpdateBattleDetails)
        debug_table.attach(self.gdb_backtrace, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)


            # Notebook - Map / Mod
        map_frame = create_page(self, notebook, 'Map', 100, 75)
                # Table - Map
        map_table = gtk.Table(rows=2, columns=2, homogeneous=False)
        map_table.show()
        map_frame.add(map_table)
                    # Map Preview
        self.map_preview_1 = gtk.Image()
        self.map_preview_1.show()
        map_table.attach(self.map_preview_1, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=0, ypadding=0)
                        # Map Description
        self.map_description = label_create("")
        self.map_description.set_line_wrap(1)
        map_table.attach(self.map_description, 1,2,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=0, ypadding=0)
                            # Map

                    # Map Window (scrolled)
        map_window = gtk.ScrolledWindow()
        map_window.set_border_width(10)
        map_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        map_window.show()
        map_table.attach(map_window, 0,1,0,2)
                        # Map ListStore
                          # 0  Name             = str
                          # 1  Players          = int
                          # 2  Height           = int
                          # 3  Width            = int
                          # 4  Min Wind         = int
                          # 5  Max Wind         = int
                          # 6  Tidal            = int
                          # 7  Extractor Radius = int
                          # 8  Max Metal        = str
                          # 9  Gravity          = str
                          # 10 Hashcode         = str
        self.map_liststore = gtk.ListStore(str, int, int, int, int, int, int, int, str, str, str)
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

        self.map_selection = self.map_treeview.get_selection()
        self.map_selection.connect('changed', self.MapPreview)

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
        self.map_column_10.set_attributes(self.map_cell_10, text=9)

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


        mod_selection = self.mod_treeview.get_selection()
        mod_selection.select_iter(self.mod_liststore.get_iter_first())
        mod_selection.connect('changed', self.ModSelection)

        self.sides = self.ModArchiveSides()
        self.ModSelection()

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
        
        self.AddPlayer(self.sides[0])


    def Show(self):
    ## ==================================================================================================
    ##  Function to show window. Called from outside of Battle class.
    ## ==================================================================================================
        
        self.window.show()


    def Hide(self):
    ## ==================================================================================================
    ##  Function to hide window. Called from outside of Battle class.
    ## ==================================================================================================
        if self.host_battle_button.get_active() == True:
            self.host_battle_button.handler_block(self.host_battle_button_handler_id)       
            self.host_battle_button.set_active(False)
            self.host_battle_button.handler_unblock(self.host_battle_button_handler_id)            
            self.AbortNetworkGame()             
        width, height = self.window.get_size()
        
        self.ini.set(self.profile, 'BATTLE_WINDOW_WIDTH', width)
        self.ini.set(self.profile, 'BATTLE_WINDOW_HEIGHT', height)
        self.ini.write(open(self.ini_file, "w+"))
        self.ini.read(self.ini_file)
                
        self.window.hide()
        

    def Destroy(self, window, event):
    ## ==================================================================================================
    ##  Function called when recieving the kill signal which hides the window instead.
    ## ==================================================================================================
        
        self.Hide()
        return True


    def MapPreview(self, map_selection):
    ## ==================================================================================================
    ##  Generates Map Preview of currently selected map & updates map previews.
    ## ==================================================================================================

        model, paths = map_selection.get_selected_rows()
        if paths:
            iter = self.map_liststore.get_iter(paths[0])
            map_name = self.map_liststore.get_value(iter, 0)
            map_name = map_name + GLOBAL.MAP_EXTENSION
            self.UpdateBattleInfo(map_selection)            

            map_preview = self.ini.get(self.profile, 'SPRING_MAP_PREVIEW')

            self.unitsync_wrapper.create_map_preview(map_name, GLOBAL.MIP_LEVEL, map_preview)

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
                self.map_description.set_text(str(self.unitsync_wrapper.get_map_info(map_name)[1]["description"]))
                self.map_description.set_line_wrap(1)


    def ModSelection(self, widget=None):
    ## ==================================================================================================
    ##  Gets mod info from currently selected Mod & updates sides info if needed.
    ## ==================================================================================================

        sides = self.ModArchiveSides()

        self.sides_model.clear()
        for side in sides:
            self.sides_model.append([side])


        if self.sides != sides:
            iter = self.player_liststore.get_iter_first()
            while iter != None:
                old_team_side = (self.player_liststore.get_value(iter, 7))
                for i in range(0,len(self.sides)):
                    if old_team_side == self.sides[i]:
                        if (len(sides)) >= i:
                            self.player_liststore.set_value(iter, 7, sides[i])
                        else:
                            self.player_liststore.set_value(iter, 7, sides[0])
                iter = self.player_liststore.iter_next(iter)
        self.sides = sides


    def PlayerPopupMenu(self, widget, event):
    ## ==================================================================================================
    ##  Player Popup Menu for Player Battle List.
    ## ==================================================================================================
        
        if event.type == gtk.gdk._2BUTTON_PRESS:
            if event.button == 1:
                treeselection = self.player_treeview.get_selection()
                (model, iter) = treeselection.get_selected()

                if iter != None:
                    # Menu
                    menu = gtk.Menu()

                        # Color
                    colour_item = gtk.MenuItem("Colour")
                    colour_item.connect("button_press_event", self.ChangeColor, iter)                    
                    colour_item.show()
                    menu.append(colour_item)

                        # Kick
                    kick_item = gtk.MenuItem("Kick")
                    kick_item.connect("button_press_event", self.KickPlayer, iter)                    
                    kick_item.show()
                       
                        
                        # Switch to
                    switch_to_item = gtk.MenuItem("Switch to ")
                    switch_to_item.show()
                    menu.append(switch_to_item)
                    menu.append(kick_item) # Like to keep menu in order
                            # Sub Menu
                    menu_switch_to_item = gtk.Menu()
                    menu_switch_to_item.show()
                    switch_to_item.set_submenu(menu_switch_to_item)
                                # Switch to Player
                    switch_to_player_item = gtk.MenuItem("Player")
                    switch_to_player_item.connect("button_press_event", self.SwitchToPlayer, iter)
                    switch_to_player_item.show()
                    menu_switch_to_item.append(switch_to_player_item)
                                # Switch to Spectator
                    switch_to_spectator_item = gtk.MenuItem("Spectator")
                    switch_to_spectator_item.connect("button_press_event", self.SwitchToSpectator, iter)                    
                    switch_to_spectator_item.show()
                    menu_switch_to_item.append(switch_to_spectator_item)
                    
                    
                    # GENERAL
                    if self.player_liststore.get_value(iter, 1) == None:
                        # AI
                        switch_to_spectator_item.set_sensitive(False)
                        switch_to_player_item.set_sensitive(False)                                                 
                    elif self.player_liststore.get_value(iter, 2) == None:
                        # Spectator
                        switch_to_spectator_item.set_sensitive(False)    
                    else:
                        # Player
                        if self.player_liststore.get_value(iter, 1) == self.player_name_offline:
                            kick_item.set_sensitive(False)
                        switch_to_player_item.set_sensitive(False)                        
                        

                    # ONLINE & NOT HOST
                    if self.host == False:
                        
                        kick_item.set_sensitive(False)

                        if self.player_liststore.get_value(iter, 1) != self.player_name_online:
                            colour_item.set_sensitive(False)
                            menu_switch_to_item.set_sensitive(False)                           
                            switch_to_player_item.set_sensitive(False)
                            switch_to_spectator_item.set_sensitive(False)
                    
                    # Show Popup Menu
                    menu.popup(None, None, None, event.button, event.time)
                    menu.show()


        elif event.type == gtk.gdk.BUTTON_PRESS:
            if event.button == 3:
                # Main Menu
                menu = gtk.Menu()

                ai_item = gtk.MenuItem("Add AI")
                ai_item.show()

                menu.append(ai_item)
               
                ai, ai_location = self.FindAI()
                menu_select_ai = gtk.Menu()
                menu_select_ai.show()
                for i in range(0,len(ai)):
                    select_ai_item = gtk.MenuItem(ai[i])
                    select_ai_item.show()
                    menu_select_ai.append(select_ai_item)
                    menu_select_ai_side = gtk.Menu()
                    menu_select_ai_side.show()
                    p = 0
                    while p <= ( len(self.sides) - 1 ):
                        select_ai_side_item = gtk.MenuItem(self.sides[p])
                        select_ai_side_item.connect("button_press_event", self.AddBot, ai[i], ai_location[i], self.sides[p])
                        select_ai_side_item.show()
                        menu_select_ai_side.append(select_ai_side_item)
                        p = p + 1
                    select_ai_item.set_submenu(menu_select_ai_side)
                    i = i + 2
                ai_item.set_submenu(menu_select_ai)

                menu.popup(None, None, None, event.button, event.time)
                menu.show() 
                


    def ModArchiveSides(self):
    ## ==================================================================================================
    ##  Gets Selected Mod & Returns Mod Side(s).
    ## ==================================================================================================

        treeselection = self.mod_treeview.get_selection()
        (model, iter) = treeselection.get_selected()
        if iter == None:
                iter = self.mod_liststore.get_iter_first()

        checksum = self.mod_liststore.get_value(iter, 1)

        sides = self.mod_index.mod_archive_sides(checksum)
        return sides

#---Battle Player List Code---#000000#FFFFFF------------------------------------
    def AddBot(self, widget, event, ai, ai_location, side):
    ## ==================================================================================================
    ##  Add New Bot with default values in Battle Player List.
    ## ==================================================================================================

        # AI Owner
        if self.online == True:
            ai_owner = self.player_name_online
        else:
            ai_owner = self.player_name_offline        

        # Team List
        team_count, ally_count = self.TeamAllyCount()
        if team_count == -1:
            team = 0
            ally = 0
        else:
            team = team_count[(len(team_count)-1)] + 1
            ally = ally_count[(len(ally_count)-1)] + 1            

        red, green, blue, pixbuf = self.DefaultColor(team)
        self.player_liststore.append([gtk.STOCK_NO, None, team, red, green, blue, pixbuf, side, ally, 0, ai, ai_owner, ai_location])


        self.player_column_0.set_cell_data_func(self.cell0, self.treeview_ready_image)
        self.player_column_2.set_cell_data_func(self.cell2, self.treeview_army_spinner)
        self.player_column_4.set_cell_data_func(self.cell4, self.treeview_side_combobox)
        self.player_column_5.set_cell_data_func(self.cell5, self.treeview_ally_spinner)
        self.player_column_6.set_cell_data_func(self.cell6, self.treeview_bonus_spinner)


    def AddPlayer(self, side):
    ## ==================================================================================================
    ##  Add MyPlayer with default values in Battle Player List.
    ## ==================================================================================================

        if self.online == True:
            my_player_name = self.player_name_online
        else:
            my_player_name = self.player_name_offline
            
        team_count, ally_count = self.TeamAllyCount()
        if team_count == -1:
            team = 0
            ally = 0
        else:
            team = team_count[(len(team_count)-1)] + 1
            ally = ally_count[(len(ally_count)-1)] + 1                        

        red, green, blue, pixbuf = self.DefaultColor(team)
        
        self.player_liststore.append([gtk.STOCK_NO, my_player_name, team, red, green, blue, pixbuf, side, team, 0, None, None, None])

        self.player_column_0.set_cell_data_func(self.cell0, self.treeview_ready_image)
        self.player_column_2.set_cell_data_func(self.cell2, self.treeview_army_spinner)
        self.player_column_5.set_cell_data_func(self.cell5, self.treeview_ally_spinner)
        self.player_column_6.set_cell_data_func(self.cell6, self.treeview_bonus_spinner)


    def SwitchToPlayer(self, widget, event, iter):

        team_count, ally_count = self.TeamAllyCount()
        if team_count == -1:
            team = 0
            ally = 0
        else:
            team = team_count[(len(team_count)-1)] + 1
            ally = ally_count[(len(ally_count)-1)] + 1
        
        red, green, blue, pixbuf = self.DefaultColor(team)
        
        # TODO: Fix Side !!!
            
        # Set Values
        self.player_liststore.set_value(iter, 2, team)
        self.player_liststore.set_value(iter, 3, red)        
        self.player_liststore.set_value(iter, 4, green)
        self.player_liststore.set_value(iter, 5, blue)        
        self.player_liststore.set_value(iter, 6, pixbuf)        
        self.player_liststore.set_value(iter, 7, self.sides[0])        
        self.player_liststore.set_value(iter, 8, ally)        
        self.player_liststore.set_value(iter, 9, '0')        
        
        self.game_settings['Spectator Count'] = self.game_settings['Spectator Count'] - 1

    def SwitchToSpectator(self, widget, event, iter):

        self.player_liststore.set_value(iter, 2, None)
        self.player_liststore.set_value(iter, 3, None)        
        self.player_liststore.set_value(iter, 4, None)
        self.player_liststore.set_value(iter, 5, None)        
        self.player_liststore.set_value(iter, 6, None)        
        self.player_liststore.set_value(iter, 7, None)        
        self.player_liststore.set_value(iter, 8, None)        
        self.player_liststore.set_value(iter, 9, None)
        
        self.game_settings['Spectator Count'] = self.game_settings['Spectator Count'] + 1
             

    def KickPlayer(self, widget, event, iter):
    ## ==================================================================================================
    ##  Removes Player / Bot from Battle Player List.
    ## ==================================================================================================

        # Removes Player / Bot from Player List
        if iter != None:
            self.player_liststore.remove(iter)


    def CreateTeamColor(self, team, red, green, blue):
    ## ==================================================================================================
    ##  Creates Team Color file & returns the pixbuf.
    ## ==================================================================================================
        
        team = str(team)
        team_colour_image = Image.new('RGB', [25,25], (red, green, blue))
        team_image = os.path.join(self.profile_dir, (team + '.jpeg'))
        team_colour_image.save(team_image, "JPEG")
        pixbuf = gtk.gdk.pixbuf_new_from_file(team_image)
        self.player_column_3.set_cell_data_func(self.cell3, self.treeview_team_image)
        return pixbuf


    def DefaultColor(self, team):
    ## ==================================================================================================
    ##  Gets Default Color for team from GLOBAL.
    ## ==================================================================================================
        
        red = GLOBAL.COLOR_TEAM[team][0]
        green = GLOBAL.COLOR_TEAM[team][1]
        blue = GLOBAL.COLOR_TEAM[team][2]
        pixbuf = self.CreateTeamColor(team, red, green, blue)
        return red, green, blue, pixbuf


    def ChangeColor(self, widget, event, iter):
    ## ==================================================================================================
    ##  Calls on Color Selector class.
    ##   And Updates Player Color in Battle Player List if needed.
    ## ==================================================================================================
        
        if iter != None:
            red = int(self.player_liststore.get_value(iter, 3))
            green = int(self.player_liststore.get_value(iter, 4))
            blue = int(self.player_liststore.get_value(iter, 5))
            red = ((red * 65535) / 255)
            green = ((green * 65535) / 255)
            blue = ((blue * 65535) / 255)
            color_dialog = color_selector(self.spring_logo_pixbuf)
            update, red, green, blue = color_dialog.color_selector(red, green, blue)

            if update == True:
                red = ((red * 255) / 65535)
                green = ((green * 255) / 65535)
                blue = ((blue * 255) / 65535)

                team = str(self.player_liststore.get_value(iter,2))
                pixbuf = self.CreateTeamColor(team, red, green, blue)

                
                scan_iter = self.player_liststore.get_iter_first()
                while scan_iter != None:
                    if self.player_liststore.get_value(scan_iter,2) == team:
                        self.player_liststore.set_value(scan_iter, 3, str(red))
                        self.player_liststore.set_value(scan_iter, 4, str(green))
                        self.player_liststore.set_value(scan_iter, 5, str(blue))
                        self.player_liststore.set_value(scan_iter, 6, pixbuf)
                        self.player_column_3.set_cell_data_func(self.cell3, self.treeview_team_image)
                    scan_iter = self.player_liststore.iter_next(scan_iter)


    def GetTeamColor(self, team, ignore_iter=None):
    ## ==================================================================================================
    ##  Searchs self.player_liststore for First Team == team.
    ##   Returns Team red green blue pixbuf values
    ##    If iter is passed, ignores if finds team with the passed iter
    ## ==================================================================================================

        red, green, blue, pixbuf = self.DefaultColor(team)

        iter = self.player_liststore.get_iter_first()
        while iter != None:
            if iter != ignore_iter:
                if self.player_liststore.get_value(iter,2) == team:
                    red = self.player_liststore.get_value(iter, 3)
                    green = self.player_liststore.get_value(iter, 4)
                    blue = self.player_liststore.get_value(iter, 5)
                    pixbuf = self.player_liststore.get_value(iter, 6)
                    break
            iter = self.player_liststore.iter_next(iter)
        return red, green, blue, pixbuf

    
    def treeview_army_spinner(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Various functions to update images in Battle Player List.
    ## ==================================================================================================
    
        value = model.get_value(iter, 2)
        if value == None:
            cell.set_property('adjustment', None)
            cell.set_property('digits', 0)
        else:
            adjustment =  gtk.Adjustment(float(value), lower=0, upper=15, step_incr=1, page_incr=1, page_size=1)
            cell.set_property('adjustment', adjustment)
            cell.set_property('digits', 0)
            cell.connect("editing-started", self.UpdatePlayerArmy)
        return


    def treeview_ally_spinner(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Various functions to update images in Battle Player List.
    ## ==================================================================================================

        value = model.get_value(iter, 8)
        if value == None:
            cell.set_property('adjustment', None)
            cell.set_property('digits', 0)
        else:
            adjustment =  gtk.Adjustment(float(value), lower=0, upper=15, step_incr=1, page_incr=1, page_size=1)
            cell.set_property('adjustment', adjustment)
            cell.set_property('digits', 0)
            cell.connect("editing-started", self.UpdatePlayerAlly)
        return


    def treeview_bonus_spinner(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Various functions to update images in Battle Player List.
    ## ==================================================================================================
        
        value = model.get_value(iter, 9)
        if value == None:
            cell.set_property('adjustment', None)
            cell.set_property('digits', 0)
        else:
            adjustment =  gtk.Adjustment(float(value), lower=0, upper=100, step_incr=1, page_incr=1, page_size=1)
            cell.set_property('adjustment', adjustment)
            cell.set_property('digits', 0)
            cell.connect("editing-started", self.UpdatePlayerBonus)
        return


    def treeview_side_combobox(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Various functions to update images in Battle Player List.
    ## ==================================================================================================
        
        value = model.get_value(iter, 7)
        if value == None:
            pass
        else:
            cell.set_property("text-column", 0)
            cell.set_property("editable", True)
            cell.set_property("has-entry", False)
            cell.set_property("model", self.sides_model)
            cell.connect("editing-started", self.UpdatePlayerSide)
        return


    def treeview_team_image(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Various functions to update images in Battle Player List.
    ## ==================================================================================================

        pixbuf = model.get_value(iter, 6)
        cell.set_property('pixbuf', pixbuf)
        return


    def treeview_ready_image(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Various functions to update images in Battle Player List.
    ## ==================================================================================================
        
            stock = model.get_value(iter, 0)
            ready_image = self.player_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
            cell.set_property('pixbuf', ready_image)
            return


    def UpdatePlayerArmy(self, cell, editable, path):
        iter = self.player_liststore.get_iter(path)
        value = self.player_liststore.get_value(iter, 2)          
        if value != None:           
            editable.connect("editing-done", self.UpdatePlayerListstoreValue, path, 2)


    def UpdatePlayerSide(self, cell, editable, path):
        iter = self.player_liststore.get_iter(path)
        value = self.player_liststore.get_value(iter, 7)          
        if value != None:
            editable.connect("editing-done", self.UpdatePlayerListstoreValue, path, 7)


    def UpdatePlayerAlly(self, cell, editable, path):
        iter = self.player_liststore.get_iter(path)
        value = self.player_liststore.get_value(iter, 8)          
        if value != None:
            editable.connect("editing-done", self.UpdatePlayerListstoreValue, path, 8)


    def UpdatePlayerBonus(self, cell, editable, path):
        iter = self.player_liststore.get_iter(path)
        value = self.player_liststore.get_value(iter, 9)         
        if value != None:
            editable.connect("editing-done", self.UpdatePlayerListstoreValue, path, 9)


    def UpdatePlayerListstoreValue(self, editable, path, column):
    ## ==================================================================================================
    ##  Updates Player Liststore Value
    ##   With exception if column = 2. Calls on .....
    ## ==================================================================================================

        iter = self.player_liststore.get_iter(path)

        if column == 2: # Team Column
            value = int(editable.get_value())
            # If value == None then Player is a Spectator
            if value == None:
                pass
                self.player_liststore.set_value(iter, 2, None)
                self.player_liststore.set_value(iter, 3, None)
                self.player_liststore.set_value(iter, 4, None)
                self.player_liststore.set_value(iter, 5, None)
                self.player_liststore.set_value(iter, 6, None)                
                self.player_liststore.set_value(iter, 7, None)                 
                self.player_liststore.set_value(iter, 8, None)
                self.player_liststore.set_value(iter, 9, None)
            else:
                red, green, blue, pixbuf = self.GetTeamColor(value, iter)
                self.player_liststore.set_value(iter, 2, value)
                self.player_liststore.set_value(iter, 3, red)
                self.player_liststore.set_value(iter, 4, green)
                self.player_liststore.set_value(iter, 5, blue)
                self.player_liststore.set_value(iter, 6, pixbuf)
                # TODO: Add Code to check if ally == -1 aswell
        elif column == 7:
            value = editable.get_active_text()
            self.player_liststore.set_value(iter, column, value)
        elif column == 8:
            value = int(editable.get_value())
            self.player_liststore.set_value(iter, column, value)
        elif column == 9:
            value = int(editable.get_value())
            self.player_liststore.set_value(iter, column, value)


#---Update Player Name Code---#000000#FFFFFF------------------------------------
    def UpdatePlayerName(self):
    ## ==================================================================================================
    ##  Called to Update Player Name when switching from online / offline games
    ## ==================================================================================================

        iter = self.player_liststore.get_iter_first()
        
        if self.online == False:
            while iter != None:
                # TODO: Add Code to update Bot Owners
                if self.player_liststore.get_value(iter, 1) == self.player_name_online:
                    self.player_liststore.set_value(iter, 1, self.player_name_offline)
                elif self.player_liststore.get_value(iter, 11) == self.player_name_online:
                    self.player_liststore.set_value(iter, 11, self.player_name_offline)
                else:
                    # TODO: May need to add code to remove other players !!!
                    pass
                iter = self.player_liststore.iter_next(iter)              
        elif self.online == True:
            while iter != None:
                if self.player_liststore.get_value(iter, 1) == self.player_name_offline:
                    self.player_liststore.set_value(iter, 1, self.player_name_online)
                elif self.player_liststore.get_value(iter, 11) == self.player_name_offline:
                    self.player_liststore.set_value(iter, 11, self.player_name_online)
                else:
                    # TODO: May need to add code to remove other players !!!
                    pass
                iter = self.player_liststore.iter_next(iter)


    def UpdatePlayerNameOffline(self):
    ## ==================================================================================================
    ##  Called to Update Player Name & Bot Owner when changing offline default name
    ##   Also updates Battle Player List if its a offline game
    ## ==================================================================================================

        iter = self.player_liststore.get_iter_first()
        
        if self.online == False:
            while iter != None:
                if self.player_liststore.get_value(iter, 1) != None:
                    self.player_liststore.set_value(iter, 1, self.player_name_offline)
                elif self.player_liststore.get_value(iter, 11) != None:
                    self.player_liststore.set_value(iter, 11, self.player_name_offline)
                iter = self.player_liststore.iter_next(iter)                    


    def PlayerUpdateStatus(self, toolbutton, ready=None):
    ## ==================================================================================================
    ##  Function which searchs self.player_liststore for player name == player_name. 
    ##   If found updates player ready status. Also updates player's bots ready status.
    ## ==================================================================================================
        # TODO: Add Code to update MYBATTLESTATUS
        
        if self.online == True:
            player_name = self.player_name_online
        else:
            player_name = self.player_name_offline
        
        if ready == None:
            if self.ready_button.get_stock_id() == gtk.STOCK_YES:
                self.ready_button.set_stock_id(gtk.STOCK_NO)
                ready = False
            else:
                self.ready_button.set_stock_id(gtk.STOCK_YES)
                ready = True

        iter = self.player_liststore.get_iter_first()
        while iter != None:
            if self.player_liststore.get_value(iter, 1) == player_name or self.player_liststore.get_value(iter, 11) == player_name:
                if ready == False:
                    self.player_liststore.set_value(iter, 0, gtk.STOCK_NO)
                else:
                    self.player_liststore.set_value(iter, 0, gtk.STOCK_YES)
            iter = self.player_liststore.iter_next(iter)
        self.player_column_0.set_cell_data_func(self.cell0, self.treeview_ready_image)

        iter = self.player_liststore.get_iter_first()
        while iter != None:
            if self.player_liststore.get_value(iter,0) == gtk.STOCK_NO:
                break
            iter = self.player_liststore.iter_next(iter)
        if iter == None:
            self.ScriptCreate()

#---Battle Online Code---#000000#FFFFFF-----------------------------------------
    def NetworkGame(self, widget):
        if widget.get_active() == True:
            self.HostNetworkGame()
        else:
            self.AbortNetworkGame()


    def HostNetworkGame(self):
        # TODO: Add Code to setup NAT selection in Options

        self.host_battle_button.set_sensitive(False)  
        self.host_battle_button.set_label('Please Wait')

        self.host = True
        self.online = True
        self.ingame = False

        self.UpdatePlayerName()                       
        self.OptionsSenstive()
               
        treeselection = self.mod_treeview.get_selection()
        (model, iter) = treeselection.get_selected()
        if iter == None:
                iter = self.mod_liststore.get_iter_first()
        self.game_settings['mod hashcode'] = self.mod_liststore.get_value(iter, 1)
        self.game_settings['mod name'] = self.mod_liststore.get_value(iter, 0)

        self.game_settings['description'] = self.description_entry.get_text()
        self.game_settings['max_players'] = int(self.max_players_adjustment.get_value())
        password = self.password_entry.get_text()
        if password == '':
            password = '*'
        args = str(self.game_settings['battle type']) + ' ' + str(self.game_settings['nat']) + ' ' + str(password) + ' ' + str(self.lobby.spring_udp_port) + ' ' + str(self.game_settings['max_players'])  + ' ' + str(self.game_settings['metal']) + ' ' + str(self.game_settings['energy']) + ' ' + str(self.game_settings['max units']) + ' ' + str(self.game_settings['starting position']) + ' ' + str(self.game_settings['game mode']) + ' ' + str(self.game_settings['limited dgun']) + ' ' + str(self.game_settings['diminishing MMs']) + ' ' + str(self.game_settings['ghosted Buildings']) + ' ' + self.game_settings['mod hashcode'] + ' ' + str(self.game_settings['rank']) + ' ' + self.game_settings['map hashcode'] + ' ' + self.game_settings['map'] + "\t" + self.game_settings['description'] + "\t" + self.game_settings['mod name']

        self.lobby.openbattle(args, True)


    def HostNetworkGameSucess(self):

        self.battle_vpane = self.lobby.CreateBattleChat()
        self.battle_vpane.show()
        self.player_vpane.pack2(self.battle_vpane, True, True)

        self.host_battle_button.set_label('Leave Battle')
        self.host_battle_button.set_sensitive(True)
        
        # Check if UPDATEBATTLEINFO is needed to be sent
        if (self.game_settings['Spectator Count'] != 0) or (self.lock_battle_combobox.get_active() != 0):
            self.UpdateBattleInfo(None)

        
        
    def JoinNetworkGame(self):

        self.host = False
        self.online = True
        self.ingame = False

        self.UpdatePlayerName()
        self.OptionsSenstive()          
                
        self.battle_vpane = self.lobby.CreateBattleChat()
        self.battle_vpane.show()
        self.player_vpane.pack2(self.battle_vpane, True, True)      

        self.host_battle_button.handler_block(self.host_battle_button_handler_id)               
        self.host_battle_button.set_label('Leave Battle')    
        self.host_battle_button.set_active(True)
        self.host_battle_button.set_sensitive(True)    
        self.host_battle_button.handler_unblock(self.host_battle_button_handler_id)                                          
        
        
    def AbortNetworkGame(self):
        
        self.host = True
        self.online = False
        self.ingame = False
        
        self.UpdatePlayerName()
        self.OptionsSenstive()
                      
        self.lobby.leavebattle()
        self.battle_vpane.destroy()        
        
        self.host_battle_button.set_label('Host Battle')  
        self.host_battle_button.set_sensitive(True)                        


    def OptionsSenstive(self):
        
        # InGame
        if self.ingame == True:
            self.ready_button.set_sensitive(False)
            self.mod_treeview.set_sensitive(False)
          
            self.game_mode.set_sensitive(False)
            self.limited_dgun.set_sensitive(False)            
            self.starting_positions.set_sensitive(False)
            self.ghosted_buildings.set_sensitive(False)
            self.start_metal_spinner.set_sensitive(False)
            self.start_energy_spinner.set_sensitive(False)
            self.diminishing_mms_combobox.set_sensitive(False)
            self.max_units_spinner.set_sensitive(False)
            self.map_treeview.set_sensitive(False)                   
            
            self.gdb_backtrace.set_sensitive(False)
                        
            self.host_battle_button.set_sensitive(False)   

        # OutofGame
        elif self.ingame == False:
            
            # Host
            if self.host == True:
                
                # Online
                if self.online == True:
                    self.ready_button.set_sensitive(True)
                    self.mod_treeview.set_sensitive(False)
          
                    self.game_mode.set_sensitive(True)
                    self.limited_dgun.set_sensitive(True)            
                    self.starting_positions.set_sensitive(True)
                    self.ghosted_buildings.set_sensitive(True)
                    self.start_metal_spinner.set_sensitive(True)
                    self.start_energy_spinner.set_sensitive(True)
                    self.diminishing_mms_combobox.set_sensitive(True)
                    self.max_units_spinner.set_sensitive(True)
                    self.map_treeview.set_sensitive(True)                   
            
                    self.gdb_backtrace.set_sensitive(True)
                                
                    self.host_battle_button.set_sensitive(True)                      
                
                # Offline
                elif self.online == False:
                    self.ready_button.set_sensitive(True)
                    self.mod_treeview.set_sensitive(True)
          
                    self.game_mode.set_sensitive(True)
                    self.limited_dgun.set_sensitive(True)            
                    self.starting_positions.set_sensitive(True)
                    self.ghosted_buildings.set_sensitive(True)
                    self.start_metal_spinner.set_sensitive(True)
                    self.start_energy_spinner.set_sensitive(True)
                    self.diminishing_mms_combobox.set_sensitive(True)
                    self.max_units_spinner.set_sensitive(True)
                    self.map_treeview.set_sensitive(True)                   
            
                    self.gdb_backtrace.set_sensitive(True)            
                    self.host_battle_button.set_sensitive(True)                      
            
            # Non-Host & Online
            elif self.host == False:
                self.ready_button.set_sensitive(True)
                self.mod_treeview.set_sensitive(False)
          
                self.game_mode.set_sensitive(False)
                self.limited_dgun.set_sensitive(False)            
                self.starting_positions.set_sensitive(False)
                self.ghosted_buildings.set_sensitive(False)
                self.start_metal_spinner.set_sensitive(False)
                self.start_energy_spinner.set_sensitive(False)
                self.diminishing_mms_combobox.set_sensitive(False)
                self.max_units_spinner.set_sensitive(False)
                self.map_treeview.set_sensitive(False)                   
            
                self.gdb_backtrace.set_sensitive(True)            
                self.host_battle_button.set_sensitive(True)                 


    def UpdateNetworkGame(self, metal, energy, units, starting, mode, dgun, dmms, ghosted):
        
        self.start_metal_spinner.set_value(int(metal))
        self.start_energy_spinner.set_value(int(energy))
        self.max_units_spinner.set_value(int(units))
        self.starting_positions.set_active(int(starting))
        self.game_mode.set_active(int(mode))
        self.limited_dgun.set_active(int(dgun))
        self.diminishing_mms_combobox.set_active(int(dmms))
        self.ghosted_buildings.set_active(int(ghosted))
        

    def UpdateBattleInfo(self, foo):
        # Host
        if self.host == True:
            if foo == self.map_selection:
                model, paths = self.map_selection.get_selected_rows()
                if paths:
                    iter = self.map_liststore.get_iter(paths[0])
                    self.game_settings['map'] = self.map_liststore.get_value(iter, 0) + GLOBAL.MAP_EXTENSION            
                    self.game_settings['map hashcode'] = self.map_liststore.get_value(iter, 10)
            elif foo == self.lock_battle_combobox:
                self.game_settings['locked'] = self.lock_battle_combobox.get_active()
            
            # Online
            if self.online == True:
                command = str(self.game_settings['Spectator Count']) + ' ' + str(self.game_settings['locked']) + ' ' + str(self.game_settings['map hashcode']) + ' ' + self.game_settings['map']
                self.lobby.updatebattleinfo(command, True)
            

    def UpdateBattleDetails(self, foo, local_changes=True):
        
        if local_changes == True:
            if foo ==  self.start_metal_spinner:
                self.game_settings['metal'] = self.start_metal_spinner.get_value_as_int()
            elif foo == self.start_energy_spinner:
                self.game_settings['energy'] = self.start_energy_spinner.get_value_as_int()
            elif foo == self.max_units_spinner:
                self.game_settings['max units'] = self.max_units_spinner.get_value_as_int()
            elif foo == self.starting_positions:
                self.game_settings['starting position'] = self.starting_positions.get_active()
            elif foo == self.game_mode:
                self.game_settings['game mode'] = self.game_mode.get_active()
            elif foo == self.limited_dgun:
                self.game_settings['limited dgun'] = self.limited_dgun.get_active()
            elif foo == self.diminishing_mms_combobox:
                self.game_settings['diminishing MMs'] = self.diminishing_mms_combobox.get_active()
            elif foo == self.ghosted_buildings:
                self.game_settings['ghosted Buildings'] = self.ghosted_buildings.get_active()

            if (self.online == True) and (self.host == True):
                args = str(self.game_settings['metal']) + ' ' + str(self.game_settings['energy']) + ' ' + str(self.game_settings['max units']) + ' ' + str(self.game_settings['starting position']) + ' ' + str(self.game_settings['game mode']) + ' ' + str(self.game_settings['limited dgun']) + ' ' + str(self.game_settings['diminishing MMs']) + ' ' + str(self.game_settings['ghosted Buildings'])
                self.lobby.updatebattledetails(args, True)
        elif self.host != True:
            self.start_metal_spinner.set_value(int(foo[0]))
            self.start_energy_spinner.set_value(int(foo[1]))
            self.max_units_spinner.set_value(int(foo[2]))
            self.starting_positions.set_active(int(foo[3]))
            self.game_mode.set_active(int(foo[4]))
            self.limited_dgun.set_active(int(foo[5]))
            self.diminishing_mms_combobox.set_active(int(foo[6]))
            self.ghosted_buildings.set_active(int(foo[7]))

# TODO: Add code to stop changes from triggering this function !!!

    def MyBattleStatus(self):
        # TODO: Finish off code for  MyBattleStatus
        
        iter = self.player_liststore.get_iter_first()
        while iter != None:
            if self.player_name_online == self.player_liststore.get_value(iter, 1):
                if self.player_liststore.set_value(iter, 0) == gtk.STOCK_NO:
                    ready = 0
                else:
                    ready = 1
        
                team = self.player_liststore.get_value(iter, 2)
                allyteam = self.player_liststore.get_value(iter, 8)
                mode = self.player_liststore.get_value(iter, 13)  # (0 = spectator, 1 = normal player)
                handicap = self.player_liststore.get_value(iter, 9)
    
                red = self.player_liststore.set_value(iter, 3)
                green = self.player_liststore.set_value(iter, 4)
                blue = self.player_liststore.set_value(iter, 5)
                side = self.player_liststore.set_value(iter, 7)
                sync = self.battle_sync
#				  battlestatus = self.lobby.BattleStatusEncode(ready, team, allyteam, mode, handicap, teamcolor, sync, side)
                break
            iter = self.player_liststore.iter_next(iter)

#---Spring Script / Monitor Code---#000000#FFFFFF-------------------------------
    def TeamAllyList(self):
    ## TeamAllyXXXX() ===================================================================================
    ## ==================================================================================================
    ##  3 Functions mainly used to convert team / ally numbers to 0->15 in order. 
    ##   Since spring wants them in order.
    ## ==================================================================================================

        team_list = []
        ally_list = []
        iter = self.player_liststore.get_iter_first()
        if iter != None:
            while iter != None:
                team = self.player_liststore.get_value(iter, 2)
                ally = self.player_liststore.get_value(iter, 8)                
                if team != None:
                    team_list.append(int(team))
                    ally_list.append(int(ally))
                iter = self.player_liststore.iter_next(iter)
        if team_list != []:
            return team_list, ally_list
        else:
            return -1, -1


    def TeamAllyCount(self):
    ## TeamAllyXXXX() ===================================================================================
    ## ==================================================================================================
    ##  3 Functions mainly used to convert team / ally numbers to 0->15 in order. 
    ##   Since spring wants them in order.
    ## ==================================================================================================
        
        team_list, ally_list = self.TeamAllyList()
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
            return -1,-1


    def TeamAllyConvertList(self):
    ## TeamAllyXXXX() ===================================================================================
    ## ==================================================================================================
    ##  3 Functions mainly used to convert team / ally numbers to 0->15 in order. 
    ##   Since spring wants them in order.
    ## ==================================================================================================
        
        team_list, ally_list = self.TeamAllyList()
        bad_team_list, bad_ally_list = self.TeamAllyList()
        team_count, ally_count = self.TeamAllyCount()
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
            return -1, -1, -1, -1, -1, -1


    def FindAI(self):
    ## ==================================================================================================
    ##  Function which searchs in datadirs reported from unitsync for AI(s). 
    ##   Returns AI('s) filename & AI('s) Complete FilePath.
    ## ==================================================================================================

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


    def ScriptCreate(self):
    ## ==================================================================================================
    ##  Function which creates script.txt used by spring to start a game.
    ## ==================================================================================================
        
        # Player Name
        if self.online == True:
            my_player_name = self.player_name_online
        else:
            my_player_name = self.player_name_offline
        # Player Number
        my_player_number = '0' # TODO: HardCoded till get Lobby added
        # Number of Players
        num_of_players = '1'   # TODO: HardCoded till get Lobby added
        # Team Data
        team_count, team_list, bad_team_list, ally_count, ally_list, bad_ally_list = self.TeamAllyConvertList()
        if team_count != -1:

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

            iter = self.player_liststore.get_iter_first()

            while iter != None:
                if self.player_liststore.get_value(iter, 1) == my_player_name:
                    if self.player_liststore.get_value(iter,2) == None:
                        spectator = '1'
                    else:
                        my_player_team = str(self.player_liststore.get_value(iter,2))
                        for i in range(0,len(bad_team_list)):
                            if bad_team_list[i] == int(my_player_team):
                                my_player_team = str(team_list[i])
                                spectator = '0'
                                break
    
                sides.append(self.player_liststore.get_value(iter, 7))
                bonus.append(self.player_liststore.get_value(iter, 9))
                ai_location.append(self.player_liststore.get_value(iter, 12))
            
                red.append(self.player_liststore.get_value(iter, 3))
                green.append(self.player_liststore.get_value(iter, 4))
                blue.append(self.player_liststore.get_value(iter, 5))

                iter = self.player_liststore.iter_next(iter)
    
            # Making Script.txt
            fd_game = open(self.ini.get(self.profile, 'SPRING_SCRIPT'),'w+')
            fd_game.write('[GAME]\n')
            fd_game.write ('{\n')
            fd_game.write ('Mapname=' +  self.game_settings['map'] + ';\n')
            fd_game.write ('GameType=' + mod_name + ';\n')
            fd_game.write ('StartMetal=' + str(self.game_settings['metal']) + ';\n')
            fd_game.write ('StartEnergy=' + str(self.game_settings['energy']) + ';\n')
            fd_game.write ('MaxUnits=' + str(self.game_settings['max units']) + ';\n')
            fd_game.write ('StartPosType=' + str(self.game_settings['starting position']) + ';\n')
            fd_game.write ('GameMode=' + str(self.game_settings['game mode']) + ';\n')
            fd_game.write ('LimitDgun=' + str(self.game_settings['limited dgun']) + ';\n');
            fd_game.write ('DiminishingMMs=' + str(self.game_settings['diminishing MMs']) + ';\n');
            fd_game.write ('GhostedBuildings=' + str(self.game_settings['ghosted Buildings']) + ';\n');


            fd_game.write ('MyPlayerNum=' + my_player_number + ';\n')
            fd_game.write ('NumPlayers=' + num_of_players + ';\n')
            fd_game.write ('NumTeams=' + str(len(team_count)) + ';\n')
            fd_game.write ('NumAllyTeams=' + str(len(ally_count)) + ';\n')



            # Player
            fd_game.write ('[PLAYER0]\n')
            fd_game.write ('{\n')
            fd_game.write ('name=' + my_player_name + ';\n')
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
            self.Start()


    def Start(self):
    ## ==================================================================================================
    ##  Function to start SpringLauncher Threaded Class
    ##   Also Updates ~/.springrc to correct name value
    ## ==================================================================================================

        if self.online == True:
            my_player_name = self.player_name_online
        else:
            my_player_name = self.player_name_offline
        
        self.options.save_player_name(my_player_name)

        spring = self.ini.get(self.profile, 'SPRING_BINARY')
        script = self.ini.get(self.profile, 'SPRING_SCRIPT')
        self.pid = None
        self.spring_launcher = Timer(1, self.CheckSpringPID, spring, script)
        self.spring_launcher.start()
        
    def CheckSpringPID(self, spring, script):
    ## ==================================================================================================
    ##  Function used to start Spring & check if Spring is alive
    ## ==================================================================================================
        try:
            if self.pid == None:
       
                gtk.gdk.threads_enter()
                self.ingame = True
                self.OptionsSenstive()
                gtk.gdk.threads_leave()
        
                if self.platform != 'win32':
                    if self.gdb_backtrace.get_active() == 1:
                        # TODO: need better checks... maybe test for existance of gdb, whether spring has been compiled with debugging info, etc.
                        gdb_script = self.ini.get(self.profile, 'GDB_SCRIPT_TEMP')
                        f = file(gdb_script, 'w')
                        f.write('run %s\nbacktrace\nquit\n' % (script))
                        f.close()
                        self.pid = os.spawnlp(os.P_NOWAIT, 'gdb', 'gdb', spring, '-x', gdb_script, '-n', '-q', '-batch')
                    elif self.gdb_backtrace.get_active() == 0:
                        self.pid = os.spawnlp(os.P_NOWAIT, spring, spring, script)

                else:
                    pass
                    # TODO: Add Windows Code

            print 'Spring PID == ' + str(self.pid)


            os.waitpid(self.pid, os.WNOHANG)
            # TODO: Can add signal error code for GUI to translate reason of spring crashing
    
            try:
                val = os.kill(self.pid, 0)
                print 'Spring is alive ' + str(self.pid)
            except:
                val = 1
                print 'Spring is dead ' + str(self.pid)
        
            if val == 1:
                self.pid = None
                gtk.gdk.threads_enter()
                self.ingame = False
                self.OptionsSenstive()
                gtk.gdk.threads_leave()        
                self.spring_launcher.stop()
        
        except Exception, inst:
            print
            print 'CheckSpringPID'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


