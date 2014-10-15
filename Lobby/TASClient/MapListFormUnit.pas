unit MapListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Menus, TB2Item, SpTBXItem,
  SpTBXControls,SpTBXTabs, ComCtrls, JvExComCtrls, JvComCtrls, Utility,
  Misc, TntForms,Math,MainUnit, SpTBXEditors, SpTBXSkins;

const
  MAP_ITEM_WIDTH = 355;
  MAP_ITEM_HEIGHT = 125;

type
  // forward declarations:
  TMapItem = class;
  TMapItemPanel = class;
  TMapListForm = class;

  TMapListForm = class(TForm)
    SortStylePopupMenu: TSpTBXPopupMenu;
    mnuNoSorting: TSpTBXItem;
    mnuSortByName: TSpTBXItem;
    mnuSortByMapSize: TSpTBXItem;
    mnuSortByAvgWind: TSpTBXItem;
    mnuSortByMaxMetal: TSpTBXItem;
    SpTBXTitleBar1: TSpTBXTitleBar;
    ScrollBox1: TScrollBox;
    TopPanel: TSpTBXPanel;
    NoPreviewImage: TImage;
    TotalMapsLabel: TSpTBXLabel;
    CloseButton: TSpTBXButton;
    SpTBXLabel2: TSpTBXLabel;
    SortLabel: TSpTBXLabel;
    lblLoadMissingMinimaps: TSpTBXLabel;
    lblSearch: TSpTBXLabel;
    MinimapDisplayCheckbox: TSpTBXCheckBox;
    txtSearch: TSpTBXButtonEdit;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure ClearMapList;
    procedure AddMap; // will automatically add next map from the utility.pas' MapList list

    //function CompareMapItems(Map1: TMapItem; Map2: TMapItem; SortStyle: Byte): Integer;
    procedure SortMapList(SortStyle: Byte);
    procedure FilterMapList(s:WideString);
    procedure SortMapInList(Index: Integer; SortStyle: Byte);
    procedure SortStylePopupMenuItemClick(Sender: TObject);

    procedure LoadAllMissingMinimaps; // this will load and cache minimaps for all maps for which we haven't loaded/cached minimap yet. Note that this process may take up several minutes!
    function AreAllMinimapsLoaded: Boolean;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure SpTBXSpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SortLabelClick(Sender: TObject);
    procedure lblLoadMissingMinimapsClick(Sender: TObject);
    procedure txtSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure txtSearchChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MinimapDisplayCheckboxClick(Sender: TObject);
    procedure txtSearchSubEditButton0Click(Sender: TObject);
  private
    { Private declarations }
  public
    Maps: TList; // of TMapItem. Each map item's index tells us the index of the map in utility.pas' MapList list
    SortedMaps: TList; // this is a duplicate of 'Maps' list but with map items sorted correctly. We need it when sorting map list.

    procedure RepaintMapItems;
  end;

  TMapItemPanel = class(TSpTBXPanel)
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
  protected
    FMyGrade: Integer;
    FVisible: Boolean;
    FMinimalDisplay: Boolean;
    FMinHeightLoaded: Boolean;
    FMaxHeightLoaded: Boolean;
    FMinHeight: Float;
    FMaxHeight: Float;

    function TryToReadInfoFromCache: Boolean; // if successful, it will write info to MapInfo record but not change any visual information
    function TryToWriteInfoToCache: Boolean;
    function TryToReadMapImageFromCache: Boolean;
    function TryToWriteMapImageToCache: Boolean;
    procedure SetVisible(v: boolean);
    function GetMinHeight: Float;
    function GetMaxHeight: Float;
  public
    Index: Integer; // index of this map in Utility.pas' MapList list

    MapName: string;
    MapHash: integer; // in hexadecimal form

    MapInfoLoaded: Boolean;
    MapImageLoaded: Boolean;
    MapInfo: TMapInfo; // valid only if MapInfoLoaded is True!


    Boxes: TScript;

    MyGrade: Integer; // 0 if not graded yet, and 1 to 10 for the actual grade otherwise
    GlobalGrade: Float; // avarage grade based on votes from other users
    TotalVotes: Integer; // number of all votes (from all users)
    Changed: Boolean; // True when some field has been changed by the user, like grade or comments. This indicates that we have to save changes back to cache at some point. It gets automatically set to False once TryToWriteInfoToCache method is invoked successfully.

    MainPanel: TImage;
    MapImage: TImage;

    Width: Integer;
    Height: Integer;

    NoControl: Boolean;

    {
    MainPanel: TMapItemPanel; // parent of all other controls of this map item
    NameLabel: TSpTBXLabel;
    MapImage: TImage; // 200 x 200 pixels so that it fits battle screen as well

    TidalStrengthLabel: TSpTBXLabel;
    GravityLabel: TSpTBXLabel;
    MaxMetalLabel: TSpTBXLabel;
    ExtRadiusLabel: TSpTBXLabel;
    MinWindLabel: TSpTBXLabel;
    MaxWindLabel: TSpTBXLabel;

    TabControl: TSpTBXTabControl;
    SeparationBevel: TBevel;

    AuthorCommentsRichEdit: TRichEdit;
    MyCommentsRichEdit: TRichEdit;
    }

    constructor Create(AOwner: TWinControl; X, Y: Integer; Index: Integer; noControl: boolean = false);
    destructor Destroy; override;
    procedure LoadMapInfo; // will automatically attempt to load it from cache, or else it will read it from the map file itself
    function LoadMinimap(CacheOnly: Boolean; Bitmap: TBitmap = nil): Boolean; // will automatically attempt to load it from cache, or else it will read it from the map file itself. If CacheOnly is true, then it will attempt to read map from the cache only and not also from the map file itfself in case if reading from cache fails.
    procedure ApplyMapInfo;
    procedure MyCommentsRichEditChange(Sender: TObject);

    procedure OnMainPanelMouseEnter(Sender: TObject);
    procedure OnMainPanelMouseLeave(Sender: TObject);
    procedure MainPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MainPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MainPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    procedure SetMinimapDisplay(md: Boolean);
    procedure SetPosition(X,Y:integer);
    procedure Repaint;

    property Visible: Boolean read FVisible write SetVisible;

    property MinHeight: Float read GetMinHeight;
    property MaxHeight: Float read GetMaxHeight;
  end;

  function CompareMapItems(Item1, Item2: Pointer): Integer;
  function GetMapItem(Index: Integer): TMapItem;
  function FindMapItem(Hash: integer): TMapItem; // returns nil if not found

