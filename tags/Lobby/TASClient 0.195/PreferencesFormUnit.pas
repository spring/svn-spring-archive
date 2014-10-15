unit PreferencesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Menus, JvExControls, JvComponent,
  JvXPCore, JvXPButtons, JvExStdCtrls, JvEdit, JvValidateEdit, ExtCtrls;

type

  TPreferences = record
    Version: Single; // we also need to save program version, since users could copy the old config file over the new one

    ServerIP: string[255];
    ServerPort: string[255];
    TabStyle: Byte;
    TimeStamps: Boolean;

    Username: string[255];
    Password: string[255];

    ConnectOnStartup: Boolean;

    SortStyle: Byte; // 0 - No sorting, 1 - Sort by name, 2 - Sort by status, 3 - Sort by rank
    BattleSortStyle: Byte; // 0 - Don't sort, 1 - Sort by status (open, full, in-game)
    FilterJoinLeftMessages: Boolean;
    ShowFlags: Boolean;
    MarkUnknownMaps: Boolean; // if true, all maps which you don't have will be marked in the battle list with red color
    TaskbarButtons: Boolean; // if true, each form has its own taskbar button
    JoinMainChannel: Boolean; // if true, client will join #main once connection is established
    SaveLogs: Boolean; // if true, program will automatically save all channel, private chat and battle logs.
    UseSoundNotifications: Boolean;

    UseProxy: Boolean;
    ProxyAddress: string;
    ProxyPort: Integer;
    ProxyUsername: string;
    ProxyPassword: string;
  end;

  TPreferencesForm = class(TForm)
    ApplyAndCloseButton: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    UsernameEdit: TEdit;
    PasswordEdit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    TabSheet3: TTabSheet;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Label6: TLabel;
    CancelAndCloseButton: TButton;
    SpeedButton1: TSpeedButton;
    AddressSpeedButton: TSpeedButton;
    AddressPopupMenu: TPopupMenu;
    Item1: TMenuItem;
    Item3: TMenuItem;
    Item2: TMenuItem;
    FontDialog1: TFontDialog;
    CheckBox2: TCheckBox;
    GameSettingsButton: TSpeedButton;
    SpeedButton2: TSpeedButton;
    TabSheet5: TTabSheet;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    SpeedButton3: TSpeedButton;
    CheckBox9: TCheckBox;
    JvXPButton1: TJvXPButton;
    TabSheet4: TTabSheet;
    UseProxyCheckBox: TCheckBox;
    ProxyPanel: TPanel;
    ProxyEdit: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    JvProxyPortEdit: TJvValidateEdit;
    ProxyUserEdit: TEdit;
    ProxyPassEdit: TEdit;

    procedure UpdatePreferencesTo(var p: TPreferences);
    procedure UpdatePreferencesFrom(p: TPreferences);

    procedure ReadPreferencesRecordFromRegistry(var Preferences: TPreferences);
    procedure ReadPreferencesFromRegistry;
    procedure WritePreferencesToRegistry;

    procedure SaveDefaultBattlePreferencesToRegistry;
    procedure LoadDefaultBattlePreferencesFromRegistry;

    procedure ApplyAndCloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelAndCloseButtonClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure AddressSpeedButtonClick(Sender: TObject);
    procedure Item1Click(Sender: TObject);
    procedure Item3Click(Sender: TObject);
    procedure Item2Click(Sender: TObject);
    procedure GameSettingsButtonClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure JvXPButton1Click(Sender: TObject);
    procedure UseProxyCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  DEFAULT_PREFERENCES: TPreferences = (ServerIP:'taspringmaster.clan-sy.com'; ServerPort:'8200'; TabStyle:2; TimeStamps: True; Username:''; Password:''; ConnectOnStartup: False; SortStyle: 1; BattleSortStyle: 1; FilterJoinLeftMessages: False; ShowFlags: True; MarkUnknownMaps: True; TaskbarButtons: False; JoinMainChannel: True; SaveLogs: False; UseSoundNotifications: True; UseProxy: False);
  PREFERENCES_FILENAME = 'config.dat';

var
  PreferencesForm: TPreferencesForm;
  Preferences: TPreferences;
  SaveOnClose: Boolean;
  ProgramInitialized: Boolean = False; // if True, then main initialization has been done already. We use it so we don't reinit anything.
  SaveToRegOnExit: Boolean = True; // should we save preferences to registry on exit?

implementation

uses Unit1, Misc, ShellAPI, Registry, BattleFormUnit, HostBattleFormUnit, Math,
  PasswordDialogUnit, OnlineMapsUnit, NotificationsUnit, PerformFormUnit;

