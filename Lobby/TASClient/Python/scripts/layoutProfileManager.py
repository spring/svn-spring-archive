import lobbyscript
import sys, os

basepath = sys.path[1]
layoutsDirectory = 'layoutScripts'
sys.path.insert(1, os.path.join(basepath, layoutsDirectory))

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

layoutProfiles = {}

menuIdList = dict()
stackMenuIdList = dict()

defaultLayoutItemId = 0
loadedLayout = []

settingsFile = 'layoutSettings.txt'

def saveSettings():
	file = open(os.path.join(sys.path[0],'..','scripts',settingsFile), 'w')
	for layoutName in loadedLayout:
		file.write(layoutName+'\n')
	file.close()
	
def readSettings():
	global loadedLayout
	if os.path.isfile(os.path.join(sys.path[0],'..','scripts',settingsFile)):
		loadedLayout = []
		file = open(os.path.join(sys.path[0],'..','scripts',settingsFile), 'r')
		for line in file.readlines():
			line = line.replace('\n','')
			if line != '':
				loadedLayout.append(line)
		file.close()


def _loadprofiles():
	print 'Loading layout profiles:',
	new = []
	for s in os.listdir(os.path.join(basepath, layoutsDirectory)):
		if not s.endswith('.py'): continue
		s = os.path.split(s)[-1].rsplit('.py',1)[0]
		if not s in layoutProfiles:
			script = __import__(s)
			layoutProfiles[s] = script
			new.append(s)
	print ', '.join(new)
	print
	return new

def _reloadallprofiles():
	print 'Reloading layout profiles: ',
	reloaded = []
	for s in dict(layoutProfiles):
		script = layoutProfiles[s]
		result = _reloadprofile(s)
		reloaded.append(result)
	print ', '.join(reloaded)
	return reloaded

def _reloadprofile(s):
	script = layoutProfiles[s]
	for a in dir(script):
		if not a.startswith('__') or not a.endswith('__'):
			exec 'del script.%s' % a # extremely hackish and will turn out something like 2.5 seconds slower
									 # in 1 million runs than deleting directly... oh well :)
	try:
		reload(script)
	except ImportError:
		del layoutProfiles[s]
		return '-%s' % s
	return s

def changeComponentProp(comp,prop,subProp,value):
	p = gui.GetControlProperties(comp,prop)
	p[subProp] = value
	return gui.SetControlProperties(comp,prop,p)

def _init():
	global menuIdList
	global stackMenuIdList
	global defaultLayoutItemId
	global loadedLayout
	global LayoutMenuId
	global StackLayoutMenu
	
	_loadprofiles()
	readSettings()
	
	LayoutMenuId = gui.AddSubmenuToMenu('Options','ScriptLayoutsSubMenu','Script layouts')
	
	#add the refresh list button to the menu
	gui.AddItemToMenu2((),onRefreshList,LayoutMenuId,'mnuScriptLayoutsRefresh','Refresh list')
	StackLayoutMenu = gui.AddSubmenuToMenu(str(LayoutMenuId),'ScriptLayoutsStackSubMenu','Stack layout')
	r = gui.AddSeparatorToMenu(str(LayoutMenuId),'ScriptLayoutsSeparator')
	
	#add the default layout to the menu
	defaultLayoutItemId = gui.AddItemToMenu2((),onDefaultClick,str(LayoutMenuId),'mnuScriptLayoutDefault','default')
	if len(loadedLayout) == 0:
		gui.SetMenuItemState(defaultLayoutItemId,True,True)
	
	#add the layout to the menus
	i = 1
	for name in layoutProfiles:
		menuIdList[name] = gui.AddItemToMenu2((name,),onLayoutClick,str(LayoutMenuId),'mnuScriptLayout'+str(i),name)
		stackMenuIdList[name] = gui.AddItemToMenu2((name,),onStackLayoutClick,str(StackLayoutMenu),'mnuScriptLayoutStack'+str(i),name)
		if len(loadedLayout) > 0 and name in loadedLayout:
			gui.SetMenuItemState(menuIdList[name],True,True)
		i += 1
		
	#load the settings' layout
	if len(loadedLayout) > 0:
		layoutsNotFound = []
		for layoutName in loadedLayout:
			if layoutName in layoutProfiles:
				layout = layoutProfiles[layoutName]
				layout.loadLayout()
			else:
				loadedLayout.remove(layoutName)

def UnloadLayouts():
	global loadedLayout
	for layoutName in loadedLayout:
		layout = layoutProfiles[layoutName]
		layout.unloadLayout()
	loadedLayout = []
	
def onRefreshList(id):
	global loadedLayout
	global menuIdList
	global defaultLayoutItemId
	global LayoutMenuId
	global StackLayoutMenu
	
	UnloadLayouts()
	gui.SetMenuItemState(defaultLayoutItemId,True,True)
	for menuName in menuIdList:
		gui.SetMenuItemState(menuIdList[menuName],False,True)
		
	_reloadallprofiles()
	_loadprofiles()
	
	# clear the menu list
	for name in menuIdList:
		gui.RemoveFromMenu(menuIdList[name])
		gui.RemoveFromMenu(stackMenuIdList[name])
		
	menuIdList = dict()
	
	# reload the menu list
	i = 1
	for name in layoutProfiles:
		menuIdList[name] = gui.AddItemToMenu2((name,),onLayoutClick,str(LayoutMenuId),'mnuScriptLayout'+str(i),name)
		stackMenuIdList[name] = gui.AddItemToMenu2((name,),onStackLayoutClick,str(StackLayoutMenu),'mnuScriptLayoutStack'+str(i),name)
		i += 1

def onClose():
	for layoutName in loadedLayout:
		layout = layoutProfiles[layoutName]
		if 'saveLayoutSettings' in dir(layout):
			function = layout.saveLayoutSettings
			if type(function) == type(onClose):
				layoutProfiles[layoutName].saveLayoutSettings()
	
def onDefaultClick(id):
	global loadedLayout
	
	if loadedLayout != '':
		UnloadLayouts()
		saveSettings()
		for menuName in menuIdList:
			gui.SetMenuItemState(menuIdList[menuName],False,True)
		gui.SetMenuItemState(defaultLayoutItemId,True,True)
		
  
def onLayoutClick(id,name):
	global loadedLayout
	
	if len(loadedLayout) > 0:
		UnloadLayouts()
	
	layout = layoutProfiles[name]
	layout.loadLayout()
	loadedLayout.append(name)
	saveSettings()
	for menuName in menuIdList:
		gui.SetMenuItemState(menuIdList[menuName],False,True)
	gui.SetMenuItemState(menuIdList[name],True,True)
	gui.SetMenuItemState(defaultLayoutItemId,False,True)
	
def onStackLayoutClick(id,name):
	global loadedLayout
	
	layout = layoutProfiles[name]
	layout.loadLayout()
	loadedLayout.append(name)
	gui.SetMenuItemState(menuIdList[name],True,True)
	saveSettings()

  