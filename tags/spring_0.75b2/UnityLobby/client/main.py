#!/usr/bin/env python

#======================================================
 #            main.py
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
import os
import sys
import ConfigParser

from optparse import OptionParser


# Custom Modules
from Battle import Battle
from Config import config
from GUI_Lobby import gui_lobby

from Map_Index import index_map
from Mod_Index import index_mod
from unitsync_wrapper import unitsync_wrapper


class status_icon:

    def __init__(self, profile):

        gtk.gdk.threads_init()

        ### Initialise Variables
        self.windows = ({'Battle':False, 'Lobby':False, 'Options':False})
        self.updating = False
        self.profile = profile

        ## Platform
        self.platform = sys.platform
        if self.platform != 'win32':
            ## Linux
            HOME = os.environ['HOME']
            self.profile_dir = os.path.join(HOME, '.unity-lobby', 'profiles', profile)
            self.ini_file = os.path.join(HOME, '.unity-lobby', 'profiles', 'setup.ini')
        else:
            ## Windows
            APPDATA = os.environ['APPDATA']
            self.setup_dir = os.path.join(APPDATA, 'unity-lobby', 'profiles', profile)
            self.ini_file = os.path.join(APPDATA, 'unity-lobby', 'profiles', 'setup.ini')

        ## Unity Conf
        self.ini = ConfigParser.ConfigParser()
        self.ini.optionxform = lambda x: x
        self.ini.read(self.ini_file)

        ## Lobby Conf
        self.lobby_ini_file = self.ini.get(self.profile, 'LOBBY_CONF')
        self.lobby_ini = ConfigParser.ConfigParser()
        self.lobby_ini.optionxform = lambda x: x
        self.lobby_ini.read(self.lobby_ini_file)

        ## Unitsync Wrapper
        self.unitsync_wrapper = unitsync_wrapper(self.ini.get(self.profile, 'SPRING_DATADIR', None))

        ## Unitsync Cache files
        self.map_index_file = self.ini.get(self.profile, 'MAP_INDEX')
        self.mod_index_file = self.ini.get(self.profile, 'MOD_INDEX')

        ## UnityLobby Location
        self.unity_location = self.ini.get(self.profile, 'UNITY_INSTALL_DIR')

        ## Register Custom Stock Images
        bot_image_location = os.path.join(self.unity_location, 'resources', 'status', 'bot.svg')
        insync_location = os.path.join(self.unity_location, 'resources', 'sync', 'sync1.png')
        unknownsync_location = os.path.join(self.unity_location, 'resources', 'sync', 'sync2.png')
        outofsync_location = os.path.join(self.unity_location, 'resources', 'sync', 'sync3.png')

        self.register_iconsets([('unitylobby-bot', bot_image_location), ('unitylobby-in-sync', insync_location),  ('unitylobby-unknown-sync', unknownsync_location), ('unitylobby-outof-sync', outofsync_location)])


    def create(self):
        self.status_icon = gtk.StatusIcon()
        self.spring_logo_pixbuf = gtk.gdk.pixbuf_new_from_file(self.ini.get(self.profile, 'DOCKAPP', None))
        self.status_icon.set_from_file(self.ini.get(self.profile, 'DOCKAPP', None))
        self.status_icon.set_visible(True)


        self.map_index = index_map(self)
        self.map_index.check_if_update_needed()

        ## Mod Index
        self.mod_index = index_mod(self)
        self.mod_index.check_if_update_needed()

        ## Datadirs
        datadirs = self.unitsync_wrapper.datadirs_list()
        self.datadirs = []
        for i in range(0,len(datadirs)):
            if os.path.isdir(datadirs[i]) == True:
                self.datadirs.append(datadirs[i])

        ## Classes
        self.battle = Battle(self)
        self.lobby = gui_lobby(self)
        self.options = config(self)
        
        self.battle.integrate_with_lobby(self)
        self.battle.integrate_with_options(self)        
        self.lobby.IntegrateWithBattle(self)

        self.lobby.Create()
        self.battle.create()        
        self.options.create()

        self.tooltip('Unity Lobby')
        self.blinking(True)
        self.status_icon.connect('activate', self.active)
        self.status_icon.connect('popup-menu', self.popup_menu)


    def tooltip(self, text):
        self.status_icon.set_tooltip(text)


    def active(self, status_icon):
        self.blinking(False)


    def blinking(self, boolean):
        self.status_icon.set_blinking(boolean)


    def popup_menu(self, status_icon, button, activate_time):
        if self.updating == False:
            self.blinking(False)

            menu = gtk.Menu()
            battle_item = gtk.MenuItem("Battle")
            lobby_item = gtk.MenuItem("Lobby")
            options_item = gtk.MenuItem("Options")
            close_item = gtk.MenuItem("Close")

            battle_item.connect("button_press_event", self.battle_show)
            lobby_item.connect("button_press_event", self.lobby_show)
            options_item.connect("button_press_event", self.options_show)
            close_item.connect("button_press_event", self.close)

            menu.append(battle_item)
            menu.append(lobby_item)
            menu.append(options_item)
            menu.append(close_item)

            menu.show_all()
            menu.popup(None, None, None, button, activate_time)


    def battle_show(self, menu_item, event):
        if self.windows['Battle'] == False:
            self.windows['Battle'] == True
            self.battle.show()
        else:
            self.windows['Battle'] == False
            self.battle.hide()


    def lobby_show(self, menu_item, event):
        if self.windows['Lobby'] == False:
            self.windows['Lobby'] == True
            self.lobby.Show()
        else:
            self.windows['Lobby'] == False
            self.lobby.Hide()


    def options_show(self, menu_item, event):
        if self.windows['Options'] == False:
            self.windows['Options'] == True
            self.options.show()
        else:
            self.windows['Options'] == False
            self.options.hide()


    def close(self, menu_item, event):
        gtk.main_quit()


    def main(self):
        gtk.gdk.threads_enter()
        self.create()
        gtk.main()
        gtk.gdk.threads_leave()


    def register_iconsets(self, icon_info):
        iconfactory = gtk.IconFactory()
        stock_ids = gtk.stock_list_ids()
        for stock_id, file in icon_info:
            ## only load image files when our stock_id is not present
            if stock_id not in stock_ids:
                pixbuf = gtk.gdk.pixbuf_new_from_file(file)
                iconset = gtk.IconSet(pixbuf)
                iconfactory.add(stock_id, iconset)
                iconfactory.add_default()

if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option("-p", "--profile", action="store", type="string", dest="profile", default=None, help="Internal Use Only -> Start Profile")
    (options, args) = parser.parse_args()

    platform = sys.platform
    status_icon = status_icon(options.profile)
    status_icon.main()