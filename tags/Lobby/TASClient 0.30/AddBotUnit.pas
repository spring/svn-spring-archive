unit AddBotUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, TBXDkPanels, SpTBXControls, SpTBXEditors,
  TntStdCtrls, SpTBXItem;

type
  TAddBotForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    Label1: TSpTBXLabel;
    ReloadButton: TSpTBXSpeedButton;
    Label2: TSpTBXLabel;
    BotTeamColorButton: TSpTBXSpeedButton;
    Label3: TSpTBXLabel;
    Label4: TSpTBXLabel;
    AIComboBox: TSpTBXComboBox;
    AddBotButton: TSpTBXButton;
    Button2: TSpTBXButton;
    BotNameEdit: TSpTBXEdit;
    BotAllyButton: TTBXButton;
    BotTeamButton: TTBXButton;
    BotSideButton: TSpTBXSpeedButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure ChangeTeamColor(ColorIndex: Integer);
    procedure ChangeSide(SideIndex: Integer);

    procedure ReloadButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure AddBotButtonClick(Sender: TObject);
    procedure BotTeamColorButtonClick(Sender: TObject);
    procedure BotTeamButtonClick(Sender: TObject);
    procedure BotAllyButtonClick(Sender: TObject);
    procedure BotSideButtonClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  AddBotForm: TAddBotForm;

implementation

uses
  Unit1, Misc, BattleFormUnit, PreferencesFormUnit, Utility;

var
  BotColorIndex: Integer;

{$R *.dfm}

procedure TAddBotForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TAddBotForm.ReloadButtonClick(Sender: TObject);
var
  sr: TSearchRec;
  FileAttrs: Integer;
begin
  AIComboBox.Items.Clear;

  FileAttrs := faAnyFile;

  if FindFirst(ExtractFilePath(Application.ExeName) + AIDLL_FOLDER+ '/*.dll', FileAttrs, sr) = 0 then
  begin
    if (sr.Name <> '.') and (sr.Name <> '..') then
      AIComboBox.Items.Add(sr.Name);

    while FindNext(sr) = 0 do
      if (sr.Name <> '.') and (sr.Name <> '..') then
        AIComboBox.Items.Add(sr.Name);

    FindClose(sr);
  end;

  AddBotButton.Enabled := AIComboBox.Items.Count <> 0;
  if AIComboBox.Items.Count <> 0 then AIComboBox.ItemIndex := 0;
end;

procedure TAddBotForm.FormCreate(Sender: TObject);
begin
  ReloadButton.OnClick(nil);
  ChangeTeamColor(0);
  BotSideButton.Images := Utility.SideImageList;
end;

procedure TAddBotForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TAddBotForm.AddBotButtonClick(Sender: TObject);
var
  Bot: TBot;
  BattleStatus: Integer;
begin
  if not Misc.VerifyName(BotNameEdit.Text) then
  begin
    MessageDlg('Bad name. Please choose another!', mtInformation, [mbOK], 0);
    Exit;
  end;

  Bot := TBot.Create('', '', '');
  Bot.SetSide(BotSideButton.Tag);
  Bot.SetTeamNo(StrToInt(BotTeamButton.Caption)-1);
  Bot.SetAllyNo(StrToInt(BotAllyButton.Caption)-1);
  Bot.SetHandicap(0);
  BattleStatus := Bot.BattleStatus;
  Bot.Free;

  MainForm.TryToSendData('ADDBOT ' + BotNameEdit.Text + ' ' + IntToStr(BattleStatus) + ' ' + IntToStr(TeamColors[BotColorIndex]) + ' ' + AIComboBox.Text);

  Close;
end;

procedure TAddBotForm.ChangeTeamColor(ColorIndex: Integer);
begin
  BotColorIndex := ColorIndex;

  BotTeamColorButton.ImageIndex := Length(TeamColors) + ColorIndex; // draw squares rather than circles
end;

procedure TAddBotForm.ChangeSide(SideIndex: Integer);
begin
  BotSideButton.Caption := SideList[SideIndex];
  BotSideButton.ImageIndex := SideIndex;
  BotSideButton.Tag := SideIndex;
end;

procedure TAddBotForm.BotTeamColorButtonClick(Sender: TObject);
var
  ColorIndex: Integer;
begin
  ColorIndex := BattleForm.ChooseColorDialog(BotTeamColorButton, BotColorIndex);
  if ColorIndex = -1 then Exit;

  ChangeTeamColor(ColorIndex);
end;

procedure TAddBotForm.BotTeamButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := BattleForm.ChooseNumberDialog(Sender as TControl, StrToInt(BotTeamButton.Caption)-1);
  if Index = -1 then Exit;

  BotTeamButton.Caption := IntToStr(Index+1);
end;

procedure TAddBotForm.BotAllyButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := BattleForm.ChooseNumberDialog(Sender as TControl, StrToInt(BotAllyButton.Caption)-1);
  if Index = -1 then Exit;

  BotAllyButton.Caption := IntToStr(Index+1);
end;

procedure TAddBotForm.BotSideButtonClick(Sender: TObject);
var
  SideIndex: Integer;
begin
  SideIndex := BattleForm.ChooseSideDialog(Sender as TControl, BotSideButton.Tag);
  if SideIndex = -1 then Exit;

  ChangeSide(SideIndex);
end;

end.
