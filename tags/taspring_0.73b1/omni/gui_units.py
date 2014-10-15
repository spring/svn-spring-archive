# -*- coding: UTF-8 -*-

#======================================================
 #            gui_units.py
 #
 #  Sat July 23 18:07 2005
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

import os,wx,misc,socket

from GLOBAL import *

ID_BUTTON_DONE = 101

ID_TEXT_UNITLIMIT = 201

ID_CHECKBOX_DISABLED = 301
ID_CHECKBOX_LIMIT = 302

ID_LISTCTL_UNITLIST = 901


#======================================================================
#===========WARNING: Some code below has been modified!================
#======================================================================

# Always read the documentation carefully before updating code from the py.gen folder!

class gui_units(wx.Frame):

    images = None
    
    unit_names = ["Commander", "Construction KBot","Peewee", "Rocko", "Hammer", "Jethro", "Zipper", "Flea", "Construction Vehicle", "Jeffy", "Flash", "Stumpy", "Samson", "Podger Mine Layer", "Construction Aircraft", "Peeper", "Freedom Fighter", "Thunder Bomber", "Atlas Transport", "Tornado Seaplane"]
    unit_faction = ["Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm", "Arm"]
    unit_filenames = ["armcom-sm.png", "armck-sm.png", "armpw-sm.png", "armrock-sm.png", "armham-sm.png", "armjeth-sm.png", "armfast-sm.png", "armflea-sm.png", "armcv-sm.png", "armfav-sm.png", "armflash-sm.png", "armstump-sm.png", "armsam-sm.png", "armmlv-sm.png", "armca-sm.png", "armpeep-sm.png", "armfig-sm.png", "armthund-sm.png", "armatlas-sm.png", "armseap-sm.png"]
    unit_limits = ["None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None", "None"]
    
    building_names = []
        
    currentunit = 0
    limitchanged = 0
    
    
    def __init__(self, *args, **kwds):
        # begin wxGlade: gui_units.__init__
        kwds["style"] = wx.DEFAULT_FRAME_STYLE
        wx.Frame.__init__(self, *args, **kwds)
        self.label_units_currentName = wx.StaticText(self, -1, "Peewee")

    #===============================================================================
    # Added os.path.join() to make it so that Windows users can see the icons too!
        self.bitmap_units_currentPreview = wx.StaticBitmap(self, -1, wx.Bitmap(os.path.join("resource/","pewee.png"), wx.BITMAP_TYPE_ANY))
    # /end edits ===================================================================

        self.checkbox_units_disabled = wx.CheckBox(self, -1, "Disable Unit")
        self.checkbox_units_limit = wx.CheckBox(self, -1, "Unit Limit")
        self.text_units_limitData = wx.TextCtrl(self, -1, "")
        self.button_units_update = wx.Button(self, -1, "Update")
        self.button_units_done = wx.Button(self, -1, "Done")
        self.button_units_revertToDefaults = wx.Button(self, -1, "Defaults")
        self.list_units_unitList = wx.ListCtrl(self, -1, style=wx.LC_REPORT|wx.LC_SINGLE_SEL|wx.SUNKEN_BORDER)

        self.__set_properties()
        self.__do_layout()
        # end wxGlade

        self.__do_events()
        self.__do_init()


  #==========================================================================================================
  #==========================================================================================================
  #======================================BEGIN EVENTS========================================================
  #==========================================================================================================
  #==========================================================================================================


# __do_events() ====================================================================================
# ==================================================================================================
#  This function maps events to callback functions 
#  defined within this class. Note that ID's are 
#  only used for menu items for which they are necessary.
# ==================================================================================================
    def __do_events(self):
    	wx.EVT_CLOSE(self, self.OnClose)
    	
    	wx.EVT_BUTTON(self, self.button_units_done.GetId(), self.OnDone)
    	wx.EVT_BUTTON(self, self.button_units_update.GetId(), self.OnUpdateLimit)
    	wx.EVT_BUTTON(self, self.button_units_revertToDefaults.GetId(), self.OnDefaults)
    	
    	wx.EVT_LIST_ITEM_SELECTED(self, self.list_units_unitList.GetId(), self.OnListItemSelect)
    	
    	wx.EVT_CHECKBOX(self, self.checkbox_units_disabled.GetId(), self.OnDisableUnit)
    	wx.EVT_CHECKBOX(self, self.checkbox_units_limit.GetId(), self.OnLimit)
    	
    	wx.EVT_TEXT(self, self.text_units_limitData.GetId(), self.OnLimitChanged)
# /end __do_events() ===============================================================================




# OnClose() ========================================================================================
# ==================================================================================================
#  Needed for destroying the window when the user
#  hits the X in the corner.  If this event is not
#  implimented, when the gui_lobby window is closed, 
#  this window will become the new top window even 
#  though the user cannot see it.  

