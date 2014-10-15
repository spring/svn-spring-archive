unit AddBotUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, SpTBXControls, SpTBXEditors,SpTBXSkins,
  TntStdCtrls, SpTBXItem, VirtualTrees, Menus, TB2Item, Clipbrd;

type
  TAIItem =
  record
    keys: TStringList;
    values: TStringList;
    descriptions: TStringList;
    nodes: TList;
    mainNode: PVirtualNode;
  end;
  PAIItem = ^TAIItem;
  TAddBotForm = class(TForm)
    AIListPopupMenu: TSpTBXPopupMenu;
    mnuCopyItem: TSpTBXItem;
    mnuGotoUrl: TSpTBXItem;
    ColorPopupMenu: TSpTBXPopupMenu;
    mnuTeamColorPalette: TSpTBXColorPalette;
    mnuTeamColorCustomize: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    mnuTeamColorCancel: TSpTBXItem;
    SpTBXTitleBar1: TSpTBXTitleBar;
    pnlMain: TSpTBXPanel;
    Label1: TSpTBXLabel;
    ReloadButton: TSpTBXSpeedButton;
    VSTAIList: TVirtualStringTree;
    Label2: TSpTBXLabel;
    BotNameEdit: TSpTBXEdit;
    Label3: TSpTBXLabel;
    Label4: TSpTBXLabel;
    BotAllyButton: TSpTBXSpinEdit;
    BotTeamButton: TSpTBXSpinEdit;
    BotSideButton: TSpTBXSpeedButton;
    BotTeamColorButton: TSpTBXSpeedButton;
    AddBotButton: TSpTBXButton;
    Button2: TSpTBXButton;

    procedure ChangeSide(SideIndex: Integer);

    procedure ReloadButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure AddBotButtonClick(Sender: TObject);
    //procedure BotTeamColorButtonClick(Sender: TObject);
    procedure BotTeamButtonClick(Sender: TObject);
    procedure BotAllyButtonClick(Sender: TObject);
    procedure BotSideButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VSTAIListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VSTAIListGetHint(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex;
      var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
    procedure mnuCopyItemClick(Sender: TObject);
    procedure mnuGotoUrlClick(Sender: TObject);
    procedure AIListPopupMenuPopup(Sender: TObject);
    procedure VSTAIListHeaderDraw(Sender: TVTHeader; HeaderCanvas: TCanvas;
      Column: TVirtualTreeColumn; R: TRect; Hover, Pressed: Boolean;
      DropMark: TVTDropMarkMode);
    procedure mnuTeamColorCustomizeClick(Sender: TObject);
    procedure mnuTeamColorPaletteCellClick(Sender: TObject; ACol,
      ARow: Integer; var Allow: Boolean);
    procedure mnuTeamColorPaletteGetColor(Sender: TObject; ACol,
      ARow: Integer; var Color: TColor; var Name: WideString);
    procedure VSTAIListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure VSTAIListDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: WideString; const CellRect: TRect;
      var DefaultDraw: Boolean);
  private
  public
    aiList: TList;
    function getSelectedAI: PAIItem;
  end;

var
  AddBotForm: TAddBotForm;
  BotColor: TColor;

implementation

uses
  MainUnit, Misc, BattleFormUnit, PreferencesFormUnit, Utility, gnugettext,
  StrUtils;

{$R *.dfm}

procedure TAddBotForm.ReloadButtonClick(Sender: TObject);
var
  i,j: integer;
  newAI : PAIItem;
  oldSelection: integer;
begin
  oldSelection := -1;
  for i:=0 to aiList.Count-1 do
    if VSTAIList.Selected[PAIItem(aiList[i]).mainNode] then
    begin
      oldSelection := i;
      break;
    end
    else
      for j:=0 to PAIItem(aiList[i]).nodes.Count-1 do
        if VSTAIList.Selected[PAIItem(aiList[i]).nodes[j]] then
        begin
          oldSelection := i;
          break;
        end;

  VSTAIList.Clear;
  for i:=0 to aiList.Count-1 do
  begin
    PAIItem(aiList[i]).keys.Free;
    PAIItem(aiList[i]).values.Free;
    PAIItem(aiList[i]).descriptions.Free;
    PAIItem(aiList[i]).nodes.Free;
  end;
  aiList.Clear;

  for i:=0 to Utility.GetSkirmishAICount-1 do
  begin
    New(newAI);
    newAI.nodes := TList.Create;
    newAI.keys := TStringList.Create;
    newAI.values := TStringList.Create;
    newAI.descriptions := TStringList.Create;
    newAI.mainNode := VSTAIList.AddChild(VSTAIList.RootNode);
    if oldSelection = i then
      VSTAIList.Selected[newAI.mainNode] := True;
    for j:=0 to Utility.GetSkirmishAIInfoCount(i)-1 do
    begin
      newAI.nodes.Add(VSTAIList.AddChild(newAI.mainNode));
      newAI.keys.Add(Utility.GetInfoKey(j));
      newAI.values.Add(Utility.GetInfoValue(j));
      newAI.descriptions.Add(Utility.GetInfoDescription(j));
    end;
    aiList.Add(newAI);
  end;
  AddBotButton.Enabled := aiList.Count > 0;