var
  MapListForm: TMapListForm;
  SyncSentAt: Cardinal = 0; // time (GetTickCount) when we sent last MAPGRADES command to the server. Use 0 if server already replied to it. Otherwise set timeout after 10 seconds.

implementation

uses BattleFormUnit, PreferencesFormUnit, InitWaitFormUnit,
  TntWideStrings, MapSelectionFormUnit, gnugettext,RegExpr;

{$R *.dfm}

procedure TMapListForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  {if not Preferences.TaskbarButtons then Exit;

  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;}
end;

function GetMapItem(Index: Integer): TMapItem;
begin
  Result := TMapItem(MapListForm.Maps[Index]);
end;

function FindMapItem(Hash: integer): TMapItem; // returns nil if not found
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
  Maps.Add(TMapItem.Create(ScrollBox1, 10, Maps.Count * MAP_ITEM_HEIGHT - ScrollBox1.VertScrollBar.Position, Maps.Count,Preferences.DisableMapDetailsLoading));
  TotalMapsLabel.Caption := _('Total maps: ') + IntToStr(Maps.Count);
end;

constructor TMapItem.Create(AOwner: TWinControl; X, Y: Integer; Index: Integer; noControl: boolean = false);
var
  temp: TSpTBXTabItem;
begin
  Self.Index := Index;
  Self.MapName := Utility.MapList[Index];
  Self.MapHash := Utility.MapChecksums.Items[Index];

  FMinHeightLoaded := False;
  FMaxHeightLoaded := False;

  MapInfoLoaded := False;
  MapImageLoaded := False;

  Width := MAP_ITEM_WIDTH;
  Height := MAP_ITEM_HEIGHT;

  MainPanel := nil;

  FVisible := True;
  FMinimalDisplay := False;

  Self.NoControl := noControl;

  if noControl then Exit;

  MainPanel := TImage.Create(AOwner);
  MainPanel.Top := Y;
  MainPanel.Left := X;
  MainPanel.AutoSize := False;
  MainPanel.Width := MAP_ITEM_WIDTH;
  MainPanel.Height := MAP_ITEM_HEIGHT;
  MainPanel.Picture.Bitmap.Width := MAP_ITEM_WIDTH;
  MainPanel.Picture.Bitmap.Height := MAP_ITEM_HEIGHT;
  MainPanel.Parent := AOwner;
  MainPanel.OnMouseDown := MainPanelMouseDown;
  MainPanel.OnMouseUp := MainPanelMouseUp;
  MainPanel.Cursor := crHandPoint;

  Repaint;

  {MainPanel := TMapItemPanel.Create(AOwner);
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
  MainPanel.BorderType := pbrRaised;
  MainPanel.TBXStyleBackground := True;
  
  MainPanel.Parent := AOwner;

  MapImage := nil;

  NameLabel := TSpTBXLabel.Create(MainPanel);
  NameLabel.Caption := MapName;
  NameLabel.Left := 5;
  NameLabel.Top := 4;
  NameLabel.Font.Style := [fsBold];
  NameLabel.OnMouseDown := MainPanelMouseDown;
  NameLabel.OnMouseUp := MainPanelMouseUp;
  NameLabel.ParentFont := True;
  NameLabel.Parent := MainPanel;
  //NameLabel.ParentColor := true;

  TabControl := TSpTBXTabControl.Create(MainPanel);
  TabControl.Left := 120;
  TabControl.Top := 20;
  TabControl.Width := 225;
  TabControl.Height := 95;
  TabControl.TabAutofit := True;

  TabControl.Parent := MainPanel;


  temp := TSpTBXTabItem.Create(MainPanel);
  temp.Caption := _('Details');
  TabControl.Items.Add(temp);

  temp := TSpTBXTabItem.Create(MainPanel);
  temp.Caption := _('Description');
  TabControl.Items.Add(temp);

  temp := TSpTBXTabItem.Create(MainPanel);
  temp.Caption := _('Comments');
  TabControl.Items.Add(temp);

  TidalStrengthLabel := TSpTBXLabel.Create(TabControl.Pages[0]);
  with TidalStrengthLabel do
  begin
    Caption := _('Tidal strength: ?');
    Left := 5;
    Top := 2;
    OnMouseDown := MainPanelMouseDown;
    OnMouseUp := MainPanelMouseUp;
    Parent := TabControl.Pages[0];
  end;

  GravityLabel := TSpTBXLabel.Create(TabControl.Pages[0]);
  with GravityLabel do
  begin
    Caption := _('Gravity: ?');
    Left := 5;
    Top := 17;
    OnMouseDown := MainPanelMouseDown;
    OnMouseUp := MainPanelMouseUp;
    Parent := TabControl.Pages[0];
  end;

  MaxMetalLabel := TSpTBXLabel.Create(TabControl.Pages[0]);
  with MaxMetalLabel do
  begin
    Caption := _('Max. metal: ?');
    Left := 5;
    Top := 32;
    OnMouseDown := MainPanelMouseDown;
    OnMouseUp := MainPanelMouseUp;
    Parent := TabControl.Pages[0];
  end;

  ExtRadiusLabel := TSpTBXLabel.Create(TabControl.Pages[0]);
  with ExtRadiusLabel do
  begin
    Caption := _('Extractor radius: ?');
    Left := 110;
    Top := 2;
    OnMouseDown := MainPanelMouseDown;
    OnMouseUp := MainPanelMouseUp;
    Parent := TabControl.Pages[0];
  end;

  MinWindLabel := TSpTBXLabel.Create(TabControl.Pages[0]);
  with MinWindLabel do
  begin
    Caption := _('Min. wind: ?');
    Left := 110;
    Top := 17;
    OnMouseDown := MainPanelMouseDown;
    OnMouseUp := MainPanelMouseUp;
    Parent := TabControl.Pages[0];
  end;

  MaxWindLabel := TSpTBXLabel.Create(TabControl.Pages[0]);
  with MaxWindLabel do
  begin
    Caption := _('Max. wind: ?');
    Left := 110;
    Top := 32;
    OnMouseDown := MainPanelMouseDown;
    OnMouseUp := MainPanelMouseUp;
    Parent := TabControl.Pages[0];
  end;

  AuthorCommentsRichEdit := TRichEdit.Create(TabControl.Pages[1]);
  AuthorCommentsRichEdit.Parent := TabControl.Pages[1];
  AuthorCommentsRichEdit.Align := alClient;
  AuthorCommentsRichEdit.ReadOnly := True;
  AuthorCommentsRichEdit.BorderStyle := bsNone;

  MyCommentsRichEdit := TRichEdit.Create(TabControl.Pages[2]);
  MyCommentsRichEdit.Parent := TabControl.Pages[2];
  MyCommentsRichEdit.Align := alClient;
  MyCommentsRichEdit.BorderStyle := bsNone;
  MyCommentsRichEdit.OnChange := MyCommentsRichEditChange;
  }
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
  MapImage.Free;

  inherited Destroy;
