unit HighlightingUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, JvExCheckLst, JvCheckListBox, Buttons,
  ExtCtrls, ComCtrls, StrUtils, JvExStdCtrls, JvCombobox, JvColorCombo,
  TntCheckLst, SpTBXEditors, SpTBXControls, SpTBXItem,TntComCtrls,
  RichEdit2, ExRichEdit, gnugettext;

type
  THighlight = record
    keyword: string;
    caseSensitive: boolean;
  end;

  PHighlight = ^THighlight;

  THighlightingForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    Label1: TSpTBXLabel;
    AddButton: TSpTBXSpeedButton;
    Image1: TImage;
    Label2: TSpTBXLabel;
    Label3: TSpTBXLabel;
    Label4: TSpTBXLabel;
    CloseButton: TSpTBXButton;
    HighlightsCheckListBox: TSpTBXCheckListBox;
    KeywordEdit: TSpTBXEdit;
    UseNotificationsCheckBox: TSpTBXCheckBox;
    HightlightColorPanel: TPanel;
    PickColorButton: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;
    function CheckLastLineForHighlights(RichEdit: TExRichEdit; ChatTextPos: Integer;LastLineStartPos:integer): Boolean;
    procedure CloseButtonClick(Sender: TObject);
    procedure SaveHighlightsToFile(FileName: string);
    procedure LoadHighlightsFromFile(FileName: string);
    procedure AddButtonClick(Sender: TObject);
    procedure HighlightsCheckListBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PickColorButtonClick(Sender: TObject);

  private
    { Private declarations }
  public
    function getHighlights: TList;
    procedure addHighlight(keyword: string; caseSensitive: Boolean);
    procedure clearHighlights;
  end;

var
  HighlightingForm: THighlightingForm;

implementation

uses PreferencesFormUnit, MainUnit, Math, Misc, BattleFormUnit;

{$R *.dfm}

procedure THighlightingForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure THighlightingForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure THighlightingForm.SaveHighlightsToFile(FileName: string);
var
  f: TextFile;
  i: Integer;
