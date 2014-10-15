{
  Project started on: 13/06/2005
  See TASClient.dpr for details.

  For protocol description + notes see TASServer.java (not part of TASClient)!

  ------ LINKS ------
  * http://community.borland.com/soapbox/techvoyage/article/1,1795,10280,00.html
    (object pascal style guide)

  * http://www.latiumsoftware.com/en/delphi/00003.php
    (how to execute application and wait until it is finished but also allowing main app to run meanwhile)

  * http://www.latiumsoftware.com/en/delphi/00024.php
    http://www.delphi3000.com/articles/article_951.asp?SK=
    http://delphi.about.com/od/objectpascalide/l/aa021301c.htm
    (how to embed audio files in .exe and play them)

  * http://delphi.about.com/od/adptips2004/a/bltip0904_3.htm
    (how to catch keys globally in app)

  * http://www.latiumsoftware.com/en/delphi/00004.php
    (how to read/write to registry)

  * http://www.jansfreeware.com/articles/delphiresource.html
    http://www.cpcug.org/user/clemenzi/technical/Languages/Delphi/Resources.html
    (how to load/store data in resource files)

  * http://flags.byodkm.de/
    (world flags - images)

  * http://appsapps.zapto.org/proggies/savesize.txt
    (how to get form's "normal" width, height, left and top values, even when form is maximized)

  * http://delphi.about.com/od/vclusing/l/aa111803a.htm
    (how to add hyperlink functionality to TRichEdit)

  * http://delphi.about.com/od/formsdialogs/l/aa073101b.htm
    (great article on how to change various form's attributes, like changing visibility of form
     in taskbar, form's transparency, etc.)

  * http://www.cpcug.org/user/clemenzi/technical/Languages/RichEdit.htm
    (explains some tricks and shows some problems using Windows API component "RichEdit")
    
  * http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/richedit/richeditcontrols.asp
    (MSDN reference about EM_GETSCROLLPOS and EM_SETSCROLLPOS messages)

  * http://www.elists.org/pipermail/twsocket/2004-March/025141.html
    (about wsoTCPNoDelay option in TWSocket)

  * http://coding.derkeiler.com/Archive/Delphi/borland.public.delphi.language.objectpascal/2003-11/0223.html
    (issue with DecimalSeparator getting changed by WM_WININICHANGE message)

  * http://groups.google.com/group/borland.public.delphi.nativeapi.win32/browse_thread/thread/f5cd2161d871edc9/d7e78910e68dfccf
    (an explanation and code showing how to fix problem with hints and showmessage and alike causing main form to receive
     focus when using taskbar buttons for all forms)

  * http://www.efg2.com/Lab/Library/UseNet/1999/0909.txt
    (MD5 algorithm implementation)

  * http://www.cityinthesky.co.uk/cryptography.html
    (another open-source MD5 implementation and also some other algorithms)

  * http://www.howtodothings.com/viewarticle.aspx?article=490
    (how to get local IP properly. Most of the examples I found on net
    are examples of bad programming, such as http://www.scalabium.com/faq/dct0037.htm.
    It IS important to do WSACleanUp even if some error occured, and also
    checking for WSAStartUp result before doing anything else is good practice)

  * http://www.brynosaurus.com/pub/net/p2pnat/
    http://www.potaroo.net/ietf/idref/draft-ford-natp2p/
    http://www.newport-networks.com/whitepapers/nat-traversal1.html
    (about NAT traversal)

  * http://www.thedelphimagazine.com/samples/1175/article.htm
    http://gp.17slon.com/gp/gptimezone.htm
    (about converting between different time zones. I am using
     this library to convert from UTC to local time)

  * http://users.pandora.be/sonal.nv/ics/faq/TWSocket.html#BroadcastvsMulticastAE
    (how to change send/receive buffer's size with TWSocket)

  ------ WARNING ------
  * Due to a bug in TjanTracker component, thumb is not positioned correctly
    when you open the project (it gets positioned correctly once you run the
    program). If you change its value in design-time, it will get updated
    and thumb will get positioned correctly.
  * TAB characters are delimiters between sentences when command requires more                                                 
    than one parameter of type "sentence". This is why program must replace
    all TABs with spaces, when sending commands with multiple sentences as
    arguments. All messaging commands require only one parameter of type "sentence"
    so there is no need to remove TABs from this messages.
  * Do not to try to load jpeg file into NoMapImage, since it won't work properly
    when assigning TPicture (or TBitmap) object. You must use normal bitmap.
  * "online maps": make sure minimap's (TImage) Top property is assigned last
    when removing maps or reordering them, since minimap is the largest of visual
    components of a map (label and download buttons bottom are higher than minimap's).
    If not, some wierd bug will arise: when being at the bottom of "online maps" page,
    try to remove first item from the list. The last item will not be removed, only
    its label will be moved higher. This is due to vertical scrollbar's position
    being changed when the lowest visual component is being moved up.

  ------ REMEMBER ------
  * when adding new common dialogs (TOpenDialog, TSaveDialog, ...) always manually set Option.ofNoChangeDir to True!
    (if not, current working dir will change and unitsync.dll won't find files since it will use new working dir)
    Also see http://qc.borland.com/wc/qcmain.aspx?d=1282
  * never change ActivePageIndex manually, since it doesn't trigger OnChange event! Always use ChangeActivePageAndUpdate method!
  * team indexes and ally team indexes are not zero-based! They all start at 1. When saved to the script.txt, they get converted
    to zero-based indexes.
  * you can send lines of any length. I've tested it with 600+ KB long strings and it worked (in both directions)
  * modders should put side images within "SidePics" folder in archive file (sdz/sd7). Side images should
    be 16x16, 24-bit BMP files.

  ------ 3RD-PARTY COMPONENTS ------
  - TVirtualStringTree/TVirtualDrawTree, see http://www.lischke-online.de/VirtualTreeview/
  - TjanTracker (modified!) (sources included)
  - TWSocket (ICS), see http://www.overbyte.be/frame_index.html?redirTo=/ssl.html
  - GraphicEx, see http://www.soft-gems.net/Graphics.php
  - RichEditURL (included with these sources. See RichEditURL.pas for more details and links)
  - JEDI Visual Component Library (http://homepages.borland.com/jedi/jvcl/)
  - MD5 algorithm implementation from http://www.efg2.com/Lab/Library/UseNet/1999/0909.txt (included with these sources)
  - SZCodeBaseX 1.3.2 (http://www.szutils.net/Delphi/Delphi.php), included with these sources
  - JvDesktopAlertForm.pas is included with these sources (it's part of JVCL but it's the latest bug fixed version from cvs)  

  ------ MY NOTES ------
  * Don't forget to manually set Scaled property of each new form to FALSE!
  * When creating a patcher, use this registry location for default dir:
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SpringClient.exe
  * Hints are not done yet, currently there could be a problem if hints would use some other font than VDTBattles.Canvas.Font,
    since there is no way to get HintCanvas in OnGetHintSize event. See this post: http://www.lischke-online.de/support/forums/viewtopic.php?t=1124
  * Program may raise all kind of exceptions(errors) on startup if you don't have enough memory available in windows
  * I am not sure if it is wise to use OnlineMaps (TList) in OnlineMapsForm withouth any thread synchronization. It may probably
    cause crashes in some rare cases!
  * Don't forget to override CreateParams method of each new form that is shown as modal form from battle screen!
  * Don't change items order in RichEditPopupMenu, unless you change OnPopup event implementation!
  * Make sure that "locked" property gets set to False when hosting a battle, since server assumes it's set to False.
  * In order to make JclDebug functionality work, here is a short description from JclDebug's readme file:
   1. Close all running instances of Delphi
   2. Install JCL and IDE experts by the JCL Installer
   3. Run Delphi IDE and open your project
   4. Remove any TApplication.OnException handlers from your project (if
      any).
   5. Add new Exception Dialog by selecting File | New | Other ... |
      Dialogs tab, Select 'Exception Dialog' or 'Exception Dialog with
      Send' icon, Click OK button, Save the form (use
      ExceptionDialog.pas name, for example)
   6. Check Project | Insert JCL Debug data menu item
   7. Do Project | Build
  * If position of original clients within client list should be changed, one must make sure that OnDblClick and
    OnDrawItem are accordingly modified!
  * EM_SETSCROLLPOS and EM_GETSCROLLPOS are available only since RichEdit 3.0, so it won't work under WINE in Linux.
    There is an alternative though, search google for EM_GETFIRSTVISIBLELINE message.
  * When adding new NAT traversal methods, modify these methods accordingly:
    + THostBattleForm.JvHostArrowButtonClick(Sender: TObject)
    + THostBattleForm.NATRadioGroupClick(Sender: TObject)
    + THostBattleForm.TryToHostBattle
    + THostBattleForm.TryToHostReplay
    + TBattleForm.GenerateNormalScriptFile(FileName: string)
    + TBattleForm.GenerateReplayScriptFile(FileName: string)
    + TBattleForm.OnStartGameMessage(var Msg: TMessage)

  ------ CHANGELOG ------

  *** 0.22 (??x??x??) ***
  * added keyword highlighting + notifications (options->program->highlights)
  * added /ping command
  * added ability to lock channels (pass key with join command to join locked channel)
  * /list command now returns more detailed channel list
  *** 0.21 (27x02x06) ***
  * fixed splash screen sometimes not dissappearing after program has loaded
  * increased send/recv buffer sizes (will hopefully fix some of the timeout issues)
  * fixed auto-complete feature
  *** 0.20 (25x02x06) ***
  * fixed updating "online maps" for people using a HTTP proxy
  * added simple auto-complete feature similar to the one used in mIRC (press TAB to auto-complete player's name)
  * password can now be changed using /password command
  * use /ingame to find out your in-game time
  * added option to lock game speed
  * fixed map info not getting updated on map changing to "none"
  * added /chanmsg command for moderators
  * fixed small problem with double-clicking on player not always working
  * increased program loading speed (replays and "online maps" are now loaded in background threads) 
  *** 0.195 (23x01x06) ***
  * fixed serious bug with hosting replays (non-host players would always crash with I/O error 103)
  * "game options" in battle form are now restored on program start
  * added "load default" and "set as default" buttons to quickly save/load all battle settings when hosting
  * added HTTP proxy settings to option pages (this will solve problems some people were having downloading maps and updates)
  *** 0.194 (19x01x06) ***
  * fixed serious bug with disabled units list being loaded causing access violation exceptions
    on changing map or not launching spring upon starting the game.
  * host can now select type of NAT traversal method
  * fixed bug with "online maps" in some rare cases pointing to wrong or invalid address
  * "online maps" are ordered aphabetically now
  * added "perform" list (Options->Server->Perform)
  * added option to update mod list from within the lobby (you don't have to restart the lobby anymore when adding new mods)       
  *** 0.193 ***
  * fixed serious bug with sorting battles as game would not start for all players or would start randomly for some
  * fixed some freezing bug when auto-updating client 
  *** 0.192 ***
  * added battle list sorting
  * fixed serious bug which caused "ambigious commands" popup upon connecting to server in case there were roughly more
    than 100 people connected
  * other minor changes and fixes
  *** 0.19 ***
  * battle hosts can now use /ring <username> command on players participating in their battles
  * fixed problem with notification dialog switching focus back to application
  * added /rename command which will rename your account (so that people who wish to add clan tags in front
    of their names don't have to reregister and lose their ranks). Player names may now also contain
    "[" and "]" characters.
  * fixed small bug in demo script parser
  * added /mute, /unmute and /mutelist commands for admins/mods
  *** 0.182 ***
  * fixed serious bug with mod sides not being loaded when user joined battle, if he didn't host the mod before that
  *** 0.181 ***
  * fixed serious bug with not accepting UPDATEBATTLEDETAILS commands
  *** 0.18 (24x11x05) ***
  * added "ghosted buildings" option
  * added multiple mod side support (modders should put side images
    into lobby/sidepics folder as 24-bit bitmap files)
  * improved hosting so that now practically anyone can host withouth forwarding
    any ports on the router. Also removed "custom udp source port" option since
    it is irrelevant now.
  * passwords are now sent to server in encoded form (MD5 hash code)
  * fixed bug in "online maps" when updater stopped responding in certain cases  
  *** 0.17 (08x11x05) ***
  * fixed network code (multiplayer replays should work now)
  * "online maps" are now updated only as needed
  * fixed some minor issues
  *** 0.161 (13x10x05) ***
  * fixed problem with application not minimizing if taskbar buttons were enabled
  * fixed problem with saving comments to demo file. Note: comments created with previous version will
    raise an "error parsing file" error when trying to watch the replay (comments should be saved
    again with new version to avoid this error).
  * temporarily disabled multiplayer replay feature due to some issues with it (probably until next update).  
  *** 0.16 (11x10x05) ***
  * added ability to add comments and grades to replays
  * added "diminishing metal maker returns" host option
  * added option for host to lock battle
  * added logging support
  * added ability to save and load disabled unit selection
  * added notifications (desktop alert popup plus sound)
  * added more advanced exception handling using JclDebug
  * fixed custom sides for bots
  * fixed minor problem with focus shifting from forms with taskbar buttons to main form
  * fixed "dancing options" bug, which happened if user lagged a lot and if he changed various battle
    parameters very fast.
  * added support for multiplayer replays
  * "online maps" are now updated directly from fileuniverse.com  
  *** 0.152 (24x09x05) ***
  * added option to add taskbar buttons for all forms
  * changed wsoTCPNoDelay to True. This could resolve some of the timeout issues.
  * added "Auto scroll" option to rich edit controls (right-click on the rich edit and choose Auto scroll)
  * fixed problem with DecimalSeparator getting overwritten with WM_WININICHANGE message in some cases.
  * fixed freezing bug on "loading mod ...", this time in unitsync.dll
  * added support for custom sides
  *** 0.151 (12x09x05) ***
  * fixed crashing bug when using startrects
  * fixed issue when client crashed upon start if it couldn't read CPU info from registry
  * fixed bug in detecting CPU speed for some older AMD processors
  * added popup hints displaying player's full country name
  * fixed "400 BAD REQUEST" bug when trying to download maps with spaces in the name
  * reduced starting-up time a bit. Still, having "online maps" cached adds some time to the loading procedure.
  * fixed problem with launching patch file
  *** 0.15 (11x09x05) ***
  * program now remembers the last mod used
  * added IP-to-country support
  * fixed problem with saving maximized form's width, size, top and left properties to registry
  * added "sort by name" as secondary sorting criterion (for example, if players are sorted by rank, players with same rank will be sorted by name)
  * added unlimited command history buffer (edit boxes now remember all commands that you typed)
  * maps in battle list which you do not have are now colored in red
  * added popup hints to battle list
  * added KICK command to battle screen (type /KICK username to kick user)
  * added hyperlink functionality to chat windows (it detects prefixes such as "http:", "file:", "mailto:", "ftp", ...)
  * added CPU tag support (in battle screen only)
  * added start rectangles support (see HELP for more info)
  * other minor changes
  *** 0.141 (30x08x05) ***
  * fixed "more maps" label pointing to wrong web location
  * added explanation of ranking system to help screen
  * client now closes itself before updating, so that you don't have to restart windows anymore
    (for the changes to take effect).
  *** 0.14 (29x08x05) ***
  * added DELETE button to Replays window
  * change the way preferences are saved - from now on they are saved to registry (HKEY_CURRENT_USER\Software\TASClient)
    and no longer to config.dat
  * added various form info to registry (size, position, splitter state, etc.) so that now program restores previous form's state
  * added "more mods" label
  * added "Reload map list" button since noone seem to notice popup menu when clicking with right mouse button on the map list
  * all forms are now non-scalable, so people using large fonts in windows shouldn't have any more problems (hopefully)
  * added ability to force change team color
  * added ability to sort players in channels (by name, status and rank)
  * fixed bug when client sometimes disconnected from server right after connection was established due to client not remembering
    correctly when was the last time data has been received from server
  * added ranking system
  * fixed issue (again) with client freezing when joining battle in certain cases.
  *** 0.13 (25x08x05) ***
  * added ability to watch replays within the lobby ("REPLAYS" button)
  * added custom UDP source port support
  * added AI support
  * added "GAME SETTINGS" button in preferences screen (it launches settings.exe)
  * player list in battle screen is now double-buffered (it no longer "blinks")
  *** 0.121 (??x??x??) ***
  * added auto connect on startup option
  * fixed issue with lobby freezing when joining a battle (in certain cases)
  * player list box is now double-buffered (no longer blinks)
  * other minor changes (clear window (popup menu), ...)
  *** 0.12 (14x08x05) ***
  * fixed away status not being updated to "normal" when participating in a battle (also "away" is not drawn anymore
    for players who are in-game)
  * fixed one serious bug: when there were spectators in the battle, the lobby would crash for the host when he pressed
    START button
  * added SHIFT+CTRL+H button to open host dialog directly from main screen
  * game is launched by "OnMessage" event now, no longer directly from GUI
  * added splitter to battle screen in player list, it can be resized now (so that all players can fit in the list)
  * added support for commands: SERVERMSG, SERVERMSGBOX
  * other minor changes
  *** 0.11 (13x08x05) ***
  * added SHIFT+CTRL+B shortcut to switch to battle screen and back
  * when joining a channel the name of the channel is changed to lower-case so that players
    don't go into different channels by entering #xta, #XTA or #Xta, for example (channel
    names are case-sensitive, as well as player names).
  * removed EOL type option, from now I manually parse incoming data, so that I can detect any kind of EOL
  * added HELP screen
  * added away status
  * fixed: when client connected to battle with map which he didn't have, it would not switch to "no map" picture
  * client no longer sends join command if user clicked CANCEL when trying to enter passworded game
  * client is no longer allowed to join battle if it is in progress
  * fixed small issue when player joining a full battle as a spectator. Host did not update battle status
    to match the correct number of spectators (instead the player who just joined was seen as a normal
    player to outside players, and not as a spectator).
  * when generating script.txt file, "hostip=" line is now "localhost" if you are hosting a battle. All other
    players assign your "outside" (internet) IP/address. I am not sure if that is to fix anything or even broke
    anything?
  * added "/PART" command
  *** 0.10 (11x08x05) ***
  * first public release

}

{ see "$DEFINE DONTUSETTL2" in Misc.pas! }
{ use TTL=2 when sending udp packets to keep ports open? Currently disabled because some players may be
  behind several layers of NAT and packets with TTL=2 may never reach those routers. }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus, Grids, ValEdit,
  VirtualTrees, ImgList, WSocket, StringParser, MMSystem, Utility, AppEvnts, Math,
  PasswordDialogUnit, HttpProt, GraphicEx, Registry, JvComponent,
  JvBaseDlg, JvDesktopAlert, JvDesktopAlertForm, DateUtils, Winsock;

const
  CountryNames: array[0..240] of string = (
  'Unknown country xx',
  'AFGHANISTAN af',
  'ALBANIA al',
  'ALGERIA dz',
  'AMERICAN SAMOA as',
  'ANDORRA ad',
  'ANGOLA ao',
  'ANGUILLA ai',
  'ANTARCTICA aq',
  'ANTIGUA AND BARBUDA ag',
  'ARGENTINA ar',
  'ARMENIA am',
  'ARUBA aw',
  'AUSTRALIA au',
  'AUSTRIA at',
  'AZERBAIJAN az',
  'BAHAMAS bs',
  'BAHRAIN bh',
  'BANGLADESH bd',
  'BARBADOS bb',
  'BELARUS by',
  'BELGIUM be',
  'BELIZE bz',
  'BENIN bj',
  'BERMUDA bm',
  'BHUTAN bt',
  'BOLIVIA bo',
  'BOSNIA AND HERZEGOWINA ba',
  'BOTSWANA bw',
  'BOUVET ISLAND bv',
  'BRAZIL br',
  'BRITISH INDIAN OCEAN TERRITORY io',
  'BRUNEI DARUSSALAM bn',
  'BULGARIA bg',
  'BURKINA FASO bf',
  'BURUNDI bi',
  'CAMBODIA kh',
  'CAMEROON cm',
  'CANADA ca',
  'CAPE VERDE cv',
  'CAYMAN ISLANDS ky',
  'CENTRAL AFRICAN REPUBLIC cf',
  'CHAD td',
  'CHILE cl',
  'CHINA cn',
  'CHRISTMAS ISLAND cx',
  'COCOS (KEELING) ISLANDS cc',
  'COLOMBIA co',
  'COMOROS km',
  'CONGO, Democratic Republic of (was Zaire) cd',
  'CONGO, People''s Republic of cg',
  'COOK ISLANDS ck',
  'COSTA RICA cr',
  'COTE D''IVOIRE ci',
  'CROATIA (local name: Hrvatska) hr',
  'CUBA cu',
  'CYPRUS cy',
  'CZECH REPUBLIC cz',
  'DENMARK dk',
  'DJIBOUTI dj',
  'DOMINICA dm',
  'DOMINICAN REPUBLIC do',
  'EAST TIMOR tl',
  'ECUADOR ec',
  'EGYPT eg',
  'EL SALVADOR sv',
  'EQUATORIAL GUINEA gq',
  'ERITREA er',
  'ESTONIA ee',
  'ETHIOPIA et',
  'FALKLAND ISLANDS (MALVINAS) fk',
  'FAROE ISLANDS fo',
  'FIJI fj',
  'FINLAND fi',
  'FRANCE fr',
  'FRANCE, METROPOLITAN fx',
  'FRENCH GUIANA gf',
  'FRENCH POLYNESIA pf',
  'FRENCH SOUTHERN TERRITORIES tf',
  'GABON ga',
  'GAMBIA gm',
  'GEORGIA ge',
  'GERMANY de',
  'GHANA gh',
  'GIBRALTAR gi',
  'GREECE gr',
  'GREENLAND gl',
  'GRENADA gd',
  'GUADELOUPE gp',
  'GUAM gu',
  'GUATEMALA gt',
  'GUINEA gn',
  'GUINEA-BISSAU gw',
  'GUYANA gy',
  'HAITI ht',
  'HEARD AND MC DONALD ISLANDS hm',
  'HONDURAS hn',
  'HONG KONG hk',
  'HUNGARY hu',
  'ICELAND is',
  'INDIA in',
  'INDONESIA id',
  'IRAN (ISLAMIC REPUBLIC OF) ir',
  'IRAQ iq',
  'IRELAND ie',
  'ISRAEL il',
  'ITALY it',
  'JAMAICA jm',
  'JAPAN jp',
  'JORDAN jo',
  'KAZAKHSTAN kz',
  'KENYA ke',
  'KIRIBATI ki',
  'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF kp',
  'KOREA, REPUBLIC OF kr',
  'KUWAIT kw',
  'KYRGYZSTAN kg',
  'LAO PEOPLE''S DEMOCRATIC REPUBLIC la',
  'LATVIA lv',
  'LEBANON lb',
  'LESOTHO ls',
  'LIBERIA lr',
  'LIBYAN ARAB JAMAHIRIYA ly',
  'LIECHTENSTEIN li',
  'LITHUANIA lt',
  'LUXEMBOURG lu',
  'MACAU mo',
  'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF mk',
  'MADAGASCAR mg',
  'MALAWI mw',
  'MALAYSIA my',
  'MALDIVES mv',
  'MALI ml',
  'MALTA mt',
  'MARSHALL ISLANDS mh',
  'MARTINIQUE mq',
  'MAURITANIA mr',
  'MAURITIUS mu',
  'MAYOTTE yt',
  'MEXICO mx',
  'MICRONESIA, FEDERATED STATES OF fm',
  'MOLDOVA, REPUBLIC OF md',
  'MONACO mc',
  'MONGOLIA mn',
  'MONTSERRAT ms',
  'MOROCCO ma',
  'MOZAMBIQUE mz',
  'MYANMAR mm',
  'NAMIBIA na',
  'NAURU nr',
  'NEPAL np',
  'NETHERLANDS nl',
  'NETHERLANDS ANTILLES an',
  'NEW CALEDONIA nc',
  'NEW ZEALAND nz',
  'NICARAGUA ni',
  'NIGER ne',
  'NIGERIA ng',
  'NIUE nu',
  'NORFOLK ISLAND nf',
  'NORTHERN MARIANA ISLANDS mp',
  'NORWAY no',
  'OMAN om',
  'PAKISTAN pk',
  'PALAU pw',
  'PALESTINIAN TERRITORY, Occupied ps',
  'PANAMA pa',
  'PAPUA NEW GUINEA pg',
  'PARAGUAY py',
  'PERU pe',
  'PHILIPPINES ph',
  'PITCAIRN pn',
  'POLAND pl',
  'PORTUGAL pt',
  'PUERTO RICO pr',
  'QATAR qa',
  'REUNION re',
  'ROMANIA ro',
  'RUSSIAN FEDERATION ru',
  'RWANDA rw',
  'SAINT KITTS AND NEVIS kn',
  'SAINT LUCIA lc',
  'SAINT VINCENT AND THE GRENADINES vc',
  'SAMOA ws',
  'SAN MARINO sm',
  'SAO TOME AND PRINCIPE st',
  'SAUDI ARABIA sa',
  'SENEGAL sn',
  'SEYCHELLES sc',
  'SIERRA LEONE sl',
  'SINGAPORE sg',
  'SLOVAKIA (Slovak Republic) sk',
  'SLOVENIA si',
  'SOLOMON ISLANDS sb',
  'SOMALIA so',
  'SOUTH AFRICA za',
  'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS gs',
  'SPAIN es',
  'SRI LANKA lk',
  'ST. HELENA sh',
  'ST. PIERRE AND MIQUELON pm',
  'SUDAN sd',
  'SURINAME sr',
  'SVALBARD AND JAN MAYEN ISLANDS sj',
  'SWAZILAND sz',
  'SWEDEN se',
  'SWITZERLAND ch',
  'SYRIAN ARAB REPUBLIC sy',
  'TAIWAN tw',
  'TAJIKISTAN tj',
  'TANZANIA, UNITED REPUBLIC OF tz',
  'THAILAND th',
  'TOGO tg',
  'TOKELAU tk',
  'TONGA to',
  'TRINIDAD AND TOBAGO tt',
  'TUNISIA tn',
  'TURKEY tr',
  'TURKMENISTAN tm',
  'TURKS AND CAICOS ISLANDS tc',
  'TUVALU tv',
  'UGANDA ug',
  'UKRAINE ua',
  'UNITED ARAB EMIRATES ae',
  'UNITED KINGDOM gb',
  'UNITED STATES us',
  'UNITED STATES MINOR OUTLYING ISLANDS um',
  'URUGUAY uy',
  'UZBEKISTAN uz',
  'VANUATU vu',
  'VATICAN CITY STATE (HOLY SEE) va',
  'VENEZUELA ve',
  'VIET NAM vn',
  'VIRGIN ISLANDS (BRITISH) vg',
  'VIRGIN ISLANDS (U.S.) vi',
  'WALLIS AND FUTUNA ISLANDS wf',
  'WESTERN SAHARA eh',
  'YEMEN ye',
  'YUGOSLAVIA yu',
  'ZAMBIA zm',
  'ZIMBABWE zw'
  );

  AmbiguousErrorMessages: array[0..12] of string = (
  '0 REDIRECT: bad arguments',
  '1 JOINFAILED: bad arguments',
  '2 OFFERFILE: bad arguments',
  '3 UDPSOURCEPORT: bad arguments',
  '4 CLIENTSOURCEPORT: bad arguments',
  '5 CLIENTSOURCEPORT: invalid client',
  '6 HOSTPORT: bad arguments',
  '7 HOSTPORT: battle not active',
  '8 ADDUSER: bad arguments',
  '9 REMOVEUSER: bad arguments',
  '10 ADDBOT: bad arguments',
  '11 ADDBOT: battle not active',
  '12 ADDBOT: invalid battle'
  // not quite finished yet
  );


type
  TColors = record
    Normal: TColor;
    Data: TColor; // on receive/send string (in debug mode only)
    Error: TColor;
    Info: TColor;
    MinorInfo: TColor; // less important information
    ChanJoin: TColor; // joined channel message color
    ChanLeft: TColor; // left channel message color
    MOTD: TColor;
    SayEx: TColor; // when user tries to say something in "/me" irc style
    Topic: TColor; // channel's topic text color
  end;

const
  Colors: TColors = (Normal:clBlack; Data: clGreen; Error:clRed; Info:clBlue; MinorInfo: clNavy; ChanJoin: clGreen; ChanLeft: clNavy; MOTD: clMaroon; SayEx: clPurple; Topic: clMaroon);


const
  VERSION_NUMBER = '0.22'; // Must be float value! (with a period as a decimal seperator)
  PROGRAM_VERSION = 'TASClient ' + VERSION_NUMBER;
  KEEP_ALIVE_INTERVAL = 10000; // in milliseconds. Tells us what should be the maximum "silence" time before we send a ping to the server.
  ASSUME_TIMEOUT_INTERVAL = 30000; // in milliseconds. Must be greater than KEEP_ALIVE_INTERVAL! If server hasn't send any data to us within this interval, then we assume timeout occured. It's us who must make sure we get constant replies from server by pinging it.
  LOCAL_TAB = '$Local'; // caption of main (command) tab window. Must be special so that is different from channel names or user names, that is why there is a "$" in front of it.
  SUPPORTED_SERVER_VERSIONS: array[0..0] of string = ('0.22'); // client can connect ONLY to server with one of these version numbers
  EOL = #13#10;

  LOG_FILENAME = 'log.txt';
  MODS_PAGE_LINK = 'http://www.fileuniverse.com/?page=listing&ID=92';
  WIKI_PAGE_LINK = 'http://taspring.clan-sy.com/wiki/Main_Page';
  AWAY_TIME = 30000; // in milliseconds. After this period of time (of inactivity), client will set its state to "away"
  LOBBY_FOLDER = 'lobby'; // main folder for lobby, in which all other folders are put (logs, cache, var, ...)
  CACHE_FOLDER = LOBBY_FOLDER + '\' + 'cache'; // we store images of minimaps in it (see OnlineMapsForm)
  LOG_FOLDER = LOBBY_FOLDER + '\' + 'logs'; // this is where we store chat logs to
  VAR_FOLDER = LOBBY_FOLDER + '\' + 'var';
  FIRST_UDP_SOURCEPORT = 8300; // udp source port (used with "fixed source ports" NAT traversal technique) of the second (first one is host) client in clients list of the battle. Third client uses this+1 port, fourth one this+2, etc.

  WM_DATAHASARRIVED = WM_USER + 0; // used when processing data received through socket
  WM_OPENOPTIONS = WM_USER + 1; // used to open OPTIONS dialog
  WM_DOREGISTER = WM_USER + 2 ; // sent when user clicks on REGISTER button
  WM_CLOSETAB = WM_USER + 3; // used when user presses CTRL+W to close tab
  WM_STARTGAME = WM_USER + 4; // used to launch spring.exe
  WM_CONNECT = WM_USER + 5; // used to simulate ConnectButton.OnClick event
  WM_STARTDOWNLOAD = WM_USER + 6; // used together with HttpGetForm. Before dispatching this message, you have to fill out all fields of DownloadFile record
  WM_STARTDOWNLOAD2 = WM_USER + 7; // used internally by HttpGetForm
  WM_FORCERECONNECT = WM_USER + 8; // used to force reconnect to server (when REDIRECT command is received, for example, or when we try to connect to next backup host if current one failed)
  WM_UDP_PORT_ACQUIRED = WM_USER + 9; // used when received UDPSOURCEPORT command from the server

  QUEUE_LENGTH = 4096;

  Ranks: array[0..4] of string = ('Newbie', 'Beginner', 'Average', 'Experienced', 'Highly experienced');

type

  TMyTabSheet = class(TTabSheet)
  public
    Clients: TList; // do not free any of the clients in this list! See AllClients list's comments
    History: TStringList; // here we store everything user has typed in. User can access it by pressing UP/DOWN keys
    HistoryIndex: Integer;
    AutoScroll: Boolean; // if true, we will scroll rich edit to the new line added
    LogFile: TFileStream;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    procedure WndProc(var Msg: TMessage); override;
  end;

  TClient = class
  public
    Name: string; // client's username
    Status: Integer; // client's status (normal, in game)
    BattleStatus: Integer; // only used for clients participating in the same battle as the player
    InBattle: Boolean; // is this client participating in a battle?
    Country: string; // two-character country code based on ISO 3166
    CPU: Integer; // CPU's speed in MHz (or equivalent if AMD). Value of 0 means that client couldn't figure out its CPU speed.
    IP: string;
    PublicPort: Integer; // client's public UDP source port. Used with NAT traversing (e.g. "hole punching")

    constructor Create(Name: string; Status: Integer; Country: string; CPU: Integer; IP: string);

    // following functions extract various values from BattleStatus:
    function GetReadyStatus: Boolean;
    function GetTeamNo: Integer;
    function GetAllyNo: Integer;
    function GetMode: Integer; // 0 - spectator, 1 - normal player. Also see server protocol description!
    function GetHandicap: Integer;
    function GetTeamColor: Integer;
    function GetSync: Integer;
    function GetSide: Integer;

    // following methods assign various values to BattleStatus:
    procedure SetSide(Side: Integer);
    procedure SetReadyStatus(Ready: Boolean);
    procedure SetTeamNo(Team: Integer);
    procedure SetAllyNo(Ally: Integer);
    procedure SetMode(Mode: Integer);
    procedure SetHandicap(Handicap: Integer);
    procedure SetTeamColor(Color: Integer);
    procedure SetSync(Sync: Integer);

    function GetStateImageIndex: Integer; // returns index of image in PlayerStateImageList

    // following methods assign/extract information to/from Status:
    function GetInGameStatus: Boolean;
    function GetAwayStatus: Boolean;
    function GetRank: Byte;
    function GetAccess: Boolean;
    procedure SetInGameStatus(InGame: Boolean);
    procedure SetAwayStatus(Away: Boolean);

  end;

  TBot = class
  public
    Name: string;
    OwnerName: string;
    AIDll: string;
    BattleStatus: Integer;

    procedure Assign(Bot: TBot); // copies all properties of Bot to this Bot
    constructor Create(Name: string; OwnerName: string; AIDll: string);

    // following functions extract various values from BattleStatus:
    function GetTeamNo: Integer;
    function GetAllyNo: Integer;
    function GetHandicap: Integer;
    function GetTeamColor: Integer;
    function GetSide: Integer;

    // following methods assign various values to BattleStatus:
    procedure SetSide(Side: Integer);
    procedure SetTeamNo(Team: Integer);
    procedure SetAllyNo(Ally: Integer);
    procedure SetHandicap(Handicap: Integer);
    procedure SetTeamColor(Color: Integer);
  end;

  TBattle = class
  public
    ID: Integer; // each battle is identified by its unique ID (server provides us with ID for each battle)
    BattleType: Integer; // 0 = normal battle, 1 = battle replay
    NATType: Integer; // 0 = none (denotes NAT traversal technique used by the host)
    Node: PVirtualNode; // link (pointer) to node in TVirtualDrawTree
    Clients: TList; // clients that are in this battle (similar to clients in a channel). First client in this list is battle's founder! Never free any of the clients in this list! See AllClients list's comments!
    Bots: TList; // bots in this battle.
    RankLimit: Shortint; // if 0, no rank limit is set. If 1 or higher, only players with this rank (or higher) can join the battle (Note: rank index 1 means seconds rank, not the first one, since you can't limit game to players of the first rank because that means game is open to all players and you don't have to limit it in that case)

    Description: string;
    Map: String;
    SpectatorCount: Integer; // how many spectators are there in this battle
    Password: Boolean; // is this battle password-protected?
    IP: string;
    Port: Integer;
    MaxPlayers: Integer;
    ModName: string; // name of the mod used in this battle
    HashCode: Integer;
    Locked: Boolean; // if true, battle is locked, meaning noone can join it anymore (until lock is released by host of the battle)

    constructor Create;
    destructor Destroy; override;
    function AreAllClientsReady: Boolean;
    function AreAllClientsSynced: Boolean;
    function AreAllBotsSet: Boolean;
    function IsBattleFull: Boolean;
    function IsBattleInProgress: Boolean;
    function GetState: Integer; // use it to get index of image from BattleStatusImageList
    function ClientsToString: string; // returns user names in a string, separated by spaces
    function GetClient(Name: string): TClient;
    function GetBot(Name: string): TBot;
    procedure RemoveAllBots;
  end;

  TScript = class // note: any TScript's method will raise an exception if something goes wrong
  private
    FScript: string;
    FUpperCaseScript: string;
    procedure SetScript(Script: string);
  public
    constructor Create(Script: string);
    function DoesTokenExist(Token: string): Boolean;
    function ReadMapName: string;
    function ReadModName: string;
    function ReadStartMetal: Integer;
    function ReadStartEnergy: Integer;
    function ReadMaxUnits: Integer;
    function ReadStartPosType: Integer;
    function ReadGameMode: Integer;
    function ReadLimitDGun: Boolean;
    function ReadDiminishingMMs: Boolean;
    function ReadGhostedBuildings: Boolean;
    procedure ChangeHostIP(NewIP: string);
    procedure ChangeHostPort(NewPort: string);
    procedure ChangeMyPlayerNum(NewNum: Integer);
    procedure ChangeNumPlayers(NewNum: Integer);
    procedure AddLineToPlayer(Player: Integer; Line: string);
    procedure AddSpectatorAfterAnotherPlayer(AnotherPlayer: Integer; NewPlayer: Integer; Nickname: string);
    procedure AddLineAfterStart(Line: string);
    procedure RemoveLineAtChar(CharIndex: Integer); // will remove line where char is located. Char must not be part of EOL!
    procedure TryToRemoveUDPSourcePort;

    property Script: string read FSCript write SetScript;
  end;

  TReplay = class
  public
    Grade: Byte; // 0..10 (where 0 is unrated/unknown)
    FileName: string;
    FullFileName: string;
  end;

  TMainForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Splitter2: TSplitter;
    PageControl1: TPageControl;
    Panel4: TPanel;
    ConnectButton: TSpeedButton;
    ButtonImageList: TImageList;
    ClientsListBox: TListBox;
    Bevel1: TBevel;
    PlayersLabel: TLabel;
    PlayerStateImageList: TImageList;
    ConnectionStateImageList: TImageList;
    OptionsSpeedButton: TSpeedButton;
    Socket: TWSocket;
    KeepAliveTimer: TTimer;
    BattleScreenSpeedButton: TSpeedButton;
    SideImageList: TImageList;
    ReadyStateImageList: TImageList;
    BattleStatusImageList: TImageList;
    VDTBattles: TVirtualDrawTree;
    SyncImageList: TImageList;
    ApplicationEvents1: TApplicationEvents;
    OpenDialog1: TOpenDialog;
    HelpButton: TSpeedButton;
    RichEditPopupMenu: TPopupMenu;
    Clearwindow1: TMenuItem;
    ReplaysButton: TSpeedButton;
    RanksImageList: TImageList;
    SortLabel: TLabel;
    SortPopupMenu: TPopupMenu;
    Nosorting1: TMenuItem;
    Sortbyname1: TMenuItem;
    Sortbystatus1: TMenuItem;
    Sortbyrank1: TMenuItem;
    Sortbycountry1: TMenuItem;
    AutoScroll1: TMenuItem;
    GradesImageList: TImageList;
    DefaultSideImage: TImage;
    DefaultArmImage: TImage;
    DefaultCoreImage: TImage;
    BattleSortPopupMenu: TPopupMenu;
    Nosorting2: TMenuItem;
    Sortbystatus2: TMenuItem;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;

    procedure OnDataHasArrivedMessage(var Msg: TMessage); message WM_DATAHASARRIVED;
    procedure OnOpenOptionsMessage(var Msg: TMessage); message WM_OPENOPTIONS;
    procedure OnDoRegisterMessage(var Msg: TMessage); message WM_DOREGISTER;
    procedure OnCloseTabMessage(var Msg: TMessage); message WM_CLOSETAB;
    procedure OnConnectMessage(var Msg: TMessage); message WM_CONNECT;
    procedure OnForceReconnectMessage(var Msg: TMessage); message WM_FORCERECONNECT;
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey; var Handled: Boolean);
    function LoadImagesDynamically: Boolean;

    procedure InitializeFlagBitmaps;
    procedure DeinitializeFlagBitmaps;
    function GetFlagBitmap(Country: string): TBitmap; // Country must contain two-letter country code (for example: "si" for Slovenia)
    function GetCountryName(CountryCode: string): string;

    function OpenLog(FileName: string): TFileStream;
    procedure CloseAllLogs; // closes all file streams for channels, private chats and battle log
    procedure OpenAllLogs;
    procedure TryToAddLog(f: TFileStream; Line: string);

    function AreWeLoggedIn: Boolean;

    function AddTabWindow(Caption: string): Integer;
    function GetTabWindowPageIndex(Caption: string): Integer;
    procedure ChangeActivePageAndUpdate(PageControl: TPageControl; PageIndex: Integer); // never change ActivePageIndex manually, since it doesn't trigger OnChange event!
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function CheckServerVersion(ServerVersion: string): Boolean;
    procedure ProcessCommand(s: string; CameFromBattleScreen: Boolean);
    procedure ProcessRemoteCommand(s: string); // processes command received from server
    procedure TryToCloseTab(TabSheet: TMyTabSheet);
    procedure OpenPrivateChat(ClientName: string);

    function AddClientToTab(Tab: TMyTabSheet; ClientName: string): Boolean;
    function RemoveClientFromTab(Tab: TMyTabSheet; ClientName: string): Boolean;
    procedure RemoveAllClientsFromTab(Tab: TMyTabSheet);
    procedure UpdateClientsListBox;

    function AddBattle(ID: Integer; BattleType: Integer; NATType: Integer; Founder: TClient; IP: string; Port: Integer; MaxPlayers: Integer; Password: Boolean; Rank: Byte; MapName: string; MapTitle: string; ModName: string): Boolean;
    function RemoveBattle(ID: Integer): Boolean;
    function RemoveBattleByIndex(Index: Integer): Boolean;
    function GetBattle(ID: Integer): TBattle;

    procedure ClearAllClientsList;
    procedure ClearClientsLists; // clears all clients list (in channels, private chats, battle, local tab, ...)
    procedure AddClientToAllClientsList(Name: string; Status: Integer; Country: string; CPU: Integer; IP: string);
    function RemoveClientFromAllClientsList(Name: string): Boolean;
    function GetClient(Name: string): TClient; // returns nil if not found
    function GetClientIndexEx(Name: string; ClientList: TList): Integer;

    function GetBot(Name: string; Battle: TBattle): TBot;

    procedure TryToConnect;
    procedure TryToConnectToNextBackup;
    procedure TryToDisconnect;
    procedure TryToSendData(s: string);
    procedure TryToLogin(Username, Password: string);
    procedure TryToRegister(Username, Password: string); // try to register new account
    procedure TryToAutoCompleteClientName(Edit: TEdit; Clients: TList);

    procedure SortClientsList(List: TList; SortStyle: Byte);
    procedure SortBattlesList(SortStyle: Byte);
    function CompareClients(Client1: TClient; Client2: TClient; SortStyle: Byte): Shortint; // used with SortClientsList method (and other methods?)
    function CompareBattles(Battle1, Battle2: TBattle; SortStyle: Byte): Shortint;
    procedure SortBattleInList(Index: Integer; SortStyle: Byte);
    procedure SortLabelClick(Sender: TObject);

    procedure AddNotification(HeaderText, MessageText: string; DisplayTime: Integer);

    procedure FormCreate(Sender: TObject);
    procedure PageControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClientsListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ConnectButtonClick(Sender: TObject);
    procedure OptionsSpeedButtonClick(Sender: TObject);
    procedure SocketChangeState(Sender: TObject; OldState,
      NewState: TSocketState);
    procedure SocketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure FormDestroy(Sender: TObject);
    procedure KeepAliveTimerTimer(Sender: TObject);
    procedure SocketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure PageControl1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClientsListBoxDblClick(Sender: TObject);
    procedure ClientsListBoxMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BattleScreenSpeedButtonClick(Sender: TObject);
    procedure SocketLineLimitExceeded(Sender: TObject; RcvdLength: Integer;
      var ClearData: Boolean);
    procedure VDTBattlesDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure VDTBattlesInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VDTBattlesGetNodeWidth(Sender: TBaseVirtualTree;
      HintCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      var NodeWidth: Integer);
    procedure VDTBattlesChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VDTBattlesDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HelpButtonClick(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure Clearwindow1Click(Sender: TObject);
    procedure ReplaysButtonClick(Sender: TObject);
    procedure SortMenuItemClick(Sender: TObject);
    procedure BattleSortMenuItemClick(Sender: TObject);
    procedure VDTBattlesGetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure VDTBattlesDrawHint(Sender: TBaseVirtualTree;
      HintCanvas: TCanvas; Node: PVirtualNode; R: TRect;
      Column: TColumnIndex);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure ClientsListBoxMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure RichEditPopupMenuPopup(Sender: TObject);
    procedure AutoScroll1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AddMainLog(Text: string; Color: TColor); overload;
    procedure AddMainLog(Text: string; Color: TColor; AmbiguousCommandID: Integer); overload;
    procedure AddTextToChatWindow(Chat: TMyTabSheet; Text: string; Color: TColor); overload;
    procedure AddTextToChatWindow(Chat: TMyTabSheet; Text: string; Color: TColor; ChatTextPos: Integer); overload;
  end;

  TConnectionState = (Disconnected, Connecting, Connected);

  PPingInfo = ^TPingInfo;
  TPingInfo =
  record
    TimeSent: Cardinal; // time when we sent this ping packet
    Key: Word; // unique ping packet ID (we use it to identify the packet so we don't mingle it with other ping packets if more were sent at the same time)
  end;

var
  Debug:
  record
    Enabled: Boolean; // show some debugging information
    Log: Boolean; // save local tab's text to disk on program exit
    FilterPingPong: Boolean;
  end;

  MainForm: TMainForm;

  { this is a list of all clients on the server. We must maintain this list by reading ADDUSER and REMOVEUSER commands.
    All other clients lists (in channels, battles) contain objects linking to actual objects in this list. Never free
    any clients in any list except in this one, since freeing them in any other list will also free them in this list! }
  AllClients: TList;


  Status: record
    ConnectionState: TConnectionState;
    NATHelpServerPort: Integer; // server's UDP port of "NAT Help Server". Acquired from "TASSERVER" command.
    Registering: Boolean; // used only when registering new account
    LoggedIn: Boolean; // only check this if ConnectionState = Connected!
    Hashing: Boolean; // if true, we are currently changing mod and hashing file, which takes time and allows application to process other messages meanwhile. We use this when we receive JOINBATTLE command, since it is possible to receive REQUESTBATTLESTATUS command before we are done hashing and so an invalid sync status would be sent. That is why we must wait for hashing to finish when we receive REQUESTBATTLESTATUS command.
    Synced: Boolean; // only check this if IsBattleActive = True!
    MyRank: Byte;
    TimeOfLastDataSent: LongWord; // the time when we sent last string to the server. We need to know this so that we know if we must ping server if time of last data sent was some time ago (otherwise server will disconnect us due to timeout!)
    TimeOfLastDataReceived: LongWord; // the time when we received last data from server. If this time get's too high, we assume that connection to server has been lost. Nevertheless, it's us who must keep constant connection to server by pinging it!
    Username: string; // our username
    AwayTime: Cardinal; // not a "period" of time, but the GetTickCount value (taken when application lost focus the last time)
    AmIInGame: Boolean; // true if we are in-game
    BattleStatusRequestReceived: Boolean; // used when joining a battle, to avoid dead-lock
    BattleStatusRequestSent: Boolean; // used when joining a battle, to avoid dead-lock
    MyCPU: Integer;
  end;

  Pings: TList; // list of TPingInfo records (holds current ping packets info. See /ping command implementation)

  // NAT traversing method used with the lobby client is described in TASServer's docs!
  NATTraversal:
  record
    MyPrivateUDPSourcePort: Integer;
    MyPublicUDPSourcePort: Integer;
    TimeOfLastKeepAlive: Cardinal; // time when we last sent UDP packet to keep binding in router's translation table open (so that router doesn't "forget" it)
  end;

  Battles: TList;
  ReplayList: TList;

  FlagBitmaps: TList; // of TBitmap objects
  FlagBitmapsInitialized: Boolean = False;
  FlagBitmapsReverseTable: array[Ord('a')..Ord('z'), Ord('a')..Ord('z')] of Smallint;

  CommonFont: TFont; // common lobby font (used with chat windows, private chat, clients list, battle window, ...)

  ReceivedAgreement: TStringList; // this is temporary string list to store received lines of an agreement sent by server.

  ProcessingRemoteCommand: Boolean = False; // tells us if we are processing remote command currently. This is important because sometimes Application.ProcessMessages can get called from within ProcessRemoteCommand method, which could led to next command being processed before current one is finished.

  // used with Socket:
  ReceiveBuffer: string; // this is temp buffer of what we receive from socket

  { we have to use messaging queue, since TWSocket doesn't seem to work correctly if certain methods are called
    from within its events (and especially if new messages arrive in meantime) }
  CommandQueue: array[0..QUEUE_LENGTH-1] of string;
  CommandQueueHead: Integer = 0;
  CommandQueueTail: Integer = 0;

  function Dequeue: string; forward;
  function Enqueue(s: string): Integer; forward;

implementation

uses BattleFormUnit, PreferencesFormUnit, Misc, WaitForAckUnit,
  InitWaitFormUnit, HelpUnit, DebugUnit, ReplaysUnit,
  HttpGetUnit, OnlineMapsUnit, ShellAPI, RichEdit, NotificationsUnit, StrUtils,
  HostBattleFormUnit, AgreementUnit, PerformFormUnit, HighlightingUnit;

{$R *.dfm}

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  // detach main form from Application and hide Application's taskbar button:

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;

  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong (Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

// this makes minimizing and restoring of application possible when using taskbar buttons for each form. See http://tinyurl.com/3j848 for details.
procedure TMainForm.WMSysCommand(var Message: TWMSysCommand);
begin
  if not Preferences.TaskbarButtons then
  begin
    inherited;
    Exit;
  end;

  if (Message.CmdType and $FFF0 = SC_MINIMIZE) and (Application.MainForm = Self) then
  begin
    if not IsIconic(Handle) then
    begin
      Application.NormalizeTopMosts;
      SetActiveWindow(Handle);
      if (Application.MainForm <> nil) and (Application.ShowMainForm or Application.MainForm.Visible)
         and IsWindowEnabled(Handle) then DefWindowProc(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
    end;
  end
  else if (Message.CmdType and $FFF0 <> SC_MOVE) or (csDesigning in ComponentState)
           or (Align = alNone) or (WindowState = wsMinimized) then inherited;

  if ((Message.CmdType and $FFF0 = SC_MINIMIZE) or (Message.CmdType and $FFF0 = SC_RESTORE))
     and not (csDesigning in ComponentState) and (Align <> alNone) then RequestAlign;
end;

function Dequeue: string;
begin
  Result := CommandQueue[CommandQueueHead];
  CommandQueueHead := (CommandQueueHead + 1) mod QUEUE_LENGTH;
end;

function Enqueue(s: string): Integer;
begin
  Result := CommandQueueTail;
  CommandQueue[CommandQueueTail] := s;
  CommandQueueTail := (CommandQueueTail + 1) mod QUEUE_LENGTH;
end;

procedure TMainForm.OnDataHasArrivedMessage(var Msg: TMessage); // responds to WM_DATAHASARRIVED message
var
  s: string;
begin
{
  if ProcessingRemoteCommand then // should probably not happen at all
  begin
    PostMessage(MainForm.Handle, WM_DATAHASARRIVED, 0, 0);
    Exit;
  end;

  OK the code above doesn't work really well, it will halt the client if there was some messagebox created from
  within ProcessRemoteCommand method, that is why I removed it. We can ignore it since we can process
  multiple commands without any problem anyway.
}

  s := Dequeue;
  if s = '' then Exit;

  if Debug.Enabled and ((not Debug.FilterPingPong) or (s <> 'PONG')) then AddMainLog('Server: "' + s + '"', Colors.Data);
  ProcessRemoteCommand(s); 
end;

procedure TMainForm.OnOpenOptionsMessage(var Msg: TMessage); // responds to WM_OPENOPTIONS message
var
  i, index: Integer;
begin
  index := 0;
  for i := 0 to PreferencesForm.PageControl1.PageCount-1 do
    if PreferencesForm.PageControl1.Pages[i].Caption = 'Account' then
    begin
      index := i;
      Break;
    end;

  PreferencesForm.PageControl1.ActivePageIndex := index;
  OptionsSpeedButton.OnClick(nil);
end;

procedure TMainForm.OnDoRegisterMessage(var Msg: TMessage); // responds to WM_DOREGISTER message
begin
  if Status.ConnectionState <> Disconnected then Exit;

  Status.Registering := True;
  ConnectButton.OnClick(nil);
end;

procedure TMainForm.OnCloseTabMessage(var Msg: TMessage); // responds to WM_CLOSETAB message
begin
  if Msg.WParam >= PageControl1.PageCount then Exit; // should not happen
  TryToCloseTab(TMyTabSheet(PageControl1.Pages[Msg.WParam]));
end;

procedure TMainForm.OnConnectMessage(var Msg: TMessage); // responds to WM_CONNECT message
begin
  if Status.ConnectionState = Disconnected then
    ConnectButton.OnClick(nil);
end;

procedure TMainForm.OnForceReconnectMessage(var Msg: TMessage); // responds to WM_FORCERECONNECT message
begin
  if Status.ConnectionState <> Disconnected then
  begin
    TryToDisconnect;
  end;

  TryToConnect;
end;

procedure TMainForm.ApplicationEvents1ShortCut(var Msg: TWMKey;
  var Handled: Boolean);
var
  s: string;
begin

  if (((Msg.CharCode >= Ord('0')) and (Msg.CharCode <= Ord('9'))) or (Msg.CharCode = VK_DELETE)) and BattleForm.Active and (BattleState.Status = Hosting) and BattleForm.IsMouseOverMapImage and (BattleState.SelectedStartRect <> -1) then
  begin
    if Msg.CharCode = VK_DELETE then BattleForm.OnDeletePressedOverStartRect
    else BattleForm.OnNumberPressedOverStartRect(Msg.CharCode - Ord('0'));

    Handled := True;
    Exit;
  end;

  // Shift+Ctrl+F5 to load button images dynamically (I need it for debuging purposes)
  if (Msg.CharCode = VK_F5) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    Handled := True;
    if MessageDlg('Reload button image list dynamically?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
    if not LoadImagesDynamically then MessageDlg('Failed to images! Make sure you have all the images in \Graphics folder!', mtError, [mbOK], 0);

    UpdateClientsListBox;
    VDTBattles.Invalidate;
    BattleForm.UpdateClientsListBox;
    ConnectButton.Glyph := nil; // we have to tell speedbutton somehow that he is about to be changed
    ConnectionStateImageList.GetBitmap(Ord(Status.ConnectionState), ConnectButton.Glyph);
    Exit;
  end;

  // Shift+Ctrl+F6 to show debug options
  if (Msg.CharCode = VK_F6) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    Handled := True;
    DebugForm.ShowModal;
    Exit;
  end;

  // Shift+Ctrl+F7 to change current map to "no map":
  if (Msg.CharCode = VK_F7) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    //*** remove (DEBUG)
    Handled := True;
    s := 'ProvingGrounds.smf';
    s := Copy(s, 1, Length(s)-4);
    BattleForm.MapImage.Picture.Bitmap.Assign(BattleForm.NoMapImage.Picture.Bitmap);
    with BattleForm.MapImage.Picture.Bitmap.Canvas do
    begin
      Brush.Style := bsClear;
      Font.Style := Font.Style + [fsBold];
      Font.Size := 16; // default
      while TextWidth(s) > BattleForm.MapImage.Picture.Bitmap.Width do
      begin
        Font.Size := Font.Size - 1;
        if Font.Size = 1 then Break; // smallest possible size
      end;

      Font.Color := $001111EE; // (0, b, g, r)
      TextOut(BattleForm.MapImage.Picture.Bitmap.Width div 2 - TextWidth(s) div 2, BattleForm.MapImage.Picture.Bitmap.Height div 2 - TextHeight('X') div 2, s);

      Font.Size := 11;
      Font.Color := clBlack;
      TextOut(5, 5, 'Map not found:');
    end;
    BattleForm.MapList.ItemIndex := -1;
    Exit;
  end;

  // Shift+Ctrl+B to switch between battle/main screen
  if (Msg.CharCode = Ord('B')) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    Handled := True;
    if MainForm.Active then BattleForm.Show else if BattleForm.Active then MainForm.Show;
    Exit;
  end;

  // Shift+Ctrl+H to switch to battle screen and open host battle dialog
  if (Msg.CharCode = Ord('H')) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    Handled := True;
    if Status.ConnectionState <> Connected then Exit;
    if not Status.LoggedIn then Exit;
    if BattleForm.IsBattleActive then Exit;

    BattleForm.Show;
    BattleForm.HostButton.OnClick(nil);
    Exit;
  end;

  // Shift+Ctrl+M to open online maps screen
  if (Msg.CharCode = Ord('M')) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    Handled := True;
    OnlineMapsForm.Show;
    Exit;
  end;

  // Shift+Ctrl+N to open notification dialog
  if (Msg.CharCode = Ord('N')) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    Handled := True;
    NotificationsForm.Show;
    Exit;
  end;

  // TAB when input TEdit has focus:
  if (Msg.CharCode = 9) and (Screen.ActiveControl.ClassType = TEdit) and (Screen.ActiveControl.Name = 'InputEdit') then
  begin
    Handled := True;
    
    if PageControl1.ActivePage.Caption = LOCAL_TAB then
      TryToAutoCompleteClientName(TEdit(Screen.ActiveControl), AllClients)
    else if PageControl1.ActivePage.Caption[1] = '#' then // a channel tab
      TryToAutoCompleteClientName(TEdit(Screen.ActiveControl), (PageControl1.ActivePage as TMyTabSheet).Clients)
    else // a private chat tab
      TryToAutoCompleteClientName(TEdit(Screen.ActiveControl), (PageControl1.ActivePage as TMyTabSheet).Clients);

    Exit;
  end;

end;

procedure TMainForm.InitializeFlagBitmaps;
var
  i: Integer;

  res: TResourceStream;
//  gif: TGIFGraphic;
  png: TPNGGraphic;

  bmp: TBitmap;

  time: Cardinal;
  name: string;
begin
  if FlagBitmapsInitialized then Exit;
  FlagBitmapsInitialized := True;

  time := GetTickCount;

  FlagBitmaps := TList.Create;

  for i := 0 to High(CountryNames) do
  begin
    try
      name := Copy(CountryNames[i], Length(CountryNames[i])-1, 2);
      res := TResourceStream.Create(HInstance, 'country_' + name, RT_RCDATA);
//     gif := TGIFGraphic.Create;
//      gif.LoadFromStream(res);
      png := TPNGGraphic.Create;
      png.LoadFromStream(res);

      bmp := TBitmap.Create;
      bmp.Assign(png);
      FlagBitmaps.Add(bmp);
//      gif.Free;
      png.Free;
      res.Free;
    except
      FlagBitmapsReverseTable[Ord(name[1]), Ord(name[2])] := -1;
      Continue;
    end;
    FlagBitmapsReverseTable[Ord(name[1]), Ord(name[2])] := FlagBitmaps.Count-1;
  end;

  time := GetTickCount - time;

end;

procedure TMainForm.DeinitializeFlagBitmaps;
var
  i: Integer;
begin
  if not FlagBitmapsInitialized then Exit;
  FlagBitmapsInitialized := False;

  for i := 0 to FlagBitmaps.Count-1 do
    TBitmap(FlagBitmaps[i]).Free;
  FlagBitmaps.Free;
end;

function TMainForm.GetFlagBitmap(Country: string): TBitmap; // Country must contain two-letter country code (for example: "si" for Slovenia)
var
  index: Integer;
begin
  if not FlagBitmapsInitialized then raise Exception.CreateFmt('Erro: FlagBitmaps not initialized! Please report this error!', []);

  index := FlagBitmapsReverseTable[Ord(Country[1]), Ord(Country[2])];
  if index = -1 then index := FlagBitmapsReverseTable[Ord('x'), Ord('x')];
  Result := FlagBitmaps[index];
end;

function TMainForm.OpenLog(FileName: string): TFileStream;
var
  fh: Integer; // file handle
begin
  Result := nil;

  try
    if not FileExists(FileName) then
    begin
      fh := FileCreate(FileName);
      if fh = -1 then Exit;
      FileClose(fh);
    end;

    Result := TFileStream.Create(FileName, fmOpenWrite or fmShareDenyWrite);
    Result.Position := Result.Size;
    TryToAddLog(Result, '');
    TryToAddLog(Result, 'Logging started on ' + FormatDateTime('ddd mmm mm hh:nn:ss yyyy', Now));

  except
    Result := nil;
    Exit;
  end;
end;

procedure TMainForm.CloseAllLogs;
var
  i: Integer;
begin
  for i := 0 to PageControl1.PageCount - 1 do
    FreeAndNil((PageControl1.Pages[i] as TMyTabSheet).LogFile);
  // close battle log:
  FreeAndNil(BattleForm.LogFile);
end;

procedure TMainForm.OpenAllLogs;
var
  i: Integer;
  FileName: string;

begin
  for i := 0 to PageControl1.PageCount - 1 do
    if (PageControl1.Pages[i] as TMyTabSheet).LogFile = nil then
    begin
      FileName := ExtractFilePath(Application.ExeName) + LOG_FOLDER + '\' + (PageControl1.Pages[i] as TMyTabSheet).Caption + '.log';
      try
        (PageControl1.Pages[i] as TMyTabSheet).LogFile := OpenLog(FileName);
        if (PageControl1.Pages[i] as TMyTabSheet).LogFile = nil then raise Exception.Create('');
      except
        AddMainLog('Error: unable to access file: ' + FileName, Colors.Error);
      end;
    end;

  // battle window log:
  if BattleForm.LogFile = nil then
  begin
    FileName := ExtractFilePath(Application.ExeName) + LOG_FOLDER + '\$battle.log';
    try
      BattleForm.LogFile := OpenLog(FileName);
      if BattleForm.LogFile = nil then raise Exception.Create('');
    except
      AddMainLog('Error: unable to access file: ' + FileName, Colors.Error);
    end;
  end;

end;

procedure TMainForm.TryToAddLog(f: TFileStream; Line: string);
begin
  if f = nil then Exit;

  try
    Line := Line + EOL;
    f.Write(Line[1], Length(Line));
  except
  end;

end;

function TMainForm.AreWeLoggedIn: Boolean;
begin
  Result := (Status.ConnectionState = Connected) and Status.LoggedIn;
end;

// returns False if battle with this ID already exists or some other error occured
function TMainForm.AddBattle(ID: Integer; BattleType: Integer; NATType: Integer; Founder: TClient; IP: string; Port: Integer; MaxPlayers: Integer; Password: Boolean; Rank: Byte; MapName: string; MapTitle: string; ModName: string): Boolean;
var
  Battle: TBattle;
begin
  Result := False;

  if GetBattle(ID) <> nil then Exit;

  Battle := TBattle.Create;
  Battle.ID := ID;
  Battle.BattleType := BattleType;
  Battle.NATType := NATType;
  Battle.Description := MapTitle;
  Battle.Map := MapName;
  Battle.Password := Password;
  Battle.RankLimit := Rank;
  Battle.IP := IP;
  Battle.Port := Port;
  Battle.MaxPlayers := MaxPlayers;
  Battle.ModName := ModName;

  Battle.Clients.Add(Founder);
  if Battle.BattleType = 0 then Battle.SpectatorCount := 0 else Battle.SpectatorCount := 1;

  with VDTBattles do
  begin
    RootNodeCount := RootNodeCount + 1;
    Battle.Node := GetLast;
  end;
  Battles.Add(Battle);

  Result := True;
end;

function TMainForm.RemoveBattle(ID: Integer): Boolean;
var
  i, j: Integer;
begin
  Result := False;

  j := -1;
  for i := 0 to Battles.Count - 1 do
    if TBattle(Battles[i]).ID = ID then
    begin
      j := i;
      Break;
    end;

  if j = -1 then Exit;

  VDTBattles.DeleteNode(TBattle(Battles[j]).Node, True);
  TBattle(Battles[j]).Free;
  Battles.Delete(j);

  Result := True;
end;

function TMainForm.RemoveBattleByIndex(Index: Integer): Boolean;
begin
  Result := False;

  if Index > Battles.Count-1 then Exit;

  VDTBattles.DeleteNode(TBattle(Battles[Index]).Node, True);
  TBattle(Battles[Index]).Free;
  Battles.Delete(Index);

  Result := True;
end;


procedure TMainForm.ClearAllClientsList;
var
  i: Integer;
begin
  for i := 0 to AllClients.Count - 1 do
    TClient(AllClients[i]).Free;

  AllClients.Clear;
end;

procedure TMainForm.ClearClientsLists; // clears all clients list (in channels, private chats, battles, local tab, ...)
var
  i: Integer;
begin

  for i := 0 to PageControl1.PageCount - 1 do
    (PageControl1.Pages[i] as TMyTabSheet).Clients.Clear;

  UpdateClientsListBox;

  // finally:
  ClearAllClientsList;
  UpdateClientsListBox;
end;

procedure TMainForm.AddClientToAllClientsList(Name: string; Status: Integer; Country: string; CPU: Integer; IP: string);
var
  Client: TClient;
begin
  Client := TClient.Create(Name, Status, Country, CPU, IP);
  AllClients.Add(Client);
end;

function TMainForm.RemoveClientFromAllClientsList(Name: string): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to AllClients.Count - 1 do
    if TClient(AllClients[i]).Name = Name then
    begin
      AllClients.Delete(i);
      Result := True;
      Exit;
    end;
end;

function TMainForm.GetClient(Name: string): TClient;
var
  i: Integer;
begin
  for i := 0 to AllClients.Count - 1 do if TClient(AllClients[i]).Name = Name then
  begin
    Result := TClient(AllClients[i]);
    Exit;
  end;

  Result := nil;
end;

function TMainForm.GetClientIndexEx(Name: string; ClientList: TList): Integer;
var
  i: Integer;
begin
  for i := 0 to ClientList.Count - 1 do if TClient(ClientList[i]).Name = Name then
  begin
    Result := i;
    Exit;
  end;

  Result := -1;
end;

function TMainForm.GetBot(Name: string; Battle: TBattle): TBot;
var
  i: Integer;
begin
  for i := 0 to Battle.Bots.Count - 1 do if TBot(Battle.Bots[i]).Name = Name then
  begin
    Result := TBot(Battle.Bots[i]);
    Exit;
  end;

  Result := nil;
end;

function TMainForm.GetBattle(ID: Integer): TBattle;
var
  i: Integer;
begin
  for i := 0 to Battles.Count - 1 do if TBattle(Battles[i]).ID = ID then
  begin
    Result := TBattle(Battles[i]);
    Exit;
  end;

  Result := nil;
end;

{ TClient }

constructor TClient.Create(Name: string; Status: Integer; Country: string; CPU: Integer; IP: string);
begin
  Self.Name := Name;
  Self.Status := Status;
  Self.BattleStatus := 0;
  Self.InBattle := False;
  Self.Country := Country;
  Self.CPU := CPU;
  Self.IP := IP;
end;

// Battle status:

function TClient.GetReadyStatus: Boolean;
begin
  Result := IntToBool((BattleStatus and $2) shr 1);
end;

function TClient.GetTeamNo: Integer;
begin
  Result := (BattleStatus and $3C) shr 2;
end;

function TClient.GetAllyNo: Integer;
begin
  Result := (BattleStatus and $3C0) shr 6;
end;

function TClient.GetMode: Integer;
begin
  Result := (BattleStatus and $400) shr 10;
end;

function TClient.GetHandicap: Integer;
begin
  Result := (BattleStatus and $3F800) shr 11;
end;

function TClient.GetTeamColor: Integer;
begin
  Result := (BattleStatus and $3C0000) shr 18;
end;

function TClient.GetSync: Integer;
begin
  Result := (BattleStatus and $C00000) shr 22;
end;

function TClient.GetSide: Integer;
begin
  Result := (BattleStatus and $F000000) shr 24;
end;

procedure TClient.SetReadyStatus(Ready: Boolean);
begin
  BattleStatus := (BattleStatus and $FFFFFFFD) or (BoolToInt(Ready) shl 1);
end;

procedure TClient.SetTeamNo(Team: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFFC3) or (Team shl 2);
end;

procedure TClient.SetAllyNo(Ally: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFC3F) or (Ally shl 6);
end;

procedure TClient.SetMode(Mode: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFBFF) or (Mode shl 10);
end;

procedure TClient.SetHandicap(Handicap: Integer);
begin
  BattleStatus := (BattleStatus and $FFFC07FF) or (Handicap shl 11);
end;

procedure TClient.SetTeamColor(Color: Integer);
begin
  BattleStatus := (BattleStatus and $FFC3FFFF) or (Color shl 18);
end;

procedure TClient.SetSync(Sync: Integer);
begin
  BattleStatus := (BattleStatus and $FF3FFFFF) or (Sync shl 22);
end;

procedure TClient.SetSide(Side: Integer);
begin
  BattleStatus := (BattleStatus and $F0FFFFFF) or (Side shl 24);
end;

// Misc:

function TClient.GetStateImageIndex: Integer; // returns index of image in PlayerStateImageList
begin
  if GetInGameStatus then Result := 2
  else if InBattle then Result := 1
  else Result := 0;

  if GetAwayStatus then if Result <> 2 then Result := 3;
end;

// Status:

function TClient.GetInGameStatus: Boolean;
begin
  Result := IntToBool(Status and $1);
end;

function TClient.GetAwayStatus: Boolean;
begin
  Result := IntToBool((Status and $2) shr 1);
end;

function TClient.GetRank: Byte;
begin
  Result := (Status and $1C) shr 2;
end;

function TClient.GetAccess: Boolean;
begin
  Result := IntToBool((Status and $20) shr 5);
end;

procedure TClient.SetInGameStatus(InGame: Boolean);
begin
  Status := (Status and $FFFFFFFE) or BoolToInt(InGame);
end;

procedure TClient.SetAwayStatus(Away: Boolean);
begin
  Status := (Status and $FFFFFFFD) or (BoolToInt(Away) shl 1);
end;

{ TBot }

procedure TBot.Assign(Bot: TBot);
begin
  Self.Name := Bot.Name;
  Self.OwnerName := Bot.OwnerName;
  Self.AIDll := Bot.AIDll;
  Self.BattleStatus := Bot.BattleStatus;
end;

constructor TBot.Create(Name: string; OwnerName: string; AIDll: string);
begin
  Self.Name := Name;
  Self.OwnerName := OwnerName;
  Self.AIDll := AIDll;
  Self.BattleStatus := 0;
end;

function TBot.GetTeamNo: Integer;
begin
  Result := (BattleStatus and $3C) shr 2;
end;

function TBot.GetAllyNo: Integer;
begin
  Result := (BattleStatus and $3C0) shr 6;
end;

function TBot.GetHandicap: Integer;
begin
  Result := (BattleStatus and $3F800) shr 11;
end;

function TBot.GetTeamColor: Integer;
begin
  Result := (BattleStatus and $3C0000) shr 18;
end;

function TBot.GetSide: Integer;
begin
  Result := (BattleStatus and $F000000) shr 24;
end;

procedure TBot.SetTeamNo(Team: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFFC3) or (Team shl 2);
end;

procedure TBot.SetAllyNo(Ally: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFC3F) or (Ally shl 6);
end;

procedure TBot.SetHandicap(Handicap: Integer);
begin
  BattleStatus := (BattleStatus and $FFFC07FF) or (Handicap shl 11);
end;

procedure TBot.SetTeamColor(Color: Integer);
begin
  BattleStatus := (BattleStatus and $FFC3FFFF) or (Color shl 18);
end;

procedure TBot.SetSide(Side: Integer);
begin
  BattleStatus := (BattleStatus and $F0FFFFFF) or (Side shl 24);
end;

{ TBattle }

constructor TBattle.Create;
begin
  inherited Create;
  SpectatorCount := 0;
  HashCode := 0;
  RankLimit := 0;
  Locked := False;
  Clients := TList.Create;
  Bots := TList.Create;
end;

destructor TBattle.Destroy;
var
  i: Integer;
begin
  Clients.Free;
  for i := 0 to Bots.Count-1 do TBot(Bots[i]).Free;
  Bots.Clear;
  Bots.Free;
  inherited Destroy;
end;

function TBattle.AreAllClientsReady: Boolean;
var
  i: Integer;
begin
  Result := False;

  if Clients.Count = 0 then Exit; // should not happen

  if BattleType = 0 then
  begin
    if SpectatorCount = Clients.Count then Exit; // all players are spectators
    for i := 0 to Clients.Count-1 do if (TClient(Clients[i]).GetMode = 1) and (not TClient(Clients[i]).GetReadyStatus) then Exit;
  end
  else if BattleType = 1 then
  begin
    for i := 0 to Clients.Count-1 do if not TClient(Clients[i]).GetReadyStatus then Exit;
  end;

  Result := True;
end;

// returns false if two or more bots share the same team number
function TBattle.AreAllBotsSet: Boolean;
var
  i: Integer;
  TeamNo: array[0..9] of Boolean;
begin
  Result := False;

  for i := 0 to High(TeamNo) do TeamNo[i] := False;
  for i := 0 to Bots.Count-1 do
  begin
    if TeamNo[TBot(Bots[i]).GetTeamNo] then Exit;
    TeamNo[TBot(Bots[i]).GetTeamNo] := True;
  end;

  Result := True;
end;

function TBattle.AreAllClientsSynced: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Clients.Count-1 do if TClient(Clients[i]).GetSync <> 1 then Exit;
  Result := True;
end;

function TBattle.IsBattleFull: Boolean;
begin
  if BattleType = 0 then
    Result :=  MaxPlayers - Clients.Count + SpectatorCount <= 0
  else
    Result :=  MaxPlayers - Clients.Count <= 0; 
end;

function TBattle.IsBattleInProgress: Boolean;
begin
  Result := TClient(Clients[0]).GetInGameStatus;
end;

function TBattle.GetState: Integer; // use it to get index of image from BattleStatusImageList
begin
  Result := 0;
  if TClient(Clients[0]).GetInGameStatus then Result := 2
  else if IsBattleFull then Inc(Result);
  if Password then Inc(Result, 3);
  if BattleType = 1 then Inc(Result, 6);
end;

function TBattle.ClientsToString: string; // returns user names in a string, separated by spaces
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Clients.Count-1 do Result := Result + TClient(Clients[i]).Name + ' ';
  if Length(Result) > 0 then Delete(Result, Length(Result), 1);
end;

function TBattle.GetClient(Name: string): TClient;
var
  i: Integer;
begin
  for i := 0 to Clients.Count-1 do if TClient(Clients[i]).Name = Name then
  begin
    Result := TClient(Clients[i]);
    Exit;
  end;

  Result := nil;
end;

function TBattle.GetBot(Name: string): TBot;
var
  i: Integer;
begin
  for i := 0 to Bots.Count-1 do if TBot(Bots[i]).Name = Name then
  begin
    Result := TBot(Bots[i]);
    Exit;
  end;

  Result := nil;
end;

procedure TBattle.RemoveAllBots;
var
  i: Integer;
begin
  for i := 0 to Bots.Count-1 do TBot(Bots[i]).Free;
  Bots.Clear;
end;

{ TScript }

constructor TScript.Create(Script: string);
begin
  inherited Create;
  FScript := Script;
  FUpperCaseScript := UpperCase(Script);
end;

procedure TScript.SetScript(Script: string);
begin
  FScript := Script;
  FUpperCaseScript := UpperCase(Script);
end;

function TScript.DoesTokenExist(Token: string): Boolean;
var
  i: Integer;
begin
  i := Pos(UpperCase(Token), FUpperCaseScript);
  Result := i > 0;
end;

function TScript.ReadMapName: string;
var
  i, j: Integer;
begin
  i := Pos('MAPNAME=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 8;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := Copy(FScript, i, j-i);
end;

function TScript.ReadModName: string;
var
  i, j: Integer;
begin
  i := Pos('GAMETYPE=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 9;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := Copy(FScript, i, j-i);
end;

function TScript.ReadStartMetal: Integer;
var
  i, j: Integer;
begin
  i := Pos('STARTMETAL=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 11;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := StrToInt(Copy(FScript, i, j-i));
end;

function TScript.ReadStartEnergy: Integer;
var
  i, j: Integer;
begin
  i := Pos('STARTENERGY=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 12;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := StrToInt(Copy(FScript, i, j-i));
end;

function TScript.ReadMaxUnits: Integer;
var
  i, j: Integer;
begin
  i := Pos('MAXUNITS=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 9;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := StrToInt(Copy(FScript, i, j-i));
end;

function TScript.ReadStartPosType: Integer;
var
  i, j: Integer;
begin
  i := Pos('STARTPOSTYPE=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 13;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := StrToInt(Copy(FScript, i, j-i));
end;

function TScript.ReadGameMode: Integer;
var
  i, j: Integer;
begin
  i := Pos('GAMEMODE=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 9;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := StrToInt(Copy(FScript, i, j-i));
end;

function TScript.ReadLimitDGun: Boolean;
var
  i, j: Integer;
begin
  i := Pos('LIMITDGUN=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 10;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := IntToBool(StrToInt(Copy(FScript, i, j-i)));
end;

function TScript.ReadDiminishingMMs: Boolean;
var
  i, j: Integer;
begin
  i := Pos('DIMINISHINGMMS=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 15;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := IntToBool(StrToInt(Copy(FScript, i, j-i)));
end;

function TScript.ReadGhostedBuildings: Boolean;
var
  i, j: Integer;
begin
  i := Pos('GHOSTEDBUILDINGS=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 15;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Result := IntToBool(StrToInt(Copy(FScript, i, j-i)));
end;

procedure TScript.ChangeHostIP(NewIP: string);
var
  i, j: Integer;
begin
  i := Pos('HOSTIP=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 7;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Delete(FScript, i, j-i);
  Insert(NewIP, FScript, i);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

procedure TScript.ChangeHostPort(NewPort: string);
var
  i, j: Integer;
begin
  i := Pos('HOSTPORT=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 9;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Delete(FScript, i, j-i);
  Insert(NewPort, FScript, i);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

procedure TScript.ChangeMyPlayerNum(NewNum: Integer);
var
  i, j: Integer;
begin
  i := Pos('MYPLAYERNUM=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 12;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Delete(FScript, i, j-i);
  Insert(IntToStr(NewNum), FScript, i);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

procedure TScript.ChangeNumPlayers(NewNum: Integer);
var
  i, j: Integer;
begin
  i := Pos('NUMPLAYERS=', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 11;
  j := PosEx(';', FUpperCaseScript, i);
  if j = 0 then raise Exception.Create('Corrupt script file!');
  Delete(FScript, i, j-i);
  Insert(IntToStr(NewNum), FScript, i);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

procedure TScript.AddLineToPlayer(Player: Integer; Line: string);
var
  i: Integer;
begin
  i := Pos('[PLAYER' + IntToStr(Player) + ']', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := PosEx('{', FUpperCaseScript, i);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 1;
  Insert(#13#10#9#9 + Line, FScript, i);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

// adds a spectator right after AnotherPlayer. Spectator is called <NickName>
procedure TScript.AddSpectatorAfterAnotherPlayer(AnotherPlayer: Integer; NewPlayer: Integer; Nickname: string);
var
  i: Integer;
  ins: string;
begin
  i := Pos('[PLAYER' + IntToStr(AnotherPlayer) + ']', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := PosEx('}', FUpperCaseScript, i);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 1 + 2; // 2 is for #13#10
  ins := #9 + '[PLAYER' + IntToStr(NewPlayer) + ']' + #13#10#9 + '{' + #13#10#9#9 + 'name=' + Nickname + ';'
       + #13#10#9#9 + 'Spectator=1;' + #13#10#9 + '}' + #13#10;
  Insert(ins, FScript, i);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

procedure TScript.AddLineAfterStart(Line: string);
var
  i: Integer;
begin
  i := Pos('[GAME]', FUpperCaseScript);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := PosEx('{', FUpperCaseScript, i);
  if i = 0 then raise Exception.Create('Corrupt script file!');
  i := i + 1;
  Insert(#13#10#9 + Line, FScript, i);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

procedure TScript.RemoveLineAtChar(CharIndex: Integer); // will remove line where char is located. Char must not be part of EOL!
var
  start, stop: Integer;
  EOLRemoved: Boolean;
begin
  if (FScript[CharIndex] = #13) or (FScript[CharIndex] = #10) then raise Exception.Create('Invalid use of TScript method! Please report this error.');
  if (CharIndex < 1) or (CharIndex > Length(FScript)) then raise Exception.Create('Invalid use of TScript method! Please report this error.');

  start := CharIndex;
  stop := CharIndex;
  EOLRemoved := False;

  try
    // find beginning of the line:
    while True do
    begin
      if start = 1 then Break; // it seems we are removing the first line from script (or script is corrupt)
      Dec(start);
      if (FScript[start] = #13) or (FScript[start] = #10) then
      begin
        if (start > 1) and (FScript[start] = #10) then if FScript[start-1] = #13 then Dec(start);
        EOLRemoved := True;
        Break;
      end;
    end;

    // find end of the line:
    while True do
    begin
      if stop = Length(FScript) then Break; // it seems we are removing the last line from script (or script is corrupt)
      Inc(stop);
      if (FScript[stop] = #13) or (FScript[stop] = #10) then
      begin
        if not EOLRemoved then if (stop < Length(FScript)) and (FScript[stop] = #13) then if FScript[stop+1] = #10 then Inc(stop)
        else Dec(stop); // let's not remove the EOL since we already removed it once (in front of the line)
        Break;
      end;
    end;
  except
    raise Exception.Create('Currupt script file or invalid use of TScript method!');
  end;

  if not EOLRemoved then ; // OK no problem, it seems we removed the ONLY line from the script

  Delete(FScript, start, stop-start+1);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

procedure TScript.TryToRemoveUDPSourcePort;
var
  i: Integer;
begin
  i := Pos('SOURCEPORT=', FUpperCaseScript);
  if i = 0 then Exit;
  RemoveLineAtChar(i);
end;

{ TMyTabSheet }

constructor TMyTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Clients := TList.Create;
  History := TStringList.Create;
  HistoryIndex := -1;
  AutoScroll := True;
  LogFile := nil;
end;

destructor TMyTabSheet.Destroy;
begin
  Clients.Free;
  History.Free;
  LogFile.Free;
  inherited Destroy;
end;

procedure TMyTabSheet.WndProc(var Msg: TMessage);
var
  p: TENLink;
  sURL: string;
  CE : TRichEdit;
begin
  if (Msg.Msg = WM_NOTIFY) then
  begin
    if (PNMHDR(Msg.lParam).code = EN_LINK) then
    begin
      p := TENLink(Pointer(TWMNotify(Msg).NMHdr)^);
      if (p.Msg = WM_LBUTTONDOWN) then
      begin
        try
          CE := TRichEdit(Self.Controls[1] as TRichEdit);
          SendMessage(CE.Handle, EM_EXSETSEL, 0, Longint(@(p.chrg)));
          sURL := CE.SelText;
          ShellExecute(Handle, 'open', PChar(sURL), nil, nil, SW_SHOWNORMAL);
        except
        end;
      end;
    end;
  end;

  inherited;
end;

{ TMainForm }

procedure TMainForm.ChangeActivePageAndUpdate(PageControl: TPageControl; PageIndex: Integer); // never change ActivePageIndex manually, since it doesn't trigger OnChange event!
begin
  PageControl.ActivePageIndex := PageIndex;
  PageControl.OnChange(PageControl);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  Left := 10;
  Top := 10;

  Randomize;
  Application.UpdateFormatSettings := False; // so that DecimalSeparator doesn't get changed by WM_WININICHANGE message. See http://coding.derkeiler.com/Archive/Delphi/borland.public.delphi.language.objectpascal/2003-11/0223.html
  DecimalSeparator := '.';
  MainForm.Caption := PROGRAM_VERSION;
  Application.Title := 'TASClient';
  Application.HintHidePause := 10000;
  Application.ShowHint := True;

  Debug.Enabled := False;
  Debug.Log := False;
  Debug.FilterPingPong := False;

  CommonFont := TFont.Create;
  CommonFont.Name := 'Fixedsys';
  CommonFont.Charset := DEFAULT_CHARSET;

  ClientsListBox.DoubleBuffered := True;

  if not Utility.InitLib then
  begin
    MessageDlg('Error initializing unit syncer!', mtError, [mbOK], 0);
    Application.Terminate;
  end;

  for i := 1 to ParamCount do
  begin
    s := ParamStr(i);
    if s[1] <> '-' then Continue;
    s := UpperCase(Copy(s, 2, Length(s)-1));
    if s = 'DEBUG' then Debug.Enabled := True
    else if s = 'LOG' then Debug.Log := True;
  end;

  AllClients := TList.Create;

  ConnectionStateImageList.GetBitmap(0, ConnectButton.Glyph);
  Status.ConnectionState := Disconnected;
  Status.Registering := False;

  AddTabWindow(LOCAL_TAB);

  Battles := TList.Create;

  ModList := TStringList.Create;
  ModArchiveList := TStringList.Create;
  UnitList := TStringList.Create;
  UnitNames := TStringList.Create;
  GetModList(ModList, ModArchiveList);
  if ModList.Count = 0 then
  begin
    MessageDlg('No mods found! Terminating program ...', mtError, [mbOK], 0);
    Application.Terminate;
  end;
  SideList := TStringList.Create; // we will load side list when needed
  SideList.CaseSensitive := False;
  // we will load unit lists when needed

  ReceiveBuffer := '';

  Status.AwayTime := GetTickCount;
  Status.AmIInGame := False;

  Status.MyCPU := Misc.GetCPUSpeed;

  ReplayList := TList.Create;

  for i := 0 to SortPopupMenu.Items.Count-1 do with SortPopupMenu do
  begin
    Items[i].Tag := i;
    Items[i].RadioItem := True;
    Items[i].OnClick := SortMenuItemClick;
  end;
  SortPopupMenu.Items[0].Checked := True;

  for i := 0 to BattleSortPopupMenu.Items.Count-1 do with BattleSortPopupMenu do
  begin
    Items[i].Tag := i;
    Items[i].RadioItem := True;
    Items[i].OnClick := BattleSortMenuItemClick;
  end;
  BattleSortPopupMenu.Items[0].Checked := True;


  InitializeFlagBitmaps;

  ReceivedAgreement := TStringList.Create;

  Pings := TList.Create;
end;

{ ChatTextPos is a position in the line where chat text begins. We need this when we are searching for keywords to highlight
  and we (for example) don't want to highlight nicknames in "<xyz>" part of the line, but only after that part (keywords will
  get highlighted only in chat part of the text, not the header). If you don't specify ChatTextPos parameter, it is assumed
  that the entire line is the chat text. }
procedure TMainForm.AddTextToChatWindow(Chat: TMyTabSheet; Text: string; Color: TColor; ChatTextPos: Integer);
var
  re: TRichEdit;
  s: string;
begin
  re := Chat.Controls[1] as TRichEdit;
  if Preferences.TimeStamps then
  begin
    s := '[' + TimeToStr(Now) + '] ';
    Text := s + Text;
    Inc(ChatTextPos, Length(s));
  end;
  Misc.AddTextToRichEdit(re, Text, Color, Chat.AutoScroll, ChatTextPos);
  TryToAddLog(Chat.LogFile, Text);

  if PageControl1.ActivePage <> Chat then
    Chat.Highlighted := True;
end;

procedure TMainForm.AddTextToChatWindow(Chat: TMyTabSheet; Text: string; Color: TColor);
begin
  AddTextToChatWindow(Chat, Text, Color, 1);
end;

procedure TMainForm.AddMainLog(Text: string; Color: TColor);
begin
  AddTextToChatWindow(PageControl1.Pages[0] as TMyTabSheet, Text, Color);
end;

procedure TMainForm.AddMainLog(Text: string; Color: TColor; AmbiguousCommandID: Integer);
begin
  AddMainLog(Text + ' [#' + IntToStr(AmbiguousCommandID) + ']', Color);
end;

function TMainForm.AddTabWindow(Caption: string): Integer;
var
  tmpts: TMyTabSheet;
  tmpre: TRichEdit;
  tmped: TEdit;
  mask: Word;
  FileName: string;
begin
  Result := -1;

  tmpts := TMyTabSheet.Create(PageControl1);

  tmpts.Caption := Caption;

  tmped := TEdit.Create(tmpts);
  tmped.Parent := tmpts;
  tmped.Name := 'InputEdit'; // don't change this name! (there are some references to it in the code)
  tmped.Text := '';
  tmped.OnKeyPress := InputEditKeyPress;
  tmped.OnKeyDown := InputEditKeyDown;
  tmped.Font.Assign(CommonFont);
  tmped.Align := alBottom;

  tmpts.PageControl := PageControl1;

  tmpre := TRichEdit.Create(tmpts);
  tmpre.Parent := tmpts;
  tmpre.Font.Assign(CommonFont);
  tmpre.ScrollBars := ssVertical;
  tmpre.ReadOnly := True;
  tmpre.PlainText := True;
  tmpre.WordWrap := True;
  tmpre.TabStop := False;
  tmpre.Align := alClient;
  tmpre.WantTabs := False;
  tmpre.HideSelection := False;
  tmpre.PopupMenu := RichEditPopupMenu;
  // enable auto URL detection:
  mask := SendMessage(tmpre.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(tmpre.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(tmpre.Handle, EM_AUTOURLDETECT, Integer(True), 0);

  if Preferences.SaveLogs then
  begin
    FileName := ExtractFilePath(Application.ExeName) + LOG_FOLDER + '\' + tmpts.Caption + '.log';
    tmpts.LogFile := OpenLog(FileName);
    if tmpts.LogFile = nil then AddMainLog('Error: unable to access file: ' + FileName, Colors.Error);
  end;

  // finally:
  ChangeActivePageAndUpdate(PageControl1, PageControl1.PageCount-1);

  Result := PageControl1.PageCount-1;
end;

// if tab window with Caption does not exists, it returns -1. Returns index in TPageControl.Pages
function TMainForm.GetTabWindowPageIndex(Caption: string): Integer;
var
  i: Integer;
begin
  Result := -1;

  for i := 0 to PageControl1.PageCount-1 do
    if PageControl1.Pages[i].Caption = Caption then
    begin
      Result := i;
      Break;
    end;
end;

function TMainForm.AddClientToTab(Tab: TMyTabSheet; ClientName: string): Boolean; // does not update ClientsListBox!
var
  c: TClient;
  i: Integer;
  tmp: TClient;
begin
  Result := False;

  c := GetClient(ClientName);
  if c = nil then Exit;

  // make sure client is not already in the list:
  for i := 0 to Tab.Clients.Count-1 do if TClient(Tab.Clients[i]).Name = ClientName then Exit;

  Tab.Clients.Add(c);
  i := Tab.Clients.Count-1;
  // sort:
  while i > 0 do
    if CompareClients(Tab.Clients[i], Tab.Clients[i-1], Preferences.SortStyle) < 0 then
    begin
      // swap:
      tmp := Tab.Clients[i];
      Tab.Clients[i] := Tab.Clients[i-1];
      Tab.Clients[i-1] := tmp;
      Dec(i);
    end
    else Break;

  Result := True;
end;

function TMainForm.RemoveClientFromTab(Tab: TMyTabSheet; ClientName: string): Boolean; // does not update ClientsListBox!
var
  i: Integer;
begin
  Result := True;

  for i := 0 to Tab.Clients.Count - 1 do if TClient(Tab.Clients[i]).Name = ClientName then
  begin
    Tab.Clients.Delete(i);
    Exit;
  end;

  Result := False;
end;

procedure TMainForm.RemoveAllClientsFromTab(Tab: TMyTabSheet);
begin
  Tab.Clients.Clear;
end;

procedure TMainForm.UpdateClientsListBox;
var
  c: Integer;
  LastIndex: Integer;
  TempItemIndex: Integer;
  TempCount: Integer;
begin
  LastIndex := ClientsListBox.TopIndex;
  TempItemIndex := ClientsListBox.ItemIndex;
  TempCount := ClientsListBox.Items.Count;

  ClientsListBox.Items.BeginUpdate;

  if PageControl1.ActivePage.Caption = LOCAL_TAB then
  begin
    c := AllClients.count;
    if c = 0 then PlayersLabel.Caption := 'Players:' else
      PlayersLabel.Caption := 'Players (' + IntToStr(c) + '):';
    ClientsListBox.Items.SetText(PChar(CreateStrings(c)));
  end
  else
  if PageControl1.ActivePage.Caption[1] = '#' then // a channel tab
  begin
    c := (PageControl1.ActivePage as TMyTabSheet).Clients.Count;
    if c = 0 then PlayersLabel.Caption := 'Players:' else
      PlayersLabel.Caption := 'Players (' + IntToStr(c) + '):';
    ClientsListBox.Items.SetText(PChar(CreateStrings(c)));
  end
  else
  begin // a private chat tab
    c := (PageControl1.ActivePage as TMyTabSheet).Clients.Count;
    if c = 0 then PlayersLabel.Caption := 'Players:' else
      PlayersLabel.Caption := 'Players (' + IntToStr(c) + '):';
    ClientsListBox.Items.SetText(PChar(CreateStrings(c)));
  end;

  ClientsListBox.TopIndex := LastIndex;

  // next line is important because if there are many players online, their statuses
  // will get updated more often and sometimes you won't be able to double click
  // on a player since clients list will get updated so fast it will reset your
  // selection from the first click. This fixes it:
  if TempCount = ClientsListBox.Items.Count then
    ClientsListBox.ItemIndex := TempItemIndex;

  ClientsListBox.Items.EndUpdate;
end;

function TMainForm.CheckServerVersion(ServerVersion: string): Boolean;
var
  i: integer;
begin
  Result := True;
  for i := Low(SUPPORTED_SERVER_VERSIONS) to High(SUPPORTED_SERVER_VERSIONS) do
    if SUPPORTED_SERVER_VERSIONS[i] = ServerVersion then Exit;
  Result := False;
end;

{ CameFromBattleScreen must be True if user typed the message in battle screen }
procedure TMainForm.ProcessCommand(s: string; CameFromBattleScreen: Boolean);
var
  sl: TStringList;
  p: Pointer;
  i: Integer;
  tmp: string;
  duration: Integer; // temp var
  res: Integer;
  str: string;
  key: Integer;
  pinginfo: PPingInfo;
begin

  if s = '' then Exit;
  sl := ParseString(s, ' ');
  sl[0] := UpperCase(sl[0]);

  try
    if sl[0] = 'CONNECT' then TryToConnect
    else if sl[0] = 'QUIT' then MainForm.Close
    else if sl[0] = 'EXIT' then MainForm.Close
    else if (sl[0] = 'JOIN') or (sl[0] = 'J') then
    begin
      if (Status.ConnectionState <> Connected) or (not Status.LoggedIn) then
      begin
        AddMainLog('Must be connected and logged on a server to join channel!', Colors.Error);
        Exit;
      end;

      if (sl.Count < 2) or (sl[1][1] <> '#') then
      begin
        AddMainLog('Cannot join - bad or no argument (don''t forget to put "#" in front of a channel''s name!)', Colors.Error);
        Exit;
      end;

      if sl.Count = 2 then tmp := '' else tmp := ' ' + MakeSentence(sl, 2);
      TryToSendData('JOIN ' + LowerCase(Copy(sl[1], 2, Length(sl[1])-1)) + tmp);
    end
    else if (sl[0] = 'PART') or (sl[0] = 'P') then
    begin
      if (sl.Count <> 1) then
      begin
        MessageDlg('Invalid command - ''PART'' requires no arguments', mtInformation, [mbOK], 0);
        Exit;
      end;

      PostMessage(MainForm.Handle, WM_CLOSETAB, PageControl1.ActivePageIndex, 0);
    end
    else if (sl[0] = 'CHANNELS') or (sl[0] = 'LIST') then
    begin
      if (Status.ConnectionState <> Connected) or (not Status.LoggedIn) then
      begin
        AddMainLog('Must be connected and logged on a server to send command!', Colors.Error);
        Exit;
      end;

      AddMainLog('Requesting channel list from server ...', Colors.Info);
      TryToSendData('CHANNELS');
    end
    else if (sl[0] = 'ME') then
    begin
      if CameFromBattleScreen then TryToSendData('SAYBATTLEEX ' + MakeSentence(sl, 1))
      else if PageControl1.ActivePage.Caption[1] = '#' then // a channel tab
        TryToSendData('SAYEX ' + Copy(PageControl1.ActivePage.Caption, 2, Length(PageControl1.ActivePage.Caption)-1) + ' ' + MakeSentence(sl, 1));
    end
    else if (sl[0] = 'RING') then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('RING command requires exactly 1 parameter!', Colors.Error);
        Exit;
      end;

      if MainForm.GetClient(sl[1]) = nil then
      begin
        MessageDlg('Invalid RING command. User does not exist! (Note: all names are case-sensitive)', mtWarning, [mbOK], 0);
        Exit;
      end;

      TryToSendData('RING ' + sl[1]);
      AddMainLog('Ringing ' + sl[1] + ' ...', Colors.Info);
    end
    else if (sl[0] = 'HELP') then
    begin
      if not HelpForm.Visible then HelpForm.ShowModal;
    end
    else if (sl[0] = 'UPTIME') then
    begin
      if not (Status.ConnectionState = Connected)  then
      begin
        AddMainLog('You must be connected and logged on the server for this command to take effect!', Colors.Error);
        Exit;
      end;

      TryToSendData('UPTIME');
    end
    else if (sl[0] = 'KICK') and (CameFromBattleScreen) then
    begin

      if not BattleForm.IsBattleActive then
      begin
        AddMainLog('Denied: Battle is not active!', Colors.Error);
        Exit;
      end;

      if not (sl.Count = 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      if not (BattleState.Status = Hosting) then
      begin
        AddMainLog('Denied: Only host can kick players from battle!', Colors.Error);
        Exit;
      end;

      if BattleState.Battle.GetClient(sl[1]) = nil then
      begin
        AddMainLog('Denied: Player ' + sl[1] + ' not found in this battle. (Note: all names are case-sensitive)', Colors.Error);
        Exit;
      end;

      MainForm.TryToSendData('KICKFROMBATTLE ' + sl[1]);
    end
    else if (sl[0] = 'KICK') and (not CameFromBattleScreen) then
    begin
      if (sl.Count < 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      if sl.Count > 2 then tmp := ' ' + MakeSentence(sl, 2)
      else tmp := '';

      if MainForm.GetClient(sl[1]) = nil then
      begin
        MessageDlg('Invalid KICK command. User does not exist! (Note: all names are case-sensitive)', mtWarning, [mbOK], 0);
        Exit;
      end;

      MainForm.TryToSendData('KICKUSER ' + sl[1] + tmp);
    end
    else if (sl[0] = 'RENAME') then
    begin
      if not (sl.Count = 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      AddMainLog('Requesting account rename from the server ...', Colors.Info);
      MainForm.TryToSendData('RENAMEACCOUNT ' + sl[1]);
    end
    else if (sl[0] = 'PASSWORD') then
    begin
      if not (sl.Count = 3) then
      begin
        AddMainLog('Denied: This command requires exactly 2 arguments!', Colors.Error);
        Exit;
      end;

      AddMainLog('Trying to change password ...', Colors.Info);
      MainForm.TryToSendData('CHANGEPASSWORD ' + Misc.GetMD5Hash(sl[1]) + ' ' + Misc.GetMD5Hash(sl[2])); 
    end
    else if (sl[0] = 'BAN') then
    begin
      if (sl.Count < 2) then
      begin
        AddMainLog('Invalid command syntax (BAN). More arguments required!', Colors.Error);
        Exit;
      end;

      tmp := '';
      if sl.Count > 2 then tmp := Misc.MakeSentence(sl, 2);

      MainForm.TryToSendData('BANLISTADD ' + sl[1] + ' ' + tmp);
    end
    else if (sl[0] = 'UNBAN') and (not CameFromBattleScreen) then
    begin
      if not (sl.Count = 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      MainForm.TryToSendData('BANLISTREMOVE ' + sl[1]);
    end
    else if (sl[0] = 'BANLIST') and (not CameFromBattleScreen) then
    begin
      MainForm.TryToSendData('BANLIST');
    end
    else if (sl[0] = 'TOPIC') and (not CameFromBattleScreen) then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Not enough arguments specified!', Colors.Error);
        Exit;
      end;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog('Error: Bad syntax!', Colors.Error);
        Exit;
      end;

      TryToSendData('CHANNELTOPIC ' + Copy(sl[1], 2, Length(sl[1])-1) + ' ' + MakeSentence(sl, 2));
    end
    else if (sl[0] = 'CHANMSG') then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Not enough arguments specified!', Colors.Error);
        Exit;
      end;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog('Error: Bad syntax!', Colors.Error);
        Exit;
      end;

      TryToSendData('CHANNELMESSAGE ' + Copy(sl[1], 2, Length(sl[1])-1) + ' ' + MakeSentence(sl, 2));
    end
    else if (sl[0] = 'INGAME') then
    begin
      str := MakeSentence(sl, 1);
      if str = '' then MainForm.TryToSendData('GETINGAMETIME')
      else MainForm.TryToSendData('GETINGAMETIME ' + str);
    end
    else if (sl[0] = 'IP') then
    begin
      if (sl.Count < 2) then
      begin
        AddMainLog('Denied: Missing arguments!', Colors.Error);
        Exit;
      end;

      if MainForm.GetClient(sl[1]) = nil then
      begin
        MessageDlg('Invalid IP command. User is not online! (Note: all names are case-sensitive)', mtWarning, [mbOK], 0);
        Exit;
      end;

      MainForm.TryToSendData('GETIP ' + sl[1]);
    end
    else if (sl[0] = 'FINDIP') then
    begin
      if (sl.Count < 2) then
      begin
        AddMainLog('Denied: Missing arguments!', Colors.Error);
        Exit;
      end;

      MainForm.TryToSendData('FINDIP ' + sl[1]);
    end
    else if (sl[0] = 'LASTLOGIN') then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      MainForm.TryToSendData('GETLASTLOGINTIME ' + sl[1]);
    end
    else if (sl[0] = 'LASTIP') then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      MainForm.TryToSendData('GETLASTIP ' + sl[1]);
    end
    else if (sl[0] = 'MUTE') then
    begin
      if (sl.Count < 3) then
      begin
        AddMainLog('Denied: Missing arguments!', Colors.Error);
        Exit;
      end;

      if (sl.Count > 3) then
        try
          duration := StrToInt(sl[3])
        except
          AddMainLog('Error in MUTE command: Duration must be an integer!', Colors.Error);
          Exit;
        end
      else duration := 0;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog('Error: Bad syntax!', Colors.Error);
        Exit;
      end;

      TryToSendData('MUTE ' + Copy(sl[1], 2, Length(sl[1])-1) + ' ' + sl[2] + ' ' + IntToStr(duration));
    end
    else if (sl[0] = 'UNMUTE') then
    begin
      if (sl.Count <> 3) then
      begin
        AddMainLog('Denied: Missing arguments!', Colors.Error);
        Exit;
      end;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog('Error: Bad syntax!', Colors.Error);
        Exit;
      end;

      TryToSendData('UNMUTE ' + Copy(sl[1], 2, Length(sl[1])-1) + ' ' + sl[2]);
    end
    else if (sl[0] = 'MUTELIST') then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog('Denied: Missing arguments!', Colors.Error);
        Exit;
      end;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog('Error: Bad syntax!', Colors.Error);
        Exit;
      end;

      TryToSendData('MUTELIST ' + Copy(sl[1], 2, Length(sl[1])-1));
    end
    else if (sl[0] = 'TESTNOTIFY') then
    begin
      AddNotification('Test', 'This is only a test.', 2000);
    end
    else if (sl[0] = 'TESTUDP') then
    begin
      i := 5000;
      Misc.SendUDPStr('192.168.1.1', 5000, i, 'PING');
//***      Misc.SendUDPStr('localhost', 8201, 0, 'Betalord');
    end
    else if (sl[0] = 'TESTMD5') then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Not enough arguments specified!', Colors.Error);
        Exit;
      end;

      MainForm.AddMainLog(GetMD5Hash(MakeSentence(sl, 1)), Colors.Info);
    end
    else if (sl[0] = 'TESTCRASH') then
    begin
      GetMem(p, 10);
      FreeMem(p);
      FreeMem(p);
    end
    else if (sl[0] = 'TESTFLOOD') then
    begin
      for i := 0 to 500 do TryToSendData('bla bla bla bla bla bla bla bla bla bla bla bla');
    end
    else if (sl[0] = 'TESTAGREEMENT') then
    begin
      AgreementForm.ShowModal;
    end
    else if (sl[0] = 'LOCALIP') then
    begin
      AddMainLog('Local IP address: ' + Misc.GetLocalIP, Colors.Error);
    end
    else if (sl[0] = 'PING') then
    begin
      if sl.Count > 1 then
      begin
        AddMainLog('Error: Too many arguments!', Colors.Error);
        Exit;
      end;
      key := Random(65536);
      New(pinginfo);
      pinginfo.Key := key;
      pinginfo.TimeSent := GetTickCount;
      Pings.Add(pinginfo);
      TryToSendData('PING ' + IntToStr(key));
      AddMainLog('Pinging server ...', Colors.Info);
    end
    else if (sl[0] = 'MSG') then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Too few arguments!', Colors.Error);
        Exit;
      end;

      if MainForm.GetClient(sl[1]) = nil then
      begin
        AddMainLog('User <' + sl[1] + '> not found!', Colors.Error);
        Exit;
      end;

      TryToSendData('SAYPRIVATE ' + sl[1] + ' ' + MakeSentence(sl, 2));
    end
    else AddMainLog('Unknown command!', Colors.Error);

  finally
    if sl <> nil then sl.Free;
  end;

end;


procedure TMainForm.ProcessRemoteCommand(s: string); // processes command received from server
var
  sl: TStringList;
  sl2: TStringList; // temp.
  i, j, k, l, m, n, o, p, r, t: Integer;
  BattleIndex: Integer;
  Battle: TBattle;
  Client: TClient;
  Bot: TBot;
  tmp, tmp2: string;
  tmpInt, tmpInt2: Integer;
  tmpBool: Boolean;
  changed: Boolean;
  count: Integer;
  tmpi64: Int64;
  rect: TRect;
  index, key: Integer;
  battletype, nattype: Integer;
  ms: TMemoryStream;
begin

  if s = '' then Exit;
  sl := ParseString(s, ' ');
  sl[0] := UpperCase(sl[0]);

  try // try..finally
    ProcessingRemoteCommand := True;

    if sl[0] = 'TASSERVER' then
    begin
      if (sl.Count < 3) or (not CheckServerVersion(sl[1])) then
      begin
        AddMainLog('This server version is not supported with this client!', Colors.Info);
        AddMainLog('Requesting update from server ...', Colors.Info);
        TryToSendData('REQUESTUPDATEFILE ' + VERSION_NUMBER); // we ask server if he has an update for us
        Exit;
      end;

      try
        Status.NATHelpServerPort := StrToInt(sl[2]);
      except
        AddMainLog('This server version is not supported with this client!', Colors.Info);
        AddMainLog('Requesting update from server ...', Colors.Info);
        TryToSendData('REQUESTUPDATEFILE ' + VERSION_NUMBER); // we ask server if he has an update for us
        Exit;
      end;

      if Status.Registering then TryToRegister(Preferences.Username, Preferences.Password)
      else TryToLogin(Preferences.Username, Preferences.Password);
    end
    else if sl[0] = 'REDIRECT' then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 0);
        Exit;
      end;
      AddMainLog('Server is redirecting us to: ' + sl[1], Colors.Info);
      Preferences.ServerIP := sl[1];
      PostMessage(MainForm.Handle, WM_FORCERECONNECT, 0, 0); // we must post a message, reconnecting from here won't work
    end
    else if sl[0] = 'AGREEMENT' then
    begin
      if sl.Count < 2 then
      begin
        ReceivedAgreement.Add('');
      end
      else
        ReceivedAgreement.Add(MakeSentence(sl, 1));
    end
    else if sl[0] = 'AGREEMENTEND' then
    begin
      tmp := ReceivedAgreement.Text;
      ms := TMemoryStream.Create;
      ms.WriteBuffer(tmp[1], Length(tmp));
      ms.Position := 0;
      AgreementForm.RichEdit1.Lines.LoadFromStream(ms);
      ms.Free;
      AgreementForm.ShowModal;
    end
    else if sl[0] = 'DENIED' then
    begin
      if sl.Count = 1 then tmp := 'Unknown reason' else tmp := MakeSentence(sl, 1);
      MessageDlg('Error logging to server: ' + tmp, mtWarning, [mbOK], 0);
      AddMainLog('Login failed: ' + tmp, Colors.Error);
      TryToDisconnect;
    end
    else if sl[0] = 'ACCEPTED' then
    begin
      ConnectButton.Glyph := nil; // we have to tell speedbutton somehow that he is about to be changed
      ConnectionStateImageList.GetBitmap(2, ConnectButton.Glyph);
      AddMainLog('Login successful!', Colors.Info);
      Status.LoggedIn := True;
      if sl.Count > 1 then Status.Username := sl[1]; // this should always evaluate to TRUE
      PlayResSound('connect');

      if Preferences.JoinMainChannel then ProcessCommand('JOIN #main', False); // join #main immediately after user has been logged in
      PerformForm.PerformCommands;
    end
    else if sl[0] = 'REGISTRATIONACCEPTED' then
    begin
      AddMainLog('Registration successful!', Colors.Info);
      Status.Registering := False;
      TryToLogin(Preferences.Username, Preferences.Password);
    end
    else if sl[0] = 'REGISTRATIONDENIED' then
    begin
      if sl.Count > 1 then
        AddMainLog('Registration failed: ' + MakeSentence(sl, 1), Colors.Error)
      else
        AddMainLog('Registration failed: Unknown reason', Colors.Error);

      Status.Registering := False;
      TryToDisconnect;
    end
    else if sl[0] = 'MOTD' then
    begin
      if sl.Count < 2 then
      AddMainLog('-', Colors.MOTD)
      else
      AddMainLog('- ' + MakeSentence(sl, 1), Colors.MOTD);
    end
    else if sl[0] = 'JOINFAILED' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 1);
      end
      else
      begin
        AddMainLog('Unable to join channel #' + sl[1] + ' (' + MakeSentence(sl, 2) + ')', Colors.Info);
      end;
    end
    else if sl[0] = 'OFFERFILE' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 2);
        Exit;
      end;

      sl2 := ParseString(MakeSentence(sl, 2), #9);
      if sl2.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 2);
        Exit;
      end;

      try
        tmpint := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 2);
        Exit;
      end;

      if MessageDlg('Server is offering you a file. This is what server has to say about it:' + #13#13 + sl2[2] + #13#13 + 'Do you wish to accept it?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
      begin // user has accepted the file
        DownloadFile.URL := sl2[1];
        DownloadFile.FileName := sl2[0];
        DownloadFile.ServerOptions := tmpint;
        PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);
      end
      else if (tmpint and 4) = 4 then TryToDisconnect;
    end
    else if sl[0] = 'UDPSOURCEPORT' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 3);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 3);
        Exit;
      end;

      // port will get assigned by method in InitWaitForm, since it is not
      // neccessary for us to update it (perhaps we want to drop it as we
      // already received it before or we don't wait for it anymore at all)
      PostMessage(InitWaitForm.Handle, WM_UDP_PORT_ACQUIRED, i, 0);
    end
    else if sl[0] = 'CLIENTPORT' then
    begin
      if sl.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 4);
        Exit;
      end;

      Client := GetClient(sl[1]);
      if Client = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 5);
        Exit;
      end;

      try
        Client.PublicPort := StrToInt(sl[2]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 4);
        Exit;
      end;
    end
    else if sl[0] = 'HOSTPORT' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 6);
        Exit;
      end;

      if BattleFormUnit.BattleState.Status = None then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 7);
        Exit;
      end;

      try
        BattleState.Battle.Port := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 6);
        Exit;
      end;
    end
    else if sl[0] = 'ADDUSER' then
    begin
      if sl.Count <> 5 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 8);
        Exit;
      end;

      try
        tmpint := StrToInt(sl[3]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 8);
        Exit;
      end;

      AddClientToAllClientsList(sl[1], 0, LowerCase(sl[2]), tmpint, sl[4]); // server will update client's status later
      if PageControl1.ActivePage.Caption = LOCAL_TAB then UpdateClientsListBox;

      i := GetTabWindowPageIndex(sl[1]);
      if i <> -1 then
      begin
        if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]) then ; // nevermind, just ignore it
        if PageControl1.ActivePage.Caption = sl[1] then UpdateClientsListBox;
      end;

    end
    else if sl[0] = 'REMOVEUSER' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 9);
        Exit;
      end;
      { We don't need to manually remove client from channels or battle, since
        server notifies us with "LEFT"/"LEFTBATTLE" commands. However, we must
        manually remove client from a private chat if it is open. }

      i := GetTabWindowPageIndex(sl[1]);
      if i <> -1 then RemoveClientFromTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]);

      if not RemoveClientFromAllClientsList(sl[1]) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 9);
      end;

      UpdateClientsListBox;
    end
    else if sl[0] = 'ADDBOT' then
    begin
      if sl.Count < 6 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 10);
        Exit;
      end;

      try
        tmpint := StrToInt(sl[1]);
        tmpint2 := StrToInt(sl[4]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 10);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 11);
        Exit;
      end;

      Battle := BattleState.Battle;
      if Battle.ID <> tmpint then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 12);
        Exit;
      end;

      if Battle.GetBot(sl[2]) <> nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 10);
        AddMainLog('Disconnecting from battle due to inconsistent data error', Colors.Error);
        TryToSendData('LEAVEBATTLE');
        Exit;
      end;

      Bot := TBot.Create(sl[2], sl[3], MakeSentence(sl, 5));
      Bot.BattleStatus := tmpInt2;

      Battle.Bots.Add(Bot);
      VDTBattles.InvalidateNode(Battle.Node);

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          BattleForm.UpdateClientsListBox;
        end;

    end
    else if sl[0] = 'REMOVEBOT' then
    begin

      if sl.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        tmpint := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := BattleState.Battle;
      if Battle.ID <> tmpint then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Bot := GetBot(sl[2], Battle);
      if Bot = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Bot.Free;
      Battle.Bots.Remove(Bot);
      VDTBattles.InvalidateNode(Battle.Node);

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          BattleForm.UpdateClientsListBox;
        end;

    end
    else if sl[0] = 'UPDATEBOT' then
    begin
      if sl.Count <> 4 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        tmpint2 := StrToInt(sl[1]);
        tmpint := StrToInt(sl[3]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not (BattleState.Battle.ID = tmpInt2) then Exit;

      Battle := BattleState.Battle;

      if Battle.ID <> tmpint2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        AddMainLog('Disconnecting from battle due to inconsistent data error', Colors.Error);
        TryToSendData('LEAVEBATTLE');
        Exit;
      end;

      Bot := GetBot(sl[2], Battle);
      if Bot = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Bot.BattleStatus := tmpInt;

      BattleForm.UpdateClientsListBox;
    end
    else if sl[0] = 'ADDSTARTRECT' then
    begin
      if sl.Count <> 6 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        index := StrToInt(sl[1]);
        Rect.Left := StrToInt(sl[2]);
        Rect.Top := StrToInt(sl[3]);
        Rect.Right := StrToInt(sl[4]);
        Rect.Bottom := StrToInt(sl[5]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if BattleState.Status = Hosting then
      begin
        // this could happen due to lag (we could get this command from our previous battle, where we didn't host)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := BattleState.Battle;

      if (index < 0) or (index > 9) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if BattleState.StartRects[index].Enabled then
      begin
        // this is a pretty serious error. It should not happen though. Client will have different start rects than other clients.
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.AddStartRect(index, rect);
    end
    else if sl[0] = 'REMOVESTARTRECT' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        index := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if BattleState.Status = Hosting then
      begin
        // this could happen due to lag (we could get this command from our previous battle, where we didn't host)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := BattleState.Battle;

      if (index < 0) or (index > 9) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleState.StartRects[index].Enabled then
      begin
        // this is a pretty serious error. It should not happen though. Client will have different start rects than other clients.
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.RemoveStartRect(index);
    end
    else if sl[0] = 'JOIN' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      end
      else
      begin
        i := GetTabWindowPageIndex('#' + sl[1]);
        if i = -1 then i := AddTabWindow('#' + sl[1])
        else ChangeActivePageAndUpdate(PageControl1, i);

        AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Now talking in ' + PageControl1.ActivePage.Caption, Colors.ChanJoin);
      end;
    end
    else if sl[0] = 'CLIENTS' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      for j := 2 to sl.Count-1 do
        if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[j]) then
        begin
          AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
          Exit;
        end;

      UpdateClientsListBox;
    end
    else if sl[0] = 'CHANNEL' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      tmp2 := sl[2]; // number of users in the channel
      if sl.Count > 4 then tmp := '  (' + MakeSentence(sl, 3) + ')'
      else tmp := '';
      AddMainLog('+ ' + '#' + sl[1] + EnumerateSpaces(Max(0, 20-Length(sl[1])-Length(tmp2))) + tmp2 + tmp, Colors.Normal);
    end
    else if sl[0] = 'ENDOFCHANNELS' then
    begin
      AddMainLog('-- END OF CHANNEL LIST --', Colors.Normal);
    end
    else if sl[0] = 'JOINED' then
    begin
      if sl.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[2]) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not Preferences.FilterJoinLeftMessages then
        AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* ' + sl[2] + ' has joined ' + PageControl1.Pages[i].Caption, Colors.ChanJoin);

      if NotificationsForm.FindNotification(nfJoinedChannel, [sl[2], '#' + sl[1]]) then AddNotification('Player joined', '<' + sl[2] + '> has joined ' + PageControl1.Pages[i].Caption, 2000);

      UpdateClientsListBox;
    end
    else if sl[0] = 'LEFT' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not RemoveClientFromTab(PageControl1.Pages[i] as TMyTabSheet, sl[2]) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not Preferences.FilterJoinLeftMessages then
      begin
        tmp := '';
        if sl.Count > 3 then tmp := ' (' + MakeSentence(sl, 3) + ')';
        AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* ' + sl[2] + ' has left ' + PageControl1.Pages[i].Caption + tmp, Colors.ChanLeft);
      end;

      UpdateClientsListBox;
    end
    else if sl[0] = 'FORCELEAVECHANNEL' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if sl.Count = 3 then tmp := '' else tmp := ' (' + MakeSentence(sl, 3) + ')';
      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* You have been kicked from #' + sl[1] + ' by <' + sl[2] + '>' + tmp, Colors.Info);
      (PageControl1.Pages[i] as TMyTabSheet).Clients.Clear;

      UpdateClientsListBox;
    end
    else if sl[0] = 'CHANNELTOPIC' then
    begin
      if sl.Count < 5 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        tmpi64 := StrToInt64(sl[3]);
        tmp := FormatDateTime('mmm d "at" hh:mm AM/PM', UTCTimeToLocalTime(UnixToDateTime(tmpi64 div 1000)));
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Topic is ''' + MakeSentence(sl, 4) + '''', Colors.Topic);
      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Set by ' + sl[2] + ' on ' + tmp, Colors.Topic);
    end
    else if sl[0] = 'SAID' then
    begin
      if sl.Count < 4 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + sl[2] + '> ' + MakeSentence(sl, 3), Colors.Normal, Length(sl[2])+2);
    end
    else if sl[0] = 'CHANNELMESSAGE' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Channel message: ' + MakeSentence(sl, 2), Colors.Info);
    end
    else if sl[0] = 'SAIDEX' then
    begin
      if sl.Count < 4 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;
      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* ' + sl[2] + ' ' + MakeSentence(sl, 3), Colors.SayEx);
    end
    else if sl[0] = 'SAIDPRIVATE' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex(sl[1]);
      if i = -1 then
      begin
        i := AddTabWindow(sl[1]);
        if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]) then
        begin
          AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
          Exit;
        end;
        UpdateClientsListBox;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + sl[1] + '> ' + MakeSentence(sl, 2), Colors.Normal, Length(sl[1])+2);

      // add notification if private message and if application isn't focused:
      if (not Application.Active) and (NotificationsForm.CheckBox1.Checked) then AddNotification('Private message', '<' + sl[1] + '> ' + MakeSentence(sl, 2), 2500);
    end
    else if sl[0] = 'SAYPRIVATE' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      i := GetTabWindowPageIndex(sl[1]);
      if i = -1 then
      begin
        i := AddTabWindow(sl[1]);
        if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]) then
        begin
          AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
          Exit;
        end;
        UpdateClientsListBox;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + Status.Username + '> ' + MakeSentence(sl, 2), Colors.Normal, Length(Status.Username)+2);
    end
    else if sl[0] = 'PONG' then
    begin
      if sl.Count > 1 then
      begin
        try
          key := StrToInt(sl[1]);
        except
          key := 0;
        end;
        for i := 0 to Pings.Count-1 do if PPingInfo(Pings[i]).Key = key then
        begin
          AddMainLog('Ping reply took ' + IntToStr(GetTickCount - PPingInfo(Pings[i]).TimeSent) + ' ms.', Colors.Info);
          Pings.Delete(i);
          Break;
        end;
        // if key was not found, ignore it
      end;
    end
    else if sl[0] = 'SAIDBATTLE' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.AddTextToChat('<' + sl[1] + '> ' + MakeSentence(sl, 2), Colors.Normal, Length(sl[1])+2);
    end
    else if sl[0] = 'SAIDBATTLEEX' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.AddTextToChat('* ' + sl[1] + ' ' + MakeSentence(sl, 2), Colors.SayEx, 1);
    end
    else if sl[0] = 'REQUESTBATTLESTATUS' then
    begin
      if sl.Count <> 1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.FigureOutBestPossibleTeamAllyAndColor;

      Status.BattleStatusRequestReceived := True;
      if Status.Hashing then
      begin
        Status.BattleStatusRequestReceived := True; // we'll leave the other method to send battle status, since hashing is not complete yet
      end
      else
      begin
        BattleForm.SendMyBattleStatusToServer;
        Status.BattleStatusRequestSent := True;
      end;

    end
    else if sl[0] = 'JOINBATTLE' then
    begin
      if sl.Count <> 11 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if BattleForm.IsBattleActive then // we are already in battle! (this can't really happen)
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        MainForm.TryToSendData('LEAVEBATTLE');
        BattleForm.DisconnectButton.OnClick(nil);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
        j := StrToInt(sl[2]);
        k := StrToInt(sl[3]);
        l := StrToInt(sl[4]);
        m := StrToInt(sl[5]);
        n := StrToInt(sl[6]);
        o := StrToInt(sl[7]);
        p := StrToInt(sl[8]);
        r := StrToInt(sl[9]);
        t := StrToInt(sl[10]);

      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := GetBattle(i);
      if Battle = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      tmpBool := False;
      if Battle.BattleType = 0 then tmpBool := BattleForm.JoinBattle(i) else tmpBool := BattleForm.JoinBattleReplay(i);
      if tmpBool then
      begin
        Status.BattleStatusRequestReceived := False;
        Status.BattleStatusRequestSent := False;

        // update battle parameters:
        Battle.HashCode := t;

        BattleForm.MetalTracker.Value := j;
        BattleForm.EnergyTracker.Value := k;
        BattleForm.UnitsTracker.Value := l;
        BattleForm.StartPosRadioGroup.ItemIndex := m;
        BattleForm.GameEndRadioGroup.ItemIndex := n;
        BattleForm.LimitDGunCheckBox.Checked := IntToBool(o);
        BattleForm.DiminishingMMsCheckBox.Checked := IntToBool(p);
        BattleForm.GhostedBuildingsCheckBox.Checked := IntToBool(r);

        // we have to change mod before hashing it:
        Status.Hashing := True; // we need this so that we know we must wait for hashing to finish when we receive REQUESTBATTLESTATUS command (we can receive it in "parallel", while hashing!)
        InitWaitForm.ChangeCaption(MSG_MODCHANGE);
        InitWaitForm.TakeAction := 0; // change mod
        InitWaitForm.ChangeToMod := Battle.ModName;
        InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)
        if GetModHash(Battle.ModName) = Battle.HashCode then Status.Synced := True else Status.Synced := False;
        Status.Hashing := False;

        if Status.BattleStatusRequestReceived and not Status.BattleStatusRequestSent then
        begin
          BattleForm.SendMyBattleStatusToServer;
          Status.BattleStatusRequestSent := True;
        end; // else the method which will receive the request will also send the battle status

        BattleForm.Show;
      end
      else MainForm.AddMainLog('Error: unable to join battle.', Colors.Error);

    end
    else if sl[0] = 'JOINBATTLEFAILED' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddMainLog('Failed to join the battle (Reason: ' + MakeSentence(sl, 1) + ')', Colors.Error);
    end
    else if sl[0] = 'OPENBATTLEFAILED' then
    begin
      tmp := 'Unknown error';
      if sl.Count > 1 then tmp := MakeSentence(sl, 1);
      WaitForAckForm.OnCancelHosting(tmp);
    end
    else if sl[0] = 'BATTLEOPENED' then
    begin
      if sl.Count < 11 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      sl2 := ParseString(MakeSentence(sl, 10), #9);

      if sl2.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        battletype := StrToInt(sl[2]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        nattype := StrToInt(sl[3]);
        if (nattype < 0) or (nattype > 2) then raise Exception.CreateFmt('Invalid NAT traversal method index', []);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Client := GetClient(sl[4]);
      if Client = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      tmp := sl[5]; // IP

      try
        j := StrToInt(sl[6]);
        k := StrToInt(sl[7]);
        tmpBool := IntToBool(StrToInt(sl[8]));
        l := StrToInt(sl[9]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddBattle(i, battletype, nattype, Client, tmp, j, k, tmpBool, l, sl2[0], sl2[1], sl2[2]);  
      SortBattleInList(Battles.Count-1, Preferences.BattleSortStyle);
      VDTBattles.Invalidate;
      
      Client.InBattle := True;
      if (not Application.Active) or (not BattleForm.Active) then if NotificationsForm.FindNotification(nfStatusInBattle, [Client.Name]) then AddNotification('Player opened new battle', '<' + Client.Name + '> is hosting new game.', 2000);

      // re-sort all clients lists:
      if Preferences.SortStyle = 2 then
        for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
          SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);

      UpdateClientsListBox;
    end
    else if sl[0] = 'BATTLECLOSED' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        BattleIndex := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := GetBattle(BattleIndex);
      if Battle = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      for i := 0 to Battle.Clients.Count-1 do TClient(Battle.Clients[i]).InBattle := False;

      // re-sort all clients lists:
      if Preferences.SortStyle = 2 then
        for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
          SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);

      UpdateClientsListBox;

      if (BattleForm.IsBattleActive) and (BattleState.Battle.ID = Battle.ID) then
      begin
        BattleForm.ResetBattleScreen;
      end;

      RemoveBattle(BattleIndex);
    end
    else if sl[0] = 'OPENBATTLE' then
    begin
      if (not WaitForAckForm.Visible) or (not WaitForAckForm.Waiting) then // we are not hosting a battle! This is an error. We must tell the server to cancel this battle. (Note: this should not happen normally. Perhaps only if server lags really badly)
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        TryToSendData('LEAVEBATTLE');
        Exit;
      end;

      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := GetBattle(i);
      if Battle = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      { Be careful: You shouldn't call any methods that calls Application.ProcessMessages before
        calling HostBattle method, because OnSocketDataAvailable may get triggered and we may receive REQUESTBATTLESTATUS
        command before we even hosted - this would be an error. }

      // accept hosting:
      if Battle.BattleType = 0 then
        BattleForm.HostBattle(i)
      else
        BattleForm.HostBattleReplay(i);

      Status.Synced := True; // host is always synced with himself!
      WaitForAckForm.ModalResult := mrOK;
    end
    else if sl[0] = 'JOINEDBATTLE' then
    begin
      if sl.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := GetBattle(i);
      if Battle = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Client := GetClient(sl[2]);
      if Client = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Client.BattleStatus := 0;

      Battle.Clients.Add(Client);
      VDTBattles.InvalidateNode(Battle.Node);
      Client.InBattle := True;
      if (not Application.Active) or (not BattleForm.Active) then
        if (not ((BattleForm.IsBattleActive) and (Battle.ID = BattleState.Battle.ID) and (NotificationsForm.FindNotification(nfJoinedBattle, [])))) then
          if NotificationsForm.FindNotification(nfStatusInBattle, [Client.Name]) then AddNotification('Player joined battle', '<' + Client.Name + '> has joined ' + TClient(Battle.Clients[0]).Name + '''s battle.' , 2000);


      // re-sort all clients lists:
      if Preferences.SortStyle = 2 then
        for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
          SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);

      UpdateClientsListBox;
      SortBattleInList(Battle.Node.Index, Preferences.BattleSortStyle);
      VDTBattles.Invalidate;

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          BattleForm.AddTextToChat('* ' + Client.Name + ' has joined battle', Colors.ChanJoin, 1);
          BattleForm.UpdateClientsListBox;
          if BattleState.Status = Hosting then
          begin
            Inc(Battle.SpectatorCount); //*** test
            BattleForm.SendBattleInfoToServer;
          end;

          if not BattleForm.Active then if NotificationsForm.FindNotification(nfJoinedBattle, []) then AddNotification('Player joined battle', '<' + Client.Name + '> has joined battle.', 2000);
        end;
    end
    else if sl[0] = 'LEFTBATTLE' then
    begin
      if sl.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := GetBattle(i);
      if Battle = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Client := GetClient(sl[2]);
      if Client = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle.Clients.Remove(Client);
      VDTBattles.InvalidateNode(Battle.Node);
      Client.InBattle := False;

      // re-sort all clients lists:
      if Preferences.SortStyle = 2 then
        for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
          SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);

      UpdateClientsListBox;
      SortBattleInList(Battle.Node.Index, Preferences.BattleSortStyle);
      VDTBattles.Invalidate;

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          BattleForm.AddTextToChat('* ' + Client.Name + ' has left battle', Colors.ChanJoin, 1);
          BattleForm.UpdateClientsListBox;

          if BattleState.Status = Hosting then
          begin
            tmpInt := BattleState.Battle.SpectatorCount;

            // update spectator count:
            count := 0;
            for i := 0 to Battle.Clients.Count-1 do if TClient(Battle.Clients[i]).GetMode = 0 then Inc(count);
            Battle.SpectatorCount := count;

            tmpBool := BattleState.Battle.SpectatorCount <> tmpInt; // did SpectatorCount change?
            if tmpBool then BattleForm.SendBattleInfoToServer;
          end;
        end;
    end
    else if sl[0] = 'CLIENTSTATUS' then
    begin
      if sl.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Client := GetClient(sl[1]);
      if Client = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        tmpInt := StrToInt(sl[2]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      tmpBool := Client.GetInGameStatus;
      Client.Status := tmpInt;
      changed := Client.GetInGameStatus <> tmpBool;

      if changed and (Preferences.SortStyle = 2) then
        for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
          SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);

      // let's check if this client is founder of any battle. If he is, we must refresh this battle's node. We must also check if he is the founder of the battle user is participating in.
      if Client.InBattle then
        for i := 0 to Battles.Count-1 do if TClient(TBattle(Battles[i]).Clients[0]).Name = Client.Name then
        begin
          if (BattleFormUnit.BattleState.Status = Joined) and (BattleState.Battle.ID = TBattle(Battles[i]).ID) and (Client.GetInGameStatus) and (changed) and (not Status.AmIInGame) then
          begin
            PostMessage(BattleForm.Handle, WM_STARTGAME, 0, 0);
            // if founder of the battle we are participating in just went in-game, we must launch the game too!
          end;
          SortBattleInList(TBattle(Battles[i]).Node.Index, Preferences.BattleSortStyle);
          VDTBattles.Invalidate; // since multiple nodes could be moved when calling SortBattleInList
          Break;
        end;

      if Client.Name = Status.Username then Status.MyRank := Client.GetRank;

      UpdateClientsListBox;
    end
    else if sl[0] = 'UPDATEBATTLEINFO' then
    begin
      if sl.Count < 4 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        tmpInt := StrToInt(sl[1]);
        tmpInt2 := StrToInt(sl[2]);
        tmpBool := IntToBool(StrToInt(sl[3]));
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle := GetBattle(tmpInt);
      if Battle = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Battle.Map := MakeSentence(sl, 4);
      Battle.SpectatorCount := tmpInt2;
      Battle.Locked := tmpBool;
      VDTBattles.InvalidateNode(Battle.Node);

      if BattleForm.IsBattleActive then if Battle.ID = BattleState.Battle.ID then
      begin
        if BattleState.Status <> Hosting then BattleForm.LockedCheckBox.Checked := Battle.Locked;

        tmpInt := BattleForm.MapList.Items.IndexOf(Battle.Map);
        if tmpInt = -1 then
        begin
          if BattleState.Status = Hosting then
          begin // this should NEVER happen!
            MessageDlg('Error: Map changed to unknown map! Please report this error!', mtError, [mbOK], 0);
            Application.Terminate;
            Exit;
          end;

          BattleForm.ChangeMapToNoMap(Battle.Map);
        end
        else
        begin
          if BattleState.Status <> Hosting then // no point in changing map again, we just did that
          begin
            TmpInt2 := BattleForm.MapList.ItemIndex;
            BattleForm.MapList.ItemIndex := tmpInt;
            if tmpInt <> TmpInt2 then
              BattleForm.MapList.OnClick(nil); // we MUST send nil as parameter, since the event checks if Sender is nil and that way he knows whether user clicked on map list or not
          end;
        end;
      end;

    end
    else if sl[0] = 'UPDATEBATTLEDETAILS' then
    begin
      if sl.Count <> 9 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if BattleFormUnit.BattleState.Status = None then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
        j := StrToInt(sl[2]);
        k := StrToInt(sl[3]);
        l := StrToInt(sl[4]);
        m := StrToInt(sl[5]);
        o := StrToInt(sl[6]);
        p := StrToInt(sl[7]);
        r := StrToInt(sl[8]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if (l < 0) or (l > 2) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if (m < 0) or (m > 1) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AllowBattleDetailsUpdate := False;
      BattleForm.MetalTracker.Value := i;
      BattleForm.EnergyTracker.Value := j;
      BattleForm.UnitsTracker.Value := k;
      BattleForm.StartPosRadioGroup.ItemIndex := l;
      BattleForm.GameEndRadioGroup.ItemIndex := m;
      BattleForm.LimitDGunCheckBox.Checked := IntToBool(o);
      BattleForm.DiminishingMMsCheckBox.Checked := IntToBool(p);
      BattleForm.GhostedBuildingsCheckBox.Checked := IntToBool(r);
      AllowBattleDetailsUpdate := True;
    end
    else if sl[0] = 'CLIENTBATTLESTATUS' then
    begin
      if sl.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Client := GetClient(sl[1]);
      if Client = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        tmpInt := StrToInt(sl[2]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;


      tmpInt2 := Client.GetMode;
      Client.BattleStatus := tmpInt;
      tmpBool := Client.GetMode <> tmpInt2; // did player change his mode from spectator to player (or vice versa)?

      BattleForm.UpdateClientsListBox;
      if Client.Name = Status.Username then
        BattleForm.SetMyBattleStatus(Client.GetSide, Client.GetReadyStatus, Client.GetTeamNo, Client.GetAllyNo, Client.GetMode, Client.GetTeamColor);

      if BattleState.Status = Hosting then if BattleState.Battle.Clients.IndexOf(Client) <> -1 then
      begin
        if tmpBool then
        begin
          // update spectator count:
          count := 0;
          for i := 0 to BattleState.Battle.Clients.Count-1 do if TClient(BattleState.Battle.Clients[i]).GetMode = 0 then Inc(count);
          BattleState.Battle.SpectatorCount := count;

          BattleForm.SendBattleInfoToServer;  
        end;
        BattleForm.StartButton.Enabled := BattleState.Battle.AreAllClientsReady and BattleState.Battle.AreAllClientsSynced;
      end;

    end
    else if sl[0] = 'FORCEQUITBATTLE' then
    begin
      if sl.Count <> 1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.AddTextToChat('You were kicked from battle!', Colors.Info, 1);
      BattleForm.DisconnectButton.OnClick(nil);
    end
    else if sl[0] = 'DISABLEUNITS' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.DisabledUnitsListBox.Items.Clear;
      for i := 1 to sl.Count-1 do BattleForm.DisabledUnitsListBox.Items.Add(sl[i]);
    end
    else if sl[0] = 'ENABLEUNITS' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      for i := 1 to sl.Count-1 do
      begin
        j := BattleForm.DisabledUnitsListBox.Items.IndexOf(sl[i]);
        if j = -1 then Continue;
        BattleForm.DisabledUnitsListBox.Items.Delete(j);
      end;
    end
    else if sl[0] = 'ENABLEALLUNITS' then
    begin
      if sl.Count <> 1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.DisabledUnitsListBox.Items.Clear;
    end
    else if sl[0] = 'RING' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      PlayResSound('ring');
      AddMainLog('User <' + sl[1] + '> rang', Colors.Info);
      //*** perhaps open a private chat with user and notify there?
    end
    else if sl[0] = 'BROADCAST' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddMainLog('* Broadcast from server: ' + MakeSentence(sl, 1), Colors.Info);
    end
    else if sl[0] = 'SERVERMSG' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddMainLog('* Message from server: ' + MakeSentence(sl, 1), Colors.Info);
    end
    else if sl[0] = 'SERVERMSGBOX' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      MessageDlg('Message from server: ' +#13+ MakeSentence(sl, 1), mtInformation, [mbOK], 0);
    end
    else if sl[0] = 'SCRIPTSTART' then
    begin
      if sl.Count <> 1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not (BattleState.Battle.BattleType = 1) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleReplayInfo.TempScript.Clear;
    end
    else if sl[0] = 'SCRIPT' then
    begin
      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not (BattleState.Battle.BattleType = 1) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if sl.Count < 2 then BattleReplayInfo.TempScript.Add('')
      else BattleReplayInfo.TempScript.Add(MakeSentence(sl, 1));
    end
    else if sl[0] = 'SCRIPTEND' then
    begin
      if sl.Count <> 1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not (BattleState.Battle.BattleType = 1) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleReplayInfo.Script.Text := BattleReplayInfo.TempScript.Text;
      BattleForm.ApplyScriptFile(BattleReplayInfo.Script);
    end
    else
    begin
      // unknown/invalid command!

      AddMainLog('Error: Server sent unknown or invalid command!', Colors.Error);
    end;
  finally
    ProcessingRemoteCommand := False;  
    if sl <> nil then sl.Free;
  end;

end;

procedure TMainForm.TryToCloseTab(TabSheet: TMyTabSheet);
var
  index: Integer;
begin
  if TabSheet.Caption = LOCAL_TAB then Exit;

  if TabSheet.Caption[1] = '#' then
    if Status.ConnectionState = Connected then TryToSendData('LEAVE ' + Copy(TabSheet.Caption, 2, Length(TabSheet.Caption)-1));

  index := TabSheet.PageIndex;
  TabSheet.Free;
  PageControl1.ActivePageIndex := Min(PageControl1.PageCount-1, index);
  PageControl1.OnChange(PageControl1); // because it doesn't get triggered automatically
end;

procedure TMainForm.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Key := #0; // To avoid that annoying noise when pressing #13 key (RETURN/ENTER key)
  if Key = #23 then Key := #0; // To avoid annoying noise when pressing CTRL+W
  if Key = #27 then Key := #0; // To avoid annoying noise when pressing ESC
end;

procedure TMainForm.InputEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: string;
begin
  if (Key = Ord('W')) and (ssCtrl in Shift) then
  begin
    if PageControl1.ActivePage.Caption = LOCAL_TAB then Exit;
    PostMessage(MainForm.Handle, WM_CLOSETAB, PageControl1.ActivePageIndex, 0);
    Exit;
  end;

  if Key = 13 then
  begin
    s := (Sender as TEdit).Text;
    (Sender as TEdit).Text := '';
    if s = '' then Exit;

    with ((Sender as TEdit).Parent as TMyTabSheet) do
    begin
      History.Add(s);
      HistoryIndex := History.Count-1;
    end;

    if (s[1] = '/') or (s[1] = '.') then
    begin
      ProcessCommand(Copy(s, 2, Length(s)-1), False);
      Exit;
    end;

    if ((Sender as TEdit).Parent as TMyTabSheet).Caption[1] = '$' then TryToSendData(s)
    else if ((Sender as TEdit).Parent as TMyTabSheet).Caption[1] = '#' then
      TryToSendData('SAY ' + Copy(((Sender as TEdit).Parent as TMyTabSheet).Caption, 2, Length(((Sender as TEdit).Parent as TMyTabSheet).Caption)) + ' ' + s)
    else TryToSendData('SAYPRIVATE ' + ((Sender as TEdit).Parent as TMyTabSheet).Caption + ' ' + s);
  end
  else if Key = VK_UP then
  begin
    with (Sender as TEdit).Parent as TMyTabSheet do
    begin
      if History.Count = 0 then Exit;
      HistoryIndex := Max(0, HistoryIndex - 1);
      (Sender as TEdit).Text := History[HistoryIndex];
      (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
      Key := 0;
    end;
  end
  else if Key = VK_DOWN then
  begin
    with (Sender as TEdit).Parent as TMyTabSheet do
    begin
      if History.Count = 0 then Exit;
      HistoryIndex := Min(History.Count-1, HistoryIndex + 1);
      (Sender as TEdit).Text := History[HistoryIndex];
      (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
      Key := 0;
    end;
  end
  else if Key = VK_ESCAPE then
  begin
    (Sender as TEdit).Text := '';
    Key := 0;
  end;


end;

procedure TMainForm.PageControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  i := PageControl1.IndexOfTabAt(X, Y);

  if (i >= 0) and (Button = mbRight) then TryToCloseTab(PageControl1.Pages[i] as TMyTabSheet);
end;

procedure TMainForm.ClientsListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  FlagBitmap: TBitmap;
  xpos: Integer;
begin
  if PageControl1.ActivePage.Caption = LOCAL_TAB then
  begin
    if Index > AllClients.Count-1 then Exit; // we just ignore it. It seems ClientsListBox hasn't been yet updated. This can happen when we remove items from it and we don't call UpdateClientsListBox right away, since we want to do some more things before that. Anyway, this should not happen, since ClientsListBox is changed only within the main VCL thread.

    // this ensures the correct highlite color is used
    (Control as TListBox).Canvas.FillRect(Rect);

    if odSelected in State then (Control as TListBox).Canvas.Font.Color := clWhite
    else (Control as TListBox).Canvas.Font.Color := clBlack;

    PlayerStateImageList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top, TClient(AllClients[Index]).GetStateImageIndex);
    (Control as TListBox).Canvas.TextOut(Rect.Left + PlayerStateImageList.Width, Rect.Top, TClient(AllClients[Index]).Name);
  end
  else
  begin
    if (Index = 0) and ((PageControl1.ActivePage as TMyTabSheet).Clients.Count = 0) then
    begin // a special case when we must paint first "item" in empty list box:
      // this ensures the correct highlite color is used
      (Control as TListBox).Canvas.FillRect(Rect);
      Exit;
    end
    else
      if Index > (PageControl1.ActivePage as TMyTabSheet).Clients.Count-1 then Exit; // we just ignore it. It seems ClientsListBox hasn't been yet updated. This can happen when we remove items from it and we don't call UpdateClientsListBox right away, since we want to do some more things before that. Anyway, this should not happen, since ClientsListBox is changed only within the main VCL thread.

    // this ensures the correct highlite color is used
    (Control as TListBox).Canvas.FillRect(Rect);

    xpos := Rect.Left;
    PlayerStateImageList.Draw((Control as TListBox).Canvas, xpos, Rect.Top, TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetStateImageIndex);
    Inc(xpos, PlayerStateImageList.Width + 1);

    if Preferences.ShowFlags then
    begin
      FlagBitmap := GetFlagBitmap(TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).Country);
      (Control as TListBox).Canvas.Draw(xpos, Rect.Top + 16 div 2 - FlagBitmap.Height div 2, FlagBitmap);
      Inc(xpos, FlagBitmap.Width + 5);
    end;

    if TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetAwayStatus and not TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetInGameStatus then
      (Control as TListBox).Canvas.Font.Color := $009F9F9F
    else (Control as TListBox).Canvas.Font.Color := clBlack;
    if odSelected in State then (Control as TListBox).Canvas.Font.Color := clWhite;

    (Control as TListBox).Canvas.TextOut(xpos, Rect.Top, TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).Name);
    Inc(xpos, (Control as TListBox).Canvas.TextWidth(TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).Name));

    RanksImageList.Draw((Control as TListBox).Canvas, xpos, Rect.Top, TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetRank);
    Inc(xpos, RanksImageList.Width + 1);

    if TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetAccess then
      PlayerStateImageList.Draw((Control as TListBox).Canvas, xpos, Rect.Top, 4);

  end;
end;

procedure TMainForm.TryToDisconnect;
begin;
  try
    Socket.CloseDelayed; // we must call CloseDelayed and not just Close, because this method is called from various methods and events like OnDataAvailable!
  except
    AddMainLog('Error while trying to disconnect!', Colors.Error);
  end;
end;

procedure TMainForm.TryToConnect;
var
  bufsize: Integer;
begin;
  if Status.ConnectionState <> Disconnected then TryToDisconnect;

  try
    Socket.Proto := 'tcp';
    Socket.Addr := Preferences.ServerIP;
//    if LowerCase(Socket.Addr) = 'localhost' then Socket.Addr := '127.0.0.1';
    Socket.Port := Preferences.ServerPort;
    Socket.LineMode := False;
    Socket.Connect;
    // send/receive buffers should be set after a call to Connect method (see http://users.pandora.be/sonal.nv/ics/faq/TWSocket.html#BroadcastvsMulticastAE):
    bufsize := 32768;
    WSocket_setsockopt(Socket.HSocket, SOL_SOCKET, SO_RCVBUF, @bufsize, SizeOf(bufsize));
    bufsize := 32768;
    WSocket_setsockopt(Socket.HSocket, SOL_SOCKET, SO_SNDBUF, @bufsize, SizeOf(bufsize));
  except
    AddMainLog('Error: cannot connect!', Colors.Error);
    if Preferences.ReconnectToBackup then TryToConnectToNextBackup;
  end;

end;

procedure TMainForm.TryToConnectToNextBackup;
var
  i: Integer;
  found: Boolean;

  procedure Reconnect;
  begin
    AddMainLog('Trying next host in the list ...', Colors.Info);
    PostMessage(MainForm.Handle, WM_FORCERECONNECT, 0, 0); // we must post a message, reconnecting from here won't work
  end;

begin
  found := False;
  for i := 0 to High(ServerList) do if ServerList[i].Address = Preferences.ServerIP then
  begin
    found := True;
    if i = High(ServerList) then
    begin
      // ok we've reached the end of the list, there is nothing more we can do, let's just cancel connecting
      if Length(ServerList) > 0 then Preferences.ServerIP := ServerList[0].Address; // set address to the first one in the list
      PreferencesForm.ServerAddressEdit.Text := Preferences.ServerIP;
      Exit;
    end;

    Preferences.ServerIP := ServerList[i+1].Address;
    PreferencesForm.ServerAddressEdit.Text := Preferences.ServerIP;
    Reconnect;
    Break;
  end;

  if not found then if Length(ServerList) > 0 then
  begin
    Preferences.ServerIP := ServerList[0].Address;
    PreferencesForm.ServerAddressEdit.Text := Preferences.ServerIP;
    Reconnect;
  end;

end;

procedure TMainForm.TryToSendData(s: string);
begin;
  if Status.ConnectionState <> Connected then
  begin
    AddMainLog('Error: Must be connected to send data!', Colors.Error);
    Exit;
  end;

  try
    Socket.SendLine(s);
    if Debug.Enabled and ((not Debug.FilterPingPong) or (s <> 'PING')) then AddMainLog('Client: "' + s + '"', Colors.Data);
    Status.TimeOfLastDataSent := GetTickCount;
  except
    AddMainLog('Error: cannot send data: "' + s + '"', Colors.Error);
  end;
end;

procedure TMainForm.TryToLogin(Username, Password: string);
var
  ip: string;
begin;
  // let's send the login command:
  ReceivedAgreement.Clear; // clear temporary agreement, as server might send us a new one now
  ip := GetLocalIP;
  if ip = '' then ip := '*';
  if Password = '' then Password := '*'; // probably local LAN mode. We have to send something as a password, so we just send an "*".
  TryToSendData('LOGIN ' + Username + ' ' + Misc.GetMD5Hash(Password) + ' ' + IntToStr(Status.MyCPU) + ' ' + ip + ' ' + PROGRAM_VERSION);
end;

procedure TMainForm.TryToRegister(Username, Password: string);
begin;
  if Password = '' then Password := '*'; // we should never send empty password
  TryToSendData('REGISTER ' + Username + ' ' + Misc.GetMD5Hash(Password));
end;

// "Edit" must be from TMyTabSheet container! (this method uses clients
procedure TMainForm.TryToAutoCompleteClientName(Edit: TEdit; Clients: TList);
var
  s: string;
  text: string;
  i: Integer;
  found: Boolean;
  pos, startpos: Integer;
begin
  if (Clients.Count = 0) or (Edit.SelLength <> 0) then
  begin
    Beep;
    Exit;
  end;

  if Edit.Text = '' then
  begin
    Edit.Text := TClient(Clients[0]).Name;
    Edit.SelStart := Length(TClient(Clients[0]).Name);
    Exit;
  end;

  found := False;
  pos := Edit.SelStart;

  text := Edit.Text;

  if Edit.SelStart = 0 then
  begin
    s := '';
    startpos := 1;
  end
  else
  begin
    if Edit.Text[Edit.SelStart] = ' ' then
    begin
      Beep;
      Exit;
    end;

    s := Copy(Edit.Text, 1, Edit.SelStart);
    startpos := Edit.SelStart+1 - System.Pos(' ', ReverseString(Copy(s, 1, Edit.SelStart)));
    if startpos > Edit.SelStart then
    begin
      s := Copy(Edit.Text, 1, Edit.SelStart);
      startpos := 1;
    end
    else
    begin
      s := Copy(Edit.Text, startpos+1, Edit.SelStart-startpos);
      Inc(startpos);
    end;
  end;

  s := UpperCase(s);

  for i := 0 to Clients.Count-1 do
    if UpperCase(Copy(TClient(Clients[i]).Name, 1, Length(s))) = s then
      if not (s = UpperCase(TClient(Clients[i]).Name)) then
      begin
        Delete(Text, startpos, Length(s));
        Insert(TClient(Clients[i]).Name, Text, startpos);
        pos := startpos + Length(TClient(Clients[i]).Name)-1;
        found := True;
        Break;
      end
      else
      begin // return next name:
        Delete(Text, startpos, Length(s));
        Insert(TClient(Clients[(i+1) mod Clients.Count]).Name, Text, startpos);
        pos := startpos + Length(TClient(Clients[(i+1) mod Clients.Count]).Name)-1;
        found := True;
        Break;
      end;

  if not found then
  begin
    Beep;
    Exit;
  end;

  Edit.Text := Text;
  Edit.SelStart := pos;
end;

procedure TMainForm.ConnectButtonClick(Sender: TObject);
begin
  if Preferences.Username = '' then
  begin
    PostMessage(MainForm.Handle, WM_OPENOPTIONS, 0, 0);
    Exit;
  end;

  if Status.ConnectionState = Connected then
  begin
    TryToDisconnect;
  end else if Status.ConnectionState = Connecting then
  begin
    TryToDisconnect;
  end else if Status.ConnectionState = Disconnected then
  begin
    TryToConnect;
  end;

end;

procedure TMainForm.OptionsSpeedButtonClick(Sender: TObject);
begin
  PreferencesForm.ShowModal;
end;

procedure TMainForm.SocketChangeState(Sender: TObject; OldState,
  NewState: TSocketState);
var
  i: Integer;
begin
{
  TSocketState       = (wsInvalidState,
                        wsOpened,     wsBound,
                        wsConnecting, wsSocksConnected, wsConnected,
                        wsAccepting,  wsListening,
                        wsClosed);
}

//  if Debug then AddLog('STATE CHANGED: ' + IntToStr(Ord(NewState)), clGreen);

  case NewState of

    wsConnecting:
    begin
      ConnectButton.Glyph := nil; // we have to tell speedbutton somehow that he is about to be changed
      ConnectionStateImageList.GetBitmap(1, ConnectButton.Glyph);
      Status.ConnectionState := Connecting;
      AddMainLog('Connecting to ' + Socket.Addr + ' ...', Colors.Info);
    end;

    wsConnected:
    begin
     // we ignore this state change here because we process it in OnSessionConnected event!
    end;

    wsClosed, wsInvalidState:
    begin
      if BattleForm.IsBattleActive and (BattleState.Battle <> nil) then BattleForm.ResetBattleScreen; // we have to check if BattleState.Battle <> nil, because this event is also triggered when form is closing and BattleForm has already been freed
      while Battles.Count > 0 do RemoveBattleByIndex(0); // remove all battles
      ConnectButton.Glyph := nil; // we have to tell speedbutton somehow that he is about to be changed
      ConnectionStateImageList.GetBitmap(0, ConnectButton.Glyph);
      if Status.ConnectionState = Connecting then
      begin
        AddMainLog('Cannot connect to server!', Colors.Info);
        if Preferences.ReconnectToBackup then TryToConnectToNextBackup;
      end
      else AddMainLog('Connection to server closed!', Colors.Info);
      if Status.LoggedIn then
        for i := PageControl1.PageCount-1 downto 1 do if (PageControl1.Pages[i] as TMyTabSheet).Caption[1] = '#' then // a channel
          if (PageControl1.Pages[i] as TMyTabSheet).Clients.Count <> 0 then // if 0 clients, then we are not in this channel anymore
            AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Disconnected', Colors.Info);
      ClearClientsLists;
      Status.ConnectionState := Disconnected;
      Status.Registering := False;
      Status.LoggedIn := False;
      PlayResSound('disconnect');
    end;

  end; // case
end;

procedure TMainForm.SocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode <> 0 then Exit;

  Status.ConnectionState := Connected;
  Status.LoggedIn := False;
  Status.Hashing := False;
  Status.MyRank := 0;
  Status.TimeOfLastDataReceived := GetTickCount;
  Status.TimeOfLastDataSent := GetTickCount;

  AddMainLog('Connection established to ' + Socket.Addr, Colors.Info);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Socket.Free;
  ClearAllClientsList;
  AllClients.Free;
  Utility.DeInitLib;
  ReplayList.Free;
  DeinitializeFlagBitmaps;
end;

procedure TMainForm.KeepAliveTimerTimer(Sender: TObject);
var
  client: TClient;
  i: Integer;
begin
  // lets purge the Pings list:
  i := 0;
  while i < Pings.Count do
  begin
    if GetTickCount - PPingInfo(Pings[i]).TimeSent > 15000 then
    begin
      AddMainLog('Ping dropped locally (timeout)', Colors.Error);
      Pings.Delete(i);
    end
    else Inc(i);
  end;

  if (Status.ConnectionState <> Connected) then Exit;

  if ((GetTickCount - Status.TimeOfLastDataSent > KEEP_ALIVE_INTERVAL) or
     (GetTickCount - Status.TimeOfLastDataReceived > KEEP_ALIVE_INTERVAL))
  then TryToSendData('PING');

  if (GetTickCount - Status.TimeOfLastDataReceived > ASSUME_TIMEOUT_INTERVAL) then
  begin
    AddMainLog('Timeout assumed. Disconnecting ...', Colors.Error);
    TryToDisconnect; // we assume timeout occured
  end;

  if Status.LoggedIn = False then Exit;

  // we will also use this timer to keep UDP source port open (so that router doesn't "forget" it). Used with "hole punching" traversal technique.
  if (Status.LoggedIn) and (BattleForm.IsBattleActive) and (not (BattleState.Status = Hosting))
     and (not Status.AmIInGame) and (NATTraversal.MyPrivateUDPSourcePort <> 0)
     and (GetTickCount - NATTraversal.TimeOfLastKeepAlive > 15000) then // some routers have timeout as low as 20 seconds!
  begin
    NATTraversal.TimeOfLastKeepAlive := GetTickCount;

    // what we send doesn't really matter (we could probably send an empty packet as well). Use TTL=2 since we don't care if packet reaches its destination.
    try
      SendUDPStrEx(Socket.Addr, Status.NATHelpServerPort, NATTraversal.MyPrivateUDPSourcePort, 2, 'HELLO');
    except
      // probably it couldn't bind the port (already used by some other application, spring perhaps?)
      AddMainLog('Error: Unable to send UDP packet. Ignoring ...', Colors.Error);
    end;
  end;

  // we will also use this timer to check if user is away:
  if (not Application.Active) and (GetTickCount - Status.AwayTime > AWAY_TIME) then
  begin // user is away
    client := GetClient(Status.Username);
    if client = nil then Exit; // should not happen!
    if not client.GetAwayStatus then // no need to set to away if already away
    begin
      client.SetAwayStatus(True);
      MainForm.TryToSendData('MYSTATUS ' + IntToStr(client.Status));
    end;
  end;

end;

procedure TMainForm.SocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  s: string;
  i: Integer;
  len: Integer;
begin
  Status.TimeOfLastDataReceived := GetTickCount;
  SetLength(s, 256);

  while True do
  begin
    len := (Sender as TWSocket).Receive(@s[1], 256);
    if len <= 0 then Exit;

    for i := 1 to len do
    begin
      if (s[i] = #13) or (s[i] = #10) then
      begin
        PostMessage(MainForm.Handle, WM_DATAHASARRIVED, Enqueue(ReceiveBuffer), 0);
        ReceiveBuffer := '';
      end
      else ReceiveBuffer := ReceiveBuffer + s[i];
    end;
  end;
end;

procedure TMainForm.PageControl1Change(Sender: TObject); // this event does not get always triggered when ActivePageIndex change but only when user clicks on new tab or presses CTRL+TAB / CTRL+SHIFT+TAB, but not when we add or remove tabs or change activepageindex manually. That is why we MUST trigger this event everytime we add/remove tab or change activepageindex or activepage!
begin
  UpdateClientsListBox;
//***  windows.beep(500, 300);

  (Sender as TPageControl).ActivePage.Highlighted := False;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  PageControl1.OnChange(PageControl1);

  if not ProgramInitialized then
  begin // do the main initialization
    Preferences := DEFAULT_PREFERENCES;
    ProgramInitialized := True;
    PreferencesForm.ReadPreferencesFromRegistry;
    PreferencesForm.UpdatePreferencesFrom(Preferences);
    NotificationsForm.LoadNotificationListFromFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\notify.dat');
    NotificationsForm.UpdateNotificationList;
    PerformForm.LoadCommandListFromFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\perform.dat');
    HighlightingForm.LoadHighlightsFromFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\highlights.dat');

    ClientsListBox.Font.Assign(CommonFont);
    BattleForm.ChatRichEdit.Font.Assign(CommonFont);
    BattleForm.InputEdit.Font.Assign(CommonFont);

    // set focus to TEdit control (we need to do this only once for 1 page only, and TEdit control will always receive focus with any new page):
    (PageControl1.ActivePage.Controls[0] as TEdit).SetFocus;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + LOBBY_FOLDER) then
    begin
      MessageDlg('Program has detected that "' + LOBBY_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + LOBBY_FOLDER) then
      begin
        MessageDlg('Unable to create directory. Program will now exit ...', mtError, [mbOK], 0);
        Application.Terminate;                                     
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + CACHE_FOLDER) then
    begin
      MessageDlg('Program has detected that "' + CACHE_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + CACHE_FOLDER) then
      begin
        MessageDlg('Unable to create directory. Program will now exit ...', mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + LOG_FOLDER) then
    begin
      MessageDlg('Program has detected that "' + LOG_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + LOG_FOLDER) then
      begin
        MessageDlg('Unable to create directory. Program will now exit ...', mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + VAR_FOLDER) then
    begin
      MessageDlg('Program has detected that "' + VAR_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + VAR_FOLDER) then
      begin
        MessageDlg('Unable to create directory. Program will now exit ...', mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if Preferences.SaveLogs then OpenAllLogs; // do this before all else, so that we don't miss any message

    if Preferences.ConnectOnStartup then PostMessage(MainForm.Handle, WM_CONNECT, 0, 0);

    OnlineMapsUnit.TReadCacheThrd.Create(False); // start reading online maps from cache
    ReplaysUnit.TReadReplaysThrd.Create(False); // start reading replays from disk
  end;
end;

{ opens a private chat with ClientName if it doesn't already exist. If it does, it just focuses it. }
procedure TMainForm.OpenPrivateChat(ClientName: string);
var
  i: Integer;
begin
  if ClientName = Status.Username then
  begin
    MessageDlg('Feel like talking to yourself? No way!', mtInformation, [mbOK], 0);
    Exit; // can't talk to yourself! (although possible! :-)
  end;

  i := GetTabWindowPageIndex(ClientName);
  if i = -1 then i := AddTabWindow(ClientName)
  else ChangeActivePageAndUpdate(PageControl1, i);

//  RemoveAllClientsFromTab(PageControl1.Pages[i] as TMyTabSheet);
  if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, ClientName) then ; // nevermind, just ignore it

  UpdateClientsListBox;

  if not MainForm.Focused then MainForm.Show;
end;

procedure TMainForm.ClientsListBoxDblClick(Sender: TObject);
var
  ClientName: string;
begin
  if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item
  if PageControl1.ActivePage.Caption = LOCAL_TAB then ClientName := TClient(AllClients[ClientsListBox.ItemIndex]).Name
  else ClientName := TClient((PageControl1.ActivePage as TMyTabSheet).Clients[ClientsListBox.ItemIndex]).Name;

  OpenPrivateChat(ClientName);
end;

procedure TMainForm.ClientsListBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then ClientsListBox.OnDblClick(ClientsListBox); // same effect as right-clicking on the user
end;

procedure TMainForm.BattleScreenSpeedButtonClick(Sender: TObject);
begin
  BattleForm.Show;
end;

procedure TMainForm.SocketLineLimitExceeded(Sender: TObject;
  RcvdLength: Integer; var ClearData: Boolean);
begin
  ClearData := False;
end;

procedure TMainForm.VDTBattlesDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  s: WideString;
  R: TRect;
  X: Integer;
  Battle: TBattle;
begin

  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    Battle := TBattle(Battles[Node.Index]);

    if (Node = FocusedNode) and Focused then
      Canvas.Font.Color := clHighlightText
    else
      Canvas.Font.Color := clWindowText;

    R := ContentRect;
    InflateRect(R, -TextMargin, 0);
    Dec(R.Right);
    Dec(R.Bottom);
    s := '';

    case Column of
      0: ; // join
      1: s := Battle.Description; // game's name (description, title)
      2: s := TClient(Battle.Clients[0]).Name; // host
      3:
      begin
        if Preferences.MarkUnknownMaps then
          if BattleForm.MapList.Items.IndexOf(Battle.Map) = -1 then
            Canvas.Font.Color := clRed;
        s := Copy(Battle.Map, 1, Length(Battle.Map)-4); // map
      end;
      4: // state
      begin
        X := ContentRect.Left + ((Sender as TVirtualDrawTree).Header.Columns[4].Width - BattleStatusImageList.Width - RanksImageList.Width - Margin) div 2;
        if Battle.RankLimit = 0 then
        begin
          BattleStatusImageList.Draw(Canvas, X, R.Top, Battle.GetState);
          if Battle.Locked then BattleStatusImageList.Draw(Canvas, X, R.Top, 12);
        end
        else
        begin
          BattleStatusImageList.Draw(Canvas, X, R.Top, Battle.GetState);
          if Battle.Locked then BattleStatusImageList.Draw(Canvas, X, R.Top, 12);
          Inc(X, BattleStatusImageList.Width);
          RanksImageList.Draw(Canvas, X, R.Top, Battle.RankLimit);
        end;
      end;
      5: // mod
      begin
        s := Battle.ModName;
      end;
      6: // players
      begin
        if Battle.BattleType = 0 then
        begin
          s := IntToStr(Battle.Clients.Count - Battle.SpectatorCount);
          if Battle.SpectatorCount > 0 then s := s + '+' + IntToStr(Battle.SpectatorCount);
          s := s + '/' + IntToStr(Battle.MaxPlayers) + ' (' + Battle.ClientsToString + ')';
        end
        else if Battle.BattleType = 1 then
        begin
          s := IntToStr(Battle.Clients.Count) + '/' + IntToStr(Battle.MaxPlayers) + ' (' + Battle.ClientsToString + ')';
        end;
      end;
    end; // case

    if Length(s) > 0 then
    begin
       with R do
         if (NodeWidth - 2 * Margin) > (Right - Left) then
           s := ShortenString(Canvas.Handle, s, Right - Left, False);
       DrawTextW(Canvas.Handle, PWideChar(S), Length(S), R, DT_TOP or DT_LEFT or DT_VCENTER or DT_SINGLELINE, False);
 //     Canvas.TextOut(ContentRect.Left, ContentRect.Top, s);
    end;
  end;

end;

procedure TMainForm.VDTBattlesInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctButton;
end;

procedure TMainForm.VDTBattlesGetNodeWidth(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  var NodeWidth: Integer);
var
  AMargin: Integer;
  s: string;

begin
  with Sender as TVirtualDrawTree do
    AMargin := TextMargin;

  case Column of
    0: NodeWidth := ButtonImageList.Width; // join
    1: NodeWidth := Canvas.TextWidth(TBattle(Battles[Node.Index]).Description) + 2 * AMargin; // description
    2: NodeWidth := Canvas.TextWidth(TClient(TBattle(Battles[Node.Index]).Clients[0]).Name) + 2 * AMargin; // host
    3: NodeWidth := Canvas.TextWidth(Copy(TBattle(Battles[Node.Index]).Map, 1, Length(TBattle(Battles[Node.Index]).Map)-4)) + 2 * AMargin; // map
    4: NodeWidth := BattleStatusImageList.Width; // state
    5: NodeWidth := Canvas.TextWidth(TBattle(Battles[Node.Index]).ModName) + 2 * AMargin; // mod
    6: // players
    begin
      s := IntToStr(TBattle(Battles[Node.Index]).Clients.Count - TBattle(Battles[Node.Index]).SpectatorCount);
      if TBattle(Battles[Node.Index]).SpectatorCount > 0 then s := s + '+' + IntToStr(TBattle(Battles[Node.Index]).SpectatorCount);
      s := s + '/' + IntToStr(TBattle(Battles[Node.Index]).MaxPlayers) + ' (' + TBattle(Battles[Node.Index]).ClientsToString + ')';
      NodeWidth := Canvas.TextWidth(s) + 2 * AMargin; // players
    end;
  end; // case
end;

procedure TMainForm.VDTBattlesChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  s, pass: string;
  res: Integer;
begin
  if BattleForm.IsBattleActive then
  begin
    MessageDlg('You must first disconnect from current battle!', mtInformation, [mbOK], 0);
    Exit;
  end;

  // check if we have the mod at all:
  if ModList.IndexOf(TBattle(Battles[Node.Index]).ModName) = -1 then
  begin
    if MessageDlg('Can''t join: you don''t have the right mod! Do you want to download it now?', mtInformation, [mbYes, mbNo], 0) = mrYes then
        ShellExecute(MainForm.Handle, nil, MODS_PAGE_LINK, '', '', SW_SHOW);
    Exit;    
  end;

  // is battle in progress?
  if TBattle(Battles[Node.Index]).IsBattleInProgress then
  begin
    MessageDlg('Can''t join: battle is in progress!', mtInformation, [mbOK], 0);
    Exit;
  end;

  // is battle locked?
  if TBattle(Battles[Node.Index]).Locked then
  begin
    MessageDlg('Can''t join: battle is locked!', mtInformation, [mbOK], 0);
    Exit;
  end;

  // is this battle replay and battle is full?
  if (TBattle(Battles[Node.Index]).BattleType = 1) and (TBattle(Battles[Node.Index]).IsBattleFull) then
  begin
    MessageDlg('Can''t join: battle is full!', mtInformation, [mbOK], 0);
    Exit;
  end;

  // is our rank to low to join this battle?
  if TBattle(Battles[Node.Index]).RankLimit > Status.MyRank then
    if MessageDlg('This battle requires a rank of <' + Ranks[TBattle(Battles[Node.Index]).RankLimit] + '>.' +#13+
                  'It is impolite to join a battle which requires a rank which you don''t have.' +#13+#13+
                  'Do you wish to attempt to join this battle anyway?', mtWarning, [mbNo, mbYes], 0) = mrNo then Exit;

  pass := '';
  if TBattle(Battles[Node.Index]).Password then
  begin
    if not InputQuery('Password', 'Password:', pass) then Exit;
  end;

  // acquire public UDP source port from the server if battle host uses "hole punching" technique:
  if TBattle(Battles[Node.Index]).NATType = 1 then  // "hole punching" method
  begin
    // let's acquire our public UDP source port from the server:
    InitWaitForm.ChangeCaption(MSG_GETHOSTPORT);
    InitWaitForm.TakeAction := 2; // get host port
    res := InitWaitForm.ShowModal;
    if res <> mrOK then
    begin
      MessageDlg('Unable to acquire UDP source port from server. Try choosing another NAT traversal technique!', mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

  s := 'JOINBATTLE ' + IntToStr(TBattle(Battles[Node.Index]).ID);
  if pass <> '' then s := s + ' ' + pass;
  TryToSendData(s);
end;

procedure TMainForm.VDTBattlesDblClick(Sender: TObject);
begin
  if VDTBattles.FocusedNode = nil then Exit;

  VDTBattles.OnChecked(VDTBattles, VDTBattles.FocusedNode);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Debug.Log then ((PageControl1.Pages[0] as TMyTabSheet).Controls[1] as TRichEdit).Lines.SaveToFile(ExtractFilePath(Application.ExeName) + LOG_FILENAME);
  if SaveToRegOnExit then PreferencesForm.WritePreferencesToRegistry;

  OnlineMapsForm.SaveOnlineMapsToCache(ExtractFilePath(Application.ExeName) + CACHE_FOLDER);
  NotificationsForm.SaveNotificationListToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\notify.dat');
  PerformForm.SaveCommandListToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\perform.dat');
  HighlightingForm.SaveHighlightsToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\highlights.dat');
end;

function TMainForm.LoadImagesDynamically: Boolean; // used for debugging purposes only
var
  i: Integer;

begin
  Result := False;

  if not FileExists('.\Graphics\battlestate1.bmp') then Exit;
  if not FileExists('.\Graphics\battlestate2.bmp') then Exit;
  if not FileExists('.\Graphics\battlestate3.bmp') then Exit;
  if not FileExists('.\Graphics\battlestate4.bmp') then Exit;
  if not FileExists('.\Graphics\battlestate5.bmp') then Exit;
  if not FileExists('.\Graphics\battlestate6.bmp') then Exit;
  if not FileExists('.\Graphics\connect1.bmp') then Exit;
  if not FileExists('.\Graphics\connect2.bmp') then Exit;
  if not FileExists('.\Graphics\connect3.bmp') then Exit;
  if not FileExists('.\Graphics\empty.bmp') then Exit;
  if not FileExists('.\Graphics\join1.bmp') then Exit;
  if not FileExists('.\Graphics\join2.bmp') then Exit;
  if not FileExists('.\Graphics\join3.bmp') then Exit;
  if not FileExists('.\Graphics\join4.bmp') then Exit;
  if not FileExists('.\Graphics\NoMap.bmp') then Exit;
  if not FileExists('.\Graphics\ready1.bmp') then Exit;
  if not FileExists('.\Graphics\ready2.bmp') then Exit;
  if not FileExists('.\Graphics\side_arm(small).bmp') then Exit;
  if not FileExists('.\Graphics\side_core(small).bmp') then Exit;
  if not FileExists('.\Graphics\state1.bmp') then Exit;
  if not FileExists('.\Graphics\state2.bmp') then Exit;
  if not FileExists('.\Graphics\state3.bmp') then Exit;
  if not FileExists('.\Graphics\sync1.bmp') then Exit;
  if not FileExists('.\Graphics\sync2.bmp') then Exit;
  if not FileExists('.\Graphics\sync3.bmp') then Exit;

  try

    // battle status:
    BattleStatusImageList.Clear;
    AddBitmapToImageList(BattleStatusImageList, '.\Graphics\battlestate1.bmp');
    AddBitmapToImageList(BattleStatusImageList, '.\Graphics\battlestate2.bmp');
    AddBitmapToImageList(BattleStatusImageList, '.\Graphics\battlestate3.bmp');
    AddBitmapToImageList(BattleStatusImageList, '.\Graphics\battlestate4.bmp');
    AddBitmapToImageList(BattleStatusImageList, '.\Graphics\battlestate5.bmp');
    AddBitmapToImageList(BattleStatusImageList, '.\Graphics\battlestate6.bmp');

    // connect button:
    ConnectionStateImageList.Clear;
    AddBitmapToImageList(ConnectionStateImageList, '.\Graphics\connect1.bmp');
    AddBitmapToImageList(ConnectionStateImageList, '.\Graphics\connect2.bmp');
    AddBitmapToImageList(ConnectionStateImageList, '.\Graphics\connect3.bmp');

    // join button:
    ButtonImageList.Clear;
    for i := 0 to 20 do AddBitmapToImageList(ButtonImageList, '.\Graphics\empty.bmp');
    AddBitmapToImageList(ButtonImageList, '.\Graphics\join1.bmp');
    AddBitmapToImageList(ButtonImageList, '.\Graphics\join2.bmp');
    AddBitmapToImageList(ButtonImageList, '.\Graphics\join3.bmp');
    AddBitmapToImageList(ButtonImageList, '.\Graphics\join4.bmp');

    // "no map" image:
    BattleForm.NoMapImage.Picture.Bitmap.LoadFromFile('.\Graphics\NoMap.bmp');

    // ready state images:
    ReadyStateImageList.Clear;
    AddBitmapToImageList(ReadyStateImageList, '.\Graphics\ready1.bmp');
    AddBitmapToImageList(ReadyStateImageList, '.\Graphics\ready2.bmp');

    // "side" images:
    SideImageList.Clear;
    AddBitmapToImageList(SideImageList, '.\Graphics\side_arm(small).bmp');
    AddBitmapToImageList(SideImageList, '.\Graphics\side_core(small).bmp');

    // player state images:
    PlayerStateImageList.Clear;
    AddBitmapToImageList(PlayerStateImageList, '.\Graphics\state1.bmp');
    AddBitmapToImageList(PlayerStateImageList, '.\Graphics\state2.bmp');
    AddBitmapToImageList(PlayerStateImageList, '.\Graphics\state3.bmp');

    // sync images:
    SyncImageList.Clear;
    // first 2, then 1 and finally 3!
    AddBitmapToImageList(SyncImageList, '.\Graphics\sync2.bmp');
    AddBitmapToImageList(SyncImageList, '.\Graphics\sync1.bmp');
    AddBitmapToImageList(SyncImageList, '.\Graphics\sync3.bmp');

    Result := True;
  finally
    //
  end;
end;

procedure TMainForm.HelpButtonClick(Sender: TObject);
begin
  HelpForm.ShowModal;
end;

procedure TMainForm.ApplicationEvents1Activate(Sender: TObject);
var
  client: TClient;
begin
  if (Status.ConnectionState = Connected) and (Status.LoggedIn) then
  begin
    client := GetClient(Status.Username);
    if client = nil then Exit; // shouldn't of happen

    if client.GetAwayStatus = False then Exit;
    client.SetAwayStatus(False);

    TryToSendData('MYSTATUS ' + IntToStr(client.Status));
  end;
end;

procedure TMainForm.ApplicationEvents1Deactivate(Sender: TObject);
begin
  Status.AwayTime := GetTickCount;
end;

procedure TMainForm.Clearwindow1Click(Sender: TObject);
begin
  (PageControl1.ActivePage.Controls[1] as TRichEdit).Lines.Clear;
end;

procedure TMainForm.ReplaysButtonClick(Sender: TObject);
begin
  ReplaysForm.ShowModal;
end;

procedure TMainForm.SortLabelClick(Sender: TObject);
var
  p: TPoint;
begin
  with SortLabel do
    p := ClientToScreen(Point(0, 0));

  SortPopupMenu.Popup(p.x, p.y);
end;

function TMainForm.CompareClients(Client1: TClient; Client2: TClient; SortStyle: Byte): Shortint;
begin
  case SortStyle of
    0: Result := 0;
    1: if AnsiCompareText(Client1.Name, Client2.Name) = 0 then Result := 0 else if AnsiCompareText(Client1.Name, Client2.Name) > 0 then Result := 1 else Result := -1;
    2: if Client1.GetInGameStatus and Client2.GetInGameStatus then Result := CompareClients(Client1, Client2, 1)
       else if Client1.GetInGameStatus and not Client2.GetInGameStatus then Result := 1
       else if not Client1.GetInGameStatus and Client2.GetInGameStatus then Result := -1
       else if Client1.InBattle and Client2.InBattle then Result := CompareClients(Client1, Client2, 1)
       else if Client1.InBattle and not Client2.InBattle then Result := 1
       else if not Client1.InBattle and Client2.InBattle then Result := -1
       else Result := CompareClients(Client1, Client2, 1);
    3: if Client1.GetRank = Client2.GetRank then Result := CompareClients(Client1, Client2, 1) else if Client1.GetRank > Client2.GetRank then Result := -1 else Result := 1;
    4: if CompareText(Client1.Country, Client2.Country) = 0 then Result := CompareClients(Client1, Client2, 1) else if CompareText(Client1.Country, Client2.Country) > 0 then Result := 1 else Result := -1;
  else
    Result := 0;
  end;
end;

function TMainForm.CompareBattles(Battle1, Battle2: TBattle; SortStyle: Byte): Shortint;
begin
  case SortStyle of
    0: Result := 0; // no sorting
    1: if Battle1.IsBattleInProgress and not Battle2.IsBattleInProgress then Result := 1 // sort by battle status
       else if not Battle1.IsBattleInProgress and Battle2.IsBattleInProgress then Result := -1
       else if Battle1.IsBattleInProgress and Battle2.isBattleInProgress then Result := 0
       else if Battle1.IsBattleFull and not Battle2.IsBattleFull then Result := 1
       else if not Battle1.IsBattleFull and Battle2.IsBattleFull then Result := -1
       else if Battle1.IsBattleFull and Battle2.IsBattleFull then Result := 0
       else Result := 0; // both battles are open/free
  else
    Result := 0;
  end;
end;

procedure TMainForm.SortClientsList(List: TList; SortStyle: Byte);
var
  i, j: Integer;
  tmp: TClient;
begin
  // simple bubble sort:
  for i := List.Count-1 downto 0 do
    for j := 0 to i-1 do
      if CompareClients(TClient(List[j]), TClient(List[j+1]), SortStyle) > 0 then
      begin
        tmp := List[j];
        List[j] := List[j+1];
        List[j+1] := tmp;
      end;
end;

{ will sort "Battles" list. It won't invalidate (repaint) VDTBattles tree! Call VDTBattles.Invalidate to do that manually. }
procedure TMainForm.SortBattlesList(SortStyle: Byte);
var
  i, j: Integer;
  tmp: TBattle;
  tmpNode: PVirtualNode;
begin
  // simple bubble sort:
  for i := Battles.Count-1 downto 0 do
    for j := 0 to i-1 do
      if CompareBattles(TBattle(Battles[j]), TBattle(Battles[j+1]), SortStyle) > 0 then
      begin
        // swap:
        tmp := Battles[j];
        Battles[j] := Battles[j+1];
        Battles[j+1] := tmp;
        // swap nodes to previous position:
        tmpNode := TBattle(Battles[j]).Node;
        TBattle(Battles[j]).Node := TBattle(Battles[j+1]).Node;
        TBattle(Battles[j+1]).Node := tmpNode;
      end;
end;

{ updates position of battle with Index in List. It doesn't repaint VDTBattles, you should do that manually. }
procedure TMainForm.SortBattleInList(Index: Integer; SortStyle: Byte);
var
  i: Integer;
  tmp: TBattle;
  tmpNode: PVirtualNode;
begin
  if (Index < 0) or (Index > Battles.Count-1) then Exit; // this should not happen!

  // sort down:
  for i := Index+1 to Battles.Count-1 do
    if CompareBattles(TBattle(Battles[Index]), TBattle(Battles[i]), SortStyle) > 0 then
    begin
      // swap:
      tmp := Battles[i];
      Battles[i] := Battles[Index];
      Battles[Index] := tmp;
      // swap nodes to previous position:
      tmpNode := TBattle(Battles[i]).Node;
      TBattle(Battles[i]).Node := TBattle(Battles[Index]).Node;
      TBattle(Battles[Index]).Node := tmpNode;

      Inc(Index);
    end
    else Break;

  // sort up:
  for i := Index-1 downto 0 do
    if CompareBattles(TBattle(Battles[Index]), TBattle(Battles[i]), SortStyle) < 0 then
    begin
      // swap:
      tmp := Battles[i];
      Battles[i] := Battles[Index];
      Battles[Index] := tmp;
      // swap nodes to previous position:
      tmpNode := TBattle(Battles[i]).Node;
      TBattle(Battles[i]).Node := TBattle(Battles[Index]).Node;
      TBattle(Battles[Index]).Node := tmpNode;

      Dec(Index);
    end
    else Break;
end;

procedure TMainForm.SortMenuItemClick(Sender: TObject);
var
  i: Integer;
begin
  (Sender as TMenuItem).Checked := True;
  Preferences.SortStyle := (Sender as TMenuItem).Tag;
  for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
    SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);
  UpdateClientsListBox;
end;

procedure TMainForm.BattleSortMenuItemClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  Preferences.BattleSortStyle := (Sender as TMenuItem).Tag;
  SortBattlesList(Preferences.BattleSortStyle);
  VDTBattles.Invalidate;
end;

procedure TMainForm.VDTBattlesGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
begin
  R := Rect(0, 0, 0, 0);

  with (Sender as TVirtualDrawTree) do
    if Header.Columns[Column].Text = 'Players' then
      R := Rect(0, 0, Canvas.TextWidth(TBattle(Battles[Node.Index]).ClientsToString) + 10, 18)
    else if Header.Columns[Column].Text = 'Mod' then
      R := Rect(0, 0, Canvas.TextWidth(TBattle(Battles[Node.Index]).ModName) + 10, 18)
    else if Header.Columns[Column].Text = 'Map' then
      R := Rect(0, 0, Canvas.TextWidth(TBattle(Battles[Node.Index]).Map) + 10, 18)
    else if Header.Columns[Column].Text = 'Host' then
      R := Rect(0, 0, Canvas.TextWidth(TClient(TBattle(Battles[Node.Index]).Clients[0]).Name) + 10, 18)
    else if Header.Columns[Column].Text = 'Description' then
      R := Rect(0, 0, Canvas.TextWidth(TBattle(Battles[Node.Index]).Description) + 10, 18)
end;

procedure TMainForm.VDTBattlesDrawHint(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
begin
  with Sender as TVirtualDrawTree, HintCanvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := $00ffdddd; { 0 b g r }
    Brush.Style := bsSolid;
    Rectangle(ClipRect);
    Brush.Style := bsClear;

    if Header.Columns[Column].Text = 'Players' then
      TextOut(5, 2, TBattle(Battles[Node.Index]).ClientsToString)
    else if Header.Columns[Column].Text = 'Mod' then
      TextOut(5, 2, TBattle(Battles[Node.Index]).ModName)
    else if Header.Columns[Column].Text = 'Map' then
      TextOut(5, 2, TBattle(Battles[Node.Index]).Map)
    else if Header.Columns[Column].Text = 'Host' then
      TextOut(5, 2, TClient(TBattle(Battles[Node.Index]).Clients[0]).Name)
    else if Header.Columns[Column].Text = 'Description' then
      TextOut(5, 2, TBattle(Battles[Node.Index]).Description);

  end;
end;

procedure TMainForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin

   If Msg.message = Messages.WM_MOUSEWHEEL then
   begin
     if OnlineMapsForm.Active then // when in SelectMapForm scrollbars should scroll through available maps
     begin
       if Msg.wParam > 0 then OnlineMapsForm.ScrollBox1.VertScrollBar.Position := OnlineMapsForm.ScrollBox1.VertScrollBar.Position - OnlineMapsForm.ScrollBox1.VertScrollBar.Increment // Scroll Up
         else OnlineMapsForm.ScrollBox1.VertScrollBar.Position := OnlineMapsForm.ScrollBox1.VertScrollBar.Position + OnlineMapsForm.ScrollBox1.VertScrollBar.Increment; // Scroll Down
     end;
     
//***     Handled := True; // we don't want other components to receive mouse wheel messages
   end;

end;

function TMainForm.GetCountryName(CountryCode: string): string; // this is a slow function. Use it only when necessary.
var
  i: Integer;
begin
  for i := 0 to High(CountryNames) do if Copy(CountryNames[i], Length(CountryNames[i])-1, 2) = CountryCode then
  begin
    Result := Copy(CountryNames[i], 1, Length(CountryNames[i])-2);
    Exit;
  end;
  Result := 'Unknown country'; // should not happen
end;

procedure TMainForm.ClientsListBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  tmp: Integer;
begin

  tmp := (Sender as TlistBox).ItemAtPos(Point(X, Y), True);
  if tmp = -1 then
  begin
    Hint := '';
    Exit;
  end;

  try
    (Sender as TlistBox).Hint := TClient((PageControl1.ActivePage as TMyTabSheet).Clients[tmp]).Name + ', ' + GetCountryName(TClient((PageControl1.ActivePage as TMyTabSheet).Clients[tmp]).Country);
  except
  end;
end;

procedure TMainForm.RichEditPopupMenuPopup(Sender: TObject);
begin
  (Sender as TPopupMenu).Items[1].Checked := (PageControl1.ActivePage as TMyTabSheet).AutoScroll;
end;

procedure TMainForm.AutoScroll1Click(Sender: TObject);
begin
  (PageControl1.ActivePage as TMyTabSheet).AutoScroll := not (PageControl1.ActivePage as TMyTabSheet).AutoScroll;
end;

procedure TMainForm.AddNotification(HeaderText, MessageText: string; DisplayTime: Integer);
var
  DA: TJvDesktopAlert;
begin
  DA := TJvDesktopAlert.Create(Self);
  DA.HeaderText := HeaderText;
  DA.MessageText := MessageText;
  DA.Options := [daoCanClose];
  DA.Location.Position := dapBottomRight;
  DA.StyleHandler.DisplayDuration := DisplayTime;
  DA.Location.Width := 250;
  DA.Location.Height := 70;
  DA.AlertStyle := asFade;
  DA.Execute;

  if Preferences.UseSoundNotifications then PlayResSound('notify');
end;

end.
