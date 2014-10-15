#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            resizePNG.py
 #
 #  Sat July 24 17:16 2005
 #  Copyright  2005  Josh Mattila
 #
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

# This program effectively batch converts many images into PNG format using the convertToPNG script...

import os
import sys

itercount = 0

print(len(sys.argv) - 1)

while itercount < len(sys.argv) - 1:
    tmpvar = sys.argv[itercount+1].split(".")
    cmd = "gimp -c -i -d -b \"(resizePNG \\\"" + str(sys.argv[itercount + 1]) + "\\\" \\\"" + str.lower(tmpvar[0]) + '-sm.png\\\" 0.25)\"' + '\"(gimp-quit 0)\"'
    os.popen2(cmd)
    itercount  = itercount + 1
    
#os.popen2("killall -9 gimp && killall -9 script-fu")

