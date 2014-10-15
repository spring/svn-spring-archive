def in_SAID(chan, user, msg):
	print '#%s <%s> %s' % (chan, user, msg)

def in_SAIDEX(chan, user, msg):
	print '#%s * %s %s' % (chan, user, msg)

def in_SAIDPRIVATE(user, msg):
	print '<%s> %s' % (user, msg)