{
  http://www.delphizine.com/newsletterarticle/2003/04/di200304rs_l/di200304rs_l.asp
  (this is why we need EnableControlAndChildren and DisableControlAndChildren)

}
{$DEFINE DONTUSETTL2}

unit Misc; // Miscellaneous

interface

uses
  Classes, ComCtrls, Windows, Graphics, MMSystem, Controls, Registry, SysUtils,
  WSocket, Winsock, ESBDates, GpTimeZone, JvColorCombo, Forms;

function ShellExecuteAndWait(FileName: string; Params: string): Boolean;
function MakeSentence(sl: TStringList; StartIndex: Integer): string;
function CreateStrings(Length: Integer): string; // a helper function used to create a string filled with #13's
function StringToHex(s: string): string;
function HexToString(s: string): string;
function SaveStringToFile(FileName: string; s: string): Boolean;
function BoolToInt(b: Boolean): Integer;
function IntToBool(i: Integer): Boolean;
function HexToInt(HexStr: String): Integer;
procedure AddTextToRichEdit(RichEdit: TRichEdit; Text: string; TextColor: TColor; Scroll: Boolean; ChatTextPos: Integer);
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

implementation

uses
  ShellAPI, Math, Dialogs, RichEdit, Messages, MainUnit, StringParser,
  StrUtils, uMd5, SZCodeBaseX, HighlightingUnit, SpTBXItem, DSiWin32;

const
  Hex: array[0..15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
  BUFFER_LENGTH = 1024;

{ --------------------------------------------------------------------------- }

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
procedure AddTextToRichEdit(RichEdit: TRichEdit; Text: string; TextColor: TColor; Scroll: Boolean; ChatTextPos: Integer);
var
  SelStart, SelLength: Integer;
  p: TPoint;
begin
  RichEdit.Lines.BeginUpdate;

  if not Scroll then
  begin
    SendMessage(RichEdit.Handle, WM_USER + 221 {EM_GETSCROLLPOS},  0, LPARAM(@p));
    SelStart := RichEdit.SelStart;
    SelLength := RichEdit.SelLength;
  end;

  try
    RichEdit.SelLength := 0;
    RichEdit.SelStart := Length(RichEdit.Text);
    RichEdit.SelAttributes.Color := TextColor;
    RichEdit.Lines.Add(Text);
    // this will automatically highlight any keywords and pop-up notification windows (if set so):
    HighlightingForm.CheckLastLineForHighlights(RichEdit, ChatTextPos);
  except
  end;

  if not Scroll then
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
    UserID := GetRegistryData(HKEY_CURRENT_USER, '\Software\LobbyUserID', 'ID');
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
    Misc.SetRegistryData(HKEY_CURRENT_USER, '\Software\LobbyUserID', 'ID', rdInteger, Integer(UserID));
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


end.
