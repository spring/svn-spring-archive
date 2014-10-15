#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            debugHandler.py
 #
 #  Sat Sept 20 18:07 2005
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

import os,wx,misc

from GLOBAL import *

class debugHandler:

    parent_window = None
    outputHandler = None
    

# __init__() =======================================================================================
# ==================================================================================================
#  The function that initializes the debug output class.
#  This class is responsible for outputting debug and
#  error messages to their correct places.
# ==================================================================================================
    def __init__(self, parent, output):
    
        # Initialize variables
        self.parent_window = parent
        self.outputHandler = output

        
# /end __init__() ==================================================================================
   
   
   
   
   
# output() =========================================================================================
# ==================================================================================================
#  Outputs a debug message of a certain priority to the main
#  window, the console, a message box, or a combination of
#  the three.

    def output(self, msg, priority):
        self.outputHandler.output(msg, priority)
        #put logging stuff here
        

        
# /end output() =====================================================================================


