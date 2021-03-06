unit OnlineMapsUnit;

interface
                                                                                                                                   
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, HttpProt, Buttons, GraphicEx, SpTBXItem,
  SpTBXControls, TBXDkPanels;

const
  MAPLIST_TEMP_FILENAME = 'maplist_temp.dat';
  MINIMAP_TEMP_FILENAME = 'minimap_temp.dat';

type
  TOnlineMapsForm = class(TForm)
    HttpCli1: THttpCli;
    OnShowTimer: TTimer;
    SpTBXTitleBar1: TSpTBXTitleBar;
    Panel2: TSpTBXPanel;
    Label13: TSpTBXLabel;
    StatusLabel: TSpTBXLabel;
    Label1: TSpTBXLabel;
    CloseButton: TSpTBXButton;
    UpdateButton: TSpTBXButton;
    Button1: TSpTBXButton;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    NoMinimap: TImage;
    NoMapsLabel: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure AddOnlineMap(MapName, DownloadLink, MinimapLink, PageLink: string);
    procedure RemoveOnlineMap(Index: Integer); // will move position of other maps accordingly
    procedure FreeAllOnlineMaps;
    procedure SaveOnlineMapsToCache(DirPath: string);
    procedure ClearCache;
    procedure SortMapsByName;

    function DoesOnlineMapExist(FileName: string): Integer;
    procedure ScrollToMap(Index: Integer);

    procedure FormCreate(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OnShowTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TOnlineMap = class
  public
    Top, Left: Integer;
    Tag: Integer;

    MapName: String;
    MapFilename: string;
    DownloadLink: string;
    MinimapLink: string;
    PageLink: string;

    Minimap: TImage;
    Label1: TLabel;
    DownloadButton: TSpeedButton;

    MinimapDownloaded: Boolean; // did we already download the minimap?

    constructor Create(X, Y, Tag: Integer; MapName, DownloadLink, MinimapLink, PageLink: string; AOwner: TWinControl);
    destructor Destroy; override;

    procedure MinimapClick(Sender: TObject);
    procedure DownloadButtonClick(Sender: TObject);
    procedure ChangeMinimap(Graphic: TGraphic);
  end;

  TUpdateThrd = class(TThread)
  private
    SParam1, SParam2, SParam3, SParam4: string; // string params used with synchronized methods
    IParam1: Integer; // integer param used with synchronized methods

    procedure SyncAddOnlineMap;
    procedure SyncRemoveOnlineMap;

  protected
    procedure Execute; override;
  public
  end;

  // this thread is used to read cached maps from disk when application launches
  TReadCacheThrd = class(TThread)
  private
    SParam1, SParam2, SParam3, SParam4: string; // string params used with synchronized methods

    procedure SyncAddOnlineMap;

  protected
    procedure Execute; override;
  public
  end;


var
  OnlineMapsForm: TOnlineMapsForm;
  OnlineMaps: TList; // of TOnlineMap objects
  UpdatingMaps: Boolean = False; // True while we are updating maps from the web site
  ReadingCache: Boolean = False; // this is True only short time after application is started (until all maps have been read from the cache)

implementation

uses MainUnit, ShellAPI, StringParser, BattleFormUnit, StrUtils, HttpGetUnit,
     PreferencesFormUnit, Misc, ExceptionUnit, Utility;

{$R *.dfm}

procedure TOnlineMapsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

{ TReadCacheThrd }

procedure TReadCacheThrd.Execute;
var
  i: Integer;
  f: TextFile;
  s1, s2, s3, s4: string;
  FileName: string;
  DirPath: string;

  GraphicClass: TGraphicExGraphicClass;
  Graphic: TGraphic;
  Picture: TPicture;

  StartTime: Cardinal;
begin

  FreeOnTerminate := True; // when Execute method finishes, thread should be freed
  Priority := tpLowest;

  ReadingCache := True;
  DirPath := ExtractFilePath(Application.ExeName) + ONLINE_CACHE_FOLDER;

  try
    OnlineMapsForm.StatusLabel.Caption := 'Reading cache ...';
    OnlineMapsForm.NoMapsLabel.Visible := False;

    StartTime := GetTickCount;

    if not DirectoryExists(DirPath) then
    begin
      Application.MessageBox('Error', 'Error reading cached "online maps" - cache folder does not exist!');
      Exit;
    end;

    i := 0;
    while True do
    begin
      {$I+}
      try
        AssignFile(f, DirPath + '\' + 'map' + IntToStr(i) + '.info');
        Reset(f);
        Readln(f, s1);
        Readln(f, s2);
        Readln(f, s3);
        Readln(f, s4);
        CloseFile(f);

        // synchronize adding new map with main thread:
        SParam1 := s1;
        SParam2 := s2;
        SParam3 := s3;
        SParam4 := s4;

        Synchronize(SyncAddOnlineMap);

        FileName := DirPath + '\' + 'map' + IntToStr(i) + '.minimap';
        if FileExists(FileName) then
        begin
          try
            // determine true file type from content rather than extension:
            GraphicClass := FileFormatList.GraphicFromContent(FileName);
            if GraphicClass = nil then
            begin
              Picture := TPicture.Create;
              Picture.Bitmap.LoadFromFile(FileName);
              TOnlineMap(OnlineMaps[i]).ChangeMinimap(Picture.Graphic);
              TOnlineMap(OnlineMaps[i]).MinimapDownloaded := True;
              Picture.Free;
            end
            else
            begin
              // GraphicFromContent always returns TGraphicExGraphicClass
              Graphic := GraphicClass.Create;
              Graphic.LoadFromFile(FileName);
              TOnlineMap(OnlineMaps[i]).ChangeMinimap(Graphic);
              TOnlineMap(OnlineMaps[i]).MinimapDownloaded := True;
            end;
          except
          end;
        end;

        Inc(i);
      except
        Break;
      end;
    end;

    // sort maps:
    OnlineMapsForm.SortMapsByName;

  //***  MainForm.AddMainLog(IntToStr(GetTickCount - StartTime) + ' ms taken to load online maps cached data!', Colors.Info);

  finally
    OnlineMapsForm.NoMapsLabel.Visible := OnlineMaps.Count = 0;
    ReadingCache := False;
    OnlineMapsForm.StatusLabel.Caption := 'Done reading cache.';
  end;

end;

procedure TReadCacheThrd.SyncAddOnlineMap;
begin
  OnlineMapsForm.AddOnlineMap(SParam1, SParam2, SParam3, SParam4);
end;


{ TOnlineMap }

constructor TOnlineMap.Create(X, Y, Tag: Integer; MapName, DownloadLink, MinimapLink, PageLink: string; AOwner: TWinControl);
var
  i, p: Integer;
  MapExists: Boolean;
begin

  Left := X;
  Top := Y;
  Self.Tag := Tag;

  Self.MapName := MapName;
  Self.DownloadLink := DownloadLink;
  Self.MinimapLink := MinimapLink;
  Self.PageLink := PageLink;

  MinimapDownloaded := False;

  // extract map filename from download link:
  p := 1;
  repeat
    i := PosEx('/', DownloadLink, p+1);
    if i = 0 then Break;
    p := i;
  until False;
  Self.MapFilename := Copy(DownloadLink, p+1, Length(DownloadLink)-p);

  Minimap := TImage.Create(AOwner);
  Minimap.Visible := False; // must be set right after a call to a constructor. We don't want the image to appear on screen before we have fully initialized it
  Minimap.Parent := AOwner;
  Minimap.AutoSize := False;
  Minimap.Width := 100;
  Minimap.Height := 100;
  Minimap.Stretch := False;
  Minimap.Cursor := crHandPoint;
  Minimap.Picture.Bitmap.Assign(OnlineMapsForm.NoMinimap.Picture.Bitmap);
  Minimap.Tag := Tag;
  Minimap.Left := X;
  Minimap.Top := Y;
  Minimap.OnClick := MinimapClick;
  Minimap.Visible := True; // only after we have initialized it

  Label1 := TLabel.Create(AOwner);
  Label1.Left := X + Minimap.Width + 10;
  Label1.Top := Y + 5;
  Label1.Caption := MapName;
  Label1.Font.Name := 'Fixedsys';
  // let's find out if we already have this map:
  MapExists := False;
  for i := 0 to Utility.MapList.Count - 1 do if Copy(Utility.MapList[i], 1, Length(Utility.MapList[i]) - 4) = Copy(MapFilename, 1, Length(MapFilename) - 4) then
  begin
    MapExists := True;
    Break;
  end;
  if MapExists then Label1.Font.Color := clGreen
  else if (Copy(MapFilename, Length(MapFilename)-2, 3) <> 'sdz') and (Copy(MapFilename, Length(MapFilename)-2, 3) <> 'sd7') then Label1.Font.Color := clYellow
  else Label1.Font.Color := clBlack;
  Label1.Parent := AOwner;

  DownloadButton := TSpeedButton.Create(AOwner);
  DownloadButton.Caption := 'Download';
  DownloadButton.Left := X + Minimap.Width + 10;
  DownloadButton.Top := Y + Minimap.Height - DownloadButton.Height;
  DownloadButton.Width := 100;
  DownloadButton.OnClick := DownloadButtonClick;
  DownloadButton.Parent := AOwner;
end;

procedure TOnlineMap.ChangeMinimap(Graphic: TGraphic);
begin
  Minimap.Picture.Graphic := Graphic;
end;

procedure TOnlineMap.MinimapClick(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(TOnlineMap(OnlineMaps[Self.Tag]).PageLink);
end;

procedure TOnlineMap.DownloadButtonClick(Sender: TObject);
var
  i: Integer;
  MapExists: Boolean;
begin
  MapExists := False;
  for i := 0 to Utility.MapList.Count - 1 do if Copy(Utility.MapList[i], 1, Length(Utility.MapList[i]) - 4) = Copy(MapFilename, 1, Length(MapFilename) - 4) then
  begin
    MapExists := True;
    Break;
  end;

  if MapExists then
    if MessageDlg('It seems you already have this map. Are you sure you wish to download it again?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  if (LowerCase(Copy(MapFilename, Length(MapFilename)-2, 3)) <> 'sdz') and (LowerCase(Copy(MapFilename, Length(MapFilename)-2, 3)) <> 'sd7') then
    if MessageDlg('This map is not a .sd7/.sdz file, are you sure you wish to download it? (You will have to manually decompress it if you choose yes)', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  if DownloadStatus.Downloading then
  begin
    MessageDlg('Cannot start download - another download already in progress.', mtInformation, [mbOK], 0);
    Exit;
  end;

  DownloadFile.URL := DownloadLink;
  DownloadFile.FileName := 'Maps\' + MapFilename;
  DownloadFile.ServerOptions := 0;
  PostMessage(HttpGetForm.Handle, WM_STARTDOWNLOAD, 0, 0);

end;

destructor TOnlineMap.Destroy;
begin
  Minimap.Free;
  Label1.Free;
  DownloadButton.Free;
  inherited Destroy;
end;

{ TOnlineMapsForm }

// returns -1 if map does not exist
function TOnlineMapsForm.DoesOnlineMapExist(FileName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to OnlineMaps.Count-1 do
    if Copy(TOnlineMap(OnlineMaps[i]).MapFilename, 1, Length(TOnlineMap(OnlineMaps[i]).MapFilename) - 4) = Copy(FileName, 1, Length(FileName) - 4) then
    begin
      Result := i;
      Exit;
    end;
end;

procedure TOnlineMapsForm.ScrollToMap(Index: Integer);
begin
  if (Index >= 0) and (Index < OnlineMaps.Count) then
    ScrollBox1.VertScrollBar.Position := TOnlineMap(OnlineMaps[Index]).Top;
end;

procedure TOnlineMapsForm.ClearCache;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  DirPath: string;
begin
  DirPath := ExtractFilePath(Application.ExeName) + ONLINE_CACHE_FOLDER;

  if not DirectoryExists(DirPath) then
  begin
    MessageDlg('Unable to clear cache - cache folder does not exist!', mtError, [mbOK], 0);
    Exit;
  end;

  FileAttrs := faAnyFile;

  {$I+}

  try
    if FindFirst(DirPath + '\*.*', FileAttrs, sr) = 0 then
    begin
      if (sr.Name <> '.') and (sr.Name <> '..') then
        DeleteFile(DirPath + '\' + sr.Name);

      while FindNext(sr) = 0 do
        if (sr.Name <> '.') and (sr.Name <> '..') then
          DeleteFile(DirPath + '\' + sr.Name);

      FindClose(sr);
    end;
  except
  end;

end;

procedure TOnlineMapsForm.SaveOnlineMapsToCache(DirPath: string);
var
  i: Integer;
  f: TextFile;
begin
  if not DirectoryExists(DirPath) then
  begin
    MessageDlg('Error caching "online maps" - cache folder does not exist!', mtError, [mbOK], 0);
    Exit;
  end;

  for i := 0 to OnlineMaps.Count-1 do
  begin
    {$I+}
    try
      AssignFile(f, DirPath + '\' + 'map' + IntToStr(i) + '.info');
      Rewrite(f);

      Writeln(f, TOnlineMap(OnlineMaps[i]).MapName);
      Writeln(f, TOnlineMap(OnlineMaps[i]).DownloadLink);
      Writeln(f, TOnlineMap(OnlineMaps[i]).MinimapLink);
      Writeln(f, TOnlineMap(OnlineMaps[i]).PageLink);
      CloseFile(f);

      if TOnlineMap(OnlineMaps[i]).MinimapDownloaded then
        TOnlineMap(OnlineMaps[i]).Minimap.Picture.Graphic.SaveToFile(DirPath + '\' + 'map' + IntToStr(i) + '.minimap')
    except
    end;
  end;

end;

procedure TOnlineMapsForm.AddOnlineMap(MapName, DownloadLink, MinimapLink, PageLink: string);
begin
  OnlineMaps.Add(TOnlineMap.Create(50 - OnlineMapsForm.ScrollBox1.HorzScrollBar.Position, 10 + OnlineMaps.Count * 120 - OnlineMapsForm.ScrollBox1.VertScrollBar.Position, OnlineMaps.Count, MapName, DownloadLink, MinimapLink, PageLink, OnlineMapsForm.ScrollBox1));
end;

// removes TOnlineMap dynamically and moves positions of other online maps accordingly. When clearing entire map list, use FreeAllOnlinemaps method rather than this one, since this one is very slow.
procedure TOnlineMapsForm.RemoveOnlineMap(Index: Integer);
var
  i: Integer;
  map: TOnlineMap;
begin
  TOnlineMap(OnlineMaps[Index]).Free;

  for i := Index+1 to OnlineMaps.Count-1 do with TOnlineMap(OnlineMaps[i]) do
  begin
    Top := 10 + (i-1) * 120 - OnlineMapsForm.ScrollBox1.VertScrollBar.Position;
    DownloadButton.Top := Top + Minimap.Height - DownloadButton.Height;
    Label1.Top := Top + 5;
    Minimap.Top := Top; // minimap's top property should be assigned last (read under "notes" about it)

    Tag := Tag - 1;
    Minimap.Tag := Minimap.Tag - 1;
  end;

  OnlineMaps.Delete(Index);
end;

procedure TOnlineMapsForm.SortMapsByName;
var
  i, j: Integer;
  c: Integer;
begin
  // simple bubble sort:
  for i := OnlineMaps.Count-1 downto 0 do
    for j := 0 to i-1 do
      if AnsiCompareText(TOnlineMap(OnlineMaps[j]).MapName, TOnlineMap(OnlineMaps[j+1]).MapName) > 0 then
      begin
        c := TOnlineMap(OnlineMaps[j]).Top;
        TOnlineMap(OnlineMaps[j]).Top := TOnlineMap(OnlineMaps[j+1]).Top;
        TOnlineMap(OnlineMaps[j+1]).Top := c;

        c := TOnlineMap(OnlineMaps[j]).DownloadButton.Top;
        TOnlineMap(OnlineMaps[j]).DownloadButton.Top := TOnlineMap(OnlineMaps[j+1]).DownloadButton.Top;
        TOnlineMap(OnlineMaps[j+1]).DownloadButton.Top := c;

        c := TOnlineMap(OnlineMaps[j]).Label1.Top;
        TOnlineMap(OnlineMaps[j]).Label1.Top := TOnlineMap(OnlineMaps[j+1]).Label1.Top;
        TOnlineMap(OnlineMaps[j+1]).Label1.Top := c;

        c := TOnlineMap(OnlineMaps[j]).Minimap.Top;
        TOnlineMap(OnlineMaps[j]).Minimap.Top := TOnlineMap(OnlineMaps[j+1]).Minimap.Top;
        TOnlineMap(OnlineMaps[j+1]).Minimap.Top := c;

        c := TOnlineMap(OnlineMaps[j]).Tag;
        TOnlineMap(OnlineMaps[j]).Tag := TOnlineMap(OnlineMaps[j+1]).Tag;
        TOnlineMap(OnlineMaps[j+1]).Tag := c;

        c := TOnlineMap(OnlineMaps[j]).Minimap.Tag;
        TOnlineMap(OnlineMaps[j]).Minimap.Tag := TOnlineMap(OnlineMaps[j+1]).Minimap.Tag;
        TOnlineMap(OnlineMaps[j+1]).Minimap.Tag := c;

        OnlineMaps.Exchange(j, j+1);
      end;
end;

procedure TOnlineMapsForm.FormCreate(Sender: TObject);
begin
  Left := 10;
  Top := 10;

  OnlineMaps := TList.Create;
  HttpCli1.SocksLevel := '5';
end;

procedure TOnlineMapsForm.FormDestroy(Sender: TObject);
begin
  FreeAllOnlineMaps;
  OnlineMaps.Free;
end;

procedure TOnlineMapsForm.FreeAllOnlineMaps; // note: this will not free the OnlineMaps list, only its contents!
var
  i: Integer;
begin
  for i := 0 to OnlineMaps.Count-1 do TOnlineMap(OnlineMaps[i]).Free;
  OnlineMaps.Clear;
end;

procedure TOnlineMapsForm.Label13Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(MAPS_PAGE_LINK);
end;

procedure TOnlineMapsForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TOnlineMapsForm.UpdateButtonClick(Sender: TObject);
begin
  if ReadingCache then
  begin
    MessageDlg('Unable to start update - caching in progress. Please retry in a second or so.' + #13#10 +
               'If update still won''t be able to start, then please report this problem to ' + SendBugReportAddress, mtWarning, [mbOK], 0);
    Exit;
  end;

  if not UpdatingMaps then TUpdateThrd.Create(False)
  else MessageDlg('Update already in progress!', mtInformation, [mbOK], 0);
end;

procedure TUpdateThrd.SyncAddOnlineMap;
begin
  OnlineMapsForm.AddOnlineMap(SParam1, SParam2, SParam3, SParam4);
end;

procedure TUpdateThrd.SyncRemoveOnlineMap;
begin
  OnlineMapsForm.RemoveOnlineMap(IParam1);
end;

procedure TUpdateThrd.Execute;
var
  i, j: Integer;
  f: TextFile;
  s: string;
  sl: TStringList;
  maps: TStringList;
  tmpbool: Boolean;
  GraphicClass: TGraphicExGraphicClass;
  Graphic: TGraphic;
  FileName: string;
begin
  if UpdatingMaps then Exit; // this should not happen!
  UpdatingMaps := True;

  FreeOnTerminate := True; // when Execute method finishes, thread should be freed

  Synchronize(OnlineMapsForm.ClearCache);

  OnlineMapsForm.HttpCli1.URL := 'http://www.fileuniverse.com/?page=betalord';

  OnlineMapsForm.StatusLabel.Caption := 'Retrieving map list ...';

  try

    try

      if Preferences.UseProxy then
      begin
        OnlineMapsForm.HttpCli1.Proxy := Preferences.ProxyAddress;
        OnlineMapsForm.HttpCli1.ProxyPort := IntToStr(Preferences.ProxyPort);
        OnlineMapsForm.HttpCli1.ProxyUsername := Preferences.ProxyUsername;
        OnlineMapsForm.HttpCli1.ProxyPassword := Preferences.ProxyPassword;
      end
      else OnlineMapsForm.HttpCli1.Proxy := '';

      OnlineMapsForm.HttpCli1.RcvdStream := TFileStream.Create(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\' + MAPLIST_TEMP_FILENAME, fmCreate);
      OnlineMapsForm.HttpCli1.Get;
      OnlineMapsForm.StatusLabel.Caption := 'Done.';
    except
      on E: EHttpException do
      begin
        OnlineMapsForm.StatusLabel.Caption := 'Failed : ' + IntToStr(OnlineMapsForm.HttpCli1.StatusCode) + ' ' + OnlineMapsForm.HttpCli1.ReasonPhrase;
        UpdatingMaps := False;
        Exit;
      end
      else
      begin
        OnlineMapsForm.StatusLabel.Caption := 'Error retrieving map list!';
        UpdatingMaps := False;
        raise;
      end;
    end;

  finally
    try
      OnlineMapsForm.HttpCli1.RcvdStream.Destroy;
    except
    end;
    OnlineMapsForm.HttpCli1.RcvdStream := nil;
  end;

  {$I+}
  sl := TStringList.Create;
  try
    AssignFile(f, ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\' + MAPLIST_TEMP_FILENAME);
    Reset(f);
    while not Eof(f) do
    begin
      Readln(f, s);
      sl.Add(s);
    end;
    CloseFile(f);
  except
    UpdatingMaps := False;
    sl.Free;
    Exit;
  end;

  // parse html file:
  try
    try
      maps := Misc.CreateMapListFromHtml(sl);
    except
      OnlineMapsForm.StatusLabel.Caption := 'Error while parsing map html file!';
      UpdatingMaps := False;
      maps.Free;
      Exit;
    end;
  finally
    sl.Free;
  end;

  // remove redundant map objects:
  i := 0;
  while True do
  begin
    if i > OnlineMaps.Count-1 then Break;

    tmpbool := false;
    with TOnlineMap(OnlineMaps[i]) do s := PageLink + '+' + MapName + '+' + MinimapLink + '+' + DownloadLink;

    for j := 0 to maps.Count-1 do
      if s = maps[j] then
      begin
        tmpbool := True;
        Break;
      end;

    if not tmpbool then
    begin
      // remove map from online map list
      IParam1 := i;
      Synchronize(SyncRemoveOnlineMap);
    end
    else Inc(i);

  end;

  // add new map objects:
  for i := 0 to maps.Count-1 do
  begin
    tmpbool := False;
    for j := 0 to OnlineMaps.Count-1 do
    begin
      with TOnlineMap(OnlineMaps[j]) do s := PageLink + '+' + MapName + '+' + MinimapLink + '+' + DownloadLink;
      if s = maps[i] then
      begin
        tmpbool := True;
        Break;
      end;
    end;
    if tmpbool then Continue; // we skip adding this map since we already have it

    sl := ParseString(maps[i], '+');
    if sl.Count <> 4 then
    begin
      sl.Free;
      Continue;
    end;
    
    // synchronize adding new map with main thread:
    SParam1 := sl[1];
    SParam2 := sl[3];
    SParam3 := sl[2];
    SParam4 := sl[0];
    Synchronize(SyncAddOnlineMap);

    sl.Free;
  end;
  maps.Free;

  // get minimap images:
  for i := 0 to OnlineMaps.Count-1 do
  begin
    if TOnlineMap(OnlineMaps[i]).MinimapDownloaded then Continue; // skip it since we already have the minimap

    if TOnlineMap(OnlineMaps[i]).MinimapLink = 'http://' then // minimap does not exist on web
    begin
      TOnlineMap(OnlineMaps[i]).MinimapDownloaded := False;
      OnlineMapsForm.StatusLabel.Caption := TOnlineMap(OnlineMaps[i]).MapName + ' has been skipped.';
      Continue;
    end;

    tmpbool := True; // did we get the minimap?
    FileName := ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\' + MINIMAP_TEMP_FILENAME;

    s := TOnlineMap(OnlineMaps[i]).MinimapLink;
    FixURL(s); // don't try to fix MinimapLink directly, as it will create problems since map object comparision takes MinimapLink in account
    OnlineMapsForm.HttpCli1.URL := s;
    OnlineMapsForm.StatusLabel.Caption := 'Downloading minimap for ' + TOnlineMap(OnlineMaps[i]).MapName + '...';

    try

      try
        OnlineMapsForm.HttpCli1.RcvdStream := TFileStream.Create(FileName, fmCreate);
        OnlineMapsForm.HttpCli1.Get;
        OnlineMapsForm.StatusLabel.Caption := 'Done.';
      except
        on E: EHttpException do
        begin
          OnlineMapsForm.StatusLabel.Caption := 'Failed : ' + IntToStr(OnlineMapsForm.HttpCli1.StatusCode) + ' ' + OnlineMapsForm.HttpCli1.ReasonPhrase;
          tmpbool := False;
        end
        else
        begin
          OnlineMapsForm.StatusLabel.Caption := 'Error retrieving minimap images!';
          UpdatingMaps := False;
          tmpbool := False;
          raise;
        end;
      end;

    finally
      try
        OnlineMapsForm.HttpCli1.RcvdStream.Destroy;
      except
        tmpbool := False;
      end;
      OnlineMapsForm.HttpCli1.RcvdStream := nil;

      if tmpbool then // OK, we received the minimap successfully
      begin
        try
          // determine true file type from content rather than extension:
          GraphicClass := FileFormatList.GraphicFromContent(FileName);
          if GraphicClass = nil then {unknown graphics format!}
          else
          begin
            // GraphicFromContent always returns TGraphicExGraphicClass
            Graphic := GraphicClass.Create;
            Graphic.LoadFromFile(FileName);
            TOnlineMap(OnlineMaps[i]).ChangeMinimap(Graphic);

            TOnlineMap(OnlineMaps[i]).MinimapDownloaded := True;
          end;
        except
        end;

      end;

    end;

  end;

  // sort maps:
  Synchronize(OnlineMapsForm.SortMapsByName);

  UpdatingMaps := False;
end;


procedure TOnlineMapsForm.Button1Click(Sender: TObject);
begin
  if UpdatingMaps then
  begin
    MessageDlg('Can''t clear cache while update is in progress!', mtWarning, [mbOK], 0);
    Exit;
  end;

  FreeAllOnlineMaps;
  ClearCache;
end;

procedure TOnlineMapsForm.FormShow(Sender: TObject);
begin
  OnShowTimer.Enabled := True;
end;

procedure TOnlineMapsForm.OnShowTimerTimer(Sender: TObject);
begin
  OnShowTimer.Enabled := False;

  if (not ReadingCache) and (not UpdatingMaps) then if OnlineMaps.Count = 0 then
    if MessageDlg('Your "online map list" is empty. Do you wish to update it now?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      UpdateButton.OnClick(nil);
end;

end.
