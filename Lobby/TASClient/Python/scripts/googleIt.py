import time,thread
import lobbyscript
import webbrowser
import sys
import pycurl
import re
from encodings import ascii
from encodings import utf_8

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

autoTranslateNickList = dict()

HexCharacters = "0123456789abcdef"

def CleanCharHex(c):
    o = ord(c)
    r = HexCharacters[o / 16]
    r += HexCharacters[o % 16]
    return r

def UrlEncode(s):
	r = ''
	for c in s:
		o = ord(c)
		if (o >= 48 and o <= 57) or \
			(o >= 97 and o <= 122) or \
			(o >= 65 and o <= 90) or \
			o == 36 or o == 45 or o == 95 or \
			o == 46 or o == 43 or o == 33 or \
			o == 42 or o == 39 or o == 40 or \
			o == 41 or o == 44:
			r += c
		else:
			r += '%' + CleanCharHex(c)
	return r

class PageContent:
    def __init__(self):
        self.contents = ''

    def body_callback(self, buf):
        self.contents = self.contents + buf


def translate(lang,text):
	pc = PageContent()
	c = pycurl.Curl()
	c.setopt(c.URL, "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair=|"+lang.encode("utf-8")+"&q="+UrlEncode(text.encode("utf-8")))
	c.setopt(c.WRITEFUNCTION, pc.body_callback)
	c.perform()
	c.close()
	match = re.search('"translatedText":"([^"]*)"', pc.contents)
	if match==None:
		return text
	else:
		return match.groups()[0].decode("utf-8")

def __go(url):
	webbrowser.open(url)

def webBrowserThreadedOpen(url):
	thread.start_new_thread(__go,(url,))

def onGoogleItClick(channel,line,charPosInLine,selectedText):
	if selectedText != '':
		webBrowserThreadedOpen("http://www.google.com/search?q="+selectedText)

def onTranslateClick(channel,line,charPosInLine,selectedText,lang):
	if selectedText != '':
		webBrowserThreadedOpen("http://translate.google.com/#auto|"+lang.decode("utf-8")+"|"+selectedText.decode("utf-8"))

def onStopAutoTranslation(user):
	global autoTranslateNickList
	if user in autoTranslateNickList:
		del autoTranslateNickList[user]

def onAutoTranslateClick(user,lang):
	cmd_autotranslate(user,lang)

def _init():
	gui.AddItemToMenu2((),onGoogleItClick,'Chat','mnuGoogleThis','Google this')
	gui.AddItemToMenu2(('en',),onTranslateClick,'Chat','mnuTranslateEnglish','Translate in english')
	gui.AddItemToMenu2(('fr',),onTranslateClick,'Chat','mnuTranslateFrench','Translate in french')
	gui.AddItemToMenu2(('de',),onTranslateClick,'Chat','mnuTranslateGerman','Translate in german')
	gui.AddItemToMenu2(('it',),onTranslateClick,'Chat','mnuTranslateItalian','Translate in italian')
	gui.AddItemToMenu2(('es',),onTranslateClick,'Chat','mnuTranslateSpanish','Translate in spanish')
	gui.AddItemToMenu2(('ru',),onTranslateClick,'Chat','mnuTranslateRussian','Translate in russian')
	# The google translation service is not available anymore for free, the feature is disabled until an alternative is found
	# autoTransSubMenuId = gui.AddSubmenuToMenu('PlayerItem','AutoTranslateSubMenu','Auto translate')
	# gui.AddItemToMenu2((),onStopAutoTranslation,autoTransSubMenuId,'mnuAutoTranslateDisable','Disable')
	# gui.AddItemToMenu2(('en',),onAutoTranslateClick,autoTransSubMenuId,'mnuAutoTranslateEnglish','in english')
	# gui.AddItemToMenu2(('fr',),onAutoTranslateClick,autoTransSubMenuId,'mnuAutoTranslateFrench','in french')
	# gui.AddItemToMenu2(('de',),onAutoTranslateClick,autoTransSubMenuId,'mnuAutoTranslateGerman','in german')
	# gui.AddItemToMenu2(('it',),onAutoTranslateClick,autoTransSubMenuId,'mnuAutoTranslateItalian','in italian')
	# gui.AddItemToMenu2(('es',),onAutoTranslateClick,autoTransSubMenuId,'mnuAutoTranslateSpanish','in spanish')
	# gui.AddItemToMenu2(('ru',),onAutoTranslateClick,autoTransSubMenuId,'mnuAutoTranslateRussian','in russian')
	


def sendTranslation(command,lang,text):
	api.SendProtocol(command+' '+translate(lang,text))
	
def outMessage(command,text):
	return False # The google translation service is not available anymore for free, the feature is disabled until an alternative is found
	words = text.split(' ')
	if words[0] == '!translate' or words[0] == '!tr':
		sendTranslation(command,words[1],' '.join(words[2:]))
		return True
	else:
		return False

def out_SAY(channel,text):
	if outMessage('SAY '+channel,text):
		return False

def out_SAYPRIVATE(user,text):
	if outMessage('SAYPRIVATE '+user,text):
		return False
		
def out_SAYEX(channel,text):
	if outMessage('SAYEX '+channel,text):
		return False
		
def out_SAYBATTLE(text):
	if outMessage('SAYBATTLE',text):
		return False
		
def out_SAYBATTLEEX(text):
	if outMessage('SAYBATTLEEX',text):
		return False
		
def inMessage(command,user,text):
	global autoTranslateNickList
	if user in autoTranslateNickList:
		return command+user+' (translated)'+translate(autoTranslateNickList[user],text)
	else:
		return command+user+' '+text
		
def in_SAID(channel,user,text):
	return inMessage(channel+' ',user,text)
	
def in_SAIDEX(channel,user,text):
	return inMessage(channel+' ',user,text)
	
def in_SAIDPRIVATE(user,text):
	return inMessage('',user,text)
	
def in_SAIDBATTLE(user,text):
	return inMessage('',user,text)
	
def in_SAIDBATTLEEX(user,text):
	return inMessage('',user,text)

def cmd_autotranslate(userNick,lang):
	global autoTranslateNickList
	autoTranslateNickList[userNick] = lang
	return True
