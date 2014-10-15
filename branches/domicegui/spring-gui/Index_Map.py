#!/usr/bin/env python

#======================================================
 #            Index_Map.py
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



def create_index(self):
	dest_fd = open(self.map_index,"w+")
	dest_fd.write('[INDEX]\n')
	dest_fd.close()
	Config.set_option(self.map_index, 'INDEX', 'ARCHIVE_COUNT', '0')

def update_index(self):
	filename  = self.map_index
	map_index = ConfigParser.ConfigParser()
	map_index.optionxform = lambda x: x
	map_index.read(filename)

	unitsync.Init(True,1)
	map_count = unitsync.GetMapCount()

	if map_count != 0:
		map_list = []
		checksums = []

		for i in range(0,map_count):
			map_list.append(unitsync.GetMapName(i))

		for i in range(0,len(map_list)):
# TODO Add GUI Progress Bar
#  Just Added console output, so users aware app is still working away
			print ('Checking Map ' + str(i) + '/' + str(len(map_list) - 1))

			map_archive_count = -1
			checksums.append(str(unitsync.GetMapChecksum(i)))
			if map_index.has_section(checksums[i]) == False:
				map_data = unitsync.GetMapInfo(map_list[i])
				map_index.add_section(checksums[i])
				map_archive_count = 1
			else:
				map_count = int(map_index.get(checksums[i], 'MAP_COUNT', '200'))
				map_archive_count = map_count + 1
				for p in range(1,(map_count+1)):
					if (map_index.get(str(checksums[i]), ('NAME_' + str(p)))) == map_list[i]:
						map_archive_count = -1
						break
				if map_archive_count != -1:
					map_data = unitsync.GetMapInfo(map_list[i])



			if map_archive_count != -1:
				map_index.set(checksums[i], 'MAP_COUNT',map_archive_count)
				map_index.set(checksums[i], ('NAME_'+str(map_archive_count)), map_list[i])
				map_index.set(checksums[i], ('PLAYERS_'+str(map_archive_count)), (map_data[1]["posCount"]))
				map_index.set(checksums[i], ('HEIGHT_'+str(map_archive_count)), (map_data[1]["height"] /512 ) )
				map_index.set(checksums[i], ('WIDTH_'+str(map_archive_count)), (map_data[1]["width"] / 512) )
				map_index.set(checksums[i], ('MIN_WIND_'+str(map_archive_count)), (map_data[1]["minWind"]))
				map_index.set(checksums[i], ('MAX_WIND_'+str(map_archive_count)), (map_data[1]["maxWind"]))
				map_index.set(checksums[i], ('TIDAL_STRENGTH_'+str(map_archive_count)), (map_data[1]["tidalStrength"]))
				map_index.set(checksums[i], ('EXTRACTOR_RADIUS_'+str(map_archive_count)), (map_data[1]["extractorRadius"]))
				map_index.set(checksums[i], ('MAX_METAL_'+str(map_archive_count)), (map_data[1]["maxMetal"]))
				map_index.set(checksums[i], ('GRAVITY_'+str(map_archive_count)), (map_data[1]["gravity"]))


		# Remove maps
		index_checksums = map_index.sections()
		for o in range(0,len(index_checksums)):
			test = False
			for p in range(0,len(checksums)):
				if index_checksums[o] == checksums[p]:
					test = True
					break
			if test == False:
				map_index.remove_section(index_checksums[o])


		map_index.write(open(filename, "w+"))

	else:
		create_index(self)


def map_info(self,checksum,map_number):
	filename  = self.map_index
	map_number = str(map_number)
	map_index = ConfigParser.ConfigParser()
	map_index.optionxform = lambda x: x
	map_index.read(filename)
	map_info = {'NAME':map_index.get(checksum, ('NAME_'+map_number)),
		'PLAYERS':map_index.getint(checksum, ('PLAYERS_'+map_number)),
		'HEIGHT':map_index.getint(checksum, ('HEIGHT_'+map_number)),
		'WIDTH':map_index.getint(checksum, ('WIDTH_'+map_number)),
		'MIN WIND':map_index.getint(checksum, ('MIN_WIND_'+map_number)),
		'MAX WIND':map_index.getint(checksum, ('MAX_WIND_'+map_number)),
		'TIDAL STRENGTH':map_index.getint(checksum, ('TIDAL_STRENGTH_'+map_number)),
		'EXTRACTOR RADIUS':map_index.getint(checksum, ('EXTRACTOR_RADIUS_'+map_number)),
		'MAX METAL':map_index.get(checksum, ('MAX_METAL_'+map_number)),
		'GRAVITY':map_index.get(checksum, ('GRAVITY_'+map_number))}
	return map_info
