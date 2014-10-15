unit ChooseColorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const
{ TColor format: $00BBGGRR
  See TAPallete.cpp for color constants! }
  TeamColors: array[0..9] of TColor = (
    $00FF5A5A,
    $005050FF,
    $00FFFFFF,
    $0046DC46,
    $00DC0A0A,
    $00B40A96,
    $0000FFFF,
    $003C3C3C,
    $00FFBE8C,
    $0091A0A0
  );

type
  TChooseColorForm = class(TForm)
    CancelButton: TButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SpeedButtonClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  ChooseColorForm: TChooseColorForm;
  ColorIndex: Integer; // result (color that user picked) is stored here

implementation

uses
  Buttons, BattleFormUnit, PreferencesFormUnit;

{$R *.dfm}

procedure TChooseColorForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;
  
  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

procedure TChooseColorForm.FormCreate(Sender: TObject);
var
  i: Integer;
  b: TSpeedButton;
  GridWidth: Integer;
  ButtonSize: Integer; // width/height of the button
  ButtonMargin: Integer;
  Color: TColor;
begin
  GridWidth := 5; // number of buttons in a row
  ButtonSize := 20;
  ButtonMargin := 5;

  for i := 0 to High(TeamColors) do
  begin
    b := TSpeedButton.Create(ChooseColorForm);
    b.Width := ButtonSize;
    b.Height := ButtonSize;
    b.Left := (i mod GridWidth) * ButtonSize;
    b.Top := (i div GridWidth) * ButtonSize;
    b.Tag := i;
    b.OnClick := SpeedButtonClick;

    with b.Glyph do
    begin
      Width := ButtonSize;
      Height := ButtonSize;
      Color := TeamColors[i];
      if Color = $00FFFFFF then Dec(Color); // $00FFFFFF is also used as transparent color
      Canvas.Pen.Color := Color;
      Canvas.Brush.Color := Color;
      Canvas.Ellipse(0,  0, ButtonSize-3, ButtonSize-3);
    end;

    b.Parent := ChooseColorForm;
  end;

  ChooseColorForm.ClientWidth := ButtonSize * GridWidth;
  ChooseColorForm.ClientHeight := (High(TeamColors) div GridWidth + 1) * ButtonSize + ButtonMargin + CancelButton.Height + ButtonMargin;

  CancelButton.Left := ChooseColorForm.ClientWidth div 2 - CancelButton.Width div 2;
  CancelButton.Top := (High(TeamColors) div GridWidth + 1) * ButtonSize + ButtonMargin;
end;

procedure TChooseColorForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TChooseColorForm.SpeedButtonClick(Sender: TObject);
begin
  ColorIndex := (Sender as TComponent).Tag;
  ModalResult := mrOK;
end;

end.
