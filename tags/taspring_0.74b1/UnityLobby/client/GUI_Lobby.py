#!/usr/bin/env python

#======================================================
 #            GUI_Lobby.py
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
import gtk
import pygtk
import thread
import time
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

		self.lobby_ini = lobby_ini
		self.lobby_ini_file = lobby_ini_file


	def create(self):
		options = self.load_options()
		# Main Window
		self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		self.window.set_icon_list(self.spring_logo_pixbuf)
		self.window.set_title("Lobby Preferences")
		self.window.connect("delete-event", self.destroy)

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

						# User Name
		username_label = label_create("User Name")
		self.username_entry = gtk.Entry(max=0)
		self.username_entry.show()
		lobby_add_server_table.attach(username_label, 0,1,2,3)
		lobby_add_server_table.attach(self.username_entry, 1,2,2,3)

						# Password
		password_label = label_create("Password")
		self.password_entry = gtk.Entry(max=0)
		self.password_entry.set_visibility(False)
		self.password_entry.show()
		lobby_add_server_table.attach(password_label, 0,1,3,4)
		lobby_add_server_table.attach(self.password_entry, 1,2,3,4)

						# Button -> Add
		lobby_add_button = gtk.Button(label=None, stock=gtk.STOCK_ADD)
		lobby_add_button.connect("clicked", self.add_lobby_server)
		lobby_add_button.show()
		lobby_add_server_table.attach(lobby_add_button, 0,1,4,5)

						# Button -> Registry
		lobby_registry_button = gtk.Button(label="Register Account", stock=None)
		lobby_registry_button.connect("clicked", self.register_account)
		lobby_registry_button.show()
		lobby_add_server_table.attach(lobby_registry_button, 1,2,4,5)


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
		self.window.hide()

	def show(self, data=None):
		self.window.show()

	def destroy(self, window, event):
		self.hide()
		return True

	def show_text_box_frame(self):
		pass

	def show_input_box_frame(self):
		pass

	def show_user_list_frame(self):
		pass

	def show_tabs_frame(self):
		pass

	def show_colors_frame(self):
		self.lobby_server_list_frame.hide()
		self.lobby_add_server_frame.hide()
		self.interface_colors_frame.show()

	def show_general_frame(self):
		pass

	def show_logging_frame(self):
		pass

	def show_sound_frame(self):
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
			self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
			self.lobby_ini.read(self.lobby_ini_file)
			if self.lobby_ini.sections()[0] == server_address:
				self.default_lobby_server(None, None, iter)
		else:
			self.lobby_ini.set(server_address, 'Port', int(self.server_port_spinner.get_value()))
			self.lobby_ini.set(server_address, 'UserName', self.username_entry.get_text())
			self.lobby_ini.set(server_address, 'UserPassword', encoded_password)
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
		server_list = self.lobby_ini.sections()
		i = 0
		while i < len(server_list):
			if server_list[i] == 'COLORS':
				server_list.pop(i)
			else:
				i = i + 1
		for i in range(0,len(server_list)):
			default = self.lobby_ini.get(server_list[i], 'Default', 'No')
			if default == 'Yes':
				server = server_list[i]
				port = self.lobby_ini.getint(server_list[i], 'Port')
				username = self.lobby_ini.get(server_list[i], 'UserName')
				password = self.lobby_ini.get(server_list[i], 'UserPassword')
				break
		return server, port, username, password

	def load_options(self):
		if self.lobby_ini.has_section('COLORS') == False:
			self.lobby_ini.add_section('COLORS')
			self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
			self.lobby_ini.read(self.lobby_ini_file)
		if self.lobby_ini.has_option('COLORS', 'Text') == True:
			temp = self.lobby_ini.get('COLORS', 'Text')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options = ({'Text':temp})
		else:
			options = ({'Text':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Action') == True:
			temp = self.lobby_ini.get('COLORS', 'Action')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Action':temp})
		else:
			options.update({'Action':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Highlight') == True:
			temp = self.lobby_ini.get('COLORS', 'Highlight')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Highlight':temp})
		else:
			options.update({'Highlight':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'MOTD') == True:
			temp = self.lobby_ini.get('COLORS', 'MOTD')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'MOTD':temp})
		else:
			options.update({'MOTD':[45232,17733,17733]})

		if self.lobby_ini.has_option('COLORS', 'Channel Topic') == True:
			temp = self.lobby_ini.get('COLORS', 'Channel Topic')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Channel Topic':temp})
		else:
			options.update({'Channel Topic':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Server Message') == True:
			temp = self.lobby_ini.get('COLORS', 'Server Message')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Server Message':temp})
		else:
			options.update({'Server Message':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Server Broadcast') == True:
			temp = self.lobby_ini.get('COLORS', 'Server Broadcast')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Server Broadcast':temp})
		else:
			options.update({'Server Broadcast':[0,0,0]})



		if self.lobby_ini.has_option('COLORS', 'Join') == True:
			temp = self.lobby_ini.get('COLORS', 'Join')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Join':temp})
		else:
			options.update({'Join':[0,0,0]})


		if self.lobby_ini.has_option('COLORS', 'Leave') == True:
			temp = self.lobby_ini.get('COLORS', 'Leave')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Leave':temp})
		else:
			options.update({'Leave':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'User Present') == True:
			temp = self.lobby_ini.get('COLORS', 'User Present')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'User Present':temp})
		else:
			options.update({'User Present':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'User InGame') == True:
			temp = self.lobby_ini.get('COLORS', 'User InGame')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'User InGame':temp})
		else:
			options.update({'User InGame':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'User AFK') == True:
			temp = self.lobby_ini.get('COLORS', 'User AFK')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'User AFK':temp})
		else:
			options.update({'User AFK':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Battle') == True:
			temp = self.lobby_ini.get('COLORS', 'Battle')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Battle':temp})
		else:
			options.update({'Battle':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Battle In Progress') == True:
			temp = self.lobby_ini.get('COLORS', 'Battle In Progress')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Battle In Progress':temp})
		else:
			options.update({'Battle In Progress':[0,0,0]})

		return options

	def save_color(self, widget, option):
		self.lobby_ini.set('COLORS', option, str(widget.get_color().red) + ' ' + str(widget.get_color().green) + ' ' + str(widget.get_color().blue))
		self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
		self.lobby_ini.read(self.lobby_ini_file)
		if option == 'User AFK' or option == 'User InGame' or option == 'User Present' or option == 'Battle' or option == 'Battle In Progress':
			self.gui_lobby.UpdateUserColor()
		else:
			self.gui_lobby.UpdateTagTable(option)


	def load_tag_color_options(self):
		if self.lobby_ini.has_section('COLORS') == False:
			self.lobby_ini.add_section('COLORS')
			self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
			self.lobby_ini.read(self.lobby_ini_file)
		if self.lobby_ini.has_option('COLORS', 'Text') == True:
			temp = self.lobby_ini.get('COLORS', 'Text')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options = ({'Text':temp})
		else:
			options = ({'Text':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Action') == True:
			temp = self.lobby_ini.get('COLORS', 'Action')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Action':temp})
		else:
			options.update({'Action':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Highlight') == True:
			temp = self.lobby_ini.get('COLORS', 'Highlight')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Highlight':temp})
		else:
			options.update({'Highlight':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'MOTD') == True:
			temp = self.lobby_ini.get('COLORS', 'MOTD')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'MOTD':temp})
		else:
			options.update({'MOTD':[45232,17733,17733]})

		if self.lobby_ini.has_option('COLORS', 'Channel Topic') == True:
			temp = self.lobby_ini.get('COLORS', 'Channel Topic')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Channel Topic':temp})
		else:
			options.update({'Channel Topic':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Server Message') == True:
			temp = self.lobby_ini.get('COLORS', 'Server Message')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Server Message':temp})
		else:
			options.update({'Server Message':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Server Broadcast') == True:
			temp = self.lobby_ini.get('COLORS', 'Server Broadcast')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Server Broadcast':temp})
		else:
			options.update({'Server Broadcast':[0,0,0]})



		if self.lobby_ini.has_option('COLORS', 'Join') == True:
			temp = self.lobby_ini.get('COLORS', 'Join')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Join':temp})
		else:
			options.update({'Join':[0,0,0]})


		if self.lobby_ini.has_option('COLORS', 'Leave') == True:
			temp = self.lobby_ini.get('COLORS', 'Leave')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Leave':temp})
		else:
			options.update({'Leave':[0,0,0]})

		return options

	def load_user_color_options(self):
		if self.lobby_ini.has_section('COLORS') == False:
			self.lobby_ini.add_section('COLORS')
			self.lobby_ini.write(open(self.lobby_ini_file, "w+"))
			self.lobby_ini.read(self.lobby_ini_file)

		if self.lobby_ini.has_option('COLORS', 'User Present') == True:
			temp = self.lobby_ini.get('COLORS', 'User Present')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options = ({'User Present':temp})
		else:
			options = ({'User Present':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'User InGame') == True:
			temp = self.lobby_ini.get('COLORS', 'User InGame')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'User InGame':temp})
		else:
			options.update({'User InGame':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'User AFK') == True:
			temp = self.lobby_ini.get('COLORS', 'User AFK')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'User AFK':temp})
		else:
			options.update({'User AFK':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Battle') == True:
			temp = self.lobby_ini.get('COLORS', 'Battle')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Battle':temp})
		else:
			options.update({'Battle':[0,0,0]})

		if self.lobby_ini.has_option('COLORS', 'Battle In Progress') == True:
			temp = self.lobby_ini.get('COLORS', 'Battle In Progress')
			temp = temp.split(" ")
			for o in range(0, len(temp)):
				temp[o] = int(temp[o])
			options.update({'Battle In Progress':temp})
		else:
			options.update({'Battle In Progress':[0,0,0]})

		return options


def update_channel_user_country_image(column, cell, model, iter):
	pixbuf = model.get_value(iter, 1)
	cell.set_property('pixbuf', pixbuf)
	return


def update_channel_user_status_image(column, cell, model, iter):
	pixbuf = model.get_value(iter, 4)
	cell.set_property('pixbuf', pixbuf)
	return


def update_channel_admin_status_image(column, cell, model, iter):
	pixbuf = model.get_value(iter, 6)
	cell.set_property('pixbuf', pixbuf)
	return


def update_channel_user_rank_image(column, cell, model, iter):
	pixbuf = model.get_value(iter, 5)
	cell.set_property('pixbuf', pixbuf)
	return


class gui_lobby:
    
# __init__() =======================================================================================
# ==================================================================================================
#  Initialise self variables for gui_lobby class.
# ==================================================================================================

	def __init__(self, status_icon):
		self.spring_logo_pixbuf = status_icon.spring_logo_pixbuf

		self.lobby_preferences = preferences(self, status_icon.lobby_ini, status_icon.lobby_ini_file)
		self.lobby_preferences.create()

		self.ini = status_icon.ini
		self.setup_profile = status_icon.profile
		self.unity_location = self.ini.get(self.setup_profile, 'UNITY_INSTALL_DIR')

		self.network_game = False

		self.UpdateUserColor()

		self.IntialiseServerVariables()

# /end __init__() ==================================================================================




# IntegrateWithBattle() ============================================================================
# ==================================================================================================
#  Integrates Lobby Class with Battle Class
# ==================================================================================================

	def IntegrateWithBattle(self, status_icon):

		self.battle = status_icon.battle

# /end IntegrateWithBattle() ==================================================================




# Create() =========================================================================================
# ==================================================================================================
#  Creates GUI for Lobby
# ==================================================================================================

	def Create(self):
		# Window
		self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		self.window.set_icon_list(self.spring_logo_pixbuf)
		self.window.set_title("Lobby")
		self.window.connect("delete-event", self.Destroy)
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
				# 9  Mapname
				# 10 Title
				# 11 Modname
				# 12 List of Players in Battle
				# 13 Locked




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
		self.battle_column_0.set_resizable(True)
		self.battle_column_1.set_resizable(True)
		self.battle_column_2.set_resizable(True)
		self.battle_column_3.set_resizable(True)
		self.battle_column_4.set_resizable(True)
		self.battle_column_5.set_resizable(True)
		self.battle_treeview.append_column(self.battle_column_0)
		self.battle_treeview.append_column(self.battle_column_1)
		self.battle_treeview.append_column(self.battle_column_2)
		self.battle_treeview.append_column(self.battle_column_3)
		self.battle_treeview.append_column(self.battle_column_4)
		self.battle_treeview.append_column(self.battle_column_5)
		self.battle_treeview.show()
		battle_window.add(self.battle_treeview)

#		self.battle_selection = self.battle_treeview.get_selection()
#		self.battle_selection.connect('changed', self.joinbattle, True)
		# Add Mouse Click event to player_treeview

		# Add Mouse Click event to battle_treeview
		self.battle_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
		self.battle_treeview.connect('event',self.BattlePopupMenu)

		# Add Mouse Click event to player_treeview
#		self.player_treeview.add_events(gtk.gdk.BUTTON_PRESS_MASK)
#		self.player_treeview.connect('event',self.player_popup_menu)
	
	        # create a CellRenderers to render the data
	        self.cell0a = gtk.CellRendererPixbuf()
	        self.cell0b = gtk.CellRendererPixbuf()
	        self.cell0c = gtk.CellRendererPixbuf()
		self.cell0d = gtk.CellRendererPixbuf()
	        self.cell1  = gtk.CellRendererText()
	        self.cell2  = gtk.CellRendererText()
	        self.cell3  = gtk.CellRendererText()
	        self.cell4  = gtk.CellRendererText()
	        self.cell5  = gtk.CellRendererText()

        	# add the cells to the columns
		self.battle_column_0.pack_start(self.cell0a, False)
		self.battle_column_0.pack_start(self.cell0b, True)
		self.battle_column_0.pack_start(self.cell0c, True)
		self.battle_column_0.pack_start(self.cell0d, True)
		self.battle_column_1.pack_start(self.cell1, False)
		self.battle_column_2.pack_start(self.cell2, False)
		self.battle_column_3.pack_start(self.cell3, False)
		self.battle_column_4.pack_start(self.cell4, False)
		self.battle_column_5.pack_start(self.cell5, False)

	        # set the cell attributes to the appropriate liststore column
	        self.battle_column_1.set_attributes(self.cell1, text=10)
	        self.battle_column_2.set_attributes(self.cell2, text=3)
	        self.battle_column_3.set_attributes(self.cell3, text=9)
		self.battle_column_4.set_attributes(self.cell4, text=11)
	        self.battle_column_5.set_attributes(self.cell5, text=12)

	        # Allow sorting on the column
	        self.battle_column_0.set_sort_column_id(13)
	        self.battle_column_1.set_sort_column_id(10)
	        self.battle_column_2.set_sort_column_id(3)
	        self.battle_column_3.set_sort_column_id(9)
	        self.battle_column_4.set_sort_column_id(11)
#	        self.player_column_5.set_sort_column_id(6)

				# Lobby Notebook
		self.lobby_notebook = gtk.Notebook()
	        self.lobby_notebook.set_tab_pos(gtk.POS_TOP)
		self.lobby_notebook.show()
		vpane.pack2(self.lobby_notebook, True, True)
#		table.attach(self.lobby_notebook, 0,1,2,3)

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

# /end Create() ====================================================================================




# Show() =========================================================================================
# ==================================================================================================
#  Function to show window. Called from outside of Battle class.
# ==================================================================================================

	def Show(self):
		self.window.show()

# /end Show() ======================================================================================




# Hide() ===========================================================================================
# ==================================================================================================
#  Function to hide window. Called from outside of Battle class.
# ==================================================================================================

	def Hide(self):
		self.window.hide()

# /end Hide() ======================================================================================




# Destroy() ========================================================================================
# ==================================================================================================
#  Overrides Display Manager kill signal and hides window instead.
# ==================================================================================================

	def Destroy(self, window, event):
		self.Hide()
		return True

# /end Destroy() ===================================================================================




# IntialiseServerVariables() =======================================================================
# ==================================================================================================
#  Initialise Server Variables that store data i.e chat / user list / battle list.
# ==================================================================================================

	def IntialiseServerVariables(self):
		self.userlist = []

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
				# 9  Mapname
				# 10 Title
				# 11 Modname
				# 12 List of Players in Battle
		try:
			self.battle_user_liststore.clear()
			self.battle_liststore.clear()
		except:
			self.battle_user_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, str)
			self.battle_liststore = gtk.ListStore(str, str, str, str, str, int, int, str, gtk.gdk.Pixbuf, str, str, str, str, str, bool)

                self.country_flags = {}
                self.rank_images = {}
                self.status_images = {}
		self.battle_images = None

# /end IntialiseServerVariables() ==================================================================




# CreateTagTable() =================================================================================
# ==================================================================================================
#  Creates Tag Table using in gtk.TextBuffers
# ==================================================================================================

	def CreateTagTable(self):
		self.tag_table = gtk.TextTagTable()
		color_options = self.lobby_preferences.load_tag_color_options()

		for k, v in color_options.iteritems():
			tag = gtk.TextTag(k)
			color = gtk.gdk.Color(v[0], v[1], v[2])
			tag.set_property("foreground-gdk", color)
			self.tag_table.add(tag)

# /end CreateTagTable() ============================================================================




# UpdateTagTable() =================================================================================
# ==================================================================================================
#  Creates Tag Table using in gtk.TextBuffers
# ==================================================================================================

	def UpdateTagTable(self, tagname):
		tag = self.tag_table.lookup(tagname)
		self.tag_table.remove(tag)

		color_options = self.lobby_preferences.load_color_options()

		for k, v in color_options.iteritems():
			if k == tagname:
				tag = gtk.TextTag(k)
				color = gtk.gdk.Color(v[0], v[1], v[2])
				tag.set_property("foreground-gdk", color)
				self.tag_table.add(tag)
				break

# /end UpdateTagTable() ============================================================================


# UpdateUserColor() ================================================================================
# ==================================================================================================
#  Updates Color Values for UserList
# ==================================================================================================

	def UpdateUserColor(self):
		self.user_color_options = self.lobby_preferences.load_user_color_options()

# /end UpdateUserColor() ===========================================================================




# CreateChannelChat() ==============================================================================
# ==================================================================================================
#  Creates Data Variables for Channel Chat.
# ==================================================================================================

	def CreateChannelChat(self, channel_name, closeable):
	# Creates Data Stores for channels
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

# /end CreateChannelChat() =========================================================================




# CreateChannelChatWindow() ========================================================================
# ==================================================================================================
#  Create GUI for Channel Chat.
# ==================================================================================================

	def CreateChannelChatWindow(self, closeable):
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
			 	player_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, str)
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
	
				self.lobby_channel_users_columns.append([ player_column_0, player_column_1, player_column_2 ])
				self.lobby_channel_users_cells.append([ cell0, cell1, cell2, cell3, cell4 ])

	        					# Add the cells to the columns
				player_column_0.pack_start(cell0, False)
				player_column_1.pack_start(cell1, False)
				player_column_2.pack_start(cell2, False)
				player_column_2.pack_start(cell3, False)
				player_column_2.pack_start(cell4, False)

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

# /end CreateChannelChatWindow() ===================================================================




# ParseOutputChannelChat() =========================================================================
# ==================================================================================================
#  Parses User Input for Channel Chat.
# ==================================================================================================

	def ParseOutputChannelChat(self, entry, channel_name):
		try:
			if self.connect_button.get_stock_id() == gtk.STOCK_CONNECT:
				temp_str =  entry.get_text()
				entry.set_text('')
				if temp_str != None:
					if temp_str[0] != '/' and channel_name != '$local':
						temp_str = 'SAY ' + channel_name + ' ' + temp_str
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

# /end ParseOutputChannelChat() ====================================================================




# RemoveChannelChatBuffer() ========================================================================
# ==================================================================================================
#  Removes Data Buffers for a Channel Chat.
#   i.e called when user leaves a Channel.
# ==================================================================================================

	def RemoveChannelChatBuffer(self, channel_name):
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

# /end RemoveChannelChatBuffer() ===================================================================




# OnChannelChatTabClick() ==========================================================================
# ==================================================================================================
#  Called When User Clicks On Channel Chat Tab.
# ==================================================================================================

	def OnChannelChatTabClick(self, widget, event, channel_name, ):
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

# /end OnChannelChatTabClick() =====================================================================




# UpdateTextbufferChannelChat() ====================================================================
# ==================================================================================================
#  Updates Textbuffer for a Channel Chat.
# ==================================================================================================

	def UpdateTextbufferChannelChat(self, channel_name, username, text, tag="Text"):
		try:
			for i in range (0,len(self.lobby_channel_names)):
				if self.lobby_channel_names[i] == channel_name:
					gtk.gdk.threads_enter()
					iter = self.lobby_channel_buffers[i].get_end_iter()
					self.lobby_channel_buffers[i].insert(iter, '\n')
					iter = self.lobby_channel_buffers[i].get_end_iter()
					if tag != "Text":
						self.lobby_channel_buffers[i].insert_with_tags_by_name(iter, text, tag)
					else:
						if username != None:
							self.lobby_channel_buffers[i].insert_with_tags_by_name(iter, '<' + username + '> ', tag)
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

# /end UpdateTextbufferChannelChat() ===============================================================




# CreatePMChat() ===================================================================================
# ==================================================================================================
#  Creates Data Variables for PM Chat.
# ==================================================================================================

	def CreatePMChat(self, pm_name):
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

# /end CreatePMChat() ==============================================================================




# CreatePMChatWindow() =============================================================================
# ==================================================================================================
#  Create GUI for PM Chat.
# ==================================================================================================

	def CreatePMChatWindow(self):
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
		 	player_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, str)
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
			self.lobby_pm_users_columns.append([ player_column_0, player_column_1, player_column_2 ])
			self.lobby_pm_users_cells.append([ cell0, cell1, cell2, cell3, cell4 ])
	
		        			# Add the cells to the columns
			player_column_0.pack_start(cell0, False)
			player_column_1.pack_start(cell1, False)
			player_column_2.pack_start(cell2, False)
			player_column_2.pack_start(cell3, False)
			player_column_2.pack_start(cell4, False)
	
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


# TODO 
		# Code this in 1 pass of userlist

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

						gtk.gdk.threads_enter()
						self.lobby_pm_users[last_index].append([username, flag, cpu, ip, status_image, rank_image, admin_image, status])
						self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][4],update_channel_admin_status_image)
						self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][3],update_channel_user_rank_image)
						self.lobby_pm_users_columns[last_index][1].set_cell_data_func(self.lobby_pm_users_cells[last_index][1],update_channel_user_country_image)
						self.lobby_pm_users_columns[last_index][0].set_cell_data_func(self.lobby_pm_users_cells[last_index][0],update_channel_user_status_image)
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

						gtk.gdk.threads_enter()
						self.lobby_pm_users[last_index].append([username, flag, cpu, ip, status_image, rank_image, admin_image, status])
						self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][4],update_channel_admin_status_image)
						self.lobby_pm_users_columns[last_index][2].set_cell_data_func(self.lobby_pm_users_cells[last_index][3],update_channel_user_rank_image)
						self.lobby_pm_users_columns[last_index][1].set_cell_data_func(self.lobby_pm_users_cells[last_index][1],update_channel_user_country_image)
						self.lobby_pm_users_columns[last_index][0].set_cell_data_func(self.lobby_pm_users_cells[last_index][0],update_channel_user_status_image)
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

# /end CreatePMChatWindow() ========================================================================




# ParseOutputPMChat() ==============================================================================
# ==================================================================================================
#  Parses User Input for PM Chat.
# ==================================================================================================

	def ParseOutputPMChat(self, entry, pm_name):
		temp_str =  entry.get_text()
		entry.set_text('')
		if temp_str != None:
			if temp_str[0] != '/':
				temp_str = 'SAYPRIVATE ' + pm_name + ' ' + temp_str
				self.client.send(temp_str)
			elif temp_str[0] == '/':
				temp_parsed = temp_str.split(" ")
				args = ''
				for i in range (1, len(temp_parsed)):
					args = args + temp_parsed[i]
					if i != len(temp_parsed):
						args = args + ' '	
				self.client.send(temp_parsed[0][1:], args)

# /end ParseOutputPMChat() =========================================================================




# RemovePMChatBuffer() =============================================================================
# ==================================================================================================
#  Removes Data Buffers for a PM Chat.
#   i.e called when user closes a PM.
# ==================================================================================================

	def RemovePMChatBuffer(self, pm_name):
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

# /end RemovePMChatBuffer() ========================================================================




# OnPMChatTabClick() ===============================================================================
# ==================================================================================================
#  Called When User Clicks On Channel Chat Tab.
# ==================================================================================================

	def OnPMChatTabClick(self, widget, event, pm_name):
		if  event.type == gtk.gdk.BUTTON_PRESS:
			if event.button == 3:
				self.RemovePMChatBuffer(pm_name)
				for o in range(0,len(self.userlist)):
					self.userlist[o].leavePM(pm_name)

# /end OnPMChatTabClick() ==========================================================================




# UpdateTextbufferPMChat() =========================================================================
# ==================================================================================================
#  Updates Textbuffer for a PM Chat
# ==================================================================================================

	def UpdateTextbufferPMChat(self, pm_name, username, text, tag="Text"):
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

# /end UpdateTextbufferPMChat() =====================================================================




# CreateBattleChat() ===============================================================================
# ==================================================================================================
#  Creates Data Variables for Battle Chat.
# ==================================================================================================

	def CreateBattleChat(self):
		self.battle_chat_buffer = gtk.TextBuffer(self.tag_table)

		self.battle_chat_textview = gtk.TextView(buffer=self.battle_chat_buffer)
		self.battle_chat_textview.set_editable(False)
		self.battle_chat_textview.set_cursor_visible(False)
		self.battle_chat_textview.set_wrap_mode(gtk.WRAP_WORD)
		self.battle_chat_textview.set_justification(gtk.JUSTIFY_LEFT)
		self.battle_chat_textview.show()

		vpane = self.CreateBattleChatWindow()
		return vpane

# /end CreateBattleChat() ==========================================================================




# CreateBattleChatWindow() =========================================================================
# ==================================================================================================
#  Create GUI for Battle Chat Window.
# ==================================================================================================

	def CreateBattleChatWindow(self):
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
			self.battle_chat_users_columns = [ player_column_0, player_column_1, player_column_2 ]
			self.battle_chat_users_cells = [ cell0, cell1, cell2, cell3, cell4 ]

		        			# Add the cells to the columns
			player_column_0.pack_start(cell0, False)
			player_column_1.pack_start(cell1, False)
			player_column_2.pack_start(cell2, False)
			player_column_2.pack_start(cell3, False)
			player_column_2.pack_start(cell4, False)
	
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

			iter = self.battle_liststore.get_iter_first()
			while iter != None:
				if self.battle_liststore.get_value(iter,0) == self.battle_id:
					users = self.battle_liststore.get_value(iter,12).split(', ')
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
	
								gtk.gdk.threads_enter()
								self.battle_user_liststore.append([username, flag, cpu, ip, status_image, rank_image, admin_image, status])
								self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[4],update_channel_admin_status_image)
								self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[3],update_channel_user_rank_image)
								self.battle_chat_users_columns[1].set_cell_data_func(self.battle_chat_users_cells[1],update_channel_user_country_image)
								self.battle_chat_users_columns[0].set_cell_data_func(self.battle_chat_users_cells[0],update_channel_user_status_image)
								gtk.gdk.threads_leave()
								break
				iter = self.battle_liststore.iter_next(iter)
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


# /end CreateBattleChatWindow() ====================================================================




# ParseOutputBattleChat() ==========================================================================
# ==================================================================================================
#  Parses User Input for Battle Chat.
# ==================================================================================================

	def ParseOutputBattleChat(self, entry):
		temp_str =  entry.get_text()
		entry.set_text('')
		if temp_str != None:
			if temp_str[0] != '/':
				temp_str = 'SAYBATTLE ' + temp_str
				self.client.send(temp_str)
				
			elif temp_str[0] == '/':
				temp_parsed = temp_str.split(" ")
				args = ''
				for i in range (1, len(temp_parsed)):
					args = args + temp_parsed[i]
					if i != len(temp_parsed):
						args = args + ' '	
				self.client.send(temp_parsed[0][1:], args)

# /end ParseOutputBattleChat() =====================================================================




# UpdateTextbufferBattleChat() =====================================================================
# ==================================================================================================
#  Updates Textbuffer for Battle Chat.
# ==================================================================================================

	def UpdateTextbufferBattleChat(self, username, text, tag='Text'):
		try:
			gtk.gdk.threads_enter()
			iter = self.battle_chat_buffer.get_end_iter()
			self.battle_chat_buffer.insert(iter, '\n')
			iter = self.battle_chat_buffer.get_end_iter()


			if tag != "Text":
				self.battle_chat_buffer.insert_with_tags_by_name(iter, text, tag)
			else:
				if username != None:
					self.battle_chat_buffer.insert_with_tags_by_name(iter, '<' + username + '> ', tag)
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




# /end UpdateTextbufferBattleChat() ================================================================




# PlayerPopupMenu() ================================================================================
# ==================================================================================================
#  Player Popup Menu for Player List.
# ==================================================================================================

	def PlayerPopupMenu(self, treeview, event):
		try:
			gtk.gdk.threads_leave()
			treeselection = treeview.get_selection()
			(model, iter) = treeselection.get_selected()
			if iter != None:
				liststore = treeview.get_model()
				if event.type == gtk.gdk._2BUTTON_PRESS:
					if event.button == 1:
						print 'Create PM'
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

# /end PlayerPopupMenu() ===========================================================================




# BattlePopupMenu() ================================================================================
# ==================================================================================================
#  Battle Popup Menu for Battle List.
# ==================================================================================================

	def BattlePopupMenu(self, treeview, event):
		try:
			if self.network_game == False:
				treeselection = treeview.get_selection()
				(model, iter) = treeselection.get_selected()
				if iter != None:
					liststore = treeview.get_model()
					if event.type == gtk.gdk._2BUTTON_PRESS:
						if event.button == 1:
						 	treeselection = self.battle_treeview.get_selection()
							(model, iter) = treeselection.get_selected()

							if iter != None:
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

# /end PlayerPopupMenu() ===========================================================================




# BattleJoin() =====================================================================================
# ==================================================================================================
#  Gets BattleID & Game Auth Status & passes to self.joinbattle
# ==================================================================================================
	def BattleJoin(self, widget, event, iter):
		self.battle_id = self.battle_liststore.get_value(iter, 0)
		passworded = self.battle_liststore.get_value(iter, 7)
		if passworded == gtk.STOCK_DIALOG_AUTHENTICATION:
			self.CreatePasswordDialog('Enter Password')
		else:
			self.battle_password = None
			self.client.send("JOINBATTLE " + str(self.battle_id))

# /end BattleJoin() ================================================================================
	



# Connection() =====================================================================================
# ==================================================================================================
#  Handles connecting / disconnecting to lobby server.
# ==================================================================================================

	def Connection(self, button, server=None, port=None, username=None, password=None):
		if self.connect_button.get_stock_id() == gtk.STOCK_DISCONNECT:
			self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
			if server == None:
				server, port, username, password = self.lobby_preferences.get_default_lobby_server()
			self.username = username
			self.client = Lobby.client(self)
			self.client.connect(server, port, username, password)
			self.client.reLogin()
		elif self.connect_button.get_stock_id() == gtk.STOCK_CONNECT:
			self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
			self.client.disconnect('User')
			self.IntialiseServerVariables()
			self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)

# /end Connection() ================================================================================




# UpdateConnectedButton() ==========================================================================
# ==================================================================================================
#  Updates Connect upon sucessful login / disconnecting from lobby server.
# ==================================================================================================

	def UpdateConnectedButton(self, connected):
		gtk.gdk.threads_enter()
		if connected == True:
			self.connect_button.set_stock_id(gtk.STOCK_CONNECT)
		else:
			self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
			self.intialise_server_variables()
			self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)
		gtk.gdk.threads_leave()

# /end UpdateConnectedButton() =====================================================================




# WarningDialog() ==================================================================================
# ==================================================================================================
#  Warning Dialog
# ==================================================================================================

	def WarningDialog(self, title, text):
		gtk.gdk.threads_enter()
		dialog = gtk.Dialog(title, self.window, gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT, (gtk.STOCK_CLOSE, gtk.RESPONSE_CLOSE))
		dialog.vbox.pack_start(gtk.Label(text))
		dialog.show_all()
		result = dialog.run()
		dialog.destroy()
		gtk.gdk.threads_leave()

# /end WarningDialog() =============================================================================




# InfoDialog() =====================================================================================
# ==================================================================================================
#  Info Dialog
# ==================================================================================================

	def InfoDialog(self, title, text):
		gtk.gdk.threads_enter()
		dialog = gtk.Dialog(title, self.window, gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT, (gtk.STOCK_CLOSE, gtk.RESPONSE_CLOSE))
		dialog.vbox.pack_start(gtk.Label(text))
		dialog.show_all()
		result = dialog.run()
		dialog.destroy()
		gtk.gdk.threads_leave()

# /end InfoDialog() ================================================================================




# PasswordDialog() =================================================================================
# ==================================================================================================
#  Password Dialog
# ==================================================================================================

	def CreatePasswordDialog(self, title):
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
		host_battle_button.connect("clicked", self.ClosePasswordDialog, popup_password_window, password_entry, iter)
		host_battle_button.show()

		table.attach(host_battle_button, 0,2,1,2, xoptions=gtk.FILL, yoptions=gtk.FILL, xpadding=0, ypadding=0)

	def ClosePasswordDialog(self, event, popup_password_window, password_entry, iter):
		self.battle_password = password_entry.get_text()
		popup_password_window.destroy()
		self.client.send("JOINBATTLE " + str(self.battle_id) + ' ' + self.battle_password)





# GetCountryFlag() =================================================================================
# ==================================================================================================
#  Checks if Country Flag is already loaded & loads if its not
# ==================================================================================================

	def GetCountryFlag(self, country):
		if self.country_flags.has_key(country) == True:
			return self.country_flags[country]
		else:
			if country != "xx":
				file_location = os.path.join(self.unity_location, 'resources', 'flags', country + '.png')
				pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,15)
			else:
				pixbuf = None
			self.country_flags[country] = pixbuf
			return pixbuf

# /end GetCountryFlag() ============================================================================




# GetRankImage() ===================================================================================
# ==================================================================================================
#  Checks if Rank Image is already loaded & loads if its not
# ==================================================================================================

	def GetRankImage(self, rank):
		if self.rank_images.has_key(rank) == True:
			return self.rank_images[rank]
		else:
			file_location = os.path.join(self.unity_location, 'resources', 'ranks', rank + '.png')
			pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,25)
			self.rank_images[rank] = pixbuf
			return pixbuf