begin
  {$I+}
  try
    AssignFile(f, FileName);
    Rewrite(f);

    for i := 0 to HighlightsCheckListBox.Items.Count-1 do
    begin
      if HighlightsCheckListBox.Checked[i] then Write(f, #1) else Write(f, #0);
      Writeln(f, HighlightsCheckListBox.Items[i]);
    end;

    CloseFile(f);
  except
    Exit;
  end;
end;

procedure THighlightingForm.LoadHighlightsFromFile(FileName: string);
var
  f: TextFile;
  s: string;
  checked: Boolean;
begin
  {$I+}
  try
    AssignFile(f, FileName);
    Reset(f);

    while not Eof(f) do
    begin
      Readln(f, s);
      if s = '' then Continue;

      checked := s[1] = #1;
      s := Copy(s, 2, Length(s)-1);
      HighlightsCheckListBox.Items.Add(s);
      HighlightsCheckListBox.Checked[HighlightsCheckListBox.Items.Count-1] := checked;
    end;

    CloseFile(f);
  except
    Exit;
  end;
end;

procedure THighlightingForm.AddButtonClick(Sender: TObject);
begin
  HighlightsCheckListBox.Items.Add(KeywordEdit.Text);
  HighlightsCheckListBox.Checked[HighlightsCheckListBox.Items.Count-1] := True;
  KeywordEdit.Text := '';
end;

procedure THighlightingForm.HighlightsCheckListBoxKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if HighlightsCheckListBox.ItemIndex = -1 then Exit;

  if Key = VK_DELETE then
    HighlightsCheckListBox.Items.Delete(HighlightsCheckListBox.ItemIndex);
end;

// will highlight all keywords and automatically pop-up notifications (if set so).
// Returns TRUE if any word has been highlighted.
// For ChatTextPos argument, see Misc.AddTextToRichEdit's comments!
function THighlightingForm.CheckLastLineForHighlights(RichEdit: TExRichEdit; ChatTextPos: Integer;LastLineStartPos:integer): Boolean;
var
  i: Integer;
  sn, su: string; // string normal, string uppercase
  com: string; // base string
  currpos: Integer; // current position in the search string
  found: Integer;
  Highlights: array of TPoint; // dynamic array
  SelStart, SelLength: Integer;

  procedure AddHighlight(start, stop: Integer);
  var
    i: Integer;
  begin
    // first make sure this highlight does not collide with another highlight:
    for i := 0 to High(Highlights) do
      if ((start >= Highlights[i].X) and (start <= Highlights[i].Y))
      or ((stop >= Highlights[i].X) and (stop <= Highlights[i].Y))
      then Exit; // skip this highlight since it collides with another one

    SetLength(Highlights, Length(Highlights)+1);
    Highlights[Length(Highlights)-1].X := start;
    Highlights[Length(Highlights)-1].Y := stop;
  end;

  procedure SortHighlights; // will sort it by position
  var
    i, j: Integer;
    tmp: TPoint;
  begin
    if Length(Highlights) = 1 then Exit; // already sorted
    // simple bubble sort:
    for i := High(Highlights) downto 0 do
      for j := 0 to i-1 do
        if Highlights[j].X > Highlights[j+1].X then
        begin
          tmp := Highlights[j];
          Highlights[j] := Highlights[j+1];
          Highlights[j+1] := tmp;
        end;
  end;

begin
  Result := False;

  if HighlightsCheckListBox.Items.Count = 0 then Exit;

  SelStart := RichEdit.SelStart;
  SelLength := RichEdit.SelLength;

  RichEdit.SelStart := LastLineStartPos;
  RichEdit.SelLength := RichEdit.GetTextLen-LastLineStartPos;

  sn := RichEdit.WideSelText;
  su := UpperCase(sn);

  for i := 0 to HighlightsCheckListBox.Items.Count-1 do
  begin
    if HighlightsCheckListBox.Checked[i] then // case sensitive
    begin
      com := HighlightsCheckListBox.Items[i];
      currpos := ChatTextPos; // use 1 to search the entire line
      while True do
      begin
        found := PosEx(com, sn, currpos);
        if found = 0 then Break;
        // keyword found:
        AddHighlight(found, found + Length(com));
        currpos := found + Length(com);
        // trigger popup notificaton (if set so):
        if Preferences.UseNotificationsForHighlights and (not Application.Active) then MainForm.AddNotification('Keyword detected', 'Keyword: <' + HighlightsCheckListBox.Items[i] + '>', 2500);
      end;
    end
    else // not case-sensitive
    begin
      com := UpperCase(HighlightsCheckListBox.Items[i]);
      currpos := ChatTextPos; // use 1 to search the entire line
      while True do
      begin
        found := PosEx(com, su, currpos);
        if found = 0 then Break;
        // keyword found:
        AddHighlight(found, found + Length(com));
        currpos := found + Length(com);
        // trigger popup notificaton (if set so):
        if Preferences.UseNotificationsForHighlights and (not Application.Active) then MainForm.AddNotification('Keyword detected', 'Keyword: <' + HighlightsCheckListBox.Items[i] + '>', 2500);
      end;
    end
  end;

  // add highlights:
  if Length(Highlights) > 0 then
  begin
    Result := True;
    SortHighlights; // not really needed anymore, but anyway

    RichEdit.SelLength := 0;
    RichEdit.SelStart := Length(RichEdit.Text);

    for i := 0 to High(Highlights) do
    begin
      RichEdit.SelStart := Length(RichEdit.Text) - (Length(sn) - Highlights[i].X) - 1;
      RichEdit.SelLength := Highlights[i].Y - Highlights[i].X;
      RichEdit.SelAttributes.Color := HightlightColorPanel.Color;//HighlightingForm.JvColorComboBox1.Colors[Max(0, Misc.MapColorNameToIndex(Preferences.HighlightColor, HighlightingForm.JvColorComboBox1))];
      RichEdit.SelAttributes.Style := [fsUnderLine];
      RichEdit.SelLength := 0;
    end;
  end;

  RichEdit.SelStart := SelStart;
  RichEdit.SelLength := SelLength;
end;

procedure THighlightingForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure THighlightingForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  HighlightingForm.SaveHighlightsToFile(ExtractFilePath(Application.ExeName) + VAR_FOLDER + '\highlights.dat');
end;

procedure THighlightingForm.PickColorButtonClick(Sender: TObject);
begin
  HightlightColorPanel.Color := InputColor(_('Choose a color ...'),HightlightColorPanel.Color);
end;

function THighlightingForm.getHighlights: TList;
var
  i:integer;
  highlight: PHighlight;
begin
  Result := TList.Create;
  for i:=0 to HighlightsCheckListBox.Items.Count-1 do
  begin
    New(highlight);
    highlight.keyword := HighlightsCheckListBox.Items[i];
    highlight.caseSensitive := HighlightsCheckListBox.Checked[i];
    Result.Add(highlight);
  end;
end;

procedure THighlightingForm.addHighlight(keyword: string; caseSensitive: Boolean);
begin
  HighlightsCheckListBox.Items.Add(keyword);
  HighlightsCheckListBox.Checked[HighlightsCheckListBox.Count-1] := caseSensitive;
end;

procedure THighlightingForm.clearHighlights;
begin
  HighlightsCheckListBox.Clear;
end;

end.
