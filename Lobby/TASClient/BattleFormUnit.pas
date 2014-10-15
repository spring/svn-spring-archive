{
  - Do not confuse battle status and battle state!
  - If you change any of the tab sheet captions, make sure any sentences like
    "if PageControl1.ActivePage.Caption = 'Player control' then ..." gets
    updated too!

  - If hosting normal battle, then clients are always at the top of the list, bots
    are at the bottom. If hosting battle replay, "original" clients will be
    positioned at the bottom of the list, and normal clients at the top.

}

unit BattleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, MainUnit, jpeg,
  VirtualTrees, Menus, RichEditURL, JvExControls, JvComponent, JvButton,
  JvTransparentButton, JvgSpeedButton, JvgShadow, JvgButton, JvExStdCtrls,
  JvXPCore, JvXPButtons, TB2Item, SpTBXItem,SpTBXSkins,
  SpTBXControls, TB2ExtItems, SpTBXEditors, SpTBXTabs, JvLED,
  ImageEx, JvSticker, JvExExtCtrls, JvImage, JvShape, JvLabel,GpIFF,
  ImgList, SpTBXFormPopupMenu,IniFiles,
  MsMultiPartFormData, JvComponentBase, Spin, Mask,
  JvExMask, JvSpin, TntStdCtrls, TntForms, TntComCtrls,RichEdit,JclUnicode,
  RichEdit2, ExRichEdit, class_TIntegerList, Utility, OleCtrls,
  SHDocVw,ActnList, gnugettext, OpenGL1x, GIFImage, DockPanel, pngimage,
  SpTBXDkPanels,WinSock, OverbyteIcsWndControl, OverbyteIcsHttpProt,OverbyteIcsWSocket;

