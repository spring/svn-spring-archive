{
  http://www.delphizine.com/newsletterarticle/2003/04/di200304rs_l/di200304rs_l.asp
  (this is why we need EnableControlAndChildren and DisableControlAndChildren)

}
{$DEFINE DONTUSETTL2}

unit Misc; // Miscellaneous

interface

uses
  SpTBXItem,JvSpin,Dialogs, Classes, ComCtrls, Windows, Graphics, MMSystem, Controls, Registry, SysUtils,
  WSocket, Winsock, ESBDates, GpTimeZone, JvColorCombo, Forms,StdCtrls,HttpProt,TntComCtrls,JclUnicode;

type
  TVerticalAlign=(alVTop,alVCenter,alVBottom);
  THorizontalAlign=(alHLeft,alHCenter,alHRight);
  TJustify=(JustLeft,JustCenter,JustRight);

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
function JoinStringList(sl : TStrings;delimiter: String):String;
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
procedure AddTextToRichEdit(RichEdit: TTntRichEdit; Text: WideString; TextColor: TColor; Scroll: Boolean; ChatTextPos: Integer);
procedure PlayResSound(RESName: string);
procedure EnableControlAndChildren(Control: TWinControl); // enable group of controls
procedure DisableControlAndChildren(Control: TWinControl); // disable group of controls
function HashFile(FileName: string): Integer; // creates signed 32-bit hash code
function VersionStringToFloat(Version: string): Single;
function GetFileSize(FileName: string): Integer;
function VerifyName(Name: string): Boolean;
function GetRegistryData(RootKey: HKEY; Key, Value: string): Variant;
procedure SetRegistryData(RootKey: HKEY; Key, Value: string; RegDataType: TRegDataType; Data: Variant);
procedure RemoveRegistryData(RootKey: HKEY; Key, Value: string);
procedure RemoveRegistryKey(RootKey: HKEY; Key: string);
function FormatFileSize(Size: Integer): string;
function FormatFileSize2(SizeInBytes: Integer): string;
function GenerateUniqueID: Integer;
function GetCPUSpeed: Integer;
procedure NormalizeRect(var Rect: TRect);
procedure LimitRect(var Rect: TRect; LimitRect: TRect);
function PointInRect(Rect: TRect; Point: TPoint): Boolean;
procedure FixURL(var URL: string);
function CreateMapListFromHtml(const HtmlText: TStringList): TStringList;
procedure RevertList(List: TList);
procedure AddBitmapToImageList(il: TImageList; FileName: string); overload;
procedure AddBitmapToImageList(il: TImageList; const buf; len: Integer); overload;
procedure SendUDPStr(Address: string; DestinationPort: Integer; var SourcePort: Integer; Text: string);
procedure SendUDPStrEx(Address: string; DestinationPort: Integer; var SourcePort: Integer; TTL: Integer; Text: string);
function GetMD5Hash(s: string): string; // returns hash in base 64 format
function GetLocalIP: string;
function UTCTimeToLocalTime(utctime: TDateTime): TDateTime;
function MapColorNameToIndex(ColorName: string; ColorComboBox: TJvColorComboBox): Integer;
function EnumerateSpaces(Count: Integer): string;
function PackRGB(R: Byte; G: Byte; B: Byte): Integer; overload; // packs R, G, B to $00BBGGRR format (standard TColor format)
function PackRGB(R: Extended; G: Extended; B: Extended): Integer; overload; // packs R, G, B to $00BBGGRR format (standard TColor format). R, G and B must be in interval [0..1]
function ColorToR(Color: Integer): Byte; // Color is in $00BBGGRR format
function ColorToG(Color: Integer): Byte; // Color is in $00BBGGRR format
function ColorToB(Color: Integer): Byte; // Color is in $00BBGGRR format
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
procedure RemoveSpTBXTitleBarMarges(form: TForm);
function InputColor(title: String; defaultColor: TColor):TColor;
procedure FixFormSizeConstraints(form: TForm);
procedure DrawMultilineText(AString: string;
                       ACanvas:TCanvas;ARect: TRect;
                       HorizontalAlign:THorizontalAlign;
                       VerticalAlign:TVerticalAlign;
                       TextJustification:TJustify;
                       WordWrap:boolean);
Function TextSize2(Text: string; AWidth: integer; Font: TFont = nil): TPoint;

implementation

uses
  ShellAPI, Math, RichEdit, Messages, MainUnit, StringParser,
  StrUtils, uMd5, SZCodeBaseX, HighlightingUnit, DSiWin32, ColorPicker;

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
function JoinStringList(sl : TStrings;delimiter: String):String;
var
  i:integer;
