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
  IdHTTP,MainUnit;

type
  TReplaysForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    ReloadButton: TSpTBXSpeedButton;
    PlayersLabel: TSpTBXLabel;
    DeleteButton: TSpTBXSpeedButton;
    SaveButton: TSpTBXSpeedButton;
    RenameButton: TSpTBXSpeedButton;
    WatchButton: TSpTBXButton;
    CloseButton: TSpTBXButton;
    ReplaysListBox: TSpTBXListBox;
    PlayersListBox: TSpTBXListBox;
    GradeComboBox: TSpTBXComboBox;
    Panel1: TSpTBXPanel;
    Label3: TSpTBXLabel;
    MapLabel: TSpTBXLabel;
    Label4: TSpTBXLabel;
    GameTypeLabel: TSpTBXLabel;
    Label2: TSpTBXLabel;
    SizeLabel: TSpTBXLabel;
    HostReplayButton: TSpTBXButton;
    LoadingPanel: TSpTBXPanel;
    LoadingLabel: TSpTBXLabel;
    PageControl1: TSpTBXTabControl;
    SpTBXTabItem2: TSpTBXTabItem;
    SpTBXTabItem1: TSpTBXTabItem;
    SpTBXTabSheet2: TSpTBXTabSheet;
    CommentsRichEdit: TRichEdit;
    SpTBXTabSheet1: TSpTBXTabSheet;
    ScriptRichEdit: TRichEdit;
    SpTBXLabel1: TSpTBXLabel;
    UploadButton: TSpTBXButton;
    DownloadButton: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure EnumerateReplayList;
    function ReadScriptFromDemo(DemoFileName: string; var Script: string): Boolean;
    function ReadScriptFromDemo2(DemoFileName: string; var Script: string): Boolean;
    function LoadReplay(Index: Integer): Boolean;
    procedure SaveCommentsToScript(var Script: TScript; Comments: TStrings; Grade: Byte);
    procedure ReadCommentsFromScript(Script: TScript; Comments: TStrings; var Grade: Byte);
    function ChangeScriptInDemo(DemoFileName, Script: string): Boolean;
    function ChangeScriptInDemo2(DemoFileName, Script: string): Boolean;
    function ReadGradeFromScript(Script: string): Byte;
    function ValidateComments(Comments: TStrings): Boolean;

    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReloadButtonClick(Sender: TObject);
    procedure ReplaysListBoxClick(Sender: TObject);
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
  private
    procedure ApplyReplayListToReplaysListBox;
  public
    { Public declarations }
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
  Script: TScript; // script file of currently opened replay
  WasLastLoadSuccessful: Boolean = False; // True only if last loading of the replay was successful. If it is False, that means we don't have a replay displayed at all (since the last load failed), and True if we have it loaded.
  LoadingReplay: Boolean = False; // is True while LoadReplay method is loading a replay

implementation

uses  StrUtils, ShellAPI, BattleFormUnit, Misc, PreferencesFormUnit,
  InitWaitFormUnit,MsMultiPartFormData, ProgressBarWindow,
  UploadReplayUnit, Utility;

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
    ReplaysForm.EnumerateReplayList;
    Synchronize(ReplaysForm.ApplyReplayListToReplaysListBox);
    ReplaysForm.ReloadButton.Enabled := True;
  finally
//***    MainForm.AddMainLog(IntToStr(GetTickCount - StartTime) + ' ms taken to reload replays!', Colors.Info);
    ReplaysForm.LoadingPanel.Enabled := False;
    ReplaysForm.LoadingPanel.Visible := False;    
  end;

end;

procedure TReplaysForm.EnumerateReplayList;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  rep: TReplay;
  s: string;
  StartTime: Cardinal;
begin
  StartTime := GetTickCount;

  ReplayList.Clear;

  FileAttrs := faAnyFile;

  if FindFirst(ExtractFilePath(Application.ExeName) + 'demos\*.sdf', FileAttrs, sr) = 0 then
  begin
    if (sr.Name <> '.') and (sr.Name <> '..') then
    begin
      rep := TReplay.Create;
      rep.FileName := sr.Name;
      rep.FullFileName := ExtractFilePath(Application.ExeName) + 'Demos\' + sr.Name;
      rep.Version := 0;
      if not ReplaysForm.ReadScriptFromDemo(rep.FullFileName, s) then
      begin
        ReplaysForm.ReadScriptFromDemo2(rep.FullFileName, s);
        rep.Version := 1;
      end;
      rep.Grade := ReplaysForm.ReadGradeFromScript(s);
      ReplayList.Add(rep);
    end;

    while FindNext(sr) = 0 do
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        rep := TReplay.Create;
        rep.FileName := sr.Name;
        rep.FullFileName := ExtractFilePath(Application.ExeName) + 'Demos\' + sr.Name;
        rep.Version := 0;
        if not ReplaysForm.ReadScriptFromDemo(rep.FullFileName, s) then
        begin
          ReplaysForm.ReadScriptFromDemo2(rep.FullFileName, s);
          rep.Version := 1;
        end;
        rep.Grade := ReplaysForm.ReadGradeFromScript(s);
        ReplayList.Add(rep);
      end;

    FindClose(sr);
  end;

  // revert the list so that the must recent replays are on top:
  RevertList(ReplayList);
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
    Script.AddOrChangeKeyValue('COMMENTS\LINE'+IntToStr(i+1),Comments[i]);

  Script.AddOrChangeKeyValue('COMMENTS\GRADE',IntToStr(Grade));
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
    tmp := Script.ReadKeyValue('COMMENTS\LINE'+IntToStr(count));
    if tmp = '' then break;
    Comments.Add(tmp);
    Inc(count);
  end;

  tmp := Script.ReadKeyValue('COMMENTS\GRADE');
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
end;

