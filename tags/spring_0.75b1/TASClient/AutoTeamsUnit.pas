unit AutoTeamsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TBXDkPanels, SpTBXControls, StdCtrls, TntStdCtrls, SpTBXEditors,
  SpTBXItem, SpTBXTabs, TB2Item, TBX, ComCtrls, SpTBXjanTracker, Buttons,
  ExtCtrls, JvExControls, JvComponent, JvLabel;

type
  TRandomizer = class(TObject)
  public
    constructor Create; overload;
    constructor Create(SeedLength: Integer); overload;
    destructor Destroy; override;

    procedure RecreateSeed(Length: Integer);
    procedure ResetPos;
    function NextByte: Byte;
    function NextByteInRange(a, b: Byte): Byte;
    function NextPermutation(Length: Byte): AnsiString;
    function PermutationToString(Permutation: AnsiString): string;
    procedure RandomlyPermuteList(List: TList);
    procedure RandomlyPermuteListInRange(List: TList; a, b: Integer);
  private
    Position: Integer;
    Key: array of Byte;
  end; // TRandomizer

  TAutoTeamsForm = class(TForm)
    SpTBXPanel1: TSpTBXPanel;
    ApplyButton: TSpTBXButton;
    SpTBXGroupBox1: TSpTBXGroupBox;
    ClansCheckBox: TSpTBXCheckBox;
    SpTBXLabel1: TSpTBXLabel;
    NumOfAlliesButton: TTBXButton;
    PlayersPerCommButton: TTBXButton;
    SpTBXLabel2: TSpTBXLabel;
    SpTBXPanel3: TSpTBXPanel;
    SpTBXLabel6: TSpTBXLabel;
    ScrollBox1: TScrollBox;
    AutoApplyCheckBox: TSpTBXCheckBox;
    CancelButton: TSpTBXButton;
    RandomizeButton: TSpTBXSpeedButton;

    procedure CreateParams(var Params: TCreateParams); override;

    function AutoSortTeams(Clients_: TList; Clans: Boolean; NumGroups: Integer; PlayersPerTeam: Integer): TList;
    procedure ClearPreview;
    procedure CreatePreview;
    procedure ApplyCurrentConfiguration;

    procedure ScrollBoxLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ScrollBoxLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    procedure ApplyButtonClick(Sender: TObject);
    procedure NumOfAlliesButtonClick(Sender: TObject);
    procedure PlayersPerCommButtonClick(Sender: TObject);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ClansCheckBoxClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RandomizeButtonClick(Sender: TObject);
  private
    LastX, LastY: Integer; // last mouse x/y position on the scroll box. We need it when scrolling by dragging
    Randomizer: TRandomizer;
  public
    { Public declarations }
  end;

var
  AutoTeamsForm: TAutoTeamsForm;
  LastConfiguration: TList; // configuration created by the last call to CreatePreview method

implementation

uses BattleFormUnit, Math, MainUnit, GpIFF, PreferencesFormUnit;

{$R *.dfm}

procedure TAutoTeamsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

{
  If 'Clans' is True, it will try to put players from the same clan in the same team ([clanname]playername).
  NumGroups means number of allies.

  Returns list of lists of lists of clients. First level separates clients into allies, second one into teams,
  and the last layer is the actual list of clients in the team at that level.
}
function TAutoTeamsForm.AutoSortTeams(Clients_: TList; Clans: Boolean; NumGroups: Integer; PlayersPerTeam: Integer): TList;

  function SumRanks(Clients: TList): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to Clients.Count-1 do Inc(Result, TClient(Clients[i]).GetRank + 1);
  end;

  // returns clan's tag name, is client is using it, or else returns ''
  function GetClanTag(Client: TClient): string;
  var
    s: string;
  begin
    Result := '';
    if Length(Client.Name) < 4 then Exit;
    if Client.Name[1] <> '[' then Exit;
    s := Copy(Client.Name, 2, Pos(']', Client.Name));
    if s = '' then Exit;
    // success:
    Result := s;
  end;

  // will return the number of players in the 'Clients' list, that uses 'ClanTag' for their clan tag
  function CountClanMembers(Clients: TList; ClanTag: string): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to Clients.Count-1 do
      if GetClanTag(TClient(Clients[i])) = ClanTag then Inc(Result);
  end;

  { Clients must be sorted from the one with the highest rank to the one with lowest rank.
    Note that this functions will remove all clients from the 'Clients' list and will return
    a list of lists, where each sublist contains some of the clients from the original 'Clients' list }
  function DivideClientsIntoGroups(Clients: TList; NumGroups: Integer): TList;
  var
    minval: Integer;
    minranks, minindex: Integer;

    Groups: TList;
    i: Integer;
  begin
    Groups := TList.Create;
    for i := 0 to NumGroups-1 do
      Groups.Add(TList.Create);

    // put clients into even groups starting with the one who has the highest rank:
    while Clients.Count > 0 do
    begin
      // find the smallest weight that some group has:
      minval := High(Integer); // "infinity"
      for i := 0 to NumGroups-1 do
        if TList(Groups[i]).Count < minval then minval := TList(Groups[i]).Count;

      // out of the groups with 'minval' players, choose a group with the lowest total weight:
      minranks := High(Integer); // "infinity"
      minindex := -1;

      for i := 0 to NumGroups-1 do
        if (TList(Groups[i]).Count = minval) and (SumRanks(Groups[i]) < minranks) then
        begin
          minindex := i;
          minranks := SumRanks(Groups[i]);
        end
        else
        if Clans and (TList(Groups[i]).Count = minval) and (SumRanks(Groups[i]) = minranks) then
          if CountClanMembers(Groups[i], GetClanTag(TClient(Clients[0]))) > CountClanMembers(Groups[minindex], GetClanTag(TClient(Clients[0]))) then
            minindex := i; // minranks stays the same, we only did a swap in order to group clan members together

      TList(Groups[minindex]).Add(Clients[0]);
      Clients.Delete(0);

      if Clients.Count = 0 then Break; // we're done!
    end; // while

    Result := Groups;
  end; // DivideClientsIntoGroups

