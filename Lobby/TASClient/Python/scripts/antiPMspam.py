import lobbyscript
import datetime

lastSent = dict()
nbMsg = dict()
warningMsgSent = dict()
ignoreUsers = []
MaxAllowedMsgPerInterval = 100
IntervalInSec = 30
Interval = datetime.timedelta(seconds=IntervalInSec)

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

colors = gui.GetColors()

def cmd_unblock(user):
	global lastSent
	global nbMsg
	global warningMsgSent
	
	if user in lastSent:
		del lastSent[user]
	if user in nbMsg:
		del nbMsg[user]
	if user in warningMsgSent:
		del warningMsgSent[user]
	gui.AddToRichEdit('$current','*** Spam protection resetted for '+user+' ***',colors['Info'])
	return True
	
def cmd_spamprotection(user):
	global ignoreUsers
	users = api.GetUsers()
	if user != '':
		if not user in ignoreUsers:
			ignoreUsers.append(user)
			gui.AddToRichEdit('$current','*** Spam protection disabled for '+user+' ***',colors['Info'])
		else:
			ignoreUsers.remove(user)
			gui.AddToRichEdit('$current','*** Spam protection enabled for '+user+' ***',colors['Info'])
	return True
	
def in_SAID(channel,user,args):
	return checkSpam(user)
	
def in_SAIDEX(channel,user,args):
	return checkSpam(user)
	
def in_SAIDPRIVATE(user,args):
	return checkSpam(user)
	
def in_SAIDBATTLE(user,args):
	return checkSpam(user)
	
def in_SAIDBATTLEEX(user,args):
	return checkSpam(user)

def checkSpam(user):
	global lastSent
	global nbMsg
	global warningMsgSent
	global ignoreUsers
	
	if not user in ignoreUsers:
		if not user in lastSent:
			lastSent[user] = datetime.datetime.now()
			nbMsg[user] = 1
		else:
			if nbMsg[user] < MaxAllowedMsgPerInterval:
				if lastSent[user]+Interval < datetime.datetime.now():
					lastSent[user] = datetime.datetime.now()
					nbMsg[user] = 1
				else:
					nbMsg[user] = nbMsg[user]+1
			else:
				if lastSent[user]+Interval > datetime.datetime.now():
					lastSent[user] = datetime.datetime.now()
					if not user in warningMsgSent:
						warningMsgSent[user] = True
						gui.AddToRichEdit('$current','*** '+user+' is trying to spam you (received more than '+str(MaxAllowedMsgPerInterval)+' messages in less than '+str(IntervalInSec)+' seconds), to reset the spam protection for this user, type "/unblock '+user+'", to disable/enable the spam protection for this user, type "/spamprotection '+user+'" ***',colors['Error'])
					return False
				else:
					lastSent[user] = datetime.datetime.now()
					nbMsg[user] = 1
					if user in warningMsgSent:
						del warningMsgSent[user]
