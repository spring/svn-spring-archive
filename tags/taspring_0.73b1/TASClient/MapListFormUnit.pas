unit MapListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Menus, TB2Item, TBX, SpTBXItem,
  TBXDkPanels, SpTBXControls, TBXToolPals, SpTBXTabs, ComCtrls,
  JvExComCtrls, JvComCtrls, Utility;

const
  MAP_ITEM_WIDTH = 550;
  MAP_ITEM_HEIGHT = 125;

type
  // forward declarations:
  TMapItem = class;
  TMapItemPanel = class;
  TMapListForm = class;

  TMapListForm = class(TForm)
    TopPanel: TSpTBXPanel;
    ScrollBox1: TScrollBox;
    TotalMapsLabel: TSpTBXLabel;
    NoPreviewImage: TImage;
    ChooseGradePopupMenu: TSpTBXPopupMenu;
    CloseButton: TSpTBXButton;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    SpTBXItem1: TSpTBXItem;
    TBXToolPalette1: TTBXToolPalette;
    RemoveGradeItem: TSpTBXItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    SyncButton: TSpTBXButton;
    SpTBXSpeedButton1: TSpTBXSpeedButton;
    SpTBXLabel1: TSpTBXLabel;
    StatusLabel: TSpTBXLabel;
    SyncTimeoutTimer: TTimer;
    SpTBXLabel2: TSpTBXLabel;
    SortLabel: TSpTBXLabel;
    SortStylePopupMenu: TSpTBXPopupMenu;
    SpTBXLabel3: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure ClearMapList;
    procedure AddMap; // will automatically add next map from the utility.pas' MapList list
    function ChooseGradeDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;

    function CompareMapItems(Map1: TMapItem; Map2: TMapItem; SortStyle: Byte): Integer;
    procedure SortMapList(SortStyle: Byte);
    procedure SortMapInList(Index: Integer; SortStyle: Byte);    
    procedure PopulateSortStylePopupMenu;
    procedure SortStylePopupMenuItemClick(Sender: TObject);

    procedure LoadAllMissingMinimaps; // this will load and cache minimaps for all maps for which we haven't loaded/cached minimap yet. Note that this process may take up several minutes!
    function AreAllMinimapsLoaded: Boolean;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TBXToolPalette1CellClick(Sender: TTBXCustomToolPalette;
      var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure TBXToolPalette1CalcImageSize(Sender: TTBXCustomToolPalette;
      Canvas: TCanvas; var AWidth, AHeight: Integer);
    procedure TBXToolPalette1DrawCellImage(Sender: TTBXCustomToolPalette;
      Canvas: TCanvas; ARect: TRect; ACol, ARow: Integer; Selected, Hot,
      Enabled: Boolean);
    procedure SpTBXSpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SyncButtonClick(Sender: TObject);
    procedure SyncTimeoutTimerTimer(Sender: TObject);
    procedure SortLabelClick(Sender: TObject);
    procedure SpTBXLabel3Click(Sender: TObject);
  private
    { Private declarations }
  public
    Maps: TList; // of TMapItem. Each map item's index tells us the index of the map in utility.pas' MapList list
    SortedMaps: TList; // this is a duplicate of 'Maps' list but with map items sorted correctly. We need it when sorting map list.
  end;

  TMapItemPanel = class(TPanel)
  private
    fOnMouseEnter : TNotifyEvent;
    fOnMouseLeave : TNotifyEvent;
  protected
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  public
    ParentMapItem: TMapItem;
  published
    property OnMouseEnter : TNotifyEvent read fOnMouseEnter write fOnMouseEnter;
    property OnMouseLeave : TNotifyEvent read fOnMouseLeave write fOnMouseLeave;
  end;

  TMapItem = class
  public
    Index: Integer; // index of this map in Utility.pas' MapList list

    MapName: string;
    MapHash: string; // in hexadecimal form

    MapInfoLoaded: Boolean;
    MapImageLoaded: Boolean;
    MapInfo: TMapInfo; // valid only if MapInfoLoaded is True!

    MyGrade: Integer; // 0 if not graded yet, and 1 to 10 for the actual grade otherwise
    GlobalGrade: Float; // avarage grade based on votes from other users
    TotalVotes: Integer; // number of all votes (from all users)
    Changed: Boolean; // True when some field has been changed by the user, like grade or comments. This indicates that we have to save changes back to cache at some point. It gets automatically set to False once TryToWriteInfoToCache method is invoked successfully.

    MainPanel: TMapItemPanel; // parent of all other controls of this map item
    NameLabel: TLabel;
    MapImage: TImage; // 200 x 200 pixels so that it fits battle screen as well
    GradeButton: TTBXButton;
    PublicGradeInfoLabel: TLabel;
    PublicGradeLabel: TLabel;

    TidalStrengthLabel: TLabel;
    GravityLabel: TLabel;
    MaxMetalLabel: TLabel;
    ExtRadiusLabel: TLabel;
    MinWindLabel: TLabel;
    MaxWindLabel: TLabel;

    TabControl: TSpTBXTabControl;
    SeparationBevel: TBevel;

    AuthorCommentsRichEdit: TRichEdit;
    MyCommentsRichEdit: TRichEdit;

    constructor Create(AOwner: TWinControl; X, Y: Integer; Index: Integer);
    destructor Destroy; override;
    procedure LoadMapInfo; // will automatically attempt to load it from cache, or else it will read it from the map file itself
    function LoadMinimap(CacheOnly: Boolean): Boolean; // will automatically attempt to load it from cache, or else it will read it from the map file itself. If CacheOnly is true, then it will attempt to read map from the cache only and not also from the map file itfself in case if reading from cache fails.
    procedure ApplyMapInfo(MapInfo: TMapInfo);
    procedure GradeButtonClick(Sender: TObject);
    procedure MyCommentsRichEditChange(Sender: TObject);

    procedure OnMainPanelMouseEnter(Sender: TObject);
    procedure OnMainPanelMouseLeave(Sender: TObject);
    procedure MainPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MainPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MainPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    FMyGrade: Integer;

    function TryToReadInfoFromCache: Boolean; // if successful, it will write info to MapInfo record but not change any visual information
    function TryToWriteInfoToCache: Boolean;
    function TryToReadMapImageFromCache: Boolean;
    function TryToWriteMapImageToCache: Boolean;

    procedure LabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MapImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MapImagemouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;

  function GetMapItem(Index: Integer): TMapItem;
  function FindMapItem(Hash: string): TMapItem; // returns nil if not found

var
  MapListForm: TMapListForm;
  SyncSentAt: Cardinal = 0; // time (GetTickCount) when we sent last MAPGRADES command to the server. Use 0 if server already replied to it. Otherwise set timeout after 10 seconds.

implementation

uses BattleFormUnit, PreferencesFormUnit, Unit1, InitWaitFormUnit;

{$R *.dfm}

procedure TMapListForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow; // note: don't assign BattleForm.Handle here since this form gets created BEFORE BattleForm and so the handle would be invalid!
  end;
end;

function GetMapItem(Index: Integer): TMapItem;
begin
  Result := TMapItem(MapListForm.Maps[Index]);
end;

function FindMapItem(Hash: string): TMapItem; // returns nil if not found
var
  i: Integer;
begin
  for i := 0 to MapListForm.Maps.Count-1 do
    if GetMapItem(i).MapHash = Hash then
    begin
      Result := GetMapItem(i);
      Exit;
    end;
  Result := nil;
end;

procedure TMapItemPanel.CMMouseEnter(var Msg: TMessage);
begin
  if assigned(fOnMouseEnter) then
    fOnMouseEnter(self);
  inherited;
end;

procedure TMapItemPanel.CMMouseLeave(var Msg: TMessage);
begin
  if assigned(fOnMouseLeave) then
    fOnMouseLeave(self);
  inherited;
end;

procedure TMapListForm.ClearMapList;
var
  i: Integer;
begin
  for i := 0 to Maps.Count-1 do
    TObject(Maps[i]).Free;
  Maps.Clear;
  SortedMaps.Clear;
end;

procedure TMapListForm.AddMap;
begin
  Maps.Add(TMapItem.Create(ScrollBox1, 10, Maps.Count * MAP_ITEM_HEIGHT - ScrollBox1.VertScrollBar.Position, Maps.Count));
  TotalMapsLabel.Caption := 'Total maps: ' + IntToStr(Maps.Count);
end;

constructor TMapItem.Create(AOwner: TWinControl; X, Y: Integer; Index: Integer);
var
  temp: TSpTBXTabItem;
begin
  Self.Index := Index;
  Self.MapName := Utility.MapList[Index];
  Self.MapHash := Utility.MapChecksums[Index];

  MyGrade := 0;
  GlobalGrade := 0;
  TotalVotes := 0;

  MapInfoLoaded := False;
  MapImageLoaded := False;

  MainPanel := TMapItemPanel.Create(AOwner);
  MainPanel.Left := X;
  MainPanel.Top := Y;
  MainPanel.Width := MAP_ITEM_WIDTH;
  MainPanel.Height := MAP_ITEM_HEIGHT;
  MainPanel.OnMouseEnter := OnMainPanelMouseEnter;
  MainPanel.OnMouseLeave := OnMainPanelMouseLeave;
  MainPanel.OnMouseDown := MainPanelMouseDown;
  MainPanel.OnMouseUp := MainPanelMouseUp;
  MainPanel.OnMouseMove := MainPanelMouseMove;
  MainPanel.DoubleBuffered := True; // how much memory does this eat?
  MainPanel.ParentMapItem := Self;
  MainPanel.Parent := AOwner;

  MapImage := TImage.Create(MainPanel);
  MapImage.Left := 5;
  MapImage.Top := 20;
  MapImage.Width := 100;
  MapImage.Height := 100;
  MapImage.Picture.Bitmap.Width := 200;
  MapImage.Picture.Bitmap.Height := 200;
  MapImage.Stretch := False; // we will set 'Stretch' to true later when we'll load the actual minimap
  MapImage.Canvas.StretchDraw(Rect(0, 0, MapImage.Width, MapImage.Height), MapListForm.NoPreviewImage.Picture.Bitmap);
  MapImage.Transparent := False;
  MapImage.AutoSize := False;
  MapImage.OnMouseDown := MapImageMouseDown;
  MapImage.OnMouseUp := MapImageMouseUp;
  MapImage.Parent := MainPanel;

  NameLabel := TLabel.Create(MainPanel);
  NameLabel.Caption := MapName;
  NameLabel.Left := 5;
  NameLabel.Top := 4;
  NameLabel.Font.Style := [fsBold];
  NameLabel.Transparent := True;
  NameLabel.OnMouseDown := LabelMouseDown;
  NameLabel.OnMouseUp := LabelMouseUp;
  NameLabel.Parent := MainPanel;

  GradeButton := TTBXButton.Create(MainPanel);
  GradeButton.Left := 114;
  GradeButton.Top := 20;
  GradeButton.Width := 77;
  GradeButton.Height := 20;
  GradeButton.Caption := 'my grade:';
  GradeButton.Images := MainForm.GradesImageList;
  GradeButton.ImageIndex := 0;
  GradeButton.Layout := blGlyphRight;
  GradeButton.OnClick := GradeButtonClick;
  GradeButton.Enabled := False; // user is not allow to grade map before map info is loaded
  GradeButton.Parent := MainPanel;

  PublicGradeInfoLabel := TLabel.Create(MainPanel);
  PublicGradeInfoLabel.Caption := 'Global grade:';
  PublicGradeInfoLabel.Left := 120;
  PublicGradeInfoLabel.Top := 50;
  PublicGradeInfoLabel.OnMouseDown := LabelMouseDown;
  PublicGradeInfoLabel.OnMouseUp := LabelMouseUp;
  PublicGradeInfoLabel.Parent := MainPanel;

  PublicGradeLabel := TLabel.Create(MainPanel);
  PublicGradeLabel.Caption := '? (? votes)';
  PublicGradeLabel.Left := 120;
  PublicGradeLabel.Top := 65;
  PublicGradeLabel.OnMouseDown := LabelMouseDown;
  PublicGradeLabel.OnMouseUp := LabelMouseUp;
  PublicGradeLabel.Parent := MainPanel;

  TidalStrengthLabel := TLabel.Create(MainPanel);
  with TidalStrengthLabel do
  begin
    Caption := 'Tidal strength: ?';
    Left := 200;
    Top := 20;
    OnMouseDown := LabelMouseDown;
    OnMouseUp := LabelMouseUp;
    Parent := MainPanel;
  end;

  GravityLabel := TLabel.Create(MainPanel);
  with GravityLabel do
  begin
    Caption := 'Gravity: ?';
    Left := 200;
    Top := 35;
    OnMouseDown := LabelMouseDown;
    OnMouseUp := LabelMouseUp;
    Parent := MainPanel;
  end;

  MaxMetalLabel := TLabel.Create(MainPanel);
  with MaxMetalLabel do
  begin
    Caption := 'Max. metal: ?';
    Left := 200;
    Top := 50;
    OnMouseDown := LabelMouseDown;
    OnMouseUp := LabelMouseUp;
    Parent := MainPanel;
  end;

  ExtRadiusLabel := TLabel.Create(MainPanel);
  with ExtRadiusLabel do
  begin
    Caption := 'Extractor radius: ?';
    Left := 200;
    Top := 65;
    OnMouseDown := LabelMouseDown;
    OnMouseUp := LabelMouseUp;
    Parent := MainPanel;
  end;

  MinWindLabel := TLabel.Create(MainPanel);
  with MinWindLabel do
  begin
    Caption := 'Min. wind: ?';
    Left := 200;
    Top := 80;
    OnMouseDown := LabelMouseDown;
    OnMouseUp := LabelMouseUp;
    Parent := MainPanel;
  end;

  MaxWindLabel := TLabel.Create(MainPanel);
  with MaxWindLabel do
  begin
    Caption := 'Max. wind: ?';
    Left := 200;
    Top := 95;
    OnMouseDown := LabelMouseDown;
    OnMouseUp := LabelMouseUp;
    Parent := MainPanel;
  end;

  TabControl := TSpTBXTabControl.Create(MainPanel);
  TabControl.Left := 320;
  TabControl.Top := 20;
  TabControl.Width := 220;
  TabControl.Height := 100;
  TabControl.TabAutofit := True;
  TabControl.Parent := MainPanel;
  //*** this is a quick fix around black color problem that was introduced with SpTBX 1.8 (1.7?):
  case Preferences.ThemeType of
    thtNone: TabControl.ThemeType := tttNone;
    thtWindows: TabControl.ThemeType := tttWindows;
    thtTBX: TabControl.ThemeType := tttTBX;
  end; // of case

  temp := TSpTBXTabItem.Create(MainPanel);
  temp.Caption := 'Author''s comments';
  TabControl.Items.Add(temp);

  temp := TSpTBXTabItem.Create(MainPanel);
  temp.Caption := 'My comments';
  TabControl.Items.Add(temp);

  SeparationBevel := TBevel.Create(MainPanel);
  SeparationBevel.Left := TabControl.Left-1;
  SeparationBevel.Top := TabControl.Top-1;
  SeparationBevel.Width := TabControl.Width+2;
  SeparationBevel.Height := TabControl.Height+2;
  SeparationBevel.Style := bsRaised;
  SeparationBevel.Parent := MainPanel;

  AuthorCommentsRichEdit := TRichEdit.Create(TabControl.Pages[0]);
  AuthorCommentsRichEdit.Parent := TabControl.Pages[0];
  AuthorCommentsRichEdit.Align := alClient;
  AuthorCommentsRichEdit.ReadOnly := True;
  AuthorCommentsRichEdit.BorderStyle := bsNone;

  MyCommentsRichEdit := TRichEdit.Create(TabControl.Pages[1]);
  MyCommentsRichEdit.Parent := TabControl.Pages[1];
  MyCommentsRichEdit.Align := alClient;
  MyCommentsRichEdit.BorderStyle := bsNone;
  MyCommentsRichEdit.OnChange := MyCommentsRichEditChange;

  // finally: (this must be at the end of initialization since while loding data some things may trigger Changed:=True)
  Changed := False;
end;

destructor TMapItem.Destroy;
begin
  // save any changes back to the cache:
  if Changed then
  try
    TryToWriteInfoToCache;
  except
  end;

  MainPanel.Free;
//  MapImage.Free; --> no need, MainPanel will free its children anyway!

  inherited Destroy;
end;

procedure TMapItem.MyCommentsRichEditChange(Sender: TObject);
begin
  Self.Changed := True;
end;

function TMapItem.TryToReadInfoFromCache: Boolean;
var
  Filename: string;
  Stream: TFileStream;
  s: string;
  len: Integer;
  i: Integer;

begin
  Result := False;

  Filename := MAPS_CACHE_FOLDER + '\' + MapHash + '.info';
  if not FileExists(Filename) then Exit;

  try
    try
      Stream := TFileStream.Create(FileName, fmOpenRead);
      Stream.ReadBuffer(MapInfo, SizeOf(TMapInfo));
      PString(MapInfo.Description) := nil; // or else some random crashes may occur (tested!) as Delphi will try to free 'Description' first before reassigning it later on when we do "MapInfo.Description := s".
      Stream.ReadBuffer(len, SizeOf(len));
      SetLength(s, len);
      Stream.ReadBuffer(s[1], len);
      MapInfo.Description := s;
      // read grade:
      Stream.ReadBuffer(i, SizeOf(i));
      MyGrade := i;
      GradeButton.ImageIndex := i;
      // read global (public) grade and number of votes:
      Stream.ReadBuffer(GlobalGrade, SizeOf(GlobalGrade));
      Stream.ReadBuffer(TotalVotes, SizeOf(TotalVotes));
      PublicGradeLabel.Caption := Format('%2.1f (%d votes)', [GlobalGrade, TotalVotes]);
      // read comments:
      Stream.ReadBuffer(len, SizeOf(len));
      SetLength(s, len);
      Stream.ReadBuffer(s[1], len);
      MyCommentsRichEdit.Text := s;
    except
      MainForm.AddMainLog('Error reading from cache: ' + Filename, Colors.Error);
      Exit;
    end;
  finally
    try
      Stream.Free;
    except
    end;
  end;

  Result := True;
end;

function TMapItem.TryToWriteInfoToCache: Boolean;
var
  Filename: string;
  Stream: TFileStream;
  s: string;
  len: Integer;
  i: Integer;

begin
  Result := False;

  Filename := MAPS_CACHE_FOLDER + '\' + MapHash + '.info';

  try
    Stream := TFileStream.Create(FileName, fmCreate);
    Stream.WriteBuffer(MapInfo, SizeOf(TMapInfo));
    s := MapInfo.Description;
    len := Length(s);
    Stream.WriteBuffer(len, SizeOf(len));
    Stream.WriteBuffer(s[1], Length(s));
    // write my grade:
    i := MyGrade;
    Stream.WriteBuffer(i, SizeOf(i));
    // write global (public) grade and number of votes:
    Stream.WriteBuffer(GlobalGrade, SizeOf(GlobalGrade));
    Stream.WriteBuffer(TotalVotes, SizeOf(TotalVotes));
    // write comments:
    s := MyCommentsRichEdit.Text;
    len := Length(s);
    Stream.WriteBuffer(len, SizeOf(len));
    Stream.WriteBuffer(s[1], Length(s));
    Stream.Free;
  except
    MainForm.AddMainLog('Error writing to cache: ' + Filename, Colors.Error);
    Exit;
  end;

  Changed := False;

  Result := True;
end;

function TMapItem.TryToReadMapImageFromCache: Boolean;
var
  Filename: string;
  Stream: TFileStream;

begin
  Result := False;

  Filename := MAPS_CACHE_FOLDER + '\' + MapHash + '.mini';
  if not FileExists(Filename) then Exit;

  try
    Stream := TFileStream.Create(FileName, fmOpenRead);
    MapImage.Picture.Bitmap.LoadFromStream(Stream);
    Stream.Free;
  except
    MainForm.AddMainLog('Error reading from cache: ' + Filename, Colors.Error);
    Exit;
  end;

  Result := True;
end;

function TMapItem.TryToWriteMapImageToCache: Boolean;
var
  Filename: string;
  Stream: TFileStream;

begin
  Result := False;

  Filename := MAPS_CACHE_FOLDER + '\' + MapHash + '.mini';

  try
    Stream := TFileStream.Create(FileName, fmCreate);
    MapImage.Picture.Bitmap.SaveToStream(Stream);
    Stream.Free;
  except
    MainForm.AddMainLog('Error writing to cache: ' + Filename, Colors.Error);
    Exit;
  end;

  Result := True;
end;

procedure TMapItem.LoadMapInfo; // will automatically attempt to load it from cache, or else it will read it from the map file itself
begin
  if not TryToReadInfoFromCache then
  begin
    // ok lets read the map info from the map file and cache it right afterwards:
    MapInfo := Utility.AcquireMapInfo(MapName);
    TryToWriteInfoToCache; // cache it
  end;

  ApplyMapInfo(MapInfo);

  NameLabel.Caption := Copy(MapName, 1, Length(MapName) - Length(ExtractFileExt(MapName))) + ' (Size: ' + IntToStr(MapInfo.Width div 64) + ' x ' + IntToStr(MapInfo.Height div 64) + ')';

  GradeButton.Enabled := True; // user may now grade the map

  MapInfoLoaded := True;
end;

function TMapItem.LoadMinimap(CacheOnly: Boolean): Boolean; // will automatically attempt to load it from cache, or else it will read it from the map file itself. If CacheOnly is true, then it will attempt to read map from the cache only and not also from the map file itfself in case if reading from cache fails.
var
  Bitmap: TBitmap;
begin
  Result := False;

  if not TryToReadMapImageFromCache then
  begin
    if CacheOnly then Exit;
    // ok lets read the map info from the map file and cache it right afterwards:
    Bitmap := TBitmap.Create;
    Utility.LoadMiniMap(MapName, Bitmap);
    MapImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, MapImage.Picture.Bitmap.Width, MapImage.Picture.Bitmap.Height), Bitmap);
    Bitmap.Free;

    TryToWriteMapImageToCache; // cache it
  end;
  MapImage.Stretch := True;

  MapImageLoaded := True;

  Result := True;
