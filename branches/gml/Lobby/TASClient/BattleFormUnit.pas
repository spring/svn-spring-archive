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
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, janTracker, Buttons, MainUnit, jpeg,
  VirtualTrees, Menus, RichEditURL, JvExControls, JvComponent, JvButton,
  JvTransparentButton, JvgSpeedButton, JvgShadow, JvgButton, JvExStdCtrls,
  JvXPCore, JvXPButtons, TBXToolPals, TB2Item, TBX, SpTBXItem, TBXDkPanels,
  SpTBXControls, TBXExtItems, TB2ExtItems, SpTBXEditors, SpTBXTabs, JvLED,
  ImageEx, JvSticker, JvExExtCtrls, JvImage, JvShape, JvLabel, TBXLists,
  SpTBXLists, ImgList, SpTBXjanTracker, SpTBXFormPopupMenu,IniFiles,
  HttpProt,MsMultiPartFormData, JvComponentBase, JvDSADialogs, Spin, Mask,
  JvExMask, JvSpin, TntStdCtrls, TntForms, TntComCtrls,RichEdit,JclUnicode;

type

  // we have to use this ugly hack to expose SelectedCell property in TTBXColorPallete class:
  TTBXColorPaletteHack = class(TTBXColorPalette);

  TJvXPCustomButtonHack = class(TJvXPCustomButton); // another hack to expose Color property

  TClientNodeType = (NodeError, NormalClient, NormalBot, OriginalClient,Separator); // used to differentiate between "types" of nodes in the visual battle clients list, so for example we can decided what to paint on OnPaint event etc. NodeError is used to indicate that certain node has invalid position.

  TLuaOption = class
  private
    Value: String;
  protected
    LabelName: TSpTBXLabel;
    DescriptionButton: TSpTBXButton;
    procedure MakeDescriptionButton(AOwner: TWinControl);
    procedure OnDescriptionButtonClick(Sender: TObject);virtual;

  public
    DefaultValue: String;
    KeyPrefix: String;
    Key: String;
    Name: String;
    Description: String;
    function GetComponent(AOwner: TWinControl):TWinControl;virtual;
    procedure SetValue(v: String);virtual;
    procedure OnChange(Sender: TObject);virtual;
    procedure Enable;virtual;
    procedure Disable;virtual;
    procedure setToDefault();virtual;
    function toString:String;virtual;
    destructor Destroy; override;
  end;

  TLuaOptionBool = class(TLuaOption)
  private

  protected
    Panel: TPanel;
    CheckBox: TSpTBXCheckBox;
  public
    function GetComponent(AOwner: TWinControl):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
    function toString:String;override;
    destructor Destroy; override;
  end;

  TLuaOptionString = class(TLuaOption)
  private

  protected
    Panel: TPanel;
    InputEdit: TSpTBXEdit;
  public
    MaxStringLength: Integer;
    function GetComponent(AOwner: TWinControl):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
    function toString:String;override;
    destructor Destroy; override;
  end;

  TLuaOptionNumber = class(TLuaOption)
  private

  protected
    Panel: TPanel;
    InputEdit: TJvSpinEdit;
  public
    MinValue: Double;
    MaxValue: Double;
    StepValue: Double;
    function GetComponent(AOwner: TWinControl):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
    procedure OnChange(Sender: TObject);override;
    function toString:String;override;
    destructor Destroy; override;
  end;

  TLuaOptionList = class(TLuaOption)
  private
    Panel: TPanel;
    ComboBox: TSpTBXComboBox;
  protected
    procedure OnDescriptionButtonClick(Sender: TObject);override;

  public
    NameList: TStringList;
    KeyList: TStringList;
    DescriptionList: TStringList;
    constructor Create;
    function GetComponent(AOwner: TWinControl):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
    function toString:String;override;
    destructor Destroy; override;
  end;
  
  TBattleForm = class(TForm)
    GameTimer: TTimer;
    ColorPopupMenu: TSpTBXPopupMenu;
    TBXColorPalette1: TTBXColorPalette;
    TBXTeamColorSet: TTBXColorSet;
    SpTBXItem1: TSpTBXItem;
    ChooseNumberPopupMenu: TSpTBXPopupMenu;
    TBXToolPalette1: TTBXToolPalette;
    SpTBXItem2: TSpTBXItem;
    ChooseSidePopupMenu: TSpTBXPopupMenu;
    PlayerControlPopupMenu: TSpTBXPopupMenu;
    HandicapSpinEditItem: TTBXSpinEditItem;
    KickPlayerItem: TSpTBXItem;
    SetTeamItem: TSpTBXSubmenuItem;
    ForceTeamToolPalette: TTBXToolPalette;
    SpTBXItem5: TSpTBXItem;
    SetAllyItem: TSpTBXSubmenuItem;
    ForceAllyToolPalette: TTBXToolPalette;
    SpTBXItem6: TSpTBXItem;
    SetTeamColorItem: TSpTBXSubmenuItem;
    ForceTeamColorPalette: TTBXColorPalette;
    SpTBXItem3: TSpTBXItem;
    SetBotSideSubitem: TSpTBXSubmenuItem;
    SpTBXItem4: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    SpTBXItem7: TSpTBXItem;
    MapsPopupMenu: TSpTBXPopupMenu;
    MapsPopupStringList: TSpTBXStringList;
    ForceSpectatorModeItem: TSpTBXItem;
    SpTBXTitleBar1: TSpTBXTitleBar;
    Panel3: TSpTBXPanel;
    StartButton: TSpTBXButton;
    HostButton: TSpTBXButton;
    DisconnectButton: TSpTBXButton;
    AddBotButton: TSpTBXButton;
    LockedCheckBox: TSpTBXCheckBox;
    Panel2: TPanel;
    NoMapImage: TImage;
    Splitter1: TSplitter;
    Panel1: TPanel;
    MyOptionsGroupBox: TSpTBXGroupBox;
    Label11: TSpTBXLabel;
    Label12: TSpTBXLabel;
    TeamColorSpeedButton: TSpTBXSpeedButton;
    SpectateCheckBox: TSpTBXCheckBox;
    MyTeamNoButton: TTBXButton;
    MyAllyNoButton: TTBXButton;
    MySideButton: TSpTBXSpeedButton;
    MapPanel: TSpTBXPanel;
    Bevel2: TBevel;
    MapDescLabel: TSpTBXLabel;
    TidalStrengthLabel: TSpTBXLabel;
    GravityLabel: TSpTBXLabel;
    MaxMetalLabel: TSpTBXLabel;
    ExtRadiusLabel: TSpTBXLabel;
    WindLabel: TSpTBXLabel;
    SpTBXPanel1: TSpTBXPanel;
    Bevel1: TBevel;
    MapsButton: TTBXButton;
    ReloadMapListButton: TTBXButton;
    TBXButton1: TTBXButton;
    TBXButton2: TTBXButton;
    VDTBattleClients: TVirtualDrawTree;
    SpTBXTabControl1: TSpTBXTabControl;
    GameOptionsTab: TSpTBXTabItem;
    DisabledUnitsTab: TSpTBXTabItem;
    SpTBXTabSheet2: TSpTBXTabSheet;
    LimitDGunCheckBox: TSpTBXCheckBox;
    GhostedBuildingsCheckBox: TSpTBXCheckBox;
    DiminishingMMsCheckBox: TSpTBXCheckBox;
    LockGameSpeedCheckBox: TSpTBXCheckBox;
    ResourcesGroupBox: TSpTBXGroupBox;
    Label8: TSpTBXLabel;
    Label9: TSpTBXLabel;
    Label10: TSpTBXLabel;
    MetalTracker: TSpTBXjanTracker;
    EnergyTracker: TSpTBXjanTracker;
    UnitsTracker: TSpTBXjanTracker;
    SpTBXTabSheet1: TSpTBXTabSheet;
    UnitsGroupBox: TSpTBXGroupBox;
    AddUnitsSpeedButton: TSpeedButton;
    DisabledUnitsListBox: TListBox;
    MapImage: TImageEx;
    BalanceTeamsPopupMenu: TSpTBXPopupMenu;
    SpTBXItem8: TSpTBXItem;
    AutoStartRectsPopupMenu: TSpTBXPopupMenu;
    AutoStartRectsOptionsItem: TSpTBXItem;
    AutoStartRectsApplyItem: TSpTBXItem;
    AdminButton: TSpTBXButton;
    lblTeamNbr: TSpTBXLabel;
    AdminPopupMenu: TSpTBXPopupMenu;
    mnuCBalanceTeams: TTBItem;
    mnuBalanceTeamOptions: TTBItem;
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
    GameEndRadioGroup: TSpTBXRadioGroup;
    mnuFixTeams: TSpTBXItem;
    mnuBlockTeams: TSpTBXItem;
    HttpCli2: THttpCli;
    LadderRulesButton: TSpTBXButton;
    HttpCli3: THttpCli;
    LadderPopupMenu: TSpTBXPopupMenu;
    SpTBXItem9: TSpTBXItem;
    SpTBXItem10: TSpTBXItem;
    SpTBXItem11: TSpTBXItem;
    RingItem: TSpTBXItem;
    ModTab: TSpTBXTabItem;
    ModTabSheet: TSpTBXTabSheet;
    MapTab: TSpTBXTabItem;
    MapTabSheet: TSpTBXTabSheet;
    MapSizeLabel: TSpTBXLabel;
    StartPosRadioGroup: TSpTBXRadioGroup;
    LoadDefaultButton: TSpTBXButton;
    SetDefaultButton: TSpTBXButton;
    ReadyButton: TSpTBXButton;
    SpTBXSeparatorItem5: TSpTBXSeparatorItem;
    mnuRemoveFromGroup: TSpTBXItem;
    mnuAddToGroup: TSpTBXSubmenuItem;
    mnuNewGroup: TSpTBXItem;
    SpTBXSeparatorItem6: TSpTBXSeparatorItem;
    ModOptionsScrollBox: TTntScrollBox;
    MapOptionsScrollBox: TTntScrollBox;
    panelModOptionsDefault: TSpTBXPanel;
    btLoadDefaultMDO: TSpTBXButton;
    btSetAsDefaultMDO: TSpTBXButton;
    btLoadModsDefaultMDO: TSpTBXButton;
    panelMapOptionsDefault: TSpTBXPanel;
    btLoadDefaultMPO: TSpTBXButton;
    btSetAsDefaultMPO: TSpTBXButton;
    btLoadMapsDefaultMPO: TSpTBXButton;
    InputEdit: TSpTBXEdit;
    ChatRichEdit: TTntRichEditURL;

    procedure CreateParams(var Params: TCreateParams); override;

    function IsBattleActive: Boolean;
    procedure AddTextToChat(Text: WideString; Color: TColor; ChatTextPos: Integer);
    procedure UpdateClientsListBox;
    function GetMyBattleStatus: Integer;
    procedure SetMyBattleStatus(Side: Integer; Ready: Boolean; TeamNo: Integer; AllyNo: Integer; Mode: Integer);
    procedure SendMyBattleStatusToServer;
    procedure SendReplayScriptToServer;
    procedure SendBattleDetailsToServer;
    procedure SendBattleInfoToServer;
    function GenerateNormalScriptFile(FileName: string):Boolean;
    function GenerateReplayScriptFile(FileName: string):Boolean;
    procedure PunchThroughNAT; // only used when hosting using "hole punching" technique. See comments at method's implementation for more info.

    function ChooseColorDialog(UnderControl: TControl; DefaultColorIndex: Integer): Integer;
    function ChooseNumberDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;
    function ChooseSideDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;

    procedure ChangeTeamColor(ColorIndex: Integer; UpdateServer: Boolean);
    procedure ChangeSide(SideIndex: Integer; UpdateServer: Boolean);

    function FigureOutBestPossibleTeamAllyAndColor(IgnoreMyself: Boolean; var BestTeam, BestAlly, BestColorIndex: Integer): Boolean;
    procedure ChangeCurrentMod(ModName: string);
    procedure ChangeMapToNoMap(MapName: string); // use 'MapName' to display missing map caption
    procedure ChangeMap(MapIndex: Integer); // 'MapIndex' refers to index in Utility.MapList
    procedure PopulatePopupMenuMapList; // will populate 'MapsPopupMenu' with map names
    procedure MapsPopupMenuItemClick(Sender: TObject);

    procedure OnStartGameMessage(var Msg: TMessage); message WM_STARTGAME;

    procedure ResetBattleScreen;
    function JoinBattle(BattleID: Integer): Boolean;
    function JoinBattleReplay(BattleID: Integer): Boolean;
    function HostBattle(BattleID: Integer): Boolean;
    function HostBattleReplay(BattleID: Integer): Boolean;    
    function ApplyScriptFile(ScriptSL: TStringList): Boolean;

    procedure ResetStartRects;
    function GetFirstMissingStartRect: Integer;
    procedure StartRectPaintBoxPaint(Sender: TObject);
    procedure AddStartRect(Index: Integer; Rect: TRect);
    procedure RemoveStartRect(Index: Integer);
    procedure ChangeStartRect(Index: Integer; Rect: TRect);
    procedure SetSelectedStartRect(Index: Integer);
    function GetStartRectAtPos(x, y: Integer): Integer;
    function IsMouseOverMapImage: Boolean;
    procedure OnNumberPressedOverStartRect(Number: Byte);
    procedure OnDeletePressedOverStartRect;
    procedure RearrangeStartRects;

    procedure ChooseSidePopupMenuItemClick(Sender: TObject);
    procedure SetBotSideItemClick(Sender: TObject);
    procedure UnbanItemClick(Sender: TObject);

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
    procedure MetalTrackerMouseUpAfterChange(Sender: TObject);
    procedure EnergyTrackerMouseUpAfterChange(Sender: TObject);
    procedure UnitsTrackerMouseUpAfterChange(Sender: TObject);
    procedure StartPosRadioGroupClick(Sender: TObject);
    procedure GameTimerTimer(Sender: TObject);
    procedure UploadReplay;
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpectateCheckBoxClick(Sender: TObject);
    procedure GameEndRadioGroupClick(Sender: TObject);
    procedure TeamColorSpeedButtonClick(Sender: TObject);
    procedure AddUnitsSpeedButtonClick(Sender: TObject);
    procedure AddBotButtonClick(Sender: TObject);
    procedure ChatRichEditURLClick(Sender: TObject; const URL: String);
    procedure MapImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MapImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LimitDGunCheckBoxClick(Sender: TObject);
    procedure DiminishingMMsCheckBoxClick(Sender: TObject);
    procedure LockedCheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GhostedBuildingsCheckBoxClick(Sender: TObject);
    procedure SetDefaultButtonClick(Sender: TObject);
    procedure LoadDefaultButtonClick(Sender: TObject);
    procedure TBXTeamColorSetGetColorInfo(Sender: TTBXCustomColorSet; Col,
      Row: Integer; var Color: TColor; var Name: String);
    procedure TBXColorPalette1CellClick(Sender: TTBXCustomToolPalette;
      var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure TBXToolPalette1CellClick(Sender: TTBXCustomToolPalette;
      var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure MyTeamNoButtonClick(Sender: TObject);
    procedure MyAllyNoButtonClick(Sender: TObject);
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
    procedure ForceTeamToolPaletteCellClick(Sender: TTBXCustomToolPalette;
      var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure SetTeamItemClick(Sender: TObject);
    procedure SetAllyItemClick(Sender: TObject);
    procedure ForceAllyToolPaletteCellClick(Sender: TTBXCustomToolPalette;
      var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure KickPlayerItemClick(Sender: TObject);
    procedure ForceTeamColorPaletteCellClick(Sender: TTBXCustomToolPalette;
      var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure SetTeamColorItemClick(Sender: TObject);
    procedure HandicapSpinEditItemChange(Sender: TObject; const Text: String);
    procedure MySideButtonClick(Sender: TObject);
    procedure ReadyButtonClick(Sender: TObject);
    procedure SpTBXItem4Click(Sender: TObject);
    procedure SpTBXItem7Click(Sender: TObject);
    procedure MapsButtonClick(Sender: TObject);
    procedure TBXButton1Click(Sender: TObject);
    procedure TBXButton2Click(Sender: TObject);
    procedure ReloadMapListButtonClick(Sender: TObject);
    procedure VDTBattleClientsDblClick(Sender: TObject);
    procedure ForceSpectatorModeItemClick(Sender: TObject);
    procedure LockedCheckBoxGetImageIndex(Sender: TObject;
      var AImageList: TCustomImageList; var AItemIndex: Integer);
    procedure BalanceTeamsButtonClick(Sender: TObject);
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
    procedure PlayerControlPopupMenuInitPopup(Sender: TObject;
      PopupView: TTBView);
    //procedure AdjustFont(Item: TTBCustomItem;
    //  Viewer: TTBItemViewer; Font: TFont; StateFlags: Integer);
    procedure mnuLimitRankAutoKickClick(Sender: TObject);
    procedure SpTBXItem8Click(Sender: TObject);
    procedure RefreshLadderRanks;
    procedure mnuLimitRankAutoSpecClick(Sender: TObject);
    procedure mnuRankLimitDisabledClick(Sender: TObject);
    procedure VDTBattleClientsDrawHint(Sender: TBaseVirtualTree;
      HintCanvas: TCanvas; Node: PVirtualNode; R: TRect;
      Column: TColumnIndex);
    procedure VDTBattleClientsGetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure mnuFixTeamsClick(Sender: TObject);
    procedure mnuBlockTeamsClick(Sender: TObject);
    function LadderTeamReady:boolean;
    procedure SpTBXItem9Click(Sender: TObject);
    procedure SpTBXItem10Click(Sender: TObject);
    procedure SpTBXItem11Click(Sender: TObject);
    procedure RingItemClick(Sender: TObject);
    procedure VDTBattleClientsHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Label9Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);

    procedure DisplayLuaOptions(luaOptionList: TList; tabSheet: TWinControl);
    function GetLuaOption(optList: TList;key: string): TLuaOption;
    procedure ChangeScriptTagValue(completeKey: String; value: String);
    procedure SendLuaOptionsDetailsToServer;
    procedure FormResize(Sender: TObject);
    procedure SpTBXTabControl1ActiveTabChange(Sender: TObject;
      TabIndex: Integer);
    procedure LockGameSpeedCheckBoxClick(Sender: TObject);
    procedure mnuNewGroupClick(Sender: TObject);
    procedure mnuRemoveFromGroupClick(Sender: TObject);
    procedure ChatRichEditMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btLoadModsDefaultMDOClick(Sender: TObject);
    procedure btLoadMapsDefaultMPOClick(Sender: TObject);
    procedure btSetAsDefaultMDOClick(Sender: TObject);
    procedure btSetAsDefaultMPOClick(Sender: TObject);
    procedure btLoadDefaultMDOClick(Sender: TObject);
    procedure btLoadDefaultMPOClick(Sender: TObject);
  private
    History: TWideStringList;
    HistoryIndex: Integer;

    SortedClientList : TList;
    SortedBotList : TList;
    SortedOriginalList : TList;

    FMyReadyStatus: Boolean;
    FCurrentMapIndex: Integer; // index of currently loaded map. -1 for none.
    procedure SetMyReadyStatus(Status: Boolean); // sets FMyReadyStatus
  public
    ModOptionsList: TList;
    MapOptionsList: TList;
    UnknownScriptTagList:
    record
      CompleteKeyList: TStrings;
      ValueList: TStrings;
    end;
    LogFile: TFileStream; // use the same way as TMyTabSheet.LogFile is used
    property CurrentMapIndex: Integer read FCurrentMapIndex; // only ChangeMap method may change it!
    property AmIReady: Boolean read FMyReadyStatus write SetMyReadyStatus;
    procedure RefreshTeamNbr;
    procedure SaveModOptionsAsDefault;
    procedure LoadModOptionsDefault(modName: string);
    procedure SaveMapOptionsAsDefault;
    procedure LoadMapOptionsDefault;
    procedure DisconnectButtonClick;overload;
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

  TLadderRanksThread = class(TThread)
  private
    procedure Refresh;
    procedure OnTerminateProcedure(Sender : TObject);

  protected
    procedure Execute; override;

  public
    constructor Create(Suspended : Boolean);
  end;

  TLadderMapThread = class(TDialogThread)
  private
    procedure Refresh;
    procedure OnTerminateProcedure(Sender : TObject);

  protected
    procedure Execute; override;
    
  public
    constructor Create(Suspended : Boolean);
  end;

  TUploadLadderDataThread = class(TDialogThread)
  private
    procedure UploadData;
    procedure OnTerminateProcedure(Sender : TObject);

  protected
    procedure Execute; override;
  public
    constructor Create(Suspended : Boolean);
  end;
var
  BattleForm: TBattleForm;
  BattleState:
  record
    Status: TBattleParticipation;
    Battle: TBattle; // don't ever free this object! It is freed automatically by RemoveBattle method! This object is only "pointer" to an item in Battles list!
    Process: // we need this information when we launch game exe
    record
      proc_info: TProcessInformation;
      startinfo: TStartupInfo;
      ExitCode: LongWord;
    end;

    LadderIndex: integer;
    AutoSendDescription : boolean;
    AutoKickRankLimit : boolean;
    AutoSpecRankLimit : boolean;
    AutoKickSpringMark : integer;
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
    BanList:TStringList;
    TryingToJoinLadderBattle: boolean;
  end;

  BattleReplayInfo: // used only when battle is of "battle replay" type
  record
    Script: TStringList;
    TempScript: TStringList; // we use it while receiving script from server. Once finished, we copy it to <Script>.
    OriginalClients: TList; // list of TClient-s from the replay. You have to manually free this clients. They are NOT bound to AllClients list!
    ReplayFilename: string;
  end;

  MyTeamColorIndex: Integer;

  AllowBattleStatusUpdate: Boolean = True;
  { should be always true except when we are changing some checkbox's checked status or TRadioGroup's ItemIndex property. The problem
    is, that the sentence "MyCheckBox.Checked := True" will trigger OnClick event, but only if value changed. Also, TRadioGroup works
    the same way (ItemIndex). But changing TComboBox's ItemIndex will not trigger OnChange event! }
  AllowBattleDetailsUpdate: Boolean = True;
  { similar to AllowBattleStatusUpdate, only for battle details }

  procedure FreeReplayClients; // free-s BattleReplayInfo.OriginalClients; NOTE: it doesn't free the list itself, only clients!

implementation

uses
  Utility, Misc, HostBattleFormUnit, ShellAPI,
  MinimapZoomedFormUnit, PreferencesFormUnit, DisableUnitsFormUnit,
  InitWaitFormUnit, AddBotUnit, Math, OnlineMapsUnit, ReplaysUnit, StrUtils,
  CustomColorUnit, StringParser, MapListFormUnit, AutoTeamsUnit,
  AutoStartRectsUnit, ColorPicker, UploadReplayUnit, ProgressBarWindow,
  TntWideStrings;

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
      StartPosRadioGroup.Enabled := not Status;
      GameEndRadioGroup.Enabled := not Status;
      if Status then DisableControlAndChildren(ResourcesGroupBox) else EnableControlAndChildren(ResourcesGroupBox);
      if Status then DisableControlAndChildren(UnitsGroupBox) else EnableControlAndChildren(UnitsGroupBox);
      LimitDGunCheckBox.Enabled := not Status;
      DiminishingMMsCheckBox.Enabled := not Status;
      GhostedBuildingsCheckBox.Enabled := not Status;
      LockGameSpeedCheckBox.Enabled := not Status;

      if BattleState.LadderIndex >= 0 then begin
        LoadDefaultButton.Enabled := False;
        btLoadDefaultMDO.Enabled := False;
        btLoadModsDefaultMDO.Enabled := False;
        btLoadDefaultMPO.Enabled := False;
        btLoadMapsDefaultMPO.Enabled := False;
        with TLadder(LadderList[BattleState.LadderIndex]) do begin
          StartPosRadioGroup.Enabled := StartPosRadioGroup.Enabled and (StartPos = 255);
          GameEndRadioGroup.Enabled := GameEndRadioGroup.Enabled and (GameMode = 255);
          LimitDGunCheckBox.Enabled := LimitDGunCheckBox.Enabled and (DGun = 255);
          GhostedBuildingsCheckBox.Enabled := GhostedBuildingsCheckBox.Enabled and (Ghost = 255);
          DiminishingMMsCheckBox.Enabled := DiminishingMMsCheckBox.Enabled and (Diminish = 255);
          MetalTracker.Enabled := MetalTracker.Enabled and ((MetalMin = -1) or (MetalMin <> MetalMax));
          EnergyTracker.Enabled := EnergyTracker.Enabled and ((EnergyMin = -1) or (EnergyMin <> EnergyMax));
          UnitsTracker.Enabled := UnitsTracker.Enabled and ((UnitsMin = -1) or (UnitsMin <> UnitsMax));
          LockGameSpeedCheckBox.Enabled := False;
          AddUnitsSpeedButton.Enabled := False;
        end;
      end;
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
procedure TBattleForm.AddTextToChat(Text: WideString; Color: TColor; ChatTextPos: Integer);
var
  s: WideString;
begin
  if Preferences.TimeStamps then
  begin
    s := '[' + TimeToStr(Now) + '] ';
    Text := s + Text;
    Inc(ChatTextPos, Length(s));
  end;
  Misc.AddTextToRichEdit(ChatRichEdit, Text, Color, True, ChatTextPos);
  MainForm.TryToAddLog(BattleForm.LogFile, Text);
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
  Inc(Result, (StrToInt(MyTeamNoButton.Caption)-1) shl 2);

  // ally no.:
  Inc(Result, (StrToInt(MyAllyNoButton.Caption)-1) shl 6);

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
  MyTeamNoButton.Caption := IntToStr(TeamNo+1);
  MyAllyNoButton.Caption := IntToStr(AllyNo+1);
  SpectateCheckBox.Checked := not IntToBool(Mode);

  AllowBattleStatusUpdate := True;
end;

{ updates the battle status only if AllowBattleStatusUpdate = True }
procedure TBattleForm.SendMyBattleStatusToServer;
begin
  if not IsBattleActive then Exit; // we are not allowed to call it if we are not participating in a battle

  if not AllowBattleStatusUpdate then Exit;

  MainForm.TryToSendCommand('MYBATTLESTATUS', IntToStr(GetMyBattleStatus) +  ' ' + IntToStr(TeamColors[MyTeamColorIndex]));
end;

procedure TBattleForm.SendReplayScriptToServer;
var
  i: Integer;
begin
  MainForm.TryToSendCommand('SCRIPTSTART');
  for i := 0 to BattleReplayInfo.Script.Count-1 do
    MainForm.TryToSendCommand('SCRIPT', BattleReplayInfo.Script[i]);
  MainForm.TryToSendCommand('SCRIPTEND');
end;

procedure TBattleForm.SendBattleDetailsToServer; // call it each time you update some of the battle's inside parameters
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/StartPosType='+IntToStr(StartPosRadioGroup.ItemIndex)+#9+'GAME/GameMode='+IntToStr(GameEndRadioGroup.ItemIndex)+#9+'GAME/LimitDGun='+BoolToStr(LimitDGunCheckBox.Checked)+#9+'GAME/GhostedBuildings='+BoolToStr(GhostedBuildingsCheckBox.Checked)+#9+'GAME/DiminishingMMs='+BoolToStr(DiminishingMMsCheckBox.Checked)+#9+'GAME/StartMetal='+IntToStr(MetalTracker.Value)+#9+'GAME/StartEnergy='+IntToStr(EnergyTracker.Value)+#9+'GAME/MaxUnits='+IntToStr(UnitsTracker.Value)+#9+'GAME/IsGameSpeedLocked='+IntToStr(BoolToInt(LockGameSpeedCheckBox.Checked)));
end;

procedure TBattleForm.SendBattleInfoToServer; // call it each time you update some of the battle's outside parameters
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  MainForm.TryToSendCommand('UPDATEBATTLEINFO', IntToStr(BattleState.Battle.SpectatorCount) + ' ' + IntToStr(BoolToInt(LockedCheckBox.Checked)) + ' ' + IntToStr(Misc.HexToInt(Utility.MapChecksums[CurrentMapIndex])) + ' ' + Utility.MapList[CurrentMapIndex]);
end;


{ tries to figure out best possible team number, ally number and team color. It finds
  first available numbers (that aren't used by other players or bots in the battle).
  If IgnoreMyself is true, then this function will ignore our team, ally and team color
  numbers while trying to figure out best possible numbers. This should be used
  for example when trying to figure out best numbers once we've joined the battle,
  but our current numbers are undefined - although they are set to some value,
  these values should be reset. }
function TBattleForm.FigureOutBestPossibleTeamAllyAndColor(IgnoreMyself: Boolean; var BestTeam, BestAlly, BestColorIndex: Integer): Boolean;
var
  i: Integer;
  team, ally, color: Integer;
  found: Boolean;
begin
  Result := False;

  if not IsBattleActive then Exit; // should not happen!

  if BattleState.Battle.BattleType = 1 then Exit;

  // find first available team and ally:
  team := 0;
  found := False;
  while not Found do
  begin
    Found := True;
    for i := 0 to BattleState.Battle.Clients.Count - 1 do
      if (not IgnoreMyself) or (TClient(BattleState.Battle.Clients[i]).Name <> Status.Username) then // ignore ourselves only if set so by IgnoreMyself
        if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then
          if TClient(BattleState.Battle.Clients[i]).GetTeamNo = team then
          begin
            Inc(team);
            Found := False;
            Break;
          end;
    for i := 0 to BattleState.Battle.Bots.Count - 1 do
      if TBot(BattleState.Battle.Bots[i]).GetTeamNo = team then
      begin
        Inc(team);
        Found := False;
        Break;
      end;
  end;
  ally := team;

  // find first available team color:
  color := 0; // color index in TeamColors array
  found := False;
  while not Found do
  begin
    Found := True;
    for i := 0 to BattleState.Battle.Clients.Count - 1 do
      if (not IgnoreMyself) or (TClient(BattleState.Battle.Clients[i]).Name <> Status.Username) then // ignore ourselves only if set so by IgnoreMyself
        if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then
          if TClient(BattleState.Battle.Clients[i]).TeamColor = TeamColors[color] then
          begin
            Inc(color);
            Found := False;
            Break;
          end;
    for i := 0 to BattleState.Battle.Bots.Count - 1 do
      if TBot(BattleState.Battle.Bots[i]).TeamColor = TeamColors[color] then
      begin
        Inc(color);
        Found := False;
        Break;
      end;
  end;
  if color > 9 then color := 0;
  if team > MAX_TEAMS-1 then team := 0;
  if ally > MAX_TEAMS-1 then ally := 0;

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

begin

  tmp := ModList.Count;
  if not Utility.ReInitLib then
  begin
    MessageDlg('Error initializing unit syncer!', mtError, [mbOK], 0);
    Application.Terminate;
  end;
  // update mod list:
  if tmp <> ModList.Count then // did number of mods change?
  begin
    s := HostBattleForm.ModsComboBox.Text;
    HostBattleForm.ModsComboBox.Items.Assign(Utility.ModList);
    HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(s));
  end;

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
  LoadLuaOptions(True,'');
  DisplayLuaOptions(ModOptionsList,ModOptionsScrollBox);
  LoadModOptionsDefault(ModName);
  panelModOptionsDefault.Visible := ModOptionsList.Count > 0;
  ModTab.Caption := 'Mod options ('+IntToStr(ModOptionsList.Count)+')';
end;

procedure TBattleForm.ChangeMapToNoMap(MapName: string);
var
  s: string;
begin
  if (Length(MapName) > 1) and (MapName[Length(MapName)] <> '.') then // we need this in order to not cut a '.' char from strings like "Loading..." (which are not true file names ofcourse)
    MapName := Copy(MapName, 1, Length(MapName) - Length(ExtractFileExt(MapName))); // remove '.smf'

  MapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
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

  MapSizeLabel.Caption := 'Map size: ?';
  TidalStrengthLabel.Caption := 'Tidal strength: ?';
  GravityLabel.Caption := 'Gravity: ?';
  MaxMetalLabel.Caption := 'Max. metal: ?';
  ExtRadiusLabel.Caption := 'Extractor radius: ?';
  WindLabel.Caption := 'Wind (min/max): ?';
  MapDescLabel.Caption := 'Description: Click on the minimap to attempt to locate map in the "Online maps" list!';
  MapDescLabel.Hint := MapDescLabel.Caption;

  FCurrentMapIndex := -1;
  MapsPopupStringList.ItemIndex := -1;

  MapImage.Hint := 'No map';
end;

procedure TBattleForm.ChangeMap(MapIndex: Integer);
var
  MapInfo: TMapInfo;
begin
  if MapIndex = -1 then Exit; // you should use ChangeMapToNoMap method instead!
  if MapIndex > Utility.MapList.Count-1 then Exit; // this should not happen!
  if MapIndex = CurrentMapIndex then Exit; // no need to change anything, we already have this map loaded!

  {if TMapItem(MapListForm.Maps[MapIndex]).MapImageLoaded then
    MapImage.Picture.Bitmap.Assign(TMapItem(MapListForm.Maps[MapIndex]).MapImage.Picture.Bitmap)
  else
  begin
    TMapItem(MapListForm.Maps[MapIndex]).LoadMinimap(False);
    MapImage.Picture.Bitmap.Assign(TMapItem(MapListForm.Maps[MapIndex]).MapImage.Picture.Bitmap)
  end;}
  Utility.LoadMiniMap(TMapItem(MapListForm.Maps[MapIndex]).MapName,MapImage.Picture.Bitmap);

  MapInfo := GetMapItem(MapIndex).MapInfo;

  MapSizeLabel.Caption := 'Map size: '+IntToStr(GetMapItem(MapIndex).MapInfo.Width div 64) + ' x ' + IntToStr(GetMapItem(MapIndex).MapInfo.Height div 64);
  TidalStrengthLabel.Caption := 'Tidal strength: ' + IntToStr(MapInfo.TidalStrength);
  GravityLabel.Caption := 'Gravity: ' + IntToStr(MapInfo.Gravity);
  MaxMetalLabel.Caption := 'Max. metal: ' + Format('%.5g', [MapInfo.Maxmetal]);
  ExtRadiusLabel.Caption := 'Extractor radius: ' + IntToStr(MapInfo.ExtractorRadius);
//  Label6.Caption := 'Min. wind: ' + Format('%.5g', [MapInfo.MinWind]);
//  Label7.Caption := 'Max. wind: ' + Format('%.5g', [MapInfo.MaxWind]);
  WindLabel.Caption := 'Wind (min/max): ' + IntToStr(MapInfo.MinWind) + '-' + IntToStr(MapInfo.MaxWind);;
  MapDescLabel.Caption := 'Description: ' + MapInfo.Description;
  MapDescLabel.Hint := MapDescLabel.Caption;

  Preferences.LastOpenMap := GetMapItem(MapIndex).MapName;

  FCurrentMapIndex := MapIndex;
  MapsPopupStringList.ItemIndex := MapIndex;

  MapImage.Hint := GetMapItem(MapIndex).MapName;

  // load map options
  LoadLuaOptions(False,GetMapItem(MapIndex).MapName);
  DisplayLuaOptions(BattleForm.MapOptionsList,BattleForm.MapOptionsScrollBox);
  LoadMapOptionsDefault;
  panelMapOptionsDefault.Visible := MapOptionsList.Count > 0;
  MapTab.Caption := 'Map options ('+IntToStr(BattleForm.MapOptionsList.Count)+')';

  SendLuaOptionsDetailsToServer;
end;

procedure TBattleForm.PopulatePopupMenuMapList;
var
  i: Integer;
  validMaps: TStringList;
begin
  MapsPopupStringList.Strings.Clear;
  if not BattleForm.IsBattleActive then
  begin
    MapsPopupStringList.Strings.Assign(Utility.MapList);
    Exit;
  end;

  ReInitLib;
  LoadMod(Utility.ModArchiveList[Utility.ModList.IndexOf(BattleState.Battle.ModName)]);
  validMaps := GetModValidMapList;
  if BattleState.LadderIndex > -1 then
  begin
    for i:=0 to Utility.MapList.Count-1 do
      if (TLadder(LadderList[BattleState.LadderIndex]).Maps.IndexOf(Utility.MapList[i]) >= 0) and ((validMaps.Count =0) or (validMaps.IndexOf(Utility.MapList[i]) >= 0)) then
        MapsPopupStringList.Strings.Add(Utility.MapList[i]);
  end
  else
  begin
    if validMaps.Count =0 then
      MapsPopupStringList.Strings.Assign(Utility.MapList)
    else
      for i:=0 to validMaps.Count-1 do
        if Utility.MapList.IndexOf(validMaps[i]) >= 0 then
          MapsPopupStringList.Strings.Add(validMaps[i]);
  end;
end;

procedure TBattleForm.MapsPopupMenuItemClick(Sender: TObject);
var
  index : integer;
begin
  index :=  Utility.MapList.IndexOf(MapsPopupStringList.Strings.Strings[MapsPopupStringList.ItemIndex]);
  if IsBattleActive and (BattleState.Status = Joined) then
  begin
    //*** MessageDlg('Only battle host is able to change map!', mtWarning, [mbOK], 0);
    MainForm.TryToSendCommand('SAYBATTLEEX', 'suggests ' + Utility.MapList[index]);
    MapsPopupStringList.ItemIndex := CurrentMapIndex;
    Exit;
  end;

  if IsBattleActive and (BattleState.Battle.BattleType = 1) then
  begin
    MessageDlg('Cannot change map while hosting battle replay!', mtWarning, [mbOK], 0);
    MapsPopupStringList.ItemIndex := CurrentMapIndex;
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
    MainForm.AddMainLog('Error while sending UDP packet to ' + TClient(BattleState.Battle.Clients[i]).Name + ' (IP=' + TClient(BattleState.Battle.Clients[i]).IP + ')', Colors.Error);
  end;
end;

procedure TBattleForm.OnStartGameMessage(var Msg: TMessage); // responds to WM_STARTGAME message
var
  i,j: Integer;
  v,springexe: string;
  script:string;
  scriptGenerationResult: boolean;
begin
  if not IsBattleActive then Exit; // this should not happen

  if Status.AmIInGame then Exit;

  if (BattleState.Status = Hosting) then
    case BattleState.Battle.NATType of
    0: ;
    1: PunchThroughNAT;
    2: for i := 1 {skip the host} to BattleState.Battle.Clients.Count-1 do
       try
         if TClient(BattleState.Battle.Clients[i]).IP = '' then MainForm.AddMainLog('Error punching through NAT: player''s IP is unknown!', Colors.Error)
         else Misc.SendUDPStrEx(TClient(BattleState.Battle.Clients[i]).IP, FIRST_UDP_SOURCEPORT + i - 1, BattleState.Battle.Port, 2, 'HELLO'); // what we send doesn't really matter (we could probably send an empty packet as well).
       except
         MainForm.AddMainLog('Error while sending UDP packet to ' + TClient(BattleState.Battle.Clients[i]).Name + ' (IP=' + TClient(BattleState.Battle.Clients[i]).IP + ')', Colors.Error);
       end;
    end;

  BattleForm.AmIReady := False; // status is automatically updated in this property's "setter"

//***  DeleteFile(ExtractFilePath(Application.ExeName) + 'script.txt'); // no problem if file does not exist (function will return FALSE in that case)

  if BattleState.Battle.BattleType = 0 then
    scriptGenerationResult := GenerateNormalScriptFile(ExtractFilePath(Application.ExeName) + 'script.txt')
  else scriptGenerationResult := GenerateReplayScriptFile(ExtractFilePath(Application.ExeName) + 'script.txt');

  if not scriptGenerationResult then
    Exit;

  FillChar(BattleState.Process.proc_info, sizeof(TProcessInformation), 0);
  FillChar(BattleState.Process.startinfo, sizeof(TStartupInfo), 0);
  BattleState.Process.startinfo.cb := sizeof(TStartupInfo);

  if BattleState.Battle.BattleType = 1 then begin
    ReplaysForm.ReadScriptFromDemo(ExtractFilePath(Application.ExeName) + 'demos\' +BattleReplayInfo.ReplayFilename, script);
    i := Pos('GameVersion=', script);
    i := i + 12;
    j := PosEx(';', script, i);
    if (i<>0) and (j<>0) then v := Copy(script, i, j-i);

    springexe := 'spring'+v+'.exe';
    if not FileExists(springexe) then
      springexe := 'spring.exe';
  end
  else
    springexe := 'spring.exe';

  if CreateProcess(nil, PChar(ExtractFilePath(Application.ExeName) + springexe + ' script.txt'), nil, nil, false, CREATE_DEFAULT_ERROR_MODE + NORMAL_PRIORITY_CLASS,
                   nil, PChar(ExtractFilePath(Application.ExeName)), BattleState.Process.startinfo, BattleState.Process.proc_info) then
  begin
    AddTextToChat('Game launched', Colors.Info, 1);
    Status.AmIInGame := True;
    MainForm.TryToSendCommand('MYSTATUS', '1');
    GameTimer.Enabled := True;
  end
  else
  begin
    CloseHandle(BattleState.Process.proc_info.hProcess);
    Application.MessageBox('Couldn''t execute the application', 'Error', MB_ICONEXCLAMATION);
  end;
end;

function TBattleForm.JoinBattle(BattleID: Integer): Boolean;
var
  Battle: TBattle;
  tmp: Integer;
  i: integer;
  validMaps: TStringList;
begin
  Result := False;

  if BattleState.Status <> None then
  begin // this should NEVER happen!
    MessageDlg('Error: cannot participate in multiple battles. Please report this error!', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  Battle := MainForm.GetBattle(BattleID);
  if Battle = nil then Exit;

  BattleState.Battle := Battle;

  DisabledUnitsListBox.Clear;

  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  EnableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := True;
  AddUnitsSpeedButton.Enabled := False;
  LimitDGunCheckBox.Enabled := False;
  DiminishingMMsCheckBox.Enabled := False;
  GhostedBuildingsCheckBox.Enabled := False;
  LockGameSpeedCheckBox.Enabled := False;
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
  LadderRulesButton.Enabled := BattleState.Battle.IsLadderBattle;

  MetalTracker.Minimum := 0;
  MetalTracker.Maximum := 10000;
  EnergyTracker.Minimum := 0;
  EnergyTracker.Maximum := 10000;
  UnitsTracker.Minimum := 0;
  UnitsTracker.Maximum := 5000;


//  SetMyBattleStatus(SideComboBox.ItemIndex, False, 0, 0, 1, MyTeamColorIndex); *** we will update it once we receive REQUESTBATTLESTATUS
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS (server should send it after he is finished sending us battle statuses of other players)

  BattleState.Battle.RemoveAllBots;
  UpdateClientsListBox;

  BattleState.Status := Joined;

  // display only mod maps
  validMaps := GetModValidMapList;
  if validMaps.Count >0 then
  begin
    MapsPopupStringList.Strings.Clear;
    for i:=0 to validMaps.Count-1 do
      if Utility.MapList.IndexOf(validMaps[i]) > -1 then
        MapsPopupStringList.Strings.Add(validMaps[i]);
  end;
  
  // update map:
  if (CurrentMapIndex = -1) or (Battle.Map <> GetMapItem(CurrentMapIndex).MapName) then
    if Utility.MapList.IndexOf(Battle.Map) = -1 then ChangeMapToNoMap(Battle.Map)
    else ChangeMap(Utility.MapList.IndexOf(Battle.Map));

  // disable map options
  for i := 0 to MapOptionsList.Count-1 do
    TLuaOption(MapOptionsList[i]).Disable;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := True;

  if BattleState.Battle.IsLadderBattle then begin
    VDTBattleClients.Header.Columns[7].MaxWidth := 40;
    VDTBattleClients.Header.Columns[7].MinWidth := 40;
    VDTBattleClients.Header.Columns[8].MaxWidth := 40;
    VDTBattleClients.Header.Columns[8].MinWidth := 40;
  end
  else
  begin
    VDTBattleClients.Header.Columns[7].MinWidth := 0;
    VDTBattleClients.Header.Columns[7].MaxWidth := 0;
    VDTBattleClients.Header.Columns[8].MinWidth := 0;
    VDTBattleClients.Header.Columns[8].MaxWidth := 0;
  end;

  AddTextToChat('Joined battle', Colors.Info, 1);

  ResetStartRects;
  BattleForm.Caption := 'Battle window (' + BattleState.Battle.ModName + ')'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := 'Battle window (' + BattleState.Battle.ModName + ')';

  Result := True;

  if not Preferences.DisableAllSounds then PlayResSound('battle');

//*** anything else?
end;

function TBattleForm.JoinBattleReplay(BattleID: Integer): Boolean;
var
  Battle: TBattle;
  tmp: Integer;
  i: Integer;
begin
  Result := False;

  if BattleState.Status <> None then
  begin // this should NEVER happen!
    MessageDlg('Error: cannot participate in multiple battles. Please report this error!', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  Battle := MainForm.GetBattle(BattleID);
  if Battle = nil then Exit;

  BattleState.Battle := Battle;

  DisabledUnitsListBox.Clear;

  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := True;
  AddUnitsSpeedButton.Enabled := False;
  LimitDGunCheckBox.Enabled := False;
  DiminishingMMsCheckBox.Enabled := False;
  GhostedBuildingsCheckBox.Enabled := False;
  LockGameSpeedCheckBox.Enabled := False;
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
  LadderRulesButton.Enabled := False;

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

  VDTBattleClients.Header.Columns[7].MinWidth := 0;
  VDTBattleClients.Header.Columns[7].MaxWidth := 0;
  VDTBattleClients.Header.Columns[8].MinWidth := 0;
  VDTBattleClients.Header.Columns[8].MaxWidth := 0;

  AddTextToChat('Joined battle replay', Colors.Info, 1);

  BattleState.Status := Joined;

  ResetStartRects;
  BattleForm.Caption := 'Battle window (' + BattleState.Battle.ModName + ')'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := 'Battle window (' + BattleState.Battle.ModName + ')';


  Result := True;

  if not Preferences.DisableAllSounds then PlayResSound('battle');

//*** anything else?
end;

function TBattleForm.HostBattle(BattleID: Integer): Boolean;
var
  i:integer;
  disabledUnits: string;
  Battle: TBattle;
  LMThread : TLadderMapThread;
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

  BattleState.Battle := Battle;
  BattleState.BanList := TStringList.Create;

  DisabledUnitsListBox.Clear;

  if BattleState.LadderIndex > -1 then begin
    disabledUnits := '';
    for i:=0 to TLadder(LadderList[BattleState.LadderIndex]).Restricted.Count-1 do begin
      DisabledUnitsListBox.Items.Add(TLadder(LadderList[BattleState.LadderIndex]).Restricted[i]);
      disabledUnits := disabledUnits + ' ' + TLadder(LadderList[BattleState.LadderIndex]).Restricted[i];
    end;

    MainForm.TryToSendCommand('ENABLEALLUNITS');
    Delete(disabledUnits, 1, 1); // remove first space character
    MainForm.TryToSendCommand('DISABLEUNITS', disabledUnits);

    VDTBattleClients.Header.Columns[7].MaxWidth := 40;
    VDTBattleClients.Header.Columns[7].MinWidth := 40;
    VDTBattleClients.Header.Columns[8].MaxWidth := 40;
    VDTBattleClients.Header.Columns[8].MinWidth := 40;
  end
  else
  begin
    VDTBattleClients.Header.Columns[7].MinWidth := 0;
    VDTBattleClients.Header.Columns[7].MaxWidth := 0;
    VDTBattleClients.Header.Columns[8].MinWidth := 0;
    VDTBattleClients.Header.Columns[8].MaxWidth := 0;
  end;

  StartPosRadioGroup.Enabled := True;
  GameEndRadioGroup.Enabled := True;
  EnableControlAndChildren(ResourcesGroupBox);
  EnableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := True;
  AddUnitsSpeedButton.Enabled := True;
  LimitDGunCheckBox.Enabled := True;
  DiminishingMMsCheckBox.Enabled := True;
  GhostedBuildingsCheckBox.Enabled := True;
  LockGameSpeedCheckBox.Enabled := True;
  LockedCheckBox.Enabled := True;
  AdminButton.Enabled := True;
  LockedCheckBox.Checked := False;
  AutoStartRectsApplyItem.Enabled := True;
  AutoStartRectsOptionsItem.Enabled := True;
  LadderRulesButton.Enabled := BattleState.Battle.IsLadderBattle;

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
  BattleForm.Caption := 'Battle window (' + BattleState.Battle.ModName + ')'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := 'Battle window (' + BattleState.Battle.ModName + ')';

  Result := True;

  if not Preferences.DisableAllSounds then PlayResSound('battle');
  BattleForm.mnuLoadBoxesClick(BattleForm.mnuLoadBoxes);

  if BattleState.LadderIndex > -1 then
    LMThread := TLadderMapThread.Create(False);

  // display only mod maps
  validMaps := GetModValidMapList;
  if validMaps.Count >0 then
  begin
    MapsPopupStringList.Strings.Clear;
    for i:=0 to validMaps.Count-1 do
      if Utility.MapList.IndexOf(validMaps[i]) > -1 then
        MapsPopupStringList.Strings.Add(validMaps[i]);
    ChangeMap(Utility.MapList.IndexOf(MapsPopupStringList.Strings[0]))
  end;

  // load map options
  if CurrentMapIndex > -1 then
  begin
    LoadLuaOptions(False,TMapItem(MapListForm.Maps[CurrentMapIndex]).MapName);
    DisplayLuaOptions(BattleForm.MapOptionsList,BattleForm.MapOptionsScrollBox);
    LoadMapOptionsDefault;
    panelMapOptionsDefault.Visible := MapOptionsList.Count > 0;
  end;
  MapTab.Caption := 'Map options ('+IntToStr(BattleForm.MapOptionsList.Count)+')';

  AddTextToChat('Battle opened', Colors.Info, 1);

//*** anything else?
end;

function TBattleForm.HostBattleReplay(BattleID: Integer): Boolean;
var
  Battle: TBattle;
  i:integer;
  script : TScript;
begin
  Result := False;

  script := TScript.Create(BattleReplayInfo.Script.GetText);

  if IsBattleActive then
  begin // this should NEVER happen!
    MessageDlg('Error: cannot participate in multiple battles. Please report this error!', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  Battle := MainForm.GetBattle(BattleID);
  if Battle = nil then Exit;

  BattleState.Battle := Battle;
  BattleState.BanList := TStringList.Create;

  DisabledUnitsListBox.Clear;

  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := True;
  AddUnitsSpeedButton.Enabled := False;
  LimitDGunCheckBox.Enabled := False;
  DiminishingMMsCheckBox.Enabled := False;
  GhostedBuildingsCheckBox.Enabled := False;
  LockGameSpeedCheckBox.Enabled := True;
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
  LadderRulesButton.Enabled := BattleState.Battle.IsLadderBattle;

  SetMyBattleStatus(0, False, 0, 0, 1);
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS

  BattleState.Battle.RemoveAllBots;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := False;

  VDTBattleClients.Header.Columns[7].MinWidth := 0;
  VDTBattleClients.Header.Columns[7].MaxWidth := 0;
  VDTBattleClients.Header.Columns[8].MinWidth := 0;
  VDTBattleClients.Header.Columns[8].MaxWidth := 0;

  AddTextToChat('Battle replay opened', Colors.Info, 1);

  BattleState.Status := Hosting;

  ResetStartRects;
  BattleForm.Caption := 'Battle window (' + BattleState.Battle.ModName + ')'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := 'Battle window (' + BattleState.Battle.ModName + ')';

  // add boxes
  i:=0;
  while script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'\StartRectLeft')<>'' do
  begin
    AddStartRect(i,Rect(Round(StrToFloat(script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'\StartRectLeft'))*MapImage.Width),Round(StrToFloat(script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'\StartRectTop'))*MapImage.Width),Round(StrToFloat(script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'\StartRectRight'))*MapImage.Width),Round(StrToFloat(script.ReadKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'\StartRectBottom'))*MapImage.Width)));
    with BattleState.StartRects[i] do
        MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(i) + ' ' + IntToStr(Rect.Left) + ' ' + IntToStr(Rect.Top) + ' ' + IntToStr(Rect.Right) + ' ' + IntToStr(Rect.Bottom) + ' ');
    i := i+1;
  end;


  // load map options
  LoadLuaOptions(False,TMapItem(MapListForm.Maps[CurrentMapIndex]).MapName);
  DisplayLuaOptions(BattleForm.MapOptionsList,BattleForm.MapOptionsScrollBox);
  LoadMapOptionsDefault;
  panelMapOptionsDefault.Visible := MapOptionsList.Count > 0;
  MapTab.Caption := 'Map options ('+IntToStr(BattleForm.MapOptionsList.Count)+')';

  // disable mod options
  for i := 0 to ModOptionsList.Count-1 do
    TLuaOption(ModOptionsList[i]).Disable;

  // disable map options
  for i := 0 to MapOptionsList.Count-1 do
    TLuaOption(MapOptionsList[i]).Disable;

  if not ApplyScriptFile(BattleReplayInfo.Script) then
  begin
    MessageDlg('Unexpected inconsistency error: Script file is corrupt! Program will now exit ...', mtError, [mbOK], 0);
    Application.Terminate;
    MainForm.Close;
    Exit;
  end;

  SendReplayScriptToServer;

  UpdateClientsListBox;

  Result := True;

  if not Preferences.DisableAllSounds then PlayResSound('battle');

//*** anything else?
end;

{ resets the battle screen: clears the clients list, enables/disables controls, ... }
procedure TBattleForm.ResetBattleScreen;
begin
  if IsBattleActive then
  begin
    AddTextToChat('Battle closed', Colors.Info, 1);
    if not Preferences.DisableAllSounds then PlayResSound('battle');
  end;

  MapsPopupStringList.Strings.Assign(Utility.MapList);

  BattleState.Status := None;

  DisabledUnitsListBox.Clear;
  DisabledUnitsTab.Caption := 'Disabled Units (0)';

  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyButton.Enabled := False;
  AddUnitsSpeedButton.Enabled := False;
  LimitDGunCheckBox.Enabled := False;
  DiminishingMMsCheckBox.Enabled := False;
  GhostedBuildingsCheckBox.Enabled := False;
  LockGameSpeedCheckBox.Enabled := False;
  LockedCheckBox.Enabled := False;
  AdminButton.Enabled := False;
  LoadDefaultButton.Enabled := False;
  btLoadDefaultMDO.Enabled := False;
  btLoadModsDefaultMDO.Enabled := False;
  btLoadDefaultMPO.Enabled := False;
  btLoadMapsDefaultMPO.Enabled := False;
  AutoStartRectsApplyItem.Enabled := False;
  AutoStartRectsOptionsItem.Enabled := False;
  LadderRulesButton.Enabled := False;

  SetMyBattleStatus(MySideButton.Tag, False, 0, 0, 1);
  ChangeTeamColor(MyTeamColorIndex, False);

  lblTeamNbr.Caption := '';

  UpdateClientsListBox;

  DisconnectButton.Enabled := False;
  StartButton.Enabled := False;
  HostButton.Enabled := True;
  AddBotButton.Enabled := False;

  ResetStartRects;
  BattleForm.Caption := 'Battle window'; // this has no effect since battle form was skinned using TSpTBXTitleBar!
  SpTBXTitleBar1.Caption := 'Battle window';

  // custom options reset
  if ModOptionsList <> nil then
    Utility.UnLoadLuaOptions(ModOptionsList);
  if MapOptionsList <> nil then
    Utility.UnLoadLuaOptions(MapOptionsList);
  panelModOptionsDefault.Visible := false;
  panelMapOptionsDefault.Visible := false;
  ModTabSheet.Caption := 'Mod options (0)';
  MapTabSheet.Caption := 'Map options (0)';
  if UnknownScriptTagList.CompleteKeyList <> nil then
    UnknownScriptTagList.CompleteKeyList.Clear;
  if UnknownScriptTagList.ValueList <> nil then
    UnknownScriptTagList.ValueList.Clear;

//*** anything else?
end;

function TBattleForm.ApplyScriptFile(ScriptSL: TStringList): Boolean;
var
  s, su: string;
  Script: TScript;
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

    s := ScriptSL.Text;                                            
    su := UpperCase(s);

    // now let's read various info from script:
    Script := TScript.Create(s);
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

          client := TClient.Create(name, 0, 'xx', 0);
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
        if count = 0 then raise Exception.Create('Corrupt script file!');

        count := 0;
        while True do
        begin
          tmp := Script.ReadKeyValue('GAME/TEAM'+IntToStr(count)+'/ALLYTEAM');
          if tmp = '' then break;
          ally := StrToInt(tmp);
          tmp := Script.ReadKeyValue('GAME/TEAM'+IntToStr(count)+'/RGBCOLOR');
          if tmp = '' then raise Exception.Create('Corrupt script file!');
          sl := StringParser.ParseString(tmp, ' ');
          if sl.Count <> 3 then raise Exception.Create('Corrupt script file!');
          color := Misc.PackRGB(StrToFloat(sl[0]), StrToFloat(sl[1]), StrToFloat(sl[2]));
          tmp := Script.ReadKeyValue('GAME/TEAM'+IntToStr(count)+'/SIDE');
          if tmp = '' then raise Exception.Create('Corrupt script file!');
          SideList.CaseSensitive := False;
          side := SideList.IndexOf(tmp);
          if side = -1 then raise Exception.Create('Corrupt script file!');
          tmp := Script.ReadKeyValue('GAME/TEAM'+IntToStr(count)+'/HANDICAP');
          if tmp = '' then raise Exception.Create('Corrupt script file!');
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
        if count = 0 then raise Exception.Create('Corrupt script file!');

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
        metal := Script.ReadStartMetal;
        energy := Script.ReadStartEnergy;
        units := Script.ReadMaxUnits;
        startpos := Script.ReadStartPosType;
        gamemode := Script.ReadGameMode;
        // also read the optional parameters:
        try
          limitdgun := Script.ReadLimitDGun;
        except
          limitdgun := False;
        end;
        try
          diminishingmms := Script.ReadDiminishingMMs;
        except
          diminishingmms := False;
        end;
        try
          ghostedbuildings := Script.ReadGhostedBuildings;
        except
          ghostedbuildings := False;
        end;
      except
        raise Exception.Create('Corrupt script file!');
      end;
    finally
      Script.Free;
    end;

    // apply changes:
    i := Utility.MapList.IndexOf(map);
    if i = -1 then ChangeMapToNoMap(map)
    else if CurrentMapIndex <> i then ChangeMap(i);

    {-->} AllowBattleDetailsUpdate := False;
    MetalTracker.Value := metal;
    EnergyTracker.Value := energy;
    UnitsTracker.Value := units;
    StartPosRadioGroup.ItemIndex := startpos;
    GameEndRadioGroup.ItemIndex := gamemode;
    LimitDGunCheckBox.Checked := limitdgun;
    DiminishingMMsCheckBox.Checked := limitdgun;
    GhostedBuildingsCheckBox.Checked := ghostedbuildings;
    {-->} AllowBattleDetailsUpdate := True;

  except
    FreeReplayClients; // just in case we actually managed to add some clients
    Exit;
  end;

  Result := True;

end;     

function TBattleForm.GenerateNormalScriptFile(FileName: string):Boolean;
var
  f: TextFile;
  NumberOfTeams: Integer;
  NumberOfAllyTeams: Integer;
  i, j: Integer;
  Pos: Integer;
  ModFileName: string;
  tmp: Integer;
  tmpbool: Boolean;
  index: Integer;
  MyPlayerNum: Integer;
  Script: TScript;
  sl: TStrings;
  tryToRewriteScript: Boolean;

  PurgedClients: array of // without spectators and with shifted team and ally numbers. Bots are included too.
  record
    Bot: Boolean; // if this client is a bot
    ClientIndex: Integer;
    TeamNo: Integer;
    AllyNo: Integer;
    TeamColor: Integer;
    Side: Integer;
    Handicap: Integer;
  end;

  TeamToPurgedTeam: array[0..MAX_TEAMS-1] of Integer; // TeamToPurgedTeam[IndexOfTeam]: IndexOfPurgedTeam
  AllyToPurgedAlly: array[0..MAX_TEAMS-1] of Integer; // AllyToPurgedAlly[IndexOfAllyTeam]: IndexOfPurgedAllyTeam

  // "purging" is needed for one reason: there mustn't be any gaps between team/ally numbers

begin
  Script := TScript.Create('');

  // get mod archive name:
  i := ModList.IndexOf(BattleState.Battle.ModName);
  if i = -1 then
  begin
    MessageDlg('Error: mod not found (' + BattleState.Battle.ModName + ')', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;
  ModFileName := ModArchiveList[i];

  // do the "purging":

  NumberOfTeams := 0;
  for i := 0 to High(TeamToPurgedTeam) do TeamToPurgedTeam[i] := -1;
  for i := 0 to BattleState.Battle.Clients.Count-1 do if TClient(BattleState.Battle.Clients[i]).GetMode = 1 then if TeamToPurgedTeam[TClient(BattleState.Battle.Clients[i]).GetTeamNo] = -1 then
  begin
    TeamToPurgedTeam[TClient(BattleState.Battle.Clients[i]).GetTeamNo] := NumberOfTeams;
    Inc(NumberOfTeams);
  end;
  for i := 0 to BattleState.Battle.Bots.Count-1 do if TeamToPurgedTeam[TBot(BattleState.Battle.Bots[i]).GetTeamNo] = -1 then
  begin
    TeamToPurgedTeam[TBot(BattleState.Battle.Bots[i]).GetTeamNo] := NumberOfTeams;
    Inc(NumberOfTeams);
  end;

  NumberOfAllyTeams := 0;
  for i := 0 to High(AllyToPurgedAlly) do AllyToPurgedAlly[i] := -1;
  for i := 0 to BattleState.Battle.Clients.Count-1 do if TClient(BattleState.Battle.Clients[i]).GetMode = 1 then if AllyToPurgedAlly[TClient(BattleState.Battle.Clients[i]).GetAllyNo] = -1 then
  begin
    AllyToPurgedAlly[TClient(BattleState.Battle.Clients[i]).GetAllyNo] := NumberOfAllyTeams;
    Inc(NumberOfAllyTeams);
  end;
  for i := 0 to BattleState.Battle.Bots.Count-1 do if AllyToPurgedAlly[TBot(BattleState.Battle.Bots[i]).GetAllyNo] = -1 then
  begin
    AllyToPurgedAlly[TBot(BattleState.Battle.Bots[i]).GetAllyNo] := NumberOfAllyTeams;
    Inc(NumberOfAllyTeams);
  end;

  // update spectator count, just in case if current one is invalid:
  tmp := 0;
  for i := 0 to BattleState.Battle.Clients.Count-1 do
    if TClient(BattleState.Battle.Clients[i]).GetMode = 0 then Inc(tmp);
  BattleState.Battle.SpectatorCount := tmp;

  tmp := 0;
  SetLength(PurgedClients, BattleState.Battle.Clients.Count - BattleState.Battle.SpectatorCount + BattleState.Battle.Bots.Count);
  for i := 0 to BattleState.Battle.Clients.Count-1 do if TClient(BattleState.Battle.Clients[i]).GetMode = 1 then
  begin
    PurgedClients[tmp].Bot := False;
    PurgedClients[tmp].ClientIndex := i;
    PurgedClients[tmp].TeamNo := TeamToPurgedTeam[TClient(BattleState.Battle.Clients[i]).GetTeamNo];
    PurgedClients[tmp].AllyNo := AllyToPurgedAlly[TClient(BattleState.Battle.Clients[i]).GetAllyNo];
    PurgedClients[tmp].TeamColor := TClient(BattleState.Battle.Clients[i]).TeamColor;
    PurgedClients[tmp].Side := TClient(BattleState.Battle.Clients[i]).GetSide;
    PurgedClients[tmp].Handicap := TClient(BattleState.Battle.Clients[i]).GetHandicap;
    Inc(tmp);
  end;
  for i := 0 to BattleState.Battle.Bots.Count-1 do
  begin
    PurgedClients[tmp].Bot := True;
    PurgedClients[tmp].ClientIndex := i;
    PurgedClients[tmp].TeamNo := TeamToPurgedTeam[TBot(BattleState.Battle.Bots[i]).GetTeamNo];
    PurgedClients[tmp].AllyNo := AllyToPurgedAlly[TBot(BattleState.Battle.Bots[i]).GetAllyNo];
    PurgedClients[tmp].TeamColor := TBot(BattleState.Battle.Bots[i]).TeamColor;
    PurgedClients[tmp].Side := TBot(BattleState.Battle.Bots[i]).GetSide;
    PurgedClients[tmp].Handicap := TBot(BattleState.Battle.Bots[i]).GetHandicap;
    Inc(tmp);
  end;

  // get my player number:
  MyPlayerNum := BattleState.Battle.Clients.IndexOf(Status.Me);

  // now let's write the script file:

  Script.AddOrChangeKeyValue('GAME/Mapname',BattleState.Battle.Map);
  //Script.AddOrChangeKeyValue('GAME/Maphash',Utility.MapChecksums[Utility.MapList.indexOf(BattleState.Battle.Map)]);
  Script.AddOrChangeKeyValue('GAME/StartMetal',IntToStr(MetalTracker.Value));
  Script.AddOrChangeKeyValue('GAME/StartEnergy',IntToStr(EnergyTracker.Value));
  Script.AddOrChangeKeyValue('GAME/MaxUnits',IntToStr(UnitsTracker.Value));
  Script.AddOrChangeKeyValue('GAME/StartPosType',IntToStr(StartPosRadioGroup.ItemIndex));
  Script.AddOrChangeKeyValue('GAME/GameMode',IntToStr(GameEndRadioGroup.ItemIndex));
  Script.AddOrChangeKeyValue('GAME/GameType',ModFileName);
  Script.AddOrChangeKeyValue('GAME/ModHash',IntToStr(GetModHash(BattleState.Battle.ModName)));
  Script.AddOrChangeKeyValue('GAME/LimitDGun',IntToStr(BoolToInt(LimitDGunCheckBox.Checked)));
  Script.AddOrChangeKeyValue('GAME/DiminishingMMs',IntToStr(BoolToInt(DiminishingMMsCheckBox.Checked)));
  Script.AddOrChangeKeyValue('GAME/GhostedBuildings',IntToStr(BoolToInt(GhostedBuildingsCheckBox.Checked)));

  if BattleState.Status = Hosting then
  begin
    Script.AddOrChangeKeyValue('GAME/HostIP','localhost');
    if BattleState.Battle.NATType = 1 then
      Script.AddOrChangeKeyValue('GAME/HostPort',IntToStr(NATTraversal.MyPrivateUDPSourcePort))
    else
      Script.AddOrChangeKeyValue('GAME/HostPort',IntToStr(BattleState.Battle.Port));
    if LockGameSpeedCheckBox.Checked then
    begin
      Script.AddOrChangeKeyValue('GAME/MinSpeed','1');
    end;
  end
  else
  begin
    Script.AddOrChangeKeyValue('GAME/HostIP',BattleState.Battle.IP);
    Script.AddOrChangeKeyValue('GAME/HostPort',IntToStr(BattleState.Battle.Port));
  end;

  if not (BattleState.Status = Hosting) then
    case BattleState.Battle.NATType of
    0: ; // use default (system assigned) port
    1: Script.AddOrChangeKeyValue('GAME/SourcePort',IntToStr(NATTraversal.MyPrivateUDPSourcePort));
    2: Script.AddOrChangeKeyValue('GAME/SourcePort',IntToStr(FIRST_UDP_SOURCEPORT + MyPlayerNum - 1{skip the host}));
    end; // of case sentence
  Script.AddOrChangeKeyValue('GAME/MyPlayerNum',IntToStr(MyPlayerNum));
  Script.AddOrChangeKeyValue('GAME/NumPlayers',IntToStr(BattleState.Battle.Clients.Count));
  Script.AddOrChangeKeyValue('GAME/NumTeams',IntToStr(NumberOfTeams));
  Script.AddOrChangeKeyValue('GAME/NumAllyTeams',IntToStr(NumberOfAllyTeams));

  // players:
  Pos := 0;
    for i := 0 to BattleState.Battle.Clients.Count-1 do
    begin
      Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/Name',TClient(BattleState.Battle.Clients[i]).Name);
      Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/countryCode',TClient(BattleState.Battle.Clients[i]).Country);
      Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/Rank',IntToStr(TClient(BattleState.Battle.Clients[i]).GetRank));
      if TClient(BattleState.Battle.Clients[i]).GetMode = 0 then
      begin
        Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/Spectator','1');
      end
      else
      begin
        Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/Spectator','0');
        Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/team',IntToStr(PurgedClients[Pos].TeamNo));
        Inc(Pos);
      end;
    end;

  // teams:
  for i := 0 to NumberOfTeams-1 do
  begin

    // is there a bot on the team?
    tmpBool := False;
    for j := 0 to High(PurgedClients) do if (PurgedClients[j].TeamNo = i) and (PurgedClients[j].Bot) then
    begin
      tmpBool := True;
      Break;
    end;

    for j := 0 to High(PurgedClients) do if (PurgedClients[j].TeamNo = i) and (PurgedClients[j].Bot or not tmpBool) then
    begin
      if tmpBool then
      begin
        index := MainForm.GetClientIndexEx(TBot(BattleState.Battle.Bots[PurgedClients[j].ClientIndex]).OwnerName, BattleState.Battle.Clients);
        if index = -1 then
        begin
          MessageDlg('Error: bot owner not found in client list. Generating script file failed!', mtError, [mbOK], 0);
          Exit;
        end;
        Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i)+'/TeamLeader',IntToStr(index));
      end
      else
        Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i)+'/TeamLeader',IntToStr(PurgedClients[j].ClientIndex));

      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i)+'/AllyTeam',IntToStr(PurgedClients[j].AllyNo));
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i)+'/RGBColor',FloatToStrF(Misc.ColorToR(PurgedClients[j].TeamColor) / 255, ffFixed, 5, 5) + ' ' + FloatToStrF(Misc.ColorToG(PurgedClients[j].TeamColor) / 255, ffFixed, 5, 5)+ ' ' + FloatToStrF(Misc.ColorToB(PurgedClients[j].TeamColor) / 255, ffFixed, 5, 5));
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i)+'/Side',SideList[PurgedClients[j].Side]);
      Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i)+'/Handicap',IntToStr(PurgedClients[j].Handicap));
      if tmpBool then
        if (Length(TBot(BattleState.Battle.Bots[PurgedClients[j].ClientIndex]).AIDll) > 6) and (LeftStr(TBot(BattleState.Battle.Bots[PurgedClients[j].ClientIndex]).AIDll,6) = 'LuaAI:') then
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i)+'/AIDLL',TBot(BattleState.Battle.Bots[PurgedClients[j].ClientIndex]).AIDll)
        else
          Script.AddOrChangeKeyValue('GAME/TEAM'+IntToStr(i)+'/AIDLL',AIDLL_FOLDER + '/' + TBot(BattleState.Battle.Bots[PurgedClients[j].ClientIndex]).AIDll);
      Break;
    end;
  end;
  // ally teams:
  for i := 0 to NumberOfAllyTeams-1 do
  begin
    Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/NumAllies','0'); // this number is not important

    if StartPosRadioGroup.ItemIndex = 2 then
      for j := 0 to High(BattleState.StartRects) do
        if BattleState.StartRects[j].Enabled then if AllyToPurgedAlly[j] = i then
        begin
          Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectLeft',FloatToStr(BattleState.StartRects[j].Rect.Left / MapImage.Width));
          Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectTop',FloatToStr(BattleState.StartRects[j].Rect.Top / MapImage.Height));
          Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectRight',FloatToStr(BattleState.StartRects[j].Rect.Right / MapImage.Width));
          Script.AddOrChangeKeyValue('GAME/ALLYTEAM'+IntToStr(i)+'/StartRectBottom',FloatToStr(BattleState.StartRects[j].Rect.Bottom / MapImage.Height));
          Break;
        end;
  end;
  // restrictions:
  Script.AddOrChangeKeyValue('GAME/NumRestrictions',IntToStr(BattleForm.DisabledUnitsListBox.Items.Count));
  for i := 0 to BattleForm.DisabledUnitsListBox.Items.Count-1 do
  begin
    Script.AddOrChangeKeyValue('GAME/RESTRICT/Unit' + IntToStr(i),BattleForm.DisabledUnitsListBox.Items[i]);
    Script.AddOrChangeKeyValue('GAME/RESTRICT/Limit' + IntToStr(i),'0');
  end;
  
  // mod options:
  for i:=0 to ModOptionsList.Count -1 do
    Script.AddOrChangeKeyValue(TLuaOption(ModOptionsList[i]).KeyPrefix + TLuaOption(ModOptionsList[i]).Key,TLuaOption(ModOptionsList[i]).toString);

  // map options:
  for i:=0 to MapOptionsList.Count -1 do
    Script.AddOrChangeKeyValue(TLuaOption(MapOptionsList[i]).KeyPrefix + TLuaOption(MapOptionsList[i]).Key,TLuaOption(MapOptionsList[i]).toString);

  // unknown setscripttags
  for i:=0 to UnknownScriptTagList.CompleteKeyList.Count -1 do
    Script.AddOrChangeKeyValue(UnknownScriptTagList.CompleteKeyList[i],UnknownScriptTagList.ValueList[i]);

  //MainForm.AddMainLog(Script.GetBruteScript,Colors.Info);

  sl := TStringList.Create;
  sl.Text := Script.Script;


  // write down the script
  repeat
  try
    AssignFile(f, FileName);
    Rewrite(f);
    for i := 0 to sl.Count-1 do Writeln(f, sl[i]);
    sl.Free;
    CloseFile(f);
    tryToRewriteScript := False;
    Result := True;
  except
    Result := False;
    try
      CloseFile(f);
    except
      //
    end;
    tryToRewriteScript := MessageDlg('Could''nt write the start script file ''script.txt'', try again ?',mtError,[mbYes,mbNo],0) = mrYes;
  end;
  until not tryToRewriteScript;

  Finalize(PurgedClients);
