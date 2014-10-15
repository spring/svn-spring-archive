#!/usr/bin/env python

#======================================================
 #            Mod_Index.py
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
import ConfigParser
import os

# Custom Modules
import unitsync

import Config

# Generic Modules
import ConfigParser
import os

# Custom Modules
import unitsync

import Config


def create_index(self):
	dest_fd = open(self.mod_index,"w+")
	dest_fd.write('[INDEX]\n')
	dest_fd.close()
	Config.set_option(self.mod_index, 'INDEX', 'ARCHIVE_COUNT', '0')


def update_index(self):
	filename  = self.mod_index
	mod_index = ConfigParser.ConfigParser()
	mod_index.optionxform = lambda x: x
	mod_index.read(filename)

	mod_count = unitsync.GetPrimaryModCount()
	checksums = []

	# Add Mods to Archive
	if mod_count != 0:
		# Add Mods
		for i in range(0,mod_count):
# TODO Add GUI Progress Bar
#  Just Added console output, so users aware app is still working away
			print ('mod Count = ', i)
			checksums.append(str(unitsync.GetPrimaryModChecksum(i)))
			if mod_index.has_section(checksums[i]) == False:
				mod_index.add_section(checksums[i])
				mod_archive = unitsync.GetPrimaryModArchive(i)
				mod_index.set(checksums[i], 'MOD_NAME', unitsync.GetPrimaryModName(i))
				mod_index.set(checksums[i], 'MOD_ARCHIVE', mod_archive )
				sides = mod_sides(self, mod_archive)
				mod_index.set(checksums[i], 'SIDE_COUNT', len(sides))
				for p in range(0, len(sides)):
					mod_index.set(checksums[i], 'SIDE_'+str(p+1), sides[p])

		# Remove mods
		index_checksums = mod_index.sections()
		for o in range(0,len(index_checksums)):
			test = False
			for p in range(0,len(checksums)):
				if index_checksums[o] == checksums[p]:
					test = True
					break
			if test == False:
				mod_index.remove_section(index_checksums[o])
				

		mod_index.write(open(filename, "w+"))					
	else:
		create_index(self)

# Add Code to remove missing Mods


def mod_sides(self, mod_archive):
	unitsync.Init(True,1)
	unitsync.GetPrimaryModCount()
	unitsync.AddAllArchives(mod_archive)
	sides_count = unitsync.GetSideCount()
	mod_sides = []
	if sides_count == 0:
		mod_sides = ['ARM','CORE']  # Hack -> Workaround for when unitsync unable to get side info
	else:
		for i in range(0,sides_count):
			mod_sides.append(unitsync.GetSideName(i))
	return mod_sides


def mod_archive(self, checksum):
	filename  = self.mod_index
	mod_index = ConfigParser.ConfigParser()
	mod_index.optionxform = lambda x: x
	mod_index.read(filename)
	return mod_index.get(checksum, 'MOD_ARCHIVE')


def mod_archive_name(self,checksum):
	filename  = self.mod_index
	mod_index = ConfigParser.ConfigParser()
	mod_index.optionxform = lambda x: x
	mod_index.read(filename)
	name = mod_index.get(checksum, 'MOD_NAME', None)
	return name


def mod_archive_sides(self):
        treeselection = self.mod_treeview.get_selection()
        (model, iter) = treeselection.get_selected()
        if iter == None:
                iter = self.mod_liststore.get_iter_first()

        checksum = self.mod_liststore.get_value(iter, 1)

	filename  = self.mod_index
	mod_index = ConfigParser.ConfigParser()
	mod_index.optionxform = lambda x: x
	mod_index.read(filename)
	sides_count = int(mod_index.get(checksum, 'SIDE_COUNT'))
	sides = []
	for i in range(1,sides_count+1):
		sides.append(mod_index.get(checksum, 'SIDE_'+ str(i)))
	return sides
