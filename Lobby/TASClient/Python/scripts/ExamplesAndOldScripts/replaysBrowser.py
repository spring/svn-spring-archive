import lobbyscript
import zipfile
import pycurl
from threading import Thread
import sys, os
import subprocess
import re
import time

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

settingsFile = 'replaysBrowserSettings.txt'
settings = dict()

demoPath = ''
downloadingReplayOrMap = False
mapName = ''
replayDownloadWindowVisible = False
dlThread = None

def onCancelDownload(Sender):
	global dlThread
	global downloadingReplayOrMap
	global replayDownloadWindowVisible
	
	dlThread.abort = True
	downloadingReplayOrMap = False
	
	if replayDownloadWindowVisible:
		gui.SetControlProperties ('ReplayDownload', '', {'Visible':'False'})
		replayDownloadWindowVisible = False

def onMapDownloadProgress(progress):
	global downloadingReplayOrMap
	global replayDownloadWindowVisible
	
	if replayDownloadWindowVisible:
		gui.SetControlProperties ('ReplayDownload', '', {'Visible':'False'})
		replayDownloadWindowVisible = False
	if progress < 0:
		downloadingReplayOrMap = False
	if progress == -1:
		p = subprocess.Popen([api.GetSpringExe(), demoPath])
		
def onModDownloadProgress(progress):
	global downloadingReplayOrMap
	global replayDownloadWindowVisible
	
	if replayDownloadWindowVisible:
		gui.SetControlProperties ('ReplayDownload', '', {'Visible':'False'})
		replayDownloadWindowVisible = False
	if progress < -1:
		downloadingReplayOrMap = False
	if progress == -1:
		maps = api.GetMaps()
		if mapName in maps:
			downloadingReplayOrMap = False
			p = subprocess.Popen([api.GetSpringExe(), demoPath])
		else:
			api.DownloadMap2(mapName,(),onMapDownloadProgress)
			
def syncedSetControlProperties(componentName,prop,values):
	gui.SetControlProperties (componentName, prop, values)

class DownloaderThread(Thread):
	def __init__(self, url, destFileName):
		Thread.__init__(self)
		self.url = url
		self.destFileName = destFileName
		self.abort = False
		
	def onProgress(self,dlTotal,dlNow,ulTotal, ulNow):
		if self.abort:
			return False
		if dlTotal > 0: 
			gui.SynchronizedUpdate2(syncedSetControlProperties,('ReplayDownload.TitleBar.pbDownload', '', {'Position':int(100*dlNow/dlTotal)}))
		
	def onDone(self):
		global demoPath 
		global downloadingReplayOrMap
		global mapName
		global replayDownloadWindowVisible
		
		zip = zipfile.ZipFile (self.destFileName, 'r')
		files = zip.namelist()
		if len(files) == 1:
			if files[0].find('..') == -1:
				fp = open('.\\demos\\'+files[0], "wb")
				fp.write(zip.read(files[0]))
				fp.close()
				
				demoPath = '.\\demos\\'+files[0]
				
				replay = open('.\\demos\\'+files[0], "rb").read()
				mapMatch = re.findall('mapname=([^;]+);',replay,re.IGNORECASE)
				modMatch = re.findall('gametype=([^;]+);',replay,re.IGNORECASE)
				if mapMatch != None and modMatch != None and len(mapMatch)>0 and len(modMatch)>0:
					mapName = mapMatch[0]
					mods = api.GetMods()
					if modMatch[0] in mods:
						maps = api.GetMaps()
						if mapName in maps:
							downloadingReplayOrMap = False
							p = subprocess.Popen([api.GetSpringExe(), demoPath])
							time.sleep(2)
							gui.SynchronizedUpdate2(syncedSetControlProperties,('ReplayDownload', '', {'Visible':'False'}))
							replayDownloadWindowVisible = False
						else:
							api.DownloadMap2(mapName,(),onMapDownloadProgress)
					else:
						api.DownloadMod2(modMatch[0],(),onModDownloadProgress)
				else: # can't get the map name or mod name just launching the replay
					downloadingReplayOrMap = False
					p = subprocess.Popen([api.GetSpringExe(), demoPath])
					time.sleep(2)
					gui.SynchronizedUpdate2(syncedSetControlProperties,('ReplayDownload', '', {'Visible':'False'}))
					replayDownloadWindowVisible = False

	def run(self):
		fp = open(self.destFileName, "wb")
		curl = pycurl.Curl()
		curl.setopt(pycurl.URL, self.url)
		curl.setopt(pycurl.FOLLOWLOCATION, 1)
		curl.setopt(pycurl.MAXREDIRS, 5)
		curl.setopt(pycurl.CONNECTTIMEOUT, 30)
		curl.setopt(pycurl.TIMEOUT, 300)
		curl.setopt(pycurl.NOSIGNAL, 1)
		curl.setopt(pycurl.WRITEDATA, fp)
		curl.setopt(pycurl.NOPROGRESS, 0)
		curl.setopt(pycurl.PROGRESSFUNCTION, self.onProgress)
		
		curl.perform()
		
		curl.close()
		fp.close()
		
		if not self.abort:
			self.onDone()

