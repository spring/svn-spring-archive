{ Warning: Default theme  must be called 'Default' or theming may raise exceptions }

unit PreferencesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Menus, JvExControls, JvComponent,
  JvXPCore, JvXPButtons, JvExStdCtrls, JvEdit, JvValidateEdit, ExtCtrls,
  JvPageList, JvNavigationPane, JvComponentBase, JvTabBar, JvLookOut,
  JvSpeedbar, JvExExtCtrls, JvCaptionPanel, JvExComCtrls, JvComCtrls, JvButton,
  JvMovableBevel, TntStdCtrls, SpTBXEditors, SpTBXControls, SpTBXItem, SpTBXTabs,
  TB2Item, VirtualTrees, OverbyteIcsHttpProt,  RichEdit2, ExRichEdit, MainUnit,OverbyteIcsWSocket,
  TntComCtrls, languagecodes,DockPanel, SpTBXSkins, pngimage,
  OverbyteIcsWndControl;

type

  TJvXPCustomButtonHack = class(TJvXPCustomButton); // a hack to expose Color property

  TSpTBXTASClientSkin = class(TSpTBXSkinOptions)
  public
    procedure FillOptions; override;
    procedure PaintBackground(ACanvas: TCanvas; ARect: TRect; Component: TSpTBXSkinComponentsType; State: TSpTBXSkinStatesType; Background, Borders: Boolean; Vertical: Boolean = False; ForceRectBorders: TAnchors = []); override;
  end;

  TSpTBXTASClientLightSkin = class(TSpTBXSkinOptions)
  public
    procedure FillOptions; override;
    procedure PaintBackground(ACanvas: TCanvas; ARect: TRect; Component: TSpTBXSkinComponentsType; State: TSpTBXSkinStatesType; Background, Borders: Boolean; Vertical: Boolean = False; ForceRectBorders: TAnchors = []); override;
  end;

  TPreferences = record
    Version: Single; // we also need to save program version, since users could copy the old config file over the new one

    ServerIP: string[255];
    RedirectIP: string[255];
    ServerPort: string[255];
    TabStyle: Byte;
    TimeStamps: Boolean;

    Username: string[255];
    Password: string[255];
    RememberPasswords : boolean;

    ConnectOnStartup: Boolean;

    SortAsc: Boolean;
    SortStyle: Integer; // 0 - No sorting, 1 - Sort by name, 2 - Sort by status, 3 - Sort by rank, 4 - Sort by country
    BattleSortStyle: Integer; // 0 - Don't sort, 1 - Sort by status (open, full, in-game), 2 - sort by mod, 3 - sort by players, 4 - sort by map, 5 - sort by host, 6 - sort by description
                           // (use BattleSortStyleToColumn/ColumnToBattleSortStyle to transform between battle treeview column index and battle sort style)
    BattleSortDirection: Byte; // 0 - ASCENDING, 1 - DESCDENDING
    BattleClientSortStyle : Integer; // tab index
    BattleClientSortDirection : Boolean; // 0 - ASCENDING, 1 - DESCDENDING
    FilterJoinLeftMessages: Boolean;
    FilterBattleJoinLeftMessages: Boolean;
    ShowFlags: Boolean;
    MarkUnknownMaps: Boolean; // if true, all maps which you don't have will be marked in the battle list with red color
    TaskbarButtons: Boolean; // if true, each form has its own taskbar button
    JoinMainChannel: Boolean; // if true, client will join #main once connection is established
    ReconnectToBackup: Boolean; // if true, client will try to connect to next backup host in list if current one fails
    SaveLogs: Boolean; // if true, program will automatically save all channel, private chat and battle logs.
    UseSoundNotifications: Boolean;
    AutoCompletionFromCurrentChannel: Boolean;
    AutoUpdateToBeta: Boolean;
    DisplayUnitsIconsAndNames: Boolean;
    DisplayAutohostInterface: Boolean;
    AutoSaveChanSession: Boolean;

    UseProxy: Boolean;
    ProxyAddress: string;
    ProxyPort: Integer;
    ProxyUsername: string;
    ProxyPassword: string;

    HighlightColor: Integer; // e.g.: 'Green'
    UseNotificationsForHighlights: Boolean; // use notifications when highlighting selected keywords?

    UseIgnoreList: Boolean; // if true, then each time we receive something from a user we check if he is in our ignore list and filter out his message accordingly
    WarnIfUsingNATTraversing: Boolean; // if true, then there will be a warning icon displayed next to each battle in the battle list that uses any form of NAT traversing
    AutoFocusOnPM: Boolean; // if true, focus will automatically switch to private chat window upon receiving a private message from the user
    LastOpenMap: String; // name of the last map open. On program start, we will try to load this map by default
    MapSortStyle: Byte; // see MapSortStyleDescriptions to see what value stands for what
    ThemeType: TSpTBXSkinType;
    Theme: string;
    AdvancedSkinning: Boolean;
    SkinnedTitlebars: Boolean;

    DisableAllSounds: Boolean; // if true, lobby won't play any sounds
    UploadReplay:Boolean;
    SortLocal: Boolean;
    DisplayQuickJoinPanel: Boolean;

    LimitChatLogs: Boolean;
    ChatLogsLimit: integer;
    ChatLogLoadLoading: Boolean;
    ChatLogLoadLines: integer;

    SPSkin: string;

    ScriptsDisabled: Boolean; // can only be changed at start
    EnableScripts: Boolean;
    ScriptWarningMsgShown: Boolean;

    EnableSpringDownloader: Boolean;

    UseLogonForm : boolean;
    DisableNews: boolean;

    LanguageCode: String;
    DisableMapDetailsLoading: Boolean;
    LoadMetalHeightMinimaps: Boolean;
  end;
  PPreferences = ^TPreferences;

  TPreferencesForm = class(TForm)
    AddressPopupMenu: TSpTBXPopupMenu;
    SpTBXTitleBar1: TSpTBXTitleBar;
    HttpCli1: THttpCli;
    LayoutDefault: TTntEdit;
    LanguageCombobox: TSpTBXComboBox;
    SpTBXLabel2: TSpTBXLabel;
    SpTBXTabControl1: TSpTBXTabControl;
    SpTBXTabItem6: TSpTBXTabItem;
    SpTBXTabItem5: TSpTBXTabItem;
    SpTBXTabItem4: TSpTBXTabItem;
    SpTBXTabItem3: TSpTBXTabItem;
    SpTBXTabItem2: TSpTBXTabItem;
    SpTBXTabItem1: TSpTBXTabItem;
    SpTBXTabItem7: TSpTBXTabItem;
    SpTBXTabSheet6: TSpTBXTabSheet;
    GroupBox1: TSpTBXGroupBox;
    Label1: TSpTBXLabel;
    Label2: TSpTBXLabel;
    ServerPortEdit: TSpTBXEdit;
    CheckBox10: TSpTBXCheckBox;
    CheckBox2: TSpTBXCheckBox;
    CheckBox7: TSpTBXCheckBox;
    ServerAddressEdit: TSpTBXButtonEdit;
    SpTBXTabSheet5: TSpTBXTabSheet;
    GroupBox2: TSpTBXGroupBox;
    RegisterAccountButton: TSpTBXSpeedButton;
    Label4: TSpTBXLabel;
    Label5: TSpTBXLabel;
    UsernameEdit: TSpTBXEdit;
    PasswordEdit: TSpTBXEdit;
    RememberPasswordsCheckBox: TSpTBXCheckBox;
    SpTBXTabSheet4: TSpTBXTabSheet;
    GroupBox3: TSpTBXGroupBox;
    ResetRegistryButton: TSpTBXSpeedButton;
    NotificationsButton: TSpTBXSpeedButton;
    HighlightingButton: TSpTBXSpeedButton;
    IgnoreListButton: TSpTBXSpeedButton;
    Label6: TSpTBXLabel;
    RadioButton4: TSpTBXRadioButton;
    RadioButton5: TSpTBXRadioButton;
    RadioButton6: TSpTBXRadioButton;
    CheckBox8: TSpTBXCheckBox;
    CheckBox9: TSpTBXCheckBox;
    CheckForNewVersionCheckBox: TSpTBXCheckBox;
    ColorsButton: TSpTBXButton;
    ManageGroupsButton: TSpTBXButton;
    EnableSpringDownloaderCheckBox: TSpTBXCheckBox;
    UseLogonFormCheckBox: TSpTBXCheckBox;
    TipsButton: TSpTBXButton;
    SpringSettingsProfilesButton: TSpTBXButton;
    SpTBXTabSheet3: TSpTBXTabSheet;
    GroupBox4: TSpTBXGroupBox;
    CheckBox1: TSpTBXCheckBox;
    CheckBox3: TSpTBXCheckBox;
    CheckBox4: TSpTBXCheckBox;
    CheckBox5: TSpTBXCheckBox;
    CheckBox6: TSpTBXCheckBox;
    WarnNATCheckBox: TSpTBXCheckBox;
    AutoFocusOnPMCheckBox: TSpTBXCheckBox;
    DisableAllSoundsCheckBox: TSpTBXCheckBox;
    UploadReplayCheckBox: TSpTBXCheckBox;
    SortLocalCheckBox: TSpTBXCheckBox;
    DisplayQuickJoinPanelCheckBox: TSpTBXCheckBox;
    FilterBattleJoinLeftCheckBox: TSpTBXCheckBox;
    AutoCompletionCurrentChannelCheckBox: TSpTBXCheckBox;
    ChatLogsLimitCheckBox: TSpTBXCheckBox;
    ChatLogsLimitTracker: TSpTBXTrackBar;
    DisplayUnitsIconsAndNamesCheckBox: TSpTBXCheckBox;
    DisableNewsCheckBox: TSpTBXCheckBox;
    DoNotLoadMapInfos: TSpTBXCheckBox;
    LoadMetalHeightMaps: TSpTBXCheckBox;
    DisplayAutoHostInterfaceCheckBox: TSpTBXCheckBox;
    ChatLogLoadingTracker: TSpTBXTrackBar;
    ChatLogLoadingCheckBox: TSpTBXCheckBox;
    SpTBXTabSheet2: TSpTBXTabSheet;
    GroupBox6: TSpTBXGroupBox;
    UseProxyCheckBox: TSpTBXCheckBox;
    ProxyPanel: TSpTBXPanel;
    ProxyEdit: TSpTBXEdit;
    Label7: TSpTBXLabel;
    Label8: TSpTBXLabel;
    ProxyUserEdit: TSpTBXEdit;
    Label9: TSpTBXLabel;
    Label10: TSpTBXLabel;
    ProxyPassEdit: TSpTBXEdit;
    SpTBXTabSheet7: TSpTBXTabSheet;
    ScriptsDebugWindowBt: TSpTBXButton;
    ScriptsReloadBt: TSpTBXButton;
    ScriptsLoadNewBt: TSpTBXButton;
    ScriptsAdvancedOptionsBt: TSpTBXButton;
    EnableScriptsCheckBox: TSpTBXCheckBox;
    SpTBXTabSheet1: TSpTBXTabSheet;
    GroupBox5: TSpTBXGroupBox;
    ThemesComboBox: TSpTBXComboBox;
    SpTBXRadioButton1: TSpTBXRadioButton;
    SpTBXRadioButton2: TSpTBXRadioButton;
    Label3: TSpTBXLabel;
    SpTBXRadioButton3: TSpTBXRadioButton;
    Label11: TSpTBXLabel;
    ApplyAndCloseButton: TSpTBXButton;
    CancelAndCloseButton: TSpTBXButton;
    LoadSkinButton: TSpTBXButton;
    OpenDialog1: TOpenDialog;
    memoTASClientSkin: TTntMemo;
    AdvancedSkinningCheckBox: TSpTBXCheckBox;
    SkinEditorButton: TSpTBXButton;
    PerformButton: TSpTBXSpeedButton;
    SpTBXWebsiteButton: TSpTBXButton;
    SkinnedTitlebarsCheckBox: TSpTBXCheckBox;
    memoTASClientLightSkin: TTntMemo;
    JvProxyPortEdit: TSpTBXSpinEdit;
    AutoSaveChansSessionCheckbox: TSpTBXCheckBox;

    function BattleSortStyleToColumn(SortStyle: Integer): Integer;
    function ColumnToBattleSortStyle(Column: Integer): Integer;

    procedure UpdatePreferencesTo(var p: TPreferences);
    procedure UpdatePreferencesFrom(p: TPreferences);

    procedure ReadPreferencesRecordFromRegistry(var Preferences: TPreferences);
    procedure ReadPreferencesFromRegistry;
    procedure WritePreferencesToRegistry;
    procedure ApplyPostInitializationPreferences;
    procedure FixFormBounds(Form: TForm);
    function IfNotClNone(colorCheck: TColor; colorElse: TColor): TColor;
    procedure ApplyCurrentThemeType; // we must call this every time we change Preferences.ThemeType field
    procedure ApplyCurrentTheme; // we must call this every time we change Preferences.Theme field
    procedure UpdateVirtualTreeSkin(VT: TBaseVirtualTree);
    procedure UpdateRichEdit(RE: TRichEdit);
    procedure UpdateExRichEdit(RE: TExRichEdit);
    procedure UpdateTntMemo(TM: TTntMemo);

    procedure SaveDefaultBattlePreferencesToRegistry;
    procedure LoadDefaultBattlePreferencesFromRegistry;

    procedure ApplyAndCloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelAndCloseButtonClick(Sender: TObject);
    procedure RegisterAccountButtonClick(Sender: TObject);
    procedure AddressPopupMenuItemClick(Sender: TObject);
    procedure GameSettingsButtonClick(Sender: TObject);
    procedure ResetRegistryButtonClick(Sender: TObject);
    procedure NotificationsButtonClick(Sender: TObject);
    procedure JvXPButton1Click(Sender: TObject);
    procedure UseProxyCheckBoxClick(Sender: TObject);
    procedure HighlightingButtonClick(Sender: TObject);
    procedure ThemesComboBoxChange(Sender: TObject);
    procedure SpTBXRadioButton1Click(Sender: TObject);
    procedure SpTBXRadioButton2Click(Sender: TObject);
    procedure SpTBXRadioButton3Click(Sender: TObject);
    procedure IgnoreListButtonClick(Sender: TObject);
    procedure KeyEditorButtonClick(Sender: TObject);
    procedure ColorsButtonClick(Sender: TObject);
    procedure ManageGroupsButtonClick(Sender: TObject);
    procedure ChatLogsLimitTrackerChange(Sender: TObject);
    procedure PasswordEditChange(Sender: TObject);
    procedure ScriptsReloadBtClick(Sender: TObject);
    procedure ScriptsLoadNewBtClick(Sender: TObject);
    procedure ScriptsDebugWindowBtClick(Sender: TObject);
    procedure ScriptsAdvancedOptionsBtClick(Sender: TObject);
    procedure TipsButtonClick(Sender: TObject);
    procedure SpringSettingsProfilesButtonClick(Sender: TObject);
    procedure ApplyAfterTranslate;
    procedure ResetDockingLayoutButtonClick(Sender: TObject);
    procedure ChatLogLoadingTrackerChange(Sender: TObject);
    procedure LoadSkinButtonClick(Sender: TObject);
    procedure SkinEditorButtonClick(Sender: TObject);
    procedure PerformButtonClick(Sender: TObject);
    procedure SpTBXWebsiteButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    LangCodes: TStringList;
    
    procedure PopulateServerListMenu;
    function isLoggedOnOfficialServer: Boolean;
    procedure applyPreferences(newPref: TPreferences; async: boolean);
    procedure asyncApplyPreferences(oldPref: TPreferences);
  end;

  TServerListItem =
  record
    Name: string;
    Address: string;
    Port: string;
  end;

