--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui.lua
--  brief:   entry point for the user LuaUI, can redirect to a mod's LuaUI
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

LUAUI_VERSION = "LuaUI v0.1"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

LUAUI_DIRNAME   = 'LuaUI/'
do
  -- use a versionned directory name if it exists
  local sansslash = string.sub(LUAUI_DIRNAME, 1, -2)
  local versiondir = sansslash .. '-' .. Game.version .. '/'
  local f = io.open(versiondir  .. 'main.lua')
  if (f) then
    f:close()
    LUAUI_DIRNAME = versiondir
  end
end
print('Using LUAUI_DIRNAME = ' .. LUAUI_DIRNAME)


USER_FILENAME   = LUAUI_DIRNAME .. 'main.lua'
CHOOSE_FILENAME = LUAUI_DIRNAME .. 'modui_dialog.lua'
PERM_FILENAME   = LUAUI_DIRNAME .. 'Config/modui_list.lua'

MODUI_DIRNAME   = 'ModUI/'  --  should version this too, exceptions?
MOD_FILENAME    = MODUI_DIRNAME .. 'main.lua'


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Spring 0.74b3 doesn't handle missing sound files gracefully.
--  We make sure that the sound file exists, and hope that it is
--  a valid sound file
--

do
  local origFunc = Spring.PlaySoundFile
  Spring.PlaySoundFile = function(filename, ...)
    local f = io.open(filename)
    if (f) then
      f:close()
      origFunc(filename, unpack(arg))
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function Echo(msg)
  Spring.SendCommands({'echo ' .. msg})
end

function CleanNameSpace()
	MOD_FILENAME    = nil
	USER_FILENAME   = nil
	PERM_FILENAME   = nil
	CHOOSE_FILENAME = nil
	Echo            = nil
  CleanNameSpace  = nil
end


--------------------------------------------------------------------------------
--
-- clear the call-ins
--

Shutdown        = nil
LayoutButtons   = nil
UpdateLayout    = nil
ConfigureLayout = nil
CommandNotify   = nil
DrawWorldItems  = nil
DrawScreenItems = nil
KeyPress        = nil
KeyRelease      = nil
MouseMove       = nil
MousePress      = nil
MouseRelease    = nil
IsAbove         = nil
GetTooltip      = nil
AddConsoleLine  = nil
GroupChanged    = nil
UnitCreated     = nil
UnitFinished    = nil
UnitFromFactory = nil
UnitDestroyed   = nil
UnitTaken       = nil
UnitGiven       = nil


--------------------------------------------------------------------------------
--
-- get the mod's GUI permission state
--

local loadFromMod = nil

do
  -- always bring up the mod dialog if CTRL is pressed
  local alt,ctrl,meta,shift = Spring.GetModKeyState()
  if (not ctrl) then  
    local chunk, err = loadfile(PERM_FILENAME)
    if (chunk ~= nil) then
      local tmp = {}
      setfenv(chunk, tmp)
      local perms = chunk()
      if (perms) then
        loadFromMod = perms[Game.modName]
      end
    end
  end
end


--------------------------------------------------------------------------------

local modText

if (loadFromMod ~= false) then
  modText = Spring.LoadTextVFS(MOD_FILENAME)
  if (modText == nil) then
    loadFromMod = false
  end
end

if (loadFromMod == nil) then
  -- setup the mod selection UI
  local chunk, err = loadfile(CHOOSE_FILENAME)
  if (chunk == nil) then
    Echo('Failed to load ' .. MOD_FILENAME .. ': (' .. err .. ')')
  else
  	CleanNameSpace()
    chunk()
    return
  end
elseif (loadFromMod) then
  -- load the mod's UI
  local chunk, err = loadstring(modText)
  if (chunk == nil) then
    Echo('Failed to load ' .. MOD_FILENAME .. ': (' .. err .. ')')
  else
    CleanNameSpace()
    chunk()
    return
  end
end


-------------------------------------------------------------------------------- 
--
-- load the user's UI
--

do
  local chunk, err = loadfile(USER_FILENAME)
  if (chunk == nil) then
    Echo('Failed to load ' .. USER_FILENAME .. ': (' .. err .. ')')
    LayoutIcons = function () return 'disabled' end
  else
    CleanNameSpace()
    chunk()
    return
  end
end


-------------------------------------------------------------------------------- 
-------------------------------------------------------------------------------- 
