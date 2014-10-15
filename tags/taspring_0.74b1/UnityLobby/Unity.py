#!/usr/bin/env python

#======================================================
 #            Unity.py
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

import sys
import os
from gtk import gtk_version, pygtk_version

from optparse import OptionParser

if __name__ == "__main__":
	if (gtk_version >= (2, 10, 0) and pygtk_version >= (2, 10, 0)):
		parser = OptionParser()
		parser.add_option("-s", "--profile-selection", action="store_true", dest="profile_selection", default=False, help="Startup Profile Setup")
		(options, args) = parser.parse_args()

		home = os.environ['HOME']
		global_install = os.path.join(sys.path[0], 'Profile.py')
		user_install = os.path.join(home, 'Profile.py')
		if os.path.isfile(user_install):
			unity = user_install
		else:
			unity = global_install
		if options.profile_selection == True:
			os.spawnlp(os.P_NOWAIT, unity, unity, '-s')
		else:
			os.spawnlp(os.P_NOWAIT, unity, unity)
	else:
		print "Error: UnityLobby requires at least GTK v2.10.0 and PyGTK v2.10.0, your versions of GTK and PyGTK are", gtk_version, " and ", pygtk_version 


