{
  http://www.delphizine.com/newsletterarticle/2003/04/di200304rs_l/di200304rs_l.asp
  (this is why we need EnableControlAndChildren and DisableControlAndChildren)

}

unit Misc; // Miscellaneous

interface

uses
  Classes, ComCtrls, Graphics, MMSystem, Controls, Registry, SysUtils, Windows;

function ShellExecuteAndWait(FileName: string; Params: string): Boolean;
function MakeSentence(sl: TStringList; StartIndex: Integer): string;
function CreateStrings(Length: Integer): string; // a helper function used to create a string filled with #13's
function StringToHex(s: string): string;
function HexToString(s: string): string;
function SaveStringToFile(FileName: string; s: string): Boolean;
function BoolToInt(b: Boolean): Integer;
function IntToBool(i: Integer): Boolean;
procedure AddTextToRichEdit(RichEdit: TRichEdit; Text: string; TextColor: TColor; Scroll: Boolean);
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
function GenerateUniqueID: Integer;
function GetCPUSpeed: Integer;
procedure NormalizeRect(var Rect: TRect);
procedure LimitRect(var Rect: TRect; LimitRect: TRect);
function PointInRect(Rect: TRect; Point: TPoint): Boolean;
procedure FixURL(var URL: string);
function CreateMapListFromHtml(const HtmlText: TStringList): TStringList;

implementation

uses
  ShellAPI, Forms, Math, Dialogs, RichEdit, Messages, Unit1, StringParser,
  StrUtils;

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
    lpFile := PChar(FileName);
    lpParameters := PChar(Params);
    lpDirectory := PChar(ExtractFilePath(FileName));
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

// if Scroll=False, it will not scroll rich edit to the new line added
procedure AddTextToRichEdit(RichEdit: TRichEdit; Text: string; TextColor: TColor; Scroll: Boolean);
var
  SelStart, SelLength: Integer;
  p: TPoint;
begin
  if not Scroll then
  begin
    SendMessage(RichEdit.Handle, WM_USER + 221 {EM_GETSCROLLPOS},  0, LPARAM(@p));
    SelStart := RichEdit.SelStart;
    SelLength := RichEdit.SelLength;
  end;

  RichEdit.SelLength := 0;
  RichEdit.SelStart := Length(RichEdit.Text);
  RichEdit.SelAttributes.Color := TextColor;
  RichEdit.Lines.Add(Text);

  if not Scroll then
  begin
    RichEdit.SelStart := SelStart;
    RichEdit.SelLength := SelLength;
    SendMessage(RichEdit.Handle, WM_USER + 222 {EM_SETSCROLLPOS}, 0, LPARAM(@p));
  end;
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
    or (Ord(c) = 95);                       // underscore
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

// <Size> is in bytes!
function FormatFileSize(Size: Integer): string;
begin
  Result := Trim(Format('%8.2f', [(Size / 1024)]));
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

end.