var
  Clients: TList;
  Groups: TList;
  i, j: Integer;
  tmpval: Integer;
  tmplist: TList;

begin
  Clients := TList.Create;
  Clients.Assign(Clients_);
  // lets sort clients from the one with highest rank to the one with lowest rank:
  for i := Clients.Count-1 downto 0 do
    for j := 0 to i-1 do
      if (TClient(Clients[j]).GetRank+1) < (TClient(Clients[j+1]).GetRank+1) then
        Clients.Exchange(j, j+1);

  // randomize clients within same rank ranges:
  i := 0;
  while i < Clients.Count-1 do
  begin
    tmpval := TClient(Clients[i]).GetRank;
    j := i;
    while (j+1 <= Clients.Count-1) and (TClient(Clients[j+1]).GetRank = tmpval) do Inc(j);

    if j > i then
    begin
      { current situation: i is index of the first client in range, j is index of the last client in range.
        We have to randomly permute clients in this range. }
      Randomizer.RandomlyPermuteListInRange(Clients, i, j);
    end;

    i := j + 1;
  end;

  Groups := DivideClientsIntoGroups(Clients, Min(NumGroups, Clients.Count));
  {
    This is the current situation: We have NumGroups of groups, where all groups
    have same number of players (or 1 less at most), and players
    are sorted into groups in such way that total sum of ranks per group is
    similar to sum of any other group.
  }

  // shuffle current ally numbers a bit (randomize it):
  Randomizer.RandomlyPermuteList(Groups);

  // now we will form teams within each group:
  for i := 0 to Groups.Count-1 do
  begin
    tmpval := TList(Groups[i]).Count div PlayersPerTeam;
    if TList(Groups[i]).Count mod PlayersPerTeam > 0 then Inc(tmpval);

    tmpList := DivideClientsIntoGroups(Groups[i], tmpval);
    TObject(Groups[i]).Free;
    Groups[i] := tmpList;
  end;

  Result := Groups;
end;

procedure TAutoTeamsForm.ApplyButtonClick(Sender: TObject);
begin
  ApplyCurrentConfiguration;
  Close;
end;

procedure TAutoTeamsForm.NumOfAlliesButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := BattleForm.ChooseNumberDialog(Sender as TControl, StrToInt(NumOfAlliesButton.Caption)-1);
  if Index = -1 then Exit;

  Index := Max(1, Index); // at least 2 allies!

  if StrToInt(NumOfAlliesButton.Caption)-1 = Index then Exit; // no change
  NumOfAlliesButton.Caption := IntToStr(Index+1);

  CreatePreview;
end;

procedure TAutoTeamsForm.PlayersPerCommButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := BattleForm.ChooseNumberDialog(Sender as TControl, StrToInt(PlayersPerCommButton.Caption)-1);
  if Index = -1 then Exit;

  if StrToInt(PlayersPerCommButton.Caption)-1 = Index then Exit; // no change
  PlayersPerCommButton.Caption := IntToStr(Index+1);

  CreatePreview;
end;

procedure TAutoTeamsForm.ClearPreview;
begin
  // remove any child controls:
  while ScrollBox1.ControlCount > 0 do
    ScrollBox1.Controls[0].Free;
end;

procedure TAutoTeamsForm.ScrollBoxLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  p := ScrollBox1.ScreenToClient((Sender as TControl).ClientToScreen(Point(X, Y)));
  ScrollBox1.OnMouseDown(ScrollBox1, Button, Shift, p.X, p.Y);
end;

