unit HostBattleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, Buttons, Menus,SpTBXSkins, OverbyteIcsHttpProt,
  SpTBXEditors, SpTBXControls, TntStdCtrls, SpTBXItem,
  JvExControls, JvComponent, JvArrowButton, ExtCtrls, JvXPCore, JvXPButtons,
  TB2Item, TB2ExtItems,
  TB2Dock, TB2Toolbar, MainUnit, StrUtils,JclUnicode, LobbyScriptUnit,
  OverbyteIcsWndControl;

type
  THostBattleForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    Label1: TSpTBXLabel;
    Label2: TSpTBXLabel;
    Label3: TSpTBXLabel;
    Label4: TSpTBXLabel;
    Label5: TSpTBXLabel;
    SpeedButton1: TSpTBXSpeedButton;
    Label6: TSpTBXLabel;
    Label7: TSpTBXLabel;
    Label8: TSpTBXLabel;
    PortEdit: TSpTBXEdit;
    PasswordEdit: TSpTBXEdit;
    TitleEdit: TSpTBXEdit;
    ModsComboBox: TSpTBXComboBox;
    RankComboBox: TSpTBXComboBox;
    NATRadioGroup: TSpTBXRadioGroup;
    CancelButton: TSpTBXButton;
    AutoSendDescCheckbox: TSpTBXCheckBox;
    HttpCli1: THttpCli;
    RefreshModListButton: TSpTBXButton;
    PlayersTracker: TSpTBXSpinEdit;
    HostButton: TSpTBXButton;
    HostTypeButton: TSpTBXButton;
    HostPopupMenu: TSpTBXPopupMenu;
    mnuHost: TSpTBXItem;
    mnuHostReplay: TSpTBXItem;
    RelayChatCheckBox: TSpTBXCheckBox;
    pnlRelayHosting: TSpTBXPanel;
    RelayHostCheckBox: TSpTBXCheckBox;
    cmbRelayList: TSpTBXComboBox;
    btRefreshRelayManagersList: TSpTBXButton;
    SpTBXPanel2: TSpTBXPanel;
    DownloadModButton: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure TryToHostBattle;
    procedure TryToHostReplay;    

    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Host1Click(Sender: TObject);
    procedure HostReplay1Click(Sender: TObject);
    procedure NATRadioGroupClick(Sender: TObject);
    procedure RefreshModListButtonClick(Sender: TObject);
    procedure HostButtonClick(Sender: TObject);
    procedure RankComboBoxDrawItem(Sender: TObject; ACanvas: TCanvas;
      var ARect: TRect; Index: Integer; const State: TOwnerDrawState;
      const PaintStage: TSpTBXPaintStage; var PaintDefault: Boolean);
    procedure btRefreshRelayManagersListClick(Sender: TObject);
    procedure RelayHostCheckBoxClick(Sender: TObject);
    procedure cmbRelayListDrawItem(Sender: TObject; ACanvas: TCanvas;
      var ARect: TRect; Index: Integer; const State: TOwnerDrawState;
      const PaintStage: TSpTBXPaintStage; var PaintDefault: Boolean);
    procedure DownloadModButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    relayHoster: TClient;
    relayHosterName: string;
    relayHostManagerName: string;
    relayHostOpenBattleCmd: string;
    relayHostPassword: string;
    replay: TReplay;

    relayHostManagerList: TList;

    procedure checkBattleReadyToBeHosted;
  end;
var
  HostBattleForm: THostBattleForm;
  BattleReplayScript: string;

implementation

uses WaitForAckUnit, BattleFormUnit, Utility, InitWaitFormUnit,
  DisableUnitsFormUnit, HostInfoUnit, Misc, PreferencesFormUnit,
  ReplaysUnit, Math, TntWideStrings, gnugettext, RapidDownloaderFormUnit;

{$R *.dfm}

procedure THostBattleForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

