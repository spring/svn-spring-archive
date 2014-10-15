unit AutoJoinFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, VirtualTrees, SpTBXItem, StdCtrls,
  TntStdCtrls, SpTBXEditors, IniFiles, StrUtils;

type
  TAutoJoinPresetItemList =
  record
    PresetName: string;
    Sorting: integer;
    SortingDirection: integer;
  end;
  PAutoJoinPresetItemList = ^TAutoJoinPresetItemList;
  TAutoJoinForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    gbAutoPlay: TSpTBXGroupBox;
    VSTAutoplayPresetList: TVirtualStringTree;
    btAutoplayPriorityUp: TSpTBXButton;
    btAutoplayPriorityDown: TSpTBXButton;
    btAutoplayRemovePreset: TSpTBXButton;
    gbAddPreset: TSpTBXGroupBox;
    SpTBXLabel1: TSpTBXLabel;
    cmbFilterPresetList: TSpTBXComboBox;
    SpTBXLabel2: TSpTBXLabel;
    cmbSortingList: TSpTBXComboBox;
    SpTBXLabel3: TSpTBXLabel;
    cmbSortDir: TSpTBXComboBox;
    btAddPresetToAutoplay: TSpTBXButton;
    gbAutoSpec: TSpTBXGroupBox;
    VSTAutospecPresetList: TVirtualStringTree;
    btAutospecPriorityUp: TSpTBXButton;
    btAutospecPriorityDown: TSpTBXButton;
    btAutospecRemovePreset: TSpTBXButton;
    btAddPresetToAutospec: TSpTBXButton;
    btClose: TSpTBXButton;
    gbOptions: TSpTBXGroupBox;
    chkKeepLookingAfterJoining: TSpTBXCheckBox;
    gbPresets: TSpTBXGroupBox;
    btSavePreset: TSpTBXButton;
    btDeletePreset: TSpTBXButton;
    txtPresetName: TSpTBXEdit;
    btClearPresets: TSpTBXButton;
    lstPresetList: TSpTBXListBox;
    chkLeaveNotFittingBattles: TSpTBXCheckBox;
    chkStopAutoJoinWhenLeaving: TSpTBXCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btAddPresetToAutoplayClick(Sender: TObject);
    procedure VSTAutoplayPresetListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure btCloseClick(Sender: TObject);
    procedure btAddPresetToAutospecClick(Sender: TObject);
    procedure VSTAutospecPresetListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure btAutoplayPriorityUpClick(Sender: TObject);
    procedure btAutoplayPriorityDownClick(Sender: TObject);
    procedure btAutospecPriorityUpClick(Sender: TObject);
    procedure btAutospecPriorityDownClick(Sender: TObject);
    procedure btAutoplayRemovePresetClick(Sender: TObject);
    procedure btAutospecRemovePresetClick(Sender: TObject);
    procedure btSavePresetClick(Sender: TObject);
    procedure btDeletePresetClick(Sender: TObject);
    procedure btClearPresetsClick(Sender: TObject);
    procedure lstPresetListClick(Sender: TObject);
    procedure lstPresetListDblClick(Sender: TObject);
    procedure VSTAutoplayPresetListDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: WideString; const CellRect: TRect;
      var DefaultDraw: Boolean);
    procedure VSTAutospecPresetListDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: WideString; const CellRect: TRect;
      var DefaultDraw: Boolean);
    procedure VSTAutoplayPresetListHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure VSTAutospecPresetListHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure VSTAutospecPresetListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure VSTAutoplayPresetListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
  private
    { Private declarations }
  public
    autoPlayPresetList: TList;
    autoSpecPresetList: TList;

    procedure SaveAutoJoinPreset(FileName: string);
    procedure LoadAutoJoinPreset(FileName: string);
    procedure LoadAutoJoinPresets;
    procedure initPresets;
  end;

var
  AutoJoinForm: TAutoJoinForm;

implementation

uses MainUnit, gnugettext, Misc;

{$R *.dfm}

procedure TAutoJoinForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  initPresets;
end;

procedure TAutoJoinForm.FormShow(Sender: TObject);
var
  i: integer;
begin
  cmbFilterPresetList.Clear;
  cmbFilterPresetList.Items.AddStrings(MainForm.PresetListbox.Items);
  cmbFilterPresetList.ItemIndex := 0;

  if cmbSortingList.ItemIndex = -1 then
    cmbSortingList.ItemIndex := 0;
  if cmbSortDir.ItemIndex = -1 then
    cmbSortDir.ItemIndex := 0;
end;

procedure TAutoJoinForm.btAddPresetToAutoplayClick(Sender: TObject);
var
  newPreset: PAutoJoinPresetItemList;