procedure TReplaysForm.FormCreate(Sender: TObject);
begin
  if not SpTBXTitleBar1.Active then
    RemoveSpTBXTitleBarMarges(self);

  PageControl1.ActiveTabIndex := 0;
  LoadingPanel.Align := alClient;
end;

// will assign ReplasyListBox items from ReplayList
procedure TReplaysForm.ApplyReplayListToReplaysListBox;
var
  i: Integer;
begin
  ReplaysListBox.Items.Clear;
  for i := 0 to ReplayList.Count-1 do ReplaysListBox.Items.Add(TReplay(ReplayList[i]).FileName);

  if ReplaysListBox.Items.Count = 0 then
  begin
    ScriptRichEdit.Lines.Clear;
    WatchButton.Enabled := False;
    DeleteButton.Enabled := False;
    RenameButton.Enabled := False;
    UploadButton.Enabled := False;
    GradeComboBox.Enabled := False;
  end
  else
  begin
    ReplaysListBox.ItemIndex := 0;
    ReplaysListBoxClick(nil);
    WatchButton.Enabled := True;
    DeleteButton.Enabled := True;
    RenameButton.Enabled := True;
    UploadButton.Enabled := True;
    GradeComboBox.Enabled := True;
  end;
end;

procedure TReplaysForm.ReloadButtonClick(Sender: TObject);
var
  i: Integer;
begin
  InitWaitForm.ChangeCaption(MSG_RELOADREPLAYS);
  InitWaitForm.TakeAction := 4; // reload replay list
  InitWaitForm.ShowModal; // this will reload replay list

  ApplyReplayListToReplaysListBox;
end;

function TReplaysForm.LoadReplay(Index: Integer): Boolean;
var
  b: Byte;
  i, j, k: Integer;
  count: Integer;
  s: string;
  FileName: string;
  ScriptCls : TScript;
  tmp: String;
begin
  LoadingReplay := True;
  Result := False;
  ScriptRichEdit.Lines.Clear;
  CommentsRichEdit.Lines.Clear;
  PlayersListBox.Items.Clear;
  MapLabel.Caption := '?';
  GameTypeLabel.Caption := '?';
  SizeLabel.Caption := '?';
  PlayersLabel.Caption := 'Players:';
  if Index > ReplaysListBox.Count-1 then Exit;

  FileName := TReplay(ReplayList[Index]).FullFileName;
  if not ReadScriptFromDemo(FileName, s) then
    ReadScriptFromDemo2(FileName, s);

  Script := TScript.Create(s);
  ScriptRichEdit.Text := s;

  count := 0;
  while True do
  begin
    tmp := Script.ReadKeyValue('GAME\PLAYER'+ IntToStr(count)+'\NAME');
    if tmp = '' then break;
    PlayersListBox.Items.Add(tmp);
    Inc(count);
  end;
  if count = 0 then Exit; // corrupt script file
  PlayersLabel.Caption := 'Players (' + IntToStr(count) + '):';

  tmp := Script.ReadKeyValue('GAME\MAPNAME');
  if tmp = '' then Exit; // corrupt script file
  MapLabel.Caption := tmp;

  tmp := Script.ReadKeyValue('GAME\GAMETYPE');
  if tmp = '' then Exit; // corrupt script file
  GameTypeLabel.Caption := tmp;

  SizeLabel.Caption := Misc.FormatFileSize(GetFileSize(FileName)) + ' KB';

  ReadCommentsFromScript(Script, CommentsRichEdit.Lines, b);
  GradeComboBox.ItemIndex := Min(b, 10); // 11 grades max. (0..10)
  SaveButton.Enabled := False;

  Result := True;
  LoadingReplay := False;
end;

procedure TReplaysForm.ReplaysListBoxClick(Sender: TObject);
begin
  if not LoadReplay(ReplaysListBox.ItemIndex) then
  begin
    WasLastLoadSuccessful := False;
    ScriptRichEdit.Lines.Add('Outdated/corrupt demo file format!');
    CommentsRichEdit.Lines.Add('Outdated/corrupt demo file format!');
    SaveButton.Enabled := False;
  end
  else
    WasLastLoadSuccessful := True;
end;

procedure TReplaysForm.WatchButtonClick(Sender: TObject);
var
  i,j:integer;
  v: string;
  FileName: string;
  s:string;
  springexe: string;
  f: file of Byte;
  script: TScript;
  springExeVersion: string;