type

  TJvXPCustomButtonHack = class(TJvXPCustomButton); // another hack to expose Color property

  TClientNodeType = (NodeError, NormalClient, NormalBot, OriginalClient,Separator); // used to differentiate between "types" of nodes in the visual battle clients list, so for example we can decided what to paint on OnPaint event etc. NodeError is used to indicate that certain node has invalid position.
  
  TBattleForm = class(TForm)
    GameTimer: TTimer;
    ColorPopupMenu: TSpTBXPopupMenu;
    mnuTeamColorCancel: TSpTBXItem;
    PlayerControlPopupMenu: TSpTBXPopupMenu;
    KickPlayerItem: TSpTBXItem;
    SetTeamColorItem: TSpTBXSubmenuItem;
    SpTBXItem3: TSpTBXItem;
    SetBotSideSubitem: TSpTBXSubmenuItem;
    mnuTeamColorCustomize: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    SpTBXItem7: TSpTBXItem;
    ForceSpectatorModeItem: TSpTBXItem;
    SpTBXTitleBar1: TSpTBXTitleBar;
    Panel3: TSpTBXPanel;
    StartButton: TSpTBXButton;
    HostButton: TSpTBXButton;
    DisconnectButton: TSpTBXButton;
    AddBotButton: TSpTBXButton;
    LockedCheckBox: TSpTBXCheckBox;
    BalanceTeamsPopupMenu: TSpTBXPopupMenu;
    SpTBXItem8: TSpTBXItem;
    AutoStartRectsPopupMenu: TSpTBXPopupMenu;
    AutoStartRectsOptionsItem: TSpTBXItem;
    AutoStartRectsApplyItem: TSpTBXItem;
    AdminButton: TSpTBXButton;
    AdminPopupMenu: TSpTBXPopupMenu;
    BanPlayerItem: TSpTBXItem;
    mnuRingAllNotRdy: TSpTBXItem;
    mnuFixColors: TSpTBXItem;
    mnuBalanceSub: TSpTBXSubmenuItem;
    SpTBXSeparatorItem3: TSpTBXSeparatorItem;
    mnuSaveBoxes: TSpTBXItem;
    mnuLoadBoxes: TSpTBXItem;
    mnuClearBoxes: TSpTBXItem;
    UnbanSubitem: TSpTBXSubmenuItem;
    SpTBXSeparatorItem4: TSpTBXSeparatorItem;
    mnuLimitRankAutoKick: TSpTBXItem;
    HttpCli1: THttpCli;
    mnuLimitRankAutoSpec: TSpTBXItem;
    mnuRankLimit: TSpTBXSubmenuItem;
    mnuRankLimitDisabled: TSpTBXItem;
    mnuFixTeams: TSpTBXItem;
    mnuBlockTeams: TSpTBXItem;
    HttpCli2: THttpCli;
    HttpCli3: THttpCli;
    RingItem: TSpTBXItem;
    KeepRatioItem: TSpTBXItem;
    SpTBXSeparatorItem7: TSpTBXSeparatorItem;
    SpTBXSeparatorItem9: TSpTBXSeparatorItem;
    SpTBXSeparatorItem10: TSpTBXSeparatorItem;
    SpTBXSeparatorItem11: TSpTBXSeparatorItem;
    MapsPopupMenu: TSpTBXFormPopupMenu;
    BattlePlayerListPanel: TSpTBXPanel;
    VDTBattleClients: TVirtualDrawTree;
    lblTeamNbr: TSpTBXLabel;
    QuickLookChangedTmr: TTimer;
    SSProfileButton: TSpTBXButton;
    SpringSettingsProfilePopupMenu: TSpTBXPopupMenu;
    sspDefaultItem: TSpTBXItem;
    SpTBXSeparatorItem13: TSpTBXSeparatorItem;
    SpTBXSeparatorItem14: TSpTBXSeparatorItem;
    mnuAutoLockOnStart: TSpTBXItem;
    ChooseSidePopupMenu: TSpTBXPopupMenu;
    PlayerSubmenu: TSpTBXSubmenuItem;
    MyOptionsPanel: TSpTBXPanel;
    MyOptionsGroupBox: TSpTBXGroupBox;
    Label11: TSpTBXLabel;
    Label12: TSpTBXLabel;
    TeamColorSpeedButton: TSpTBXSpeedButton;
    SpectateCheckBox: TSpTBXCheckBox;
    MySideButton: TSpTBXSpeedButton;
    MyTeamNoButton: TSpTBXSpinEdit;
    MyAllyNoButton: TSpTBXSpinEdit;
    MapPanel: TSpTBXPanel;
    MapOptionsPanel: TSpTBXPanel;
    SpTBXPanel1: TSpTBXPanel;
    MapsButton: TSpTBXButton;
    DropDownMapSelectionButton: TSpTBXButton;
    ReloadMapListButton: TSpTBXButton;
    DownloadMapButton: TSpTBXButton;
    OnlineMapsButton: TSpTBXButton;
    OnlineModsButton: TSpTBXButton;
    MapSizeLabel: TSpTBXLabel;
    TidalStrengthLabel: TSpTBXLabel;
    GravityLabel: TSpTBXLabel;
    MaxMetalLabel: TSpTBXLabel;
    ExtRadiusLabel: TSpTBXLabel;
    WindLabel: TSpTBXLabel;
    SpTBXPanel3: TSpTBXPanel;
    MapDescLabel: TSpTBXLabel;
    MapsTabs: TSpTBXTabControl;
    MinimapTab: TSpTBXTabItem;
    RessourcesMapTab: TSpTBXTabItem;
    HeightMapTab: TSpTBXTabItem;
    SpTBXTabSheet5: TSpTBXTabSheet;
    HeightMapPanel: TSpTBXPanel;
    HeightMapImage: TImage;
    SpTBXTabSheet4: TSpTBXTabSheet;
    MetalMapPanel: TSpTBXPanel;
    MetalMapImage: TImage;
    SpTBXTabSheet3: TSpTBXTabSheet;
    MinimapPanel: TSpTBXPanel;
    MapImage: TImageEx;
    BattleMiddlePanel: TDockPanel;
    BattleChatPanel: TSpTBXPanel;
    NoMapImage: TImage;
    InputEdit: TTntMemo;
    BattleOptionsPanel: TSpTBXPanel;
    SpTBXTabControl1: TSpTBXTabControl;
    QuickLookTab: TSpTBXTabItem;
    GameOptionsTab: TSpTBXTabItem;
    DisabledUnitsTab: TSpTBXTabItem;
    MapTab: TSpTBXTabItem;
    ModTab: TSpTBXTabItem;
    SpTBXTabSheet1: TSpTBXTabSheet;
    UnitsGroupBox: TSpTBXGroupBox;
    VDTDisabledUnits: TVirtualDrawTree;
    ModTabSheet: TSpTBXTabSheet;
    ModOptionsScrollBox: TTntScrollBox;
    panelModOptionsDefault: TSpTBXPanel;
    btLoadDefaultMDO: TSpTBXButton;
    btSetAsDefaultMDO: TSpTBXButton;
    btLoadModsDefaultMDO: TSpTBXButton;
    MapTabSheet: TSpTBXTabSheet;
    MapOptionsScrollBox: TTntScrollBox;
    panelMapOptionsDefault: TSpTBXPanel;
    btLoadDefaultMPO: TSpTBXButton;
    btSetAsDefaultMPO: TSpTBXButton;
    btLoadMapsDefaultMPO: TSpTBXButton;
    SpTBXTabSheet2: TSpTBXTabSheet;
    ResourcesGroupBox: TSpTBXGroupBox;
    lblEnergy: TSpTBXLabel;
    lblMetal: TSpTBXLabel;
    lblUnits: TSpTBXLabel;
    GameEndRadioGroup: TSpTBXRadioGroup;
    StartPosRadioGroup: TSpTBXRadioGroup;
    LoadDefaultButton: TSpTBXButton;
    SetDefaultButton: TSpTBXButton;
    SpTBXTabSheet6: TSpTBXTabSheet;
    QuickLookRichEdit: TRichEdit;
    NumberSelection: TSpTBXPopupMenu;
    NumbersImgList: TTBImageList;
    AutoHostVotePanel: TSpTBXPanel;
    AutoHostVoteMsg: TSpTBXLabel;
    AutoHostVoteButtonsPanel: TSpTBXPanel;
    ImgVoteYes: TImage;
    ImgVoteNo: TImage;
    FlashPanel: TSpTBXPanel;
    AutoHostVoteIcon: TImage;
    ImgVoteBlank: TImage;
    AutoHostInfoPanel: TSpTBXPanel;
    AutoHostMsgFlashTimer: TTimer;
    SPADSPopupMenu: TSpTBXPopupMenu;
    SPRINGIEPopupMenu: TSpTBXPopupMenu;
    mnuDisableAutohostInterface: TSpTBXItem;
    SpTBXSeparatorItem5: TSpTBXSeparatorItem;
    SpTBXItem5: TSpTBXItem;
    SpTBXSubmenuItem1: TSpTBXSubmenuItem;
    SpTBXItem13: TSpTBXItem;
    SpTBXItem6: TSpTBXItem;
    SpTBXItem14: TSpTBXItem;
    SpTBXItem15: TSpTBXItem;
    SpTBXItem16: TSpTBXItem;
    SpTBXItem17: TSpTBXItem;
    SpTBXItem18: TSpTBXItem;
    SpTBXItem19: TSpTBXItem;
    SpTBXItem20: TSpTBXItem;
    SpTBXItem21: TSpTBXItem;
    SpTBXItem22: TSpTBXItem;
    SpTBXItem23: TSpTBXItem;
    SpTBXItem24: TSpTBXItem;
    SpTBXItem25: TSpTBXItem;
    SpTBXSubmenuItem2: TSpTBXSubmenuItem;
    SpTBXItem26: TSpTBXItem;
    SpTBXItem27: TSpTBXItem;
    SpTBXItem28: TSpTBXItem;
    SpTBXItem29: TSpTBXItem;
    SpTBXItem30: TSpTBXItem;
    AutoHostControlLabel: TSpTBXLabel;
    AutoHostInfoBottomPanel: TSpTBXPanel;
    AutoHostInfoRightPanel: TSpTBXPanel;
    Image1: TImage;
    AutoHostCommandsButton: TSpTBXSpeedButton;
    SpTBXPanel2: TSpTBXPanel;
    AutoHostInfoIcon: TImage;
    mnuHideAutoHostMsgs: TSpTBXItem;
    SpTBXSubmenuItem3: TSpTBXSubmenuItem;
    SpTBXItem31: TSpTBXItem;
    SpTBXItem32: TSpTBXItem;
    SpTBXItem33: TSpTBXItem;
    SpTBXItem34: TSpTBXItem;
    SpTBXItem35: TSpTBXItem;
    SpTBXItem36: TSpTBXItem;
    SpTBXItem37: TSpTBXItem;
    SpTBXSubmenuItem4: TSpTBXSubmenuItem;
    SpTBXItem38: TSpTBXItem;
    SpTBXItem39: TSpTBXItem;
    SpTBXItem40: TSpTBXItem;
    SpTBXItem41: TSpTBXItem;
    SpTBXItem42: TSpTBXItem;
    SpTBXItem43: TSpTBXItem;
    SpTBXItem44: TSpTBXItem;
    SpTBXItem45: TSpTBXItem;
    SpTBXItem46: TSpTBXItem;
    SpTBXItem47: TSpTBXItem;
    SpTBXItem48: TSpTBXItem;
    SpTBXItem49: TSpTBXItem;
    Bevel2: TBevel;
    mnuDisableAutohostInterface2: TSpTBXItem;
    mnuHideAutoHostMsgs2: TSpTBXItem;
    SpTBXSeparatorItem6: TSpTBXSeparatorItem;
    SpTBXSubmenuItem5: TSpTBXSubmenuItem;
    SpTBXSubmenuItem6: TSpTBXSubmenuItem;
    SpTBXSubmenuItem7: TSpTBXSubmenuItem;
    SpTBXSubmenuItem8: TSpTBXSubmenuItem;
    SpTBXItem2: TSpTBXItem;
    SpTBXItem50: TSpTBXItem;
    SpTBXItem51: TSpTBXItem;
    SpTBXItem52: TSpTBXItem;
    SpTBXItem53: TSpTBXItem;
    SpTBXItem54: TSpTBXItem;
    SpTBXItem55: TSpTBXItem;
    SpTBXItem56: TSpTBXItem;
    SpTBXItem57: TSpTBXItem;
    SpTBXItem58: TSpTBXItem;
    SpTBXItem59: TSpTBXItem;
    SpTBXItem60: TSpTBXItem;
    SpTBXItem61: TSpTBXItem;
    SpTBXItem62: TSpTBXItem;
    SpTBXItem63: TSpTBXItem;
    SpTBXItem64: TSpTBXItem;
    SpTBXItem65: TSpTBXItem;
    SpTBXItem66: TSpTBXItem;
    SpTBXItem67: TSpTBXItem;
    SpTBXItem68: TSpTBXItem;
    SpTBXItem69: TSpTBXItem;
    SpTBXItem70: TSpTBXItem;
    SpTBXItem71: TSpTBXItem;
    SpTBXItem72: TSpTBXItem;
    SpTBXItem73: TSpTBXItem;
    SpTBXItem74: TSpTBXItem;
    SpTBXItem75: TSpTBXItem;
    AutohostControlSplitter: TSpTBXSplitter;
    SpTBXSeparatorItem15: TSpTBXSeparatorItem;
    sspOptions: TSpTBXItem;
    ChatRichEdit: TExRichEdit;
    AutoHostMsgsRichEdit: TExRichEdit;
    StartProgressBar: TSpTBXProgressBar;
    AddUnitsSpeedButton: TSpTBXButton;
    ZoomItem: TSpTBXItem;
    ForceTeamSpin: TSpTBXEditItem;
    ForceAllySpin: TSpTBXEditItem;
    HandicapSpinEditItem: TSpTBXEditItem;
    EnergyTracker: TSpTBXTrackBar;
    MetalTracker: TSpTBXTrackBar;
    UnitsTracker: TSpTBXTrackBar;
    lblMetalValue: TSpTBXLabel;
    lblEnergyValue: TSpTBXLabel;
    lblUnitsValue: TSpTBXLabel;
    mnuTeamColorPalette: TSpTBXColorPalette;
    mnuForceTeamColorPalette: TSpTBXColorPalette;
    ReadyButton: TSpTBXSpeedButton;
    BotOptionsItem: TSpTBXItem;
    SpTBXItem1: TSpTBXItem;
    JoinButton: TSpTBXButton;
    SpTBXSeparatorItem16: TSpTBXSeparatorItem;
    sspCustomExe: TSpTBXItem;
    sspMT: TSpTBXItem;
    sspST: TSpTBXItem;
    mnuBalanceTeamOptions: TSpTBXItem;
    mnuCBalanceTeams: TSpTBXItem;

    procedure CreateParams(var Params: TCreateParams); override;

    function IsBattleActive: Boolean;
    procedure AddTextToChat(Text: WideString; Color: TColor; ChatTextPos: Integer; AutoHostMsg: boolean=False);
    procedure UpdateClientsListBox;
    function GetMyBattleStatus: Integer;
    procedure SetMyBattleStatus(Side: Integer; Ready: Boolean; TeamNo: Integer; AllyNo: Integer; Mode: Integer);
    procedure SendMyBattleStatusToServer;
    procedure SendReplayScriptToServer;
    procedure SendBattleDetailsToServer;
    procedure SendBattleInfoToServer;
    function GenerateJoinScriptFile(FileName: string):TScript;
    function GenerateNormalHostScriptFile(FileName: string;relayHostScript: boolean=false):TScript;
    function GenerateReplayHostScriptFile(FileName: string):TScript;
    procedure PunchThroughNAT; // only used when hosting using "hole punching" technique. See comments at method's implementation for more info.

    //function ChooseColorDialog(UnderControl: TControl; DefaultColorIndex: Integer): Integer;
    function ChooseNumberDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;
    function ChooseSideDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;

    procedure ChangeTeamColor(ColorIndex: Integer; UpdateServer: Boolean);
    procedure ChangeSide(SideIndex: Integer; UpdateServer: Boolean);

    function FigureOutBestPossibleTeamAllyAndColor(IgnoreMyself: Boolean; var BestTeam, BestAlly, BestColorIndex:integer): Boolean;
    procedure ChangeCurrentMod(ModName: string);
    procedure ChangeMapToNoMap(MapName: string); // use 'MapName' to display missing map caption
    procedure ChangeMapToFirstOne;
    procedure ChangeMap(MapIndex: Integer); // 'MapIndex' refers to index in Utility.MapList
    procedure CheckBattleSync;
    procedure PopulatePopupMenuMapList;
    procedure PopulatePopupMenuMapListF(filter: string = ''); // will populate 'MapsPopupMenu' with map names
    procedure MapsPopupMenuItemClick(Sender: TObject);

    procedure OnStartGameMessage(var Msg: TMessage); message WM_STARTGAME;

    procedure ResetBattleScreen;
    function JoinBattle(BattleID: Integer): Boolean;
    function JoinBattleReplay(BattleID: Integer): Boolean;
    function HostBattle(BattleID: Integer): Boolean;
    function HostBattleReplay(BattleID: Integer): Boolean;    
    function ApplyScriptFile(Script: TScript): Boolean;

    procedure ResetStartRects;
    function GetFirstMissingStartRect: Integer;
    procedure StartRectPaintBoxPaint(Sender: TObject);
    procedure AddStartRect(Index: Integer; Rect: TRect);
    procedure RefreshStartRectsPosAndSize;
    procedure RemoveStartRect(Index: Integer);
    procedure ChangeStartRect(Index: Integer; Rect: TRect; limit2: Boolean = False);
    procedure SetSelectedStartRect(Index: Integer);
    function GetStartRectAtPos(x, y: Integer): Integer;
    function IsMouseOverMapImage: Boolean;
    procedure OnNumberPressedOverStartRect(Number: Byte);
    procedure OnDeletePressedOverStartRect;
    procedure RearrangeStartRects;

    procedure ChooseSidePopupMenuItemClick(Sender: TObject);
    procedure SetBotSideItemClick(Sender: TObject);
    procedure UnbanItemClick(Sender: TObject);
    procedure SetBotLibItemClick(Sender: TObject);

    function GetClientNodeType(NodeIndex: Integer): TClientNodeType;

    procedure SetRadioItem(PopupMenu: TSpTBXPopupMenu; ItemIndex: Integer);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure HostButtonClick(Sender: TObject);
    procedure MapImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DisconnectButtonClick(Sender: TObject); overload;
    procedure StartPosRadioGroupClick(Sender: TObject);
    procedure GameTimerTimer(Sender: TObject);
    procedure UploadReplay;
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpectateCheckBoxClick(Sender: TObject);
    procedure GameEndRadioGroupClick(Sender: TObject);
    procedure AddUnitsSpeedButtonClick(Sender: TObject);
    procedure AddBotButtonClick(Sender: TObject);
    procedure ChaTExRichEditURLClick(Sender: TObject; const URL: String);
    procedure MapImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MapImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LockedCheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetDefaultButtonClick(Sender: TObject);
    procedure LoadDefaultButtonClick(Sender: TObject);
    procedure VDTBattleClientsGetNodeWidth(Sender: TBaseVirtualTree;
      HintCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      var NodeWidth: Integer);
    procedure GetNodeClient(index : integer;var realindex : integer;var nodetype : TClientNodeType);
    procedure SortClientList(SortStyle: Byte; Ascending: Boolean;FullSort : Boolean);
    procedure SortBotList(SortStyle: Byte; Ascending: Boolean;FullSort : Boolean);
    function CompareClients(Client1 : TClient; Client2 : TClient;SortStyle: Byte) : integer;
    function CompareBots(Bot1 : TBot; Bot2 : TBot;SortStyle: Byte) : integer;
    procedure VDTBattleClientsDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure VDTBattleClientsMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KickPlayerItemClick(Sender: TObject);
    procedure MySideButtonClick(Sender: TObject);
    procedure ReadyButtonClick(Sender: TObject);
    procedure mnuTeamColorCustomizeClick(Sender: TObject);
    procedure SpTBXItem7Click(Sender: TObject);
    procedure MapsButtonClick(Sender: TObject);
    procedure ReloadMapListButtonClick(Sender: TObject);
    procedure VDTBattleClientsDblClick(Sender: TObject);
    procedure ForceSpectatorModeItemClick(Sender: TObject);
    procedure LockedCheckBoxGetImageIndex(Sender: TObject;
      var AImageList: TCustomImageList; var AItemIndex: Integer);
    procedure AutoStartRectsOptionsItemClick(Sender: TObject);
    procedure AutoStartRectsApplyItemClick(Sender: TObject);
    procedure mnuRingAllNotRdyClick(Sender: TObject);
    procedure mnuFixColorsClick(Sender: TObject);
    procedure mnuClearBoxesClick(Sender: TObject);
    procedure mnuLoadBoxesClick(Sender: TObject);
    procedure mnuSaveBoxesClick(Sender: TObject);
    procedure mnuCBalanceTeamsClick(Sender: TObject);
    procedure mnuBalanceTeamOptionsClick(Sender: TObject);
    procedure MapDescLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MapPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BanPlayerItemClick(Sender: TObject);
    //procedure AdjustFont(Item: TTBCustomItem;
    //  Viewer: TTBItemViewer; Font: TFont; StateFlags: Integer);
    procedure mnuLimitRankAutoKickClick(Sender: TObject);
    procedure SpTBXItem8Click(Sender: TObject);
    procedure mnuLimitRankAutoSpecClick(Sender: TObject);
    procedure mnuRankLimitDisabledClick(Sender: TObject);
    procedure VDTBattleClientsDrawHint(Sender: TBaseVirtualTree;
      HintCanvas: TCanvas; Node: PVirtualNode; R: TRect;
      Column: TColumnIndex);
    procedure VDTBattleClientsGetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure mnuFixTeamsClick(Sender: TObject);
    procedure mnuBlockTeamsClick(Sender: TObject);
    procedure RingItemClick(Sender: TObject);
    procedure VDTBattleClientsHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
    procedure lblMetalClick(Sender: TObject);
    procedure lblEnergyClick(Sender: TObject);
    procedure lblUnitsClick(Sender: TObject);
    procedure ChangeScriptTagValue(completeKey: String; value: String);
    procedure SendLuaOptionsDetailsToServer;
    procedure FormResize(Sender: TObject);
    procedure SpTBXTabControl1ActiveTabChange(Sender: TObject;
      TabIndex: Integer);
    procedure mnuNewGroupClick(Sender: TObject);
    procedure mnuPlayerManueClick(Sender: TObject);
    procedure btLoadModsDefaultMDOClick(Sender: TObject);
    procedure btLoadMapsDefaultMPOClick(Sender: TObject);
    procedure btSetAsDefaultMDOClick(Sender: TObject);
    procedure btSetAsDefaultMPOClick(Sender: TObject);
    procedure btLoadDefaultMDOClick(Sender: TObject);
    procedure btLoadDefaultMPOClick(Sender: TObject);
    procedure KeepRatioItemClick(Sender: TObject);
    procedure VDTDisabledUnitsDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure ChatExRichEditDblClick(Sender: TObject);
    procedure ChatRichEditMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DownloadMapButtonClick(Sender: TObject);
    procedure MapListFilterTextBoxChange(Sender: TObject;
      const Text: WideString);
    procedure MapsPopupMenuPopup(Sender: TObject);
    procedure InputEditChange(Sender: TObject);
    procedure OnlineMapsButtonClick(Sender: TObject);
    procedure OnlineModsButtonClick(Sender: TObject);
    procedure MinimapPanelResize(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MetalMapPanelResize(Sender: TObject);
    procedure HeightMapPanelResize(Sender: TObject);
    procedure MapsTabsActiveTabChange(Sender: TObject; TabIndex: Integer);
    procedure RefreshQuickLookText;
    procedure QuickLookChangedTmrTimer(Sender: TObject);
    procedure OnSpringSettingsProfileItemClick(Sender: TObject);
    procedure sspDefaultItemClick(Sender: TObject);
    procedure QuickLookRichEditMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure MyTeamNoButtonExit(Sender: TObject);
    procedure MyAllyNoButtonExit(Sender: TObject);
    procedure VDTBattleClientsDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure AutoHostMsgFlashTimerTimer(Sender: TObject);
    procedure AutoHostInfoMsgsDrawItemBackground(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure AutoHostInfoMsgsDrawItem(Control: TWinControl;
      Index: Integer; R: TRect; State: TOwnerDrawState);
    procedure ImgVoteYesClick(Sender: TObject);
    procedure ImgVoteNoClick(Sender: TObject);
    procedure ImgVoteBlankClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure mnuDisableAutohostInterfaceClick(Sender: TObject);
    procedure mnuHideAutoHostMsgs2Click(Sender: TObject);
    procedure SPRINGIEPopupMenuInitPopup(Sender: TObject;
      PopupView: TTBView);
    procedure SpTBXItem13Click(Sender: TObject);
    procedure SpTBXItem5Click(Sender: TObject);
    procedure SpTBXItem48Click(Sender: TObject);
    procedure SpTBXItem6Click(Sender: TObject);
    procedure SpTBXItem14Click(Sender: TObject);
    procedure SpTBXItem15Click(Sender: TObject);
    procedure SpTBXItem16Click(Sender: TObject);
    procedure SpTBXItem17Click(Sender: TObject);
    procedure SpTBXItem18Click(Sender: TObject);
    procedure SpTBXItem19Click(Sender: TObject);
    procedure SpTBXItem20Click(Sender: TObject);
    procedure SpTBXItem21Click(Sender: TObject);
    procedure SpTBXItem22Click(Sender: TObject);
    procedure SpTBXItem23Click(Sender: TObject);
    procedure SpTBXItem24Click(Sender: TObject);
    procedure SpTBXItem25Click(Sender: TObject);
    procedure SpTBXItem31Click(Sender: TObject);
    procedure SpTBXItem37Click(Sender: TObject);
    procedure SpTBXItem36Click(Sender: TObject);
    procedure SpTBXItem32Click(Sender: TObject);
    procedure SpTBXItem45Click(Sender: TObject);
    procedure SpTBXItem33Click(Sender: TObject);
    procedure SpTBXItem34Click(Sender: TObject);
    procedure SpTBXItem35Click(Sender: TObject);
    procedure SpTBXItem44Click(Sender: TObject);
    procedure SpTBXItem47Click(Sender: TObject);
    procedure SpTBXItem49Click(Sender: TObject);
    procedure SpTBXItem26Click(Sender: TObject);
    procedure SpTBXItem27Click(Sender: TObject);
    procedure SpTBXItem29Click(Sender: TObject);
    procedure SpTBXItem28Click(Sender: TObject);
    procedure SpTBXItem30Click(Sender: TObject);
    procedure SpTBXItem46Click(Sender: TObject);
    procedure SpTBXItem39Click(Sender: TObject);
    procedure SpTBXItem38Click(Sender: TObject);
    procedure SpTBXItem40Click(Sender: TObject);
    procedure SpTBXItem41Click(Sender: TObject);
    procedure SpTBXItem42Click(Sender: TObject);
    procedure SpTBXItem43Click(Sender: TObject);
    procedure SpTBXItem64Click(Sender: TObject);
    procedure SpTBXItem2Click(Sender: TObject);
    procedure SpTBXItem50Click(Sender: TObject);
    procedure SpTBXItem62Click(Sender: TObject);
    procedure SpTBXItem57Click(Sender: TObject);
    procedure SpTBXItem51Click(Sender: TObject);
    procedure SpTBXItem52Click(Sender: TObject);
    procedure SpTBXItem53Click(Sender: TObject);
    procedure SpTBXItem54Click(Sender: TObject);
    procedure SpTBXItem55Click(Sender: TObject);
    procedure SpTBXItem56Click(Sender: TObject);
    procedure SpTBXItem63Click(Sender: TObject);
    procedure SpTBXItem75Click(Sender: TObject);
    procedure SpTBXItem65Click(Sender: TObject);
    procedure SpTBXItem66Click(Sender: TObject);
    procedure SpTBXItem67Click(Sender: TObject);
    procedure SpTBXItem68Click(Sender: TObject);
    procedure SpTBXItem69Click(Sender: TObject);
    procedure SpTBXItem70Click(Sender: TObject);
    procedure SpTBXItem71Click(Sender: TObject);
    procedure SpTBXItem72Click(Sender: TObject);
    procedure SpTBXItem73Click(Sender: TObject);
    procedure SpTBXItem74Click(Sender: TObject);
    procedure SpTBXItem58Click(Sender: TObject);
    procedure SpTBXItem59Click(Sender: TObject);
    procedure SpTBXItem60Click(Sender: TObject);
    procedure SpTBXItem61Click(Sender: TObject);
    procedure AutoHostInfoBottomPanelResize(Sender: TObject);
    procedure sspOptionsClick(Sender: TObject);
    procedure AutohostControlSplitterMoved(Sender: TObject);
    procedure PlayerControlPopupMenuPopup(Sender: TObject);
    procedure ZoomItemClick(Sender: TObject);
    procedure ForceTeamSpinChange(Sender: TObject; const Text: WideString);
    procedure ForceAllySpinChange(Sender: TObject; const Text: WideString);
    procedure HandicapSpinEditItemChange(Sender: TObject;
      const Text: WideString);
    procedure EnergyTrackerChange(Sender: TObject);
    procedure MetalTrackerChange(Sender: TObject);
    procedure UnitsTrackerChange(Sender: TObject);
    procedure SpringSettingsProfilePopupMenuPopup(Sender: TObject);
    procedure VDTBattleClientsHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure MetalTrackerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UnitsTrackerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EnergyTrackerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuTeamColorPaletteCellClick(Sender: TObject; ACol,
      ARow: Integer; var Allow: Boolean);
    procedure mnuTeamColorPaletteGetColor(Sender: TObject; ACol,
      ARow: Integer; var Color: TColor; var Name: WideString);
    procedure mnuForceTeamColorPaletteCellClick(Sender: TObject; ACol,
      ARow: Integer; var Allow: Boolean);
    procedure BotOptionsItemClick(Sender: TObject);
    procedure SpTBXItem1Click(Sender: TObject);
    procedure JoinButtonClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ModOptionsScrollBoxConstrainedResize(Sender: TObject;
      var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
    procedure MapOptionsScrollBoxConstrainedResize(Sender: TObject;
      var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
    procedure sspSTClick(Sender: TObject);
    procedure sspMTClick(Sender: TObject);
    procedure sspCustomExeClick(Sender: TObject);
  private
    History: TWideStringList;
    HistoryIndex: Integer;

    SortedClientList : TList;
    SortedBotList : TList;
    SortedOriginalList : TList;

    FMyReadyStatus: Boolean;
    FCurrentMapIndex: Integer; // index of currently loaded map. -1 for none.
    FCurrentModName: string; // index of currently loaded map. -1 for none.
    procedure SetMyReadyStatus(Status: Boolean); // sets FMyReadyStatus
  public
    ChatActive: Boolean;
    SpringSettingsProfile: string;
    ModOptionsList: TList;
    MapOptionsList: TList;
    UnknownScriptTagList:
    record
      CompleteKeyList: TStrings;
      ValueList: TStrings;
    end;
    LogFile: TFileStream; // use the same way as TMyTabSheet.LogFile is used
    MapMetal: TMapData;
    TotalMetal: int64;
    MapMetalWidth: integer;
    MapMetalHeight: integer;
    MapHeight: TMapData;
    MapHeightWidth: integer;
    MapHeightHeight: integer;
    QuickLookHints: TStringList;

    property CurrentMapIndex: Integer read FCurrentMapIndex; // only ChangeMap method may change it!
    property CurrentModName: String read FCurrentModName; // only ChangeMap method may change it!
    property AmIReady: Boolean read FMyReadyStatus write SetMyReadyStatus;
    procedure RefreshTeamNbr;
    procedure SaveModOptionsAsDefault;
    procedure LoadModOptionsDefault(modName: string);
    procedure SaveMapOptionsAsDefault;
    procedure LoadMapOptionsDefault;
    procedure DisconnectButtonClick;overload;
    procedure PopulateDisabledUnitsVDT;
    function isBattleReadyToStart: Boolean;

  end;

  TBattleParticipation = (None, Hosting, Joined);
  // use Hosting if you are the host of the battle and server has already
  // updated/approved your battle. Use Joined if you are connected to someone
  // else's battle. Use None if none of the above is true.

  TStartRect =
  record
    Enabled: Boolean;
    Rect: TRect;
    PaintBox: TPaintBox;
  end;
var
  BattleForm: TBattleForm;
  BattleState:
  record
    Status: TBattleParticipation;
    JoiningComplete: Boolean; // used to know if the joining/hosting process is complete
    Battle: TBattle; // don't ever free this object! It is freed automatically by RemoveBattle method! This object is only "pointer" to an item in Battles list!
    Password: string;
    Process: // we need this information when we launch game exe
    record
      proc_info: TProcessInformation;
      startinfo: TStartupInfo;
      ExitCode: LongWord;
      WindowHandle : HWND;
    end;

    AutoSendDescription : boolean;
    AutoKickRankLimit : boolean;
    AutoSpecRankLimit : boolean;
    StartRects: array of TStartRect;
    DrawingStartRect: Shortint; // if -1, then we are not drawing a "start rectangle"
    MovingStartRect: Shortint; // if -1, then we are not moving a "start rectangle"
    MovingX: integer; // coord of the mousedown (do be able to move the "start rectangle")
    MovingY: integer;
    ResizingStartRect : Shortint; // if -1, then we are no resizing a "start rectangle"
    ResizingDirection : ShortInt; // 1 left, 2 top,4 right, 8 bottom, 3 left + top, 6 top + right, 12 bottom + right, 9 bottom + left
    ResizingX : ShortInt; // distance between the rect border and where you click
    ResizingY : ShortInt;
    SelectedStartRect: Shortint; // if -1, no start rect is selected
    BanList:TIntegerList;
    DisabledUnits: TStringList;
    AutoHost: Boolean;
    AutoHostType: integer; // 0 = SPADS, 1 = Springie

    IngameId: TIntegerList;
    IngameName: TStringList;
    SpringComAddrAcquired: Boolean;
    SpringComAddr: string;
    SpringComPort: integer;
    SpringChatMsgsBeingRelayed: TWideStringList;
    HostSupportsJoinPassword: boolean;
    RelayChat: boolean;

    JoiningBattle: Boolean;
  end;

  BattleReplayInfo: // used only when battle is of "battle replay" type
  record
    Script: TScript;
    TempScript: TStringList; // we use it while receiving script from server. Once finished, we copy it to <Script>.
    OriginalClients: TList; // list of TClient-s from the replay. You have to manually free this clients. They are NOT bound to AllClients list!
    Replay: TReplay;
  end;

  MyTeamColorIndex: Integer;

  AllowBattleStatusUpdate: Boolean = True;
  { should be always true except when we are changing some checkbox's checked status or TRadioGroup's ItemIndex property. The problem
    is, that the sentence "MyCheckBox.Checked := True" will trigger OnClick event, but only if value changed. Also, TRadioGroup works
    the same way (ItemIndex). But changing TComboBox's ItemIndex will not trigger OnChange event! }
  AllowBattleDetailsUpdate: Boolean = True;
  { similar to AllowBattleStatusUpdate, only for battle details }

  procedure FreeReplayClients; // free-s BattleReplayInfo.OriginalClients; NOTE: it doesn't free the list itself, only clients!
  function GetWindowHwnd(Handle : HWND; lParam : LPARAM) : Boolean;stdcall;

implementation

uses
  Misc, HostBattleFormUnit, ShellAPI,
  MinimapZoomedFormUnit, PreferencesFormUnit, DisableUnitsFormUnit,
  InitWaitFormUnit, AddBotUnit, Math, ReplaysUnit, StrUtils,
  StringParser, MapListFormUnit, AutoTeamsUnit,
  AutoStartRectsUnit, ColorPicker, UploadReplayUnit, ProgressBarWindow,
  TntWideStrings, LobbyScriptUnit, SpringDownloaderFormUnit,
  MapSelectionFormUnit, TipsFormUnit, SpringSettingsProfileFormUnit,
  Minimap3DPreviewUnit, Types, DateUtils, AutoJoinFormUnit;

{$R *.dfm}

procedure TBattleForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure FreeReplayClients;
var
  i: Integer;
begin
  for i := 0 to BattleReplayInfo.OriginalClients.Count-1 do
  try
    TClient(BattleReplayInfo.OriginalClients[i]).Free;
  except
  end;

  BattleReplayInfo.OriginalClients.Clear;
end;

procedure TBattleForm.SetMyReadyStatus(Status: Boolean);
var
  i:integer;
begin
  FMyReadyStatus := Status;

  if FMyReadyStatus then
    ReadyButton.ImageIndex := 10
    //MainForm.MiscImageList.GetBitmap(10, ReadyButton.Glyph.Bitmap)
  else
    ReadyButton.ImageIndex := 9;
    //MainForm.MiscImageList.GetBitmap(9, ReadyButton.Glyph.Bitmap);

  if not IsBattleActive then Exit;

  SendMyBattleStatusToServer;

  // disable controls (player should not be allowed to change his preferences once he selects "I'm ready"):
  if (BattleState.Battle.BattleType = 0) then
  begin
    if Status then DisableControlAndChildren(MyOptionsGroupBox) else EnableControlAndChildren(MyOptionsGroupBox);
    AddBotButton.Enabled := not Status;
    if BattleState.Status = Hosting then
    begin
      LoadDefaultButton.Enabled := not Status;
      for i := 0 to ModOptionsList.Count-1 do
        if Status then
          TLuaOption(ModOptionsList[i]).Disable
        else
          TLuaOption(ModOptionsList[i]).Enable;
      for i := 0 to MapOptionsList.Count-1 do
        if Status then
          TLuaOption(MapOptionsList[i]).Disable
        else
          TLuaOption(MapOptionsList[i]).Enable;
      btLoadDefaultMDO.Enabled := not Status;
      btLoadModsDefaultMDO.Enabled := not Status;
      btLoadDefaultMPO.Enabled := not Status;
      btLoadMapsDefaultMPO.Enabled := not Status;
      StartPosRadioGroup.Enabled := {*(HostBattleForm.relayHoster = nil) and *}not Status;
      GameEndRadioGroup.Enabled := not Status;
      if Status then DisableControlAndChildren(ResourcesGroupBox) else EnableControlAndChildren(ResourcesGroupBox);
      if Status then DisableControlAndChildren(UnitsGroupBox) else EnableControlAndChildren(UnitsGroupBox);
    end;
  end;

end;

{ returns True if battle is active, that is if we are hosting a battle or if
  we are connected to someone else's battle }
function TBattleForm.IsBattleActive: Boolean;
begin
  Result := (BattleState.Status = Hosting) or (BattleState.Status = Joined);
end;

{ for ChatTextPos argument, see MainForm's AddTextToChatWindow method's comments }
procedure TBattleForm.AddTextToChat(Text: WideString; Color: TColor; ChatTextPos: Integer; AutoHostMsg: boolean=False);
var
  s: WideString;
  c: TWinControl;
begin
  if Preferences.TimeStamps and not AutoHostMsg then
  begin
    s := '[' + TimeToStr(Now) + '] ';
    Text := s + Text;
    Inc(ChatTextPos, Length(s));
  end;
  if AutoHostMsg then
    Misc.AddTextToRichEdit(AutoHostMsgsRichEdit, Text, Color, True, ChatTextPos, True)
  else
    Misc.AddTextToRichEdit(ChatRichEdit, Text, Color, True, ChatTextPos);
  Misc.TryToAddLog(BattleForm.LogFile, Text);

  {*c := ChatRichEdit;
  while c.ClassParent <> TForm do
    c := c.Parent;

  if not TForm(c).Active then FlashWindow(TForm(c).Handle, true);
  *}
end;

procedure TBattleForm.UpdateClientsListBox;
var
  LastRootNodeCount: Integer;
begin
  LastRootNodeCount := VDTBattleClients.RootNodeCount;

  if BattleState.Status = None then
  begin
    VDTBattleClients.RootNodeCount := 0;
  end
  else
    if BattleState.Battle.BattleType = 0 then
    begin
      VDTBattleClients.RootNodeCount := BattleState.Battle.Clients.Count + BattleState.Battle.Bots.Count;
    end
    else
    begin
      VDTBattleClients.RootNodeCount := BattleState.Battle.Clients.Count + BattleReplayInfo.OriginalClients.Count;
    end;

  // loose selection if currently selected (focused) node changed its position (it probably did change its position if root node count has changed):
  if VDTBattleClients.RootNodeCount <> LastRootNodeCount then
    VDTBattleClients.FocusedNode := nil;

  VDTBattleClients.Invalidate;
end;

function TBattleForm.GetMyBattleStatus: Integer;
begin
  // see protocol's description for more info on battle status value!

  Result := 0;

  // ready:
  Inc(Result, BoolToInt(BattleForm.AmIReady) shl 1);

  // team no.:
  Inc(Result, (MyTeamNoButton.SpinOptions.ValueAsInteger-1) shl 2);

  // ally no.:
  Inc(Result, (MyAllyNoButton.SpinOptions.ValueAsInteger-1) shl 6);

  // mode:
  Inc(Result, BoolToInt(not SpectateCheckBox.Checked) shl 10);

  // handicap is ignored (only host can change it)

  // sync status:
  Inc(Result, (2-BoolToInt(Status.Synced)) shl 22);

  // side:
  Inc(Result, MySideButton.Tag shl 24);

end;

procedure TBattleForm.SetMyBattleStatus(Side: Integer; Ready: Boolean; TeamNo: Integer; AllyNo: Integer; Mode: Integer);
begin
  AllowBattleStatusUpdate := False;

  // handicap is ignored (only host can change it)
  if SideList.Count > Side then ChangeSide(Side, False);
  BattleForm.AmIReady := Ready;
  MyTeamNoButton.SpinOptions.ValueAsInteger := TeamNo+1;
  MyAllyNoButton.SpinOptions.ValueAsInteger := AllyNo+1;
  SpectateCheckBox.Checked := not IntToBool(Mode);
  ReadyButton.Enabled := (BattleState.Battle <> nil) and not SpectateCheckBox.Checked;

  AllowBattleStatusUpdate := True;
end;

{ updates the battle status only if AllowBattleStatusUpdate = True }
procedure TBattleForm.SendMyBattleStatusToServer;
begin
  if not IsBattleActive then Exit; // we are not allowed to call it if we are not participating in a battle

  if not Status.BattleStatusRequestReceived then Exit;

  if not AllowBattleStatusUpdate then Exit;

  MainForm.TryToSendCommand('MYBATTLESTATUS', IntToStr(GetMyBattleStatus) +  ' ' + IntToStr(TeamColors[MyTeamColorIndex]));
end;

procedure TBattleForm.SendReplayScriptToServer;
var
  i: Integer;
  scriptLines: TStringList;
  startTime : TDateTime;
  nextScriptLine : string;
  sendSpeed: Extended;
begin
  scriptLines := TStringList.Create;
  ParseDelimited(scriptLines,BattleReplayInfo.Script.Script,EOL,'');

  StartProgressBar.Left := StartButton.Left;
  StartProgressBar.Top := StartButton.Top;
  StartProgressBar.Width := StartButton.Width;
  StartProgressBar.Height := StartButton.Height;
  StartProgressBar.Min := 0;
  StartProgressBar.Max := scriptLines.Count-1;
  StartButton.Visible := False;
  StartProgressBar.Visible := True;

  startTime := Now;

  AddTextToChat(_('Sending replay script ...'),Colors.Info,0);

  MainForm.TryToSendCommand('SCRIPTSTART');
  for i := 0 to scriptLines.Count-1 do
  begin
    StartProgressBar.Position := i;
    StartProgressBar.Refresh;

    nextScriptLine := 'SCRIPT '+scriptLines[i];
    if Length(nextScriptLine) <= 1024 then
    begin
      while Status.CumulativeDataSent+Length(nextScriptLine)-Status.CumulativeDataSentHistory.Items[0] > FLOODLIMIT_BYTESPERSECOND*FLOODLIMIT_SECONDS do
      begin
        Application.ProcessMessages;
        Sleep(10);
      end;
      Application.ProcessMessages;
      MainForm.TryToSendCommand('SCRIPT', scriptLines[i]);
    end
    else
    begin
      Application.ProcessMessages;
      MainForm.AddMainLog(_('A replay script line could not be sent to the server because it exceeded the maximum allowed line size. The replay may not work properly.'),Colors.Error);
    end;
  end;
  MainForm.TryToSendCommand('SCRIPTEND');

  StartButton.Visible := True;
  StartProgressBar.Visible := False;

  AddTextToChat(_('Sending replay script ... done'),Colors.Info,0);
end;

procedure TBattleForm.SendBattleDetailsToServer; // call it each time you update some of the battle's inside parameters
var
  s: string;
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though
  if not BattleState.JoiningComplete then Exit;
  if not AllowBattleDetailsUpdate then Exit;

  s := 'GAME/StartPosType='+IntToStr(StartPosRadioGroup.ItemIndex);
  if GameEndRadioGroup.Visible then
    s := s + #9+'GAME/modoptions/GameMode='+IntToStr(GameEndRadioGroup.ItemIndex);
  if MetalTracker.Visible then
    s := s + #9+'GAME/modoptions/StartMetal='+IntToStr(MetalTracker.Position);
  if EnergyTracker.Visible then
    s := s + #9+'GAME/modoptions/StartEnergy='+IntToStr(EnergyTracker.Position);
  if UnitsTracker.Visible then
    s := s + #9+'GAME/modoptions/MaxUnits='+IntToStr(UnitsTracker.Position);

  MainForm.TryToSendCommand('SETSCRIPTTAGS', s);
end;

procedure TBattleForm.SendBattleInfoToServer; // call it each time you update some of the battle's outside parameters
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  MainForm.TryToSendCommand('UPDATEBATTLEINFO', IntToStr(BattleState.Battle.SpectatorCount) + ' ' + IntToStr(BoolToInt(LockedCheckBox.Checked)) + ' ' + IntToStr(Utility.MapChecksums.Items[CurrentMapIndex]) + ' ' + Utility.MapList[CurrentMapIndex]);
end;


{ tries to figure out best possible team number, ally number and team color. It finds
  first available numbers (that aren't used by other players or bots in the battle).
  If IgnoreMyself is true, then this function will ignore our team, ally and team color
  numbers while trying to figure out best possible numbers. This should be used
  for example when trying to figure out best numbers once we've joined the battle,
  but our current numbers are undefined - although they are set to some value,
  these values should be reset. }
function TBattleForm.FigureOutBestPossibleTeamAllyAndColor(IgnoreMyself: Boolean;  var BestTeam, BestAlly, BestColorIndex:integer): Boolean;
var
  i,j: Integer;
  team, ally, color: Integer;
  found: Boolean;
  usedInt : TIntegerList;
begin
  usedInt := TIntegerList.Create;


  Result := False;

  if not IsBattleActive then Exit; // should not happen!

  if BattleState.Battle.BattleType = 1 then Exit;

  // find first available team and ally:
  team := 0;
  for i := 0 to BattleState.Battle.Clients.Count - 1 do
    if (not IgnoreMyself) or (TClient(BattleState.Battle.Clients[i]).Name <> Status.Username) then // ignore ourselves only if set so by IgnoreMyself
      if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then
        usedInt.Add(TClient(BattleState.Battle.Clients[i]).GetTeamNo);
  for i := 0 to BattleState.Battle.Bots.Count - 1 do
    usedInt.Add( TBot(BattleState.Battle.Bots[i]).GetTeamNo);
  for i:=0 to 15 do
    if usedInt.IndexOf(i) = -1 then
    begin
      team := i;
      ally := team;
      break;
    end;

  // find first available team color:
  usedInt.Clear;
  for i := 0 to BattleState.Battle.Clients.Count - 1 do
    if (not IgnoreMyself) or (TClient(BattleState.Battle.Clients[i]).Name <> Status.Username) then // ignore ourselves only if set so by IgnoreMyself
      if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then
        usedInt.Add(TClient(BattleState.Battle.Clients[i]).TeamColor);
  for i := 0 to BattleState.Battle.Bots.Count - 1 do
    usedInt.Add(TBot(BattleState.Battle.Bots[i]).TeamColor);

  color := -1;
  i := 0;
  while (i <= High(TeamColors)) and (color = -1)  do
  begin
    j := 0;
    color := i;
    while (j < usedInt.Count) do
    begin
      if Misc.ColorDistance2(TeamColors[i],usedInt.Items[j]) < 50 then
      begin
        color := -1;
        break;
      end;
      Inc(j);
    end;
    Inc(i);
  end;
  if color = -1 then
    color := 0;

  BestTeam := team;
  BestAlly := ally;
  BestColorIndex := color;

  Result := True;
end;

procedure TBattleForm.ChooseSidePopupMenuItemClick(Sender: TObject);
begin
  (Sender as TSpTBXItem).Parent.Tag := (Sender as TSpTBXItem).Tag;
end;

procedure TBattleForm.ChangeCurrentMod(ModName: string);
var
  tmp: Integer;
  Side1, Side2: string;
  s: string;
  i: Integer;
  sl: TStringList;
begin

  tmp := ModList.Count;
  if not Utility.ReInitLib then
  begin
    MessageDlg(_('Error initializing unit syncer!'), mtError, [mbOK], 0);
    Application.Terminate;
  end;
  // update mod list:
  if tmp <> ModList.Count then // did number of mods change?
  begin
    s := HostBattleForm.ModsComboBox.Text;
    sl := TStringList.Create;
    sl.Assign(Utility.ModList);
    sl.Sort;
    HostBattleForm.ModsComboBox.Items.Assign(sl);
    HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(s));
  end;

  FCurrentModName := ModName;

  LoadMod(ModArchiveList[ModList.IndexOf(ModName)]);

  Side1 := MySideButton.Caption;
  Side2 := AddBotForm.BotSideButton.Caption;
  ReloadSides;
  if SideList.Count > 16 then
  begin
    MainForm.AddMainLog('Warning: more than 16 sides detected in current mod, truncating ...', Colors.Error);
    while SideList.Count > 16 do SideList.Delete(SideList.Count-1);
  end;

  MySideButton.Images := SideImageList;
  ChooseSidePopupMenu.Images := SideImageList;

  // populate ChooseSidePopupMenu:
  ChooseSidePopupMenu.Items.Clear;
  for i := 0 to SideList.Count-1 do
  begin
    ChooseSidePopupMenu.Items.Add(TSpTBXItem.Create(ChooseSidePopupMenu.Items.Owner));
    with ChooseSidePopupMenu.Items[ChooseSidePopupMenu.Items.Count-1] as TSpTBXItem do
    begin
      GroupIndex := 1;
      RadioItem := True;
      Caption := SideList[i];
      Tag := i;
      ImageIndex := i;
      OnClick := ChooseSidePopupMenuItemClick;
    end;
  end;
  // populate SetBotSideSubitem:
  SetBotSideSubitem.Clear;
  for i := 0 to SideList.Count-1 do
  begin
    SetBotSideSubitem.Add(TSpTBXItem.Create(SetBotSideSubitem));
    with SetBotSideSubitem.Items[SetBotSideSubitem.Count-1] as TSpTBXItem do
    begin
      Caption := SideList[i];
      Tag := i;
      Images := Utility.SideImageList;
      ImageIndex := i;
      OnClick := SetBotSideItemClick;
    end;
  end;

  // select some side:
  //ChangeSide(Min(Max(0, SideList.IndexOf(Side1)), SideList.Count-1), False); // old
  ChangeSide(Min(Max(0, MySideButton.Tag), SideList.Count-1), False);
  AddBotForm.ChangeSide(Min(Max(0, SideList.IndexOf(Side2)), SideList.Count-1));

  // load mod options
  Utility.LoadModOptions;
  DisplayLuaOptions(ModOptionsList,ModOptionsScrollBox);
  LoadModOptionsDefault(ModName);
  panelModOptionsDefault.Visible := ModOptionsList.Count > 0;
  ModTab.Caption := _('Mod options (')+IntToStr(ModOptionsList.Count)+')';
end;

procedure TBattleForm.ChangeMapToNoMap(MapName: string);
var
  s: string;
begin
  if (Length(MapName) > 1) and (MapName[Length(MapName)] <> '.') then // we need this in order to not cut a '.' char from strings like "Loading..." (which are not true file names ofcourse)
    MapName := Copy(MapName, 1, Length(MapName) - Length(ExtractFileExt(MapName))); // remove '.smf'

  MapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
  MetalMapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
  HeightMapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
  with MapImage.Picture.Bitmap.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Style := Font.Style + [fsBold];
    Font.Size := 16; // default
    while TextWidth(MapName) > MapImage.Picture.Bitmap.Width do
    begin
      Font.Size := Font.Size - 1;
      if Font.Size = 1 then Break; // smallest possible size
    end;

    Font.Color := $001111EE; // (0, B, G, R)
    TextOut(MapImage.Picture.Bitmap.Width div 2 - TextWidth(MapName) div 2, MapImage.Picture.Bitmap.Height div 2 - TextHeight('X') div 2, MapName);

    Font.Size := 11;
    Font.Color := clBlack;
    TextOut(5, 5, 'Map not found:');

    Font.Size := 11;
    s := '(click to get it)';
    Font.Color := clLime;
    Brush.Color := clBlack;
    TextOut(MapImage.Picture.Bitmap.Width div 2 - TextWidth(s) div 2, MapImage.Picture.Bitmap.Height - TextHeight('X') - 20, s);
  end;

  MapSizeLabel.Caption := _('Map size: ?');
  TidalStrengthLabel.Caption := _('Tidal strength: ?');
  GravityLabel.Caption := _('Gravity: ?');
  MaxMetalLabel.Caption := _('Max. metal: ?');
  ExtRadiusLabel.Caption := _('Extractor radius: ?');
  WindLabel.Caption := _('Wind (min/max/avg): ?');
  MapDescLabel.Caption := _('Description: Click on the minimap to attempt to locate map in the "Online maps" list!');
  MapDescLabel.Hint := MapDescLabel.Caption;

  FCurrentMapIndex := -1;
  MapSelectionForm.MapListBox.ItemIndex := -1;

  TotalMetal := 0;
  MapMetalWidth := 0;
  MapMetalHeight := 0;
  MapHeightWidth := 0;
  MapHeightHeight := 0;

  MapImage.Hint := _('No map');

  if MapOptionsList <> nil then
    Utility.UnLoadLuaOptions(MapOptionsList);

  RefreshQuickLookText;

  CheckBattleSync;

  SendMyBattleStatusToServer;
  MinimapPanelResize(nil);
  MetalMapPanelResize(nil);
  HeightMapPanelResize(nil);
end;

procedure TBattleForm.CheckBattleSync;
var
  mapSynced,modSynced : Boolean;
begin
  if IsBattleActive then
    if BattleState.Status = Hosting then
      Status.Synced := true
    else
    begin
      mapSynced := True;
      modSynced := True;

      if (CurrentMapIndex = -1) or ( (BattleState.Battle.MapHash <> 0) and (Utility.MapChecksums.Items[CurrentMapIndex] <> BattleState.Battle.MapHash) ) then
      begin
        mapSynced := False;
        if not (CurrentMapIndex = -1) and (BattleState.Status <> None) then
          AddTextToChat(_('Your map differs from the host''s one.'),Colors.Error,1);
      end;
      if (BattleState.Battle.HashCode <> 0) and (GetModHash(BattleState.Battle.ModName) <> BattleState.Battle.HashCode) then
      begin
        modSynced := False;
        if BattleState.Status <> None then
          AddTextToChat(_('Your mod differs from the host''s one.'),Colors.Error,1);
      end;

      Status.Synced := mapSynced and modSynced;
    end;
end;

procedure TBattleForm.ChangeMapToFirstOne;
begin
  ChangeMap(Utility.MapList.IndexOf(MapSelectionForm.MapListBox.Items.Strings[0]));
end;

procedure TBattleForm.ChangeMap(MapIndex: Integer);
var
  MapInfo: TMapInfo;
  width,height : integer;
  i,j,v:integer;
  P: PByteArray;
  minimap: TBitmap;
begin
  if MapIndex = -1 then // you should use ChangeMapToNoMap method instead!
  begin
    MainForm.AddMainLog('Error: map index ('+IntToStr(MapIndex)+') out of bounds.',Colors.Error);
    Exit;
  end;
  if MapIndex > Utility.MapList.Count-1 then // this should not happen!
  begin
    MainForm.AddMainLog('Error: map index ('+IntToStr(MapIndex)+') out of bounds.',Colors.Error);
    Exit;
  end;
  if MapIndex = CurrentMapIndex then
  begin
    if Debug.Enabled then
      MainForm.AddMainLog('Debug: map already loaded.',Colors.Normal);
    Exit; // no need to change anything, we already have this map loaded!
  end;

  TMapItem(MapListForm.Maps[MapIndex]).LoadMapInfo;
  minimap := TBitmap.Create;
  Utility.LoadMiniMap(TMapItem(MapListForm.Maps[MapIndex]).MapName,minimap);
  BattleForm.MapImage.Picture.Assign(minimap);
  TMapItem(MapListForm.Maps[MapIndex]).LoadMinimap(False,minimap);

  TotalMetal := 0;
  MapMetalWidth := 0;
  MapMetalHeight := 0;
  MapHeightWidth := 0;
  MapHeightHeight := 0;

  // load height map in the corresponding TImage
  if Preferences.LoadMetalHeightMinimaps then
  begin
    try
      if MapHeight <> nil then Utility.free(MapHeight);
      MapHeight := Utility.getHeightMap(Utility.MapList[MapIndex],MapHeightWidth,MapHeightHeight);
      if MapHeight = nil then raise Exception.Create('error');
    except
      MapHeightWidth := 64;
      MapHeightHeight := 64;
      MapHeight := Utility.malloc(MapHeightWidth*MapHeightHeight);
    end;

    HeightMapImage.Picture.Bitmap.Width := MapHeightWidth-1;
    HeightMapImage.Picture.Bitmap.Height := MapHeightHeight-1;
    HeightMapImage.Picture.Bitmap.PixelFormat := pf24bit;
    HeightMapImage.Picture.Bitmap.Canvas.Brush.Color := clBlack;
    HeightMapImage.Picture.Bitmap.Canvas.FillRect(HeightMapImage.Picture.Bitmap.Canvas.ClipRect);

    for j:=0 to MapHeightHeight-2 do
    begin
      P := HeightMapImage.Picture.Bitmap.ScanLine[j];
      for i:=1 to MapHeightWidth-1 do
      begin
        v := Ord(MapHeight[j*MapHeightWidth+i]);
        P[(i-1)*3] := v;
        P[(i-1)*3+1] := v;
        P[(i-1)*3+2] := v;
      end;
    end;

    HeightMapImage.Refresh;
    
    // load the metal map in the corresponding TImage
    try
      if MapMetal <> nil then Utility.free(MapMetal);
      MapMetal := Utility.getMetalMap(Utility.MapList[MapIndex],MapMetalWidth,MapMetalHeight);
      if MapMetal = nil then raise Exception.Create('error');
    except
      MapMetalWidth := 64;
      MapMetalHeight := 64;
      MapMetal := Utility.malloc(MapMetalWidth*MapMetalHeight);
    end;

    MetalMapImage.Picture.Graphic.Width := MapMetalWidth-1;
    MetalMapImage.Picture.Graphic.Height := MapMetalHeight-1;
    MetalMapImage.Picture.Bitmap.PixelFormat := pf24bit;

    for j:=0 to MapMetalHeight-2 do
    begin
      P := MetalMapImage.Picture.Bitmap.ScanLine[j];
      for i:=0 to MapMetalWidth-2 do
      begin
        v := Ord(MapMetal[j*MapMetalWidth+i]);
        P[i*3] := 0;
        P[i*3+1] := v;
        P[i*3+2] := 0;
      end;
    end;

    MetalMapImage.Refresh;

    // get the total amount of metal of that map
    TotalMetal := 0;
    for i:=1 to MapMetalWidth*MapMetalHeight do
      TotalMetal := TotalMetal + Ord(MapMetal[i]);
  end
  else
  begin
    MetalMapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
    HeightMapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
    MetalMapImage.Canvas.TextOut(0,Floor(MetalMapImage.Picture.Height/2-MetalMapImage.Canvas.TextHeight('M')/2),'Metal minimap loading disabled');
    HeightMapImage.Canvas.TextOut(0,Floor(HeightMapImage.Picture.Height/2-HeightMapImage.Canvas.TextHeight('M')/2),'Height minimap loading disabled');
  end;

  MapInfo := GetMapItem(MapIndex).MapInfo;

  MapSizeLabel.Caption := _('Map size: ')+IntToStr(GetMapItem(MapIndex).MapInfo.Width div 64) + ' x ' + IntToStr(GetMapItem(MapIndex).MapInfo.Height div 64);
  TidalStrengthLabel.Caption := _('Tidal strength: ') + IntToStr(MapInfo.TidalStrength);
  GravityLabel.Caption := _('Gravity: ') + IntToStr(MapInfo.Gravity);
  MaxMetalLabel.Caption := _('Max. metal: ') + Format('%.5g', [MapInfo.Maxmetal]);
  ExtRadiusLabel.Caption := _('Extractor radius: ') + IntToStr(MapInfo.ExtractorRadius);
//  Label6.Caption := 'Min. wind: ' + Format('%.5g', [MapInfo.MinWind]);
//  Label7.Caption := 'Max. wind: ' + Format('%.5g', [MapInfo.MaxWind]);
  WindLabel.Caption := _('Wind (min/max/avg): ') + IntToStr(MapInfo.MinWind) + '-' + IntToStr(MapInfo.MaxWind)+ '-' + IntToStr(Round((MapInfo.MaxWind+MapInfo.MinWind)/2));
  MapDescLabel.Caption := GetMapItem(MapIndex).MapName + _(' - Description: ') + MapInfo.Description;
  MapDescLabel.Hint := MapDescLabel.Caption;

  Preferences.LastOpenMap := GetMapItem(MapIndex).MapName;

  FCurrentMapIndex := MapIndex;
  MapSelectionForm.MapListBox.ItemIndex := MapIndex;

  MapImage.Hint := GetMapItem(MapIndex).MapName + '. '+_('Use Shift+Click/Drag to draw a new box, Ctrl+Click/Drag to move an existing box, 1-2-3-... over a box to change its id and DEL over a box to delete it.');

  // load map options
  Utility.LoadMapOptions(GetMapItem(MapIndex).MapName);
  DisplayLuaOptions(BattleForm.MapOptionsList,BattleForm.MapOptionsScrollBox);
  LoadMapOptionsDefault;

  // UnknownScriptTagList.ValueList[UnknownScriptTagList.CompleteKeyList.IndexOf(LowerCase(completeKey))] := value
  for i:=0 to BattleForm.MapOptionsList.Count-1 do
  begin
    j := UnknownScriptTagList.CompleteKeyList.IndexOf(LowerCase(TLuaOption(BattleForm.MapOptionsList[i]).KeyPrefix+TLuaOption(BattleForm.MapOptionsList[i]).Key));
    if j>-1 then
    begin
      TLuaOption(BattleForm.MapOptionsList[i]).SetValue(UnknownScriptTagList.ValueList[j]);
      //UnknownScriptTagList.CompleteKeyList.Delete(j);
      //UnknownScriptTagList.ValueList.Delete(j);
    end;
  end;

  panelMapOptionsDefault.Visible := MapOptionsList.Count > 0;
  MapTab.Caption := _('Map options (')+IntToStr(BattleForm.MapOptionsList.Count)+')';
  RefreshQuickLookText;
  QuickLookChangedTmr.Enabled := True;

  try
    minimap.Free;
  except
  end;

  MinimapPanelResize(nil);
  MetalMapPanelResize(nil);
  HeightMapPanelResize(nil);

  CheckBattleSync;

  SendMyBattleStatusToServer;
  SendLuaOptionsDetailsToServer;

  MainForm.PrintUnitsyncErrors;
end;

procedure TBattleForm.PopulatePopupMenuMapList;
begin
  MapSelectionForm.FilterTextBox.Text := '';
  PopulatePopupMenuMapListF(MapSelectionForm.FilterTextBox.Text);
end;

procedure TBattleForm.PopulatePopupMenuMapListF(filter: string = '');
var
  i: Integer;
  validMaps: TStringList;
begin
  MapSelectionForm.MapListBox.Items.BeginUpdate;
  MapSelectionForm.MapListBox.Items.Clear;

  for i:=0 to Utility.MapList.Count-1 do
    if (
      ((filter = '') or (Pos(LowerCase(filter),LowerCase(Utility.MapList[i])) > 0)) and // filter
      ((Utility.ModValidMaps = nil) or (Utility.ModValidMaps.Count = 0) or (Utility.ModValidMaps.IndexOf(Utility.MapList[i]) >= 0)) // valid maps
    ) then
      MapSelectionForm.MapListBox.Items.Add(Utility.MapList[i]);
  MapSelectionForm.MapListBox.Items.EndUpdate;
end;

procedure TBattleForm.MapsPopupMenuItemClick(Sender: TObject);
var
  index : integer;
begin
  if MapSelectionForm.MapListBox.ItemIndex = -1 then Exit;
  index :=  Utility.MapList.IndexOf(MapSelectionForm.MapListBox.Items.Strings[MapSelectionForm.MapListBox.ItemIndex]);
  if IsBattleActive and (BattleState.Status = Joined) then
  begin
    //*** MessageDlg('Only battle host is able to change map!', mtWarning, [mbOK], 0);
    if BattleState.AutoHost and Preferences.DisplayAutohostInterface then
      if BattleState.AutoHostType = 1 then
        MainForm.TryToSendCommand('SAYBATTLE', '!votemap ' + Utility.MapList[index])
      else
        MainForm.TryToSendCommand('SAYBATTLE', '!map ' + Utility.MapList[index])
    else
      MainForm.TryToSendCommand('SAYBATTLEEX', 'suggests ' + Utility.MapList[index]);
    MapSelectionForm.MapListBox.ItemIndex := CurrentMapIndex;
    Exit;
  end;

  if IsBattleActive and (BattleState.Battle.BattleType = 1) then
  begin
    MessageDlg(_('Cannot change map while hosting battle replay!'), mtWarning, [mbOK], 0);
    MapSelectionForm.MapListBox.ItemIndex := CurrentMapIndex;
    Exit;
  end;

  // ok we are either not participating in a battle or we are and are its host at the same time
  ChangeMap(index);

  if IsBattleActive and (BattleState.Status = Hosting) then
    SendBattleInfoToServer;
end;

procedure TBattleForm.SetRadioItem(PopupMenu: TSpTBXPopupMenu; ItemIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to PopupMenu.Items.Count-1 do
    PopupMenu.Items[i].Checked := False;

  if ItemIndex = -1 then Exit
  else PopupMenu.Items[ItemIndex].Checked := True;
end;

// used with "hole punching" NAT traversal technique
procedure TBattleForm.PunchThroughNAT;
var
  i: Integer;
begin
  for i := 1 {skip the host} to BattleState.Battle.Clients.Count-1 do
  try
    if TClient(BattleState.Battle.Clients[i]).IP = '' then MainForm.AddMainLog('Error punching through NAT: player''s IP is unknown!', Colors.Error)
    else Misc.SendUDPStrEx(TClient(BattleState.Battle.Clients[i]).IP, TClient(BattleState.Battle.Clients[i]).PublicPort, NATTraversal.MyPrivateUDPSourcePort, 2, 'HELLO'); // what we send doesn't really matter (we can send an empty packet as well).
  except
    MainForm.AddMainLog(_('Error while sending UDP packet to ') + TClient(BattleState.Battle.Clients[i]).Name + ' (IP=' + TClient(BattleState.Battle.Clients[i]).IP + ')', Colors.Error);
  end;
end;

procedure TBattleForm.OnStartGameMessage(var Msg: TMessage); // responds to WM_STARTGAME message
var
  i,j: Integer;
  v: string;
  script:string;
  scriptGenerationResult: TScript;
  r: string;
  params: string;
  springExe: string;
  springPath: string;
  lobbyDir: string;
  createProcessResult: LongBool;
begin
  if not IsBattleActive then Exit; // this should not happen

  if (BattleState.HostSupportsJoinPassword and (BattleState.Status = Joined)) or (HostBattleForm.relayHoster <> nil) then
  begin
    JoinButton.Visible := True;
    StartButton.Visible := False;
  end;

  if Status.AmIInGame then Exit;

  if Utility.MapList.indexOf(BattleState.Battle.Map) = -1 then
  begin
    ReloadMapListButtonClick(nil);
    if Utility.MapList.indexOf(BattleState.Battle.Map) = -1 then
    begin
      MessageDlg(_('You don''t have the map and cannot join the game.'),mtWarning,[mbOk],0);
      Exit;
    end;
  end;

  if (BattleState.Status = Hosting) then
  begin
    case BattleState.Battle.NATType of
    0: ;
    1: PunchThroughNAT;
    2: for i := 1 {skip the host} to BattleState.Battle.Clients.Count-1 do
       try
         if TClient(BattleState.Battle.Clients[i]).IP = '' then MainForm.AddMainLog(_('Error punching through NAT: player''s IP is unknown!'), Colors.Error)
         else Misc.SendUDPStrEx(TClient(BattleState.Battle.Clients[i]).IP, FIRST_UDP_SOURCEPORT + i - 1, BattleState.Battle.Port, 2, 'HELLO'); // what we send doesn't really matter (we could probably send an empty packet as well).
       except
         MainForm.AddMainLog(_('Error while sending UDP packet to ') + TClient(BattleState.Battle.Clients[i]).Name + ' (IP=' + TClient(BattleState.Battle.Clients[i]).IP + ')', Colors.Error);
       end;
    end;
  end;

  BattleForm.AmIReady := False; // status is automatically updated in this property's "setter"

//***  DeleteFile(ExtractFilePath(Application.ExeName) + 'script.txt'); // no problem if file does not exist (function will return FALSE in that case)

  if (BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil) then
  begin
    if BattleState.Battle.BattleType = 0 then
      scriptGenerationResult := GenerateNormalHostScriptFile(ExtractFilePath(Application.ExeName) + 'script.txt')
    else
      scriptGenerationResult := GenerateReplayHostScriptFile(ExtractFilePath(Application.ExeName) + 'script.txt');
  end
  else
    scriptGenerationResult := GenerateJoinScriptFile(ExtractFilePath(Application.ExeName) + 'script.txt');
  if scriptGenerationResult = nil then
    Exit;

  if not NO3D then
  begin
    if Minimap3DPreview <> nil then
      Minimap3DPreview.Close;
  end;

  FillChar(BattleState.Process.proc_info, sizeof(TProcessInformation), 0);
  FillChar(BattleState.Process.startinfo, sizeof(TStartupInfo), 0);
  BattleState.Process.startinfo.cb := sizeof(TStartupInfo);
  BattleState.Process.startinfo.dwFlags := STARTF_USESHOWWINDOW;
  BattleState.Process.startinfo.wShowWindow := SW_SHOWMAXIMIZED;

  if SpringSettingsProfileForm.cpNames.IndexOf(SpringSettingsProfile) = -1 then
    SpringSettingsProfile := '';

  lobbyDir := ExtractFilePath(Application.ExeName);

  params := '"' + lobbyDir + 'script.txt"';
  r := SpringSettingsProfileForm.getSettingsFile(Status.Me.GetMode = 0,SpringSettingsProfile <> '',SpringSettingsProfile);
  if r <> '' then
    params := '--config="'+r+'" '+params;

  AcquireMainThread;
  if not Preferences.ScriptsDisabled then
  begin
    try
      r := handlers.onStartSpring(params);
    except
      r := 'None';
    end;
    if r <> 'None' then
      params := r;
  end;
  ReleaseMainThread;

  springExe := SpringSettingsProfileForm.getSpringExe;
  if BattleState.Battle.EngineVersion = Status.MySpringVersion then
    springPath := ''
  else
    springPath := lobbyDir+'engine\'+BattleState.Battle.EngineVersion+'\';

  createProcessResult := CreateProcess(nil, PChar('"'+springPath+springExe + '" ' + params), nil, nil, false, CREATE_DEFAULT_ERROR_MODE + NORMAL_PRIORITY_CLASS + SYNCHRONIZE, nil, PChar(lobbyDir), BattleState.Process.startinfo, BattleState.Process.proc_info);

  if createProcessResult then
  begin
    AddTextToChat('Game launched', Colors.Info, 1);
    Status.AmIInGame := True;
    MainForm.TryToSendCommand('MYSTATUS', '1');
    GameTimer.Enabled := True;
    if (BattleState.Status = Hosting) and not BattleState.Battle.Locked and mnuAutoLockOnStart.Checked then
      LockedCheckBoxClick(nil);
  end
  else
  begin
    CloseHandle(BattleState.Process.proc_info.hProcess);
    Application.MessageBox(PChar(_('Couldn''t execute the application')), 'Error', MB_ICONEXCLAMATION);
  end;
end;

function TBattleForm.JoinBattle(BattleID: Integer): Boolean;
var
  Battle: TBattle;
  tmp: Integer;
  i: integer;
  validMaps: TStringList;
  dlMap: TDownloadMapThread;
begin
  Result := False;

  if BattleState.Status <> None then
  begin // this should NEVER happen!
    MessageDlg(_('Error: cannot participate in multiple battles. Please report this error!'), mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  Battle := MainForm.GetBattle(BattleID);
  if Battle = nil then Exit;

  BattleState.JoiningComplete := False;
  BattleState.Battle := Battle;
  BattleState.AutoHost := False;

  BattleState.DisabledUnits.Clear;
  PopulateDisabledUnitsVDT;

  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  EnableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := True;
  AddUnitsSpeedButton.Enabled := False;
  LockedCheckBox.Enabled := False;
  AdminButton.Enabled := False;
  LockedCheckBox.Checked := Battle.Locked;
  LoadDefaultButton.Enabled := False;
  btLoadDefaultMDO.Enabled := False;
  btLoadModsDefaultMDO.Enabled := False;
  btLoadDefaultMPO.Enabled := False;
  btLoadMapsDefaultMPO.Enabled := False;
  AutoStartRectsApplyItem.Enabled := False;
  AutoStartRectsOptionsItem.Enabled := False;

  MetalTracker.Min := 0;
  MetalTracker.Max:= 10000;
  EnergyTracker.Min := 0;
  EnergyTracker.Max := 10000;
  UnitsTracker.Min := 0;
  UnitsTracker.Max := 5000;

  if Preferences.DisplayUnitsIconsAndNames then
    VDTDisabledUnits.DefaultNodeHeight := 64
  else
    VDTDisabledUnits.DefaultNodeHeight := VDTDisabledUnits.Font.Size*2;


//  SetMyBattleStatus(SideComboBox.ItemIndex, False, 0, 0, 1, MyTeamColorIndex); *** we will update it once we receive REQUESTBATTLESTATUS
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS (server should send it after he is finished sending us battle statuses of other players)

  BattleState.Battle.RemoveAllBots;
  UpdateClientsListBox;

  PopulatePopupMenuMapList;

  // update map:
  if (CurrentMapIndex = -1) or (Battle.Map <> GetMapItem(CurrentMapIndex).MapName) then
    if Utility.MapList.IndexOf(Battle.Map) = -1 then
      ChangeMapToNoMap(Battle.Map)
    else
      ChangeMap(Utility.MapList.IndexOf(Battle.Map));

  // disable map options
  for i := 0 to MapOptionsList.Count-1 do
    TLuaOption(MapOptionsList[i]).Disable;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := True;

  AddTextToChat('Joined battle', Colors.Info, 1);

  BattleState.Status := Joined;
  BattleState.HostSupportsJoinPassword := False;

  ResetStartRects;
  BattleForm.Caption := _('Battle window (') + BattleState.Battle.ModName + ')'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := _('Battle window (') + BattleState.Battle.ModName + ')';

  if Utility.MapList.IndexOf(BattleState.Battle.Map) = -1 then
    SpringDownloaderFormUnit.DownloadMap(BattleState.Battle.MapHash,BattleState.Battle.Map,True);
    //dlMap := TDownloadMapThread.Create(false,BattleState.Battle.MapHash,BattleState.Battle.Map);

  Result := True;

  if not Preferences.DisableAllSounds then PlayResSound('battle');

  TipsForm.ShowTips(2);

//*** anything else?
end;

function TBattleForm.JoinBattleReplay(BattleID: Integer): Boolean;
var
  Battle: TBattle;
  tmp: Integer;
  i: Integer;
  dlMap: TDownloadMapThread;
begin
  Result := False;

  if BattleState.Status <> None then
  begin // this should NEVER happen!
    MessageDlg(_('Error: cannot participate in multiple battles. Please report this error!'), mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  Battle := MainForm.GetBattle(BattleID);
  if Battle = nil then Exit;

  BattleState.Battle := Battle;
  BattleState.AutoHost := False;

  BattleState.DisabledUnits.Clear;
  PopulateDisabledUnitsVDT;

  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := True;
  AddUnitsSpeedButton.Enabled := False;
  LockedCheckBox.Enabled := False;
  AdminButton.Enabled := False;
  LockedCheckBox.Checked := Battle.Locked;
  LoadDefaultButton.Enabled := False;
  btLoadDefaultMDO.Enabled := False;
  btLoadModsDefaultMDO.Enabled := False;
  btLoadDefaultMPO.Enabled := False;
  btLoadMapsDefaultMPO.Enabled := False;
  AutoStartRectsApplyItem.Enabled := False;
  AutoStartRectsOptionsItem.Enabled := False;

//  SetMyBattleStatus(SideComboBox.ItemIndex, False, 0, 0, 1, MyTeamColorIndex); *** we will update it once we receive REQUESTBATTLESTATUS
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS (server should send it after he is finished sending us battle statuses of other players)

  BattleState.Battle.RemoveAllBots;
  UpdateClientsListBox;

  // update map:

  // update map:
  if Battle.Map <> GetMapItem(CurrentMapIndex).MapName then
    if Utility.MapList.IndexOf(Battle.Map) = -1 then ChangeMapToNoMap(Battle.Map)
    else ChangeMap(Utility.MapList.IndexOf(Battle.Map));

  // disable map options
  for i := 0 to MapOptionsList.Count-1 do
    TLuaOption(MapOptionsList[i]).Disable;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := False;

  AddTextToChat('Joined battle replay', Colors.Info, 1);

  BattleState.Status := Joined;
  BattleState.HostSupportsJoinPassword := False;

  ResetStartRects;
  BattleForm.Caption := _('Battle window (') + BattleState.Battle.ModName + ')'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := _('Battle window (') + BattleState.Battle.ModName + ')';

  if Utility.MapList.IndexOf(BattleState.Battle.Map) = -1 then
    SpringDownloaderFormUnit.DownloadMap(BattleState.Battle.MapHash,BattleState.Battle.Map);
    //dlMap := TDownloadMapThread.Create(false,BattleState.Battle.MapHash,BattleState.Battle.Map);
    
  Result := True;

  if not Preferences.DisableAllSounds then PlayResSound('battle');

  TipsForm.ShowTips(2);

//*** anything else?
end;

function TBattleForm.HostBattle(BattleID: Integer): Boolean;
var
  i:integer;
  disabledUnits: string;
  Battle: TBattle;
  validMaps: TStringList;
begin
  Result := False;

  if IsBattleActive then
  begin // this should NEVER happen!
    MessageDlg('Error: cannot participate in multiple battles. Please report this error!', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  Battle := MainForm.GetBattle(BattleID);
  if Battle = nil then Exit;

  BattleState.JoiningComplete := False;
  BattleState.Battle := Battle;
  BattleState.AutoHost := False;

  BattleState.DisabledUnits.Clear;
  PopulateDisabledUnitsVDT;

  GameEndRadioGroup.Enabled := True;
  EnableControlAndChildren(ResourcesGroupBox);
  EnableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := True;
  AddUnitsSpeedButton.Enabled := True;
  LockedCheckBox.Enabled := True;
  AdminButton.Enabled := True;
  LockedCheckBox.Checked := False;
  AutoStartRectsApplyItem.Enabled := True;
  AutoStartRectsOptionsItem.Enabled := True;

  SetMyBattleStatus(MySideButton.Tag, False, 0, 0, 1);
  ChangeTeamColor(MyTeamColorIndex, False);
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS

  BattleState.Battle.RemoveAllBots;
  UpdateClientsListBox;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := True;

  BattleState.Status := Hosting;

  ResetStartRects;
  BattleForm.Caption := _('Battle window (') + BattleState.Battle.ModName + ')'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := _('Battle window (') + BattleState.Battle.ModName + ')';

  Result := True;

  if not Preferences.DisableAllSounds then PlayResSound('battle');
  BattleForm.mnuLoadBoxesClick(BattleForm.mnuLoadBoxes);

  PopulatePopupMenuMapList;

  // load map options
  if CurrentMapIndex > -1 then
  begin
    if (Utility.ModValidMaps<>nil) and (Utility.ModValidMaps.Count > 0) and (Utility.ModValidMaps.IndexOf(Utility.MapList[CurrentMapIndex]) = -1) then
      ChangeMap(Utility.MapList.IndexOf(MapSelectionForm.MapListBox.Items[0]));

    Utility.LoadMapOptions(TMapItem(MapListForm.Maps[CurrentMapIndex]).MapName);
    DisplayLuaOptions(BattleForm.MapOptionsList,BattleForm.MapOptionsScrollBox);
    LoadMapOptionsDefault;
    panelMapOptionsDefault.Visible := MapOptionsList.Count > 0;
  end;
  MapTab.Caption := _('Map options (')+IntToStr(BattleForm.MapOptionsList.Count)+')';

  LoadDefaultButtonClick(nil);

  AddTextToChat(_('Battle opened'), Colors.Info, 1);

  RefreshQuickLookText;

  TipsForm.ShowTips(1);

//*** anything else?
end;

function TBattleForm.HostBattleReplay(BattleID: Integer): Boolean;
var
  Battle: TBattle;
  i:integer;
begin
  Result := False;

  if IsBattleActive then
  begin // this should NEVER happen!
    MessageDlg('Error: cannot participate in multiple battles. Please report this error!', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  Battle := MainForm.GetBattle(BattleID);
  if Battle = nil then Exit;

  BattleState.JoiningComplete := False;
  BattleState.Battle := Battle;
  BattleState.AutoHost := False;

  BattleState.DisabledUnits.Clear;
  PopulateDisabledUnitsVDT;

  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := True;
  AddUnitsSpeedButton.Enabled := False;
  LockedCheckBox.Enabled := True;
  AdminButton.Enabled := True;
  LockedCheckBox.Checked := False;
  LoadDefaultButton.Enabled := False;
  btLoadDefaultMDO.Enabled := False;
  btLoadModsDefaultMDO.Enabled := False;
  btLoadDefaultMPO.Enabled := False;
  btLoadMapsDefaultMPO.Enabled := False;
  AutoStartRectsApplyItem.Enabled := False;
  AutoStartRectsOptionsItem.Enabled := False;

  SetMyBattleStatus(0, False, 0, 0, 1);
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS

  BattleState.Battle.RemoveAllBots;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := False;

  AddTextToChat(_('Battle replay opened'), Colors.Info, 1);

  BattleState.Status := Hosting;

  ResetStartRects;
  BattleForm.Caption := _('Battle window (') + BattleState.Battle.ModName + ')'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := _('Battle window (') + BattleState.Battle.ModName + ')';

  // add boxes
  i:=0;
  while BattleReplayInfo.Script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectLeft')<>'' do
  begin
    AddStartRect(i,Rect(Round(StrToFloat(BattleReplayInfo.Script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectLeft'))*100),Round(StrToFloat(BattleReplayInfo.Script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectTop'))*100),Round(StrToFloat(BattleReplayInfo.Script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectRight'))*100),Round(StrToFloat(BattleReplayInfo.Script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectBottom'))*100)));
    with BattleState.StartRects[i] do
        MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(i) + ' ' + IntToStr(Rect.Left*2) + ' ' + IntToStr(Rect.Top*2) + ' ' + IntToStr(Rect.Right*2) + ' ' + IntToStr(Rect.Bottom*2) + ' ');
    i := i+1;
  end;


  // load map options
  Utility.LoadMapOptions(TMapItem(MapListForm.Maps[CurrentMapIndex]).MapName);
  DisplayLuaOptions(BattleForm.MapOptionsList,BattleForm.MapOptionsScrollBox);
  LoadMapOptionsDefault;
  panelMapOptionsDefault.Visible := MapOptionsList.Count > 0;
  MapTab.Caption := _('Map options (')+IntToStr(BattleForm.MapOptionsList.Count)+')';

  // disable mod options
  for i := 0 to ModOptionsList.Count-1 do
    TLuaOption(ModOptionsList[i]).Disable;

  // disable map options
  for i := 0 to MapOptionsList.Count-1 do
    TLuaOption(MapOptionsList[i]).Disable;

  if not ApplyScriptFile(BattleReplayInfo.Script) then
  begin
    MessageDlg(_('Unexpected inconsistency error: Script file is corrupt! Cannot host this replay.'), mtError, [mbOK], 0);
    BattleForm.DisconnectButtonClick(nil);
    Exit;
  end;

  UpdateClientsListBox;

  Result := True;

  if not Preferences.DisableAllSounds then PlayResSound('battle');

//*** anything else?
end;

{ resets the battle screen: clears the clients list, enables/disables controls, ... }
procedure TBattleForm.ResetBattleScreen;
begin
  BattleForm.VDTBattleClients.Header.Columns[1].Options := BattleForm.VDTBattleClients.Header.Columns[1].Options - [coVisible];
  BattleState.JoiningComplete := False;
  if IsBattleActive then
  begin
    AddTextToChat(_('Battle closed'), Colors.Info, 1);
    if not Preferences.DisableAllSounds then PlayResSound('battle');
    HostBattleForm.relayHoster := nil;
  end;

  StartButton.Visible := True;
  JoinButton.Visible := False;
  StartProgressBar.Visible := False;

  PopulatePopupMenuMapList;

  BattleState.DisabledUnits.Clear;
  PopulateDisabledUnitsVDT;

  MapSelectionForm.MapListBox.Enabled := True;

  BattleState.BanList.Clear;

  AutoHostVotePanel.Visible := False;
  AutoHostInfoPanel.Visible := False;
  AutohostControlSplitter.Visible := False;
  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := False;
  AddUnitsSpeedButton.Enabled := False;
  LockedCheckBox.Enabled := False;
  AdminButton.Enabled := False;
  LoadDefaultButton.Enabled := False;
  btLoadDefaultMDO.Enabled := False;
  btLoadModsDefaultMDO.Enabled := False;
  btLoadDefaultMPO.Enabled := False;
  btLoadMapsDefaultMPO.Enabled := False;
  AutoStartRectsApplyItem.Enabled := False;
  AutoStartRectsOptionsItem.Enabled := False;

  SetMyBattleStatus(MySideButton.Tag, False, 0, 0, 1);
  DisableControlAndChildren(MyOptionsGroupBox);
  ChangeTeamColor(MyTeamColorIndex, False);

  lblTeamNbr.Caption := '';

  UpdateClientsListBox;

  DisconnectButton.Enabled := False;
  StartButton.Enabled := False;
  HostButton.Enabled := True;
  AddBotButton.Enabled := False;

  ResetStartRects;
  BattleForm.Caption := _('Battle window'); // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := 'Battle window';

  // custom options reset
  if ModOptionsList <> nil then
    Utility.UnLoadLuaOptions(ModOptionsList);
  //if MapOptionsList <> nil then
  //  Utility.UnLoadLuaOptions(MapOptionsList);
  panelModOptionsDefault.Visible := false;
  panelMapOptionsDefault.Visible := false;
  ModTabSheet.Caption := _('Mod options (0)');
  //MapTabSheet.Caption := _('Map options (0)');
  if UnknownScriptTagList.CompleteKeyList <> nil then
    UnknownScriptTagList.CompleteKeyList.Clear;
  if UnknownScriptTagList.ValueList <> nil then
    UnknownScriptTagList.ValueList.Clear;

  MapSelectionForm.FilterTextBox.Text := '';

  RefreshQuickLookText;

  MainForm.ResetAutoKickMsgSentCounters;
  MainForm.ResetAutoSpecMsgSentCounters;
//*** anything else?
end;

function TBattleForm.ApplyScriptFile(Script: TScript): Boolean;
var
  s, su: string;
  i, j, k, c, count: Integer;
  fstart, fstop: Integer; // "field start", "field stop" (temp vars)
  name: string;
  spec: Boolean;
  team, ally, color, side, handicap: Integer;
  client: TClient;
  map: string;
  modname: string;
  metal, energy, units: Integer;
  startpos, gamemode: Integer;
  limitdgun, diminishingmms, ghostedbuildings: Boolean;
  temp: string;
  sl: TStringList;
  tmp: string;
begin
  Result := False;

  try
    FreeReplayClients; // clear the list

    // now let's read various info from script:
    try
      try
        count := 0;
        while True do
        begin
          name := Script.ReadKeyValue('GAME/PLAYER'+IntToStr(count)+'/NAME');
          if name = '' then break;
          tmp := Script.ReadKeyValue('GAME/PLAYER'+IntToStr(count)+'/SPECTATOR');
          if tmp = '' then raise Exception.Create('Corrupt script file!');
          spec := StrToBool(tmp);
          if not spec then
          begin
            tmp := Script.ReadKeyValue('GAME/PLAYER'+IntToStr(count)+'/TEAM');
            if tmp = '' then raise Exception.Create('Corrupt script file!');
            team := StrToInt(tmp);
          end;

          client := TClient.Create(name, 0, 'xx', 0,-1);
          client.SetMode(BoolToInt(not spec));
          client.SetTeamNo(team);
          client.SetReadyStatus(True);
          try
            client.Country := Script.ReadKeyValue('GAME/PLAYER'+IntToStr(count)+'/countrycode');
          except
            //
          end;
          try
            client.SetRank(StrToInt(Script.ReadKeyValue('GAME/PLAYER'+IntToStr(count)+'/rank')));
          except
            //
          end;

          BattleReplayInfo.OriginalClients.Add(client);

          Inc(count);
        end;
        if count = 0 then raise Exception.Create(_('Corrupt script file!'));

        count := 0;
        while True do
        begin
          tmp := Script.ReadKeyValue('GAME/TEAM'+IntToStr(count)+'/ALLYTEAM');
          if tmp = '' then break;
          ally := StrToInt(tmp);
          tmp := Script.ReadKeyValue('GAME/TEAM'+IntToStr(count)+'/RGBCOLOR');
          if tmp = '' then raise Exception.Create(_('Corrupt script file!'));
          sl := StringParser.ParseString(tmp, ' ');
          if sl.Count <> 3 then raise Exception.Create('Corrupt script file!');
          color := Misc.PackRGB(StrToFloat(sl[0]), StrToFloat(sl[1]), StrToFloat(sl[2]));
          tmp := Script.ReadKeyValue('GAME/TEAM'+IntToStr(count)+'/SIDE');
          if tmp = '' then raise Exception.Create(_('Corrupt script file!'));
          SideList.CaseSensitive := False;
          side := SideList.IndexOf(tmp);
          if side = -1 then raise Exception.Create('Corrupt script file!');
          tmp := Script.ReadKeyValue('GAME/TEAM'+IntToStr(count)+'/HANDICAP');
          if tmp = '' then raise Exception.Create(_('Corrupt script file!'));
          handicap := StrToInt(tmp);

          for c := 0 to BattleReplayInfo.OriginalClients.Count-1 do
          if TClient(BattleReplayInfo.OriginalClients[c]).GetTeamNo = count then
          begin
            TClient(BattleReplayInfo.OriginalClients[c]).SetAllyNo(ally);
            TClient(BattleReplayInfo.OriginalClients[c]).SetSide(side);
            TClient(BattleReplayInfo.OriginalClients[c]).SetHandicap(handicap);
            TClient(BattleReplayInfo.OriginalClients[c]).TeamColor := color;
          end;

          Inc(count);
        end;
        if count = 0 then raise Exception.Create(_('Corrupt script file!'));

        for i := 0 to ModOptionsList.Count-1 do
        begin
          tmp := Script.ReadKeyValue('GAME/MODOPTIONS/'+TLuaOption(ModOptionsList[i]).Key);
          if tmp <> '' then
            TLuaOption(ModOptionsList[i]).SetValue(tmp);
        end;
        for i := 0 to MapOptionsList.Count-1 do
        begin
          tmp := Script.ReadKeyValue('GAME/MAPOPTIONS/'+TLuaOption(MapOptionsList[i]).Key);
          if tmp <> '' then
            TLuaOption(MapOptionsList[i]).SetValue(tmp);
        end;
        map := Script.ReadMapName;
        modname := Script.ReadModName;

        if MetalTracker.Visible then
          metal := Script.ReadStartMetal;

        if EnergyTracker.Visible then
          energy := Script.ReadStartEnergy;

        if UnitsTracker.Visible then
          units := Script.ReadMaxUnits;

        startpos := Script.ReadStartPosType;

        if GameEndRadioGroup.Visible then
          gamemode := Script.ReadGameMode2;
      except
        raise Exception.Create(_('Corrupted script file!'));
      end;
    finally
    end;

    // apply changes:
    i := Utility.MapList.IndexOf(map);
    if i = -1 then ChangeMapToNoMap(map)
    else if CurrentMapIndex <> i then ChangeMap(i);

    {-->} AllowBattleDetailsUpdate := False;
    if MetalTracker.Visible then
      MetalTracker.Position := metal;
    if EnergyTracker.Visible then
      EnergyTracker.Position := energy;
    if UnitsTracker.Visible then
      UnitsTracker.Position := units;
    StartPosRadioGroup.ItemIndex := startpos;
    if GameEndRadioGroup.Visible then
      GameEndRadioGroup.ItemIndex := gamemode;
    {-->} AllowBattleDetailsUpdate := True;

  except
    FreeReplayClients; // just in case we actually managed to add some clients
    Exit;
  end;

  Result := True;

end;

function TBattleForm.GenerateJoinScriptFile(FileName: string):TScript;
var
  f: TextFile;
  Script: TScript;
  tryToRewriteScript: Boolean;
begin
  Script := TScript.Create('');
  Script.AddOrChangeKeyValue('GAME/IsHost','0');
  Script.AddOrChangeKeyValue('GAME/HostIP',BattleState.Battle.IP);
  Script.AddOrChangeKeyValue('GAME/HostPort',IntToStr(BattleState.Battle.Port));
  Script.AddOrChangeKeyValue('GAME/MyPlayerName',Status.Me.Name);
  if Status.Me.BattleJoinPassword <> '' then
  begin
    Script.AddOrChangeKeyValue('GAME/MyPasswd',Status.Me.BattleJoinPassword);
  end;

// write down the script
  repeat
  try
    AssignFile(f, FileName);
    Rewrite(f);
    Write(f, Script.Script);
    CloseFile(f);
    tryToRewriteScript := False;
    Result := Script;
  except
    Result := nil;
    Script.Free;
    try
      CloseFile(f);
    except
      //
    end;
    tryToRewriteScript := MessageDlg(CANT_WRITE_SCRIPT_MSG,mtError,[mbYes,mbNo],0) = mrYes;
  end;
  until not tryToRewriteScript;
end;

function TBattleForm.GenerateNormalHostScriptFile(FileName: string; relayHostScript: boolean=false):TScript;
var
  f: TextFile;
  NumberOfTeams: Integer;
  i, j, k, l: Integer;
  ModFileName: string;
  MyPlayerNum: Integer;
  Script: TScript;
  tryToRewriteScript: Boolean;
  mapHash: Cardinal;
  modHash: Cardinal;
  startPosIndexes: TIntegerList;
  // "purging" is needed for one reason: there mustn't be any gaps between team/ally numbers

begin
  Script := TScript.Create('');

  // get mod archive name:
  i := ModList.IndexOf(BattleState.Battle.ModName);
  if i = -1 then
  begin
    MessageDlg(_('Error: mod not found (') + BattleState.Battle.ModName + ')', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;
  ModFileName := ModArchiveList[i];

  // now let's write the script file:

  Script.AddOrChangeKeyValue('GAME/Mapname',BattleState.Battle.Map);
  mapHash := Utility.MapChecksums.Items[Utility.MapList.indexOf(BattleState.Battle.Map)];
  Script.AddOrChangeKeyValue('GAME/Maphash',IntToStr(mapHash));
  if MetalTracker.Visible then
    Script.AddOrChangeKeyValue('GAME/modoptions/StartMetal',IntToStr(MetalTracker.Position));
  if EnergyTracker.Visible then
    Script.AddOrChangeKeyValue('GAME/modoptions/StartEnergy',IntToStr(EnergyTracker.Position));
  if UnitsTracker.Visible then
    Script.AddOrChangeKeyValue('GAME/modoptions/MaxUnits',IntToStr(UnitsTracker.Position));
  if relayHostScript and (StartPosRadioGroup.ItemIndex < 2) then
  begin
    Script.AddOrChangeKeyValue('GAME/StartPosType','3');
    if StartPosRadioGroup.ItemIndex = 1 then // random start pos
    begin
      startPosIndexes := TIntegerList.Create;
      for i:=0 to GetMapItem(CurrentMapIndex).MapInfo.PosCount-1 do
        startPosIndexes.Add(i);
    end;
  end
  else
    Script.AddOrChangeKeyValue('GAME/StartPosType',IntToStr(StartPosRadioGroup.ItemIndex));
  if GameEndRadioGroup.Visible then
    Script.AddOrChangeKeyValue('GAME/modoptions/GameMode',IntToStr(GameEndRadioGroup.ItemIndex));
  Script.AddOrChangeKeyValue('GAME/GameType',BattleState.Battle.ModName);
  modHash := GetModHash(BattleState.Battle.ModName);
  Script.AddOrChangeKeyValue('GAME/ModHash',IntToStr(modHash));

  if not relayHostScript and BattleState.RelayChat then
  begin
    MainForm.SpringSocket.DefaultPort := BattleState.Battle.Port-1;
    Script.AddOrChangeKeyValue('GAME/autohostport',IntToStr(MainForm.SpringSocket.DefaultPort));
    BattleState.IngameName.Clear;
    BattleState.IngameId.Clear;
    BattleState.SpringComAddrAcquired := False;
    MainForm.SpringSocket.Active := True;
  end;

  if relayHostScript or ((BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil)) then
  begin
    Script.AddOrChangeKeyValue('GAME/HostIP',GetLocalIP);
    if not relayHostScript and (BattleState.Battle.NATType = 1) then
      Script.AddOrChangeKeyValue('GAME/HostPort',IntToStr(NATTraversal.MyPrivateUDPSourcePort))
    else
      Script.AddOrChangeKeyValue('GAME/HostPort',IntToStr(BattleState.Battle.Port));
  end
  else
  begin
    Script.AddOrChangeKeyValue('GAME/HostIP',BattleState.Battle.IP);
    Script.AddOrChangeKeyValue('GAME/HostPort',IntToStr(BattleState.Battle.Port));
  end;

  if not relayHostScript and (not (BattleState.Status = Hosting) or (HostBattleForm.relayHoster <> nil)) then
    case BattleState.Battle.NATType of
    0: ; // use default (system assigned) port
    1: Script.AddOrChangeKeyValue('GAME/SourcePort',IntToStr(NATTraversal.MyPrivateUDPSourcePort));
    2: Script.AddOrChangeKeyValue('GAME/SourcePort',IntToStr(FIRST_UDP_SOURCEPORT + MyPlayerNum - 1{skip the host}));
    end; // of case sentence
  //Script.AddOrChangeKeyValue('GAME/MyPlayerNum',IntToStr(MyPlayerNum));
  if relayHostScript then
  begin
    Script.AddOrChangeKeyValue('GAME/MyPlayerName',HostBattleForm.relayHoster.Name);
    Script.AddOrChangeKeyValue('GAME/IsHost','1');
    Script.AddOrChangeKeyValue('GAME/NumPlayers',IntToStr(BattleState.Battle.Clients.Count-1));
  end
  else
  begin
    Script.AddOrChangeKeyValue('GAME/MyPlayerName',Status.Me.Name);
    Script.AddOrChangeKeyValue('GAME/IsHost',BoolToStr((BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil)));
    Script.AddOrChangeKeyValue('GAME/NumPlayers',IntToStr(BattleState.Battle.Clients.Count));
  end;


  // players:
  for i := 0 to BattleState.Battle.Clients.Count-1 do
  begin
    if not relayHostScript or (i>0) then
    begin
      if relayHostScript then
        j := i-1
      else
        j := i;
      Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(j)+'/Name',TClient(BattleState.Battle.Clients[i]).Name);
      Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(j)+'/countryCode',TClient(BattleState.Battle.Clients[i]).Country);
      Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(j)+'/Rank',IntToStr(TClient(BattleState.Battle.Clients[i]).GetRank));
      if TClient(BattleState.Battle.Clients[i]).BattleJoinPassword <> '' then
        Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(j)+'/Password',TClient(BattleState.Battle.Clients[i]).BattleJoinPassword);
      if TClient(BattleState.Battle.Clients[i]).GetMode = 0 then
      begin
        Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(j)+'/Spectator','1');
      end
      else
      begin
        Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(j)+'/Spectator','0');
        Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(j)+'/team',IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo));
        //Inc(Pos);
      end;
    end;
  end;

  // bots:
  for i := 0 to BattleState.Battle.Bots.Count-1 do
  begin
    Script.AddOrChangeKeyValue('GAME/AI'+IntToStr(i)+'/Name',TBot(BattleState.Battle.Bots[i]).Name);
    Script.AddOrChangeKeyValue('GAME/AI'+IntToStr(i)+'/ShortName',TBot(BattleState.Battle.Bots[i]).AIShortName);
    Script.AddOrChangeKeyValue('GAME/AI'+IntToStr(i)+'/Team',IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo));
    for j:=0 to BattleState.Battle.Clients.Count-1 do
    begin
      if relayHostScript then
        k := j-1
      else
        k := j;
      if TClient(BattleState.Battle.Clients[j]).Name = TBot(BattleState.Battle.Bots[i]).OwnerName then
      begin
        Script.AddOrChangeKeyValue('GAME/AI'+IntToStr(i)+'/Host',IntToStr(k));
        break;
      end;
    end;
  end;

  Randomize;

  for i := 0 to BattleState.Battle.Clients.Count-1 do
  begin
    if relayHostScript then
      j := i-1
    else
      j := i;
    if not Script.keyExists('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)) and (TClient(BattleState.Battle.Clients[i]).GetMode = 1) and (not relayHostScript or (i>0)) then
    begin
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/TeamLeader',IntToStr(j));
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/AllyTeam',IntToStr(TClient(BattleState.Battle.Clients[i]).GetAllyNo));
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/RgbColor',Misc.ColorToScriptString(TClient(BattleState.Battle.Clients[i]).TeamColor));
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/Side',SideList[TClient(BattleState.Battle.Clients[i]).GetSide]);
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/Handicap',IntToStr(TClient(BattleState.Battle.Clients[i]).GetHandicap));
      if StartPosRadioGroup.ItemIndex = 3 then
      begin
        with BattleState.StartRects[TClient(BattleState.Battle.Clients[i]).GetTeamNo] do
        begin
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/StartPosX',IntToStr(Round((Rect.Left+(Rect.Right-Rect.Left)/2)*TMapItem(MapListForm.Maps[CurrentMapIndex]).MapInfo.Width*8/100)));
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/StartPosZ',IntToStr(Round((Rect.Top+(Rect.Bottom-Rect.Top)/2)*TMapItem(MapListForm.Maps[CurrentMapIndex]).MapInfo.Height*8/100)));
        end;
      end;
      if (StartPosRadioGroup.ItemIndex < 2) and relayHostScript then
      begin
        with GetMapItem(CurrentMapIndex) do
        begin
          if ((StartPosRadioGroup.ItemIndex = 0) and (NumberOfTeams >= MapInfo.PosCount)) or ((StartPosRadioGroup.ItemIndex = 1) and (startPosIndexes.Count = 0)) then
            raise Exception.Create(_('The map has not enough fixed start position. Please use another start position mode.'));
          if StartPosRadioGroup.ItemIndex = 1 then // random start pos
          begin
            l := RandomRange(0,startPosIndexes.Count-1);
            k := startPosIndexes.Items[l];
            startPosIndexes.Delete(l);
          end
          else
            k := NumberOfTeams;
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/StartPosX',IntToStr(MapInfo.Positions[k].x));
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetTeamNo)+'/StartPosZ',IntToStr(MapInfo.Positions[k].y));
        end;
      end;
      Inc(NumberOfTeams);
    end;
  end;

  for i := 0 to BattleState.Battle.Bots.Count-1 do
    if not Script.keyExists('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)) then
    begin
      for j:=0 to BattleState.Battle.Clients.Count-1 do
      begin
        if relayHostScript then
          k := j-1
        else
          k := j;
        if TClient(BattleState.Battle.Clients[j]).Name = TBot(BattleState.Battle.Bots[i]).OwnerName then
        begin
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/TeamLeader',IntToStr(k));
          break;
        end;
      end;
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/AllyTeam',IntToStr(TBot(BattleState.Battle.Bots[i]).GetAllyNo));
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/RgbColor',Misc.ColorToScriptString(TBot(BattleState.Battle.Bots[i]).TeamColor));
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/Side',SideList[TBot(BattleState.Battle.Bots[i]).GetSide]);
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/Handicap',IntToStr(TBot(BattleState.Battle.Bots[i]).GetHandicap));
      if StartPosRadioGroup.ItemIndex = 3 then
      begin
        with BattleState.StartRects[TBot(BattleState.Battle.Bots[i]).GetTeamNo] do
        begin
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/StartPosX',IntToStr(Round((Rect.Left+(Rect.Right-Rect.Left)/2)*TMapItem(MapListForm.Maps[CurrentMapIndex]).MapInfo.Width*8/100)));
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/StartPosZ',IntToStr(Round((Rect.Top+(Rect.Bottom-Rect.Top)/2)*TMapItem(MapListForm.Maps[CurrentMapIndex]).MapInfo.Height*8/100)));
        end;
      end;
      if (StartPosRadioGroup.ItemIndex < 2) and relayHostScript then
      begin
        with GetMapItem(CurrentMapIndex) do
        begin
          if ((StartPosRadioGroup.ItemIndex = 0) and (NumberOfTeams >= MapInfo.PosCount)) or ((StartPosRadioGroup.ItemIndex = 1) and (startPosIndexes.Count = 0)) then
            raise Exception.Create(_('The map has not enough fixed start position. Please use another start position mode.'));
          if StartPosRadioGroup.ItemIndex = 1 then // random start pos
          begin
            l := RandomRange(0,startPosIndexes.Count-1);
            k := startPosIndexes.Items[l];
            startPosIndexes.Delete(l);
          end
          else
            k := NumberOfTeams;
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/StartPosX',IntToStr(MapInfo.Positions[k].x));
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetTeamNo)+'/StartPosZ',IntToStr(MapInfo.Positions[k].y));
        end;
      end;
      Inc(NumberOfTeams);
    end
    else
    begin
      raise Exception.Create('An AI tries to control an existing team.');
    end;

  Script.AddOrChangeKeyValue('GAME/NumTeams',IntToStr(NumberOfTeams));

  if StartPosRadioGroup.ItemIndex = 2 then
  begin
    for i:=0 to High(BattleState.StartRects) do
      if BattleState.StartRects[i].Enabled then
      begin
        Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/NumAllies','0'); // this number is not important
        Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectLeft',FloatToStr(BattleState.StartRects[i].Rect.Left / 100));
        Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectTop',FloatToStr(BattleState.StartRects[i].Rect.Top / 100));
        Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectRight',FloatToStr(BattleState.StartRects[i].Rect.Right / 100));
        Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectBottom',FloatToStr(BattleState.StartRects[i].Rect.Bottom / 100));
      end;
  end;
  for i:=0 to BattleState.Battle.Clients.Count-1 do
    if TClient(BattleState.Battle.Clients[i]).GetMode = 1 then
      Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(TClient(BattleState.Battle.Clients[i]).GetAllyNo)+'/NumAllies','0');
  for i:=0 to BattleState.Battle.Bots.Count-1 do
    Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(TBot(BattleState.Battle.Bots[i]).GetAllyNo)+'/NumAllies','0');

  // restrictions:
  Script.AddOrChangeKeyValue('GAME/NumRestrictions',IntToStr(BattleState.DisabledUnits.Count));
  for i := 0 to BattleState.DisabledUnits.Count-1 do
  begin
    Script.AddOrChangeKeyValue('GAME/RESTRICT/Unit' + IntToStr(i),BattleState.DisabledUnits[i]);
    Script.AddOrChangeKeyValue('GAME/RESTRICT/Limit' + IntToStr(i),'0');
  end;
  
  // mod options:
  for i:=0 to ModOptionsList.Count -1 do
    if TLuaOption(ModOptionsList[i]).ClassType <> TLuaOptionSection then
      Script.AddOrChangeKeyValue(TLuaOption(ModOptionsList[i]).KeyPrefix + TLuaOption(ModOptionsList[i]).Key,TLuaOption(ModOptionsList[i]).toString);

  // map options:
  for i:=0 to MapOptionsList.Count -1 do
    if TLuaOption(MapOptionsList[i]).ClassType <> TLuaOptionSection then
      Script.AddOrChangeKeyValue(TLuaOption(MapOptionsList[i]).KeyPrefix + TLuaOption(MapOptionsList[i]).Key,TLuaOption(MapOptionsList[i]).toString);

  // bot options:
  for j:=0 to BattleState.Battle.Bots.Count-1 do
    for i:=0 to TBot(BattleState.Battle.Bots[j]).OptionsList.Count -1 do
      if TLuaOption(TBot(BattleState.Battle.Bots[j]).OptionsList[i]).ClassType <> TLuaOptionSection then
        Script.AddOrChangeKeyValue(TLuaOption(TBot(BattleState.Battle.Bots[j]).OptionsList[i]).KeyPrefix + TLuaOption(TBot(BattleState.Battle.Bots[j]).OptionsList[i]).Key,TLuaOption(TBot(BattleState.Battle.Bots[j]).OptionsList[i]).toString);

  // unknown setscripttags
  for i:=0 to UnknownScriptTagList.CompleteKeyList.Count -1 do
    Script.AddOrChangeKeyValue(UnknownScriptTagList.CompleteKeyList[i],UnknownScriptTagList.ValueList[i]);





  //MainForm.AddMainLog(Script.GetBruteScript,Colors.Info);

  // write down the script
  repeat
  try
    AssignFile(f, FileName);
    Rewrite(f);
    Write(f, Script.Script);
    CloseFile(f);
    tryToRewriteScript := False;
    Result := Script;
  except
    Result := nil;
    Script.Free;
    try
      CloseFile(f);
    except
      //
    end;
    tryToRewriteScript := MessageDlg(CANT_WRITE_SCRIPT_MSG,mtError,[mbYes,mbNo],0) = mrYes;
  end;
  until not tryToRewriteScript;
