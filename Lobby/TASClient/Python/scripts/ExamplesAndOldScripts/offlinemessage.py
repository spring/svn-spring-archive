import lobbyscript
api = lobbyscript.Callback()

def in_ADDUSER(user, etc):
	if user == 'InsertUserHere':
		message = 'Message Goes Here'
		api.SendProtocol('SAYPRIVATE %s %s' % (user, message) )