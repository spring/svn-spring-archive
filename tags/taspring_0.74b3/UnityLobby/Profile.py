#!/usr/bin/env python

#======================================================
 #            Profile.py
 #
 #  Thurs September 7 11:20 2006
 #  Copyright  2006  Josh Mattila
 #  		          Declan Ireland
 #  Other authors may add their names above!
 #
 #  deco_ireland2@yahoo.ie
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
   
class assistant:
    def __init__(self, setup_profiles):
        self.setup_profiles = setup_profiles
        self.assistant = gtk.Assistant()
        self.assistant.connect('delete_event', self.delete)
        self.assistant.connect('close', self.close)
                
        ## Construct Page 0
        vbox_0 = gtk.VBox(False, 5)
        vbox_0.set_border_width(5)
        vbox_0.show()
        
        profile_name = gtk.Entry(max=0)
        profile_name.show()
        profile_name.connect('changed', self.check_profile_name)
        vbox_0.pack_start(profile_name, True, True, 0)        
            
        self.assistant.append_page(vbox_0)
        self.assistant.set_page_title(vbox_0, 'Profile Name')
        self.assistant.set_page_type(vbox_0, gtk.ASSISTANT_PAGE_CONTENT)
        
        
        ## Construct Page 1
        vbox_1 = gtk.VBox(False, 5)
        vbox_1.set_border_width(5)
        vbox_1.show()
        
        spring_binary_location = gtk.Entry(max=0)
        spring_binary_location.show()
        spring_binary_location.connect('changed', self.check_spring_binary)
        vbox_1.pack_start(spring_binary_location, True, True, 0)        
            
        self.assistant.append_page(vbox_1)
        self.assistant.set_page_title(vbox_1, 'Spring Excuteable Location')
        self.assistant.set_page_type(vbox_1, gtk.ASSISTANT_PAGE_CONTENT)
                
        ## Construct Page 2
        vbox_2 = gtk.VBox(False, 5)
        vbox_2.set_border_width(5)
        vbox_2.show()

        spring_datadir_location = gtk.Entry(max=0)
        spring_datadir_location.show()
        spring_datadir_location.connect('changed', self.check_spring_datadir)
        vbox_2.pack_start(spring_datadir_location, True, True, 0)
        
        self.assistant.append_page(vbox_2)
        self.assistant.set_page_title(vbox_2, 'Spring Datadir Location')
        self.assistant.set_page_type(vbox_2, gtk.ASSISTANT_PAGE_CONTENT)
                
        ## Contstruct Page 3
        
        vbox_3 = gtk.VBox(False, 5)
        vbox_3.set_border_width(5)
        vbox_3.show()

        label = gtk.Label("UnityLobby is still under development & multiplayer is not yet in working condition.")
        label.show()
        vbox_3.pack_start(label, True, True, 0)
        
        self.assistant.append_page(vbox_3)
        self.assistant.set_page_title(vbox_3, "Author's Notes")
        self.assistant.set_page_type(vbox_3, gtk.ASSISTANT_PAGE_SUMMARY)
        self.assistant.show()
        
    def check_profile_name(self, entry):
        profile_name = entry.get_text()
        test = True
        for i in range (0,len(self.setup_profiles)):
            if self.setup_profiles[i] == profile_name:
                test = False
                break
        if test == True:
            self.assistant.set_page_complete(entry.get_parent(), True)
        else:
            self.assistant.set_page_complete(entry.get_parent(), False)
            
    def check_spring_binary(self, entry):
        spring_excutable = entry.get_text()
        # TODO: Fix Add Code to scan system paths for relative spring filename
        if os.path.isfile(spring_excutable) == True:
            self.assistant.set_page_complete(entry.get_parent(), True)
        else:
            self.assistant.set_page_complete(entry.get_parent(), False)              
            
    def check_spring_datadir(self, entry):
        ## Checks to see if entry.get_text() == a directory
        spring_datadir = entry.get_text()
        if os.path.isdir(spring_datadir) == True:
            self.assistant.set_page_complete(entry.get_parent(), True)
        else:
            self.assistant.set_page_complete(entry.get_parent(), False)
            
    def get_profile_values(self):
        if self.assistant.get_current_page() == -1:
            profile_name = ((self.assistant.get_nth_page(0)).get_children()[0]).get_text()
            spring_binary = ((self.assistant.get_nth_page(1)).get_children()[0]).get_text()
            spring_datadir = ((self.assistant.get_nth_page(2)).get_children()[0]).get_text()
        else:
            profile_name = None
            spring_binary = None
            spring_datadir = None
        return profile_name, spring_binary, spring_datadir
    
    def close(self, widget):
        self.assistant.hide()
        gtk.main_quit()

    def delete(self, widget, event):
        gtk.main_quit()
        
    def main(self):
            self.assistant.show()
            gtk.main()
            
