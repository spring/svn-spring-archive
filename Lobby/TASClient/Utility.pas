{
  Usage: Call InitLib when program is started and DeInitLib when program gets closed. All other functions may be used only
  after library has been initialized.
}

unit Utility;

interface

uses
  Windows, Graphics, Classes, SyncObjs, Controls,Math,MainUnit,OpenIL,gnugettext,class_TIntegerList,
  SpTBXEditors, SpTBXControls, SpTBXItem, SpTBXTabs, JvSpin, SpTBXSkins, StdCtrls,OverbyteIcsWSocket;

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

  TMapData = PChar;

  TLuaOptionSection = class;

  TLuaOption = class
  protected
    LabelName: TSpTBXLabel;
    DescriptionButton: TSpTBXButton;
    procedure MakeDescriptionButton(AOwner: TWinControl);
    procedure OnDescriptionButtonClick(Sender: TObject);virtual;
    function GetSectionOption(luaOptionList: TList): TLuaOptionSection;

  public
    Index: integer;
    SectionIndex: integer; // this index doesn't match the TLuaOptionSection.Index, it's is just used to sort the lua options and keep the right sections order
    Value: String;
    DefaultValue: String;
    KeyPrefix: String;
    Key: String;
    Name: String;
    Description: String;
    Section: String;
    hasChanged: Boolean;
    function GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;virtual;
    procedure SetValue(v: String);virtual;
    procedure OnChange(Sender: TObject);virtual;
    procedure Enable;virtual;
    procedure Disable;virtual;
    procedure setToDefault();virtual;
    function isDefault:Boolean;virtual;
    function toString:String;virtual;
    function toSetScriptTagsString:String;virtual;
    function getDescription:string;virtual;
    destructor Destroy; override;
  end;

  TLuaOptionSection = class(TLuaOption)
  private

  protected
    Panel: TSpTBXGroupBox;
  public
    function GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
     function isDefault:Boolean;override;
    function toString:String;override;
    destructor Destroy; override;
  end;

  TLuaOptionBool = class(TLuaOption)
  private

  protected
    Panel: TSpTBXPanel;
    CheckBox: TSpTBXCheckBox;
  public
    function GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
    function isDefault:Boolean;override;
    function toString:String;override;
    destructor Destroy; override;
  end;

  TLuaOptionString = class(TLuaOption)
  private

  protected
    Panel: TSpTBXPanel;
    InputEdit: TSpTBXEdit;
  public
    MaxStringLength: Integer;
    function GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
    function isDefault:Boolean;override;
    function toString:String;override;
    destructor Destroy; override;
  end;

  TLuaOptionNumber = class(TLuaOption)
  private

  protected
    Panel: TSpTBXPanel;
    InputEdit: TSpTBXSpinEdit;
  public
    MinValue: Double;
    MaxValue: Double;
    StepValue: Double;
    function GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
    function isDefault:Boolean;override;
    procedure OnChange(Sender: TObject);override;
    function toSetScriptTagsString:String;override;
    function toString:String;override;
    destructor Destroy; override;
  end;

  TLuaOptionList = class(TLuaOption)
  private
    Panel: TSpTBXPanel;
    ComboBox: TSpTBXComboBox;

  public
    NameList: TStringList;
    KeyList: TStringList;
    DescriptionList: TStringList;
    constructor Create;
    function GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;override;
    procedure SetValue(v: String);override;
    procedure Enable;override;
    procedure Disable;override;
    procedure setToDefault();override;
    function isDefault:Boolean;override;
    function toString:String;override;
    function nameToString:String;
    function getDescription:string;override;
    destructor Destroy; override;
  end;

function InitLib: Boolean;
function ReInitLib: Boolean;
function ReInitLibWithDialog: Boolean; // uses InitWaitForm to (re)initialize library
procedure DeInitLib;
function AcquireSpringVersion: string;

procedure checkDevILErrors(functionCalled: string);
procedure ReloadMapList(UpdateSplashScreen: Boolean); // will populate MapList and MapChecksums lists. If "UpdateSplashScreen" is True, it will update splash screen text too - use it only when loading map list at the beginning of the execution when splash screen form is still active!
function LoadMiniMap(MapName: string; bmp: TBitmap): Boolean;
function AcquireMapInfo(MapName: string): TMapInfo;
procedure ReloadModList;
function GetModHash(ModName: string): Integer;
function GetModHash2(ModArchive: string): Integer;
procedure LoadMod(ModName: string);
function GetUnitBitmap(unitName: string):TBitmap;
procedure ReloadUnitList; // will populate UnitNames and UnitList lists
procedure ReloadSides; // populates SideList list and loads side images into SideImageList
procedure DisplayLuaOptions(luaOptionList: TList; tabSheet: TWinControl);
function LoadSkirmishAI(AIShortName: String):integer;
procedure LoadModOptions;
procedure LoadMapOptions(mapName: string);
procedure LoadLuaOptions(var list:TList; nb: integer; keyPrefix: String; modOptions: bool=False);
function LuaOptionCompare(Item1, Item2: Pointer): Integer;
procedure UnLoadLuaOptions(luaOptionList: TList);
function GetLuaOption(optList: TList;key: string): TLuaOption;
{function GetLuaAIList:TStrings;}
function GetModValidMapList: TStringList;
function GetMapArchive(mapName: String):String;
function GetModShortName: String;
function ReadVFSFile(fileName: string): string;
function ExtractVFSDir(Dir: string;ExtractTo: string): boolean;
function getMetalMap(mapName: string; var width: integer; var height: integer): TMapData;
function getHeightMap(mapName: string; var width: integer; var height: integer): TMapData;
procedure GetUnitSyncErrors(errorsList: TStringList);

