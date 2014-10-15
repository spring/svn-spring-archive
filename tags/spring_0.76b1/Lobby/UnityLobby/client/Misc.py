#!/usr/bin/env python

#======================================================
 #            Misc.py
 #
 #  Thurs September 7 11:20 2006
 #  Copyright  2006  Josh Mattila
 #  		     Declan Ireland
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

import gtk


def create_page(self, notebook, text, x, y):
	frame = gtk.Frame(None)
	frame.set_border_width(10)
	frame.set_size_request(x,y)
	frame.show()

	label = gtk.Label(text)
	notebook.append_page(frame, label)

	return frame

def frame_create(text):
## Function to create a frame & attach to a table & return the frame
	frame = gtk.Frame()
	frame.set_label(text)
	frame.set_shadow_type(gtk.SHADOW_ETCHED_OUT)
	frame.show()
	return frame

def label_create(text):
## Function to attach label to a table
	label = gtk.Label(text)
	label.set_justify(gtk.JUSTIFY_LEFT)
	label.show()
	return label

def combobox_setup(options, value, visible):
## Function to setup a combobox
	combobox = gtk.combo_box_new_text()
	for i in range (0,(len(options))):
		combobox.append_text(options[i])
	combobox.set_active(int(value))
	if visible == True:
		combobox.show()
	return combobox


def spinner_create(options, value, visible):
# Function to setup spinner box's
	adjustment = gtk.Adjustment(int(value), options[0], options[1], options[2], options[3], page_size=0)
	spinner = gtk.SpinButton(adjustment, 0, 0)
	if visible == True:
		spinner.show()
	return spinner
