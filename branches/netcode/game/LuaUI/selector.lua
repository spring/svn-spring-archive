--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    selector.lua
--  brief:   the widget selector, loads and unloads widgets
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "WidgetSelector",
    desc      = "Widget selection widget",
    author    = "trepan",
    date      = "Jan 8, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = -9,
    enabled   = true  --  loaded by default?
  }
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

include("colors.h.lua")
include("keysym.h.lua")
include("fonts.lua")


local floor = math.floor


widgetHandler.knownChanged = true

local widgetsList = {}

local vsx, vsy = widgetHandler:GetViewSizes()

local fontSize = 11
local fontSpace = 5
local yStep = fontSize + fontSpace

local fh = (1 > 0)
--[[
local entryFont  = "LuaUI/Fonts/arial_14"
local headerFont = "LuaUI/Fonts/arial_20"
local entryFont  = "LuaUI/Fonts/dustismo_14"
local headerFont = "LuaUI/Fonts/dustismo_18"
local entryFont  = "LuaUI/Fonts/courbd_14"
local headerFont = "LuaUI/Fonts/courbd_18"
local entryFont  = "LuaUI/Fonts/times_14"
local headerFont = "LuaUI/Fonts/times_18"
local entryFont  = "LuaUI/Fonts/trebucbd_14"
local headerFont = "LuaUI/Fonts/trebucbd_18"
local entryFont  = "LuaUI/Fonts/monofont_14"
local headerFont = "LuaUI/Fonts/monofont_18"
--]]
local entryFont  = "LuaUI/Fonts/FreeSansBold_12"
local headerFont = "LuaUI/Fonts/FreeSansBold_16"
local entryFont  = "LuaUI/Fonts/FreeMonoBold_12"
local headerFont = "LuaUI/Fonts/FreeMonoBold_16"

--local headerFont = "LuaUI/Fonts/FreeSerifBold_24"

if (1 > 0) then
  entryFont  = ":n:" .. entryFont
  headerFont = ":n:" .. headerFont
end

fontHandler.UseDefaultFont()
local entryFont = fontHandler.GetFontName()

if (fh) then
  fh = fontHandler.UseFont(headerFont) and
       fontHandler.UseFont(entryFont)
end
if (fh) then
  fontSize  = fontHandler.GetFontSize()
  yStep     = fontHandler.GetFontYStep()
  fontSpace = yStep - fontSize
end


local maxWidth = 0.01
local borderx = yStep * 0.75
local bordery = yStep * 0.75

local midx = vsx * 0.5
local minx = vsx * 0.4
local maxx = vsx * 0.6
local midy = vsy * 0.5
local miny = vsy * 0.4
local maxy = vsy * 0.6

-------------------------------------------------------------------------------

local function UpdateGeometry()
  midx  = vsx * 0.5
  midy  = vsy * 0.5

  local halfWidth = maxWidth * fontSize * 0.5
  minx = floor(midx - halfWidth - borderx)
  maxx = floor(midx + halfWidth + borderx)

  local ySize = yStep * table.getn(widgetsList)
  miny = floor(midy - (0.5 * ySize) - bordery)
  maxy = floor(midy + (0.5 * ySize) + bordery)
end
UpdateGeometry()


local function UpdateList()
  local myCount = table.getn(widgetsList)
  if (not widgetHandler.knownChanged) then
    return
  end
  widgetHandler.knownChanged = false

  local myName = widget:GetInfo().name
  maxWidth = 0
  widgetsList = {}
  for name,data in pairs(widgetHandler.knownWidgets) do
    if (name ~= myName) then
      table.insert(widgetsList, { name, data })
      -- look for the maxWidth
      local width = gl.GetTextWidth(name)
      local width = fontHandler.GetTextWidth(name)
      if (width > maxWidth) then
        maxWidth = width
      end
    end
  end
  
  maxWidth = maxWidth / fontSize

  local myCount = table.getn(widgetsList)
  if (widgetHandler.knownCount ~= (myCount + 1)) then
    error('knownCount mismatch')
  end

  table.sort(widgetsList, function(nd1, nd2)
    return (nd1[1] < nd2[1]) -- sort by name
  end)

  UpdateGeometry()
