{

  http://www.cpcug.org/user/clemenzi/technical/Languages/Delphi/Parse.html
  (the first page google found on "Delphi parsing string" :-) )

  http://www.delphicorner.f9.co.uk/articles/misc9.htm

}
unit StringParser;

interface

uses Classes,JclUnicode;

function ParseString(s: string; Delimiter: Char): TStringList;overload;
function ParseString(s: WideString; Delimiter: Char): TWideStringList; overload;
function ParseStringEx(s: string; Delimiter: string): TStringList;

implementation


{
function  Mid_mc(s:string; StartPos: integer; EndPos: integer = -1):string;
    // NumOfCharacters = -1 means "to the end of the string"
var
  i, j: integer;
begin
  i := StartPos;
  if (i < 1) then i := 1;

  if (i > length(s)) then begin
    Mid_mc := '';
    exit;
  end;

  if EndPos < 0 then
    j := length(s)
  else
    j := EndPos;
  Mid_mc := copy(s, i, j-i+1);
end;   // Mid_mc  integer, integer


function  InStr_mc(S, Pattern: string; Start: integer=1;
                     CaseSensitive:boolean=false):integer;
var
  tempStr: string;
  i, j: integer;
begin
  i := Start;
  if (i < 1) then i := 1;

  if (i > length(s)) then begin
    InStr_mc := 0;
    exit;
  end;
  tempStr := copy(s, i, length(s));

  if CaseSensitive then
    j := pos(Pattern, tempStr)
  else
    j := pos(upperCase(Pattern), upperCase(tempStr));

  if J<>0 then j := i+j-1 ;

  InStr_mc := j;
end;   // InStr_mc


// Accepts a string and returns a stringList
function  ParseString_mc(s: string; delimiters: string = WhiteSpace_mc)
                 : TStringList;
var
  tempStr, token: string;
  list: TStringList;
  i,j: integer;
begin
  tempStr := s;
  list:= TStringList.Create;
  i:=1;
  if length(s)>0 then repeat
    while InStr_mc(delimiters, tempStr[i]) <> 0 do begin
      i := i+1;
      if i > length(s) then break;
    end;
    j:= i;
    if j <= length(s) then
      while InStr_mc(delimiters, tempStr[j]) = 0 do begin
        j := j+1;
        if j > length(s) then break;
      end;

    if i <= length(s) then begin
      token:=mid_mc(tempStr, i, j-1);
      list.Append(token);
    end;
    i := j+1;
  until i >= length(s) ;

  ParseString_mc := list;
end;   // ParseString_mc
}

function ParseString(s: WideString; Delimiter: Char): TWideStringList;
var
  str, wrd: WideString;
  list: TWideStringList;

begin

  list:= TWideStringList.Create;

  Result := list;
  str := s;
  wrd := '';

  {Check to see if the string passed is blank}
  if (Length(s) = 0) then Exit;

  while (Pos(Delimiter, str) > 0) do                  {Do this while you find}
  begin                                         {spaces in the sentence}
    wrd := Copy(str, 1, Pos(Delimiter, str) - 1);     {Get the word from the string}
    list.Add(wrd);                              {Add the word to the TStringList}
    str := Copy(str, Pos(Delimiter, str) + 1,         {Redefine the sentence by cutting}
                Length(str) - Length(wrd) + 1); {off the first word}
  end;

  if (Length(str) > 0) then                     {This is important, because you never}
    list.Add(str);                              {know if there's anything left in the
                                                 sentence.}
end;


function ParseString(s: string; Delimiter: Char): TStringList;
var
  str, wrd: string;
  list: TStringList;

begin

  list:= TStringList.Create;

  Result := list;
  str := s;
  wrd := '';

  {Check to see if the string passed is blank}
  if (Length(s) = 0) then Exit;

  while (Pos(Delimiter, str) > 0) do                  {Do this while you find}
  begin                                         {spaces in the sentence}
    wrd := Copy(str, 1, Pos(Delimiter, str) - 1);     {Get the word from the string}
    list.Add(wrd);                              {Add the word to the TStringList}
    str := Copy(str, Pos(Delimiter, str) + 1,         {Redefine the sentence by cutting}
                Length(str) - Length(wrd) + 1); {off the first word}
  end;

  if (Length(str) > 0) then                     {This is important, because you never}
    list.Add(str);                              {know if there's anything left in the
                                                 sentence.}
end;

function ParseStringEx(s: string; Delimiter: string): TStringList;
var
  str, wrd: string;

begin
  Result := TStringList.Create;

  str := s;
  wrd := '';

  if (Length(s) = 0) then Exit;

  while (Pos(Delimiter, str) > 0) do
  begin
    wrd := Copy(str, 1, Pos(Delimiter, str) - 1);
    Result.Add(wrd);
    str := Copy(str, Pos(Delimiter, str) + Length(Delimiter), Length(str));
  end;

  if (Length(str) > 0) then Result.Add(str);
end;

end.