# /end GetRankImage() ==============================================================================				




# GetStatusImage() =================================================================================
# ==================================================================================================
#  Checks if Status Image is already loaded & loads if its not
# ==================================================================================================

	def GetStatusImage(self, status):
		if self.status_images.has_key(status) == True:
			return self.status_images[status]
		else:
			file_location = os.path.join(self.unity_location, 'resources', 'status', status + '.png')
			pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,25)
			self.status_images[status] = pixbuf
			return pixbuf

# /end GetStatusImage() ============================================================================




# RegisterAccount() ================================================================================
# ==================================================================================================
#  Register's Account to lobby server
# ==================================================================================================

	def RegisterAccount(self, server_address, server_port, username, encoded_password):
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

# /end RegisterAccount() ============================================================================


	def UpdateUserFontColor(self, column, cell, model, iter):
		status = model.get_value(iter, 7)
		if status == 'Present':
			color = gtk.gdk.Color(self.user_color_options['User Present'][0], self.user_color_options['User Present'][1], self.user_color_options['User Present'][2])	
		elif status == 'InGame':
			color = gtk.gdk.Color(self.user_color_options['User InGame'][0], self.user_color_options['User InGame'][1], self.user_color_options['User InGame'][2])	
		elif status == 'AFK':
			color = gtk.gdk.Color(self.user_color_options['User AFK'][0], self.user_color_options['User AFK'][1], self.user_color_options['User AFK'][2])	
		cell.set_property('foreground-gdk', color)
		

