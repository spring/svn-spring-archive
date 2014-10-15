{
  Perhaps it would be good to sort units?
  See this methods (TVirtualDrawTree):
  Sort
  SortTree
  OnCompareNodes

}
unit DisableUnitsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, StdCtrls, Buttons, SpTBXControls,SpTBXSkins,
  SpTBXItem,Misc,ExtCtrls;

type
  TDisableUnitsForm = class(TForm)
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    SpTBXTitleBar1: TSpTBXTitleBar;
    pnlMain: TSpTBXPanel;
    SpeedButton2: TSpTBXSpeedButton;
    SpeedButton3: TSpTBXSpeedButton;
    SpeedButton1: TSpTBXSpeedButton;
    VDTUnits: TVirtualDrawTree;
    Button1: TSpTBXButton;
    Button2: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure LoadSelectionFromFile(FileName: string);
    procedure SaveSelectionToFile(FileName: string);

    procedure VDTUnitsInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VDTUnitsDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure VDTUnitsColumnResize(Sender: TVTHeader;
      Column: TColumnIndex);
    procedure VDTUnitsCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VDTUnitsHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
    procedure VDTUnitsHeaderDraw(Sender: TVTHeader; HeaderCanvas: TCanvas;
      Column: TVirtualTreeColumn; R: TRect; Hover, Pressed: Boolean;
      DropMark: TVTDropMarkMode);
  private
    { Private declarations }
  public
    procedure PopulateUnitList;
  end;

var
  DisableUnitsForm: TDisableUnitsForm;

implementation

uses
  Utility, PreferencesFormUnit, BattleFormUnit, MainUnit, gnugettext;

{$R *.dfm}

procedure TDisableUnitsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TDisableUnitsForm.VDTUnitsInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  Node.Dummy := 0; // we use dummy to store selection status. See VirtualTreeView's docs on what Dummy actually is
end;

procedure TDisableUnitsForm.VDTUnitsDrawNode(Sender: TBaseVirtualTree;const PaintInfo: TVTPaintInfo);
var
  s: WideString;
  R: TRect;
  availableWidth: integer;
  availableHeight: integer;
  forceWidth: integer;
  forceHeight: integer;
  nodeIndex : integer;
  BgRect: TRect;
  pt: TPoint;
  hot: Boolean;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
  CheckboxRect: TRect;
