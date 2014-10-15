{
  Usage: Call InitLib when program is started and DeInitLib when program gets closed. All other functions may be used only
  after library has been initialized.
}

unit Utility;

interface

uses
  Windows, Graphics, Classes, SyncObjs;

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
  TMinimapData = array[0..1024*1024-1] of Word; // raw bitmap data returned by GetMinimap function fromUnitSync.dll

function InitLib: Boolean;
function ReInitLib: Boolean;
procedure DeInitLib;

procedure GetMapList(List: TStrings);
function LoadMiniMap(MapName: string; bmp: TBitmap): Boolean;
function AcquireMapInfo(MapName: string): TMapInfo;
procedure GetModList(ModList: TStrings; ModArchiveList: TStrings);
function GetModHash(ModName: string): Integer;
procedure LoadMod(ModName: string);
procedure GetUnitList(UnitNames, UnitList: TStrings); // unit names are just that, unit list is a list of "code names" of units
procedure GetSideList(SideList: TStrings);

var
  ModList: TStrings; // names of mods
  ModArchiveList: TStrings; // names of files in which mods are

  UnitNames: TStrings;
  UnitList: TStrings;

  SideList: TStringList;

implementation

uses
  SysUtils, StrUtils, Dialogs, Forms, Misc, Unit1;


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
{since 0.63} function GetSideName(Side: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetSideName';
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

procedure GetSideList(SideList: TStrings);
var
  i: Integer;
begin
  SideList.Clear;

  for i := 0 to GetSideCount-1 do SideList.Add(GetSideName(i));
end;

{ ------------------------------------------------------------------------ }


end.
