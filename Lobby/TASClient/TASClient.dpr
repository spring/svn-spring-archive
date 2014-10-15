(*

  Copyright (C) 2005, 2006 Tomaz Kunaver

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; version 2 of the License.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  --------------------------------------------------------------------

  Note: Program's main code (entry code) is located in MainUnit.pas!

*)

program TASClient;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  PreferencesFormUnit in 'PreferencesFormUnit.pas' {PreferencesForm},
  StringParser in 'StringParser.pas',
  BattleFormUnit in 'BattleFormUnit.pas' {BattleForm},
  Utility in 'Utility.pas',
  Misc in 'Misc.pas',
  HostBattleFormUnit in 'HostBattleFormUnit.pas' {HostBattleForm},
  MinimapZoomedFormUnit in 'MinimapZoomedFormUnit.pas' {MinimapZoomedForm},
  WaitForAckUnit in 'WaitForAckUnit.pas' {WaitForAckForm},
  DisableUnitsFormUnit in 'DisableUnitsFormUnit.pas' {DisableUnitsForm},
  InitWaitFormUnit in 'InitWaitFormUnit.pas' {InitWaitForm},
  HostInfoUnit in 'HostInfoUnit.pas' {HostInfoForm},
  HelpUnit in 'HelpUnit.pas' {HelpForm},
  DebugUnit in 'DebugUnit.pas' {DebugForm},
  AddBotUnit in 'AddBotUnit.pas' {AddBotForm},
  ReplaysUnit in 'ReplaysUnit.pas' {ReplaysForm},
  HttpGetUnit in 'HttpGetUnit.pas' {HttpGetForm},
  NotificationsUnit in 'NotificationsUnit.pas' {NotificationsForm},
  AddNotificationFormUnit in 'AddNotificationFormUnit.pas' {AddNotificationForm},
  ExceptionUnit in 'ExceptionUnit.pas' {ExceptionDialog},
  CrashDetailsUnit in 'CrashDetailsUnit.pas' {CrashDetailsDialog},
  SZCodeBaseX in 'SZCodeBaseX.pas',
  uMd5 in 'uMd5.pas',
  AgreementUnit in 'AgreementUnit.pas' {AgreementForm},
  PerformFormUnit in 'PerformFormUnit.pas' {PerformForm},
  SplashScreenUnit in 'SplashScreenUnit.pas' {SplashScreenForm},
  HighlightingUnit in 'HighlightingUnit.pas' {HighlightingForm},
  NewAccountUnit in 'NewAccountUnit.pas' {NewAccountForm},
  IgnoreListUnit in 'IgnoreListUnit.pas' {IgnoreListForm},
  MuteListFormUnit in 'MuteListFormUnit.pas' {MuteListForm},
  MapListFormUnit in 'MapListFormUnit.pas' {MapListForm},
  LoginProgressFormUnit in 'LoginProgressFormUnit.pas' {LoginProgressForm},
  GpIFF in 'GpIFF.pas',
  SpTBXItem,
  SysUtils,
  DSiWin32 in 'DSiWin32.pas',
  AutoTeamsUnit in 'AutoTeamsUnit.pas' {AutoTeamsForm},
  AutoStartRectsUnit in 'AutoStartRectsUnit.pas' {AutoStartRectsForm},
  SearchFormUnit in 'SearchFormUnit.pas' {SearchForm},
  ColorPicker in 'ColorPicker.pas' {ColorPickerForm},
  ManageGroups in 'ManageGroups.pas' {ManageGroupsForm},
  MsMultiPartFormData in 'MsMultiPartFormData.pas',
  ProgressBarWindow in 'ProgressBarWindow.pas' {ProgressBarForm},
  UploadReplayUnit in 'UploadReplayUnit.pas' {UploadReplayForm},
  AwayMessageFormUnit in 'AwayMessageFormUnit.pas' {AwayMessageForm},
  ColorsPreferenceUnit in 'ColorsPreferenceUnit.pas' {ColorsPreference},
  Math,
  Classes,
  Dialogs,
  StrUtils,
  SearchPlayerFormUnit in 'SearchPlayerFormUnit.pas' {SearchPlayerForm},
  MenuFormUnit in 'MenuFormUnit.pas' {MenuForm},
  UWebBrowserWrapper in 'UWebBrowserWrapper.pas',
  IntfDocHostUIHandler in 'IntfDocHostUIHandler.pas',
  UContainer in 'UContainer.pas',
  UNulContainer in 'UNulContainer.pas',
  class_TIntegerList in 'class_TIntegerList.pas',
  OpenIL in 'openil.pas',
  PythonScriptDebugFormUnit in 'PythonScriptDebugFormUnit.pas' {PythonScriptDebugForm},
  LobbyScriptUnit in 'LobbyScriptUnit.pas',
  SpringDownloaderFormUnit in 'SpringDownloaderFormUnit.pas' {SpringDownloaderForm},
  LogonFormUnit in 'LogonFormUnit.pas' {LogonForm},
  MapSelectionFormUnit in 'MapSelectionFormUnit.pas' {MapSelectionForm},
  TipsFormUnit in 'TipsFormUnit.pas' {TipsForm},
  CustomizeGUIFormUnit in 'CustomizeGUIFormUnit.pas' {CustomizeGUIForm},
  SetValuesFormUnit in 'SetValuesFormUnit.pas' {SetValuesForm},
  TemplateEditorFormUnit in 'TemplateEditorFormUnit.pas' {TemplateEditorForm},
  SpringSettingsProfileFormUnit in 'SpringSettingsProfileFormUnit.pas' {SpringSettingsProfileForm},
  AutoJoinFormUnit in 'AutoJoinFormUnit.pas' {AutoJoinForm},
  Minimap3DPreviewUnit in 'Minimap3DPreviewUnit.pas' {Minimap3DPreview},
  GIFImage in 'GIFImage.pas',
  SetStringsUnit in 'SetStringsUnit.pas' {SetStringsForm},
  ChannelsListFormUnit in 'ChannelsListFormUnit.pas' {ChannelsListForm},
  SpTBXSkins,
  BotOptionsFormUnit in 'BotOptionsFormUnit.pas' {BotOptionsForm},
  WidgetDBFormUnit in 'WidgetDBFormUnit.pas' {WidgetDBForm},
  Controls in 'Controls.pas',
  Windows,
  Registry,
  BitList in 'BitList.pas',
  gnugettext in 'C:\Program Files (x86)\dxgettext\gnugettext.pas',
  RapidDownloaderFormUnit in 'RapidDownloaderFormUnit.pas' {RapidDownloaderForm};