const
  DEFAULT_PREFERENCES: TPreferences = (ServerIP:'lobby.springrts.com'; ServerPort:'8200'; TabStyle:0; TimeStamps: True; Username:''; Password:'';
                                        RememberPasswords: False; ConnectOnStartup: False; SortAsc: True ;SortStyle: 1; BattleSortStyle: 1; BattleSortDirection: 0;
                                        BattleClientSortStyle: 2;FilterJoinLeftMessages: False;FilterBattleJoinLeftMessages: False; ShowFlags: True;
                                        MarkUnknownMaps: False; TaskbarButtons: True; JoinMainChannel: True; ReconnectToBackup: True; SaveLogs: True;
                                        UseSoundNotifications: True;AutoCompletionFromCurrentChannel: False; AutoUpdateToBeta: False;DisplayUnitsIconsAndNames: False;
                                        DisplayAutohostInterface: True;AutoSaveChanSession: True; UseProxy: False; HighlightColor: clGreen; UseNotificationsForHighlights: True; UseIgnoreList: False;
                                        WarnIfUsingNATTraversing: True; AutoFocusOnPM: True; MapSortStyle: 1; ThemeType: sknSkin; Theme: 'TASClient';AdvancedSkinning : True;
                                        SkinnedTitlebars: True ;DisableAllSounds: False; SortLocal: False; DisplayQuickJoinPanel : True; LimitChatLogs: False; ChatLogsLimit: 800;
                                        ChatLogLoadLoading: True; ChatLogLoadLines: 30; SPSkin: 'default.ssk'; ScriptsDisabled : False; EnableScripts : True;
                                        ScriptWarningMsgShown: False; EnableSpringDownloader : True; UseLogonForm : True; DisableNews : False; DisableMapDetailsLoading: False;
                                        LoadMetalHeightMinimaps: True);

var
  PreferencesForm: TPreferencesForm;
  Preferences: TPreferences;
  CommandLineServer: string;
  CommandLinePort: string;
  SaveOnClose: Boolean;
  ProgramInitialized: Boolean = False; // if True, then main initialization has been done already. We use it so we don't reinit anything.
  SaveToRegOnExit: Boolean = True; // should we save preferences to registry on exit?
  PasswordChanged: Boolean = False; // has the user changed the password ? if yes it must be crypted before being saved
  SaveLayoutOnClose: Boolean = True;

  ServerList: array of TServerListItem;

  implementation

uses Misc, ShellAPI, Registry, BattleFormUnit, HostBattleFormUnit, Math,
  NotificationsUnit, PerformFormUnit, HighlightingUnit,
  NewAccountUnit, IgnoreListUnit, MapListFormUnit, ColorsPreferenceUnit,
  ManageGroups, ReplaysUnit, PythonScriptDebugFormUnit, LobbyScriptUnit,
  SpringDownloaderFormUnit, LogonFormUnit, TipsFormUnit,
  TemplateEditorFormUnit, SpringSettingsProfileFormUnit, gnugettext,
  AutoTeamsUnit, ChannelsListFormUnit, AutoJoinFormUnit, InitWaitFormUnit,
  DisableUnitsFormUnit, MenuFormUnit, AddBotUnit, AwayMessageFormUnit,
  UploadReplayUnit,CustomizeGUIFormUnit, HostInfoUnit, HelpUnit, Types,
  HttpGetUnit, SplashScreenUnit, DebugUnit, WidgetDBFormUnit;

{$R *.dfm}

procedure TPreferencesForm.ReadPreferencesRecordFromRegistry(var Preferences: TPreferences);
begin
  try
    try Preferences.ServerIP := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ServerIP'); except end;
    try Preferences.ServerPort := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ServerPort'); except end;
    try Preferences.TabStyle := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'TabStyle2'); except end;
    try Preferences.TimeStamps := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'TimeStamps'); except end;
    try Preferences.Username := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'Username'); except end;
    try Preferences.Password := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'Password'); except end;
    try Preferences.UseLogonForm := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseLogonForm'); except end;
    try Preferences.AutoSaveChanSession := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AutoSaveChanSession'); except end;
    if (Length(Preferences.Password) <> 24)  and (Length(Preferences.Password) > 0) then // not md5 password = old system
      Preferences.Password := Misc.GetMD5Hash(Preferences.Password);
    try
      Preferences.RememberPasswords := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'RememberPasswords');
    except
      Preferences.RememberPasswords := Preferences.Password <> '';
    end;

    try Preferences.ConnectOnStartup := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ConnectOnStartup'); except end;
    try Preferences.SortStyle := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SortStyle'); except end;
    try Preferences.SortAsc := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SortAsc'); except end;
    try Preferences.BattleSortStyle := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'BattleSortStyle'); except end;
    try Preferences.BattleSortDirection := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'BattleSortDirection'); except end;
    try Preferences.BattleClientSortStyle := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'BattleClientSortStyle'); except end;
    try Preferences.BattleClientSortDirection := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'BattleClientSortDirection'); except end;
    try Preferences.FilterJoinLeftMessages := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'FilterJoinLeftMessages'); except end;
    try Preferences.FilterBattleJoinLeftMessages := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'FilterBattleJoinLeftMessages'); except end;
    try Preferences.AutoCompletionFromCurrentChannel := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AutoCompletionFromCurrentChannel'); except end;
    try Preferences.ShowFlags := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ShowFlags'); except end;
    try Preferences.DisplayUnitsIconsAndNames := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisplayUnitsIconsAndNames'); except end;
    try Preferences.MarkUnknownMaps := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'MarkUnknownMapsNMods'); except end;
    try Preferences.TaskbarButtons := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'TaskbarButtons'); except end;
    try Preferences.JoinMainChannel := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'JoinMainChannel'); except end;
    try Preferences.ReconnectToBackup := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ReconnectToBackup'); except end;
    try Preferences.SaveLogs := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SaveLogs'); except end;
    try Preferences.UseSoundNotifications := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseSoundNotifications'); except end;
    try Preferences.UseProxy := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseProxy'); except end;
    try Preferences.ProxyAddress := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ProxyAddress'); except end;
    try Preferences.ProxyPort := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ProxyPort'); except end;
    try Preferences.ProxyUsername := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ProxyUsername'); except end;
    try Preferences.ProxyPassword:= Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ProxyPassword'); except end;
    try Preferences.HighlightColor:= Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'HighlightColor'); except end;
    try Preferences.UseNotificationsForHighlights := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseNotificationsForHighlights'); except end;
    try Preferences.AutoUpdateToBeta := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'CheckForNewVersion'); except end;
    try Preferences.EnableSpringDownloader := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'EnableSpringDownloader'); except end;
    try Preferences.UseIgnoreList := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseIgnoreList'); except end;
    try Preferences.WarnIfUsingNATTraversing := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'WarnIfUsingNATTraversing'); except end;
    try Preferences.AutoFocusOnPM := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AutoFocusOnPM'); except end;
    try Preferences.LastOpenMap := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'LastOpenMap'); except end;
    try Preferences.MapSortStyle := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'MapSortStyle'); except end;
    try Preferences.ThemeType := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ThemeType2'); except end;
    try Preferences.Theme := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'Theme2'); except end;
    try Preferences.AdvancedSkinning := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AdvancedSkinning'); except end;
    try Preferences.SkinnedTitlebars := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SkinnedTitlebars'); except end;
    try Preferences.DisableAllSounds := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisableAllSounds'); except end;
    try Preferences.SortLocal := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SortLocal'); except end;
    try Preferences.UploadReplay := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AskUploadReplay'); except end;
    try Preferences.DisplayQuickJoinPanel := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisplayQuickJoinPanelv2'); except end;
    try Preferences.LanguageCode := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'LanguageCode'); except end;
    try
      Preferences.EnableScripts := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ScriptsEnabled3');
      Preferences.ScriptsDisabled := not Preferences.EnableScripts;
    except end;
    try Preferences.ScriptWarningMsgShown := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ScriptWarningMsgShown'); except end;
    try Preferences.LimitChatLogs := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'LimitChatLogs'); except end;
    try
      Preferences.ChatLogsLimit := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ChatLogsLimit');
      Preferences.ChatLogsLimit := max(ChatLogsLimitTracker.Min,min(ChatLogsLimitTracker.Max,Preferences.ChatLogsLimit));
    except end;
    try Preferences.ChatLogLoadLoading := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ChatLogLoadLoading'); except end;
    try
      Preferences.ChatLogLoadLines := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ChatLogLoadLines');
      Preferences.ChatLogLoadLines := max(ChatLogLoadingTracker.Min,min(ChatLogLoadingTracker.Max,Preferences.ChatLogLoadLines));
    except end;
    try Preferences.SPSkin := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SPTheme'); except end;
    try Preferences.DisableNews := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisableNews3'); except end;
    try Preferences.DisableMapDetailsLoading := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisableMapDetailsLoading'); except end;
    try Preferences.LoadMetalHeightMinimaps := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'LoadMetalHeightMinimaps2'); except end;
    try Preferences.DisplayAutohostInterface := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisplayAutohostInterface'); except end;


    try CommonFont.Name := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'FontName'); except end;
    try CommonFont.Size := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'FontSize'); except end;
    try (TMyTabSheet(MainForm.ChatTabs[0]).FindChildControl('RichEdit') as TExRichEdit).Font.Assign(CommonFont); except end;
    try Colors.Normal := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Normal'); except end;
    try Colors.MyText := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'MyText'); except end;
    try Colors.AdminText := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'AdminText2'); except end;
    try Colors.Data := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Data'); except end;
    try Colors.Error := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Error'); except end;
    try Colors.Info := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Info'); except end;
    try Colors.MinorInfo := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'MinorInfo'); except end;
    try Colors.ChanJoin := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'ChanJoin'); except end;
    try Colors.ChanLeft := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'ChanLeft'); except end;
    try Colors.MOTD := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'MOTD'); except end;
    try Colors.SayEx := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'SayEx'); except end;
    try Colors.Topic := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Topic'); except end;
    try Colors.OldMsgs := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'OldMsgs'); except end;
    try Colors.ClientAway := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'ClientAway'); except end;
    try Colors.MapModUnavailable := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'MapModUnavailable'); except end;
    try Colors.BotText := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'BotText'); except end;
    try Colors.BattleDetailsNonDefault := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'BattleDetailsNonDefault'); except end;
    try Colors.BattleDetailsChanged := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'BattleDetailsChanged'); except end;
    try Colors.ClientIngame := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'ClientIngame'); except end;
    try Colors.ReplayWinningTeam := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'ReplayWinningTeam'); except end;
    try Colors.SkillLowUncertainty := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'SkillLowUncertainty'); except end;
    try Colors.SkillAvgUncertainty := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'SkillAvgUncertainty'); except end;
    try Colors.SkillHighUncertainty := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'SkillHighUncertainty'); except end;
    try Colors.SkillVeryHighUncertainty := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'SkillVeryHighUncertainty'); except end;
  except
  end;
