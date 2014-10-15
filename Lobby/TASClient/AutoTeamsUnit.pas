unit AutoTeamsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, StdCtrls, TntStdCtrls, SpTBXEditors,
  SpTBXItem, SpTBXTabs, TB2Item, ComCtrls, Buttons,
  ExtCtrls, JvExControls, JvComponent, JvLabel,Misc,MainUnit;

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
    SpTBXTitleBar1: TSpTBXTitleBar;
    SpTBXPanel1: TSpTBXPanel;
    ApplyButton: TSpTBXButton;
    SpTBXGroupBox1: TSpTBXGroupBox;
    ClansCheckBox: TSpTBXCheckBox;
    SpTBXLabel1: TSpTBXLabel;
    SpTBXLabel2: TSpTBXLabel;
    RandomizeButton: TSpTBXSpeedButton;
    NumOfAlliesSpin: TSpTBXSpinEdit;
    PlayersPerCommSpin: TSpTBXSpinEdit;
    NoNewIdsCheckBox: TSpTBXCheckBox;
    SpTBXPanel3: TSpTBXPanel;
    SpTBXLabel6: TSpTBXLabel;
    ScrollBox1: TScrollBox;
    CancelButton: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;

    function AutoSortTeams(Clients_: TList; Clans: Boolean; NumGroups: Integer; PlayersPerTeam: Integer): TList;
    procedure ClearPreview;
    procedure CreatePreview;
    procedure ApplyCurrentConfiguration;

    procedure ScrollBoxLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ScrollBoxLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    procedure ApplyButtonClick(Sender: TObject);
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
    function GetClanTag(Client: TClient): string;
    procedure NumOfAlliesSpinValueChanged(Sender: TObject);
    procedure PlayersPerCommSpinValueChanged(Sender: TObject);
    procedure NoNewIdsCheckBoxClick(Sender: TObject);
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

uses BattleFormUnit, Math, GpIFF, PreferencesFormUnit, gnugettext;

{$R *.dfm}

// returns clan's tag name, is client is using it, or else returns ''
  function TAutoTeamsForm.GetClanTag(Client: TClient): string;
  var
    s1 : TStrings;
    s2 : TStrings;
    group: TClientGroup;
    i: integer;
  begin
    group := Client.GetGroup;
    if group <> nil then
      if group.BalanceInSameTeam then
      begin
        Result := group.Name + '64q4ss87$';
        Exit;
      end;

    s1 := TStringList.Create;
    s2 := TStringList.Create;
    Result := '';
    Misc.ParseDelimited(s1,Client.DisplayName,'[','');
    if s1.Count > 1 then
    begin
      i:=1;
      while (s1.Strings[i] = '') and (i<s1.count) do begin
        i := i+1;
      end;
      Misc.ParseDelimited(s2,s1.Strings[i],']','');
      if s2.Count > 1 then
        Result := s2.Strings[0];
    end;
  end;