#  Destroying the top window in wxWidgets is the 
#  only way to end the program.
# ==================================================================================================
    def OnClose(self, event):
        self.Destroy()
# /end OnClose() ===================================================================================




# OnDone() =========================================================================================
# ==================================================================================================
#  This function is called when the user hits
#  the "done" button.

    def OnDone(self, event):
    	self.Close(True)
# /end OnDone() ====================================================================================




# OnListItemSelect() ===============================================================================
# ==================================================================================================
#  This function is called when the user selects
#  a list item from the list of units.  This updates
#  The picture and unit title in the rest of the dialog
#  and allows users to edit limits with particular units.
# ==================================================================================================
    def OnListItemSelect(self, event):
    
        self.UpdateCurrentLimit()
            
        preview = self.unit_filenames[event.GetIndex()].split("-")
        preview = preview[0] + ".png"
        
        self.label_units_currentName.SetLabel(self.unit_names[event.GetIndex()])
    	self.bitmap_units_currentPreview.SetBitmap(wx.Bitmap(os.path.join("resource/units/", preview), wx.BITMAP_TYPE_ANY))
    	
        if self.unit_limits[event.GetIndex()] == "None":
           self.checkbox_units_disabled.SetValue(False)
           
           self.checkbox_units_limit.Enable(True)
           self.checkbox_units_limit.SetValue(False)
           
           self.text_units_limitData.SetValue("")
           self.text_units_limitData.Enable(False)
           
        elif self.unit_limits[event.GetIndex()] == "0":
           self.checkbox_units_disabled.SetValue(True)
           
           self.checkbox_units_limit.SetValue(False)
           self.checkbox_units_limit.Enable(False)
           
           self.text_units_limitData.SetValue("")
           self.text_units_limitData.Enable(False)
           
        elif int(self.unit_limits[event.GetIndex()]) > 0:
           self.checkbox_units_disabled.SetValue(False)
           
           self.checkbox_units_limit.Enable(True)
           self.checkbox_units_limit.SetValue(True)
           
           self.text_units_limitData.SetValue(self.unit_limits[event.GetIndex()])
           self.text_units_limitData.Enable(True)
        
        self.currentunit = event.GetIndex()
    	   
# /end OnListItemSelect() ==========================================================================