end;

procedure TPreferencesForm.ReadPreferencesFromRegistry;
var
  i: Integer;
begin
  try
    try MainForm.Left := GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Left'); except end;
    try MainForm.Top := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Top'); except end;
    try MainForm.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Width'); except end;
    try MainForm.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Height'); except end;
//***    try MainForm.WindowState := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'WindowState'); except end;
// we will apply the above line after we load everything because it has some strange effect: if we left main window in minimized mode (when we closed the program), this line will update the form before we finished initializing it (setting WindowState property probably triggers form's Update method). This is why we do it later.
    try MainForm.PlayerListPanel.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Splitter1'); except end;
    //try MainForm.Panel3.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Splitter2'); except end;
    try MainForm.EnableFilters.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'EnableFilters'); except end;
    try MainForm.FiltersTabs.ActiveTabIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'FiltersActiveTab'); except end;
    try MainForm.mnuLockView.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'LockView'); except end;
    try MainForm.mnuReloadViewLogin.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'ReloadViewLogin'); except end;
    try
      if (MainForm.BattlePlayersButton.ImageIndex=3) and not Boolean(Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'DisplayBattlePlayers')) then
        MainForm.BattlePlayersButtonClick(nil);
    except
    end;
    try MainForm.BattlePlayersPanel.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'BattlePlayersPanelWidth'); except end;


    try ReplaysForm.FiltersTabs.ActiveTabIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'ReplayFiltersActiveTab'); except end;

    with MainForm.VDTBattles.Header.Columns do
      for i := 0 to Count-1 do
      try
        Items[i].Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Column' + IntToStr(i));
        Items[i].Position := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'ColumnPosition' + IntToStr(i));
      except
      end;
    FixFormBounds(MainForm);

    try WidgetDBForm.Left := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Left'); except end;
    try WidgetDBForm.Top := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Top'); except end;
    try WidgetDBForm.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Width'); except end;
    try WidgetDBForm.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Height'); except end;
    try WidgetDBForm.WindowState := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'WindowState'); except end;
    try WidgetDBForm.pnlWidgetInfo.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'PnlWidgetInfoHeight'); except end;
    try WidgetDBForm.wbScreenShots.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'WbScreenShotsHeight'); except end;
    try WidgetDBForm.vstWidgetList.Header.SortColumn := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'SortColumn'); except end;
    try
      if Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'SortDirection') = 0 then
        WidgetDBForm.vstWidgetList.Header.SortDirection := sdAscending
      else
        WidgetDBForm.vstWidgetList.Header.SortDirection := sdDescending;
    except
    end;
    with WidgetDBForm.vstWidgetList.Header.Columns do
      for i := 0 to Count-1 do
      try
        Items[i].Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Column2_' + IntToStr(i));
        Items[i].Position := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'ColumnPosition2_' + IntToStr(i));
      except
      end;
    FixFormBounds(WidgetDBForm);


    try BattleForm.Left := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Left'); except end;
    try BattleForm.Top := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Top'); except end;
    try BattleForm.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Width'); except end;
    try BattleForm.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Height'); except end;
    try BattleForm.WindowState := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'WindowState'); except end;
    FixFormBounds(BattleForm);
    //try BattleForm.Panel1.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Splitter4'); except end;
    //try BattleForm.Panel4.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Splitter2'); except end;
    //try BattleForm.Panel6.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Splitter3'); except end;
    try BattleForm.KeepRatioItem.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'KeepMinimapRatio'); except end;
    try BattleForm.SpringSettingsProfile := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'SpringSettingsProfile'); except end;
    try BattleForm.mnuAutoLockOnStart.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'AutoLockOnStart'); except end;
    try BattleForm.mnuHideAutoHostMsgs.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'HideAutoHostMsgs'); except end;
    try BattleForm.AutoHostInfoPanel.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'AutoHostInfoSplitter'); except end;
    try BattleForm.sspST.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'SingleThreadedExe'); except end;
    try BattleForm.sspMT.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'MultiThreadedExe'); except end;
    try BattleForm.sspCustomExe.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'CustomExe'); except end;


    try AutoTeamsForm.ClansCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoTeam', 'ClanBalance'); except end;
    try AutoTeamsForm.NoNewIdsCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoTeam', 'KeepIds'); except end;
    AutoTeamsForm.NoNewIdsCheckBoxClick(nil);

    {-->} AllowBattleDetailsUpdate := False;
    //try BattleForm.StartPosRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'StartPos'); except end;
    //try BattleForm.GameEndRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'GameEnd'); except end;
    //try BattleForm.LimitDGunCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'LimitDGun'); except end;
    try BattleForm.MySideButton.Tag := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Side'); except end;
    //try BattleForm.UnitsTracker.Value := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Units'); except end;
    //try BattleForm.LockGameSpeedCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'LockSpeed'); except end;


    {-->} AllowBattleDetailsUpdate := True;
    with BattleForm.VDTBattleClients.Header.Columns do
      for i := 0 to Count-1 do
      try
        Items[i].Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Column' + IntToStr(i));
        Items[i].Position := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'ColumnPosition' + IntToStr(i));
      except
      end;
    FixFormBounds(BattleForm);

    try NotificationsForm.CheckBox1.Checked := GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\NotificationsForm', 'CheckBox1'); except end;

    try HostBattleForm.PortEdit.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'Port'); except end;
    try HostBattleForm.TitleEdit.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'Description'); except end;
    try HostBattleForm.AutoSendDescCheckbox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'DescriptionAutoSend'); except end;
    try HostBattleForm.PasswordEdit.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'Password'); except end;
    try HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'Mod'))); except end;
    try HostBattleForm.NATRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'NATTechnique'); except end;
    try HostBattleForm.PlayersTracker.Value := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'NbPlayer'); except end;
    try HostBattleForm.RelayHostCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'RelayHost'); except end;
    try HostBattleForm.RelayChatCheckBox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'RelayChat'); except end;

    try MapListForm.Left := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'Left'); except end;
    try MapListForm.Top := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'Top'); except end;
    try MapListForm.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'Width'); except end;
    try MapListForm.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'Height'); except end;
    try MapListForm.WindowState := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'WindowState'); except end;
    try MapListForm.MinimapDisplayCheckbox.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'MinimapDisplay'); except end;
    FixFormBounds(MapListForm);

    // read custom team colors to registry:
    // (first assign default team colors in case if reading from registry fails)
    TeamColors := DefaultTeamColors;
    for i := 0 to High(TeamColors) do
      try TeamColors[i] := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\TeamColors', 'Color' + IntToStr(i)); except end;

    try ReplaysForm.Left := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Left'); except end;
    try ReplaysForm.Top := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Top'); except end;
    try ReplaysForm.Width := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Width'); except end;
    try ReplaysForm.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Height'); except end;
    try ReplaysForm.chkEnableFilters.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'FiltersEnabled'); except end;
    try ReplaysForm.BottomPanel.Height := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Spliter1'); except end;

    try TipsForm.chkShowTips.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\TipsForm', 'ShowTips'); except end;

    try TemplateEditorForm.ProfileTemplate.Lines.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\TemplateEditor', 'LayoutGlobal2'); except end;
    try TemplateEditorForm.LayoutPropertyChange.Lines.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\TemplateEditor', 'LayoutProperty2'); except end;
    try TemplateEditorForm.RecordPropertyChange.Lines.Text := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\TemplateEditor', 'RecordProperty2'); except end;

    try AutoJoinForm.chkKeepLookingAfterJoining.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoJoinForm', 'KeepLookingAfterJoining'); except end;
    try AutoJoinForm.chkLeaveNotFittingBattles.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoJoinForm', 'LeaveNotFittingBattles'); except end;
    try AutoJoinForm.chkStopAutoJoinWhenLeaving.Checked := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoJoinForm', 'StopAutoJoinWhenLeaving'); except end;

    try ChannelsListForm.VDTChannels.Header.SortColumn := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ChannelsList', 'ChannelsSortColumn'); except end;
    try
      if Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ChannelsList', 'ChannelsSortDirection') = 0 then
        ChannelsListForm.VDTChannels.Header.SortDirection := sdAscending
      else
        ChannelsListForm.VDTChannels.Header.SortDirection := sdDescending;
    except
    end;

    try MenuForm.MePlayer.Name := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MenuForm', 'PlayerName'); except end;

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

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Left', rdInteger, R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Top', rdInteger, R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Width', rdInteger, R.Right-R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Height', rdInteger, R.Bottom-R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'WindowState', rdInteger, MainForm.WindowState);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'MonitorIndex', rdInteger, MainForm.Monitor.MonitorNum);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Splitter1', rdInteger, MainForm.PlayerListPanel.Width);
    //Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Splitter2', rdInteger, MainForm.Panel3.Height);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'EnableFilters', rdInteger, Misc.BoolToInt(MainForm.EnableFilters.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'FiltersActiveTab', rdInteger, MainForm.FiltersTabs.ActiveTabIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'ReplayFiltersActiveTab', rdInteger, ReplaysForm.FiltersTabs.ActiveTabIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'LockView', rdInteger, Misc.BoolToInt(MainForm.mnuLockView.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'ReloadViewLogin', rdInteger, Misc.BoolToInt(MainForm.mnuReloadViewLogin.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'DisplayBattlePlayers', rdInteger, Misc.BoolToInt(MainForm.BattlePlayersButton.ImageIndex = 3));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'BattlePlayersPanelWidth', rdInteger, MainForm.BattlePlayersPanel.Width);


    with MainForm.VDTBattles.Header.Columns do
      for i := 0 to Count-1 do
      begin
        Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'Column' + IntToStr(i), rdInteger, Items[i].Width);
        Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'ColumnPosition' + IntToStr(i), rdInteger, Items[i].Position);
      end;

    Pl.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(WidgetDBForm.Handle, @Pl);
    R := Pl.rcNormalPosition;

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Left', rdInteger, R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Top', rdInteger, R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Width', rdInteger, R.Right-R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Height', rdInteger, R.Bottom-R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'WindowState', rdInteger, WidgetDBForm.WindowState);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'PnlWidgetInfoHeight', rdInteger, WidgetDBForm.pnlWidgetInfo.Height);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'WbScreenShotsHeight', rdInteger, WidgetDBForm.wbScreenShots.Height);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'SortColumn', rdInteger, WidgetDBForm.vstWidgetList.Header.SortColumn);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'SortDirection', rdInteger, IfThen(WidgetDBForm.vstWidgetList.Header.SortDirection = sdAscending,0,1));
    with WidgetDBForm.vstWidgetList.Header.Columns do
      for i := 0 to Count-1 do
      begin
        Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'Column2_' + IntToStr(i), rdInteger, Items[i].Width);
        Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\WidgetDBForm', 'ColumnPosition2_' + IntToStr(i), rdInteger, Items[i].Position);
      end;


    Pl.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(BattleForm.Handle, @Pl);
    R := Pl.rcNormalPosition;

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Left', rdInteger, R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Top', rdInteger, R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Width', rdInteger, R.Right-R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Height', rdInteger, R.Bottom-R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'WindowState', rdInteger, BattleForm.WindowState);
    //Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Splitter4', rdInteger, BattleForm.Panel1.Height);
    //Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Splitter2', rdInteger, BattleForm.Panel4.Height);
    //Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Splitter3', rdInteger, BattleForm.Panel6.Width);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'KeepMinimapRatio', rdInteger, Misc.BoolToInt(BattleForm.KeepRatioItem.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'SpringSettingsProfile', rdString, BattleForm.SpringSettingsProfile);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'AutoLockOnStart', rdInteger, Misc.BoolToInt(BattleForm.mnuAutoLockOnStart.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Side', rdInteger, BattleForm.MySideButton.Tag);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'HideAutoHostMsgs', rdInteger, Misc.BoolToInt(BattleForm.mnuHideAutoHostMsgs.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'AutoHostInfoSplitter', rdInteger, BattleForm.AutoHostInfoPanel.Height);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'SingleThreadedExe', rdInteger, Misc.BoolToInt(BattleForm.sspST.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'MultiThreadedExe', rdInteger, Misc.BoolToInt(BattleForm.sspMT.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'CustomExe', rdInteger, Misc.BoolToInt(BattleForm.sspCustomExe.Checked));


    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoTeam', 'ClanBalance', rdInteger, Misc.BoolToInt(AutoTeamsForm.ClansCheckBox.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoTeam', 'KeepIds', rdInteger, Misc.BoolToInt(AutoTeamsForm.NoNewIdsCheckBox.Checked));

    with BattleForm.VDTBattleClients.Header.Columns do
      for i := 0 to Count-1 do
      begin
        Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'Column' + IntToStr(i), rdInteger, Items[i].Width);
        Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm', 'ColumnPosition' + IntToStr(i), rdInteger, Items[i].Position);
      end;

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\NotificationsForm', 'CheckBox1', rdInteger, Misc.BoolToInt(NotificationsForm.CheckBox1.Checked));

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'Port', rdString, HostBattleForm.PortEdit.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'Description', rdString, HostBattleForm.TitleEdit.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'DescriptionAutoSend', rdInteger, Misc.BoolToInt(HostBattleForm.AutoSendDescCheckbox.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'Password', rdString, HostBattleForm.PasswordEdit.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'Mod', rdString, HostBattleForm.ModsComboBox.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'NATTechnique', rdInteger, HostBattleForm.NATRadioGroup.ItemIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'NbPlayer', rdInteger, HostBattleForm.PlayersTracker.Value);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'RelayHost', rdInteger, Misc.BoolToInt(HostBattleForm.RelayHostCheckBox.Checked));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\HostBattleForm', 'RelayChat', rdInteger, Misc.BoolToInt(HostBattleForm.RelayChatCheckBox.Checked));


    Pl.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(MapListForm.Handle, @Pl);
    R := Pl.rcNormalPosition;

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'Left', rdInteger, MapListForm.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'Top', rdInteger, MapListForm.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'Width', rdInteger, R.Right-R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'Height', rdInteger, R.Bottom-R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'WindowState', rdInteger, MapListForm.WindowState);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MapListForm', 'MinimapDisplay', rdInteger, Misc.BoolToInt(MapListForm.MinimapDisplayCheckbox.Checked));

    Pl.Length := SizeOf(TWindowPlacement);
    GetWindowPlacement(ReplaysForm.Handle, @Pl);
    R := Pl.rcNormalPosition;

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Left', rdInteger, R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Top', rdInteger, R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Width', rdInteger, R.Right-R.Left);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Height', rdInteger, R.Bottom-R.Top);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'FiltersEnabled', rdInteger, ReplaysForm.chkEnableFilters.Checked);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ReplaysForm', 'Spliter1', rdInteger, ReplaysForm.BottomPanel.Height);

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoJoinForm', 'KeepLookingAfterJoining', rdInteger, AutoJoinForm.chkKeepLookingAfterJoining.Checked);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoJoinForm', 'LeaveNotFittingBattles', rdInteger, AutoJoinForm.chkLeaveNotFittingBattles.Checked);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\AutoJoinForm', 'StopAutoJoinWhenLeaving', rdInteger, AutoJoinForm.chkStopAutoJoinWhenLeaving.Checked);


    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\TipsForm', 'ShowTips', rdInteger, Misc.BoolToInt(TipsForm.chkShowTips.Checked));

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ChannelsList', 'ChannelsSortColumn', rdInteger, ChannelsListForm.VDTChannels.Header.SortColumn);
    if ChannelsListForm.VDTChannels.Header.SortDirection = sdAscending then
      Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ChannelsList', 'ChannelsSortDirection', rdInteger, 0)
    else
      Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\ChannelsList', 'ChannelsSortDirection', rdInteger, 1);

    try
      Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MenuForm', 'PlayerName', rdString, MenuForm.MePlayer.Name);
    except
    end;

    // write custom team colors to registry:
    for i := 0 to High(TeamColors) do
      Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\TeamColors', 'Color' + IntToStr(i), rdInteger, TeamColors[i]);

    // write preferences record to registry:
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ServerIP', rdString, Preferences.ServerIP);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ServerPort', rdString, Preferences.ServerPort);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'TabStyle2', rdInteger, Preferences.TabStyle);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'TimeStamps', rdInteger, Misc.BoolToInt(Preferences.TimeStamps));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'Username', rdString, Preferences.Username);
    if Preferences.RememberPasswords then
    begin
      Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'Password', rdString, Preferences.Password);
    end
    else
    begin
      Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'Password', rdString, '');
    end;
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'RememberPasswords', rdInteger, Misc.BoolToInt(Preferences.RememberPasswords));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseLogonForm', rdInteger, Misc.BoolToInt(Preferences.UseLogonForm));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ConnectOnStartup', rdInteger, Misc.BoolToInt(Preferences.ConnectOnStartup));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SortStyle', rdInteger, Preferences.SortStyle);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SortAsc', rdInteger, Preferences.SortAsc);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'BattleSortStyle', rdInteger, Preferences.BattleSortStyle);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'BattleSortDirection', rdInteger, Preferences.BattleSortDirection);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'BattleClientSortStyle', rdInteger, Preferences.BattleClientSortStyle);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'BattleClientSortDirection', rdInteger, Preferences.BattleClientSortDirection);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'FilterJoinLeftMessages', rdInteger, Misc.BoolToInt(Preferences.FilterJoinLeftMessages));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'FilterBattleJoinLeftMessages', rdInteger, Misc.BoolToInt(Preferences.FilterBattleJoinLeftMessages));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AutoCompletionFromCurrentChannel', rdInteger, Misc.BoolToInt(Preferences.AutoCompletionFromCurrentChannel));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ShowFlags', rdInteger, Misc.BoolToInt(Preferences.ShowFlags));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisplayUnitsIconsAndNames', rdInteger, Misc.BoolToInt(Preferences.DisplayUnitsIconsAndNames));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'MarkUnknownMapsNMods', rdInteger, Misc.BoolToInt(Preferences.MarkUnknownMaps));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'TaskbarButtons', rdInteger, Misc.BoolToInt(Preferences.TaskbarButtons));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'JoinMainChannel', rdInteger, Misc.BoolToInt(Preferences.JoinMainChannel));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ReconnectToBackup', rdInteger, Misc.BoolToInt(Preferences.ReconnectToBackup));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SaveLogs', rdInteger, Misc.BoolToInt(Preferences.SaveLogs));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseSoundNotifications', rdInteger, Misc.BoolToInt(Preferences.UseSoundNotifications));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseProxy', rdInteger, Misc.BoolToInt(Preferences.UseProxy));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ProxyAddress', rdString, Preferences.ProxyAddress);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ProxyPort', rdinteger, Preferences.ProxyPort);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ProxyUsername', rdString, Preferences.ProxyUsername);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ProxyPassword', rdString, Preferences.ProxyPassword);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'HighlightColor', rdinteger, Preferences.HighlightColor);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseNotificationsForHighlights', rdInteger, Preferences.UseNotificationsForHighlights);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'CheckForNewVersion', rdInteger, Misc.BoolToInt(Preferences.AutoUpdateToBeta));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'EnableSpringDownloader', rdInteger, Misc.BoolToInt(Preferences.EnableSpringDownloader));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'UseIgnoreList', rdInteger, Preferences.UseIgnoreList);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'WarnIfUsingNATTraversing', rdInteger, Preferences.WarnIfUsingNATTraversing);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AutoFocusOnPM', rdInteger, Preferences.AutoFocusOnPM);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'LastOpenMap', rdString, Preferences.LastOpenMap);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'MapSortStyle', rdInteger, Preferences.MapSortStyle);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ThemeType2', rdInteger, Preferences.ThemeType);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'Theme2', rdString, Preferences.Theme);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AdvancedSkinning', rdInteger, Misc.BoolToInt(Preferences.AdvancedSkinning));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SkinnedTitlebars', rdInteger, Misc.BoolToInt(Preferences.SkinnedTitlebars));
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisableAllSounds', rdInteger, Preferences.DisableAllSounds);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SortLocal', rdInteger, Preferences.SortLocal);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AskUploadReplay', rdInteger, Preferences.UploadReplay);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'FontName', rdString, CommonFont.Name);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'FontSize', rdInteger, CommonFont.Size);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisplayQuickJoinPanelv2', rdInteger, Preferences.DisplayQuickJoinPanel);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ScriptsEnabled3', rdInteger, Preferences.EnableScripts);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ScriptWarningMsgShown', rdInteger, Preferences.ScriptWarningMsgShown);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'LimitChatLogs', rdInteger, Preferences.LimitChatLogs);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ChatLogsLimit', rdInteger, Preferences.ChatLogsLimit);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ChatLogLoadLoading', rdInteger, Preferences.ChatLogLoadLoading);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'ChatLogLoadLines', rdInteger, Preferences.ChatLogLoadLines);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'SPTheme', rdString, Preferences.SPSkin);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisableNews3', rdInteger, Preferences.DisableNews);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'LanguageCode', rdString, Preferences.LanguageCode);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisableMapDetailsLoading', rdInteger, Preferences.DisableMapDetailsLoading);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'LoadMetalHeightMinimaps2', rdInteger, Preferences.LoadMetalHeightMinimaps);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'DisplayAutohostInterface', rdInteger, Preferences.DisplayAutohostInterface);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences', 'AutoSaveChanSession', rdInteger, Misc.BoolToInt(Preferences.AutoSaveChanSession));

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'MyText', rdInteger, Colors.MyText);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'AdminText2', rdInteger, Colors.AdminText);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Normal', rdInteger, Colors.Normal);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Data', rdInteger, Colors.Data);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Error', rdInteger, Colors.Error);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Info', rdInteger, Colors.Info);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'MinorInfo', rdInteger, Colors.MinorInfo);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'ChanJoin', rdInteger, Colors.ChanJoin);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'ChanLeft', rdInteger, Colors.ChanLeft);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'MOTD', rdInteger, Colors.MOTD);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'SayEx', rdInteger, Colors.SayEx);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'Topic', rdInteger, Colors.Topic);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\ChatColors2', 'OldMsgs', rdInteger, Colors.OldMsgs);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'ClientAway', rdInteger, Colors.ClientAway);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'MapModUnavailable', rdInteger, Colors.MapModUnavailable);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'BotText', rdInteger, Colors.BotText);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'BattleDetailsNonDefault', rdInteger, Colors.BattleDetailsNonDefault);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'BattleDetailsChanged', rdInteger, Colors.BattleDetailsChanged);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'ClientIngame', rdInteger, Colors.ClientIngame);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'ReplayWinningTeam', rdInteger, Colors.ReplayWinningTeam);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'SkillLowUncertainty', rdInteger, Colors.SkillLowUncertainty);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'SkillAvgUncertainty', rdInteger, Colors.SkillAvgUncertainty);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'SkillHighUncertainty', rdInteger, Colors.SkillHighUncertainty);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Preferences\OtherColors2', 'SkillHighUncertainty', rdInteger, Colors.SkillHighUncertainty);

    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\TemplateEditor', 'LayoutGlobal2', rdString, TemplateEditorForm.ProfileTemplate.Lines.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\TemplateEditor', 'LayoutProperty2', rdString, TemplateEditorForm.LayoutPropertyChange.Lines.Text);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\TemplateEditor', 'RecordProperty2', rdString, TemplateEditorForm.RecordPropertyChange.Lines.Text);
  except
  end;
