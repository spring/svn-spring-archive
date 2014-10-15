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
  Dialogs, Buttons, StdCtrls, ComCtrls, ExtCtrls, Math;

type
  TReplaysForm = class(TForm)
    WatchButton: TButton;
    CloseButton: TButton;
    ReplaysListBox: TListBox;
    ReloadButton: TSpeedButton;
    PlayersListBox: TListBox;
    PlayersLabel: TLabel;
    DeleteButton: TSpeedButton;
    SaveButton: TSpeedButton;
    GradeComboBox: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ScriptRichEdit: TRichEdit;
    CommentsRichEdit: TRichEdit;
    Panel1: TPanel;
    Label3: TLabel;
    MapLabel: TLabel;
    Label4: TLabel;
    GameTypeLabel: TLabel;
    Label2: TLabel;
    SizeLabel: TLabel;
    Label1: TLabel;
    HostReplayButton: TButton;

    procedure CreateParams(var Params: TCreateParams); override;

    function ReadScriptFromDemo(DemoFileName: string; var Script: string): Boolean;
    function LoadReplay(Index: Integer): Boolean;
    procedure SaveCommentsToScript(var Script: string; Comments: TStrings; Grade: Byte);
    procedure ReadCommentsFromScript(Script: string; Comments: TStrings; var Grade: Byte);
    function ChangeScriptInDemo(DemoFileName, Script: string): Boolean;
    function ReadGradeFromScript(Script: string): Byte;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReplaysForm: TReplaysForm;
  Script: string; // script file of currently opened replay
  WasLastLoadSuccessful: Boolean = False; // True only if last loading of the replay was successful. If it is False, that means we don't have a replay displayed at all (since the last load failed), and True if we have it loaded. 

implementation

uses Unit1, StrUtils, ShellAPI, BattleFormUnit, Misc, PreferencesFormUnit;

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
  for i := 0 to Comments.Count-1 do Script := Script + #9 + 'line' + IntToStr(i+1) + '=' + Comments[i] + #13#10;
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
      if index > 0 then Comments[i] := Copy(Comments[i], index+1, Length(Comments[i]));
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
  PageControl1.ActivePageIndex := 0;
  ReloadButton.OnClick(nil);
end;

procedure TReplaysForm.ReloadButtonClick(Sender: TObject);
var
  i: Integer;
begin
  MainForm.EnumerateReplayList;

  ReplaySListBox.Items.Clear;
  for i := 0 to ReplayList.Count-1 do ReplaySListBox.Items.Add(TReplay(ReplayList[i]).FileName);
  
  if ReplaysListBox.Items.Count = 0 then
  begin
    ScriptRichEdit.Lines.Clear;
    WatchButton.Enabled := False;
    DeleteButton.Enabled := False;
  end
  else
  begin
    ReplaysListBox.ItemIndex := 0;
    ReplaysListBoxClick(nil);
    WatchButton.Enabled := True;
    DeleteButton.Enabled := True;
  end;
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
  Result := False;
  ScriptRichEdit.Lines.Clear;
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
end;

procedure TReplaysForm.ReplaysListBoxClick(Sender: TObject);
begin
  if not LoadReplay(ReplaysListBox.ItemIndex) then
  begin
    WasLastLoadSuccessful := False;
    ScriptRichEdit.Lines.Clear;
    ScriptRichEdit.Lines.Add('Outdated/corrupt demo file format!')
  end
  else
    WasLastLoadSuccessful := True;

end;

procedure TReplaysForm.WatchButtonClick(Sender: TObject);
begin
  if BattleForm.IsBattleActive then
  begin
    MessageDlg('Disconnect from battle first!', mtWarning, [mbOK], 0);
    Exit;
  end;

  ShellExecute(MainForm.Handle, nil, 'spring.exe', PChar(ReplaysListBox.Items[ReplaysListBox.ItemIndex]), PChar(ExtractFilePath(Application.ExeName)), SW_SHOW);
end;

procedure TReplaysForm.DeleteButtonClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete ' + ReplaysListBox.Items[ReplaysListBox.ItemIndex] + '?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  DeleteFile(ExtractFilePath(Application.ExeName) + 'demos\' + ReplaysListBox.Items[ReplaysListBox.ItemIndex]);
  ReloadButton.OnClick(nil);
end;

procedure TReplaysForm.CommentsRichEditChange(Sender: TObject);
begin
  SaveButton.Enabled := True;
end;

procedure TReplaysForm.SaveButtonClick(Sender: TObject);
var
  Grade: Byte;
begin
  if GradeComboBox.ItemIndex = -1 then Exit; // this shouldn't happen!

  Grade := GradeComboBox.ItemIndex;

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
var
  tmp: Integer;
begin
  // this ensures the correct highlite color is used
  (Control as TListBox).Canvas.FillRect(Rect);

  tmp := TReplay(ReplayList.Items[Index]).Grade;
  if tmp >= 8 then tmp := 3
  else if tmp >= 5 then tmp := 2
  else if tmp > 0 then tmp := 1;
  MainForm.GradesImageList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top, tmp);
  (Control as TListBox).Canvas.TextOut(Rect.Left + MainForm.GradesImageList.Width + 3, Rect.Top, TReplay(ReplayList.Items[Index]).FileName);
end;

procedure TReplaysForm.GradeComboBoxChange(Sender: TObject);
begin
  SaveButton.Enabled := True;
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

end.
