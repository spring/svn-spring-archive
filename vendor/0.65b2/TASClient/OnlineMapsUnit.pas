unit OnlineMapsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, HttpProt, Buttons, GraphicEx;

const
  MAPLIST_TEMP_FILENAME = 'maplist_temp.dat';
  MINIMAP_TEMP_FILENAME = 'minimap_temp.dat';

type
  TOnlineMapsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label13: TLabel;
    CloseButton: TButton;
    UpdateButton: TButton;
    ScrollBox1: TScrollBox;
    NoMinimap: TImage;
    HttpCli1: THttpCli;
    StatusLabel: TLabel;
    Label1: TLabel;
    Button1: TButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure AddOnlineMap(MapName, DownloadLink, MinimapLink, PageLink: string);
    procedure FreeAllOnlineMaps; // note: this will not free the OnlineMaps list, only its contents!
    procedure LoadOnlineMapsFromCache(DirPath: string);
    procedure SaveOnlineMapsToCache(DirPath: string);
    procedure ClearCache;

    function DoesOnlineMapExist(FileName: string): Integer;
    procedure ScrollToMap(Index: Integer);

    procedure FormCreate(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  protected
    procedure Execute; override;
  public
  end;


var
  OnlineMapsForm: TOnlineMapsForm;
  OnlineMaps: TList; // of TOnlineMap objects
  UpdatingMaps: Boolean = False;

implementation

uses Unit1, ShellAPI, StringParser, BattleFormUnit, StrUtils, HttpGetUnit,
     PreferencesFormUnit, Misc;

{$R *.dfm}

procedure TOnlineMapsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
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
  for i := 0 to BattleForm.MapList.Items.Count - 1 do if Copy(BattleForm.MapList.Items[i], 1, Length(BattleForm.MapList.Items[i]) - 4) = Copy(MapFilename, 1, Length(MapFilename) - 4) then
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
  ShellExecute(MainForm.Handle, nil, PChar(TOnlineMap(OnlineMaps[Self.Tag]).PageLink), '', '', SW_SHOW);
end;

procedure TOnlineMap.DownloadButtonClick(Sender: TObject);
var
  i: Integer;
  MapExists: Boolean;
begin
  MapExists := False;
  for i := 0 to BattleForm.MapList.Items.Count - 1 do if Copy(BattleForm.MapList.Items[i], 1, Length(BattleForm.MapList.Items[i]) - 4) = Copy(MapFilename, 1, Length(MapFilename) - 4) then
  begin
    MapExists := True;
    Break;
  end;

  if MapExists then
    if MessageDlg('It seems you already have this map. Are you sure you wish to download it again?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  if (Copy(MapFilename, Length(MapFilename)-2, 3) <> 'sdz') and (Copy(MapFilename, Length(MapFilename)-2, 3) <> 'sd7') then
    if MessageDlg('This map is not a .sd7/.sdz file, are you sure you wish to download it? (You will have to manually decompress it if you choose yes)', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  if DownloadStatus.Downloading then
  begin
    MessageDlg('Cannot start download - another download already in progress.', mtInformation, [mbOK], 0);
    Exit;
  end;

  DownloadFile.URL := DownloadLink;
  DownloadFile.FileName := 'Maps\' + MapFilename;
  DownloadFile.ServerOptions := 4;
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
  DirPath := ExtractFilePath(Application.ExeName) + CACHE_FOLDER;

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

procedure TOnlineMapsForm.LoadOnlineMapsFromCache(DirPath: string); // Note: you should call it only when program starts and not in the middle of program execution, since it may clash with TUpdateThrd when updating online maps
var
  i: Integer;
  f: TextFile;
  s1, s2, s3, s4: string;
  FileName: string;

  GraphicClass: TGraphicExGraphicClass;
  Graphic: TGraphic;
  Picture: TPicture;
begin
  if not DirectoryExists(DirPath) then
  begin
    MessageDlg('Error reading cached "online maps" - cache folder does not exist!', mtError, [mbOK], 0);
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

      AddOnlineMap(s1, s2, s3, s4);

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

end;

procedure TOnlineMapsForm.AddOnlineMap(MapName, DownloadLink, MinimapLink, PageLink: string);
begin
  OnlineMaps.Add(TOnlineMap.Create(50 - OnlineMapsForm.ScrollBox1.HorzScrollBar.Position, 10 + OnlineMaps.Count * 120 - OnlineMapsForm.ScrollBox1.VertScrollBar.Position, OnlineMaps.Count, MapName, DownloadLink, MinimapLink, PageLink, OnlineMapsForm.ScrollBox1));
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
  ShellExecute(MainForm.Handle, nil, 'http://www.fileuniverse.com/?page=listing&ID=121', '', '', SW_SHOW);
end;

procedure TOnlineMapsForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TOnlineMapsForm.UpdateButtonClick(Sender: TObject);
begin
  if not UpdatingMaps then TUpdateThrd.Create(False)
  else MessageDlg('Update already in progress!', mtInformation, [mbOK], 0);
end;

procedure TUpdateThrd.Execute;
var
  i: Integer;
  f: TextFile;
  s: string;
  sl: TStringList;
  maplist: TStringList;
  tmpbool: Boolean;
  GraphicClass: TGraphicExGraphicClass;
  Graphic: TGraphic;
  FileName: string;
begin
  if UpdatingMaps then Exit; // this should not happen!
  UpdatingMaps := True;

  FreeOnTerminate := True; // when Execute method finishes, thread should be freed

  Synchronize(OnlineMapsForm.FreeAllOnlineMaps);
  Synchronize(OnlineMapsForm.ClearCache);

//  OnlineMapsForm.HttpCli1.URL := 'http://users.sentvid.org/~tomaz/taspring/maplist.txt';
  OnlineMapsForm.HttpCli1.URL := 'http://www.fileuniverse.com/?page=betalord';

  OnlineMapsForm.StatusLabel.Caption := 'Retrieving map list ...';

  try

    try
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
      maplist := Misc.CreateMapListFromHtml(sl);
    except
      OnlineMapsForm.StatusLabel.Caption := 'Error while parsing map html file!';
      UpdatingMaps := False;
      maplist.Free;
      Exit;
    end;
  finally
    sl.Free;
  end;

  // add map objects:
  for i := 0 to maplist.Count-1 do
  begin
    sl := ParseString(maplist[i], '+');
    if sl.Count <> 4 then
    begin
      sl.Free;
      Continue;
    end;
    OnlineMapsForm.AddOnlineMap(sl[1], sl[3], sl[2], sl[0]);
    sl.Free;
  end;
  maplist.Free;

  // get minimap images:
  for i := 0 to OnlineMaps.Count-1 do
  begin
    if TOnlineMap(OnlineMaps[i]).MinimapLink = 'http://' then // minimap does not exist on web
    begin
      TOnlineMap(OnlineMaps[i]).MinimapDownloaded := False;
      OnlineMapsForm.StatusLabel.Caption := 'Skiping ' + TOnlineMap(OnlineMaps[i]).MapName + '...';
      Continue;
    end;

    tmpbool := True; // did we get the minimap?
    FileName := ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\' + MINIMAP_TEMP_FILENAME;

    OnlineMapsForm.HttpCli1.URL := TOnlineMap(OnlineMaps[i]).MinimapLink;
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

  UpdatingMaps := False;
end;


procedure TOnlineMapsForm.Button1Click(Sender: TObject);
begin
  FreeAllOnlineMaps;
  ClearCache;
end;

end.