# OnDisableUnit() ==================================================================================
# ==================================================================================================
#  This function is called when the user chooses
#  to disable a unit.

    def OnDisableUnit(self, event):
        if self.checkbox_units_disabled.GetValue():
            self.unit_limits[self.currentunit] = "0"
            
            self.checkbox_units_limit.SetValue(False)
            self.checkbox_units_limit.Enable(False)
            
            self.text_units_limitData.SetValue("")
            self.text_units_limitData.Enable(False)
            
            self.list_units_unitList.SetStringItem(self.currentunit, 3, "X")
            self.list_units_unitList.SetItemTextColour(self.currentunit, wx.Colour(100,100,100))
        else:
            self.unit_limits[self.currentunit] = "None"
            
            self.checkbox_units_limit.SetValue(False)
            self.checkbox_units_limit.Enable(True)
            
            self.text_units_limitData.SetValue("")
            self.text_units_limitData.Enable(False)
            
            self.list_units_unitList.SetStringItem(self.currentunit, 3, "None")
            self.list_units_unitList.SetItemTextColour(self.currentunit, wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
# /end OnDisableUnit() =============================================================================





# OnLimit() ========================================================================================
# ==================================================================================================
#  This function is called when the user wants 
#  to set a specific numeric limit on the current
#  unit.

    def OnLimit(self, event):
        if self.checkbox_units_limit.GetValue():
           self.text_units_limitData.SetValue("")
           self.text_units_limitData.Enable(True)
           
        else:
           self.text_units_limitData.SetValue("")
           self.text_units_limitData.Enable(False)
           
           self.unit_limits[self.currentunit] = "None"
           self.list_units_unitList.SetStringItem(self.currentunit, 3, self.unit_limits[self.currentunit])
           self.list_units_unitList.SetItemTextColour(self.currentunit, wx.SystemSettings_GetColour(wx.SYS_COLOUR_WINDOWTEXT))
# /end OnLimit() ===================================================================================





# OnLimitChanged() =================================================================================
# ==================================================================================================
#  This function is called when the user changes
#  the data in the limitData text control.

    def OnLimitChanged(self, event):
        if str.isdigit(str(self.text_units_limitData.GetValue())):
            self.limitchanged = 1
        else:
            self.text_units_limitData.Remove(len(self.text_units_limitData.GetValue()) - 1, len(self.text_units_limitData.GetValue()))
            
# /end OnLimitChanged() ============================================================================





# OnUpdateLimit() ==================================================================================
# ==================================================================================================
#  This function is called when the program needs
#  to update the limit data in the list control.

    def OnUpdateLimit(self, event):
        self.UpdateCurrentLimit()
# /end OnUpdateLimit() =============================================================================





# OnDefaults() =====================================================================================
# ==================================================================================================
#  This function is called when the program needs
#  to update the limit data in the list control.

    def OnDefaults(self, event):
        self.Defaults()
# /end OnUpdateLimit() =============================================================================






  #==========================================================================================================
  #==========================================================================================================
  #=========================================OTHER FUNCTIONS==================================================
  #==========================================================================================================
  #==========================================================================================================






# __do_init() ======================================================================================
# ==================================================================================================
#  Do other init that is not already done by the
#  wxGlade generated code.  This makes integrating the 
#  wxGlade code much easier (if it needs to change).

#  Initializes the wxConfig class to store and retrieve
#  data from files "portably".
# ==================================================================================================
    def __do_init(self):
        self.images = wx.ImageList(24, 24, False, 1)
        
        self.InitConfig()
        self.InitList()
# /end __do_init() =================================================================================






# InitList() =======================================================================================
# ==================================================================================================
#  Populates the list control with units and structures.

    def InitList(self):
    
        imageIterCount = 0
        listIterCount = 0
        
        while imageIterCount < len(self.unit_names) + len(self.building_names):
            self.images.Add(wx.Bitmap(os.path.join("resource/units/", self.unit_filenames[imageIterCount]), wx.BITMAP_TYPE_PNG))
            imageIterCount = imageIterCount + 1
            
        self.list_units_unitList.SetImageList(self.images, wx.IMAGE_LIST_SMALL)
        
        self.list_units_unitList.InsertColumn(0, "", wx.LIST_FORMAT_LEFT, 25)
        self.list_units_unitList.InsertColumn(1, "Faction", wx.LIST_FORMAT_CENTER, 50)
        self.list_units_unitList.InsertColumn(2, "Name", wx.LIST_FORMAT_LEFT, 150)
        self.list_units_unitList.InsertColumn(3, "Limits", wx.LIST_FORMAT_CENTER, 50)
        
        
        while listIterCount < len(self.unit_names) + len(self.building_names):
            self.list_units_unitList.InsertImageItem(listIterCount , listIterCount)
            self.list_units_unitList.SetStringItem(listIterCount, 1, self.unit_faction[listIterCount])
            self.list_units_unitList.SetStringItem(listIterCount, 2, self.unit_names[listIterCount])
            self.list_units_unitList.SetStringItem(listIterCount, 3, "None")
            listIterCount = listIterCount + 1
        
        self.list_units_unitList.SetItemState(0, wx.LIST_STATE_SELECTED, wx.LIST_STATE_SELECTED)
        self.currentunit = 0
# /end InitList() ==================================================================================







# UpdateCurrentLimit() =============================================================================
# ==================================================================================================
#  Updates the current unit limit in the list control.

    def UpdateCurrentLimit(self):
        if self.limitchanged == 1:
            if not self.text_units_limitData.GetValue() == "":
                self.unit_limits[self.currentunit] = self.text_units_limitData.GetValue()
                self.list_units_unitList.SetStringItem(self.currentunit, 3, self.unit_limits[self.currentunit])
                self.limitchanged = 0
# /end UpdateCurrentLimit() ========================================================================






# Defaults() =======================================================================================
# ==================================================================================================
#  Populates the list control with units and structures.

    def Defaults(self):
    
        listIterCount = 0
        
        while listIterCount < len(self.unit_names) + len(self.building_names):
            self.list_units_unitList.SetStringItem(listIterCount, 3, "None")
            self.list_units_unitList.SetItemTextColour(self.currentunit, wx.SystemSettings_GetColour())
            self.unit_limits[listIterCount] = "None"
            listIterCount = listIterCount + 1

        
        self.list_units_unitList.SetItemState(0, wx.LIST_STATE_SELECTED, wx.LIST_STATE_SELECTED)
        self.currentunit = 0
# /end Defaults() ==================================================================================






  #==========================================================================================================
  #==========================================================================================================
  #======================================WXCONFIG FUNCTIONS==================================================
  #==========================================================================================================
  #==========================================================================================================





# InitConfig() =====================================================================================
# ==================================================================================================
#  This function sets up the wxConfig class so that it can
#  be used by SpringClient.  All config initialization should
#  go here.
# ==================================================================================================
    def InitConfig(self):
        config = wx.Config().Get()

        # Write all changes to the file
        config.Flush()
# /end InitConfig() ================================================================================



# SaveConfig() =====================================================================================
# ==================================================================================================
#  This function saves the configuration settings that
#  need to be saved.  This is usually called when the
#  window is being destroyed.
# ==================================================================================================
    def SaveConfig(self):
        config = wx.Config.Get()

        config.Flush()	
# /end SaveConfig() ================================================================================




  #==========================================================================================================
  #==========================================================================================================
  #======================================WXGLADE FUNCTIONS===================================================
  #==========================================================================================================
  #==========================================================================================================




    def __set_properties(self):
        # begin wxGlade: gui_units.__set_properties
        self.SetTitle("Disabled Units")
        _icon = wx.EmptyIcon()

    #===============================================================================
    # Added os.path.join() and added os.name to get Windows Icons to work!
        if os.name == "posix":
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.png"), wx.BITMAP_TYPE_PNG)
        else:
            _icon.LoadFile(os.path.join("resource/","spring-redlogo.ico"), wx.BITMAP_TYPE_ICO)
    # /end edits ===================================================================

        self.SetIcon(_icon)
        self.label_units_currentName.SetFont(wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.BOLD, 0, ""))
        self.text_units_limitData.SetSize((80, 25))
        self.text_units_limitData.Enable(False)
        self.button_units_update.SetSize((100, 30))
        self.button_units_update.SetFont(wx.Font(10, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.button_units_update.SetDefault()
        self.button_units_revertToDefaults.SetSize((70, 30))
        self.button_units_revertToDefaults.SetFont(wx.Font(8, wx.DEFAULT, wx.NORMAL, wx.NORMAL, 0, "Sans"))
        self.list_units_unitList.SetSize((300, 285))
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: gui_units.__do_layout
        grid_sizer_1 = wx.FlexGridSizer(3, 5, 0, 0)
        grid_units_info = wx.FlexGridSizer(12, 1, 0, 0)
        sizer_1 = wx.BoxSizer(wx.HORIZONTAL)
        sizer_7 = wx.BoxSizer(wx.HORIZONTAL)
        grid_sizer_1.Add((15, 15), 0, 0, 0)
        grid_sizer_1.Add((130, 15), 0, 0, 0)
        grid_sizer_1.Add((15, 15), 0, 0, 0)
        grid_sizer_1.Add((210, 15), 0, 0, 0)
        grid_sizer_1.Add((15, 15), 0, 0, 0)
        grid_sizer_1.Add((15, 200), 0, 0, 0)
        grid_units_info.Add(self.label_units_currentName, 0, 0, 0)
        grid_units_info.Add((100, 15), 0, 0, 0)
        grid_units_info.Add(self.bitmap_units_currentPreview, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_units_info.Add((100, 15), 0, 0, 0)
        grid_units_info.Add(self.checkbox_units_disabled, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        grid_units_info.Add((100, 15), 0, 0, 0)
        sizer_7.Add(self.checkbox_units_limit, 0, wx.EXPAND|wx.ALIGN_CENTER_VERTICAL, 0)
        sizer_7.Add((5, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_7.Add(self.text_units_limitData, 0, wx.FIXED_MINSIZE, 0)
        grid_units_info.Add(sizer_7, 1, wx.EXPAND, 0)
        grid_units_info.Add((100, 7), 0, 0, 0)
        grid_units_info.Add(self.button_units_update, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.FIXED_MINSIZE, 0)
        grid_units_info.Add((100, 15), 0, 0, 0)
        sizer_1.Add(self.button_units_done, 0, wx.ALIGN_CENTER_HORIZONTAL, 0)
        sizer_1.Add((20, 20), 0, wx.FIXED_MINSIZE, 0)
        sizer_1.Add(self.button_units_revertToDefaults, 0, wx.FIXED_MINSIZE, 0)
        grid_units_info.Add(sizer_1, 1, wx.EXPAND, 0)
        grid_sizer_1.Add(grid_units_info, 1, wx.EXPAND, 0)
        grid_sizer_1.Add((15, 200), 0, 0, 0)
        grid_sizer_1.Add(self.list_units_unitList, 1, wx.FIXED_MINSIZE, 0)
        grid_sizer_1.Add((15, 200), 0, 0, 0)
        grid_sizer_1.Add((15, 15), 0, 0, 0)
        grid_sizer_1.Add((130, 15), 0, 0, 0)
        grid_sizer_1.Add((15, 15), 0, 0, 0)
        grid_sizer_1.Add((210, 15), 0, 0, 0)
        grid_sizer_1.Add((15, 15), 0, 0, 0)
        self.SetAutoLayout(True)
        self.SetSizer(grid_sizer_1)
        grid_sizer_1.Fit(self)
        grid_sizer_1.SetSizeHints(self)
        self.Layout()
        self.Centre()
        # end wxGlade
        
       
# end of class gui_units