end;

procedure TAddBotForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  BotSideButton.Images := Utility.SideImageList;
  BotAllyButton.SpinOptions.MaxValue := MAX_TEAMS;
  BotTeamButton.SpinOptions.MaxValue := MAX_TEAMS;
  aiList := TList.Create;
end;

procedure TAddBotForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TAddBotForm.AddBotButtonClick(Sender: TObject);
var
  Bot: TBot;
  BattleStatus: Integer;
  botIdx : integer;
begin
  if VSTAIList.GetFirstSelected = nil then Exit;
  if not Misc.VerifyName(BotNameEdit.Text) then
  begin
    MessageDlg(_('Bad name. Please choose another one!'), mtInformation, [mbOK], 0);
    Exit;
  end;

  Bot := TBot.Create('', '', '');
  Bot.SetSide(BotSideButton.Tag);
  Bot.SetTeamNo(BotTeamButton.SpinOptions.ValueAsInteger-1);
  Bot.SetAllyNo(BotAllyButton.SpinOptions.ValueAsInteger-1);
  Bot.SetHandicap(0);
  BattleStatus := Bot.BattleStatus;
  Bot.Free;

  MainForm.TryToSendCommand('ADDBOT', BotNameEdit.Text + ' ' + IntToStr(BattleStatus) + ' ' + IntToStr(BotColor) + ' ' + getSelectedAI.values[getSelectedAI.keys.IndexOf('shortname')]);

  Close;
end;

procedure TAddBotForm.ChangeSide(SideIndex: Integer);
begin
  BotSideButton.Caption := SideList[SideIndex];
  BotSideButton.ImageIndex := SideIndex;
  BotSideButton.Tag := SideIndex;
end;

{procedure TAddBotForm.BotTeamColorButtonClick(Sender: TObject);
var
  ColorIndex: Integer;
begin
  ColorIndex := BattleForm.ChooseColorDialog(BotTeamColorButton, BotColorIndex);
  if ColorIndex = -1 then Exit;

  ChangeTeamColor(ColorIndex);
end;}

procedure TAddBotForm.BotTeamButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := BattleForm.ChooseNumberDialog(Sender as TControl, BotTeamButton.SpinOptions.ValueAsInteger-1);
  if Index = -1 then Exit;

  BotTeamButton.SpinOptions.ValueAsInteger := Index+1;
end;

procedure TAddBotForm.BotAllyButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := BattleForm.ChooseNumberDialog(Sender as TControl, BotAllyButton.SpinOptions.ValueAsInteger-1);
  if Index = -1 then Exit;

  BotAllyButton.SpinOptions.ValueAsInteger := Index+1;
end;

procedure TAddBotForm.BotSideButtonClick(Sender: TObject);
var
  SideIndex: Integer;
begin
  SideIndex := BattleForm.ChooseSideDialog(Sender as TControl, BotSideButton.Tag);
  if SideIndex = -1 then Exit;

  ChangeSide(SideIndex);
end;

procedure TAddBotForm.FormShow(Sender: TObject);
begin
  ReloadButton.OnClick(nil);
  BotTeamColorButton.ImageIndex := Length(TeamColors)*2;
end;

procedure TAddBotForm.VSTAIListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  i,j,k:integer;
begin
  CellText := 'Loading ...';
  for i:=0 to aiList.Count-1 do
    if PAIItem(aiList[i]).mainNode = Node then
    begin
      k := PAIItem(aiList[i]).keys.IndexOf('shortname');
      CellText := PAIItem(aiList[i]).values[k];
      k := PAIItem(aiList[i]).keys.IndexOf('name');
      if k >= 0 then
        CellText := CellText + ': '+ PAIItem(aiList[i]).values[k];
      Exit;
    end
    else
      for j:=0 to PAIItem(aiList[i]).nodes.Count-1 do
        if PAIItem(aiList[i]).nodes[j] = Node then
        begin
          CellText := PAIItem(aiList[i]).keys[j] + ' = ' + PAIItem(aiList[i]).values[j];
          Exit;
        end;
end;

function TAddBotForm.getSelectedAI: PAIItem;
var
  i,j,k:integer;
begin
  Result := nil;
  for i:=0 to aiList.Count-1 do
    if PAIItem(aiList[i]).mainNode = VSTAIList.GetFirstSelected then
    begin
      Result := aiList[i];
      Exit;
    end
    else
      for j:=0 to PAIItem(aiList[i]).nodes.Count-1 do
        if PAIItem(aiList[i]).nodes[j] = VSTAIList.GetFirstSelected then
        begin
          Result := aiList[i];
          Exit;
        end;
