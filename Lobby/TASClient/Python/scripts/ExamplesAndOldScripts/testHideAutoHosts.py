import lobbyscript

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

sEnabled = True

autoHostKeyWords = ['host','dedicated','spads','springie']

def isNameAutoHost(name):
	global autoHostKeyWords
	for keyWord in autoHostKeyWords:
		if name.lower().find(keyWord) >= 0:
			return True
	return False
	
def isUserBot(userDict):
	return ((int(userDict['Status']) & 0x40) >> 6) == 1 or isNameAutoHost(userDict['Name'])	

def refreshBattles():
	global sEnabled

	battles = api.GetBattles()
	for id in battles:
		gui.SetBattleVisible(id,(sEnabled == False) or (not isUserBot(battles[id]['Hoster'])))
	
def cmd_hideautohosts(data):
	global sEnabled
	sEnabled = True
	refreshBattles()
	return True
	
def cmd_showautohosts(data):
	global sEnabled
	sEnabled = False
	refreshBattles()
	return True

def in_UPDATEBATTLEINFO(idStr, rest):
	global sEnabled
	if sEnabled: 
		battles = api.GetBattles()
		id = int(idStr)
		if isUserBot(battles[id]['Hoster']):
			gui.SetBattleVisible(id,False)
	