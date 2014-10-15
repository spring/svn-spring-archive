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
  TntStdCtrls, SpTBXEditors, TBXDkPanels, SpTBXTabs, TB2Item, TBX,
  SpTBXItem, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP,MainUnit,DateUtils, VirtualTrees,Utility, Mask, JvExMask, JvSpin,IniFiles,MapListFormUnit;

type
  TReplaysForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    LoadingPanel: TSpTBXPanel;
    LoadingLabel: TSpTBXLabel;
    VDTReplays: TVirtualDrawTree;
    BottomPanel: TPanel;
    SpTBXLabel1: TSpTBXLabel;
    GradeComboBox: TSpTBXComboBox;
    PageControl1: TSpTBXTabControl;
    PlayersTab: TSpTBXTabItem;
    SpTBXTabItem2: TSpTBXTabItem;
    SpTBXTabItem1: TSpTBXTabItem;
    SpTBXTabSheet2: TSpTBXTabSheet;
    CommentsRichEdit: TRichEdit;
    SpTBXTabSheet1: TSpTBXTabSheet;
    ScriptRichEdit: TRichEdit;
    SpTBXTabSheet3: TSpTBXTabSheet;
    VDTPlayers: TVirtualDrawTree;
    HostReplayButton: TSpTBXButton;
    WatchButton: TSpTBXButton;
    CloseButton: TSpTBXButton;
    DownloadButton: TSpTBXButton;
    UploadButton: TSpTBXButton;
    SaveButton: TSpTBXSpeedButton;
    RenameButton: TSpTBXSpeedButton;
    DeleteButton: TSpTBXSpeedButton;
    ReloadButton: TSpTBXSpeedButton;
    SpTBXSplitter1: TSpTBXSplitter;
    SpTBXTabItem3: TSpTBXTabItem;
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
    frmDisabledUnits: TSpTBXGroupBox;
    lstDisabledUnits: TSpTBXListBox;
    SpTBXGroupBox1: TSpTBXGroupBox;
    lstLuaOptions: TSpTBXListBox;
    SpTBXLabel2: TSpTBXLabel;
    SpTBXLabel3: TSpTBXLabel;
    SpTBXLabel4: TSpTBXLabel;
    PanelTop: TPanel;
    FiltersButton: TSpTBXButton;
    frmFilters: TSpTBXGroupBox;
    SpTBXGroupBox3: TSpTBXGroupBox;
    chkFilterFixed: TSpTBXCheckBox;
    chkFilterRandom: TSpTBXCheckBox;
    chkFilterChooseInGame: TSpTBXCheckBox;
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
    speFilterMetal: TJvSpinEdit;
    speFilterEnergy: TJvSpinEdit;
    speFilterUnits: TJvSpinEdit;
    chkFilterPlayers: TSpTBXCheckBox;
    btFilterPlayers: TSpTBXButton;
    speFilterPlayers: TJvSpinEdit;
    chkFilterLength: TSpTBXCheckBox;
    btFilterLength: TSpTBXButton;
    speFilterLength: TJvSpinEdit;
    speFilterFileSize: TJvSpinEdit;
    btFilterFileSize: TSpTBXButton;
    chkFilterFileSize: TSpTBXCheckBox;
    chkFilterGrade: TSpTBXCheckBox;
    btFilterGrade: TSpTBXButton;
    speFilterGrade: TJvSpinEdit;
    FilterList: TVirtualStringTree;
    SpTBXPanel2: TSpTBXPanel;
    FilterListCombo: TSpTBXComboBox;
    ContainsRadio: TSpTBXRadioButton;
    DoNotContainsRadio: TSpTBXRadioButton;
    FilterValueTextBox: TSpTBXEdit;
    AddToFilterListButton: TSpTBXButton;
    RemoveFromFilterListButton: TSpTBXButton;
    ClearFilterListButton: TSpTBXButton;
    chkEnableFilters: TSpTBXCheckBox;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure EnumerateReplayList;
    function ReadScriptFromDemo(DemoFileName: string; var Script: string): Boolean;
    function ReadScriptFromDemo2(DemoFileName: string; var Script: string): Boolean;
    function FillPlayersInReplay(var replay: TReplay):boolean;
    function ReadHeaderFromDemo2(var replay: TReplay): Boolean;
    function LoadReplay(Replay: TReplay): Boolean;
    procedure SaveCommentsToScript(var Script: TScript; Comments: TStrings; Grade: Byte);
    procedure ReadCommentsFromScript(Script: TScript; Comments: TStrings; var Grade: Byte);
    function ChangeScriptInDemo(DemoFileName, Script: string): Boolean;
    function ChangeScriptInDemo2(DemoFileName, Script: string): Boolean;
    function ReadGradeFromScript(Script: string): Byte;
    function ValidateComments(Comments: TStrings): Boolean;

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
    function GetReplayPlayerFromNode(Node: PVirtualNode): TReplayPlayer;
    procedure VDTReplaysDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure VDTReplaysCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VDTReplaysHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure InitVDTForRefresh;
    procedure TerminateVDTRefresh;
    procedure VDTReplaysClick(Sender: TObject);overload;
    procedure VDTPlayersDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure VDTPlayersCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VDTPlayersHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
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
    procedure frmFiltersResize(Sender: TObject);
    procedure VDTReplaysColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure VDTReplaysKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FilterListCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FilterListHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure VDTReplaysGetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure VDTReplaysDrawHint(Sender: TBaseVirtualTree;
      HintCanvas: TCanvas; Node: PVirtualNode; R: TRect;
      Column: TColumnIndex);
  private
    { Private declarations }
  public
    procedure VDTReplaysClick;overload;
    function isReplayVisible(Replay: TReplay):boolean;
    procedure FilterReplayList;
    procedure LoadReplayFiltersFromFile;
    procedure UpdateReplayFilters;
    procedure SaveReplayFiltersToFile;
    function GetReplayFilterIndexFromNode(Node : PVirtualNode): integer;
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
  UploadReplayUnit;

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

