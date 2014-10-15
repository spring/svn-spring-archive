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
  Dialogs, VirtualTrees, StdCtrls, Buttons, SpTBXControls, TBXDkPanels,
  SpTBXItem;

type
  TDisableUnitsForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    Label1: TSpTBXLabel;
    SpeedButton1: TSpTBXSpeedButton;
    SpeedButton2: TSpTBXSpeedButton;
    SpeedButton3: TSpTBXSpeedButton;
    Button1: TSpTBXButton;
    VDTUnits: TVirtualDrawTree;
    Button2: TSpTBXButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DisableUnitsForm: TDisableUnitsForm;

implementation

uses
  Utility, PreferencesFormUnit, BattleFormUnit, Unit1;

{$R *.dfm}

procedure TDisableUnitsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

procedure TDisableUnitsForm.VDTUnitsInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  Node.Dummy := 0; // we use dummy to store selection status. See VirtualTreeView's docs on what Dummy actually is
end;

procedure TDisableUnitsForm.VDTUnitsDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  s: WideString;
  R: TRect;

begin
  with Sender as TVirtualDrawTree, PaintInfo do
  begin

    if (Node = FocusedNode) and Focused then
      Canvas.Font.Color := clHighlightText
    else
      Canvas.Font.Color := clWindowText;

    R := ContentRect;
    InflateRect(R, -TextMargin, 0);
    Dec(R.Right);
    Dec(R.Bottom);
    s := '';

    case Column of
      0: ; // enabled
      1: s := UnitNames[Node.Index]; // unit name
      2: s := UnitList[Node.Index]; // unit "code name"
    end; // case

    if Length(s) > 0 then
    begin
       with R do
         if (NodeWidth - 2 * Margin) > (Right - Left) then
           s := ShortenString(Canvas.Handle, s, Right - Left, False);
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

  i := VDTUnits.RootNodeCount;
  VDTUnits.RootNodeCount := 0;
  VDTUnits.RootNodeCount := i;
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
        MessageDlg('Error loading selection: this selection contains units which are not on your unit list. Make sure you are using the right mod!', mtError, [mbOK], 0);
        Selection.Free;
        Exit;
      end;

    // let's select the units (this will take O(m*n) since we don't keep pointers to the nodes ... but nevermind):
    // but first let's clear current selection:
    i := VDTUnits.RootNodeCount;
    VDTUnits.RootNodeCount := 0;
    VDTUnits.RootNodeCount := i;
    // mark units:
    for i := 0 to Selection.Count-1 do
    begin
      index := UnitList.IndexOf(Selection[i]);
      node := VDTUnits.GetFirst;
      while index > 0 do
      begin
        node := node.NextSibling;
        Dec(Index);
      end;

      node.CheckState := csCheckedNormal;
    end;

  except
    MessageDlg('Error: unable to access file: ' + FileName, mtError, [mbOK], 0);
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

    i := 0;
    node := VDTUnits.GetFirst;
    while node <> nil do
    begin
      if (node.CheckState = csCheckedNormal) or (node.CheckState = csCheckedPressed) then
        Writeln(f, UnitList[i]);

      node := node.NextSibling;
      Inc(i);
    end;

    CloseFile(f);

  except
    MessageDlg('Error: unable to access file: ' + FileName, mtError, [mbOK], 0);
  end;

end;


procedure TDisableUnitsForm.FormCreate(Sender: TObject);
begin
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

end.
