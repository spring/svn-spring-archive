{
  Project started on: 13/06/2005

  * Right-clicking on a tab button will close the tab
  * Double or right clicking on a user will open a chat with him
  * Click on the minimap to see a zoomed-in minimap
  * Click on SIDE label to change side
  * Use -DEBUG switch to enable verbose, use -LOG to save local tab's text to disk on program exit
  * Use "/me" ta talk in "/me" irc style
  * Double clicking on battle or clicking on battle join button, will (both) join the battle
  * Right click on minimap or map list and choose "Reload map list". It will reload map list
    even while hosting or participating in a battle.

  Also see protocol description + notes in TASServer.java!

  * Use modified TjanTracker component and Virtual TreeView to compile

  * DO NOT edit config.dat file by yourself!

  ------ LINKS ------
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

  ------ REMEMBER ------
  * never change ActivePageIndex manually, since it doesn't trigger OnChange event! Always use ChangeActivePageAndUpdate method!
  * team indexes and ally team indexes are not zero-based! They all start at 1. When saved to the script.txt, they get converted
    to zero-based indexes.
  * you can send lines of any length. I've tested it with 600+ KB long strings and it worked (in both directions!)

  ------ 3RD-PARTY COMPONENTS ------
  - TVirtualStringTree/TVirtualDrawTree, see http://www.lischke-online.de/VirtualTreeview/
  - TjanTracker (modified!) (sources included)
  - TWSocket (ICS), see http://www.overbyte.be/frame_index.html?redirTo=/ssl.html
  - GraphicEx, see http://www.soft-gems.net/Graphics.php
  - RichEditURL (included with these sources. See RichEditURL.pas for more details (and links))
  - JEDI Visual Component Library (http://homepages.borland.com/jedi/jvcl/)

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

  ------ CHANGELOG ------

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

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus, Grids, ValEdit,
  VirtualTrees, ImgList, WSocket, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, StringParser, MMSystem, Utility, AppEvnts, Math,
  PasswordDialogUnit, HttpProt, GraphicEx, Registry, JvComponent,
  JvBaseDlg, JvDesktopAlert;

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
  VERSION_NUMBER = '0.16'; // Must be float value! (with a period as a decimal seperator)
  PROGRAM_VERSION = 'TASClient ' + VERSION_NUMBER;
  KEEP_ALIVE_INTERVAL = 10000; // in miliseconds. Tells us what should be the maximum "silence" time before we send a ping to the server.
  ASSUME_TIMEOUT_INTERVAL = 30000; // in miliseconds. Must be greater than KEEP_ALIVE_INTERVAL! If server hasn't send any data to us within this interval, then we assume timeout occured. It's us who must make sure we get constant replies from server by pinging it.
  LOCAL_TAB = '$Local'; // caption of main (command) tab window. Must be special so that is different from channel names or user names, that is why there is a "$" in front of it.
  SUPPORTED_SERVER_VERSIONS: array[0..0] of string = ('0.16'); // client can connect ONLY to server with one of these version numbers
  EOL = #13#10;

  LOG_FILENAME = 'log.txt';
  AWAY_TIME = 30000; // in miliseconds. After this period of time (of inactivity), client will set its state to "away"
  LOBBY_FOLDER = 'lobby'; // main folder for lobby, in which all other folders are put (logs, cache, var, ...)
  CACHE_FOLDER = LOBBY_FOLDER + '\' + 'cache'; // we store images of minimaps in it (see OnlineMapsForm)
  LOG_FOLDER = LOBBY_FOLDER + '\' + 'logs'; // this is where we store chat logs to
  VAR_FOLDER = LOBBY_FOLDER + '\' + 'var';

  WM_DATAHASARRIVED = WM_USER + 0; // used when processing data received through socket
  WM_OPENOPTIONS = WM_USER + 1; // used to open OPTIONS dialog
  WM_DOREGISTER = WM_USER + 2 ; // sent when user clicks on REGISTER button
  WM_CLOSETAB = WM_USER + 3; // used when user presses CTRL+W to close tab
  WM_STARTGAME = WM_USER + 4; // used to launch spring.exe
  WM_STARTTRANSFER = WM_USER + 5; // used when receiving file from server
  WM_UPDATETRANSFER = WM_USER + 6; // used to tell GetFileForm to update position of DownloadProgressBar
  WM_CONNECT = WM_USER + 7; // used to simulate ConnectButton.OnClick event
  WM_STARTDOWNLOAD = WM_USER + 8; // used together with HttpGetForm. Before dispatching this message, you have to fill out all fields of DownloadFile record
  WM_STARTDOWNLOAD2 = WM_USER + 9; // used internally by HttpGetForm

  QUEUE_LENGTH = 256;

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

    constructor Create(Name: string; Status: Integer; Country: string; CPU: Integer);

    // following functions extract various values from BattleStatus:
    function GetSide: Integer;
    function GetReadyStatus: Boolean;
    function GetTeamNo: Integer;
    function GetAllyNo: Integer;
    function GetMode: Integer; // 0 - spectator, 1 - normal player. Also see server protocol description!
    function GetHandicap: Integer;
    function GetTeamColor: Integer;
    function GetSync: Integer;

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
    function GetSide: Integer;
    function GetTeamNo: Integer;
    function GetAllyNo: Integer;
    function GetHandicap: Integer;
    function GetTeamColor: Integer;

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
    function isBattleInProgress: Boolean;
    function GetState: Integer; // use it to get index of image from BattleStatusImageList
    function ClientsToString: string; // returns user names in a string, separated by spaces
    function GetClient(Name: string): TClient;
    function GetBot(Name: string): TBot;
    procedure RemoveAllBots;
  end;

  TScript = class
  private
    FScript: string;
    FUpperCaseScript: string;
    procedure SetScript(Script: string);
  public
    constructor Create(Script: string);
    function ReadMapName: string; // raises an exception if it fails
    function ReadModName: string; // raises an exception if it fails
    function ReadStartMetal: Integer; // raises an exception if it fails
    function ReadStartEnergy: Integer; // raises an exception if it fails
    function ReadMaxUnits: Integer; // raises an exception if it fails
    function ReadStartPosType: Integer; // raises an exception if it fails
    function ReadGameMode: Integer; // raises an exception if it fails
    function ReadLimitDGun: Boolean; // raises an exception if it fails
    function ReadDiminishingMMs: Boolean; // raises an exception if it fails
    procedure ChangeHostIP(NewIP: string); // raises an exception if it fails
    procedure ChangeHostPort(NewPort: string); // raises an exception if it fails
    procedure ChangeMyPlayerNum(NewNum: Integer); // raises an exception if it fails
    procedure ChangeNumPlayers(NewNum: Integer); // raises an exception if it fails
    procedure AddLineToPlayer(Player: Integer; Line: string); // raises an exception if it fails
    procedure AddSpectatorAfterAnotherPlayer(AnotherPlayer: Integer; NewPlayer: Integer; Nickname: string); // raises an exception if it fails
    procedure AddLineAfterStart(Line: string); // raises an exception if it fails

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
    FileTransferTimer: TTimer;
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

    procedure CreateParams(var Params: TCreateParams); override;

    procedure OnDataHasArrivedMessage(var Msg: TMessage); message WM_DATAHASARRIVED;
    procedure OnOpenOptionsMessage(var Msg: TMessage); message WM_OPENOPTIONS;
    procedure OnDoRegisterMessage(var Msg: TMessage); message WM_DOREGISTER;
    procedure OnCloseTabMessage(var Msg: TMessage); message WM_CLOSETAB;
    procedure OnConnectMessage(var Msg: TMessage); message WM_CONNECT;
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

    procedure EnumerateReplayList;
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
    procedure AddTextToChatWindow(Chat: TMyTabSheet; Text: string; Color: TColor);
    procedure OpenPrivateChat(ClientName: string);

    function AddClientToTab(Tab: TMyTabSheet; ClientName: string): Boolean;
    function RemoveClientFromTab(Tab: TMyTabSheet; ClientName: string): Boolean;
    procedure RemoveAllClientsFromTab(Tab: TMyTabSheet);
    procedure UpdateClientsListBox;

    function AddBattle(ID: Integer; BattleType: Integer; Founder: TClient; IP: string; Port: Integer; MaxPlayers: Integer; Password: Boolean; Rank: Byte; MapName: string; MapTitle: string; ModName: string): Boolean;
    function RemoveBattle(ID: Integer): Boolean;
    function RemoveBattleByIndex(Index: Integer): Boolean;
    function GetBattle(ID: Integer): TBattle;

    procedure ClearAllClientsList;
    procedure ClearClientsLists; // clears all clients list (in channels, private chats, battle, local tab, ...)
    procedure AddClientToAllClientsList(Name: string; Status: Integer; Country: string; CPU: Integer);
    function RemoveClientFromAllClientsList(Name: string): Boolean;
    function GetClient(Name: string): TClient;
    function GetClientIndexEx(Name: string; ClientList: TList): Integer;

    function GetBot(Name: string; Battle: TBattle): TBot;

    procedure TryToConnect;
    procedure TryToDisconnect;
    procedure TryToSendData(s: string);
    procedure TryToLogin(Username, Password: string);
    procedure TryToRegister(Username, Password: string); // try to register new account

    procedure AddMainLog(Text: string; Color: TColor);

    procedure SortClientsList(List: TList; SortStyle: Byte);
    function CompareClients(Client1: TClient; Client2: TClient; SortStyle: Byte): Shortint; // used with SortClientsList method (and other methods?)
    function CompareBattles(Battle1, Battle2: TBattle; SortStyle: Byte): Shortint;
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
    procedure FileTransferTimerTimer(Sender: TObject);
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TConnectionState = (Disconnected, Connecting, Connected);

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
    Registering: Boolean; // used only when registering new account
    WaitingForFileTransfer: Boolean; // true when we are waiting for server to start sending us the file we have requested
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

  Battles: TList;
  ReplayList: TList;

  FlagBitmaps: TList; // of TBitmap objects
  FlagBitmapsInitialized: Boolean = False;
  FlagBitmapsReverseTable: array[Ord('a')..Ord('z'), Ord('a')..Ord('z')] of Smallint;

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
  InitWaitFormUnit, HelpUnit, GetFileUnit, DebugUnit, ReplaysUnit,
  HttpGetUnit, OnlineMapsUnit, ShellAPI, RichEdit, NotificationsUnit, StrUtils;

{$R *.dfm}

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  // detach main form from Application and hide Application's taskbar button:

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopwindow;
  end;

  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong (Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
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

procedure TMainForm.EnumerateReplayList;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  rep: TReplay;
  s: string;
begin
  ReplayList.Clear;

  FileAttrs := faAnyFile;

  if FindFirst(ExtractFilePath(Application.ExeName) + 'demos\*.sdf', FileAttrs, sr) = 0 then
  begin
    if (sr.Name <> '.') and (sr.Name <> '..') then
    begin
      rep := TReplay.Create;
      rep.FileName := sr.Name;
      rep.FullFileName := ExtractFilePath(Application.ExeName) + 'Demos\' + sr.Name;
      ReplaysForm.ReadScriptFromDemo(rep.FullFileName, s);
      rep.Grade := ReplaysForm.ReadGradeFromScript(s);
      ReplayList.Add(rep);
    end;

    while FindNext(sr) = 0 do
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        rep := TReplay.Create;
        rep.FileName := sr.Name;
        rep.FullFileName := ExtractFilePath(Application.ExeName) + 'Demos\' + sr.Name;
        ReplaysForm.ReadScriptFromDemo(rep.FullFileName, s);
        rep.Grade := ReplaysForm.ReadGradeFromScript(s);
        ReplayList.Add(rep);
      end;

    FindClose(sr);
  end;
end;

// returns False if battle with this ID already exists or some other error occured
function TMainForm.AddBattle(ID: Integer; BattleType: Integer; Founder: TClient; IP: string; Port: Integer; MaxPlayers: Integer; Password: Boolean; Rank: Byte; MapName: string; MapTitle: string; ModName: string): Boolean;
var
  Battle: TBattle;
  i: Integer;
  tmp: TBattle;
  tmpNode: PVirtualNode;
begin
  Result := False;

  if GetBattle(ID) <> nil then Exit;

  Battle := TBattle.Create;
  Battle.ID := ID;
  Battle.BattleType := BattleType;
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

  // sort battles:
  i := Battles.Count-1;
  while i > 0 do
    if CompareBattles(Battles[i], Battles[i-1], 1) < 0 then
    begin
      // swap:
      tmp := Battles[i];
      Battles[i] := Battles[i-1];
      Battles[i-1] := tmp;
      // swap nodes to previous position:
      tmpNode := TBattle(Battles[i]).Node;
      TBattle(Battles[i]).Node := TBattle(Battles[i-1]).Node;
      TBattle(Battles[i-1]).Node := tmpNode;

      Dec(i);
    end
    else Break;


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

procedure TMainForm.AddClientToAllClientsList(Name: string; Status: Integer; Country: string; CPU: Integer);
var
  Client: TClient;
begin
  Client := TClient.Create(Name, Status, Country, CPU);
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

constructor TClient.Create(Name: string; Status: Integer; Country: string; CPU: Integer);
begin
  Self.Name := Name;
  Self.Status := Status;
  Self.BattleStatus := 0;
  Self.InBattle := False;
  Self.Country := Country;
  Self.CPU := CPU;
end;

// Battle status:

function TClient.GetSide: Integer;
begin
  Result := BattleStatus and $1;
end;

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

procedure TClient.SetSide(Side: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFFFE) or Side;
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

// Misc:

function TClient.GetStateImageIndex: Integer; // returns index of image in PlayerStateImageList
begin
  if GetInGameStatus then Result := 2
  else if InBattle then Result := 1
  else Result := 0;
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

function TBot.GetSide: Integer;
begin
  Result := BattleStatus and $1;
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

procedure TBot.SetSide(Side: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFFFE) or Side;
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

function TScript.ReadMapName: string; // raises an exception if it fails
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

function TScript.ReadModName: string; // raises an exception if it fails
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

function TScript.ReadStartMetal: Integer; // raises an exception if it fails
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

function TScript.ReadStartEnergy: Integer; // raises an exception if it fails
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

function TScript.ReadMaxUnits: Integer; // raises an exception if it fails
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

function TScript.ReadStartPosType: Integer; // raises an exception if it fails
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

function TScript.ReadGameMode: Integer; // raises an exception if it fails
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

function TScript.ReadLimitDGun: Boolean; // raises an exception if it fails
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

function TScript.ReadDiminishingMMs: Boolean; // raises an exception if it fails
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

procedure TScript.ChangeHostIP(NewIP: string); // raises an exception if it fails
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

procedure TScript.ChangeHostPort(NewPort: string); // raises an exception if it fails
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

procedure TScript.ChangeMyPlayerNum(NewNum: Integer); // raises an exception if it fails
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

procedure TScript.ChangeNumPlayers(NewNum: Integer); // raises an exception if it fails
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

procedure TScript.AddLineToPlayer(Player: Integer; Line: string); // raises an exception if it fails
var
  i, j, k: Integer;
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
procedure TScript.AddSpectatorAfterAnotherPlayer(AnotherPlayer: Integer; NewPlayer: Integer; Nickname: string); // raises an exception if it fails
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
       + #13#10#9#9 + 'Spectator=1;' + #13#10#9 + '}';
  Insert(ins, FScript, i);

  // update upper-case script:
  FUpperCaseScript := UpperCase(FScript);
end;

procedure TScript.AddLineAfterStart(Line: string); // raises an exception if it fails
var
  i, j, k: Integer;
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
  // EnumerateReplayList; -> we will do itin ReplaysForm!

  for i := 0 to SortPopupMenu.Items.Count-1 do
  begin
    SortPopupMenu.Items[i].Tag := i;
    SortPopupMenu.Items[i].RadioItem := True;
    SortPopupMenu.Items[i].OnClick := SortMenuItemClick;
  end;
  SortPopupMenu.Items[0].Checked := True;

  InitializeFlagBitmaps;
end;

procedure TMainForm.AddTextToChatWindow(Chat: TMyTabSheet; Text: string; Color: TColor);
var
  re: TRichEdit;
begin
  re := Chat.Controls[1] as TRichEdit;
  if Preferences.TimeStamps then Text := '[' + TimeToStr(Now) + '] ' + Text;
  Misc.AddTextToRichEdit(re, Text, Color, Chat.AutoScroll);
  TryToAddLog(Chat.LogFile, Text);

  if PageControl1.ActivePage <> Chat then
    Chat.Highlighted := True;
end;

procedure TMainForm.AddMainLog(Text: string; Color: TColor);
begin
  AddTextToChatWindow(PageControl1.Pages[0] as TMyTabSheet, Text, Color);
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
  tmped.Name := 'InputEdit';
  tmped.Text := '';
  tmped.OnKeyPress := InputEditKeyPress;
  tmped.OnKeyDown := InputEditKeyDown;
  tmped.Font.Name := 'Fixedsys';
  tmped.Align := alBottom;

  tmpts.PageControl := PageControl1;

  tmpre := TRichEdit.Create(tmpts);
  tmpre.Parent := tmpts;
  tmpre.Font.Name := 'Fixedsys';
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
begin
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

      if (sl.Count <> 2) or (sl[1][1] <> '#') then
      begin
        AddMainLog('Cannot join - bad or no argument (don''t forget to put "#" in front of a channel''s name!)', Colors.Error);
        Exit;
      end;

      TryToSendData('JOIN ' + LowerCase(Copy(sl[1], 2, Length(sl[1])-1)));
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

      TryToSendData('RING ' + sl[1]);
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
    else if (sl[0] = 'TEST') then
    begin
      AddNotification('Test', 'This is only a test.', 2000);
    end
    else if (sl[0] = 'TESTCRASH') then
    begin
      GetMem(p, 10);
      FreeMem(p);
      FreeMem(p);
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
  i, j, k, l, m, n, o, p, r: Integer;
  BattleIndex: Integer;
  Battle: TBattle;
  Client: TClient;
  Bot: TBot;
  tmp: string;
  tmpInt, tmpInt2: Integer;
  tmpBool: Boolean;
  changed: Boolean;
  count: Integer;
  time: Cardinal;
  size: Integer;
  rect: TRect;
  index: Integer;
  battletype: Integer;

begin

  if s = '' then Exit;
  sl := ParseString(s, ' ');
  sl[0] := UpperCase(sl[0]);

  // using Exit inside a block causes this method not to reach the end, where sl is freed. This probably means memory leak,
  // so use Exit only if error occured!

  if sl[0] = 'TASSERVER' then
  begin
    if (sl.Count < 2) or (not CheckServerVersion(sl[1])) then
    begin
      AddMainLog('This server version is not supported with this client!', Colors.Info);
      AddMainLog('Requesting update from server ...', Colors.Info);
      TryToSendData('REQUESTUPDATEFILE ' + VERSION_NUMBER); // we ask server if he has an update for us
    end
    else
    begin
      if Status.Registering then TryToRegister(Preferences.Username, Preferences.Password)
      else TryToLogin(Preferences.Username, Preferences.Password);
    end;
  end
  else if sl[0] = 'REDIRECT' then
  begin
    if (sl.Count <> 2) then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end
    else
    begin
      AddMainLog('Server is redirecting us to: ' + sl[1], Colors.Info);
      TryToDisconnect;
      Preferences.ServerIP := sl[1];
      TryToConnect;
    end;
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
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
      AddMainLog('Unable to join channel "' + sl[1] + '" (' + MakeSentence(sl, 2) + ')', Colors.Info);
    end;
  end
  else if sl[0] = 'ADDUSER' then
  begin
    if sl.Count <> 4 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    if sl.Count <> 4 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    try
      tmpint := StrToInt(sl[3]);
    except
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    AddClientToAllClientsList(sl[1], 0, LowerCase(sl[2]), tmpint); // server will update client's status later
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
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
      { We don't need to manually remove client from channels or battle, since
        server notifies us with "LEFT"/"LEFTBATTLE" commands. However, we must
        manually remove client from a private chat if it is open. }

      i := GetTabWindowPageIndex(sl[1]);
      if i <> -1 then RemoveClientFromTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]);

      if not RemoveClientFromAllClientsList(sl[1]) then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      end;

      UpdateClientsListBox;
    end;
  end
  else if sl[0] = 'ADDBOT' then
  begin
    if sl.Count < 6 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    try
      tmpint := StrToInt(sl[1]);
      tmpint2 := StrToInt(sl[4]);
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

    if Battle.GetBot(sl[2]) <> nil then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
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
    end
    else
    begin
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
    end;
  end
  else if sl[0] = 'CHANNELS' then
  begin
    if sl.Count < 2 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
      AddMainLog('[CHANNELS] ' + MakeSentence(sl, 1), Colors.Normal);
    end;
  end
  else if sl[0] = 'JOINED' then
  begin
    if sl.Count <> 3 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
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
    end;
  end
  else if sl[0] = 'LEFT' then
  begin
    if sl.Count <> 3 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
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
        AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* ' + sl[2] + ' has left ' + PageControl1.Pages[i].Caption, Colors.ChanLeft);

      UpdateClientsListBox;
    end;
  end
  else if sl[0] = 'CHANNELTOPIC' then
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

    AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* Topic is ''' + MakeSentence(sl, 2) + '''', Colors.Topic);
  end
  else if sl[0] = 'SAID' then
  begin
    if sl.Count < 4 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + sl[2] + '> ' + MakeSentence(sl, 3), Colors.Normal);
    end;
  end
  else if sl[0] = 'SAIDEX' then
  begin
    if sl.Count < 4 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '* ' + sl[2] + ' ' + MakeSentence(sl, 3), Colors.SayEx);
    end;
  end
  else if sl[0] = 'SAIDPRIVATE' then
  begin
    if sl.Count < 3 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
      i := GetTabWindowPageIndex(sl[1]);
      if i = -1 then
      begin
        i := AddTabWindow(sl[1]);
        if not AddClientToTab(PageControl1.Pages[i] as TMyTabSheet, sl[1]) then
        begin
          AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
          Exit;
        end;
      end;

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + sl[1] + '> ' + MakeSentence(sl, 2), Colors.Normal);

      // add notification if private message and if application isn't focused:
      if (not Application.Active) and (NotificationsForm.CheckBox1.Checked) then AddNotification('Private message', '<' + sl[1] + '> ' + MakeSentence(sl, 2), 2500);

    end;
  end
  else if sl[0] = 'SAYPRIVATE' then
  begin
    if sl.Count < 3 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
    end
    else
    begin
      i := GetTabWindowPageIndex(sl[1]);
      if i = -1 then i := AddTabWindow(sl[1]);

      AddTextToChatWindow(PageControl1.Pages[i] as TMyTabSheet, '<' + Status.Username + '> ' + MakeSentence(sl, 2), Colors.Normal);
    end;
  end
  else if sl[0] = 'PONG' then
  begin
    // we don't have to respond to it
  end
  else if sl[0] = 'SAIDBATTLE' then
  begin
    if sl.Count < 3 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    BattleForm.AddTextToChat('<' + sl[1] + '> ' + MakeSentence(sl, 2), Colors.Normal);
  end
  else if sl[0] = 'SAIDBATTLEEX' then
  begin
    if sl.Count < 3 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    BattleForm.AddTextToChat('* ' + sl[1] + ' ' + MakeSentence(sl, 2), Colors.SayEx);
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
    if sl.Count <> 10 then
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
      Battle.HashCode := r;

      BattleForm.MetalTracker.Value := j;
      BattleForm.EnergyTracker.Value := k;
      BattleForm.UnitsTracker.Value := l;
      BattleForm.StartPosRadioGroup.ItemIndex := m;
      BattleForm.GameEndRadioGroup.ItemIndex := n;
      BattleForm.LimitDGunCheckBox.Checked := IntToBool(o);
      BattleForm.DiminishingMMsCheckBox.Checked := IntToBool(p);      

      // we have to change mod before hashing it:
      Status.Hashing := True; // we need this so that we know we must wait for hashing to finish when we receive REQUESTBATTLESTATUS command (we can receive it in "parallel", while hashing!)
      InitWaitForm.ChangeCaption(MSG_MODCHANGE);
      InitWaitForm.TakeAction := 0; // change mod
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
    if sl.Count < 10 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    sl2 := ParseString(MakeSentence(sl, 9), #9);

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

    Client := GetClient(sl[3]);
    if Client = nil then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    tmp := sl[4]; // IP

    try
      j := StrToInt(sl[5]);
      k := StrToInt(sl[6]);
      tmpBool := IntToBool(StrToInt(sl[7]));
      l := StrToInt(sl[8]);
    except
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    AddBattle(i, battletype, Client, tmp, j, k, tmpBool, l, sl2[0], sl2[1], sl2[2]);
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
    end
    else
    begin
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
    end;
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

    if BattleForm.IsBattleActive then
      if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
      begin
        BattleForm.AddTextToChat('* ' + Client.Name + ' has joined battle', Colors.ChanJoin);
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

    if BattleForm.IsBattleActive then
      if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
      begin
        BattleForm.AddTextToChat('* ' + Client.Name + ' has left battle', Colors.ChanJoin);
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
        VDTBattles.InvalidateNode(TBattle(Battles[i]).Node);
        if (BattleFormUnit.BattleState.Status = Joined) and (BattleState.Battle.ID = TBattle(Battles[i]).ID) and (Client.GetInGameStatus) and (changed) and (not Status.AmIInGame) then
        begin
          PostMessage(BattleForm.Handle, WM_STARTGAME, 0, 0);
          // if founder of the battle we are participating in just went in-game, we must launch the game too!
        end;
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
    if sl.Count <> 8 then
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

    BattleForm.AddTextToChat('You were kicked from battle!', Colors.Info);
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
  else if sl[0] = 'OFFERFILE' then
  begin
    if sl.Count < 2 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    sl2 := ParseString(MakeSentence(sl, 2), #9);
    if sl2.Count <> 3 then
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

    case ((tmpint and $FC) shr 2) of
    0: // patch file
      if MessageDlg('Server is offering you an update. This is what server has to say about it:' + #13#13 + sl2[2] + #13#13 + 'Do you wish to accept it?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
      begin // user has accepted the file
        DownloadFile.URL := sl2[1];
        DownloadFile.FileName := sl2[0];
        DownloadFile.ServerOptions := tmpint;
        PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);
      end
      else TryToDisconnect;

    1: // map file
      if MessageDlg('Server is offering you a map. This is what server has to say about it:' + #13#13 + sl2[2] + #13#13 + 'Do you wish to accept it?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
      begin // user has accepted the file
        DownloadFile.URL := sl2[1];
        DownloadFile.FileName := sl2[0];
        DownloadFile.ServerOptions := tmpint;
        PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);
      end
    end; // of case

  end
  else if sl[0] = 'GETFILEFAILED' then
  begin
    if sl.Count < 2 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    MessageDlg('GETFILE command failed. Reason: ' +#13+ MakeSentence(sl, 1), mtInformation, [mbOK], 0);
  end
  else if sl[0] = 'OFFERUPDATE' then
  begin
    if sl.Count < 3 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    sl2 := ParseString(MakeSentence(sl, 2), #9);
    if sl2.Count <> 2 then
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

    if MessageDlg('Server is sending you a file: "' + sl2[0] + '" (' + FormatFileSize(tmpint) + ' KB). This is what server has to say about it:' + #13#13 + sl2[1] + #13#13 + 'Do you wish to accept it?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
    begin // user has accepted the file
      {$I-}
      AssignFile(GetFile.ToFile, ExtractFilePath(Application.ExeName) + sl2[0]);
      Rewrite(GetFile.ToFile);
      {$I+}
      if not ((IOResult = 0) and (sl2[0] <> '')) then
      begin
        AddMainLog('Error: could not write to file ' + sl2[0] + '!', Colors.Error);
        Exit;
      end;

      Status.WaitingForFileTransfer := True;
      FileTransferTimer.Interval := 10000;
      FileTransferTimer.Enabled := True;
      TryToSendData('GETFILE ' + sl2[0]);
    end;
  end
  else if sl[0] = 'FILE' then
  begin
    if sl.Count < 4 then
    begin
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    try
      size := StrToInt(sl[1]);
      tmpint := StrToInt(sl[2]);
    except
      AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
      Exit;
    end;

    if GetFile.Receiving then
    begin
      AddMainLog('Error: Server is sending us new file although there is already another upload in progress!', Colors.Error);
      Exit;
    end;

    if not Status.WaitingForFileTransfer then
    begin
      AddMainLog('Error: Server is trying to send us a file although we haven''t requested it!', Colors.Error);
      TryToSendData('CANCELTRANSFER');
      Exit;
    end;

    Status.WaitingForFileTransfer := False;
    FileTransferTimer.Enabled := False;
    GetFile.Receiving := True;

    GetFile.Size := size;
    GetFile.Options := tmpint;
    GetFile.Filename := MakeSentence(sl, 3);

    AddMainLog('File transfer started (' + GetFile.Filename + '/' + IntToStr(GetFile.Size) + ' bytes' + '/' + ')', Colors.Info);
    SendMessage(GetFileForm.Handle, WM_STARTTRANSFER, 0, 0);
  end
  else if sl[0] = 'DATA' then
  begin
    if GetFile.Receiving then // if not receiving, then just ignore it
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      size := Length(sl[1]);
      if size mod 2 <> 0 then
      begin
        AddMainLog('Error: Server sent ambiguous command!', Colors.Error);
        Exit;
      end;

      BlockWrite(GetFile.ToFile, HexToString(sl[1])[1], size div 2);

      Inc(GetFile.Position, size div 2);
      SendMessage(GetFileForm.Handle, WM_UPDATETRANSFER, 0, 0);
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

  if sl <> nil then sl.Free;

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

    PlayerStateImageList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top, TClient(AllClients[Index]).GetStateImageIndex);
    (Control as TListBox).Canvas.TextOut(Rect.Left + PlayerStateImageList.Width, Rect.Top, TClient(AllClients[Index]).Name);
    if TClient(AllClients[Index]).GetAwayStatus and not TClient(AllClients[Index]).GetInGameStatus then
      PlayerStateImageList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top, 3);
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

    (Control as TListBox).Canvas.TextOut(xpos, Rect.Top, TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).Name);
    Inc(xpos, (Control as TListBox).Canvas.TextWidth(TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).Name));
    if TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetAwayStatus and not TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetInGameStatus then
      PlayerStateImageList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top, 3);

    RanksImageList.Draw((Control as TListBox).Canvas, xpos, Rect.Top, TClient((PageControl1.ActivePage as TMyTabSheet).Clients[Index]).GetRank);
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
begin;
  if Status.ConnectionState <> Disconnected then TryToDisconnect;

  try
    Socket.Proto := 'tcp';
    Socket.Addr := Preferences.ServerIP;
    Socket.Port := Preferences.ServerPort;
    Socket.LineMode := False;
    Socket.Connect;
  except
    AddMainLog('Error: cannot connect!', Colors.Error);
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
begin;
  if Password = '' then Password := '*'; // probably local LAN mode. We have to send something as a password, so we just send an "*".
  TryToSendData('LOGIN ' + Username + ' ' + Password + ' ' + IntToStr(Status.MyCPU));