end;

procedure TMapItem.MyCommentsRichEditChange(Sender: TObject);
begin
  Self.Changed := True;
end;

procedure TMapItem.SetVisible(v: boolean);
begin
  if v = FVisible then Exit;
  FVisible := v;
  MainPanel.Visible := v and not FMinimalDisplay;
  MapImage.Visible := v and FMinimalDisplay;
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

  Filename := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER + '\' + IntToStr(MapHash) + '.info';
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
      // read global (public) grade and number of votes:
      Stream.ReadBuffer(GlobalGrade, SizeOf(GlobalGrade));
      Stream.ReadBuffer(TotalVotes, SizeOf(TotalVotes));
      // read comments:
      //Stream.ReadBuffer(len, SizeOf(len));
      //SetLength(s, len);
      //Stream.ReadBuffer(s[1], len);
      //if MainPanel <> nil then
        //MyCommentsRichEdit.Text := s;
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

  Filename := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER + '\' + IntToStr(MapHash) + '.info';

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
    //s := '';
    //if MainPanel <> nil then
    //  s := MyCommentsRichEdit.Text;
    //len := Length(s);
    //Stream.WriteBuffer(len, SizeOf(len));
    //Stream.WriteBuffer(s[1], Length(s));
    Stream.Free;
  except
    MainForm.AddMainLog(_('Error writing to cache: ') + Filename, Colors.Error);
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

  Filename := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER + '\' + IntToStr(MapHash) + '.mini';
  if not FileExists(Filename) then Exit;

  try
    Stream := TFileStream.Create(FileName, fmOpenRead);
    MapImage.Picture.Bitmap.LoadFromStream(Stream);
    Stream.Free;
  except
    MainForm.AddMainLog(_('Error reading from cache: ') + Filename, Colors.Error);
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

  Filename := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER + '\' + IntToStr(MapHash) + '.mini';

  try
    Stream := TFileStream.Create(FileName, fmCreate);
    MapImage.Picture.Bitmap.SaveToStream(Stream);
    Stream.Free;
  except
    MainForm.AddMainLog(_('Error writing to cache: ') + Filename, Colors.Error);
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

  Repaint;

  {if MainPanel <> nil then
  begin
    ApplyMapInfo(MapInfo);

    NameLabel.Caption := Copy(MapName, 1, Length(MapName) - Length(ExtractFileExt(MapName))) + ' (Size: ' + IntToStr(MapInfo.Width div 64) + ' x ' + IntToStr(MapInfo.Height div 64) + ')';
  end;}

  MapInfoLoaded := True;