end;

function TBattleForm.GenerateReplayHostScriptFile(FileName: string):TScript;
var
  f: TextFile;
  i: Integer;
  Script: TScript;
  tryToRewriteScript:boolean;
begin
  Script := TScript.Create(BattleReplayInfo.Script);
  //Script.ChangeMyPlayerNum(BattleState.Battle.Clients.IndexOf(Status.Me) + BattleReplayInfo.OriginalClients.Count);
  Script.ChangeNumPlayers(BattleState.Battle.Clients.Count + BattleReplayInfo.OriginalClients.Count);
  if BattleState.Status = Hosting then
    Script.AddOrChangeKeyValue('GAME/Demofile',BattleReplayInfo.Replay.FullFileName)
  else
    Script.AddOrChangeKeyValue('GAME/Demofile','multiplayer replay');


  Script.AddOrChangeKeyValue('GAME/MyPlayerName',Status.Me.Name);
  Script.AddOrChangeKeyValue('GAME/IsHost',BoolToStr(BattleState.Status = Hosting));
  if Script.keyExists('GAME/autohostport') then
    Script.RemoveKey('GAME/autohostport');

  if BattleState.Status = Hosting then
  begin
    Script.ChangeHostIP(GetLocalIP);

    if BattleState.Battle.NATType = 1 then
      Script.ChangeHostPort(IntToStr(NATTraversal.MyPrivateUDPSourcePort))
    else
      Script.ChangeHostPort(IntToStr(BattleState.Battle.Port));
  end
  else
  begin
    Script.ChangeHostIP(BattleState.Battle.IP);
    Script.ChangeHostPort(IntToStr(BattleState.Battle.Port));
  end;

  Script.TryToRemoveUDPSourcePort;
  if not (BattleState.Status = Hosting) then
    case BattleState.Battle.NATType of
    0: ; // use default (system assigned) port
    1: Script.AddOrChangeKeyValue('GAME/SourcePort',IntToStr(NATTraversal.MyPrivateUDPSourcePort));
    2: Script.AddOrChangeKeyValue('GAME/SourcePort',IntToStr(FIRST_UDP_SOURCEPORT + BattleState.Battle.Clients.IndexOf(Status.Me) - 1{skip the host}));
    end; // of case sentence

  for i := 0 to BattleReplayInfo.OriginalClients.Count-1 do
  begin
    Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/IsFromDemo','1');
    Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/Name',Script.ReadKeyValue('GAME/PLAYER'+IntToStr(i)+'/Name')+'_Replay');
  end;
  for i := 0 to BattleState.Battle.Clients.Count-1 do
  begin
    Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(BattleReplayInfo.OriginalClients.Count+i)+'/NAME',TClient(BattleState.Battle.Clients[i]).Name);
    Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(BattleReplayInfo.OriginalClients.Count+i)+'/Spectator','1');
  end;

  // write down the script
  repeat
  try
    AssignFile(f, FileName);
    Rewrite(f);
    Write(f,  Script.Script);
    CloseFile(f);
    tryToRewriteScript := False;
    Result := Script;
  except
    Result := nil;
    Script.Free;
    try
      CloseFile(f);
    except
      //
    end;
    tryToRewriteScript := MessageDlg(CANT_WRITE_SCRIPT_MSG,mtError,[mbYes,mbNo],0) = mrYes;
  end;
  until not tryToRewriteScript;
