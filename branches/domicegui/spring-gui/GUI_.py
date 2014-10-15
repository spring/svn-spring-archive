#!/usr/bin/env python

#======================================================
 #            GUI_.py
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

import gtk
import os

# Custom Modules
import GLOBAL

import Config


def combobox_setup(conf_temp, section, option, default, foo):
# Function to setup a combobox
	combobox = gtk.combo_box_new_text()
	for i in range (0,(len(foo))):
		combobox.append_text(foo[i])
	if conf_temp != None:
		value = int(Config.get_option(conf_temp,section,option,default))
		combobox.set_active(value)
	else:
		combobox.set_active(default)
	combobox.show()
	return combobox


def spinner_create(conf_temp, option, default, foo):
# Function to setup spinner box's
	value = float(Config.get_option(conf_temp, 'GAME', option, default))
	adjustment = gtk.Adjustment(value, foo[0], foo[1], foo[2], foo[3], page_size=0)
	spinner = gtk.SpinButton(adjustment, 0, 0)
	spinner.show()
	return spinner


def label_create(text):
# Function to attach label to a table
	label = gtk.Label(text)
	label.set_justify(gtk.JUSTIFY_LEFT)
	label.show()
	return label


def frame_create(text):
# Function to create a frame & attach to a table & return the frame
	frame = gtk.Frame()
	frame.set_label(text)
	frame.set_shadow_type(gtk.SHADOW_ETCHED_OUT)
	frame.show()
	return frame

def create_page(self, notebook, text, x, y):
	frame = gtk.Frame(text)
	frame.set_border_width(10)
	frame.set_size_request(x,y)
	frame.show()

	label = gtk.Label(text)
	notebook.append_page(frame, label)

	return frame

def custom_button(self, label, folder, image_file):
	image_file = os.path.join(GLOBAL.SPRING_GUI_INSTALL,'resource',folder,image_file)
        image = gtk.Image()
        image.set_from_file(image_file)
        image.show()
        # a button to contain the image widget
        button = gtk.Button()
        button.add(image)
	return button