end;

function TMapItem.LoadMinimap(CacheOnly: Boolean; Bitmap: TBitmap = nil): Boolean; // will automatically attempt to load it from cache, or else it will read it from the map file itself. If CacheOnly is true, then it will attempt to read map from the cache only and not also from the map file itfself in case if reading from cache fails.
var
  localBitmap: boolean;
begin
  Result := False;
  localBitmap := false;

  if NoControl then Exit;

  if MapImage = nil then
  begin
    MapImage := TImage.Create(MainPanel.Owner);
    MapImage.Width := 100;
    MapImage.Height := 100;
    MapImage.Picture.Bitmap.Width := 100;
    MapImage.Picture.Bitmap.Height := 100;
    MapImage.Stretch := False; // we will set 'Stretch' to true later when we'll load the actual minimap
    MapImage.Canvas.StretchDraw(Rect(0, 0, MapImage.Width, MapImage.Height), MapListForm.NoPreviewImage.Picture.Bitmap);
    MapImage.Transparent := False;
    MapImage.AutoSize := False;
    MapImage.OnMouseDown := MainPanelMouseDown;
    MapImage.OnMouseUp := MainPanelMouseUp;
    MapImage.Parent := MainPanel.Parent;
    MapImage.Visible := False;
    MapImage.Cursor := crHandPoint;
    MapImage.ShowHint := True;

    MapImage.Hint := MapName + EOL;

    MapImage.Hint := MapImage.Hint + EOL + _('Size: ') + IntToStr(MapInfo.Width div 64) + 'x' + IntToStr(MapInfo.Height div 64);
    MapImage.Hint := MapImage.Hint + EOL + _('Tidal strength: ') + IntToStr(MapInfo.TidalStrength);
    MapImage.Hint := MapImage.Hint + EOL + _('Gravity: ') + IntToStr(MapInfo.Gravity);
    MapImage.Hint := MapImage.Hint + EOL + _('Max. metal: ') + Format('%.5g', [MapInfo.Maxmetal]);
    MapImage.Hint := MapImage.Hint + EOL + _('Extractor radius: ') + IntToStr(MapInfo.ExtractorRadius);
    MapImage.Hint := MapImage.Hint + EOL + _('Min. wind: ') + IntToStr(MapInfo.MinWind);
    MapImage.Hint := MapImage.Hint + EOL + _('Max. wind: ') + IntToStr(MapInfo.MaxWind);
    MapImage.Hint := MapImage.Hint + EOL + EOL + MapInfo.Description;
  end;

  if not TryToReadMapImageFromCache then
  begin
    if CacheOnly then Exit;
    // ok lets read the map info from the map file and cache it right afterwards:
    if Bitmap = nil then
    begin
      Bitmap := TBitmap.Create;
      Utility.LoadMiniMap(MapName, Bitmap);
      localBitmap := true;
    end;

    MapImage.Picture.Bitmap.Canvas.Brush.Color := clBlack;
    MapImage.Picture.Bitmap.Canvas.FillRect(MapImage.Picture.Bitmap.Canvas.ClipRect);
    if (Self.MapInfo.Height > 0) and (Self.MapInfo.Width > 0) then
      if Self.MapInfo.Width > Self.MapInfo.Height then
      begin
        MapImage.Picture.Bitmap.Height := Round(MapImage.Picture.Bitmap.Width * Self.MapInfo.Height / Self.MapInfo.Width);
        //MapImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, MapImage.Picture.Bitmap.Width, , Bitmap);
      end
      else
      begin
        MapImage.Picture.Bitmap.Width := Round(MapImage.Picture.Bitmap.Height * Self.MapInfo.Width / Self.MapInfo.Height);
        //MapImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, Round(MapImage.Picture.Bitmap.Height * Self.MapInfo.Width / Self.MapInfo.Height), MapImage.Picture.Bitmap.Height), Bitmap);
      end;

    MapImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, MapImage.Picture.Bitmap.Width, MapImage.Picture.Bitmap.Height), Bitmap);
    if localBitmap then
      Bitmap.Free;

    TryToWriteMapImageToCache; // cache it
  end;
  //MapImage.Stretch := True;

  MainPanel.Picture.Bitmap.Canvas.Draw(5,20,MapImage.Picture.Graphic);

  MapImageLoaded := True;

  Result := True;
