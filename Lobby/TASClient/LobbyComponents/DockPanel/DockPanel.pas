{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-f,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{-------------------------------------------------------------------------------
   This is a modified version of the dockpanel originally written for the
  OpenPerl IDE. It's been made to be as easy to use as physicly possible,
  handling a lot of the stuff for you.
}
{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: DockPanel.pas, released 04 Nov 2001.

The Initial Developer of the Original Code is Jürgen Güntherodt.

Portions created by Jürgen Güntherodt <jguentherodt@users.sourceforge.net>
are Copyright (C) 2001-2002 Jürgen Güntherodt. All Rights Reserved.

Contributor: Stefan Ascher <stievie@users.sourceforge.net>

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: DockPanel.pas,v 1.4 2002/05/26 13:47:35 jguentherodt Exp $

You may retrieve the latest version of this file at the Open Perl IDE webpage,
located at http://open-perl-ide.sourceforge.net or http://www.lost-sunglasses.de
-------------------------------------------------------------------------------}
unit DockPanel;

interface

uses
  extCtrls, controls, classes, windows, comCtrls, forms, sysUtils,SpTBXTabs,
  graphics, messages, ImgList, iniFiles, registry, commctrl, StrUtils,
  SpTBXItem,SpTBXSkins, Math;

Type TTabType=(ttText, ttTextIcon, ttIcon);

type
  TCustomDockTree = class(TDockTree)
  protected
    procedure PaintDockFrame(Canvas: TCanvas; Control: TControl; const ARect: TRect); override;
  public
    constructor Create(DockSite: TWinControl);
  end;

  TPageControl = class(ComCtrls.TPageControl)
  protected
    FAutoDrawTab: Boolean;
    procedure SetAutoDrawTab(const Value: Boolean);
    procedure CMMouseLeave(var Msg: TMessage); message CM_MouseLeave;
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure WMPaint(var msg: TWMPaint); message WM_PAINT;
  public
    constructor Create(AOwner: TComponent); override;
    property AutoDrawTab: Boolean read FAutoDrawTab write SetAutoDrawTab;
  end;

  TDockHandler = class;
  TPageControlHost = class;
  TDockPanel = class(TPanel)
  private
    m_iWidth: Integer;
    m_bUnDocking: Boolean;
    TabPos: TTabPosition;
    m_iMinSize: Integer;
    m_bDockOnPageControl: Boolean;
    pSizer: TSplitter;
  protected
    procedure PSizerMoved(Sender: TObject);
    function CreateDockManager: IDockManager; override;
    procedure DockOver(Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure UnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
    procedure DoEndDock(Target: TObject; X, Y: Integer); override;
    procedure GetSiteInfo(Client: TControl; var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean); override;
    procedure DoStartDock(var DragObject: TDragObject); override;
    function DoUnDock(NewTarget: TWinControl; Client: TControl): Boolean; override;
    procedure Resize(Sender: TObject);
    function GetAsString: String; virtual;
    procedure SetAsString(s: String); virtual;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DockDrop(Source: TDragDockObject; X, Y: Integer); override;
    property AsString: String Read GetAsString Write SetAsString;
    property MinSizeWidth: Integer Read m_iMinSize Write m_iMinSize;
  published
    property TabPosition: TTabPosition read TabPos write TabPos;
  end;


  TSetOtherHostAsStringEvent = procedure(Sender: TDockHandler; sValue: String) of object;
  TGetOtherHostAsStringEvent = function(Sender: TDockHandler): String of object;

  TDockHandler = class
  private
    m_iMinSize: Integer;
    b_ShowGrabberBars: Boolean;
    m_slDockPanels: TStringList;
    m_slPageControlHosts: TStringList;
    m_slDockClients: TStringList;
    m_lSimpleDockPanels: TList;
    m_OnRefresh: TNotifyEvent;
    m_slDockHosts: TStringList;
    m_Owner: TComponent;
    m_OnSetOtherHostsAsString: TSetOtherHostAsStringEvent;
    m_OnGetOtherHostsAsString: TGetOtherHostAsStringEvent;
    m_pcShadow: TPageControl;
    TType: TTabType;
    m_nLockRefreshCount: Integer;
    function GetDockPanelCount: Integer;
    procedure SetTType(s: TTabType); Virtual;
    function GetDockPanels(i: Integer): TDockPanel;
    function GetPageControlHostCount: Integer;
    function GetPageControlHosts(i: Integer): TPageControlHost;
    function GetDockHostCount: Integer;
    function GetDockHosts(i: Integer): TWinControl;
    function GetDockClientCount: Integer;
    function GetDockClients(i: Integer): TWinControl;
    procedure BuildOldPageControl(sAlign, sData: String);
    procedure DoRefresh; virtual;
    procedure DoSetOtherHostsAsString(sValue: String);
    function DoGetOtherHostsAsString: String;
  protected
    function GetAsString: String; virtual;
    procedure SetAsString(s: String); virtual;
    procedure RegisterDockPanel(pnl: TDockPanel); virtual;
    procedure UnRegisterDockPanel(pnl: TDockPanel); virtual;
    procedure UnregisterPageControlHost(pch: TPageControlHost); virtual;
    procedure RegisterPageControlHost(pch: TPageControlHost); virtual;
    procedure RegisterDockClient(ctrl: TControl); virtual;
    procedure UnRegisterDockClient(ctrl: TControl); virtual;


  public
    bLoadSuccess: Boolean;

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure LockRefresh;
    procedure UnlockRefresh;
    procedure UnRegisterDockHost(wctrl: TWinControl);
    procedure SaveDesktop(regPath: String);
    procedure LoadDesktop(regPath: string; defaultLayout: string);
    procedure RegisterDockHost(wctrl: TWinControl);
    procedure Refresh;
    property DockClientCount: Integer Read GetDockClientCount;
    property DockClients[i: Integer]: TWinControl Read GetDockClients;
    property DockHostCount: Integer Read GetDockHostCount;
    property DockHosts[i: Integer]: TWinControl Read GetDockHosts;
    property DockPanelCount: Integer Read GetDockPanelCount;
    property DockPanels[i: Integer]: TDockPanel Read GetDockPanels;
    property PageControlHostCount: Integer Read GetPageControlHostCount;
    property PageControlHosts[i: Integer]: TPageControlHost Read GetPageControlHosts;
    property AsString: String Read GetAsString Write SetAsString;
    property Owner: TComponent Read m_Owner;

    property ShowGrabberBars: Boolean Read b_ShowGrabberBars Write b_ShowGrabberBars;

    property OnRefresh: TNotifyEvent Read m_OnRefresh Write m_OnRefresh;
    property OnSetOtherHostsAsString: TSetOtherHostAsStringEvent Read m_OnSetOtherHostsAsString Write m_OnSetOtherHostsAsString;
    property OnGetOtherHostsAsString: TGetOtherHostAsStringEvent Read m_OnGetOtherHostsAsString Write m_OnGetOtherHostsAsString;
    property TabType: TTabType Read TType Write SetTType;

    procedure AddDockedPanelsToList(var l: TList;recursive: TControl=nil);
    procedure RegisterSpecialDockClient(ctrl: TWinControl);
  end;
  TPageControlHost = class(TForm)
    PageControl: TPageControl;
    tmr: TTimer;
    img: TImageList;
    procedure PageControlUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure tmrTimer(Sender: TObject);
    procedure PageControlGetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    procedure PageControlDockDrop(Sender: TObject; Source: TDragDockObject;
      X, Y: Integer);
    procedure PageControlChange(Sender: TObject);
    procedure PageControlDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
  private
    { Private declarations }
    m_bOnClose: Boolean;
    function GetVisibleDockClientCount: Integer;
//    procedure TextRotate(const S: string; x,y, deg : integer);
  protected
    function GetAsString: String; virtual;
    procedure SetAsString(s: String); virtual;
    procedure DoShow; override;
    procedure DoHide; override;
    procedure DoStartDock(var DragObject: TDragObject); override;
    procedure DoEndDock(Target: TObject; X, Y: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AsString: String Read GetAsString Write SetAsString;
  end;

  TDockableForm = class(TForm)
  private
    m_CaptionPanel: TPanel;
    m_LastHostDockSiteClass: TClass;
    SizePer: Integer;
    function GetVisible: Boolean;
    procedure SetVisible(b: Boolean);
  protected
    function GetAsString: String; virtual;
    procedure SetAsString(s: String); virtual;
    procedure DoEndDock(Target: TObject; X, Y: Integer); override;
    procedure DoShow; override;
    procedure DoHide; override;
    property AsString: String Read GetAsString Write SetAsString;
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer); override;
    destructor Destroy; override;
    procedure RefreshCaption; virtual;
    property Visible: Boolean Read GetVisible Write SetVisible;
    property LastHostDockSiteClass: TClass Read m_LastHostDockSiteClass;
  end;

  var
  bDontSize: BOolean;

function DockHandler(AOwner: TComponent = nil): TDockHandler;


procedure Register;


implementation

{$R *.DFM}
// {$R F_DOCKABLEFORM.DFM}

const
  InternalDockHandler: TDockHandler = nil;


procedure Register;
begin
  RegisterComponents('DockPanel', [TDockPanel]);
end;


function GetVisibleDockClientCount(win: TWinControl): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to win.DockClientCount - 1 do begin
    if win.DockClients[i].Visible then inc(Result);
  end;
end;


function DockHandler(AOwner: TComponent = nil): TDockHandler;
begin
  if InternalDockHandler = nil then InternalDockHandler := TDockHandler.Create(AOwner);
  Result := InternalDockHandler;
end;

procedure ParseDelimited(const sl : TStrings; const value : string; const delimiter : string;const delimiter2: string) ;
  var
   dx : integer;
   ns : string;
   txt : string;
   delta,delta1,delta2 : integer;
  begin
   delta1 := Length(delimiter) ;
   delta2 := Length(delimiter2) ;
   txt := value + delimiter;
   sl.BeginUpdate;
   sl.Clear;
   try
     while Length(txt) > 0 do
     begin
       dx := Pos(delimiter, txt) ;
       delta := delta1;
       if (delta2 > 0) and (Pos(delimiter2,txt) < dx) and (Pos(delimiter2,txt) > 0) then
       begin
        dx := Pos(delimiter2,txt);
        delta := delta2;
       end;
       ns := Copy(txt,0,dx-1) ;
       sl.Add(ns) ;
       txt := Copy(txt,dx+delta,MaxInt) ;
     end;
   finally
     sl.EndUpdate;
   end;
  end;
function JoinStringList(sl : TStrings;delimiter: String;startIndex: integer = 0):String;
var
  i:integer;
begin
  Result := '';
  for i:=startIndex to sl.Count-1 do
    if i = sl.Count-1 then
      Result := Result+sl[i]
    else
      Result := Result+sl[i]+delimiter;
  if RightStr(Result,Length(delimiter)) = delimiter then
    Delete(Result,Length(Result)-Length(delimiter),Length(delimiter));
end;

function GetComponentNameFromString(component: string):string;
var
  i: integer;
begin
  i := StrLen(PChar(Component))-1;
  while (i>=0) and (component[i] <> '.') do
    Dec(i);
  Result := MidStr(component,i+1,9999);
end;

function GetComponentOwnerFromString(component: string):string;
var
  i: integer;
begin
  i := 0;
  while (i<StrLen(PChar(Component))) and (component[i] <> '.') do
    Inc(i);
  Result := LeftStr(component,i-1);
end;

function GetComponentFromString(component: string): TComponent;
var
  c: TComponent;
  componentList: TStringList;
  i: integer;
begin
  Result := nil;
  componentList := TStringList.Create;

  ParseDelimited(componentList,component,'.','');

  if componentList.Count = 0 then
    Exit;

  c := Application;
  for i:=0 to componentList.Count-1 do
    c := c.FindComponent(componentList[i]);

  Result := c;
end;

function GetStringFromComponent(component : TComponent): string;
var
  c : TComponent;
  sl: TStringList;
begin
  if component = nil then
  begin
    Result := '';
    Exit;
  end;
  
  sl := TStringList.Create;
  c := component;

  sl.Add(c.Name);
  while c.Owner.ClassType <> TApplication do
  begin
    sl.Insert(0,c.Owner.Name);
    c := c.Owner;
  end;

  Result := JoinStringList(sl,'.');
end;


function StrToBool(s: String): Boolean;
begin
  if s = 'FALSE' then Result := False else Result := True;
end;

function BoolToStr(b: Boolean): String;
begin
  if b then Result := 'TRUE' else Result := 'FALSE';
end;

procedure SetWinControlAsString(c: TWinControl; s:String);
var
  sl: TStringList;
  nLeft, nTop, nWidth, nHeight: Integer;
  bFloating: Boolean;
begin
  sl := TStringList.Create;
  sl.CommaText := s;
  nLeft := StrToIntDef(sl.Values['Left'], 0);
  nTop := StrToIntDef(sl.Values['Top'], 0);
  nWidth := StrToIntDef(sl.Values['Width'], 200);
  nHeight := StrToIntDef(sl.Values['Height'], 200);
  c.BoundsRect := Rect(nLeft, nTop, nLeft + nWidth, nTop + nHeight);
  bFloating := StrToBool(sl.Values['Floating']);
  if not bFloating then c.ManualDock(DockHandler.m_pcShadow);
  c.Visible := StrToBool(sl.Values['Visible']);
  if (sl.Values['Owner'] <> '') and (sl.Values['Owner'] <> c.Owner.Name) then
  begin
    c.Owner.RemoveComponent(c);
    TCustomForm(GetComponentFromString(sl.Values['Owner'])).InsertComponent(c);
  end;
  sl.Free;
end;

function GetWinControlAsString(c: TWinControl):String;
var
  sl: TStringList;
  pt: TPoint;
  p: TControl;
begin
  sl := TStringList.Create;
  pt := Point(c.Left, c.Top);
  if c.HostDockSite <> nil then pt := c.HostDockSite.ClientToScreen(pt);
  sl.Values['Left'] := IntToStr(pt.x);
  sl.Values['Top'] := IntToStr(pt.y);
  sl.Values['Width'] := IntToStr(c.Width);
  sl.Values['Height'] := IntToStr(c.Height);
  sl.Values['Visible'] := BoolToStr(c.Visible);
  sl.Values['Floating'] := BoolToStr(c.HostDockSite = nil);
  sl.Values['Owner'] := GetComponentOwnerFromString(GetStringFromComponent(c.Parent));

  Result := sl.CommaText;
  sl.Free;
end;


////////////////////////////////////////////////////////////////////////////////
//  TDockHandler = class(TComponent)
////////////////////////////////////////////////////////////////////////////////
constructor TDockHandler.Create(AOwner: TComponent);
begin
  inherited Create;
  m_Owner  := AOwner;
  if not (csDesigning in m_Owner.ComponentState) then begin
    m_pcShadow := TPageControl.Create(m_Owner);
    m_pcShadow.Parent := TWinControl(m_Owner);
    m_pcShadow.Visible := False;
    m_pcShadow.DockSite := True;
  end;
  m_slDockPanels := TStringList.Create;
  m_slDockPanels.Sorted := True;
  m_slDockPanels.Duplicates := dupIgnore;
  m_slPageControlHosts := TStringList.Create;
  m_slPageControlHosts.Sorted := True;
  m_slPageControlHosts.Duplicates := dupIgnore;
  m_slDockClients := TStringList.Create;
  m_slDockClients.Sorted := True;
  m_slDockClients.Duplicates := dupIgnore;
  m_slDockHosts := TStringList.Create;
  m_slDockHosts.Sorted := True;
  m_slDockHosts.Duplicates := dupIgnore;
  m_lSimpleDockPanels := TList.Create;
  AsString := '';
end;

destructor TDockHandler.Destroy;
begin
  try
    while DockPanelCount > 0 do UnRegisterDockPanel(DockPanels[0]);
    while PageControlHostCount > 0 do UnregisterPageControlHost(PageControlHosts[0]);
    while DockHostCount > 0 do UnregisterDockHost(DockHosts[0]);
    m_slDockHosts.Free;
    m_slDockPanels.Free;
    m_slPageControlHosts.Free;
    m_slDockClients.Free;
  except
  end;
  inherited Destroy;
end;

procedure TdockHandler.SetTType(s: TTabType);
begin

  TType := s;
end;

procedure TDockHandler.LockRefresh;
begin
  inc(m_nLockRefreshCount);
end;

procedure TDockHandler.RegisterSpecialDockClient(ctrl: TWinControl);
begin
  m_lSimpleDockPanels.Add(ctrl);
end;

procedure TDockHandler.AddDockedPanelsToList(var l: TList;recursive: TControl=nil);
var
  i: integer;
begin
  if recursive = nil then
  begin
    for i:=0 to m_lSimpleDockPanels.Count-1 do
      l.Add(m_lSimpleDockPanels[i]);
    for i:=0 to DockClientCount-1 do
      l.Add(DockClients[i]);
    for i:=0 to DockPanelCount-1 do
      AddDockedPanelsToList(l,DockPanels[i]);
    for i:=0 to PageControlHostCount-1 do
      AddDockedPanelsToList(l,PageControlHosts[i].PageControl);
  end
  else
  begin
    try
      if not (recursive is TDockableForm) and not TPanel(recursive).DockSite and (l.IndexOf(recursive) = -1) then
        l.Add(recursive)
    except
    end;

    try
      for i:=0 to TWinControl(recursive).DockClientCount-1 do
        AddDockedPanelsToList(l,TWinControl(recursive).DockClients[i]);
    except
    end;
  end;
end;


procedure TDockHandler.UnlockRefresh;
begin
  if m_nLockRefreshCount > 0 then dec(m_nLockRefreshCount);
  if m_nLockRefreshCount = 0 then Refresh;
end;

function TDockHandler.GetDockClientCount: Integer;
begin
  Result := m_slDockClients.Count;
end;


function TDockHandler.GetDockClients(i: Integer): TWinControl;
begin
  Result := TWinControl(m_slDockClients.Objects[i]);
end;


function TDockHandler.DoGetOtherHostsAsString: String;
begin
  if Assigned(m_OnGetOtherHostsAsString) then Result := m_OnGetOtherHostsAsString(Self);
end;


procedure TDockHandler.DoSetOtherHostsAsString(sValue: String);
begin
  if Assigned(m_OnSetOtherHostsAsString) then m_OnSetOtherHostsAsString(Self, sValue);
end;


function TDockHandler.GetDockHostCount: Integer;
begin
  Result := m_slDockHosts.Count;
end;


function TDockHandler.GetDockHosts(i: Integer): TWinControl;
begin
  Result := TWinControl(m_slDockHosts.Objects[i]);
end;


procedure TDockHandler.UnRegisterDockHost(wctrl: TWinControl);
var
  idx: Integer;
begin
  idx := m_slDockHosts.IndexOf(IntToStr(Integer(wctrl)));
  if idx > -1 then m_slDockHosts.Delete(idx);
end;


procedure TDockHandler.RegisterDockHost(wctrl: TWinControl);
begin
  m_slDockHosts.AddObject(IntToStr(Integer(wctrl)), wctrl);
end;


procedure TDockHandler.Refresh;
begin
  if m_nLockRefreshCount = 0 then DoRefresh;
end;


procedure TDockHandler.DoRefresh;
var i: Integer;
begin
  for i := 0 to GetDockPanelCount-1 do
    if GetVisibleDockClientcount(GetDockPanels(i)) = 0 then begin
      With GetDockPanels(i) do begin
        Width := 0;
        Height := 0;
        if pSizer <> nil then begin
          pSizer.Align := alNone;
          pSizer.Visible := False;
          pSizer.Destroy;
          pSizer := nil;
        end;
      end;
    end
    else begin
      With GetDockPanels(i) do begin
        if (Align = alLeft) or (Align = alRight) then begin
          if Width < m_iMinSize then begin
            Width := m_iMinSize;
          end;
        end
        else begin
          if Height < m_iMinSize then begin
            Height := m_iMinSize;
          end;
        end;
        if pSizer = nil then begin
          // Place a splitter
          pSizer := TSplitter.Create(Parent);
          pSizer.OnMoved := PSizerMoved;
          pSizer.MinSize := m_iMinSize;
          pSizer.Color := clBtnFace;
          pSizer.Parent := Parent;
          pSizer.Align := Align;
          pSizer.Visible := False;
          pSizer.ResizeStyle := rsUpdate;
          pSizer.Width := 4;
        end;
        if Align = alTop then
          pSizer.Top := Height + Top;
        if Align = alBottom then
          pSizer.Top := Top;
        if Align = alLeft then
          pSizer.Left := Left + Width;
        if Align = alRight then
          pSizer.Left := Left;
      end;
    end;

  if Assigned(m_OnRefresh) then m_OnRefresh(Self);
end;


procedure TDockHandler.RegisterDockClient(ctrl: TControl);
begin
  m_slDockClients.AddObject(IntToStr(Integer(ctrl)), ctrl);
  if ctrl.Owner <> nil then ctrl.Owner.RemoveComponent(ctrl);
  if Owner <> nil then Owner.InsertComponent(ctrl);
end;


procedure TDockHandler.UnRegisterDockClient(ctrl: TControl);
var
  idx: Integer;
begin
  idx := m_slDockClients.IndexOf(IntToStr(Integer(ctrl)));
  if idx > -1 then m_slDockClients.Delete(idx);
end;


function TDockHandler.GetDockPanelCount: Integer;
begin
  Result := m_slDockPanels.Count;
end;


function TDockHandler.GetDockPanels(i: Integer): TDockPanel;
begin
  Result := TDockPanel(m_slDockPanels.Objects[i]);
end;


function TDockHandler.GetPageControlHostCount: Integer;
begin
  Result := m_slPageControlHosts.Count;
end;


function TDockHandler.GetPageControlHosts(i: Integer): TPageControlHost;
begin
  Result := TPageControlHost(m_slPageControlHosts.Objects[i]);
end;


procedure TDockHandler.UnregisterPageControlHost(pch: TPageControlHost);
var
  idx: Integer;
begin
  idx := m_slPageControlHosts.IndexOf(IntToStr(Integer(pch)));
  if idx > -1 then m_slPageControlHosts.Delete(idx);
end;


procedure TDockHandler.RegisterPageControlHost(pch: TPageControlHost);
begin
  m_slPageControlHosts.AddObject(IntToStr(Integer(pch)), pch);
end;


function TDockHandler.GetAsString: String;
var
  sl: TStringList;
  i: Integer;
  sPageControlHosts: String;
  sDockPanels: String;
  sFloatingDockForms: String;
  frm: TDockableForm;
begin
  sl := TStringList.Create;
  for i := 0 to m_slDockClients.Count - 1 do begin
    frm := TDockableForm(m_slDockClients.Objects[i]);
    if frm.HostDockSite = nil then sl.Values[GetStringFromComponent(frm)] := frm.AsString;
  end;
  sFloatingDockForms := sl.CommaText;
  sl.Clear;
  for i := 0 to PageControlHostCount - 1 do begin
    sl.Values[GetStringFromComponent(PageControlHosts[i])] := PageControlHosts[i].AsString;
  end;
  sPageControlHosts := sl.CommaText;
  sl.Clear;
  for i := 0 to DockPanelCount - 1 do begin
    sl.Values[GetStringFromComponent(DockPanels[i])] := DockPanels[i].AsString;
  end;
  sDockPanels := sl.CommaText;
  sl.Clear;
  sl.Values['FloatingDockForms'] := sFloatingDockForms;
  sl.Values['PageControlHosts'] := sPageControlHosts;
  sl.Values['DockPanels'] := sDockPanels;
  sl.Values['OtherHosts'] := DoGetOtherHostsAsString;
  sl.Values['Version'] := '1';
  Result := sl.CommaText;
  sl.Free;
end;

procedure TDockHandler.LoadDesktop(regPath: string; defaultLayout: string);
var
  reg: TRegistry;
  i: integer;
begin
  reg := TRegistry.Create;
  reg.OpenKey(regPath, True);
  bLoadSuccess := True;
  if reg.ValueExists('dockData') then
    SetAsString(reg.ReadString('dockData'))
  else
    SetAsString(defaultLayout);

  for i:=0 to m_slPageControlHosts.Count-1 do
    PageControlHosts[i].PageControl.MultiLine := True;

  reg.Free;
end;


procedure TDockHandler.SaveDesktop(regPath: string);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  reg.OpenKey(regPath, True);
  reg.WriteString('dockData', AsString);
  reg.Free;
end;

procedure TDockHandler.BuildOldPageControl(sAlign, sData: String);
var
  sl: TStringList;
  pch: TPageControlHost;
  cmp: TComponent;
  i: Integer;
  dp: TDockPanel;
  nTabIndex: Integer;
begin
  sl := TStringList.Create;
  sl.CommaText := sData;
  if sl.Count > 3 then begin
    pch := TPageControlHost.Create(Owner);
    if DockHandler.TType = ttIcon then
      pch.PageControl.Images := pch.img;
    pch.Name := 'pc' + sAlign;
    cmp := Owner.FindComponent('dp' + sAlign);
    if (cmp <> nil) and (cmp is TDockPanel) then begin
      dp := TDockPanel(cmp);
      dp.Width := StrToIntDef(sl.Values['Width'], 200);
      dp.Height := StrToIntDef(sl.Values['Height'], 200);
      for i := 3 to sl.Count - 1 do begin
        cmp := Owner.FindComponent(sl.Names[i]);
        if (cmp <> nil) and (cmp is TDockableForm) then begin
          TDockableForm(cmp).AsString := sl.Values[cmp.Name];
          TDockableForm(cmp).ManualDock(pch.PageControl);
        end;
      end;
      pch.ManualDock(dp);
      nTabIndex := StrToIntDef(sl.Values['TabIndex'], -1);
      if (nTabIndex > -1) and (nTabIndex < pch.PageControl.PageCount) then
        pch.PageControl.ActivePage := pch.PageControl.Pages[nTabIndex];
      pch.Visible := True;
    end;
  end;
  sl.Free;
end;


procedure TDockHandler.SetAsString(s: String);
var
  sl: TStringList;
  i,j: Integer;
  slFloatingDockForms: TStringList;
  slPageControlHosts: TStringList;
  slDockPanels: TStringList;
  cmp: TComponent;
  ctrl: TControl;
  rct: TRect;
  sVersion: String;
begin
  // Lock updates
  LockRefresh;
  try
    bDontSize:=True;

    // Destroy all dynamic page control hosts
    for j:=0 to PageControlHostCount-1 do
      for i:=PageControlHosts[j].PageControl.DockClientCount-1 downto 0 do
        PageControlHosts[j].PageControl.DockClients[i].ManualDock(m_pcShadow);

    while PageControlHostCount>0 do
      PageControlHosts[0].Free;

    // Hide and float all registered dock clients
    for i := 0 to m_slDockClients.Count - 1 do begin
      ctrl := TControl(m_slDockClients.Objects[i]);
      TControl(m_slDockClients.Objects[i]).Hide;
      TControl(m_slDockClients.Objects[i]).ManualDock(m_pcShadow);
      if ctrl is TDockableForm then TDockableForm(ctrl).m_LastHostDockSiteClass := nil;
      rct := ctrl.BoundsRect;
      {if ctrl.Parent <> nil then begin
        rct.TopLeft := ctrl.Parent.ClientToScreen(rct.TopLeft);
        rct.BottomRight := ctrl.Parent.ClientToScreen(rct.BottomRight);
      end;}
      ctrl.ManualFloat(rct);
    end;

    sl := TStringList.Create;
    sl.CommaText := s;

    sVersion := UpperCase(sl.Values['Version']);

    if sVersion = '1' then begin
      // Handle floating dockable forms
      slFloatingDockForms := TStringList.Create;
      slFloatingDockForms.CommaText := sl.Values['FloatingDockForms'];
      for i := 0 to slFloatingDockForms.Count - 1 do begin
        cmp := GetComponentFromString(slFloatingDockForms.Names[i]);
        if cmp <> nil then begin
          TDockableForm(cmp).AsString := slFloatingDockForms.ValueFromIndex[i];
        end;
      end;
      slFloatingDockForms.Free;

      // Create dynamic page control hosts
      slPageControlHosts := TStringList.Create;
      slPageControlHosts.CommaText := sl.Values['PageControlHosts'];
      for i := 0 to slPageControlHosts.Count - 1 do begin
        cmp := GetComponentFromString(slPageControlHosts.Names[i]);
        if cmp = nil then begin
          cmp := TPageControlHost.Create(GetComponentFromString(GetComponentOwnerFromString(slPageControlHosts.Names[i])));
          TPageControlHost(cmp).SetParent(nil); //Owner as TWinControl);
          cmp.Name := GetComponentNameFromString(slPageControlHosts.Names[i]);
        end;
        TPageControlHost(cmp).AsString := slPageControlHosts.ValueFromIndex[i];
      end;
      slPageControlHosts.Free;


      // Create dockpanels
      slDockPanels := TStringList.Create;
      slDockPanels.CommaText := sl.Values['DockPanels'];
      for i := 0 to slDockPanels.Count - 1 do begin
        cmp := GetComponentFromString(slDockPanels.Names[i]);
        if cmp <> nil then begin
          TDockPanel(cmp).AsString := slDockPanels.ValueFromIndex[i];
          if TDockPanel(cmp).DockClientCount = 0 then begin
            TDockPanel(cmp).Width := 0;
            TDockPanel(cmp).Height := 0;
          end;
        end;

      end;
      slDockPanels.Free;

      // Handle forms, which are docked in another way
      DoSetOtherHostsAsString(sl.Values['OtherHosts']);

    end else begin
      // Handle floating dockable forms
      slFloatingDockForms := TStringList.Create;
      slFloatingDockForms.CommaText := sl.Values['Floating'];
      for i := 0 to slFloatingDockForms.Count - 1 do begin
        cmp := GetComponentFromString(slFloatingDockForms.Names[i]);
        if (cmp <> nil) and (cmp is TDockableForm) then begin
          TDockableForm(cmp).AsString := slFloatingDockForms.ValueFromIndex[i];
        end;
      end;
      DoSetOtherHostsAsString('MainForm=' + slFloatingDockForms.Values['MainForm']);
      slFloatingDockForms.Free;

      BuildOldPageControl('Left', sl.Values['pcLeft']);
      BuildOldPageControl('Top', sl.Values['pcTop']);
      BuildOldPageControl('Right', sl.Values['pcRight']);
      BuildOldPageControl('Bottom', sl.Values['pcBottom']);
    end;

    sl.Free;
  finally
    // Unlock updates
    UnlockRefresh;
    bDontSize:=False;
  end;
end;




procedure TDockHandler.RegisterDockPanel(pnl: TDockPanel);
begin
  m_slDockPanels.AddObject(IntToStr(Integer(pnl)), pnl);
end;


procedure TDockHandler.UnRegisterDockPanel(pnl: TDockPanel);
var
  idx: Integer;
begin
  idx := m_slDockPanels.IndexOf(IntToStr(Integer(pnl)));
  if idx > -1 then m_slDockPanels.Delete(idx);
end;



////////////////////////////////////////////////////////////////////////////////
//  TDockPanel = class(TPanel)
////////////////////////////////////////////////////////////////////////////////
constructor TDockPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_iWidth := 200;
  m_iMinSize := 50;
  OnUnDock := UnDock;
  OnResize := Resize;
  DockHandler(AOwner).RegisterDockPanel(Self);
end;

procedure TDockPanel.PSizerMoved(Sender: TObject);
begin

    if (Align = alLeft) or (Align = alRight) then begin
      if Width < m_iMinSize then begin
        Width := m_iMinSize;
        Dockhandler.Refresh;
      end;
    end
    else begin
      if Height < m_iMinSize then begin
        Height := m_iMinSize;
        DockHandler.Refresh;
      end;
    end;
  
end;


procedure TDockPanel.Resize(Sender: TObject);
begin

end;


procedure TDockPanel.UnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
  m_bUndocking := True;
  if (Align = alLeft) or (align = alRight) then
    m_iWidth := Width
  else
    m_iWidth := Height;

  if GetVisibleDockClientCount(Self) = 1 then begin
    if (Align = alLeft) or (Align = alRight) then
      Width := 0
    else
      Height := 0;
    if pSizer <> nil then begin
      // This should never be the case but better safe than
      // sorry :)
      pSizer.Align := alNone;
      pSizer.Destroy;
      pSizer := nil;
    end;
  end;
end;

destructor TDockPanel.Destroy;
begin
  try
    DockHandler.UnRegisterDockPanel(Self);
  except
  end;
  inherited Destroy;
end;


function TDockPanel.CreateDockManager: IDockManager;
begin
  //test := WindowProc;
  Result := inherited CreateDockManager;
  //Self.WindowProc := test;
  //Result := TCustomDockTree.Create(Self);
end;

function ColorToR(Color: Integer): Byte; // Color is in $00BBGGRR format
begin
  Result := Color and $000000FF;
end;

{ --------------------------------------------------------------------------- }

function ColorToG(Color: Integer): Byte; // Color is in $00BBGGRR format
begin
  Result := (Color and $0000FF00) shr 8;
end;

{ --------------------------------------------------------------------------- }

function ColorToB(Color: Integer): Byte; // Color is in $00BBGGRR format
begin
  Result := (Color and $00FF0000) shr 16;
end;

procedure TDockPanel.Paint;
begin
  inherited;
  if SkinManager.GetSkinType=sknSkin then
  begin
    Canvas.Brush.Color := RGB(Floor(ColorToR(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1)*0.8),Floor(ColorToG(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1)*0.8),Floor(ColorToB(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1)*0.8));
    Canvas.FillRect(Canvas.ClipRect);
    //SkinManager.CurrentSkin.PaintBackground(Canvas,Canvas.ClipRect,skncPanel,sknsNormal,True,False);
  end;
end;


procedure TDockPanel.SetAsString(s: String);
var
  sl: TStringList;
  slDockClients: TStringList;
  cmp: TComponent;
  i: Integer;
  ms: TMemoryStream;
  h: String;
begin
  sl := TStringList.Create;
  sl.CommaText := s;
  bDontSize := True;
  // Restore dock clients
  slDockClients := TStringList.Create;
  slDockClients.CommaText := sl.Values['DockClients'];
  for i := 0 to slDockClients.Count - 1 do begin
    cmp := GetComponentFromString(slDockClients.Names[i]);
    if (cmp <> nil) then
    begin
      try
        SetWinControlAsString(TWinControl(cmp),slDockClients.Values[slDockClients.Names[i]]);
      except
      end;
      if cmp is TDockableForm then
        TDockableForm(cmp).m_CaptionPanel.Visible := True;
    end;
  end;
  slDockClients.Free;

  // Load width and height
  Width := StrToIntDef(sl.Values['Width'], 200);
  Height := StrToIntDef(sl.Values['Height'], 200);
  m_iWidth := StrToIntDef(sl.Values['iWidth'], 200);
  // Load and apply docking information
  h := sl.Values['DockingData'];
  ms := TMemoryStream.Create;
  ms.SetSize(Length(h) div 2);
  HexToBin(PChar(h), ms.Memory, Length(h));
  ms.Seek(0, soFromBeginning);
  DockManager.LoadFromStream(ms);
  DockManager.ResetBounds(True);
  ms.Free;
  bDontSize:=False;
  sl.Free;
end;


function TDockPanel.GetAsString: String;
var
  i: Integer;
  sl: TStringList;
  ms: TMemoryStream;
  sDockingData: String;
  sDockClients: String;
begin
  Result := '';
  sl := TStringList.Create;

  for i := 0 to DockClientCount - 1 do begin
      sl.Values[GetStringFromComponent(DockClients[i])] := GetWinControlAsString(TWinControl(DockClients[i]));
  end;

  sDockClients := sl.CommaText;
  sl.Clear;

  // Use DockManager to store docking information
  ms := TMemoryStream.Create;
  DockManager.SaveToStream(ms);
  SetLength(sDockingData, 2 * ms.Size);
  BinToHex(ms.Memory, PChar(sDockingData), ms.Size);
  ms.Free;

  sl.Values['DockClients'] := sDockClients;
  sl.Values['Width'] := IntToStr(Width);
  sl.Values['Height'] := IntToStr(Height);
  sl.Values['iWidth'] := IntToStr(m_iWidth);  
  sl.Values['DockingData'] := sDockingData;

  Result := sl.CommaText;
  if (Self.DockClientCount = 0) then begin
    Width := 0;
    Height := 0;
  end;
  sl.Free;
end;



procedure TDockPanel.DockDrop(Source: TDragDockObject; X, Y: Integer);
var
  pch: TPageControlHost;

begin
  m_bUndocking := True;
  if (Source.Control is TPageControlHost) then begin
    (Source.Control as TPageControlHost).PageControl.TabPosition := Self.TabPos;
    if ((Source.Control as TPageControlHost).PageControl.TabPosition <> tpLeft) and ((Source.Control as TPageControlHost).PageControl.TabPosition <> tpRight) then

    (Source.Control as TPageControlHost).PageControl.MultiLine := False;
  end;
  if m_bDockOnPageControl then begin
    pch := TPageControlHost.Create(Owner);
    pch.Parent := Self;
    pch.BoundsRect := Source.DropOnControl.ClientRect;
    pch.Visible := True;
    m_bDockOnPageControl := False;
    pch.ReplaceDockedControl(Source.DropOnControl, pch.PageControl, nil, alClient);
    Source.Control.ManualDock(pch.PageControl);
    pch.Caption := pch.PageControl.ActivePage.Caption;
    //pch.PageControl.OwnerDraw := True;
    pch.PageControl.TabPosition := Self.TabPos;
    if (pch.PageControl.TabPosition <> tpLeft) and (pch.PageControl.TabPosition <> tpRight) then
      pch.PageControl.MultiLine := False;
  end else begin
    inherited DockDrop(Source, x, y);
    if m_iWidth < m_iMinSize then m_iWidth := m_iMinSize;

    if pSizer = nil then begin
      // Place a splitter
      pSizer := TSplitter.Create(Self.Parent);
      pSizer.OnMoved := PSizerMoved;
      pSizer.MinSize := m_iMinSize;
      pSizer.Color := clBtnFace;
      pSizer.Parent := Self.Parent;
      pSizer.Align := Self.Align;
      pSizer.Visible := True;
      pSizer.ResizeStyle := rsUpdate;
      pSizer.Width := 4;
    end;
    if (Self.DockClientCount =1) and (bDontSize=False) then
      if (Self.Align = alLeft) or (Align = alRight) then
        Width := m_iWidth
      else
        Height := m_iWidth;
    if Align = alTop then
      pSizer.Top := Self.Height + Self.Top;
    if Align = alBottom then
      pSizer.Top := Self.Top;
    if Align = alLeft then
      pSizer.Left := Self.Left + Self.Width;
    if Align = alRight then
      pSizer.Left := Self.Left;

  end;

end;


procedure TDockPanel.DockOver(Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  rct: TRect;
  nFrameWidth, nFrameHeight: Integer;
begin
  inherited DockOver(Source, x, y, State, Accept);
  m_bDockOnPageControl := False;
  if GetVisibleDockClientCount(Self) = 0 then begin
    if m_iWidth < m_iMinSize then m_iWidth := m_iMinSize;
    if Self.Align = alLeft then begin
      rct.TopLeft := Point(0, 0);
      rct.BottomRight := Point(m_iWidth, ClientHeight);
      rct.TopLeft := ClientToScreen(rct.TopLeft);
      rct.BottomRight := ClientToScreen(rct.BottomRight);
      Source.DockRect := rct;
    end
    else if Self.Align = alRight then begin
      rct.TopLeft := Point(Width - m_iWidth, 0);
      rct.BottomRight := Point(ClientWidth, ClientHeight);
      rct.TopLeft := ClientToScreen(rct.TopLeft);
      rct.BottomRight := ClientToScreen(rct.BottomRight);
      Source.DockRect := rct;
    end
    else if Self.Align = alBottom then begin
      rct.TopLeft := Point(0, ClientHeight - m_iWidth);
      rct.BottomRight := Point(Width, ClientHeight);
      rct.TopLeft := ClientToScreen(rct.TopLeft);
      rct.BottomRight := ClientToScreen(rct.BottomRight);
      Source.DockRect := rct;
    end
    else begin
      rct.TopLeft := Point(0, 0);
      rct.BottomRight := Point(Width, Top + m_iWidth);
      rct.TopLeft := ClientToScreen(rct.TopLeft);
      rct.BottomRight := ClientToScreen(rct.BottomRight);
      Source.DockRect := rct;
    end;
  end;
  if (Source.DropOnControl <> nil) and (not (Source.Control is TPageControlHost)) then begin
    if Source.Control.HostDockSite <> nil then begin
      if Source.Control.HostDockSite.Parent = Source.DropOnControl then exit;
    end;
    if Source.Control = Source.DropOnControl then exit;
    rct := Source.DropOnControl.BoundsRect;
    nFrameWidth := (rct.Right - rct.Left) div 5;
    nFrameHeight := (rct.Bottom - rct.Top) div 5;
    rct.Left := rct.Left + nFrameWidth;
    rct.Top := rct.Top + nFrameHeight;
    rct.Right := rct.Right - nFrameWidth;
    rct.Bottom := rct.Bottom - nFrameHeight;
    if PtInRect(rct, Point(x, y)) then begin
      rct.TopLeft := ClientToScreen(rct.TopLeft);
      rct.BottomRight := ClientToScreen(rct.BottomRight);
      Source.DockRect := rct;
      m_bDockOnPageControl := True;
    end;
  end;
end;


procedure TDockPanel.DoEndDock(Target: TObject; X, Y: Integer);
begin
  inherited DoEndDock(Target, x, y);
end;


procedure TDockPanel.GetSiteInfo(Client: TControl; var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
begin
  inherited GetSiteInfo(Client, InfluenceRect, MousePos, CanDock);
end;


procedure TDockPanel.DoStartDock(var DragObject: TDragObject);
begin
  inherited DoStartDock(DragObject);
end;


function TDockPanel.DoUnDock(NewTarget: TWinControl; Client: TControl): Boolean;
begin

  Result := inherited DoUndock(NewTarget, Client);
  DockHandler.Refresh;
  
end;





////////////////////////////////////////////////////////////////////////////////
//  TPageControlHost = class(TForm)
////////////////////////////////////////////////////////////////////////////////
constructor TPageControlHost.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DragKind := dkDock;
  DragMode := dmAutomatic;
  PageControl.HotTrack := True;
  DockHandler(AOwner).RegisterPageControlHost(Self);
  PageControl.OwnerDraw := False;
  PageControl.SetAutoDrawTab(False);
  PageControl.DoubleBuffered := True;
  PageControl.TabWidth := 0;
  PageControl.TabHeight := 0;
  PageControl.MultiLine := True;
end;


destructor TPageControlHost.Destroy;
begin
  try
    DockHandler.UnregisterPageControlHost(Self);
  except
  end;
  inherited Destroy;
end;


procedure TPageControlHost.DoStartDock(var DragObject: TDragObject);
begin
  PageControl.SetFocus;
  inherited DoStartDock(DragObject);
end;


procedure TPageControlHost.DoEndDock(Target: TObject; X, Y: Integer);
begin

  inherited DoEndDock(Target, x, y);
{  if (not (Self.Parent is TDockPanel)) then begin}
    Self.Left := Self.Left;
    Self.Top := Self.Top;
//  end;

  DockHandler.Refresh;
  PageControl.MultiLine := True;

end;


procedure TPageControlHost.DoShow;
begin

  inherited DoShow;
  DockHandler.Refresh;

end;


procedure TPageControlHost.DoHide;
begin

  inherited DoHide;
  DockHandler.Refresh;

end;


function TPageControlHost.GetVisibleDockClientCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to PageControl.DockClientCount - 1 do begin
    if PageControl.DockClients[i].Visible then inc(Result);
  end;
end;


function TPageControlHost.GetAsString: String;
var
  sl: TStringList;
  i: Integer;
  s: String;
  ctrl: TControl;
  pt: TPoint;
begin
  sl := TStringList.Create;

  // Docked Controls, ActivePage, Visibility
  for i := 0 to PageControl.DockClientCount - 1 do begin
    ctrl := PageControl.DockClients[i];
      sl.Values[GetStringFromComponent(ctrl)] := GetWinControlAsString(TWinControl(ctrl));
  end;
  s := sl.CommaText;
  sl.Clear;
  sl.Values['DockedControls'] := s;
  sl.Values['ActivePage'] := PageControl.ActivePage.Caption;
  pt := Point(Left, Top);
  if HostDockSite <> nil then pt := HostDockSite.ClientToScreen(pt);
  sl.Values['Left'] := IntToStr(pt.x);
  sl.Values['Top'] := IntToStr(pt.y);
  sl.Values['Width'] := IntToStr(Width);
  sl.Values['Height'] := IntToStr(Height);
//  PageControl.TabPosition := TTabPosition(StrToIntDef(sl.Values['TabPos'], 0);
  sl.Values['TabPos'] := IntToStr(Integer(PageControl.TabPosition));
  sl.Values['Visible'] := BoolToStr(Visible);
  sl.Values['Floating'] := BoolToStr(HostDockSite = nil);
  Result := sl.CommaText;
  sl.Free;
end;


procedure TPageControlHost.SetAsString(s: String);
var
  sl, slDockedControls: TStringList;
  sCaption: String;
  i: Integer;
  cmp: TComponent;
  nLeft, nTop, nWidth, nHeight: Integer;
  bFloating: Boolean;
begin
  Visible := False;

  sl := TStringList.Create;
  sl.CommaText := s;

  // Apply page control docking
  slDockedControls := TStringList.Create;
  slDockedControls.CommaText := sl.Values['DockedControls'];
  for i := 0 to slDockedControls.Count - 1 do begin
    cmp := GetComponentFromString(slDockedControls.Names[i]);
    if (cmp <> nil) then
    begin
      try
        SetWinControlAsString(TWinControl(cmp),slDockedControls.ValueFromIndex[i]);
      except
      end;
      if cmp is TDockableForm then
        TDockableForm(cmp).m_CaptionPanel.Visible := False;
      TControl(cmp).ManualDock(PageControl);
    end;
  end;
  slDockedControls.Free;

  // Set active page
  sCaption := sl.Values['ActivePage'];
  for i := 0 to PageControl.PageCount - 1 do begin
    if PageControl.Pages[i].Caption = sCaption then
      PageControl.ActivePage := PageControl.Pages[i];
  end;

  nLeft := StrToIntDef(sl.Values['Left'], 0);
  nTop := StrToIntDef(sl.Values['Top'], 0);
  nWidth := StrToIntDef(sl.Values['Width'], 200);
  nHeight := StrToIntDef(sl.Values['Height'], 200);

  PageControl.TabPosition := TTabPosition(StrToIntDef(sl.Values['TabPos'], 0));
  BoundsRect := Rect(nLeft, nTop, nLeft + nWidth, nTop + nHeight);

  bFloating := StrToBool(sl.Values['Floating']);
  if not bFloating then begin
    ManualDock(DockHandler.m_pcShadow);
    Align := alNone;
  end;

  // Set visibility
  Visible := StrToBool(sl.Values['Visible']);
  Caption := PageControl.ActivePage.Caption;
  sl.Free;
end;


procedure TPageControlHost.PageControlUnDock(Sender: TObject;
  Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin

 if m_bOnClose then exit;
//  if PageControl.DockClientCount = 2 then begin
  if GetVisibleDockClientCount <= 2 then begin
    // at maximum one visible DockClient remains on page control
    m_bOnClose := True;
    tmr.Enabled := True;
  end;
end;

procedure TPageControlHost.tmrTimer(Sender: TObject);
var
  i: Integer;
  ctrl: TControl;
  sl: TStringList;
  rct: TRect;
begin
  tmr.Enabled := False;
  sl := TStringList.Create;
  i := 0;
  ctrl := nil;
  while i < PageControl.DockClientCount do begin
    if PageControl.DockClients[i].Visible then begin
      ctrl := PageControl.DockClients[i];
    end else begin
      sl.AddObject('', PageControl.DockClients[i]);
    end;
    inc(i);
  end;
  for i := 0 to sl.Count - 1 do begin
    rct := TControl(sl.Objects[i]).BoundsRect;
    rct.TopLeft := ClientToScreen(rct.TopLeft);
    rct.BottomRight := ClientToScreen(rct.BottomRight);
    TControl(sl.Objects[i]).ManualFloat(rct);
  end;
  sl.Free;
  if ctrl <> nil then ctrl.ReplaceDockedControl(Self, nil, nil, alNone);
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;


procedure TPageControlHost.PageControlGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
  CanDock := DockClient.HostDockSite <> PageControl;
  if CanDock = true then
    CanDock := (DockClient.Tag <> 1) and (DockClient.Tag <> 2);
end;



procedure TPageControlHost.PageControlDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
var
  pch: TPageControlHost;
  Icon: TIcon;
begin
  //MessageBox(0, PChar(IntToStr(PageControl.PageCount)), 'test' , MB_OK);
  if Source.Control is TPageControlHost then begin
    pch := Source.Control as TPageControlHost;
    while pch.PageControl.DockClientCount > 0 do begin
      pch.PageControl.DockClients[0].ManualDock(PageControl);
    end;
  end;

  if Source.Control is TDockableForm then begin
    if (DockHandler.TType = TTIcon) or (DockHandler.TType = TTTextIcon) then begin
      if (Source.Control as TdockableForm).Icon <> nil then begin
        PageControl.Images := img;
        Icon := TIcon.Create;
        Icon := (Source.Control as TDockableForm).Icon;
        PageControl.Pages[PageControl.PageCount - 1].ImageIndex := img.AddIcon(Icon);
      end;
    end;
  end;

  try
    PageControl.Pages[PageControl.PageCount - 1].Caption := TPanel(Source.Control).Caption;
  except
  end;
  Caption := PageControl.ActivePage.Caption;
end;


////////////////////////////////////////////////////////////////////////////////
//  TDockableForm = class(TForm)
////////////////////////////////////////////////////////////////////////////////
constructor TDockableForm.CreateNew(AOwner: TComponent; Dummy: Integer);
var
  pnl: TPanel;
begin
  inherited CreateNew(AOwner,Dummy);
  m_CaptionPanel := TPanel.Create(Self);
  m_CaptionPanel.Parent := Self;
  with m_CaptionPanel do begin
    Height := 0;
    Align := alTop;
    BevelInner := bvNone;
    BevelOuter := bvNone;
  end;
  // Caption
  pnl := TPanel.Create(Self);
  pnl.Parent := m_CaptionPanel;
  pnl.Align := alClient;
  pnl.Alignment := taLeftJustify;
  pnl.Caption := '  ' + Self.Caption;
  pnl.BevelInner := bvNone;
  pnl.BevelOuter := bvNone;
  pnl.Font.Color := clNavy;
  BorderIcons := [];
  DockHandler(AOwner).RegisterDockClient(Self);
end;


destructor TDockableForm.Destroy;
begin
  try
    DockHandler.UnRegisterDockClient(Self);
  except;
  end;
  inherited Destroy;
end;

function TDockableForm.GetVisible: Boolean;
var
  ctr: TWinControl;
begin
  Result := inherited Visible;
  ctr := Parent;
  while Result and (ctr <> nil) do begin
    if not (ctr is TTabSheet) then Result := ctr.Visible;
    ctr := ctr.Parent;
  end;
end;


procedure TDockableForm.SetVisible(b: Boolean);
var
  ctr: TWinControl;
  pc: TPageControl;
begin
  if b then begin
    if (m_LastHostDockSiteClass <> nil) and (Parent = nil) then begin
      DockHandler.DoSetOtherHostsAsString(m_LastHostDockSiteClass.ClassName + '=' + Name);
      inherited Visible := True;
      exit;
    end;
    inherited Visible := True;
    ctr := Parent;
    while ctr <> nil do begin
      ctr.Visible := True;
      if ctr is TTabSheet then begin
        pc := TPageControl(TTabSheet(ctr).PageControl);
        if pc <> nil then pc.ActivePage := TTabSheet(ctr);
      end else if ctr is TForm then begin
        ctr.BringToFront;
      end;
      ctr := ctr.Parent;
    end;
  end else begin
    inherited Visible := False;
  end;
end;


procedure TDockableForm.RefreshCaption;
begin
  m_CaptionPanel.Visible := (HostDockSite <> nil) and (HostDockSite is TDockPanel);
end;


procedure TDockableForm.DoShow;
begin

  if HostDockSite <> nil then begin
    m_LastHostDockSiteClass := HostDockSite.ClassType;
  end else begin
    m_LastHostDockSiteClass := nil;
  end;
  if (HostDockSite is TDockPanel) then begin
    if (HostDockSite.VisibleDockClientCount = 1) then
      (HostDockSite as TDockPanel).Width := (HostDockSite as TDockPanel).m_iWidth;

  end;
  inherited DoShow;
  DockHandler.Refresh;

end;


procedure TDockableForm.DoHide;
begin
  if HostDockSite <> nil then begin
    m_LastHostDockSiteClass := HostDockSite.ClassType;
  end else begin
    m_LastHostDockSiteClass := nil;
  end;
  if HostDockSite is TDockPanel then begin
    (HostDockSite as TDockPanel).m_iWidth := (HostDockSite as TDockPanel).Width;
  end;
  inherited DoHide;
  DockHandler.Refresh;

end;


procedure TDockableForm.DoEndDock(Target: TObject; X, Y: Integer);
begin

  if HostDockSite <> nil then begin
    m_LastHostDockSiteClass := HostDockSite.ClassType;
  end else begin
    m_LastHostDockSiteClass := nil;
  end;
  inherited DoEndDock(Target, x, y);
  if (not (Self.Parent is TDockPanel)) and (not (Self.Parent is TTabSheet)) then begin
    Self.Left := Self.Left;
    Self.Top := Self.Top;
  end;

  DockHandler.Refresh;

end;

function TDockableForm.GetAsString: String;
begin
  Result := GetWinControlAsString(Self);
end;


procedure TDockableForm.SetAsString(s: String);
begin
  SetWinControlAsString(Self,s);
end;

procedure DrawRaisedEdge (DC: HDC; R: TRect; const FillInterior: Boolean);
  const
    FillMiddle: array[Boolean] of UINT = (0, BF_MIDDLE);
  begin
    DrawEdge (DC, R, BDR_RAISEDINNER, BF_RECT or FillMiddle[FillInterior]);
  end;

procedure LimitPaintingToArea(Canvas: TCanvas; ClipRect: TRect);
  // Limits further painting onto the given canvas to the given rectangle.
  // VisibleRegion is an optional region which can be used to limit drawing further.
var
  ClipRegion: HRGN;
begin
  // Regions expect their coordinates in device coordinates, hence we have to transform the region rectangle.
  LPtoDP(Canvas.Handle, ClipRect, 2);
  ClipRegion := CreateRectRgnIndirect(ClipRect);
  SelectClipRgn(Canvas.Handle, ClipRegion);
  DeleteObject(ClipRegion);
end;



procedure TPageControlHost.PageControlChange(Sender: TObject);
begin
  Caption := PageControl.ActivePage.Caption;
end;

procedure TPageControlHost.PageControlDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  ar, ar2: TRect;
  imgX, imgY, txtX, txtY, bSize: Integer;
  R: TRect;
begin
  SkinManager.CurrentSkin.PaintBackground(PageControl.Canvas,PageControl.TabRect(TabIndex),skncToolbar,sknsNormal,True,True);
   {  if DockHandler.b_ShowGrabberBars then
      bSize := 8
    else
      bSize := 10;
    if (PageControl.TabPosition <> tpBottom) and (PageControl.TabPosition <> tpTop) then begin
      PageControl.TabWidth := 32 + bSize;
      PageControl.TabHeight := 26;
    end
    else begin
      if DockHandler.TType = ttIcon then begin
        PageControl.TabWidth := 32 + bSize;
        PageControl.TabHeight := 26;
      end
      else if DockHandler.TType = ttTextIcon then begin
        PageControl.TabWidth := 112 + bSize;
        PageControl.TabHeight := 30;
      end
      else begin
        PageControl.TabWidth := 96 + bSize;
        PageControl.TabHeight := 30;
      end;
    end;

  PageControl.Canvas.Pen.Color := clBtnFace;
  PageControl.Canvas.FillRect(Rect);

  if Active then begin

    if PageControl.TabPosition = tpTop then begin
      With ar do begin
        Left := rect.Left + 7;
        Right := rect.Left + 9;
        Bottom := rect.Bottom - 11;
        Top := rect.Top + 7;
      end;
      With ar2 do begin
        Left := rect.Left + 10;
        Right := rect.Left + 12;
        Bottom := rect.Bottom - 11;
        Top := rect.Top + 7;
      end;
    end
    else if PageControl.TabPosition = tpBottom then begin
      With ar do begin
        Left := rect.Left + 7;
        Right := rect.Left + 9;
        Bottom := rect.Bottom - 9;
        Top := rect.Top + 9;
      end;
      With ar2 do begin
        Left := rect.Left + 10;
        Right := rect.Left + 12;
        Bottom := rect.Bottom - 9;
        Top := rect.Top + 9;
      end;
    end
    else begin
      if PageControl.TabPosition = tpLeft then begin
        With ar do begin
          Left := rect.Left + 9;
          Right := Rect.Right - 7;
          Bottom := rect.Bottom - 10;
          Top := rect.Bottom - 12;
        end;
        With ar2 do begin
          Left := rect.Left + 9;
          Right := Rect.Right - 7;
          Bottom := rect.Bottom - 7;
          Top := rect.Bottom - 9;
        end;
      end else begin
        With ar do begin
          Left := rect.Right - 9;
          Right := Rect.Left + 7;
          Bottom := rect.Bottom - 10;
          Top := rect.Bottom - 12;
        end;
        With ar2 do begin
          Left := rect.Right - 9;
          Right := Rect.Left + 7;
          Bottom := rect.Bottom - 7;
          Top := rect.Bottom - 9;
        end;
      end;
    end;
  end
  else begin
    if (PageControl.TabPosition = tpBottom) or (PageControl.TabPosition = tpTop) then begin
       With ar do begin
         Left := rect.Left + 3;
         Right := rect.Left + 5;
         Bottom := rect.Bottom - 5;
         Top := rect.Top + 7;
       end;
       With ar2 do begin
         Left := rect.Left + 6;
         Right := rect.Left + 8;
         Bottom := rect.Bottom - 5;
         Top := rect.Top + 7;
       end;
    end
    else begin
      if PageControl.TabPosition = tpLeft then begin
        With ar do begin
          Left := rect.Left + 6;
          Right := rect.Right - 3;
          Bottom := rect.Bottom - 3;
          Top := rect.Bottom - 5;
        end;
        With ar2 do begin
          Left := rect.Left + 6;
          Right := rect.Right - 3;
          Bottom := rect.Bottom - 6;
          Top := rect.Bottom - 8;
        end;
      end else begin
        With ar do begin
          Left := rect.Right - 6;
          Right := rect.Left + 3;
          Bottom := rect.Bottom - 3;
          Top := rect.Bottom - 5;
        end;
        With ar2 do begin
          Left := rect.Right - 6;
          Right := rect.Left + 3;
          Bottom := rect.Bottom - 6;
          Top := rect.Bottom - 8;
        end;
      end;
    end;
  end;
  //Canvas.FrameRect(ar);
  if (PageControl.TabPosition = tpBottom) or (PageControl.TabPosition = tpTop) then
    bSize := Rect.Left
  else
    bSize := Rect.Bottom;
  if Dockhandler.b_ShowGrabberBars then begin
    DrawRaisedEdge(PageControl.canvas.Handle, ar , True);
    DrawRaisedEdge(PageControl.canvas.Handle, ar2 , True);
    if (PageControl.TabPosition = tpLeft) or (PageControl.TabPosition = tpRight) then
      bSize := ar2.Top - 3
    else
      bSize := ar2.Right + 3;
  end;
  if Active then begin
    if (PageControl.TabPosition = tpBottom) then begin

      imgX := Rect.Left + 16;
      imgY := rect.Top + 8;
    end
    else if  (PageControl.TabPosition = tpTop) then begin
      imgX := Rect.Left + 16;
      imgY := rect.Top + 8;
    end
    else begin
      if pagecontrol.TabPosition = tpLeft then begin
        imgX := Rect.Left + 10;
        imgY := rect.Bottom - 32;
      end else begin
        imgX := Rect.Right - 16 - 10;
        imgY := Rect.Bottom - 32;
      end;

      imgX := Rect.Left + 10;
      imgY := Rect.Bottom - 32;
    end;
  end
  else begin
    if (PageControl.TabPosition = tpBottom) then begin

      imgX := Rect.Left + 12;
      imgY := rect.Top + 5;
    end
    else if  (PageControl.TabPosition = tpTop) then begin
      imgX := Rect.Left + 12;
      imgY := rect.Top + 8;
    end
    else begin
      if pagecontrol.TabPosition = tpLeft then begin
        imgX := Rect.Left + 8;
        imgY := rect.Bottom - 28;
      end else begin
        imgX := Rect.Right - 16 - 8;
        imgY := Rect.Bottom - 28;
      end;
    end;
  end;
    img.Draw(PageControl.Canvas, imgX, imgY, Integer(PageControl.Pages[TabIndex].ImageIndex));

  if (DockHandler.TabType = TTTextIcon) or (DockHandler.Tabtype = ttText) then begin
    if (DockHandler.TType = TTTextIcon) then begin
      if (PageControl.TabPosition = tpBottom) then begin
        if Active then begin
          txtX := Rect.Left + 38;
          txtY := Rect.Top + 9;
        end
        else begin
          txtX := Rect.Left + 34;
          txtY := Rect.Top + 7;
        end;
      end
      else if (PageControl.TabPosition = tpTop) then begin
        if Active then begin
          txtX := Rect.Left + 38;
          txtY := Rect.Top + 9;
        end
        else begin
          txtX := Rect.Left + 34;
          txtY := Rect.Top + 10;
        end;
      end;
    end
    else begin
      if (PageControl.TabPosition = tpBottom) or (PageControl.TabPosition = tpTop) then begin
        txtX := Rect.Left + 16 + 8 + 3;
        txtY := Rect.Top + 6;
      end
   end;
     if (PageControl.TabPosition = tpBottom) or (PageControl.TabPosition = tpTop) then begin
       PageControl.Canvas.TextOut(txtX, txtY, PageControl.Pages[TabIndex].Caption)
     end;

  end;}
end;

procedure TPageControl.SetAutoDrawTab(const Value: Boolean);
begin
  FAutoDrawTab := Value;
end;

function PointInRect(Rect: TRect; Point: TPoint): Boolean;
begin
  Result := (Point.X >= Rect.Left) and (Point.X <= Rect.Right)
        and (Point.Y >= Rect.Top) and (Point.Y <= Rect.Bottom);
end;

constructor TPageControl.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := True;
  OnMouseMove := MouseMove;
end;

procedure TPageControl.CMMouseLeave(var Msg: TMessage);
begin
  Repaint;
end;

procedure TPageControl.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  Repaint;
end;

procedure TPageControl.WMPaint(var msg: TWMPaint);
var
  R,R2: TRect;
  bmp: TBitmap;
  i: Integer;
  originalClipRect: TRect;
  p: TPoint;
  hotTrack: Boolean;
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  PS: TPaintStruct;
  Canvas: TCanvas;
  HotTrackRect: TRect;
  itemState: TSpTBXSkinStatesType;
begin
  if not FAutoDrawTab and (SkinManager.GetSkinType = sknSkin) then
  begin
    DC := GetDC(0);
    MemBitmap := CreateCompatibleBitmap(DC, ClientRect.Right, ClientRect.Bottom);
    ReleaseDC(0, DC);
    MemDC := CreateCompatibleDC(0);
    OldBitmap := SelectObject(MemDC, MemBitmap);
    
    DC := BeginPaint(Handle, PS);
    Perform(WM_ERASEBKGND, MemDC, MemDC);
    Msg.DC := MemDC;
    try
    Canvas := TCanvas.Create;
    Canvas.Handle := MemDC;
    
    CopyRect(originalClipRect,Canvas.ClipRect);
    CopyRect(R,Canvas.ClipRect);
    R.Top := R.Top+Self.TabRect(0).Bottom;
    SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncTabBackground,sknsNormal,True,True);
    CopyRect(R,Canvas.ClipRect);
    R.Bottom := Self.TabRect(0).Bottom;
    SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncDock,sknsNormal,True,False);
    SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncToolbar,sknsNormal,True,False);
    SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncTabToolbar,sknsNormal,True,False);
    GetCursorPos(p);
    for i:=0 to Self.Tabs.Count-1 do
    begin
      CopyRect(R,TabRect(i));
      CopyRect(HotTrackRect,TabRect(i));
      InflateRect(HotTrackRect,-1,-1);
      hotTrack := PointInRect(HotTrackRect,ScreenToClient(p));
      if (ActivePageIndex = i) or (Pages[i].Highlighted or hotTrack) then
      begin
        LimitPaintingToArea(Canvas,Rect(originalClipRect.Left, originalClipRect.Top, originalClipRect.Right, R.Bottom+2));
        if (ActivePageIndex = i) then
          R.Bottom := R.Bottom+5
        else
          R.Bottom := R.Bottom+1;
        itemState := SkinManager.CurrentSkin.GetState(Pages[i].Enabled,Pages[i].Highlighted,hotTrack,True);
        SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncTab,itemState,True,True,False,[akBottom]);
        LimitPaintingToArea(Canvas,originalClipRect);
        Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncTab,itemState);
      end
      else
      begin
        CopyRect(R2,R);
        R2.Left := R2.Right - 2;
        if i <> ActivePageIndex-1 then
          SpDrawXPMenuSeparator(Canvas,R2,False,True);
        SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncTab,sknsNormal,True,True,False,[akBottom]);
        Canvas.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncTab,sknsNormal);
      end;
      Canvas.Brush.Style := Graphics.bsClear;
      Canvas.TextOut(TabRect(i).Left+4,TabRect(i).Top+4,Tabs[i]);
    end;
    finally
      Msg.DC := 0;
      BitBlt(DC, 0, 0, ClientRect.Right, ClientRect.Bottom, MemDC, 0, 0, SRCCOPY);
      EndPaint(Handle, PS);
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
      Canvas.Free;
    end;
  end
  else
    inherited;
end;

procedure TCustomDockTree.PaintDockFrame(Canvas: TCanvas; Control: TControl; const ARect: TRect);
var
  R:TRect;
  p:TPoint;
  HTFlag : integer;
  PatternColor: TColor;
begin
  if SkinManager.GetSkinType = sknSkin then
  begin
    SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncDockablePanel,sknsNormal,True,True);
    CopyRect(R,ARect);
    R.Bottom := R.Top + 12;

    SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncDockablePanelTitleBar,sknsNormal,True,True);

    R.Left := R.Right-12;
    InflateRect(R,-1,-1);
    SkinManager.CurrentSkin.PaintBackground(Canvas,R,skncToolbarItem,sknsNormal,True,True);
    SpDrawGlyphPattern(Canvas, R, 0, CurrentSkin.GetTextColor(skncDockablePanelTitleBar, sknsNormal));
  end
  else
    inherited;
end;

constructor TCustomDockTree.Create(DockSite: TWinControl);
begin
  inherited Create(DockSite);
end;

Initialization
  Controls.DefaultDockTreeClass := TCustomDockTree;

finalization
  if InternalDockHandler <> nil then InternalDockHandler.Free;
end.
