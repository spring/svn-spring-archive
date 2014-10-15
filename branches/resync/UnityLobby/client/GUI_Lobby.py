#!/usr/bin/env python

#======================================================
 #            GUI_Lobby.py
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
import gtk
import gobject
import os
import os.path


# Custom Modules
import GLOBAL
import Lobby

from Misc import create_page, label_create, combobox_setup, spinner_create


class preferences:

    def __init__(self, gui_lobby, lobby_ini, lobby_ini_file):
        
        self.spring_logo_pixbuf = gui_lobby.spring_logo_pixbuf
        self.gui_lobby = gui_lobby
        
        self.ini =  gui_lobby.ini
        self.ini_file = gui_lobby.ini_file
        self.profile = gui_lobby.profile

        self.lobby_ini = lobby_ini
        self.lobby_ini_file = lobby_ini_file
        

    def create(self):
        
        options = self.load_options()
        # Main Window
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_icon_list(self.spring_logo_pixbuf)
        self.window.set_title("Lobby Preferences")
        self.window.connect("delete-event", self.destroy)
        
        self.window.resize(self.ini.getint(self.profile, 'LOBBY_PREFERENCES_WINDOW_WIDTH'), self.ini.getint(self.profile, 'LOBBY_PREFERENCES_WINDOW_HEIGHT'))        

            # Table
        table = gtk.Table(rows=2, columns=2, homogeneous=False)
        table.show()
        self.window.add(table)

                # Category Window (scrolled)
        category_window = gtk.ScrolledWindow()
        category_window.set_border_width(10)
        category_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        category_window.show()

        self.category_treestore = gtk.TreeStore(str)
        self.category_treeview = gtk.TreeView(self.category_treestore)

        self.category_column_0 = gtk.TreeViewColumn('Categories')
        self.category_treeview.append_column(self.category_column_0)
        category_window.add(self.category_treeview)
        self.category_treeview.show()

        selection = self.category_treeview.get_selection()
        selection.connect('changed', self.on_selection_changed)

        self.category_cell_0  = gtk.CellRendererText()
        self.category_column_0.pack_start(self.category_cell_0, False)
        self.category_column_0.set_attributes(self.category_cell_0, text=0)

        iter = self.category_treestore.append(None, ['Interface'])
        self.category_treestore.append(iter, ['Text box'])
        self.category_treestore.append(iter, ['Input box'])
        self.category_treestore.append(iter, ['User list'])
        self.category_treestore.append(iter, ['Tabs'])
        self.category_treestore.append(iter, ['Colors'])
        iter = self.category_treestore.append(None, ['Chatting'])
        self.category_treestore.append(iter, ['General'])
        self.category_treestore.append(iter, ['Logging'])
        self.category_treestore.append(iter, ['Sound'])
        iter = self.category_treestore.append(None, ['Network'])
        self.category_treestore.append(iter, ['Add Lobby Server'])
        self.category_treestore.append(iter, ['List Lobby Servers'])

                # Interface - Colors
        self.interface_colors_frame = gtk.Frame('Colors')
        self.interface_colors_frame.set_border_width(10)

                    # Table
        interface_colors_table = gtk.Table(rows=1,columns=1, homogeneous=False)
        interface_colors_table.show()
        self.interface_colors_frame.add(interface_colors_table)

                    # Label -> Text Colors
        text_colors_label = gtk.Label()
        text_colors_label.set_markup("<b>Text Colors</b>")
        text_colors_label.set_alignment(0.1,1)
        text_colors_label.show()
        interface_colors_table.attach(text_colors_label, 0,1,0,1)

                        # Text Color
        text_label = label_create("Text")
        text_label.set_alignment(0.2,0.5)
        text_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Text'][0], options['Text'][1], options['Text'][2]))
        text_colorbutton.connect("color-set", self.save_color, 'Text')
        text_colorbutton.set_title("Text")
        text_colorbutton.show()
        
        interface_colors_table.attach(text_label, 0,1,1,2)
        interface_colors_table.attach(text_colorbutton, 1,2,1,2, gtk.FILL, gtk.FILL,0,0)

                        # Text Actions
        text_actions_label = label_create("Actions")
        text_actions_label.set_alignment(0.2,0.5)
        text_actions_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Action'][0], options['Action'][1], options['Action'][2]))
        text_actions_colorbutton.connect("color-set", self.save_color, 'Action')
        text_actions_colorbutton.set_title("Actions")
        text_actions_colorbutton.show()
        
        interface_colors_table.attach(text_actions_label, 2,3,1,2)
        interface_colors_table.attach(text_actions_colorbutton, 3,4,1,2, gtk.FILL, gtk.FILL,0,0)

                        # Join
        text_join_label = label_create("Join")
        text_join_label.set_alignment(0.2,0.5)
        text_join_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Join'][0], options['Join'][1], options['Join'][2]))
        text_join_colorbutton.connect("color-set", self.save_color, 'Join')
        text_join_colorbutton.set_title("Join")
        text_join_colorbutton.show()
        
        interface_colors_table.attach(text_join_label, 0,1,2,3)
        interface_colors_table.attach(text_join_colorbutton, 1,2,2,3, gtk.FILL, gtk.FILL,0,0)

                        # Leave
        text_leave_label = label_create("Leave")
        text_leave_label.set_alignment(0.2,0.5)
        text_leave_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Leave'][0], options['Leave'][1], options['Leave'][2]))
        text_leave_colorbutton.connect("color-set", self.save_color, 'Leave')
        text_leave_colorbutton.set_title("Leave")
        text_leave_colorbutton.show()

        interface_colors_table.attach(text_leave_label, 2,3,2,3)
        interface_colors_table.attach(text_leave_colorbutton, 3,4,2,3, gtk.FILL, gtk.FILL,0,0)

                        # Text Highlighting
        text_highlight_label = label_create("Highlight")
        text_highlight_label.set_alignment(0.2,0.5)
        text_highlight_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Highlight'][0], options['Highlight'][1], options['Highlight'][2]))
        text_highlight_colorbutton.connect("color-set", self.save_color, 'Highlight')
        text_highlight_colorbutton.set_title("Highlight")
        text_highlight_colorbutton.show()
        
        interface_colors_table.attach(text_highlight_label, 0,1,3,4)
        interface_colors_table.attach(text_highlight_colorbutton, 1,2,3,4, gtk.FILL, gtk.FILL,0,0)

                        # MOTD
        text_motd_label = label_create("MOTD")
        text_motd_label.set_alignment(0.2,0.5)
        text_motd_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['MOTD'][0], options['MOTD'][1], options['MOTD'][2]))
        text_motd_colorbutton.connect("color-set", self.save_color, 'MOTD')
        text_motd_colorbutton.set_title("MOTD")
        text_motd_colorbutton.show()
        
        interface_colors_table.attach(text_motd_label, 0,1,4,5)
        interface_colors_table.attach(text_motd_colorbutton, 1,2,4,5, gtk.FILL, gtk.FILL,0,0)

                        # Channel Topic
        text_channeltopic_label = label_create("Channel Topic")
        text_channeltopic_label.set_alignment(0.2,0.5)
        text_channeltopic_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Channel Topic'][0], options['Channel Topic'][1], options['Channel Topic'][2]))
        text_channeltopic_colorbutton.connect("color-set", self.save_color, 'Channel Topic')
        text_channeltopic_colorbutton.show()
        
        interface_colors_table.attach(text_channeltopic_label, 2,3,4,5)
        interface_colors_table.attach(text_channeltopic_colorbutton, 3,4,4,5, gtk.FILL, gtk.FILL,0,0)

                        # Server Msg
        text_servermsg_label = label_create("Server Message")
        text_servermsg_label.set_alignment(0.2,0.5)
        text_servermsg_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Server Message'][0], options['Server Message'][1], options['Server Message'][2]))
        text_servermsg_colorbutton.connect("color-set", self.save_color, 'Server Message')
        text_servermsg_colorbutton.set_title("Server Message")
        text_servermsg_colorbutton.show()
        
        interface_colors_table.attach(text_servermsg_label, 0,1,5,6)
        interface_colors_table.attach(text_servermsg_colorbutton, 1,2,5,6, gtk.FILL, gtk.FILL,0,0)

                        # Server Broadcast
        text_serverbroadcast_label = label_create("Server Broadcast")
        text_serverbroadcast_label.set_alignment(0.2,0.5)
        text_serverbroadcast_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Server Broadcast'][0], options['Server Broadcast'][1], options['Server Broadcast'][2]))
        text_serverbroadcast_colorbutton.connect("color-set", self.save_color, 'Server Broadcast')
        text_serverbroadcast_colorbutton.set_title("Server Broadcast")
        text_serverbroadcast_colorbutton.show()
        
        interface_colors_table.attach(text_serverbroadcast_label, 2,3,5,6)
        interface_colors_table.attach(text_serverbroadcast_colorbutton, 3,4,5,6, gtk.FILL, gtk.FILL,0,0)

                # Label -> Interface Colors
        text_colors_label = gtk.Label()
        text_colors_label.set_markup("<b>Interface Colors</b>")
        text_colors_label.show()
        text_colors_label.set_alignment(0.1,1)
        interface_colors_table.attach(text_colors_label, 0,1,7,8)

                        # User Present
        user_present_label = label_create("User Present")
        user_present_label.set_alignment(0.2,0.5)
        user_present_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['User Present'][0], options['User Present'][1], options['User Present'][2]))
        user_present_colorbutton.connect("color-set", self.save_color, 'User Present')
        user_present_colorbutton.set_title("User Present")
        user_present_colorbutton.show()
        
        interface_colors_table.attach(user_present_label, 0,1,8,9)
        interface_colors_table.attach(user_present_colorbutton, 1,2,8,9, gtk.FILL, gtk.FILL,0,0)

                        # User InGame
        user_ingame_label = label_create("User InGame")
        user_ingame_label.set_alignment(0.2,0.5)
        user_ingame_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['User InGame'][0], options['User InGame'][1], options['User InGame'][2]))
        user_ingame_colorbutton.connect("color-set", self.save_color, 'User InGame')
        user_ingame_colorbutton.set_title("User InGame")
        user_ingame_colorbutton.show()
        
        interface_colors_table.attach(user_ingame_label, 2,3,8,9)
        interface_colors_table.attach(user_ingame_colorbutton, 3,4,8,9, gtk.FILL, gtk.FILL,0,0)

                        # User AFK
        user_afk_label = label_create("User AFK")
        user_afk_label.set_alignment(0.2,0.5)
        user_afk_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['User AFK'][0], options['User AFK'][1], options['User AFK'][2]))
        user_afk_colorbutton.connect("color-set", self.save_color, 'User AFK')
        user_afk_colorbutton.set_title("User AFK")
        user_afk_colorbutton.show()
        
        interface_colors_table.attach(user_afk_label, 0,1,9,10)
        interface_colors_table.attach(user_afk_colorbutton, 1,2,9,10, gtk.FILL, gtk.FILL,0,0)

                        # Battle
        battle_label = label_create("Battle")
        battle_label.set_alignment(0.2,0.5)
        battle_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Battle'][0], options['Battle'][1], options['Battle'][2]))
        battle_colorbutton.connect("color-set", self.save_color, 'Battle')
        battle_colorbutton.set_title("Battle")
        battle_colorbutton.show()
        
        interface_colors_table.attach(battle_label, 0,1,11,12)
        interface_colors_table.attach(battle_colorbutton, 1,2,11,12, gtk.FILL, gtk.FILL,0,0)

                        # Battle In Progress
        battle_inprogress_label = label_create("Battle In Progress")
        battle_inprogress_label.set_alignment(0.2,0.5)
        battle_inprogress_colorbutton = gtk.ColorButton(color=gtk.gdk.Color(options['Battle In Progress'][0], options['Battle In Progress'][1], options['Battle In Progress'][2]))
        battle_inprogress_colorbutton.connect("color-set", self.save_color, 'Battle In Progress')
        battle_inprogress_colorbutton.set_title("Battle")
        battle_inprogress_colorbutton.show()
        
        interface_colors_table.attach(battle_inprogress_label, 2,3,11,12)
        interface_colors_table.attach(battle_inprogress_colorbutton, 3,4,11,12, gtk.FILL, gtk.FILL,0,0)
        

                # Lobby - Server List
        self.lobby_server_list_frame = gtk.Frame('Lobby Server List')
        self.lobby_server_list_frame.set_border_width(10)

                    # Select Profile Window (scrolled)
        lobby_server_list_window = gtk.ScrolledWindow()
        lobby_server_list_window.set_border_width(10)
        lobby_server_list_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        lobby_server_list_window.show()
        self.lobby_server_list_frame.add(lobby_server_list_window)
                    # Select Profile ListStore
                      # Profile Name       = String
        self.lobby_server_list_liststore = gtk.ListStore(str)
        self.lobby_server_list_treeview = gtk.TreeView(self.lobby_server_list_liststore)
        self.lobby_server_list_treeview.set_headers_visible(False)
        lobby_server_list_column_1 = gtk.TreeViewColumn('Server')
        self.lobby_server_list_treeview.append_column(lobby_server_list_column_1)
        lobby_server_list_window.add(self.lobby_server_list_treeview)
        self.lobby_server_list_treeview.show()

        server_list = self.lobby_ini.sections()
        i = 0
        while i < len(server_list):
            if server_list[i] == 'COLORS':
                server_list.pop(i)
            else:
                i = i + 1
        for i in range(0,len(server_list)):
            self.lobby_server_list_liststore.append([server_list[i]])


                    # Add Mouse Click event to select_profile_treeview
        self.lobby_server_list_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
        self.lobby_server_list_treeview.connect('event', self.server_selection)

                        # create a CellRenderers to render the data
        cell1  = gtk.CellRendererText()

                        # add the cells to the columns
        lobby_server_list_column_1.pack_start(cell1, False)

                        # set the cell attributes to the appropriate liststore column
        lobby_server_list_column_1.set_attributes(cell1, text=0)


                # Lobby - Add Server
        self.lobby_add_server_frame = gtk.Frame('Add Lobby Server')
        self.lobby_add_server_frame.set_border_width(10)

                    # Table
        lobby_add_server_table = gtk.Table(rows=1,columns=1, homogeneous=False)
        lobby_add_server_table.show()
        self.lobby_add_server_frame.add(lobby_add_server_table)

                        # Server Address
        server_address_label = label_create("Server")
        self.server_address_entry = gtk.Entry(max=0)
        self.server_address_entry.set_text(GLOBAL.Lobby_Server)
        self.server_address_entry.show()
        lobby_add_server_table.attach(server_address_label, 0,1,0,1)
        lobby_add_server_table.attach(self.server_address_entry, 1,2,0,1)

                        # Server Port
        server_port_label = label_create("Port")
        server_port_adjustment = gtk.Adjustment(GLOBAL.Lobby_Server_Port, lower=0, upper=65535, step_incr=100, page_incr=1000, page_size=0)
        self.server_port_spinner = gtk.SpinButton(server_port_adjustment, 0, 0)
        self.server_port_spinner.show()
        lobby_add_server_table.attach(server_port_label, 0,1,1,2)
        lobby_add_server_table.attach(self.server_port_spinner, 1,2,1,2)

                        # Spring UDP Port
        spring_udp_port_label = label_create("Spring UDP Port")
        spring_udp_port_adjustment = gtk.Adjustment(GLOBAL.Spring_UDP_Port, lower=0, upper=65535, step_incr=100, page_incr=1000, page_size=0)
        self.spring_udp_port_spinner = gtk.SpinButton(spring_udp_port_adjustment, 0, 0)
        self.spring_udp_port_spinner.show()
        lobby_add_server_table.attach(spring_udp_port_label, 0,1,2,3)
        lobby_add_server_table.attach(self.spring_udp_port_spinner, 1,2,2,3)

                        # User Name
        username_label = label_create("User Name")
        self.username_entry = gtk.Entry(max=0)
        self.username_entry.show()
        lobby_add_server_table.attach(username_label, 0,1,3,4)
        lobby_add_server_table.attach(self.username_entry, 1,2,3,4)

                        # Password
        password_label = label_create("Password")
        self.password_entry = gtk.Entry(max=0)
        self.password_entry.set_visibility(False)
        self.password_entry.show()
        lobby_add_server_table.attach(password_label, 0,1,4,5)
        lobby_add_server_table.attach(self.password_entry, 1,2,4,5)

                        # Button -> Add
        lobby_add_button = gtk.Button(label=None, stock=gtk.STOCK_ADD)
        lobby_add_button.connect("clicked", self.add_lobby_server)
        lobby_add_button.show()
        lobby_add_server_table.attach(lobby_add_button, 0,1,5,6)

                        # Button -> Registry
        lobby_registry_button = gtk.Button(label="Register Account", stock=None)
        lobby_registry_button.connect("clicked", self.register_account)
        lobby_registry_button.show()
        lobby_add_server_table.attach(lobby_registry_button, 1,2,5,6)


        vbox = gtk.VBox(homogeneous=False, spacing=0)
        vbox.show()

        # Vertical Pane
        hpane = gtk.HPaned()
        table.attach(hpane, 0,1,1,2)
        hpane.show()

        hpane.pack1(category_window, True, True)
        hpane.pack2(vbox, True, True)

        vbox.pack_end(self.interface_colors_frame, expand=True, fill=True, padding=0)
        vbox.pack_end(self.lobby_server_list_frame, expand=True, fill=True, padding=0)
        vbox.pack_end(self.lobby_add_server_frame, expand=True, fill=True, padding=0)


        self.show_colors_frame()

    def hide(self):
        width, height = self.window.get_size()
        
        self.ini.set(self.profile, 'LOBBY_PREFERENCES_WINDOW_WIDTH', width)
        self.ini.set(self.profile, 'LOBBY_PREFERENCES_WINDOW_HEIGHT', height)
        self.ini.write(open(self.ini_file, "w+"))
        self.ini.read(self.ini_file)        
        
        self.window.hide()


    def show(self, data=None):
        
        self.window.show()


    def destroy(self, window, event):
        
        self.hide()
        return True


    def show_text_box_frame(self):
        # TODO: Add code for show text box frame
        pass


    def show_input_box_frame(self):
        # TODO: Add code for show_input_box_frame
        pass


    def show_user_list_frame(self):
        # TODO: Add code for show_user_list_frame
        pass


    def show_tabs_frame(self):
        # TODO: Add code for show_tabs_frame
        pass


    def show_colors_frame(self):
        
        self.lobby_server_list_frame.hide()
        self.lobby_add_server_frame.hide()
        self.interface_colors_frame.show()


    def show_general_frame(self):
        # TODO: Add code for show_general_frame
        pass


    def show_logging_frame(self):
        # TODO: Add code for show_logging_frame
        pass


    def show_sound_frame(self):
        # TODO: Add code for show_sound_frame
        pass


    def show_add_lobby_server_frame(self):
        
        self.interface_colors_frame.hide()
        self.lobby_server_list_frame.hide()
        self.lobby_add_server_frame.show()


    def show_list_lobby_servers_frame(self):
        
        self.interface_colors_frame.hide()
        self.lobby_add_server_frame.hide()
        self.lobby_server_list_frame.show()


    def update_frame(self, widget, event):
        
        treeselection = self.category_treeview.get_selection()
        (model, iter) = treeselection.get_selected()
        if iter != None:
            frame = self.category_treestore.get_value(iter, 0)


    def on_selection_changed(self, selection): 
        
        model, paths = selection.get_selected_rows()
        if paths:
            iter = self.category_treestore.get_iter(paths[0])
            category = self.category_treestore.get_value(iter, 0)
            if category == 'Text box':
                self.show_text_box_frame()
            elif category == 'Input box':
                self.show_input_box_frame()
            elif category == 'User list':
                self.show_user_list_frame()
            elif category == 'Tabs':
                self.show_tabs_frame()
            elif category == 'Colors':
                self.show_colors_frame()	
            elif category == 'General':
                self.show_general_frame()
            elif category == 'Logging':
                self.show_logging_frame()
            elif category == 'Sound':
                self.show_sound_frame()
            elif category == 'Add Lobby Server':
                self.show_add_lobby_server_frame()
            elif category == 'List Lobby Servers':
                self.show_list_lobby_servers_frame()


    def server_selection(self, widget, event):
        
        treeselection = self.lobby_server_list_treeview.get_selection()
        (model, iter) = treeselection.get_selected()
        if iter != None:
            if event.type == gtk.gdk.BUTTON_PRESS:
                if event.button == 3:
                    # Main Menu
                    menu = gtk.Menu()
                    menu.show()
                    default_item = gtk.MenuItem("Set as Default Server")
                    remove_item = gtk.MenuItem("Remove from Server List")
                    menu.append(default_item)
                    menu.append(remove_item)
                    default_item.show()
                    remove_item.show()
                    default_item.connect("button_press_event", self.default_lobby_server, iter)
                    remove_item.connect("button_press_event", self.delete_lobby_server, iter)
                    menu.popup(None, None, None, event.button, event.time)


    def register_account(self, button):
        
        import md5
        import base64

        server_address = self.server_address_entry.get_text()
        u = md5.new(self.password_entry.get_text()).digest()
        encoded_password = base64.encodestring(u)
    
        username = self.username_entry.get_text()
        port = int(self.server_port_spinner.get_value())

        self.add_lobby_server(None)
        self.gui_lobby.RegisterAccount(server_address, port, username, encoded_password)


    def add_lobby_server(self, widget):
        
        import md5
        import base64

        server_address = self.server_address_entry.get_text()
        u = md5.new(self.password_entry.get_text()).digest()
        encoded_password = base64.encodestring(u)

        if self.lobby_ini.has_section(server_address) == False:
            self.lobby_ini.add_section(server_address)
            iter = self.lobby_server_list_liststore.append([server_address])

            self.lobby_ini.set(server_address, 'Port', int(self.server_port_spinner.get_value()))
            self.lobby_ini.set(server_address, 'UserName', self.username_entry.get_text())
            self.lobby_ini.set(server_address, 'UserPassword', encoded_password)
            self.lobby_ini.set(server_address, 'Spring UDP Port', int(self.spring_udp_port_spinner.get_value()))
            self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
            self.lobby_ini.read(self.lobby_ini_file)
            if self.lobby_ini.sections()[0] == server_address:
                self.default_lobby_server(None, None, iter)
        else:
            self.lobby_ini.set(server_address, 'Port', int(self.server_port_spinner.get_value()))
            self.lobby_ini.set(server_address, 'UserName', self.username_entry.get_text())
            self.lobby_ini.set(server_address, 'UserPassword', encoded_password)
            self.lobby_ini.set(server_address, 'Spring UDP Port', int(self.spring_udp_port_spinner.get_value()))            
            self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
            self.lobby_ini.read(self.lobby_ini_file)


    def delete_lobby_server(self, widget, event, iter):
        
        server_name = self.lobby_server_list_liststore.get_value(iter,0)
        self.lobby_ini.remove_section(server_name)
        self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
        self.lobby_ini.read(self.lobby_ini_file)
        self.lobby_server_list_liststore.remove(iter)


    def default_lobby_server(self, event, widget, iter):
        
        default_server = self.lobby_server_list_liststore.get_value(iter,0)
        server_list = self.lobby_ini.sections()
        i = 0
        while i < len(server_list):
            if server_list[i] == 'COLORS':
                server_list.pop(i)
            else:
                i = i + 1

        for i in range(0,len(server_list)):
            if server_list[i] != default_server:
                self.lobby_ini.set(server_list[i], 'Default', 'No')
            else:
                self.lobby_ini.set(server_list[i], 'Default', 'Yes')
        self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
        self.lobby_ini.read(self.lobby_ini_file)


    def get_default_lobby_server(self):

        server = None
        port = None
        spring_udp_port = None        
        username = None
        password = None
               
        server_list = self.lobby_ini.sections()
        for i in range(0,len(server_list)):
            default = self.lobby_ini.get(server_list[i], 'Default', 'No')
            if default == 'Yes':
                server = server_list[i]
                port = self.lobby_ini.getint(server_list[i], 'Port')
                username = self.lobby_ini.get(server_list[i], 'UserName')
                password = self.lobby_ini.get(server_list[i], 'UserPassword')
                spring_udp_port = self.lobby_ini.get(server_list[i], 'Spring UDP Port')
                break
        return server, port, spring_udp_port, username, password


    def load_options(self):
        
        if self.ini.has_option(self.profile, 'Lobby Color Text') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Text')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options = ({'Text':temp})
        else:
            options = ({'Text':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Action') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Action')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Action':temp})
        else:
            options.update({'Action':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Highlight') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Highlight')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Highlight':temp})
        else:
            options.update({'Highlight':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color MOTD') == True:
            temp = self.ini.get(self.profile, 'Lobby Color MOTD')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'MOTD':temp})
        else:
            options.update({'MOTD':[45232,17733,17733]})

        if self.ini.has_option(self.profile, 'Lobby Color Channel Topic') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Channel Topic')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Channel Topic':temp})
        else:
            options.update({'Channel Topic':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Server Message') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Server Message')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Server Message':temp})
        else:
            options.update({'Server Message':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Server Broadcast') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Server Broadcast')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Server Broadcast':temp})
        else:
            options.update({'Server Broadcast':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Join') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Join')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Join':temp})
        else:
            options.update({'Join':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Leave') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Leave')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Leave':temp})
        else:
            options.update({'Leave':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color User Present') == True:
            temp = self.ini.get(self.profile, 'Lobby Color User Present')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'User Present':temp})
        else:
            options.update({'User Present':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color User InGame') == True:
            temp = self.ini.get(self.profile, 'Lobby Color User InGame')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'User InGame':temp})
        else:
            options.update({'User InGame':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color User AFK') == True:
            temp = self.ini.get(self.profile, 'Lobby Color User AFK')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'User AFK':temp})
        else:
            options.update({'User AFK':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Battle') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Battle')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Battle':temp})
        else:
            options.update({'Battle':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Battle In Progress') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Battle In Progress')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Battle In Progress':temp})
        else:
            options.update({'Battle In Progress':[0,0,0]})
            
        return options


    def save_color(self, widget, option):
        
        self.ini.set(self.profile, 'Lobby Color ' + option, str(widget.get_color().red) + ' ' + str(widget.get_color().green) + ' ' + str(widget.get_color().blue))
        self.ini.write(open(self.ini_file, "w+"))
        self.ini.read(self.ini_file)
        if option == 'User AFK' or option == 'User InGame' or option == 'User Present' or option == 'Battle' or option == 'Battle In Progress':
            self.gui_lobby.UpdateUserColor()
        else:
            self.gui_lobby.UpdateTagTable(option)


    def load_tag_color_options(self):
        
        if self.ini.has_option(self.profile, 'Lobby Color Text') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Text')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options = ({'Text':temp})
        else:
            options = ({'Text':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Action') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Action')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Action':temp})
        else:
            options.update({'Action':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Highlight') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Highlight')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Highlight':temp})
        else:
            options.update({'Highlight':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color MOTD') == True:
            temp = self.ini.get(self.profile, 'Lobby Color MOTD')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'MOTD':temp})
        else:
            options.update({'MOTD':[45232,17733,17733]})

        if self.ini.has_option(self.profile, 'Lobby Color Channel Topic') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Channel Topic')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Channel Topic':temp})
        else:
            options.update({'Channel Topic':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Server Message') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Server Message')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Server Message':temp})
        else:
            options.update({'Server Message':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Server Broadcast') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Server Broadcast')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Server Broadcast':temp})
        else:
            options.update({'Server Broadcast':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Join') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Join')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Join':temp})
        else:
            options.update({'Join':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Leave') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Leave')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Leave':temp})
        else:
            options.update({'Leave':[0,0,0]})

        return options


    def load_user_color_options(self):

        if self.ini.has_option(self.profile, 'Lobby Color User Present') == True:
            temp = self.ini.get(self.profile, 'Lobby Color User Present')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options = ({'User Present':temp})
        else:
            options = ({'User Present':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color User InGame') == True:
            temp = self.ini.get(self.profile, 'Lobby Color User InGame')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'User InGame':temp})
        else:
            options.update({'User InGame':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color User AFK') == True:
            temp = self.ini.get(self.profile, 'Lobby Color User AFK')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'User AFK':temp})
        else:
            options.update({'User AFK':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Battle') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Battle')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Battle':temp})
        else:
            options.update({'Battle':[0,0,0]})

        if self.ini.has_option(self.profile, 'Lobby Color Battle In Progress') == True:
            temp = self.ini.get(self.profile, 'Lobby Color Battle In Progress')
            temp = temp.split(" ")
            for o in range(0, len(temp)):
                temp[o] = int(temp[o])
            options.update({'Battle In Progress':temp})
        else:
            options.update({'Battle In Progress':[0,0,0]})

        return options
    
    
class gui_lobby:
    
    def __init__(self, status_icon):
    ## ==================================================================================================
    ##  Initialise self variables for gui_lobby class.
    ## ==================================================================================================
    
        self.spring_logo_pixbuf = status_icon.spring_logo_pixbuf

        self.ini =  status_icon.ini
        self.ini_file = status_icon.ini_file
        self.profile = status_icon.profile

        self.lobby_preferences = preferences(self, status_icon.lobby_ini, status_icon.lobby_ini_file)
        self.lobby_preferences.create()
        
        self.setup_profile = status_icon.profile
        self.unity_location = status_icon.unity_location

        self.network_game = False

        self.UpdateUserColor()

        self.IntialiseServerVariables()


    def IntegrateWithBattle(self, status_icon):
    ## ==================================================================================================
    ##  Integrates Lobby Class with Battle Class
    ## ==================================================================================================

        self.battle = status_icon.battle


    def Create(self):
    ## ==================================================================================================
    ##  Creates GUI for Lobby
    ## ==================================================================================================

        # Window
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_icon_list(self.spring_logo_pixbuf)
        self.window.set_title("Lobby")
        self.window.connect("delete-event", self.Destroy)
        
        self.window.resize(self.ini.getint(self.profile, 'LOBBY_WINDOW_WIDTH'), self.ini.getint(self.profile, 'LOBBY_WINDOW_HEIGHT'))
        
            # Table
        table = gtk.Table(rows=2, columns=2, homogeneous=False)
        table.show()
        self.window.add(table)

        # Vertical Pane
        vpane = gtk.VPaned()
        table.attach(vpane, 0,1,1,2)
        vpane.show()

            # Frame
        frame = gtk.Frame(None)
        frame.set_border_width(0)
        frame.set_size_request(100,75)
        frame.show()


        # Battle ListStore
            # 0 Battle ID
            # 1 Battle Type
            # 2 Nat Type
            # 3 Founder
            # 4 IP
            # 5 Port
                # 6  Max Players
                # 7  Passworded
                # 8  Rank
                # 9  Map Hash
                # 10 Mapname
                # 11 Title
                # 12 Modname
                # 13 List of Players <internal>
                # 14 List of Players <external>
                # 15 Locked
                # 16 Founder Status
                # 17 Bot Status
                # 18 Amount of Players <external>

                    # Battle Window
        battle_window = gtk.ScrolledWindow()
        battle_window.set_border_width(0)
        battle_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        battle_window.show()
        vpane.pack1(battle_window, True, True)
                        # Battle List
        self.battle_treeview = gtk.TreeView(self.battle_liststore)
        self.battle_column_0 = gtk.TreeViewColumn('State')
        self.battle_column_1 = gtk.TreeViewColumn('Description')
        self.battle_column_2 = gtk.TreeViewColumn('Host')
        self.battle_column_3 = gtk.TreeViewColumn('Map')
        self.battle_column_4 = gtk.TreeViewColumn('Mod')
        self.battle_column_5 = gtk.TreeViewColumn('Players')
        self.battle_column_6 = gtk.TreeViewColumn('List of Players')
        self.battle_column_0.set_resizable(True)
        self.battle_column_1.set_resizable(True)
        self.battle_column_2.set_resizable(True)
        self.battle_column_3.set_resizable(True)
        self.battle_column_4.set_resizable(True)
        self.battle_column_5.set_resizable(True)
        self.battle_column_6.set_resizable(True)        
        self.battle_treeview.append_column(self.battle_column_0)
        self.battle_treeview.append_column(self.battle_column_1)
        self.battle_treeview.append_column(self.battle_column_2)
        self.battle_treeview.append_column(self.battle_column_3)
        self.battle_treeview.append_column(self.battle_column_4)
        self.battle_treeview.append_column(self.battle_column_5)
        self.battle_treeview.append_column(self.battle_column_6)        
        self.battle_treeview.show()
        battle_window.add(self.battle_treeview)

        # Add Mouse Click event to battle_treeview
        self.battle_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
        self.battle_treeview.connect('event',self.BattlePopupMenu)

        # Create a CellRenderers to render the data
        self.cell0a = gtk.CellRendererPixbuf()
        self.cell0b = gtk.CellRendererPixbuf()
        self.cell0c = gtk.CellRendererPixbuf()
        self.cell0d = gtk.CellRendererPixbuf()
        self.cell0e = gtk.CellRendererPixbuf()
        self.cell1  = gtk.CellRendererText()
        self.cell2  = gtk.CellRendererText()
        self.cell3  = gtk.CellRendererText()
        self.cell4  = gtk.CellRendererText()
        self.cell5  = gtk.CellRendererText()
        self.cell6  = gtk.CellRendererText()

            # add the cells to the columns
        self.battle_column_0.pack_start(self.cell0a, False)
        self.battle_column_0.pack_start(self.cell0b, True)
        self.battle_column_0.pack_start(self.cell0c, True)
        self.battle_column_0.pack_start(self.cell0d, True)
        self.battle_column_0.pack_start(self.cell0e, True)
        self.battle_column_1.pack_start(self.cell1, False)
        self.battle_column_2.pack_start(self.cell2, False)
        self.battle_column_3.pack_start(self.cell3, False)
        self.battle_column_4.pack_start(self.cell4, False)
        self.battle_column_5.pack_start(self.cell5, False)
        self.battle_column_6.pack_start(self.cell6, False)

        # set the cell attributes to the appropriate liststore column
        self.battle_column_1.set_attributes(self.cell1, text=11)
        self.battle_column_2.set_attributes(self.cell2, text=3)
        self.battle_column_3.set_attributes(self.cell3, text=10)
        self.battle_column_4.set_attributes(self.cell4, text=12)
        self.battle_column_5.set_attributes(self.cell5, text=18)
        self.battle_column_6.set_attributes(self.cell6, text=14)

        # Allow sorting on the column
        self.battle_column_0.set_sort_column_id(16)
        self.battle_column_1.set_sort_column_id(11)
        self.battle_column_2.set_sort_column_id(3)
        self.battle_column_3.set_sort_column_id(10)
        self.battle_column_4.set_sort_column_id(12)
        self.battle_column_5.set_sort_column_id(6)

                # Lobby Notebook
        self.lobby_notebook = gtk.Notebook()
        self.lobby_notebook.set_tab_pos(gtk.POS_TOP)
        self.lobby_notebook.show()
        vpane.pack2(self.lobby_notebook, True, True)

        gtk.gdk.threads_leave()
        self.CreateChannelChat('$local', False)
        gtk.gdk.threads_enter()

        self.connect_button = gtk.ToolButton(gtk.STOCK_DISCONNECT)
        self.connect_button.connect("clicked", self.Connection)
        self.connect_button.show()

        self.preferences_button = gtk.ToolButton(gtk.STOCK_PREFERENCES)
        self.preferences_button.connect("clicked", self.lobby_preferences.show)
        self.preferences_button.show()

        toolbar = gtk.Toolbar()	
        toolbar.insert(self.connect_button, 0)
        toolbar.insert(self.preferences_button, 1)		
        toolbar.set_style(gtk.TOOLBAR_ICONS)
        toolbar.show()

        table.attach(toolbar,0,1,0,1, gtk.FILL, gtk.FILL,0,0)

        Lobby.client(self)


    def Show(self):
    ## ==================================================================================================
    ##  Function to show window. Called from outside of Battle class.
    ## ==================================================================================================

        self.window.show()


    def Hide(self):
    ## ==================================================================================================
    ##  Function to hide window. Called from outside of Battle class.
    ## ==================================================================================================
        width, height = self.window.get_size()
        
        self.ini.set(self.profile, 'LOBBY_WINDOW_WIDTH', width)
        self.ini.set(self.profile, 'LOBBY_WINDOW_HEIGHT', height)
        self.ini.write(open(self.ini_file, "w+"))
        self.ini.read(self.ini_file)
                
        self.window.hide()


    def Destroy(self, window, event):
    ## ==================================================================================================
    ##  Overrides Display Manager kill signal and hides window instead.
    ## ==================================================================================================
        
        self.Hide()
        return True


    def IntialiseServerVariables(self):
    ## ==================================================================================================
    ##  Initialise Server Variables that store data i.e chat / user list / battle list.
    ## ==================================================================================================
        
        self.userlist = [(Lobby.user(self, None, None, None, None))]

        self.username = ''
        self.server_agreement = ''
        self.battle_id = None
        self.network_game = False

        self.CreateTagTable()


        try:
            while len(self.lobby_channel_names) != 1:
                self.lobby_channel_vpanes.pop(1)
                self.lobby_channel_names.pop(1)
                self.lobby_channel_buffers.pop(1)
                self.lobby_channel_textview.pop(1)
                self.lobby_channel_users.pop(1)
                self.lobby_channel_users_cells.pop(1)
                self.lobby_channel_users_columns.pop(1)
            while self.lobby_notebook.get_n_pages() > 1:
                self.lobby_notebook.remove_page(1)
            self.lobby_channel_buffers[0].delete(self.lobby_channel_buffers[0].get_start_iter(), self.lobby_channel_buffers[0].get_end_iter())

        except:
            self.lobby_channel_vpanes = []
            self.lobby_channel_names = []
            self.lobby_channel_buffers = []
            self.lobby_channel_textview = []
            self.lobby_channel_users = []
            self.lobby_channel_users_cells = []
            self.lobby_channel_users_columns = []
            

        self.lobby_pm_vpanes = []
        self.lobby_pm_names = []
        self.lobby_pm_buffers = []
        self.lobby_pm_textview = []
        self.lobby_pm_users = []
        self.lobby_pm_users_cells = []
        self.lobby_pm_users_columns = []

        # Battle ListStore
            # 0 Battle ID
            # 1 Battle Type
            # 2 Nat Type
            # 3 Founder
            # 4 IP
            # 5 Port
                # 6  Max Players
                # 7  Passworded
                # 8  Rank
                # 9  Map Hash
                # 10 Mapname
                # 11 Title
                # 12 Modname
                # 13 List of Players <internal>
                # 14 List of Players
                # 15 Locked
                # 16 Founder Status
                # 17 Bot Status
        try:
            self.battle_user_liststore.clear()
            self.battle_liststore.clear()
        except:
            self.battle_user_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, str, str)
            self.battle_liststore = gtk.ListStore(str, str, str, str, str, int, int, str, gtk.gdk.Pixbuf, str, str, str, str, gobject.TYPE_PYOBJECT, str, str, bool, str, str)

        self.country_flags = {}
        self.rank_images = {}
        self.status_images = {}
        self.battle_images = None


    def CreateTagTable(self):
    ## ==================================================================================================
    ##  Creates Tag Table using in gtk.TextBuffers
    ## ==================================================================================================
        
        self.tag_table = gtk.TextTagTable()
        color_options = self.lobby_preferences.load_tag_color_options()

        for k, v in color_options.iteritems():
            tag = gtk.TextTag(k)
            color = gtk.gdk.Color(v[0], v[1], v[2])
            tag.set_property("foreground-gdk", color)
            self.tag_table.add(tag)


    def UpdateTagTable(self, tagname):
    ## ==================================================================================================
    ##  Creates Tag Table using in gtk.TextBuffers
    ## ==================================================================================================
        
        tag = self.tag_table.lookup(tagname)
        self.tag_table.remove(tag)

        color_options = self.lobby_preferences.load_tag_color_options()

        for k, v in color_options.iteritems():
            if k == tagname:
                tag = gtk.TextTag(k)
                color = gtk.gdk.Color(v[0], v[1], v[2])
                tag.set_property("foreground-gdk", color)
                self.tag_table.add(tag)
                break


    def UpdateUserColor(self):
    ## ==================================================================================================
    ##  Updates Color Values for UserList
    ## ==================================================================================================

        self.user_color_options = self.lobby_preferences.load_user_color_options()


    def CreateChannelChat(self, channel_name, closeable):
    ## ==================================================================================================
    ##  Creates Data Variables for Channel Chat.
    ## ==================================================================================================

        try:
            textbuffer = gtk.TextBuffer(self.tag_table)

            textview = gtk.TextView(buffer=textbuffer)
            textview.set_editable(False)
            textview.set_cursor_visible(False)
            textview.set_wrap_mode(gtk.WRAP_WORD)
            textview.set_justification(gtk.JUSTIFY_LEFT)
            textview.show()

            self.lobby_channel_names.append(channel_name)
            self.lobby_channel_buffers.append(textbuffer)
            self.lobby_channel_textview.append(textview)

            self.CreateChannelChatWindow(closeable)

        except Exception, inst:
            print
            print 'CreateChannelChat failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def CreateChannelChatWindow(self, closeable):
    ## ==================================================================================================
    ##  Create GUI for Channel Chat.
    ## ==================================================================================================
        
        
        try:
            gtk.gdk.threads_enter()

            last_index = len(self.lobby_channel_names) - 1

            # Label
            label_box = gtk.EventBox()
            if closeable == True:
                label = gtk.Label('#' + self.lobby_channel_names[last_index])
            else:
                label = gtk.Label(self.lobby_channel_names[last_index])
            label.show()
            label_box.show()
            label_box.add(label)
    
    
            # Vertical Pane
            vpane = gtk.HPaned()
            self.lobby_channel_vpanes.append(vpane)
            vpane.show()
    
                # Frame
            frame = gtk.Frame(None)
            frame.set_border_width(0)
            frame.set_size_request(100,75)
            frame.show()
            vpane.pack1(frame, True, True)


            if closeable == True:
                frame2 = gtk.Frame(None)
                frame2.set_border_width(0)
                frame2.show()
                vpane.pack2(frame2, True, True)
    
                    # Player Window (scrolled)
                player_window = gtk.ScrolledWindow()
                player_window.set_border_width(0)
                player_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
                player_window.show()
                        # Player ListStore
                            # 0 Username
                            # 1 Country
                            # 2 Cpu
                            # 3 IP
                                # 4 Status -> InGame / Away
                                # 5 Rank
                                # 6 Admin
                                # 7 Status Text
                                # 8 Bot
                player_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, str, str)
                self.lobby_channel_users.append(player_liststore)
                player_treeview = gtk.TreeView(player_liststore)
                player_column_0 = gtk.TreeViewColumn('') # Away
                player_column_1 = gtk.TreeViewColumn('') # Country
                player_column_2 = gtk.TreeViewColumn('') # Name Rank Mod
    
                player_treeview.append_column(player_column_0)
                player_treeview.append_column(player_column_1)
                player_treeview.append_column(player_column_2)
                player_treeview.set_headers_visible(False)
                player_treeview.show()
                player_window.add(player_treeview)
                frame2.add(player_window)

                            # Add Mouse Click event to player_treeview
                player_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
                player_treeview.connect('event', self.PlayerPopupMenu)
            
                                # Create a CellRenderers to render the data
                cell0  = gtk.CellRendererPixbuf()
                cell1  = gtk.CellRendererPixbuf()
                cell2  = gtk.CellRendererText()
                cell3  = gtk.CellRendererPixbuf()
                cell4  = gtk.CellRendererPixbuf()
                cell5  = gtk.CellRendererPixbuf()
    
                self.lobby_channel_users_columns.append([ player_column_0, player_column_1, player_column_2 ])
                self.lobby_channel_users_cells.append([ cell0, cell1, cell2, cell3, cell4, cell5 ])

                                # Add the cells to the columns
                player_column_0.pack_start(cell0, False)
                player_column_1.pack_start(cell1, False)
                player_column_2.pack_start(cell2, False)
                player_column_2.pack_start(cell3, False)
                player_column_2.pack_start(cell4, False)
                player_column_2.pack_start(cell5, False)

                                # Set the cell attributes to the appropriate liststore column
                player_column_2.set_attributes(cell2, text=0)
       
                                # Allow sorting on the column
                player_column_2.set_sort_column_id(0)
            else:
                self.lobby_channel_users.append(None)
                self.lobby_channel_users_cells.append(None)
                self.lobby_channel_users_columns.append(None)
        
    
                    # Table
            table = gtk.Table(rows=1, columns=4, homogeneous=False)
            frame.add(table)
            table.show()
    
                        # Scrolled Window
            scrolled_window = gtk.ScrolledWindow(hadjustment=None, vadjustment=None)
            scrolled_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
            scrolled_window.add(self.lobby_channel_textview[last_index])
            scrolled_window.show()
            table.attach(scrolled_window, 0,2,0,1)
        
                        # Entrys
            entry = gtk.Entry(max=0)
            entry.show()
            entry.connect("activate", self.ParseOutputChannelChat, self.lobby_channel_names[last_index])
            table.attach(entry, 0,2,1,2, gtk.FILL, gtk.FILL,0,0)
    
            # Notebook Page
            self.lobby_notebook.append_page(vpane, label_box)
            if closeable == True:
                label_box.connect('event', self.OnChannelChatTabClick, self.lobby_channel_names[last_index])
            gtk.gdk.threads_leave()

        except Exception, inst:
            print
            print 'createchannelwindow failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def ParseOutputChannelChat(self, entry, channel_name):
    ## ==================================================================================================
    ##  Parses User Input for Channel Chat.
    ## ==================================================================================================
        
        try:
            if self.connect_button.get_stock_id() == gtk.STOCK_CONNECT:
                temp_str =  entry.get_text()
                entry.set_text('')
                if temp_str != None:
                    if temp_str[0] != '/' and channel_name != '$local':
                        temp_str = 'SAY ' + channel_name + ' ' + temp_str
                        self.client.send(temp_str)
                    elif temp_str[:4] == '/ME ' or temp_str[:4] == '/me ':
                        if channel_name != '$local':
                            temp_str = 'SAYEX ' + channel_name + ' ' + temp_str[4:]
                            self.client.send(temp_str)
                    elif temp_str[0] == '/':
                        temp_parsed = temp_str.split(" ")
                        args = ''
                        for i in range (1, len(temp_parsed)):
                            args = args + temp_parsed[i]
                            if i != len(temp_parsed):
                                args = args + ' '	
                        self.client.send(temp_parsed[0][1:], args)
                        
        except Exception, inst:
            print
            print 'ParseOutputChannelChat failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def RemoveChannelChatBuffer(self, channel_name):
    ## ==================================================================================================
    ##  Removes Data Buffers for a Channel Chat.
    ##   i.e called when user leaves a Channel.
    ## ==================================================================================================
        
        try:
            for o in range(0,len(self.userlist)):
                self.userlist[o].leaveChannel(channel_name)

            for i in range(0,len(self.lobby_channel_names)):
                if self.lobby_channel_names[i] == channel_name:

                    self.lobby_channel_names.pop(i)	## remove i-th channel name
                    self.lobby_channel_buffers.pop(i)	## remove i-th textbuffer
                    self.lobby_channel_textview.pop(i)	## remove i-th textview

                    self.lobby_channel_users_columns.pop(i) ## should always be idx of channel!
                    self.lobby_channel_users_cells.pop(i)	## should always be idx of channel!
                    self.lobby_channel_users.pop(i)		## remove i-th liststore

                    for o in range(0,self.lobby_notebook.get_n_pages()):
                        if self.lobby_channel_vpanes[i] == self.lobby_notebook.get_nth_page(o):
                            self.lobby_notebook.remove_page(o)
                            self.lobby_channel_vpanes.pop(i)
                            break
                    break
                
        except Exception, inst:
            print
            print 'RemoveChannelChatBuffer failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def OnChannelChatTabClick(self, widget, event, channel_name, ):
    ## ==================================================================================================
    ##  Called When User Clicks On Channel Chat Tab.
    ## ==================================================================================================
        
        try:
            if  event.type == gtk.gdk.BUTTON_PRESS:
                if event.button == 3:
                    self.client.send('LEAVE', channel_name)
                    self.RemoveChannelChatBuffer(channel_name)

        except Exception, inst:
            print
            print 'OnChannelChatTabClick failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def UpdateTextbufferChannelChat(self, channel_name, username, text, tag="Text"):
    ## ==================================================================================================
    ##  Updates Textbuffer for a Channel Chat.
    ## ==================================================================================================
        
        
        try:
            for i in range (0,len(self.lobby_channel_names)):
                if self.lobby_channel_names[i] == channel_name:
                    gtk.gdk.threads_enter()
                    iter = self.lobby_channel_buffers[i].get_end_iter()
                    self.lobby_channel_buffers[i].insert(iter, '\n')
                    iter = self.lobby_channel_buffers[i].get_end_iter()

                    if username != None:
                        if tag != 'Action':
                            self.lobby_channel_buffers[i].insert_with_tags_by_name(iter, '<' + username + '> ', tag)
                        else:
                            self.lobby_channel_buffers[i].insert_with_tags_by_name(iter, '* ' + username + ' ', tag)

                    self.lobby_channel_buffers[i].insert_with_tags_by_name(iter, text, tag)

                    while self.lobby_channel_buffers[i].get_line_count() > 50:
                        self.lobby_channel_buffers[i].delete(self.lobby_channel_buffers[i].get_start_iter(), self.lobby_channel_buffers[i].get_iter_at_line(1))
                    self.lobby_channel_textview[i].scroll_mark_onscreen(self.lobby_channel_buffers[i].get_insert())
                    gtk.gdk.threads_leave()
                    break

        except Exception, inst:
            print
            print 'UpdateTextbufferChannelChat failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y
            print 'tag =', tag


    def CreatePMChat(self, pm_name):
    ## ==================================================================================================
    ##  Creates Data Variables for PM Chat.
    ## ==================================================================================================
        
        try:
            textbuffer = gtk.TextBuffer(self.tag_table)

            textview = gtk.TextView(buffer=textbuffer)
            textview.set_editable(False)
            textview.set_cursor_visible(False)
            textview.set_wrap_mode(gtk.WRAP_WORD)
            textview.set_justification(gtk.JUSTIFY_LEFT)
            textview.show()

            self.lobby_pm_names.append(pm_name)
            self.lobby_pm_buffers.append(textbuffer)
            self.lobby_pm_textview.append(textview)

            self.CreatePMChatWindow()

        except Exception, inst:
            print
            print 'CreatePMChat failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def CreatePMChatWindow(self):
    ## ==================================================================================================
    ##  Create GUI for PM Chat.
    ## ==================================================================================================
        
        try:
            last_index = len(self.lobby_pm_names) - 1
#			gtk.gdk.threads_enter()
    
            # Label
            label_box = gtk.EventBox()
            label = gtk.Label(self.lobby_pm_names[last_index])
            label.show()
            label_box.show()
            label_box.add(label)
    
    
            # Vertical Pane
            vpane = gtk.HPaned()
            self.lobby_pm_vpanes.append(vpane)
            vpane.show()

                # Frame
            frame = gtk.Frame(None)
            frame.set_border_width(0)
            frame.set_size_request(100,75)
            frame.show()
            vpane.pack1(frame, True, True)
    
    
            frame2 = gtk.Frame(None)
            frame2.set_border_width(0)
            frame2.show()
            vpane.pack2(frame2, True, True)
    
                # Player Window (scrolled)
            player_window = gtk.ScrolledWindow()
            player_window.set_border_width(0)
            player_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
            player_window.show()
                    # Player ListStore
                        # 0 Username
                        # 1 Country
                        # 2 Cpu
                        # 3 IP
                            # 4 Status -> InGame / Away
                            # 5 Rank
                            # 6 Admin
                            # 7 Status Text
                            # 8 Bot
            player_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, str, str)
            self.lobby_pm_users.append(player_liststore)
            player_treeview = gtk.TreeView(player_liststore)
            player_column_0 = gtk.TreeViewColumn('') # Away
            player_column_1 = gtk.TreeViewColumn('') # Country
            player_column_2 = gtk.TreeViewColumn('') # Name Rank Mod
            player_treeview.append_column(player_column_0)
            player_treeview.append_column(player_column_1)
            player_treeview.append_column(player_column_2)
            player_treeview.set_headers_visible(False)
            player_treeview.show()
            player_window.add(player_treeview)
            frame2.add(player_window)

                            # Create a CellRenderers to render the data
            cell0  = gtk.CellRendererPixbuf()
            cell1  = gtk.CellRendererPixbuf()
            cell2  = gtk.CellRendererText()
            cell3  = gtk.CellRendererPixbuf()
            cell4  = gtk.CellRendererPixbuf()
            cell5  = gtk.CellRendererPixbuf()

            self.lobby_pm_users_columns.append([ player_column_0, player_column_1, player_column_2 ])
            self.lobby_pm_users_cells.append([ cell0, cell1, cell2, cell3, cell4, cell5 ])
    
                            # Add the cells to the columns
            player_column_0.pack_start(cell0, False)
            player_column_1.pack_start(cell1, False)
            player_column_2.pack_start(cell2, False)
            player_column_2.pack_start(cell3, False)
            player_column_2.pack_start(cell4, False)
            player_column_2.pack_start(cell5, False)
    
                            # Set the cell attributes to the appropriate liststore column
            player_column_2.set_attributes(cell2, text=0)
   
                            # Allow sorting on the column
            player_column_2.set_sort_column_id(0)
    
    
    
                    # Table
            table = gtk.Table(rows=1, columns=4, homogeneous=False)
            frame.add(table)
            table.show()

                        # Scrolled Window
            scrolled_window = gtk.ScrolledWindow(hadjustment=None, vadjustment=None)
            scrolled_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
            scrolled_window.add(self.lobby_pm_textview[last_index])
            scrolled_window.show()
            table.attach(scrolled_window, 0,2,0,1)
    
                        # Entrys
            entry = gtk.Entry(max=0)
            entry.show()
            entry.connect("activate", self.ParseOutputPMChat, self.lobby_pm_names[last_index])
            table.attach(entry, 0,2,1,2, gtk.FILL, gtk.FILL,0,0)
    
            # Notebook Page
            self.lobby_notebook.append_page(vpane, label_box)
            label_box.connect('event', self.OnPMChatTabClick, self.lobby_pm_names[last_index])



        # TODO: Code this in 1 pass of userlist

            for o in range(0,len(self.userlist)):
                if self.userlist[o].name == self.username:
                        self.userlist[o].addPM(self.lobby_pm_names[last_index])

                        username = self.userlist[o].name
                        flag = self.GetCountryFlag(self.userlist[o].country)
                        cpu = self.userlist[o].cpu
                        ip = self.userlist[o].ip

                        if self.userlist[o].inGame() == True:
                            status_image = self.GetStatusImage('ingame')
                            status = 'InGame'
                        elif self.userlist[o].isAway() == True:
                            status_image = self.GetStatusImage('away')
                            status = 'AFK'
                        else:
                            status_image = self.GetStatusImage('here')
                            status = 'Present'

                        rank = self.userlist[o].getRank()
                        rank_image = self.GetRankImage(rank)
                        admin = self.userlist[o].admin()
                        if admin == True:
                            admin_image = self.GetRankImage("admin")
                        else:
                            admin_image = None

                        if self.userlist[o].isBot() == True:
                            bot = 'unitylobby-bot'
                        else:
                            bot = None

                        gtk.gdk.threads_enter()
                        self.lobby_pm_users[last_index].append([username, flag, cpu, ip, status_image, rank_image, admin_image, status, bot])
                        self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][5], self.UpdateChannelBot)
                        self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][4], self.UpdateChannelAdmin)
                        self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][3], self.UpdateChannelRank)
                        self.lobby_pm_users_columns[last_index][1].set_cell_data_func(self.lobby_pm_users_cells[last_index][1], self.UpdateChannelUserFlag)
                        self.lobby_pm_users_columns[last_index][0].set_cell_data_func(self.lobby_pm_users_cells[last_index][0], self.UpdateChannelUserStatus)
                        gtk.gdk.threads_leave()
                        break

            for o in range(0,len(self.userlist)):
                if self.userlist[o].name == self.lobby_pm_names[last_index]:
                        self.userlist[o].addPM(self.lobby_pm_names[last_index])

                        username = self.userlist[o].name
                        flag = self.GetCountryFlag(self.userlist[o].country)
                        cpu = self.userlist[o].cpu
                        ip = self.userlist[o].ip

                        if self.userlist[o].inGame() == True:
                            status_image = self.GetStatusImage('ingame')
                            status = 'InGame'
                        elif self.userlist[o].isAway() == True:
                            status_image = self.GetStatusImage('away')
                            status = 'AFK'
                        else:
                            status_image = self.GetStatusImage('here')
                            status = 'Present'

                        rank = self.userlist[o].getRank()
                        rank_image = self.GetRankImage(rank)
                        admin = self.userlist[o].admin()
                        if admin == True:
                            admin_image = self.GetRankImage("admin")
                        else:
                            admin_image = None

                        if self.userlist[o].isBot() == True:
                            bot = 'unitylobby-bot'
                        else:
                            bot = None

                        gtk.gdk.threads_enter()
                        self.lobby_pm_users[last_index].append([username, flag, cpu, ip, status_image, rank_image, admin_image, status, bot])
                        self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][5], self.UpdateChannelBot)
                        self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][4], self.UpdateChannelAdmin)
                        self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][3], self.UpdateChannelRank)
                        self.lobby_pm_users_columns[last_index][1].set_cell_data_func(self.lobby_pm_users_cells[last_index][1], self.UpdateChannelUserFlag)
                        self.lobby_pm_users_columns[last_index][0].set_cell_data_func(self.lobby_pm_users_cells[last_index][0], self.UpdateChannelUserStatus)
                        gtk.gdk.threads_leave()
                        break

        except Exception, inst:
            print
            print 'CreatePMChatWindow failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def ParseOutputPMChat(self, entry, pm_name):
        
        temp_str =  entry.get_text()
        entry.set_text('')
        if temp_str != None:
            if temp_str[0] != '/':
                temp_str = 'SAYPRIVATE ' + pm_name + ' ' + temp_str
                self.client.send(temp_str)