end;

procedure TMapItem.ApplyMapInfo;
begin
  Self.MapInfo := MapInfo;

  With MainPanel.Picture.Bitmap do
  begin
    Canvas.Brush.Style := Graphics.bsClear;
    Canvas.Font.Color :=  PreferencesForm.IfNotClNone(SkinManager.CurrentSkin.GetTextColor(skncLabel,sknsNormal),clWindowText);
    Canvas.Font.Style := [fsBold];
    Canvas.TextOut(5,4,MapName + ' (Size: ' + IntToStr(MapInfo.Width div 64) + ' x ' + IntToStr(MapInfo.Height div 64) + ')');
    Canvas.Font.Style := [];

    Canvas.TextOut(110,20,_('Tidal strength: ') + IntToStr(MapInfo.TidalStrength));
    Canvas.TextOut(110,36,_('Gravity: ') + IntToStr(MapInfo.Gravity));
    Canvas.TextOut(110,52,_('Max. metal: ') + Format('%.5g', [MapInfo.Maxmetal]));
    Canvas.TextOut(232,20,_('Extractor radius: ') + IntToStr(MapInfo.ExtractorRadius));
    Canvas.TextOut(232,36,_('Min. wind: ') + IntToStr(MapInfo.MinWind));
    Canvas.TextOut(232,52,_('Max. wind: ') + IntToStr(MapInfo.MaxWind));

    if SkinManager.GetSkinType = sknSkin then
      SkinManager.CurrentSkin.PaintBackground(Canvas,Rect(110,68,MAP_ITEM_WIDTH-5,MAP_ITEM_HEIGHT-5),skncPanel,sknsNormal,True,True)
    else
      SkinManager.CurrentSkin.PaintWindowFrame(Canvas,Rect(110,68,MAP_ITEM_WIDTH-5,MAP_ITEM_HEIGHT-5),True,False,1);

    Canvas.Brush.Style := Graphics.bsClear;
    DrawMultilineText(MapInfo.Description,Canvas,Rect(113,71,MAP_ITEM_WIDTH-8,MAP_ITEM_HEIGHT-8),alHLeft,alVTop,JustLeft,True);
  end;

  {TidalStrengthLabel.Caption := _('Tidal strength: ') + IntToStr(MapInfo.TidalStrength);
  GravityLabel.Caption := _('Gravity: ') + IntToStr(MapInfo.Gravity);
  MaxMetalLabel.Caption := _('Max. metal: ') + Format('%.5g', [MapInfo.Maxmetal]);
  ExtRadiusLabel.Caption := _('Extractor radius: ') + IntToStr(MapInfo.ExtractorRadius);
  MinWindLabel.Caption := _('Min. wind: ') + IntToStr(MapInfo.MinWind);
  MaxWindLabel.Caption := _('Max. wind: ') + IntToStr(MapInfo.MaxWind);
  AuthorCommentsRichEdit.Text := MapInfo.Description;}