end;

procedure TMainForm.TryToRegister(Username, Password: string);
begin;
  if Password = '' then Password := '*'; // we should never send empty password
  TryToSendData('REGISTER ' + Username + ' ' + Password);
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
      ClearClientsLists;
      ConnectButton.Glyph := nil; // we have to tell speedbutton somehow that he is about to be changed
      ConnectionStateImageList.GetBitmap(0, ConnectButton.Glyph);
      if Status.ConnectionState = Connecting then AddMainLog('Cannot connect to server!', Colors.Info)
      else AddMainLog('Connection to server closed!', Colors.Info);
      Status.ConnectionState := Disconnected;
      Status.Registering := False;
      Status.LoggedIn := False;
      for i := PageControl1.PageCount-1 downto 1 do TryToCloseTab(PageControl1.Pages[i] as TMyTabSheet);
      PlayResSound('disconnect');
    end;

  end; // case
end;

procedure TMainForm.SocketSessionConnected(Sender: TObject; ErrCode: Word);
begin
  if ErrCode <> 0 then Exit;

  Status.ConnectionState := Connected;
  Status.WaitingForFileTransfer := False;
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
begin
  if (Status.ConnectionState <> Connected) then Exit;

  if ((GetTickCount - Status.TimeOfLastDataSent > KEEP_ALIVE_INTERVAL) or
     (GetTickCount - Status.TimeOfLastDataReceived > KEEP_ALIVE_INTERVAL))
  then TryToSendData('PING');

  if (GetTickCount - Status.TimeOfLastDataReceived > ASSUME_TIMEOUT_INTERVAL) then
  begin
    AddMainLog('Timeout assumed. Disconnecting ...', Colors.Error);
    TryToDisconnect; // we assume timeout occured
  end;

  // we will also use this timer to check if user is away:

  if Status.LoggedIn = False then Exit;

  if (not Application.Active) and (GetTickCount - Status.AwayTime > AWAY_TIME) then
  begin
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
  SetLength(s, 256);

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

  Status.TimeOfLastDataReceived := GetTickCount;