# UpdateBattleNat() ================================================================================
# ==================================================================================================
#  Updates Battle Nat Image in Battle TreeView
# ==================================================================================================

	def UpdateBattleNat(self, column, cell, model, iter):
	        stock = model.get_value(iter, 2)
		if stock != None:
		        pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
		else:
			pixbuf = None
	        cell.set_property('pixbuf', pixbuf)
	        return

# /end UpdateBattleNat() ===========================================================================




# UpdateBattleReplay() =============================================================================
# ==================================================================================================
#  Updates Battle Nat Image in Battle TreeView
# ==================================================================================================

	def UpdateBattleReplay(self, column, cell, model, iter):
	        stock = model.get_value(iter, 1)
		if stock != None:
		        pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
		else:
			pixbuf = None
	        cell.set_property('pixbuf', pixbuf)
	        return

# /end UpdateBattleReplay() ========================================================================




# UpdateBattleAuth() ===============================================================================
# ==================================================================================================
#  Updates Battle Auth Image in Battle TreeView
# ==================================================================================================

	def UpdateBattleAuth(self, column, cell, model, iter):
	        stock = model.get_value(iter, 7)
		if stock != None:
		        pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
		else:
			pixbuf = None
	        cell.set_property('pixbuf', pixbuf)
	        return

