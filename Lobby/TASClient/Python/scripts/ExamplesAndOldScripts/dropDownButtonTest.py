import lobbyscript

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

def changeComponentProp(comp,prop,value):
  p = gui.GetControlProperties(comp,'')
  p[prop] = value
  return gui.SetControlProperties(comp,'',p)

def _init():
  gui.AddDropDownButton('Quick host','OptsBt','OptsMenu','MainForm.Panel4')
  gui.AddItemToMenu('MainForm.Panel4.OptsMenu','Host Latest BA 6v6',(),'test','onHostBA6v6')
  gui.AddItemToMenu('MainForm.Panel4.OptsMenu','Host Latest BA 8v8',(),'test','onHostBA8v8')
  
  gui.AddDropDownButton('Single Item','ScTestBt','ScTestMnu','MainForm.Panel4')
  gui.AddItemToMenu('MainForm.Panel4.ScTestMnu','Only one item hidden',(),'test','onTest')
  
  changeComponentProp('MainForm.Panel4.OptsBt','Top',8)
  changeComponentProp('MainForm.Panel4.ScTestBt','Top',8)
  
  changeComponentProp('MainForm.Panel4.OptsBt','Left',500)
  changeComponentProp('MainForm.Panel4.ScTestBt','Left',588)
  
def onTest(id):
	print 'test '+str(id)
  
def onHostBA6v6(id):
  mods = api.GetMods()
  
  baList = list()
  
  for modName in mods:
    if modName.find('Balanced Annihilation') != -1:
        baList.append(modName)
  
  baList.sort()
  
  api.HostBattle(12,4,baList[len(baList)-1],'Quick start hoster','',8452,0)
  
def onHostBA8v8(id):
  mods = api.GetMods()
  
  baList = list()
  
  for modName in mods:
    if modName.find('Balanced Annihilation') != -1:
        baList.append(modName)
  
  baList.sort()
  
  api.HostBattle(16,4,baList[len(baList)-1],'Quick start hoster','',8452,0)
  