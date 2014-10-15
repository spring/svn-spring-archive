import lobbyscript
import datetime

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

autoUnspecEnabled = False
myName = ''
oldNbPlayer = 0
currentBattleId = -1
lastUnspecSent = datetime.datetime.now()
maxUnspecInterval = datetime.timedelta(seconds=3)
retryNextTime = False

def onChkAutoSpecClick(sender):
	global autoUnspecEnabled
	global lastUnspecSent
	autoUnspecEnabled = gui.GetControlProperties('BattleForm.MyOptionsGroupBox.chkAutoUnspec','')['Checked'] == 'True'
	if autoUnspecEnabled:
		api.SetMyBattleStatus(False) # in case there is already a slot available
		lastUnspecSent = datetime.datetime.now()

def _init():
	specChkBoxProp = gui.GetControlProperties('BattleForm.SpectateCheckBox','')
	gui.AddControl('chkAutoUnspec','BattleForm.MyOptionsGroupBox','TSpTBXCheckBox')
	chkAutoUnspecProp = dict()
	chkAutoUnspecProp['Checked'] = 'False'
	chkAutoUnspecProp['Left'] = specChkBoxProp['Left']+specChkBoxProp['Width']+4
	chkAutoUnspecProp['Top'] = specChkBoxProp['Top']
	chkAutoUnspecProp['Caption'] = 'Auto unspec'
	chkAutoUnspecProp['Enabled'] = False
	chkAutoUnspecProp['Visible'] = True
	gui.SetControlProperties('BattleForm.MyOptionsGroupBox.chkAutoUnspec','',chkAutoUnspecProp)
	gui.AddEvent2('BattleForm.MyOptionsGroupBox.chkAutoUnspec','OnClick',onChkAutoSpecClick)

def out_LOGIN(userName, infos):
	global myName
	myName = userName
	
def in_JOINBATTLE(battleid,infos):
	global oldNbPlayer
	global currentBattleId
	currentBattleId = int(battleid)
	oldNbPlayer = 0
	gui.SetControlProperties('BattleForm.MyOptionsGroupBox.chkAutoUnspec','',{'Enabled':True, 'Checked':False})
		
def out_LEAVEBATTLE():
	global currentBattleId
	global autoUnspecEnabled
	currentBattleId = -1
	autoUnspecEnabled = False
	gui.SetControlProperties('BattleForm.MyOptionsGroupBox.chkAutoUnspec','',{'Checked':False})
	
def onDisconnect():
	gui.SetControlProperties('BattleForm.MyOptionsGroupBox.chkAutoUnspec','',{'Enabled':False, 'Checked':False})
	
def tryToUnspec():
	global oldNbPlayer
	global autoUnspecEnabled
	global wasSpec
	global lastUnspecSent
	global retryNextTime

	if datetime.datetime.now()-lastUnspecSent > maxUnspecInterval:
		iAmSpec = gui.GetControlProperties('BattleForm.SpectateCheckBox','')['Checked']
		
		currentBattle = api.GetCurrentBattle()
		if currentBattle != None:
			currentNbPlayer = len(currentBattle['Battle']['Users'])-api.GetCurrentBattle()['Battle']['SpectatorCount']
			if autoUnspecEnabled and oldNbPlayer > currentNbPlayer and iAmSpec:
				api.SetMyBattleStatus(False)
				lastUnspecSent = datetime.datetime.now()
			oldNbPlayer = currentNbPlayer
	else:
		retryNextTime = True
	
def in2_CLIENTBATTLESTATUS(infos):
	global autoUnspecEnabled
	if autoUnspecEnabled:
		tryToUnspec()

def in_LEFTBATTLE(id,username):
	global currentBattleId
	global autoUnspecEnabled
	if autoUnspecEnabled and int(id) == currentBattleId:
		tryToUnspec()
		
def all_in(args):
	global retryNextTime
	if retryNextTime:
		retryNextTime = False
		tryToUnspec()
	
