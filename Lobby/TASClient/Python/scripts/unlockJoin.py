import lobbyscript
import datetime

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

timeoutDuration = datetime.timedelta(seconds=5)
timeoutLimit = datetime.datetime.now()
battle = None

def in_SAYPRIVATE(user,msg):
	global battle
	if datetime.datetime.now() < timeoutLimit:
		if user == battle['Hoster']['Name'] and msg == '!unlockspec':
			return False
		
def in_UPDATEBATTLEINFO(battleId,SpectatorCount,locked,other):
	global timeoutLimit
	if datetime.datetime.now() < timeoutLimit and battle != None:
		if battleId == str(battle['Id']) and locked == '0':
			api.JoinBattle(battle['Id'],'',False)
			timeoutLimit = datetime.datetime.now()
			
def onUnlockJoin(battleId):
	global battle
	global timeoutLimit
	battles = api.GetBattles()
	if battleId in battles:
		battle = battles[battleId]
		if battle['Locked']:
			api.SendProtocol('SAYPRIVATE '+battle['Hoster']['Name']+' !unlockspec')
			timeoutLimit = datetime.datetime.now()+timeoutDuration
		else:
			api.JoinBattle(battleId,'',False)

def _init():
	gui.AddItemToMenu2((),onUnlockJoin,'BattleItem','mnuUnlockSpec','!unlockspec Join')