# /end UpdateBattleAuth() ==========================================================================




# UpdateBattleLocked() =============================================================================
# ==================================================================================================
#  Updates Battle Locked Image in Battle TreeView
# ==================================================================================================

	def UpdateBattleLocked(self, column, cell, model, iter):
	        stock = model.get_value(iter, 13)
		if stock != None:
		        pixbuf = self.battle_treeview.render_icon(stock, gtk.ICON_SIZE_MENU, None)
		else:
			pixbuf = None
	        cell.set_property('pixbuf', pixbuf)
	        return

# /end UpdateBattleLocked() ========================================================================





# UpdateBattleFontColor() ==========================================================================
# ==================================================================================================
#  Updates Battle Locked Image in Battle TreeView
# ==================================================================================================

	def UpdateBattleFontColor(self, column, cell, model, iter):
	        boolean = model.get_value(iter, 14)
		if boolean == True:
			color = gtk.gdk.Color(self.user_color_options['Battle In Progress'][0], self.user_color_options['Battle In Progress'][1], self.user_color_options['Battle In Progress'][2])	
		else:
			color = gtk.gdk.Color(self.user_color_options['Battle'][0], self.user_color_options['Battle'][1], self.user_color_options['Battle'][2])	
		cell.set_property('foreground-gdk', color)
	        return

