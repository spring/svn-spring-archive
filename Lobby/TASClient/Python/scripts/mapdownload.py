import lobbyscript

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

oldParent = dict()

joiningBattleId = -1
acceptNextDownload = False
startDownload = False
dlFormName = ''
dlFailed = False

def changeComponentProp(comp,prop,value):
	changeComponentPropFull(comp,'',prop,value)
	
def changeComponentPropFull(comp,path,prop,value):
	p = dict()
	p[prop] = value
	return gui.SetControlProperties(comp,path,p)
	
def out_JOINBATTLE(args):
	if gui.GetControlProperties(dlFormName,'') != None:
		gui.ExecMethod(dlFormName,'CancelButtonClick',())
	
def onDownloadProgress(progress):
	global dlFormName
	global dlFailed
	global oldParent
	if progress == -2:
		if gui.GetControlProperties(dlFormName,'') != None:
			p = gui.GetControlProperties(dlFormName+'.lblInfo','')
			changeComponentProp(dlFormName+'.lblProgress','Caption',p['Caption'])
			p = gui.GetControlProperties(dlFormName+'.lblInfo','Font')
			changeComponentPropFull(dlFormName+'.lblProgress','Font','Color',p['Color'])
			dlFailed = True
	if progress == -1 or progress == -3:
		for control in oldParent:
			changeComponentProp(control,'Parent',oldParent[control])
		oldParent = dict()
		changeComponentProp('BattleForm.MapDescLabel','Visible','True')
		dlFormName = ''
	return False
		
def all_in(args):
	global startDownload
	global dlFailed
	if startDownload and joiningBattleId > -1:
		battles = api.GetBattles()
		dlFailed = False
		api.DownloadMap2(battles[joiningBattleId]['Map'],(),onDownloadProgress)
		startDownload = False
		
def in_JOINBATTLE(id,args):
	global joiningBattleId
	joiningBattleId = int(id)
	
def in_LEFTBATTLE(id,nick):
	global joiningBattleId
	if nick == api.GetMyUser()['Name']:
		joiningBattleId = -1
	
def onDownloadMapStart(formName,mapHash,mapName):
	global acceptNextDownload
	global startDownload
	global dlFormName
	global joiningBattleId
	battles = api.GetBattles()
	if battles != None and (acceptNextDownload or (joiningBattleId > -1 and battles[joiningBattleId]['Map'] == mapName)):
		if acceptNextDownload:
			changeComponentProp('BattleForm.MapDescLabel','Visible','False')		
			
			p = gui.GetControlProperties(formName+'.ProgressBar','')
			oldParent[formName+'.ProgressBar'] = p['Parent']
			changeComponentProp(formName+'.ProgressBar','Parent','BattleForm.SpTBXPanel3')
			changeComponentProp(formName+'.ProgressBar','Height','20')
			changeComponentProp(formName+'.ProgressBar','Align','alBottom')
			
			p = gui.GetControlProperties(formName+'.lblProgress','')
			oldParent[formName+'.lblProgress'] = p['Parent']
			changeComponentProp(formName+'.lblProgress','Parent','BattleForm.SpTBXPanel3')
			changeComponentProp(formName+'.lblProgress','Align','alLeft')
			
			p = gui.GetControlProperties(formName+'.CancelButton','')
			oldParent[formName+'.CancelButton'] = p['Parent']
			changeComponentProp(formName+'.CancelButton','Parent','BattleForm.SpTBXPanel3')
			changeComponentProp(formName+'.CancelButton','Align','alRight')

			dlFormName = formName
			acceptNextDownload = False
			return False
		else:
			acceptNextDownload = True
			startDownload = True
			if dlFormName != '':
				for control in oldParent:
					changeComponentProp(control,'Parent',oldParent[control])
				changeComponentProp('BattleForm.MapDescLabel','Visible','True')
				dlFormName = ''
			return True
