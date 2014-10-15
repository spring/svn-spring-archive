import lobbyscript
api = lobbyscript.Callback()

connected = False
def in_TASSERVER():
	print 'connected'
	connected = True

def timer_5():
	print connected
	if connected:
		api.sendProtocol('PING')
		api.handleProtocol('PONG')

def timer_1():
	print 'one second timer'