# /end UpdateBattleFontColor() =====================================================================




# BattleStatusEncode() =============================================================================
# ==================================================================================================
#  Builds a status bitmask. teamcolor is for compatibility
# ==================================================================================================
	def BattleStatusEncode(ready, team, allyteam, mode, handicap, sync, side):
		result = 0
		result += ready<<1
		result += team<<2
		result += allyteam<<6
		result += mode<<10
#		result += teamcolor<<18
		result += sync<<22
		result += side<<24
		print
		print
		print Result
		return Result
# /end BattleStatusEncode() ========================================================================




# BattleStatusDecode() =============================================================================
# ==================================================================================================
#  Converts a status bitmask to a tuple
# ==================================================================================================
	def BattleStatusDecode(status):
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
# /end BattleStatusDecode() ========================================================================


			

# Lobby Protocols
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
			self.WarningDialog('Server Message', text)
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
			self.UpdateTextbufferChannel(command[0], None, text)
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
			self.WarningDialog('Denied', text)
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


# adduser() ========================================================================================
# ==================================================================================================
#  Function for Lobby Protocol
# 	* ADDUSER username country cpu IP
# ==================================================================================================

	def adduser(self, username, country, cpu, ip):
		try:
			self.userlist.append(Lobby.user(self, username, country, cpu, ip))
		except Exception, inst:
			print
			print 'adduser'
			print type(inst)     # the exception instance
			print inst.args      # arguments stored in .args
			print inst           # __str__ allows args to printed directly
			x, y = inst          # __getitem__ allows args to be unpacked directly
			print 'x =', x
			print 'y =', y

