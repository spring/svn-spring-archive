unit ManageGroups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, StdCtrls, TntStdCtrls, SpTBXEditors, CheckLst,
  TntCheckLst, SpTBXControls,MainUnit, ExtCtrls, Misc, SpTBXSkins;

type
  TManageGroupsForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    lstClients: TSpTBXCheckListBox;
    cmbGroups: TSpTBXComboBox;
    SpTBXPanel1: TSpTBXPanel;
    btRemove: TSpTBXButton;
    btRemoveGroup: TSpTBXButton;
    SpTBXPanel2: TSpTBXPanel;
    ColorPanel: TPanel;
    SpTBXLabel1: TSpTBXLabel;
    btChooseColor: TSpTBXButton;
    btClose: TSpTBXButton;
    AutoSpecCheckBox: TSpTBXCheckBox;
    AutoKickCheckBox: TSpTBXCheckBox;
    NotifyOnHostCheckBox: TSpTBXCheckBox;
    NotifyOnJoinCheckBox: TSpTBXCheckBox;
    NotifyOnBattlEndCheckBox: TSpTBXCheckBox;
    NotifyOnConnectCheckBox: TSpTBXCheckBox;
    txtName: TSpTBXEdit;
    HighlightBattlesCheckbox: TSpTBXCheckBox;
    btAddPlayer: TSpTBXButton;
    ChatColorPanel: TPanel;
    btChooseChatColor: TSpTBXButton;
    ChatColorCheckBox: TSpTBXCheckBox;
    ReplaceRankCheckBox: TSpTBXCheckBox;
    ReplaceRankCmb: TSpTBXComboBox;
    BalanceInSameTeamCheckBox: TSpTBXCheckBox;
    IgnoreCheckBox: TSpTBXCheckBox;
    ColorCheckBox: TSpTBXCheckBox;
    SpTBXLabel13: TSpTBXLabel;
    ExecSpecCommandsCheckBox: TSpTBXCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cmbGroupsChange(Sender: TObject);
    procedure btRemoveClick(Sender: TObject);
    procedure btRenameClick(Sender: TObject);
    procedure btChooseColorClick(Sender: TObject);
    procedure btRemoveGroupClick(Sender: TObject);
    procedure txtNameChange(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure AutoSpecCheckBoxClick(Sender: TObject);
    procedure AutoKickCheckBoxClick(Sender: TObject);
    procedure NotifyOnHostCheckBoxClick(Sender: TObject);
    procedure NotifyOnJoinCheckBoxClick(Sender: TObject);
    procedure NotifyOnBattlEndCheckBoxClick(Sender: TObject);
    procedure NotifyOnConnectCheckBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HighlightBattlesCheckboxClick(Sender: TObject);
    procedure btAddPlayerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChatColorCheckBoxClick(Sender: TObject);
    procedure btChooseChatColorClick(Sender: TObject);
    procedure ReplaceRankCheckBoxClick(Sender: TObject);
    procedure ReplaceRankCmbChange(Sender: TObject);
    procedure BalanceInSameTeamCheckBoxClick(Sender: TObject);
    procedure IgnoreCheckBoxClick(Sender: TObject);
    procedure lstClientsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lstClientsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ColorCheckBoxClick(Sender: TObject);
    procedure ReplaceRankCmbDrawItem(Sender: TObject; ACanvas: TCanvas;
      var ARect: TRect; Index: Integer; const State: TOwnerDrawState;
      const PaintStage: TSpTBXPaintStage; var PaintDefault: Boolean);
    procedure ExecSpecCommandsCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ManageGroupsForm: TManageGroupsForm;

implementation

uses ColorPicker, LobbyScriptUnit, gnugettext, BattleFormUnit,
  PreferencesFormUnit;

{$R *.dfm}

procedure TManageGroupsForm.FormShow(Sender: TObject);
var
  i:Integer;
  client: TClient;
  g : TClientGroup;
begin
  cmbGroups.Clear;
  for i:=0 to ClientGroups.Count-1 do
    cmbGroups.Items.Add(TClientGroup(ClientGroups[i]).Name);

  client := MainForm.GetClient(SelectedUserName);
  if client <> nil then
  begin
    g := client.GetGroup;
    if g <> nil then
    begin
      cmbGroups.ItemIndex := ClientGroups.IndexOf(g);
      cmbGroupsChange(Sender);
      Exit
    end;
  end;

  if cmbGroups.Items.Count > 0 then
    cmbGroups.ItemIndex := 0;
  cmbGroupsChange(Sender);
end;

procedure TManageGroupsForm.cmbGroupsChange(Sender: TObject);
var
  i: Integer;
  latestName: WideString;
begin
  lstClients.Clear;
  lstClients.Items.AddStrings(TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Clients);
  for i:=0 to TClientGroup(ClientGroups[cmbGroups.ItemIndex]).ClientsIds.Count-1 do
  begin
    latestName := TClient.GetLatestName(TClientGroup(ClientGroups[cmbGroups.ItemIndex]).ClientsIds.Items[i]);
    if latestName <> '' then
      lstClients.Items.Add(latestName);
  end;
  ColorPanel.Color := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Color;
  txtName.Text := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Name;
  AutoKickCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AutoKick;
  AutoSpecCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AutoSpec;
  NotifyOnHostCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnHost;
  NotifyOnJoinCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnJoin;
  NotifyOnBattlEndCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnBattleEnd;
  NotifyOnConnectCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnConnect;
  HighlightBattlesCheckbox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).HighlightBattles;
  ChatColorCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).EnableChatColor;
  ChatColorPanel.Color := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).ChatColor;
  ReplaceRankCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).ReplaceRank;
  ReplaceRankCmb.ItemIndex := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Rank;
  BalanceInSameTeamCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).BalanceInSameTeam;
  IgnoreCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Ignore;
  ColorCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).EnableColor;
  ExecSpecCommandsCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).ExecuteSpecialCommands;