begin
  with Sender as TVirtualDrawTree, PaintInfo do
  begin
    nodeIndex := UnitNodes.IndexOf(Node);

    GetCursorPos(pt);
    pt := ScreenToClient(pt);
    GetHitTestInfoAt(pt.X,pt.Y,True,hi);

    hot := (SkinManager.GetSkinType=sknSkin) and DisableUnitsForm.Active and (hi.HitNode = Node);

    CopyRect(BgRect,CellRect);
    {if Position <> 0 then
      BgRect.Left := -5;
    if Position <> Header.Columns.Count-1 then
      BgRect.Right := BgRect.Right+5;}

    if SkinManager.GetSkinType=sknSkin then
    begin
      itemState := SkinManager.CurrentSkin.GetState(True,False,hot,(Node = FocusedNode) and focused);
      Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,itemState);
      SkinManager.CurrentSkin.PaintBackground(Canvas,BgRect,skncListItem,itemState,True,True);
      Canvas.Brush.Style := Graphics.bsClear;
    end
    else if (Node = FocusedNode) and focused then
    begin
      Canvas.Font.Color := clHighlightText;
      Canvas.Brush.Color := clHighlight;
      Canvas.FillRect(CellRect);
    end
    else
      Canvas.Font.Color := clWindowText;

    if Header.Columns[Column].CheckBox and (SkinManager.GetSkinType=sknSkin) then
    begin
      CopyRect(CheckboxRect,Canvas.ClipRect);
      InflateRect(CheckboxRect,-3,-3);
      SkinManager.CurrentSkin.PaintBackground(Canvas,CheckboxRect,skncCheckBox,itemState,True,True);
      if (Node.CheckState = csCheckedNormal) then
        SkinManager.CurrentSkin.PaintMenuCheckMark(Canvas,CheckboxRect,True,False,False,itemState);
    end;

    R := ContentRect;
    if Column <> 1 then
    begin
      InflateRect(R, -TextMargin, 0);
      Dec(R.Right);
      Dec(R.Bottom);
    end;
    s := '';

    case Column of
      0: ; // enabled
      1:
      begin
        if Preferences.DisplayUnitsIconsAndNames then
        if TBitmap(UnitBitmaps[Node.Index]).Width > 0 then
        begin
          availableWidth := R.Right-R.Left;
          availableHeight := R.Bottom-R.Top;
          if TBitmap(UnitBitmaps[nodeIndex]).Width > 0 then
          begin
            forceHeight := Round(availableWidth*TBitmap(UnitBitmaps[nodeIndex]).Height/TBitmap(UnitBitmaps[nodeIndex]).Width);
            forceWidth := Round(availableHeight*TBitmap(UnitBitmaps[nodeIndex]).Width/TBitmap(UnitBitmaps[nodeIndex]).Height);

            if ((TBitmap(UnitBitmaps[nodeIndex]).Width > TBitmap(UnitBitmaps[nodeIndex]).Height) and (forceHeight < availableHeight)) or (forceWidth > availableWidth) then
              Canvas.StretchDraw(Rect(R.Left,R.Top,R.Right,R.Top+forceHeight),TBitmap(UnitBitmaps[nodeIndex]))
            else
              Canvas.StretchDraw(Rect(R.Left,R.Top,R.Left+forceWidth,R.Bottom),TBitmap(UnitBitmaps[nodeIndex]));
          end;
        end;
      end;
      2: s := UnitNames[nodeIndex]; // unit name
      3: s := UnitList[nodeIndex]; // unit "code name"
    end; // case

    if Length(s) > 0 then
    begin
       with R do
         if (NodeWidth - 2 * Margin) > (Right - Left) then
           s := ShortenString(Canvas.Handle, s, Right - Left, 0);
       DrawTextW(Canvas.Handle, PWideChar(S), Length(S), R, DT_TOP or DT_LEFT or DT_VCENTER or DT_SINGLELINE, False);
 //     Canvas.TextOut(ContentRect.Left, ContentRect.Top, s);
    end;
  end;

end;

procedure TDisableUnitsForm.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TDisableUnitsForm.Button2Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TDisableUnitsForm.SpeedButton1Click(Sender: TObject);
var
  i: Integer;
begin
  // the simplest way to clear all checkboxes is to clear all nodes :)
  PopulateUnitList;
end;

procedure TDisableUnitsForm.LoadSelectionFromFile(FileName: string);
var
  f: TextFile;
  Selection: TStringList;
  s: string;
  node: PVirtualNode;
  i: Integer;
  index: Integer;
begin

  Selection := TStringList.Create;

  {$I+}
  try

    AssignFile(f, FileName);
    Reset(f);

    while not Eof(f) do
    begin
      Readln(f, s);
      Selection.Add(s);
    end;

    CloseFile(f);

    // now let's check if we have all the units:
    for i := 0 to Selection.Count - 1 do
      if UnitList.IndexOf(Selection[i]) = -1 then
      begin
        MessageDlg(_('Error loading selection: this selection contains units which are not on your unit list. Make sure you are using the right mod!'), mtError, [mbOK], 0);
        Selection.Free;
        Exit;
      end;

    // let's select the units (this will take O(m*n) since we don't keep pointers to the nodes ... but nevermind):
    // but first let's clear current selection:
    //VDTUnits.RootNodeCount := i;
    DisableUnitsForm.PopulateUnitList;

    // mark units:
    for i := 0 to Selection.Count-1 do
    begin
      index := UnitList.IndexOf(Selection[i]);
      node := UnitNodes[index];
      node.CheckState := csCheckedNormal;
    end;

  except
    MessageDlg(_('Error: unable to access file: ') + FileName, mtError, [mbOK], 0);
  end;

  Selection.Free;