function ValidatePassword(p: string): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 1 to Length(p) do if not (p[i] in ['0'..'9', 'a'..'z', 'A'..'Z']) then Exit;

  Result := True;
end;

procedure THostBattleForm.CancelButtonClick(Sender: TObject);
begin
  HostButton.Enabled := True;
  Close;
end;

procedure THostBattleForm.TryToHostBattle;
var
  i,j: Integer;
  s: WideString;
begin
  try
    i := StrToInt(Trim(PortEdit.Text));
  if not RelayHostCheckBox.Checked and ((i < 1024) or (i > 65535)) then raise Exception.Create('Number out of range');
  except
    if not LobbyScriptUnit.ScriptHostingRunning and not LobbyScriptUnit.ScriptHostingReplayRunning then
      MessageDlg(_('Port number must be a whole number within a proper range (1024..65535)'), mtError, [mbOK], 0);
    Exit;
  end;

  if not (PasswordEdit.Text = '') then if not ValidatePassword(PasswordEdit.Text) then
  begin
    if not LobbyScriptUnit.ScriptHostingRunning and not LobbyScriptUnit.ScriptHostingReplayRunning then
      MessageDlg(_('Invalid password! Must contain letters and numbers only!'), mtError, [mbOK], 0);
    Exit;
  end;

  if BattleForm.CurrentMapIndex = -1 then // this should not happen!
  begin
    if not LobbyScriptUnit.ScriptHostingRunning and not LobbyScriptUnit.ScriptHostingReplayRunning then
      MessageDlg(_('Cannot proceed: no map is selected!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if not RelayHostCheckBox.Checked then
  begin
    ReInitLib;
    LoadMod(Utility.ModArchiveList[Utility.ModList.IndexOf(ModsComboBox.Items[ModsComboBox.ItemIndex])]);

    if Utility.ModValidMaps.Count > 0 then
    begin
      i:=0;
      while (i < Utility.ModValidMaps.Count) and (Utility.MapList.IndexOf(Utility.ModValidMaps[i]) = -1) do
        i := i+1;
      if i = Utility.ModValidMaps.Count then
      begin
        if not LobbyScriptUnit.ScriptHostingRunning and not LobbyScriptUnit.ScriptHostingReplayRunning then
          MessageDlg(_('Cannot proceed: this mod requires one of the following map :')+EOL+Misc.JoinStringList(Utility.ModValidMaps,' ; '), mtWarning, [mbOK], 0);
        Exit;
      end;
    end;
  end;

{
  if RankComboBox.ItemIndex > 0 then
    if MessageDlg('You should try to avoid limiting games to a certain rank unless it is absolutely necessary'+#13+
                 'as new players will have a limited enough opportunity to play as is.'+#13+#13+
                 'Are you sure you wish to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
}

  if (Status.MyRank < RankComboBox.ItemIndex) then
    if not LobbyScriptUnit.ScriptHostingRunning and not LobbyScriptUnit.ScriptHostingReplayRunning then
      if MessageDlg(Format(_('Your rank (%s) is lower than the battle rank limit (%s). Do you wish to continue anyway?'),[Ranks[Status.MyRank], Ranks[RankComboBox.ItemIndex]]), mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  // loading default battle preferences
  PreferencesForm.LoadDefaultBattlePreferencesFromRegistry;

  if not RelayHostCheckBox.Checked then
  begin
    // we have to change mod and update unit list:
    InitWaitForm.ChangeCaption(MSG_MODCHANGE);
    InitWaitForm.TakeAction := 0; // change mod
    InitWaitForm.ChangeToMod := ModsComboBox.Text;
    InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)
    // now let's update units:
    InitWaitForm.ChangeCaption(MSG_GETUNITS);
    InitWaitForm.TakeAction := 1; // load unit lists
    InitWaitForm.ShowModal; // this loads unit lists (see OnFormActivate event)
    //DisableUnitsForm.VDTUnits.RootNodeCount := UnitNames.Count;
    DisableUnitsForm.PopulateUnitList;
  end;

  s := '';
  // type:
  s := s + '0' + ' ';
  // NAT traversal method type:
  s := s + IntToStr(NATRadioGroup.ItemIndex) + ' ';
  // password (must be "*" for none):
  if PasswordEdit.Text = '' then s := s + '* ' else s := s + PasswordEdit.Text + ' ';
  // port:
  if NATRadioGroup.ItemIndex = 1 then s := s + IntToStr(NATTraversal.MyPublicUDPSourcePort) + ' '
  else s := s + Trim(PortEdit.Text) + ' ';
  // max. players:
  s := s + IntToStr(PlayersTracker.SpinOptions.ValueAsInteger) + ' ';
  // hash code:
  s := s + IntToStr(GetModHash(ModsComboBox.Items[ModsComboBox.ItemIndex])) + ' ';
  // rank limit:
  s := s + IntToStr(RankComboBox.ItemIndex) + ' ';
  // map hash:
  s := s + IntToStr(Utility.MapChecksums.Items[BattleForm.CurrentMapIndex]) + ' ';
  // engine name:
  s := s + 'spring' + #9;
  // engine version:
  s := s + Status.MySpringVersion + #9;
  // map:
  s := s + Utility.MapList[BattleForm.CurrentMapIndex] + #9;
  // title (description):
    if TitleEdit.Text = '' then
      s := s + '(none)' + #9
    else
      s := s + TitleEdit.Text + #9; // we should not send empty line for title!
  // name of mod:
  s := s + ModsComboBox.Text;

  // send the command:
  if RelayHostCheckBox.Checked then
  begin
    relayHostOpenBattleCmd := '!openbattle '+s;
    relayHostPassword := PasswordEdit.Text;
    BattleState.AutoSendDescription := AutoSendDescCheckbox.Checked;
    BattleState.AutoKickRankLimit := BattleForm.mnuLimitRankAutoKick.Checked;

    relayHostManagerName := TClient(relayHostManagerList[cmbRelayList.ItemIndex]).Name;
    MainForm.TryToSendCommand('SAYPRIVATE',relayHostManagerName+' !spawn');
    Close;
  end
  else
  begin
    MainForm.TryToSendCommand('OPENBATTLE', s);

    BattleState.AutoSendDescription := AutoSendDescCheckbox.Checked;
    BattleState.AutoKickRankLimit := BattleForm.mnuLimitRankAutoKick.Checked;
    BattleState.Password := PasswordEdit.Text;

    WaitForAckForm.ShowModal;
  end;
end;

procedure THostBattleForm.TryToHostReplay;
var
  i: Integer;
  s: WideString;
begin
  try
    i := StrToInt(Trim(PortEdit.Text));
    if (i < 1024) or (i > 65535) then raise Exception.Create('Number out of range');
  except
    MessageDlg(_('Port number must be a whole number within a proper range (1024..65535)'), mtError, [mbOK], 0);
    Exit;
  end;

  if not (PasswordEdit.Text = '') then if not ValidatePassword(PasswordEdit.Text) then
  begin
    MessageDlg(_('Invalid password! Must contain letters and numbers only!'), mtError, [mbOK], 0);
    Exit;
  end;

{
  if RankComboBox.ItemIndex > 0 then
    if MessageDlg('You should try to avoid limiting games to a certain rank unless it is absolutely necessary'+#13+
                 'as new players will have a limited enough opportunity to play as is.'+#13+#13+
                 'Are you sure you wish to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
}

  if (Status.MyRank < RankComboBox.ItemIndex) then
    if MessageDlg(Format(_('Your rank (%s) is lower than the battle rank limit (%s). Do you wish to continue anyway?'),[Ranks[Status.MyRank], Ranks[RankComboBox.ItemIndex]]), mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;


  // we have to change mod and update unit list:
  InitWaitForm.ChangeCaption(MSG_MODCHANGE);
  InitWaitForm.TakeAction := 0; // change mod
  InitWaitForm.ChangeToMod := ModsComboBox.Text;
  InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)
  // now let's update units:
  InitWaitForm.ChangeCaption(MSG_GETUNITS);
  InitWaitForm.TakeAction := 1; // load unit lists
  InitWaitForm.ShowModal; // this loads unit lists (see OnFormActivate event)
  //DisableUnitsForm.VDTUnits.RootNodeCount := UnitNames.Count;
  DisableUnitsForm.PopulateUnitList;
  // change map in battle window to the one used in this replay:

  if Utility.MapList.IndexOf(replay.Script.ReadKeyValue('GAME/mapname')) = -1 then // this can not really happen since we already checked if we have this map
  begin
    MessageDlg(_('You don''t have the map: ') + replay.Script.ReadKeyValue('GAME/mapname'), mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    i := Utility.MapList.IndexOf(replay.Script.ReadKeyValue('GAME/mapname'));
    if BattleForm.CurrentMapIndex <> i then BattleForm.ChangeMap(i);
  end;

  s := '';
  // type:
  s := s + '1' + ' ';
  // NAT traversal method type:
  s := s + IntToStr(NATRadioGroup.ItemIndex) + ' ';
  // password (must be "*" for none):
  if PasswordEdit.Text = '' then s := s + '* ' else s := s + PasswordEdit.Text + ' ';
  // port:
  if NATRadioGroup.ItemIndex = 1 then s := s + IntToStr(NATTraversal.MyPublicUDPSourcePort) + ' '
  else s := s + Trim(PortEdit.Text) + ' ';
  // max. players:
  s := s + IntToStr(PlayersTracker.SpinOptions.ValueAsInteger) + ' ';
  // hash code:
  s := s + IntToStr(GetModHash(ModsComboBox.Items[ModsComboBox.ItemIndex])) + ' ';
  // rank limit:
  s := s + IntToStr(RankComboBox.ItemIndex) + ' ';
  // map hash:
  s := s + IntToStr(Utility.MapChecksums.Items[Utility.MapList.IndexOf(replay.Script.ReadKeyValue('GAME/mapname'))]) + ' ';
  // map:
  s := s + replay.Script.ReadKeyValue('GAME/mapname') + #9;
  // title (description):
  if TitleEdit.Text = '' then s := s + '(none)' + #9 else s := s + TitleEdit.Text + #9; // we should not send empty line for title!
  // name of mod:
  if ModArchiveList.IndexOf(replay.Script.ReadKeyValue('GAME/gametype')) = -1 then
    s := s + replay.Script.ReadKeyValue('GAME/gametype')
  else
    s := s + ModList[ModArchiveList.IndexOf(replay.Script.ReadKeyValue('GAME/gametype'))];

  // send the command:
  MainForm.TryToSendCommand('OPENBATTLE', s);

  BattleState.AutoSendDescription := AutoSendDescCheckbox.Checked;
  BattleState.AutoKickRankLimit := BattleForm.mnuLimitRankAutoKick.Checked;
  BattleState.Password := PasswordEdit.Text;

  WaitForAckForm.Show;
end;

procedure THostBattleForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  TranslateComponent(self);

  ModsComboBox.Items.Assign(Utility.ModList);
  ModsComboBox.ItemIndex := 0;

  PlayersTracker.SpinOptions.MaxValue := MAX_TEAMS;

  relayHoster := nil;
  relayHostManagerList := TList.Create;

  RankComboBox.Items.Add('(No limit)');
  for i := 1 to High(Ranks) do RankComboBox.Items.Add(Ranks[i]);
  RankComboBox.ItemIndex := 0;
end;

procedure THostBattleForm.SpeedButton1Click(Sender: TObject);
begin
  HostInfoForm.ShowModal;
end;


procedure THostBattleForm.FormShow(Sender: TObject);
var
  s:string;
  sl: TStringList;
begin
  Host1Click(HostPopupMenu.Items[0]);
  s := HostBattleForm.ModsComboBox.Text;
  sl := TStringList.Create;
  sl.Assign(Utility.ModList);
  sl.Sort;
  HostBattleForm.ModsComboBox.Items.Assign(sl);
  HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(s));
  if HostButtonMenuIndex = 0 then
    Host1Click(mnuHost)
  else if HostButtonMenuIndex = 2 then
    HostReplay1Click(mnuHostReplay);
  HostButtonMenuIndex := 0;
end;

procedure THostBattleForm.Host1Click(Sender: TObject);
var
  s : string;
begin
  replay := nil;

  pnlRelayHosting.Visible := True;

  ModsComboBox.Enabled := True;
  RankComboBox.Enabled := True;

  AutoSendDescCheckbox.Enabled := True;
  TitleEdit.Enabled := True;
  Label4.Enabled := True;

  PlayersTracker.Enabled := true;
  Label4.Visible := True;
  AutoSendDescCheckbox.Visible := True;
  TitleEdit.Visible := True;

  PlayersTracker.SpinOptions.MinValue := 2;
  PlayersTracker.SpinOptions.MaxValue := MAX_TEAMS;

  Label3.Visible := True;
  Label8.Visible := True;
  PasswordEdit.Visible := True;

 // s := ModsComboBox.Items[ModsComboBox.ItemIndex];
  //ModsComboBox.Items.Assign(Utility.ModList);
  //ModsComboBox.ItemIndex := ModsComboBox.Items.IndexOf(s);

  (Sender as TSpTBXItem).Checked := True;
  HostButton.Caption := _('Host battle');

  checkBattleReadyToBeHosted;
end;

procedure THostBattleForm.HostReplay1Click(Sender: TObject);
begin
  pnlRelayHosting.Visible := False;

  ReplaysForm.WatchButton.Visible := False;
  ReplaysForm.HostReplayButton.Visible := True;

  AutoSendDescCheckbox.Enabled := True;
  TitleEdit.Enabled := True;
  Label4.Enabled := True;

  PlayersTracker.Enabled := true;
  Label4.Visible := True;
  AutoSendDescCheckbox.Visible := True;
  TitleEdit.Visible := True;

  PlayersTracker.SpinOptions.MinValue := 2;
  PlayersTracker.SpinOptions.MaxValue := 16;

  Label3.Visible := True;
  Label8.Visible := True;
  PasswordEdit.Visible := True;

  if not LobbyScriptUnit.ScriptHostingReplayRunning then
  begin
    if ReplaysForm.ShowModal <> mrOK then
    begin
      ReplaysForm.WatchButton.Visible := True;
      ReplaysForm.HostReplayButton.Visible := False;
      Exit;
    end;

    replay := ReplaysForm.GetReplayFromNode(ReplaysForm.VDTReplays.FocusedNode);
  end;

  if Utility.MapList.IndexOf(replay.Script.ReadKeyValue('GAME/mapname')) = -1 then
  begin
    MessageDlg(_('You don''t have the map: ') + replay.Script.ReadKeyValue('GAME/mapname'), mtWarning, [mbOK], 0);
    ReplaysForm.WatchButton.Visible := True;
    ReplaysForm.HostReplayButton.Visible := False;
    Exit;
  end;

  if (ModArchiveList.IndexOf(replay.Script.ReadKeyValue('GAME/gametype')) = -1) and (ModList.IndexOf(replay.Script.ReadKeyValue('GAME/gametype')) = -1) then
  begin
    MessageDlg(_('You don''t have the mod: ') + replay.Script.ReadKeyValue('GAME/gametype'), mtWarning, [mbOK], 0);
    ReplaysForm.WatchButton.Visible := True;
    ReplaysForm.HostReplayButton.Visible := False;
    Exit;
  end
  else
    if ModArchiveList.IndexOf(replay.Script.ReadKeyValue('GAME/gametype')) = -1 then
      ModsComboBox.ItemIndex := ModList.IndexOf(replay.Script.ReadKeyValue('GAME/gametype'))
    else
      ModsComboBox.ItemIndex := ModArchiveList.IndexOf(replay.Script.ReadKeyValue('GAME/gametype'));


  // success:
  ReplaysForm.WatchButton.Visible := True;
  ReplaysForm.HostReplayButton.Visible := False;

  ModsComboBox.Enabled := False;
  RankComboBox.Enabled := False;

  RankComboBox.ItemIndex := 0;

  BattleReplayInfo.Replay := ReplaysForm.GetReplayFromNode(ReplaysForm.VDTReplays.FocusedNode);
  BattleReplayInfo.Script := TScript.Create(BattleReplayInfo.Replay.Script);

  (Sender as TSpTBXItem).Checked := True;
  HostButton.Caption := _('Host replay');

  checkBattleReadyToBeHosted;
end;

procedure THostBattleForm.NATRadioGroupClick(Sender: TObject);
begin
  if NATRadioGroup.ItemIndex = 1 then PortEdit.Enabled := False
  else PortEdit.Enabled := True;
end;

procedure THostBattleForm.RefreshModListButtonClick(Sender: TObject);
var
  s: string;
  sl: TStringList;
begin
  Utility.ReInitLibWithDialog;

  if mnuHost.Checked then
  begin
    s := HostBattleForm.ModsComboBox.Text;
    sl := TStringList.Create;
    sl.Assign(Utility.ModList);
    sl.Sort;
    HostBattleForm.ModsComboBox.Items.Assign(sl);
    HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(s));
  end;

  MainForm.PrintUnitsyncErrors;
end;

procedure THostBattleForm.HostButtonClick(Sender: TObject);
var
  res: Integer;
begin
  { we don't really need to acquire port now, since we will do
    it when starting the game, but we do it here nevertheless,
    since this way we can find out if "hole punching" is going
    to work for us at all (better to find that now then later
    when already starting the game). }
  if ModsComboBox.ItemIndex = -1 then
  begin
      MessageDlg(_('You must select a mod fist !'), mtWarning, [mbOK], 0);
      Exit;
  end;

  if BattleForm.IsBattleActive then
  begin
    if MessageDlg(_('You are already in a battle, do you want to leave it ?'),mtInformation,[mbYes, mbNo],0) = mrYes then
      BattleForm.DisconnectButtonClick(nil)
    else
      Exit;
  end;

  if NATRadioGroup.ItemIndex = 1 then  // "hole punching" method
  begin
    // let's acquire our public UDP source port from the server:
    InitWaitForm.ChangeCaption(MSG_GETHOSTPORT);
    InitWaitForm.TakeAction := 2; // get host port
    res := InitWaitForm.ShowModal;
    if res <> mrOK then
    begin
      MessageDlg(_('Unable to acquire UDP source port from server. Try choosing another NAT traversal technique!'), mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

  BattleState.RelayChat := RelayChatCheckBox.Checked;

  if mnuHost.Checked then
    TryToHostBattle
  else
    TryToHostReplay;

  Close;
end;

procedure THostBattleForm.RankComboBoxDrawItem(Sender: TObject;
  ACanvas: TCanvas; var ARect: TRect; Index: Integer;
  const State: TOwnerDrawState; const PaintStage: TSpTBXPaintStage;
  var PaintDefault: Boolean);
begin
  PaintDefault := False;
  if SkinManager.GetSkinType = sknSkin then
    if State = [odHotLight] then
    begin
      SkinManager.CurrentSkin.PaintBackground(Canvas,ARect,skncListItem,sknsHotTrack,True,True);
      ACanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsHotTrack);
    end
    else
    begin
      SkinManager.CurrentSkin.PaintBackground(Canvas,ARect,skncListItem,sknsNormal,True,True);
      ACanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsNormal);
    end
  else
    (Sender as TSpTBXComboBox).Canvas.FillRect(ARect);

  ACanvas.Brush.Style := bsClear;
  if Index <> 0 then MainForm.RanksImageList.Draw(ACanvas, ARect.Left, ARect.Top, Index);
  if Index <> 0 then ACanvas.TextOut(ARect.Left + MainForm.RanksImageList.Width + 3, ARect.Top, (Sender as TSpTBxComboBox).Items[Index])
  else ACanvas.TextOut(ARect.Left + 3, ARect.Top, (Sender as TSpTBXComboBox).Items[Index]);
end;

procedure THostBattleForm.btRefreshRelayManagersListClick(Sender: TObject);
begin
  if MainForm.GetClient(RELAYHOST_MANAGER_NAME) = nil then
  begin
    MessageDlg(_('RelayHostManager offline, you can''t relay host until it gets back online'),mtError,[mbOk],0)
  end
  else
  begin
    btRefreshRelayManagersList.Enabled := False;
    cmbRelayList.Enabled := False;
    cmbRelayList.Clear;
    relayHostManagerList.Clear;

    // display a refresh msg
    cmbRelayList.Items.Add('');
    cmbRelayList.ItemIndex := 0;

    checkBattleReadyToBeHosted;
    MainForm.TryToSendCommand('SAYPRIVATE',RELAYHOST_MANAGER_NAME+' !listmanagers');
  end;
end;

procedure THostBattleForm.checkBattleReadyToBeHosted;
begin
  HostButton.Enabled := mnuHostReplay.Checked or not RelayHostCheckBox.Checked or (relayHostManagerList.Count > 0);
end;

procedure THostBattleForm.RelayHostCheckBoxClick(Sender: TObject);
begin
  checkBattleReadyToBeHosted;
end;

procedure THostBattleForm.cmbRelayListDrawItem(Sender: TObject;
  ACanvas: TCanvas; var ARect: TRect; Index: Integer;
  const State: TOwnerDrawState; const PaintStage: TSpTBXPaintStage;
  var PaintDefault: Boolean);
var
  selectedManager: TClient;
  FlagBitmap: TBitmap;
  msg: WideString;
begin
  PaintDefault := False;
  if SkinManager.GetSkinType = sknSkin then
    if State = [odHotLight] then
    begin
      SkinManager.CurrentSkin.PaintBackground(Canvas,ARect,skncListItem,sknsHotTrack,True,True);
      ACanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsHotTrack);
    end
    else
    begin
      SkinManager.CurrentSkin.PaintBackground(Canvas,ARect,skncListItem,sknsNormal,True,True);
      ACanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,sknsNormal);
    end
  else
    (Sender as TSpTBXComboBox).Canvas.FillRect(ARect);

  ACanvas.Brush.Style := bsClear;

  if relayHostManagerList.Count = 0 then
  begin
    if btRefreshRelayManagersList.Enabled then
      msg := _('No relay host is available, please try again later.')
    else
      msg := _('Refreshing ...');

    DrawTextW(ACanvas.Handle, PWideChar(msg), Length(msg), ARect, DT_TOP or DT_LEFT or DT_VCENTER or DT_SINGLELINE);
  end
  else
  begin
    selectedManager := TClient(relayHostManagerList[Index]);

    FlagBitmap := MainForm.GetFlagBitmap(selectedManager.Country);
    ACanvas.Draw(ARect.Left,ARect.Top,FlagBitmap);
    ACanvas.TextOut(ARect.Left + FlagBitmap.Width + 5, ARect.Top, selectedManager.Name);
  end;
end;

procedure THostBattleForm.DownloadModButtonClick(Sender: TObject);
begin
  RapidDownloaderForm.ShowModal;
end;

end.