end;

procedure TManageGroupsForm.btRemoveClick(Sender: TObject);
var
  i:Integer;
begin
  for i:= lstClients.Count-1 downto 0 do
  if lstClients.Checked[i] then
  begin
    TClientGroup(ClientGroups[cmbGroups.ItemIndex]).RemoveClient(lstClients.Items[i]);
    lstClients.Items.Delete(i);
  end;
  MainForm.SaveGroups;
  MainForm.ResortClientsLists;
end;

procedure TManageGroupsForm.btRenameClick(Sender: TObject);
var
  InputString : String;
  index : Integer;
begin
  InputString:= cmbGroups.Items[cmbGroups.ItemIndex];
  if InputQuery(_('Renaming group ...'), _('Enter the group name :'), InputString) then begin
    TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Name := InputString;
    index := cmbGroups.ItemIndex;
    cmbGroups.Items[cmbGroups.ItemIndex] := InputString;
    cmbGroups.ItemIndex := index;
    cmbGroups.Refresh;
    MainForm.SaveGroups;
  end;
end;

procedure TManageGroupsForm.btChooseColorClick(Sender: TObject);
begin
  ColorPanel.Color := InputColor(_('Choose a group color ...'),ColorPanel.Color);
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Color := ColorPanel.Color;
  MainForm.UpdateClientsListBox;
end;

procedure TManageGroupsForm.btRemoveGroupClick(Sender: TObject);
begin
  if MessageDlg(_('Remove the group ')+TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Name, mtInformation, [mbYes, mbNo], 0) = mrNo then
    Exit;
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Destroy;
  ClientGroups.Delete(cmbGroups.ItemIndex);
  MainForm.SaveGroups;
  cmbGroups.Items.Delete(cmbGroups.ItemIndex);
  MainForm.ClientsListBox.Refresh;
  if ClientGroups.Count = 0 then begin
    Close;
    Exit;
  end;
  cmbGroups.ItemIndex := 0;
  cmbGroupsChange(Sender);
  MainForm.ResortClientsLists;
end;

procedure TManageGroupsForm.txtNameChange(Sender: TObject);
var
  index:integer;
begin
    TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Name := txtName.Text;
    index := cmbGroups.ItemIndex;
    cmbGroups.Items[cmbGroups.ItemIndex] := txtName.Text;
    cmbGroups.ItemIndex := index;
    cmbGroups.Refresh;
end;

procedure TManageGroupsForm.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TManageGroupsForm.AutoSpecCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AutoSpec := AutoSpecCheckBox.Checked;
end;

procedure TManageGroupsForm.AutoKickCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AutoKick := AutoKickCheckBox.Checked;
end;

procedure TManageGroupsForm.NotifyOnHostCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnHost := NotifyOnHostCheckBox.Checked;
end;

procedure TManageGroupsForm.NotifyOnJoinCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnJoin := NotifyOnJoinCheckBox.Checked;
end;

procedure TManageGroupsForm.NotifyOnBattlEndCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnBattleEnd := NotifyOnBattlEndCheckBox.Checked;
end;

procedure TManageGroupsForm.NotifyOnConnectCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnConnect := NotifyOnConnectCheckBox.Checked;
end;

procedure TManageGroupsForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  TranslateComponent(self);

  for i := 0 to High(Ranks) do ReplaceRankCmb.Items.Add(Ranks[i]);
  ReplaceRankCmb.ItemIndex := 0;
end;

procedure TManageGroupsForm.HighlightBattlesCheckboxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).HighlightBattles := HighlightBattlesCheckbox.Checked;
end;

