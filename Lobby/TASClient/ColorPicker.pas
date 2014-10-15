unit ColorPicker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,Misc, SpTBXItem, SpTBXControls, StdCtrls, TB2Item, TB2Dock,
  TB2Toolbar, SpTBXEditors, gnugettext;

type
  TColorPickerForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    SpTBXPanel1: TSpTBXPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    MainGradiant: TImage;
    SndGradiant: TImage;
    rdH: TSpTBXRadioButton;
    txtH: TSpTBXEdit;
    SpTBXLabel1: TSpTBXLabel;
    SpTBXLabel2: TSpTBXLabel;
    SpTBXLabel3: TSpTBXLabel;
    txtS: TSpTBXEdit;
    rdS: TSpTBXRadioButton;
    rdL: TSpTBXRadioButton;
    txtL: TSpTBXEdit;
    SpTBXLabel4: TSpTBXLabel;
    txtR: TSpTBXEdit;
    SpTBXLabel5: TSpTBXLabel;
    txtG: TSpTBXEdit;
    SpTBXLabel6: TSpTBXLabel;
    txtB: TSpTBXEdit;
    SpTBXLabel7: TSpTBXLabel;
    txtColorHex: TSpTBXEdit;
    btReset: TSpTBXButton;
    btCancel: TSpTBXButton;
    btDone: TSpTBXButton;
    ColorPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure SndGradiantMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SndGradiantMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SndGradiantMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainGradiantMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainGradiantMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainGradiantMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btResetClick(Sender: TObject);
    procedure txtColorHexKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btDoneClick(Sender: TObject);
    procedure txtBKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtGKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtRKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtHKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtSKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtLKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btCancelClick(Sender: TObject);
  private
    FSelectedColorIndex: Integer;
    isSndGradiantMouseDown: boolean;
    isMainGradiantMouseDown: boolean;
    currentHue: Integer;
    curMainX,curMainY,oldMainX,oldMainY,curSndY,oldSndY: Integer;
    procedure DrawGradient4(Hue: Integer;Fast : boolean);
    procedure DrawGradient4Mark(RefreshHSL,RefreshRGB : boolean);
    procedure DrawGradient2(s,e:integer);
    procedure DrawGradient2Mark;
    procedure RefreshHSLColor;
    procedure RefreshRGBColor;
  public

    procedure SetColor(Color : TColor);
    { Public declarations }
  end;

var
  ColorPickerForm: TColorPickerForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TColorPickerForm.FormCreate(Sender: TObject);
var
  t:TColor;
  i,j: integer;
begin
  TranslateComponent(self);

  isSndGradiantMouseDown := False;
  isMainGradiantMouseDown := False;
  curMainX := 0;
  curMainY := 0;
  curSndY := 0;
  FSelectedColorIndex := -1;
  DrawGradient2(0,360);
  DrawGradient2Mark;
  DrawGradient4(currentHue,False);
  DrawGradient4Mark(True,True);
end;

procedure TColorPickerForm.DrawGradient4(Hue: Integer;Fast : boolean);
var
  i,j:integer;
  H,S,L: integer;
  iStart,iEnd,jStart,jEnd : integer;
begin
  with MainGradiant do begin
    if Fast then begin
      iStart := Round(oldMainX/3)-3;
      iEnd := Round(oldMainX/3)+3;
      jStart := Round((300-oldMainY)/3)-3;
      jEnd := Round((300-oldMainY)/3)+3;
    end
    else
    begin
      iStart := 0;
      iEnd := 100;
      jStart := 0;
      jEnd := 100;
    end;
    for i:= iStart to iEnd do
      for j:=jStart to jEnd do begin
        Canvas.Brush.Color := Misc.HSL(Hue,i,j);
        Canvas.Brush.Style :=bsSolid ;
        Canvas.FillRect(Rect(i*3,(99-j)*3,i*3+3,(99-j)*3+3));
      end;
  end;
end;

procedure TColorPickerForm.DrawGradient4Mark(RefreshHSL,RefreshRGB : boolean);
var
  i:integer;
