
function chatHandler(args)
	local editBox = CEGUI.WindowManager:getSingleton():getWindow("/Chat/Wnd/Edit")
	local list = CEGUI.WindowManager:getSingleton():getWindow("/Chat/Wnd/List")
	local item =  CEGUI.ListboxTextItem:new(editBox:getText())
	list:addItem(item)
	list:ensureItemIsVisible(list:getItemCount())
	editBox:setText("")
end


-- get CEGUI singletons
local logger = CEGUI.Logger:getSingleton()
logger:logEvent( ">>> Initializing Spring GUI" )
--logger:setLoggingLevel( CEGUI.Informative )

-- get a local reference to the singletons we use (not required)
local system    = CEGUI.System:getSingleton()
local fontman   = CEGUI.FontManager:getSingleton()
local schememan = CEGUI.SchemeManager:getSingleton()
local winMgr	= CEGUI.WindowManager:getSingleton()
local isMgr	= CEGUI.ImagesetManager:getSingleton()

--schememan:loadScheme( "WindowsLook.scheme" )
--schememan:loadScheme( "VanillaSkin.scheme" )
schememan:loadScheme( "TaharezLook.scheme" , "schemes")


-- load a default font
local font = fontman:createFont( "Commonwealth-10.font" , "fonts")

-- set default mouse cursor
--system:setDefaultMouseCursor( "Marti", "MouseArrow")

w = winMgr:loadWindowLayout("Demo7Windows.layout", "layouts")
w:setVisible(true)
system:setGUISheet(w)
--winMgr:getWindow("/Chat/Wnd/Edit"):subscribeEvent("TextAccepted", "chatHandler")

logger:logEvent( "<<< Init script says goodbye" )
