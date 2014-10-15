unit IgnoreListUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, SpTBXControls, StdCtrls, CheckLst,
  TntCheckLst, SpTBXEditors,Misc, StrUtils,MainUnit, TntStdCtrls;

type
  TIgnoreListForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    EnableIgnoresCheckBox: TSpTBXCheckBox;
    DoneButton: TSpTBXButton;
    IgnoreListBox: TSpTBXListBox;
    SpTBXLabel3: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoneButtonClick(Sender: TObject);
    procedure IgnoreListBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadIgnoreListFromFile(FileName: string);
    function SetOfflineClientIsIgnored(userName: WideString; value: Boolean):Boolean;
  end;

var
  IgnoreListForm: TIgnoreListForm;

implementation

uses PreferencesFormUnit, gnugettext;

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

procedure TIgnoreListForm.LoadIgnoreListFromFile(FileName: string);
var
  f: TextFile;
  s: string;
  checked: Boolean;
  sl: TStringList;
begin
  {$I+}
  try
    AssignFile(f, FileName);
    Reset(f);

    sl := TStringList.Create;

    while not Eof(f) do
    begin
      Readln(f, s);
      if s = '' then Continue;

      checked := s[1] = #1;
      s := Copy(s, 2, Length(s)-1);

      sl.Delimiter := ' ';
      sl.DelimitedText := s;
      TClient.SetIsIgnored(StrToInt(sl[0]),checked);
    end;

  except
    Exit;
  end;
end;

function TIgnoreListForm.SetOfflineClientIsIgnored(userName: WideString; value: Boolean):Boolean;
var
  sl: TStringList;
  i: integer;
begin
  Result := False;
  try
    sl := TStringList.Create;
    ClientsDataIni.ReadSections(sl);
    for i:=0 to sl.Count-1 do
    begin
      if LowerCase(userName) = LowerCase(TClient.GetLatestName(StrToInt(sl[i]))) then
      begin
        TClient.SetIsIgnored(StrToInt(sl[i]),value);
        Result := True;
        Exit;
      end;
    end;
  except
    MainForm.AddMainLog(_('Error: Corrupted clients data file.'),Colors.Error);
  end;
end;

procedure TIgnoreListForm.DoneButtonClick(Sender: TObject);
begin
  Preferences.UseIgnoreList := EnableIgnoresCheckBox.Checked;
  Close;
end;

procedure TIgnoreListForm.IgnoreListBoxKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  client: TClient;
begin
  if IgnoreListBox.ItemIndex = -1 then Exit;

  if Key = VK_DELETE then
  begin
    client := MainForm.GetClient(IgnoreListBox.Items[IgnoreListBox.ItemIndex]);
    if client <> nil then
      client.isIgnored := False
    else
      SetOfflineClientIsIgnored(IgnoreListBox.Items[IgnoreListBox.ItemIndex],False);

    IgnoreListBox.DeleteSelected;
  end;
end;

procedure TIgnoreListForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TIgnoreListForm.FormShow(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin
  IgnoreListBox.Clear;
  sl := TStringList.Create;
  try
    ClientsDataIni.ReadSections(sl);
    for i:=0 to sl.Count-1 do
    begin
      if TClient.GetIsIgnored(StrToInt(sl[i])) then
      begin
        IgnoreListBox.Items.Add(TClient.GetLatestName(StrToInt(sl[i])));
      end;
    end;
  except
    MainForm.AddMainLog(_('Error: Corrupted clients data file.'),Colors.Error);
  end;
end;

end.