end;

procedure TMapItem.ApplyMapInfo(MapInfo: TMapInfo);
begin
  Self.MapInfo := MapInfo;

  TidalStrengthLabel.Caption := 'Tidal strength: ' + IntToStr(MapInfo.TidalStrength);
  GravityLabel.Caption := 'Gravity: ' + IntToStr(MapInfo.Gravity);
  MaxMetalLabel.Caption := 'Max. metal: ' + Format('%.5g', [MapInfo.Maxmetal]);
  ExtRadiusLabel.Caption := 'Extractor radius: ' + IntToStr(MapInfo.ExtractorRadius);
  MinWindLabel.Caption := 'Min. wind: ' + IntToStr(MapInfo.MinWind);
  MaxWindLabel.Caption := 'Max. wind: ' + IntToStr(MapInfo.MaxWind);
  AuthorCommentsRichEdit.Text := MapInfo.Description;
end;

procedure TMapItem.OnMainPanelMouseEnter(Sender: TObject);
begin
//  (Sender as TMapItemPanel).BorderStyle := bsSingle;
//  (Sender as TMapItemPanel).BevelOuter := bvLowered;
  (Sender as TMapItemPanel).Color := 9435324;
  (Sender as TMapItemPanel).BevelWidth := 2;
end;

procedure TMapItem.OnMainPanelMouseLeave(Sender: TObject);
begin
//  (Sender as TMapItemPanel).BorderStyle := bsNone;
//  (Sender as TMapItemPanel).BevelOuter := bvRaised;
  (Sender as TMapItemPanel).Color := clBtnFace;
  (Sender as TMapItemPanel).BevelWidth := 1;
