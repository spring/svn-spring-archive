import time,thread
import lobbyscript
import sys

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

stickingNick = ''
specMode = 0
battleJoinedAndStatusChanged = 0

subMenuId = 0
menuStickSpecId = 0
menuStickId = 0
menuUnstickId = 0


colors = gui.GetColors()

def onUnStickClick(id):
	global menuUnstickId
	cmd_unstick()
	gui.RemoveFromMenu(menuUnstickId)
	menuUnstickId = 0

def onStickClick(id,spec):
	global subMenuId
	global menuStickSpecId
	global menuStickId
	global menuUnstickId
	if spec:
		cmd_stick(id+' 1')
	else:
		cmd_stick(id+' 0')

	if menuUnstickId == 0:    
		menuUnstickId = gui.AddItemToMenu2((),onUnStickClick,subMenuId,'mnuUnstick','UnStick')
    

def _init():
	global subMenuId
	global menuStickSpecId
	global menuStickId
	global menuUnstickId
	subMenuId = gui.AddSubmenuToMenu('PlayerItem','StickSubMenu','Stick')
	menuStickSpecId = gui.AddItemToMenu2((False,),onStickClick,subMenuId,'mnuStick','Stick')
	menuStickId = gui.AddItemToMenu2((True,),onStickClick,subMenuId,'mnuStickSpec','Stick Spec')
	gui.AddSeparatorToMenu(subMenuId,'mnuStickSpecSperator')
  

# exit stick mode if the sticked user left
def in_REMOVEUSER(nick):
	global stickingNick
	global menuUnstickId
	if nick == stickingNick:
		stickingNick = ''
		gui.AddToRichEdit('$current','Exiting stick mode ('+nick+' left).',colors['Info'])
		gui.RemoveFromMenu(menuUnstickId)

def in_FORCEQUITBATTLE():
	global stickingNick
	global menuUnstickId
	if stickingNick  != '':
		stickingNick = ''
		gui.AddToRichEdit('$current','Exiting stick mode (You were kicked from the battle).',colors['Info'])
		gui.RemoveFromMenu(menuUnstickId)

# the timer tryin to connect you to the sticked user
def timer_2():
	global stickingNick
	global specMode

	if stickingNick != '': 
		curBat = api.GetCurrentBattle()
		if curBat != None:
			if stickingNick not in curBat['Battle']['Users']:
				api.LeaveBattle()
		else:
			users = api.GetUsers()
			if stickingNick in users:
				if 'Battle' in users[stickingNick]:
					api.JoinBattle(users[stickingNick]['Battle']['Id'],'',specMode=='1')

def cmd_unstick():
	global stickingNick
	stickingNick = ''
	gui.AddToRichEdit('$current','Exiting stick mode.',colors['Info'])
	return True

def cmd_stick(data):
	args = data.split(' ')

	if len(args) != 2:
		gui.AddToRichEdit('$current',"Stick usage : /stick user joinAsSpec={0/1} (Ex : '/stick haxor465 1' will join as spectator every battle the player haxor465 joins.",colors['Error'])
		return 1
	nick = args[0]
	spec = args[1]
	global stickingNick
	global specMode

	if stickingNick != '':
		gui.AddToRichEdit('$current','Exiting stick mode.',colors['Info'])

	users = api.GetUsers()
	if nick in users:
		stickingNick = nick
		specMode = spec
		if specMode == '1':
			gui.AddToRichEdit('$current','Entering spectator sticking mode on : '+nick,colors['Info'])
		else:
			gui.AddToRichEdit('$current','Entering sticking mode on : '+nick,colors['Info'])
		gui.AddToRichEdit('$current','Type /unstick to leave that mode.',colors['Info'])

	else:
		stickingNick = ''
		gui.AddToRichEdit('$current',"User '"+nick+"' does not exist.",colors['Error'])

	# the command won't be processed by the lobby
	return True