begin
  Result := '';
  for i:=0 to sl.Count-1 do
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

{
  If Scroll=False, it will not scroll rich edit to the new line added.

  ChatTextPos is a position in the line where chat text begins. We need this when we are searching for keywords to highlight
  and we (for example) don't want to highlight nicknames in "<xyz>" part of the line, but only after that part (keywords will
  get highlighted only in chat part of the text, not the header). If you don't specify ChatTextPos parameter, it is assumed
  that the entire line is the chat text.
}
procedure AddTextToRichEdit(RichEdit: TTntRichEdit; Text: WideString; TextColor: TColor; Scroll: Boolean; ChatTextPos: Integer);
var
  SelStart, SelLength: Integer;
  p: TPoint;
  pMax: TPoint;
begin
  RichEdit.Lines.BeginUpdate;

    // save the scroll pos
    SelStart := RichEdit.SelStart;
    SelLength := RichEdit.SelLength;
    SendMessage(RichEdit.Handle, WM_USER + 221 {EM_GETSCROLLPOS},  0, LPARAM(@p));

    // get the scroll max
    RichEdit.SelLength := 0;
    RichEdit.SelStart := Length(RichEdit.Text);
    SendMessage(RichEdit.Handle, WM_USER + 221 {EM_GETSCROLLPOS},  0, LPARAM(@pMax));

  try
    if RichEdit.Lines.Count >= 1500 then
      RichEdit.Lines.Delete(0);

    RichEdit.SelLength := 0;
    RichEdit.SelStart := Length(RichEdit.Text);
    RichEdit.SelAttributes.Color := TextColor;
    RichEdit.Lines.Add(Text);
    // this will automatically highlight any keywords and pop-up notification windows (if set so):
    HighlightingForm.CheckLastLineForHighlights(RichEdit, ChatTextPos);
  except
  end;

  if not Scroll or (p.Y < Max(0,pMax.Y-20)) then
  begin
    RichEdit.SelStart := SelStart;
    RichEdit.SelLength := SelLength;
    SendMessage(RichEdit.Handle, WM_USER + 222 {EM_SETSCROLLPOS}, 0, LPARAM(@p));
  end;

  RichEdit.Lines.EndUpdate;
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
  else if SizeInBytes < 1000*1000 then Result := Format('%.2f', [(SizeInBytes / 1024)]) + ' KB'
  else Result := Format('%.2f', [(SizeInBytes / (1024*1024))]) + ' MB'
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

function Color16BitsToR(Color: Word): Byte;
begin
  Result := Color and $F800 shr 11;
end;

function Color16BitsToG(Color: Word): Byte;
begin
  Result := Color and $7E0 shr 5;
end;

function Color16BitsToB(Color: Word): Byte;
begin
  Result := Color and $1F;
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
           NORMAL_PRIORITY_CLASS,
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
  CaptureProgramOutput('spring.exe /V', Output);

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
    UserID := GetRegistryData(HKEY_CURRENT_USER, '\Software\TNEilcsat', 'UserId');
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
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\TNEilcsat', 'UserId', rdInteger, Integer(UserID));
  except
  end;
end;

{ --------------------------------------------------------------------------- }

procedure OpenURLInDefaultBrowser(URL: string);
begin
//  ShellExecute(MainForm.Handle, nil, PChar(URL), '', '', SW_SHOW);
  ShellExecute(MainForm.Handle, nil, PChar(AnsiString(URL)), '', '', SW_SHOWNORMAL);

end;

{ --------------------------------------------------------------------------- }

function ColorDistance(e1:integer;e2:integer):integer;
var
   l1,a1,b1: integer;
   l2,a2,b2: integer;
begin
   RGBToLab(ColorToR(e1),ColorToG(e1),ColorToB(e1),l1,a1,b1);
   RGBToLab(ColorToR(e2),ColorToG(e2),ColorToB(e2),l2,a2,b2);
   Result := Round(Power(Power((l1-l2),2)+Power((a1-a2),2)+Power((b1-b2),2),1/2));
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

procedure RemoveSpTBXTitleBarMarges(form: TForm);
begin
  TSpTBXTitleBar(form.FindChildControl('SpTBXTitleBar1')).Align := alNone;
  TSpTBXTitleBar(form.FindChildControl('SpTBXTitleBar1')).Top := -30;
  form.Width := form.Width-10;
  form.Height := form.Height-60;
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
    MinHeight := 0;
    MinWidth := 0;
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

end.