end


function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
  UpdateList()
  UpdateGeometry()
end


-------------------------------------------------------------------------------

function widget:KeyPress(key, mods, isRepeat)
  if ((key == KEYSYMS.ESCAPE) or
      ((key == KEYSYMS.F11) and not isRepeat and
       not (mods.alt or mods.ctrl or mods.meta or mods.shift))) then
    widgetHandler:RemoveWidget(self)
    return true
  end
  return false
end


function widget:DrawScreen()
  UpdateList()

  -- draw the header  
  if (fh) then
--    fontHandler.DisableCache()
    gl.Color(1, 1, 1)
    fontHandler.UseFont(headerFont)
    fontHandler.DrawCentered("Widget Selector", floor(midx), floor(maxy + 7))
    fontHandler.UseFont(entryFont)
  else
    gl.Text("Widget Selector", midx, maxy + 5, fontSize * 1.25, "oc")
  end


  -- draw the box
  gl.Color(0.3, 0.3, 0.3, 1.0)
  gl.Texture("bitmaps/detailtex.bmp")
  local ts = (2.0 / 512)  --  texture scale 
  gl.Shape(GL.QUADS, {
    { v = { minx, miny }, t = { minx * ts, miny * ts } },
    { v = { maxx, miny }, t = { maxx * ts, miny * ts } },
    { v = { maxx, maxy }, t = { maxx * ts, maxy * ts } },
    { v = { minx, maxy }, t = { minx * ts, maxy * ts } } 
  })
  gl.Texture(false)

  -- draw the widget labels
  local mx,my,lmb,mmb,rmb = Spring.GetMouseState()
  local nd = not widgetHandler.tweakMode and self:AboveLabel(mx, my)
  local pointedY = nil
  local pointedEnabled = false
  local pointedName = (nd and nd[1]) or nil
  local posy = maxy - yStep - bordery
  for _,namedata in ipairs(widgetsList) do
    local name = namedata[1]
    local data = namedata[2]
    local color = ''
    local pointed = (pointedName == name)
    local order = widgetHandler.orderList[name]
    local enabled = order and (order > 0)
    local active = data.active
    if (pointed) then
      pointedY = posy
      pointedEnabled = data.active
      if (lmb or mmb or rmb) then
        color = WhiteStr
      else
        color = (active  and '\255\128\255\128') or
                (enabled and '\255\255\255\128') or '\255\255\128\128'
      end
    else
      color = (active  and '\255\064\224\064') or
              (enabled and '\255\200\200\064') or '\255\224\064\064'
    end

    local tmpName
    if (data.fromZip) then
      -- FIXME: extra chars not counted in text length
      tmpName = WhiteStr .. '*' .. color .. name .. WhiteStr .. '*'
    else
      tmpName = color .. name
    end

    if (fh) then
      fontHandler.DrawCentered(color..tmpName, floor(midx), floor(posy + 2))
    else
      gl.Text(color..tmpName, midx, posy, fontSize, "c")
    end

    posy = posy - yStep
  end

  -- outline the highlighted label
  if (pointedY) then
    if (lmb or mmb or rmb) then
      if (pointedEnabled) then
        gl.Color(1.0, 0.2, 0.2, 0.2)
      else
        gl.Color(0.2, 1.0, 1.0, 0.2)
      end
    else
      gl.Color(0.2, 0.2, 1.0, 0.2)
    end
    local minyp = pointedY - 0.5
    local maxyp = pointedY + yStep + 0.5
    local xn = minx + 0.5
    local xp = maxx - 0.5
    local yn = pointedY - 0.5
    local yp = yn + yStep + 1
    gl.Blending(false)
    gl.Shape(GL.LINE_LOOP, {
      { v = { xn, yn } }, { v = { xp, yn } },
      { v = { xp, yp } }, { v = { xn, yp } }
    })
    xn = minx
    xp = maxx
    yn = yn + 0.5
    yp = yp - 0.5
    gl.Blending(GL.SRC_ALPHA, GL.ONE)
    gl.Shape(GL.QUADS, {
      { v = { xn, yn } }, { v = { xp, yn } },
      { v = { xp, yp } }, { v = { xn, yp } }
    })
    gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
  end

  -- outline the box
  xn = minx - 0.5
  yn = miny - 0.5
  xp = maxx + 0.5
  yp = maxy + 0.5
  gl.Color(1, 1, 1)
  gl.Shape(GL.LINE_LOOP, {
    { v = { xn, yn } }, { v = { xp, yn } },
    { v = { xp, yp } }, { v = { xn, yp } }
  })
  xn = xn - 1
  yn = yn - 1
  xp = xp + 1
  yp = yp + 1
  gl.Color(0, 0, 0)
  gl.Shape(GL.LINE_LOOP, {
    { v = { xn, yn } }, { v = { xp, yn } },
    { v = { xp, yp } }, { v = { xn, yp } }
  })

  if (fh) then
    fontHandler.EnableCache()
  end
