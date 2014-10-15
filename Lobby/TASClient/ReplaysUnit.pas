{
  Demo grades:

  0 - unrated/unknown
  1 - 10 = grade

  or:

  A) Unrated (0)
  B) Nothing special (1-4)
  C) Instructive (5-8)
  D) A must-see (9-10)

}

unit ReplaysUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, ExtCtrls, Math, SpTBXControls,
  TntStdCtrls, SpTBXEditors, SpTBXTabs, TB2Item, SpTBXItem, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,MainUnit,DateUtils,
  VirtualTrees,Utility, Mask, JvExMask, JvSpin,  IniFiles,MapListFormUnit,
  Menus, RegExpr, SpTBXDkPanels,SpTBXSkins, RSChartPanel, CheckLst,
  TntCheckLst,RSCharts;

type
  TReplaysForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    LoadingPanel: TSpTBXPanel;
    LoadingLabel: TSpTBXLabel;
    VDTReplays: TVirtualDrawTree;
    SpTBXSplitter1: TSpTBXSplitter;
    ReplayListPopupMenu: TSpTBXPopupMenu;
    BottomPanel: TSpTBXPanel;
    PageControl1: TSpTBXTabControl;
    PlayersTab: TSpTBXTabItem;
    SpTBXTabItem3: TSpTBXTabItem;
    CommentsTab: TSpTBXTabItem;
    SpTBXTabItem1: TSpTBXTabItem;
    SpTBXTabSheet2: TSpTBXTabSheet;
    CommentsRichEdit: TRichEdit;
    SpTBXTabSheet4: TSpTBXTabSheet;
    frmGameOptions: TSpTBXGroupBox;
    lblStartPos: TSpTBXLabel;
    lblGameEnd: TSpTBXLabel;
    lblMetal: TSpTBXLabel;
    lblEnergy: TSpTBXLabel;
    lblMaxUnits: TSpTBXLabel;
    chkLimiteDGun: TSpTBXCheckBox;
    chkGhosted: TSpTBXCheckBox;
    chkDiminishing: TSpTBXCheckBox;
    SpTBXLabel2: TSpTBXLabel;
    SpTBXLabel3: TSpTBXLabel;
    SpTBXLabel4: TSpTBXLabel;
    frmDisabledUnits: TSpTBXGroupBox;
    lstDisabledUnits: TSpTBXListBox;
    SpTBXGroupBox1: TSpTBXGroupBox;
    lstLuaOptions: TSpTBXListBox;
    SpTBXTabSheet1: TSpTBXTabSheet;
    ScriptRichEdit: TRichEdit;
    SpTBXTabSheet3: TSpTBXTabSheet;
    VDTPlayers: TVirtualDrawTree;
    WatchButton: TSpTBXButton;
    CloseButton: TSpTBXButton;
    GradeComboBox: TSpTBXComboBox;
    SpTBXLabel1: TSpTBXLabel;
    DownloadButton: TSpTBXButton;
    UploadButton: TSpTBXButton;
    DeleteAllVisibleButton: TSpTBXButton;
    DeleteButton: TSpTBXSpeedButton;
    SaveButton: TSpTBXSpeedButton;
    RenameButton: TSpTBXSpeedButton;
    ReloadButton: TSpTBXSpeedButton;
    HostReplayButton: TSpTBXButton;
    PanelTop: TSpTBXPanel;
    FiltersTabs: TSpTBXTabControl;
    FiltersTab: TSpTBXTabItem;
    PresetsTab: TSpTBXTabItem;
    SpTBXTabSheet6: TSpTBXTabSheet;
    SpTBXGroupBox2: TSpTBXGroupBox;
    btDeletePreset: TSpTBXButton;
    btSavePreset: TSpTBXButton;
    PresetNameTextbox: TSpTBXEdit;
    btClearPreset: TSpTBXButton;
    SpTBXLabel5: TSpTBXLabel;
    PresetListbox: TSpTBXListBox;
    SpTBXTabSheet5: TSpTBXTabSheet;
    SpTBXGroupBox4: TSpTBXGroupBox;
    chkFilterGameContinues: TSpTBXCheckBox;
    chkFilterComEnd: TSpTBXCheckBox;
    chkFilterLineage: TSpTBXCheckBox;
    SpTBXPanel1: TSpTBXPanel;
    chkFilterLimitDGunFilter: TSpTBXCheckBox;
    chkFilterGhostedFilter: TSpTBXCheckBox;
    chkFilterDiminishingFilter: TSpTBXCheckBox;
    chkFilterGhosted: TSpTBXCheckBox;
    chkFilterLimitDGun: TSpTBXCheckBox;
    chkFilterDiminishing: TSpTBXCheckBox;
    SpTBXGroupBox5: TSpTBXGroupBox;
    chkFilterMetal: TSpTBXCheckBox;
    chkFilterEnergy: TSpTBXCheckBox;
    chkFilterUnits: TSpTBXCheckBox;
    btFilterUnits: TSpTBXButton;
    btFilterEnergy: TSpTBXButton;
    btFilterMetal: TSpTBXButton;
    chkFilterPlayers: TSpTBXCheckBox;
    btFilterPlayers: TSpTBXButton;
    chkFilterLength: TSpTBXCheckBox;
    btFilterLength: TSpTBXButton;
    btFilterFileSize: TSpTBXButton;
    chkFilterFileSize: TSpTBXCheckBox;
    chkFilterGrade: TSpTBXCheckBox;
    btFilterGrade: TSpTBXButton;
    SpTBXGroupBox3: TSpTBXGroupBox;
    chkFilterFixed: TSpTBXCheckBox;
    chkFilterRandom: TSpTBXCheckBox;
    chkFilterChooseInGame: TSpTBXCheckBox;
    SpTBXPanel2: TSpTBXPanel;
    FilterListCombo: TSpTBXComboBox;
    ContainsRadio: TSpTBXRadioButton;
    DoNotContainsRadio: TSpTBXRadioButton;
    FilterValueTextBox: TSpTBXEdit;
    AddToFilterListButton: TSpTBXButton;
    RemoveFromFilterListButton: TSpTBXButton;
    ClearFilterListButton: TSpTBXButton;
    FilterList: TVirtualStringTree;
    speFilterMetal: TSpTBXSpinEdit;
    speFilterEnergy: TSpTBXSpinEdit;
    speFilterUnits: TSpTBXSpinEdit;
    speFilterPlayers: TSpTBXSpinEdit;
    speFilterLength: TSpTBXSpinEdit;
    speFilterFileSize: TSpTBXSpinEdit;
    speFilterGrade: TSpTBXSpinEdit;
    EnableFiltersPanel: TSpTBXPanel;
    chkEnableFilters: TSpTBXCheckBox;
    FiltersButton: TSpTBXButton;
    SpacerPanel2: TSpTBXPanel;
    SpacerPanel1: TSpTBXPanel;
    GraphsTab: TSpTBXTabItem;
    SpTBXTabSheet7: TSpTBXTabSheet;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    rscTSGChart: TRSChartPanel;
    pnlTSGOptions: TSpTBXPanel;
    gbTSGLine: TSpTBXGroupBox;
    cmbTSGEnableLine: TSpTBXCheckBox;
    lstTSGLineStat: TSpTBXListBox;
    gbTSGDashed: TSpTBXGroupBox;
    cmbTSGEnableDashed: TSpTBXCheckBox;
    lstTSGDashedStat: TSpTBXListBox;
    gbTSGPlayers: TSpTBXGroupBox;
    lstTSGPlayers: TSpTBXCheckListBox;
    btTSGCollapse: TSpTBXButton;
    sptTSGOptions: TSpTBXSplitter;
    SpTBXPanel4: TSpTBXPanel;
    btTSGAll: TSpTBXButton;
    btTSGNone: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReloadButtonClick(Sender: TObject);
    procedure WatchButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure CommentsRichEditChange(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ReplaysListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure GradeComboBoxChange(Sender: TObject);
    procedure HostReplayButtonClick(Sender: TObject);
    procedure RenameButtonClick(Sender: TObject);
    procedure ReplaysListBoxDblClick(Sender: TObject);
    procedure LoadingPanelResize(Sender: TObject);
    procedure DownloadButtonClick(Sender: TObject);
    procedure UploadButtonClick(Sender: TObject);
    function GetReplayFromNode(Node: PVirtualNode): TReplay;
    function GetReplayFromFileName(fName: String): TReplay;
    function GetReplayPlayerFromNode(Node: PVirtualNode): TReplayPlayer;
    procedure VDTReplaysDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure VDTReplaysCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VDTReplaysHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
    procedure InitVDTForRefresh;
    procedure TerminateVDTRefresh;
    procedure VDTReplaysClick(Sender: TObject);overload;
    procedure VDTPlayersDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure VDTPlayersCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VDTPlayersHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
    procedure chkEnableFiltersClick(Sender: TObject);
    procedure FiltersButtonClick(Sender: TObject);
    procedure FilterListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure chkFilterGameContinuesClick(Sender: TObject);
    procedure chkFilterComEndClick(Sender: TObject);
    procedure chkFilterLineageClick(Sender: TObject);
    procedure chkFilterLimitDGunFilterClick(Sender: TObject);
    procedure chkFilterGhostedFilterClick(Sender: TObject);
    procedure chkFilterDiminishingFilterClick(Sender: TObject);
    procedure chkFilterLimitDGunClick(Sender: TObject);
    procedure chkFilterGhostedClick(Sender: TObject);
    procedure chkFilterDiminishingClick(Sender: TObject);
    procedure chkFilterMetalClick(Sender: TObject);
    procedure chkFilterEnergyClick(Sender: TObject);
    procedure chkFilterUnitsClick(Sender: TObject);
    procedure chkFilterPlayersClick(Sender: TObject);
    procedure chkFilterLengthClick(Sender: TObject);
    procedure chkFilterFileSizeClick(Sender: TObject);
    procedure chkFilterGradeClick(Sender: TObject);
    procedure chkFilterFixedClick(Sender: TObject);
    procedure chkFilterRandomClick(Sender: TObject);
    procedure chkFilterChooseInGameClick(Sender: TObject);
    procedure btFilterMetalClick(Sender: TObject);
    procedure btFilterEnergyClick(Sender: TObject);
    procedure btFilterUnitsClick(Sender: TObject);
    procedure btFilterPlayersClick(Sender: TObject);
    procedure btFilterLengthClick(Sender: TObject);
    procedure btFilterFileSizeClick(Sender: TObject);
    procedure btFilterGradeClick(Sender: TObject);
    procedure speFilterMetalChange(Sender: TObject);
    procedure speFilterEnergyChange(Sender: TObject);
    procedure speFilterUnitsChange(Sender: TObject);
    procedure speFilterPlayersChange(Sender: TObject);
    procedure speFilterLengthChange(Sender: TObject);
    procedure speFilterFileSizeChange(Sender: TObject);
    procedure speFilterGradeChange(Sender: TObject);
    procedure AddToFilterListButtonClick(Sender: TObject);
    procedure RemoveFromFilterListButtonClick(Sender: TObject);
    procedure ClearFilterListButtonClick(Sender: TObject);
    procedure FilterListChecking(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure VDTReplaysColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure VDTReplaysKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FilterListCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FilterListHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
    procedure VDTReplaysGetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure VDTReplaysDrawHint(Sender: TBaseVirtualTree;
      HintCanvas: TCanvas; Node: PVirtualNode; R: TRect;
      Column: TColumnIndex);
    procedure DeleteAllVisibleButtonClick(Sender: TObject);
    procedure btSavePresetClick(Sender: TObject);
    procedure btClearPresetClick(Sender: TObject);
    procedure PresetListboxDblClick(Sender: TObject);
    procedure PresetListboxClick(Sender: TObject);
    procedure FilterListEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure FilterListClick(Sender: TObject);
    procedure FilterListNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure btDeletePresetClick(Sender: TObject);
    procedure FilterListHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure VDTReplaysHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure VDTPlayersHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure FilterListDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: WideString; const CellRect: TRect;
      var DefaultDraw: Boolean);
    procedure FilterListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure FormShow(Sender: TObject);
    procedure rscTSGChartDblClick(Sender: TObject);
    procedure lstTSGLineStatClick(Sender: TObject);
    procedure lstTSGDashedStatClick(Sender: TObject);
    procedure cmbTSGEnableLineClick(Sender: TObject);
    procedure cmbTSGEnableDashedClick(Sender: TObject);
    procedure lstTSGPlayersDrawItem(Sender: TObject; ACanvas: TCanvas;
      var ARect: TRect; Index: Integer; const State: TOwnerDrawState;
      const PaintStage: TSpTBXPaintStage; var PaintDefault: Boolean);
    procedure btTSGNoneClick(Sender: TObject);
    procedure btTSGAllClick(Sender: TObject);
    procedure lstTSGPlayersClick(Sender: TObject);
    procedure btTSGCollapseClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FTeamLineCharts: TList;

    function GetValueFromStats( var stats: TTeamStatistics; var listBox: TSpTBXListBox ): double;
    procedure UpdateTeamStatsGraph;
  public
    procedure VDTReplaysClick;overload;
    function isReplayVisible(Replay: TReplay):boolean;
    procedure FilterReplayList;
    procedure LoadReplayFiltersFromFile(inputFileName : string);
    procedure UpdateReplayFilters;
    procedure SaveReplayFiltersToFile(outputFileName : string);
    function GetReplayFilterIndexFromNode(Node : PVirtualNode): integer;
    procedure LoadReplayFiltersPresets;
    procedure initFiltersPresets;
    procedure FiltersUpdated;
     procedure EnumerateReplayList;
    function ReadReplay(fileName: string): TReplay;
    function ReadScriptFromDemo(DemoFileName: string; var Script: string): Boolean;
    function ReadScriptFromDemo2(var replay: TReplay; var Script: string): Boolean;
    procedure ReadWinningTeamsFromDemo(var replay: TReplay);
    function FillPlayersInReplay(var replay: TReplay):boolean;
    function ReadHeaderFromDemo2(var replay: TReplay): Boolean;
    function LoadReplay(Replay: TReplay): Boolean;
    procedure SaveCommentsToScript(var Script: TScript; Comments: TStrings; Grade: Byte);
    procedure ReadCommentsFromScript(Script: TScript; Comments: TStrings; var Grade: Byte);
    function ChangeScriptInDemo(DemoFileName, Script: string): Boolean;
    function ChangeScriptInDemo2(DemoFileName, Script: string): Boolean;
    function ReadGradeFromScript(Script: string): Byte;
    function ValidateComments(Comments: TStrings): Boolean;
    function ReadTeamStats(var replay: TReplay ): Boolean;
  end;

  // this thread is used to load replays info from disk on application start
  TReadReplaysThrd = class(TThread)
  private
  protected
    procedure Execute; override;
  public
  end;

var
  ReplaysForm: TReplaysForm;
  WasLastLoadSuccessful: Boolean = False; // True only if last loading of the replay was successful. If it is False, that means we don't have a replay displayed at all (since the last load failed), and True if we have it loaded.
  LoadingReplay: Boolean = False; // is True while LoadReplay method is loading a replay

  Filters:
  record
    GameContinues: Boolean;
    ComEnd: Boolean;
    Lineage: Boolean;
    FilterLimitDGun: Boolean;
    LimitDGun: Boolean;
    FilterGhosted: Boolean;
    Ghosted: Boolean;
    FilterDiminishing: Boolean;
    Diminishing: Boolean;
    Fixed: Boolean;
    Random: Boolean;
    ChooseInGame: Boolean;
    Metal: TFilterNumber;
    Energy: TFilterNumber;
    Units: TFilterNumber;
    Players: TFilterNumber;
    Length: TFilterNumber;
    FileSize: TFilterNumber;
    Grade: TFilterNumber;
    TextFilters: TList;
  end;

implementation

uses  StrUtils, ShellAPI, BattleFormUnit, Misc, PreferencesFormUnit,
  InitWaitFormUnit,MsMultiPartFormData, ProgressBarWindow,
  UploadReplayUnit, LobbyScriptUnit, TipsFormUnit, gnugettext,
  SpringSettingsProfileFormUnit, SpringDownloaderFormUnit,
  HostBattleFormUnit;

{$R *.dfm}

procedure TReplaysForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopwindow;
  end;
end;

{ TReadReplaysThread }

procedure TReadReplaysThrd.Execute;
var
  StartTime: Cardinal;

begin
  FreeOnTerminate := True; // when Execute method finishes, thread should be freed
  StartTime := GetTickCount;
  Priority := tpLowest;

  try
    Synchronize(ReplaysForm.InitVDTForRefresh);
    ReplaysForm.EnumerateReplayList;
    Synchronize(ReplaysForm.TerminateVDTRefresh);
    Synchronize(ReplaysForm.VDTReplays.Refresh);
    ReplaysForm.ReloadButton.Enabled := True;
  finally
//***    MainForm.AddMainLog(IntToStr(GetTickCount - StartTime) + ' ms taken to reload replays!', Colors.Info);
  end;

end;

function TReplaysForm.ReadReplay(fileName: string): TReplay;
var
  rep: TReplay;
  st: string;
  s: TScript;
  dateFormat: TFormatSettings;
  tmp:String;
  i,j: integer;
  replayPlayer: PReplayPlayer;
begin
  // old replay date format '2007-11-4 16:15: 4 GMT'
  dateFormat.DateSeparator := '-';
  dateFormat.TimeSeparator := ':';
  dateFormat.ShortDateFormat := 'yyyy-mm-d hh:nn:ss';

  Result := nil;

  if not FileExists(fileName) then Exit;

  rep := TReplay.Create;
  rep.FileName := ExtractFileName(fileName);
  rep.FullFileName := fileName;
  rep.Version := 0;

  if ReplaysForm.ReadScriptFromDemo(fileName, st) then // super old replay format
  begin
    rep.SpringVersion := s.ReadKeyValue('VERSION/GameVersion');
    tmp := s.ReadKeyValue('VERSION/unixtime');
    if tmp <> '' then
      rep.Date := UnixToDateTime(StrToInt64(tmp))
    else
      rep.Date := StrToDateTime(s.ReadKeyValue('VERSION/DateTime'),dateFormat);
  end
  else // new replay format
  begin
    ReadHeaderFromDemo2(rep);
    rep.Date := UnixToDateTime(rep.demoHeader.unixTime);
    rep.SpringVersion := StringReplace(rep.demoHeader.versionString,'spring','',[rfReplaceAll,rfIgnoreCase]);

    if not ReplaysForm.ReadScriptFromDemo2(rep, st) then
    begin
      rep.Free;
      Exit;
    end;

    ReadWinningTeamsFromDemo( rep );

    rep.Version := 1;
  end;

  s := TScript.Create(st);
  rep.Script := s;
  rep.Grade := ReplaysForm.ReadGradeFromScript(st);

  if ((rep.Version = 0) or ((rep.Version = 1) and (rep.demoHeader.magic = 'spring demofile'))) and FillPlayersInReplay(rep) then
  begin
    // create teams
    for i:=0 to rep.PlayerList.Count-1 do
    begin
      replayPlayer := PReplayPlayer(rep.PlayerList.Items[i]);
      if NOT replayPlayer.Spectator then
        rep.GetTeam( replayPlayer.Id ).PlayerList.Add( replayPlayer );
    end;

    rep.TeamStatsAvailable := ReadTeamStats(rep);

    Result := rep;
  end
  else
    rep.Free;
end;

procedure TReplaysForm.EnumerateReplayList;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  rep: TReplay;
  i: integer;
  demoPathList: TStringList;
begin
  for i:=0 to ReplayList.Count-1 do
    try
      TReplay(ReplayList[i]).Free;
    except
      //
    end;
  ReplayList.Clear;
  VDTReplays.Clear;

  FileAttrs := faAnyFile;

  demoPathList := TStringList.Create;
  demoPathList.Add(GetMyDocuments+'\My Games\Spring\');
  demoPathList.Add(ExtractFilePath(Application.ExeName));

  for i:=0 to demoPathList.Count-1 do
    if FindFirst(demoPathList[i] + 'demos\*.sdf', FileAttrs, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          rep := ReadReplay(demoPathList[i] + 'demos\' + sr.Name);

          if rep <> nil then
          begin
            ReplayList.Add(rep);
            if isReplayVisible(rep) then
            begin
              VDTReplays.RootNodeCount := VDTReplays.RootNodeCount +1;
              rep.Node := VDTReplays.GetLast;
            end;
          end;
        end
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
end;

function TReplaysForm.ValidateComments(Comments: TStrings): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to Comments.Count-1 do if Pos(';', Comments[i]) <> 0 then
  begin
    MessageDlg(_('Invalid character found in comments: ";". Please remove any ";" from the comments before saving them!'), mtWarning, [mbOK], 0);
    Exit
  end;

  Result := True;
end;

procedure TReplaysForm.SaveCommentsToScript(var Script: TScript; Comments: TStrings; Grade: Byte);
var
  i: Integer;
begin
  Script.RemoveKey('COMMENTS');
  for i:=0 to Comments.Count -1 do
    Script.AddOrChangeKeyValue('COMMENTS/LINE'+IntToStr(i+1),Comments[i]);

  Script.AddOrChangeKeyValue('COMMENTS/GRADE',IntToStr(Grade));
end;

procedure TReplaysForm.ReadCommentsFromScript(Script: TScript; Comments: TStrings; var Grade: Byte);
var
  count: Integer;
  tmp: String;
begin
  Grade := 0;

  count := 1;
  while True do
  begin
    tmp := Script.ReadKeyValue('COMMENTS/LINE'+IntToStr(count));
    if tmp = '' then break;
    Comments.Add(tmp);
    Inc(count);
  end;

  tmp := Script.ReadKeyValue('COMMENTS/GRADE');
  if tmp <> '' then
    Grade := StrToInt(tmp);

end;

// returns True if successful
function TReplaysForm.ChangeScriptInDemo(DemoFileName, Script: string): Boolean;
var
  f1, f2: TFileStream;
  i: Integer;
  FileName: string;
  b: Byte;
  s: string;
  Size: Integer;
begin

  Result := False;

  f1 := nil;
  f2 := nil;
  try
    f1 := TFileStream.Create(DemoFileName, fmOpenReadWrite);

    i := 0;
    FileName := ExtractFilePath(Application.ExeName) + 'temp' + IntToStr(i) + '.dat';
    while FileExists(FileName) do
    begin
      Inc(i);
      FileName := ExtractFilePath(Application.ExeName) + 'temp' + IntToStr(i) + '.dat';
    end;
    f2 := TFileStream.Create(FileName, fmCreate);

    f1.Read(b, 1);
    f2.Write(b, 1);

    // skip script:
    f1.Read(i, 4);
    SetLength(s, i);
    f1.Read(s[1], i);

    // write script:
    i := Length(Script);
    f2.Write(i, 4);
    f2.Write(Script[1], Length(Script));

    // read the rest:
    Size := f1.Size - f1.Position;
    SetLength(s, Size);
    f1.Read(s[1], Size);

    // write the rest:
    f2.Write(s[1], Size);

    // now let's overwrite source file with temp file:
    f1.Position := 0;
    f1.Size := 0;
    f2.Position := 0;
    SetLength(s, f2.Size);
    f2.Read(s[1], Length(s));
    f1.Write(s[1], Length(s));

    f1.Free;
    f2.Free;
    DeleteFile(FileName);
  except
    try
      if f1 <> nil then f1.Free;
      if f2 <> nil then f1.Free;
    except
    end;
    Exit;
  end;

  Result := True;
end;

// returns True if successful, handle the new demo files
function TReplaysForm.ChangeScriptInDemo2(DemoFileName, Script: string): Boolean;
var
  f1, f2: TFileStream;
  i: Integer;
  FileName: string;
  s: string;
  Size: Integer;
  scriptPos: integer;
  scriptLength: integer;
begin

  Result := False;

  f1 := nil;
  f2 := nil;
  try
    f1 := TFileStream.Create(DemoFileName, fmOpenReadWrite);

    FileName := ExtractFilePath(Application.ExeName) + 'temp' + IntToStr(i) + '.dat';
    while FileExists(FileName) do
    begin
      Inc(i);
      FileName := ExtractFilePath(Application.ExeName) + 'temp' + IntToStr(i) + '.dat';
    end;
    f2 := TFileStream.Create(FileName, fmCreate);

    // read the header size = script pos
    f1.Position := 20;
    f1.Read(scriptPos,4);
    f1.Position := 0;

    // read/write the first part header:
    SetLength(s, 304);
    f1.Read(s[1], 304);
    f2.Write(s[1], Length(s));

    // read/write the script size
    f1.Read(scriptLength,4);
    i := Length(Script);
    f2.Write(i,4);

    // read/write the snd part of the header
    Size := scriptPos - f1.Position;
    SetLength(s, Size);
    f1.Read(s[1], Size);
    f2.Write(s[1], Length(s));

    // skip the script
    f1.Position := scriptPos+scriptLength;

    // write script:
    i := Length(Script);
    f2.Write(Script[1], Length(Script));

    // read/write the rest
    Size := f1.Size - f1.Position;
    SetLength(s, Size);
    f1.Read(s[1], Size);
    f2.Write(s[1], Length(s));

    // now let's overwrite source file with temp file:
    f1.Position := 0;
    f1.Size := 0;
    f2.Position := 0;
    SetLength(s, f2.Size);
    f2.Read(s[1], Length(s));
    f1.Write(s[1], Length(s));

    f1.Free;
    f2.Free;
    DeleteFile(FileName);
  except
    try
      if f1 <> nil then f1.Free;
      if f2 <> nil then f1.Free;
    except
    end;
    Exit;
  end;

  Result := True;
end;

// returns True if successful and writes result to Script
function TReplaysForm.ReadScriptFromDemo(DemoFileName: string; var Script: string): Boolean;
var
  f: file of Byte;
  s: string;
  c: Char;
  i: Integer;
begin

  Result := False;

  AssignFile(f, DemoFileName);

  {$I+}
  try
    Reset(f);

    BlockRead(f, c, 1);
    if Ord(c) <> 1 then
    begin
      CloseFile(f);
      Exit;
    end;
    BlockRead(f, i, 4);

    SetLength(s, i);
    BlockRead(f, s[1], i);
    Script := s;

    CloseFile(f);

  except
    try
      CloseFile(f);
    except
    end;

    Exit;
  end;

  Result := True;
end;

procedure TReplaysForm.ReadWinningTeamsFromDemo(var replay: TReplay);
var
  f: file of Byte;
  winninAllyTeams: array of byte;
  i:integer;
begin
  if replay.demoHeader.version < 5 then
  begin
    replay.winningTeams.Add(replay.demoHeader.winningAllyTeam);
  end
  else
  begin
    AssignFile(f, replay.FullFileName);
    {$I+}
    try
      Reset(f);

      if FileSize(f) < replay.demoHeader.getWinningAllyTeamsSizePosition + replay.demoHeader.winningAllyTeamsSize then
      begin
        CloseFile(f);
        Exit;
      end;

      Seek(f,replay.demoHeader.getWinningAllyTeamsSizePosition);

      SetLength(winninAllyTeams, replay.demoHeader.winningAllyTeamsSize);

      for i:=0 to replay.demoHeader.winningAllyTeamsSize-1 do
        winninAllyTeams[i] := 234;

      BlockRead(f, winninAllyTeams[0], replay.demoHeader.winningAllyTeamsSize);

      for i:=0 to replay.demoHeader.winningAllyTeamsSize-1 do
      begin
        if winninAllyTeams[i] > replay.demoHeader.numTeams then
        begin
          CloseFile(f);
          Exit;
        end;
        replay.winningTeams.Add(winninAllyTeams[i]);
      end;

      CloseFile(f);
    except
      try
        CloseFile(f);
      except
      end;

      Exit;
    end;
  end;
end;

// returns True if successful and writes result to Script , read the new demofiles
function TReplaysForm.ReadScriptFromDemo2(var replay: TReplay; var Script: string): Boolean;
var
  f: file of Byte;
  s: string;
begin
  Result := False;

  AssignFile(f, replay.FullFileName);

  {$I+}
  try
    Reset(f);

    Seek(f,replay.demoHeader.headerSize);

    SetLength(s, replay.demoHeader.scriptSize);
    BlockRead(f, s[1], replay.demoHeader.scriptSize);
    Script := s;

    CloseFile(f);

  except
    try
      CloseFile(f);
    except
    end;

    Exit;
  end;

  Result := True;
end;

function TReplaysForm.ReadHeaderFromDemo2(var replay: TReplay): Boolean;
var
  f: file of Byte;
  tmpHeader: TDemoHeaderV3;
begin
  Result := False;

  AssignFile(f, replay.FullFileName);

  try
    Reset(f);
    BlockRead(f, tmpHeader, 20);
  except
    try
      CloseFile(f);
    except
    end;

    Exit;
  end;

  replay.demoHeader.version := tmpHeader.version;

  {$I+}
  try
    Reset(f);

    //Seek(f,0);
    if replay.demoHeader.version <= 3 then
      BlockRead(f, replay.demoHeader.demoHeaderV3, sizeof(replay.demoHeader.demoHeaderV3))
    else if replay.demoHeader.version = 4 then
      BlockRead(f, replay.demoHeader.demoHeaderV4, sizeof(replay.demoHeader.demoHeaderV4))
    else if replay.demoHeader.version = 5 then
      BlockRead(f, replay.demoHeader.demoHeaderV5, sizeof(replay.demoHeader.demoHeaderV5))
    else
      raise Exception.Create('Error: Replay file version not supported : '+IntToStr( replay.demoHeader.version ));

    CloseFile(f);

  except
    on E:Exception do
    begin
      if Debug.Enabled then
      begin
        MainForm.AddMainLog(E.Message,Colors.Error);
      end;

      try
        CloseFile(f);
      except
      end;

      Exit;
    end;
  end;

  Result := True;
end;

function TReplaysForm.FillPlayersInReplay(var replay: TReplay):boolean;
var
  count:integer;
  tmp: String;
  player: ^TReplayPlayer;
  sl : TStringList;
  f: file of Byte;
  doReadPlayerStats: boolean;
begin
  doReadPlayerStats := false;
  if replay.Version > 0 then
  begin
    AssignFile(f, replay.FullFileName);
    {$I+}
    try
      Reset(f);
      Seek(f,replay.demoHeader.getPlayerStatsPosition);
    except
      CloseFile(f);
      MainForm.AddMainLog(_('Error : couldn''t open the replay file :')+replay.FileName,Colors.Error);
      sl.Free;
      Exit;
    end;
    doReadPlayerStats := true;
  end;

  sl := TStringList.Create;
  count := 0;

  while True do
  begin
    tmp := replay.Script.ReadKeyValue('GAME/PLAYER'+ IntToStr(count)+'/NAME');
    if tmp = '' then break;
    New(player);
    player^ := TReplayPlayer.Create;

    player^.UserName := tmp;

    tmp := replay.Script.ReadKeyValue('GAME/PLAYER'+ IntToStr(count)+'/Rank');
    if tmp <> '' then
      player^.Rank := StrToInt(tmp);

    tmp := replay.Script.ReadKeyValue('GAME/PLAYER'+ IntToStr(count)+'/countrycode');
    if tmp <> '' then
      player^.CountryCode := tmp;

    tmp := replay.Script.ReadKeyValue('GAME/PLAYER'+ IntToStr(count)+'/spectator');
    if tmp = '' then
    begin
      Result := false;
      sl.Free;
      if doReadPlayerStats then
        CloseFile(f);
      player^.Free;
      FreeMem(player);
      Exit;
    end;
    player^.Spectator := StrToBool(tmp);

    if not player^.Spectator then
    begin
      tmp := replay.Script.ReadKeyValue('GAME/PLAYER'+ IntToStr(count)+'/team');
      if (tmp = '') then
      begin
        Result := false;
        sl.Free;
        if doReadPlayerStats then
          CloseFile(f);
        player^.Free;
        FreeMem(player);
        Exit;
      end;
      player^.Id := StrToInt(tmp);

      tmp := replay.Script.ReadKeyValue('GAME/team'+ IntToStr(player^.Id)+'/allyteam');
      if (tmp = '') then
      begin
        Result := false;
        sl.Free;
        if doReadPlayerStats then
          CloseFile(f);
        player^.Free;
        FreeMem(player);
        Exit;
      end;
      player^.Team := StrToInt(tmp);

      tmp := replay.Script.ReadKeyValue('GAME/team'+ IntToStr(player^.Id)+'/rgbcolor');
      if (tmp = '') then
      begin
        Result := false;
        sl.Free;
        if doReadPlayerStats then
          CloseFile(f);
        player^.Free;
        FreeMem(player);
        Exit;
      end;
      ParseDelimited(sl,tmp,' ','');
      try
        player^.Color := RGB(Ceil(StrToFloat(sl[0])*255),Ceil(StrToFloat(sl[1])*255),Ceil(StrToFloat(sl[2])*255));
      except
        Result := false;
        sl.Free;
        if doReadPlayerStats then
          CloseFile(f);
        player^.Free;
        FreeMem(player);
        Exit;
      end;
    end;
    replay.PlayerList.Add(player);

    if doReadPlayerStats then
    begin
      try
        BlockRead(f, player^.Stats, sizeof(player^.Stats));
      except
        //MainForm.AddMainLog('Error : couldn''t read the players stats in the replay file '+replay.FileName,Colors.Error);
        CloseFile(f);
        doReadPlayerStats := false;
      end;
    end;
    Inc(count);
  end;
  sl.Free;
  if doReadPlayerStats then
    CloseFile(f);
  if count=0 then
  begin
    Result := false;
    Exit;
  end;
  Result := true;
end;

function TReplaysForm.ReadGradeFromScript(Script: string): Byte;
var
  i, j: Integer;
  b: Byte;
begin
  Result := 0;

  Script := UpperCase(Script);
  i := Pos('[COMMENTS]', Script);
  if i = 0 then Exit;

  i := PosEx('GRADE=', Script, i);
  if i = 0 then Exit;

  j := PosEx(';', Script, i);
  if j = 0 then Exit;

  try
    b := StrToInt(Copy(Script, i+6, j-(i+6)));
  except
    Exit;
  end;

  Result := b;
end;


procedure TReplaysForm.CloseButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TReplaysForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  
  PageControl1.ActiveTabIndex := 0;
  LoadingPanel.Height := ReplaysForm.ClientHeight-PanelTop.Top-PanelTop.Left;
  LoadingPanel.Width := ReplaysForm.ClientWidth-PanelTop.Left*2;
  LoadingPanel.Top := PanelTop.Top;
  LoadingPanel.Left := PanelTop.Left;

  FTeamLineCharts := TList.Create;
  lstTSGLineStat.ItemIndex := 0;
  lstTSGDashedStat.ItemIndex := 0;

  FixFormSizeConstraints(self);

  initFiltersPresets;

  FiltersButtonClick(nil);
end;

procedure TReplaysForm.ReloadButtonClick(Sender: TObject);
begin
  ReplaysUnit.TReadReplaysThrd.Create(False);
  {InitWaitForm.ChangeCaption(MSG_RELOADREPLAYS);
  InitWaitForm.TakeAction := 4; // reload replay list
  InitWaitForm.ShowModal; // this will reload replay list }
end;

function TReplaysForm.LoadReplay(Replay: TReplay): Boolean;
var
  b: Byte;
  i, j, k: Integer;
  count: Integer;
  s: string;
  FileName: string;
  ScriptCls : TScript;
  tmp: String;
  tmpSubKeys: TStrings;
begin
  LoadingReplay := True;
  Result := False;
  ScriptRichEdit.Lines.Clear;
  CommentsRichEdit.Lines.Clear;
  VDTPlayers.Clear;
  PlayersTab.Caption := _('Players');
  if Replay = nil then Exit;

  VDTPlayers.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoTristateTracking,toAutoDeleteMovedNodes];
  for i:=0 to Replay.PlayerList.Count-1 do
  begin
    VDTPlayers.RootNodeCount := VDTPlayers.RootNodeCount + 1;
    TReplayPlayer(Replay.PlayerList[i]^).Node := VDTPlayers.GetLast;
  end;
  VDTPlayers.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoSort,toAutoTristateTracking,toAutoDeleteMovedNodes];
  VDTPlayers.SortTree(VDTPlayers.Header.SortColumn,VDTPlayers.Header.SortDirection);

  PlayersTab.Caption := _('Players (') + IntToStr(Replay.PlayerList.Count) + ')';

  Result := True;
  LoadingReplay := False;

  ScriptRichEdit.Text := Replay.Script.Script;
  ReadCommentsFromScript(Replay.Script, CommentsRichEdit.Lines, b);
  if CommentsRichEdit.Lines.Text <> '' then
    CommentsTab.FontSettings.Style := [fsBold]
  else
    CommentsTab.FontSettings.Style := [];
  GradeComboBox.ItemIndex := Min(b, 10); // 11 grades max. (0..10)
  SaveButton.Enabled := False;

  try

    if Replay.Script.ReadStartPosType = 3 then
      lblStartPos.Caption := _('Start pos : Choose in lobby')
    else
      lblStartPos.Caption := _('Start pos : ')+BattleForm.StartPosRadioGroup.Items[Replay.Script.ReadStartPosType];
  except
    on E: Exception do MessageDlg(_('An error occured while loading the replay ''')+Replay.FileName+''' :'+EOL+EOL + E.Message,mtError,[mbOk],E.HelpContext);
  end;

  try lblGameEnd.Caption := _('Game end condition: ')+IntToStr(Replay.Script.ReadGameMode); except end;
  try lblMetal.Caption := _('Start metal : ')+IntToStr(Replay.Script.ReadStartMetal); except end;
  try lblEnergy.Caption := _('Start energy : ')+IntToStr(Replay.Script.ReadStartEnergy); except end;
  try lblMaxUnits.Caption := _('Max units : ')+IntToStr(Replay.Script.ReadMaxUnits); except end;


  try
    chkLimiteDGun.Checked := Replay.Script.ReadLimitDGun;
    chkLimiteDGun.Visible := True;
  except
    chkLimiteDGun.Visible := False;
  end;
  try
    chkGhosted.Checked := Replay.Script.ReadGhostedBuildings;
    chkGhosted.Visible := True;
  except
    chkGhosted.Visible := False;
  end;
  try
    chkDiminishing.Checked := Replay.Script.ReadDiminishingMMs;
    chkDiminishing.Visible := True;
  except
    chkDiminishing.Visible := False;
  end;

  lstDisabledUnits.Items.AddStrings(Replay.Script.ReadDisabledUnits);

  lstLuaOptions.Clear;

  tmpSubKeys := TStringList.Create;
  tmpSubKeys := Replay.Script.GetSubKeys('GAME/ModOptions');
  for i:=0 to tmpSubKeys.Count-1 do
    lstLuaOptions.Items.Add(tmpSubKeys[i]+' : '+Replay.Script.ReadKeyValue('GAME/ModOptions/'+tmpSubKeys[i]));

  tmpSubKeys := TStringList.Create;
  tmpSubKeys := Replay.Script.GetSubKeys('GAME/MapOptions');
  for i:=0 to tmpSubKeys.Count-1 do
    lstLuaOptions.Items.Add(tmpSubKeys[i]+' : '+Replay.Script.ReadKeyValue('GAME/MapOptions/'+tmpSubKeys[i]));

  lstTSGPlayers.Items.Clear;
  if Replay.TeamStatsAvailable then
  begin
    GraphsTab.Enabled := true;
    for i:=0 to Replay.TeamList.count -1 do
    begin
      lstTSGPlayers.Items.Add('');
      lstTSGPlayers.Checked[i] := true;
    end;
  end
  else
    GraphsTab.Enabled := false;

  UpdateTeamStatsGraph;
end;

procedure TReplaysForm.WatchButtonClick(Sender: TObject);
var
  FileName: string;
  springDir: string;
  Replay: TReplay;
  springExeVersion: String;
  version1: TStringList;
  version2: TStringList;
  springExe: string;
  springVersionsMatch: boolean;
  replayMapMissing: boolean;
  replayModMissing: boolean;
begin
  if VDTReplays.FocusedNode = nil then // just in case
    Exit;

  version1 := TStringList.Create;
  version2 := TStringList.Create;

  Replay := GetReplayFromNode(VDTReplays.FocusedNode);

  replayMapMissing := Utility.MapList.IndexOf(Replay.Script.ReadMapName()) = -1;
  replayModMissing := Utility.ModList.IndexOf(Replay.Script.ReadModName()) = -1;
  if replayModMissing then
  begin
    HostBattleForm.RefreshModListButton.OnClick(HostBattleForm.RefreshModListButton);
    replayModMissing := Utility.ModList.IndexOf(Replay.Script.ReadModName()) = -1;
  end;

  if replayMapMissing or replayModMissing then
  begin
    if MessageDlg(_('You cannot start this replay because the map and/or the mod is/are missing. Do you want to download the missing files ?'), mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      if replayModMissing then DownloadMod(0,Replay.Script.ReadModName());
      if replayMapMissing then DownloadMap(0,Replay.Script.ReadMapName());
      Exit;
    end
    else if MessageDlg(_('Do you want to start the replay anyway ?'), mtWarning, [mbYes, mbNo], 0) = mrNo then
      Exit;
  end;

  if RunningUnderWine then
  begin
    springDir := ExtractFilePath(Application.ExeName);
  end
  else
  begin
    if BattleForm.IsBattleActive and Status.Me.GetReadyStatus then
      if MessageDlg(_('You cannot be ready in a battle and watch replays at the same time. Do you wish to unready now?'), mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit
      else BattleForm.ReadyButton.OnClick(BattleForm.ReadyButton);

    FileName := Replay.FullFileName;

    springVersionsMatch := CompareSpringVersion( Replay.SpringVersion, Status.MySpringVersion) = 0;

    if not springVersionsMatch then
    begin
      ParseDelimited(version2,Replay.SpringVersion,'.','');
      springDir := ExtractFilePath(Application.ExeName)+'OldSpring\'+version2[0]+'\';
    end;

    if springVersionsMatch or not FileExists(springDir+'spring.exe') then
    begin
      springExeVersion := GetSpringVersionFromEXE;

      if not springVersionsMatch then
        if MessageDlg(springDir + _('spring.exe not found.')+EOL+EOL+_('Watching a replay with the wrong spring version may not work.')+EOL+EOL+_('Watch with the default spring.exe (')+springExeVersion+') ?',mtWarning,[mbYes,mbNo],0) = mrNo then
          Exit;
      springDir := ExtractFilePath(Application.ExeName);
    end
    else
    begin
      try
        CopyFile(PChar(Replay.FullFileName),PChar(springDir+'demos\'+Replay.FileName),true);
        CopyFile(PChar(ExtractFilePath(Application.ExeName)+'mods\'+Replay.Script.ReadModName),PChar(springDir+'mods/'+Replay.Script.ReadModName),true);
        CopyFile(PChar(ExtractFilePath(Application.ExeName)+GetMapArchive(Replay.Script.ReadMapName)),PChar(springDir+GetMapArchive(Replay.Script.ReadMapName)),true);
      except
        //nothing
      end;
    end;
  end;
  springExe := SpringSettingsProfileForm.getSpringExe;
  ShellExecute(MainForm.Handle, 'open', PChar(springExe), PChar('"'+AnsiString(Replay.FullFileName)+'"'), PChar(springDir), SW_MAX);
end;

procedure TReplaysForm.DeleteButtonClick(Sender: TObject);
begin
  if MessageDlg(_('Are you sure you want to delete ') + GetReplayFromNode(VDTReplays.FocusedNode).FileName + '?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  DeleteFile(GetReplayFromNode(VDTReplays.FocusedNode).FullFileName);
  ReloadButton.OnClick(nil);
end;

procedure TReplaysForm.CommentsRichEditChange(Sender: TObject);
begin
  if VDTReplays.FocusedNode <> nil then if not LoadingReplay then SaveButton.Enabled := True;
end;

procedure TReplaysForm.SaveButtonClick(Sender: TObject);
var
  Grade: Byte;
  Replay: TReplay;
begin
  if GradeComboBox.ItemIndex = -1 then Exit; // this shouldn't happen!

  Grade := GradeComboBox.ItemIndex;

  if not ValidateComments(CommentsRichEdit.Lines) then Exit;

  Replay := GetReplayFromNode(VDTReplays.FocusedNode);

  SaveCommentsToScript(Replay.Script, CommentsRichEdit.Lines, Grade);

  if ((Replay.Version = 0) and (not ChangeScriptInDemo(Replay.FullFileName, Replay.Script.Script))) or ((Replay.Version = 1) and (not ChangeScriptInDemo2(Replay.FullFileName, Replay.Script.Script))) then
  begin
    MessageDlg(_('Error: unable to write file!'), mtError, [mbOK], 0);
  end
  else
  begin
    SaveButton.Enabled := False;
    Replay.Grade := Grade;
    VDTReplays.Invalidate;
    ScriptRichEdit.Text := Replay.Script.Script;
    ScriptRichEdit.Invalidate;
  end;
end;

procedure TReplaysForm.ReplaysListBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if Index > ReplayList.Count-1 then Exit; // this fixes the crash when deleting the last item in the list
  // this ensures the correct highlite color is used
//  (Control as TSpTBXListBox).Canvas.FillRect(Rect); --> we need this only with TListBox, but not with TSpTBXListBox

  MainForm.GradesImageList.Draw((Control as TSpTBXListBox).Canvas, Rect.Left, Rect.Top, TReplay(ReplayList.Items[Index]).Grade);
  (Control as TSpTBXListBox).Canvas.Brush.Style := bsClear; // we need this only with TSpTBXListBox and not with standard TListBox
  (Control as TSpTBXListBox).Canvas.TextOut(Rect.Left + MainForm.GradesImageList.Width + 3, Rect.Top, TReplay(ReplayList.Items[Index]).FileName);
end;

procedure TReplaysForm.GradeComboBoxChange(Sender: TObject);
begin
  if VDTReplays.FocusedNode <> nil then SaveButton.Enabled := True;
end;

procedure TReplaysForm.HostReplayButtonClick(Sender: TObject);
begin
  {if not WasLastLoadSuccessful then
  begin
    MessageDlg('Outdated/corrupt demo file format - unable to host!', mtWarning, [mbOK], 0);
    Exit;
  end;}
  ModalResult := mrOK;
end;

procedure TReplaysForm.RenameButtonClick(Sender: TObject);
var
  s, OldName: string;
  Replay: TReplay;
begin
  Replay := GetReplayFromNode(VDTReplays.FocusedNode);
  OldName := Replay.FullFileName;
  s := Replay.FileName;
  if not InputQuery(_('Rename file'), _('New name:'), s) then Exit;
  if Copy(s, Length(s) - 3, 4) <> '.sdf' then s := s + '.sdf';
  if not RenameFile(OldName, ExtractFilePath(Application.ExeName) + 'demos\' + s) then
  begin
    MessageDlg(_('Rename file failed!'), mtWarning, [mbOK], 0);
    Exit;
  end;
  ReloadButton.OnClick(nil);
end;

procedure TReplaysForm.ReplaysListBoxDblClick(Sender: TObject);
begin
  WatchButton.OnClick(nil);
end;

procedure TReplaysForm.LoadingPanelResize(Sender: TObject);
begin
  LoadingLabel.Top := LoadingPanel.Height div 2 - LoadingLabel.Height div 2;
end;

procedure TReplaysForm.DownloadButtonClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://replays.springrts.com');
end;

procedure TReplaysForm.UploadButtonClick(Sender: TObject);
var
  i,j:integer;
  Replay: TReplay;
begin
  Replay := GetReplayFromNode(VDTReplays.FocusedNode);
  UploadReplayForm.AutoUpload := False;
  UploadReplayForm.FileName := Replay.FullFileName;
  UploadReplayForm.MapName := Copy(Replay.Script.ReadKeyValue('GAME/mapname'),0,Length(Replay.Script.ReadKeyValue('GAME/mapname'))-4);
  UploadReplayForm.ModName := Copy(Replay.Script.ReadKeyValue('GAME/gametype'),0,Length(Replay.Script.ReadKeyValue('GAME/mapname'))-4);
  UploadReplayForm.ShowModal;
end;

function TReplaysForm.GetReplayFromNode(Node: PVirtualNode): TReplay;
var
  i: Integer;
begin
  for i := 0 to ReplayList.Count - 1 do
    if TReplay(ReplayList[i]).Node <> nil then
      if TReplay(ReplayList[i]).Node.Index = Node.index then
      begin
        Result := ReplayList[i];
        exit;
      end;
  Result := ReplayList[ReplayList.Count-1];
end;

function TReplaysForm.GetReplayPlayerFromNode(Node: PVirtualNode): TReplayPlayer;
var
  Replay: TReplay;
  i: Integer;
begin
  Replay := GetReplayFromNode(VDTReplays.FocusedNode);

  for i := 0 to Replay.PlayerList.Count - 1 do
    if TReplayPlayer(Replay.PlayerList[i]^).Node <> nil then
    if TReplayPlayer(Replay.PlayerList[i]^).Node.Index = Node.index then
  begin
    Result := TReplayPlayer(Replay.PlayerList[i]^);
    exit;
  end;
  Result := TReplayPlayer(Replay.PlayerList[Replay.PlayerList.Count-1]^);
end;

function TReplaysForm.GetReplayFromFileName(fName: String): TReplay;
var
  i: Integer;
begin
  fName := LowerCase(fName);
  for i := 0 to ReplayList.Count - 1 do
    if (LowerCase(TReplay(ReplayList[i]).FileName) = fName) or (LowerCase(TReplay(ReplayList[i]).FullFileName) = fName) then
    begin
      Result := ReplayList[i];
      exit;
    end;
  Result := ReadReplay(fName);
end;

procedure TReplaysForm.VDTReplaysDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  R: TRect;
  Replay: TReplay;
  Pos: integer;
  s: WideString;
  s2: string;
  tmp : WideString;
  textAlign: Cardinal;
  i: integer;
  dt: TDateTime;
  BgRect: TRect;
  pt: TPoint;
  hot: Boolean;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
begin
  if not (Sender as TVirtualDrawTree).Visible then
    Exit;


  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    Replay := GetReplayFromNode(Node);

    GetCursorPos(pt);
    pt := ScreenToClient(pt);
    GetHitTestInfoAt(pt.X,pt.Y,True,hi);

    hot := (SkinManager.GetSkinType=sknSkin) and ReplaysForm.Active and (hi.HitNode = Node);

    CopyRect(BgRect,CellRect);
    {if Position <> 0 then
      BgRect.Left := -5;
    if Position <> Header.Columns.Count-1 then
      BgRect.Right := BgRect.Right+5;}

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
    InflateRect(R, -TextMargin, 0);
    Dec(R.Right);
    Dec(R.Bottom);
    s := '';
    pos := 0;
    textAlign := DT_LEFT;

    case Column of
      0: // grade
        MainForm.GradesImageList.Draw(Canvas, R.Left+pos, R.Top, Replay.Grade);
      1: // date time
        s := DateTimeToStr(Replay.Date);
      2: // host name
        if Replay.PlayerList.Count > 0 then
          s := TReplayPlayer(Replay.PlayerList[0]^).UserName;
      3: // mod
        s := Replay.Script.ReadModName;
      4: // map
        s := Replay.Script.ReadMapName;
      5: // demo file size
      begin
        s := Misc.FormatFileSize(GetFileSize(Replay.FullFileName)) + ' KB';
        textAlign := DT_RIGHT;
      end;
      6: // game length
        if Replay.Version = 1 then
        begin
          dt := EncodeTime(Replay.demoHeader.gameTime div 3600,(Replay.demoHeader.gameTime div 60) mod 60,Replay.demoHeader.gameTime mod 60,0);
          DateTimeToString(s2,'hh:nn:ss',dt);
          s := s2;
          //s := TimeToStr(EncodeTime(Replay.demoHeader.gameTime div 3600,(Replay.demoHeader.gameTime div 60) mod 60,Replay.demoHeader.gameTime mod 60,0));
        end
        else
          s:= 'n/a';
      7: // spring version
        s := Replay.SpringVersion;
      8: // players
      begin
        if (Replay.Version = 1) and (Replay.demoHeader.maxPlayerNum > 0) then
          tmp := IntToStr(Replay.demoHeader.maxPlayerNum)
        else
          tmp := '??';
        s := IntToStr(Replay.PlayerList.Count-Replay.GetSpectatorCount) +'+'+IntToStr(Replay.GetSpectatorCount)+'/' + tmp + '  ';
        for i:=0 to Replay.PlayerList.Count-1 do
          s := s + ' ' + TReplayPlayer(Replay.PlayerList[i]^).UserName;
      end;
      9: // file name
        s := Replay.FileName;
    end;

    if Length(s) > 0 then
    begin
       with R do
         if (NodeWidth - 2 * Margin) > (Right - Left) then
           s := ShortenString(Canvas.Handle, s, Right - Left, 0);
       R.Left := R.Left + Pos;
       DrawTextW(Canvas.Handle, PWideChar(S), Length(S), R, DT_TOP or textAlign or DT_VCENTER or DT_SINGLELINE, False);
    end;
  end;
end;

procedure TReplaysForm.VDTReplaysCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Replay1,Replay2: TReplay;
  i,j: integer;
begin
  Replay1 := GetReplayFromNode(Node1);
  Replay2 := GetReplayFromNode(Node2);

  Result := 0;

  case Column of
    0: // grade
      Result := CompareValue(Replay1.Grade,Replay2.Grade);
    1: // date time
      Result := CompareDateTime(Replay1.Date,Replay2.Date);
    2: // host name
      Result := CompareStr(TReplayPlayer(Replay1.PlayerList[0]^).UserName,TReplayPlayer(Replay2.PlayerList[0]^).UserName);
    3: // mod
      Result := CompareStr(Replay1.Script.ReadModName,Replay2.Script.ReadModName);
    4: // map
      Result := CompareStr(Replay1.Script.ReadMapName,Replay2.Script.ReadMapName);
    5: // demo file size
      Result := CompareValue(Misc.GetFileSize(Replay1.FullFileName),Misc.GetFileSize(Replay2.FullFileName));
    6: // game length
    begin
      if Replay1.Version = 0 then
        i := 0
      else
        i := Replay1.demoHeader.gameTime;
      if Replay2.Version = 0 then
        j := 0
      else
        j := Replay2.demoHeader.gameTime;
      Result := CompareValue(i,j);
    end;
    7: // spring version
      Result := CompareStr(Replay1.SpringVersion,Replay2.SpringVersion);
    8: // players
      Result := CompareValue(Replay1.PlayerList.Count-Replay1.GetSpectatorCount,Replay2.PlayerList.Count-Replay2.GetSpectatorCount);
    9: // file name
      Result := CompareStr(Replay1.FileName,Replay2.FileName);
  end;
end;

procedure TReplaysForm.VDTReplaysHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if VDTReplays.Header.SortColumn = HitInfo.Column then
    if VDTReplays.Header.SortDirection = sdDescending then
      VDTReplays.Header.SortDirection := sdAscending
    else
      VDTReplays.Header.SortDirection := sdDescending
  else
  begin
    VDTReplays.Header.SortColumn := HitInfo.Column;
    VDTReplays.Header.SortDirection := sdDescending;
  end;
end;

procedure TReplaysForm.InitVDTForRefresh;
begin
  ReplaysForm.LoadingPanel.Visible := True;
  SpTBXSplitter1.Visible := False;
  BottomPanel.Visible := False;
  PanelTop.Visible := False;
  VDTReplays.Visible := false;
  VDTReplays.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoTristateTracking,toAutoDeleteMovedNodes];
end;

procedure TReplaysForm.TerminateVDTRefresh;
begin
  BottomPanel.Visible := true;
  SpTBXSplitter1.Visible := true;
  PanelTop.Visible := true;
  VDTReplays.Visible := true;
  ReplaysForm.LoadingPanel.Visible := False;
  if VDTReplays.RootNodeCount = 0 then
  begin
    VDTPlayers.Refresh;
    Exit;
  end;
  VDTReplays.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoSort,toAutoTristateTracking,toAutoDeleteMovedNodes];
  VDTReplays.SortTree(VDTReplays.Header.SortColumn,VDTReplays.Header.SortDirection);

  RenameButton.Enabled := ReplayList.Count > 0;
  DeleteButton.Enabled := RenameButton.Enabled;
  GradeComboBox.Enabled := RenameButton.Enabled;
  UploadButton.Enabled := RenameButton.Enabled;

  ReplaysForm.VDTReplays.FocusedNode := ReplaysForm.VDTReplays.GetFirst;
  ReplaysForm.VDTReplays.Selected[ReplaysForm.VDTReplays.FocusedNode] := true;

  ReplaysForm.VDTReplaysClick;

  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onReplaysReloaded(); except end;
  ReleaseMainThread;
end;

procedure TReplaysForm.VDTReplaysClick;
begin
  if VDTReplays.FocusedNode = nil then Exit;
  if not LoadReplay(GetReplayFromNode(VDTReplays.FocusedNode)) then
  begin
    WasLastLoadSuccessful := False;
    ScriptRichEdit.Lines.Add(_('Outdated/corrupt demo file format!'));
    CommentsRichEdit.Lines.Add(_('Outdated/corrupt demo file format!'));
    SaveButton.Enabled := False;
  end
  else
  begin
    SaveButton.Enabled := True;
  end;
end;

procedure TReplaysForm.VDTReplaysClick(Sender: TObject);
begin
  VDTReplaysClick;
end;

procedure TReplaysForm.VDTPlayersDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  R: TRect;
  ReplayPlayer: TReplayPlayer;
  Replay: TReplay;
  Pos: integer;
  s: WideString;
  tmp : WideString;
  textAlign: Cardinal;
  i: integer;
  FlagBitmap: TBitmap;
  TempPenColor,TempBrushColor: TColor;
  BgRect: TRect;
  pt: TPoint;
  hot: Boolean;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
begin
  if not VDTReplays.Visible then
    Exit;
  if VDTReplays.RootNodeCount = 0 then
    Exit;

  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    Replay := GetReplayFromNode(VDTReplays.FocusedNode);
    ReplayPlayer := GetReplayPlayerFromNode(Node);

    GetCursorPos(pt);
    pt := ScreenToClient(pt);
    GetHitTestInfoAt(pt.X,pt.Y,True,hi);

    hot := (SkinManager.GetSkinType=sknSkin) and ReplaysForm.Active and (hi.HitNode = Node);

    CopyRect(BgRect,CellRect);
    {if Position <> 0 then
      BgRect.Left := -5;
    if Position <> Header.Columns.Count-1 then
      BgRect.Right := BgRect.Right+5;}

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

    if not hot and ((Node <> FocusedNode) or not focused) and (Replay.Version = 1) and Replay.isWinningTeam(ReplayPlayer.Team) and not ReplayPlayer.Spectator then
    begin
      Canvas.Brush.Color := MainUnit.Colors.ReplayWinningTeam;
      Canvas.FillRect(CellRect);
    end;


    InflateRect(R, -TextMargin, 0);
    Dec(R.Right);
    Dec(R.Bottom);
    s := '';
    pos := 0;
    textAlign := DT_LEFT;

    case Column of
      0: // player
      begin
        if Preferences.ShowFlags and (ReplayPlayer.CountryCode <> '') then
        begin
          FlagBitmap := MainForm.GetFlagBitmap(ReplayPlayer.CountryCode);
          Canvas.Draw(R.Left+pos, R.Top + 16 div 2 - FlagBitmap.Height div 2, FlagBitmap);
          Inc(pos, FlagBitmap.Width + 5);
        end;
        MainForm.RanksImageList.Draw(Canvas, R.Left+pos, R.Top, ReplayPlayer.Rank);
        Inc(pos, MainForm.RanksImageList.Width + 5);
        s := ReplayPlayer.UserName;
      end;
      1: // id
      begin
        if not ReplayPlayer.Spectator then
        begin
          with Canvas do
          begin
            TempPenColor := Pen.Color;
            TempBrushColor := Brush.Color;
            Brush.Color := ReplayPlayer.Color;
            Pen.Color := clGray;
            Ellipse(R.Left + Pos + 2, R.Top + 2, R.Left + Pos + 13, R.Top + 13);
            Pen.Color := TempPenColor;
            Brush.Color := TempBrushColor;
            Brush.Style := Graphics.bsClear;
            Inc(Pos,20);
          end;

          s := IntToStr(ReplayPlayer.Id+1);
        end;
      end;
      2: // team
        if not ReplayPlayer.Spectator then
          s := IntToStr(ReplayPlayer.Team+1);
      3: // mouse pixels
        if (ReplayPlayer.Stats.mousePixels > 0) and (Replay.demoHeader.wallclockTime >0 ) then
          s := IntToStr(Ceil(ReplayPlayer.Stats.mousePixels*60/Replay.demoHeader.wallclockTime));
      4: // mouse clicks
        if (ReplayPlayer.Stats.mouseClicks > 0) and (Replay.demoHeader.wallclockTime >0 ) then
          s := IntToStr(Ceil(ReplayPlayer.Stats.mouseClicks*60/Replay.demoHeader.wallclockTime));
      5: // key presses
        if (ReplayPlayer.Stats.keyPresses > 0) and (Replay.demoHeader.wallclockTime >0 ) then
          s := IntToStr(Ceil(ReplayPlayer.Stats.keyPresses*60/Replay.demoHeader.wallclockTime));
      6: // num commands
        if (ReplayPlayer.Stats.numCommands > 0) and (Replay.demoHeader.wallclockTime >0 ) then
          s := IntToStr(Ceil(ReplayPlayer.Stats.numCommands*60/Replay.demoHeader.wallclockTime));
      7: // units per commands
        if (ReplayPlayer.Stats.numCommands > 0) and (ReplayPlayer.Stats.numCommands >0 ) then
          s := FloatToStr(RoundTo(ReplayPlayer.Stats.unitCommands/ReplayPlayer.Stats.numCommands,-2));
    end;

    if Length(s) > 0 then
    begin
       with R do
         if (NodeWidth - 2 * Margin) > (Right - Left) then
           s := ShortenString(Canvas.Handle, s, Right - Left, 0);
       R.Left := R.Left + Pos;
       DrawTextW(Canvas.Handle, PWideChar(S), Length(S), R, DT_TOP or textAlign or DT_VCENTER or DT_SINGLELINE, False);
    end;
  end;
end;

procedure TReplaysForm.VDTPlayersCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  ReplayPlayer1,ReplayPlayer2: TReplayPlayer;
  Replay: TReplay;
begin
  Replay := GetReplayFromNode(VDTReplays.FocusedNode);
  ReplayPlayer1 := GetReplayPlayerFromNode(Node1);
  ReplayPlayer2 := GetReplayPlayerFromNode(Node2);

  case Column of
    0:
      Result := CompareStr(ReplayPlayer1.UserName,ReplayPlayer2.UserName);
    1:
      if not ReplayPlayer1.Spectator and not ReplayPlayer2.Spectator then
        Result := CompareValue(ReplayPlayer1.Id,ReplayPlayer2.Id)
      else
        if ReplayPlayer2.Spectator then
          Result := -1
        else
          Result := 1;
    2:
      if not ReplayPlayer1.Spectator and not ReplayPlayer2.Spectator then
        Result := CompareValue(ReplayPlayer1.Team,ReplayPlayer2.Team)
      else
        if ReplayPlayer2.Spectator then
          Result := -1
        else
          Result := 1;
    3:
      if Replay.demoHeader.wallclockTime = 0 then
        Result := 0
      else
        Result := CompareValue(Ceil(ReplayPlayer1.Stats.mousePixels*60/Replay.demoHeader.wallclockTime),Ceil(ReplayPlayer2.Stats.mousePixels*60/Replay.demoHeader.wallclockTime));
    4:
      if Replay.demoHeader.wallclockTime = 0 then
        Result := 0
      else
        Result := CompareValue(Ceil(ReplayPlayer1.Stats.mouseClicks*60/Replay.demoHeader.wallclockTime),Ceil(ReplayPlayer2.Stats.mouseClicks*60/Replay.demoHeader.wallclockTime));
    5:
      if Replay.demoHeader.wallclockTime = 0 then
        Result := 0
      else
        Result := CompareValue(Ceil(ReplayPlayer1.Stats.keyPresses*60/Replay.demoHeader.wallclockTime),Ceil(ReplayPlayer2.Stats.keyPresses*60/Replay.demoHeader.wallclockTime));
    6:
      if Replay.demoHeader.wallclockTime = 0 then
        Result := 0
      else
        Result := CompareValue(Ceil(ReplayPlayer1.Stats.numCommands*60/Replay.demoHeader.wallclockTime),Ceil(ReplayPlayer2.Stats.numCommands*60/Replay.demoHeader.wallclockTime));
    7:
      if (ReplayPlayer1.Stats.numCommands = 0) then
        Result := -1
      else
        if (ReplayPlayer2.Stats.numCommands = 0) then
          Result := 1
        else
          Result := CompareValue(RoundTo(ReplayPlayer1.Stats.unitCommands/ReplayPlayer1.Stats.numCommands,-2),RoundTo(ReplayPlayer2.Stats.unitCommands/ReplayPlayer2.Stats.numCommands,-2));
  end;
end;

procedure TReplaysForm.VDTPlayersHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if VDTPlayers.Header.SortColumn = HitInfo.Column then
    if VDTPlayers.Header.SortDirection = sdDescending then
      VDTPlayers.Header.SortDirection := sdAscending
    else
      VDTPlayers.Header.SortDirection := sdDescending
  else
  begin
    VDTPlayers.Header.SortColumn := HitInfo.Column;
    VDTPlayers.Header.SortDirection := sdAscending;
  end;
end;

function TReplaysForm.isReplayVisible(Replay: TReplay):boolean;
var
  i,j,k:integer;
  tmpStr: String;
  sl: TStrings;
begin
  if not chkEnableFilters.Checked then
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
          tmpStr := TReplayPlayer(Replay.PlayerList[0]^).UserName
        else if filterType = MapName then
          tmpStr := LeftStr(Replay.Script.ReadMapName,Length(Replay.Script.ReadMapName)-4) // left to remove the .smf (or whatever the extension is)
        else if filterType = ModName then
          tmpStr := LeftStr(Replay.Script.ReadModName,Length(Replay.Script.ReadModName)-4) // left to remove the .sd7 (or whatever the extension is)
        else if filterType = DisabledUnits then
          tmpStr := JoinStringList(Replay.Script.ReadDisabledUnits,' ')
        else if filterType = SpringVersion then
          tmpStr := Replay.SpringVersion
        else if filterType = FileName then
          tmpStr := Replay.FileName
        else if filterType = MapModOption then
        begin
          sl := Replay.Script.GetSubKeys('GAME/modoptions');
          for j:=0 to sl.Count-1 do
            tmpStr := tmpStr + ' ' + sl[j]+'='+Replay.Script.ReadKeyValue('GAME/modoptions/'+sl[j]);
          sl := Replay.Script.GetSubKeys('GAME/mapoptions');
          for j:=0 to sl.Count-1 do
            tmpStr := tmpStr + ' ' + sl[j]+'='+Replay.Script.ReadKeyValue('GAME/mapoptions/'+sl[j]);
        end
        else if filterType = Players then
          for k:=0 to Replay.PlayerList.Count-1 do
            tmpStr := tmpStr + TReplayPlayer(Replay.PlayerList[k]^).UserName + ' '
        else
          raise Exception.Create(_('Filter type not handled.'));

        //j := Pos(LowerCase(value),LowerCase(tmpStr));
        //if (contains and (j = 0)) or ((not contains) and (j > 0)) then
        if RegExpr.ExecRegExpr(LowerCase(value),LowerCase(tmpStr)) xor contains then
        begin
          Result := False;
          Exit;
        end;
      end; // if
    end; // with
  end; // for
  try
  Result :=
      (Filters.GameContinues or not (Replay.Script.ReadGameMode = 0)) and
      (Filters.ComEnd or not (Replay.Script.ReadGameMode = 1)) and
      (Filters.Lineage or not (Replay.Script.ReadGameMode = 2)) and
      (not Filters.FilterLimitDGun or (Replay.Script.ReadLimitDGun = Filters.LimitDGun)) and
      (not Filters.FilterGhosted or (Replay.Script.ReadGhostedBuildings = Filters.Ghosted)) and
      (not Filters.FilterDiminishing or (Replay.Script.ReadDiminishingMMs = Filters.Diminishing)) and
      (Filters.Fixed or not (Replay.Script.ReadStartPosType = 0)) and
      (Filters.Random or not (Replay.Script.ReadStartPosType = 1)) and
      (Filters.ChooseInGame or not (Replay.Script.ReadStartPosType = 2)) and
      (
        not Filters.Metal.enabled or
        ((Filters.Metal.filterType = Sup) and (Replay.Script.ReadStartMetal > Filters.Metal.value)) or
        ((Filters.Metal.filterType = Inf) and (Replay.Script.ReadStartMetal < Filters.Metal.value)) or
        ((Filters.Metal.filterType = Equal) and (Replay.Script.ReadStartMetal = Filters.Metal.value))
      ) and
      (
        not Filters.Energy.enabled or
        ((Filters.Energy.filterType = Sup) and (Replay.Script.ReadStartEnergy > Filters.Energy.value)) or
        ((Filters.Energy.filterType = Inf) and (Replay.Script.ReadStartEnergy < Filters.Energy.value)) or
        ((Filters.Energy.filterType = Equal) and (Replay.Script.ReadStartEnergy = Filters.Energy.value))
      ) and
      (
        not Filters.Units.enabled or
        ((Filters.Units.filterType = Sup) and (Replay.Script.ReadMaxUnits > Filters.Units.value)) or
        ((Filters.Units.filterType = Inf) and (Replay.Script.ReadMaxUnits < Filters.Units.value)) or
        ((Filters.Units.filterType = Equal) and (Replay.Script.ReadMaxUnits = Filters.Units.value))
      ) and
      (
        not Filters.Players.enabled or
        ((Filters.Players.filterType = Sup) and (Replay.PlayerList.Count-Replay.GetSpectatorCount > Filters.Players.value)) or
        ((Filters.Players.filterType = Inf) and (Replay.PlayerList.Count-Replay.GetSpectatorCount < Filters.Players.value)) or
        ((Filters.Players.filterType = Equal) and (Replay.PlayerList.Count-Replay.GetSpectatorCount = Filters.Players.value))
      ) and
      (
        not Filters.Length.enabled or
        ((Filters.Length.filterType = Sup) and (Replay.GetLength/60 > Filters.Length.value)) or
        ((Filters.Length.filterType = Inf) and (Replay.GetLength/60 < Filters.Length.value)) or
        ((Filters.Length.filterType = Equal) and (Replay.GetLength/60 = Filters.Length.value))
      ) and
      (
        not Filters.FileSize.enabled or
        ((Filters.FileSize.filterType = Sup) and (GetFileSize(Replay.FullFileName)/1024 > Filters.FileSize.value)) or
        ((Filters.FileSize.filterType = Inf) and (GetFileSize(Replay.FullFileName)/1024 < Filters.FileSize.value)) or
        ((Filters.FileSize.filterType = Equal) and (GetFileSize(Replay.FullFileName)/1024 = Filters.FileSize.value))
      ) and
      (
        not Filters.Grade.enabled or
        ((Filters.Grade.filterType = Sup) and (Replay.Grade > Filters.Grade.value)) or
        ((Filters.Grade.filterType = Inf) and (Replay.Grade < Filters.Grade.value)) or
        ((Filters.Grade.filterType = Equal) and (Replay.Grade = Filters.Grade.value))
      );
  except
    Result := False;
  end;
end;

procedure TReplaysForm.FilterReplayList;
var
  i:integer;
begin
  VDTReplays.Clear;
  VDTReplays.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoTristateTracking,toAutoDeleteMovedNodes];
  for i:=0 to ReplayList.Count-1 do
  begin
    if isReplayVisible(ReplayList[i]) then
    begin
      VDTReplays.RootNodeCount := VDTReplays.RootNodeCount + 1;
      TReplay(ReplayList[i]).Node := VDTReplays.GetLast;
    end
    else
      TReplay(ReplayList[i]).Node := nil;
  end;
  if VDTReplays.RootNodeCount = 0 then
  begin
    VDTPlayers.Refresh;
    Exit;
  end;
  VDTReplays.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoSort,toAutoTristateTracking,toAutoDeleteMovedNodes];
  VDTReplays.SortTree(VDTReplays.Header.SortColumn,VDTReplays.Header.SortDirection);

  RenameButton.Enabled := ReplayList.Count > 0;
  DeleteButton.Enabled := ReplayList.Count > 0;
  GradeComboBox.Enabled := ReplayList.Count > 0;

  ReplaysForm.VDTReplays.FocusedNode := ReplaysForm.VDTReplays.GetFirst;
  ReplaysForm.VDTReplays.Selected[ReplaysForm.VDTReplays.FocusedNode] := true;

  ReplaysForm.VDTReplaysClick;
end;

procedure TReplaysForm.chkEnableFiltersClick(Sender: TObject);
begin
  FilterReplayList;
end;

procedure TReplaysForm.FiltersButtonClick(Sender: TObject);
begin
  if FiltersTabs.Height = 0 then
  begin
    FiltersTabs.Height := 225;
    PanelTop.Height := PanelTop.Height + FiltersTabs.Height;
    FiltersButton.ImageIndex := 0;
  end
  else
  begin
    FiltersButton.ImageIndex := 1;
    PanelTop.Height := PanelTop.Height - FiltersTabs.Height;
    FiltersTabs.Height := 0;
  end;
  if FilterListCombo.ItemIndex = -1 then FilterListCombo.ItemIndex := 0;
end;

// TODO: recode the load save and update replay filters because it's pretty bad coded
procedure TReplaysForm.LoadReplayFiltersFromFile(inputFileName : string);
var
  Ini : TIniFile;
  i:integer;
  tmpStr: String;
  f: ^TFilterText;
begin
  //FilenamePath := VAR_FOLDER + '\' + 'replayFilters.ini';
  Ini := TIniFile.Create(inputFileName);
  i := 0;
  Filters.GameContinues := Ini.ReadBool('StaticFilters', 'GameContinues', True);
  Filters.ComEnd := Ini.ReadBool('StaticFilters', 'ComEnd', True);
  Filters.Lineage := Ini.ReadBool('StaticFilters', 'Lineage', True);
  Filters.FilterLimitDGun := Ini.ReadBool('StaticFilters', 'FilterLimitDGun', False);
  Filters.LimitDGun := Ini.ReadBool('StaticFilters', 'LimitDGun', False);
  Filters.FilterGhosted := Ini.ReadBool('StaticFilters', 'FilterGhosted', False);
  Filters.Ghosted := Ini.ReadBool('StaticFilters', 'Ghosted', False);
  Filters.FilterDiminishing := Ini.ReadBool('StaticFilters', 'FilterDiminishing', False);
  Filters.Diminishing := Ini.ReadBool('StaticFilters', 'Diminishing', False);
  Filters.Fixed := Ini.ReadBool('StaticFilters', 'Fixed', True);
  Filters.Random := Ini.ReadBool('StaticFilters', 'Random', True);
  Filters.ChooseInGame := Ini.ReadBool('StaticFilters', 'ChooseInGame', True);


  Filters.Metal.enabled := Ini.ReadBool('StaticFilters', 'Metal', False);
  Filters.Energy.enabled := Ini.ReadBool('StaticFilters', 'Energy', False);
  Filters.Units.enabled := Ini.ReadBool('StaticFilters', 'Units', False);
  Filters.Players.enabled := Ini.ReadBool('StaticFilters', 'Players', False);
  Filters.Length.enabled := Ini.ReadBool('StaticFilters', 'Length', False);
  Filters.FileSize.enabled := Ini.ReadBool('StaticFilters', 'FileSize', False);
  Filters.Grade.enabled := Ini.ReadBool('StaticFilters', 'Grade', False);

  tmpStr := Ini.ReadString('StaticFilters', 'GradeSign', 'sup');
  if tmpStr = 'sup' then
    Filters.Grade.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Grade.filterType := Inf
  else
    Filters.Grade.filterType := Equal;
  Filters.Grade.value := Ini.ReadInteger('StaticFilters', 'GradeValue', 200);

  tmpStr := Ini.ReadString('StaticFilters', 'FileSizeSign', 'sup');
  if tmpStr = 'sup' then
    Filters.FileSize.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.FileSize.filterType := Inf
  else
    Filters.FileSize.filterType := Equal;
  Filters.FileSize.value := Ini.ReadInteger('StaticFilters', 'FileSizeValue', 200);

  tmpStr := Ini.ReadString('StaticFilters', 'LengthSign', 'sup');
  if tmpStr = 'sup' then
    Filters.Length.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Length.filterType := Inf
  else
    Filters.Length.filterType := Equal;
  Filters.Length.value := Ini.ReadInteger('StaticFilters', 'LengthValue', 15);

  tmpStr := Ini.ReadString('StaticFilters', 'MetalSign', 'inf');
  if tmpStr = 'sup' then
    Filters.Metal.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Metal.filterType := Inf
  else
    Filters.Metal.filterType := Equal;
  Filters.Metal.value := Ini.ReadInteger('StaticFilters', 'MetalValue', 500);

  tmpStr := Ini.ReadString('StaticFilters', 'EnergySign', 'inf');
  if tmpStr = 'sup' then
    Filters.Energy.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Energy.filterType := Inf
  else
    Filters.Energy.filterType := Equal;
  Filters.Energy.value := Ini.ReadInteger('StaticFilters', 'EnergyValue', 500);

  tmpStr := Ini.ReadString('StaticFilters', 'UnitsSign', 'inf');
  if tmpStr = 'sup' then
    Filters.Units.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Units.filterType := Inf
  else
    Filters.Units.filterType := Equal;
  Filters.Units.value := Ini.ReadInteger('StaticFilters', 'UnitsValue', 100);

  tmpStr := Ini.ReadString('StaticFilters', 'PlayersSign', 'sup');
  if tmpStr = 'sup' then
    Filters.Players.filterType := Sup
  else if tmpStr = 'inf' then
    Filters.Players.filterType := Inf
  else
    Filters.Players.filterType := Equal;
  Filters.Players.value := Ini.ReadInteger('StaticFilters', 'PlayersValue', 5);

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
    else if tmpStr = 'DisabledUnits' then
      TFilterText(f^).filterType := DisabledUnits
    else if tmpStr = 'SpringVersion' then
      TFilterText(f^).filterType := SpringVersion
    else if tmpStr = 'FileName' then
      TFilterText(f^).filterType := FileName
    else if tmpStr = 'Players' then
      TFilterText(f^).filterType := Players
    else if tmpStr = 'MapModOption' then
      TFilterText(f^).filterType := MapModOption;

    TFilterText(f^).value := Ini.ReadString('TextFilter'+IntToStr(i),'Value','');
    TFilterText(f^).contains := Ini.ReadBool('TextFilter'+IntToStr(i),'Contains',True);
    TFilterText(f^).enabled := Ini.ReadBool('TextFilter'+IntToStr(i),'Enabled',True);
    TFilterText(f^).node := nil;
    Filters.TextFilters.Add(f);

    i := i+1;
  end;

  Ini.Free;
end;

procedure TReplaysForm.UpdateReplayFilters;
var
  i: integer;
begin
  chkFilterFixed.Checked := Filters.Fixed;
  chkFilterRandom.Checked := Filters.Random;
  chkFilterChooseInGame.Checked := Filters.ChooseInGame;
  chkFilterGameContinues.Checked := Filters.GameContinues;
  chkFilterComEnd.Checked := Filters.ComEnd;
  chkFilterLineage.Checked := Filters.Lineage;
  chkFilterLimitDGunFilter.Checked := Filters.FilterLimitDGun;
  chkFilterGhostedFilter.Checked := Filters.FilterGhosted;
  chkFilterDiminishingFilter.Checked := Filters.FilterDiminishing;
  chkFilterGhosted.Checked := Filters.Ghosted;
  chkFilterLimitDGun.Checked := Filters.LimitDGun;
  chkFilterDiminishing.Checked := Filters.Diminishing;
  chkFilterMetal.Checked := Filters.Metal.enabled;
  chkFilterEnergy.Checked := Filters.Energy.enabled;
  chkFilterUnits.Checked := Filters.Units.enabled;
  chkFilterFileSize.Checked := Filters.FileSize.enabled;
  chkFilterLength.Checked := Filters.Length.enabled;
  chkFilterPlayers.Checked := Filters.Players.enabled;
  chkFilterGrade.Checked := Filters.Grade.enabled;

  if Filters.Grade.filterType = Sup then
    btFilterGrade.Caption := '>'
  else if Filters.Grade.filterType = Inf then
    btFilterGrade.Caption := '<'
  else
    btFilterGrade.Caption := '=';
  speFilterGrade.Value := Filters.Grade.value;

  if Filters.Metal.filterType = Sup then
    btFilterMetal.Caption := '>'
  else if Filters.Metal.filterType = Inf then
    btFilterMetal.Caption := '<'
  else
    btFilterMetal.Caption := '=';
  speFilterMetal.Value := Filters.Metal.value;

  if Filters.Energy.filterType = Sup then
    btFilterEnergy.Caption := '>'
  else if Filters.Energy.filterType = Inf then
    btFilterEnergy.Caption := '<'
  else
    btFilterEnergy.Caption := '=';
  speFilterEnergy.Value := Filters.Energy.value;

  if Filters.Units.filterType = Sup then
    btFilterUnits.Caption := '>'
  else if Filters.Units.filterType = Inf then
    btFilterUnits.Caption := '<'
  else
    btFilterUnits.Caption := '=';
  speFilterUnits.Value := Filters.Units.value;

  if Filters.FileSize.filterType = Sup then
    btFilterFileSize.Caption := '>'
  else if Filters.FileSize.filterType = Inf then
    btFilterFileSize.Caption := '<'
  else
    btFilterFileSize.Caption := '=';
  speFilterFileSize.Value := Filters.FileSize.value;

  if Filters.Length.filterType = Sup then
    btFilterLength.Caption := '>'
  else if Filters.Length.filterType = Inf then
    btFilterLength.Caption := '<'
  else
    btFilterLength.Caption := '=';
  speFilterLength.Value := Filters.Length.value;

  if Filters.Players.filterType = Sup then
    btFilterPlayers.Caption := '>'
  else if Filters.Players.filterType = Inf then
    btFilterPlayers.Caption := '<'
  else
    btFilterPlayers.Caption := '=';
  speFilterPlayers.Value := Filters.Players.value;

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

procedure TReplaysForm.SaveReplayFiltersToFile(outputFileName : string);
var
  Ini : TIniFile;
  i:integer;
begin
  try
    //FilenamePath := VAR_FOLDER + '\' + 'replayFilters.ini';
    if FileExists(outputFileName) then
      DeleteFile(outputFileName);
    Ini := TIniFile.Create(outputFileName);
    i := 0;
    Ini.WriteBool('StaticFilters','GameContinues',Filters.GameContinues);
    Ini.WriteBool('StaticFilters','ComEnd',Filters.ComEnd);
    Ini.WriteBool('StaticFilters','Lineage',Filters.Lineage);
    Ini.WriteBool('StaticFilters','FilterLimitDGun',Filters.FilterLimitDGun);
    Ini.WriteBool('StaticFilters','LimitDGun',Filters.LimitDGun);
    Ini.WriteBool('StaticFilters','FilterGhosted',Filters.FilterGhosted);
    Ini.WriteBool('StaticFilters','Ghosted',Filters.Ghosted);
    Ini.WriteBool('StaticFilters','FilterDiminishing',Filters.FilterDiminishing);
    Ini.WriteBool('StaticFilters','Diminishing',Filters.Diminishing);
    Ini.WriteBool('StaticFilters','Fixed',Filters.Fixed);
    Ini.WriteBool('StaticFilters','Random',Filters.Random);
    Ini.WriteBool('StaticFilters','ChooseInGame',Filters.ChooseInGame);
    Ini.WriteBool('StaticFilters','Metal',Filters.Metal.enabled);
    Ini.WriteBool('StaticFilters','Energy',Filters.Energy.enabled);
    Ini.WriteBool('StaticFilters','Units',Filters.Units.enabled);
    Ini.WriteBool('StaticFilters','Players',Filters.Players.enabled);
    Ini.WriteBool('StaticFilters','Length',Filters.Length.enabled);
    Ini.WriteBool('StaticFilters','FileSize',Filters.FileSize.enabled);
    Ini.WriteBool('StaticFilters','Grade',Filters.Grade.enabled);

    if Filters.Players.filterType = Sup then
      Ini.WriteString('StaticFilters','PlayersSign','sup')
    else if Filters.Players.filterType = Inf then
      Ini.WriteString('StaticFilters','PlayersSign','inf')
    else
      Ini.WriteString('StaticFilters','PlayersSign','equal');
    Ini.WriteInteger('StaticFilters','PlayersValue',Filters.Players.value);

    if Filters.Metal.filterType = Sup then
      Ini.WriteString('StaticFilters','MetalSign','sup')
    else if Filters.Metal.filterType = Inf then
      Ini.WriteString('StaticFilters','MetalSign','inf')
    else
      Ini.WriteString('StaticFilters','MetalSign','equal');
    Ini.WriteInteger('StaticFilters','MetalValue',Filters.Metal.value);

    if Filters.Energy.filterType = Sup then
      Ini.WriteString('StaticFilters','EnergySign','sup')
    else if Filters.Energy.filterType = Inf then
      Ini.WriteString('StaticFilters','EnergySign','inf')
    else
      Ini.WriteString('StaticFilters','EnergySign','equal');
    Ini.WriteInteger('StaticFilters','EnergyValue',Filters.Energy.value);

    if Filters.Units.filterType = Sup then
      Ini.WriteString('StaticFilters','UnitsSign','sup')
    else if Filters.Units.filterType = Inf then
      Ini.WriteString('StaticFilters','UnitsSign','inf')
    else
      Ini.WriteString('StaticFilters','UnitsSign','equal');
    Ini.WriteInteger('StaticFilters','UnitsValue',Filters.Units.value);

    if Filters.Length.filterType = Sup then
      Ini.WriteString('StaticFilters','LengthSign','sup')
    else if Filters.Length.filterType = Inf then
      Ini.WriteString('StaticFilters','LengthSign','inf')
    else
      Ini.WriteString('StaticFilters','LengthSign','equal');
    Ini.WriteInteger('StaticFilters','LengthValue',Filters.Length.value);

    if Filters.FileSize.filterType = Sup then
      Ini.WriteString('StaticFilters','FileSizeSign','sup')
    else if Filters.FileSize.filterType = Inf then
      Ini.WriteString('StaticFilters','FileSizeSign','inf')
    else
      Ini.WriteString('StaticFilters','FileSizeSign','equal');
    Ini.WriteInteger('StaticFilters','FileSizeValue',Filters.FileSize.value);

    if Filters.Grade.filterType = Sup then
      Ini.WriteString('StaticFilters','GradeSign','sup')
    else if Filters.Grade.filterType = Inf then
      Ini.WriteString('StaticFilters','GradeSign','inf')
    else
      Ini.WriteString('StaticFilters','GradeSign','equal');
    Ini.WriteInteger('StaticFilters','GradeValue',Filters.Grade.value);

    for i:=0 to Filters.TextFilters.Count-1 do begin
      with TFilterText(Filters.TextFilters[i]^) do begin

        if filterType = HostName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Host')
        else if filterType = MapName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Map')
        else if filterType = ModName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Mod')
        else if filterType = DisabledUnits then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'DisabledUnits')
        else if filterType = SpringVersion then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'SpringVersion')
        else if filterType = FileName then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'FileName')
        else if filterType = Players then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Players')
        else if filterType = MapModOption then
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'MapModOption');

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

procedure TReplaysForm.FilterListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  filter : TFilterText;
begin
  filter := TFilterText(Filters.TextFilters[GetReplayFilterIndexFromNode(node)]^);

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
        CellText := 'Description'
      else if filter.filterType = DisabledUnits then
        CellText := 'Disabled Units'
      else if filter.filterType = SpringVersion then
        CellText := 'Spring Version'
      else if filter.filterType = FileName then
        CellText := 'File Name'
      else if filter.filterType = Players then
        CellText := 'Players'
      else if filter.filterType = MapModOption then
        CellText := 'Map/Mod option';
    2:
      if filter.contains then
        CellText := 'with'
      else
        CellText := 'without';
    3:CellText := filter.value;
  end;
end;

function TReplaysForm.GetReplayFilterIndexFromNode(Node : PVirtualNode): integer;
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

procedure TReplaysForm.chkFilterGameContinuesClick(Sender: TObject);
begin
  if not chkFilterGameContinues.Focused then Exit;
  Filters.GameContinues := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterComEndClick(Sender: TObject);
begin
  if not chkFilterComEnd.Focused then Exit;
  Filters.ComEnd := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterLineageClick(Sender: TObject);
begin
  if not chkFilterLineage.Focused then Exit;
  Filters.Lineage := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterLimitDGunFilterClick(Sender: TObject);
begin
  if not chkFilterLimitDGunFilter.Focused then Exit;
  Filters.FilterLimitDGun := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterGhostedFilterClick(Sender: TObject);
begin
  if not chkFilterGhostedFilter.Focused then Exit;
  Filters.FilterGhosted := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterDiminishingFilterClick(Sender: TObject);
begin
  if not chkFilterDiminishingFilter.Focused then Exit;
  Filters.FilterDiminishing := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterLimitDGunClick(Sender: TObject);
begin
  if not chkFilterLimitDGun.Focused then Exit;
  Filters.LimitDGun := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterGhostedClick(Sender: TObject);
begin
  if not chkFilterGhosted.Focused then Exit;
  Filters.Ghosted := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterDiminishingClick(Sender: TObject);
begin
  if not chkFilterDiminishing.Focused then Exit;
  Filters.Diminishing := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterMetalClick(Sender: TObject);
begin
  if not chkFilterMetal.Focused then Exit;
  Filters.Metal.enabled := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterEnergyClick(Sender: TObject);
begin
  if not chkFilterEnergy.Focused then Exit;
  Filters.Energy.enabled := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterUnitsClick(Sender: TObject);
begin
  if not chkFilterUnits.Focused then Exit;
  Filters.Units.enabled := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterPlayersClick(Sender: TObject);
begin
  if not chkFilterPlayers.Focused then Exit;
  Filters.Players.enabled := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterLengthClick(Sender: TObject);
begin
  if not chkFilterLength.Focused then Exit;
  Filters.Length.enabled := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterFileSizeClick(Sender: TObject);
begin
  if not chkFilterFileSize.Focused then Exit;
  Filters.FileSize.enabled := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterGradeClick(Sender: TObject);
begin
  if not chkFilterGrade.Focused then Exit;
  Filters.Grade.enabled := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterFixedClick(Sender: TObject);
begin
  if not chkFilterFixed.Focused then Exit;
  Filters.Fixed := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterRandomClick(Sender: TObject);
begin
  if not chkFilterRandom.Focused then Exit;
  Filters.Random := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.chkFilterChooseInGameClick(Sender: TObject);
begin
  if not chkFilterChooseInGame.Focused then Exit;
  Filters.ChooseInGame := (Sender as TSpTBXCheckBox).Checked;
  FiltersUpdated;
end;

procedure TReplaysForm.btFilterMetalClick(Sender: TObject);
begin
  with Filters.Metal do
  begin
    if (Sender as TSpTBXButton).Caption = '>' then
    begin
      (Sender as TSpTBXButton).Caption := '<';
      filterType := Inf;
    end
    else if (Sender as TSpTBXButton).Caption = '<' then
    begin
      (Sender as TSpTBXButton).Caption := '=';
      filterType := Equal;
    end
    else
    begin
      (Sender as TSpTBXButton).Caption := '>';
      filterType := Sup;
    end;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.btFilterEnergyClick(Sender: TObject);
begin
  with Filters.Energy do
  begin
    if (Sender as TSpTBXButton).Caption = '>' then
    begin
      (Sender as TSpTBXButton).Caption := '<';
      filterType := Inf;
    end
    else if (Sender as TSpTBXButton).Caption = '<' then
    begin
      (Sender as TSpTBXButton).Caption := '=';
      filterType := Equal;
    end
    else
    begin
      (Sender as TSpTBXButton).Caption := '>';
      filterType := Sup;
    end;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.btFilterUnitsClick(Sender: TObject);
begin
  with Filters.Units do
  begin
    if (Sender as TSpTBXButton).Caption = '>' then
    begin
      (Sender as TSpTBXButton).Caption := '<';
      filterType := Inf;
    end
    else if (Sender as TSpTBXButton).Caption = '<' then
    begin
      (Sender as TSpTBXButton).Caption := '=';
      filterType := Equal;
    end
    else
    begin
      (Sender as TSpTBXButton).Caption := '>';
      filterType := Sup;
    end;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.btFilterPlayersClick(Sender: TObject);
begin
  with Filters.Players do
  begin
    if (Sender as TSpTBXButton).Caption = '>' then
    begin
      (Sender as TSpTBXButton).Caption := '<';
      filterType := Inf;
    end
    else if (Sender as TSpTBXButton).Caption = '<' then
    begin
      (Sender as TSpTBXButton).Caption := '=';
      filterType := Equal;
    end
    else
    begin
      (Sender as TSpTBXButton).Caption := '>';
      filterType := Sup;
    end;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.btFilterLengthClick(Sender: TObject);
begin
  with Filters.Length do
  begin
    if (Sender as TSpTBXButton).Caption = '>' then
    begin
      (Sender as TSpTBXButton).Caption := '<';
      filterType := Inf;
    end
    else if (Sender as TSpTBXButton).Caption = '<' then
    begin
      (Sender as TSpTBXButton).Caption := '=';
      filterType := Equal;
    end
    else
    begin
      (Sender as TSpTBXButton).Caption := '>';
      filterType := Sup;
    end;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.btFilterFileSizeClick(Sender: TObject);
begin
  with Filters.FileSize do
  begin
    if (Sender as TSpTBXButton).Caption = '>' then
    begin
      (Sender as TSpTBXButton).Caption := '<';
      filterType := Inf;
    end
    else if (Sender as TSpTBXButton).Caption = '<' then
    begin
      (Sender as TSpTBXButton).Caption := '=';
      filterType := Equal;
    end
    else
    begin
      (Sender as TSpTBXButton).Caption := '>';
      filterType := Sup;
    end;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.btFilterGradeClick(Sender: TObject);
begin
  with Filters.Grade do
  begin
    if (Sender as TSpTBXButton).Caption = '>' then
    begin
      (Sender as TSpTBXButton).Caption := '<';
      filterType := Inf;
    end
    else if (Sender as TSpTBXButton).Caption = '<' then
    begin
      (Sender as TSpTBXButton).Caption := '=';
      filterType := Equal;
    end
    else
    begin
      (Sender as TSpTBXButton).Caption := '>';
      filterType := Sup;
    end;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.speFilterMetalChange(Sender: TObject);
begin
  if not speFilterMetal.Focused then Exit;
  with Filters.Metal do
  begin
    value := speFilterMetal.SpinOptions.ValueAsInteger;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.speFilterEnergyChange(Sender: TObject);
begin
  if not speFilterEnergy.Focused then Exit;
  with Filters.Energy do
  begin
    value := speFilterEnergy.SpinOptions.ValueAsInteger;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.speFilterUnitsChange(Sender: TObject);
begin
  if not speFilterUnits.Focused then Exit;
  with Filters.Units do
  begin
    value := speFilterUnits.SpinOptions.ValueAsInteger;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.speFilterPlayersChange(Sender: TObject);
begin
  if not speFilterPlayers.Focused then Exit;
  with Filters.Players do
  begin
    value := speFilterPlayers.SpinOptions.ValueAsInteger;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.speFilterLengthChange(Sender: TObject);
begin
  if not speFilterLength.Focused then Exit;
  with Filters.Length do
  begin
    value := speFilterLength.SpinOptions.ValueAsInteger;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.speFilterFileSizeChange(Sender: TObject);
begin
  if not speFilterFileSize.Focused then Exit;
  with Filters.FileSize do
  begin
    value := speFilterLength.SpinOptions.ValueAsInteger;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.speFilterGradeChange(Sender: TObject);
begin
  if not speFilterGrade.Focused then Exit;
  with Filters.Grade do
  begin
    value := speFilterGrade.SpinOptions.ValueAsInteger;
    if enabled then
      FiltersUpdated;
  end;
end;

procedure TReplaysForm.AddToFilterListButtonClick(Sender: TObject);
var
  f: ^TFilterText;
begin

  if FilterValueTextBox.Text = '' then Exit;
  New(f);
  case FilterListCombo.ItemIndex of
    0:f^.filterType := HostName;
    1:f^.filterType := MapName;
    2:f^.filterType := ModName;
    3:f^.filterType := DisabledUnits;
    4:f^.filterType := SpringVersion;
    5:f^.filterType := FileName;
    6:f^.filterType := Players;
    7:f^.filterType := MapModOption;
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
  FiltersUpdated;
end;

procedure TReplaysForm.RemoveFromFilterListButtonClick(Sender: TObject);
var
  i: integer;
  n: PVirtualNode;
begin
  n := FilterList.GetFirstSelected;
  while n <> nil do
  begin
    Filters.TextFilters.Delete(GetReplayFilterIndexFromNode(n));
    n := FilterList.GetNextSelected(n);
  end;
  FilterList.DeleteSelectedNodes;
  FiltersUpdated;
end;

procedure TReplaysForm.ClearFilterListButtonClick(Sender: TObject);
begin
  Filters.TextFilters.Clear;
  FilterList.Clear;
  FiltersUpdated;
end;

procedure TReplaysForm.FilterListChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
begin
  if not FilterList.Focused then Exit;
  TFilterText(Filters.TextFilters[GetReplayFilterIndexFromNode(Node)]^).enabled := NewState = csCheckedNormal;
  FiltersUpdated;
end;

procedure TReplaysForm.VDTReplaysColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
begin
  if WatchButton.Visible then
    WatchButtonClick(nil)
  else
    HostReplayButtonClick(nil);
end;

procedure TReplaysForm.VDTReplaysKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
    VDTReplaysClick;
  Key := 0;
end;

procedure TReplaysForm.FilterListCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  filter : TFilterText;
  filter2 : TFilterText;
  text1: String;
  text2: String;
begin
  filter := TFilterText(Filters.TextFilters[GetReplayFilterIndexFromNode(Node1)]^);

  case Column of
    1:
      if filter.filterType = HostName then
        text1 := _('Host')
      else if filter.filterType = MapName then
        text1 := _('Map')
      else if filter.filterType = ModName then
        text1 := _('Mod')
      else if filter.filterType = Description then
        text1 := _('Description');
    2:
      if filter.contains then
        text1 := _('with')
      else
        text1 := _('without');
    3:text1 := filter.value;
  end;

  filter2 := TFilterText(Filters.TextFilters[GetReplayFilterIndexFromNode(Node2)]^);

  case Column of
    0:
    begin
      if filter.enabled = filter2.enabled then
        Result := 0
      else
        if filter.enabled then
          Result := 1
        else
          Result := -1;
      Exit;
    end;
    1:
      if filter2.filterType = HostName then
        text2 := _('Host')
      else if filter2.filterType = MapName then
        text2 := _('Map')
      else if filter2.filterType = ModName then
        text2 := _('Mod')
      else if filter2.filterType = Description then
        text2 := _('Description');
    2:
      if filter2.contains then
        text2 := _('with')
      else
        text2 := _('without');
    3:text2 := filter2.value;
  end;

  Result := AnsiCompareStr(text1, text2);
end;

procedure TReplaysForm.FilterListHeaderClick(Sender: TVTHeader;
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

procedure TReplaysForm.VDTReplaysGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
var
  Replay: TReplay;
  s:String;
  tmp:string;
  i:integer;
begin
  Replay := GetReplayFromNode(Node);
  R := Rect(0, 0, 0, 0);

  with (Sender as TVirtualDrawTree) do
    case Column of
      0: // grade
        s := '';
      1: // date time
        s := DateTimeToStr(Replay.Date);
      2: // host name
        s := TReplayPlayer(Replay.PlayerList[0]^).UserName;
      3: // mod
        s := Replay.Script.ReadModName;
      4: // map
        s := Replay.Script.ReadMapName;
      5: // demo file size
        s := Misc.FormatFileSize(GetFileSize(Replay.FullFileName)) + ' KB';
      6: // game length
        if Replay.Version = 1 then
        begin
          s := TimeToStr(EncodeTime(Replay.demoHeader.gameTime div 3600,(Replay.demoHeader.gameTime div 60) mod 60,Replay.demoHeader.gameTime mod 60,0));
        end
        else
          s:= 'n/a';
      7: // spring version
        s := Replay.SpringVersion;
      8: // players
      begin
        if Replay.Version = 1 then
          tmp := IntToStr(Replay.demoHeader.maxPlayerNum)
        else
          tmp := '??';
        s := IntToStr(Replay.PlayerList.Count-Replay.GetSpectatorCount) +'+'+IntToStr(Replay.GetSpectatorCount)+'/' + tmp + '  ';
        for i:=0 to Replay.PlayerList.Count-1 do
          s := s + ' ' + TReplayPlayer(Replay.PlayerList[i]^).UserName;
      end;
      9: // file name
        s := Replay.FileName;
    end;

    if Column = 4 then
    begin
      if Utility.MapList.IndexOf(Replay.Script.ReadMapName) > -1 then
        R := Rect(0, 0, 110+250, 120)
      else
        R := Rect(0, 0, Canvas.TextWidth(Replay.Script.ReadMapName) + 20, 18);
    end
    else
    begin
      R := Rect(0, 0, Canvas.TextWidth(s)+20, 18)
    end;
end;

procedure TReplaysForm.VDTReplaysDrawHint(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  Replay: TReplay;
  s:String;
  tmp:string;
  i:integer;
begin
  with Sender as TVirtualDrawTree, HintCanvas do
  begin
    Replay := GetReplayFromNode(Node);

    Pen.Color := clBlack;
    Brush.Color := $00ffdddd; { 0 b g r }
    Brush.Style := bsSolid;
    Rectangle(ClipRect);
    Brush.Style := bsClear;

    case Column of
      0: // grade
        s := '';
      1: // date time
        s := DateTimeToStr(Replay.Date);
      2: // host name
        s := TReplayPlayer(Replay.PlayerList[0]^).UserName;
      3: // mod
        s := Replay.Script.ReadModName;
      4: // map
        s := Replay.Script.ReadMapName;
      5: // demo file size
        s := Misc.FormatFileSize(GetFileSize(Replay.FullFileName)) + ' KB';
      6: // game length
        if Replay.Version = 1 then
        begin
          s := TimeToStr(EncodeTime(Replay.demoHeader.gameTime div 3600,(Replay.demoHeader.gameTime div 60) mod 60,Replay.demoHeader.gameTime mod 60,0));
        end
        else
          s:= 'n/a';
      7: // spring version
        s := Replay.SpringVersion;
      8: // players
      begin
        if Replay.Version = 1 then
          tmp := IntToStr(Replay.demoHeader.maxPlayerNum)
        else
          tmp := '??';
        s := IntToStr(Replay.PlayerList.Count-Replay.GetSpectatorCount) +'+'+IntToStr(Replay.GetSpectatorCount)+'/' + tmp + '  ';
        for i:=0 to Replay.PlayerList.Count-1 do
          s := s + ' ' + TReplayPlayer(Replay.PlayerList[i]^).UserName;
      end;
      9: // file name
        s := Replay.FileName;
    end;

    if Column = 4 then
    begin
      if Utility.MapList.IndexOf(Replay.Script.ReadMapName) > -1 then
      begin
        with TMapItem(MapListForm.Maps[Utility.MapList.IndexOf(Replay.Script.ReadMapName)]) do
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
      end;
    end
    else
      TextOut(5, 2, s);
  end;
end;

procedure TReplaysForm.DeleteAllVisibleButtonClick(Sender: TObject);
var
  i : integer;
begin
  if MessageDlg(_('Are you sure you want to delete all visible replays ?'), mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  for i:=0 to ReplayList.Count-1 do
    if TReplay(ReplayList[i]).Node <> nil then
      DeleteFile(TReplay(ReplayList[i]).FullFileName);

  ReloadButtonClick(nil);
end;

procedure TReplaysForm.btSavePresetClick(Sender: TObject);
begin
  if PresetListbox.Items.IndexOf(PresetNameTextbox.Text) >= 0 then
  begin
    if MessageDlg(_('A preset with this name already exists, do you want to replace it ?'),mtWarning,[mbYes, mbNo],0) = mrNo then
      Exit;
    PresetListbox.ItemIndex := PresetListbox.Items.IndexOf(PresetNameTextbox.Text);
  end
  else
  begin
    PresetListbox.Items.Add(PresetNameTextbox.Text);
    PresetListbox.ItemIndex := PresetListbox.Count-1;
  end;

  SaveReplayFiltersToFile(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER + '\'+PresetNameTextbox.Text+'.ini');
end;

procedure TReplaysForm.btClearPresetClick(Sender: TObject);
var
  i: integer;
begin
  for i:=PresetListbox.Count-1 downto 1 do
  begin
    DeleteFile(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER + '\' + PresetListbox.Items[i] + '.ini');
    PresetListbox.Items.Delete(i);
  end;
  PresetListbox.Selected[0] := true;
end;

procedure TReplaysForm.LoadReplayFiltersPresets;
var
  FileAttrs: Integer;
  sr: TSearchRec;
begin
  FileAttrs := faAnyFile;
  if FindFirst(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER + '\*.ini', FileAttrs, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') and (sr.Name <> 'current.ini') then
      begin
        PresetListbox.Items.Add(LeftStr(''+sr.Name,Length(''+sr.Name)-4));
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TReplaysForm.initFiltersPresets;
begin
  FiltersTabs.ActiveTabIndex := 0;
  Filters.TextFilters := TList.Create;
  LoadReplayFiltersFromFile(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER + '\current.ini');
  UpdateReplayFilters;
  PresetListbox.Selected[0] := true;
  LoadReplayFiltersPresets;
end;

procedure TReplaysForm.FiltersUpdated;
begin
  PresetListbox.Selected[0] := true;
  FilterReplayList;
end;

procedure TReplaysForm.PresetListboxDblClick(Sender: TObject);
begin
  if (PresetListbox.ItemIndex = 0) or not FileExists(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER + '\' + PresetListbox.Items[PresetListbox.ItemIndex] + '.ini') then Exit;
  LoadReplayFiltersFromFile(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER + '\' + PresetListbox.Items[PresetListbox.ItemIndex] + '.ini');
  UpdateReplayFilters;
  FilterReplayList;
end;

procedure TReplaysForm.PresetListboxClick(Sender: TObject);
begin
  if (PresetListbox.ItemIndex = 0) then Exit;
  PresetNameTextbox.Text := PresetListbox.Items[PresetListbox.ItemIndex];
end;

procedure TReplaysForm.FilterListEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column = 3;
end;

procedure TReplaysForm.FilterListClick(Sender: TObject);
var
  ht: THitInfo;
  pt: TPoint;
begin
  GetCursorPos(pt);
  pt := FilterList.ScreenToClient(pt);
  FilterList.GetHitTestInfoAt(pt.X,pt.Y,False,ht);
  FilterList.FocusedColumn := ht.HitColumn;
end;

procedure TReplaysForm.FilterListNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
  TFilterText(Filters.TextFilters[GetReplayFilterIndexFromNode(Node)]^).value := NewText;
  FiltersUpdated;
end;

procedure TReplaysForm.btDeletePresetClick(Sender: TObject);
begin
  if PresetListbox.ItemIndex = 0 then Exit;
  DeleteFile(ExtractFilePath(Application.ExeName) + REPLAY_FILTERS_FOLDER + '\' + PresetListbox.Items[PresetListbox.ItemIndex] + '.ini');
  PresetListbox.Items.Delete(PresetListbox.ItemIndex);
  PresetListbox.Selected[0] := true;
end;

procedure TReplaysForm.FilterListHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

procedure TReplaysForm.VDTReplaysHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

procedure TReplaysForm.VDTPlayersHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

procedure TReplaysForm.FilterListDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: WideString; const CellRect: TRect; var DefaultDraw: Boolean);
begin
  MainForm.FilterListDrawText(Sender,TargetCanvas,Node,Column,Text,CellRect,DefaultDraw);
end;

procedure TReplaysForm.FilterListPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Style := [];
  inherited;
end;

procedure TReplaysForm.FormShow(Sender: TObject);
begin
  if ReplayList.Count = 0 then
   ReloadButtonClick(nil);
end;

function TReplaysForm.ReadTeamStats(var replay: TReplay ): Boolean;
var
  f: file of Byte;
  s: string;
  i,j: integer;
  numStatsForTeam: integer;
  replayTeam: PReplayTeam;
  teamStats: TTeamStatistics;
begin
  Result := False;

  {$I+}
  try
    if replay.demoHeader.numTeams <> replay.TeamList.Count then
      raise Exception.Create('Incorrect number of team in replay');

    AssignFile(f, replay.FullFileName);

    Reset(f);

    Seek(f,replay.demoHeader.headerSize + replay.demoHeader.scriptSize + replay.demoHeader.demoStreamSize + replay.demoHeader.playerStatSize +1 );

    // read number of starts per team
    for i:=0 to replay.demoHeader.numTeams-1 do
    begin
      replayTeam := replay.GetTeam(i);
      BlockRead(f, numStatsForTeam, 4 );
      if (numStatsForTeam < 0) or (numStatsForTeam > 2000) then
        raise Exception.Create('Incorrect number of stats for one team');
      SetLength( replayTeam.Stats, numStatsForTeam );
    end;

    // read the team stats
    for i:=0 to replay.demoHeader.numTeams-1 do
    begin
      replayTeam := replay.GetTeam(i);
      
      for j:=0 to Length(replayTeam.Stats)-1 do
      begin
        BlockRead(f, replayTeam.Stats[j], sizeof(replayTeam.Stats[j]) );
      end;
    end;

    CloseFile(f);

  except
    on E:Exception do
    begin
      if Debug.Enabled then
      begin
        MainForm.AddMainLog('Error when reading replay team stats ('+replay.FullFileName+'): ' + E.Message,Colors.Error);
      end;

      try
        CloseFile(f);
      except
      end;

      Exit;
    end;
  end;

  Result := True;
end;

procedure TReplaysForm.UpdateTeamStatsGraph;
var
  Replay: TReplay;
  i,j: integer;
  replayTeam: PReplayTeam;
  rsLineChart: ^TRSLineChart;
  value: double;
begin
  Replay := GetReplayFromNode(VDTReplays.FocusedNode);

  if NOT Replay.TeamStatsAvailable then
  begin
    for i:=0 to FTeamLineCharts.Count-1 do
    begin
      rsLineChart := FTeamLineCharts.Items[i];
      rsLineChart.Visible := false;
    end;
    Exit;
  end;

  // first make two TRSLineChart for every team (one for the line and one for the dashed)
  if FTeamLineCharts.Count <= 2*Replay.TeamList.Count then
  begin
    // we need more TRSLineChart
    while 2*Replay.TeamList.Count - FTeamLineCharts.Count <> 0 do
    begin
      New(rsLineChart);
      rsLineChart^ := TRSLineChart.Create(self);
      rsLineChart.Parent := rscTSGChart;
      rsLineChart.Options := [];
      FTeamLineCharts.Add(rsLineChart);
    end;
  end
  else
  begin
    // we have too many TRSLineChart
    while 2*Replay.TeamList.Count - FTeamLineCharts.Count <> 0 do
    begin
      rsLineChart := FTeamLineCharts.Items[0];
      FTeamLineCharts.Remove(rsLineChart);
      rsLineChart.Free;
      FreeMem(rsLineChart);
    end;
  end;

  // bold
   for i:=0 to Replay.TeamList.Count-1 do
  begin
    replayTeam := PReplayTeam(Replay.TeamList[i]);
    rsLineChart := FTeamLineCharts.Items[i];
    rsLineChart.Color := PReplayPlayer(replayTeam.PlayerList.items[0]).Color;
    rsLineChart.Pen.Width := 2;
    rsLineChart.Values.Clear;

    if cmbTSGEnableLine.Checked and lstTSGPlayers.Checked[i] then
    begin
      rsLineChart.Visible := true;
      for j:=0 to Length(replayTeam.Stats)-1 do
      begin
        rsLineChart.Values.Add( Replay.demoHeader.teamStatPeriod*j/60., GetValueFromStats( replayTeam.Stats[j], lstTSGLineStat) );
      end;
    end
    else
    begin
      rsLineChart.Visible := false;
    end;
  end;

  // thin
  for i:=0 to Replay.TeamList.Count-1 do
  begin
    replayTeam := PReplayTeam(Replay.TeamList[i]);
    rsLineChart := FTeamLineCharts.Items[Replay.TeamList.Count+i];
    rsLineChart.Color := PReplayPlayer(replayTeam.PlayerList.items[0]).Color;
    rsLineChart.Pen.Width := 1;
    rsLineChart.Values.Clear;

    if cmbTSGEnableDashed.Checked and lstTSGPlayers.Checked[i] then
    begin
      rsLineChart.Visible := true;
      for j:=0 to Length(replayTeam.Stats)-1 do
      begin
        rsLineChart.Values.Add( Replay.demoHeader.teamStatPeriod*j/60., GetValueFromStats( replayTeam.Stats[j], lstTSGDashedStat) );
      end;
    end
    else
    begin
      rsLineChart.Visible := false;
    end;
  end;

  // make sure the axes are visible
  rscTSGChart.BottomAxis.Visible := true;
  rscTSGChart.LeftAxis.Visible := true;
end;

procedure TReplaysForm.rscTSGChartDblClick(Sender: TObject);
begin
  rscTSGChart.UnZoom();
end;

procedure TReplaysForm.lstTSGLineStatClick(Sender: TObject);
begin
  UpdateTeamStatsGraph;
end;

function TReplaysForm.GetValueFromStats( var stats: TTeamStatistics; var listBox: TSpTBXListBox ): double;
begin
  case listBox.ItemIndex of
    0: Result := stats.metalUsed;
    1: Result := stats.energyUsed;
    2: Result := stats.metalProduced;
    3: Result := stats.energyProduced;
    4: Result := stats.metalReceived;
    5: Result := stats.energyReceived;
    6: Result := stats.metalSent;
    7: Result := stats.energySent;
    8: Result := stats.damageDealt;
    9: Result := stats.damageReceived;
    10: Result := stats.unitsProduced;
    11: Result := stats.unitsDied;
    12: Result := stats.unitsReceived;
    13: Result := stats.unitsSent;
    14: Result := stats.unitsCaptured;
    15: Result := stats.unitsOutCaptured;
    16: Result := stats.unitsKilled;
  else
    Result := stats.metalUsed;
  end;
end;

procedure TReplaysForm.lstTSGDashedStatClick(Sender: TObject);
begin
  UpdateTeamStatsGraph;
end;

procedure TReplaysForm.cmbTSGEnableLineClick(Sender: TObject);
begin
  UpdateTeamStatsGraph;
end;

procedure TReplaysForm.cmbTSGEnableDashedClick(Sender: TObject);
begin
  UpdateTeamStatsGraph;
end;

procedure TReplaysForm.lstTSGPlayersDrawItem(Sender: TObject;
  ACanvas: TCanvas; var ARect: TRect; Index: Integer;
  const State: TOwnerDrawState; const PaintStage: TSpTBXPaintStage;
  var PaintDefault: Boolean);
var
  Replay : TReplay;
  TempPenColor: TColor;
  TempBrushColor: TColor;
  ReplayTeam: PReplayTeam;
  Players: string;
  i: integer;
begin
  Replay := GetReplayFromNode(VDTReplays.FocusedNode);
  ReplayTeam := PReplayTeam(Replay.TeamList[Index]);
  PaintDefault := false;

  if ReplayTeam.PlayerList.Count = 0 then
    Exit;

  with ACanvas do
  begin
    TempPenColor := Pen.Color;
    TempBrushColor := Brush.Color;
    Brush.Color := PReplayPlayer(ReplayTeam.PlayerList[0]).Color;
    Pen.Color := clGray;
    Ellipse(ARect.Left + 2, ARect.Top + 2, ARect.Left + 13, ARect.Top + 13);
    Pen.Color := TempPenColor;
    Brush.Color := TempBrushColor;
    Brush.Style := Graphics.bsClear;

    Players := PReplayPlayer(ReplayTeam.PlayerList[0]).UserName;
    for i:=1 to ReplayTeam.PlayerList.Count -1 do
      Players := Players + ', ' + PReplayPlayer(ReplayTeam.PlayerList[i]).UserName;

    TextOut(ARect.Left + 15,ARect.Top,Players);
  end;
end;

procedure TReplaysForm.btTSGNoneClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to lstTSGPlayers.Count-1 do
    lstTSGPlayers.Checked[i] := false;
  UpdateTeamStatsGraph;
end;

procedure TReplaysForm.btTSGAllClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to lstTSGPlayers.Count-1 do
    lstTSGPlayers.Checked[i] := true;
  UpdateTeamStatsGraph;
end;

procedure TReplaysForm.lstTSGPlayersClick(Sender: TObject);
begin
  UpdateTeamStatsGraph;
end;

procedure TReplaysForm.btTSGCollapseClick(Sender: TObject);
begin
  if btTSGCollapse.ImageIndex = 3 then
  begin
    btTSGCollapse.Visible := False;
    btTSGCollapse.Align := alRight;
    pnlTSGOptions.Visible := True;
    btTSGCollapse.Visible := True;
    sptTSGOptions.Visible := True;
    btTSGCollapse.Align := alLeft;
    btTSGCollapse.ImageIndex := 2;
  end
  else
  begin
    sptTSGOptions.Visible := False;
    pnlTSGOptions.Visible := False;
    btTSGCollapse.ImageIndex := 3;
  end;
end;

end.
