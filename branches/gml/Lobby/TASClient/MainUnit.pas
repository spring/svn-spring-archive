{
  Project started on: 13/06/2005
  See TASClient.dpr for details.

  For protocol description + notes see "trunk/Documentation/Lobby/LobbyProtocol.txt" (in SVN repository)

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

  * http://www.experts-exchange.com/Programming/Programming_Languages/Delphi/Q_21351618.html
    (how to do OnMouseEnter/OnMouseLeave events)

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
  - ImageEx (included with these sources. See ImageEx.pas for more details and links)
  - JEDI Visual Component Library (http://homepages.borland.com/jedi/jvcl/)
  - MD5 algorithm implementation from http://www.efg2.com/Lab/Library/UseNet/1999/0909.txt (included with these sources)
  - SZCodeBaseX 1.3.2 (http://www.szutils.net/Delphi/Delphi.php), included with these sources
  - DSiWin32 - collection of Win32 wrappers and helpful functions (http://17slon.com/gp/gp/files/dsiwin32.htm)
  - Toolbar2000 2.1.8 (http://www.jrsoftware.org/tb2k.php)
  - Patch for TB2K 2.1.8 (http://club.telepolis.com/silverpointdev/sptbxlib/tbxpatch218.zip)
  - TBX 2.1 Beta 1 (http://www.g32.org/tbx/index.html)
  - TntWare Delphi Unicode Controls 2.2.3 or above (http://www.tntware.com/delphicontrols/unicode/)
  - SpTBXLib 1.8 (http://club.telepolis.com/silverpointdev/sptbxlib/index.htm)
  - Additional TBX themes (http://www.rmklever.com/zipfiles/TBXThemes21.zip)
  + See "! readme !.txt" on further instructions on how to install some of these components

  ------ MY NOTES ------
  * Don't forget to manually set Scaled property of each new form to FALSE!
  * Don't forget to manually set Caption, UseTBXBackground, FixedSize and system menu properties when adding TSpTBXTitlebar!
  * When creating a patcher, use this registry location for default dir:
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SpringClient.exe
  * Hints are not done yet, currently there could be a problem if hints would use some other font than VDTBattles
  .Canvas.Font,
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
  * If SpTBX/TNT controls were ever to be removed, one should accordingly modify:
    + NotificationsUnit: replace WideString-s with AnsiString-s
    + PreferencesForm: remove "Skins" tab and skin detection
  * For checksums I use signed integers, although for example unitsync.dll returns hash codes / checksums
    as unsigned ints, the reason I use signed integers is due to the fact Java doesn't have
    unsigned numerical data types (lobby server is written in Java). To store unsigned 32-bit ints
    in java you have to use signed 64-bit integers, which is a waste of space most of the time.
  * When using TBX/SpTBX components, remember that they use WideStrings instead of AnsiStrings,
    casting those strings to PChar will not work properly - that was the bug with watching replays
    not working since I casted WideString to PChar and gave that to ShellExecute!
  * MapListForm's map items use doublebuffered TMapItemPanel-s. Not sure how does that impact performance (probably takes some memory etc.)!

  ------ CHANGELOG ------

  [moved to a separate file: trunk\Documentation\lobbychangelog.txt (SVN repository)]

}

{ see "$DEFINE DONTUSETTL2" in Misc.pas! }
{ use TTL=2 when sending udp packets to keep ports open? Currently disabled because some players may be
  behind several layers of NAT and packets with TTL=2 may never reach those routers. }

unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus, Grids, ValEdit,
  VirtualTrees, ImgList, WSocket, StringParser, MMSystem, Utility, AppEvnts, Math,
  HttpProt, GraphicEx, Registry, JvComponent, JvBaseDlg, JvDesktopAlert,
  JvDesktopAlertForm, DateUtils, Winsock, TBXToolPals, SpTBXItem, TB2Item,
  TBX, SpTBXControls, TBXDkPanels, SpTBXFormPopupMenu,IniFiles,StrUtils,
  TntStdCtrls, SpTBXEditors, Mask, JvExMask, JvSpin,TntComCtrls,JclUnicode;

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

  LobbyMailAddress = 'springlobby@clan-sy.com';

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
    ClientAway: TColor; // text color of an away client
    MapModUnavailable: TColor; // text color of a battle with a mod or map you don't have
    BotText: TColor; // bot text color in battle client list
    MyText: TColor; // my chat text color
    AdminText: TColor;
  end;

  TTeamColors = array[0..9] of TColor;

const

  { TColor format: $00BBGGRR }
  DefaultTeamColors: TTeamColors = (
  $00FF5A5A, // blue
  $000000C8, // red
  $00FFFFFF, // white
  $00209B26, // green
  $007D1F07, // blue
  $00B40A96, // purple
  $0000FFFF, // yellow
  $00323232, // black
  $00DCC898, // ltblue
  $0083ABAB  // tan
  );

const
  VERSION_NUMBER = '0.37'; // Must be float value! (with a period as a decimal seperator)
  BETA_NUMBER = 273;
  CHECK_BETA_LOBBY_URL = 'http://tasclient.no-ip.org/TASClient.txt';
  PROGRAM_VERSION = 'TASClient ' + VERSION_NUMBER + ' beta';
  KEEP_ALIVE_INTERVAL = 10000; // in milliseconds. Tells us what should be the maximum "silence" time before we send a ping to the server.
  ASSUME_TIMEOUT_INTERVAL = 30000; // in milliseconds. Must be greater than KEEP_ALIVE_INTERVAL! If server hasn't send any data to us within this interval, then we assume timeout occured. It's us who must make sure we get constant replies from server by pinging it.
  LOCAL_TAB = '$Local'; // caption of main (command) tab window. Must be special so that is different from channel names or user names, that is why there is a "$" in front of it.
  SUPPORTED_SERVER_VERSIONS: array[0..0] of string = ('0.35'); // client can connect ONLY to server with one of these version numbers
  EOL = #13#10;
  MAX_MSG_ID = 65535; // when sending commands to the server they may be assigned an unique ID, MAX_MSG_ID is the maximum value of this ID (note that you may assign IDs any way you want, random, consecutive, or even not at all). Currently this program assigns consecutive IDs, so once it reaches this value, the next will be 0, then 1 etc.

  LOG_FILENAME = 'log.txt';
  MODS_PAGE_LINK = 'http://spring.jobjol.nl/files.php?subcategory_id=5';
  MAPS_PAGE_LINK = 'http://spring.jobjol.nl/files.php?subcategory_id=2';
  WIKI_PAGE_LINK = 'http://taspring.clan-sy.com/wiki/Main_Page';
  LADDER_PREFIX_URL = 'http://blendax.informatik.uni-bremen.de/jan/spring/ladder/lobby/'; //'http://springladder.no-ip.org/lobby/';
  LADDER_BATTLE_PASSWORD = 'ladderlock2';
  AWAY_TIME = 300000; // in milliseconds. After this period of time (of inactivity), client will set its state to "away"
  IDL_DEFAULT_MSG = 'The user has been idling for $t minutes.';
  AWAY_DEFAULT_MSG = 'I am currently away from the computer.';
  LOBBY_FOLDER = 'lobby'; // main folder for lobby, in which all other folders are put (logs, cache, var, ...)
  CACHE_FOLDER = LOBBY_FOLDER + '\' + 'cache';
  ONLINE_CACHE_FOLDER = CACHE_FOLDER + '\' + 'online'; // we store images of minimaps (downloaded from content site) in it (see OnlineMapsForm)
  MAPS_CACHE_FOLDER = CACHE_FOLDER + '\' + 'maps'; // we store info of local maps there plus minimaps
  MODS_CACHE_FOLDER = CACHE_FOLDER + '\' + 'mods'; // we store info of local mods there like default mod options
  LOG_FOLDER = LOBBY_FOLDER + '\' + 'logs'; // this is where we store chat logs
  VAR_FOLDER = LOBBY_FOLDER + '\' + 'var';
  FIRST_UDP_SOURCEPORT = 8300; // udp source port (used with "fixed source ports" NAT traversal technique) of the second (first one is host) client in clients list of the battle. Third client uses this+1 port, fourth one this+2, etc.
  AIDLL_FOLDER = 'AI/Bot-libs'; // searching for *.dll in this folder will return all bots that you can use to play with
  MAP_DOWNLOADER_ENABLED = False; // integrated map downloader is currently disabled as FileUniverse.com is no longer hosting spring content

  MAX_PLAYERS = 32; // max. players supported by Spring in a game
  MAX_TEAMS = 16; // max. teams supported by Spring in a game (MAX_ALLIES would be same as MAX_TEAMS, so no need for it)
  MAX_POPUP = 8; // max popup notification displaying at the same time

  // custom messages:
  WM_DATAHASARRIVED = WM_USER + 0; // used when processing data received through socket
  WM_OPENOPTIONS = WM_USER + 1; // used to open OPTIONS dialog
  WM_DOREGISTER = WM_USER + 2 ; // sent when user clicks on REGISTER button
  WM_CLOSETAB = WM_USER + 3; // used when user presses CTRL+W to close tab
  WM_STARTGAME = WM_USER + 4; // used to launch spring.exe
  WM_CONNECT = WM_USER + 5; // used to simulate ConnectButton.OnClick event
  WM_STARTDOWNLOAD = WM_USER + 6; // used together with HttpGetForm. Before dispatching this message, you have to fill out all fields of DownloadFile record
  WM_STARTDOWNLOAD2 = WM_USER + 7; // used internally by HttpGetForm
  WM_FORCERECONNECT = WM_USER + 8; // used to force reconnect to server (when REDIRECT command is received, for example)
  WM_UDP_PORT_ACQUIRED = WM_USER + 9; // used when received UDPSOURCEPORT command from the server
  WM_CONNECT_TO_NEXT_HOST = WM_USER + 10; // used with "Connect to backup host if primary fails" option
  WM_LOAD_NEXT_MINIMAP = WM_USER + 11; // used with loding missing minimaps from MapListForm (this message is sent to InitWaitForm)
  WM_AFTERCREATE = WM_USER + 12; // we send this signal once we've finished creating all forms. We will do some post-initialization here

  QUEUE_LENGTH = 4096;

  Ranks: array[0..6] of string = ('Newbie', 'Beginner', 'Average', 'Above average', 'Experienced', 'Highly experienced', 'Veteran');

type

  TPlayerStatistics =
  record
    mousePixels : integer;
    mouseClicks : integer;
    keyPresses : integer;
    numCommands : integer;
    unitCommands : integer; // total amount of units affected by commands   (divide by numCommands for average units/command)
  end;

  TDemoHeader =
  record
    magic: array[0..15] of Char;
    version: integer;
    headerSize: integer;
    versionString: array[0..15] of Char;
    gameID: array[0..15] of Byte;
    unixTime: UInt64;
    scriptSize: integer;
    demoStreamSize: integer;
    gameTime: integer;
    wallclockTime: integer;
    maxPlayerNum: integer;
    numPlayers: integer;
    playerStatSize: integer;
    playerStatElemSize: integer;
    numTeams: integer;
    teamStatSize: integer;
    teamStatElemSize: integer;
    teamStatPeriod: integer;
    winningAllyTeam: integer;
  end;

  TFilterText =
  record
    filterType : (HostName, MapName, ModName, Description, DisabledUnits, SpringVersion, FileName, Players);
    contains: boolean;
    node : PVirtualNode;
    enabled: boolean;
    value: string;
  end;

  TFilterNumber =
  record
    filterType : (Sup, Inf, Equal);
    value: Integer;
    enabled: boolean;
  end;

  TMyTabSheet = class(TTabSheet)
  public
    Clients: TList; // do not free any of the clients in this list! See AllClients list's comments
    History: TWideStringList; // here we store everything user has typed in. User can access it by pressing UP/DOWN keys
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
    RecentNames: string; // use for modos with FINDIP
    Status: Integer; // client's status (normal, in game)
    BattleStatus: Integer; // only used for clients participating in the same battle as the player
    TeamColor: Integer; // $00BBGGRR where B = blue, G = green, R = red
    InBattle: Boolean; // is this client participating in a battle?
    Country: string; // two-character country code based on ISO 3166
    CPU: Integer; // CPU's speed in MHz (or equivalent if AMD). Value of 0 means that client couldn't figure out its CPU speed.
    StatusRefreshed : Boolean;
    SprinkMarkScore : integer; // -1 downloading, -2 n/a, 0> score
    SpringMarkData : string; // system info : cpu@freq
    CurrentLadderId : integer; // ladder id of the current ladder information
    CurrentLadderRank : integer; // since its the rank of the client in the current ladder, it must be set to -1 each time he join a battle
    CurrentLadderRating : integer; // same as the rank
    CupList: TList;
    CupLadderList: TStringList;
    IP: string; // this field is assigned by the CLIENTIPPORT command only when needed, generally it is set to '' (empty string)
    PublicPort: Integer; // client's public UDP source port. Used with NAT traversing (e.g. "hole punching")
    AwayMessageSent: boolean; // to not resend the away message each time the player send you a message

    constructor Create(Name: string; Status: Integer; Country: string; CPU: Integer);

    function GetChatTextColor: TColor;

    // following functions extract various values from BattleStatus:
    function GetReadyStatus: Boolean;
    function GetTeamNo: Integer;
    function GetAllyNo: Integer;
    function GetMode: Integer; // 0 - spectator, 1 - normal player. Also see server protocol description!
    function GetHandicap: Integer;
    function GetSync: Integer;
    function GetSide: Integer;

    function isComSharing: Boolean;
    function GetGroup: Integer;
    function GetBattleId: Integer;

    // following methods assign various values to BattleStatus:
    procedure SetSide(Side: Integer);
    procedure SetReadyStatus(Ready: Boolean);
    procedure SetTeamNo(Team: Integer);
    procedure SetAllyNo(Ally: Integer);
    procedure SetMode(Mode: Integer);
    procedure SetRank(Rank: Integer);
    procedure SetHandicap(Handicap: Integer);
    procedure SetSync(Sync: Integer);

    function GetStateImageIndex: Integer; // returns index of image in PlayerStateImageList

    // following methods assign/extract information to/from Status:
    function GetInGameStatus: Boolean;
    function GetAwayStatus: Boolean;
    function GetRank: Integer;
    function GetAccess: Boolean; // if True, then client is a server moderator
    function GetBotMode: Boolean;
    procedure SetInGameStatus(InGame: Boolean);
    procedure SetAwayStatus(Away: Boolean);

  end;

  TDialogThread = class(TThread)
  protected
    MsgT : string;
    DlgTypeT: TMsgDlgType;
    ButtonsT : TMsgDlgButtons;
    HelpCtxT: Longint;
    MessageDlgReturn : integer;
    ACaptionT, APromptT, ADefaultT: string;
    InputBoxReturn : string;
    function MessageDlgThread(const Msg: string; DlgType: TMsgDlgType;Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
    function InputBoxThread(const ACaption, APrompt, ADefault: string): string;
    procedure ShowLastMessage;
    procedure ShowInputBox;
  end;

  TKeepAliveThread = class(TDialogThread)
  protected
    procedure Execute; override;
  end;

  TLadderTopPlayersThread = class(TThread)
  private
    procedure Refresh;
    procedure OnTerminateProcedure(Sender : TObject);

  protected
    procedure Execute; override;

  public
    constructor Create(Suspended : Boolean);
  end;

  TCheckNewBetaLobbyThread = class(TDialogThread)
  private
    confirmation: boolean;

  protected
    procedure Execute; override;

  public
    constructor Create(Suspended : Boolean;hasLastVersionConfirmation: boolean);
  end;

  TLadder = class
  public
    id: integer;
    Name: string;
    ModName: string;
    MinPlayersPerAllyTeam: integer;
    MaxPlayersPerAllyTeam: integer;
    StartPos: byte; // -1 = any
    GameMode: byte; // -1 = any
    DGun: byte; // -1 = any
    Ghost: byte; // -1 = any
    Diminish: byte; // -1 = any
    MetalMin: integer;  // -1 = any
    MetalMax: integer;
    EnergyMin: integer; // -1 = any
    EnergyMax: integer;
    UnitsMin: integer; // -1 = any
    UnitsMax: integer;
    Restricted : TStrings;
    Rules: string;
    Maps : TStrings;
    constructor Create(id: integer; Name: string);
  end;

  TBot = class
  public
    Name: string;
    OwnerName: string;
    AIDll: string;
    BattleStatus: Integer;
    TeamColor: Integer; // $00BBGGRR where B = blue, G = green, R = red

    procedure Assign(Bot: TBot); // copies all properties of Bot to this Bot
    constructor Create(Name: string; OwnerName: string; AIDll: string);

    // following functions extract various values from BattleStatus:
    function GetTeamNo: Integer;
    function GetAllyNo: Integer;
    function GetHandicap: Integer;
    function GetSide: Integer;

    function isComSharing: Boolean;

    // following methods assign various values to BattleStatus:
    procedure SetSide(Side: Integer);
    procedure SetTeamNo(Team: Integer);
    procedure SetAllyNo(Ally: Integer);
    procedure SetHandicap(Handicap: Integer);
  end;

  TBattle = class
  protected
    CurrentHighLightGroup: integer;
  public
    ID: Integer; // each battle is identified by its unique ID (server provides us with ID for each battle)
    BattleType: Integer; // 0 = normal battle, 1 = battle replay
    NATType: Integer; // 0 = none, 1 = hole punching, 2 = fixed ports (denotes NAT traversal technique used by the host)
    Node: PVirtualNode; // link (pointer) to node in TVirtualDrawTree
    Clients: TList; // clients that are in this battle (similar to clients in a channel). First client in this list is battle's founder! Never free any of the clients in this list! See AllClients list's comments!
    Bots: TList; // bots in this battle.
    RankLimit: Shortint; // if 0, no rank limit is set. If 1 or higher, only players with this rank (or higher) can join the battle (Note: rank index 1 means seconds rank, not the first one, since you can't limit game to players of the first rank because that means game is open to all players and you don't have to limit it in that case)
    Visible : boolean;

    Description: WideString;
    Map: String; // .smf file name, not archive file name!
    MapHash: Integer; // checksum of the map (acquired using unitsync.dll, for example)
    SpectatorCount: Integer; // how many spectators are there in this battle
    Password: Boolean; // is this battle password-protected?
    IP: string;
    Port: Integer;
    MaxPlayers: Integer;
    ModName: string; // name of the mod used in this battle
    HashCode: Integer; // mod's (and its dependecies combined) checksum
    Locked: Boolean; // if true, battle is locked, meaning noone can join it anymore (until lock is released by host of the battle)

    constructor Create;
    destructor Destroy; override;
    function AreAllClientsReady: Boolean;
    function AreAllClientsSynced: Boolean;
    function AreAllBotsSet: Boolean;
    function IsBattleFull: Boolean;
    function IsBattleInProgress: Boolean;
    function IsLadderBattle: Boolean;
    function GetLadderId: integer;
    function GetState: Integer; // use it to get index of image from BattleStatusImageList
    function ClientsToString: string; // returns user names in a string, separated by spaces
    function GetClient(Name: string): TClient;
    function GetBot(Name: string): TBot;
    procedure RemoveAllBots;
    function GetHighlightColor: TColor;
    procedure NextHighlight;
  end;

  TScript = class // note: any TScript's method will raise an exception if something goes wrong
  protected
    FScript: string;
    CompleteKeyList: TStrings;
    KeyValueList: TStrings;
    FUpperCaseScript: string;
    Corrupted: boolean;
    function GetScript:String;
    procedure SetScript(Script: string);
    procedure WriteScriptKeys(f: TStrings; completeKey: String;writtenKeys: TStrings; headWrite: Boolean);
  public
    constructor Create(Script: string);
    destructor Destroy; override;
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
    function ReadDisabledUnits: TStringList;
    procedure ParseScript;
    function GetSubKeys(completeKey: string):TStrings;
    function GetBruteScript:String; // DEBUG METHOD
    function ReadKeyValue(completeKey: string):String;
    procedure ChangeHostIP(NewIP: string);
    procedure ChangeHostPort(NewPort: string);
    procedure ChangeMyPlayerNum(NewNum: Integer);
    procedure ChangeNumPlayers(NewNum: Integer);
    procedure AddOrChangeKeyValue(completeKey: String; value: String);
    procedure RemoveKey(completeKey: String);
    procedure TryToRemoveUDPSourcePort;
    function isCorrupted: boolean;

    property Script: string read GetScript write SetScript;
  end;

  TReplay = class
  public
    Grade: Byte; // 0..10 (where 0 is unrated/unknown)
    Version: Byte; // 0: old demo version, 1: new demo version
    SpringVersion: String;
    FileName: string;
    FullFileName: string;
    Date: TDateTime;
    PlayerList: TList;
    demoHeader: TDemoHeader;
    Script: TScript;
    Node: PVirtualNode;

    constructor Create;
    function GetSpectatorCount: integer;
    function GetLength: integer;
    function GetTeamCount: integer;
    destructor Destroy; override;
  end;

  TReplayPlayer = class
  public
    UserName: string;
    Rank: byte;
    CountryCode: string;
    Id: byte;
    Team: byte;
    Color: TColor;
    Spectator: boolean;
    Node: PVirtualNode;
    Stats : TPlayerStatistics;
  end;


  TClientGroup = class
  public
    Name: string;
    Color: integer;
    Clients: TStrings;
    AutoKick : boolean;
    AutoSpec : boolean;
    NotifyOnHost : boolean;
    NotifyOnJoin : boolean;
    NotifyOnBattleEnd : boolean;
    NotifyOnConnect : boolean;
    HighlightBattles : boolean;

    constructor Create(Name: string; Color: Integer);
    destructor Destroy;
  end;

  TMainForm = class(TForm)
    SearchFormPopupMenu: TSpTBXFormPopupMenu;
    BattleListPopupMenu: TSpTBXPopupMenu;
    mnuSelectBattle: TSpTBXItem;
    SpTBXItem1: TSpTBXItem;
    mnuManageGroups: TSpTBXItem;
    mnuRemoveFromGroup: TSpTBXItem;
    SpTBXSeparatorItem3: TSpTBXSeparatorItem;
    mnuAddToGroup: TSpTBXSubmenuItem;
    mnuNewGroup: TSpTBXItem;
    SpTBXSeparatorItem4: TSpTBXSeparatorItem;
    HelpPopupMenu: TSpTBXPopupMenu;
    mnuHelp: TSpTBXItem;
    SpTBXSeparatorItem5: TSpTBXSeparatorItem;
    mnuSpringHomePage: TSpTBXItem;
    mnuMessageboard: TSpTBXItem;
    mnuBugTracker: TSpTBXItem;
    mnuUnknownFiles: TSpTBXItem;
    mnuSpringReplays: TSpTBXItem;
    mnuSpringLadder: TSpTBXItem;
    HttpCli1: THttpCli;
    SpTBXSeparatorItem7: TSpTBXSeparatorItem;
    SubMenuWiki: TSpTBXSubmenuItem;
    mnuFAQ: TSpTBXItem;
    mnuPlayingSpring: TSpTBXItem;
    mnuGlossary: TSpTBXItem;
    mnuStrategyAndTactics: TSpTBXItem;
    HostBattlePopupMenu: TSpTBXPopupMenu;
    menuHostBattle: TSpTBXItem;
    mnuHostLadderBattle: TSpTBXItem;
    mnuHostReplay: TSpTBXItem;
    SpTBXSeparatorItem8: TSpTBXSeparatorItem;
    mnuBattleScreen: TSpTBXItem;
    SpTBXItem6: TSpTBXItem;
    ConnectionPopupMenu: TSpTBXPopupMenu;
    mnuAway: TSpTBXItem;
    SpTBXSeparatorItem10: TSpTBXSeparatorItem;
    mnuNewAwayMsg: TSpTBXItem;
    mnuBack: TSpTBXItem;
    RichEditPopupMenu: TSpTBXPopupMenu;
    AutoJoin1: TSpTBXItem;
    AutoScroll1: TSpTBXItem;
    Clearwindow1: TSpTBXItem;
    Copy1: TSpTBXItem;
    SpTBXSeparatorItem9: TSpTBXSeparatorItem;
    Panel1: TSpTBXPanel;
    Panel3: TPanel;
    VDTBattles: TVirtualDrawTree;
    Splitter2: TSplitter;
    Panel4: TSpTBXPanel;
    DefaultSideImage: TImage;
    DefaultArmImage: TImage;
    DefaultCoreImage: TImage;
    BotImage: TImage;
    OptionsSpeedButton: TSpTBXSpeedButton;
    BattleScreenSpeedButton: TSpTBXSpeedButton;
    HelpButton: TSpTBXSpeedButton;
    ReplaysButton: TSpTBXSpeedButton;
    SearchButton: TSpTBXSpeedButton;
    ConnectButton: TTBXButton;
    PageControl1: TPageControl;
    Bevel2: TBevel;
    SpTBXSeparatorItem11: TSpTBXSeparatorItem;
    mnuIgnore: TSpTBXItem;
    FilterGroup: TSpTBXGroupBox;
    FiltersButton: TSpTBXButton;
    ArrowList: TImageList;
    FilterValueTextBox: TSpTBXEdit;
    ContainsRadio: TSpTBXRadioButton;
    DoNotContainsRadio: TSpTBXRadioButton;
    AddToFilterListButton: TSpTBXButton;
    FilterListCombo: TSpTBXComboBox;
    RemoveFromFilterListButton: TSpTBXButton;
    ClearFilterListButton: TSpTBXButton;
    EnableFilters: TSpTBXCheckBox;
    FilterList: TVirtualStringTree;
    mnuDisplayFilters: TSpTBXItem;
    RemoveMenu: TSpTBXSubmenuItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    SpTBXPanel1: TSpTBXPanel;
    FullFilter: TSpTBXCheckBox;
    InProgressFilter: TSpTBXCheckBox;
    LadderFilter: TSpTBXCheckBox;
    LockedFilter: TSpTBXCheckBox;
    PasswordedFilter: TSpTBXCheckBox;
    RankLimitFilter: TSpTBXCheckBox;
    ReplaysFilter: TSpTBXCheckBox;
    ModsNotAvailableFilter: TSpTBXCheckBox;
    MapsNotAvailableFilter: TSpTBXCheckBox;
    NatTraversalFilter: TSpTBXCheckBox;
    PlayersSignButton: TSpTBXButton;
    PlayersValueTextBox: TJvSpinEdit;
    MaxPlayersSignButton: TSpTBXButton;
    MaxPlayersValueTextBox: TJvSpinEdit;
    Sortbygroup1: TMenuItem;
    HighlighBattlesTimer: TTimer;
    MaxPlayersFilter: TSpTBXCheckBox;
    PlayersFilter: TSpTBXCheckBox;
    MuteSubitemMenu: TSpTBXSubmenuItem;
    mnuMute5Min: TSpTBXItem;
    mnuMute30Min: TSpTBXItem;
    mnuMute1Hour: TSpTBXItem;
    mnuMute1Day: TSpTBXItem;
    mnuMute1Week: TSpTBXItem;
    SpTBXSeparatorItem6: TSpTBXSeparatorItem;
    mnuMuteCustom: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    mnuFindIP: TSpTBXItem;
    mnuUnmute: TSpTBXItem;
    SpTBXSeparatorItem12: TSpTBXSeparatorItem;
    SpTBXSeparatorItem13: TSpTBXSeparatorItem;
    HttpCli2: THttpCli;
    LadderCups: TImageList;
    LadderCupsRefresh: TTimer;
    mnuBattleHost: TSpTBXSubmenuItem;
    ClientPopupMenu: TSpTBXPopupMenu;
    PlayerSubMenu: TSpTBXSubmenuItem;
    SpTBXSeparatorItem14: TSpTBXSeparatorItem;
    mnuBattleDlMap: TSpTBXItem;
    mnuBattleDlMod: TSpTBXItem;
    mnuBattleAddToFilters: TSpTBXSubmenuItem;
    mnuDisplayOnly: TSpTBXSubmenuItem;
    mnuHideEvery: TSpTBXSubmenuItem;
    mnuDisplayOnlyHost: TSpTBXItem;
    mnuDisplayOnlyMap: TSpTBXItem;
    mnuDisplayOnlyMod: TSpTBXItem;
    mnuHideEveryMap: TSpTBXItem;
    mnuHideEveryMod: TSpTBXItem;
    mnuHideEveryHost: TSpTBXItem;
    SpTBXItem3: TSpTBXItem;
    mnuForceLobbyUpdateCheck: TSpTBXItem;
    procedure mnuOpenPrivateChatClick(Sender: TObject);
    procedure mnuSelectBattleClick(Sender: TObject);
    procedure SpTBXItem1Click(Sender: TObject);
    procedure mnuManageGroupsClick(Sender: TObject);
    procedure mnuNewGroupClick(Sender: TObject);
    procedure AddToGroupItemClick(Sender: TObject);
    procedure RefreshClientSort;
    procedure ClientsListBoxClick(Sender: TObject);
    procedure mnuRemoveFromGroupClick(Sender: TObject);
    procedure mnuHelpClick(Sender: TObject);
    procedure mnuSpringmarkClick(Sender: TObject);
    procedure mnuSpringLadderClick(Sender: TObject);
    procedure mnuSpringReplaysClick(Sender: TObject);
    procedure mnuUnknownFilesClick(Sender: TObject);
    procedure mnuBugTrackerClick(Sender: TObject);
    procedure mnuMessageboardClick(Sender: TObject);
    procedure mnuSpringHomePageClick(Sender: TObject);
    procedure mnuFAQClick(Sender: TObject);
    procedure mnuPlayingSpringClick(Sender: TObject);
    procedure mnuGlossaryClick(Sender: TObject);
    procedure mnuStrategyAndTacticsClick(Sender: TObject);
    procedure mnuBattleScreenClick(Sender: TObject);
    procedure menuHostBattleClick(Sender: TObject);
    procedure mnuHostLadderBattleClick(Sender: TObject);
    procedure mnuHostReplayClick(Sender: TObject);
    procedure SpTBXItem6Click(Sender: TObject);
    procedure AutoJoin1Click(Sender: TObject);
    procedure mnuAwayClick(Sender: TObject);
    procedure mnuBackClick(Sender: TObject);
    procedure mnuNewAwayMsgClick(Sender: TObject);
    procedure AwayMessageItemClick(Sender: TObject);
    procedure RemoveAwayMessageItemClick(Sender: TObject);
    procedure ConnectionPopupMenuPopup(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure mnuIgnoreClick(Sender: TObject);
    procedure FiltersButtonClick(Sender: TObject);
    procedure AddToFilterListButtonClick(Sender: TObject);
    procedure PlayersSignButtonClick(Sender: TObject);
    procedure MaxPlayersSignButtonClick(Sender: TObject);
    procedure PlayersValueTextBoxChange(Sender: TObject);
    procedure MaxPlayersValueTextBoxChange(Sender: TObject);
    procedure FullFilterClick(Sender: TObject);
    procedure InProgressFilterClick(Sender: TObject);
    procedure LadderFilterClick(Sender: TObject);
    procedure LockedFilterClick(Sender: TObject);
    procedure PasswordedFilterClick(Sender: TObject);
    procedure NatTraversalFilterClick(Sender: TObject);
    procedure RankLimitFilterClick(Sender: TObject);
    procedure MapsNotAvailableFilterClick(Sender: TObject);
    procedure ModsNotAvailableFilterClick(Sender: TObject);
    procedure FilterListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure FilterGroupResize(Sender: TObject);
    procedure ReplaysFilterClick(Sender: TObject);
    procedure EnableFiltersClick(Sender: TObject);
    procedure RemoveFromFilterListButtonClick(Sender: TObject);
    procedure ClearFilterListButtonClick(Sender: TObject);
    procedure mnuDisplayFiltersClick(Sender: TObject);
    procedure FilterListCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FilterListHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure SaveFiltersToFile;
    procedure LoadFiltersFromFile;
    procedure UpdateFilters;
    procedure HighlighBattlesTimerTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PlayersFilterClick(Sender: TObject);
    procedure MaxPlayersFilterClick(Sender: TObject);
    procedure FilterListResize(Sender: TObject);
    procedure mnuKickClick(Sender: TObject);
    procedure mnuKickReasonClick(Sender: TObject);
    procedure mnuMute5MinClick(Sender: TObject);
    procedure mnuMute30MinClick(Sender: TObject);
    procedure mnuMute1HourClick(Sender: TObject);
    procedure mnuMute1DayClick(Sender: TObject);
    procedure mnuMute1WeekClick(Sender: TObject);
    procedure mnuMuteCustomClick(Sender: TObject);
    procedure SpTBXItem2Click(Sender: TObject);
    procedure mnuFindIPClick(Sender: TObject);
    procedure mnuUnmuteClick(Sender: TObject);
    procedure LadderCupsRefreshTimer(Sender: TObject);
    procedure FilterListChecking(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure BattleListPopupMenuInitPopup(Sender: TObject;
      PopupView: TTBView);
    procedure ClientPopupMenuInitPopup(Sender: TObject;
      PopupView: TTBView);
    procedure mnuDisplayOnlyHostClick(Sender: TObject);
    procedure mnuDisplayOnlyModClick(Sender: TObject);
    procedure mnuDisplayOnlyMapClick(Sender: TObject);
    procedure mnuHideEveryHostClick(Sender: TObject);
    procedure mnuHideEveryModClick(Sender: TObject);
    procedure mnuHideEveryMapClick(Sender: TObject);
    procedure VDTBattlesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpTBXItem3Click(Sender: TObject);
    procedure mnuBattleDlMapClick(Sender: TObject);
    procedure mnuBattleDlModClick(Sender: TObject);
    procedure mnuForceLobbyUpdateCheckClick(Sender: TObject);

  published
    MainTitleBar: TSpTBXTitleBar;
    Panel2: TSpTBXPanel;
    Bevel1: TBevel;
    PlayersLabel: TSpTBXLabel;
    SortLabel: TLabel;
    ClientsListBox: TListBox;
    ButtonImageList: TImageList;
    PlayerStateImageList: TImageList;
    ConnectionStateImageList: TImageList;
    Socket: TWSocket;
    KeepAliveTimer: TTimer;
    ReadyStateImageList: TImageList;
    BattleStatusImageList: TImageList;
    SyncImageList: TImageList;
    ApplicationEvents1: TApplicationEvents;
    OpenDialog1: TOpenDialog;
    RanksImageList: TImageList;
    SortPopupMenu: TPopupMenu;
    Nosorting1: TMenuItem;
    Sortbyname1: TMenuItem;
    Sortbystatus1: TMenuItem;
    Sortbyrank1: TMenuItem;
    Sortbycountry1: TMenuItem;
    GradesImageList: TImageList;
    NumbersImageList: TImageList;
    MiscImageList: TImageList;
    ColorImageList: TImageList;
    ClientPopupMenu2: TSpTBXPopupMenu;
    mnuOpenPrivateChat: TSpTBXItem;
    ModerationSubmenuItem: TSpTBXSubmenuItem;
    SpTBXLabelItem1: TSpTBXLabelItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    mnuKick: TSpTBXItem;
    mnuKickReason: TSpTBXItem;
    Splitter1: TSplitter;

  public
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;

    procedure OnDataHasArrivedMessage(var Msg: TMessage); message WM_DATAHASARRIVED;
    procedure OnOpenOptionsMessage(var Msg: TMessage); message WM_OPENOPTIONS;
    procedure OnDoRegisterMessage(var Msg: TMessage); message WM_DOREGISTER;
    procedure OnCloseTabMessage(var Msg: TMessage); message WM_CLOSETAB;
    procedure OnConnectMessage(var Msg: TMessage); message WM_CONNECT;
    procedure OnForceReconnectMessage(var Msg: TMessage); message WM_FORCERECONNECT;
    procedure OnConnectToNextHostMessage(var Msg: TMessage); message WM_CONNECT_TO_NEXT_HOST;
    procedure WMAfterCreate(var AMsg: TMessage); message WM_AFTERCREATE; // we will do some post-initialization here

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

    function AddTabWindow(Caption: string; SetFocus: Boolean): Integer;
    function GetTabWindowPageIndex(Caption: string): Integer;
    procedure ChangeActivePageAndUpdate(PageControl: TPageControl; PageIndex: Integer); // never change ActivePageIndex manually, since it doesn't trigger OnChange event!
    procedure RichEditMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditClick(Sender: TObject);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function CheckServerVersion(ServerVersion: string): Boolean;
    procedure ProcessCommand(s: WideString; CameFromBattleScreen: Boolean);
    procedure ProcessRemoteCommand(s: WideString); // processes command received from server
    procedure TryToCloseTab(TabSheet: TMyTabSheet);
    procedure OpenPrivateChat(ClientName: string);

    function AddClientToTab(Tab: TMyTabSheet; ClientName: string): Boolean;
    function RemoveClientFromTab(Tab: TMyTabSheet; ClientName: string): Boolean;
    procedure RemoveAllClientsFromTab(Tab: TMyTabSheet);
    procedure UpdateClientsListBox;

    function AddBattle(ID: Integer; BattleType: Integer; NATType: Integer; Founder: TClient; IP: string; Port: Integer; MaxPlayers: Integer; Password: Boolean; Rank: Byte; MapHash: Integer; MapName: string; Title: WideString; ModName: string): Boolean;
    function RemoveBattle(ID: Integer): Boolean;
    function RemoveBattleByIndex(Index: Integer): Boolean;
    function GetBattle(ID: Integer): TBattle;
    function GetBattleFromNode(Node : PVirtualNode): TBattle;
    function GetFilterIndexFromNode(Node : PVirtualNode): integer;
    function GetBattleIndex(ID: Integer): Integer;

    procedure ClearAllClientsList;
    procedure ClearClientsLists; // clears all clients list (in channels, private chats, battle, local tab, ...)
    procedure AddClientToAllClientsList(Name: string; Status2: Integer; Country: string; CPU: Integer);
    function RemoveClientFromAllClientsList(Name: string): Boolean;
    function GetClient(Name: string): TClient; // returns nil if not found
    function GetClientByIP(IP: string): TClient; // returns nil if not found
    function GetClientIndexEx(Name: string; ClientList: TList): Integer;

    function GetBot(Name: string; Battle: TBattle): TBot;

    procedure TryToDisconnect;
    // note that the generic TryToSendCommand is located under a private block
    function TryToSendCommand(Command: WideString; Params: WideString; AssignID: Boolean): Integer; overload;
    function TryToSendCommand(Command: WideString; AssignID: Boolean): Integer; overload;
    procedure TryToSendCommand(Command: WideString; Params: WideString); overload;
    procedure TryToSendCommand(Command: WideString); overload;

    procedure TryToSendDataDirectly(s: string); // deprecated - use TryToSendCommand method instead!
    procedure TryToLogin(Username, Password: string);
    procedure TryToRegister(Username, Password: string); // try to register new account
    procedure TryToAutoCompleteClientName(Edit: TSpTBXEdit; Clients: TList);

    procedure SortClientsList(List: TList; SortStyle: Byte);
    procedure SortBattlesList(SortStyle: Byte; Ascending: Boolean);
    function CompareClients(Client1: TClient; Client2: TClient; SortStyle: Byte): Shortint; // used with SortClientsList method (and other methods?)
    function CompareBattles(Battle1, Battle2: TBattle; SortStyle: Byte): Shortint;
    procedure RefreshBattleList();
    function isBattleVisible(Battle:TBattle):Boolean;
    procedure SortBattleInList(Index: Integer; SortStyle: Byte; Ascending: Boolean);

    procedure AddNotification(HeaderText, MessageText: string; DisplayTime: Integer;OnClick: Boolean = false;BattleId: integer = -1);
    procedure NotificationClick(Sender: TObject);
    procedure NotificationClose(Sender: TObject);

    procedure UpdateColorImageList; // will (re)populate ColorImageList

    procedure SaveGroups;
    procedure LoadGroups;

    procedure SaveAwayMessages;
    procedure LoadAwayMessages;

    procedure CheckNewVersion;
    procedure SetAway(AwayIndex: integer);

  published
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClientsListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
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
    procedure JoinBattle(Battle: TBattle);
    procedure VDTBattlesDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HelpButtonClick(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure AutoSetBack;
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure Clearwindow1Click(Sender: TObject);
    procedure ReplaysButtonClick(Sender: TObject);
    procedure SortMenuItemClick(Sender: TObject);
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
    procedure VDTBattlesHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure ClientsListBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClientsListBoxMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ConnectButtonClick(Sender: TObject);
    procedure SortLabelClick(Sender: TObject);

  private
    function TryToSendCommand(Command: WideString; SendParams: Boolean; Params: WideString; AssignID: Boolean): Integer; overload;

  public
    procedure TryToConnect; overload;
    procedure TryToConnect(ServerAddress, ServerPort: string); overload;

    procedure AddMainLog(Text: WideString; Color: TColor); overload;
    procedure AddMainLog(Text: WideString; Color: TColor; AmbiguousCommandID: Integer); overload;
    procedure AddTextToChatWindow(Chat: TMyTabSheet; Text: WideString; Color: TColor); overload;
    procedure AddTextToChatWindow(Chat: TMyTabSheet; Text: WideString; Color: TColor; ChatTextPos: Integer); overload;
  end;

  TConnectionState = (Disconnected, Connecting, Connected);

  PPingInfo = ^TPingInfo;
  TPingInfo =
  record
    TimeSent: Cardinal; // time when we sent this ping packet
    Key: Word; // unique ping packet ID (we use it to identify the packet so we don't mingle it with other ping packets if more were sent at the same time)
  end;
var
  Colors: TColors = (Normal:clBlack; Data: clGreen; Error:clRed; Info:clBlue; MinorInfo: clNavy; ChanJoin: clGreen; ChanLeft: clNavy; MOTD: clMaroon; SayEx: clPurple; Topic: clMaroon; ClientAway: $009F9F9F; MapModUnavailable: $00ed00d5;BotText:clGray; MyText: $0092726e;AdminText: $00A36603 );
  Debug:
  record
    Enabled: Boolean; // show some debugging information
    Log: Boolean; // save local tab's text to disk on program exit
    FilterPingPong: Boolean;
    IgnoreVersionIncompatibility: Boolean;
  end;

  MainForm: TMainForm;

  KAT:TKeepAliveThread;

  { this is a list of all clients on the server. We must maintain this list by reading ADDUSER and REMOVEUSER commands.
    All other clients lists (in channels, battles) contain objects linking to actual objects in this list. Never free
    any clients in any list except in this one, since freeing them in any other list will also free them in this list! }
  AllClients: TList;

  ClientGroups: TList;

  AwayMessages: record
    Titles: TStrings;
    Messages: TStrings;
  end;

  Status: record
    MySpringVersion: string; // acquired via "spring.exe /V"
    ConnectionState: TConnectionState;
    NATHelpServerPort: Integer; // server's UDP port of "NAT Help Server". Acquired from "TASSERVER" command.
    ServerMode: Integer; // 0 - normal mode, 1 - LAN mode
    Registering: Boolean; // used only when registering new account
    LoggedIn: Boolean; // only check this if ConnectionState = Connected!
    ReceivingLoginInfo: Boolean; // true after we received ACCEPTED command but not yet received LOGININFOEND command. This means we are currently receiving login info from the server.
    Hashing: Boolean; // if true, we are currently changing mod and hashing file, which takes time and allows application to process other messages meanwhile. We use this when we receive JOINBATTLE command, since it is possible to receive REQUESTBATTLESTATUS command before we are done hashing and so an invalid sync status would be sent. That is why we must wait for hashing to finish when we receive REQUESTBATTLESTATUS command.
    Synced: Boolean; // only check this if IsBattleActive = True!
    MyRank: Byte;
    TimeOfLastDataSent: LongWord; // the time when we sent last string to the server. We need to know this so that we know if we must ping server if time of last data sent was some time ago (otherwise server will disconnect us due to timeout!)
    TimeOfLastDataReceived: LongWord; // the time when we received last data from server. If this time get's too high, we assume that connection to server has been lost. Nevertheless, it's us who must keep constant connection to server by pinging it!
    Username: string; // my username
    Me: TClient; // reference to myself in TClient from AllClients list. Note: This reference will only become valid once we received ADDUSER command containing our username, not before! - Status.Username property gets assigned earlier (when we received ACCEPTED command from the server)
    AwayTime: Cardinal; // not a "period" of time, but the GetTickCount value (taken when application lost focus the last time)
    CurrentAwayItem: integer; // current away message : -1 = default away, -2 = available
    CurrentAwayMessage : string;
    AutoAway: boolean; // timer away = true , manual away = false
    AmIInGame: Boolean; // true if we are in-game
    BattleStatusRequestReceived: Boolean; // used when joining a battle, to avoid dead-lock
    BattleStatusRequestSent: Boolean; // used when joining a battle, to avoid dead-lock
    MyCPU: Integer;
    LastCommandReceived: string; // here we keep only the first part of the command that is last received, that is the command identifier without the actual parameters. Note that we keep it in upper-case for easier comparision!
    LastCommandReceivedFull: string; // here we keep the full command we last received from the server (together with the param list and message ID, if any)
    CumulativeDataSent: Int64; // number of bytes sent since connection has been established. Note that this counter gets reset when you reconnect
    CumulativeDataRecv: Int64; // number of bytes received since connection has been established. Note that this counter gets reset when you reconnect
    CurrentMsgID: Integer; // when sending commands to the server some are assigned an unique ID. This value represents last assigned ID. Currently we assign IDs consecutively (note that you may assign IDs any way you want, random, consecutive, or even not at all. IDs have only one function: to track server responses to commands sent by the client. See server's protocol description for more info)
  end;



  Filters:
  record
    Full: Boolean;
    InProgress: Boolean;
    Ladder: Boolean;
    Locked: Boolean;
    Passworded: Boolean;
    NatTraversal: Boolean;
    RankLimitSupEqMine: Boolean;
    MapNotAvailable: Boolean;
    ModNotAvailable: Boolean;
    Replays: Boolean;
    Players: TFilterNumber;
    MaxPlayers: TFilterNumber;
    TextFilters: TList;
  end;

  Pings: TList; // list of TPingInfo records (holds current ping packets info. See /ping command implementation)

  // NAT traversing method used with the lobby client is described in TASServer's docs!
  NATTraversal:
  record
    MyPrivateUDPSourcePort: Integer;
    MyPublicUDPSourcePort: Integer;
    TimeOfLastKeepAlive: Cardinal; // time when we last sent UDP packet to keep binding in router's translation table open (so that router doesn't "forget" it)
  end;

  NotifyingBattleId : Integer; // used when clicking on the notification message to join the good battle

  TeamColors: TTeamColors;

  Battles: TList;
  ReplayList: TList;

  RefreshingBattleList:Boolean = false;

  FlagBitmaps: TList; // of TBitmap objects
  FlagBitmapsInitialized: Boolean = False;
  FlagBitmapsReverseTable: array[Ord('a')..Ord('z'), Ord('a')..Ord('z')] of Smallint;

  CommonFont: TFont; // common lobby font (used with chat windows, private chat, clients list, battle window, ...)
  BattleClientsListFont: TFont; // font used with VDTBattleClients list

  MuteListForms: TList; // list of all open MuteListForm-s. When form is created it will add itself to the list automatically, likewise will remove itself from the list when it gets destroyed
  ReceivingMuteListForChannel: string; // name of the channel for which we are currently receiving the mute list (we've extracted this info form MUTELISTBEGIN command)

  ReceivedAgreement: TStringList; // this is temporary string list to store received lines of an agreement sent by server.

  ProcessingRemoteCommand: Boolean = False; // tells us if we are processing remote command currently. This is important because sometimes Application.ProcessMessages can get called from within ProcessRemoteCommand method, which could led to next command being processed before current one is finished.

  // used with Socket:
  ReceiveBuffer: WideString; // this is temp buffer of what we receive from socket

  LadderList: TList;

  HostButtonMenuIndex : Integer;

  { we have to use messaging queue, since TWSocket doesn't seem to work correctly if certain methods are called
    from within its events (and especially if new messages arrive in meantime) }
  CommandQueue: array[0..QUEUE_LENGTH-1] of WideString;
  CommandQueueHead: Integer = 0;
  CommandQueueTail: Integer = 0;

  SelectedBattle: TBattle;
  SelectedUserName: string;
  RichEditSelectedClient: TClient;

  LastBoundTo: integer;
  FindIPQueueList : TStringList;

  LastCursorPos : TPoint;

  displayingNotificationList: TList;

  RunningUnderWine: Boolean = False; // set via -wine argument to the program
  MyInternetIp: String;
  

  function Dequeue: WideString; forward;
  function Enqueue(s: WideString): Integer; forward;


implementation

uses BattleFormUnit, PreferencesFormUnit, Misc, WaitForAckUnit,
  InitWaitFormUnit, HelpUnit, DebugUnit, ReplaysUnit,
  HttpGetUnit, OnlineMapsUnit, ShellAPI, RichEdit, NotificationsUnit,
  HostBattleFormUnit, AgreementUnit, PerformFormUnit, HighlightingUnit,
  IgnoreListUnit, MuteListFormUnit, MapListFormUnit, SplashScreenUnit,
  LoginProgressFormUnit, GpIFF, SearchFormUnit, ManageGroups, ColorPicker,
  AwayMessageFormUnit,JclStrings;

{$R *.dfm}

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

    inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or
    WS_EX_APPWINDOW;

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  // detach main form from Application and hide Application's taskbar button:

  with Params do begin
    //ExStyle := ExStyle or WS_EX_APPWINDOW;
    ExStyle := ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;

  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong (Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

// this makes minimizing and restoring of application possible when using taskbar buttons for each form. See http://tinyurl.com/3j848 for details.
procedure TMainForm.WMSysCommand(var Message: TWMSysCommand);
begin
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
end;

function Dequeue: WideString;
begin
  Result := CommandQueue[CommandQueueHead];
  CommandQueueHead := (CommandQueueHead + 1) mod QUEUE_LENGTH;
end;

function Enqueue(s: WideString): Integer;
begin
  Result := CommandQueueTail;
  CommandQueue[CommandQueueTail] := s;
  CommandQueueTail := (CommandQueueTail + 1) mod QUEUE_LENGTH;
end;
procedure TMainForm.mnuFAQClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring.clan-sy.com/wiki/FAQ');
end;

procedure TMainForm.mnuPlayingSpringClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring.clan-sy.com/wiki/Using_Spring');
end;

procedure TMainForm.mnuGlossaryClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring.clan-sy.com/wiki/Glossary');
end;

procedure TMainForm.mnuStrategyAndTacticsClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring.clan-sy.com/wiki/Strategy_and_Tactics');
end;

procedure TMainForm.OnDataHasArrivedMessage(var Msg: TMessage); // responds to WM_DATAHASARRIVED message
var
  s: WideString;
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

  // message ID is currently still contained in this string, it will get extracted in ProcessRemoteCommand method

  if Debug.Enabled and ((not Debug.FilterPingPong) or (s <> 'PONG')) then AddMainLog('Server: "' + s + '"', Colors.Data);
  Status.LastCommandReceivedFull := s;
  // Status.LastCommandReceived will get assigned in ProcessRemoteCommand method!
  Inc(Status.CumulativeDataRecv, Length(s));
  ProcessRemoteCommand(s);
end;

procedure TMainForm.OnOpenOptionsMessage(var Msg: TMessage); // responds to WM_OPENOPTIONS message
var
  i, index: Integer;
begin
  index := 0;
  for i := 0 to PreferencesForm.SpTBXTabControl1.Items.Count-1 do
    if PreferencesForm.SpTBXTabControl1.Items[i].Caption = 'Account' then
    begin
      index := i;
      Break;
    end;

  PreferencesForm.SpTBXTabControl1.ActiveTabIndex := index;
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
  Status.AwayTime := GetTickCount;
  AutoSetBack;
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
    ConnectButton.ImageIndex := Ord(Status.ConnectionState);
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
    BattleForm.ChangeMapToNoMap('ProvingGrounds.smf');
    Exit;
  end;

  // F1 to show the help
  if (Msg.CharCode = VK_F1) then
  begin
    Handled := True;
    HelpForm.Show;
    Exit;
  end;

  // F2 to switch between battle/main screen
  if (Msg.CharCode = VK_F2) then
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

  // Alt+Left to change channel tab
  if (Msg.CharCode = VK_LEFT) and (GetKeyState(VK_LMENU) < 0) then
  begin
    Handled := True;
    PageControl1.SelectNextPage(False);
    Exit;
  end;

  // Alt+Right to change channel tab
  if (Msg.CharCode = VK_RIGHT) and (GetKeyState(VK_LMENU) < 0) then
  begin
    Handled := True;
    PageControl1.SelectNextPage(True);
    Exit;
  end;

  // TAB when input TEdit has focus:
  if (Msg.CharCode = 9) and (Screen.ActiveControl.ClassType = TSpTBXEdit) and (Screen.ActiveControl.Name = 'InputEdit') then
  begin
    Handled := True;
    if (PageControl1.ActivePage.Caption = LOCAL_TAB) or (Screen.ActiveForm.Name = 'BattleForm') then
      TryToAutoCompleteClientName(TSpTBXEdit(Screen.ActiveControl), AllClients)
    else if PageControl1.ActivePage.Caption[1] = '#' then // a channel tab
      TryToAutoCompleteClientName(TSpTBXEdit(Screen.ActiveControl), (PageControl1.ActivePage as TMyTabSheet).Clients)
    else // a private chat tab
      TryToAutoCompleteClientName(TSpTBXEdit(Screen.ActiveControl), (PageControl1.ActivePage as TMyTabSheet).Clients);

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
    TryToAddLog(Result, 'Logging started on ' + FormatDateTime('ddd mmm dd hh:nn:ss yyyy', Now));

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
function TMainForm.AddBattle(ID: Integer; BattleType: Integer; NATType: Integer; Founder: TClient; IP: string; Port: Integer; MaxPlayers: Integer; Password: Boolean; Rank: Byte; MapHash: Integer; MapName: string; Title: WideString; ModName: string): Boolean;
var
  Battle: TBattle;
  i:integer;
begin
  while RefreshingBattleList do;
  Result := False;

  if GetBattle(ID) <> nil then Exit;

  Battle := TBattle.Create;
  Battle.ID := ID;
  Battle.BattleType := BattleType;
  Battle.NATType := NATType;
  Battle.Description := Title;
  Battle.MapHash := MapHash;
  Battle.Map := MapName;
  Battle.Password := Password;
  Battle.RankLimit := Rank;
  Battle.IP := IP;
  Battle.Port := Port;
  Battle.MaxPlayers := MaxPlayers;
  Battle.ModName := ModName;
  Battle.Clients.Add(Founder);
  Battle.Visible :=  isBattleVisible(Battle);
  Battle.Node := nil;


  if Battle.BattleType = 0 then Battle.SpectatorCount := 0 else Battle.SpectatorCount := 1;

  Battles.Add(Battle);

  with VDTBattles do
  begin
    if Battle.Visible then begin
      RootNodeCount := RootNodeCount + 1;
      Battle.Node := GetLast;
    end;
  end;


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

  if TBattle(Battles[j]).Visible then
    VDTBattles.DeleteNode(TBattle(Battles[j]).Node, True);
  TBattle(Battles[j]).Free;
  Battles.Delete(j);

  Result := True;
end;

function TMainForm.RemoveBattleByIndex(Index: Integer): Boolean;
begin
  Result := False;

  if Index > Battles.Count-1 then Exit;

  if TBattle(Battles[index]).Visible then
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

procedure TMainForm.AddClientToAllClientsList(Name: string; Status2: Integer; Country: string; CPU: Integer);
var
  Client: TClient;
begin
  Client := TClient.Create(Name, Status2, Country, CPU);
  Client.SprinkMarkScore := -1;
  Client.SpringMarkData := '';
  Client.CurrentLadderRank := -1;
  Client.CurrentLadderRating := -1;
  AllClients.Add(Client);
  if not Status.ReceivingLoginInfo then SortClientsList(AllClients,Preferences.SortStyle);
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

function TMainForm.GetClientByIP(IP: string): TClient;
var
  i: Integer;
begin
  for i := 0 to AllClients.Count - 1 do if TClient(AllClients[i]).IP = IP then
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

function TMainForm.GetBattleFromNode(Node : PVirtualNode): TBattle;
var
  i: Integer;
begin
  for i := 0 to Battles.Count - 1 do
    if TBattle(Battles[i]).Node <> nil then
    if TBattle(Battles[i]).Node.Index = Node.index then
  begin
    Result := Battles[i];
    exit;
  end;
  Result := nil;
end;

function TMainForm.GetFilterIndexFromNode(Node : PVirtualNode): integer;
var
  i: Integer;
  j: Integer;
begin
  j:=0;
  with Filters do
  begin
  for i := 0 to TextFilters.Count - 1 do
    if TFilterText(TextFilters[i]^).Node <> nil then
    if TFilterText(TextFilters[i]^).Node.Index = Node.index then
  begin
    Result := i;
    exit;
  end;
  Result := TextFilters.Count-1;
  end;
end;

function TMainForm.GetBattleIndex(ID: Integer): Integer;
var
  i: Integer;
begin
  for i := 0 to Battles.Count - 1 do if TBattle(Battles[i]).ID = ID then
  begin
    Result := i;
    Exit;
  end;

  Result := -1;
end;

{ TClient }

constructor TClient.Create(Name: string; Status: Integer; Country: string; CPU: Integer);
begin
  Self.Name := Name;
  Self.Status := Status;
  Self.BattleStatus := 0;
  Self.InBattle := False;
  Self.Country := Country;
  Self.CPU := CPU;
  Self.IP := ''; // IP will get assigned by the CLIENTIPPORT command when needed
  Self.TeamColor := 0;
  Self.CupList := TList.Create;
  Self.CupLadderList := TStringList.Create;
end;

function TClient.GetChatTextColor: TColor;
begin
  if Self.Name = MainUnit.Status.Username then
    Result := Colors.MyText
  else
    if Self.GetAccess then
      Result := Colors.AdminText
    else
      Result := Colors.Normal;
end;

function TClient.isComSharing: Boolean;
var
  i:integer;
begin
  Result := False;
  if Self.InBattle then begin
    for i := 0 to BattleState.Battle.Clients.Count-1 do begin
      if (TClient(BattleState.Battle.Clients[i]).GetTeamNo = Self.GetTeamNo) and (TClient(BattleState.Battle.Clients[i]).Name <> Self.Name) and (TClient(BattleState.Battle.Clients[i]).GetMode <> 0) then begin
        Result := True;
        break;
      end;
    end;
    if Result = False then begin
      for i := 0 to BattleState.Battle.Bots.Count-1 do begin
        if (TBot(BattleState.Battle.Bots[i]).GetTeamNo = Self.GetTeamNo) then begin
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

function TClient.GetGroup: Integer;
var
  i,j:integer;
begin
  Result := -1;
  for i:=0 to ClientGroups.Count -1 do
    for j:=0 to TClientGroup(ClientGroups[i]).Clients.Count -1 do
      if TClientGroup(ClientGroups[i]).Clients[j] = Self.Name then begin
        Result := i;
        Exit;
      end;
end;

function TClient.GetBattleId: Integer;
var
  i,j:integer;
begin
  Result := -1;
  if not Self.InBattle then
    Exit;

  for i:=0 to Battles.Count -1 do
    for j:=0 to TBattle(Battles[i]).Clients.Count-1 do
      if TClient(TBattle(Battles[i]).Clients[j]).Name = Self.Name then begin
        Result := TBattle(Battles[i]).ID;
        Exit;
      end;
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

procedure TClient.SetRank(Rank: Integer);
begin
  Status := (Status and $FFFFFFE3) or (Rank shl 2);
end;

procedure TClient.SetHandicap(Handicap: Integer);
begin
  BattleStatus := (BattleStatus and $FFFC07FF) or (Handicap shl 11);
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

function TClient.GetRank: Integer;
begin
  Result := (Status and $1C) shr 2;
end;

function TClient.GetAccess: Boolean;
begin
  Result := IntToBool((Status and $20) shr 5);
end;

function TClient.GetBotMode: Boolean;
begin
  Result := IntToBool((Status and $40) shr 6);
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
  Self.TeamColor := Bot.TeamColor;
end;

constructor TBot.Create(Name: string; OwnerName: string; AIDll: string);
begin
  Self.Name := Name;
  Self.OwnerName := OwnerName;
  Self.AIDll := AIDll;
  Self.BattleStatus := 0;
  Self.TeamColor := 0;
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

procedure TBot.SetSide(Side: Integer);
begin
  BattleStatus := (BattleStatus and $F0FFFFFF) or (Side shl 24);
end;

function TBot.isComSharing: Boolean;
var
  i:integer;
begin
  Result := False;
    for i := 0 to BattleState.Battle.Clients.Count-1 do begin
      if (TClient(BattleState.Battle.Clients[i]).GetTeamNo = Self.GetTeamNo) and (TClient(BattleState.Battle.Clients[i]).GetMode <> 0) then begin
        Result := True;
        break;
      end;
    end;
    if Result = False then begin
      for i := 0 to BattleState.Battle.Bots.Count-1 do begin
        if (TBot(BattleState.Battle.Bots[i]).GetTeamNo = Self.GetTeamNo) and (TBot(BattleState.Battle.Bots[i]).Name <> Self.Name) then begin
          Result := True;
          break;
        end;
      end;
    end;
end;

{ TBattle }

constructor TBattle.Create;
begin
  inherited Create;
  SpectatorCount := 0;
  HashCode := 0;
  MapHash := 0;
  RankLimit := 0;
  Locked := False;
  Clients := TList.Create;
  Bots := TList.Create;
  CurrentHighLightGroup := -1;
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
    if (SpectatorCount = Clients.Count) and (Bots.Count = 0) then Exit; // all players are spectators (and there are no bots in this battle. If there are bots, we will allow the battle to start since host is probably hosting a bot vs. bot type of a battle)
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

function TBattle.IsLadderBattle: Boolean;
begin
  Result := LeftStr(Self.Description,8) = '(ladder ';
end;

function TBattle.GetLadderId: integer;
var
  tmp : string;
begin
  Result := -1;
  if Self.IsLadderBattle then
  begin
    tmp := MidStr(Self.Description,9,5000);
    try Result := StrToInt(LeftStr(tmp,Pos(')',tmp)-1)); except end;
  end;
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
    Result := (Clients.Count > 0) and (TClient(Clients[0]).GetInGameStatus);
end;

function TBattle.GetState: Integer; // use it to get index of image from BattleStatusImageList
begin
  Result := 0;
  if TClient(Clients[0]).GetInGameStatus then Inc(Result,2)
  else if IsBattleFull then Inc(Result);
  if Password then Inc(Result, 3);
  if BattleType = 1 then Inc(Result, 6);
  if IsLadderBattle and Password then Inc(Result,11);
end;

function TBattle.ClientsToString: string; // returns user names in a string, separated by spaces
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Clients.Count-1 do Result := Result + TClient(Clients[i]).Name + ', ';
  if Length(Result) > 0 then Delete(Result, Length(Result)-1, 2);
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

function TBattle.GetHighlightColor: TColor;
begin
  Result := clWindow;
  if CurrentHighLightGroup > -1 then
  begin
    try
      Result := TClientGroup(ClientGroups[CurrentHighLightGroup]).Color;
    except
      // nothing
    end;
  end;
end;

procedure TBattle.NextHighlight;
var
  GroupList: TList;
  i,j: integer;
  found: boolean;
  ptrInt: ^integer;
begin
  // we find the battle client group list
  GroupList := TList.Create;
  for i:=0 to Clients.Count-1 do
    if (TClient(Clients[i]).GetGroup > -1) and TClientGroup(ClientGroups[TClient(Clients[i]).GetGroup]).HighlightBattles then
    begin
      found := false;
      for j:=0 to GroupList.Count-1 do
        if integer(GroupList[j]^) = TClient(Clients[i]).GetGroup then
        begin
          found := true;
          break;
        end;
      if not found then
      begin
        New(ptrInt);
        ptrInt^ := TClient(Clients[i]).GetGroup;
        GroupList.Add(ptrInt);
      end;
    end;

    // we change the highligh group index to the next one or none if there is no group
    if GroupList.Count = 0 then
      CurrentHighLightGroup := -1
    else
    begin
      j := 0;
      for i:=0 to GroupList.Count-1 do
        if integer(GroupList[i]^) = CurrentHighLightGroup then
        begin
          j:=i;
          break;
        end;
      if j=GroupList.Count-1 then
        CurrentHighLightGroup := Integer(GroupList[0]^)
      else
        CurrentHighLightGroup := Integer(GroupList[j+1]^);
    end;
end;

{ TScript }

constructor TScript.Create(Script: string);
begin
  inherited Create;
  FScript := Script;
  FUpperCaseScript := UpperCase(Script);
  CompleteKeyList := TStringList.Create;
  KeyValueList := TStringList.Create;
  self.ParseScript;
  self.Corrupted := false;
end;

destructor TScript.Destroy;
begin
  CompleteKeyList.Free;
  KeyValueList.Free;
  inherited Destroy;
end;

procedure TScript.SetScript(Script: string);
begin
  FScript := Script;
  FUpperCaseScript := UpperCase(Script);
  self.ParseScript;
end;

function TScript.DoesTokenExist(Token: string): Boolean;
var
  i: Integer;
begin
  i := Pos(UpperCase(Token), FUpperCaseScript);
  Result := i > 0;
end;

function TScript.ReadMapName: string;
begin
  Result := ReadKeyValue('GAME/MAPNAME');
  if Result = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadModName: string;
begin
  Result := ReadKeyValue('GAME/GAMETYPE');
  if Result = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadStartMetal: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/STARTMETAL');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadStartEnergy: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/STARTENERGY');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadMaxUnits: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/MAXUNITS');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadStartPosType: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/STARTPOSTYPE');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadGameMode: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/GAMEMODE');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create('Corrupted script file!');
  end;
end;

function TScript.ReadLimitDGun: Boolean;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/LIMITDGUN');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
  try
    Result := StrToBool(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadDiminishingMMs: Boolean;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/DIMINISHINGMMS');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
  try
    Result := StrToBool(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadGhostedBuildings: Boolean;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/GHOSTEDBUILDINGS');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
  try
    Result := StrToBool(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create('Corrupt script file!');
  end;
end;

function TScript.ReadDisabledUnits: TStringList;
var
  i: integer;
  tmp: string;
begin
  Result := TStringList.Create;
  i:=0;
  tmp := ReadKeyValue('GAME/RESTRICT/Unit'+IntToStr(i));
  while tmp <> '' do
  begin
    Result.Add(tmp);
    i := i+1;
    tmp := ReadKeyValue('GAME/RESTRICT/Unit'+IntToStr(i));
  end;
end;

procedure TScript.ChangeHostIP(NewIP: string);
var
  i: Integer;
begin
  i := CompleteKeyList.IndexOf(LowerCase('GAME/HOSTIP'));
  if i = -1 then raise Exception.Create('Corrupt script file!');
  KeyValueList[i] := NewIP;
end;

procedure TScript.ChangeHostPort(NewPort: string);
var
  i: Integer;
begin
  i := CompleteKeyList.IndexOf(LowerCase('GAME/HOSTPORT'));
  if i = -1 then raise Exception.Create('Corrupt script file!');
  KeyValueList[i] := NewPort;
end;

procedure TScript.ChangeMyPlayerNum(NewNum: Integer);
var
  i: Integer;
begin
  i := CompleteKeyList.IndexOf(LowerCase('GAME/MYPLAYERNUM'));
  if i = -1 then raise Exception.Create('Corrupt script file!');
  KeyValueList[i] := IntToStr(NewNum);
end;

procedure TScript.ChangeNumPlayers(NewNum: Integer);
var
  i: Integer;
begin
  i := CompleteKeyList.IndexOf(LowerCase('GAME/NUMPLAYERS'));
  if i = -1 then raise Exception.Create('Corrupt script file!');
  KeyValueList[i] := IntToStr(NewNum);
end;

procedure TScript.AddOrChangeKeyValue(completeKey: String; value: String);
var
  i: Integer;
begin
  i := CompleteKeyList.IndexOf(LowerCase(completeKey));
  if i > -1 then
    KeyValueList[i] := value
  else
  begin
    CompleteKeyList.Add(LowerCase(completeKey));
    KeyValueList.Add(value);
  end;
end;

procedure TScript.RemoveKey(completeKey: String);
var
  i: Integer;
  subKeys: TStrings;
begin
  i := CompleteKeyList.IndexOf(LowerCase(completeKey));
  if i>-1 then
  begin
    CompleteKeyList.Delete(i);
    KeyValueList.Delete(i);
  end
  else
  begin
    subKeys := GetSubKeys(completeKey);
    for i:=0 to subKeys.Count-1 do
      RemoveKey(completeKey + '/' + subKeys[i]);
  end;
  subKeys.Free;
end;

procedure TScript.TryToRemoveUDPSourcePort;
begin
  RemoveKey('GAME/SOURCEPORT');
end;

function TScript.isCorrupted: boolean;
begin
  Result := self.Corrupted;
end;

procedure TScript.ParseScript;
var
  currentCompleteKey: TStrings;
  lineScript: TStrings;
  lineWithoutTabs: String;
  i: integer;
  key: string;
  value: string;
begin
  currentCompleteKey := TStringList.Create;
  lineScript := TStringList.Create;
  Misc.ParseDelimited(lineScript,FScript,EOL,#$A);
  for i:=0 to lineScript.Count-1 do
  begin
    lineWithoutTabs := StringReplace(lineScript[i],#9,'',[rfReplaceAll]);
    if (lineWithoutTabs <> '') then
    begin
      if LeftStr(lineWithoutTabs,1) = '[' then // [KEY]
      begin
        key := MidStr(lineWithoutTabs,2,Pos(']',lineWithoutTabs)-2);
        currentCompleteKey.Add(key);
      end
      else if LeftStr(lineWithoutTabs,1) = '}' then
      begin
        currentCompleteKey.Delete(currentCompleteKey.Count-1);
      end
      else if (Length(lineWithoutTabs) > 4) and (currentCompleteKey.Count>0) then // key=value
      begin
        key := MidStr(lineWithoutTabs,1,Pos('=',lineWithoutTabs)-1);
        value := MidStr(lineWithoutTabs,Pos('=',lineWithoutTabs)+1,Pos(';',lineWithoutTabs)-Pos('=',lineWithoutTabs)-1);
        CompleteKeyList.Add(LowerCase(Misc.JoinStringList(currentCompleteKey,'/')+'/'+key));
        KeyValueList.Add(value);
      end;
    end;
  end;
  currentCompleteKey.Free;
  lineScript.Free;
end;

function TScript.GetSubKeys(completeKey: string):TStrings;
var
  i,j: Integer;
  sl1: TStrings;
  sl2: TStrings;
begin
  sl1 := ParseString(completeKey,'/');
  Result := TStringList.Create;
  for i:=0 to CompleteKeyList.Count -1 do
    if (Length(CompleteKeyList[i]) > Length(completeKey)) and ((LeftStr(CompleteKeyList[i],Length(completeKey)+1) = LowerCase(completeKey)+'/') or (completeKey = '')) then
    begin
      sl2 := ParseString(CompleteKeyList[i],'/');
      if Result.IndexOf(sl2[sl1.Count])=-1 then
          Result.Add(sl2[sl1.Count]);
    end;
  sl1.Free;
  sl2.Free;
end;

function TScript.GetBruteScript:String;// DEBUG METHOD
var
  i: integer;
begin
  // DEBUG METHOD
  for i:=0 to CompleteKeyList.Count-1 do
    Result := Result + CompleteKeyList[i]+'='+KeyValueList[i]+EOL;
end;

function TScript.GetScript:String;
var
  ScriptLines: TStrings;
  writtenKeys: TStrings;
begin
  ScriptLines := TStringList.Create;
  writtenKeys := TStringList.Create;
  WriteScriptKeys(ScriptLines,'',writtenKeys,False);
  Result := Misc.JoinStringList(ScriptLines,EOL);
  ScriptLines.Free;
  writtenKeys.Free;
end;

procedure TScript.WriteScriptKeys(f: TStrings; completeKey: String;writtenKeys: TStrings; headWrite: Boolean);
var
  sl1: TStrings;
  sl2: TStrings;
  i,j: Integer;
begin
  if (completeKey <> '') and (writtenKeys.IndexOf(LowerCase(completeKey)) > -1) then
    Exit;
  sl1 := GetSubKeys(completeKey);
  sl2 := ParseString(completeKey,'/');
  if sl1.Count = 0 then
  begin
    j := CompleteKeyList.IndexOf(LowerCase(completeKey));
    if j = -1 then
    begin
      sl1.Free;
      sl2.Free;
      Exit;
    end;
    f.Add(StrRepeat(#9,sl2.Count-1) + sl2[sl2.Count-1]+'='+KeyValueList[j]+';');
    writtenKeys.Add(LowerCase(completeKey));
  end
  else
  begin
    if headWrite then
    begin
      f.Add(StrRepeat(#9,sl2.Count-1) + '['+sl2[sl2.Count-1]+']');
      f.Add(StrRepeat(#9,sl2.Count-1) + '{');
    end;
    for i:=0 to sl1.Count-1 do
      if completeKey = '' then
        WriteScriptKeys(f,sl1[i],writtenKeys,True)
      else
        WriteScriptKeys(f,completeKey+'/'+sl1[i],writtenKeys,True);
    if headWrite then
      f.Add(StrRepeat(#9,sl2.Count-1) + '}');
    if completeKey <> '' then
      writtenKeys.Add(LowerCase(completeKey));
  end;
  sl1.Free;
  sl2.Free;
end;

function TScript.ReadKeyValue(completeKey: string):String;
var
  i: integer;
begin
  Result := '';
  i := CompleteKeyList.IndexOf(LowerCase(completeKey));
  if i >-1 then
    Result := KeyValueList[i];
end;

{ TMyTabSheet }

constructor TMyTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Clients := TList.Create;
  History := TWideStringList.Create;
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
  CE : TTntRichEdit;
begin
  if (Msg.Msg = WM_NOTIFY) then
  begin
    if (PNMHDR(Msg.lParam).code = EN_LINK) then
    begin
      p := TENLink(Pointer(TWMNotify(Msg).NMHdr)^);
      if (p.Msg = WM_LBUTTONDOWN) then
      begin
        try
          CE := TTntRichEdit(Self.Controls[1] as TTntRichEdit);
          SendMessage(CE.Handle, EM_EXSETSEL, 0, Longint(@(p.chrg)));
          sURL := CE.SelText;
          Misc.OpenURLInDefaultBrowser(sURL);
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

  try
    if FileExists(Application.ExeName + '.old') then
      DeleteFile(Application.ExeName + '.old');
  except
    // nothing
  end;

  FilterGroup.Height := 0;
  Filters.TextFilters := TList.Create;
  LoadFiltersFromFile;
  UpdateFilters;

  Randomize;
  Application.UpdateFormatSettings := False; // so that DecimalSeparator doesn't get changed by WM_WININICHANGE message. See http://coding.derkeiler.com/Archive/Delphi/borland.public.delphi.language.objectpascal/2003-11/0223.html
  DecimalSeparator := '.';
  MainForm.Caption := PROGRAM_VERSION;
  MainTitleBar.Caption := PROGRAM_VERSION;
  Application.Title := 'TASClient';
  Application.HintHidePause := 10000;
  Application.ShowHint := True;

  Debug.Enabled := False;
  Debug.Log := False;
  Debug.FilterPingPong := False;

  CommonFont := TFont.Create;
  CommonFont.Name := 'Fixedsys';
  CommonFont.Charset := DEFAULT_CHARSET;

  BattleClientsListFont := TFont.Create;
  BattleClientsListFont.Name := 'Arial';
  BattleClientsListFont.Style := [fsBold];
  BattleClientsListFont.Charset := DEFAULT_CHARSET;

  ClientsListBox.DoubleBuffered := True;

  FixFormSizeConstraints(MainForm);

  KAT := TKeepAliveThread.Create(False);

  SplashScreenForm.UpdateText('initializing unitsync.dll ...');
  if not Utility.InitLib then
  begin
    MessageDlg('Error initializing unitsync.dll!', mtError, [mbOK], 0);
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

  ClientGroups := TList.Create;

  Status.ConnectionState := Disconnected;
  Status.Registering := False;

  AddTabWindow(LOCAL_TAB, True);

  Battles := TList.Create;

  Utility.ReloadModList;

  if ModList.Count = 0 then
  begin
    KeepAliveTimer.Enabled := False;
    MessageDlg('No mods found! Terminating program ...', mtError, [mbOK], 0);
    Application.Terminate;
  end;

  ReceiveBuffer := '';

  Status.AwayTime := GetTickCount;
  Status.AmIInGame := False;

  Status.MyCPU := Misc.GetCPUSpeed;
  Status.CurrentMsgID := 0;

  MyInternetIp := '';

  ReplayList := TList.Create;

  for i := 0 to SortPopupMenu.Items.Count-1 do with SortPopupMenu do
  begin
    Items[i].Tag := i;
    Items[i].RadioItem := True;
    Items[i].OnClick := SortMenuItemClick;
  end;
  SortPopupMenu.Items[0].Checked := True;

  InitializeFlagBitmaps;

  ReceivedAgreement := TStringList.Create;

  Pings := TList.Create;

  MuteListForms := TList.Create;

  LadderList := TList.Create;

  FindIPQueueList := TStringList.Create;

  // we have to set the splash screen title bar back to what it was before (since we changed it in OnFormCreate event):
  SplashScreenForm.UpdateText('creating forms ...'); // main form will change the update text, that is why we change it back again

  // finally move to post-initialization (will happen once all other forms have been created too):
  PostMessage(Handle, WM_AFTERCREATE, 0, 0);
end;

procedure TMainForm.WMAfterCreate(var AMsg: TMessage); // responds to WM_AFTERCREATE message. We will do some post-initialization here
var
  mask: Word;
begin
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
    IgnoreListForm.LoadIgnoreListFromFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\ignorelist.dat');

    // we must apply themetype and theme now and not before, since some forms
    // or controls may yet not have been created earlier:
    PreferencesForm.ApplyCurrentThemeType;
    PreferencesForm.ApplyCurrentTheme;

    ClientsListBox.Font.Assign(CommonFont);
    BattleForm.ChatRichEdit.Font.Assign(CommonFont);
    BattleForm.InputEdit.Font.Assign(CommonFont);

    LoadGroups;
    LoadAwayMessages;

    // populate ColorImageList:
    UpdateColorImageList;

    // set focus to TEdit control (we need to do this only once for 1 page only, and TEdit control will always receive focus with any new page):
//*****    (PageControl1.ActivePage.Controls[0] as TEdit).SetFocus;

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

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + ONLINE_CACHE_FOLDER) then
    begin
      MessageDlg('Program has detected that "' + ONLINE_CACHE_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + ONLINE_CACHE_FOLDER) then
      begin
        MessageDlg('Unable to create directory. Program will now exit ...', mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER) then
    begin
      MessageDlg('Program has detected that "' + MAPS_CACHE_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER) then
      begin
        MessageDlg('Unable to create directory. Program will now exit ...', mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + MODS_CACHE_FOLDER) then
    begin
      MessageDlg('Program has detected that "' + MODS_CACHE_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + MODS_CACHE_FOLDER) then
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

    SplashScreenForm.UpdateText('loading maps ...');

    // lod map list in battle form and select some map (WARNING: this must be done AFTER you check if cache folder exists!):
    Utility.ReloadMapList(True);
    SplashScreenForm.UpdateText('finalizing ...');
    if Utility.MapList.IndexOf(Preferences.LastOpenMap) = -1 then
      BattleForm.ChangeMap(0) // load first map in the list
    else BattleForm.ChangeMap(Utility.MapList.IndexOf(Preferences.LastOpenMap)); // restore last open map

    // finally apply post-initialization preferences:
    PreferencesForm.ApplyPostInitializationPreferences;

    // hide splash screen:
    SplashScreenForm.Close;
    FreeAndNil(SplashScreenForm);

    // cache all minimaps if user chooses to do so:
    if not MapListForm.AreAllMinimapsLoaded then
      //if MessageDlg('Program has detected that one or more maps in your "maps" folder don''t have minimaps cached yet. Would you like to cache them now? (note: this process may take several minutes depending on the number of non-cached maps)', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        MapListForm.LoadAllMissingMinimaps;

    SearchFormPopupMenu.PopupForm := SearchForm;

    if Preferences.ConnectOnStartup then PostMessage(MainForm.Handle, WM_CONNECT, 0, 0);

    OnlineMapsUnit.TReadCacheThrd.Create(False); // start reading online maps from cache
    ReplaysUnit.TReadReplaysThrd.Create(False); // start reading replays from disk

    // reenable auto URL detection for $local because it's doesn't work the first time
    mask := SendMessage(((PageControl1.Pages[0] as TMyTabSheet).Controls[1] as TTntRichEdit).Handle, EM_GETEVENTMASK, 0, 0);
    SendMessage(((PageControl1.Pages[0] as TMyTabSheet).Controls[1] as TTntRichEdit).Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
    SendMessage(((PageControl1.Pages[0] as TMyTabSheet).Controls[1] as TTntRichEdit).Handle, EM_AUTOURLDETECT, Integer(True), 0);

    ReplaysForm.LoadReplayFiltersFromFile;
    ReplaysForm.UpdateReplayFilters;

    // finally:
    MainForm.Visible := True;

    // check new version
    if Preferences.CheckForNewVersion then
      CheckNewVersion;
   end;
end;

procedure TMainForm.UpdateColorImageList;
var
  i: Integer;
  bmp: TBitmap;
  TransparentColor: TColor;

begin
  ColorImageList.Clear;

  for i := 0 to High(TeamColors) do // first n images correspond to first n colors, using a circle shape to represent the color
  begin
    bmp := TBitmap.Create;
    bmp.Width := 16;
    bmp.Height := 16;

    with bmp.Canvas do
    begin
      if TeamColors[i] = clBlack then TransparentColor := clWhite else TransparentColor := clBlack;
      Brush.Color := TransparentColor;
      Pen.Color := TransparentColor;
      Rectangle(0, 0, 16, 16);

      Brush.Color := TeamColors[i];
      Pen.Color := clGray;
      Ellipse(2, 2, 13, 13);
    end;

    ColorImageList.AddMasked(bmp, TransparentColor);

    bmp.Free;
  end;
  for i := 0 to High(TeamColors) do // next n images correspond to first n colors, using a square shape to represent the color
  begin
    bmp := TBitmap.Create;
    bmp.Width := 16;
    bmp.Height := 16;

    with bmp.Canvas do
    begin
      if TeamColors[i] = clBlack then TransparentColor := clWhite else TransparentColor := clBlack;
      Brush.Color := TransparentColor;
      Pen.Color := TransparentColor;
      Rectangle(0, 0, 16, 16);

      Brush.Color := TeamColors[i];
      Pen.Color := clGray;
      RoundRect(1, 1, 14, 14, 4, 4);
    end;

    ColorImageList.AddMasked(bmp, TransparentColor);

    bmp.Free;
  end;

end;

{ ChatTextPos is a position in the line where chat text begins. We need this when we are searching for keywords to highlight
  and we (for example) don't want to highlight nicknames in "<xyz>" part of the line, but only after that part (keywords will
  get highlighted only in chat part of the text, not the header). If you don't specify ChatTextPos parameter, it is assumed
  that the entire line is the chat text. }
procedure TMainForm.AddTextToChatWindow(Chat: TMyTabSheet; Text: WideString; Color: TColor; ChatTextPos: Integer);
var
  re: TTntRichEdit;
  s: WideString;
begin
  re := Chat.Controls[1] as TTntRichEdit;
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

procedure TMainForm.AddTextToChatWindow(Chat: TMyTabSheet; Text: WideString; Color: TColor);
begin
  AddTextToChatWindow(Chat, Text, Color, 1);
end;

procedure TMainForm.AddMainLog(Text: WideString; Color: TColor);
begin
  AddTextToChatWindow(PageControl1.Pages[0] as TMyTabSheet, Text, Color);
end;

procedure TMainForm.AddMainLog(Text: WideString; Color: TColor; AmbiguousCommandID: Integer);
begin
  AddMainLog(Text + ' [#' + IntToStr(AmbiguousCommandID) + ']', Color);
end;

// SetFocus: if True, then switch focus to this new TAB and update
function TMainForm.AddTabWindow(Caption: string; SetFocus: Boolean): Integer;
var
  tmpts: TMyTabSheet;
  tmpre: TTntRichEdit;
  tmped: TSpTBXEdit;
  mask: Word;
  FileName: string;
begin
  Result := -1;

  tmpts := TMyTabSheet.Create(PageControl1);

  tmpts.Caption := Caption;

  tmped := TSpTBXEdit.Create(tmpts);
  tmped.Parent := tmpts;
  tmped.Name := 'InputEdit'; // don't change this name! (there are some references to it in the code)
  tmped.Text := '';
  tmped.OnKeyPress := InputEditKeyPress;
  tmped.OnKeyDown := InputEditKeyDown;
  tmped.OnClick := InputEditClick;
  tmped.Font.Assign(CommonFont);
  tmped.Align := alBottom;

  tmpts.PageControl := PageControl1;

  tmpre := TTntRichEdit.Create(tmpts);
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
  tmpre.OnMouseDown := RichEditMouseDown;
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
  if SetFocus then
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
procedure TMainForm.ProcessCommand(s: WideString; CameFromBattleScreen: Boolean);
var
  sl: TWideStringList;
  p: Pointer;
  i: Integer;
  tmp: WideString;
  duration: Integer; // temp var
  res: Integer;
  str: WideString;
  pinginfo: PPingInfo;
begin

  if s = '' then Exit;
  sl := ParseString(s, ' ');
  sl[0] := UpperCase(sl[0]);

  try
    if sl[0] = 'CONNECT' then TryToConnect
    else if (sl[0] = 'QUIT') and (sl.Count=1) then MainForm.Close
    else if (sl[0] = 'QUIT') and (sl.Count>1) then
    begin
      TryToSendCommand('EXIT', MakeSentenceWS(sl,1));
      Sleep(1000);
      MainForm.Close;
    end
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

      if sl.Count = 2 then tmp := '' else tmp := ' ' + MakeSentenceWS(sl, 2);
      TryToSendCommand('JOIN', LowerCase(Copy(sl[1], 2, Length(sl[1])-1)) + tmp);
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
      TryToSendCommand('CHANNELS');
    end
    else if (sl[0] = 'ME') then
    begin
      if CameFromBattleScreen then TryToSendCommand('SAYBATTLEEX', MakeSentenceWS(sl, 1))
      else if PageControl1.ActivePage.Caption[1] = '#' then // a channel tab
        TryToSendCommand('SAYEX', Copy(PageControl1.ActivePage.Caption, 2, Length(PageControl1.ActivePage.Caption)-1) + ' ' + MakeSentenceWS(sl, 1));
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

      TryToSendCommand('RING', sl[1]);
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

      TryToSendCommand('UPTIME');
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

      MainForm.TryToSendCommand('KICKFROMBATTLE', sl[1]);
    end
    else if (sl[0] = 'KICK') and (not CameFromBattleScreen) then
    begin
      if (sl.Count < 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      if sl.Count > 2 then tmp := ' ' + MakeSentenceWS(sl, 2)
      else tmp := '';

      if MainForm.GetClient(sl[1]) = nil then
      begin
        MessageDlg('Invalid KICK command. User does not exist! (Note: all names are case-sensitive)', mtWarning, [mbOK], 0);
        Exit;
      end;

      MainForm.TryToSendCommand('KICKUSER', sl[1] + tmp);
    end
    else if (sl[0] = 'RENAME') then
    begin
      if not (sl.Count = 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      AddMainLog('Requesting account rename from the server ...', Colors.Info);
      MainForm.TryToSendCommand('RENAMEACCOUNT', sl[1]);
    end
    else if (sl[0] = 'PASSWORD') then
    begin
      if not (sl.Count = 3) then
      begin
        AddMainLog('Denied: This command requires exactly 2 arguments (old and new passwords)!', Colors.Error);
        Exit;
      end;

      if (not VerifyName(sl[2])) then
      begin
        AddMainLog('Invalid password! Make sure your password consists only of legal characters.', Colors.Error);
        Exit;
      end;

      AddMainLog('Trying to change password ...', Colors.Info);
      MainForm.TryToSendCommand('CHANGEPASSWORD', Misc.GetMD5Hash(sl[1]) + ' ' + Misc.GetMD5Hash(sl[2]));
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

      TryToSendCommand('CHANNELTOPIC', Copy(sl[1], 2, Length(sl[1])-1) + ' ' + MakeSentenceWS(sl, 2));
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

      TryToSendCommand('CHANNELMESSAGE', Copy(sl[1], 2, Length(sl[1])-1) + ' ' + MakeSentenceWS(sl, 2));
    end
    else if (sl[0] = 'INGAME') then
    begin
      str := MakeSentenceWS(sl, 1);
      if str = '' then MainForm.TryToSendCommand('GETINGAMETIME')
      else MainForm.TryToSendCommand('GETINGAMETIME', str);
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

      MainForm.TryToSendCommand('GETIP', sl[1]);
    end
    else if (sl[0] = 'FINDIP') then
    begin
      if (sl.Count < 2) then
      begin
        AddMainLog('Denied: Missing arguments!', Colors.Error);
        Exit;
      end;

      MainForm.TryToSendCommand('FINDIP', sl[1]);
    end
    else if (sl[0] = 'LASTLOGIN') then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      MainForm.TryToSendCommand('GETLASTLOGINTIME', sl[1]);
    end
    else if (sl[0] = 'LASTIP') then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog('Denied: This command requires exactly 1 argument!', Colors.Error);
        Exit;
      end;

      MainForm.TryToSendCommand('GETLASTIP', sl[1]);
    end
    else if (sl[0] = 'MUTE') then
    begin
      if (sl.Count < 3) then
      begin
        AddMainLog('Denied: Missing arguments!', Colors.Error);
        Exit;
      end;

      if (sl.Count > 3) and (UpperCase(sl[3]) <> 'IP') then
        try
          duration := StrToInt(sl[3]);
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

      if ((sl.Count > 3) and (UpperCase(sl[3]) = 'IP')) or ((sl.Count > 4) and (UpperCase(sl[4]) = 'IP')) then
        tmp := ' ip' else tmp := '';
      TryToSendCommand('MUTE', Copy(sl[1], 2, Length(sl[1])-1) + ' ' + sl[2] + ' ' + IntToStr(duration) + tmp);
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

      TryToSendCommand('UNMUTE', Copy(sl[1], 2, Length(sl[1])-1) + ' ' + sl[2]);
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

      TryToSendCommand('MUTELIST', Copy(sl[1], 2, Length(sl[1])-1));
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

      MainForm.AddMainLog(GetMD5Hash(MakeSentenceWS(sl, 1)), Colors.Info);
    end
    else if (sl[0] = 'TESTCRASH') then
    begin
      GetMem(p, 10);
      FreeMem(p);
      FreeMem(p);
    end
    else if (sl[0] = 'TESTFLOOD') then
    begin
      for i := 0 to 500 do TryToSendCommand('bla bla bla bla bla bla bla bla bla bla bla bla');
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
      New(pinginfo);
      pinginfo.Key := TryToSendCommand('PING', True);
      pinginfo.TimeSent := GetTickCount;
      Pings.Add(pinginfo);

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

      TryToSendCommand('SAYPRIVATE', sl[1] + ' ' + MakeSentenceWS(sl, 2));
    end
    else if (sl[0] = 'HOOK') then
    begin
      if sl.Count > 2 then
      begin
        AddMainLog('Error: Too many arguments!', Colors.Error);
        Exit;
      end;
      if(sl.Count = 2) then
        TryToSendCommand('HOOK', sl[1])
      else
        TryToSendCommand('HOOK')
    end
    else if (sl[0] = 'IGNORE') then
    begin
      if sl.Count = 1 then
      begin
        IgnoreListForm.ShowModal;
      end
      else
      begin
        tmp := MakeSentenceWS(sl, 1);

        if MainForm.GetClient(tmp) = nil then
        begin
          if MessageDlg('User <' + tmp + '> is not online, do you wish to add him to ignore list anyway?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            IgnoreListForm.AddToIgnoreList(tmp);
            IgnoreListForm.ShowModal;
          end;
        end
        else
        begin
          IgnoreListForm.AddToIgnoreList(tmp);
          IgnoreListForm.ShowModal;
        end;
      end;
    end
    else AddMainLog('Unknown command!', Colors.Error);

  finally
    if sl <> nil then sl.Free;
  end;

end;


procedure TMainForm.ProcessRemoteCommand(s: WideString); // processes command received from server
var
  sl: TWideStringList;
  sl2: TWideStringList; // temp.
  sl3: TStringList; // temp.
  MsgID: Integer;
  i, j, k, l, m, n, o, p, r, t: Integer;
  BattleIndex: Integer;
  Battle: TBattle;
  Client: TClient;
  Bot: TBot;
  tmp, tmp2, hash, url: WideString;
  tmpInt, tmpInt2, tmpInt3,tmpInt4: Integer;
  tmpBool: Boolean;
  changed: Boolean;
  count: Integer;
  tmpi64: Int64;
  rect: TRect;
  index: Integer;
  battletype, nattype: Integer;
  ms: TMemoryStream;
  team, ally, color, teamcolor: Integer;
  mapitem: TMapItem;
  maphash: Integer;
  oldMapHash: integer;
  oldVisible: Boolean;
  LadderListThread : TLadderListThread;
  LMThread : TLadderMapThread;
  CheckPasswordThread : TLadderCheckAccountThread;
  Ladder : ^TLadder;
  RenameThread : TLadderRenameAccountThread;
  luaOpt: TLuaOption;
  cTmp: TColor;
begin
  if s = '' then Exit;
  sl := ParseString(s, ' ');
  if sl[0][1] = '#' then // message ID is present. Lets extract it!
  begin
    try
      MsgID := StrToInt(Copy( sl[0], 2, Length(sl[0])));
    except // this should really not happen - it means that server is misconfigured/malfunctioning!
      AddMainLog('Error: invalid message ID. Ignoring command ...', Colors.Error);
      Exit;
    end;
    sl.Delete(0);
  end
  else MsgID := -1; // no msg ID
  sl[0] := UpperCase(sl[0]); // uppercase the command, but not the arguments

  try // try..finally
    ProcessingRemoteCommand := True;

    if sl[0] = 'TASSERVER' then
    begin
      if (sl.Count <> 5) or (not Debug.IgnoreVersionIncompatibility and not CheckServerVersion(sl[1])) then
      begin
        if Debug.IgnoreVersionIncompatibility then
          AddMainLog('Parsing TASSERVER command failed !', Colors.Error);
        AddMainLog('Server version (' + IFF(sl.Count > 1, sl[1], '[unknown]') + ') is not supported with this client!', Colors.Info);
        AddMainLog('Requesting update from server ...', Colors.Info);
        TryToSendCommand('REQUESTUPDATEFILE', 'TASClient ' + VERSION_NUMBER); // we ask server if he has an update for us
        Exit;
      end;

      if (sl[2] <> '*') and (sl[2] <> Status.MySpringVersion) and (not Debug.IgnoreVersionIncompatibility) then
      begin
        AddMainLog('Server says our Spring version (' + Status.MySpringVersion + ') is outdated (server only supports ' + sl[2] + ')', Colors.Info);
        AddMainLog('Requesting update from server ...', Colors.Info);
        TryToSendCommand('REQUESTUPDATEFILE', 'Spring ' + Status.MySpringVersion); // we ask server if he has an update for us
        Exit;
      end;

      try
        Status.NATHelpServerPort := StrToInt(sl[3]);
        Status.ServerMode := 0;
        Status.ServerMode := StrToInt(sl[4]);
      except
        AddMainLog('This server version is not supported with this client!', Colors.Info);
        AddMainLog('Requesting update from server ...', Colors.Info);
        TryToSendCommand('REQUESTUPDATEFILE', 'TASClient ' + VERSION_NUMBER); // we ask server if he has an update for us
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
        ReceivedAgreement.Add(MakeSentenceWS(sl, 1));
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
      if sl.Count = 1 then tmp := 'Unknown reason' else tmp := MakeSentenceWS(sl, 1);
      MessageDlg('Error logging to server: ' + tmp, mtWarning, [mbOK], 0);
      AddMainLog('Login failed: ' + tmp, Colors.Error);
      TryToDisconnect;
    end
    else if sl[0] = 'ACCEPTED' then
    begin
      ConnectButton.ImageIndex := 2;
      AddMainLog('Login successful!', Colors.Info);
      MainForm.MainTitleBar.Caption := PROGRAM_VERSION+' - '+sl[1];
      MainForm.Caption := PROGRAM_VERSION+' - '+sl[1];
      Status.LoggedIn := True;
      Status.ReceivingLoginInfo := True;
      if sl.Count > 1 then Status.Username := sl[1]; // this should always evaluate to TRUE
      if not Preferences.DisableAllSounds then PlayResSound('connect');

      if Preferences.JoinMainChannel then ProcessCommand('JOIN #main', False); // try to join #main immediately after user has been logged in
      PerformForm.PerformCommands;

      // display "login in progress" window:
      Misc.CenterFormOverAnotherForm(LoginProgressForm, MainForm); // center the login form first
      LoginProgressForm.Show;
    end
    else if sl[0] = 'LOGININFOEND' then
    begin
      Status.ReceivingLoginInfo := False;
      LoginProgressForm.Hide;
      // we must do some graphical updating now since we ignored it while receiving login info (to speed the login process):
      SortClientsList(AllClients,Preferences.SortStyle);
      for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
        SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);
      UpdateClientsListBox;
      VDTBattles.Invalidate;
      LadderCupsRefreshTimer(nil);
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
      begin
        AddMainLog('Registration failed: ' + MakeSentenceWS(sl, 1), Colors.Error);
        MessageDlg('Registration failed: ' + MakeSentenceWS(sl, 1), mtWarning, [mbOK], 0);
      end
      else
      begin
        AddMainLog('Registration failed: Unknown reason', Colors.Error);
        MessageDlg('Registration failed for unknown reason! Try using different username/password, if it still fails then please contact ' + LobbyMailAddress, mtWarning, [mbOK], 0);
      end;

      Status.Registering := False;
      TryToDisconnect;
    end
    else if sl[0] = 'MOTD' then
    begin
      if sl.Count < 2 then
      AddMainLog('-', Colors.MOTD)
      else
      AddMainLog('- ' + MakeSentenceWS(sl, 1), Colors.MOTD);

      if (Status.ReceivingLoginInfo) and (Status.LastCommandReceived = 'ACCEPTED') then LoginProgressForm.UpdateCaption('Receiving MOTD ...');
    end
    else if sl[0] = 'JOINFAILED' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 1);
      end
      else
      begin
        AddMainLog('Unable to join channel #' + sl[1] + ' (' + MakeSentenceWS(sl, 2) + ')', Colors.Info);
      end;
    end
    else if sl[0] = 'OFFERFILE' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 2);
        Exit;
      end;

      sl2 := ParseString(MakeSentenceWS(sl, 2), #9);
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
    else if sl[0] = 'CLIENTIPPORT' then
    begin
      if sl.Count <> 4 then
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
        Client.PublicPort := StrToInt(sl[3]);
        Client.IP := sl[2];
        if (Client.PublicPort = 0) and (BattleForm.IsBattleActive) then
          BattleForm.AddTextToChat('Warning : '+Client.Name+' doesn''t support NAT Traversal.',Colors.Error,1);
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
      if sl.Count <> 4 then
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

      AddClientToAllClientsList(sl[1], 0, LowerCase(sl[2]), tmpint); // server will update client's status later
      if sl[1] = Status.Username then Status.Me := GetClient(Status.Username);

      if (PageControl1.ActivePage.Caption = LOCAL_TAB) and (not Status.ReceivingLoginInfo) then UpdateClientsListBox;

      if not Status.ReceivingLoginInfo and (TClient(GetClient(sl[1])).GetGroup >= 0) and TClientGroup(ClientGroups[TClient(GetClient(sl[1])).GetGroup]).NotifyOnConnect then
        AddNotification('Player connection', '<' + sl[1] + '> has joined the server.', 2000);

      i := GetTabWindowPageIndex(sl[1]);
      if i <> -1 then
      begin
        if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]) then ; // nevermind, just ignore it
        if (PageControl1.ActivePage.Caption = sl[1]) and (not Status.ReceivingLoginInfo) then UpdateClientsListBox;
      end;

      if (Status.ReceivingLoginInfo) and (Status.LastCommandReceived = 'MOTD') then LoginProgressForm.UpdateCaption('Receiving user list ...');
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
      if i <> -1 then
      begin
        RemoveClientFromTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]);
        AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet,sl[1]+' has left the server.',Colors.ChanLeft);
      end;

      if not RemoveClientFromAllClientsList(sl[1]) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 9);
      end;

      if sl[1] = Status.Username then Status.Me := nil;

      UpdateClientsListBox;
    end
    else if sl[0] = 'ADDBOT' then
    begin
      if sl.Count < 7 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error, 10);
        Exit;
      end;

      try
        tmpint := StrToInt(sl[1]);
        tmpint2 := StrToInt(sl[4]);
        teamcolor := StrToInt(sl[5]);
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
        TryToSendCommand('LEAVEBATTLE');
        Exit;
      end;

      Bot := TBot.Create(sl[2], sl[3], MakeSentenceWS(sl, 6));
      Bot.BattleStatus := tmpInt2;
      Bot.TeamColor := teamcolor;

      Battle.Bots.Add(Bot);
      if Battle.Visible then
        VDTBattles.InvalidateNode(Battle.Node);

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,False);
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
      if Battle.Visible then
        VDTBattles.InvalidateNode(Battle.Node);

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
          BattleForm.UpdateClientsListBox;
        end;

    end
    else if sl[0] = 'UPDATEBOT' then
    begin
      if sl.Count <> 5 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        tmpint2 := StrToInt(sl[1]);
        tmpint := StrToInt(sl[3]);
        teamcolor := StrToInt(sl[4]);
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
        TryToSendCommand('LEAVEBATTLE');
        Exit;
      end;

      Bot := GetBot(sl[2], Battle);
      if Bot = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Bot.BattleStatus := tmpInt;
      Bot.TeamColor := teamcolor;

      BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
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

      if (index < 0) or (index > High(BattleState.StartRects)) then
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

      if (index < 0) or (index > High(BattleState.StartRects)) then
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
        if i = -1 then i := AddTabWindow('#' + sl[1], True)
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
      if sl.Count > 4 then tmp := '  (' + MakeSentenceWS(sl, 3) + ')'
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
        if sl.Count > 3 then tmp := ' (' + MakeSentenceWS(sl, 3) + ')';
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

      if sl.Count = 3 then tmp := '' else tmp := ' (' + MakeSentenceWS(sl, 3) + ')';
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
      tmp2 := MakeSentenceWS(sl, 4);

      sl2 := TWideStringList.Create;
      Misc.ParseDelimited(sl2,tmp2,'\n','');

      if sl2.Count = 1 then
        AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Topic is ''' + tmp2 + '''', Colors.Topic)
      else
      begin
        AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Topic is ''' + sl2[0], Colors.Topic);
        for j:=1 to sl2.Count-1 do
          if j=sl2.Count-1 then
            AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, sl2[j] + '''', Colors.Topic)
          else
            AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, sl2[j], Colors.Topic);
      end;
      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Set by ' + sl[2] + ' on ' + tmp, Colors.Topic);
    end
    else if sl[0] = 'SAID' then
    begin
      if sl.Count < 4 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      // are we ignoring this user?
      if Preferences.UseIgnoreList then
        if IgnoreListForm.IgnoringUser(sl[2]) then Exit; // don't display the message

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Client := GetClient(sl[2]);

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + Client.Name + '> ' + MakeSentenceWS(sl, 3), Client.GetChatTextColor, Length(sl[2])+2);
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

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Channel message: ' + MakeSentenceWS(sl, 2), Colors.Info);
    end
    else if sl[0] = 'SAIDEX' then
    begin
      if sl.Count < 4 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      // are we ignoring this user?
      if Preferences.UseIgnoreList then
        if IgnoreListForm.IgnoringUser(sl[2]) then Exit; // don't display the message

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* ' + sl[2] + ' ' + MakeSentenceWS(sl, 3), Colors.SayEx);
    end
    else if sl[0] = 'SAIDPRIVATE' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      // are we ignoring this user?
      if Preferences.UseIgnoreList then
        if IgnoreListForm.IgnoringUser(sl[1]) then Exit; // don't display the message

      i := GetTabWindowPageIndex(sl[1]);
      if i = -1 then
      begin
        i := AddTabWindow(sl[1], Preferences.AutoFocusOnPM);
        if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]) then
        begin
          AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
          Exit;
        end;
        UpdateClientsListBox;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + sl[1] + '> ' + MakeSentenceWS(sl, 2), Colors.Normal, Length(sl[1])+2);

      // auto replay away message
      Client := GetClient(sl[1]);
      if not Client.AwayMessageSent and Status.Me.GetAwayStatus then begin
        TryToSendCommand('SAYPRIVATE', sl[1] + ' <AUTO-REPLY> : ' + StringReplace(Status.CurrentAwayMessage,'$t',IntToStr(Round((GetTickCount-Status.AwayTime)/60000)),[rfReplaceAll]));
        Client.AwayMessageSent := True;
      end;

      if not Application.Active then FlashWindow(MainForm.Handle, true);

      // add notification if private message and if application isn't focused:
      if (not Application.Active) and (NotificationsForm.CheckBox1.Checked) then AddNotification('Private message', '<' + sl[1] + '> ' + MakeSentenceWS(sl, 2), 2500);
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
        i := AddTabWindow(sl[1], Preferences.AutoFocusOnPM);
        if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]) then
        begin
          AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
          Exit;
        end;
        UpdateClientsListBox;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + Status.Username + '> ' + MakeSentenceWS(sl, 2), Colors.MyText, Length(Status.Username)+2);
    end
    else if sl[0] = 'PONG' then
    begin
      if MsgID <> -1 then
        for i := 0 to Pings.Count-1 do if PPingInfo(Pings[i]).Key = MsgID then
        begin
          AddMainLog('Ping reply took ' + IntToStr(GetTickCount - PPingInfo(Pings[i]).TimeSent) + ' ms.', Colors.Info);
          Pings.Delete(i);
          Break;
        end;
    end
    else if sl[0] = 'SAIDBATTLE' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      Client := GetClient(sl[1]);

      BattleForm.AddTextToChat('<' + Client.Name + '> ' + MakeSentenceWS(sl, 2), Client.GetChatTextColor, Length(sl[1])+2);
    end
    else if sl[0] = 'SAIDBATTLEEX' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BattleForm.AddTextToChat('* ' + sl[1] + ' ' + MakeSentenceWS(sl, 2), Colors.SayEx, 1);
    end
    else if sl[0] = 'REQUESTBATTLESTATUS' then
    begin
      if sl.Count <> 1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not BattleForm.FigureOutBestPossibleTeamAllyAndColor(True, team, ally, color) then
      begin
        BattleForm.SetMyBattleStatus(0, False, 0, 0, 0); // this probably shouldn't of happen though
        MyTeamColorIndex := 0;
      end
      else
      begin
        BattleForm.SetMyBattleStatus(BattleForm.MySideButton.Tag, False, team, ally, 1);
//        MyTeamColorIndex := color;   -> not needed anymore, we should keep last used color anyway
      end;

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
      if sl.Count <> 3 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if BattleForm.IsBattleActive then // we are already in battle! (this can't really happen)
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        MainForm.TryToSendCommand('LEAVEBATTLE');
        BattleForm.ResetBattleScreen;
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
        t := StrToInt(sl[2]);

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

        // we have to change mod before hashing it:
        Status.Hashing := True; // we need this so that we know we must wait for hashing to finish when we receive REQUESTBATTLESTATUS command (we can receive it in "parallel", while hashing!)
        InitWaitForm.ChangeCaption(MSG_MODCHANGE);
        InitWaitForm.TakeAction := 0; // change mod
        InitWaitForm.ChangeToMod := Battle.ModName;
        InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)
        Status.Synced := GetModHash(Battle.ModName) = Battle.HashCode;
        Status.Hashing := False;

        if Status.BattleStatusRequestReceived and not Status.BattleStatusRequestSent then
        begin
          BattleForm.SendMyBattleStatusToServer;
          Status.BattleStatusRequestSent := True;
        end; // else the method which will receive the request will also send the battle status

        BattleState.LadderIndex := -1;
        if Battle.IsLadderBattle then
        begin
          CheckPasswordThread := TLadderCheckAccountThread.Create(False,Preferences.LadderPassword,true);
          if Battle.GetLadderId = -1 then
            AddMainLog('Error: Battle ladder id not found.', Colors.Error)
          else
          begin
            for i:=0 to LadderList.Count -1 do
              if TLadder(LadderList[i]).id = Battle.GetLadderId then begin
                LadderListThread := TLadderListThread.Create(False,i,false);
                BattleState.LadderIndex := i;
                LMThread := TLadderMapThread.Create(False);
                break;
              end;
            if BattleState.LadderIndex = -1 then begin
              New(Ladder);
              Ladder^ := TLadder.Create(Battle.GetLadderId,'');
              LadderList.Add(Ladder^);
              LadderListThread := TLadderListThread.Create(False,LadderList.IndexOf(Ladder^),false);
              BattleState.LadderIndex := LadderList.IndexOf(Ladder^);
              LMThread := TLadderMapThread.Create(False);
              BattleForm.RefreshLadderRanks;
            end;
          end;
        end;

        BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
        BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
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
      if BattleState.TryingToJoinLadderBattle then
        MessageDlg('You are trying to join a battle with another ladder version, updating your lobby should fix that problem.',mtWarning,[mbOk],0);
      AddMainLog('Failed to join the battle (Reason: ' + MakeSentenceWS(sl, 1) + ')', Colors.Error);
    end
    else if sl[0] = 'OPENBATTLEFAILED' then
    begin
      tmp := 'Unknown error';
      if sl.Count > 1 then tmp := MakeSentenceWS(sl, 1);
      WaitForAckForm.OnCancelHosting(tmp);
    end
    else if sl[0] = 'BATTLEOPENED' then
    begin
      if sl.Count < 12 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      sl2 := ParseString(MakeSentenceWS(sl, 11), #9);

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
        maphash := StrToInt(sl[10]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;
      AddBattle(i, battletype, nattype, Client, tmp, j, k, tmpBool, l, maphash, sl2[0], sl2[1], sl2[2]);
      Battle := GetBattle(i);
      if Battle.visible then
        SortBattleInList(GetBattleIndex(i), Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0);
      if not Status.ReceivingLoginInfo then VDTBattles.Invalidate;

      Client.InBattle := True;
      if (not Application.Active) or (not BattleForm.Active) then if NotificationsForm.FindNotification(nfStatusInBattle, [Client.Name]) then AddNotification('Player opened new battle', '<' + Client.Name + '> is hosting new game.', 2000);

      if (Status.ReceivingLoginInfo = False) and (Client.Name <> Status.Username) then if
        NotificationsForm.FindNotification(nfModHosted, [Battle.ModName]) then AddNotification('Mod hosted', 'Mod <' + Battle.ModName + '> has been hosted by ' + TClient(Battle.Clients[0]).Name + '.', 2000);

      // re-sort all clients lists:
      if not Status.ReceivingLoginInfo then
        if Preferences.SortStyle = 2 then
          for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
            SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);

      if not Status.ReceivingLoginInfo then UpdateClientsListBox;

      if not Status.ReceivingLoginInfo and (Client.GetGroup > -1) and TClientGroup(ClientGroups[Client.GetGroup]).NotifyOnHost then begin
        AddNotification('Player host', '<' + Client.Name + '> is hosting a new battle.', 4000,true,Battle.ID);
      end;

      if (Status.ReceivingLoginInfo) and (Status.LastCommandReceived = 'ADDUSER') then LoginProgressForm.UpdateCaption('Receiving battle list ...');
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
        TryToSendCommand('LEAVEBATTLE');
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

      { Be careful: You shouldn't call any methods that call Application.ProcessMessages before
        calling HostBattle method, because OnSocketDataAvailable may get triggered and we may receive REQUESTBATTLESTATUS
        command before we even hosted - this would be an error. }

      // accept hosting:
      if Battle.BattleType = 0 then
        BattleForm.HostBattle(i)
      else
        BattleForm.HostBattleReplay(i);

      Status.Synced := True; // host is always synced with himself!
      WaitForAckForm.ModalResult := mrOK;
      BattleForm.RefreshLadderRanks;
      BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
      BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);

      BattleForm.SendBattleDetailsToServer;
      BattleForm.SendLuaOptionsDetailsToServer;
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
      if Battle.Visible then
        if battle.Node <> nil then begin
          VDTBattles.InvalidateNode(Battle.Node);
        end
        else
        begin
          VDTBattles.InvalidateNode(Battle.Node);
        end;

      Client.InBattle := True;

      Client.StatusRefreshed := False;

      if ((not Application.Active) or (not BattleForm.Active)) and not Status.ReceivingLoginInfo then
        if (not ((BattleForm.IsBattleActive) and (Battle.ID = BattleState.Battle.ID))) then
          if NotificationsForm.FindNotification(nfStatusInBattle, [Client.Name]) or ((Client.GetGroup > -1) and TClientGroup(ClientGroups[Client.GetGroup]).NotifyOnHost and (Battle.ID <> Status.Me.GetBattleId)) then
            AddNotification('Player joined battle', '<' + Client.Name + '> has joined ' + TClient(Battle.Clients[0]).Name + '''s battle.' , 4000,true,Battle.ID);


          //or (not ((BattleForm.IsBattleActive) and (Battle.ID = BattleState.Battle.ID)) and (Client.GetGroup > -1) and TClientGroup(ClientGroups[Client.GetGroup]).NotifyOnHost)

      // re-sort all clients lists:
      if Preferences.SortStyle = 2 then
        for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
          SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);

      UpdateClientsListBox;

      RefreshBattleList;
      //while RefreshingBattleList do;
      //SortBattleInList(i, Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0);

      VDTBattles.Invalidate;

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          BattleForm.AddTextToChat('* ' + Client.Name + ' has joined battle', Colors.ChanJoin, 1);
          BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,False);
          BattleForm.UpdateClientsListBox;
          if BattleState.Status = Hosting then
          begin
            if Misc.Contains(Client.Name,BattleState.BanList) then begin
              MainForm.TryToSendCommand('SAYBATTLEEX', '*** Banned player auto-kick ***');
              MainForm.TryToSendCommand('KICKFROMBATTLE', Client.Name);
            end
            else
            begin
              if (Client.GetRank < BattleState.Battle.RankLimit) and BattleState.AutoKickRankLimit then begin
                MainForm.TryToSendCommand('SAYBATTLEEX', '*** Rank limit auto-kick ***');
                MainForm.TryToSendCommand('KICKFROMBATTLE', Client.Name);
              end
              else
                if (Client.GetGroup > -1) and TClientGroup(ClientGroups[Client.GetGroup]).AutoKick then begin
                  MainForm.TryToSendCommand('SAYBATTLEEX', '*** Banned Group member auto-kick ***');
                  MainForm.TryToSendCommand('KICKFROMBATTLE', Client.Name);
                end;
            end;
            Inc(Battle.SpectatorCount); //*** test
            BattleForm.SendBattleInfoToServer;
            if (BattleFormUnit.BattleState.Battle.Description <> '(none)') and BattleState.AutoSendDescription then
              MainForm.TryToSendCommand('SAYBATTLEEX', '*** Description : '+BattleFormUnit.BattleState.Battle.Description+' ***');
          end;
          if not BattleForm.Active then
            if NotificationsForm.FindNotification(nfJoinedBattle, []) or ((BattleState.Status = Hosting) and NotificationsForm.FindNotification(nfJoinedMyHostedBattle, [])) then
              AddNotification('Player joined battle', '<' + Client.Name + '> has joined battle.', 2000);
          Client.CurrentLadderRank := -1;
          Client.CurrentLadderRating := -1;
          BattleForm.RefreshLadderRanks;
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
      if Battle.Visible then
        VDTBattles.InvalidateNode(Battle.Node);
      Client.InBattle := False;

      // re-sort all clients lists:
      if Preferences.SortStyle = 2 then
        for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
          SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);

      UpdateClientsListBox;

      //while RefreshingBattleList do;
      RefreshBattleList;

      VDTBattles.Invalidate;

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          BattleForm.AddTextToChat('* ' + Client.Name + ' has left battle', Colors.ChanJoin, 1);
          BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
          BattleForm.UpdateClientsListBox;
          BattleForm.RefreshTeamNbr;

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
          if Client = Status.Me then // this should normally not happen since we disconnect from the battle immediately after receiving FORCEQUITBATTLE command from the server
            BattleForm.ResetBattleScreen;
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

      if not Status.ReceivingLoginInfo then
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
          if isBattleVisible(Battles[i]) and TBattle(Battles[i]).Visible then
            SortBattleInList(i, Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0)
          else
          begin
            RefreshBattleList;
          end;
          if not Status.ReceivingLoginInfo then VDTBattles.Invalidate; // since multiple nodes could be moved when calling SortBattleInList
          Break;
        end;

      if Client.InBattle and BattleForm.IsBattleActive and (BattleState.Battle.Clients.IndexOf(Client) <> -1) then begin
        BattleForm.VDTBattleClients.Invalidate; // refresh battle client list, since client's status just changed (we could also just invalidate this client's node and not the entire list, but just to make sure)
        BattleForm.RefreshTeamNbr;
      end;

      if changed and not Client.GetInGameStatus and (Client.GetBattleId <> Status.Me.GetBattleId) and (Client.GetGroup > -1) and TClientGroup(ClientGroups[Client.GetGroup]).NotifyOnBattleEnd then
        AddNotification('Player battle end', '<' + Client.Name + '> has end his battle.', 2000);


      if Client.Name = Status.Username then Status.MyRank := Client.GetRank;

      if not Status.ReceivingLoginInfo then UpdateClientsListBox;

      if (Status.ReceivingLoginInfo) and ((Status.LastCommandReceived = 'UPDATEBATTLEINFO') or (Status.LastCommandReceived = 'JOINEDBATTLE')) then LoginProgressForm.UpdateCaption('Updating clients status list ...');
    end
    else if sl[0] = 'UPDATEBATTLEINFO' then
    begin
      if sl.Count < 5 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      try
        tmpInt := StrToInt(sl[1]);
        tmpInt2 := StrToInt(sl[2]);
        tmpBool := IntToBool(StrToInt(sl[3]));
        maphash := StrToInt(sl[4]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;
      while RefreshingBattleList do;
      Battle := GetBattle(tmpInt);
      if Battle = nil then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if (BattleForm.IsBattleActive) and (Battle.ID = BattleState.Battle.ID) then
        oldMapHash := BattleState.Battle.MapHash;

      Battle.Map := MakeSentenceWS(sl, 5);
      Battle.MapHash := maphash;
      Battle.SpectatorCount := tmpInt2;
      Battle.Locked := tmpBool;

      oldVisible := Battle.Visible;
      Battle.Visible := isBattleVisible(Battle);
      if Battle.Visible <> oldVisible then begin
        RefreshBattleList;
      end;

      if Battle.Visible then
        SortBattleInList(tmpInt, Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0);
      VDTBattles.Invalidate;

      if BattleForm.IsBattleActive then if Battle.ID = BattleState.Battle.ID then
      begin
        if BattleState.Status <> Hosting then BattleForm.LockedCheckBox.Checked := Battle.Locked;

        tmpInt := Utility.MapList.IndexOf(Battle.Map);
        if tmpInt = -1 then
        begin
          if BattleState.Status = Hosting then
          begin // this should NEVER happen!
            MessageDlg('Error: Map changed to unknown map! Please report this error!', mtError, [mbOK], 0);
            Application.Terminate;
            Exit;
          end
          else
          begin
            if Status.Me.GetReadyStatus then
            begin
              BattleForm.AmIReady := False;
            end;
          end;
          BattleForm.ChangeMapToNoMap(Battle.Map);
        end
        else
        begin
          if BattleState.Status <> Hosting then begin // no point in changing map again, we just did that
            BattleForm.ChangeMap(tmpInt);
          end
          else
          begin
            if oldMapHash <> maphash then begin
              BattleForm.mnuClearBoxesClick(BattleForm.mnuLoadBoxes);
              BattleForm.mnuLoadBoxesClick(BattleForm.mnuLoadBoxes);
            end;
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

      if (m < 0) or (m > 2) then
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
    else if sl[0] = 'REMOVESCRIPTTAGS' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;
      for i:=1 to sl.Count-1 do
      begin
        with BattleForm.UnknownScriptTagList do
        begin
          j := CompleteKeyList.IndexOf(LowerCase(sl[i]));
          if j = -1 then
          begin
            AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
            Exit;
          end;
          CompleteKeyList.Delete(j);
          ValueList.Delete(j);
        end;
      end;
    end
    else if sl[0] = 'SETSCRIPTTAGS' then
    begin
      sl2 := ParseString(MakeSentenceWS(sl,1),#9);

      if sl2.Count = 0 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;
      sl3 := TStringList.Create;
      for i:=0 to sl2.Count-1 do
      begin
        j := Pos('=',sl2[i]);
        tmp := LowerCase(LeftStr(sl2[i],j-1)); // key
        tmp2 := MidStr(sl2[i],j+1,MaxInt); // value

        Misc.ParseDelimited(sl3,tmp,'/','\');
        AllowBattleDetailsUpdate := False;
        if (sl3.Count = 3) and (sl3[0] = 'game') and ((sl3[1] = 'mapoptions') or (sl3[1] = 'modoptions')) then
        begin
          if sl3[1] = 'mapoptions' then
          begin
            luaOpt := BattleForm.GetLuaOption(BattleForm.MapOptionsList,sl3[2]);
            if (BattleForm.SpTBXTabControl1.ActivePage.Item.Name <> 'MapTab') and (BattleState.Status <> Hosting) then
            begin
              BattleForm.MapTab.FontSettings.Bold := tsTrue;
            end;
          end
          else
          begin
            luaOpt := BattleForm.GetLuaOption(BattleForm.ModOptionsList,sl3[2]);
            if (BattleForm.SpTBXTabControl1.ActivePage.Item.Name <> 'ModTab') and (BattleState.Status <> Hosting) then
            begin
              BattleForm.ModTab.FontSettings.Bold := tsTrue;
            end;
          end;

          if luaOpt <> nil then
            luaOpt.SetValue(tmp2)
          else
            BattleForm.ChangeScriptTagValue(Misc.JoinStringList(sl3,'/'),tmp2);
        end
        else
        try
          if (BattleForm.SpTBXTabControl1.ActivePage.Item.Name <> 'GameOptionsTab') and (BattleState.Status <> Hosting) then
          begin
            BattleForm.GameOptionsTab.FontSettings.Bold := tsTrue;
          end;
          if tmp = LowerCase('GAME/StartMetal') then
            BattleForm.MetalTracker.Value := StrToInt(tmp2)
          else if tmp = LowerCase('GAME/StartEnergy') then
            BattleForm.EnergyTracker.Value := StrToInt(tmp2)
          else if tmp = LowerCase('GAME/MaxUnits') then
            BattleForm.UnitsTracker.Value := StrToInt(tmp2)
          else if tmp = LowerCase('GAME/StartPosType') then
            BattleForm.StartPosRadioGroup.ItemIndex := StrToInt(tmp2)
          else if tmp = LowerCase('GAME/GameMode') then
            BattleForm.GameEndRadioGroup.ItemIndex := StrToInt(tmp2)
          else if tmp = LowerCase('GAME/LimitDGun') then
            BattleForm.LimitDGunCheckBox.Checked := StrToBool(tmp2)
          else if tmp = LowerCase('GAME/DiminishingMMs') then
            BattleForm.DiminishingMMsCheckBox.Checked := StrToBool(tmp2)
          else if tmp = LowerCase('GAME/GhostedBuildings') then
            BattleForm.GhostedBuildingsCheckBox.Checked := StrToBool(tmp2)
          else if tmp = LowerCase('GAME/IsGameSpeedLocked') then
            BattleForm.LockGameSpeedCheckBox.Checked := StrToBool(tmp2)
          else
            BattleForm.ChangeScriptTagValue(Misc.JoinStringList(sl3,'/'),tmp2);
        except
          AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
          BattleForm.DisconnectButtonClick(nil);
          //BattleForm.ChangeScriptTagValue(tmp,tmp2);
        end;
        AllowBattleDetailsUpdate := True;
      end;
    end
    else if sl[0] = 'CLIENTBATTLESTATUS' then
    begin
      if sl.Count <> 4 then
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

      try
        teamcolor := StrToInt(sl[3]);
      except
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      tmpInt2 := Client.GetMode;
      tmpInt3 := Client.GetAllyNo;
      tmpInt4 := Client.GetTeamNo;
      Client.BattleStatus := tmpInt;
      tmpBool := Client.GetMode <> tmpInt2; // did player change his mode from spectator to player (or vice versa)?
      Client.TeamColor := teamcolor;

      if BattleForm.mnuBlockTeams.Checked and  (tmpInt3 <> Client.GetAllyNo) and Client.StatusRefreshed then begin
        MainForm.TryToSendCommand('FORCEALLYNO', Client.Name + ' ' + IntToStr(tmpInt3));
        Client.SetAllyNo(tmpInt3);
      end;
      if BattleForm.mnuBlockTeams.Checked and  (tmpInt4 <> Client.GetTeamNo) and Client.StatusRefreshed then begin
        MainForm.TryToSendCommand('FORCETEAMNO', Client.Name + ' ' + IntToStr(tmpInt4));
        Client.SetTeamNo(tmpInt4);
      end;
      BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
      BattleForm.UpdateClientsListBox;
      if Client.Name = Status.Username then
      begin
        BattleForm.SetMyBattleStatus(Client.GetSide, Client.GetReadyStatus, Client.GetTeamNo, Client.GetAllyNo, Client.GetMode);
        if Misc.GetColorIndex(TeamColors, teamcolor) = -1 then begin
          TeamColors[0] := teamcolor;
          UpdateColorImageList;
        end;
        BattleForm.ChangeTeamColor(Misc.GetColorIndex(TeamColors, teamcolor),False);
      end;

      if BattleState.Status = Hosting then if BattleState.Battle.Clients.IndexOf(Client) <> -1 then
      begin
        if tmpBool then
        begin
          if (BattleState.Status=Hosting) and (Client.GetRank < BattleState.Battle.RankLimit) and BattleState.AutoSpecRankLimit and (Client.GetMode <> 0) then begin
            MainForm.TryToSendCommand('SAYBATTLEEX', '*** Rank limit auto-spec : '+Client.Name+' ***');
            MainForm.TryToSendCommand('FORCESPECTATORMODE', Client.Name);
          end
          else
            if (BattleState.Status=Hosting) and (Client.GetGroup > -1) and TClientGroup(ClientGroups[Client.GetGroup]).AutoSpec and (Client.GetMode <> 0) then begin
              MainForm.TryToSendCommand('SAYBATTLEEX', '*** Group auto-spec : '+Client.Name+' ***');
              MainForm.TryToSendCommand('FORCESPECTATORMODE', Client.Name);
            end
            else
              if (BattleState.Status=Hosting) and (Client.GetMode <> 0) and BattleState.Battle.IsLadderBattle and (Client.CurrentLadderRating=0) then
              begin
                MainForm.TryToSendCommand('SAYBATTLEEX', '*** No ladder account auto-spec : '+Client.Name+' ***');
                MainForm.TryToSendCommand('FORCESPECTATORMODE', Client.Name);
              end;

          // update spectator count:
          count := 0;
          for i := 0 to BattleState.Battle.Clients.Count-1 do if TClient(BattleState.Battle.Clients[i]).GetMode = 0 then Inc(count);
          BattleState.Battle.SpectatorCount := count;

          BattleForm.SendBattleInfoToServer;
        end;
        BattleForm.StartButton.Enabled := BattleState.Battle.AreAllClientsReady and BattleState.Battle.AreAllClientsSynced and BattleForm.LadderTeamReady;
      end;
      BattleForm.RefreshTeamNbr;
      Client.StatusRefreshed := True;
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
      BattleForm.ResetBattleScreen;
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
      BattleForm.DisabledUnitsTab.Caption := 'Disabled Units ('+IntToStr(BattleForm.DisabledUnitsListBox.Items.Count)+')';
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
      BattleForm.DisabledUnitsTab.Caption := 'Disabled Units ('+IntToStr(BattleForm.DisabledUnitsListBox.Items.Count)+')';
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
      BattleForm.DisabledUnitsTab.Caption := 'Disabled Units (0)';
    end
    else if sl[0] = 'RING' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      if not Preferences.DisableAllSounds then PlayResSound('ring');
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

      AddMainLog('* Broadcast from server: ' + MakeSentenceWS(sl, 1), Colors.Info);

      For i:=1 to PageControl1.PageCount -1 do
        AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Broadcast from server: ' + MakeSentenceWS(sl, 1), Colors.Info);
    end
    else if sl[0] = 'SERVERMSG' then
    begin
      sl2 := TWideStringList.Create;
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;
      tmp := MakeSentenceWS(sl, 1);
      AddMainLog('* Message from server: ' + tmp, Colors.Info);
      if (Pos('Your account has been renamed',tmp) > 0) and (Preferences.LadderPassword <> '') then // handleRename
      begin
        tmp := MidStr(tmp,Pos('<',tmp)+1,500000);
        tmp := LeftStr(tmp,Pos('>',tmp)-1);
        RenameThread := TLadderRenameAccountThread.Create(False,tmp);
      end;
      if Pos('''s IP is ',tmp)>0 then // retreiving ip
      begin
        Misc.ParseDelimited(sl2,tmp,'''s IP is ','');
        Client := GetClient(sl2[0]);
        if Client <> nil then
          Client.IP := sl2[1];
        if FindIPQueueList.IndexOf(sl2[0]) > -1 then
        begin
          TryToSendCommand('FINDIP', Client.IP);
          FindIPQueueList.Delete(FindIPQueueList.IndexOf(sl2[0]));
        end;
      end;
    end
    else if sl[0] = 'SERVERMSGBOX' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      sl2 := ParseString(MakeSentenceWS(sl, 1), #9);

      if sl2.Count > 1 then url := sl2[1]
      else url := '';

      if url = '' then
        MessageDlg('Message from server: ' +#13+#13+ sl2[0], mtInformation, [mbOK], 0)
      else
      begin
        if MessageDlg('Message from server: ' +#13+#13+ sl2[0] +#13+#13+'Do you want to open ' + url + ' in the default browser now?', mtInformation, [mbYes, mbNo], 0) = mrYes then
          Misc.OpenURLInDefaultBrowser(url);
      end;
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
      else BattleReplayInfo.TempScript.Add(MakeSentenceWS(sl, 1));
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
    else if sl[0] = 'MUTELISTBEGIN' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      // lets check if form containing such list is already open:
      tmpBool := False; // found?
      tmp := sl[1];
      for i := 0 to MuteListForms.Count - 1 do
        if TMuteListForm(MuteListForms[i]).ChanName = tmp then
        begin
          TMuteListForm(MuteListForms[i]).MuteListBox.Clear;
          TMuteListForm(MuteListForms[i]).Show;

          tmpBool := True;
          Break;
        end;

      if not tmpBool then
      begin
        TMuteListForm.Create(tmp).Show;
      end;

      ReceivingMuteListForChannel := tmp;
    end
    else if sl[0] = 'MUTELIST' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      // lets found the form that is holding the mute list (if such form does not exist, no problem, we'll just ignore it!)
      for i := 0 to MuteListForms.Count - 1 do
        if TMuteListForm(MuteListForms[i]).ChanName = ReceivingMuteListForChannel then
        begin
          TMuteListForm(MuteListForms[i]).MuteListBox.Items.Add(MakeSentenceWS(sl, 1));
          Break;
        end;
    end
    else if sl[0] = 'MUTELISTEND' then
    begin
      // lets found the form that is holding the mute list (if such form does not exist, no problem, we'll just ignore it!)
      for i := 0 to MuteListForms.Count - 1 do
        if TMuteListForm(MuteListForms[i]).ChanName = ReceivingMuteListForChannel then
        begin
          TMuteListForm(MuteListForms[i]).StatusBar.SimpleText := 'Done.';
          if TMuteListForm(MuteListForms[i]).MuteListBox.Items.Count = 0 then
            TMuteListForm(MuteListForms[i]).MuteListBox.Items.Add('--- mute list is empty ---');
          Break;
        end;
    end
    else if sl[0] = 'MAPGRADES' then
    begin
      if (sl.Count-1) mod 3 <> 0 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      for i := 0 to (sl.Count-1) div 3 - 1 do
      begin
        hash := sl[1 + i*3];
        mapitem := FindMapItem(hash);
        if mapitem = nil then Continue;

        mapitem.GlobalGrade := StrToFloat(sl[1 +i*3+1]);
        mapitem.TotalVotes := StrToInt(sl[1 +i*3+2]);
        mapitem.PublicGradeLabel.Caption := Format('%2.1f (%d votes)', [mapitem.GlobalGrade, mapitem.TotalVotes]);
        mapitem.Changed := True; // since global grade probably just changed
      end;

      if Preferences.MapSortStyle = 4 then MapListForm.SortMapList(Preferences.MapSortStyle);
      MapListForm.StatusLabel.Caption := 'synchronization completed.';
      SyncSentAt := 0;
    end
    else if sl[0] = 'MAPGRADESFAILED' then
    begin
      tmp := 'Unspecified error';
      if sl.Count > 1 then tmp := MakeSentenceWS(sl, 1);
      MessageDlg('Unable to synchronize map grades (reason: ' + tmp + ')', mtWarning, [mbOK], 0);
      MapListForm.StatusLabel.Caption := 'synchronization failed.';
      SyncSentAt := 0;
    end
    else if sl[0] = 'ACQUIREUSERID' then
    begin
      Misc.GenerateAndSaveLobbyUserID;
      TryToSendCommand('USERID', IntToHex(Misc.GetLobbyUserID, 1));
    end
    else
    begin
      // unknown/invalid command!

      AddMainLog('Error: Server sent unknown or invalid command!', Colors.Error);
    end;
  finally
    ProcessingRemoteCommand := False;
    Status.LastCommandReceived := sl[0];
    if sl <> nil then sl.Free;
    if sl2 <> nil then sl2.Free;
    if sl3 <> nil then sl3.Free;


  end;

end;

procedure TMainForm.TryToCloseTab(TabSheet: TMyTabSheet);
var
  index: Integer;
begin
  if TabSheet.Caption = LOCAL_TAB then Exit;

  if TabSheet.Caption[1] = '#' then
    if Status.ConnectionState = Connected then TryToSendCommand('LEAVE', Copy(TabSheet.Caption, 2, Length(TabSheet.Caption)-1));

  index := TabSheet.PageIndex;
  TabSheet.Free;
  PageControl1.ActivePageIndex := Min(PageControl1.PageCount-1, index);
  PageControl1.OnChange(PageControl1); // because it doesn't get triggered automatically
end;

procedure TMainForm.RichEditMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ci, //Character Index
   lix, //Line Index
   co, //Character Offset
   k, j: Integer;
   Pt: TPoint;
   s: string;
   SelectedNick: string;
begin
  if Button = mbRight then
  begin
   with TTntRichEdit(Sender) do
   begin
     Pt := Point(X, Y) ;
     ci := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@Pt)) ;
     if ci < 0 then Exit;
     lix := Perform(EM_EXLINEFROMCHAR, 0, ci) ;
     co := ci - Perform(EM_LINEINDEX, lix, 0) ;
     if -1 + Lines.Count < lix then Exit;
     s := Lines[lix];
     Inc(co) ;
     k := co;
     while (k > 0) and (s[k] <> ' ') and (s[k] <> '<') do k:=k-1;
     Inc(k);
     Inc(co) ;
     j := co;
     while (j <= Length(s)) and (s[j] <> ' ') and (s[j] <> '>') do Inc(j) ;
     SelectedNick := Copy(s, k, j - k) ;

     RichEditSelectedClient := GetClient(SelectedNick);

     if RichEditSelectedClient <> nil then
     begin
       ModerationSubmenuItem.Visible := Status.Me.GetAccess; // only moderators may see moderation menu!
       MuteSubitemMenu.Visible := LeftStr(PageControl1.ActivePage.Caption,1) = '#';
       mnuUnmute.Visible := LeftStr(PageControl1.ActivePage.Caption,1) = '#';
       ClientPopupMenu.Popup(TTntRichEdit(Sender).ClientToScreen(pt).X,TTntRichEdit(Sender).ClientToScreen(pt).Y);
       RichEditSelectedClient := nil;
     end;
   end;
  end;
end;

procedure TMainForm.InputEditClick(Sender: TObject);
begin
  (Sender as TEdit).Tag := 0;
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
  s: WideString;
  sl: TWideStringList;
  tmp: string;
begin
  if (Key = Ord('W')) and (ssCtrl in Shift) then
  begin
    if PageControl1.ActivePage.Caption = LOCAL_TAB then Exit;
    PostMessage(MainForm.Handle, WM_CLOSETAB, PageControl1.ActivePageIndex, 0);
    Exit;
  end;

  if Key = 13 then
  begin
    s := (Sender as TSpTBXEdit).Text;
    (Sender as TEdit).Text := '';
    if s = '' then Exit;

    with ((Sender as TSpTBXEdit).Parent as TMyTabSheet) do
    begin
      History.Add(s);
      HistoryIndex := History.Count;
    end;

    if (s[1] = '/') or (s[1] = '.') then
    begin
      ProcessCommand(Copy(s, 2, Length(s)-1), False);
      Exit;
    end;
    if ((Sender as TEdit).Parent as TMyTabSheet).Caption[1] = '$' then
    begin
      sl := StringParser.ParseString(s, ' ');
      if sl.Count > 1 then
        TryToSendCommand(sl[0], MakeSentenceWS(sl, 1))
      else
        TryToSendCommand(sl[0]);
    end
    else if ((Sender as TSpTBXEdit).Parent as TMyTabSheet).Caption[1] = '#' then
      TryToSendCommand('SAY',Copy(((Sender as TSpTBXEdit).Parent as TMyTabSheet).Caption, 2, Length(((Sender as TSpTBXEdit).Parent as TMyTabSheet).Caption))+' '+s)
    else TryToSendCommand('SAYPRIVATE', ((Sender as TSpTBXEdit).Parent as TMyTabSheet).Caption + ' ' + s);
  end
  else if Key = VK_UP then
  begin
    with (Sender as TSpTBXEdit).Parent as TMyTabSheet do
    begin
      if History.Count = 0 then Exit;
      HistoryIndex := Max(0, HistoryIndex-1);
      (Sender as TSpTBXEdit).Text := History[HistoryIndex];
      (Sender as TSpTBXEdit).SelStart := Length((Sender as TSpTBXEdit).Text);
      Key := 0;
    end;
  end
  else if Key = VK_DOWN then
  begin
    with (Sender as TSpTBXEdit).Parent as TMyTabSheet do
    begin
      if History.Count = 0 then Exit;
      HistoryIndex := Min(History.Count-1, HistoryIndex + 1);
      (Sender as TSpTBXEdit).Text := History[HistoryIndex];
      (Sender as TSpTBXEdit).SelStart := Length((Sender as TSpTBXEdit).Text);
      Key := 0;
    end;
  end
  else if Key = VK_ESCAPE then
  begin
    (Sender as TSpTBXEdit).Text := '';
    Key := 0;
  end;

  if Key <> VK_TAB then
    (Sender as TSpTBXEdit).Tag := 0;
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
  group: Integer;
  i: integer;
begin
  if PageControl1.ActivePage.Caption = LOCAL_TAB then
  begin
    if Index > AllClients.Count-1 then Exit; // we just ignore it. It seems ClientsListBox hasn't been yet updated. This can happen when we remove items from it and we don't call UpdateClientsListBox right away, since we want to do some more things before that. Anyway, this should not happen, since ClientsListBox is changed only within the main VCL thread.

    group := TClient(AllClients[Index]).GetGroup;
    if (group > -1) and (ClientsListBox.ItemIndex <> Index) then
      (Control as TListBox).Canvas.Brush.Color := TClientGroup(ClientGroups[group]).Color;
      
    // this ensures the correct highlite color is used
    (Control as TListBox).Canvas.FillRect(Rect);

    xpos := Rect.Left;
    if odSelected in State then (Control as TListBox).Canvas.Font.Color := clWhite
    else (Control as TListBox).Canvas.Font.Color := clBlack;

    PlayerStateImageList.Draw((Control as TListBox).Canvas, xpos, Rect.Top, TClient(AllClients[Index]).GetStateImageIndex);
    Inc(xpos,PlayerStateImageList.Width);

    if Preferences.ShowFlags then
    begin
      FlagBitmap := GetFlagBitmap(TClient(AllClients[Index]).Country);
      (Control as TListBox).Canvas.Draw(xpos, Rect.Top + 16 div 2 - FlagBitmap.Height div 2, FlagBitmap);
      Inc(xpos, FlagBitmap.Width + 5);
    end;

    (Control as TListBox).Canvas.TextOut(xpos, Rect.Top, TClient(AllClients[Index]).Name);

    Inc(xpos, (Control as TListBox).Canvas.TextWidth(TClient(AllClients[Index]).Name));

    if TClient(AllClients[Index]).GetAccess then
      PlayerStateImageList.Draw((Control as TListBox).Canvas, xpos, Rect.Top, 4);
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

    group := TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetGroup;
    if (group > -1) and (ClientsListBox.ItemIndex <> Index) then
      (Control as TListBox).Canvas.Brush.Color := TClientGroup(ClientGroups[group]).Color;

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
      (Control as TListBox).Canvas.Font.Color := Colors.ClientAway
    else (Control as TListBox).Canvas.Font.Color := clWindowText;
    if odSelected in State then (Control as TListBox).Canvas.Font.Color := clWhite;

    if TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetBotMode then
    begin
      (Control as TListBox).Canvas.Draw(xpos, Rect.Top, BotImage.Picture.Bitmap);
      Inc(xpos, BotImage.Picture.Bitmap.Width + 4{leave some space between username and the icon});
    end;

    // ladder cup
    with TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]) do
    begin
      for i:=0 to CupList.Count-1 do
      begin
        LadderCups.Draw((Control as TListBox).Canvas, xpos, Rect.Top, Integer(CupList[i]^));
        Inc(xpos, LadderCups.Width + 1);
      end;
    end;

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
    MainForm.MainTitleBar.Caption := PROGRAM_VERSION;
    MainForm.Caption := PROGRAM_VERSION;
  except
    AddMainLog('Error while trying to disconnect!', Colors.Error);
  end;
end;

procedure TMainForm.TryToConnect;
begin
  TryToConnect(Preferences.ServerIP, Preferences.ServerPort);
  Status.CurrentAwayItem := -2; // status : available
end;

procedure TMainForm.TryToConnect(ServerAddress, ServerPort: string);
var
  bufsize: Integer;
  t: TGetInternetIpThread;
begin
  if Status.ConnectionState <> Disconnected then TryToDisconnect;

  try
    Socket.Proto := 'tcp';
    Socket.Addr := ServerAddress;
//    if LowerCase(Socket.Addr) = 'localhost' then Socket.Addr := '127.0.0.1';
    Socket.Port := ServerPort;
    Socket.LineMode := False;
    Socket.Connect;
    // send/receive buffers should be set after a call to Connect method (see http://users.pandora.be/sonal.nv/ics/faq/TWSocket.html#BroadcastvsMulticastAE):
    bufsize := 32768;
    WSocket_setsockopt(Socket.HSocket, SOL_SOCKET, SO_RCVBUF, @bufsize, SizeOf(bufsize));
    bufsize := 32768;
    WSocket_setsockopt(Socket.HSocket, SOL_SOCKET, SO_SNDBUF, @bufsize, SizeOf(bufsize));
    //t := TGetInternetIpThread.Create(false);
  except
    AddMainLog('Error: cannot connect! (' + ServerAddress + ':' + ServerPort + ')', Colors.Error);
    if Preferences.ReconnectToBackup then PostMessage(MainForm.Handle, WM_CONNECT_TO_NEXT_HOST, 0, 0);
  end;
end;

procedure TMainForm.OnConnectToNextHostMessage(var Msg: TMessage); // responds to WM_CONNECT_TO_NEXT_HOST message
var
  i: Integer;
  found: Boolean;

  procedure Reconnect(Address: string);
  begin
    AddMainLog('Trying next host in the list ...', Colors.Info);
    TryToConnect(Address, Preferences.ServerPort);
  end;

begin
  found := False;

  for i := 0 to High(ServerList) do if ServerList[i].Address = Socket.Addr then
  begin
    found := True;

    if i = High(ServerList) then
    begin
      // ok we've reached the end of the list, there is nothing more we can do, let's just cancel connecting
      Exit;
    end;

    Reconnect(ServerList[i+1].Address);
    Break;
  end;

  if not found then if Length(ServerList) > 0 then
  begin
    // try the first server in the list
    Reconnect(ServerList[0].Address);
  end;
end;

procedure TMainForm.TryToSendDataDirectly(s: string); // deprecated - use TryToSendCommand method instead!
begin;
  if Status.ConnectionState <> Connected then
  begin
    AddMainLog('Error: Must be connected to send data!', Colors.Error);
    Exit;
  end;

  try
    Socket.SendLine(s);
    Inc(Status.CumulativeDataSent, Length(s));
    if Debug.Enabled and ((not Debug.FilterPingPong) or (s <> 'PING')) then AddMainLog('Client: "' + s + '"', Colors.Data);
    Status.TimeOfLastDataSent := GetTickCount;
  except
    AddMainLog('Error: cannot send data: "' + s + '"', Colors.Error);
  end;
end;

{ will try to send command to the server returning the message ID chosen for this message if 'AssignID' is true, or else returning -1.
  Params will not be sent along the command if SendParams is set to 'False'.
  Returns immediately.
  Note that this is a generic (and private) method, use other overloaded methods instead for general use. }
function TMainForm.TryToSendCommand(Command: WideString; SendParams: Boolean; Params: WideString; AssignID: Boolean): Integer;
var
  s: WideString;
  sUTF8: UTF8String;
begin;
  // assign unique message(command) ID:
  if AssignID then
  begin
    Status.CurrentMsgID := (Status.CurrentMsgID + 1) mod MAX_MSG_ID;
    Result := Status.CurrentMsgID;
  end
  else Result := -1;

  s := IFF(AssignID, '#' + IntToStr(Result) + ' ', '') + UpperCase(Command) + IFF(SendParams, ' ' + Params, '');

  if Status.ConnectionState <> Connected then
  begin
    AddMainLog('Error: Must be connected to send data!', Colors.Error);
    Exit;
  end;

  try
    sUTF8 := UTF8Encode(s+EOL);
    Socket.Send(PChar(sUTF8),length(sUTF8));
    Inc(Status.CumulativeDataSent, Length(s));
    if Debug.Enabled and ((not Debug.FilterPingPong) or (Command <> 'PING')) then AddMainLog('Client: "' + s + '"', Colors.Data);
    Status.TimeOfLastDataSent := GetTickCount;
  except
    AddMainLog('Error: cannot send data: "' + s + '"', Colors.Error);
  end;
end;

{ will try to send command to the server returning the message ID chosen for this message if 'AssignID' is true, or else returning -1.
  Returns immediately. }
function TMainForm.TryToSendCommand(Command: WideString; Params: WideString; AssignID: Boolean): Integer;
begin;
  Result := TryToSendCommand(Command, True, Params, AssignID);
end;

{ 'AssignID' - if true, ID is assigned and returned, or else -1 is returned }
function TMainForm.TryToSendCommand(Command: WideString; AssignID: Boolean): Integer;
begin;
  Result := TryToSendCommand(Command, False, '', AssignID);
end;

procedure TMainForm.TryToSendCommand(Command: WideString; Params: WideString);
begin
  TryToSendCommand(Command, True, Params, False);
end;

procedure TMainForm.TryToSendCommand(Command: WideString);
begin
  TryToSendCommand(Command, False, '', False);
end;

procedure TMainForm.TryToLogin(Username, Password: string);
var
  ip: string;
  userid: string;
begin;
  // let's send the login command:
  ReceivedAgreement.Clear; // clear temporary agreement, as server might send us a new one now
  ip := GetLocalIP;
  if ip = '' then ip := '*';
  if ((Password = '') or (Status.ServerMode = 1{LAN MODE})) then Password := '*'; // probably local LAN mode. We have to send something as a password, so we just send an "*".
  userid := IntToHex(Misc.GetLobbyUserID, 1);
  TryToSendCommand('LOGIN', Username + ' ' + Misc.GetMD5Hash(Password) + ' ' + IntToStr(Status.MyCPU) + ' ' + ip + ' ' + PROGRAM_VERSION + IFF(userid <> '0', #9 + userid, ''));
end;

procedure TMainForm.TryToRegister(Username, Password: string);
begin;
  if Password = '' then Password := '*'; // we should never send empty password
  TryToSendCommand('REGISTER', Username + ' ' + Misc.GetMD5Hash(Password));
end;

// "Edit" must be from TMyTabSheet container! (this method uses clients
procedure TMainForm.TryToAutoCompleteClientName(Edit: TSpTBXEdit; Clients: TList);
var
  s: string;
  text: string;
  i,j: Integer;
  found: Boolean;
  pos, startpos: Integer;
  SortedClientsList: TStringList;
  splitedString: TWideStringList;
  completionWordIndex: integer;
  selStart: integer;
begin
  if (Clients.Count = 0) or ((Edit.SelLength <> 0) and (Edit.Tag = 0))  or (Edit.Text = '') then
  begin
    Beep;
    Exit;
  end;

  SortedClientsList := TStringList.Create;
  splitedString := TWideStringList.Create;

  try
  for i:=0 to Clients.Count-1 do
    SortedClientsList.Add(TClient(Clients[i]).Name);

  SortedClientsList.Sort;

  splitedString := ParseString(Edit.Text,' ');

  // we find the word being completed
  completionWordIndex := splitedString.Count-1;
  j := 0;
  for i:=0 to splitedString.Count-1 do
  begin
    j := j + Length(splitedString[i])+1;
    if Edit.SelStart <= j then
    begin
      completionWordIndex := i;
      Break;
    end;
  end;

  // we use the Edit.Tag to save the length of the first string we tab
  if Edit.Tag = 0 then
  begin
    Edit.Tag := Edit.SelStart - (j-Length(splitedString[i])-1);
    splitedString[i] := LeftStr(splitedString[i],Edit.Tag);
  end;

  // extract the good ones
  for i:=SortedClientsList.Count-1 downto 0 do
    if LowerCase(LeftStr(SortedClientsList[i],Edit.Tag)) <> LowerCase(LeftStr(splitedString[completionWordIndex],Edit.Tag)) then
      SortedClientsList.Delete(i);

  if SortedClientsList.Count = 0 then
  begin
    Beep;
    Exit;
  end;

  // we replace the username
  if Length(splitedString[completionWordIndex]) = Edit.Tag then // is it the first tab we do ?
    splitedString[completionWordIndex] := SortedClientsList[0]
  else
  begin
    for i:=0 to SortedClientsList.Count-1 do
      if LowerCase(SortedClientsList[i]) = LowerCase(splitedString[completionWordIndex]) then
      begin
        j := i;
        break;
      end;
    if j = SortedClientsList.Count-1 then
      j:=-1;
    splitedString[completionWordIndex] := SortedClientsList[j+1];
  end;


  // we remake the string and put the selstart at the right place
  Edit.Text := '';
  for i := 0 to splitedString.Count-1 do
  begin
    if i=0 then
      Edit.Text := splitedString[i]
    else
      Edit.Text := Edit.Text + ' ' + splitedString[i];
    if i=completionWordIndex then
    begin
      selStart := Length(Edit.Text)-Length(splitedString[i])+Edit.Tag;
      Edit.SelLength := Length(splitedString[i]);
    end;
  end;

  Edit.SelStart := selStart + Length(splitedString[completionWordIndex])-Edit.Tag;
  // we select the new added text
  //Edit.SelStart := selStart;
  //Edit.SelLength := Length(splitedString[completionWordIndex]) - Edit.Tag;

  finally
    SortedClientsList.Free;
    splitedString.Free;
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
      ConnectButton.ImageIndex := 1;
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
      ConnectButton.ImageIndex := 0;
      if Status.ConnectionState = Connecting then
      begin
        AddMainLog('Cannot connect to server!', Colors.Info);
        if Preferences.ReconnectToBackup then PostMessage(MainForm.Handle, WM_CONNECT_TO_NEXT_HOST, 0, 0);
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
      Status.ReceivingLoginInfo := False;
      Status.Me := nil;
      if not Preferences.DisableAllSounds then PlayResSound('disconnect');
    end;

  end; // case
end;

procedure TMainForm.SocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode <> 0 then Exit;

  Status.ConnectionState := Connected;
  Status.LoggedIn := False;
  Status.ReceivingLoginInfo := False;
  Status.Hashing := False;
  Status.MyRank := 0;
  Status.TimeOfLastDataReceived := GetTickCount;
  Status.TimeOfLastDataSent := GetTickCount;
  Status.CumulativeDataSent := 0;
  Status.CumulativeDataRecv := 0;

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
  i: Integer;
  p: TPoint;
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
  then TryToSendCommand('PING');

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

  // cursor moved
  GetCursorPos(p);
  if (p.X <> LastCursorPos.X) and (p.Y <> LastCursorPos.Y)then
  begin
    Status.AwayTime := GetTickCount;
    AutoSetBack;
  end;
  LastCursorPos := p;

  // we will also use this timer to check if user is away:
  if (GetTickCount - Status.AwayTime > AWAY_TIME) then // (not Application.Active) and
  begin // user is away
    if Status.Me = nil then Exit; // should not happen!
    if not Status.Me.GetAwayStatus then // no need to set to away if already away
    begin
      Status.Me.SetAwayStatus(True);
      Status.CurrentAwayMessage := IDL_DEFAULT_MSG;
      Status.CurrentAwayItem := -1;
      MainForm.TryToSendCommand('MYSTATUS', IntToStr(Status.Me.Status));
      Status.AutoAway := True;
    end;
  end;

end;

procedure TMainForm.SocketDataAvailable(Sender: TObject; ErrCode: Word);
var
  sBuffer: UTF8String;
  s: WideString;
  i: Integer;
  len: Integer;
  s2: String;
begin
  Status.TimeOfLastDataReceived := GetTickCount;
  SetLength(sBuffer, 256);

  while True do
  begin
    len := (Sender as TWSocket).Receive(@sBuffer[1], 256);
    if len <= 0 then Exit;

    s := UTF8Decode(LeftBStr(sBuffer,len));
    s2 := s;
    if Pos('29093',s2)>0 then
    begin
      ReceiveBuffer := ReceiveBuffer;
    end;

    for i := 1 to length(s) do
    begin
      if (s[i] = #$A) then
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
  // set focus to TEdit control (we need to do this only once for 1 page only, and TEdit control will always receive focus with any new page):
  (PageControl1.ActivePage.Controls[0] as TEdit).SetFocus;
end;

{ opens a private chat with ClientName if it doesn't already exist.
  If it does, it just focuses it. }
procedure TMainForm.OpenPrivateChat(ClientName: string);
var
  i: Integer;
  tmpEd : TEdit;
begin
  if ClientName = Status.Username then
  begin
    MessageDlg('Feel like talking to yourself? No way!', mtInformation, [mbOK], 0);
    Exit; // can't talk to yourself! (although possible! :-)
  end;

  i := GetTabWindowPageIndex(ClientName);
  if i = -1 then i := AddTabWindow(ClientName, True) // switch focus to new tab
  else ChangeActivePageAndUpdate(PageControl1, i);

//  RemoveAllClientsFromTab(PageControl1.Pages[i] as TMyTabSheet);
  if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, ClientName) then ; // nevermind, just ignore it

  UpdateClientsListBox;

  tmped := (PageControl1.Pages[i] as TMyTabSheet).FindChildControl('InputEdit') as TEdit;
  if tmped <> nil then
    tmped.SetFocus;
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

procedure TMainForm.BattleScreenSpeedButtonClick(Sender: TObject);
begin

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
  i:integer;
  avgRank:float;
begin
  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    Battle := GetBattleFromNode(Node);

    if (Node = FocusedNode) and Focused then
      Canvas.Font.Color := clHighlightText
    else
    begin
      Canvas.Font.Color := clWindowText;

      // clientgroup highlight
      Canvas.Brush.Color := Battle.GetHighlightColor;
      R := ContentRect;
      Dec(R.Left,TextMargin);
      Canvas.FillRect(R);
    end;

    R := ContentRect;
    InflateRect(R, -TextMargin, 0);
    Dec(R.Right);
    Dec(R.Bottom);
    s := '';

    case Column of
      0: ; // join
      1:
      begin
        if Battle.IsLadderBattle then begin
          BattleStatusImageList.Draw(Canvas, ContentRect.Left, R.Top, 17);
          s := MidStr(Battle.Description,Pos(') ',Battle.Description)+2,99999);
          Inc(R.Left,16);
        end
        else
          s := Battle.Description; // game's name (description, title)
      end;
      2: s := TClient(Battle.Clients[0]).Name; // host
      3: // map
      begin
        if Preferences.MarkUnknownMaps then
          if Utility.MapList.IndexOf(Battle.Map) = -1 then
            Canvas.Font.Color := MainUnit.Colors.MapModUnavailable;
        s := Copy(Battle.Map, 1, Length(Battle.Map)-4);
      end;
      4: // state
      begin
        X := ContentRect.Left + ((Sender as TVirtualDrawTree).Header.Columns[4].Width - BattleStatusImageList.Width - RanksImageList.Width - BattleStatusImageList.Width - Margin) div 2;

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

        if (Preferences.WarnIfUsingNATTraversing) and (Battle.NATType > 0) then
        begin
          Inc(X, BattleStatusImageList.Width);
          BattleStatusImageList.Draw(Canvas, X, R.Top, 13);
        end;
      end;
      5: // mod
      begin
        if Preferences.MarkUnknownMaps then
          if Utility.ModList.IndexOf(Battle.ModName) = -1 then
            Canvas.Font.Color := MainUnit.Colors.MapModUnavailable;
        s := Battle.ModName;
      end;
      6: // avg player rank
      begin
        avgRank := 0;
        for i:=0 to Battle.Clients.Count-1 do
          avgRank := avgRank + TClient(Battle.Clients[i]).GetRank;
        avgRank := avgRank / Battle.Clients.Count;
        RanksImageList.Draw(Canvas, R.Left, R.Top, Round(avgRank));
        Inc(R.Left, RanksImageList.Width);
        s := FloatToStrF(RoundTo(avgRank+1,-2),ffFixed,7,2);
      end;
      7: // players
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
           s := ShortenString(Canvas.Handle, s, Right - Left, 0);
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
  Battle: TBattle;
  i:integer;
begin
  with Sender as TVirtualDrawTree do
    AMargin := TextMargin;


  Battle := GetBattleFromNode(Node);

  case Column of
    0: NodeWidth := ButtonImageList.Width; // join
    1: NodeWidth := Canvas.TextWidth(Battle.Description) + 2 * AMargin; // description
    2: NodeWidth := Canvas.TextWidth(TClient(Battle.Clients[0]).Name) + 2 * AMargin; // host
    3: NodeWidth := Canvas.TextWidth(Copy(Battle.Map, 1, Length(Battle.Map)-4)) + 2 * AMargin; // map
    4: // state
    begin
      NodeWidth := BattleStatusImageList.Width;
      if Battle.RankLimit > 0 then Inc(NodeWidth, BattleStatusImageList.Width);
      if (Preferences.WarnIfUsingNATTraversing) and (Battle.NATType > 0) then Inc(NodeWidth, BattleStatusImageList.Width);
    end;
    5: NodeWidth := Canvas.TextWidth(Battle.ModName) + 2 * AMargin; // mod
    7: // players
    begin
      s := IntToStr(Battle.Clients.Count - Battle.SpectatorCount);
      if Battle.SpectatorCount > 0 then s := s + '+' + IntToStr(Battle.SpectatorCount);
      s := s + '/' + IntToStr(Battle.MaxPlayers) + ' (' + Battle.ClientsToString + ')';
      NodeWidth := Canvas.TextWidth(s) + 2 * AMargin; // players
    end;
  end; // case
end;

procedure TMainForm.VDTBattlesChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  JoinBattle(GetBattleFromNode(Node));
end;

procedure TMainForm.JoinBattle(Battle: TBattle);
var
  s, pass: string;
  res: Integer;
  url: string;
  s1: TStrings;
  i:integer;
begin
  s1 := TStringList.Create;
  if BattleForm.IsBattleActive then
  begin
    //MessageDlg('You must first disconnect from current battle!', mtInformation, [mbOK], 0);
    if MessageDlg('Do you want to disconnect from the current battle to join this one ?',mtConfirmation, [mbYes,mbNo], 0) = mrYes then
      BattleForm.DisconnectButtonClick(nil)
    else
      Exit;
  end;

  // check if we have the mod at all:
  if ModList.IndexOf(Battle.ModName) = -1 then
  begin
    // try refreshing the mod list, perhaps user has just installed the mod:
    HostBattleForm.RefreshModListButton.OnClick(HostBattleForm.RefreshModListButton);

    if ModList.IndexOf(Battle.ModName) = -1 then
    begin
      if MessageDlg('Can''t join: you don''t have the right mod! Do you want to download it now?', mtInformation, [mbYes, mbNo], 0) = mrYes then begin
        //Misc.ParseDelimited(s1,Battle.ModName,' ','.');
        url := 'http://spring.jobjol.nl/search_result.php?search='+Battle.ModName+'&select=select_all';
        FixURL(url);
        Misc.OpenURLInDefaultBrowser(url);
      end;
      Exit;
    end;
  end;

  // is battle in progress?
  if Battle.IsBattleInProgress then
  begin
    MessageDlg('Can''t join: battle is in progress!', mtInformation, [mbOK], 0);
    Exit;
  end;

  // is battle locked?
  if Battle.Locked then
  begin
    MessageDlg('Can''t join: battle is locked!', mtInformation, [mbOK], 0);
    Exit;
  end;

  // is this battle replay and battle is full?
  if (Battle.BattleType = 1) and (Battle.IsBattleFull) then
  begin
    MessageDlg('Can''t join: battle is full!', mtInformation, [mbOK], 0);
    Exit;
  end;

  // is our rank to low to join this battle?
  if Battle.RankLimit > Status.MyRank then
    if MessageDlg('This battle requires a rank of <' + Ranks[Battle.RankLimit] + '>.' +#13+
                  'It is impolite to join a battle which requires a rank which you don''t have.' +#13+#13+
                  'Do you wish to attempt to join this battle anyway?', mtWarning, [mbNo, mbYes], 0) = mrNo then Exit;

  pass := '';
  if Battle.Password then
  begin
    if Battle.IsLadderBattle then
      pass := LADDER_BATTLE_PASSWORD
    else
      if not InputQuery('Password', 'Password:', pass) then Exit;
  end;

  // acquire public UDP source port from the server if battle host uses "hole punching" technique:
  if Battle.NATType = 1 then  // "hole punching" method
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
  BattleState.TryingToJoinLadderBattle := Battle.IsLadderBattle;
  BattleState.LadderIndex := -1;
  TryToSendCommand('JOINBATTLE', IntToStr(Battle.ID) + IFF(pass <> '', ' ' + pass, ''));
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

  OnlineMapsForm.SaveOnlineMapsToCache(ExtractFilePath(Application.ExeName) + ONLINE_CACHE_FOLDER);
  NotificationsForm.SaveNotificationListToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\notify.dat');
  PerformForm.SaveCommandListToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\perform.dat');
  HighlightingForm.SaveHighlightsToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\highlights.dat');
  IgnoreListForm.SaveIgnoreListToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\ignorelist.dat');
  SaveFiltersToFile;
  ReplaysForm.SaveReplayFiltersToFile;
  SaveGroups;
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

end;

procedure TMainForm.ApplicationEvents1Activate(Sender: TObject);
begin
  AutoSetBack;
end;

procedure TMainForm.AutoSetBack;
begin
  if (Status.ConnectionState = Connected) and (Status.LoggedIn) and Status.AutoAway then
  begin
    if Status.Me = nil then Exit; // shouldn't happen

    if Status.Me.GetAwayStatus = False then Exit;
    Status.Me.SetAwayStatus(False);
    Status.CurrentAwayItem := -2;
    Status.AwayTime := GetTickCount;
    Status.AutoAway := False;

    TryToSendCommand('MYSTATUS', IntToStr(Status.Me.Status));
  end;
end;

procedure TMainForm.ApplicationEvents1Deactivate(Sender: TObject);
begin
  Status.AwayTime := GetTickCount;
end;

procedure TMainForm.Clearwindow1Click(Sender: TObject);
begin
  (PageControl1.ActivePage.Controls[1] as TTntRichEdit).Lines.Clear;
end;

procedure TMainForm.ReplaysButtonClick(Sender: TObject);
begin
  ReplaysForm.Show;
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
    0: Result := 0; // no sorting
    // sort by name:
    1: if AnsiCompareText(Client1.Name, Client2.Name) = 0 then Result := 0 else if AnsiCompareText(Client1.Name, Client2.Name) > 0 then Result := 1 else Result := -1;
    // sort by status:
    2: if Client1.GetInGameStatus and Client2.GetInGameStatus then Result := CompareClients(Client1, Client2, 1)
       else if Client1.GetInGameStatus and not Client2.GetInGameStatus then Result := 1
       else if not Client1.GetInGameStatus and Client2.GetInGameStatus then Result := -1
       else if Client1.InBattle and Client2.InBattle then Result := CompareClients(Client1, Client2, 1)
       else if Client1.InBattle and not Client2.InBattle then Result := 1
       else if not Client1.InBattle and Client2.InBattle then Result := -1
       else Result := CompareClients(Client1, Client2, 1);
    // sort by rank:
    3: if Client1.GetRank = Client2.GetRank then Result := CompareClients(Client1, Client2, 1) else if Client1.GetRank > Client2.GetRank then Result := -1 else Result := 1;
    // sort by country:
    4: if CompareText(Client1.Country, Client2.Country) = 0 then Result := CompareClients(Client1, Client2, 1) else if CompareText(Client1.Country, Client2.Country) > 0 then Result := 1 else Result := -1;
    // sort by group (then by name):
    5:
      if ((Client1.GetGroup = -1) and (Client2.GetGroup = -1)) or (Client1.GetGroup = Client2.GetGroup) then
        if AnsiCompareText(Client1.Name, Client2.Name) = 0 then Result := 0 else if AnsiCompareText(Client1.Name, Client2.Name) > 0 then Result := 1 else Result := -1
      else
        Result := CompareValue(Client2.GetGroup,Client1.GetGroup);
  else
    Result := 0;
  end;
end;

function TMainForm.CompareBattles(Battle1, Battle2: TBattle; SortStyle: Byte): Shortint;
var
  avgRank1,avgRank2: float;
  i:integer;
begin
  case SortStyle of
    0: Result := 0; // no sorting
    // sort by battle status:
    1: if Battle1.IsBattleInProgress and not Battle2.IsBattleInProgress then Result := 1
       else if not Battle1.IsBattleInProgress and Battle2.IsBattleInProgress then Result := -1
       else if Battle1.IsBattleInProgress and Battle2.isBattleInProgress then Result := 0
       else if Battle1.IsBattleFull and not Battle2.IsBattleFull then Result := 1
       else if not Battle1.IsBattleFull and Battle2.IsBattleFull then Result := -1
       else if Battle1.IsBattleFull and Battle2.IsBattleFull then Result := 0
       else Result := 0; // both battles are open/free
    // sort by mod:
    2: if AnsiCompareText(Battle1.ModName, Battle2.ModName) = 0 then Result := 0 else if AnsiCompareText(Battle1.ModName, Battle2.ModName) > 0 then Result := 1 else Result := -1;
    // sort by players:
    3: if Battle1.Clients.Count = Battle2.Clients.Count then Result := 0 else if Battle1.Clients.Count > Battle2.Clients.Count then Result := -1 else Result := 1;
    // sort by map:
    4: if AnsiCompareText(Battle1.Map, Battle2.Map) = 0 then Result := 0 else if AnsiCompareText(Battle1.Map, Battle2.Map) > 0 then Result := 1 else Result := -1;
    // sort by host:
    5: if AnsiCompareText(TClient(Battle1.Clients[0]).Name, TClient(Battle2.Clients[0]).Name) = 0 then Result := 0 else if AnsiCompareText(TClient(Battle1.Clients[0]).Name, TClient(Battle2.Clients[0]).Name) > 0 then Result := 1 else Result := -1;
    6:
    begin
      avgRank1 := 0;
      for i:=0 to Battle1.Clients.Count-1 do
          avgRank1 := avgRank1 + TClient(Battle1.Clients[i]).GetRank;
      avgRank1 := avgRank1 / Battle1.Clients.Count;
      avgRank2 := 0;
      for i:=0 to Battle2.Clients.Count-1 do
          avgRank2 := avgRank2 + TClient(Battle2.Clients[i]).GetRank;
      avgRank2 := avgRank2 / Battle2.Clients.Count;
      Result := CompareValue(avgRank1,avgRank2);
    end;
    // sort by description:
    7: if AnsiCompareText(Battle1.Description, Battle2.Description) = 0 then Result := 0 else if AnsiCompareText(Battle1.Description, Battle2.Description) > 0 then Result := 1 else Result := -1;
  else
    Result := 0;
  end; // case
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

{ will sort "Battles" list. It won't invalidate (repaint) VDTBattles tree! Call VDTBattles.Invalidate to do that manually.
  If Ascending is False, then the list will be sorted in descending order. }
procedure TMainForm.SortBattlesList(SortStyle: Byte; Ascending: Boolean);
var
  i, j: Integer;
  tmp: TBattle;
  tmpNode: PVirtualNode;
  asc: ShortInt;
begin
  if Ascending then asc := 1 else asc := -1;
  // simple bubble sort:
  for i := Battles.count-1 downto 0 do
    for j := 0 to i-1 do
      if asc * CompareBattles(TBattle(Battles[j]), TBattle(Battles[j+1]), SortStyle) > 0 then
      begin
        // swap:
        tmp := Battles[j];
        Battles[j] := Battles[j+1];
        Battles[j+1] := tmp;
      end;

  tmpNode := nil;
  tmpNode := VDTBattles.GetFirst();
  for i:=0 to Battles.Count-1 do
    if TBattle(Battles[i]).Visible then begin
      TBattle(Battles[i]).Node := tmpNode;
      tmpNode := VDTBattles.GetNext(tmpNode);
    end;
end;

function TMainForm.isBattleVisible(Battle:TBattle):Boolean;
var
  i,j: integer;
  tmpStr: string;
begin
  if not EnableFilters.Checked then
  begin
    Result := True;
    Exit;
  end;
  for i:=0 to Filters.TextFilters.Count -1 do
  begin
    with TFilterText(Filters.TextFilters[i]^) do
    begin
      if enabled then
      begin
        if filterType = HostName then
          tmpStr := TClient(Battle.Clients[0]).Name
        else if filterType = MapName then
          tmpStr := LeftStr(Battle.Map,Length(Battle.Map)-4) // left to remove the .smf (or whatever the extension is)
        else if filterType = ModName then
          tmpStr := Battle.ModName
        else if filterType = Description then
          tmpStr := Battle.Description
        else
          raise Exception.Create('Filter type not handled.');

        j := Pos(LowerCase(value),LowerCase(tmpStr));
        if (contains and (j = 0)) or ((not contains) and (j > 0)) then
        begin
          Result := False;
          Exit;
        end;
      end; // if
    end; // with
  end; // for

  Result :=
      (Filters.Locked or (not Battle.Locked)) and
      ((Filters.Passworded and Filters.Ladder) or (not Battle.Password) or (not Filters.Passworded and Filters.Ladder and Battle.IsLadderBattle) or (Filters.Passworded and not Battle.IsLadderBattle)) and
      (Filters.Full or (not Battle.IsBattleFull)) and
      (Filters.MapNotAvailable or (Utility.MapList.IndexOf(Battle.Map) >-1)) and
      (Filters.ModNotAvailable or (Utility.ModList.IndexOf(Battle.ModName) > -1)) and
      (Filters.InProgress or (not Battle.IsBattleInProgress)) and
      (Filters.NatTraversal or (Battle.NATType = 0)) and
      (Filters.Replays or (Battle.BattleType = 0)) and
      (Filters.RankLimitSupEqMine or (Battle.RankLimit <= Status.Me.GetRank)) and
      (
      (Filters.Replays and (Battle.BattleType = 1)) or
      not Filters.Players.enabled or
      ((Filters.Players.filterType = Sup) and ((Battle.Clients.Count-Battle.SpectatorCount) > Filters.Players.value)) or
      ((Filters.Players.filterType = Inf) and ((Battle.Clients.Count-Battle.SpectatorCount) < Filters.Players.value)) or
      ((Filters.Players.filterType = Equal) and ((Battle.Clients.Count-Battle.SpectatorCount) = Filters.Players.value))
      ) and (
      not Filters.MaxPlayers.enabled or
      ((Filters.MaxPlayers.filterType = Sup) and (Battle.MaxPlayers > Filters.MaxPlayers.value)) or
      ((Filters.MaxPlayers.filterType = Inf) and (Battle.MaxPlayers < Filters.MaxPlayers.value)) or
      ((Filters.MaxPlayers.filterType = Equal) and (Battle.MaxPlayers = Filters.MaxPlayers.value))
      );
end;

procedure TMainForm.RefreshBattleList;
var
  i,j:integer;
  BattleNodeCount : integer;
  asc: ShortInt;
  tmp : TBattle;
  PTmpNode : PVirtualNode;
  nb:integer;
  caca : string;
begin
  if Status.ConnectionState <> Connected then Exit;

  while RefreshingBattleList do;
  RefreshingBattleList := true;
  
  if Preferences.BattleSortDirection=0 then asc := 1 else asc := -1;
  // simple bubble sort:
  for i := Battles.count-1 downto 0 do
    for j := 0 to i-1 do
      if asc * CompareBattles(TBattle(Battles[j]), TBattle(Battles[j+1]), Preferences.BattleSortStyle) > 0 then
      begin
        // swap:
        tmp := Battles[j];
        Battles[j] := Battles[j+1];
        Battles[j+1] := tmp;
      end;

  j:=0;
  for i:=0 to Battles.Count-1 do begin
    TBattle(Battles[i]).Visible := isBattleVisible(Battles[i]);
    if TBattle(Battles[i]).Visible then begin
      j:=j+1;
      //VDTBattles.DeleteNode(TBattle(Battles[i]).Node);
    end;
  end;
  
  nb := VDTBattles.RootNodeCount;
  if j > nb then begin
    for i:=nb to j-1 do begin
      VDTBattles.RootNodeCount := VDTBattles.RootNodeCount+1;
      PTmpNode := VDTBattles.GetLast;
    end
  end
  else
  begin
    for i:=nb downto j+1 do begin
      VDTBattles.DeleteNode(VDTBattles.GetFirst);
    end;
  end;

  PTmpNode := VDTBattles.GetFirst;
  for i:=0 to Battles.Count-1 do begin
    if TBattle(Battles[i]).Visible then begin
      TBattle(Battles[i]).Node := PTmpNode;
      PTmpNode := VDTBattles.GetNext(PTmpNode);
      //SortBattleInList(i, Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0);
    end
    else
      TBattle(Battles[i]).Node := nil;
  end;
  VDTBattles.Invalidate;
  RefreshingBattleList := false;
end;

{ updates position of battle with Index in List. It doesn't repaint VDTBattles, you should do that manually.
  If Ascending is False, then the list will be sorted in descending order. }
procedure TMainForm.SortBattleInList(Index: Integer; SortStyle: Byte; Ascending: Boolean);
var
  i,j: Integer;
  tmp: TBattle;
  tmpNode: PVirtualNode;
  asc: ShortInt;
begin

  if (Index < 0) or (Index > Battles.Count-1) then Exit; // this should not happen!

  if Ascending then asc := 1 else asc := -1;

  // sort down:
  {*for i := Index+1 to Battles.Count-1 do
    if (asc * CompareBattles(TBattle(Battles[Index]), TBattle(Battles[i]), SortStyle) > 0) or not TBattle(Battles[i]).Visible then
    begin
      if TBattle(Battles[i]).Visible then begin
        // swap nodes
        tmpNode := TBattle(Battles[i]).Node;
        TBattle(Battles[i]).Node := TBattle(Battles[Index]).Node;
        TBattle(Battles[Index]).Node := tmpNode;
      end;
        // swap:
        tmp := Battles[i];
        Battles[i] := Battles[Index];
        Battles[Index] := tmp;
        Index:=i;
    end
    else break;

  // sort up:
  for i := Index-1 downto 0 do begin
    if (asc * CompareBattles(TBattle(Battles[Index]), TBattle(Battles[i]), SortStyle) < 0) or not TBattle(Battles[i]).Visible then
    begin
      if TBattle(Battles[i]).Visible then begin
        // swap nodes
        tmpNode := TBattle(Battles[i]).Node;
        TBattle(Battles[i]).Node := TBattle(Battles[Index]).Node;
        TBattle(Battles[Index]).Node := tmpNode;
      end;
        // swap:
        tmp := Battles[i];
        Battles[i] := Battles[Index];
        Battles[Index] := tmp;
        Index:=i;
    end
    else break;
  end;*}
  for i := Index+1 to Battles.Count-1 do
    if (asc * CompareBattles(TBattle(Battles[Index]), TBattle(Battles[i]), SortStyle) > 0) then
    begin
        // swap:
        tmp := Battles[i];
        Battles[i] := Battles[Index];
        Battles[Index] := tmp;
        Inc(Index);
    end
    else break;

  // sort up:
  for i := Index-1 downto 0 do begin
    if (asc * CompareBattles(TBattle(Battles[Index]), TBattle(Battles[i]), SortStyle) < 0) then
    begin
        // swap:
        tmp := Battles[i];
        Battles[i] := Battles[Index];
        Battles[Index] := tmp;
        Dec(Index);
    end
    else break;
  end;
  j:=0;
  tmpNode := nil;
  tmpNode := VDTBattles.GetFirst();
  for i:=0 to Battles.Count-1 do
    if TBattle(Battles[i]).Visible then begin
      TBattle(Battles[i]).Node := tmpNode;
      tmpNode := VDTBattles.GetNext(tmpNode);
    end
    else
    begin
      j := j+1;
    end;
   //BattleScreenSpeedButton.Caption := IntToStr(j);  
end;

procedure TMainForm.SortMenuItemClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  Preferences.SortStyle := (Sender as TMenuItem).Tag;
  SortLabel.Caption := (Sender as TMenuItem).Caption;
  RefreshClientSort;
end;

procedure TMainForm.VDTBattlesGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
var
  Battle: TBattle;
  i : integer;
begin
  R := Rect(0, 0, 0, 0);
  Battle := GetBattleFromNode(Node);

  with (Sender as TVirtualDrawTree) do
    if Header.Columns[Column].Text = 'Players' then
      R := Rect(0, 0, Canvas.TextWidth(Battle.ClientsToString) + 20, 18)
    else if Header.Columns[Column].Text = 'Mod' then
      R := Rect(0, 0, Canvas.TextWidth(Battle.ModName) + 20, 18)
    else if Header.Columns[Column].Text = 'State' then
      if Battle.Locked then
        R := Rect(0, 0, Canvas.TextWidth('Locked') + 20, 18)
      else // ignore
    else if Header.Columns[Column].Text = 'Map' then
    begin
      if Utility.MapList.IndexOf(Battle.Map) > -1 then
        R := Rect(0, 0, 110+250, 120)
      else
        R := Rect(0, 0, Canvas.TextWidth(Battle.Map) + 20, 18);
    end
    else if Header.Columns[Column].Text = 'Host' then
      R := Rect(0, 0, Canvas.TextWidth(TClient(Battle.Clients[0]).Name) + 20, 18)
    else if Header.Columns[Column].Text = 'Description' then
      R := Rect(0, 0, Canvas.TextWidth(Battle.Description) + 20, 18)
end;

procedure TMainForm.VDTBattlesDrawHint(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  Battle : TBattle;
  i:integer;
begin
  with Sender as TVirtualDrawTree, HintCanvas do
  begin
    Battle := GetBattleFromNode(Node);
    Pen.Color := clBlack;
    Brush.Color := $00ffdddd; { 0 b g r }
    Brush.Style := bsSolid;
    Rectangle(ClipRect);
    Brush.Style := bsClear;

    if Header.Columns[Column].Text = 'Players' then
      TextOut(5, 2, Battle.ClientsToString)
    else if Header.Columns[Column].Text = 'Mod' then
      TextOut(5, 2, Battle.ModName)
    else if Header.Columns[Column].Text = 'State' then
      if Battle.Locked then
        TextOut(5, 2, 'Locked')
      else // ignore it
    else if Header.Columns[Column].Text = 'Map' then
    begin
      if Utility.MapList.IndexOf(Battle.Map) > -1 then
      begin
        with TMapItem(MapListForm.Maps[Utility.MapList.IndexOf(Battle.Map)]) do
        begin
          StretchDraw(Rect(10,10,110,110),MapImage.Picture.Bitmap);
          Font.Style := [fsBold];
          TextOut(120, 10, MapName);
          Font.Style := [];
          TextOut(120, 10+TextHeight(MapName), 'Map size: '+IntToStr(MapInfo.Width div 64)+'x'+IntToStr(MapInfo.Height div 64));
          TextOut(120, 10+TextHeight(MapName)*2, 'Max. metal: '+FloatToStr(MapInfo.MaxMetal));
          TextOut(120, 10+TextHeight(MapName)*3, 'Wind (min/max): '+IntToStr(MapInfo.MinWind)+'-'+IntToStr(MapInfo.MaxWind));
          DrawMultilineText(MapInfo.Description,HintCanvas,Rect(120,10+10+TextHeight(MapName)*4,R.Right-10,R.Bottom-5),alHLeft,alVTop,JustLeft,true);
        end;
      end
      else
        TextOut(5, 2, Battle.Map);
    end
    else if Header.Columns[Column].Text = 'Host' then
      TextOut(5, 2, TClient(Battle.Clients[0]).Name)
    else if Header.Columns[Column].Text = 'Description' then
      TextOut(5, 2, Battle.Description);

  end;
end;

procedure TMainForm.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
   // left right or middle click or mouse wheel = set away status to back
   if (Msg.message = Messages.WM_LBUTTONDOWN) or (Msg.message = Messages.WM_RBUTTONDOWN) or (Msg.message = Messages.WM_MBUTTONDOWN) or (Msg.message = Messages.WM_MOUSEWHEEL) then
    AutoSetBack;
   If Msg.message = Messages.WM_MOUSEWHEEL then
   begin
     if OnlineMapsForm.Active then // when in SelectMapForm scrollbars should scroll through available maps
     begin
       if Msg.wParam > 0 then OnlineMapsForm.ScrollBox1.VertScrollBar.Position := OnlineMapsForm.ScrollBox1.VertScrollBar.Position - OnlineMapsForm.ScrollBox1.VertScrollBar.Increment // Scroll Up
         else OnlineMapsForm.ScrollBox1.VertScrollBar.Position := OnlineMapsForm.ScrollBox1.VertScrollBar.Position + OnlineMapsForm.ScrollBox1.VertScrollBar.Increment; // Scroll Down
     end;

     if MapListForm.Active then // when in MapListForm scrollbars should scroll through available maps
     begin
       if Msg.wParam > 0 then MapListForm.ScrollBox1.VertScrollBar.Position := MapListForm.ScrollBox1.VertScrollBar.Position - MapListForm.ScrollBox1.VertScrollBar.Increment // Scroll Up
         else MapListForm.ScrollBox1.VertScrollBar.Position := MapListForm.ScrollBox1.VertScrollBar.Position + MapListForm.ScrollBox1.VertScrollBar.Increment; // Scroll Down
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
  groupStr: String;
begin

  tmp := (Sender as TlistBox).ItemAtPos(Point(X, Y), True);
  if tmp = -1 then
  begin
    (Sender as TlistBox).Hint := '';
    Exit;
  end;

  try
    if PageControl1.ActivePage.Caption = LOCAL_TAB then
    begin
      groupStr := '';
      if TClient(AllClients[tmp]).GetGroup > -1 then
        groupStr := ', '+TClientGroup(ClientGroups[TClient(AllClients[tmp]).GetGroup]).Name;
      (Sender as TlistBox).Hint := TClient(AllClients[tmp]).Name + ', ' + GetCountryName(TClient(AllClients[tmp]).Country)+groupStr;
    end
    else
    begin
      groupStr := '';
      if TClient((PageControl1.ActivePage as TMyTabSheet).Clients[tmp]).GetGroup > -1 then
        groupStr := ', '+TClientGroup(ClientGroups[TClient((PageControl1.ActivePage as TMyTabSheet).Clients[tmp]).GetGroup]).Name;
      (Sender as TlistBox).Hint := TClient((PageControl1.ActivePage as TMyTabSheet).Clients[tmp]).Name + ', ' + GetCountryName(TClient((PageControl1.ActivePage as TMyTabSheet).Clients[tmp]).Country)+groupStr;
      if TClient((PageControl1.ActivePage as TMyTabSheet).Clients[tmp]).CupLadderList.Count > 0 then
        (Sender as TlistBox).Hint := (Sender as TlistBox).Hint + ', '+Misc.JoinStringList(TClient((PageControl1.ActivePage as TMyTabSheet).Clients[tmp]).CupLadderList,', ')
    end;
  except
  end;
end;

procedure TMainForm.RichEditPopupMenuPopup(Sender: TObject);
var
  i : Integer;
begin
  with (Sender as TSpTBXPopupMenu) do
  begin
    (Items[Items.IndexOf(AutoScroll1)] as TSpTBXItem).Visible := Misc.DetectWine or RunningUnderWine;
    (Items[Items.IndexOf(AutoScroll1)] as TSpTBXItem).Checked := (PageControl1.ActivePage as TMyTabSheet).AutoScroll;
    (Items[Items.IndexOf(AutoJoin1)] as TSpTBXItem).Visible := (PageControl1.ActivePage.Caption <> '$Local') and (PageControl1.ActivePage.Caption <> '#main') and (LeftStr(PageControl1.ActivePage.Caption,1) = '#');
    (Items[Items.IndexOf(AutoJoin1)] as TSpTBXItem).Checked := True;
    for i:=0 to PerformForm.CommandsListBox.Count-1 do
      if (AnsiUpperCase(PerformForm.CommandsListBox.Items[i]) = '/J '+AnsiUpperCase(PageControl1.ActivePage.Caption)) or (AnsiUpperCase(PerformForm.CommandsListBox.Items[i]) = '/JOIN '+AnsiUpperCase(PageControl1.ActivePage.Caption)) then
        Exit;
    (Items[Items.IndexOf(AutoJoin1)] as TSpTBXItem).Checked := False;
  end;
end;

procedure TMainForm.AutoScroll1Click(Sender: TObject);
begin
  (PageControl1.ActivePage as TMyTabSheet).AutoScroll := not (PageControl1.ActivePage as TMyTabSheet).AutoScroll;
end;

procedure TMainForm.AddNotification(HeaderText, MessageText: string; DisplayTime: Integer;OnClick: Boolean = false;BattleId: integer = -1);
var
  DA: TJvDesktopAlert;
begin
  if Preferences.UseSoundNotifications then
    if not Preferences.DisableAllSounds then PlayResSound('notify');
  if (BattleState.Status <> None) and (BattleState.Battle.IsBattleInProgress) then
    Exit;
  DA := TJvDesktopAlert.Create(Self);
  DA.HeaderText := HeaderText;
  DA.MessageText := MessageText;
  if OnClick then
    DA.Options := [daoCanClose,daoCanClick]
  else
    DA.Options := [daoCanClose];
  if displayingNotificationList.Count >= MAX_POPUP then
    TJvDesktopAlert(displayingNotificationList.First).Close(True);
  displayingNotificationList.Add(DA);
  DA.Location.Position := dapBottomRight;
  DA.StyleHandler.DisplayDuration := DisplayTime;
  DA.Location.Width := 250;
  DA.Location.Height := 70;
  DA.AlertStyle := asFade;
  DA.OnMessageClick := NotificationClick;
  DA.OnClose := NotificationClose;
  DA.Tag := BattleId;
  DA.Execute;
end;

procedure TMainForm.NotificationClose(Sender: TObject);
begin
  displayingNotificationList.Remove(Sender);
end;

procedure TMainForm.NotificationClick(Sender: TObject);
var
  i: integer;
begin
  if (Sender as TJvDesktopAlert).Tag = -1 then
    Exit;
  for i:=0 to Battles.Count-1 do
    if TBattle(Battles[i]).ID = (Sender as TJvDesktopAlert).Tag then begin
      JoinBattle(Battles[i]);
      break;
    end;
end;

procedure TMainForm.VDTBattlesHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  // note: when moving columns, their indexes remain the same!
  // (so the header of the first column may not have index 0)

  if VDTBattles.Header.SortColumn = Column then
    if Preferences.BattleSortDirection = 0 then Preferences.BattleSortDirection := 1
    else Preferences.BattleSortDirection := 0
  else Preferences.BattleSortDirection := 0;
    
  Preferences.BattleSortStyle := PreferencesForm.ColumnToBattleSortStyle(Column);
  VDTBattles.Header.SortColumn := Column;
  if Preferences.BattleSortDirection = 0 then VDTBattles.Header.SortDirection := sdAscending else VDTBattles.Header.SortDirection := sdDescending;
  SortBattlesList(Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0);
  VDTBattles.Invalidate;
end;

procedure TMainForm.ClientsListBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  p := (Sender as TControl).ClientToScreen(Point(X, Y));
  if Button = mbRight then
  begin
    if ClientsListBox.ItemIndex > -1 then
    begin
      ClientPopupMenu.Popup(p.X, p.Y);
    end;
  end;
end;

procedure TMainForm.ClientsListBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // auto select item on right click:
  if Button = mbRight then
  begin
    ClientsListBox.ItemIndex := ClientsListBox.ItemAtPos(Point(X, Y), True);
    ClientPopupMenuInitPopup(nil,nil);
  end;
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

procedure TMainForm.mnuOpenPrivateChatClick(Sender: TObject);
begin
  OpenPrivateChat(SelectedUserName);
end;

procedure TMainForm.mnuSelectBattleClick(Sender: TObject);
var
  i,j:integer;
  ClientName : String;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item
  VDTBattles.ClearSelection;
  VDTBattles.FocusedNode := nil;
  for i:=0 to Battles.Count-1 do
    if TBattle(Battles[i]).Visible then begin
      for j:=0 to TBattle(Battles[i]).Clients.Count-1 do
        if TClient(TBattle(Battles[i]).Clients[j]).Name = SelectedUserName then begin
          VDTBattles.Selected[TBattle(Battles[i]).Node] := True;
          VDTBattles.FocusedNode := TBattle(Battles[i]).Node;
          VDTBattles.SetFocus;
          Exit;
        end;
    end;
end;

procedure TMainForm.SpTBXItem1Click(Sender: TObject);
var
  i,j:integer;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item

  for i:=0 to Battles.Count-1 do begin
      for j:=0 to TBattle(Battles[i]).Clients.Count-1 do
        if TClient(TBattle(Battles[i]).Clients[j]).Name = SelectedUserName then begin
          JoinBattle(Battles[i]);
          Exit;
        end;
  end;
end;

constructor TReplay.Create;
begin
  PlayerList := TList.Create;
end;

destructor TReplay.Destroy;
var
  i:integer;
begin
  for i := 0 to PlayerList.Count-1 do
  begin
    TReplayPlayer(PlayerList[i]^).free;
    FreeMem(PlayerList[i]);
  end;
  PlayerList.Free;
  Script.Free;
  inherited Destroy;
end;

function TReplay.GetSpectatorCount: integer;
var
  i:integer;
begin
  result := 0;
  for i:=0 to PlayerList.Count-1 do
    if TReplayPlayer(PlayerList[i]).Spectator then
      Result := Result + 1;
end;

function TReplay.GetLength: integer;
begin
  if Version = 0 then
    Result := 0
  else
    Result := demoHeader.gameTime;
end;

function TReplay.GetTeamCount: integer;
var
  count: integer;
  tmp: string;
begin
  count := 0;
  while true do
  begin
    tmp := Script.ReadKeyValue('GAME/AllyTeam'+IntToStr(count));
    if tmp = '' then
      Exit;
    count := count +1;
  end;
  result := count;
end;

constructor TClientGroup.Create(Name: string; Color: Integer);
begin
  Self.Clients := TStringList.Create;
  Self.Name := Name;
  Self.Color := Color;
  Self.AutoKick := False;
  Self.AutoSpec := False;
  Self.NotifyOnHost := False;
  Self.NotifyOnJoin := False;
  Self.NotifyOnBattleEnd := False;
  Self.NotifyOnConnect := False;
end;

destructor TClientGroup.Destroy;
begin
  Self.Clients.Destroy;
end;

procedure TMainForm.mnuManageGroupsClick(Sender: TObject);
begin
  ManageGroupsForm.ShowModal;
end;

procedure TMainForm.mnuNewGroupClick(Sender: TObject);
var
  InputString: string;
  group : TClientGroup;
  i: integer;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item
  InputString:= 'New group '+IntToStr(ClientGroups.Count+1);
  if InputQuery('New group ...', 'Enter the group name :', InputString) then begin
    group := TClientGroup.Create(InputString,InputColor('Choose a group highlight color ...',clWhite));
    group.Clients.Add(SelectedUserName);
    ClientGroups.Add(group);
    RefreshClientSort;
  end;
end;

procedure TMainForm.AddToGroupItemClick(Sender: TObject);
var
  ClientName: String;
  i:integer;
begin
  ClientName := SelectedUserName;
  TClientGroup(ClientGroups[(Sender as TSpTBXItem).Tag]).Clients.Add(ClientName);
  RefreshClientSort;
end;

procedure TMainForm.RefreshClientSort;
var
  i:integer;
begin
  SortClientsList(AllClients, Preferences.SortStyle);
  for i := 1 {start from 1 to skip LOCAL_TAB} to PageControl1.PageCount-1 do
    SortClientsList((PageControl1.Pages[i] as TMyTabSheet).Clients, Preferences.SortStyle);
  UpdateClientsListBox;
end;

procedure TMainForm.ClientsListBoxClick(Sender: TObject);
begin
  ClientsListBox.Refresh;
end;

procedure TMainForm.mnuRemoveFromGroupClick(Sender: TObject);
var
  Client : TClient;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item
  if GetClientIndexEx(SelectedUserName,AllClients) = -1 then Exit;
  Client := TClient(AllClients[GetClientIndexEx(SelectedUserName,AllClients)]);
  TClientGroup(ClientGroups[Client.GetGroup]).Clients.Delete(TClientGroup(ClientGroups[Client.GetGroup]).Clients.IndexOf(Client.Name));
  RefreshClientSort;
  MainForm.ClientsListBox.Refresh;
end;

procedure TMainForm.SaveGroups;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
begin
  try
    Filename := VAR_FOLDER + '\' + 'groups.ini';
    if FileExists(Filename) then
      DeleteFile(Filename);
    Ini := TIniFile.Create(Filename);
    for i:=0 to ClientGroups.Count-1 do begin
      Ini.WriteString(IntToStr(i), 'Name', TClientGroup(ClientGroups[i]).Name);
      Ini.WriteString(IntToStr(i), 'Color', IntToStr(TClientGroup(ClientGroups[i]).Color));
      Ini.WriteString(IntToStr(i), 'AutoKick', BoolToStr(TClientGroup(ClientGroups[i]).AutoKick));
      Ini.WriteString(IntToStr(i), 'AutoSpec', BoolToStr(TClientGroup(ClientGroups[i]).AutoSpec));
      Ini.WriteString(IntToStr(i), 'NotifyOnHost', BoolToStr(TClientGroup(ClientGroups[i]).NotifyOnHost));
      Ini.WriteString(IntToStr(i), 'NotifyOnJoin', BoolToStr(TClientGroup(ClientGroups[i]).NotifyOnJoin));
      Ini.WriteString(IntToStr(i), 'NotifyOnBattleEnd', BoolToStr(TClientGroup(ClientGroups[i]).NotifyOnBattleEnd));
      Ini.WriteString(IntToStr(i), 'NotifyOnConnect', BoolToStr(TClientGroup(ClientGroups[i]).NotifyOnConnect));
      Ini.WriteString(IntToStr(i), 'HighlightBattles', BoolToStr(TClientGroup(ClientGroups[i]).HighlightBattles));
      Ini.WriteString(IntToStr(i), 'Clients', Misc.JoinStringList(TClientGroup(ClientGroups[i]).Clients,' '));
    end;
    Ini.Free;
  except
    Exit;
  end;
end;

procedure TMainForm.LoadGroups;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
  cg : TClientGroup;
begin
  // because i moved the groups.ini to the var folder
  MoveFile(LOBBY_FOLDER + '\' + 'groups.ini',VAR_FOLDER + '\' + 'groups.ini');
  Filename := VAR_FOLDER + '\' + 'groups.ini';
  Ini := TIniFile.Create(Filename);
  i := 0;
  while Ini.SectionExists(IntToStr(i)) do begin
    cg := TClientGroup.Create('empty',0);
    cg.Name := Ini.ReadString(IntToStr(i), 'Name', 'Empty');
    cg.Color := StrToInt(Ini.ReadString(IntToStr(i), 'Color', 'Empty'));
    cg.AutoKick := StrToBool(Ini.ReadString(IntToStr(i), 'AutoKick', '0'));
    cg.AutoSpec := StrToBool(Ini.ReadString(IntToStr(i), 'AutoSpec', '0'));
    cg.NotifyOnHost := StrToBool(Ini.ReadString(IntToStr(i), 'NotifyOnHost', '0'));
    cg.NotifyOnJoin := StrToBool(Ini.ReadString(IntToStr(i), 'NotifyOnJoin', '0'));
    cg.NotifyOnBattleEnd := StrToBool(Ini.ReadString(IntToStr(i), 'NotifyOnBattleEnd', '0'));
    cg.NotifyOnConnect := StrToBool(Ini.ReadString(IntToStr(i), 'NotifyOnConnect', '0'));
    cg.HighlightBattles := StrToBool(Ini.ReadString(IntToStr(i), 'HighlightBattles', '0'));
    Misc.ParseDelimited(cg.Clients,Ini.ReadString(IntToStr(i), 'Clients', 'Empty'),' ','');
    ClientGroups.Add(cg);
    i := i+1;
  end;
  Ini.Free;
end;

procedure TMainForm.SaveAwayMessages;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
begin
  try
    Filename := VAR_FOLDER + '\' + 'away_messages.ini';
    if FileExists(Filename) then
      DeleteFile(Filename);
    Ini := TIniFile.Create(Filename);
    i := 0;
    for i:=0 to AwayMessages.Titles.Count-1 do begin
      Ini.WriteString(IntToStr(i), 'Title', AwayMessages.Titles[i]);
      Ini.WriteString(IntToStr(i), 'Message', AwayMessages.Messages[i]);
    end;
    Ini.Free;
  except
    Exit;
  end;
end;

procedure TMainForm.LoadAwayMessages;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
begin
  Filename := VAR_FOLDER + '\' + 'away_messages.ini';
  AwayMessages.Titles := TStringList.Create;
  AwayMessages.Messages := TStringList.Create;
  Ini := TIniFile.Create(Filename);
  i := 0;
  while Ini.SectionExists(IntToStr(i)) do begin
    AwayMessages.Titles.Add(Ini.ReadString(IntToStr(i), 'Title', 'Empty'));
    AwayMessages.Messages.Add(Ini.ReadString(IntToStr(i), 'Message', 'Empty'));
    i := i+1;
  end;
  Ini.Free;
end;

procedure TMainForm.mnuHelpClick(Sender: TObject);
begin
    HelpForm.ShowModal;
end;

procedure TMainForm.mnuSpringmarkClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://www.jobjol.com/springmark.html');
end;

procedure TMainForm.mnuSpringLadderClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://springladder.no-ip.org/');
end;

procedure TMainForm.mnuSpringReplaysClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://replays.unknown-files.net/');
end;

procedure TMainForm.mnuUnknownFilesClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring.jobjol.nl');
end;

procedure TMainForm.mnuBugTrackerClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring.clan-sy.com/mantis/');
end;

procedure TMainForm.mnuMessageboardClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring.clan-sy.com/phpbb/index.php');
end;

procedure TMainForm.mnuSpringHomePageClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring.clan-sy.com/');
end;

procedure TMainForm.CheckNewVersion;
var
  checkThread : TCheckNewBetaLobbyThread;
begin
  checkThread := TCheckNewBetaLobbyThread.Create(false,false);
end;

constructor TLadder.Create(id: integer; Name: string);
begin
  Self.id := id;
  Self.Name := Name;
  Self.Restricted := TStringList.Create;
  Self.Maps := TStringList.Create;
end;

procedure TDialogThread.ShowLastMessage;
begin
  MessageDlgReturn := MessageDlg(MsgT,DlgTypeT,ButtonsT,HelpCtxT);
end;

procedure TDialogThread.ShowInputBox;
begin
  InputBoxReturn := InputBox(ACaptionT,APromptT,ADefaultT);
end;

function TDialogThread.MessageDlgThread(const Msg: string; DlgType: TMsgDlgType;Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  MsgT := Msg;
  DlgTypeT := DlgType;
  ButtonsT := Buttons;
  HelpCtxT := HelpCtx;
  Synchronize(ShowLastMessage);
  Result := MessageDlgReturn;
end;

function TDialogThread.InputBoxThread(const ACaption, APrompt, ADefault: string): string;
begin
  ACaptionT := ACaption;
  APromptT := APrompt;
  ADefaultT := ADefault;
  Synchronize(ShowInputBox);
  Result := InputBoxReturn;
end;

procedure TMainForm.mnuBattleScreenClick(Sender: TObject);
begin
  BattleForm.Show;
end;

procedure TMainForm.menuHostBattleClick(Sender: TObject);
begin
  HostButtonMenuIndex := 0;
  BattleForm.HostButton.OnClick(nil);
  BattleForm.Show;
end;

procedure TMainForm.mnuHostLadderBattleClick(Sender: TObject);
begin
  HostButtonMenuIndex := 1;
  BattleForm.HostButton.OnClick(nil);
  BattleForm.Show;
end;

procedure TMainForm.mnuHostReplayClick(Sender: TObject);
begin
  HostButtonMenuIndex := 2;
  BattleForm.HostButton.OnClick(nil);
  BattleForm.Show;
end;

procedure TMainForm.SpTBXItem6Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://quickstart.zjt3.com/');
end;

procedure TMainForm.AutoJoin1Click(Sender: TObject);
var
  i : integer;
begin
  if (Sender as TSpTBXItem).Checked = False then
    PerformForm.CommandsListBox.Items.Add('/j '+PageControl1.ActivePage.Caption)
  else
  begin
    for i:=0 to PerformForm.CommandsListBox.Items.Count -1 do
      if (AnsiUpperCase(PerformForm.CommandsListBox.Items[i]) = '/J '+AnsiUpperCase(PageControl1.ActivePage.Caption)) or (AnsiUpperCase(PerformForm.CommandsListBox.Items[i]) = '/JOIN '+AnsiUpperCase(PageControl1.ActivePage.Caption)) then begin
        PerformForm.CommandsListBox.Items.Delete(i);
        Exit;
      end;
  end;
end;

procedure TMainForm.mnuAwayClick(Sender: TObject);
begin
    SetAway(-1);
end;

procedure TMainForm.mnuBackClick(Sender: TObject);
begin
    if Status.Me = nil then Exit; // should not happen!
    if Status.Me.GetAwayStatus then // no need to set to available if already available
    begin
      Status.Me.SetAwayStatus(False);
      MainForm.TryToSendCommand('MYSTATUS', IntToStr(Status.Me.Status));
    end;
    Status.CurrentAwayItem := -2;
end;

procedure TMainForm.mnuNewAwayMsgClick(Sender: TObject);
begin
  AwayMessageForm.ShowModal;
end;

procedure TMainForm.AwayMessageItemClick(Sender: TObject);
begin
  SetAway((Sender as TSpTBXItem).Tag);
end;

procedure TMainForm.RemoveAwayMessageItemClick(Sender: TObject);
begin
  AwayMessages.Titles.Delete((Sender as TSpTBXItem).Tag);
  AwayMessages.Messages.Delete((Sender as TSpTBXItem).Tag);
end;

procedure TMainForm.ConnectionPopupMenuPopup(Sender: TObject);
var
  i:integer;
begin
  // delete the custom away messages items
  for i:= ConnectionPopupMenu.Items.Count -1 downto 6 do
    ConnectionPopupMenu.Items.Delete(i);

  ConnectionPopupMenu.Items[0].Checked := Status.CurrentAwayItem = -2;
  ConnectionPopupMenu.Items[1].Checked := Status.CurrentAwayItem = -1;

  // insert new item for each away message
  for i:=0 to AwayMessages.Titles.Count-1 do
  begin
    ConnectionPopupMenu.Items.Add(TSpTBXItem.Create(ConnectionPopupMenu));
    with ConnectionPopupMenu.Items[ConnectionPopupMenu.Items.Count-1] as TSpTBXItem do
    begin
      Caption := AwayMessages.Titles[i];
      Checked := Status.CurrentAwayItem = i;
      Tag := i;
      OnClick := AwayMessageItemClick;
    end;
  end;

  RemoveMenu.Clear;
  // insert new item for each away message to remove
  for i:=0 to AwayMessages.Titles.Count-1 do
  begin
    RemoveMenu.Add(TSpTBXItem.Create(ConnectionPopupMenu));
    with RemoveMenu.Items[RemoveMenu.Count-1] as TSpTBXItem do
    begin
      Caption := AwayMessages.Titles[i];
      Tag := i;
      OnClick := RemoveAwayMessageItemClick;
    end;
  end;
  RemoveMenu.Visible := AwayMessages.Titles.Count > 0;

  // grayed if not connected
  for i:=0 to ConnectionPopupMenu.Items.Count -1 do
      ConnectionPopupMenu.Items[i].Enabled := Status.ConnectionState = Connected;
end;

procedure TMainForm.SetAway(AwayIndex: integer);
var
  i:integer;
begin
  for i:=0 to AllClients.Count-1 do
    TClient(AllClients[i]).AwayMessageSent := False;
  if Status.Me = nil then Exit; // should not happen!
  if not Status.Me.GetAwayStatus then // no need to set to away if already away
  begin
    Status.Me.SetAwayStatus(True);
    MainForm.TryToSendCommand('MYSTATUS', IntToStr(Status.Me.Status));
  end;
  if AwayIndex = -1 then
    Status.CurrentAwayMessage := AWAY_DEFAULT_MSG
  else
    Status.CurrentAwayMessage := AwayMessages.Messages[AwayIndex];
    
  Status.CurrentAwayItem := AwayIndex;
  Status.AutoAway := False;
end;

procedure TMainForm.Copy1Click(Sender: TObject);
begin
  (PageControl1.ActivePage.Controls[1] as TTntRichEdit).CopyToClipboard;
end;

procedure TMainForm.mnuIgnoreClick(Sender: TObject);
var
  Client: TClient;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item

  if mnuIgnore.Checked then
    IgnoreListForm.IgnoreListBox.Items.Delete(IgnoreListForm.IgnoreListBox.Items.IndexOf(SelectedUserName))
  else
  begin
    IgnoreListForm.EnableIgnoresCheckBox.Checked := True;
    Preferences.UseIgnoreList := True;
    IgnoreListForm.AddToIgnoreList(SelectedUserName);
  end;
end;

procedure TMainForm.FiltersButtonClick(Sender: TObject);
begin
  if FiltersButton.ImageIndex = 0 then
  begin
    FilterGroup.Height := 173;
    FiltersButton.ImageIndex := 1;
  end
  else
  begin
    FilterGroup.Height := 0;
    FiltersButton.ImageIndex := 0;
  end;
end;

procedure TMainForm.AddToFilterListButtonClick(Sender: TObject);
var
  f: ^TFilterText;
begin
  if FilterValueTextBox.Text = '' then Exit;
  New(f);
  case FilterListCombo.ItemIndex of
    0:f^.filterType := HostName;
    1:f^.filterType := MapName;
    2:f^.filterType := ModName;
    3:f^.filterType := Description;
  end;
  f^.node := nil;
  f^.contains := ContainsRadio.Checked;
  f^.value := FilterValueTextBox.Text;
  Filters.TextFilters.Add(f);
  f^.Node := FilterList.AddChild(FilterList.RootNode);
  f^.Node.CheckType := ctCheckBox;
  f^.Node.CheckState := csCheckedNormal;
  f^.enabled := True;
  FilterList.Invalidate;
  FilterValueTextBox.Text := '';
  RefreshBattleList;
end;

procedure TMainForm.PlayersSignButtonClick(Sender: TObject);
begin
  if PlayersSignButton.Caption = '>' then
  begin
    PlayersSignButton.Caption := '<';
    Filters.Players.filterType := Inf;
  end
  else if PlayersSignButton.Caption = '<' then
  begin
    PlayersSignButton.Caption := '=';
    Filters.Players.filterType := Equal;
  end
  else
  begin
    PlayersSignButton.Caption := '>';
    Filters.Players.filterType := Sup;
  end;
  RefreshBattleList;
end;

procedure TMainForm.MaxPlayersSignButtonClick(Sender: TObject);
begin
  if MaxPlayersSignButton.Caption = '>' then
  begin
    MaxPlayersSignButton.Caption := '<';
    Filters.MaxPlayers.filterType := Inf;
  end
  else if MaxPlayersSignButton.Caption = '<' then
  begin
    MaxPlayersSignButton.Caption := '=';
    Filters.MaxPlayers.filterType := Equal;
  end
  else
  begin
    MaxPlayersSignButton.Caption := '>';
    Filters.MaxPlayers.filterType := Sup;
  end;
  RefreshBattleList;
end;

procedure TMainForm.PlayersValueTextBoxChange(Sender: TObject);
begin
  Filters.Players.value := PlayersValueTextBox.AsInteger;
  RefreshBattleList;
end;

procedure TMainForm.MaxPlayersValueTextBoxChange(Sender: TObject);
begin
  Filters.MaxPlayers.value := MaxPlayersValueTextBox.AsInteger;
  RefreshBattleList;
end;

procedure TMainForm.FullFilterClick(Sender: TObject);
begin
  Filters.Full := FullFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.InProgressFilterClick(Sender: TObject);
begin
  Filters.InProgress := InProgressFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.LadderFilterClick(Sender: TObject);
begin
  Filters.Ladder := LadderFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.LockedFilterClick(Sender: TObject);
begin
  Filters.Locked := LockedFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.PasswordedFilterClick(Sender: TObject);
begin
  Filters.Passworded := PasswordedFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.NatTraversalFilterClick(Sender: TObject);
begin
  Filters.NatTraversal := NatTraversalFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.RankLimitFilterClick(Sender: TObject);
begin
  Filters.RankLimitSupEqMine := RankLimitFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.MapsNotAvailableFilterClick(Sender: TObject);
begin
  Filters.MapNotAvailable := MapsNotAvailableFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.ModsNotAvailableFilterClick(Sender: TObject);
begin
  Filters.ModNotAvailable := ModsNotAvailableFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.FilterListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  filter : TFilterText;
begin
  filter := TFilterText(Filters.TextFilters[GetFilterIndexFromNode(node)]^);

  CellText := 'error';

  case Column of
    1:
      if filter.filterType = HostName then
        CellText := 'Host'
      else if filter.filterType = MapName then
        CellText := 'Map'
      else if filter.filterType = ModName then
        CellText := 'Mod'
      else if filter.filterType = Description then
        CellText := 'Description';
    2:
      if filter.contains then
        CellText := 'with'
      else
        CellText := 'without';
    3:CellText := filter.value;
  end;
end;

procedure TMainForm.FilterGroupResize(Sender: TObject);
begin
  FilterList.Width := FilterGroup.Width - 402;
end;

procedure TMainForm.ReplaysFilterClick(Sender: TObject);
begin
  Filters.Replays := ReplaysFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.EnableFiltersClick(Sender: TObject);
begin
  RefreshBattleList;
end;

procedure TMainForm.RemoveFromFilterListButtonClick(Sender: TObject);
var
  i: integer;
  n: PVirtualNode;
begin
  n := FilterList.GetFirstSelected;
  while n <> nil do
  begin
    Filters.TextFilters.Delete(GetFilterIndexFromNode(n));
    n := FilterList.GetNextSelected(n);
  end;
  FilterList.DeleteSelectedNodes;
  RefreshBattleList;
end;

procedure TMainForm.ClearFilterListButtonClick(Sender: TObject);
begin
  Filters.TextFilters.Clear;
  FilterList.Clear;
  RefreshBattleList;
end;

procedure TMainForm.mnuDisplayFiltersClick(Sender: TObject);
begin
  FiltersButton.OnClick(nil);
end;

procedure TMainForm.FilterListCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  filter : TFilterText;
  filter2 : TFilterText;
  text1: String;
  text2: String;
begin
  filter := TFilterText(Filters.TextFilters[GetFilterIndexFromNode(Node1)]^);

  case Column of
    1:
      if filter.filterType = HostName then
        text1 := 'Host'
      else if filter.filterType = MapName then
        text1 := 'Map'
      else if filter.filterType = ModName then
        text1 := 'Mod'
      else if filter.filterType = Description then
        text1 := 'Description';
    2:
      if filter.contains then
        text1 := 'with'
      else
        text1 := 'without';
    3:text1 := filter.value;
  end;

  filter2 := TFilterText(Filters.TextFilters[GetFilterIndexFromNode(Node2)]^);

  case Column of
    1:
      if filter2.filterType = HostName then
        text2 := 'Host'
      else if filter2.filterType = MapName then
        text2 := 'Map'
      else if filter2.filterType = ModName then
        text2 := 'Mod'
      else if filter2.filterType = Description then
        text2 := 'Description';
    2:
      if filter2.contains then
        text2 := 'with'
      else
        text2 := 'without';
    3:text2 := filter2.value;
  end;

  Result := AnsiCompareStr(text1, text2);
end;

procedure TMainForm.FilterListHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if FilterList.Header.SortColumn = Column then
    if FilterList.Header.SortDirection = sdDescending then
      FilterList.Header.SortDirection := sdAscending
    else
      FilterList.Header.SortDirection := sdDescending
  else
  begin
    FilterList.Header.SortColumn := Column;
    FilterList.Header.SortDirection := sdAscending
  end;
end;

procedure TMainForm.SaveFiltersToFile;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
begin
  try
    Filename := VAR_FOLDER + '\' + 'filters.ini';
    if FileExists(Filename) then
      DeleteFile(Filename);
    Ini := TIniFile.Create(Filename);
    i := 0;
    Ini.WriteBool('StaticFilters','Full',Filters.Full);
    Ini.WriteBool('StaticFilters','InProgress',Filters.InProgress);
    Ini.WriteBool('StaticFilters','Ladder',Filters.Ladder);
    Ini.WriteBool('StaticFilters','Locked',Filters.Locked);
    Ini.WriteBool('StaticFilters','Passworded',Filters.Passworded);
    Ini.WriteBool('StaticFilters','NatTraversal',Filters.NatTraversal);
    Ini.WriteBool('StaticFilters','RankLimitSupEqMine',Filters.RankLimitSupEqMine);
    Ini.WriteBool('StaticFilters','MapNotAvailable',Filters.MapNotAvailable);
    Ini.WriteBool('StaticFilters','ModNotAvailable',Filters.ModNotAvailable);
    Ini.WriteBool('StaticFilters','Replays',Filters.Replays);
    Ini.WriteBool('StaticFilters','Players',Filters.Players.enabled);
    Ini.WriteBool('StaticFilters','MaxPlayers',Filters.MaxPlayers.enabled);
  
    if Filters.Players.filterType = Sup then
      Ini.WriteString('StaticFilters','PlayersSign','sup')
    else if Filters.Players.filterType = Inf then
      Ini.WriteString('StaticFilters','PlayersSign','inf')
    else
      Ini.WriteString('StaticFilters','PlayersSign','equal');
    Ini.WriteInteger('StaticFilters','PlayersValue',Filters.Players.value);

    if Filters.MaxPlayers.filterType = Sup then
      Ini.WriteString('StaticFilters','MaxPlayersSign','sup')
    else if Filters.MaxPlayers.filterType = Inf then
      Ini.WriteString('StaticFilters','MaxPlayersSign','inf')
    else
      Ini.WriteString('StaticFilters','MaxPlayersSign','equal');
    Ini.WriteInteger('StaticFilters','MaxPlayersValue',Filters.MaxPlayers.value);
  
    for i:=0 to Filters.TextFilters.Count-1 do begin
      with TFilterText(Filters.TextFilters[i]^) do begin

        if filterType = HostName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Host')
        else if filterType = MapName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Map')
        else if filterType = ModName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Mod')
        else if filterType = Description then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Description');
        
        Ini.WriteBool('TextFilter'+IntToStr(i), 'Contains', contains);
        Ini.WriteString('TextFilter'+IntToStr(i), 'Value', value);
        Ini.WriteBool('TextFilter'+IntToStr(i), 'Enabled', enabled);
      end;
    end;
    Ini.Free;
  except
    Exit;
  end;
end;

procedure TMainForm.LoadFiltersFromFile;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
  tmpStr: String;
  f: ^TFilterText;
begin
  Filename := VAR_FOLDER + '\' + 'filters.ini';
  Ini := TIniFile.Create(Filename);
  i := 0;
  Filters.Full := Ini.ReadBool('StaticFilters', 'Full', True);
  Filters.InProgress := Ini.ReadBool('StaticFilters', 'InProgress', True);
  Filters.Ladder := Ini.ReadBool('StaticFilters', 'Ladder', True);
  Filters.Locked := Ini.ReadBool('StaticFilters', 'Locked', True);
  Filters.Passworded := Ini.ReadBool('StaticFilters', 'Passworded', True);
  Filters.NatTraversal := Ini.ReadBool('StaticFilters', 'NatTraversal', True);
  Filters.RankLimitSupEqMine := Ini.ReadBool('StaticFilters', 'RankLimitSupEqMine', True);
  Filters.MapNotAvailable := Ini.ReadBool('StaticFilters', 'MapNotAvailable', True);
  Filters.ModNotAvailable := Ini.ReadBool('StaticFilters', 'ModNotAvailable', True);
  Filters.Replays := Ini.ReadBool('StaticFilters', 'Replays', True);
  Filters.Players.enabled := Ini.ReadBool('StaticFilters', 'Players', False);
  Filters.MaxPlayers.enabled := Ini.ReadBool('StaticFilters', 'MaxPlayers', False);

  tmpStr := Ini.ReadString('StaticFilters', 'PlayersSign', 'sup');
  if tmpStr = 'sup' then
    Filters.Players.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Players.filterType := Inf
  else
    Filters.Players.filterType := Equal;
  Filters.Players.value := Ini.ReadInteger('StaticFilters', 'PlayersValue', 0);

  tmpStr := Ini.ReadString('StaticFilters', 'MaxPlayersSign', 'sup');
  if tmpStr = 'sup' then
    Filters.MaxPlayers.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.MaxPlayers.filterType := Inf
  else
    Filters.MaxPlayers.filterType := Equal;
  Filters.MaxPlayers.value := Ini.ReadInteger('StaticFilters', 'MaxPlayersValue', 1);

  i := 0;
  while Ini.SectionExists('TextFilter'+IntToStr(i)) do begin
    tmpStr := Ini.ReadString('TextFilter'+IntToStr(i), 'Type', 'Error');
    if tmpStr = 'Error' then raise Exception.Create('TextFilter type uknown !');

    New(f);
    if tmpStr = 'Host' then
      TFilterText(f^).filterType := HostName
    else if tmpStr = 'Map' then
      TFilterText(f^).filterType := MapName
    else if tmpStr = 'Mod' then
      TFilterText(f^).filterType := ModName
    else if tmpStr = 'Description' then
      TFilterText(f^).filterType := Description;

    TFilterText(f^).value := Ini.ReadString('TextFilter'+IntToStr(i),'Value','');
    TFilterText(f^).contains := Ini.ReadBool('TextFilter'+IntToStr(i),'Contains',True);
    TFilterText(f^).enabled := Ini.ReadBool('TextFilter'+IntToStr(i),'Enabled',True);
    TFilterText(f^).node := nil;
    Filters.TextFilters.Add(f);

    i := i+1;
  end;

  Ini.Free;
end;

procedure TMainForm.UpdateFilters;
var
  i: integer;
begin
  FullFilter.Checked := Filters.Full;
  InProgressFilter.Checked := Filters.InProgress;
  LadderFilter.Checked := Filters.Ladder;
  LockedFilter.Checked := Filters.Locked;
  PasswordedFilter.Checked := Filters.Passworded;
  NatTraversalFilter.Checked := Filters.NatTraversal;
  MapsNotAvailableFilter.Checked := Filters.MapNotAvailable;
  ModsNotAvailableFilter.Checked := Filters.ModNotAvailable;
  ReplaysFilter.Checked := Filters.Replays;
  RankLimitFilter.Checked := Filters.RankLimitSupEqMine;
  PlayersFilter.Checked := Filters.Players.enabled;
  MaxPlayersFilter.Checked := Filters.MaxPlayers.enabled;

  if Filters.Players.filterType = Sup then
    PlayersSignButton.Caption := '>'
  else if Filters.Players.filterType = Inf then
    PlayersSignButton.Caption := '<'
  else
    PlayersSignButton.Caption := '=';
  PlayersValueTextBox.Value := Filters.Players.value;

  if Filters.MaxPlayers.filterType = Sup then
    MaxPlayersSignButton.Caption := '>'
  else if Filters.MaxPlayers.filterType = Inf then
    MaxPlayersSignButton.Caption := '<'
  else
    MaxPlayersSignButton.Caption := '=';
  MaxPlayersValueTextBox.Value := Filters.MaxPlayers.value;

  for i:=0 to Filters.TextFilters.Count -1 do
  begin
    TFilterText(Filters.TextFilters[i]^).Node := FilterList.AddChild(FilterList.RootNode);
    TFilterText(Filters.TextFilters[i]^).Node.CheckType := ctCheckBox;
    if TFilterText(Filters.TextFilters[i]^).enabled then
      TFilterText(Filters.TextFilters[i]^).Node.CheckState := csCheckedNormal
    else
      TFilterText(Filters.TextFilters[i]^).Node.CheckState := csUncheckedNormal;
  end;
end;


procedure TMainForm.HighlighBattlesTimerTimer(Sender: TObject);
var
  i:integer;
begin
  for i:= 0 to Battles.Count -1 do
    TBattle(Battles[i]).NextHighlight;
  VDTBattles.Refresh;
end;

procedure TMainForm.FormResize(Sender: TObject);
var
  i: Integer;
   p: TPoint;
   re : TTntRichEdit;
begin
  FixFormSizeConstraints(MainForm);
  for i:=0 to PageControl1.PageCount-1 do
  begin
    re := PageControl1.Pages[i].Controls[1] as TTntRichEdit;
    re.SelLength := 0;
    re.SelStart := 0;
    re.SelStart := Length(re.text);
  end;
end;

procedure TMainForm.PlayersFilterClick(Sender: TObject);
begin
  Filters.Players.enabled := PlayersFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.MaxPlayersFilterClick(Sender: TObject);
begin
  Filters.MaxPlayers.enabled := MaxPlayersFilter.Checked;
  RefreshBattleList;
end;

procedure TMainForm.FilterListResize(Sender: TObject);
begin
  FilterList.Width := FilterGroup.Width - 434;
end;

procedure TMainForm.mnuKickClick(Sender: TObject);
begin
  TryToSendCommand('KICKUSER', SelectedUserName);
end;

procedure TMainForm.mnuKickReasonClick(Sender: TObject);
var
  reason: string;
begin
  reason := InputBox('Kicking reason','Reason :','');
  if reason <> '' then
    TryToSendCommand('KICKUSER', SelectedUserName+' '+reason);
end;

procedure TMainForm.mnuMute5MinClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(PageControl1.ActivePage.Caption,2,500000000)+' '+SelectedUserName+' 5 ip');
end;

procedure TMainForm.mnuMute30MinClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(PageControl1.ActivePage.Caption,2,500000000)+' '+SelectedUserName+' 30 ip');
end;

procedure TMainForm.mnuMute1HourClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(PageControl1.ActivePage.Caption,2,500000000)+' '+SelectedUserName+' 60 ip');
end;

procedure TMainForm.mnuMute1DayClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(PageControl1.ActivePage.Caption,2,500000000)+' '+SelectedUserName+' 1440 ip');
end;

procedure TMainForm.mnuMute1WeekClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(PageControl1.ActivePage.Caption,2,500000000)+' '+SelectedUserName+' 10080 ip');
end;

procedure TMainForm.mnuMuteCustomClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(PageControl1.ActivePage.Caption,2,500000000)+' '+SelectedUserName+' '+IntToStr(InputBoxInteger('Mute duration','Duration (min):',30,1))+' ip');
end;

procedure TMainForm.SpTBXItem2Click(Sender: TObject);
begin
  TryToSendCommand('GETIP', SelectedUserName);
end;

procedure TMainForm.mnuFindIPClick(Sender: TObject);
var
  client: TClient;
begin
  client := GetClient(SelectedUserName);
  if client = nil then Exit;
  if client.IP = '' then
  begin
    TryToSendCommand('GETIP', SelectedUserName);
    FindIPQueueList.Add(SelectedUserName);
  end
  else
  begin
    TryToSendCommand('FINDIP', client.IP);
  end;

end;

procedure TMainForm.mnuUnmuteClick(Sender: TObject);
begin
  TryToSendCommand('UNMUTE', MidStr(PageControl1.ActivePage.Caption,2,500000000)+' '+SelectedUserName);
end;

procedure TKeepAliveThread.Execute;
begin
  while true do
  begin
    if Status.LoggedIn then
      MainForm.TryToSendCommand('PING');
    Sleep(8000);
  end;
end;

constructor TLadderTopPlayersThread.Create(Suspended: Boolean);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   OnTerminate := OnTerminateProcedure;
end;

procedure TLadderTopPlayersThread.Execute;
begin
  if not Status.LoggedIn then
    Exit;
  Refresh;
end;

procedure TLadderTopPlayersThread.Refresh;
var
  i,j,k:integer;
  html:string;
  parse1 : TStrings;
  parse2 : TStrings;
  parse3 : TStrings;
  tmp: ^integer;
begin
  parse1 := TStringList.Create;
  parse2 := TStringList.Create;
  parse3 := TStringList.Create;

  with MainForm do
  begin

  // get the html result
  if Preferences.UseProxy then
  begin
    HttpCli2.Proxy := Preferences.ProxyAddress;
    HttpCli2.ProxyPort := IntToStr(Preferences.ProxyPort);
    HttpCli2.ProxyUsername := Preferences.ProxyUsername;
    HttpCli2.ProxyPassword := Preferences.ProxyPassword
  end
  else HttpCli2.Proxy := '';
  HttpCli2.URL := LADDER_PREFIX_URL + 'top.php?minplayers=15&minbattles=40&fraction=0&number=3';
  HttpCli2.RcvdStream := TMemoryStream.Create;
  try
    HttpCli2.Get;
  except
    if Pos('Warning: Ladder server unavailable.',((PageControl1.Pages[0] as TMyTabSheet).Controls[1] as TTntRichEdit).Lines.Text) = 0 then
      MainForm.AddMainLog('Warning: Ladder server unavailable.', Colors.Normal);
    Exit;
  end;
  HttpCli2.RcvdStream.Seek(0,0);
  SetLength(html, HttpCli2.RcvdStream.Size);
  HttpCli2.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli2.RcvdStream.Size);

  // clear players cups
  for i:=0 to AllClients.Count-1 do
  begin
    TClient(AllClients[i]).CupList.Clear;
    TClient(AllClients[i]).CupLadderList.Clear;
  end;

  // parse the html result
  Misc.ParseDelimited(parse1,TrimRight(TrimLeft(html)),#$A,'');
  for i:=0 to parse1.Count-1 do
  begin
    try
      Misc.ParseDelimited(parse2,MidStr(parse1[i],Pos(' ',parse1[i]),MaxInt),#9,'');
    except
      if Pos('Warning: Error while parsing top players ladder page.',((PageControl1.Pages[0] as TMyTabSheet).Controls[1] as TTntRichEdit).Lines.Text) = 0 then
        MainForm.AddMainLog('Warning: Error while parsing top players ladder page.', Colors.Normal);
      parse1.Free;
      parse2.Free;
      parse3.Free;
      Exit;
    end;
    if parse2.Count <> 2 then
    begin
      if Pos('Warning: Error while parsing top players ladder page.',((PageControl1.Pages[0] as TMyTabSheet).Controls[1] as TTntRichEdit).Lines.Text) = 0 then
        MainForm.AddMainLog('Warning: Error while parsing top players ladder page.', Colors.Normal);
      parse1.Free;
      parse2.Free;
      parse3.Free;
      Exit;
    end;
    Misc.ParseDelimited(parse3,TrimRight(TrimLeft(parse2[1])),' ','');
    if parse3.Count <> 3 then
    begin
      if Pos('Warning: Error while parsing top players ladder page.',((PageControl1.Pages[0] as TMyTabSheet).Controls[1] as TTntRichEdit).Lines.Text) = 0 then
        MainForm.AddMainLog('Warning: Error while parsing top players ladder page.', Colors.Normal);
      parse1.Free;
      parse2.Free;
      parse3.Free;
      Exit;
    end;
    new(tmp);
    tmp^ := 0;
    try
      MainForm.GetClient(parse3[0]).CupList.Add(tmp);
      MainForm.GetClient(parse3[0]).CupLadderList.Add(TrimRight(TrimLeft(parse2[0])));
    except
      //
    end;
    new(tmp);
    tmp^ := 1;
    try
      MainForm.GetClient(parse3[1]).CupList.Add(tmp);
      MainForm.GetClient(parse3[1]).CupLadderList.Add(parse2[0]);
    except
      //
    end;
    new(tmp);
    tmp^ := 2;
    try
      MainForm.GetClient(parse3[2]).CupList.Add(tmp);
      MainForm.GetClient(parse3[2]).CupLadderList.Add(parse2[0]);
    except
      //
    end;
    parse2.Clear;
    parse3.Clear;
  end;
  parse1.Free;
  parse2.Free;
  parse3.Free;
  end;
end;

procedure TLadderTopPlayersThread.OnTerminateProcedure(Sender: TObject);
begin
  // nothing
end;

procedure TMainForm.LadderCupsRefreshTimer(Sender: TObject);
var
  t: TLadderTopPlayersThread;
begin
  if Status.LoggedIn then
    t := TLadderTopPlayersThread.Create(false);
end;

procedure TMainForm.FilterListChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
begin
  TFilterText(Filters.TextFilters[GetFilterIndexFromNode(Node)]^).enabled := NewState = csCheckedNormal;
  RefreshBattleList;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  s: string;
  s2 : WideString;
begin
  AddMainLog('  ' + BattleForm.InputEdit.Text+'d',Colors.Normal);
end;

procedure TMainForm.BattleListPopupMenuInitPopup(Sender: TObject;
  PopupView: TTBView);
begin
  VDTBattles.SetFocus;
  if (VDTBattles.FocusedNode <> nil) and VDTBattles.Selected[VDTBattles.FocusedNode] then
  begin
    SelectedBattle := GetBattleFromNode(VDTBattles.FocusedNode);
    RichEditSelectedClient := SelectedBattle.Clients[0];
    ClientPopupMenuInitPopup(nil,nil);
    mnuBattleHost.Caption := RichEditSelectedClient.Name;
  end;
  mnuBattleHost.Visible := VDTBattles.FocusedNode <> nil;
  mnuBattleAddToFilters.Visible := VDTBattles.FocusedNode <> nil;

  VDTBattles.Repaint;
end;

procedure TMainForm.ClientPopupMenuInitPopup(Sender: TObject;
  PopupView: TTBView);
var
  Client: TClient;
  ClientGroup : Integer;
  i : Integer;
begin
  if RichEditSelectedClient = nil then // showing player context menu from the richedit
  begin
    if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item
    if PageControl1.ActivePage.Caption = LOCAL_TAB then Client := TClient(AllClients[ClientsListBox.ItemIndex])
    else Client := TClient((PageControl1.ActivePage as TMyTabSheet).Clients[ClientsListBox.ItemIndex]);
  end
  else
    Client := RichEditSelectedClient;

  ModerationSubmenuItem.Visible := Status.Me.GetAccess; // only moderators may see moderation menu!
  MuteSubitemMenu.Visible := LeftStr(PageControl1.ActivePage.Caption,1) = '#';
  mnuUnmute.Visible := LeftStr(PageControl1.ActivePage.Caption,1) = '#';

  ClientGroup := Client.GetGroup;

  if ClientGroup >-1 then begin
    mnuAddToGroup.Enabled := False;
    mnuRemoveFromGroup.Enabled := True;
  end
  else
  begin
    mnuRemoveFromGroup.Enabled := False;
    mnuAddToGroup.Enabled := True
  end;

  mnuIgnore.Checked := IgnoreListForm.IgnoringUser(Client.Name);

  mnuManageGroups.Enabled := ClientGroups.Count > 0;

  for i:= mnuAddToGroup.Count-1 downto 2 do
    mnuAddToGroup.Remove(mnuAddToGroup.Items[i]);

  for i:=0 to ClientGroups.Count-1 do
  begin
    mnuAddToGroup.Add(TSpTBXItem.Create(mnuAddToGroup));
    with mnuAddToGroup.Items[mnuAddToGroup.Count-1] as TSpTBXItem do
    begin
      Caption := TClientGroup(ClientGroups[i]).Name;
      Tag := i;
      OnClick := AddToGroupItemClick;
    end;
  end;

  SelectedUserName := Client.Name;
end;

procedure TMainForm.mnuDisplayOnlyHostClick(Sender: TObject);
var
  f: ^TFilterText;
begin
  New(f);
  f^.filterType := HostName;
  f^.node := nil;
  f^.contains := True;
  f^.value := TClient(SelectedBattle.Clients[0]).Name;
  Filters.TextFilters.Add(f);
  f^.Node := FilterList.AddChild(FilterList.RootNode);
  f^.Node.CheckType := ctCheckBox;
  f^.Node.CheckState := csCheckedNormal;
  f^.enabled := True;
  FilterList.Invalidate;
  FilterValueTextBox.Text := '';
  RefreshBattleList;
end;

procedure TMainForm.mnuDisplayOnlyModClick(Sender: TObject);
var
  f: ^TFilterText;
begin
  New(f);
  f^.filterType := ModName;
  f^.node := nil;
  f^.contains := True;
  f^.value := SelectedBattle.ModName;
  Filters.TextFilters.Add(f);
  f^.Node := FilterList.AddChild(FilterList.RootNode);
  f^.Node.CheckType := ctCheckBox;
  f^.Node.CheckState := csCheckedNormal;
  f^.enabled := True;
  FilterList.Invalidate;
  FilterValueTextBox.Text := '';
  RefreshBattleList;
end;

procedure TMainForm.mnuDisplayOnlyMapClick(Sender: TObject);
var
  f: ^TFilterText;
begin
  New(f);
  f^.filterType := MapName;
  f^.node := nil;
  f^.contains := True;
  f^.value := Copy(SelectedBattle.Map, 1, Length(SelectedBattle.Map)-4);
  Filters.TextFilters.Add(f);
  f^.Node := FilterList.AddChild(FilterList.RootNode);
  f^.Node.CheckType := ctCheckBox;
  f^.Node.CheckState := csCheckedNormal;
  f^.enabled := True;
  FilterList.Invalidate;
  FilterValueTextBox.Text := '';
  RefreshBattleList;
end;

procedure TMainForm.mnuHideEveryHostClick(Sender: TObject);
var
  f: ^TFilterText;
begin
  New(f);
  f^.filterType := HostName;
  f^.node := nil;
  f^.contains := False;
  f^.value := TClient(SelectedBattle.Clients[0]).Name;
  Filters.TextFilters.Add(f);
  f^.Node := FilterList.AddChild(FilterList.RootNode);
  f^.Node.CheckType := ctCheckBox;
  f^.Node.CheckState := csCheckedNormal;
  f^.enabled := True;
  FilterList.Invalidate;
  FilterValueTextBox.Text := '';
  RefreshBattleList;
end;

procedure TMainForm.mnuHideEveryModClick(Sender: TObject);
var
  f: ^TFilterText;
begin
  New(f);
  f^.filterType := ModName;
  f^.node := nil;
  f^.contains := False;
  f^.value := SelectedBattle.ModName;
  Filters.TextFilters.Add(f);
  f^.Node := FilterList.AddChild(FilterList.RootNode);
  f^.Node.CheckType := ctCheckBox;
  f^.Node.CheckState := csCheckedNormal;
  f^.enabled := True;
  FilterList.Invalidate;
  FilterValueTextBox.Text := '';
  RefreshBattleList;
end;

procedure TMainForm.mnuHideEveryMapClick(Sender: TObject);
var
  f: ^TFilterText;
begin
  New(f);
  f^.filterType := MapName;
  f^.node := nil;
  f^.contains := False;
  f^.value := Copy(SelectedBattle.Map, 1, Length(SelectedBattle.Map)-4);
  Filters.TextFilters.Add(f);
  f^.Node := FilterList.AddChild(FilterList.RootNode);
  f^.Node.CheckType := ctCheckBox;
  f^.Node.CheckState := csCheckedNormal;
  f^.enabled := True;
  FilterList.Invalidate;
  FilterValueTextBox.Text := '';
  RefreshBattleList;
end;

procedure TMainForm.VDTBattlesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    BattleListPopupMenuInitPopup(nil,nil);
end;

constructor TCheckNewBetaLobbyThread.Create(Suspended: Boolean;hasLastVersionConfirmation: boolean);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   confirmation := hasLastVersionConfirmation;
end;

procedure TCheckNewBetaLobbyThread.Execute;
var
  html : string;
  parsedHtml: TStrings;
begin
  if FileExists(Application.ExeName + '.old') then
    DeleteFile(Application.ExeName + '.old');
  with MainForm do
  begin
    parsedHtml := TStringList.Create;
    if Preferences.UseProxy then
    begin
      HttpCli1.Proxy := Preferences.ProxyAddress;
      HttpCli1.ProxyPort := IntToStr(Preferences.ProxyPort);
      HttpCli1.ProxyUsername := Preferences.ProxyUsername;
      HttpCli1.ProxyPassword := Preferences.ProxyPassword
    end
    else HttpCli1.Proxy := '';
    HttpCli1.URL := CHECK_BETA_LOBBY_URL;
    HttpCli1.MultiThreaded := True;
    HttpCli1.RcvdStream := TMemoryStream.Create;
    try
      HttpCli1.Get;
    except
      MainForm.AddMainLog('Warning: Beta lobby version server unavailable.', Colors.Normal);
      Exit;
    end;
    try
      HttpCli1.RcvdStream.Seek(0,0);
      SetLength(html, HttpCli1.RcvdStream.Size);
      HttpCli1.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli1.RcvdStream.Size);

      Misc.ParseDelimited(parsedHtml,html,' ','');
      if StrToInt(parsedHtml[0]) > BETA_NUMBER then
      begin
        //if MessageDlgThread('A new beta version of the lobby is available, do you want to download it ?',mtInformation,[mbYes,mbNo],0) = mrYes then
        //begin
          //Misc.OpenURLInDefaultBrowser(parsedHtml[1]);
            DownloadFile.URL := parsedHtml[1];
            DownloadFile.FileName := '_AutoUpdateTempFile.7z';
            DownloadFile.ServerOptions := 4;
            PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);
        //end;
      end
      else
        if confirmation then
          MessageDlgThread('Your lobby version is up to date.',mtInformation,[mbOk],0);
    except
      Exit;
    end;
  end;
end;

procedure TMainForm.SpTBXItem3Click(Sender: TObject);
begin
    Misc.OpenURLInDefaultBrowser('http://spring.clan-sy.com/websvn/log.php?repname=spring&path=%2Ftrunk%2FLobby%2FTASClient%2F');
end;

procedure TMainForm.mnuBattleDlMapClick(Sender: TObject);
var
  url: string;
begin
  url := StringReplace(SelectedBattle.Map,'.smf','',[rfReplaceAll, rfIgnoreCase]);
  {url := StringReplace(url,'_',' ',[rfReplaceAll, rfIgnoreCase]);
  url := StringReplace(url,'-',' ',[rfReplaceAll, rfIgnoreCase]); }
  url := 'http://spring.jobjol.nl/search_result.php?search=' + url+'&select=select_all';
  FixURL(url);
  Misc.OpenURLInDefaultBrowser(url);
end;

procedure TMainForm.mnuBattleDlModClick(Sender: TObject);
var
  url: string;
begin
  url := 'http://spring.jobjol.nl/search_result.php?search='+SelectedBattle.ModName+'&select=select_all';
  FixURL(url);
  Misc.OpenURLInDefaultBrowser(url);
end;

procedure TMainForm.mnuForceLobbyUpdateCheckClick(Sender: TObject);
var
  checkThread: TCheckNewBetaLobbyThread;
begin
  checkThread := TCheckNewBetaLobbyThread.Create(false,true);
end;

end.
