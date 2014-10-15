unit UpdateBotUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Unit1, janTracker;

type
  TUpdateBotForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    BotTeamComboBox: TComboBox;
    BotAllyComboBox: TComboBox;
    BotTeamColorButton: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    BotSideComboBox: TComboBox;
    BotSideLabel: TLabel;
    Button3: TButton;
    HandicapTracker: TjanTracker;
    Label1: TLabel;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure ShowModalEx(Bot: TBot);
    procedure ChangeTeamColor(ColorIndex: Integer);

    procedure Button2Click(Sender: TObject);
    procedure BotTeamColorButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BotSideLabelClick(Sender: TObject);
    procedure BotSideComboBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    Bot: TBot;
  public

  end;

var
  UpdateBotForm: TUpdateBotForm;

implementation

uses
  BattleFormUnit, PreferencesFormUnit, Utility;

var
  BotColorIndex: Integer;

{$R *.dfm}

procedure TUpdateBotForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

procedure TUpdateBotForm.ChangeTeamColor(ColorIndex: Integer);
begin
  BotColorIndex := ColorIndex;
  with BotTeamColorButton.Glyph.Canvas do
  begin
    Pen.Color := TeamColors[BotColorIndex];
    Brush.Color := TeamColors[BotColorIndex];
    Rectangle(0+1, 0+1, BotTeamColorButton.Glyph.Width-2, BotTeamColorButton.Glyph.Height-2);
  end;
end;

procedure TUpdateBotForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TUpdateBotForm.BotTeamColorButtonClick(Sender: TObject);
var
  ColorIndex: Integer;
begin
  ColorIndex := BattleForm.ChooseColorDialog(BotTeamColorButton, BotColorIndex);
  if ColorIndex = -1 then Exit;

  ChangeTeamColor(ColorIndex);
end;

procedure TUpdateBotForm.FormCreate(Sender: TObject);
begin
  ChangeTeamColor(0);
  Bot := TBot.Create('', '', '');
end;

procedure TUpdateBotForm.FormShow(Sender: TObject);
begin
  BotTeamComboBox.ItemIndex := Bot.GetTeamNo;
  BotAllyComboBox.ItemIndex := Bot.GetAllyNo;
  ChangeTeamColor(Bot.GetTeamColor);
  BotSideComboBox.ItemIndex := Bot.GetSide;
  HandicapTracker.Value := Bot.GetHandicap;
end;

procedure TUpdateBotForm.ShowModalEx(Bot: TBot);
begin
  Self.Bot.Assign(Bot);
  ShowModal;
end;

procedure TUpdateBotForm.BotSideLabelClick(Sender: TObject);
begin
  BotSideComboBox.ItemIndex := (BotSideComboBox.ItemIndex + 1) mod SideList.Count;
end;

procedure TUpdateBotForm.BotSideComboBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  // this ensures the correct highlite color is used
  (Control as TComboBox).Canvas.FillRect(Rect);

  MainForm.SideImageList.Draw((Control as TComboBox).Canvas, Rect.Left, Rect.Top, Index);
  (Control as TComboBox).Canvas.TextOut(Rect.Left + MainForm.SideImageList.Width + 3, Rect.Top, (Control as TComboBox).Items[Index]);
end;

procedure TUpdateBotForm.Button1Click(Sender: TObject);
var
  target: TBot;
begin
  Bot.SetTeamNo(BotTeamComboBox.ItemIndex);
  Bot.SetAllyNo(BotAllyComboBox.ItemIndex);
  Bot.SetTeamColor(BotColorIndex);
  Bot.SetSide(BotSideComboBox.ItemIndex);
  Bot.SetHandicap(HandicapTracker.Value);

  if BattleForm.IsBattleActive then
  begin
    target := MainForm.GetBot(Bot.Name, BattleState.Battle);
    if (target <> nil) and ((target.OwnerName = Status.Username) or (BattleState.Status = Hosting)) then
    begin
      // ok everything is OK, let's update it:
      MainForm.TryToSendData('UPDATEBOT ' + Bot.Name + ' ' + IntToStr(Bot.BattleStatus));
    end;
  end;

  Close;
end;

procedure TUpdateBotForm.Button3Click(Sender: TObject);
var
  target: TBot;
begin
  if BattleForm.IsBattleActive then
  begin
    target := MainForm.GetBot(Bot.Name, BattleState.Battle);
    if (target <> nil) and ((target.OwnerName = Status.Username) or (BattleState.Status = Hosting)) then
    begin
      // ok everything is OK, let's kick it:
      MainForm.TryToSendData('REMOVEBOT ' + Bot.Name);
    end;
  end;

  Close;
end;

end.
