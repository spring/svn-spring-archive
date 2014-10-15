unit IgnoreListUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, SpTBXControls, TBXDkPanels, StdCtrls, CheckLst,
  TntCheckLst, SpTBXEditors;

type
  TIgnoreListForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    SpTBXLabel1: TSpTBXLabel;
    EnableIgnoresCheckBox: TSpTBXCheckBox;
    DoneButton: TSpTBXButton;
    IgnoreListBox: TSpTBXCheckListBox;
    AddIgnoreEdit: TSpTBXEdit;
    AddButton: TSpTBXSpeedButton;
    SpTBXLabel2: TSpTBXLabel;
    SpTBXLabel3: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure SaveIgnoreListToFile(FileName: string);
    procedure LoadIgnoreListFromFile(FileName: string);
    function IgnoringUser(Username: string): Boolean; // are we ignoring user Username?
    procedure AddToIgnoreList(Username: string);

    procedure DoneButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure IgnoreListBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IgnoreListForm: TIgnoreListForm;

implementation

uses PreferencesFormUnit;

{$R *.dfm}

procedure TIgnoreListForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TIgnoreListForm.SaveIgnoreListToFile(FileName: string);
var
  f: TextFile;
  i: Integer;
begin
  {$I+}
  try
    AssignFile(f, FileName);
    Rewrite(f);

    for i := 0 to IgnoreListBox.Items.Count-1 do
    begin
      if IgnoreListBox.Checked[i] then Write(f, #1) else Write(f, #0);
      Writeln(f, IgnoreListBox.Items[i]);
    end;

    CloseFile(f);
  except
    Exit;
  end;
end;

procedure TIgnoreListForm.LoadIgnoreListFromFile(FileName: string);
var
  f: TextFile;
  s: string;
  checked: Boolean;
begin
  {$I+}
  try
    AssignFile(f, FileName);
    Reset(f);

    while not Eof(f) do
    begin
      Readln(f, s);
      if s = '' then Continue;

      checked := s[1] = #1;
      s := Copy(s, 2, Length(s)-1);
      IgnoreListBox.Items.Add(s);
      IgnoreListBox.Checked[IgnoreListBox.Items.Count-1] := checked;
    end;

    CloseFile(f);
  except
    Exit;
  end;
end;

procedure TIgnoreListForm.DoneButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TIgnoreListForm.AddButtonClick(Sender: TObject);
begin
  IgnoreListBox.Items.Add(AddIgnoreEdit.Text);
  IgnoreListBox.Checked[IgnoreListBox.Items.Count-1] := True;
  AddIgnoreEdit.Text := '';
end;

procedure TIgnoreListForm.IgnoreListBoxKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if IgnoreListBox.ItemIndex = -1 then Exit;

  if Key = VK_DELETE then
    IgnoreListBox.Items.Delete(IgnoreListBox.ItemIndex);
end;

function TIgnoreListForm.IgnoringUser(Username: string): Boolean; // are we ignoring user Username?
var
  i: Integer;
begin
  for i := 0 to IgnoreListBox.Count-1 do
    if IgnoreListBox.Items[i] = Username then
    begin
      Result := IgnoreListBox.Checked[i];
      Exit;
    end;

  Result := False;
end;

procedure TIgnoreListForm.AddToIgnoreList(Username: string);
var
  i: Integer;
begin
  if IgnoreListBox.Items.IndexOf(Username) <> -1 then Exit; // username already in the list!

  IgnoreListBox.Items.Add(Username);
  IgnoreListBox.Checked[IgnoreListBox.Items.Count-1] := True;
end;

end.
