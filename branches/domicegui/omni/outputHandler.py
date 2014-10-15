#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            outputHandler.py
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

class outputHandler:

    color_debug_text = None
    color_error_text = None
    color_server_text = None
    color_channel_text = None
    color_user_text = None
    color_private_text = None
    color_red_text = None
    color_blue_text = None
    color_orange_text = None
    color_green_text = None

    
    
    parent_window = None
    

# __init__() =======================================================================================
# ==================================================================================================
#  The function that initializes the output class.
#  This class is primarily used for classifying and
#  displaying information passed to it.
# ==================================================================================================
    def __init__(self, parent):
    
        # Initialize variables
   
        self.parent_window = parent
        
        self.color_debug_text = self.parent_window.color_debug_text
        self.color_error_text = self.parent_window.color_error_text
        self.color_server_text = self.parent_window.color_server_text
        self.color_channel_text = self.parent_window.color_channel_text
        self.color_user_text = self.parent_window.color_user_text
        self.color_private_text = self.parent_window.color_private_text
        self.color_red_text = wx.Colour(255,0,0)
        self.color_blue_text = wx.Colour(0,0,255)
        self.color_orange_text = wx.Colour(255,127,0)
        self.color_green_text = wx.Colour(0,124,0)
            
        
# /end __init__() ==================================================================================
   
   
   
   
   
# output() =========================================================================================
# ==================================================================================================
#  Outputs a debug message of a certain priority to the main
#  window, the console, a message box, or a combination of
#  the three.

    def output(self, msg, priority, target=0):
    
        config = wx.Config().Get()
        
        
        if target == 0:
            chat_area = self.parent_window.tabManager.GetCurrentChatArea()
        elif target == -1:
            chat_area = self.parent_window.battleroom.text_battleroom_players_chatarea
        else:
            chat_area = self.parent_window.tabManager.GetCurrentChatArea(target)
        
        if chat_area == None:
            return False
            
        
        if priority == DEBUG_ERROR:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_error_text))
        elif priority == ERROR_MSG:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_error_text))
        elif priority == DEBUG_MESSAGE:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_debug_text))
        elif priority == SERVER_HIGH:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_server_text))
        elif priority == SERVER_OTHER:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_server_text))
        elif priority == CHANNEL_MSG:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_channel_text))
        elif priority == USER_MSG:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_user_text))
        elif priority == PRIVATE_MSG:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_private_text))
        elif priority == OTHER_MSG:
            chat_area.SetDefaultStyle(wx.TextAttr(self.color_channel_text))
                
        if msg.find("^") != -1:
            msg_parsed = msg.split("^")
            increment = 1
            
            if msg_parsed[0] != "":
                if priority == DEBUG_ERROR:
                    chat_area.AppendText(msg_parsed[0])
                    print(msg)
                elif priority == ERROR_MSG:
                    chat_area.AppendText(msg_parsed[0])
                elif priority == DEBUG_MESSAGE:
                    if config.ReadBool("/Global/ShowDebug") == True:
                        chat_area.AppendText(msg_parsed[0])
                        print(msg)
                    else:
                        print(msg)
                elif priority == SERVER_HIGH:
                    chat_area.AppendText(msg_parsed[0])
                    print(msg)
                elif priority == SERVER_OTHER:
                    chat_area.AppendText(msg_parsed[0])
                elif priority == SERVER_USELESS:
                    if config.ReadBool("/Global/ShowDebug") == True:
                        print(msg)
                    return True
                elif priority == DEBUG_USELESS:
                    if config.ReadBool("/Global/ShowDebug") == True:
                        print(msg)    
                    return True
                elif priority == CHANNEL_MSG:
                    chat_area.AppendText(msg_parsed[0])
                elif priority == USER_MSG:
                    chat_area.AppendText(msg_parsed[0])
                elif priority == PRIVATE_MSG:
                    chat_area.AppendText(msg_parsed[0])
                elif priority == OTHER_MSG:
                    chat_area.AppendText(msg_parsed[0])
                
            while len(msg_parsed) > increment:
                tmp_str = msg_parsed[increment]
                noColor = False
                
                if tmp_str != "":
                
                    if tmp_str[0] == str(COLOR_MACRO_CHANNEL):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_channel_text))
                    elif tmp_str[0] == str(COLOR_MACRO_USER):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_user_text))
                    elif tmp_str[0] == str(COLOR_MACRO_PRIVATE):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_private_text))
                    elif tmp_str[0] == str(COLOR_MACRO_SERVER):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_server_text))
                    elif tmp_str[0] == str(COLOR_MACRO_ERROR):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_error_text))
                    elif tmp_str[0] == str(COLOR_MACRO_DEBUG):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_debug_text))
                    elif tmp_str[0] == str(COLOR_MACRO_RED):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_red_text))
                    elif tmp_str[0] == str(COLOR_MACRO_ORANGE):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_orange_text))
                    elif tmp_str[0] == str(COLOR_MACRO_BLUE):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_blue_text))
                    elif tmp_str[0] == str(COLOR_MACRO_GREEN):
                        chat_area.SetDefaultStyle(wx.TextAttr(self.color_green_text))
                    else:
                        tmp_str = "^" + tmp_str
                        noColor = True
                        
                    if len(msg_parsed) == increment + 1:
                        if noColor == False:
                            chat_area.AppendText(tmp_str[1:] + "\n")
                        else:
                            chat_area.AppendText(tmp_str + "\n")
                    else:
                        if noColor == False:
                            chat_area.AppendText(tmp_str[1:])
                        else:
                            chat_area.AppendText(tmp_str)
                        
                else:
                
                    tmp_str = "^" + tmp_str
                    noColor = True
                    
                    if len(msg_parsed) == increment + 1:
                        chat_area.AppendText(tmp_str + "\n")
                    else:
                        chat_area.AppendText(tmp_str)
                        
                increment += 1

        else:

            if priority == DEBUG_CRITICAL:
                misc.CreateMessageBox(self.parent_window, MSGBOX_CRITICAL_ERROR , str(msg))
                print(msg)
            elif priority == DEBUG_ERROR:
                chat_area.AppendText(msg + "\n")
                print(msg)
            elif priority == ERROR_MSG:
                chat_area.AppendText(msg + "\n")
            elif priority == DEBUG_MESSAGE:
                if config.ReadBool("/Global/ShowDebug") == True:
                    chat_area.AppendText(msg + "\n")
                    print(msg)
                else:
                    print(msg)
            elif priority == DEBUG_USELESS:
                if config.ReadBool("/Global/ShowDebug") == True:
                    print(msg)
            elif priority == SERVER_HIGH:
                chat_area.AppendText(msg + "\n")
                print(msg)
            elif priority == SERVER_LOW:
                print(msg)
            elif priority == SERVER_OTHER:
                chat_area.AppendText(msg + "\n")
            elif priority == SERVER_USELESS:
                if config.ReadBool("/Global/ShowDebug") == True:
                    print(msg)
            elif priority == CHANNEL_MSG:
                chat_area.AppendText(msg + "\n")
            elif priority == USER_MSG:
                chat_area.AppendText(msg + "\n")
            elif priority == PRIVATE_MSG:
                chat_area.AppendText(msg + "\n")
            elif priority == OTHER_MSG:
                chat_area.AppendText(msg + "\n")
        
# /end output() =====================================================================================