end;

procedure TMapItem.MainPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TMapItemPanel).BevelOuter := bvLowered;
end;

procedure TMapItem.MainPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MapInfo: TMapInfo;
  Bitmap: TBitmap;
begin
  (Sender as TMapItemPanel).BevelOuter := bvRaised;

  if not PtInRect((Sender as TMapItemPanel).ClientRect, Point(X, Y)) then Exit; // if mouse is out of the panel rectangle then ignore the click

  if not (Sender as TMapItemPanel).ParentMapItem.MapImageLoaded then
    (Sender as TMapItemPanel).ParentMapItem.LoadMinimap(False);

  if BattleForm.IsBattleActive and (BattleState.Status = Joined) then
  begin
    MainForm.TryToSendData('SAYBATTLEEX ' + 'suggests ' + (Sender as TMapItemPanel).ParentMapItem.MapName);
    MapListForm.Close;
    Exit;
  end;

  if BattleForm.IsBattleActive and (BattleState.Battle.BattleType = 1) then
  begin
    MessageDlg('Cannot change map while hosting battle replay!', mtWarning, [mbOK], 0);
    Exit;
  end;

  // ok we are either not participating in a battle or we are and are its host at the same time
  BattleForm.ChangeMap((Sender as TMapItemPanel).ParentMapItem.Index);

  if BattleForm.IsBattleActive and (BattleState.Status = Hosting) then
    BattleForm.SendBattleInfoToServer;

  MapListForm.Close;
