import lobbyscript
import thread

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

num = 0
mutexTest = thread.allocate_lock()

def changeComponentProp(comp,prop,value):
	changeComponentPropFull(comp,'',prop,value)
	
def changeComponentPropFull(comp,path,prop,value):
	p = gui.GetControlProperties(comp,path)
	p[prop] = value
	return gui.SetControlProperties(comp,path,p)

def _init():
	api.ShowDebugWindow()
	
def updateGUI(a,b,c,d):
	gui.SetControlProperties('MainForm.MainTitleBar','',{'Caption':str(num)+' '+str(a)+' '+str(b)+' '+str(c)+' '+str(d)})

def cmd_test():
	for i in range(1,100):
		print i
		a = api.GetUsers()
		b = api.GetBattles()
	return True
	
def timer_1():
	global num
	global mutexTest
	mutexTest.acquire()
	num += 1
	b = 0
	bb = api.GetReplays()
	if bb != None:
		b = len(bb)
	c = len(api.GetBattles())
	a = len(api.GetUsers())
	dd = api.GetCurrentBattle()
	if dd != None:
		d = len(dd)
	else:
		d = 0

	gui.SynchronizedUpdate('stabilityTestWithThreads','updateGUI',(a,b,c,d))
	mutexTest.release()