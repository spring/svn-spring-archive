
!ifdef INSTALL
  SetOutPath "$INSTDIR"

  ; Main stuff
  File "..\game\spring.exe"
;  File "..\game\armor.txt"
  Delete "$INSTDIR\armor.txt"
  Delete "$INSTDIR\bagge.fnt"
  Delete "$INSTDIR\hpiutil.dll"
  File "..\game\luxi.ttf"
  File "..\game\selectioneditor.exe"
  
  ; Can be nice and not overwrite these. or not
  SetOverWrite on
  File "..\game\selectkeys.txt"
  File "..\game\uikeys.txt"
  
  SetOverWrite on
  File "..\game\settings.exe"
  File "..\game\settingstemplate.xml"
;  File "..\game\zlib.dll"
  Delete "$INSTDIR\zlib.dll"
  File "..\game\zlibwapi.dll"
  ; File "..\game\7zxa.dll"
  Delete "$INSTDIR\7zxa.dll"
  File "..\game\crashrpt.dll"
  File "..\game\dbghelp.dll"
  File "..\game\devil.dll"
  File "..\game\SDL.dll"
  File "..\game\msvcp71.dll"
  File "..\game\msvcr71.dll"
;  File "..\game\tower.sdu"
  Delete "$INSTDIR\tower.sdu"
  File "..\game\palette.pal"
;  File "..\game\testscript.lua"
;  File "..\game\spawn.txt"
  
  ; Gamedata - stored in springcontent.sdz now. If it's stored on disk then mods can't override it
  Delete "$INSTDIR\gamedata\*.tdf"
  RmDir "$INSTDIR\gamedata"

  ; Bitmaps that are not from TA
 ; SetOutPath "$INSTDIR\bitmaps"
;  File "..\game\bitmaps\*.gif"
;  File "..\game\bitmaps\*.bmp"
;  File "..\game\bitmaps\*.jpg"
;  SetOutPath "$INSTDIR\bitmaps\smoke"
;  File "..\game\bitmaps\smoke\*.bmp"
  
;  SetOutPath "$INSTDIR\bitmaps\tracks"
;  File "..\game\bitmaps\tracks\*.bmp"
  
;  SetOutPath "$INSTDIR\bitmaps\terrain"
;  File "..\game\bitmaps\terrain\*.jpg"
  Delete "$INSTDIR\bitmaps\terrain\*.jpg"
  Rmdir "$INSTDIR\bitmaps\terrain"

  ; All bitmaps are now in archives
  Delete "$INSTDIR\bitmaps\*.bmp"
  Delete "$INSTDIR\bitmaps\*.jpg"
  Delete "$INSTDIR\bitmaps\*.gif"
  Delete "$INSTDIR\bitmaps\smoke\*.bmp"
  Delete "$INSTDIR\bitmaps\tracks\*.bmp"
  RmDir "$INSTDIR\bitmaps\smoke"
  RmDir "$INSTDIR\bitmaps\tracks"
  RmDir "$INSTDIR\bitmaps"

  SetOutPath "$INSTDIR\startscripts"
  File "..\game\startscripts\*.lua"

  SetOutPath "$INSTDIR\shaders"
  File "..\game\shaders\*.fp"
  File "..\game\shaders\*.vp"
  
  SetOutPath "$INSTDIR\AI\Helper-libs"
  File "..\game\AI\Helper-libs\centralbuild.dll"
  File "..\game\AI\Helper-libs\mmhandler.dll"
  File "..\game\AI\Helper-libs\simpleform.dll"
  File "..\game\AI\Helper-libs\radar.dll"
  File "..\game\AI\Helper-libs\mexupgrade.dll"
  File "..\game\AI\Helper-libs\economy.dll"
  File "..\game\AI\Helper-libs\reportidle.dll"
  
  SetOverWrite ifnewer
  SetOutPath "$INSTDIR\AI\Bot-libs"
  File "..\game\AI\Bot-libs\emptyai.dll"
  
  SetOverWrite on
  ; XTA
;  File "..\game\taenheter.ccx"
  SetOutPath "$INSTDIR\base"

;  File "..\game\base\tatextures.sdz"
  Delete "$INSTDIR\base\tatextures.sdz"
  File "..\game\base\tatextures_v062.sdz"

;  File "..\game\base\tacontent.sdz"
  Delete "$INSTDIR\base\tacontent.sdz"

!ifndef SP_UPDATE
  File "..\game\base\otacontent.sdz"