end;

procedure TMapItem.MainPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //*** not done yet! (should be used with dragging elements when using custom sorting style, if it gets implemented at all)
end;

procedure TMapItem.LabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  p := ((Sender as TLabel).Parent as TMapItemPanel).ScreenToClient((Sender as TLabel).ClientToScreen(Point(X, Y)));

  ((Sender as TLabel).Parent as TMapItemPanel).OnMouseDown((Sender as TLabel).Parent, Button, Shift, p.X, p.Y);
end;

procedure TMapItem.LabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  p := ((Sender as TLabel).Parent as TMapItemPanel).ScreenToClient((Sender as TLabel).ClientToScreen(Point(X, Y)));

  ((Sender as TLabel).Parent as TMapItemPanel).OnMouseUp((Sender as TLabel).Parent, Button, Shift, p.X, p.Y);
end;

procedure TMapItem.MapImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  p := ((Sender as TImage).Parent as TMapItemPanel).ScreenToClient((Sender as TImage).ClientToScreen(Point(X, Y)));

  ((Sender as TImage).Parent as TMapItemPanel).OnMouseDown((Sender as TImage).Parent, Button, Shift, p.X, p.Y);
end;

procedure TMapItem.MapImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  p := ((Sender as TImage).Parent as TMapItemPanel).ScreenToClient((Sender as TImage).ClientToScreen(Point(X, Y)));

  ((Sender as TImage).Parent as TMapItemPanel).OnMouseUp((Sender as TImage).Parent, Button, Shift, p.X, p.Y);