# /end adduser() ===================================================================================




# removeuser() =====================================================================================
# ==================================================================================================
#  Function for Lobby Protocol
# 	  * REMOVEUSER username
# ==================================================================================================
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

# /end removeuser() ================================================================================



	def joinedfailed(self, command):
		try:
			if len(command) != 0:
				text = command[0]
			else:
				text = ''
			for i in range(1, len(command)):
				text = text + ' ' + command[i]
			self.WarningDialog('Join Channel Failed', text)
		except Exception, inst:
			print
			print 'joinfailed'
			print type(inst)     # the exception instance
			print inst.args      # arguments stored in .args
			print inst           # __str__ allows args to printed directly
			x, y = inst          # __getitem__ allows args to be unpacked directly
			print 'x =', x
			print 'y =', y





# clients() ========================================================================================
# ==================================================================================================
#  Function for Lobby Protocol
# 	  * CLIENTS channame {clients}
# ==================================================================================================	

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

						gtk.gdk.threads_enter()
						self.lobby_channel_users[channel_index].append([username, flag, cpu, ip, status_image, rank_image, admin_image, status])
						self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][4], update_channel_admin_status_image)
						self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][3], update_channel_user_rank_image)
						self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][2], self.UpdateUserFontColor)
						self.lobby_channel_users_columns[channel_index][1].set_cell_data_func(self.lobby_channel_users_cells[channel_index][1],update_channel_user_country_image)
						self.lobby_channel_users_columns[channel_index][0].set_cell_data_func(self.lobby_channel_users_cells[channel_index][0],update_channel_user_status_image)
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

