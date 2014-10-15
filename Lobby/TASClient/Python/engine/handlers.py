import lobbyscript
api = lobbyscript.Callback()

import sys, os
basepath = sys.path[-1]
sys.path.insert(1, os.path.join(basepath, '..', 'modules'))
sys.path.insert(1, os.path.join(basepath, '..', 'scripts'))

import inspect, time, thread
scripts = {}

global timers
timers = []

global threads
threads = 0

## TODO ##
## Add try:except:traceback on everything
##########

global timer_lock
timer_lock = thread.allocate_lock()

global running
global connected
running = True
connected = False

def __timer_loop():
	global timers
	global running
	global threads
	threads += 1
	while running:
		time.sleep(1)
		timer_lock.acquire()
		try:
			for i in xrange(len(timers)):
				timers[i]['position'] -= 1
				if timers[i]['position'] <= 0:
					timers[i]['position'] = timers[i]['max']
					timers[i]['function']()
			timer_lock.release()
		except:
			timer_lock.release()
			thread.start_new_thread(__timer_loop,())
			threads -= 1
			#new thread so the traceback can continue
			raise
	threads -= 1

def _parse_timers():
	global timers
	print
	print 'Parsing timers...'
	timer_lock.acquire()
	timers = []
	for s in scripts:
		script = scripts[s]
		for attr in dir(script):
			if attr.startswith('timer_'):
				timer, secs = attr.split('_',1)
				#try:
				secs = int(secs)
				exec 'timer = script.%s' % attr
				if type(timer) == type(_parse_timers):
					timers.append( {'function':timer, 'position':0, 'max':secs} )
					print '%s registered timer function %s() for every %s seconds' % (s, attr, secs)
				else: print '%s is a bad timer hook -- it is not a function' % timer
				#except: print '%s is a bad timer in script %s' % (attr, s)
	print
	timer_lock.release()

def _load():
	print 'Loading scripts:',
	new = []
	for s in os.listdir(os.path.join(basepath, '..', 'scripts')):
		if not s.endswith('.py'): continue
		s = os.path.split(s)[-1].rsplit('.py',1)[0]
		if not s in scripts:
			script = __import__(s)
			if '_init' in dir(script):
				script._init()
			scripts[s] = script
			new.append(s)
	print ', '.join(new)
	print
	_parse_timers()
	return new

def _reloadall():
	print 'Reloading scripts: ',
	reloaded = []
	for s in dict(scripts):
		script = scripts[s]
		if '_reload' in dir(script):
			script._reload()
		result = _reload(s)
		reloaded.append(result)
	print ', '.join(reloaded)
	_parse_timers()
	return reloaded

def _reload(s):
	script = scripts[s]
	for a in dir(script):
		if not a.startswith('__') or not a.endswith('__'):
			exec 'del script.%s' % a # extremely hackish and will turn out something like 2.5 seconds slower
									 # in 1 million runs than deleting directly... oh well  :) 
	try:
		reload(script)
	except ImportError:
		del scripts[s]
		return '-%s' % s
	if '_reinit' in dir(script):
		script._reinit(api)
	return s

def _list():
	reply = []
	for s in scripts:
		reply.append(s)
	return ', '.join(reply)

def _call_function(function, spaces, data, cmd, args):
	if type(function) == type(_call_function):
		function_info = inspect.getargspec(function)
		total_args = len(function_info[0])
		if total_args == 0:
			returned = function()
		else:
			if total_args > spaces:
				print 'Too many arguments in function %s of %s' % (function.__name__, inspect.getmodule(function))
			else:
				args = args.split(' ',total_args-1)
				returned = function(*args)
		if returned == False: return ''
		if data == None:
			data = cmd
		else:
			if returned == None: data = args
			else: data = returned
			if type(data) in (list, tuple): data = ' '.join(data)
			if data:
				if cmd!=None:
					data = '%s %s' % (cmd, data)
			else:
				data = cmd
	else:
		print ' %s has an attribute %s but it is not a function' % (s, funcname)
	return data

