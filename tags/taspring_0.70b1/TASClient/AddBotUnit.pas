unit AddBotUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TAddBotForm = class(TForm)
    AIComboBox: TComboBox;
    Label1: TLabel;
    ReloadButton: TSpeedButton;
    AddBotButton: TButton;
    Button2: TButton;
    BotNameEdit: TEdit;
    Label2: TLabel;
    BotTeamComboBox: TComboBox;
    BotAllyComboBox: TComboBox;
    BotTeamColorButton: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    BotSideComboBox: TComboBox;
    BotSideLabel: TLabel;

    procedure CreateParams(var Params: TCreateParams); override;
    
    procedure ReloadButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure AddBotButtonClick(Sender: TObject);
    procedure BotTeamColorButtonClick(Sender: TObject);
    procedure BotSideComboBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BotSideLabelClick(Sender: TObject);
  private
    procedure ChangeTeamColor(ColorIndex: Integer);
  public
    { Public declarations }
  end;

var
  AddBotForm: TAddBotForm;

implementation

uses
  ChooseColorFormUnit, Unit1, Misc, BattleFormUnit, PreferencesFormUnit,
  Utility;

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

  if FindFirst(ExtractFilePath(Application.ExeName) + 'aidll\globalai\*.dll', FileAttrs, sr) = 0 then
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
  Bot.SetSide(BotSideComboBox.ItemIndex);
  Bot.SetTeamNo(BotTeamComboBox.ItemIndex);
  Bot.SetAllyNo(BotAllyComboBox.ItemIndex);
  Bot.SetHandicap(0);
  Bot.SetTeamColor(BotColorIndex);
  BattleStatus := Bot.BattleStatus;
  Bot.Free;

  MainForm.TryToSendData('ADDBOT ' + BotNameEdit.Text + ' ' + IntToStr(BattleStatus) + ' '+ AIComboBox.Text);

  Close;
end;

procedure TAddBotForm.ChangeTeamColor(ColorIndex: Integer);
begin
  BotColorIndex := ColorIndex;
  with BotTeamColorButton.Glyph.Canvas do
  begin
    Pen.Color := TeamColors[BotColorIndex];
    Brush.Color := TeamColors[BotColorIndex];
    Rectangle(0+1, 0+1, BotTeamColorButton.Glyph.Width-2, BotTeamColorButton.Glyph.Height-2);
  end;
end;

procedure TAddBotForm.BotTeamColorButtonClick(Sender: TObject);
begin
  if not (ChooseColorForm.ShowModal = mrOK) then Exit;

  ChangeTeamColor(ChooseColorFormUnit.ColorIndex);
end;

procedure TAddBotForm.BotSideComboBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  // this ensures the correct highlite color is used
  (Control as TComboBox).Canvas.FillRect(Rect);

  MainForm.SideImageList.Draw((Control as TComboBox).Canvas, Rect.Left, Rect.Top, Index);
  (Control as TComboBox).Canvas.TextOut(Rect.Left + MainForm.SideImageList.Width + 3, Rect.Top, (Control as TComboBox).Items[Index]);
end;

procedure TAddBotForm.BotSideLabelClick(Sender: TObject);
begin
  BotSideComboBox.ItemIndex := (BotSideComboBox.ItemIndex + 1) mod SideList.Count;
end;

end.