end;

procedure TPreferencesForm.SaveDefaultBattlePreferencesToRegistry;
begin
  try
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'StartPos', rdInteger, BattleForm.StartPosRadioGroup.ItemIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'GameEnd', rdInteger, BattleForm.GameEndRadioGroup.ItemIndex);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'StartMetal', rdInteger, BattleForm.MetalTracker.Position);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'StartEnergy', rdInteger, BattleForm.EnergyTracker.Position);
    Misc.SetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'MaxUnits', rdInteger, BattleForm.UnitsTracker.Position);
  except
    MessageDlg(_('Unable to write preferences to windows registry!'), mtError, [mbOK], 0);
  end;
end;

procedure TPreferencesForm.LoadDefaultBattlePreferencesFromRegistry;
begin
  try BattleForm.StartPosRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'StartPos'); except end;
  try BattleForm.GameEndRadioGroup.ItemIndex := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'GameEnd'); except end;
  try BattleForm.MetalTracker.Position := Min(BattleForm.MetalTracker.Max,Max(BattleForm.MetalTracker.Min,Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'StartMetal'))); except end;
  try BattleForm.EnergyTracker.Position := Min(BattleForm.EnergyTracker.Max,Max(BattleForm.EnergyTracker.Min,Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'StartEnergy'))); except end;
  try BattleForm.UnitsTracker.Position := Min(BattleForm.UnitsTracker.Max,Max(BattleForm.UnitsTracker.Min,Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\BattleForm\Default', 'MaxUnits'))); except end;
end;

{ call this method after all forms have been initialized, just before hiding the splash screen!
  The problem is, if this preferences are applied before, some strange effects may occur.
  For example, if we assign main form's WindowState to wsMaximized it will show the main form
  and so hide the splash screen (also, it will show main form in "distorted" form, e.g. withouth it's
  controls properly sized and aligned - since initialization hasn't been completed yet. }
procedure TPreferencesForm.ApplyPostInitializationPreferences;
begin
  try MainForm.WindowState := Misc.GetRegistryData(HKEY_CURRENT_USER, TASCLIENT_REGISTRY_KEY+'\Forms\MainForm', 'WindowState'); except end;
  UpdateTntMemo(BattleForm.InputEdit);
  UpdateTntMemo(TTntMemo(TMyTabSheet(MainForm.ChatTabs[0]).FindChildControl('InputEdit')));
end;

{ will check form's bounds and adjust them if they appear outside the visible area etc.
  This fixes some problem that user experienced with 0.30 version (and possibly with older
  versions as well, just not as often as with 0.30) when upon restarting the client battle
  form or map list form didn't appear on screen (they had some large negative value for
  TForm.Left property). This usually happens when program crashes. Still not sure why
  it happens though. }
procedure TPreferencesForm.FixFormBounds(Form: TForm);
begin
  if Form.Top < 0 then Form.Top := 10;
  if Form.Left < 0 - (Form.Width - 100) then Form.Left := 10;
  if Form.Width > Screen.Width then Form.Width := Screen.Width;
  if Form.Height > Screen.Height then Form.Height := Screen.Height;
  { should probably also check if width/height is smaller than
    certain value, but that is more tedious since different forms have
    different prefered sizes }
end;

function TPreferencesForm.IfNotClNone(colorCheck: TColor; colorElse: TColor): TColor;
begin
  Result := colorElse;
  if colorCheck <> clNone then
    Result := colorCheck;
end;

procedure TPreferencesForm.ApplyCurrentThemeType; // we must call this every time we change Preferences.ThemeType field
var
  i: Integer;
  titleBar: TSpTBXTitleBar;
  c: TControl;
  f: TForm;
  h,w,t,l: integer;
begin
  for i := 0 to Screen.FormCount-1 do
  begin
    f := Screen.Forms[i];
    if (f <> SplashScreenForm) and (f <> CustomizeGUIForm) and (f <> DebugForm) then
    begin
      if MainUnit.Debug.Enabled then
        Misc.TryToAddLog(MainUnit.StartDebugLog,'Applying theme on "'+f.Name+'"('+f.ClassName+') ...');
      SkinManager.ChangeControlSkinType(f,Preferences.ThemeType,True);

      if MainForm.Visible then Continue;

      c := f.FindChildControl('SpTBXTitleBar1');
      if c = nil then
        c := f.FindChildControl('MainTitleBar');

      if c <> nil then
      begin
        titleBar := TSpTBXTitleBar(c);
        if (Preferences.ThemeType=sknSkin) and Preferences.SkinnedTitlebars then
        begin
          t := f.Top;
          l := f.Left;
          h := f.Height;
          w := f.Width;
          titleBar.Active := True;
          titleBar.Refresh;
          f.BorderStyle := Forms.bsNone;

          if titleBar.FixedSize then
          begin
            f.Height := h-GetSystemMetrics(SM_CYCAPTION)-SkinManager.CurrentSkin.FloatingWindowBorderSize*2;
            f.Width := w-SkinManager.CurrentSkin.FloatingWindowBorderSize*2;
          end;
          f.Top := t;
          f.Left := l;
        end
        else if titleBar.FixedSize and not titleBar.Active then
        begin
          f.BorderStyle := bsDialog;
          titleBar.Align := alNone;
          titleBar.Top := -26;
          f.HorzScrollBar.Visible := False;
          f.VertScrollBar.Visible := false;
          f.Width := f.Width-5;
          f.Height := f.Height-26;
        end;
      end;
    end;
  end;

  ApplyCurrentTheme;

  case Preferences.ThemeType of
    sknNone: ThemesComboBox.Enabled := False;
    sknWindows: ThemesComboBox.Enabled := False;
    sknSkin: ThemesComboBox.Enabled := True;
  end; // of case

  if PreferencesForm.Visible then
    PreferencesForm.SetFocus;
end;

procedure TPreferencesForm.ApplyCurrentTheme; // we must call this every time we change Preferences.Theme field
var
  i: integer;
  PanelDarkerColor: TColor;
  f: TForm;
begin
  if (Preferences.ThemeType = sknSkin) then
    if FileExists(Preferences.Theme) then
      SkinManager.LoadFromFile(Preferences.Theme)
    else
      SkinManager.SetSkin(Preferences.Theme)
  else
    SkinManager.SetToDefaultSkin;

  if SkinManager.CurrentSkinName = 'TASClient Skin' then
  begin
    MainForm.ConnectionStateImageList.Clear;
    MainForm.ConnectionStateImageList.AddImages(MainForm.ConnectionStateDarkImageList);
    MainForm.ArrowList.Clear;
    MainForm.ArrowList.AddImages(MainForm.ArrowDarkList);
  end
  else
  begin
    MainForm.ConnectionStateImageList.Clear;
    MainForm.ConnectionStateImageList.AddImages(MainForm.ConnectionStateLightImageList);
    MainForm.ArrowList.Clear;
    MainForm.ArrowList.AddImages(MainForm.ArrowLightList);
  end;

  if (Preferences.ThemeType = sknSkin) and Preferences.AdvancedSkinning then
  begin
    if DirectoryExists(SCROLLING_NEWS_DIR_DEFAULT + '\' + SkinManager.CurrentSkinName) then
      SCROLLING_NEWS_DIR := SCROLLING_NEWS_DIR_DEFAULT + '\' + SkinManager.CurrentSkinName
    else
      SCROLLING_NEWS_DIR := SCROLLING_NEWS_DIR_DEFAULT;

    if MainForm.ScrollingNewsBrowser <> nil then
      MainForm.ScrollingNewsTimerTimer(nil);

    PanelDarkerColor := RGB(Floor(ColorToR(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1)*0.8),Floor(ColorToG(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1)*0.8),Floor(ColorToB(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1)*0.8));
    BattleForm.QuickLookRichEdit.Color :=  IfNotClNone(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1,clBtnFace);
    MapListForm.ScrollBox1.Color :=  PanelDarkerColor;
    MainForm.ClientsListBox.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncListItem).Body.Color1,clWindow);
    MainForm.ClientsListBox.BorderStyle := Forms.bsNone;
    MainForm.BattlePlayersListBox.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncListItem).Body.Color1,clWindow);
    MainForm.BattlePlayersListBox.BorderStyle := Forms.bsNone;
    ReplaysForm.CommentsRichEdit.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncEditFrame).Body.Color1,clWindow);
    ReplaysForm.CommentsRichEdit.Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal),clWindowText);
    ReplaysForm.CommentsRichEdit.BorderStyle := Forms.bsNone;
    ReplaysForm.ScriptRichEdit.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncEditFrame).Body.Color1,clWindow);
    ReplaysForm.ScriptRichEdit.Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal),clWindow);
    ReplaysForm.ScriptRichEdit.BorderStyle := Forms.bsNone;
    BattleForm.AutoHostMsgsRichEdit.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1,clBtnFace);
    HelpForm.TntScrollBox1.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1,clWindow);
    HostInfoForm.Label3.Font.Color := clWhite;
    HostInfoForm.Label5.Font.Color := clWhite;
    BattleForm.lblEnergy.Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncLabel,sknsNormal),clBlue);
    BattleForm.lblMetal.Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncLabel,sknsNormal),clBlue);
    BattleForm.lblUnits.Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncLabel,sknsNormal),clBlue);
    MapListForm.lblLoadMissingMinimaps.Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncLabel,sknsNormal),clBlue);
    MapListForm.SortLabel.Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncLabel,sknsNormal),clBlue);
    MainForm.MainDockPanel.Color :=  IfNotClNone(SkinManager.CurrentSkin.Options(skncWindow).Body.Color1,clBtnFace);
    BattleForm.BattleMiddlePanel.Color :=  IfNotClNone(SkinManager.CurrentSkin.Options(skncWindow).Body.Color1,clBtnFace);
    BattleForm.MapPanel.Color :=  IfNotClNone(SkinManager.CurrentSkin.Options(skncWindow).Body.Color1,clBtnFace);
    BattleForm.Repaint;
    for i := 0 to Screen.FormCount-1 do
    begin
      f := Screen.Forms[i];
      if (f <> CustomizeGUIForm) and (f <> DebugForm) and (f <> SplashScreenForm) then
        f.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncWindow).Body.Color1,clBtnFace);
    end;
  end
  else
  begin
    BattleForm.QuickLookRichEdit.Color :=  clBtnFace;
    MainForm.ClientsListBox.Color := clWindow;
    MainForm.ClientsListBox.BorderStyle := Forms.bsSingle;
    MainForm.BattlePlayersListBox.Color := clWindow;
    MainForm.BattlePlayersListBox.BorderStyle := Forms.bsSingle;
    ReplaysForm.CommentsRichEdit.Color := clWindow;
    ReplaysForm.CommentsRichEdit.Font.Color := clWindowText;
    ReplaysForm.CommentsRichEdit.BorderStyle := Forms.bsSingle;
    ReplaysForm.ScriptRichEdit.Color := clWindow;
    ReplaysForm.ScriptRichEdit.Font.Color := clWindowText;
    ReplaysForm.ScriptRichEdit.BorderStyle :=Forms.bsSingle;
    BattleForm.AutoHostMsgsRichEdit.Color := clBtnFace;
    HelpForm.TntScrollBox1.Color := clWindow;
    HostInfoForm.Label3.Font.Color := clBlue;
    HostInfoForm.Label5.Font.Color := clBlue;
    BattleForm.lblEnergy.Font.Color := clBlue;
    BattleForm.lblMetal.Font.Color := clBlue;
    BattleForm.lblUnits.Font.Color := clBlue;
    MapListForm.lblLoadMissingMinimaps.Font.Color := clBlue;
    MapListForm.SortLabel.Font.Color := clBlue;
    MapListForm.ScrollBox1.Color :=  clMedGray;
    MainForm.MainDockPanel.Color :=  clBtnFace;
    BattleForm.BattleMiddlePanel.Color :=  clBtnFace;
    BattleForm.MapPanel.Color :=  clBtnFace;
    for i := 0 to Screen.FormCount-1 do
      Screen.Forms[i].Color := clBtnFace;
  end;
  BattleForm.MapOptionsScrollBox.Color :=  BattleForm.QuickLookRichEdit.Color;
  BattleForm.ModOptionsScrollBox.Color :=  BattleForm.QuickLookRichEdit.Color;
  UpdateVirtualTreeSkin(MainForm.VDTBattles);
  UpdateVirtualTreeSkin(MainForm.FilterList);
  UpdateVirtualTreeSkin(BattleForm.VDTBattleClients);
  UpdateVirtualTreeSkin(BattleForm.VDTDisabledUnits);
  UpdateVirtualTreeSkin(ReplaysForm.VDTReplays);
  UpdateVirtualTreeSkin(ReplaysForm.VDTPlayers);
  UpdateVirtualTreeSkin(ReplaysForm.FilterList);
  UpdateVirtualTreeSkin(AddBotForm.VSTAIList);
  UpdateVirtualTreeSkin(WidgetDBForm.vstWidgetList);
  AddBotForm.VSTAIList.Colors.FocusedSelectionColor := clHighlight;
  AddBotForm.VSTAIList.Colors.FocusedSelectionBorderColor := clHighlight;
  UpdateVirtualTreeSkin(AutoJoinForm.VSTAutoplayPresetList);
  UpdateVirtualTreeSkin(AutoJoinForm.VSTAutospecPresetList);
  UpdateVirtualTreeSkin(DisableUnitsForm.VDTUnits);
  UpdateVirtualTreeSkin(AddBotForm.VSTAIList);
  UpdateVirtualTreeSkin(ChannelsListForm.VDTChannels);

  UpdateRichEdit(AwayMessageForm.MessageRichEdit);
  UpdateRichEdit(UploadReplayForm.DescriptionRtBox);
  UpdateExRichEdit(BattleForm.ChatRichEdit);

  UpdateRichEdit(WidgetDBForm.reChangelog);
  UpdateRichEdit(WidgetDBForm.reComments);
  UpdateRichEdit(WidgetDBForm.reMyComment);

  UpdateTntMemo(BattleForm.InputEdit);
  
  for i:=0 to MainForm.ChatTabs.Count-1 do
  begin
    UpdateExRichEdit(TExRichEdit(TMyTabSheet(MainForm.ChatTabs[i]).FindChildControl('RichEdit')));
    UpdateTntMemo(TTntMemo(TMyTabSheet(MainForm.ChatTabs[i]).FindChildControl('InputEdit')));
  end;

  MapListForm.RepaintMapItems;