end;

procedure TBattleForm.FormCreate(Sender: TObject);
var
  i:integer;
  mask: Word;
  pch: TPageControlHost;
  bmpNumber: TBitmap;
begin
  TranslateComponent(self);
  pch := TPageControlHost.Create(BattleMiddlePanel);
  pch.Visible := False;
  pch.ManualDock(BattleMiddlePanel);

  Left := 10;
  Top := 10;
  BattleState.DisabledUnits := TStringList.Create;

  FCurrentMapIndex := -1;
  MapHeight := nil;
  MapMetal := nil;
  ChatActive := False;

  MyTeamNoButton.SpinOptions.MinValue := 1;
  MyTeamNoButton.SpinOptions.MaxValue := MAX_TEAMS;
  MyAllyNoButton.SpinOptions.MinValue := 1;
  MyAllyNoButton.SpinOptions.MaxValue := MAX_TEAMS;
  {ForceAllySpin.MinValue := 1;
  ForceAllySpin.MaxValue := MAX_TEAMS;
  ForceTeamSpin.MinValue := 1;
  ForceTeamSpin.MaxValue := MAX_TEAMS;}

  //Numbers.RowCount := Floor(MAX_TEAMS/10)+1;
  //Numbers.ColCount := Min(10,MAX_TEAMS);
  for i:=1 to MAX_TEAMS do
  begin
    bmpNumber := TBitmap.Create;
    bmpNumber.Width := 16;
    bmpNumber.Height := 16;
    with bmpNumber.Canvas do
    begin
      Brush.Color := clWhite;
      FillRect(ClipRect);
      Font.Color := clBlack;
      Font.Name := 'Arial';
      Font.Size := 7;
      Font.Style := [fsBold];
      TextOut(1,1,IntToStr(i));
    end;
    NumbersImgList.AddMasked(bmpNumber,clWhite);
  end;

  MapPanel.ManualDock(pch.PageControl);
  MapPanel.ManualDock(BattleMiddlePanel,nil,alLeft);
  DockHandler.RegisterSpecialDockClient(MapPanel);
  BattleOptionsPanel.Align := alRight;
  BattleOptionsPanel.ManualDock(pch.PageControl);
  BattleOptionsPanel.ManualDock(BattleMiddlePanel,nil,alRight);
  DockHandler.RegisterSpecialDockClient(BattleOptionsPanel);

  MyOptionsPanel.Align := alRight;
  BattlePlayerListPanel.Align := alClient;
  BattleChatPanel.Align := alBottom;
  MyOptionsPanel.ManualDock(pch.PageControl);
  MyOptionsPanel.ManualDock(BattleMiddlePanel,nil,alBottom);
  DockHandler.RegisterSpecialDockClient(MyOptionsPanel);
  BattlePlayerListPanel.ManualDock(pch.PageControl);
  BattlePlayerListPanel.ManualDock(BattleMiddlePanel,nil,alBottom);
  DockHandler.RegisterSpecialDockClient(BattlePlayerListPanel);
  BattleChatPanel.ManualDock(pch.PageControl);
  BattleChatPanel.ManualDock(BattleMiddlePanel,nil,alBottom);
  DockHandler.RegisterSpecialDockClient(BattleChatPanel);
  //BattleTopPanel.ManualDock(pch.PageControl);


  pch.Free;
  //DockHandler.RegisterDockHost(BattleMiddlePanel);

  InputEdit.Align := alBottom;
  ChatRichEdit.Align := alClient;

  {mask := SendMessage(ChatRichEdit.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(ChatRichEdit.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(ChatRichEdit.Handle, EM_AUTOURLDETECT, Integer(True), 0); }

  MapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
  //ChangeMapToNoMap('Loading...');
  // we will load map list and current map once everything else gets initialized!

  BattleState.JoiningBattle := False;

  BattleState.DrawingStartRect := -1;
  BattleState.MovingStartRect := -1;
  BattleState.ResizingStartRect := -1;
  BattleState.SelectedStartRect := -1;

  MapsTabs.ActiveTabIndex := 0;
  SpTBXTabControl1.ActiveTabIndex := 0;
  ChangeTeamColor(0, False);

  BattleState.DrawingStartRect := -1;
  BattleState.SelectedStartRect := -1;
  BattleState.MovingStartRect := -1;
  BattleState.ResizingStartRect := -1;

  ResetBattleScreen;

  FixFormSizeConstraints(BattleForm);

  if (Screen.Width >= 800) and (Screen.Height >= 600) then
  begin
    BattleForm.Height := 600;
  end;

  History := TWideStringList.Create;
  HistoryIndex := -1;

  BattleReplayInfo.Script := nil;
  BattleReplayInfo.TempScript := TStringList.Create;
  BattleReplayInfo.OriginalClients := TList.Create;

  SortedClientList := TList.Create;
  SortedBotList := TList.Create;
  SortedOriginalList := TList.Create;
  ModOptionsList := TList.Create;
  MapOptionsList := TList.Create;
  UnknownScriptTagList.CompleteKeyList := TStringList.Create;
  UnknownScriptTagList.ValueList := TStringList.Create;

  PreferencesForm.LoadDefaultBattlePreferencesFromRegistry;
  QuickLookHints := TStringList.Create;

  SSProfileButton.Left := Panel3.Width - 118;
end;

procedure TBattleForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  BattleState.Battle := nil;

  for i := 0 to High(BattleState.StartRects) do
  try
    BattleState.StartRects[i].PaintBox.Free;
  except
  end;

  Finalize(BattleState.StartRects);

  History.Free;

  BattleReplayInfo.Script.Free;
  BattleReplayInfo.TempScript.Free;
  FreeReplayClients;
  BattleReplayInfo.OriginalClients.Free;

end;

function TBattleForm.isBattleReadyToStart: Boolean;
begin
  Result := (BattleState.Battle <> nil) and BattleState.Battle.AreAllClientsReady and BattleState.Battle.AreAllClientsSynced and (BattleState.Status = Hosting);
end;

procedure TBattleForm.StartButtonClick(Sender: TObject);
var
  res: Integer;
  i: integer;
  scriptGenerationResult: TScript;
  sl:TStringList;
  startTime : TDateTime;
  nextScriptLine : string;
  sendSpeed: Extended;
begin
  if not isBattleReadyToStart then
  begin
    StartButton.Enabled := False;
    if not LobbyScriptUnit.ScriptStart then MessageDlg(_('The battle is not ready to start!'), mtInformation, [mbOK], 0);
    Exit;
  end;

  if not BattleState.Battle.AreAllBotsSet then
  begin
    if not LobbyScriptUnit.ScriptStart then MessageDlg(_('Two or more bots share the same team number. Please change that!'), mtInformation, [mbOK], 0);
    Exit;
  end;

  if BattleState.Battle.Clients.Count > MAX_PLAYERS then
  begin
    if not LobbyScriptUnit.ScriptStart then MessageDlg(_('Too many players (spring supports up to ') + IntToStr(MAX_PLAYERS) + _(' players)!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if BattleState.Battle.BattleType = 1 then // we're hosting an online replay
    if BattleReplayInfo.OriginalClients.Count + BattleState.Battle.Clients.Count > MAX_PLAYERS then
    begin
      if not LobbyScriptUnit.ScriptStart then MessageDlg(_('Too many players (spring supports up to ') + IntToStr(MAX_PLAYERS) + _(' players, original players from the demo included)!'), mtWarning, [mbOK], 0);
      Exit;
    end;

  if StartPosRadioGroup.ItemIndex = 3 then
  begin
    for i:=0 to BattleState.Battle.Clients.Count-1 do
      if (TClient(BattleState.Battle.Clients[i]).GetMode = 1) and (not BattleState.StartRects[TClient(BattleState.Battle.Clients[i]).GetTeamNo].Enabled) then
      begin
        MessageDlg(Format(_('The player''s start position is not set (%s). Pick another start position mode or make the corresponding box.'),[TClient(BattleState.Battle.Clients[i]).Name]),mtWarning,[mbOK],0);
        Exit;
      end;
    for i:=0 to BattleState.Battle.Bots.Count-1 do
      if not BattleState.StartRects[TBot(BattleState.Battle.Bots[i]).GetTeamNo].Enabled then
      begin
        MessageDlg(Format(_('The bot''s start position is not set (%s). Pick another start position mode or make the corresponding box.'),[TBot(BattleState.Battle.Bots[i]).Name]),mtWarning,[mbOK],0);
        Exit;
      end;
  end;

  if BattleState.Battle.NATType = 1 then  // "hole punching" method
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

  if (BattleState.Status = Hosting) and (HostBattleForm.relayHoster <> nil) then
  begin
    scriptGenerationResult := GenerateNormalHostScriptFile(ExtractFilePath(Application.ExeName) + 'script.txt',True);
    if scriptGenerationResult = nil then
      Exit;
    sl := TStringList.Create;
    ParseDelimited(sl,scriptGenerationResult.Script,EOL,'');
    MainForm.TryToSendCommand('SAYPRIVATE',HostBattleForm.relayHoster.Name+' !cleanscript');
    StartProgressBar.Left := StartButton.Left;
    StartProgressBar.Top := StartButton.Top;
    StartProgressBar.Width := StartButton.Width;
    StartProgressBar.Height := StartButton.Height;
    StartProgressBar.Min := 0;
    StartProgressBar.Max := sl.Count-1;
    StartButton.Visible := False;
    StartProgressBar.Visible := True;

    startTime := Now;
    for i:=0 to sl.Count-1 do
    begin
      StartProgressBar.Position := i;
      StartProgressBar.Refresh;
      nextScriptLine := 'SAYPRIVATE '+HostBattleForm.relayHoster.Name+' !appendscriptline '+sl[i];
      if Length(nextScriptLine) < 1024 then
      begin
        while Status.CumulativeDataSent+Length(nextScriptLine)-Status.CumulativeDataSentHistory.Items[0] > FLOODLIMIT_BYTESPERSECOND*FLOODLIMIT_SECONDS do
        begin
          Application.ProcessMessages;
          Sleep(10);
        end;
        Application.ProcessMessages;
        MainForm.TryToSendCommand('SAYPRIVATE',HostBattleForm.relayHoster.Name+' !appendscriptline '+sl[i]);
      end
      else
      begin
        Application.ProcessMessages;
        MainForm.AddMainLog(_('A start script line could not be sent to the server because it exceeded the maximum allowed line size. The hosting may not work properly.'),Colors.Error);
      end;
    end;
    StartButton.Visible := True;
    StartProgressBar.Visible := False;
    MainForm.TryToSendCommand('SAYPRIVATE',HostBattleForm.relayHoster.Name+' !redirectspring 1');
    MainForm.TryToSendCommand('SAYPRIVATE',HostBattleForm.relayHoster.Name+' !startgame');
    sl.Free;
  end
  else
    PostMessage(BattleForm.Handle, WM_STARTGAME, 0, 0);
end;

procedure TBattleForm.HostButtonClick(Sender: TObject);
begin
  if not MainForm.AreWeLoggedIn then
  begin
    MessageDlg('You must first log on to the server!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if CurrentMapIndex = -1 then ChangeMap(0); // select first map in a list if none is currently selected

  ReplaysForm.Close;

  if HostBattleForm.btRefreshRelayManagersList.Enabled and (MainForm.GetClient(RELAYHOST_MANAGER_NAME) <> nil) then
  begin
    HostBattleForm.btRefreshRelayManagersListClick(nil);
  end;
  HostBattleForm.ShowModal;
end;

procedure TBattleForm.MapImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tmp,startBoxHalfWidth,startBoxHalfHeight: Integer;
  url: string;
  heightMap: TBitmap;
  texture: TBitmap;
  textureMetal: TBitmap;
  linePixels1,linePixels2 : pColorData;
  comp1,comp2: integer;
  i,j: integer;
  heightMapLine : pByteArray;
begin
  if Button <> mbLeft then Exit;
  if CurrentMapIndex = -1 then // user does not have this map
  begin
    if BattleState.Status = Joined then
        DownloadMapButtonClick(nil);
    Exit;
  end;
  X := Round(100*X/MapImage.Width);
  Y := Round(100*Y/MapImage.Height);

  if (TImage(Sender).Cursor = crCross) and (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) then
  begin
    tmp := GetFirstMissingStartRect;
    if tmp > High(BattleState.StartRects) then Exit;

    if StartPosRadioGroup.ItemIndex = 3 then
    begin
      with GetMapItem(CurrentMapIndex) do
      begin
        startBoxHalfWidth := 4;
        startBoxHalfHeight := 3;
        if MapInfo.Width/MapInfo.Height > 1 then
          startBoxHalfWidth := Round(startBoxHalfWidth*MapInfo.Height/MapInfo.Width)
        else
          startBoxHalfHeight := Round(startBoxHalfHeight*MapInfo.Width/MapInfo.Height);
      end;

      AddStartRect(tmp, Rect(X-startBoxHalfWidth,Y-startBoxHalfHeight ,X+startBoxHalfWidth, Y+startBoxHalfHeight));

      RefreshStartRectsPosAndSize;
      NormalizeRect(BattleState.StartRects[tmp].Rect);

      // notify everyone about new startrect:
      if StartPosRadioGroup.ItemIndex < 2 then
        StartPosRadioGroup.ItemIndex := 2; // automatically switch to "Choose in game" startpos

      with BattleState.StartRects[tmp] do
        MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(tmp) + ' ' + IntToStr(Rect.Left*2) + ' ' + IntToStr(Rect.Top*2) + ' ' + IntToStr(Rect.Right*2) + ' ' + IntToStr(Rect.Bottom*2) + ' ');    // *2 because the start rect is in % (0->100) and the old system was in pixel with a 200x200 minimap
      Exit;  
    end
    else
    begin
      BattleState.DrawingStartRect := tmp;

      AddStartRect(tmp, Rect(X,Y ,X, Y));

      Exit;
    end;
  end;

  if (BattleState.SelectedStartRect > -1) and (TImage(Sender).Cursor = crSizeAll) and (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) then
  begin
    BattleState.MovingStartRect := BattleState.SelectedStartRect;
    BattleState.MovingX := X;
    BattleState.MovingY := Y;
    Exit;
  end;

  if (BattleState.SelectedStartRect > -1) and (BattleState.ResizingDirection > 0) and (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) then
  begin
    BattleState.ResizingStartRect := BattleState.SelectedStartRect;
    BattleState.ResizingY := 0;
    BattleState.ResizingX := 0;
    if (BattleState.ResizingDirection and 1) = 1 then
      BattleState.ResizingX := X-BattleState.StartRects[BattleState.SelectedStartRect].Rect.Left;
    if (BattleState.ResizingDirection and 2) = 2 then
      BattleState.ResizingY := Y-BattleState.StartRects[BattleState.SelectedStartRect].Rect.Top;
    if (BattleState.ResizingDirection and 4) = 4 then
      BattleState.ResizingX := X-BattleState.StartRects[BattleState.SelectedStartRect].Rect.Right;
    if (BattleState.ResizingDirection and 8) = 8 then
      BattleState.ResizingY := Y-BattleState.StartRects[BattleState.SelectedStartRect].Rect.Bottom;
    Exit;
  end;

  if (BattleState.SelectedStartRect > -1) and BattleForm.IsBattleActive then
  begin
    MyAllyNoButton.SpinOptions.ValueAsInteger := BattleState.SelectedStartRect+1;
    if not IsBattleActive then Exit;
    SendMyBattleStatusToServer;
    Exit;
  end;

  // open larger minimap:
  MinimapZoomedForm.UpdateMinimap(TImage(Sender));

  // 3d minimap
  if Preferences.LoadMetalHeightMinimaps and not MainUnit.NO3D then
  begin
    Application.CreateForm(TMinimap3DPreview, Minimap3DPreview);
    if SkinManager.GetSkinType <> sknSkin then
      Minimap3DPreview.SpTBXTitleBar1.Active := False;
    Minimap3DPreview.UpdateMiniMap(GetMapItem(CurrentMapIndex),HeightMapImage.Picture.Bitmap,MinimapZoomedForm.Image1.Picture.Bitmap,MetalMapImage.Picture.Bitmap,Sender = MetalMapImage);
    Minimap3DPreview.Caption := MinimapZoomedForm.Caption;
    Minimap3DPreview.SpTBXTitleBar1.Caption := Minimap3DPreview.Caption;
    Minimap3DPreview.ShowModal;
    Minimap3DPreview.Free;
    Minimap3DPreview := nil;
  end
  else
  begin
    MinimapZoomedForm.ShowModal;
  end;
end;

procedure TBattleForm.MapImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
begin

  for i:=0 to High(BattleState.StartRects) do
    if BattleState.StartRects[i].Enabled then
      BattleState.StartRects[i].PaintBox.Parent := TImage(Sender).Parent;

  X := Round(100*X/TImage(Sender).Width);
  Y := Round(100*Y/TImage(Sender).Height);
  if ssShift in Shift then
  begin
    if (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) then
    begin
      TImage(Sender).Cursor := crCross;
    end;
  end
  else
    if (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) and ((ssCtrl in Shift) or ((StartPosRadioGroup.ItemIndex = 3) and (BattleState.SelectedStartRect <> -1)))  then
      TImage(Sender).Cursor := crSizeAll
    else
      if (BattleState.ResizingStartRect = -1) and (BattleState.Status = Hosting) then
      if (BattleState.SelectedStartRect <> -1) then begin
        BattleState.ResizingDirection := 0;
        if (X >= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Left-2) and (X <= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Left + 2) then begin
          BattleState.ResizingDirection := BattleState.ResizingDirection + 1;
        end;
        if (X >= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Right-2) and (X <= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Right+2) then begin
          BattleState.ResizingDirection := BattleState.ResizingDirection + 4;
        end;
        if (Y >= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Top-2) and (Y <= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Top + 2) then begin
          BattleState.ResizingDirection := BattleState.ResizingDirection + 2;
        end;
        if (Y >= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Bottom-2) and (Y <= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Bottom+2) then begin
          BattleState.ResizingDirection := BattleState.ResizingDirection + 8;
        end;
        if (BattleState.ResizingDirection = 1) or (BattleState.ResizingDirection = 4) then
          TImage(Sender).Cursor := crSizeWE
        else
          if (BattleState.ResizingDirection = 2) or (BattleState.ResizingDirection = 8) then
            TImage(Sender).Cursor := crSizeNS
          else
            if (BattleState.ResizingDirection = 3) or (BattleState.ResizingDirection = 12) then
              TImage(Sender).Cursor := crSizeNWSE
            else
              if (BattleState.ResizingDirection = 6) or (BattleState.ResizingDirection = 9) then
                TImage(Sender).Cursor := crSizeNESW
              else
                TImage(Sender).Cursor := crHandPoint;
      end
      else
        TImage(Sender).Cursor := crHandPoint
      else
        TImage(Sender).Cursor := crHandPoint;

  if BattleState.DrawingStartRect <> -1 then
  begin
    ChangeStartRect(BattleState.DrawingStartRect, Rect(BattleState.StartRects[BattleState.DrawingStartRect].Rect.Left, BattleState.StartRects[BattleState.DrawingStartRect].Rect.Top, X, Y));
  end
  else
  begin
    if BattleState.MovingStartRect <> -1 then begin
      ChangeStartRect(BattleState.MovingStartRect, Rect(BattleState.StartRects[BattleState.MovingStartRect].Rect.Left+X-BattleState.MovingX, BattleState.StartRects[BattleState.MovingStartRect].Rect.Top+Y-BattleState.MovingY, BattleState.StartRects[BattleState.MovingStartRect].Rect.Right+X-BattleState.MovingX, BattleState.StartRects[BattleState.MovingStartRect].Rect.Bottom+Y-BattleState.MovingY),True);
      BattleState.MovingX := X;
      BattleState.MovingY := Y;
    end
    else
      if BattleState.ResizingStartRect <> -1 then begin
        if (BattleState.ResizingDirection and 1) = 1 then
          ChangeStartRect(BattleState.ResizingStartRect, Rect(X-BattleState.ResizingX, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Top, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Right, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Bottom));
        if (BattleState.ResizingDirection and 2) = 2 then
          ChangeStartRect(BattleState.ResizingStartRect, Rect(BattleState.StartRects[BattleState.ResizingStartRect].Rect.Left, Y-BattleState.ResizingY, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Right, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Bottom));
        if (BattleState.ResizingDirection and 4) = 4 then
          ChangeStartRect(BattleState.ResizingStartRect, Rect(BattleState.StartRects[BattleState.ResizingStartRect].Rect.Left, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Top, X-BattleState.ResizingX, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Bottom));
        if (BattleState.ResizingDirection and 8) = 8 then
          ChangeStartRect(BattleState.ResizingStartRect, Rect(BattleState.StartRects[BattleState.ResizingStartRect].Rect.Left, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Top, BattleState.StartRects[BattleState.ResizingStartRect].Rect.Right, Y-BattleState.ResizingY));
      end;
      SetSelectedStartRect(GetStartRectAtPos(X, Y));
  end;
end;

procedure TBattleForm.MapImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if BattleState.DrawingStartRect <> -1 then
  begin
    with BattleState.StartRects[BattleState.DrawingStartRect].Rect do
    begin
      if (Abs(Right - Left) < 5) or (Abs(Bottom - Top) < 5) then
      begin // let's cancel the startrect, since it's too small
        RemoveStartRect(BattleState.DrawingStartRect);
        BattleState.DrawingStartRect := -1;
        Exit;
      end;

    end;
    RefreshStartRectsPosAndSize;
    NormalizeRect(BattleState.StartRects[BattleState.DrawingStartRect].Rect);

    // notify everyone about new startrect:
    if BattleState.Status = Hosting then
    begin
      if StartPosRadioGroup.ItemIndex < 2 then
        StartPosRadioGroup.ItemIndex := 2; // automatically switch to "Choose in game" startpos

      with BattleState.StartRects[BattleState.DrawingStartRect] do
        MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(BattleState.DrawingStartRect) + ' ' + IntToStr(Rect.Left*2) + ' ' + IntToStr(Rect.Top*2) + ' ' + IntToStr(Rect.Right*2) + ' ' + IntToStr(Rect.Bottom*2) + ' ');    // *2 because the start rect is in % (0->100) and the old system was in pixel with a 200x200 minimap
    end;


    BattleState.DrawingStartRect := -1;
  end;
  if BattleState.MovingStartRect <> -1 then
  begin
    with BattleState.StartRects[BattleState.MovingStartRect].Rect do
    begin
      if ((Abs(Right - Left) < 3) or (Abs(Bottom - Top) < 3)) and (StartPosRadioGroup.ItemIndex  < 3) then
      begin // let's cancel the startrect, since it's too small
        RemoveStartRect(BattleState.MovingStartRect);
        MainForm.TryToSendCommand('REMOVESTARTRECT', IntToStr(BattleState.MovingStartRect));
        BattleState.MovingStartRect := -1;
        Exit;
      end;

    end;
    NormalizeRect(BattleState.StartRects[BattleState.MovingStartRect].Rect);
    MainForm.TryToSendCommand('REMOVESTARTRECT', IntToStr(BattleState.MovingStartRect));
    with BattleState.StartRects[BattleState.MovingStartRect] do
      MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(BattleState.MovingStartRect) + ' ' + IntToStr(Rect.Left*2) + ' ' + IntToStr(Rect.Top*2) + ' ' + IntToStr(Rect.Right*2) + ' ' + IntToStr(Rect.Bottom*2) + ' ');    // *2 because the start rect is in % (0->100) and the old system was in pixel with a 200x200 minimap
    BattleState.MovingStartRect := -1;
  end;
  if BattleState.ResizingStartRect <> -1 then
  begin
    with BattleState.StartRects[BattleState.ResizingStartRect].Rect do
    begin
      if (Abs(Right - Left) < 5) or (Abs(Bottom - Top) < 5) then
      begin // let's cancel the startrect, since it's too small
        RemoveStartRect(BattleState.ResizingStartRect);
        MainForm.TryToSendCommand('REMOVESTARTRECT', IntToStr(BattleState.ResizingStartRect));
        BattleState.ResizingStartRect := -1;
        Exit;
      end;

    end;
    NormalizeRect(BattleState.StartRects[BattleState.ResizingStartRect].Rect);
    MainForm.TryToSendCommand('REMOVESTARTRECT', IntToStr(BattleState.ResizingStartRect));
    with BattleState.StartRects[BattleState.ResizingStartRect] do
      MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(BattleState.ResizingStartRect) + ' ' + IntToStr(Rect.Left*2) + ' ' + IntToStr(Rect.Top*2) + ' ' + IntToStr(Rect.Right*2) + ' ' + IntToStr(Rect.Bottom*2) + ' ');    // *2 because the start rect is in % (0->100) and the old system was in pixel with a 200x200 minimap
    BattleState.ResizingStartRect := -1;
  end;
end;

procedure TBattleForm.ResetStartRects;
var
  i: Integer;
begin

  if not (Length(BattleState.StartRects) = 0) then // first initialization
    SetSelectedStartRect(-1);

  for i := 0 to High(BattleState.StartRects) do
  begin
    try
      BattleState.StartRects[i].PaintBox.Free;
    except
    end;
  end;

  Finalize(BattleState.StartRects);
  SetLength(BattleState.StartRects, 16); // there can be 10 ally teams at maximum

  for i := 0 to High(BattleState.StartRects) do
    BattleState.StartRects[i].Enabled := False;

end;

procedure TBattleForm.StartRectPaintBoxPaint(Sender: TObject);
var
  s: string;
  i,j: integer;
  metal: int64;
begin
  with (Sender as TPaintBox), (Sender as TPaintBox).Canvas do
  begin

    Brush.Style := bsSolid;
    if (BattleState.SelectedStartRect = (Sender as TPaintBox).Tag) and (BattleState.ResizingStartRect =-1) and (BattleState.MovingStartRect =-1) then
    begin
      Pen.Mode := pmCopy;
      Font.Color := clBlue;
      Brush.Color := $00ffeeee; { 0 b g r }
      Pen.Color := clRed;
    end
    else
    begin
      Pen.Mode := pmMergeNotPen;
      Font.Color := clWhite;
      Brush.Color := $0000FFFF; { 0 b g r }
      Pen.Color := clRed;
    end;
    Rectangle((Sender as TPaintBox).ClientRect);

    metal := 0;
    s := IntToStr((Sender as TPaintBox).Tag + 1);
    if (TotalMetal>0) and Preferences.LoadMetalHeightMinimaps and (StartPosRadioGroup.ItemIndex < 3) then
    begin
      for i:=Round(BattleState.StartRects[(Sender as TPaintBox).Tag].Rect.Top*MapMetalHeight/100) to Round(BattleState.StartRects[(Sender as TPaintBox).Tag].Rect.Bottom*MapMetalHeight/100)-1 do
        for j:=Round(BattleState.StartRects[(Sender as TPaintBox).Tag].Rect.Left*MapMetalWidth/100)+1 to Round(BattleState.StartRects[(Sender as TPaintBox).Tag].Rect.Right*MapMetalWidth/100) do
          metal := metal + Ord(MapMetal[i*MapMetalWidth+j]);

      s := s + '/M='+FloatToStr(RoundTo(metal*100/TotalMetal,-1))+'%';
    end;
    
    Brush.Style := bsClear;
    Font.Style := [fsBold];
    
    TextOut(Width div 2 - TextWidth(s) div 2, Height div 2 - TextHeight(s) div 2, s);
  end;

end;

function TBattleForm.GetFirstMissingStartRect: Integer;
var
  i: Integer;
begin
  for i := 0 to High(BattleState.StartRects) do
    if BattleState.StartRects[i].Enabled = False then
    begin
      Result := i;
      Exit;
    end;
  Result := High(BattleState.StartRects) + 1;

end;

procedure TBattleForm.AddStartRect(Index: Integer; Rect: TRect);
begin
  if Index > High(BattleState.StartRects) then Exit; // this should not happen!
  if Index < 0 then Exit; // this should not happen!
  if BattleState.StartRects[Index].Enabled then Exit; // this should not happen!

  BattleState.StartRects[Index].Enabled := True;
  BattleState.StartRects[Index].Rect := Rect;
  BattleState.StartRects[Index].PaintBox := TPaintBox.Create(MetalMapPanel);
  BattleState.StartRects[Index].PaintBox.Enabled := False;
  BattleState.StartRects[Index].PaintBox.Tag := Index;
  BattleState.StartRects[Index].PaintBox.OnPaint := StartRectPaintBoxPaint;
  BattleState.StartRects[Index].PaintBox.Left := MapImage.Left+Round(MapImage.Width*(Rect.Left/100));
  BattleState.StartRects[Index].PaintBox.Top := MapImage.Top+Round(MapImage.Height*(Rect.Top/100));
  BattleState.StartRects[Index].PaintBox.Width := Round(MapImage.Width*(Rect.Right - Rect.Left)/100);
  BattleState.StartRects[Index].PaintBox.Height := Round(MapImage.Height*(Rect.Bottom - Rect.Top)/100);
  BattleState.StartRects[Index].PaintBox.Parent := MetalMapPanel;

  if MapsTabs.ActiveTabIndex = 0 then
    BattleState.StartRects[Index].PaintBox.Parent := MapImage.Parent
  else if MapsTabs.ActiveTabIndex = 1 then
    BattleState.StartRects[Index].PaintBox.Parent := MetalMapImage.Parent
  else if MapsTabs.ActiveTabIndex = 2 then
    BattleState.StartRects[Index].PaintBox.Parent := HeightMapImage.Parent;

  RearrangeStartRects;
end;

procedure TBattleForm.RefreshStartRectsPosAndSize;
var
  i: integer;
begin
  for i:=0 to High(BattleState.StartRects) do
  if BattleState.StartRects[i].Enabled then
  begin
    BattleState.StartRects[i].PaintBox.Left := MapImage.Left+Round(MapImage.Width*(BattleState.StartRects[i].Rect.Left/100));
    BattleState.StartRects[i].PaintBox.Top := MapImage.Top+Round(MapImage.Height*(BattleState.StartRects[i].Rect.Top/100));
    BattleState.StartRects[i].PaintBox.Width := Round(MapImage.Width*(BattleState.StartRects[i].Rect.Right - BattleState.StartRects[i].Rect.Left)/100);
    BattleState.StartRects[i].PaintBox.Height := Round(MapImage.Height*(BattleState.StartRects[i].Rect.Bottom - BattleState.StartRects[i].Rect.Top)/100);
    BattleState.StartRects[i].PaintBox.Repaint;
  end;
end;

// rearranges start rects paintboxes in a way that first box is drawn first, then seconds one, etc.
procedure TBattleForm.RearrangeStartRects;
var
  i: Integer;
begin
  try
    for i := 0 to High(BattleState.StartRects) do if BattleState.StartRects[i].Enabled then BattleState.StartRects[i].PaintBox.BringToFront;
  except
  end;
end;

procedure TBattleForm.RemoveStartRect(Index: Integer);
begin
  if BattleState.SelectedStartRect = Index then SetSelectedStartRect(-1);

  BattleState.StartRects[Index].Enabled := False;
  try
    BattleState.StartRects[Index].PaintBox.Free;
  except
  end;
end;

procedure TBattleForm.ChangeStartRect(Index: Integer; Rect: TRect; limit2: Boolean = False);
var
  R:TRect;
begin
  R.Left := 0;
  R.Right := 100;
  R.Top :=0;
  R.Bottom := 100;
  if limit2 then
    LimitRect2(Rect,R)
  else
    LimitRect(Rect,R);
  BattleState.StartRects[Index].Rect := Rect;

  NormalizeRect(Rect);

  try
    BattleState.StartRects[Index].PaintBox.Left := MapImage.Left+Round(MapImage.Width*(Rect.Left/100));
    BattleState.StartRects[Index].PaintBox.Top := MapImage.Top+Round(MapImage.Height*(Rect.Top/100));
    BattleState.StartRects[Index].PaintBox.Width := Round(MapImage.Width*(Rect.Right - Rect.Left)/100);
    BattleState.StartRects[Index].PaintBox.Height := Round(MapImage.Height*(Rect.Bottom - Rect.Top)/100);
  except
    MainForm.AddMainLog('Error: ChangeStartRect method raised an exception. Please report this error!', Colors.Error);
  end;
end;

procedure TBattleForm.SetSelectedStartRect(Index: Integer);
var
  tmp: Integer;
begin
  tmp := BattleState.SelectedStartRect;
  BattleState.SelectedStartRect := Index;

  if (tmp <> -1) and (Index <> tmp) then if BattleState.StartRects[tmp].Enabled then
  begin
    try
      BattleState.StartRects[tmp].PaintBox.Repaint;
    except
    end;
  end;

  if (BattleState.SelectedStartRect <> -1) and (Index <> tmp) then if BattleState.StartRects[BattleState.SelectedStartRect].Enabled then
  begin
    try
      BattleState.StartRects[BattleState.SelectedStartRect].PaintBox.Repaint;
    except
    end;
  end;

end;

function TBattleForm.GetStartRectAtPos(x, y: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := High(BattleState.StartRects) downto 0 do
    if BattleState.StartRects[i].Enabled then if PointInRect(BattleState.StartRects[i].Rect, Point(x, y)) then
    begin
      Result := i;
      Exit;
    end;
end;

function TBattleForm.IsMouseOverMapImage: Boolean;
var
  p: TPoint;
begin
  GetCursorPos(p);
  p := MapImage.ScreenToClient(p);
  Result := PointInRect(MapImage.ClientRect, p);
end;

procedure TBattleForm.OnNumberPressedOverStartRect(Number: Byte);
var
  tmpRect: TRect;
  tmp: Integer;
begin
  if BattleState.SelectedStartRect = -1 then Exit; // this should never happen!

  if ((Number < 0) or (Number > 9)) then Exit;
  if Number = 0 then Number := 10;
  Dec(Number);

  if Number = BattleState.SelectedStartRect then
  begin
    Beep;
    Exit;
  end;

  if BattleState.StartRects[Number].Enabled then
  begin
    Beep;
    Exit;
  end;

  tmpRect := BattleState.StartRects[BattleState.SelectedStartRect].Rect;
  tmp := BattleState.SelectedStartRect;
  RemoveStartRect(BattleState.SelectedStartRect);
  AddStartRect(Number, tmpRect);
  // notify all about the change:
  if BattleState.Status = Hosting then
  begin
    MainForm.TryToSendCommand('REMOVESTARTRECT', IntToStr(tmp));
    with BattleState.StartRects[Number] do
      MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(Number) + ' ' + IntToStr(Rect.Left*2) + ' ' + IntToStr(Rect.Top*2) + ' ' + IntToStr(Rect.Right*2) + ' ' + IntToStr(Rect.Bottom*2) + ' ');
  end;

end;

procedure TBattleForm.OnDeletePressedOverStartRect;
var
  tmp: Integer;
begin
  if BattleState.SelectedStartRect = -1 then Exit; // this should never happen!

  tmp := BattleState.SelectedStartRect;
  RemoveStartRect(BattleState.SelectedStartRect);
  if BattleState.Status = Hosting then
    MainForm.TryToSendCommand('REMOVESTARTRECT', IntToStr(tmp));
end;

procedure TBattleForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (BattleState.Status = Hosting) or (BattleState.Status = Joined) then
  begin
    if AutoJoinForm.chkStopAutoJoinWhenLeaving.Checked then
    begin
      MainForm.mnuAutoplayFirstAvailable.Checked := False;
      MainForm.mnuAutospecFirstAvailable.Checked := False;
    end;
    DisconnectButton.OnClick(nil);
  end;
end;

procedure TBattleForm.DisconnectButtonClick;
begin
  DisconnectButtonClick(nil);
end;
procedure TBattleForm.DisconnectButtonClick(Sender: TObject);
begin
  if BattleState.Status = None then Exit;

  if (BattleState.Status = Joined) or (BattleState.Status = Hosting) then
  begin
    if AutoJoinForm.chkStopAutoJoinWhenLeaving.Checked and (Sender = DisconnectButton) then
    begin
      MainForm.mnuAutoplayFirstAvailable.Checked := False;
      MainForm.mnuAutospecFirstAvailable.Checked := False;
    end;
    MainForm.TryToSendCommand('LEAVEBATTLE');
    ResetBattleScreen;
  end;

  Utility.ReInitLib;
  BattleState.Status := None;
end;

procedure TBattleForm.StartPosRadioGroupClick(Sender: TObject);
begin
  //if (HostBattleForm.relayHoster <> nil) and (StartPosRadioGroup.ItemIndex < 2) then StartPosRadioGroup.ItemIndex := 2;

  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/StartPosType='+IntToStr(StartPosRadioGroup.ItemIndex));

  if StartPosRadioGroup.ItemIndex = 3 then
    mnuClearBoxesClick(nil);

  RefreshStartRectsPosAndSize;
end;

{ GameTimer is a timer which we enable when we run spring.exe waiting for it to terminate.
  See also: http://www.latiumsoftware.com/en/delphi/00003.php }
procedure TBattleForm.GameTimerTimer(Sender: TObject);
begin
  GameTimer.Enabled := False;
  if GetExitCodeProcess(BattleState.Process.proc_info.hProcess, BattleState.Process.ExitCode)
  then
    if BattleState.Process.ExitCode = STILL_ACTIVE then
      GameTimer.Enabled := True
    else
    begin
      AddTextToChat('Back from the game', Colors.Info, 1);
      MainForm.SpringSocket.Active := False;
      if (BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil) then
      begin
        JoinButton.Visible := False;
        StartButton.Visible := True;
      end;
      if (HostBattleForm.relayHoster <> nil) and HostBattleForm.relayHoster.GetInGameStatus then
        AddTextToChat('(You can force the autohost to stop the game using /forcequit)', Colors.Info, 1);
      Status.AmIInGame := False;
      MainForm.TryToSendCommand('MYSTATUS', '0'); // let's tell the server we returned from the game

      CloseHandle(BattleState.Process.proc_info.hProcess);
      AcquireMainThread;
      try if not Preferences.ScriptsDisabled then handlers.onBackFromGame(); except end;
      ReleaseMainThread;
      UploadReplay;
    end
  else
  begin
    AddTextToChat('Back from the game', Colors.Info, 1);
    MainForm.SpringSocket.Active := False;
    if (BattleState.Status = Hosting) and (HostBattleForm.relayHoster = nil) then
    begin
      JoinButton.Visible := False;
      StartButton.Visible := True;
    end;
    Status.AmIInGame := False;
    MainForm.TryToSendCommand('MYSTATUS', '0'); // let's tell the server we returned from the game

    TerminateProcess(BattleState.Process.proc_info.hProcess, 0);
    CloseHandle(BattleState.Process.proc_info.hProcess);
    AcquireMainThread;
    try if not Preferences.ScriptsDisabled then handlers.onBackFromGame(); except end;
    ReleaseMainThread;
    UploadReplay;
  end;
end;

procedure TBattleForm.UploadReplay;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  rep: TReplay;
  s,su: string;
  FileName : string;
  i,j:integer;
begin
  if not Preferences.UploadReplay or (BattleState.Battle.BattleType=1) then
  begin
    Exit;
  end;

  FileAttrs := faAnyFile;

  if FindFirst(ExtractFilePath(Application.ExeName) + 'demos\*.sdf', FileAttrs, sr) = 0 then
  begin
    if (sr.Name <> '.') and (sr.Name <> '..') then
    begin
      FileName := ExtractFilePath(Application.ExeName) + 'Demos\' + sr.Name;
    end;

    while FindNext(sr) = 0 do
      if (sr.Name <> '.') and (sr.Name <> '..') and (FileAge(FileName) < FileAge(ExtractFilePath(Application.ExeName) + 'Demos\' + sr.Name)) then
      begin
        FileName := ExtractFilePath(Application.ExeName) + 'Demos\' + sr.Name;
      end;

    FindClose(sr);
  end;

  if (Now-FileDateToDateTime(FileAge(FileName)))*86400 > 5 then Exit; // the file isn't the replay we're looking for

  if UploadReplayForm.Visible then UploadReplayForm.Close;

  UploadReplayForm.FileName := FileName;

  UploadReplayForm.UploadedReplayId := '';
  UploadReplayForm.AutoUpload := True;

  UploadReplayForm.ShowModal;
end;

procedure TBattleForm.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Key := #0; // To avoid that annoying noise when pressing #13 key (RETURN/ENTER key)
  if Key = #27 then Key := #0; // To avoid that annoying noise when pressing #27 key (ESCAPE key)
end;

procedure TBattleForm.InputEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: WideString;
  msgLines : TWideStringList;
  i : integer;
begin
  BattleForm.ChatActive := True;
  if Key = 13 then
  begin
    msgLines := TWideStringList.Create;
    for i := 0 to (Sender as TTntMemo).Lines.Count-1 do
      msgLines.Add((Sender as TTntMemo).Lines.Strings[i]);
    s := (Sender as TTntMemo).Text;
    (Sender as TTntMemo).Text := '';
    if s = '' then Exit;

    History.Add(msgLines.Text);
    HistoryIndex := History.Count;

    if (s[1] = '/') or (s[1] = '.') then
    begin
      MainForm.ProcessCommand(Copy(s, 2, Length(s)-1), True);
      Exit;
    end;

    if IsBattleActive then
      if (msgLines.Count <= 10) or (MessageDlg(_('You are about to send a ')+IntToStr(msgLines.Count)+ _(' lines message.')+EOL+EOL+_('Do you really want to send it ?'),mtConfirmation,[mbYes,mbNo],0) = mrYes) then
        for i:=0 to msgLines.Count-1 do
          MainForm.TryToSendCommand('SAYBATTLE',msgLines[i]);
  end
  else if Key = VK_UP then
  begin
    if History.Count = 0 then Exit;
    HistoryIndex := Max(0, HistoryIndex - 1);
    (Sender as TTntMemo).Text := History[HistoryIndex];
    (Sender as TTntMemo).SelStart := Length((Sender as TTntMemo).Text);
    Key := 0;
  end
  else if Key = VK_DOWN then
  begin
    if History.Count = 0 then Exit;
    HistoryIndex := Min(History.Count-1, HistoryIndex + 1);
    (Sender as TTntMemo).Text := History[HistoryIndex];
    (Sender as TTntMemo).SelStart := Length((Sender as TTntMemo).Text);
    Key := 0;
  end
  else if Key = VK_ESCAPE then
  begin
    (Sender as TTntMemo).Text := '';
    Key := 0;
  end;

  if Key <> VK_TAB then
    InputEdit.Tag := 0;

end;

procedure TBattleForm.SpectateCheckBoxClick(Sender: TObject);
begin
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

procedure TBattleForm.GameEndRadioGroupClick(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  if not GameEndRadioGroup.Visible then Exit;

  if not BattleState.JoiningComplete then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/modoptions/GameMode='+IntToStr(GameEndRadioGroup.ItemIndex));
end;

{ if UpdateServer=True, then we notify server about new team color }
procedure TBattleForm.ChangeTeamColor(ColorIndex: Integer; UpdateServer: Boolean);
begin
  MyTeamColorIndex := ColorIndex;

  TeamColorSpeedButton.ImageIndex := Length(TeamColors) + ColorIndex; // draw squares rather than circles

  if UpdateServer then SendMyBattleStatusToServer;
end;

{ if UpdateServer=True, then we notify server about our new side }
procedure TBattleForm.ChangeSide(SideIndex: Integer; UpdateServer: Boolean);
begin
  MySideButton.Caption := SideList[SideIndex];
  MySideButton.ImageIndex := SideIndex;
  MySideButton.Tag := SideIndex;

  if UpdateServer then SendMyBattleStatusToServer;
end;

{procedure TBattleForm.TeamColorSpeedButtonClick(Sender: TObject);
var
  ColorIndex: Integer;
begin
  ColorIndex := ChooseColorDialog(Sender as TControl, MyTeamColorIndex);
  if ColorIndex = -1 then Exit;

  ChangeTeamColor(ColorIndex, True);
end;}

procedure TBattleForm.AddUnitsSpeedButtonClick(Sender: TObject);
var
  i: Integer;
  node: PVirtualNode;
  s: string;
begin
  if DisableUnitsForm.ShowModal <> mrOK then Exit;
  BattleState.DisabledUnits.Clear;
  for i:=0 to UnitNodes.Count-1 do
    if ( PVirtualNode(UnitNodes[i]).CheckState = csCheckedNormal) or (PVirtualNode(UnitNodes[i]).CheckState = csCheckedPressed) then
      BattleState.DisabledUnits.Add(UnitList[i]);


  // for the sake of simplicity we send the entire list each time it is changed
  // (we could also generate diff list and update it with ENABLEUNITS/DISABLEUNITS commands)
  BattleForm.PopulateDisabledUnitsVDT;

  RefreshQuickLookText;

  MainForm.TryToSendCommand('ENABLEALLUNITS');
  if BattleState.DisabledUnits.Count > 0 then
  begin
    s := JoinStringList(BattleState.DisabledUnits,' ');
    MainForm.TryToSendCommand('DISABLEUNITS', s);
  end;
end;

procedure TBattleForm.AddBotButtonClick(Sender: TObject);
var
  team, ally, color: Integer;
  i: Integer;

  function FindDuplicate(BotName: string; List: TList): boolean; // find bot with name BotName in List of TBot-s. Return True if found.
  var
    i: Integer;
  begin
    for i := 0 to List.Count -1 do
    begin
      if TBot(List[i]).Name = BotName then
      begin
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;

  function GetNumFromEnd(BotName: string): Integer; // will extract number from the end of the bot's name, e.g.: "Bot123" -> 123. If there is no number at the end of the string, function returns 0 as a result (strings like "Bot0" are invalid anyway)
  var
    temp: string;
    i: Integer;
  begin
    Result := 0;
    i := Length(BotName);
    if not (BotName[i] in ['0'..'9']) then Exit; // Result = 0
    Result := Ord(BotName[i]) - 48;
    while True do
    begin
      Dec(i);
      if i < 1 then Break; // we've reach the beginning of the string
      if (BotName[i] in ['0'..'9']) then Result := (Ord(BotName[i]) - 48) * 10 * (Length(BotName) - i)
      else Break;
    end;
  end;

begin
  if FigureOutBestPossibleTeamAllyAndColor(False, team, ally, color) then
  begin
    AddBotForm.BotTeamButton.SpinOptions.ValueAsInteger := team+1;
    AddBotForm.BotAllyButton.SpinOptions.ValueAsInteger := ally+1;
    AddBotUnit.BotColor := TeamColors[Color];
    MainForm.UpdateColorImageList;
  end;

  // fix bot name to avoid any duplicates:
  if (BattleState.Battle.BattleType = 0 {normal battle}) and (Length(AddBotForm.BotNameEdit.Text) > 0) then
  begin
    if FindDuplicate(AddBotForm.BotNameEdit.Text, BattleState.Battle.Bots) then // bot name already in use, lets modify it to be unique:
    begin
      i := GetNumFromEnd(AddBotForm.BotNameEdit.Text);
      if i = 0 then i := 2 else
      begin
        AddBotForm.BotNameEdit.Text := Copy(AddBotForm.BotNameEdit.Text, 1, Length(AddBotForm.BotNameEdit.Text) - Length(IntToStr(i)));
        Inc(i);
      end;

      while FindDuplicate(AddBotForm.BotNameEdit.Text + IntToStr(i), BattleState.Battle.Bots) do Inc(i);
      AddBotForm.BotNameEdit.Text := AddBotForm.BotNameEdit.Text + IntToStr(i);
    end;
  end;

  AddBotForm.ShowModal;
end;

procedure TBattleForm.ChaTExRichEditURLClick(Sender: TObject;
  const URL: String);
begin
  Misc.OpenURLInDefaultBrowser(URL);
end;

procedure TBattleForm.LockedCheckBoxClick(Sender: TObject);
begin
  if LockedCheckBox.Checked then
  begin
    LockedCheckBox.Font.Color := clRed;
    LockedCheckBox.Caption := 'Locked';
  end
  else
  begin
    LockedCheckBox.Font.Color := clGreen;
    LockedCheckBox.Caption := 'Unlocked';
  end;

  if BattleState.Status <> Hosting then Exit; // happens when we programatically change Changed property (for example when we try to host new battle)

  SendBattleInfoToServer;
end;

procedure TBattleForm.FormShow(Sender: TObject);
begin
  try
    InputEdit.SetFocus;
  except
  end;
  MinimapPanelResize(nil);
end;

procedure TBattleForm.SetDefaultButtonClick(Sender: TObject);
begin
  if MessageDlg(_('Do you wish to save current battle settings as default?'), mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  PreferencesForm.SaveDefaultBattlePreferencesToRegistry;
end;

procedure TBattleForm.LoadDefaultButtonClick(Sender: TObject);
begin
  if BattleState.Battle.BattleType = 1 then Exit; // not allowed to change settings while hosting a replay

  {-->} AllowBattleDetailsUpdate := False;
  PreferencesForm.LoadDefaultBattlePreferencesFromRegistry;
  if HostBattleForm.relayHoster <> nil then
    StartPosRadioGroup.ItemIndex := 2;
  {-->} AllowBattleDetailsUpdate := True;
  if (BattleState.Status = Hosting) and (Sender <> nil) then
    SendBattleDetailsToServer;
end;

{procedure TBattleForm.TBXTeamColorSetGetColorInfo(Sender: TTBXCustomColorSet;
  Col, Row: Integer; var Color: TColor; var Name: String);
begin
  Color := TeamColors[Col + Row * Sender.ColCount];
  Name := 'Color ' + IntToStr(Col + Row * Sender.ColCount);
end;}

{procedure TBattleForm.TBXColorPalette1CellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
begin
  // we keep selection information in Tag property:
  Sender.Tag := ACol + ARow * (Sender as TTBXColorPalette).ColorSet.ColCount;
end;}

{ returns -1 if user cancels the dialog, otherwise returns color index.
  Specify DefaultColorIndex to indicate which color is "default",
  that is currently selected color in choose color dialog (use -1 if you don't
  want any color to be selected). "UnderControl" is the control under which the
  choose color dialog should be displayed. }
{function TBattleForm.ChooseColorDialog(UnderControl: TControl; DefaultColorIndex: Integer): Integer;
var
  p: TPoint;
  Item: TTBCustomItem;
begin
  if DefaultColorIndex = -1 then
    TTBXColorPaletteHack(TBXColorPalette1).SelectedCell := Point(-1, -1)
  else
    TTBXColorPaletteHack(TBXColorPalette1).SelectedCell := Point(DefaultColorIndex mod TBXColorPalette1.ColorSet.ColCount, DefaultColorIndex div TBXColorPalette1.ColorSet.ColCount);

  p := UnderControl.ClientToScreen(Point(0, UnderControl.Height));
  Item := ColorPopupMenu.PopupEx(p.X, p.Y, nil, False);

  if Item = nil then
  begin
    Result := -1;
    Exit;
  end;

  if Item.ClassType <> TTBXColorPalette then
  begin
    Result := -1;
    Exit;
  end;

  Result := Item.Tag;
end; }

{ returns -1 if user cancels the dialog, otherwise returns cell index
  (if user chooses 1, the returned index is 0!).
  Specify DefaultIndex to indicate which cell is "default",
  that is currently selected cell in "choose number dialog" (use -1 if you don't
  want any cell to be selected) - again, 0 means first cell is selected, that is
  cell with number 1 on it. "UnderControl" is the control under which the
  dialog should be displayed. }
function TBattleForm.ChooseNumberDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;
begin
end;

{ returns -1 if user cancels the dialog, otherwise returns side index.
  Specify DefaultIndex to indicate which side is selected by "default",
  that is currently selected item in "choose side dropdown list" (use -1 if you
  don't want any side to be selected). "UnderControl" is the control under which
  the dialog should be displayed. }
function TBattleForm.ChooseSideDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;
var
  p: TPoint;
  Item: TTBCustomItem;
  i: Integer;
begin
  if (DefaultIndex = -1) or (DefaultIndex > SideList.Count-1) then
    for i := 0 to ChooseSidePopupMenu.Items.Count-1 do // deselect all items (clear any radio item selection)
      ChooseSidePopupMenu.Items[i].Checked := False
  else
    ChooseSidePopupMenu.Items[DefaultIndex].Checked := True;

  p := UnderControl.ClientToScreen(Point(0, UnderControl.Height));
  Item := ChooseSidePopupMenu.PopupEx(p.X, p.Y, nil, False);

  if Item = nil then
  begin
    Result := -1;
    Exit;
  end;

  Result := Item.Tag;
end;

{procedure TBattleForm.TBXToolPalette1CellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
begin
  // we keep selection information in Tag property:
  Sender.Tag := ACol + ARow * (Sender as TTBXToolPalette).ColCount;
end;}

procedure TBattleForm.VDTBattleClientsGetNodeWidth(
  Sender: TBaseVirtualTree; HintCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; var NodeWidth: Integer);
var
  AMargin: Integer;

begin
  Exit; //***** disabled (not finished yet!)

  with Sender as TVirtualDrawTree do
    AMargin := TextMargin;

  case Column of
    0: NodeWidth := 100; // player / bot name
    1: ; // team
    2: ; // ally
    3: ; // ready
    4: ; // sync / bot ownder
    5: ; // CPU / AI dll
    6: NodeWidth := 0; // handicap
    7: NodeWidth := 0;
    8: NodeWidth := 0;
  end; // case
end;

{ Will return node type of node with NodeIndex index.
  This is how it works:
  "Normal clients" are clients that are not bots and are not clients
  from the replay script file,
  "Normal bots" are bots,
  "Original clients" are clients from replay's script file (only used
  with hosting battle replays).
  Each type has its own position in the battle client list,
  normal clients are always at the top of the list,
  bots are always at the bottom as well as original clients
  (you can't add both bots and original clients to the list at the same time).
}
function TBattleForm.GetClientNodeType(NodeIndex: Integer): TClientNodeType;
begin
  if BattleState.Battle.BattleType = 1 then
  begin
    if NodeIndex > BattleState.Battle.Clients.Count + BattleReplayInfo.OriginalClients.Count - 1 then
      Result := NodeError
    else if NodeIndex < BattleState.Battle.Clients.Count then
      Result := NormalClient
    else
      Result := OriginalClient;
  end
  else if BattleState.Battle.BattleType = 0 then
  begin
    if NodeIndex > BattleState.Battle.Clients.Count + BattleState.Battle.Bots.Count - 1 then
      Result := NodeError
    else if NodeIndex < BattleState.Battle.Clients.Count then
      Result := NormalClient
    else
      Result := NormalBot;
  end
  else
    Result := NodeError; // this shouldn't of happen (unknown battle type)
end;

function TBattleForm.CompareClients(Client1 : TClient; Client2 : TClient;SortStyle: Byte) : integer;
begin
  case SortStyle of
    0: Result := CompareArgs([Client1.DisplayName],[Client2.DisplayName]);
    1: Result := CompareArgs([-Client1.GetMode, Client1.GetTeamNo, Client1.DisplayName],[-Client2.GetMode, Client2.GetTeamNo, Client2.DisplayName]); // Team Nbs are assigned in skill order
    2: Result := CompareArgs([-Client1.GetMode, Client1.GetTeamNo, Client1.DisplayName],[-Client2.GetMode, Client2.GetTeamNo, Client2.DisplayName]);
    3: Result := CompareArgs([-Client1.GetMode, Client1.GetAllyNo, Client1.DisplayName],[-Client2.GetMode, Client2.GetAllyNo, Client2.DisplayName]);
    4: Result := CompareArgs([-Client1.GetMode, Client1.GetReadyStatus, Client1.DisplayName],[-Client2.GetMode, Client2.GetReadyStatus, Client2.DisplayName]);
    5: Result := CompareArgs([Client1.GetSync, Client1.DisplayName],[Client2.GetSync, Client2.DisplayName]);
    6: Result := CompareArgs([Client1.CPU],[Client2.CPU]);
    7: Result := CompareArgs([-Client1.GetMode, Client1.GetHandicap],[-Client2.GetMode, Client2.GetHandicap]);
    8: Result := CompareArgs([BattleState.Battle.Clients.IndexOf(Client1)],[BattleState.Battle.Clients.IndexOf(Client2)]);
  end;
end;

function TBattleForm.CompareBots(Bot1 : TBot; Bot2 : TBot;SortStyle: Byte) : integer;
begin
  Result := 1;
  case SortStyle of
    0:
      if AnsiCompareText(Bot1.Name,Bot2.Name) = 0  then
        Result := 0
      else if AnsiCompareText(Bot1.Name,Bot2.Name) < 0 then
        Result := -1
      else
        Result := 1;
// Team Nbs are assigned in skill order
    1:
      if Bot1.GetTeamNo = Bot2.GetTeamNo then
        Result := 0
      else if Bot1.GetTeamNo < Bot2.GetTeamNo then
        Result := -1
      else
        Result := 1;
    2:
      if Bot1.GetTeamNo = Bot2.GetTeamNo then
        Result := 0
      else if Bot1.GetTeamNo < Bot2.GetTeamNo then
        Result := -1
      else
        Result := 1;
    3:
      if Bot1.GetAllyNo = Bot2.GetAllyNo then
        Result := 0
      else if Bot1.GetAllyNo < Bot2.GetAllyNo then
        Result := -1
      else
        Result := 1;
    9:
      if BattleState.Battle.Bots.IndexOf(Bot1) = BattleState.Battle.Bots.IndexOf(Bot2)  then
        Result := 0
      else if BattleState.Battle.Bots.IndexOf(Bot1) < BattleState.Battle.Bots.IndexOf(Bot2) then
        Result := -1
      else
        Result := 1;
  end;
end;

procedure TBattleForm.SortClientList(SortStyle: Byte; Ascending: Boolean;FullSort : Boolean);
var
  i,j,k : integer;
  AscValue : integer;
begin
  if BattleState.Status = None then
    Exit;
  if BattleState.Battle = nil then
    Exit;

  if Ascending then
    AscValue := 1
  else
    AscValue := -1;

  // insertion sort
  if FullSort then
  begin
    SortedClientList.Clear;
    SortedClientList.Add(BattleState.Battle.Clients[0]);
    for i:=1 to BattleState.Battle.Clients.Count -1 do // for each clients
    begin
      j:=0;
      while (j<SortedClientList.Count) and (CompareClients(TClient(SortedClientList[j]),TClient(BattleState.Battle.Clients[i]),SortStyle) = AscValue) do
        j := j+1;
      SortedClientList.Insert(j,BattleState.Battle.Clients[i]);
    end;

    SortedOriginalList.Clear;
    if (BattleState.Battle.BattleType = 1) and (BattleReplayInfo.OriginalClients.Count > 0) then begin
      SortedOriginalList.Add(BattleReplayInfo.OriginalClients[0]);
      for i:=1 to BattleReplayInfo.OriginalClients.Count -1 do // for each original clients
      begin
        j:=0;
        while (j<SortedOriginalList.Count) and (CompareClients(TClient(SortedOriginalList[j]),TClient(BattleReplayInfo.OriginalClients[i]),SortStyle) = AscValue) do
          j := j+1;
        SortedOriginalList.Insert(j,BattleReplayInfo.OriginalClients[i]);
      end;
    end;
  end
  else
  begin
    i:=0;
    while (i<SortedClientList.Count) and (CompareClients(TClient(SortedClientList[i]),TClient(BattleState.Battle.Clients.Last),SortStyle) = AscValue) do
      i := i+1;
    SortedClientList.Insert(i,BattleState.Battle.Clients.Last);
  end;
end;
procedure TBattleForm.SortBotList(SortStyle: Byte; Ascending: Boolean;FullSort : Boolean);
var
  i,j,k : integer;
  AscValue : integer;
begin
  if BattleState.Status = None then
    Exit;
  if BattleState.Battle = nil then
    Exit;
  if BattleState.Battle.Bots.Count = 0 then
  begin
    SortedBotList.Clear;
    Exit;
  end;

  if Ascending then
    AscValue := 1
  else
    AscValue := -1;

  // insertion sort
  if FullSort then
  begin
    SortedBotList.Clear;
    SortedBotList.Add(BattleState.Battle.Bots[0]);
    for i:=1 to BattleState.Battle.Bots.Count -1 do // for each bots
    begin
      j:=0;
      while (j<SortedBotList.Count) and (CompareBots(TBot(SortedBotList[j]),TBot(BattleState.Battle.Bots[i]),SortStyle) = AscValue) do
        j := j+1;
      SortedBotList.Insert(j,BattleState.Battle.Bots[i]);
    end;
  end
  else
  begin
    i:=0;
    while (i<SortedBotList.Count) and (CompareBots(TBot(SortedBotList[i]),TBot(BattleState.Battle.Bots.Last),SortStyle) = AscValue) do
      i := i+1;
    SortedBotList.Insert(i,BattleState.Battle.Bots.Last);
  end;
end;


procedure TBattleForm.GetNodeClient(index : integer;var realindex : integer;var nodetype : TClientNodeType);
var
  i,j,k : integer;
  originalClientIndex: integer;
begin
  if index < SortedClientList.Count then begin
    realindex := BattleState.Battle.Clients.IndexOf(SortedClientList[index]);
    nodetype := NormalClient;
    Exit;
  end;
  if index < SortedClientList.Count + SortedBotList.Count then begin
    realindex := BattleState.Battle.Bots.IndexOf(SortedBotList[index - SortedClientList.Count]);
    nodetype := NormalBot;
    Exit;
  end;
  originalClientIndex := index - SortedClientList.Count - SortedBotList.Count;
  if originalClientIndex < SortedOriginalList.Count then
    realindex := BattleReplayInfo.OriginalClients.IndexOf(SortedOriginalList[originalClientIndex])
  else
    realindex := -1;
  nodetype := OriginalClient;
  realindex := Max(0,realindex);
end;

procedure TBattleForm.VDTBattleClientsDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  Index: Integer;
  Pos: Integer; // offset in X direction
  s: string;
  R: TRect;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
  score:Integer;
  TempPenColor, TempBrushColor: TColor;
  group : TClientGroup;
  FlagBitmap: TBitmap;
  i: integer;
  tmp: integer;
  BgRect: TRect;
  pt: TPoint;
  hot: Boolean;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
  SkillKey: string;
begin
  Index := PaintInfo.Node.Index;

  PaintInfo.Canvas.Font := BattleClientsListFont;

  if not IsBattleActive then
  begin
    UpdateClientsListBox;
    Exit;
  end;

  if BattleState.Battle.BattleType = 0 then if Index > BattleState.Battle.Clients.Count + BattleState.Battle.Bots.Count - 1 then
  begin
    UpdateClientsListBox;
    Exit;
  end;

  if BattleState.Battle.BattleType = 1 then if Index > BattleState.Battle.Clients.Count + BattleReplayInfo.OriginalClients.Count - 1 then
  begin
    UpdateClientsListBox;
    Exit;
  end;

  GetNodeClient(Index,RealIndex,WhatToDraw);

  if RealIndex = -1 then Exit; // shouldn't happen

  with Sender as TVirtualDrawTree, PaintInfo do
  begin

    GetCursorPos(pt);
    pt := ScreenToClient(pt);
    GetHitTestInfoAt(pt.X,pt.Y,True,hi);
    
    hot := (SkinManager.GetSkinType=sknSkin) and BattleForm.Active and (hi.HitNode = Node);
  
    CopyRect(BgRect,CellRect);
    {if Position <> 0 then
      BgRect.Left := -5;
    if Position <> Header.Columns.Count-1 then
      BgRect.Right := BgRect.Right+5;}

    if SkinManager.GetSkinType=sknSkin then
    begin
      itemState := SkinManager.CurrentSkin.GetState((WhatToDraw = NormalClient) or (WhatToDraw = NormalBot),False,hot,(Node = FocusedNode) and focused);
      Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,itemState);
      SkinManager.CurrentSkin.PaintBackground(Canvas,BgRect,skncListItem,itemState,True,True);
      Canvas.Brush.Style := Graphics.bsClear;
    end
    else if (Node = FocusedNode) and focused then
    begin
      if (WhatToDraw = NormalClient) or (WhatToDraw = NormalBot) then
        Canvas.Brush.Color := clHighlight
      else
        PaintInfo.Canvas.Brush.Color := $00ffdddd;
      Canvas.Font.Color := clHighlightText;
      Canvas.FillRect(CellRect);
    end
    else
      Canvas.Font.Color := clWindowText;

    R := ContentRect;
    InflateRect(R, -TextMargin, 0);
    Dec(R.Right);
    Dec(R.Bottom);

    // set correct font color:
    case WhatToDraw of
      NormalBot:
      begin
        Canvas.Font.Color := MainUnit.Colors.BotText;
        if (Node = FocusedNode) and Focused then
          Canvas.Font.Color := clHighlightText;
      end;
    end;

    Pos := 0;

    case Column of
      0: // player / bot name
      case WhatToDraw of
        NormalClient:
        begin
          if Preferences.ShowFlags then
          begin
            // Country Flag:
            FlagBitmap := MainForm.GetFlagBitmap(TClient(BattleState.Battle.Clients[RealIndex]).Country);
            Canvas.Draw(R.Left, R.Top + 16 div 2 - FlagBitmap.Height div 2, FlagBitmap);
            Inc(Pos, FlagBitmap.Width + 4);
          end;
          // side:
          if TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1 then
            SideImageList.Draw(PaintInfo.Canvas, R.Left + Pos, R.Top, Min(TClient(BattleState.Battle.Clients[RealIndex]).GetSide, SideList.Count-1));
          Inc(Pos, SideImageList.Width);
          // rank:
          MainForm.RanksImageList.Draw(Canvas, R.Left + Pos, R.Top, TClient(BattleState.Battle.Clients[RealIndex]).GetRank);
          Inc(Pos, MainForm.RanksImageList.Width + 3);

          // bot mode icon:
          if TClient(BattleState.Battle.Clients[RealIndex]).GetBotMode then
          begin
            Canvas.Draw(R.Left + Pos, R.Top, MainForm.BotImage.Picture.Bitmap);
            Inc(Pos, MainForm.BotImage.Picture.Bitmap.Width + 4{leave some space between username and the icon});
          end;

          // group highlight
          if not hot then
          begin
            group := TClient(BattleState.Battle.Clients[RealIndex]).GetGroup;
            if (group <> nil) and (PaintInfo.Node <> VDTBattleClients.FocusedNode) and (group.EnableColor) then begin
              Canvas.Brush.Color := group.Color;
              Canvas.Font.Color := Misc.ComplementaryTextColor(group.Color);
              Canvas.FillRect(Rect(R.Left+Pos,R.Top,R.Right,R.Bottom));
            end;
          end;

           // override font color if client is away or ingame:
          if TClient(BattleState.Battle.Clients[RealIndex]).GetAwayStatus and not TClient(BattleState.Battle.Clients[RealIndex]).GetInGameStatus then
            Canvas.Font.Color := MainUnit.Colors.ClientAway
          else if TClient(BattleState.Battle.Clients[RealIndex]).GetInGameStatus then
            Canvas.Font.Color := MainUnit.Colors.ClientIngame;


          // username:
          s := TClient(BattleState.Battle.Clients[RealIndex]).DisplayName;
          Canvas.TextOut(R.Left + Pos, R.Top, s);

          Inc(Pos,Canvas.TextWidth(s)+5);

          // custom icons
          if not Preferences.ScriptsDisabled then
          for i:=0 to lobbyScriptUnit.PlayerIconTypeNames.Count-1 do
          begin
            tmp := TClient(BattleState.Battle.Clients[RealIndex]).GetCustomIconId(i);
            if (tmp >= 0) and (TImageList(lobbyScriptUnit.PlayerIconTypeIcons[i]).Count > tmp) then
            begin
              TImageList(lobbyScriptUnit.PlayerIconTypeIcons[i]).Draw(Canvas, R.Left + Pos, R.Top,tmp);
              Inc(Pos, TImageList(lobbyScriptUnit.PlayerIconTypeIcons[i]).Width + 1);
            end;
          end;

          // hoster icon
          if RealIndex = 0 then
          begin
            MainForm.PlayerStateImageList.Draw(Canvas, R.Left + Pos, R.Top, 5);
            Inc(Pos, MainForm.PlayerStateImageList.Width + 1);
          end;

          // admin icon
          if TClient(BattleState.Battle.Clients[RealIndex]).GetAccess then
            MainForm.PlayerStateImageList.Draw(Canvas, R.Left + Pos, R.Top, 4)
        end;
        NormalBot:
        begin
          // side:
          SideImageList.Draw(Canvas, R.Left + Pos, R.Top, Min(TBot(BattleState.Battle.Bots[RealIndex]).GetSide, SideList.Count-1));
          Inc(Pos, SideImageList.Width + 3);
          // name:
          s := TBot(BattleState.Battle.Bots[RealIndex]).Name;
          Canvas.TextOut(R.Left + Pos, R.Top, s);
        end;
        OriginalClient:
        begin
          if Preferences.ShowFlags then
          begin
            // Country Flag:
            try
              FlagBitmap := MainForm.GetFlagBitmap(TClient(BattleReplayInfo.OriginalClients[RealIndex]).Country);
            except
              FlagBitmap := TBitmap.Create;
            end;
            Canvas.Draw(R.Left, R.Top + 16 div 2 - FlagBitmap.Height div 2, FlagBitmap);
            Inc(Pos, FlagBitmap.Width + 4);
          end;
          // side:
          if TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetMode = 1 then
            SideImageList.Draw(Canvas, R.Left + Pos, R.Top, Min(TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetSide, SideList.Count-1));
          Inc(Pos, SideImageList.Width);
          // rank:
          MainForm.RanksImageList.Draw(Canvas, R.Left + Pos, R.Top, TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetRank);
          Inc(Pos, MainForm.RanksImageList.Width + 3);
          
          // username:
          s := TClient(BattleReplayInfo.OriginalClients[RealIndex]).Name;
          Canvas.TextOut(R.Left + Pos, R.Top, s);
        end;
      end; // case WhatToDraw

      1: // skill
      case WhatToDraw of
        NormalClient:
        begin
          SkillKey := 'game/players/' + LowerCase(TClient(BattleState.Battle.Clients[RealIndex]).Name) + '/skill';
          if UnknownScriptTagList.CompleteKeyList.IndexOf(SkillKey) >= 0 then
          begin
            Canvas.Font.Color := MainUnit.Colors.SkillVeryHighUncertainty;
            s := UnknownScriptTagList.ValueList[UnknownScriptTagList.CompleteKeyList.IndexOf(SkillKey)];
            SkillKey := 'game/players/' + LowerCase(TClient(BattleState.Battle.Clients[RealIndex]).Name) + '/skilluncertainty';
            if UnknownScriptTagList.CompleteKeyList.IndexOf(SkillKey) >= 0 then
            begin
              tmp := StrToInt(UnknownScriptTagList.ValueList[UnknownScriptTagList.CompleteKeyList.IndexOf(SkillKey)]);
              if  tmp > 2 then
                Canvas.Font.Color := MainUnit.Colors.SkillVeryHighUncertainty
              else if tmp > 1 then
                Canvas.Font.Color := MainUnit.Colors.SkillHighUncertainty
              else if tmp > 0 then
                Canvas.Font.Color := MainUnit.Colors.SkillAvgUncertainty
              else
                Canvas.Font.Color := MainUnit.Colors.SkillLowUncertainty;
            end;
            Canvas.TextOut(R.Left + Pos, R.Top, s);
          end;
        end;
        NormalBot:
        begin
          // no need to draw this for bot
        end;
        OriginalClient:
        begin
//        we don't need to draw this
        end;
      end; // case WhatToDraw

      2: // team
      case WhatToDraw of
        NormalClient:
        begin
          if TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1 then
          begin
            s := IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetTeamNo + 1);
            Pos := (R.Right - R.Left) div 2 - (MainForm.ColorImageList.Width + Canvas.TextWidth(s)) div 2;
            // team color:
            with Canvas do
            begin
              if TClient(BattleState.Battle.Clients[RealIndex]).isComSharing then begin
                Brush.Color := TClient(BattleState.Battle.Clients[RealIndex]).TeamColor;
                FillRect(ContentRect);
                Font.Color := $00FFFFFF-TClient(BattleState.Battle.Clients[RealIndex]).TeamColor;
                Pen.Color := $00FFFFFF-TClient(BattleState.Battle.Clients[RealIndex]).TeamColor;
              end;
              TempPenColor := Pen.Color;
              TempBrushColor := Brush.Color;
              Brush.Color := TClient(BattleState.Battle.Clients[RealIndex]).TeamColor;

              if TClient(BattleState.Battle.Clients[RealIndex]).isComSharing then
                Pen.Color := $00FFFFFF-TClient(BattleState.Battle.Clients[RealIndex]).TeamColor
              else
                Pen.Color := clGray;

              Ellipse(R.Left + Pos + 2, R.Top + 2, R.Left + Pos + 13, R.Top + 13);
              
              Pen.Color := TempPenColor;
              Brush.Color := TempBrushColor;

              Brush.Style := Graphics.bsClear;

              TextOut(R.Left + Pos + MainForm.ColorImageList.Width, R.Top, s);
            end;
          end;
        end;
        NormalBot:
        begin
          s := IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetTeamNo + 1);
          Pos := (R.Right - R.Left) div 2 - (MainForm.ColorImageList.Width + Canvas.TextWidth(s)) div 2;
          // team color:
          with Canvas do
          begin
            if TBot(BattleState.Battle.Bots[RealIndex]).isComSharing then begin
              Brush.Color := TBot(BattleState.Battle.Bots[RealIndex]).TeamColor;
              FillRect(ContentRect);
              Font.Color := $00FFFFFF-TBot(BattleState.Battle.Bots[RealIndex]).TeamColor;
              Pen.Color := $00FFFFFF-TBot(BattleState.Battle.Bots[RealIndex]).TeamColor;
            end;
            TempPenColor := Pen.Color;
            TempBrushColor := Brush.Color;
            Brush.Color := TBot(BattleState.Battle.Bots[RealIndex]).TeamColor;

            if TBot(BattleState.Battle.Bots[RealIndex]).isComSharing then
              Pen.Color := $00FFFFFF-TBot(BattleState.Battle.Bots[RealIndex]).TeamColor
            else
              Pen.Color := clGray;
              
            Ellipse(R.Left + Pos + 2, R.Top + 2, R.Left + Pos + 13, R.Top + 13);
            Pen.Color := TempPenColor;
            Brush.Color := TempBrushColor;
            Brush.Style := Graphics.bsClear;
          end;
          // team no.:
          Canvas.TextOut(R.Left + Pos + MainForm.ColorImageList.Width, R.Top, s);
        end;
        OriginalClient:
        begin
          if TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetMode = 1 then
          begin
            s := IntToStr(TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetTeamNo + 1);
            Pos := (R.Right - R.Left) div 2 - (MainForm.ColorImageList.Width + Canvas.TextWidth(s)) div 2;
            // team color:
            with Canvas do
            begin
              TempPenColor := Pen.Color;
              TempBrushColor := Brush.Color;
              Brush.Color := TClient(BattleReplayInfo.OriginalClients[RealIndex]).TeamColor;
              Pen.Color := clGray;
              Ellipse(R.Left + Pos + 2, R.Top + 2, R.Left + Pos + 13, R.Top + 13);
              Pen.Color := TempPenColor;
              Brush.Color := TempBrushColor;
              Brush.Style := Graphics.bsClear;
            end;
            // team no.:
            Canvas.TextOut(R.Left + Pos + MainForm.ColorImageList.Width, R.Top, s);
          end;
        end
      end; // case WhatToDraw

      3: // ally
      case WhatToDraw of
        NormalClient:
        begin
          if TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1 then
          begin
            s := IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetAllyNo + 1);
            Pos := (R.Right - R.Left) div 2 - Canvas.TextWidth(s) div 2;
            Canvas.TextOut(R.Left + Pos, R.Top, s);
          end;
        end;
        NormalBot:
        begin
          s := IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetAllyNo + 1);
          Pos := (R.Right - R.Left) div 2 - Canvas.TextWidth(s) div 2;
          Canvas.TextOut(R.Left + Pos, R.Top, s);
        end;
        OriginalClient:
        begin
          if TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetMode = 1 then
          begin
            s := IntToStr(TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetAllyNo + 1);
            Pos := (R.Right - R.Left) div 2 - Canvas.TextWidth(s) div 2;
            Canvas.TextOut(R.Left + Pos, R.Top, s);
          end;
        end;
      end; // case WhatToDraw

      4: // ready
      case WhatToDraw of
        NormalClient:
        begin
          if (TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1) then
          begin
            Pos := (R.Right - R.Left) div 2 - MainForm.ReadyStateImageList.Width div 2;
            MainForm.ReadyStateImageList.Draw(Canvas, R.Left + Pos, R.Top, BoolToInt(TClient(BattleState.Battle.Clients[RealIndex]).GetReadyStatus));
          end;
        end;
        NormalBot:
        begin
          // no need to draw this for bot
        end;
        OriginalClient:
        begin
          // ready:
//        we don't need to draw this
        end;
      end; // case WhatToDraw

      5: // sync / bot owner
      case WhatToDraw of
        NormalClient:
        begin
          MainForm.SyncImageList.Draw(Canvas, R.Left + Pos, R.Top, TClient(BattleState.Battle.Clients[RealIndex]).GetSync);
        end;
        NormalBot:
        begin
          // owner:
          s := TBot(BattleState.Battle.Bots[RealIndex]).OwnerName;
          Canvas.TextOut(R.Left + Pos, R.Top, s);
        end;
        OriginalClient:
        begin
          // sync:
//        we don't need to draw this
        end;
      end; // case WhatToDraw

      6: // cpu / ai dll
      case WhatToDraw of
        NormalClient:
        begin
          if TClient(BattleState.Battle.Clients[RealIndex]).CPU = 0 then s := '? Ghz'
          else s := Trim(Format('%8.1f', [TClient(BattleState.Battle.Clients[RealIndex]).CPU / 1000])) + ' GHz';
          Canvas.TextOut(R.Left + Pos, R.Top, s);
        end;
        NormalBot:
        begin
          // AI (dll file name):
          s := TBot(BattleState.Battle.Bots[RealIndex]).AIShortName;
          Canvas.TextOut(R.Left + Pos, R.Top, s);
        end;
        OriginalClient:
        begin
          // cpu:
//        we don't need to draw this
        end;
      end; // case WhatToDraw

      7: // handicap
      case WhatToDraw of
        NormalClient:
        begin
          if TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1 then
            Canvas.TextOut(R.Left + Pos, R.Top, IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetHandicap));
        end;
        NormalBot:
        begin
          Canvas.TextOut(R.Left + Pos, R.Top, IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetHandicap));
        end;
        OriginalClient:
        begin
          if TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetMode = 1 then
            Canvas.TextOut(R.Left + Pos, R.Top, IntToStr(TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetHandicap));
        end;
      end; // case WhatToDraw

      8: // order
      case WhatToDraw of
        NormalClient:
        begin
            Canvas.TextOut(R.Left + Pos, R.Top, IntToStr(RealIndex+1));
        end;
        NormalBot:
        begin
            Canvas.TextOut(R.Left + Pos, R.Top, IntToStr(BattleState.Battle.Clients.Count-BattleState.Battle.SpectatorCount+RealIndex+1));
        end;
        OriginalClient:
        begin
            Canvas.TextOut(R.Left + Pos, R.Top, '');
        end;
      end; // case WhatToDraw

    end; // case Column

  end;

