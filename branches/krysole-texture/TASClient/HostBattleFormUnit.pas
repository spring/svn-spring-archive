unit HostBattleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, janTracker, Buttons, Menus,
  JvExControls, JvComponent, JvArrowButton, ExtCtrls, JvXPCore, JvXPButtons,
  TBXDkPanels, SpTBXControls, TntStdCtrls, SpTBXEditors, SpTBXItem, TBX,
  TB2Item, TB2ExtItems, TB2Dock, TB2Toolbar;

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
    PlayersTracker: TjanTracker;
    TitleEdit: TSpTBXEdit;
    ModsComboBox: TSpTBXComboBox;
    RankComboBox: TSpTBXComboBox;
    NATRadioGroup: TRadioGroup;
    RefreshModListButton: TJvXPButton;
    HostButton: TTBXButton;
    HostPopupMenu: TPopupMenu;
    Host1: TMenuItem;
    HostReplay1: TMenuItem;
    CancelButton: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure TryToHostBattle;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HostBattleForm: THostBattleForm;
  BattleReplayScript: string;

implementation

uses WaitForAckUnit, BattleFormUnit, Unit1, Utility, InitWaitFormUnit,
  DisableUnitsFormUnit, HostInfoUnit, Misc, PreferencesFormUnit,
  ReplaysUnit, Math;

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
  Close;
end;

procedure THostBattleForm.TryToHostBattle;
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

  s := 'OPENBATTLE ';
  // type:
  s := s + '0' + ' ';
  // NAT traversal method type:
  s := s + IntToStr(NATRadioGroup.ItemIndex) + ' ';
  // password (must be "*" for none):
  if PasswordEdit.Text = '' then s := s + '* ' else s := s + PasswordEdit.Text + ' ';
  // port:
  if NATRadioGroup.ItemIndex = 1 then s := s + IntToStr(NATTraversal.MyPublicUDPSourcePort) + ' '
  else s := s + PortEdit.Text + ' ';
  // max. players:
  s := s + IntToStr(PlayersTracker.Value) + ' ';
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
  // hash code:
  s := s + IntToStr(GetModHash(ModsComboBox.Items[ModsComboBox.ItemIndex])) + ' ';
  // rank limit:
  s := s + IntToStr(RankComboBox.ItemIndex) + ' ';
  // map:
  s := s + BattleForm.MapList.Items[BattleForm.MapList.ItemIndex] + #9;
  // title (description):
  if TitleEdit.Text = '' then s := s + '(none)' + #9 else s := s + TitleEdit.Text + #9; // we should not send empty line for title!
  // name of mod:
  s := s + ModsComboBox.Text;

  // send the command:
  MainForm.TryToSendData(s);

  if WaitForAckForm.ShowModal = mrOK then
  begin // success
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

  s := 'OPENBATTLE ';
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
  // hash code:
  s := s + IntToStr(GetModHash(ModsComboBox.Items[ModsComboBox.ItemIndex])) + ' ';
  // rank limit:
  s := s + IntToStr(RankComboBox.ItemIndex) + ' ';
  // map:
  s := s + ReplaysForm.MapLabel.Caption + #9;
  // title (description):
  if TitleEdit.Text = '' then s := s + '(none)' + #9 else s := s + TitleEdit.Text + #9; // we should not send empty line for title!
  // name of mod:
  s := s + ModList[ModArchiveList.IndexOf(ReplaysForm.GameTypeLabel.Caption)];

  // send the command:
  MainForm.TryToSendData(s);

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
begin
  Host1Click(HostPopupMenu.Items[0]);
end;

procedure THostBattleForm.Host1Click(Sender: TObject);
begin
  ModsComboBox.Enabled := True;
  RankComboBox.Enabled := True;

  (Sender as TMenuItem).Checked := True;
  HostButton.Caption := 'Host';
end;

procedure THostBattleForm.HostReplay1Click(Sender: TObject);
begin
  ReplaysForm.WatchButton.Visible := False;
  ReplaysForm.HostReplayButton.Visible := True;

  if ReplaysForm.ShowModal <> mrOK then
  begin
    ReplaysForm.WatchButton.Visible := True;
    ReplaysForm.HostReplayButton.Visible := False;
    Exit;
  end;

  if BattleForm.MapList.Items.IndexOf(ReplaysForm.MapLabel.Caption) = -1 then
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
  s := HostBattleForm.ModsComboBox.Text;
  HostBattleForm.ModsComboBox.Items.Assign(Utility.ModList);
  HostBattleForm.ModsComboBox.ItemIndex := Max(0, HostBattleForm.ModsComboBox.Items.IndexOf(s));
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

  if HostButton.Caption = 'Host' then TryToHostBattle
  else TryToHostReplay;
end;

  
end.