begin
  New(newPreset);
  newPreset.PresetName := cmbFilterPresetList.Text;
  newPreset.Sorting := cmbSortingList.ItemIndex;
  newPreset.SortingDirection := cmbSortDir.ItemIndex;

  autoPlayPresetList.Add(newPreset);
  VSTAutoplayPresetList.RootNodeCount := VSTAutoplayPresetList.RootNodeCount+1;
  VSTAutoplayPresetList.Refresh;
end;

procedure TAutoJoinForm.VSTAutoplayPresetListGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
begin
  case Column of
    0:CellText := IntToStr(Node.Index+1);
    1:CellText := PAutoJoinPresetItemList(autoPlayPresetList[Node.Index]).PresetName;
    2:CellText := cmbSortingList.Items[PAutoJoinPresetItemList(autoPlayPresetList[Node.Index]).Sorting];
    3:CellText := cmbSortDir.Items[PAutoJoinPresetItemList(autoPlayPresetList[Node.Index]).SortingDirection];
  end;
end;

procedure TAutoJoinForm.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TAutoJoinForm.btAddPresetToAutospecClick(Sender: TObject);
var
  newPreset: PAutoJoinPresetItemList;
begin
  New(newPreset);
  newPreset.PresetName := cmbFilterPresetList.Text;
  newPreset.Sorting := cmbSortingList.ItemIndex;
  newPreset.SortingDirection := cmbSortDir.ItemIndex;

  autoSpecPresetList.Add(newPreset);
  VSTAutospecPresetList.RootNodeCount := VSTAutospecPresetList.RootNodeCount+1;
  VSTAutospecPresetList.Refresh;
end;

procedure TAutoJoinForm.VSTAutospecPresetListGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
begin
  case Column of
    0:CellText := IntToStr(Node.Index+1);
    1:CellText := PAutoJoinPresetItemList(autoSpecPresetList[Node.Index]).PresetName;
    2:CellText := cmbSortingList.Items[PAutoJoinPresetItemList(autoSpecPresetList[Node.Index]).Sorting];
    3:CellText := cmbSortDir.Items[PAutoJoinPresetItemList(autoSpecPresetList[Node.Index]).SortingDirection];
  end;
end;

procedure TAutoJoinForm.btAutoplayPriorityUpClick(Sender: TObject);
var
  item: PAutoJoinPresetItemList;
  idx : integer;
begin
  if VSTAutoplayPresetList.GetFirstSelected = nil then
    Exit;
  idx := VSTAutoplayPresetList.GetFirstSelected.Index;
  if idx = 0 then
    Exit;
  item := autoPlayPresetList[idx-1];
  autoPlayPresetList[idx-1] := autoPlayPresetList[idx];
  autoPlayPresetList[idx] := item;
  VSTAutoplayPresetList.Refresh;
  VSTAutoplayPresetList.Selected[VSTAutoplayPresetList.GetFirstSelected.PrevSibling] := True;
end;

procedure TAutoJoinForm.btAutoplayPriorityDownClick(Sender: TObject);
var
  item: PAutoJoinPresetItemList;
  idx : integer;
begin
  if VSTAutoplayPresetList.GetFirstSelected = nil then
    Exit;
  idx := VSTAutoplayPresetList.GetFirstSelected.Index;
  if idx = VSTAutoplayPresetList.RootNodeCount-1 then
    Exit;
  item := autoPlayPresetList[idx+1];
  autoPlayPresetList[idx+1] := autoPlayPresetList[idx];
  autoPlayPresetList[idx] := item;
  VSTAutoplayPresetList.Refresh;
  VSTAutoplayPresetList.Selected[VSTAutoplayPresetList.GetFirstSelected.NextSibling] := True;
end;

procedure TAutoJoinForm.btAutospecPriorityUpClick(Sender: TObject);
var
  item: PAutoJoinPresetItemList;
  idx : integer;
begin
  if VSTAutospecPresetList.GetFirstSelected = nil then
    Exit;
  idx := VSTAutospecPresetList.GetFirstSelected.Index;
  if idx = 0 then
    Exit;
  item := autoSpecPresetList[idx-1];
  autoSpecPresetList[idx-1] := autoSpecPresetList[idx];
  autoSpecPresetList[idx] := item;
  VSTAutospecPresetList.Refresh;
  VSTAutospecPresetList.Selected[VSTAutospecPresetList.GetFirstSelected.PrevSibling] := True;
end;

procedure TAutoJoinForm.btAutospecPriorityDownClick(Sender: TObject);
var
  item: PAutoJoinPresetItemList;
  idx : integer;
