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
import Lobby


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
    
	def __init__(self, parent_window): #, table, lobby_ini, setup_ini, setup_profile):
# self.lobby = gui_lobby(self.window, lobby_table, self.lobby_ini, self.ini_file ,self.profile)

		# Initialize variables        

		self.lobby_channel_names = []
		self.lobby_channel_buffers = []
		self.lobby_channel_textview = []
		self.lobby_channel_users = []
		self.lobby_channel_users_cells = []
		self.lobby_channel_users_columns = []

		self.lobby_pm_names = []
		self.lobby_pm_buffers = []
		self.lobby_pm_textview = []
		self.lobby_pm_users = []

		self.window = parent_window.window
		
		self.lobby_ini = parent_window.lobby_ini
		self.lobby_ini_file = parent_window.lobby_ini_file

		self.ini = parent_window.ini
		self.setup_profile = parent_window.profile

		self.unity_location = self.ini.get(self.setup_profile, 'UNITY_INSTALL_DIR')

		table = parent_window.lobby_table

			# User ListStore
				# 0 Username
				# 1 Country
				# 2 Cpu
				# 3 IP
					# 4 Status -> InGame / Away
					# 5 Rank
					# 6 Moderator
# FIX Add Images -> gtk.gdk.Pixbuf
		self.user_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf)
		self.country_flags = {}
		self.rank_images = {}
		self.status_images = {}


		# GUI
			# Lobby Notebook
		self.lobby_notebook = gtk.Notebook()
	        self.lobby_notebook.set_tab_pos(gtk.POS_LEFT)
		self.lobby_notebook.show()
		table.attach(self.lobby_notebook,0,1,1,2)

		gtk.threads_leave()
		self.create_channel('$local', False)
		gtk.threads_enter()

		self.connect_button = gtk.ToolButton(gtk.STOCK_DISCONNECT)
		self.connect_button.connect("clicked", self.connection)
		self.connect_button.show()

		self.preferences_button = gtk.ToolButton(gtk.STOCK_PREFERENCES)
		self.preferences_button.connect("clicked", self.preferences)
		self.preferences_button.show()

		toolbar = gtk.Toolbar()	
		toolbar.insert(self.connect_button, 0)
		toolbar.insert(self.preferences_button, 1)		
		toolbar.set_style(gtk.TOOLBAR_ICONS)
		toolbar.show()

		table.attach(toolbar,0,1,0,1, gtk.FILL, gtk.FILL,0,0)

		Lobby.client(self)


	def preferences(self):
		pass


	def reintialise_server_variables(self):
	# Called when client is diconnected. Reinitialises Variables that store data.
		# Also kills all open tabs  besides $local
			# Clears text in $local
		self.lobby_channel_buffers[0].delete(self.lobby_channel_buffers[0].get_start_iter(), self.lobby_channel_buffers[0].get_end_iter())

		while len(self.lobby_channel_names) != 1:
			self.lobby_channel_names.pop(1)
			self.lobby_channel_buffers.pop(1)
			self.lobby_channel_textview.pop(1)
			self.lobby_channel_users.pop(1)
			self.lobby_channel_users_cells.pop(1)
			self.lobby_channel_users_columns.pop(1)

		self.lobby_pm_names = []
		self.lobby_pm_buffers = []
		self.lobby_pm_textview = []
		self.lobby_pm_users = []

		self.user_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf)
		self.country_flags = {}
		self.rank_images = {}
		self.status_images = {}

		while self.lobby_notebook.get_n_pages() != 1:
			self.lobby_notebook.remove_page(1)


	def create_channel(self, channel_name, closeable):
	# Creates Data Stores for channels
		textbuffer = gtk.TextBuffer(table=None)

		textview = gtk.TextView(buffer=textbuffer)
		textview.set_editable(False)
		textview.set_cursor_visible(False)
		textview.set_wrap_mode(gtk.WRAP_WORD)
		textview.set_justification(gtk.JUSTIFY_LEFT)
		textview.show()

		self.lobby_channel_names.append(channel_name)
		self.lobby_channel_buffers.append(textbuffer)
		self.lobby_channel_textview.append(textview)


		self.create_channel_window(closeable)


	def create_channel_window(self, closeable):
	# Creates GUI for channel
		last_index = len(self.lobby_channel_names) - 1
		gtk.threads_enter()

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
		 	player_liststore = gtk.ListStore(str, gtk.gdk.Pixbuf, str, str, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf, gtk.gdk.Pixbuf)
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
			player_treeview.connect('event',self.player_popup_menu)
		
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

			tag_table = self.lobby_channel_buffers[last_index].get_tag_table()

			join_tag = gtk.TextTag("join")
			join_tag.set_property("foreground", "blue")
			tag_table.add(join_tag)

			left_tag = gtk.TextTag("left")
			left_tag.set_property("foreground", "grey")
			tag_table.add(left_tag)

			topic_tag = gtk.TextTag("topic")
			topic_tag.set_property("foreground", "purple")
			tag_table.add(topic_tag)
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
		entry.connect("activate", self.parse_output, self.lobby_channel_names[last_index])
		table.attach(entry, 0,2,1,2, gtk.FILL, gtk.FILL,0,0)

		# Notebook Page
		tab_index = self.lobby_notebook.append_page(vpane, label_box)
		if closeable == True:
			label_box.connect('event', self.on_chat_tab_click, frame, self.lobby_channel_names[last_index], tab_index)

		gtk.threads_leave()


	def parse_output(self, entry, channel_name):
	# Parses User Input
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


	def on_chat_tab_click(self, widget, event, frame, channel_name, tab_index):
	# Checks if event on tab is right click
		# If it is Leaves Channel & Deletes Data Stores for the channel
		if  event.type == gtk.gdk.BUTTON_PRESS:
			if event.button == 3:
				for i in range(0,len(self.lobby_channel_names)):
					if self.lobby_channel_names[i] == channel_name:
						self.lobby_notebook.remove_page(tab_index)
						self.lobby_channel_names.pop(i)
						self.lobby_channel_buffers.pop(i)
						self.lobby_channel_textview.pop(i)
						self.lobby_channel_users.pop(i)
						self.client.send('LEAVE', channel_name)
						break


	def player_popup_menu(self, widget, event):
		pass
	

	def join_channel(self):
		chat_window(self)


	def connection(self, button):
	# Handles GUI for button & either disconnects / connects to lobby
		if self.connect_button.get_stock_id() == gtk.STOCK_DISCONNECT:
			self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)

			server_list = self.lobby_ini.sections()
			for i in range(0,len(server_list)):
				default = self.lobby_ini.get(server_list[i], 'Default', 'NO')
				if default == 'Yes':
					server = server_list[i]
					port = self.lobby_ini.getint(server_list[i], 'Port')
					username = self.lobby_ini.get(server_list[i], 'UserName')
					password = self.lobby_ini.get(server_list[i], 'UserPassword')
					break

			self.client = Lobby.client(self)
			self.client.connect(server, port, username, password)
			self.client.reLogin()
		elif self.connect_button.get_stock_id() == gtk.STOCK_CONNECT:
			self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
			self.client.disconnect('User')
			self.reintialise_server_variables()
			self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)


	def update_textbuffer_channel(self, channel_name, username, text, tag=None):
	# Updates TextBuffers for chat
		
		for i in range (0,len(self.lobby_channel_names)):
			if self.lobby_channel_names[i] == channel_name:
				gtk.threads_enter()
				iter = self.lobby_channel_buffers[i].get_end_iter()
				self.lobby_channel_buffers[i].insert(iter, '\n')
				iter = self.lobby_channel_buffers[i].get_end_iter()
				if tag == "join":
					self.lobby_channel_buffers[i].insert_with_tags_by_name(iter, text, "join")

				elif tag == "left":
					self.lobby_channel_buffers[i].insert_with_tags_by_name(iter, text, "left")
				elif tag == "topic":
					self.lobby_channel_buffers[i].insert_with_tags_by_name(iter, text, "topic")

				else:
					if username != None:
						self.lobby_channel_buffers[i].insert(iter, '<' + username + '> ')
					self.lobby_channel_buffers[i].insert(iter, text)

				if self.lobby_channel_buffers[i].get_line_count() > 50:
					self.lobby_channel_buffers[i].delete(self.lobby_channel_buffers[i].get_start_iter(), self.lobby_channel_buffers[i].get_iter_at_line(1))
				self.lobby_channel_textview[i].scroll_mark_onscreen(self.lobby_channel_buffers[i].get_insert())
				gtk.threads_leave()
				break




	def update_connected_button(self, connected):
	# Used by Lobby.py  class == client  for changing Connect Button upon successful login / disconnecting
		gtk.threads_enter()
		if connected == True:
			self.connect_button.set_stock_id(gtk.STOCK_CONNECT)
		else:
			self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
			self.reintialise_server_variables()
			self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)
		gtk.threads_leave()


	def warning(self, title, text):
	# Warning Dialog
		gtk.threads_enter()
		dialog = gtk.Dialog(title, self.window, gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT, (gtk.STOCK_CLOSE, gtk.RESPONSE_CLOSE))
		dialog.vbox.pack_start(gtk.Label(text))
		dialog.show_all()
		result = dialog.run()
		dialog.destroy()
		gtk.threads_leave()


	def info(self, title, text):
	# Info Dialog
		gtk.threads_enter()
		dialog = gtk.Dialog(title, self.window, gtk.DIALOG_MODAL | gtk.DIALOG_DESTROY_WITH_PARENT, (gtk.STOCK_CLOSE, gtk.RESPONSE_CLOSE))
		dialog.vbox.pack_start(gtk.Label(text))
		dialog.show_all()
		result = dialog.run()
		dialog.destroy()
		gtk.threads_leave()


	def get_country_flag(self, country):
		if self.country_flags.has_key(country) == True:
			return self.country_flags[country]
		else:
			if country != "xx":
				file_location = os.path.join(self.unity_location, 'resources', 'flags', country + '.svg')
				pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,25)
			else:
				pixbuf = None
			self.country_flags[country] = pixbuf
			return pixbuf


	def get_rank_image(self, rank):
		if self.rank_images.has_key(rank) == True:
			return self.rank_images[rank]
		else:
			file_location = os.path.join(self.unity_location, 'resources', 'ranks', rank + '.png')
			pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,25)
			self.rank_images[rank] = pixbuf
			return pixbuf				


	def get_status_image(self, status):
		if self.status_images.has_key(status) == True:
			return self.status_images[status]
		else:
			file_location = os.path.join(self.unity_location, 'resources', 'status', status + '.png')
			pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(file_location,25,25)
			self.status_images[status] = pixbuf
			return pixbuf


	def register_account(self, server_address, server_port, username, encoded_password):
		if self.connect_button.get_stock_id() == gtk.STOCK_DISCONNECT:
			self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
			self.client = Lobby.client(self)
			self.client.connect(server_address, server_port, username, encoded_password)
			self.client.Register()
		elif self.connect_button.get_stock_id() == gtk.STOCK_CONNECT:
			self.connect_button.set_stock_id(gtk.STOCK_EXECUTE)
			self.client.disconnect('User')
			self.reintialise_server_variables()
			self.connect_button.set_stock_id(gtk.STOCK_DISCONNECT)

			self.client = Lobby.client(self)
			self.client.connect(server_address, server_port, username, encoded_password)
			self.client.Register()
		else:
			self.warning('Warning', 'Plz disconnect from lobby server & try again')
			

