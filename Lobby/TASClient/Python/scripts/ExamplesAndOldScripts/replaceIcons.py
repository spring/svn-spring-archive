import lobbyscript

api = lobbyscript.Callback()
gui = lobbyscript.GUI()

def _init():
	icons = {0:{'File':'Lobby\python\scripts\C-Rank1.png', 'MaskColor':16777215}, 1:{'File':'Lobby\python\scripts\C-Rank2.png', 'MaskColor':16777215},2:{'File':'Lobby\python\scripts\C-Rank3.png', 'MaskColor':16777215},3:{'File':'Lobby\python\scripts\C-Rank4.png', 'MaskColor':16777215},4:{'File':'Lobby\python\scripts\\1starg.png', 'MaskColor':16777215},5:{'File':'Lobby\python\scripts\\2stars.png', 'MaskColor':16777215},6:{'File':'Lobby\python\scripts\\3starsu.png', 'MaskColor':16777215},7:{'File':'Lobby\python\scripts\\generalxz.png', 'MaskColor':16777215}}
	gui.AddOrReplaceIconList('rank',icons)
	gui.AddOrReplaceIconList('connectionstate',icons)