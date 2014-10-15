import lobbyscript
api = lobbyscript.Callback()
gui = lobbyscript.GUI()

def out_SAY(chan, msg):
	if chan == 'code':
		exec msg