procedure TManageGroupsForm.btAddPlayerClick(Sender: TObject);
var
  InputString: string;
  client: TClient;
begin
  InputString := '';
  if InputQuery(_('New group ...'), _('Enter the player name :'), InputString) and (InputString <> '') then
  begin
    if not TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AddClient(InputString) then
    begin
      MessageDlg(_('Unknown user.'),mtError,[mbOK],0);
      Exit;
    end;
    lstClients.Items.Add(InputString);
    lstClients.Refresh;

    client := MainForm.GetClient(InputString);
    if client <> nil then
      MainForm.SortClientInLists(client);
  end;
end;

procedure TManageGroupsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onGroupsChanged(); except end;
  ReleaseMainThread;
  MainForm.SaveGroups;
end;

procedure TManageGroupsForm.ChatColorCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).EnableChatColor := ChatColorCheckBox.Checked;
end;

procedure TManageGroupsForm.btChooseChatColorClick(Sender: TObject);
begin
  ChatColorPanel.Color := InputColor(_('Choose a group color ...'),ChatColorPanel.Color);
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).ChatColor := ChatColorPanel.Color;
end;

procedure TManageGroupsForm.ReplaceRankCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).ReplaceRank := ReplaceRankCheckBox.Checked;
end;

procedure TManageGroupsForm.ReplaceRankCmbChange(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Rank := ReplaceRankCmb.ItemIndex;
end;

procedure TManageGroupsForm.BalanceInSameTeamCheckBoxClick(
  Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).BalanceInSameTeam := BalanceInSameTeamCheckBox.Checked;
end;

procedure TManageGroupsForm.IgnoreCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Ignore := IgnoreCheckBox.Checked;
end;

procedure TManageGroupsForm.lstClientsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  tmp,realIndex: integer;
  cList: TList;
  i:integer;
  WhatToDraw: TClientNodeType;
begin
  if(Source = MainForm.ClientsListBox) then
  begin
    if MainForm.ClientsListBox.ItemIndex = -1 then Exit;
    if MainForm.lastActiveTab.Caption = LOCAL_TAB then
      cList := AllClients
    else
      cList := MainForm.lastActiveTab.Clients;

    tmp := MainForm.ClientsListBox.ItemIndex;
    for i:=0 to cList.Count-1 do
    begin
      if TClient(cList[i]).Visible then Dec(tmp);
      if tmp = -1 then break;
    end;
    realIndex := i;

    if realIndex>-1 then
    begin
      if TClient(cList[realIndex]).GetGroup <> nil then
        TClient(cList[realIndex]).GetGroup.RemoveClient(TClient(cList[realIndex]).Name);
      TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AddClient(TClient(cList[realIndex]).Name);
      lstClients.Items.Add(TClient(cList[realIndex]).Name);
      lstClients.Refresh;
      MainForm.SortClientInLists(TClient(cList[realIndex]));
    end
    else
      MainForm.AddMainLog('Error: Player not found in global player list. (3)',Colors.Error);
    Exit;
  end;
  if(Source = BattleForm.VDTBattleClients) then
  begin
    BattleForm.GetNodeClient(BattleForm.VDTBattleClients.FocusedNode.Index,realIndex,WhatToDraw);
    if WhatToDraw = NormalClient then
    begin
      if TClient(BattleState.Battle.Clients[realIndex]).GetGroup <> nil then
        TClient(BattleState.Battle.Clients[realIndex]).GetGroup.RemoveClient(TClient(BattleState.Battle.Clients[realIndex]).Name);
      TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AddClient(TClient(BattleState.Battle.Clients[realIndex]).Name);
      lstClients.Items.Add(TClient(BattleState.Battle.Clients[realIndex]).Name);
      lstClients.Refresh;
      MainForm.SortClientInLists(TClient(BattleState.Battle.Clients[realIndex]));
    end;
    Exit;
  end;
end;

procedure TManageGroupsForm.lstClientsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = MainForm.ClientsListBox) or (Source = BattleForm.VDTBattleClients);
end;

procedure TManageGroupsForm.ColorCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).EnableColor := ColorCheckBox.Checked;
  if Preferences.SortStyle = 5 then
    MainForm.ResortClientsLists;
end;

procedure TManageGroupsForm.ReplaceRankCmbDrawItem(Sender: TObject;
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
  MainForm.RanksImageList.Draw(ACanvas, ARect.Left, ARect.Top, Index);
  ACanvas.TextOut(ARect.Left + MainForm.RanksImageList.Width + 3, ARect.Top, (Sender as TSpTBxComboBox).Items[Index])
end;

procedure TManageGroupsForm.ExecSpecCommandsCheckBoxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).ExecuteSpecialCommands := ExecSpecCommandsCheckBox.Checked;
end;

end.