end;

function TBattleForm.GenerateReplayScriptFile(FileName: string):Boolean;
var
  f: TextFile;
  i: Integer;
  Script: TScript;
  sl: TStringList;
  tryToRewriteScript:boolean;
begin
  Script := TScript.Create(BattleReplayInfo.Script.Text);
  Script.ChangeMyPlayerNum(BattleState.Battle.Clients.IndexOf(Status.Me) + BattleReplayInfo.OriginalClients.Count);
  Script.ChangeNumPlayers(BattleState.Battle.Clients.Count + BattleReplayInfo.OriginalClients.Count);
  if BattleState.Status = Hosting then
    Script.AddOrChangeKeyValue('GAME/Demofile',BattleReplayInfo.ReplayFilename)
  else
    Script.AddOrChangeKeyValue('GAME/Demofile','multiplayer replay');

  if BattleState.Status = Hosting then
  begin
    Script.ChangeHostIP('localhost');

    if BattleState.Battle.NATType = 1 then
      Script.ChangeHostPort(IntToStr(NATTraversal.MyPrivateUDPSourcePort))
    else
      Script.ChangeHostPort(IntToStr(BattleState.Battle.Port));

    if LockGameSpeedCheckBox.Checked then
    begin
      Script.AddOrChangeKeyValue('GAME/MinSpeed','1');
      Script.AddOrChangeKeyValue('GAME/MaxSpeed','1');
    end
    else
    begin
      Script.RemoveKey('GAME/MinSpeed');
      Script.RemoveKey('GAME/MaxSpeed');
    end;

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

  for i := 0 to BattleReplayInfo.OriginalClients.Count-1 do Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(i)+'/IsFromDemo','1');
  for i := 0 to BattleState.Battle.Clients.Count-1 do
  begin
    Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(BattleReplayInfo.OriginalClients.Count+i)+'/NAME',TClient(BattleState.Battle.Clients[i]).Name);
    Script.AddOrChangeKeyValue('GAME/PLAYER'+IntToStr(BattleReplayInfo.OriginalClients.Count+i)+'/Spectator','1');
  end;

  sl := TStringList.Create;
  sl.Text := Script.Script;

  // write down the script
  repeat
  try
    AssignFile(f, FileName);
    Rewrite(f);
    for i := 0 to sl.Count-1 do Writeln(f, sl[i]);
    sl.Free;
    CloseFile(f);
    tryToRewriteScript := False;
    Result := True;
  except
    Result := False;
    try
      CloseFile(f);
    except
      //
    end;
    tryToRewriteScript := MessageDlg('Could''nt write the start script file ''script.txt'', try again ?',mtError,[mbYes,mbNo],0) = mrYes;
  end;
  until not tryToRewriteScript;