def _handle(direction, data):
	for s in scripts:
		if not data: return data

		spaces = data.count(' ')
		if spaces >= 1:
			cmd, args = data.split(' ',1)
		else:
			cmd = data
			args = ''

		funcname = '%s_%s' % (direction, cmd)
		script = scripts[s]

		if funcname in dir(script):
			exec "function = script.%s" % funcname
			data = _call_function(function, spaces, data, cmd, args)
		elif 'all_%s' % direction in dir(script):
			exec 'function = script.all_%s' % direction
			data = _call_function(function, spaces+1, data, None, data)
	return data
	
def handleIn2(data, recursing=0):
	return _handle('in2', data)

def handleIn(data, recursing=0):
	return _handle('in', data)

def handleOut(data, recursing=0):
	return _handle('out', data)

def _handle_callin(funcname, args=''):
	if not funcname: return False
	for s in scripts:
		script = scripts[s]

		spaces = args.count(' ')

		if funcname in dir(script):
			exec "function = script.%s" % funcname
			if type(function) == type(_handle):

				function_info = inspect.getargspec(function)
				total_args = len(function_info[0])

				if total_args == 0:
					return function()
				else:
					if total_args > spaces+1:
						print 'Too many arguments in function %s of %s' % (funcname, s)
						return False
					else:
						args = args.split(' ',total_args-1)
						return function(*args)
					
			else:
				print ' %s has an attribute %s but it is not a function' % (s, funcname)

def onDisconnect():
	return _handle_callin('onDisconnect')

def onConnected():
	return _handle_callin('onConnected')

def onLogin():
	return _handle_callin('onLogin')

def onLoggedIn():
	return _handle_callin('onLoggedIn')
	
def onSettingsChanged():
	return _handle_callin('onSettingsChanged')
	
def onGroupsChanged():
	return _handle_callin('onGroupsChanged')
	
def onMapsReloaded():
	return _handle_callin('onMapsReloaded')
	
def onReplaysReloaded():
	return _handle_callin('onReplaysReloaded')
	
def onModsReloaded():
	return _handle_callin('onModsReloaded')
	
def onURLClick(channel,url):
	return _handle_callin('onURLClick',channel+' '+url)
	
def onChatDblClick(channel,charPos,line):
	return _handle_callin('onChatDblClick',channel+' '+str(charPos)+' '+line)
	
def onDownloadRapidStart(formName,rapidName):
	return _handle_callin('onDownloadModStart',formName+' '+rapidName)
	
def onDownloadModStart(formName,modHash,modName):
	return _handle_callin('onDownloadModStart',formName+' '+str(modHash)+' '+modName)
	
def onDownloadMapStart(formName,mapHash,mapName):
	return _handle_callin('onDownloadMapStart',formName+' '+str(mapHash)+' '+mapName)
	
def onStartSpring(args):
	return _handle_callin('onStartSpring',args)
	
def onBackFromGame():
	return _handle_callin('onBackFromGame')
	
def onWidgetListRefreshed():
	return _handle_callin('onWidgetListRefreshed')

def onWidgetInstalledOrUpdated(widgetId,widgetUpdated):
	return _handle_callin('onWidgetInstalledOrUpdated',str(widgetId)+' '+str(widgetUpdated))

def onWidgetUninstalled(widgetId):
	return _handle_callin('onWidgetUninstalled',str(widgetId))
	
def onClose():
	global running
	running = False
	return _handle_callin('onClose')

def handleCommand(cmd):
	spaces = cmd.count(' ')
	if spaces >= 1:
		cmd, args = cmd.split(' ',1)
	else:
		cmd = cmd
		args = ''
	return _handle_callin('cmd_%s'%cmd, args)


thread.start_new_thread(__timer_loop,())
