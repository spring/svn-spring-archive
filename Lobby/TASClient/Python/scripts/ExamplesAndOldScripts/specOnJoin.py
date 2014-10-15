import lobbyscript
import sys

battleJoinedAndStatusChanged = 0

def in_JOINBATTLE(data):
  global battleJoinedAndStatusChanged
  battleJoinedAndStatusChanged = 2

def in_CLIENTBATTLESTATUS(nick, status, color):
  api = lobbyscript.Callback()
  if nick == api.GetMyUser()['Name']:
    global battleJoinedAndStatusChanged
    if battleJoinedAndStatusChanged:
      battleJoinedAndStatusChanged -= 1
      if battleJoinedAndStatusChanged == 0:
		api.SetMyBattleStatus(1)