procedure TAutoTeamsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
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



  // will return the number of players in the 'Clients' list, that uses 'ClanTag' for their clan tag
  function CountClanMembers(Clients: TList; ClanTag: string): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to Clients.Count-1 do
      if GetClanTag(TClient(Clients[i])) = ClanTag then Inc(Result);
  end;
  
   {Clients must be sorted from the one with the highest rank to the one with lowest rank.
    Note that this functions will remove all clients from the 'Clients' list and will return
    a list of lists, where each sublist contains some of the clients from the original 'Clients' list }
  function DivideClientsIntoGroups(Clients: TList; NumGroups: Integer): TList;
  type
	  PPlayer = ^Player;
	  Player =
	  record
	    id : integer;
	    rank : integer;
	    clan : String;
	  end;
	var
	  ranker : TList;
	  tmpList : TList;
	  l2 : TList;
	  teamClans : TList;
	  teamUsers : TList;
	  ptrTmpList : ^TList;
	  ptrTmpStrList : ^TStrings;
	  i: integer;
	  j: integer;
	  APlayer : PPlayer;
	  maxRank : integer;
	  teamCount : integer;
	  teamList : TStrings;
	  teamSums : array of integer;
	  temp : TList;
	  allys : TList;
	  minSum : integer;
	  minId : integer;
	  cnt : integer;
	  picked_user : integer;
	  rank : integer;
	  assignedClans : TStringList;
	  ptrInt : ^Integer;
	  usr : Player;
	  rdIndex : integer;
	  allyNum : integer;
	  Groups: TList;
	begin
	  ranker := TList.Create;
	  tmpList := TList.Create;
	  l2 := TList.Create;
	  teamList := TStringList.Create;
	  teamClans := TList.Create;
	  teamUsers := TList.Create;
	  assignedClans :=  TStringList.Create;
	  temp := TList.Create;
	  allys := TList.Create;

	  for i:=0 to Clients.Count-1 do begin
      if TClient(Clients[i]).GetMode <> 0 then begin
	      New(APlayer);
	      APlayer^.id := i;
	      APlayer^.rank :=  TClient(Clients[i]).GetRank;
	      APlayer^.clan :=  GetClanTag(TClient(Clients[i]));
	      ranker.Add(APlayer);
      end;
	  end;

	  teamCount := NumGroups;

	  tmpList.Clear;
	  for i := 0 to ranker.Count - 1 do
	    tmpList.Add(ranker[i]);
	  ranker.clear;

	  while tmpList.count > 0 do begin
	      // find max rank
	      maxRank := Low(Integer);
	      for i:= 0 to tmpList.Count - 1 do
	      begin
	        if PPlayer(tmpList[i]).rank > maxRank then
	          maxRank := PPlayer(tmpList[i]).rank;
	      end;

	      i:=0;
	      while i < tmpList.Count do begin
	        if PPlayer(tmpList[i]).rank = maxRank then begin
	          l2.Add(PPlayer(tmpList[i]));
	          tmpList.Remove(PPlayer(tmpList[i]));
	          i:=0;
	        end;
	        i := i+1;
	      end;

	      while l2.Count > 0 do begin
	        i:= Random(l2.Count);
	        ranker.Add(PPlayer(l2[i]));
	        l2.Remove(PPlayer(l2[i]));
	      end;
	  end;

      for i:= 1 to teamCount do
           teamUsers.Add(TList.Create);

      SetLength(teamSums,teamCount);

      for i:= 1 to teamCount do
           teamClans.Add(TStringList.Create);

      // this cycle performs actual user adding to teams
      cnt := 0;
      while ranker.Count > 0 do begin

        minId := 0;
        minSum := High(Integer);

        for i:=0 to teamCount-1 do begin
          if TList(teamUsers[i]).Count = (cnt div teamCount) then begin
            if teamSums[i] < minSum then begin
              minId := i;
              minSum := teamSums[i];
            end;
          end;
        end;
        picked_user := 0;
        
        if ClansCheckBox.Checked then begin  // clanwise balancing - attempt to pick someone with same clan
	        APlayer := ranker.Items[0];
	        rank := APlayer^.rank;
	        temp.Clear;

          // get list of clans assigned to other teams
	        assignedClans.Clear;
	        for i:= 0 to teamClans.Count - 1 do begin
	          if i <> minId then begin
	            for j:=0 to TStrings(teamClans[i]).Count-1 do begin
	               assignedClans.Add(TStrings(teamClans[i]).Strings[j]);
	            end;
	          end;
	        end;

          // first try to get some with same clan
	        if TStrings(teamClans[minId]).Count >0 then begin
	            for i:=0 to ranker.Count -1 do begin
	              APlayer := ranker.Items[i];
	              if (temp.Count > 0) and (APlayer^.rank <> rank) then Break;
	              if (APlayer^.clan <> '') and Misc.Contains(APlayer^.clan,TStringList(teamClans[minId])) then begin
	                New(ptrInt);
	                ptrInt^ := i;
	                temp.Add(ptrInt);
	              end;
	            end;
	        end;

          // we dont have any candidates try to get clanner from unassigned clan
	        if temp.Count = 0 then begin
	          for i:= 0 to ranker.Count -1 do begin
	            APlayer := ranker.Items[i];
	            if (temp.Count > 0) and (APlayer^.rank <> rank) then Break;
	            if (APlayer^.clan <> '') and (not Misc.Contains(APlayer^.clan,assignedClans)) then begin
	                New(ptrInt);
	                ptrInt^ := i;
	                temp.Add(ptrInt);
	            end;
	          end;
	        end;

          // we still dont have any candidates try to get non-clanner
	        if temp.Count = 0 then begin
	          for i:=0 to ranker.Count -1 do begin
	            APlayer := ranker.Items[i];
	            if (temp.Count > 0) and (APlayer^.rank <> rank) then Break;
	            if (APlayer^.clan = '') then begin
	                New(ptrInt);
	                ptrInt^ := i;
	                temp.Add(ptrInt);
	            end;
	          end;
	        end;

          // if we have some candidates pick one randomly
	        if temp.Count > 0 then begin
	          ptrInt := temp[Random(temp.Count)];
	          picked_user := ptrInt^;
	        end;
	      end;

	      TList(teamUsers[minId]).add(ranker[picked_user]);
	      teamSums[minId] := teamSums[minId] + PPlayer(ranker[picked_user]).rank;

	      if ClansCheckBox.Checked and (PPlayer(ranker[picked_user]).clan <> '') then begin // if we work with clans add user's clan to clan list for his team
	        if not Contains(PPlayer(ranker[picked_user]).clan,TStringList(teamClans[minId])) then
	          TStrings(teamClans[minId]).Add(PPlayer(ranker[picked_user]).clan);
	      end;

	      ranker.Delete(picked_user);

	      cnt := cnt +1;

	  	end;

	  Groups := TList.Create;
    for i := 0 to teamCount-1 do
        Groups.Add(TList.Create);

	  for i:=0 to teamCount-1 do
      for j:=0 to TList(teamUsers[i]).Count-1 do
	      TList(Groups[i]).add(Clients[PPlayer(TList(teamUsers[i])[j]).id]);

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

  Groups := AutoSortTeams(Clients, ClansCheckBox.Checked, NumOfAlliesSpin.SpinOptions.ValueAsInteger, IFF(NoNewIdsCheckBox.Checked,1,Integer(PlayersPerCommSpin.SpinOptions.ValueAsInteger)));

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
        tmpLabel := AddLabel(tmpX, tmpY, TClient(TList(TList(Groups[i])[j])[k]).DisplayName);
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
  TeamCounter : integer;