end;

procedure TBattleForm.FormCreate(Sender: TObject);
var
  i:integer;
  mask: Word;
begin
  Left := 10;
  Top := 10;

  FCurrentMapIndex := -1;

  Panel1.Constraints.MinHeight := Panel1.Height;

  InputEdit.Align := alBottom;
  ChatRichEdit.Align := alClient;
  mask := SendMessage(ChatRichEdit.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(ChatRichEdit.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(ChatRichEdit.Handle, EM_AUTOURLDETECT, Integer(True), 0);

  MapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
  ChangeMapToNoMap('Loading...');
  // we will load map list and current map once everything else gets initialized!

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
    Panel1.Height := Panel1.Height + 20;
  end;

  History := TWideStringList.Create;
  HistoryIndex := -1;

  BattleReplayInfo.Script := TStringList.Create;
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

  TJvXPCustomButtonHack(ReadyButton).Color := clBtnFace; // so that the button corners will be drawn correctly
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

procedure TBattleForm.StartButtonClick(Sender: TObject);
var
  res: Integer;
begin
  if not BattleState.Battle.AreAllBotsSet then
  begin
    MessageDlg('Two or more bots share the same team number. Please change that!', mtInformation, [mbOK], 0);
    Exit;
  end;

  if BattleState.Battle.Clients.Count > MAX_PLAYERS then
  begin
    MessageDlg('Too many players (spring supports up to ' + IntToStr(MAX_PLAYERS) + ' players)!', mtWarning, [mbOK], 0);
    Exit;
  end;
  
  if BattleState.Battle.BattleType = 1 then // we're hosting an online replay
    if BattleReplayInfo.OriginalClients.Count + BattleState.Battle.Clients.Count > MAX_PLAYERS then
    begin
      MessageDlg('Too many players (spring supports up to ' + IntToStr(MAX_PLAYERS) + ' players, original players from the demo included)!', mtWarning, [mbOK], 0);
      Exit;
    end;

  if BattleState.Battle.NATType = 1 then  // "hole punching" method
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

  HostBattleForm.ShowModal;
end;

procedure TBattleForm.MapImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MapInfo: TMapInfo;
  tmp: Integer;
  url: string;
begin
  if Button <> mbLeft then Exit;
  if CurrentMapIndex = -1 then // user does not have this map
  begin
    if BattleState.Status = Joined then
    begin
      if MAP_DOWNLOADER_ENABLED then
      begin
        OnlineMapsForm.Show;
        OnlineMapsForm.ScrollToMap(OnlineMapsForm.DoesOnlineMapExist(BattleState.Battle.Map));
      end
      else
        url := StringReplace(BattleState.Battle.Map,'.smf','',[rfReplaceAll, rfIgnoreCase]);
        {url := StringReplace(url,'_',' ',[rfReplaceAll, rfIgnoreCase]);
        url := StringReplace(url,'-',' ',[rfReplaceAll, rfIgnoreCase]);}
        url := 'http://spring.jobjol.nl/search_result.php?search=' + url+'&select=select_all';
        FixURL(url);
        Misc.OpenURLInDefaultBrowser(url);
    end;
    Exit;
  end;

  if (MapImage.Cursor = crCross) and (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) then
  begin
    tmp := GetFirstMissingStartRect;
    if tmp > High(BattleState.StartRects) then Exit;
    BattleState.DrawingStartRect := tmp;

    AddStartRect(tmp, Rect(X, Y, X, Y));

    Exit;
  end;

  if (BattleState.SelectedStartRect > -1) and (MapImage.Cursor = crSizeAll) and (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) then
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

  // open larger minimap:
  if GetMapItem(CurrentMapIndex).MapInfo.Width > GetMapItem(CurrentMapIndex).MapInfo.Height then
  begin
    MinimapZoomedForm.ClientWidth := 600;
    MinimapZoomedForm.ClientHeight := Round(MinimapZoomedForm.ClientWidth * GetMapItem(CurrentMapIndex).MapInfo.Height / GetMapItem(CurrentMapIndex).MapInfo.Width);
  end
  else
  begin
    MinimapZoomedForm.ClientHeight := 600;
    MinimapZoomedForm.ClientWidth := Round(MinimapZoomedForm.ClientHeight * GetMapItem(CurrentMapIndex).MapInfo.Width / GetMapItem(CurrentMapIndex).MapInfo.Height);
  end;

  MinimapZoomedForm.Image1.Width := MinimapZoomedForm.ClientWidth ;
  MinimapZoomedForm.Image1.Height := MinimapZoomedForm.ClientHeight;
  MinimapZoomedForm.Image1.Picture.Bitmap.Width := MinimapZoomedForm.ClientWidth;
  MinimapZoomedForm.Image1.Picture.Bitmap.Height := MinimapZoomedForm.ClientHeight;

  //Utility.LoadMiniMap(TMapItem(MapListForm.Maps[CurrentMapIndex]).MapName,MinimapZoomedForm.Image1.Picture.Bitmap);

  MinimapZoomedForm.Image1.Canvas.StretchDraw(Rect(0, 0, MinimapZoomedForm.Image1.Width, MinimapZoomedForm.Image1.Height), MapImage.Picture.Bitmap);
  MinimapZoomedForm.DrawBoxes;
  MinimapZoomedForm.DrawStartPositions(GetMapItem(CurrentMapIndex).MapInfo);
  MinimapZoomedForm.Caption := 'Minimap (' + Utility.MapList[CurrentMapIndex] + ', ' + IntToStr(GetMapItem(CurrentMapIndex).MapInfo.Width div 64) + ' x ' + IntToStr(GetMapItem(CurrentMapIndex).MapInfo.Height div 64) + ')';
  MinimapZoomedForm.Position := poScreenCenter;
  MinimapZoomedForm.ShowModal;
end;

procedure TBattleForm.MapImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssShift in Shift then
  begin
    if (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) then
    begin
      MapImage.Cursor := crCross;
    end;
  end
  else
    if (ssCtrl in Shift) and (BattleState.Status = Hosting) and (BattleState.Battle.BattleType =0) then
      MapImage.Cursor := crSizeAll
    else
      if (BattleState.ResizingStartRect = -1) and (BattleState.Status = Hosting) then
      if (BattleState.SelectedStartRect <> -1) then begin
        BattleState.ResizingDirection := 0;
        if (X >= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Left) and (X <= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Left + 6) then begin
          BattleState.ResizingDirection := BattleState.ResizingDirection + 1;
        end;
        if (X >= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Right-6) and (X <= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Right) then begin
          BattleState.ResizingDirection := BattleState.ResizingDirection + 4;
        end;
        if (Y >= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Top) and (Y <= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Top + 6) then begin
          BattleState.ResizingDirection := BattleState.ResizingDirection + 2;
        end;
        if (Y >= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Bottom-6) and (Y <= BattleState.StartRects[BattleState.SelectedStartRect].Rect.Bottom) then begin
          BattleState.ResizingDirection := BattleState.ResizingDirection + 8;
        end;
        if (BattleState.ResizingDirection = 1) or (BattleState.ResizingDirection = 4) then
          MapImage.Cursor := crSizeWE
        else
          if (BattleState.ResizingDirection = 2) or (BattleState.ResizingDirection = 8) then
            MapImage.Cursor := crSizeNS
          else
            if (BattleState.ResizingDirection = 3) or (BattleState.ResizingDirection = 12) then
              MapImage.Cursor := crSizeNWSE
            else
              if (BattleState.ResizingDirection = 6) or (BattleState.ResizingDirection = 9) then
                MapImage.Cursor := crSizeNESW
              else
                MapImage.Cursor := crHandPoint;
      end
      else
        MapImage.Cursor := crHandPoint
      else
        MapImage.Cursor := crHandPoint;

  if BattleState.DrawingStartRect <> -1 then
  begin
    ChangeStartRect(BattleState.DrawingStartRect, Rect(BattleState.StartRects[BattleState.DrawingStartRect].Rect.Left, BattleState.StartRects[BattleState.DrawingStartRect].Rect.Top, X, Y));
  end
  else
  begin
    if BattleState.MovingStartRect <> -1 then begin
      ChangeStartRect(BattleState.MovingStartRect, Rect(BattleState.StartRects[BattleState.MovingStartRect].Rect.Left+X-BattleState.MovingX, BattleState.StartRects[BattleState.MovingStartRect].Rect.Top+Y-BattleState.MovingY, BattleState.StartRects[BattleState.MovingStartRect].Rect.Right+X-BattleState.MovingX, BattleState.StartRects[BattleState.MovingStartRect].Rect.Bottom+Y-BattleState.MovingY));
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
      if (Abs(Right - Left) < 10) or (Abs(Bottom - Top) < 10) then
      begin // let's cancel the startrect, since it's too small
        RemoveStartRect(BattleState.DrawingStartRect);
        BattleState.DrawingStartRect := -1;
        Exit;
      end;

    end;

    NormalizeRect(BattleState.StartRects[BattleState.DrawingStartRect].Rect);

    // notify everyone about new startrect:
    if BattleState.Status = Hosting then
    begin
      StartPosRadioGroup.ItemIndex := 2; // automatically switch to "Choose in game" startpos
      
      with BattleState.StartRects[BattleState.DrawingStartRect] do
        MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(BattleState.DrawingStartRect) + ' ' + IntToStr(Rect.Left) + ' ' + IntToStr(Rect.Top) + ' ' + IntToStr(Rect.Right) + ' ' + IntToStr(Rect.Bottom) + ' ');
    end;


    BattleState.DrawingStartRect := -1;
  end;
  if BattleState.MovingStartRect <> -1 then
  begin
    with BattleState.StartRects[BattleState.MovingStartRect].Rect do
    begin
      if (Abs(Right - Left) < 10) or (Abs(Bottom - Top) < 10) then
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
      MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(BattleState.MovingStartRect) + ' ' + IntToStr(Rect.Left) + ' ' + IntToStr(Rect.Top) + ' ' + IntToStr(Rect.Right) + ' ' + IntToStr(Rect.Bottom) + ' ');
    BattleState.MovingStartRect := -1;
  end;
  if BattleState.ResizingStartRect <> -1 then
  begin
    with BattleState.StartRects[BattleState.ResizingStartRect].Rect do
    begin
      if (Abs(Right - Left) < 10) or (Abs(Bottom - Top) < 10) then
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
      MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(BattleState.ResizingStartRect) + ' ' + IntToStr(Rect.Left) + ' ' + IntToStr(Rect.Top) + ' ' + IntToStr(Rect.Right) + ' ' + IntToStr(Rect.Bottom) + ' ');
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
      if Utility.MapList.IndexOf(BattleState.Battle.Map) > -1 then begin
        Pen.Mode := pmMergeNotPen;
        Font.Color := clWhite;
        Brush.Color := $0000FFFF; { 0 b g r }
      end
      else
      begin
        Pen.Mode := pmCopy;
        Font.Color := clBlue;
        Brush.Color := $00d9c9c9; { 0 b g r }
      end;
      Pen.Color := clRed;
    end;

    Rectangle((Sender as TPaintBox).ClientRect);

    s := IntToStr((Sender as TPaintBox).Tag + 1);
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
  BattleState.StartRects[Index].PaintBox := TPaintBox.Create(MapPanel);
  BattleState.StartRects[Index].PaintBox.Enabled := False;
  BattleState.StartRects[Index].PaintBox.Tag := Index;
  BattleState.StartRects[Index].PaintBox.OnPaint := StartRectPaintBoxPaint;
  BattleState.StartRects[Index].PaintBox.Left := Rect.Left;
  BattleState.StartRects[Index].PaintBox.Top := Rect.Top;
  BattleState.StartRects[Index].PaintBox.Width := Rect.Right - Rect.Left;
  BattleState.StartRects[Index].PaintBox.Height := Rect.Bottom - Rect.Top;
  BattleState.StartRects[Index].PaintBox.Parent := MapPanel;

  RearrangeStartRects;
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

