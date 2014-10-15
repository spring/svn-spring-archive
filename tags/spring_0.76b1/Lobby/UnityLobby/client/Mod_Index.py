#!/usr/bin/env python

#======================================================
 #            Mod_Index.py
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

## Generic Modules
import ConfigParser
import gtk

from threading import Thread


class Mod_Index(Thread):

    def __init__(self, index_mod):
        Thread.__init__(self)

        self.status_icon_tooltip = index_mod.status_icon_tooltip
        self.unitsync_wrapper = index_mod.unitsync_wrapper

        self.mod_index = index_mod.mod_index
        self.mod_index_file = index_mod.mod_index_file
        self.mod_count = index_mod.mod_count
   

    def run(self):
        checksums = []

    ## Add Mods to Archive
        if self.mod_count != 0:
            ## Add Mods
            for i in range(0,self.mod_count):
                self.status_icon_tooltip('Checking for New Mods: ' + str( ((i+1) / float(self.mod_count)) * 100) + '%')
                while gtk.events_pending():
                    gtk.main_iteration()
                checksums.append(str(self.unitsync_wrapper.get_mod_checksum(i)))
                if self.mod_index.has_section(checksums[i]) == False:
                    self.mod_index.add_section(checksums[i])
                    self.mod_index.set(checksums[i], 'MOD_NAME', self.unitsync_wrapper.get_primary_mod_name(i))
                    mod_archive = self.unitsync_wrapper.get_primary_mod_archive(i)
                    self.mod_index.set(checksums[i], 'MOD_ARCHIVE', mod_archive)
                    sides = self.unitsync_wrapper.get_mod_sides(mod_archive)
                    self.mod_index.set(checksums[i], 'SIDE_COUNT', len(sides))
                    for p in range(0, len(sides)):
                        self.mod_index.set(checksums[i], 'SIDE_'+str(p+1), sides[p])
                    self.mod_index.write(open(self.mod_index_file, "w+"))
                    self.mod_index.read(self.mod_index_file)

            ## Check if need to remove mods
            index_checksums = self.mod_index.sections()
            remove_checksums = []
            for o in range(0,len(index_checksums)):
                self.status_icon_tooltip('Checking for Missing Mods: ' + str(((i+1) / float(len(index_checksums)))*100) + '%')
                while gtk.events_pending():
                    gtk.main_iteration()
                remove = True
                for p in range(0,len(checksums)):
                    if index_checksums[o] == checksums[p]:
                        remove = False
                        break
                if remove == True:
                    remove_checksums.append(index_checksums[o])

            ## Remove Mods
            for o in range(0,len(remove_checksums)):
                self.mod_index.remove_section(remove_checksums[o])

            self.mod_index.write(open(self.mod_index_file, "w+"))
            self.mod_index.read(self.mod_index_file)




class index_mod:

    def __init__(self, status_icon):

        self.status_icon_tooltip = status_icon.tooltip

        ## Unitsync Wrapper
        self.unitsync_wrapper = status_icon.unitsync_wrapper

        ## Mod Index Cache
        self.mod_index_file = status_icon.mod_index_file
        self.mod_index = ConfigParser.ConfigParser()
        self.mod_index.optionxform = lambda x: x
        self.mod_index.read(self.mod_index_file)	


    def create_index(self):
        dest_fd = open(self.mod_index_file,"w+")
        dest_fd.close()


    def check_if_update_needed(self):
        self.mod_count = self.unitsync_wrapper.get_mod_count()
        if self.mod_count != len(self.mod_index.sections()):
            self.rescan_index()


    def rescan_index(self):
        if self.mod_count != 0:
            index_scan = Mod_Index(self)
            index_scan.start()
            index_scan.join()
        else:
            self.create_index()


    def mod_archive(self, checksum):
        return self.mod_index.get(checksum, 'MOD_ARCHIVE')


    def mod_archive_name(self,checksum):
        return self.mod_index.get(checksum, 'MOD_NAME', None)


    def mod_archive_sides(self, checksum):
        sides_count = self.mod_index.getint(checksum, 'SIDE_COUNT')
        sides = []
        for i in range(1,sides_count+1):
            sides.append(self.mod_index.get(checksum, 'SIDE_'+ str(i)))
        return sides


    def list_checksums(self):
        self.mod_checksum_list = self.mod_index.sections()
        return self.mod_checksum_list