end;

procedure TMapItem.GradeButtonClick(Sender: TObject);
var
  res: Integer; // "result"
begin
  res := MapListForm.ChooseGradeDialog(GradeButton, MyGrade-1);
  if res > -1 then
  begin
    MyGrade := res + 1;
    GradeButton.ImageIndex := res + 1;
  end
  else if res = -2 then
  begin
    MyGrade := 0;
    GradeButton.ImageIndex := 0;
  end;

  MapListForm.SortMapInList(MapListForm.SortedMaps.IndexOf(Self), Preferences.MapSortStyle);

  // indicates that we must save changes user has made at some point:
  Self.Changed := True;
end;

procedure TMapListForm.FormCreate(Sender: TObject);
begin
  Left := 10;
  Top := 10;

  Maps := TList.Create;
  SortedMaps := TList.Create;

  PopulateSortStylePopupMenu;
end;

procedure TMapListForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Maps.Count-1 do
    TObject(Maps[i]).Free;
  Maps.Free;
  SortedMaps.Free;
end;

{ returns -1 if user cancels the dialog, otherwise returns cell index
  (if user chooses 1, the returned index is 0!).
  Specify DefaultIndex to indicate which cell is "default",
  that is currently selected cell in "choose grade dialog" (use -1 if you don't
  want any cell to be selected) - again, 0 means first cell is selected.
  Returns -2 if "Remove grade" button is clicked.
  "UnderControl" is the control under which the dialog should be displayed. }