{$R *.dfm}

procedure TPreferencesForm.ReadPreferencesRecordFromRegistry(var Preferences: TPreferences);
begin
  try
    try Preferences.ServerIP := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ServerIP'); except end;
    try Preferences.ServerPort := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ServerPort'); except end;
    try Preferences.TabStyle := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'TabStyle'); except end;
    try Preferences.TimeStamps := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'TimeStamps'); except end;
    try Preferences.Username := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'Username'); except end;
    try Preferences.Password := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'Password'); except end;
    try Preferences.ConnectOnStartup := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ConnectOnStartup'); except end;
    try Preferences.SortStyle := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'SortStyle'); except end;
    try Preferences.BattleSortStyle := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'BattleSortStyle'); except end;
    try Preferences.FilterJoinLeftMessages := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'FilterJoinLeftMessages'); except end;
    try Preferences.ShowFlags := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ShowFlags'); except end;
    try Preferences.MarkUnknownMaps := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'MarkUnknownMaps'); except end;
    try Preferences.TaskbarButtons := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'TaskbarButtons'); except end;
    try Preferences.JoinMainChannel := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'JoinMainChannel'); except end;
    try Preferences.SaveLogs := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'SaveLogs'); except end;
    try Preferences.UseSoundNotifications := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'UseSoundNotifications'); except end;
    try Preferences.UseProxy := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'UseProxy'); except end;
    try Preferences.ProxyAddress := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ProxyAddress'); except end;
    try Preferences.ProxyPort := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ProxyPort'); except end;
    try Preferences.ProxyUsername := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ProxyUsername'); except end;
    try Preferences.ProxyPassword:= Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ProxyPassword'); except end;
  except
  end;
end;

procedure TPreferencesForm.ReadPreferencesFromRegistry;
var
  i: Integer;
begin
  try
    try MainForm.Left := GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Left'); except end;
    try MainForm.Top := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Top'); except end;
    try MainForm.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Width'); except end;
    try MainForm.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Height'); except end;
    try MainForm.WindowState := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'WindowState'); except end;
    try MainForm.Panel2.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Splitter1'); except end;
    try MainForm.Panel3.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Splitter2'); except end;
    with MainForm.VDTBattles.Header.Columns do
      for i := 0 to Count-1 do
      try
        Items[i].Width := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Column' + IntToStr(i));
      except
      end;

    try BattleForm.Left := GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Left'); except end;
    try BattleForm.Top := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Top'); except end;
    try BattleForm.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Width'); except end;
    try BattleForm.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Height'); except end;
    try BattleForm.WindowState := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'WindowState'); except end;
    try BattleForm.Panel2.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Splitter1'); except end;
    {-->} AllowBattleDetailsUpdate := False;
    try BattleForm.StartPosRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'StartPos'); except end;
    try BattleForm.GameEndRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'GameEnd'); except end;
    try BattleForm.LimitDGunCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'LimitDGun'); except end;
    {-->} AllowBattleDetailsUpdate := True;

    try OnlineMapsForm.Left := GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'Left'); except end;
    try OnlineMapsForm.Top := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'Top'); except end;
    try OnlineMapsForm.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'Width'); except end;
    try OnlineMapsForm.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'Height'); except end;
    try OnlineMapsForm.WindowState := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'WindowState'); except end;

    try NotificationsForm.CheckBox1.Checked := GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\NotificationsForm', 'CheckBox1'); except end;

    try HostBattleForm.PortEdit.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'Port'); except end;
    try HostBattleForm.TitleEdit.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'Description'); except end;
    try HostBattleForm.PasswordEdit.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'Password'); except end;
    try HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'Mod'))); except end;
    try HostBattleForm.NATRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'NATTechnique'); except end;

    ReadPreferencesRecordFromRegistry(Preferences);
  except
  end;
end;

procedure TPreferencesForm.WritePreferencesToRegistry;
var
  i: Integer;
  Pl : TWindowPlacement; // used for API call
  R: TRect; // used for wdw pos
