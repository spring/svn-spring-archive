unit SpringSettingsProfileFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, StdCtrls, SpTBXEditors, SpTBXControls,
  TntStdCtrls, IniFiles,MainUnit;

type
  TSpringSettingsProfileForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    gbPlaying: TSpTBXGroupBox;
    SpTBXLabel1: TSpTBXLabel;
    bePlaying: TSpTBXButtonEdit;
    gbSpectator: TSpTBXGroupBox;
    beSpectator: TSpTBXButtonEdit;
    SpTBXLabel2: TSpTBXLabel;
    CustomGroupBox: TSpTBXGroupBox;
    lstCustom: TSpTBXListBox;
    btClose: TSpTBXButton;
    btAdd: TSpTBXButton;
    btEdit: TSpTBXButton;
    btDelete: TSpTBXButton;
    OpenDialog1: TOpenDialog;
    gbCustomExe: TSpTBXGroupBox;
    beCustomSpringExe: TSpTBXButtonEdit;
    OpenDialog2: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure bePlayingSubEditButton0Click(Sender: TObject);
    procedure beSpectatorSubEditButton0Click(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCloseClick(Sender: TObject);
    procedure beCustomSpringExeSubEditButton0Click(Sender: TObject);
  private
    { Private declarations }
  public
    cpNames: TStringList;
    cpFiles: TStringList;
    function countCustomProfile: integer;
    procedure getCustomProfile(index: integer; var name: string; var settingsFile: string);
    function getSettingsFile(spectator: boolean;custom: boolean; customProfileName: string):string;
    function getPlayingProfile: string;
    function getSpectatorProfile: string;
    procedure setPlayingProfile(filePath: string);
    procedure setSpectatorProfile(filePath: string);
    procedure SaveProfiles;
    procedure LoadProfiles;
    function getSpringExe:string;
    function getCustomSpringExe: string;
    procedure setCustomSpringExe(filePath: string);
    procedure clearCustomProfiles;
    procedure addCustomProfile(name: string; filePath: string);
  end;

var
  SpringSettingsProfileForm: TSpringSettingsProfileForm;

implementation

uses Misc, BattleFormUnit, gnugettext;

{$R *.dfm}

procedure TSpringSettingsProfileForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  cpNames := TStringList.Create;
  cpFiles := TStringList.Create;

  SpringSettingsProfileForm.LoadProfiles;
end;

procedure TSpringSettingsProfileForm.bePlayingSubEditButton0Click(
  Sender: TObject);
begin
  if OpenDialog1.Execute then
    bePlaying.Text := OpenDialog1.FileName;
end;

procedure TSpringSettingsProfileForm.beSpectatorSubEditButton0Click(
  Sender: TObject);
begin
  if OpenDialog1.Execute then
    beSpectator.Text := OpenDialog1.FileName;
end;

procedure TSpringSettingsProfileForm.btAddClick(Sender: TObject);
var
  profileName: string;
begin
  profileName := InputBox(_('Adding profile'),_('Profile name :'),'');
  if LowerCase(profileName) = 'default' then
  begin
    MessageDlg('Reserved profile name.',mtInformation,[mbOk],0);
    Exit;
  end;
  if (profileName <> '') and OpenDialog1.Execute then
  begin
    cpNames.Add(profileName);
    cpFiles.Add(OpenDialog1.FileName);
    lstCustom.Items.Add(profileName + ' => ' + OpenDialog1.FileName);
  end;
end;

procedure TSpringSettingsProfileForm.btDeleteClick(Sender: TObject);
begin
  if lstCustom.ItemIndex > -1 then
  begin
    if BattleForm.SpringSettingsProfile = cpNames[lstCustom.ItemIndex] then
      BattleForm.SpringSettingsProfile := '';
    cpNames.Delete(lstCustom.ItemIndex);
    cpFiles.Delete(lstCustom.ItemIndex);
    lstCustom.DeleteSelected;
  end;
end;

procedure TSpringSettingsProfileForm.btEditClick(Sender: TObject);
var
  profileName: string;
begin
  if lstCustom.ItemIndex = -1 then Exit;
  profileName := InputBox(_('Editing profile'),_('Profile name :'),cpNames[lstCustom.ItemIndex]);
  OpenDialog1.FileName := cpFiles[lstCustom.ItemIndex];
  if (profileName <> '') and OpenDialog1.Execute then
  begin
    if BattleForm.SpringSettingsProfile = cpNames[lstCustom.ItemIndex] then
      BattleForm.SpringSettingsProfile := profileName;
    cpNames[lstCustom.ItemIndex] := profileName;
    cpFiles[lstCustom.ItemIndex] := OpenDialog1.FileName;
    lstCustom.Items[lstCustom.ItemIndex] := profileName + ' => ' + OpenDialog1.FileName;
  end;
end;

function TSpringSettingsProfileForm.getSettingsFile(spectator: boolean;custom: boolean; customProfileName: string):string;
begin
  if not custom then
    if spectator then
      Result := beSpectator.Text
    else
      Result := bePlaying.Text
  else
    if cpNames.IndexOf(customProfileName) = -1 then
      raise Exception.Create(_('Unknown spring settings profile name.'))
    else
      Result := cpFiles[cpNames.IndexOf(customProfileName)];
end;

function TSpringSettingsProfileForm.countCustomProfile: integer;
begin
  Result := cpNames.Count;
end;

procedure TSpringSettingsProfileForm.getCustomProfile(index: integer; var name: string; var settingsFile: string);
begin
  name := cpNames[index];
  settingsFile := cpFiles[index];
end;

procedure TSpringSettingsProfileForm.SaveProfiles;
var
  Ini : TIniFile;
  i:integer;
  FileName:String;
begin
  try
    FileName := ExtractFilePath(Application.ExeName) + SPRING_SETTINGS_PROFILE_FILE;
    if FileExists(FileName) then
      DeleteFile(FileName);
    Ini := TIniFile.Create(FileName);
    Ini.WriteString('Default','Playing',bePlaying.Text);
    Ini.WriteString('Default','Spectator',beSpectator.Text);
    Ini.WriteString('Default','CustomExe',beCustomSpringExe.Text);

    for i:=0 to cpNames.Count-1 do
      Ini.WriteString(cpNames[i],'File',cpFiles[i]);

    Ini.Free;
  except
    Exit;
  end;
end;
procedure TSpringSettingsProfileForm.LoadProfiles;
var
  Ini : TIniFile;
  i:integer;
  FileName: String;
begin
  FileName := ExtractFilePath(Application.ExeName) + SPRING_SETTINGS_PROFILE_FILE;
  if not FileExists(FileName) then Exit;
  Ini := TIniFile.Create(FileName);
  bePlaying.Text := Ini.ReadString('Default','Playing','');
  beSpectator.Text := Ini.ReadString('Default','Spectator','');
  beCustomSpringExe.Text := Ini.ReadString('Default','CustomExe','');

  cpNames.Clear;
  cpFiles.Clear;
  lstCustom.Clear;
  
  Ini.ReadSections(cpNames);
  cpNames.Delete(cpNames.IndexOf('Default'));
  for i:=0 to cpNames.Count-1 do
  begin
    cpFiles.Add(Ini.ReadString(cpNames[i],'File',''));
    lstCustom.Items.Add(cpNames[i] + ' => ' + cpFiles[i]);
  end;

  if cpNames.IndexOf(BattleForm.SpringSettingsProfile) = -1 then
    BattleForm.SpringSettingsProfile := '';
end;



procedure TSpringSettingsProfileForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveProfiles;
end;

procedure TSpringSettingsProfileForm.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TSpringSettingsProfileForm.beCustomSpringExeSubEditButton0Click(
  Sender: TObject);
begin
  if OpenDialog2.Execute then
    beCustomSpringExe.Text := OpenDialog2.FileName;
end;

function TSpringSettingsProfileForm.getSpringExe:string;
begin
  if BattleForm.sspST.Checked then
    Result := 'spring.exe'
  else if BattleForm.sspMT.Checked then
    Result := 'spring-multithreaded.exe'
  else
    Result := beCustomSpringExe.Text;
end;

function TSpringSettingsProfileForm.getCustomSpringExe: string;
begin
  Result := beCustomSpringExe.Text;
end;

procedure TSpringSettingsProfileForm.setPlayingProfile(filePath: string);
begin
  bePlaying.Text := filePath;
end;

procedure TSpringSettingsProfileForm.setSpectatorProfile(filePath: string);
begin
  beSpectator.Text := filePath;
end;

function TSpringSettingsProfileForm.getPlayingProfile: string;
begin
  Result := bePlaying.Text;
end;

function TSpringSettingsProfileForm.getSpectatorProfile: string;
begin
  Result := beSpectator.Text;
end;

procedure TSpringSettingsProfileForm.setCustomSpringExe(filePath: string);
begin
  beCustomSpringExe.Text := filePath;
end;

procedure TSpringSettingsProfileForm.clearCustomProfiles;
begin
  cpNames.Clear;
  cpFiles.Clear;
  lstCustom.Clear;
end;

procedure TSpringSettingsProfileForm.addCustomProfile(name: string; filePath: string);
begin
  cpNames.Add(name);
  cpFiles.Add(filePath);
  lstCustom.Items.Add(name + ' => ' + filePath);
end;

end.
