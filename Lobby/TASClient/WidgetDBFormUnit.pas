unit WidgetDBFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, gnugettext, SpTBXControls, StdCtrls, TntStdCtrls,
  SpTBXEditors, SpTBXDkPanels, OleCtrls, SHDocVw, VirtualTrees, xmldom,
  XMLIntf, msxmldom, XMLDoc, SpTBXSkins, GpIFF, UWebBrowserWrapper,ActiveX,
  JclUnicode, SpTBXTabs, TB2Item, ComCtrls, OverbyteIcsWndControl,
  OverbyteIcsHttpProt, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, MsMultiPartFormData, MainUnit;

type
  TWidgetCategory = class
  public
    Id: integer;
    Name: WideString;
  end;

  TWidgetItem = class
  public
    Id : integer;
    Name : WideString;
    NameId : Integer;
    Downloads : integer;
    Games : WideString;
    Rating : Extended;
    VoteCount : integer;
    Comments : integer;
    Author : WideString;
    Description: WideString;
    Category: TWidgetCategory;
    Entry: WideString;
    Node: PVirtualNode;
    NodeAdded: Boolean;
    Changelog: WideString;
    Installed: Boolean;
    UpToDate: Boolean;
  end;

  TRefreshWidgetListThread = class(TTASClientThread)
  protected
    procedure Execute; override;
    procedure UpdateList;

  public
    constructor Create(Suspended : Boolean);
  end;

  TUpdateWidgetInfoThread = class(TTASClientThread)
  protected
    FWidget: TWidgetItem;
    FDisplayWB: boolean;
    FResultHtml: WideString;
    FComments: WideString;
    procedure Execute; override;
    procedure UpdateWBHtml;
    procedure UpdateComments;

  public
    constructor Create(Suspended : Boolean; widget : TWidgetItem);
  end;

  TInstallWidgetThread = class(TTASClientThread)
  protected
    FWidget: TWidgetItem;
    FUninstall: Boolean;
    FUpdating: Boolean;
    procedure Execute; override;
    procedure UpdateGUI;

  public
    constructor Create(Suspended : Boolean; widget : TWidgetItem; uninstall: boolean);
  end;

  TSendCommentThread = class(TTASClientThread)
  protected
    FWidget: TWidgetItem;
    FComment: WideString;
    procedure Execute; override;
    procedure UpdateGUI;

  public
    constructor Create(Suspended : Boolean; widget : TWidgetItem; comment: WideString);
  end;

  TRateThread = class(TTASClientThread)
  protected
    FWidget: TWidgetItem;
    FRate: Byte;
    procedure Execute; override;
    procedure UpdateGUI;

  public
    constructor Create(Suspended : Boolean; widget : TWidgetItem; rate: Byte);
  end;

  TWidgetDBForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    pnlMain: TSpTBXPanel;
    SpTBXSplitter1: TSpTBXSplitter;
    vstWidgetList: TVirtualStringTree;
    pnlWidgetInfo: TSpTBXPanel;
    pnlMiddle: TSpTBXPanel;
    lblWidgetName: TSpTBXLabel;
    SpTBXSplitter2: TSpTBXSplitter;
    mmDescriptionHtml: TMemo;
    mmScreenshotsHtml: TMemo;
    mmScreenshotItemHtml: TMemo;
    pnlTop: TSpTBXPanel;
    btRefresh: TSpTBXButton;
    lblFilter: TSpTBXLabel;
    txtFilter: TSpTBXButtonEdit;
    tcWidgetInfo: TSpTBXTabControl;
    tabWidgetDescription: TSpTBXTabItem;
    tsWidgetDescription: TSpTBXTabSheet;
    tabWidgetChangelog: TSpTBXTabItem;
    tsWidgetChangelog: TSpTBXTabSheet;
    tabWidgetComments: TSpTBXTabItem;
    tsWidgetComments: TSpTBXTabSheet;
    reChangelog: TRichEdit;
    reComments: TRichEdit;
    btInstall: TSpTBXButton;
    btUninstall: TSpTBXButton;
    pnlPostComment: TSpTBXPanel;
    reMyComment: TRichEdit;
    btSendComment: TSpTBXButton;
    IdAntiFreeze1: TIdAntiFreeze;
    IdHTTP1: TIdHTTP;
    gbRate: TSpTBXGroupBox;
    btRate5: TSpTBXButton;
    btRate4: TSpTBXButton;
    btRate3: TSpTBXButton;
    btRate2: TSpTBXButton;
    btRate1: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormCreate(Sender: TObject);
    procedure vstWidgetListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vstWidgetListDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: WideString; const CellRect: TRect;
      var DefaultDraw: Boolean);
    procedure vstWidgetListHeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure vstWidgetListHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure vstWidgetListCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FormShow(Sender: TObject);
    procedure OnWebBrowsersBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure OnWebBrowsersNewWindow2(Sender: TObject;
      var ppDisp: IDispatch; var Cancel: WordBool);
    procedure txtFilterChange(Sender: TObject);
    procedure txtFilterSubEditButton0Click(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
    procedure vstWidgetListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure btInstallClick(Sender: TObject);
    procedure btUninstallClick(Sender: TObject);
    procedure btSendCommentClick(Sender: TObject);
    procedure btRate1Click(Sender: TObject);
    procedure btRate2Click(Sender: TObject);
    procedure btRate3Click(Sender: TObject);
    procedure btRate4Click(Sender: TObject);
    procedure btRate5Click(Sender: TObject);
    procedure vstWidgetListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstWidgetListChecking(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure vstWidgetListGetHint(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex;
      var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
  private
    { Private declarations }
  protected
    wbInitialized: Boolean;
  public
    widgetList: TList;
    widgetCategoryList: TList;
    noneCategory: TWidgetCategory;
    wbDescription: TWebBrowserWrapper;
    wbScreenShots: TWebBrowserWrapper;
    uwiThread : TUpdateWidgetInfoThread;

    function GetWidgetByNode(Node : PVirtualNode): TWidgetItem;
    function SelectWidget(Node : PVirtualNode): boolean;
    function GetSkinnedHtmlDescription(description: WideString): WideString;
    function ReplaceCommonVars(htmlCode: WideString): WideString;
    procedure FilterWidgetListDisplay(filter: WideString);
    function GetCategoryById(id: integer): TWidgetCategory;
    function GetWidgetById(id: integer): TWidgetItem;
    procedure RateWidget(rate: Byte);
  end;
var
  WidgetDBForm: TWidgetDBForm;

implementation

uses PreferencesFormUnit, Misc, Math, ComObj, StrUtils,LobbyScriptUnit;

{$R *.dfm}

procedure TWidgetDBForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  FixFormSizeConstraints(WidgetDBForm);

  widgetList := TList.Create;
  widgetCategoryList := TList.Create;
  noneCategory := TWidgetCategory.Create;
  noneCategory.Id := -1;
  noneCategory.Name := ' ';
  uwiThread := nil;
  wbInitialized := false;

  wbScreenShots := TWebBrowserWrapper.Create(Self);
  TWinControl(wbScreenShots).Parent := pnlWidgetInfo;
  TWinControl(wbScreenShots).Align := alBottom;
  TWinControl(wbScreenShots).Height := 180;
  wbScreenShots.Show3DBorder := False;
  wbScreenShots.OnBeforeNavigate2 := OnWebBrowsersBeforeNavigate2;
  wbScreenShots.OnNewWindow2 := OnWebBrowsersNewWindow2;

  SpTBXSplitter2.Align := alBottom;

  TWinControl(wbScreenShots).Visible := False;
  SpTBXSplitter2.Visible := False;

  wbDescription := TWebBrowserWrapper.Create(Self);
  TWinControl(wbDescription).Parent := tsWidgetDescription;
  TWinControl(wbDescription).Align := alClient;
  wbDescription.Show3DBorder := False;
  wbDescription.OnBeforeNavigate2 := OnWebBrowsersBeforeNavigate2;
  wbDescription.OnNewWindow2 := OnWebBrowsersNewWindow2;
end;

procedure TWidgetDBForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

function TWidgetDBForm.GetWidgetByNode(Node : PVirtualNode): TWidgetItem;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to widgetList.Count-1 do
    if (TWidgetItem(widgetList[i]).Node = Node) or TWidgetItem(widgetList[i]).NodeAdded then
    begin
      Result := widgetList[i];
      Exit;
    end;
end;

function TWidgetDBForm.GetWidgetById(id: integer): TWidgetItem;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to widgetList.Count-1 do
    if TWidgetItem(widgetList[i]).Id = id then
    begin
      Result := widgetList[i];
      Exit;
    end;
end;

procedure TWidgetDBForm.vstWidgetListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  widget : TWidgetItem;
  i: integer;
begin
  widget := GetWidgetByNode(Node);
  if widget = nil then
  begin
    CellText := '';
    Exit;
  end;
  case Column of
    0: CellText := '   ';
    1: CellText := widget.Name;
    2: CellText := widget.Category.Name;
    3: CellText := IntToStr(widget.Downloads);
    4: CellText := widget.Games;
    5: CellText := IFF(widget.Rating>-1,FloatToStrF(widget.Rating,ffGeneral,2,1),' ');
    6: CellText := IntToStr(widget.VoteCount);
    7: CellText := IntToStr(widget.Comments);
    8: CellText := widget.Author;
    9: CellText := widget.Entry;
  end;
end;

procedure TWidgetDBForm.vstWidgetListDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: WideString; const CellRect: TRect; var DefaultDraw: Boolean);
var
  PaintRect: TRect;
  CheckboxRect: TRect;
  hot: Boolean;
  pt: TPoint;
  hi: THitInfo;
  itemState: TSpTBXSkinStatesType;
  widgetItem: TWidgetItem;
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

      if Header.Columns[Column].CheckBox then
        TargetCanvas.FillRect(TargetCanvas.ClipRect);

      itemState := SkinManager.CurrentSkin.GetState(True,False,hot,Selected[Node]);
      SkinManager.CurrentSkin.PaintBackground(TargetCanvas,PaintRect,skncListItem,itemState,True,True);
      TargetCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncListItem,itemState);
      if Header.Columns[Column].CheckBox then
      begin
        widgetItem := GetWidgetByNode(Node);
        if widgetItem.Installed and not widgetItem.UpToDate then
        begin
          TargetCanvas.CopyMode := Graphics.cmDstInvert;
          TargetCanvas.CopyRect(TargetCanvas.ClipRect,TargetCanvas,TargetCanvas.ClipRect);
          TargetCanvas.CopyMode := Graphics.cmSrcCopy;
        end;

        CopyRect(CheckboxRect,TargetCanvas.ClipRect);
        InflateRect(CheckboxRect,-3,-3);
        SkinManager.CurrentSkin.PaintBackground(TargetCanvas,CheckboxRect,skncCheckBox,itemState,True,True);
        if (Node.CheckState = csCheckedNormal) then
          SkinManager.CurrentSkin.PaintMenuCheckMark(TargetCanvas,CheckboxRect,True,False,False,itemState);
      end;
      TargetCanvas.Brush.Style := Graphics.bsClear;
    end;
  end
  else
  begin
    if Column = 0 then
    begin
      widgetItem := GetWidgetByNode(Node);
      if widgetItem.Installed and not widgetItem.UpToDate then
      begin
        TargetCanvas.CopyMode := Graphics.cmDstInvert;
        TargetCanvas.CopyRect(TargetCanvas.ClipRect,TargetCanvas,TargetCanvas.ClipRect);
        TargetCanvas.CopyMode := Graphics.cmSrcCopy;
      end;
    end;
  end;
end;

procedure TWidgetDBForm.vstWidgetListHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if Sender.SortColumn = HitInfo.Column then
    if Sender.SortDirection = sdDescending then
      Sender.SortDirection := sdAscending
    else
      Sender.SortDirection := sdDescending
  else if HitInfo.Column >= 0 then
  begin
    Sender.SortColumn := HitInfo.Column;
    Sender.SortDirection := sdAscending
  end;
  Sender.Treeview.Invalidate;
end;

procedure TWidgetDBForm.vstWidgetListHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
var
  pressedMargin: integer;
  s: string;
begin
  pressedMargin := 0;
  if Pressed then
    pressedMargin := 1;
  if Hover then
  begin
    SkinManager.CurrentSkin.PaintBackground(HeaderCanvas,R,skncHeader,sknsHotTrack,True,True);
    HeaderCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncHeader,sknsHotTrack);
  end
  else if Pressed then
  begin
    SkinManager.CurrentSkin.PaintBackground(HeaderCanvas,R,skncHeader,sknsPushed,True,True);
    HeaderCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncHeader,sknsPushed);
  end
  else
  begin
    SkinManager.CurrentSkin.PaintBackground(HeaderCanvas,R,skncHeader,sknsNormal,True,True);
    HeaderCanvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncHeader,sknsNormal);
  end;
  s := Sender.Columns[Column.Index].Text;

  HeaderCanvas.Brush.Style := Graphics.bsClear;
  if R.Right-R.Left-vstWidgetList.Margin < HeaderCanvas.TextWidth(Sender.Columns[Column.Index].Text) then
    s := ShortenString(HeaderCanvas.Handle, s, R.Right - R.Left-vstWidgetList.Margin, 0);
  HeaderCanvas.TextOut(R.Left+vstWidgetList.Margin+pressedMargin,R.Top+2+pressedMargin,s);
  
  if Sender.SortColumn = Column.Index then
  begin
    MainForm.ArrowList.Draw(HeaderCanvas,R.Left+vstWidgetList.Margin+HeaderCanvas.TextWidth(s)+4,R.Top+1,IFF(Sender.SortDirection = sdAscending,0,1));
  end;
