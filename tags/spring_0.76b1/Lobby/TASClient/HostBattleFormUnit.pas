unit HostBattleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, janTracker, Buttons, Menus,
  JvExControls, JvComponent, JvArrowButton, ExtCtrls, JvXPCore, JvXPButtons,
  TBXDkPanels, SpTBXControls, TntStdCtrls, SpTBXEditors, SpTBXItem, TBX,
  TB2Item, TB2ExtItems, TB2Dock, TB2Toolbar, SpTBXjanTracker, HttpProt,MainUnit,StrUtils;

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
    PlayersTracker: TSpTBXjanTracker;
    TitleEdit: TSpTBXEdit;
    ModsComboBox: TSpTBXComboBox;
    RankComboBox: TSpTBXComboBox;
    NATRadioGroup: TSpTBXRadioGroup;
    HostButton: TTBXButton;
    HostPopupMenu: TPopupMenu;
    Host1: TMenuItem;
    HostReplay1: TMenuItem;
    CancelButton: TSpTBXButton;
    AutoSendDescCheckbox: TSpTBXCheckBox;
    HostLadder1: TMenuItem;
    LadderComboBox: TSpTBXComboBox;
    SpTBXLabel1: TSpTBXLabel;
    HttpCli1: THttpCli;
    RefreshButton: TSpTBXButton;
    RefreshModListButton: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure TryToHostBattle(ladderIndex: integer);
    procedure TryToHostReplay;    

    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RankComboBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure Host1Click(Sender: TObject);
    procedure HostReplay1Click(Sender: TObject);
    procedure NATRadioGroupClick(Sender: TObject);
    procedure RefreshModListButtonClick(Sender: TObject);
    procedure HostButtonClick(Sender: TObject);
    procedure HostLadder1Click(Sender: TObject);
    procedure ApplyLadderParams(ladder: TLadder);
    procedure RefreshButtonClick(Sender: TObject);
    procedure LadderComboBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TLadderListThread = class(TDialogThread)
  private
    DownloadLadderDetailsIndex : integer;
    procedure Refresh;
    function DownloadLadderDetails(ladderIndex : integer):boolean;
    procedure OnTerminateProcedure(Sender : TObject);

  protected
    procedure Execute; override;
    
  public
    constructor Create(Suspended : Boolean;ladderIndex: integer);
  end;
var
  HostBattleForm: THostBattleForm;
  BattleReplayScript: string;

implementation

uses WaitForAckUnit, BattleFormUnit, Utility, InitWaitFormUnit,
  DisableUnitsFormUnit, HostInfoUnit, Misc, PreferencesFormUnit,
  ReplaysUnit, Math, TntWideStrings;

{$R *.dfm}

procedure THostBattleForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
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
  RefreshButton.Enabled := True;
  Close;
end;

procedure THostBattleForm.TryToHostBattle(ladderIndex: integer);
var
  i,j: Integer;
  s: string;
  validMaps: TStringList;