begin
  try

    { Calculate window's normal size and position using
      Windows API call - the form's Width, Height, Top and
      Left properties will give maximized window size if
      form is maximized, which is not what we want here }
    Pl.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(MainForm.Handle, @Pl);
    R := Pl.rcNormalPosition;

    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Left', rdInteger, R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Top', rdInteger, R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Width', rdInteger, R.Right-R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Height', rdInteger, R.Bottom-R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'WindowState', rdInteger, MainForm.WindowState);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Splitter1', rdInteger, MainForm.Panel2.Width);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Splitter2', rdInteger, MainForm.Panel3.Height);
    with MainForm.VDTBattles.Header.Columns do
      for i := 0 to Count-1 do Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\MainForm', 'Column' + IntToStr(i), rdInteger, Items[i].Width);

    Pl.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(BattleForm.Handle, @Pl);
    R := Pl.rcNormalPosition;

    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Left', rdInteger, R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Top', rdInteger, R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Width', rdInteger, R.Right-R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Height', rdInteger, R.Bottom-R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'WindowState', rdInteger, BattleForm.WindowState);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'Splitter1', rdInteger, BattleForm.Panel2.Width);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'StartPos', rdInteger, BattleForm.StartPosRadioGroup.ItemIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'GameEnd', rdInteger, BattleForm.GameEndRadioGroup.ItemIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm', 'LimitDGun', rdInteger, Misc.BoolToInt(BattleForm.LimitDGunCheckBox.Checked));

    Pl.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(OnlineMapsForm.Handle, @Pl);
    R := Pl.rcNormalPosition;

    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'Left', rdInteger, R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'Top', rdInteger, R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'Width', rdInteger, R.Right-R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'Height', rdInteger, R.Bottom-R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\OnlineMapsForm', 'WindowState', rdInteger, OnlineMapsForm.WindowState);

    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\NotificationsForm', 'CheckBox1', rdInteger, Misc.BoolToInt(NotificationsForm.CheckBox1.Checked));

    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'Port', rdString, HostBattleForm.PortEdit.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'Description', rdString, HostBattleForm.TitleEdit.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'Password', rdString, HostBattleForm.PasswordEdit.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'Mod', rdString, HostBattleForm.ModsComboBox.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\HostBattleForm', 'NATTechnique', rdInteger, HostBattleForm.NATRadioGroup.ItemIndex);

    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ServerIP', rdString, Preferences.ServerIP);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ServerPort', rdString, Preferences.ServerPort);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'TabStyle', rdInteger, Preferences.TabStyle);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'TimeStamps', rdInteger, Misc.BoolToInt(Preferences.TimeStamps));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'Username', rdString, Preferences.Username);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'Password', rdString, Preferences.Password);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ConnectOnStartup', rdInteger, Misc.BoolToInt(Preferences.ConnectOnStartup));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'SortStyle', rdInteger, Preferences.SortStyle);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'BattleSortStyle', rdInteger, Preferences.BattleSortStyle);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'FilterJoinLeftMessages', rdInteger, Misc.BoolToInt(Preferences.FilterJoinLeftMessages));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ShowFlags', rdInteger, Misc.BoolToInt(Preferences.ShowFlags));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'MarkUnknownMaps', rdInteger, Misc.BoolToInt(Preferences.MarkUnknownMaps));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'TaskbarButtons', rdInteger, Misc.BoolToInt(Preferences.TaskbarButtons));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'JoinMainChannel', rdInteger, Misc.BoolToInt(Preferences.JoinMainChannel));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'SaveLogs', rdInteger, Misc.BoolToInt(Preferences.SaveLogs));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'UseSoundNotifications', rdInteger, Misc.BoolToInt(Preferences.UseSoundNotifications));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'UseProxy', rdInteger, Misc.BoolToInt(Preferences.UseProxy));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ProxyAddress', rdString, Preferences.ProxyAddress);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ProxyPort', rdinteger, Preferences.ProxyPort);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ProxyUsername', rdString, Preferences.ProxyUsername);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Preferences', 'ProxyPassword', rdString, Preferences.ProxyPassword);
  except
  end;
end;

procedure TPreferencesForm.SaveDefaultBattlePreferencesToRegistry;
begin
  try
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'StartPos', rdInteger, BattleForm.StartPosRadioGroup.ItemIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'GameEnd', rdInteger, BattleForm.GameEndRadioGroup.ItemIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'LimitDGun', rdInteger, Misc.BoolToInt(BattleForm.LimitDGunCheckBox.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'StartMetal', rdInteger, BattleForm.MetalTracker.Value);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'StartEnergy', rdInteger, BattleForm.EnergyTracker.Value);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'MaxUnits', rdInteger, BattleForm.UnitsTracker.Value);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'GhostedBuildings', rdInteger, BattleForm.GhostedBuildingsCheckBox.Checked);
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'DiminishingMMs', rdInteger, BattleForm.DiminishingMMsCheckBox.Checked);
  except
    MessageDlg('Unable to write preferences to windows registry!', mtError, [mbOK], 0);
  end;
