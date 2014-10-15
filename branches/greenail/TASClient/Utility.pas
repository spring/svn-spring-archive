{
  Usage: Call InitLib when program is started and DeInitLib when program gets closed. All other functions may be used only
  after library has been initialized.
}

unit Utility;

interface

uses
  Windows, Graphics, Classes, SyncObjs, Controls;

type

  Float = Single;

  TStartPos =
  record
    x: Integer;
    y: Integer;
  end;

  { minwind and maxwind are defined as ints in unitsync.h, but some maps like "Core_Prime_Industrial_Area_01" use
    float values in their .smd files (e.g. "MinWind=0.2"). I use unitsync.dll now so that is not a problem anymore. }
  PMapInfo = ^TMapInfo;
  TMapInfo =
  packed record
    Description: string; // cast it as PChar
    TidalStrength: Integer;
    Gravity: Integer;
    MaxMetal: Float;
    ExtractorRadius: Integer;
    MinWind: Integer;
    MaxWind: Integer;

    // 0.61b1+
    Width: Integer;
    Height: Integer;
    PosCount: Integer;
    Positions: array[0..15] of TStartPos;
  end;

  PMinimapData = ^TMinimapData;
  TMinimapData = array[0..1024*1024-1] of Word; // raw bitmap data returned by GetMinimap function from UnitSync.dll

function InitLib: Boolean;
function ReInitLib: Boolean;
function ReInitLibWithDialog: Boolean; // uses InitWaitForm to (re)initialize library
procedure DeInitLib;

procedure GetMapList(List: TStrings);
function LoadMiniMap(MapName: string; bmp: TBitmap): Boolean;
function AcquireMapInfo(MapName: string): TMapInfo;
procedure GetModList(ModList: TStrings; ModArchiveList: TStrings);
function GetModHash(ModName: string): Integer;
procedure LoadMod(ModName: string);
procedure GetUnitList(UnitNames, UnitList: TStrings); // unit names are just that, unit list is a list of "code names" of units
procedure GetSides(SideList: TStrings; SideImageList: TImageList); // populates side list and loads side images into image list

{since 0.68}function FindFilesArchive(archive, cur: Integer; nameBuf: PChar; var size: Integer): Integer; stdcall; external 'UnitSync.dll' name 'FindFilesArchive';
{since 0.68}function OpenArchive(name: PChar): Integer; stdcall; external 'UnitSync.dll' name 'OpenArchive';
{since 0.68}procedure CloseArchive(archive: Integer); stdcall; external 'UnitSync.dll' name 'CloseArchive';
{since 0.68}function OpenArchiveFile(archive: Integer; name: PChar): Integer; stdcall; external 'UnitSync.dll' name 'OpenArchiveFile';
{since 0.68}function ReadArchiveFile(archive: Integer; handle: Integer; buffer: Pointer; numBytes: Integer): Integer; stdcall; external 'UnitSync.dll' name 'ReadArchiveFile';
{since 0.68}procedure CloseArchiveFile(archive: Integer; handle: Integer); stdcall; external 'UnitSync.dll' name 'CloseArchiveFile';
{since 0.68}function SizeArchiveFile(archive: Integer; handle: Integer): Integer; stdcall; external 'UnitSync.dll' name 'SizeArchiveFile';

{since 0.68}function OpenFileVFS(const name: PChar): Integer; stdcall; external 'UnitSync.dll' name 'OpenFileVFS';
{since 0.68}procedure CloseFileVFS(handle: Integer); stdcall; external 'UnitSync.dll' name 'CloseFileVFS';
{since 0.68}procedure ReadFileVFS(handle: Integer; buf: Pointer; length: Integer); stdcall; external 'UnitSync.dll' name 'ReadFileVFS';
{since 0.68}function FileSizeVFS(handle: Integer): Integer; stdcall; external 'UnitSync.dll' name 'FileSizeVFS';
{since 0.68}function InitFindVFS(const pattern: PChar): Integer; stdcall; external 'UnitSync.dll' name 'InitFindVFS';
{since 0.68}function FindFilesVFS(handle: Integer; nameBuf: PChar; size: Integer): Integer; stdcall; external 'UnitSync.dll' name 'FindFilesVFS';

