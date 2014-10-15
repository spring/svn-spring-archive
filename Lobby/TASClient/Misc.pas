{
  http://www.delphizine.com/newsletterarticle/2003/04/di200304rs_l/di200304rs_l.asp
  (this is why we need EnableControlAndChildren and DisableControlAndChildren)

}
{$DEFINE DONTUSETTL2}

unit Misc; // Miscellaneous

interface

uses
  SpTBXTabs,SpTBXItem,JvSpin,Dialogs, Classes, ComCtrls, Windows, Graphics, MMSystem,
  Controls, Registry, SysUtils,RichEdit2, ExRichEdit, OverbyteIcsWSocket, Winsock, Mapi ,
  ESBDates, GpTimeZone, JvColorCombo, Forms,StdCtrls,OverbyteIcsHttpProt,TntComCtrls,
  JclUnicode,TntSysUtils,PreferencesFormUnit,Variants,typinfo, OpenIL, DockPanel,
  IdHashMessageDigest, idHash, shlobj;

type
  TColorData = Array[0..128000] Of TRGBTriple;
  pColorData = ^TColorData;

  TVerticalAlign=(alVTop,alVCenter,alVBottom);
  THorizontalAlign=(alHLeft,alHCenter,alHRight);
  TJustify=(JustLeft,JustCenter,JustRight);

  PMethodParam = ^TMethodParam;
  TMethodParam = record
    Flags: TParamFlags;
    ParamName: PShortString;
    TypeName: PShortString;
  end;
  TMethodParamList = array of TMethodParam;
  PMethodSignature = ^TMethodSignature;
  TMethodSignature = record
    MethodKind: TMethodKind;
    ParamCount: Byte;
    ParamList: TMethodParamList;
    ResultType: PShortString;
  end;

  TGetInternetIpThread = class(TThread)
  private
    procedure Refresh;
    procedure OnTerminateProcedure(Sender : TObject);

  protected
    procedure Execute; override;

  public
    constructor Create(Suspended : Boolean);
  end;


procedure ParseDelimited(const sl : TStrings; const value : string; const delimiter : string;const delimiter2: string) ;overload;
procedure ParseDelimited(const sl : TWideStrings; const value : string; const delimiter : WideString;const delimiter2: WideString) ;overload;
function JoinStringList(sl : TStrings;delimiter: String;startIndex: integer = 0):String;
function ShellExecuteAndWait(FileName: string; Params: string): Boolean;
function MakeSentence(sl: TStringList; StartIndex: Integer): string;
function MakeSentenceWS(sl: TWideStringList; StartIndex: Integer): WideString;
function CreateStrings(Length: Integer): string; // a helper function used to create a string filled with #13's
function StringToHex(s: string): string;
function HexToString(s: string): string;
function SaveStringToFile(FileName: string; s: string): Boolean;
function BoolToInt(b: Boolean): Integer;
function IntToBool(i: Integer): Boolean;
function HexToInt(HexStr: String): Integer;
procedure CheckLastLineForSpecialUrlsProtocol(RichEdit: TExRichEdit; protocol: string;LastLineStartPos:integer);
procedure CheckLastLineForSpecialUrlsProtocols(RichEdit: TExRichEdit;LastLineStartPos:integer);
procedure AddTextToRichEdit(RichEdit: TExRichEdit; Text: WideString; TextColor: TColor; Scroll: Boolean; ChatTextPos: Integer; EOLBefore: boolean = False);
procedure PlayResSound(RESName: string);
procedure EnableControlAndChildren(Control: TWinControl); // enable group of controls
procedure DisableControlAndChildren(Control: TWinControl); // disable group of controls
function HashFile(FileName: string): Integer; // creates signed 32-bit hash code
function VersionStringToFloat(Version: string): Single;
function GetFileSize(FileName: string): Integer;
function ReadFile2(FileName: string): string;
function ReadLastLogFileLines(FileStream: TFileStream; nbLines : integer ): String;
procedure SaveFile(FileName: string;content: string);
function VerifyName(Name: string): Boolean;
function GetRegistryData(RootKey: HKEY; Key, Value: string): Variant;
procedure SetRegistryData(RootKey: HKEY; Key, Value: string; RegDataType: TRegDataType; Data: Variant);
procedure RemoveRegistryData(RootKey: HKEY; Key, Value: string);
procedure RemoveRegistryKey(RootKey: HKEY; Key: string);
function FormatFileSize(Size: Integer): string;
function FormatFileSize2(SizeInBytes: Integer): string;
// will replace the %s by the corresponding size and all %u by the unit
function FormatFileSize3(const sizes: array of const;formatStr: string): string;
function GenerateUniqueID: Integer;
function GetCPUSpeed: Integer;
procedure NormalizeRect(var Rect: TRect);
procedure LimitRect(var Rect: TRect; LimitRect: TRect);
procedure LimitRect2(var Rect: TRect; LimitRect: TRect);
function PointInRect(Rect: TRect; Point: TPoint): Boolean;
procedure FixURL(var URL: string);
function CreateMapListFromHtml(const HtmlText: TStringList): TStringList;
procedure RevertList(List: TList);
procedure AddBitmapToImageList(il: TImageList; FileName: string); overload;
procedure AddBitmapToImageList(il: TImageList; const buf; len: Integer); overload;
procedure SendUDPStr(Address: string; DestinationPort: Integer; var SourcePort: Integer; Text: string);
procedure SendUDPStrEx(Address: string; DestinationPort: Integer; var SourcePort: Integer; TTL: Integer; Text: string);
function GetMD5Hash(s: string): string; // returns hash in base 64 format
function GetFileMD5Hash(const fileName : string) : string;
function GetLocalIP: string;
function UTCTimeToLocalTime(utctime: TDateTime): TDateTime;
function MapColorNameToIndex(ColorName: string; ColorComboBox: TJvColorComboBox): Integer;
function EnumerateSpaces(Count: Integer): string;
function PackRGB(R: Byte; G: Byte; B: Byte): Integer; overload; // packs R, G, B to $00BBGGRR format (standard TColor format)
function PackRGB(R: Extended; G: Extended; B: Extended): Integer; overload; // packs R, G, B to $00BBGGRR format (standard TColor format). R, G and B must be in interval [0..1]
function ColorToR(Color: Integer): Byte; // Color is in $00BBGGRR format
function ColorToG(Color: Integer): Byte; // Color is in $00BBGGRR format
function ColorToB(Color: Integer): Byte; // Color is in $00BBGGRR format
function ColorToStandardRGB(Color: Integer): Integer;
function ColorToStandardRGBHex(Color: Integer): string;
function StandardRGBToColor(Color: Integer): Integer;
function ColorToScriptString(ColorC: TColor): string;
function Color16BitsToR(Color: Word): Byte;
function Color16BitsToG(Color: Word): Byte;
function Color16BitsToB(Color: Word): Byte;
function RGB16BitsToColor(R,G,B : Byte): Word;
function GetColorIndex(ColorArray: array of TColor; Color: TColor): Integer; // returns -1 if Color is not found in ColorArray
procedure CenterForm(AForm: TForm);
procedure CenterFormOverAnotherForm(AForm: TForm; BaseForm: TForm);
procedure ActivateOrDeactivateAllTBXTitleBars(Activate: Boolean);
function DetectWine: Boolean;
procedure CaptureProgramOutput(DosApp: string; Output: TStrings);
function GetSpringVersionFromEXE: string; // obsolete since 0.75
function GetLobbyUserID: Integer;
procedure GenerateAndSaveLobbyUserID;
procedure OpenURLInDefaultBrowser(URL: string);
function ColorDistance(e1:integer;e2:integer):integer;
function ColorDistance2(e1:integer;e2:integer):integer;
procedure RGBToLab(r:byte;g:byte;b1:byte;var l:integer;var a:integer;var b2:integer);
function Contains(const str: string; const strL : TStringList): Boolean;
function HSL(H: integer;S: byte;L: byte):Integer;
procedure HslToRgb(H: integer;S: byte;L: byte;var R: byte;var G: byte;var B: byte);
procedure RgbToHsl(R,G,B: byte;var H: integer;var S: byte;var L: byte);
function InputQueryInteger(const ACaption, APrompt: WideString; var Val: Integer;
  Min: Integer = Low(Integer); Max: Integer = High(Integer);
  Increment: Integer = 1): Boolean;
function InputBoxInteger(const ACaption, APrompt: WideString; ADefault: Integer;
  Min: Integer = Low(Integer); Max: Integer = High(Integer);
  Increment: Integer = 1): Integer;
function IsWindowsVista: Boolean;
function IsWindowsXP: Boolean;
function InputColor(title: String; defaultColor: TColor):TColor;
procedure FixFormSizeConstraints(form: TForm);
procedure DrawMultilineText(AString: string;
                       ACanvas:TCanvas;ARect: TRect;
                       HorizontalAlign:THorizontalAlign;
                       VerticalAlign:TVerticalAlign;
                       TextJustification:TJustify;
                       WordWrap:boolean);
Function TextSize2(Text: string; AWidth: integer; Font: TFont = nil): TPoint;
function VariantToString(AVar: OleVariant): string;
function GetLongPathNameA(lpFileName:LPCTSTR;lpBuffer:LPTSTR;nBufferLength:DWORD): integer;stdcall; external 'Kernel32.dll';
function GetLongPathName(FileName: string): string;
function DeleteFilesRegExp(DirName: string; regularExpression: string): LongInt;
Function DelTree(DirName : string): LongInt;
Function CopyTree(DirFrom : string; DirTo : string): LongInt;
Function MoveTree(DirFrom : string; DirTo : string): LongInt;
Function BitmapFlip(Const Vertical : Boolean;Const Horizontal : Boolean;var BitmapIn : TBitmap;out BitmapOut : TBitmap): Boolean;
function ExtractAfterLastSlash(path: string): string;
function ExtractBeforeLastSlash(path: string): string;
function GetLobbyRevision: integer;
procedure MakePath(Path: string);
function URLDecode(const S: string): string;
function URLEncode(const S: string; const InQueryString: Boolean): string;
procedure SetProperty(Obj:TObject; propName: string; value: Variant);
function GetPerpertyInfo(Obj:TObject; propName: string): PPropInfo;
procedure GetProperties(Obj:TObject; nameList : TStrings; valueList : TList; typeList: TStringList);
procedure GetEnumPropertyList(Obj:TObject; name : string; enumList : TStringList);
function StringNChar(c: char; n: integer): string;
procedure ShowAndSetFocus(c: TWinControl; forceShow: boolean = False);
function PackedShortString(Value: PShortstring;var NextField{: Pointer}): PShortString; overload;
function PackedShortString(var NextField{: Pointer}): PShortString; overload;
function GetMethodSignature(Event: PPropInfo): TMethodSignature;
function crypt_xor(chaine:string;key:string):string;
function decrypt_xor(chaine:string;key:string):string;
procedure TryToAddLog(f: TFileStream; Line: string);
function OpenLog(FileName: string): TFileStream;
function CallFunction(p: TMethod;  paramList: TList): Integer;
function getLanguageNameIgnoreCase(langcode:string):string;
function GetWinVersion: string;
function GetControlForm(control : TWinControl): TCustomForm;
function LoadPictureWithDevIL(fileName: string; pict: TPicture): boolean;overload;
function LoadPictureWithDevIL(fileName: string; bmp: TBitmap): boolean;overload;
function SendMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
function CompareBoolean(b1: Boolean;b2: Boolean): Integer;
function CompareArgs(const Args1: array of const; const Args2: array of const; idx: integer=0): Integer;
function ComplementaryTextColor(c: TColor):TColor;
function GetMyDocuments: string;
function SwapEndian(Value: Cardinal): Cardinal; register; overload;
function SwapEndian(Value: integer): integer; register; overload;
function SwapEndian(Value: smallint): smallint; register; overload;
function SwapEndian(Value : int64) : int64 ; register; overload;
function GetFloatDecimals(value : Extended): Integer;
procedure RemoveEmptyStrings(var sl: TStringList); overload;
procedure RemoveEmptyStrings(var sl: TWideStringList); overload;
function CompareSpringVersion(version1: string; version2: string): integer;

implementation

uses
  ShellAPI, Math, RichEdit, Messages, MainUnit, StringParser,gnugettext,
  StrUtils, uMd5, SZCodeBaseX, HighlightingUnit, DSiWin32, ColorPicker,RegExpr,
  Utility;