function TMapListForm.ChooseGradeDialog(UnderControl: TControl; DefaultIndex: Integer): Integer;
var
  p: TPoint;
  Item: TTBCustomItem;
begin
  if DefaultIndex = -1 then
    TBXToolPalette1.SelectedCell := Point(-1, -1)
  else
    TBXToolPalette1.SelectedCell := Point(DefaultIndex mod TBXToolPalette1.ColCount, DefaultIndex div TBXToolPalette1.ColCount);

  p := UnderControl.ClientToScreen(Point(0, UnderControl.Height));
  Item := ChooseGradePopupMenu.PopupEx(p.X, p.Y, nil, False);

  if Item = nil then
  begin
    Result := -1;
    Exit;
  end;

  if Item.ClassType = TSpTBXItem then if Item.Name = 'RemoveGradeItem' then
  begin
    Result := -2;
    Exit;
  end;

  if Item.ClassType <> TTBXToolPalette then
  begin
    Result := -1;
    Exit;
  end;

  Result := Item.Tag;
end;

procedure TMapListForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMapListForm.TBXToolPalette1CellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
begin
  // we keep selection information in Tag property:
  Sender.Tag := ACol + ARow * (Sender as TTBXToolPalette).ColCount;
end;

procedure TMapListForm.TBXToolPalette1CalcImageSize(
  Sender: TTBXCustomToolPalette; Canvas: TCanvas; var AWidth,
  AHeight: Integer);