procedure TAutoTeamsForm.ScrollBoxLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  p := ScrollBox1.ScreenToClient((Sender as TControl).ClientToScreen(Point(X, Y)));
  ScrollBox1.OnMouseMove(ScrollBox1, Shift, p.X, p.Y);
end;

procedure TAutoTeamsForm.CreatePreview;
var
  Clients: TList;
  Groups: TList;
  tmpLabel: TJvLabel;
  i, j, k: Integer;
  tmpY, tmpX: Integer;
  YSpacing: Integer;
  TeamCounter: Integer;

  function AddLabel(X, Y: Integer; Text: string): TJvLabel;
  var
    lab: TJvLabel;
  begin
    lab := TJvLabel.Create(ScrollBox1);
    lab.Left := X - ScrollBox1.HorzScrollBar.ScrollPos;
    lab.Top := Y - ScrollBox1.VertScrollBar.ScrollPos;
    lab.Caption := Text;
    lab.Parent := ScrollBox1;

    lab.OnMouseDown := ScrollBoxLabelMouseDown;
    lab.OnMouseUp := ScrollBox1.OnMouseUp;
    lab.OnMouseMove := ScrollBoxLabelMouseMove;

    Result := lab;
  end;

  function GetMaxRightPos: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to ScrollBox1.ControlCount - 1 do
      Result := Max(Result, ScrollBox1.Controls[i].Left + ScrollBox1.Controls[i].Width + ScrollBox1.HorzScrollBar.Position);
  end; // GetMaxRightPos

begin
  if BattleState.Status = None then Exit;

  ClearPreview;

  Randomizer.RecreateSeed(512); // randomize a bit

  Clients := TList.Create;
  Clients.Assign(BattleState.Battle.Clients);

  if Clients.Count = 0 then Exit; // should not really happen

  Groups := AutoSortTeams(Clients, ClansCheckBox.Checked, StrToInt(NumOfAlliesButton.Caption), StrToInt(PlayersPerCommButton.Caption));

  YSpacing := 13;
  TeamCounter := 0;
  for i := 0 to Groups.Count-1 do
  begin
    tmpX := IFF(i = 0, 10, GetMaxRightPos + 30);
    tmpY := 10;
    for j := 0 to TList(Groups[i]).Count-1 do
    begin
      AddLabel(tmpX, tmpY, 'Team ' + IntToStr(TeamCounter+1) + ':');
      Inc(TeamCounter);

      Inc(tmpX, 10);
      for k := 0 to TList(TList(Groups[i])[j]).Count-1 do
      begin
        Inc(tmpY, YSpacing);
        tmpLabel := AddLabel(tmpX, tmpY, TClient(TList(TList(Groups[i])[j])[k]).Name);
        tmpLabel.Images := MainForm.RanksImageList;
        tmpLabel.ImageIndex := TClient(TList(TList(Groups[i])[j])[k]).GetRank;
        tmpLabel.Spacing := 1;
      end;
      Dec(tmpX, 10);
      Inc(tmpY, 25); // vertical spacing between teams
    end;

    if i < Groups.Count-1 then
    begin
      tmpLabel := AddLabel(GetMaxRightPos + 30, tmpY div 2 - 5, 'VS.');
      tmpLabel.Font.Color := clRed;
      tmpLabel.Font.Style := [fsBold];
    end;
  end;

  // expand scrollable area a bit:
  i := ScrollBox1.HorzScrollBar.Position;
  j := ScrollBox1.VertScrollBar.Position;
  ScrollBox1.AutoScroll := True;
  ScrollBox1.HorzScrollBar.Range := ScrollBox1.HorzScrollBar.Range + 10;
  ScrollBox1.VertScrollBar.Range := ScrollBox1.VertScrollBar.Range + 10;
  ScrollBox1.HorzScrollBar.Position := i;
  ScrollBox1.VertScrollBar.Position := j;

  LastConfiguration := Groups;
end;

// will apply the last generated configuration to the current battle that user is participating in
procedure TAutoTeamsForm.ApplyCurrentConfiguration;
var
  i, j, k: Integer;
  Groups: TList;
begin
  if LastConfiguration = nil then Exit; // this should not really happen!

  if BattleState.Status <> Hosting then
  begin
    BattleForm.AddTextToChat('Unable to force ally/team numbers - only host allowed to force it!', Colors.Info, 1);
    Exit;
  end;

  Groups := LastConfiguration;

  BattleForm.AddTextToChat('Forcing team/ally numbers ...', Colors.Info, 1);

  try
    for i := 0 to Groups.Count-1 do
    begin
      for j := 0 to TList(Groups[i]).Count-1 do
      begin
        for k := 0 to TList(TList(Groups[i])[j]).Count-1 do
        begin
          if TClient(TList(TList(Groups[i])[j])[k]).GetAllyNo <> i then
            MainForm.TryToSendCommand('FORCEALLYNO', TClient(TList(TList(Groups[i])[j])[k]).Name + ' ' + IntToStr(i));
          if TClient(TList(TList(Groups[i])[j])[k]).GetTeamNo <> j then
            MainForm.TryToSendCommand('FORCETEAMNO', TClient(TList(TList(Groups[i])[j])[k]).Name + ' ' + IntToStr(j));
        end;
      end;
    end;
  except
    BattleForm.AddTextToChat('Unable to force ally/team numbers (player list changed?) - try recreating the preview', Colors.Error, 1);
    Exit;
  end;

  MainForm.TryToSendCommand('SAYBATTLEEX', 'is auto-balancing teams ...');