const
  Hex: array[0..15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
  BUFFER_LENGTH = 1024;

{ --------------------------------------------------------------------------- }
procedure ParseDelimited(const sl : TWideStrings; const value : string; const delimiter : WideString;const delimiter2: WideString) ;
  var
   dx : integer;
   ns : WideString;
   txt : WideString;
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
function ShellExecuteAndWait(FileName: string; Params: string): Boolean;
var
  exInfo: TShellExecuteInfo;
  Ph: DWORD;
begin
  Result := False;

  FillChar(exInfo, SizeOf(exInfo), 0);
  with exInfo do
  begin
    cbSize := SizeOf(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
//    Wnd := GetActiveWindow();
//    ExInfo.lpVerb := 'open';
    lpFile := PChar(AnsiString(FileName));
    lpParameters := PChar(AnsiString(Params));
    lpDirectory := PChar(ExtractFilePath(AnsiString(FileName)));
    nShow := SW_SHOWNORMAL;
  end;

  if ShellExecuteEx(@exInfo) then Ph := exInfo.HProcess else Exit;

  WaitForSingleObject(ExInfo.hProcess, Infinite);
  CloseHandle(Ph);

  Result := True;
end;

{ --------------------------------------------------------------------------- }

// puts together strings from sl, starting at sl[startIndex]
function MakeSentence(sl: TStringList; StartIndex: Integer): string;
begin
  Result := '';
  if StartIndex > sl.Count-1 then Exit;

  Result := sl[StartIndex];
  Inc(StartIndex);
  while StartIndex <= sl.Count-1 do
  begin
    Result := Result + ' ' + sl[StartIndex];
    Inc(StartIndex);
  end;
end;

function MakeSentenceWS(sl: TWideStringList; StartIndex: Integer): WideString;
begin
  Result := '';
  if StartIndex > sl.Count-1 then Exit;

  Result := sl[StartIndex];
  Inc(StartIndex);
  while StartIndex <= sl.Count-1 do
  begin
    Result := Result + ' ' + sl[StartIndex];
    Inc(StartIndex);
  end;
end;

{ --------------------------------------------------------------------------- }

function CreateStrings(Length: Integer): string;
begin
  Result := '';

  if Length = 0 then Exit;

  SetLength(Result, Length);
  FillChar(Result[1], Length, #13);
end;

{ --------------------------------------------------------------------------- }

function StringToHex(s: string): string;
var
  i: Integer;
begin
  SetLength(Result, Length(s) * 2);
  for i := 1 to Length(s) do
  begin
    Result[i*2-1] := Hex[Byte(s[i]) shr 4];
    Result[i*2] := Hex[Byte(s[i]) and $0F];
  end;
end;

{ --------------------------------------------------------------------------- }

function HexToString(s: string): string;
var
  i: Integer;

begin
  if Length(s) mod 2 <> 0 then Exit;

  SetLength(Result, Length(s) div 2);
  for i := 1 to Length(Result) do
  begin

    if s[i*2-1] in ['0'..'9'] then Result[i] := Chr(Ord(s[i*2-1]) - Ord('0'))
    else if s[i*2-1] in ['A'..'F'] then Result[i] := Chr(Ord(s[i*2-1]) - Ord('A') + 10)
    else Exit; // error!

    Result[i] := Chr(Ord(Result[i]) shl 4);

    if s[i*2] in ['0'..'9'] then Result[i] := Chr(Ord(Result[i]) + Ord(s[i*2]) - Ord('0'))
    else if s[i*2] in ['A'..'F'] then Result[i] := Chr(Ord(Result[i]) + Ord(s[i*2]) - Ord('A') + 10)
    else Exit; // error!

  end;
end;

{ --------------------------------------------------------------------------- }

function SaveStringToFile(FileName: string; s: string): Boolean;
var
  f: TFileStream;
begin
  Result := False;

  f := nil;
  try
    f := TFileStream.Create(FileName, fmCreate);
    f.Write(s[1], Length(s));
    f.Free;
  except
    try
      if f <> nil then f.Free;
    except
    end;
    Exit;
  end;

  Result := True;
end;

{ --------------------------------------------------------------------------- }

function BoolToInt(b: Boolean): Integer;
begin
  if b then Result := 1 else Result := 0;
end;

{ --------------------------------------------------------------------------- }

function IntToBool(i: Integer): Boolean;
begin
  Result := i <> 0;
end;

{ --------------------------------------------------------------------------- }

function HexToInt(HexStr: String): Integer;
begin
  result := StrToInt('$' + HexStr);
end;

{ --------------------------------------------------------------------------- }
procedure CheckLastLineForSpecialUrlsProtocol(RichEdit: TExRichEdit; protocol: string;LastLineStartPos:integer);
var
  lastLine: WideString;
  curPos: integer;
  endPos: integer;
  SelStart, SelLength: Integer;
begin
  SelStart := RichEdit.SelStart;
  SelLength := RichEdit.SelLength;

  RichEdit.SelStart := LastLineStartPos;
  RichEdit.SelLength := RichEdit.GetTextLen-LastLineStartPos;
  lastLine := LowerCase(RichEdit.WideSelText);

  curPos := PosEx(' '+protocol+'://',lastLine);
  if curPos = 0 then
    if LeftStr(lastLine,Length(protocol)+3) = protocol+'://' then
      curPos := 1;
  while curPos > 0 do
  begin
    endPos := PosEx(' ',lastLine,curPos);
    if endPos = 0 then
      endPos := Length(lastLine)+1;

    RichEdit.SelStart := lastLineStartPos+curPos-1;
    RichEdit.SelLength := endPos-curPos;
    RichEdit.SelAttributes.IsURL := True;

    curPos := PosEx(protocol+'://',lastLine,endPos);
  end;
  
  RichEdit.SelStart := SelStart;
  RichEdit.SelLength := SelLength;
end;
procedure CheckLastLineForSpecialUrlsProtocols(RichEdit: TExRichEdit;LastLineStartPos:integer);
var
  i:integer;
begin
  for i:=0 to Length(SpecialUrlProtocols)-1 do
    CheckLastLineForSpecialUrlsProtocol(RichEdit,SpecialUrlProtocols[i],LastLineStartPos);
end;

{
  If Scroll=False, it will not scroll rich edit to the new line added.

  ChatTextPos is a position in the line where chat text begins. We need this when we are searching for keywords to highlight
  and we (for example) don't want to highlight nicknames in "<xyz>" part of the line, but only after that part (keywords will
  get highlighted only in chat part of the text, not the header). If you don't specify ChatTextPos parameter, it is assumed
  that the entire line is the chat text.
}
procedure AddTextToRichEdit(RichEdit: TExRichEdit; Text: WideString; TextColor: TColor; Scroll: Boolean; ChatTextPos: Integer; EOLBefore: boolean = False);
var
  SelStart, SelLength: Integer;
  p: TPoint;
  pMax: TPoint;
  mask : Word;
  newLineStartPos: integer;
begin
  // stop redrawing
  SendMessage(RichEdit.Handle, WM_SETREDRAW, 0, 0);

  Text := Tnt_WideStringReplace(Text,#$0B,' ',[rfReplaceAll]);
  RichEdit.URLColor := clBlack;

  // save the scroll pos
  SelStart := RichEdit.SelStart;
  SelLength := RichEdit.SelLength;
  SendMessage(RichEdit.Handle, WM_USER + 221 {EM_GETSCROLLPOS},  0, LPARAM(@p));

  try
    if Preferences.LimitChatLogs and (RichEdit.Lines.Count >= Preferences.ChatLogsLimit+20) then
    begin
       RichEdit.SelStart  := 0;
       RichEdit.SelLength := RichEdit.Perform(EM_LINEINDEX, 20, 0);
       RichEdit.SelText   := '';
    end;

    RichEdit.SelLength := 0;
    RichEdit.SelStart := RichEdit.GetTextLen;

    // get the scroll max
    SendMessage(RichEdit.Handle, WM_USER + 221 {EM_GETSCROLLPOS},  0, LPARAM(@pMax));

    RichEdit.SelAttributes.Style := [];
    RichEdit.SelAttributes.Color := TextColor;

    newLineStartPos := RichEdit.GetTextLen-1;
    
    //if RichEdit.SelStart = 0 then // to avoid the first empty line
    //  RichEdit.WideSelText := Text
    //else
    if EOLBefore then
      if RichEdit.GetTextLen = 0 then
        RichEdit.WideSelText := Text
      else
        RichEdit.WideSelText :=  EOL+Text
    else
      RichEdit.WideSelText :=  Text+EOL;

    // this will automatically highlight any keywords and pop-up notification windows (if set so):
    HighlightingForm.CheckLastLineForHighlights(RichEdit, ChatTextPos,newLineStartPos);
    CheckLastLineForSpecialUrlsProtocols(RichEdit,newLineStartPos);

    {mask := SendMessage(RichEdit.Handle, EM_GETEVENTMASK, 0, 0);
    SendMessage(RichEdit.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
    SendMessage(RichEdit.Handle, EM_AUTOURLDETECT, Integer(False), 0);
    SendMessage(RichEdit.Handle, EM_AUTOURLDETECT, Integer(True), 0);}

    RichEdit.SelStart := SelStart;
    RichEdit.SelLength := SelLength;

    if not Scroll or (p.Y < Max(0,pMax.Y-20)) then
      SendMessage(RichEdit.Handle, WM_USER + 222 {EM_SETSCROLLPOS}, 0, LPARAM(@p))
    else
    begin
      RichEdit.ScrollToBottom;
      RichEdit.ScrollToBottom;
    end;
  except
  end;
  // redraw
  SendMessage(RichEdit.Handle, WM_SETREDRAW, 1, 0);
  RichEdit.Invalidate;
end;

{ --------------------------------------------------------------------------- }

procedure PlayResSound(RESName: string);
var
  hFind, hRes: THandle;
  Song: PChar;
begin
  hFind := FindResource(HInstance, PChar(RESName), 'WAVE');
  if hFind = 0 then Exit;
  hRes := LoadResource(HInstance, hFind);
  if hRes <> 0 then
  begin
    Song := LockResource(hRes);
    if Assigned(Song) then
      SndPlaySound(Song, snd_ASync or snd_Memory);
    UnlockResource(hRes);
  end;
  FreeResource(hFind);
end;

{ --------------------------------------------------------------------------- }

procedure EnableControlAndChildren(Control: TWinControl);
var
  i: Integer;
begin
  Control.Enabled := True;
  for i := 0 to Control.ControlCount-1 do
    Control.Controls[i].Enabled := True;
end;

{ --------------------------------------------------------------------------- }

procedure DisableControlAndChildren(Control: TWinControl);
var
  i: Integer;
begin
  Control.Enabled := False;
  for i := 0 to Control.ControlCount-1 do
    Control.Controls[i].Enabled := False;
end;

{ --------------------------------------------------------------------------- }

{ I use simple Fletcher's checksum }
function HashFile(FileName: string): Integer; // creates 32-bit hash code
var
  i: Integer;
  f: file of Byte;
  Buffer: array[0..BUFFER_LENGTH-1] of Byte;
  BytesRead: Integer;
  A, B: Word;
begin
  Result := 0;

  {$I-}
  AssignFile(f, FileName);
  FileMode := 0;  { Set file access to read only }
  Reset(f);
  {$I+}

  if not ((IOResult = 0) and (FileName <> '')) then Exit;

  A := 0;
  B := 0;
  while not Eof(f) do
  begin
    BlockRead(f, Buffer, BUFFER_LENGTH, BytesRead);
    for i := 0 to BytesRead - 1 do
    begin
      A := A + Buffer[i]; // modulo: 2^16
      B := B + A; // modulo: 2^16
    end;
  end;

  CloseFile(f);

  Result := Integer(MakeLong(A, B));
end;

{ --------------------------------------------------------------------------- }

function VersionStringToFloat(Version: string): Single;
begin
  Result := StrToFloat(Version);
end;

{ --------------------------------------------------------------------------- }

function GetFileSize(FileName: string): Integer;
var
  f: file of Byte;
begin
  Result := -1;
  if not FileExists(FileName) then Exit;

  {$I-}
  AssignFile(f, FileName);
  FileMode := 0;  {Set file access to read only }
  Reset(f);
  Result := FileSize(f);
  CloseFile(f);
  {$I+}
  if IOResult <> 0 then Result := -1;
end;

function ReadFile2(FileName: string): String;
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  SetLength(Result,FileStream.Size);
  FileStream.ReadBuffer(Pointer(Result)^,FileStream.Size);
  FileStream.Free;
end;

function ReadLastLogFileLines(FileStream: TFileStream; nbLines : integer ): String;
var
  i: integer;
  c: string;
  readSize: integer;
  line : string;
  previousEOL: integer;
begin
  FileStream.Seek(-1,soFromEnd);
  if FileStream.Size < 2 then Exit;
  SetLength(c,1);

  previousEOL := FileStream.Size;
  i := 0;
  repeat
    FileStream.Seek(-2,soFromCurrent);
    FileStream.ReadBuffer(Pointer(c)^,1);
    if c = #13 then
    begin
      readSize := previousEOL-FileStream.Position-1;
      if readSize > 0 then
      begin
        SetLength(line,readSize);
        FileStream.ReadBuffer(Pointer(line)^,readSize);
        FileStream.Seek(-readSize,soFromCurrent);
        if (LeftStr(LowerCase(line),16) <> #10+'logging started') and (LeftStr(LowerCase(line),10) <> #10+'---------') and (line <> #10) then // not counting the logging started msgs
        begin
          if Result = '' then
            Result := StringReplace(line,#10,'',[rfReplaceAll])
          else
            Result := StringReplace(line,#10,'',[rfReplaceAll]) + EOL + Result;
          Inc(i);
        end;
      end;
      previousEOL := FileStream.Position;
    end;
  until (i >= nbLines) or (FileStream.Position <= 2);

  Result := TrimLeft(Result);

  FileStream.Seek(-1,soFromEnd);
end;

procedure SaveFile(FileName: string;content: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenWrite or fmCreate);
  try
    FileStream.WriteBuffer(content[1],Length(content));
  finally
    FileStream.Free;
  end;
end;

{ --------------------------------------------------------------------------- }

function VerifyName(Name: string): Boolean;
  function VerifyChar(c: Char): Boolean;
  begin
    Result :=
       ((Ord(c) >= 48) and (Ord(c) <= 57))  // numbers
    or ((Ord(c) >= 65) and (Ord(c) <= 90))  // capital letters
    or ((Ord(c) >= 97) and (Ord(c) <= 122)) // letters
    or (Ord(c) = 95)                        // underscore
    or (Ord(c) = 91)                        // left bracket "["
    or (Ord(c) = 93);                       // right bracket "]"
  end;

var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(Name) do if not VerifyChar(Name[i]) then Exit;
  Result := True;
end;

{ --------------------------------------------------------------------------- }

// from: http://www.latiumsoftware.com/en/delphi/00004.php

function GetRegistryData(RootKey: HKEY; Key, Value: string): Variant;
var
  Reg: TRegistry;
  RegDataType: TRegDataType;
  DataSize, Len: integer;
  s: string;
label cantread;
begin
  Reg := nil;
  try
    Reg := TRegistry.Create(KEY_QUERY_VALUE);
    Reg.RootKey := RootKey;
    if Reg.OpenKeyReadOnly(Key) then begin
      try
        RegDataType := Reg.GetDataType(Value);
        if (RegDataType = rdString) or
           (RegDataType = rdExpandString) then
          Result := Reg.ReadString(Value)
        else if RegDataType = rdInteger then
          Result := Reg.ReadInteger(Value)
        else if RegDataType = rdBinary then begin
          DataSize := Reg.GetDataSize(Value);
          if DataSize = -1 then goto cantread;
          SetLength(s, DataSize);
          Len := Reg.ReadBinaryData(Value, PChar(s)^, DataSize);
          if Len <> DataSize then goto cantread;
          Result := s;
        end else
cantread:
          raise Exception.Create(SysErrorMessage(ERROR_CANTREAD));
      except
        s := ''; // Deallocates memory if allocated
        Reg.CloseKey;
        raise;
      end;
      Reg.CloseKey;
    end else
      raise Exception.Create(SysErrorMessage(GetLastError));
  except
    Reg.Free;
    raise;
  end;
  Reg.Free;
end;

{ --------------------------------------------------------------------------- }

// from: http://www.latiumsoftware.com/en/delphi/00004.php

procedure SetRegistryData(RootKey: HKEY; Key, Value: string;
  RegDataType: TRegDataType; Data: Variant);
var
  Reg: TRegistry;
  s: string;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(Key, True) then begin
      try
        if RegDataType = rdUnknown then
          RegDataType := Reg.GetDataType(Value);
        if RegDataType = rdString then
          Reg.WriteString(Value, Data)
        else if RegDataType = rdExpandString then
          Reg.WriteExpandString(Value, Data)
        else if RegDataType = rdInteger then
          Reg.WriteInteger(Value, Data)
        else if RegDataType = rdBinary then begin
          s := Data;
          Reg.WriteBinaryData(Value, PChar(s)^, Length(s));
        end else
          raise Exception.Create(SysErrorMessage(ERROR_CANTWRITE));
      except
        Reg.CloseKey;
        raise;
      end;
      Reg.CloseKey;
    end else
      raise Exception.Create(SysErrorMessage(GetLastError));
  finally
    Reg.Free;
  end;
end;

{ --------------------------------------------------------------------------- }

procedure RemoveRegistryData(RootKey: HKEY; Key, Value: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(RootKey);
  if Reg.OpenKey(Key, False) then Reg.DeleteValue(Value);
  Reg.CloseKey;
  Reg.Free;
end;

{ --------------------------------------------------------------------------- }

procedure RemoveRegistryKey(RootKey: HKEY; Key: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(RootKey);
  Reg.DeleteKey(Key);
  Reg.CloseKey;
  Reg.Free;
end;

{ --------------------------------------------------------------------------- }

// <Size> is in bytes! Returns number of KBytes (float format, e.g.: 0.56 KB)
function FormatFileSize(Size: Integer): string;
begin
  Result := Trim(Format('%8.2f', [(Size / 1024)]));
end;

{ --------------------------------------------------------------------------- }

// returns result in a human readable form
function FormatFileSize2(SizeInBytes: Integer): string;
begin
  if SizeInBytes < 1000 then Result := IntToStr(SizeInBytes) + ' bytes'
  else if SizeInBytes < 1000*1000 then Result := Format('%.2f', [(SizeInBytes / 1024)]) + ' kB'
  else Result := Format('%.2f', [(SizeInBytes / (1024*1024))]) + ' MB'
end;

function FormatFileSize3(const sizes: array of const;formatStr: string): string;
var
  i: integer;
  maxSize: integer;
  unitDiv: Extended;
  unitStr: string;
begin
  maxSize := 0;
  for i:=0 to Length(sizes)-1 do
  begin
    if sizes[i].VType <> System.vtInteger then
      raise Exception.Create('Misc.FormatFileSize3 only supports integer sizes');
    if sizes[i].VInteger > maxSize then
      maxSize := sizes[i].VInteger;
  end;

  i:=0;

  while maxSize / (Power(1024,i+1)) > 2 do
    Inc(i);

  case i of
    0: unitStr := _('bytes');
    1: unitStr := _('kB');
    2: unitStr := _('MB');
    3: unitStr := _('GB');
    4: unitStr := _('TB');
  else
    unitStr := 'HELL LOT OF BYTES';
  end;

  unitDiv := Power(1024,i);

  Result := formatStr;
  for i:=0 to Length(sizes)-1 do
  begin
    Result := StringReplace(Result,'%s',Format('%.2f', [(sizes[i].VInteger / unitDiv)]),[]);
  end;
  Result := StringReplace(Result,'%u',unitStr,[rfReplaceAll]);
end;

{ --------------------------------------------------------------------------- }

function GenerateUniqueID: Integer;
begin
  Result := Random(High(Integer));
end;

{ --------------------------------------------------------------------------- }

// returns MHz for all processors except for AMD (returns the "real" speed expressed in MHz).
// Also note that this method works only with never systems (Windows 98 for example,
// don't have this registry key)
function GetCPUSpeed: Integer;
var
  Registry: TRegistry;
  s: string;
begin
  Result := 0;

  Registry := TRegistry.Create;
  try
    try
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      Registry.OpenKey('\HARDWARE\DESCRIPTION\SYSTEM\CentralProcessor\0', False);
      Result := Registry.ReadInteger('~MHz');
      s := Registry.ReadString('ProcessorNameString');

      if Length(s) >= 3 then if UpperCase(Copy(s, 1, 3)) = 'AMD' then
      begin
        try
          Result := StrToInt(Copy(s, Length(s)-4, 4));
        except
        end;
      end;
    except
      // user doesn't have permission (non-admin account) or uses windows < 2000
    end;
  finally
    Registry.Free;
  end;
end;

{ --------------------------------------------------------------------------- }

procedure NormalizeRect(var Rect: TRect);
var
  tmp: Integer;
begin
  with Rect do
  begin
    if Right < Left then
    begin
      tmp := Left;
      Left := Right;
      Right := tmp;
    end;

    if Bottom < Top then
    begin
      tmp := Top;
      Top := Bottom;
      Bottom := tmp;
    end;
  end;
end;

{ --------------------------------------------------------------------------- }

procedure LimitRect(var Rect: TRect; LimitRect: TRect);
begin
  NormalizeRect(LimitRect);

  Rect.Left := Min(LimitRect.Right, Max(Rect.Left, LimitRect.Left));
  Rect.Top := Min(LimitRect.Bottom, Max(Rect.Top, LimitRect.Top));

  Rect.Right := Max(LimitRect.Left, Min(Rect.Right, LimitRect.Right));
  Rect.Bottom := Max(LimitRect.Top, Min(Rect.Bottom, LimitRect.Bottom));
end;

procedure LimitRect2(var Rect: TRect; LimitRect: TRect);
var
  tmp: integer;
begin
  NormalizeRect(LimitRect);

  if Rect.Right > LimitRect.Right then
  begin
    tmp := (Rect.Right-Rect.Left);
    Rect.Left := LimitRect.Right-tmp;
    Rect.Right := Rect.Left + tmp;
  end;
  if Rect.Bottom > LimitRect.Bottom then
  begin
    tmp := (Rect.Bottom-Rect.Top);
    Rect.Top := LimitRect.Bottom-tmp;
    Rect.Bottom := Rect.Top + tmp;
  end;
  if Rect.Left < LimitRect.Left then
  begin
    tmp := (Rect.Right-Rect.Left);
    Rect.Left := LimitRect.Left;
    Rect.Right := Rect.Left + tmp;
  end;
  if Rect.Top < LimitRect.Top then
  begin
    tmp := (Rect.Bottom-Rect.Top);
    Rect.Top := LimitRect.Top;
    Rect.Bottom := Rect.Top + tmp;
  end;
end;

{ --------------------------------------------------------------------------- }

function PointInRect(Rect: TRect; Point: TPoint): Boolean;
begin
  NormalizeRect(Rect);
  Result := (Point.X >= Rect.Left) and (Point.X <= Rect.Right)
        and (Point.Y >= Rect.Top) and (Point.Y <= Rect.Bottom);
end;

{ --------------------------------------------------------------------------- }

// removes double "/" chars and replaces spaces with %20
procedure FixURL(var URL: string);
var
  i: Integer;
  last: Boolean;
begin
  last := False;
  i := 7; // we must skip "http://" part
  while True do
  begin
    if i > Length(URL) then Break;
    if URL[i] = ' ' then
    begin
      Delete(URL, i, 1);
      Insert('%20', URL, i);
      Inc(i, 2);
      Continue;
    end;
    if URL[i] = '/' then
      if last then
      begin
        Delete(URL, i, 1);
      end
      else last := True
    else last := False;
    Inc(i);
  end;
end;

{ --------------------------------------------------------------------------- }

function CreateMapListFromHtml(const HtmlText: TStringList): TStringList;
var
  i: Integer;
  text: string;
  start, stop: Integer;
  lines: TStringList;

  name, download, minimap, page: string;
begin
  Result := TStringList.Create;
  if HtmlText.Count = 0 then Exit;

  text := '';
  for i := 0 to HtmlText.Count-1 do text := text + HtmlText[i] + #13#10;

  start := Pos('<--', text) + 7;
  stop := Pos('-->', text) - 4;

  if ((start = 0) or (stop = 0) or (stop < start)) then raise Exception.Create('Bad html file!');
  text := Copy(text, start, stop-start);

  // let's parse it now:
  lines := StringParser.ParseStringEx(text, '<br>');
  try
    for i := 0 to lines.Count-1 do
    begin
      start := Pos('''', lines[i]);
      if start = 0 then raise Exception.Create('Bad html file!');
      Inc(start);
      stop := PosEx('''', lines[i], start+1);
      if (stop = 0) or (stop < start) then raise Exception.Create('Bad html file!');

      page := 'http://www.fileuniverse.com/' + Copy(lines[i], start, stop-start);

      start := PosEx('>', lines[i], stop+1) + 1;
      stop := PosEx('</a>', lines[i], stop+1);
      name := Copy(lines[i], start, stop-start); //**** ?

      start := PosEx('''', lines[i], stop+1) + 1;
      stop := PosEx('''', lines[i], start);
      minimap := Copy(lines[i], start, stop-start);

      start := PosEx('''', lines[i], stop+1) + 1;
      stop := PosEx('''', lines[i], start);
      download := 'http://www.fileuniverse.com/' + Copy(lines[i], start, stop-start);

      Result.Add(page + '+' + name + '+' + minimap + '+' + download);

    end;
  finally
    lines.Free;
  end;
end;

{ --------------------------------------------------------------------------- }

procedure RevertList(List: TList);
var
  i: Integer;
  temp: Pointer;
begin
  if List.Count = 0 then Exit;

  for i := 0 to (List.Count-1) div 2 do
  begin
    temp := List[i];
    List[i] := List[List.Count-1-i];
    List[List.Count-1-i] := temp;
  end;

end;

{ --------------------------------------------------------------------------- }

procedure AddBitmapToImageList(il: TImageList; FileName: string); overload; // doesn't check for errors. Assumes clWhite is the transparent color.
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.LoadFromFile(FileName);
  il.AddMasked(bmp, clWhite);
  bmp.Free;
end;

{ --------------------------------------------------------------------------- }

procedure AddBitmapToImageList(il: TImageList; const buf; len: Integer); overload; // doesn't check for errors. Assumes clWhite is the transparent color.
var
  bmp: TBitmap;
  strm: TMemoryStream;
begin
  strm := TMemoryStream.Create;
  strm.WriteBuffer(buf, len);
  strm.Position := 0;
  bmp := TBitmap.Create;
  bmp.LoadFromStream(strm);
  il.AddMasked(bmp, clWhite);
  bmp.Free;
  strm.Free;
end;

{ --------------------------------------------------------------------------- }

procedure SendUDPStr(Address: string; DestinationPort: Integer; var SourcePort: Integer; Text: string);
var
  WSocket: TWSocket;
begin
  if Debug.Enabled then MainForm.AddMainLog('UDP to ' + Address + ' from port ' + IntToStr(SourcePort) + ' to port ' + IntToStr(DestinationPort) + ' has been sent.', Colors.Info);

  WSocket := TWSocket.Create(nil);
  WSocket.Proto := 'udp';
  WSocket.Addr := Address;
  WSocket.Port := IntToStr(DestinationPort);
  WSocket.LocalPort  := IntToStr(SourcePort);
  { UDP is connectionless. Connect will just open the socket }
  WSocket.Connect;
  SourcePort := StrToInt(WSocket.LocalPort); // useful when we assign 0 for source port (OS will rewrite our source port when we call Connect function)
  WSocket.SendStr(Text);
  WSocket.Free;
end;

{ --------------------------------------------------------------------------- }

procedure SendUDPStrEx(Address: string; DestinationPort: Integer; var SourcePort: Integer; TTL: Integer; Text: string);
var
  WSocket: TWSocket;
begin
  {$IFDEF DONTUSETTL2}
  TTL := 128;
  {$ENDIF}

  if Debug.Enabled then MainForm.AddMainLog('UDP to ' + Address + ' from port ' + IntToStr(SourcePort) + ' to port ' + IntToStr(DestinationPort) + ' has been sent.', Colors.Info);

  WSocket := TWSocket.Create(nil);
  WSocket.Proto := 'udp';
  WSocket.Addr := Address;
  WSocket.Port := IntToStr(DestinationPort);
  WSocket.LocalPort  := IntToStr(SourcePort);
  { UDP is connectionless. Connect will just open the socket }
  WSocket.Connect;
  SourcePort := StrToInt(WSocket.LocalPort); // useful when we assign 0 for source port (OS will rewrite our source port when we call Connect function)
  WSocket_SetSockOpt(WSocket.HSocket, IPPROTO_IP, IP_TTL, @TTL, SizeOf(TTL));

{
  size := SizeOf(TTL);
  WSocket_GetSockOpt(WSocket.HSocket, IPPROTO_IP, IP_TTL, @TTL, size);
  MainForm.AddMainLog(IntToStr(TTL), Colors.Info);
}

  WSocket.SendStr(Text);
  WSocket.Free;
end;

{ --------------------------------------------------------------------------- }

function GetMD5Hash(s: string): string; // returns hash in base 64 format
var
  BinaryResult: AnsiString;
  I: Integer;
  MD5: TMD5Stream;
begin
  MD5 := TMD5Stream.Create;
  try
    MD5.WriteBuffer(s[1], Length(s));
    BinaryResult := MD5.DigestString;
    Result := SZFullEncodeBase64(BinaryResult);
  finally
    MD5.Free;
  end
end;

  //returns MD5 has for a file
function GetFileMD5Hash(const fileName : string) : string;
var
  idmd5 : TIdHashMessageDigest5;
  fs : TFileStream;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  fs := TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite) ;
  try
    result := idmd5.AsHex(idmd5.HashValue(fs)) ;
  finally
    fs.Free;
    idmd5.Free;
  end;
end;

{ --------------------------------------------------------------------------- }

// found at: http://www.howtodothings.com/viewarticle.aspx?article=490

function GetLocalIP: string;
var
  wsaData: TWSAData;
  addr: TSockAddrIn;
  Phe: PHostEnt;
  szHostName: array[0..128] of Char;
begin
  Result := '';
  if WSAStartup($101, WSAData) <> 0 then
    Exit;
  try
    if GetHostName(szHostName, 128) <> SOCKET_ERROR then
    begin
      Phe := GetHostByName(szHostName);
      if Assigned(Phe) then
      begin
        addr.sin_addr.S_addr := longint(plongint(Phe^.h_addr_list^)^);
        Result := inet_ntoa(addr.sin_addr);
      end;
    end;
  finally
    WSACleanup;
  end;
end;


{ --------------------------------------------------------------------------- }

function UTCTimeToLocalTime(utctime: TDateTime): TDateTime;
var
  TZ: TTimeZoneInformation;
begin
  GetTimeZoneInformation (TZ);
  Result := UTCToTZLocalTime(TZ,utctime);
end;

{ --------------------------------------------------------------------------- }

// maps color name to color index in TJvColorComboBox
function MapColorNameToIndex(ColorName: string; ColorComboBox: TJvColorComboBox): Integer;
var
  i: Integer;
begin
  for i := 0 to ColorComboBox.Items.Count-1 do if SameText(ColorComboBox.Items[i], ColorName) then
  begin
    Result := i;
    Exit;
  end;

  // not found:
  Result := -1;
end;

{ --------------------------------------------------------------------------- }

function EnumerateSpaces(Count: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Count do Result := Result + ' ';
end;

{ --------------------------------------------------------------------------- }

function PackRGB(R: Byte; G: Byte; B: Byte): Integer; // packs R, G, B to $00BBGGRR format (standard TColor format)
begin
  Result := B + G shl 8 + R shl 16;
end;

{ --------------------------------------------------------------------------- }

function PackRGB(R: Extended; G: Extended; B: Extended): Integer; // packs R, G, B to $00BBGGRR format (standard TColor format). R, G and B must be in interval [0..1]
begin
  Result := Byte(Round(255 * R)) + Byte(Round(255 * G)) shl 8 + Byte(Round(255 * B)) shl 16;
end;

{ --------------------------------------------------------------------------- }

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

{ --------------------------------------------------------------------------- }

function ColorToStandardRGB(Color: Integer): Integer;
begin
  Result := ((ColorToR(Color) shl 16) or ColorToG(Color) shl 8) or ColorToB(Color);
end;

function ColorToStandardRGBHex(Color: Integer): string;
begin
  Result := IntToHex(ColorToStandardRGB(Color),6);
end;

function StandardRGBToColor(Color: Integer): Integer;
var
  R,G,B:byte;
begin
  R := (Color and $00FF0000) shr 16;
  G := (Color and $0000FF00) shr 8;
  B := Color and $000000FF;
  Result := RGB(R,G,B);
end;

{ --------------------------------------------------------------------------- }

function ColorToScriptString(ColorC: TColor): string;
var
  Color: Integer;
begin
  Color := ColorToRGB(ColorC);
  Result := FloatToStr(ColorToR(Color)/255)+' '+FloatToStr(ColorToG(Color)/255)+' '+FloatToStr(ColorToB(Color)/255)+' ';
end;

{ --------------------------------------------------------------------------- }

function Color16BitsToR(Color: Word): Byte;
begin
  Result := Color and $F800 shr 8;
end;

function Color16BitsToG(Color: Word): Byte;
begin
  Result := Color and $7E0 shr 3;
end;

function Color16BitsToB(Color: Word): Byte;
begin
  Result := Color and $1F shl 3;
end;

function RGB16BitsToColor(R,G,B : Byte): Word;
begin
  Result := R*2048+G*32+B;
end;

function GetColorIndex(ColorArray: array of TColor; Color: TColor): Integer; // returns -1 if Color is not found in ColorArray
var
  i: Integer;
begin
  for i := 0 to High(ColorArray) do
    if ColorArray[i] = Color then
    begin
      Result := i;
      Exit;
    end;
  // not found:
  Result := -1;
end;

{ --------------------------------------------------------------------------- }

// Centers a form on screen at runtime
// (copied from http://www.chmaas.handshake.de/delphi/tipsmain.htm)
procedure CenterForm(AForm: TForm);
var ALeft, ATop: integer;
begin
  ALeft := (Screen.Width - AForm.Width) div 2;
  ATop  := (Screen.Height - AForm.Height) div 2;
  { prevents form being repainted twice! }
  AForm.SetBounds(ALeft, ATop, AForm.Width, AForm.Height);
end;

{ --------------------------------------------------------------------------- }

{ will center AForm over BaseForm at runtime }
procedure CenterFormOverAnotherForm(AForm: TForm; BaseForm: TForm);
var
  ALeft, ATop: integer;
begin
  ALeft := BaseForm.Left + (BaseForm.Width div 2) - (AForm.Width div 2);
  ATop := BaseForm.Top + (BaseForm.Height div 2) - (AForm.Height div 2);
  { prevent form from being outside the screen }
  if ALeft < 0 then ALeft := BaseForm.Left;
  if ATop < 0 then ATop := BaseForm.Top;
  if (ALeft + AForm.Width > Screen.Width) or (ATop + AForm.Height > Screen.Height) then
    CenterForm (AForm)
  else
    AForm.SetBounds (ALeft, ATop, AForm.Width, AForm.Height); { prevents form being twice repainted! }
end;

{ --------------------------------------------------------------------------- }

// will disable/enable all TSpTBXTitleBar-s application wide.
// Note that due to some bug in SpTBXItem.pas it won't restore
// parent forms correctly (see http://news.jrsoftware.org/read/article.php?id=12996&group=jrsoftware.toolbar2000.thirdparty#12996
// for more info on this problem)
procedure ActivateOrDeactivateAllTBXTitleBars(Activate: Boolean);
var
  i, j: Integer;
  a: TSpTBXTitleBar;
begin
  for i := 0 to Screen.FormCount-1 do
    for j := 0 to Screen.Forms[i].ControlCount-1 do
      if Screen.Forms[i].Controls[j].ClassType = TSpTBXTitleBar then
        TSpTBXTitleBar(Screen.Forms[i].Controls[j]).Active := Activate;
end;

{ --------------------------------------------------------------------------- }

// tries to figure out if we are running this application under Wine (see http://www.winehq.com)
function DetectWine: Boolean;
var
  Registry: TRegistry;
  s: string;
begin
  Result := False;

  try
    Registry := TRegistry.Create;
    try
      Registry.RootKey := HKEY_CURRENT_USER; // this is where Wine entry is usually located
      if Registry.OpenKey('\Software\Wine\', False) then Result := True;
    except
      // user doesn't have permission (non-admin account) or some other problem
    end;
  finally
    Registry.Free;
  end;

  try
    Registry := TRegistry.Create;
    try
      Registry.RootKey := HKEY_LOCAL_MACHINE; // just in case it wasn't in HKCU
      if Registry.OpenKey('\Software\Wine\', False) then Result := True;
    except
      // user doesn't have permission (non-admin account) or some other problem
    end;
  finally
    Registry.Free;
  end;

end;

{ --------------------------------------------------------------------------- }

// copied from: http://delphi.about.com/cs/adptips2001/a/bltip0201_2.htm
procedure CaptureProgramOutput(DosApp: string; Output: TStrings);
const
  ReadBuffer = 2400;
var
  Security: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  start: TStartUpInfo;
  ProcessInfo: TProcessInformation;
  Buffer: PChar;
  BytesRead: DWord;
  Apprunning: DWord;
begin
  with Security do
  begin
    nlength := SizeOf(TSecurityAttributes);
    binherithandle := True;
    lpsecuritydescriptor := nil;
  end;

  if Createpipe(ReadPipe, WritePipe, @Security, 0) then
  begin
    Buffer := AllocMem(ReadBuffer + 1);
    FillChar(Start, Sizeof(Start), #0);
    start.cb := SizeOf(start);
    start.hStdOutput := WritePipe;
    start.hStdInput := ReadPipe;
    start.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    start.wShowWindow := SW_HIDE;

    if CreateProcess(nil,
           PChar(DosApp),
           @Security,
           @Security,
           true,
           NORMAL_PRIORITY_CLASS + SYNCHRONIZE,
           nil,
           nil,
           start,
           ProcessInfo)
    then
    begin
      repeat
        Apprunning := WaitForSingleObject(ProcessInfo.hProcess, 100);
        Application.ProcessMessages;
      until (Apprunning <> WAIT_TIMEOUT);
      repeat
        BytesRead := 0;
        ReadFile(ReadPipe, Buffer[0], ReadBuffer, BytesRead, nil);
        Buffer[BytesRead] := #0;
        OemToAnsi(Buffer, Buffer);
        Output.Text := Output.Text + string(Buffer);
      until (BytesRead < ReadBuffer);
    end;
    FreeMem(Buffer);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ReadPipe);
    CloseHandle(WritePipe);
  end;
end;

{ --------------------------------------------------------------------------- }

// this function is obsolete since 0.75. Use unitsync.dll function GetSpringVersion() instead.
function GetSpringVersionFromEXE: string;
var
  ExitCode: Cardinal;
  Output: TStringList;
  time: Cardinal;
  sl: TStringList;
begin
  time := GetTickCount;
  Output := TStringList.Create;
//*** -> this code caused crashes on Wine: DSiExecuteAndCapture('spring.exe /V', Output, ExtractFilePath(Application.ExeName), ExitCode);
  CaptureProgramOutput('spring.exe -V', Output);

  if Output.Text = '' then
  begin
    MessageDlg('Unable to acquire Spring version from "spring.exe". Make sure "spring.exe" is located in the same folder as TASClient. If you think this is an error, please report it to springlobby@clan-sy.com', mtError, [mbOK], 0);
    Halt;
  end;

  sl := StringParser.ParseString(Trim(Output.Text), ' ');
  Result := sl[1];
  sl.Free;
  Output.Free;
end;

{ --------------------------------------------------------------------------- }

// returns 0 if not set
function GetLobbyUserID: Integer;
var
  UserID: Cardinal;
begin
  UserID := 0;
  try
    UserID := GetRegistryData(HKEY_LOCAL_MACHINE, '\Software\TNEilcsat', 'UserId');
  except
  end;

  Result := UserID;
end;

{ --------------------------------------------------------------------------- }

procedure GenerateAndSaveLobbyUserID;
var
  UserID: Cardinal;
begin
  UserID := Random(2147483647) + 2147483648;
  try
    Misc.SetRegistryData(HKEY_LOCAL_MACHINE, '\Software\TNEilcsat', 'UserId', rdInteger, Integer(UserID));
  except
  end;
end;

{ --------------------------------------------------------------------------- }

procedure OpenURLInDefaultBrowser(URL: string);
begin
//  ShellExecute(MainForm.Handle, nil, PChar(URL), '', '', SW_SHOW);
  ShellExecute(MainForm.Handle, 'open', PChar(AnsiString(URL)), '', '', SW_SHOWNORMAL);

end;

{ --------------------------------------------------------------------------- }

function ColorDistance(e1:integer;e2:integer):integer;
var
   l1,a1,b1: integer;
   l2,a2,b2: integer;
begin
   RGBToLab(ColorToR(e1),ColorToG(e1),ColorToB(e1),l1,a1,b1);
   RGBToLab(ColorToR(e2),ColorToG(e2),ColorToB(e2),l2,a2,b2);
   Result := Round(Sqrt(Power((l1-l2),2)+Power((a1-a2),2)+Power((b1-b2),2)));
end;

function ColorDistance2(e1:integer;e2:integer):integer;
var
  r,g,b,rmean : integer;
begin
  rmean := Round((ColorToR(e1)+ColorToR(e2))/2);
  r := ColorToR(e1)-ColorToR(e2);
  g := ColorToG(e1)-ColorToG(e2);
  b := ColorToB(e1)-ColorToB(e2);
  Result := (((512 + rmean)*r*r) shr 8) + 4*g*g + (((767 - rmean)*b*b) shr 8);
end;

procedure RGBToLab(r:byte;g:byte;b1:byte;var l:integer;var a:integer;var b2:integer);
var
  Xn,Yn,Zn : double;
  X,Y,Z : double;
  fx,fy,fz: double;
  xr,yr,zr: double;
  rr,bb,gg:double;
begin
  Xn := 0.964221;
  Yn := 1;
  Zn := 0.825211;

  if r/255 <= 0.04045 then
    rr := r/255/12.92
  else
    rr := Power((r/255+0.055)/1.055,2.4);

  if g/255 <= 0.04045 then
    gg := g/255/12.92
  else
    gg := Power((g/255+0.055)/1.055,2.4);

  if b1/255 <= 0.04045 then
    bb := b1/255/12.92
  else
    bb := Power((b1/255+0.055)/1.055,2.4);

  X := 0.436052025* rr + 0.385081593*gg + 0.143087414*bb;
  Y := 0.222491598* rr + 0.71688606*gg + 0.060621486*bb;
  Z := 0.013929122* rr + 0.097097002*gg + 0.71418547*bb;

  xr:=X/Xn;
  yr:=Y/Yn;
  zr:=Z/Zn;

  if xr > 0.008856 then
    fx := Power(xr,1/3)
  else
    fx := (xr*903.3+16)/116;

  if yr > 0.008856 then
    fy := Power(yr,1/3)
  else
    fy := (yr*903.3+16)/116;

  if zr > 0.008856 then
    fz := Power(zr,1/3)
  else
    fz := (zr*903.3+16)/116;

  l:=Round(116*fy-16);
  a:=Round(500*(fx-fy));
  b2:=Round(200*(fy-fz));
end;
function Contains(const str: string; const strL : TStringList): Boolean;
  begin
      Result := strL.IndexOf(str) > -1;
  end;

function HSL(H: integer;S: byte;L: byte):Integer;
var
  R,G,B : byte;
begin
  HslToRgb(H,S,L,R,G,B);
  Result := R*65536 + G*256 + B;
end;

procedure HslToRgb(H: integer;S: byte;L: byte;var R: byte;var G: byte;var B: byte);
var
   xminL100, xmoyL100montant, xmoyL100descendant, xmaxL100: double;
   xmin, xmoymontant, xmoydescendant, xmax: Byte;
begin
     xminL100:=255*(100-S)/100;

     xmoyL100descendant:=255-S*(H mod 60)*255/6000;

     xmoyL100montant:=255-S*(60 -(H mod 60))*255/6000;

     xmaxL100:=255;

     xmin:=Round(xminL100*L/100);

     xmoymontant:=Round(xmoyL100montant*L/100);

     xmoydescendant:=Round(xmoyL100descendant*L/100);

     xmax:=Round(xmaxL100*L/100);
     begin
          R:=xmax;
          B:=xmoydescendant;
          G:=xmin;
     end;

     if ((H>=0) and (H<60)) then
     begin
          R:=xmax;
          G:=xmoymontant;
          B:=xmin;
     end;

     if ((H>=60) and (H<120)) then
     begin
          G:=xmax;
          R:=xmoydescendant;
          B:=xmin;
     end;

     if ((H>=120) and (H<180)) then
     begin
          G:=xmax;
          B:=xmoymontant;
          R:=xmin;
     end;

     if ((H>=180) and (H<240)) then
     begin
          B:=xmax;
          G:=xmoydescendant;
          R:=xmin;
     end;

     if ((H>=240) and (H<300)) then
     begin
          B:=xmax;
          R:=xmoymontant;
          G:=xmin;
     end;
end;
procedure RgbToHsl(R,G,B: byte;var H: integer;var S: byte;var L: byte);
const
     MONTANT = True;
     DESCENDANT = False;
var
   xmin,xmoy,xmax: Byte;
   Ld: double;
   Sd: double;
   xmoyL100: double;
   xmoyLS100: double;
   TSup: integer;
   Sens:Boolean;
   T : integer;
begin
     if ((R=255) and (G=255) and (B=255)) then
     begin
          H:=0;
          S:=0;
          L:=100;
          exit;
     end;

     if ((R=0) and (G=0) and (B=0)) then
     begin
          H:=0;
          S:=0;
          L:=0;
          exit;
     end;

     begin
          TSup:=360;
          Sens:=DESCENDANT;
          xmax:=R;
          xmoy:=B;
          xmin:=G;
     end;

     if ((R>=G) and (G>B)) then
     begin
          TSup:=60;
          Sens:=MONTANT;
          xmax:=R;
          xmoy:=G;
          xmin:=B;
     end;

     if ((G>R) and (R>=B)) then
     begin
          TSup:=120;
          Sens:=DESCENDANT;
          xmax:=G;
          xmoy:=R;
          xmin:=B;
     end;

     if ((G>=B) and (B>R)) then
     begin
          TSup:=180;
          Sens:=MONTANT;
          xmax:=G;
          xmoy:=B;
          xmin:=R;
     end;

     if ((B>G) and (G>=R)) then
     begin
          TSup:=240;
          Sens:=DESCENDANT;
          xmax:=B;
          xmoy:=G;
          xmin:=R;
     end;

     if ((B>=R) and (R>=G)) then
     begin
          TSup:=300;
          Sens:=MONTANT;
          xmax:=B;
          xmoy:=R;
          xmin:=G;
     end;

     Ld:=xmax*100/255;

     if xmax<>0 then
        Sd:=100-100*xmin/xmax
     else
         Sd:=100;

     if Ld<>0 then
        xmoyL100:=xmoy*100/Ld
     else
         xmoyL100:=0;

     if Sd<>0 then
        xmoyLS100:=(100*xmoyL100 - 255*(100-Sd))/Sd
     else
         xmoyLS100:=xmoyL100;

     if Sens=MONTANT then
        T:=Round(TSup - 60 + xmoyLS100*60/255)
     else
         T:=Round(TSup - xmoyLS100*60/255);

     S:=Round(Sd);
     L:=Round(Ld);
     H:=T;
end;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputQueryInteger(const ACaption, APrompt: WideString; var Val: Integer;
  Min: Integer = Low(Integer); Max: Integer = High(Integer);
  Increment: Integer = 1): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TJvSpinEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TJvSpinEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        MinValue := Min;
        MaxValue := Max;
        Increment := Increment;
        Value := Val;
        SelectAll;
        ButtonKind := bkStandard;
        CheckOptions := [coCheckOnExit,coCropBeyondLimit];
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Ok';
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Cancel';
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;          
      end;
      if ShowModal = mrOk then
      begin
        Val := Round(Edit.Value);
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function InputBoxInteger(const ACaption, APrompt: WideString; ADefault: Integer;
  Min: Integer = Low(Integer); Max: Integer = High(Integer);
  Increment: Integer = 1): Integer;
begin
  Result := ADefault;
  InputQueryInteger(ACaption, APrompt, Result, Min, Max, Increment);
end;

function IsWindowsVista: Boolean;
var
  VerInfo: TOSVersioninfo;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);
  Result := VerInfo.dwMajorVersion >= 6;
end;

function IsWindowsXP: Boolean;
var
  VerInfo: TOSVersioninfo;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(VerInfo);
  Result := (VerInfo.dwMajorVersion = 5) and (VerInfo.dwMinorVersion = 1) ;
end;

function InputColor(title: String; defaultColor: TColor):TColor;
var
  i: integer;
begin
  ColorPickerForm.SpTBXTitleBar1.Caption := title;
  ColorPickerForm.SetColor(defaultColor);

  if ColorPickerForm.ShowModal = mrOK then
    Result := ColorPickerForm.ColorPanel.Color
  else
    Result := defaultColor;
end;

procedure FixFormSizeConstraints(form: TForm);
begin
  with form.Constraints do
  begin
    MaxHeight := 0;
    MaxWidth := 0;
    MinHeight := 50;
    MinWidth := 50;
  end;
end;

constructor TGetInternetIpThread.Create(Suspended: Boolean);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   OnTerminate := OnTerminateProcedure;
end;

procedure TGetInternetIpThread.Execute;
begin
  Refresh;
end;

procedure TGetInternetIpThread.Refresh;
var
  html:string;
  i: integer;
  HttpCli2: THttpCli;
begin
  HttpCli2 := THttpCli.Create(MainForm);
    // get the html result


    HttpCli2.Proxy := '';
    HttpCli2.URL := 'http://www.whatismyip.com/automation/n09230945.asp';
    HttpCli2.RcvdStream := TMemoryStream.Create;
    try
      HttpCli2.Get;
    except
      Exit;
    end;
    HttpCli2.RcvdStream.Seek(0,0);
    SetLength(html, HttpCli2.RcvdStream.Size);
    HttpCli2.RcvdStream.ReadBuffer(Pointer(html)^, HttpCli2.RcvdStream.Size);

    if html = '' then begin
      Exit;
    end;

    MainUnit.MyInternetIp := html;

end;

procedure TGetInternetIpThread.OnTerminateProcedure(Sender: TObject);
begin
  // nothing
end;

procedure DrawMultilineText(AString: string;
                       ACanvas:TCanvas;ARect: TRect;
                       HorizontalAlign:THorizontalAlign;
                       VerticalAlign:TVerticalAlign;
                       TextJustification:TJustify;
                       WordWrap:boolean);
var
  AHeight,AWidth:integer;
  Rect,oldClipRect:TRect;
  ATop,ALeft,H,W:Integer;
  AText:string;
  TextJustify:Integer;
  APoint:TPoint;
begin
  with ACanvas do
  begin
    Lock;
    AHeight:=ARect.Bottom-ARect.Top;
    AWidth:=ARect.Right-ARect.Left;

    APoint:=TextSize2(AString,0,ACanvas.Font);
    W:=APoint.X;
    H:=APoint.Y;
 
    ATop:=ARect.Top;
    ALeft:=ARect.Left;
 
    If WordWrap then
      if W>(ARect.Right-ARect.Left) then
      begin //alors...
        W:=(ARect.Right-ARect.Left);
        H:=TextSize2(AString,W,ACanvas.Font).y;
      end;
 
    case VerticalAlign of
      alVBottom : ATop:=ARect.Bottom-H;
      alVCenter : ATop:=ARect.Top+((AHeight-H) div 2);
      alVTop    : ATop:=ARect.Top;
    end;
 
    case HorizontalAlign of
      alHLeft  : ALeft:=ARect.Left;
      alHCenter: ALeft:=ARect.Left+(AWidth-W) div 2;
      alHRight : ALeft:=ARect.Right-W;
    end;
 
    Rect:=Bounds(ALeft,ATop,W,H);
    IntersectRect(Rect,Rect,ARect);
    case TextJustification of
      JustLeft  : TextJustify:=DT_LEFT;
      JustCenter: TextJustify:=DT_CENTER;
      JustRight : TextJustify:=DT_RIGHT;
    end;

    DrawText(Handle,PChar(AString),-1,Rect,TextJustify or DT_NOPREFIX or DT_WORDBREAK );
    
    unlock;
  end;
end;
Function TextSize2(Text: string; AWidth: integer; Font: TFont = nil): TPoint;
var
  DC: HDC;
  X: Integer;
  Rect: TRect;
  C : TBitmap;
  WordWrapParams:integer;
begin
  C := TBitmap.create;
  if Font <> nil then  C.canvas.Font := Font;
 
  Rect.Left := 0;
  Rect.Top:=0;
  Rect.Right:=AWidth;
  Rect.Bottom:=0;
  DC := GetDC(0);
  C.Canvas.Handle := DC;
 
  WordWrapParams:=0;
  if AWidth<>0 then WordWrapParams:=DT_NOPREFIX or DT_WORDBREAK;

  DrawText(C.Canvas.Handle, PChar(Text), -1, Rect, WordWrapParams or (DT_EXPANDTABS or DT_CALCRECT));
  C.Canvas.Handle := 0;
  ReleaseDC(0, DC);
  Result.X:=Rect.Right-Rect.Left;
  Result.Y:=Rect.Bottom-Rect.Top;
  C.Free;
end;

function VariantToString(AVar: OleVariant): string;
var
  i: integer;
  V: olevariant;
begin
  Result := '';
  if VarType(AVar) = (varVariant or varByRef) then
     V := Variant(TVarData(AVar).VPointer^)
  else V := AVar;

  if VarType(V) = (varByte or varArray) then
      try
        for i:=VarArrayLowBound(V,1) to VarArrayHighBound(V,1) do
           Result := Result + Chr(Byte(V[i]));
      except;
      end
    else Result := V;
end;

function  GetLongPathName(FileName: string): string;
var
  long:cardinal;
  LongPath:array[0..max_path-1]of char;
begin
    long:=GetLongPathNameA(PChar(FileName),nil,0);
    if long>0 then
    begin
        GetLongPathNameA(PChar(FileName),LongPath,long);
        Result:=LongPath;
    end
    else showmessage('IncorrectPath');
end;

function DeleteFilesRegExp(DirName: string; regularExpression: string): LongInt;
var
  SearchRec :TSearchRec;
begin
    if RightStr(DirName,1) = '\' then
      DirName := LeftStr(DirName,Length(DirName)-1);

    Result := FindFirst(DirName+'\*.*', faAnyFile , SearchRec);
    while Result = 0 do
    begin
      if not(SearchRec.name[1]='.') then
      begin
       if (SearchRec.attr and faDirectory) <> 0 then
        begin
            DeleteFilesRegExp(DirName +'\' + SearchRec.name,regularExpression);
        end
        else
        begin
          if RegExpr.ExecRegExpr(regularExpression,LowerCase(DirName+'\'+SearchRec.name)) then
            try
              DeleteFile(DirName+'\'+SearchRec.name);
            except
            end;
        end;
      end; //if . ..
      Result := FindNext(SearchRec);
    end;
    FindClose(SearchRec);
end;

Function DelTree(DirName : string): LongInt;
var
  SearchRec :TSearchRec;
begin
    if RightStr(DirName,1) = '\' then
      DirName := LeftStr(DirName,Length(DirName)-1);

    Result := FindFirst(DirName+'\*.*', faAnyFile , SearchRec);
    while Result = 0 do
    begin
      if not(SearchRec.name[1]='.') then
      begin
       if (SearchRec.attr and faDirectory) <> 0 then
        begin
            DelTree(DirName +'\' + SearchRec.name);
        end
        else
        begin
          try
            DeleteFile(DirName+'\'+SearchRec.name);
          except
          end;
        end;
      end; //if . ..
      Result := FindNext(SearchRec);
    end;
    FindClose(SearchRec);

    try RmDir(DirName); except end;
end;

Function CopyTree(DirFrom : string; DirTo : string): LongInt;
var
  SearchRec :TSearchRec;
begin
    if RightStr(DirFrom,1) = '\' then
      DirFrom := LeftStr(DirFrom,Length(DirFrom)-1);
    if RightStr(DirTo,1) = '\' then
      DirTo := LeftStr(DirTo,Length(DirTo)-1);
    MakePath(DirTo);

    Result := FindFirst(DirFrom+'\*.*', faAnyFile , SearchRec);
    while Result = 0 do
    begin
      if not(SearchRec.name[1]='.') then
      begin
       if (SearchRec.attr and faDirectory) <> 0 then
        begin
            CopyTree(DirFrom +'\' + SearchRec.name,DirTo +'\' + SearchRec.name);
        end
        else
        begin
          try
            if FileExists(DirTo+'\'+SearchRec.name) then
              DeleteFile(DirTo+'\'+SearchRec.name);
            CopyFile(PChar(DirFrom+'\'+SearchRec.name),PChar(DirTo+'\'+SearchRec.name),False);
          except
          end;
        end;
      end; //if . ..
      Result := FindNext(SearchRec);
    end;
    FindClose(SearchRec);
end;

Function MoveTree(DirFrom : string; DirTo : string): LongInt;
var
  SearchRec :TSearchRec;
begin
    if RightStr(DirFrom,1) = '\' then
      DirFrom := LeftStr(DirFrom,Length(DirFrom)-1);
    if RightStr(DirTo,1) = '\' then
      DirTo := LeftStr(DirTo,Length(DirTo)-1);
    MakePath(DirTo);
    
    Result := FindFirst(DirFrom+'\*.*', faAnyFile , SearchRec);
    while Result = 0 do
    begin
      if not(SearchRec.name[1]='.') then
      begin
       if (SearchRec.attr and faDirectory) <> 0 then
        begin
            MoveTree(DirFrom +'\' + SearchRec.name,DirTo +'\' + SearchRec.name);
        end
        else
        begin
          try
            if FileExists(DirTo+'\'+SearchRec.name) then
              DeleteFile(DirTo+'\'+SearchRec.name);
            MoveFile(PChar(DirFrom+'\'+SearchRec.name),PChar(DirTo+'\'+SearchRec.name));
          except
          end;
        end;
      end; //if . ..
      Result := FindNext(SearchRec);
    end;
    FindClose(SearchRec);
end;

Function BitmapFlip(Const Vertical : Boolean;Const Horizontal : Boolean;var BitmapIn : TBitmap;out BitmapOut : TBitmap): Boolean;
Var
   DataIn : pColorData;
   DataOut : pColorData;
   inRow : Integer;
   inCol : Integer;
Begin
   Result := False;
   Try
     If BitmapIn.PixelFormat <> pf24bit Then Exit;
     With BitmapOut Do
     Begin
       Width := BitmapIn.Width;
       Height := BitmapIn.Height;
       PixelFormat := BitmapIn.PixelFormat;
     End;
     For inRow := 0 To BitmapIn.Height - 1 Do
     Begin
       DataIn := BitmapIn.Scanline[inRow];
       If Vertical Then
       Begin
         DataOut := BitmapOut.ScanLine
                    [BitmapIn.Height - 1 - inRow];
       End
       Else
       Begin
         DataOut := BitmapOut.ScanLine[inRow];
       End;
       If Horizontal Then
       Begin
         For inCol := 0 To BitmapIn.Width-1 Do
             DataOut[inCol] := DataIn
                    [BitmapIn.Width-1-inCol];
       End
       Else
       Begin
         For inCol := 0 To BitmapIn.Width-1 Do
             DataOut[inCol] := DataIn[inCol];
       End;
     End;
     Result := True;
   Except
   End;
End;

function ExtractAfterLastSlash(path: string): string;
var
  i: integer;
begin
  for i:=Length(path) downto 1 do
  begin
    if MidStr(path,i,1) = '/' then
    begin
      Result := MidStr(path,i+1,9999999);
      Exit;
    end;
  end;
end;

function ExtractBeforeLastSlash(path: string): string;
var
  i: integer;
begin
  for i:=Length(path) downto 1 do
  begin
    if MidStr(path,i,1) = '/' then
    begin
      Result := LeftStr(path,i-1);
      Exit;
    end;
  end;
end;

function GetLobbyRevision: integer;
var
  exe: string;
  n, Len: Cardinal;
  versionBuff: string;
  version: PChar;
  sl: TStringList;
begin
  Result := 99999;

  exe := Application.ExeName;
  n := GetFileVersionInfoSize(PChar(exe),n);
  SetLength(versionBuff,n);
  GetFileVersionInfo(PChar(exe),0,n,PChar(versionBuff));
  If VerQueryValue(PChar(versionBuff),PChar('StringFileInfo\040904E4\FileVersion'),Pointer(version),Len) Then
  Begin
    version := PChar(Trim(version)) ;
    If Length(version) > 0 Then
    Begin
      sl := TStringList.Create;
      ParseDelimited(sl,version,'.','');
      Result := StrToInt(sl[sl.Count-1]);
    End;
  End;
end;

procedure MakePath(Path: string);
var
  dirList: TStringList;
  dirTemp: string;
  i: integer;
begin
  dirList := TStringList.Create;

  ParseDelimited(dirList,Path,'\','');
  dirTemp := dirList[0];

  for i:=1 to dirList.Count-1 do
  begin
    dirTemp := dirTemp + '\' + dirList[i];
    if not DirectoryExists(dirTemp) then
      MkDir(dirTemp);
  end;
end;

function URLDecode(const S: string): string;
var
  Idx: Integer;   // loops thru chars in string
  Hex: string;    // string of hex characters
  Code: Integer;  // hex character code (-1 on error)
begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
      begin
        // % should be followed by two hex digits - exception otherwise
        if Idx <= Length(S) - 2 then
        begin
          // there are sufficient digits - try to decode hex digits
          Hex := S[Idx+1] + S[Idx+2];
          Code := SysUtils.StrToIntDef('$' + Hex, -1);
          Inc(Idx, 2);
        end
        else
          // insufficient digits - error
          Code := -1;
        // check for error and raise exception if found
        if Code = -1 then
          raise SysUtils.EConvertError.Create(
            'Invalid hex digit in URL'
          );
        // decoded OK - add character to result
        Result := Result + Chr(Code);
      end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
      else
        // All other characters pass thru unchanged
        Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
end;


function URLEncode(const S: string; const InQueryString: Boolean): string;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
      else
        Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;

function GetPerpertyInfo(Obj:TObject; propName: string): PPropInfo;
var
  PropList:PPropList;
  count,i,count2 : Integer;
  PT : PTypeData;
begin
  PT:=GetTypeData(Obj.ClassInfo);
  Count := PT.PropCount;
  GetMem(PropList,Count * SizeOf(PPropInfo));
  count2 := GetPropList(Obj.ClassInfo, tkAny, PropList);
  for i:=0 to count2 -1 do
    if LowerCase(Proplist[i].Name) = LowerCase(propName) then
    begin
      Result := Proplist[i];
      Exit;
    end;
end;

procedure SetProperty(Obj:TObject; propName: string; value: Variant);
var
  PropList:PPropList;
  count,i,count2 : Integer;
  PT : PTypeData;
begin
  PT:=GetTypeData(Obj.ClassInfo);
  Count := PT.PropCount;
  GetMem(PropList,Count * SizeOf(PPropInfo));
  count2 := GetPropList(Obj.ClassInfo, tkAny, PropList);
  for i:=0 to count2 -1 do
    if LowerCase(Proplist[i].Name) = LowerCase(propName) then
    begin
      case Proplist[i].PropType^.Kind of
        tkInteger :   SetOrdProp(Obj,Proplist[i].Name,Integer(value));
        tkString,tkLString :    SetStrProp(Obj,Proplist[i].Name,String(value));
        tkWString :   SetStrProp(Obj,Proplist[i].Name,WideString(value));
        tkFloat :     SetFloatProp(Obj,Proplist[i].Name,Extended(value));
        tkSet : SetSetProp(Obj,Proplist[i].Name,String(value));
        tkEnumeration :
          if (GetEnumName(Proplist[i].PropType^,0) = 'False') and (GetEnumName(Proplist[i].PropType^,1) = 'True') then
            if Boolean(value) then
              SetEnumProp(Obj,Proplist[i].Name,'True')
            else
              SetEnumProp(Obj,Proplist[i].Name,'False')
          else
            SetEnumProp(Obj,Proplist[i].Name,String(value));
      end;
      Exit;
    end;
end;

procedure GetEnumPropertyList(Obj:TObject; name : string; enumList : TStringList);
var
  PropList:PPropList;
  count,i,j,count2 : Integer;
  PT : PTypeData;
  v: ^Variant;
  canAdd: boolean;
  typeStr: string;
  s: string;
  bp: PPTypeInfo;
  tmpStr: string;
begin
  enumList.Clear;

  PT:=GetTypeData(Obj.ClassInfo);
  Count := PT.PropCount;
  GetMem(PropList,Count * SizeOf(PPropInfo));
  count2 := GetPropList(Obj.ClassInfo, tkAny, PropList);
  for i:=0 to count2 -1 do
  begin
    if (Proplist[i].Name = name) and (Proplist[i].PropType^.Kind = tkEnumeration) then
    begin
      for j:=Max(0,GetTypeData(Proplist[i].PropType^).MinValue) to Min(50,GetTypeData(Proplist[i].PropType^).MaxValue) do
      begin
        tmpStr := GetEnumName(Proplist[i].PropType^,j);
        if enumList.IndexOf(tmpStr) > -1 then
          Break;
        enumList.Add(tmpStr);
      end;
    end;
    if (Proplist[i].Name = name) and (Proplist[i].PropType^.Kind = tkSet) then
    begin
      bp := GetTypeData(Proplist[i].PropType^).CompType;
      for j:=GetTypeData(bp^).MinValue to GetTypeData(bp^).MaxValue do
        enumList.Add(GetEnumName(bp^,j));
    end;
  end;
end;

procedure GetProperties(Obj:TObject; nameList : TStrings; valueList : TList; typeList: TStringList);
var
  PropList:PPropList;
  count,i,count2 : Integer;
  PT : PTypeData;
  v: ^Variant;
  o: TObject;
  canAdd: boolean;
  typeStr: string;
  m: TMemo;
begin
  nameList.Clear;
  valueList.Clear;
  typeList.Clear;
  canAdd := True;

  PT:=GetTypeData(Obj.ClassInfo);
  Count := PT.PropCount;
  GetMem(PropList,Count * SizeOf(PPropInfo));
  count2 := GetPropList(Obj.ClassInfo, tkAny, PropList);
  for i:=0 to count2 -1 do
  begin
    try
    if canAdd then
      New(v);
    canAdd := True;
    case Proplist[i].PropType^.Kind of
      tkInteger :
      begin
        v^ := Variant(GetOrdProp(Obj,Proplist[i].Name));
        typeStr := Proplist[i].PropType^.Name;
      end;
      tkMethod :
      begin
        v^ := Variant(Proplist[i].PropType^.Name);
        typeStr := 'tkMethod';
      end;
      tkString,tkLString :
      begin
        v^ := Variant(GetStrProp(Obj,Proplist[i].Name));
        typeStr := 'tkString';
      end;
      tkWString :
      begin
        v^ := Variant(GetWideStrProp(Obj,Proplist[i].Name));
        typeStr := 'tkWString';
      end;
      tkFloat :
      begin
        v^ := Variant(GetFloatProp(Obj,Proplist[i].Name));
        typeStr := 'tkFloat';
      end;
      tkEnumeration:
      begin
        v^ := Variant(GetEnumProp(Obj,Proplist[i].Name));
        typeStr := 'tkEnumeration'
      end;
      tkInterface,tkRecord,tkClass:
      begin
        o := GetObjectProp(Obj,Proplist[i].Name,TObject);
        if o = nil then
          canAdd := False;
        typeStr := 'tkClass';
      end;
      tkSet:
      begin
        v^ := Variant(GetSetProp(Obj,Proplist[i].Name));
        typeStr := 'tkSet';
      end;
    else
      canAdd := False;
    end;
    except
      canAdd := False;
    end;
    if canAdd then
    begin
      nameList.Add(Proplist[i].Name);
      if Proplist[i].PropType^.Kind = tkClass then
        valueList.Add(o)
      else
        valueList.Add(v);
      typeList.Add(typeStr);
    end;
  end;
end;

function StringNChar(c: char; n: integer): string;
begin
  Result := '';
  while n > 0 do
  begin
    Result := Result + c;
    Dec(n);
  end;
end;

procedure ShowAndSetFocus(c: TWinControl; forceShow: boolean = False);  // ShowAndSetFocus
var
  p: TWinControl;
  controlList: TList;
  i: integer;
begin
  controlList := TList.Create;

  p := c.Parent;
  while p <> nil do
  begin
    controlList.Add(p);
    p := p.Parent;
  end;

  for i:=controlList.Count-1 downto 0 do
    if (TWinControl(controlList[i]).ClassType = TTabSheet) then
      TTabSheet(controlList[i]).PageControl.ActivePage := TTabSheet(controlList[i])
    else if (TWinControl(controlList[i]).ClassType = TSpTBXTabSheet) then
      TSpTBXTabSheet(controlList[i]).TabControl.ActivePage := TSpTBXTabSheet(controlList[i])
    else if (TWinControl(controlList[i]) is TCustomForm) and ((Screen.ActiveForm <> nil) or (not TCustomForm(controlList[i]).Visible or forceShow or (Screen.ActiveForm.Handle = GetForegroundWindow))) then
    begin
      TCustomForm(controlList[i]).Show;
      while not TCustomForm(controlList[i]).Visible do;
    end;

  try
    c.SetFocus;
  except
  end;
end;

function PackedShortString(Value: PShortstring; 
  var NextField{: Pointer}): PShortString; overload;
begin
  Result := Value;
  PShortString(NextField) := Value;
  Inc(PChar(NextField), SizeOf(Result^[0]) + Length(Result^));
end;  

function PackedShortString(var NextField{: Pointer}): PShortString; overload;
begin
  Result := PShortString(NextField);
  Inc(PChar(NextField), SizeOf(Result^[0]) + Length(Result^));
end;  

function GetMethodSignature(Event: PPropInfo): TMethodSignature;
type
  PParamListRecord = ^TParamListRecord;
  TParamListRecord = packed record 
    Flags: TParamFlags;
    ParamName: {packed} ShortString; // Really string[Length(ParamName)]
    TypeName:  {packed} ShortString; // Really string[Length(TypeName)]
  end;
var
  EventData: PTypeData;
  i: integer;
  MethodParam: PMethodParam;
  ParamListRecord: PParamListRecord;
begin
  Assert(Assigned(Event) and Assigned(Event.PropType));
  Assert(Event.PropType^.Kind = tkMethod);
  EventData := GetTypeData(Event.PropType^);
  Result.MethodKind := EventData.MethodKind;
  Result.ParamCount := EventData.ParamCount;
  SetLength(Result.ParamList, Result.ParamCount);
  ParamListRecord := @EventData.ParamList;
  for i := 0 to Result.ParamCount-1 do
  begin
    MethodParam := @Result.ParamList[i];
    MethodParam.Flags     := ParamListRecord.Flags;
    MethodParam.ParamName := PackedShortString(
      @ParamListRecord.ParamName, ParamListRecord);
    MethodParam.TypeName  := PackedShortString(ParamListRecord);
  end;  
  Result.ResultType := PackedShortString(ParamListRecord);
end;

function decrypt_xor(chaine:string;key:string):string;
var
  i,j:integer;
  s:string;
begin
  s := '';
  for i:=0 to (length(chaine) div 2)-1 do
    s := s + char(StrToInt('$'+MidStr(chaine,1+i*2,2)));
  chaine := s;
  s:='';
  j:=1;
  for i:=1 to length(chaine) do
  begin
    if j>length(key) then j:=1;
    s:=s+char(integer(ord(chaine[i])) xor integer(ord(key[j])));
    j:=j+1;
  end;
  Result:=s;
end;

function crypt_xor(chaine:string;key:string):string;
var
  i,j:integer;
  s:string;
begin
  s:='';
  j:=1;
  for i:=1 to length(chaine) do
  begin
    if j>length(key) then j:=1;
    s:=s+IntToHex(integer(ord(chaine[i])) xor integer(ord(key[j])),2);
    j:=j+1;
  end;
  Result:=s;
end;

procedure TryToAddLog(f: TFileStream; Line: string);
begin
  if f = nil then Exit;

  try
    Line := Line + EOL;
    f.Write(Line[1], Length(Line));
  except
  end;

end;

function OpenLog(FileName: string): TFileStream;
var
  fh: Integer; // file handle
begin
  Result := nil;

  try
    if not FileExists(FileName) then
    begin
      fh := FileCreate(FileName);
      if fh = -1 then Exit;
      FileClose(fh);
    end;

    Result := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite);
    Result.Position := Result.Size;
    TryToAddLog(Result, '');
    TryToAddLog(Result, '');
    TryToAddLog(Result, '----------------------------------------------------');
    TryToAddLog(Result, 'Logging started on ' + FormatDateTime('ddd mmm dd hh:nn:ss yyyy', Now));
    TryToAddLog(Result, '----------------------------------------------------');

  except
    Result := nil;
    Exit;
  end;
end;

function CallFunction(p: TMethod;  paramList: TList): Integer;
var
  i: Integer;
  pCount: Integer;
  pParams: array of Pointer;
  ret: Integer;
begin
  SetLength(pParams,paramList.Count);
  pCount := paramList.Count;
  for i:=0 to pCount-1 do
    pParams[i] := paramList[i];

  asm
    cmp pCount, 1
    JB @exec
    JE @One
    cmp pCount, 2
    JE @two
    @ThreeUp:
      CLD
      mov ecx, pCount
      sub ecx, 2
      mov edx, 4
      add edx, 4
    @loop:
      mov eax, [pParams]
      mov eax, [eax]+edx
      test eax, eax
      jz @nullP
      mov eax, [eax]
    @nullP:
      push eax
      add edx, 4
      Loop @loop
    @Two:
      mov ecx, [pParams]
      mov ecx, [ecx]+4
      test ecx, ecx
      jz @One
      mov ecx, [ecx]
    @One:
      mov edx, [pParams]
      mov edx, [edx]
      test edx, edx
      jz @exec
      mov edx, [edx]
    @exec:
      mov eax, p.Data
      test eax, eax
      je @1
      jne @call
      @1:
        mov eax, edx
        mov edx, ecx
        pop ecx
        jmp @call
      @call:
        call P.Code
        mov [ret], eax
  end;
  Result := ret;
end;

function getLanguageNameIgnoreCase(langcode:string):string;
begin
  if LowerCase(langcode)=LowerCase('aa') then Result:='Afar' else
  if LowerCase(langcode)=LowerCase('ab') then Result:='Abkhazian' else
  if LowerCase(langcode)=LowerCase('ae') then Result:='Avestan' else
  if LowerCase(langcode)=LowerCase('af') then Result:='Afrikaans' else
  if LowerCase(langcode)=LowerCase('ak') then Result:='Akan' else
  if LowerCase(langcode)=LowerCase('am') then Result:='Amharic' else
  if LowerCase(langcode)=LowerCase('an') then Result:='Aragonese' else
  if LowerCase(langcode)=LowerCase('ar') then Result:='Arabic' else
  if LowerCase(langcode)=LowerCase('as') then Result:='Assamese' else
  if LowerCase(langcode)=LowerCase('av') then Result:='Avaric' else
  if LowerCase(langcode)=LowerCase('ay') then Result:='Aymara' else
  if LowerCase(langcode)=LowerCase('az') then Result:='Azerbaijani' else
  if LowerCase(langcode)=LowerCase('ba') then Result:='Bashkir' else
  if LowerCase(langcode)=LowerCase('be') then Result:='Belarusian' else
  if LowerCase(langcode)=LowerCase('bg') then Result:='Bulgarian' else
  if LowerCase(langcode)=LowerCase('bh') then Result:='Bihari' else
  if LowerCase(langcode)=LowerCase('bi') then Result:='Bislama' else
  if LowerCase(langcode)=LowerCase('bm') then Result:='Bambara' else
  if LowerCase(langcode)=LowerCase('bn') then Result:='Bengali' else
  if LowerCase(langcode)=LowerCase('bo') then Result:='Tibetan' else
  if LowerCase(langcode)=LowerCase('br') then Result:='Breton' else
  if LowerCase(langcode)=LowerCase('bs') then Result:='Bosnian' else
  if LowerCase(langcode)=LowerCase('ca') then Result:='Catalan' else
  if LowerCase(langcode)=LowerCase('ce') then Result:='Chechen' else
  if LowerCase(langcode)=LowerCase('ch') then Result:='Chamorro' else
  if LowerCase(langcode)=LowerCase('co') then Result:='Corsican' else
  if LowerCase(langcode)=LowerCase('cr') then Result:='Cree' else
  if LowerCase(langcode)=LowerCase('cs') then Result:='Czech' else
  if LowerCase(langcode)=LowerCase('cv') then Result:='Chuvash' else
  if LowerCase(langcode)=LowerCase('cy') then Result:='Welsh' else
  if LowerCase(langcode)=LowerCase('da') then Result:='Danish' else
  if LowerCase(langcode)=LowerCase('de') then Result:='German' else
  if LowerCase(langcode)=LowerCase('de_AT') then Result:='Austrian German' else
  if LowerCase(langcode)=LowerCase('de_CH') then Result:='Swiss German' else
  if LowerCase(langcode)=LowerCase('dv') then Result:='Divehi' else
  if LowerCase(langcode)=LowerCase('dz') then Result:='Dzongkha' else
  if LowerCase(langcode)=LowerCase('ee') then Result:='Ewe' else
  if LowerCase(langcode)=LowerCase('el') then Result:='Greek' else
  if LowerCase(langcode)=LowerCase('en') then Result:='English' else
  if LowerCase(langcode)=LowerCase('en_AU') then Result:='Australian English' else
  if LowerCase(langcode)=LowerCase('en_CA') then Result:='Canadian English' else
  if LowerCase(langcode)=LowerCase('en_GB') then Result:='British English' else
  if LowerCase(langcode)=LowerCase('en_US') then Result:='American English' else
  if LowerCase(langcode)=LowerCase('eo') then Result:='Esperanto' else
  if LowerCase(langcode)=LowerCase('es') then Result:='Spanish' else
  if LowerCase(langcode)=LowerCase('et') then Result:='Estonian' else
  if LowerCase(langcode)=LowerCase('eu') then Result:='Basque' else
  if LowerCase(langcode)=LowerCase('fa') then Result:='Persian' else
  if LowerCase(langcode)=LowerCase('ff') then Result:='Fulah' else
  if LowerCase(langcode)=LowerCase('fi') then Result:='Finnish' else
  if LowerCase(langcode)=LowerCase('fj') then Result:='Fijian' else
  if LowerCase(langcode)=LowerCase('fo') then Result:='Faroese' else
  if LowerCase(langcode)=LowerCase('fr') then Result:='French' else
  if LowerCase(langcode)=LowerCase('fr_BE') then Result:='Walloon' else
  if LowerCase(langcode)=LowerCase('fy') then Result:='Frisian' else
  if LowerCase(langcode)=LowerCase('ga') then Result:='Irish' else
  if LowerCase(langcode)=LowerCase('gd') then Result:='Gaelic' else
  if LowerCase(langcode)=LowerCase('gl') then Result:='Gallegan' else
  if LowerCase(langcode)=LowerCase('gn') then Result:='Guarani' else
  if LowerCase(langcode)=LowerCase('gu') then Result:='Gujarati' else
  if LowerCase(langcode)=LowerCase('gv') then Result:='Manx' else
  if LowerCase(langcode)=LowerCase('ha') then Result:='Hausa' else
  if LowerCase(langcode)=LowerCase('he') then Result:='Hebrew' else
  if LowerCase(langcode)=LowerCase('hi') then Result:='Hindi' else
  if LowerCase(langcode)=LowerCase('ho') then Result:='Hiri Motu' else
  if LowerCase(langcode)=LowerCase('hr') then Result:='Croatian' else
  if LowerCase(langcode)=LowerCase('ht') then Result:='Haitian' else
  if LowerCase(langcode)=LowerCase('hu') then Result:='Hungarian' else
  if LowerCase(langcode)=LowerCase('hy') then Result:='Armenian' else
  if LowerCase(langcode)=LowerCase('hz') then Result:='Herero' else
  if LowerCase(langcode)=LowerCase('ia') then Result:='Interlingua' else
  if LowerCase(langcode)=LowerCase('id') then Result:='Indonesian' else
  if LowerCase(langcode)=LowerCase('ie') then Result:='Interlingue' else
  if LowerCase(langcode)=LowerCase('ig') then Result:='Igbo' else
  if LowerCase(langcode)=LowerCase('ii') then Result:='Sichuan Yi' else
  if LowerCase(langcode)=LowerCase('ik') then Result:='Inupiaq' else
  if LowerCase(langcode)=LowerCase('io') then Result:='Ido' else
  if LowerCase(langcode)=LowerCase('is') then Result:='Icelandic' else
  if LowerCase(langcode)=LowerCase('it') then Result:='Italian' else
  if LowerCase(langcode)=LowerCase('iu') then Result:='Inuktitut' else
  if LowerCase(langcode)=LowerCase('ja') then Result:='Japanese' else
  if LowerCase(langcode)=LowerCase('jv') then Result:='Javanese' else
  if LowerCase(langcode)=LowerCase('ka') then Result:='Georgian' else
  if LowerCase(langcode)=LowerCase('kg') then Result:='Kongo' else
  if LowerCase(langcode)=LowerCase('ki') then Result:='Kikuyu' else
  if LowerCase(langcode)=LowerCase('kj') then Result:='Kuanyama' else
  if LowerCase(langcode)=LowerCase('kk') then Result:='Kazakh' else
  if LowerCase(langcode)=LowerCase('kl') then Result:='Greenlandic' else
  if LowerCase(langcode)=LowerCase('km') then Result:='Khmer' else
  if LowerCase(langcode)=LowerCase('kn') then Result:='Kannada' else
  if LowerCase(langcode)=LowerCase('ko') then Result:='Korean' else
  if LowerCase(langcode)=LowerCase('kr') then Result:='Kanuri' else
  if LowerCase(langcode)=LowerCase('ks') then Result:='Kashmiri' else
  if LowerCase(langcode)=LowerCase('ku') then Result:='Kurdish' else
  if LowerCase(langcode)=LowerCase('kw') then Result:='Cornish' else
  if LowerCase(langcode)=LowerCase('kv') then Result:='Komi' else
  if LowerCase(langcode)=LowerCase('ky') then Result:='Kirghiz' else
  if LowerCase(langcode)=LowerCase('la') then Result:='Latin' else
  if LowerCase(langcode)=LowerCase('lb') then Result:='Luxembourgish' else
  if LowerCase(langcode)=LowerCase('lg') then Result:='Ganda' else
  if LowerCase(langcode)=LowerCase('li') then Result:='Limburgan' else
  if LowerCase(langcode)=LowerCase('ln') then Result:='Lingala' else
  if LowerCase(langcode)=LowerCase('lo') then Result:='Lao' else
  if LowerCase(langcode)=LowerCase('lt') then Result:='Lithuanian' else
  if LowerCase(langcode)=LowerCase('lu') then Result:='Luba-Katanga' else
  if LowerCase(langcode)=LowerCase('lv') then Result:='Latvian' else
  if LowerCase(langcode)=LowerCase('mg') then Result:='Malagasy' else
  if LowerCase(langcode)=LowerCase('mh') then Result:='Marshallese' else
  if LowerCase(langcode)=LowerCase('mi') then Result:='Maori' else
  if LowerCase(langcode)=LowerCase('mk') then Result:='Macedonian' else
  if LowerCase(langcode)=LowerCase('ml') then Result:='Malayalam' else
  if LowerCase(langcode)=LowerCase('mn') then Result:='Mongolian' else
  if LowerCase(langcode)=LowerCase('mo') then Result:='Moldavian' else
  if LowerCase(langcode)=LowerCase('mr') then Result:='Marathi' else
  if LowerCase(langcode)=LowerCase('ms') then Result:='Malay' else
  if LowerCase(langcode)=LowerCase('mt') then Result:='Maltese' else
  if LowerCase(langcode)=LowerCase('my') then Result:='Burmese' else
  if LowerCase(langcode)=LowerCase('na') then Result:='Nauru' else
  if LowerCase(langcode)=LowerCase('nb') then Result:='Norwegian Bokmaal' else
  if LowerCase(langcode)=LowerCase('nd') then Result:='Ndebele, North' else
  if LowerCase(langcode)=LowerCase('ne') then Result:='Nepali' else
  if LowerCase(langcode)=LowerCase('ng') then Result:='Ndonga' else
  if LowerCase(langcode)=LowerCase('nl') then Result:='Dutch' else
  if LowerCase(langcode)=LowerCase('nl_BE') then Result:='Flemish' else
  if LowerCase(langcode)=LowerCase('nn') then Result:='Norwegian Nynorsk' else
  if LowerCase(langcode)=LowerCase('no') then Result:='Norwegian' else
  if LowerCase(langcode)=LowerCase('nr') then Result:='Ndebele, South' else
  if LowerCase(langcode)=LowerCase('nv') then Result:='Navajo' else
  if LowerCase(langcode)=LowerCase('ny') then Result:='Chichewa' else
  if LowerCase(langcode)=LowerCase('oc') then Result:='Occitan' else
  if LowerCase(langcode)=LowerCase('oj') then Result:='Ojibwa' else
  if LowerCase(langcode)=LowerCase('om') then Result:='Oromo' else
  if LowerCase(langcode)=LowerCase('or') then Result:='Oriya' else
  if LowerCase(langcode)=LowerCase('os') then Result:='Ossetian' else
  if LowerCase(langcode)=LowerCase('pa') then Result:='Panjabi' else
  if LowerCase(langcode)=LowerCase('pi') then Result:='Pali' else
  if LowerCase(langcode)=LowerCase('pl') then Result:='Polish' else
  if LowerCase(langcode)=LowerCase('ps') then Result:='Pushto' else
  if LowerCase(langcode)=LowerCase('pt') then Result:='Portuguese' else
  if LowerCase(langcode)=LowerCase('pt_BR') then Result:='Brazilian Portuguese' else
  if LowerCase(langcode)=LowerCase('qu') then Result:='Quechua' else
  if LowerCase(langcode)=LowerCase('rm') then Result:='Raeto-Romance' else
  if LowerCase(langcode)=LowerCase('rn') then Result:='Rundi' else
  if LowerCase(langcode)=LowerCase('ro') then Result:='Romanian' else
  if LowerCase(langcode)=LowerCase('ru') then Result:='Russian' else
  if LowerCase(langcode)=LowerCase('rw') then Result:='Kinyarwanda' else
  if LowerCase(langcode)=LowerCase('sa') then Result:='Sanskrit' else
  if LowerCase(langcode)=LowerCase('sc') then Result:='Sardinian' else
  if LowerCase(langcode)=LowerCase('sd') then Result:='Sindhi' else
  if LowerCase(langcode)=LowerCase('se') then Result:='Northern Sami' else
  if LowerCase(langcode)=LowerCase('sg') then Result:='Sango' else
  if LowerCase(langcode)=LowerCase('si') then Result:='Sinhalese' else
  if LowerCase(langcode)=LowerCase('sk') then Result:='Slovak' else
  if LowerCase(langcode)=LowerCase('sl') then Result:='Slovenian' else
  if LowerCase(langcode)=LowerCase('sm') then Result:='Samoan' else
  if LowerCase(langcode)=LowerCase('sn') then Result:='Shona' else
  if LowerCase(langcode)=LowerCase('so') then Result:='Somali' else
  if LowerCase(langcode)=LowerCase('sq') then Result:='Albanian' else
  if LowerCase(langcode)=LowerCase('sr') then Result:='Serbian' else
  if LowerCase(langcode)=LowerCase('ss') then Result:='Swati' else
  if LowerCase(langcode)=LowerCase('st') then Result:='Sotho, Southern' else
  if LowerCase(langcode)=LowerCase('su') then Result:='Sundanese' else
  if LowerCase(langcode)=LowerCase('sv') then Result:='Swedish' else
  if LowerCase(langcode)=LowerCase('sw') then Result:='Swahili' else
  if LowerCase(langcode)=LowerCase('ta') then Result:='Tamil' else
  if LowerCase(langcode)=LowerCase('te') then Result:='Telugu' else
  if LowerCase(langcode)=LowerCase('tg') then Result:='Tajik' else
  if LowerCase(langcode)=LowerCase('th') then Result:='Thai' else
  if LowerCase(langcode)=LowerCase('ti') then Result:='Tigrinya' else
  if LowerCase(langcode)=LowerCase('tk') then Result:='Turkmen' else
  if LowerCase(langcode)=LowerCase('tl') then Result:='Tagalog' else
  if LowerCase(langcode)=LowerCase('tn') then Result:='Tswana' else
  if LowerCase(langcode)=LowerCase('to') then Result:='Tonga' else
  if LowerCase(langcode)=LowerCase('tr') then Result:='Turkish' else
  if LowerCase(langcode)=LowerCase('ts') then Result:='Tsonga' else
  if LowerCase(langcode)=LowerCase('tt') then Result:='Tatar' else
  if LowerCase(langcode)=LowerCase('tw') then Result:='Twi' else
  if LowerCase(langcode)=LowerCase('ty') then Result:='Tahitian' else
  if LowerCase(langcode)=LowerCase('ug') then Result:='Uighur' else
  if LowerCase(langcode)=LowerCase('uk') then Result:='Ukrainian' else
  if LowerCase(langcode)=LowerCase('ur') then Result:='Urdu' else
  if LowerCase(langcode)=LowerCase('uz') then Result:='Uzbek' else
  if LowerCase(langcode)=LowerCase('ve') then Result:='Venda' else
  if LowerCase(langcode)=LowerCase('vi') then Result:='Vietnamese' else
  if LowerCase(langcode)=LowerCase('vo') then Result:='Volapuk' else
  if LowerCase(langcode)=LowerCase('wa') then Result:='Walloon' else
  if LowerCase(langcode)=LowerCase('wo') then Result:='Wolof' else
  if LowerCase(langcode)=LowerCase('xh') then Result:='Xhosa' else
  if LowerCase(langcode)=LowerCase('yi') then Result:='Yiddish' else
  if LowerCase(langcode)=LowerCase('yo') then Result:='Yoruba' else
  if LowerCase(langcode)=LowerCase('za') then Result:='Zhuang' else
  if LowerCase(langcode)=LowerCase('zh') then Result:='Chinese' else
  if LowerCase(langcode)=LowerCase('zu') then Result:='Zulu' else
  Result:='';
end;

function GetWinVersion: string;
var
   osVerInfo: TOSVersionInfo;
   majorVersion, minorVersion: Integer;
begin
   Result := 'Unknown';
   osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo) ;
   if GetVersionEx(osVerInfo) then
   begin
     minorVersion := osVerInfo.dwMinorVersion;
     majorVersion := osVerInfo.dwMajorVersion;
     case osVerInfo.dwPlatformId of
       VER_PLATFORM_WIN32_NT:
       begin
         if majorVersion <= 4 then
           Result := 'NT'
         else if (majorVersion = 5) and (minorVersion = 0) then
           Result := '2k'
         else if (majorVersion = 5) and (minorVersion = 1) then
           Result := 'XP'
         else if (majorVersion = 6) and (minorVersion = 0) then
           Result := 'Vista'
         else if (majorVersion = 6) and (minorVersion = 1) then
           Result := 'Seven';
       end;
       VER_PLATFORM_WIN32_WINDOWS:
       begin
         if (majorVersion = 4) and (minorVersion = 0) then
           Result := '95'
         else if (majorVersion = 4) and (minorVersion = 10) then
         begin
           if osVerInfo.szCSDVersion[1] = 'A' then
             Result := '98SE'
           else
             Result := '98';
         end
         else if (majorVersion = 4) and (minorVersion = 90) then
           Result := 'ME'
         else
           Result := 'Unknown';
       end;
     end;
   end;
end;

function GetControlForm(control : TWinControl): TCustomForm;
var
  c : TWinControl;
begin
  if control = nil then
  begin
    Result := nil;
    Exit;
  end;
  
  c := control;

  while c.Parent <> nil do
  begin
    c := c.Parent;
  end;

  Result := TForm(c);
end;

function LoadPictureWithDevIL(fileName: string; pict: TPicture): boolean;
var
  tmp,tmp2: TBitmap;
begin
  Result := False;
  ilDisable(IL_ORIGIN_SET);
  checkDevILErrors('ilDisable');
  if ilLoadImage(PChar(fileName)) = IL_TRUE then
  begin
    checkDevILErrors('ilLoadImage');
    tmp := TBitmap.Create;

    tmp.Width := ilGetInteger(IL_IMAGE_WIDTH);
    tmp.Height := ilGetInteger(IL_IMAGE_HEIGHT);

    tmp.PixelFormat := pf24bit;

    ilCopyPixels(0,0,0,tmp.Width,tmp.Height,1,IL_BGR,IL_UNSIGNED_BYTE,tmp.ScanLine[tmp.Height-1]);
    checkDevILErrors('ilCopyPixels');

    if LowerCase(RightStr(fileName,3)) <> 'bmp' then
    begin
      tmp2 := TBitmap.Create;
      BitmapFlip(True,False,tmp,tmp2);
      pict.Assign(tmp2);
      tmp2.FreeImage;
      tmp2.Free;
    end
    else
      pict.Assign(tmp);

    tmp.FreeImage;
    tmp.Free;
    Result := True;
  end
  else
    checkDevILErrors('ilLoadImage');

end;

function LoadPictureWithDevIL(fileName: string; bmp: TBitmap): boolean;
var
  tmp: TBitmap;
begin
  Result := False;
  ilDisable(IL_ORIGIN_SET);
  if ilLoadImage(PChar(fileName)) = IL_TRUE then
  begin
    checkDevILErrors('ilLoadImage');

    tmp := TBitmap.Create;
    
    tmp.Width := ilGetInteger(IL_IMAGE_WIDTH);
    tmp.Height := ilGetInteger(IL_IMAGE_HEIGHT);

    tmp.PixelFormat := pf24bit;

    ilCopyPixels(0,0,0,tmp.Width,tmp.Height,1,IL_BGR,IL_BYTE,tmp.ScanLine[tmp.Height-1]);
    checkDevILErrors('ilCopyPixels');

    if LowerCase(RightStr(fileName,3)) <> 'bmp' then
      BitmapFlip(True,False,tmp,bmp)
    else
      bmp.Assign(tmp);

    tmp.FreeImage;
    tmp.Free;

    Result := True;
  end
  else
    checkDevILErrors('ilLoadImage');
end;

function SendMail(const Subject, Body, FileName,
                  SenderName, SenderEMail,
                  RecipientName, RecipientEMail: string): Integer;
var
  Msg: TMapiMessage;
  lpSender, lpRecipient: TMapiRecipDesc;
  FileAttach: TMapiFileDesc;

  SM: TFNMapiSendMail;
  MAPIModule: HModule;
begin
  FillChar(Msg, SizeOf(Msg), 0);
  with Msg do
  begin
    if (Subject <> '') then
      lpszSubject := PChar(Subject);

    if (Body <> '') then
      lpszNoteText := PChar(Body);

    if (SenderEmail <> '') then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      if (SenderName = '') then
        lpSender.lpszName := PChar(SenderEMail)
      else
        lpSender.lpszName := PChar(SenderName);
      lpSender.lpszAddress := PChar(SenderEmail);
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    if (RecipientEmail <> '') then
    begin
      lpRecipient.ulRecipClass := MAPI_TO;
      if (RecipientName = '') then
        lpRecipient.lpszName := PChar(RecipientEMail)
      else
        lpRecipient.lpszName := PChar(RecipientName);
      lpRecipient.lpszAddress := PChar(RecipientEmail);
      lpRecipient.ulReserved := 0;
      lpRecipient.ulEIDSize := 0;
      lpRecipient.lpEntryID := nil;
      nRecipCount := 1;
      lpRecips := @lpRecipient;
    end
    else
      lpRecips := nil;

    if (FileName = '') then
    begin
      nFileCount := 0;
      lpFiles := nil;
    end
    else
    begin
      FillChar(FileAttach, SizeOf(FileAttach), 0);
      FileAttach.nPosition := Cardinal($FFFFFFFF);
      FileAttach.lpszPathName := PChar(FileName);

      nFileCount := 1;
      lpFiles := @FileAttach;
    end;
  end;

  Result := MapiSendMail(0, Application.Handle,Msg, MAPI_DIALOG, 0);

  if Result <> SUCCESS_SUCCESS then
    MessageDlg('Error sending mail (' + IntToStr(Result) + ').', mtError,[mbOK], 0);
end;

function CompareBoolean(b1: Boolean;b2: Boolean): Integer;
begin
  if b1 = b2 then
    Result := 0
  else if b1 and not b2 then
    Result := 1
  else
    Result := -1;
end;

function CompareArgs(const Args1: array of const; const Args2: array of const; idx: integer=0): Integer;
begin
  case Args1[idx].VType of
    System.vtBoolean:
    begin
      if Args2[idx].VType <> System.vtBoolean then
        raise Exception.Create('CompareArgs args mismatch: '+IntToStr(idx));
      Result := CompareBoolean(Args1[idx].VBoolean,Args2[idx].VBoolean);
      if (Result = 0) and (idx <> High(Args1)) then
        Result := CompareArgs(Args1,Args2,idx+1);
    end;
    System.vtInteger:
    begin
      if Args2[idx].VType <> System.vtInteger then
        raise Exception.Create('CompareArgs args mismatch: '+IntToStr(idx));
      Result := CompareValue(Args1[idx].VInteger,Args2[idx].VInteger);
      if (Result = 0) and (idx <> High(Args1)) then
        Result := CompareArgs(Args1,Args2,idx+1);
    end;
    System.vtExtended:
    begin
      if Args2[idx].VType <> System.vtExtended then
        raise Exception.Create('CompareArgs args mismatch: '+IntToStr(idx));
      Result := CompareValue(Extended(Args1[idx].VExtended^),Extended(Args2[idx].VExtended^));
      if (Result = 0) and (idx <> High(Args1)) then
        Result := CompareArgs(Args1,Args2,idx+1);
    end;
    System.vtAnsiString:
    begin
      if Args2[idx].VType <> System.vtAnsiString then
        raise Exception.Create('CompareArgs args mismatch: '+IntToStr(idx));
      Result := AnsiCompareStr(AnsiString(Args1[idx].VAnsiString),AnsiString(Args2[idx].VAnsiString));
      if (Result = 0) and (idx <> High(Args1)) then
        Result := CompareArgs(Args1,Args2,idx+1);
    end;
    System.vtWideString:
    begin
      if Args2[idx].VType <> System.vtWideString then
        raise Exception.Create('CompareArgs args mismatch: '+IntToStr(idx));
      Result := WideCompareStr(WideString(Args1[idx].VWideString),WideString(Args2[idx].VWideString));
      if (Result = 0) and (idx <> High(Args1)) then
        Result := CompareArgs(Args1,Args2,idx+1);
    end;
    System.vtPChar:
    begin
      if Args2[idx].VType <> System.vtPChar then
        raise Exception.Create('CompareArgs args mismatch: '+IntToStr(idx));
      Result := AnsiCompareStr(Args1[idx].VPChar^,Args2[idx].VPChar^);
      if (Result = 0) and (idx <> High(Args1)) then
        Result := CompareArgs(Args1,Args2,idx+1);
    end;
    System.vtPWideChar:
    begin
      if Args2[idx].VType <> System.vtPWideChar then
        raise Exception.Create('CompareArgs args mismatch: '+IntToStr(idx));
      Result := WideCompareStr(Args1[idx].VPWideChar^,Args2[idx].VPWideChar^);
      if (Result = 0) and (idx <> High(Args1)) then
        Result := CompareArgs(Args1,Args2,idx+1);
    end;
  end;
  if Result > 0 then
    Result := 1
  else if Result < 0 then
    Result := -1;
end;

function ComplementaryTextColor(c: TColor):TColor;
var
  r,g,b: byte;
begin
  r := ColorToR(c);
  g := ColorToG(c);
  b := ColorToB(c);

  if 0.299*r+0.587*g+0.114*b > 128 then
    result := clBlack
  else
    result := clWhite;
end;

function GetMyDocuments: string;
var
  r: Bool;
  path: array[0..Max_Path] of Char;
begin
  r := ShGetSpecialFolderPath(0, path, CSIDL_Personal, False) ;
  if not r then
    raise Exception.Create('Could not find MyDocuments folder location.') ;
  Result := Path;
end;

function SwapEndian(Value: Cardinal): Cardinal; register; overload;
asm
  bswap eax
end;

function SwapEndian(Value: integer): integer; register; overload;
asm
  bswap eax
end;

function SwapEndian(Value: smallint): smallint; register; overload;
asm
  xchg  al, ah
end;

function SwapEndian(Value : int64) : int64 ; overload;
asm
  mov edx,dword ptr [Value]
  mov eax,dword ptr [Value+4]
  bswap edx
  bswap eax
end;

function GetFloatDecimals(value : Extended): Integer;
var
  intValue: integer;
  extValue: Extended;
begin
  Result := -1;
  repeat
    Inc(Result);
    extValue := value*Power(10,Result);
    intValue := Floor(extValue);
  until extValue-intValue < value;
end;

procedure RemoveEmptyStrings(var sl: TStringList); overload;
var
  i:integer;
begin
  for i:=sl.Count-1 downto 0 do
  begin
    if sl[i] = '' then
      sl.Delete(i);
  end;
end;

procedure RemoveEmptyStrings(var sl: TWideStringList); overload;
var
  i:integer;
begin
  for i:=sl.Count-1 downto 0 do
  begin
    if sl[i] = '' then
      sl.Delete(i);
  end;
end;

function CompareSpringVersion(version1: string; version2: string): integer;
var
  version1Sl: TStringList;
  version2Sl: TStringList;
  i: integer;
  v1: integer;
  v2: integer;
begin
  Result := 0;
  
  version1Sl := TStringList.Create;
  version2Sl := TStringList.Create;

  try
    ParseDelimited(version1Sl,version1,'.','');
    ParseDelimited(version2Sl,version2,'.','');

    for i:=0 to min( version1Sl.Count-1, version2Sl.Count-1 ) do
    begin
      v1 := StrToInt( version1Sl[i] );
      v2 := StrToInt( version2Sl[i] );

      if v1 < v2 then
      begin
        Result := 1;
        Exit;
      end
      else if v2 < v1 then
      begin
        Result := -1;
        Exit;
      end;
    end;
  except
    Result := -1;
  end;
end;

end.