end;

procedure TMapItem.SetMinimapDisplay(md: Boolean);
begin
  if md = FMinimalDisplay then Exit;
  FMinimalDisplay := md;

  MainPanel.Visible := not md and FVisible;
  MapImage.Visible := md and FVisible;

  if md then
  begin
    Width := MapImage.Width;
    Height := MapImage.Height;
  end
  else
  begin
    Width := MainPanel.Width;
    Height := MainPanel.Height;
  end;
end;

procedure TMapItem.SetPosition(X,Y:integer);
begin
  MainPanel.Top := Y;
  MainPanel.Left := X;

  MapImage.Top := Y;
  MapImage.Left := X;
end;

procedure TMapItem.Repaint;
begin
  if MainPanel = nil then Exit;
  if SkinManager.GetSkinType = sknSkin then
    SkinManager.CurrentSkin.PaintBackground(MainPanel.Picture.Bitmap.Canvas,MainPanel.Picture.Bitmap.Canvas.ClipRect,skncPanel,sknsNormal,True,True)
  else
  begin
    MainPanel.Picture.Bitmap.Canvas.Brush.Style := Graphics.bsSolid;
    MainPanel.Picture.Bitmap.Canvas.Brush.Color := clWindow;
    MainPanel.Picture.Bitmap.Canvas.FillRect(MainPanel.Picture.Bitmap.Canvas.ClipRect);
    SkinManager.CurrentSkin.PaintWindowFrame(MainPanel.Picture.Bitmap.Canvas,MainPanel.Picture.Bitmap.Canvas.ClipRect,True,False,1);
  end;

  if MapImageLoaded then
    MainPanel.Picture.Bitmap.Canvas.Draw(5,20,MapImage.Picture.Graphic);

  ApplyMapInfo;
end;

procedure TMapItem.OnMainPanelMouseEnter(Sender: TObject);
begin
//  (Sender as TMapItemPanel).BorderStyle := bsSingle;
//  (Sender as TMapItemPanel).BevelOuter := bvLowered;
  {(Sender as TMapItemPanel).TBXStyleBackground := False;
  (Sender as TMapItemPanel).Color := 9435324;
  NameLabel.Font.Color := clBlack;
  (Sender as TMapItemPanel).BevelWidth := 2;}
end;

procedure TMapItem.OnMainPanelMouseLeave(Sender: TObject);
begin
//  (Sender as TMapItemPanel).BorderStyle := bsNone;
//  (Sender as TMapItemPanel).BevelOuter := bvRaised;
  {(Sender as TMapItemPanel).TBXStyleBackground := True;
  (Sender as TMapItemPanel).Color := clBtnFace;
  NameLabel.Font.Color := clWindowText;
  (Sender as TMapItemPanel).BevelWidth := 1; }
end;

procedure TMapItem.MainPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //MainPanel.BevelOuter := bvLowered;
end;

procedure TMapItem.MainPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MapInfo: TMapInfo;
  Bitmap: TBitmap;