begin
  try
    i := StrToInt(PortEdit.Text);
    if (i < 1024) or (i > 65535) then raise Exception.Create('Number out of range');
  except
    MessageDlg('Port number must be a whole number within a proper range (1024..65535)', mtError, [mbOK], 0);
    Exit;
  end;

  if not (PasswordEdit.Text = '') then if not ValidatePassword(PasswordEdit.Text) then
  begin
    MessageDlg('Invalid password! Must contain letters and numbers only!', mtError, [mbOK], 0);
    Exit;
  end;

  if BattleForm.CurrentMapIndex = -1 then // this should not happen!
  begin
    MessageDlg('Cannot proceed: no map is selected!', mtWarning, [mbOK], 0);
    Exit;
  end;

  ReInitLib;
  LoadMod(Utility.ModArchiveList[Utility.ModList.IndexOf(ModsComboBox.Text)]);
  validMaps:=GetModValidMapList;
  if validMaps.Count > 0 then
  begin
    i:=0;
    while (i < validMaps.Count) and (Utility.MapList.IndexOf(validMaps[i]) = -1) do
      i := i+1;
    if i = validMaps.Count then
    begin
      MessageDlg('Cannot proceed: this mod requires one of the following map :'+EOL+Misc.JoinStringList(validMaps,' ; '), mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

{
  if RankComboBox.ItemIndex > 0 then
    if MessageDlg('You should try to avoid limiting games to a certain rank unless it is absolutely necessary'+#13+
                 'as new players will have a limited enough opportunity to play as is.'+#13+#13+
                 'Are you sure you wish to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
}

  if (Status.MyRank < RankComboBox.ItemIndex) then
    if MessageDlg('Your rank (' + Ranks[Status.MyRank] + ') is lower than the battle rank limit (' + Ranks[RankComboBox.ItemIndex] + '). Do you wish to continue anyway?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  // loading default battle preferences
  PreferencesForm.LoadDefaultBattlePreferencesFromRegistry;

  // we have to change mod and update unit list:
  InitWaitForm.ChangeCaption(MSG_MODCHANGE);
  InitWaitForm.TakeAction := 0; // change mod
  InitWaitForm.ChangeToMod := ModsComboBox.Text;
  InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)
  // now let's update units:
  InitWaitForm.ChangeCaption(MSG_GETUNITS);
  InitWaitForm.TakeAction := 1; // load unit lists
  InitWaitForm.ShowModal; // this loads unit lists (see OnFormActivate event)
  DisableUnitsForm.VDTUnits.RootNodeCount := UnitNames.Count;

  with BattleForm do begin
    MetalTracker.Minimum := 0;
    MetalTracker.Maximum := 10000;
    EnergyTracker.Minimum := 0;
    EnergyTracker.Maximum := 10000;
    UnitsTracker.Minimum := 0;
    UnitsTracker.Maximum := 5000;
    if ladderIndex >= 0 then
    begin
      LockGameSpeedCheckBox.Checked := True;
      with TLadder(LadderList[LadderComboBox.ItemIndex]) do begin
        if StartPos <> 255 then
          StartPosRadioGroup.ItemIndex := StartPos;
        if GameMode <> 255 then
          GameEndRadioGroup.ItemIndex := GameMode;
        if DGun <> 255 then
          LimitDGunCheckBox.Checked := DGun = 1;
        if Ghost <> 255 then
          GhostedBuildingsCheckBox.Checked := Ghost = 1;
        if Diminish <> 255 then
          DiminishingMMsCheckBox.Checked := Diminish = 1;
        if MetalMin <> -1 then
          if MetalMin = MetalMax then
            MetalTracker.Value := MetalMin
          else
          begin
            MetalTracker.Minimum := MetalMin;
            MetalTracker.Maximum := MetalMax;
          end;
        if EnergyMin <> -1 then
          if EnergyMin = EnergyMax then
            EnergyTracker.Value := EnergyMin
          else
          begin
            EnergyTracker.Minimum := EnergyMin;
            EnergyTracker.Maximum := EnergyMax;
          end;
        if UnitsMin <> -1 then
          if UnitsMin = UnitsMax then
            UnitsTracker.Value := UnitsMin
          else
          begin
            UnitsTracker.Minimum := UnitsMin;
            UnitsTracker.Maximum := UnitsMax;
          end;
        end;
      end;
  end;

  s := '';
  // type:
  s := s + '0' + ' ';
  // NAT traversal method type:
  s := s + IntToStr(NATRadioGroup.ItemIndex) + ' ';
  // password (must be "*" for none):
  if ladderIndex > -1 then
    s := s + 'ladderlock '
  else
    if PasswordEdit.Text = '' then s := s + '* ' else s := s + PasswordEdit.Text + ' ';
  // port:
  if NATRadioGroup.ItemIndex = 1 then s := s + IntToStr(NATTraversal.MyPublicUDPSourcePort) + ' '
  else s := s + PortEdit.Text + ' ';
  // max. players:
  s := s + IntToStr(PlayersTracker.Value) + ' ';
  

  // the old system UPDATEBATTLEDETAILS
  {// metal:
  s := s + IntToStr(BattleForm.MetalTracker.Value) + ' ';
  // energy:
  s := s + IntToStr(BattleForm.EnergyTracker.Value) + ' ';
  // max. units:
  s := s + IntToStr(BattleForm.UnitsTracker.Value) + ' ';
  // start pos.:
  s := s + IntToStr(BattleForm.StartPosRadioGroup.ItemIndex) + ' ';
  // game end condition:
  s := s + IntToStr(BattleForm.GameEndRadioGroup.ItemIndex) + ' ';
  // limit d-gun to startpos:
  s := s + IntToStr(BoolToInt(BattleForm.LimitDGunCheckBox.Checked)) + ' ';
  // diminishing metal maker returns:
  s := s + IntToStr(BoolToInt(BattleForm.DiminishingMMsCheckBox.Checked)) + ' ';
  // ghosted buildings:
  s := s + IntToStr(BoolToInt(BattleForm.GhostedBuildingsCheckBox.Checked)) + ' ';}


  // hash code:
  s := s + IntToStr(GetModHash(ModsComboBox.Items[ModsComboBox.ItemIndex])) + ' ';
  // rank limit:
  s := s + IntToStr(RankComboBox.ItemIndex) + ' ';
  // map hash:
  s := s + IntToStr(Misc.HexToInt(Utility.MapChecksums[BattleForm.CurrentMapIndex])) + ' ';
  // map:
  s := s + Utility.MapList[BattleForm.CurrentMapIndex] + #9;
  // title (description):
  if ladderIndex >= 0 then
    s := s + '(ladder '+IntToStr(TLadder(LadderList[ladderIndex]).id)+') '+TLadder(LadderList[ladderIndex]).Name+#9
  else
    if TitleEdit.Text = '' then
      s := s + '(none)' + #9
    else
      s := s + TitleEdit.Text + #9; // we should not send empty line for title!
  // name of mod:
  s := s + ModsComboBox.Text;

  BattleState.LadderIndex := ladderIndex;

  // send the command:
  MainForm.TryToSendCommand('OPENBATTLE', s);

  if WaitForAckForm.ShowModal = mrOK then
  begin // success
    BattleState.AutoSendDescription := AutoSendDescCheckbox.Checked;
    BattleState.AutoKickRankLimit := BattleForm.mnuLimitRankAutoKick.Checked;
    Close;
  end
  else
  begin // failure
  end;
end;

procedure THostBattleForm.TryToHostReplay;
var
  i: Integer;
  s: string;
begin
  try
    i := StrToInt(PortEdit.Text);
    if (i < 1024) or (i > 65535) then raise Exception.Create('Number out of range');
  except
    MessageDlg('Port number must be a whole number within a proper range (1024..65535)', mtError, [mbOK], 0);
    Exit;
  end;

  if not (PasswordEdit.Text = '') then if not ValidatePassword(PasswordEdit.Text) then
  begin
    MessageDlg('Invalid password! Must contain letters and numbers only!', mtError, [mbOK], 0);
    Exit;
  end;

{
  if RankComboBox.ItemIndex > 0 then
    if MessageDlg('You should try to avoid limiting games to a certain rank unless it is absolutely necessary'+#13+
                 'as new players will have a limited enough opportunity to play as is.'+#13+#13+
                 'Are you sure you wish to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
}

  if (Status.MyRank < RankComboBox.ItemIndex) then
    if MessageDlg('Your rank (' + Ranks[Status.MyRank] + ') is lower than the battle rank limit (' + Ranks[RankComboBox.ItemIndex] + '). Do you wish to continue anyway?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;


  // we have to change mod and update unit list:
  InitWaitForm.ChangeCaption(MSG_MODCHANGE);
  InitWaitForm.TakeAction := 0; // change mod
  InitWaitForm.ChangeToMod := ModsComboBox.Text;
  InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)
  // now let's update units:
  InitWaitForm.ChangeCaption(MSG_GETUNITS);
  InitWaitForm.TakeAction := 1; // load unit lists
  InitWaitForm.ShowModal; // this loads unit lists (see OnFormActivate event)
  DisableUnitsForm.VDTUnits.RootNodeCount := UnitNames.Count;
  // change map in battle window to the one used in this replay:
  if Utility.MapList.IndexOf(ReplaysForm.MapLabel.Caption) = -1 then // this can not really happen since we already checked if we have this map
  begin
    MessageDlg('You don''t have the map: ' + ReplaysForm.MapLabel.Caption, mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    i := Utility.MapList.IndexOf(ReplaysForm.MapLabel.Caption);
    if BattleForm.CurrentMapIndex <> i then BattleForm.ChangeMap(i);
  end;

  BattleForm.MetalTracker.Minimum := 0;
  BattleForm.MetalTracker.Maximum := 10000;
  BattleForm.EnergyTracker.Minimum := 0;
  BattleForm.EnergyTracker.Maximum := 10000;
  BattleForm.UnitsTracker.Minimum := 0;
  BattleForm.UnitsTracker.Maximum := 5000;

  s := '';
  // type:
  s := s + '1' + ' ';
  // NAT traversal method type:
  s := s + IntToStr(NATRadioGroup.ItemIndex) + ' ';
  // password (must be "*" for none):
  if PasswordEdit.Text = '' then s := s + '* ' else s := s + PasswordEdit.Text + ' ';
  // port:
  if NATRadioGroup.ItemIndex = 1 then s := s + IntToStr(NATTraversal.MyPublicUDPSourcePort) + ' '
  else s := s + PortEdit.Text + ' ';
  // max. players:
  s := s + IntToStr(PlayersTracker.Value) + ' ';

  {
  // metal:
  s := s + IntToStr(BattleForm.MetalTracker.Value) + ' ';
  // energy:
  s := s + IntToStr(BattleForm.EnergyTracker.Value) + ' ';
  // max. units:
  s := s + IntToStr(BattleForm.UnitsTracker.Value) + ' ';
  // start pos.:
  s := s + IntToStr(BattleForm.StartPosRadioGroup.ItemIndex) + ' ';
  // game end condition:
  s := s + IntToStr(BattleForm.GameEndRadioGroup.ItemIndex) + ' ';
  // limit d-gun to startpos:
  s := s + IntToStr(BoolToInt(BattleForm.LimitDGunCheckBox.Checked)) + ' ';
  // diminishing metal maker returns:
  s := s + IntToStr(BoolToInt(BattleForm.DiminishingMMsCheckBox.Checked)) + ' ';
  // ghosted buildings:
  s := s + IntToStr(BoolToInt(BattleForm.GhostedBuildingsCheckBox.Checked)) + ' ';
  }

  // hash code:
  s := s + IntToStr(GetModHash(ModsComboBox.Items[ModsComboBox.ItemIndex])) + ' ';
  // rank limit:
  s := s + IntToStr(RankComboBox.ItemIndex) + ' ';
  // map hash:
  s := s + IntToStr(Misc.HexToInt(Utility.MapChecksums[Utility.MapList.IndexOf(ReplaysForm.MapLabel.Caption)])) + ' ';
  // map:
  s := s + ReplaysForm.MapLabel.Caption + #9;
  // title (description):
  if TitleEdit.Text = '' then s := s + '(none)' + #9 else s := s + TitleEdit.Text + #9; // we should not send empty line for title!
  // name of mod:
  s := s + ModList[ModArchiveList.IndexOf(ReplaysForm.GameTypeLabel.Caption)];

  BattleState.LadderIndex := -1;

  // send the command:
  MainForm.TryToSendCommand('OPENBATTLE', s);

  if WaitForAckForm.ShowModal = mrOK then
  begin // success
    Close;
  end
  else
  begin // failure
  end;
end;

procedure THostBattleForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  if not SpTBXTitleBar1.Active then
    RemoveSpTBXTitleBarMarges(self);
  ModsComboBox.Items.Assign(Utility.ModList);
  ModsComboBox.ItemIndex := 0;

  RankComboBox.Items.Add('(No limit)');
  for i := 1 to High(Ranks) do RankComboBox.Items.Add(Ranks[i]);
  RankComboBox.ItemIndex := 0;
end;

procedure THostBattleForm.SpeedButton1Click(Sender: TObject);
begin
  HostInfoForm.ShowModal;
end;

procedure THostBattleForm.RankComboBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  // this ensures the correct highlite color is used
  (Control as TSpTBXComboBox).Canvas.FillRect(Rect);

  if Index <> 0 then MainForm.RanksImageList.Draw((Control as TSpTBXComboBox).Canvas, Rect.Left, Rect.Top, Index);
  if Index <> 0 then (Control as TSpTBxComboBox).Canvas.TextOut(Rect.Left + MainForm.RanksImageList.Width + 3, Rect.Top, (Control as TSpTBxComboBox).Items[Index])
  else (Control as TSpTBxComboBox).Canvas.TextOut(Rect.Left + 3, Rect.Top, (Control as TSpTBXComboBox).Items[Index]);
end;

procedure THostBattleForm.FormShow(Sender: TObject);
var
  s:string;
begin
  Host1Click(HostPopupMenu.Items[0]);
  s := HostBattleForm.ModsComboBox.Text;
  HostBattleForm.ModsComboBox.Items.Assign(Utility.ModList);
  HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(s));
  if HostButtonMenuIndex = 1 then
    HostLadder1Click(HostLadder1);
  if HostButtonMenuIndex = 2 then
    HostReplay1Click(HostReplay1);
  HostButtonMenuIndex := 0;
end;

procedure THostBattleForm.Host1Click(Sender: TObject);
var
  s : string;
begin
  ModsComboBox.Enabled := True;
  RankComboBox.Enabled := True;

  AutoSendDescCheckbox.Enabled := True;
  TitleEdit.Enabled := True;
  Label4.Enabled := True;

  PlayersTracker.Enabled := true;
  Label4.Visible := True;
  AutoSendDescCheckbox.Visible := True;
  TitleEdit.Visible := True;
  SpTBXLabel1.Visible := False;
  LadderComboBox.Visible := False;
  RefreshButton.Visible := False;

  Label3.Visible := True;
  Label8.Visible := True;
  PasswordEdit.Visible := True;

  s := ModsComboBox.Items[ModsComboBox.ItemIndex];
  ModsComboBox.Items.Assign(Utility.ModList);
  ModsComboBox.ItemIndex := ModsComboBox.Items.IndexOf(s);

  (Sender as TMenuItem).Checked := True;
  HostButton.Caption := 'Host';
end;

procedure THostBattleForm.HostReplay1Click(Sender: TObject);
begin
  ReplaysForm.WatchButton.Visible := False;
  ReplaysForm.HostReplayButton.Visible := True;

  AutoSendDescCheckbox.Enabled := True;
  TitleEdit.Enabled := True;
  Label4.Enabled := True;

  PlayersTracker.Enabled := true;
  Label4.Visible := True;
  AutoSendDescCheckbox.Visible := True;
  TitleEdit.Visible := True;
  SpTBXLabel1.Visible := False;
  LadderComboBox.Visible := False;

  Label3.Visible := True;
  Label8.Visible := True;
  PasswordEdit.Visible := True;

  if ReplaysForm.ShowModal <> mrOK then
  begin
    ReplaysForm.WatchButton.Visible := True;
    ReplaysForm.HostReplayButton.Visible := False;
    Exit;
  end;

  if Utility.MapList.IndexOf(ReplaysForm.MapLabel.Caption) = -1 then
  begin
    MessageDlg('You don''t have the map: ' + ReplaysForm.MapLabel.Caption, mtWarning, [mbOK], 0);
    ReplaysForm.WatchButton.Visible := True;
    ReplaysForm.HostReplayButton.Visible := False;
    Exit;
  end;

  if ModArchiveList.IndexOf(ReplaysForm.GameTypeLabel.Caption) = -1 then
  begin
    MessageDlg('You don''t have the mod: ' + ReplaysForm.GameTypeLabel.Caption, mtWarning, [mbOK], 0);
    ReplaysForm.WatchButton.Visible := True;
    ReplaysForm.HostReplayButton.Visible := False;
    Exit;
  end
  else ModsComboBox.ItemIndex := ModArchiveList.IndexOf(ReplaysForm.GameTypeLabel.Caption);


  // success:
  ReplaysForm.WatchButton.Visible := True;
  ReplaysForm.HostReplayButton.Visible := False;

  ModsComboBox.Enabled := False;
  RankComboBox.Enabled := False;

  RankComboBox.ItemIndex := 0;

  BattleReplayInfo.Script.Assign(ReplaysForm.ScriptRichEdit.Lines);
  BattleReplayInfo.ReplayFilename := TReplay(ReplayList.Items[ReplaysForm.ReplaysListBox.ItemIndex]).FileName;

  (Sender as TMenuItem).Checked := True;
  HostButton.Caption := 'Host Replay';
end;

procedure THostBattleForm.NATRadioGroupClick(Sender: TObject);
begin
  if NATRadioGroup.ItemIndex = 1 then PortEdit.Enabled := False
  else PortEdit.Enabled := True;
end;

procedure THostBattleForm.RefreshModListButtonClick(Sender: TObject);
var
  s: string;
begin
  Utility.ReInitLibWithDialog;
  if HostLadder1.Checked then
    ApplyLadderParams(TLadder(LadderList[LadderComboBox.ItemIndex]))
  else begin
    s := HostBattleForm.ModsComboBox.Text;
    HostBattleForm.ModsComboBox.Items.Assign(Utility.ModList);
    HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(s));
  end;
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
      MessageDlg('You must select a mod fist !', mtWarning, [mbOK], 0);
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
      MessageDlg('Unable to acquire UDP source port from server. Try choosing another NAT traversal technique!', mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

  if Host1.Checked then
    TryToHostBattle(-1)
  else if HostLadder1.Checked then
    if LadderList.Count = 0 then
      MessageDlg('You must select a ladder first !',mtWarning,[mbOk],0)
    else
      if Preferences.LadderPassword = '' then
        MessageDlg('You must enter your ladder password in the Options/Account first !',mtWarning,[mbOk],0)
      else
        TryToHostBattle(LadderComboBox.ItemIndex)
  else
    TryToHostReplay;
end;

  
procedure THostBattleForm.HostLadder1Click(Sender: TObject);
var
  ThreadLL : TLadderListThread;
begin
  ModsComboBox.Enabled := True;
  RankComboBox.Enabled := True;

  AutoSendDescCheckbox.Checked := False;
  AutoSendDescCheckbox.Enabled := False;
  TitleEdit.Enabled := False;
  Label4.Enabled := False;

  Label4.Visible := False;
  AutoSendDescCheckbox.Visible := False;
  TitleEdit.Visible := False;
  SpTBXLabel1.Visible := True;
  LadderComboBox.Visible := True;
  RefreshButton.Visible := True;

  Label3.Visible := False;
  Label8.Visible := False;
  PasswordEdit.Visible := False;

  (Sender as TMenuItem).Checked := True;
  HostButton.Caption := 'Host Ladder';

  if LadderComboBox.Items.Count =0 then
    ThreadLL := TLadderListThread.Create(False,-1)
  else
    ApplyLadderParams(TLadder(LadderList[LadderComboBox.ItemIndex]));
end;

procedure THostBattleForm.ApplyLadderParams(ladder: TLadder);
var
  i:integer;
begin
  if ladder.ModName <> '' then begin
    if ladder.MinPlayersPerAllyTeam = ladder.MaxPlayersPerAllyTeam then begin
      PlayersTracker.Minimum := 2;
      PlayersTracker.Maximum := 16;
      PlayersTracker.Value := ladder.MinPlayersPerAllyTeam*2;
      PlayersTracker.Enabled := False;
    end
    else
    begin
      PlayersTracker.Enabled := true;
      PlayersTracker.Minimum := ladder.MinPlayersPerAllyTeam*2;
      PlayersTracker.Maximum := ladder.MaxPlayersPerAllyTeam*2;
    end;
    ModsComboBox.Clear;
    for i:=0 to Utility.ModList.Count-1 do
      if Pos(ladder.ModName,Utility.ModList[i]) > 0 then
        ModsComboBox.Items.Add(Utility.ModList[i]);
    ModsComboBox.ItemIndex := ModsComboBox.Items.Count-1;
  end;
end;

constructor TLadderListThread.Create(Suspended : Boolean;ladderIndex: integer);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   OnTerminate := OnTerminateProcedure;
   DownloadLadderDetailsIndex := ladderIndex;
end;

procedure TLadderListThread.Execute;
begin
  if DownloadLadderDetailsIndex > -1 then begin
    DownloadLadderDetails(DownloadLadderDetailsIndex);
  end
  else
    Refresh;
end;

procedure TLadderListThread.Refresh;
var
  i,j,k:integer;
  html,laddername,ladderid:string;
  parse1 : TStrings;
  parse2 : TStrings;
  ladder : ^TLadder;
begin
  parse1 := TStringList.Create;
  //parse2 := TStringList.Create;
  LadderList.Clear;

  with HostBattleForm do begin
    LadderComboBox.Clear;
    LadderComboBox.Items.Add('Loading ladder list ...');
    LadderComboBox.ItemIndex := 0;
    HostButton.Enabled := False;
    RefreshButton.Enabled := False;

    if Preferences.UseProxy then
    begin
      HttpCli1.Proxy := Preferences.ProxyAddress;
      HttpCli1.ProxyPort := IntToStr(Preferences.ProxyPort);
      HttpCli1.ProxyUsername := Preferences.ProxyUsername;
      HttpCli1.ProxyPassword := Preferences.ProxyPassword
    end
    else HttpCli1.Proxy := '';
    HttpCli1.URL := LADDER_PREFIX_URL + 'ladderlist.php';
    HttpCli1.RcvdStream := TMemoryStream.Create;
    try
      HttpCli1.Get;
    except
      MainForm.AddMainLog('Error: Ladder server unavailable.', Colors.Error);
      LadderComboBox.Items.Strings[0] := 'Error: Ladder server unavailable.';
      LadderComboBox.ItemIndex := 0;
      RefreshButton.Enabled := True;
      HostButton.Enabled := True;
      LadderList.Clear;
      Exit;
    end;
    HttpCli1.RcvdStream.Seek(0,0);
    SetLength(html, HttpCli1.RcvdStream.Size-1);
    HttpCli1.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli1.RcvdStream.Size-1);
    HttpCli1.RcvdStream.Free;

    // parse the html result
    Misc.ParseDelimited(parse1,html,' ','');
    if (parse1[0] = 'error') or (parse1[0] = 'notice') then
    begin
      parse1.Delete(0);
      MessageDlgThread(Misc.JoinStringList(parse1,' '),mtError,[mbOK],0)
    end
    else
    begin
      parse1.Clear;
      Misc.ParseDelimited(parse1,html,#$A,'');
      for i:= 0 to parse1.Count -1 do // for each ladder
        if parse1[i] <> '' then begin
          k := Pos(' ',PChar(parse1[i]));
          laddername := MidStr(parse1[i],k+1,50000000);
          ladderid := Copy(parse1[i],1,k-1);
          j:= 0;
          while (j <= LadderList.Count-1) and (TLadder(LadderList[j]).id <> StrToInt(ladderid)) do
            j := j+1;
          if j > LadderList.Count-1 then begin
            New(ladder);
            ladder^ := TLadder.Create(StrToInt(ladderid),laddername);
            LadderList.Add(ladder^);
            if not DownloadLadderDetails(LadderList.indexof(ladder^)) then begin
              MainForm.AddMainLog('Error: Ladder details download failed : '+IntToStr(ladder^.id)+'.', Colors.Error);
              LadderComboBox.Items.Strings[0] := 'Error: Ladder details download failed : '+IntToStr(ladder^.id)+'.';
              LadderComboBox.ItemIndex := 0;
              HostButton.Enabled := True;
              RefreshButton.Enabled := True;
              Exit;
            end;
          end;
        end;
    end;
    LadderComboBox.Clear;
    for j:=0 to LadderList.Count -1 do
      LadderComboBox.Items.Add(TLadder(LadderList[j]).Name);
    LadderComboBox.ItemIndex := 0;
    ApplyLadderParams(TLadder(LadderList[0]));
    parse1.Clear;
    HostButton.Enabled := True;
    RefreshButton.Enabled := True
  end;
end;

function TLadderListThread.DownloadLadderDetails(ladderIndex : integer): boolean;
var
  html:string;
  parse1,parse2 : TStrings;
  i,j,k : integer;
  paramName,paramValue: string;
begin
  Result := True;
  TLadder(LadderList[ladderIndex]).Rules := 'Downloading ladder details ...';
  parse1 := TStringList.Create;
  parse2 := TStringList.Create;
  with HostBattleForm do begin
    if Preferences.UseProxy then
    begin
      HttpCli1.Proxy := Preferences.ProxyAddress;
      HttpCli1.ProxyPort := IntToStr(Preferences.ProxyPort);
      HttpCli1.ProxyUsername := Preferences.ProxyUsername;
      HttpCli1.ProxyPassword := Preferences.ProxyPassword
    end
    else HttpCli1.Proxy := '';
    HttpCli1.URL := LADDER_PREFIX_URL + 'rules.php?ladder='+IntToStr(TLadder(LadderList[ladderIndex]).id);
    HttpCli1.RcvdStream := TMemoryStream.Create;
    try
      HttpCli1.Get;
    except
      MainForm.AddMainLog('Error: Ladder details not available : '+IntToStr(TLadder(LadderList[ladderIndex]).id), Colors.Error);
      Exit;
    end;
    HttpCli1.RcvdStream.Seek(0,0);
    SetLength(html, HttpCli1.RcvdStream.Size);
    HttpCli1.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli1.RcvdStream.Size);
    HttpCli1.RcvdStream.Free;

    // parse the html result
    Misc.ParseDelimited(parse1,html,' ','');
    if (parse1[0] = 'error') or (parse1[0] = 'notice') then
    begin
      parse1.Delete(0);
      MessageDlgThread(Misc.JoinStringList(parse1,' '),mtError,[mbOK],0)
    end
    else
    begin
      parse1.Clear;
      Misc.ParseDelimited(parse1,html,#$A,'');
      with TLadder(LadderList[ladderIndex]) do begin
      for i:=0 to parse1.Count-1 do
        if parse1[i] <> '' then begin
        try
          k := Pos(' ',PChar(parse1[i]));
          paramValue := MidStr(parse1[i],k+1,5000000);
          paramName := Copy(parse1[i],1,k-1);
          if paramValue = 'any' then
            paramValue := '-1';
          if paramName = 'mod' then
            ModName := paramValue
          else if paramName = 'min_players_per_allyteam' then
            MinPlayersPerAllyTeam := StrToInt(paramValue)
          else if paramName = 'max_players_per_allyteam' then
            MaxPlayersPerAllyTeam := StrToInt(paramValue)
          else if paramName = 'startpos' then
            StartPos := StrToInt(paramValue)
          else if paramName = 'gamemode' then
            GameMode := StrToInt(paramValue)
          else if paramName = 'dgun' then
            DGun := StrToInt(paramValue)
          else if paramName = 'ghost' then
            Ghost := StrToInt(paramValue)
          else if paramName = 'diminish' then
            Diminish := StrToInt(paramValue)
          else if paramName = 'metal' then
            if paramValue <> '-1' then begin
              Misc.ParseDelimited(parse2,paramValue,' ','');
              MetalMin := StrToInt(parse2[0]);
              MetalMax := StrToInt(parse2[1]);
            end
            else
              MetalMin := StrToInt(paramValue)
          else if paramName = 'energy' then
            if paramValue <> '-1' then begin
              Misc.ParseDelimited(parse2,paramValue,' ','');
              EnergyMin := StrToInt(parse2[0]);
              EnergyMax := StrToInt(parse2[1]);
            end
            else
              EnergyMin := StrToInt(paramValue)
          else if paramName = 'units' then
            if paramValue <> '-1' then begin
              Misc.ParseDelimited(parse2,paramValue,' ','');
              UnitsMin := Max(10,StrToInt(parse2[0]));
              UnitsMax := Min(5000,StrToInt(parse2[1]));
            end
            else
              UnitsMin := StrToInt(paramValue)
          else if paramName = 'rules' then
            begin
              Rules := paramValue;
              for j:=i+1 to parse1.Count-1 do
                Rules := Rules + parse1[j];
              break;
            end
          else if paramName = 'restricted' then
              if paramValue <> 'none' then
                Misc.ParseDelimited(Restricted,paramValue,',','')
        Except
          MessageDlgThread('An error occured while parsing the ladder details !',mtError,[mbOk],0);
          Result := False;
          Exit;
        end;
        end;
        end;
    end;
    if TLadder(LadderList[ladderIndex]).Rules = '' then
      TLadder(LadderList[ladderIndex]).Rules := 'No rules set for this ladder.';
  end;
end;

procedure TLadderListThread.OnTerminateProcedure(Sender: TObject);
begin
  // nothing
end;

procedure THostBattleForm.RefreshButtonClick(Sender: TObject);
var
  ThreadLL : TLadderListThread;
begin
  LadderList.Clear;
  ThreadLL := TLadderListThread.Create(False,-1);
end;

procedure THostBattleForm.LadderComboBoxChange(Sender: TObject);
begin
  if LadderList.Count > 0 then
    ApplyLadderParams(TLadder(LadderList[LadderComboBox.ItemIndex]));
end;

end.