procedure TBattleForm.ChangeStartRect(Index: Integer; Rect: TRect);
begin
  LimitRect(Rect, MapImage.ClientRect);
  BattleState.StartRects[Index].Rect := Rect;

  NormalizeRect(Rect);

  try
    BattleState.StartRects[Index].PaintBox.Left := Rect.Left;
    BattleState.StartRects[Index].PaintBox.Top := Rect.Top;
    BattleState.StartRects[Index].PaintBox.Width := Rect.Right - Rect.Left;
    BattleState.StartRects[Index].PaintBox.Height := Rect.Bottom - Rect.Top;
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
      MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(Number) + ' ' + IntToStr(Rect.Left) + ' ' + IntToStr(Rect.Top) + ' ' + IntToStr(Rect.Right) + ' ' + IntToStr(Rect.Bottom) + ' ');
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
  if BattleState.Status = Hosting then
  begin
    DisconnectButton.OnClick(nil);
  end
  else if BattleState.Status = Joined then
  begin
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

  if BattleState.Status = Joined then
  begin
    MainForm.TryToSendCommand('LEAVEBATTLE');
    ResetBattleScreen;
  end
  else if BattleState.Status = Hosting then
  begin
    MainForm.TryToSendCommand('LEAVEBATTLE');
    ResetBattleScreen;
  end;