class profile:
    def __init__(self, unity_location, setup, show):
        self.platform = sys.platform
        self.show = show
        self.setup = setup
        self.unity_location = unity_location

        ## Detect Profiles
        self.setup_profiles = []
        if self.platform != 'win32':
            ## Linux
            self.home = os.environ['HOME']
            self.setup_dir = os.path.join(self.home, '.unity-lobby', 'profiles')
            self.setup_ini = os.path.join(self.setup_dir, 'setup.ini')
        else:
            ## Windows
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


        ## Remove Old Profiles
        old_profiles = []

        for i in range(0,len(self.setup_profiles)):
            if setup_file.has_option(self.setup_profiles[i], 'VERSION') == False:
                setup_file.set(self.setup_profiles[i], 'VERSION', '0')

            version_check = setup_file.get(self.setup_profiles[i], 'VERSION')
            if version_check != '3.02':
                old_profiles.append(self.setup_profiles[i])
                profile_dir = os.path.join(self.setup_dir, self.setup_profiles[i])	
                setup_file.remove_section(self.setup_profiles[i])
                if os.path.isdir(profile_dir) == True:
                    shutil.rmtree(profile_dir)

        for i in range(0,len(old_profiles)):
            self.setup_profiles.remove(old_profiles[i])
            setup_file.remove_section(old_profiles[i])
            setup_file.write(open(self.setup_ini, "w+"))
            setup_file.read(self.setup_ini)


        ## WTF is this ??
        if self.setup_profiles == []:
            if os.path.isfile(os.path.join(self.unity_location, 'profiles', 'setup.ini')) == True:
                self.create_default_profile()

                
    def main(self):
        if (len(self.setup_profiles) >= 2 or self.show == True) and self.setup == False:
            self.create_profile_selection_gui()
            self.window.show()
            gtk.main()
            
        elif len(self.setup_profiles) == 0 or self.setup == True:
            self.wizard = assistant(self.setup_profiles)
            self.wizard.main()
            profile_name, spring_binary, spring_datadir = self.wizard.get_profile_values()
            if profile_name != None:
                self.create_setup_file()
                self.save_profile(profile_name, spring_binary, spring_datadir)
                unity = os.path.join(self.unity_location, 'client', 'main.py')
                os.spawnlp(os.P_NOWAIT, unity, unity, '-p', profile_name)     
        else:
            unity = os.path.join(self.unity_location, 'client', 'main.py')
            os.spawnlp(os.P_NOWAIT, unity, unity, '-p', self.setup_profiles[0])
            
            
    def create_profile_selection_gui(self):

            ## Main Window
            self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
            self.window.set_title("Unity Lobby -> Profile Selection")
            self.window.connect("delete-event", gtk.main_quit)
            self.window.add_events(gtk.gdk.BUTTON_PRESS_MASK)

            ## Vertical Box Part 1/2
            vbox = gtk.VBox(False, 0)
            vbox.show()
            self.window.add(vbox)

            ## Menu Part 1/2
            menu_bar = gtk.MenuBar()
            menu_bar.show()

            ## Frame - Select Profile Frame
            select_profile_frame = gtk.Frame(label=None)
            select_profile_frame.show()
            vbox.pack_start(select_profile_frame, True, True, 2)

            ## Select Profile Window (scrolled)
            select_profile_window = gtk.ScrolledWindow()
            select_profile_window.set_border_width(10)
            select_profile_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
            select_profile_window.show()
            select_profile_frame.add(select_profile_window)
            
            ## Select Profile ListStore
                ## Profile Name       = String
            self.select_profile_liststore = gtk.ListStore(str)
            self.select_profile_treeview = gtk.TreeView(self.select_profile_liststore)
            select_profile_column_1 = gtk.TreeViewColumn('Profile')
            self.select_profile_treeview.append_column(select_profile_column_1)
            select_profile_window.add(self.select_profile_treeview)
            self.select_profile_treeview.show()

            for i in range(0,len(self.setup_profiles)):
                self.select_profile_liststore.append([self.setup_profiles[i]])

            ## Add Mouse Click event to select_profile_treeview
            self.select_profile_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
            self.select_profile_treeview.connect('event', self.profile_selection)

            ## Create a CellRenderers to render the data
            self.cell1  = gtk.CellRendererText()

            ## add the cells to the columns
            select_profile_column_1.pack_start(self.cell1, False)

            ## set the cell attributes to the appropriate liststore column
            select_profile_column_1.set_attributes(self.cell1, text=0)

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
                elif event.button == 3:
                    config = ConfigParser.ConfigParser()
                    config.optionxform = lambda x: x
                    config.read(self.setup_ini)

                    self.profile = self.select_profile_liststore.get_value(iter, 0)
                    self.map_index = config.get(self.profile, 'MAP_INDEX', None)
                    self.mod_index = config.get(self.profile, 'MOD_INDEX', None)
                    ## Main Menu
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
            
    def save_profile(self, profile_name, spring_binary, spring_datadir):
        setup_profile_dir = os.path.join(self.setup_dir, profile_name)

        config = ConfigParser.ConfigParser()
        config.optionxform = lambda x: x
        config.read(self.setup_ini)

        self.select_profile_liststore.append([profile_name])
        config.add_section(profile_name)
        if os.path.isdir(setup_profile_dir) == True:
            os.rmdir(setup_profile_dir)
        os.mkdir(setup_profile_dir)

        config.set(profile_name, 'LOBBY_CONF', os.path.join(self.setup_dir, 'lobby.ini'))
        config.set(profile_name, 'SPRING_BINARY', spring_binary)
        config.set(profile_name, 'SPRING_DATADIR',  spring_datadir)
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
        config.set(profile_name, 'LOBBY_PREFERENCES_WINDOW_HEIGHT', 553)
        config.set(profile_name, 'LOBBY_PREFERENCES_WINDOW_WIDTH', 977)        
        config.set(profile_name, 'OPTIONS_WINDOW_HEIGHT', 254)
        config.set(profile_name, 'OPTIONS_WINDOW_WIDTH', 359)


        if self.platform != 'win32':
            ## Linux
            config.set(profile_name, 'SPRING_CONF', os.path.join(self.home, '.springrc'))
        else:
            ## Windows
            pass

        config.set(profile_name, 'VERSION', '3.02')
        config.set(profile_name, 'STARTUP', '1')
        config.write(open(self.setup_ini, "w+"))

    def profile_delete(self, widget, event):
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
    from optparse import OptionParser

    unity_location = sys.path[0]

    parser = OptionParser()
    parser.add_option("-s", "--profile-setup", action="store_true", dest="profile_setup", default=False, help="Startup Profile Setup")    
    parser.add_option("-p", "--profile-selection", action="store_true", dest="profile_selection", default=False, help="Startup Profile Selection")
    (options, args) = parser.parse_args()

    profile = profile(unity_location, options.profile_setup, options.profile_selection)
    profile.create_profile_selection_gui()
    profile.main()