end


function widget:MousePress(x, y, button)
  UpdateList()
  
  local namedata = self:AboveLabel(x, y)
  if (not namedata) then
    return false
  end
  
  return true
  
end


function widget:MouseMove(x, y, dx, dy, button)
  return false
end


function widget:MouseRelease(x, y, button)
  UpdateList()
  
  local namedata = self:AboveLabel(x, y)
  if (not namedata) then
    return false
  end
  
  local name = namedata[1]
  local data = namedata[2]
  
  if (button == 1) then
    widgetHandler:ToggleWidget(name)
  elseif ((button == 2) or (button == 3)) then
    local w = widgetHandler:FindWidget(name)
    if (not w) then return -1 end
    if (button == 2) then
      widgetHandler:LowerWidget(w)
    else
      widgetHandler:RaiseWidget(w)
    end
    widgetHandler:SaveOrderList()
  end
  return -1
end


function widget:AboveLabel(x, y)
  if ((x < minx) or (y < (miny + bordery)) or
      (x > maxx) or (y > (maxy - bordery))) then
    return nil
  end
  local count = table.getn(widgetsList)
  if (count < 1) then return nil end
  
  local i = floor(1 + ((maxy - bordery) - y) / yStep)
  if     (i < 1)     then i = 1
  elseif (i > count) then i = count end
  
  return widgetsList[i]
end


function widget:IsAbove(x, y)
  UpdateList()
  if ((x < minx) or (x > maxx) or
      (y < miny) or (y > maxy)) then
    return false
  end
  return true
end


function widget:GetTooltip(x, y)
  UpdateList()  
  local namedata = self:AboveLabel(x, y)
  if (not namedata) then
    return '\255\200\255\200'..'Widget Selector\n'    ..
           '\255\255\255\200'..'LMB: toggle widget\n' ..
           '\255\255\200\200'..'MMB: lower  widget\n' ..
           '\255\200\200\255'..'RMB: raise  widget'
  end

  local n = namedata[1]
  local d = namedata[2]

  local order = widgetHandler.orderList[n]
  local enabled = order and (order > 0)
  
  local tt = (d.active and GreenStr) or (enabled  and YellowStr) or RedStr
  tt = tt..n..'\n'
  tt = d.desc   and tt..WhiteStr..d.desc..'\n' or tt
  tt = d.author and tt..BlueStr..'Author:  '..CyanStr..d.author..'\n' or tt
  tt = tt..MagentaStr..d.basename
  if (d.fromZip) then
    tt = tt..RedStr..' (mod widget)'
  end
  return tt
end


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
