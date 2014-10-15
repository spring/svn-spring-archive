unit PerformFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PreferencesFormUnit, StdCtrls, JvExStdCtrls, JvListBox, Buttons,
  SpTBXControls, SpTBXEditors, TBXDkPanels, TntStdCtrls, SpTBXItem;

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

    procedure CreateParams(var Params: TCreateParams); override;

    procedure SaveCommandListToFile(FileName: string);
    procedure LoadCommandListFromFile(FileName: string);
    procedure PerformCommands;

    procedure SpeedButton1Click(Sender: TObject);
    procedure CommandsListBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PerformForm: TPerformForm;

implementation

uses Unit1;

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
    MessageDlg('Invalid command! (each command should start with "/" character', mtError, [mbOK], 0);
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
  for i := 0 to CommandsListBox.Count-1 do
    MainForm.ProcessCommand(Copy(CommandsListBox.Items[i], 2, Length(CommandsListBox.Items[i])-1), False);
end;

procedure TPerformForm.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