var
  i: Integer;

{$R *.res}
{$R 'sounds.RES'} // various sounds
{$R 'flags.RES'} // country flags
{$R 'administrator.res' 'administrator.rc'}

begin
  Debug.Enabled := False;
  Debug.Log := False;
  
  // read command line arguments:
  i:=1;
  while i <= ParamCount do
  begin
    MainUnit.RunningUnderWine := MainUnit.RunningUnderWine or (UpperCase(ParamStr(i)) = '-WINE');
    MainUnit.RunningWithMainMenuDev := MainUnit.RunningWithMainMenuDev or (UpperCase(ParamStr(i)) = '-MENUDEV');
    MainUnit.RunningWithMainMenu := MainUnit.RunningWithMainMenu or MainUnit.RunningWithMainMenuDev or (UpperCase(ParamStr(i)) = '-MENU');
    MainUnit.Debug.Enabled := MainUnit.Debug.Enabled or (UpperCase(ParamStr(i)) = '-DEBUG');
    MainUnit.Debug.Log := MainUnit.Debug.Log or (UpperCase(ParamStr(i)) = '-LOG');
    MainUnit.NO3D := MainUnit.NO3D or (UpperCase(ParamStr(i)) = '-NO3D');
    MainUnit.Debug.IgnoreVersionIncompatibility := MainUnit.Debug.IgnoreVersionIncompatibility or (UpperCase(ParamStr(i)) = '-IGNOREVERSION');
    MainUnit.Debug.IgnoreRedirects := MainUnit.Debug.IgnoreRedirects or (UpperCase(ParamStr(i)) = '-IGNOREREDIRECTS');

    if UpperCase(ParamStr(i)) = '-INIFILE' then
    begin
      Inc(i);
      if i <= ParamCount then
      begin
        CUSTOM_TASCLIENT_FILE := ParamStr(i);
        if not FileExists(CUSTOM_TASCLIENT_FILE) then
          MessageDlg(_('File not found : ')+CUSTOM_TASCLIENT_FILE,mtWarning,[mbOK],0)
      end
      else
        MessageDlg(_('Wrong -inifile usage : -inifile filename'),mtWarning,[mbOK],0);
    end;
    if UpperCase(ParamStr(i)) = '-SERVER' then
      if (ParamCount = i) or (Pos(':',ParamStr(i+1)) = 0) then
        MessageDlg(_('Wrong -server usage : -server myserver.com:8200'),mtWarning,[mbOk],0)
      else
      begin
        try
          CommandLineServer := LeftStr(ParamStr(i+1),Pos(':',ParamStr(i+1))-1);
          CommandLinePort := IntToStr(StrToInt(MidStr(ParamStr(i+1),Pos(':',ParamStr(i+1))+1,99999)));
        except
          MessageDlg(_('Wrong -server usage : -server myserver.com:8200'),mtWarning,[mbOk],0);
        end;
      end;
    if UpperCase(ParamStr(i)) = '-MENUMOD' then
      if (ParamCount = i) then
        MessageDlg(_('Wrong -menumod usage : -menumod "modName"'),mtWarning,[mbOk],0)
      else
      begin
        MainUnit.RunningWithMainMenu := True;
        MenuModName := ParamStr(i+1);
      end;
    Inc(i);
  end;

  if MainUnit.Debug.Enabled then
    MainUnit.StartDebugLog := Misc.OpenLog('TASClient_Start.log');

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Loading preferences ...');
    
  // set the locale dir
  DefaultInstance.bindtextdomain(DefaultTextDomain,IncludeTrailingPathDelimiter(ExtractFilePath(ExecutableFilename))+'lobby\locale');

  // preload preferences, since we need to know about "TaskbarButtons" field before we create other forms:
  Preferences := DEFAULT_PREFERENCES;
  PreferencesForm.ReadPreferencesRecordFromRegistry(Preferences);

  SplashScreenForm := TSplashScreenForm.Create(nil);
  SplashScreenForm.VersionLabel.Caption := VERSION_NUMBER;
  SplashScreenForm.Show;

  // load the tasclient.ini file
  LoadTASClientIni(CUSTOM_TASCLIENT_FILE);
    
  MainUnit.RunningUnderWine := MainUnit.RunningUnderWine;

  try
    Debug.Crashed := Misc.GetRegistryData(HKEY_CURRENT_USER,TASCLIENT_REGISTRY_KEY,'Crashed')
  except
    Debug.Crashed := False;
  end;
  Misc.SetRegistryData(HKEY_CURRENT_USER,TASCLIENT_REGISTRY_KEY,'Crashed',rdInteger,Misc.BoolToInt(True));

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Displaying splashscreen ...');

  if not DISABLE_FADEIN then
  begin
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Splashscreen fadein ...');
    while SplashScreenForm.AlphaBlendValue < 255 do
    begin
      SplashScreenForm.AlphaBlendValue := Min(255,SplashScreenForm.AlphaBlendValue+8);
      SplashScreenForm.Refresh;
      Sleep(20);
    end;
  end
  else
  begin
    SplashScreenForm.AlphaBlendValue := 255;
    SplashScreenForm.Refresh;
  end;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing application ...');

  Application.Initialize;
  Application.ShowMainForm := False;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Acquiring spring version ...');

  // retrieve Spring version:
  Status.MySpringVersion := Utility.AcquireSpringVersion;

  SplashScreenForm.UpdateText(_('creating forms ...'));

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Initializing lists ...');

  MainUnit.displayingNotificationList := TList.Create;
  MainUnit.displayedNewsList := TStringList.Create;

  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Checking vista and wine mode ...');

  // disable title bars if program is running under Wine:
  if MainUnit.RunningUnderWine or (Preferences.ThemeType = sknSkin) then
  begin
    //SpTBXItem.ActivateTitleBarsOnStartUp := False;
    if MainUnit.RunningUnderWine then
      MainForm.AddNotification(_('Wine detected!'), _('All title bars have been disabled since they are not supported under Wine'), 5000);
  end;

  Application.Title := 'TASClient';
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating MainForm ...');
  Application.CreateForm(TMainForm, MainForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating SetStringsForm ...');
  Application.CreateForm(TSetStringsForm, SetStringsForm);
  {if not MainUnit.NO3D then
  begin
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating Minimap3DPreview ...');
    //Application.CreateForm(TMinimap3DPreview, Minimap3DPreview);
  end;}
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating MapSelectionForm ...');
  Application.CreateForm(TMapSelectionForm, MapSelectionForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating LogonForm ...');
  Application.CreateForm(TLogonForm, LogonForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating ColorPickerForm ...');
  Application.CreateForm(TColorPickerForm, ColorPickerForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating PreferencesForm ...');
  Application.CreateForm(TPreferencesForm, PreferencesForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating BattleForm ...');
  Application.CreateForm(TBattleForm, BattleForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating HostBattleForm ...');
  Application.CreateForm(THostBattleForm, HostBattleForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating MinimapZoomedForm ...');
  Application.CreateForm(TMinimapZoomedForm, MinimapZoomedForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating WaitForAckForm ...');
  Application.CreateForm(TWaitForAckForm, WaitForAckForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating InitWaitForm ...');
  Application.CreateForm(TInitWaitForm, InitWaitForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating HostInfoForm ...');
  Application.CreateForm(THostInfoForm, HostInfoForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating HelpForm ...');
  Application.CreateForm(THelpForm, HelpForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating DebugForm ...');
  Application.CreateForm(TDebugForm, DebugForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating AddBotForm ...');
  Application.CreateForm(TAddBotForm, AddBotForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating ReplaysForm ...');
  Application.CreateForm(TReplaysForm, ReplaysForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating ChannelsListForm ...');
  Application.CreateForm(TChannelsListForm, ChannelsListForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating HttpGetForm ...');
  Application.CreateForm(THttpGetForm, HttpGetForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating NotificationsForm ...');
  Application.CreateForm(TNotificationsForm, NotificationsForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating AddNotificationForm ...');
  Application.CreateForm(TAddNotificationForm, AddNotificationForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating CrashDetailsDialog ...');
  Application.CreateForm(TCrashDetailsDialog, CrashDetailsDialog);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating AgreementForm ...');
  Application.CreateForm(TAgreementForm, AgreementForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating PerformForm ...');
  Application.CreateForm(TPerformForm, PerformForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating HighlightingForm ...');
  Application.CreateForm(THighlightingForm, HighlightingForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating NewAccountForm ...');
  Application.CreateForm(TNewAccountForm, NewAccountForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating IgnoreListForm ...');
  Application.CreateForm(TIgnoreListForm, IgnoreListForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating MuteListForm ...');
  Application.CreateForm(TMuteListForm, MuteListForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating MapListForm ...');
  Application.CreateForm(TMapListForm, MapListForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating LoginProgressForm ...');
  Application.CreateForm(TLoginProgressForm, LoginProgressForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating AutoTeamsForm ...');
  Application.CreateForm(TAutoTeamsForm, AutoTeamsForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating AutoStartRectsForm ...');
  Application.CreateForm(TAutoStartRectsForm, AutoStartRectsForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating SearchForm ...');
  Application.CreateForm(TSearchForm, SearchForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating ManageGroupsForm ...');
  Application.CreateForm(TManageGroupsForm, ManageGroupsForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating ProgressBarForm ...');
  Application.CreateForm(TProgressBarForm, ProgressBarForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating UploadReplayForm ...');
  Application.CreateForm(TUploadReplayForm, UploadReplayForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating AwayMessageForm ...');
  Application.CreateForm(TAwayMessageForm, AwayMessageForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating ColorsPreference ...');
  Application.CreateForm(TColorsPreference, ColorsPreference);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating SearchPlayerForm ...');
  Application.CreateForm(TSearchPlayerForm, SearchPlayerForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating PythonScriptDebugForm ...');
  Application.CreateForm(TPythonScriptDebugForm, PythonScriptDebugForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating TipsForm ...');
  Application.CreateForm(TTipsForm, TipsForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating CustomizeGUIForm ...');
  Application.CreateForm(TCustomizeGUIForm, CustomizeGUIForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating SetValuesForm ...');
  Application.CreateForm(TSetValuesForm, SetValuesForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating TemplateEditorForm ...');
  Application.CreateForm(TTemplateEditorForm, TemplateEditorForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating SpringSettingsProfileForm ...');
  Application.CreateForm(TSpringSettingsProfileForm, SpringSettingsProfileForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating AutoJoinForm ...');
  Application.CreateForm(TAutoJoinForm, AutoJoinForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating WidgetDBForm ...');
  Application.CreateForm(TWidgetDBForm, WidgetDBForm);
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating DisableUnitsForm ...');
  Application.CreateForm(TDisableUnitsForm, DisableUnitsForm);
  if MainUnit.RunningWithMainMenu then
  begin
    if MainUnit.Debug.Enabled then
      Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating MenuForm ...');
    Application.CreateForm(TMenuForm, MenuForm);
  end;
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Creating RapidDownloaderForm ...');
  Application.CreateForm(TRapidDownloaderForm, RapidDownloaderForm);
  SplashScreenForm.UpdateText(_('Initializing ...'));

  Application.Run;
end.