end;

procedure TPreferencesForm.LoadDefaultBattlePreferencesFromRegistry;
begin
  try BattleForm.StartPosRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'StartPos'); except end;
  try BattleForm.GameEndRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'GameEnd'); except end;
  try BattleForm.LimitDGunCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'LimitDGun'); except end;
  try BattleForm.MetalTracker.Value := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'StartMetal'); except end;
  try BattleForm.EnergyTracker.Value := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'StartEnergy'); except end;
  try BattleForm.UnitsTracker.Value := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'MaxUnits'); except end;
  try BattleForm.GhostedBuildingsCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'GhostedBuildings'); except end;
  try BattleForm.DiminishingMMsCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, '\Software\TASClient\Forms\BattleForm\Default', 'DiminishingMMs'); except end;
end;

procedure TPreferencesForm.ApplyAndCloseButtonClick(Sender: TObject);
begin
  if UsernameEdit.Text = '' then
  begin
    MessageDlg('"Username" field should not be left empty!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if (not VerifyName(UsernameEdit.Text)) or (not VerifyName(PasswordEdit.Text)) then
  begin
    MessageDlg('Your username and/or password consists of illegal characters!', mtWarning, [mbOK], 0);
    Exit;
  end;

  SaveOnClose := True;
  Close;
end;

{ Saves radio buttons/check boxes/etc. states into variable p }
procedure TPreferencesForm.UpdatePreferencesTo(var p: TPreferences);
var
  i: Integer;
  tmp: Boolean;
begin
  p.ServerIP := Edit1.Text;
  p.ServerPort := Edit2.Text;

  if RadioButton4.Checked then i := 0
  else if RadioButton5.Checked then i := 1
  else if RadioButton6.Checked then i := 2
  else i := 0; // this should not happen!
  p.TabStyle := i;

  p.TimeStamps := CheckBox1.Checked;

  p.Username := UsernameEdit.Text;
  p.Password := PasswordEdit.Text;

  p.ConnectOnStartup := CheckBox2.Checked;

  // SortSytle and BattleSortSytles get updated automatically (in Preferences) when we select certain sorting sytle

  p.FilterJoinLeftMessages := CheckBox3.Checked;
  p.ShowFlags := CheckBox4.Checked;
  p.MarkUnknownMaps := CheckBox5.Checked;
  p.TaskbarButtons := CheckBox6.Checked;
  p.JoinMainChannel := CheckBox7.Checked;
  tmp := p.SaveLogs;
  p.SaveLogs := CheckBox8.Checked;
  p.UseSoundNotifications := CheckBox9.Checked;

  p.UseProxy := UseProxyCheckBox.Checked;
  p.ProxyAddress := ProxyEdit.Text;
  p.ProxyPort := JvProxyPortEdit.Value;
  p.ProxyUsername := ProxyUserEdit.Text;
  p.ProxyPassword := ProxyPassEdit.Text;

  // update changes:
  MainForm.VDTBattles.Invalidate;
  MainForm.UpdateClientsListBox;
  if tmp <> p.SaveLogs then if p.SaveLogs then MainForm.OpenAllLogs else MainForm.CloseAllLogs;
end;

{ applies preferences from variable p to VCL controls (radio buttons, check boxes, etc.) }
procedure TPreferencesForm.UpdatePreferencesFrom(p: TPreferences);
begin
  Edit1.Text := p.ServerIP;
  Edit2.Text := p.ServerPort;

  if p.TabStyle = 0 then RadioButton4.Checked := True
  else if p.TabStyle = 1 then RadioButton5.Checked := True
  else if p.TabStyle = 2 then RadioButton6.Checked := True
  else RadioButton4.Checked := True; // this should not happen!

  CheckBox1.Checked := p.TimeStamps;

  MainForm.PageControl1.Style := TTabStyle(p.TabStyle);

  UsernameEdit.Text := p.Username;
  PasswordEdit.Text := p.Password;

  CheckBox2.Checked := p.ConnectOnStartup;

  MainForm.SortPopupMenu.Items[p.SortStyle].Checked := True;
  MainForm.BattleSortPopupMenu.Items[p.BattleSortStyle].Checked := True;  

  CheckBox3.Checked := p.FilterJoinLeftMessages;
  CheckBox4.Checked := p.ShowFlags;
  CheckBox5.Checked := p.MarkUnknownMaps;
  CheckBox6.Checked := p.TaskbarButtons;
  CheckBox7.Checked := p.JoinMainChannel;
  CheckBox8.Checked := p.SaveLogs;
  CheckBox9.Checked := p.UseSoundNotifications;

  UseProxyCheckBox.Checked := p.UseProxy;
  ProxyEdit.Text := p.ProxyAddress;
  JvProxyPortEdit.Value := p.ProxyPort;
  ProxyUserEdit.Text := p.ProxyUsername;
  ProxyPassEdit.Text := p.ProxyPassword;

end;

procedure TPreferencesForm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TPreferencesForm.FormShow(Sender: TObject);
begin
  SaveOnClose := False;
end;

procedure TPreferencesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ActiveControl := nil;
  { Wonder why we need ActiveControl := nil ? We need it in this case: if focus was on the radio button
    when we closed the form (by clicking the 'X' so that focus remained on radio button), then that same
    radio button would get automatically selected when form is shown and so ignoring any changes we made
    in OnShow event to Checked properties of any of the radio buttons. If you call TRadioButton.SetFocus,
    it will automatically set it's Checked property to true. }

  if SaveOnClose then
  begin
    UpdatePreferencesTo(Preferences); // save changes to p
    UpdatePreferencesFrom(Preferences); // update changes from p
  end
  else
  begin
    UpdatePreferencesFrom(Preferences);
  end;
end;

procedure TPreferencesForm.CancelAndCloseButtonClick(Sender: TObject);
begin
  SaveOnClose := False;
  Close;
end;

procedure TPreferencesForm.SpeedButton1Click(Sender: TObject);
begin
  if Status.ConnectionState = Connected then
  begin
    MessageDlg('You are not allowed to register new account while being logged-in!', mtError, [mbOK], 0);
    Exit;
  end;

  if (UsernameEdit.Text = '') or (PasswordEdit.Text = '') then
  begin
    MessageDlg('Username/password should not be blank!', mtError, [mbOK], 0);
    Exit;
  end;

  if (not VerifyName(UsernameEdit.Text)) or (not VerifyName(PasswordEdit.Text)) then
  begin
    MessageDlg('Your username and/or password consists of illegal characters!', mtWarning, [mbOK], 0);
    Exit;
  end;

  PasswordDlg.Password.Text := '';
  if PasswordDlg.ShowModal = mrCancel then Exit;
  if PasswordDlg.Password.Text <> PasswordEdit.Text then
  begin
    MessageDlg('Password differ! Please retype it', mtWarning, [mbOK], 0);
    Exit;
  end;

  PostMessage(MainForm.Handle, WM_DOREGISTER, 0, 0);
  ApplyAndCloseButton.OnClick(nil);
end;

procedure TPreferencesForm.AddressSpeedButtonClick(Sender: TObject);
var
  p: TPoint;
begin
  with AddressSpeedButton do
    p := ClientToScreen(Point(0, 0));

  AddressPopupMenu.Popup(p.x, p.y);
end;

procedure TPreferencesForm.Item1Click(Sender: TObject);
begin
  Edit1.Text := 'taspringmaster.clan-sy.com';
end;

procedure TPreferencesForm.Item3Click(Sender: TObject);
begin
  Edit1.Text := 'localhost';
end;

procedure TPreferencesForm.Item2Click(Sender: TObject);
begin
  Edit1.Text := 'cheetah.sentvid.org';
end;

procedure TPreferencesForm.GameSettingsButtonClick(Sender: TObject);
var
  tmp: Integer;
begin
  tmp := ShellExecute(MainForm.Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + 'settings.exe'), '', PChar(ExtractFilePath(Application.ExeName)), SW_SHOWNORMAL);
  if (tmp > 0) and (tmp < 32) then MessageDlg('Couldn''t find settings.exe!', mtWarning, [mbOK], 0);
end;

procedure TPreferencesForm.SpeedButton2Click(Sender: TObject);
begin
  if MessageDlg('This will remove all TASClient data from registry. Do you wish to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  RemoveRegistryKey(HKEY_CURRENT_USER, '\Software\TASClient');
  SaveToRegOnExit := False;
end;

procedure TPreferencesForm.SpeedButton3Click(Sender: TObject);
begin
  NotificationsForm.Show;
end;

procedure TPreferencesForm.JvXPButton1Click(Sender: TObject);
begin
  PerformForm.ShowModal;
end;

procedure TPreferencesForm.UseProxyCheckBoxClick(Sender: TObject);
begin
  If UseProxyCheckBox.Checked then EnableControlAndChildren(ProxyPanel)
  else DisableControlAndChildren(ProxyPanel);
end;

end.
