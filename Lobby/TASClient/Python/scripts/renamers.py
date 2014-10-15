import lobbyscript

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

colors = gui.GetColors()

def cmd_renamers():
	users = api.GetUsers()
	
	gui.AddToRichEdit('$local', '', colors['Info'])
	gui.AddToRichEdit('$local', '----------------------------------------', colors['Info'])
	gui.AddToRichEdit('$local', 'Renamers (sorted by name history size) :', colors['Info'])
	gui.AddToRichEdit('$local', '----------------------------------------', colors['Info'])
	
	renamers = list()
	
	for userName,userData in users.items():
		if len(userData['NameHistory'])>0:
			renamers.append(userData)
	
	renamersSorted = sorted(renamers, key=lambda renamer: len(renamer['NameHistory']), reverse=True)
	
	for renamer in renamersSorted:
		gui.AddToRichEdit('$local', '['+str(len(renamer['NameHistory']))+'] '+renamer['Name']+' (A.K.A. : '+', '.join(renamer['NameHistory'])+')', colors['Info'])
	
	return True