end;

procedure TBattleForm.VDTBattleClientsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if VDTBattleClients.FocusedNode = nil then
    Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = OriginalClient then Exit;

  p := (Sender as TControl).ClientToScreen(Point(X, Y));

  if Button = mbRight
  then
  begin
    SetBotSideSubitem.Enabled := WhatToDraw = NormalBot;
    ForceSpectatorModeItem.Enabled := (WhatToDraw = NormalClient) and (TClient(BattleState.Battle.Clients[RealIndex]).GetMode <> 0);
    if WhatToDraw = NormalClient then
    begin
      HandicapSpinEditItem.Text := IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetHandicap);
    end
    else if WhatToDraw = NormalBot then
    begin
      HandicapSpinEditItem.Text := IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetHandicap);
    end;

    BanPlayerItem.Enabled := WhatToDraw = NormalClient;
    RingItem.Enabled := WhatToDraw = NormalClient;
    PlayerControlPopupMenuPopup(nil);
    PlayerControlPopupMenu.Popup(p.X, p.Y);

    if VDTBattleClients.FocusedNode <> nil then
    begin
      if (WhatToDraw = NormalClient)
      and (StrToInt(HandicapSpinEditItem.Text) <> TClient(BattleState.Battle.Clients[RealIndex]).GetHandicap) then
        MainForm.TryToSendCommand('HANDICAP', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(StrToInt(HandicapSpinEditItem.Text)))
      else if (WhatToDraw = NormalBot)
      and (StrToInt(HandicapSpinEditItem.Text) <> TBot(BattleState.Battle.Bots[RealIndex]).GetHandicap) then
      begin
        TBot(BattleState.Battle.Bots[RealIndex]).SetHandicap(StrToInt(HandicapSpinEditItem.Text));
        MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
      end;
    end;
  end
  else if Button = mbLeft then ;