end;

procedure TWidgetDBForm.vstWidgetListCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  widget1,widget2: TWidgetItem;
  i : integer;
begin
  widget1 := GetWidgetByNode(Node1);
  if widget1 = nil then
  begin
    Result := 0;
    Exit;
  end;
  widget2 := GetWidgetByNode(Node2);
  if widget2 = nil then
  begin
    Result := 0;
    Exit;
  end;

  case Column of
    0: Result := Misc.CompareArgs([widget1.Installed,widget1.UpToDate,widget1.Name],[widget2.Installed,widget2.UpToDate,widget2.Name]);
    1: Result := AnsiCompareStr(widget1.Name,widget2.Name);
    2: Result := AnsiCompareStr(widget1.Category.Name,widget2.Category.Name);
    3: Result := CompareValue(widget1.Downloads,widget2.Downloads);
    4: Result := AnsiCompareStr(widget1.Games,widget2.Games);
    5: Result := CompareValue(widget1.Rating,widget2.Rating);
    6: Result := CompareValue(widget1.VoteCount,widget2.VoteCount);
    7: Result := CompareValue(widget1.Comments,widget2.Comments);
    8: Result := AnsiCompareStr(widget1.Author,widget2.Author);
    9: Result := AnsiCompareStr(widget1.Entry,widget2.Entry);
  end;