{ I assume bools are 1 byte in size (not 4) in unitsync.dll (from MSDN: "In Visual C++ 4.2,
  the Standard C++ header files contained a typedef that equated bool with int.
  In Visual C++ 5.0 and later, bool is implemented as a built-in type with a size
  of 1 byte. That means that for Visual C++ 4.2, a call of sizeof(bool) yields 4,
  while in Visual C++ 5.0 and later, the same call yields 1.") }

function Init(isServer: Boolean; id: Integer): Integer; stdcall; external 'UnitSync.dll' name 'Init';
function InitEx(isServer: Boolean; id: Integer; enable_logging: Boolean): Integer; stdcall; external 'UnitSync.dll' name 'Init';
procedure UnInit; stdcall; external 'UnitSync.dll' name 'UnInit';
{since 0.75} function GetSpringVersion: PChar; stdcall; external 'UnitSync.dll' name 'GetSpringVersion';
{since 0.8x} function GetSpringVersionPatchset: PChar; stdcall; external 'UnitSync.dll' name 'GetSpringVersionPatchset';
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
// {removed since 0.75} function InitArchiveScanner: Integer; stdcall; external 'UnitSync.dll' name 'InitArchiveScanner';
procedure AddArchive(name: PChar); stdcall; external 'UnitSync.dll' name 'AddArchive';
procedure AddAllArchives(root: PChar); stdcall; external 'UnitSync.dll' name 'AddAllArchives';
{since 0.61}function GetArchiveChecksum(arname: PChar): LongWord; stdcall; external 'UnitSync.dll' name 'GetArchiveChecksum';
{since 0.72}function GetPrimaryModChecksum(index: Integer): LongWord; stdcall; external 'UnitSync.dll' name 'GetPrimaryModChecksum';
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
{since 0.71} function GetMapArchiveCount(mapName: PChar): Integer; stdcall; external 'UnitSync.dll' name 'GetMapArchiveCount';
{since 0.71} function GetMapArchiveName(index: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetMapArchiveName';
{since 0.76} function GetMapChecksum(index: Integer): LongWord; stdcall; external 'UnitSync.dll' name 'GetMapChecksum';
{------------------------------------------------------------------------------}
{since 0.68}function FindFilesArchive(archive, cur: Integer; nameBuf: PChar; var size: Integer): Integer; stdcall; external 'UnitSync.dll' name 'FindFilesArchive';
{since 0.68}function OpenArchive(name: PChar): Integer; stdcall; external 'UnitSync.dll' name 'OpenArchive';
{since 0.68}procedure CloseArchive(archive: Integer); stdcall; external 'UnitSync.dll' name 'CloseArchive';
{since 0.68}function OpenArchiveFile(archive: Integer; name: PChar): Integer; stdcall; external 'UnitSync.dll' name 'OpenArchiveFile';
{since 0.68}function ReadArchiveFile(archive: Integer; handle: Integer; buffer: Pointer; numBytes: Integer): Integer; stdcall; external 'UnitSync.dll' name 'ReadArchiveFile';
{since 0.68}procedure CloseArchiveFile(archive: Integer; handle: Integer); stdcall; external 'UnitSync.dll' name 'CloseArchiveFile';
{since 0.68}function SizeArchiveFile(archive: Integer; handle: Integer): Integer; stdcall; external 'UnitSync.dll' name 'SizeArchiveFile';
{------------------------------------------------------------------------------}
{since 0.68}function OpenFileVFS(const name: PChar): Integer; stdcall; external 'UnitSync.dll' name 'OpenFileVFS';
{since 0.68}procedure CloseFileVFS(handle: Integer); stdcall; external 'UnitSync.dll' name 'CloseFileVFS';
{since 0.68}procedure ReadFileVFS(handle: Integer; buf: Pointer; length: Integer); stdcall; external 'UnitSync.dll' name 'ReadFileVFS';
{since 0.68}function FileSizeVFS(handle: Integer): Integer; stdcall; external 'UnitSync.dll' name 'FileSizeVFS';
{since 0.68}function InitFindVFS(const pattern: PChar): Integer; stdcall; external 'UnitSync.dll' name 'InitFindVFS';
{since 0.77}function InitDirListVFS(const path: PChar; const pattern: PChar; const modes: PChar): Integer; stdcall; external 'UnitSync.dll' name 'InitDirListVFS';
{since 0.77}function InitSubDirsVFS(const path: PChar; const pattern: PChar; const modes: PChar): Integer; stdcall; external 'UnitSync.dll' name 'InitSubDirsVFS';
{since 0.68}function FindFilesVFS(handle: Integer; nameBuf: PChar; size: Integer): Integer; stdcall; external 'UnitSync.dll' name 'FindFilesVFS';
{------------------------------------------------------------------------------}
{since 0.76 DEPRECATED}//function GetLuaAICount: Integer; stdcall; external 'UnitSync.dll' name 'GetLuaAICount';
{since 0.76 DEPRECATED}//function GetLuaAIName(aiIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetLuaAIName';
{since 0.76 DEPRECATED}//function GetLuaAIDesc(aiIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetLuaAIDesc';
{since 0.79}function GetSkirmishAICount: Integer; stdcall; external 'UnitSync.dll' name 'GetSkirmishAICount';
{since 0.79}function GetSkirmishAIInfoCount(index:integer): Integer; stdcall; external 'UnitSync.dll' name 'GetSkirmishAIInfoCount';
{since 0.79}function GetInfoKey(index: integer): PChar; stdcall; external 'UnitSync.dll' name 'GetInfoKey';
{since 0.79}function GetInfoValue(index: integer): PChar; stdcall; external 'UnitSync.dll' name 'GetInfoValue';
{since 0.79}function GetInfoDescription(index: integer): PChar; stdcall; external 'UnitSync.dll' name 'GetInfoDescription';
{since 0.79}function GetSkirmishAIOptionCount(index: integer): Integer; stdcall; external 'UnitSync.dll' name 'GetSkirmishAIOptionCount';
{------------------------------------------------------------------------------}
{since 0.76}function GetMapOptionCount(mapName: PChar): Integer; stdcall; external 'UnitSync.dll' name 'GetMapOptionCount';
{since 0.76}function GetModOptionCount: Integer; stdcall; external 'UnitSync.dll' name 'GetModOptionCount';
{since 0.76}function GetOptionKey(optIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionKey';
{since 0.76}function GetOptionName(optIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionName';
{since 0.77}function GetOptionSection(optIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionSection';
{since 0.77}function GetOptionStyle(optIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionStyle';
{since 0.76}function GetOptionDesc(optIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionDesc';
{since 0.76}function GetOptionType(optIndex: Integer): Integer; stdcall; external 'UnitSync.dll' name 'GetOptionType';
{since 0.76}function GetOptionBoolDef(optIndex: Integer): Boolean; stdcall; external 'UnitSync.dll' name 'GetOptionBoolDef';
{since 0.76}function GetOptionNumberDef(optIndex: Integer): Float; stdcall; external 'UnitSync.dll' name 'GetOptionNumberDef';
{since 0.76}function GetOptionNumberMin(optIndex: Integer): Float; stdcall; external 'UnitSync.dll' name 'GetOptionNumberMin';
{since 0.76}function GetOptionNumberMax(optIndex: Integer): Float; stdcall; external 'UnitSync.dll' name 'GetOptionNumberMax';
{since 0.76}function GetOptionNumberStep(optIndex: Integer): Float; stdcall; external 'UnitSync.dll' name 'GetOptionNumberStep';
{since 0.76}function GetOptionStringDef(optIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionStringDef';
{since 0.76}function GetOptionStringMaxLen(optIndex: Integer): Integer; stdcall; external 'UnitSync.dll' name 'GetOptionStringMaxLen';
{since 0.76}function GetOptionListCount(optIndex: Integer): Integer; stdcall; external 'UnitSync.dll' name 'GetOptionListCount';
{since 0.76}function GetOptionListDef(optIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionListDef';
{since 0.76}function GetOptionListItemName(optIndex: Integer; itemIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionListItemName';
{since 0.76}function GetOptionListItemDesc(optIndex: Integer; itemIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionListItemDesc';
{since 0.76}function GetOptionListItemKey(optIndex: Integer; itemIndex: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetOptionListItemKey';
{since 0.76}function GetModValidMapCount: integer; stdcall; external 'UnitSync.dll' name 'GetModValidMapCount';
{since 0.76}function GetModValidMap(index: Integer): PChar; stdcall; external 'UnitSync.dll' name 'GetModValidMap';
{since 0.80}function GetMapMinHeight(const name: PChar): Float; stdcall; external 'UnitSync.dll' name 'GetMapMinHeight';
{since 0.80}function GetMapMaxHeight(const name: PChar): Float; stdcall; external 'UnitSync.dll' name 'GetMapMaxHeight';
{------------------------------------------------------------------------------}
{since 0.77}procedure lpClose; stdcall; external 'UnitSync.dll' name 'lpClose';
{since 0.77}function lpOpenFile(const filename: PChar;const fileModes: PChar;const accessModes: PChar): Integer; stdcall; external 'UnitSync.dll' name 'lpOpenFile';
{since 0.77}function lpOpenSource(const source: PChar;const accessModes: PChar): Integer; stdcall; external 'UnitSync.dll' name 'lpOpenSource';
{since 0.77}function lpExecute:Integer; stdcall; external 'UnitSync.dll' name 'lpExecute';
{since 0.77}procedure lpErrorLog; stdcall; external 'UnitSync.dll' name 'lpErrorLog';
{since 0.77}procedure lpAddTableInt(key: integer;over_ride: integer); stdcall; external 'UnitSync.dll' name 'lpAddTableInt';
{since 0.77}procedure lpAddTableStr(const key: PChar;over_ride: integer); stdcall; external 'UnitSync.dll' name 'lpAddTableStr';
{since 0.77}procedure lpEndTable; stdcall; external 'UnitSync.dll' name 'lpEndTable';

{since 0.77}procedure lpAddIntKeyIntVal(key: integer;val: integer); stdcall; external 'UnitSync.dll' name 'lpAddIntKeyIntVal';
{since 0.77}procedure lpAddStrKeyIntVal(const key: PChar;val: integer); stdcall; external 'UnitSync.dll' name 'lpAddStrKeyIntVal';

{since 0.77}procedure lpAddIntKeyBoolVal(key: integer;val: integer); stdcall; external 'UnitSync.dll' name 'lpAddIntKeyBoolVal';
{since 0.77}procedure lpAddStrKeyBoolVal(const key: PChar;val: integer); stdcall; external 'UnitSync.dll' name 'lpAddStrKeyBoolVal';

{since 0.77}procedure lpAddIntKeyFloatVal(key: integer;val: Float); stdcall; external 'UnitSync.dll' name 'lpAddIntKeyFloatVal';
{since 0.77}procedure lpAddStrKeyFloatVal(const key: PChar;val: Float); stdcall; external 'UnitSync.dll' name 'lpAddStrKeyFloatVal';

{since 0.77}procedure lpAddIntKeyStrVal(key: integer;const val: PChar); stdcall; external 'UnitSync.dll' name 'lpAddIntKeyStrVal';
{since 0.77}procedure lpAddStrKeyStrVal(const key: PChar;const val: PChar); stdcall; external 'UnitSync.dll' name 'lpAddStrKeyStrVal';

{since 0.77}function lpRootTable:Integer; stdcall; external 'UnitSync.dll' name 'lpRootTable';
{since 0.77}function lpRootTableExpr(const expr: PChar):Integer; stdcall; external 'UnitSync.dll' name 'lpRootTableExpr';
{since 0.77}function lpSubTableInt(key: Integer):Integer; stdcall; external 'UnitSync.dll' name 'lpSubTableInt';
{since 0.77}function lpSubTableStr(const key: PChar):Integer; stdcall; external 'UnitSync.dll' name 'lpSubTableStr';
{since 0.77}function lpSubTableExpr(const expr: PChar):Integer; stdcall; external 'UnitSync.dll' name 'lpSubTableExpr';
{since 0.77}procedure lpPopTable; stdcall; external 'UnitSync.dll' name 'lpPopTable';

{since 0.77}function lpGetKeyExistsInt(key: Integer):Integer; stdcall; external 'UnitSync.dll' name 'lpGetKeyExistsInt';
{since 0.77}function lpGetKeyExistsStr(const key: PChar):Integer; stdcall; external 'UnitSync.dll' name 'lpGetKeyExistsStr';

{since 0.77}function lpGetIntKeyType(key: Integer):Integer; stdcall; external 'UnitSync.dll' name 'lpGetIntKeyType';
{since 0.77}function lpGetStrKeyType(const key: PChar):Integer; stdcall; external 'UnitSync.dll' name 'lpGetStrKeyType';

{since 0.77}function lpGetIntKeyListCount:Integer; stdcall; external 'UnitSync.dll' name 'lpGetIntKeyListCount';
{since 0.77}function lpGetIntKeyListEntry(index: Integer):Integer; stdcall; external 'UnitSync.dll' name 'lpGetIntKeyListEntry';
{since 0.77}function lpGetStrKeyListCount:Integer; stdcall; external 'UnitSync.dll' name 'lpGetStrKeyListCount';
{since 0.77}function lpGetStrKeyListEntry(index: Integer):PChar; stdcall; external 'UnitSync.dll' name 'lpGetStrKeyListEntry';

{since 0.77}function lpGetIntKeyIntVal(key: Integer;defVal: Integer):Integer; stdcall; external 'UnitSync.dll' name 'lpGetIntKeyIntVal';
{since 0.77}function lpGetStrKeyIntVal(const key: PChar;defVal: Integer):Integer; stdcall; external 'UnitSync.dll' name 'lpGetStrKeyIntVal';
{since 0.77}function lpGetIntKeyBoolVal(key: Integer;defVal: Integer):Integer; stdcall; external 'UnitSync.dll' name 'lpGetIntKeyBoolVal';
{since 0.77}function lpGetStrKeyBoolVal(const key: PChar;defVal: Integer):Integer; stdcall; external 'UnitSync.dll' name 'lpGetStrKeyBoolVal';
{since 0.77}function lpGetIntKeyFloatVal(key: Integer;defVal: Float):Float; stdcall; external 'UnitSync.dll' name 'lpGetIntKeyFloatVal';
{since 0.77}function lpGetStrKeyFloatVal(const key: PChar;defVal: Float):Float; stdcall; external 'UnitSync.dll' name 'lpGetStrKeyFloatVal';
{since 0.77}function lpGetIntKeyStrVal(key: Integer;const defVal: PCHar):PChar; stdcall; external 'UnitSync.dll' name 'lpGetIntKeyStrVal';
{since 0.77}function lpGetStrKeyStrVal(const key: PChar;const defVal: PChar):PChar; stdcall; external 'UnitSync.dll' name 'lpGetStrKeyStrVal';
{------------------------------------------------------------------------------}
{since 0.77b5}function GetInfoMapSize(const filename: PChar;const name: PChar;var width: integer;var height: integer):Integer; stdcall; external 'UnitSync.dll' name 'GetInfoMapSize';
{since 0.77b5}function GetInfoMap(const filename: PChar;const name: PChar;data : PChar; typeHint: integer):Integer; stdcall; external 'UnitSync.dll' name 'GetInfoMap';
{since 0.??}function GetNextError():PChar; stdcall; external 'UnitSync.dll' name 'GetNextError';

function malloc(Size: Integer): Pointer; cdecl; external 'msvcrt.dll';
function free(m: Pointer): Pointer; cdecl; external 'msvcrt.dll';

var
  ModList: TStrings; // names of mods
  ModArchiveList: TStrings; // names of files in which mods are

  UnitNames: TStrings; // list of unit names
  UnitList: TStrings; // list of "code names" of units
  UnitBitmaps: TList; // list of TBitmap icon of units
  UnitNodes: TList; // node associated in the disable form list

  ModValidMaps: TStringList; //

  SideList: TStringList; // list of mod's sides, like "Arm", "Core", etc.
  SideImageList: TImageList; // images of sides. Also see SideList

  MapList: TStringList;
  MapChecksums: TIntegerList;
  MapMainArchive: TStringList;

  LastInitSuccess: Boolean = True; // check this var to see if last call to InitLib/ReInitLib was successful!

implementation

uses
  SysUtils, StrUtils, Dialogs, Forms, Misc, InitWaitFormUnit,
  MapListFormUnit, SplashScreenUnit, BattleFormUnit, PreferencesFormUnit,
  LobbyScriptUnit;

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
var
  springVersion: string;
  hDll: Cardinal;
  pGetSpringVersionPatchset: Pointer;
begin
  ChDir(ExtractFilePath(Application.ExeName));
  Result := True;
  springVersion := GetSpringVersion;
  hDll := LoadLibrary('unitsync.dll');
  pGetSpringVersionPatchset := GetProcAddress(hDll,'GetSpringVersionPatchset');
  FreeLibrary(hDll);
  if (springVersion = '0.82.7') and (pGetSpringVersionPatchset = nil) then
    Result := InitEx(False,0,True) = 1
  else
    Result := Init(False,0) = 1;
  LastInitSuccess := Result;
  MainForm.PrintUnitsyncErrors;
end;

function ReInitLib: Boolean;
begin
  UnInit;
  Result := InitLib;
  if not Result then Exit;
  // reload mod list:
  ReloadModList;
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
    MessageDlg(_('Error initializing unitsync!'), mtError, [mbOK], 0);
    Application.Terminate;
  end;
end;

procedure DeInitLib;
begin
  UnInit;
end;

function AcquireSpringVersion: string;
begin
  Result := GetSpringVersion+'.'+GetSpringVersionPatchset;
end;

{ ------------------------------------------------------------------------ }

// note: checksums are stored as hexadecimal numbers in text form
procedure ReloadMapList(UpdateSplashScreen: Boolean); // will populate MapList and MapChecksums lists
var
  i, j, c: Integer;
  MapCount: Integer;
  CheckSum : Integer;
  MapName: string;
  tmp: string;
  time: Cardinal;
  archiveHwd: Integer;
  fileHwd: Integer;
  boxes: string;
  size: integer;
begin
  if UpdateSplashScreen and (SplashScreenForm = nil) then UpdateSplashScreen := False; // just in case if caller forgot to set it to false

  MapList.Clear;
  MapCheckSums.Clear;
  MapMainArchive.Clear;
  MapListForm.ClearMapList;

  time := GetTickCount;
  MapCount := GetMapCount;

  {*if MapCount = 0 then
  begin
    MessageDlg('No maps found!', mtError, [mbOK], 0);
    Application.Terminate;
    Exit;
  end;*}

  for i := 0 to MapCount-1 do
  begin
     Forms.Application.ProcessMessages;
     
     MapName := GetMapName(i);

     // filter out maps with duplicate names:
     if MapList.IndexOf(MapName) <> -1 then Continue;

     // calculate checksum:
     CheckSum := GetMapChecksum(i);
     c := GetMapArchiveCount(PChar(MapName));

     // check if map is "valid":
     if CheckSum = 0 then
     begin
       MainForm.AddMainLog(Format(_('Skipping map file: %s (bad checksum)'),[MapName]), Colors.Error);
       Continue;
     end;
     if MapCheckSums.IndexOf(CheckSum) <> -1 then
     begin
       MainForm.AddMainLog(Format(_('Skipping map file: "%s", duplicate checksum of file "%s"'),[MapName, ExtractFileName(MapMainArchive[MapCheckSums.IndexOf(CheckSum)])]), Colors.Error);
       Continue;
     end;

     // add map to the map list:
     if UpdateSplashScreen then SplashScreenForm.UpdateText(_('loading map (') + MapName + ')');
     MapList.Add(MapName);
     MapCheckSums.Add(CheckSum);
     MapMainArchive.Add(GetMapArchiveName(0));
     MapListForm.AddMap;

     if not Preferences.DisableMapDetailsLoading then
     begin
      TMapItem(MapListForm.Maps[MapListForm.Maps.Count-1]).LoadMapInfo;
      TMapItem(MapListForm.Maps[MapListForm.Maps.Count-1]).LoadMinimap(True);
      //TMapItem(MapListForm.Maps[MapListForm.Maps.Count-1]).Boxes := TScript.Create(boxes);
     end;

//*** debug     MainForm.AddMainLog(MapName + ' ... ' + IntToStr(c) + ':' + MapCheckSums[MapCheckSums.Count-1], Colors.Info);
  end;
  MapListForm.SortedMaps.Assign(MapListForm.Maps);
  MapListForm.SortMapList(Preferences.MapSortStyle);
  BattleForm.ChangeMapToNoMap(''); // we have to set CurrentMapIndex to -1 or else ChangeMap method may not change map later on if old map index collides with new one!
  BattleForm.PopulatePopupMenuMapList;

  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onMapsReloaded(); except end;
  ReleaseMainThread;
//***  showmessage('time taken: ' + inttostr(gettickcount - time) + ' ms');
end;

{ ------------------------------------------------------------------------ }

procedure checkDevILErrors(functionCalled: string);
var
  ilErrMsg: Cardinal;
begin
  ilErrMsg := ilGetError();
  while ilErrMsg <> IL_NO_ERROR do
  begin
    if Debug.Enabled then
    begin
      raise Exception.Create('DevIL Error ('+functionCalled+') : '+IntToStr(ilErrMsg));
    end;
    ilErrMsg := ilGetError();
  end;
end;

{ ------------------------------------------------------------------------ }

function LoadMiniMap(MapName: string; bmp: TBitmap): Boolean;
var
  mipsize: Integer;
  minimap: PMinimapData;
  minimapRGB: PChar;
  x, y: Integer;
  P: PByteArray;
  color: Word;
  mapCheckSum: integer;
  tmp: TBitmap;
  filePath: string;
begin
  Result := False;

  mipsize := 1024;
  try
    mapCheckSum := MapChecksums.Items[MapList.IndexOf(MapName)];
  except
    MessageDlg(Format(_('Map "%s" not in the list !'),[MapName]),mtError,[mbOk],0);
  end;

  filePath :=  ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER+'\'+IntToStr(mapCheckSum)+'.png';

  if FileExists(filePath) then
  begin
    if ilLoadImage(PChar( filePath )) = IL_TRUE then
    begin
      checkDevILErrors('ilLoadImage');

      bmp.Width := ilGetInteger(IL_IMAGE_WIDTH);
      bmp.Height := ilGetInteger(IL_IMAGE_HEIGHT);

      bmp.PixelFormat := pf24bit;

      ilCopyPixels(0,0,0,bmp.Width,bmp.Height,1,IL_BGR,IL_UNSIGNED_BYTE,bmp.ScanLine[bmp.Height-1]);
      checkDevILErrors('ilCopyPixels');
    end
    else
      checkDevILErrors('ilLoadImage');
  end
  else
  begin
    minimap := GetMinimap(PChar(MapName), 0);
    if minimap = nil then
    begin
      MessageDlg(Format(_('Loading "%s" minimap failed !'),[MapName]),mtError,[mbOk],0);
      Exit;
    end;

    bmp.PixelFormat := pf16bit;
    bmp.Width := 1024;
    bmp.Height := 1024;
    minimapRGB := malloc(bmp.Width*bmp.Height*3);

    for y := 0 to bmp.Height -1 do
    begin
      P := bmp.ScanLine[y];

      for x := 0 to bmp.Width -1 do
      begin
        P[x*2+0] := Lo(minimap[y * mipsize + x]);
        P[x*2+1] := Hi(minimap[y * mipsize + x]);

        minimapRGB[(bmp.Height-y)*bmp.Height*3+x*3+0] := Char(Color16BitsToR(minimap[y * mipsize + x]));
        minimapRGB[(bmp.Height-y)*bmp.Height*3+x*3+1] := Char(Color16BitsToG(minimap[y * mipsize + x]));
        minimapRGB[(bmp.Height-y)*bmp.Height*3+x*3+2] := Char(Color16BitsToB(minimap[y * mipsize + x]));
      end;
    end;

    if ilLoadDataL(PChar(minimapRGB),bmp.Width*bmp.Height*3,bmp.Width,bmp.Height,1,3) = IL_TRUE then
    begin
      ilSaveImage(PChar(filePath));
    end;

    free(minimapRGB);
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

procedure ReloadModList; // will populate ModList and ModArchiveList lists
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

  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers.onModsReloaded(); except end;
  ReleaseMainThread;
end;

{ ------------------------------------------------------------------------ }

{ this is a fast routine, should be done in less than 1 ms (as far as I've tested it) }
function GetModHash(ModName: string): Integer;
var
  index: Integer;
begin
  Result := 0;
  index := ModList.IndexOf(ModName);
  if index = -1 then Exit;
  if Debug.Enabled then MainForm.AddMainLog(_('Hashing file: ') + ModList[index], Colors.MinorInfo);
  Result := GetPrimaryModChecksum(index)
end;

function GetModHash2(ModArchive: string): Integer;
var
  index: Integer;
begin
  Result := 0;
  index := ModArchiveList.IndexOf(ModArchive);
  if index = -1 then Exit;
  if Debug.Enabled then MainForm.AddMainLog(_('Hashing file: ') + ModList[index], Colors.MinorInfo);
  Result := GetPrimaryModChecksum(index);
end;

{ ------------------------------------------------------------------------ }

{ don't forget to reinit unitsync.dll each time you change mod (except for the first time)! }
procedure LoadMod(ModName: string);
begin
  AddAllArchives(PChar(ModName));
  ModValidMaps.Free;
  ModValidMaps := GetModValidMapList;
end;

{ ------------------------------------------------------------------------ }

function GetUnitBitmap(unitName: string):TBitmap;
var
  s,picture: string;
  size: integer;
  res: Integer;
  imgWidth,imgHeight: integer;
  imgType: Cardinal;
begin
  Result := TBitmap.Create;
  res := InitFindVFS(PChar('unitpics\'+unitName+'.*'));
  SetLength(s, 255);
  res := FindFilesVFS(res, PChar(s), 255);
  if res <> 0 then
  begin
    Delete(s,Pos(#0,s),5000);
    while res <> 0 do
    begin
      if RightStr(LowerCase(Trim(s)),4) = '.pcx' then // pcx are only used in the old otacontent so if a more recent file is available it will be png or something else
      begin
        res := FindFilesVFS(res, PChar(s), 255);
        Delete(s,Pos(#0,s),5000);
      end
      else
        break;
    end;


    res := OpenFileVFS(PChar(s));
    size := FileSizeVFS(res);
    SetLength(picture, size);
    ReadFileVFS(res, PChar(picture), size);
    CloseFileVFS(res);

    Delete(s,Pos(#0,s),5000);

    if RightStr(LowerCase(Trim(s)),4) = '.dds' then
      imgType := IL_DDS
    else if RightStr(LowerCase(Trim(s)),4) = '.png' then
      imgType := IL_PNG
    else if RightStr(LowerCase(Trim(s)),4) = '.pcx' then
      imgType := IL_PCX
    else if RightStr(LowerCase(Trim(s)),4) = '.jpg' then
      imgType := IL_JPG
    else if RightStr(LowerCase(Trim(s)),4) = '.tga' then
      imgType := IL_TGA
    else
      imgType := IL_TYPE_UNKNOWN;

    ilEnable(IL_ORIGIN_SET);
    checkDevILErrors('ilEnable');
    ilOriginFunc(IL_ORIGIN_LOWER_LEFT);
    checkDevILErrors('ilOriginFunc');
    if ilLoadL(imgType,Pointer(picture),size) = IL_TRUE then
    begin
      checkDevILErrors('ilLoadL');
      imgWidth := ilGetInteger(IL_IMAGE_WIDTH);
      checkDevILErrors('ilGetInteger');
      imgHeight := ilGetInteger(IL_IMAGE_HEIGHT);
      checkDevILErrors('ilGetInteger');

      Result.Width := imgWidth;
      Result.Height := imgHeight;

      Result.PixelFormat := pf24bit;

      ilCopyPixels(0,0,0,imgWidth,imgHeight,1,IL_BGR,IL_UNSIGNED_BYTE,Result.ScanLine[imgHeight-1]);
      checkDevILErrors('ilCopyPixels');
    end
    else
      checkDevILErrors('ilLoadL');
    ilDisable(IL_ORIGIN_SET);
    checkDevILErrors('ilDisable');
  end;
end;

procedure ReloadUnitList; // will populate UnitNames and UnitList lists
var
  i: Integer;
begin
  UnitNames.Clear;
  UnitList.Clear;

  for i:=0 to UnitBitmaps.Count-1 do
  begin
    TBitmap(UnitBitmaps[i]).FreeImage;
    TBitmap(UnitBitmaps[i]).Free;
  end;
  UnitBitmaps.Clear;

  // first process all units (this may take some time):
  while ProcessUnits > 0 do;

  // check unitsync errors
  MainForm.PrintUnitsyncErrors;

  for i := 0 to GetUnitCount-1 do
  begin
    UnitNames.Add(GetFullUnitName(i));
    UnitList.Add(GetUnitName(i));
    if Preferences.DisplayUnitsIconsAndNames then
      UnitBitmaps.Add(GetUnitBitmap(GetUnitName(i)));
  end;
end;

{ ------------------------------------------------------------------------ }

procedure ReloadSides; // populates SideList list and loads side images into SideImageList image list
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

  if count = 0 then // this should not happen - mod author forgot to define sides! 
  begin
    MessageDlg(_('This mod doesn''t have any sides defined. Using default sides (Arm/Core) ...'), mtWarning, [mbOK], 0);
    SideList.Add('Arm');
    SideList.Add('Core');
  end;

  sl := TStringList.Create; // list of archive files
  sl2 := TStringList.Create; // list of archive file sides

  // get a list of all side images from mod archive:
  res := InitFindVFS('SidePics\*.bmp');
  SetLength(s, 255);
  res := FindFilesVFS(res, PChar(s), 255);
  if res = 0 then
  begin
    if Debug.Enabled then MainForm.AddMainLog(_('No side pictures found! Skipping ...'), Colors.Error);
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

      //if Debug.Enabled then MainForm.AddMainLog('Side image found: ' + s, Colors.Info);
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

      CloseFileVFS(res);
    end;
  end; // for

  sl.Free;
  sl2.Free;
end;

procedure DisplayLuaOptions(luaOptionList: TList; tabSheet: TWinControl);
var
  i: Integer;
  c: TWinControl;
begin
  tabSheet.Visible := False;
  for i:=0 to luaOptionList.Count -1 do
  begin
    c := TLuaOption(luaOptionList[i]).GetComponent(tabSheet,luaOptionList);
    c.Align := alBottom;
    c.Align := alTop;
    if (BattleState.Status = Joined) then
      TLuaOption(luaOptionList[i]).Disable
    else
      TLuaOption(luaOptionList[i]).Enable;
  end;
  // hide empty sections
  for i:=0 to luaOptionList.Count-1 do
  begin
    if TLuaOption(luaOptionList[i]).ClassType = TLuaOptionSection then
      TLuaOptionSection(luaOptionList[i]).Panel.Visible := TLuaOptionSection(luaOptionList[i]).Panel.ControlCount > 0;
  end;
  tabSheet.Visible := True;
end;

function LoadSkirmishAI(AIShortName: String):integer;
var
  i,j: integer;
begin
  Result := -1;
  for i:=0 to GetSkirmishAICount-1 do
    for j:=0 to GetSkirmishAIInfoCount(i)-1 do
      if (LowerCase(GetInfoKey(j)) = 'shortname') and (LowerCase(GetInfoValue(j)) = LowerCase(AIShortName)) then
      begin
        Result := Utility.GetSkirmishAIOptionCount(i);
        Exit;
      end;
end;

procedure LoadLuaOptions(var list:TList; nb: integer; keyPrefix: String; modOptions: bool=False);
var
  i,j:integer;
  o: ^TLuaOption;
  addDefaultSection: Boolean;
  defaultSection: ^TLuaOption;
  sections: TStringList;
  lKey: string;
  tmp: string;
begin
  sections := TStringList.Create;
  sections.add(LowerCase('__defaultSection__'));

  New(defaultSection);
  defaultSection^ := TLuaOptionSection.Create;
  defaultSection^.Key := '__defaultSection__';
  defaultSection^.Name := _('Other Options');
  defaultSection^.Description := '';
  defaultSection^.Section := '';
  defaultSection^.hasChanged := False;
  defaultSection^.Index := -1;
  addDefaultSection := false;

  for i:=0 to nb-1 do
  begin
    if modOptions then
    begin
      lKey := LowerCase(GetOptionKey(i));
      if lKey = 'startmetal' then
      begin
        if GetOptionType(i) = 3 then
          with BattleForm do
          begin
            lblMetal.Visible := True;
            lblMetalValue.Visible := True;
            MetalTracker.Visible := True;
            ResourcesGroupBox.Visible := True;

            lblMetal.Caption := GetOptionName(i);
            lblMetal.Hint := GetOptionDesc(i);
            MetalTracker.Hint := GetOptionDesc(i);
            MetalTracker.Min := Round(GetOptionNumberMin(i));
            MetalTracker.Max := Round(GetOptionNumberMax(i));
            MetalTracker.Position := Round(GetOptionNumberDef(i));
            Continue;
          end;
      end
      else if lKey = 'startenergy' then
      begin
        if GetOptionType(i) = 3 then
          with BattleForm do
          begin
            lblEnergy.Visible := True;
            lblEnergyValue.Visible := True;
            EnergyTracker.Visible := True;
            ResourcesGroupBox.Visible := True;

            lblEnergy.Caption := GetOptionName(i);
            lblEnergy.Hint := GetOptionDesc(i);
            EnergyTracker.Hint := GetOptionDesc(i);
            EnergyTracker.Min := Round(GetOptionNumberMin(i));
            EnergyTracker.Max := Round(GetOptionNumberMax(i));
            EnergyTracker.Position := Round(GetOptionNumberDef(i));
            Continue;
          end;
      end
      else if lKey = 'maxunits' then
      begin
        if GetOptionType(i) = 3 then
          with BattleForm do
          begin
            lblUnits.Visible := True;
            lblUnitsValue.Visible := True;
            UnitsTracker.Visible := True;
            ResourcesGroupBox.Visible := True;

            lblUnits.Caption := GetOptionName(i);
            lblUnits.Hint := GetOptionDesc(i);
            UnitsTracker.Hint := GetOptionDesc(i);
            UnitsTracker.Min := Round(GetOptionNumberMin(i));
            UnitsTracker.Max := Round(GetOptionNumberMax(i));
            UnitsTracker.Position := Round(GetOptionNumberDef(i));
            Continue;
          end;
      end
      else if lKey = 'gamemode' then
      begin
        if GetOptionType(i) = 2 then
          with BattleForm do
          begin
            GameEndRadioGroup.Visible := True;
            GameEndRadioGroup.Height := 17;
            GameEndRadioGroup.Hint := '';
            GameEndRadioGroup.Items.Clear;

            tmp := GetOptionListDef(i);

            for j:= 0 to GetOptionListCount(i)-1 do
            begin
              GameEndRadioGroup.Items.Add(GetOptionListItemName(i,j));
              GameEndRadioGroup.Height := GameEndRadioGroup.Height + 17;
              GameEndRadioGroup.Hint := GameEndRadioGroup.Hint + GetOptionListItemName(i,j) + ' = ' + GetOptionListItemDesc(i,j) + EOL;
              if tmp = GetOptionListItemKey(i,j) then GameEndRadioGroup.ItemIndex := j;
            end;

            Continue;
          end;
      end;
    end;
    Case GetOptionType(i) of
      1: // bool
      begin
        New(o);
        o^ := TLuaOptionBool.Create;
        TLuaOptionBool(o^).DefaultValue := BoolToStr(GetOptionBoolDef(i));
      end;
      2: // list
      begin
        New(o);
        o^ := TLuaOptionList.Create;
        with TLuaOptionList(o^) do
        begin
          DefaultValue := GetOptionListDef(i);
          for j:= 0 to GetOptionListCount(i)-1 do
          begin
            NameList.Add(GetOptionListItemName(i,j));
            DescriptionList.Add(GetOptionListItemDesc(i,j));
            KeyList.Add(GetOptionListItemKey(i,j))
          end;
        end;
      end;
      3: // number
      begin
        New(o);
        o^ := TLuaOptionNumber.Create;
        with TLuaOptionNumber(o^) do
        begin
          DefaultValue := FloatToStr(GetOptionNumberDef(i));
          MinValue := GetOptionNumberMin(i);
          MaxValue := GetOptionNumberMax(i);
          StepValue := RoundTo(GetOptionNumberStep(i),-4);
        end;
      end;
      4: // string
      begin
        New(o);
        o^ := TLuaOptionString.Create;
        with TLuaOptionString(o^) do
        begin
          DefaultValue := GetOptionStringDef(i);
          MaxStringLength := GetOptionStringMaxLen(i);
        end;
      end;
      5: // section
      begin
        New(o);
        o^ := TLuaOptionSection.Create;
        sections.Add(LowerCase(GetOptionKey(i)));
      end;
    else
    begin
        New(o);
        o^ := TLuaOption.Create;
    end
    end;
    o^.Key := StrNew(GetOptionKey(i));
    o^.Name := StrNew(GetOptionName(i));
    o^.Description := StrNew(GetOptionDesc(i));
    o^.Section := StrNew(GetOptionSection(i));
    if (o^.Section = '') and not(o^ is TLuaOptionSection) then
    begin
      o^.Section := '__defaultSection__';
      addDefaultSection := true;
    end;
    o^.hasChanged := False;
    o^.KeyPrefix := keyPrefix;
    o^.Index := i;
    o^.SectionIndex := -2;
    list.Add(o^);
  end;

  for i:=0 to list.Count-1 do
  begin
    if not (TLuaOption(list[i]) is TLuaOptionSection) then
    begin
      if (sections.IndexOf(LowerCase(TLuaOption(list[i]).Section)) = -1) then
      begin
        TLuaOption(list[i]).Section := '__defaultSection__';
        addDefaultSection := true;
      end;
      TLuaOption(list[i]).SectionIndex := sections.IndexOf(LowerCase(TLuaOption(list[i]).Section));
    end
    else
      TLuaOption(list[i]).SectionIndex := sections.IndexOf(LowerCase(TLuaOption(list[i]).Key));
  end;

  if addDefaultSection then
    list.Add(defaultSection^);

  // sort by section
  list.Sort(LuaOptionCompare);
end;

function LuaOptionCompare(Item1, Item2: Pointer): Integer;
var
  isSection1,isSection2: Boolean;
begin
  isSection1 := TLuaOption(Item1) is TLuaOptionSection;
  isSection2 := TLuaOption(Item2) is TLuaOptionSection;

  Result := CompareValue(TLuaOption(Item1).SectionIndex,TLuaOption(Item2).SectionIndex);

  if Result = 0 then
  begin
    if isSection1 <> isSection2 then
    begin
      if isSection1 then
      begin
        Result := -1;
      end
      else if isSection2 then
      begin
        Result := 1;
      end;
    end
    else
    begin
      Result := CompareValue(TLuaOption(Item1).Index,TLuaOption(Item2).Index);
    end;
  end;
end;

procedure LoadModOptions;
var
  o: ^TLuaOption;
  nb: integer;
begin
  // first we hide the engine options
  with BattleForm do
  begin
    lblMetal.Visible := False;
    lblEnergy.Visible := False;
    lblUnits.Visible := False;
    MetalTracker.Visible := False;
    EnergyTracker.Visible := False;
    UnitsTracker.Visible := False;
    ResourcesGroupBox.Visible := False;
    GameEndRadioGroup.Visible := False;
    lblMetalValue.Visible := False;
    lblEnergyValue.Visible := False;
    lblUnitsValue.Visible := False;
  end;

  UnLoadLuaOptions(BattleForm.ModOptionsList);

  LoadLuaOptions(BattleForm.ModOptionsList,GetModOptionCount,'GAME/MODOPTIONS/',True);
end;

procedure LoadMapOptions(mapName: string);
var
  o: ^TLuaOption;
begin
  UnLoadLuaOptions(BattleForm.MapOptionsList);

  LoadLuaOptions(BattleForm.MapOptionsList,GetMapOptionCount(PChar(mapName)),'GAME/MAPOPTIONS/',False);
end;

procedure UnLoadLuaOptions(luaOptionList: TList);
var
  i: Integer;
begin
  for i:=0 to luaOptionList.Count-1 do
    if TLuaOption(luaOptionList[i]).ClassType <> TLuaOptionSection then
      TLuaOption(luaOptionList[i]).Destroy;
  for i:=0 to luaOptionList.Count-1 do
    if TLuaOption(luaOptionList[i]).ClassType = TLuaOptionSection then
      TLuaOption(luaOptionList[i]).Destroy;
  luaOptionList.Clear;
end;
{function GetLuaAIList:TStrings;
var
  i:integer;
begin
  Result := TStringList.Create;
  for i:=0 to GetLuaAICount-1 do
    Result.Add('LuaAI:'+GetLuaAIName(i));
end;}
function GetModValidMapList: TStringList;
var
  i:integer;
  return: TStringList;
begin
  return := TStringList.Create;
  for i:=0 to GetModValidMapCount-1 do
    return.Add(GetModValidMap(i));

  Result := return;
end;
function GetMapArchive(mapName: String):String;
var
  i: integer;
begin
  i := GetMapArchiveCount(PChar(MapName));
  Result := GetMapArchiveName(0);
end;

function GetModShortName: String;
var
  fileHwd,size: integer;
  fileContent: string;
  s: TTDFParser;
begin
  Result := '';
  fileHwd := OpenFileVFS('modinfo.tdf');
  if fileHwd <> 0 then
  begin
    size := FileSizeVFS(fileHwd);
    SetLength(fileContent,size);
    ReadFileVFS(fileHwd,PChar(fileContent),size);
    CloseFileVFS(fileHwd);
    s := TTDFParser.Create(fileContent);
    Result := s.ReadKeyValue('mod/shortname');
    if Result = '' then
    begin
      Result := s.ReadKeyValue('mod/Game');
      if Result = '' then
        raise Exception.Create('mod/shortname not found in the modinfo.tdf file : '+EOL+fileContent);
    end;
    s.Destroy;
  end
  else
  begin
    fileHwd := OpenFileVFS('modinfo.lua');
    if fileHwd <> 0 then
    begin
      size := FileSizeVFS(fileHwd);
      SetLength(fileContent,size);
      ReadFileVFS(fileHwd,PChar(fileContent),size);
      CloseFileVFS(fileHwd);

      lpOpenSource(PChar(fileContent),'r');

      if (Utility.lpExecute = 0) then
        Raise Exception.Create(_('Invalid modinfo.lua file.'));

      if lpGetKeyExistsStr('shortname') <> 0 then
        Result := lpGetStrKeyStrVal('shortname','')
      else
        if lpGetKeyExistsStr('game') <> 0 then
          Result := lpGetStrKeyStrVal('game','')
        else
          Raise Exception.Create(_('Invalid modinfo.lua file.'));
    end
    else
      raise Exception.Create('modinfo.tdf/lua not found.');
  end;
end;

function ReadVFSFile(fileName: string): string;
var
  fileHwd,size: integer;
  fileContent: string;
begin
  Result := '';
  fileHwd := OpenFileVFS(PChar(fileName));
  if fileHwd <> 0 then
  begin
    size := FileSizeVFS(fileHwd);
    SetLength(fileContent,size);
    ReadFileVFS(fileHwd,PChar(fileContent),size);
    CloseFileVFS(fileHwd);
    Result := fileContent;
  end;
end;

function ExtractVFSDir(Dir: string;ExtractTo: string): boolean;
var
  archiveHwd,fileHwd,size: integer;
  fileContent: string;
  res: integer;
  s: string;
  subDirs: TStringList;
  i: integer;
  fs: TFileStream;
  outputFileName : string;
  vfsFileName: string;
begin
  // make the subdirs list
  subDirs := TStringList.Create;
  res := InitSubDirsVFS(PChar(Dir),'*',nil);
  SetLength(s, 255);
  res := FindFilesVFS(res, PChar(s), 255);
  while res <> 0 do
  begin
    Delete(s,Pos(#0,s),255);
    subDirs.Add(s);
    SetLength(s, 255);
    res := FindFilesVFS(res, PChar(s), 255);
  end;

  res := InitDirListVFS(PChar(Dir),'*',nil);
  SetLength(s, 255);
  res := FindFilesVFS(res, PChar(s), 255);

  if (res = 0) and (subDirs.Count = 0) then
  begin
    Result := false;
  end
  else
  begin
    Result := True;
    if not DirectoryExists(ExtractTo) then
      MkDir(ExtractTo);

    // copy the files
    while res <> 0 do
    begin
      // copy one file
      fileHwd := OpenFileVFS(PChar(s));
      if fileHwd <> 0 then
      begin
        size := FileSizeVFS(fileHwd);
        SetLength(fileContent,size);
        ReadFileVFS(fileHwd,PChar(fileContent),size);
        Delete(s,Pos(#0,s),255);
        vfsFileName := ExtractFileName(StringReplace(s,'/','\',[rfReplaceAll]));
        if vfsFileName <> '' then
        begin
          outputFileName := ExtractTo+'\'+vfsFileName;
          if FileExists(outputFileName) then
            DeleteFile(outputFileName);
          fs := TFileStream.Create(outputFileName,fmOpenWrite or fmCreate );
          fs.WriteBuffer(fileContent[1],size);
          fs.Free;
          CloseFileVFS(fileHwd);
        end
        else
          MainForm.AddMainLog('Error: Empty VFS file name : '+s,Colors.Error);
      end;
      // get next filename
      SetLength(s, 255);
      res := FindFilesVFS(res, PChar(s), 255);
    end;

    for i:=0 to subDirs.Count-1 do
      ExtractVFSDir(subDirs[i],ExtractTo+'\'+ExtractAfterLastSlash(LeftStr(subDirs[i],Length(subDirs[i])-1)));
  end;
end;
function getMetalMap(mapName: string; var width: integer; var height: integer): TMapData;
var
  mapCheckSum: integer;
  filePath: string;
begin
  Result := nil;

  try
    mapCheckSum := MapChecksums.Items[MapList.IndexOf(mapName)];
  except
    MessageDlg(Format(_('Map "%s" not in the list !'),[mapName]),mtError,[mbOk],0);
    Exit;
  end;

  filePath := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER+'\'+IntToStr(mapCheckSum)+'.metal.png';

  if FileExists(filePath) and (ilLoadImage(PChar(filePath)) = IL_TRUE) then
  begin
    width := ilGetInteger(IL_IMAGE_WIDTH);
    height := ilGetInteger(IL_IMAGE_HEIGHT);

    Result := malloc(width*height);

    ilCopyPixels(0,0,0,width,height,1,IL_LUMINANCE,IL_UNSIGNED_BYTE,Result);
    checkDevILErrors('ilCopyPixels');
  end
  else
  begin
    checkDevILErrors('ilLoadImage');
    
    width := 0;
    height := 0;
    if GetInfoMapSize(PChar(mapName),'metal',width,height) >= 0 then
    begin
      Result := malloc(width*height);
      GetInfoMap(PChar(mapName),'metal',Result,1);

      if ilLoadDataL(Result,width*height,width,height,1,1) = IL_TRUE then
      begin
        ilSaveImage(PChar(filePath));
        checkDevILErrors('ilSaveImage');
      end
      else
        checkDevILErrors('ilLoadDataL');
    end;
  end;
end;
function getHeightMap(mapName: string; var width: integer; var height: integer): TMapData;
var
  mapCheckSum: integer;
  filePath: string;
begin
  Result := nil;

  try
    mapCheckSum := MapChecksums.Items[MapList.IndexOf(mapName)];
  except
    MessageDlg(Format(_('Map "%s" not in the list !'),[mapName]),mtError,[mbOk],0);
  end;

  filePath := ExtractFilePath(Application.ExeName) + MAPS_CACHE_FOLDER+'\'+IntToStr(mapCheckSum)+'.height.png';

  if FileExists(filePath) and (ilLoadImage(PChar(filePath)) = IL_TRUE) then
  begin
    width := ilGetInteger(IL_IMAGE_WIDTH);
    height := ilGetInteger(IL_IMAGE_HEIGHT);

    Result := malloc(width*height);

    ilCopyPixels(0,0,0,width,height,1,IL_LUMINANCE,IL_UNSIGNED_BYTE,Result);
    checkDevILErrors('ilCopyPixels');
  end
  else
  begin
    width := 0;
    height := 0;
    if GetInfoMapSize(PChar(mapName),'height',width,height) >= 0 then
    begin
      Result := malloc(width*height);
      GetInfoMap(PChar(mapName),'height',Result,1);

      if ilLoadDataL(Result,width*height,width,height,1,1) = IL_TRUE then
      begin
        ilSaveImage(PChar(filePath));
        checkDevILErrors('ilSaveImage');
      end
      else
        checkDevILErrors('ilLoadDataL');
    end;
  end;
end;

constructor TLuaOptionList.Create;
begin
    NameList := TStringList.Create;
    DescriptionList := TStringList.Create;
    KeyList := TStringList.Create;
end;

procedure TLuaOption.MakeDescriptionButton(AOwner: TWinControl);
begin
  if DescriptionButton = nil then
  begin
    DescriptionButton := TSpTBXButton.Create(AOwner);
    DescriptionButton.Parent := AOwner;
    DescriptionButton.Caption := '?';
    DescriptionButton.Width := 17;
    DescriptionButton.Height := 20;
    DescriptionButton.Left := 365;
    DescriptionButton.ParentColor := false;
    DescriptionButton.Anchors := [akRight,akTop];
    DescriptionButton.OnClick := OnDescriptionButtonClick;
  end;
end;
function TLuaOption.GetSectionOption(luaOptionList: TList): TLuaOptionSection;
var
  i : integer;
begin
  Result := nil;

  for i:=0 to luaOptionList.Count-1 do
  begin
    if TLuaOption(luaOptionList[i]).ClassType = TLuaOptionSection then
      if LowerCase(TLuaOptionSection(luaOptionList[i]).Key) = LowerCase(Section) then
      begin
        Result := TLuaOptionSection(luaOptionList[i]);
        Exit;
      end;
  end;

  raise Exception.Create('Unknown section');
end;
procedure TLuaOption.OnDescriptionButtonClick(Sender: TObject);
begin
  MessageDlg(Self.Name + ' : ' + Self.getDescription,mtInformation,[mbOk],0);
end;
function TLuaOption.getDescription:string;
begin
  result := Self.Description;
end;

function TLuaOptionList.getDescription:string;
var
  msg: String;
  i: integer;
begin
  for i:=0 to DescriptionList.Count-1 do
    msg := msg + EOL + '     ' + NameList[i] + ' = ' + DescriptionList[i];
  Result := Self.Description+EOL+msg;
end;

function TLuaOption.GetComponent(AOwner: TWinControl;luaOptionList: TList): TWinControl;
var
  sec: TLuaOptionSection;
begin
  if LabelName = nil then
  begin
    sec := GetSectionOption(luaOptionList);

    if sec <> nil then
    begin
      AOwner := sec.GetComponent(AOwner,luaOptionList);
    end;

    AOwner.Height := AOwner.Height + 18;

    LabelName := TSpTBXLabel.Create(AOwner);
    LabelName.Parent := AOwner;
    LabelName.Caption := Name + ' : Unknown option type';
    LabelName.Font.Color := Colors.Error;
    LabelName.AutoSize := True;
    LabelName.Font.Style := [];
  end;
  Result := LabelName;
end;

function TLuaOptionString.GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;
var
  sec: TLuaOptionSection;
begin
  if Panel = nil then
  begin
    sec := GetSectionOption(luaOptionList);

    if sec <> nil then
    begin
      AOwner := sec.GetComponent(AOwner,luaOptionList);
    end;

    AOwner.Height := AOwner.Height + 23;

    Panel := TSpTBXPanel.Create(AOwner);
    Panel.Parent := AOwner;
    Panel.Borders := False;
    //Panel.AutoSize := True;
    Panel.Height := 23;
    Panel.Width := 386;

    LabelName := TSpTBXLabel.Create(Panel);
    LabelName.Parent := Panel;
    LabelName.Caption := Name + ' :';
    LabelName.AutoSize := True;
    LabelName.Left := 8;
    LabelName.Top := 3;
    LabelName.Width := 180;
    LabelName.Hint := Description;
    LabelName.ShowHint := True;
    LabelName.ParentFont := False;
    LabelName.Font.Style := [];

    InputEdit := TSpTBXEdit.Create(Panel);
    InputEdit.Parent := Panel;
    InputEdit.Left := 188;
    InputEdit.Top := 0;
    InputEdit.MaxLength := MaxStringLength;
    InputEdit.Hint := Description;
    InputEdit.ShowHint := True;
    InputEdit.Width := 170;
    InputEdit.Text := DefaultValue;
    InputEdit.OnExit := self.OnChange;
    InputEdit.Anchors := [akLeft,akTop,akRight];
    InputEdit.SkinType := sknSkin;
    SendMessage(InputEdit.Handle,WM_SPSKINCHANGE,0,0);
    

    MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOptionNumber.GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;
var
  sec: TLuaOptionSection;
begin
  if Panel = nil then
  begin
    sec := GetSectionOption(luaOptionList);

    if sec <> nil then
    begin
      AOwner := sec.GetComponent(AOwner,luaOptionList);
    end;

    AOwner.Height := AOwner.Height + 23;

    Panel := TSpTBXPanel.Create(AOwner);
    Panel.Parent := AOwner;
    Panel.Borders := False;
    //Panel.AutoSize := True;
    Panel.Height := 23;
    Panel.Width := 386;

    LabelName := TSpTBXLabel.Create(Panel);
    LabelName.Parent := Panel;
    LabelName.Caption := Name + ' :';
    LabelName.AutoSize := True;
    LabelName.Left := 8;
    LabelName.Top := 3;
    LabelName.Width := 180;
    LabelName.Hint := Description;
    LabelName.ShowHint := True;
    LabelName.ParentFont := False;
    LabelName.Font.Style := [];

    InputEdit := TSpTBXSpinEdit.Create(Panel);
    InputEdit.Parent := Panel;
    InputEdit.SpinOptions.ValueType := spnFloat;
    InputEdit.SpinOptions.MaxValue := MaxValue;
    InputEdit.SpinOptions.MinValue := MinValue;
    if StepValue <= 0 then
    begin
      InputEdit.SpinButton.Visible := False;
      InputEdit.SpinOptions.Increment := 0.0000000001;
      InputEdit.SpinOptions.Decimal := 10;
    end
    else
    begin
      InputEdit.SpinOptions.Increment := StepValue;
      InputEdit.SpinOptions.Decimal := GetFloatDecimals(StepValue);
    end;
    InputEdit.SpinOptions.Value := StrToFloat(DefaultValue);
    InputEdit.Hint := Description;
    InputEdit.ShowHint := True;
    InputEdit.Width := 170;
    InputEdit.OnExit := self.OnChange;
    InputEdit.Left := 188;
    InputEdit.Top := 0;
    InputEdit.SkinType := sknSkin;
    InputEdit.ParentCtl3D := False;
    InputEdit.Ctl3D := True;
    InputEdit.Anchors := [akLeft,akTop,akRight];
    SendMessage(InputEdit.Handle,WM_SPSKINCHANGE,0,0);

    MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOptionBool.GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;
var
  sec: TLuaOptionSection;
begin
  if Panel = nil then
  begin
    sec := GetSectionOption(luaOptionList);

    if sec <> nil then
    begin
      AOwner := sec.GetComponent(AOwner,luaOptionList);
    end;

    AOwner.Height := AOwner.Height + 23;

    Panel := TSpTBXPanel.Create(AOwner);
    Panel.Parent := AOwner;
    Panel.Borders := False;
    //Panel.AutoSize := True;
    Panel.Height := 23;
    Panel.Width := 386;

    LabelName := TSpTBXLabel.Create(Panel);
    LabelName.Parent := Panel;
    LabelName.Caption := Name + ' :';
    LabelName.Left := 8;
    LabelName.Top := 3;
    LabelName.Width := 180;
    LabelName.Hint := Description;
    LabelName.ShowHint := True;
    LabelName.ParentFont := False;
    LabelName.Font.Style := [];
  
    CheckBox := TSpTBXCheckBox.Create(Panel);
    CheckBox.Parent := Panel;
    CheckBox.Left := 188;
    CheckBox.Top := 3;
    CheckBox.AutoSize := False;
    CheckBox.Caption := '';
    CheckBox.Height := 15;
    CheckBox.Hint := Description;
    CheckBox.ShowHint := True;
    CheckBox.Checked := StrToBool(DefaultValue);
    CheckBox.OnClick := self.OnChange;

    MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOptionSection.GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;
begin
  if Panel = nil then
  begin
    Panel := TSpTBXGroupBox.Create(AOwner);
    Panel.Name := 'test'+IntToStr(RandomRange(0,50000));
    Panel.Parent := AOwner;
    Panel.Height := 20;
    Panel.Caption := Name;
    Panel.ShowHint := True;
    Panel.Hint := Description;
    Panel.Font.Style := [fsBold];
    Panel.TBXStyleBackground := True;
    Panel.Visible := True;
    //MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOptionList.GetComponent(AOwner: TWinControl;luaOptionList: TList):TWinControl;
var
  i: integer;
  sec: TLuaOptionSection;
begin
  if Panel = nil then
  begin
    sec := GetSectionOption(luaOptionList);

    if sec <> nil then
    begin
      AOwner := sec.GetComponent(AOwner,luaOptionList);
    end;

    AOwner.Height := AOwner.Height + 23;

    Panel := TSpTBXPanel.Create(AOwner);
    Panel.Parent := AOwner;
    Panel.Borders := False;
    Panel.SkinType := sknSkin;
    //Panel.AutoSize := True;
    Panel.Height := 23;
    Panel.Width := 386;

    LabelName := TSpTBXLabel.Create(Panel);
    LabelName.Parent := Panel;
    LabelName.Caption := Name + ' :';
    LabelName.Align := alNone;
    LabelName.AutoSize := True;
    LabelName.Left := 8;
    LabelName.Top := 3;
    LabelName.Width := 180;
    LabelName.Hint := Description;
    LabelName.ShowHint := True;
    LabelName.ParentFont := False;
    LabelName.Font.Style := [];

    ComboBox := TSpTBXComboBox.Create(Panel);
    ComboBox.Parent := Panel;
    ComboBox.Style := csDropDownList;
    ComboBox.Top := 0;
    ComboBox.Width := 170;
    ComboBox.Height := 21;
    ComboBox.Items.Assign(NameList);
    ComboBox.ItemIndex := Max(0,KeyList.IndexOf(DefaultValue));
    ComboBox.Left := 188;
    ComboBox.Hint := Description;
    ComboBox.ShowHint := True;
    ComboBox.OnChange := self.OnChange;
    ComboBox.Anchors := [akLeft,akTop,akRight];
    SendMessage(ComboBox.Handle,WM_SPSKINCHANGE,0,0);

    MakeDescriptionButton(Panel);
  end;
  Result := Panel;
end;

function TLuaOption.toString:String;
begin
  Result := Value;
end;

function TLuaOptionNumber.toString:String;
begin
  Result := InputEdit.Text;
end;

function TLuaOptionString.toString:String;
begin
  Result := InputEdit.Text;
end;

function TLuaOptionList.toString:String;
begin
  Result := KeyList[ComboBox.ItemIndex];
end;
function TLuaOptionList.nameToString:String;
begin
  Result := NameList[ComboBox.ItemIndex];
end;

function TLuaOptionBool.toString:String;
begin
  Result := IntToStr(BoolToInt(CheckBox.Checked));
end;

function TLuaOptionSection.toString:String;
begin
  Result := '';
end;

procedure TLuaOption.OnChange(Sender: TObject);
begin
  if (BattleState.Status = Hosting) and AllowBattleDetailsUpdate then
  begin
    MainForm.TryToSendCommand('SETSCRIPTTAGS', KeyPrefix+Key+'='+Self.toString);
  end;
  Value := Self.toString;
end;

function TLuaOption.toSetScriptTagsString:String;
begin
  Result := KeyPrefix+Key+'='+Self.toString;
end;

procedure TLuaOptionNumber.OnChange(Sender: TObject);
begin
  inherited OnChange(Sender)
end;

function TLuaOptionNumber.toSetScriptTagsString:String;
begin
  if StepValue <= 0 then
  begin
    inherited toSetScriptTagsString;
  end
  else
  begin
    InputEdit.Text := FloatToStr(Round(StrToFloat(InputEdit.Text) / StepValue)*StepValue);
    Result := inherited toSetScriptTagsString;
  end;
end;

procedure TLuaOption.SetValue(v: String);
begin
  hasChanged := hasChanged or (Value <> v);
  Value := v;
  //if hasChanged then
  //  BattleForm.RefreshQuickLookText;
end;

procedure TLuaOption.setToDefault;
begin
  hasChanged := hasChanged or (Value <> DefaultValue);
  Value := DefaultValue;
  if hasChanged then
    BattleForm.RefreshQuickLookText;
end;

function TLuaOption.isDefault:Boolean;
begin
  Result := DefaultValue = Value;
end;

procedure TLuaOptionString.SetValue(v: String);
begin
  inherited;
  InputEdit.Text := v;
end;

procedure TLuaOptionString.setToDefault;
begin
  inherited;
  InputEdit.Text := DefaultValue;
end;

function TLuaOptionString.isDefault:Boolean;
begin
  Result := InputEdit.Text = DefaultValue;
end;

procedure TLuaOptionList.SetValue(v: String);
begin
  inherited;
  ComboBox.ItemIndex := Max(0,KeyList.IndexOf(v));
end;

procedure TLuaOptionList.setToDefault;
begin
  inherited;
  ComboBox.ItemIndex := Max(0,KeyList.IndexOf(DefaultValue));
end;

function TLuaOptionList.isDefault:Boolean;
begin
  Result := Max(0,KeyList.IndexOf(DefaultValue)) = ComboBox.ItemIndex;
end;

procedure TLuaOptionBool.SetValue(v: String);
begin
  inherited;
  CheckBox.Checked := StrToBool(v);
end;

procedure TLuaOptionSection.setToDefault;
begin
end;

function TLuaOptionSection.isDefault:Boolean;
begin
  Result := True;
end;

procedure TLuaOptionSection.SetValue(v: String);
begin
end;

procedure TLuaOptionBool.setToDefault;
begin
  inherited;
  CheckBox.Checked := StrToBool(DefaultValue);
end;

function TLuaOptionBool.isDefault:Boolean;
begin
  Result := StrToBool(DefaultValue) = CheckBox.Checked;
end;


procedure TLuaOptionNumber.SetValue(v: String);
begin
  inherited;
  InputEdit.Text := v;
end;

procedure TLuaOptionNumber.setToDefault;
begin
  inherited;
  InputEdit.Value := StrToFloat(DefaultValue);
end;

function TLuaOptionNumber.isDefault:Boolean;
begin
  Result := RoundTo(InputEdit.Value,-5) = RoundTo(StrToFloat(DefaultValue),-5);
end;

procedure TLuaOption.Enable;
begin
  // nothing
end;
procedure TLuaOption.Disable;
begin
  // nothing
end;

procedure TLuaOptionString.Enable;
begin
  LabelName.Enabled := True;
  InputEdit.Enabled := True;
end;
procedure TLuaOptionString.Disable;
begin
  LabelName.Enabled := False;
  InputEdit.Enabled := False;
end;

procedure TLuaOptionList.Enable;
begin
  LabelName.Enabled := True;
  ComboBox.Enabled := True;
end;
procedure TLuaOptionList.Disable;
begin
  LabelName.Enabled := False;
  ComboBox.Enabled := False;
end;

procedure TLuaOptionBool.Enable;
begin
  LabelName.Enabled := True;
  CheckBox.Enabled := True;
end;
procedure TLuaOptionBool.Disable;
begin
  LabelName.Enabled := False;
  CheckBox.Enabled := False;
end;

procedure TLuaOptionSection.Enable;
begin
  //Panel.Enabled := True;
end;
procedure TLuaOptionSection.Disable;
begin
  //Panel.Enabled := False;
end;

procedure TLuaOptionNumber.Enable;
begin
  LabelName.Enabled := True;
  InputEdit.Enabled := True;
end;
procedure TLuaOptionNumber.Disable;
begin
  LabelName.Enabled := False;
  InputEdit.Enabled := False;
end;

destructor TLuaOption.Destroy;
begin
  inherited Destroy;
end;

destructor TLuaOptionList.Destroy;
begin
  NameList.Free;
  DescriptionList.Free;
  inherited Destroy;
  Panel.Destroy;
end;

destructor TLuaOptionString.Destroy;
begin
  inherited Destroy;
  Panel.Destroy;
end;

destructor TLuaOptionNumber.Destroy;
begin
  inherited Destroy;
  Panel.Destroy;
end;

destructor TLuaOptionBool.Destroy;
begin
  inherited Destroy;
  Panel.Destroy;
end;

destructor TLuaOptionSection.Destroy;
begin
  inherited Destroy;
  Panel.Destroy;
end;

function GetLuaOption(optList: TList;key: string): TLuaOption;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to optList.Count-1 do
  begin
    if LowerCase(TLuaOption(optList[i]).Key) = LowerCase(key) then
    begin
      Result := TLuaOption(optList[i]);
      Exit;
    end;
  end;
end;

procedure GetUnitSyncErrors(errorsList: TStringList);
var
  errMsg: PChar;
  errMsgStr: string;
begin
  errorsList.Clear;
  errMsg := GetNextError;
  while errMsg <> nil do
  begin
    errMsgStr := errMsg;
    errorsList.Add(errMsgStr);
    errMsg := GetNextError;
  end;
end;

initialization
  // side lists and unit lists gets loaded when needed and not in OnFormCreate
  // event (this information is accurate for 0.23 successor version at least)

  ModList := TStringList.Create;
  ModArchiveList := TStringList.Create;
  UnitList := TStringList.Create;
  UnitNames := TStringList.Create;
  UnitBitmaps := TList.Create;
  UnitNodes := TList.Create;
  SideList := TStringList.Create; // we will load side list when needed
  SideList.CaseSensitive := False;
  SideImageList := TImageList.CreateSize(16, 16);
  MapList := TStringList.Create;
  MapChecksums := TIntegerList.Create;
  MapMainArchive := TStringList.Create;

finalization

  if Assigned(ModList) then ModList.Free;
  if Assigned(ModArchiveList) then ModArchiveList.Free;
  if Assigned(UnitList) then UnitList.Free;
  if Assigned(UnitNames) then UnitNames.Free;
  if Assigned(SideList) then SideList.Free;
  if Assigned(SideImageList) then SideImageList.Free;
  if Assigned(MapList) then MapList.Free;
  if Assigned(MapChecksums) then MapChecksums.Free;

end.