var
  ModList: TStrings; // names of mods
  ModArchiveList: TStrings; // names of files in which mods are

  UnitNames: TStrings;
  UnitList: TStrings;

  SideList: TStringList;
  SidePics: TImageList;

  LastInitSuccess: Boolean = True; // check this var to see if last call to InitLib/ReInitLib was successful!

implementation

uses
  SysUtils, StrUtils, Dialogs, Forms, Misc, Unit1, InitWaitFormUnit;


{ I assume bools are 1 byte in size (not 4) in unitsync.dll (from MSDN: "In Visual C++ 4.2,
  the Standard C++ header files contained a typedef that equated bool with int.
  In Visual C++ 5.0 and later, bool is implemented as a built-in type with a size
  of 1 byte. That means that for Visual C++ 4.2, a call of sizeof(bool) yields 4,
  while in Visual C++ 5.0 and later, the same call yields 1.") }

function Init(isServer: Boolean; id: Integer): Integer; stdcall; external 'UnitSync.dll' name 'Init';
procedure UnInit; stdcall; external 'UnitSync.dll' name 'UnInit';
function ProcessUnits: Integer; stdcall; external 'UnitSync.dll' name 'ProcessUnits';
{since 0.61}function ProcessUnitsNoChecksum: Integer; stdcall; external 'UnitSync.dll' name 'ProcessUnitsNoChecksum';
function GetCurrentList: PChar; stdcall; external 'UnitSync.dll' name 'GetCurrentList';
procedure AddClient(id: Integer; unitList: PChar); stdcall; external 'UnitSync.dll' name 'AddClient';
procedure RemoveClient(id: Integer); stdcall; external 'UnitSync.dll' name 'RemoveClient';
function GetClientDiff(id: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetClientDiff';
procedure InstallClientDiff(diff: PChar); stdcall; external 'UnitSync.dll' name 'InstallClientDiff';
function GetUnitCount: Integer; stdcall; external 'UnitSync.dll' name 'GetUnitCount';
function GetUnitName(unit_: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetUnitName';
function GetFullUnitName(unit_: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetFullUnitName';
function IsUnitDisabled(unit_: Integer): Integer; stdcall; external 'UnitSync.dll' name 'IsUnitDisabled';
function IsUnitDisabledByClient(unit_: Integer; clientId: Integer): Integer; stdcall; external 'UnitSync.dll' name 'IsUnitDisabledByClient';
{------------------------------------------------------------------------------}
function InitArchiveScanner: Integer; stdcall; external 'UnitSync.dll' name 'InitArchiveScanner';
procedure AddArchive(name: PChar); stdcall; external 'UnitSync.dll' name 'AddArchive';
procedure AddAllArchives(root: PChar); stdcall; external 'UnitSync.dll' name 'AddAllArchives';
{since 0.61}function GetArchiveChecksum(arname: PChar): LongWord; stdcall; external 'UnitSync.dll' name 'GetArchiveChecksum';
function GetMapCount: Integer; stdcall; external 'UnitSync.dll' name 'GetMapCount';
function GetMapName(index: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetMapName';
function GetMapInfo(name: PChar; outInfo: PMapInfo): Integer; stdcall; external 'UnitSync.dll' name 'GetMapInfo';
// GetMinimap returns void*, I cast it as PMinimapData
function GetMinimap(filename: PChar; miplevel: Integer): PMinimapData; stdcall; external 'UnitSync.dll' name 'GetMinimap';
{------------------------------------------------------------------------------}
function GetPrimaryModCount: Integer; stdcall; external 'UnitSync.dll' name 'GetPrimaryModCount';
function GetPrimaryModName(index: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetPrimaryModName';
function GetPrimaryModArchive(index: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetPrimaryModArchive';
{since 0.61}function GetPrimaryModArchiveCount(index: Integer): Integer; stdcall; external 'UnitSync.dll' name 'GetPrimaryModArchiveCount';
{since 0.61}function GetPrimaryModArchiveList(arnr: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetPrimaryModArchiveList';
function GetPrimaryModIndex(name: PChar): Integer; stdcall; external 'UnitSync.dll' name 'GetPrimaryModIndex';
{since 0.63} function GetSideCount: Integer; stdcall; external 'UnitSync.dll' name 'GetSideCount';
{since 0.63} function GetSideName(side: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetSideName';
{------------------------------------------------------------------------------}
// some internal routines:
function RED_RGB565(c: Word): Word; forward;
function GREEN_RGB565(c: Word): Word; forward;
function BLUE_RGB565(c: Word): Word; forward;
function PACKRGB(r, g, b: Word): Word; forward;


{ ------------------------------------------------------------------------ }

function RED_RGB565(c: Word): Word;
begin
  Result := (c and $F800) shr 11;
end;

function GREEN_RGB565(c: Word): Word;
begin
  Result := (c and $07E0) shr 5;
end;

function BLUE_RGB565(c: Word): Word;
begin
  Result := c and $001F;
end;

function PACKRGB(r, g, b: Word): Word;
begin
  Result :=
  ((r shl 11) and $F800) or
  ((g shl 5) and $07E0) or
  (b and $001F);
end;

{ ------------------------------------------------------------------------ }

function InitLib: Boolean;
begin
  Result := Init(False, 0) = 1;
  LastInitSuccess := Result;
  if not Result then Exit;
  InitArchiveScanner;
end;

function ReInitLib: Boolean;
begin
  UnInit;
  Result := InitLib;
  if not Result then Exit;
  // reload mod list:
  GetModList(ModList, ModArchiveList);
end;

function ReInitLibWithDialog: Boolean;
var
  res: Integer;
begin
  InitWaitForm.ChangeCaption(MSG_REINITLIB);
  InitWaitForm.TakeAction := 3; // (re)initialize unitsync library
  InitWaitForm.ShowModal;
  if not LastInitSuccess then
  begin
    MessageDlg('Error initializing unit syncer!', mtError, [mbOK], 0);
    Application.Terminate;
  end;
end;

procedure DeInitLib;
begin
  UnInit;
end;

{ ------------------------------------------------------------------------ }

procedure GetMapList(List: TStrings);
var
  i: Integer;
  MapCount: Integer;
begin
  List.Clear;

  MapCount := GetMapCount;
  for i := 0 to MapCount-1 do List.Add(GetMapName(i));
end;

{ ------------------------------------------------------------------------ }

function LoadMiniMap(MapName: string; bmp: TBitmap): Boolean;
var
  mipsize: Integer;
  minimap: PMinimapData;
  x, y: Integer;
  P: PByteArray;

begin
  Result := False;

  mipsize := 1024;

  minimap := GetMinimap(PChar(MapName), 0);

  bmp.PixelFormat := pf16bit;
  bmp.Width := 1024;
  bmp.Height := 1024;

  for y := 0 to bmp.Height -1 do
  begin
    P := bmp.ScanLine[y];

    for x := 0 to bmp.Width -1 do
    begin
      P[x*2+0] := Lo(minimap[y * mipsize + x]);
      P[x*2+1] := Hi(minimap[y * mipsize + x]);
    end;
  end;

  bmp.Modified := True; // force repaint

  Result := True;
end;

{ ------------------------------------------------------------------------ }

function AcquireMapInfo(MapName: string): TMapInfo;
var
  i: Integer;
begin
  SetLength(Result.Description, 256);
  GetMapInfo(PChar(MapName), @Result);
  Result.Width := Result.Width div 8;
  Result.Height := Result.Height div 8;
  for i := 1 to Length(Result.Description) do if Result.Description[i] = #0 then
  begin
    Result.Description := Copy(Result.Description, 1, i-1);
    Break;
  end;
end;

{ ------------------------------------------------------------------------ }

procedure GetModList(ModList: TStrings; ModArchiveList: TStrings);
var
  ModCount: Integer;
  i: Integer;
begin
  ModList.Clear;
  ModArchiveList.Clear;

  ModCount := GetPrimaryModCount;
  for i := 0 to ModCount-1 do
  begin
    ModList.Add(GetPrimaryModName(i));
    ModArchiveList.Add(GetPrimaryModArchive(i));
  end;
end;

{ ------------------------------------------------------------------------ }

{ this is a fast routine, should be done in less than 1 ms (as far as I've tested it) }
function GetModHash(ModName: string): Integer;
var
  index: Integer;
  i: Integer;
begin
  Result := 0;

  index := ModList.IndexOf(ModName);
  if index = -1 then Exit;

  for i := 0 to GetPrimaryModArchiveCount(index)-1 do
  begin
    if Debug.Enabled then MainForm.AddMainLog('Hashing file: ' + GetPrimaryModArchiveList(i), Colors.MinorInfo);
    Inc(Result, GetArchiveCheckSum(GetPrimaryModArchiveList(i)));
  end;

//  Result := Misc.HashFile(ExtractFilePath(Application.ExeName) + 'Mods\' + ModArchiveList[index]);
end;

{ ------------------------------------------------------------------------ }

{ don't forget to reinit unitsync.dll each time you change mod (except for the first time)! }
procedure LoadMod(ModName: string);
begin
  AddAllArchives(PChar(ModName));
end;

{ ------------------------------------------------------------------------ }

procedure GetUnitList(UnitNames, UnitList: TStrings); // unit names are just that, unit list is a list of "code names" of units
var
  i: Integer;
begin
  UnitNames.Clear;
  UnitList.Clear;

  // first process all units (this may take some time):
  while ProcessUnitsNoChecksum <> 0 do;

  for i := 0 to GetUnitCount-1 do
  begin
    UnitNames.Add(GetFullUnitName(i));
    UnitList.Add(GetUnitName(i));
  end;
end;

{ ------------------------------------------------------------------------ }

procedure GetSides(SideList: TStrings; SideImageList: TImageList);
var
  i: Integer;
  s: string;
  side: string;
  res: Integer;
  sl, sl2: TStringList;
  index, size, count: Integer;

  procedure LoadDefaultSideImage(Side: string);
  begin
    if UpperCase(Side) = 'ARM' then
      SideImageList.AddMasked(MainForm.DefaultArmImage.Picture.Bitmap, clWhite)
    else if UpperCase(Side) = 'CORE' then
      SideImageList.AddMasked(MainForm.DefaultCoreImage.Picture.Bitmap, clWhite)
    else
      SideImageList.AddMasked(MainForm.DefaultSideImage.Picture.Bitmap, clWhite); // none specific side
  end;

begin

  SideList.Clear;
  SideImageList.Clear;

  count := GetSideCount;
  for i := 0 to count-1 do
    SideList.Add(GetSideName(i));

  sl := TStringList.Create; // list of archive files
  sl2 := TStringList.Create; // list of archive file sides

  // get a list of all side images from mod archive:
  res := InitFindVFS('SidePics\*.bmp');
  SetLength(s, 255);
  res := FindFilesVFS(res, PChar(s), 255);
  if res = 0 then
  begin
    if Debug.Enabled then MainForm.AddMainLog('No side pictures found! Skipping ...', Colors.Error);
  end
  else
  begin
    while res <> 0 do
    begin
      for i := 1 to 255 do if s[i] = #0 then
      begin
        s := Copy(s, 1, i-1);
        Break;
      end;

      if Debug.Enabled then MainForm.AddMainLog('Side image found: ' + s, Colors.Info);
      sl.Add(s);
      sl2.Add(UpperCase(Copy(ExtractFileName(s), 1, Length(ExtractFileName(s))-4)));
      SetLength(s, 255);
      res := FindFilesVFS(res, PChar(s), 255);
    end;
  end;

  // load side images:
  for i := 0 to SideList.Count-1 do
  begin
    index := sl2.IndexOf(UpperCase(SideList[i]));

    // if we don't have a suitable side image, load the default one:
    if index = -1 then
      LoadDefaultSideImage(UpperCase(SideList[i]))
    else
    begin // let's load the side image from mod's archive file:
      res := OpenFileVFS(PChar(sl[index]));
      if res = 0 then
      begin
        MainForm.AddMainLog('Error: Unable to open archive file: ' + sl[index], Colors.Error);
        LoadDefaultSideImage(UpperCase(SideList[i]));
        Continue;
      end;
      size := FileSizeVFS(res);
      if size = 0 then
      begin
        MainForm.AddMainLog('Error: Unable to open archive file: ' + sl[index], Colors.Error);
        LoadDefaultSideImage(UpperCase(SideList[i]));
        CloseFileVFS(res);
        Continue;
      end;

      SetLength(s, size);
      ReadFileVFS(res, @s[1], size);
      try
        AddBitmapToImageList(SideImageList, s[1], size);
      except
        LoadDefaultSideImage(UpperCase(SideList[i]));
     end;
    end;
  end; // for

  sl.Free;
  sl2.Free;
end;

{ ------------------------------------------------------------------------ }


end.