begin
  if VSTAutospecPresetList.GetFirstSelected = nil then
    Exit;
  idx := VSTAutospecPresetList.GetFirstSelected.Index;
  if idx = VSTAutospecPresetList.RootNodeCount-1 then
    Exit;
  item := autoSpecPresetList[idx+1];
  autoSpecPresetList[idx+1] := autoSpecPresetList[idx];
  autoSpecPresetList[idx] := item;
  VSTAutospecPresetList.Refresh;
  VSTAutospecPresetList.Selected[VSTAutospecPresetList.GetFirstSelected.NextSibling] := True;
end;

procedure TAutoJoinForm.btAutoplayRemovePresetClick(Sender: TObject);
var
  node: PVirtualNode;
begin
  if VSTAutoplayPresetList.GetFirstSelected = nil then
    Exit;
  autoPlayPresetList.Delete(VSTAutoplayPresetList.GetFirstSelected.Index);
  node := VSTAutoplayPresetList.GetFirstSelected.PrevSibling;
  if node = nil then
    node := VSTAutoplayPresetList.GetFirstSelected.NextSibling;
  VSTAutoplayPresetList.DeleteSelectedNodes;
  if node <> nil then
    VSTAutoplayPresetList.Selected[node] := true;
  VSTAutoplayPresetList.Refresh;
end;

procedure TAutoJoinForm.btAutospecRemovePresetClick(Sender: TObject);
var
  node: PVirtualNode;
begin
  if VSTAutospecPresetList.GetFirstSelected = nil then
    Exit;
  autoSpecPresetList.Delete(VSTAutospecPresetList.GetFirstSelected.Index);
  node := VSTAutospecPresetList.GetFirstSelected.PrevSibling;
  if node = nil then
    node := VSTAutospecPresetList.GetFirstSelected.NextSibling;
  VSTAutospecPresetList.DeleteSelectedNodes;
  if node <> nil then
    VSTAutospecPresetList.Selected[node] := true;
  VSTAutospecPresetList.Refresh;
end;

procedure TAutoJoinForm.LoadAutoJoinPreset(FileName: string);
var
  Ini : TIniFile;
  i:integer;
  newPresetItem: PAutoJoinPresetItemList;
begin
  Ini := TIniFile.Create(FileName);
  autoPlayPresetList.Clear;
  autoSpecPresetList.Clear;
  VSTAutoplayPresetList.Clear;
  VSTAutospecPresetList.Clear;
  i := 0;
  while Ini.ValueExists('AutoPlay', 'PresetName_'+IntToStr(i)) do
  begin
    New(newPresetItem);
    newPresetItem.PresetName := Ini.ReadString('AutoPlay', 'PresetName_'+IntToStr(i), 'Error');
    newPresetItem.Sorting := Ini.ReadInteger('AutoPlay', 'Sorting_'+IntToStr(i), 0);
    newPresetItem.SortingDirection := Ini.ReadInteger('AutoPlay', 'SortingDirection_'+IntToStr(i), 0);
    autoPlayPresetList.Add(newPresetItem);
    VSTAutoplayPresetList.RootNodeCount := VSTAutoplayPresetList.RootNodeCount+1;
    Inc(i);
  end;
  i := 0;
  while Ini.ValueExists('AutoSpec', 'PresetName_'+IntToStr(i)) do
  begin
    New(newPresetItem);
    newPresetItem.PresetName := Ini.ReadString('AutoSpec', 'PresetName_'+IntToStr(i), 'Error');
    newPresetItem.Sorting := Ini.ReadInteger('AutoSpec', 'Sorting_'+IntToStr(i), 0);
    newPresetItem.SortingDirection := Ini.ReadInteger('AutoSpec', 'SortingDirection_'+IntToStr(i), 0);
    autoSpecPresetList.Add(newPresetItem);
    VSTAutospecPresetList.RootNodeCount := VSTAutospecPresetList.RootNodeCount+1;
    Inc(i);
  end;
  VSTAutoplayPresetList.Refresh;
  VSTAutospecPresetList.Refresh;
end;

procedure TAutoJoinForm.SaveAutoJoinPreset(FileName: string);
var
  Ini : TIniFile;
  i:integer;
begin
  try
    if FileExists(FileName) then
      DeleteFile(FileName);
    Ini := TIniFile.Create(FileName);
    i := 0;
    for i:=0 to autoPlayPresetList.Count-1 do
    begin
      Ini.WriteString('AutoPlay', 'PresetName_'+IntToStr(i), PAutoJoinPresetItemList(autoPlayPresetList[i]).PresetName);
      Ini.WriteString('AutoPlay', 'Sorting_'+IntToStr(i), IntToStr(PAutoJoinPresetItemList(autoPlayPresetList[i]).Sorting));
      Ini.WriteString('AutoPlay', 'SortingDirection_'+IntToStr(i), IntToStr(PAutoJoinPresetItemList(autoPlayPresetList[i]).SortingDirection));
    end;
    for i:=0 to autoSpecPresetList.Count-1 do
    begin
      Ini.WriteString('AutoSpec', 'PresetName_'+IntToStr(i), PAutoJoinPresetItemList(autoSpecPresetList[i]).PresetName);
      Ini.WriteString('AutoSpec', 'Sorting_'+IntToStr(i), IntToStr(PAutoJoinPresetItemList(autoSpecPresetList[i]).Sorting));
      Ini.WriteString('AutoSpec', 'SortingDirection_'+IntToStr(i), IntToStr(PAutoJoinPresetItemList(autoSpecPresetList[i]).SortingDirection));
    end;
  except
    MainForm.AddMainLog('Error: Can''t write the autojoin settings.',Colors.Error);
  end;