procedure TReplaysForm.EnumerateReplayList;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  rep: TReplay;
  st: string;
  StartTime: Cardinal;
  s: TScript;
  dateFormat: TFormatSettings;
  tmp:String;
  i: integer;
begin
  // old replay date format '2007-11-4 16:15: 4 GMT'
  dateFormat.DateSeparator := '-';
  dateFormat.TimeSeparator := ':';
  dateFormat.ShortDateFormat := 'yyyy-mm-d hh:nn:ss';

  StartTime := GetTickCount;

  for i:=0 to ReplayList.Count-1 do
    try
      TReplay(ReplayList[i]).Free;
    except
      //
    end;
  ReplayList.Clear;
  VDTReplays.Clear;

  FileAttrs := faAnyFile;

  if FindFirst(ExtractFilePath(Application.ExeName) + 'demos\*.sdf', FileAttrs, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        rep := TReplay.Create;
        rep.FileName := sr.Name;
        rep.FullFileName := ExtractFilePath(Application.ExeName) + 'Demos\' + sr.Name;
        rep.Version := 0;
        if not ReplaysForm.ReadScriptFromDemo(rep.FullFileName, st) then
        begin
          ReplaysForm.ReadScriptFromDemo2(rep.FullFileName, st);
          rep.Version := 1;
        end;
        s := TScript.Create(st);
        rep.Script := s;
        rep.Grade := ReplaysForm.ReadGradeFromScript(st);
        if rep.Version = 0 then
        begin
          rep.SpringVersion := s.ReadKeyValue('VERSION/GameVersion');
          tmp := s.ReadKeyValue('VERSION/unixtime');
          if tmp <> '' then
             rep.Date := UnixToDateTime(StrToInt64(tmp))
          else
              rep.Date := StrToDateTime(s.ReadKeyValue('VERSION/DateTime'),dateFormat);
        end
        else
        begin
          ReadHeaderFromDemo2(rep);
          rep.Date := UnixToDateTime(rep.demoHeader.unixTime);
          rep.SpringVersion := StringReplace(rep.demoHeader.versionString,'spring','',[rfReplaceAll,rfIgnoreCase]);
        end;
        if ((rep.Version = 0) or ((rep.Version = 1) and (rep.demoHeader.magic = 'spring demofile'))) and FillPlayersInReplay(rep) then
        begin
          ReplayList.Add(rep);
          if isReplayVisible(rep) then
          begin
            VDTReplays.RootNodeCount := VDTReplays.RootNodeCount +1;
            rep.Node := VDTReplays.GetLast;
          end;
        end
        else
          rep.Free;
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
    MessageDlg('Invalid character found in comments: ";". Please remove any ";" from the comments before saving them!', mtWarning, [mbOK], 0);
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
    SetLength(s, 64);
    f1.Read(s[1], 64);
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

// returns True if successful and writes result to Script , read the new demofiles
function TReplaysForm.ReadScriptFromDemo2(DemoFileName: string; var Script: string): Boolean;
var
  f: file of Byte;
  s: string;
  scriptPos: integer;
  scriptLength: integer;
  headerSize: integer;
begin
  Result := False;

  AssignFile(f, DemoFileName);

  {$I+}
  try
    Reset(f);

    Seek(f,20);
    BlockRead(f, headerSize, 4);

    Seek(f,64);
    BlockRead(f, scriptLength, 4);

    scriptPos := headerSize;

    Seek(f,scriptPos);

    SetLength(s, scriptLength);
    BlockRead(f, s[1], scriptLength);
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
begin
  Result := False;

  AssignFile(f, replay.FullFileName);

  {$I+}
  try
    Reset(f);

    //Seek(f,0);
    BlockRead(f, replay.demoHeader, sizeof(replay.demoHeader));

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
      Seek(f,replay.demoHeader.headerSize + replay.demoHeader.scriptSize + replay.demoHeader.demoStreamSize);
    except
      CloseFile(f);
      MainForm.AddMainLog('Error : couldn''t open the replay file '+replay.FileName,Colors.Error);
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
      Player^.Free;
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
        Player^.Free;
        FreeMem(player);
        Exit;
      end;
      player^.Id := StrToInt(tmp)+1;

      tmp := replay.Script.ReadKeyValue('GAME/team'+ IntToStr(player^.Id-1)+'/allyteam');
      if (tmp = '') then
      begin
        Result := false;
        sl.Free;
        if doReadPlayerStats then
          CloseFile(f);
        Player^.Free;
        FreeMem(player);
        Exit;
      end;
      player^.Team := StrToInt(tmp)+1;

      tmp := replay.Script.ReadKeyValue('GAME/team'+ IntToStr(player^.Id-1)+'/rgbcolor');
      if (tmp = '') then
      begin
        Result := false;
        sl.Free;
        if doReadPlayerStats then
          CloseFile(f);
        Player^.Free;
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
        Player^.Free;
        FreeMem(player);
        Exit;
      end;
    end;
    replay.PlayerList.Add(Player);

    if doReadPlayerStats then
    begin
      try
        BlockRead(f, Player^.Stats, sizeof(Player^.Stats));
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
  PageControl1.ActiveTabIndex := 0;
  LoadingPanel.Height := ReplaysForm.ClientHeight-PanelTop.Top-PanelTop.Left;
  LoadingPanel.Width := ReplaysForm.ClientWidth-PanelTop.Left*2;
  LoadingPanel.Top := PanelTop.Top;
  LoadingPanel.Left := PanelTop.Left;

  Filters.TextFilters := TList.Create;

  FixFormSizeConstraints(self);

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
  PlayersTab.Caption := 'Players';
  if Replay = nil then Exit;

  VDTPlayers.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoTristateTracking,toAutoDeleteMovedNodes];
  for i:=0 to Replay.PlayerList.Count-1 do
  begin
    VDTPlayers.RootNodeCount := VDTPlayers.RootNodeCount + 1;
    TReplayPlayer(Replay.PlayerList[i]^).Node := VDTPlayers.GetLast;
  end;
  VDTPlayers.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoSort,toAutoTristateTracking,toAutoDeleteMovedNodes];
  VDTPlayers.SortTree(VDTPlayers.Header.SortColumn,VDTPlayers.Header.SortDirection);

  PlayersTab.Caption := 'Players (' + IntToStr(Replay.PlayerList.Count) + ')';

  Result := True;
  LoadingReplay := False;

  ScriptRichEdit.Text := Replay.Script.Script;
  ReadCommentsFromScript(Replay.Script, CommentsRichEdit.Lines, b);
  GradeComboBox.ItemIndex := Min(b, 10); // 11 grades max. (0..10)
  SaveButton.Enabled := False;

  try
    lblStartPos.Caption := 'Start pos : '+BattleForm.StartPosRadioGroup.Items[Replay.Script.ReadStartPosType];
    lblGameEnd.Caption := 'Game end condition: '+BattleForm.GameEndRadioGroup.Items[Replay.Script.ReadGameMode];
    lblMetal.Caption := 'Start metal : '+IntToStr(Replay.Script.ReadStartMetal);
    lblEnergy.Caption := 'Start energy : '+IntToStr(Replay.Script.ReadStartEnergy);
    lblMaxUnits.Caption := 'Max units : '+IntToStr(Replay.Script.ReadMaxUnits);
    chkLimiteDGun.Checked := Replay.Script.ReadLimitDGun;
    chkGhosted.Checked := Replay.Script.ReadGhostedBuildings;
    chkDiminishing.Checked := Replay.Script.ReadDiminishingMMs;
  except
    on E: Exception do MessageDlg(E.Message,mtError,[mbOk],E.HelpContext);
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