end;

procedure TAddBotForm.VSTAIListGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
  i,j,k:integer;
begin
  LineBreakStyle :=hlbDefault;
  HintText := 'Loading ...';
  for i:=0 to aiList.Count-1 do
    if PAIItem(aiList[i]).mainNode = Node then
    begin
      k := PAIItem(aiList[i]).keys.IndexOf('shortname');
      HintText := PAIItem(aiList[i]).values[k];
      k := PAIItem(aiList[i]).keys.IndexOf('name');
      if k >= 0 then
        HintText := HintText + ': '+ PAIItem(aiList[i]).values[k];
      Exit;
    end
    else
      for j:=0 to PAIItem(aiList[i]).nodes.Count-1 do
        if PAIItem(aiList[i]).nodes[j] = Node then
        begin
          HintText := PAIItem(aiList[i]).descriptions[j];
          Exit;
        end;
end;

procedure TAddBotForm.mnuCopyItemClick(Sender: TObject);
var
  celltxt: WideString;
  tt: TVSTTextType;
begin
  VSTAIListGetText(VSTAIList,VSTAIList.GetFirstSelected,0,tt,celltxt);
  Clipboard.AsText := celltxt;
end;

procedure TAddBotForm.mnuGotoUrlClick(Sender: TObject);
var
  celltxt: WideString;
  tt: TVSTTextType;
begin
  VSTAIListGetText(VSTAIList,VSTAIList.GetFirstSelected,0,tt,celltxt);
  celltxt := MidStr(celltxt,Pos('http://',LowerCase(celltxt)),900000);
  Misc.OpenURLInDefaultBrowser(celltxt);
end;

procedure TAddBotForm.AIListPopupMenuPopup(Sender: TObject);
var
  celltxt: WideString;
  tt: TVSTTextType;
begin
  VSTAIListGetText(VSTAIList,VSTAIList.GetFirstSelected,0,tt,celltxt);
  mnuGotoUrl.Visible := Pos('http://',LowerCase(celltxt)) > 0;
end;

procedure TAddBotForm.VSTAIListHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

procedure TAddBotForm.mnuTeamColorCustomizeClick(Sender: TObject);
begin
  BotColor := Misc.InputColor('Bot color',BotColor);
  MainForm.UpdateColorImageList;
end;

procedure TAddBotForm.mnuTeamColorPaletteCellClick(Sender: TObject; ACol,
  ARow: Integer; var Allow: Boolean);
begin
  BotColor := TeamColors[ARow*5+ACol];
  MainForm.UpdateColorImageList;  
end;

procedure TAddBotForm.mnuTeamColorPaletteGetColor(Sender: TObject; ACol,
  ARow: Integer; var Color: TColor; var Name: WideString);
begin
  Color := TeamColors[ARow*5+ACol];
end;

procedure TAddBotForm.VSTAIListPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Style := [];
  inherited;
end;

procedure TAddBotForm.VSTAIListDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: WideString; const CellRect: TRect; var DefaultDraw: Boolean);
var
  PaintRect: TRect;
  CheckboxRect: TRect;
  hot: Boolean;
  pt: TPoint;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
begin
  DefaultDraw := True;
  if (SkinManager.GetSkinType=sknSkin) then
  begin
    with (Sender as TVirtualStringTree) do
    begin
      GetCursorPos(pt);
      pt := ScreenToClient(pt);
      GetHitTestInfoAt(pt.X,pt.Y,True,hi);
      hot := Misc.GetControlForm(Sender).Active and (hi.HitNode = Node);

      CopyRect(PaintRect,TargetCanvas.ClipRect);
      {if Header.Columns[Column].Position <> 0 then
        PaintRect.Left := PaintRect.Left - 3;
      if Header.Columns[Column].Position <> Header.Columns.Count-1 then
        PaintRect.Right := PaintRect.Right + 3;}

      if (Column > -1) and Header.Columns[Column].CheckBox then
        TargetCanvas.FillRect(TargetCanvas.ClipRect);

      itemState := SkinManager.CurrentSkin.GetState(True,False,hot,Selected[Node]);
      SkinManager.CurrentSkin.PaintBackground(TargetCanvas,PaintRect,skncListItem,itemState,True,True);
      TargetCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,itemState);
      if (Column > -1) and Header.Columns[Column].CheckBox then
      begin
        CopyRect(CheckboxRect,TargetCanvas.ClipRect);
        InflateRect(CheckboxRect,-3,-3);
        SkinManager.CurrentSkin.PaintBackground(TargetCanvas,CheckboxRect,skncCheckBox,itemState,True,True);
        if (Node.CheckState = csCheckedNormal) then
          SkinManager.CurrentSkin.PaintMenuCheckMark(TargetCanvas,CheckboxRect,True,False,False,itemState);
      end;
      TargetCanvas.Brush.Style := Graphics.bsClear;
    end;
  end;
end;

end.
