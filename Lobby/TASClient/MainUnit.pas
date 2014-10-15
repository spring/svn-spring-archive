{
  Project started on: 13/06/2005
  See TASClient.dpr for details.

  For protocol description + notes see "trunk/Documentation/Lobby/LobbyProtocol.txt" (in SVN repository)

{ see "$DEFINE DONTUSETTL2" in Misc.pas! }
{ use TTL=2 when sending udp packets to keep ports open? Currently disabled because some players may be
  behind several layers of NAT and packets with TTL=2 may never reach those routers. }

unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus, Grids, ValEdit,
  VirtualTrees, ImgList, StringParser, MMSystem, AppEvnts, Math,
  GraphicEx, Registry, JvComponent, JvBaseDlg, JvDesktopAlert,
  JvDesktopAlertForm, DateUtils, Winsock, SpTBXItem, TB2Item,
  SpTBXControls, SpTBXFormPopupMenu,IniFiles,StrUtils,xmldom,
  XMLIntf, msxmldom, XMLDoc, WrapDelphi, PythonEngine, AtomPythonEngine,
  SpTBXEditors, TntStdCtrls, SpTBXTabs, DockPanel,
  Mask, JvExMask, JvSpin,TntComCtrls,JclUnicode,
  GR32_Image, VarPyth, PythonGUIInputOutput,
  RichEdit2, ExRichEdit, JvComponentBase, JvMTComponents, class_TIntegerList,
  RegExpr,TntGraphics,SpTBXDkPanels, TB2Dock, UWebBrowserWrapper,TypInfo,TntForms,
  Clipbrd,SyncObjs, JvExStdCtrls, JvBehaviorLabel, OleCtrls, SHDocVw,
  JvWinampLabel, JvExControls, JvLinkLabel, ActnList, JvgHint, OpenGL1x,
  SpTBXSkins,pngimage, SpTBXExtEditors, BotOptionsFormUnit,
  OverbyteIcsHttpProt, OverbyteIcsWndControl, OverbyteIcsWSocket,
  OverbyteIcsMultipartHttpDownloader,ActiveX, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPClient, IdUDPServer,IdSocketHandle;

const
  SpecialUrlProtocols : array[0..0] of string =
    (
      'spring'
    );

  RelayedCommands : array[0..20] of string =
   (
      'UPDATEBATTLEINFO',
      'SETSCRIPTTAGS',
      'REMOVESTARTRECT',
      'ADDSTARTRECT',
      'REMOVESTARTRECT',
      'ADDSTARTRECT',
      'ENABLEALLUNITS',
      'DISABLEUNITS',
      'SETSCRIPTTAGS',
      'FORCETEAMNO',
      'FORCEALLYNO',
      'FORCETEAMCOLOR',
      'FORCESPECTATORMODE',
      'KICKFROMBATTLE',
      'HANDICAP',
      'REMOVEBOT',
      'UPDATEBOT',
      'RING',
      'SCRIPTSTART',
      'SCRIPT',
      'SCRIPTEND'
    );
  CommandList : array[0..49] of string =
   (
      'CONNECT',
      'QUIT',
      'JOIN',
      'PART',
      'CHANNELS',
      'LIST',
      'ME',
      'RING',
      'HELP',
      'UPTIME',
      'KICK',
      'RENAME',
      'PASSWORD',
      'TOPIC',
      'CHANMSG',
      'INGAME',
      'IP',
      'FINDIP',
      'LASTIP',
      'MUTE',
      'UNMUTE',
      'MUTELIST',
      'TESTNOTIFY',
      'FORCEUPDATE',
      'FORCEBETAUPDATE',
      'TESTUDP',
      'TESTMD5',
      'TESTCRASH',
      'VERSION',
      'TESTFLOOD',
      'TESTAGREEMENT',
      'LOCALIP',
      'PING',
      'MSG',
      'HOOK',
      'SCRIPTSDEBUGWINDOW',
      'FORCESTART',
      'FORCEQUIT',
      'ISSPADSAUTOHOST',
      'ISSPRINGIEAUTOHOST',
      'ISNTAUTOHOST',
      'GETDOWNLOADLINKS',
      'GETENGINEDOWNLOADLINKS',
      'DOWNLOADMAP',
      'DOWNLOADMOD',
      'DOWNLOADMODARCHIVE',
      'DOWNLOADRAPID',
      'RAPIDLIST',
      'OPENPLAYERCHATLOGS',
      'RAPIDTOSDD'
   ) ;
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

  LobbyMailAddress = 'satirik@climachine.com';

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
    OldMsgs: TColor;
    BattleDetailsNonDefault: TColor;
    BattleDetailsChanged: TColor;
    ClientIngame: TColor;
    ReplayWinningTeam: TColor;
    SkillLowUncertainty: TColor;
    SkillAvgUncertainty: TColor;
    SkillHighUncertainty: TColor;
    SkillVeryHighUncertainty: TColor;
  end;

  TTeamColors = array[0..19] of TColor;

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
  $00AAAAAA,  // light grey
  $00666666,  // dark grey
  $0000FF1A,  // light green
  $00FFD6F4,  // pink
  $0000A6FF,  // orange
  $00FFEE00,
  $00FF69E3,
  $0081BD00,
  $000D0073,
  $00009191,
  $000000FF
  );

const
  VERSION_NUMBER = '1.07'; // Must be float value! (with a period as a decimal seperator)
  PROGRAM_VERSION = 'TASClient ' + VERSION_NUMBER;
  KEEP_ALIVE_INTERVAL = 10000; // in milliseconds. Tells us what should be the maximum "silence" time before we send a ping to the server.
  ASSUME_TIMEOUT_INTERVAL = 30000; // in milliseconds. Must be greater than KEEP_ALIVE_INTERVAL! If server hasn't send any data to us within this interval, then we assume timeout occured. It's us who must make sure we get constant replies from server by pinging it.
  LOCAL_TAB = '$Local'; // caption of main (command) tab window. Must be special so that is different from channel names or user names, that is why there is a "$" in front of it.
  SUPPORTED_SERVER_VERSIONS: array[0..2] of string = ('0.35','0.36', '0.37'); // client can connect ONLY to server with one of these version numbers
  EOL = #13#10;
  MAX_MSG_ID = 65535; // when sending commands to the server they may be assigned an unique ID, MAX_MSG_ID is the maximum value of this ID (note that you may assign IDs any way you want, random, consecutive, or even not at all). Currently this program assigns consecutive IDs, so once it reaches this value, the next will be 0, then 1 etc.

  LOG_FILENAME = 'TASClient_Debug.log';
  MODS_PAGE_LINK = 'http://springfiles.com/spring/games';
  MAPS_PAGE_LINK = 'http://springfiles.com/spring/spring-maps';
  AWAY_TIME = 300000; // in milliseconds. After this period of time (of inactivity), client will set its state to "away"
  IDL_DEFAULT_MSG = 'The user has been idling for $t minutes.';
  AWAY_DEFAULT_MSG = 'I am currently away from the computer.';
  LOBBY_FOLDER = 'lobby'; // main folder for lobby, in which all other folders are put (logs, cache, var, ...)
  CACHE_FOLDER = LOBBY_FOLDER + '\' + 'cache';
  MAPS_CACHE_FOLDER = CACHE_FOLDER + '\' + 'maps'; // we store info of local maps there plus minimaps
  MODS_CACHE_FOLDER = CACHE_FOLDER + '\' + 'mods'; // we store info of local mods there like default mod options
  LOG_FOLDER = LOBBY_FOLDER + '\' + 'logs'; // this is where we store chat logs
  VAR_FOLDER = LOBBY_FOLDER + '\var';
  GROUPS_FILE = VAR_FOLDER + '\' + 'groups.ini';
  LAYOUTS_FILE = VAR_FOLDER + '\' + 'layouts.ini';
  AWAY_MSGS_FILE = VAR_FOLDER + '\' + 'away_messages.ini';
  AUTOJOIN_PRESETS_FOLDER = VAR_FOLDER + '\autoJoinPresets';
  MENU_SETTINGS_FILE = VAR_FOLDER + '\' + 'menuSettings.ini';
  TIPS_FILE = VAR_FOLDER+'\tips.txt';
  RENAMES_FILE = VAR_FOLDER+'\renames.ini';
  SPRING_SETTINGS_PROFILE_FILE = VAR_FOLDER + '\SpringSettingsProfiles.ini';
  CLIENTS_DATA_FILE = VAR_FOLDER + '\UsersData.ini';
  FILTERS_FOLDER = VAR_FOLDER + '\filters';
  REPLAY_FILTERS_FOLDER = VAR_FOLDER + '\replayFilters';
  SPSKIN_FOLDER = LOBBY_FOLDER + '\SPThemes';
  SCRIPTS_FOLDER = LOBBY_FOLDER + '\Python\engine';
  SCRIPTS_PROFILES_FOLDER = LOBBY_FOLDER + '\Python\scripts\layoutScripts';
  SCROLLING_NEWS_TEMPLATE = '\template.html';
  SCROLLING_NEWS_ITEM_TEMPLATE = '\newsItem.html';
  SCROLLING_NEWS_NEW_ITEM_TEMPLATE = '\newNewsItem.html';
  SCROLLING_NEWS_PAGE = '\page.html';
  FIRST_UDP_SOURCEPORT = 8300; // udp source port (used with "fixed source ports" NAT traversal technique) of the second (first one is host) client in clients list of the battle. Third client uses this+1 port, fourth one this+2, etc.
  AIDLL_FOLDER = 'AI/Bot-libs'; // searching for *.dll in this folder will return all bots that you can use to play with
  CANT_WRITE_SCRIPT_MSG = 'Could''nt write the start script file ''script.txt'', try again ?';
  SCROLLING_NEWS_DIR_DEFAULT = LOBBY_FOLDER + '\ScrollingNews';

  REMOTE_JOIN_COMMAND = '!join';

  MAX_PLAYERS = 200; // max. players supported by Spring in a game
  MAX_TEAMS = 100; // max. teams supported by Spring in a game (MAX_ALLIES would be same as MAX_TEAMS, so no need for it)
  MAX_POPUP = 8; // max popup notification displaying at the same time
  MAX_AUTOSENDMSG = 2; // limit the auto sent msg when auto specing or kicking players

  FLOODLIMIT_BYTESPERSECOND = 1024;
  FLOODLIMIT_SECONDS = 9; // the limit is actually 10seconds, but to be sure it won't exceed the limit we use 9seconds

  DOWNLOADER_SEGMENTS = 4;

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
  WM_REFRESHOUTPUT = WM_USER + 13; // used to refresh script debug output
  WM_SCRIPT = WM_USER + 14; // used to add a msg from a script to a textbox (tab RichEdit or battleform)
  WM_UNLOCK_WINDOW = WM_USER + 15; // used to unlock the menu form display to avoid white flashes
  WM_REFRESHMAINLOG = WM_USER + 16; // used to avoid richedit problems
  WM_SPRINGSOCKETMSG = WM_USER + 17; // used to display chat msg ingame
  WM_ASYNCPREFUPDATE = WM_USER + 18; // used to update the preferences in the main thread (from python)

  QUEUE_LENGTH = 4096;

  Ranks: array[0..7] of string = ('Newbie', 'Beginner', 'Average', 'Above average', 'Experienced', 'Highly experienced', 'Veteran', 'Ghost');

type

  TFastQueue = class
  protected
    Tail,Head: integer;
    Data: array[0..QUEUE_LENGTH] of String;
  public
    constructor Create;
    function Enqueue(s: String): Integer;
    function Dequeue: String;
  end;

  TPlayerStatistics =
  record
    numCommands : integer;
    unitCommands : integer; // total amount of units affected by commands   (divide by numCommands for average units/command)
    mousePixels : integer;
    mouseClicks : integer;
    keyPresses : integer;
  end;

  TTeamStatistics =
  record
    frame : integer;

    metalUsed : single;
    energyUsed : single;

    metalProduced : single;
    energyProduced : single;

    metalExcess : single;
    energyExcess : single;

    metalReceived : single;
    energyReceived : single;
    
    metalSent : single;
    energySent : single;

    damageDealt : single;
    damageReceived : single;

    unitsProduced : integer;
    unitsDied : integer;
    unitsReceived : integer;
    unitsSent : integer;
    unitsCaptured : integer;
    unitsOutCaptured : integer;
    unitsKilled : integer;
  end;

  TDemoHeaderV3 =
  record
    magic: array[0..15] of Char;
    version: integer;
    headerSize: integer;
    versionString: array[0..15] of Char;
    gameID: array[0..15] of Char;
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

  TDemoHeaderV4 = record
    magic: array[0..15] of Char;
    version: integer;
    headerSize: integer;
    versionString: array[0..15] of Char;
    gameID: array[0..15] of Char;
    unixTime: UInt64;
    scriptSize: integer;
    demoStreamSize: integer;
    gameTime: integer;
    wallclockTime: integer;
    numPlayers: integer;
    playerStatSize: integer;
    playerStatElemSize: integer;
    numTeams: integer;
    teamStatSize: integer;
    teamStatElemSize: integer;
    teamStatPeriod: integer;
    winningAllyTeam: integer;
  end;

  TDemoHeaderV5 = record
    magic: array[0..15] of Char;
    version: integer;
    headerSize: integer;
    versionString: array[0..255] of Char;
    gameID: array[0..15] of Char;
    unixTime: UInt64;
    scriptSize: integer;
    demoStreamSize: integer;
    gameTime: integer;
    wallclockTime: integer;
    numPlayers: integer;
    playerStatSize: integer;
    playerStatElemSize: integer;
    numTeams: integer;
    teamStatSize: integer;
    teamStatElemSize: integer;
    teamStatPeriod: integer;
    winningAllyTeamsSize: integer;
  end;

  TDemoHeaderGeneric = class
  protected
    function getMagic: string;
    function getHeaderSize: integer;
    function getVersionString: string;
    function getGameID: string;
    function getUnixTime: UInt64;
    function getScriptSize: integer;
    function getDemoStreamSize: integer;
    function getGameTime: integer;
    function getWallClockTime: integer;
    function getMaxPlayerNum: integer;
    function getNumPlayers: integer;
    function getPlayerStatSize: integer;
    function getPlayerStatElemSize: integer;
    function getNumTeams: integer;
    function getTeamStatSize: integer;
    function getTeamStatElemSize: integer;
    function getTeamStatPeriod: integer;
    function getWinningAllyTeam: integer;
    function getWinningAllyTeamsSize: integer;
  public
    version: integer;
    demoHeaderV3: TDemoHeaderV3;
    demoHeaderV4: TDemoHeaderV4;
    demoHeaderV5: TDemoHeaderV5;

    constructor Create;
    property magic: string read getMagic;
    property headerSize: integer read getHeaderSize;
    property versionString: string read getVersionString;
    property gameID: string read getGameID;
    property unixTime: UInt64 read getUnixTime;
    property scriptSize: integer read getScriptSize;
    property demoStreamSize: integer read getDemoStreamSize;
    property gameTime: integer read getGameTime;
    property wallclockTime: integer read getWallClockTime;
    property maxPlayerNum: integer read getMaxPlayerNum;
    property numPlayers: integer read getNumPlayers;
    property playerStatSize: integer read getPlayerStatSize;
    property playerStatElemSize: integer read getPlayerStatElemSize;
    property numTeams: integer read getNumTeams;
    property teamStatSize: integer read getTeamStatSize;
    property teamStatElemSize: integer read getTeamStatElemSize;
    property teamStatPeriod: integer read getTeamStatPeriod;
    property winningAllyTeam: integer read getWinningAllyTeam;
    property winningAllyTeamsSize: integer read getWinningAllyTeamsSize;

    function getWinningAllyTeamsSizePosition: integer;
    function getPlayerStatsPosition: integer;
  end;

  TFilterText =
  record
    filterType : (HostName, MapName, ModName, Description, DisabledUnits, SpringVersion, FileName, Players, MapModOption, AllBattle);
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

  TMyTabSheet = class(TDockableForm)
  protected
    procedure MyTabSheetOnActivate(Sender:TObject);
    procedure MyTabSheetOnClose(Sender: TObject; var Action: TCloseAction);
  public
    PMId: integer;
    Clients: TList; // do not free any of the clients in this list! See AllClients list's comments
    ClientListBoxPosition: integer;
    History: TWideStringList; // here we store everything user has typed in. User can access it by pressing UP/DOWN keys
    HistoryIndex: Integer;
    AutoScroll: Boolean; // if true, we will scroll rich edit to the new line added
    LogFile: TFileStream;
    LogFileName: String;
    constructor CreateNew(AOwner: TComponent; Dummy: Integer); override;
    destructor Destroy; override;
    procedure ScrollRichEditToBottom;
  end;

  TClientGroup = class
  public
    Name: string;
    EnableColor: boolean;
    Color: integer;
    Clients: TStrings;
    ClientsIds: TIntegerList;
    AutoKick : boolean;
    AutoSpec : boolean;
    NotifyOnHost : boolean;
    NotifyOnJoin : boolean;
    NotifyOnBattleEnd : boolean;
    NotifyOnConnect : boolean;
    HighlightBattles : boolean;
    EnableChatColor : boolean;
    ChatColor : integer;
    ReplaceRank: boolean;
    Rank: integer;
    BalanceInSameTeam: boolean;
    Ignore: boolean;
    ExecuteSpecialCommands: boolean;

    constructor Create(Name: string; Color: Integer);
    destructor Destroy;
    function AddClient(nickName: string): Boolean;
    procedure RemoveClient(nickName: string);

    procedure GroupUpdated;
  end;

  TBattle = class;

  TClient = class
  protected
    Group: TClientGroup;
    FIsRenamed: Boolean;
    FDisplayName: WideString;
    FIgnored: Boolean;
    FNameHistory: TWideStringList;

    // internal properties functions
    function IGetDisplayName: WideString;
    procedure ISetDisplayName(displayName: WideString);
    procedure ISetIsIgnored(ignored: Boolean);
  public
    Id: integer;
    Name: WideString; // client's username

    RecentNames: string; // use for modos with FINDIP
    FStatus: Integer; // client's status (normal, in game)
    FBattleStatus: Integer; // only used for clients participating in the same battle as the player
    TeamColor: Integer; // $00BBGGRR where B = blue, G = green, R = red
    FInBattle: Boolean; // is this client participating in a battle?
    Country: string; // two-character country code based on ISO 3166
    CPU: Integer; // CPU's speed in MHz (or equivalent if AMD). Value of 0 means that client couldn't figure out its CPU speed.
    StatusRefreshed : Boolean;
    IP: string; // this field is assigned by the CLIENTIPPORT command only when needed, generally it is set to '' (empty string)
    PublicPort: Integer; // client's public UDP source port. Used with NAT traversing (e.g. "hole punching")
    AwayMessageSent: boolean; // to not resend the away message each time the player send you a message
    AutoKickMsgSent : integer;
    AutoSpecMsgSent : integer;

    Battle: TBattle;
    BattleJoinPassword: WideString;
    IngameId: integer;

    Visible: boolean;

    ScriptIcons: TIntegerList;

    constructor Create(Name: WideString; Status: Integer; Country: string; CPU: Integer; id: integer);
    destructor Destroy;override;

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
    function isComShareLeader: Boolean;
    procedure SetGroup(g: TClientGroup);
    function GetGroup: TClientGroup;
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

    procedure SetStatus(s: integer);
    property Status: integer read FStatus write SetStatus;

    procedure SetBattleStatus(bs: integer);
    property BattleStatus: integer read FBattleStatus write SetBattleStatus;

    procedure SetInBattle(b: Boolean);
    property InBattle: Boolean read FInBattle write SetInBattle;

    procedure AddNewCustomIcon;
    function GetCustomIconId(iconType: integer): integer;
    procedure SetCustomIconId(iconType: integer; id: integer);

    property isRenamed: Boolean read FIsRenamed;
    property DisplayName: WideString read IGetDisplayName write ISetDisplayName;
    property isIgnored: Boolean read FIgnored write ISetIsIgnored;
    property NameHistory: TWideStringList read FNameHistory;

    class function GetLatestName(id: integer):WideString;
    class function GetDisplayName(id: integer):WideString;
    class function GetIsRenamed(id: integer): Boolean;
    class function GetNameHistory(id: integer): TWideStringList;
    class function GetNameHistory2(id: integer): TStringList;
    class function GetIsIgnored(id: integer): Boolean;
    class function GetIdByLatestName(latestName: WideString): Integer;

    class procedure SetLatestName(id: integer; name: WideString);
    class procedure SetDisplayName(id: integer; displayName: WideString);
    class procedure SetIsRenamed(id: integer; isRenamed: Boolean);
    class procedure SetNameHistory(id: integer; NameHistory: TWideStringList);
    class procedure SetIsIgnored(id: integer; isIgnored: Boolean);
  end;

  TTASClientThread = class(TThread) //TDialogThread
  private
    MsgT : string;
    DlgTypeT: TMsgDlgType;
    ButtonsT : TMsgDlgButtons;
    HelpCtxT: Longint;
    MessageDlgReturn : integer;
    ACaptionT, APromptT, ADefaultT: string;
    InputBoxReturn : string;
    AddMainLogMsgT: string;
    AddMainLogColorT: TColor;
    
    procedure ShowLastMessage;
    procedure ShowInputBox;
    procedure RefreshMainLog;

  protected
    function MessageDlgThread(const Msg: string; DlgType: TMsgDlgType;Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
    function InputBoxThread(const ACaption, APrompt, ADefault: string): string;
    procedure AddMainLogThread(const Msg: string; Color: TColor);
  end;

  TKeepAliveThread = class(TTASClientThread)
  protected
    procedure Execute; override;
  end;

  TTestThread = class(TThread)
  protected
    procedure Execute; override;

  public
    constructor Create(Suspended : Boolean);
  end;

  TDownloadMapThread = class(TThread)
  private
    MapHash: integer;
    MapName: string;

    procedure GetLink;
    procedure OpenBrowser;
    procedure OnTerminateProcedure(Sender : TObject);

  protected
    procedure Execute; override;

  public
    constructor Create(Suspended : Boolean;hash: integer;name: string);
  end;

  TLobbyUpdateThread = class(TTASClientThread)
  private
    dlBeta: boolean;
    autoUpdt: boolean;
    delay: integer;
    forceUpt: boolean;
    startSpringDl: boolean;

  protected
    procedure Execute; override;

  public
    constructor Create(Suspended: Boolean;downloadBeta: boolean; autoUpdate: boolean; delayed : integer = 0; forceUpdate: boolean = False; startSpringUpdateDownloadIfNoLobbyUpdate: boolean = False);
  end;

  TScrollingNewsRefreshThread = class(TTASClientThread)
  private
    m_timer: integer;
  protected
    procedure Execute; override;

  public
    constructor Create(Suspended: Boolean;timer: integer);
  end;

  TBot = class
  public
    Name: string;
    OwnerName: string;
    AIShortName: string;
    BattleStatus: Integer;
    TeamColor: Integer; // $00BBGGRR where B = blue, G = green, R = red
    OptionsList: TList;
    OptionsForm: TBotOptionsForm;

    procedure Assign(Bot: TBot); // copies all properties of Bot to this Bot
    constructor Create(Name: string; OwnerName: string; AIShortName: string);

    // following functions extract various values from BattleStatus:
    function GetTeamNo: Integer;
    function GetAllyNo: Integer;
    function GetHandicap: Integer;
    function GetSide: Integer;
    procedure SetBattleStatus(bs: integer);
    procedure SetTeamColor(c: integer);

    function isComSharing: Boolean;

    // following methods assign various values to BattleStatus:
    procedure SetSide(Side: Integer);
    procedure SetTeamNo(Team: Integer);
    procedure SetAllyNo(Ally: Integer);
    procedure SetHandicap(Handicap: Integer);
  end;

  TBattle = class
  protected
    CurrentHighLightGroup: TClientGroup;
  public
    ID: Integer; // each battle is identified by its unique ID (server provides us with ID for each battle)
    BattleType: Integer; // 0 = normal battle, 1 = battle replay
    NATType: Integer; // 0 = none, 1 = hole punching, 2 = fixed ports (denotes NAT traversal technique used by the host)
    Node: PVirtualNode; // link (pointer) to node in TVirtualDrawTree
    Clients: TList; // clients that are in this battle (similar to clients in a channel). First client in this list is battle's founder! Never free any of the clients in this list! See AllClients list's comments!
    SortedClients: TList;
    Bots: TList; // bots in this battle.
    RankLimit: Shortint; // if 0, no rank limit is set. If 1 or higher, only players with this rank (or higher) can join the battle (Note: rank index 1 means seconds rank, not the first one, since you can't limit game to players of the first rank because that means game is open to all players and you don't have to limit it in that case)
    Visible : boolean;
    ForcedHidden: boolean;
    StartTimeUknown: Boolean;
    StartTime: TDateTime;

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
    EngineName: string; // For example: 'my spring'
    EngineVersion: string; // For example: '94.1.1-1062-g9d16c2d develop'

    constructor Create;
    destructor Destroy; override;
    function AreAllClientsReady: Boolean;
    function AreAllClientsSynced: Boolean;
    function AreAllBotsSet: Boolean;
    function IsBattleFull: Boolean;
    function IsBattleInProgress: Boolean;
    function GetState: Integer; // use it to get index of image from BattleStatusImageList
    function ClientsToString(separator: string=', ';displayName: boolean=True): string; // returns user names in a string, separated by spaces
    function GetClient(Name: string): TClient;
    function GetBot(Name: string): TBot;
    procedure RemoveAllBots;
    function GetHighlightColor: TColor;
    procedure NextHighlight;
    function GetAvgRank: double;
  end;

  TTDFParser = class
  protected
    FScript: string;
    CompleteKeyList: TStrings;
    CompleteOriginalKeyList: TStrings;
    KeyValueList: TStrings;
    FUpperCaseScript: string;
    Corrupted: boolean;
    function GetScript:String;
    procedure SetScript(Script: string);
    procedure WriteScriptKeys(f: TStrings; completeKey: String;writtenKeys: TStrings; headWrite: Boolean);
  public
    constructor Create(Script: string);overload;
    constructor Create(s: TTDFParser);overload;
    destructor Destroy; override;
    procedure ParseScript;
    function GetSubKeys(completeKey: string):TStrings;
    function GetBruteScript:String; // DEBUG METHOD
    function ReadKeyValue(completeKey: string):String;
    procedure AddOrChangeKeyValue(completeKey: String; value: String);
    function keyExists(completeKey: string): boolean;
    procedure RemoveKey(completeKey: String);
    function isCorrupted: boolean;

    property Script: string read GetScript write SetScript;
  end;

  TScript = class(TTDFParser) // note: any TScript's method will raise an exception if something goes wrong
  protected
    { empty }
  public
    constructor Create(Script: string);overload;
    constructor Create(s: TTDFParser);overload;
    destructor Destroy; override;
    function ReadMapName: string;
    function ReadMaphash: string;
    function ReadModName: string;
    function ReadStartMetal: Integer;
    function ReadStartEnergy: Integer;
    function ReadMaxUnits: Integer;
    function ReadStartPosType: Integer;
    function ReadGameMode: Integer;
    function ReadGameMode2: Integer;
    function ReadLimitDGun: Boolean;
    function ReadDiminishingMMs: Boolean;
    function ReadGhostedBuildings: Boolean;
    function ReadDisabledUnits: TStringList;
    procedure ChangeHostIP(NewIP: string);
    procedure ChangeHostPort(NewPort: string);
    procedure ChangeMyPlayerNum(NewNum: Integer);
    procedure ChangeNumPlayers(NewNum: Integer);
    procedure TryToRemoveUDPSourcePort;
  end;

  TPresetFilters=
  record
    Name: String;
    FileName: String;
    Full: Boolean;
    InProgress: Boolean;
    Locked: Boolean;
    Passworded: Boolean;
    NatTraversal: Boolean;
    RankLimitSupEqMine: Boolean;
    MapNotAvailable: Boolean;
    ModNotAvailable: Boolean;
    Replays: Boolean;
    Players: TFilterNumber;
    Players2: TFilterNumber;
    MaxPlayers: TFilterNumber;
    AvgRank: TFilterNumber;
    TextFilters: TList;
  end;
  PPresetFilters = ^TPresetFilters;

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
  PReplayPlayer = ^TReplayPlayer;

  TReplayTeam = class
  public
    TeamId: byte;
    PlayerList: TList;
    Stats : array of TTeamStatistics;

    constructor Create;
  end;
  PReplayTeam = ^TReplayTeam;

  TReplay = class
  public
    Grade: Byte; // 0..10 (where 0 is unrated/unknown)
    Version: Byte; // 0: old demo version, 1: new demo version
    SpringVersion: String;
    FileName: string;
    FullFileName: string;
    Date: TDateTime;
    PlayerList: TList;
    TeamList: TList;
    demoHeader: TDemoHeaderGeneric;
    winningTeams: TIntegerList;
    Script: TScript;
    Node: PVirtualNode;
    TeamStatsAvailable: Boolean;

    constructor Create;
    function GetSpectatorCount: integer;
    function GetLength: integer;
    function GetTeamCount: integer;
    function GetTeam(teamId : byte): PReplayTeam;
    function isWinningTeam(teamId: integer): Boolean;
    destructor Destroy; override;
  end;
  PReplay = ^TReplay;

  TMainForm = class(TForm)
    SearchFormPopupMenu: TSpTBXFormPopupMenu;
    BattleListPopupMenu: TSpTBXPopupMenu;
    mnuSelectBattle: TSpTBXItem;
    mnuPlayWith: TSpTBXItem;
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
    mnuJobJol: TSpTBXItem;
    mnuSpringReplays: TSpTBXItem;
    HttpCli1: THttpCli;
    SpTBXSeparatorItem7: TSpTBXSeparatorItem;
    SubMenuWiki: TSpTBXSubmenuItem;
    mnuFAQ: TSpTBXItem;
    mnuPlayingSpring: TSpTBXItem;
    mnuGlossary: TSpTBXItem;
    mnuStrategyAndTactics: TSpTBXItem;
    HostBattlePopupMenu: TSpTBXPopupMenu;
    menuHostBattle: TSpTBXItem;
    mnuHostReplay: TSpTBXItem;
    SpTBXSeparatorItem8: TSpTBXSeparatorItem;
    mnuBattleScreen: TSpTBXItem;
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
    SpTBXSeparatorItem11: TSpTBXSeparatorItem;
    mnuIgnore: TSpTBXItem;
    ArrowList: TImageList;
    mnuDisplayFilters: TSpTBXItem;
    RemoveMenu: TSpTBXSubmenuItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    HighlighBattlesTimer: TTimer;
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
    SubMenuDownload: TSpTBXSubmenuItem;
    mnuSpringPortal: TSpTBXItem;
    mnuEvolutionRTSMaps: TSpTBXItem;
    mnuDarkStars: TSpTBXItem;
    SubMenuEvolutionRTS: TSpTBXSubmenuItem;
    mnuEvolutionRTSMods: TSpTBXItem;
    SearchPlayerFormPopupMenu: TSpTBXFormPopupMenu;
    mnuQuickJoinPanel: TSpTBXItem;
    SpTBXItem4: TSpTBXItem;
    HttpCli3: THttpCli;
    PyEngine: TAtomPythonEngine;
    lobbyScriptModule: TPythonModule;
    PyInOut: TPythonInputOutput;
    SpTBXSeparatorItem15: TSpTBXSeparatorItem;
    SpTBXSeparatorItem16: TSpTBXSeparatorItem;
    SpTBXSeparatorItem17: TSpTBXSeparatorItem;
    SpTBXSeparatorItem18: TSpTBXSeparatorItem;
    SpTBXSeparatorItem19: TSpTBXSeparatorItem;
    SpTBXSeparatorItem20: TSpTBXSeparatorItem;
    SpTBXSeparatorItem21: TSpTBXSeparatorItem;
    lobbyscriptWrapper: TPyDelphiWrapper;
    mnuDisableNotifications: TSpTBXItem;
    mnuTips: TSpTBXItem;
    Panel1: TSpTBXPanel;
    OpenLogs1: TSpTBXItem;
    DefaultSideImage: TImage;
    DefaultCoreImage: TImage;
    DefaultArmImage: TImage;
    BotImage: TImage;
    Panel4: TSpTBXPanel;
    OptionsSpeedButton: TSpTBXSpeedButton;
    BattleScreenSpeedButton: TSpTBXSpeedButton;
    HelpButton: TSpTBXSpeedButton;
    ReplaysButton: TSpTBXSpeedButton;
    SearchButton: TSpTBXSpeedButton;
    SinglePlayerButton: TSpTBXButton;
    ScrollingNewsTimer: TTimer;
    NewsMainPanel: TSpTBXPanel;
    ExpandNewsButton: TSpTBXButton;
    ScrollingNewsPanel: TSpTBXPanel;
    NewsPanel: TSpTBXPanel;
    ScrollingNewsRSS: TXMLDocument;
    AutojoinPopupMenu: TSpTBXPopupMenu;
    mnuPlaynow: TSpTBXItem;
    mnuSpecnow: TSpTBXItem;
    mnuAutoplayFirstAvailable: TSpTBXItem;
    mnuAutospecFirstAvailable: TSpTBXItem;
    SpTBXSeparatorItem22: TSpTBXSeparatorItem;
    SpTBXSeparatorItem23: TSpTBXSeparatorItem;
    mnuAutojoinOptions: TSpTBXItem;
    mnuSpringinfo: TSpTBXItem;
    AutojoinTimer: TTimer;
    SpTBXItem5: TSpTBXItem;
    MainDockPanel: TDockPanel;
    PlayerListPanel: TSpTBXPanel;
    ClientsListBox: TTntListBox;
    BattlesPanel: TSpTBXPanel;
    QuickJoinPanel: TSpTBXPanel;
    BattleListLabel: TSpTBXLabel;
    btSpecatateNow: TSpTBXButton;
    DoubleClickLabel: TSpTBXLabel;
    VDTBattles: TVirtualDrawTree;
    FilterGroup: TSpTBXPanel;
    FiltersTabs: TSpTBXTabControl;
    SpTBXTabItem1: TSpTBXTabItem;
    SpTBXTabItem2: TSpTBXTabItem;
    SpTBXTabSheet2: TSpTBXTabSheet;
    PresetListbox: TSpTBXListBox;
    SpTBXLabel3: TSpTBXLabel;
    SpTBXGroupBox1: TSpTBXGroupBox;
    btDeletePreset: TSpTBXButton;
    btSavePreset: TSpTBXButton;
    PresetNameTextbox: TSpTBXEdit;
    btClearPreset: TSpTBXButton;
    SpTBXTabSheet1: TSpTBXTabSheet;
    FilterList: TVirtualStringTree;
    ClearFilterListButton: TSpTBXButton;
    RemoveFromFilterListButton: TSpTBXButton;
    AddToFilterListButton: TSpTBXButton;
    FilterValueTextBox: TSpTBXEdit;
    DoNotContainsRadio: TSpTBXRadioButton;
    ContainsRadio: TSpTBXRadioButton;
    FilterListCombo: TSpTBXComboBox;
    SpTBXPanel2: TSpTBXPanel;
    FullFilter: TSpTBXCheckBox;
    InProgressFilter: TSpTBXCheckBox;
    LockedFilter: TSpTBXCheckBox;
    PasswordedFilter: TSpTBXCheckBox;
    RankLimitFilter: TSpTBXCheckBox;
    ReplaysFilter: TSpTBXCheckBox;
    ModsNotAvailableFilter: TSpTBXCheckBox;
    MapsNotAvailableFilter: TSpTBXCheckBox;
    NatTraversalFilter: TSpTBXCheckBox;
    PlayersSignButton: TSpTBXButton;
    MaxPlayersSignButton: TSpTBXButton;
    MaxPlayersFilter: TSpTBXCheckBox;
    PlayersFilter: TSpTBXCheckBox;
    OptionsPopupMenu: TSpTBXPopupMenu;
    mnuPreferences: TSpTBXItem;
    SpTBXSeparatorItem24: TSpTBXSeparatorItem;
    mnuLockView: TSpTBXItem;
    SpTBXSeparatorItem25: TSpTBXSeparatorItem;
    ViewSubMenu: TSpTBXSubmenuItem;
    mnuResetView: TSpTBXItem;
    mnuReloadViewLogin: TSpTBXItem;
    SpTBXItem6: TSpTBXItem;
    SortPopupMenu: TSpTBXPopupMenu;
    Sortbygroup1: TSpTBXItem;
    Sortbycountry1: TSpTBXItem;
    Sortbyrank1: TSpTBXItem;
    Sortbystatus1: TSpTBXItem;
    Sortbyname1: TSpTBXItem;
    Nosorting1: TSpTBXItem;
    LoadLayoutSubmenu: TSpTBXSubmenuItem;
    SaveLayoutSubmenu: TSpTBXSubmenuItem;
    mnuSaveNewLayout: TSpTBXItem;
    SpTBXSeparatorItem26: TSpTBXSeparatorItem;
    DeleteLayoutSubmenu: TSpTBXSubmenuItem;
    mnuSpringOptions: TSpTBXItem;
    SpTBXSeparatorItem27: TSpTBXSeparatorItem;
    Players2Filter: TSpTBXCheckBox;
    Players2SignButton: TSpTBXButton;
    SubMenuAutoplayFirstAvailable: TSpTBXSubmenuItem;
    SubMenuAutospecFirstAvailable: TSpTBXSubmenuItem;
    SubMenuPlaynow: TSpTBXSubmenuItem;
    SubMenuSpecnow: TSpTBXSubmenuItem;
    RankFilter: TSpTBXCheckBox;
    RankSignButton: TSpTBXButton;
    mnuRename: TSpTBXItem;
    AwayMsgsButton: TSpTBXButton;
    PlayersValueTextBox: TSpTBXSpinEdit;
    Players2ValueTextBox: TSpTBXSpinEdit;
    MaxPlayersValueTextBox: TSpTBXSpinEdit;
    RankValueTextBox: TSpTBXSpinEdit;
    ClientListOptionsPanel: TSpTBXPanel;
    PlayerFiltersPanel: TSpTBXPanel;
    SpTBXLabel4: TSpTBXLabel;
    PlayersInfoPanel: TSpTBXPanel;
    PlayersLabel: TSpTBXLabel;
    SortLabel: TSpTBXButton;
    ConnectButton: TSpTBXLabel;
    SpTBXItem1: TSpTBXItem;
    ConnectionStateLightImageList: TImageList;
    ArrowLightList: TImageList;
    ConnectionStateDarkImageList: TImageList;
    ArrowDarkList: TImageList;
    SpTBXSeparatorItem28: TSpTBXSeparatorItem;
    mnuListChannels: TSpTBXItem;
    mnuJoinChannel: TSpTBXItem;
    EnableFiltersPanel: TSpTBXPanel;
    EnableFilters: TSpTBXCheckBox;
    FiltersButton: TSpTBXButton;
    SpacerPanel1: TSpTBXPanel;
    SpacerPanel2: TSpTBXPanel;
    mnuSpringWidgetDatabase: TSpTBXItem;
    PlayerFiltersTextbox: TSpTBXButtonEdit;
    BattlePlayersPanel: TSpTBXPanel;
    BattlePlayersSplitter: TSpTBXSplitter;
    BattlePlayersButton: TSpTBXButton;
    BattlePlayersListBox: TTntListBox;
    SpTBXItem7: TSpTBXItem;
    TBControlItem1: TTBControlItem;
    tmrCumulativeDataSentHistory: TTimer;
    SpTBXSeparatorItem29: TSpTBXSeparatorItem;
    mnuDescSort: TSpTBXItem;
    mnuAscSort: TSpTBXItem;
    mnuGetModDownloadLinks: TSpTBXItem;
    mnuGetMapDlLinks: TSpTBXItem;
    mnuCopyPlayerNameToClipboard: TSpTBXItem;
    mnuBattleCopyToClipboard: TSpTBXSubmenuItem;
    mnuCopyDescription: TSpTBXItem;
    mnuCopyMapName: TSpTBXItem;
    mnuCopyModName: TSpTBXItem;
    SpTBXSeparatorItem30: TSpTBXSeparatorItem;
    SpringSocket: TIdUDPServer;
    SpTBXItem8: TSpTBXItem;
    mnuJoinMe: TSpTBXItem;
    pnlQuickBattleFilters: TSpTBXPanel;
    BattleFiltersTextbox: TSpTBXButtonEdit;
    SpacerPanel3: TSpTBXPanel;
    SpTBXItem9: TSpTBXItem;
    mnuRapidDownloader: TSpTBXItem;
    mnuGetEngineDownloadLinks: TSpTBXItem;
    procedure mnuOpenPrivateChatClick(Sender: TObject);
    procedure mnuSelectBattleClick(Sender: TObject);
    procedure mnuPlayWithClick(Sender: TObject);
    procedure mnuManageGroupsClick(Sender: TObject);
    procedure mnuNewGroupClick(Sender: TObject);
    procedure AddToGroupItemClick(Sender: TObject);
    procedure ViewItemClick(Sender: TObject);
    procedure ResortClientsLists;
    procedure SortClientInLists(client: TClient);
    procedure ClientsListBoxClick(Sender: TObject);
    procedure mnuRemoveFromGroupClick(Sender: TObject);
    procedure mnuHelpClick(Sender: TObject);
    procedure mnuSpringReplaysClick(Sender: TObject);
    procedure mnuJobJolClick(Sender: TObject);
    procedure mnuBugTrackerClick(Sender: TObject);
    procedure mnuMessageboardClick(Sender: TObject);
    procedure mnuSpringHomePageClick(Sender: TObject);
    procedure mnuFAQClick(Sender: TObject);
    procedure mnuPlayingSpringClick(Sender: TObject);
    procedure mnuGlossaryClick(Sender: TObject);
    procedure mnuStrategyAndTacticsClick(Sender: TObject);
    procedure mnuBattleScreenClick(Sender: TObject);
    procedure menuHostBattleClick(Sender: TObject);
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
  HitInfo: TVTHeaderHitInfo);
    procedure HighlighBattlesTimerTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PlayersFilterClick(Sender: TObject);
    procedure MaxPlayersFilterClick(Sender: TObject);
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
    procedure FilterListChecking(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
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
    procedure ClientsListBoxExit(Sender: TObject);
    procedure mnuSpringPortalClick(Sender: TObject);
    procedure mnuEvolutionRTSMapsClick(Sender: TObject);
    procedure mnuDarkStarsClick(Sender: TObject);
    procedure mnuEvolutionRTSModsClick(Sender: TObject);
    procedure ClientsListBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchPlayerFormPopupMenuPopup(Sender: TObject);
    procedure mnuQuickJoinPanelClick(Sender: TObject);
    procedure btPlayNowClick(Sender: TObject);
    procedure Splitter2Moving(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure SpTBXItem4Click(Sender: TObject);
    procedure btSavePresetClick(Sender: TObject);
    procedure PresetListboxClick(Sender: TObject);
    procedure btDeletePresetClick(Sender: TObject);
    procedure btClearPresetClick(Sender: TObject);
    procedure SinglePlayerButtonClick(Sender: TObject);
    procedure PyInOutSendData(Sender: TObject;
      const Data: String);
    procedure lobbyscriptWrapperInitialization(Sender: TObject);
    procedure RichEditURLClick(Sender: TObject; URL: String);
    procedure mnuTipsClick(Sender: TObject);
    procedure OpenLogs1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure PageControl1Resize(Sender: TObject);
    function IsIncludedInList(sl: TStringList; s: string):Boolean;
    procedure ScrollingNewsTimerTimer(Sender: TObject);
    procedure ExpandNewsButtonClick(Sender: TObject);
    procedure NewsBrowserNewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure OnNewsBrowserDocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure OnNewsBrowserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure PlayerFiltersTextboxChange(Sender: TObject);
    procedure mnuAutojoinOptionsClick(Sender: TObject);
    procedure mnuSpringinfoClick(Sender: TObject);
    procedure mnuPlaynowClick(Sender: TObject);
    procedure mnuSpecnowClick(Sender: TObject);
    procedure AutojoinTimerTimer(Sender: TObject);
    procedure mnuAutoplayFirstAvailableClick(Sender: TObject);
    procedure mnuAutospecFirstAvailableClick(Sender: TObject);
    procedure ClearPlayersFilterButtonClick(Sender: TObject);
    procedure SpTBXButton1Click(Sender: TObject);
    procedure SpTBXItem5Click(Sender: TObject);
    procedure OnDockHandlerRefresh(Sender: TObject);
    procedure mnuPreferencesClick(Sender: TObject);
    procedure mnuLockViewClick(Sender: TObject);
    procedure mnuResetViewClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuSaveNewLayoutClick(Sender: TObject);
    procedure mnuSaveLayoutClick(Sender: TObject);
    procedure mnuLoadLayoutClick(Sender: TObject);
    procedure mnuDeleteLayoutClick(Sender: TObject);
    procedure LoadLayouts;
    procedure mnuSpringOptionsClick(Sender: TObject);
    procedure PresetListboxDblClick(Sender: TObject);
    procedure Players2FilterClick(Sender: TObject);
    procedure Players2SignButtonClick(Sender: TObject);
    procedure Players2ValueTextBoxChange(Sender: TObject);
    procedure FilterListEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure FilterListNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure FilterListClick(Sender: TObject);
    procedure AutojoinPopupMenuPopup(Sender: TObject);
    procedure RankFilterClick(Sender: TObject);
    procedure RankSignButtonClick(Sender: TObject);
    procedure RankValueTextBoxChange(Sender: TObject);
    procedure OptionsPopupMenuPopup(Sender: TObject);
    procedure mnuRenameClick(Sender: TObject);
    procedure BattleListPopupMenuPopup(Sender: TObject);
    procedure ClientPopupMenuPopup(Sender: TObject);
    procedure VDTBattlesHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure FilterListDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: WideString; const CellRect: TRect;
      var DefaultDraw: Boolean);
    procedure ConnectButtonMouseEnter(Sender: TObject);
    procedure ConnectButtonMouseLeave(Sender: TObject);
    procedure SpTBXItem1Click(Sender: TObject);
    procedure mnuJoinChannelClick(Sender: TObject);
    procedure mnuListChannelsClick(Sender: TObject);
    procedure PlayersValueTextBoxSubEditButton0Click(Sender: TObject);
    procedure Players2ValueTextBoxSubEditButton0Click(Sender: TObject);
    procedure MaxPlayersValueTextBoxSubEditButton0Click(Sender: TObject);
    procedure RankValueTextBoxSubEditButton0Click(Sender: TObject);
    procedure mnuSpringWidgetDatabaseClick(Sender: TObject);
    procedure FilterListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure BattlePlayersButtonClick(Sender: TObject);
    procedure VDTBattlesFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure SpTBXItem7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tmrCumulativeDataSentHistoryTimer(Sender: TObject);
    procedure mnuAscSortClick(Sender: TObject);
    procedure mnuDescSortClick(Sender: TObject);
    procedure SortPopupMenuPopup(Sender: TObject);
    procedure mnuGetMapDlLinksClick(Sender: TObject);
    procedure mnuGetModDownloadLinksClick(Sender: TObject);
    procedure mnuCopyPlayerNameToClipboardClick(Sender: TObject);
    procedure mnuCopyDescriptionClick(Sender: TObject);
    procedure mnuCopyMapNameClick(Sender: TObject);
    procedure mnuCopyModNameClick(Sender: TObject);
    procedure SpringSocketUDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure SpTBXItem8Click(Sender: TObject);
    procedure mnuJoinMeClick(Sender: TObject);
    procedure BattleFiltersTextboxChange(Sender: TObject);
    procedure BattleFiltersTextboxSubEditButton0Click(Sender: TObject);
    procedure SpTBXItem9Click(Sender: TObject);
    procedure mnuRapidDownloaderClick(Sender: TObject);
    procedure mnuGetEngineDownloadLinksClick(Sender: TObject);
  published
    MainTitleBar: TSpTBXTitleBar;
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
    ScrollingNewsBrowser: TWebBrowserWrapper;
    NewsBrowser: TWebBrowserWrapper;

    procedure AutoSpecFirstAvailablePresetClick(Sender: TObject);
    procedure AutoPlayFirstAvailablePresetClick(Sender: TObject);
    procedure PlayNowClick(Sender: TObject);
    procedure SpecNowClick(Sender: TObject);
  protected
    selectedBattlePlayers: TBattle;

    procedure GetDrawItemClientList(control: TWinControl;var res: TList);
  public
    lastActiveTab: TMyTabSheet;
    ChatTabs: TList;
    autoCompletionHint : THintWindow;
    richContextMenuClick: TPoint;
    richContextMenu: TExRichEdit;
    
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;

    procedure OnDataHasArrivedMessage(var Msg: TMessage); message WM_DATAHASARRIVED;
    procedure OnOpenOptionsMessage(var Msg: TMessage); message WM_OPENOPTIONS;
    procedure OnDoRegisterMessage(var Msg: TMessage); message WM_DOREGISTER;
    procedure OnCloseTabMessage(var Msg: TMessage); message WM_CLOSETAB;
    procedure OnConnectMessage(var Msg: TMessage); message WM_CONNECT;
    procedure OnForceReconnectMessage(var Msg: TMessage); message WM_FORCERECONNECT;
    procedure OnConnectToNextHostMessage(var Msg: TMessage); message WM_CONNECT_TO_NEXT_HOST;
    procedure OnScriptMessage(var Msg: TMessage); message WM_SCRIPT;
    procedure WMAfterCreate(var AMsg: TMessage); message WM_AFTERCREATE; // we will do some post-initialization here
    procedure RefreshMainLog(var AMsg: TMessage); message WM_REFRESHMAINLOG;
    procedure OnSpringSocketMsg(var AMsg: TMessage); message WM_SPRINGSOCKETMSG;
    procedure OnAsyncPreferencesUpdate(var Msg: TMessage); message WM_ASYNCPREFUPDATE;

    function LoadImagesDynamically: Boolean;

    procedure InitializeFlagBitmaps;
    procedure DeinitializeFlagBitmaps;
    function GetFlagBitmap(Country: string): TBitmap; // Country must contain two-letter country code (for example: "si" for Slovenia)
    function GetCountryName(CountryCode: string): string;
    function GetCountryCode(CountryName: string): string;

    procedure CloseAllLogs; // closes all file streams for channels, private chats and battle log
    procedure OpenAllLogs;

    function AreWeLoggedIn: Boolean;

    function AddTabWindow(Caption: string; SetFocus: Boolean; pmId: integer = -1): TMyTabSheet;
    function GetTabWindowPageIndex(Caption: string): Integer; overload;
    function GetTabWindowPageIndex(Client: TClient): Integer; overload;
    procedure ChangeActivePageAndUpdate(PageControl: TPageControl; PageIndex: Integer); // never change ActivePageIndex manually, since it doesn't trigger OnChange event!
    procedure RichEditMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RichEditDblClick(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditClick(Sender: TObject);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure InputEditChange(Sender: TObject);
    function CheckServerVersion(ServerVersion: string): Boolean;
    procedure ProcessCommand(s: WideString; CameFromBattleScreen: Boolean);
    procedure ProcessRemoteCommand(s: WideString); // processes command received from server
    procedure TryToCloseTab(TabSheet: TMyTabSheet);
    procedure OpenPrivateChat(Client: TClient);

    function AddClientToTab(ClientList: TList; ClientName: WideString): Boolean;
    function RemoveClientFromTab(Tab: TMyTabSheet; ClientName: WideString): Boolean;
    procedure RemoveAllClientsFromTab(Tab: TMyTabSheet);
    procedure UpdateClientsListBox;
    procedure UpdateBattlePlayersListBox(battle: TBattle; client:TClient);

    function AddBattle(ID: Integer; BattleType: Integer; NATType: Integer; Founder: TClient; IP: string; Port: Integer; MaxPlayers: Integer; Password: Boolean; Rank: Byte; MapHash: Integer; MapName: string; Title: WideString; ModName: string; EngineName: string; EngineVersion: string): TBattle;
    function RemoveBattle(ID: Integer): Boolean;
    function RemoveBattleByIndex(Index: Integer): Boolean;
    function GetBattle(ID: Integer): TBattle;
    function GetBattleFromNode(Node : PVirtualNode): TBattle;
    function GetFilterIndexFromNode(Node : PVirtualNode): integer;
    function GetBattleIndex(ID: Integer): Integer;

    procedure ClearAllClientsList;
    procedure ClearClientsLists; // clears all clients list (in channels, private chats, battle, local tab, ...)
    procedure AddClientToAllClientsList(Name: WideString; Status2: Integer; Country: string; CPU: Int64; id :integer);
    function RemoveClientFromAllClientsList(Name: WideString): Boolean;
    function GetClient(Name: WideString): TClient; // returns nil if not found
    function GetClientByIP(IP: string): TClient; // returns nil if not found
    function GetClientById(Id: integer): TClient; // returns nil if not found
    function GetClientIndexEx(Name: WideString; ClientList: TList): Integer;

    function GetGroup(Name: string): TClientGroup; // returns nil if not found

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
    procedure TryToAutoCompleteWord(Edit: TTntMemo; Clients: TList);
    function TryToAutoCompleteCommand(word: string; pos: integer;Edit: TTntMemo):string;

    procedure SortClientsList(List: TList; SortStyle: Integer; SortAsc: Boolean);
    procedure SortClientInList(client: TClient;List: TList; SortStyle: Integer; SortAsc: Boolean);
    procedure SortBattlesList(BattleList: TList; SortStyle: Integer; Ascending: Boolean; CountMe: Boolean = True);
    procedure RefreshBattlesNodes;
    function CompareClients(Client1: TClient; Client2: TClient; SortStyle: Integer; SortAsc: Boolean): Shortint; // used with SortClientsList method (and other methods?)
    function CompareBattles(Battle1, Battle2: TBattle; SortStyle: Integer; SortDirection: Boolean; CountMe: Boolean = False): Shortint;

    function isBattleVisible(Battle:TBattle;Filters: TPresetFilters; countMe: Boolean = True):Boolean;
    procedure SortBattleInList(Index: Integer; SortStyle: Integer; Ascending: Boolean);

    procedure AddNotification(HeaderText, MessageText: string; DisplayTime: Integer;OnClick: Boolean = false;BattleId: integer = -1);
    function MakeNotification(HeaderText, MessageText: string; DisplayTime: Integer; canClick: boolean): TJvDesktopAlert;
    procedure OnNotificationShow(Sender: TObject);
    procedure ExecuteNotification(N: TJvDesktopAlert);
    procedure NotificationClick(Sender: TObject);
    procedure NotificationClose(Sender: TObject);

    procedure FinaliseStart;

    procedure UpdateColorImageList; // will (re)populate ColorImageList

    procedure SaveGroups;
    procedure LoadGroups;

    procedure SaveAwayMessages;
    procedure LoadAwayMessages;

    procedure CheckNewVersion;
    procedure SetAway(AwayIndex: integer);

    procedure ResetAutoKickMsgSentCounters;
    procedure ResetAutoSpecMsgSentCounters;

    procedure initLobbyScript;
    procedure initFiltersPresets;

    function getAutojoinBestBattle(autoJoinPresetList:TList):TBattle;

    procedure SaveFiltersToFile(Filters: TPresetFilters);
    procedure LoadFiltersFromFile(var Filters: TPresetFilters);
    procedure LoadPresets;
    procedure FiltersUpdated;
    procedure UpdateFilters(pFilters: TPresetFilters);
    procedure CopyFilters(srcFilters: TPresetFilters; var dstFilters: TPresetFilters);

    procedure LoadRenames;
    procedure PrintUnitsyncErrors;
  published
    MainPCH : TPageControlHost;
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
    procedure JoinBattle(Battle: TBattle; SpecatorMode: Boolean = False; Password: string = '');
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
  HitInfo: TVTHeaderHitInfo);
    procedure ClientsListBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClientsListBoxMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ConnectButtonClick(Sender: TObject);
    procedure SortLabelClick(Sender: TObject);
    procedure RefreshBattleList;
  private
    MainLogCS: TCriticalSection;
    function TryToSendCommand(Command: WideString; SendParams: Boolean; Params: WideString; AssignID: Boolean): Integer; overload;

  public
    procedure TryToConnect; overload;
    procedure TryToConnect(ServerAddress, ServerPort: string; DontRecoToBackup : boolean = false); overload;

    procedure AddMainLog(Text: WideString; Color: TColor); overload;
    procedure AmbiguousCommand(AmbiguousCommand : WideString; Text: WideString; Color: TColor; AmbiguousCommandID: Integer); overload;
    procedure AddTextToChatWindow(Chat: TMyTabSheet; Text: WideString; Color: TColor; DoNotHighLight : Boolean = false; DoNotFlash : Boolean = True); overload;
    procedure AddTextToChatWindow(Chat: TMyTabSheet; Text: WideString; Color: TColor; ChatTextPos: Integer; DoNotHighLight : Boolean = false; DoNotFlash : Boolean = True); overload;
  end;

  TConnectionState = (Disconnected, Connecting, Connected);

  PPingInfo = ^TPingInfo;
  TPingInfo =
  record
    TimeSent: Cardinal; // time when we sent this ping packet
    Key: Word; // unique ping packet ID (we use it to identify the packet so we don't mingle it with other ping packets if more were sent at the same time)
  end;
var
  Colors: TColors = (Normal:$00729EA6; Data: clGreen; Error:$003232C9; Info:$00FFC5A1; MinorInfo: $00D14D4D; ChanJoin: clGreen; ChanLeft: $00FFC5A1; MOTD: $0059597A; SayEx: $00855885; Topic: $0059597A; ClientAway: $00545454; MapModUnavailable: $00A8479F;BotText:$00808080; MyText: $00A2E0EB;AdminText: $00A9EBA2; OldMsgs: $00545454; BattleDetailsNonDefault: $00A8479F; BattleDetailsChanged: $00FFC5A1; ClientIngame: $00D14D4D; ReplayWinningTeam: 2900515; SkillLowUncertainty: $0000A000; SkillAvgUncertainty: $00729EA6; SkillHighUncertainty: $005C7478; SkillVeryHighUncertainty: $00384547);
  Debug:
  record
    Enabled: Boolean; // show some debugging information
    Log: Boolean; // save local tab's text to disk on program exit
    FilterPingPong: Boolean;
    IgnoreVersionIncompatibility: Boolean;
    LoginWithPasswordOnLan: Boolean;
    IgnoreRedirects: Boolean;
    Crashed: Boolean; // set to true if tasclient crashed during the previous run
  end;

  SCROLLING_NEWS_RSS_URL: string = 'http://springfiles.com/rss2.php?s=20';
  NEWS_URL:string = 'http://springrts.com/phpbb/search.php?search_id=active_topics';
  DISABLE_FADEIN: boolean = false;
  AUTOUPDATE_URL: string = 'http://springrts.com/dl/tasclient/TASClient_update_v5.txt';
  TASCLIENT_REGISTRY_KEY: string = 'Software\TASClient';
  CUSTOM_TASCLIENT_FILE:string = 'TASClient.ini';
  SCROLLING_NEWS_DIR:string = SCROLLING_NEWS_DIR_DEFAULT;
  WIDGETDB_MANAGER_URL: string = 'http://widgetdb.springrts.de/lua_manager.php';
  SPRINGDOWNLOADER_SERVICE_URL: string = 'http://zero-k.info/ContentService.asmx';
  RAPID_DOWNLOADER_URL: string = 'http://repos.springrts.com/repos.gz';
  RELAYHOST_MANAGER_NAME: string = 'RelayHostManagerList';

  MainForm: TMainForm;

  StartDebugLog: TFileStream;

  { this is a list of all clients on the server. We must maintain this list by reading ADDUSER and REMOVEUSER commands.
    All other clients lists (in channels, battles) contain objects linking to actual objects in this list. Never free
    any clients in any list except in this one, since freeing them in any other list will also free them in this list! }
  AllClients: TList;
  ClientsDataIni: TMemIniFile;

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
    Username: WideString; // my username
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
    CumulativeDataSentHistory: TIntegerList;
    CumulativeDataRecv: Int64; // number of bytes received since connection has been established. Note that this counter gets reset when you reconnect
    CurrentMsgID: Integer; // when sending commands to the server some are assigned an unique ID. This value represents last assigned ID. Currently we assign IDs consecutively (note that you may assign IDs any way you want, random, consecutive, or even not at all. IDs have only one function: to track server responses to commands sent by the client. See server's protocol description for more info)
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
  AutoJoinBattles: TList;
  ReplayList: TList;

  CurrentFilters : TPresetFilters;
  PresetList: TList;

  LockIncMsgProcessing : TCriticalSection;

  RefreshingBattleList:Boolean = false;

  FlagBitmaps: TList; // of TBitmap objects
  FlagBitmapsInitialized: Boolean = False;
  FlagBitmapsReverseTable: array[Ord('a')..Ord('z'), Ord('a')..Ord('z')] of Smallint;

  CommonFont: TFont; // common lobby font (used with chat windows, private chat, clients list, battle window, ...)
  BattleClientsListFont: TFont; // font used with VDTBattleClients list

  MuteListForms: TList; // list of all open MuteListForm-s. When form is created it will add itself to the list automatically, likewise will remove itself from the list when it gets destroyed
  ReceivingMuteListForChannel: string; // name of the channel for which we are currently receiving the mute list (we've extracted this info form MUTELISTBEGIN command)

  ReceivedAgreement: TWideStringList; // this is temporary string list to store received lines of an agreement sent by server.

  ProcessingRemoteCommand: Boolean = False; // tells us if we are processing remote command currently. This is important because sometimes Application.ProcessMessages can get called from within ProcessRemoteCommand method, which could led to next command being processed before current one is finished.

  // used with Socket:
  ReceiveBuffer: WideString; // this is temp buffer of what we receive from socket

  HostButtonMenuIndex : Integer;

  { we have to use messaging queue, since TWSocket doesn't seem to work correctly if certain methods are called
    from within its events (and especially if new messages arrive in meantime) }
  CommandQueue: array[0..QUEUE_LENGTH-1] of WideString;
  CommandQueueHead: Integer = 0;
  CommandQueueTail: Integer = 0;

  SpringSocketQueue: TFastQueue;

  SelectedBattle: TBattle;
  SelectedUserName: WideString;
  ContextMenuSelectedClient: TClient;

  LastBoundTo: integer;
  FindIPQueueList : TStringList;

  LastCursorPos : TPoint;

  displayingNotificationList: TList;

  displayedNewsList: TStringList;

  RunningUnderWine: Boolean = False; // set via -wine argument to the program
  RunningWithMainMenu: Boolean = False; // set via -menu argument to the program
  RunningWithMainMenuDev: Boolean = False; // set via -menudev argument to the program
  NO3D: Boolean = False; // set via -no3d argument to the program

  MyInternetIp: String;

  JoinAsSpectator : Boolean;

  // script var
  handlers: variant;

  autoUpdateDone: Boolean = False;

  autoCompleteString : String;

  mainLogBuffer : TWideStringList;
  mainLogBufferColor: TIntegerList;

  BattleSorting: integer;
  BattleSortingDirection: Boolean;

  SwitchToNewChatRoom : Boolean = false;
  NbAutoJoinChannels: integer = 0;

  MenuModName: string = '';

  IgnoreNextTASClientChanJoin: Boolean = false;
  IgnoreTASClientChanMsgs: Boolean = false;
  AutoJoinTASClient: Boolean = false; 

  function Dequeue: WideString; forward;
  function Enqueue(s: WideString): Integer; forward;
  function ClientSortCompare(Item1, Item2: Pointer): Integer;
  function BattleSortCompare(Item1, Item2: Pointer): Integer;
  procedure LoadTASClientIni(FileName: string);
  function GetDataSentSpeed: Extended;

implementation

uses BattleFormUnit, PreferencesFormUnit, Misc, WaitForAckUnit,
  InitWaitFormUnit, HelpUnit, DebugUnit, ReplaysUnit,
  HttpGetUnit, ShellAPI, RichEdit, NotificationsUnit,
  HostBattleFormUnit, AgreementUnit, PerformFormUnit, HighlightingUnit,
  IgnoreListUnit, MuteListFormUnit, MapListFormUnit, SplashScreenUnit,
  LoginProgressFormUnit, GpIFF, SearchFormUnit, ManageGroups, ColorPicker,
  AwayMessageFormUnit,JclStrings, SearchPlayerFormUnit, MenuFormUnit, Utility,
  PythonScriptDebugFormUnit,LobbyScriptUnit, SpringDownloaderFormUnit,
  LogonFormUnit, MapSelectionFormUnit, TipsFormUnit,
  ColorsPreferenceUnit, CustomizeGUIFormUnit, SetValuesFormUnit,
  TntWideStrings, SpringSettingsProfileFormUnit, gnugettext,
  AutoJoinFormUnit, AddBotUnit, Minimap3DPreviewUnit,
  MinimapZoomedFormUnit, DisableUnitsFormUnit, SetStringsUnit,
  ChannelsListFormUnit, Types, WidgetDBFormUnit, RapidDownloaderFormUnit;

{$R *.dfm}
{$B-}

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

function GetDataSentSpeed: Extended;
begin

end;

constructor TFastQueue.Create;
begin
  Self.Head := 0;
  Self.Tail := 0;
end;

function TFastQueue.Dequeue: String;
begin
  Result := Self.Data[Self.Head];
  Self.Head := (Self.Head + 1) mod QUEUE_LENGTH;
end;

function TFastQueue.Enqueue(s: String): Integer;
begin
  Result := Self.Tail;
  Self.Data[Self.Tail] := s;
  Self.Tail := (Self.Tail + 1) mod QUEUE_LENGTH;
end;

procedure TMainForm.mnuFAQClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(_('http://springrts.com/wiki/FAQs'));
end;

procedure TMainForm.mnuPlayingSpringClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(_('http://springrts.com/wiki/Using_Spring'));
end;

procedure TMainForm.mnuGlossaryClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(_('http://springrts.com/wiki/Glossary'));
end;

procedure TMainForm.mnuStrategyAndTacticsClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(_('http://springrts.com/wiki/Strategy_and_Tactics'));
end;

procedure TMainForm.OnSpringSocketMsg(var AMsg: TMessage); // responds to WM_SPRINGSOCKETMSG message
var
  msg: string;
  name : string;
  client: TClient;
  i: integer;
begin
  msg := SpringSocketQueue.Dequeue;
  if (Byte(msg[1]) = 13) and (Byte(msg[3]) = 254) then
  begin
    i := BattleState.IngameId.IndexOf(Byte(msg[2]));
    if i > -1 then
    begin
      BattleState.SpringChatMsgsBeingRelayed.Add('<'+BattleState.IngameName[i]+'> '+Copy(msg,4,Length(msg)-3));
      TryToSendCommand('SAYBATTLE',BattleState.SpringChatMsgsBeingRelayed[BattleState.SpringChatMsgsBeingRelayed.Count-1]);
    end;
    Exit;
  end;
  if Byte(msg[1]) = 10 then
  begin
    name := Copy(msg,3,Length(msg)-2);
    BattleState.IngameId.Add(Byte(msg[2]));
    BattleState.IngameName.Add(name);
  end;
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
    if PreferencesForm.SpTBXTabControl1.Items[i].Caption = _('Account') then
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
  TryToConnect;
end;

procedure TMainForm.OnCloseTabMessage(var Msg: TMessage); // responds to WM_CLOSETAB message
begin
  if Msg.WParam >= ChatTabs.Count then Exit; // should not happen
  TryToCloseTab(TMyTabSheet(ChatTabs[Msg.WParam]));
end;

procedure TMainForm.OnConnectMessage(var Msg: TMessage); // responds to WM_CONNECT message
begin
  if Status.ConnectionState = Disconnected then
    if Preferences.UseLogonForm then
    begin
      LogonForm.Show;
      LogonForm.btLoginClick(nil);
    end
    else
      ConnectButton.OnClick(nil);
end;

procedure TMainForm.OnAsyncPreferencesUpdate(var Msg: TMessage); // responds to WM_ASYNCPREFUPDATE message
var
  oldPref: PPreferences;
begin
  oldPref := PPreferences(Msg.WParam);
  PreferencesForm.asyncApplyPreferences(oldPref^);
  FreeMemory(oldPref);
end;

procedure TMainForm.OnForceReconnectMessage(var Msg: TMessage); // responds to WM_FORCERECONNECT message
begin
  if Status.ConnectionState <> Disconnected then
  begin
    TryToDisconnect;
  end;

  TryToConnect(Preferences.RedirectIP,Preferences.ServerPort);
end;

procedure TMainForm.ApplicationEvents1ShortCut(var Msg: TWMKey;
  var Handled: Boolean);
var
  s: string;
  i: integer;
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

  // Shift+Ctrl+F5 to reset the mainform and battle form pos and size
  if (Msg.CharCode = VK_F5) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    if MessageDlg(_('Do you really want to reset the main TASClient windows positions and sizes ?'),mtConfirmation,[mbYes,mbNo],0) = mrNo then Exit;
    MainForm.Show;
    MainForm.WindowState := wsNormal;
    MainForm.Left := 0;
    MainForm.Top := 0;
    MainForm.Width := 1000;
    MainForm.Height := 700;
    BattleForm.Show;
    BattleForm.WindowState := wsNormal;
    BattleForm.Left := 50;
    BattleForm.Top := 50;
    BattleForm.Width := 800;
    BattleForm.Height := 500;
    WidgetDBForm.Left := 100;
    WidgetDBForm.Top := 100;
    WidgetDBForm.Width := 835;
    WidgetDBForm.Height := 600;
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

  // Shift+Ctrl+F8 to show the CustomizeGUI form:
  if (Msg.CharCode = VK_F8) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    CustomizeGUIForm.Show;
    Exit;
  end;

  if ( (Msg.CharCode = 192) OR (Msg.CharCode = 222) ) and (GetKeyState(VK_MENU) < 0) then
  begin
    PythonScriptDebugForm.Visible := not PythonScriptDebugForm.Visible;
    Exit;
  end;

  if (Msg.CharCode = VK_F4) and (Minimap3DPreview <> nil) then
  begin
    Minimap3DPreview.SwitchMetalMap;
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
    if ((Screen.ActiveControl = FilterList) or (Screen.ActiveControl = ReplaysForm.FilterList)) and (TVirtualStringTree(Screen.ActiveControl).FocusedNode  <> nil) then
      TVirtualStringTree(Screen.ActiveControl).EditNode(TVirtualStringTree(Screen.ActiveControl).FocusedNode,3)
    else if MainForm.Active then
    begin
      BattleForm.Show;
      BattleForm.ChatActive := True;
    end
    else if BattleForm.Active then
      MainForm.Show;
    Exit;
  end;

  // Shift+Ctrl+H to switch to battle screen and open host battle dialog
  if (Msg.CharCode = Ord('H')) and (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    Handled := True;
    if Status.ConnectionState <> Connected then Exit;
    if not Status.LoggedIn then Exit;
    if BattleForm.IsBattleActive then Exit;

    Misc.ShowAndSetFocus(BattleForm.InputEdit,True);
    BattleForm.HostButton.OnClick(nil);
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
  if ((Msg.CharCode = VK_LEFT) and (GetKeyState(VK_LMENU) < 0)) or ((Msg.CharCode = VK_TAB) and (GetKeyState(VK_CONTROL) < 0) and (GetKeyState(VK_SHIFT) < 0)) then
  begin
    Handled := True;
    for i:=0 to ChatTabs.Count -1 do
      if ChatTabs[i] = lastActiveTab then
        break;
    if i = 0 then
      i := ChatTabs.Count-1
    else
      Dec(i);
    //ShowAndSetFocus(TWinControl(TMyTabSheet(ChatTabs[i]).FindComponent('InputEdit')));
    TMyTabSheet(ChatTabs[i]).OnActivate(nil);
    if TMyTabSheet(ChatTabs[i]).Parent is TTabSheet then
      TTabSheet(TMyTabSheet(ChatTabs[i]).Parent).PageControl.OnChange(TTabSheet(TMyTabSheet(ChatTabs[i]).Parent).PageControl);
    Exit;
  end;

  // Alt+Right to change channel tab
  if ((Msg.CharCode = VK_RIGHT) and (GetKeyState(VK_LMENU) < 0)) or ((Msg.CharCode = VK_TAB) and (GetKeyState(VK_CONTROL) < 0) and (GetKeyState(VK_SHIFT) >= 0)) then
  begin
    Handled := True;
    for i:=0 to ChatTabs.Count -1 do
      if ChatTabs[i] = lastActiveTab then
        break;
    if i = ChatTabs.Count-1 then
      i := 0
    else
      Inc(i);
    //ShowAndSetFocus(TWinControl(TMyTabSheet(ChatTabs[i]).FindComponent('InputEdit')));
    TMyTabSheet(ChatTabs[i]).OnActivate(nil);
    if TMyTabSheet(ChatTabs[i]).Parent is TTabSheet then
      TTabSheet(TMyTabSheet(ChatTabs[i]).Parent).PageControl.OnChange(TTabSheet(TMyTabSheet(ChatTabs[i]).Parent).PageControl);
    Exit;
  end;

  // TAB when input TEdit has focus:
  if (Msg.CharCode = 9) and (Screen.ActiveControl.ClassType = TTntMemo) and (Screen.ActiveControl.Name = 'InputEdit') then
  begin
    Handled := True;
    if not Preferences.AutoCompletionFromCurrentChannel or (MainForm.lastActiveTab.Caption = LOCAL_TAB) then
      TryToAutoCompleteWord(TTntMemo(Screen.ActiveControl), AllClients)
    else if Screen.ActiveForm.Name = 'BattleForm' then
      TryToAutoCompleteWord(TTntMemo(Screen.ActiveControl), BattleState.Battle.Clients)
    else if MainForm.lastActiveTab.Caption[1] = '#' then // a channel tab
      TryToAutoCompleteWord(TTntMemo(Screen.ActiveControl), MainForm.lastActiveTab.Clients)
    else // a private chat tab
      TryToAutoCompleteWord(TTntMemo(Screen.ActiveControl), MainForm.lastActiveTab.Clients);

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
  Country := LowerCase(Country);
  if not FlagBitmapsInitialized then raise Exception.CreateFmt('Erro: FlagBitmaps not initialized! Please report this error!', []);

  try
    index := FlagBitmapsReverseTable[Ord(Country[1]), Ord(Country[2])];
  except
    index := -1;
  end;
  if index = -1 then index := FlagBitmapsReverseTable[Ord('x'), Ord('x')];
  try
    Result := FlagBitmaps[index];
  except
    Result := FlagBitmaps[FlagBitmapsReverseTable[Ord('x'), Ord('x')]];
  end;
end;

procedure TMainForm.CloseAllLogs;
var
  i: Integer;
begin
  for i := 0 to MainForm.ChatTabs.Count - 1 do
    FreeAndNil(TMyTabSheet(MainForm.ChatTabs[i]).LogFile);
  // close battle log:
  FreeAndNil(BattleForm.LogFile);
end;

procedure TMainForm.OpenAllLogs;
var
  i: Integer;
  FileName: string;
  client: TClient;
  logName: string;
begin
  for i := 0 to MainForm.ChatTabs.Count - 1 do
    if TMyTabSheet(MainForm.ChatTabs[i]).LogFile = nil then
    begin
      client := GetClientById(TMyTabSheet(MainForm.ChatTabs[i]).PMId);
      if client = nil then
        logName := TMyTabSheet(MainForm.ChatTabs[i]).Caption
      else
        logName := Client.Name;
      FileName := ExtractFilePath(Application.ExeName) + LOG_FOLDER + '\' +  logName + '.log';
      try
        TMyTabSheet(MainForm.ChatTabs[i]).LogFile := OpenLog(FileName);
        TMyTabSheet(MainForm.ChatTabs[i]).LogFileName := FileName;
        if TMyTabSheet(MainForm.ChatTabs[i]).LogFile = nil then raise Exception.Create('');
      except
        AddMainLog(_('Error: unable to access file: ') + FileName, Colors.Error);
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
      AddMainLog(_('Error: unable to access file: ') + FileName, Colors.Error);
    end;
  end;

end;

function TMainForm.AreWeLoggedIn: Boolean;
begin
  Result := (Status.ConnectionState = Connected) and Status.LoggedIn;
end;

// returns False if battle with this ID already exists or some other error occured
function TMainForm.AddBattle(ID: Integer; BattleType: Integer; NATType: Integer; Founder: TClient; IP: string; Port: Integer; MaxPlayers: Integer; Password: Boolean; Rank: Byte; MapHash: Integer; MapName: string; Title: WideString; ModName: string; EngineName: string; EngineVersion: string): TBattle;
var
  Battle: TBattle;
  i:integer;
begin
  while RefreshingBattleList do;
  Result := nil;

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
  Founder.Battle := Battle;
  Battle.Visible :=  not EnableFilters.Checked or isBattleVisible(Battle,CurrentFilters);
  Battle.Node := nil;
  Battle.EngineName := EngineName;
  Battle.EngineVersion := EngineVersion;

  if Battle.BattleType = 0 then Battle.SpectatorCount := 0 else Battle.SpectatorCount := 1;

  Battles.Add(Battle);
  AutoJoinBattles.Add(Battle);

  with VDTBattles do
  begin
    if Battle.Visible then begin
      RootNodeCount := RootNodeCount + 1;
      Battle.Node := GetLast;
    end;
  end;


  Result := Battle;
end;

function TMainForm.RemoveBattle(ID: Integer): Boolean;
var
  i, j: Integer;
begin
  Result := False;

  j := GetBattleIndex(ID);

  if j = -1 then Exit;

  if TBattle(Battles[j]).Visible then
    VDTBattles.DeleteNode(TBattle(Battles[j]).Node, True);
  AutoJoinBattles.Delete(AutoJoinBattles.IndexOf(Battles[j]));
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
  AutoJoinBattles.Delete(AutoJoinBattles.IndexOf(Battles[Index]));
  Battles.Delete(Index);

  Result := True;
end;


procedure TMainForm.ClearAllClientsList;
var
  i: Integer;
begin
  // makes sure all battles are removed first : dirty should be moved somewhere else
  while Battles.Count > 0 do RemoveBattleByIndex(0); // remove all battles

  for i := 0 to AllClients.Count - 1 do
  begin
    TClient(AllClients[i]).Free;
  end;

  AllClients.Clear;
end;

procedure TMainForm.ClearClientsLists; // clears all clients list (in channels, private chats, battles, local tab, ...)
var
  i: Integer;
begin
  for i := 0 to MainForm.ChatTabs.Count - 1 do
    TMyTabSheet(MainForm.ChatTabs[i]).Clients.Clear;

  selectedBattlePlayers := nil;
  BattlePlayersListBox.Clear;
  BattlePlayersListBox.Invalidate;
  UpdateClientsListBox;

  // finally:
  ClearAllClientsList;
  UpdateClientsListBox;
end;

procedure TMainForm.AddClientToAllClientsList(Name: WideString; Status2: Integer; Country: string; CPU: Int64; id :integer);
var
  Client: TClient;
  i: integer;
  tmp: TClient;
begin
  Client := TClient.Create(Name, Status2, Country, IfThen(CPU>10000,0,Integer(CPU)),id);
  AllClients.Add(Client);

  // sort
  if not Status.ReceivingLoginInfo and Preferences.SortLocal then
  begin
    //SortClientsList(AllClients,Preferences.SortStyle);
    i := AllClients.Count-1;
    while i > 0 do
      if CompareClients(AllClients[i], AllClients[i-1], Preferences.SortStyle, Preferences.SortAsc) < 0 then
      begin
        // swap:
        tmp := AllClients[i];
        AllClients[i] := AllClients[i-1];
        AllClients[i-1] := tmp;
        Dec(i);
      end
      else Break;
  end;
end;

function TMainForm.RemoveClientFromAllClientsList(Name: WideString): Boolean;
var
  i,j: Integer;
begin
  Result := False;

  for i := 0 to AllClients.Count - 1 do
    if TClient(AllClients[i]).Name = Name then
    begin
      TClient(AllClients[i]).Free;
      AllClients.Delete(i);
      Result := True;
      Exit;
    end;
end;

function TMainForm.GetClient(Name: WideString): TClient;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to AllClients.Count - 1 do
  begin
    if TClient(AllClients[i]).DisplayName = Name then
      Result := TClient(AllClients[i]);
    if TClient(AllClients[i]).Name = Name then
    begin
      Result := TClient(AllClients[i]);
      Exit;
    end;
  end;
end;

function TMainForm.GetGroup(Name: string): TClientGroup;
var
  i: integer;
begin
  for i := 0 to ClientGroups.Count - 1 do
    if TClientGroup(ClientGroups[i]).Name = Name then
    begin
      Result := TClientGroup(ClientGroups[i]);
      Exit;
    end;

  Result := nil;
end;

function TMainForm.GetClientByIP(IP: string): TClient;
var
  i: Integer;
begin
  for i := 0 to AllClients.Count - 1 do
    if TClient(AllClients[i]).IP = IP then
    begin
      Result := TClient(AllClients[i]);
      Exit;
    end;

  Result := nil;
end;

function TMainForm.GetClientById(Id: integer): TClient;
var
  i: Integer;
begin
  for i := 0 to AllClients.Count - 1 do
    if TClient(AllClients[i]).Id = Id then
    begin
      Result := TClient(AllClients[i]);
      Exit;
    end;

  Result := nil;
end;

function TMainForm.GetClientIndexEx(Name: WideString; ClientList: TList): Integer;
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
  Result := nil;
  if Node = nil then Exit;
  for i := 0 to Battles.Count - 1 do
    if TBattle(Battles[i]).Node <> nil then
    if TBattle(Battles[i]).Node.Index = Node.index then
  begin
    Result := Battles[i];
    Exit;
  end;
end;

function TMainForm.GetFilterIndexFromNode(Node : PVirtualNode): integer;
var
  i: Integer;
  j: Integer;
begin
  j:=0;
  with CurrentFilters do
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

constructor TClient.Create(Name: WideString; Status: Integer; Country: string; CPU: Integer; id: integer);
var
  i,j: integer;
  latestName: WideString;
begin
  Self.Id := id;
  Self.Name := Name;
  Self.FDisplayName := GetDisplayName(id);
  Self.FIsRenamed := GetIsRenamed(id);
  latestName := GetLatestName(id);
  FNameHistory := GetNameHistory(id);
  if (latestName <> '') and (LowerCase(Name) <> LowerCase(latestName)) then
  begin
    if FNameHistory.IndexOf(latestName) = -1 then
    begin
      FNameHistory.Add(latestName);
      SetNameHistory(id,FNameHistory);
    end;
  end;
  i := FNameHistory.IndexOf(Name);
  if i > -1 then
  begin
    FNameHistory.Delete(i);
    SetNameHistory(id,FNameHistory);
  end;
  SetLatestName(id,Name);
  Self.Status := Status;
  Self.BattleStatus := 0;
  Self.InBattle := False;
  Self.Country := Country;
  Self.CPU := CPU;
  Self.IP := ''; // IP will get assigned by the CLIENTIPPORT command when needed
  Self.TeamColor := 0;
  Self.AutoKickMsgSent := 0;
  Self.AutoSpecMsgSent := 0;
  Self.Visible := True;
  Self.Group := nil;
  Self.Battle := nil;
  if not Preferences.ScriptsDisabled then
  begin
    Self.ScriptIcons := TIntegerList.Create;
    for i:=0 to lobbyScriptUnit.PlayerIconTypeNames.Count-1 do
      Self.ScriptIcons.Add(-1);
  end;
  if id >= 0 then
  begin
    for i:=0 to ClientGroups.Count-1 do
    begin
      j := TClientGroup(ClientGroups[i]).Clients.IndexOf(Name);
      if j > -1 then
      begin
        Self.Group := TClientGroup(ClientGroups[i]);
        TClientGroup(ClientGroups[i]).Clients.Delete(j);
        if TClientGroup(ClientGroups[i]).ClientsIds.IndexOf(id) = -1 then
          TClientGroup(ClientGroups[i]).ClientsIds.Add(id);
        break;
      end;
      j := TClientGroup(ClientGroups[i]).ClientsIds.IndexOf(id);
      if j > -1 then
      begin
        Self.Group := TClientGroup(ClientGroups[i]);
        break;
      end;
    end;
  end;
end;

destructor TClient.Destroy;
var
  j: integer;
begin
  // remove it from the HostBattleForm relay host manager it if needed
  j := HostBattleForm.relayHostManagerList.IndexOf(Self);
  if j > -1 then
  begin
    HostBattleForm.cmbRelayList.Items.Delete(j);
    HostBattleForm.relayHostManagerList.Delete(j);
  end;

  if (Self.Battle <> nil) then
  begin
    if Self.Battle.Clients.IndexOf(Self) > -1 then
      raise Exception.Create('Critical error: Trying to delete a TClient while it is still in a Battle.Clients')
    else
      raise Exception.Create('Trying to delete a TClient with non nil Battle');
  end;
  FNameHistory.Free;
  inherited;
end;

function TClient.GetChatTextColor: TColor;
var
  g : TClientGroup;
begin
  if Self.Name = MainUnit.Status.Username then
    Result := Colors.MyText
  else
  begin
    g := Self.GetGroup;
    if (g <> nil) and g.EnableChatColor then
      Result := g.ChatColor
    else if Self.GetAccess then
      Result := Colors.AdminText
    else
      Result := Colors.Normal;
  end;
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

function TClient.isComShareLeader: Boolean;
var
  i:integer;
begin
  Result := True;
  if Self.isComSharing and Self.InBattle then begin
    for i := 0 to BattleState.Battle.Clients.Count-1 do begin
      if (TClient(BattleState.Battle.Clients[i]).GetTeamNo = Self.GetTeamNo) and (TClient(BattleState.Battle.Clients[i]).Name <> Self.Name) and (TClient(BattleState.Battle.Clients[i]).GetMode <> 0) then begin
        if BattleState.Battle.Clients.IndexOf(Self) < i then
          Result := True
        else
          Result := False;
        Exit;
      end;
    end;
  end;
end;

function TClient.GetGroup: TClientGroup;
begin
  Result := Group;
end;

procedure TClient.SetGroup(g: TClientGroup);
begin
  Group := g;
end;

function TClient.GetBattleId: Integer;
var
  i,j:integer;
begin
  if Battle = nil then
    Result := -1
  else
    Result := Battle.ID;
end;

function TClient.GetCustomIconId(iconType: integer): integer;
begin
  Result := Self.ScriptIcons.Items[iconType];
end;
procedure TClient.SetCustomIconId(iconType: integer; id: integer);
begin
  Self.ScriptIcons.Items[iconType] := id;
end;
procedure TClient.AddNewCustomIcon;
begin
  Self.ScriptIcons.Add(-1);
end;

// Battle status:

function TClient.GetReadyStatus: Boolean;
begin
  Result := IntToBool((BattleStatus and $2) shr 1);
end;

function TClient.GetTeamNo: Integer;
begin
  if GetMode = 0 then
    Result := -1
  else
    Result := (BattleStatus and $3C) shr 2;
end;

function TClient.GetAllyNo: Integer;
begin
  if GetMode = 0 then
    Result := -1
  else
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
  BattleStatus := (BattleStatus and $FFFFFFC3) or ((Team and $F) shl 2);
end;

procedure TClient.SetAllyNo(Ally: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFC3F) or ((Ally and $F) shl 6);
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
var
  g: TClientGroup;
begin
  Result := (Status and $1C) shr 2;
  g := Self.GetGroup;
  if g <> nil then
    if g.ReplaceRank then
      Result := g.Rank;
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

procedure TClient.SetStatus(s: integer);
var
  i: integer;
begin
  FStatus := s;

  // re-sort all clients lists:
  if not MainUnit.Status.ReceivingLoginInfo then
    if Preferences.SortStyle = 2 then
    begin
      for i := 1 {start from 1 to skip LOCAL_TAB} to MainForm.ChatTabs.Count-1 do
        MainForm.SortClientInList(Self,TMyTabSheet(MainForm.ChatTabs[i]).Clients, Preferences.SortStyle, Preferences.SortAsc);
      if (Battle <> nil) and (Battle = MainForm.selectedBattlePlayers) then
        MainForm.SortClientInList(Self,Battle.SortedClients, Preferences.SortStyle, Preferences.SortAsc);
      if Preferences.SortLocal then
        MainForm.SortClientInList(Self,AllClients, Preferences.SortStyle, Preferences.SortAsc);
    end;
end;

procedure TClient.SetInBattle(b: Boolean);
var
  i: integer;
begin
  FInBattle := b;

  // re-sort all clients lists:
  if not MainUnit.Status.ReceivingLoginInfo then
    if Preferences.SortStyle = 2 then
    begin
      for i := 1 {start from 1 to skip LOCAL_TAB} to MainForm.ChatTabs.Count-1 do
        MainForm.SortClientInList(Self,TMyTabSheet(MainForm.ChatTabs[i]).Clients, Preferences.SortStyle, Preferences.SortAsc);
      if (Battle <> nil) and (Battle = MainForm.selectedBattlePlayers) then
        MainForm.SortClientInList(Self,Battle.SortedClients, Preferences.SortStyle, Preferences.SortAsc);
      if Preferences.SortLocal then
        MainForm.SortClientInList(Self,AllClients, Preferences.SortStyle, Preferences.SortAsc);
    end;
end;

procedure TClient.SetBattleStatus(bs: integer);
var
  i: integer;
begin
  FBattleStatus := bs;
end;

function TClient.IGetDisplayName: WideString;
begin
  if FIsRenamed then
    Result := FDisplayName
  else
    Result := Name;
end;

procedure TClient.ISetDisplayName(displayName: WideString);
begin
  if displayName = '' then
  begin
    FIsRenamed := False;
    TClient.SetIsRenamed(Id,False);
    Exit;
  end;
  FIsRenamed := True;
  FDisplayName := displayName;
  TClient.SetDisplayName(Id,displayName);
  TClient.SetIsRenamed(Id,True);
end;

procedure TClient.ISetIsIgnored(ignored: Boolean);
begin
  FIgnored := ignored;
  TClient.SetIsIgnored(Id,ignored);
end;

{ TBot }

procedure TBot.Assign(Bot: TBot);
begin
  Self.Name := Bot.Name;
  Self.OwnerName := Bot.OwnerName;
  Self.AIShortName := Bot.AIShortName;
  Self.BattleStatus := Bot.BattleStatus;
  Self.TeamColor := Bot.TeamColor;
end;

constructor TBot.Create(Name: string; OwnerName: string; AIShortName: string);
begin
  Self.Name := Name;
  Self.OwnerName := OwnerName;
  Self.AIShortName := AIShortName;
  Self.BattleStatus := 0;
  Self.TeamColor := 0;
  OptionsList := TList.Create;
  if OwnerName = Status.Me.Name then
  begin
    Utility.LoadLuaOptions(OptionsList,Utility.LoadSkirmishAI(AIShortName),'GAME/AI'+IntToStr(BattleState.Battle.Bots.Count)+'/OPTIONS/',False);
    Application.CreateForm(TBotOptionsForm, OptionsForm);
    Utility.DisplayLuaOptions(OptionsList,OptionsForm.AIOptionsScrollBox);
    OptionsForm.Caption := OptionsForm.Caption + ' - ' + Name;
    OptionsForm.SpTBXTitleBar1.Caption := OptionsForm.Caption;
    OptionsForm.BotSideButton.Images := Utility.SideImageList;
    OptionsForm.BotSideButton.ImageIndex := 0;
    OptionsForm.Bot := Self;
  end;
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
  BattleStatus := (BattleStatus and $FFFFFFC3) or ((Team and $F) shl 2);
  if OptionsForm = nil then Exit;
  OptionsForm.BotTeamButton.SpinOptions.ValueAsInteger := Team+1;
end;

procedure TBot.SetAllyNo(Ally: Integer);
begin
  BattleStatus := (BattleStatus and $FFFFFC3F) or ((Ally and $F) shl 6);
  if OptionsForm = nil then Exit;
  OptionsForm.BotAllyButton.SpinOptions.ValueAsInteger := Ally+1;
end;

procedure TBot.SetHandicap(Handicap: Integer);
begin
  BattleStatus := (BattleStatus and $FFFC07FF) or (Handicap shl 11);
end;

procedure TBot.SetSide(Side: Integer);
begin
  BattleStatus := (BattleStatus and $F0FFFFFF) or (Side shl 24);
  if OptionsForm = nil then Exit;
  OptionsForm.BotSideButton.ImageIndex := Side;
  OptionsForm.BotSideButton.Caption := Utility.SideList[Side];
end;

procedure TBot.SetBattleStatus(bs: integer);
begin
  BattleStatus := bs;
  if OptionsForm = nil then Exit;
  OptionsForm.BotSideButton.ImageIndex := GetSide;
  OptionsForm.BotSideButton.Caption := Utility.SideList[GetSide];
  OptionsForm.BotAllyButton.SpinOptions.ValueAsInteger := GetAllyNo+1;
  OptionsForm.BotTeamButton.SpinOptions.ValueAsInteger := GetTeamNo+1;
end;

procedure TBot.SetTeamColor(c: integer);
begin
  TeamColor := c;
  if OptionsForm = nil then Exit;
  MainForm.UpdateColorImageList;
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
  SortedClients := TList.Create;
  Bots := TList.Create;
  CurrentHighLightGroup := nil;
  ForcedHidden := False;
  StartTimeUknown := True;
  StartTime := Now;
end;

destructor TBattle.Destroy;
var
  i: Integer;
begin
  for i := 0 to Clients.Count-1 do
    TClient(Clients[i]).Battle := nil;
  Clients.Free;
  for i := 0 to Bots.Count-1 do
    TBot(Bots[i]).Free;
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
  end;
  {else if BattleType = 1 then
  begin
    for i := 0 to Clients.Count-1 do if not TClient(Clients[i]).GetReadyStatus then Exit;
  end;}

  Result := True;
end;

// returns false if two or more bots share the same team number
function TBattle.AreAllBotsSet: Boolean;
var
  i: Integer;
  TeamNo: array[0..15] of Boolean;
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
  for i := 0 to Clients.Count-1 do
    if (TClient(Clients[i]).GetSync <> 1) and (TClient(Clients[i]).GetMode = 1) then
      Exit;
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
    Result := (Clients.Count > 0) and (TClient(Clients[0]).GetInGameStatus);
end;

function TBattle.GetState: Integer; // use it to get index of image from BattleStatusImageList
begin
  Result := 0;
  if TClient(Clients[0]).GetInGameStatus then Inc(Result,2)
  else if IsBattleFull then Inc(Result);
  if Password then Inc(Result, 3);
  if BattleType = 1 then Inc(Result, 6);
end;

function TBattle.ClientsToString(separator: string=', ';displayName: boolean=True): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Clients.Count-1 do
    Result := Result + TClient(Clients[i]).DisplayName + separator;
  if Length(Result) > 0 then Delete(Result, Length(Result)-1, Length(separator));
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
  Result := MainForm.VDTBattles.Color;
  if CurrentHighLightGroup <>  nil then
    try
      Result := CurrentHighLightGroup.Color;
    except
    end;
end;

function TBattle.GetAvgRank: double;
var
  i:integer;
begin
  Result := 0;
  if Clients.Count = 0 then Exit;
  for i:=0 to Clients.Count-1 do
    Result := Result + TClient(Clients[i]).GetRank;
  Result := Result / Clients.Count;
end;

procedure TBattle.NextHighlight;
var
  GroupList: TList;
  i,j: integer;
  found: boolean;
  ptrInt: ^integer;
  cg: TClientGroup;
begin
  // we find the battle client group list
  GroupList := TList.Create;
  for i:=0 to Clients.Count-1 do
  begin
    cg := TClient(Clients[i]).GetGroup;
    if cg <> nil then
      if cg.HighlightBattles then
        if GroupList.IndexOf(cg) = -1 then
          GroupList.Add(cg);
  end;

  // we change the highligh group index to the next one or none if there is no group
  if GroupList.Count = 0 then
    CurrentHighLightGroup := nil
  else
  begin
    j := 0;
    for i:=0 to GroupList.Count-1 do
      if GroupList[i] = CurrentHighLightGroup then
      begin
        j:=i;
        break;
      end;
    if j=GroupList.Count-1 then
      CurrentHighLightGroup := GroupList[0]
    else
      CurrentHighLightGroup := GroupList[j+1];
  end;

  GroupList.Free;
end;

{ TScript }

constructor TScript.Create(Script: string);
begin
  inherited;
end;

constructor TScript.Create(s: TTDFParser);
begin
  inherited;
end;

constructor TTDFParser.Create(s: TTDFParser);
begin
  inherited Create;
  FScript := s.FScript;
  FUpperCaseScript := s.FUpperCaseScript;
  CompleteKeyList := TStringList.Create;
  CompleteKeyList.Assign(s.CompleteKeyList);
  CompleteOriginalKeyList := TStringList.Create;
  CompleteOriginalKeyList.Assign(s.CompleteOriginalKeyList);
  KeyValueList := TStringList.Create;
  KeyValueList.Assign(s.KeyValueList);
  self.Corrupted := s.Corrupted;
end;

constructor TTDFParser.Create(Script: string);
begin
  inherited Create;
  FScript := Script;
  FUpperCaseScript := UpperCase(Script);
  CompleteKeyList := TStringList.Create;
  CompleteOriginalKeyList := TStringList.Create;
  KeyValueList := TStringList.Create;
  self.Corrupted := false;
  try
    self.ParseScript;
  except
    self.Corrupted := True;
  end;
end;

destructor TScript.Destroy;
begin
  inherited;
end;

destructor TTDFParser.Destroy;
begin
  CompleteKeyList.Free;
  CompleteOriginalKeyList.Free;
  KeyValueList.Free;
  inherited Destroy;
end;

procedure TTDFParser.SetScript(Script: string);
begin
  FScript := Script;
  FUpperCaseScript := UpperCase(Script);
  CompleteKeyList.Clear;
  CompleteOriginalKeyList.Clear;
  KeyValueList.Clear;
  self.ParseScript;
end;

function TScript.ReadMapName: string;
begin
  Result := ReadKeyValue('GAME/MAPNAME');
  if Result = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadMaphash: string;
begin
  Result := ReadKeyValue('GAME/MAPHASH');
  if Result = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadModName: string;
begin
  Result := ReadKeyValue('GAME/GAMETYPE');
  if Result = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadStartMetal: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/STARTMETAL');
  if tmp = '' then
    tmp := ReadKeyValue('GAME/MODOPTIONS/STARTMETAL');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadStartEnergy: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/STARTENERGY');
  if tmp = '' then
    tmp := ReadKeyValue('GAME/MODOPTIONS/STARTENERGY');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadMaxUnits: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/MAXUNITS');
  if tmp = '' then
    tmp := ReadKeyValue('GAME/MODOPTIONS/MAXUNITS');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
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
    raise Exception.Create(_('Corrupted script file!'));
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
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
    raise Exception.Create(_('Corrupted script file!'));
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadGameMode2: Integer;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/MODOPTIONS/GAMEMODE');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
  try
    Result := StrToInt(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadLimitDGun: Boolean;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/LIMITDGUN');
  if tmp = '' then
    tmp := ReadKeyValue('GAME/MODOPTIONS/LIMITDGUN');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
  try
    Result := StrToBool(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadDiminishingMMs: Boolean;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/DIMINISHINGMMS');
  if tmp = '' then
    tmp := ReadKeyValue('GAME/MODOPTIONS/DIMINISHINGMMS');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
  try
    Result := StrToBool(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
  end;
end;

function TScript.ReadGhostedBuildings: Boolean;
var
  tmp: String;
begin
  tmp := ReadKeyValue('GAME/GHOSTEDBUILDINGS');
  if tmp = '' then
    tmp := ReadKeyValue('GAME/MODOPTIONS/GHOSTEDBUILDINGS');
  if tmp = '' then
  begin
    self.Corrupted := true;
    raise Exception.Create(_('Corrupt script file!'));
  end;
  try
    Result := StrToBool(tmp);
  except
    self.Corrupted := true;
    raise Exception.Create(_('Corrupted script file!'));
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
begin
  AddOrChangeKeyValue('GAME/HOSTIP',NewIP);
end;

procedure TScript.ChangeHostPort(NewPort: string);
begin
  AddOrChangeKeyValue('GAME/HOSTPORT',NewPort);
end;

procedure TScript.ChangeMyPlayerNum(NewNum: Integer);
var
  i: Integer;
begin
  i := CompleteKeyList.IndexOf(LowerCase('GAME/MYPLAYERNUM'));
  if i = -1 then raise Exception.Create(_('Corrupted script file!'));
  KeyValueList[i] := IntToStr(NewNum);
end;

procedure TScript.ChangeNumPlayers(NewNum: Integer);
var
  i: Integer;
begin
  i := CompleteKeyList.IndexOf(LowerCase('GAME/NUMPLAYERS'));
  if i = -1 then raise Exception.Create(_('Corrupted script file!'));
  KeyValueList[i] := IntToStr(NewNum);
end;

procedure TTDFParser.AddOrChangeKeyValue(completeKey: String; value: String);
var
  i: Integer;
begin
  i := CompleteKeyList.IndexOf(LowerCase(completeKey));
  if i > -1 then
    KeyValueList[i] := value
  else
  begin
    CompleteKeyList.Add(LowerCase(completeKey));
    CompleteOriginalKeyList.Add(completeKey);
    KeyValueList.Add(value);
  end;
end;

function TTDFParser.keyExists(completeKey: string): boolean;
begin
  Result := CompleteKeyList.IndexOf(LowerCase(completeKey)) > -1;
end;


procedure TTDFParser.RemoveKey(completeKey: String);
var
  i: Integer;
  subKeys: TStrings;
begin
  i := CompleteKeyList.IndexOf(LowerCase(completeKey));
  if i>-1 then
  begin
    CompleteKeyList.Delete(i);
    CompleteOriginalKeyList.Delete(i);
    KeyValueList.Delete(i);
  end
  else
  begin
    subKeys := GetSubKeys(completeKey);
    for i:=0 to subKeys.Count-1 do
      RemoveKey(completeKey + '/' + subKeys[i]);
    subKeys.Free;
  end;
end;

procedure TScript.TryToRemoveUDPSourcePort;
begin
  RemoveKey('GAME/SOURCEPORT');
end;

function TTDFParser.isCorrupted: boolean;
begin
  Result := self.Corrupted;
end;

procedure TTDFParser.ParseScript;
var
  currentCompleteKey: TStrings;
  lineScript: TStrings;
  trimedLine: String;
  i: integer;
  key: string;
  value: string;
  RegExpr: TRegExpr;
begin
  currentCompleteKey := TStringList.Create;
  lineScript := TStringList.Create;
  RegExpr := TRegExpr.Create;
  RegExpr.Expression := '/\*.*\*/';  // to remove the '/* comments */'
  Misc.ParseDelimited(lineScript, RegExpr.Replace(FScript,''),EOL,#$A);
  for i:=0 to lineScript.Count-1 do
  begin
    trimedLine := Trim(lineScript[i]);
    if (trimedLine <> '') and (LeftStr(trimedLine,2) <> '//') then
    begin
      if LeftStr(trimedLine,1) = '[' then // [KEY]
      begin
        key := MidStr(trimedLine,2,Pos(']',trimedLine)-2);
        currentCompleteKey.Add(key);
      end
      else if LeftStr(trimedLine,1) = '}' then
      begin
        if currentCompleteKey.Count = 0 then
          raise Exception.Create(_('Corrupted script on line ')+IntToStr(i));
        currentCompleteKey.Delete(currentCompleteKey.Count-1);
      end
      else if (Length(trimedLine) > 4) and (currentCompleteKey.Count>0) then // key=value
      begin
        key := MidStr(trimedLine,1,Pos('=',trimedLine)-1);
        value := MidStr(trimedLine,Pos('=',trimedLine)+1,Pos(';',trimedLine)-Pos('=',trimedLine)-1);
        CompleteKeyList.Add(LowerCase(Misc.JoinStringList(currentCompleteKey,'/')+'/'+key));
        CompleteOriginalKeyList.Add(Misc.JoinStringList(currentCompleteKey,'/')+'/'+key);
        KeyValueList.Add(value);
      end;
    end;
  end;
  currentCompleteKey.Free;
  lineScript.Free;
end;

function TTDFParser.GetSubKeys(completeKey: string):TStrings;
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
      sl2 := ParseString(CompleteOriginalKeyList[i],'/');
      if Result.IndexOf(sl2[sl1.Count])=-1 then
          Result.Add(sl2[sl1.Count]);
      sl2.Free;
    end;
  sl1.Free;
end;

function TTDFParser.GetBruteScript:String;// DEBUG METHOD
var
  i: integer;
begin
  // DEBUG METHOD
  for i:=0 to CompleteKeyList.Count-1 do
    Result := Result + CompleteKeyList[i]+'='+KeyValueList[i]+EOL;
end;

function TTDFParser.GetScript:String;
var
  ScriptLines: TStrings;
  writtenKeys: TStrings;
begin
  ScriptLines := TStringList.Create;
  writtenKeys := TStringList.Create;
  WriteScriptKeys(ScriptLines,'',writtenKeys,False);
  Result := Misc.JoinStringList(ScriptLines,EOL)+EOL;
  ScriptLines.Free;
  writtenKeys.Free;
end;

procedure TTDFParser.WriteScriptKeys(f: TStrings; completeKey: String;writtenKeys: TStrings; headWrite: Boolean);
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

function TTDFParser.ReadKeyValue(completeKey: string):String;
var
  i: integer;
begin
  Result := '';
  i := CompleteKeyList.IndexOf(LowerCase(completeKey));
  if i >-1 then
    Result := KeyValueList[i];
end;

{ TMyTabSheet }

constructor TMyTabSheet.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner,Dummy);
  Clients := TList.Create;
  History := TWideStringList.Create;
  HistoryIndex := -1;
  AutoScroll := True;
  LogFile := nil;
  Self.OnActivate := MyTabSheetOnActivate;
  Self.OnClose := MyTabSheetOnClose;
  Self.PMId := -1;
  ClientListBoxPosition := 0;
end;

procedure TMyTabSheet.MyTabSheetOnActivate(Sender:TObject);
begin
  MainForm.lastActiveTab.ClientListBoxPosition := MainForm.ClientsListBox.TopIndex;
  MainForm.lastActiveTab := Self;
  BattleForm.ChatActive := False;
  MainForm.UpdateClientsListBox;
  MainForm.ClientsListBox.TopIndex := Min(ClientListBoxPosition,MainForm.ClientsListBox.Count-1);
  try
    ShowAndSetFocus(TWinControl(Self.FindComponent('InputEdit')));
  except
  end;
end;


procedure TMyTabSheet.MyTabSheetOnClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.TryToCloseTab(Self);
end;

destructor TMyTabSheet.Destroy;
var
  i:integer;
begin
  Clients.Free;
  History.Free;
  LogFile.Free;
  for i:=0 to MainForm.ChatTabs.Count-1 do
    if MainForm.ChatTabs[i] = Self then
    begin
      MainForm.ChatTabs.Delete(i);
      break;
    end;
  inherited Destroy;
end;

procedure TMyTabSheet.ScrollRichEditToBottom;
var
  r: TExRichEdit;
begin
  r := TExRichEdit(Self.FindComponent('RichEdit'));
  r.ScrollToBottom;
end;

{ TMainForm }

procedure TMainForm.ChangeActivePageAndUpdate(PageControl: TPageControl; PageIndex: Integer); // never change ActivePageIndex manually, since it doesn't trigger OnChange event!
begin
  PageControl.ActivePageIndex := PageIndex;
  PageControl.OnChange(PageControl);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i,j: Integer;
  s: string;
begin
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing translations variables ...');

  TP_GlobalIgnoreClassProperty(TAction,'Category');
  TP_GlobalIgnoreClassProperty(TControl,'HelpKeyword');
  TP_GlobalIgnoreClassProperty(TNotebook,'Pages');
  TP_GlobalIgnoreClass (TWebBrowser);
  TP_GlobalIgnoreClass (TWebBrowserWrapper);
  TP_GlobalIgnoreClass (TExRichEdit);
  TP_GlobalIgnoreClass (TRichEdit);
  TP_GlobalIgnoreClass (THttpCli);

  TP_GlobalIgnoreClassProperty(TFont,'Name');
  
  TP_Ignore (self,'.Caption');
  TP_Ignore (self,'MainTitleBar.Caption');
  //TP_Ignore (self,'SortLabel');
  if Preferences.LanguageCode <> '' then
    UseLanguage(Preferences.LanguageCode);

  TranslateComponent(self);

  Application.HintPause := 100;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing variables ...');

  DoubleClickLabel.Left := BattleListLabel.Left + BattleListLabel.Canvas.TextWidth(BattleListLabel.Caption) + 6;
  Left := 10;
  Top := 10;

  ChatTabs := TList.Create;

  BattleState.BanList := TIntegerList.Create;
  autoCompletionHint := THintWindow.Create(MainForm);
  MainLogCS := TCriticalSection.Create;
  BattleState.IngameId := TIntegerList.Create;
  BattleState.IngameName := TStringList.Create;
  BattleState.SpringChatMsgsBeingRelayed := TWideStringList.Create;

  SinglePlayerButton.Enabled := not RunningUnderWine;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Deleting TASClient.old ...');

  try
    if FileExists(Application.ExeName + '.old') then
    begin
      DeleteFile(Application.ExeName + '.old');
      DelTree(ExtractFilePath(Application.ExeName)+'TASClientUpdateTemp\');
    end;
  except
    // nothing
  end;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing variables ...');

  Randomize;
  Application.UpdateFormatSettings := False; // so that DecimalSeparator doesn't get changed by WM_WININICHANGE message. See http://coding.derkeiler.com/Archive/Delphi/borland.public.delphi.language.objectpascal/2003-11/0223.html
  DecimalSeparator := '.';
  MainForm.Caption := PROGRAM_VERSION;
  MainTitleBar.Caption := PROGRAM_VERSION;
  Application.Title := 'TASClient';
  Application.HintHidePause := 10000;
  Application.ShowHint := True;
  LockIncMsgProcessing := TCriticalSection.Create;

  SpringSocketQueue := TFastQueue.Create;

  Debug.FilterPingPong := False;

  CommonFont := TFont.Create;
  CommonFont.Name := 'Fixedsys';
  CommonFont.Charset := DEFAULT_CHARSET;

  BattleClientsListFont := TFont.Create;
  BattleClientsListFont.Name := 'Arial';
  BattleClientsListFont.Style := [fsBold];
  BattleClientsListFont.Charset := DEFAULT_CHARSET;

  ClientsListBox.DoubleBuffered := True;
  BattlePlayersListBox.DoubleBuffered := True;

  FixFormSizeConstraints(MainForm);

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Launching keepalive thread ...');

  TKeepAliveThread.Create(False);

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing unitsync.dll ...');

  SplashScreenForm.UpdateText(_('initializing unitsync.dll ...'));
  if not Utility.InitLib then
  begin
    MessageDlg(_('Error initializing unitsync.dll!'), mtError, [mbOK], 0);
    Application.Terminate;
  end;

  SplashScreenForm.UpdateText(_('initializing TASClient ...'));

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing variables ...');

  AllClients := TList.Create;

  ClientGroups := TList.Create;

  Status.ConnectionState := Disconnected;
  Status.Registering := False;
  Status.CumulativeDataSentHistory := TIntegerList.Create;
  tmrCumulativeDataSentHistory.Enabled := True;

  mainLogBuffer := TWideStringList.Create;
  mainLogBufferColor := TIntegerList.Create;
  Battles := TList.Create;
  AutoJoinBattles := TList.Create;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading clients data ...');

  if not FileExists(CLIENTS_DATA_FILE) then // old files import
  begin
    ClientsDataIni := TMemIniFile.Create(ExtractFilePath(Application.ExeName) + CLIENTS_DATA_FILE);
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading ignore list ...');
    IgnoreListForm.LoadIgnoreListFromFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\ignorelist.dat');

    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading renames ...');
    LoadRenames;
  end
  else
    ClientsDataIni := TMemIniFile.Create(ExtractFilePath(Application.ExeName) + CLIENTS_DATA_FILE);


  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading docking settings ...');

  DockHandler.TabType := ttText;
  DockHandler.OnRefresh := OnDockHandlerRefresh;
  MainPCH := TPageControlHost.Create(Panel1);
  MainPCH.ManualDock(MainDockPanel);
  MainPCH.Visible := True;

  PlayerListPanel.ManualDock(MainPCH.PageControl);
  PlayerListPanel.ManualDock(MainDockPanel,nil,alRight);
  DockHandler.RegisterSpecialDockClient(PlayerListPanel);
  BattlesPanel.ManualDock(MainPCH.PageControl);
  BattlesPanel.ManualDock(MainDockPanel,nil,alBottom);
  DockHandler.RegisterSpecialDockClient(BattlesPanel);

  MainPCH.Destroy;
  MainPCH := TPageControlHost.Create(MainDockPanel);
  MainPCH.Align := alNone;
  MainPCH.ManualDock(MainDockPanel,nil,alClient);
  MainPCH.Visible := True;
  MainPCH.Name := 'MainPCH';
  ChatTabs.Add(AddTabWindow(LOCAL_TAB, False));

  PlayerListPanel.ManualDock(MainDockPanel,nil,alRight);
  BattlesPanel.ManualDock(MainDockPanel,nil,alBottom);

  lastActiveTab := ChatTabs[ChatTabs.Count-1];

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading mod list ...');

  Utility.ReloadModList;

  {*if ModList.Count = 0 then
  begin
    KeepAliveTimer.Enabled := False;
    MessageDlg('No mods found! Terminating program ...', mtError, [mbOK], 0);
    Application.Terminate;
  end; *}

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing variables ...');

  ReceiveBuffer := '';

  Status.AwayTime := GetTickCount;
  Status.AmIInGame := False;

  Status.MyCPU := Misc.GetCPUSpeed;
  Status.CurrentMsgID := 0;

  MyInternetIp := '';

  ReplayList := TList.Create;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing flag bitmaps ...');

  InitializeFlagBitmaps;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing variables ...');

  ReceivedAgreement := TWideStringList.Create;

  Pings := TList.Create;

  MuteListForms := TList.Create;

  FindIPQueueList := TStringList.Create;

  SpringDownloaderFormUnit.DownloadList := TStringList.Create;
  SpringDownloaderFormUnit.ClosedDownloadFormList := TList.Create;

  // we have to set the splash screen title bar back to what it was before (since we changed it in OnFormCreate event):
  SplashScreenForm.UpdateText(_('creating forms ...')); // main form will change the update text, that is why we change it back again

  // finally move to post-initialization (will happen once all other forms have been created too):
  PostMessage(Handle, WM_AFTERCREATE, 0, 0);
end;

procedure TMainForm.WMAfterCreate(var AMsg: TMessage); // responds to WM_AFTERCREATE message. We will do some post-initialization here
var
  i,j : Integer;
  mask: Word;
begin
  if not ProgramInitialized then
  begin
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Apply translation control transformations ...');

    // do the main initialization
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading preferences ...');
    Preferences := DEFAULT_PREFERENCES;
    ProgramInitialized := True;
    PreferencesForm.ReadPreferencesFromRegistry;
    if CommandLineServer <> '' then
    begin
      Preferences.ServerIP := CommandLineServer;
      Preferences.ServerPort := CommandLinePort;
    end;
    PreferencesForm.UpdatePreferencesFrom(Preferences);
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading notifications ...');
    NotificationsForm.LoadNotificationListFromFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\notify.dat');
    NotificationsForm.UpdateNotificationList;
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading perform list ...');
    PerformForm.LoadCommandListFromFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\perform.dat');
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading highlights ...');
    HighlightingForm.LoadHighlightsFromFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\highlights.dat');

    // we must apply themetype and theme now and not before, since some forms
    // or controls may yet not have been created earlier:
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Applying theme ...');

    PreferencesForm.ApplyCurrentThemeType;

    ColorsPreference.ApplyFont;

    if not Preferences.DisableNews then
    begin
      if MainUnit.Debug.Enabled then
        Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating scrolling news control ...');

      // make the scrolling news browser
      ScrollingNewsBrowser := TWebBrowserWrapper.Create(ScrollingNewsPanel);
      TWinControl(ScrollingNewsBrowser).Parent := ScrollingNewsPanel;
      ScrollingNewsBrowser.ShowScrollBars := False;
      ScrollingNewsBrowser.Show3DBorder := False;
      ScrollingNewsBrowser.UseCustomCtxMenu := True;
      ScrollingNewsBrowser.AllowTextSelection := False;
      ScrollingNewsBrowser.Align := alClient;
      ScrollingNewsBrowser.Silent := True;
      ScrollingNewsBrowser.OnBeforeNavigate2 := OnNewsBrowserBeforeNavigate2;
      ScrollingNewsBrowser.Cursor := crHandPoint;
    end;

    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading filters and presets ...');
    initFiltersPresets;

    // make the news browser
    if Preferences.DisableNews or RunningWithMainMenu then
    begin
      NewsMainPanel.Visible := False;
      ScrollingNewsTimer.Enabled := False;
    end
    else
    begin
      if MainUnit.Debug.Enabled then
        Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating news control ...');

      NewsBrowser := TWebBrowserWrapper.Create(NewsPanel);
      TWinControl(NewsBrowser).Parent := NewsPanel;
      NewsBrowser.Show3DBorder := False;
      NewsBrowser.Align := alClient;
      NewsBrowser.Visible := True;
      NewsBrowser.Silent := True;
      NewsBrowser.OnDocumentComplete := OnNewsBrowserDocumentComplete;
      NewsBrowser.OnBeforeNavigate2 := OnNewsBrowserBeforeNavigate2;
      NewsBrowser.OnNewWindow2 := NewsBrowserNewWindow2;

      // display and expand the news
      ScrollingNewsPanel.Align := alClient;
      Panel1.Visible := False;
      NewsMainPanel.Align := alClient;
      ScrollingNewsPanel.Visible := False;
      NewsPanel.Align := alClient;
      NewsPanel.Visible := True;
      ExpandNewsButton.ImageIndex := 0;
      MainForm.WindowState := wsMinimized;
      MainForm.Visible := True;
      
      //ScrollingNewsTimerTimer(nil);
      TScrollingNewsRefreshThread.Create(False,600000);

      if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Displaying news page ...');
      try
        NewsBrowser.Navigate(NEWS_URL);
      except
      end;
      MainForm.Visible := False;
      MainForm.WindowState := wsNormal;
    end;

    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading groups ...');
    LoadGroups;
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading away messages ...');
    LoadAwayMessages;
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading autojoin settings ...');
    AutoJoinForm.LoadAutoJoinPreset(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\current.ini');

    initLobbyScript;

    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading user docking layout ...');
    DockHandler.LoadDesktop(TASCLIENT_REGISTRY_KEY+'\Layout',PreferencesForm.LayoutDefault.Text);

    MainForm.MainPCH.PageControl.Style := TTabStyle(Preferences.TabStyle);

    TMyTabSheet(ChatTabs[0]).ScrollRichEditToBottom;

    // populate ColorImageList:
    UpdateColorImageList;

    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Checking dirs ...');

    // set focus to TEdit control (we need to do this only once for 1 page only, and TEdit control will always receive focus with any new page):
//*****    (PageControl1.ActivePage.Controls[0] as TEdit).SetFocus;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + LOBBY_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + LOBBY_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + LOBBY_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;                                     
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + CACHE_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + CACHE_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + CACHE_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + MAPS_CACHE_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + MODS_CACHE_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + MODS_CACHE_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + MODS_CACHE_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + LOG_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + LOG_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + LOG_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + VAR_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + VAR_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + VAR_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + FILTERS_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + FILTERS_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + FILTERS_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + REPLAY_FILTERS_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if not DirectoryExists(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER) then
    begin
      //MessageDlg('Program has detected that "' + REPLAY_FILTERS_FOLDER + '" folder does not exist. It will be now created.', mtInformation, [mbOK], 0);
      if not CreateDir(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER) then
      begin
        MessageDlg(_('Unable to create directory. Program will now exit ...'), mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;

    if Preferences.SaveLogs then OpenAllLogs; // do this before all else, so that we don't miss any message

    SplashScreenForm.UpdateText(_('loading maps ...'));

    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading maps ...');

    // lod map list in battle form and select some map (WARNING: this must be done AFTER you check if cache folder exists!):
    Utility.ReloadMapList(True);
    SplashScreenForm.UpdateText(_('finalizing ...'));
    if Utility.MapList.IndexOf(Preferences.LastOpenMap) = -1 then
    begin
      if Utility.MapList.Count = 0 then
        BattleForm.ChangeMapToNoMap('NoMap')
      else
        BattleForm.ChangeMap(0); // load first map in the list
    end
    else
      BattleForm.ChangeMap(Utility.MapList.IndexOf(Preferences.LastOpenMap)); // restore last open map

    // finally apply post-initialization preferences:
    PreferencesForm.ApplyPostInitializationPreferences;

    if not RunningUnderWine and RunningWithMainMenu then
    begin
      SplashScreenForm.UpdateText(_('loading menu ...'));
      if MainUnit.Debug.Enabled then
        Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading menu ...');
      MenuForm.LoadSkin(Preferences.SPSkin);
    end;

    if MenuModName <> '' then
    begin
      SplashScreenForm.UpdateText(_('loading mod ...'));
      if MainUnit.Debug.Enabled then
        Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading mod ...');
      if Utility.ModList.IndexOf(MenuModName) = -1 then
      begin
        MessageDlg(_('Unknown -menumod name : ')+MenuModName,mtError,[mbOk],0);
        Application.Terminate;
        Exit;
      end;
      MenuForm.LoadMod(MenuModName);
    end;


    // cache all minimaps if user chooses to do so:
    if not MapListForm.AreAllMinimapsLoaded and not Preferences.DisableMapDetailsLoading then
    begin
      if not SplashScreenForm.Active then
        FlashWindow(SplashScreenForm.Handle,True);
      if SplashScreenForm.MsgBox('Program has detected that one or more maps in your "maps" folder don''t have minimaps cached yet. Would you like to cache them now? (note: this process may take several minutes depending on the number of non-cached maps)', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        SplashScreenForm.UpdateText(_('loading missing minimaps ...'));
        if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading missing minimaps ...');
        MapListForm.LoadAllMissingMinimaps;
      end;
    end;

    // hide splash screen:
    SplashScreenForm.Close;
    FreeAndNil(SplashScreenForm);

    LockWindowUpdate(0);

    SearchFormPopupMenu.PopupForm := SearchForm;
    SearchPlayerFormPopupMenu.PopupForm := SearchPlayerForm;
    BattleForm.MapsPopupMenu.PopupForm := MapSelectionForm;
    CustomizeGUIForm.SetValuesPopupMenu.PopupForm := SetValuesForm;
    CustomizeGUIForm.SetStringsPopupMenu.PopupForm := SetStringsForm;

    //ReplaysUnit.TReadReplaysThrd.Create(False); // start reading replays from disk

    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading layouts ...');
    LoadLayouts;

    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading tips ...');
    TipsForm.LoadTips;

    KeepAliveTimer.Enabled := True;
    HighlighBattlesTimer.Enabled := True;

    MainForm.PrintUnitsyncErrors;

    // finally:
    if RunningWithMainMenu then
    begin
      if MainUnit.Debug.Enabled then
        Misc.TryToAddLog(MainUnit.StartDebugLog,'Displaying SP form ...');
      MenuForm.Show;
      if MenuModName <> '' then
        MenuForm.LoadMenu('modMain.html',ModMain);
    end
    else
    begin
      if MainUnit.Debug.Enabled then
        Misc.TryToAddLog(MainUnit.StartDebugLog,'Displaying MainForm ...');
      MainForm.Show;
      FinaliseStart;
      if Preferences.ConnectOnStartup and  not RunningWithMainMenu then
      begin
        LogonForm.Hide;
        PostMessage(MainForm.Handle, WM_CONNECT, 0, 0);
      end;
    end;

   end;
end;

procedure TMainForm.FinaliseStart;
begin
  UpdateFilters(CurrentFilters);
  if Preferences.EnableSpringDownloader then
    StartSpringDownloader;
  TipsForm.ShowTips;
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

  // next new bot form team color
    bmp := TBitmap.Create;
    bmp.Width := 16;
    bmp.Height := 16;

    with bmp.Canvas do
    begin
      if AddBotUnit.BotColor = clBlack then TransparentColor := clWhite else TransparentColor := clBlack;
      Brush.Color := TransparentColor;
      Pen.Color := TransparentColor;
      Rectangle(0, 0, 16, 16);

      Brush.Color := AddBotUnit.BotColor;
      Pen.Color := clGray;
      RoundRect(1, 1, 14, 14, 4, 4);
    end;

    ColorImageList.AddMasked(bmp, TransparentColor);

    bmp.Free;

  // next bots forms team color
  if BattleState.Battle <> nil then
    for i:=0 to BattleState.Battle.Bots.Count-1 do
    begin
      bmp := TBitmap.Create;
      bmp.Width := 16;
      bmp.Height := 16;

      with bmp.Canvas do
      begin
        if TBot(BattleState.Battle.Bots[i]).TeamColor = clBlack then TransparentColor := clWhite else TransparentColor := clBlack;
        Brush.Color := TransparentColor;
        Pen.Color := TransparentColor;
        Rectangle(0, 0, 16, 16);

        Brush.Color := TBot(BattleState.Battle.Bots[i]).TeamColor;
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
procedure TMainForm.AddTextToChatWindow(Chat: TMyTabSheet; Text: WideString; Color: TColor; ChatTextPos: Integer; DoNotHighLight : Boolean = false; DoNotFlash : Boolean = True);
var
  re: TExRichEdit;
  s: WideString;
  f: TCustomForm;
begin
  re := Chat.FindChildControl('RichEdit') as TExRichEdit;
  if Preferences.TimeStamps then
  begin
    s := '[' + TimeToStr(Now) + '] ';
    Text := s + Text;
    Inc(ChatTextPos, Length(s));
  end;
  Misc.AddTextToRichEdit(re, Text, Color, Chat.AutoScroll, ChatTextPos);
  TryToAddLog(Chat.LogFile, Text);

  if (Chat.Parent is TTabSheet) and (TTabSheet(Chat.Parent).PageControl.ActivePage <> TTabSheet(Chat.Parent)) and not DoNotHighLight then
    try
      TTabSheet(Chat.Parent).Highlighted := True;
    except
    end;

  if not DoNotFlash then
  begin
    f := GetControlForm(re);
    if not f.Active then FlashWindow(f.Handle, true);
  end;
end;

procedure TMainForm.AddTextToChatWindow(Chat: TMyTabSheet; Text: WideString; Color: TColor; DoNotHighLight : Boolean = false; DoNotFlash : Boolean = True);
begin
  AddTextToChatWindow(Chat, Text, Color, 1,DoNotHighLight,DoNotFlash);
end;

procedure TMainForm.AddMainLog(Text: WideString; Color: TColor);
begin
  mainLogBuffer.BeginUpdate;
  mainLogBuffer.Add(Text);
  mainLogBufferColor.Add(ColorToRGB(Color));
  mainLogBuffer.EndUpdate;
  SendMessage(Handle,WM_REFRESHMAINLOG,0,0);
end;

procedure TMainForm.AmbiguousCommand(AmbiguousCommand : WideString; Text: WideString; Color: TColor; AmbiguousCommandID: Integer);
begin
  AddMainLog(_('Error: Server sent ambiguous command!')+IFF(Text<>'','{'+Text+'}','') + ' [#' + IntToStr(AmbiguousCommandID) + ']', Color);
  AddMainLog(_('Ambiguous command : ')+AmbiguousCommand, Color);
end;

// SetFocus: if True, then switch focus to this new TAB and update
function TMainForm.AddTabWindow(Caption: string; SetFocus: Boolean; pmId: integer = -1): TMyTabSheet;
var
  tmppn: TSpTBXPanel;
  tmpts: TMyTabSheet;
  tmpre: TExRichEdit;
  //tmped: TSpTBXEdit;
  tmped: TTntMemo;
  mask: Word;
  FileName: string;
  logsLastLines : string;
  tabName: string;
  i: integer;
  nbTabs: integer;
  f: TCustomForm;
begin
  Result := nil;

  tmpts := TMyTabSheet.CreateNew(MainForm,0);

  tmpts.PMId := pmId;

  if mnuLockView.Checked then
  begin
    tmpts.DragMode := dmManual;
    tmpts.DragKind := dkDrag;
  end
  else
  begin
    tmpts.DragMode := dmAutomatic;
    tmpts.DragKind := dkDock;
  end;

  tmpts.ManualDock(MainPCH.PageControl);
  tmpts.Show;
  MainPCH.Visible := True;

  tabName := 'TabSheet_'+Caption;
  nbTabs := 0;

  for i:=0 to MainForm.ChatTabs.Count-1 do
    if (LowerCase(TMyTabSheet(MainForm.ChatTabs[i]).Caption) = LowerCase(Caption)) and (TMyTabSheet(MainForm.ChatTabs[i]).Caption <> Caption) then
      nbTabs := nbTabs+1;
  tabName := 'TabSheet_'+Caption+'_'+IntToStr(nbTabs);
  tmpts.Caption := Caption;
  tabName := StringReplace(tabName,'$','Internal_',[rfReplaceAll]);
  tabName := StringReplace(tabName,'#','Channel_',[rfReplaceAll]);
  tabName := StringReplace(tabName,'[','_OB_',[rfReplaceAll]);
  tabName := StringReplace(tabName,']','_EB_',[rfReplaceAll]);
  try
    tmpts.Name := tabName;
  except
  end;
  i := 1;
  while tmpts.Name = '' do
    try
      tmpts.Name := tabName+'_'+IntToStr(i);
    except
      Inc(i);
    end;

  tmped := TTntMemo.Create(tmpts);
  tmped.Parent := tmpts;
  tmped.Name := 'InputEdit'; // don't change this name! (there are some references to it in the code)
  tmped.Text := '';
  tmped.Height := CommonFont.Size*2+5;
  tmped.HideSelection := False;
  tmped.ScrollBars := ssNone;
  tmped.OnKeyPress := InputEditKeyPress;
  tmped.OnKeyDown := InputEditKeyDown;
  tmped.OnClick := InputEditClick;
  tmped.OnChange := InputEditChange;
  tmped.Font.Assign(CommonFont);
  tmped.Align := alBottom;
  tmped.WordWrap := False;

  tmpre := TExRichEdit.Create(tmpts);
  tmpre.Parent := tmpts;
  tmpre.Font.Assign(CommonFont);
  tmpre.ScrollBars := ssVertical;
  tmpre.ReadOnly := True;
  tmpre.AutoVerbMenu := False;
  tmpre.PlainRTF := False;
  tmpre.WordWrap := True;
  tmpre.TabStop := False;
  tmpre.Align := alClient;
  tmpre.WantTabs := False;
  tmpre.HideSelection := False;
  tmpre.IncludeOLE := False;
  tmpre.LangOptions := [];
  tmpre.ParentColor := False;
  tmpre.ParentCtl3D := False;
  tmpre.ParentFont := False;
  tmpre.ParentShowHint := False;
  tmpre.PopupMenu := RichEditPopupMenu;
  tmpre.OnMouseDown := RichEditMouseDown;
  tmpre.AutoURLDetect := adDefault;
  tmpre.OnDblClick := RichEditDblClick;
  tmpre.OnURLClick := RichEditURLClick;
  tmpre.Name := 'RichEdit';

  if Preferences.SaveLogs then
  begin
    if pmId > -1 then
      FileName := ExtractFilePath(Application.ExeName) + LOG_FOLDER + '\' + GetClientById(pmId).Name + '.log'
    else
      FileName := ExtractFilePath(Application.ExeName) + LOG_FOLDER + '\' + tmpts.Caption + '.log';
    tmpts.LogFile := OpenLog(FileName);
    tmpts.LogFileName := FileName;
    if tmpts.LogFile = nil then
      AddMainLog(_('Error: unable to access file: ') + FileName, Colors.Error)
    else if Preferences.ChatLogLoadLoading then
    begin
      logsLastLines := ReadLastLogFileLines(tmpts.LogFile,Preferences.ChatLogLoadLines);
      if logsLastLines <> '' then
        AddTextToRichEdit(tmpre,logsLastLines,Colors.OldMsgs,True,0);
    end;
  end;

  PreferencesForm.UpdateExRichEdit(tmpre);
  PreferencesForm.UpdateTntMemo(tmped);

  // scroll to bottom
  tmpre.SelLength := 0;
  tmpre.SelStart := 0;
  tmpre.SelStart := Length(tmpre.text);

  f := GetControlForm(tmped);
  if not f.Active then FlashWindow(f.Handle, true);

  // finally:
  if SetFocus then
    ShowAndSetFocus(tmped);

  Result := tmpts;
end;

// if tab window with Caption does not exists, it returns -1. Returns index in TPageControl.Pages
function TMainForm.GetTabWindowPageIndex(Caption: string): Integer;
var
  i: Integer;
begin
  Result := -1;

  for i := 0 to ChatTabs.Count-1 do
    if TMyTabSheet(MainForm.ChatTabs[i]).Caption = Caption then
    begin
      Result := i;
      Break;
    end;
end;
function TMainForm.GetTabWindowPageIndex(Client: TClient): Integer;
var
  i: Integer;
begin
  Result := -1;

  for i := 0 to ChatTabs.Count-1 do
    if ((Client.Id <> -1) and (TMyTabSheet(MainForm.ChatTabs[i]).PMId = Client.Id)) or ((Client.Id = -1) and (TMyTabSheet(MainForm.ChatTabs[i]).Caption = Client.Name)) then
    begin
      Result := i;
      Break;
    end;
end;

function TMainForm.AddClientToTab(ClientList: TList; ClientName: WideString): Boolean; // does not update ClientsListBox!
var
  c: TClient;
  i: Integer;
  tmp: TClient;
begin
  Result := False;

  c := GetClient(ClientName);
  if c = nil then Exit;

  // make sure client is not already in the list:
  for i := 0 to ClientList.Count-1 do
    if TClient(ClientList[i]).Name = ClientName then
      Exit;

  ClientList.Add(c);
  i := ClientList.Count-1;
  // sort:
  while i > 0 do
    if CompareClients(ClientList[i], ClientList[i-1], Preferences.SortStyle, Preferences.SortAsc) < 0 then
    begin
      // swap:
      tmp := ClientList[i];
      ClientList[i] := ClientList[i-1];
      ClientList[i-1] := tmp;
      Dec(i);
    end
    else Break;

  Result := True;
end;

function TMainForm.RemoveClientFromTab(Tab: TMyTabSheet; ClientName: WideString): Boolean; // does not update ClientsListBox!
var
  i: Integer;
begin
  Result := True;

  for i := 0 to Tab.Clients.Count - 1 do
    if TClient(Tab.Clients[i]).Name = ClientName then
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

procedure TMainForm.UpdateBattlePlayersListBox(battle: TBattle; client:TClient);
var
  b: TBattle;
begin
  b := selectedBattlePlayers;
  if b <> nil then
  begin
    if ((b <> battle) and (battle <> nil)) or ((client <>nil) and (b.Clients.IndexOf(client) = -1)) then Exit;
    BattlePlayersListBox.Items.BeginUpdate;
    BattlePlayersListBox.Items.SetTextW(PWideChar(WideString(CreateStrings(b.Clients.Count))));
    BattlePlayersListBox.Items.EndUpdate;
    BattlePlayersListBox.Invalidate ;
  end
  else
  begin
    BattlePlayersListBox.Items.Clear;
    BattlePlayersListBox.Invalidate;
  end;
end;

procedure TMainForm.UpdateClientsListBox;
var
  c: Integer;
  LastIndex: Integer;
  TempItemIndex: Integer;
  TempCount: Integer;
  words: TStringList;
  i,j: integer;
  cList: TList;
  client: TClient;
  textFoundInNameHistory: boolean;
begin
  words := TStringList.Create;
  c := 0;

  if lastActiveTab.Caption = LOCAL_TAB then
    cList := AllClients
  else
    cList := lastActiveTab.Clients;

  for i:=0 to cList.Count-1 do
  begin
    try
      client := TClient(cList[i]);
      textFoundInNameHistory := false;

      if PlayerFiltersTextbox.Text <> '' then
      begin
        for j:=0 to client.FNameHistory.Count-1 do
        begin
          if RegExpr.ExecRegExpr(LowerCase(PlayerFiltersTextbox.Text),LowerCase(client.FNameHistory[j])) then
          begin
            textFoundInNameHistory := true;
            break;
          end;
        end;
        client.Visible :=   textFoundInNameHistory
                        or  RegExpr.ExecRegExpr(LowerCase(PlayerFiltersTextbox.Text),LowerCase(client.Name))
                        or  RegExpr.ExecRegExpr(LowerCase(PlayerFiltersTextbox.Text),LowerCase(client.DisplayName));
      end
      else
      begin
        client.Visible := true;
      end;

      if (client.Group <> nil) then
      begin
        client.Visible := client.Visible or RegExpr.ExecRegExpr(LowerCase(PlayerFiltersTextbox.Text),LowerCase(client.Group.Name));
      end;

    except
      TClient(cList[i]).Visible := True;
    end;
    if TClient(cList[i]).Visible then Inc(c);
  end;

  LastIndex := ClientsListBox.TopIndex;
  TempItemIndex := ClientsListBox.ItemIndex;
  TempCount := ClientsListBox.Items.Count;

  ClientsListBox.Items.BeginUpdate;

  if c = 0 then
    PlayersLabel.Caption := _('Players:')
  else
    PlayersLabel.Caption := _('Players (') + IntToStr(c) + '):';
  ClientsListBox.Items.SetTextW(PWideChar(WideString(CreateStrings(c))));


  // next line is important because if there are many players online, their statuses
  // will get updated more often and sometimes you won't be able to double click
  // on a player since clients list will get updated so fast it will reset your
  // selection from the first click. This fixes it:
  ClientsListBox.ItemIndex := TempItemIndex;

  ClientsListBox.TopIndex := LastIndex;

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
  sl2: TStringList;
  sl3: TStringList;
  p: Pointer;
  i: Integer;
  tmp: WideString;
  tmpBool: boolean;
  duration: Integer; // temp var
  res: Integer;
  str: WideString;
  pinginfo: PPingInfo;
  handleCommandReturn: boolean;
begin

  if s = '' then Exit;
  sl := ParseString(s, ' ');
  sl[0] := UpperCase(sl[0]);

  try
    handleCommandReturn := false;
    if AcquireMainThread then
    begin
      try if not Preferences.ScriptsDisabled then handleCommandReturn := handlers.handleCommand(s); except end;
      ReleaseMainThread;
    end;
    if handleCommandReturn then Exit
    else if sl[0] = 'CONNECT' then TryToConnect
    else if (sl[0] = 'QUIT') and (sl.Count=1) then MainForm.Close
    else if sl[0] = 'GETDOWNLOADLINKS' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog(_('Usage: /getdownloadlinks mod/mapname'), Colors.Error);
        Exit;
      end;
      sl3 := TStringList.Create;
      sl2 := SpringDownloaderFormUnit.GetDownloadLinks(MakeSentenceWS(sl,1),sl3);
      sl3.Free;
      AddMainLog('',Colors.Info);
      AddMainLog(_('Download links')+' ['+IntToStr(sl2.count)+'] ('+MakeSentenceWS(sl,1)+'):',Colors.Info);
      for i:=0 to sl2.Count-1 do
        AddMainLog(sl2[i],Colors.Info);
    end
    else if sl[0] = 'GETENGINEDOWNLOADLINKS' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog(_('Usage: /getenginedownloadlinks name version (ex: "/getenginedownloadlinks spring 96.0")'), Colors.Error);
        Exit;
      end;
      sl2 := SpringDownloaderFormUnit.GetEngineDownloadLinks(MakeSentenceWS(sl,1));
      AddMainLog('',Colors.Info);
      AddMainLog(_('Download links')+' ['+IntToStr(sl2.count)+'] ('+MakeSentenceWS(sl,1)+'):',Colors.Info);
      for i:=0 to sl2.Count-1 do
        AddMainLog(sl2[i],Colors.Info);
    end
    else if sl[0] = 'DOWNLOADMAP' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog(_('Usage: /downloadmap mapname'), Colors.Error);
        Exit;
      end;
      SpringDownloaderFormUnit.DownloadMap(0,MakeSentenceWS(sl,1));
    end
    else if sl[0] = 'DOWNLOADMOD' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog(_('Usage: /downloadmod modname'), Colors.Error);
        Exit;
      end;
      SpringDownloaderFormUnit.DownloadMod(0,MakeSentenceWS(sl,1));
    end
    else if sl[0] = 'DOWNLOADMODARCHIVE' then
    begin
      if sl.Count < 2 then
      begin
        AddMainLog(_('Usage: /downloadmodarchive modname'), Colors.Error);
        Exit;
      end;
      SpringDownloaderFormUnit.DownloadMod(0,MakeSentenceWS(sl,1),true);
    end
    else if sl[0] = 'RAPIDTOSDD' then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog(_('Usage: /rapidtosdd rapidname(ex: ba:latest) sddName'), Colors.Error);
        Exit;
      end;
      SpringDownloaderFormUnit.DownloadRapid(sl[1], true, MakeSentenceWS(sl,2));
      AddMainLog(_('The mod will be available in : ') + ExtractFilePath(Application.ExeName)+'mods\'+MakeSentenceWS(sl,2)+'.sdd', Colors.Info);
    end
    else if sl[0] = 'DOWNLOADRAPID' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog(_('Usage: /downloadrapid rapidname(ex: ba:latest)'), Colors.Error);
        Exit;
      end;
      SpringDownloaderFormUnit.DownloadRapid(sl[1], false, '');
    end
    else if sl[0] = 'RAPIDLIST' then
    begin
      TRapidDownloadThread.Create(false,nil,MakeSentenceWS(sl,1),'',True);
    end
    else if sl[0] = 'OPENPLAYERCHATLOGS' then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog(_('Usage: /openplayerchatlogs playername'), Colors.Error);
        Exit;
      end;
      if FileExists(ExtractFilePath(Application.ExeName)+LOG_FOLDER+'\'+sl[1]+'.log') then
        ShellExecute(0,'open',PChar(String(ExtractFilePath(Application.ExeName)+LOG_FOLDER+'\'+sl[1]+'.log')),nil,nil,SW_SHOWNORMAL);
    end
    else if (sl[0] = 'ISSPADSAUTOHOST') and CameFromBattleScreen and (BattleState.Status = Joined) then
    begin
      tmpBool := BattleForm.ChatRichEdit.atBottom;
      BattleState.AutoHostType := 0;
      BattleForm.AutoHostCommandsButton.DropDownMenu := BattleForm.SPADSPopupMenu;
      BattleForm.AutoHostControlLabel.Caption := _('Autohost - ')+'SPADS';
      if not BattleState.AutoHost then
      begin
        BattleForm.AutoHostMsgsRichEdit.Clear;
        BattleState.AutoHost := True;
        BattleForm.AutoHostInfoPanel.Visible := True;
        BattleForm.AutohostControlSplitter.Visible := BattleForm.AutoHostInfoPanel.Visible;
        BattleForm.AutohostControlSplitter.Align := alBottom;
        BattleForm.AutohostControlSplitter.Align := alTop;
        BattleForm.AutoHostVotePanel.Align := alBottom;
        BattleForm.AutoHostVotePanel.Align := alTop;
        BattleForm.Refresh;
        if tmpBool then
        begin
         BattleForm.ChatRichEdit.ScrollToTop;
         BattleForm.ChatRichEdit.ScrollToBottom;
        end;
      end;
    end
    else if (sl[0] = 'ISSPRINGIEAUTOHOST') and CameFromBattleScreen and (BattleState.Status = Joined) then
    begin
      tmpBool := BattleForm.ChatRichEdit.atBottom;
      BattleState.AutoHostType := 1;
      BattleForm.AutoHostCommandsButton.DropDownMenu := BattleForm.SPRINGIEPopupMenu;
      BattleForm.AutoHostControlLabel.Caption := _('Autohost - ')+'Springie';
      if not BattleState.AutoHost then
      begin
        BattleForm.AutoHostMsgsRichEdit.Clear;
        BattleState.AutoHost := True;
        BattleForm.AutoHostInfoPanel.Visible := True;
        BattleForm.AutohostControlSplitter.Visible := BattleForm.AutoHostInfoPanel.Visible;
        BattleForm.AutohostControlSplitter.Align := alBottom;
        BattleForm.AutohostControlSplitter.Align := alTop;
        BattleForm.AutoHostVotePanel.Align := alBottom;
        BattleForm.AutoHostVotePanel.Align := alTop;
        BattleForm.Refresh;
        if tmpBool then
        begin
         BattleForm.ChatRichEdit.ScrollToTop;
         BattleForm.ChatRichEdit.ScrollToBottom;
        end;
      end;
    end
    else if (sl[0] = 'ISNTAUTOHOST') and CameFromBattleScreen and (BattleState.Status = Joined) then
    begin
      BattleState.AutoHostType := 1;
      BattleState.AutoHost := False;
      BattleForm.AutoHostInfoPanel.Visible := False;
      BattleForm.AutoHostVotePanel.Visible := False;
    end
    else if (sl[0] = 'QUIT') and (sl.Count>1) then
    begin
      TryToSendCommand('EXIT', MakeSentenceWS(sl,1));
      Sleep(1000);
      MainForm.Close;
    end
    else if (sl[0] = 'FORCEQUIT') and (HostBattleForm.relayHoster <> nil) then
    begin
      TryToSendCommand('SAYPRIVATE',HostBattleForm.relayHoster.Name+' #/quitforce');
    end
    else if (sl[0] = 'FORCESTART') and CameFromBattleScreen and BattleForm.IsBattleActive then
    begin
      if (BattleState.Status=Hosting) and (BattleState.Battle.NATType = 1) then  // "hole punching" method
      begin
        // let's acquire our public UDP source port from the server:
        InitWaitForm.ChangeCaption(MSG_GETHOSTPORT);
        InitWaitForm.TakeAction := 2; // get host port
        res := InitWaitForm.ShowModal;
        if res <> mrOK then
        begin
          if not LobbyScriptUnit.ScriptStart then MessageDlg(_('Unable to acquire UDP source port from server. Try choosing another NAT traversal technique!'), mtWarning, [mbOK], 0);
          Exit;
        end;
      end;
      LobbyScriptUnit.StartBattleSuccess := True;
      PostMessage(BattleForm.Handle, WM_STARTGAME, 0, 0);
    end
    else if sl[0] = 'EXIT' then MainForm.Close
    else if (sl[0] = 'JOIN') or (sl[0] = 'J') then
    begin
      if (Status.ConnectionState <> Connected) or (not Status.LoggedIn) then
      begin
        AddMainLog(_('You must be connected and logged on a server to join channel!'), Colors.Error);
        Exit;
      end;

      if (sl.Count < 2) or (sl[1][1] <> '#') then
      begin
        AddMainLog(_('Cannot join - bad or no argument (don''t forget to put "#" in front of a channel''s name!)'), Colors.Error);
        Exit;
      end;
      if sl.Count = 2 then tmp := '' else tmp := ' ' + MakeSentenceWS(sl, 2);
      TryToSendCommand('JOIN', Copy(sl[1], 2, Length(sl[1])-1) + tmp);
    end
    else if (sl[0] = 'PART') or (sl[0] = 'P') then
    begin
      if (sl.Count <> 1) then
      begin
        MessageDlg(_('Invalid command - ''PART'' requires no arguments'), mtInformation, [mbOK], 0);
        Exit;
      end;

      //PostMessage(MainForm.Handle, WM_CLOSETAB, PageControl1.ActivePageIndex, 0);
    end
    else if (sl[0] = 'CHANNELS') or (sl[0] = 'LIST') then
    begin
      if (Status.ConnectionState <> Connected) or (not Status.LoggedIn) then
      begin
        AddMainLog(_('Must be connected and logged on a server to send command!'), Colors.Error);
        Exit;
      end;
      ChannelsListForm.ClearnChannels;
      AddMainLog(_('Requesting channel list from server ...'), Colors.Info);
      TryToSendCommand('CHANNELS');
    end
    else if (sl[0] = 'ME') then
    begin
      if CameFromBattleScreen then TryToSendCommand('SAYBATTLEEX', MakeSentenceWS(sl, 1))
      else if lastActiveTab.Caption[1] = '#' then // a channel tab
        TryToSendCommand('SAYEX', Copy(lastActiveTab.Caption, 2, Length(lastActiveTab.Caption)-1) + ' ' + MakeSentenceWS(sl, 1));
    end
    else if (sl[0] = 'RING') then
    begin
      if sl.Count <> 2 then
      begin
        AddMainLog(_('RING command requires exactly 1 parameter!'), Colors.Error);
        Exit;
      end;

      if MainForm.GetClient(sl[1]) = nil then
      begin
        MessageDlg(_('Invalid RING command. User does not exist! (Note: all names are case-sensitive)'), mtWarning, [mbOK], 0);
        Exit;
      end;

      TryToSendCommand('RING', sl[1]);
      AddMainLog(_('Ringing ') + sl[1] + ' ...', Colors.Info);
    end
    else if (sl[0] = 'HELP') then
    begin
      if not HelpForm.Visible then HelpForm.ShowModal;
    end
    else if (sl[0] = 'UPTIME') then
    begin
      if not (Status.ConnectionState = Connected)  then
      begin
        AddMainLog(_('You must be connected and logged on the server for this command to take effect!'), Colors.Error);
        Exit;
      end;

      TryToSendCommand('UPTIME');
    end
    else if (sl[0] = 'KICK') and (CameFromBattleScreen) then
    begin

      if not BattleForm.IsBattleActive then
      begin
        AddMainLog(_('Denied: Battle is not active!'), Colors.Error);
        Exit;
      end;

      if not (sl.Count = 2) then
      begin
        AddMainLog(_('Denied: This command requires exactly 1 argument!'), Colors.Error);
        Exit;
      end;

      if not (BattleState.Status = Hosting) then
      begin
        AddMainLog(_('Denied: Only host can kick players from battle!'), Colors.Error);
        Exit;
      end;

      if BattleState.Battle.GetClient(sl[1]) = nil then
      begin
        AddMainLog(_('Denied: Player ') + sl[1] + _(' not found in this battle. (Note: all names are case-sensitive)'), Colors.Error);
        Exit;
      end;

      MainForm.TryToSendCommand('KICKFROMBATTLE', sl[1]);
    end
    else if (sl[0] = 'KICK') and (not CameFromBattleScreen) then
    begin
      if (sl.Count < 2) then
      begin
        AddMainLog(_('Denied: This command requires exactly 1 argument!'), Colors.Error);
        Exit;
      end;

      if sl.Count > 2 then tmp := ' ' + MakeSentenceWS(sl, 2)
      else tmp := '';

      if MainForm.GetClient(sl[1]) = nil then
      begin
        MessageDlg(_('Invalid KICK command. User does not exist! (Note: all names are case-sensitive)'), mtWarning, [mbOK], 0);
        Exit;
      end;

      MainForm.TryToSendCommand('KICKUSER', sl[1] + tmp);
    end
    else if (sl[0] = 'RENAME') then
    begin
      if not (sl.Count = 2) then
      begin
        AddMainLog(_('Denied: This command requires exactly 1 argument!'), Colors.Error);
        Exit;
      end;

      AddMainLog(_('Requesting account rename from the server ...'), Colors.Info);
      MainForm.TryToSendCommand('RENAMEACCOUNT', sl[1]);
    end
    else if (sl[0] = 'PASSWORD') then
    begin
      if not (sl.Count = 3) then
      begin
        AddMainLog(_('Denied: This command requires exactly 2 arguments (old and new passwords)!'), Colors.Error);
        Exit;
      end;

      if (not VerifyName(sl[2])) then
      begin
        AddMainLog(_('Invalid password! Make sure your password consists only of legal characters.'), Colors.Error);
        Exit;
      end;

      AddMainLog(_('Trying to change password ...'), Colors.Info);
      MainForm.TryToSendCommand('CHANGEPASSWORD', Misc.GetMD5Hash(sl[1]) + ' ' + Misc.GetMD5Hash(sl[2]));
    end
    else if (sl[0] = 'TOPIC') and (not CameFromBattleScreen) then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog(_('Error: Not enough arguments specified!'), Colors.Error);
        Exit;
      end;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog(_('Error: Bad syntax!'), Colors.Error);
        Exit;
      end;

      TryToSendCommand('CHANNELTOPIC', Copy(sl[1], 2, Length(sl[1])-1) + ' ' + MakeSentenceWS(sl, 2));
    end
    else if (sl[0] = 'CHANMSG') then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog(_('Error: Not enough arguments specified!'), Colors.Error);
        Exit;
      end;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog(_('Error: Bad syntax!'), Colors.Error);
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
        AddMainLog(_('Denied: Missing arguments!'), Colors.Error);
        Exit;
      end;

      if MainForm.GetClient(sl[1]) = nil then
      begin
        MessageDlg(_('Invalid IP command. User is not online! (Note: all names are case-sensitive)'), mtWarning, [mbOK], 0);
        Exit;
      end;

      MainForm.TryToSendCommand('GETIP', sl[1]);
    end
    else if (sl[0] = 'FINDIP') then
    begin
      if (sl.Count < 2) then
      begin
        AddMainLog(_('Denied: Missing arguments!'), Colors.Error);
        Exit;
      end;

      MainForm.TryToSendCommand('FINDIP', sl[1]);
    end
    else if (sl[0] = 'LASTLOGIN') then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog(_('Denied: This command requires exactly 1 argument!'), Colors.Error);
        Exit;
      end;

      MainForm.TryToSendCommand('GETLASTLOGINTIME', sl[1]);
    end
    else if (sl[0] = 'LASTIP') then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog(_('Denied: This command requires exactly 1 argument!'), Colors.Error);
        Exit;
      end;

      MainForm.TryToSendCommand('GETLASTIP', sl[1]);
    end
    else if (sl[0] = 'MUTE') then
    begin
      if (sl.Count < 3) then
      begin
        AddMainLog(_('Denied: Missing arguments!'), Colors.Error);
        Exit;
      end;

      if (sl.Count > 3) and (UpperCase(sl[3]) <> 'IP') then
        try
          duration := StrToInt(sl[3]);
        except
          AddMainLog(_('Error in MUTE command: Duration must be an integer!'), Colors.Error);
          Exit;
        end
      else duration := 0;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog(_('Error: Bad syntax!'), Colors.Error);
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
        AddMainLog(_('Denied: Missing arguments!'), Colors.Error);
        Exit;
      end;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog(_('Error: Bad syntax!'), Colors.Error);
        Exit;
      end;

      TryToSendCommand('UNMUTE', Copy(sl[1], 2, Length(sl[1])-1) + ' ' + sl[2]);
    end
    else if (sl[0] = 'MUTELIST') then
    begin
      if (sl.Count <> 2) then
      begin
        AddMainLog(_('Denied: Missing arguments!'), Colors.Error);
        Exit;
      end;

      if Copy(sl[1], 1, 1) <> '#' then
      begin
        AddMainLog(_('Error: Bad syntax!'), Colors.Error);
        Exit;
      end;

      TryToSendCommand('MUTELIST', Copy(sl[1], 2, Length(sl[1])-1));
    end
    else if (sl[0] = 'TESTNOTIFY') then
    begin
      AddNotification(_('Test'), _('This is only a test.'), 2000);
    end
    else if (sl[0] = 'FORCEUPDATE') then
    begin
      TLobbyUpdateThread.Create(False,False,True,0,True);
    end
    else if (sl[0] = 'FORCEBETAUPDATE') then
    begin
      TLobbyUpdateThread.Create(False,True,True,0,True);
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
        AddMainLog(_('Error: Not enough arguments specified!'), Colors.Error);
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
    else if (sl[0] = 'VERSION') then
    begin
      AddMainLog('TASClient version : '+VERSION_NUMBER+' rev '+IntToStr(Misc.GetLobbyRevision), Colors.Info);
      Exit;
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
      AddMainLog(_('Local IP address: ') + Misc.GetLocalIP, Colors.Error);
    end
    else if (sl[0] = 'PING') then
    begin
      if sl.Count > 1 then
      begin
        AddMainLog(_('Error: Too many arguments!'), Colors.Error);
        Exit;
      end;
      New(pinginfo);
      pinginfo.Key := TryToSendCommand('PING', True);
      pinginfo.TimeSent := GetTickCount;
      Pings.Add(pinginfo);

      AddMainLog(_('Pinging server ...'), Colors.Info);
    end
    else if (sl[0] = 'MSG') then
    begin
      if sl.Count < 3 then
      begin
        AddMainLog(_('Error: Too few arguments!'), Colors.Error);
        Exit;
      end;

      if MainForm.GetClient(sl[1]) = nil then
      begin
        AddMainLog(_('User <') + sl[1] + _('> not found!'), Colors.Error);
        Exit;
      end;

      TryToSendCommand('SAYPRIVATE', sl[1] + ' ' + MakeSentenceWS(sl, 2));
    end
    else if (sl[0] = 'HOOK') then
    begin
      if sl.Count > 2 then
      begin
        AddMainLog(_('Error: Too many arguments!'), Colors.Error);
        Exit;
      end;
      if(sl.Count = 2) then
        TryToSendCommand('HOOK', sl[1])
      else
        TryToSendCommand('HOOK')
    end
    else if (sl[0] = 'SCRIPTSDEBUGWINDOW') then
    begin
      PythonScriptDebugForm.Show;
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
          if MessageDlg(_('User <') + tmp + _('> is not online, do you wish to add him to ignore list anyway?'), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            if IgnoreListForm.SetOfflineClientIsIgnored(tmp,True) then
              IgnoreListForm.ShowModal
            else
              AddMainLog(_('Error: Unknown UserName.'),Colors.Error);
          end;
        end
        else
        begin
            if IgnoreListForm.SetOfflineClientIsIgnored(tmp,True) then
              IgnoreListForm.ShowModal
            else
              AddMainLog(_('Error: Unknown UserName.'),Colors.Error);
        end;
      end;
    end
    else AddMainLog(_('Error: Unknown command!'), Colors.Error);

  finally
    if sl <> nil then sl.Free;
  end;

end;


procedure TMainForm.ProcessRemoteCommand(s: WideString); // processes command received from server
var
  sl: TWideStringList;
  sl2: TWideStringList; // temp.
  sl3: TStringList; // temp.
  list: TList; // tmp
  MsgID: Integer;
  i, j, k, l, m, n, o, p, r, t: Integer;
  BattleIndex: Integer;
  Battle: TBattle;
  Client,Client2: TClient;
  Bot: TBot;
  tmp, tmp2, url: WideString;
  hash: integer;
  tmpInt, tmpInt2, tmpInt3,tmpInt4: Integer;
  tmpInt64: Int64;
  tmpBool, tmpBool2: Boolean;
  tmpStr: String;
  changed: Boolean;
  count: Integer;
  tmpi64: Int64;
  rect: TRect;
  index: Integer;
  battletype, nattype: Integer;
  ms: TMemoryStream;
  team, ally, teamcolor,color: Integer;
  //color: TColor;
  mapitem: TMapItem;
  maphash: Integer;
  oldMapHash: integer;
  oldVisible: Boolean;
  luaOpt: TLuaOption;
  cTmp: TColor;
  tmpClientGroup: TClientGroup;
begin
  tmp := s;

  if AcquireMainThread then
  begin
    try if not Preferences.ScriptsDisabled then s := handlers.handleIn(s); except end;
    ReleaseMainThread;
  end;

  if Debug.Enabled and ((not Debug.FilterPingPong) or (s <> 'PONG')) then
    if (s <> 'ACQUIREUSERID') or Status.Me.GetAccess then
      AddMainLog('Server: "' + s + '"', Colors.Data);

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
          AddMainLog(_('Parsing TASSERVER command failed !'), Colors.Error);
        AddMainLog(_('Server version (') + IFF(sl.Count > 1, sl[1], _('[unknown]')) + _(') is not supported with this client!'), Colors.Info);
        AddMainLog(_('Requesting update from server ...'), Colors.Info);
        //TryToSendCommand('REQUESTUPDATEFILE', 'TASClient ' + VERSION_NUMBER); // we ask server if he has an update for us
        //if autoUpdateDone then
        TLobbyUpdateThread.Create(False,False,True,5000);
        Exit;
      end;

      if (sl[2] <> '*') and ( CompareSpringVersion( sl[2], Status.MySpringVersion) < 0 ) and (not Debug.IgnoreVersionIncompatibility) then
      begin
        AddMainLog(_('Server says our Spring version (') + Status.MySpringVersion + _(') is outdated (server only supports ') + sl[2] + ')', Colors.Info);
        AddMainLog(_('Requesting update from server ...'), Colors.Info);
        TryToSendCommand('REQUESTUPDATEFILE', 'Spring ' + Status.MySpringVersion); // we ask server if he has an update for us
        Exit;
      end;

      try
        Status.NATHelpServerPort := StrToInt(sl[3]);
        Status.ServerMode := 0;
        Status.ServerMode := StrToInt(sl[4]);
      except
        AddMainLog(_('This server version is not supported with this client!'), Colors.Info);
        AddMainLog(_('Requesting update from server ...'), Colors.Info);
        //TryToSendCommand('REQUESTUPDATEFILE', 'TASClient ' + VERSION_NUMBER); // we ask server if he has an update for us
        //if autoUpdateDone then
        TLobbyUpdateThread.Create(False,False,True,5000);
        Exit;
      end;

      if Status.Registering then TryToRegister(Preferences.Username, Preferences.Password)
      else TryToLogin(Preferences.Username, Preferences.Password);
    end
    else if sl[0] = 'REDIRECT' then
    begin
      if (sl.Count <> 2) then
      begin
        AmbiguousCommand(s,'', Colors.Error, 0);
        Exit;
      end;
      if not Debug.IgnoreRedirects then
      begin
        AddMainLog(_('Server is redirecting us to: ') + sl[1], Colors.Info);
        Preferences.RedirectIP := sl[1];
        PostMessage(MainForm.Handle, WM_FORCERECONNECT, 0, 0); // we must post a message, reconnecting from here won't work
      end;
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
      AgreementForm.RichEdit1.BeginUpdate;
      AgreementForm.RichEdit1.Clear;
      AgreementForm.RichEdit1.InsertRTF(WideStringToUTF8(tmp));
      AgreementForm.RichEdit1.EndUpdate;
      AgreementForm.ShowModal;
    end
    else if sl[0] = 'DENIED' then
    begin
      if sl.Count = 1 then tmp := _('Unknown reason') else tmp := MakeSentenceWS(sl, 1);
      MessageDlg(_('Error logging to server: ') + tmp, mtWarning, [mbOK], 0);
      AddMainLog(_('Login failed: ') + tmp, Colors.Error);
      TryToDisconnect;
    end
    else if sl[0] = 'ACCEPTED' then
    begin
      ConnectButton.ImageIndex := 2;
      LogonForm.btLogin.ImageIndex := ConnectButton.ImageIndex;
      AddMainLog(_('Login successful!'), Colors.Info);
      MainForm.MainTitleBar.Caption := PROGRAM_VERSION+' - '+sl[1];
      MainForm.Caption := PROGRAM_VERSION+' - '+sl[1];
      Status.LoggedIn := True;
      Status.ReceivingLoginInfo := True;
      if sl.Count > 1 then Status.Username := sl[1]; // this should always evaluate to TRUE
      if not Preferences.DisableAllSounds then PlayResSound('connect');

      ProcessCommand('JOIN #tasclient',False);
      IgnoreNextTASClientChanJoin := True;

      if Preferences.JoinMainChannel then ProcessCommand('JOIN #main', False); // try to join #main immediately after user has been logged in
      PerformForm.PerformCommands;

      // display "login in progress" window:
      Misc.CenterFormOverAnotherForm(LoginProgressForm, MainForm); // center the login form first
      LoginProgressForm.Show;
    end
    else if sl[0] = 'LOGININFOEND' then
    begin
      LoginProgressForm.UpdateCaption(_('Joining channels ...'));
      Status.ReceivingLoginInfo := False;

      // we must do some graphical updating now since we ignored it while receiving login info (to speed the login process):
      if Preferences.SortLocal then
        SortClientsList(AllClients,Preferences.SortStyle, Preferences.SortAsc);
      for i := 1 {start from 1 to skip LOCAL_TAB} to ChatTabs.Count-1 do
        SortClientsList(TMyTabSheet(MainForm.ChatTabs[i]).Clients, Preferences.SortStyle, Preferences.SortAsc);
      UpdateClientsListBox;
      VDTBattles.Invalidate;

      // joins every channels opened
      for i:=0 to ChatTabs.Count-1 do
        if (LeftStr(TMyTabSheet(MainForm.ChatTabs[i]).Caption,1) = '#') and (LowerCase(TMyTabSheet(MainForm.ChatTabs[i]).Caption) <> '#main') then
        begin
          tmpBool := false;
          for j:=0 to PerformForm.CommandsListBox.Count-1 do
            if (AnsiUpperCase(PerformForm.CommandsListBox.Items[j]) = '/J '+AnsiUpperCase(TMyTabSheet(MainForm.ChatTabs[i]).Caption)) or (AnsiUpperCase(PerformForm.CommandsListBox.Items[j]) = '/JOIN '+AnsiUpperCase(TMyTabSheet(MainForm.ChatTabs[i]).Caption)) then
            begin
              tmpBool := true;
              Break;
            end;
          if not tmpBool then
          begin
            ProcessCommand('JOIN '+TMyTabSheet(MainForm.ChatTabs[i]).Caption,False);
          end;
        end;

      // check new version
      CheckNewVersion;

      // hide the news
      if NewsPanel.Visible then
        ExpandNewsButtonClick(nil);

      AcquireMainThread;
      try if not Preferences.ScriptsDisabled then handlers.onLoggedIn(); except end;
      ReleaseMainThread;

      LoginProgressForm.Hide;
    end
    else if sl[0] = 'REGISTRATIONACCEPTED' then
    begin
      AddMainLog(_('Registration successful!'), Colors.Info);
      Status.Registering := False;
      TryToLogin(Preferences.Username, Preferences.Password);
    end
    else if sl[0] = 'REGISTRATIONDENIED' then
    begin
      if sl.Count > 1 then
      begin
        AddMainLog(_('Registration failed: ') + MakeSentenceWS(sl, 1), Colors.Error);
        MessageDlg(_('Registration failed: ') + MakeSentenceWS(sl, 1), mtWarning, [mbOK], 0);
      end
      else
      begin
        AddMainLog(_('Registration failed: Unknown reason'), Colors.Error);
        MessageDlg(_('Registration failed for unknown reason! Try using different username/password, if it still fails then please contact ') + LobbyMailAddress, mtWarning, [mbOK], 0);
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
        AmbiguousCommand(s,'', Colors.Error, 1);
      end
      else
      begin
        AddMainLog(_('Unable to join channel #') + sl[1] + ' (' + MakeSentenceWS(sl, 2) + ')', Colors.Info);
      end;
    end
    else if sl[0] = 'OFFERFILE' then
    begin
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error, 2);
        Exit;
      end;

      sl2 := ParseString(MakeSentenceWS(sl, 2), #9);
      if sl2.Count <> 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error, 3);
        Exit;
      end;

      try
        tmpint := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error, 4);
        Exit;
      end;

      if MessageDlg('Server is offering you a file. This is what server has to say about it:' + #13#13 + sl2[2] + #13#13 + 'Do you wish to accept it?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
      begin // user has accepted the file
        DownloadFile.URL := sl2[1];
        DownloadFile.FileName := sl2[0];
        DownloadFile.ServerOptions := tmpint;
        DownloadFile.HeaderReceived := False;
        TLobbyUpdateThread.Create(False, False, True, 0, False, True );
      end
      else
      begin
        TLobbyUpdateThread.Create(False, False, True );
        if (tmpint and 4) = 4 then
          TryToDisconnect;
      end;
    end
    else if sl[0] = 'UDPSOURCEPORT' then
    begin
      if sl.Count <> 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error, 5);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error, 6);
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
        AmbiguousCommand(s,'', Colors.Error, 7);
        Exit;
      end;

      Client := GetClient(sl[1]);
      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error, 8);
        Exit;
      end;

      try
        Client.PublicPort := StrToInt(sl[3]);
        Client.IP := sl[2];
        if (Client.PublicPort = 0) and (BattleForm.IsBattleActive) then
          BattleForm.AddTextToChat('Warning : '+Client.Name+' doesn''t support NAT Traversal.',Colors.Error,1);
      except
        AmbiguousCommand(s,'', Colors.Error, 9);
        Exit;
      end;
    end
    else if sl[0] = 'HOSTPORT' then
    begin
      if sl.Count <> 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error, 10);
        Exit;
      end;

      if BattleFormUnit.BattleState.Status = None then
      begin
        AmbiguousCommand(s,'', Colors.Error, 11);
        Exit;
      end;

      try
        BattleState.Battle.Port := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error, 12);
        Exit;
      end;
    end
    else if sl[0] = 'ADDUSER' then
    begin
      if (sl.Count < 4) or (sl.Count > 5) then
      begin
        AmbiguousCommand(s,'', Colors.Error, 13);
        Exit;
      end;

      try
        tmpInt64 := StrToInt64Def(sl[3],0);
      except
        AmbiguousCommand(s,'', Colors.Error, 14);
        Exit;
      end;

      try
        if sl.Count = 5 then
          tmpInt2 := StrToInt(sl[4])
        else
          tmpInt2 := -1;
      except
        AmbiguousCommand(s,'', Colors.Error, 15);
        Exit;
      end;

      if sl[1] = '' then
      begin
        AmbiguousCommand(s,'', Colors.Error, 16);
        Exit;
      end;

      if (tmpInt2 > 0) and (GetClientById(tmpInt2) <> nil) then
      begin
        AmbiguousCommand(s,GetClientById(tmpInt2).Name, Colors.Error, 149);
        Exit;
      end;

      if (sl.Count = 4) and (GetClient(sl[1]) <> nil) then
      begin
        AmbiguousCommand(s,'', Colors.Error, 150);
        Exit;
      end;

      AddClientToAllClientsList(sl[1], 0, LowerCase(sl[2]), tmpInt64,tmpInt2); // server will update client's status later
      if sl[1] = Status.Username then Status.Me := GetClient(Status.Username);

      if (lastActiveTab.Caption = LOCAL_TAB) and (not Status.ReceivingLoginInfo) then UpdateClientsListBox;

      Client := GetClient(sl[1]);

      if not Status.ReceivingLoginInfo and (TClient(GetClient(sl[1])).GetGroup <> nil) and TClient(GetClient(sl[1])).GetGroup.NotifyOnConnect then
        AddNotification(_('Player connection'), '<' + Client.DisplayName + _('> has joined the server.'), 2000);



      i := GetTabWindowPageIndex(Client);
      if i <> -1 then
      begin
        if not AddClientToTab(TMyTabSheet(MainForm.ChatTabs[i]).Clients, sl[1]) then ; // nevermind, just ignore it
        if (lastActiveTab.Caption = sl[1]) and (not Status.ReceivingLoginInfo) then UpdateClientsListBox;
      end;

      if (Status.ReceivingLoginInfo) and (Status.LastCommandReceived = 'MOTD') then LoginProgressForm.UpdateCaption(_('Receiving user list ...'));

      if sl[1] = HostBattleForm.relayHosterName then
      begin
        HostBattleForm.relayHosterName := '';
        HostBattleForm.relayHoster := GetClient(sl[1]);
        if HostBattleForm.relayHoster = nil then
        begin
          MessageDlg(_('Couldn''t relay the host : hoster spawned does not exist'),mtWarning,[mbOk],0);
          AddMainLog(_('Couldn''t relay the host : hoster spawned does not exist'),Colors.Error);
        end
        else
        begin
          TryToSendCommand('SAYPRIVATE',sl[1]+' !supportscriptpassword');
          TryToSendCommand('SAYPRIVATE',sl[1]+' '+HostBattleForm.relayHostOpenBattleCmd);
        end;
      end;
    end
    else if sl[0] = 'REMOVEUSER' then
    begin
      if sl.Count <> 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error, 17);
        Exit;
      end;
      { We don't need to manually remove client from channels or battle, since
        server notifies us with "LEFT"/"LEFTBATTLE" commands. However, we must
        manually remove client from a private chat if it is open. }

      Client := GetClient(sl[1]);

      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error, 18);
        Exit;
      end;

      i := GetTabWindowPageIndex(Client);
      if i <> -1 then
      begin
        RemoveClientFromTab(TMyTabSheet(MainForm.ChatTabs[i]), sl[1]);
        AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]),Client.DisplayName+_(' has left the server.'),Colors.ChanLeft,True);
      end;

      if Client.Battle <> nil then
      begin
        AddMainLog(_('Warning: User left the server but is still in a battle !'), Colors.Error);
        ProcessRemoteCommand('LEFTBATTLE '+IntToStr(Client.Battle.ID)+' '+Client.Name);
      end;

      if not RemoveClientFromAllClientsList(sl[1]) then
      begin
        AmbiguousCommand(s,'', Colors.Error, 19);
      end;

      if sl[1] = Status.Username then Status.Me := nil;

      UpdateClientsListBox;
    end
    else if sl[0] = 'ADDBOT' then
    begin
      if sl.Count < 7 then
      begin
        AmbiguousCommand(s,'', Colors.Error, 20);
        Exit;
      end;

      try
        tmpint := StrToInt(sl[1]);
        tmpint2 := StrToInt(sl[4]);
        teamcolor := StrToInt(sl[5]);
      except
        AmbiguousCommand(s,'', Colors.Error, 21);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error, 22);
        Exit;
      end;

      Battle := BattleState.Battle;
      if Battle.ID <> tmpint then
      begin
        AmbiguousCommand(s,'', Colors.Error, 23);
        Exit;
      end;

      if Battle.GetBot(sl[2]) <> nil then
      begin
        AmbiguousCommand(s,'', Colors.Error, 24);
        AddMainLog(_('Disconnecting from battle due to inconsistent data error'), Colors.Error);
        TryToSendCommand('LEAVEBATTLE');
        Exit;
      end;

      Bot := TBot.Create(sl[2], sl[3], MakeSentenceWS(sl, 6));
      Bot.SetBattleStatus(tmpInt2);
      Bot.SetTeamColor(teamcolor);

      Battle.Bots.Add(Bot);
      if Battle.Visible then
        VDTBattles.InvalidateNode(Battle.Node);


      BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,False);
      BattleForm.UpdateClientsListBox;

      BattleForm.StartButton.Enabled := BattleForm.isBattleReadyToStart;
    end
    else if sl[0] = 'REMOVEBOT' then
    begin

      if sl.Count <> 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,25);
        Exit;
      end;

      try
        tmpint := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error,26);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,27);
        Exit;
      end;

      Battle := BattleState.Battle;
      if Battle.ID <> tmpint then
      begin
        AmbiguousCommand(s,'', Colors.Error,28);
        Exit;
      end;

      Bot := GetBot(sl[2], Battle);
      if Bot = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,29);
        Exit;
      end;

      Bot.Free;
      Battle.Bots.Remove(Bot);
      if Battle.Visible then
        VDTBattles.InvalidateNode(Battle.Node);

      BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
      BattleForm.UpdateClientsListBox;

      BattleForm.StartButton.Enabled := BattleForm.isBattleReadyToStart;

    end
    else if sl[0] = 'UPDATEBOT' then
    begin
      if sl.Count <> 5 then
      begin
        AmbiguousCommand(s,'', Colors.Error,30);
        Exit;
      end;

      try
        tmpint2 := StrToInt(sl[1]);
        tmpint := StrToInt(sl[3]);
        teamcolor := StrToInt(sl[4]);
      except
        AmbiguousCommand(s,'', Colors.Error,31);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,32);
        Exit;
      end;

      if not (BattleState.Battle.ID = tmpInt2) then Exit;

      Battle := BattleState.Battle;

      if Battle.ID <> tmpint2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,33);
        AddMainLog(_('Disconnecting from battle due to inconsistent data error'), Colors.Error);
        TryToSendCommand('LEAVEBATTLE');
        Exit;
      end;

      Bot := GetBot(sl[2], Battle);
      if Bot = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,34);
        Exit;
      end;

      Bot.SetBattleStatus(tmpInt);
      Bot.SetTeamColor(teamcolor);

      BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
      BattleForm.UpdateClientsListBox;
    end
    else if sl[0] = 'ADDSTARTRECT' then
    begin
      if sl.Count <> 6 then
      begin
        AmbiguousCommand(s,'', Colors.Error,35);
        Exit;
      end;

      if HostBattleForm.relayHoster <> nil then Exit;

      try
        index := StrToInt(sl[1]);
        Rect.Left := Round(StrToInt(sl[2])/2);
        Rect.Top := Round(StrToInt(sl[3])/2);
        Rect.Right := Round(StrToInt(sl[4])/2);
        Rect.Bottom := Round(StrToInt(sl[5])/2);
      except
        AmbiguousCommand(s,'', Colors.Error,36);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,37);
        Exit;
      end;

      if (BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil) then
      begin
        // this could happen due to lag (we could get this command from our previous battle, where we didn't host)
        AmbiguousCommand(s,'', Colors.Error,38);
        Exit;
      end;

      Battle := BattleState.Battle;

      if (index < 0) or (index > High(BattleState.StartRects)) then
      begin
        AmbiguousCommand(s,'', Colors.Error,39);
        Exit;
      end;

      if BattleState.StartRects[index].Enabled then
      begin
        // this is a pretty serious error. It should not happen though. Client will have different start rects than other clients.
        AmbiguousCommand(s,'', Colors.Error,40);
        Exit;
      end;

      BattleForm.AddStartRect(index, rect);
    end
    else if sl[0] = 'REMOVESTARTRECT' then
    begin
      if sl.Count <> 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,41);
        Exit;
      end;

      try
        index := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error,42);
        Exit;
      end;

      if HostBattleForm.relayHoster <> nil then Exit;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,43);
        Exit;
      end;

      if (BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil) then
      begin
        // this could happen due to lag (we could get this command from our previous battle, where we didn't host)
        AmbiguousCommand(s,'', Colors.Error,44);
        Exit;
      end;

      Battle := BattleState.Battle;

      if (index < 0) or (index > High(BattleState.StartRects)) then
      begin
        AmbiguousCommand(s,'', Colors.Error,45);
        Exit;
      end;

      if not BattleState.StartRects[index].Enabled then
      begin
        // this is a pretty serious error. It should not happen though. Client will have different start rects than other clients.
        AmbiguousCommand(s,'', Colors.Error,46);
        Exit;
      end;

      BattleForm.RemoveStartRect(index);
    end
    else if sl[0] = 'JOIN' then
    begin
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,47);
      end
      else
      begin
        if IgnoreNextTASClientChanJoin and (sl[1] = 'tasclient') then
        begin
          IgnoreNextTASClientChanJoin := False;
          IgnoreTASClientChanMsgs := True;
          TryToSendCommand('SAYEX', 'tasclient is using TASClient '+VERSION_NUMBER+' rev '+IntToStr(Misc.GetLobbyRevision)+' on '+GetWinVersion+'. Scripts='+BooleanToStr(not Preferences.ScriptsDisabled)+' News='+BooleanToStr(not Preferences.DisableNews)+' AutohostGUI='+BooleanToStr(Preferences.DisplayAutohostInterface)+' Skin='+IFF(Preferences.ThemeType=sknSkin,IFF(MidStr(Preferences.Theme,2,2)=':\','Custom',Preferences.Theme),'Windows')+IFF(Debug.Crashed,' Crashed',''));
          Debug.Crashed := False; // do not send crash info twice if the user is disconnected
          TryToSendCommand('LEAVE', 'tasclient');
          if AutoJoinTASClient then
          begin
            ProcessCommand('JOIN #tasclient',false);
            AutoJoinTASClient := False;
          end;
          Exit;
        end;
        if not IgnoreNextTASClientChanJoin and (sl[1] = 'tasclient') then
        begin
          IgnoreTASClientChanMsgs := False;
        end;
        if Preferences.AutoSaveChanSession then
          PerformForm.addAutoJoinChannel(sl[1]);
        if PerformForm.isChannelAutoJoined(sl[1]) then
          Dec(NbAutoJoinChannels);
        i := GetTabWindowPageIndex('#' + sl[1]);
        if i = -1 then
        begin
          ChatTabs.Add(AddTabWindow('#' + sl[1], SwitchToNewChatRoom));
          i := ChatTabs.Count-1;
          if (NbAutoJoinChannels = 0) and mnuReloadViewLogin.Checked then
          begin
            DockHandler.LoadDesktop(TASCLIENT_REGISTRY_KEY+'\Layout',PreferencesForm.LayoutDefault.Text);
            MainForm.MainPCH.PageControl.Style := TTabStyle(Preferences.TabStyle);
            for j:=1 to ChatTabs.Count-1 do
            begin
              if not TMyTabSheet(ChatTabs[j]).Visible then
              begin
                TMyTabSheet(ChatTabs[j]).ManualDock(MainPCH.PageControl);
                TMyTabSheet(ChatTabs[j]).Visible := True;
              end;
              TMyTabSheet(ChatTabs[j]).ScrollRichEditToBottom;
            end;
            TMyTabSheet(ChatTabs[0]).ScrollRichEditToBottom;
            mnuLockViewClick(nil);

            // glitch fix for window skin
            ClientListOptionsPanel.InvalidateBackground(False);
            PlayersInfoPanel.InvalidateBackground(False);
            PlayerFiltersPanel.InvalidateBackground(False);
          end;
        end;
        AddTextToChatWindow(TMyTabSheet(ChatTabs[i]), _('* Now talking in ') + TMyTabSheet(ChatTabs[i]).Caption, Colors.ChanJoin,True);
      end;
    end
    else if sl[0] = 'CLIENTS' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,48);
        Exit;
      end;

      if IgnoreTASClientChanMsgs and (sl[1] = 'tasclient') then Exit;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,49);
        Exit;
      end;

      for j := 2 to sl.Count-1 do
        if not AddClientToTab(TMyTabSheet(MainForm.ChatTabs[i]).Clients, sl[j]) then
        begin
          AmbiguousCommand(s,sl[j], Colors.Error,50);
          //Exit;
        end;

      UpdateClientsListBox;
    end
    else if sl[0] = 'CHANNEL' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,51);
        Exit;
      end;

      tmp2 := sl[2]; // number of users in the channel
      if sl.Count > 3 then
        tmp := MakeSentenceWS(sl, 3)
      else
        tmp := '';
  
      ChannelsListForm.AddChannel(sl[1],tmp,StrToInt(tmp2));
      //AddMainLog('+ ' + '#' + sl[1] + EnumerateSpaces(Max(0, 20-Length(sl[1])-Length(tmp2))) + tmp2 + tmp, Colors.Normal);
    end
    else if sl[0] = 'ENDOFCHANNELS' then
    begin
      //AddMainLog(_('-- END OF CHANNEL LIST --'), Colors.Normal);
      ChannelsListForm.isRetreiving := False;
      ShowAndSetFocus(ChannelsListForm.VDTChannels);
    end
    else if sl[0] = 'JOINED' then
    begin
      if sl.Count <> 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,52);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,53);
        Exit;
      end;

      if not AddClientToTab(TMyTabSheet(MainForm.ChatTabs[i]).Clients, sl[2]) then
      begin
        AmbiguousCommand(s,'', Colors.Error,144);
        Exit;
      end;

      if not Preferences.FilterJoinLeftMessages then
        AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), '* ' + sl[2] + _(' has joined ') + TMyTabSheet(MainForm.ChatTabs[i]).Caption, Colors.ChanJoin,true);

      if NotificationsForm.FindNotification(nfJoinedChannel, [sl[2], '#' + sl[1]]) then AddNotification(_('Player joined'), '<' + sl[2] + _('> has joined ') + TMyTabSheet(MainForm.ChatTabs[i]).Caption, 2000);

      UpdateClientsListBox;
    end
    else if sl[0] = 'LEFT' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,54);
        Exit;
      end;

      Client := GetClient(sl[2]);

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,55);
        Exit;
      end;

      if not RemoveClientFromTab(TMyTabSheet(MainForm.ChatTabs[i]), sl[2]) then
      begin
        AmbiguousCommand(s,'', Colors.Error,56);
        Exit;
      end;

      if not Preferences.FilterJoinLeftMessages then
      begin
        tmp := '';
        if sl.Count > 3 then tmp := ' (' + MakeSentenceWS(sl, 3) + ')';
        AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), '* ' + Client.DisplayName + _(' has left ') + TMyTabSheet(MainForm.ChatTabs[i]).Caption + tmp, Colors.ChanLeft, true);
      end;

      UpdateClientsListBox;
    end
    else if sl[0] = 'FORCELEAVECHANNEL' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,57);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,58);
        Exit;
      end;

      if sl.Count = 3 then tmp := '' else tmp := ' (' + MakeSentenceWS(sl, 3) + ')';
      AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), _('* You have been kicked from #') + sl[1] + _(' by <') + sl[2] + '>' + tmp, Colors.Info);
      TMyTabSheet(MainForm.ChatTabs[i]).Clients.Clear;

      UpdateClientsListBox;
    end
    else if sl[0] = 'CHANNELTOPIC' then
    begin
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,590);
        Exit;
      end;

      if IgnoreTASClientChanMsgs and (sl[1] = 'tasclient') then Exit;

      if sl.Count < 5 then
      begin
        AmbiguousCommand(s,'', Colors.Error,59);
        Exit;
      end;

      try
        tmpi64 := StrToInt64(sl[3]);
        tmp := FormatDateTime('mmm d "'+_('at')+'" hh:mm AM/PM', UTCTimeToLocalTime(UnixToDateTime(tmpi64 div 1000)));
      except
        AmbiguousCommand(s,'', Colors.Error,60);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,61);
        Exit;
      end;
      tmp2 := MakeSentenceWS(sl, 4);

      sl2 := TWideStringList.Create;
      Misc.ParseDelimited(sl2,tmp2,'\n','');

      if sl2.Count = 1 then
        AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), _('* Topic is ''') + tmp2 + '''', Colors.Topic,True)
      else
      begin
        AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), _('* Topic is ''') + sl2[0], Colors.Topic,True);
        for j:=1 to sl2.Count-1 do
          if j=sl2.Count-1 then
            AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), sl2[j] + '''', Colors.Topic,True)
          else
            AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), sl2[j], Colors.Topic,True);
      end;
      AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), _('* Set by ') + sl[2] + _(' on ') + tmp, Colors.Topic,True);
    end
    else if sl[0] = 'SAID' then
    begin
      if sl.Count < 4 then
      begin
        AmbiguousCommand(s,'', Colors.Error,62);
        Exit;
      end;

      if IgnoreTASClientChanMsgs and (sl[1] = 'tasclient') then Exit;

      Client := GetClient(sl[2]);

      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,152);
        Exit;
      end;

      // are we ignoring this user?
      if Preferences.UseIgnoreList then
        if Client.IsIgnored then Exit; // don't display the message

      // are we ignoring the group?
      tmpClientGroup := Client.GetGroup;
      if (tmpClientGroup <> nil) and tmpClientGroup.Ignore then
          Exit; // don't display the message

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,63);
        Exit;
      end;

      Client := GetClient(sl[2]);

      AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), '<' + Client.DisplayName + '> ' + MakeSentenceWS(sl, 3), Client.GetChatTextColor, Length(sl[2])+2);
    end
    else if sl[0] = 'CHANNELMESSAGE' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,64);
        Exit;
      end;

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,145);
        Exit;
      end;

      AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), _('* Channel message: ') + MakeSentenceWS(sl, 2), Colors.Info,True);
    end
    else if sl[0] = 'SAIDEX' then
    begin
      if sl.Count < 4 then
      begin
        AmbiguousCommand(s,'', Colors.Error,65);
        Exit;
      end;

      if IgnoreTASClientChanMsgs and (sl[1] = 'tasclient') then Exit;

      Client := GetClient(sl[2]);

      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,153);
        Exit;
      end;

      // are we ignoring this user?
      if Preferences.UseIgnoreList then
        if Client.isIgnored then Exit; // don't display the message

      // are we ignoring the group?
      tmpClientGroup := Client.GetGroup;
      if (tmpClientGroup <> nil) and tmpClientGroup.Ignore then
          Exit; // don't display the message

      i := GetTabWindowPageIndex('#' + sl[1]);
      if i = -1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,66);
        Exit;
      end;

      AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), '* ' + Client.DisplayName + ' ' + MakeSentenceWS(sl, 3), Colors.SayEx);
    end
    else if sl[0] = 'SAIDDATAPRIVATE' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,400);
        Exit;
      end;

      if sl[1] = '' then
      begin
        AmbiguousCommand(s,'', Colors.Error,401);
        Exit;
      end;

      Client := GetClient(sl[1]);

      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,402);
        Exit;
      end;

      // not supported by the server yet
    end
    else if sl[0] = 'SAIDPRIVATE' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,67);
        Exit;
      end;

      if sl[1] = '' then
      begin
        AmbiguousCommand(s,'', Colors.Error,68);
        Exit;
      end;

      if sl[1] = HostBattleForm.relayHostManagerName then
      begin
        HostBattleForm.relayHosterName := '';
        HostBattleForm.relayHostManagerName := '';
        if sl[2] = #1 then
        begin
          MessageDlg(_('Couldn''t relay the host : ')+MakeSentenceWS(sl,3),mtError,[mbOk],0);
          AddMainLog(_('Couldn''t relay the host : ')+MakeSentenceWS(sl,3),Colors.Error);
          Exit;
        end
        else
        begin
          HostBattleForm.relayHosterName := sl[2];
          Exit;
        end;
      end;
      if sl[1] = RELAYHOST_MANAGER_NAME then
      begin
        if sl[2] = 'managerlist' then
        begin
          sl2 := TWideStringList.Create;
          HostBattleForm.relayHostManagerList.Clear;
          ParseDelimited(sl2,sl[3],#9,'');
          HostBattleForm.cmbRelayList.Clear;
          for i:=0 to sl2.Count-1 do
          begin
            client := GetClient(sl2[i]);
            if (client <> nil) and not Client.GetInGameStatus and not Client.GetAwayStatus then
            begin
              HostBattleForm.relayHostManagerList.Add(client);
              HostBattleForm.cmbRelayList.Items.Add(''); // owner draw list
            end;
          end;

          if HostBattleForm.relayHostManagerList.Count > 0 then
          begin
            Randomize;

            HostBattleForm.cmbRelayList.ItemIndex := RandomRange(0,HostBattleForm.relayHostManagerList.Count);
          end
          else
          begin
            // display a msg
            HostBattleForm.cmbRelayList.Items.Add('');
            HostBattleForm.cmbRelayList.ItemIndex := 0;   
          end;

          HostBattleForm.btRefreshRelayManagersList.Enabled := True;
          HostBattleForm.cmbRelayList.Enabled := True;
          HostBattleForm.checkBattleReadyToBeHosted;

          Exit;
        end;
      end;

      Client := GetClient(sl[1]);

      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,154);
        Exit;
      end;

      if (sl[2] = REMOTE_JOIN_COMMAND) and (Client.GetAccess or ((Client.GetGroup <> nil) and (Client.GetGroup.ExecuteSpecialCommands))) and (sl.Count >= 4) and (sl.Count <= 5) then
      begin
        Client2 := GetClient(sl[3]);
        if (Client2 <> nil) and (Client2.Battle <> nil) then
        begin
          if not Client2.Battle.Password or (sl.Count >= 5) then
          begin
            try
              AddMainLog(Format(_('Executing !join command from user : %s'),[Client.Name]),Colors.Info);
            except
              AddMainLog(Format('Executing !join command from user : %s',[Client.Name]),Colors.Info);
            end;

            if BattleForm.IsBattleActive then
            begin
              BattleForm.DisconnectButtonClick(nil);
            end;

            if Client2.Battle.Password and (sl.Count >= 5) then
              JoinBattle(Client2.Battle,false,sl[4])
            else
              JoinBattle(Client2.Battle);

            Exit;
          end;
        end;
      end;

      if (Client = HostBattleForm.relayHoster) and (sl[2] = 'JOINEDBATTLE') then
      begin
        Client2 := GetClient(sl[4]);
        if (Client2 <> nil) then
        begin
          Client2.BattleJoinPassword := '';
          if (sl.Count >= 6) then
          begin
            Client2.BattleJoinPassword := sl[5];
             if HostBattleForm.relayHoster.GetInGameStatus  then
            begin
              TryToSendCommand('SAYPRIVATE',HostBattleForm.relayHoster.Name+' #/adduser '+Client2.Name+' '+Client2.BattleJoinPassword);
            end;
          end;
          Exit;
        end;
      end;

      // are we ignoring this user?
      if Preferences.UseIgnoreList then
        if Client.isIgnored then
          Exit; // don't display the message

      // are we ignoring the group?
      tmpClientGroup := Client.GetGroup;
      if (tmpClientGroup <> nil) and tmpClientGroup.Ignore then
          Exit; // don't display the message

      i := GetTabWindowPageIndex(Client);
      if i = -1 then
      begin
        ChatTabs.Add(AddTabWindow(Client.DisplayName, Preferences.AutoFocusOnPM,Client.Id));
        i := ChatTabs.Count-1;
        if not AddClientToTab(TMyTabSheet(MainForm.ChatTabs[i]).Clients, sl[1]) then
        begin
          AmbiguousCommand(s,'', Colors.Error,69);
          Exit;
        end;
        UpdateClientsListBox;
      end;

      AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), '<' + Client.DisplayName + '> ' + MakeSentenceWS(sl, 2), Colors.Normal, Length(sl[1])+2,False,False);

      // auto replay away message
      Client := GetClient(sl[1]);
      if not Client.AwayMessageSent and Status.Me.GetAwayStatus then begin
        TryToSendCommand('SAYPRIVATE', sl[1] + ' <AUTO-REPLY> : ' + StringReplace(Status.CurrentAwayMessage,'$t',IntToStr(Round((GetTickCount-Status.AwayTime)/60000)),[rfReplaceAll]));
        Client.AwayMessageSent := True;
      end;

      // add notification if private message:
      if (NotificationsForm.CheckBox1.Checked) and ((lastActiveTab <> MainForm.ChatTabs[i]) or not GetControlForm(TMyTabSheet(ChatTabs[i])).Active or (Screen.ActiveForm.Handle <> GetForegroundWindow)) then AddNotification(_('Private message'), '<' + Client.DisplayName + '> ' + MakeSentenceWS(sl, 2), 2500);
    end
    else if sl[0] = 'SAYPRIVATE' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,70);
        Exit;
      end;

      Client := GetClient(sl[1]);

      if (HostBattleForm.relayHoster <> nil) and (sl[1] = HostBattleForm.relayHoster.Name) then
        Exit;
      if sl[1] = HostBattleForm.relayHostManagerName then
        Exit;
      if (sl[1] = RELAYHOST_MANAGER_NAME) and (sl[2] = '!listmanagers') then Exit;

      i := GetTabWindowPageIndex(Client);
      if i = -1 then
      begin
        ChatTabs.Add(AddTabWindow(Client.DisplayName, Preferences.AutoFocusOnPM, Client.Id));
        i := ChatTabs.Count-1;
        if not AddClientToTab(TMyTabSheet(MainForm.ChatTabs[i]).Clients, sl[1]) then
        begin
          AmbiguousCommand(s,'', Colors.Error,71);
          Exit;
        end;
        UpdateClientsListBox;
      end;

      if TMyTabSheet(MainForm.ChatTabs[i]).Clients[0] = Client then // avoid multiple pm feedback when having multiple users in one PM chat because of renames
        AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), '<' + Status.Username + '> ' + MakeSentenceWS(sl, 2), Colors.MyText, Length(Status.Username)+2);
    end
    else if sl[0] = 'SAYDATAPRIVATE' then
    begin
      // nothing
    end
    else if sl[0] = 'FORCEJOINBATTLE' then
    begin
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,350);
        Exit;
      end;
      try
        tmpInt := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error,351);
        Exit;
      end;
      Battle := GetBattle(tmpInt);
      if Battle = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,352);
        Exit;
      end;

      if sl.Count >= 2 then
      begin
        JoinBattle(Battle,False,sl[2]);
      end
      else
      begin
        JoinBattle(Battle);
      end;
    end
    else if sl[0] = 'PONG' then
    begin
      if MsgID <> -1 then
        for i := 0 to Pings.Count-1 do if PPingInfo(Pings[i]).Key = MsgID then
        begin
          AddMainLog(_('Ping reply took ') + IntToStr(GetTickCount - PPingInfo(Pings[i]).TimeSent) + _(' ms.'), Colors.Info);
          Pings.Delete(i);
          Break;
        end;
    end
    else if sl[0] = 'SAIDBATTLE' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,72);
        Exit;
      end;

      Client := GetClient(sl[1]);

      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,155);
        Exit;
      end;

      // are we ignoring this user?
      if Preferences.UseIgnoreList then
        if Client.isIgnored then Exit; // don't display the message

      // are we ignoring the group?
      tmpClientGroup := Client.GetGroup;
      if (tmpClientGroup <> nil) and tmpClientGroup.Ignore then
          Exit; // don't display the message

      tmp := MakeSentenceWS(sl, 2);
      tmp2 := '<' + Client.DisplayName + '> ' + tmp;
      tmpStr := tmp2;
      BattleForm.AddTextToChat( tmp2, Client.GetChatTextColor, Length(sl[1])+2);
      if (BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil) and Status.Me.GetInGameStatus and BattleState.SpringComAddrAcquired then
      begin
        tmpInt := BattleState.SpringChatMsgsBeingRelayed.IndexOf(tmp);
        if tmpInt = -1 then
          MainForm.SpringSocket.SendBuffer(BattleState.SpringComAddr,BattleState.SpringComPort,tmpStr[1],Length(tmpStr))
        else
          BattleState.SpringChatMsgsBeingRelayed.Delete(tmpInt);
      end;
    end
    else if sl[0] = 'SAIDBATTLEEX' then
    begin
      if sl.Count < 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,73);
        Exit;
      end;

      Client := GetClient(sl[1]);

      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,156);
        Exit;
      end;

      // are we ignoring this user?
      if Preferences.UseIgnoreList then
        if Client.isIgnored then Exit; // don't display the message

      // are we ignoring the group?
      tmpClientGroup := Client.GetGroup;
      if (tmpClientGroup <> nil) and tmpClientGroup.Ignore then
          Exit; // don't display the message

      tmp := MakeSentenceWS(sl, 2);

      if Preferences.DisplayAutohostInterface and (TClient(BattleState.Battle.Clients[0]).Name = sl[1]) then
      begin
        tmpBool := BattleForm.ChatRichEdit.atBottom;
        tmpBool2 := False;
        if (not BattleState.AutoHost) then
        if Pos('spads',LowerCase(tmp)) > 0 then
        begin
          tmpBool2 := True;
          BattleState.AutoHost := True;
          BattleState.AutoHostType := 0;
          BattleForm.AutoHostInfoPanel.Visible := True;
          //BattleForm.AutoHostInfoMsgs.Clear;
          BattleForm.AutoHostMsgsRichEdit.Clear;
          BattleForm.AutoHostCommandsButton.DropDownMenu := BattleForm.SPADSPopupMenu;
          BattleForm.AutoHostControlLabel.Caption := _('Autohost - ')+'SPADS';
        end
        else if Pos('springie',LowerCase(tmp)) > 0 then
        begin
          tmpBool2 := True;
          BattleState.AutoHost := True;
          BattleState.AutoHostType := 1;
          BattleForm.AutoHostInfoPanel.Visible := True;
          //BattleForm.AutoHostInfoMsgs.Clear;
          BattleForm.AutoHostMsgsRichEdit.Clear;
          BattleForm.AutoHostCommandsButton.DropDownMenu := BattleForm.SPRINGIEPopupMenu;
          BattleForm.AutoHostControlLabel.Caption := _('Autohost - ')+'Springie';
        end;

        if BattleState.AutoHost then
        begin
          if ((BattleState.AutoHostType = 0) and (Pos(' called a vote for command "',tmp) > 0) and (LeftStr(tmp,2+Length(Status.Me.Name)) <> '* '+Status.Me.Name)) or
             ((BattleState.AutoHostType = 1) and (Pos('? [!y=0/8, !n=0/8]',tmp) > 0)) then
          begin
            tmpBool2 := True;
            case BattleState.AutoHostType of
              0: BattleForm.AutoHostVoteMsg.Caption := MidStr(StringReplace(StringReplace(tmp,' called a vote for command',' : ',[rfReplaceAll]),'[!vote y, !vote n, !vote b]','',[rfReplaceAll]),3,9999)+' ?';
              1: BattleForm.AutoHostVoteMsg.Caption := StringReplace(tmp,'!vote 1 = yes, !vote 2 = no',' : ',[rfReplaceAll]);
            end;
            BattleForm.AutoHostVotePanel.Visible := True;
            BattleForm.AutoHostVoteIcon.Tag := 8;
          end
          else
          begin
            if (Pos('Vote cancelled',tmp) > 0) or (Pos('Vote for command "',tmp) > 0) or (Pos('vote successful',tmp) > 0) or (Pos('not enough votes',tmp) > 0) or (Pos('Game starting, cancelling',tmp) > 0) then
              BattleForm.AutoHostVotePanel.Visible := False;
            //BattleForm.AutoHostInfoMsgs.Items.Add(tmp);
            BattleForm.AddTextToChat(tmp, Colors.Normal, 1,True);
            
            {*if BattleForm.AutoHostInfoMsgs.Tag = BattleForm.AutoHostInfoMsgs.Count-2 then
              BattleForm.AutoHostInfoMsgs.ItemIndex := BattleForm.AutoHostInfoMsgs.Count-1;*}
            BattleForm.AutoHostInfoIcon.Tag := 8;
          end;
        end
        else
          BattleForm.AutoHostInfoPanel.Visible := False;
        if tmpBool2 then
        begin
          BattleForm.AutohostControlSplitter.Visible := BattleForm.AutoHostInfoPanel.Visible;
          BattleForm.AutohostControlSplitter.Align := alBottom;
          BattleForm.AutohostControlSplitter.Align := alTop;
          BattleForm.AutoHostVotePanel.Align := alBottom;
          BattleForm.AutoHostVotePanel.Align := alTop;
          BattleForm.Refresh;
          if tmpBool then
          begin
            BattleForm.ChatRichEdit.ScrollToTop;
            BattleForm.ChatRichEdit.ScrollToBottom;
          end;
        end;
        if BattleState.AutoHost and BattleForm.mnuHideAutoHostMsgs.Checked then Exit;
      end;

      BattleForm.AddTextToChat('* ' + Client.DisplayName + ' ' + tmp, Colors.SayEx, 1);
    end
    else if sl[0] = 'REQUESTBATTLESTATUS' then
    begin
      if sl.Count <> 1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,74);
        Exit;
      end;

      if not BattleForm.FigureOutBestPossibleTeamAllyAndColor(True, team, ally, color) then
      begin
        BattleForm.SetMyBattleStatus(0, False, 0, 0, IFF(JoinAsSpectator,0,1)); // this probably shouldn't of happen though
        MyTeamColorIndex := 0;
      end
      else
      begin
        BattleForm.SetMyBattleStatus(BattleForm.MySideButton.Tag, False, team, ally, IFF(JoinAsSpectator,0,1));
        MyTeamColorIndex := color;   //-> not needed anymore, we should keep last used color anyway
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
      if (sl.Count <> 3) then
      begin
        AmbiguousCommand(s,'', Colors.Error,146);
        Exit;
      end;

      if BattleForm.IsBattleActive then // we are already in battle! (this can't really happen)
      begin
        AmbiguousCommand(s,'', Colors.Error,75);
        MainForm.TryToSendCommand('LEAVEBATTLE');
        BattleForm.ResetBattleScreen;
        BattleState.Status := None;
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
        t := StrToInt(sl[2]);

      except
        AmbiguousCommand(s,'', Colors.Error,76);
        Exit;
      end;

      Battle := GetBattle(i);
      if Battle = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,77);
        Exit;
      end;

      BattleState.JoiningBattle := False;

      tmpBool := False;
      Misc.ShowAndSetFocus(BattleForm.InputEdit);

      if (HostBattleForm.relayHoster <> nil) and (TClient(Battle.Clients[0]) = HostBattleForm.relayHoster) then
      begin
        BattleState.JoiningComplete := False;
        if Battle.BattleType = 0 then
          tmpBool := BattleForm.HostBattle(i)
        else
          tmpBool := BattleForm.HostBattleReplay(i);
      end
      else
      begin
        if Battle.BattleType = 0 then
          tmpBool := BattleForm.JoinBattle(i)
        else
          tmpBool := BattleForm.JoinBattleReplay(i);
      end;

      if tmpBool then
      begin
        if (HostBattleForm.relayHoster = nil) then
        begin
          Status.BattleStatusRequestReceived := False;
          Status.BattleStatusRequestSent := False;
        end;

        // update battle parameters:
        Battle.HashCode := t;

        // we have to change mod before hashing it:
        Status.Hashing := True; // we need this so that we know we must wait for hashing to finish when we receive REQUESTBATTLESTATUS command (we can receive it in "parallel", while hashing!)
        InitWaitForm.ChangeCaption(MSG_MODCHANGE);
        InitWaitForm.TakeAction := 0; // change mod
        InitWaitForm.ChangeToMod := Battle.ModName;
        InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)

        if Preferences.DisplayUnitsIconsAndNames or (HostBattleForm.relayHoster <> nil) then
        begin
          // now let's update units:
          InitWaitForm.ChangeCaption(MSG_GETUNITS);
          InitWaitForm.TakeAction := 1; // load unit lists
          InitWaitForm.ShowModal; // this loads unit lists (see OnFormActivate event)
          if HostBattleForm.relayHoster <> nil then
            DisableUnitsForm.PopulateUnitList;
        end;

        BattleForm.CheckBattleSync;

        Status.Hashing := False;

        if Status.BattleStatusRequestReceived and not Status.BattleStatusRequestSent then
        begin
          BattleForm.SendMyBattleStatusToServer;
          Status.BattleStatusRequestSent := True;
        end; // else the method which will receive the request will also send the battle status

        BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
        BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);

        BattleState.JoiningComplete := True;
        if (HostBattleForm.relayHoster <> nil) and (TClient(Battle.Clients[0]) = HostBattleForm.relayHoster) then
        begin
          BattleForm.SendLuaOptionsDetailsToServer;
          BattleForm.SendBattleDetailsToServer;
        end;
      end
      else MainForm.AddMainLog(_('Error: unable to join battle.'), Colors.Error);

    end
    else if sl[0] = 'JOINBATTLEFAILED' then
    begin
      BattleState.JoiningBattle := False;
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,78);
        Exit;
      end;
      AddMainLog(_('Failed to join the battle (Reason: ') + MakeSentenceWS(sl, 1) + ')', Colors.Error);
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
        AmbiguousCommand(s,'', Colors.Error,79);
        Exit;
      end;

      sl2 := ParseString(MakeSentenceWS(sl, 11), #9);

      if sl2.Count <> 5 then
      begin
        AmbiguousCommand(s,'', Colors.Error,80);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error,81);
        Exit;
      end;

      try
        battletype := StrToInt(sl[2]);
      except
        AmbiguousCommand(s,'', Colors.Error,82);
        Exit;
      end;

      try
        nattype := StrToInt(sl[3]);
        if (nattype < 0) or (nattype > 2) then raise Exception.CreateFmt(_('Invalid NAT traversal method index'), []);
      except
        AmbiguousCommand(s,'', Colors.Error,83);
        Exit;
      end;

      Client := GetClient(sl[4]);
      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,84);
        Exit;
      end;

      if GetBattle(i) <> nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,148);
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
        AmbiguousCommand(s,'', Colors.Error,85);
        Exit;
      end;
      Battle := AddBattle(i, battletype, nattype, Client, tmp, j, k, tmpBool, l, maphash, sl2[2], sl2[3], sl2[4], sl2[0], sl2[1]);
      SortBattleInList(GetBattleIndex(i), Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0);
      if not Status.ReceivingLoginInfo then VDTBattles.Invalidate;

      Client.InBattle := True;
      if (not Application.Active) or (not BattleForm.Active) then if NotificationsForm.FindNotification(nfStatusInBattle, [Client.Name]) then AddNotification('Player opened new battle', '<' + Client.Name + '> is hosting new game.', 2000);

      if (Status.ReceivingLoginInfo = False) and (Client.Name <> Status.Username) then if
        NotificationsForm.FindNotification(nfModHosted, [Battle.ModName]) then AddNotification(_('Mod hosted'), _('Mod <') + Battle.ModName + _('> has been hosted by ') + TClient(Battle.Clients[0]).DisplayName +'.', 2000);

      if not Status.ReceivingLoginInfo then UpdateClientsListBox;

      if not Status.ReceivingLoginInfo and (Client.GetGroup <> nil) and Client.GetGroup.NotifyOnHost then
      begin
        AddNotification(_('Player host'), '<' + Client.DisplayName + _('> is hosting a new battle.'), 5000,true,Battle.ID);
      end;

      if (Status.ReceivingLoginInfo) and (Status.LastCommandReceived = 'ADDUSER') then LoginProgressForm.UpdateCaption(_('Receiving battle list ...'));

      if Client = HostBattleForm.relayHoster then
      begin
        JoinBattle(Battle,false,HostBattleForm.relayHostPassword);
      end;
    end
    else if sl[0] = 'BATTLECLOSED' then
    begin
      if sl.Count <> 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,86);
        Exit;
      end;

      try
        BattleIndex := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error,87);
        Exit;
      end;

      Battle := GetBattle(BattleIndex);
      if Battle = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,88);
        Exit;
      end;

      for i := 0 to Battle.Clients.Count-1 do
      begin
        TClient(Battle.Clients[i]).InBattle := False;
        TClient(Battle.Clients[i]).Battle := nil;
      end;

      UpdateClientsListBox;
      if selectedBattlePlayers = Battle then
      begin
        BattlePlayersListBox.Clear;
        selectedBattlePlayers := nil;
        BattlePlayersListBox.Invalidate;
      end;

      if (BattleForm.IsBattleActive) and (BattleState.Battle.ID = Battle.ID) then
      begin
        BattleForm.ResetBattleScreen;
        BattleState.Status := None;
      end;

      RemoveBattle(BattleIndex);
    end
    else if sl[0] = 'OPENBATTLE' then
    begin
      if (not WaitForAckForm.Visible) or (not WaitForAckForm.Waiting) then // we are not hosting a battle! This is an error. We must tell the server to cancel this battle. (Note: this should not happen normally. Perhaps only if server lags really badly)
      begin
        AmbiguousCommand(s,'', Colors.Error,89);
        TryToSendCommand('LEAVEBATTLE');
        Exit;
      end;

      if sl.Count <> 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,90);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error,91);
        Exit;
      end;

      Battle := GetBattle(i);
      if Battle = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,92);
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
      WaitForAckForm.Close;
      BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
      BattleForm.SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);

      BattleState.JoiningComplete := True;
      BattleForm.SendBattleDetailsToServer;
      BattleForm.SendLuaOptionsDetailsToServer;

      if Battle.BattleType = 1 then
      begin
        Misc.ShowAndSetFocus(BattleForm.InputEdit);
        BattleForm.SendReplayScriptToServer;
      end;
    end
    else if sl[0] = 'JOINBATTLEREQUEST' then
    begin
      if sl.Count <> 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,93);
        Exit;
      end;
      Client := GetClient(sl[1]);
      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,94);
        Exit;
      end;
      Client.IP := sl[2];
      if ((Client.GetGroup <> nil) and (Client.GetGroup.AutoKick)) or (BattleState.BanList.IndexOf(Client.Id) > -1) then
        TryToSendCommand('JOINBATTLEDENY',Client.Name + #9 + 'Banned group Member')
      else
        TryToSendCommand('JOINBATTLEACCEPT',Client.Name);
    end
    else if sl[0] = 'JOINEDBATTLE' then
    begin
      if (sl.Count <> 3) and ((sl.Count <> 4) or ((sl[3] <> Status.Me.BattleJoinPassword) and (BattleState.Status = Joined))) then
      begin
        AmbiguousCommand(s,'', Colors.Error,95);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error,96);
        Exit;
      end;

      Battle := GetBattle(i);
      if Battle = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,97);
        Exit;
      end;

      Client := GetClient(sl[2]);
      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,98);
        Exit;
      end;

      if Client.Battle <> nil then
      begin
        AmbiguousCommand(s,'', Colors.Error, 151);
        Exit;
      end;

      if (Status.Me <> Client) and (sl.Count >= 4) then
      begin
        Client.BattleJoinPassword := sl[3];
        if (BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil) and Status.Me.InBattle and BattleState.SpringComAddrAcquired then
        begin
          tmpStr := '/adduser '+Client.Name+' '+Client.BattleJoinPassword;
          MainForm.SpringSocket.SendBuffer(BattleState.SpringComAddr,BattleState.SpringComPort,tmpStr[1],Length(tmpStr))
        end;
      end;

      if (sl.Count = 3) and (Client = Status.Me) then
        Status.Me.BattleJoinPassword := '';

      if (sl.Count = 4) and (Client = Status.Me) and (sl[3] = Status.Me.BattleJoinPassword) and (BattleState.Status = Joined) then
      begin
        BattleState.HostSupportsJoinPassword := True;
        if TClient(Battle.Clients[0]).GetInGameStatus then
        begin
          BattleForm.JoinButton.Enabled := MapList.IndexOf(BattleState.Battle.Map) > -1;
          BattleForm.JoinButton.Visible := True;
          BattleForm.StartButton.Visible := False;
        end;
      end;

      Client.SetMode(1);
      Client.Battle := Battle;
      Battle.Clients.Add(Client);
      if Battle = selectedBattlePlayers then
      begin
        Battle.SortedClients.Add(Client);
        SortClientInList(Client,Battle.SortedClients,Preferences.SortStyle, Preferences.SortAsc);
      end;
      UpdateBattlePlayersListBox(Battle,Client);

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
          if NotificationsForm.FindNotification(nfStatusInBattle, [Client.Name]) or ((Client.GetGroup <> nil) and Client.GetGroup.NotifyOnHost and (Battle.ID <> Status.Me.GetBattleId)) then
            AddNotification(_('Player joined battle'), '<' + Client.DisplayName + _('> has joined ') + TClient(Battle.Clients[0]).DisplayName + _('''s battle.') , 5000,true,Battle.ID);

      SortBattleInList(Battles.IndexOf(Battle),Preferences.BattleSortStyle,Preferences.BattleSortDirection = 0);
      RefreshBattleList;

      VDTBattles.Invalidate;

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          if not Preferences.FilterBattleJoinLeftMessages then
            BattleForm.AddTextToChat('* ' + Client.DisplayName + _(' has joined battle'), Colors.ChanJoin, 1);
          BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,False);
          BattleForm.UpdateClientsListBox;
          if BattleState.Status = Hosting then
          begin
            if BattleState.BanList.IndexOf(Client.Id) > -1 then begin
              if Client.AutoKickMsgSent < MAX_AUTOSENDMSG then
              begin
                MainForm.TryToSendCommand('SAYBATTLEEX', '*** Banned player auto-kick ***');
                Client.AutoKickMsgSent := Client.AutoKickMsgSent + 1;
              end;
              MainForm.TryToSendCommand('KICKFROMBATTLE', Client.Name);
            end
            else
            begin
              if (Client.GetRank < BattleState.Battle.RankLimit) and BattleState.AutoKickRankLimit then begin
                if Client.AutoKickMsgSent < MAX_AUTOSENDMSG then
                begin
                  MainForm.TryToSendCommand('SAYBATTLEEX', '*** Rank limit auto-kick ***');
                  Client.AutoKickMsgSent := Client.AutoKickMsgSent + 1;
                end;
                MainForm.TryToSendCommand('KICKFROMBATTLE', Client.Name);
              end
              else
                if (Client.GetGroup <> nil) and Client.GetGroup.AutoKick then begin
                  if Client.AutoKickMsgSent < MAX_AUTOSENDMSG then
                  begin
                    MainForm.TryToSendCommand('SAYBATTLEEX', '*** Banned Group member auto-kick ***');
                    Client.AutoKickMsgSent := Client.AutoKickMsgSent + 1;
                  end;
                  MainForm.TryToSendCommand('KICKFROMBATTLE', Client.Name);
                end;
            end;
            Inc(Battle.SpectatorCount); //*** test
            BattleForm.SendBattleInfoToServer;
            if (BattleFormUnit.BattleState.Battle.Description <> '(none)') and BattleState.AutoSendDescription and (Client.AutoKickMsgSent < MAX_AUTOSENDMSG)  then
              MainForm.TryToSendCommand('SAYBATTLEEX', '*** Description : '+BattleFormUnit.BattleState.Battle.Description+' ***');
          end;
          if not BattleForm.Active then
            if NotificationsForm.FindNotification(nfJoinedBattle, []) or ((BattleState.Status = Hosting) and NotificationsForm.FindNotification(nfJoinedMyHostedBattle, [])) then
              AddNotification(_('Player joined battle'), '<'+ Client.DisplayName + _('> has joined battle.'), 2000);
        end;
    end
    else if sl[0] = 'LEFTBATTLE' then
    begin
      if sl.Count <> 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,99);
        Exit;
      end;

      try
        i := StrToInt(sl[1]);
      except
        AmbiguousCommand(s,'', Colors.Error,100);
        Exit;
      end;

      Battle := GetBattle(i);
      if Battle = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,101);
        Exit;
      end;

      Client := GetClient(sl[2]);
      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,102);
        Exit;
      end;

      if Battle.Clients[0] = Client then
      begin
        AddMainLog(_('Warning: User left a battle he is hosting without closing it!'), Colors.Error);
        ProcessRemoteCommand('BATTLECLOSED '+IntToStr(Battle.ID));
        Exit; // the BATTLECLOSED takes care of everything
      end;

      tmpBool := Client.GetMode=0;

      Battle.Clients.Remove(Client);
      Battle.SortedClients.Remove(Client);
      Client.Battle := nil;
      UpdateBattlePlayersListBox(Battle,Client);

      if Battle.Visible then
        VDTBattles.InvalidateNode(Battle.Node);
      Client.InBattle := False;

      UpdateClientsListBox;

      //while RefreshingBattleList do;
      SortBattleInList(Battles.IndexOf(Battle),Preferences.BattleSortStyle,Preferences.BattleSortDirection = 0);
      RefreshBattleList;

      VDTBattles.Invalidate;

      if BattleForm.IsBattleActive then
        if Battle.ID = BattleFormUnit.BattleState.Battle.ID then
        begin
          if not Preferences.FilterBattleJoinLeftMessages then
            BattleForm.AddTextToChat('* ' + Client.DisplayName + _(' has left battle'), Colors.ChanLeft, 1);
          BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
          BattleForm.UpdateClientsListBox;
          BattleForm.RefreshTeamNbr;

          if BattleState.Status = Hosting then
          begin
            tmpInt := Battle.SpectatorCount;
            if tmpBool then
            begin
              Battle.SpectatorCount := Battle.SpectatorCount - 1;
              BattleForm.SendBattleInfoToServer;
            end;
          end;
          if Client = Status.Me then // this should normally not happen since we disconnect from the battle immediately after receiving FORCEQUITBATTLE command from the server
          begin
            BattleForm.ResetBattleScreen;
            BattleState.Status := None;
          end;

          BattleForm.StartButton.Enabled := BattleForm.isBattleReadyToStart;
        end;
    end
    else if sl[0] = 'CLIENTSTATUS' then
    begin
      if sl.Count <> 3 then
      begin
        AmbiguousCommand(s,'', Colors.Error,103);
        Exit;
      end;

      Client := GetClient(sl[1]);
      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,104);
        Exit;
      end;

      try
        tmpInt := StrToInt(sl[2]);
      except
        AmbiguousCommand(s,'', Colors.Error,105);
        Exit;
      end;

      tmpBool := Client.GetInGameStatus;
      Client.Status := tmpInt;
      changed := Client.GetInGameStatus <> tmpBool;

      // let's check if this client is founder of any battle. If he is, we must refresh this battle's node. We must also check if he is the founder of the battle user is participating in.
      if Client.InBattle then
      begin
        if Client.Battle.Clients[0] = Client then
        begin
          if changed and (BattleState.Battle <> nil) and (BattleState.Battle.ID = Client.Battle.ID) and (client <> Status.me) then
          begin
            BattleForm.JoinButton.Enabled := MapList.IndexOf(BattleState.Battle.Map) > -1;
            BattleForm.JoinButton.Visible := Client.GetInGameStatus;
            BattleForm.StartButton.Visible := not BattleForm.JoinButton.Visible;
          end;
          if not Status.ReceivingLoginInfo then
          begin
            Client.Battle.StartTimeUknown := False;
            Client.Battle.StartTime := Now;
          end;
          if (BattleState.Battle <> nil) and (BattleState.Battle.ID = Client.Battle.ID) and (Client.GetInGameStatus) and changed and (not Status.AmIInGame) then
          begin
            AutojoinTimer.Interval := AutojoinTimer.Interval + 3000;
            PostMessage(BattleForm.Handle, WM_STARTGAME, 0, 0);
            // if founder of the battle we are participating in just went in-game, we must launch the game too!
          end;
          if changed and ((Preferences.BattleSortStyle = 1) or (Preferences.BattleSortStyle = 8)) then
            SortBattleInList(Battles.IndexOf(Client.Battle),Preferences.BattleSortStyle,Preferences.BattleSortDirection = 0);
          if changed then
            RefreshBattleList;
          if not Status.ReceivingLoginInfo then VDTBattles.Invalidate; // since multiple nodes could be moved when calling SortBattleInList
          
        end;
      end;

      if Client.InBattle and BattleForm.IsBattleActive and (BattleState.Battle.Clients.IndexOf(Client) <> -1) then begin
        BattleForm.VDTBattleClients.Invalidate; // refresh battle client list, since client's status just changed (we could also just invalidate this client's node and not the entire list, but just to make sure)
        BattleForm.RefreshTeamNbr;
      end;

      if changed and not Client.GetInGameStatus and (Client.GetBattleId <> Status.Me.GetBattleId) and (Client.GetGroup <> nil) and Client.GetGroup.NotifyOnBattleEnd then
        AddNotification(_('Player battle end'), '<' + Client.DisplayName + _('> has end his battle.'), 2000);


      if Client.Name = Status.Username then Status.MyRank := Client.GetRank;

      if not Status.ReceivingLoginInfo then UpdateClientsListBox;
      UpdateBattlePlayersListBox(nil,Client);

      if (Status.ReceivingLoginInfo) and ((Status.LastCommandReceived = 'UPDATEBATTLEINFO') or (Status.LastCommandReceived = 'JOINEDBATTLE')) then LoginProgressForm.UpdateCaption(_('Updating clients status list ...'));
    end
    else if sl[0] = 'UPDATEBATTLEINFO' then
    begin
      if sl.Count < 5 then
      begin
        AmbiguousCommand(s,'', Colors.Error,106);
        Exit;
      end;

      try
        tmpInt := StrToInt(sl[1]);
        tmpInt2 := StrToInt(sl[2]);
        tmpBool := IntToBool(StrToInt(sl[3]));
        maphash := StrToInt(sl[4]);
      except
        AmbiguousCommand(s,'', Colors.Error,107);
        Exit;
      end;
      while RefreshingBattleList do;
      Battle := GetBattle(tmpInt);
      if Battle = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,108);
        Exit;
      end;

      if (BattleForm.IsBattleActive) and (Battle.ID = BattleState.Battle.ID) then
        oldMapHash := BattleState.Battle.MapHash;

      Battle.Map := MakeSentenceWS(sl, 5);
      Battle.MapHash := maphash;
      Battle.SpectatorCount := tmpInt2;
      Battle.Locked := tmpBool;

      SortBattleInList(Battles.IndexOf(Battle),Preferences.BattleSortStyle,Preferences.BattleSortDirection = 0);

      oldVisible := Battle.Visible;
      Battle.Visible := isBattleVisible(Battle,CurrentFilters);
      if Battle.Visible <> oldVisible then begin
        RefreshBattleList;
      end;

      VDTBattles.Invalidate;

      if BattleForm.IsBattleActive then if Battle.ID = BattleState.Battle.ID then
      begin
        if BattleState.Status <> Hosting then BattleForm.LockedCheckBox.Checked := Battle.Locked;

        tmpInt := Utility.MapList.IndexOf(Battle.Map);
        if tmpInt = -1 then
        begin
          if BattleState.Status = Hosting then
          begin // this should NEVER happen!
            MessageDlg(_('Error: Map changed to unknown map! Please report this error!'), mtError, [mbOK], 0);
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
        AmbiguousCommand(s,'', Colors.Error,109);
        Exit;
      end;

      if BattleFormUnit.BattleState.Status = None then
      begin
        AmbiguousCommand(s,'', Colors.Error,110);
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
        AmbiguousCommand(s,'', Colors.Error,111);
        Exit;
      end;

      if (l < 0) or (l > 3) then
      begin
        AmbiguousCommand(s,'', Colors.Error,112);
        Exit;
      end;

      if (m < 0) or (m > 2) then
      begin
        AmbiguousCommand(s,'', Colors.Error,113);
        Exit;
      end;

      AllowBattleDetailsUpdate := False;
      BattleForm.MetalTracker.Position := i;
      BattleForm.EnergyTracker.Position := j;
      BattleForm.UnitsTracker.Position := k;
      BattleForm.StartPosRadioGroup.ItemIndex := l;
      BattleForm.RefreshStartRectsPosAndSize;
      BattleForm.GameEndRadioGroup.ItemIndex := m;
      //BattleForm.LimitDGunCheckBox.Checked := IntToBool(o);
      //BattleForm.DiminishingMMsCheckBox.Checked := IntToBool(p);
      //BattleForm.GhostedBuildingsCheckBox.Checked := IntToBool(r);
      AllowBattleDetailsUpdate := True;
      BattleForm.RefreshQuickLookText;
    end
    else if sl[0] = 'REMOVESCRIPTTAGS' then
    begin
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,114);
        Exit;
      end;
      for i:=1 to sl.Count-1 do
      begin
        with BattleForm.UnknownScriptTagList do
        begin
          j := CompleteKeyList.IndexOf(LowerCase(sl[i]));
          if j = -1 then
          begin
            AmbiguousCommand(s,'', Colors.Error,115);
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
        //AmbiguousCommand(s,'', Colors.Error,116);
        Exit;
      end;
      sl3 := TStringList.Create;
      tmpBool2 := False; // indicates if scripttags contain skill data
      for i:=0 to sl2.Count-1 do
      begin
        j := Pos('=',sl2[i]);
        tmp := LowerCase(LeftStr(sl2[i],j-1)); // key
        tmp2 := MidStr(sl2[i],j+1,MaxInt); // value

        Misc.ParseDelimited(sl3,tmp,'/','\');
        AllowBattleDetailsUpdate := False;

        tmpBool := (fsBold in BattleForm.GameOptionsTab.FontSettings.Style);

        try
          if tmp = LowerCase('GAME/modoptions/StartMetal') then
            BattleForm.MetalTracker.Position := StrToInt(tmp2)
          else if tmp = LowerCase('GAME/modoptions/StartEnergy') then
            BattleForm.EnergyTracker.Position := StrToInt(tmp2)
          else if tmp = LowerCase('GAME/modoptions/MaxUnits') then
            BattleForm.UnitsTracker.Position := StrToInt(tmp2)
          else if tmp = LowerCase('GAME/StartPosType') then
          begin
            BattleForm.StartPosRadioGroup.ItemIndex := StrToInt(tmp2);
            BattleForm.RefreshStartRectsPosAndSize;
          end
          else if tmp = LowerCase('GAME/modoptions/GameMode') then
            BattleForm.GameEndRadioGroup.ItemIndex := StrToInt(tmp2)
          else if (sl3.Count = 3) and (sl3[0] = 'game') and ((sl3[1] = 'mapoptions') or (sl3[1] = 'modoptions')) then
          begin
            if sl3[1] = 'mapoptions' then
            begin
              luaOpt := Utility.GetLuaOption(BattleForm.MapOptionsList,sl3[2]);
              if (BattleForm.SpTBXTabControl1.ActivePage.Item.Name <> 'MapTab') and (BattleState.Status <> Hosting) then
              begin
                //BattleForm.MapTab.FontSettings.Bold := tsTrue;
              end;
            end
            else
            begin
              luaOpt := Utility.GetLuaOption(BattleForm.ModOptionsList,sl3[2]);
              if (BattleForm.SpTBXTabControl1.ActivePage.Item.Name <> 'ModTab') and (BattleState.Status <> Hosting) then
              begin
                //BattleForm.ModTab.FontSettings.Bold := tsTrue;
              end;
            end;

            if (BattleForm.SpTBXTabControl1.ActivePage.Item.Name <> 'GameOptionsTab') and (BattleState.Status <> Hosting) and not tmpBool then
            begin
              //BattleForm.GameOptionsTab.FontSettings.Bold := tsFalse;
            end;

            if luaOpt <> nil then
              luaOpt.SetValue(tmp2);
            //else
              BattleForm.ChangeScriptTagValue(Misc.JoinStringList(sl3,'/'),tmp2);
          end
          else
          begin
            BattleForm.ChangeScriptTagValue(Misc.JoinStringList(sl3,'/'),tmp2);
            if (sl3.Count = 4) and (sl3[0] = 'game') and (sl3[1] = 'players') and ((sl3[3] = 'skill') or (sl3[3] = 'skilluncertainty')) then
              tmpBool2 := True; // scripttags contain skill data
          end;
          BattleForm.QuickLookChangedTmr.Enabled := False;
          BattleForm.QuickLookChangedTmr.Interval := 3000;
          BattleForm.QuickLookChangedTmr.Enabled := True;
        except
          on E: Exception do
          begin
            MessageDlg(E.Message,mtError,[mbOk], E.HelpContext);
            AmbiguousCommand(s,'', Colors.Error,117);
            BattleForm.DisconnectButtonClick(nil);
          end;
        end;
        BattleForm.RefreshQuickLookText;
        AllowBattleDetailsUpdate := True;
      end;
      if tmpBool2 then
      begin
        BattleForm.VDTBattleClients.Header.Columns[1].Options := BattleForm.VDTBattleClients.Header.Columns[1].Options + [coVisible];
        BattleForm.VDTBattleClients.Invalidate; // we need to reprint skill values if we receive new ones
      end;
    end
    else if sl[0] = 'CLIENTBATTLESTATUS' then
    begin
      if sl.Count <> 4 then
      begin
        AmbiguousCommand(s,'', Colors.Error,118);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,119);
        Exit;
      end;

      Client := GetClient(sl[1]);
      if Client = nil then
      begin
        AmbiguousCommand(s,'', Colors.Error,120);
        Exit;
      end;

      try
        tmpInt := StrToInt(sl[2]);
      except
        AmbiguousCommand(s,'', Colors.Error,121);
        Exit;
      end;

      try
        teamcolor := StrToInt(sl[3]);
      except
        AmbiguousCommand(s,'', Colors.Error,122);
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
        if (Client.GetMode = 0) and (Client.GetReadyStatus) then
        begin
          Client.SetReadyStatus(False);
          BattleForm.AmIReady := False;
        end;
        if Misc.GetColorIndex(TeamColors, teamcolor) = -1 then begin
          TeamColors[0] := teamcolor;
          UpdateColorImageList;
        end;
        BattleForm.ChangeTeamColor(Misc.GetColorIndex(TeamColors, teamcolor),False);
      end;

      // update spectator count:
      BattleState.Battle.SpectatorCount := 0;
      for i:=0 to BattleState.Battle.Clients.Count-1 do
        if TClient(BattleState.Battle.Clients[i]).GetMode = 0 then
          BattleState.Battle.SpectatorCount := BattleState.Battle.SpectatorCount + 1;

      if BattleState.Status = Hosting then if BattleState.Battle.Clients.IndexOf(Client) <> -1 then
      begin
        if tmpBool then
        begin
          if (BattleState.Status=Hosting) and (Client.GetRank < BattleState.Battle.RankLimit) and BattleState.AutoSpecRankLimit and (Client.GetMode <> 0) then begin
            if Client.AutoSpecMsgSent < MAX_AUTOSENDMSG then
            begin
              MainForm.TryToSendCommand('SAYBATTLEEX', '*** Rank limit auto-spec : '+Client.Name+' ***');
              Client.AutoSpecMsgSent := Client.AutoSpecMsgSent + 1;
            end;
            MainForm.TryToSendCommand('FORCESPECTATORMODE', Client.Name);
          end
          else
            if (BattleState.Status=Hosting) and (Client.GetGroup <> nil) and Client.GetGroup.AutoSpec and (Client.GetMode <> 0) then begin
              if Client.AutoSpecMsgSent < MAX_AUTOSENDMSG then
              begin
                MainForm.TryToSendCommand('SAYBATTLEEX', '*** Group auto-spec : '+Client.Name+' ***');
                Client.AutoSpecMsgSent := Client.AutoSpecMsgSent + 1;
              end;
              MainForm.TryToSendCommand('FORCESPECTATORMODE', Client.Name);
            end;

          BattleForm.SendBattleInfoToServer;
        end;
        BattleForm.StartButton.Enabled := BattleForm.isBattleReadyToStart;
      end;
      BattleForm.RefreshTeamNbr;
      Client.StatusRefreshed := True;
    end
    else if sl[0] = 'FORCEQUITBATTLE' then
    begin
      if sl.Count <> 1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,123);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,147);
        Exit;
      end;

      BattleForm.AddTextToChat(_('You were kicked from battle!'), Colors.Info,1);
      BattleForm.ResetBattleScreen;
      BattleState.Status := None;
    end
    else if sl[0] = 'DISABLEUNITS' then
    begin
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,124);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,125);
        Exit;
      end;

      for i := 1 to sl.Count-1 do BattleState.DisabledUnits.Add(sl[i]);
      BattleForm.PopulateDisabledUnitsVDT;
      BattleForm.RefreshQuickLookText;
    end
    else if sl[0] = 'ENABLEUNITS' then
    begin
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,126);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,127);
        Exit;
      end;

      for i := 1 to sl.Count-1 do
      begin
        j := BattleState.DisabledUnits.IndexOf(sl[i]);
        if j = -1 then Continue;
        BattleState.DisabledUnits.Delete(j);
      end;
      BattleForm.PopulateDisabledUnitsVDT;
      BattleForm.RefreshQuickLookText;
    end
    else if sl[0] = 'ENABLEALLUNITS' then
    begin
      if sl.Count <> 1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,128);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,129);
        Exit;
      end;

      BattleState.DisabledUnits.Clear;
      BattleForm.PopulateDisabledUnitsVDT;
      BattleForm.RefreshQuickLookText;
    end
    else if sl[0] = 'RING' then
    begin
      if sl.Count <> 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,130);
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
        AmbiguousCommand(s,'', Colors.Error,131);
        Exit;
      end;

      AddMainLog(_('* Broadcast from server: ') + MakeSentenceWS(sl, 1), Colors.Info);

      For i:=1 to ChatTabs.Count -1 do
        AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), _('* Broadcast from server: ') + MakeSentenceWS(sl, 1), Colors.Info);
    end
    else if sl[0] = 'SERVERMSG' then
    begin
      sl2 := TWideStringList.Create;
      if sl.Count < 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,132);
        Exit;
      end;
      tmp := MakeSentenceWS(sl, 1);
      AddMainLog(_('* Message from server: ') + tmp, Colors.Info);
      if Pos('Your account has been renamed',tmp) > 0then // handleRename
      begin
        tmp := MidStr(tmp,Pos('<',tmp)+1,500000);
        tmp := LeftStr(tmp,Pos('>',tmp)-1);

        Preferences.Username := tmp;
        PreferencesForm.UpdatePreferencesFrom(Preferences);
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
        AmbiguousCommand(s,'', Colors.Error,133);
        Exit;
      end;

      sl2 := ParseString(MakeSentenceWS(sl, 1), #9);

      if sl2.Count > 1 then url := sl2[1]
      else url := '';

      if url = '' then
        MessageDlg(_('Message from server: ') +#13+#13+ sl2[0], mtInformation, [mbOK], 0)
      else
      begin
        if MessageDlg(_('Message from server: ') +#13+#13+ sl2[0] +#13+#13+_('Do you want to open ') + url + _(' in the default browser now?'), mtInformation, [mbYes, mbNo], 0) = mrYes then
          Misc.OpenURLInDefaultBrowser(url);
      end;
    end
    else if sl[0] = 'SCRIPTSTART' then
    begin
      if sl.Count <> 1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,134);
        Exit;
      end;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,135);
        Exit;
      end;

      if not (BattleState.Battle.BattleType = 1) then
      begin
        AmbiguousCommand(s,'', Colors.Error,136);
        Exit;
      end;

      BattleReplayInfo.TempScript.Clear;
    end
    else if sl[0] = 'SCRIPT' then
    begin
      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,137);
        Exit;
      end;

      if not (BattleState.Battle.BattleType = 1) then
      begin
        AmbiguousCommand(s,'', Colors.Error,138);
        Exit;
      end;

      if sl.Count < 2 then BattleReplayInfo.TempScript.Add('')
      else BattleReplayInfo.TempScript.Add(MakeSentenceWS(sl, 1));
    end
    else if sl[0] = 'SCRIPTEND' then
    begin
      if sl.Count <> 1 then
      begin
        AmbiguousCommand(s,'', Colors.Error,139);
        Exit;
      end;

      // we are hosting with a relay host, no need to apply the script again
      if HostBattleForm.relayHoster <> nil then
        Exit;

      if not BattleForm.IsBattleActive then
      begin
        // not a big problem. This can happen because of lag (we could get this command just after we left the battle)
        AmbiguousCommand(s,'', Colors.Error,140);
        Exit;
      end;

      if not (BattleState.Battle.BattleType = 1) then
      begin
        AmbiguousCommand(s,'', Colors.Error,141);
        Exit;
      end;

      if BattleReplayInfo.Script <> nil then
        BattleReplayInfo.Script.Free;
      BattleReplayInfo.Script := TScript.Create(BattleReplayInfo.TempScript.Text);
      BattleForm.ApplyScriptFile(BattleReplayInfo.Script);
    end
    else if sl[0] = 'MUTELISTBEGIN' then
    begin
      if sl.Count <> 2 then
      begin
        AmbiguousCommand(s,'', Colors.Error,142);
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
        AmbiguousCommand(s,'', Colors.Error,143);
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
    else if sl[0] = 'ACQUIREUSERID' then
    begin
      Misc.GenerateAndSaveLobbyUserID;
      TryToSendCommand('USERID', IntToHex(Misc.GetLobbyUserID, 1));
    end
    else
    begin
      // unknown/invalid command!

      AddMainLog(_('Error: Server sent unknown or invalid command : '+s), Colors.Error);
    end;
  finally
    if AcquireMainThread then
    begin
      try if not Preferences.ScriptsDisabled then handlers.handleIn2(s); except end;
      ReleaseMainThread;
    end;
    
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
  pc: TPageControl;
begin
  if TabSheet.Caption = LOCAL_TAB then Exit;

  if TabSheet.Parent is TTabSheet then
    pc := TPageControl(TTabSheet(TabSheet.Parent).PageControl);

  if TabSheet.Caption[1] = '#' then
    if Status.ConnectionState = Connected then
    begin
      TryToSendCommand('LEAVE', MidStr(TabSheet.Caption, 2, 999));
      if Preferences.AutoSaveChanSession then
        PerformForm.removeAutoJoinChannel(MidStr(TabSheet.Caption, 2, 999));
    end;

  if TabSheet.Parent is TTabSheet then
  begin
    index := TTabSheet(TabSheet.Parent).PageIndex;
    pc.ActivePageIndex := Min(pc.PageCount-1, index+1);
    if pc.ActivePage.Controls[0] is TMyTabSheet then
      lastActiveTab := TMyTabSheet(pc.ActivePage.Controls[0])
    else
      lastActiveTab := ChatTabs[0];
    pc.OnChange(pc);
  end
  else
  begin
    lastActiveTab := ChatTabs[0];
    UpdateClientsListBox;
    ShowAndSetFocus(TWinControl(lastActiveTab.FindComponent('InputEdit')));
  end;
  BattleForm.ChatActive := False;
  TabSheet.Free;
end;


procedure TMainForm.RichEditDblClick(Sender: TObject);
var
   ci, //Character Index
   lix, //Line Index
   co, //Character Offset
   k, j: Integer;
   Pt: TPoint;
   s: WideString;
   SelectedWord: WideString;
   SelectedClient: TClient;
   mapIndex: integer;
   r: boolean;
   charPosOnLine: integer;
   channel: string;
begin
   with TExRichEdit(Sender) do
   begin
    try
     GetCursorPos(pt);
     pt := TExRichEdit(Sender).ScreenToClient(pt);
     //Pt := Point(X, Y) ;
     ci := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@Pt)) ;
     if ci < 0 then Exit;
     lix := Perform(EM_EXLINEFROMCHAR, 0, ci) ;
     co := ci - Perform(EM_LINEINDEX, lix, 0) ;
     charPosOnLine := co;
     if -1 + Lines.Count < lix then Exit;
     s := Lines[lix];
     Inc(co) ;
     k := co;
     while (k > 0) and (s[k] <> ' ') and (s[k] <> #9) and (s[k] <> '<') and (s[k] <> '(') do k:=k-1;
     Inc(k);
     Inc(co) ;
     j := co;
     while (j <= Length(s)) and (s[j] <> ' ') and (s[j] <> #9) and (s[j] <> '>') and (s[j] <> ')') do Inc(j) ;
     SelectedWord := Copy(s, k, j - k) ;

     if Sender = BattleForm.ChatRichEdit then
      channel := '$battle'
     else
      channel := TMyTabSheet(TExRichEdit(Sender).Parent).Caption;

     AcquireMainThread;
     try if not Preferences.ScriptsDisabled then r := handlers.onChatDblClick(channel,charPosOnLine,UTF8Encode(WideLines[lix])); except end;
     ReleaseMainThread;

     if r then Exit;

     SelectedClient := GetClient(SelectedWord);

     if SelectedClient <> nil then
     begin
       OpenPrivateChat(SelectedClient);
     end
     else// if RightStr(LowerCase(SelectedWord),4) = '.smf' then
     begin
        mapIndex := MapList.IndexOf(SelectedWord);
        if mapIndex > -1 then
          if BattleState.Status = Hosting then
          begin
            BattleForm.ChangeMap(mapIndex);
            if BattleState.Status = Hosting then
              BattleForm.SendBattleInfoToServer;
            
          end;
     end;
    except
      
    end;
   end;
end;

procedure TMainForm.RichEditMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ci, //Character Index
   lix, //Line Index
   co, //Character Offset
   k, j: Integer;
   s: string;
   SelectedNick: string;
begin
  richContextMenu := TExRichEdit(Sender);
   with TExRichEdit(Sender) do
   begin
    try
     richContextMenuClick := Point(X, Y) ;

     ci := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@richContextMenuClick)) ;
     if ci < 0 then Exit;
     lix := Perform(EM_EXLINEFROMCHAR, 0, ci) ;
     co := ci - Perform(EM_LINEINDEX, lix, 0) ;
     if -1 + Lines.Count < lix then Exit;
     s := Lines[lix];
     Inc(co) ;
     k := co;
     while (k > 0) and (s[k] <> ' ') and (s[k] <> #9) and (s[k] <> '<') and (s[k] <> '(') do k:=k-1;
     Inc(k);
     Inc(co) ;
     j := co;
     while (j <= Length(s)) and (s[j] <> ' ') and (s[j] <> #9) and (s[j] <> '>') and (s[j] <> ')') do Inc(j) ;
     SelectedNick := Copy(s, k, j - k) ;

     ContextMenuSelectedClient := GetClient(SelectedNick);

     if (ContextMenuSelectedClient <> nil) then
     begin
      if (Button = mbRight) then
      begin
       ModerationSubmenuItem.Visible := Status.Me.GetAccess; // only moderators may see moderation menu!
       MuteSubitemMenu.Visible := LeftStr(lastActiveTab.Caption,1) = '#';
       mnuUnmute.Visible := LeftStr(lastActiveTab.Caption,1) = '#';
       ClientPopupMenu.Popup(TExRichEdit(Sender).ClientToScreen(richContextMenuClick).X,TExRichEdit(Sender).ClientToScreen(richContextMenuClick).Y);
      end
      else
      begin
        ShowHint := True;
        s := '';
        if ContextMenuSelectedClient.GetGroup <> nil then s := ' - ' + ContextMenuSelectedClient.GetGroup.Name;
        Hint :=  IFF(ContextMenuSelectedClient.GetBotMode,_('{BOT} '),'') + ContextMenuSelectedClient.Name + ' - ' + GetCountryName(ContextMenuSelectedClient.Country) + ' - ' + Ranks[ContextMenuSelectedClient.GetRank] + s + IFF(ContextMenuSelectedClient.GetInGameStatus,_(' - INGAME'),'');
        // name history
        if ContextMenuSelectedClient.NameHistory.Count > 0 then
          Hint := Hint + ' - ('+_('A.K.A.')+' : ' + ContextMenuSelectedClient.NameHistory.CommaText + ')';
        if lastActiveTab.Caption = LOCAL_TAB then
          ClientsListBox.ItemIndex := AllClients.IndexOf(ContextMenuSelectedClient)
        else
          ClientsListBox.ItemIndex := lastActiveTab.Clients.IndexOf(ContextMenuSelectedClient);
      end;
      ContextMenuSelectedClient := nil;
     end
     else
      ShowHint := False;
    except
      ContextMenuSelectedClient := nil;
    end;
   end;
end;

procedure TMainForm.InputEditClick(Sender: TObject);
begin
  (Sender as TTntMemo).Tag := 0;
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
  tmp: WideString;
  i,j: integer;
  cmd: WideString;
  msgLines : TWideStringList;
  tmpLine: WideString;
begin
  if (Key = Ord('W')) and (ssCtrl in Shift) then
  begin
    if lastActiveTab.Caption = LOCAL_TAB then Exit;
    //PostMessage(MainForm.Handle, WM_CLOSETAB, PageControl1.ActivePageIndex, 0);
    Exit;
  end;

  if Key = 13 then
  begin
    SwitchToNewChatRoom := true;
    msgLines := TWideStringList.Create;
    for i:=0 to (Sender as TTntMemo).Lines.Count-1 do
    begin
      tmpLine := tmpLine + (Sender as TTntMemo).Lines[i];
      if Length(tmpLine) <> 1024 then
      begin
        msgLines.Add(tmpLine);
        tmpLine := '';
      end;
    end;
    if tmpLine <> '' then
      msgLines.Add(tmpLine);
    if (Sender as TTntMemo).Text = '' then Exit;
    s := msgLines[0];

    (Sender as TTntMemo).Text := '';

    with ((Sender as TTntMemo).Parent as TMyTabSheet) do
    begin
      History.Add(msgLines.Text);
      HistoryIndex := History.Count;
    end;

    for i:=0 to msgLines.Count-1 do
      if (Length(msgLines[i]) > 0) and ((msgLines[i][1] = '/') or (msgLines[i][1] = '.')) then
      begin
        ProcessCommand(Copy(msgLines[i], 2, Length(msgLines[i])-1), False);
      end;

    if ((Sender as TTntMemo).Parent as TMyTabSheet).Caption[1] = '$' then
    begin
      for i:=0 to msgLines.Count-1 do
        if (Length(msgLines[i]) > 0) and ((msgLines[i][1] <> '.') and (msgLines[i][1] <> '/')) then
        begin
          sl := StringParser.ParseString(msgLines[i], ' ');
          if sl.Count > 1 then
            TryToSendCommand(sl[0], MakeSentenceWS(sl, 1))
          else
            TryToSendCommand(sl[0]);
        end;
    end
    else
    begin
      if ((Sender as TTntMemo).Parent as TMyTabSheet).Clients.Count > 0 then
        if (msgLines.Count <= 10) or (MessageDlg(_('You are about to send a ')+IntToStr(msgLines.Count)+ _(' lines message.')+EOL+EOL+_('Do you really want to send it ?'),mtConfirmation,[mbYes,mbNo],0) = mrYes) then
          for i:=0 to msgLines.Count-1 do
            if (Length(msgLines[i]) = 0) or ((msgLines[i][1] <> '.') and (msgLines[i][1] <> '/')) then
              if ((Sender as TTntMemo).Parent as TMyTabSheet).Caption[1] = '#' then
                TryToSendCommand('SAY',Copy(((Sender as TTntMemo).Parent as TMyTabSheet).Caption, 2, Length(((Sender as TTntMemo).Parent as TMyTabSheet).Caption))+' '+msgLines[i])
              else
                TryToSendCommand('SAYPRIVATE',TClient(((Sender as TTntMemo).Parent as TMyTabSheet).Clients[0]).Name+' '+msgLines[i]);
                //for j:=0 to ((Sender as TTntMemo).Parent as TMyTabSheet).Clients.Count-1 do
                //  TryToSendCommand('SAYPRIVATE',TClient(((Sender as TTntMemo).Parent as TMyTabSheet).Clients[j]).Name+' '+msgLines[i]);
    end;
  end
  else if Key = VK_UP then
  begin
    with (Sender as TTntMemo).Parent as TMyTabSheet do
    begin
      if History.Count = 0 then Exit;
      HistoryIndex := Max(0, HistoryIndex-1);
      (Sender as TTntMemo).Text := History[HistoryIndex];
      (Sender as TTntMemo).SelStart := Length((Sender as TTntMemo).Text);
      Key := 0;
    end;
  end
  else if Key = VK_DOWN then
  begin
    with (Sender as TTntMemo).Parent as TMyTabSheet do
    begin
      if History.Count = 0 then Exit;
      HistoryIndex := Min(History.Count-1, HistoryIndex + 1);
      (Sender as TTntMemo).Text := History[HistoryIndex];
      (Sender as TTntMemo).SelStart := Length((Sender as TTntMemo).Text);
      Key := 0;
    end;
  end
  else if Key = VK_ESCAPE then
  begin
    (Sender as TTntMemo).Text := '';
    Key := 0;
  end;

  if Key <> VK_TAB then
    (Sender as TTntMemo).Tag := 0;
end;

procedure TMainForm.InputEditChange(Sender: TObject);
var
  selStart,selLength: integer;
begin
  selStart := (Sender as TTntMemo).SelStart;
  selLength := (Sender as TTntMemo).SelLength;

  if (Sender as TTntMemo).Lines.Count > 1 then
    (Sender as TTntMemo).ScrollBars := ssVertical
  else
    (Sender as TTntMemo).ScrollBars := ssNone;

  (Sender as TTntMemo).SelStart := selStart;
  (Sender as TTntMemo).SelLength := selLength;
end;

procedure TMainForm.PageControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  i := TPageControl(Sender).IndexOfTabAt(X, Y);

  if (i >= 0) and (Button = mbRight) and (TPageControl(Sender).Pages[i].Controls[0] is TMyTabSheet) then
    TryToCloseTab(TPageControl(Sender).Pages[i].Controls[0] as TMyTabSheet);
end;

procedure TMainForm.ClientsListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  FlagBitmap: TBitmap;
  xpos: Integer;
  group: TClientGroup;
  i: integer;
  tmp: integer;
  cList: TList;
  realIndex: integer;
  LineRect: TRect;
  pt: TPoint;
  hot: Boolean;
  groupColorEnabled: boolean;
begin
  if Status.ReceivingLoginInfo then Exit;

  cList := TList.Create;
  GetDrawItemClientList(Control,cList);

  try

  if (Index = 0) and (cList.Count = 0) then
  begin
    (Control as TTntListBox).Canvas.FillRect(Rect);
    Exit;
  end
  else
    if Index > cList.Count-1 then Exit; // we just ignore it. It seems ClientsListBox hasn't been yet updated. This can happen when we remove items from it and we don't call UpdateClientsListBox right away, since we want to do some more things before that. Anyway, this should not happen, since ClientsListBox is changed only within the main VCL thread.

  {if Control = ClientsListBox then
  begin
    tmp := Index;
    for i:=0 to cList.Count-1 do
    begin
      if TClient(cList[i]).Visible then Dec(tmp);
      if tmp = -1 then break;
    end;
    realIndex := i;
  end
  else}
    realIndex := Index;    

  groupColorEnabled := false;
  group := TClient(cList[realIndex]).GetGroup;
  if (group <> nil) and ((Control as TTntListBox).ItemIndex <> Index) and (group.EnableColor) then
  begin
    (Control as TTntListBox).Canvas.Brush.Color := group.Color;
    (Control as TTntListBox).Canvas.Font.Color := Misc.ComplementaryTextColor(group.Color);
    groupColorEnabled := true;
  end;

  if (SkinManager.GetSkinType = sknSkin) then
  begin
    GetCursorPos(pt);
    pt := (Control as TTntListBox).ScreenToClient(pt);
    hot := PointInRect(Rect,pt);
    if((Control as TTntListBox).ItemIndex = Index) then
    begin
      CopyRect(LineRect,Rect);
      InflateRect(LineRect,-1,-1);
      (Control as TTntListBox).Canvas.Brush.Style := Graphics.bsSolid;
      (Control as TTntListBox).Canvas.Brush.Color := (Control as TTntListBox).Color;
      (Control as TTntListBox).Canvas.FillRect(Rect);
      if hot then
        SkinManager.CurrentSkin.PaintBackground((Control as TTntListBox).Canvas,LineRect,skncListItem,sknsCheckedAndHotTrack,True,True)
      else
        SkinManager.CurrentSkin.PaintBackground((Control as TTntListBox).Canvas,LineRect,skncListItem,sknsChecked,True,True);
      //if odSelected in State then
      //  (Control as TTntListBox).Canvas.DrawFocusRect(Rect); // <--- That's the trick!
      (Control as TTntListBox).Canvas.Brush.Style := Graphics.bsClear;
      if hot then
        (Control as TTntListBox).Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsCheckedAndHotTrack)
      else
        (Control as TTntListBox).Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsChecked);
    end
    else
    begin
      if hot then
      begin
        SkinManager.CurrentSkin.PaintBackground((Control as TTntListBox).Canvas,Rect,skncListItem,sknsHotTrack,True,True);
        (Control as TTntListBox).Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsHotTrack);
        (Control as TTntListBox).Canvas.Brush.Style := Graphics.bsClear;
      end
      else
      begin
        if not groupColorEnabled then
          (Control as TTntListBox).Canvas.Font.Color := PreferencesForm.IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsNormal),clHighlightText);
        (Control as TTntListBox).Canvas.FillRect(Rect);
      end;
    end;
  end
  else
  begin
    if(ClientsListBox.ItemIndex = Index) then
      (Control as TTntListBox).Canvas.Font.Color := clHighlightText
    else if not groupColorEnabled then
      (Control as TTntListBox).Canvas.Font.Color := clWindowText;
    (Control as TTntListBox).Canvas.FillRect(Rect);
  end;

  xpos := Rect.Left;
  PlayerStateImageList.Draw((Control as TTntListBox).Canvas, xpos, Rect.Top, TClient(cList[realIndex]).GetStateImageIndex);
  Inc(xpos, PlayerStateImageList.Width + 5);

  if Preferences.ShowFlags then
  begin
    FlagBitmap := GetFlagBitmap(TClient(cList[realIndex]).Country);
    (Control as TTntListBox).Canvas.Draw(xpos, Rect.Top + 16 div 2 - FlagBitmap.Height div 2, FlagBitmap);
    Inc(xpos, FlagBitmap.Width + 5);
  end;

  if TClient(cList[realIndex]).GetAwayStatus and not TClient(cList[realIndex]).GetInGameStatus then
    (Control as TTntListBox).Canvas.Font.Color := Colors.ClientAway;
  RanksImageList.Draw((Control as TTntListBox).Canvas, xpos, Rect.Top, TClient(cList[realIndex]).GetRank);
  Inc(xpos, RanksImageList.Width + 1);

  if TClient(cList[realIndex]).GetBotMode then
  begin
    (Control as TTntListBox).Canvas.Draw(xpos, Rect.Top, BotImage.Picture.Bitmap);
    Inc(xpos, BotImage.Picture.Bitmap.Width + 4{leave some space between username and the icon});
  end;

  WideCanvasTextOut((Control as TTntListBox).Canvas, xpos, Rect.Top, TClient(cList[realIndex]).DisplayName);
  Inc(xpos, WideCanvasTextWidth((Control as TTntListBox).Canvas,TClient(cList[realIndex]).DisplayName));

  // custom icons
  if not Preferences.ScriptsDisabled then
    for i:=0 to lobbyScriptUnit.PlayerIconTypeNames.Count-1 do
    begin
      tmp := TClient(cList[realIndex]).GetCustomIconId(i);
      if (tmp >= 0) and (TImageList(lobbyScriptUnit.PlayerIconTypeIcons[i]).Count > tmp) then
      begin
        TImageList(lobbyScriptUnit.PlayerIconTypeIcons[i]).Draw((Control as TTntListBox).Canvas, xpos, Rect.Top,tmp);
        Inc(xpos, TImageList(lobbyScriptUnit.PlayerIconTypeIcons[i]).Width + 1);
      end;
    end;


  if TClient(cList[realIndex]).GetAccess then
    PlayerStateImageList.Draw((Control as TTntListBox).Canvas, xpos, Rect.Top, 4);

  finally
    cList.Free;
  end;
end;

procedure TMainForm.TryToDisconnect;
begin;
  try
    AcquireMainThread;
    try if not Preferences.ScriptsDisabled then handlers.onDisconnect; except end;
    ReleaseMainThread;
    if BattleForm.IsBattleActive then
      BattleForm.DisconnectButtonClick(nil);
    TryToSendCommand('EXIT');
    Socket.CloseDelayed; // we must call CloseDelayed and not just Close, because this method is called from various methods and events like OnDataAvailable!
    MainForm.MainTitleBar.Caption := PROGRAM_VERSION;
    MainForm.Caption := PROGRAM_VERSION;
  except
    AddMainLog(_('Error while trying to disconnect!'), Colors.Error);
  end;
end;

procedure TMainForm.TryToConnect;
begin
  TryToConnect(Preferences.ServerIP, Preferences.ServerPort);
  Status.CurrentAwayItem := -2; // status : available
end;

procedure TMainForm.TryToConnect(ServerAddress, ServerPort: string; DontRecoToBackup : boolean = false);
var
  bufsize: Integer;
begin
  if Status.ConnectionState <> Disconnected then TryToDisconnect;

  try
    if Preferences.UseProxy then
    begin
      Socket.SocksServer := Preferences.ProxyAddress;
      Socket.SocksPort := IntToStr(Preferences.ProxyPort);
      if Preferences.ProxyUsername <> '' then
      begin
        Socket.SocksAuthentication:=socksAuthenticateUsercode;
        Socket.SocksUsercode := Preferences.ProxyUsername;
        Socket.SocksPassword := Preferences.ProxyPassword;
      end
      else
        Socket.SocksAuthentication:=socksNoAuthentication;
    end;
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
    //TGetInternetIpThread.Create(false);
  except
    AddMainLog('Error: cannot connect! (' + ServerAddress + ':' + ServerPort + ')', Colors.Error);
    if Preferences.ReconnectToBackup and not DontRecoToBackup then PostMessage(MainForm.Handle, WM_CONNECT_TO_NEXT_HOST, 0, 0);
  end;
end;

procedure TMainForm.OnConnectToNextHostMessage(var Msg: TMessage); // responds to WM_CONNECT_TO_NEXT_HOST message
var
  i: Integer;
  found: Boolean;

  procedure Reconnect(Address: string; Port: string);
  begin
    AddMainLog(_('Trying next host in the list ...'), Colors.Info);
    TryToConnect(Address, Port);
  end;

begin
  found := False;

  for i := 0 to High(ServerList) do
  if (ServerList[i].Port = Socket.Port) and ((ServerList[i].Address = Socket.Addr) or ((Socket.Addr = Preferences.RedirectIP) and (ServerList[i].Address = Preferences.ServerIP))) then
  begin
    found := True;

    if i = High(ServerList) then
    begin
      // ok we've reached the end of the list, there is nothing more we can do, let's just cancel connecting
      Exit;
    end;

    Reconnect(ServerList[i+1].Address,ServerList[i+1].Port);
    Break;
  end;

  if not found and (Length(ServerList) > 0) then
  begin
    // try the first server in the list
    Reconnect(ServerList[0].Address,ServerList[0].Port);
  end;
end;

procedure TMainForm.OnScriptMessage(var Msg: TMessage);
begin
  case Msg.WParam of
    0: // AddToTextBox
      LobbyScriptUnit.PostMsgs;
    1: // LeaveBattle
    begin
      BattleForm.DisconnectButtonClick;
    end;
    2: // JoinBattle
    begin
      LobbyScriptUnit.JoinBattle;
    end;
    3: // ChangeMap
    begin
      LobbyScriptUnit.ChangeMap;
    end;
    4: // HostBattle
    begin
      LobbyScriptUnit.HostBattle;
    end;
    5: // DownloadMap DownloadMod
    begin
      LobbyScriptUnit.StartDownloads;
    end;
    6: // TGUI.SynchronizedUpdate
    begin
      GUISynchronizedUpdate(PGUIUpdateCallback(Msg.LParam));
    end;
  end;
end;

procedure TMainForm.TryToSendDataDirectly(s: string); // deprecated - use TryToSendCommand method instead!
begin;
  if Status.ConnectionState <> Connected then
  begin
    AddMainLog(_('Error: Must be connected to send data!'), Colors.Error);
    Exit;
  end;

  try
    Socket.SendLine(s);
    Inc(Status.CumulativeDataSent, Length(s));
    if Debug.Enabled and ((not Debug.FilterPingPong) or (s <> 'PING')) then
      if ((Pos('USERID ',s) = 0) and (Pos(IntToHex(Misc.GetLobbyUserID, 1),s) = 0)) or Status.Me.GetAccess then
        AddMainLog('Client: "' + s + '"', Colors.Data);
    Status.TimeOfLastDataSent := GetTickCount;
  except
    AddMainLog(_('Error: cannot send data: "') + s + _('"'), Colors.Error);
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
  i: integer;
begin;
  if IgnoreNextTASClientChanJoin and (LowerCase(Command) = 'join') and SendParams and (LowerCase(Params) = 'tasclient') then
  begin
    AutoJoinTASClient := True;
    Exit;
  end;
  // assign unique message(command) ID:
  if AssignID then
  begin
    Status.CurrentMsgID := (Status.CurrentMsgID + 1) mod MAX_MSG_ID;
    Result := Status.CurrentMsgID;
  end
  else Result := -1;

  if (HostBattleForm.relayHoster <> nil) and BattleForm.IsBattleActive then
    for i:=0 to High(RelayedCommands) do
      if UpperCase(RelayedCommands[i]) = Command then
      begin
        SendParams := True;
        Params := HostBattleForm.relayHoster.Name + ' !'+LowerCase(Command)+' '+Params;
        Command := 'SAYPRIVATE';
        break;
      end;

  s := IFF(AssignID, '#' + IntToStr(Result) + ' ', '') + UpperCase(Command) + IFF(SendParams, ' ' + Params, '');

  if Status.ConnectionState <> Connected then
  begin
    AddMainLog(_('Error: Must be connected to send data!'), Colors.Error);
    Exit;
  end;

  if AcquireMainThread then
  begin
  try
    if not Preferences.ScriptsDisabled then
    begin
      s := handlers.handleOut(s);
      i := Pos(#13,s);
      if i = 0 then
        i := Pos(#10,s);
      if i > 0 then
        s := LeftStr(s,i-1);
      if s = '' then
      begin
        exit;
      end;
    end;
  finally
    ReleaseMainThread;
  end;
  end;

  try
    sUTF8 := UTF8Encode(s+EOL);
    Socket.Send(PChar(sUTF8),length(sUTF8));
    Inc(Status.CumulativeDataSent, length(sUTF8));
    if Debug.Enabled and ((not Debug.FilterPingPong) or (Command <> 'PING')) then
      if ((Pos('USERID ',s) = 0) and ((Misc.GetLobbyUserID = 0) or (Pos(IntToHex(Misc.GetLobbyUserID, 1),s) = 0))) or ((Status.Me <> nil) and Status.Me.GetAccess) then
        AddMainLog('Client: "' + s + '"', Colors.Data);
    Status.TimeOfLastDataSent := GetTickCount;
  except
    AddMainLog(_('Error: cannot send data: "') + s + _('"'), Colors.Error);
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
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onLogin(); except end;
  ReleaseMainThread;

  // let's send the login command:
  ReceivedAgreement.Clear; // clear temporary agreement, as server might send us a new one now
  ip := GetLocalIP;
  if ip = '' then ip := '*';
  if ((Password = '') or (Status.ServerMode = 1{LAN MODE}) and not Debug.LoginWithPasswordOnLan) then Password := '*'; // probably local LAN mode. We have to send something as a password, so we just send an "*".
  userid := IntToHex(Misc.GetLobbyUserID, 1);
  TryToSendCommand('LOGIN', Username + ' ' + Password + ' ' + IntToStr(Status.MyCPU) + ' ' + ip + ' TASClient ' + VERSION_NUMBER + '.' + IntToStr(Misc.GetLobbyRevision) + IFF(userid <> '0', #9 + userid, #9+'0')+#9+'a b sp m cl');
end;

procedure TMainForm.TryToRegister(Username, Password: string);
begin;
  if Password = '' then Password := '*'; // we should never send empty password
  TryToSendCommand('REGISTER', Username + ' ' + Password);
end;

function TMainForm.TryToAutoCompleteCommand(word: string; pos: integer;Edit: TTntMemo):string;
var
  i:integer;
  validCommands: TStringList;
  hintStr: string;
  r: TRect;
begin
  Result := word;

  validCommands := TStringList.Create;
  for i:=0 to High(CommandList) do
    if '/'+LowerCase(LeftStr(CommandList[i],pos-1)) = LeftStr(word,pos) then
      validCommands.Add(CommandList[i]);

  autoCompletionHint.ReleaseHandle;

  if validCommands.Count = 0 then Exit;
  
  hintStr := JoinStringList(validCommands,' - ');
  r := autoCompletionHint.CalcHintRect(Edit.Width,hintStr,nil);
  autoCompletionHint.ActivateHint(Rect(Edit.ClientOrigin.X,Edit.ClientOrigin.Y+Edit.Height,Edit.ClientOrigin.X+r.Right,Edit.ClientOrigin.Y+Edit.Height+r.Bottom),hintStr);




  Result := '/'+LowerCase(validCommands[0]);

  for i:=0 to validCommands.Count-1 do
    if '/'+LowerCase(validCommands[i]) = LowerCase(word) then
      if i = validCommands.Count-1 then
      begin
        Result := '/'+LowerCase(validCommands[0]);
        Exit;
      end
      else
      begin
        Result := '/'+LowerCase(validCommands[i+1]);
        Exit;
      end;
end;

// "Edit" must be from TMyTabSheet container! (this method uses clients
procedure TMainForm.TryToAutoCompleteWord(Edit: TTntMemo; Clients: TList);
var
  s: string;
  text: string;
  i,j: Integer;
  found: Boolean;
  startpos: Integer;
  SortedClientsList: TStringList;
  ValidClientsList: TStringList;
  splitedString: TWideStringList;
  completionWordIndex: integer;
  selStart: integer;
  r: TRect;
  hintStr: string;
begin
  if ((Clients.Count = 0) and (LeftStr(Edit.Text,1) <> '/')) or ((Edit.SelLength <> 0) and (Edit.Tag = 0))  or (Edit.Text = '') then
  begin
    Beep;
    Exit;
  end;

  SortedClientsList := TStringList.Create;
  ValidClientsList := TStringList.Create;
  splitedString := TWideStringList.Create;

  try
  for i:=0 to Clients.Count-1 do
  begin
    if TClient(Clients[i]).isRenamed then
      SortedClientsList.Add(TClient(Clients[i]).DisplayName);
    SortedClientsList.Add(TClient(Clients[i]).Name);
  end;

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
    Edit.Tag := Edit.SelStart - (j-Length(splitedString[completionWordIndex])-1);
    splitedString[i] := LeftStr(splitedString[completionWordIndex],Edit.Tag);
    autoCompleteString := LowerCase(splitedString[completionWordIndex]);
  end;

  if (LeftStr(Edit.Text,1) = '/') and (completionWordIndex = 0) then
  begin
    splitedString[completionWordIndex] := TryToAutoCompleteCommand(splitedString[completionWordIndex],Edit.Tag,Edit);
  end
  else
  begin
    // extract the good ones
    for i:=0 to SortedClientsList.Count-1 do
      if autoCompleteString = LowerCase(LeftStr(SortedClientsList[i],Length(autoCompleteString))) then
        ValidClientsList.Add(SortedClientsList[i]);
    for i:=0 to SortedClientsList.Count-1 do
      if (ValidClientsList.IndexOf(SortedClientsList[i]) = -1) and  (Pos(autoCompleteString,LowerCase(SortedClientsList[i])) > 0) then
        ValidClientsList.Add(SortedClientsList[i]);


    autoCompletionHint.ReleaseHandle;
    
    if ValidClientsList.Count = 0 then
    begin
      Beep;
      Exit;
    end;


    hintStr := JoinStringList(ValidClientsList,' - ');
    r := autoCompletionHint.CalcHintRect(Edit.Width,hintStr,nil);
    autoCompletionHint.ActivateHint(Rect(Edit.ClientOrigin.X,Edit.ClientOrigin.Y+Edit.Height,Edit.ClientOrigin.X+r.Right,Edit.ClientOrigin.Y+Edit.Height+r.Bottom),hintStr);


    // we replace the username
    if Length(splitedString[completionWordIndex]) = Edit.Tag then // is it the first tab we do ?
      splitedString[completionWordIndex] := ValidClientsList[0]
    else
    begin
      j := 0;
      for i:=0 to ValidClientsList.Count-1 do
        if LowerCase(ValidClientsList[i]) = LowerCase(splitedString[completionWordIndex]) then
        begin
          j := i;
          break;
        end;
      if j = ValidClientsList.Count-1 then
        j:=-1;
      splitedString[completionWordIndex] := ValidClientsList[j+1];
    end;
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
      LogonForm.btLogin.ImageIndex := ConnectButton.ImageIndex;
      Status.ConnectionState := Connecting;
      AddMainLog(_('Connecting to ') + Socket.Addr + ' ...', Colors.Info);
    end;

    wsConnected:
    begin
     // we ignore this state change here because we process it in OnSessionConnected event!
    end;

    wsClosed, wsInvalidState:
    begin
      if BattleForm.IsBattleActive and (BattleState.Battle <> nil) then
      begin
        BattleForm.ResetBattleScreen; // we have to check if BattleState.Battle <> nil, because this event is also triggered when form is closing and BattleForm has already been freed
        BattleState.Status := None;
      end;
      BattleState.Status := None;
      BattleState.JoiningBattle := False;
      while Battles.Count > 0 do RemoveBattleByIndex(0); // remove all battles
      ConnectButton.ImageIndex := 0;
      LogonForm.btLogin.ImageIndex := ConnectButton.ImageIndex;
      if Status.ConnectionState = Connecting then
      begin
        AddMainLog(_('Cannot connect to server!'), Colors.Info);
        if Preferences.ReconnectToBackup then PostMessage(MainForm.Handle, WM_CONNECT_TO_NEXT_HOST, 0, 0);
      end
      else AddMainLog(_('Connection to server closed!'), Colors.Info);
      if Status.LoggedIn then
        for i := ChatTabs.Count-1 downto 1 do
          if TMyTabSheet(MainForm.ChatTabs[i]).Caption[1] = '#' then // a channel
            if TMyTabSheet(MainForm.ChatTabs[i]).Clients.Count <> 0 then // if 0 clients, then we are not in this channel anymore
              AddTextToChatWindow(TMyTabSheet(MainForm.ChatTabs[i]), _('* Disconnected'), Colors.Info,true);
      ClearClientsLists;
      AcquireMainThread;
      try if not Preferences.ScriptsDisabled then handlers.onDisconnect; except end;
      ReleaseMainThread;
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
  Status.CumulativeDataSentHistory.Clear;
  Status.CumulativeDataSentHistory.Add(0);

  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onConnected(); except end;
  ReleaseMainThread;

  AddMainLog(_('Connection established to ') + Socket.Addr, Colors.Info);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Socket.Free;
  ClearAllClientsList;
  AllClients.Free;
  Utility.DeInitLib;
  ReplayList.Free;
  DeinitializeFlagBitmaps;
  PyEngine.Finalize;
  PyEngine.UnloadDll;
end;

procedure TMainForm.KeepAliveTimerTimer(Sender: TObject);
var
  i: Integer;
  p: TPoint;
begin
  // cursor moved
  GetCursorPos(p);
  if (p.X <> LastCursorPos.X) and (p.Y <> LastCursorPos.Y)then
  begin
    autoCompletionHint.ReleaseHandle;
    Status.AwayTime := GetTickCount;
    AutoSetBack;
  end;
  LastCursorPos := p;

  // lets purge the Pings list:
  i := 0;
  while i < Pings.Count do
  begin
    if GetTickCount - PPingInfo(Pings[i]).TimeSent > 15000 then
    begin
      AddMainLog(_('Ping dropped locally (timeout)'), Colors.Error);
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
    AddMainLog(_('Timeout assumed. Disconnecting ...'), Colors.Error);
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
    
    if length(s) = 0 then
    begin
      s := LeftBStr(sBuffer,len);
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
  if (Sender is TPageControl) and (TPageControl(Sender).ActivePage.ControlCount > 0) and (TPageControl(Sender).ActivePage.Controls[0] is TMyTabSheet) then
    TMyTabSheet(TPageControl(Sender).ActivePage.Controls[0]).OnActivate(TPageControl(Sender).ActivePage.Controls[0]);

  if (Sender is TPageControl) and (TPageControl(Sender).ActivePage.ControlCount > 0) then
    try
      TPageControl(Sender).ActivePage.Caption := TPanel(TPageControl(Sender).ActivePage.Controls[0]).Caption;
    except
    end;

  UpdateClientsListBox;
//***  windows.beep(500, 300);

  (Sender as TPageControl).ActivePage.Highlighted := False;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  i,j:integer;
begin
  PreferencesForm.ApplyAfterTranslate;
  if MainPCH.PageControl.PageCount > 0 then
    MainPCH.PageControl.OnChange(MainPCH.PageControl);
  // set focus to TEdit control (we need to do this only once for 1 page only, and TEdit control will always receive focus with any new page):
  //(PageControl1.ActivePage.Controls[0] as TTntMemo).SetFocus;

  // small fix for weird tab captions
    for j:=0 to DockHandler.PageControlHostCount-1 do
      for i:=0 to DockHandler.PageControlHosts[j].PageControl.PageCount-1 do
        try
          DockHandler.PageControlHosts[j].PageControl.Pages[i].Caption := TPanel(DockHandler.PageControlHosts[j].PageControl.Pages[i].Controls[0]).Caption;
        except
        end;

  // fuckin buggy delphi + sptbx need a fuckin hack for this fuckin form because of a fuckin random bug happening JUST ON THIS FUCKIN FORM
  if Preferences.ThemeType <> sknSkin then
  begin
    MapListForm.SpTBXTitleBar1.Active := True;
    MapListForm.SpTBXTitleBar1.Active := False;
  end;

  MainForm.mnuLockViewClick(nil);

  if not Status.LoggedIn and Preferences.UseLogonForm and not RunningWithMainMenu and (SplashScreenForm = nil) then
    LogonForm.Show;
end;

{ opens a private chat with ClientName if it doesn't already exist.
  If it does, it just focuses it. }
procedure TMainForm.OpenPrivateChat(Client: TClient);
var
  i: Integer;
  tmpEd : TTntMemo;
begin
  if Client = Status.Me then
  begin
    MessageDlg(_('Feel like talking to yourself? No way!'), mtInformation, [mbOK], 0);
    Exit; // can't talk to yourself! (although possible! :-)
  end;

  i := GetTabWindowPageIndex(Client);
  if i = -1 then
  begin
    ChatTabs.Add(AddTabWindow(Client.DisplayName, True, Client.Id));
    i := ChatTabs.Count-1;
  end;
  //else
    //if TMyTabSheet(MainForm.ChatTabs[i]).Visible then
      //ChangeActivePageAndUpdate(PageControl1, i);

//  RemoveAllClientsFromTab(PageControl1.Pages[i] as TMyTabSheet);
  if not AddClientToTab(TMyTabSheet(MainForm.ChatTabs[i]).Clients, Client.Name) then ; // nevermind, just ignore it

  UpdateClientsListBox;

  tmped := TMyTabSheet(MainForm.ChatTabs[i]).FindChildControl('InputEdit') as TTntMemo;
  if tmped <> nil then
    Misc.ShowAndSetFocus(tmped); // switch focus to chat window
end;

procedure TMainForm.ClientsListBoxDblClick(Sender: TObject);
var
  ClientName: WideString;
  index: integer;
  cList: TList;
  i:integer;
begin
  index := TTntListBox(Sender).ItemIndex;
  if index = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item


  cList := TList.Create;
  GetDrawItemClientList(TTntListBox(Sender),cList);

  if cList = nil then Exit;

  ClientName := TClient(cList[index]).Name;

  OpenPrivateChat(TClient(cList[index]));

  cList.Free;
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
  s2: string;
  R: TRect;
  X: Integer;
  Battle: TBattle;
  i:integer;
  avgRank:float;
  BgRect: TRect;
  pt: TPoint;
  checkImgIdx: Integer;
  hot: Boolean;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
  FlagBitmap: TBitmap;
begin
  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    try
    Battle := GetBattleFromNode(Node);

    R := ContentRect;
    CopyRect(BgRect,CellRect);
    {if Position <> 0 then
      BgRect.Left := -3;
    if Position <> Header.Columns.Count-1 then
      BgRect.Right := BgRect.Right+3;}

    GetCursorPos(pt);
    pt := ScreenToClient(pt);
    GetHitTestInfoAt(pt.X,pt.Y,True,hi);
    
    if MainForm.Active and (hi.HitNode = Node) then
    begin
      checkImgIdx := 1;
      hot := True;
    end
    else
    begin
      checkImgIdx := 0;
      hot := False;
    end;

    if SkinManager.GetSkinType=sknSkin then
    begin
      if (Battle.GetHighlightColor <> VDTBattles.Color) and not hot and not ((Node = FocusedNode) and focused) then
      begin
        Canvas.Brush.Color := Battle.GetHighlightColor;
        Canvas.Font.Color := Misc.ComplementaryTextColor(Canvas.Brush.Color);//SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsNormal);
        Canvas.FillRect(CellRect);
      end
      else
      begin
        itemState := SkinManager.CurrentSkin.GetState(True,False,hot,(Node = FocusedNode) and focused);
        Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,itemState);
        SkinManager.CurrentSkin.PaintBackground(Canvas,BgRect,skncListItem,itemState,True,True);
      end;
      //if Column = 0 then
      //  CheckImages.Draw(Canvas,3,0,checkImgIdx);
      Canvas.Brush.Style := Graphics.bsClear;
    end
    else if (Node = FocusedNode) and focused then
    begin
      Canvas.Font.Color := clHighlightText;
      Canvas.Brush.Color := clHighlight;
      Canvas.FillRect(CellRect);
    end
    else
    begin
      Canvas.Brush.Color := Battle.GetHighlightColor;
      Canvas.FillRect(CellRect);
      Canvas.Font.Color := IFF(Battle.GetHighlightColor <> VDTBattles.Color,Misc.ComplementaryTextColor(Canvas.Brush.Color),clWindowText);
    end;

    if Column = 0 then
      CheckImages.Draw(Canvas,3,0,checkImgIdx);

    InflateRect(R, TextMargin, 0);
    if Column = 0 then
    begin
      InflateRect(R, -TextMargin+2, 0);
    end;

    InflateRect(R, -TextMargin, 0);

    Dec(R.Right);
    Dec(R.Bottom);
    s := ' ';

    case Column of
      0: // join
      ;
      1: // description
      begin
        s := Battle.Description; // game's name (description, title)
      end;
      2: // host
      begin
        s := TClient(Battle.Clients[0]).DisplayName;
        if Preferences.ShowFlags then
        begin
          FlagBitmap := GetFlagBitmap(TClient(Battle.Clients[0]).Country);
          Canvas.Draw(R.Left, R.Top + 16 div 2 - FlagBitmap.Height div 2, FlagBitmap);
          Inc(R.Left, FlagBitmap.Width + 5);
        end;
      end;
      3: // map
      begin
        if Preferences.MarkUnknownMaps then
          if Utility.MapList.IndexOf(Battle.Map) = -1 then
            Canvas.Font.Color := MainUnit.Colors.MapModUnavailable;
        s := Copy(Battle.Map, 1, Length(Battle.Map));
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
        avgRank := Battle.GetAvgRank;
        RanksImageList.Draw(Canvas, R.Left, R.Top, Round(avgRank));
        Inc(R.Left, RanksImageList.Width);
        s := FloatToStrF(RoundTo(avgRank+1,-2),ffFixed,7,2);
      end;
      7: // length
      begin
        if Battle.IsBattleInProgress then
          if Battle.StartTimeUknown then
          begin
            DateTimeToString(s2,'h:nn:ss',Now-Battle.StartTime);
            DrawTextW(Canvas.Handle, '>', 1, R, DT_TOP or DT_LEFT or DT_VCENTER or DT_SINGLELINE, False);
            R.Left := R.Left + Canvas.TextWidth('> ');
            s := s2;
          end
          else
          begin
            DateTimeToString(s2,'h:nn:ss',Now-Battle.StartTime);
            R.Left := R.Left + Canvas.TextWidth('> ');
            s := s2;
          end
        else
          s := '';
      end;
      8: // players
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
      9: // engine
      begin
        s := Battle.EngineName + ' ' + Battle.EngineVersion;
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
    except
      Canvas.TextOut(ContentRect.Left, ContentRect.Top, 'Error');
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

  try

  Battle := GetBattleFromNode(Node);

  case Column of
    0: NodeWidth := ButtonImageList.Width; // join
    1:
    begin // description
      NodeWidth := Canvas.TextWidth(Battle.Description) + 2 * AMargin;
    end;
    2: NodeWidth := Canvas.TextWidth(TClient(Battle.Clients[0]).Name) + 2 * AMargin; // host
    3: NodeWidth := Canvas.TextWidth(Copy(Battle.Map, 1, Length(Battle.Map)-4)) + 2 * AMargin; // map
    4: // state
    begin
      NodeWidth := BattleStatusImageList.Width;
      if Battle.RankLimit > 0 then Inc(NodeWidth, BattleStatusImageList.Width);
      if (Preferences.WarnIfUsingNATTraversing) and (Battle.NATType > 0) then Inc(NodeWidth, BattleStatusImageList.Width);
    end;
    5: NodeWidth := Canvas.TextWidth(Battle.ModName) + 2 * AMargin; // mod
    7: NodeWidth := Canvas.TextWidth('?:??:?');
    8: // players
    begin
      s := IntToStr(Battle.Clients.Count - Battle.SpectatorCount);
      if Battle.SpectatorCount > 0 then s := s + '+' + IntToStr(Battle.SpectatorCount);
      s := s + '/' + IntToStr(Battle.MaxPlayers) + ' (' + Battle.ClientsToString + ')';
      NodeWidth := Canvas.TextWidth(s) + 2 * AMargin; // players
    end;
    9: NodeWidth := Canvas.TextWidth(Battle.EngineName + ' ' + Battle.EngineVersion);
  end; // case

  except
    NodeWidth := Canvas.TextWidth('Error') + 2 * AMargin;
  end;
end;

procedure TMainForm.VDTBattlesChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if AutoJoinForm.chkStopAutoJoinWhenLeaving.Checked then
  begin
    mnuAutoplayFirstAvailable.Checked := False;
    mnuAutospecFirstAvailable.Checked := False;
  end;
  JoinBattle(GetBattleFromNode(Node));
end;

procedure TMainForm.JoinBattle(Battle: TBattle; SpecatorMode: Boolean = False; Password: string = '');
var
  s: string;
  res: Integer;
  url: string;
  i:integer;
  osVerInfo: TOSVersionInfo;
begin
  if BattleState.JoiningBattle then
  begin
    AddMainLog(_('You are already joining a battle ...'),Colors.Error);
    Exit;
  end;

  // is battle locked?
  if Battle.Locked then
  begin
    if not LobbyScriptUnit.ScriptJoining then
      MessageDlg(_('Can''t join: battle is locked!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if BattleForm.IsBattleActive and (BattleState.Battle <> Battle) then
  begin
    //MessageDlg('You must first disconnect from current battle!', mtInformation, [mbOK], 0);
    if Battle = BattleState.Battle then Exit;
    if LobbyScriptUnit.ScriptJoining or (MessageDlg(_('Do you want to disconnect from the current battle to join this one ?'),mtConfirmation, [mbYes,mbNo], 0) = mrYes) then
      BattleForm.DisconnectButtonClick(nil)
    else
      Exit;
  end;

  // check the engine name
  if Battle.EngineName <> 'spring' then
  begin
    if not LobbyScriptUnit.ScriptJoining then
      MessageDlg(_('Can''t join: currently, only the spring engine is supported !'), mtWarning, [mbOK], 0);
    Exit;
  end;

  // multiple engine is only supported on vista and later
  if Status.MySpringVersion <> Battle.EngineVersion then
  begin
    osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo) ;
    if GetVersionEx(osVerInfo) then
    begin
      if osVerInfo.dwMajorVersion < 6 then
      begin
        if not LobbyScriptUnit.ScriptJoining then
          MessageDlg(_('Can''t join: tasclient only support multi engine on Windows Vista and later systems !'), mtWarning, [mbOK], 0);
        Exit;
      end;
    end;
  end;

  // check if the engine version is available
  if (Status.MySpringVersion <> Battle.EngineVersion) and NOT FileExists(ExtractFilePath(Application.ExeName)+'engine\'+Battle.EngineVersion+'\spring.exe') then
  begin
    if not LobbyScriptUnit.ScriptJoining then
      if Preferences.EnableSpringDownloader or (MessageDlg(_('To join this battle, you need to download its engine, do you want to open a browser to a download page ?'),mtConfirmation,[mbYes,mbNo],0) = mrYes) then
        SpringDownloaderFormUnit.DownloadEngine(Battle.EngineName,Battle.EngineVersion, false, Battle.ID);
    Exit;
  end;

  // check if we have the mod at all:
  if ModList.IndexOf(Battle.ModName) = -1 then
  begin
    // try refreshing the mod list, perhaps user has just installed the mod:
    HostBattleForm.RefreshModListButton.OnClick(HostBattleForm.RefreshModListButton);

    if ModList.IndexOf(Battle.ModName) = -1 then
    begin
      if not LobbyScriptUnit.ScriptJoining then
        if Preferences.EnableSpringDownloader or (MessageDlg(_('To join this battle, you need to download its mod, do you want to open a browser to a download page ?'),mtConfirmation,[mbYes,mbNo],0) = mrYes) then
          SpringDownloaderFormUnit.DownloadMod(0,Battle.ModName,false,Battle.ID);
      Exit;
    end;
  end;

  // is this battle replay and battle is full?
  if (Battle.BattleType = 1) and (Battle.IsBattleFull) then
  begin
    if not LobbyScriptUnit.ScriptJoining then
      MessageDlg(_('Can''t join: battle is full!'), mtInformation, [mbOK], 0);
    Exit;
  end;

  // is our rank to low to join this battle?
  if not LobbyScriptUnit.ScriptJoining then
    if Battle.RankLimit > Status.MyRank then
      if MessageDlg(_('This battle requires a rank of <') + Ranks[Battle.RankLimit] + _('>.') +#13+
                    _('It is impolite to join a battle which requires a rank which you don''t have.') +#13+#13+
                    _('Do you wish to attempt to join this battle anyway?'), mtWarning, [mbNo, mbYes], 0) = mrNo then Exit;

  if Battle.Password and (Password = '') then
  begin
    if LobbyScriptUnit.ScriptJoining then
      Exit
    else if not InputQuery(_('Password'), _('Password:'), Password) then
      Exit;
  end;

  JoinAsSpectator := SpecatorMode;

  // acquire public UDP source port from the server if battle host uses "hole punching" technique:
  if Battle.NATType = 1 then  // "hole punching" method
  begin
    // let's acquire our public UDP source port from the server:
    InitWaitForm.ChangeCaption(MSG_GETHOSTPORT);
    InitWaitForm.TakeAction := 2; // get host port
    res := InitWaitForm.ShowModal;
    if res <> mrOK then
    begin
      if not LobbyScriptUnit.ScriptJoining then
        MessageDlg(_('Unable to acquire UDP source port from server. Try choosing another NAT traversal technique!'), mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

  BattleState.Password := Password;
  BattleState.JoiningBattle := True;
  Randomize;
  Status.Me.BattleJoinPassword := IntToHex(Random(MaxInt),8);
  TryToSendCommand('JOINBATTLE', IntToStr(Battle.ID) + IFF(Password <> '', ' ' + Password, ' ')+' '+Status.Me.BattleJoinPassword);
end;

procedure TMainForm.VDTBattlesDblClick(Sender: TObject);
begin
  if VDTBattles.FocusedNode = nil then Exit;

  VDTBattles.OnChecked(VDTBattles, VDTBattles.FocusedNode);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Status.LoggedIn then
    TryToDisconnect;
    
  ClearAllClientsList;

  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onClose; except end;

  NewsPanel.Visible := False;

  HighlighBattlesTimer.Enabled := False;
  KeepAliveTimer.Enabled := False;

  if Debug.Log then (TMyTabSheet(MainForm.ChatTabs[0]).FindChildControl('RichEdit') as TExRichEdit).Lines.SaveToFile(ExtractFilePath(Application.ExeName) + LOG_FILENAME);
  if FiltersButton.ImageIndex = 1 then
  begin
    FilterGroup.Height := 0;
    MainDockPanel.Height := MainDockPanel.Height + 173;
    FiltersButton.ImageIndex := 0;
  end;
  if SaveToRegOnExit then PreferencesForm.WritePreferencesToRegistry;

  NotificationsForm.SaveNotificationListToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\notify.dat');
  PerformForm.SaveCommandListToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\perform.dat');
  HighlightingForm.SaveHighlightsToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\highlights.dat');
  SaveFiltersToFile(CurrentFilters);
  AutoJoinForm.SaveAutoJoinPreset(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\current.ini');
  ReplaysForm.SaveReplayFiltersToFile(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER + '\current.ini');
  if RunningWithMainMenu then
    MenuForm.SaveSettings;
  SaveGroups;
  ClientsDataIni.UpdateFile;
  ClientsDataIni.Free;

  if Preferences.EnableSpringDownloader then
    CloseSpringDownloader;

  Misc.SetRegistryData(HKEY_CURRENT_USER,TASCLIENT_REGISTRY_KEY,'Crashed',rdInteger,Misc.BoolToInt(False));

  Application.Terminate;
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
  richContextMenu.Lines.Clear;
end;

procedure TMainForm.ReplaysButtonClick(Sender: TObject);
begin
  if ReplaysForm.LoadingPanel.Visible then
    Misc.ShowAndSetFocus(ReplaysForm.LoadingPanel)
  else
    Misc.ShowAndSetFocus(ReplaysForm.VDTReplays);
  TipsForm.ShowTips(4);
end;

procedure TMainForm.SortLabelClick(Sender: TObject);
var
  p: TPoint;
begin
  with SortLabel do
    p := ClientToScreen(Point(0, 0));

  SortPopupMenu.Popup(p.x, p.y);
end;

function TMainForm.CompareClients(Client1: TClient; Client2: TClient; SortStyle: Integer; SortAsc: Boolean): Shortint;
var
  group1,group2: TCLientGroup;
begin
  case SortStyle of
    0: Result := 0; // no sorting
    // sort by name:
    1: Result := CompareArgs([Client1.DisplayName],[Client2.DisplayName]);
    // sort by status:
    2: Result := CompareArgs([Client1.GetAwayStatus, Client1.GetInGameStatus, Client1.InBattle, Client1.DisplayName],[Client2.GetAwayStatus, Client2.GetInGameStatus, Client2.InBattle, Client2.DisplayName]);
    // sort by rank:
    3: Result := CompareArgs([Client1.GetRank ,Client1.DisplayName],[Client2.GetRank ,Client2.DisplayName]);
    // sort by country:
    4: Result := CompareArgs([Client1.Country ,Client1.DisplayName],[Client2.Country ,Client2.DisplayName]);
    // sort by group (then by name):
    5:
      if (((Client1.GetGroup = nil) or (not Client1.GetGroup.EnableColor)) and ((Client2.GetGroup = nil) or (not Client2.GetGroup.EnableColor))) or (Client1.GetGroup = Client2.GetGroup) then
        Result := CompareArgs([Client1.DisplayName],[Client2.DisplayName])
      else
        if (Client1.GetGroup = nil) or not Client1.GetGroup.EnableColor then
          Result := 1
        else if (Client2.GetGroup = nil) or not Client2.GetGroup.EnableColor then
          Result := -1
        else
          Result := CompareStr(Client2.GetGroup.Name,Client1.GetGroup.Name)
  else
    Result := 0;
  end;

  if not SortAsc then
    Result := Result * -1;
end;

function TMainForm.CompareBattles(Battle1, Battle2: TBattle; SortStyle: Integer; SortDirection: Boolean; CountMe: Boolean = False): Shortint;
var
  avgRank1,avgRank2: float;
  i:integer;
  asc: ShortInt;
  meAsPlayer1,meAsSpec1,meAsPlayer2,meAsSpec2: integer;
begin
  if SortDirection then asc := 1 else asc := -1;
  case SortStyle of
    0: Result := 0; // no sorting
    // sort by battle status:
    1: Result := CompareArgs([Battle1.Clients.Count-Battle1.SpectatorCount = 0,Battle1.IsBattleInProgress, not Battle1.IsBattleInProgress and Battle1.IsBattleFull, Battle1.Password, Battle1.Locked],[Battle2.Clients.Count-Battle2.SpectatorCount = 0, Battle2.IsBattleInProgress, not Battle2.IsBattleInProgress and Battle2.IsBattleFull, Battle2.Password, Battle2.Locked]);
    // sort by mod:
    2: Result := CompareArgs([Battle1.ModName],[Battle2.ModName]);
    // sort by players:
    3:
    begin
        meAsPlayer1 := 0;
        meAsSpec1 := 0;
        meAsPlayer2 := 0;
        meAsSpec2 := 0;
        if not CountMe then
        begin
          if Status.Me.InBattle and (Battle1.Clients.IndexOf(Status.Me) > -1) then
            if Status.Me.GetMode = 1 then
              meAsPlayer1 := 1
            else
              meAsSpec1 := 1
          else if Status.Me.InBattle and (Battle2.Clients.IndexOf(Status.Me) > -1) then
            if Status.Me.GetMode = 1 then
              meAsPlayer2 := 1
            else
              meAsSpec2 := 1;
        end;
        Result := CompareArgs([Battle1.Clients.Count - Battle1.SpectatorCount - meAsPlayer1, Battle1.SpectatorCount-meAsSpec1],[Battle2.Clients.Count - Battle2.SpectatorCount - meAsPlayer2, Battle2.SpectatorCount-meAsSpec2]);
    end;
    // sort by map:
    4: Result := CompareArgs([Battle1.Map],[Battle2.Map]);
    // sort by host:
    5: Result := CompareArgs([TClient(Battle1.Clients[0]).DisplayName],[TClient(Battle2.Clients[0]).DisplayName]);
    // sort by average rank
    6:
    begin
      avgRank1 := 0;
      for i:=0 to Battle1.Clients.Count-1 do
        if (Battle1.Clients[i] <> Status.Me) or CountMe then
          avgRank1 := avgRank1 + TClient(Battle1.Clients[i]).GetRank;
      avgRank1 := avgRank1 / Battle1.Clients.Count;
      avgRank2 := 0;
      for i:=0 to Battle2.Clients.Count-1 do
        if (Battle2.Clients[i] <> Status.Me) or CountMe then
          avgRank2 := avgRank2 + TClient(Battle2.Clients[i]).GetRank;
      avgRank2 := avgRank2 / Battle2.Clients.Count;
      Result := CompareArgs([avgRank1],[avgRank2]);
    end;
    // sort by description:
    7:  Result := CompareArgs([Battle1.Description],[Battle2.Description]);
    8:  Result := CompareArgs([Battle1.IsBattleInProgress, -Battle1.StartTime],[Battle2.IsBattleInProgress, -Battle2.StartTime]);
    // sort by players/maxplayers
    9:
    begin
        meAsPlayer1 := 0;
        meAsSpec1 := 0;
        meAsPlayer2 := 0;
        meAsSpec2 := 0;
        if not CountMe then
        begin
          if Status.Me.InBattle and (Battle1.Clients.IndexOf(Status.Me) > -1) then
            if Status.Me.GetMode = 1 then
              meAsPlayer1 := 1
            else
              meAsSpec1 := 1
          else if Status.Me.InBattle and (Battle2.Clients.IndexOf(Status.Me) > -1) then
            if Status.Me.GetMode = 1 then
              meAsPlayer2 := 1
            else
              meAsSpec2 := 1;
        end;
        Result := CompareArgs([(Battle1.Clients.Count - Battle1.SpectatorCount - meAsPlayer1)/Battle1.MaxPlayers, Battle1.SpectatorCount-meAsSpec1],[(Battle2.Clients.Count - Battle2.SpectatorCount - meAsPlayer2)/Battle2.MaxPlayers, Battle2.SpectatorCount-meAsSpec2]);
    end;
  else
    Result := 0;
  end; // case
  Result := asc*Result;
end;

procedure TMainForm.SortClientsList(List: TList; SortStyle: Integer; SortAsc: Boolean);
begin
  List.Sort(ClientSortCompare);
end;

function ClientSortCompare(Item1, Item2: Pointer): Integer;
begin
  Result := MainForm.CompareClients(TClient(Item1), TClient(Item2), Preferences.SortStyle,Preferences.SortAsc);
end;
function BattleSortCompare(Item1, Item2: Pointer): Integer;
begin
  if TObject(Item2) is TBattle then
    if TObject(Item1) is TBattle then
      Result := MainForm.CompareBattles(TBattle(Item1), TBattle(Item2), BattleSorting, BattleSortingDirection)
    else
      Result := 1
  else
    Result := -1;
end;

procedure TMainForm.SortClientInList(client: TClient;List: TList; SortStyle: Integer; SortAsc: Boolean);
var
  i, index: Integer;
  tmp: TClient;
begin
  index := List.IndexOf(client);
  if index = -1 then Exit;

  for i := Index+1 to List.Count-1 do
    if (CompareClients(TClient(List[index]), TClient(List[i]), SortStyle, SortAsc) > 0) then
    begin
        // swap:
        tmp := List[i];
        List[i] := List[Index];
        List[Index] := tmp;
        Inc(Index);
    end
    else break;

  for i := Index-1 downto 0 do begin
    if (CompareClients(TClient(List[index]), TClient(List[i]), SortStyle, SortAsc) < 0) then
    begin
        // swap:
        tmp := List[i];
        List[i] := List[Index];
        List[Index] := tmp;
        Dec(Index);
    end
    else break;
  end;
end;

{ will sort "Battles" list. It won't invalidate (repaint) VDTBattles tree! Call VDTBattles.Invalidate to do that manually.
  If Ascending is False, then the list will be sorted in descending order. }
procedure TMainForm.SortBattlesList(BattleList: TList; SortStyle: Integer; Ascending: Boolean; CountMe: Boolean = True);
var
  i, index, j: Integer;
  tmp: TBattle;
begin
  {*
  BattleSorting := SortStyle;
  BattleSortingDirection := Ascending;
  BattleList.Sort(BattleSortCompare); // crash when sorting by length ?!?!!!
  *}

  for j := 1 to BattleList.Count-1 do
  begin
    Index := j;
    for i := Index-1 downto 0 do begin
      if (CompareBattles(TBattle(BattleList[Index]), TBattle(BattleList[i]), SortStyle, Ascending, CountMe) < 0) then
      begin
        // swap:
        tmp := BattleList[i];
        BattleList[i] := BattleList[Index];
        BattleList[Index] := tmp;
        Dec(Index);
      end
      else break;
    end;
  end;
end;

procedure TMainForm.RefreshBattlesNodes;
var
  i: Integer;
  tmpNode: PVirtualNode;
begin
  tmpNode := nil;

  tmpNode := VDTBattles.GetFirst();
  for i:=0 to Battles.Count-1 do
    if TBattle(Battles[i]).Visible then begin
      TBattle(Battles[i]).Node := tmpNode;
      tmpNode := VDTBattles.GetNext(tmpNode);
    end
    else
      TBattle(Battles[i]).Node := nil;
  if selectedBattlePlayers <> nil then
  begin
    VDTBattles.FocusedNode := selectedBattlePlayers.Node;
    VDTBattles.Selected[VDTBattles.FocusedNode] := True;
  end;
end;

function TMainForm.isBattleVisible(Battle:TBattle;Filters: TPresetFilters; countMe: Boolean = True):Boolean;
var
  i,j: integer;
  tmpStr: string;
  meAsPlayer : integer;
begin
  if Battle.ForcedHidden then
  begin
    Result := False;
    Exit;
  end;

  // quick text filters
  if BattleFiltersTextbox.Text <> '' then
  begin
    tmpStr := Battle.Description+' '+IFF(TClient(Battle.Clients[0]).isRenamed,TClient(Battle.Clients[0]).Name+' '+TClient(Battle.Clients[0]).DisplayName,TClient(Battle.Clients[0]).Name)+' '+Battle.Map+' '+Battle.ModName+' '+Battle.ClientsToString(' ',True)+' '+Battle.ClientsToString(' ',False);
    try
      if not RegExpr.ExecRegExpr(LowerCase(BattleFiltersTextbox.Text),LowerCase(tmpStr)) then
      begin
        Result := False;
        Exit;
      end;
    except
    end
  end;

  // simple filters
  meAsPlayer := 0;
  if not countMe then
    if BattleForm.IsBattleActive and (Battle.Clients.IndexOf(Status.Me) > -1) and (Status.Me.GetMode = 1) then
      meAsPlayer := 1;

  // advanced filters
  Result :=
      (Filters.Locked or (not Battle.Locked)) and
      (Filters.Passworded or not Battle.Password) and
      (Filters.Full or (not Battle.IsBattleFull)) and
      (Filters.MapNotAvailable or (Utility.MapList.IndexOf(Battle.Map) >-1)) and
      (Filters.ModNotAvailable or (Utility.ModList.IndexOf(Battle.ModName) > -1)) and
      (Filters.InProgress or (not Battle.IsBattleInProgress)) and
      (Filters.NatTraversal or (Battle.NATType = 0)) and
      (Filters.Replays or (Battle.BattleType = 0)) and
      (Filters.RankLimitSupEqMine or (Battle.RankLimit <= Status.Me.GetRank)) and
      (not Filters.Players.enabled or
      ((Filters.Players.filterType = Sup) and (Battle.Clients.Count-Battle.SpectatorCount-meAsPlayer > Filters.Players.value)) or
      ((Filters.Players.filterType = Inf) and (Battle.Clients.Count-Battle.SpectatorCount-meAsPlayer < Filters.Players.value)) or
      ((Filters.Players.filterType = Equal) and (Battle.Clients.Count-Battle.SpectatorCount-meAsPlayer = Filters.Players.value))
      ) and
      (not Filters.Players2.enabled or
      ((Filters.Players2.filterType = Sup) and (Battle.Clients.Count-Battle.SpectatorCount-meAsPlayer > Filters.Players2.value)) or
      ((Filters.Players2.filterType = Inf) and (Battle.Clients.Count-Battle.SpectatorCount-meAsPlayer < Filters.Players2.value)) or
      ((Filters.Players2.filterType = Equal) and (Battle.Clients.Count-Battle.SpectatorCount-meAsPlayer = Filters.Players2.value))
      ) and
      (not Filters.MaxPlayers.enabled or
      ((Filters.MaxPlayers.filterType = Sup) and (Battle.MaxPlayers > Filters.MaxPlayers.value)) or
      ((Filters.MaxPlayers.filterType = Inf) and (Battle.MaxPlayers < Filters.MaxPlayers.value)) or
      ((Filters.MaxPlayers.filterType = Equal) and (Battle.MaxPlayers = Filters.MaxPlayers.value))
      ) and
      (not Filters.AvgRank.enabled or
      ((Filters.AvgRank.filterType = Sup) and (Round(Battle.GetAvgRank+1) > Filters.AvgRank.value)) or
      ((Filters.AvgRank.filterType = Inf) and (Round(Battle.GetAvgRank+1) < Filters.AvgRank.value)) or
      ((Filters.AvgRank.filterType = Equal) and (Round(Battle.GetAvgRank+1) = Filters.AvgRank.value))
      );

  if Result = False then
    Exit;

  for i:=0 to Filters.TextFilters.Count -1 do
  begin
    with TFilterText(Filters.TextFilters[i]^) do
    begin
      if enabled and (value <> '') then
      begin
        if filterType = HostName then
          if TClient(Battle.Clients[0]).isRenamed then
            tmpStr := TClient(Battle.Clients[0]).Name+' '+TClient(Battle.Clients[0]).DisplayName
          else
            tmpStr := TClient(Battle.Clients[0]).Name
        else if filterType = MapName then
          tmpStr := LeftStr(Battle.Map,Length(Battle.Map)) // left to remove the .smf (or whatever the extension is)
        else if filterType = ModName then
          tmpStr := Battle.ModName
        else if filterType = Description then
          tmpStr := Battle.Description
        else if filterType = Players then
          tmpStr := Battle.ClientsToString(' ',True)+' '+Battle.ClientsToString(' ',False)
        else if filterType = AllBattle then
          tmpStr := 'Description="'+Battle.Description+'" Host="'+IFF(TClient(Battle.Clients[0]).isRenamed,TClient(Battle.Clients[0]).Name+' '+TClient(Battle.Clients[0]).DisplayName,TClient(Battle.Clients[0]).Name)+'" Map="'+Battle.Map+'" Mod="'+Battle.ModName+'" Players="'+Battle.ClientsToString(' ',True)+' '+Battle.ClientsToString(' ',False)+'"'
        else
          raise Exception.Create(_('Filter type not handled.'));

        try
          if RegExpr.ExecRegExpr(LowerCase(value),LowerCase(tmpStr)) xor contains then
          begin
            Result := False;
            Exit;
          end;
        except
        end;
      end; // if
    end; // with
  end; // for
end;

procedure TMainForm.RefreshBattleList;
var
  i,j:integer;
  BattleNodeCount : integer;
  tmp : TBattle;
  PTmpNode : PVirtualNode;
  nb:integer;
  caca : string;
begin
  if Status.ConnectionState <> Connected then Exit;

  while RefreshingBattleList do;
  RefreshingBattleList := true;

  j:=0;
  for i:=0 to Battles.Count-1 do begin
    TBattle(Battles[i]).Visible := not EnableFilters.Checked or isBattleVisible(Battles[i],CurrentFilters);
    if TBattle(Battles[i]).Visible then begin
      j:=j+1;
    end;
  end;
  
  nb := VDTBattles.RootNodeCount;
  if j > nb then begin
    for i:=nb to j-1 do begin
      VDTBattles.RootNodeCount := VDTBattles.RootNodeCount+1;
      PTmpNode := VDTBattles.GetLast;
      PTmpNode.CheckType := ctCheckBox;
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
  if selectedBattlePlayers <> nil then
  begin
    VDTBattles.FocusedNode := selectedBattlePlayers.Node;
    VDTBattles.Selected[VDTBattles.FocusedNode] := True;
  end;
  VDTBattles.Invalidate;
  RefreshingBattleList := false;
end;

{ updates position of battle with Index in List. It doesn't repaint VDTBattles, you should do that manually.
  If Ascending is False, then the list will be sorted in descending order. }
procedure TMainForm.SortBattleInList(Index: Integer; SortStyle: Integer; Ascending: Boolean);
var
  i,j: Integer;
  tmp: TBattle;
  tmpNode: PVirtualNode;
begin
  if (Index < 0) or (Index > Battles.Count-1) then Exit; // this should not happen!

  // sort down:
  for i := Index+1 to Battles.Count-1 do
    if (CompareBattles(TBattle(Battles[Index]), TBattle(Battles[i]), SortStyle, Ascending) > 0) then
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
    if (CompareBattles(TBattle(Battles[Index]), TBattle(Battles[i]), SortStyle, Ascending) < 0) then
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
      TBattle(Battles[i]).Node := nil;
      j := j+1;
    end;
   //BattleScreenSpeedButton.Caption := IntToStr(j);
  if selectedBattlePlayers <> nil then
  begin
    VDTBattles.FocusedNode := selectedBattlePlayers.Node;
    VDTBattles.Selected[VDTBattles.FocusedNode] := True;
  end;
end;

procedure TMainForm.SortMenuItemClick(Sender: TObject);
begin
  //(Sender as TSpTBXItem).Checked := True;
  Preferences.SortStyle := (Sender as TSpTBXItem).Tag;
  Preferences.SortAsc := True;
  SortPopupMenu.Items[Preferences.SortStyle].Checked := True;
  SortLabel.ImageIndex := 0;
  SortLabel.Caption := (Sender as TSpTBXItem).Caption;
  ResortClientsLists;
end;

procedure TMainForm.VDTBattlesGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
var
  Battle: TBattle;
  i : integer;
  tmpStr : string;
  maxNameWidth: integer;
  nameWidth: integer;
begin
  R := Rect(0, 0, 0, 0);
  Battle := GetBattleFromNode(Node);

  with (Sender as TVirtualDrawTree) do
    try

    case Column of
      8:
      begin
        maxNameWidth := Canvas.TextWidth(TClient(Battle.Clients[0]).DisplayName);
        for i:=1 to Battle.Clients.Count-1 do
        begin
          nameWidth := Canvas.TextWidth(TClient(Battle.Clients[i]).DisplayName);
          if nameWidth > maxNameWidth then
            maxNameWidth := nameWidth;
        end;

        R := Rect(0,0,10+Ceil(Battle.Clients.Count/8)*(maxNameWidth+20),20+(Canvas.TextHeight('H')+2)*min(Battle.Clients.Count,8));
      end;
      5: R := Rect(0, 0, Canvas.TextWidth(Battle.ModName) + 20, 18);
      4:
      begin
        if Battle.NATType > 0 then
          tmpStr := _(' NAT Traversal enabled, you may not be able to join this battle.');
        if Battle.IsBattleInProgress then
          R := Rect(0, 0, Canvas.TextWidth(_('Battle in progress, you can join it but you will have to wait until it ends.')) + 20, 18)
        else if Battle.Locked then
          R := Rect(0, 0, Canvas.TextWidth(_('Battle locked, you can''t join it.')) + 20, 18)
        else if Battle.Password then
          R := Rect(0, 0, Canvas.TextWidth(_('You need the password to join that battle.')) + 20, 18)
        else if Battle.IsBattleFull then
          R := Rect(0, 0, Canvas.TextWidth(_('The battle is full, you can join but you will be spectator.')+tmpStr) + 20, 18)
        else if Battle.RankLimit > Status.Me.GetRank then
          R := Rect(0, 0, Canvas.TextWidth(_('You don''t have the rank required to join that battle. However you can still try to join it if you think you are good enough.')+tmpStr) + 20, 18)
        else
          R := Rect(0, 0, Canvas.TextWidth(_('Battle opened.')+tmpStr) + 20, 18);
      end;
      3:
      begin
        if Utility.MapList.IndexOf(Battle.Map) > -1 then
          R := Rect(0, 0, 110+250, 120)
        else
          R := Rect(0, 0, Canvas.TextWidth(Battle.Map) + 20, 18);
      end;
      2: R := Rect(0, 0, Canvas.TextWidth(TClient(Battle.Clients[0]).Name) + 20, 18);
      1: R := Rect(0, 0, Canvas.TextWidth(Battle.Description) + 20, 18);
      6: R := Rect(0, 0, Canvas.TextWidth(Header.Columns[Column].Hint) + 20, 18);
      9: R := Rect(0, 0, Canvas.TextWidth(Battle.EngineName + ' ' + Battle.EngineVersion) + 20, 18);
      7: R := Rect(0, 0, Canvas.TextWidth('?:??:?')+20, 18);
    end;
    
    except
      R := Rect(0, 0, Canvas.TextWidth('Error') + 20, 18);
    end;
end;

procedure TMainForm.VDTBattlesDrawHint(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  Battle : TBattle;
  i:integer;
  tmpStr : string;
  s: string;
  maxNameWidth: integer;
  nameWidth: integer;
  txtHeight: integer;
begin
  with Sender as TVirtualDrawTree, HintCanvas do
  begin
    try

    HintCanvas.Font.Assign((Sender as TVirtualDrawTree).Canvas.Font);
    HintCanvas.Font.Color := clBlack;

    Battle := GetBattleFromNode(Node);
    Pen.Color := clBlack;
    Brush.Color := $00ffdddd; { 0 b g r }
    Brush.Style := bsSolid;
    Rectangle(ClipRect);

    //Brush.Style := bsClear;

    case Column of
      8:
      begin
        maxNameWidth := HintCanvas.TextWidth(TClient(Battle.Clients[0]).DisplayName);
        for i:=1 to Battle.Clients.Count-1 do
        begin
          nameWidth := HintCanvas.TextWidth(TClient(Battle.Clients[i]).DisplayName);
          if nameWidth > maxNameWidth then
            maxNameWidth := nameWidth;
        end;

        txtHeight := HintCanvas.TextHeight('H');
        for i:=0 to Battle.Clients.Count-1 do
        begin
          if (TClient(Battle.Clients[i]).GetGroup <> nil) and (TClient(Battle.Clients[i]).GetGroup.EnableColor) then
          begin
            HintCanvas.Brush.Color := TClient(Battle.Clients[i]).GetGroup.Color;
            HintCanvas.Font.Color := Misc.ComplementaryTextColor(HintCanvas.Brush.Color);
          end
          else
          begin
            HintCanvas.Font.Color := clBlack;
            HintCanvas.Brush.Color := $00ffdddd; { 0 b g r }
          end;
          TextOut(10+(maxNameWidth+20)*(i div 8), 10+(txtHeight+2)*(i mod 8), TClient(Battle.Clients[i]).DisplayName);
        end;
        HintCanvas.Pen.Color := clBlack;
        HintCanvas.Brush.Color := $00ffdddd; { 0 b g r }
      end;
      5: TextOut(5, 2, Battle.ModName);
      4:
      begin
        if Battle.NATType > 0 then
          tmpStr := _(' NAT Traversal enabled, you may not be able to join this battle.');
        if Battle.IsBattleInProgress then
          TextOut(5, 2, _('Battle in progress, you can join it but you will have to wait until it ends.'))
        else if Battle.Locked then
          TextOut(5, 2, _('Battle locked, you can''t join it.'))
        else if Battle.Password then
          TextOut(5, 2, _('You need the password to join that battle.'))
        else if Battle.IsBattleFull then
          TextOut(5, 2, _('The battle is full, you can join but you will be spectator.')+tmpStr)
        else if Battle.RankLimit > Status.Me.GetRank then
          TextOut(5, 2, _('You don''t have the rank required to join that battle. However you can still try to join it if you think you are good enough.')+tmpStr)
        else
          TextOut(5, 2, 'Battle opened.'+tmpStr);
      end;
      3:
      begin
        if Utility.MapList.IndexOf(Battle.Map) > -1 then
        begin
          with TMapItem(MapListForm.Maps[Utility.MapList.IndexOf(Battle.Map)]) do
          begin
            if MapImage <> nil then
              Draw(10,10,MapImage.Picture.Bitmap);
            Font.Style := [fsBold];
            TextOut(120, 10, MapName);
            Font.Style := [];
            TextOut(120, 10+TextHeight(MapName), _('Map size: ')+IntToStr(MapInfo.Width div 64)+'x'+IntToStr(MapInfo.Height div 64));
            TextOut(120, 10+TextHeight(MapName)*2, _('Max. metal: ')+FloatToStr(RoundTo(MapInfo.MaxMetal,-3)));
            TextOut(120, 10+TextHeight(MapName)*3, _('Wind (min/max/avg): ')+IntToStr(MapInfo.MinWind)+'-'+IntToStr(MapInfo.MaxWind)+ '-' + IntToStr(Floor((MapInfo.MaxWind+MapInfo.MinWind)/2)));
            DrawMultilineText(MapInfo.Description,HintCanvas,Rect(120,10+10+TextHeight(MapName)*4,R.Right-10,R.Bottom-5),alHLeft,alVTop,JustLeft,true);
          end;
        end
        else
          TextOut(5, 2, Battle.Map);
      end;
      2: TextOut(5, 2, TClient(Battle.Clients[0]).Name);
      1: TextOut(5, 2, Battle.Description);
      6: TextOut(5, 2, Header.Columns[Column].Hint);
      9: TextOut(5, 2, Battle.EngineName + ' ' + Battle.EngineVersion);
      7:
      begin
        if Battle.IsBattleInProgress then
          if Battle.StartTimeUknown then
            s := '?:??:??'
          else
          begin
            DateTimeToString(s,'h:nn:ss',Now-Battle.StartTime);
          end
        else
          s := '';
        TextOut(5, 2, s);
      end;
    end;

    except
      TextOut(5, 2, 'Error');
    end;

  end;
end;

procedure TMainForm.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
var
  c,cNext: TWinControl;
begin
  // remove the double click on the dockpanel drag bar detaching the panel
  if (Msg.message = Messages.WM_LBUTTONDBLCLK) and (mnuLockView.Checked) then
  begin
    c := Screen.ActiveForm;
    cNext := c;
    while cNext <> nil do
    begin
      c := cNext;
      cNext := TWinControl(c.ControlAtPos(c.ScreenToClient(Msg.pt),True,True));
    end;
    if (c.ClassType = TDockPanel) or (c.ClassType = TPageControl) then
      Handled := True;
  end;
  // left right or middle click or mouse wheel = set away status to back
  if (Msg.message = Messages.WM_LBUTTONDOWN) or (Msg.message = Messages.WM_RBUTTONDOWN) or (Msg.message = Messages.WM_MBUTTONDOWN) or (Msg.message = Messages.WM_MOUSEWHEEL) then
    AutoSetBack;
  If Msg.message = Messages.WM_MOUSEWHEEL then
  begin
    if MapListForm.Active then // when in MapListForm scrollbars should scroll through available maps
    begin
      if Msg.wParam > 0 then MapListForm.ScrollBox1.VertScrollBar.Position := MapListForm.ScrollBox1.VertScrollBar.Position - MapListForm.ScrollBox1.VertScrollBar.Increment // Scroll Up
        else MapListForm.ScrollBox1.VertScrollBar.Position := MapListForm.ScrollBox1.VertScrollBar.Position + MapListForm.ScrollBox1.VertScrollBar.Increment; // Scroll Down
    end;

    if Screen.ActiveControl is TSpTBXSpinEdit then
    begin
      if Msg.wParam > 0 then
        TSpTBXSpinEdit(Screen.ActiveControl).SpinOptions.ValueInc
      else
        TSpTBXSpinEdit(Screen.ActiveControl).SpinOptions.ValueDec;
      Handled := True;
    end;

//***     Handled := True; // we don't want other components to receive mouse wheel messages
  end;

end;

function TMainForm.GetCountryName(CountryCode: string): string; // this is a slow function. Use it only when necessary.
var
  i: Integer;
begin
  for i := 0 to High(CountryNames) do
    if LowerCase(RightStr(CountryNames[i], Length(CountryCode))) = LowerCase(CountryCode) then
    begin
      Result := LeftStr(CountryNames[i],Length(CountryNames[i])-Length(CountryCode)-1);
      Exit;
    end;
  Result := 'Unknown country'; // should not happen
end;

function TMainForm.GetCountryCode(CountryName: string): string;
var
  i: Integer;
begin
  for i := 0 to High(CountryNames) do
    if LowerCase(LeftStr(CountryNames[i], Length(CountryName))) = LowerCase(CountryName) then
    begin
      Result := RightStr(CountryNames[i],Length(CountryNames[i])-Length(CountryName)-1);
      Exit;
    end;
  Result := 'Unknown country'; // should not happen
end;

procedure TMainForm.ClientsListBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  tmp,tmp2: Integer;
  groupStr: String;
  i: integer;
  realIndex: integer;
  cList: TList;
begin
  if MainForm.Active and (SkinManager.GetSkinType = sknSkin) then
    TTntListBox(Sender).Repaint;

  cList := TList.Create;
  GetDrawItemClientList(TTntListBox(Sender),cList);

  try

  tmp := (Sender as TTntListBox).ItemAtPos(Point(X, Y), True);
  if tmp = -1 then
  begin
    (Sender as TTntListBox).Hint := '';
    Exit;
  end;

  {if Sender = ClientsListBox then
  begin
    for i:=0 to cList.Count-1 do
    begin
      if TClient(cList[i]).Visible then Dec(tmp);
      if tmp = -1 then break;
    end;
    realIndex := i;
  end
  else}

  realIndex := tmp;

  try
    groupStr := '';
    if TClient(cList[realIndex]).GetGroup <> nil then
      groupStr := ', '+TClient(cList[realIndex]).GetGroup.Name;
    (Sender as TTntListBox).Hint := TClient(cList[realIndex]).Name + ', ' + GetCountryName(TClient(cList[realIndex]).Country)+groupStr;

    // custom icons
    if not Preferences.ScriptsDisabled then
    for i:=0 to lobbyScriptUnit.PlayerIconTypeNames.Count-1 do
    begin
      tmp2 := TClient(cList[realIndex]).GetCustomIconId(i);
      if (tmp2 >= 0) and (TImageList(lobbyScriptUnit.PlayerIconTypeIcons[i]).Count > tmp2) then
      begin
        (Sender as TTntListBox).Hint := (Sender as TTntListBox).Hint + ', ' + lobbyScriptUnit.PlayerIconTypeNames[i] + '=' + TStringList(lobbyScriptUnit.PlayerIconTypeIconsNames[i]).Strings[tmp2]
      end;
    end;

    // name history
    if TClient(cList[realIndex]).NameHistory.Count > 0 then
      (Sender as TTntListBox).Hint := (Sender as TTntListBox).Hint + ', ('+_('A.K.A.')+' : ' + TClient(cList[realIndex]).NameHistory.CommaText + ')';
  except
  end;

  finally
    cList.Free;
  end;
end;

procedure TMainForm.RichEditPopupMenuPopup(Sender: TObject);
var
  i : Integer;
begin
  with (Sender as TSpTBXPopupMenu) do
  begin
    OpenLogs1.Visible := lastActiveTab.LogFile <> nil;
    AutoScroll1.Visible := (richContextMenu <> BattleForm.ChatRichEdit) and RunningUnderWine;
    AutoScroll1.Checked := lastActiveTab.AutoScroll;
    AutoJoin1.Visible := (richContextMenu <> BattleForm.ChatRichEdit) and (lastActiveTab.Caption <> LOCAL_TAB) and (lastActiveTab.Caption <> '#main') and (LeftStr(lastActiveTab.Caption,1) = '#');
    AutoJoin1.Checked := PerformForm.isChannelAutoJoined(MidStr(lastActiveTab.Caption,2,999));
  end;
end;

procedure TMainForm.AutoScroll1Click(Sender: TObject);
begin
  lastActiveTab.AutoScroll := not lastActiveTab.AutoScroll;
end;

function TMainForm.MakeNotification(HeaderText, MessageText: string; DisplayTime: Integer; canClick: boolean): TJvDesktopAlert;
begin
  Result := TJvDesktopAlert.Create(Self);
  Result.HeaderText := HeaderText;
  Result.MessageText := MessageText;
  if canClick then
    Result.Options := [daoCanClose,daoCanClick]
  else
    Result.Options := [daoCanClose];
  Result.Location.Position := dapBottomRight;
  Result.OnShow := OnNotificationShow;

  if SkinManager.GetSkinType = sknSkin then
    Result.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal)
  else
    Result.Font.Color := clBlack;


  Result.StyleHandler.DisplayDuration := DisplayTime;
  Result.Location.Width := 250;
  Result.Location.Height := 70;
  Result.AlertStyle := asFade;
end;

procedure TMainForm.OnNotificationShow(Sender: TObject);
begin
  if SkinManager.GetSkinType = sknSkin then
  begin
    TJvDesktopAlert(Sender).Form.Color := SkinManager.CurrentSkin.Options(skncPanel,sknsNormal).Body.Color2;
    TJvDesktopAlert(Sender).Form.CaptionColorFrom := SkinManager.CurrentSkin.Options(skncPanel,sknsNormal).Body.Color1;
    TJvDesktopAlert(Sender).Form.CaptionColorTo := SkinManager.CurrentSkin.Options(skncPanel,sknsNormal).Body.Color2;
    TJvDesktopAlert(Sender).Form.WindowColorFrom := SkinManager.CurrentSkin.Options(skncPanel,sknsNormal).Body.Color2;
    TJvDesktopAlert(Sender).Form.WindowColorTo := SkinManager.CurrentSkin.Options(skncPanel,sknsNormal).Body.Color1;
    TJvDesktopAlert(Sender).HeaderFont.Color := SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal);
    TJvDesktopAlert(Sender).Form.tbClose.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal);
    TJvDesktopAlert(Sender).Form.tbClose.HotTrackFont.Color := SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsHotTrack);
  end
  else
  begin
    TJvDesktopAlert(Sender).Form.Color := $ffffff;
    TJvDesktopAlert(Sender).Form.CaptionColorFrom := $ebe0d7;
    TJvDesktopAlert(Sender).Form.CaptionColorTo := $ffffff;
    TJvDesktopAlert(Sender).Form.WindowColorFrom := $ffffff;
    TJvDesktopAlert(Sender).Form.WindowColorTo := $e0cdbc;
    TJvDesktopAlert(Sender).HeaderFont.Color := clRed;
    TJvDesktopAlert(Sender).Form.tbClose.Font.Color := clRed;
    TJvDesktopAlert(Sender).Form.tbClose.HotTrackFont.Color := clPurple;
  end;
end;

procedure TMainForm.ExecuteNotification(N: TJvDesktopAlert);
begin
  if mnuDisableNotifications.Checked then Exit;
  if (BattleState.Status <> None) and (Status.Me.GetInGameStatus) then
    Exit;
  if Preferences.UseSoundNotifications then
    if not Preferences.DisableAllSounds then PlayResSound('notify');

  if displayingNotificationList.Count >= MAX_POPUP then
  begin
    N.Free;
    Exit;
    //TJvDesktopAlert(displayingNotificationList.First).Close(True);
  end;

  displayingNotificationList.Add(N);
  N.OnClose := NotificationClose; // removes itself from the displayingNotificationList

  N.Execute;
end;

procedure TMainForm.AddNotification(HeaderText, MessageText: string; DisplayTime: Integer;OnClick: Boolean = false;BattleId: integer = -1);
var
  DA: TJvDesktopAlert;
begin
  DA := MakeNotification(HeaderText,MessageText,DisplayTime,OnClick);
  DA.OnMessageClick := NotificationClick;
  DA.Tag := BattleId;
  ExecuteNotification(DA);
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
  HitInfo: TVTHeaderHitInfo);
var
  tmpNode: PVirtualNode;
  i: integer;
begin
  // note: when moving columns, their indexes remain the same!
  // (so the header of the first column may not have index 0)

  if VDTBattles.Header.SortColumn = HitInfo.Column then
    if Preferences.BattleSortDirection = 0 then Preferences.BattleSortDirection := 1
    else Preferences.BattleSortDirection := 0
  else Preferences.BattleSortDirection := 0;
    
  Preferences.BattleSortStyle := PreferencesForm.ColumnToBattleSortStyle(HitInfo.Column);
  VDTBattles.Header.SortColumn := HitInfo.Column;
  if Preferences.BattleSortDirection = 0 then
    VDTBattles.Header.SortDirection := sdAscending
  else
    VDTBattles.Header.SortDirection := sdDescending;
  SortBattlesList(Battles ,Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0);
  RefreshBattlesNodes;

  tmpNode := nil;
  tmpNode := VDTBattles.GetFirst();
  for i:=0 to Battles.Count-1 do
    if TBattle(Battles[i]).Visible then begin
      TBattle(Battles[i]).Node := tmpNode;
      tmpNode := VDTBattles.GetNext(tmpNode);
    end;

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
    if TTntListBox(Sender).ItemIndex > -1 then
    begin
      ClientPopupMenu.Popup(p.X, p.Y);
    end;
  end;
end;

procedure TMainForm.ClientsListBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  cList: TList;
begin
  // auto select item on right click:
  if Button = mbRight then
  begin
    TTntListBox(Sender).ItemIndex := TTntListBox(Sender).ItemAtPos(Point(X, Y), True);
    if TTntListBox(Sender).ItemIndex > -1 then
    begin
      cList := TList.Create;
      GetDrawItemClientList(TTntListBox(Sender),cList);
      ContextMenuSelectedClient := cList[TTntListBox(Sender).ItemIndex];
      ClientPopupMenuPopup(nil);
      cList.Free;
    end;
  end;
end;

procedure TMainForm.ConnectButtonClick(Sender: TObject);
begin
  if (Status.ConnectionState = Disconnected) and Preferences.UseLogonForm then
  begin
    LogonForm.Show;
    Exit;
  end;

  if Preferences.Username = '' then
  begin
    MessageDlg(_('To log into the server, you need an account. Use the "Create new account" button to register a new account.'),mtInformation,[mbOk],0);
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
  OpenPrivateChat(GetClient(SelectedUserName));
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
          VDTBattles.TreeOptions.AutoOptions := VDTBattles.TreeOptions.AutoOptions - [toDisableAutoscrollOnFocus];
          VDTBattles.Selected[TBattle(Battles[i]).Node] := True;
          VDTBattles.FocusedNode := TBattle(Battles[i]).Node;
          Misc.ShowAndSetFocus(VDTBattles);
          VDTBattles.TreeOptions.AutoOptions := VDTBattles.TreeOptions.AutoOptions + [toDisableAutoscrollOnFocus];
          Exit;
        end;
    end;
end;

procedure TMainForm.mnuPlayWithClick(Sender: TObject);
var
  i,j:integer;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item

  for i:=0 to Battles.Count-1 do begin
      for j:=0 to TBattle(Battles[i]).Clients.Count-1 do
        if TClient(TBattle(Battles[i]).Clients[j]).Name = SelectedUserName then begin
          if AutoJoinForm.chkStopAutoJoinWhenLeaving.Checked then
          begin
            mnuAutoplayFirstAvailable.Checked := False;
            mnuAutospecFirstAvailable.Checked := False;
          end;
          JoinBattle(Battles[i]);
          Exit;
        end;
  end;
end;

constructor TReplay.Create;
begin
  PlayerList := TList.Create;
  demoHeader := TDemoHeaderGeneric.Create;
  winningTeams := TIntegerList.Create;
  TeamList := TList.Create;
  TeamStatsAvailable := false;
end;

destructor TReplay.Destroy;
var
  i:integer;
begin
  for i := 0 to PlayerList.Count-1 do
  begin
    PReplayPlayer(PlayerList[i]).Free;
    FreeMem(PlayerList[i]);
  end;
  PlayerList.Free;

  for i := 0 to TeamList.Count-1 do
  begin
    PReplayTeam(TeamList[i]).Free;
    FreeMem(TeamList[i]);
  end;
  TeamList.Free;

  Script.Free;
  inherited Destroy;
end;

function TReplay.GetSpectatorCount: integer;
var
  i:integer;
begin
  result := 0;
  for i:=0 to PlayerList.Count-1 do
    if TReplayPlayer(PlayerList[i]^).Spectator then
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

function TReplay.isWinningTeam(teamId: integer): Boolean;
begin
  Result := winningTeams.IndexOf(teamId) > -1;
end;

function TReplay.GetTeam(teamId : byte): PReplayTeam;
var
  i:integer;
  replayTeam: PReplayTeam;
begin
  for i:=0 to TeamList.Count-1 do
  begin
    replayTeam := PReplayTeam(TeamList.Items[i]);
    if replayTeam.TeamId = teamId then
    begin
      Result := replayTeam;
      Exit;
    end;
  end;

  // team not found, create it
  New(replayTeam);
  replayTeam^ := TReplayTeam.Create();
  replayTeam.TeamId := teamId;

  TeamList.Add(replayTeam);
  Result := replayTeam;
end;

constructor TReplayTeam.Create();
begin
  PlayerList := TList.Create;
end;

constructor TClientGroup.Create(Name: string; Color: Integer);
begin
  Self.Clients := TStringList.Create;
  Self.ClientsIds := TIntegerList.Create;
  Self.Name := Name;
  Self.EnableColor := True;
  Self.Color := Color;
  Self.AutoKick := False;
  Self.AutoSpec := False;
  Self.NotifyOnHost := False;
  Self.NotifyOnJoin := False;
  Self.NotifyOnBattleEnd := False;
  Self.NotifyOnConnect := False;
  Self.EnableChatColor := False;
  Self.ChatColor := Color;
  Self.ReplaceRank := False;
  Self.Rank := 0;
  Self.BalanceInSameTeam := False;
  Self.ExecuteSpecialCommands := False;
end;

destructor TClientGroup.Destroy;
var
  i: integer;
  client: TClient;
begin
  for i:=0 to Clients.Count-1 do
  begin
    client := MainForm.GetClient(Clients[i]);
    if client <> nil then
      client.SetGroup(nil);
  end;
  Self.Clients.Destroy;
end;

procedure TClientGroup.GroupUpdated;
begin
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onGroupsChanged(); except end;
  ReleaseMainThread;
end;

function TClientGroup.AddClient(nickName: string): Boolean;
var
  c: TClient;
  id: integer;
begin
  Result := False;

  c := MainForm.GetClient(nickName);
  if c <> nil then
  begin
    ClientsIds.Add(c.Id);
    c.SetGroup(Self);
  end
  else
  begin
    id := TClient.GetIdByLatestName(nickName);
    if id = -1 then
      Exit;
    ClientsIds.Add(id);
  end;
  MainForm.SaveGroups;

  Result := True;
end;
procedure TClientGroup.RemoveClient(nickName: string);
var
  c: TClient;
begin
  c := MainForm.GetClient(nickName);
  if c <> nil then
  begin
    ClientsIds.Remove(c.Id);
    c.SetGroup(nil);
  end
  else
  begin
    ClientsIds.Remove(TClient.GetIdByLatestName(nickName))
  end;
end;

procedure TMainForm.mnuManageGroupsClick(Sender: TObject);
begin
  ManageGroupsForm.Show;
end;

procedure TMainForm.mnuNewGroupClick(Sender: TObject);
var
  InputString: string;
  group : TClientGroup;
  Client: TClient;
  i: integer;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item
  Client := GetClient(SelectedUserName);
  if Client = nil then
    Exit;
  if Client.GetGroup <> nil then
    Client.GetGroup.RemoveClient(Client.Name);

  InputString:= _('New group ')+IntToStr(ClientGroups.Count+1);
  if InputQuery(_('New group ...'), _('Enter the group name :'), InputString) then begin
    group := TClientGroup.Create(InputString,InputColor(_('Choose a group highlight color ...'),clWhite));
    group.AddClient(SelectedUserName);
    ClientGroups.Add(group);
    SortClientInLists(Client);
    group.GroupUpdated;
    ManageGroupsForm.Show;
  end;
end;

procedure TMainForm.AddToGroupItemClick(Sender: TObject);
var
  Client: TClient;
  i:integer;
begin
  Client := GetClient(SelectedUserName);
  if Client = nil then
    Exit;
    
  if Client.GetGroup <> nil then
    Client.GetGroup.RemoveClient(Client.Name);

  TClientGroup(ClientGroups[(Sender as TSpTBXItem).Tag]).AddClient(SelectedUserName);
  SortClientInLists(Client);
  TClientGroup(ClientGroups[(Sender as TSpTBXItem).Tag]).GroupUpdated;
end;

procedure TMainForm.ResortClientsLists;
var
  i:integer;
begin
  if Preferences.SortLocal then
    SortClientsList(AllClients, Preferences.SortStyle, Preferences.SortAsc);

  for i := 1 {start from 1 to skip LOCAL_TAB} to ChatTabs.Count-1 do
    SortClientsList(TMyTabSheet(MainForm.ChatTabs[i]).Clients, Preferences.SortStyle, Preferences.SortAsc);
  if selectedBattlePlayers <> nil then
    SortClientsList(selectedBattlePlayers.SortedClients,Preferences.SortStyle, Preferences.SortAsc);
  UpdateClientsListBox;
  BattlePlayersListBox.Invalidate;
end;

procedure TMainForm.SortClientInLists(client: TClient);
var
  i:integer;
begin
  if Preferences.SortLocal then
    SortClientInList(client,AllClients, Preferences.SortStyle, Preferences.SortAsc);
  for i := 1 {start from 1 to skip LOCAL_TAB} to ChatTabs.Count-1 do
    SortClientInList(client,TMyTabSheet(MainForm.ChatTabs[i]).Clients, Preferences.SortStyle, Preferences.SortAsc);
  if (client.Battle <> nil) and (client.Battle = selectedBattlePlayers) then
    SortClientInList(client,client.Battle.SortedClients, Preferences.SortStyle, Preferences.SortAsc);
  UpdateClientsListBox;
end;

procedure TMainForm.ClientsListBoxClick(Sender: TObject);
begin
  TTntListBox(Sender).Refresh;
end;

procedure TMainForm.mnuRemoveFromGroupClick(Sender: TObject);
var
  Client : TClient;
  g : TClientGroup;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item
  if GetClientIndexEx(SelectedUserName,AllClients) = -1 then Exit;
  Client := GetClient(SelectedUserName);
  g := Client.GetGroup;
  g.RemoveClient(Client.Name);
  SortClientInLists(Client);
  MainForm.ClientsListBox.Refresh;
  g.GroupUpdated;
end;

procedure TMainForm.SaveGroups;
var
  FileName: String;
  Ini : TIniFile;
  i,j:integer;
  tmpStr: string;
begin
  try
    FileName := ExtractFilePath(Application.ExeName) + GROUPS_FILE;
    if FileExists(FileName) then
      DeleteFile(FileName);
    Ini := TIniFile.Create(FileName);
    for i:=0 to ClientGroups.Count-1 do begin
      Ini.WriteString(IntToStr(i), 'Name', TClientGroup(ClientGroups[i]).Name);
      Ini.WriteString(IntToStr(i), 'EnableColor', BoolToStr(TClientGroup(ClientGroups[i]).EnableColor));
      Ini.WriteString(IntToStr(i), 'Color', IntToStr(TClientGroup(ClientGroups[i]).Color));
      Ini.WriteString(IntToStr(i), 'AutoKick', BoolToStr(TClientGroup(ClientGroups[i]).AutoKick));
      Ini.WriteString(IntToStr(i), 'AutoSpec', BoolToStr(TClientGroup(ClientGroups[i]).AutoSpec));
      Ini.WriteString(IntToStr(i), 'NotifyOnHost', BoolToStr(TClientGroup(ClientGroups[i]).NotifyOnHost));
      Ini.WriteString(IntToStr(i), 'NotifyOnJoin', BoolToStr(TClientGroup(ClientGroups[i]).NotifyOnJoin));
      Ini.WriteString(IntToStr(i), 'NotifyOnBattleEnd', BoolToStr(TClientGroup(ClientGroups[i]).NotifyOnBattleEnd));
      Ini.WriteString(IntToStr(i), 'NotifyOnConnect', BoolToStr(TClientGroup(ClientGroups[i]).NotifyOnConnect));
      Ini.WriteString(IntToStr(i), 'HighlightBattles', BoolToStr(TClientGroup(ClientGroups[i]).HighlightBattles));
      Ini.WriteString(IntToStr(i), 'EnableChatColor', BoolToStr(TClientGroup(ClientGroups[i]).EnableChatColor));
      Ini.WriteString(IntToStr(i), 'ChatColor', IntToStr(TClientGroup(ClientGroups[i]).ChatColor));
      Ini.WriteString(IntToStr(i), 'ReplaceRank', BoolToStr(TClientGroup(ClientGroups[i]).ReplaceRank));
      Ini.WriteString(IntToStr(i), 'Rank', IntToStr(TClientGroup(ClientGroups[i]).Rank));
      Ini.WriteString(IntToStr(i), 'BalanceInSameTeam', BoolToStr(TClientGroup(ClientGroups[i]).BalanceInSameTeam));
      Ini.WriteString(IntToStr(i), 'Ignore', BoolToStr(TClientGroup(ClientGroups[i]).Ignore));
      Ini.WriteString(IntToStr(i), 'ExecuteSpecialCommands', BoolToStr(TClientGroup(ClientGroups[i]).ExecuteSpecialCommands));
      Ini.WriteString(IntToStr(i), 'Clients', Misc.JoinStringList(TClientGroup(ClientGroups[i]).Clients,' '));
      tmpStr := '';
      for j:=0 to TClientGroup(ClientGroups[i]).ClientsIds.Count-1 do
        tmpStr := tmpStr+IntToStr(TClientGroup(ClientGroups[i]).ClientsIds.Items[j])+' ';
      Ini.WriteString(IntToStr(i), 'ClientsIds', tmpStr);
    end;
    Ini.Free;
  except
    Exit;
  end;
end;

procedure TMainForm.LoadGroups;
var
  Ini : TIniFile;
  i,j:integer;
  cg : TClientGroup;
  FileName: String;
  tmp: string;
  sl: TStringList;
begin
  FileName := ExtractFilePath(Application.ExeName) + GROUPS_FILE;
  Ini := TIniFile.Create(FileName);
  i := 0;
  while Ini.SectionExists(IntToStr(i)) do begin
    cg := TClientGroup.Create('empty',0);
    cg.Name := Ini.ReadString(IntToStr(i), 'Name', 'Empty');
    cg.EnableColor := StrToBool(Ini.ReadString(IntToStr(i), 'EnableColor', '1'));
    cg.Color := StrToInt(Ini.ReadString(IntToStr(i), 'Color', '0'));
    cg.AutoKick := StrToBool(Ini.ReadString(IntToStr(i), 'AutoKick', '0'));
    cg.AutoSpec := StrToBool(Ini.ReadString(IntToStr(i), 'AutoSpec', '0'));
    cg.NotifyOnHost := StrToBool(Ini.ReadString(IntToStr(i), 'NotifyOnHost', '0'));
    cg.NotifyOnJoin := StrToBool(Ini.ReadString(IntToStr(i), 'NotifyOnJoin', '0'));
    cg.NotifyOnBattleEnd := StrToBool(Ini.ReadString(IntToStr(i), 'NotifyOnBattleEnd', '0'));
    cg.NotifyOnConnect := StrToBool(Ini.ReadString(IntToStr(i), 'NotifyOnConnect', '0'));
    cg.HighlightBattles := StrToBool(Ini.ReadString(IntToStr(i), 'HighlightBattles', '0'));
    cg.EnableChatColor := StrToBool(Ini.ReadString(IntToStr(i), 'EnableChatColor', '0'));
    cg.ChatColor := StrToInt(Ini.ReadString(IntToStr(i), 'ChatColor', '0'));
    cg.ReplaceRank := StrToBool(Ini.ReadString(IntToStr(i), 'ReplaceRank', '0'));
    cg.Rank := StrToInt(Ini.ReadString(IntToStr(i), 'Rank', '0'));
    cg.BalanceInSameTeam := StrToBool(Ini.ReadString(IntToStr(i), 'BalanceInSameTeam', '0'));
    cg.Ignore := StrToBool(Ini.ReadString(IntToStr(i), 'Ignore', '0'));
    cg.ExecuteSpecialCommands := StrToBool(Ini.ReadString(IntToStr(i), 'ExecuteSpecialCommands', '0'));
    tmp := Ini.ReadString(IntToStr(i), 'Clients', '');
    if tmp <> '' then
      Misc.ParseDelimited(cg.Clients,tmp,' ','');
    tmp := Ini.ReadString(IntToStr(i), 'ClientsIds', '');
    if tmp <> '' then
    begin
      sl := TStringList.Create;
      Misc.ParseDelimited(sl,tmp,' ','');
      for j:=0 to sl.Count-1 do
        try
          cg.ClientsIds.Add(StrToInt(sl[j]));
        except
        end;
      sl.Free;
    end;
    ClientGroups.Add(cg);
    i := i+1;
  end;
  Ini.Free;
end;

procedure TMainForm.SaveAwayMessages;
var
  Ini : TIniFile;
  i:integer;
  FileName: String;
begin
  try
    FileName := ExtractFilePath(Application.ExeName) + AWAY_MSGS_FILE;
    if FileExists(FileName) then
      DeleteFile(FileName);
    Ini := TIniFile.Create(FileName);
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
  Ini : TIniFile;
  i:integer;
  FileName: String;
begin
  AwayMessages.Titles := TStringList.Create;
  AwayMessages.Messages := TStringList.Create;
  FileName := ExtractFilePath(Application.ExeName) + AWAY_MSGS_FILE;
  Ini := TIniFile.Create(FileName);
  i := 0;
  while Ini.SectionExists(IntToStr(i)) do begin
    AwayMessages.Titles.Add(Ini.ReadString(IntToStr(i), 'Title', _('Empty')));
    AwayMessages.Messages.Add(Ini.ReadString(IntToStr(i), 'Message', _('Empty')));
    i := i+1;
  end;
  Ini.Free;
end;

procedure TMainForm.mnuHelpClick(Sender: TObject);
begin
    HelpForm.ShowModal;
end;

procedure TMainForm.mnuSpringReplaysClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://replays.springrts.com/');
end;

procedure TMainForm.mnuJobJolClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://springfiles.com');
end;

procedure TMainForm.mnuBugTrackerClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://springrts.com/mantis/');
end;

procedure TMainForm.mnuMessageboardClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://springrts.com/phpbb/index.php');
end;

procedure TMainForm.mnuSpringHomePageClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://springrts.com/');
end;

procedure TMainForm.CheckNewVersion;
begin
  TLobbyUpdateThread.Create(false,Preferences.AutoUpdateToBeta,True);
end;

procedure TTASClientThread.ShowLastMessage;
begin
  MessageDlgReturn := MessageDlg(MsgT,DlgTypeT,ButtonsT,HelpCtxT);
end;

procedure TTASClientThread.ShowInputBox;
begin
  InputBoxReturn := InputBox(ACaptionT,APromptT,ADefaultT);
end;

procedure TTASClientThread.RefreshMainLog;
begin
  MainForm.AddMainLog(AddMainLogMsgT,AddMainLogColorT);
end;

procedure TTASClientThread.AddMainLogThread(const Msg: string; Color: TColor);
begin
  AddMainLogMsgT := Msg;
  AddMainLogColorT := Color;
  Synchronize(RefreshMainLog);
end;

function TTASClientThread.MessageDlgThread(const Msg: string; DlgType: TMsgDlgType;Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  MsgT := Msg;
  DlgTypeT := DlgType;
  ButtonsT := Buttons;
  HelpCtxT := HelpCtx;

  Synchronize(ShowLastMessage);
  Result := MessageDlgReturn;
end;

function TTASClientThread.InputBoxThread(const ACaption, APrompt, ADefault: string): string;
begin
  ACaptionT := ACaption;
  APromptT := APrompt;
  ADefaultT := ADefault;
  Synchronize(ShowInputBox);
  Result := InputBoxReturn;
end;

procedure TMainForm.mnuBattleScreenClick(Sender: TObject);
begin
  Misc.ShowAndSetFocus(BattleForm.InputEdit);
  BattleForm.ChatActive := True;
end;

procedure TMainForm.menuHostBattleClick(Sender: TObject);
begin
  HostButtonMenuIndex := 0;
  BattleForm.HostButton.OnClick(nil);
  if not HostBattleForm.RelayHostCheckBox.Checked then
    Misc.ShowAndSetFocus(BattleForm.InputEdit);
end;

procedure TMainForm.mnuHostReplayClick(Sender: TObject);
begin
  HostButtonMenuIndex := 2;
  BattleForm.HostButton.OnClick(nil);
  Misc.ShowAndSetFocus(BattleForm.InputEdit);
end;

procedure TMainForm.SpTBXItem6Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('https://translations.launchpad.net/tasclient/trunk');
end;

procedure TMainForm.AutoJoin1Click(Sender: TObject);
begin
  if (Sender as TSpTBXItem).Checked then
    PerformForm.removeAutoJoinChannel(MidStr(lastActiveTab.Caption,2,999))
  else
    PerformForm.addAutoJoinChannel(MidStr(lastActiveTab.Caption,2,999));
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
  for i:= ConnectionPopupMenu.Items.Count -1 downto 7 do
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
  richContextMenu.CopyToClipboard;
end;

procedure TMainForm.mnuIgnoreClick(Sender: TObject);
var
  Client: TClient;
begin
  //if ClientsListBox.ItemIndex = -1 then Exit; // I don't think this can actually happen, since we must click in ListBox and so select an item

  if mnuIgnore.Checked then
    GetClient(SelectedUserName).isIgnored := False
  else
  begin
    IgnoreListForm.EnableIgnoresCheckBox.Checked := True;
    Preferences.UseIgnoreList := True;
    GetClient(SelectedUserName).isIgnored := True;
  end;
end;

procedure TMainForm.FiltersButtonClick(Sender: TObject);
begin
  if FiltersButton.ImageIndex = 0 then
  begin
    FilterGroup.Height := 173;
    //BattlesPanel.Height := BattlesPanel.Height + 173;
    FiltersButton.ImageIndex := 1;
  end
  else
  begin
    FilterGroup.Height := 0;
    //BattlesPanel.Height := BattlesPanel.Height - 173;
    FiltersButton.ImageIndex := 0;
  end;
  if FilterListCombo.ItemIndex = -1 then FilterListCombo.ItemIndex := 0;
  UpdateFilters(CurrentFilters);
end;

procedure TMainForm.AddToFilterListButtonClick(Sender: TObject);
var
  f: ^TFilterText;
begin
  if (FilterValueTextBox.Text = '') or (FilterListCombo.ItemIndex = -1) then Exit;
  New(f);
  case FilterListCombo.ItemIndex of
    0:f^.filterType := HostName;
    1:f^.filterType := MapName;
    2:f^.filterType := ModName;
    3:f^.filterType := Description;
    4:f^.filterType := Players;
    5:f^.filterType := AllBattle;
  end;
  f^.node := nil;
  f^.contains := ContainsRadio.Checked;
  f^.value := FilterValueTextBox.Text;
  CurrentFilters.TextFilters.Add(f);
  f^.Node := FilterList.AddChild(FilterList.RootNode);
  f^.Node.CheckType := ctCheckBox;
  f^.Node.CheckState := csCheckedNormal;
  f^.enabled := True;
  FilterList.Invalidate;
  FilterValueTextBox.Text := '';
  FiltersUpdated;
end;

procedure TMainForm.PlayersSignButtonClick(Sender: TObject);
begin
  if PlayersSignButton.Caption = '>' then
  begin
    PlayersSignButton.Caption := '<';
    CurrentFilters.Players.filterType := Inf;
  end
  else if PlayersSignButton.Caption = '<' then
  begin
    PlayersSignButton.Caption := '=';
    CurrentFilters.Players.filterType := Equal;
  end
  else
  begin
    PlayersSignButton.Caption := '>';
    CurrentFilters.Players.filterType := Sup;
  end;
  FiltersUpdated;
end;

procedure TMainForm.MaxPlayersSignButtonClick(Sender: TObject);
begin
  if MaxPlayersSignButton.Caption = '>' then
  begin
    MaxPlayersSignButton.Caption := '<';
    CurrentFilters.MaxPlayers.filterType := Inf;
  end
  else if MaxPlayersSignButton.Caption = '<' then
  begin
    MaxPlayersSignButton.Caption := '=';
    CurrentFilters.MaxPlayers.filterType := Equal;
  end
  else
  begin
    MaxPlayersSignButton.Caption := '>';
    CurrentFilters.MaxPlayers.filterType := Sup;
  end;
  FiltersUpdated;
end;

procedure TMainForm.PlayersValueTextBoxChange(Sender: TObject);
begin
  if not PlayersValueTextBox.Focused then Exit;
  CurrentFilters.Players.value := PlayersValueTextBox.SpinOptions.ValueAsInteger;
  FiltersUpdated;
end;

procedure TMainForm.MaxPlayersValueTextBoxChange(Sender: TObject);
begin
  if not MaxPlayersValueTextBox.Focused then Exit;
  CurrentFilters.MaxPlayers.value := MaxPlayersValueTextBox.SpinOptions.ValueAsInteger;
  FiltersUpdated;
end;

procedure TMainForm.FullFilterClick(Sender: TObject);
begin
  if not FullFilter.Focused then Exit;
  CurrentFilters.Full := FullFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.InProgressFilterClick(Sender: TObject);
begin
  if not InProgressFilter.Focused then Exit;
  CurrentFilters.InProgress := InProgressFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.LockedFilterClick(Sender: TObject);
begin
  if not LockedFilter.Focused then Exit;
  CurrentFilters.Locked := LockedFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.PasswordedFilterClick(Sender: TObject);
begin
  if not PasswordedFilter.Focused then Exit;
  CurrentFilters.Passworded := PasswordedFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.NatTraversalFilterClick(Sender: TObject);
begin
  if not NatTraversalFilter.Focused then Exit;
  CurrentFilters.NatTraversal := NatTraversalFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.RankLimitFilterClick(Sender: TObject);
begin
  if not RankLimitFilter.Focused then Exit;
  CurrentFilters.RankLimitSupEqMine := RankLimitFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.MapsNotAvailableFilterClick(Sender: TObject);
begin
  if not MapsNotAvailableFilter.Focused then Exit;
  CurrentFilters.MapNotAvailable := MapsNotAvailableFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.ModsNotAvailableFilterClick(Sender: TObject);
begin
  if not ModsNotAvailableFilter.Focused then Exit;
  CurrentFilters.ModNotAvailable := ModsNotAvailableFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.FilterListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  filter : TFilterText;
begin
  filter := TFilterText(CurrentFilters.TextFilters[GetFilterIndexFromNode(node)]^);

  CellText := 'error';

  case Column of
    1:
      if filter.filterType = HostName then
        CellText := _('Host')
      else if filter.filterType = MapName then
        CellText := _('Map')
      else if filter.filterType = ModName then
        CellText := _('Mod')
      else if filter.filterType = Description then
        CellText := _('Description')
      else if filter.filterType = Players then
        CellText := _('Players')
      else if filter.filterType = AllBattle then
        CellText := _('All');
    2:
      if filter.contains then
        CellText := _('with')
      else
        CellText := _('without');
    3:CellText := filter.value;
  end;
end;

procedure TMainForm.FilterGroupResize(Sender: TObject);
begin
  FilterList.Width := FilterGroup.Width - 486;
end;

procedure TMainForm.ReplaysFilterClick(Sender: TObject);
begin
  if not ReplaysFilter.Focused then Exit;
  CurrentFilters.Replays := ReplaysFilter.Checked;
  FiltersUpdated;
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
    CurrentFilters.TextFilters.Delete(GetFilterIndexFromNode(n));
    n := FilterList.GetNextSelected(n);
  end;
  FilterList.DeleteSelectedNodes;
  FiltersUpdated;
end;

procedure TMainForm.ClearFilterListButtonClick(Sender: TObject);
begin
  CurrentFilters.TextFilters.Clear;
  FilterList.Clear;
  FiltersUpdated;
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
  Result := 1;
  try
    filter := TFilterText(Filters.TextFilters[GetFilterIndexFromNode(Node1)]^);
  except
    Exit;
  end;

  case Column of
    1:
      if filter.filterType = HostName then
        text1 := _('Host')
      else if filter.filterType = MapName then
        text1 := _('Map')
      else if filter.filterType = ModName then
        text1 := _('Mod')
      else if filter.filterType = Description then
        text1 := _('Description')
      else if filter.filterType = Players then
        text1 := _('Players')
      else if filter.filterType = AllBattle then
        text1 := _('All');
    2:
      if filter.contains then
        text1 := _('with')
      else
        text1 := _('without');
    3:text1 := filter.value;
  end;

  try
    filter2 := TFilterText(Filters.TextFilters[GetFilterIndexFromNode(Node2)]^);
  except
    Exit;
  end;

  case Column of
    1:
      if filter2.filterType = HostName then
        text2 := _('Host')
      else if filter2.filterType = MapName then
        text2 := _('Map')
      else if filter2.filterType = ModName then
        text2 := _('Mod')
      else if filter2.filterType = Description then
        text2 := _('Description')
      else if filter.filterType = Players then
        text2 := _('Players')
      else if filter.filterType = AllBattle then
        text2 := _('All');
    2:
      if filter2.contains then
        text2 := _('with')
      else
        text2 := _('without');
    3:text2 := filter2.value;
  end;

  Result := AnsiCompareStr(text1, text2);
end;

procedure TMainForm.FilterListHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if FilterList.Header.SortColumn = HitInfo.Column then
    if FilterList.Header.SortDirection = sdDescending then
      FilterList.Header.SortDirection := sdAscending
    else
      FilterList.Header.SortDirection := sdDescending
  else
  begin
    FilterList.Header.SortColumn := HitInfo.Column;
    FilterList.Header.SortDirection := sdAscending
  end;
end;

procedure TMainForm.SaveFiltersToFile(Filters: TPresetFilters);
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
begin
  try
    Filename := Filters.FileName; //VAR_FOLDER + '\' + 'filters.ini';
    if FileExists(Filename) then
      DeleteFile(Filename);
    Ini := TIniFile.Create(Filename);
    i := 0;
    Ini.WriteString('PresetInfo','Name',Filters.Name);
    Ini.WriteBool('StaticFilters','Full',Filters.Full);
    Ini.WriteBool('StaticFilters','InProgress',Filters.InProgress);
    Ini.WriteBool('StaticFilters','Locked',Filters.Locked);
    Ini.WriteBool('StaticFilters','Passworded',Filters.Passworded);
    Ini.WriteBool('StaticFilters','NatTraversal',Filters.NatTraversal);
    Ini.WriteBool('StaticFilters','RankLimitSupEqMine',Filters.RankLimitSupEqMine);
    Ini.WriteBool('StaticFilters','MapNotAvailable',Filters.MapNotAvailable);
    Ini.WriteBool('StaticFilters','ModNotAvailable',Filters.ModNotAvailable);
    Ini.WriteBool('StaticFilters','Replays',Filters.Replays);
    Ini.WriteBool('StaticFilters','Players',Filters.Players.enabled);
    Ini.WriteBool('StaticFilters','Players2',Filters.Players2.enabled);
    Ini.WriteBool('StaticFilters','MaxPlayers',Filters.MaxPlayers.enabled);
    Ini.WriteBool('StaticFilters','AvgRank',Filters.AvgRank.enabled);
  
    if Filters.Players.filterType = Sup then
      Ini.WriteString('StaticFilters','PlayersSign','sup')
    else if Filters.Players.filterType = Inf then
      Ini.WriteString('StaticFilters','PlayersSign','inf')
    else
      Ini.WriteString('StaticFilters','PlayersSign','equal');
    Ini.WriteInteger('StaticFilters','PlayersValue',Filters.Players.value);

    if Filters.Players2.filterType = Sup then
      Ini.WriteString('StaticFilters','Players2Sign','sup')
    else if Filters.Players2.filterType = Inf then
      Ini.WriteString('StaticFilters','Players2Sign','inf')
    else
      Ini.WriteString('StaticFilters','Players2Sign','equal');
    Ini.WriteInteger('StaticFilters','Players2Value',Filters.Players2.value);

    if Filters.MaxPlayers.filterType = Sup then
      Ini.WriteString('StaticFilters','MaxPlayersSign','sup')
    else if Filters.MaxPlayers.filterType = Inf then
      Ini.WriteString('StaticFilters','MaxPlayersSign','inf')
    else
      Ini.WriteString('StaticFilters','MaxPlayersSign','equal');
    Ini.WriteInteger('StaticFilters','MaxPlayersValue',Filters.MaxPlayers.value);

    if Filters.AvgRank.filterType = Sup then
      Ini.WriteString('StaticFilters','AvgRankSign','sup')
    else if Filters.AvgRank.filterType = Inf then
      Ini.WriteString('StaticFilters','AvgRankSign','inf')
    else
      Ini.WriteString('StaticFilters','AvgRankSign','equal');
    Ini.WriteInteger('StaticFilters','AvgRankValue',Filters.AvgRank.value);
  
    for i:=0 to Filters.TextFilters.Count-1 do begin
      with TFilterText(Filters.TextFilters[i]^) do begin

        if filterType = HostName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Host')
        else if filterType = MapName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Map')
        else if filterType = ModName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Mod')
        else if filterType = Description then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Description')
        else if filterType = Players then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Players')
        else if filterType = AllBattle then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'AllBattle');
        
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

procedure TMainForm.LoadFiltersFromFile(var Filters: TPresetFilters);
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
  tmpStr: String;
  f: ^TFilterText;
begin
  Filename := Filters.FileName; //VAR_FOLDER + '\' + 'filters.ini';
  Ini := TIniFile.Create(Filename);
  i := 0;
  Randomize;
  Filters.Name := Ini.ReadString('PresetInfo','Name','Preset_'+IntToStr(RandomRange(1,MaxInt)));
  Filters.Full := Ini.ReadBool('StaticFilters', 'Full', True);
  Filters.InProgress := Ini.ReadBool('StaticFilters', 'InProgress', True);
  Filters.Locked := Ini.ReadBool('StaticFilters', 'Locked', True);
  Filters.Passworded := Ini.ReadBool('StaticFilters', 'Passworded', True);
  Filters.NatTraversal := Ini.ReadBool('StaticFilters', 'NatTraversal', True);
  Filters.RankLimitSupEqMine := Ini.ReadBool('StaticFilters', 'RankLimitSupEqMine', True);
  Filters.MapNotAvailable := Ini.ReadBool('StaticFilters', 'MapNotAvailable', True);
  Filters.ModNotAvailable := Ini.ReadBool('StaticFilters', 'ModNotAvailable', True);
  Filters.Replays := Ini.ReadBool('StaticFilters', 'Replays', True);
  Filters.Players.enabled := Ini.ReadBool('StaticFilters', 'Players', False);
  Filters.Players2.enabled := Ini.ReadBool('StaticFilters', 'Players2', False);
  Filters.MaxPlayers.enabled := Ini.ReadBool('StaticFilters', 'MaxPlayers', False);
  Filters.AvgRank.enabled := Ini.ReadBool('StaticFilters', 'AvgRank', False);

  tmpStr := Ini.ReadString('StaticFilters', 'PlayersSign', 'sup');
  if tmpStr = 'sup' then
    Filters.Players.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Players.filterType := Inf
  else
    Filters.Players.filterType := Equal;
  Filters.Players.value := Ini.ReadInteger('StaticFilters', 'PlayersValue', 0);

  tmpStr := Ini.ReadString('StaticFilters', 'Players2Sign', 'inf');
  if tmpStr = 'sup' then
    Filters.Players2.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Players2.filterType := Inf
  else
    Filters.Players2.filterType := Equal;
  Filters.Players2.value := Ini.ReadInteger('StaticFilters', 'Players2Value', 0);

  tmpStr := Ini.ReadString('StaticFilters', 'MaxPlayersSign', 'sup');
  if tmpStr = 'sup' then
    Filters.MaxPlayers.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.MaxPlayers.filterType := Inf
  else
    Filters.MaxPlayers.filterType := Equal;
  Filters.MaxPlayers.value := Ini.ReadInteger('StaticFilters', 'MaxPlayersValue', 1);

  tmpStr := Ini.ReadString('StaticFilters', 'AvgRankSign', 'sup');
  if tmpStr = 'sup' then
    Filters.AvgRank.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.AvgRank.filterType := Inf
  else
    Filters.AvgRank.filterType := Equal;
  Filters.AvgRank.value := Ini.ReadInteger('StaticFilters', 'AvgRankValue', 4);

  Filters.TextFilters.Clear;
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
      TFilterText(f^).filterType := Description
    else if tmpStr = 'Players' then
      TFilterText(f^).filterType := Players
    else if tmpStr = 'AllBattle' then
      TFilterText(f^).filterType := AllBattle;

    TFilterText(f^).value := Ini.ReadString('TextFilter'+IntToStr(i),'Value','');
    TFilterText(f^).contains := Ini.ReadBool('TextFilter'+IntToStr(i),'Contains',True);
    TFilterText(f^).enabled := Ini.ReadBool('TextFilter'+IntToStr(i),'Enabled',True);
    TFilterText(f^).node := nil;
    Filters.TextFilters.Add(f);

    i := i+1;
  end;

  Ini.Free;
end;

procedure TMainForm.LoadPresets;
var
  FileAttrs: Integer;
  sr: TSearchRec;
  newPreset: PPresetFilters;
begin
  FileAttrs := faAnyFile;
  if FindFirst(ExtractFilePath(Application.ExeName) + FILTERS_FOLDER + '\*.ini', FileAttrs, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') and (sr.Name <> 'current.ini') then
      begin
        New(newPreset);
        newPreset.TextFilters := TList.Create;
        newPreset^.FileName := FILTERS_FOLDER+'\'+sr.Name;
        LoadFiltersFromFile(newPreset^);
        PresetListbox.Items.Add(newPreset.Name);
        PresetList.Add(newPreset);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TMainForm.FiltersUpdated;
begin
  PresetListbox.Selected[0] := true;
  RefreshBattleList;
  SaveFiltersToFile(CurrentFilters);
end;

procedure TMainForm.CopyFilters(srcFilters: TPresetFilters; var dstFilters: TPresetFilters);
var
  i: integer;
  f: ^TFilterText;
begin
  dstFilters.Full := srcFilters.Full;
  dstFilters.InProgress := srcFilters.InProgress;
  dstFilters.Locked := srcFilters.Locked;
  dstFilters.Passworded := srcFilters.Passworded;
  dstFilters.NatTraversal := srcFilters.NatTraversal;
  dstFilters.MapNotAvailable := srcFilters.MapNotAvailable;
  dstFilters.ModNotAvailable := srcFilters.ModNotAvailable;
  dstFilters.Replays := srcFilters.Replays;
  dstFilters.RankLimitSupEqMine := srcFilters.RankLimitSupEqMine;
  dstFilters.Players.enabled := srcFilters.Players.enabled;
  dstFilters.Players2.enabled := srcFilters.Players2.enabled;
  dstFilters.MaxPlayers.enabled := srcFilters.MaxPlayers.enabled;
  dstFilters.AvgRank.enabled := srcFilters.AvgRank.enabled;

  dstFilters.Players.filterType := srcFilters.Players.filterType;
  dstFilters.Players.value := srcFilters.Players.value;

  dstFilters.Players2.filterType := srcFilters.Players2.filterType;
  dstFilters.Players2.value := srcFilters.Players2.value;

  dstFilters.MaxPlayers.filterType := srcFilters.MaxPlayers.filterType;
  dstFilters.MaxPlayers.value := srcFilters.MaxPlayers.value;

  dstFilters.AvgRank.filterType := srcFilters.AvgRank.filterType;
  dstFilters.AvgRank.value := srcFilters.AvgRank.value;

  dstFilters.TextFilters.Clear; // possible memory leak too lazy to fix
  for i:=0 to srcFilters.TextFilters.Count -1 do
  begin
    New(f);
    with f^ do
    begin
      filterType := TFilterText(srcFilters.TextFilters[i]^).filterType;
      contains := TFilterText(srcFilters.TextFilters[i]^).contains;
      node := nil;
      enabled := TFilterText(srcFilters.TextFilters[i]^).enabled;
      value := TFilterText(srcFilters.TextFilters[i]^).value;
    end;
    dstFilters.TextFilters.Add(f);
  end;
end;

procedure TMainForm.UpdateFilters(pFilters: TPresetFilters);
var
  i: integer;
begin
  FullFilter.Checked := pFilters.Full;
  InProgressFilter.Checked := pFilters.InProgress;
  LockedFilter.Checked := pFilters.Locked;
  PasswordedFilter.Checked := pFilters.Passworded;
  NatTraversalFilter.Checked := pFilters.NatTraversal;
  MapsNotAvailableFilter.Checked := pFilters.MapNotAvailable;
  ModsNotAvailableFilter.Checked := pFilters.ModNotAvailable;
  ReplaysFilter.Checked := pFilters.Replays;
  RankLimitFilter.Checked := pFilters.RankLimitSupEqMine;
  PlayersFilter.Checked := pFilters.Players.enabled;
  Players2Filter.Checked := pFilters.Players2.enabled;
  MaxPlayersFilter.Checked := pFilters.MaxPlayers.enabled;
  RankFilter.Checked := pFilters.AvgRank.enabled;

  if pFilters.Players.filterType = Sup then
    PlayersSignButton.Caption := '>'
  else if pFilters.Players.filterType = Inf then
    PlayersSignButton.Caption := '<'
  else
    PlayersSignButton.Caption := '=';
  PlayersValueTextBox.value := pFilters.Players.value;

  if pFilters.Players2.filterType = Sup then
    Players2SignButton.Caption := '>'
  else if pFilters.Players2.filterType = Inf then
    Players2SignButton.Caption := '<'
  else
    Players2SignButton.Caption := '=';
  Players2ValueTextBox.value := pFilters.Players2.value;

  if pFilters.MaxPlayers.filterType = Sup then
    MaxPlayersSignButton.Caption := '>'
  else if pFilters.MaxPlayers.filterType = Inf then
    MaxPlayersSignButton.Caption := '<'
  else
    MaxPlayersSignButton.Caption := '=';
  MaxPlayersValueTextBox.Value := pFilters.MaxPlayers.value;

  if pFilters.AvgRank.filterType = Sup then
    RankSignButton.Caption := '>'
  else if pFilters.AvgRank.filterType = Inf then
    RankSignButton.Caption := '<'
  else
    RankSignButton.Caption := '=';
  RankValueTextBox.Value := pFilters.AvgRank.value;

  FilterList.Clear;
  for i:=0 to pFilters.TextFilters.Count -1 do
  begin
    TFilterText(pFilters.TextFilters[i]^).Node := FilterList.AddChild(FilterList.RootNode);
    TFilterText(pFilters.TextFilters[i]^).Node.CheckType := ctCheckBox;
    if TFilterText(pFilters.TextFilters[i]^).enabled then
      TFilterText(pFilters.TextFilters[i]^).Node.CheckState := csCheckedNormal
    else
      TFilterText(pFilters.TextFilters[i]^).Node.CheckState := csUncheckedNormal;
  end;
end;


procedure TMainForm.HighlighBattlesTimerTimer(Sender: TObject);
var
  i:integer;
begin
  for i:= 0 to Battles.Count -1 do
    if TBattle(Battles[i]).Visible then
      TBattle(Battles[i]).NextHighlight;
  VDTBattles.Refresh;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  FixFormSizeConstraints(MainForm);
 // if MaskForm.Visible then
   // MaskForm.RefreshPostAndSize;
end;

procedure TMainForm.PlayersFilterClick(Sender: TObject);
begin
  if not PlayersFilter.Focused then Exit;
  CurrentFilters.Players.enabled := PlayersFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.MaxPlayersFilterClick(Sender: TObject);
begin
  if not MaxPlayersFilter.Focused then Exit;
  CurrentFilters.MaxPlayers.enabled := MaxPlayersFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.mnuKickClick(Sender: TObject);
begin
  TryToSendCommand('KICKUSER', SelectedUserName);
end;

procedure TMainForm.mnuKickReasonClick(Sender: TObject);
var
  reason: string;
begin
  reason := InputBox(_('Kicking reason'),_('Reason :'),'');
  if reason <> '' then
    TryToSendCommand('KICKUSER', SelectedUserName+' '+reason);
end;

procedure TMainForm.mnuMute5MinClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(lastActiveTab.Caption,2,500000000)+' '+SelectedUserName+' 5 ip');
end;

procedure TMainForm.mnuMute30MinClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(lastActiveTab.Caption,2,500000000)+' '+SelectedUserName+' 30 ip');
end;

procedure TMainForm.mnuMute1HourClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(lastActiveTab.Caption,2,500000000)+' '+SelectedUserName+' 60 ip');
end;

procedure TMainForm.mnuMute1DayClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(lastActiveTab.Caption,2,500000000)+' '+SelectedUserName+' 1440 ip');
end;

procedure TMainForm.mnuMute1WeekClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(lastActiveTab.Caption,2,500000000)+' '+SelectedUserName+' 10080 ip');
end;

procedure TMainForm.mnuMuteCustomClick(Sender: TObject);
begin
  TryToSendCommand('MUTE',MidStr(lastActiveTab.Caption,2,500000000)+' '+SelectedUserName+' '+IntToStr(InputBoxInteger('Mute duration','Duration (min):',30,1))+' ip');
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
  TryToSendCommand('UNMUTE', MidStr(lastActiveTab.Caption,2,500000000)+' '+SelectedUserName);
end;

procedure TKeepAliveThread.Execute;
begin
  while true do
  begin
    try
      if Status.LoggedIn then
      begin
        MainForm.TryToSendCommand('PING');
      end;
    except
    end;
    Sleep(8000);
  end;
end;

constructor TTestThread.Create(Suspended: Boolean);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
end;

procedure TTestThread.Execute;
begin
  while True do
  begin
    Sleep(100);
  end;
end;

constructor TDownloadMapThread.Create(Suspended : Boolean;hash: integer;name: string);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   OnTerminate := OnTerminateProcedure;
   MapHash := hash;
   MapName := name;
end;

procedure TDownloadMapThread.Execute;
begin
  GetLink;
end;

procedure TDownloadMapThread.OpenBrowser;
var
  url: string;
begin
  url := StringReplace(MapName,'.smf','',[rfReplaceAll, rfIgnoreCase]);
  url := 'http://spring.jobjol.nl/search_result.php?search=' + url+'&select=select_all';
  FixURL(url);
  Misc.OpenURLInDefaultBrowser(url);
end;

procedure TDownloadMapThread.GetLink;
var
  html:string;
begin
  with MainForm do
  begin


  // direct download disabled
  Synchronize(OpenBrowser);
  Exit;

  // get the html result
  {if Preferences.UseProxy then
  begin
    HttpCli3.Proxy := Preferences.ProxyAddress;
    HttpCli3.ProxyPort := IntToStr(Preferences.ProxyPort);
    HttpCli3.ProxyUsername := Preferences.ProxyUsername;
    HttpCli3.ProxyPassword := Preferences.ProxyPassword
  end
  else }HttpCli3.Proxy := '';
  HttpCli3.URL := 'http://evolutionrts.info/gethash.php?q='+IntToStr(MapHash);
  HttpCli3.RcvdStream := TMemoryStream.Create;
  try
    HttpCli3.Get;
  except
    Synchronize(OpenBrowser);
    Exit;
  end;
  HttpCli3.RcvdStream.Seek(0,0);
  SetLength(html, HttpCli3.RcvdStream.Size);
  HttpCli3.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli3.RcvdStream.Size);
  HttpCli3.RcvdStream.Free;

  if html = '' then
    Synchronize(OpenBrowser)
  else
  begin
    html := StringReplace(html,#$A,'',[rfReplaceAll]);
    DownloadFile.URL := 'http://evolutionrts.info/'+html;
    DownloadFile.FileName := 'maps\'+Misc.ExtractAfterLastSlash(DownloadFile.URL);
    DownloadFile.HeaderReceived := False;
    DownloadFile.ServerOptions := 8;
    PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);
  end;

  end;
end;

procedure TDownloadMapThread.OnTerminateProcedure(Sender: TObject);
begin
  // nothing
end;

procedure TMainForm.FilterListChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
begin
  if not FilterList.Focused then Exit;
  TFilterText(CurrentFilters.TextFilters[GetFilterIndexFromNode(Node)]^).enabled := NewState = csCheckedNormal;
  RefreshBattleList;
  FiltersUpdated;
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
  CurrentFilters.TextFilters.Add(f);
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
  CurrentFilters.TextFilters.Add(f);
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
  f^.value := Copy(SelectedBattle.Map, 1, Length(SelectedBattle.Map));
  CurrentFilters.TextFilters.Add(f);
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
  CurrentFilters.TextFilters.Add(f);
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
  CurrentFilters.TextFilters.Add(f);
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
  f^.value := Copy(SelectedBattle.Map, 1, Length(SelectedBattle.Map));
  CurrentFilters.TextFilters.Add(f);
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
  VDTBattles.FocusedNode := VDTBattles.GetNodeAt(X,Y);
  VDTBattles.Selected[VDTBattles.FocusedNode] := true;
  if Button = mbRight then
  begin
    BattleListPopupMenuPopup(nil);
  end;
end;

constructor TLobbyUpdateThread.Create(Suspended: Boolean;downloadBeta: boolean; autoUpdate: boolean; delayed : integer = 0; forceUpdate: boolean = False; startSpringUpdateDownloadIfNoLobbyUpdate: boolean = False);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   dlBeta := downloadBeta;
   autoUpdt := autoUpdate;
   delay := delayed;
   forceUpt := forceUpdate;
   startSpringDl := startSpringUpdateDownloadIfNoLobbyUpdate;
end;

procedure TLobbyUpdateThread.Execute;
var
  html : string;
  parsedHtml: TStringList;
  parsedHtml2: TStringList;
  sl: TStringList;
  i:integer;
begin
  Sleep(delay);
  if HttpGetForm.Visible then Exit;
  if FileExists(Application.ExeName + '.old') then
    DeleteFile(Application.ExeName + '.old');
  with MainForm do
  begin
    parsedHtml := TStringList.Create;
    parsedHtml2 := TStringList.Create;
    {if Preferences.UseProxy then
    begin
      HttpCli1.Proxy := Preferences.ProxyAddress;
      HttpCli1.ProxyPort := IntToStr(Preferences.ProxyPort);
      HttpCli1.ProxyUsername := Preferences.ProxyUsername;
      HttpCli1.ProxyPassword := Preferences.ProxyPassword
    end
    else }HttpCli1.Proxy := '';
    HttpCli1.URL := AUTOUPDATE_URL;
    HttpCli1.MultiThreaded := True;
    HttpCli1.RcvdStream := TMemoryStream.Create;
    try
      HttpCli1.Get;
    except
      MainForm.AddMainLog(_('Warning: Lobby update server unavailable.'), Colors.Normal);
      autoUpdateDone := True;
      if startSpringDl then
      begin
        PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);
      end;
      Exit;
    end;
    try
      HttpCli1.RcvdStream.Seek(0,0);
      SetLength(html, HttpCli1.RcvdStream.Size);
      HttpCli1.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli1.RcvdStream.Size);

      Misc.ParseDelimited(parsedHtml,html,EOL,#$A);

      for i:=0 to parsedHtml.Count-1 do
      begin
        Misc.ParseDelimited(parsedHtml2,parsedHtml[i],' ','');
        if parsedHtml2.Count < 5 then
          Raise Exception.Create('Error');
        if (dlBeta and (StrToInt(parsedHtml2[0]) = 1)) or (StrToInt(parsedHtml2[0]) = 0) then
        begin
          if StrToInt(parsedHtml2[1]) <= Misc.GetLobbyRevision then
          begin
            if forceUpt or (StrToInt(parsedHtml2[2]) > Misc.GetLobbyRevision) then
            begin
              if forceUpt or (autoUpdt and dlBeta) or (MessageDlgThread(StringReplace(MakeSentence(parsedHtml2,4),'\n',EOL,[rfReplaceAll]),mtInformation,[mbYes,mbNo],0) = mrYes) then
              begin
                DownloadFile.URL := parsedHtml2[3];
                DownloadFile.HeaderReceived := False;
                if FileExists(ExtractFilePath(Application.ExeName)+'\_AutoUpdateTempFile.7z') then
                  DeleteFile(ExtractFilePath(Application.ExeName)+'\_AutoUpdateTempFile.7z');
                DownloadFile.FileName := '_AutoUpdateTempFile.7z';
                DownloadFile.ServerOptions := 4;
                PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);
                autoUpdateDone := True;
                Exit;
              end;
            end
          end;
        end;
      end;
      if not autoUpdt then
        MessageDlgThread(_('Your lobby version is up to date.'),mtInformation,[mbOk],0);
      autoUpdateDone := True;
    except
      MainForm.AddMainLog(_('Warning: Auto-update file broken.'), Colors.Normal);
      autoUpdateDone := True;
    end;

    if startSpringDl then
    begin
      PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);
    end;
  end;
end;

constructor TScrollingNewsRefreshThread.Create(Suspended: Boolean;timer: integer);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   m_timer := timer;
end;

procedure TScrollingNewsRefreshThread.Execute;
begin
  CoInitialize(nil);
  while True do
  begin
    MainForm.ScrollingNewsTimerTimer(nil);

    Sleep(m_timer);
  end;
  CoUnInitialize;
end;

procedure TMainForm.SpTBXItem3Click(Sender: TObject);
begin
    Misc.OpenURLInDefaultBrowser('http://planetspads.free.fr/spring/stats/');
end;

procedure TMainForm.mnuBattleDlMapClick(Sender: TObject);
var
  dlMap: TDownloadMapThread;
begin
  if Utility.MapList.IndexOf(SelectedBattle.Map) = -1 then
  begin
    SpringDownloaderFormUnit.DownloadMap(SelectedBattle.MapHash,SelectedBattle.Map);
    Exit;
    dlMap := TDownloadMapThread.Create(false,SelectedBattle.MapHash,SelectedBattle.Map);
  end;
end;

procedure TMainForm.mnuBattleDlModClick(Sender: TObject);
var
  url: string;
begin
  SpringDownloaderFormUnit.DownloadMod(SelectedBattle.HashCode,SelectedBattle.ModName);
  Exit;
  url := 'http://spring.jobjol.nl/search_result.php?search='+SelectedBattle.ModName+'&select=select_all';
  FixURL(url);
  Misc.OpenURLInDefaultBrowser(url);
end;

procedure TMainForm.mnuForceLobbyUpdateCheckClick(Sender: TObject);
begin
  TLobbyUpdateThread.Create(false,True,False);
end;

procedure TMainForm.ClientsListBoxExit(Sender: TObject);
begin
  TTntListBox(Sender).ItemIndex := -1;
end;

procedure TMainForm.mnuSpringPortalClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://spring-portal.com');
end;

procedure TMainForm.mnuEvolutionRTSMapsClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://evolutionrts.info/maps/');
end;

procedure TMainForm.mnuDarkStarsClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://www.darkstars.co.uk/downloads/');
end;

procedure TMainForm.mnuEvolutionRTSModsClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://evolutionrts.info/mods/');
end;

procedure TMainForm.ClientsListBoxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i,j:integer;
  Clients : TList;
begin
  {if (Key = VK_F3) and (SearchPlayerForm.KeywordEdit.Text <> '') then
  begin
    if MainForm.PageControl1.ActivePageIndex = 0 then
      Clients := AllClients
    else
      Clients := (MainForm.PageControl1.ActivePage as TMyTabSheet).Clients;
    if MainForm.ClientsListBox.ItemIndex > -1 then
      j := MainForm.ClientsListBox.ItemIndex
    else
      j := 0;
    for i:=j+1 to Clients.Count-1 do
      if Pos(LowerCase(SearchPlayerForm.KeywordEdit.Text),LowerCase(TClient(Clients[i]).Name)) > 0 then
      begin
        MainForm.ClientsListBox.ItemIndex := i;
        Exit;
      end;
    Exit;
  end;*}
end;

procedure TMainForm.SearchPlayerFormPopupMenuPopup(Sender: TObject);
begin
  SearchPlayerFormPopupMenu.PopupForm.SetFocus;
  SearchPlayerForm.KeywordEdit.SetFocus;
end;

procedure TMainForm.mnuQuickJoinPanelClick(Sender: TObject);
begin
  QuickJoinPanel.Visible := not QuickJoinPanel.Visible;
  Preferences.DisplayQuickJoinPanel := QuickJoinPanel.Visible;
  PreferencesForm.DisplayQuickJoinPanelCheckBox.Checked := QuickJoinPanel.Visible;
end;

procedure TMainForm.btPlayNowClick(Sender: TObject);
var
  i: integer;
  selected : integer;
  ratioPlayerMaxPlayer : double;
begin
  if BattleForm.IsBattleActive then
    Exit;
  ratioPlayerMaxPlayer := 0;
  selected := -1;
  for i:=0 to Battles.Count-1 do
  begin
    with TBattle(Battles[i]) do
    begin
      if not IsBattleInProgress and not Password and (BattleType = 0) and not Locked and not IsBattleFull and (RankLimit <= Status.Me.GetRank) then
      begin
        if (Clients.Count-SpectatorCount)/MaxPlayers > ratioPlayerMaxPlayer then
        begin
          ratioPlayerMaxPlayer := (Clients.Count-SpectatorCount)/MaxPlayers;
          selected := i;
        end;
      end;
    end;
  end;
  if selected > -1 then
    JoinBattle(TBattle(Battles[selected]))
  else
    MessageDlg(_('Sorry, there is no battle available.'),mtInformation,[mbOk],0);
end;

procedure TMainForm.Splitter2Moving(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  //PageControl1.Repaint;
end;

procedure TMainForm.ResetAutoKickMsgSentCounters;
var
  i: integer;
begin
  for i:=0 to AllClients.Count-1 do
    TClient(AllClients[i]).AutoKickMsgSent := 0;
end;

procedure TMainForm.ResetAutoSpecMsgSentCounters;
var
  i: integer;
begin
  for i:=0 to AllClients.Count-1 do
    TClient(AllClients[i]).AutoSpecMsgSent := 0;
end;

procedure TMainForm.SpTBXItem4Click(Sender: TObject);
begin
    Misc.OpenURLInDefaultBrowser('http://www.springlobby.info');
end;

procedure TMainForm.btSavePresetClick(Sender: TObject);
var
  newPreset: PPresetFilters;
begin
  if PresetListbox.Items.IndexOf(PresetNameTextbox.Text) >= 0 then
  begin
    if MessageDlg(_('A preset with this name already exists, do you want to replace it ?'),mtWarning,[mbYes, mbNo],0) = mrNo then
      Exit;

    CopyFilters(CurrentFilters,PPresetFilters(PresetList[PresetListbox.Items.IndexOf(PresetNameTextbox.Text)-1])^);
    SaveFiltersToFile(PPresetFilters(PresetList[PresetListbox.Items.IndexOf(PresetNameTextbox.Text)-1])^);

    PresetListbox.ItemIndex := PresetListbox.Items.IndexOf(PresetNameTextbox.Text);
    PresetListboxClick(nil);
  end
  else
  begin
    New(newPreset);
    newPreset.TextFilters := TList.Create;
    CopyFilters(CurrentFilters,newPreset^);
    newPreset.Name := PresetNameTextbox.Text;
    newPreset.FileName := ExtractFilePath(Application.ExeName) + FILTERS_FOLDER + '\'+PresetNameTextbox.Text+'.ini';

    SaveFiltersToFile(newPreset^);
    PresetListbox.Items.Add(PresetNameTextbox.Text);
    PresetListbox.Selected[PresetListbox.Count-1] := true;

    PresetList.Add(newPreset);
  end;
end;

procedure TMainForm.PresetListboxClick(Sender: TObject);
begin
  if (PresetListbox.ItemIndex < 1) then Exit;
  PresetNameTextbox.Text := PPresetFilters(PresetList[PresetListbox.ItemIndex-1])^.Name;
end;

procedure TMainForm.btDeletePresetClick(Sender: TObject);
begin
  if PresetListbox.ItemIndex = 0 then Exit;
  DeleteFile(ExtractFilePath(Application.ExeName) + FILTERS_FOLDER + '\' + PresetListbox.Items[PresetListbox.ItemIndex] + '.ini');
  if PresetListbox.ItemIndex > 0 then
    PresetList.Delete(PresetListbox.ItemIndex-1);
  PresetListbox.Items.Delete(PresetListbox.ItemIndex);
  PresetListbox.Selected[0] := true;
end;

procedure TMainForm.btClearPresetClick(Sender: TObject);
var
  i: integer;
begin
  for i:=PresetListbox.Count-1 downto 1 do
  begin
    DeleteFile(ExtractFilePath(Application.ExeName) + FILTERS_FOLDER + '\' + PresetListbox.Items[i] + '.ini');
    PresetListbox.Items.Delete(i);
  end;
  PresetListbox.Selected[0] := true;
end;

procedure TMainForm.SinglePlayerButtonClick(Sender: TObject);
begin
  //if MessageDlg('Do you want to launch another instance in Single Player mode, otherwise it will disconnect and swi',mtConfirmation,[mbYes,mbNo],0) = mrNo then Exit;

  ShellExecute(0,'open',PChar(Application.ExeName),'-menu',PChar(ExtractFileName(Application.ExeName)),SW_SHOWNORMAL);
  Exit;

  TryToDisconnect;
  MainForm.Hide;
  MenuForm.Show;
end;

procedure TMainForm.initLobbyScript;
begin
  //if not Preferences.ScriptWarningMsgShown then MessageDlg(_('Experimental lobby scripts are now enabled. You can disable them in the options if they create issues. Lobby scripts allow you to extend TASClient with new functionality. You can add or remove them in the Spring\lobby\Python\scripts directory.'),mtInformation, [mbOK], 0);
  //Preferences.ScriptWarningMsgShown := True;
  if Preferences.ScriptsDisabled then Exit;
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing scripts ...');
  RegisterClasses([TDockPanel, TImage, TTntScrollBox ,TWebBrowserWrapper ,TSpTBXDock, TSpTBXMultiDock, TSpTBXToolbar, TSpTBXDockablePanel, TSpTBXTabSet, TSpTBXTabControl, TSpTBXStatusBar, TSpTBXLabel, TSpTBXCheckBox, TSpTBXRadioButton, TSpTBXProgressBar, TSpTBXTrackBar, TSpTBXSplitter, TSpTBXPanel, TSpTBXGroupBox, TSpTBXRadioGroup, TSpTBXEdit,TSpTBXSpinEdit, TSpTBXComboBox,TSpTBXListBox, TSpTBXCheckListBox, TExRichEdit, TImage32, TSpTBXButton, TSpTBXColorEdit, TSpTBXColorListBox, TSpTBXFontComboBox, TTntMemo, TSpTBXTitleBar]);
  PyEngine.LoadDll;
  with GetPythonEngine do
  begin
    SysModule.path := NewPythonList;
    SysModule.path.append(ExtractFilePath(Application.ExeName) +SCRIPTS_FOLDER);

    try
      handlers := Import('handlers');

      LobbyScriptUnit.MainInterpreterState := PyThreadState_Get.interp;
      LobbyScriptUnit.MainThreadState := PyThreadState_Get;
      LobbyScriptUnit.ScriptHostingRunning := False;
      LobbyScriptUnit.ScriptHostingReplayRunning := False;
      LobbyScriptUnit.ScriptJoining := False;
      LobbyScriptUnit.ScriptStart := False;
      LobbyScriptUnit.MsgList := TStringList.Create;
      LobbyScriptUnit.RichEditList := TList.Create;
      LobbyScriptUnit.MsgColor := TIntegerList.Create;
      LobbyScriptUnit.NotificationTempList := TList.Create;
      LobbyScriptUnit.ScriptsInitialized := True;
      LobbyScriptUnit.PlayerIconTypeNames := TStringList.Create;
      LobbyScriptUnit.PlayerIconTypeIcons := TList.Create;
      LobbyScriptUnit.PlayerIconTypeIconsNames := TList.Create;
      LobbyScriptUnit.MapDownloadList := TList.Create;
      LobbyScriptUnit.ModDownloadList := TList.Create;
      LobbyScriptUnit.RapidDownloadList := TList.Create;
      LobbyScriptUnit.EngineDownloadList := TList.Create;
      LobbyScriptUnit.GUICS := TCriticalSection.Create;
      LobbyScriptUnit.InstallWidgetIds := TIntegerList.Create;
      LobbyScriptUnit.UninstallWidgetIds := TIntegerList.Create;
      LobbyScriptUnit.RefreshWidgetListAction := false;

      handlers._load;

      PyEval_ReleaseThread(LobbyScriptUnit.MainThreadState);
    except
      Preferences.ScriptsDisabled := True;
      AddMainLog(_('An error occured when initializing the scripts.'),Colors.Error);
    end;
  end;
end;

procedure TMainForm.PyInOutSendData(Sender: TObject;
  const Data: String);
begin
  PythonScriptDebugFormUnit.printList.BeginUpdate;
  PythonScriptDebugFormUnit.printList.Add(Data);
  PythonScriptDebugFormUnit.printList.EndUpdate;
  SendMessage(PythonScriptDebugForm.Handle, WM_REFRESHOUTPUT, 0, 0);
end;

procedure TMainForm.lobbyscriptWrapperInitialization(Sender: TObject);
begin
  if Preferences.ScriptsDisabled then Exit;
  lobbyscriptWrapper.RegisterDelphiWrapper(TPyCallback);
  lobbyscriptWrapper.RegisterDelphiWrapper(TPyGUI);
end;

procedure TMainForm.initFiltersPresets;
begin
  PresetList := TList.Create;
  FiltersTabs.ActiveTabIndex := 0;
  CurrentFilters.TextFilters := TList.Create;
  CurrentFilters.FileName := ExtractFilePath(Application.ExeName) + FILTERS_FOLDER + '\current.ini';
  LoadPresets;
  LoadFiltersFromFile(CurrentFilters);
  UpdateFilters(CurrentFilters);
  PresetListbox.Selected[0] := true;
  FilterGroup.Height := 0;
end;    


procedure TMainForm.RichEditURLClick(Sender: TObject; URL: String);
var
  r : boolean;
  channel: string;
begin
  r := False;
  if Sender = BattleForm.ChatRichEdit then
    channel := '$battle'
  else
    channel := TMyTabSheet(TExRichEdit(Sender).Parent).Caption;
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then r := handlers.onURLClick(,URL); except end;
  ReleaseMainThread;
  if not r then Misc.OpenURLInDefaultBrowser(URL);
end;

procedure TMainForm.mnuTipsClick(Sender: TObject);
begin
  TipsForm.ShowTips(0,True);
end;

procedure TMainForm.OpenLogs1Click(Sender: TObject);
begin
  if richContextMenu = BattleForm.ChatRichEdit then
    ShellExecute(0,'open',PChar(ExtractFilePath(Application.ExeName) + LOG_FOLDER+'\$battle.log'),nil,nil,SW_SHOWNORMAL)
  else
    ShellExecute(0,'open',PChar(lastActiveTab.LogFileName),nil,nil,SW_SHOWNORMAL);
end;

procedure TMainForm.Button10Click(Sender: TObject);
begin
  try
    raise Exception.Create('test');
  except
  end;
end;

procedure TMainForm.PageControl1Resize(Sender: TObject);
var
  i: Integer;
  p: TPoint;
  re : TExRichEdit;
begin
  for i:=0 to ChatTabs.Count-1 do
  begin
    try
      re := TMyTabSheet(ChatTabs[i]).FindChildControl('RichEdit') as TExRichEdit;
      re.SelLength := 0;
      re.SelStart := 0;
      re.SelStart := Length(re.text);
    except
    end;
  end;
end;

function TMainForm.IsIncludedInList(sl: TStringList; s: string):Boolean;
var
  i:integer;
begin
  Result := False;
  if s = '' then
    Exit;

  s := LowerCase(s);
  for i:=0 to sl.Count-1 do
    if Pos(LowerCase(sl[i]),s) > 0 then
    begin
      Result := True;
      Exit;
    end;
end;

procedure TMainForm.ScrollingNewsTimerTimer(Sender: TObject);
var
   StartItemNode : IXMLNode;
   ANode : IXMLNode;
   STitle, sDesc, sLink : WideString;
   htmlCode: string;
   itemHtmlCode: string;
   newItemHtmlCode: string;
   htmlNewsCode: string;
   temp: string;
   firstNewsRefresh: boolean;
begin
  if Status.AmIInGame then Exit;

  if not FileExists(ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_TEMPLATE) or not FileExists(ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_ITEM_TEMPLATE) or not FileExists(ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_NEW_ITEM_TEMPLATE) then
  begin
    MessageDlg('Some scrolling news files are missing.',mtError,[mbOK],0);
    MainForm.AddMainLog('Missing scrolling news files',Colors.Error);
    Exit;
  end;
  htmlCode := Misc.ReadFile2(ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_TEMPLATE);
  itemHtmlCode := Misc.ReadFile2(ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_ITEM_TEMPLATE);
  newItemHtmlCode := Misc.ReadFile2(ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_NEW_ITEM_TEMPLATE);

  //points to local XML file in "original" code
  ScrollingNewsRSS.Destroy;
  ScrollingNewsRSS := TXMLDocument.Create(MainForm);
  try
    ScrollingNewsRSS.FileName := SCROLLING_NEWS_RSS_URL;
    ScrollingNewsRSS.Active:=True;
    ScrollingNewsRSS.Resync;
  except
    MainForm.AddMainLog(_('Scrolling news RSS Feed''s server unavailable.'),Colors.Error);
    Exit;
  end;

  StartItemNode := ScrollingNewsRSS.DocumentElement.ChildNodes.First.ChildNodes.FindNode('item') ;

  firstNewsRefresh := displayedNewsList.Count = 0;

  ANode := StartItemNode;
  repeat
    STitle := ANode.ChildNodes['title'].Text;
    sLink := ANode.ChildNodes['link'].Text;
    sDesc := ANode.ChildNodes['description'].Text;

    if firstNewsRefresh or (displayedNewsList.IndexOf(STitle) > -1) then
    begin
      temp := StringReplace(itemHtmlCode,'[title]',STitle,[rfReplaceAll,rfIgnoreCase]);
      if firstNewsRefresh then
        displayedNewsList.Add(STitle);
    end
    else
    begin
      temp := StringReplace(newItemHtmlCode,'[title]',STitle,[rfReplaceAll,rfIgnoreCase]);
      displayedNewsList.Add(STitle);
    end;

    temp := StringReplace(temp,'[url]',sLink,[rfReplaceAll,rfIgnoreCase]);
    temp := StringReplace(temp,'[description]',sDesc,[rfReplaceAll,rfIgnoreCase]);

    htmlNewsCode := htmlNewsCode + temp + EOL;

    ANode := ANode.NextSibling;
  until ANode = nil;

  htmlCode := StringReplace(htmlCode,'[newsItems]',htmlNewsCode,[rfReplaceAll, rfIgnoreCase]);

  try
    SaveFile(ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_PAGE,htmlCode);
  except
  end;
  ScrollingNewsBrowser.Navigate('file://'+ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_PAGE);
end;

procedure TMainForm.ExpandNewsButtonClick(Sender: TObject);
begin
  if NewsPanel.Visible then
  begin
    NewsMainPanel.Align := alTop;
    NewsMainPanel.Height := 50;
    Panel1.Visible := True;
    ScrollingNewsPanel.Visible := True;
    NewsPanel.Visible := False;
    ExpandNewsButton.ImageIndex := 1;
  end
  else
  begin
    Panel1.Visible := False;
    NewsMainPanel.Align := alClient;
    ScrollingNewsPanel.Visible := False;
    NewsPanel.Align := alClient;
    NewsPanel.Visible := True;
    NewsBrowser.Visible := True;
    ExpandNewsButton.ImageIndex := 0;
    NewsBrowser.Repaint;
    try
      NewsBrowser.Refresh2;
    except
    end;
    NewsBrowser.SetFocus;
  end;
end;

procedure TMainForm.NewsBrowserNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
  Cancel := True;
end;

procedure TMainForm.OnNewsBrowserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  // nothing
end;

procedure TMainForm.OnNewsBrowserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if (LowerCase(URL) = 'about:blank') or (RightStr(LowerCase(URL),Length(NEWS_URL)) = LowerCase(NEWS_URL)) or (LowerCase(URL) = LowerCase(NEWS_URL)) or (LowerCase(URL) = LowerCase(NEWS_URL+'/')) or (LowerCase(URL) = LowerCase(ExtractFilePath(Application.ExeName) + SCROLLING_NEWS_DIR + SCROLLING_NEWS_PAGE)) then Exit;
  Cancel := True;
  Misc.OpenURLInDefaultBrowser(URL);
end;

procedure TMainForm.RefreshMainLog(var AMsg: TMessage);
var
  i:integer;
begin
  if (ChatTabs = nil) or (ChatTabs.Count < 1) then Exit;
  mainLogBuffer.BeginUpdate;
  for i:=0 to mainLogBuffer.Count-1 do
    AddTextToChatWindow(TMyTabSheet(ChatTabs[0]), mainLogBuffer[i], TColor(mainLogBufferColor.Items[i]));
  mainLogBuffer.EndUpdate;
  mainLogBuffer.Clear;
  mainLogBufferColor.Clear;
end;

procedure TMainForm.PlayerFiltersTextboxChange(Sender: TObject);
begin
  UpdateClientsListBox;
end;

procedure TMainForm.mnuAutojoinOptionsClick(Sender: TObject);
begin
  AutoJoinForm.ShowModal;
end;

procedure TMainForm.mnuSpringinfoClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://www.springinfo.info/');
end;

function TMainForm.getAutojoinBestBattle(autoJoinPresetList:TList):TBattle;
var
  SortStyle: byte;
  i,j,k: integer;
  curPreset : TPresetFilters;
  presetFound: boolean;
begin
  Result := nil;
  if autoJoinPresetList.Count = 0 then
    Exit;

  curPreset.TextFilters := TList.Create;

  for i:=0 to autoJoinPresetList.Count-1 do
  begin
    presetFound := False;
    if LowerCase(PAutoJoinPresetItemList(autoJoinPresetList[i]).PresetName) = _('current') then
    begin
      CopyFilters(CurrentFilters,curPreset);
      presetFound := True;
    end
    else
      for j:=0 to PresetList.Count-1 do
      begin
        if LowerCase(PPresetFilters(PresetList[j]).Name) = LowerCase(PAutoJoinPresetItemList(autoJoinPresetList[i]).PresetName) then
        begin
          CopyFilters(PPresetFilters(PresetList[j])^,curPreset);
          presetFound := True;
          break;
        end;
      end;
    if presetFound then
    begin
      curPreset.Locked := True;
      case PAutoJoinPresetItemList(autoJoinPresetList[i]).Sorting of
        0: SortStyle := 5; // host
        1: SortStyle := 4; // map
        2: SortStyle := 1; // state
        3: SortStyle := 2; // mod
        4: SortStyle := 6; // avg rank
        5: SortStyle := 3; // players
        6: SortStyle := 9; // players/maxplayers
      end;
      SortBattlesList(AutoJoinBattles,SortStyle,PAutoJoinPresetItemList(autoJoinPresetList[i]).SortingDirection=0,False);
      for k:=0 to AutoJoinBattles.Count-1 do
        if isBattleVisible(TBattle(AutoJoinBattles[k]),curPreset,False) and (not TBattle(AutoJoinBattles[k]).Locked or (AutoJoinBattles[k] = BattleState.Battle)) then
        begin
          Result := TBattle(AutoJoinBattles[k]);
          curPreset.TextFilters.Clear;
          Exit;
        end;
    end;
  end;
  curPreset.TextFilters.Clear;
end;

procedure TMainForm.mnuPlaynowClick(Sender: TObject);
var
  Battle:TBattle;
begin
  Battle := getAutojoinBestBattle(AutoJoinForm.autoPlayPresetList);
  if Battle = nil then
  begin
    MessageDlg(_('Sorry, there is no battle matching your preset filters.'),mtInformation,[mbOK],0);
    Exit;
  end;
  JoinBattle(Battle);
end;

procedure TMainForm.mnuSpecnowClick(Sender: TObject);
var
  Battle:TBattle;
begin
  Battle := getAutojoinBestBattle(AutoJoinForm.autoSpecPresetList);
  if Battle = nil then
  begin
    MessageDlg(_('Sorry, there is no battle matching your preset filters.'),mtInformation,[mbOK],0);
    Exit;
  end;
  JoinBattle(Battle,True);
end;

procedure TMainForm.AutojoinTimerTimer(Sender: TObject);
var
  Battle:TBattle;
begin
  AutojoinTimer.Interval := 1000;
  if Status.LoggedIn and (mnuAutoplayFirstAvailable.Checked or mnuAutospecFirstAvailable.Checked) and not BattleForm.AmIReady and not InitWaitForm.Visible and (not Status.Me.GetInGameStatus or (Status.Me.GetInGameStatus and not BattleForm.IsBattleActive)) and (BattleState.JoiningComplete or (BattleState.Status = None)) then
  begin
    if mnuAutoplayFirstAvailable.Checked then
      Battle := getAutojoinBestBattle(AutoJoinForm.autoPlayPresetList)
    else
      Battle := getAutojoinBestBattle(AutoJoinForm.autoSpecPresetList);
    if (Battle = nil) and AutoJoinForm.chkLeaveNotFittingBattles.Checked then
      BattleForm.DisconnectButtonClick(nil);
    if (Battle = nil) or Battle.Locked or Battle.Password or ((BattleState.Status <> None) and (Battle = BattleState.Battle)) then
    begin
      Exit;
    end;
    AutojoinTimer.Interval := 8000;
    BattleForm.DisconnectButtonClick(nil);
    JoinBattle(Battle,mnuAutospecFirstAvailable.Checked);
    if not AutoJoinForm.chkKeepLookingAfterJoining.Checked then
    begin
      mnuAutoplayFirstAvailable.Checked := False;
      mnuAutospecFirstAvailable.Checked := False;
    end;
    Exit;
  end;
end;

procedure TMainForm.mnuAutoplayFirstAvailableClick(Sender: TObject);
begin
  mnuAutospecFirstAvailable.Checked := False;
end;

procedure TMainForm.mnuAutospecFirstAvailableClick(Sender: TObject);
begin
  mnuAutoplayFirstAvailable.Checked := False;
end;

procedure TMainForm.ClearPlayersFilterButtonClick(Sender: TObject);
begin
  PlayerFiltersTextbox.Text := '';
end;

procedure TMainForm.SpTBXButton1Click(Sender: TObject);
begin
  AddBotForm.Show;
end;

procedure TMainForm.SpTBXItem5Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(_('http://springrts.com/wiki/Main_Page'));
end;

procedure LoadTASClientIni(FileName: string);
var
  Ini : TIniFile;
  tmpStr: string;
begin
  try
    //FileName := ExtractFilePath(Application.ExeName) + CUSTOM_TASCLIENT_FILE;
    if FileExists(FileName) then
    begin
      if MidStr(FileName,2,2) <> ':\' then
        FileName := ExtractFilePath(Application.ExeName)+FileName;
      Ini := TIniFile.Create(FileName);
      TASCLIENT_REGISTRY_KEY := Ini.ReadString('General','RegistryKey',TASCLIENT_REGISTRY_KEY);
      AUTOUPDATE_URL := Ini.ReadString('General','AutoUpdateURL',AUTOUPDATE_URL);
      NEWS_URL := Ini.ReadString('News','NewsURL',NEWS_URL);
      SCROLLING_NEWS_RSS_URL := Ini.ReadString('News','ScrollingNewsRSSFeed',SCROLLING_NEWS_RSS_URL);
      DISABLE_FADEIN := Ini.ReadBool('SplashScreen','DisableFadeIn',false);
      tmpStr := Ini.ReadString('SplashScreen','Image','');
      WIDGETDB_MANAGER_URL := Ini.ReadString('WidgetDB','ManagerURL',WIDGETDB_MANAGER_URL);
      SPRINGDOWNLOADER_SERVICE_URL := Ini.ReadString('SpringDownloader','ServiceURL',SPRINGDOWNLOADER_SERVICE_URL);
      RAPID_DOWNLOADER_URL := Ini.ReadString('SpringDownloader','RapidURL',RAPID_DOWNLOADER_URL);
      RELAYHOST_MANAGER_NAME := Ini.ReadString('Spring','RelayHostManagerName',RELAYHOST_MANAGER_NAME);

      if tmpStr <> '' then
      begin
        if MidStr(tmpStr,2,2) <> ':\' then
          tmpStr := ExtractFilePath(Application.ExeName)+tmpStr;
        try
          SplashScreenForm.Image1.Picture.LoadFromFile(tmpStr);
        except
        end;
      end;

      // version label
      tmpStr := Ini.ReadString('SplashScreen','VersionLabelX','');
      if tmpStr <> '' then
        try SplashScreenForm.VersionLabel.Left := StrToInt(tmpStr); except end;
      tmpStr := Ini.ReadString('SplashScreen','VersionLabelY','');
      if tmpStr <> '' then
        try SplashScreenForm.VersionLabel.Top := StrToInt(tmpStr); except end;
      tmpStr := Ini.ReadString('SplashScreen','VersionLabelColor','');
      if tmpStr <> '' then
        try SplashScreenForm.VersionLabel.Font.Color := StandardRGBToColor(HexToInt(tmpStr)); except end;

      // InfoLabel
      tmpStr := Ini.ReadString('SplashScreen','InfoLabelX','');
      if tmpStr <> '' then
        try SplashScreenForm.InfoLabel.Left := StrToInt(tmpStr); except end;
      tmpStr := Ini.ReadString('SplashScreen','InfoLabelY','');
      if tmpStr <> '' then
        try SplashScreenForm.InfoLabel.Top := StrToInt(tmpStr); except end;
      tmpStr := Ini.ReadString('SplashScreen','InfoLabelColor','');
      if tmpStr <> '' then
        try SplashScreenForm.InfoLabel.Font.Color := StandardRGBToColor(HexToInt(tmpStr)); except end;
    end;
  except
  end;
end;

procedure TMainForm.OnDockHandlerRefresh(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to DockHandler.PageControlHostCount-1 do
  begin
    DockHandler.PageControlHosts[i].PageControl.OnChange := PageControl1Change;
    DockHandler.PageControlHosts[i].PageControl.OnMouseDown := PageControl1MouseDown;
    DockHandler.PageControlHosts[i].PageControl.OnResize := PageControl1Resize;
  end;
end;

procedure TMainForm.ViewItemClick(Sender: TObject);
begin
  TControl(TSpTBXItem(Sender).Tag).Visible := not TControl(TSpTBXItem(Sender).Tag).Visible;
end;

procedure TMainForm.mnuPreferencesClick(Sender: TObject);
begin
  PreferencesForm.ShowModal;
end;

procedure TMainForm.mnuLockViewClick(Sender: TObject);
var
  l: TList;
  i,j: integer;
begin
  l := TList.Create;
  DockHandler.AddDockedPanelsToList(l);
  for i:=0 to l.Count-1 do
    if mnuLockView.Checked then
    begin
      try
        TPanel(l[i]).DragMode := dmManual;
      except
      end;
      try
        TDockableForm(l[i]).DragKind := dkDrag;
      except
      end;
    end
    else
    begin
      try
        TPanel(l[i]).DragMode := dmAutomatic;
      except
      end;
      try
        TDockableForm(l[i]).DragKind := dkDock;
      except
      end;
    end;
end;

procedure TMainForm.mnuResetViewClick(Sender: TObject);
var
  i: integer;
begin
  if MessageDlg(_('Do you really want to reset the layout to default ?'),mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
  DockHandler.LoadDesktop('',PreferencesForm.LayoutDefault.Text);
  MainForm.MainPCH.PageControl.Style := TTabStyle(Preferences.TabStyle);
  for i:=1 to ChatTabs.Count-1 do
  begin
    TMyTabSheet(ChatTabs[i]).ManualDock(MainPCH.PageControl);
    TMyTabSheet(ChatTabs[i]).Visible := True;
  end;
  PageControl1Resize(nil);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if SaveLayoutOnClose then
    DockHandler.SaveDesktop(TASCLIENT_REGISTRY_KEY+'\Layout');
  CanClose := true;
end;

constructor TDemoHeaderGeneric.Create;
begin
  version := -1;
end;
function TDemoHeaderGeneric.getMagic: string;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.magic
  else if version = 4 then
    Result := demoHeaderV4.magic
  else if version = 5 then
    Result := demoHeaderV5.magic
  else
    Result := '';
end;
function TDemoHeaderGeneric.getHeaderSize: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.headerSize
  else if version = 4 then
    Result := demoHeaderV4.headerSize
  else if version = 5 then
    Result := demoHeaderV5.headerSize
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getVersionString: string;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.versionString
  else if version = 4 then
    Result := demoHeaderV4.versionString
  else if version = 5 then
    Result := demoHeaderV5.versionString
  else
    Result := '';
end;
function TDemoHeaderGeneric.getGameID: string;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.gameID
  else if version = 4 then
    Result := demoHeaderV4.gameID
  else if version = 5 then
    Result := demoHeaderV5.gameID
  else
    Result := '';
end;
function TDemoHeaderGeneric.getUnixTime: UInt64;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.unixTime
  else if version = 4 then
    Result := demoHeaderV4.unixTime
  else if version = 5 then
    Result := demoHeaderV5.unixTime
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getScriptSize: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.scriptSize
  else if version = 4 then
    Result := demoHeaderV4.scriptSize
  else if version = 5 then
    Result := demoHeaderV5.scriptSize
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getDemoStreamSize: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.demoStreamSize
  else if version = 4 then
    Result := demoHeaderV4.demoStreamSize
  else if version = 5 then
    Result := demoHeaderV5.demoStreamSize
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getGameTime: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.gameTime
  else if version = 4 then
    Result := demoHeaderV4.gameTime
  else if version = 5 then
    Result := demoHeaderV5.gameTime
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getWallClockTime: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.wallclockTime
  else if version = 4 then
    Result := demoHeaderV4.wallclockTime
  else if version = 5 then
    Result := demoHeaderV5.wallclockTime
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getMaxPlayerNum: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.maxPlayerNum
  else if version = 4 then
    Result := 0
  else if version = 5 then
    Result := 0
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getNumPlayers: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.numPlayers
  else if version = 4 then
    Result := demoHeaderV4.numPlayers
  else if version = 5 then
    Result := demoHeaderV5.numPlayers
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getPlayerStatSize: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.playerStatSize
  else if version = 4 then
    Result := demoHeaderV4.playerStatSize
  else if version = 5 then
    Result := demoHeaderV5.playerStatSize
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getPlayerStatElemSize: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.playerStatElemSize
  else if version = 4 then
    Result := demoHeaderV4.playerStatElemSize
  else if version = 5 then
    Result := demoHeaderV5.playerStatElemSize
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getNumTeams: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.numTeams
  else if version = 4 then
    Result := demoHeaderV4.numTeams
  else if version = 5 then
    Result := demoHeaderV5.numTeams
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getTeamStatSize: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.teamStatSize
  else if version = 4 then
    Result := demoHeaderV4.teamStatSize
  else if version = 5 then
    Result := demoHeaderV5.teamStatSize
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getTeamStatElemSize: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.teamStatElemSize
  else if version = 4 then
    Result := demoHeaderV4.teamStatElemSize
  else if version = 5 then
    Result := demoHeaderV5.teamStatElemSize
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getTeamStatPeriod: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.teamStatPeriod
  else if version = 4 then
    Result := demoHeaderV4.teamStatPeriod
  else if version = 5 then
    Result := demoHeaderV5.teamStatPeriod
  else
    Result := 0;
end;
function TDemoHeaderGeneric.getWinningAllyTeam: integer;
begin
  if version = -1 then
    Raise Exception.Create('Demoheader not initialized.');
  if version <= 3 then
    Result := demoHeaderV3.winningAllyTeam
  else if version = 4 then
    Result := demoHeaderV4.winningAllyTeam
  else if version = 5 then
    Result := -1
  else
    Result := -1;
end;

function TDemoHeaderGeneric.getWinningAllyTeamsSize: integer;
begin
  if version <> 5 then
    Result := -1
  else if version = 5 then
    Result := demoHeaderV5.winningAllyTeamsSize;
end;

function TDemoHeaderGeneric.getPlayerStatsPosition;
begin
  if version < 4 then
    Result := -1
  else if version = 4 then
    Result := headerSize + scriptSize + demoStreamSize
  else if version = 5 then
    Result := headerSize + scriptSize + demoStreamSize + winningAllyTeamsSize
  else
    Result := -1;
end;

function TDemoHeaderGeneric.getWinningAllyTeamsSizePosition: integer;
begin
  if version < 5 then
    Result := -1
  else if version = 5 then
    Result := headerSize + scriptSize + demoStreamSize
  else
    Result := -1;
end;

procedure TMainForm.mnuSaveNewLayoutClick(Sender: TObject);
var
  FileName: String;
  Ini : TIniFile;
  layoutName: string;
begin
  layoutName := InputBox(_('Save new layout'),_('New layout name :'),'New layout '+IntToStr(LoadLayoutSubmenu.Count+1));
  try
    FileName := ExtractFilePath(Application.ExeName) + LAYOUTS_FILE;
    Ini := TIniFile.Create(FileName);
    if Ini.ValueExists('Layouts',layoutName) then
      if MessageDlg(Format(_('%s already exists, replace ?'),[layoutName]),mtConfirmation,[mbYes,mbNo],0) <> mrYes then
        Exit;
    Ini.WriteString('Layouts',layoutName,DockHandler.AsString);
    Ini.Free;
    SaveLayoutSubmenu.Add(TSpTBXItem.Create(SaveLayoutSubmenu));
    with SaveLayoutSubmenu.Items[SaveLayoutSubmenu.Count-1] as TSpTBXItem do
    begin
      Caption := layoutName;
      OnClick := mnuSaveLayoutClick;
    end;
    LoadLayoutSubmenu.Add(TSpTBXItem.Create(LoadLayoutSubmenu));
    with LoadLayoutSubmenu.Items[LoadLayoutSubmenu.Count-1] as TSpTBXItem do
    begin
      Caption := layoutName;
      OnClick := mnuLoadLayoutClick;
    end;
    DeleteLayoutSubmenu.Add(TSpTBXItem.Create(DeleteLayoutSubmenu));
    with DeleteLayoutSubmenu.Items[DeleteLayoutSubmenu.Count-1] as TSpTBXItem do
    begin
      Caption := layoutName;
      OnClick := mnuDeleteLayoutClick;
    end;
  except
    Exit;
  end;
end;

procedure TMainForm.mnuSaveLayoutClick(Sender: TObject);
var
  FileName: String;
  Ini : TIniFile;
  layoutName: string;
begin
  layoutName := TSpTBXItem(Sender).Caption;
  try
    FileName := ExtractFilePath(Application.ExeName) + LAYOUTS_FILE;
    Ini := TIniFile.Create(FileName);
    Ini.WriteString('Layouts',layoutName,DockHandler.AsString);
    Ini.Free;
  except
    Exit;
  end;
end;

procedure TMainForm.mnuLoadLayoutClick(Sender: TObject);
var
  FileName: String;
  Ini : TIniFile;
  layoutName: string;
  layoutData: string;
  i: integer;
begin
  layoutName := TSpTBXItem(Sender).Caption;
  try
    FileName := ExtractFilePath(Application.ExeName) + LAYOUTS_FILE;
    Ini := TIniFile.Create(FileName);
    SetLength(layoutData,10000);
    GetPrivateProfileString('Layouts',PChar(layoutName),PChar(PreferencesForm.LayoutDefault.Text),PChar(layoutData),10000,PChar(FileName));
    DockHandler.AsString := layoutData;
    for i:=1 to ChatTabs.Count-1 do
      if not TMyTabSheet(ChatTabs[i]).Visible then
      begin
        TMyTabSheet(ChatTabs[i]).ManualDock(MainPCH.PageControl);
        TMyTabSheet(ChatTabs[i]).Visible := True;
      end;

    for i:=0 to DockHandler.PageControlHostCount-1 do
      DockHandler.PageControlHosts[i].PageControl.MultiLine := True;

    PageControl1Resize(nil);
    Ini.Free;
  except
    Exit;
  end;
end;

procedure TMainForm.mnuDeleteLayoutClick(Sender: TObject);
var
  FileName: String;
  Ini : TIniFile;
  layoutName: string;
  i: integer;
begin
  layoutName := TSpTBXItem(Sender).Caption;
  try
    FileName := ExtractFilePath(Application.ExeName) + LAYOUTS_FILE;
    Ini := TIniFile.Create(FileName);
    Ini.DeleteKey('Layouts',layoutName);
    Ini.Free;
    for i:=2 to SaveLayoutSubmenu.Count-1 do
      if SaveLayoutSubmenu.Items[i].Caption = layoutName then
        SaveLayoutSubmenu.Delete(i);
    for i:=0 to LoadLayoutSubmenu.Count-1 do
      if LoadLayoutSubmenu.Items[i].Caption = layoutName then
        LoadLayoutSubmenu.Delete(i);
    for i:=0 to DeleteLayoutSubmenu.Count-1 do
      if DeleteLayoutSubmenu.Items[i].Caption = layoutName then
        DeleteLayoutSubmenu.Delete(i);
  except
    Exit;
  end;
end;

procedure TMainForm.LoadLayouts;
var
  FileName: String;
  Ini : TIniFile;
  layoutList: TStringList;
  i: integer;
begin
  try
    FileName := ExtractFilePath(Application.ExeName) + LAYOUTS_FILE;
    Ini := TIniFile.Create(FileName);
    layoutList := TStringList.Create;
    Ini.ReadSection('Layouts',layoutList);
    for i:=2 to SaveLayoutSubmenu.Count-1 do
      SaveLayoutSubmenu.Remove(SaveLayoutSubmenu.Items[i]);
    LoadLayoutSubmenu.Clear;
    for i:=0 to layoutList.Count-1 do
    begin
      SaveLayoutSubmenu.Add(TSpTBXItem.Create(SaveLayoutSubmenu));
      with SaveLayoutSubmenu.Items[SaveLayoutSubmenu.Count-1] as TSpTBXItem do
      begin
      Caption := layoutList[i];
      OnClick := mnuSaveLayoutClick;
      end;
      LoadLayoutSubmenu.Add(TSpTBXItem.Create(LoadLayoutSubmenu));
      with LoadLayoutSubmenu.Items[LoadLayoutSubmenu.Count-1] as TSpTBXItem do
      begin
        Caption := layoutList[i];
        OnClick := mnuLoadLayoutClick;
      end;
      DeleteLayoutSubmenu.Add(TSpTBXItem.Create(DeleteLayoutSubmenu));
      with DeleteLayoutSubmenu.Items[DeleteLayoutSubmenu.Count-1] as TSpTBXItem do
      begin
        Caption := layoutList[i];
        OnClick := mnuDeleteLayoutClick;
      end;
    end;
    Ini.Free;
  except
    Exit;
  end;
end;


procedure TMainForm.mnuSpringOptionsClick(Sender: TObject);
begin
  PreferencesForm.GameSettingsButtonClick(nil);
end;

procedure TMainForm.PresetListboxDblClick(Sender: TObject);
begin
  if (PresetListbox.ItemIndex < 1) then Exit;
  CopyFilters(PPresetFilters(PresetList[PresetListbox.ItemIndex-1])^, CurrentFilters);
  PresetNameTextbox.Text := PPresetFilters(PresetList[PresetListbox.ItemIndex-1])^.Name;
  UpdateFilters(CurrentFilters);
  RefreshBattleList;
end;

procedure TMainForm.Players2FilterClick(Sender: TObject);
begin
  if not Players2Filter.Focused then Exit;
  CurrentFilters.Players2.enabled := Players2Filter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.Players2SignButtonClick(Sender: TObject);
begin
  if Players2SignButton.Caption = '>' then
  begin
    Players2SignButton.Caption := '<';
    CurrentFilters.Players2.filterType := Inf;
  end
  else if Players2SignButton.Caption = '<' then
  begin
    Players2SignButton.Caption := '=';
    CurrentFilters.Players2.filterType := Equal;
  end
  else
  begin
    Players2SignButton.Caption := '>';
    CurrentFilters.Players2.filterType := Sup;
  end;
  FiltersUpdated;
end;

procedure TMainForm.Players2ValueTextBoxChange(Sender: TObject);
begin
  if not Players2ValueTextBox.Focused then Exit;
  CurrentFilters.Players2.value := Players2ValueTextBox.SpinOptions.ValueAsInteger;
  FiltersUpdated;
end;

procedure TMainForm.FilterListEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column = 3;
end;

procedure TMainForm.FilterListNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
  TFilterText(CurrentFilters.TextFilters[GetFilterIndexFromNode(Node)]^).value := NewText;
  RefreshBattleList;
  FiltersUpdated;
end;

procedure TMainForm.FilterListClick(Sender: TObject);
var
  ht: THitInfo;
  pt: TPoint;
begin
  GetCursorPos(pt);
  pt := FilterList.ScreenToClient(pt);
  FilterList.GetHitTestInfoAt(pt.X,pt.Y,False,ht);
  FilterList.FocusedColumn := ht.HitColumn;
  if FilterList.FocusedNode <> ht.HitNode then
  begin
    FilterList.FocusedNode := ht.HitNode;
    FilterList.Selected[ht.HitNode] := True;
  end;
end;

procedure TMainForm.AutoSpecFirstAvailablePresetClick(Sender: TObject);
begin
  AutoJoinForm.lstPresetList.ItemIndex := TSpTBXItem(Sender).Tag;
  AutoJoinForm.lstPresetListDblClick(nil);
  if TSpTBXItem(Sender).Checked then
  begin
    mnuAutospecFirstAvailable.Checked := False;
    mnuAutoplayFirstAvailable.Checked := False;
  end
  else
  begin
    mnuAutospecFirstAvailable.Checked := True;
    mnuAutoplayFirstAvailable.Checked := False;
  end;
  mnuAutospecFirstAvailable.Tag := TSpTBXItem(Sender).Tag;
end;

procedure TMainForm.AutoPlayFirstAvailablePresetClick(Sender: TObject);
begin
  AutoJoinForm.lstPresetList.ItemIndex := TSpTBXItem(Sender).Tag;
  AutoJoinForm.lstPresetListDblClick(nil);
  if TSpTBXItem(Sender).Checked then
  begin
    mnuAutospecFirstAvailable.Checked := False;
    mnuAutoplayFirstAvailable.Checked := False;
  end
  else
  begin
    mnuAutospecFirstAvailable.Checked := False;
    mnuAutoplayFirstAvailable.Checked := True;
  end;
  mnuAutoplayFirstAvailable.Tag := TSpTBXItem(Sender).Tag;
end;

procedure TMainForm.PlayNowClick(Sender: TObject);
begin
  AutoJoinForm.lstPresetList.ItemIndex := TSpTBXItem(Sender).Tag;
  AutoJoinForm.lstPresetListDblClick(nil);
  mnuPlaynowClick(nil);
end;

procedure TMainForm.SpecNowClick(Sender: TObject);
begin
  AutoJoinForm.lstPresetList.ItemIndex := TSpTBXItem(Sender).Tag;
  AutoJoinForm.lstPresetListDblClick(nil);
  mnuSpecnowClick(nil);
end;

procedure TMainForm.AutojoinPopupMenuPopup(Sender: TObject);
var
  i:integer;
begin
  SubMenuAutoplayFirstAvailable.Clear;
  SubMenuAutospecFirstAvailable.Clear;
  SubMenuPlaynow.Clear;
  SubMenuSpecnow.Clear;

  if AutoJoinForm.lstPresetList.Items.Count = 1 then
  begin
    mnuAutoplayFirstAvailable.Visible := True;
    mnuAutospecFirstAvailable.Visible := True;
    mnuPlaynow.Visible := True;
    mnuSpecnow.Visible := True;
    SubMenuAutoplayFirstAvailable.Visible := False;
    SubMenuAutospecFirstAvailable.Visible := False;
    SubMenuPlaynow.Visible := False;
    SubMenuSpecnow.Visible := False;
  end
  else
  begin
    mnuAutoplayFirstAvailable.Visible := False;
    mnuAutospecFirstAvailable.Visible := False;
    mnuPlaynow.Visible := False;
    mnuSpecnow.Visible := False;
    SubMenuAutoplayFirstAvailable.Visible := True;
    SubMenuAutospecFirstAvailable.Visible := True;
    SubMenuPlaynow.Visible := True;
    SubMenuSpecnow.Visible := True;

    for i:=0 to AutoJoinForm.lstPresetList.Items.Count-1 do
    begin
      SubMenuSpecnow.Add(TSpTBXItem.Create(SubMenuSpecnow));
      with SubMenuSpecnow.Items[SubMenuSpecnow.Count-1] as TSpTBXItem do
      begin
        Caption := AutoJoinForm.lstPresetList.Items[i];
        Tag := i;
        OnClick := SpecNowClick;
      end;
      SubMenuPlaynow.Add(TSpTBXItem.Create(SubMenuPlaynow));
      with SubMenuPlaynow.Items[SubMenuPlaynow.Count-1] as TSpTBXItem do
      begin
        Caption := AutoJoinForm.lstPresetList.Items[i];
        Tag := i;
        OnClick := PlayNowClick;
      end;

      SubMenuAutospecFirstAvailable.Add(TSpTBXItem.Create(SubMenuAutospecFirstAvailable));
      with SubMenuAutospecFirstAvailable.Items[SubMenuAutospecFirstAvailable.Count-1] as TSpTBXItem do
      begin
        Caption := AutoJoinForm.lstPresetList.Items[i];
        Tag := i;
        OnClick := AutoSpecFirstAvailablePresetClick;
        if mnuAutospecFirstAvailable.Checked then
          if mnuAutospecFirstAvailable.Tag = i then
            Checked := True;
      end;
      SubMenuAutoplayFirstAvailable.Add(TSpTBXItem.Create(SubMenuAutoplayFirstAvailable));
      with SubMenuAutoplayFirstAvailable.Items[SubMenuAutoplayFirstAvailable.Count-1] as TSpTBXItem do
      begin
        Caption := AutoJoinForm.lstPresetList.Items[i];
        Tag := i;
        OnClick := AutoPlayFirstAvailablePresetClick;
        if mnuAutoplayFirstAvailable.Checked then
          if mnuAutoplayFirstAvailable.Tag = i then
            Checked := True;
      end;
    end;
  end;
  MainForm.Refresh;
end;

procedure TMainForm.RankFilterClick(Sender: TObject);
begin
  if not RankFilter.Focused then Exit;
  CurrentFilters.AvgRank.enabled := RankFilter.Checked;
  FiltersUpdated;
end;

procedure TMainForm.RankSignButtonClick(Sender: TObject);
begin
  if RankSignButton.Caption = '>' then
  begin
    RankSignButton.Caption := '<';
    CurrentFilters.AvgRank.filterType := Inf;
  end
  else if RankSignButton.Caption = '<' then
  begin
    RankSignButton.Caption := '=';
    CurrentFilters.AvgRank.filterType := Equal;
  end
  else
  begin
    RankSignButton.Caption := '>';
    CurrentFilters.AvgRank.filterType := Sup;
  end;
  FiltersUpdated;
end;

procedure TMainForm.RankValueTextBoxChange(Sender: TObject);
begin
  if not RankValueTextBox.Focused then Exit;
  CurrentFilters.AvgRank.value := RankValueTextBox.SpinOptions.ValueAsInteger;
  FiltersUpdated;
end;

procedure TMainForm.OptionsPopupMenuPopup(Sender: TObject);
var
  i: integer;
  l: TList;
begin
  l := TList.Create;
  DockHandler.AddDockedPanelsToList(l);

  ViewSubMenu.Clear;
  for i:=0 to l.Count-1 do
  begin
    ViewSubMenu.Add(TSpTBXItem.Create(ViewSubMenu));
    with ViewSubMenu.Items[ViewSubMenu.Count-1] as TSpTBXItem do
    begin
      if TObject(l[i]) is TPageControlHost then
        Caption := TPageControl(l[i]).Name
      else
        Caption := TPanel(l[i]).Caption;
      Checked := TPanel(l[i]).Visible;
      OnClick := ViewItemClick;
      Tag := Integer(TControl(l[i]));
    end;
  end;
end;

procedure TMainForm.mnuRenameClick(Sender: TObject);
var
  client: TClient;
begin
  client := GetClient(SelectedUserName);
  client.DisplayName := InputBox(_('Rename user'),_('New name (leave empty to disable renaming) :'),client.DisplayName);
  SortClientInLists(client);
  UpdateClientsListBox;
  if Preferences.BattleSortStyle = 5 then
  begin
    SortBattlesList(Battles ,Preferences.BattleSortStyle, Preferences.BattleSortDirection = 0);
    RefreshBattlesNodes;
  end;
  VDTBattles.Refresh;
  if client.InBattle and BattleForm.IsBattleActive and (BattleState.Battle.Clients.IndexOf(Client) > -1) and (Preferences.BattleClientSortStyle = 0) then
  begin
    BattleForm.SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
    BattleForm.VDTBattleClients.Refresh;
  end;
end;

procedure TMainForm.LoadRenames;
var
  FileName: String;
  Ini : TIniFile;
  i:integer;
  sl: TStringList;
begin
  try
    FileName := ExtractFilePath(Application.ExeName) + RENAMES_FILE;
    Ini := TIniFile.Create(FileName);
    sl := TStringList.Create;
    Ini.ReadSection('Renames',sl);
    for i:=0 to sl.Count-1 do
    begin
      TClient.SetDisplayName(StrToInt(sl[i]),Ini.ReadString('Renames',sl[i],''));
      TClient.SetIsRenamed(StrToInt(sl[i]),True);
    end;

    sl.Free;
    Ini.Free;
  except
    MainForm.AddMainLog(_('An error occured while loading the Renames file.'),Colors.Error);
  end;
end;

procedure TMainForm.BattleListPopupMenuPopup(Sender: TObject);
begin
  VDTBattles.SetFocus;
  if (VDTBattles.FocusedNode <> nil) and VDTBattles.Selected[VDTBattles.FocusedNode] then
  begin
    SelectedBattle := GetBattleFromNode(VDTBattles.FocusedNode);
    ContextMenuSelectedClient := SelectedBattle.Clients[0];
    ClientPopupMenuPopup(nil);
    mnuBattleHost.Caption := ContextMenuSelectedClient.DisplayName;
    mnuBattleDlMap.Enabled := Utility.MapList.IndexOf(SelectedBattle.Map) = -1;
    mnuBattleDlMod.Enabled := Utility.ModList.IndexOf(SelectedBattle.ModName) = -1;
  end;
  mnuBattleHost.Visible := VDTBattles.FocusedNode <> nil;
  mnuBattleAddToFilters.Visible := VDTBattles.FocusedNode <> nil;
  mnuBattleDlMap.Visible := VDTBattles.FocusedNode <> nil;
  mnuBattleDlMod.Visible := VDTBattles.FocusedNode <> nil;
  mnuBattleHost.Visible := VDTBattles.FocusedNode <> nil;
  mnuBattleAddToFilters.Visible := VDTBattles.FocusedNode <> nil;
  if QuickJoinPanel.Visible then
    mnuQuickJoinPanel.Caption := _('Hide Quick join panel')
  else
    mnuQuickJoinPanel.Caption := _('Show Quick join panel');

  VDTBattles.Repaint;
end;

procedure TMainForm.ClientPopupMenuPopup(Sender: TObject);
var
  Client: TClient;
  ClientGroup : TClientGroup;
  i : Integer;
begin
  Client := ContextMenuSelectedClient;

  ModerationSubmenuItem.Visible := Status.Me.GetAccess; // only moderators may see moderation menu!
  MuteSubitemMenu.Visible := LeftStr(lastActiveTab.Caption,1) = '#';
  mnuUnmute.Visible := LeftStr(lastActiveTab.Caption,1) = '#';

  mnuPlayWith.Enabled := Client.GetBattleId <> -1;
  mnuSelectBattle.Enabled := mnuPlayWith.Enabled;

  ClientGroup := Client.GetGroup;

  if ClientGroup <> nil then begin
    mnuAddToGroup.Caption := _('Move to group');
    mnuRemoveFromGroup.Enabled := True;
  end
  else
  begin
    mnuAddToGroup.Caption := _('Add to group');
    mnuRemoveFromGroup.Enabled := False;
  end;

  mnuIgnore.Checked := Client.isIgnored;

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

  mnuJoinMe.Enabled := BattleForm.IsBattleActive;

  SelectedUserName := Client.Name;
end;

procedure TMainForm.VDTBattlesHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
var
  pressedMargin: integer;
  s: string;
begin
  pressedMargin := 0;
  if Pressed then
    pressedMargin := 1;
  if Hover then
  begin
    SkinManager.CurrentSkin.PaintBackground(HeaderCanvas,R,skncHeader,sknsHotTrack,True,True);
    HeaderCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncHeader,sknsHotTrack);
  end
  else if Pressed then
  begin
    SkinManager.CurrentSkin.PaintBackground(HeaderCanvas,R,skncHeader,sknsPushed,True,True);
    HeaderCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncHeader,sknsPushed);
  end
  else
  begin
    SkinManager.CurrentSkin.PaintBackground(HeaderCanvas,R,skncHeader,sknsNormal,True,True);
    HeaderCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncHeader,sknsNormal);
  end;
  s := Sender.Columns[Column.Index].Text;

  HeaderCanvas.Brush.Style := Graphics.bsClear;
  if R.Right-R.Left-VDTBattles.Margin < HeaderCanvas.TextWidth(Sender.Columns[Column.Index].Text) then
    s := ShortenString(HeaderCanvas.Handle, s, R.Right - R.Left-VDTBattles.Margin, 0);
  HeaderCanvas.TextOut(R.Left+VDTBattles.Margin+pressedMargin,R.Top+2+pressedMargin,s);
  
  if Sender.SortColumn = Column.Index then
  begin
    ArrowList.Draw(HeaderCanvas,R.Left+VDTBattles.Margin+HeaderCanvas.TextWidth(s)+4,R.Top+1,IFF(Sender.SortDirection = sdAscending,0,1));
  end;
end;


procedure TMainForm.FilterListDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: WideString; const CellRect: TRect; var DefaultDraw: Boolean);
var
  PaintRect: TRect;
  CheckboxRect: TRect;
  hot: Boolean;
  pt: TPoint;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
begin
  DefaultDraw := True;
  if (SkinManager.GetSkinType=sknSkin) then
  begin
    with (Sender as TVirtualStringTree) do
    begin
      GetCursorPos(pt);
      pt := ScreenToClient(pt);
      GetHitTestInfoAt(pt.X,pt.Y,True,hi);
      hot := Misc.GetControlForm(Sender).Active and (hi.HitNode = Node);

      CopyRect(PaintRect,TargetCanvas.ClipRect);
      {if Header.Columns[Column].Position <> 0 then
        PaintRect.Left := PaintRect.Left - 3;
      if Header.Columns[Column].Position <> Header.Columns.Count-1 then
        PaintRect.Right := PaintRect.Right + 3;}

      if Header.Columns[Column].CheckBox then
        TargetCanvas.FillRect(TargetCanvas.ClipRect);

      itemState := SkinManager.CurrentSkin.GetState(True,False,hot,Selected[Node]);
      SkinManager.CurrentSkin.PaintBackground(TargetCanvas,PaintRect,skncListItem,itemState,True,True);
      TargetCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,itemState);
      if Header.Columns[Column].CheckBox then
      begin
        CopyRect(CheckboxRect,TargetCanvas.ClipRect);
        InflateRect(CheckboxRect,-3,-3);
        SkinManager.CurrentSkin.PaintBackground(TargetCanvas,CheckboxRect,skncCheckBox,itemState,True,True);
        if (Node.CheckState = csCheckedNormal) then
          SkinManager.CurrentSkin.PaintMenuCheckMark(TargetCanvas,CheckboxRect,True,False,False,itemState);
      end;
      TargetCanvas.Brush.Style := Graphics.bsClear;
    end;
  end;
end;

procedure TMainForm.ConnectButtonMouseEnter(Sender: TObject);
begin
  ConnectButton.ImageIndex := 1;
end;

procedure TMainForm.ConnectButtonMouseLeave(Sender: TObject);
begin
  ConnectButton.ImageIndex := Ord(Status.ConnectionState);
end;

procedure TMainForm.SpTBXItem1Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://quotes.springlobby.info/');
end;

procedure TMainForm.mnuJoinChannelClick(Sender: TObject);
var
  channelName: string;
begin
  channelName := InputBox(_('Join channel'),_('Channel name :'),'');
  if channelName <> '' then
  begin
    SwitchToNewChatRoom := True;
    ProcessCommand('JOIN #'+channelName,False);
  end;
end;

procedure TMainForm.mnuListChannelsClick(Sender: TObject);
begin
  ProcessCommand('CHANNELS',false);
end;

procedure TMainForm.PrintUnitsyncErrors;
var
  sl: TStringList;
  i: integer;
begin
  if not Debug.Enabled then
    Exit;
  sl := TStringList.Create;
  GetUnitSyncErrors(sl);
  for i:=0 to sl.Count-1 do
  begin
    MainForm.AddMainLog(sl[i],Colors.Error);
  end;
end;

procedure TMainForm.PlayersValueTextBoxSubEditButton0Click(
  Sender: TObject);
begin
  PlayersValueTextBoxChange(PlayersValueTextBox);
end;

procedure TMainForm.Players2ValueTextBoxSubEditButton0Click(
  Sender: TObject);
begin
  Players2ValueTextBoxChange(Players2ValueTextBox);
end;

procedure TMainForm.MaxPlayersValueTextBoxSubEditButton0Click(
  Sender: TObject);
begin
  MaxPlayersValueTextBoxChange(MaxPlayersValueTextBox);
end;

procedure TMainForm.RankValueTextBoxSubEditButton0Click(Sender: TObject);
begin
  RankValueTextBoxChange(RankValueTextBox);
end;

procedure TMainForm.mnuSpringWidgetDatabaseClick(Sender: TObject);
begin
  ShowAndSetFocus(WidgetDBForm.btRefresh);
  if WidgetDBForm.widgetList.Count = 0 then
    WidgetDBForm.btRefreshClick(nil);
end;

procedure TMainForm.FilterListPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Style := [];
  inherited;
end;

procedure TMainForm.BattlePlayersButtonClick(Sender: TObject);
begin
  if BattlePlayersButton.ImageIndex = 2 then
  begin
    BattlePlayersButton.Visible := False;
    BattlePlayersButton.Align := alLeft;
    BattlePlayersPanel.Visible := True;
    BattlePlayersButton.Visible := True;
    BattlePlayersSplitter.Visible := True;
    BattlePlayersButton.Align := alRight;
    BattlePlayersButton.ImageIndex := 3;
  end
  else
  begin
    BattlePlayersSplitter.Visible := False;
    BattlePlayersPanel.Visible := False;
    BattlePlayersButton.ImageIndex := 2;
  end;
end;

procedure TMainForm.GetDrawItemClientList(control: TWinControl;var res: TList);
var
  battle: TBattle;
  i: integer;
  cList: TList;
begin
  if control = ClientsListBox then
  begin
    res.Clear;
    if lastActiveTab.Caption = LOCAL_TAB then
      cList := AllClients
    else
      cList := lastActiveTab.Clients;
    for i:=0 to cList.Count-1 do
      if TClient(cList[i]).Visible then
        res.Add(cList[i]);
  end
  else
  begin
    battle := selectedBattlePlayers;
    if battle <> nil then
    begin
      res.Assign(battle.SortedClients);
    end
    else
      res.Clear
  end;
end;

procedure TMainForm.VDTBattlesFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  battle: TBattle;
begin
  battle := GetBattleFromNode(VDTBattles.FocusedNode);
  if (battle <> nil) and (battle <> selectedBattlePlayers) then
  begin
    selectedBattlePlayers := battle;
    selectedBattlePlayers.SortedClients.Assign(selectedBattlePlayers.Clients);
    SortClientsList(selectedBattlePlayers.SortedClients,Preferences.SortStyle, Preferences.SortAsc);
    UpdateBattlePlayersListBox(nil,nil);
  end;
end;

procedure TMainForm.SpTBXItem7Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(_('http://springrts.com/wiki/FAQ'));
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  TTestThread.Create(False);
end;

procedure TMainForm.tmrCumulativeDataSentHistoryTimer(Sender: TObject);
begin
  Status.CumulativeDataSentHistory.Add(Status.CumulativeDataSent);
  if Status.CumulativeDataSentHistory.Count > FLOODLIMIT_SECONDS+2 then // +2 to be sure it won't reach the limit
    Status.CumulativeDataSentHistory.Delete(0);
end;

procedure TMainForm.mnuAscSortClick(Sender: TObject);
begin
  SortLabel.ImageIndex := 0;
  Preferences.SortAsc := True;
  ResortClientsLists;
end;

procedure TMainForm.mnuDescSortClick(Sender: TObject);
begin
  SortLabel.ImageIndex := 1;
  Preferences.SortAsc := False;
  ResortClientsLists;
end;

procedure TMainForm.SortPopupMenuPopup(Sender: TObject);
begin
  mnuAscSort.Checked := Preferences.SortAsc;
  mnuDescSort.Checked := not Preferences.SortAsc;
end;

class function TClient.GetDisplayName(id: integer):WideString;
begin
  Result := '';
  if id < 0 then Exit;
  Result := ClientsDataIni.ReadString(IntToStr(id),'DisplayName','');
end;

class function TClient.GetIsRenamed(id: integer): Boolean;
begin
  Result := False;
  if id < 0 then Exit;
  Result := ClientsDataIni.ReadBool(IntToStr(id),'IsRenamed',False);
end;

class function TClient.GetNameHistory(id: integer): TWideStringList;
begin
  Result := TWideStringList.Create;
  if id < 0 then Exit;
  Result.CommaText := ClientsDataIni.ReadString(IntToStr(id),'NameHistory','');
  RemoveEmptyStrings(Result);
end;

class function TClient.GetNameHistory2(id: integer): TStringList;
begin
  Result := TStringList.Create;
  if id < 0 then Exit;
  Result.CommaText := ClientsDataIni.ReadString(IntToStr(id),'NameHistory','');
  RemoveEmptyStrings(Result);
end;

class function TClient.GetIsIgnored(id: integer): Boolean;
begin
  Result := False;
  if id < 0 then Exit;
  Result := ClientsDataIni.ReadBool(IntToStr(id),'IsIgnored',False);
end;

class procedure TClient.SetDisplayName(id: integer; displayName: WideString);
begin
  if id < 0 then Exit;
  ClientsDataIni.WriteString(IntToStr(id),'DisplayName',displayName);
end;

class procedure TClient.SetIsRenamed(id: integer; isRenamed: Boolean);
begin
  if id < 0 then Exit;
  ClientsDataIni.WriteBool(IntToStr(id),'IsRenamed',isRenamed);
end;

class procedure TClient.SetNameHistory(id: integer; NameHistory: TWideStringList);
begin
  if id < 0 then Exit;
  ClientsDataIni.WriteString(IntToStr(id),'NameHistory',NameHistory.CommaText);
end;

class procedure TClient.SetIsIgnored(id: integer; isIgnored: Boolean);
begin
  if id < 0 then Exit;
  ClientsDataIni.WriteBool(IntToStr(id),'IsIgnored',isIgnored);
end;

class function TClient.GetLatestName(id: integer):WideString;
begin
  Result := '';
  if id < 0 then Exit;
  Result := ClientsDataIni.ReadString(IntToStr(id),'LatestName','');
end;

class procedure TClient.SetLatestName(id: integer; name: WideString);
begin
  if id < 0 then Exit;
  ClientsDataIni.WriteString(IntToStr(id),'LatestName',name);
end;

class function TClient.GetIdByLatestName(latestName: WideString): Integer;
var
  strIds: TStringList;
  i: integer;
begin
  Result := 0;
  strIds := TStringList.Create;
  try
    ClientsDataIni.ReadSections(strIds);
    for i:=0 to strIds.Count-1 do
      if LowerCase(GetLatestName(StrToInt(strIds[i]))) = LowerCase(latestName) then
      begin
        Result := StrToInt(strIds[i]);
        Exit;
      end;
  except
    MainForm.AddMainLog(_('Error: Corrupted clients data file.'),Colors.Error);
  end;
end;

procedure TMainForm.mnuGetMapDlLinksClick(Sender: TObject);
begin
  ProcessCommand('getdownloadlinks '+SelectedBattle.Map,False);
end;

procedure TMainForm.mnuGetModDownloadLinksClick(Sender: TObject);
begin
  ProcessCommand('getdownloadlinks '+SelectedBattle.ModName,False);
end;

procedure TMainForm.mnuCopyPlayerNameToClipboardClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(@WideStringToUTF8(SelectedUserName)[1]);
end;

procedure TMainForm.mnuCopyDescriptionClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(@WideStringToUTF8(SelectedBattle.Description)[1]);
end;

procedure TMainForm.mnuCopyMapNameClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(@WideStringToUTF8(SelectedBattle.Map)[1]);
end;

procedure TMainForm.mnuCopyModNameClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(@WideStringToUTF8(SelectedBattle.ModName)[1]);
end;

procedure TMainForm.SpringSocketUDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  sMsg: string;
begin
  if not BattleState.SpringComAddrAcquired then
  begin
    BattleState.SpringComAddr := ABinding.PeerIP;
    BattleState.SpringComPort := ABinding.PeerPort;
    BattleState.SpringComAddrAcquired := True;
  end;
  if AData.Size <= 0 then Exit;
  SetLength(sMsg,AData.Size);
  AData.ReadBuffer(sMsg[1],AData.Size);
  if (Byte(sMsg[1]) = 13) or (Byte(sMsg[1]) = 10) then // chat msg or player joined
  begin
    PostMessage(MainForm.Handle, WM_SPRINGSOCKETMSG, SpringSocketQueue.Enqueue(sMsg), 0);
  end;
end;

procedure TMainForm.SpTBXItem8Click(Sender: TObject);
begin
  SpringDownloaderFormUnit.DownloadMod(SelectedBattle.HashCode,SelectedBattle.ModName,True);
end;

procedure TMainForm.mnuJoinMeClick(Sender: TObject);
begin
  if Status.Me.Battle <> nil then
    TryToSendCommand('SAYPRIVATE',SelectedUserName+' '+REMOTE_JOIN_COMMAND+' '+TClient(Status.Me.Battle.Clients[0]).Name + IFF(BattleState.Password <> '', ' '+BattleState.Password, '') );
end;

procedure TMainForm.BattleFiltersTextboxChange(Sender: TObject);
begin
  RefreshBattleList;
end;

procedure TMainForm.BattleFiltersTextboxSubEditButton0Click(
  Sender: TObject);
begin
  BattleFiltersTextbox.Text := '';
  RefreshBattleList;
end;

procedure TMainForm.SpTBXItem9Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://springrts.com/dl/tasclient/tasclient_changelog.log');
end;

procedure TMainForm.mnuRapidDownloaderClick(Sender: TObject);
begin
  RapidDownloaderForm.Show;
end;

procedure TMainForm.mnuGetEngineDownloadLinksClick(Sender: TObject);
begin
  ProcessCommand('getenginedownloadlinks '+SelectedBattle.EngineName+' '+SelectedBattle.EngineVersion,False);
end;

end.