end;

{procedure TBattleForm.ForceTeamToolPaletteCellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
var
  team: Integer;
  i:integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    team := ACol + ARow * (Sender as TTBXToolPalette).ColCount;

    if WhatToDraw = NormalClient then
    begin
      if mnuBlockTeams.Checked then
        TClient(BattleState.Battle.Clients[RealIndex]).SetTeamNo(team);
      MainForm.TryToSendCommand('FORCETEAMNO', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(team));
      AddTextToChat(_('Forcing ') + TClient(BattleState.Battle.Clients[RealIndex]).Name + _('''s team number ...'), Colors.Info, 1);
    end
    else if WhatToDraw = NormalBot then
    begin
      with TBot(BattleState.Battle.Bots[RealIndex]) do begin
        SetTeamNo(Round(team));
        if isComSharing then begin
          for i := 0 to BattleState.Battle.Clients.Count-1 do begin
            if (TClient(BattleState.Battle.Clients[i]).GetTeamNo = GetTeamNo) then begin
              TeamColor := TClient(BattleState.Battle.Clients[i]).TeamColor;
              break;
            end;
          end;
          if i < BattleState.Battle.Clients.Count then begin
            for i := 0 to BattleState.Battle.Bots.Count-1 do begin
              if (TBot(BattleState.Battle.Bots[i]).GetTeamNo = GetTeamNo) and (TBot(BattleState.Battle.Bots[i]).Name <> Name) then begin
                TeamColor := TBot(BattleState.Battle.Bots[i]).TeamColor;
                break;
              end;
            end;
          end;
        end;
      end;
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;
  end;
end;

procedure TBattleForm.ForceAllyToolPaletteCellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
var
  ally: Integer;
  i:integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    ally := ACol + ARow * (Sender as TTBXToolPalette).ColCount;

    if WhatToDraw = NormalClient then
    begin
      if mnuBlockTeams.Checked then
        TClient(BattleState.Battle.Clients[RealIndex]).SetAllyNo(ally);
      MainForm.TryToSendCommand('FORCEALLYNO', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(ally));
      AddTextToChat(_('Forcing ') + TClient(BattleState.Battle.Clients[RealIndex]).Name + _('''s ally number ...'), Colors.Info, 1);
    end
    else if WhatToDraw = NormalBot then
    begin
      TBot(BattleState.Battle.Bots[RealIndex]).SetAllyNo(Round(ally));
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;

  end;
end; }

procedure TBattleForm.KickPlayerItemClick(Sender: TObject);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
      MainForm.TryToSendCommand('KICKFROMBATTLE', TClient(BattleState.Battle.Clients[RealIndex]).Name)
    else if WhatToDraw = NormalBot then
      MainForm.TryToSendCommand('REMOVEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name);
  end;
end;

{procedure TBattleForm.ForceTeamColorPaletteCellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
var
  color: Integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    color := ACol + ARow * (Sender as TTBXColorPalette).ColorSet.ColCount;

    if WhatToDraw = NormalClient then
    begin
      MainForm.TryToSendCommand('FORCETEAMCOLOR', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(TeamColors[color]));
    end
    else if WhatToDraw = NormalBot then
    begin
      TBot(BattleState.Battle.Bots[RealIndex]).TeamColor := TeamColors[color];
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;
  end;
end;

procedure TBattleForm.SetTeamColorItemClick(Sender: TObject);
var
  colorindex: Integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      colorindex := Misc.GetColorIndex(TeamColors, TClient(BattleState.Battle.Clients[RealIndex]).TeamColor);
      if colorindex = -1 then
        TTBXColorPaletteHack(ForceTeamColorPalette).SelectedCell := Point(-1, -1)
      else
        TTBXColorPaletteHack(ForceTeamColorPalette).SelectedCell := Point(colorindex mod ForceTeamColorPalette.ColorSet.ColCount, colorindex div ForceTeamColorPalette.ColorSet.ColCount);
    end
    else if WhatToDraw = NormalBot then
    begin
      colorindex := Misc.GetColorIndex(TeamColors, TBot(BattleState.Battle.Bots[RealIndex]).TeamColor);
      if colorindex = -1 then
        TTBXColorPaletteHack(ForceTeamColorPalette).SelectedCell := Point(-1, -1)
      else
        TTBXColorPaletteHack(ForceTeamColorPalette).SelectedCell := Point(colorindex mod ForceTeamColorPalette.ColorSet.ColCount, colorindex div ForceTeamColorPalette.ColorSet.ColCount);
    end;
  end
  else
    TTBXColorPaletteHack(ForceTeamColorPalette).SelectedCell := Point(-1, -1);
end;}

procedure TBattleForm.SetBotSideItemClick(Sender: TObject);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalBot then begin
      TBot(BattleState.Battle.Bots[RealIndex]).SetSide((Sender as TSpTBXItem).Tag);
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;
  end;
end;

procedure TBattleForm.SetBotLibItemClick(Sender: TObject);
begin
  TBot(BattleState.Battle.Bots[(Sender as TSpTBXItem).Tag]).AIShortName := (Sender as TSpTBXItem).Caption;
end;

procedure TBattleForm.UnbanItemClick(Sender: TObject);
var
  Client: TClient;
begin
    MainForm.TryToSendCommand('SAYBATTLEEX', 'removed '+(Sender as TSpTBXItem).Caption+' from ban list');
    Client := MainForm.GetClientById(BattleState.BanList.Items[(Sender as TSpTBXItem).Tag]);
    if Client <> nil then
      Client.AutoKickMsgSent := 0;
    BattleState.BanList.Delete((Sender as TSpTBXItem).Tag);
end;

procedure TBattleForm.MySideButtonClick(Sender: TObject);
var
  SideIndex: Integer;
begin
  SideIndex := ChooseSideDialog(Sender as TControl, MySideButton.Tag);
  if SideIndex = -1 then Exit;

  ChangeSide(SideIndex, True);
end;

procedure TBattleForm.ReadyButtonClick(Sender: TObject);
begin
  // check if user has the correct map before readying up:
  if (not BattleForm.AmIReady) and (Utility.MapList.IndexOf(BattleState.Battle.Map) = -1) then
  begin
    MessageDlg(_('Please download the map before readying up. You can do this by clicking on the minimap area or the "Download map ..." button, which will open integrated map downloader'), mtWarning, [mbOK], 0);
    Exit;
  end;

  BattleForm.AmIReady := not BattleForm.AmIReady;
end;

procedure TBattleForm.mnuTeamColorCustomizeClick(Sender: TObject);
begin
  if AddBotForm.Visible then
    Misc.InputColor(_('Color Picker'),clBlack)
  else
  begin
    Misc.InputColor(_('Color Picker'),Status.Me.TeamColor);
    ChangeTeamColor(MyTeamColorIndex, True);
  end;
end;

procedure TBattleForm.SpTBXItem7Click(Sender: TObject);
var
  color: Integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      color := Misc.InputColor(_('Color Picker'),TClient(BattleState.Battle.Clients[RealIndex]).TeamColor);
      MainForm.TryToSendCommand('FORCETEAMCOLOR', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(color));
    end
    else if WhatToDraw = NormalBot then
    begin
      color := Misc.InputColor(_('Color Picker'),TBot(BattleState.Battle.Bots[RealIndex]).TeamColor);
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;
  end;
end;

procedure TBattleForm.MapsButtonClick(Sender: TObject);
begin
  if MapListForm.Visible then
    MapListForm.Close;
  MapListForm.ShowModal;
end;

procedure TBattleForm.ReloadMapListButtonClick(Sender: TObject);
var
  i:integer;
begin
  TotalMetal := 0;
  if (BattleState.Status = Hosting) and (BattleState.Battle.BattleType = 1) then
  begin
    // this should not happen though since we don't allow player to host a replay if he doesn't have the correct map!
    MessageDlg(_('Cannot reload map list while hosting online replay!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if BattleState.Status = Hosting then
  begin
    Utility.ReInitLibWithDialog;

    // reload map list:
    InitWaitForm.ChangeCaption(MSG_RELOADMAPLIST);
    InitWaitForm.TakeAction := 5;
    InitWaitForm.ShowModal;

    if Utility.MapList.IndexOf(BattleState.Battle.Map) = -1 then
      ChangeMapToNoMap(BattleState.Battle.Map)
    else
      ChangeMap(Utility.MapList.IndexOf(BattleState.Battle.Map));

    SendBattleInfoToServer; // in case map got changed
  end
  else if BattleState.Status = Joined then
  begin
    Utility.ReInitLibWithDialog;

    // reload map list:
    InitWaitForm.ChangeCaption(MSG_RELOADMAPLIST);
    InitWaitForm.TakeAction := 5;
    InitWaitForm.ShowModal;


    if Utility.MapList.IndexOf(BattleState.Battle.Map) = -1 then
      ChangeMapToNoMap(BattleState.Battle.Map)
    else
    begin
      JoinButton.Enabled := True;
      ChangeMap(Utility.MapList.IndexOf(BattleState.Battle.Map));
    end;
  end
  else
  begin // just reinit and reload
    Utility.ReInitLibWithDialog;

    // reload map list:
    InitWaitForm.ChangeCaption(MSG_RELOADMAPLIST);
    InitWaitForm.TakeAction := 5;
    InitWaitForm.ShowModal;

    if Utility.MapList.IndexOf(Preferences.LastOpenMap) = -1 then
      if Utility.MapList.Count = 0 then
        BattleForm.ChangeMapToNoMap('NoMap')
      else
        BattleForm.ChangeMap(0) // load first map in the list
    else
      BattleForm.ChangeMap(Utility.MapList.IndexOf(Preferences.LastOpenMap)); // restore last open map
  end;

  MainForm.PrintUnitsyncErrors;
end;

procedure TBattleForm.VDTBattleClientsDblClick(Sender: TObject);
var
  HitInfo: THitInfo;
  p: TPoint;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  GetCursorPos(p);
  p := VDTBattleClients.ScreenToClient(p);
  VDTBattleClients.GetHitTestInfoAt(p.X, p.Y, True, HitInfo);

  if HitInfo.HitNode <> nil then
  begin
    GetNodeClient(HitInfo.HitNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      MainForm.OpenPrivateChat(TClient(BattleState.Battle.Clients[RealIndex]));
    end
    else if WhatToDraw = NormalBot then
    begin
      if (TBot(BattleState.Battle.Bots[RealIndex]).OptionsForm <> nil) and (BattleState.Status=Hosting) then
        TBot(BattleState.Battle.Bots[RealIndex]).OptionsForm.Show;
    end;
  end;
end;

procedure TBattleForm.ForceSpectatorModeItemClick(Sender: TObject);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      MainForm.TryToSendCommand('FORCESPECTATORMODE', TClient(BattleState.Battle.Clients[RealIndex]).Name);
      AddTextToChat(_('Forcing spectator mode on ') + TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ...', Colors.Info, 1);
    end;
  end;
end;

procedure TBattleForm.LockedCheckBoxGetImageIndex(Sender: TObject;
  var AImageList: TCustomImageList; var AItemIndex: Integer);
begin
  AImageList := MainForm.MiscImageList;
  if (Sender as TSpTBXCheckBox).Checked then
    AItemIndex := 11
  else
    AItemIndex := 12
end;

procedure TBattleForm.AutoStartRectsOptionsItemClick(Sender: TObject);
begin
  AutoStartRectsForm.ShowModal;
end;

procedure TBattleForm.AutoStartRectsApplyItemClick(Sender: TObject);
begin
  AutoStartRectsForm.FormShow(nil);
  AutoStartRectsForm.RecreatePreview;
  AutoStartRectsForm.ApplyCurrentConfiguration;
end;
procedure TBattleForm.RefreshTeamNbr;
var
  i : integer;
  nb : array [1..MAX_TEAMS] of Integer;
  nbPlayers: integer;
  nbSpecs: integer;
  msg : string;
begin
  if BattleState.Status <> None then begin
    for i:= 1 to MAX_TEAMS do begin
      nb[i] := 0;
    end;
    nbPlayers := 0;
    nbSpecs := 0;
    for i:=0 to BattleState.Battle.Clients.Count-1 do begin
      if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then begin
        nb[TClient(BattleState.Battle.Clients[i]).GetAllyNo+1] := nb[TClient(BattleState.Battle.Clients[i]).GetAllyNo+1] + 1;
        nbPlayers := nbPlayers +1;
      end
      else
        nbSpecs := nbSpecs + 1;
    end;
    msg := '';
    for i:=1 to MAX_TEAMS do begin
      if nb[i] > 0 then begin
        if msg <> '' then begin
          msg := msg + #13#10;
        end;
        msg := msg + '| '+IntToStr(i)+' | = ' + IntToStr(nb[i]);
      end;
    end;
    msg := msg + #13#10;
    if nbSpecs > 0 then
      msg := msg + #13#10 + IntToStr(nbPlayers) + '+' + IntToStr(nbSpecs) + '/' + IntToStr(BattleState.Battle.MaxPlayers)
    else
      msg := msg + #13#10 + IntToStr(nbPlayers) + '/' + IntToStr(BattleState.Battle.MaxPlayers);
    BattleForm.lblTeamNbr.caption := msg;
  end;
end;

procedure TBattleForm.mnuRingAllNotRdyClick(Sender: TObject);
var
  i: Integer;
begin
    for i:=0 to BattleState.Battle.Clients.Count-1 do begin
      if (not TClient(BattleState.Battle.Clients[i]).GetReadyStatus) and (TClient(BattleState.Battle.Clients[i]).GetMode <> 0) then begin
        MainForm.ProcessCommand('RING '+TClient(BattleState.Battle.Clients[i]).Name, True);
      end;
    end
end;



procedure TBattleForm.mnuFixColorsClick(Sender: TObject);
var
  ColorList : TIntegerList;
  i,j,k : integer;
  bestCol,bestVal : integer;
  r,g,b : integer;
  temp:integer;
  minDist : integer;
  cDistance:integer;
  Color : integer;
begin
  ColorList := TIntegerList.create;
  for i:=0 to BattleState.Battle.Clients.count-1 do
    if (TClient(BattleState.Battle.Clients[i]).GetMode <> 0) and TClient(BattleState.Battle.Clients[i]).isComShareLeader then begin
      ColorList.Add(TClient(BattleState.Battle.Clients[i]).TeamColor);
    end;

  for i:=0 to ColorList.Count -2 do
    for j:=i+1 to ColorList.Count -1 do
      if Misc.ColorDistance(ColorList.Items[i],ColorList.Items[j]) < 80 then begin
        bestVal := Low(Integer);
        r:=0;
        while r <= 255 do begin
          g:=0;
          while g<=255 do begin
            b:=0;
            while b<=255 do begin
              temp := b*65536 + g*256 + r; // $00BBGGRR
              minDist := High(Integer);
              for k:=0 to ColorList.count-1 do
                if k<>i then begin
                  cDistance := Misc.ColorDistance2(temp,ColorList.Items[k]);
                  if cDistance <= bestVal then begin
                    minDist := Low(Integer);
                    break;
                  end;
                  if cDistance < minDist then
                    minDist := cDistance;
                end;
              if minDist > bestVal then begin
                  bestVal := minDist;
                  bestCol := temp;
              end;
              b:=b+10;
            end;
            g:=g+10;
          end;
          r:=r+10;
        end;
        ColorList.Items[i] := bestCol;
      end;

  MainForm.TryToSendCommand('SAYBATTLEEX', 'is fixing colors ...');
  j:=0;
  for i:=0 to BattleState.Battle.Clients.count-1 do
    if (TClient(BattleState.Battle.Clients[i]).GetMode <> 0) and TClient(BattleState.Battle.Clients[i]).isComShareLeader then begin
      for k:=0 to BattleState.Battle.Clients.Count-1 do
        if TClient(BattleState.Battle.Clients[i]).GetTeamNo = TClient(BattleState.Battle.Clients[k]).GetTeamNo then
          //if TClient(BattleState.Battle.Clients[i]).TeamColor <> ColorList.Items[j] then
            MainForm.TryToSendCommand('FORCETEAMCOLOR', TClient(BattleState.Battle.Clients[k]).Name + ' ' + IntToStr(ColorList.Items[j]));
      j := j+1;
    end;
end;

procedure TBattleForm.mnuClearBoxesClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to High(BattleState.StartRects) do begin
    if BattleState.StartRects[i].Enabled then begin
      RemoveStartRect(i);
      MainForm.TryToSendCommand('REMOVESTARTRECT', IntToStr(i));
    end;
  end;
end;

procedure TBattleForm.mnuLoadBoxesClick(Sender: TObject);
var
  Filename: string;
  Ini : TIniFile;
  i: Integer;
  left,top,right,bottom: Integer;
begin
  Filename := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER + '\' + IntToHex(BattleState.Battle.MapHash,8) + '.boxes';
  Ini := TIniFile.Create(Filename);
  if Ini.SectionExists('Box0') then begin
    mnuClearBoxesClick(Sender);
    for i:=0 to High(BattleState.StartRects) do begin
      left := Min(100,StrToInt(Ini.ReadString('Box'+IntToStr(i), 'Left', '0')));
      top := Min(100,StrToInt(Ini.ReadString('Box'+IntToStr(i), 'Top', '0')));
      right := Min(100,StrToInt(Ini.ReadString('Box'+IntToStr(i), 'Right', '0')));
      bottom := Min(100,StrToInt(Ini.ReadString('Box'+IntToStr(i), 'Bottom', '0')));
      if right > 0 then begin
        AddStartRect(i,Rect(left,top,right,bottom));
        MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(i) + ' ' + IntToStr(left*2) + ' ' + IntToStr(top*2) + ' ' + IntToStr(right*2) + ' ' + IntToStr(bottom*2) + ' ');
      end;
    end;
  end;
  Ini.Free;
end;

procedure TBattleForm.mnuSaveBoxesClick(Sender: TObject);
var
  Filename: string;
  Ini : TIniFile;
  i: Integer;
begin
  Filename := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER + '\' + IntToHex(BattleState.Battle.MapHash,8) + '.boxes';
  Ini := TIniFile.Create(Filename);
  for i:=0 to High(BattleState.StartRects) do begin
    if BattleState.StartRects[i].Enabled then begin
      Ini.WriteString('Box'+IntToStr(i), 'Left', IntToStr(BattleState.StartRects[i].Rect.Left));
      Ini.WriteString('Box'+IntToStr(i), 'Top', IntToStr(BattleState.StartRects[i].Rect.Top));
      Ini.WriteString('Box'+IntToStr(i), 'Right', IntToStr(BattleState.StartRects[i].Rect.Right));
      Ini.WriteString('Box'+IntToStr(i), 'Bottom', IntToStr(BattleState.StartRects[i].Rect.Bottom));
    end
    else
    begin
      Ini.WriteString('Box'+IntToStr(i), 'Left', '0');
      Ini.WriteString('Box'+IntToStr(i), 'Top', '0');
      Ini.WriteString('Box'+IntToStr(i), 'Right', '0');
      Ini.WriteString('Box'+IntToStr(i), 'Bottom', '0');
    end;

  end;
  Ini.Free;
end;

procedure TBattleForm.mnuCBalanceTeamsClick(Sender: TObject);
var
  i: integer;
  nb: integer;
begin
  nb := 0;
  for i:=0 to High(BattleState.StartRects) do begin
    if BattleState.StartRects[i].Enabled then nb := nb +1;
  end;
  if nb > 2 then
        AutoTeamsForm.NumOfAlliesSpin.Value := nb;
    AutoTeamsForm.CreatePreview;
    AutoTeamsForm.ApplyCurrentConfiguration;
end;

procedure TBattleForm.mnuBalanceTeamOptionsClick(Sender: TObject);
var
  i: integer;
  nb: integer;
begin
  nb := 0;
  for i:=0 to High(BattleState.StartRects) do begin
    if BattleState.StartRects[i].Enabled then nb := nb +1;
  end;
  if nb > 2 then
    AutoTeamsForm.NumOfAlliesSpin.Value := nb;
  AutoTeamsForm.ShowModal;
end;

procedure TBattleForm.MapDescLabelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SetSelectedStartRect(-1);
end;

procedure TBattleForm.MapPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SetSelectedStartRect(-1);
end;


procedure TBattleForm.BanPlayerItemClick(Sender: TObject);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then begin
      if BattleState.BanList.IndexOf(TClient(BattleState.Battle.Clients[RealIndex]).Id) = -1 then begin
        MainForm.TryToSendCommand('SAYBATTLEEX', 'added '+TClient(BattleState.Battle.Clients[RealIndex]).Name+' to ban list');
        MainForm.TryToSendCommand('KICKFROMBATTLE', TClient(BattleState.Battle.Clients[RealIndex]).Name);
        BattleState.BanList.add(TClient(BattleState.Battle.Clients[RealIndex]).Id);
      end;
    end;
  end;
end;

procedure TBattleForm.mnuLimitRankAutoKickClick(Sender: TObject);
var
  i: integer;
begin
  mnuRankLimitDisabled.Checked := False;
  mnuLimitRankAutoKick.Checked := True;
  mnuLimitRankAutoSpec.Checked := False;

  for i:=1 to BattleState.Battle.Clients.Count-1 do
    if (TClient(BattleState.Battle.Clients[i]).GetRank < BattleState.Battle.RankLimit) then begin
      MainForm.TryToSendCommand('SAYBATTLEEX', '*** Rank limit auto-kick ***');
      MainForm.TryToSendCommand('KICKFROMBATTLE', TClient(BattleState.Battle.Clients[i]).Name);
    end;

  BattleState.AutoKickRankLimit := True;
  BattleState.AutoSpecRankLimit := False;

  MainForm.ResetAutoSpecMsgSentCounters;
end;

procedure TBattleForm.SpTBXItem8Click(Sender: TObject);
begin
  AutoTeamsForm.ShowModal;
end;

procedure TBattleForm.mnuLimitRankAutoSpecClick(Sender: TObject);
var
  i: integer;
begin
  mnuRankLimitDisabled.Checked := False;
  mnuLimitRankAutoKick.Checked := False;
  mnuLimitRankAutoSpec.Checked := True;

  for i:=1 to BattleState.Battle.Clients.Count-1 do
    if (TClient(BattleState.Battle.Clients[i]).GetRank < BattleState.Battle.RankLimit) and (TClient(BattleState.Battle.Clients[i]).GetMode<>0) then begin
      MainForm.TryToSendCommand('SAYBATTLEEX', '*** Rank limit auto-spec : '+TClient(BattleState.Battle.Clients[i]).Name+' ***');
      MainForm.TryToSendCommand('FORCESPECTATORMODE', TClient(BattleState.Battle.Clients[i]).Name);
    end;

  BattleState.AutoSpecRankLimit := True;
  BattleState.AutoKickRankLimit := False;

  MainForm.ResetAutoKickMsgSentCounters;
end;

procedure TBattleForm.mnuRankLimitDisabledClick(Sender: TObject);
begin
  mnuRankLimitDisabled.Checked := True;
  mnuLimitRankAutoKick.Checked := False;
  mnuLimitRankAutoSpec.Checked := False;

  BattleState.AutoSpecRankLimit := False;
  BattleState.AutoKickRankLimit := False;

  MainForm.ResetAutoKickMsgSentCounters;
  MainForm.ResetAutoSpecMsgSentCounters;
end;

procedure TBattleForm.VDTBattleClientsDrawHint(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
  h: String;
begin
  if (Node = nil) then
    Exit;
  HintCanvas.Font.Assign((Sender as TVirtualDrawTree).Canvas.Font);
  HintCanvas.Font.Color := clBlack;
  GetNodeClient(Node.Index,RealIndex,WhatToDraw);
  if RealIndex = -1 then Exit; // shouldn't happen
  if (WhatToDraw = NormalClient) then
  begin
    with Sender as TVirtualDrawTree, HintCanvas do
    begin
      Pen.Color := clBlack;
      Brush.Color := $00ffdddd; { 0 b g r }
      Brush.Style := bsSolid;
      Rectangle(ClipRect);
      Brush.Style := bsClear;
      h := '';
      try
        h := h + TClient(BattleState.Battle.Clients[RealIndex]).Name;
        h := h + ' - '+MainForm.GetCountryName(TClient(BattleState.Battle.Clients[RealIndex]).Country);
        if TClient(BattleState.Battle.Clients[RealIndex]).GetMode <> 0 then
          h := h + ' - ' + Utility.SideList[TClient(BattleState.Battle.Clients[RealIndex]).GetSide];
        if TClient(BattleState.Battle.Clients[RealIndex]).GetGroup <> nil then
          h := h + ' - ' + TClient(BattleState.Battle.Clients[RealIndex]).GetGroup.Name;

        // name history
        if TClient(BattleState.Battle.Clients[RealIndex]).NameHistory.Count > 0 then
          h := h + ' - ('+_('A.K.A.')+' : '+ TClient(BattleState.Battle.Clients[RealIndex]).NameHistory.CommaText + ')';

        TextOut(5, 2, h);
      except
        Exit;
      end;
    end;
  end
  else if (WhatToDraw = NormalBot) then
  begin
    with Sender as TVirtualDrawTree, HintCanvas do
    begin
      Pen.Color := clBlack;
      Brush.Color := $00ffdddd; { 0 b g r }
      Brush.Style := bsSolid;
      Rectangle(ClipRect);
      Brush.Style := bsClear;
      h := '';
      try
        h := h + TBot(BattleState.Battle.Bots[RealIndex]).Name;
        h := h + ' - '+TBot(BattleState.Battle.Bots[RealIndex]).OwnerName;
        h := h + ' - '+TBot(BattleState.Battle.Bots[RealIndex]).AIShortName;
        TextOut(5, 2, h);
      except
        Exit;
      end;
    end;
  end;
end;

procedure TBattleForm.VDTBattleClientsGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
  h: String;
  nameHistory: TWideStringList;
begin
  if (Node = nil) then
    Exit;
  GetNodeClient(Node.Index,RealIndex,WhatToDraw);
  if RealIndex = -1 then Exit; // shouldn't happen
  R := Rect(0, 0, 0, 0);
  if (WhatToDraw = NormalClient) then
  begin
    h := '';
    with (Sender as TVirtualDrawTree) do
    begin
      try
        h := h + TClient(BattleState.Battle.Clients[RealIndex]).Name;
        h := h + ' - '+MainForm.GetCountryName(TClient(BattleState.Battle.Clients[RealIndex]).Country);
        if TClient(BattleState.Battle.Clients[RealIndex]).GetMode <> 0 then
          h := h + ' - ' + Utility.SideList[TClient(BattleState.Battle.Clients[RealIndex]).GetSide];
        if TClient(BattleState.Battle.Clients[RealIndex]).GetGroup <> nil then
          h := h + ' - ' + TClient(BattleState.Battle.Clients[RealIndex]).GetGroup.Name;

        // name history
        if TClient(BattleState.Battle.Clients[RealIndex]).NameHistory.Count > 0 then
          h := h + ' - ('+_('A.K.A.')+' : '+ TClient(BattleState.Battle.Clients[RealIndex]).NameHistory.CommaText + ')';

        R := Rect(0, 0, Canvas.TextWidth(h)+10, 18);
      except
        Exit;
      end;
    end;
  end
  else if (WhatToDraw = NormalBot) then
  begin
    h := '';
    with (Sender as TVirtualDrawTree) do
    begin
      try
        h := h + TBot(BattleState.Battle.Bots[RealIndex]).Name;
        h := h + ' - '+TBot(BattleState.Battle.Bots[RealIndex]).OwnerName;
        h := h + ' - '+TBot(BattleState.Battle.Bots[RealIndex]).AIShortName;
        R := Rect(0, 0, Round(Canvas.TextWidth(h)), 18);
      except
        Exit;
      end;
    end;
  end
end;

procedure TBattleForm.mnuFixTeamsClick(Sender: TObject);
var
  i,j : integer;
  teamNoAvailableList : TList;
  PInt : ^Integer;
begin
  teamNoAvailableList := TList.Create;

  MainForm.TryToSendCommand('SAYBATTLEEX', 'is fixing ids ...');

  {// add 0->15 to the available team no
  for i:=0 to 15 do begin
      New(PInt);
      PInt^ := i;
      teamNoAvailableList.Add(PInt);
  end;

  // remove the team no already in use
  for i:=0 to BattleState.Battle.Clients.Count -1 do
    for j:= 0 to teamNoAvailableList.Count-1 do
      if (TClient(BattleState.Battle.Clients[i]).GetTeamNo = Integer(teamNoAvailableList[j]^)) and (TClient(BattleState.Battle.Clients[i]).GetMode <> 0) then begin
         teamNoAvailableList.Delete(j);
         Break;
      end;

  // find comsharers and fix their teams
  for i:=0 to BattleState.Battle.Clients.Count -2 do
    for j:=i+1 to BattleState.Battle.Clients.Count -1 do
      if (TClient(BattleState.Battle.Clients[i]).GetTeamNo = TClient(BattleState.Battle.Clients[j]).GetTeamNo)  and (TClient(BattleState.Battle.Clients[i]).GetMode <> 0) and (TClient(BattleState.Battle.Clients[j]).GetMode <> 0) then begin
         MainForm.TryToSendCommand('FORCETEAMNO', TClient(BattleState.Battle.Clients[j]).Name + ' ' + IntToStr(Integer(teamNoAvailableList[0]^)));
         teamNoAvailableList.Delete(0);
      end;

  teamNoAvailableList.Destroy;}

  j:=0;
  for i:=0 to BattleState.Battle.Clients.Count -1 do
    if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then
    begin
      MainForm.TryToSendCommand('FORCETEAMNO', TClient(BattleState.Battle.Clients[i]).Name + ' ' + IntToStr(j));
      if mnuBlockTeams.Checked then
        TClient(BattleState.Battle.Clients[i]).SetTeamNo(j);
      j := j+1;
    end;
end;

procedure TBattleForm.mnuBlockTeamsClick(Sender: TObject);
begin
  mnuBlockTeams.Checked := not mnuBlockTeams.Checked;
end;

procedure TBattleForm.RingItemClick(Sender: TObject);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      MainForm.ProcessCommand('RING '+TClient(BattleState.Battle.Clients[RealIndex]).Name, True);
    end;
  end;
end;

procedure TBattleForm.VDTBattleClientsHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if Preferences.BattleClientSortStyle = HitInfo.Column then
    Preferences.BattleClientSortDirection := not Preferences.BattleClientSortDirection
  else
  begin
    Preferences.BattleClientSortStyle := HitInfo.Column;
    Preferences.BattleClientSortDirection := False;
  end;
  SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
  SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
  VDTBattleClients.Refresh;
end;

procedure TBattleForm.lblMetalClick(Sender: TObject);
begin
  MetalTracker.Position := Misc.InputBoxInteger(_('Metal custom value'),_('Enter value :'),MetalTracker.Position,MetalTracker.Min,MetalTracker.Max);
  MetalTrackerChange(nil);
end;

procedure TBattleForm.lblEnergyClick(Sender: TObject);
begin
  EnergyTracker.Position := Misc.InputBoxInteger(_('Energy custom value'),_('Enter value :'),EnergyTracker.Position,EnergyTracker.Min,EnergyTracker.Max);
  EnergyTrackerChange(nil);
end;

procedure TBattleForm.lblUnitsClick(Sender: TObject);
begin
  UnitsTracker.Position := Misc.InputBoxInteger(_('Units custom value'),_('Enter units :'),UnitsTracker.Position,UnitsTracker.Min,UnitsTracker.Max);
  UnitsTrackerChange(nil);
end;


procedure TBattleForm.ChangeScriptTagValue(completeKey: String; value: String);
begin
  if UnknownScriptTagList.CompleteKeyList.IndexOf(LowerCase(completeKey)) > 0 then
    UnknownScriptTagList.ValueList[UnknownScriptTagList.CompleteKeyList.IndexOf(LowerCase(completeKey))] := value
  else
  begin
    BattleForm.UnknownScriptTagList.CompleteKeyList.Add(LowerCase(completeKey));
    BattleForm.UnknownScriptTagList.ValueList.Add(value);
  end;
end;

procedure TBattleForm.SendLuaOptionsDetailsToServer;
var
  i: Integer;
  s: string;
  sBefore: string;
begin
  if not (BattleState.Status = Hosting) then Exit;
  if not AllowBattleDetailsUpdate then Exit;
  if not BattleState.JoiningComplete then Exit;

  s := '';
  for i:=0 to ModOptionsList.Count -1 do
    if TLuaOption(ModOptionsList[i]).ClassType <> TLuaOptionSection then
    begin
      sBefore := s;
      if s <> '' then
        s := s + #9;
      s := s+TLuaOption(ModOptionsList[i]).toSetScriptTagsString;
      if Length(s)+15 >= 1024 then
      begin
        MainForm.TryToSendCommand('SETSCRIPTTAGS', sBefore);
        s := TLuaOption(ModOptionsList[i]).toSetScriptTagsString;
      end;
    end;

  for i:=0 to MapOptionsList.Count -1 do
    if TLuaOption(MapOptionsList[i]).ClassType <> TLuaOptionSection then
    begin
      sBefore := s;
      if s <> '' then
        s := s + #9;
      s := s+TLuaOption(MapOptionsList[i]).toSetScriptTagsString;
      if Length(s)+15 >= 1024 then
      begin
        MainForm.TryToSendCommand('SETSCRIPTTAGS', sBefore);
        s := TLuaOption(MapOptionsList[i]).toSetScriptTagsString;
      end;
    end;

  if Length(s) > 0 then
    MainForm.TryToSendCommand('SETSCRIPTTAGS', s);
end;

procedure TBattleForm.FormResize(Sender: TObject);
begin
  FixFormSizeConstraints(BattleForm);
end;

procedure TBattleForm.SpTBXTabControl1ActiveTabChange(Sender: TObject;
  TabIndex: Integer);
begin
  SpTBXTabControl1.ActivePage.Item.FontSettings.Style := [];
end;

procedure TBattleForm.mnuNewGroupClick(Sender: TObject);
begin
  MainForm.mnuNewGroupClick(nil);
end;

procedure TBattleForm.mnuPlayerManueClick(Sender: TObject);
begin
  MainForm.mnuRemoveFromGroupClick(nil);
end;

procedure TBattleForm.btLoadModsDefaultMDOClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to ModOptionsList.Count -1 do
    TLuaOption(ModOptionsList[i]).setToDefault;

  SendLuaOptionsDetailsToServer;
end;

procedure TBattleForm.btLoadMapsDefaultMPOClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to MapOptionsList.Count -1 do
    TLuaOption(MapOptionsList[i]).setToDefault;

  SendLuaOptionsDetailsToServer;
end;

procedure TBattleForm.SaveModOptionsAsDefault;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
begin
  try
    Filename := ExtractFilePath(Application.ExeName) + MODS_CACHE_FOLDER + '\' + BattleState.Battle.ModName +'.ini';
    if FileExists(Filename) then
      DeleteFile(Filename);
    Ini := TIniFile.Create(Filename);
    for i:=0 to ModOptionsList.Count -1 do
      Ini.WriteString('ModOptions', TLuaOption(ModOptionsList[i]).Key, TLuaOption(ModOptionsList[i]).toString);
    Ini.Free;
  except
    Exit;
  end;
end;

procedure TBattleForm.LoadModOptionsDefault(modName: string);
var
  Filename: string;
  Ini : TIniFile;
  i: Integer;
begin
  Filename := ExtractFilePath(Application.ExeName) + MODS_CACHE_FOLDER + '\' + modName +'.ini';
  Ini := TIniFile.Create(Filename);
  if Ini.SectionExists('ModOptions') then
  begin
    for i:=0 to ModOptionsList.Count -1 do
      TLuaOption(ModOptionsList[i]).SetValue(Ini.ReadString('ModOptions', TLuaOption(ModOptionsList[i]).Key, TLuaOption(ModOptionsList[i]).DefaultValue));
  end;
  Ini.Free;
  SendLuaOptionsDetailsToServer;
end;

procedure TBattleForm.SaveMapOptionsAsDefault;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
begin
  try
    Filename := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER + '\' + IntToStr(Utility.MapChecksums.Items[CurrentMapIndex]) +'.options';
    if FileExists(Filename) then
      DeleteFile(Filename);
    Ini := TIniFile.Create(Filename);
    for i:=0 to MapOptionsList.Count -1 do
      Ini.WriteString('MapOptions', TLuaOption(MapOptionsList[i]).Key, TLuaOption(MapOptionsList[i]).toString);
    Ini.Free;
  except
    Exit;
  end;
end;

procedure TBattleForm.LoadMapOptionsDefault;
var
  Filename: string;
  Ini : TIniFile;
  i: Integer;
begin
  Filename := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER + '\' + IntToStr(Utility.MapChecksums.Items[CurrentMapIndex]) +'.options';

  if FileExists(Filename) then
  begin
    Ini := TIniFile.Create(Filename);
    if Ini.SectionExists('MapOptions') then
    begin
      for i:=0 to MapOptionsList.Count -1 do
      begin
        TLuaOption(MapOptionsList[i]).SetValue(Ini.ReadString('MapOptions', TLuaOption(MapOptionsList[i]).Key, TLuaOption(MapOptionsList[i]).DefaultValue));
      end;
    end;
    Ini.Free;
  end
  else
  begin
    for i:=0 to MapOptionsList.Count -1 do
    begin
      TLuaOption(MapOptionsList[i]).SetValue(TLuaOption(MapOptionsList[i]).DefaultValue);
    end;
  end;
  SendLuaOptionsDetailsToServer;
end;

procedure TBattleForm.btSetAsDefaultMDOClick(Sender: TObject);
begin
  SaveModOptionsAsDefault;
end;

procedure TBattleForm.btSetAsDefaultMPOClick(Sender: TObject);
begin
  SaveMapOptionsAsDefault;
end;

procedure TBattleForm.btLoadDefaultMDOClick(Sender: TObject);
begin
  LoadModOptionsDefault(BattleState.Battle.ModName);
end;

procedure TBattleForm.btLoadDefaultMPOClick(Sender: TObject);
begin
  LoadMapOptionsDefault;
end;

procedure TBattleForm.KeepRatioItemClick(Sender: TObject);
begin
  MinimapPanelResize(nil);
end;

procedure TBattleForm.PopulateDisabledUnitsVDT;
begin
  VDTDisabledUnits.Clear;
  if Preferences.DisplayUnitsIconsAndNames then
    BattleForm.VDTDisabledUnits.DefaultNodeHeight := 64
  else
    BattleForm.VDTDisabledUnits.DefaultNodeHeight := 16;
  VDTDisabledUnits.RootNodeCount := BattleState.DisabledUnits.Count;
  DisabledUnitsTab.Caption := _('Disabled Units (')+IntToStr(BattleState.DisabledUnits.Count)+')';
end;

procedure TBattleForm.VDTDisabledUnitsDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  s: WideString;
  R: TRect;
  availableWidth: integer;
  availableHeight: integer;
  nodeIndex : integer;
  BgRect: TRect;
  pt: TPoint;
  hot: Boolean;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
begin
  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    nodeIndex := UnitList.IndexOf(BattleState.DisabledUnits[Node.index]);

    GetCursorPos(pt);
    pt := ScreenToClient(pt);
    GetHitTestInfoAt(pt.X,pt.Y,True,hi);

    hot := (SkinManager.GetSkinType=sknSkin) and BattleForm.Active and (hi.HitNode = Node);

    CopyRect(BgRect,CellRect);
    if Position <> 0 then
      BgRect.Left := -5;
    if Position <> Header.Columns.Count-1 then
      BgRect.Right := BgRect.Right+5;

    if SkinManager.GetSkinType=sknSkin then
    begin
      itemState := SkinManager.CurrentSkin.GetState(True,False,hot,(Node = FocusedNode) and focused);
      Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,itemState);
      SkinManager.CurrentSkin.PaintBackground(Canvas,BgRect,skncListItem,itemState,True,True);
      Canvas.Brush.Style := Graphics.bsClear;
    end
    else if (Node = FocusedNode) and focused then
    begin
      Canvas.Font.Color := clHighlightText;
      Canvas.Brush.Color := clHighlight;
      Canvas.FillRect(CellRect);
    end
    else
      Canvas.Font.Color := clWindowText;

    R := ContentRect;
    if Column <> 0 then
    begin
      InflateRect(R, -TextMargin, 0);
      Dec(R.Right);
      Dec(R.Bottom);
    end;
    s := '';

    case Column of
      0:
      begin
        if (nodeIndex > -1) and (Preferences.DisplayUnitsIconsAndNames or (HostBattleForm.relayHoster <> nil)) and (nodeIndex < UnitBitmaps.Count) and (TBitmap(UnitBitmaps[nodeIndex]).Width > 0) then
        begin
          availableWidth := R.Right-R.Left;
          availableHeight := R.Bottom-R.Top;

          if TBitmap(UnitBitmaps[nodeIndex]).Width > 0 then
          begin
            if (TBitmap(UnitBitmaps[nodeIndex]).Width/TBitmap(UnitBitmaps[nodeIndex]).Height) > (availableWidth/availableHeight) then
              Canvas.StretchDraw(Rect(R.Left,R.Top+2,R.Right,R.Top+2+Round(availableWidth*TBitmap(UnitBitmaps[nodeIndex]).Height/TBitmap(UnitBitmaps[nodeIndex]).Width)),TBitmap(UnitBitmaps[nodeIndex]))
            else
              Canvas.StretchDraw(Rect(R.Left,R.Top+2,R.Left+Round(availableHeight*TBitmap(UnitBitmaps[nodeIndex]).Width/TBitmap(UnitBitmaps[nodeIndex]).Height),R.Bottom),TBitmap(UnitBitmaps[nodeIndex]));
          end;
        end;
      end;
      1:
        if (nodeIndex > -1) and (Preferences.DisplayUnitsIconsAndNames or (HostBattleForm.relayHoster <> nil)) then
          s := UnitNames[nodeIndex]; // unit name
      2:
        s := BattleState.DisabledUnits[Node.index]; // unit "code name"
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

procedure TBattleForm.ChatExRichEditDblClick(Sender: TObject);
begin
   MainForm.RichEditDblClick(Sender);
end;

procedure TBattleForm.ChatRichEditMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MainForm.RichEditMouseDown(Sender,Button,Shift,X,Y);
end;

procedure TBattleForm.DownloadMapButtonClick(Sender: TObject);
begin
  if (CurrentMapIndex = -1) and BattleForm.IsBattleActive then
  begin
    ReloadMapListButtonClick(nil);
    if CurrentMapIndex = -1 then
      SpringDownloaderFormUnit.DownloadMap(BattleState.Battle.MapHash,BattleState.Battle.Map);
  end;
end;

procedure TBattleForm.MapListFilterTextBoxChange(Sender: TObject;
  const Text: WideString);
begin
  PopulatePopupMenuMapListF(Text);
end;

procedure TBattleForm.MapsPopupMenuPopup(Sender: TObject);
begin
  MapSelectionForm.SetFocus;
  MapSelectionForm.FilterTextBox.SetFocus;
end;

procedure TBattleForm.InputEditChange(Sender: TObject);
begin
  MainForm.InputEditChange(Sender);
end;

procedure TBattleForm.OnlineMapsButtonClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(MAPS_PAGE_LINK);
end;

procedure TBattleForm.OnlineModsButtonClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(MODS_PAGE_LINK);
end;

procedure TBattleForm.MinimapPanelResize(Sender: TObject);
var
  index: integer;
  map : TMapItem;
  mapImgSpaceWidth,mapImgSpaceHeight : double;
begin
  //if not MapSelectionForm.MapListBox.Enabled then
    //Exit;
  mapImgSpaceWidth := MinimapPanel.Width;
  mapImgSpaceHeight := MinimapPanel.Height;
  if CurrentMapIndex = -1 then
  begin
    if mapImgSpaceWidth > mapImgSpaceHeight then
    begin
      MapImage.Anchors := [akLeft,akTop,akRight];
      MapImage.Height := Round(mapImgSpaceHeight);
      MapImage.Width := Round(mapImgSpaceHeight);
    end
    else
    begin
      MapImage.Anchors := [akLeft,akTop,akBottom];
      MapImage.Width := Round(mapImgSpaceWidth);
      MapImage.Height :=  Round(mapImgSpaceWidth);
    end;
    RefreshStartRectsPosAndSize;
    Exit;
  end;
  map := GetMapItem(CurrentMapIndex);
  if not map.MapInfoLoaded or (map.MapInfo.Width <= 0) or (map.MapInfo.Height <= 0) then
  begin
    MapImage.Anchors := [akLeft,akTop,akBottom,akRight];
    MapImage.Height := Round(mapImgSpaceHeight);
    MapImage.Width := Round(mapImgSpaceWidth);
    RefreshStartRectsPosAndSize;
    Exit
  end;
  if KeepRatioItem.Checked then
    if (map.MapInfo.Width/map.MapInfo.Height) > (mapImgSpaceWidth/mapImgSpaceHeight) then
    begin
      MapImage.Align := alNone;
      MapImage.Anchors := [akLeft,akTop,akRight];
      MapImage.Height := Round(mapImgSpaceWidth*map.MapInfo.Height/map.MapInfo.Width);
      MapImage.Width := Round(mapImgSpaceWidth);
    end
    else
    begin
      MapImage.Align := alNone;
      MapImage.Anchors := [akLeft,akTop,akBottom];
      MapImage.Width := Round(mapImgSpaceHeight*map.MapInfo.Width/map.MapInfo.Height);
      MapImage.Height :=  Round(mapImgSpaceHeight);
    end
  else
  begin
    MapImage.Align := alClient;
    MapImage.Height := Round(mapImgSpaceHeight);
    MapImage.Width := Round(mapImgSpaceWidth);
  end;
  RefreshStartRectsPosAndSize;
end;

procedure TBattleForm.Button2Click(Sender: TObject);
var
  i,j,v:integer;
  P: PByteArray;
begin
  MapImage.Picture.Graphic.Width := MapHeightWidth;
  MapImage.Picture.Graphic.Height := MapHeightHeight;
  MapImage.Picture.Bitmap.PixelFormat := pf24bit;

  for j:=0 to MapHeightHeight-1 do
  begin
    P := MapImage.Picture.Bitmap.ScanLine[j];
    for i:=0 to MapHeightWidth-1 do
    begin
      v := Ord(MapHeight[j*MapHeightWidth+i]);
      P[i*3] := v;
      P[i*3+1] := v;
      P[i*3+2] := v;
    end;
  end;
end;

procedure TBattleForm.MetalMapPanelResize(Sender: TObject);
var
  index: integer;
  map : TMapItem;
  mapImgSpaceWidth,mapImgSpaceHeight : double;
begin
  //if not MapSelectionForm.MapListBox.Enabled then
    //Exit;
  mapImgSpaceWidth := MetalMapPanel.Width;
  mapImgSpaceHeight := MetalMapPanel.Height;
  if CurrentMapIndex = -1 then
  begin
    if mapImgSpaceWidth > mapImgSpaceHeight then
    begin
      MetalMapImage.Anchors := [akLeft,akTop,akRight];
      MetalMapImage.Height := Round(mapImgSpaceHeight);
      MetalMapImage.Width := Round(mapImgSpaceHeight);
    end
    else
    begin
      MetalMapImage.Anchors := [akLeft,akTop,akBottom];
      MetalMapImage.Width := Round(mapImgSpaceWidth);
      MetalMapImage.Height :=  Round(mapImgSpaceWidth);
    end;
    RefreshStartRectsPosAndSize;
    Exit;
  end;
  map := GetMapItem(CurrentMapIndex);
  if not map.MapInfoLoaded or (map.MapInfo.Width <= 0) or (map.MapInfo.Height <= 0) then
  begin
    MetalMapImage.Anchors := [akLeft,akTop,akBottom,akRight];
    MetalMapImage.Height := Round(mapImgSpaceHeight);
    MetalMapImage.Width := Round(mapImgSpaceWidth);
    RefreshStartRectsPosAndSize;
    Exit
  end;
  if KeepRatioItem.Checked then
    if (map.MapInfo.Width/map.MapInfo.Height) > (mapImgSpaceWidth/mapImgSpaceHeight) then
    begin
      MetalMapImage.Align := alNone;
      MetalMapImage.Anchors := [akLeft,akTop,akRight];
      MetalMapImage.Height := Round(mapImgSpaceWidth*map.MapInfo.Height/map.MapInfo.Width);
      MetalMapImage.Width := Round(mapImgSpaceWidth);
    end
    else
    begin
      MetalMapImage.Align := alNone;
      MetalMapImage.Anchors := [akLeft,akTop,akBottom];
      MetalMapImage.Width := Round(mapImgSpaceHeight*map.MapInfo.Width/map.MapInfo.Height);
      MetalMapImage.Height :=  Round(mapImgSpaceHeight);
    end
  else
  begin
    MetalMapImage.Align := alClient;
    MetalMapImage.Height := Round(mapImgSpaceHeight);
    MetalMapImage.Width := Round(mapImgSpaceWidth);
  end;
  RefreshStartRectsPosAndSize;
end;

procedure TBattleForm.HeightMapPanelResize(Sender: TObject);
var
  index: integer;
  map : TMapItem;
  mapImgSpaceWidth,mapImgSpaceHeight : double;
begin
  //if not MapSelectionForm.MapListBox.Enabled then
    //Exit;
  mapImgSpaceWidth :=  HeightMapPanel.Width;
  mapImgSpaceHeight := HeightMapPanel.Height;
  if CurrentMapIndex = -1 then
  begin
    if mapImgSpaceWidth > mapImgSpaceHeight then
    begin
      HeightMapImage.Anchors := [akLeft,akTop,akRight];
      HeightMapImage.Height := Round(mapImgSpaceHeight);
      HeightMapImage.Width := Round(mapImgSpaceHeight);
    end
    else
    begin
      HeightMapImage.Anchors := [akLeft,akTop,akBottom];
      HeightMapImage.Width := Round(mapImgSpaceWidth);
      HeightMapImage.Height :=  Round(mapImgSpaceWidth);
    end;
    RefreshStartRectsPosAndSize;
    Exit;
  end;
  map := GetMapItem(CurrentMapIndex);
  if not map.MapInfoLoaded or (map.MapInfo.Width <= 0) or (map.MapInfo.Height <= 0) then
  begin
    HeightMapImage.Anchors := [akLeft,akTop,akBottom,akRight];
    HeightMapImage.Height := Round(mapImgSpaceHeight);
    HeightMapImage.Width := Round(mapImgSpaceWidth);
    RefreshStartRectsPosAndSize;
    Exit
  end;
  if KeepRatioItem.Checked then
    if (map.MapInfo.Width/map.MapInfo.Height) > (mapImgSpaceWidth/mapImgSpaceHeight) then
    begin
      HeightMapImage.Align := alNone;
      HeightMapImage.Anchors := [akLeft,akTop,akRight];
      HeightMapImage.Height := Round(mapImgSpaceWidth*map.MapInfo.Height/map.MapInfo.Width);
      HeightMapImage.Width := Round(mapImgSpaceWidth);
    end
    else
    begin
      HeightMapImage.Align := alNone;
      HeightMapImage.Anchors := [akLeft,akTop,akBottom];
      HeightMapImage.Width := Round(mapImgSpaceHeight*map.MapInfo.Width/map.MapInfo.Height);
      HeightMapImage.Height :=  Round(mapImgSpaceHeight);
    end
  else
  begin
    HeightMapImage.Align := alClient;
    HeightMapImage.Height := Round(mapImgSpaceHeight);
    HeightMapImage.Width := Round(mapImgSpaceWidth);
  end;
  RefreshStartRectsPosAndSize;
end;

procedure TBattleForm.MapsTabsActiveTabChange(Sender: TObject;
  TabIndex: Integer);
begin
  SetSelectedStartRect(-1);
  if TabIndex = 0 then
    MapImageMouseMove(MapImage,[],0,0)
  else if TabIndex = 1 then
    MapImageMouseMove(MetalMapImage,[],0,0)
  else if TabIndex = 2 then
    MapImageMouseMove(HeightMapImage,[],0,0);
end;

procedure TBattleForm.RefreshQuickLookText;
var
  i: integer;
  SelStart, SelLength: Integer;
  p: TPoint;
  tmpStr: string;
  procedure SetTitleAttr;
  begin
    QuickLookRichEdit.SelAttributes.Name := 'MS Sans Serif';
    QuickLookRichEdit.SelAttributes.Style := [fsBold];
    QuickLookRichEdit.SelAttributes.Size := 14;
    QuickLookRichEdit.SelAttributes.Color := Colors.Normal;
  end;
  procedure SetNormalAttr;
  begin
    QuickLookRichEdit.SelAttributes.Name := 'MS Sans Serif';
    QuickLookRichEdit.SelAttributes.Style := [];
    QuickLookRichEdit.SelAttributes.Size := 8;
    QuickLookRichEdit.SelAttributes.Color := Colors.Normal;
  end;
  procedure SetSectionAttr;
  begin
    SetNormalAttr;
    QuickLookRichEdit.SelAttributes.Style := [fsBold, fsUnderline];
  end;
  procedure SetNotDefaultAttr;
  begin
    QuickLookRichEdit.SelAttributes.Color := Colors.BattleDetailsNonDefault;
  end;
  procedure SetHasChangedAttr;
  begin
    QuickLookRichEdit.SelAttributes.Name := 'MS Sans Serif';
    QuickLookRichEdit.SelAttributes.Style := [fsBold];
    QuickLookRichEdit.SelAttributes.Size := 8;
    QuickLookRichEdit.SelAttributes.Color := Colors.BattleDetailsChanged;
  end;
  procedure AddTitle(str: string);
  begin
    SetTitleAttr;
    QuickLookRichEdit.SelText := str+EOL;
    QuickLookHints.Add(str);
  end;
procedure AddSection(caption: string; hint: string);
  begin
    SetSectionAttr;
    QuickLookRichEdit.SelText := caption+EOL;
    QuickLookHints.Add(hint);
  end;
  procedure AddLine(caption: string;value: string;defaultValue: boolean = false; valueHasChanged: boolean = false; hint: string = '');
  begin
    if valueHasChanged then
      SetHasChangedAttr
    else
      SetNormalAttr;
    QuickLookRichEdit.SelText := '    ' + caption +': ';
    QuickLookRichEdit.SelAttributes.Style := [fsBold];
    if not defaultValue then
      SetNotDefaultAttr;
    QuickLookRichEdit.SelText := value + EOL;
    QuickLookHints.Add(hint);
  end;
begin
  // stop redrawing
  SendMessage(QuickLookRichEdit.Handle, WM_SETREDRAW, 0, 0);

  // save the scroll pos and selection
  SelStart := QuickLookRichEdit.SelStart;
  SelLength := QuickLookRichEdit.SelLength;
  SendMessage(QuickLookRichEdit.Handle, WM_USER + 221 {EM_GETSCROLLPOS},  0, LPARAM(@p));

  QuickLookRichEdit.Lines.BeginUpdate;
  QuickLookRichEdit.Text := '';

  if not BattleForm.IsBattleActive then
  begin
    QuickLookRichEdit.Lines.EndUpdate;
    Exit;
  end;

  QuickLookHints.Clear;

  AddTitle(_('Game options'));
  AddLine('Start position',StartPosRadioGroup.Items[StartPosRadioGroup.ItemIndex],true,StartPosRadioGroup.ItemIndex <> StartPosRadioGroup.Tag,StartPosRadioGroup.Hint);
  if GameEndRadioGroup.Visible and (GameEndRadioGroup.ItemIndex > -1) then
    AddLine('Game end condition',GameEndRadioGroup.Items[GameEndRadioGroup.ItemIndex],true,GameEndRadioGroup.ItemIndex <> GameEndRadioGroup.Tag,GameEndRadioGroup.Hint);
  if MetalTracker.Visible then
    AddLine(lblMetal.Caption,IntToStr(MetalTracker.Position),true,MetalTracker.Position <> MetalTracker.Tag,MetalTracker.Hint);
  if EnergyTracker.Visible then
    AddLine(lblEnergy.Caption,IntToStr(EnergyTracker.Position),true,EnergyTracker.Position <> EnergyTracker.Tag,EnergyTracker.Hint);
  if UnitsTracker.Visible then
    AddLine(lblUnits.Caption,IntToStr(UnitsTracker.Position),true,UnitsTracker.Position <> UnitsTracker.Tag,UnitsTracker.Hint);

  if ModOptionsList.Count > 0 then
  begin
    AddTitle(_('Mod options'));
    for i:=0 to ModOptionsList.Count-1 do
      if TLuaOption(ModOptionsList[i]).ClassType = TLuaOptionSection then
        AddSection(TLuaOption(ModOptionsList[i]).Name,TLuaOption(ModOptionsList[i]).getDescription)
      else if TLuaOption(ModOptionsList[i]).ClassType = TLuaOptionBool then
        AddLine(TLuaOption(ModOptionsList[i]).Name,BoolToStr(TLuaOption(ModOptionsList[i]).toString <> '0',true),TLuaOption(ModOptionsList[i]).isDefault,TLuaOption(ModOptionsList[i]).hasChanged,TLuaOption(ModOptionsList[i]).getDescription)
      else if TLuaOption(ModOptionsList[i]).ClassType = TLuaOptionList then
        AddLine(TLuaOption(ModOptionsList[i]).Name,TLuaOptionList(ModOptionsList[i]).nameToString,TLuaOption(ModOptionsList[i]).isDefault,TLuaOption(ModOptionsList[i]).hasChanged,TLuaOption(ModOptionsList[i]).getDescription)
      else
        AddLine(TLuaOption(ModOptionsList[i]).Name,TLuaOption(ModOptionsList[i]).toString,TLuaOption(ModOptionsList[i]).isDefault,TLuaOption(ModOptionsList[i]).hasChanged,TLuaOption(ModOptionsList[i]).getDescription);
  end;

  if MapOptionsList.Count > 0 then
  begin
    AddTitle(_('Map options'));
    for i:=0 to MapOptionsList.Count-1 do
      if TLuaOption(MapOptionsList[i]).ClassType = TLuaOptionSection then
        AddSection(TLuaOption(MapOptionsList[i]).Name,TLuaOption(MapOptionsList[i]).getDescription)
      else if TLuaOption(MapOptionsList[i]).ClassType = TLuaOptionBool then
        AddLine(TLuaOption(MapOptionsList[i]).Name,BoolToStr(TLuaOption(MapOptionsList[i]).toString <> '0',true),TLuaOption(MapOptionsList[i]).isDefault,TLuaOption(MapOptionsList[i]).hasChanged,TLuaOption(MapOptionsList[i]).getDescription)
      else if TLuaOption(MapOptionsList[i]).ClassType = TLuaOptionList then
        AddLine(TLuaOption(MapOptionsList[i]).Name,TLuaOptionList(MapOptionsList[i]).nameToString,TLuaOption(MapOptionsList[i]).isDefault,TLuaOption(MapOptionsList[i]).hasChanged,TLuaOption(MapOptionsList[i]).getDescription)
      else
        AddLine(TLuaOption(MapOptionsList[i]).Name,TLuaOption(MapOptionsList[i]).toString,TLuaOption(MapOptionsList[i]).isDefault,TLuaOption(MapOptionsList[i]).hasChanged,TLuaOption(MapOptionsList[i]).getDescription);
  end;

  if BattleState.DisabledUnits.Count > 0 then
  begin
    AddTitle(_('Disabled units'));
    SetNormalAttr;
    if Preferences.DisplayUnitsIconsAndNames then
    begin
      for i:=0 to BattleState.DisabledUnits.Count-1 do
        tmpStr := tmpStr + UnitNames[UnitList.IndexOf(BattleState.DisabledUnits[i])] + EOL;
      QuickLookRichEdit.SelText := tmpStr;
    end
    else
      QuickLookRichEdit.SelText := BattleState.DisabledUnits.Text;
  end;
  QuickLookRichEdit.SelText := #0;

  // restore scroll pos and selection
  QuickLookRichEdit.SelStart := SelStart;
  QuickLookRichEdit.SelLength := SelLength;
  SendMessage(QuickLookRichEdit.Handle, WM_USER + 222 {EM_SETSCROLLPOS}, 0, LPARAM(@p));

  QuickLookRichEdit.Lines.EndUpdate;

  // redraw
  SendMessage(QuickLookRichEdit.Handle, WM_SETREDRAW, 1, 0);
  QuickLookRichEdit.Invalidate;
end;

function GetWindowHwnd(Handle : HWND; lParam : LPARAM) : Boolean;stdcall;
begin
  if BattleState.Process.WindowHandle = 0 then
    BattleState.Process.WindowHandle := Handle;
  Result := True;
end;

procedure TBattleForm.SpTBXItem59Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!spec '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.QuickLookChangedTmrTimer(Sender: TObject);
var
  i: integer;
begin
  for i:=0 To ModOptionsList.Count-1 do
    TLuaOption(ModOptionsList[i]).hasChanged := False;

  for i:=0 To MapOptionsList.Count-1 do
    TLuaOption(MapOptionsList[i]).hasChanged := False;

  StartPosRadioGroup.Tag := StartPosRadioGroup.ItemIndex;
  GameEndRadioGroup.Tag := GameEndRadioGroup.ItemIndex;
  MetalTracker.Tag := MetalTracker.Position;
  EnergyTracker.Tag := EnergyTracker.Position;
  UnitsTracker.Tag := UnitsTracker.Position;

  RefreshQuickLookText;

  QuickLookChangedTmr.Enabled := False;
end;

procedure TBattleForm.OnSpringSettingsProfileItemClick(Sender: TObject);
var
  i: integer;
begin
  SpringSettingsProfile := SpringSettingsProfileForm.cpNames[TSpTBXItem(Sender).Tag];;
end;

procedure TBattleForm.sspDefaultItemClick(Sender: TObject);
var
  i: integer;
begin
  SpringSettingsProfile := '';
end;

procedure TBattleForm.QuickLookRichEditMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
   ci, //Character Index
   lix, //Line Index
   co: integer; //Character Offset
   Pt: TPoint;
   s: string;
   Key: string;
   mapOptionsLine: integer;
   modOptionsLine: integer;
   i: integer;
begin
   with TRichEdit(Sender) do
   begin
    try
     Pt := Point(X, Y);
     ci := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@Pt));
     if ci < 0 then Exit;
     lix := Perform(EM_EXLINEFROMCHAR, 0, ci) ;

     if lix < QuickLookHints.Count then
      Hint := QuickLookHints[lix];

    except
    end;
   end;
end;

procedure TBattleForm.MyTeamNoButtonExit(Sender: TObject);
begin
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

procedure TBattleForm.MyAllyNoButtonExit(Sender: TObject);
begin
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

procedure TBattleForm.VDTBattleClientsDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  GetNodeClient(Node.Index,RealIndex,WhatToDraw);
  Allowed := WhatToDraw =NormalClient;
end;

procedure TBattleForm.Button1Click(Sender: TObject);
begin

end;

{procedure TBattleForm.NumbersCellClick(Sender: TTBXCustomToolPalette;
  var ACol, ARow: Integer; var AllowChange: Boolean);
begin
  TSpTBXSpinEdit(NumberSelection.Tag).Value := 1+ACol+ARow*10;
  TSpTBXSpinEdit(NumberSelection.Tag).OnExit(nil);
end;}

{procedure TBattleForm.MyTeamNoButtonContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  Handled := False;
  NumberSelection.Tag := Integer(MyTeamNoButton);
  Numbers.SelectedCell := Point((MyTeamNoButton.ValueAsInteger Mod 10)-1,Floor(MyTeamNoButton.ValueAsInteger/10));
end;

procedure TBattleForm.MyAllyNoButtonContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  Handled := False;
  NumberSelection.Tag := Integer(MyAllyNoButton);
  Numbers.SelectedCell := Point((MyAllyNoButton.ValueAsInteger Mod 10)-1,Floor(MyAllyNoButton.ValueAsInteger/10));
end; }

procedure TBattleForm.AutoHostMsgFlashTimerTimer(Sender: TObject);
begin
  if AutoHostInfoIcon.Tag > 0 then
  begin
    AutoHostInfoIcon.Tag := AutoHostInfoIcon.Tag - 1;
    AutoHostInfoIcon.Visible := not AutoHostInfoIcon.Visible;
  end
  else
    AutoHostInfoIcon.Visible := False;

  AutoHostVoteIcon.Visible := not AutoHostVoteIcon.Visible;
end;

procedure TBattleForm.AutoHostInfoMsgsDrawItemBackground(
  Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  // do nothing;
end;

procedure TBattleForm.AutoHostInfoMsgsDrawItem(Control: TWinControl;
  Index: Integer; R: TRect; State: TOwnerDrawState);
type
  TWrapRecord=record
    Height:Integer;
    Lines: array of string;
  end;

  function WrapText(Canvas:TCanvas; Text:string; const MaxWidth:integer):TWrapRecord;
  var
    S:string;
    CurrWidth:integer;
  begin
    SetLength(Result.Lines,0);
    Result.Height:=0;
    CurrWidth:=MaxWidth;
    Text:=Text+' ';
    repeat
      S:=copy(Text,1,pos(' ',Text)-1);
      Delete(Text,1,pos(' ',Text));

      if (Canvas.TextWidth(S+' ')+CurrWidth)<=MaxWidth then
      begin
        with Result do Lines[High(Lines)]:=Lines[High(Lines)] + ' ' +S;
        Inc(CurrWidth, Canvas.TextWidth(S+' '));
      end
      else with Result do
      begin
        if length(Lines)>0 then Inc(Height,Canvas.TextHeight(Lines[High(Lines)]));

        SetLength(Lines,length(Lines)+1);
        Lines[High(Lines)]:=S;
        CurrWidth:=Canvas.TextWidth(S);
      end;
    until length(TrimRight(Text))=0;

    with Result do Inc(Height,Canvas.TextHeight(Lines[High(Lines)]));
  end;
var
  wr: TWrapRecord;
  i:integer;
  lineHeight: integer;
begin
  (Control as TSpTBXListBox).Canvas.TextRect(R,0,0,'');
  wr := WrapText((Control as TSpTBXListBox).Canvas,(Control as TSpTBXListBox).Items[Index],(Control as TSpTBXListBox).ClientWidth);

  lineHeight := Canvas.TextHeight('W');
  R.Top := R.Top +  ((Control as TSpTBXListBox).Height-Length(wr.Lines)*lineHeight) div 2;
  for i:=Low(wr.Lines) to High(wr.Lines) do
    (Control as TSpTBXListBox).Canvas.TextOut(R.Left,R.Top+i*lineHeight,wr.Lines[i]);

  (Control as TSpTBXListBox).Tag := Index;
end;

procedure TBattleForm.ImgVoteYesClick(Sender: TObject);
begin
  if BattleState.AutoHostType = 1 then
    MainForm.TryToSendCommand('SAYBATTLE','!vote 1')
  else
    MainForm.TryToSendCommand('SAYBATTLE','!vote y');
  AutoHostVotePanel.Visible := False;
end;

procedure TBattleForm.ImgVoteNoClick(Sender: TObject);
begin
  if BattleState.AutoHostType = 1 then
    MainForm.TryToSendCommand('SAYBATTLE','!vote 2')
  else
    MainForm.TryToSendCommand('SAYBATTLE','!vote n');
  AutoHostVotePanel.Visible := False;
end;

procedure TBattleForm.ImgVoteBlankClick(Sender: TObject);
begin
  if BattleState.AutoHostType = 0 then
    MainForm.TryToSendCommand('SAYBATTLE','!vote b');
  AutoHostVotePanel.Visible := False;
end;

procedure TBattleForm.Image1Click(Sender: TObject);
begin
  if BattleState.AutoHostType = 1 then
    Misc.OpenURLInDefaultBrowser('http://springrts.com/wiki/Hosting_Spring/Autohost')
  else
    Misc.OpenURLInDefaultBrowser('http://planetspads.free.fr/spads/doc/spadsDoc.html');
end;

procedure TBattleForm.mnuDisableAutohostInterfaceClick(Sender: TObject);
begin
  AutoHostInfoPanel.Visible := False;
  AutoHostVotePanel.Visible := False;
  Preferences.DisplayAutohostInterface := False;
  PreferencesForm.WritePreferencesToRegistry;
end;

procedure TBattleForm.mnuHideAutoHostMsgs2Click(Sender: TObject);
begin
  mnuHideAutoHostMsgs.Checked := mnuHideAutoHostMsgs2.Checked;
end;

procedure TBattleForm.SPRINGIEPopupMenuInitPopup(Sender: TObject;
  PopupView: TTBView);
begin
  mnuHideAutoHostMsgs2.Checked := mnuHideAutoHostMsgs.Checked;
end;

procedure TBattleForm.SpTBXItem13Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!help');
end;

procedure TBattleForm.SpTBXItem5Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!status');
end;

procedure TBattleForm.SpTBXItem48Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!hostStats');
end;

procedure TBattleForm.SpTBXItem6Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!notify');
end;

procedure TBattleForm.SpTBXItem14Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list users');
end;

procedure TBattleForm.SpTBXItem15Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list presets');
end;

procedure TBattleForm.SpTBXItem16Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list bPresets');
end;

procedure TBattleForm.SpTBXItem17Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list hPresets');
end;

procedure TBattleForm.SpTBXItem18Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list settings');
end;

procedure TBattleForm.SpTBXItem19Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list bSettings');
end;

procedure TBattleForm.SpTBXItem20Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list hSettings');
end;

procedure TBattleForm.SpTBXItem21Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list bans');
end;

procedure TBattleForm.SpTBXItem22Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list maps');
end;

procedure TBattleForm.SpTBXItem23Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list pref');
end;

procedure TBattleForm.SpTBXItem24Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list all');
end;

procedure TBattleForm.SpTBXItem25Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!version');
end;

procedure TBattleForm.SpTBXItem31Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!forcestart');
end;

procedure TBattleForm.SpTBXItem37Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!restart');
end;

procedure TBattleForm.SpTBXItem36Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!stop');
end;

procedure TBattleForm.SpTBXItem32Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!lock');
end;

procedure TBattleForm.SpTBXItem45Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!unlock');
end;

procedure TBattleForm.SpTBXItem33Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!balance');
end;

procedure TBattleForm.SpTBXItem34Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!rebalance');
end;

procedure TBattleForm.SpTBXItem35Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!specAfk');
end;

procedure TBattleForm.SpTBXItem44Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!fixcolors');
end;

procedure TBattleForm.SpTBXItem47Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!autolock '+IntToStr(InputBoxInteger('!autolock','Autolock at :',10)));
end;

procedure TBattleForm.SpTBXItem49Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!autolock '+InputBox('!coop','Cooperation team name :','something'));
end;

procedure TBattleForm.SpTBXItem26Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!kick '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.SpTBXItem27Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!ban '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.SpTBXItem29Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!banip '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.SpTBXItem28Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!spec '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.SpTBXItem30Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!ring '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.SpTBXItem46Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!boss '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.SpTBXItem39Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!split v '+IntToStr(InputBoxInteger('!split vertical','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem38Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!split h '+IntToStr(InputBoxInteger('!split horizontal','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem40Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!split c '+IntToStr(InputBoxInteger('!split corners','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem41Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!split c1 '+IntToStr(InputBoxInteger('!split corners top-left vs bottom-right','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem42Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!split c2 '+IntToStr(InputBoxInteger('!split corners top-right vs bottom-left','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem43Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!split s '+IntToStr(InputBoxInteger('!split left vs top vs right vs bottom','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem64Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!start');
end;

procedure TBattleForm.SpTBXItem2Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!helpall');
end;

procedure TBattleForm.SpTBXItem50Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!stats');
end;

procedure TBattleForm.SpTBXItem62Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!notify');
end;

procedure TBattleForm.SpTBXItem57Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!admins');
end;

procedure TBattleForm.SpTBXItem51Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list maps');
end;

procedure TBattleForm.SpTBXItem52Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list mods');
end;

procedure TBattleForm.SpTBXItem53Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list bans');
end;

procedure TBattleForm.SpTBXItem54Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list options');
end;

procedure TBattleForm.SpTBXItem55Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!list presets');
end;

procedure TBattleForm.SpTBXItem56Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!springie');
end;

procedure TBattleForm.SpTBXItem63Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!start');
end;

procedure TBattleForm.SpTBXItem75Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!voteexit');
end;

procedure TBattleForm.SpTBXItem65Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!balance');
end;

procedure TBattleForm.SpTBXItem66Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!cbalance');
end;

procedure TBattleForm.SpTBXItem67Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!lock');
end;

procedure TBattleForm.SpTBXItem68Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!unlock');
end;

procedure TBattleForm.SpTBXItem69Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!specafk');
end;

procedure TBattleForm.SpTBXItem70Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!fixcolors');
end;

procedure TBattleForm.SpTBXItem71Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!fix');
end;

procedure TBattleForm.SpTBXItem72Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!split v '+IntToStr(InputBoxInteger('!split vertical','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem73Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!split h '+IntToStr(InputBoxInteger('!split horizontal','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem74Click(Sender: TObject);
begin
  MainForm.TryToSendCommand('SAYBATTLE','!corners a '+IntToStr(InputBoxInteger('!split corners','Boxes size (%):',20)));
end;

procedure TBattleForm.SpTBXItem58Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!votekick '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.SpTBXItem60Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!ring '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.SpTBXItem61Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!voteboss '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.AutoHostInfoBottomPanelResize(Sender: TObject);
begin
  //AutoHostInfoMsgs.ItemHeight := AutoHostInfoBottomPanel.ClientHeight;
end;

procedure TBattleForm.sspOptionsClick(Sender: TObject);
begin
  SpringSettingsProfileForm.ShowModal;
end;

procedure TBattleForm.AutohostControlSplitterMoved(Sender: TObject);
begin
  ChatRichEdit.ScrollToBottom;
end;

procedure TBattleForm.PlayerControlPopupMenuPopup(Sender: TObject);
var
  i:integer;
  ClientGroup: TClientGroup;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);

  BotOptionsItem.Visible := (WhatToDraw = NormalBot) and (TBot(BattleState.Battle.Bots[RealIndex]).OptionsForm <> nil) and (BattleState.Status=Hosting);
  ForceTeamSpin.Visible := ((WhatToDraw <> OriginalClient) and (BattleState.Status = Hosting) ) or ((WhatToDraw = NormalBot) and ((BattleState.Status = Hosting) or (TBot(BattleState.Battle.Bots[RealIndex]).OwnerName = Status.Username)));
  ForceAllySpin.Visible := ForceTeamSpin.Visible;
  SetTeamColorItem.Visible := ForceTeamSpin.Visible;
  HandicapSpinEditItem.Visible := ForceTeamSpin.Visible;
  KickPlayerItem.Visible := ForceTeamSpin.Visible;
  SetBotSideSubitem.Visible := (ForceTeamSpin.Visible) and (WhatToDraw = NormalBot);
  ForceSpectatorModeItem.Visible := ForceTeamSpin.Visible;
  RingItem.Visible := (WhatToDraw = NormalClient) and ((BattleState.Status = Hosting) or (RealIndex=0));

  BanPlayerItem.Visible := BattleState.Status = Hosting;
  UnbanSubitem.Visible := BanPlayerItem.Visible;
  if UnbanSubitem.Visible then
  begin
    UnbanSubitem.Clear;
    for i:=0 to BattleState.BanList.count-1 do begin
      UnbanSubitem.Add(TSpTBXItem.Create(UnbanSubitem));
      with UnbanSubitem.Items[UnbanSubitem.Count-1] as TSpTBXItem do
      begin
        Caption := MainForm.GetClientById(BattleState.BanList.Items[i]).Name;
        Tag := i;
        OnClick := UnbanItemClick;
      end;
    end;
    UnbanSubitem.Enabled := UnbanSubitem.Count > 0;
  end;

  if WhatToDraw = NormalClient then
  begin
    ForceAllySpin.Text := IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetAllyNo+1);
    ForceTeamSpin.Text := IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetTeamNo+1);
  end
  else
  begin
    ForceAllySpin.Text := IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetAllyNo+1);
    ForceTeamSpin.Text := IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetTeamNo+1);
  end;

  if WhatToDraw = NormalClient then
  begin
    PlayerSubmenu.Caption := TClient(BattleState.Battle.Clients[RealIndex]).DisplayName;
    MainUnit.ContextMenuSelectedClient := TClient(BattleState.Battle.Clients[RealIndex]);
    MainForm.ClientPopupMenuPopup(nil);
    PlayerSubmenu.Visible := True;
  end
  else
    PlayerSubmenu.Visible := False;

  ChatRichEdit.Refresh;
  VDTBattleClients.Refresh;