end;

procedure TBattleForm.MetalTrackerMouseUpAfterChange(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/StartMetal='+IntToStr(MetalTracker.Value));
end;

procedure TBattleForm.EnergyTrackerMouseUpAfterChange(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/StartEnergy='+IntToStr(EnergyTracker.Value));
end;

procedure TBattleForm.UnitsTrackerMouseUpAfterChange(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  if UnitsTracker.Value < 10 then UnitsTracker.Value := 10;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/MaxUnits='+IntToStr(UnitsTracker.Value));
end;

procedure TBattleForm.StartPosRadioGroupClick(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/StartPosType='+IntToStr(StartPosRadioGroup.ItemIndex));
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
      Status.AmIInGame := False;
      MainForm.TryToSendCommand('MYSTATUS', '0'); // let's tell the server we returned from the game

      CloseHandle(BattleState.Process.proc_info.hProcess);
      UploadReplay;
    end
  else
  begin
    AddTextToChat('Back from the game', Colors.Info, 1);
    Status.AmIInGame := False;
    MainForm.TryToSendCommand('MYSTATUS', '0'); // let's tell the server we returned from the game

    TerminateProcess(BattleState.Process.proc_info.hProcess, 0);
    CloseHandle(BattleState.Process.proc_info.hProcess);
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
  teamCount : array[0..15] of integer;
  LadderUpThread : TUploadLadderDataThread;
begin
  if (not Preferences.UploadReplay and ((BattleState.LadderIndex = -1) or (BattleState.Status = Joined))) or (BattleState.Battle.BattleType=1) then begin
    if (BattleState.LadderIndex > -1) and (BattleState.Battle.BattleType=0) and (Status.Me.GetMode <> 0) then begin
      UploadReplayForm.UploadedReplayId := '';
      ProgressBarForm.TakeAction := 2;
      ProgressBarForm.ShowModal;
    end;
    Exit;
  end;
  {Replay upload disabled while the Replay site is down
  
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

  ReplaysForm.ReadScriptFromDemo(FileName,s);
  su := UpperCase(s);

  UploadReplayForm.FileName := FileName;

  i := Pos('MAPNAME=', su);
  i := i + 8;
  j := PosEx(';', su, i);
  if (i<>0) and (j<>0) then UploadReplayForm.MapName := Copy(s, i, j-i-4)
  else Exit; // corrupt script file

  i := Pos('GAMETYPE=', su);
  i := i + 9;
  j := PosEx(';', su, i);
  if (i<>0) and (j<>0) then UploadReplayForm.ModName := Copy(s, i, j-i-4)
  else Exit; // corrupt script file

  for i:=0 to 15 do
    teamCount[i] := 0;

  i := Pos('AllyTeam=',s);
  while i > 0 do begin
    i := i+9;
    j := PosEx(';',s,i);
    Inc(teamCount[StrToInt(Copy(s,i,j-i))]);
    i := PosEx('AllyTeam=',s,i);
  end;
  UploadReplayForm.NbPlayers := '';
  for i:= 0 to 15 do
    if teamCount[i] > 0 then
      if UploadReplayForm.NbPlayers = '' then
        UploadReplayForm.NbPlayers := IntToStr(teamCount[i])
      else
        UploadReplayForm.NbPlayers := UploadReplayForm.NbPlayers + 'v' + IntToStr(teamCount[i]);


  if BattleState.LadderIndex >= 0 then
    UploadReplayForm.Title := 'Ladder battle : ' + TLadder(LadderList[BattleState.LadderIndex]).Name;
  }
  UploadReplayForm.UploadedReplayId := '';
  //UploadReplayForm.ShowModal;

  if (BattleState.LadderIndex >= 0) and (Status.Me.GetMode <> 0) then begin
    ProgressBarForm.Close;
    ProgressBarForm.TakeAction := 2;
    ProgressBarForm.ShowModal;
  end;

  //MessageDlg(FileName,mtInformation,[mbOk],0);

end;


constructor TUploadLadderDataThread.Create(Suspended: Boolean);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);      
   OnTerminate := OnTerminateProcedure;
end;

procedure TUploadLadderDataThread.Execute;
begin
  UploadData;
end;

procedure TUploadLadderDataThread.OnTerminateProcedure(Sender: TObject);
begin
  PostMessage(ProgressBarForm.Handle, WM_CLOSE, 0, 0); // close form
end;

procedure TUploadLadderDataThread.UploadData;
var
  ResponseStream: TMemoryStream;
  ResponseStr : string;
  MultiPartFormDataStream: TMsMultiPartFormDataStream;
  ResponseStrList : TStrings;
begin
  with UploadReplayForm do begin
  MultiPartFormDataStream := TMsMultiPartFormDataStream.Create;
  ResponseStream := TMemoryStream.Create;
  ResponseStrList := TStringList.Create;
  try
    IdHTTP1.Request.ContentType := MultiPartFormDataStream.RequestContentType;
    MultiPartFormDataStream.AddFormField('username', Preferences.Username);
    MultiPartFormDataStream.AddFormField('password', Preferences.LadderPassword);
    MultiPartFormDataStream.AddFormField('replay', UploadReplayForm.UploadedReplayId);
    MultiPartFormDataStream.AddFormField('submit', 'submit');

    if FileExists('infolog.txt') and FileExists('script.txt') then begin
      MultiPartFormDataStream.AddFile('infolog', ExtractFilePath(Application.ExeName) + '\infolog.txt' , 'application/octet-stream');
      MultiPartFormDataStream.AddFile('script', ExtractFilePath(Application.ExeName) + '\script.txt' , 'application/octet-stream');
    end
    else
    begin
      MessageDlgThread('Error : infolog.txt or script.txt not found !',mtError,[mbOk],0);
      MultiPartFormDataStream.Free;
      ResponseStream.Free;
      Exit;
    end;

    { You must make sure you call this method *before* sending the stream }
    MultiPartFormDataStream.PrepareStreamForDispatch;
    MultiPartFormDataStream.Position := 0;
    ProgressBarForm.Refresh;
    ProgressBarForm.pb.Max := MultiPartFormDataStream.Size;
    ProgressBarForm.pb.Position := 0;
    IdHTTP1.Post(LADDER_PREFIX_URL+'report.php', MultiPartFormDataStream, ResponseStream);
    ResponseStream.Seek(0,0);
    SetLength(ResponseStr, ResponseStream.Size);
    ResponseStream.ReadBuffer(Pointer(ResponseStr)^, ResponseStream.Size);
  finally
    MultiPartFormDataStream.Free;
    ResponseStream.Free;
  end;
  PostMessage(ProgressBarForm.Handle, WM_CLOSE, 0, 0); // close form
  Misc.ParseDelimited(ResponseStrList,ResponseStr,' ','');
  if (ResponseStrList.Count > 0) and (ResponseStrList[0] = 'notice') then begin
    ResponseStrList.Delete(0);
    MessageDlgThread(Misc.JoinStringList(ResponseStrList,' '), mtInformation,[mbOk], 0);
  end
  else
  begin
    ResponseStrList.Delete(0);
    MessageDlgThread(Misc.JoinStringList(ResponseStrList,' '), mtInformation,[mbOk], 0);
  end;
  end;
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
begin
  if Key = 13 then
  begin
    s := (Sender as TSpTBXEdit).Text;
    (Sender as TSpTBXEdit).Text := '';
    if s = '' then Exit;

    History.Add(s);
    HistoryIndex := History.Count;

    if (s[1] = '/') or (s[1] = '.') then
    begin
      MainForm.ProcessCommand(Copy(s, 2, Length(s)-1), True);
      Exit;
    end;

    if IsBattleActive then
      MainForm.TryToSendCommand('SAYBATTLE', s);
  end
  else if Key = VK_UP then
  begin
    if History.Count = 0 then Exit;
    HistoryIndex := Max(0, HistoryIndex - 1);
    (Sender as TSpTBXEdit).Text := History[HistoryIndex];
    (Sender as TSpTBXEdit).SelStart := Length((Sender as TSpTBXEdit).Text);
    Key := 0;
  end
  else if Key = VK_DOWN then
  begin
    if History.Count = 0 then Exit;
    HistoryIndex := Min(History.Count-1, HistoryIndex + 1);
    (Sender as TSpTBXEdit).Text := History[HistoryIndex];
    (Sender as TSpTBXEdit).SelStart := Length((Sender as TSpTBXEdit).Text);
    Key := 0;
  end
  else if Key = VK_ESCAPE then
  begin
    (Sender as TSpTBXEdit).Text := '';
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

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/GameMode='+IntToStr(GameEndRadioGroup.ItemIndex));
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

procedure TBattleForm.TeamColorSpeedButtonClick(Sender: TObject);
var
  ColorIndex: Integer;
begin
  ColorIndex := ChooseColorDialog(Sender as TControl, MyTeamColorIndex);
  if ColorIndex = -1 then Exit;

  ChangeTeamColor(ColorIndex, True);
end;

procedure TBattleForm.AddUnitsSpeedButtonClick(Sender: TObject);
var
  i: Integer;
  node: PVirtualNode;
  s: string;
begin
  if DisableUnitsForm.ShowModal <> mrOK then Exit;
  DisabledUnitsListBox.Clear;

  i := 0;
  node := DisableUnitsForm.VDTUnits.GetFirst;
  while node <> nil do
  begin
    if (node.CheckState = csCheckedNormal) or (node.CheckState = csCheckedPressed) then
      DisabledUnitsListBox.Items.Add(UnitList[i]);

    node := node.NextSibling;
    Inc(i);
  end;

  // for the sake of simplicity we send the entire list each time it is changed
  // (we could also generate diff list and update it with ENABLEUNITS/DISABLEUNITS commands)
  DisabledUnitsTab.Caption := 'Disabled Units ('+IntToStr(DisabledUnitsListBox.Items.Count)+')';
  MainForm.TryToSendCommand('ENABLEALLUNITS');
  if DisabledUnitsListBox.Items.Count > 0 then
  begin
    s := '';
    for i := 0 to DisabledUnitsListBox.Items.Count-1 do
      s := s + ' ' + DisabledUnitsListBox.Items[i];
    Delete(s, 1, 1); // remove first space character
    MainForm.TryToSendCommand('DISABLEUNITS', s);
    DisabledUnitsTab.Caption := 'Disabled Units ('+IntToStr(DisabledUnitsListBox.Items.Count)+')';
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
    AddBotForm.BotTeamButton.Caption := IntToStr(team+1);
    AddBotForm.BotAllyButton.Caption := IntToStr(ally+1);
    AddBotForm.ChangeTeamColor(color);
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

procedure TBattleForm.ChatRichEditURLClick(Sender: TObject;
  const URL: String);
begin
  Misc.OpenURLInDefaultBrowser(URL);
end;

procedure TBattleForm.LimitDGunCheckBoxClick(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/LimitDGun='+IntToStr(BoolToInt(LimitDGunCheckBox.Checked)));
end;

procedure TBattleForm.DiminishingMMsCheckBoxClick(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/DiminishingMMs='+IntToStr(BoolToInt(DiminishingMMsCheckBox.Checked)));
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
  InputEdit.SetFocus;
end;

procedure TBattleForm.GhostedBuildingsCheckBoxClick(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/GhostedBuildings='+IntToStr(BoolToInt(GhostedBuildingsCheckBox.Checked)));
end;

procedure TBattleForm.SetDefaultButtonClick(Sender: TObject);
begin
  if MessageDlg('Do you wish to save current battle settings as default?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  PreferencesForm.SaveDefaultBattlePreferencesToRegistry;
end;

procedure TBattleForm.LoadDefaultButtonClick(Sender: TObject);
begin
  if BattleState.Battle.BattleType = 1 then Exit; // not allowed to change settings while hosting a replay

  {-->} AllowBattleDetailsUpdate := False;
  PreferencesForm.LoadDefaultBattlePreferencesFromRegistry;
  {-->} AllowBattleDetailsUpdate := True;
  if BattleState.Status = Hosting then
    SendBattleDetailsToServer;
end;

procedure TBattleForm.TBXTeamColorSetGetColorInfo(Sender: TTBXCustomColorSet;
  Col, Row: Integer; var Color: TColor; var Name: String);
begin
  Color := TeamColors[Col + Row * Sender.ColCount];
  Name := 'Color ' + IntToStr(Col + Row * Sender.ColCount);
end;

procedure TBattleForm.TBXColorPalette1CellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
begin
  // we keep selection information in Tag property:
  Sender.Tag := ACol + ARow * (Sender as TTBXColorPalette).ColorSet.ColCount;
end;

{ returns -1 if user cancels the dialog, otherwise returns color index.
  Specify DefaultColorIndex to indicate which color is "default",
  that is currently selected color in choose color dialog (use -1 if you don't
  want any color to be selected). "UnderControl" is the control under which the
  choose color dialog should be displayed. }
function TBattleForm.ChooseColorDialog(UnderControl: TControl; DefaultColorIndex: Integer): Integer;
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
end;

{ returns -1 if user cancels the dialog, otherwise returns cell index
  (if user chooses 1, the returned index is 0!).
  Specify DefaultIndex to indicate which cell is "default",
  that is currently selected cell in "choose number dialog" (use -1 if you don't
  want any cell to be selected) - again, 0 means first cell is selected, that is
  cell with number 1 on it. "UnderControl" is the control under which the
  dialog should be displayed. }
function TBattleForm.ChooseNumberDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;
var
  p: TPoint;
  Item: TTBCustomItem;
begin
  if DefaultIndex = -1 then
    TBXToolPalette1.SelectedCell := Point(-1, -1)
  else
    TBXToolPalette1.SelectedCell := Point(DefaultIndex mod TBXToolPalette1.ColCount, DefaultIndex div TBXToolPalette1.ColCount);

  p := UnderControl.ClientToScreen(Point(0, UnderControl.Height));
  Item := ChooseNumberPopupMenu.PopupEx(p.X, p.Y, nil, False);

  if Item = nil then
  begin
    Result := -1;
    Exit;
  end;

  if Item.ClassType <> TTBXToolPalette then
  begin
    Result := -1;
    Exit;
  end;

  Result := Item.Tag;
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

procedure TBattleForm.TBXToolPalette1CellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
begin
  // we keep selection information in Tag property:
  Sender.Tag := ACol + ARow * (Sender as TTBXToolPalette).ColCount;
end;

procedure TBattleForm.MyTeamNoButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ChooseNumberDialog(Sender as TControl, StrToInt(MyTeamNoButton.Caption)-1);
  if Index = -1 then Exit;

  if StrToInt(MyTeamNoButton.Caption)-1 = Index then Exit; // no change
  MyTeamNoButton.Caption := IntToStr(Index+1);

  // update info:
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

procedure TBattleForm.MyAllyNoButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ChooseNumberDialog(Sender as TControl, StrToInt(MyAllyNoButton.Caption)-1);
  if Index = -1 then Exit;

  if StrToInt(MyAllyNoButton.Caption)-1 = Index then Exit; // no change
  MyAllyNoButton.Caption := IntToStr(Index+1);

  // update info:
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

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
    0:
      if AnsiCompareText(Client1.Name,Client2.Name) = 0  then
        Result := 0
      else if AnsiCompareText(Client1.Name,Client2.Name) < 0 then
        Result := -1
      else
        Result := 1;
    1:
      if Client2.GetMode = 0 then
        Result := -1
      else if Client1.GetMode = 0 then
        Result := 1
      else if Client1.GetTeamNo = Client2.GetTeamNo then
        Result := 0
      else if Client1.GetTeamNo < Client2.GetTeamNo then
        Result := -1
      else
        Result := 1;
    2:
      if Client2.GetMode = 0 then
        Result := -1
      else if Client1.GetMode = 0 then
        Result := 1
      else if Client1.GetAllyNo = Client2.GetAllyNo then
        Result := 0
      else if Client1.GetAllyNo < Client2.GetAllyNo then
        Result := -1
      else
        Result := 1;
    3:
      if Client2.GetMode = 0 then
        Result := -1
      else if Client1.GetMode = 0 then
        Result := 1
      else if Client1.GetReadyStatus = Client2.GetReadyStatus then
        Result := 0
      else if Client1.GetReadyStatus then
        Result := 1
      else
        Result := -1;
    4:
      if Client1.GetSync = Client2.GetSync then
        Result := 0
      else if Client1.GetSync < Client2.GetSync then
        Result := -1
      else
        Result := 1;
    5:
      if Client1.CPU = Client2.CPU then
        Result := 0
      else if Client1.CPU < Client2.CPU then
        Result := -1
      else
        Result := 1;
    6:
      if Client2.GetMode = 0 then
        Result := -1
      else if Client1.GetMode = 0 then
        Result := 1
      else if Client1.GetHandicap = Client2.GetHandicap then
        Result := 0
      else if Client1.GetHandicap < Client2.GetHandicap then
        Result := -1
      else
        Result := 1;
    7:
      if Client1.CurrentLadderRank = Client2.CurrentLadderRank then
        Result := 0
      else if Client1.CurrentLadderRank < Client2.CurrentLadderRank then
        Result := -1
      else
        Result := 1;
    8:
      if Client1.CurrentLadderRating = Client2.CurrentLadderRating then
        Result := 0
      else if Client1.CurrentLadderRating < Client2.CurrentLadderRating then
        Result := -1
      else
        Result := 1;
    9:
      if BattleState.Battle.Clients.IndexOf(Client1) = BattleState.Battle.Clients.IndexOf(Client2)  then
        Result := 0
      else if BattleState.Battle.Clients.IndexOf(Client1) < BattleState.Battle.Clients.IndexOf(Client2) then
        Result := -1
      else
        Result := 1;
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
    1:
      if Bot1.GetTeamNo = Bot2.GetTeamNo then
        Result := 0
      else if Bot1.GetTeamNo < Bot2.GetTeamNo then
        Result := -1
      else
        Result := 1;
    2:
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
  realindex := BattleReplayInfo.OriginalClients.IndexOf(SortedOriginalList[index - SortedClientList.Count - SortedBotList.Count]);
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
  group : Integer;
  FlagBitmap: TBitmap;
  i: integer;
begin
  Index := PaintInfo.Node.Index;

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

  if (WhatToDraw = NormalClient) or (WhatToDraw = NormalBot) then
  begin
    // this ensures the correct highlite color is used (if item is not selected, otherwise VDT will paint it correctly anyway):
    if PaintInfo.Node <> VDTBattleClients.FocusedNode then
    begin
      PaintInfo.Canvas.Brush.Color := VDTBattleClients.Color;
      PaintInfo.Canvas.FillRect(PaintInfo.CellRect);
    end
    else ; // VDT will paint it correctly, no need for us to overwrite it  
  end
  else
  begin
    PaintInfo.Canvas.Brush.Color := $00ffdddd; { 0 b g r }
    PaintInfo.Canvas.FillRect(PaintInfo.CellRect);
  end;


  // do the actual drawing:

  with Sender as TVirtualDrawTree, PaintInfo do
  begin

    R := ContentRect;
    InflateRect(R, -TextMargin, 0);
    Dec(R.Right);
    Dec(R.Bottom);

    PaintInfo.Canvas.Font := BattleClientsListFont;

    // set correct font color:
    case WhatToDraw of
      NormalClient:
      begin
        Canvas.Font.Color := clWindowText;
        if (Node = FocusedNode) and Focused then
          Canvas.Font.Color := clHighlightText; // $00FFDDDD;  // (0, B, G, R)
      end;
      NormalBot:
      begin
        Canvas.Font.Color := MainUnit.Colors.BotText;
        if (Node = FocusedNode) and Focused then
          Canvas.Font.Color := clHighlightText;
      end;
      OriginalClient:
      begin
        Canvas.Font.Color := clWindowText;
        if (Node = FocusedNode) and Focused then
          Canvas.Font.Color := clHighlightText; // $00CC6666;  // (0, B, G, R)
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

           // override font color if client is away or ingame:
          if TClient(BattleState.Battle.Clients[RealIndex]).GetAwayStatus and not TClient(BattleState.Battle.Clients[RealIndex]).GetInGameStatus then
            Canvas.Font.Color := $009F9F9F
          else if TClient(BattleState.Battle.Clients[RealIndex]).GetInGameStatus then
            Canvas.Font.Color := $009F1111;

          // bot mode icon:
          if TClient(BattleState.Battle.Clients[RealIndex]).GetBotMode then
          begin
            Canvas.Draw(R.Left + Pos, R.Top, MainForm.BotImage.Picture.Bitmap);
            Inc(Pos, MainForm.BotImage.Picture.Bitmap.Width + 4{leave some space between username and the icon});
          end;

          // group highlight
          group := TClient(BattleState.Battle.Clients[RealIndex]).GetGroup;
          if (group > -1) and (PaintInfo.Node <> VDTBattleClients.FocusedNode) then begin
            Canvas.Brush.Color := TClientGroup(ClientGroups[group]).Color;
            Canvas.FillRect(Rect(R.Left+Pos,R.Top,R.Right,R.Bottom));
          end;

          // username:
          s := TClient(BattleState.Battle.Clients[RealIndex]).Name;
          Canvas.TextOut(R.Left + Pos, R.Top, s);

          Inc(Pos,Canvas.TextWidth(s)+5);

          // cups
          with TClient(BattleState.Battle.Clients[RealIndex]) do
          begin
            for i:=0 to CupList.Count-1 do
            begin
              MainForm.LadderCups.Draw(Canvas, R.Left + Pos, R.Top, Integer(CupList[i]^));
              Inc(Pos, MainForm.LadderCups.Width + 1);
            end;
          end;

          // hoster icon
          if RealIndex = 0 then
            MainForm.PlayerStateImageList.Draw(Canvas, R.Left + Pos, R.Top, 4);
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
            FlagBitmap := MainForm.GetFlagBitmap(TClient(BattleReplayInfo.OriginalClients[RealIndex]).Country);
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

      1: // team
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
                FillRect(R);
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
            end;
            // team no.:
            Canvas.TextOut(R.Left + Pos + MainForm.ColorImageList.Width, R.Top, s);
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
              FillRect(R);
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
            end;
            // team no.:
            Canvas.TextOut(R.Left + Pos + MainForm.ColorImageList.Width, R.Top, s);
          end;
        end
      end; // case WhatToDraw

      2: // ally
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

      3: // ready
      case WhatToDraw of
        NormalClient:
        begin
          if (TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1) or (BattleState.Battle.BattleType = 1) then
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

      4: // sync / bot owner
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

      5: // cpu / ai dll
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
          s := TBot(BattleState.Battle.Bots[RealIndex]).AIDll;
          Canvas.TextOut(R.Left + Pos, R.Top, s);
        end;
        OriginalClient:
        begin
          // cpu:
//        we don't need to draw this
        end;
      end; // case WhatToDraw

      6: // handicap
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

      7: // ladder rank
      case WhatToDraw of
        NormalClient:
        begin
          if TClient(BattleState.Battle.Clients[RealIndex]).CurrentLadderRank = 0 then
            Canvas.TextOut(R.Left + Pos, R.Top,'n/a')
          else if TClient(BattleState.Battle.Clients[RealIndex]).CurrentLadderRank = -2 then
            Canvas.TextOut(R.Left + Pos, R.Top,'n/a')
          else if TClient(BattleState.Battle.Clients[RealIndex]).CurrentLadderRank = -1 then
            Canvas.TextOut(R.Left + Pos, R.Top,'...')
          else
            Canvas.TextOut(R.Left + Pos, R.Top, IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).CurrentLadderRank));
        end;
        NormalBot:
        begin
          Canvas.TextOut(R.Left + Pos, R.Top, '-');
        end;
        OriginalClient:
        begin
            Canvas.TextOut(R.Left + Pos, R.Top, '-');
        end;
      end; // case WhatToDraw

      8: // ladder rating
      case WhatToDraw of
        NormalClient:
        begin
          if TClient(BattleState.Battle.Clients[RealIndex]).CurrentLadderRating = 0 then
          begin
            Canvas.Brush.Color := clRed;
            Canvas.TextOut(R.Left + Pos, R.Top,'No ladder account.');
          end
          else if TClient(BattleState.Battle.Clients[RealIndex]).CurrentLadderRating = -2 then
            Canvas.TextOut(R.Left + Pos, R.Top,'n/a')
          else if TClient(BattleState.Battle.Clients[RealIndex]).CurrentLadderRating = -1 then
            Canvas.TextOut(R.Left + Pos, R.Top,'...')
          else
            Canvas.TextOut(R.Left + Pos, R.Top, IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).CurrentLadderRating));
        end;
        NormalBot:
        begin
          Canvas.TextOut(R.Left + Pos, R.Top, '-');
        end;
        OriginalClient:
        begin
            Canvas.TextOut(R.Left + Pos, R.Top, '-');
        end;
      end; // case WhatToDraw

      9: // order
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

  p := (Sender as TControl).ClientToScreen(Point(X, Y));

  if
     // right button and a normal client or your bot
     (Button = mbRight) and (WhatToDraw <> OriginalClient) and
     ((WhatToDraw <> NormalBot) or (TBot(BattleState.Battle.Bots[RealIndex]).OwnerName = Status.Username))
     {
     // battle host may change other player's or bot's properties:
     (
     (BattleState.Status = Hosting) and (Button = mbRight) and (VDTBattleClients.FocusedNode <> nil)
     and ((WhatToDraw = NormalClient) or (WhatToDraw = NormalBot))
     )
     or
     // allow bot's owner to change his bot's properties:
     (
     (Button = mbRight) and (VDTBattleClients.FocusedNode <> nil)
     and (WhatToDraw = NormalBot)
     and (TBot(BattleState.Battle.Bots[RealIndex]).OwnerName = Status.Username)
     )}
  then
  begin
    SetBotSideSubitem.Enabled := WhatToDraw = NormalBot;
    ForceSpectatorModeItem.Enabled := (WhatToDraw = NormalClient) and (TClient(BattleState.Battle.Clients[RealIndex]).GetMode <> 0);
    if WhatToDraw = NormalClient then
    begin
      HandicapSpinEditItem.Value := TClient(BattleState.Battle.Clients[RealIndex]).GetHandicap;
    end
    else if WhatToDraw = NormalBot then
    begin
      HandicapSpinEditItem.Value := TBot(BattleState.Battle.Bots[RealIndex]).GetHandicap;
    end;

    BanPlayerItem.Enabled := WhatToDraw = NormalClient;
    RingItem.Enabled := WhatToDraw = NormalClient;
    PlayerControlPopupMenuInitPopup(nil,nil);
    PlayerControlPopupMenu.Popup(p.X, p.Y);

    if VDTBattleClients.FocusedNode <> nil then
    begin
      if (WhatToDraw = NormalClient)
      and (HandicapSpinEditItem.Value <> TClient(BattleState.Battle.Clients[RealIndex]).GetHandicap) then
        MainForm.TryToSendCommand('HANDICAP', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(Round(HandicapSpinEditItem.Value)))
      else if (WhatToDraw = NormalBot)
      and (HandicapSpinEditItem.Value <> TBot(BattleState.Battle.Bots[RealIndex]).GetHandicap) then
      begin
        TBot(BattleState.Battle.Bots[RealIndex]).SetHandicap(Round(HandicapSpinEditItem.Value));
        MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
      end;
    end;
  end
  else if Button = mbLeft then ;
end;

procedure TBattleForm.ForceTeamToolPaletteCellClick(
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
      AddTextToChat('Forcing ' + TClient(BattleState.Battle.Clients[RealIndex]).Name + '''s team number ...', Colors.Info, 1);
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

procedure TBattleForm.SetTeamItemClick(Sender: TObject);
var
  team: Integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      team := TClient(BattleState.Battle.Clients[RealIndex]).GetTeamNo;
      ForceTeamToolPalette.SelectedCell := Point(team mod ForceTeamToolPalette.ColCount, team div ForceTeamToolPalette.ColCount);
    end
    else if WhatToDraw = NormalBot then
    begin
      team := TBot(BattleState.Battle.Bots[RealIndex]).GetTeamNo;
      ForceTeamToolPalette.SelectedCell := Point(team mod ForceTeamToolPalette.ColCount, team div ForceTeamToolPalette.ColCount);
    end;
  end
  else
    ForceTeamToolPalette.SelectedCell := Point(-1, -1);
end;

procedure TBattleForm.SetAllyItemClick(Sender: TObject);
var
  ally: Integer;
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
begin
  if (VDTBattleClients.FocusedNode <> nil) then
  begin
    GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      ally := TClient(BattleState.Battle.Clients[RealIndex]).GetAllyNo;
      ForceAllyToolPalette.SelectedCell := Point(ally mod ForceAllyToolPalette.ColCount, ally div ForceAllyToolPalette.ColCount);
    end
    else if WhatToDraw = NormalBot then
    begin
      ally := TBot(BattleState.Battle.Bots[RealIndex]).GetAllyNo;
      ForceAllyToolPalette.SelectedCell := Point(ally mod ForceAllyToolPalette.ColCount, ally div ForceAllyToolPalette.ColCount);
    end;
  end
  else
    ForceAllyToolPalette.SelectedCell := Point(-1, -1);
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
      AddTextToChat('Forcing ' + TClient(BattleState.Battle.Clients[RealIndex]).Name + '''s ally number ...', Colors.Info, 1);
    end
    else if WhatToDraw = NormalBot then
    begin
      TBot(BattleState.Battle.Bots[RealIndex]).SetAllyNo(Round(ally));
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;

  end;
end;

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

procedure TBattleForm.ForceTeamColorPaletteCellClick(
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
end;

procedure TBattleForm.HandicapSpinEditItemChange(Sender: TObject;
  const Text: String);
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
  HandicapSpinEditItem.Value := Value;
end;

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

procedure TBattleForm.UnbanItemClick(Sender: TObject);
begin
    MainForm.TryToSendCommand('SAYBATTLEEX', 'removed '+(Sender as TSpTBXItem).Caption+' from ban list');
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
  if (BattleState.LadderIndex > -1) and (Preferences.LadderPassword = '') and not SpectateCheckBox.Checked then begin
    MessageDlg('You must enter your ladder password in the Options/Account first !',mtWarning,[mbOk],0);
    Exit;
  end;

  // check if user has the correct map before readying up:
  if (not BattleForm.AmIReady) and (Utility.MapList.IndexOf(BattleState.Battle.Map) = -1) then
  begin
    MessageDlg('Please download the map before readying up. You can do this by clicking on the minimap area or the "more maps" label, which will open integrated map downloader', mtWarning, [mbOK], 0);
    Exit;
  end;

  BattleForm.AmIReady := not BattleForm.AmIReady;
end;

procedure TBattleForm.SpTBXItem4Click(Sender: TObject);
begin
  if AddBotForm.Visible then
    Misc.InputColor('Color Picker',clBlack)
  else
  begin
    Misc.InputColor('Color Picker',Status.Me.TeamColor);
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
    color := Misc.InputColor('Color Picker',TClient(BattleState.Battle.Clients[RealIndex]).TeamColor);

    if WhatToDraw = NormalClient then
    begin
      MainForm.TryToSendCommand('FORCETEAMCOLOR', TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ' + IntToStr(color));
    end
    else if WhatToDraw = NormalBot then
    begin
      TBot(BattleState.Battle.Bots[RealIndex]).TeamColor := color;
      MainForm.TryToSendCommand('UPDATEBOT', TBot(BattleState.Battle.Bots[RealIndex]).Name + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).BattleStatus) + ' ' + IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).TeamColor));
    end;
  end;
end;

procedure TBattleForm.MapsButtonClick(Sender: TObject);
begin
  MapListForm.ShowModal;
end;

procedure TBattleForm.TBXButton1Click(Sender: TObject);
begin
  if MAP_DOWNLOADER_ENABLED then
    OnlineMapsForm.Show
  else
    Misc.OpenURLInDefaultBrowser(MAPS_PAGE_LINK);
end;

procedure TBattleForm.TBXButton2Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(MODS_PAGE_LINK);
end;

procedure TBattleForm.ReloadMapListButtonClick(Sender: TObject);
var
  i:integer;
begin
  if (BattleState.Status = Hosting) and (BattleState.Battle.BattleType = 1) then
  begin
    // this should not happen though since we don't allow player to host a replay if he doesn't have the correct map!
    MessageDlg('Cannot reload map list while hosting online replay!', mtWarning, [mbOK], 0);
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
    else ChangeMap(Utility.MapList.IndexOf(BattleState.Battle.Map));

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
    else ChangeMap(Utility.MapList.IndexOf(BattleState.Battle.Map));
  end
  else
  begin // just reinit and reload
    Utility.ReInitLibWithDialog;

    // reload map list:
    InitWaitForm.ChangeCaption(MSG_RELOADMAPLIST);
    InitWaitForm.TakeAction := 5;
    InitWaitForm.ShowModal;

    if Utility.MapList.IndexOf(Preferences.LastOpenMap) = -1 then
      BattleForm.ChangeMap(0) // load first map in the list
    else BattleForm.ChangeMap(Utility.MapList.IndexOf(Preferences.LastOpenMap)); // restore last open map
  end;

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
      MainForm.OpenPrivateChat(TClient(BattleState.Battle.Clients[RealIndex]).Name);
      MainForm.Show; // switch focus to chat window
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
      AddTextToChat('Forcing spectator mode on ' + TClient(BattleState.Battle.Clients[RealIndex]).Name + ' ...', Colors.Info, 1);
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

procedure TBattleForm.BalanceTeamsButtonClick(Sender: TObject);
var
  p: TPoint;
begin
  if AutoTeamsForm.AutoApplyCheckBox.Checked then
  begin
    AutoTeamsForm.CreatePreview;
    AutoTeamsForm.ApplyCurrentConfiguration;
  end
  else
    AutoTeamsForm.ShowModal;
end;

procedure TBattleForm.AutoStartRectsOptionsItemClick(Sender: TObject);
begin
  AutoStartRectsForm.ShowModal;
end;

procedure TBattleForm.AutoStartRectsApplyItemClick(Sender: TObject);
begin
  AutoStartRectsForm.RecreatePreview;
  AutoStartRectsForm.ApplyCurrentConfiguration;
end;
procedure TBattleForm.RefreshTeamNbr;
var
  i : integer;
  nb : array [1..16] of Integer;
  msg : string;
begin
  if BattleState.Status <> None then begin
    for i:= 1 to 16 do begin
      nb[i] := 0;
    end;
    for i:=0 to BattleState.Battle.Clients.Count-1 do begin
      if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then begin
        nb[TClient(BattleState.Battle.Clients[i]).GetAllyNo+1] := nb[TClient(BattleState.Battle.Clients[i]).GetAllyNo+1] + 1;
      end;
    end;
    msg := '';
    for i:=1 to 16 do begin
      if nb[i] > 0 then begin
        if msg <> '' then begin
          msg := msg + #13#10;
        end;
        msg := msg + '| '+IntToStr(i)+' | = ' + IntToStr(nb[i]);
      end;
    end;
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
  ColorList : TList;
  i,j,k : integer;
  bestCol,bestVal : integer;
  r,g,b : integer;
  temp:integer;
  minDist : integer;
  cDistance:integer;
  PColor : ^integer;
begin
  ColorList := TList.create;
  for i:=0 to BattleState.Battle.Clients.count-1 do
    if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then begin
      New(PColor);
      PColor^:=TClient(BattleState.Battle.Clients[i]).TeamColor;
      ColorList.Add(PColor);
    end;

  for i:=0 to ColorList.Count -2 do
    for j:=i+1 to ColorList.Count -1 do
      if Misc.ColorDistance(PInteger(ColorList[i])^,PInteger(ColorList[j])^) < 80 then begin
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
                  cDistance := Misc.ColorDistance2(temp,PInteger(ColorList[k])^);
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
        PColor := ColorList[i];
        PColor^ := bestCol;
      end;

  MainForm.TryToSendCommand('SAYBATTLEEX', 'is fixing colors ...');
  j:=0;
  for i:=0 to BattleState.Battle.Clients.count-1 do
    if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then begin
      if TClient(BattleState.Battle.Clients[i]).TeamColor <> PInteger(ColorList[j])^ then
        MainForm.TryToSendCommand('FORCETEAMCOLOR', TClient(BattleState.Battle.Clients[i]).Name + ' ' + IntToStr(PInteger(ColorList[j])^));
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
  Filename := MAPS_CACHE_FOLDER + '\' + IntToHex(BattleState.Battle.MapHash,8) + '.boxes';
  Ini := TIniFile.Create(Filename);
  if Ini.SectionExists('Box0') then begin
    mnuClearBoxesClick(Sender);
    for i:=0 to High(BattleState.StartRects) do begin
      left := StrToInt(Ini.ReadString('Box'+IntToStr(i), 'Left', '0'));
      top := StrToInt(Ini.ReadString('Box'+IntToStr(i), 'Top', '0'));
      right := StrToInt(Ini.ReadString('Box'+IntToStr(i), 'Right', '0'));
      bottom := StrToInt(Ini.ReadString('Box'+IntToStr(i), 'Bottom', '0'));
      if right > 0 then begin
        AddStartRect(i,Rect(left,top,right,bottom));
        MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(i) + ' ' + IntToStr(left) + ' ' + IntToStr(top) + ' ' + IntToStr(right) + ' ' + IntToStr(bottom) + ' ');
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
  Filename := MAPS_CACHE_FOLDER + '\' + IntToHex(BattleState.Battle.MapHash,8) + '.boxes';
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
        AutoTeamsForm.NumOfAlliesButton.Caption := IntToStr(nb);
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
        AutoTeamsForm.NumOfAlliesButton.Caption := IntToStr(nb);
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
      if not Misc.Contains(TClient(BattleState.Battle.Clients[RealIndex]).Name,BattleState.BanList) then begin
        MainForm.TryToSendCommand('SAYBATTLEEX', 'added '+TClient(BattleState.Battle.Clients[RealIndex]).Name+' to ban list');
        MainForm.TryToSendCommand('KICKFROMBATTLE', TClient(BattleState.Battle.Clients[RealIndex]).Name);
        BattleState.BanList.add(TClient(BattleState.Battle.Clients[RealIndex]).Name);
      end;
    end;
  end;
end;

procedure TBattleForm.PlayerControlPopupMenuInitPopup(Sender: TObject;
  PopupView: TTBView);
var
  i:integer;
  ClientGroup: integer;
  RealIndex: integer;
  WhatToDraw: TClientNodeType;
  Client: TClient;
begin
  GetNodeClient(VDTBattleClients.FocusedNode.Index,RealIndex,WhatToDraw);

  SetTeamItem.Visible := (WhatToDraw <> OriginalClient) and ((BattleState.Status = Hosting) or ((WhatToDraw = NormalBot) and (TBot(BattleState.Battle.Bots[RealIndex]).OwnerName = Status.Username)));
  SetAllyItem.Visible := SetTeamItem.Visible;
  SetTeamColorItem.Visible := SetTeamItem.Visible;
  HandicapSpinEditItem.Visible := SetTeamItem.Visible;
  KickPlayerItem.Visible := SetTeamItem.Visible;
  SetBotSideSubitem.Visible := SetTeamItem.Visible;
  ForceSpectatorModeItem.Visible := SetTeamItem.Visible;
  RingItem.Visible := (WhatToDraw = NormalClient) and ((BattleState.Status = Hosting) or (RealIndex=0));
  SpTBXSeparatorItem5.Visible := RingItem.Visible;

  BanPlayerItem.Visible := BattleState.Status = Hosting;
  UnbanSubitem.Visible := BanPlayerItem.Visible;
  if UnbanSubitem.Visible then
  begin
    UnbanSubitem.Clear;
    for i:=0 to BattleState.BanList.count-1 do begin
      UnbanSubitem.Add(TSpTBXItem.Create(UnbanSubitem));
      with UnbanSubitem.Items[UnbanSubitem.Count-1] as TSpTBXItem do
      begin
        Caption := BattleState.BanList[i];
        Tag := i;
        OnClick := UnbanItemClick;
      end;
    end;
    UnbanSubitem.Enabled := UnbanSubitem.Count > 0;
  end;

  mnuAddToGroup.Visible := WhatToDraw = NormalClient;
  mnuRemoveFromGroup.Visible := mnuAddToGroup.Visible;
  if mnuAddToGroup.Visible then
  begin
    Client := TClient(BattleState.Battle.Clients[RealIndex]);
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

    for i:= mnuAddToGroup.Count-1 downto 2 do
      mnuAddToGroup.Remove(mnuAddToGroup.Items[i]);

    for i:=0 to ClientGroups.Count-1 do
    begin
      mnuAddToGroup.Add(TSpTBXItem.Create(mnuAddToGroup));
      with mnuAddToGroup.Items[mnuAddToGroup.Count-1] as TSpTBXItem do
      begin
        Caption := TClientGroup(ClientGroups[i]).Name;
        Tag := i;
        OnClick := MainForm.AddToGroupItemClick;
      end;
    end;

    MainUnit.SelectedUserName := Client.Name;
  end;

  ChatRichEdit.Refresh;
  VDTBattleClients.Refresh;
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
end;

procedure TBattleForm.SpTBXItem8Click(Sender: TObject);
begin
  AutoTeamsForm.ShowModal;
end;


procedure TBattleForm.RefreshLadderRanks;
var
  ThreadLR : TLadderRanksThread;
  i : integer;
begin
  for i:=0 to BattleState.Battle.Clients.Count -1 do
    if TClient(BattleState.Battle.Clients[i]).CurrentLadderId <> BattleState.Battle.GetLadderId then begin
      TClient(BattleState.Battle.Clients[i]).CurrentLadderRank := -1;
      TClient(BattleState.Battle.Clients[i]).CurrentLadderRating := -1;
    end;

  if BattleState.Battle.IsLadderBattle or (BattleState.LadderIndex > -1) then begin
    ThreadLR := TLadderRanksThread.Create(False);
  end;
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
end;

procedure TBattleForm.mnuRankLimitDisabledClick(Sender: TObject);
begin
  mnuRankLimitDisabled.Checked := True;
  mnuLimitRankAutoKick.Checked := False;
  mnuLimitRankAutoSpec.Checked := False;

  BattleState.AutoSpecRankLimit := False;
  BattleState.AutoKickRankLimit := False;
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
  GetNodeClient(Node.Index,RealIndex,WhatToDraw);
  if (WhatToDraw <> NormalClient) then
    Exit;
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
      h := h + ' ' + MainForm.GetCountryName(TClient(BattleState.Battle.Clients[RealIndex]).Country);
      if (TClient(BattleState.Battle.Clients[RealIndex]).GetGroup > -1) then
        h := h + ', '+ TClientGroup(ClientGroups[TClient(BattleState.Battle.Clients[RealIndex]).GetGroup]).Name;
      TextOut(5, 2, h);
    except
      Exit;
    end;
  end;
end;

procedure TBattleForm.VDTBattleClientsGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
var
  RealIndex: Integer;
  WhatToDraw: TClientNodeType;
  h: String;
begin
  if (Node = nil) then
    Exit;
  GetNodeClient(Node.Index,RealIndex,WhatToDraw);
  if (WhatToDraw <> NormalClient) then
    Exit;
  R := Rect(0, 0, 0, 0);
  h := '';
  with (Sender as TVirtualDrawTree) do
  begin
  try
    h := h + TClient(BattleState.Battle.Clients[RealIndex]).Name;
    h := h + ' '+MainForm.GetCountryName(TClient(BattleState.Battle.Clients[RealIndex]).Country);
    if TClient(BattleState.Battle.Clients[RealIndex]).GetGroup > -1 then
      h := h + ', ' + TClientGroup(ClientGroups[TClient(BattleState.Battle.Clients[RealIndex]).GetGroup]).Name;
    R := Rect(0, 0, Canvas.TextWidth(h) + 10, 18);
  except
    Exit;
  end;
  end;
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
    if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then begin
      MainForm.TryToSendCommand('FORCETEAMNO', TClient(BattleState.Battle.Clients[i]).Name + ' ' + IntToStr(j));
      j := j+1;
    end;
end;

procedure TBattleForm.mnuBlockTeamsClick(Sender: TObject);
begin
  mnuBlockTeams.Checked := not mnuBlockTeams.Checked;
end;

constructor TLadderRanksThread.Create(Suspended: Boolean);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   OnTerminate := OnTerminateProcedure;
end;

procedure TLadderRanksThread.Execute;
begin
  Refresh;
end;

procedure TLadderRanksThread.Refresh;
var
  i,j,k:integer;
  phpParams:string;
  playerList : TStrings;
  html:string;
  parse1 : TStrings;
  parse2 : TStrings;
  nick : PChar;
  forceSpecNickList: TStringList;
begin
  if BattleState.LadderIndex = -1 then
    Exit;

  forceSpecNickList := TStringList.Create;
    
  with BattleForm do begin
  playerList := TStringList.Create;
  parse1 := TStringList.Create;
  parse2 := TStringList.Create;
  if (BattleState.Status = None) then
    Exit;

  // make the list of player without ladder data (now all players are refreshed each time someone join)
  for i:=0 to BattleState.Battle.Clients.Count-1 do
    playerList.Add(TClient(BattleState.Battle.Clients[i]).Name);

  playerList.Add(TClient(Status.Me).Name);

  if playerList.Count > 0 then begin
    // make the php parameters url
    phpParams := '';
    for i:=0 to playerList.Count-1 do
      phpParams := phpParams+'&players[]='+playerList[i];

    // get the html result
    with BattleForm do begin
      if Preferences.UseProxy then
      begin
        HttpCli3.Proxy := Preferences.ProxyAddress;
        HttpCli3.ProxyPort := IntToStr(Preferences.ProxyPort);
        HttpCli3.ProxyUsername := Preferences.ProxyUsername;
        HttpCli3.ProxyPassword := Preferences.ProxyPassword
      end
      else HttpCli3.Proxy := '';
      HttpCli3.URL := LADDER_PREFIX_URL + 'ranking.php?ladder='+IntToStr(TLadder(LadderList[BattleState.LadderIndex]).id)+phpParams;
      HttpCli3.RcvdStream := TMemoryStream.Create;
      try
        HttpCli3.Get;
      except
        MainForm.AddMainLog('Error: Ladder server unavailable.', Colors.Error);
        Exit;
      end;
      HttpCli3.RcvdStream.Seek(0,0);
      SetLength(html, HttpCli3.RcvdStream.Size);
      HttpCli3.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli3.RcvdStream.Size);
    end;
    // set all players to refresh to 'no ladder record'
    for i:=0 to BattleState.Battle.Clients.Count-1 do
      if TClient(BattleState.Battle.Clients[i]).CurrentLadderRank = -1 then
      begin
        TClient(BattleState.Battle.Clients[i]).CurrentLadderRank := -2;
        TClient(BattleState.Battle.Clients[i]).CurrentLadderRating := -2;
      end;

    // parse the html result
    Misc.ParseDelimited(parse1,html,#$A,'');
    for i:= 0 to parse1.Count -1 do // for each player result
      if parse1[i] <> '' then begin
        Misc.ParseDelimited(parse2,parse1[i],' ','');
        // find the player in battlelist
        for j:= 0 to BattleState.Battle.Clients.count-1 do begin
          if TClient(BattleState.Battle.Clients[j]).Name = parse2[0] then begin
            with TClient(BattleState.Battle.Clients[j]) do begin
              if parse2[1] = 'n/a' then
              begin
                CurrentLadderRating := 0;
                if (GetMode <> 0) and (BattleState.Status = Hosting) then
                begin
                  MainForm.TryToSendCommand('FORCESPECTATORMODE', Name);
                  forceSpecNickList.Add(Name);
                end;
              end
              else
                CurrentLadderRating := StrToInt(parse2[1]);
              if parse2[2] = 'n/a' then
                CurrentLadderRank := 0
              else
                CurrentLadderRank := StrToInt(parse2[2]);
              CurrentLadderId := TLadder(LadderList[BattleState.LadderIndex]).id;
            end;
            break;
          end;
        end;
      end;
      VDTBattleClients.Refresh;
      if forceSpecNickList.Count >0 then
        MainForm.TryToSendCommand('SAYBATTLEEX', 'is forcing spectator players without ladder account: '+JoinStringList(forceSpecNickList,' '));
      forceSpecNickList.Free;
  end;
  end;
end;

procedure TLadderRanksThread.OnTerminateProcedure(Sender: TObject);
begin
  // nothing
end;

constructor TLadderMapThread.Create(Suspended: Boolean);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   OnTerminate := OnTerminateProcedure;
end;

procedure TLadderMapThread.Execute;
begin
  Refresh;
end;

procedure TLadderMapThread.Refresh;
var
  html:string;
  i: integer;
begin
  with BattleForm do begin
    //ChangeMapToNoMap('');
    MapsPopupStringList.Strings.Clear;
    MapsPopupStringList.Strings.Add('Loading ladder map list ...');
    StartButton.Enabled := False;

    // get the html result

    if Preferences.UseProxy then
    begin
      HttpCli2.Proxy := Preferences.ProxyAddress;
      HttpCli2.ProxyPort := IntToStr(Preferences.ProxyPort);
      HttpCli2.ProxyUsername := Preferences.ProxyUsername;
      HttpCli2.ProxyPassword := Preferences.ProxyPassword
    end
    else HttpCli2.Proxy := '';
    HttpCli2.URL := LADDER_PREFIX_URL + 'maplist.php?ladder='+IntToStr(TLadder(LadderList[BattleState.LadderIndex]).id);
    HttpCli2.RcvdStream := TMemoryStream.Create;
    try
      HttpCli2.Get;
    except
      // try again:
      try
        HttpCli2.Get;
      except
        //MainForm.AddMainLog('Error: Ladder map list unavailable :'+IntToStr(TLadder(LadderList[BattleState.LadderIndex]).id), Colors.Error);
        MapsPopupStringList.Strings.Strings[0] := 'Error: Ladder server unavailable.';
        StartButton.Enabled := BattleState.Battle.AreAllClientsReady and BattleState.Battle.AreAllClientsSynced and BattleForm.LadderTeamReady;
        MessageDlgThread('The ladder server is unavailable, if the ladder url has changed you may fix this by updating your lobby.',mtError,[mbOk],0);
        Synchronize(BattleForm.DisconnectButtonClick);
        Exit;
      end;
    end;
    HttpCli2.RcvdStream.Seek(0,0);
    SetLength(html, HttpCli2.RcvdStream.Size);
    HttpCli2.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli2.RcvdStream.Size);

    if html = '' then begin
      MapsPopupStringList.Strings.Strings[0] := 'Error: Empty map list.';
      Exit;
    end;

    if LowerCase(LeftStr(html,6)) = 'error' then
    begin
      MapsPopupStringList.Strings.Strings[0] := 'Error: Ladder not found.';
      MessageDlgThread('The ladder you joined does not exist, if the ladder url has changed you may fix this by updating your lobby.',mtError,[mbOk],0);
      Synchronize(BattleForm.DisconnectButtonClick);
      Exit;
    end;

    Misc.ParseDelimited(TLadder(LadderList[BattleState.LadderIndex]).Maps,html,#$A,'');

    MapsPopupStringList.Strings.Clear;

    for i:=0 to Utility.MapList.Count-1 do
      if TLadder(LadderList[BattleState.LadderIndex]).Maps.IndexOf(Utility.MapList[i]) >= 0 then
        MapsPopupStringList.Strings.Add(Utility.MapList[i]);

    if BattleState.Status = Hosting then
      if MapsPopupStringList.Strings.Count > 0 then
      begin
        ChangeMap(Utility.MapList.IndexOf(MapsPopupStringList.Strings.Strings[0]));
        if IsBattleActive and (BattleState.Status = Hosting) then
          SendBattleInfoToServer;
      end
      else
      begin
        DisconnectButtonClick(nil);
        MessageDlgThread('To host this ladder battle, you need at least one of the following map :'+EOL+Misc.JoinStringList(TLadder(LadderList[BattleState.LadderIndex]).Maps,' ; '), mtWarning, [mbOK], 0);
        Exit;
      end;
  end;

end;

procedure TLadderMapThread.OnTerminateProcedure(Sender: TObject);
begin
  // nothing
end;

function TBattleForm.LadderTeamReady:boolean;
var
  i : integer;
  nb : array [1..16] of Integer;
  nbTeam : integer;
begin
  if (BattleState.Status <> None) and (BattleState.LadderIndex >=0) then begin
    for i:= 1 to 16 do begin
      nb[i] := 0;
    end;
    for i:=0 to BattleState.Battle.Clients.Count-1 do begin
      if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then begin
        nb[TClient(BattleState.Battle.Clients[i]).GetAllyNo+1] := nb[TClient(BattleState.Battle.Clients[i]).GetAllyNo+1] + 1;
      end;
    end;
    with TLadder(LadderList[BattleState.LadderIndex]) do begin
      Result := False;
      nbTeam := 0;
      for i:= 1 to 16 do
        if nb[i] > 0 then begin
          nbTeam := nbTeam +1;
          if (nbTeam > 2) or (nb[i] < MinPlayersPerAllyTeam) or (nb[i] > MaxPlayersPerAllyTeam) then
            Exit;
        end;
      if nbTeam < 2 then
        Exit;
      Result := True;
    end;
  end
  else
    Result := True;
end;

procedure TBattleForm.SpTBXItem9Click(Sender: TObject);
begin
  MessageBox(BattleForm.Handle,PAnsiChar(TLadder(LadderList[BattleState.LadderIndex]).Rules),PAnsiChar('Ladder rules'),MB_OK);
end;

procedure TBattleForm.SpTBXItem10Click(Sender: TObject);
begin
  RefreshLadderRanks;
  MainForm.LadderCupsRefreshTimer(nil);
end;

procedure TBattleForm.SpTBXItem11Click(Sender: TObject);
var
  LMThread : TLadderMapThread;
begin
  LMThread := TLadderMapThread.Create(false);
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
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if Preferences.BattleClientSortStyle = Column then
    Preferences.BattleClientSortDirection := not Preferences.BattleClientSortDirection
  else
  begin
    Preferences.BattleClientSortStyle := Column;
    Preferences.BattleClientSortDirection := False;
  end;
  SortClientList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
  SortBotList(Preferences.BattleClientSortStyle,Preferences.BattleClientSortDirection,True);
  VDTBattleClients.Refresh;
end;

procedure TBattleForm.Label9Click(Sender: TObject);
begin
  MetalTracker.Value := Misc.InputBoxInteger('Custom value','Metal value :',MetalTracker.Value,0,10000);
  MetalTrackerMouseUpAfterChange(nil);
end;

procedure TBattleForm.Label8Click(Sender: TObject);
begin
  EnergyTracker.Value := Misc.InputBoxInteger('Custom value','Energy value :',EnergyTracker.Value,0,10000);
  EnergyTrackerMouseUpAfterChange(nil);
end;

procedure TBattleForm.Label10Click(Sender: TObject);
begin
  UnitsTracker.Value := Misc.InputBoxInteger('Custom value','Max units :',UnitsTracker.Value,10,5000);
  UnitsTrackerMouseUpAfterChange(nil);
end;

constructor TLuaOptionList.Create;
begin
    NameList := TStringList.Create;
    DescriptionList := TStringList.Create;
    KeyList := TStringList.Create;
end;

procedure TBattleForm.DisplayLuaOptions(luaOptionList: TList; tabSheet: TWinControl);
var
  i: Integer;
  c: TWinControl;
begin
  for i:=0 to luaOptionList.Count -1 do
  begin
    c := TLuaOption(luaOptionList[i]).GetComponent(tabSheet);
    c.Align := alBottom;
    c.Align := alTop;
    if (BattleState.Status = Joined) then
      TLuaOption(luaOptionList[i]).Disable
    else
      TLuaOption(luaOptionList[i]).Enable;
  end;
end;

procedure TLuaOption.MakeDescriptionButton(AOwner: TWinControl);
begin
  if DescriptionButton = nil then
  begin
    DescriptionButton := TSpTBXButton.Create(AOwner);
    DescriptionButton.Parent := AOwner;
    DescriptionButton.Caption := '?';
    DescriptionButton.Width := 17;
    DescriptionButton.Height := 20;
    DescriptionButton.Left := 365;
    DescriptionButton.OnClick := OnDescriptionButtonClick;
  end;
end;
procedure TLuaOption.OnDescriptionButtonClick(Sender: TObject);
begin
  MessageBox(BattleForm.Handle,PAnsiChar(Self.Name + ' : ' + Self.Description),PAnsiChar('Mod option description'),MB_OK);
end;
procedure TLuaOptionList.OnDescriptionButtonClick(Sender: TObject);
var
  msg: String;
  i: integer;
begin
  for i:=0 to DescriptionList.Count-1 do
    msg := msg + EOL + '     ' + NameList[i] + ' = ' + DescriptionList[i];
  MessageBox(BattleForm.Handle,PAnsiChar(Self.Name + ' : ' + Self.Description+EOL+msg),PAnsiChar('Mod option description'),MB_OK);
end;

function TLuaOption.GetComponent(AOwner: TWinControl): TWinControl;
begin
  if LabelName = nil then
  begin
    LabelName := TSpTBXLabel.Create(AOwner);
    LabelName.Parent := AOwner;
    LabelName.Caption := Name + ' : Unknown option type';
    LabelName.Font.Color := Colors.Error;
    LabelName.AutoSize := True;
  end;
  Result := LabelName;
end;

function TLuaOptionString.GetComponent(AOwner: TWinControl):TWinControl;
begin
  if Panel = nil then
  begin
    Panel := TPanel.Create(AOwner);
    Panel.Parent := AOwner;
    Panel.BevelOuter := bvNone;
    Panel.AutoSize := True;
    Panel.Height := 23;

    LabelName := TSpTBXLabel.Create(Panel);
    LabelName.Parent := Panel;
    LabelName.Caption := Name + ' :';
    LabelName.AutoSize := True;
    LabelName.Left := 8;
    LabelName.Top := 3;
    LabelName.Width := 180;
    LabelName.Hint := Description;
    LabelName.ShowHint := True;

    InputEdit := TSpTBXEdit.Create(Panel);
    InputEdit.Parent := Panel;
    InputEdit.Left := 188;
    InputEdit.Top := 0;
    InputEdit.MaxLength := MaxStringLength;
    InputEdit.Hint := Description;
    InputEdit.ShowHint := True;
    InputEdit.Width := 170;
    InputEdit.Text := DefaultValue;
    InputEdit.OnExit := self.OnChange;

    MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOptionNumber.GetComponent(AOwner: TWinControl):TWinControl;
begin
  if Panel = nil then
  begin
    Panel := TPanel.Create(AOwner);
    Panel.Parent := AOwner;
    Panel.BevelOuter := bvNone;
    Panel.AutoSize := True;
    Panel.Height := 23;

    LabelName := TSpTBXLabel.Create(Panel);
    LabelName.Parent := Panel;
    LabelName.Caption := Name + ' :';
    LabelName.AutoSize := True;
    LabelName.Left := 8;
    LabelName.Top := 3;
    LabelName.Width := 180;
    LabelName.Hint := Description;
    LabelName.ShowHint := True;

    InputEdit := TJvSpinEdit.Create(Panel);
    InputEdit.Parent := Panel;
    InputEdit.ButtonKind := bkStandard;
    InputEdit.BorderStyle := bsSingle;
    InputEdit.ValueType := vtFloat;
    InputEdit.CheckMinValue := True;
    InputEdit.CheckMaxValue := True;
    InputEdit.CheckOptions := [coCheckOnExit,coCropBeyondLimit];
    InputEdit.MaxValue := MaxValue;
    InputEdit.MinValue := MinValue;
    if StepValue <= 0 then
    begin
      InputEdit.ShowButton := False;
      InputEdit.Increment := 0.0000000001;
      InputEdit.Decimal := 10;
    end
    else
    begin
      InputEdit.Increment := StepValue;
      InputEdit.Decimal := 4;
    end;
    InputEdit.Value := StrToFloat(DefaultValue);
    InputEdit.Hint := Description;
    InputEdit.ShowHint := True;
    InputEdit.Width := 170;
    InputEdit.OnExit := self.OnChange;
    InputEdit.Left := 188;
    InputEdit.Top := 0;

    MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOptionBool.GetComponent(AOwner: TWinControl):TWinControl;
begin
  if Panel = nil then
  begin
    Panel := TPanel.Create(AOwner);
    Panel.Parent := AOwner;
    Panel.BevelOuter := bvNone;
    Panel.AutoSize := True;
    Panel.Height := 23;

    LabelName := TSpTBXLabel.Create(Panel);
    LabelName.Parent := Panel;
    LabelName.Caption := Name + ' :';
    LabelName.Left := 8;
    LabelName.Top := 3;
    LabelName.Width := 180;
    LabelName.Hint := Description;
    LabelName.ShowHint := True;
  
    CheckBox := TSpTBXCheckBox.Create(Panel);
    CheckBox.Parent := Panel;
    CheckBox.Left := 188;
    CheckBox.Top := 3;
    CheckBox.AutoSize := False;
    CheckBox.Caption := '';
    CheckBox.Height := 15;
    CheckBox.Hint := Description;
    CheckBox.ShowHint := True;
    CheckBox.Checked := StrToBool(DefaultValue);
    CheckBox.OnClick := self.OnChange;

    MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOptionList.GetComponent(AOwner: TWinControl):TWinControl;
var
  i: integer;
begin
  if Panel = nil then
  begin
    Panel := TPanel.Create(AOwner);
    Panel.Parent := AOwner;
    Panel.BevelOuter := bvNone;
    Panel.AutoSize := True;
    Panel.Height := 23;

    LabelName := TSpTBXLabel.Create(Panel);
    LabelName.Parent := Panel;
    LabelName.Caption := Name + ' :';
    LabelName.Align := alNone;
    LabelName.AutoSize := True;
    LabelName.Left := 8;
    LabelName.Top := 3;
    LabelName.Width := 180;
    LabelName.Hint := Description;
    LabelName.ShowHint := True;

    ComboBox := TSpTBXComboBox.Create(Panel);
    ComboBox.Parent := Panel;
    ComboBox.Style := csDropDownList;
    ComboBox.Top := 0;
    ComboBox.Width := 170;
    ComboBox.Height := 21;
    ComboBox.Items.Assign(NameList);
    ComboBox.ItemIndex := Max(0,KeyList.IndexOf(DefaultValue));
    ComboBox.Left := 188;
    ComboBox.Hint := Description;
    ComboBox.ShowHint := True;
    ComboBox.OnChange := self.OnChange;

    MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOption.toString:String;
begin
  Result := Value;
end;

function TLuaOptionNumber.toString:String;
begin
  Result := InputEdit.Text;
end;

function TLuaOptionString.toString:String;
begin
  Result := InputEdit.Text;
end;

function TLuaOptionList.toString:String;
begin
  Result := KeyList[ComboBox.ItemIndex];
end;

function TLuaOptionBool.toString:String;
begin
  Result := IntToStr(BoolToInt(CheckBox.Checked));
end;

procedure TLuaOption.OnChange(Sender: TObject);
begin
  if (BattleState.Status = Hosting) and AllowBattleDetailsUpdate then
  begin
    MainForm.TryToSendCommand('SETSCRIPTTAGS', StringReplace(KeyPrefix+Key,'/','\',[rfReplaceAll])+'='+Self.toString);
  end;
end;

procedure TLuaOptionNumber.OnChange(Sender: TObject);
begin
  if StepValue <= 0 then
  begin
    inherited OnChange(Sender)
  end
  else
  begin
    InputEdit.Text := FloatToStr(Round(StrToFloat(InputEdit.Text) / StepValue)*StepValue);
    inherited OnChange(Sender)
  end;
end;

procedure TLuaOption.SetValue(v: String);
begin
    Value := v;
end;

procedure TLuaOption.setToDefault;
begin
    Value := DefaultValue;
end;

procedure TLuaOptionString.SetValue(v: String);
begin
    InputEdit.Text := v;
end;

procedure TLuaOptionString.setToDefault;
begin
    InputEdit.Text := DefaultValue;
end;

procedure TLuaOptionList.SetValue(v: String);
begin
  ComboBox.ItemIndex := Max(0,KeyList.IndexOf(v));
end;

procedure TLuaOptionList.setToDefault;
begin
  ComboBox.ItemIndex := Max(0,KeyList.IndexOf(DefaultValue));
end;

procedure TLuaOptionBool.SetValue(v: String);
begin
    CheckBox.Checked := StrToBool(v);
end;

procedure TLuaOptionBool.setToDefault;
begin
    CheckBox.Checked := StrToBool(DefaultValue);
end;

procedure TLuaOptionNumber.SetValue(v: String);
begin
    InputEdit.Text := v;
end;

procedure TLuaOptionNumber.setToDefault;
begin
    InputEdit.Text := DefaultValue;
end;

procedure TLuaOption.Enable;
begin
  // nothing
end;
procedure TLuaOption.Disable;
begin
  // nothing
end;

procedure TLuaOptionString.Enable;
begin
  LabelName.Enabled := True;
  InputEdit.Enabled := True;
end;
procedure TLuaOptionString.Disable;
begin
  LabelName.Enabled := False;
  InputEdit.Enabled := False;
end;

procedure TLuaOptionList.Enable;
begin
  LabelName.Enabled := True;
  ComboBox.Enabled := True;
end;
procedure TLuaOptionList.Disable;
begin
  LabelName.Enabled := False;
  ComboBox.Enabled := False;
end;

procedure TLuaOptionBool.Enable;
begin
  LabelName.Enabled := True;
  CheckBox.Enabled := True;
end;
procedure TLuaOptionBool.Disable;
begin
  LabelName.Enabled := False;
  CheckBox.Enabled := False;
end;

procedure TLuaOptionNumber.Enable;
begin
  LabelName.Enabled := True;
  InputEdit.Enabled := True;
end;
procedure TLuaOptionNumber.Disable;
begin
  LabelName.Enabled := False;
  InputEdit.Enabled := False;
end;

destructor TLuaOption.Destroy;
begin
  LabelName.Destroy;
  inherited Destroy;
end;

destructor TLuaOptionList.Destroy;
begin
  NameList.Free;
  DescriptionList.Free;
  inherited Destroy;
  Panel.Destroy;
end;

destructor TLuaOptionString.Destroy;
begin
  inherited Destroy;
  Panel.Destroy;
end;

destructor TLuaOptionNumber.Destroy;
begin
  inherited Destroy;
  Panel.Destroy;
end;

destructor TLuaOptionBool.Destroy;
begin
  inherited Destroy;
  Panel.Destroy;
end;

function TBattleForm.GetLuaOption(optList: TList;key: string): TLuaOption;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to optList.Count-1 do
  begin
    if LowerCase(TLuaOption(optList[i]).Key) = LowerCase(key) then
    begin
      Result := TLuaOption(optList[i]);
      Exit;
    end;
  end;
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
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  for i:=0 to ModOptionsList.Count -1 do
    TLuaOption(ModOptionsList[i]).OnChange(nil);

  for i:=0 to MapOptionsList.Count -1 do
    TLuaOption(MapOptionsList[i]).OnChange(nil);
end;

procedure TBattleForm.FormResize(Sender: TObject);
begin
  FixFormSizeConstraints(BattleForm);
end;

procedure TBattleForm.SpTBXTabControl1ActiveTabChange(Sender: TObject;
  TabIndex: Integer);
begin
  SpTBXTabControl1.ActivePage.Item.FontSettings.Bold := tsFalse;
end;

procedure TBattleForm.LockGameSpeedCheckBoxClick(Sender: TObject);
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendCommand('SETSCRIPTTAGS', 'GAME/IsGameSpeedLocked='+IntToStr(BoolToInt(LockGameSpeedCheckBox.Checked)));
end;

procedure TBattleForm.mnuNewGroupClick(Sender: TObject);
begin
  MainForm.mnuNewGroupClick(nil);
end;

procedure TBattleForm.mnuRemoveFromGroupClick(Sender: TObject);
begin
  MainForm.mnuRemoveFromGroupClick(nil);
end;

procedure TBattleForm.ChatRichEditMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MainForm.RichEditMouseDown(Sender,Button,Shift,X,Y);
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
    Filename := MODS_CACHE_FOLDER + '\' + BattleState.Battle.ModName +'.ini';
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
  Filename := MODS_CACHE_FOLDER + '\' + modName +'.ini';
  Ini := TIniFile.Create(Filename);
  if Ini.SectionExists('ModOptions') then
  begin
    for i:=0 to ModOptionsList.Count -1 do
      TLuaOption(ModOptionsList[i]).SetValue(Ini.ReadString('ModOptions', TLuaOption(ModOptionsList[i]).Key, TLuaOption(ModOptionsList[i]).DefaultValue));
  end;
  Ini.Free;
end;

procedure TBattleForm.SaveMapOptionsAsDefault;
var
  Filename : String;
  Ini : TIniFile;
  i:integer;
begin
  try
    Filename := MAPS_CACHE_FOLDER + '\' + Utility.MapChecksums[CurrentMapIndex] +'.options';
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
  Filename := MAPS_CACHE_FOLDER + '\' + Utility.MapChecksums[CurrentMapIndex] +'.options';
  Ini := TIniFile.Create(Filename);
  if Ini.SectionExists('MapOptions') then
  begin
    for i:=0 to MapOptionsList.Count -1 do
      TLuaOption(MapOptionsList[i]).SetValue(Ini.ReadString('MapOptions', TLuaOption(MapOptionsList[i]).Key, TLuaOption(MapOptionsList[i]).DefaultValue));
  end;
  Ini.Free;
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

end.
