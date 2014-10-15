unit CustomizeGUIFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, StdCtrls, TntStdCtrls, SpTBXEditors, SpTBXControls,
  TntForms, Buttons, Grids, ValEdit, Menus, SpTBXFormPopupMenu,
  LobbyScriptUnit, ComCtrls, SpTBXTabs, STXControlResizer,Clipbrd, OpenIL,GR32,
  TntWideStrings, SpTBXDkPanels, SpTBXItem,DockPanel;

type
  TProperty = class
    protected
      FValue: Variant;
      FName: string;
      FObject: TObject;

      procedure ValueChanged(v: Variant);virtual;

    public
      constructor Create(name: string;value: Variant; obj: TObject);

      property Value:Variant read FValue write ValueChanged;
      property Name:string read FName;
      property Obj: TObject read FObject;

      procedure AddToList(l: TValueListEditor);
      procedure OnEdit;virtual;
  end;

  TEnumerationProperty = class(TProperty)
    public
      procedure AddToList(l: TValueListEditor);
  end;

  TSetProperty = class(TProperty)
    public
      procedure AddToList(l: TValueListEditor);
      procedure OnEdit;override;
      procedure ChangeValue(v: string);
  end;

  TStringsProperty = class(TProperty)
    protected
      FStrings: TWideStrings;
    public
      constructor Create(name: string;value: TWideStrings; obj: TObject);
      procedure AddToList(l: TValueListEditor);
      procedure OnEdit;override;
      procedure ChangeValue(v: TWideStrings);
  end;

  TClassProperty = class(TProperty)
    protected
      FValueObj: TObject;
    public
      constructor Create(name: string;value: TObject; obj: TObject);
      procedure AddToList(l: TValueListEditor);
      procedure OnEdit;override;
  end;

  TBitmap32Property = class(TProperty)
    protected
      FBmp32Obj: TBitmap32;
    public
      constructor Create(name: string;value: TBitmap32; obj: TObject);
      procedure AddToList(l: TValueListEditor);
      procedure OnEdit;override;
      procedure LoadNewPicture(Sender: TObject);
      procedure ShowProperties(Sender: TObject);
  end;

  TColorProperty = class(TProperty)
    public
      procedure AddToList(l: TValueListEditor);
      procedure OnEdit;override;
  end;

  TPictureProperty = class(TProperty)
    protected
      FPictObj: TPicture;
      procedure ValueChanged(v: Variant);override;
    public
      constructor Create(name: string;pictObj: TPicture; obj: TObject);
      procedure AddToList(l: TValueListEditor);
      procedure OnEdit;override;
  end;

  TBitmapProperty = class(TProperty)
    protected
      FBitmapObj: TBitmap;
      procedure ValueChanged(v: Variant);override;
    public
      constructor Create(name: string;bmpObj: TBitmap; obj: TObject);
      procedure AddToList(l: TValueListEditor);
      procedure OnEdit;override;
  end;

  THistoryItem = class
    public
      function getPythonCode(saveType: integer): string; virtual; abstract;
      procedure Revert; virtual; abstract;
  end;
  THistoryItemProperty = class(THistoryItem)
    public
      FPropName: string;
      FPropOldValue: Variant;
      FPropNewValue: Variant;
      FObject : TObject;
      FControl: TControl;
      FSubProp: string;
      FDblQuoteResult: Boolean;

      constructor Create(p: TProperty; newValue: Variant; subP: string; c: TControl; dblQuoteResult : boolean = False);
      function getPythonCode(saveType: integer): string; override;
      procedure Revert; override;
  end;
  THistoryItemControl = class(THistoryItem)
    protected
      FControl: TControl;
    public
      constructor Create(control: TControl);
      function getPythonCode(saveType: integer): string; override;
      procedure Revert; override;
  end;
  THistoryItemForm = class(THistoryItem)
    protected
      FForm: TCustomForm;
      FDockableForm: String;
    public
      constructor Create(form: TCustomForm;dockableForm:boolean);
      function getPythonCode(saveType: integer): string; override;
      procedure Revert; override;
  end;
  THistoryItemTab = class(THistoryItem)
    protected
      FTabSheet: TSpTBXTabSheet;
      FTabControl: TSpTBXTabControl;
    public
      constructor Create(tabSheet: TSpTBXTabSheet; tabControl: TSpTBXTabControl);
      function getPythonCode(saveType: integer): string; override;
      procedure Revert; override;
  end;

  TCustomizeGUIForm = class(TForm)
    ControlsPanel: TSpTBXPanel;
    VDTControls: TVirtualStringTree;
    VerticalSplitter: TSpTBXSplitter;
    FormsPanel: TSpTBXPanel;
    FormSelectionComboBox: TSpTBXComboBox;
    RefreshFormListButton: TSpTBXButton;
    PropertiesScrollBox: TTntScrollBox;
    PropertiesListEditor: TValueListEditor;
    SetValuesPopupMenu: TSpTBXFormPopupMenu;
    TopMenu: TMainMenu;
    File1: TMenuItem;
    PickButton: TSpTBXButton;
    Add1: TMenuItem;
    Form1: TMenuItem;
    abs1: TMenuItem;
    ab1: TMenuItem;
    Panel1: TMenuItem;
    Control1: TMenuItem;
    Move1: TMenuItem;
    Delete1: TMenuItem;
    Control2: TMenuItem;
    InputBox1: TMenuItem;
    Label1: TMenuItem;
    CheckBox1: TMenuItem;
    Radio1: TMenuItem;
    Button1: TMenuItem;
    ProgressBar1: TMenuItem;
    rackBar1: TMenuItem;
    Splitter1: TMenuItem;
    GroupBox1: TMenuItem;
    SpinEdit1: TMenuItem;
    ComboBox1: TMenuItem;
    ListBox1: TMenuItem;
    CheckListBox1: TMenuItem;
    Saveprofile1: TMenuItem;
    Resetchanges1: TMenuItem;
    Save1: TMenuItem;
    emplateEditor1: TMenuItem;
    ExportChanges1: TMenuItem;
    Profile1: TMenuItem;
    Save2: TMenuItem;
    SaveDialog1: TSaveDialog;
    ResizerControl: TStxControlResizer;
    WebBrowser1: TMenuItem;
    ScrollBox1: TMenuItem;
    DisplayResizer1: TMenuItem;
    Copycontrolpath1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Image1: TMenuItem;
    MultiActionPopupMenu: TPopupMenu;
    SetStringsPopupMenu: TSpTBXFormPopupMenu;
    Image321: TMenuItem;
    Memo1: TMenuItem;
    Coloreditor1: TMenuItem;
    FontComboBox1: TMenuItem;
    itleBar1: TMenuItem;
    DockPanel1: TMenuItem;
    DockableForm1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure VDTControlsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure FormCreate(Sender: TObject);
    procedure RefreshFormListButtonClick(Sender: TObject);
    procedure FormSelectionComboBoxChange(Sender: TObject);
    procedure PropertiesListEditorEditButtonClick(Sender: TObject);
    procedure VDTControlsClick(Sender: TObject);
    procedure PropertiesListEditorStringsChange(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetValuesPopupMenuClosePopup(Sender: TObject;
      Selected: Boolean);
    procedure PickButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Form1Click(Sender: TObject);
    procedure Move1Click(Sender: TObject);
    procedure PageControl1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Control2Click(Sender: TObject);
    procedure abs1Click(Sender: TObject);
    procedure ab1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure InputBox1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Radio1Click(Sender: TObject);
    procedure ProgressBar1Click(Sender: TObject);
    procedure rackBar1Click(Sender: TObject);
    procedure Splitter1Click(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure SpinEdit1Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure Saveprofile1Click(Sender: TObject);
    procedure Resetchanges1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure emplateEditor1Click(Sender: TObject);
    procedure ExportChanges1Click(Sender: TObject);
    procedure Save2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ResizerControlControlResize(Sender: TObject);
    procedure WebBrowser1Click(Sender: TObject);
    procedure ScrollBox1Click(Sender: TObject);
    procedure DisplayResizer1Click(Sender: TObject);
    procedure Copycontrolpath1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image321Click(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Coloreditor1Click(Sender: TObject);
    procedure FontComboBox1Click(Sender: TObject);
    procedure itleBar1Click(Sender: TObject);
    procedure DockPanel1Click(Sender: TObject);
    procedure DockableForm1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  protected
    NodeList: TList;
    NodeText: TStringList;
    NodeControl: TList;
    FormList: TList;
    Properties: TList;
    MovingControl: TControl;

    subProp: string;
    CurrentControl: TControl;
  private
    procedure AddControlAndSubControls(node: PVirtualNode; c: TWinControl);
  public
    recordHistoryStartIndex: integer;
    history: TList;
    newProfileCode: string;
    
    procedure ListAllFormControls(f: TCustomForm);
    procedure ListAllForms;
    procedure ListObjectProperties(c: TObject);
    procedure StartMoveControl;
    procedure EndMoveControl;
    procedure AddControl(className: string);
    procedure AddToHistory(p: TProperty; newValue: Variant; subP: string; c: TControl; forceSave: boolean = false);
  end;

var
  CustomizeGUIForm: TCustomizeGUIForm;

implementation

uses MainUnit, HelpUnit, Misc, SetValuesFormUnit, TemplateEditorFormUnit, gnugettext,
  SetStringsUnit;

{$R *.dfm}

procedure TCustomizeGUIForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TBitmap32Property.LoadNewPicture(Sender: TObject);
var
  newVal: string;
begin
  CustomizeGUIForm.OpenDialog1.Filter := 'Picture files |*.jpg;*.bmp;*.gif;*.png;*.ico;*.tga';
  if not CustomizeGUIForm.OpenDialog1.Execute then
    Exit;
  FBmp32Obj.LoadFromFile(CustomizeGUIForm.OpenDialog1.FileName);
  newVal := StringReplace(CustomizeGUIForm.OpenDialog1.FileName,'\','\\',[rfReplaceAll]);
  CustomizeGUIForm.AddToHistory(Self,newVal,CustomizeGUIForm.subProp,CustomizeGUIForm.CurrentControl);
  FValue := newVal;
end;
procedure TBitmap32Property.ShowProperties(Sender: TObject);
begin
  if CustomizeGUIForm.subProp = '' then
    CustomizeGUIForm.subProp := FName
  else
    CustomizeGUIForm.subProp := CustomizeGUIForm.subProp + '.' + FName;
  CustomizeGUIForm.ListObjectProperties(FBmp32Obj);
end;

procedure TBitmap32Property.OnEdit;
var
  p: TPoint;
begin
  CustomizeGUIForm.MultiActionPopupMenu.Items.Clear;
  CustomizeGUIForm.MultiActionPopupMenu.Items.Add(TMenuItem.Create(CustomizeGUIForm.MultiActionPopupMenu));
  with CustomizeGUIForm.MultiActionPopupMenu.Items.Items[CustomizeGUIForm.MultiActionPopupMenu.Items.Count-1] do
  begin
    Caption := 'Load ...';
    OnClick := Self.LoadNewPicture;
  end;
  CustomizeGUIForm.MultiActionPopupMenu.Items.Add(TMenuItem.Create(CustomizeGUIForm.MultiActionPopupMenu));
  with CustomizeGUIForm.MultiActionPopupMenu.Items.Items[CustomizeGUIForm.MultiActionPopupMenu.Items.Count-1] do
  begin
    Caption := 'Properties ...';
    OnClick := Self.ShowProperties;
  end;
  GetCursorPos(p);
  CustomizeGUIForm.MultiActionPopupMenu.Popup(p.X,p.Y);
end;

constructor TBitmap32Property.Create(name: string;value: TBitmap32; obj: TObject);
begin
  FName := name;
  FObject := obj;
  FBmp32Obj := value;
end;

procedure TBitmap32Property.AddToList(l: TValueListEditor);
begin
  l.InsertRow(FName,FBmp32Obj.ClassName,True);
  with l.ItemProps[FName] do
  begin
    EditStyle := esEllipsis;
    ReadOnly := True;
  end;
end;

procedure TClassProperty.OnEdit;
begin
  if CustomizeGUIForm.subProp = '' then
    CustomizeGUIForm.subProp := FName
  else
    CustomizeGUIForm.subProp := CustomizeGUIForm.subProp + '.' + FName;
  CustomizeGUIForm.ListObjectProperties(FValueObj);
end;

constructor TClassProperty.Create(name: string;value: TObject; obj: TObject);
begin
  FName := name;
  FObject := obj;
  FValueObj := value;
end;

procedure TClassProperty.AddToList(l: TValueListEditor);
begin
  l.InsertRow(FName,FValueObj.ClassName,True);
  with l.ItemProps[FName] do
  begin
    EditStyle := esEllipsis;
    ReadOnly := True;
  end;

end;

constructor TProperty.Create(name: string;value: Variant; obj: TObject);
begin
  FName := name;
  FObject := obj;
  FValue := value;
end;

procedure TProperty.AddToList(l: TValueListEditor);
begin
  l.InsertRow(FName,FValue,True);
end;

procedure TProperty.OnEdit;
begin
end;

procedure TEnumerationProperty.AddToList(l: TValueListEditor);
var
  enumList: TStringList;
begin
  enumList := TStringList.Create;

  Misc.GetEnumPropertyList(FObject,FName,enumList);

  l.InsertRow(FName,FValue,True);
  with l.ItemProps[FName] do
  begin
    EditStyle := esPickList;
    ReadOnly := True;
    PickList.Assign(enumList);
  end;
end;

procedure TSetProperty.AddToList(l: TValueListEditor);
var
  enumList: TStringList;
begin
  enumList := TStringList.Create;

  Misc.GetEnumPropertyList(FObject,FName,enumList);

  l.InsertRow(FName,FValue,True);
  with l.ItemProps[FName] do
  begin
    EditStyle := esEllipsis;
    ReadOnly := True;
  end;
end;

procedure TSetProperty.OnEdit;
var
  p: TPoint;
  enumList: TStringList;
  valuesList: TStringList;
  i: integer;
  s: TGridRect;
begin
  enumList := TStringList.Create;
  valuesList := TStringList.Create;

  Misc.GetEnumPropertyList(FObject,FName,enumList);
  Misc.ParseDelimited(valuesList,FValue,',','');

  if SetValuesForm.SetValues.Cells[0,0] <> '' then
    for i:=SetValuesForm.SetValues.RowCount-1 downto 0 do
      SetValuesForm.SetValues.DeleteRow(i);

  for i:=0 to enumList.Count-1 do
  begin
    if valuesList.IndexOf(enumList[i]) > -1 then
      SetValuesForm.SetValues.InsertRow(enumList[i],'True',True)
    else
      SetValuesForm.SetValues.InsertRow(enumList[i],'False',True);

    with SetValuesForm.SetValues.ItemProps[enumList[i]] do
    begin
      EditStyle := esPickList;
      PickList.Add('True');
      PickList.Add('False');
      ReadOnly := True;
    end;
  end;

  s.Left := 1;
  s.Right := 1;
  s.Top := 0;
  s.Bottom := 0;
  SetValuesForm.SetValues.Selection := s;
  SetValuesForm.SetValues.Refresh;

  if SetValuesForm.SetValues.RowCount > 1 then
    SetValuesForm.SetValues.Row := 1;

  SetValuesForm.DisplayedProperty := Self;
  GetCursorPos(p);
  CustomizeGUIForm.SetValuesPopupMenu.Popup(p.X,p.Y);
end;

procedure TSetProperty.ChangeValue(v: string);
begin
  CustomizeGUIForm.PropertiesListEditor.Values[FName] := v;
end;

constructor TStringsProperty.Create(name: string;value: TWideStrings; obj: TObject);
begin
  FName := name;
  FObject := obj;
  FStrings := value;
end;

procedure TStringsProperty.AddToList(l: TValueListEditor);
var
  enumList: TStringList;
begin
  enumList := TStringList.Create;

  Misc.GetEnumPropertyList(FObject,FName,enumList);

  l.InsertRow(FName,FStrings.Text,True);
  with l.ItemProps[FName] do
  begin
    EditStyle := esEllipsis;
    ReadOnly := True;
  end;
end;

procedure TStringsProperty.OnEdit;
var
  p: TPoint;
begin
  SetStringsForm.StringsMemo.Lines.Assign(FStrings);
  SetStringsForm.DisplayedProperty := Self;
  GetCursorPos(p);
  CustomizeGUIForm.SetStringsPopupMenu.Popup(p.X,p.Y);
end;

procedure TStringsProperty.ChangeValue(v: TWideStrings);
var
  i: integer;
  newVal: string;
begin
  FStrings.Clear;
  for i:=0 to v.Count-1 do
  begin
    if newVal = '' then
      newVal := '["' + v.Strings[i] + '"'
    else
      newVal := newVal + ', "' + v.Strings[i] + '"';
    FStrings.Add(v.Strings[i]);
  end;
  newVal := newVal + ']';

  CustomizeGUIForm.PropertiesListEditor.Values[FName] := FStrings.Text;

  CustomizeGUIForm.AddToHistory(Self,newVal,CustomizeGUIForm.subProp,CustomizeGUIForm.CurrentControl);
  FValue := newVal;
end;

procedure TColorProperty.AddToList(l: TValueListEditor);
var
  enumList: TStringList;
begin
  enumList := TStringList.Create;

  Misc.GetEnumPropertyList(FObject,FName,enumList);

  l.InsertRow(FName,FValue,True);
  with l.ItemProps[FName] do
  begin
    EditStyle := esEllipsis;
    ReadOnly := False;
  end;
end;

procedure TColorProperty.OnEdit;
begin
  CustomizeGUIForm.PropertiesListEditor.Values[FName] := IntToStr(Misc.InputColor(FName,FValue));
end;

constructor TPictureProperty.Create(name: string;pictObj: TPicture; obj: TObject);
begin
  FName := name;
  FObject := obj;
  FPictObj := pictObj;
end;

procedure TPictureProperty.AddToList(l: TValueListEditor);
var
  enumList: TStringList;
begin
  enumList := TStringList.Create;

  Misc.GetEnumPropertyList(FObject,FName,enumList);

  l.InsertRow(FName,IntToStr(FPictObj.Width)+'x'+IntToStr(FPictObj.Height)+' picture',True);
  with l.ItemProps[FName] do
  begin
    EditStyle := esEllipsis;
    ReadOnly := False;
  end;
end;

procedure TPictureProperty.OnEdit;
var
  newVal: string;
begin
  CustomizeGUIForm.OpenDialog1.Filter := 'Picture files |*.jpg;*.bmp;*.gif;*.png;*.ico;*.tga';
  if not CustomizeGUIForm.OpenDialog1.Execute then
    Exit;

  if LoadPictureWithDevIL(CustomizeGUIForm.OpenDialog1.FileName,FPictObj) then
  begin
      newVal := StringReplace(CustomizeGUIForm.OpenDialog1.FileName,'\','\\',[rfReplaceAll]);
      CustomizeGUIForm.AddToHistory(Self,newVal,CustomizeGUIForm.subProp,CustomizeGUIForm.CurrentControl);
      FValue := newVal;
      CustomizeGUIForm.PropertiesListEditor.Values[FName] := IntToStr(FPictObj.Width)+'x'+IntToStr(FPictObj.Height)+' picture';
  end;
end;

constructor TBitmapProperty.Create(name: string;bmpObj: TBitmap; obj: TObject);
begin
  FName := name;
  FObject := obj;
  FBitmapObj := bmpObj;
end;

procedure TBitmapProperty.AddToList(l: TValueListEditor);
var
  enumList: TStringList;
begin
  enumList := TStringList.Create;

  Misc.GetEnumPropertyList(FObject,FName,enumList);

  l.InsertRow(FName,IntToStr(FBitmapObj.Width)+'x'+IntToStr(FBitmapObj.Height)+' picture',True);
  with l.ItemProps[FName] do
  begin
    EditStyle := esEllipsis;
    ReadOnly := False;
  end;
end;

procedure TBitmapProperty.OnEdit;
var
  imgWidth,imgHeight: integer;
  tmp,tmp2: TBitmap;
  newVal: String;
begin
  CustomizeGUIForm.OpenDialog1.Filter := 'Picture files |*.jpg;*.bmp;*.gif;*.png;*.ico;*.tga';
  if not CustomizeGUIForm.OpenDialog1.Execute then
    Exit;
  if LoadPictureWithDevIL(CustomizeGUIForm.OpenDialog1.FileName,FBitmapObj) then
  begin
      newVal := StringReplace(CustomizeGUIForm.OpenDialog1.FileName,'\','\\',[rfReplaceAll]);
      CustomizeGUIForm.AddToHistory(Self,newVal,CustomizeGUIForm.subProp,CustomizeGUIForm.CurrentControl);
      FValue := newVal;
      CustomizeGUIForm.PropertiesListEditor.Values[FName] := IntToStr(FBitmapObj.Width)+'x'+IntToStr(FBitmapObj.Height)+' picture';
  end;
end;

procedure TProperty.ValueChanged(v: Variant);
begin
  try
    CustomizeGUIForm.AddToHistory(Self,v,CustomizeGUIForm.subProp,CustomizeGUIForm.CurrentControl);
    FValue := v;
    Misc.SetProperty(FObject,FName,FValue);
  except
  end;
end;

procedure TPictureProperty.ValueChanged(v: Variant);
begin
end;

procedure TBitmapProperty.ValueChanged(v: Variant);
begin
end;

procedure TCustomizeGUIForm.ListObjectProperties(c: TObject);
var
  propNames: TStringList;
  propValue: TList;
  propTypes: TStringList;
  enumTest: TStringList;
  i: integer;
  p: TProperty;
  s: TGridRect;
begin
  LockWindowUpdate(Self.Handle);
  Properties.Clear;
  if PropertiesListEditor.Cells[0,0] <> '' then
    for i:=PropertiesListEditor.RowCount-1 downto 0 do
      PropertiesListEditor.DeleteRow(i);

  propNames := TStringList.Create;
  propValue := TList.Create;
  propTypes := TStringList.Create;
  enumTest := TStringList.Create;

  Misc.GetProperties(c,propNames,propValue,propTypes);

  for i:=0 to propNames.Count-1 do
  begin
    if propTypes[i] = 'tkEnumeration' then
    begin
      p := TEnumerationProperty.Create(propNames[i],Variant(propValue[i]^),c);
      TEnumerationProperty(p).AddToList(PropertiesListEditor);
    end
    else if propTypes[i] = 'tkClass' then
    begin
      if TObject(propValue[i]).ClassType = TPicture then
      begin
        p := TPictureProperty.Create(propNames[i],TPicture(propValue[i]),c);
        TPictureProperty(p).AddToList(PropertiesListEditor);
      end
      else if TObject(propValue[i]) is TWideStrings then
      begin
        p := TStringsProperty.Create(propNames[i],TWideStrings(propValue[i]),c);
        TStringsProperty(p).AddToList(PropertiesListEditor);
      end
      else if TObject(propValue[i]).ClassType = TBitmap then
      begin
        p := TBitmapProperty.Create(propNames[i],TBitmap(propValue[i]),c);
        TBitmapProperty(p).AddToList(PropertiesListEditor);
      end
      else if TObject(propValue[i]).ClassType = TBitmap32 then
      begin
        p := TBitmap32Property.Create(propNames[i],TBitmap32(propValue[i]),c);
        TBitmap32Property(p).AddToList(PropertiesListEditor);
      end
      else
      begin
        p := TClassProperty.Create(propNames[i],TObject(propValue[i]),c);
        TClassProperty(p).AddToList(PropertiesListEditor);
      end;
    end
    else if propTypes[i] = 'tkSet' then
    begin
      p := TSetProperty.Create(propNames[i],Variant(propValue[i]^),c);
      TSetProperty(p).AddToList(PropertiesListEditor);
    end
    else if propTypes[i] = 'TColor' then
    begin
      p := TColorProperty.Create(propNames[i],Variant(propValue[i]^),c);
      TColorProperty(p).AddToList(PropertiesListEditor);
    end
    else
    begin
      p := TProperty.Create(propNames[i],Variant(propValue[i]^),c);
      p.AddToList(PropertiesListEditor);
    end;
    Properties.Add(p);
  end;

  s.Left := 1;
  s.Right := 1;
  s.Top := 0;
  s.Bottom := 0;
  PropertiesListEditor.Selection := s;
  PropertiesListEditor.Refresh;
  LockWindowUpdate(0);

  if propNames.Count > 1 then
    PropertiesListEditor.Row := 1;
end;

procedure TCustomizeGUIForm.StartMoveControl;
var
  i: integer;
begin
  VDTControls.SetFocus;
  if VDTControls.FocusedNode <> nil then
  begin
    i := NodeList.IndexOf(VDTControls.FocusedNode);
    MovingControl := TControl(NodeControl[i]);

    Move1.Checked := True;
    File1.Enabled := False;
    Control1.Enabled := False;
    PropertiesScrollBox.Enabled := False;
  end;
end;

procedure TCustomizeGUIForm.EndMoveControl;
begin
  Move1.Checked := False;
  File1.Enabled := True;
  Control1.Enabled := True;
  PropertiesScrollBox.Enabled := True;
end;

procedure TCustomizeGUIForm.ListAllForms;
var
  i:integer;
begin
  FormList.Clear;
  FormSelectionComboBox.Clear;
  for i:=0 to Screen.FormCount-1 do
  begin
    if Screen.Forms[i].Name <> '' then
    begin
      FormSelectionComboBox.Items.Add(Screen.Forms[i].Name);
      FormList.Add(Screen.Forms[i]);
    end;
  end;
end;

procedure TCustomizeGUIForm.ListAllFormControls(f: TCustomForm);
begin
  VDTControls.Clear;
  NodeList.Clear;
  NodeText.Clear;
  NodeControl.Clear;
  VDTControls.Expanded[VDTControls.RootNode] := True;
  AddControlAndSubControls(VDTControls.RootNode,f);
  VDTControls.Repaint;
end;

procedure TCustomizeGUIForm.AddControlAndSubControls(node: PVirtualNode; c: TWinControl);
var
  i: integer;
  controlNode: PVirtualNode;
  childNode: PVirtualNode;
  gc : TGraphicControl;
begin
  if c.Name = '' then
    Exit;
  controlNode := VDTControls.AddChild(node);
  NodeList.Add(controlNode);
  NodeText.Add(c.Name);
  NodeControl.Add(c);
  controlNode.States := controlNode.States+[vsExpanded];

  // add child controls
  for i:=0 to c.ControlCount-1 do
  begin
    try
      gc := c.Controls[i] as TGraphicControl;
      childNode := VDTControls.AddChild(controlNode);
      NodeList.Add(childNode);
      childNode.States := childNode.States+[vsExpanded];
      NodeText.Add(gc.Name);
      NodeControl.Add(gc);
    except
    end;
    try
      AddControlAndSubControls(controlNode,c.Controls[i] as TWinControl);
    except
    end;
  end;

  // add docked controls
  for i:=0 to c.DockClientCount-1 do
  begin
    if NodeControl.IndexOf(c.DockClients[i]) = -1 then
    begin
      try
        gc := c.DockClients[i] as TGraphicControl;
        childNode := VDTControls.AddChild(controlNode);
        NodeList.Add(childNode);
        childNode.States := childNode.States+[vsExpanded];
        NodeText.Add(gc.Name);
        NodeControl.Add(gc);
      except
      end;
      try
        AddControlAndSubControls(controlNode,c.DockClients[i] as TWinControl);
      except
      end;
    end;
  end;

  // add child comp
  for i:=0 to c.ComponentCount-1 do
  begin
    try
      if not(c.Components[i] is TWinControl) and (c.Components[i].Name <> '') then
      begin
        childNode := VDTControls.AddChild(controlNode);
        NodeList.Add(childNode);
        childNode.States := childNode.States+[vsExpanded];
        NodeText.Add(c.Components[i].Name);
        NodeControl.Add(c.Components[i]);
      end;
    except
    end;
  end;
end;


procedure TCustomizeGUIForm.Button1Click(Sender: TObject);
begin
  AddControl('TSpTBXButton');
end;

procedure TCustomizeGUIForm.VDTControlsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  i: integer;
begin
  i := NodeList.IndexOf(Node);
  CellText := NodeText[i];
end;

procedure TCustomizeGUIForm.FormCreate(Sender: TObject);
begin
  NodeList := TList.Create;
  NodeText := TStringList.Create;
  FormList := TList.Create;
  Properties := TList.Create;
  NodeControl := TList.Create;

  history := TList.Create;
end;

procedure TCustomizeGUIForm.RefreshFormListButtonClick(Sender: TObject);
begin
  ListAllForms;
  FormSelectionComboBox.ItemIndex := 0;
  FormSelectionComboBoxChange(nil);
end;

procedure TCustomizeGUIForm.FormSelectionComboBoxChange(Sender: TObject);
begin
  ListAllFormControls(TCustomForm(FormList[FormSelectionComboBox.ItemIndex]));
end;

procedure TCustomizeGUIForm.PropertiesListEditorEditButtonClick(
  Sender: TObject);
var
  i:integer;
begin
  for i:=0 to Properties.Count-1 do
    if (TProperty(Properties[i]).Name = PropertiesListEditor.Keys[PropertiesListEditor.Row]) then
    begin
      TProperty(Properties[i]).OnEdit;
      Exit;
    end;
end;

procedure TCustomizeGUIForm.VDTControlsClick(Sender: TObject);
var
  i,j:integer;
  oldParent: TWinControl;

  ts: TTabSheet;
begin
  if VDTControls.FocusedNode <> nil then
  begin
    i := NodeList.IndexOf(VDTControls.FocusedNode);
    DisplayResizer1.Checked := False;
    DisplayResizer1Click(nil);
    if Move1.Checked then
    begin
      oldParent := MovingControl.Parent;
      try
        MovingControl.Parent := TWinControl(NodeControl[i]);
      except
        EndMoveControl;
      end;
      ListAllFormControls(TForm(FormList[FormSelectionComboBox.ItemIndex]));
      i := NodeControl.IndexOf(MovingControl);
      VDTControls.Selected[NodeList[i]] := True;
      VDTControls.FocusedNode := NodeList[i];
      VDTControls.ScrollIntoView(PVirtualNode(NodeList[i]),False);
      oldParent.Refresh;

      // special case for pagecontrol
      if oldParent.ClassType = TPageControl then
      begin
        if TPageControl(oldParent).ActivePage = MovingControl then
          TPageControl(oldParent).ActivePage := TPageControl(oldParent).Pages[0];
      end;

      MovingControl.Refresh;
      EndMoveControl;

      for j:=0 to Properties.Count-1 do
        if TProperty(Properties[j]).Name = 'Parent' then
        begin
          AddToHistory(TProperty(Properties[j]),GetStringFromComponent(MovingControl.Parent),'',CurrentControl);
          TProperty(Properties[j]).FValue := GetStringFromComponent(MovingControl.Parent);
        end;
    end
    else
    begin
      ListObjectProperties(TControl(NodeControl[i]));
      if TComponent(NodeControl[i]) is TControl then
        Properties.Add(TProperty.Create('Parent',GetStringFromComponent(TControl(NodeControl[i]).Parent),TControl(NodeControl[i])));
      subProp := '';
      CurrentControl := TControl(NodeControl[i]);
    end;
  end;
end;

procedure TCustomizeGUIForm.PropertiesListEditorStringsChange(
  Sender: TObject);
var
  i: integer;
  obj: TObject;
begin
  for i:=0 to Properties.Count-1 do
    if TProperty(Properties[i]).Name = PropertiesListEditor.Keys[PropertiesListEditor.Row] then
    begin
      if TProperty(Properties[i]).ClassType <> TClassProperty then
        TProperty(Properties[i]).Value := PropertiesListEditor.Values[TProperty(Properties[i]).Name];
    end;
end;

procedure TCustomizeGUIForm.SetValuesPopupMenuClosePopup(Sender: TObject;
  Selected: Boolean);
begin
  SetValuesForm.DisplayedProperty := nil;
end;

procedure TCustomizeGUIForm.PickButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  p: TPoint;
  pScreen: TPoint;
  c,cTmp: TWinControl;
begin
  p.X := X;
  p.Y := Y;
  pScreen := (Sender as TSpTBXButton).ClientToScreen(p);
  p := TForm(FormList[FormSelectionComboBox.ItemIndex]).ScreenToClient(pScreen);
  try
    cTmp := TForm(FormList[FormSelectionComboBox.ItemIndex]).ControlAtPos(p,True,True) as TWinControl;
  except
    cTmp := nil;
  end;
  while cTmp <> nil do
  begin
    c := cTmp;
    try
      cTmp := c.ControlAtPos(c.ScreenToClient(pScreen),True,True) as TWinControl;
    except
      cTmp := nil;
    end;
  end;

  i := NodeControl.IndexOf(c);
  if i > -1 then
  begin
    VDTControls.SetFocus;
    VDTControls.Selected[NodeList[i]] := True;
    VDTControls.FocusedNode := NodeList[i];
    VDTControls.ScrollIntoView(NodeList[i],False);
    VDTControlsClick(nil);
  end;
end;

procedure TCustomizeGUIForm.Form1Click(Sender: TObject);
var
  p: TScriptForm;
begin
  p := TScriptForm.CreateNew(Application,0);
  p.Name := InputBox('Add form','Control name:','');
  p.Caption := 'Empty form';
  p.BorderStyle := bsSizeable;
  p.Show;
  ListAllForms;
  FormSelectionComboBox.ItemIndex := FormSelectionComboBox.Items.IndexOf(p.Name);
  FormSelectionComboBoxChange(nil);
  history.Add(THistoryItemForm.Create(p,False));
end;

procedure TCustomizeGUIForm.Move1Click(Sender: TObject);
begin
  StartMoveControl;
end;

procedure TCustomizeGUIForm.PageControl1Click(Sender: TObject);
var
  p: TPageControl;
  i: integer;
begin
  i := NodeList.IndexOf(VDTControls.FocusedNode);
  if i > -1 then
  begin
    p := TPageControl.Create(TControl(NodeControl[i]));
    p.Parent := TWinControl(NodeControl[i]);
    p.Name := InputBox('Add PageControl','Control name:','');

    ListAllFormControls(TForm(FormList[FormSelectionComboBox.ItemIndex]));
    i := NodeControl.IndexOf(p);
    VDTControls.Selected[NodeList[i]] := True;
    VDTControls.FocusedNode := NodeList[i];
    VDTControls.ScrollIntoView(PVirtualNode(NodeList[i]),False);
  end;
end;

procedure TCustomizeGUIForm.Panel1Click(Sender: TObject);
begin
  AddControl('TSpTBXPanel');
end;

procedure TCustomizeGUIForm.Control2Click(Sender: TObject);
begin
  AddControl(InputBox('Add control','Control class name :',''));
end;

procedure TCustomizeGUIForm.AddControl(className: string);
var
  classV: TPersistentClass;
  p: TWinControl;
  i: integer;
  n: string;
begin

  i := NodeList.IndexOf(VDTControls.FocusedNode);
  if i > -1 then
  begin
    try
      n := InputBox('Add Panel','Control name:','');
      if n = '' then Exit;
      classV := GetClass(className);
      p := TWinControlClass(classV).Create(TControl(NodeControl[i]));
      p.Parent := TWinControl(NodeControl[i]);
      p.Name := n;

      ListAllFormControls(TForm(FormList[FormSelectionComboBox.ItemIndex]));
      i := NodeControl.IndexOf(p);
      VDTControls.Selected[NodeList[i]] := True;
      VDTControls.FocusedNode := NodeList[i];
      VDTControls.ScrollIntoView(PVirtualNode(NodeList[i]),False);
      VDTControlsClick(nil);

      history.Add(THistoryItemControl.Create(p));
    except
      MessageDlg('Incorrect class name!',mtError,[mbOk],0);
    end;
  end;
end;

procedure TCustomizeGUIForm.abs1Click(Sender: TObject);
begin
  AddControl('TSpTBXTabControl');
end;

procedure TCustomizeGUIForm.ab1Click(Sender: TObject);
var
  classV: TPersistentClass;
  p: TWinControl;
  i,j: integer;
  cname: string;
  control: TControl;
begin
  i := NodeList.IndexOf(VDTControls.FocusedNode);
  if i > -1 then
  begin
    control := TControl(NodeControl[i]);
    if control.ClassType <> TSpTBXTabControl then
    begin
      MessageDlg('You must select a TSpTBXTabControl first!',mtError,[mbOk],0);
      Exit;
    end;
    TSpTBXTabControl(control).Add('Empty tab');
    cname := InputBox('Add tab','Tab name :','');
    if cname = '' then Exit;
    TSpTBXTabControl(control).Pages[TSpTBXTabControl(control).PagesCount-1].Name := cname;

    ListAllFormControls(TForm(FormList[FormSelectionComboBox.ItemIndex]));
    j := NodeControl.IndexOf(TSpTBXTabControl(control).Pages[TSpTBXTabControl(control).PagesCount-1]);
    VDTControls.Selected[NodeList[j]] := True;
    VDTControls.FocusedNode := NodeList[j];
    VDTControls.ScrollIntoView(PVirtualNode(NodeList[j]),False);
    VDTControlsClick(nil);
    history.Add(THistoryItemTab.Create(TSpTBXTabControl(control).Pages[TSpTBXTabControl(control).PagesCount-1],TSpTBXTabControl(control)));
  end;
end;

procedure TCustomizeGUIForm.Delete1Click(Sender: TObject);
var
  i: integer;
begin
  if VDTControls.FocusedNode <> nil then
  begin
    i := NodeList.IndexOf(VDTControls.FocusedNode);
    if DisplayResizer1.Checked then
    begin
      DisplayResizer1.Checked := False;
      ResizerControl.HandleObject := nil;
      ResizerControl.Parent := CustomizeGUIForm;
    end;
    if TControl(NodeControl[i]).ClassType = TSpTBXTabSheet then
      TSpTBXTabSheet(NodeControl[i]).Item.Destroy;
    TControl(NodeControl[i]).Destroy;

    ListAllFormControls(TForm(FormList[FormSelectionComboBox.ItemIndex]));
  end;
end;

procedure TCustomizeGUIForm.InputBox1Click(Sender: TObject);
begin
  AddControl('TSpTBXEdit');
end;

procedure TCustomizeGUIForm.Label1Click(Sender: TObject);
begin
  AddControl('TSpTBXLabel');
end;

procedure TCustomizeGUIForm.CheckBox1Click(Sender: TObject);
begin
  AddControl('TSpTBXCheckBox');
end;

procedure TCustomizeGUIForm.Radio1Click(Sender: TObject);
begin
  AddControl('TSpTBXRadioButton');
end;

procedure TCustomizeGUIForm.ProgressBar1Click(Sender: TObject);
begin
  AddControl('TSpTBXProgressBar');
end;

procedure TCustomizeGUIForm.rackBar1Click(Sender: TObject);
begin
  AddControl('TSpTBXTrackBar');
end;

procedure TCustomizeGUIForm.Splitter1Click(Sender: TObject);
begin
  AddControl('TSpTBXSplitter');
end;

procedure TCustomizeGUIForm.GroupBox1Click(Sender: TObject);
begin
  AddControl('TSpTBXGroupBox');
end;

procedure TCustomizeGUIForm.SpinEdit1Click(Sender: TObject);
begin
  AddControl('TSpTBXSpinEdit');
end;

procedure TCustomizeGUIForm.ComboBox1Click(Sender: TObject);
begin
  AddControl('TSpTBXComboBox');
end;

procedure TCustomizeGUIForm.ListBox1Click(Sender: TObject);
begin
  AddControl('TSpTBXListBox');
end;

procedure TCustomizeGUIForm.CheckListBox1Click(Sender: TObject);
begin
  AddControl('TSpTBXCheckListBox'); 
end;

procedure TCustomizeGUIForm.Saveprofile1Click(Sender: TObject);
var
  i: integer;
begin
  newProfileCode := '';
  for i:=0 to history.Count-1 do
    newProfileCode := newProfileCode + THistoryItem(history[i]).getPythonCode(0);

  for i:=history.Count-1 downto 0 do
  begin
    THistoryItem(history[i]).Revert;
    THistoryItem(history[i]).Free;
  end;
  history.Clear;

  if CurrentControl <> nil then
    try
      ListObjectProperties(CurrentControl);
    except
      CurrentControl := nil;
    end;

  Save1.Enabled := True;
  Saveprofile1.Enabled := False;
  ExportChanges1.Enabled := False;

  MessageDlg('Layout has been unloaded, save the profile when you will have restored de default layout properly.',mtInformation,[mbOk],0);
end;

procedure TCustomizeGUIForm.AddToHistory(p: TProperty; newValue: Variant; subP: string; c: TControl; forceSave: boolean = false);
var
  i: integer;
  prop: TProperty;
begin
    if (p.FValue <> newValue) or forceSave then
    begin
      if (p.FName <> 'Align') then
          for i:=history.Count-1 downto 0 do // to avoid saving multiple changes for properties (except for the align, because align order matters)
          begin
            // we remove the pos and size changes until we find an align changement
            if (p.FName = 'Left') or (p.FName = 'Top') or (p.FName = 'Width') or (p.FName = 'Height') then
              if THistoryItemProperty(history[i]).FPropName = 'Align' then
                break;
            if (THistoryItemProperty(history[i]).FObject = p.FObject) and (THistoryItemProperty(history[i]).FPropName = p.FName) and (THistoryItemProperty(history[i]).FSubProp = subP) then
            begin
              p.FValue := THistoryItemProperty(history[i]).FPropOldValue; // small hack :D
              history.Delete(i);
              if i < recordHistoryStartIndex then
                Dec(recordHistoryStartIndex);
              break;
            end;
          end;
      if p.FName = 'Align' then
      begin
        for i:=0 to Properties.Count-1 do
        begin
          prop := TProperty(Properties[i]);
          if TProperty(Properties[i]).FName = 'Top' then
            AddToHistory(prop,prop.FValue,subP,c,True);
          if TProperty(Properties[i]).FName = 'Left' then
            AddToHistory(prop,prop.FValue,subP,c,True);
          if TProperty(Properties[i]).FName = 'Width' then
            AddToHistory(prop,prop.FValue,subP,c,True);
          if TProperty(Properties[i]).FName = 'Height' then
            AddToHistory(prop,prop.FValue,subP,c,True);
        end;
      end;
      history.Add(THistoryItemProperty.Create(p,newValue,subP,c,not(p is TStringsProperty)));
    end;
end;

constructor THistoryItemProperty.Create(p: TProperty; newValue: Variant; subP: string; c: TControl; dblQuoteResult : boolean = False);
begin
  Self.FPropName := p.Name;
  Self.FPropOldValue := p.Value;
  Self.FPropNewValue := newValue;
  Self.FControl := c;
  Self.FObject := p.FObject;
  Self.FSubProp := subP;
  Self.FDblQuoteResult := dblQuoteResult;
end;

function THistoryItemProperty.getPythonCode(saveType: integer): string;
begin
  if saveType = 0 then
    Result := TemplateEditorForm.LayoutPropertyChange.Lines.Text
  else
    Result := TemplateEditorForm.RecordPropertyChange.Lines.Text;

  Result := StringReplace(Result,'$control',GetStringFromComponent(TControl(Self.FControl)),[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,'$subprop',Self.FSubProp,[rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,'$propname',Self.FPropName,[rfReplaceAll, rfIgnoreCase]);
  if FDblQuoteResult then
     Result := StringReplace(Result,'$newvalue','"'+String(Self.FPropNewValue)+'"',[rfReplaceAll, rfIgnoreCase])
  else
    Result := StringReplace(Result,'$newvalue',String(Self.FPropNewValue),[rfReplaceAll, rfIgnoreCase]);
  Result := Result;
end;

constructor THistoryItemControl.Create(control: TControl);
begin
  FControl := control;
end;

function THistoryItemControl.getPythonCode(saveType: integer): string;
var
  ownerPath: string;
  controlPath: string;
begin
  ownerPath := GetStringFromComponent(Self.FControl.Owner);
  controlPath := GetStringFromComponent(FControl);
  Result := #9+'gui.AddControl("'+Self.FControl.Name+'","'+ownerPath+'","'+Self.FControl.ClassName+'")'+EOL;
  if saveType = 0 then
    Result := Result + #9 + 'newControlList.append("'+controlPath+'")'+EOL;
end;

constructor THistoryItemForm.Create(form: TCustomForm;dockableForm:boolean);
begin
  FForm := form;
  if dockableForm then
    FDockableForm := 'True'
  else
    FDockableForm := 'False';
end;

function THistoryItemForm.getPythonCode(saveType: integer): string;
begin
  Result := #9+'gui.AddForm("'+Self.FForm.Name+'","EmptyForm",2,'+FDockableForm+')'+EOL;
  if saveType = 0 then
    Result := Result + #9 + 'newControlList.append("'+Self.FForm.Name+'")'+EOL;
end;

constructor THistoryItemTab.Create(tabSheet: TSpTBXTabSheet; tabControl: TSpTBXTabControl);
begin
  FTabSheet := tabSheet;
  FTabControl := tabControl;
end;

function THistoryItemTab.getPythonCode(saveType: integer): string;
begin
  Result := #9+'gui.AddTab("New tab","'+Self.FTabSheet.Name+'","'+GetStringFromComponent(Self.FTabControl)+'")'+EOL;
  if saveType = 0 then
    Result := Result + #9 + 'newControlList.append("'+GetStringFromComponent(Self.FTabSheet)+'")';
end;

procedure THistoryItemProperty.Revert;
begin
  if FPropName = 'Parent' then
    TControl(Self.FObject).Parent :=  GetComponentFromString(Self.FPropOldValue) as TWinControl
  else
    try
      Misc.SetProperty(Self.FObject,Self.FPropName,Self.FPropOldValue);
    except
    end;
end;

procedure THistoryItemTab.Revert;
begin
  try
    FTabSheet.Item.Destroy;
  except
  end;
end;

procedure THistoryItemForm.Revert;
begin
  FForm.Destroy;
end;

procedure THistoryItemControl.Revert;
begin
  FControl.Destroy;
end;

procedure TCustomizeGUIForm.Resetchanges1Click(Sender: TObject);
var
  i: integer;
begin
  for i:=history.Count-1 downto 0 do
  begin
    THistoryItem(history[i]).Revert;
    THistoryItem(history[i]).Free;
  end;
  history.Clear;
  if CurrentControl <> nil then
    ListObjectProperties(CurrentControl);
end;

procedure TCustomizeGUIForm.Save1Click(Sender: TObject);
var
  fileName: string;
  f: TextFile;
  loadProfileCode,profileCode: String;
  i: integer;
begin
  fileName := InputBox('Save profile','Profile name :','');
  if filename = '' then
    Exit;

  profileCode := StringReplace(TemplateEditorForm.ProfileTemplate.Text,'${loadProfileContent}',newProfileCode,[]);

  loadProfileCode := '';
  for i:=0 to history.Count-1 do
    loadProfileCode := loadProfileCode + THistoryItem(history[i]).getPythonCode(0);

  profileCode := StringReplace(profileCode,'${unloadProfileContent}',loadProfileCode,[]);

  AssignFile(f, ExtractFilePath(Application.ExeName) + SCRIPTS_PROFILES_FOLDER + '\' + fileName + '.py');
  Rewrite(f);
  Write(f, profileCode);
  CloseFile(f);

  Save1.Enabled := False;
  Saveprofile1.Enabled := True;
  ExportChanges1.Enabled := True;
  history.Clear;
end;

procedure TCustomizeGUIForm.emplateEditor1Click(Sender: TObject);
begin
  TemplateEditorForm.Show;
end;

procedure TCustomizeGUIForm.ExportChanges1Click(Sender: TObject);
begin
  recordHistoryStartIndex := history.Count;

  Save2.Enabled := True;
  ExportChanges1.Enabled := False;
  Saveprofile1.Enabled := False;
end;

procedure TCustomizeGUIForm.Save2Click(Sender: TObject);
var
  i: integer;
  fileName: string;
  f: TextFile;
  profileCode: String;
begin
  if not SaveDialog1.Execute then
    Exit;

  fileName := SaveDialog1.FileName;

  profileCode := '';
  for i:=recordHistoryStartIndex to history.Count-1 do
    profileCode := profileCode + THistoryItem(history[i]).getPythonCode(1);

  AssignFile(f, fileName);
  Rewrite(f);
  Write(f, profileCode);
  CloseFile(f);

  Save2.Enabled := False;
  ExportChanges1.Enabled := True;
  Saveprofile1.Enabled := True;
end;

procedure TCustomizeGUIForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ResizerControl.HandleObject := nil;
end;

procedure TCustomizeGUIForm.ResizerControlControlResize(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to PropertiesListEditor.RowCount-1 do
  begin
    if PropertiesListEditor.Cells[0,i] = 'Left' then
    begin
      PropertiesListEditor.Cells[1,i] := IntToStr((Sender as TControl).Left+6);
      PropertiesListEditor.Row := i;
      PropertiesListEditorStringsChange(PropertiesListEditor);
    end;
    if PropertiesListEditor.Cells[0,i] = 'Top' then
    begin
      PropertiesListEditor.Cells[1,i] := IntToStr((Sender as TControl).Top+6);
      PropertiesListEditor.Row := i;
      PropertiesListEditorStringsChange(PropertiesListEditor);
    end;
    if PropertiesListEditor.Cells[0,i] = 'Width' then
    begin
      PropertiesListEditor.Cells[1,i] := IntToStr((Sender as TControl).Width-12);
      PropertiesListEditor.Row := i;
      PropertiesListEditorStringsChange(PropertiesListEditor);
    end;
    if PropertiesListEditor.Cells[0,i] = 'Height' then
    begin
      PropertiesListEditor.Cells[1,i] := IntToStr((Sender as TControl).Height-12);
      PropertiesListEditor.Row := i;
      PropertiesListEditorStringsChange(PropertiesListEditor);
    end;
  end;
  
end;

procedure TCustomizeGUIForm.WebBrowser1Click(Sender: TObject);
begin
  AddControl('TWebBrowserWrapper');
end;

procedure TCustomizeGUIForm.ScrollBox1Click(Sender: TObject);
begin
  AddControl('TTntScrollBox');
end;

procedure TCustomizeGUIForm.DisplayResizer1Click(Sender: TObject);
var
  i: integer;
begin
  if VDTControls.FocusedNode <> nil then
  begin
    i := NodeList.IndexOf(VDTControls.FocusedNode);

    if DisplayResizer1.Checked then
    begin
      try
        ResizerControl.HandleObject := TControl(NodeControl[i]);
      except
        ResizerControl.HandleObject := nil;
        DisplayResizer1.Checked := False;
      end;
      //CustomizeGUIForm.SetFocus;
    end
    else
      try
        ResizerControl.HandleObject := nil;
        ResizerControl.Parent := CustomizeGUIForm;
      except
      end;
  end
  else
  begin
    ResizerControl.HandleObject := nil;
    DisplayResizer1.Checked := False;
    ResizerControl.Parent := CustomizeGUIForm;
  end;
end;

procedure TCustomizeGUIForm.Copycontrolpath1Click(Sender: TObject);
var
  i: integer;
begin
  if VDTControls.FocusedNode <> nil then
  begin
    i := NodeList.IndexOf(VDTControls.FocusedNode);

    Clipboard.SetTextBuf(PChar(LobbyScriptUnit.GetStringFromComponent(TControl(NodeControl[i]))));
  end;
end;

procedure TCustomizeGUIForm.Image1Click(Sender: TObject);
begin
  AddControl('TImage');
end;

procedure TCustomizeGUIForm.Image321Click(Sender: TObject);
begin
  AddControl('TImage32');
end;

procedure TCustomizeGUIForm.Memo1Click(Sender: TObject);
begin
  AddControl('TTntMemo');
end;

procedure TCustomizeGUIForm.Coloreditor1Click(Sender: TObject);
begin
  AddControl('TSpTBXColorEdit');
end;

procedure TCustomizeGUIForm.FontComboBox1Click(Sender: TObject);
begin
  AddControl('TSpTBXFontComboBox');
end;

procedure TCustomizeGUIForm.itleBar1Click(Sender: TObject);
begin
  AddControl('TSpTBXTitleBar');
end;

procedure TCustomizeGUIForm.DockPanel1Click(Sender: TObject);
begin
  AddControl('TDockPanel');
end;

procedure TCustomizeGUIForm.DockableForm1Click(Sender: TObject);
var
  p: TDockableForm;
begin
  p := TDockableForm.CreateNew(Application,0);
  p.Name := InputBox('Add form','Control name:','');
  p.Caption := 'Empty form';
  p.BorderStyle := bsSizeable;
  if not MainForm.mnuLockView.Checked then
  begin
    p.DragKind := dkDock;
    p.DragMode := dmAutomatic;
  end;
  p.Show;
  ListAllForms;
  FormSelectionComboBox.ItemIndex := FormSelectionComboBox.Items.IndexOf(p.Name);
  FormSelectionComboBoxChange(nil);
  history.Add(THistoryItemForm.Create(p,True));
end;

procedure TCustomizeGUIForm.Button2Click(Sender: TObject);
begin
  ListObjectProperties(MainForm.RichEditPopupMenu);
end;

end.
