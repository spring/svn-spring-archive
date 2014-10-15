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
  SpTBXItem;

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

    procedure CreateParams(var Params: TCreateParams); override;

    procedure EnumerateReplayList;
    function ReadScriptFromDemo(DemoFileName: string; var Script: string): Boolean;
    function LoadReplay(Index: Integer): Boolean;
    procedure SaveCommentsToScript(var Script: string; Comments: TStrings; Grade: Byte);
    procedure ReadCommentsFromScript(Script: string; Comments: TStrings; var Grade: Byte);
    function ChangeScriptInDemo(DemoFileName, Script: string): Boolean;
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
  Script: string; // script file of currently opened replay
  WasLastLoadSuccessful: Boolean = False; // True only if last loading of the replay was successful. If it is False, that means we don't have a replay displayed at all (since the last load failed), and True if we have it loaded.
  LoadingReplay: Boolean = False; // is True while LoadReplay method is loading a replay

implementation

uses Unit1, StrUtils, ShellAPI, BattleFormUnit, Misc, PreferencesFormUnit,
  InitWaitFormUnit;

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

procedure TReplaysForm.SaveCommentsToScript(var Script: string; Comments: TStrings; Grade: Byte);
var
  index: Integer;
  i: Integer;
begin
  index := Pos('[COMMENTS]', Script);
  if index = 0 then
  begin
    Script := Script + #13#10 + '[COMMENTS]' + #13#10 + '{' + #13#10;
  end
  else
  begin
    Script := Copy(Script, 1, index + Length('[COMMENTS]') - 1);
    Script := Script + #13#10 + '{' + #13#10;
  end;
  Script := Script + #9 + 'Grade=' + IntToStr(Grade) + ';' + #13#10;
  for i := 0 to Comments.Count-1 do Script := Script + #9 + 'line' + IntToStr(i+1) + '=' + Comments[i] + ';' + #13#10;
  Script := Script + '}';
end;

procedure TReplaysForm.ReadCommentsFromScript(Script: string; Comments: TStrings; var Grade: Byte);
var
  index: Integer;
  i, j: Integer;
  b: Byte;
begin
  Grade := 0;

  Comments.BeginUpdate;

  Comments.Clear;
  index := Pos('[COMMENTS]', Script);
  if index = 0 then
  begin // no comments found
    Comments.EndUpdate;
    Exit;
  end;
  Inc(index, Length('[COMMENTS]'));

  Comments.Text := Copy(Script, index, Length(Script)-index);

  // clear all up to "{"
  for i := 0 to Comments.Count-1 do if Trim(Comments[i]) = '{' then
  begin
    for j := 0 to i do Comments.Delete(0);
    Break;
  end;

  // clear all after "}"
  for i := 0 to Comments.Count-1 do if Trim(Comments[i]) = '}' then
  begin
    for j := Comments.Count-1 downto i do Comments.Delete(j);
    Break;
  end;

  // trim all TABs in front of each line and remove "line=":
  i := 0;
  while True do
  begin
    if i > Comments.Count-1 then Break;

    Comments[i] := TrimLeft(Comments[i]);
    if UpperCase(Copy(Comments[i], 1, 4)) = 'LINE' then
    begin
      index := Pos('=', Comments[i]);
      if index > 0 then Comments[i] := Copy(Comments[i], index+1, Length(Comments[i])-index-1); // we ignore the last char which it is ";"
    end
    else if UpperCase(Copy(Comments[i], 1, 5)) = 'GRADE' then
    begin
      b := 0;
      j := Pos(';', Comments[i]);
      if j > 0 then
      try
        b := StrToInt(Copy(Comments[i], 7, j-7));
      except
      end;

      Grade := b;
      Comments.Delete(i);
      Continue; // don't increase i since we just skipped a line
    end;

    Inc(i);
  end;

  Comments.EndUpdate;
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
    GradeComboBox.Enabled := False;
  end
  else
  begin
    ReplaysListBox.ItemIndex := 0;
    ReplaysListBoxClick(nil);
    WatchButton.Enabled := True;
    DeleteButton.Enabled := True;
    RenameButton.Enabled := True;
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
  su: string;
  FileName: string;
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
  ReadScriptFromDemo(FileName, s);

  Script := s;
  ScriptRichEdit.Text := s;

  su := UpperCase(s);

  count := 0;
  while True do
  begin
    i := Pos('[PLAYER' + IntToStr(count), su);
    if i = 0 then Break;

    j := PosEx('NAME=', su, i);
    if j = 0 then Break;
    j := j + 5;
    k := PosEx(';', su, j);
    if k = 0 then Break;
    PlayersListBox.Items.Add(Copy(s, j, k-j));

    Inc(count);
  end;
  if count = 0 then Exit; // corrupt script file
  PlayersLabel.Caption := 'Players (' + IntToStr(count) + '):';

  i := Pos('MAPNAME=', su);
  i := i + 8;
  j := PosEx(';', su, i);
  if (i<>0) and (j<>0) then MapLabel.Caption := Copy(s, i, j-i)
  else Exit; // corrupt script file

  i := Pos('GAMETYPE=', su);
  i := i + 9;
  j := PosEx(';', su, i);
  if (i<>0) and (j<>0) then GameTypeLabel.Caption := Copy(s, i, j-i)
  else Exit; // corrupt script file

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
begin
  if BattleForm.IsBattleActive then
    if MessageDlg('You cannot participate in a battle and watch replays at the same time. Do you wish to disconnect from your current battle now?', mtWarning, [mbYes, mbNo, mbCancel], 0) <> mrYes then Exit
    else BattleForm.DisconnectButton.OnClick(BattleForm.DisconnectButton);

  ShellExecute(MainForm.Handle, nil, 'spring.exe', PChar(AnsiString(ReplaysListBox.Items[ReplaysListBox.ItemIndex])), PChar(ExtractFilePath(Application.ExeName)), SW_SHOW);
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

  if not ChangeScriptInDemo(ExtractFilePath(Application.ExeName) + 'demos\' + ReplaysListBox.Items[ReplaysListBox.ItemIndex], Script) then
  begin
    MessageDlg('Error: unable to write file!', mtError, [mbOK], 0);
  end
  else
  begin
    SaveButton.Enabled := False;
    TReplay(ReplayList[ReplaysListBox.ItemIndex]).Grade := Grade;
    ReplaysListBox.Invalidate;
    ScriptRichEdit.Text := Script;
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

end.