end;

function TWidgetDBForm.SelectWidget(Node : PVirtualNode): boolean;
var
  widget: TWidgetItem;
begin
  if Node = nil then
    widget := nil
  else
    widget := GetWidgetByNode(Node);

  vstWidgetList.FocusedNode := Node;

  SpTBXSplitter2.Visible := False;
  wbScreenShots.Visible := False;

  if widget = nil then
  begin
    lblWidgetName.Caption := '';
    if wbInitialized then // webbrowser are really created only once the form is shown
      wbDescription.LoadFromString(GetSkinnedHtmlDescription(''));
    reChangelog.Text := '';
    reComments.Text := '';
    result := false;
    Exit;
  end;
  lblWidgetName.Caption := widget.Name;
  if wbInitialized then // webbrowser are really created only once the form is shown
    wbDescription.LoadFromString(GetSkinnedHtmlDescription(widget.Description));
  reChangelog.Clear;
  reChangelog.SelText := widget.Changelog;

  btUninstall.Enabled := widget.Installed;
  btInstall.Enabled := True;
  btRate1.Enabled := True;
  btRate2.Enabled := True;
  btRate3.Enabled := True;
  btRate4.Enabled := True;
  btRate5.Enabled := True;
  if widget.Installed then
    btInstall.Caption := _('Update')
  else
    btInstall.Caption := _('Install');

  uwiThread := TUpdateWidgetInfoThread.Create(false,widget);
end;

function TWidgetDBForm.GetSkinnedHtmlDescription(description: WideString): WideString;
begin
  Result := mmDescriptionHtml.Lines.Text;
  Result := ReplaceCommonVars(Result);
  Result := StringReplace(Result,'$content',description,[rfIgnoreCase, rfReplaceAll]);
end;

procedure TWidgetDBForm.FormShow(Sender: TObject);
begin
  wbInitialized := true;
  tcWidgetInfo.ActivePage := tsWidgetDescription;
  wbDescription.LoadFromString(GetSkinnedHtmlDescription(''));
  if vstWidgetList.FocusedNode = nil then
    vstWidgetList.FocusedNode := vstWidgetList.RootNode.FirstChild;
  SelectWidget(vstWidgetList.FocusedNode);
end;

constructor TUpdateWidgetInfoThread.Create(Suspended : Boolean; widget : TWidgetItem);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   FWidget := widget;
end;

procedure TUpdateWidgetInfoThread.Execute;
var
  xmlDoc : TXMLDocument;
  itemHtml: WideString;
  contentHtml: WideString;
  commentText: WideString;
  fileNode: IXMLNode;
  i: integer;