begin
  if BattleForm.IsBattleActive and Status.Me.GetReadyStatus then
    if MessageDlg('You cannot be ready in a battle and watch replays at the same time. Do you wish to unready now?', mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit
    else BattleForm.ReadyButton.OnClick(BattleForm.ReadyButton);

  FileName := TReplay(ReplayList[ReplaysListBox.ItemIndex]).FullFileName;
  if ReadScriptFromDemo(FileName, s) then
  begin
    // old version demo : the spring version is in the script
    script := TScript.Create(s);
    v := script.ReadKeyValue('VERSION\GameVersion');
  end
  else
  begin
    // new version demo : the spring version is in the header
    AssignFile(f, FileName);

    {$I+}
    try
      Reset(f);
      // spring version at a fixed pos : 24
      Seek(f,24);
      SetLength(v, 16);
      BlockRead(f, v[1], 16);
      CloseFile(f);
      Delete(v,Pos(#0,v),17-Pos(#0,v));
    except
      try
        CloseFile(f);
      except
      end;

      Exit;
    end;
  end;

  springexe := 'spring'+v+'.exe';
  if not FileExists(springexe) then
  begin
    springExeVersion := GetSpringVersionFromEXE;
    if springExeVersion <> v then
      if MessageDlg(springexe + ' not found.'+EOL+EOL+'Watching a replay with the wrong spring version may not work.'+EOL+EOL+'Watch with the default spring.exe ('+springExeVersion+') ?',mtWarning,[mbYes,mbNo],0) = mrNo then
        Exit;
    springexe := 'spring.exe';
  end;
  ShellExecute(MainForm.Handle, nil, PChar(springexe), PChar(AnsiString(ReplaysListBox.Items[ReplaysListBox.ItemIndex])), PChar(ExtractFilePath(Application.ExeName)), SW_SHOW);
end;

procedure TReplaysForm.DeleteButtonClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete ' + ReplaysListBox.Items[ReplaysListBox.ItemIndex] + '?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  DeleteFile(ExtractFilePath(Application.ExeName) + 'demos\' + ReplaysListBox.Items[ReplaysListBox.ItemIndex]);
  ReloadButton.OnClick(nil);
end;

procedure TReplaysForm.CommentsRichEditChange(Sender: TObject);
begin
  if ReplaysListBox.ItemIndex <> -1 then if not LoadingReplay then SaveButton.Enabled := True;
end;

procedure TReplaysForm.SaveButtonClick(Sender: TObject);
var
  Grade: Byte;
begin
  if GradeComboBox.ItemIndex = -1 then Exit; // this shouldn't happen!

  Grade := GradeComboBox.ItemIndex;

  if not ValidateComments(CommentsRichEdit.Lines) then Exit;

  SaveCommentsToScript(Script, CommentsRichEdit.Lines, Grade);

  if ((TReplay(ReplayList[ReplaysListBox.ItemIndex]).Version = 0) and (not ChangeScriptInDemo(ExtractFilePath(Application.ExeName) + 'demos\' + ReplaysListBox.Items[ReplaysListBox.ItemIndex], Script.Script))) or ((TReplay(ReplayList[ReplaysListBox.ItemIndex]).Version = 1) and (not ChangeScriptInDemo2(ExtractFilePath(Application.ExeName) + 'demos\' + ReplaysListBox.Items[ReplaysListBox.ItemIndex], Script.Script))) then
  begin
    MessageDlg('Error: unable to write file!', mtError, [mbOK], 0);
  end
  else
  begin
    SaveButton.Enabled := False;
    TReplay(ReplayList[ReplaysListBox.ItemIndex]).Grade := Grade;
    ReplaysListBox.Invalidate;
    ScriptRichEdit.Text := Script.Script;
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
  if ReplaysListBox.ItemIndex <> -1 then SaveButton.Enabled := True;
end;

procedure TReplaysForm.HostReplayButtonClick(Sender: TObject);
begin
  if not WasLastLoadSuccessful then
  begin
    MessageDlg('Outdated/corrupt demo file format - unable to host!', mtWarning, [mbOK], 0);
    Exit;
  end;
  ModalResult := mrOK;
end;

procedure TReplaysForm.RenameButtonClick(Sender: TObject);
var
  s, OldName: string;
begin
  OldName := ExtractFilePath(Application.ExeName) + 'demos\' + ReplaysListBox.Items[ReplaysListBox.ItemIndex];
  s := ReplaysListBox.Items[ReplaysListBox.ItemIndex];
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
begin
  for i:=0 to 15 do
    teamCount[i] := 0;
  UploadReplayForm.FileName := TReplay(ReplayList[ReplaysListBox.ItemIndex]).FullFileName;
  UploadReplayForm.MapName := Copy(MapLabel.Caption,0,Length(MapLabel.Caption)-4);
  UploadReplayForm.ModName := Copy(GameTypeLabel.Caption,0,Length(GameTypeLabel.Caption)-4);
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
end;

end.
