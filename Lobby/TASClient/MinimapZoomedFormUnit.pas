unit MinimapZoomedFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Utility, DB, DBClient, TConnect;

type
  TMinimapZoomedForm = class(TForm)
    Image1: TImage;
    LocalConnection1: TLocalConnection;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure DrawStartPositions(MapInfo: TMapInfo;Image: TImage; TextSize: integer = 9);
    procedure DrawBoxes;
    procedure UpdateMinimap(minimapImg: TImage);
  end;

var
  MinimapZoomedForm: TMinimapZoomedForm;

implementation

uses BattleFormUnit, PreferencesFormUnit, gnugettext, MapListFormUnit, MainUnit;

{$R *.dfm}

procedure TMinimapZoomedForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TMinimapZoomedForm.DrawStartPositions(MapInfo: TMapInfo;Image: TImage; TextSize: integer = 9);
var
  x, y: Integer;
  i: Integer;
  s: string;
begin

  with Image.Canvas do
  begin
    Font.Color := clYellow;
    Font.Name := 'Fixedsys';
    Font.Size := Round(TextSize);
    Font.Style := [];
    Pen.Color := clBlack;
    Brush.Style := bsSolid;
    Brush.Color := clBlack;
    Pen.Mode := pmCopy
  end;

  for i := 0 to MapInfo.PosCount-1 do
  begin
    x := Round(MapInfo.Positions[i].x * Image.Picture.Bitmap.Width / (MapInfo.Width * 8) );
    y := Round(MapInfo.Positions[i].y * Image.Picture.Bitmap.Height / (MapInfo.Height * 8));
    s := IntToStr(i+1);

    with Image.Canvas do
    begin
      Ellipse(x - TextSize-1, y - TextSize-1, x + TextSize+1, y + TextSize+1);
      TextOut(x - TextWidth(s) div 2, y - TextHeight(s) div 2, s);
    end;
  end;
end;
procedure TMinimapZoomedForm.DrawBoxes;
var
  x, y: Integer;
  i: Integer;
  s: string;
  r: TRect;
begin

  for i := 0 to High(BattleState.StartRects) do
  begin
    if BattleState.StartRects[i].Enabled then
    begin
      with Image1.Canvas do
      begin
        Font.Name := 'Fixedsys';
        Font.Size := Round(9);
        Pen.Color := clRed;
        Pen.Mode := pmMergeNotPen;
        Font.Color := clWhite;
        Brush.Color := $0000FFFF; { 0 b g r }
        Brush.Style := bsSolid;
        r := Rect(Round(BattleState.StartRects[i].Rect.Left*Image1.Picture.Bitmap.Width/100),Round(BattleState.StartRects[i].Rect.Top*Image1.Picture.Bitmap.Height/100),Round(BattleState.StartRects[i].Rect.Right*Image1.Picture.Bitmap.Width/100),Round(BattleState.StartRects[i].Rect.Bottom*Image1.Picture.Bitmap.Height/100));
        Rectangle(r);

        s := IntToStr(i+1);
        Brush.Style := bsClear;
        Font.Style := [fsBold];

        TextOut((r.Left+r.Right) div 2 - TextWidth(s) div 2, (r.Top+r.Bottom) div 2 - TextHeight(s) div 2, s);
      end;
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
  TranslateComponent(self);
  
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
end;

procedure TMinimapZoomedForm.UpdateMinimap(minimapImg: TImage);
var
  currentMap: TMapItem;
begin
  currentMap := GetMapItem(BattleForm.CurrentMapIndex);

  with currentMap do
  begin
    if (MapInfo.Width = 0) or (MapInfo.Height = 0) then Exit;

    if MapInfo.Width/MapInfo.Height > Screen.WorkAreaWidth/Screen.WorkAreaHeight then
    begin
      MinimapZoomedForm.Width := Screen.WorkAreaWidth;
      ClientHeight := Round(ClientWidth * MapInfo.Height / MapInfo.Width);
      MinimapZoomedForm.Left := 0;
      MinimapZoomedForm.Top := Screen.WorkAreaHeight div 2 - MinimapZoomedForm.Height div 2;
    end
    else
    begin
      MinimapZoomedForm.Height := Screen.WorkAreaHeight;
      ClientWidth := Round(ClientHeight * MapInfo.Width / MapInfo.Height );
      MinimapZoomedForm.Left := Screen.WorkAreaWidth div 2 - MinimapZoomedForm.Width div 2;
      MinimapZoomedForm.Top := 0;
    end;
  end;

  Image1.Width := ClientWidth ;
  Image1.Height := ClientHeight;
  Image1.Picture.Bitmap.Width := ClientWidth;
  Image1.Picture.Bitmap.Height := ClientHeight;

  if Preferences.LoadMetalHeightMinimaps and not MainUnit.NO3D then
    Image1.Canvas.StretchDraw(Rect(0, 0, Image1.Width, Image1.Height), BattleForm.MapImage.Picture.Bitmap)
  else
    Image1.Canvas.StretchDraw(Rect(0, 0, Image1.Width, Image1.Height), minimapImg.Picture.Bitmap);

  DrawBoxes;
  DrawStartPositions(currentMap.MapInfo,Image1);
  Caption := _('Minimap (') + Utility.MapList[BattleForm.CurrentMapIndex] + ', ' + IntToStr(currentMap.MapInfo.Width div 64) + ' x ' + IntToStr(currentMap.MapInfo.Height div 64) + ')';
end;

end.