begin
  CoInitialize(nil);

  xmlDoc := TXMLDocument.Create(WidgetDBForm);
  xmlDoc.FileName := WIDGETDB_MANAGER_URL+'?m=4&id='+IntToStr(FWidget.NameId);
  try
    xmlDoc.Active := True;
  except
    CoUnInitialize;
    AddMainLogThread(_('Widget database server unavailable.'),Colors.Error);
    Exit;
  end;
  xmlDoc.Resync;

  WidgetDBForm.mmScreenshotItemHtml.Lines.BeginUpdate;

  FDisplayWB := False;

  if xmlDoc.DocumentElement.NodeName = 'root' then
  begin
    for i:=0 to xmlDoc.DocumentElement.ChildNodes.Count-1 do
    begin
      fileNode := xmlDoc.DocumentElement.ChildNodes.Get(i);
      if fileNode.NodeName = 'File' then
      begin
        itemHtml := WidgetDBForm.mmScreenshotItemHtml.Lines.Text;
        itemHtml := StringReplace(itemHtml,'$url',fileNode.ChildValues['Url'],[rfIgnoreCase, rfReplaceAll]);
        contentHtml := contentHtml+itemHtml;
        FDisplayWB := True;
      end;
    end;
  end;

  WidgetDBForm.mmScreenshotsHtml.Lines.BeginUpdate;
  FResultHtml := WidgetDBForm.mmScreenshotsHtml.Lines.Text;
  WidgetDBForm.mmScreenshotsHtml.Lines.EndUpdate;
  FResultHtml := WidgetDBForm.ReplaceCommonVars(FResultHtml);
  FResultHtml := StringReplace(FResultHtml,'$content',contentHtml,[rfIgnoreCase, rfReplaceAll]);

  xmlDoc.Destroy;
  if WidgetDBForm.uwiThread <> Self then
  begin
    CoUnInitialize;
    Exit;
  end;
  Synchronize(UpdateWBHtml);

  xmlDoc := TXMLDocument.Create(WidgetDBForm);
  xmlDoc.FileName := WIDGETDB_MANAGER_URL+'?m=16&id='+IntToStr(FWidget.NameId);
  try
    xmlDoc.Active := True;
  except
    CoUnInitialize;
    AddMainLogThread(_('Widget database server unavailable.'),Colors.Error);
    Exit;
  end;
  xmlDoc.Resync;

  FComments := '';

  if xmlDoc.DocumentElement.NodeName = 'root' then
  begin
    for i:=0 to xmlDoc.DocumentElement.ChildNodes.Count-1 do
    begin
      fileNode := xmlDoc.DocumentElement.ChildNodes.Get(i);
      if fileNode.NodeName = 'Comment' then
      begin
        try
          commentText := Format(_('by %s (%s)'),[fileNode.ChildValues['Username'], fileNode.ChildValues['Entry']]);
        except
          commentText := Format('by %s (%s)',[fileNode.ChildValues['Username'], fileNode.ChildValues['Entry']]);
        end;
        commentText := commentText + EOL + '================'+EOL+fileNode.ChildValues['Comment'];
        FComments := FComments+commentText+EOL+EOL;
      end;
    end;
  end;

  xmlDoc.Destroy;
  if WidgetDBForm.uwiThread <> Self then
  begin
    CoUnInitialize;
    Exit;
  end;
  Synchronize(UpdateComments);

  CoUnInitialize;
end;

procedure TUpdateWidgetInfoThread.UpdateComments;
begin
  WidgetDBForm.reComments.Clear;
  WidgetDBForm.reComments.SelText := FComments;
end;

procedure TUpdateWidgetInfoThread.UpdateWBHtml;
begin
  TWinControl(WidgetDBForm.wbScreenShots).Visible := FDisplayWB;
  WidgetDBForm.SpTBXSplitter2.Visible := FDisplayWB;
  if FDisplayWB then
    WidgetDBForm.wbScreenShots.LoadFromString(FResultHtml);
end;

procedure TWidgetDBForm.OnWebBrowsersBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if (LowerCase(URL) = 'about:blank') then Exit;
  Cancel := True;
  Misc.OpenURLInDefaultBrowser(URL);
end;

procedure TWidgetDBForm.OnWebBrowsersNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
  ppDisp := wbScreenShots.DefaultInterface as IDispatch;
end;

function TWidgetDBForm.ReplaceCommonVars(htmlCode: WideString): WideString;
begin
  Result := htmlCode;
  if Preferences.ThemeType = sknSkin then
  begin
    Result := StringReplace(Result,'$bgcolor','#'+Misc.ColorToStandardRGBHex(PreferencesForm.IfNotClNone(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1,clWindow)),[rfIgnoreCase, rfReplaceAll]);
    Result := StringReplace(Result,'$textcolor','#'+Misc.ColorToStandardRGBHex(SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal)),[rfIgnoreCase, rfReplaceAll]);
    Result := StringReplace(Result,'$linkcolor','#'+Misc.ColorToStandardRGBHex(Misc.ComplementaryTextColor(PreferencesForm.IfNotClNone(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1,clWindow))),[rfIgnoreCase, rfReplaceAll]);
  end
  else
  begin
    Result := StringReplace(Result,'$bgcolor','inherit',[rfIgnoreCase, rfReplaceAll]);
    Result := StringReplace(Result,'$textcolor','inherit',[rfIgnoreCase, rfReplaceAll]);
    Result := StringReplace(Result,'$linkcolor','inherit',[rfIgnoreCase, rfReplaceAll]);
  end;
end;

procedure TWidgetDBForm.txtFilterChange(Sender: TObject);
begin
  FilterWidgetListDisplay(txtFilter.Text);
end;

procedure TWidgetDBForm.FilterWidgetListDisplay(filter: WideString);
var
  i,j: integer;
  sl: TWideStringList;
  showWidget: boolean;
