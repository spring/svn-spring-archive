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
        self.drawingarea.get_colormap()
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
        self.spring_missing_map_image = os.path.join(status_icon.unity_location, 'resources', 'nomap.png')

        self.game_settings = {'battle description': GLOBAL.DESCRIPTION, 'locked': GLOBAL.LOCK_BATTLE_DEFAULT, 'game mode': GLOBAL.GAME_MODES_DEFAULT, 'limited dgun':GLOBAL.LIMITED_DGUN_DEFAULT, 'starting position': GLOBAL.STARTING_POSITIONS_DEFAULT, 'ghosted Buildings':GLOBAL.GHOSTED_BUILDINGS_DEFAULT, 'metal': GLOBAL.METAL_RESOURCES_DEFAULT, 'energy': GLOBAL.ENERGY_RESOURCES_DEFAULT, 'diminishing MMs':GLOBAL.DIMINISHING_MSS_DEFAULT, 'max units': GLOBAL.MAX_UNITS_DEFAULT, 'battle type': 0, 'nat':0, 'rank':0, 'Spectator Count':0, 'mod':None, 'mod hashcode':None, 'map':None, 'map hashcode':None}
        self.sync_status = {'map':None, 'mod':None}
        self.sides = None

        self.player_name_offline = None
        self.player_name_online = None
        self.pid = None

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
        self.battle_cache = [[], []]
        self.battle_bot_list = []
        for o in range(1, GLOBAL.MAX_TEAMS):
            self.battle_cache[0].append(None)

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
        self.ready_button.connect("clicked", self.player_update_status)
        self.ready_button.show()
        
        self.launch_battle_button = gtk.ToolButton(None, 'Start Battle')
        self.launch_battle_button.connect("clicked", self.launch_spring)
        self.launch_battle_button.set_sensitive(False)
        self.launch_battle_button.show()
        
        toolbar = gtk.Toolbar()	
        toolbar.insert(self.ready_button, 0)		
        toolbar.insert(self.launch_battle_button, 1)	
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
                        # 2  Team        = String
                        # 3  RGB -> R    = String
                        # 4  RGB -> G    = String
                        # 5  RGB -> B    = String
                        # 6  Color Image = gtk.gdk.Pixbuf
                        # 7  Side        = String
                        # 8  Ally        = String
                        # 9  Bonus       = String
                        # 10 AI          = String
                        # 11 AI Owner    = String
                        # 12 AI Location = String
                        # 13 Sync Status = gtk.gdk.Pixbuf
                        
                                            # 0    1    2    3    4    5    6               7    8    9    10   11   12   13
        self.player_liststore = gtk.ListStore(str, str, str, str, str, str, gtk.gdk.Pixbuf, str, str, str, str, str, str, str)
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
        self.cell0a = gtk.CellRendererPixbuf()
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
        self.player_column_0.pack_end(self.cell0a, False)
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
        self.description_entry.set_text(GLOBAL.DESCRIPTION)
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
        self.lock_battle_combobox.connect("changed", self.UpdateBattleInfo)
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
        start_metal_adjustment = gtk.Adjustment(GLOBAL.METAL_RESOURCES_DEFAULT, lower=GLOBAL.METAL_RESOURCES[0], upper=GLOBAL.METAL_RESOURCES[1], step_incr=GLOBAL.METAL_RESOURCES[2], page_incr=GLOBAL.METAL_RESOURCES[3], page_size=0)
        self.start_metal_spinner = gtk.SpinButton(start_metal_adjustment, 0, 0)
        self.start_metal_spinner.connect("value-changed", self.UpdateBattleDetails)
        self.start_metal_spinner.show()
        resources_table.attach(self.start_metal_spinner, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
                        # Start Energy
        start_energy_label = label_create("Energy")
        resources_table.attach(start_energy_label, 0,1,1,2, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        start_energy_adjustment = gtk.Adjustment(GLOBAL.ENERGY_RESOURCES_DEFAULT, lower=GLOBAL.ENERGY_RESOURCES[0], upper=GLOBAL.ENERGY_RESOURCES[1], step_incr=GLOBAL.ENERGY_RESOURCES[2], page_incr=GLOBAL.ENERGY_RESOURCES[3], page_size=0)
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
        max_units_adjustment = gtk.Adjustment(GLOBAL.MAX_UNITS_DEFAULT, lower=GLOBAL.MAX_UNITS[0], upper=GLOBAL.MAX_UNITS[1], step_incr=GLOBAL.MAX_UNITS[2], page_incr=GLOBAL.MAX_UNITS[3], page_size=0)
        self.max_units_spinner = gtk.SpinButton(max_units_adjustment, 0, 0)
        self.max_units_spinner.connect("value-changed", self.UpdateBattleDetails)
        self.max_units_spinner.show()
        resources_table.attach(self.max_units_spinner, 1,2,3,4, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
            # Frame - Debug
        debug_frame = create_page(self, options_notebook, 'Debug', 100, 50)
                    # Table
        debug_table = gtk.Table(rows=1, columns=1, homogeneous=False)
        debug_table.show()
        debug_frame.add(debug_table)
                        # Gdb Backtrace
        gdb_backtrace_label = label_create("Gdb Backtrace")
        debug_table.attach(gdb_backtrace_label,0,1,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)

        self.gdb_backtrace = combobox_setup(GLOBAL.GDB_BACKTRACE, GLOBAL.GDB_BACKTRACE_DEFAULT, True)
        self.gdb_backtrace.connect("changed", self.UpdateBattleDetails)
        debug_table.attach(self.gdb_backtrace, 1,2,0,1, xoptions=gtk.SHRINK|gtk.FILL, yoptions=gtk.SHRINK|gtk.FILL, xpadding=5, ypadding=5)
        
                        # Frame - Sync Status
        sync_frame = frame_create('Sync Status')                        
        debug_table.attach(sync_frame, 0,2,1,4)
                            # Table
        sync_table = gtk.Table(rows=4, columns=2, homogeneous=False)
        sync_table.show()
        sync_frame.add(sync_table)
                            # Map Status
        sync_map_label = label_create('Map Status')
        sync_table.attach(sync_map_label, 0,1,0,1)

        self.sync_status_map_label = label_create('Unknown')
        sync_table.attach(self.sync_status_map_label, 1,2,0,1)        
                            # Mod Status
        sync_map_label = label_create('Mod Status')
        sync_table.attach(sync_map_label, 0,1,2,3)                            

        self.sync_status_mod_label = label_create('Unknown')
        sync_table.attach(self.sync_status_mod_label, 1,2,2,3)                            
            

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

        map_selection = self.map_treeview.get_selection()
        map_selection.connect('changed', self.MapSelection)

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

        self.ModSelection(mod_selection)        

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


    def PlayerPopupMenu(self, widget, event):
    ## ==================================================================================================
    ##  Player Popup Menu for Player Battle List.
    ## ==================================================================================================
        
        if event.type == gtk.gdk._2BUTTON_PRESS:
            if event.button == 1:
                treeselection = self.player_treeview.get_selection()
                (model, iter) = treeselection.get_selected()
                
                name = self.player_liststore.get_value(iter, 1)

                if iter != None:
                    # Menu
                    menu = gtk.Menu()
                        # Name
                    username_item = gtk.MenuItem(name)
                    username_item.show()
                    menu.append(username_item)
                    username_item.set_sensitive(False)
                    
                        # Name Seperator
                    username_seperator = gtk.SeparatorMenuItem()
                    username_seperator.show()
                    menu.append(username_seperator)
                    
                    
                        # Army
                    change_army_item = gtk.MenuItem("Army")
                    change_army_item.show()
                    menu.append(change_army_item)                                              
                            # Sub Menu
                    menu_change_army = gtk.Menu()
                    menu_change_army.show()
                    change_army_item.set_submenu(menu_change_army)
                                # Army
                    foo = self.player_liststore.get_value(iter, 2)
                    if foo == None:
                        change_army_item.set_sensitive(False)
                    else:
                        foo = int(foo)
                        for o in range(1,GLOBAL.MAX_TEAMS + 1):
                            sub_army_item = gtk.MenuItem(str(o))
                            sub_army_item.connect("button_press_event", self.UpdateArmyValue, iter, o)                    
                            sub_army_item.show()
                            if foo == o:
                                sub_army_item.set_sensitive(False)
                            menu_change_army.append(sub_army_item)
                        

                        # Ally
                    change_ally_item = gtk.MenuItem("Ally")
                    change_ally_item.show()
                    menu.append(change_ally_item)
                            # Sub Menu
                    menu_change_ally = gtk.Menu()
                    menu_change_ally.show()
                    change_ally_item.set_submenu(menu_change_ally)
                                # Ally
                    foo = self.player_liststore.get_value(iter, 8)
                    if foo == None:
                        change_ally_item.set_sensitive(False)
                    else:
                        foo = int(foo)
                        for o in range(1,GLOBAL.MAX_ALLIES + 1):
                            sub_ally_item = gtk.MenuItem(str(o))
                            sub_ally_item.connect("button_press_event", self.UpdateAllyValue, iter, o)                                            
                            sub_ally_item.show()
                            if foo == o:
                                sub_ally_item.set_sensitive(False)
                            menu_change_ally.append(sub_ally_item)

                        
                        # Side
                    change_side_item = gtk.MenuItem("Side")
                    change_side_item.show()
                    menu.append(change_side_item)
                            # Sub Menu
                    menu_change_side = gtk.Menu()
                    menu_change_side.show()
                    change_side_item.set_submenu(menu_change_side)
                                # Side
                    foo = self.player_liststore.get_value(iter, 7)
                    if foo == None:
                        change_side_item.set_sensitive(False)
                    else:
                        for o in range(0,len(self.sides)):
                            sub_side_item = gtk.MenuItem(self.sides[o])
                            sub_side_item.connect("button_press_event", self.UpdateSideValue, iter, o)                                            
                            sub_side_item.show()
                            if foo == self.sides[o]:
                                sub_side_item.set_sensitive(False)
                            menu_change_side.append(sub_side_item)


                        # Misc Seperator
                    misc_seperator = gtk.SeparatorMenuItem()
                    misc_seperator.show()
                    menu.append(misc_seperator) 
                    
                        # Color
                    change_colour_item = gtk.MenuItem("Colour")
                    change_colour_item.connect("button_press_event", self.ChooseColor, iter)                    
                    change_colour_item.show()
                    menu.append(change_colour_item)
                    
                    if foo == None:
                        change_colour_item.set_sensitive(False)

                    
                        # Handicap
                    change_handicap_item = gtk.MenuItem("Handicap")
#                    change_handicap_item.connect("button_press_event", self.ChangeHandicap, iter)
                    change_handicap_item.show()
                    menu.append(change_handicap_item)
                    
                    if foo == None:
                        change_handicap_item.set_sensitive(False)
                
                        # Kick
                    kick_item = gtk.MenuItem("Kick")
                    kick_item.connect("button_press_event", self.KickPlayerOrBot, iter)                    
                    kick_item.show()                
                       
                        # Misc Seperator
                    misc_seperator = gtk.SeparatorMenuItem()
                    misc_seperator.show()
                    menu.append(misc_seperator)                        
                    
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
                    switch_to_player_item.connect("button_press_event", self.UpdatePlayerSpectatorValue, iter, 1)
                    switch_to_player_item.show()
                    menu_switch_to_item.append(switch_to_player_item)
                                # Switch to Spectator
                    switch_to_spectator_item = gtk.MenuItem("Spectator")
                    switch_to_spectator_item.connect("button_press_event", self.UpdatePlayerSpectatorValue, iter, 0)                    
                    switch_to_spectator_item.show()
                    menu_switch_to_item.append(switch_to_spectator_item)
                    
  
                    # Sensitive Settings
                    if self.online == True:
                        if (self.host == False) and (self.player_liststore.get_value(iter, 1) != self.player_name_online):
                            change_army_item.set_sensitive(False)
                            change_ally_item.set_sensitive(False)
                            change_colour_item.set_sensitive(False)
                            switch_to_item.set_sensitive(False)

                        if (self.player_liststore.get_value(iter, 1) != self.player_name_online) and (self.player_liststore.get_value(iter, 1) != self.player_name_online):
                            change_side_item.set_sensitive(False)                            

                        if self.host == True:
                            change_handicap_item.set_sensitive(False)
                        else:
                            kick_item.set_sensitive(False)
                            
                    if self.player_liststore.get_value(iter, 1) == self.player_name_online:
                            kick_item.set_sensitive(False)
                            if self.player_liststore.get_value(iter, 2) == None:
                                switch_to_spectator_item.set_sensitive(False)
                            else:
                                switch_to_player_item.set_sensitive(False)

                    else:        
                        if self.player_liststore.get_value(iter, 1) == self.player_name_offline:
                            kick_item.set_sensitive(False)
                            if self.player_liststore.get_value(iter, 2) == None:
                                switch_to_spectator_item.set_sensitive(False)
                            else:
                                switch_to_player_item.set_sensitive(False)
                    
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
                        if self.online == True:
                            select_ai_side_item.connect("button_press_event", self.AddBot, ai[i], None, self.player_name_online, ai_location[i], self.sides[p])
                        else:
                            select_ai_side_item.connect("button_press_event", self.AddBot, ai[i], None, self.player_name_offline, ai_location[i], self.sides[p])
                        select_ai_side_item.show()
                        menu_select_ai_side.append(select_ai_side_item)
                        p = p + 1
                    select_ai_item.set_submenu(menu_select_ai_side)
                    i = i + 2
                ai_item.set_submenu(menu_select_ai)

                menu.popup(None, None, None, event.button, event.time)
                menu.show() 
        
    def HandicapDialog(self):
        pass
        
#---Battle Player List Code---#000000#FFFFFF------------------------------------
    def AddBot(self, widget, event, ai, ai_name, ai_owner, ai_location, side = None, battlestatus=None, teamcolor=None):
    ## ==================================================================================================
    ##  Add Bot
    ## ==================================================================================================

        if battlestatus == None:
        ## Generate Default Values for Bot
            # Team & Ally
            spare_teams, spare_allys = self.spare_team_ally_values()
            if len(spare_teams) >= 1:
                team = spare_teams[0]
            else:
                team = 1
            if len(spare_allys) >= 1:
                ally = spare_allys[0]
            else:
                ally = 1
            # Team Color
            red, green, blue, pixbuf = self.DefaultColor(team)
            # Sync Status
            ready = None
            sync = None
            
            ai_name = self.DefaultAIName()
            
        else:
        ## Get Values from BattleStatus & Color bits
            # BattleStatus
            ready, team, ally, mode, handicap, sync, side = self.BattleStatusDecode(int(battlestatus))
            ready = None
            sync = None
            team = team + 1
            ally = ally + 1
            side = self.sides[int(side)]
            # Team Color
            red, green, blue = self.BattleStatusColorDecode(int(teamcolor))
            pixbuf = self.CreateTeamColor(team, red, green, blue)
            

        if ai_name != None:
            if (self.online == False) or (battlestatus != None): 
            ## Adding Bot to Player List
                self.battle_bot_list.append(ai_name)
                self.player_liststore.append([None, ai_name, team, red, green, blue, pixbuf, side, ally, 0, ai, ai_owner, ai_location, None])

                self.player_column_0.set_cell_data_func(self.cell0, self.treeview_ready_image)
                self.player_column_0.set_cell_data_func(self.cell0a, self.treeview_sync_image)        
                
            elif battlestatus == None:
                ## Encoding BattleStatus into Bitmasks
                ready = 1
                sync = 0
                mode = 1
                bonus = 0
                
                team = team - 1
                ally = ally - 1

                side = self.sides.index(side)
                battle_status_bitmask = self.BattleStatusEncode(ready, team, ally, mode, bonus, sync, side)
                battle_color_bitmask = self.ColorEncode(red, green, blue)
                args = ai_name + ' ' + str(battle_status_bitmask) + ' ' + str(battle_color_bitmask) + " " + (ai_location.replace(' ', "\t"))
                self.lobby.addbot(args, True)            


    def AddPlayer(self, side):
    ## ==================================================================================================
    ##  Add MyPlayer with default values in Battle Player List.
    ## ==================================================================================================

        if self.online == True:
            my_player_name = self.player_name_online
        else:
            my_player_name = self.player_name_offline
            
        spare_teams, spare_allys = self.spare_team_ally_values()
        if len(spare_teams) >= 1:
            team = spare_teams[0]
        else:
            team = 1
        if len(spare_allys) >= 1:
            ally = spare_allys[0]
        else:
            ally = 1                      

        red, green, blue, pixbuf = self.DefaultColor(team)


        if (self.sync_status['map'] == 'Good') and (self.sync_status['mod'] == 'Good'):
            self.player_liststore.append([gtk.STOCK_NO, my_player_name, team, red, green, blue, pixbuf, side, ally, 0, None, None, None, 'unitylobby-in-sync'])            
        elif (self.sync_status['map'] == 'Unknown') or (self.sync_status['mod'] == 'Unknown'):
            self.player_liststore.append([gtk.STOCK_NO, my_player_name, team, red, green, blue, pixbuf, side, ally, 0, None, None, None, 'unitylobby-unknown-sync'])            
        else:
            self.player_liststore.append([gtk.STOCK_NO, my_player_name, team, red, green, blue, pixbuf, side, team, 0, None, None, None, 'unitylobby-outof-sync'])            

        self.player_column_0.set_cell_data_func(self.cell0, self.treeview_ready_image)
        self.player_column_0.set_cell_data_func(self.cell0a, self.treeview_sync_image)                


    def scan_for_player(self, username, scan_iter=None):
        
        if scan_iter == None:
            scan_iter = self.player_liststore.get_iter_first()
        else:
            scan_iter = self.player_liststore.iter_next(scan_iter) 
            
        while scan_iter != None:
            if self.player_liststore.get_value(scan_iter, 10) == None:
                if username == None:
                    break                
                elif self.player_liststore.get_value(scan_iter, 1) == username:
                    break
            scan_iter = self.player_liststore.iter_next(scan_iter)                
        return scan_iter
    

    def scan_for_bot(self, username=None, scan_iter=None):
                
        if scan_iter == None:
            scan_iter = self.player_liststore.get_iter_first()
        else:
            scan_iter = self.player_liststore.iter_next(scan_iter) 

        while scan_iter != None:
            if self.player_liststore.get_value(scan_iter, 10) != None:
                if username == None:
                    break
                elif self.player_liststore.get_value(scan_iter, 1) == username:
                    break
            scan_iter = self.player_liststore.iter_next(scan_iter)
            
        return scan_iter        

    
    def RemovePlayer(self, username):
        test = None
        scan_iter = self.player_liststore.get_iter_first()
        
        while scan_iter != None:
            # Check for Player & Bots
            if ((self.player_liststore.get_value(scan_iter, 1) == username) and (self.player_liststore.get_value(scan_iter, 10) == None)): #or (self.player_liststore.get_value(scan_iter, 11) == username):
                test = self.player_liststore.remove(scan_iter)
            if test == True:
                test = None
            elif test == False:
                break
            elif test == None:
                scan_iter = self.player_liststore.iter_next(scan_iter)


    def RemoveBot(self, username):
        scan_iter = self.player_liststore.get_iter_first()
        while scan_iter != None:
            # Check for Player & Bots
            if ((self.player_liststore.get_value(scan_iter, 1) == username) and (self.player_liststore.get_value(scan_iter, 10) != None)) or (self.player_liststore.get_value(scan_iter, 11) == username):
                self.player_liststore.remove(scan_iter)
                break
            else:
                scan_iter = self.player_liststore.iter_next(scan_iter)        
        self.battle_bot_list.remove(username)
        
    def spare_team_ally_values(self):
        spare_teams = []
        spare_allys = []
        
        for o in range(1, GLOBAL.MAX_TEAMS):
            spare_teams.append(o)

        for o in range(1, GLOBAL.MAX_ALLIES):
            spare_allys.append(o)        
            
        scan_iter = self.player_liststore.get_iter_first()
        while scan_iter != None:
            team = int(self.player_liststore.get_value(scan_iter, 2))
            ally = int(self.player_liststore.get_value(scan_iter, 8))
            
            if team != None:
                if spare_teams.count(team) != 0:
                    spare_teams.remove(team)
                    if spare_allys.count(ally) != 0:
                        spare_allys.remove(ally)
            scan_iter = self.player_liststore.iter_next(scan_iter)        
        return spare_teams, spare_allys

    def UpdateArmyValue(self, widget, event, iter, value):
        if self.online == False:
            self.player_liststore.set_value(iter, 2, value)
        else:
            if (self.player_liststore.get_value(iter, 10) != None) and ( (self.player_liststore.get_value(iter, 11) == self.player_name_online) or (self.host == True) ):
                # Bot Name
                name = self.player_liststore.get_value(iter, 1)
                # Getting Old BattleStatus & TeamColor
                ready, team, allyteam, mode, bonus, sync, side, red, green, blue = self.MyBattleStatus(iter)
                # Updating New Value
                team = value - 1
                allyteam = allyteam - 1
                # Encoding BattleStatus into Bitmasks
                battle_status_bitmask = self.BattleStatusEncode(ready, team, allyteam, mode, bonus, sync, side)
                battle_color_bitmask = self.ColorEncode(red, green, blue)
                self.UpdateBot(name, battle_status_bitmask, battle_color_bitmask)
            elif self.player_liststore.get_value(iter, 1) != self.player_name_online:
                self.ForceTeamNumber(iter, value)
            else:
                self.UpdateMyBattleStatus(iter, ['team', value - 1])


    def UpdateAllyValue(self, widget, event, iter, value):
        if self.online == False:
            self.player_liststore.set_value(iter, 8, value)
        else:
            if (self.player_liststore.get_value(iter, 10) != None) and ( (self.player_liststore.get_value(iter, 11) == self.player_name_online) or (self.host == True) ):
                # Bot Name
                name = self.player_liststore.get_value(iter, 1)
                # Getting Old BattleStatus & TeamColor
                ready, team, allyteam, mode, bonus, sync, side, red, green, blue = self.MyBattleStatus(iter)
                # Updating New Value
                team = team - 1
                allyteam = value - 1
                # Encoding BattleStatus into Bitmasks
                battle_status_bitmask = self.BattleStatusEncode(ready, team, allyteam, mode, bonus, sync, side)
                battle_color_bitmask = self.ColorEncode(red, green, blue)
                self.UpdateBot(name, battle_status_bitmask, battle_color_bitmask)
            elif self.player_liststore.get_value(iter, 1) != self.player_name_online:
                self.ForceAllyNumber(iter, value)
            else:
                self.UpdateMyBattleStatus(iter, ['ally', value - 1])


    def UpdateSideValue(self, widget, event, iter, value):
        if self.online == False:
            self.player_liststore.set_value(iter, 7, self.sides[value])
        else:
            if (self.player_liststore.get_value(iter, 10) != None) and ( (self.player_liststore.get_value(iter, 11) == self.player_name_online) or (self.host == True) ):
                # Bot Name
                name = self.player_liststore.get_value(iter, 1)
                # Getting Old BattleStatus & TeamColor
                ready, team, allyteam, mode, bonus, sync, side, red, green, blue = self.MyBattleStatus(iter)
                # Updating New Value
                team = team - 1
                allyteam = allyteam - 1
                side = value
                # Encoding BattleStatus into Bitmasks
                battle_status_bitmask = self.BattleStatusEncode(ready, team, allyteam, mode, bonus, sync, side)
                battle_color_bitmask = self.ColorEncode(red, green, blue)
                self.UpdateBot(name, battle_status_bitmask, battle_color_bitmask)
            else:
                self.UpdateMyBattleStatus(iter, ['side', value])

                
    def UpdateColorValue(self, iter, value):
        if self.online == False:
            self.UpdateColor(iter, value)
        else:
            if (self.player_liststore.get_value(iter, 10) != None) and ( (self.player_liststore.get_value(iter, 11) == self.player_name_online) or (self.host == True) ):
                # Bot Name
                name = self.player_liststore.get_value(iter, 1)
                # Getting Old BattleStatus & TeamColor
                ready, team, allyteam, mode, bonus, sync, side, red, green, blue = self.MyBattleStatus(iter)
                # Updating New Value
                team = team - 1
                allyteam = allyteam - 1
                red = value[0]
                green = value[1]
                blue = value[2]
                # Encoding BattleStatus into Bitmasks
                battle_status_bitmask = self.BattleStatusEncode(ready, team, allyteam, mode, bonus, sync, side)
                battle_color_bitmask = self.ColorEncode(red, green, blue)
                self.UpdateBot(name, battle_status_bitmask, battle_color_bitmask)
                self.UpdateBot(name, battle_status_bitmask, battle_color_bitmask)
            elif self.player_liststore.get_value(iter, 1) != self.player_name_online:
                self.ForceTeamColor(iter, value)
            else:
                self.UpdateMyBattleStatus(iter, ['color', value[0], value[1], value[2]])


    def UpdatePlayerSpectatorValue(self, widget, event, iter, value):

        if self.online == False:
            if value == 0:
                self.SwitchToSpectator(iter)
            else:
                self.SwitchToPlayer(iter)
        else:
            if self.player_liststore.get_value(iter, 1) == self.player_name_online:
                self.UpdateMyBattleStatus(iter, ['mode', value])
            else:
                pass
                # TODO:


    def SwitchToPlayer(self, iter):

        spare_teams, spare_allys = self.spare_team_ally_values()
        if len(spare_teams) >= 1:
            team = spare_teams[0]
        else:
            team = 1
        if len(spare_allys) >= 1:
            ally = spare_allys[0]
        else:
            ally = 1
        
        red, green, blue, pixbuf = self.DefaultColor(team)
                    
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
        
        if (self.online == True) and (self.player_liststore.get_value(iter, 1) == self.player_name_online):
            self.MyBattleStatus(iter)

    def SwitchToSpectator(self, iter):

        self.player_liststore.set_value(iter, 2, None)
        self.player_liststore.set_value(iter, 3, None)        
        self.player_liststore.set_value(iter, 4, None)
        self.player_liststore.set_value(iter, 5, None)        
        self.player_liststore.set_value(iter, 6, None)        
        self.player_liststore.set_value(iter, 7, None)        
        self.player_liststore.set_value(iter, 8, None)        
        self.player_liststore.set_value(iter, 9, None)
        
        self.game_settings['Spectator Count'] = self.game_settings['Spectator Count'] + 1

        if (self.online == True) and (self.player_liststore.get_value(iter, 1) == self.player_name_online):
            self.MyBattleStatus(iter)             

    def KickPlayerOrBot(self, widget, event, iter=None):
    ## ==================================================================================================
    ##  Removes Player / Bot from Battle Player List.
    ## ==================================================================================================
        # Removes Player / Bot from Player List
        if self.online == True:
            name = self.player_liststore.get_value(iter, 1)
            if self.player_liststore.get_value(iter, 10) == None:
                # Player
                self.lobby.kickfrombattle(name)
            else:
                self.lobby.removebot(name, True)
        else:
            self.player_liststore.remove(iter)


    def CreateTeamColor(self, team, red, green, blue):
    ## ==================================================================================================
    ##  Creates Team Color file & returns the pixbuf.
    ## ==================================================================================================
        
        team = str(team)
        team_colour_image = Image.new('RGB', [48,16], (red, green, blue))
        team_image = os.path.join(self.profile_dir, (team + '.jpeg'))
        team_colour_image.save(team_image, "JPEG")
        pixbuf = gtk.gdk.pixbuf_new_from_file(team_image)
        self.player_column_3.set_cell_data_func(self.cell3, self.treeview_team_image)
        return pixbuf


    def DefaultColor(self, team):
    ## ==================================================================================================
    ##  Gets Default Color for team from GLOBAL.
    ## ==================================================================================================
        
        red = GLOBAL.COLOR_TEAM[(team - 1)][0]
        green = GLOBAL.COLOR_TEAM[(team - 1)][1]
        blue = GLOBAL.COLOR_TEAM[(team - 1)][2]
        pixbuf = self.CreateTeamColor((team -1), red, green, blue)
        return red, green, blue, pixbuf


    def DefaultAIName(self):
        
        template = 'Bot'
        ai_name = None
        name_list = []
        scan_iter = self.player_liststore.get_iter_first()
        
        while scan_iter != None:
            name_list.append(self.player_liststore.get_value(scan_iter, 1))
            scan_iter = self.player_liststore.iter_next(scan_iter)
        
        for o in range(1, GLOBAL.MAX_TEAMS):
            try:
                name_list.index((template + str(o)))
            except:
                ai_name = template + str(o)
                break
        return ai_name

        
    def ChooseColor(self, widget, event, iter):
    ## ==================================================================================================
    ##  Calls on Color Selector class.
    ##   And then passes updated rgb to self.UpdateColorValue
    ## ==================================================================================================
        
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

        self.UpdateColorValue(iter, [red,green,blue])


    def UpdateColor(self, iter, value):
        team = str(self.player_liststore.get_value(iter,2))
        pixbuf = self.CreateTeamColor(team, value[0], value[1], value[2])
        
        if team != None:
            scan_iter = self.player_liststore.get_iter_first()
            while scan_iter != None:
                if self.player_liststore.get_value(scan_iter,2) == team:
                    self.player_liststore.set_value(scan_iter, 3, str(value[0]))
                    self.player_liststore.set_value(scan_iter, 4, str(value[1]))
                    self.player_liststore.set_value(scan_iter, 5, str(value[2]))
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
            if stock != None:
                pixbuf = self.player_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
            else:
                pixbuf = None
            cell.set_property('pixbuf', pixbuf)
            return

        
    def treeview_sync_image(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Various functions to update images in Battle Player List.
    ## ==================================================================================================
        
            stock = model.get_value(iter, 13)
            if stock != None:
                pixbuf = self.player_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
            else:
                pixbuf = None
            cell.set_property('pixbuf', pixbuf)
            return        
        
    
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


    def player_update_status(self, toolbutton, ready=None):
    ## ==================================================================================================
    ##  Function which searchs self.player_liststore for my_player_name == player_name. 
    ##   If found updates player ready status.
    ## ==================================================================================================
                
        if ready == None:
            if self.ready_button.get_stock_id() == gtk.STOCK_YES:
                self.ready_button.set_stock_id(gtk.STOCK_NO)
                ready = False
            else:
                self.ready_button.set_stock_id(gtk.STOCK_YES)
                ready = True

        if self.online == True:
            player_name = self.player_name_online
            if ready == False:
                self.UpdateMyBattleStatus(None, ['ready',0])
            else:
                self.UpdateMyBattleStatus(None, ['ready',1])                
        else:
            player_name = self.player_name_offline

        # Update Player Ready Icon
        iter = self.scan_for_player(player_name)
        if ready == False:
            self.player_liststore.set_value(iter, 0, gtk.STOCK_NO)
        else:
            self.player_liststore.set_value(iter, 0, gtk.STOCK_YES)
            
        self.player_column_0.set_cell_data_func(self.cell0, self.treeview_ready_image)


        iter = self.player_liststore.get_iter_first()
        while iter != None:
            if self.player_liststore.get_value(iter,0) == gtk.STOCK_NO:
                break
            iter = self.player_liststore.iter_next(iter)
        if iter == None:
            if self.host == True:
                self.launch_battle_button.set_sensitive(True)
        else:
            self.launch_battle_button.set_sensitive(False)
            
#---Update Map Code---#000000#FFFFFF-------------------------------------------- 
    def MapSelection(self, map_selection):
    ## ==================================================================================================
    ##  Generates Map Preview of currently selected map & updates map previews.
    ## ==================================================================================================

        model, paths = map_selection.get_selected_rows()
        if paths:
            iter = self.map_liststore.get_iter(paths[0])
            
            # No need to pass map_selection to self.UpdateBattleInfo
            #  Faster & easier to update here & just pass None
            #   So it will be updated to other clients if online & host
            map_hashcode = self.map_liststore.get_value(iter, 10)
            if self.game_settings['map hashcode'] != map_hashcode:
                map = self.map_liststore.get_value(iter, 0)
                self.game_settings['map'] = map
                self.game_settings['map hashcode'] = map_hashcode

                self.UpdateBattleInfo(None)
                self.UpdateMySyncStatus('map', 'Good')
                self.GenerateMapPreview(iter)   
                            

    def SearchForMap(self):
    ## ==================================================================================================
    ##  Searchs for  Map in Map Liststore
    ## ==================================================================================================

        map_selection = self.map_treeview.get_selection()
        map_selection.unselect_all()
        iter = self.map_liststore.get_iter_first()
        while iter != None:
            if self.map_liststore.get_value(iter, 0) == self.game_settings['map']:                   
                if self.map_liststore.get_value(iter, 10) == self.game_settings['map hashcode']:
                    self.UpdateMySyncStatus('map', 'Good')
                    map_selection.select_iter(iter)
                else:
                    self.UpdateMySyncStatus('map', 'Bad Checksum')
                break
            iter = self.map_liststore.iter_next(iter)
        
        if iter == None:
            self.UpdateMySyncStatus('map', 'Missing')
        self.GenerateMapPreview(iter)
            

    def GenerateMapPreview(self, iter):
    ## ==================================================================================================
    ##  Generates Map Preview 
    ## ==================================================================================================
        if iter == None:
            # Generate Preview
            pixbuf = gtk.gdk.pixbuf_new_from_file(self.spring_missing_map_image)
            self.map_preview_1.set_from_pixbuf(pixbuf)
            self.map_preview_2.set_from_pixbuf(pixbuf)
            self.map_description.set_text('Could not find \n' + self.game_settings['map'])

            
        else:
            # Generate Preview
            map_preview = self.ini.get(self.profile, 'SPRING_MAP_PREVIEW')
            self.unitsync_wrapper.create_map_preview( (self.game_settings['map'] + GLOBAL.MAP_EXTENSION), GLOBAL.MIP_LEVEL, map_preview)
            
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
                self.map_description.set_text(str(self.unitsync_wrapper.get_map_info(self.game_settings['map']+GLOBAL.MAP_EXTENSION)[1]["description"]))
                self.map_description.set_line_wrap(1)
            

#---Update Mod Code---#000000#FFFFFF--------------------------------------------
    def ModSelection(self, mod_selection):
    ## ==================================================================================================
    ##  Gets mod info from currently selected Mod & updates sides info if needed.
    ## ==================================================================================================

        model, paths = mod_selection.get_selected_rows()
        if paths:
            iter = self.mod_liststore.get_iter(paths[0])
            
            # No need to pass map_selection to self.UpdateBattleInfo
            #  Faster & easier to update here & just pass None
            #   So it will be updated to other clients if online & host
            mod_hashcode = self.mod_liststore.get_value(iter, 1)
            if self.game_settings['mod hashcode'] != mod_hashcode:
                mod = self.mod_liststore.get_value(iter, 0)
                self.game_settings['mod'] = mod
                self.game_settings['mod hashcode'] = mod_hashcode

                self.UpdateMySyncStatus('mod', 'Good')
                self.UpdateModSides(iter)
                
                
    def SearchForMod(self):
    ## ==================================================================================================
    ##  Searchs for Mod in Mod Liststore
    ## ==================================================================================================

        mod_selection = self.mod_treeview.get_selection()
        mod_selection.unselect_all()   
        iter = self.mod_liststore.get_iter_first()
        while iter != None:
            if self.mod_liststore.get_value(iter, 0) == self.game_settings['mod']:                   
                if self.mod_liststore.get_value(iter, 1) == self.game_settings['mod hashcode']:
                    self.UpdateMySyncStatus('mod', 'Good')
                    mod_selection.select_iter(iter)                    
                    self.UpdateModSides(iter)
                else:
                    self.UpdateMySyncStatus('mod', 'Bad Checksum')
                    # TODO: Change Player Side to 0  just to be safe
                break
            iter = self.mod_liststore.iter_next(iter)
        
        if iter == None:
            self.UpdateMySyncStatus('mod', 'Missing')
            # TODO: Change Player Side to 0  just to be safe


    def UpdateModSides(self, iter):
    ## Checks if old sides != new sides
    ##  If true updates sides

        sides = self.mod_index.mod_archive_sides(self.game_settings['mod hashcode'])

        if self.sides != sides:
            self.sides_model.clear()
            for side in sides:
                self.sides_model.append([side])
            
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
        args = str(self.game_settings['battle type']) + ' ' + str(self.game_settings['nat']) + ' ' + str(password) + ' ' + str(self.lobby.spring_udp_port) + ' ' + str(self.game_settings['max_players'])  + ' ' + str(self.game_settings['metal']) + ' ' + str(self.game_settings['energy']) + ' ' + str(self.game_settings['max units']) + ' ' + str(self.game_settings['starting position']) + ' ' + str(self.game_settings['game mode']) + ' ' + str(self.game_settings['limited dgun']) + ' ' + str(self.game_settings['diminishing MMs']) + ' ' + str(self.game_settings['ghosted Buildings']) + ' ' + self.game_settings['mod hashcode'] + ' ' + str(self.game_settings['rank']) + ' ' + self.game_settings['map hashcode'] + ' ' + self.game_settings['map'] + GLOBAL.MAP_EXTENSION + "\t" + self.game_settings['description'] + "\t" + self.game_settings['mod name']

        self.lobby.openbattle(args, True)


    def HostNetworkGameSucess(self, battle_id):
        
        self.host = True
        self.online = True
        self.ingame = False

        
        self.lobby.battle_id = battle_id
        self.lobby.battle_ip = '127.0.0.1'
        self.lobby.battle_port = self.lobby.spring_udp_port
        self.lobby.battle_host = None

        scan_iter = self.scan_for_network_game()        
        
        self.battle_player_list = [self.lobby.battle_liststore.get_value(scan_iter, 13)]
        self.battle_bot_list = []

        self.battle_vpane = self.lobby.CreateBattleChat(scan_iter)
        self.battle_vpane.show()
        self.player_vpane.pack2(self.battle_vpane, True, True)

        self.host_battle_button.set_label('Leave Battle')
        self.host_battle_button.set_sensitive(True)
        
        # Check if UPDATEBATTLEINFO is needed to be sent
        if (self.game_settings['Spectator Count'] != 0) or (self.lock_battle_combobox.get_active() != 0):
            self.UpdateBattleInfo(None)
        
        
    def JoinNetworkGame(self, command):
        
        # Checking for AI's and removing them
        scan_iter = self.scan_for_bot()
        while scan_iter != None:
            self.player_liststore.remove(scan_iter)
            scan_iter = self.scan_for_bot(scan_iter)

    
        # Updating Battle Variables
        self.host = False
        self.online = True
        self.ingame = False

        self.UpdatePlayerName()
        
        scan_iter = self.scan_for_network_game()
        # Update GUI_Lobby Values
        self.lobby.battle_id = self.lobby.battle_liststore.get_value(scan_iter, 0)
        self.lobby.battle_ip = self.lobby.battle_liststore.get_value(scan_iter, 4)
        self.lobby.battle_port = str(self.lobby.battle_liststore.get_value(scan_iter, 5))        
        self.lobby.battle_host = self.lobby.battle_liststore.get_value(scan_iter, 13)[0]
        
        self.battle_player_list = [self.lobby.battle_liststore.get_value(scan_iter, 13)]
        self.battle_bot_list = []
                
                
        # Creating Battle Chat Window
        gtk.gdk.threads_leave()
        self.battle_vpane = self.lobby.CreateBattleChat(scan_iter)
        gtk.gdk.threads_enter()
        self.battle_vpane.show()
        self.player_vpane.pack2(self.battle_vpane, True, True)      

        # Updaing Host Button
        self.host_battle_button.handler_block(self.host_battle_button_handler_id)               
        self.host_battle_button.set_label('Leave Battle')    
        self.host_battle_button.set_active(True)
        self.host_battle_button.set_sensitive(True)    
        self.host_battle_button.handler_unblock(self.host_battle_button_handler_id)                                          

        # Updating Map
        self.game_settings['map'] = self.lobby.battle_liststore.get_value(scan_iter, 10)
        self.game_settings['map hashcode'] = self.lobby.battle_liststore.get_value(scan_iter, 9)        
        self.SearchForMap()
        
        # Updating Mod
        self.game_settings['mod'] = self.lobby.battle_liststore.get_value(scan_iter, 12)
        self.game_settings['mod hashcode'] = command[9]
        self.SearchForMod()
        
        # Updating Game Options
        self.OptionsSenstive()     
        self.start_metal_spinner.set_value(int(command[1]))
        self.start_energy_spinner.set_value(int(command[2]))
        self.max_units_spinner.set_value(int(command[3]))
        self.starting_positions.set_active(int(command[4]))
        self.game_mode.set_active(int(command[5]))
        self.limited_dgun.set_active(int(command[6]))
        self.diminishing_mms_combobox.set_active(int(command[7]))
        self.ghosted_buildings.set_active(int(command[8]))        
        
        
    def scan_for_network_game(self):
        iter = self.lobby.battle_liststore.get_iter_first()
        while iter != None:
            if self.lobby.battle_liststore.get_value(iter,0) == self.lobby.battle_id:
                return iter           
            iter = self.lobby.battle_liststore.iter_next(iter)

        
    def AbortNetworkGame(self):

        # Remove Other Players & Bots from player liststore
        scan_iter = self.player_liststore.get_iter_first()
        while scan_iter != None:
            # Bot
            if (self.player_liststore.get_value(scan_iter, 10) == None) and (self.player_liststore.get_value(scan_iter, 1) != self.player_name_online):
                if self.player_liststore.remove(scan_iter) == False:
                    break
            # Player
            elif self.player_liststore.get_value(scan_iter, 1) != self.player_name_online:                
                if self.player_liststore.remove(scan_iter) == False:
                    break
            # Update Iter Value
            else:
                scan_iter = self.player_liststore.iter_next(scan_iter)

        
        self.host = True
        self.online = False
        self.ingame = False
        
        self.lobby.battle_id = None
        self.lobby.battle_ip = None
        self.lobby.battle_port = None
        self.lobby.battle_host = None        

        
        self.UpdatePlayerName()
        self.OptionsSenstive()
                      
        self.lobby.leavebattle()
        self.battle_vpane.destroy()        
        
        self.host_battle_button.set_label('Host Battle')  
        self.host_battle_button.set_sensitive(True) 
        
        self.battle_cache = [[], []]
        for o in range(1, GLOBAL.MAX_TEAMS):
            self.battle_cache[0].append(None)
        
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
            self.ready_button.set_sensitive(True)              
            
            # Host
            if self.host == True:
                
                # Online
                if self.online == True:
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


    def UpdateBattleInfo(self, foo, local_changes=True):
        
        if local_changes == True:
            # Host
            if self.host == True:
                if foo == self.lock_battle_combobox:
                    self.game_settings['locked'] = self.lock_battle_combobox.get_active()
                
                # Online
                if self.online == True:
                    command = str(self.game_settings['Spectator Count']) + ' ' + str(self.game_settings['locked']) + ' ' + str(self.game_settings['map hashcode']) + ' ' + self.game_settings['map'] + GLOBAL.MAP_EXTENSION
                    self.lobby.updatebattleinfo(command, True)

        elif self.host != True:      
            self.game_settings['locked'] = int(foo[1])
            self.lock_battle_combobox.set_active(self.game_settings['locked'])           
            
            map = foo[3]
            for o in range(4, len(foo)):
                map = map + ' ' + foo[o]
            map = map[:-4]

            self.game_settings['map'] = map
            self.game_settings['map hashcode'] = foo[2]
            self.SearchForMap()
            

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


    def ForceTeamNumber(self, iter, value):   
        args = self.player_liststore.get_value(iter, 1) + ' ' + str(value-1)
        self.lobby.forceteamno(args)        
        

    def ForceAllyNumber(self, iter, value):
        args = self.player_liststore.get_value(iter, 1) + ' ' + str(value-1)
        self.lobby.forceallyno(args)
        
        
    def ForceTeamColor(self, iter, value):
        args = self.player_liststore.get_value(iter, 1) + ' ' + str(self.ColorEncode(value[0], value[1], value[2]))
        self.lobby.forceteamcolor(args)

        
    def UpdateBot(self, name, battlestatus, teamcolor, send=True):
        if send == True:
            args = name + ' ' + str(battlestatus) + ' ' + str(teamcolor)
            self.lobby.updatebot(args, True)
        else:
            ready, team, ally, mode, handicap, sync, side = self.BattleStatusDecode(int(battlestatus))
            team = team + 1
            ally = ally + 1
            
            red, green, blue = self.BattleStatusColorDecode(int(teamcolor))
            pixbuf = self.CreateTeamColor(team, red, green, blue)
            
            scan_iter = self.scan_for_bot(name, None)
            
            self.player_liststore.set_value(scan_iter, 2, team)
            self.player_liststore.set_value(scan_iter, 8, ally)
            self.player_liststore.set_value(scan_iter, 9, handicap)
            self.player_liststore.set_value(scan_iter, 7, self.sides[side])
            
            self.player_liststore.set_value(scan_iter, 3, red)
            self.player_liststore.set_value(scan_iter, 4, green)
            self.player_liststore.set_value(scan_iter, 5, blue)
            self.player_liststore.set_value(scan_iter, 6, pixbuf)
            
    def AddStartRect(self, allyno, position):
        left= float(position[0]) / 200
        top = float(position[1]) / 200
        right = float(position[2]) / 200
        bottom = float(position[3]) / 200
        self.battle_cache[0][int(allyno)] = [left, top, right, bottom]

    def RemoveStartRect(self, allyno):
        self.battle_cache[0][int(allyno)] = None
        
    def DisableUnits(self, foo):
        for o in range(0, len(foo)):
            self.battle_cache[1].append(foo[o])
            
    
    def EnableUnits(self, foo):
        for o in range(0, len(foo)):
            self.battle_cache[1].remove(foo[o])
            
    def EnableAllUnits(self):
        self.battle_cache[1]=[]

            
            
        
#---MyBattleStatus---#000000#FFFFFF-----------------------------------------------
    def MyBattleStatus(self, iter=None):

        if iter == None:
            iter = self.scan_for_player(self.player_name_online)

        if self.player_liststore.get_value(iter, 0) == gtk.STOCK_NO:
            ready = 0
        else:
            ready = 1
            
        team = self.player_liststore.get_value(iter, 2)            
        sync =  self.GetSyncStatus()


        if team == None:
            # Spectator
            mode = 0
            team = 0
            allyteam = 0
            bonus = 0
            side = 0
            red = 0
            green = 0
            blue = 0
        else:        
            # Non Spectator
            team = int(team) - 1
            mode = 1
            allyteam = int(self.player_liststore.get_value(iter, 8)) - 1
            bonus = int(self.player_liststore.get_value(iter, 9))
            side =  self.sides.index(self.player_liststore.get_value(iter, 7))
            
            red = int(self.player_liststore.get_value(iter, 3))
            green = int(self.player_liststore.get_value(iter, 4))
            blue = int(self.player_liststore.get_value(iter, 5))

        return ready, team, allyteam, mode, bonus, sync, side, red, green, blue
    

    def UpdateMyBattleStatus(self, iter, value):
        
        # Getting Old BattleStatus
        ready, team, ally, mode, bonus, sync, side, red, green, blue = self.MyBattleStatus(iter)

        # Updating BattleStatus
        if value[0] == 'ready':
            ready = value[1]
        elif value[0] == 'team':
            team = value[1]
        elif value[0] == 'ally':
            ally = value[1]
        elif value[0] == 'mode':
            mode = value[1]
        elif value[0] == 'bonus':
            bonus = value[1]
        elif value[0] == 'sync':
            sync = value[1]
        elif value[0] == 'side':
            side = value[1]
        elif value[0] == 'color':
            red = value[1]
            green = value[2]
            blue = value[3]
        elif value[0] == 'mode':
            if value[1] == 0:
                # Spectator
                mode = 0
                team = 0
                ally = 0
                bonus = 0
                side = 0
                red = 0
                green = 0
                blue = 0
            else:
                # Player
                mode = 1

                spare_teams, spare_allys = self.spare_team_ally_values()
                if len(spare_teams) >= 1:
                    team = spare_teams[0]
                else:
                    team = 1
                if len(spare_allys) >= 1:
                    ally = spare_allys[0]
                else:
                    ally = 1

                bonus = 0
                side = 0
                
                red, green, blue, pixbuf = self.DefaultColor(team)                

        # Encoding BattleStatus into Bitmasks
        battle_status_bitmask = self.BattleStatusEncode(ready, team, ally, mode, bonus, sync, side)
        battle_color_bitmask = self.ColorEncode(red, green, blue)
        
        # Sending MYBATTLESTATUS to lobby server
        self.lobby.mybattlestatus(battle_status_bitmask, battle_color_bitmask)


    def BattleStatusEncode(self, ready, team, allyteam, mode, bonus, sync, side):
        ## Builds a status bitmask
        Result = 0
        Result += ready<<1
        Result += team<<2
        Result += allyteam<<6
        Result += mode<<10
        Result += sync<<22
        Result += side<<24
        return Result

    
    def ClientBattleStatus(self, command):
        username = command[0]
        ready, team, ally, mode, handicap, sync, side = self.BattleStatusDecode(int(command[1]))
        red, green, blue = self.BattleStatusColorDecode(int(command[2]))
        
        team = team + 1
        ally = ally + 1
        pixbuf = self.CreateTeamColor(team, red, green, blue)
        side = self.sides[side]
        
        
        if ready == 0:
            ready = gtk.STOCK_NO
        else:
            ready = gtk.STOCK_YES
                    
        if sync == 0:
             sync = 'unitylobby-unknown-sync'
        elif sync == 1:
            sync = 'unitylobby-in-sync'
        else:
            sync = 'unitylobby-outof-sync'
                    
        iter = self.scan_for_player(command[0])
        
        if iter == None:
            iter =  self.player_liststore.append([ready, username, team, red, green, blue, pixbuf, side, ally, handicap, None, None, None, sync])
        else:
            self.player_liststore.set_value(iter, 0, ready)
            self.player_liststore.set_value(iter, 2, team)
            self.player_liststore.set_value(iter, 3, red)
            self.player_liststore.set_value(iter, 4, green)
            self.player_liststore.set_value(iter, 5, blue)
            self.player_liststore.set_value(iter, 6, pixbuf)
            self.player_liststore.set_value(iter, 7, side)
            self.player_liststore.set_value(iter, 8, ally)
            self.player_liststore.set_value(iter, 9, handicap)
            self.player_liststore.set_value(iter,13, sync)
            
        if mode == 0:
            self.SwitchToSpectator(iter)
            
        if self.host == True:
            iter = self.player_liststore.get_iter_first()
            while iter != None:
                if self.player_liststore.get_value(iter,0) == gtk.STOCK_NO:
                    break
                iter = self.player_liststore.iter_next(iter)
            if iter == None:
                self.launch_battle_button.set_sensitive(True)
            else:
                self.launch_battle_button.set_sensitive(False)

    def BattleStatusDecode(self, status):
        ## Converts a status bitmask to a tuple
        ready = (status & int('2',16)) >> 1
        team = (status & int('3C',16)) >> 2
        ally = (status & int('3C0',16)) >> 6
        mode = (status & int('400',16)) >> 10
        handicap = (status & int('23F800',16)) >> 11
        sync = (status & int('C00000',16)) >> 22
        side = (status & int('F000000',16)) >> 24
        return ready, team, ally, mode, handicap, sync, side

    def BattleStatusColorDecode(self, color):
        ## Converts a color bitmask to RGB
        red = color & 255
        green = (color & 65280) >> 8
        blue = (color & 16711680) >> 16
        return (red,green,blue)

    def ColorEncode(self, red, green, blue):
        ## Converts RGB values to a color bitmask
        Result = red
        Result+= green << 8
        Result+= blue << 16
        return Result

    def ScriptColor(self, DecodedColor):
        ## Converts RGB value to script format
        red = str(1.0/255 * DecodedColor[0])[:7]
        green = str(1.0/255 * DecodedColor[1])[:7]
        blue = str(1.0/255 * DecodedColor[2])[:7]
        return (red,green,blue)
    
    def GetSyncStatus(self, name=None):
        ## Status 0 = Unkown
        ## Status 1 = Good
        ## Status 2 = Bad
        ##  If Name = None get my sync status
        
        if name == None:
            # Work Out Client Status
            if (self.sync_status['map'] == 'Good') and (self.sync_status['mod'] == 'Good'):
                status = 1
            elif (self.sync_status['map'] == 'Unknown') or (self.sync_status['mod'] == 'Unknown'):
                status = 0
            else:
                status = 2
        else:
            # Work Out Someone Else's Status
            iter = self.scan_for_player(name)
            sync = self.player_liststore.get_value(iter, 13)
            if sync == 'unitylobby-in-sync':
                status = 1
            elif sync == 'unitylobby-outof-sync':
                status = 2
            elif sync == 'unitylobby-unknown-sync':
                status = 0
        return status


    def UpdateMySyncStatus(self, foo, status):
        ## Foo == 'map'  or 'mod'
        ## status == 'Good', 'Bad Checksum', 'Missing Map'

        # Check if Update is Needed
        if self.sync_status[foo] != status:
            self.sync_status[foo] = status
            if foo == 'map':
                self.sync_status_map_label.set_text(status)
            else:
                self.sync_status_mod_label.set_text(status)

        sync_status = self.GetSyncStatus()

        if sync_status == 0:
            self.ready_button.set_sensitive(False)
            sync_status_image = 'unitylobby-unknown-sync'
        elif sync_status == 1:
            self.ready_button.set_sensitive(True) 
            sync_status_image = 'unitylobby-in-sync'
        elif sync_status == 2:
            self.ready_button.set_sensitive(False) 
            sync_status_image = 'unitylobby-outof-sync'

        if self.online == True:
            player_name = self.player_name_online
        else:
            player_name = self.player_name_offline            

        iter = self.scan_for_player(player_name)
        if iter != None:
            self.player_liststore.set_value(iter, 13, sync_status_image)
                        
        self.player_column_0.set_cell_data_func(self.cell0a, self.treeview_sync_image)        


#---Spring Script / Monitor Code---#000000#FFFFFF-------------------------------

    def load_team_values(self, team_count, team_list, team_foo):
        team_values = []
        for o in range(0, team_count):
            team_values.append(None)
            
        
        # Load Team Values
        for o in range(0, team_count):            

            scan_iter = self.player_liststore.get_iter_first()
            while scan_iter != None:
                if o == team_foo.index(self.player_liststore.get_value(scan_iter, 2)):
                    if team_values[team_foo.index(self.player_liststore.get_value(scan_iter, 2))] == None:
                        if self.player_liststore.get_value(scan_iter, 10) != None:
                            # Bot
                            teamleader = self.battle_player_list.index(self.player_liststore.get_value(scan_iter, 11))
                            ai_location = self.player_liststore.get_value(scan_iter, 12)
                        else:
                            # Player
                            teamleader = self.battle_player_list.index(self.player_liststore.get_value(scan_iter, 1))
                            ai_location = None
                            
                            
                        # Rest
                        red = str(float(self.player_liststore.get_value(scan_iter, 3)) / 255)
                        green = str(float(self.player_liststore.get_value(scan_iter, 4)) / 255)
                        blue = str(float(self.player_liststore.get_value(scan_iter, 5)) / 255)

                        side = self.player_liststore.get_value(scan_iter, 7)
                        bonus = self.player_liststore.get_value(scan_iter, 9)                  




                        if team_values[o] == None:
                            team_values[o] = [teamleader, red, green, blue, side, bonus, ai_location]
                        else:
                            team_values[o] = [team_values[o][0], red, green, blue, side, bonus, team_values[o][6]]
                           
                    
                    
                    
                scan_iter = self.player_liststore.iter_next(scan_iter)
                



    
                    
            team_values[o] = [teamleader, red, green, blue, side, bonus, ai_location]
        return team_values


    def get_team_ally_script_values(self):
        team_list = []
        team_foo = []

                
        ally_list = []
        ally_foo = []
        ally_count = 0 - 1

        
        # Players First
        for o in range(0, len(self.battle_player_list)):
            scan_iter = self.scan_for_player(self.battle_player_list[o])
            
            old_value = self.player_liststore.get_value(scan_iter, 2)
            if old_value == None:
                team_list.append('Spectator')
            else:
                if team_foo.count(old_value) == 0:
                    team_foo.append(old_value)
                    
                team_list.append(team_foo.index(old_value))
                
                # Load Ally Old Value
                if ally_foo.count(old_value) == 0:
                    ally_foo.append(old_value)
                    ally_count = ally_count + 1
                    ally_list.append(ally_count)
                else:
                    ally_list.append(ally_foo.index(old_value))

            
        # AI Last
        for o in range(0, len(self.battle_bot_list)):
            scan_iter = self.scan_for_bot(self.battle_bot_list[o])            
            
            old_value = self.player_liststore.get_value(scan_iter, 2)
            if old_value == None:
                team_list.append('Spectator')
            else:
                if team_foo.count(old_value) == 0:
                    team_foo.append(old_value)
                    
                team_list.append(team_foo.index(old_value))
                
            # Load Ally Old Value
            if ally_foo.count(old_value) == 0:
                ally_foo.append(old_value)
                ally_count = ally_count + 1
                ally_list.append(ally_count)
            else:
                ally_list.append(ally_foo.index(old_value))

        
        # Team Count
        team_count = len(team_foo)
        
        # Team Values
        team_values = self.load_team_values(team_count, team_list, team_foo)
        
        return team_count, team_list, team_values, ally_count, ally_list
    

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
        length = len(extension) * -1 

        for i in range (0,len(self.datadirs)):
            scandir = os.path.join(self.datadirs[i],'AI','Bot-libs')
            if os.path.isdir(scandir) == True:
                file_listings = os.listdir(os.path.join(self.datadirs[i],'AI','Bot-libs'))
                for p in range (0,(len(file_listings))):
                    if file_listings[p][length:] == extension:
                        ai.append(file_listings[p][:length])
                        ai_location.append(os.path.join(self.datadirs[i],'AI','Bot-libs',file_listings[p]))

        return ai, ai_location

    def script_create(self):
    ## ==================================================================================================
    ##  Function which creates script.txt used by spring to start a game.
    ## ==================================================================================================

        # Order of Players / Teams / Allys
        if self.online == True:
            # Online
            my_player_name = self.player_name_online
            scan_iter = self.scan_for_network_game()
            self.battle_player_list = self.lobby.battle_liststore.get_value(scan_iter, 13)
        else:
            # Offline
            my_player_name = self.player_name_offline
            self.battle_player_list = [my_player_name]
            
        self.options.save_player_name(my_player_name)
            
        # Order of Teams & Allys
        team_count, team_list, team_values, ally_count, ally_list = self.get_team_ally_script_values()
        
        # My Player Number
        my_player_number = str(self.battle_player_list.index(my_player_name))
        
        # Create Script.txt
        fd_game = open(self.ini.get(self.profile, 'SPRING_SCRIPT'),'w+')
        fd_game.write('[GAME]\n')
        fd_game.write ('{\n')
        fd_game.write ('\tMapname=' +  self.game_settings['map'] + GLOBAL.MAP_EXTENSION + ';\n')
        fd_game.write ('\tStartMetal=' + str(self.game_settings['metal']) + ';\n')
        fd_game.write ('\tStartEnergy=' + str(self.game_settings['energy']) + ';\n')
        fd_game.write ('\tMaxUnits=' + str(self.game_settings['max units']) + ';\n')
        fd_game.write ('\tStartPosType=' + str(self.game_settings['starting position']) + ';\n')        
        fd_game.write ('\tGameMode=' + str(self.game_settings['game mode']) + ';\n')
        fd_game.write ('\tGameType=' + self.game_settings['mod'] + ';\n')
        fd_game.write ('\tLimitDgun=' + str(self.game_settings['limited dgun']) + ';\n');
        fd_game.write ('\tDiminishingMMs=' + str(self.game_settings['diminishing MMs']) + ';\n');
        fd_game.write ('\tGhostedBuildings=' + str(self.game_settings['ghosted Buildings']) + ';\n');
        fd_game.write ('\n')
        
        if self.online == True:
            
            fd_game.write ('\tHostIP=' + self.lobby.battle_ip + ';\n')
            fd_game.write ('\tHostPort=' + self.lobby.battle_port + ';\n')
            fd_game.write ('\tSourcePort=' + self.lobby.spring_udp_port + ';\n')

        fd_game.write ('\tMyPlayerNum=' + my_player_number + ';\n')
        fd_game.write ('\n')
        fd_game.write ('\tNumPlayers=' + str(len(self.battle_player_list)) + ';\n')
        fd_game.write ('\tNumTeams=' + str(team_count) + ';\n')
        fd_game.write ('\tNumAllyTeams=' + str(len(ally_list)+ 1) + ';\n')

        # Player
        fd_game.write ('\n')
        for o in range(0,len(self.battle_player_list)):
            fd_game.write ('\t[PLAYER' + str(o) + ']\n')
            fd_game.write ('\t{\n')
            fd_game.write ('\t\tname=' + self.battle_player_list[o] + ';\n')
            scan_iter = self.scan_for_player(self.battle_player_list[o])
            if self.player_liststore.get_value(scan_iter, 2) != None:
                fd_game.write ('\t\tSpectator=0;\n')
                fd_game.write ('\t\tTeam=' + str(team_list[o]) + ';\n')
            else:
                fd_game.write ('\t\tSpectator=1;\n')
            fd_game.write ('\t}\n')

        # Teams team_values[o] = [teamleader, red, green, blue, side, bonus, ai_location]
        fd_game.write ('\n')
        for o in range(0, team_count):

            fd_game.write ('\t[TEAM' + str(o) + ']\n')
            fd_game.write ('\t{\n')
            fd_game.write ('\t\tTeamLeader=' + str(team_values[o][0]) + ';\n')
            fd_game.write ('\t\tAllyTeam=' + str(ally_list[o]) + ';\n')
            fd_game.write ('\t\tRgbColor=' + team_values[o][1] + ' ' + team_values[o][2] + ' ' + team_values[o][3] + ';\n')
            fd_game.write ('\t\tSide='+ team_values[o][4] + ';\n')
            fd_game.write ('\t\tHandicap='+ team_values[o][5] + ';\n')
            if team_values[o][6] != None:
                fd_game.write('\t\tAiDLL=' + team_values[o][6] + ';\n')
            fd_game.write ('\t}\n')


        # Ally Teams
        fd_game.write ('\n')
        for o in range(0, (ally_count+1)):
            fd_game.write ('\t[ALLYTEAM' + str(o) + ']\n')
            fd_game.write ('\t{\n')
            fd_game.write ('\t\tNumAllies=0;\n') # What the hell is this for??????/
            if self.battle_cache[0][o] != None:
                fd_game.write ('\t\tStartRectTop=' + str(self.battle_cache[0][o][1]) + ';\n')
                fd_game.write ('\t\tStartRectLeft=' + str(self.battle_cache[0][o][0]) + ';\n')
                fd_game.write ('\t\tStartRectBottom=' + str(self.battle_cache[0][o][3]) + ';\n')
                fd_game.write ('\t\tStartRectRight=' + str(self.battle_cache[0][o][2]) + ';\n')
            fd_game.write ('\t}\n')
            
        # Unit Restrictions
        fd_game.write ('\n')
        if self.battle_cache[1] != None:
            fd_game.write ('NumRestrictions=' + str(len(self.battle_cache[1])) + ';\n')
            fd_game.write ('\t[RESTRICT]\n')
            fd_game.write ('\t{\n')
            for o in range(0, len(self.battle_cache[1])):
                fd_game.write('\t\tUnit' + str(o) + '=' + self.battle_cache[1][o] + ';\n')
                fd_game.write('\t\tLimit' + str(o) + '=0;\n')
                fd_game.write ('\n')
            fd_game.write ('\t}\n')

        # End of File
        fd_game.write ('}\n')
        fd_game.close()


    def launch_spring(self, widget=None, event=None):
    ## ==================================================================================================
    ##  Function to start SpringLauncher Threaded Class
    ##   Also Updates ~/.springrc to correct name value
    ## ==================================================================================================
    
        if self.host == True:
            self.launch_battle_button.set_sensitive(False)
            self.launch_battle_button.set_label('Launching Battle')
            

        self.script_create()
        spring = self.ini.get(self.profile, 'SPRING_BINARY')
        script = self.ini.get(self.profile, 'SPRING_SCRIPT')
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
                if self.online == True:
                    self.lobby.mystatus('1', True)
                    self.player_update_status(None)
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


            os.waitpid(self.pid, os.WNOHANG)
            self.launch_battle_button.set_label('Battle Underway')
            # TODO: Can add signal error code for GUI to translate reason of spring crashing
    
            try:
                os.kill(self.pid, 0)

            except:
                self.pid = None
                self.ingame = False
                gtk.gdk.threads_enter()
                if self.online == True:
                    self.lobby.mystatus('0', True)
                self.OptionsSenstive()
                self.launch_battle_button.set_label('Start Battle')
                if self.host == True:
                    self.ready_button.set_sensitive(True)
                self.spring_launcher.stop()
                gtk.gdk.threads_leave()        
                
        
        except Exception, inst:
            print
            print 'CheckSpringPID'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