begin
  //MainPanel.BevelOuter := bvRaised;

  if not PtInRect(MainPanel.ClientRect, Point(X, Y)) then Exit; // if mouse is out of the panel rectangle then ignore the click

  if not MapImageLoaded then
    LoadMinimap(False);

  if BattleForm.IsBattleActive and (BattleState.Status = Joined) then
  begin
    if BattleState.AutoHost and Preferences.DisplayAutohostInterface then
      if BattleState.AutoHostType = 1 then
        MainForm.TryToSendCommand('SAYBATTLE', '!votemap ' + MapName)
      else
        MainForm.TryToSendCommand('SAYBATTLE', '!map ' + MapName)
    else
      MainForm.TryToSendCommand('SAYBATTLEEX', 'suggests ' + MapName);
    MapListForm.Close;
    Exit;
  end;

  if BattleForm.IsBattleActive and (BattleState.Battle.BattleType = 1) then
  begin
    MessageDlg(_('Cannot change map while hosting battle replay!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  // ok we are either not participating in a battle or we are and are its host at the same time
  BattleForm.ChangeMap(Index);

  if BattleForm.IsBattleActive and (BattleState.Status = Hosting) then
    BattleForm.SendBattleInfoToServer;

  MapListForm.Close;
end;

procedure TMapItem.MainPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //*** not done yet! (should be used with dragging elements when using custom sorting style, if it gets implemented at all)
end;

function TMapItem.GetMinHeight: Float;
begin
  if not FMinHeightLoaded then
  begin
    FMinHeight := GetMapMinHeight(PChar(MapName));
    MainForm.PrintUnitsyncErrors;
    FMinHeightLoaded := True;
  end;
  Result := FMinHeight;
end;
function TMapItem.GetMaxHeight: Float;
begin
  if not FMaxHeightLoaded then
  begin
    FMaxHeight := GetMapMaxHeight(PChar(MapName));
    MainForm.PrintUnitsyncErrors;
    FMaxHeightLoaded := True;
  end;
  Result := FMaxHeight;
end;

procedure TMapListForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  //Left := 10;
  //Top := 10;

  Maps := TList.Create;
  SortedMaps := TList.Create;

  //PopulateSortStylePopupMenu;
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

procedure TMapListForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMapListForm.SpTBXSpeedButton1Click(Sender: TObject);
begin
  MessageDlg(_('Syncing grades with the server means sending your local grades of all your maps to the server and at the same time retrieving global grades. Grades are accepted only from players with a rank above "beginner".'), mtInformation, [mbOK], 0);
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

procedure TMapListForm.SortMapList(SortStyle: Byte);
var
  i: Integer;
  j:Longint;
  tmp: Integer;
  mi: TMapItem;
begin
  SortedMaps.Sort(CompareMapItems);
  // simple bubble sort:
  {for i := SortedMaps.Count-1 downto 0 do
    for j := 0 to i-1 do
      if CompareMapItems(TMapItem(SortedMaps[j]), TMapItem(SortedMaps[j+1]), SortStyle) > 0 then
      begin
        // we don't want to update .Top properties here because that will cause excessive repainting and will slow down things (we will do it at the end)

        mi := SortedMaps[j];
        SortedMaps[j] := SortedMaps[j+1];
        SortedMaps[j+1] := mi;
      end;}

   FilterMapList(txtSearch.Text);
end;

procedure TMapListForm.FilterMapList(s:WideString);
var
  i,j,k:integer;
  nbItemPerLine: integer;
  re: TRegExpr;
begin
  if Preferences.DisableMapDetailsLoading then Exit;

  if SortedMaps.Count = 0 then Exit;

  for i:=0 to SortedMaps.Count-1 do
    TMapItem(SortedMaps[i]).SetMinimapDisplay(MinimapDisplayCheckbox.Checked);

  nbItemPerLine := Max(1,Floor(ScrollBox1.ClientWidth /  TMapItem(SortedMaps[0]).Width));
  j:=0;

  re := TRegExpr.Create;
  if s <> '' then
    re.Expression := s
  else
    re.Expression := '.*';

  for i := 0 to SortedMaps.Count - 1 do begin
    if TMapItem(SortedMaps[i]).MainPanel = nil then Exit; // happens when the map details loading is enabled back

    TMapItem(SortedMaps[i]).Visible := re.Exec(LowerCase(TMapItem(SortedMaps[i]).MapName)) and
                                      ((Utility.ModValidMaps = nil) or (Utility.ModValidMaps.Count = 0) or (Utility.ModValidMaps.IndexOf(TMapItem(SortedMaps[i]).MapName) >= 0));

    if TMapItem(SortedMaps[i]).Visible then
    begin
      TMapItem(SortedMaps[i]).SetPosition((j mod nbItemPerLine) * TMapItem(SortedMaps[i]).Width - ScrollBox1.HorzScrollBar.Position,
                                          Floor(j / nbItemPerLine) * TMapItem(SortedMaps[i]).Height - ScrollBox1.VertScrollBar.Position);
      j := j+1;
    end
    else
      TMapItem(SortedMaps[i]).MainPanel.Top := 0;
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
    if CompareMapItems(SortedMaps[Index], SortedMaps[i]) > 0 then
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
    if CompareMapItems(SortedMaps[Index], SortedMaps[i]) < 0 then
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
function CompareMapItems(Item1, Item2: Pointer): Integer;
var
  globalGradeVotes1,globalGradeVotes2 : integer;
  Map1,Map2: TMapItem;
begin
  Map1 := TMapItem(Item1);
  Map2 := TMapItem(Item2);
  case Preferences.MapSortStyle of
    // no sorting
    0: Result := 0;
    // sort by map name:
    1: Result := AnsiCompareText(Map1.MapName, Map2.MapName);
    // sort by map size:
    2: Result := (Map1.MapInfo.Width * Map1.MapInfo.Height - Map2.MapInfo.Width * Map2.MapInfo.Height);
    // sort by my grade:
    3: Result := Map2.MyGrade - Map1.MyGrade;
    // sort by global grade:
    4:
    begin
      globalGradeVotes1 := Round((Map1.GlobalGrade - 5)*Map1.TotalVotes);
      globalGradeVotes2 := Round((Map2.GlobalGrade - 5)*Map2.TotalVotes);
      if globalGradeVotes1 = globalGradeVotes2 then Result := 0 else if globalGradeVotes1 > globalGradeVotes2 then Result := -1 else Result := 1;
    end;
    // avg wind
    5: Result := Round((Map1.MapInfo.MaxWind+Map1.MapInfo.MinWind)/2)-Round((Map2.MapInfo.MaxWind+Map2.MapInfo.MinWind)/2);
    // max metal
    6: Result := CompareValue(Map1.MapInfo.MaxMetal,Map2.MapInfo.MaxMetal);
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

procedure TMapListForm.SortStylePopupMenuItemClick(Sender: TObject);
var
  i: Integer;
begin
  Preferences.MapSortStyle := (Sender as TSpTBXItem).Tag;

  for i := 0 to SortStylePopupMenu.Items.Count-1 do
    SortStylePopupMenu.Items[i].Checked := False;
  (Sender as TSpTBXItem).Checked := True;

  SortLabel.Caption := (Sender as TSpTBXItem).Caption;

  SortMapList(Preferences.MapSortStyle);
end;

procedure TMapListForm.lblLoadMissingMinimapsClick(Sender: TObject);
begin
  if MessageDlg('This will load and cache all minimaps that haven''t been loaded yet. This process may take several minutes, depending on amount of non-cached maps. Are you sure you wish to proceed?' + ' (Note: When you click on the map its minimap gets loaded and cached automatically)', mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;

  LoadAllMissingMinimaps;
end;

procedure TMapListForm.LoadAllMissingMinimaps;
begin
  InitWaitForm.ChangeCaption(_('Loading minimaps ...'));
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

procedure TMapListForm.txtSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    FilterMapList(txtSearch.Text);
end;

procedure TMapListForm.FormShow(Sender: TObject);
var
  i: integer;
begin
  case Preferences.MapSortStyle of
    0:
    begin
      mnuNoSorting.Checked := True;
      SortLabel.Caption := mnuNoSorting.Caption;
    end;
    1:
    begin
      mnuSortByName.Checked := True;
      SortLabel.Caption := mnuSortByName.Caption;
    end;
    2:
    begin
      mnuSortByMapSize.Checked := True;
      SortLabel.Caption := mnuSortByMapSize.Caption;
    end;
    5:
    begin
      mnuSortByAvgWind.Checked := True;
      SortLabel.Caption := mnuSortByAvgWind.Caption;
    end;
    6:
    begin
      mnuSortByMaxMetal.Checked := True;
      SortLabel.Caption := mnuSortByMaxMetal.Caption;
    end;
  end;

  FilterMapList(txtSearch.Text);
  txtSearch.SetFocus;
end;

procedure TMapListForm.txtSearchChange(Sender: TObject);
begin
  FilterMapList(txtSearch.Text);
end;

procedure TMapListForm.FormResize(Sender: TObject);
begin
  try
    FilterMapList(txtSearch.Text);
  except
  end;
end;

procedure TMapListForm.Button1Click(Sender: TObject);
begin
  ScrollBox1.Visible := True;
end;

procedure TMapListForm.MinimapDisplayCheckboxClick(Sender: TObject);
begin
  FilterMapList(txtSearch.Text);
end;

procedure TMapListForm.RepaintMapItems;
var
  i: integer;
begin
  for i:=0 to SortedMaps.Count-1 do
    TMapItem(SortedMaps[i]).Repaint;
end;

procedure TMapListForm.txtSearchSubEditButton0Click(Sender: TObject);
begin
  txtSearch.Text := '';
  FilterMapList('');
end;

end.