begin
  with MainGradiant do begin
    Canvas.Pen.Mode := pmNot;
    Canvas.Brush.Style := bsClear;
    Canvas.Ellipse(curMainX-5,curMainY-5,curMainX+5,curMainY+5);
    ColorPanel.Color := Misc.Hsl(currentHue,Round(curMainX/3),Round((300-curMainY)/3));
    ColorPanel.Refresh;
    Refresh;
  end;
  if RefreshHSL then begin
    txtH.Text := IntToStr(currentHue);
    txtH.Refresh;
    txtS.Text := IntToStr(Round(curMainX/3));
    txtS.Refresh;
    txtL.Text := IntToStr(Round((300-curMainY)/3));
    txtL.Refresh;
  end;
  if RefreshRGB then begin
    txtR.Text := IntToStr(Misc.ColorToR(ColorPanel.Color));
    txtR.Refresh;
    txtG.Text := IntToStr(Misc.ColorToG(ColorPanel.Color));
    txtG.Refresh;
    txtB.Text := IntToStr(Misc.ColorToB(ColorPanel.Color));
    txtB.Refresh;
    txtColorHex.Text := IntToHex(ColorToStandardRGB(ColorPanel.Color),6);
    txtColorHex.Refresh;
  end;
  if FSelectedColorIndex = -1 then Exit; // we haven't selected a color yet

  TeamColors[FSelectedColorIndex] := ColorPanel.Color;
  MainForm.UpdateColorImageList;
  //ColorToolbar.Repaint;
end;

procedure TColorPickerForm.DrawGradient2(s,e:integer);
var
  i:integer;
begin
  with SndGradiant do begin
    for i:=0 to 300  do begin
      Canvas.Brush.Color := Misc.HSL(Round(i*360/Canvas.ClipRect.Bottom),100,100);
      Canvas.FillRect(Rect(0,i,Canvas.ClipRect.Right,i+Round(Canvas.ClipRect.Bottom/360)));
    end;
  end;
end;

procedure TColorPickerForm.DrawGradient2Mark;
var
  i:integer;
begin
  DrawGradient2(oldSndY-2,oldSndY+2);
  with SndGradiant do begin
    Canvas.Pen.Mode := pmNot;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(Rect(0,curSndY-2,Canvas.ClipRect.Right,curSndY+2));
    Refresh;
  end;
end;

procedure TColorPickerForm.SndGradiantMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  isSndGradiantMouseDown := True;
  SndGradiantMouseMove(Sender,Shift,X,Y);
end;

procedure TColorPickerForm.SndGradiantMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if Y<0 then
    Y := 0;
  if X<0 then
    X :=0;
  if X>SndGradiant.Canvas.ClipRect.Right then
    X := SndGradiant.Canvas.ClipRect.Right;
  if Y>SndGradiant.Canvas.ClipRect.Bottom then
    Y := SndGradiant.Canvas.ClipRect.Bottom;
  if isSndGradiantMouseDown then begin
    currentHue := Round(Y*359/SndGradiant.Canvas.ClipRect.Bottom);
    oldSndY := curSndY;
    curSndY := Y;
    DrawGradient4(currentHue,False);
    DrawGradient4Mark(True,True);
    DrawGradient2Mark;
  end;
end;

procedure TColorPickerForm.SndGradiantMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  isSndGradiantMouseDown := False;
end;

procedure TColorPickerForm.MainGradiantMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if Y<0 then
    Y := 0;
  if X<0 then
    X :=0;
  if X>MainGradiant.Canvas.ClipRect.Right-1 then
    X := MainGradiant.Canvas.ClipRect.Right-1;
  if Y>MainGradiant.Canvas.ClipRect.Bottom-1 then
    Y := MainGradiant.Canvas.ClipRect.Bottom-1;
  if isMainGradiantMouseDown then begin
    oldMainX := curMainX;
    oldMainY := curMainY;
    curMainX := X;
    curMainY := Y;
    DrawGradient4(currentHue,True);
    DrawGradient4Mark(True,True);
  end;
end;

procedure TColorPickerForm.MainGradiantMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  isMainGradiantMouseDown := True;
  MainGradiantMouseMove(Sender,Shift,X,Y);
end;

procedure TColorPickerForm.MainGradiantMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  isMainGradiantMouseDown := False;
end;

procedure TColorPickerForm.btResetClick(Sender: TObject);
begin
  TeamColors := DefaultTeamColors;
  MainForm.UpdateColorImageList;
  //ColorToolbar.Repaint;
end;