end;

procedure TPreferencesForm.UpdateVirtualTreeSkin(VT: TBaseVirtualTree);
var
  i: integer;
  hdr: TVTHeader;
begin
  if VT is TVirtualDrawTree then
  begin
    if (SkinManager.GetSkinType = sknSkin) and Preferences.AdvancedSkinning then
    begin
      TVirtualDrawTree(VT).TreeOptions.PaintOptions := TVirtualDrawTree(VT).TreeOptions.PaintOptions + [toHotTrack];
      TVirtualDrawTree(VT).Header.Options := TVirtualDrawTree(VT).Header.Options + [hoHotTrack];
      TVirtualDrawTree(VT).Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncListItem).Body.Color1,clWindow);
      TVirtualDrawTree(VT).Colors.FocusedSelectionColor := TVirtualDrawTree(VT).Color;
      TVirtualDrawTree(VT).Colors.FocusedSelectionBorderColor := TVirtualDrawTree(VT).Color;
      TVirtualDrawTree(VT).Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsNormal),clWindowText);
      TVirtualDrawTree(VT).BorderStyle := Forms.bsNone;
    end
    else
    begin
      TVirtualDrawTree(VT).TreeOptions.PaintOptions := TVirtualDrawTree(VT).TreeOptions.PaintOptions - [toHotTrack];
      TVirtualDrawTree(VT).Header.Options := TVirtualDrawTree(VT).Header.Options - [hoHotTrack];
      TVirtualDrawTree(VT).Color := clWindow;
      TVirtualDrawTree(VT).Colors.FocusedSelectionColor := clHighlight;
      TVirtualDrawTree(VT).Colors.FocusedSelectionBorderColor := clHighlight;
      TVirtualDrawTree(VT).Font.Color := clWindowText;
      TVirtualDrawTree(VT).BorderStyle := Forms.bsSingle;
    end
  end
  else
  begin
    if (SkinManager.GetSkinType = sknSkin) and Preferences.AdvancedSkinning  then
    begin
      TVirtualStringTree(VT).TreeOptions.PaintOptions := TVirtualStringTree(VT).TreeOptions.PaintOptions + [toHotTrack];
      TVirtualStringTree(VT).Header.Options := TVirtualStringTree(VT).Header.Options + [hoHotTrack];
      TVirtualStringTree(VT).Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncListItem).Body.Color1,clWindow);
      TVirtualStringTree(VT).Colors.FocusedSelectionColor := TVirtualDrawTree(VT).Color;
      TVirtualStringTree(VT).Colors.FocusedSelectionBorderColor := TVirtualDrawTree(VT).Color;
      TVirtualStringTree(VT).Font.Color := IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsNormal),clWindowText);
      TVirtualStringTree(VT).BorderStyle := Forms.bsNone;
    end
    else
    begin
      TVirtualStringTree(VT).TreeOptions.PaintOptions := TVirtualStringTree(VT).TreeOptions.PaintOptions - [toHotTrack];
      TVirtualStringTree(VT).Header.Options := TVirtualStringTree(VT).Header.Options - [hoHotTrack];
      TVirtualStringTree(VT).Color := clWindow;
      TVirtualStringTree(VT).Colors.FocusedSelectionColor := clHighlight;
      TVirtualStringTree(VT).Colors.FocusedSelectionBorderColor := clHighlight;
      TVirtualStringTree(VT).Font.Color := clWindowText;
      TVirtualStringTree(VT).BorderStyle := Forms.bsSingle;
    end
  end;

  if VT is TVirtualDrawTree then
    hdr := TVirtualDrawTree(VT).Header
  else
    hdr := TVirtualStringTree(VT).Header;

  for i:=0 to hdr.Columns.Count-1 do
    if (Preferences.ThemeType = sknSkin) and Preferences.AdvancedSkinning  then
      hdr.Columns[i].Style := vsOwnerDraw
    else
      hdr.Columns[i].Style := vsText;
    hdr.Background := IfNotClNone(SkinManager.CurrentSkin.Options(skncToolbar).Body.Color1,clBtnFace);