begin
  sl := TWideStringList.Create;
  ParseDelimited(sl,filter,' ','');
  vstWidgetList.Clear;
  for i:=0 to widgetList.Count-1 do
  begin
    TWidgetItem(widgetList[i]).Node := nil;
    if (filter = '') then
    begin
      TWidgetItem(widgetList[i]).NodeAdded := True;
      TWidgetItem(widgetList[i]).Node := vstWidgetList.AddChild(vstWidgetList.RootNode);
      TWidgetItem(widgetList[i]).Node.CheckType := ctCheckBox;
      if TWidgetItem(widgetList[i]).Installed then
        TWidgetItem(widgetList[i]).Node.CheckState := csCheckedNormal;
    end
    else
    begin
      showWidget := True;
      for j:=0 to sl.Count-1 do
      begin
        if (sl[j] <> '') and not ((Pos(LowerCase(sl[j]),LowerCase(TWidgetItem(widgetList[i]).Name)) > 0) or
           (Pos(LowerCase(sl[j]),LowerCase(TWidgetItem(widgetList[i]).Games)) > 0) or
           (Pos(LowerCase(sl[j]),LowerCase(TWidgetItem(widgetList[i]).Author)) > 0) or
           (Pos(LowerCase(sl[j]),LowerCase(TWidgetItem(widgetList[i]).Category.Name)) > 0) or
           (Pos(LowerCase(sl[j]),LowerCase(TWidgetItem(widgetList[i]).Description)) > 0)) then
        begin
          showWidget := False;
          break;
        end;
      end;
      if showWidget then
      begin
          TWidgetItem(widgetList[i]).NodeAdded := True;
          TWidgetItem(widgetList[i]).Node := vstWidgetList.AddChild(vstWidgetList.RootNode);
          TWidgetItem(widgetList[i]).Node.CheckType := ctCheckBox;
          if TWidgetItem(widgetList[i]).Installed then
            TWidgetItem(widgetList[i]).Node.CheckState := csCheckedNormal;
      end;
    end;
    TWidgetItem(widgetList[i]).NodeAdded := False;
  end;
end;

procedure TWidgetDBForm.txtFilterSubEditButton0Click(Sender: TObject);
begin
  txtFilter.Text := '';
end;

function TWidgetDBForm.GetCategoryById(id: integer): TWidgetCategory;
var
  i: Integer;
begin
  Result := noneCategory;
  for i:=0 to widgetCategoryList.Count-1 do
    if TWidgetCategory(widgetCategoryList[i]).Id = id then
    begin
      Result := widgetCategoryList[i];
      Exit;
    end;
end;

procedure TRefreshWidgetListThread.Execute;
var
  xmlDoc : TXMLDocument;
  i: integer;
  widgetNode : IXMLNode;
  categoryNode : IXMLNode;
  fileNode: IXMLNode;
  widgetItem : TWidgetItem;
  categoryItem : TWidgetCategory;
  tmpStr: WideString;
  idStrList: TStringList;