end;

procedure TDisableUnitsForm.SaveSelectionToFile(FileName: string);
var
  f: TextFile;
  node: PVirtualNode;
  i: Integer;

begin

  {$I+}
  try

    AssignFile(f, FileName);
    Rewrite(f);

    for i:=0 to UnitNodes.Count-1 do
      if (PVirtualNode(UnitNodes[i]).CheckState = csCheckedNormal) or (PVirtualNode(UnitNodes[i]).CheckState = csCheckedPressed) then
        Writeln(f, UnitList[i]);

    CloseFile(f);

  except
    MessageDlg(_('Error: unable to access file: ') + FileName, mtError, [mbOK], 0);
  end;

end;


procedure TDisableUnitsForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  FixFormSizeConstraints(DisableUnitsForm);
  SaveDialog1.InitialDir := ExtractFilePath(Application.ExeName) + VAR_FOLDER;
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName) + VAR_FOLDER;
end;

procedure TDisableUnitsForm.SpeedButton2Click(Sender: TObject);
begin
  if not SaveDialog1.Execute then Exit;
  SaveSelectionToFile(SaveDialog1.FileName);
end;

procedure TDisableUnitsForm.SpeedButton3Click(Sender: TObject);
begin
  if not OpenDialog1.Execute then Exit;
  LoadSelectionFromFile(OpenDialog1.FileName);
end;

procedure TDisableUnitsForm.VDTUnitsColumnResize(Sender: TVTHeader;
  Column: TColumnIndex);
var
  Node: PVirtualNode;
begin
  if Column = 1 then
  begin
    VDTUnits.DefaultNodeHeight := VDTUnits.Header.Columns[1].Width;
    Node := VDTUnits.GetFirst;
    while Node <> nil do
    begin
      VDTUnits.NodeHeight[Node] := VDTUnits.Header.Columns[1].Width;
      Node.TotalHeight := VDTUnits.Header.Columns[1].Width;
      Node := VDTUnits.GetNext(Node);
    end;
  end;
end;

procedure TDisableUnitsForm.PopulateUnitList;
var
  i: integer;
  node: PVirtualNode;
begin
  VDTUnits.Clear;
  UnitNodes.Clear;
  VDTUnits.BeginUpdate;

  VDTUnits.RootNodeCount := UnitList.Count;
  node := VDTUnits.GetFirst;
  for i:=0 to UnitList.Count-1 do
  begin
    if UnitNodes.IndexOf(node) = -1 then
      UnitNodes.Add(node);
    node := VDTUnits.GetNext(node);
  end;

  VDTUnits.EndUpdate;
end;

procedure TDisableUnitsForm.VDTUnitsCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  node1Index: integer;
  node2Index: integer;
begin
  node1Index := UnitNodes.IndexOf(Node1);
  node2Index := UnitNodes.IndexOf(Node2);

    case Column of
      0:
        if Node1.CheckState = Node2.CheckState  then
          Result := 0
        else if Node1.CheckState = csCheckedNormal then
          Result := -1
        else
          Result := 1;
      1:;
      2:Result := CompareStr(UnitNames[node1Index],UnitNames[node2Index]);
      3:Result := CompareStr(UnitList[node1Index],UnitList[node2Index]);
    end;
end;

procedure TDisableUnitsForm.VDTUnitsHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if VDTUnits.Header.SortColumn = HitInfo.Column then
    if VDTUnits.Header.SortDirection = sdDescending then
      VDTUnits.Header.SortDirection := sdAscending
    else
      VDTUnits.Header.SortDirection := sdDescending
  else
  begin
    VDTUnits.Header.SortColumn := HitInfo.Column;
    VDTUnits.Header.SortDirection := sdAscending
  end;
end;

procedure TDisableUnitsForm.VDTUnitsHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

end.