!endif
  File "..\game\base\tacontent_v2.sdz"
  File "..\game\base\springcontent.sdz"
  SetOutPath "$INSTDIR\base\spring"
  Delete "$INSTDIR\base\spring\springdecals_v061.sdz"
  Delete "$INSTDIR\base\spring\springbitmaps_v061.sdz"
  Delete "$INSTDIR\base\spring\springdecals_v062.sdz"
  Delete "$INSTDIR\base\spring\springloadpictures_v061.sdz"
  File "..\game\base\spring\bitmaps.sdz"

  SetOutPath "$INSTDIR\mods"
  File "..\game\mods\xtape.sd7"

  Delete "$INSTDIR\mods\xtapev3.sd7"
  Delete "$INSTDIR\mods\xta_se_v065.sdz"
  Delete "$INSTDIR\mods\xta_se_v064.sdz"
  Delete "$INSTDIR\mods\xta_se_v063.sdz"
  Delete "$INSTDIR\mods\xta_se_v062.sdz"
  Delete "$INSTDIR\mods\xta_se_v061.sdz"
  Delete "$INSTDIR\mods\xta_se_v060.sdz"
  
  ; Stuff to always clean up (from old versions etc)
  Delete "$INSTDIR\taenheter.ccx"
  Delete "$INSTDIR\Utility.dll"
  Delete "$INSTDIR\SpringClient.pdb"
  Delete "$INSTDIR\test.sdf"
  
  Delete "$INSTDIR\maps\*.pe"
  Delete "$INSTDIR\maps\*.pe2"
  
  Delete "$INSTDIR\ClientControls.dll"
  Delete "$INSTDIR\SpringClient.exe"

  
  !insertmacro APP_ASSOCIATE_SPECIAL "sdf" "taspring.demofile" "TA Spring demo file" "$INSTDIR\spring.exe,0" "Open with Spring" "$INSTDIR\spring.exe"
  !insertmacro UPDATEFILEASSOC

!else

  ; Main files
  Delete "$INSTDIR\spring.exe"
;  Delete "$INSTDIR\armor.txt"
  Delete "$INSTDIR\bagge.fnt"
  Delete "$INSTDIR\hpiutil.dll"
  Delete "$INSTDIR\luxi.ttf"
  Delete "$INSTDIR\palette.pal"
  Delete "$INSTDIR\selectioneditor.exe"
  Delete "$INSTDIR\selectkeys.txt"
  Delete "$INSTDIR\uikeys.txt"
  Delete "$INSTDIR\settings.exe"
;  Delete "$INSTDIR\zlib.dll"
  Delete "$INSTDIR\zlibwapi.dll"
;  Delete "$INSTDIR\7zxa.dll"
  Delete "$INSTDIR\crashrpt.dll"
  Delete "$INSTDIR\dbghelp.dll"
  Delete "$INSTDIR\devil.dll"
  Delete "$INSTDIR\SDL.dll"
  Delete "$INSTDIR\MSVCP71.dll"
  Delete "$INSTDIR\MSVCR71.dll"
  Delete "$INSTDIR\tower.sdu"
  Delete "$INSTDIR\palette.pal"
;  Delete "$INSTDIR\spawn.txt"

  ; Shaders
  Delete "$INSTDIR\shaders\*.fp"
  Delete "$INSTDIR\shaders\*.vp"
  RMDir "$INSTDIR\shaders"
  
  ; AI-dll's
  Delete "$INSTDIR\AI\Bot-libs\emptyai.dll"
  RmDir "$INSTDIR\AI\Bot-libs"
  Delete "$INSTDIR\AI\Helper-libs\centralbuild.dll"
  Delete "$INSTDIR\AI\Helper-libs\mmhandler.dll"
  Delete "$INSTDIR\AI\Helper-libs\simpleform.dll"
  Delete "$INSTDIR\AI\Helper-libs\radar.dll"
  Delete "$INSTDIR\AI\Helper-libs\economy.dll"
  Delete "$INSTDIR\AI\Helper-libs\reportidle.dll"
  RMDir "$INSTDIR\AI\Helper-libs"
  RMDir "$INSTDIR\AI"
  
  ; Gamedata
  Delete "$INSTDIR\gamedata\resources.tdf"
  Delete "$INSTDIR\gamedata\explosion_alias.tdf"
  RmDir "$INSTDIR\gamedata"

  ; Startscript
  Delete "$INSTDIR\startscripts\testscript.lua"
  RmDir "$INSTDIR\startscripts"

  ; Maps
  Delete "$INSTDIR\maps\paths\SmallDivide.*"
  ; Delete "$INSTDIR\maps\paths\FloodedDesert.*"
  Delete "$INSTDIR\maps\paths\Mars.*"
  Delete "$INSTDIR\maps\SmallDivide.*"
  Delete "$INSTDIR\maps\FloodedDesert.*"
  Delete "$INSTDIR\maps\Mars.*"
  RmDir "$INSTDIR\maps\paths"
  RMDir "$INSTDIR\maps"

  ; XTA + content
  Delete "$INSTDIR\base\tatextures_v062.sdz"
  Delete "$INSTDIR\base\tacontent_v2.sdz"
  Delete "$INSTDIR\base\otacontent.sdz"
  Delete "$INSTDIR\base\springcontent.sdz"
  Delete "$INSTDIR\mods\xta_se_v066.sdz"
  Delete "$INSTDIR\mods\xtape.sd7"
  Delete "$INSTDIR\base\spring\springbitmaps_v061.sdz"
  Delete "$INSTDIR\base\spring\springdecals_v061.sdz"
  Delete "$INSTDIR\base\spring\springdecals_v062.sdz"
  Delete "$INSTDIR\base\spring\springloadpictures_v061.sdz"
  Delete "$INSTDIR\base\spring\bitmaps.sdz"
  
  RmDir "$INSTDIR\AI\Bot-libs"
  RmDir "$INSTDIR\AI\Helper-libs"
  RmDir "$INSTDIR\AI"
  RmDir "$INSTDIR\base\spring"
  RmDir "$INSTDIR\base"
  RmDir "$INSTDIR\mods"

; Generated stuff from the installer
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  
  ; Generated stuff from running spring
  Delete "$INSTDIR\infolog.txt"
  Delete "$INSTDIR\ext.txt"
;  Delete "$INSTDIR\config.dat"
!endif
