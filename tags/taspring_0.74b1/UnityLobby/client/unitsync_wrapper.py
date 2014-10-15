#!/usr/bin/env python

#======================================================
 #            unitsync_wrapper.py
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



import unitsync


class unitsync_wrapper:

	def __init__(self, datadir):
		import os

		# Chdir to datadir
		if datadir != None:
			os.chdir(datadir)

		# Initialise Unitsync
		unitsync.Init(True,1)

			# Datadirs
		self.datadirs = unitsync.GetDataDirectories(False)


	def datadirs_list(self):
		return self.datadirs

	def get_map_count(self):
		self.map_count = unitsync.GetMapCount()
		return self.map_count

	def get_map_checksum(self, map_number):
		return unitsync.GetMapChecksum(map_number)

	def get_map_name(self, map_number):
		return unitsync.GetMapName(map_number)

	def get_map_info(self, map_name):
		return unitsync.GetMapInfo(map_name)

	def create_map_preview(self, map_name, mip, map_preview):
		unitsync.GetMinimap(map_name, mip, map_preview)




	def get_mod_count(self):
		self.mod_count = unitsync.GetPrimaryModCount()
		return self.mod_count

	def get_mod_checksum(self, mod_number):
		return unitsync.GetPrimaryModChecksum(mod_number)

	def get_primary_mod_archive(self, mod_number):
		return unitsync.GetPrimaryModArchive(mod_number)

	def get_primary_mod_name(self, mod_number):
		return unitsync.GetPrimaryModName(mod_number)

	def get_mod_sides(self, mod_archive):
		unitsync.GetPrimaryModCount()
		unitsync.AddAllArchives(mod_archive)
		sides_count = unitsync.GetSideCount()
		mod_sides = []
		if sides_count == 0:
			mod_sides = ['ARM','CORE']  # Hack -> Workaround for when Mod Author's forget to define sides
		else:
			for i in range(0,sides_count):
				mod_sides.append(unitsync.GetSideName(i))
		unitsync.Init(True,1)
		return mod_sides