end;

procedure TAutoTeamsForm.ScrollBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) or (ssRight in Shift) then
  begin
    ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position - (X-LastX);
    ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position - (Y-LastY);
    LastX := X;
    LastY := Y;
  end;
end;

procedure TAutoTeamsForm.ScrollBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) or (ssRight in Shift) then
  begin
    LastX := x;
    LastY := y;
    Screen.Cursor := crHandPoint;
  end;
end;

procedure TAutoTeamsForm.ScrollBox1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDefault;
end;

procedure TAutoTeamsForm.FormCreate(Sender: TObject);
begin
  ScrollBox1.DoubleBuffered := True;
  Randomizer := TRandomizer.Create;
end;

procedure TAutoTeamsForm.ClansCheckBoxClick(Sender: TObject);
begin
  CreatePreview;
end;

procedure TAutoTeamsForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TAutoTeamsForm.FormShow(Sender: TObject);
begin
  CreatePreview;
end;

{ *************************************************************************** }
{ **************************   TRandomizer class   ************************** }
{ *************************************************************************** }

constructor TRandomizer.Create;
begin
  Create(1024);
end;

constructor TRandomizer.Create(SeedLength: Integer);
begin
  inherited Create;
  RecreateSeed(SeedLength);
end;

destructor TRandomizer.Destroy;
begin
  Finalize(Key);
  inherited Destroy;
end;

procedure TRandomizer.RecreateSeed(Length: Integer);
var
  i: Integer;
begin
  SetLength(Key, Length);
  for i := 0 to Length-1 do
    Key[i] := Random(256);

  ResetPos;
end;

procedure TRandomizer.ResetPos;
begin
  Position := 0;
end;

function TRandomizer.NextByte: Byte;
begin
  Result := Key[Position];
  Position := (Position + 1) mod Length(Key); // ring buffer
end;

// will return a value in range [a, b], inclusive
function TRandomizer.NextByteInRange(a, b: Byte): Byte;
begin
  Result := (NextByte mod (b - a + 1)) + a;
end;

{ will return a string of length Length containing bytes in range [0, Length).
  Algorithm taken from: http://www2.toki.or.id/book/AlgDesignManual/BOOK/BOOK4/NODE151.HTM
  An example input and output case:
  input: 4
  output: 2, 0, 1, 3
  }
function TRandomizer.NextPermutation(Length: Byte): AnsiString;
var
  i: Integer;

  procedure SwapChars(var s: string; i1, i2: Integer);
  var
    c: Char;
  begin
    if i1 = i2 then Exit;
    c := s[i1];
    s[i1] := s[i2];
    s[i2] := c;
  end;

begin
  SetLength(Result, Length);
{
  for the reference, this is how uniform algorithm should look like:
    for i := 0 to n-1 do a[i] := i;
    for i := 0 to n-2 do a.swap(i, random([i, n-1]));
}
  for i := 1 to Length do Result[i] := Chr(i-1);
  for i := 1 to Length-1 do SwapChars(Result, i, NextByteInRange(i, Length));
end;

function TRandomizer.PermutationToString(Permutation: AnsiString): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Permutation) do
    Result := Result + IntToStr(Ord(Permutation[i])) + '|';
  Delete(Result, Length(Result), 1);
end;

procedure TRandomizer.RandomlyPermuteList(List: TList);
var
  i: Integer;
begin
  for i := 0 to List.Count-2 do List.Exchange(i, NextByteInRange(i, List.Count-1));
end;

{ will permute elements in the list starting at index a and ending at index b (both inclusive).
  For example, having a list of 5 elements: abcdef and a=1 b=3 will permute sublist "bcd".
  Final list will be composed of 3 sublist: "a" + perm("bcd") + "ef" }
procedure TRandomizer.RandomlyPermuteListInRange(List: TList; a, b: Integer);
var
  i: Integer;
begin
  if not (b > a) then Exit; // invalid arguments
  for i := a to b-1 do List.Exchange(i, NextByteInRange(i, b));
end;

procedure TAutoTeamsForm.RandomizeButtonClick(Sender: TObject);
begin
  CreatePreview;
end;

end.