# /end clients() ===================================================================================


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


# joined() =========================================================================================
# ==================================================================================================
#  Function for Lobby Protocol
# 	  * JOINED channame username
# ==================================================================================================	

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

					gtk.gdk.threads_enter()
					self.lobby_channel_users[channel_index].append([username, flag, cpu, ip, status_image, rank_image, admin_image, status])
					self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][4], update_channel_admin_status_image)
					self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][3], update_channel_user_rank_image)
					self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][2], self.UpdateUserFontColor)
					self.lobby_channel_users_columns[channel_index][1].set_cell_data_func(self.lobby_channel_users_cells[channel_index][1],update_channel_user_country_image)
					self.lobby_channel_users_columns[channel_index][0].set_cell_data_func(self.lobby_channel_users_cells[channel_index][0],update_channel_user_status_image)
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

# /end joined() ====================================================================================




# clientstatus() ===================================================================================
# ==================================================================================================
#  Function for Lobby Protocol  
# 	  * CLIENTSTATUS username status
# ==================================================================================================

	def clientstatus(self, username, status):
# FIX
		try:
			for o in range(0,len(self.userlist)):
				if self.userlist[o].name == username:
					self.userlist[o].updateStatus(status)

					channel_list = self.userlist[o].listChannels()
					pm_list = self.userlist[o].listPMs()
					battle_id = self.userlist[o].getBattleID()


					if self.userlist[o].inGame() == True:
						status_image = self.GetStatusImage('ingame')
						status = 'InGame'
						if self.userlist[o].getBattleHost() == True:
							battle_id = self.userlist[o].getBattleID()
							iter = self.battle_liststore.get_iter_first()
							while iter != None:
								if self.battle_liststore.get_value(iter,0) == battle_id:
									gtk.gdk.threads_enter()
									self.battle_liststore.set(iter, 14, True)
								        self.battle_column_1.set_cell_data_func(self.cell1, self.UpdateBattleFontColor)
								        self.battle_column_2.set_cell_data_func(self.cell2, self.UpdateBattleFontColor)
								        self.battle_column_3.set_cell_data_func(self.cell3, self.UpdateBattleFontColor)
								        self.battle_column_4.set_cell_data_func(self.cell4, self.UpdateBattleFontColor)
								        self.battle_column_5.set_cell_data_func(self.cell5, self.UpdateBattleFontColor)
									gtk.gdk.threads_leave()
									break
								iter = self.battle_liststore.iter_next(iter)
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
								self.lobby_channel_users_columns[index][2].set_cell_data_func(self.lobby_channel_users_cells[index][4], update_channel_admin_status_image)
								self.lobby_channel_users_columns[index][2].set_cell_data_func(self.lobby_channel_users_cells[index][3], update_channel_user_rank_image)
								self.lobby_channel_users_columns[index][2].set_cell_data_func(self.lobby_channel_users_cells[index][2], self.UpdateUserFontColor)
								self.lobby_channel_users_columns[index][1].set_cell_data_func(self.lobby_channel_users_cells[index][1],update_channel_user_country_image)
								self.lobby_channel_users_columns[index][0].set_cell_data_func(self.lobby_channel_users_cells[index][0],update_channel_user_status_image)
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
								self.lobby_pm_users_columns[index][2].set_cell_data_func(self.lobby_pm_users_cells[index][4], update_channel_admin_status_image)
								self.lobby_pm_users_columns[index][2].set_cell_data_func(self.lobby_pm_users_cells[index][3], update_channel_user_rank_image)
								self.lobby_pm_users_columns[index][2].set_cell_data_func(self.lobby_pm_users_cells[index][2], self.UpdateUserFontColor)
								self.lobby_pm_users_columns[index][1].set_cell_data_func(self.lobby_pm_users_cells[index][1],update_channel_user_country_image)
								self.lobby_pm_users_columns[index][0].set_cell_data_func(self.lobby_pm_users_cells[index][0],update_channel_user_status_image)
								gtk.gdk.threads_leave()
								break
							iter = self.lobby_pm_users[index].iter_next(iter)

					# Battle Chat
					if battle_id != None and battle_id == self.battle_id:
						iter = self.battle_user_liststore.get_iter_first()
						while iter != None:
							if self.battle_user_liststore.get_value(iter,0) == username:
								gtk.gdk.threads_enter()
								self.battle_user_liststore.set_value(iter, 4, status_image)
								self.battle_user_liststore.set_value(iter, 5, rank_image)
								self.battle_user_liststore.set_value(iter, 6, admin_image)
								self.battle_user_liststore.set_value(iter, 7, status)
								self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[4],update_channel_admin_status_image)
								self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[3],update_channel_user_rank_image)
								self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[2], self.UpdateUserFontColor)
								self.battle_chat_users_columns[1].set_cell_data_func(self.battle_chat_users_cells[1],update_channel_user_country_image)
								self.battle_chat_users_columns[0].set_cell_data_func(self.battle_chat_users_cells[0],update_channel_user_status_image)
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

# /end clientstatus() ==============================================================================



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
				self.intialise_server_variables()
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
			self.RemoveChannelChatBuffer(self, command[0])
			self.warning('Force Leave Channel ' + command[0], '<' + command[0] + '>' + text)
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
# 3 Founder
			temp = '' + command[9]
			for o in range(10,len(command)):
				temp = temp + ' ' + command[o]

			temp = temp.split("\t")