end;

procedure TReplaysForm.WatchButtonClick(Sender: TObject);
var
  FileName: string;
  springDir: string;
  Replay: TReplay;
  springExeVersion: String;
begin
  if BattleForm.IsBattleActive and Status.Me.GetReadyStatus then
    if MessageDlg('You cannot be ready in a battle and watch replays at the same time. Do you wish to unready now?', mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit
    else BattleForm.ReadyButton.OnClick(BattleForm.ReadyButton);

  Replay := GetReplayFromNode(VDTReplays.FocusedNode);
  FileName := Replay.FullFileName;

  springDir := ExtractFilePath(Application.ExeName)+'OldSpring\'+Replay.SpringVersion+'\';
  if not FileExists(springDir+'spring.exe') then
  begin
    springExeVersion := GetSpringVersionFromEXE;
    if springExeVersion <> Replay.SpringVersion then
      if MessageDlg(springDir + 'spring.exe not found.'+EOL+EOL+'Watching a replay with the wrong spring version may not work.'+EOL+EOL+'Watch with the default spring.exe ('+springExeVersion+') ?',mtWarning,[mbYes,mbNo],0) = mrNo then
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
  ShellExecute(MainForm.Handle, nil, PChar(springDir+'spring.exe'), PChar(AnsiString(Replay.FileName)), PChar(springDir), SW_SHOW);
end;

procedure TReplaysForm.DeleteButtonClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete ' + GetReplayFromNode(VDTReplays.FocusedNode).FileName + '?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
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
    MessageDlg('Error: unable to write file!', mtError, [mbOK], 0);
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
  if not InputQuery('Rename file', 'New name:', s) then Exit;
  if Copy(s, Length(s) - 3, 4) <> '.sdf' then s := s + '.sdf';
  if not RenameFile(OldName, ExtractFilePath(Application.ExeName) + 'demos\' + s) then
  begin
    MessageDlg('Rename file failed!', mtWarning, [mbOK], 0);
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
  LoadingLabel.Left := LoadingPanel.Width div 2 - LoadingLabel.Width div 2;
  LoadingLabel.Top := LoadingPanel.Height div 2 - LoadingLabel.Height div 2;
end;

procedure TReplaysForm.DownloadButtonClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://replays.unknown-files.net/');
end;

procedure TReplaysForm.UploadButtonClick(Sender: TObject);
var
  i,j:integer;
  teamCount : array[0..15] of integer;
  Replay: TReplay;
begin
  { disable while the replay site is down
  Replay := GetReplayFromNode(VDTReplays.FocusedNode);
  for i:=0 to 15 do
    teamCount[i] := 0;
  UploadReplayForm.FileName := Replay.FullFileName;
  UploadReplayForm.MapName := Copy(Replay.Script.ReadKeyValue('GAME/mapname'),0,Length(Replay.Script.ReadKeyValue('GAME/mapname'))-4);
  UploadReplayForm.ModName := Copy(Replay.Script.ReadKeyValue('GAME/gametype'),0,Length(Replay.Script.ReadKeyValue('GAME/mapname'))-4);
  i := Pos('AllyTeam=',ScriptRichEdit.Text);
  while i > 0 do begin
    i := i+9;
    j := PosEx(';',ScriptRichEdit.Text,i);
    Inc(teamCount[StrToInt(Copy(ScriptRichEdit.Text,i,j-i))]);
    i := PosEx('AllyTeam=',ScriptRichEdit.Text,i);
  end;
  UploadReplayForm.NbPlayers := '';
  for i:= 0 to 15 do
    if teamCount[i] > 0 then
      if UploadReplayForm.NbPlayers = '' then
        UploadReplayForm.NbPlayers := IntToStr(teamCount[i])
      else
        UploadReplayForm.NbPlayers := UploadReplayForm.NbPlayers + 'v' + IntToStr(teamCount[i]);
  UploadReplayForm.ShowModal;
  }
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

procedure TReplaysForm.VDTReplaysDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  R: TRect;
  Replay: TReplay;
  Pos: integer;
  s: WideString;
  tmp : WideString;
  textAlign: Cardinal;
  i: integer;
begin
  if not (Sender as TVirtualDrawTree).Visible then
    Exit;
    
  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    Replay := GetReplayFromNode(Node);

    if (Node = FocusedNode) and Focused then
      Canvas.Font.Color := clHighlightText
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
      Result := CompareStr(TReplayPlayer(Replay1.PlayerList[0]).UserName,TReplayPlayer(Replay2.PlayerList[0]).UserName);
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
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if VDTReplays.Header.SortColumn = Column then
    if VDTReplays.Header.SortDirection = sdDescending then
      VDTReplays.Header.SortDirection := sdAscending
    else
      VDTReplays.Header.SortDirection := sdDescending
  else
  begin
    VDTReplays.Header.SortColumn := Column;
    VDTReplays.Header.SortDirection := sdDescending;
  end;
end;

procedure TReplaysForm.InitVDTForRefresh;
begin
  ReplaysForm.LoadingPanel.Visible := True;
  VDTReplays.Visible := false;
  VDTReplays.TreeOptions.AutoOptions := [toAutoDropExpand,toAutoScrollOnExpand,toAutoTristateTracking,toAutoDeleteMovedNodes];
end;

procedure TReplaysForm.TerminateVDTRefresh;
begin
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
  DeleteButton.Enabled := ReplayList.Count > 0;
  GradeComboBox.Enabled := ReplayList.Count > 0;

  ReplaysForm.VDTReplays.FocusedNode := ReplaysForm.VDTReplays.GetFirst;
  ReplaysForm.VDTReplays.Selected[ReplaysForm.VDTReplays.FocusedNode] := true;

  ReplaysForm.VDTReplaysClick;
end;

procedure TReplaysForm.VDTReplaysClick;
begin
  if not LoadReplay(GetReplayFromNode(VDTReplays.FocusedNode)) then
  begin
    WasLastLoadSuccessful := False;
    ScriptRichEdit.Lines.Add('Outdated/corrupt demo file format!');
    CommentsRichEdit.Lines.Add('Outdated/corrupt demo file format!');
    SaveButton.Enabled := False;
  end
  else
    SaveButton.Enabled := true;
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
begin
  if not VDTReplays.Visible then
    Exit;
  if VDTReplays.RootNodeCount = 0 then
    Exit;

  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    Replay := GetReplayFromNode(VDTReplays.FocusedNode);
    ReplayPlayer := GetReplayPlayerFromNode(Node);

    if (Node = FocusedNode) and Focused then
      Canvas.Font.Color := clHighlightText
    else
      Canvas.Font.Color := clWindowText;

    R := ContentRect;

    if (Node <> VDTPlayers.FocusedNode) and (Replay.Version = 1) and (ReplayPlayer.Team = Replay.demoHeader.winningAllyTeam+1) and (Replay.demoHeader.winningAllyTeam > -1) and not ReplayPlayer.Spectator then
    begin
      Canvas.Brush.Color := 12116153;
      Canvas.FillRect(R);
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
            Inc(Pos,20);
          end;

          s := IntToStr(ReplayPlayer.Id);
        end;
      end;
      2: // team
        if not ReplayPlayer.Spectator then
          s := IntToStr(ReplayPlayer.Team);
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
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if VDTPlayers.Header.SortColumn = Column then
    if VDTPlayers.Header.SortDirection = sdDescending then
      VDTPlayers.Header.SortDirection := sdAscending
    else
      VDTPlayers.Header.SortDirection := sdDescending
  else
  begin
    VDTPlayers.Header.SortColumn := Column;
    VDTPlayers.Header.SortDirection := sdAscending;
  end;
end;

function TReplaysForm.isReplayVisible(Replay: TReplay):boolean;
var
  i,j,k:integer;
  tmpStr: String;
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
        else if filterType = Players then
          for k:=0 to Replay.PlayerList.Count-1 do
            tmpStr := tmpStr + TReplayPlayer(Replay.PlayerList[k]^).UserName + ' '
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
  if frmFilters.Height = 0 then
  begin
    frmFilters.Height := 219;
    PanelTop.Height := PanelTop.Height + frmFilters.Height;
    FiltersButton.ImageIndex := 0;
  end
  else
  begin
    FiltersButton.ImageIndex := 1;
    PanelTop.Height := PanelTop.Height - frmFilters.Height;
    frmFilters.Height := 0;
  end;
end;

// TODO: recode the load save and update replay filters because it's pretty bad coded
procedure TReplaysForm.LoadReplayFiltersFromFile;
var
  FilenamePath : String;
  Ini : TIniFile;
  i:integer;
  tmpStr: String;
  f: ^TFilterText;
begin
  FilenamePath := VAR_FOLDER + '\' + 'replayFilters.ini';
  Ini := TIniFile.Create(FilenamePath);
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
      TFilterText(f^).filterType := Players;

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

procedure TReplaysForm.SaveReplayFiltersToFile;
var
  FilenamePath : String;
  Ini : TIniFile;
  i:integer;
begin
  try
    FilenamePath := VAR_FOLDER + '\' + 'replayFilters.ini';
    if FileExists(FilenamePath) then
      DeleteFile(FilenamePath);
    Ini := TIniFile.Create(FilenamePath);
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
          Ini.WriteString('TextFilter'+IntToStr(i), 'Type', 'Players');

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
        CellText := 'Players';
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
  Filters.GameContinues := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterComEndClick(Sender: TObject);
begin
  Filters.ComEnd := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterLineageClick(Sender: TObject);
begin
  Filters.Lineage := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterLimitDGunFilterClick(Sender: TObject);
begin
  Filters.FilterLimitDGun := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterGhostedFilterClick(Sender: TObject);
begin
  Filters.FilterGhosted := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterDiminishingFilterClick(Sender: TObject);
begin
  Filters.FilterDiminishing := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterLimitDGunClick(Sender: TObject);
begin
  Filters.LimitDGun := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterGhostedClick(Sender: TObject);
begin
  Filters.Ghosted := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterDiminishingClick(Sender: TObject);
begin
  Filters.Diminishing := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterMetalClick(Sender: TObject);
begin
  Filters.Metal.enabled := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterEnergyClick(Sender: TObject);
begin
  Filters.Energy.enabled := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterUnitsClick(Sender: TObject);
begin
  Filters.Units.enabled := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterPlayersClick(Sender: TObject);
begin
  Filters.Players.enabled := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterLengthClick(Sender: TObject);
begin
  Filters.Length.enabled := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterFileSizeClick(Sender: TObject);
begin
  Filters.FileSize.enabled := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterGradeClick(Sender: TObject);
begin
  Filters.Grade.enabled := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
    FilterReplayList;
end;

procedure TReplaysForm.chkFilterFixedClick(Sender: TObject);
begin
  Filters.Fixed := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
        FilterReplayList;
end;

procedure TReplaysForm.chkFilterRandomClick(Sender: TObject);
begin
  Filters.Random := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
        FilterReplayList;
end;

procedure TReplaysForm.chkFilterChooseInGameClick(Sender: TObject);
begin
  Filters.ChooseInGame := (Sender as TSpTBXCheckBox).Checked;
  if chkEnableFilters.Checked then
        FilterReplayList;
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
      if chkEnableFilters.Checked then
        FilterReplayList;
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
      if chkEnableFilters.Checked then
        FilterReplayList;
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
      if chkEnableFilters.Checked then
        FilterReplayList;
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
      if chkEnableFilters.Checked then
        FilterReplayList;
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
      if chkEnableFilters.Checked then
        FilterReplayList;
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
      if chkEnableFilters.Checked then
        FilterReplayList;
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
      if chkEnableFilters.Checked then
        FilterReplayList;
  end;
end;

procedure TReplaysForm.speFilterMetalChange(Sender: TObject);
begin
  with Filters.Metal do
  begin
    value := (Sender as TJvSpinEdit).AsInteger;
    if enabled then
      if chkEnableFilters.Checked then
        FilterReplayList;
  end;
end;

procedure TReplaysForm.speFilterEnergyChange(Sender: TObject);
begin
  with Filters.Energy do
  begin
    value := (Sender as TJvSpinEdit).AsInteger;
    if enabled then
      if chkEnableFilters.Checked then
        FilterReplayList;
  end;
end;

procedure TReplaysForm.speFilterUnitsChange(Sender: TObject);
begin
  with Filters.Units do
  begin
    value := (Sender as TJvSpinEdit).AsInteger;
    if enabled then
      if chkEnableFilters.Checked then
        FilterReplayList;
  end;
end;

procedure TReplaysForm.speFilterPlayersChange(Sender: TObject);
begin
  with Filters.Players do
  begin
    value := (Sender as TJvSpinEdit).AsInteger;
    if enabled then
      if chkEnableFilters.Checked then
        FilterReplayList;
  end;
end;

procedure TReplaysForm.speFilterLengthChange(Sender: TObject);
begin
  with Filters.Length do
  begin
    value := (Sender as TJvSpinEdit).AsInteger;
    if enabled then
      if chkEnableFilters.Checked then
        FilterReplayList;
  end;
end;

procedure TReplaysForm.speFilterFileSizeChange(Sender: TObject);
begin
  with Filters.FileSize do
  begin
    value := (Sender as TJvSpinEdit).AsInteger;
    if enabled then
      if chkEnableFilters.Checked then
        FilterReplayList;
  end;
end;

procedure TReplaysForm.speFilterGradeChange(Sender: TObject);
begin
  with Filters.Grade do
  begin
    value := (Sender as TJvSpinEdit).AsInteger;
    if enabled then
      if chkEnableFilters.Checked then
        FilterReplayList;
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
  if chkEnableFilters.Checked then
        FilterReplayList;
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
  if chkEnableFilters.Checked then
        FilterReplayList;
end;

procedure TReplaysForm.ClearFilterListButtonClick(Sender: TObject);
begin
  Filters.TextFilters.Clear;
  FilterList.Clear;
  if chkEnableFilters.Checked then
        FilterReplayList;
end;

procedure TReplaysForm.FilterListChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
begin
  TFilterText(Filters.TextFilters[GetReplayFilterIndexFromNode(Node)]^).enabled := NewState = csCheckedNormal;
  if chkEnableFilters.Checked then
        FilterReplayList;
end;

procedure TReplaysForm.frmFiltersResize(Sender: TObject);
begin
  FilterList.Width := frmFilters.Width - 610;
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

procedure TReplaysForm.FilterListHeaderClick(Sender: TVTHeader;
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
          StretchDraw(Rect(10,10,110,110),MapImage.Picture.Bitmap);
          Font.Style := [fsBold];
          TextOut(120, 10, MapName);
          Font.Style := [];
          TextOut(120, 10+TextHeight(MapName), 'Map size: '+IntToStr(MapInfo.Width div 64)+'x'+IntToStr(MapInfo.Height div 64));
          TextOut(120, 10+TextHeight(MapName)*2, 'Max. metal: '+FloatToStr(MapInfo.MaxMetal));
          TextOut(120, 10+TextHeight(MapName)*3, 'Wind (min/max): '+IntToStr(MapInfo.MinWind)+'-'+IntToStr(MapInfo.MaxWind));
          DrawMultilineText(MapInfo.Description,HintCanvas,Rect(120,10+10+TextHeight(MapName)*4,R.Right-10,R.Bottom-5),alHLeft,alVTop,JustLeft,true);
        end;
      end;
    end
    else
      TextOut(5, 2, s);
  end;
end;

end.