end;

procedure TBattleForm.ZoomItemClick(Sender: TObject);
begin
  BattleState.SelectedStartRect := -1;
  MapImageMouseDown(MapImage,mbLeft,[ssLeft],-100,-100);
end;

procedure TBattleForm.ForceTeamSpinChange(Sender: TObject;
  const Text: WideString);
var
  team: Integer;
  i:integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    team := StrToInt(Text)-1;

    if WhatToDraw = NormalClient then
    begin
      if mnuBlockTeams.Checked then
        TClient(BattleState.Battle.Clients[RealIndex]).SetTeamNo(team);
      MainForm.TryToSendCommand('FORCETEAMNO', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(team));
      //AddTextToChat(_('Forcing ') + TClient(BattleState.Battle.Clients[RealIndex]).Name + _('''s team number ...'), Colors.Info, 1);
    end
    else if WhatToDraw = NormalBot then
    begin
      with TBot(BattleState.Battle.Bots[RealIndex]) do begin
        SetTeamNo(Round(team));
        if isComSharing then begin
          for i := 0 to BattleState.Battle.Clients.Count-1 do begin
            if (TClient(BattleState.Battle.Clients[i]).GetTeamNo = GetTeamNo) then begin
              TeamColor := TClient(BattleState.Battle.Clients[i]).TeamColor;
              break;
            end;
          end;
          if i < BattleState.Battle.Clients.Count then begin
            for i := 0 to BattleState.Battle.Bots.Count-1 do begin
              if (TBot(BattleState.Battle.Bots[i]).GetTeamNo = GetTeamNo) and (TBot(BattleState.Battle.Bots[i]).Name <> Name) then begin
                TeamColor := TBot(BattleState.Battle.Bots[i]).TeamColor;
                break;
              end;
            end;
          end;
        end;
      end;
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;
  end;
