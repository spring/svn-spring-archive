#!/usr/bin/env python

#======================================================
 #            Map_Index.py
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
import ConfigParser
import os
import gtk

from threading import Thread


class Map_Index(Thread):

	def __init__(self, index_map):
		Thread.__init__(self)

		self.status_icon_tooltip = index_map.status_icon_tooltip
		self.unitsync_wrapper = index_map.unitsync_wrapper

		self.map_index = index_map.map_index
		self.map_index_file = index_map.map_index_file
		self.map_count = index_map.map_count

   

	def run(self):

		
		map_list = []
		checksums = []

		for i in range(0,self.map_count):
			map_list.append(self.unitsync_wrapper.get_map_name(i))

		for i in range(0,len(map_list)):
			self.status_icon_tooltip('Checking for New Maps: ' + str(((i+1) / float(self.map_count))* 100) +'%')
      			while gtk.events_pending():
		        	gtk.main_iteration()

			map_archive_count = -1
			checksums.append(str(self.unitsync_wrapper.get_map_checksum(i)))
			if self.map_index.has_section(checksums[i]) == False:
				map_data = self.unitsync_wrapper.get_map_info(map_list[i])
				self.map_index.add_section(checksums[i])
				map_archive_count = 1
			else:
				map_archive_count = self.map_index.getint(checksums[i], 'MAP_COUNT') + 1
				for p in range(1,(map_archive_count)):
					if self.map_index.get(str(checksums[i]), ('NAME_' + str(p))) == map_list[i]:
						map_archive_count = -1
						break
				if map_archive_count != -1:
					map_data = self.unitsync_wrapper.get_map_info(map_list[i])

			if map_archive_count != -1:
				# Map Info
				self.map_index.set(checksums[i], 'MAP_COUNT',map_archive_count)
				self.map_index.set(checksums[i], ('NAME_'+str(map_archive_count)), map_list[i])
				self.map_index.set(checksums[i], ('PLAYERS_'+str(map_archive_count)), (map_data[1]["posCount"]))
				self.map_index.set(checksums[i], ('HEIGHT_'+str(map_archive_count)), (map_data[1]["height"] /512 ) )
				self.map_index.set(checksums[i], ('WIDTH_'+str(map_archive_count)), (map_data[1]["width"] / 512) )
				self.map_index.set(checksums[i], ('MIN_WIND_'+str(map_archive_count)), (map_data[1]["minWind"]))
				self.map_index.set(checksums[i], ('MAX_WIND_'+str(map_archive_count)), (map_data[1]["maxWind"]))
				self.map_index.set(checksums[i], ('TIDAL_STRENGTH_'+str(map_archive_count)), (map_data[1]["tidalStrength"]))
				self.map_index.set(checksums[i], ('EXTRACTOR_RADIUS_'+str(map_archive_count)), (map_data[1]["extractorRadius"]))
				self.map_index.set(checksums[i], ('MAX_METAL_'+str(map_archive_count)), (map_data[1]["maxMetal"]))
				self.map_index.set(checksums[i], ('GRAVITY_'+str(map_archive_count)), (map_data[1]["gravity"]))
				self.map_index.write(open(self.map_index_file, "w+"))
				self.map_index.read(self.map_index_file)


		index_checksums = self.map_index.sections()
		index_checksums.remove('INDEX')
		remove_checksums = []
		for o in range(0,len(index_checksums)):
			self.status_icon_tooltip('Checking for Missing Maps: ' + str( ((o+1) / float(len(index_checksums)))*100) + '%')
      			while gtk.events_pending():
		        	gtk.main_iteration()
			remove = True
			for p in range(0,len(checksums)):
				if index_checksums[o] == checksums[p]:
					remove = False
					break
			if remove == True:
				remove_checksums.append(index_checksums[o])
		for o in range(0,len(remove_checksums)):
			self.map_index.remove_section(remove_checksums[o])
			self.map_index.write(open(self.map_index_file, "w+"))
			self.map_index.read(self.map_index_file)


		self.map_index.set('INDEX', 'MAP_COUNT',  self.map_count)
		self.map_index.write(open(self.map_index_file, "w+"))
		self.map_index.read(self.map_index_file)


class index_map:

	def __init__(self, status_icon):

		self.status_icon_tooltip = status_icon.tooltip

		# Unitsync Wrapper
		self.unitsync_wrapper = status_icon.unitsync_wrapper

		# Map Index Cache
		self.map_index_file = status_icon.map_index_file
		if os.path.isfile(self.map_index_file) == False:
			self.create_index()
		self.map_index = ConfigParser.ConfigParser()
		self.map_index.optionxform = lambda x: x
		self.map_index.read(self.map_index_file)



	def create_index(self):
		dest_fd = open(self.map_index_file,"w+")
		dest_fd.write('[INDEX]\n')
		dest_fd.write('MAP_COUNT=0\n')
		dest_fd.close()


	def check_if_update_needed(self):
		self.map_count = self.unitsync_wrapper.get_map_count()
		if self.map_index.getint('INDEX','MAP_COUNT') != self.map_count:
			self.rescan_index()


	def rescan_index(self):
		if self.map_count != 0:
			index_scan = Map_Index(self)
			index_scan.start()
			index_scan.join()			
		else:
			create_index(self)


	def list_checksums(self):
		self.map_checksum_list = self.map_index.sections()
		self.map_checksum_list.remove('INDEX')
		return self.map_checksum_list


	def map_info(self, checksum, map_number):
		map_number = str(map_number)
		map_info = {'NAME':self.map_index.get(checksum, ('NAME_'+map_number)),
			'PLAYERS':self.map_index.getint(checksum, ('PLAYERS_'+map_number)),
			'HEIGHT':self.map_index.getint(checksum, ('HEIGHT_'+map_number)),
			'WIDTH':self.map_index.getint(checksum, ('WIDTH_'+map_number)),
			'MIN WIND':self.map_index.getint(checksum, ('MIN_WIND_'+map_number)),
			'MAX WIND':self.map_index.getint(checksum, ('MAX_WIND_'+map_number)),
			'TIDAL STRENGTH':self.map_index.getint(checksum, ('TIDAL_STRENGTH_'+map_number)),
			'EXTRACTOR RADIUS':self.map_index.getint(checksum, ('EXTRACTOR_RADIUS_'+map_number)),
			'MAX METAL':self.map_index.get(checksum, ('MAX_METAL_'+map_number)),
			'GRAVITY':self.map_index.get(checksum, ('GRAVITY_'+map_number))}
		return map_info


	def all_map_info(self):
		info = []
		for i in range(0,len(self.map_checksum_list)):
			map_count = self.map_index.getint(self.map_checksum_list[i], 'MAP_COUNT')
			for p in range(1,map_count+1):
				map_data = self.map_info(self.map_checksum_list[i], p)
				i = str(i)
				info.append([ map_data[("NAME")][:-4],
						map_data[("PLAYERS")],
						map_data[("HEIGHT")],
						map_data[("WIDTH")],
						map_data[("MIN WIND")],
						map_data[("MAX WIND")],
						map_data[("TIDAL STRENGTH")],
						map_data[("EXTRACTOR RADIUS")],
						map_data[("MAX METAL")],
						map_data[("GRAVITY")] ])
				i = int(i)
		return info