end;

procedure TPreferencesForm.UpdateRichEdit(RE: TRichEdit);
begin
  if (Preferences.ThemeType = sknSkin) and Preferences.AdvancedSkinning  then
  begin
    RE.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal);
    RE.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1,clWindow);
    RE.BorderStyle := Forms.bsNone;
  end
  else
  begin
    RE.Font.Color := clWindowText;
    RE.Color := clWindow;
    RE.BorderStyle := Forms.bsSingle;
  end;
end;

procedure TPreferencesForm.UpdateExRichEdit(RE: TExRichEdit);
begin
  if (Preferences.ThemeType = sknSkin) and Preferences.AdvancedSkinning  then
  begin
    RE.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1,clWindow);
    RE.BorderStyle := Forms.bsNone;
  end
  else
  begin
    RE.Color := clWindow;
    RE.BorderStyle := Forms.bsSingle;
  end;
end;

procedure TPreferencesForm.UpdateTntMemo(TM: TTntMemo);
begin
  if (Preferences.ThemeType = sknSkin) and Preferences.AdvancedSkinning  then
  begin
    TM.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal);
    TM.Ctl3D := False;
    TM.Color := IfNotClNone(SkinManager.CurrentSkin.Options(skncEditFrame).Body.Color1,clWindow);
  end
  else
  begin
    TM.Ctl3D := True;
    TM.Color := clWindow;
    TM.Font.Color := clWindowText;
  end;
end;