{procedure TColorPickerForm.TBXColorPalette1CellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
begin
  FSelectedColorIndex := ACol + ARow * TBXColorPalette1.ColorSet.ColCount;
  txtR.Text := IntToStr(Misc.ColorToR(TBXColorPalette1.ColorSet.GetColor(ACol, ARow)));
  txtG.Text := IntToStr(Misc.ColorToG(TBXColorPalette1.ColorSet.GetColor(ACol, ARow)));
  txtB.Text := IntToStr(Misc.ColorToB(TBXColorPalette1.ColorSet.GetColor(ACol, ARow)));
  RefreshRGBColor;
end; *}

procedure TColorPickerForm.RefreshHSLColor;
var
  H,S,L : integer;
begin
  try
    H := StrToInt(txtH.Text);
    S := StrToInt(txtS.Text);
    L := StrToInt(txtL.Text);
  except
    Exit;
    //MessageDlg('H, S and L values must be whole numbers within a proper range H:(0..360) S,L:(0..100) ', mtError, [mbOK], 0);
  end;
    H := H mod 360;
    if S < 0 then
      S := 0;
    if S > 100 then
      S := 100;
    if L < 0 then
      L := 0;
    if L > 100 then
      L := 100;
    currentHue := H;
    curMainX := 3*S;
    curMainY := 3*(100-L);
    if curMainX = 300 then
      curMainX := 299;
    if curMainY = 300 then
      curMainY := 299;
    curSndY := Round(H*299/360);
    DrawGradient2Mark;
    DrawGradient4(currentHue,False);
    DrawGradient4Mark(False,True);
end;

procedure TColorPickerForm.RefreshRGBColor;
var
  R,G,B,H : integer;
  S,L : byte;
begin
  try
    R := StrToInt(txtR.Text);
    G := StrToInt(txtG.Text);
    B := StrToInt(txtB.Text);
  except
    Exit;
    //MessageDlg('R, G and B values must be whole numbers within a proper range (0..255)', mtError, [mbOK], 0);
  end;

    if R < 0 then
      R := 0;
    if R > 255 then
      R := 255;
    if G < 0 then
      G := 0;
    if G > 255 then
      G := 255;
    if B < 0 then
      B := 0;
    if B > 255 then
      B := 255;
    Misc.RgbToHsl(B,G,R,H,S,L);
    currentHue :=  H mod 360;
    curMainX := 3*S;
    curMainY := 3*(100-L);
    if curMainX > 299 then
      curMainX := 299;
    if curMainY > 299 then
      curMainY := 299;
    curSndY := Round(H*299/360);
    DrawGradient2Mark;
    DrawGradient4(currentHue,False);
    DrawGradient4Mark(True,False);
    txtColorHex.Text := IntToHex(R*65536+G*256+B,6);
end;

procedure TColorPickerForm.txtColorHexKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  Color : Integer;
begin
  if key = 13 then begin
    try
      Color := Misc.HexToInt(txtColorHex.Text);
    except
      MessageDlg(_('You must enter a valid hexadecimal number.'), mtError, [mbOK], 0);
      Exit;
    End;
    txtR.Text := IntToStr(Misc.ColorToB(Color));
    txtG.Text := IntToStr(Misc.ColorToG(Color));
    txtB.Text := IntToStr(Misc.ColorToR(Color));
    RefreshRGBColor;
  end;
end;

procedure TColorPickerForm.btDoneClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TColorPickerForm.SetColor(Color : TColor);
var
  i:integer;
begin
    txtR.Text := IntToStr(Misc.ColorToR(Color));
    txtG.Text := IntToStr(Misc.ColorToG(Color));
    txtB.Text := IntToStr(Misc.ColorToB(Color));
    RefreshRGBColor;
    for i:=0 to High(MainUnit.TeamColors) do
    if MainUnit.TeamColors[i] = Color then
    begin
      FSelectedColorIndex := i;
      Break;
    end;
end;

procedure TColorPickerForm.txtBKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    RefreshRGBColor;
end;

procedure TColorPickerForm.txtGKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    RefreshRGBColor;
end;

procedure TColorPickerForm.txtRKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    RefreshRGBColor;
end;

procedure TColorPickerForm.txtHKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  RefreshHSLColor;
end;

procedure TColorPickerForm.txtSKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  RefreshHSLColor;
end;

procedure TColorPickerForm.txtLKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  RefreshHSLColor;
end;

procedure TColorPickerForm.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