#			elif temp_str[:4] == '/ME ' or '/me ':
#				temp_str = 'SAYPRIVATEEX ' + temp_str[4:]
#				self.client.send(temp_str)
            elif temp_str[0] == '/':
                temp_parsed = temp_str.split(" ")
                args = ''
                for i in range (1, len(temp_parsed)):
                    args = args + temp_parsed[i]
                    if i != len(temp_parsed):
                        args = args + ' '	
                self.client.send(temp_parsed[0][1:], args)


    def RemovePMChatBuffer(self, pm_name):
    ## ==================================================================================================
    ##  Removes Data Buffers for a PM Chat.
    ##   i.e called when user closes a PM.
    ## ==================================================================================================
        
        for o in range(0,len(self.userlist)):
            if self.userlist[o].name == pm_name:
                self.userlist[o].leavePM(pm_name)
                break

        for i in range(0,len(self.lobby_pm_names)):
            if self.lobby_pm_names[i] == pm_name:

                self.lobby_pm_names.pop(i)		## remove i-th pm name
                self.lobby_pm_buffers.pop(i)		## remove i-th textbuffer
                self.lobby_pm_textview.pop(i)		## remove i-th textview

                self.lobby_pm_users_columns.pop(i) 	## should always be idx of pm!
                self.lobby_pm_users_cells.pop(i)	## should always be idx of pm!
                self.lobby_pm_users.pop(i)		## remove i-th liststore

                for o in range(0,self.lobby_notebook.get_n_pages()):
                    if self.lobby_pm_vpanes[i] == self.lobby_notebook.get_nth_page(o):
                        self.lobby_notebook.remove_page(o)
                        self.lobby_pm_vpanes.pop(i)
                        break
                break


    def OnPMChatTabClick(self, widget, event, pm_name):
    ## ==================================================================================================
    ##  Called When User Clicks On Channel Chat Tab.
    ## ==================================================================================================
        
        if  event.type == gtk.gdk.BUTTON_PRESS:
            if event.button == 3:
                self.RemovePMChatBuffer(pm_name)
                for o in range(0,len(self.userlist)):
                    self.userlist[o].leavePM(pm_name)


    def UpdateTextbufferPMChat(self, pm_name, username, text, tag="Text"):
    ## ==================================================================================================
    ##  Updates Textbuffer for a PM Chat
    ## ==================================================================================================
        
        for i in range (0,len(self.lobby_pm_names)):
            if self.lobby_pm_names[i] == pm_name:
                gtk.gdk.threads_enter()
                iter = self.lobby_pm_buffers[i].get_end_iter()
                self.lobby_pm_buffers[i].insert(iter, '\n')
                iter = self.lobby_pm_buffers[i].get_end_iter()
                if tag != "Text":
                    self.lobby_pm_buffers[i].insert_with_tags_by_name(iter, text, tag)
                else:
                    if username != None:
                        self.lobby_pm_buffers[i].insert_with_tags_by_name(iter, '<' + username + '> ', tag)
                    self.lobby_pm_buffers[i].insert_with_tags_by_name(iter, text, tag)

                while self.lobby_pm_buffers[i].get_line_count() > 50:
                    self.lobby_pm_buffers[i].delete(self.lobby_pm_buffers[i].get_start_iter(), self.lobby_pm_buffers[i].get_iter_at_line(1))
                self.lobby_pm_textview[i].scroll_mark_onscreen(self.lobby_pm_buffers[i].get_insert())
                gtk.gdk.threads_leave()
                break


    def CreateBattleChat(self, iter):
    ## ==================================================================================================
    ##  Creates Data Variables for Battle Chat.
    ## ==================================================================================================
        
        self.battle_chat_buffer = gtk.TextBuffer(self.tag_table)

        self.battle_chat_textview = gtk.TextView(buffer=self.battle_chat_buffer)
        self.battle_chat_textview.set_editable(False)
        self.battle_chat_textview.set_cursor_visible(False)
        self.battle_chat_textview.set_wrap_mode(gtk.WRAP_WORD)
        self.battle_chat_textview.set_justification(gtk.JUSTIFY_LEFT)
        self.battle_chat_textview.show()

        vpane = self.CreateBattleChatWindow(iter)
        return vpane


    def CreateBattleChatWindow(self, iter):
    ## ==================================================================================================
    ##  Create GUI for Battle Chat Window.
    ## ==================================================================================================

        
        try:
            # Vertical Pane
            vpane = gtk.HPaned()
            vpane.show()

                # Frame
            frame = gtk.Frame(None)
            frame.set_border_width(0)
            frame.set_size_request(100,75)
            frame.show()
            vpane.pack1(frame, True, True)


            frame2 = gtk.Frame(None)
            frame2.set_border_width(0)
            frame2.show()
            vpane.pack2(frame2, True, True)

                # Player Window (scrolled)
            player_window = gtk.ScrolledWindow()
            player_window.set_border_width(0)
            player_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
            player_window.show()
                    # Player ListStore
                        # 0 Username
                        # 1 Country
                        # 2 Cpu
                        # 3 IP
                            # 4 Status -> InGame / Away
                            # 5 Rank
                            # 6 Admin
                            # 7 Status Text
            self.battle_user_liststore.clear()
            player_treeview = gtk.TreeView(self.battle_user_liststore)
            player_column_0 = gtk.TreeViewColumn('') # Away
            player_column_1 = gtk.TreeViewColumn('') # Country
            player_column_2 = gtk.TreeViewColumn('') # Name Rank Mod
            player_treeview.append_column(player_column_0)
            player_treeview.append_column(player_column_1)
            player_treeview.append_column(player_column_2)
            player_treeview.set_headers_visible(False)
            player_treeview.show()
            player_window.add(player_treeview)
            frame2.add(player_window)
    
                        # Create a CellRenderers to render the data
            cell0  = gtk.CellRendererPixbuf()
            cell1  = gtk.CellRendererPixbuf()
            cell2  = gtk.CellRendererText()
            cell3  = gtk.CellRendererPixbuf()
            cell4  = gtk.CellRendererPixbuf()
            cell5  = gtk.CellRendererPixbuf()

            self.battle_chat_users_columns = [ player_column_0, player_column_1, player_column_2 ]
            self.battle_chat_users_cells = [ cell0, cell1, cell2, cell3, cell4, cell5 ]

                            # Add the cells to the columns
            player_column_0.pack_start(cell0, False)
            player_column_1.pack_start(cell1, False)
            player_column_2.pack_start(cell2, False)
            player_column_2.pack_start(cell3, False)
            player_column_2.pack_start(cell4, False)
            player_column_2.pack_start(cell5, False)
    
                            # Set the cell attributes to the appropriate liststore column
            player_column_2.set_attributes(cell2, text=0)
   
                            # Allow sorting on the column
            player_column_2.set_sort_column_id(0)



                    # Table
            table = gtk.Table(rows=1, columns=4, homogeneous=False)
            frame.add(table)
            table.show()

                        # Scrolled Window
            scrolled_window = gtk.ScrolledWindow(hadjustment=None, vadjustment=None)
            scrolled_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
            scrolled_window.add(self.battle_chat_textview)
            scrolled_window.show()
            table.attach(scrolled_window, 0,2,0,1)
    
                        # Entrys
            entry = gtk.Entry(max=0)
            entry.show()
            entry.connect("activate", self.ParseOutputBattleChat)
            table.attach(entry, 0,2,1,2, gtk.FILL, gtk.FILL,0,0)

            users = self.battle_liststore.get_value(iter, 13)
            for i in range(0, len(users)):
                for o in range(0,len(self.userlist)):
                    if self.userlist[o].name == users[i]:    
                        username = self.userlist[o].name
                        flag = self.GetCountryFlag(self.userlist[o].country)
                        cpu = self.userlist[o].cpu
                        ip = self.userlist[o].ip

                        if self.userlist[o].inGame() == True:
                            status_image = self.GetStatusImage('ingame')
                            status = 'InGame'
                        elif self.userlist[o].isAway() == True:
                            status_image = self.GetStatusImage('away')
                            status = 'AFK'

                        else:
                            status_image = self.GetStatusImage('here')
                            status = 'Present'

                        rank = self.userlist[o].getRank()
                        rank_image = self.GetRankImage(rank)
                        admin = self.userlist[o].admin()
                        if admin == True:
                            admin_image = self.GetRankImage("admin")
                        else:
                            admin_image = None

                        if self.userlist[o].isBot() == True:
                            bot = 'unitylobby-bot'
                        else:
                            bot = None

                        gtk.gdk.threads_enter()
                        self.battle_user_liststore.append([username, flag, cpu, ip, status_image, rank_image, admin_image, status, bot])
                        self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[5], self.UpdateChannelBot)
                        self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[4], self.UpdateChannelAdmin)
                        self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[3], self.UpdateChannelRank)
                        self.battle_chat_users_columns[1].set_cell_data_func(self.battle_chat_users_cells[1], self.UpdateChannelUserFlag)
                        self.battle_chat_users_columns[0].set_cell_data_func(self.battle_chat_users_cells[0], self.UpdateChannelUserStatus)
                        gtk.gdk.threads_leave()

            return vpane
    
        except Exception, inst:
            print
            print 'CreateBattleChatWindow failed'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def ParseOutputBattleChat(self, entry):
    ## ==================================================================================================
    ##  Parses User Input for Battle Chat.
    ## ==================================================================================================
        
        temp_str =  entry.get_text()
        entry.set_text('')
        if temp_str != None:
            if temp_str[0] != '/':
                temp_str = 'SAYBATTLE ' + temp_str
                self.client.send(temp_str)
            elif temp_str[:4] == '/ME ' or temp_str[:4] == '/me ':
                temp_str = 'SAYBATTLEEX ' + temp_str[4:]
                self.client.send(temp_str)				
            elif temp_str[0] == '/':
                temp_parsed = temp_str.split(" ")
                args = ''
                for i in range (1, len(temp_parsed)):
                    args = args + temp_parsed[i]
                    if i != len(temp_parsed):
                        args = args + ' '	
                self.client.send(temp_parsed[0][1:], args)


    def UpdateTextbufferBattleChat(self, username, text, tag='Text'):
    ## ==================================================================================================
    ##  Updates Textbuffer for Battle Chat.
    ## ==================================================================================================
        
        try:
            gtk.gdk.threads_enter()
            iter = self.battle_chat_buffer.get_end_iter()
            self.battle_chat_buffer.insert(iter, '\n')
            iter = self.battle_chat_buffer.get_end_iter()

            if username != None:
                if tag != 'Action':
                    self.battle_chat_buffer.insert_with_tags_by_name(iter, '<' + username + '> ', tag)
                else:
                    self.battle_chat_buffer.insert_with_tags_by_name(iter, '* ' + username + ' ', tag)
                
            self.battle_chat_buffer.insert_with_tags_by_name(iter, text, tag)

            while self.battle_chat_buffer.get_line_count() > 50:
                self.battle_chat_buffer.delete(self.battle_chat_buffer.get_start_iter(), self.battle_chat_buffer.get_iter_at_line(1))
            self.battle_chat_textview.scroll_mark_onscreen(self.battle_chat_buffer.get_insert())
            gtk.gdk.threads_leave()

        except Exception, inst:
            print
            print 'UpdateTextBufferChat'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def PlayerPopupMenu(self, treeview, event):
    ## ==================================================================================================
    ##  Player Popup Menu for Player List.
    ## ==================================================================================================
        
        try:
            gtk.gdk.threads_leave()
            treeselection = treeview.get_selection()
            (model, iter) = treeselection.get_selected()
            if iter != None:
                liststore = treeview.get_model()
                if event.type == gtk.gdk._2BUTTON_PRESS:
                    if event.button == 1:
                        self.CreatePMChat(liststore.get_value(iter, 0))
            gtk.gdk.threads_enter()

        except Exception, inst:
            print
            print 'PlayerPopupMenu failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def BattlePopupMenu(self, treeview, event):
    ## ==================================================================================================
    ##  Battle Popup Menu for Battle List.
    ## ==================================================================================================
        
        try:
            if self.network_game == False:
                treeselection = treeview.get_selection()
                (model, iter) = treeselection.get_selected()
                if iter != None:
                    if event.type == gtk.gdk._2BUTTON_PRESS:
                        if event.button == 1:
                            treeselection = self.battle_treeview.get_selection()
                            (model, iter) = treeselection.get_selected()
                            if model.get_value(iter, 15) == None and model.get_value(iter, 16) == False:
                                menu = gtk.Menu()
                                menu.show()
                                join_item = gtk.MenuItem("Join Battle")
                                menu.append(join_item)
                                join_item.show()
                                menu.popup(None, None, None, event.button, event.time)
                                join_item.connect("button_press_event", self.BattleJoin, iter)

        except Exception, inst:
            print
            print 'BattlePopupMenu failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def BattleJoin(self, widget, event, iter):
    ## ==================================================================================================
    ##  Gets BattleID & Game Auth Status & passes to self.joinbattle
    ## ==================================================================================================

        passworded = self.battle_liststore.get_value(iter, 7)
        battle_id = str(self.battle_liststore.get_value(iter, 0))
        if passworded == gtk.STOCK_DIALOG_AUTHENTICATION:
            self.CreatePasswordDialog('Enter Password', battle_id)
        else:
            self.battle_password = None
            self.joinbattle(battle_id, True)


    def Connection(self, button, server=None, port=None, username=None, password=None):
    ## ==================================================================================================
    ##  Handles connecting / disconnecting to lobby server.
    ## ==================================================================================================
        
        if self.connect_button.get_stock_id() == gtk.STOCK_DISCONNECT:
            self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
            if server == None:
                server, port, self.spring_udp_port, username, password = self.lobby_preferences.get_default_lobby_server()
            if server != None:
                self.username = username
                self.client = Lobby.client(self)
                self.client.connect(server, port, username, password)
                self.client.reLogin()
                self.battle.player_name_online = username
                self.battle.UpdatePlayerName()
            else:
                self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)
                self.lobby_preferences.show_add_lobby_server_frame()
                self.lobby_preferences.show()
                # TODO: Add Code to change Battle User Name to profile default

        elif self.connect_button.get_stock_id() == gtk.STOCK_CONNECT:
            self.battle.host_battle_button.set_active(False) 
            self.battle.host_battle_button.set_sensitive(False)           
            self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
            self.client.disconnect('User')
            self.IntialiseServerVariables()
            self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)


    def UpdateConnectedButton(self, connected):
    ## ==================================================================================================
    ##  Updates Connect upon sucessful login / disconnecting from lobby server.
    ##   Also Updates Battle Hosting Button
    ## ==================================================================================================
        gtk.gdk.threads_enter()
        try:
       
            if connected == True:
                self.connect_button.set_stock_id(gtk.STOCK_CONNECT)
                self.battle.host_battle_button.set_sensitive(True) 
                # TODO: Add Tooltip
                # TODO: Add Code to exit Online Battle
            else:
                self.battle.host_battle_button.set_active(False)
                self.battle.host_battle_button.set_sensitive(False)             
                self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
                self.IntialiseServerVariables()            
                self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)            
        except Exception, inst:
            print
            print 'TESTING'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y            
        gtk.gdk.threads_leave()


    def WarningDialog(self, title, text):
        
        dialog = gtk.Dialog(title, self.window, gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT, (gtk.STOCK_CLOSE, gtk.RESPONSE_CLOSE))
        dialog.vbox.pack_start(gtk.Label(text))
        dialog.show_all()
        result = dialog.run()
        dialog.destroy()


    def InfoDialog(self, title, text):
        
        gtk.gdk.threads_enter()
        dialog = gtk.Dialog(title, self.window, gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT, (gtk.STOCK_CLOSE, gtk.RESPONSE_CLOSE))
        dialog.vbox.pack_start(gtk.Label(text))
        dialog.show_all()
        result = dialog.run()
        dialog.destroy()
        gtk.gdk.threads_leave()


    def CreatePasswordDialog(self, title, battle_id):
        
        self.battle_password = None
        popup_password_window = gtk.Window()
        popup_password_window.set_modal(True)
        popup_password_window.set_title(title)
        popup_password_window.show()

        table = gtk.Table(rows=2, columns=2, homogeneous=False)
        table.show()
        popup_password_window.add(table)

        title_label = label_create("Password") 
        table.attach(title_label, 0,1,0,1)

        password_entry = gtk.Entry(max=0)
        password_entry.set_width_chars(14)
        password_entry.show()
        table.attach(password_entry, 1,2,0,1)

        host_battle_button = gtk.Button(label="Ok", stock=None)
        host_battle_button.connect("clicked", self.ClosePasswordDialog, popup_password_window, password_entry, battle_id)
        host_battle_button.show()

        table.attach(host_battle_button, 0,2,1,2, xoptions=gtk.FILL, yoptions=gtk.FILL, xpadding=0, ypadding=0)


    def ClosePasswordDialog(self, event, popup_password_window, password_entry, battle_id):
        
        self.battle_password = password_entry.get_text()
        popup_password_window.destroy()
        self.joinbattle( (str(battle_id) + ' ' + self.battle_password), True)


    def GetCountryFlag(self, country):
    ## ==================================================================================================
    ##  Checks if Country Flag is already loaded & loads if its not
    ## ==================================================================================================
        
        if self.country_flags.has_key(country) == True:
            return self.country_flags[country]
        else:
            pixbuf = None
            file_location = os.path.join(self.unity_location, 'resources', 'flags', country + '.png')
            if os.path.isfile(file_location) == True:
                pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,15)
            self.country_flags[country] = pixbuf
            return pixbuf


    def GetRankImage(self, rank):
    ## ==================================================================================================
    ##  Checks if Rank Image is already loaded & loads if its not
    ## ==================================================================================================
    
        if self.rank_images.has_key(rank) == True:
            return self.rank_images[rank]
        else:
            file_location = os.path.join(self.unity_location, 'resources', 'ranks', rank + '.png')
            pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,25)
            self.rank_images[rank] = pixbuf
            return pixbuf


    def GetStatusImage(self, status):
    ## ==================================================================================================
    ##  Checks if Status Image is already loaded & loads if its not
    ## ==================================================================================================
        
        if self.status_images.has_key(status) == True:
            return self.status_images[status]
        else:
            file_location = os.path.join(self.unity_location, 'resources', 'status', status + '.png')
            pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,25)
            self.status_images[status] = pixbuf
            return pixbuf


    def RegisterAccount(self, server_address, server_port, username, encoded_password):
    ## ==================================================================================================
    ##  Register's Account to lobby server
    ## ==================================================================================================
        
        if self.connect_button.get_stock_id() == gtk.STOCK_DISCONNECT:
            self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
            self.client = Lobby.client(self)
            self.client.connect(server_address, server_port, username, encoded_password)
            self.client.Register()
        elif self.connect_button.get_stock_id() == gtk.STOCK_CONNECT:
            self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
            self.client.disconnect('User')
            self.IntialiseServerVariables()
            self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)

            self.client = Lobby.client(self)
            self.client.connect(server_address, server_port, username, encoded_password)
            self.client.Register()
        else:
            self.WarningDialog('Warning', 'Plz disconnect from lobby server & try again')


    def UpdateChannelUserFlag(self, column, cell, model, iter):
        
        pixbuf = model.get_value(iter, 1)
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateChannelUserStatus(self, column, cell, model, iter):
        
        pixbuf = model.get_value(iter, 4)
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateChannelAdmin(self, column, cell, model, iter):
        
        pixbuf = model.get_value(iter, 6)
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateChannelRank(self, column, cell, model, iter):
        
        pixbuf = model.get_value(iter, 5)
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateChannelBot(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Updates Channel Bot Image in Battle TreeView
    ## ==================================================================================================

        stock = model.get_value(iter, 8)
        if stock != None:
                pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
        else:
            pixbuf = None
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateUserFontColor(self, column, cell, model, iter):
        
        status = model.get_value(iter, 7)
        if status == 'Present':
            color = gtk.gdk.Color(self.user_color_options['User Present'][0], self.user_color_options['User Present'][1], self.user_color_options['User Present'][2])	
        elif status == 'InGame':
            color = gtk.gdk.Color(self.user_color_options['User InGame'][0], self.user_color_options['User InGame'][1], self.user_color_options['User InGame'][2])	
        else:
            color = gtk.gdk.Color(self.user_color_options['User AFK'][0], self.user_color_options['User AFK'][1], self.user_color_options['User AFK'][2])	
        cell.set_property('foreground-gdk', color)
        

    def UpdateBattleNat(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Updates Battle Nat Image in Battle TreeView
    ## ==================================================================================================

        stock = model.get_value(iter, 2)
        if stock != None:
                pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
        else:
            pixbuf = None
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateBattleReplay(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Updates Battle Nat Image in Battle TreeView
    ## ==================================================================================================

        stock = model.get_value(iter, 1)
        if stock != None:
                pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
        else:
            pixbuf = None
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateBattleAuth(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Updates Battle Auth Image in Battle TreeView
    ## ==================================================================================================

        stock = model.get_value(iter, 7)
        if stock != None:
                pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
        else:
            pixbuf = None
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateBattleLocked(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Updates Battle Locked Image in Battle TreeView
    ## ==================================================================================================

        stock = model.get_value(iter, 15)
        if stock != None:
                pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
        else:
            pixbuf = None
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateBattleBot(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Updates Battle Bot Image in Battle TreeView
    ## ==================================================================================================

        stock = model.get_value(iter, 17)
        if stock != None:
                pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
        else:
            pixbuf = None
        cell.set_property('pixbuf', pixbuf)
        return


    def UpdateBattlePlayerList(self, iter):
    ## ==================================================================================================
    ##  Updates Player List in Battle TreeView
    ## ==================================================================================================
    
        try:
            player_list = self.battle_liststore.get_value(iter, 13)                            
            players = player_list[0]
            for o in range(1,len(player_list)):
                players = players + ', ' + player_list[o]
            self.battle_liststore.set_value(iter, 14, players)

        except Exception, inst:
            print
            print 'UpdateBattlePlayerList'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y            
        
        
        return


    def UpdateBattleFontColor(self, column, cell, model, iter):
    ## ==================================================================================================
    ##  Updates Battle Font Color in Battle TreeView
    ## ==================================================================================================
        
        boolean = model.get_value(iter, 16)
        if boolean == True:
            color = gtk.gdk.Color(self.user_color_options['Battle In Progress'][0], self.user_color_options['Battle In Progress'][1], self.user_color_options['Battle In Progress'][2])	
        else:
            color = gtk.gdk.Color(self.user_color_options['Battle'][0], self.user_color_options['Battle'][1], self.user_color_options['Battle'][2])	
        cell.set_property('foreground-gdk', color)
        return


    def BattleStatusEncode(self, ready, team, allyteam, mode, handicap, sync, side):
    ## ==================================================================================================
    ##  Builds a status bitmask. teamcolor is for compatibility
    ## ==================================================================================================
        result = 0
        result += ready<<1
        result += team<<2
        result += allyteam<<6
        result += mode<<10
#		result += teamcolor<<18
        result += sync<<22
        result += side<<24
        return result


    def BattleStatusDecode(self, status):
    ## ==================================================================================================
    ##  Converts a status bitmask to a tuple
    ## ==================================================================================================
        ready = (status & int('2',16)) >> 1
        team = (status & int('3C',16)) >> 2
        ally = (status & int('3C0',16)) >> 6
        mode = (status & int('400',16)) >> 10
        handicap = (status & int('23F800',16)) >> 11
#		teamcolor = (status & int('3C0000',16)) >> 18
        sync = (status & int('C00000',16)) >> 22
        side = (status & int('F000000',16)) >> 24
#		return (ready,team,ally,mode,handicap,teamcolor,sync,side)
        return (ready, team, ally, mode, handicap, sync, side)


#---Lobby Protocols---#000000#FFFFFF--------------------------------------------

    def tasserver(self, command):

        try:
            gtk.gdk.threads_enter()
            self.WarningDialog('Error Incompatible Lobby Server', ('Plz update UnityLobby & Spring to newer versions' + '\n' + 'Lobby Version = ' + command[0] + '\n' + 'Compatibale Versions = ' + '0.31 & 0.32 & 0.33'))
            gtk.gdk.threads_leave()            

        except Exception, inst:
            print
            print 'servermsg'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y

            
    def servermsg(self, command):
        
        try:
            text = 'Server Message ->'
            for i in range(0, len(command)):
                text = text + ' ' + command[i]
            self.UpdateTextbufferChannelChat(self.lobby_channel_names[0], None, text)
            
        except Exception, inst:
            print
            print 'servermsg'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def servermsgbox(self, command):
        
        try:
            if len(command) != 0:
                text = command[0]
            else:
                text = ''
            for i in range(1, len(command)):
                text = text + ' ' + command[i]
            gtk.gdk.threads_enter()
            self.WarningDialog('Server Message', text)
            gtk.gdk.threads_leave()
            
        except Exception, inst:
            print
            print 'servermsgbox'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y

        
    def channelmessage(self, command):
        
        try:
            if len(command) != 0:
                text = 'Channel Message -> ' + command[1]
            else:
                text = 'Channel Message ->'
            for i in range(2, len(command)):
                text = text + command[i]
            self.UpdateTextbufferChannelChat(command[0], None, text)
            
        except Exception, inst:
            print
            print 'channelmessage'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y

        
    def denied(self, command):
        
        try:
            if len(command) != 0:
                temp = command[0].split("\t")
                text = temp[0]
                for o in range(1, len(temp)):
                    text = text + ' ' + temp[o]
            else:
                text = ''
            for i in range(1, len(command)):
                text = text + ' ' + command[i]
            gtk.gdk.threads_enter()
            self.WarningDialog('Denied', text)
            gtk.gdk.threads_leave()
            
        except Exception, inst:
            print
            print 'denied'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def motd(self, command):
        
        try:
            if len(command) != 0:
                text = command[0]
            else:
                text = ''
            for i in range(1, len(command)):
                text = text + ' ' + command[i]
            self.UpdateTextbufferChannelChat(self.lobby_channel_names[0], None, text)
            
        except Exception, inst:
            print
            print 'motd'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def join(self, command):
        
        try:
            self.CreateChannelChat(command[0], True)

        except Exception, inst:
            print
            print 'join failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def said(self, command):
        
        try:
            text = ''
            for i in range(2, len(command)):
                text = text + ' ' + command[i]
            self.UpdateTextbufferChannelChat(command[0], command[1], text)
            
        except Exception, inst:
            print
            print 'said'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def saidex(self, command):
        try:
            text = ''
            for i in range(2, len(command)):
                text = text + ' ' + command[i]
            self.UpdateTextbufferChannelChat(command[0], command[1], text, 'Action')
            
        except Exception, inst:
            print
            print 'said'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def saidbattle(self, command):
        
        try:
            text = ''
            for i in range(1, len(command)):
                text = text + ' ' + command[i]
            self.UpdateTextbufferBattleChat(command[0], text)
            
        except Exception, inst:
            print
            print 'saidbattle'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def saidbattleex(self, command):
        
        try:
            text = ''
            for i in range(1, len(command)):
                text = text + ' ' + command[i]
            self.UpdateTextbufferBattleChat(command[0], text, 'Action')
            
        except Exception, inst:
            print
            print 'saidbattle'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def mystatus(self, command, send=False):
        
        try:
            if send == False:
                print
                print
                print ' RECEIVED MYSTATUS'
                print command
                print
                print
            else:
                self.client.send("MYSTATUS", command)
        except Exception, inst:
            print
            print 'mystatuse'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def adduser(self, username, country, cpu):
        
        try:
            if username == self.username:
                self.userlist[0] = Lobby.user(self, username, country, cpu, None)
            else:
                self.userlist.append(Lobby.user(self, username, country, cpu, None))
        except Exception, inst:
            print
            print 'adduser'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def removeuser(self, command):
        
        try:
            for o in range(0,len(self.userlist)):
                if self.userlist[o].name == command:
                    self.userlist.pop(o)
                    break
                
        except Exception, inst:
            print
            print 'removeuser'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def joinedfailed(self, command):
        
        try:
            if len(command) != 0:
                text = command[0]
            else:
                text = ''
            for i in range(1, len(command)):
                text = text + ' ' + command[i]
            gtk.gdk.threads_enter()
            self.WarningDialog('Join Channel Failed', text)
            gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'joinfailed'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def clients(self, channel, clients):
        
        try:
            for o in range(0,len(self.lobby_channel_names)):
                if self.lobby_channel_names[o] == channel:
                    channel_index = o
                    break

            for o in range(0,len(clients)):

                for p in range(0,len(self.userlist)):
                    if self.userlist[p].name == clients[o]:
                        self.userlist[p].addChannel(channel)

                        username = self.userlist[p].name
                        flag = self.GetCountryFlag(self.userlist[p].country)
                        cpu = self.userlist[p].cpu
                        ip = self.userlist[p].ip

                        if self.userlist[p].isAway() == True:
                            status_image = self.GetStatusImage('away')
                            status = 'AFK'
                        elif self.userlist[p].inGame() == True:
                            status_image = self.GetStatusImage('ingame')
                            status = 'InGame'
                        else:
                            status_image = self.GetStatusImage('here')
                            status = 'Present'

                        rank = self.userlist[p].getRank()
                        rank_image = self.GetRankImage(rank)
                        admin = self.userlist[p].admin()
                        if admin == True:
                            admin_image = self.GetRankImage("admin")
                        else:
                            admin_image = None

                        if self.userlist[p].isBot() == True:
                            bot = 'unitylobby-bot'
                        else:
                            bot = None

                        gtk.gdk.threads_enter()
                        self.lobby_channel_users[channel_index].append([username, flag, cpu, ip, status_image, rank_image, admin_image, status, bot])
                        self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][4], self.UpdateChannelAdmin)
                        self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][3], self.UpdateChannelRank)
                        self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][2], self.UpdateUserFontColor)
                        self.lobby_channel_users_columns[channel_index][1].set_cell_data_func(self.lobby_channel_users_cells[channel_index][1], self.UpdateChannelUserFlag)
                        self.lobby_channel_users_columns[channel_index][0].set_cell_data_func(self.lobby_channel_users_cells[channel_index][0], self.UpdateChannelUserStatus)
                        gtk.gdk.threads_leave()
                        break

        except Exception, inst:
            print
            print 'clients'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def left(self, command):
        
        try:
            for i in range(0,len(self.lobby_channel_names)):
                if command[0] == self.lobby_channel_names[i]:
                    channel_index = i

            iter = self.lobby_channel_users[channel_index].get_iter_first()
            while iter != None:
                username = self.lobby_channel_users[channel_index].get_value(iter,0)
                if username == command[1]:
                    gtk.gdk.threads_enter()
                    self.lobby_channel_users[channel_index].remove(iter)
                    gtk.gdk.threads_leave()
                    break
                iter = self.lobby_channel_users[channel_index].iter_next(iter)

            text = ''
            for i in range(2, len(command)):
                text = text + ' ' + command[i]
            text = '* ' + command[1] + ' has left ' + command[0] + ' (' + text[1:] + ')'
            self.UpdateTextbufferChannelChat(command[0], None, text, "Leave")
            
        except Exception, inst:
            print
            print 'left'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def joined(self, channel, username):
        
        try:
            channel_index = self.lobby_channel_names.index(channel)

            for o in range(0,len(self.userlist)):
                if self.userlist[o].name == username:
                    self.userlist[o].addChannel(channel)

                    username = self.userlist[o].name
                    flag = self.GetCountryFlag(self.userlist[o].country)
                    cpu = self.userlist[o].cpu
                    ip = self.userlist[o].ip

                    if self.userlist[o].inGame() == True:
                        status_image = self.GetStatusImage('ingame')
                        status = 'InGame'
                    elif self.userlist[o].isAway() == True:
                        status_image = self.GetStatusImage('away')
                        status = 'AFK'
                    else:
                        status_image = self.GetStatusImage('here')
                        status = 'Present'

                    rank = self.userlist[o].getRank()
                    rank_image = self.GetRankImage(rank)
                    admin = self.userlist[o].admin()
                    if admin == True:
                        admin_image = self.GetRankImage("admin")
                    else:
                        admin_image = None

                    if self.userlist[o].isBot() == True:
                        bot = 'unitylobby-bot'
                    else:
                        bot = None

                    gtk.gdk.threads_enter()
                    self.lobby_channel_users[channel_index].append([username, flag, cpu, ip, status_image, rank_image, admin_image, status, bot])
                    self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][5], self.UpdateChannelBot)
                    self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][4], self.UpdateChannelAdmin)
                    self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][3], self.UpdateChannelRank)
                    self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][2], self.UpdateUserFontColor)
                    self.lobby_channel_users_columns[channel_index][1].set_cell_data_func(self.lobby_channel_users_cells[channel_index][1], self.UpdateChannelUserFlag)
                    self.lobby_channel_users_columns[channel_index][0].set_cell_data_func(self.lobby_channel_users_cells[channel_index][0], self.UpdateChannelUserStatus)
                    text = '* ' + username + ' has joined ' + channel
                    self.UpdateTextbufferChannelChat(username, None, text, "Join")
                    gtk.gdk.threads_leave()
                    break

        except Exception, inst:
            print
            print 'joined failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def clientstatus(self, username, status):
    ## ==================================================================================================
    ##  Function for Lobby Protocol  
    ## 	  * CLIENTSTATUS username status
    ## ==================================================================================================

        try:
            for o in range(0,len(self.userlist)):
                if self.userlist[o].name == username:
                    old_ingame_status = self.userlist[o].inGame()
                    self.userlist[o].updateStatus(status)

                    channel_list = self.userlist[o].listChannels()
                    pm_list = self.userlist[o].listPMs()
                    battle_id = self.userlist[o].getBattleID()


                    if self.userlist[o].inGame() == True:
                        status_image = self.GetStatusImage('ingame')
                        status = 'InGame'
                    elif self.userlist[o].isAway() == True:
                        status_image = self.GetStatusImage('away')
                        status = 'AFK'
                    else:
                        status_image = self.GetStatusImage('here')
                        status = 'Present'
                        
                    if self.userlist[o].getBattleHost() == True:
                        battle_id = self.userlist[o].getBattleID()
                        iter = self.battle_liststore.get_iter_first()
                        while iter != None:
                            if self.battle_liststore.get_value(iter,0) == battle_id:
                                gtk.gdk.threads_enter()
                                self.battle_liststore.set(iter, 16, self.userlist[o].inGame())
                                self.battle_column_1.set_cell_data_func(self.cell1, self.UpdateBattleFontColor)
                                self.battle_column_2.set_cell_data_func(self.cell2, self.UpdateBattleFontColor)
                                self.battle_column_3.set_cell_data_func(self.cell3, self.UpdateBattleFontColor)
                                self.battle_column_4.set_cell_data_func(self.cell4, self.UpdateBattleFontColor)
                                self.battle_column_5.set_cell_data_func(self.cell5, self.UpdateBattleFontColor)                

                                if self.userlist[o].isBot() == True:
                                    self.battle_liststore.set(iter, 17, 'unitylobby-bot')
                                else:
                                    self.battle_liststore.set(iter, 17, None)
                                self.battle_column_0.set_cell_data_func(self.cell0e, self.UpdateBattleBot)
                                gtk.gdk.threads_leave()
                                break

                            iter = self.battle_liststore.iter_next(iter)


                    rank = self.userlist[o].getRank()
                    rank_image = self.GetRankImage(rank)

                    if self.userlist[o].admin() == True:
                        admin_image = self.GetRankImage("admin")
                    else:
                        admin_image = None

                    # Channel Chat
                    for p in range(0,len(channel_list)):
                        index = self.lobby_channel_names.index(channel_list[p])
                        iter = self.lobby_channel_users[index].get_iter_first()
                        while iter != None:
                            if self.lobby_channel_users[index].get_value(iter,0) == username:
                                gtk.gdk.threads_enter()
                                self.lobby_channel_users[index].set_value(iter, 4, status_image)
                                self.lobby_channel_users[index].set_value(iter, 5, rank_image)
                                self.lobby_channel_users[index].set_value(iter, 6, admin_image)
                                self.lobby_channel_users[index].set_value(iter, 7, status)
                                if self.userlist[o].isBot() == True:
                                    self.lobby_channel_users[index].set_value(iter, 8, 'unitylobby-bot')
                                else:
                                    self.lobby_channel_users[index].set_value(iter, 8, None)
                                self.lobby_channel_users_columns[index][2].set_cell_data_func(self.lobby_channel_users_cells[index][5], self.UpdateChannelBot)
                                self.lobby_channel_users_columns[index][2].set_cell_data_func(self.lobby_channel_users_cells[index][4], self.UpdateChannelAdmin)
                                self.lobby_channel_users_columns[index][2].set_cell_data_func(self.lobby_channel_users_cells[index][3], self.UpdateChannelRank)
                                self.lobby_channel_users_columns[index][2].set_cell_data_func(self.lobby_channel_users_cells[index][2], self.UpdateUserFontColor)
                                self.lobby_channel_users_columns[index][1].set_cell_data_func(self.lobby_channel_users_cells[index][1], self.UpdateChannelUserFlag)
                                self.lobby_channel_users_columns[index][0].set_cell_data_func(self.lobby_channel_users_cells[index][0], self.UpdateChannelUserStatus)
                                gtk.gdk.threads_leave()
                                break
                            iter = self.lobby_channel_users[index].iter_next(iter)

                    # PM Chat
                    for p in range(0,len(pm_list)):
                        index = self.lobby_pm_names.index(pm_list[p])
                        iter = self.lobby_pm_users[index].get_iter_first()
                        while iter != None:
                            if self.lobby_pm_users[index].get_value(iter,0) == username:
                                gtk.gdk.threads_enter()
                                self.lobby_pm_users[index].set_value(iter, 4, status_image)
                                self.lobby_pm_users[index].set_value(iter, 5, rank_image)
                                self.lobby_pm_users[index].set_value(iter, 6, admin_image)
                                self.lobby_pm_users[index].set_value(iter, 7, status)
                                if self.userlist[o].isBot() == True:
                                    self.lobby_pm_users[index].set_value(iter, 8, 'unitylobby-bot')
                                else:
                                    self.lobby_pm_users[index].set_value(iter, 8, None)
                                self.lobby_pm_users_columns[index][2].set_cell_data_func(self.lobby_pm_users_cells[index][5], self.UpdateChannelBot)
                                self.lobby_pm_users_columns[index][2].set_cell_data_func(self.lobby_pm_users_cells[index][4], self.UpdateChannelAdmin)
                                self.lobby_pm_users_columns[index][2].set_cell_data_func(self.lobby_pm_users_cells[index][3], self.UpdateChannelRank)
                                self.lobby_pm_users_columns[index][2].set_cell_data_func(self.lobby_pm_users_cells[index][2], self.UpdateUserFontColor)
                                self.lobby_pm_users_columns[index][1].set_cell_data_func(self.lobby_pm_users_cells[index][1], self.UpdateChannelUserFlag)
                                self.lobby_pm_users_columns[index][0].set_cell_data_func(self.lobby_pm_users_cells[index][0], self.UpdateChannelUserStatus)
                                gtk.gdk.threads_leave()
                                break
                            iter = self.lobby_pm_users[index].iter_next(iter)

                    # Battle Chat
                    if (battle_id != None) and (battle_id == self.battle_id):
                        iter = self.battle_user_liststore.get_iter_first()
                        while iter != None:
                            if self.battle_user_liststore.get_value(iter,0) == username:
                                gtk.gdk.threads_enter()

                                self.battle_user_liststore.set_value(iter, 4, status_image)
                                self.battle_user_liststore.set_value(iter, 5, rank_image)
                                self.battle_user_liststore.set_value(iter, 6, admin_image)
                                self.battle_user_liststore.set_value(iter, 7, status)
                                if self.userlist[o].isBot() == True:
                                    self.battle_user_liststore.set_value(iter, 8, 'unitylobby-bot')
                                else:
                                    self.battle_user_liststore.set_value(iter, 8, None)
                                self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[5], self.UpdateChannelBot)
                                self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[4], self.UpdateChannelAdmin)
                                self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[3], self.UpdateChannelRank)
                                self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[2], self.UpdateUserFontColor)
                                self.battle_chat_users_columns[1].set_cell_data_func(self.battle_chat_users_cells[1], self.UpdateChannelUserFlag)
                                self.battle_chat_users_columns[0].set_cell_data_func(self.battle_chat_users_cells[0], self.UpdateChannelUserStatus)
                                if (self.userlist[o].getBattleHost() == True) and (o != 0):
                                    if (old_ingame_status == False) and (self.userlist[o].inGame() == True):
                                        self.battle.launch_spring()                                
                                gtk.gdk.threads_leave()
                                break
                            iter = self.battle_user_liststore.iter_next(iter)

        except Exception, inst:
            print
            print 'clientstatus failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def channeltopic(self, command):
        
        try:
            text = ''
            for i in range(3, len(command)):
                text = text + ' ' + command[i]
            text = "* Topic for " + command[0] + " is: " + text
            self.UpdateTextbufferChannelChat(command[0], None, text, "Channel Topic")
            text = "* Topic for " + command[0] + " set by: " + command[1]  # + ' at ' + str(command[2])
            self.UpdateTextbufferChannelChat(command[0], None, text, "Channel Topic")
        except Exception, inst:
            print
            print 'channeltopic'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def saidprivate(self, command):
        
        try:
            index = -1
            for i in range(0, len(self.lobby_pm_names)):
                if command[0] == self.lobby_pm_names[i]:
                    index = i
                    break
            if index == -1:
                self.CreatePMChat(command[0])

            text = ''
            for i in range(1, len(command)):
                text = text + ' ' + command[i]
            self.UpdateTextbufferPMChat(command[0], command[0], text)
        except Exception, inst:
            print
            print 'saidprivate'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def sayprivate(self, command):
        
        try:
            text = ''
            for i in range(1, len(command)):
                text = text + ' ' + command[i]
            self.UpdateTextbufferPMChat(command[0], self.username, text)
        except Exception, inst:
            print
            print 'sayprivate'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def agreement(self, command):
        
        try:
            text = ''
            for i in range(0, len(command)):
                text = text + ' ' + command[i]
            self.server_agreement = self.server_agreement + text
        except Exception, inst:
            print
            print 'agreement'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def agreementend(self):
        
        try:
            gtk.gdk.threads_enter()
            dialog = gtk.Dialog('Server Agreement', self.window, gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT, (gtk.STOCK_OK, gtk.RESPONSE_OK, gtk.STOCK_NO, gtk.RESPONSE_NO))
            text = gtk.Label(self.server_agreement)
            text.set_line_wrap(True)
            dialog.vbox.pack_start(text)
            dialog.show_all()
            result = dialog.run()
            dialog.destroy()
            gtk.gdk.threads_leave()

            if result == gtk.RESPONSE_OK:
                self.client.send("CONFIRMAGREEMENT")
                self.client.reLogin()
                gtk.gdk.threads_enter()
                self.connect_button.set_stock_id(gtk.STOCK_CONNECT)
                gtk.gdk.threads_leave()
            elif result == gtk.RESPONSE_NO:
                self.client.disconnect('User')
                self.IntialiseServerVariables()
                gtk.gdk.threads_enter()
                self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)
                gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'agreementend'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def forceleavechannel(self, command):
        
        try:
            text = ''
            for i in range(2, len(command)):
                text = text + ' ' + command[i]
            self.RemoveChannelChatBuffer(command[0])
            gtk.gdk.threads_enter()
            self.WarningDialog('Force Leave Channel ' + command[0], '<' + command[0] + '>' + text)
            gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'forceleavechannel'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y




    def battleopened(self, command):
        
        try:
            temp = '' + command[10]
            for o in range(11,len(command)):
                temp = temp + ' ' + command[o]
            temp = temp.split("\t")
            gtk.gdk.threads_enter()		
            
            # Players List & Amount of Players
            players_list = [command[3]]
            if len(command[6]) == 1:
                amount_of_players =  ' 1' + '/' + command[6] + '  (0)'
            else:
                amount_of_players =  ' 1' + '/' + command[6]  + ' (0)'

                                                # 0           1     2     3           4           5                6                7     8      9           10            11       12       13            14          15    16    17    18
            iter = self.battle_liststore.append([ command[0], None, None, command[3], command[4], int(command[5]), int(command[6]), None, None , command[9], temp[0][:-4], temp[1], temp[2], players_list, command[3], None, None, None, amount_of_players ])
            self.UpdateBattlePlayerList(iter)

            # Battle Type
            if command[1] == '0':
                self.battle_liststore.set(iter, 1, None)
            else:
                self.battle_liststore.set(iter, 1, gtk.STOCK_ZOOM_IN)
            self.battle_column_0.set_cell_data_func(self.cell0d, self.UpdateBattleReplay)

            # Nat
            if command[2] == '0':
                self.battle_liststore.set(iter, 2, None)
            else:
                self.battle_liststore.set(iter, 2, gtk.STOCK_DIALOG_WARNING)

                self.battle_column_0.set_cell_data_func(self.cell0c, self.UpdateBattleNat)

            # Passworded
            if command[7] == '0':
                self.battle_liststore.set(iter, 7, None)
            else:
                self.battle_liststore.set(iter, 7, gtk.STOCK_DIALOG_AUTHENTICATION)


                self.battle_column_0.set_cell_data_func(self.cell0b, self.UpdateBattleAuth)
            gtk.gdk.threads_leave()

            # Founder Status
            for o in range(0,len(self.userlist)):
                if self.userlist[o].name == command[3]:
                    self.userlist[o].updateBattleHost(True)
                    self.userlist[o].updateBattleID(command[0])
                    gtk.gdk.threads_enter()
                    if self.userlist[o].inGame() == True:
                        self.battle_liststore.set(iter, 16, True)
                    else:
                        self.battle_liststore.set(iter, 16, False)
                        self.battle_column_1.set_cell_data_func(self.cell1, self.UpdateBattleFontColor)
                        self.battle_column_2.set_cell_data_func(self.cell2, self.UpdateBattleFontColor)
                        self.battle_column_3.set_cell_data_func(self.cell3, self.UpdateBattleFontColor)
                        self.battle_column_4.set_cell_data_func(self.cell4, self.UpdateBattleFontColor)
                        self.battle_column_5.set_cell_data_func(self.cell5, self.UpdateBattleFontColor)

                    if self.userlist[o].isBot() == True:
                        self.battle_liststore.set(iter, 17, 'unitylobby-bot')
                    else:
                        self.battle_liststore.set(iter, 17, None)
                    self.battle_column_0.set_cell_data_func(self.cell0e, self.UpdateBattleBot)

                    gtk.gdk.threads_leave()
                    break			
            
        except Exception, inst:
            print
            print 'battleopened failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def battleclosed(self, battle_id):
        
        try:
            gtk.gdk.threads_enter()
            iter = self.battle_liststore.get_iter_first()
            while iter != None:
                if self.battle_liststore.get_value(iter,0) == battle_id:
                    self.battle_liststore.remove(iter)
                    break
                iter = self.battle_liststore.iter_next(iter)
            if battle_id == self.battle_id:
                self.battle.AbortNetworkGame()
                
            gtk.gdk.threads_leave()

        except Exception, inst:
            print
            print 'battleclosed failure'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def joinedbattle(self, command):
        
        try:
            iter = self.battle_liststore.get_iter_first()
            while iter != None:
                if self.battle_liststore.get_value(iter,0) == command[0]:
                    gtk.gdk.threads_enter()
                    
                    # Players List
                    players_list = self.battle_liststore.get_value(iter, 13)
                    players_list.append(command[1])
                    
                    # Amount of Players
                    amount_of_players = self.battle_liststore.get_value(iter, 18)
                    if len(players_list) >= 10:
                        amount_of_players = str(len(players_list)) + amount_of_players[2:]
                    else:
                        amount_of_players = ' ' + str(len(players_list))  + amount_of_players[2:]
                        
                    self.battle_liststore.set_value(iter, 13, players_list)
                    self.battle_liststore.set_value(iter, 18, amount_of_players)              
                    self.UpdateBattlePlayerList(iter)
                    gtk.gdk.threads_leave()
                    break
                iter = self.battle_liststore.iter_next(iter)

            if self.battle_id == command[0]:
                for o in range(0,len(self.userlist)):
                    if self.userlist[o].name == command[1]:
                        self.userlist[o].updateBattleID(command[0])

                        username = self.userlist[o].name
                        flag = self.GetCountryFlag(self.userlist[o].country)
                        cpu = self.userlist[o].cpu
                        ip = self.userlist[o].ip

                        if self.userlist[o].inGame() == True:
                            status_image = self.GetStatusImage('ingame')
                            status = 'InGame'
                        elif self.userlist[o].isAway() == True:
                            status_image = self.GetStatusImage('away')
                            status = 'AFK'
                        else:
                            status_image = self.GetStatusImage('here')
                            status = 'Present'
                            
                        if self.userlist[o].isBot() == True:
                            bot = 'unitylobby-bot'
                        else:
                            bot = None                        

                        rank = self.userlist[o].getRank()
                        rank_image = self.GetRankImage(rank)
                        admin = self.userlist[o].admin()
                        if admin == True:
                            admin_image = self.GetRankImage("admin")
                        else:
                            admin_image = None
                        
                        gtk.gdk.threads_enter()
                        self.battle_user_liststore.append([username, flag, cpu, ip, status_image, rank_image, admin_image, status, bot])
                        self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[4], self.UpdateChannelAdmin)
                        self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[3], self.UpdateChannelRank)
                        self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[2], self.UpdateUserFontColor)
                        self.battle_chat_users_columns[1].set_cell_data_func(self.battle_chat_users_cells[1], self.UpdateChannelUserFlag)
                        self.battle_chat_users_columns[0].set_cell_data_func(self.battle_chat_users_cells[0], self.UpdateChannelUserStatus)
                        text = '* ' + command[1] + ' has joined the Battle'
                        gtk.gdk.threads_leave()
                        self.UpdateTextbufferBattleChat(None, text, "Join")
                        break

        except Exception, inst:
            print
            print 'joinedbattle'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def leftbattle(self, command):
        
        try:
            if self.battle_id == command[0]:
                iter = self.battle_user_liststore.get_iter_first()
                while iter != None:
                    username = self.battle_user_liststore.get_value(iter,0)
                    if (username == command[1] and username != self.username):
                        gtk.gdk.threads_enter()
                        self.battle_user_liststore.remove(iter)
                        self.battle.RemovePlayer(username)
                        gtk.gdk.threads_leave()
                        text = '* ' + command[1] + ' has left the Battle'
                        self.UpdateTextbufferBattleChat(None, text, "Leave")
                        break
                    iter = self.battle_user_liststore.iter_next(iter)

            iter = self.battle_liststore.get_iter_first()
            while iter != None:
                if self.battle_liststore.get_value(iter,0) == command[0]:
                    gtk.gdk.threads_enter()

                    # Players List
                    players_list = self.battle_liststore.get_value(iter,13)
                    players_list.remove(command[1])

                    # Amount of Players
                    amount_of_players = self.battle_liststore.get_value(iter, 18)
                    if len(players_list) >= 10:
                        amount_of_players = str(len(players_list)) + amount_of_players[2:]
                    else:
                        amount_of_players = ' ' + str(len(players_list))  + amount_of_players[2:]
                   
                    self.battle_liststore.set_value(iter, 13, players_list)
                    self.battle_liststore.set_value(iter, 18, amount_of_players)
                    self.UpdateBattlePlayerList(iter)

                    gtk.gdk.threads_leave()
                    break
                iter = self.battle_liststore.iter_next(iter)

            for o in range(0,len(self.userlist)):
                if self.userlist[o].name == command[1]:
                    self.userlist[o].updateBattleHost(False)
                    self.userlist[o].updateBattleID(None)
                    break
            if command[1] == self.username:
                self.battle_id = None

        except Exception, inst:
            print
            print 'leftbattle'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def updatebattleinfo(self, command, send=False):
        
        try:
            if send == False:
                
                # Map Name
                mapname = command[4]
                for o in range(5, len(command)):
                    mapname = mapname + ' ' +  command[o]

                # Scan self.battle_liststore
                gtk.gdk.threads_enter()
                iter = self.battle_liststore.get_iter_first()
                while iter != None:
                    if self.battle_liststore.get_value(iter,0) == command[0]:
                        if command[2] == '0':
                            self.battle_liststore.set_value(iter, 15, None)
                        else:
                            self.battle_liststore.set_value(iter, 15, gtk.STOCK_NO)
                        self.battle_liststore.set_value(iter, 9, command[3])
                        self.battle_liststore.set_value(iter, 10, mapname[:-4])
                        break
                    iter = self.battle_liststore.iter_next(iter)
                self.battle_column_0.set_cell_data_func(self.cell0a, self.UpdateBattleLocked)

                # Check if Client is in Battle in question
                if command[0] == self.battle_id:
                    self.battle.UpdateBattleInfo(command[1:], False)
                    
                gtk.gdk.threads_leave()
            else:
                self.client.send("UPDATEBATTLEINFO", command)
                

        except Exception, inst:
            print
            print 'updatebattleinfo'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y, z = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y
            print 'z =', z


    def openbattle(self, args, send=False):
        try:
            if send == True:
                self.client.send("OPENBATTLE", args)
            else:

                self.battle.HostNetworkGameSucess(args)
        except Exception, inst:
            print
            print 'openbattle'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def openbattlefailed(self, command):
        
        try:
            text = command[0]
            for i in range(1, len(command)):
                text = text + ' ' +  command[i]
                
            gtk.gdk.threads_enter()
            self.WarningDialog('Open Battle Failed', text)
            self.battle.host_battle_button.handler_block(self.battle.host_battle_button_handler_id)       
            self.battle.host_battle_button.set_active(False)
            self.battle.host_battle_button.handler_unblock(self.battle.host_battle_button_handler_id)            
            gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'openbattlefailed'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y
            

    def joinbattlefailed(self, command):
        
        try:
            text = command[0]
            for i in range(1, len(command)):
                text = text + ' ' +  command[i]
                
            gtk.gdk.threads_enter()
            self.WarningDialog('Join Battle Failed', text)
            gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'joinbattlefailed'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y
            


    def leavebattle(self):
        
        try:
            self.client.send("LEAVEBATTLE")
        except Exception, inst:
            print
            print 'leavebattle'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def error(self, msg):
        
        try:
            gtk.gdk.threads_enter()
            self.WarningDialog('Error', msg[1])
            gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'error'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def joinbattle(self, command, send=False):
        
        try:
            if send == True:
                self.client.send("JOINBATTLE " + command)
            else:              
                gtk.gdk.threads_enter()
                self.battle_id = command[0]
                self.battle.JoinNetworkGame(command)
                gtk.gdk.threads_leave()


        except Exception, inst:
            print
            print 'joinbattle'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y, z = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y
            print 'z =', z


    def updatebattledetails(self, command, send=False):
        
        try:
            if send == True:
                self.client.send("UPDATEBATTLEDETAILS", command)
            else:
                gtk.gdk.threads_enter()
                self.battle.UpdateBattleDetails(command, False)
                gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'updatebattledetails'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def mybattlestatus(self, battlestatus, myteamcolor):
        
        try:
            command =  str(battlestatus) + ' ' + str(myteamcolor)
            self.client.send("MYBATTLESTATUS", command)
        except Exception, inst:
            print
            print 'mybattlestatus'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y
            
    def clientbattlestatus(self, command):
        
        try:
            gtk.gdk.threads_enter()
            self.battle.ClientBattleStatus(command)
            gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'clientbattlestatus'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def requestbattlestatus(self):
        
        try:
            gtk.gdk.threads_enter()
            self.battle.UpdateMyBattleStatus(None, [None])
            gtk.gdk.threads_leave()
        except Exception, inst:
            print
            print 'requestbattlestatus'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y
            
    def forcefrombattle(self, command):
        
        try:
            self.client.send("FORCEFROMBATTLE", command)
        except Exception, inst:
            print
            print 'forcefrombattle'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def forcequitbattle(self):
        
        try:
            self.InfoDialog('Kicked', 'Host has kicked u from Battle')
            self.battle.AbortHostNetworkGame()
        except Exception, inst:
            print
            print 'forcequitchannel'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y

            
            
    def forceteamno(self, command):
        
        try:
            self.client.send("FORCETEAMNO", command)
        except Exception, inst:
            print
            print 'forceteamno'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y


    def forceallyno(self, command):
        
        try:
            self.client.send("FORCEALLYNO", command)
        except Exception, inst:
            print
            print 'forceallyno'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y 

            
    def forceteamcolor(self, command):
        
        try:
            self.client.send("FORCETEAMCOLOR", command)
        except Exception, inst:
            print
            print 'forceteamcolor'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y  
            

    def disableunits(self, command, send=False):
        try:
            if send == True:
                self.client.send("DISABLEUNITS", command)
            else:
                gtk.gdk.threads_enter()        
                self.battle.DisableUnits(command[1:])
                gtk.gdk.threads_leave()        
        except Exception, inst:
            print
            print 'disableunits'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y 
    

    def enableunits(self, command, send=False):
        try:
            if send == True:
                self.client.send("ENABLEUNITS", command)
            else:
                gtk.gdk.threads_enter()        
                self.battle.EnableUnits(command[1:])
                gtk.gdk.threads_leave()        
        except Exception, inst:
            print
            print 'enableunits'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y 
    
    
    
    def enableallunits(self, command, send=False):
        try:
            if send == True:
                self.client.send("ENABLEALLUNITS", command)
            else:
                gtk.gdk.threads_enter()        
                self.battle.EnableAllUnits()
                gtk.gdk.threads_leave()        
        except Exception, inst:
            print
            print 'enableallunits'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y 
    
    
    
            
    def addbot(self, command, send=False):
        try:
            if send == True:
                self.client.send("ADDBOT", command)
            else:
                gtk.gdk.threads_enter()        
                self.battle.AddBot(None, None, command[5], command[1], command[2], command[5], None, command[3], command[4])
                gtk.gdk.threads_leave()        
        except Exception, inst:
            print
            print 'addbot'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y    

    def removebot(self, command, send=False):
        try:
            if send == True:
                self.client.send("REMOVEBOT", command)
            else:
                gtk.gdk.threads_enter()        
                self.battle.RemoveBot(command[1])
                gtk.gdk.threads_leave()        

        except Exception, inst:
            print
            print 'removebot'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y    
            
    
    def updatebot(self, command, send=False):
        try:
            if send == True:
                self.client.send("UPDATEBOT", command)
            else:
                gtk.gdk.threads_enter()        
                self.battle.UpdateBot(command[1], command[2], command[3], False)
                gtk.gdk.threads_leave()        
        except Exception, inst:
            print
            print 'updatebot'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y 
            
    def addstartrect(self, command, send=False):
        try:
            if send == True:
                self.client.send("ADDSTARTRECT", command)
            else:
                gtk.gdk.threads_enter()       
                self.battle.AddStartRect(command[0], command[1:])
                gtk.gdk.threads_leave()        
        except Exception, inst:
            print
            print 'addstartrect'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y 
            

    def removestartrect(self, command, send=False):
        try:
            if send == True:
                self.client.send("REMOVESTARTRECT", command)
            else:
                gtk.gdk.threads_enter()        
                self.battle.RemoveStartRect(command)
                gtk.gdk.threads_leave()        
        except Exception, inst:
            print
            print 'removestartrect'
            print type(inst)     # the exception instance
            print inst.args      # arguments stored in .args
            print inst           # __str__ allows args to printed directly
            x, y = inst          # __getitem__ allows args to be unpacked directly
            print 'x =', x
            print 'y =', y 
        