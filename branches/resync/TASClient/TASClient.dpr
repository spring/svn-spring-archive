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
  TBXDefaultTheme,
  TBXOfficeXPTheme,
  TBXAluminumTheme,
  rmkThemes in 'Themes\rmkThemes.pas',
  TBXAthenTheme in 'Themes\TBXAthenTheme.pas',
  TBXDreamTheme in 'Themes\TBXDreamTheme.pas',
  TBXEosTheme in 'Themes\TBXEosTheme.pas',
  TBXMirandaTheme in 'Themes\TBXMirandaTheme.pas',
  TBXMonaiTheme in 'Themes\TBXMonaiTheme.pas',
  TBXMonaiXPTheme in 'Themes\TBXMonaiXPTheme.pas',
  TBXNexos2Theme in 'Themes\TBXNexos2Theme.pas',
  TBXNexos3Theme in 'Themes\TBXNexos3Theme.pas',
  TBXNexos4Theme in 'Themes\TBXNexos4Theme.pas',
  TBXNexos5Theme in 'Themes\TBXNexos5Theme.pas',
  TBXNexosXTheme in 'Themes\TBXNexosXTheme.pas',
  TBXOffice11AdaptiveTheme in 'Themes\TBXOffice11AdaptiveTheme.pas',
  TBXOfficeCTheme in 'Themes\TBXOfficeCTheme.pas',
  TBXReliferTheme in 'Themes\TBXReliferTheme.pas',
  TBXRomaTheme in 'Themes\TBXRomaTheme.pas',
  TBXSentimoXTheme in 'Themes\TBXSentimoXTheme.pas',
  TBXTristan2Theme in 'Themes\TBXTristan2Theme.pas',
  TBXTristanTheme in 'Themes\TBXTristanTheme.pas',
  TBXWhidbeyTheme in 'Themes\TBXWhidbeyTheme.pas',
  TBXXitoTheme in 'Themes\TBXXitoTheme.pas',
  TBXZezioTheme in 'Themes\TBXZezioTheme.pas',
  TBXOffice12Theme in 'Themes\TBXOffice12Theme.pas',
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
  OnlineMapsUnit in 'OnlineMapsUnit.pas' {OnlineMapsForm},
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
  CustomColorUnit in 'CustomColorUnit.pas' {CustomColorForm},
  MuteListFormUnit in 'MuteListFormUnit.pas' {MuteListForm},
  MapListFormUnit in 'MapListFormUnit.pas' {MapListForm},
  LoginProgressFormUnit in 'LoginProgressFormUnit.pas' {LoginProgressForm},
  GpIFF in 'GpIFF.pas',
  SpTBXItem,
  SysUtils,
  DSiWin32 in 'DSiWin32.pas',
  AutoTeamsUnit in 'AutoTeamsUnit.pas' {AutoTeamsForm};

var
  RunningUnderWine: Boolean = False; // set via -wine argument to the program
  i: Integer;

{$R *.res}
{$R 'sounds.RES'} // various sounds
{$R 'flags.RES'} // country flags

begin

  // preload preferences, since we need to know about "TaskbarButtons" field before we create other forms:
  Preferences := DEFAULT_PREFERENCES;
  PreferencesForm.ReadPreferencesRecordFromRegistry(Preferences);

  // read command line arguments:
  for i := 1 to ParamCount do
    if (UpperCase(ParamStr(i)) = 'WINE') or (UpperCase(ParamStr(i)) = '-WINE') then RunningUnderWine := True;

  // first create splash screen (but preferences must already be loaded!):
  SplashScreenForm := TSplashScreenForm.Create(nil);
  SplashScreenForm.Show;

  Application.Initialize;
  Application.ShowMainForm := False;

  SplashScreenForm.UpdateText('acquiring spring version from spring.exe ...');
  Status.MySpringVersion := Misc.GetSpringVersion;

  SplashScreenForm.UpdateText('creating forms ...');

  // disable title bars if program is running under Wine:
  if RunningUnderWine or Misc.DetectWine then
  begin
    SpTBXItem.ActivateTitleBarsOnStartUp := False;
    MainForm.AddNotification('Wine detected!', 'All title bars have been disabled since they are not supported under Wine', 5000);
  end;

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAutoTeamsForm, AutoTeamsForm);
  SplashScreenForm.UpdateText('creating forms ...'); // main form will change the update text, that is why we change it back again
  Application.CreateForm(TPreferencesForm, PreferencesForm);
  Application.CreateForm(TBattleForm, BattleForm);
  Application.CreateForm(THostBattleForm, HostBattleForm);
  Application.CreateForm(TMinimapZoomedForm, MinimapZoomedForm);
  Application.CreateForm(TWaitForAckForm, WaitForAckForm);
  Application.CreateForm(TDisableUnitsForm, DisableUnitsForm);
  Application.CreateForm(TInitWaitForm, InitWaitForm);
  Application.CreateForm(THostInfoForm, HostInfoForm);
  Application.CreateForm(THelpForm, HelpForm);
  Application.CreateForm(TDebugForm, DebugForm);
  Application.CreateForm(TAddBotForm, AddBotForm);
  Application.CreateForm(TReplaysForm, ReplaysForm);
  Application.CreateForm(THttpGetForm, HttpGetForm);
  Application.CreateForm(TOnlineMapsForm, OnlineMapsForm);
  Application.CreateForm(TNotificationsForm, NotificationsForm);
  Application.CreateForm(TAddNotificationForm, AddNotificationForm);
  Application.CreateForm(TCrashDetailsDialog, CrashDetailsDialog);
  Application.CreateForm(TAgreementForm, AgreementForm);
  Application.CreateForm(TPerformForm, PerformForm);
  Application.CreateForm(THighlightingForm, HighlightingForm);
  Application.CreateForm(TNewAccountForm, NewAccountForm);
  Application.CreateForm(TIgnoreListForm, IgnoreListForm);
  Application.CreateForm(TCustomColorForm, CustomColorForm);
  Application.CreateForm(TMuteListForm, MuteListForm);
  Application.CreateForm(TMapListForm, MapListForm);
  Application.CreateForm(TLoginProgressForm, LoginProgressForm);
  SplashScreenForm.UpdateText('Initializing ...');

  Application.Run;
end.