end;

procedure TBattleForm.ForceAllySpinChange(Sender: TObject;
  const Text: WideString);
var
  ally: Integer;
  i:integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    ally := StrToInt(Text)-1;

    if WhatToDraw = NormalClient then
    begin
      if mnuBlockTeams.Checked then
        TClient(BattleState.Battle.Clients[RealIndex]).SetAllyNo(ally);
      MainForm.TryToSendCommand('FORCEALLYNO', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(ally));
      //AddTextToChat(_('Forcing ') + TClient(BattleState.Battle.Clients[RealIndex]).Name + _('''s ally number ...'), Colors.Info, 1);
    end
    else if WhatToDraw = NormalBot then
    begin
      TBot(BattleState.Battle.Bots[RealIndex]).SetAllyNo(Round(ally));
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;

  end;
end;

procedure TBattleForm.HandicapSpinEditItemChange(Sender: TObject;
  const Text: WideString);
var
  Value: Integer;
begin
  try
    Value := StrToInt(Text);
  except
    Exit;
  end;

  if (Value < 0) or (Value > 100) then Exit;

  // finally:
  HandicapSpinEditItem.Text := IntToStr(Value);
end;

procedure TBattleForm.EnergyTrackerChange(Sender: TObject);
begin
  lblEnergyValue.Caption := IntToStr(EnergyTracker.Position);
end;

procedure TBattleForm.MetalTrackerChange(Sender: TObject);
begin
  lblMetalValue.Caption := IntToStr(MetalTracker.Position);
end;

procedure TBattleForm.UnitsTrackerChange(Sender: TObject);
begin
  lblUnitsValue.Caption := IntToStr(UnitsTracker.Position);
end;

procedure TBattleForm.SpringSettingsProfilePopupMenuPopup(Sender: TObject);
var
  i: integer;
begin
  for i:=SpringSettingsProfilePopupMenu.Items.Count-1 downto 8 do
    SpringSettingsProfilePopupMenu.Items.Delete(i);

  for i:=0 to SpringSettingsProfileForm.cpNames.Count-1 do
  begin
    SpringSettingsProfilePopupMenu.Items.Add(TSpTBXItem.Create(SpringSettingsProfilePopupMenu));
    with SpringSettingsProfilePopupMenu.Items[SpringSettingsProfilePopupMenu.Items.Count-1] as TSpTBXItem do
    begin
      Caption := SpringSettingsProfileForm.cpNames[i];
      Tag := i;
      OnClick := OnSpringSettingsProfileItemClick;
      Checked := SpringSettingsProfile = SpringSettingsProfileForm.cpNames[i];
    end;
  end;

  sspDefaultItem.Checked := SpringSettingsProfile = '';
  sspCustomExe.Caption := SpringSettingsProfileForm.beCustomSpringExe.Text;
  sspCustomExe.Visible := SpringSettingsProfileForm.beCustomSpringExe.Text <> '';
  if not sspCustomExe.Visible and sspCustomExe.Checked then
    sspST.Checked := True;
end;

procedure TBattleForm.VDTBattleClientsHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

procedure TBattleForm.MetalTrackerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  if not MetalTracker.Visible then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/modoptions/StartMetal='+IntToStr(MetalTracker.Position));
end;

procedure TBattleForm.UnitsTrackerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  if not UnitsTracker.Visible then Exit;

  if UnitsTracker.Position < 10 then UnitsTracker.Position := 10;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/modoptions/MaxUnits='+IntToStr(UnitsTracker.Position));
end;

procedure TBattleForm.EnergyTrackerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  if not EnergyTracker.Visible then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/modoptions/StartEnergy='+IntToStr(EnergyTracker.Position));
end;

procedure TBattleForm.mnuTeamColorPaletteCellClick(Sender: TObject; ACol,
  ARow: Integer; var Allow: Boolean);
begin
  Allow := True;
  ChangeTeamColor(ARow*5+ACol, True);
end;

procedure TBattleForm.mnuTeamColorPaletteGetColor(Sender: TObject; ACol,
  ARow: Integer; var Color: TColor; var Name: WideString);
begin
  Color := TeamColors[ARow*5+ACol];
end;

procedure TBattleForm.mnuForceTeamColorPaletteCellClick(Sender: TObject;
  ACol, ARow: Integer; var Allow: Boolean);
var
  color: Integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    Allow := True;
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      TClient(BattleState.Battle.Clients[RealIndex]).TeamColor := TeamColors[ARow*5+ACol];
      MainForm.TryToSendCommand('FORCETEAMCOLOR', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(TeamColors[ARow*5+ACol]));
    end
    else if WhatToDraw = NormalBot then
    begin
      TBot(BattleState.Battle.Bots[RealIndex]).TeamColor := TeamColors[ARow*5+ACol];
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;
  end;
end;

procedure TBattleForm.BotOptionsItemClick(Sender: TObject);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  TBot(BattleState.Battle.Bots[RealIndex]).OptionsForm.Show;
end;

procedure TBattleForm.SpTBXItem1Click(Sender: TObject);
var
  i:integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  if VDTBattleClients.FocusedNode = nil then Exit;
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
  if WhatToDraw = NormalClient then
    MainForm.TryToSendCommand('SAYBATTLE','!kickban '+TClient(BattleState.Battle.Clients[RealIndex]).Name);
end;

procedure TBattleForm.JoinButtonClick(Sender: TObject);
begin
  MainForm.ProcessCommand('FORCESTART',true);
end;

procedure TBattleForm.BitBtn1Click(Sender: TObject);
begin
  DisableUnitsForm.Show;
end;

procedure TBattleForm.ModOptionsScrollBoxConstrainedResize(Sender: TObject;
  var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
var
  i: integer;
begin
  if (GetAsyncKeyState(VK_LBUTTON) < 0) or (GetAsyncKeyState(VK_RBUTTON) < 0) then
    with TTntScrollBox(Sender) do
      for i:=0 to ControlCount-1 do
        Controls[i].SendToBack;
end;

procedure TBattleForm.MapOptionsScrollBoxConstrainedResize(Sender: TObject;
  var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
var
  i: integer;
begin
  if (GetAsyncKeyState(VK_LBUTTON) < 0) or (GetAsyncKeyState(VK_RBUTTON) < 0) then
    with TTntScrollBox(Sender) do
      for i:=0 to ControlCount-1 do
        Controls[i].SendToBack;
end;

procedure TBattleForm.sspSTClick(Sender: TObject);
begin
  sspST.Checked := True;
end;

procedure TBattleForm.sspMTClick(Sender: TObject);
begin
  sspMT.Checked := True;
end;

procedure TBattleForm.sspCustomExeClick(Sender: TObject);
begin
  sspCustomExe.Checked := True;
end;

end.

