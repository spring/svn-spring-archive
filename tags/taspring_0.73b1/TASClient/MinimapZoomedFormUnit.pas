unit MinimapZoomedFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Utility;

type
  TMinimapZoomedForm = class(TForm)
    Image1: TImage;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure DrawStartPositions(MapInfo: TMapInfo);

    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MinimapZoomedForm: TMinimapZoomedForm;

implementation

uses BattleFormUnit, PreferencesFormUnit;

{$R *.dfm}

procedure TMinimapZoomedForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

procedure TMinimapZoomedForm.DrawStartPositions(MapInfo: TMapInfo);
var
  x, y: Integer;
  i: Integer;
  s: string;
begin

  with Image1.Canvas do
  begin
    Font.Color := clYellow;
    Font.Name := 'Fixedsys';
    Font.Size := Round(9);

    Pen.Color := clBlue;
    Brush.Color := clBlue;
  end;

  for i := 0 to MapInfo.PosCount-1 do
  begin
    x := Round(MapInfo.Positions[i].x / (MapInfo.Width * 8) * Image1.Picture.Bitmap.Width);
    y := Round(MapInfo.Positions[i].y / (MapInfo.Height * 8) * Image1.Picture.Bitmap.Height);
    s := IntToStr(i+1);

    with Image1.Canvas do
    begin
      Ellipse(x - 10, y - 10, x + 10, y + 10);
      TextOut(x - TextWidth(s) div 2, y - TextHeight(s) div 2, s);
    end;
  end;

end;

procedure TMinimapZoomedForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

procedure TMinimapZoomedForm.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then Close;
end;

procedure TMinimapZoomedForm.FormCreate(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
end;

end.
