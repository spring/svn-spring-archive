unit ManageGroups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, StdCtrls, TntStdCtrls, SpTBXEditors, CheckLst,
  TntCheckLst, TBXDkPanels, SpTBXControls,MainUnit, ExtCtrls, Misc;

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
    SpTBXLabel2: TSpTBXLabel;
    SpTBXLabel3: TSpTBXLabel;
    SpTBXLabel4: TSpTBXLabel;
    btChooseColor: TSpTBXButton;
    btClose: TSpTBXButton;
    AutoSpecCheckBox: TSpTBXCheckBox;
    AutoKickCheckBox: TSpTBXCheckBox;
    NotifyOnHostCheckBox: TSpTBXCheckBox;
    SpTBXLabel5: TSpTBXLabel;
    SpTBXLabel6: TSpTBXLabel;
    NotifyOnJoinCheckBox: TSpTBXCheckBox;
    SpTBXLabel7: TSpTBXLabel;
    NotifyOnBattlEndCheckBox: TSpTBXCheckBox;
    SpTBXLabel8: TSpTBXLabel;
    NotifyOnConnectCheckBox: TSpTBXCheckBox;
    txtName: TSpTBXEdit;
    SpTBXLabel9: TSpTBXLabel;
    HighlightBattlesCheckbox: TSpTBXCheckBox;
    btAddPlayer: TSpTBXButton;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ManageGroupsForm: TManageGroupsForm;

implementation

uses ColorPicker;

{$R *.dfm}

procedure TManageGroupsForm.FormShow(Sender: TObject);
var
  i:Integer;
begin
  cmbGroups.Clear;
  for i:=0 to ClientGroups.Count-1 do
    cmbGroups.Items.Add(TClientGroup(ClientGroups[i]).Name);
  if cmbGroups.Items.Count > 0 then
    cmbGroups.ItemIndex := 0;
  cmbGroupsChange(Sender);
end;

procedure TManageGroupsForm.cmbGroupsChange(Sender: TObject);
var
  i: Integer;
begin
  lstClients.Clear;
  for i:=0 to TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Clients.Count-1 do
    lstClients.Items.Add(TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Clients[i]);
  ColorPanel.Color := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Color;
  txtName.Text := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Name;
  AutoKickCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AutoKick;
  AutoSpecCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).AutoSpec;
  NotifyOnHostCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnHost;
  NotifyOnJoinCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnJoin;
  NotifyOnBattlEndCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnBattleEnd;
  NotifyOnConnectCheckBox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).NotifyOnConnect;
  HighlightBattlesCheckbox.Checked := TClientGroup(ClientGroups[cmbGroups.ItemIndex]).HighlightBattles;
end;

procedure TManageGroupsForm.btRemoveClick(Sender: TObject);
var
  i:Integer;
begin
  for i:= lstClients.Count-1 downto 0 do
  if lstClients.Checked[i] then
  begin
    TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Clients.Delete(i);
    lstClients.Items.Delete(i);
  end;
  MainForm.SaveGroups;
  MainForm.ClientsListBox.Refresh;
end;

procedure TManageGroupsForm.btRenameClick(Sender: TObject);
var
  InputString : String;
  index : Integer;
begin
  InputString:= cmbGroups.Items[cmbGroups.ItemIndex];
  if InputQuery('Renaming group ...', 'Enter the group name :', InputString) then begin
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
  ColorPanel.Color := InputColor('Choose a group color ...',ColorPanel.Color);
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Color := ColorPanel.Color;
  MainForm.ClientsListBox.Refresh;
end;

procedure TManageGroupsForm.btRemoveGroupClick(Sender: TObject);
begin
  if MessageDlg('Remove the group '+TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Name, mtInformation, [mbYes, mbNo], 0) = mrNo then
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
begin
  if not SpTBXTitleBar1.Active then
    RemoveSpTBXTitleBarMarges(self);
end;

procedure TManageGroupsForm.HighlightBattlesCheckboxClick(Sender: TObject);
begin
  TClientGroup(ClientGroups[cmbGroups.ItemIndex]).HighlightBattles := HighlightBattlesCheckbox.Checked;
end;

procedure TManageGroupsForm.btAddPlayerClick(Sender: TObject);
var
  InputString: string;
begin
  InputString := '';
  if InputQuery('New group ...', 'Enter the group name :', InputString) and (InputString <> '') then
  begin
    TClientGroup(ClientGroups[cmbGroups.ItemIndex]).Clients.Add(InputString);
    lstClients.Items.Add(InputString);
    lstClients.Refresh;
  end;
end;

end.