begin
  CoInitialize(nil);

  with WidgetDBForm do
  begin

  vstWidgetList.Clear;
  widgetList.Clear;
  widgetCategoryList.Clear;
  idStrList := TStringList.Create;

  // get widget category list
  xmlDoc := TXMLDocument.Create(WidgetDBForm);
  xmlDoc.FileName := WIDGETDB_MANAGER_URL+'?m=20';
  try
    xmlDoc.Active := True;
  except
    AddMainLogThread(_('Widget database server unavailable.'),Colors.Error);
    Synchronize(UpdateList);
    Exit;
  end;

  if xmlDoc.DocumentElement.NodeName = 'root' then
  begin
    for i:=0 to xmlDoc.DocumentElement.ChildNodes.Count-1 do
    begin
      categoryNode := xmlDoc.DocumentElement.ChildNodes.Get(i);
      if categoryNode.NodeName = 'Category' then
      begin
        categoryItem := TWidgetCategory.Create;
        try
          categoryItem.Id := categoryNode.Attributes['ID'];
          categoryItem.Name := categoryNode.ChildValues['Name'];
          widgetCategoryList.Add(categoryItem);
        except
          categoryItem.Destroy;
        end;
      end;
    end;
  end;
  xmlDoc.Destroy;

  // get widgets info
  xmlDoc := TXMLDocument.Create(WidgetDBForm);
  xmlDoc.FileName := WIDGETDB_MANAGER_URL+'?m=0';
  try
    xmlDoc.Active := True;
  except
    AddMainLogThread(_('Widget database server unavailable.'),Colors.Error);
    Synchronize(UpdateList);
    Exit;
  end;

  if xmlDoc.DocumentElement.NodeName = 'root' then
  begin
    for i:=0 to xmlDoc.DocumentElement.ChildNodes.Count-1 do
    begin
      widgetNode := xmlDoc.DocumentElement.ChildNodes.Get(i);
      if widgetNode.NodeName = 'Widget' then
      begin
        widgetItem := TWidgetItem.Create;
        try
          widgetItem.NodeAdded := False;
          widgetItem.UpToDate := True;
          widgetItem.Id := widgetNode.Attributes['ID'];
          widgetItem.VoteCount := widgetNode.ChildValues['VoteCount'];
          if widgetItem.VoteCount > 0 then
            widgetItem.Rating := widgetNode.ChildValues['Rating']
          else
            widgetItem.Rating := -1;
          widgetItem.Name := widgetNode.ChildValues['Name'];
          widgetItem.NameId := widgetNode.ChildValues['NameId'];
          widgetItem.Downloads := widgetNode.ChildValues['DownloadCount'];
          try
            widgetItem.Games := widgetNode.ChildValues['Mods'];
          except
          end;
          widgetItem.Comments := widgetNode.ChildValues['CommentCount'];
          widgetItem.Author := widgetNode.ChildValues['Author'];
          try
            widgetItem.Description := widgetNode.ChildValues['Description'];
          except
          end;
          widgetItem.Entry := widgetNode.ChildValues['Entry'];
          try
            widgetItem.Changelog := widgetNode.ChildValues['Changelog'];
          except
          end;
          try
            widgetItem.Category := GetCategoryById(widgetNode.ChildValues['CategoryId']);
          except
            widgetItem.Category := noneCategory;
          end;
          widgetList.Add(widgetItem);
          idStrList.Add(IntToStr(widgetItem.Id));
          widgetItem.Node := nil;
        except
          widgetItem.Destroy;
        end;
      end;
    end;
  end;
  xmlDoc.Destroy;

  // check installed widgets
  xmlDoc := TXMLDocument.Create(WidgetDBForm);
  xmlDoc.FileName := WIDGETDB_MANAGER_URL+'?m=17&ids='+idStrList.CommaText;
  try
    xmlDoc.Active := True;
  except
    AddMainLogThread(_('Widget database server unavailable.'),Colors.Error);
    Exit;
  end;

  if xmlDoc.DocumentElement.NodeName = 'root' then
  begin
    for i:=0 to xmlDoc.DocumentElement.ChildNodes.Count-1 do
    begin
      fileNode := xmlDoc.DocumentElement.ChildNodes.Get(i);
      if fileNode.NodeName = 'File' then
      begin
        try
          tmpStr := StringReplace(fileNode.ChildValues['LocalPath'],'/','\',[rfReplaceAll]);
          if tmpStr[1] = '\' then
            tmpStr := MidStr(tmpStr,2,MaxInt);
          tmpStr := ExtractFilePath(Application.ExeName)+tmpStr;

          widgetItem := GetWidgetById(fileNode.ChildValues['LuaId']);
          if not FileExists(tmpStr) then
            widgetItem.UpToDate := False
          else if LowerCase(GetFileMD5Hash(tmpStr)) <> LowerCase(fileNode.ChildValues['MD5']) then
            widgetItem.UpToDate := False;

          if (LowerCase(ExtractFileExt(tmpStr)) = '.lua') and (LowerCase(ExtractFilePath(tmpStr)) = LowerCase(ExtractFilePath(Application.ExeName)+'LuaUI\Widgets\')) and FileExists(tmpStr) then
            widgetItem.Installed := True;
        except
        end;
      end;
    end;
  end;

  Synchronize(UpdateList);

  end;
  CoUnInitialize;

end;
procedure TRefreshWidgetListThread.UpdateList;
begin
  WidgetDBForm.FilterWidgetListDisplay(WidgetDBForm.txtFilter.Text);
  WidgetDBForm.SelectWidget(WidgetDBForm.vstWidgetList.RootNode.FirstChild);
  WidgetDBForm.btRefresh.Caption := _('Refresh');
  WidgetDBForm.btRefresh.Enabled := True;

  LobbyScriptUnit.RefreshWidgetListAction := false;

  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onWidgetListRefreshed(); except end;
  ReleaseMainThread;

  LobbyScriptUnit.ExecuteNextWidgetAction;
end;
constructor TRefreshWidgetListThread.Create(Suspended : Boolean);
begin
  FreeOnTerminate := True;
  inherited Create(Suspended);
end;

procedure TWidgetDBForm.btRefreshClick(Sender: TObject);
var
  refreshThread: TRefreshWidgetListThread;
begin
  if not btRefresh.Enabled then Exit;
  SelectWidget(nil);
  btRefresh.Enabled := False;
  btInstall.Enabled := False;
  btUninstall.Enabled := False;
  btRate1.Enabled := False;
  btRate2.Enabled := False;
  btRate3.Enabled := False;
  btRate4.Enabled := False;
  btRate5.Enabled := False;
  btRefresh.Caption := _('Refreshing ...');
  refreshThread := TRefreshWidgetListThread.Create(False);
end;

procedure TWidgetDBForm.vstWidgetListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  SelectWidget(vstWidgetList.FocusedNode);
end;

procedure TWidgetDBForm.btInstallClick(Sender: TObject);
var
  widget: TWidgetItem;
begin
  if not btInstall.Enabled then Exit;
  widget := GetWidgetByNode(vstWidgetList.FocusedNode);
  if widget <> nil then
  begin
    btInstall.Enabled := False;
    btRefresh.Enabled := False;
    if widget.Installed then
      btInstall.Caption := _('Updating ...')
    else
      btInstall.Caption := _('Installing ...');

    TInstallWidgetThread.Create(false,widget,false);
  end;
end;

procedure TInstallWidgetThread.Execute;
var
  xmlDoc : TXMLDocument;
  i: integer;
  fileNode : IXMLNode;
  httpCli: THttpCli;
  filePath: WideString;
  dlFailed: Boolean;
  successfullyInstalledFiles: TWideStringList;
  url: string;
begin
  CoInitialize(nil);

  xmlDoc := TXMLDocument.Create(WidgetDBForm);
  xmlDoc.FileName := WIDGETDB_MANAGER_URL+'?m=1&id='+IntToStr(FWidget.Id);
  try
    xmlDoc.Active := True;
  except
    AddMainLogThread(_('Widget database server unavailable.'),Colors.Error);
    Exit;
  end;

  httpCli := THttpCli.Create(WidgetDBForm);
  dlFailed := False;
  successfullyInstalledFiles := TWideStringList.Create;

  if xmlDoc.DocumentElement.NodeName = 'root' then
  begin
    try
      for i:=0 to xmlDoc.DocumentElement.ChildNodes.Count-1 do
      begin
        fileNode := xmlDoc.DocumentElement.ChildNodes.Get(i);
        if fileNode.NodeName = 'File' then
        begin
          try
            filePath := StringReplace(fileNode.ChildValues['LocalPath'],'/','\',[rfReplaceAll]);
            if filePath[1] = '\' then
              filePath := MidStr(filePath,2,MaxInt);
            filePath := ExtractFilePath(Application.ExeName)+filePath;

            if FUninstall then
            begin
              if FileExists(filePath) then
                DeleteFile(filePath);
            end
            else
            begin
              url := fileNode.ChildValues['Url'];
              FixURL(url);
              httpCli.URL := url;
              Misc.MakePath(ExtractFilePath(filePath));
              httpCli.RcvdStream := TFileStream.Create(filePath,fmCreate or fmOpenWrite);
              try
                httpCli.Get;
                httpCli.RcvdStream.Free;
                successfullyInstalledFiles.Add(filePath);
              except
                on E:Exception do
                begin
                  httpCli.RcvdStream.Free;
                  DeleteFile(filePath);
                  raise Exception.Create('HttpGet failed ('+httpCli.URL+'): '+E.Message);
                end;
              end;
            end;
          except
            on E:Exception do
            begin
              if FUninstall then
                AddMainLogThread('Error: Widget uninstallation failed: '+E.Message,Colors.Error)
              else
                AddMainLogThread('Error: Widget installation failed: '+E.Message,Colors.Error);
              dlFailed := True;
              raise Exception.Create(E.Message);
            end;
          end;
        end;
      end;
    except
    end;
    if dlFailed then
    begin
      if not FUninstall then
      begin
        for i:=0 to successfullyInstalledFiles.Count-1 do
          try
            DeleteFile(successfullyInstalledFiles[i]);
          except
            on E:Exception do
            begin
              AddMainLogThread('Error: '+E.Message,Colors.Error);
            end;
          end;
      end;
    end
    else
    begin
      if FUninstall then
      begin
        FWidget.Installed := False;
        if FWidget.Node <> nil then
          FWidget.Node.CheckState := csUncheckedNormal;
      end
      else
      begin
        httpCli.URL := WIDGETDB_MANAGER_URL+'?m=5&id='+IntToStr(FWidget.Id);
        httpCli.RcvdStream := TMemoryStream.Create;
        try
          httpCli.Get;
          httpCli.RcvdStream.Free;
        except
          on E:Exception do
          begin
            AddMainLogThread('Error: Download increment failed : '+E.Message,Colors.Error);
          end;
        end;

        FWidget.Installed := True;
        FWidget.UpToDate := True;
        if FWidget.Node <> nil then
          FWidget.Node.CheckState := csCheckedNormal;
      end;
    end;
  end;

  httpCli.Destroy;
  xmlDoc.Destroy;

  Synchronize(UpdateGUI);

  CoUnInitialize;
end;

procedure TInstallWidgetThread.UpdateGUI;
var
  widget: TWidgetItem;
begin
  widget := WidgetDBForm.GetWidgetByNode(WidgetDBForm.vstWidgetList.FocusedNode);
  if widget <> nil then
  begin
    if widget.Installed then
      WidgetDBForm.btInstall.Caption := _('Update')
    else
      WidgetDBForm.btInstall.Caption := _('Install');
  end;
  WidgetDBForm.btRefresh.Enabled := True;
  WidgetDBForm.btInstall.Enabled := True;
  WidgetDBForm.btUninstall.Enabled := widget.Installed;
  WidgetDBForm.btUninstall.Caption := _('Uninstall');
  WidgetDBForm.vstWidgetList.Invalidate;

  if FUninstall then
  begin
    AcquireMainThread;
    try if not Preferences.ScriptsDisabled then handlers.onWidgetUninstalled(FWidget.Id); except end;
    ReleaseMainThread;
  end
  else
  begin
    AcquireMainThread;
    try if not Preferences.ScriptsDisabled then handlers.onWidgetInstalledOrUpdated(FWidget.Id,FUpdating); except end;
    ReleaseMainThread;
  end;
  LobbyScriptUnit.ExecuteNextWidgetAction;
end;

constructor TInstallWidgetThread.Create(Suspended : Boolean; widget : TWidgetItem; uninstall: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(Suspended);
  FWidget := widget;
  FUninstall := uninstall;
  FUpdating := widget.Installed;
end;

procedure TWidgetDBForm.btUninstallClick(Sender: TObject);
var
  widget: TWidgetItem;
begin
  if not btUninstall.Enabled then Exit;
  widget := GetWidgetByNode(vstWidgetList.FocusedNode);
  if widget <> nil then
  begin
    if widget.Installed then
    begin
      btUninstall.Enabled := False;
      btRefresh.Enabled := False;
      btUninstall.Caption := _('Uninstalling ...');
      TInstallWidgetThread.Create(false,widget,true);
    end
    else
    begin
      btUninstall.Caption := _('Uninstall'); // should not happen
      Raise Exception.Create('Uninstall button enabled on a widget not installed');
    end;
  end;
end;

procedure TSendCommentThread.Execute;
var
  ResponseStream: TMemoryStream;
  ResponseStr : string;
  MultiPartFormDataStream: TMsMultiPartFormDataStream;
  idHttp: TIdHTTP;
  sendFailed: Boolean;
begin
  MultiPartFormDataStream := TMsMultiPartFormDataStream.Create;
  ResponseStream := TMemoryStream.Create;
  idHttp := TIdHTTP.Create(WidgetDBForm);
  sendFailed := False;
  try
    idHttp.Request.ContentType := MultiPartFormDataStream.RequestContentType;

    MultiPartFormDataStream.AddFormField('c', FComment);
    { You must make sure you call this method *before* sending the stream }
    MultiPartFormDataStream.PrepareStreamForDispatch;
    MultiPartFormDataStream.Position := 0;

    idHttp.Post(WIDGETDB_MANAGER_URL+'?m=15&id='+IntToStr(FWidget.NameId)+'&uname='+Preferences.Username+'&pw='+Preferences.Password, MultiPartFormDataStream, ResponseStream);
    ResponseStream.Seek(0,0);
    SetLength(ResponseStr, ResponseStream.Size);
    ResponseStream.ReadBuffer(Pointer(ResponseStr)^, ResponseStream.Size);
  except
    AddMainLogThread(_('Error: Failed to send the widget comment.'),Colors.Error);
    sendFailed := True;
  end;
  MultiPartFormDataStream.Free;
  ResponseStream.Free;
  if not sendFailed then
  begin
    if ResponseStr = 'Rejected!' then
    begin
      AddMainLogThread(_('Error: Widget comment rejected.'),Colors.Error);
    end
    else if ResponseStr = 'Commented!' then
    begin
      // nothing
    end
    else
    begin
      AddMainLogThread(_('Error: ')+ResponseStr,Colors.Error);
    end;
  end;

  Synchronize(UpdateGUI);
end;
procedure TSendCommentThread.UpdateGUI;
begin
  WidgetDBForm.btSendComment.Enabled := True;
  WidgetDBForm.btSendComment.Caption := _('Send');
  WidgetDBForm.btRefresh.Enabled := True;
  WidgetDBForm.reMyComment.Text := '';
  WidgetDBForm.reMyComment.Enabled := True;
  WidgetDBForm.SelectWidget(WidgetDBForm.vstWidgetList.FocusedNode);

  LobbyScriptUnit.ExecuteNextWidgetAction;
end;
constructor TSendCommentThread.Create(Suspended : Boolean; widget : TWidgetItem; comment: WideString);
begin
  FreeOnTerminate := True;
  inherited Create(Suspended);
  FWidget := widget;
  FComment := comment
end;

procedure TWidgetDBForm.btSendCommentClick(Sender: TObject);
var
  widget: TWidgetItem;
begin
  if not btSendComment.Enabled then Exit;
  if not PreferencesForm.isLoggedOnOfficialServer then
  begin
    MessageDlg(_('You need to be logged into the official server to be able to post a comment about this widget.'),mtWarning,[mbOk],0);
    Exit;
  end;

  widget := GetWidgetByNode(vstWidgetList.FocusedNode);
  if (widget <> nil) and (reMyComment.Text <> '') then
  begin
    btSendComment.Enabled := False;
    btRefresh.Enabled := False;
    reMyComment.Enabled := False;
    btSendComment.Caption := _('Sending ...');

    TSendCommentThread.Create(false,widget,reMyComment.Text);
  end;
end;

procedure TRateThread.Execute;
var
  ResponseStream: TMemoryStream;
  ResponseStr : string;
  MultiPartFormDataStream: TMsMultiPartFormDataStream;
  idHttp: TIdHTTP;
  sendFailed: Boolean;
begin
  MultiPartFormDataStream := TMsMultiPartFormDataStream.Create;
  ResponseStream := TMemoryStream.Create;
  idHttp := TIdHTTP.Create(WidgetDBForm);
  sendFailed := False;
  try
    idHttp.Request.ContentType := MultiPartFormDataStream.RequestContentType;
    { You must make sure you call this method *before* sending the stream }
    MultiPartFormDataStream.PrepareStreamForDispatch;
    MultiPartFormDataStream.Position := 0;

    idHttp.Post(WIDGETDB_MANAGER_URL+'?m=14&id='+IntToStr(FWidget.NameId)+'&uname='+Preferences.Username+'&pw='+Preferences.Password+'&r='+IntToStr(FRate), MultiPartFormDataStream, ResponseStream);
    ResponseStream.Seek(0,0);
    SetLength(ResponseStr, ResponseStream.Size);
    ResponseStream.ReadBuffer(Pointer(ResponseStr)^, ResponseStream.Size);
  except
    AddMainLogThread(_('Error: Failed to rate the widget.'),Colors.Error);
    sendFailed := True;
  end;
  MultiPartFormDataStream.Free;
  ResponseStream.Free;
  if not sendFailed then
  begin
    if ResponseStr = 'Rejected!' then
    begin
      AddMainLogThread(_('Error: Widget rate rejected.'),Colors.Error);
    end
    else if ResponseStr = 'Rated!' then
    begin
      // nothing
    end
    else
    begin
      AddMainLogThread(_('Error: Widget rating error : ')+ResponseStr,Colors.Error);
    end;
  end;

  Synchronize(UpdateGUI);
end;
procedure TRateThread.UpdateGUI;
begin
  WidgetDBForm.gbRate.Enabled := True;
  WidgetDBForm.gbRate.Caption := _('Rate');
  WidgetDBForm.btRate1.Enabled := True;
  WidgetDBForm.btRate2.Enabled := True;
  WidgetDBForm.btRate3.Enabled := True;
  WidgetDBForm.btRate4.Enabled := True;
  WidgetDBForm.btRate5.Enabled := True;
  WidgetDBForm.btRefresh.Enabled := True;
end;
constructor TRateThread.Create(Suspended : Boolean; widget : TWidgetItem; rate: Byte);
begin
  FreeOnTerminate := True;
  inherited Create(Suspended);
  FWidget := widget;
  FRate := rate;
end;

procedure TWidgetDBForm.RateWidget(rate: Byte);
var
  widget: TWidgetItem;
begin
  if not btSendComment.Enabled then Exit;
  if not PreferencesForm.isLoggedOnOfficialServer then
  begin
    MessageDlg(_('You need to be logged into the official server to be able to rate a widget.'),mtWarning,[mbOk],0);
    Exit;
  end;

  widget := GetWidgetByNode(vstWidgetList.FocusedNode);
  if (widget <> nil) and (rate > 0) and (rate < 6) then
  begin
    gbRate.Enabled := False;
    btRate1.Enabled := False;
    btRate2.Enabled := False;
    btRate3.Enabled := False;
    btRate4.Enabled := False;
    btRate5.Enabled := False;
    btRefresh.Enabled := False;
    gbRate.Caption := _('Rating ...');

    TRateThread.Create(false,widget,rate);
  end;
end;

procedure TWidgetDBForm.btRate1Click(Sender: TObject);
begin
  RateWidget(1);
end;

procedure TWidgetDBForm.btRate2Click(Sender: TObject);
begin
  RateWidget(2);
end;

procedure TWidgetDBForm.btRate3Click(Sender: TObject);
begin
  RateWidget(3);
end;

procedure TWidgetDBForm.btRate4Click(Sender: TObject);
begin
  RateWidget(4);
end;

procedure TWidgetDBForm.btRate5Click(Sender: TObject);
begin
  RateWidget(5);
end;

procedure TWidgetDBForm.vstWidgetListPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Column = 1 then
  begin
    TargetCanvas.Font.Style := [fsBold];
  end
  else
  begin
    TargetCanvas.Font.Style := [];
  end;
  inherited;
end;

procedure TWidgetDBForm.vstWidgetListChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
begin
  Allowed := False;
end;

procedure TWidgetDBForm.vstWidgetListGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
  widgetItem: TWidgetItem;
begin
  vstWidgetListGetText(Sender,Node,Column,ttNormal,HintText);
  if Column = 0 then
  begin
    widgetItem := GetWidgetByNode(Node);
    if widgetItem.Installed then
      if widgetItem.UpToDate then
        HintText := _('You have the latest version of this widget installed')
      else
        HintText := _('You have an outdated or an unknown version of this widget installed')
    else
      HintText := _('You don''t have this widget installed at all');
  end;
end;

end.