procedure TPreferencesForm.ApplyAndCloseButtonClick(Sender: TObject);
begin
  if UsernameEdit.Text = '' then
  begin
    MessageDlg(_('"Username" field should not be left empty!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if (not VerifyName(UsernameEdit.Text)) or (not VerifyName(PasswordEdit.Text) and PasswordChanged) then
  begin
    MessageDlg(_('Your username and/or password consists of illegal characters!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if Status.LoggedIn and (Status.Username <> UsernameEdit.Text) then
  begin
    MainForm.TryToDisconnect;
  end;

  if PasswordChanged then
    PasswordEdit.Text := Misc.GetMD5Hash(PasswordEdit.Text);

  SaveOnClose := True;
  Close;
end;

{ Saves radio buttons/check boxes/etc. states into variable p }
procedure TPreferencesForm.UpdatePreferencesTo(var p: TPreferences);
var
  i: Integer;
  tmp: Boolean;
begin
  p.ServerIP := ServerAddressEdit.Text;
  p.ServerPort := ServerPortEdit.Text;

  if RadioButton4.Checked then i := 0
  else if RadioButton5.Checked then i := 1
  else if RadioButton6.Checked then i := 2
  else i := 0; // this should not happen!
  p.TabStyle := i;

  p.TimeStamps := CheckBox1.Checked;

  p.Username := UsernameEdit.Text;
  p.Password := PasswordEdit.Text;
  p.RememberPasswords := RememberPasswordsCheckBox.Checked;
  p.UseLogonForm := UseLogonFormCheckBox.Checked;
  p.AutoSaveChanSession := AutoSaveChansSessionCheckbox.Checked;

  p.ConnectOnStartup := CheckBox2.Checked;

  // SortStyle and BattleSortStyle get updated automatically (in Preferences) when we select certain sorting sytle

  p.FilterJoinLeftMessages := CheckBox3.Checked;
  p.FilterBattleJoinLeftMessages := FilterBattleJoinLeftCheckBox.Checked;
  p.ShowFlags := CheckBox4.Checked;
  p.DisplayUnitsIconsAndNames := DisplayUnitsIconsAndNamesCheckBox.Checked;
  p.MarkUnknownMaps := CheckBox5.Checked;
  p.TaskbarButtons := CheckBox6.Checked;
  p.JoinMainChannel := CheckBox7.Checked;
  p.ReconnectToBackup := CheckBox10.Checked;
  tmp := p.SaveLogs;
  p.SaveLogs := CheckBox8.Checked;
  p.UseSoundNotifications := CheckBox9.Checked;
  p.AutoCompletionFromCurrentChannel := AutoCompletionCurrentChannelCheckBox.Checked;
  p.AutoUpdateToBeta := CheckForNewVersionCheckBox.Checked;
  p.EnableSpringDownloader := EnableSpringDownloaderCheckBox.Checked;

  p.UseProxy := UseProxyCheckBox.Checked;
  p.ProxyAddress := ProxyEdit.Text;
  p.ProxyPort := JvProxyPortEdit.SpinOptions.ValueAsInteger;
  p.ProxyUsername := ProxyUserEdit.Text;
  p.ProxyPassword := ProxyPassEdit.Text;

  p.HighlightColor := HighlightingForm.HightlightColorPanel.Color; //JvColorComboBox1.Text;
  p.UseNotificationsForHighlights := HighlightingForm.UseNotificationsCheckBox.Checked;

  p.UseIgnoreList := IgnoreListForm.EnableIgnoresCheckBox.Checked;
  p.WarnIfUsingNATTraversing := WarnNATCheckBox.Checked;
  p.AutoFocusOnPM := AutoFocusOnPMCheckBox.Checked;

  p.DisableAllSounds := DisableAllSoundsCheckBox.Checked;
  p.SortLocal := SortLocalCheckBox.Checked;
  p.UploadReplay := UploadReplayCheckBox.Checked;

  p.DisplayQuickJoinPanel := DisplayQuickJoinPanelCheckBox.Checked;
  MainForm.QuickJoinPanel.Visible := p.DisplayQuickJoinPanel;

  p.LimitChatLogs := ChatLogsLimitCheckBox.Checked;
  p.ChatLogsLimit := ChatLogsLimitTracker.Position;
  p.ChatLogLoadLoading := ChatLogLoadingCheckBox.Checked;
  p.ChatLogLoadLines := ChatLogLoadingTracker.Position;

  p.EnableScripts := EnableScriptsCheckBox.Checked;
  p.DisableNews := DisableNewsCheckBox.Checked;

  p.AdvancedSkinning := AdvancedSkinningCheckBox.Checked;
  p.SkinnedTitlebars := SkinnedTitlebarsCheckBox.Checked;

  try
    p.LanguageCode := LangCodes[LanguageCombobox.ItemIndex];
  except
  end;

  p.DisableMapDetailsLoading := DoNotLoadMapInfos.Checked;
  p.LoadMetalHeightMinimaps := LoadMetalHeightMaps.Checked;
  p.DisplayAutohostInterface := DisplayAutoHostInterfaceCheckBox.Checked;

  // there is no need to set p.ThemeType or p.Theme here since those are directly updated to Preferences when we change them in GUI at runtime

  // update changes:
  MainForm.VDTBattles.Invalidate;
  MainForm.UpdateClientsListBox;
  if tmp <> p.SaveLogs then if p.SaveLogs then MainForm.OpenAllLogs else MainForm.CloseAllLogs;
end;

{ applies preferences from variable p to VCL controls (radio buttons, check boxes, etc.) }
procedure TPreferencesForm.UpdatePreferencesFrom(p: TPreferences);
var
  i:integer;
begin
  ServerAddressEdit.Text := p.ServerIP;
  ServerPortEdit.Text := p.ServerPort;

  LogonForm.beServer.Text := p.ServerIP;
  LogonForm.txtPort.Text := p.ServerPort;

  if p.TabStyle = 0 then RadioButton4.Checked := True
  else if p.TabStyle = 1 then RadioButton5.Checked := True
  else if p.TabStyle = 2 then RadioButton6.Checked := True
  else RadioButton4.Checked := True; // this should not happen!

  CheckBox1.Checked := p.TimeStamps;

  MainForm.MainPCH.PageControl.Style := TTabStyle(p.TabStyle);

  UsernameEdit.Text := p.Username;
  PasswordEdit.Text := p.Password;
  RememberPasswordsCheckBox.Checked := p.RememberPasswords;
  UseLogonFormCheckBox.Checked := p.UseLogonForm;
  AutoSaveChansSessionCheckbox.Checked := p.AutoSaveChanSession;

  LogonForm.txtLogin.Text := p.Username;
  LogonForm.txtPort.Text := p.ServerPort;
  LogonForm.beServer.Text := p.ServerIP;
  LogonForm.txtPassword.Text := p.Password;
  LogonForm.chkRememberPasswords.Checked := p.RememberPasswords;
  LogonForm.chkUseLogonForm.Checked := p.UseLogonForm;

  CheckBox2.Checked := p.ConnectOnStartup;

  MainForm.SortPopupMenu.Items[p.SortStyle].Checked := True;
  MainForm.mnuAscSort.Checked := p.SortAsc;
  MainForm.SortLabel.ImageIndex := IfThen(p.SortAsc,0,1);
  MainForm.SortLabel.Caption := TSpTBXItem(MainForm.SortPopupMenu.Items[p.SortStyle]).Caption;
  MainForm.VDTBattles.Header.SortColumn := BattleSortStyleToColumn(p.BattleSortStyle);
  if p.BattleSortDirection = 0 then MainForm.VDTBattles.Header.SortDirection := sdAscending else MainForm.VDTBattles.Header.SortDirection := sdDescending;

  CheckBox3.Checked := p.FilterJoinLeftMessages;
  FilterBattleJoinLeftCheckBox.Checked := p.FilterBattleJoinLeftMessages;
  CheckBox4.Checked := p.ShowFlags;
  DisplayUnitsIconsAndNamesCheckBox.Checked := p.DisplayUnitsIconsAndNames;
  CheckBox5.Checked := p.MarkUnknownMaps;
  CheckBox6.Checked := p.TaskbarButtons;
  CheckBox7.Checked := p.JoinMainChannel;
  CheckBox10.Checked := p.ReconnectToBackup;
  CheckBox8.Checked := p.SaveLogs;
  CheckBox9.Checked := p.UseSoundNotifications;
  AutoCompletionCurrentChannelCheckBox.Checked := p.AutoCompletionFromCurrentChannel;
  CheckForNewVersionCheckBox.Checked := p.AutoUpdateToBeta;
  EnableSpringDownloaderCheckBox.Checked := p.EnableSpringDownloader;

  UseProxyCheckBox.Checked := p.UseProxy;
  ProxyEdit.Text := p.ProxyAddress;
  JvProxyPortEdit.Value := p.ProxyPort;
  ProxyUserEdit.Text := p.ProxyUsername;
  ProxyPassEdit.Text := p.ProxyPassword;

  try
    HighlightingForm.HightlightColorPanel.Color := p.HighlightColor;// JvColorComboBox1.ItemIndex := Max(0, HighlightingForm.JvColorComboBox1.Items.IndexOf(p.HighlightColor));
  except
  end;
  HighlightingForm.UseNotificationsCheckBox.Checked := p.UseNotificationsForHighlights;

  IgnoreListForm.EnableIgnoresCheckBox.Checked := p.UseIgnoreList;
  WarnNATCheckBox.Checked := p.WarnIfUsingNATTraversing;
  AutoFocusOnPMCheckBox.Checked := p.AutoFocusOnPM;

  DisableAllSoundsCheckBox.Checked := p.DisableAllSounds;
  SortLocalCheckBox.Checked := p.SortLocal;

  UploadReplayCheckBox.Checked := p.UploadReplay;

  DisplayQuickJoinPanelCheckBox.Checked := p.DisplayQuickJoinPanel;
  MainForm.QuickJoinPanel.Visible := p.DisplayQuickJoinPanel;

  EnableScriptsCheckBox.Checked := p.EnableScripts;

  ChatLogsLimitCheckBox.Checked := p.LimitChatLogs;
  ChatLogsLimitTracker.Position := p.ChatLogsLimit;
  ChatLogsLimitTrackerChange(nil);
  ChatLogLoadingCheckBox.Checked := p.ChatLogLoadLoading;
  ChatLogLoadingTracker.Position := p.ChatLogLoadLines;
  ChatLogLoadingTrackerChange(nil);

  DisableNewsCheckBox.Checked := p.DisableNews;
  DoNotLoadMapInfos.Checked := p.DisableMapDetailsLoading;
  LoadMetalHeightMaps.Checked := p.LoadMetalHeightMinimaps;
  DisplayAutoHostInterfaceCheckBox.Checked := p.DisplayAutohostInterface;

  AdvancedSkinningCheckBox.Checked := p.AdvancedSkinning;
  SkinnedTitlebarsCheckBox.Checked := p.SkinnedTitlebars;

  UseLanguage(p.LanguageCode);
  for i:=0 to LangCodes.Count-1 do
  begin
    if Pos(LangCodes[i],GetCurrentLanguage)>0 then
      LanguageCombobox.ItemIndex := i;
  end;
  for i:=0 to Screen.FormCount-1 do
  begin
    try
      if Screen.Forms[i] <> SplashScreenForm then
        RetranslateComponent(Screen.Forms[i]);
    except
    end;
  end;
  ApplyAfterTranslate;

  case p.ThemeType of
    sknNone: SpTBXRadioButton1.Checked := True;
    sknWindows: SpTBXRadioButton2.Checked := True;
    sknSkin: SpTBXRadioButton3.Checked := True;
  end; // of case

  if p.ThemeType = sknSkin then
  begin
    if ThemesComboBox.Items.AnsiStrings.IndexOf(p.Theme) = -1 then
    begin
      ThemesComboBox.ItemIndex := 0;
    end
    else
      ThemesComboBox.ItemIndex := ThemesComboBox.Items.AnsiStrings.IndexOf(p.Theme);
  end;
end;

procedure TPreferencesForm.PopulateServerListMenu;
var
  i: integer;
begin
  AddressPopupMenu.Items.Clear;
  for i := 0 to High(ServerList) do
  begin
    AddressPopupMenu.Items.Add(TSpTBXItem.Create(AddressPopupMenu.Items.Owner));
    with AddressPopupMenu.Items[AddressPopupMenu.Items.Count-1] as TSpTBXItem do
    begin
      Caption := ServerList[i].Name;
      Tag := i;
      OnClick := AddressPopupMenuItemClick;
    end;
  end;
end;

procedure TPreferencesForm.FormCreate(Sender: TObject);
var
  i:integer;
begin
  TranslateComponent(self);

  SpTBXTabControl1.ActiveTabIndex := 0;

  SetLength(ServerList,4);

  ServerList[0].Name := _('Official host (lobby.springrts.com)');
  ServerList[0].Address := 'lobby.springrts.com';
  ServerList[0].Port := '8200';

  ServerList[1].Name := _('Backup server #1 (springbackup1.servegame.com)');
  ServerList[1].Address := 'springbackup1.servegame.com';
  ServerList[1].Port := '8200';

  ServerList[2].Name := _('Backup server #2 (springbackup2.servegame.org)');
  ServerList[2].Address := 'springbackup2.servegame.org';
  ServerList[2].Port := '8200';

  ServerList[3].Name := _('Local server (localhost)');
  ServerList[3].Address := 'localhost';
  ServerList[3].Port := '8200';

  LangCodes := TStringList.Create;
  LangCodes.Clear;
  LanguageCombobox.Items.Clear;

  DefaultInstance.GetListOfLanguages ('default',LangCodes);
  for i:=0 to LangCodes.Count-1 do
  begin
    LanguageCombobox.Items.Add(getLanguageNameIgnoreCase(LangCodes[i]));
    if Pos(LangCodes[i],GetCurrentLanguage)>0 then
      LanguageCombobox.ItemIndex := i;
  end;

  PopulateServerListMenu;

  // let's populate TBX themes:
  ThemesComboBox.Clear;
  for i:=0 to SkinManager.SkinsList.Count-1 do
    ThemesComboBox.Items.Add(SkinManager.SkinsList.Strings[i]);
  ThemesComboBox.ItemIndex := 0;
  // we will change theme and set ThemeType-s after initilization
  // since at this point not all forms have been created yet
  // so the changes would not be applied to all forms!
end;

procedure TPreferencesForm.FormShow(Sender: TObject);
begin
  PasswordChanged := false;
  SaveOnClose := False;
end;

procedure TPreferencesForm.asyncApplyPreferences(oldPref: TPreferences);
var
  mapIndex : integer;
begin
    if not oldPref.LoadMetalHeightMinimaps and Preferences.LoadMetalHeightMinimaps then
    begin
      mapIndex := BattleForm.CurrentMapIndex;
      BattleForm.ChangeMapToNoMap('');
      BattleForm.ChangeMap(mapIndex);
    end;
    if not oldPref.SortLocal and Preferences.SortLocal then
      MainForm.ResortClientsLists;
    if oldPref.EnableSpringDownloader <> Preferences.EnableSpringDownloader  then
      if Preferences.EnableSpringDownloader then
        StartSpringDownloader
      else
        CloseSpringDownloader;

    if not oldPref.DisplayUnitsIconsAndNames and Preferences.DisplayUnitsIconsAndNames and (BattleState.Status <> None) then
    begin
      // now let's update units:
      InitWaitForm.ChangeCaption(MSG_GETUNITS);
      InitWaitForm.TakeAction := 1; // load unit lists
      InitWaitForm.ShowModal; // this loads unit lists (see OnFormActivate event)
      DisableUnitsForm.PopulateUnitList;
      BattleForm.PopulateDisabledUnitsVDT;
    end;
end;

procedure TPreferencesForm.applyPreferences(newPref: TPreferences; async: boolean);
var
  oldPref: PPreferences;
begin
  New(oldPref);
  oldPref^ := Preferences;
  Preferences := newPref;
  UpdatePreferencesFrom(Preferences); // update changes from p

  if async then
  begin
    PostMessage(MainForm.Handle,WM_ASYNCPREFUPDATE,Integer(oldPref),0);
  end
  else
  begin
    asyncApplyPreferences(oldPref^);
    FreeMemory(oldPref);
  end;
end;

procedure TPreferencesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  newPref: TPreferences;
begin
  ActiveControl := ApplyAndCloseButton;
  { Wonder why we need ActiveControl := ApplyAndCloseButton ? We need it in this case: if focus was on
    the radio button when we closed the form (by clicking the 'X' so that focus remained on radio button),
    then that same radio button would get automatically selected when form is shown and so ignoring any
    changes we made in OnShow event to Checked properties of any of the radio buttons. If you call
    TRadioButton.SetFocus, it will automatically set it's Checked property to true.

    Note (01x05x06): With 0.23 and older version I used to do ActiveControl := nil,
    which actually seemed to work with normal TRadioButton-s, but it didn't work
    anymore with TSpTBXRadioButton, so I changed it to ActiveControl := ApplyAndCloseButton
    (doesn't really matter what control, as long as it is not a radio button). }

  if SaveOnClose then
  begin
    newPref := Preferences;
    UpdatePreferencesTo(newPref); // save changes to p

    applyPreferences(newPref,false);

    AcquireMainThread;
    try if not Preferences.ScriptsDisabled then handlers.onSettingsChanged(); except end;
    ReleaseMainThread;
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

procedure TPreferencesForm.RegisterAccountButtonClick(Sender: TObject);
begin
  if Status.ConnectionState = Connected then
  begin
    MessageDlg(_('You are not allowed to register new account while being logged-in!'), mtError, [mbOK], 0);
    Exit;
  end;

  NewAccountForm.UsernameEdit.Text := UsernameEdit.Text;
  NewAccountForm.PasswordEdit.Text := '';
  NewAccountForm.ConfirmPasswordEdit.Text := '';

  if NewAccountForm.ShowModal = mrCancel then Exit;

  // now let's start account registration process:

  UsernameEdit.Text := NewAccountForm.UsernameEdit.Text;
  PasswordEdit.Text :=  NewAccountForm.PasswordEdit.Text;

  PasswordChanged := true;

  PostMessage(MainForm.Handle, WM_DOREGISTER, 0, 0);
  ApplyAndCloseButton.OnClick(nil);
end;

procedure TPreferencesForm.AddressPopupMenuItemClick(Sender: TObject);
begin
  ServerAddressEdit.Text := ServerList[(Sender as TSpTBXItem).Tag].Address;
  LogonForm.beServer.Text := ServerList[(Sender as TSpTBXItem).Tag].Address;

  ServerPortEdit.Text := ServerList[(Sender as TSpTBXItem).Tag].Port;
  LogonForm.txtPort.Text := ServerList[(Sender as TSpTBXItem).Tag].Port;
end;

procedure TPreferencesForm.GameSettingsButtonClick(Sender: TObject);
var
  tmp: Integer;
begin
  if FileExists(ExtractFilePath(Application.ExeName) + 'springsettings.exe') then
  begin
    tmp := ShellExecute(MainForm.Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + 'springsettings.exe'), '', PChar(ExtractFilePath(Application.ExeName)), SW_SHOWNORMAL);
  end
  else
  begin
    tmp := ShellExecute(MainForm.Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + 'settings.exe'), '', PChar(ExtractFilePath(Application.ExeName)), SW_SHOWNORMAL);
    if (tmp > 0) and (tmp < 32) then MessageDlg(_('Couldn''t find settings.exe!'), mtWarning, [mbOK], 0);
  end;
end;

procedure TPreferencesForm.ResetRegistryButtonClick(Sender: TObject);
begin
  if MessageDlg(_('This will remove all TASClient data from registry. Do you wish to continue?'), mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  RemoveRegistryKey(HKEY_CURRENT_USER, '\Software\TASClient');
  SaveToRegOnExit := False;
end;

procedure TPreferencesForm.NotificationsButtonClick(Sender: TObject);
begin
  NotificationsForm.ShowModal;
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

procedure TPreferencesForm.HighlightingButtonClick(Sender: TObject);
begin
  HighlightingForm.ShowModal;
end;

procedure TPreferencesForm.ThemesComboBoxChange(Sender: TObject);
begin
  Preferences.Theme := ThemesComboBox.Text;
  ApplyCurrentTheme;
end;

procedure TPreferencesForm.SpTBXRadioButton1Click(Sender: TObject);
begin
  if not (Sender is TSpTBXRadioButton) or not TSpTBXRadioButton(Sender).Focused then Exit;
  Preferences.ThemeType := sknNone;
  ApplyCurrentThemeType;
end;

procedure TPreferencesForm.SpTBXRadioButton2Click(Sender: TObject);
begin
  if not (Sender is TSpTBXRadioButton) or not TSpTBXRadioButton(Sender).Focused then Exit;
  Preferences.ThemeType := sknWindows;
  ApplyCurrentThemeType;
end;

procedure TPreferencesForm.SpTBXRadioButton3Click(Sender: TObject);
begin
  if not (Sender is TSpTBXRadioButton) or not TSpTBXRadioButton(Sender).Focused then Exit;
  Preferences.ThemeType := sknSkin;
  ApplyCurrentThemeType;
end;

procedure TPreferencesForm.IgnoreListButtonClick(Sender: TObject);
begin
  IgnoreListForm.ShowModal;
end;

// "Column" is battle treeview's column index, result is corresponding BattleSortStyle value
function TPreferencesForm.ColumnToBattleSortStyle(Column: Integer): Integer;
begin
  case Column of
    -1: Result := 0; // no sorting
    0: Result := 0; // no sorting
    1: Result := 7; // sort by description
    2: Result := 5; // sort by host
    3: Result := 4; // sort by map
    4: Result := 1; // sort by state
    5: Result := 2; // sort by mod
    6: Result := 6; // sort by avg rank
    8: Result := 3; // sort by players
    7: Result := 8; // sort by length
  end; // case
end;

// "SortStyle" is battle sort style value, result is corresponding battle treeview's column index
function TPreferencesForm.BattleSortStyleToColumn(SortStyle: Integer): Integer;
begin
  case SortStyle of
    0: Result := -1; // no sorting
    1: Result := 4; // sort by state
    2: Result := 5; // sort by mod
    3: Result := 8; // sort by players
    4: Result := 3; // sort by map
    5: Result := 2; // sort by host
    6: Result := 6; // sort by avg rank
    7: Result := 1; // sort by description
    8: Result := 7; // sort by length
  end; // case
end;

procedure TPreferencesForm.KeyEditorButtonClick(Sender: TObject);
var
  tmp: Integer;
begin
  tmp := ShellExecute(MainForm.Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + 'SelectionEditor.exe'), '', PChar(ExtractFilePath(Application.ExeName)), SW_SHOWNORMAL);
  if (tmp > 0) and (tmp < 32) then MessageDlg(_('Couldn''t find SelectionEditor.exe!'), mtWarning, [mbOK], 0);
end;

procedure TPreferencesForm.ColorsButtonClick(Sender: TObject);
begin
  ColorsPreference.showmodal;
end;

procedure TPreferencesForm.ManageGroupsButtonClick(Sender: TObject);
begin
  if ClientGroups.Count = 0 then
  begin
    MessageDlg(_('There is no player group to manage. To make a new group use the player context menu.'),mtInformation,[mbOk],0);
    Exit;
  end;
  ManageGroupsForm.Showmodal;
end;

procedure TPreferencesForm.ChatLogsLimitTrackerChange(Sender: TObject);
begin
  ChatLogsLimitCheckBox.Caption := Format(_('Limit chat logs to %d lines'),[ChatLogsLimitTracker.Position]);
end;

procedure TPreferencesForm.PasswordEditChange(Sender: TObject);
begin
  if not PasswordEdit.Focused and (SpTBXTabControl1.ActiveTabIndex = 1) then Exit;
  PasswordChanged := true;
end;

procedure TPreferencesForm.ScriptsReloadBtClick(Sender: TObject);
begin
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers._reloadall; except end;
  ReleaseMainThread;
end;

procedure TPreferencesForm.ScriptsLoadNewBtClick(Sender: TObject);
begin
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers._load; except end;
  ReleaseMainThread;
end;

procedure TPreferencesForm.ScriptsDebugWindowBtClick(Sender: TObject);
begin
  PythonScriptDebugForm.Show;
end;

procedure TPreferencesForm.ScriptsAdvancedOptionsBtClick(Sender: TObject);
begin
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.showOptions; except end;
  ReleaseMainThread;
end;

procedure TPreferencesForm.TipsButtonClick(Sender: TObject);
begin
  TipsForm.ShowTips(0,True);
end;

procedure TPreferencesForm.SpringSettingsProfilesButtonClick(
  Sender: TObject);
begin
  SpringSettingsProfileForm.ShowModal;
end;

procedure TPreferencesForm.ApplyAfterTranslate;
begin
  MainForm.DoubleClickLabel.Left := MainForm.BattleListLabel.Left+MainForm.BattleListLabel.Width + 4;
end;


procedure TPreferencesForm.ResetDockingLayoutButtonClick(Sender: TObject);
begin
  if MessageDlg(_('This will reset the docking layout. Do you wish to continue?'), mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  RemoveRegistryKey(HKEY_CURRENT_USER, '\Software\TASClient\Layout');
  MessageDlg(_('The layout will be set to default the next time you will start TASClient.'),mtInformation,[mbOk],0);

  SaveLayoutOnClose := False;
end;

procedure TPreferencesForm.ChatLogLoadingTrackerChange(Sender: TObject);
begin
  ChatLogLoadingCheckBox.Caption := Format(_('Load the last %d chat log lines'),[ChatLogLoadingTracker.Position]);
end;
 procedure TPreferencesForm.LoadSkinButtonClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'Skin files|*.skn';
  OpenDialog1.Title := _('Select a skin file ...');
  if OpenDialog1.Execute then
  begin
    Preferences.Theme := OpenDialog1.FileName;
    if MessageDlg(_('Do you want to load the skin''s TASClient custom colors too ?'),mtConfirmation,[mbYes,mbNo],0) = mrYes then
      ColorsPreference.LoadColors(OpenDialog1.FileName);
    ApplyCurrentTheme;
  end;
end;

procedure TSpTBXTASClientSkin.FillOptions;
begin
  LoadFromStrings(PreferencesForm.memoTASClientSkin.Lines.AnsiStrings);
end;

procedure TSpTBXTASClientSkin.PaintBackground(ACanvas: TCanvas; ARect: TRect;
  Component: TSpTBXSkinComponentsType; State: TSpTBXSkinStatesType; Background,
  Borders, Vertical: Boolean; ForceRectBorders: TAnchors);
var
  i,j,imWidth,imHeight: integer;
  pngImg: TPNGObject;
  tmpBitmap: TBitmap;
  cornerRectSrc: TRect;
  cornerRectDst: TRect;
begin
  inherited;
  // Override the Tab painting
  if (Component = skncTab) and (State in [sknsChecked]) then begin
    SpDrawLine(ACanvas, ARect.Left + 3, ARect.Top, ARect.Right - 3, ARect.Top, $7DE2FF); //$C1FCFF
    SpDrawLine(ACanvas, ARect.Left + 2, ARect.Top + 1, ARect.Right - 2, ARect.Top + 1, $2FD0FF);
    SpDrawLine(ACanvas, ARect.Left + 1, ARect.Top + 2, ARect.Right - 1, ARect.Top + 2, $2FD0FF);
  end;
end;

procedure TSpTBXTASClientLightSkin.FillOptions;
begin
  LoadFromStrings(PreferencesForm.memoTASClientLightSkin.Lines.AnsiStrings);
end;

procedure TSpTBXTASClientLightSkin.PaintBackground(ACanvas: TCanvas; ARect: TRect;
  Component: TSpTBXSkinComponentsType; State: TSpTBXSkinStatesType; Background,
  Borders, Vertical: Boolean; ForceRectBorders: TAnchors);
var
  i,j,imWidth,imHeight: integer;
  pngImg: TPNGObject;
  tmpBitmap: TBitmap;
  cornerRectSrc: TRect;
  cornerRectDst: TRect;
begin
  inherited;
  // Override the Tab painting
  if (Component = skncTab) and (State in [sknsChecked]) then begin
    SpDrawLine(ACanvas, ARect.Left + 3, ARect.Top, ARect.Right - 3, ARect.Top, clDkGray); //$C1FCFF
    SpDrawLine(ACanvas, ARect.Left + 2, ARect.Top + 1, ARect.Right - 2, ARect.Top + 1, clBlack);
    SpDrawLine(ACanvas, ARect.Left + 1, ARect.Top + 2, ARect.Right - 1, ARect.Top + 2, clBlack);
  end;
end;

procedure TPreferencesForm.SkinEditorButtonClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://springrts.com/dl/tasclient/SkinEditor.7z');
end;

procedure TPreferencesForm.PerformButtonClick(Sender: TObject);
begin
  PerformForm.ShowModal;
end;

procedure TPreferencesForm.SpTBXWebsiteButtonClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser('http://www.silverpointdevelopment.com/sptbxlib/index.htm');
end;

function TPreferencesForm.isLoggedOnOfficialServer: Boolean;
begin
  Result := Status.LoggedIn and ((MainForm.Socket.Addr = 'taspringmaster.clan-sy.com') or (MainForm.Socket.Addr = 'springrts.com') or (MainForm.Socket.Addr = 'lobby.springrts.com'));
end;

initialization
  SkinManager.SkinsList.AddSkin('TASClient', TSpTBXTASClientSkin);
  SkinManager.SkinsList.AddSkin('TASClient Light', TSpTBXTASClientLightSkin);
end.
