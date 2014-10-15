unit PerformFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PreferencesFormUnit, StdCtrls, JvExStdCtrls, JvListBox, Buttons,
  SpTBXControls, SpTBXEditors, TntStdCtrls, SpTBXItem, ImgList,Misc,
  StrUtils, gnugettext;

type
  TPerformForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    Label1: TSpTBXLabel;
    Label2: TSpTBXLabel;
    SpeedButton1: TSpTBXSpeedButton;
    Label3: TSpTBXLabel;
    CommandsListBox: TSpTBXListBox;
    CmdEdit: TSpTBXEdit;
    Button1: TSpTBXButton;
    UpButton: TSpTBXButton;
    SpTBXButton1: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure SaveCommandListToFile(FileName: string);
    procedure LoadCommandListFromFile(FileName: string);
    procedure PerformCommands;

    procedure SpeedButton1Click(Sender: TObject);
    procedure CommandsListBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure SpTBXButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    function isChannelAutoJoined(channelName: string):Boolean;
    procedure addAutoJoinChannel(channelName: string);
    procedure removeAutoJoinChannel(channelName: string);
    function getPerformList:TStringList;
    procedure setPerformList(performList: TStringList);
  end;

var
  PerformForm: TPerformForm;

implementation

uses MainUnit,Math;

{$R *.dfm}

procedure TPerformForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TPerformForm.SpeedButton1Click(Sender: TObject);
begin
  if Length(CmdEdit.Text) < 2 then
  begin
    MessageDlg('Invalid command!', mtError, [mbOK], 0);
    Exit;
  end;

  if (CmdEdit.Text[1] <> '/') and (CmdEdit.Text[1] <> '.') then
  begin
    MessageDlg(_('Invalid command! (each command should start with "/" character'), mtError, [mbOK], 0);
    Exit;
  end;

  CommandsListBox.Items.Add(CmdEdit.Text);
  CmdEdit.Text := '';
end;

procedure TPerformForm.CommandsListBoxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if CommandsListbox.ItemIndex = -1 then Exit;

  if Key = VK_DELETE then
    CommandsListbox.Items.Delete(CommandsListbox.ItemIndex);
end;

procedure TPerformForm.SaveCommandListToFile(FileName: string);
var
  f: TextFile;
  i: Integer;
begin

  {$I+}
  try
    AssignFile(f, FileName);
    Rewrite(f);

    for i := 0 to CommandsListBox.Items.Count-1 do
      Writeln(f, CommandsListBox.Items[i]);

    CloseFile(f);
  except
    Exit;
  end;

end;

procedure TPerformForm.LoadCommandListFromFile(FileName: string);
var
  f: TextFile;
  s: string;
begin

  CommandsListBox.Clear;

  if not FileExists(FileName) then
  begin
    CommandsListBox.Items.Add('/join #newbies');
    CommandsListBox.Items.Add('/join #'+LeftStr(GetWindowsLanguage,2));
  end;

  {$I+}
  try
    AssignFile(f, FileName);
    Reset(f);

    while not Eof(f) do
    begin
      Readln(f, s);
      if s = '' then Continue; // skip empty lines
      if s[1] = '#' then Continue; // skip comments

      CommandsListBox.Items.Add(s);
    end;

    CloseFile(f);
  except
    Exit;
  end;

end;

procedure TPerformForm.PerformCommands;
var
  i: Integer;
begin
  NbAutoJoinChannels := 0;
  for i := 0 to CommandsListBox.Count-1 do
  begin
    MainForm.ProcessCommand(Copy(CommandsListBox.Items[i], 2, Length(CommandsListBox.Items[i])-1), False);
    if LowerCase(LeftStr(CommandsListBox.Items[i],4)) = '/j #' then
      Inc(NbAutoJoinChannels);
    if LowerCase(LeftStr(CommandsListBox.Items[i],7)) = '/join #' then
      Inc(NbAutoJoinChannels);
  end;
end;

procedure TPerformForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TPerformForm.UpButtonClick(Sender: TObject);
var
  i: integer;
begin
  if CommandsListBox.ItemIndex = -1 then Exit;
  i := Max(0,CommandsListBox.ItemIndex-1);
  CommandsListBox.Items.Move(CommandsListBox.ItemIndex,i);
  CommandsListBox.ItemIndex := i;
end;

procedure TPerformForm.SpTBXButton1Click(Sender: TObject);
var
  i: integer;
begin
  if CommandsListBox.ItemIndex = -1 then Exit;
  i := Min(CommandsListBox.Count-1,CommandsListBox.ItemIndex+1);
  CommandsListBox.Items.Move(CommandsListBox.ItemIndex,i);
  CommandsListBox.ItemIndex := i;
end;

procedure TPerformForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TPerformForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PerformForm.SaveCommandListToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\perform.dat');
end;

function TPerformForm.isChannelAutoJoined(channelName: string):Boolean;
var
  i: integer;
begin
  Result := False;
  if AnsiUpperCase(channelName) = 'MAIN' then
    Exit;
  for i:=0 to PerformForm.CommandsListBox.Count-1 do
    if (AnsiUpperCase(PerformForm.CommandsListBox.Items[i]) = '/J #'+AnsiUpperCase(channelName)) or (AnsiUpperCase(PerformForm.CommandsListBox.Items[i]) = '/JOIN #'+AnsiUpperCase(channelName)) then
    begin
      Result := True;
      Exit;
    end;
end;

procedure TPerformForm.addAutoJoinChannel(channelName: string);
begin
  if AnsiUpperCase(channelName) = 'MAIN' then
    Exit;
  if not isChannelAutoJoined(channelName) then
    PerformForm.CommandsListBox.Items.Add('/j #'+channelName)
end;

procedure TPerformForm.removeAutoJoinChannel(channelName: string);
var
  i: integer;
begin
  if AnsiUpperCase(channelName) = 'MAIN' then
    Exit;
  for i:=PerformForm.CommandsListBox.Count-1 downto 0 do
    if (AnsiUpperCase(PerformForm.CommandsListBox.Items[i]) = '/J #'+AnsiUpperCase(channelName)) or (AnsiUpperCase(PerformForm.CommandsListBox.Items[i]) = '/JOIN #'+AnsiUpperCase(channelName)) then
    begin
      PerformForm.CommandsListBox.Items.Delete(i);
    end;
end;

function TPerformForm.getPerformList:TStringList;
begin
  Result := TStringList.Create;
  Result.AddStrings(CommandsListBox.Items.AnsiStrings);
end;

procedure TPerformForm.setPerformList(performList: TStringList);
begin
  CommandsListBox.Items.Clear;
  CommandsListBox.Items.AddStrings(performList);
end;

end.