end;

procedure TAutoJoinForm.btSavePresetClick(Sender: TObject);
begin
  if lstPresetList.Items.IndexOf(txtPresetName.Text) >= 0 then
  begin
    if MessageDlg(_('A preset with this name already exists, do you want to replace it ?'),mtWarning,[mbYes, mbNo],0) = mrNo then
      Exit;
    lstPresetList.ItemIndex := lstPresetList.Items.IndexOf(txtPresetName.Text);
  end
  else
  begin
    lstPresetList.Items.Add(txtPresetName.Text);
    lstPresetList.ItemIndex := lstPresetList.Count-1;
  end;

  SaveAutoJoinPreset(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\'+txtPresetName.Text+'.ini');
end;

procedure TAutoJoinForm.btDeletePresetClick(Sender: TObject);
begin
  if lstPresetList.ItemIndex = 0 then Exit;
  DeleteFile(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\' + lstPresetList.Items[lstPresetList.ItemIndex] + '.ini');
  lstPresetList.Items.Delete(lstPresetList.ItemIndex);
  lstPresetList.Selected[0] := true;
end;

procedure TAutoJoinForm.btClearPresetsClick(Sender: TObject);
var
  i:integer;
begin
  for i:=lstPresetList.Count-1 downto 1 do
  begin
    DeleteFile(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\' + lstPresetList.Items[i] + '.ini');
    lstPresetList.Items.Delete(i);
  end;
  lstPresetList.Selected[0] := true;
end;

procedure TAutoJoinForm.lstPresetListClick(Sender: TObject);
begin
  if (lstPresetList.ItemIndex = 0) then Exit;
  txtPresetName.Text := lstPresetList.Items[lstPresetList.ItemIndex]
end;

procedure TAutoJoinForm.lstPresetListDblClick(Sender: TObject);
begin
  if (lstPresetList.ItemIndex = 0) or not FileExists(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\' + lstPresetList.Items[lstPresetList.ItemIndex] + '.ini') then Exit;
  LoadAutoJoinPreset(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\' + lstPresetList.Items[lstPresetList.ItemIndex] + '.ini');
  VSTAutoplayPresetList.Refresh;
  VSTAutospecPresetList.Refresh;
end;

procedure TAutoJoinForm.LoadAutoJoinPresets;
var
  FileAttrs: Integer;
  sr: TSearchRec;
begin
  FileAttrs := faAnyFile;
  if FindFirst(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\*.ini', FileAttrs, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') and (sr.Name <> 'current.ini') then
      begin
        lstPresetList.Items.Add(LeftStr(''+sr.Name,Length(''+sr.Name)-4));
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TAutoJoinForm.initPresets;
begin
  autoPlayPresetList := TList.Create;
  autoSpecPresetList := TList.Create;

  LoadAutoJoinPreset(ExtractFilePath(Application.ExeName) + AUTOJOIN_PRESETS_FOLDER + '\current.ini');
  lstPresetList.Selected[0] := true;
  LoadAutoJoinPresets;
end;

procedure TAutoJoinForm.VSTAutoplayPresetListDrawText(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; const Text: WideString; const CellRect: TRect;
  var DefaultDraw: Boolean);
begin
  MainForm.FilterListDrawText(Sender,TargetCanvas,Node,Column,Text,CellRect,DefaultDraw);
end;

procedure TAutoJoinForm.VSTAutospecPresetListDrawText(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; const Text: WideString; const CellRect: TRect;
  var DefaultDraw: Boolean);
begin
  MainForm.FilterListDrawText(Sender,TargetCanvas,Node,Column,Text,CellRect,DefaultDraw);
end;

procedure TAutoJoinForm.VSTAutoplayPresetListHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

procedure TAutoJoinForm.VSTAutospecPresetListHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

procedure TAutoJoinForm.VSTAutospecPresetListPaintText(
  Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  TargetCanvas.Font.Style := [];
  inherited;
end;

procedure TAutoJoinForm.VSTAutoplayPresetListPaintText(
  Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  TargetCanvas.Font.Style := [];
  inherited;
end;

end.



