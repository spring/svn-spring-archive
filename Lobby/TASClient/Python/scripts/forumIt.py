import time,thread
import lobbyscript
import webbrowser
import string

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

def __go(url):
	webbrowser.open(url)

def webBrowserThreadedOpen(url):
	thread.start_new_thread(__go,(url,))

def cmd_forum(args):
	webBrowserThreadedOpen("http://springrts.com/phpbb/search.php?keywords="+string.join(args, '' )+"&terms=all&author=&sc=1&sf=all&sk=t&sd=d&sr=topics&st=0&ch=300&t=0&submit=Search")
	return True
	