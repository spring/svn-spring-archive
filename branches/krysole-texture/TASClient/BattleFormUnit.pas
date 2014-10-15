{
  - Do not confuse battle status and battle state!
  - If you change any of the tab sheet captions, make sure any sentences like
    "if PageControl1.ActivePage.Caption = 'Player control' then ..." gets
    updated too!

}

unit BattleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, janTracker, Buttons, Unit1, jpeg,
  VirtualTrees, Menus, RichEditURL, JvExControls, JvComponent, JvButton,
  JvTransparentButton, JvgSpeedButton, JvgShadow, JvgButton, JvExStdCtrls,
  JvXPCore, JvXPButtons, TBXToolPals, TB2Item, TBX, SpTBXItem;

type

  // we have to use this ugly hack to expose SelectedCell property in TTBXColorPallete class:
  TTBXColorPaletteHack = class(TTBXColorPalette)
  end;

  TBattleForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    InputEdit: TEdit;
    SizeLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel3: TPanel;
    StartButton: TButton;
    HostButton: TButton;
    DisconnectButton: TButton;
    ClientsListBox: TListBox;
    Label14: TLabel;
    GameTimer: TTimer;
    NoMapImage: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ResourcesGroupBox: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EnergyTracker: TjanTracker;
    MetalTracker: TjanTracker;
    UnitsTracker: TjanTracker;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    GameEndRadioGroup: TRadioGroup;
    StartPosRadioGroup: TRadioGroup;
    MyOptionsGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    TeamComboBox: TComboBox;
    AllyComboBox: TComboBox;
    SideLabel: TLabel;
    SideComboBox: TComboBox;
    SpectateCheckBox: TCheckBox;
    Label16: TLabel;
    Label17: TLabel;
    MapDescLabel: TLabel;
    TeamColorSpeedButton: TSpeedButton;
    PlayerControlGroupBox: TGroupBox;
    HandicapTracker: TjanTracker;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label18: TLabel;
    Label19: TLabel;
    ForceTeamComboBox: TComboBox;
    ForceAllyComboBox: TComboBox;
    UnitsGroupBox: TGroupBox;
    DisabledUnitsListBox: TListBox;
    AddUnitsSpeedButton: TSpeedButton;
    PopupMenu1: TPopupMenu;
    Item1: TMenuItem;
    MapPanel: TPanel;
    MapList: TListBox;
    MapImage: TImage;
    Splitter1: TSplitter;
    AddBotButton: TButton;
    Label15: TLabel;
    Label20: TLabel;
    ReloadMapListButton: TSpeedButton;
    ForceTeamColorButton: TSpeedButton;
    Label13: TLabel;
    ChatRichEdit: TRichEditURL;
    LimitDGunCheckBox: TCheckBox;
    LockedCheckBox: TCheckBox;
    ReadyCheckBox: TCheckBox;
    Bevel1: TBevel;
    TabSheet5: TTabSheet;
    GhostedBuildingsCheckBox: TCheckBox;
    DiminishingMMsCheckBox: TCheckBox;
    SetDefaultButton: TJvXPButton;
    LoadDefaultButton: TJvXPButton;
    LockGameSpeedCheckBox: TCheckBox;
    Label21: TLabel;
    ColorPopupMenu: TSpTBXPopupMenu;
    TBXColorPalette1: TTBXColorPalette;
    TBXColorSet1: TTBXColorSet;
    SpTBXItem1: TSpTBXItem;

    procedure CreateParams(var Params: TCreateParams); override;

    function IsBattleActive: Boolean;
    procedure AddTextToChat(Text: string; Color: TColor; ChatTextPos: Integer);
    procedure UpdateClientsListBox;
    function GetMyBattleStatus: Integer;
    procedure SetMyBattleStatus(Side: Integer; Ready: Boolean; TeamNo: Integer; AllyNo: Integer; Mode: Integer; TeamColor: Integer);
    procedure SendMyBattleStatusToServer;
    procedure SendReplayScriptToServer;
    procedure SendBattleDetailsToServer;
    procedure SendBattleInfoToServer;
    procedure PopulateMapList;
    procedure GenerateNormalScriptFile(FileName: string);
    procedure GenerateReplayScriptFile(FileName: string);
    procedure PunchThroughNAT; // only used when hosting using "hole punching" technique. See comments at method's implementation for more info.

    function ChooseColorDialog(UnderControl: TControl; DefaultColorIndex: Integer): Integer;
    procedure ChangeTeamColor(ColorIndex: Integer; UpdateServer: Boolean);
    procedure ChangeForceTeamColor(ColorIndex: Integer);

    procedure FigureOutBestPossibleTeamAllyAndColor;
    procedure ChangeCurrentMod(ModName: string);

    procedure OnStartGameMessage(var Msg: TMessage); message WM_STARTGAME;

    procedure ResetBattleScreen;
    function JoinBattle(BattleID: Integer): Boolean;
    function JoinBattleReplay(BattleID: Integer): Boolean;
    function HostBattle(BattleID: Integer): Boolean;
    function HostBattleReplay(BattleID: Integer): Boolean;    
    procedure ChangeMapToNoMap(MapName: string);
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

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MapListClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure HostButtonClick(Sender: TObject);
    procedure MapImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure ReadyCheckBoxClick(Sender: TObject);
    procedure SideComboBoxChange(Sender: TObject);
    procedure TeamComboBoxChange(Sender: TObject);
    procedure AllyComboBoxChange(Sender: TObject);
    procedure SideComboBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SideLabelClick(Sender: TObject);
    procedure MetalTrackerMouseUpAfterChange(Sender: TObject);
    procedure EnergyTrackerMouseUpAfterChange(Sender: TObject);
    procedure UnitsTrackerMouseUpAfterChange(Sender: TObject);
    procedure StartPosRadioGroupClick(Sender: TObject);
    procedure ClientsListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure GameTimerTimer(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpectateCheckBoxClick(Sender: TObject);
    procedure ClientsListBoxDblClick(Sender: TObject);
    procedure GameEndRadioGroupClick(Sender: TObject);
    procedure HandicapTrackerMouseUpAfterChange(Sender: TObject);
    procedure ClientsListBoxClick(Sender: TObject);
    procedure TeamColorSpeedButtonClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ForceTeamComboBoxClick(Sender: TObject);
    procedure ForceAllyComboBoxClick(Sender: TObject);
    procedure AddUnitsSpeedButtonClick(Sender: TObject);
    procedure Item1Click(Sender: TObject);
    procedure AddBotButtonClick(Sender: TObject);
    procedure ReloadMapListButtonClick(Sender: TObject);
    procedure ForceTeamColorButtonClick(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
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
    procedure TBXColorSet1GetColorInfo(Sender: TTBXCustomColorSet; Col,
      Row: Integer; var Color: TColor; var Name: String);
    procedure TBXColorPalette1CellClick(Sender: TTBXCustomToolPalette;
      var ACol, ARow: Integer; var AllowChange: Boolean);
  private
    History: TStringList;
    HistoryIndex: Integer;
  public
    LogFile: TFileStream; // use the same way as TMyTabSheet.LogFile is used
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
    Battle: TBattle; // don't ever free this object! It is freed automatically by RemoveBattle method! This object is only "pointer" to an item in Battles list!
    Process: // we need this information when we launch game exe
    record
      proc_info: TProcessInformation;
      startinfo: TStartupInfo;
      ExitCode: LongWord;
    end;

    StartRects: array of TStartRect;
    DrawingStartRect: Shortint; // if -1, then we are not drawing a "start rectangle"
    SelectedStartRect: Shortint; // if -1, no start rect is selected
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
  InitWaitFormUnit, AddBotUnit, UpdateBotUnit, Math, OnlineMapsUnit,
  ReplaysUnit, StrUtils;

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

{ returns True if battle is active, that is if we are hosting a battle or if
  we are connected to someone else's battle }
function TBattleForm.IsBattleActive: Boolean;
begin
  Result := (BattleState.Status = Hosting) or (BattleState.Status = Joined);
end;

{ for ChatTextPos argument, see MainForm's AddTextToChatWindow method's comments }
procedure TBattleForm.AddTextToChat(Text: string; Color: TColor; ChatTextPos: Integer);
var
  s: string;
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
  tmpItemIndex: Integer;
begin
  tmpItemIndex := ClientsListBox.ItemIndex;

  if BattleState.Status = None then
    ClientsListBox.Items.SetText(PChar(''))
  else
    if BattleState.Battle.BattleType = 0 then
      ClientsListBox.Items.SetText(PChar(CreateStrings(BattleState.Battle.Clients.Count + BattleState.Battle.Bots.Count)))
    else ClientsListBox.Items.SetText(PChar(CreateStrings(BattleState.Battle.Clients.Count + BattleReplayInfo.OriginalClients.Count)));

  if ClientsListBox.ItemIndex = -1 then // this should actually always be true since ItemIndex should change to -1 when Items change
    if (BattleState.Status = Hosting) and (PageControl1.ActivePage.Caption = 'Player control') then
    begin
      if tmpItemIndex > BattleState.Battle.Clients.Count-1 then
        DisableControlAndChildren(PlayerControlGroupBox)
      else
      begin
        ClientsListBox.ItemIndex := tmpItemIndex;
        ClientsListBox.OnClick(nil);
      end;
    end
    else
      DisableControlAndChildren(PlayerControlGroupBox);
end;

function TBattleForm.GetMyBattleStatus: Integer;
begin
  // see protocol's description for more info on battle status value!

  Result := 0;

  // ready:
  Inc(Result, BoolToInt(ReadyCheckBox.Checked) shl 1);

  // team no.:
  Inc(Result, TeamComboBox.ItemIndex shl 2);

  // ally no.:
  Inc(Result, AllyComboBox.ItemIndex shl 6);

  // mode:
  Inc(Result, BoolToInt(not SpectateCheckBox.Checked) shl 10);

  // handicap is ignored (only host can change it)

  // team color index:
  Inc(Result, MyTeamColorIndex shl 18);

  // sync status:
  Inc(Result, (2-BoolToInt(Status.Synced)) shl 22);

  // side:
  Inc(Result, SideComboBox.ItemIndex shl 24);

end;

procedure TBattleForm.SetMyBattleStatus(Side: Integer; Ready: Boolean; TeamNo: Integer; AllyNo: Integer; Mode: Integer; TeamColor: Integer);
begin
  AllowBattleStatusUpdate := False;

  // handicap is ignored (only host can change it)
  SideComboBox.ItemIndex := Side;
  ReadyCheckBox.Checked := Ready;
  TeamComboBox.ItemIndex := TeamNo;
  AllyComboBox.ItemIndex := AllyNo;
  SpectateCheckBox.Checked := not IntToBool(Mode);
  ChangeTeamColor(TeamColor, False);

  AllowBattleStatusUpdate := True;
end;

{ updates the battle status only if AllowBattleStatusUpdate = True }
procedure TBattleForm.SendMyBattleStatusToServer;
begin
  if not IsBattleActive then Exit; // we are not allowed to call it if we are not participating in a battle

  if not AllowBattleStatusUpdate then Exit;

  MainForm.TryToSendData('MYBATTLESTATUS ' + IntToStr(GetMyBattleStatus));
end;

procedure TBattleForm.SendReplayScriptToServer;
var
  i: Integer;
begin
  MainForm.TryToSendData('SCRIPTSTART');
  for i := 0 to BattleReplayInfo.Script.Count-1 do
    MainForm.TryToSendData('SCRIPT ' + BattleReplayInfo.Script[i]);
  MainForm.TryToSendData('SCRIPTEND');
end;

procedure TBattleForm.SendBattleDetailsToServer; // call it each time you update some of the battle's inside parameters
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  if not AllowBattleDetailsUpdate then Exit;

  MainForm.TryToSendData('UPDATEBATTLEDETAILS ' + IntToStr(MetalTracker.Value) + ' ' + IntToStr(EnergyTracker.Value) + ' ' + IntToStr(UnitsTracker.Value) + ' ' +IntToStr(StartPosRadioGroup.ItemIndex) + ' ' +IntToStr(GameEndRadioGroup.ItemIndex) + ' ' + IntToStr(BoolToInt(LimitDGunCheckBox.Checked)) + ' ' + IntToStr(BoolToInt(DiminishingMMsCheckBox.Checked)) + ' ' + IntToStr(BoolToInt(GhostedBuildingsCheckBox.Checked)));
end;

procedure TBattleForm.SendBattleInfoToServer; // call it each time you update some of the battle's outside parameters
begin
  if not (BattleState.Status = Hosting) then Exit; // this should not happen though

  MainForm.TryToSendData('UPDATEBATTLEINFO ' + IntToStr(BattleState.Battle.SpectatorCount) + ' ' + IntToStr(BoolToInt(LockedCheckBox.Checked)) + ' ' + MapList.Items[MapList.ItemIndex]);
end;


{ tries to figure out best possible team number, ally number and team color. It tries to use those numbers that aren't used
  by other players in the battle. NOTE: you shouldn't call this method before you received all battle statuses of the players
  in battle! That is why you should call it when you receive REQUESTBATTLESTATUS and not before! }
procedure TBattleForm.FigureOutBestPossibleTeamAllyAndColor;
var
  i: Integer;
  team, ally, color: Integer;
  found: Boolean;
begin
  if not IsBattleActive then Exit; // should not happen!

  if BattleState.Battle.BattleType = 1 then
  begin
    SetMyBattleStatus(0, False, 0, 0, 0, 0);
    Exit;
  end;

  // find first available team and ally:
  team := 0;
  found := False;
  while not Found do
  begin
    Found := True;
    for i := 0 to BattleState.Battle.Clients.Count - 1 do
      if TClient(BattleState.Battle.Clients[i]).Name <> Status.Username then
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
  color := 0;
  found := False;
  while not Found do
  begin
    Found := True;
    for i := 0 to BattleState.Battle.Clients.Count - 1 do
      if TClient(BattleState.Battle.Clients[i]).Name <> Status.Username then
        if TClient(BattleState.Battle.Clients[i]).GetMode <> 0 then
          if TClient(BattleState.Battle.Clients[i]).GetTeamColor = color then
          begin
            Inc(color);
            Found := False;
            Break;
          end;
    for i := 0 to BattleState.Battle.Bots.Count - 1 do
      if TBot(BattleState.Battle.Bots[i]).GetTeamColor = color then
      begin
        Inc(color);
        Found := False;
        Break;
      end;
  end;
  if color > 9 then color := 0;
  if team > 9 then team := 0;
  if ally > 9 then ally := 0;

  SetMyBattleStatus(SideComboBox.ItemIndex, False, team, ally, 1, color);
end;

procedure TBattleForm.ChangeCurrentMod(ModName: string);
var
  tmp: Integer;
  tmpBool: Boolean;
  Side1, Side2: string;
  s: string;

begin

  tmp := ModList.Count;
  if not Utility.ReInitLib then
  begin
    MessageDlg('Error initializing unit syncer!', mtError, [mbOK], 0);
    Application.Terminate;
  end;
  tmpBool := tmp <> ModList.Count; // did number of mods change?
  // update mod list:
  if tmpBool then
  begin
    s := HostBattleForm.ModsComboBox.Text;
    HostBattleForm.ModsComboBox.Items.Assign(Utility.ModList);
    HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(s));
  end;

  LoadMod(ModArchiveList[ModList.IndexOf(ModName)]);

  Side1 := SideComboBox.Text;
  Side2 := AddBotForm.BotSideComboBox.Text;
  GetSides(SideList, MainForm.SideImageList);
  if SideList.Count > 16 then
  begin
    MainForm.AddMainLog('Warning: more than 16 sides detected in current mod, truncating ...', Colors.Error);
    while SideList.Count > 16 do SideList.Delete(SideList.Count-1);
  end;
  SideComboBox.Items.Assign(SideList);
  AddBotForm.BotSideComboBox.Items.Assign(SideList);
  UpdateBotForm.BotSideComboBox.Items.Assign(SideList);

  SideComboBox.ItemIndex := Min(Max(0, SideComboBox.Items.IndexOf(Side1)), SideList.Count-1);
  AddBotForm.BotSideComboBox.ItemIndex := Min(Max(0, AddBotForm.BotSideComboBox.Items.IndexOf(Side2)), SideList.Count-1);
  UpdateBotForm.BotSideComboBox.ItemIndex := 0;

end;

// used with "hole punching" NAT traversal technique
procedure TBattleForm.PunchThroughNAT;
var
  i: Integer;
begin
  for i := 1 {skip the host} to BattleState.Battle.Clients.Count-1 do
  try
    Misc.SendUDPStrEx(TClient(BattleState.Battle.Clients[i]).IP, TClient(BattleState.Battle.Clients[i]).PublicPort, NATTraversal.MyPrivateUDPSourcePort, 2, 'HELLO'); // what we send doesn't really matter (we can send an empty packet as well).
  except
    MainForm.AddMainLog('Error while sending UDP packet to ' + TClient(BattleState.Battle.Clients[i]).Name + ' (IP=' + TClient(BattleState.Battle.Clients[i]).IP + ')', Colors.Error);
  end;
end;

procedure TBattleForm.OnStartGameMessage(var Msg: TMessage); // responds to WM_STARTGAME message
var
  i: Integer;

begin
  if not IsBattleActive then Exit; // this should not happen

  if Status.AmIInGame then Exit;

  if (BattleState.Status = Hosting) then
    case BattleState.Battle.NATType of
    0: ;
    1: PunchThroughNAT;
    2: for i := 1 {skip the host} to BattleState.Battle.Clients.Count-1 do
       try
         Misc.SendUDPStrEx(TClient(BattleState.Battle.Clients[i]).IP, FIRST_UDP_SOURCEPORT + i - 1, BattleState.Battle.Port, 2, 'HELLO'); // what we send doesn't really matter (we could probably send an empty packet as well).
       except
         MainForm.AddMainLog('Error while sending UDP packet to ' + TClient(BattleState.Battle.Clients[i]).Name + ' (IP=' + TClient(BattleState.Battle.Clients[i]).IP + ')', Colors.Error);
       end;
    end;

  ReadyCheckBox.Checked := False; // status is automatically updated in OnClick event (which is triggered by changing Checked property, in case it differs from previous value - which is the case here)

//***  DeleteFile(ExtractFilePath(Application.ExeName) + 'script.txt'); // no problem if file does not exist (function will return FALSE in that case)

  if BattleState.Battle.BattleType = 0 then
    GenerateNormalScriptFile(ExtractFilePath(Application.ExeName) + 'script.txt')
  else GenerateReplayScriptFile(ExtractFilePath(Application.ExeName) + 'script.txt');

  FillChar(BattleState.Process.proc_info, sizeof(TProcessInformation), 0);
  FillChar(BattleState.Process.startinfo, sizeof(TStartupInfo), 0);
  BattleState.Process.startinfo.cb := sizeof(TStartupInfo);
  if CreateProcess(nil, PChar(ExtractFilePath(Application.ExeName) + 'spring.exe script.txt'), nil, nil, false, CREATE_DEFAULT_ERROR_MODE + NORMAL_PRIORITY_CLASS,
                   nil, PChar(ExtractFilePath(Application.ExeName)), BattleState.Process.startinfo, BattleState.Process.proc_info) then
  begin
    AddTextToChat('Game launched', Colors.Info, 1);
    Status.AmIInGame := True;
    MainForm.TryToSendData('MYSTATUS 1');
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
  index: Integer;
  tmp: Integer;

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

  MapList.Enabled := False;
  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  EnableControlAndChildren(MyOptionsGroupBox);
  ReadyCheckBox.Enabled := True;
  DisableControlAndChildren(UnitsGroupBox);
  LimitDGunCheckBox.Enabled := False;
  DiminishingMMsCheckBox.Enabled := False;
  GhostedBuildingsCheckBox.Enabled := False;
  LockGameSpeedCheckBox.Enabled := False;
  LockedCheckBox.Enabled := False;
  LockedCheckBox.Checked := Battle.Locked;
  LoadDefaultButton.Enabled := False;

//  SetMyBattleStatus(SideComboBox.ItemIndex, False, 0, 0, 1, MyTeamColorIndex); *** we will update it once we receive REQUESTBATTLESTATUS
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS (server should send it after he is finished sending us battle statuses of other players)

  BattleState.Battle.RemoveAllBots;
  UpdateClientsListBox;

  // update map:
  index := MapList.Items.IndexOf(Battle.Map);
  if index = -1 then ChangeMapToNoMap(Battle.Map)
  else
  begin
    tmp := BattleForm.MapList.ItemIndex;
    MapList.ItemIndex := index;
    if tmp <> index then
      MapList.OnClick(nil); // we MUST send nil as parameter, since the event checks if Sender is nil and that way he knows whether user clicked on map list or not
  end;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := True;

  AddTextToChat('Joined battle', Colors.Info, 1);

  BattleState.Status := Joined;

  ResetStartRects;
  BattleForm.Caption := 'Battle window (' + BattleState.Battle.ModName + ')';

  Result := True;

  PlayResSound('battle');

//*** anything else?
end;

function TBattleForm.JoinBattleReplay(BattleID: Integer): Boolean;
var
  Battle: TBattle;
  index: Integer;
  tmp: Integer;

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

  MapList.Enabled := False;
  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyCheckBox.Enabled := True;
  DisableControlAndChildren(UnitsGroupBox);
  LimitDGunCheckBox.Enabled := False;
  DiminishingMMsCheckBox.Enabled := False;
  GhostedBuildingsCheckBox.Enabled := False;
  LockGameSpeedCheckBox.Enabled := False;
  LockedCheckBox.Enabled := False;
  LockedCheckBox.Checked := Battle.Locked;
  LoadDefaultButton.Enabled := False;

//  SetMyBattleStatus(SideComboBox.ItemIndex, False, 0, 0, 1, MyTeamColorIndex); *** we will update it once we receive REQUESTBATTLESTATUS
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS (server should send it after he is finished sending us battle statuses of other players)

  BattleState.Battle.RemoveAllBots;
  UpdateClientsListBox;

  // update map:
  index := MapList.Items.IndexOf(Battle.Map);
  if index = -1 then ChangeMapToNoMap(Battle.Map)
  else
  begin
    tmp := BattleForm.MapList.ItemIndex;
    MapList.ItemIndex := index;
    if tmp <> index then
      MapList.OnClick(nil); // we MUST send nil as parameter, since the event checks if Sender is nil and that way he knows whether user clicked on map list or not
  end;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := False;

  AddTextToChat('Joined battle replay', Colors.Info, 1);

  BattleState.Status := Joined;

  ResetStartRects;
  BattleForm.Caption := 'Battle window (' + BattleState.Battle.ModName + ')';

  Result := True;

  PlayResSound('battle');

//*** anything else?
end;

function TBattleForm.HostBattle(BattleID: Integer): Boolean;
var
  Battle: TBattle;
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

  DisabledUnitsListBox.Clear;

  MapList.Enabled := True;
  StartPosRadioGroup.Enabled := True;
  GameEndRadioGroup.Enabled := True;
  EnableControlAndChildren(ResourcesGroupBox);
  EnableControlAndChildren(MyOptionsGroupBox);
  ReadyCheckBox.Enabled := True;
  EnableControlAndChildren(UnitsGroupBox);
  LimitDGunCheckBox.Enabled := True;
  DiminishingMMsCheckBox.Enabled := True;
  GhostedBuildingsCheckBox.Enabled := True;
  LockGameSpeedCheckBox.Enabled := True;
  LockedCheckBox.Enabled := True;
  LockedCheckBox.Checked := False;
  LoadDefaultButton.Enabled := True;

  SetMyBattleStatus(SideComboBox.ItemIndex, False, 0, 0, 1, MyTeamColorIndex);
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS (server should send it after he is finished sending us battle statuses of other players)

  BattleState.Battle.RemoveAllBots;
  UpdateClientsListBox;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := True;

  AddTextToChat('Battle opened', Colors.Info, 1);

  BattleState.Status := Hosting;

  ResetStartRects;
  BattleForm.Caption := 'Battle window (' + BattleState.Battle.ModName + ')';

  Result := True;

  PlayResSound('battle');

//*** anything else?
end;

function TBattleForm.HostBattleReplay(BattleID: Integer): Boolean;
var
  Battle: TBattle;
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

  DisabledUnitsListBox.Clear;

  MapList.Enabled := False;
  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyCheckBox.Enabled := True;
  DisableControlAndChildren(UnitsGroupBox);
  LimitDGunCheckBox.Enabled := False;
  DiminishingMMsCheckBox.Enabled := False;
  GhostedBuildingsCheckBox.Enabled := False;
  LockGameSpeedCheckBox.Enabled := True;
  LockedCheckBox.Enabled := True;
  LockedCheckBox.Checked := False;
  LoadDefaultButton.Enabled := False;

  SetMyBattleStatus(0, False, 0, 0, 1, 0);
  // we will send our battle status to server as soon as we receive REQUESTBATTLESTATUS (server should send it after he is finished sending us battle statuses of other players)

  BattleState.Battle.RemoveAllBots;

  DisconnectButton.Enabled := True;
  StartButton.Enabled := False;
  HostButton.Enabled := False;
  AddBotButton.Enabled := False;

  AddTextToChat('Battle replay opened', Colors.Info, 1);

  BattleState.Status := Hosting;

  ResetStartRects;
  BattleForm.Caption := 'Battle window (' + BattleState.Battle.ModName + ')';

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

  PlayResSound('battle');

//*** anything else?
end;

{ resets the battle screen: clears the clients list, enables/disables controls, ... }
procedure TBattleForm.ResetBattleScreen;
begin
  if IsBattleActive then
  begin
    AddTextToChat('Battle closed', Colors.Info, 1);
    PlayResSound('battle');
  end;

  BattleState.Status := None;

  DisabledUnitsListBox.Clear;

  MapList.Enabled := True;
  StartPosRadioGroup.Enabled := False;
  GameEndRadioGroup.Enabled := False;
  DisableControlAndChildren(PlayerControlGroupBox);
  DisableControlAndChildren(ResourcesGroupBox);
  DisableControlAndChildren(MyOptionsGroupBox);
  ReadyCheckBox.Enabled := False;
  DisableControlAndChildren(UnitsGroupBox);
  LimitDGunCheckBox.Enabled := False;
  DiminishingMMsCheckBox.Enabled := False;
  GhostedBuildingsCheckBox.Enabled := False;
  LockGameSpeedCheckBox.Enabled := False;
  LockedCheckBox.Enabled := False;
  LoadDefaultButton.Enabled := False;

  SetMyBattleStatus(SideComboBox.ItemIndex, False, 0, 0, 1, MyTeamColorIndex);

  UpdateClientsListBox;

  DisconnectButton.Enabled := False;
  StartButton.Enabled := False;
  HostButton.Enabled := True;
  AddBotButton.Enabled := False;

  ResetStartRects;
  BattleForm.Caption := 'Battle window';

//*** anything else?
end;

procedure TBattleForm.ChangeMapToNoMap(MapName: string);
var
  s: string;
begin
  MapName := Copy(MapName, 1, Length(MapName)-4); // remove '.smf'
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
    TextOut(MapImage.Picture.Bitmap.Width div 2 - TextWidth(s) div 2, MapImage.Picture.Bitmap.Height - TextHeight('X') - 20, s);
  end;
  MapList.ItemIndex := -1;

  SizeLabel.Caption :=  'Size: ? x ?';
  Label2.Caption := 'Tidal strength: ?';
  Label3.Caption := 'Gravity: ?';
  Label4.Caption := 'Max. metal: ?';
  Label5.Caption := 'Extractor radius: ?';
  Label6.Caption := 'Min. wind: ?';
  Label7.Caption := 'Max. wind: ?';
  MapDescLabel.Caption := 'Description: Click on the minimap to attempt to locate map in the "Online maps" list!';
  MapDescLabel.Hint := MapDescLabel.Caption;
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

begin
  Result := False;

  try
    FreeReplayClients; // clear the list

    s := ScriptSL.Text;                                            
    su := UpperCase(s);

    count := 0;
    while True do
    begin
      fstart := Pos('[PLAYER' + IntToStr(count), su);
      if fstart = 0 then Break;
      fstart := PosEx('{', su, fstart);
      if fstart = 0 then raise Exception.Create('Corrupt script file!');
      fstop := PosEx('}', su, fstart);
      if fstop = 0 then raise Exception.Create('Corrupt script file!');

      j := PosEx('NAME=', su, fstart);
      if j = 0 then raise Exception.Create('Corrupt script file!');
      j := j + 5;
      k := PosEx(';', su, j);
      if k = 0 then raise Exception.Create('Corrupt script file!');
      name := Copy(s, j, k-j);

      j := PosEx('SPECTATOR=', su, fstart);
      if (j > 0) and (j < fstop) then
      begin
        j := j + 10;
        k := PosEx(';', su, j);
        if k = 0 then raise Exception.Create('Corrupt script file!');
        spec := not IntToBool(StrToInt(Copy(s, j, k-j)));
      end
      else spec := False; // defaults to False if not mentioned

      j := PosEx('TEAM=', su, fstart);
      if j = 0 then raise Exception.Create('Corrupt script file!');
      j := j + 5;
      k := PosEx(';', su, j);
      if k = 0 then raise Exception.Create('Corrupt script file!');
      team := StrToInt(Copy(s, j, k-j));

      client := TClient.Create(name, 0, 'xx', 0, '');
      client.SetMode(BoolToInt(spec));
      client.SetTeamNo(team);
      client.SetReadyStatus(True);
      BattleReplayInfo.OriginalClients.Add(client);

      Inc(count);
    end;
    if count = 0 then raise Exception.Create('Corrupt script file!');

    count := 0;
    while True do
    begin
      i := Pos('[TEAM' + IntToStr(count), su);
      if i = 0 then Break;

      j := PosEx('ALLYTEAM=', su, i);
      if j = 0 then raise Exception.Create('Corrupt script file!');
      j := j + 9;
      k := PosEx(';', su, j);
      if k = 0 then raise Exception.Create('Corrupt script file!');
      ally := StrToInt(Copy(s, j, k-j));

      j := PosEx('COLOR=', su, i);
      if j = 0 then raise Exception.Create('Corrupt script file!');
      j := j + 6;
      k := PosEx(';', su, j);
      if k = 0 then raise Exception.Create('Corrupt script file!');
      color := StrToInt(Copy(s, j, k-j));

      j := PosEx('SIDE=', su, i);
      if j = 0 then raise Exception.Create('Corrupt script file!');
      j := j + 5;
      k := PosEx(';', su, j);
      if k = 0 then raise Exception.Create('Corrupt script file!');
      SideList.CaseSensitive := False;
      side := SideList.IndexOf(Copy(s, j, k-j));
      if side = -1 then raise Exception.Create('Corrupt script file!');

      j := PosEx('HANDICAP=', su, i);
      if j = 0 then raise Exception.Create('Corrupt script file!');
      j := j + 9;
      k := PosEx(';', su, j);
      if k = 0 then raise Exception.Create('Corrupt script file!');
      handicap := StrToInt(Copy(s, j, k-j));

      for c := 0 to BattleReplayInfo.OriginalClients.Count-1 do
        if TClient(BattleReplayInfo.OriginalClients[c]).GetTeamNo = count then
        begin
          TClient(BattleReplayInfo.OriginalClients[c]).SetAllyNo(ally);
          TClient(BattleReplayInfo.OriginalClients[c]).SetTeamColor(color);
          TClient(BattleReplayInfo.OriginalClients[c]).SetSide(side);
          TClient(BattleReplayInfo.OriginalClients[c]).SetHandicap(handicap);
        end;

      Inc(count);
    end;
    if count = 0 then raise Exception.Create('Corrupt script file!');

    // now let's read various info from script:
    Script := TScript.Create(s);
    try
      try
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
    i := BattleForm.MapList.Items.IndexOf(map);
    if i = -1 then ChangeMapToNoMap(map)
    else
    begin
      j := BattleForm.MapList.ItemIndex;
      BattleForm.MapList.ItemIndex := i;
      if i <> j then BattleForm.MapList.OnClick(nil); // we MUST send nil as parameter, since the event checks if Sender is nil and that way he knows whether user clicked on map list or not
    end;

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

procedure TBattleForm.PopulateMapList;
begin
  Utility.GetMapList(MapList.Items);
end;

procedure TBattleForm.GenerateNormalScriptFile(FileName: string);
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

  PurgedClients: array of // without spectators and with shiftet team and ally numbers. Bots are included too.
  record
    Bot: Boolean; // if this client is a bot
    ClientIndex: Integer;
    TeamNo: Integer;
    AllyNo: Integer;
    TeamColor: Integer;
    Side: Integer;
    Handicap: Integer;
  end;

  TeamToPurgedTeam: array[0..9] of Integer; // TeamToPurgedTeam[IndexOfTeam]: IndexOfPurgedTeam
  AllyToPurgedAlly: array[0..9] of Integer; // AllyToPurgedAlly[IndexOfAllyTeam]: IndexOfPurgedAllyTeam

  // "purging" is needed for one reason: there mustn't be any gaps between team/ally numbers

begin

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
    PurgedClients[tmp].TeamColor := TClient(BattleState.Battle.Clients[i]).GetTeamColor;
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
    PurgedClients[tmp].TeamColor := TBot(BattleState.Battle.Bots[i]).GetTeamColor;
    PurgedClients[tmp].Side := TBot(BattleState.Battle.Bots[i]).GetSide;
    PurgedClients[tmp].Handicap := TBot(BattleState.Battle.Bots[i]).GetHandicap;
    Inc(tmp);
  end;

  // get my player number:
  MyPlayerNum := BattleState.Battle.Clients.IndexOf(MainForm.GetClient(Status.Username));

  // now let's write the script file:

  AssignFile(f, FileName);
  Rewrite(f);
  Writeln(f, '[GAME]');
  Writeln(f, '{');
  Writeln(f, #9 + 'Mapname=' + BattleState.Battle.Map + ';');
  Writeln(f, #9 + 'StartMetal=' + IntToStr(MetalTracker.Value) + ';');
  Writeln(f, #9 + 'StartEnergy=' + IntToStr(EnergyTracker.Value) + ';');
  Writeln(f, #9 + 'MaxUnits=' + IntToStr(UnitsTracker.Value) + ';');
  Writeln(f, #9 + 'StartPosType=' + IntToStr(StartPosRadioGroup.ItemIndex) + ';');
  Writeln(f, #9 + 'GameMode=' + IntToStr(GameEndRadioGroup.ItemIndex) + ';');
  Writeln(f, #9 + 'GameType=' + ModFileName + ';');
  Writeln(f, #9 + 'LimitDGun=' + IntToStr(BoolToInt(LimitDGunCheckBox.Checked)) + ';');
  Writeln(f, #9 + 'DiminishingMMs=' + IntToStr(BoolToInt(DiminishingMMsCheckBox.Checked)) + ';');
  Writeln(f, #9 + 'GhostedBuildings=' + IntToStr(BoolToInt(GhostedBuildingsCheckBox.Checked)) + ';');

  Writeln(f, '');

  if BattleState.Status = Hosting then
  begin
    Writeln(f, #9 + 'HostIP=' + 'localhost' + ';');
    if BattleState.Battle.NATType = 1 then
      Writeln(f, #9 + 'HostPort=' + IntToStr(NATTraversal.MyPrivateUDPSourcePort) + ';')
    else
      Writeln(f, #9 + 'HostPort=' + IntToStr(BattleState.Battle.Port) + ';');
    if LockGameSpeedCheckBox.Checked then
    begin
      Writeln(f, #9 + 'MinSpeed=1;');
      Writeln(f, #9 + 'MaxSpeed=1;');
    end;
  end
  else
  begin
    Writeln(f, #9 + 'HostIP=' + BattleState.Battle.IP + ';');
    Writeln(f, #9 + 'HostPort=' + IntToStr(BattleState.Battle.Port) + ';');
  end;

  if not (BattleState.Status = Hosting) then
    case BattleState.Battle.NATType of
    0: ; // use default (system assigned) port
    1: Writeln(f, #9 + 'SourcePort=' + IntToStr(NATTraversal.MyPrivateUDPSourcePort) + ';');
    2: Writeln(f, #9 + 'SourcePort=' + IntToStr(FIRST_UDP_SOURCEPORT + MyPlayerNum - 1{skip the host}) + ';');
    end; // of case sentence
  Writeln(f, '');
  Writeln(f, #9 + 'MyPlayerNum=' + IntToStr(MyPlayerNum) + ';');
  Writeln(f, '');
  Writeln(f, #9 + 'NumPlayers=' + IntToStr(BattleState.Battle.Clients.Count) + ';');
  Writeln(f, #9 + 'NumTeams=' + IntToStr(NumberOfTeams) + ';');
  Writeln(f, #9 + 'NumAllyTeams=' + IntToStr(NumberOfAllyTeams) + ';');
  Writeln(f, '');
  // players:
  Pos := 0;
  for i := 0 to BattleState.Battle.Clients.Count-1 do
  begin
    Writeln(f, #9 + '[PLAYER' + IntToStr(i) + ']');
    Writeln(f, #9 + '{');
    Writeln(f, #9 + #9 + 'name=' + TClient(BattleState.Battle.Clients[i]).Name + ';');
    if TClient(BattleState.Battle.Clients[i]).GetMode = 0 then
    begin
      Writeln(f, #9 + #9 + 'Spectator=1;');
      Writeln(f, #9 + '}');
    end
    else
    begin
      Writeln(f, #9 + #9 + 'Spectator=0;');
      Writeln(f, #9 + #9 + 'team=' + IntToStr(PurgedClients[Pos].TeamNo) + ';');
      Writeln(f, #9 + '}');
      Inc(Pos);
    end;
  end;
//  for i := 0 to BattleState.Battle.Bots.Count-1 do
//  begin
//    Writeln(f, #9 + '[PLAYER' + IntToStr(i + BattleState.Battle.Clients.Count) + ']');
//    Writeln(f, #9 + '{');
//    Writeln(f, #9 + #9 + 'name=' + TBot(BattleState.Battle.Bots[i]).Name + ';');
//    Writeln(f, #9 + #9 + 'Spectator=0;');
//    Writeln(f, #9 + #9 + 'team=' + IntToStr(PurgedClients[Pos].TeamNo) + ';');
//    Writeln(f, #9 + '}');
//    Inc(Pos);
//  end;
  Writeln(f, '');
  // teams:
  for i := 0 to NumberOfTeams-1 do
  begin
    Writeln(f, #9 + '[TEAM' + IntToStr(i) + ']');
    Writeln(f, #9 + '{');

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
        Writeln(f, #9 + #9 + 'TeamLeader=' + IntToStr(index) + ';');
      end
      else
        Writeln(f, #9 + #9 + 'TeamLeader=' + IntToStr(PurgedClients[j].ClientIndex) + ';');
      Writeln(f, #9 + #9 + 'AllyTeam=' + IntToStr(PurgedClients[j].AllyNo) + ';');
      Writeln(f, #9 + #9 + 'Color=' + IntToStr(PurgedClients[j].TeamColor) + ';');
      Writeln(f, #9 + #9 + 'Side=' + SideList[PurgedClients[j].Side] + ';');
      Writeln(f, #9 + #9 + 'Handicap=' + IntToStr(PurgedClients[j].Handicap) + ';');
      if tmpBool then Writeln(f, #9 + #9 + 'AIDLL=aidll\globalai\' + TBot(BattleState.Battle.Bots[PurgedClients[j].ClientIndex]).AIDll + ';');
      Break;
    end;
    Writeln(f, #9 + '}');
  end;
  // ally teams:
  for i := 0 to NumberOfAllyTeams-1 do
  begin
    Writeln(f, #9 + '[ALLYTEAM' + IntToStr(i) + ']');
    Writeln(f, #9 + '{');
    Writeln(f, #9 + #9 + 'NumAllies=0;'); // this number is not important

    if StartPosRadioGroup.ItemIndex = 2 then
      for j := 0 to High(BattleState.StartRects) do if BattleState.StartRects[j].Enabled then if AllyToPurgedAlly[j] = i then
      begin
        Writeln(f, #9 + #9 + 'StartRectLeft=' + FloatToStr(BattleState.StartRects[j].Rect.Left / MapImage.Width) + ';');
        Writeln(f, #9 + #9 + 'StartRectTop=' + FloatToStr(BattleState.StartRects[j].Rect.Top / MapImage.Height) + ';');
        Writeln(f, #9 + #9 + 'StartRectRight=' + FloatToStr(BattleState.StartRects[j].Rect.Right / MapImage.Width) + ';');
        Writeln(f, #9 + #9 + 'StartRectBottom=' + FloatToStr(BattleState.StartRects[j].Rect.Bottom / MapImage.Height) + ';');
        Break;
      end;

    Writeln(f, #9 + '}');
  end;
  // restrictions:
  Writeln(f, #9 + 'NumRestrictions=' + IntToStr(BattleForm.DisabledUnitsListBox.Items.Count) + ';');
  Writeln(f, #9 + '[RESTRICT]');
  Writeln(f, #9 + '{');
  for i := 0 to BattleForm.DisabledUnitsListBox.Items.Count-1 do
  begin
    Writeln(f, #9 + #9+ 'Unit' + IntToStr(i) + '=' + BattleForm.DisabledUnitsListBox.Items[i] + ';');
    Writeln(f, #9 + #9+ 'Limit' + IntToStr(i) + '=0;');
  end;
  Writeln(f, #9 + '}');
  Writeln(f, '}');  


  Finalize(PurgedClients);

  CloseFile(f);
end;

procedure TBattleForm.GenerateReplayScriptFile(FileName: string);
var
  f: TextFile;
  i: Integer;
  Script: TScript;
  sl: TStringList;
begin
  Script := TScript.Create(BattleReplayInfo.Script.Text);  
  Script.ChangeMyPlayerNum(BattleState.Battle.Clients.IndexOf(MainForm.GetClient(Status.Username)) + BattleReplayInfo.OriginalClients.Count);
  Script.ChangeNumPlayers(BattleState.Battle.Clients.Count + BattleReplayInfo.OriginalClients.Count);
  if BattleState.Status = Hosting then Script.AddLineAfterStart('Demofile=' + BattleReplayInfo.ReplayFilename + ';')
  else Script.AddLineAfterStart('Demofile=multiplayer replay;');

  if BattleState.Status = Hosting then
  begin
    Script.ChangeHostIP('localhost');

    if BattleState.Battle.NATType = 1 then
      Script.ChangeHostPort(IntToStr(NATTraversal.MyPrivateUDPSourcePort))
    else
      Script.ChangeHostPort(IntToStr(BattleState.Battle.Port));

    if LockGameSpeedCheckBox.Checked then
    begin
      { If there is MinSpeed/MaxSpeed already in the old script, let's just skip it. Otherwise add it to the script: }
      if ((not Script.DoesTokenExist('MinSpeed')) and (not Script.DoesTokenExist('MaxSpeed'))) then
      begin
        Script.AddLineAfterStart('MinSpeed=1;');
        Script.AddLineAfterStart('MaxSpeed=1;');
      end;
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
    1: Script.AddLineAfterStart('SourcePort=' + IntToStr(NATTraversal.MyPrivateUDPSourcePort) + ';');
    2: Script.AddLineAfterStart('SourcePort=' + IntToStr(FIRST_UDP_SOURCEPORT + BattleState.Battle.Clients.IndexOf(MainForm.GetClient(Status.Username)) - 1{skip the host}) + ';');
    end; // of case sentence

  for i := 0 to BattleReplayInfo.OriginalClients.Count-1 do Script.AddLineToPlayer(i, 'IsFromDemo=1;');
  for i := 0 to BattleState.Battle.Clients.Count-1 do Script.AddSpectatorAfterAnotherPlayer(BattleReplayInfo.OriginalClients.Count - 1 + i, BattleReplayInfo.OriginalClients.Count + i, TClient(BattleState.Battle.Clients[i]).Name);

  AssignFile(f, FileName);
  Rewrite(f);
  sl := TStringList.Create;
  sl.Text := Script.Script;
  for i := 0 to sl.Count-1 do Writeln(f, sl[i]);
  sl.Free;
  CloseFile(f);
end;

procedure TBattleForm.FormCreate(Sender: TObject);
begin
  Left := 10;
  Top := 10;

  Panel1.Constraints.MinHeight := Panel1.Height;

  InputEdit.Align := alBottom;
  ChatRichEdit.Align := alClient;

  MapImage.Picture.Bitmap.Assign(NoMapImage.Picture.Bitmap);
  PopulateMapList;
  if MapList.Items.Count = 0 then
  begin
    MessageDlg('No maps found! Terminating program ...', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  MapList.ItemIndex := 0;
  MapList.OnClick(MapList); // update selection

  PageControl1.TabIndex := 0;
  ChangeTeamColor(0, False);
  ChangeForceTeamColor(0);

  BattleState.DrawingStartRect := -1;
  BattleState.SelectedStartRect := -1;
  
  ResetBattleScreen;

  if (Screen.Width >= 800) and (Screen.Height >= 600) then
  begin
    BattleForm.Height := 600;
    Panel1.Height := Panel1.Height + 20;
  end;

  ClientsListBox.DoubleBuffered := True;

  History := TStringList.Create;
  HistoryIndex := -1;

  MapPanel.DoubleBuffered := True;

  BattleReplayInfo.Script := TStringList.Create;
  BattleReplayInfo.TempScript := TStringList.Create;
  BattleReplayInfo.OriginalClients := TList.Create;

//  SideComboBox.Items.Assign(SideList);
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

procedure TBattleForm.MapListClick(Sender: TObject);
var
  MapInfo: TMapInfo;
begin
  if MapList.ItemIndex = -1 then Exit; // user does not have the map

  LoadMiniMap(MapList.Items[MapList.ItemIndex], MapImage.Picture.Bitmap);
  MapInfo := AcquireMapInfo(MapList.Items[MapList.ItemIndex]);

  SizeLabel.Caption := 'Size: ' + IntToStr(MapInfo.Width div 64) + ' x ' + IntToStr(MapInfo.Height div 64);

  Label2.Caption := 'Tidal strength: ' + IntToStr(MapInfo.TidalStrength);
  Label3.Caption := 'Gravity: ' + IntToStr(MapInfo.Gravity);
  Label4.Caption := 'Max. metal: ' + Format('%.5g', [MapInfo.Maxmetal]);
  Label5.Caption := 'Extractor radius: ' + IntToStr(MapInfo.ExtractorRadius);
//  Label6.Caption := 'Min. wind: ' + Format('%.5g', [MapInfo.MinWind]);
//  Label7.Caption := 'Max. wind: ' + Format('%.5g', [MapInfo.MaxWind]);
  Label6.Caption := 'Min. wind: ' + IntToStr(MapInfo.MinWind);
  Label7.Caption := 'Max. wind: ' + IntToStr(MapInfo.MaxWind);
  MapDescLabel.Caption := 'Description: ' + MapInfo.Description;
  MapDescLabel.Hint := MapDescLabel.Caption;

  if Sender <> nil then if BattleState.Status = Hosting then // we have to check "Sender <> nil" because we manually trigger this event when server sends new battle info command (with Sender = nil parameter) and we wouldn't want to resend command to server (we would create an endless loop)
    SendBattleInfoToServer;
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

  if MapList.ItemIndex = -1 then
  begin
    MapList.ItemIndex := 0; // select first map in a list if none is currently selected
    MapList.OnClick(nil);
  end;

  HostBattleForm.ShowModal;
end;

procedure TBattleForm.MapImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MapInfo: TMapInfo;
  tmp: Integer;

begin
  if Button <> mbLeft then Exit;

  if MapList.ItemIndex = -1 then // user does not have this map
  begin
    if BattleState.Status = Joined then
    begin
      OnlineMapsForm.Show;
      OnlineMapsForm.ScrollToMap(OnlineMapsForm.DoesOnlineMapExist(BattleState.Battle.Map));
    end;
    Exit;
  end;

  if (MapImage.Cursor = crCross) and (BattleState.Status = Hosting) then
  begin
    tmp := GetFirstMissingStartRect;
    if tmp > 9 then Exit;
    BattleState.DrawingStartRect := tmp;

    AddStartRect(tmp, Rect(X, Y, X, Y));

    Exit; 
  end;

  // open larger minimap:
  MinimapZoomedForm.Image1.Picture.Bitmap.Assign(MapImage.Picture.Bitmap);
  MapInfo := AcquireMapInfo(MapList.Items[MapList.ItemIndex]);
  MinimapZoomedForm.DrawStartPositions(MapInfo);
  MinimapZoomedForm.Caption := 'Minimap (' + MapList.Items[MapList.ItemIndex] + ')';
  MinimapZoomedForm.ShowModal;

end;

procedure TBattleForm.MapImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssShift in Shift then
  begin
    if BattleState.Status = Hosting then
    begin
      MapImage.Cursor := crCross;
    end;
  end
  else MapImage.Cursor := crHandPoint;

  if BattleState.DrawingStartRect <> -1 then
  begin
    ChangeStartRect(BattleState.DrawingStartRect, Rect(BattleState.StartRects[BattleState.DrawingStartRect].Rect.Left, BattleState.StartRects[BattleState.DrawingStartRect].Rect.Top, X, Y));
  end
  else
  begin
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
        MainForm.TryToSendData('ADDSTARTRECT ' + IntToStr(BattleState.DrawingStartRect) + ' ' + IntToStr(Rect.Left) + ' ' + IntToStr(Rect.Top) + ' ' + IntToStr(Rect.Right) + ' ' + IntToStr(Rect.Bottom) + ' ');
    end;


    BattleState.DrawingStartRect := -1;
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
  SetLength(BattleState.StartRects, 10); // there can be 10 ally teams at maximum

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
    if BattleState.SelectedStartRect = (Sender as TPaintBox).Tag then
    begin
      Brush.Color := $00ffeeee; { 0 b g r }
      Pen.Color := clRed;
    end
    else
    begin
      Brush.Color := $00ffdddd; { 0 b g r }
      Pen.Color := clRed;
    end;

    Rectangle((Sender as TPaintBox).ClientRect);

    s := IntToStr((Sender as TPaintBox).Tag + 1);
    Brush.Style := bsClear;
    Font.Style := [fsBold];
    Font.Color := clBlue;
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

  if tmp <> -1 then if BattleState.StartRects[tmp].Enabled then
  begin
    try
      BattleState.StartRects[tmp].PaintBox.Repaint;
    except
    end;
  end;

  if BattleState.SelectedStartRect <> -1 then if BattleState.StartRects[BattleState.SelectedStartRect].Enabled then
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
    MainForm.TryToSendData('REMOVESTARTRECT ' + IntToStr(tmp));
    with BattleState.StartRects[Number] do
      MainForm.TryToSendData('ADDSTARTRECT ' + IntToStr(Number) + ' ' + IntToStr(Rect.Left) + ' ' + IntToStr(Rect.Top) + ' ' + IntToStr(Rect.Right) + ' ' + IntToStr(Rect.Bottom) + ' ');
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
    MainForm.TryToSendData('REMOVESTARTRECT ' + IntToStr(tmp));
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

procedure TBattleForm.DisconnectButtonClick(Sender: TObject);
begin
  if BattleState.Status = None then Exit;

  if BattleState.Status = Joined then
  begin
    MainForm.TryToSendData('LEAVEBATTLE');
    ResetBattleScreen;
  end
  else if BattleState.Status = Hosting then
  begin
    MainForm.TryToSendData('LEAVEBATTLE');
    ResetBattleScreen;
  end;
end;

procedure TBattleForm.ReadyCheckBoxClick(Sender: TObject);
begin
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
  if ReadyCheckBox.Checked then ReadyCheckBox.Font.Color := clGreen else ReadyCheckBox.Font.Color := clRed;
end;

procedure TBattleForm.SideComboBoxChange(Sender: TObject);
begin
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

procedure TBattleForm.TeamComboBoxChange(Sender: TObject);
begin
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

procedure TBattleForm.AllyComboBoxChange(Sender: TObject);
begin
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

procedure TBattleForm.SideComboBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  // this ensures the correct highlite color is used
  (Control as TComboBox).Canvas.FillRect(Rect);

  MainForm.SideImageList.Draw((Control as TComboBox).Canvas, Rect.Left, Rect.Top, Index);
  (Control as TComboBox).Canvas.TextOut(Rect.Left + MainForm.SideImageList.Width + 3, Rect.Top, (Control as TComboBox).Items[Index]);
end;

procedure TBattleForm.SideLabelClick(Sender: TObject);
begin
  SideComboBox.ItemIndex := (SideComboBox.ItemIndex + 1) mod SideList.Count;
  SideComboBox.OnChange(nil);
end;

procedure TBattleForm.MetalTrackerMouseUpAfterChange(Sender: TObject);
begin
  SendBattleDetailsToServer;
end;

procedure TBattleForm.EnergyTrackerMouseUpAfterChange(Sender: TObject);
begin
  SendBattleDetailsToServer;
end;

procedure TBattleForm.UnitsTrackerMouseUpAfterChange(Sender: TObject);
begin
  SendBattleDetailsToServer;
end;

procedure TBattleForm.StartPosRadioGroupClick(Sender: TObject);
begin
  SendBattleDetailsToServer;
end;

procedure TBattleForm.ClientsListBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Pos: Integer;
  s: string;
  NameSpacing: Integer;
  tmpColor: TColor;
  RealIndex: Integer;
  DrawOriginalClient: Boolean;
  DrawNormalClient: Boolean;
  DrawNormalBot: Boolean;
begin
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

  RealIndex := Index;
  DrawOriginalClient := False;
  DrawNormalClient := False;
  DrawNormalBot := False;
  if BattleState.Battle.BattleType = 1 then
  begin
    if (Index < BattleState.Battle.Clients.Count) then
    begin
      DrawNormalClient := True;
      RealIndex := Index;
    end
    else
    begin
      DrawOriginalClient := True;
      RealIndex := Index - BattleState.Battle.Clients.Count;
    end;
  end
  else if BattleState.Battle.BattleType = 0 then
  begin
    if Index <= BattleState.Battle.Clients.Count-1 then
    begin
      DrawNormalClient := True;
      RealIndex := Index;
    end
    else
    begin
      DrawNormalBot := True;
      RealIndex := Index - BattleState.Battle.Clients.Count;
    end;
  end
  else
  begin
    MessageDlg('Critical error: Invalid battle type passed as a parameter. Program will now exit ...', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

  if DrawNormalClient or DrawNormalBot then
  begin
    // this ensures the correct highlite color is used
    (Control as TListBox).Canvas.FillRect(Rect);
  end
  else
  begin
    (Control as TListBox).Canvas.Brush.Color := $00ffdddd; { 0 b g r }
    (Control as TListBox).Canvas.FillRect(Rect);
  end;


  // do the actual drawing:
  Pos := 0;

  if DrawNormalClient then
  begin // draw player's status
    NameSpacing := 74;

    (Control as TListBox).Canvas.Font.Color := clBlack;
    if odSelected in State then (Control as TListBox).Canvas.Font.Color := $00FFDDDD;  // (0, B, G, R)

    // side:
    if TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1 then
      MainForm.SideImageList.Draw((Control as TListBox).Canvas, Rect.Left + Pos, Rect.Top, Min(TClient(BattleState.Battle.Clients[RealIndex]).GetSide, SideList.Count-1));
    Inc(Pos, MainForm.SideImageList.Width);

    // rank:
    MainForm.RanksImageList.Draw((Control as TListBox).Canvas, Rect.Left + Pos, Rect.Top, TClient(BattleState.Battle.Clients[RealIndex]).GetRank);
    Inc(Pos, MainForm.RanksImageList.Width + 3);

    // username:
    s := TClient(BattleState.Battle.Clients[RealIndex]).Name;
    if (Control as TListBox).Canvas.TextWidth(s) > NameSpacing then
    begin
      while (Control as TListBox).Canvas.TextWidth(s + '...') > NameSpacing do s := Copy(s, 1, Length(s)-1);
      s := s + '...';
    end;
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, s);
    Inc(Pos, NameSpacing + 5);

    // team and team color:
    if TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1 then
    begin
      // team color:
      tmpColor := (Control as TListBox).Canvas.Brush.Color;
      (Control as TListBox).Canvas.Brush.Color := TeamColors[TClient(BattleState.Battle.Clients[RealIndex]).GetTeamColor];
      (Control as TListBox).Canvas.Ellipse(Rect.Left + Pos, Rect.Top + 2, Rect.Left + Pos + 10, Rect.Top + 12);
      (Control as TListBox).Canvas.Brush.Color := tmpColor;
      // team no.:
      (Control as TListBox).Canvas.TextOut(Rect.Left + Pos + 13, Rect.Top, IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetTeamNo + 1));
    end;
    Inc(Pos, 40);

    // ally:
    if TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1 then
      (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetAllyNo + 1));
    Inc(Pos, 40);

    // ready:
    if (TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1) or (BattleState.Battle.BattleType = 1) then
      MainForm.ReadyStateImageList.Draw((Control as TListBox).Canvas, Rect.Left + Pos, Rect.Top, BoolToInt(TClient(BattleState.Battle.Clients[RealIndex]).GetReadyStatus));
    Inc(Pos, 50);

    // sync:
    MainForm.SyncImageList.Draw((Control as TListBox).Canvas, Rect.Left + Pos, Rect.Top, TClient(BattleState.Battle.Clients[RealIndex]).GetSync);
    Inc(Pos, 30);

    // cpu:
    if TClient(BattleState.Battle.Clients[RealIndex]).CPU = 0 then s := '? Ghz'
    else s := Trim(Format('%8.1f', [TClient(BattleState.Battle.Clients[RealIndex]).CPU / 1000])) + ' GHz';
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, s);
    Inc(Pos, 50);

    // handicap:
    if TClient(BattleState.Battle.Clients[RealIndex]).GetMode = 1 then
      (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, IntToStr(TClient(BattleState.Battle.Clients[RealIndex]).GetHandicap));
    Inc(Pos, 20);

  end
  else if DrawNormalBot then
  begin // draw bot's status
    NameSpacing := 90;

    (Control as TListBox).Canvas.Font.Color := clGray;

    // side:
    MainForm.SideImageList.Draw((Control as TListBox).Canvas, Rect.Left + Pos, Rect.Top, Min(TBot(BattleState.Battle.Bots[RealIndex]).GetSide, SideList.Count-1));
    Inc(Pos, MainForm.SideImageList.Width + 3);

    // name:
    s := TBot(BattleState.Battle.Bots[RealIndex]).Name;
    if (Control as TListBox).Canvas.TextWidth(s) > NameSpacing then
    begin
      while (Control as TListBox).Canvas.TextWidth(s + '...') > NameSpacing do s := Copy(s, 1, Length(s)-1);
      s := s + '...';
    end;
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, s);
    Inc(Pos, NameSpacing + 5);

    // team color:
    tmpColor := (Control as TListBox).Canvas.Brush.Color;
    (Control as TListBox).Canvas.Brush.Color := TeamColors[TBot(BattleState.Battle.Bots[RealIndex]).GetTeamColor];
    (Control as TListBox).Canvas.Ellipse(Rect.Left + Pos, Rect.Top + 2, Rect.Left + Pos + 10, Rect.Top + 12);
    (Control as TListBox).Canvas.Brush.Color := tmpColor;
    // team no.:
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos + 13, Rect.Top, IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetTeamNo + 1));
    Inc(Pos, 40);

    // ally:
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetAllyNo + 1));
    Inc(Pos, 25);

    // owner:
    s := TBot(BattleState.Battle.Bots[RealIndex]).OwnerName;
    if (Control as TListBox).Canvas.TextWidth(s) > NameSpacing then
    begin
      while (Control as TListBox).Canvas.TextWidth(s + '...') > NameSpacing do s := Copy(s, 1, Length(s)-1);
      s := s + '...';
    end;
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, s);
    Inc(Pos, NameSpacing + 5);

    // AI (dll file name):
    s := TBot(BattleState.Battle.Bots[RealIndex]).AIDll;
    if (Control as TListBox).Canvas.TextWidth(s) > 40 then
    begin
      while (Control as TListBox).Canvas.TextWidth(s + '...') > 40 do s := Copy(s, 1, Length(s)-1);
      s := s + '...';
    end;
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, s);
    Inc(Pos, 45);

    Inc(Pos, 5);

    // handicap:
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, IntToStr(TBot(BattleState.Battle.Bots[RealIndex]).GetHandicap));
    Inc(Pos, 20);

  end
  else if DrawOriginalClient then
  begin // draw original client from replay's script
    NameSpacing := 74;

    (Control as TListBox).Canvas.Font.Color := clBlack;
    if odSelected in State then (Control as TListBox).Canvas.Font.Color := $00CC6666;  // (0, B, G, R)

    // side:
    if TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetMode = 1 then
      MainForm.SideImageList.Draw((Control as TListBox).Canvas, Rect.Left + Pos, Rect.Top, Min(TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetSide, SideList.Count-1));
    Inc(Pos, MainForm.SideImageList.Width);

    // rank:
//    we don't need to draw this
    Inc(Pos, MainForm.RanksImageList.Width + 3);

    // username:
    s := TClient(BattleReplayInfo.OriginalClients[RealIndex]).Name;
    if (Control as TListBox).Canvas.TextWidth(s) > NameSpacing then
    begin
      while (Control as TListBox).Canvas.TextWidth(s + '...') > NameSpacing do s := Copy(s, 1, Length(s)-1);
      s := s + '...';
    end;
    (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, s);
    Inc(Pos, NameSpacing + 5);

    // team and team color:
    if TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetMode = 1 then
    begin
      // team color:
      tmpColor := (Control as TListBox).Canvas.Brush.Color;
      (Control as TListBox).Canvas.Brush.Color := TeamColors[TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetTeamColor];
      (Control as TListBox).Canvas.Ellipse(Rect.Left + Pos, Rect.Top + 2, Rect.Left + Pos + 10, Rect.Top + 12);
      (Control as TListBox).Canvas.Brush.Color := tmpColor;
      // team no.:
      (Control as TListBox).Canvas.TextOut(Rect.Left + Pos + 13, Rect.Top, IntToStr(TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetTeamNo + 1));
    end;
    Inc(Pos, 40);

    // ally:
    if TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetMode = 1 then
      (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, IntToStr(TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetAllyNo + 1));
    Inc(Pos, 40);

    // ready:
//    we don't need to draw this
    Inc(Pos, 50);

    // sync:
//    we don't need to draw this
    Inc(Pos, 30);

    // cpu:
//    we don't need to draw this
    Inc(Pos, 50);

    // handicap:
    if TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetMode = 1 then
      (Control as TListBox).Canvas.TextOut(Rect.Left + Pos, Rect.Top, IntToStr(TClient(BattleReplayInfo.OriginalClients[RealIndex]).GetHandicap));
    Inc(Pos, 20);
  end
  else // error!
  begin
    MessageDlg('Critical error: Invalid draw parameter. Program will now exit ...', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;

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
      MainForm.TryToSendData('MYSTATUS 0'); // let's tell the server we returned from the game

      CloseHandle(BattleState.Process.proc_info.hProcess);
    end
  else
  begin
    AddTextToChat('Back from the game', Colors.Info, 1);
    Status.AmIInGame := False;
    MainForm.TryToSendData('MYSTATUS 0'); // let's tell the server we returned from the game

    TerminateProcess(BattleState.Process.proc_info.hProcess, 0);
    CloseHandle(BattleState.Process.proc_info.hProcess);
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
  s: string;
begin
  if Key = 13 then
  begin
    s := (Sender as TEdit).Text;
    (Sender as TEdit).Text := '';
    if s = '' then Exit;

    History.Add(s);
    HistoryIndex := History.Count-1;

    if (s[1] = '/') or (s[1] = '.') then
    begin
      MainForm.ProcessCommand(Copy(s, 2, Length(s)-1), True);
      Exit;
    end;

    if IsBattleActive then
      MainForm.TryToSendData('SAYBATTLE ' + s);
  end
  else if Key = VK_UP then
  begin
    if History.Count = 0 then Exit;
    HistoryIndex := Max(0, HistoryIndex - 1);
    (Sender as TEdit).Text := History[HistoryIndex];
    (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
    Key := 0;
  end
  else if Key = VK_DOWN then
  begin
    if History.Count = 0 then Exit;
    HistoryIndex := Min(History.Count-1, HistoryIndex + 1);
    (Sender as TEdit).Text := History[HistoryIndex];
    (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
    Key := 0;
  end
  else if Key = VK_ESCAPE then
  begin
    (Sender as TEdit).Text := '';
    Key := 0;
  end;

end;

procedure TBattleForm.SpectateCheckBoxClick(Sender: TObject);
begin
  if not IsBattleActive then Exit;
  SendMyBattleStatusToServer;
end;

procedure TBattleForm.ClientsListBoxDblClick(Sender: TObject);
var
  i: Integer;
  p: TPoint;
  Bot: TBot;
begin
  if not IsBattleActive then Exit; // this should not happen
  GetCursorPos(p);
  i := ClientsListBox.ItemAtPos(ClientsListBox.ScreenToClient(p), True);
  if i = -1 then Exit;

  if BattleState.Battle.BattleType = 0 then
  begin
    if not (i <= BattleState.Battle.Clients.Count-1) then
    begin // double-clicked on bot
      Bot := BattleState.Battle.Bots[i - BattleState.Battle.Clients.Count];
      if (Bot.OwnerName = Status.Username) or (BattleState.Status = Hosting) then
      UpdateBotForm.ShowModalEx(Bot);
    end
    else
    begin // double-clicked on player
      MainForm.OpenPrivateChat(TClient(BattleState.Battle.Clients[i]).Name);
    end;
  end else if BattleState.Battle.BattleType = 1 then
  begin
    if i < BattleState.Battle.Clients.Count then MainForm.OpenPrivateChat(TClient(BattleState.Battle.Clients[i]).Name);
  end;

end;

procedure TBattleForm.GameEndRadioGroupClick(Sender: TObject);
begin
  SendBattleDetailsToServer;
end;

procedure TBattleForm.HandicapTrackerMouseUpAfterChange(Sender: TObject);
begin
  if (IsBattleActive) and (BattleState.Status = Hosting) and (ClientsListBox.ItemIndex <> -1) and (ClientsListBox.ItemIndex <= BattleState.Battle.Clients.Count-1) then
  begin
    MainForm.TryToSendData('HANDICAP ' + TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).Name + ' ' + IntToStr(HandicapTracker.Value));
  end;
end;

procedure TBattleForm.ClientsListBoxClick(Sender: TObject);
begin
  if (BattleState.Status = Hosting) and (ClientsListBox.ItemIndex <> -1)
  and (ClientsListBox.ItemIndex <= BattleState.Battle.Clients.Count-1)
  and (TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).GetMode = 1) then
  begin
    HandicapTracker.Value := TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).GetHandicap;
    ForceTeamComboBox.ItemIndex := TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).GetTeamNo;
    ForceAllyComboBox.ItemIndex := TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).GetAllyNo;
    ChangeForceTeamColor(TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).GetTeamColor);
    EnableControlAndChildren(PlayerControlGroupBox);
  end
  else
  begin
    DisableControlAndChildren(PlayerControlGroupBox);
  end;
end;

{ if UpdateServer=True, then we notify server about new team color }
procedure TBattleForm.ChangeTeamColor(ColorIndex: Integer; UpdateServer: Boolean);
begin
  MyTeamColorIndex := ColorIndex;

  with TeamColorSpeedButton.Glyph.Canvas do
  begin
    Pen.Color := TeamColors[MyTeamColorIndex];
    Brush.Color := TeamColors[MyTeamColorIndex];
    Rectangle(0+1, 0+1, TeamColorSpeedButton.Glyph.Width-2, TeamColorSpeedButton.Glyph.Height-2);
  end;

  if UpdateServer then SendMyBattleStatusToServer;
end;

procedure TBattleForm.ChangeForceTeamColor(ColorIndex: Integer);
begin
  with ForceTeamColorButton.Glyph.Canvas do
  begin
    Pen.Color := TeamColors[ColorIndex];
    Brush.Color := TeamColors[ColorIndex];
    Rectangle(0+1, 0+1, ForceTeamColorButton.Glyph.Width-2, ForceTeamColorButton.Glyph.Height-2);
  end;
end;

procedure TBattleForm.TeamColorSpeedButtonClick(Sender: TObject);
var
  ColorIndex: Integer;
begin
  ColorIndex := ChooseColorDialog(Sender as TControl, MyTeamColorIndex);
  if ColorIndex = -1 then Exit;

  ChangeTeamColor(ColorIndex, True);
end;

procedure TBattleForm.SpeedButton1Click(Sender: TObject);
begin
  if (IsBattleActive) and (BattleState.Status = Hosting) and (ClientsListBox.ItemIndex <> -1) and (ClientsListBox.ItemIndex <= BattleState.Battle.Clients.Count-1) then
  begin
    MainForm.TryToSendData('KICKFROMBATTLE ' + TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).Name);
  end;
end;

procedure TBattleForm.ForceTeamComboBoxClick(Sender: TObject);
begin
  MainForm.TryToSendData('FORCETEAMNO ' + TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).Name + ' ' + IntToStr(ForceTeamComboBox.ItemIndex));
  AddTextToChat('Forcing ' + TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).Name + '''s team number ...', Colors.Info, 1);
end;

procedure TBattleForm.ForceAllyComboBoxClick(Sender: TObject);
begin
  MainForm.TryToSendData('FORCEALLYNO ' + TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).Name + ' ' + IntToStr(ForceAllyComboBox.ItemIndex));
  AddTextToChat('Forcing ' + TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).Name + '''s ally number ...', Colors.Info, 1);
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
  MainForm.TryToSendData('ENABLEALLUNITS');
  if DisabledUnitsListBox.Items.Count > 0 then
  begin
    s := 'DISABLEUNITS';
    for i := 0 to DisabledUnitsListBox.Items.Count-1 do
      s := s + ' ' + DisabledUnitsListBox.Items[i];
    MainForm.TryToSendData(s);
  end;
end;

procedure TBattleForm.Item1Click(Sender: TObject);
begin
  ReloadMapListButton.OnClick(ReloadMapListButton);
end;

procedure TBattleForm.AddBotButtonClick(Sender: TObject);
begin
  AddBotForm.ShowModal;
end;

procedure TBattleForm.ReloadMapListButtonClick(Sender: TObject);
var
  i: Integer;
begin
  if BattleState.Status = Hosting then
  begin
    Utility.ReInitLibWithDialog;
    Utility.GetMapList(MapList.Items);
    MapList.ItemIndex := 0;
    MapList.OnClick(MapList); // to update selection
  end
  else if BattleState.Status = Joined then
  begin
    Utility.ReInitLibWithDialog;
    Utility.GetMapList(MapList.Items);

    i := BattleForm.MapList.Items.IndexOf(BattleState.Battle.Map);
    if i = -1 then ChangeMapToNoMap(BattleState.Battle.Map)
    else
    begin
      BattleForm.MapList.ItemIndex := i;
      BattleForm.MapList.OnClick(nil); // we MUST send nil as parameter .. see MapList.OnClick event implementation
    end;
  end
  else
  begin // just reinit and reload
    Utility.ReInitLibWithDialog;
    Utility.GetMapList(MapList.Items);
    MapList.ItemIndex := 0;
    MapList.OnClick(nil);
  end;

  MainForm.VDTBattles.Invalidate;
end;

procedure TBattleForm.ForceTeamColorButtonClick(Sender: TObject);
var
  ColorIndex: Integer;
begin
  ColorIndex := ChooseColorDialog(ForceTeamColorButton, TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).GetTeamColor);
  if ColorIndex = -1 then Exit;

  ChangeForceTeamColor(ColorIndex);
  MainForm.TryToSendData('FORCETEAMCOLOR ' + TClient(BattleState.Battle.Clients[ClientsListBox.ItemIndex]).Name + ' ' + IntToStr(ColorIndex));
end;

procedure TBattleForm.Label20Click(Sender: TObject);
begin
  ShellExecute(MainForm.Handle, nil, MODS_PAGE_LINK, '', '', SW_SHOW);
end;

procedure TBattleForm.Label13Click(Sender: TObject);
begin
  OnlineMapsForm.Show;
end;

procedure TBattleForm.ChatRichEditURLClick(Sender: TObject;
  const URL: String);
begin
  ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TBattleForm.LimitDGunCheckBoxClick(Sender: TObject);
begin
  SendBattleDetailsToServer;
end;

procedure TBattleForm.DiminishingMMsCheckBoxClick(Sender: TObject);
begin
  SendBattleDetailsToServer;
end;                        

procedure TBattleForm.LockedCheckBoxClick(Sender: TObject);
begin
  if LockedCheckBox.Checked then LockedCheckBox.Font.Color := clRed else LockedCheckBox.Font.Color := clGreen;

  if BattleState.Status <> Hosting then Exit; // happens when we programatically change Changed property (for example when we try to host new battle)

  SendBattleInfoToServer;
end;

procedure TBattleForm.FormShow(Sender: TObject);
begin
  InputEdit.SetFocus;
end;

procedure TBattleForm.GhostedBuildingsCheckBoxClick(Sender: TObject);
begin
  SendBattleDetailsToServer;
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

procedure TBattleForm.TBXColorSet1GetColorInfo(Sender: TTBXCustomColorSet;
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
  Item := ColorPopupMenu.PopupEx(Rect(p.X, p.Y, p.X, p.Y), False);

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

end.