# 			self.battle_liststore = gtk.ListStore(0 = str, 1 = str, 2 = str, 3 = str, 4 = str, 5 = int, 6 = int, 7 = str, 8 = gtk.gdk.Pixbuf, 9 = str, 10 = str, 11 = str, 12 = str, 13 = str, 14 = bool)
			gtk.gdk.threads_enter()		#     0           1     2     3           4            5                6                7     8      9             10       11       12          13
			iter = self.battle_liststore.append([ command[0], None, None, command[3], command[4], int(command[5]), int(command[6]), None, None , temp[0][:-4], temp[1], temp[2], command[3], None, None ])

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
						self.battle_liststore.set(iter, 14, True)
					else:
						self.battle_liststore.set(iter, 14, False)
				        self.battle_column_1.set_cell_data_func(self.cell1, self.UpdateBattleFontColor)
				        self.battle_column_2.set_cell_data_func(self.cell2, self.UpdateBattleFontColor)
				        self.battle_column_3.set_cell_data_func(self.cell3, self.UpdateBattleFontColor)
				        self.battle_column_4.set_cell_data_func(self.cell4, self.UpdateBattleFontColor)
				        self.battle_column_5.set_cell_data_func(self.cell5, self.UpdateBattleFontColor)
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
					players_list = self.battle_liststore.get_value(iter,12)
					players_list = players_list + ', ' + command[1]
					self.battle_liststore.set_value(iter, 12, players_list)
					gtk.gdk.threads_leave()
					break
				iter = self.battle_liststore.iter_next(iter)

			if self.battle_id == command[0]:
				for o in range(0,len(self.userlist)):
					if self.userlist[o].name == command[1]:
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
	
						gtk.gdk.threads_enter()
						self.battle_user_liststore.append([username, flag, cpu, ip, status_image, rank_image, admin_image, status])
						self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[4],update_channel_admin_status_image)
						self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[3],update_channel_user_rank_image)
						self.battle_chat_users_columns[2].set_cell_data_func(self.battle_chat_users_cells[2], self.UpdateUserFontColor)
						self.battle_chat_users_columns[1].set_cell_data_func(self.battle_chat_users_cells[1],update_channel_user_country_image)
						self.battle_chat_users_columns[0].set_cell_data_func(self.battle_chat_users_cells[0],update_channel_user_status_image)
						text = '* ' + command[1] + ' has joined the Battle'
						self.UpdateTextbufferBattleChat(None, text, "Join")
						gtk.gdk.threads_leave()
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
					if username == command[1]:
						gtk.gdk.threads_enter()
						self.battle_user_liststore.remove(iter)
						text = '* ' + command[1] + ' has left the Battle'
						self.UpdateTextbufferBattleChat(command[0], text, "Leave")
						gtk.gdk.threads_leave()
						break
					iter = self.battle_user_liststore.iter_next(iter)

			iter = self.battle_liststore.get_iter_first()
			while iter != None:
				if self.battle_liststore.get_value(iter,0) == command[0]:
					gtk.gdk.threads_enter()
					players_list = self.battle_liststore.get_value(iter,12)
					players_list.lstrip(', ' + command[1])
					self.battle_liststore.set_value(iter, 12, players_list)
					gtk.gdk.threads_leave()
					break
				iter = self.battle_liststore.iter_next(iter)

			for o in range(0,len(self.userlist)):
				if self.userlist[o].name == command[1]:
					self.userlist[o].updateBattleHost(False)
					self.userlist[o].ID(None)
				break

		except Exception, inst:
			print
			print 'leftbattle'
			print type(inst)     # the exception instance
			print inst.args      # arguments stored in .args
			print inst           # __str__ allows args to printed directly
			x, y = inst          # __getitem__ allows args to be unpacked directly
			print 'x =', x
			print 'y =', y


	def updatebattleinfo(self, command):
		try:
			gtk.gdk.threads_enter()
			iter = self.battle_liststore.get_iter_first()
			while iter != None:
				mapname = command[3]
				for o in range(4, len(command)):
					mapname = mapname + ' ' +  command[o]
				if self.battle_liststore.get_value(iter,0) == command[0]:
					if command[2] == '0':
						self.battle_liststore.set_value(iter, 13, None)
					else:
						self.battle_liststore.set_value(iter, 13, gtk.STOCK_NO)
					self.battle_liststore.set_value(iter, 9, mapname[:-4])
					break
				iter = self.battle_liststore.iter_next(iter)

			self.battle_column_0.set_cell_data_func(self.cell0a, self.UpdateBattleLocked)
			gtk.gdk.threads_leave()

		except Exception, inst:
			print
			print 'Updatebattleinfo'
			print type(inst)     # the exception instance
			print inst.args      # arguments stored in .args
			print inst           # __str__ allows args to printed directly
			x, y = inst          # __getitem__ allows args to be unpacked directly
			print 'x =', x
			print 'y =', y


	def openbattle(self, args, send=False):
		try:
			if send == True:
				self.client.send("OPENBATTLE", args)
			else:
				self.battle_id = args
				self.battle.HostNetworkGameSucess()
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
			self.WarningDialog('Open Battle Failed', text)
			gtk.gdk.threads_enter()
			self.battle.network_button.set_active(False)
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

	def leavebattle(self):
		try:
			self.client.send("LEAVEBATTLE")
			self.battle_id = None
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
			self.WarningDialog('Error', msg[1])
		except Exception, inst:
			print
			print 'error'
			print type(inst)     # the exception instance
			print inst.args      # arguments stored in .args
			print inst           # __str__ allows args to printed directly
			x, y = inst          # __getitem__ allows args to be unpacked directly
			print 'x =', x
			print 'y =', y


	def joinbattle(self, data):
		try:
			self.battle.JoinNetworkGame()
#			iter = self.battle_liststore.get_iter_first()
			self.battle.UpdateNetworkGame(data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8])

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

	def updatebattledetails(self, command, send):
		try:
			if send == True:
				self.client.send("UPDATEBATTLEDETAILS", args)
			else:
				self.battle.UpdateNetworkGame(command)
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
			self.client.send("MYBATTLESTATUS", battlestatus, myteamcolor)
		except Exception, inst:
			print
			print 'mybattlestatus'
			print type(inst)     # the exception instance
			print inst.args      # arguments stored in .args
			print inst           # __str__ allows args to printed directly
			x, y = inst          # __getitem__ allows args to be unpacked directly
			print 'x =', x
			print 'y =', y


	def requestbattlestatus(self): #REQUESTBATTLESTATUS
		try:
			self.battle.MyBattleStatus()
		except Exception, inst:
			print
			print 'requestbattlestatus'
			print type(inst)     # the exception instance
			print inst.args      # arguments stored in .args
			print inst           # __str__ allows args to printed directly
			x, y = inst          # __getitem__ allows args to be unpacked directly
			print 'x =', x
			print 'y =', y
