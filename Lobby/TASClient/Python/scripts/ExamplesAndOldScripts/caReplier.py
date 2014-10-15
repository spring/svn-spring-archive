import lobbyscript
import datetime

lastSent = datetime.datetime.now()
MaxInterval = datetime.timedelta(seconds=15)

def in_SAID(chan,user,data):
	global lastSent
	global MaxInterval
	api = lobbyscript.Callback()
	if chan == 'main':
		if lastSent + MaxInterval < datetime.datetime.now(): 
			if data.find('caspring.org') >= 0:
				api.SendProtocol('SAY '+chan+' But, does CADownloader make pizza ??')
				lastSent = datetime.datetime.now()