begin
  AWidth := 16;
  AHeight := 16;
end;

procedure TMapListForm.TBXToolPalette1DrawCellImage(
  Sender: TTBXCustomToolPalette; Canvas: TCanvas; ARect: TRect; ACol,
  ARow: Integer; Selected, Hot, Enabled: Boolean);
begin
  MainForm.GradesImageList.Draw(Canvas, ARect.Left, ARect.Top, ACol + ARow * (Sender as TTBXToolPalette).ColCount + 1);
end;

procedure TMapListForm.SpTBXSpeedButton1Click(Sender: TObject);
begin
  MessageDlg('Syncing grades with the server means sending your local grades of all your maps to the server and at the same time retrieving global grades. Grades are accepted only from players with a rank above "beginner".', mtInformation, [mbOK], 0);
end;

procedure TMapListForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: Integer;
begin
  // write any changes made by the user back to the cache (not really neccessary as any
  // changes will be saved once the objects are freed, but just in case if program crashes
  // before that - we don't want to loose all changes in that case). Note though that saving
  // changes only here would not be enough since this form may never receive OnClose event
  // at all, for example when application closes, the main form receives OnClose event,
  // but any child forms do not!

  for i := 0 to Maps.Count-1 do
    if TMapItem(Maps[i]).Changed then
      TMapItem(Maps[i]).TryToWriteInfoToCache;
end;

procedure TMapListForm.SyncButtonClick(Sender: TObject);
var
  i: Integer;
  command: string;
