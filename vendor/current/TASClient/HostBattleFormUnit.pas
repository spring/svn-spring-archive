unit HostBattleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, janTracker, Buttons, Menus,
  JvExControls, JvComponent, JvArrowButton;

type
  THostBattleForm = class(TForm)
    Label1: TLabel;
    CancelButton: TButton;
    PortEdit: TEdit;
    Label2: TLabel;
    PasswordEdit: TEdit;
    Label3: TLabel;
    PlayersTracker: TjanTracker;
    TitleEdit: TEdit;
    Label4: TLabel;
    ModsComboBox: TComboBox;
    Label5: TLabel;
    SpeedButton1: TSpeedButton;
    RankComboBox: TComboBox;
    Label6: TLabel;
    JvHostArrowButton: TJvArrowButton;
    HostPopupMenu: TPopupMenu;
    Host1: TMenuItem;
    HostReplay1: TMenuItem;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure TryToHostBattle;
    procedure TryToHostReplay;    

    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RankComboBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure JvHostArrowButtonClick(Sender: TObject);
    procedure Host1Click(Sender: TObject);
    procedure HostReplay1Click(Sender: TObject);
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
  ReplaysUnit;

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
  InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)
  // now let's update units:
  InitWaitForm.ChangeCaption(MSG_GETUNITS);
  InitWaitForm.TakeAction := 1; // load unit lists
  InitWaitForm.ShowModal; // this loads unit lists (see OnFormActivate event)
  DisableUnitsForm.VDTUnits.RootNodeCount := UnitNames.Count;

  s := 'OPENBATTLE ';
  // type:
  s := s + '0' + ' ';
  // password (must be "*" for none):
  if PasswordEdit.Text = '' then s := s + '* ' else s := s + PasswordEdit.Text + ' ';
  // port:
  s := s + PortEdit.Text + ' ';
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
  InitWaitForm.ShowModal; // this changes mod (see OnFormActivate event)
  // now let's update units:
  InitWaitForm.ChangeCaption(MSG_GETUNITS);
  InitWaitForm.TakeAction := 1; // load unit lists
  InitWaitForm.ShowModal; // this loads unit lists (see OnFormActivate event)
  DisableUnitsForm.VDTUnits.RootNodeCount := UnitNames.Count;

  s := 'OPENBATTLE ';
  // type:
  s := s + '1' + ' ';
  // password (must be "*" for none):
  if PasswordEdit.Text = '' then s := s + '* ' else s := s + PasswordEdit.Text + ' ';
  // port:
  s := s + PortEdit.Text + ' ';
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
  (Control as TComboBox).Canvas.FillRect(Rect);

  if Index <> 0 then MainForm.RanksImageList.Draw((Control as TComboBox).Canvas, Rect.Left, Rect.Top, Index);
  if Index <> 0 then (Control as TComboBox).Canvas.TextOut(Rect.Left + MainForm.RanksImageList.Width + 3, Rect.Top, (Control as TComboBox).Items[Index])
  else (Control as TComboBox).Canvas.TextOut(Rect.Left + 3, Rect.Top, (Control as TComboBox).Items[Index]);

end;

procedure THostBattleForm.FormShow(Sender: TObject);
begin
  Host1Click(HostPopupMenu.Items[0]);
end;

procedure THostBattleForm.JvHostArrowButtonClick(Sender: TObject);
begin
  if JvHostArrowButton.Caption = 'Host' then TryToHostBattle
  else TryToHostReplay;
end;

procedure THostBattleForm.Host1Click(Sender: TObject);
begin
  ModsComboBox.Enabled := True;
  RankComboBox.Enabled := True;

  (Sender as TMenuItem).Checked := True;
  JvHostArrowButton.Caption := 'Host';
end;

procedure THostBattleForm.HostReplay1Click(Sender: TObject);
begin
  MessageDlg('Multiplayer replay feature is disabled until next update, since some issues have been identified with it. Sorry!', mtInformation, [mbOK], 0);
  Exit;

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
  JvHostArrowButton.Caption := 'Host Replay';
end;

end.