def onClose():
	global settings
	p = gui.GetControlProperties('ReplaysBrowser','')
	settings['Width'] = p['Width']
	settings['Height'] = p['Height']
	settings['Left'] = p['Left']
	settings['Top'] = p['Top']
	file(os.path.join(sys.path[0],'..','scripts',settingsFile),'w').write(repr(settings))
	
def AddTitleBar(formName,titlebarName):
	p = gui.GetControlProperties(formName,'')
	gui.AddControl(titlebarName,formName,'TSpTBXTitleBar')
	gui.SetControlProperties (formName+'.'+titlebarName, '', {'Active':'False','Caption':p['Caption']})
	if gui.GetControlProperties('MainForm.AwayMsgsButton','')['SkinType'] == 'sknSkin':
		if p['BorderStyle'] == 'bsSingle':
			gui.SetControlProperties (formName, '', {'BorderStyle':'bsSizeable'})
		gui.SetControlProperties (formName+'.'+titlebarName, '', {'FixedSize':'True','Active':'True','FixedSize':'False'})
		if p['BorderStyle'] == 'bsSingle':
			gui.SetControlProperties (formName, '', {'BorderIcons':'biSystemMenu'})
			gui.SetControlProperties (formName+'.'+titlebarName, '', {'FixedSize':'True'})
			gui.SetControlProperties (formName+'.'+titlebarName, 'Options', {'Maximize':'False','Minimize':'False'})

def _init():
	global settings
	if os.path.isfile(os.path.join(sys.path[0],'..','scripts',settingsFile)):
		s = file(os.path.join(sys.path[0],'..','scripts',settingsFile),'r').read()
		settings = eval(s)
	
	if not 'Width' in settings:
		settings['Width'] = 800
	if not 'Height' in settings:
		settings['Height'] = 600
	if not 'Left' in settings:
		settings['Left'] = 50
	if not 'Top' in settings:
		settings['Top'] = 50

	gui.AddForm('ReplaysBrowser','Replays Browser',2,False)
	gui.SetControlProperties ('ReplaysBrowser', '', {'Width':settings['Width'], 'Height':settings['Height'],'Left':settings['Left'],'Top':settings['Top'],'BorderIcons':'biSystemMenu,biMinimize,biMaximize'})
	AddTitleBar('ReplaysBrowser','TitleBar')
	gui.AddControl('WebBrowser','ReplaysBrowser.TitleBar','TWebBrowserWrapper')
	gui.SetControlProperties ('ReplaysBrowser.TitleBar.WebBrowser', '', {'Align':'alClient'})
	gui.AddEvent2('ReplaysBrowser.TitleBar.WebBrowser','OnBeforeNavigate2',WebBrowserOnBeforeNavigate2)
	gui.AddEvent2('ReplaysForm.DownloadButton','OnClick',DownloadButtonOnClick)
	
	gui.AddForm('ReplayDownload','Downloading replay ...',1,False)
	gui.SetControlProperties ('ReplayDownload', '', {'BorderIcons':'biSystemMenu,biMinimize,biMaximize'})
	AddTitleBar('ReplayDownload','TitleBar')
	gui.AddControl('pbDownload','ReplayDownload.TitleBar','TSpTBXProgressBar')
	gui.SetControlProperties ('ReplayDownload', '', {'Width':400, 'Height':60,'BorderIcons':'biSystemMenu','Position':'poMainFormCenter'})
	gui.SetControlProperties ('ReplayDownload.TitleBar.pbDownload', '', {'Align':'alClient','Max':100,'Min':0,'Position':0,'Smooth':'True','CaptionType':'pctNone'})
	gui.AddEvent2('ReplayDownload','OnClose',onCancelDownload)


def WebBrowserOnBeforeNavigate2(Sender,PostData,TargetFrameName,URL):
	global downloadingReplayOrMap
	global replayDownloadWindowVisible
	global dlThread
	if not downloadingReplayOrMap and URL.lower().find('http://replays.adune.nl/?act=download&id=') > -1:
		gui.SetControlProperties ('ReplayDownload', '', {'Visible':'True'})
		replayDownloadWindowVisible = True
		downloadingReplayOrMap = True
		dlThread = DownloaderThread(URL,'tmpReplayFile.zip')
		dlThread.start()
		return True
	else:
		return False
	
def DownloadButtonOnClick(Sender):
	gui.SetControlProperties ('ReplaysBrowser', '', {'Visible':'True'})
	gui.SetControlProperties ('ReplaysBrowser.TitleBar.WebBrowser', '', {'URL':'http://replays.adune.nl/?customlink=Play%20now'})
	
	