begin
  if not MainForm.AreWeLoggedIn then
  begin
    MessageDlg('You must first log on to the server!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if SyncSentAt <> 0 then
  begin
    MessageDlg('Synchronizing already in progress!', mtWarning, [mbOK], 0);
    Exit;
  end;

  // generate MAPGRADES command:
  command := 'MAPGRADES';
  for i := 0 to Maps.Count-1 do
    command := command + ' ' + GetMapItem(i).MapHash + ' ' + IntToStr(GetMapItem(i).MyGrade);
  MainForm.TryToSendData(command);

  StatusLabel.Caption := 'Waiting for response from server ...';
  SyncSentAt := GetTickCount;
  SyncTimeoutTimer.Enabled := True;
end;

procedure TMapListForm.SyncTimeoutTimerTimer(Sender: TObject);
begin
  if SyncSentAt = 0 then
  begin
    (Sender as TTimer).Enabled := False;
    Exit;
  end;

  if GetTickCount - SyncSentAt > 10000 then
  begin
    StatusLabel.Caption := 'No response from the server (timeout).';
    SyncSentAt := 0;
    (Sender as TTimer).Enabled := False;
    Exit;
  end;
end;

procedure TMapListForm.SortMapList(SortStyle: Byte);
var
  i, j: Integer;
  tmp: Integer;
  mi: TMapItem;
begin
  // simple bubble sort:
  for i := SortedMaps.Count-1 downto 0 do
    for j := 0 to i-1 do
      if CompareMapItems(TMapItem(SortedMaps[j]), TMapItem(SortedMaps[j+1]), SortStyle) > 0 then
      begin
        tmp := TMapItem(SortedMaps[j]).MainPanel.Top;
        TMapItem(SortedMaps[j]).MainPanel.Top := TMapItem(SortedMaps[j+1]).MainPanel.Top;
        TMapItem(SortedMaps[j+1]).MainPanel.Top := tmp;

        mi := SortedMaps[j];
        SortedMaps[j] := SortedMaps[j+1];
        SortedMaps[j+1] := mi;
      end;
end;

{ will determine correct position of the element within the list (will not sort other elements!).
  Note that Index should refer to index in SortedMaps list, not Maps list! }
procedure TMapListForm.SortMapInList(Index: Integer; SortStyle: Byte);
var
  i: Integer;
  tmp: Integer;
  mi: TMapItem;

begin
  if (Index < 0) or (Index > SortedMaps.Count-1) then Exit; // this should not happen!

  // sort down:
  for i := Index+1 to SortedMaps.Count-1 do
    if CompareMapItems(TMapItem(SortedMaps[Index]), TMapItem(SortedMaps[i]), SortStyle) > 0 then
    begin
      tmp := TMapItem(SortedMaps[i]).MainPanel.Top;
      TMapItem(SortedMaps[i]).MainPanel.Top := TMapItem(SortedMaps[Index]).MainPanel.Top;
      TMapItem(SortedMaps[Index]).MainPanel.Top := tmp;

      mi := SortedMaps[i];
      SortedMaps[i] := SortedMaps[Index];
      SortedMaps[Index] := mi;

      Inc(Index);
    end
    else Break;

  // sort up:
  for i := Index-1 downto 0 do
    if CompareMapItems(TMapItem(SortedMaps[Index]), TMapItem(SortedMaps[i]), SortStyle) < 0 then
    begin
      tmp := TMapItem(SortedMaps[i]).MainPanel.Top;
      TMapItem(SortedMaps[i]).MainPanel.Top := TMapItem(SortedMaps[Index]).MainPanel.Top;
      TMapItem(SortedMaps[Index]).MainPanel.Top := tmp;

      mi := SortedMaps[i];
      SortedMaps[i] := SortedMaps[Index];
      SortedMaps[Index] := mi;

      Dec(Index);
    end
    else Break;

end;

{ returns 0 if both maps are equal (by comparing by SortStyle), positive value if first is "greater" than second, or negative value
  otherwise. Note that resuls it not normalized, i.e. it doesn't return only -1,0,1, but can return arbitrary large positive
  and negative numbers. }
function TMapListForm.CompareMapItems(Map1: TMapItem; Map2: TMapItem; SortStyle: Byte): Integer;
begin
  case SortStyle of
    // no sorting
    0: Result := 0;
    // sort by map name:
    1: Result := AnsiCompareText(Map1.MapName, Map2.MapName);
    // sort by map size:
    2: Result := Map1.MapInfo.Width * Map1.MapInfo.Height - Map2.MapInfo.Width * Map2.MapInfo.Height;
    // sort by my grade:
    3: Result := Map2.MyGrade - Map1.MyGrade;
    // sort by global grade:
    4: if Map1.GlobalGrade = Map2.GlobalGrade then Result := 0 else if Map1.GlobalGrade > Map2.GlobalGrade then Result := -1 else Result := 1;
  else
    Result := 0;
  end;
end;

procedure TMapListForm.SortLabelClick(Sender: TObject);
var
  p: TPoint;
begin
  GetCursorPos(p);
  SortStylePopupMenu.Popup(p.X, p.Y);
end;

procedure TMapListForm.PopulateSortStylePopupMenu;
var
  i: Integer;
begin
  SortStylePopupMenu.Items.Clear;
  for i := 0 to High(MapSortStyleDescriptions) do
  begin
    SortStylePopupMenu.Items.Add(TSpTBXItem.Create(SortStylePopupMenu.Items.Owner));

    with SortStylePopupMenu.Items[SortStylePopupMenu.Items.Count-1] as TSpTBXItem do
    begin
      Caption := MapSortStyleDescriptions[i];
      Tag := i;
      RadioItem := True;
      OnClick := SortStylePopupMenuItemClick;
    end;
  end;
end;

procedure TMapListForm.SortStylePopupMenuItemClick(Sender: TObject);
var
  i: Integer;
begin
  Preferences.MapSortStyle := (Sender as TSpTBXItem).Tag;

  BattleForm.SetRadioItem(SortStylePopupMenu, (Sender as TSpTBXItem).Tag);
  SortLabel.Caption := MapSortStyleDescriptions[Preferences.MapSortStyle];

  SortMapList(Preferences.MapSortStyle);
end;

procedure TMapListForm.SpTBXLabel3Click(Sender: TObject);
begin
  if MessageDlg('This will load and cache all minimaps that haven''t been loaded yet. This process may take several minutes, depending on amount of non-cached maps. Are you sure you wish to proceed?' + ' (Note: When you click on the map its minimap gets loaded and cached automatically)', mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;

  LoadAllMissingMinimaps;
end;

procedure TMapListForm.LoadAllMissingMinimaps;
begin
  InitWaitForm.ChangeCaption('Loading minimaps ...');
  InitWaitForm.TakeAction := 6; // load minimaps
  InitWaitForm.ShowModal;
end;

function TMapListForm.AreAllMinimapsLoaded: Boolean;
var
  i: Integer;
begin
  for i := 0 to Maps.Count-1 do
    if not GetMapItem(i).MapImageLoaded then
    begin
      Result := False;
      Exit;
    end;
  Result := True;
end;

end.