# Lobby Protocols
	def servermsg(self, command):	
		text = 'Server Message ->'
		for i in range(0, len(command)):
			text = text + ' ' + command[i]
		self.update_textbuffer_channel(self.lobby_channel_names[0], None, text)


	def servermsgbox(self, command):
		if len(command) != 0:
			text = command[0]
		else:
			text = ''
		for i in range(1, len(command)):
			text = text + ' ' + command[i]
		self.warning('Server Message', text)

		
	def channelmessage(self, command):
		if len(command) != 0:
			text = 'Channel Message -> ' + command[1]
		else:
			text = 'Channel Message ->'
		for i in range(2, len(command)):
			text = text + command[i]
		self.update_textbuffer_channel(command[0], None, text)

		
	def denied(self, command):
		if len(command) != 0:
			text = command[0]
		else:
			text = ''
		for i in range(1, len(command)):
			text = text + ' ' + command[i]
		self.warning('Denied', text)


	def motd(self, command):
		if len(command) != 0:
			text = command[0]
		else:
			text = ''
		for i in range(1, len(command)):
			text = text + ' ' + command[i]
		self.update_textbuffer_channel(self.lobby_channel_names[0], None, text)


	def join(self, command):
		self.create_channel(command[0], True)


	def said(self, command):
		text = ''
		for i in range(2, len(command)):
			text = text + ' ' + command[i]
		self.update_textbuffer_channel(command[0], command[1], text)


	def adduser(self, command):
		flag = self.get_country_flag(command[1])

		self.user_liststore.append([ command[0], flag, command[2], command[3], self.get_status_image('here'), self.get_rank_image("1"), None])


	def removeuser(self, command):
		iter = self.user_liststore.get_iter_first()
		while iter != None:
			if self.user_liststore.get_value(iter,0) == command:
				self.user_liststore.remove(iter)
				break
			iter = self.user_liststore.iter_next(iter)


	def joinedfailed(self, command):
		if len(command) != 0:
			text = command[0]
		else:
			text = ''
		for i in range(1, len(command)):
			text = text + ' ' + command[i]
		self.warning('Join Channel Failed', text)


	def clients(self, command):
		for i in range(0,len(self.lobby_channel_names)):
			if command[0] == self.lobby_channel_names[i]:
				channel_index = i
		for p in range(1,len(command)):
			iter = self.user_liststore.get_iter_first()
			while iter != None:
				username = self.user_liststore.get_value(iter,0)
				if username == command[p]:
					gtk.threads_enter()
					self.lobby_channel_users[channel_index].append([username, self.user_liststore.get_value(iter,1), self.user_liststore.get_value(iter,2), self.user_liststore.get_value(iter,3), self.user_liststore.get_value(iter,4), self.user_liststore.get_value(iter,5), self.user_liststore.get_value(iter,6)])
					self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][4],update_channel_admin_status_image)
					self.lobby_channel_users_columns[channel_index][2].set_cell_data_func(self.lobby_channel_users_cells[channel_index][3],update_channel_user_rank_image)
					self.lobby_channel_users_columns[channel_index][1].set_cell_data_func(self.lobby_channel_users_cells[channel_index][1],update_channel_user_country_image)
					self.lobby_channel_users_columns[channel_index][0].set_cell_data_func(self.lobby_channel_users_cells[channel_index][0],update_channel_user_status_image)
					gtk.threads_leave()
					break
				iter = self.user_liststore.iter_next(iter)


	def left(self, command):
		for i in range(0,len(self.lobby_channel_names)):
			if command[0] == self.lobby_channel_names[i]:
				channel_index = i

		iter = self.lobby_channel_users[channel_index].get_iter_first()
		while iter != None:
			username = self.lobby_channel_users[channel_index].get_value(iter,0)
			if username == command[1]:
				gtk.threads_enter()
				self.lobby_channel_users[channel_index].remove(iter)
				gtk.threads_leave()
				break
			iter = self.lobby_channel_users[channel_index].iter_next(iter)

		text = ''
		for i in range(2, len(command)):
			text = text + ' ' + command[i]
		text = '* ' + command[1] + ' has left ' + command[0] + ' (' + text[1:] + ')'
		self.update_textbuffer_channel(command[0], None, text, "left")


	def joined(self, command):
		for i in range(0,len(self.lobby_channel_names)):
			if command[0] == self.lobby_channel_names[i]:
				channel_index = i

		iter = self.user_liststore.get_iter_first()
		while iter != None:
			username = self.user_liststore.get_value(iter,0)
			if username == command[1]:
				gtk.threads_enter()
				self.lobby_channel_users[channel_index].append([username, self.user_liststore.get_value(iter,1), self.user_liststore.get_value(iter,2), self.user_liststore.get_value(iter,3), self.user_liststore.get_value(iter,4), self.user_liststore.get_value(iter,5), self.user_liststore.get_value(iter,6)])
				gtk.threads_leave()
				break
			iter = self.user_liststore.iter_next(iter)

		text = '* ' + command[1] + ' has joined ' + command[0]
		self.update_textbuffer_channel(command[0], None, text, "join")


	def clientstatus(self, command): #CLIENTSTATUS username status

		status =  int(command[1])

		if (status & 1) != 0:
			status_image = self.get_status_image('ingame')
		else:
			if (status & 2) != 0:
				status_image = self.get_status_image('away')
			else:
				status_image = self.get_status_image('here')

       		rank = 0x1c & status
		rank = rank >> 2
		rank = str(rank + 1)
		rank = self.get_rank_image(rank)

		if (status & 32) !=0:
			admin = self.get_rank_image("admin")
		else:
			admin = None

			# User ListStore
				# Username
				# Country
				# Cpu
				# IP
					# InGame
					# Away
					# Rank
					# Moderator
		iter = self.user_liststore.get_iter_first()
		while iter != None:
			if self.user_liststore.get_value(iter,0) == command[0]:
				self.user_liststore.set_value(iter, 4, status_image)
				self.user_liststore.set_value(iter, 5, rank)
				self.user_liststore.set_value(iter, 6, admin)
				break
			iter = self.user_liststore.iter_next(iter)


	def channeltopic(self, command):#CHANNELTOPIC channame author changedtime {topic}
		text = ''
		for i in range(3, len(command)):
			text = text + ' ' + command[i]
		text = "* Topic for " + command[0] + " is: " + text
		self.update_textbuffer_channel(command[0], None, text, "topic")
		text = "* Topic for " + command[0] + " set by: " + command[1]  # + ' at ' + str(command[2])
		self.update_textbuffer_channel(command[0], None, text, "topic")


		


#		except Exception, inst:
#			print type(inst)     # the exception instance
#			print inst.args      # arguments stored in .args
#			print inst           # __str__ allows args to printed directly
#			x, y = inst          # __getitem__ allows args to be unpacked directly
#			print 'x =', x
#			print 'y =', ys