end;

procedure TMainForm.PageControl1Change(Sender: TObject); // this event does not get always triggered when ActivePageIndex change but only when user clicks on new tab or presses CTRL+TAB / CTRL+SHIFT+TAB, but not when we add or remove tabs or change activepageindex manually. That is why we MUST trigger this event everytime we add/remove tab or change activepageindex or activepage!
begin
  UpdateClientsListBox;
//***  windows.beep(500, 300);

  // set focus to TEdit control:
  if MainForm.Enabled and MainForm.Visible then
    ((Sender as TPageControl).ActivePage.Controls[0] as TEdit).SetFocus;

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

    OnlineMapsForm.LoadOnlineMapsFromCache(ExtractFilePath(Application.ExeName) + CACHE_FOLDER);
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
begin
  if BattleForm.IsBattleActive then
  begin
    MessageDlg('You must first disconnect from current battle!', mtInformation, [mbOK], 0);
    Exit;
  end;

  // check if we have the mod at all:
  if ModList.IndexOf(TBattle(Battles[Node.Index]).ModName) = -1 then
  begin
    MessageDlg('Can''t join: you don''t have the right mod!', mtInformation, [mbOK], 0);
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
end;

function TMainForm.LoadImagesDynamically: Boolean; // used for debugging purposes only
var
  i: Integer;

  function LoadBitmap(FileName: string): TBitmap;
  begin
    Result := TBitmap.Create;
    Result.LoadFromFile(FileName);
  end;

  procedure AddBitmapToImageList(il: TImageList; FileName: string); // doesn't check for errors
  var
    bmp: TBitmap;
  begin
    bmp := TBitmap.Create;
    bmp.LoadFromFile(FileName);
    il.AddMasked(bmp, clWhite);
    bmp.Free;
  end;

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

procedure TMainForm.FileTransferTimerTimer(Sender: TObject);
begin
  Enabled := False;
  if not Status.WaitingForFileTransfer then Exit;

  Status.WaitingForFileTransfer := False;
  TryToSendData('CANCELTRANSFER'); // just in case we are lagging and server is yet to send the file
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
    1: if CompareText(Client1.Name, Client2.Name) = 0 then Result := 0 else if CompareText(Client1.Name, Client2.Name) > 0 then Result := 1 else Result := -1;
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