begin
  if LastConfiguration = nil then Exit; // this should not really happen!

  if BattleState.Status <> Hosting then
  begin
    BattleForm.AddTextToChat(_('Unable to force ally/team numbers - only host allowed to force it!'), Colors.Info, 1);
    Exit;
  end;

  Groups := LastConfiguration;

  BattleForm.AddTextToChat(_('Forcing team/ally numbers ...'), Colors.Info, 1);

  try
    TeamCounter := 0;
    for i := 0 to Groups.Count-1 do
    begin
      for j := 0 to TList(Groups[i]).Count-1 do
      begin
        for k := 0 to TList(TList(Groups[i])[j]).Count-1 do
        begin
          if TClient(TList(TList(Groups[i])[j])[k]).GetAllyNo <> i then
            MainForm.TryToSendCommand('FORCEALLYNO', TClient(TList(TList(Groups[i])[j])[k]).Name + ' ' + IntToStr(i));
          if not NoNewIdsCheckBox.Checked and (TClient(TList(TList(Groups[i])[j])[k]).GetTeamNo <> TeamCounter) then
            MainForm.TryToSendCommand('FORCETEAMNO', TClient(TList(TList(Groups[i])[j])[k]).Name + ' ' + IntToStr(TeamCounter));
          if BattleForm.mnuBlockTeams.Checked then begin
            TClient(TList(TList(Groups[i])[j])[k]).SetAllyNo(i);
            TClient(TList(TList(Groups[i])[j])[k]).SetTeamNo(TeamCounter);
          end;
        end;
        Inc(TeamCounter);
      end;
    end;
  except
    BattleForm.AddTextToChat(_('Unable to force ally/team numbers (player list changed?) - try recreating the preview'), Colors.Error, 1);
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
  TranslateComponent(self);

  ScrollBox1.DoubleBuffered := True;
  Randomizer := TRandomizer.Create;
  NumOfAlliesSpin.SpinOptions.MinValue := 1;
  NumOfAlliesSpin.SpinOptions.MaxValue := MAX_TEAMS;
  PlayersPerCommSpin.SpinOptions.MinValue := 1;
  PlayersPerCommSpin.SpinOptions.MaxValue := MAX_TEAMS;

  NumOfAlliesSpin.Value := 2;
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

procedure TAutoTeamsForm.NumOfAlliesSpinValueChanged(Sender: TObject);
begin
  CreatePreview;
end;

procedure TAutoTeamsForm.PlayersPerCommSpinValueChanged(Sender: TObject);
begin
  CreatePreview;
end;

procedure TAutoTeamsForm.NoNewIdsCheckBoxClick(Sender: TObject);
begin
  SpTBXLabel2.Enabled := not NoNewIdsCheckBox.Checked;
  PlayersPerCommSpin.Enabled := not NoNewIdsCheckBox.Checked;
end;

end.
