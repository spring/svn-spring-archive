import lobbyscript
api = lobbyscript.Callback()

def in_ADDUSER(user, etc):
	if len(user) > 20:
		print 'We have an abuser'
		api.SendProtocol('GETIP %s' % user)
		api.SendProtocol('KICKUSER %s use a shorter name.' % user)