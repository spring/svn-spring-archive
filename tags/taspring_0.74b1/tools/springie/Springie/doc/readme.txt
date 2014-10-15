This springie is for next version of spring (0.74).

If you run it with pre 0.74 spring version make sure you do this before starting a game:
- go into springie menu and set host process priority to normal or lower


Changelog (unfinished)

- added !reload command to manually reload mod and map list. 
- %1 can now be used in game title (will display springie version)
- springie now sets hosting spring process priority, desired level is in settings (main section). Default is "AboveNormal"
- if you try to close springie while hosting a game, new dialog pops up and you can choose to automatically exit as soon as hosted game ends
- allows you to change spring priority on the run from menu
- allows you to hide/show spring hosting window on the run from menu
- allows rehosting and mod reloading from menu
- advanced error handling - you can now setup in config how to handle errors (default is to suppress them and try to resume). Springie also logs all errors to springie_errors.txt and also them to website (http://springie.licho.eu/errors.txt)
- greatly improved mod/map reload speed (=startup speed improved, map reload now almost instant)
- !team and !ally commands added for manual team/ally forcing
- !helpall command added - displays all commands known to springie, sorted by command level 
- you can now set windows size and fullscreen/windowed mode and hide spring window in settings


minor tweaks and bugfixes: 
==========================
- missing map dl% progress report fixed
- game now locks on start (to prevent some minor bugs)
- maplink now never contains space characters - you can always click on it
- default throttling for "!force" added (to avoid spring.exe crash)
- empty admin name causing exception fixed
- empty welcome message causing exception fixed
- fixed exception caused by network disconnect during map search
- all messages by springie to battle lobby are now said as emote (except game chat redirects)
- fixed chat redirect from springie GUI to game
- changes done in battle details settings are now applied instantly
- improved search filtering (listmaps and listmods now always show map/mod numbers as well as name)


=========================
== TODO                ==
=========================
* enforce min rank
* stats 
* presets
* colors
* unit disabling
* http://www.compuphase.com/cmetric.htm
* kickbynum
* springie  - info a verze
* reenable last resort exit check
* banning
* tooltip a nebo status bar with map/players info
