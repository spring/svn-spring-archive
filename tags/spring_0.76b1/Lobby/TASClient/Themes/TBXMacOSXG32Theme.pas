unit TBXMacOSXG32Theme;

interface

{$I TB2Ver.inc}
{$I TBX.inc}

uses
  Windows, Messages, Graphics, TBXThemes, TBXDefaultTheme, ImgList,
  PngImage, GR32;

type
  TItemPart = (ipBody, ipText, ipFrame);
  TBtnItemState = (bisNormal, bisDisabled, bisSelected, bisPressed, bisHot,
    bisDisabledHot, bisSelectedHot, bisPopupParent);
  TMenuItemState = (misNormal, misDisabled, misHot, misDisabledHot);
  TWinFramePart = (wfpBorder, wfpCaption, wfpCaptionText);
  TWinFrameState = (wfsActive, wfsInactive);

  TTBXMacOSXg32Theme= class(TTBXDefaultTheme)//TTBXTheme)//
  private
//    FInterpolationMode: Integer;
    procedure EnlargeBitmap(Source:TBitmap32; Target:TCanvas; SourceRect, TargetRect:TRect; VSideSize:Integer=3; HSideSize:Integer=3); overload;
    procedure DrawImage(Source:TBitmap32; Target:TCanvas; SourceRect:TRect; x,y: Integer);
    Procedure DrawStripeBG(Target: TCanvas; R:TRect; AColor:TColor);
  protected
    { View/Window Colors }
    DockColor: TColor;
    MenuBarColor: TColor;
    ToolbarColor: TColor;
    StatusbarColor: TColor;
    PopupColor: TColor;
    DockPanelColor: TColor;
    PopupFrameColor: TColor;
    WinFrameColors: array [TWinFrameState, TWinFramePart] of TColor;
    PnlFrameColors: array [TWinFrameState, TWinFramePart] of TColor;
    MenuItemColors: array [TMenuItemState, TItemPart] of TColor;
    BtnItemColors: array [TBtnItemState, TItemPart] of TColor;
    SeparatorColor: TColor;
    PopupSeparatorColor:TColor;
    DefaultRoughness: Integer;
    procedure SetupColorCache; virtual;
    function GetPartColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart): TColor;
    function GetBtnColor(const ItemInfo: TTBXItemInfo; ItemPart: TItemPart): TColor;
  public
    constructor Create(const AName: string); override;
    destructor Destroy; override;

    function GetIntegerMetrics(Index: Integer): Integer; override;
    function GetItemColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function GetItemTextColor(const ItemInfo: TTBXItemInfo): TColor; override;
    function GetItemImageBackground(const ItemInfo: TTBXItemInfo): TColor; override;
    function GetViewColor(AViewType: Integer): TColor; override;

    procedure PaintBackgnd(Canvas: TCanvas; const ADockRect, ARect, AClipRect: TRect; AColor: TColor; Transparent: Boolean; AViewType: Integer); override;
    procedure PaintButton(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintDock(Canvas: TCanvas; const ClientRect, DockRect: TRect; DockPosition: Integer); override;
    procedure PaintDockPanelNCArea(Canvas: TCanvas; R: TRect; const DockPanelInfo: TTBXDockPanelInfo); override;
    procedure PaintDropDownArrow(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintComboArrow(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo);
    procedure PaintEditButton(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo; ButtonInfo: TTBXEditBtnInfo); override;
    procedure PaintEditFrame(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo; const EditInfo: TTBXEditInfo); override;
    procedure PaintFrameControl(Canvas: TCanvas; R: TRect; Kind, State: Integer; Params: Pointer); override;
    procedure PaintFloatingBorder(Canvas: TCanvas; const ARect: TRect; const WindowInfo: TTBXWindowInfo); override;
    procedure PaintImage(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList; ImageIndex: Integer); override;
    procedure PaintMenuItem(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo); override;
    procedure PaintMenuItemFrame(Canvas: TCanvas; const ARect: TRect; const ItemInfo: TTBXItemInfo); override;
    procedure PaintMDIButton(Canvas: TCanvas; ARect: TRect; const ItemInfo: TTBXItemInfo; ButtonKind: Cardinal); override;
    procedure PaintSeparator(Canvas: TCanvas; ARect: TRect; ItemInfo: TTBXItemInfo; Horizontal, LineSeparator: Boolean); override;
    procedure PaintToolbarNCArea(Canvas: TCanvas; R: TRect; const ToolbarInfo: TTBXToolbarInfo); override;
  public
//    property InterpolationMode: Integer read FInterpolationMode write FInterpolationMode default InterpolationModeNearestNeighbor;
  end;

Var
  HotColor, BaseColor, BaseShade: TColor;

implementation

uses
  TBXUtils, TB2Item, TB2Common, Classes, Controls, Forms, Commctrl,
  SysUtils, ActiveX, TBXUxThemes, Types;

{$R macr.RES}

type TGraphicAccess = class(TGraphic);

function PngObjectToBitmap32(APng: TPngObject; ADIB: TBitmap32): integer;
var
  i, j: integer;
  P: PColor32;
  A: PByte;
  ABmp: TBitmap;
  Canvas: TCanvas;
begin
  ABmp := TBitmap.Create;
  try
    // assign to the a bitmap
    APng.AssignTo(ABmp);

    // We now *draw* the bitmap to our bitmap.. this will clear alpha in places
    // where drawn.. so we can use it later
    ADib.SetSize(APng.Width, APng.Height);
    ADib.Clear(clBlack32);
    //ADib.Canvas.Draw(0,0, ABmp);
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := ADib.Handle;
      TGraphicAccess(ABmp).Draw(Canvas, Rect(0, 0, ADib.Width, ADib.Height));
    finally
      Canvas.Free;
    end;

    // Flip the alpha channel
    P := @ADib.Bits[0];
    for i := 0 to ADib.Width * ADib.Height - 1 do begin
      P^ := P^ XOR $FF000000;
      inc(P);
    end;

    // The previous doesn't handle bitwise alpha info, so we do that here
    for i := 0 to APng.Height - 1 do begin
      A := PByte(APng.AlphaScanLine[i]);
      if assigned(A) then begin
        P := @ADib.Bits[i * ADib.Width];
        for j := 0 to APng.Width - 1 do begin
          P^ := SetAlpha(P^, A^);
          inc(P); inc(A);
        end;
      end else
        break;
    end;

    // Arriving here means "all ok"
    Result := 1;
  finally
    //APng.Free;
    ABmp.Free;
  end;
end;

Var
  StockBitmap: TBitmap = nil;

Procedure DrawBitmap32Rect(AHDC:HDC; x,y: Integer; Bmp32:TBitmap32; const RSrc: TRect);
Var
  ImageWidth, ImageHeight: Integer;
  I, J: Integer;
  srcx, srcy:Integer;
  Src: PColor32;
  Dst: PColor;//^Cardinal;
  S, C, CBRB, CBG: Cardinal;
  Wt1, Wt2: Cardinal;
Begin
  If Not Assigned(StockBitmap) then
  Begin
    StockBitmap:= TBitmap.Create;
    StockBitmap.HandleType:= bmDIB;
    StockBitmap.PixelFormat:= pf32bit;
  End;
  ImageWidth := RSrc.Right - RSrc.Left;
  ImageHeight := RSrc.Bottom - RSrc.Top;
  {with Bmp32 do
  begin
    if Width < ImageWidth then ImageWidth := Width;
    if Height < ImageHeight then ImageHeight :=  Height;
  end;}
  StockBitmap.Width:= ImageWidth;
  StockBitmap.Height:= ImageHeight;
  BitBlt(StockBitmap.Canvas.Handle, 0, 0, ImageWidth, ImageHeight,
    AHDC, x, y, SRCCOPY);
  srcx:= RSrc.Left;
  srcy:= RSrc.Top;
  for J := 0 to ImageHeight - 1 do
  begin
    Src := Bmp32.PixelPtr[srcx+0, srcy+J];
    Dst := StockBitmap.ScanLine[J];
    for I := 0 to ImageWidth - 1 do
    begin
      S := Src^;
      Wt2:= (S and $FF000000) shr 24;
      Wt1:= 255-Wt2;

      CBRB := (Dst^ and $00FF00FF) * Wt1;
      CBG  := (Dst^ and $0000FF00) * Wt1;
      C := ((S and $FF00FF) * Wt2 + CBRB) and $FF00FF00 + ((S and $00FF00) * Wt2 + CBG) and $00FF0000;
      Dst^ := C shr 8;
      Inc(Src);
      Inc(Dst);
    end;
  end;  
  BitBlt(AHDC, x, y, ImageWidth, ImageHeight,
    StockBitmap.Canvas.Handle, 0, 0, SRCCOPY);
End;

Procedure DrawBitmap32(AHDC:HDC; const RDest: TRect; Bmp32:TBitmap32);
Var
  ImageWidth, ImageHeight: Integer;
  I, J: Integer;
  Src: PColor32;
  Dst: PColor;//^Cardinal;
  S, C, CBRB, CBG: Cardinal;
  Wt1, Wt2: Cardinal;
Begin
  If Not Assigned(StockBitmap) then
  Begin
    StockBitmap:= TBitmap.Create;
    StockBitmap.HandleType:= bmDIB;
    StockBitmap.PixelFormat:= pf32bit;
  End;
  ImageWidth := RDest.Right - RDest.Left;
  ImageHeight := RDest.Bottom - RDest.Top;
  with Bmp32 do
  begin
    if Width < ImageWidth then ImageWidth := Width;
    if Height < ImageHeight then ImageHeight :=  Height;
  end;
  StockBitmap.Width:= ImageWidth;
  StockBitmap.Height:= ImageHeight;
  BitBlt(StockBitmap.Canvas.Handle, 0, 0, ImageWidth, ImageHeight,
    AHDC, RDest.Left, RDest.Top, SRCCOPY);
  for J := 0 to ImageHeight - 1 do
  begin
    Src := Bmp32.PixelPtr[0, J];
    Dst := StockBitmap.ScanLine[J];
    for I := 0 to ImageWidth - 1 do
    begin
      S := Src^;
      Wt2:= (S and $FF000000) shr 24;
      Wt1:= 255-Wt2;

      CBRB := (Dst^ and $00FF00FF) * Wt1;
      CBG  := (Dst^ and $0000FF00) * Wt1;
      C := ((S and $FF00FF) * Wt2 + CBRB) and $FF00FF00 + ((S and $00FF00) * Wt2 + CBG) and $00FF0000;
      Dst^ := C shr 8;
      Inc(Src);
      Inc(Dst);
    end;
  end;  
  BitBlt(AHDC, RDest.Left, RDest.Top, ImageWidth, ImageHeight,
    StockBitmap.Canvas.Handle, 0, 0, SRCCOPY);
End;

{ TTBXSimpleTheme }

Const
  FStretchFilter= sfLanczos;//sfNearest;//sfLinear;//sfMitchell;//sfSpline;//

Type
  TDrawStyle = (bsDefault, bsHover, bsDisabled, bsPushed, bsSelected, bsSelectedHover);
  TCheckStatus = (cNone, cChecked, cMixed);

var
  StockBitmap321: TBitmap32 = nil;
  StockBitmap322: TBitmap32 = nil;
  {StockImgList: TImageList;
  StockPatternBitmap: TBitmap;}
  RadioM: TBitmap32 = nil;
  CheckM: TBitmap32 = nil;
  //BOTON: TBitmap32 = nil;
  BOTON: TBitmap32;
//  COMBOBUTTONGLYPH2: TBitmap32 = nil;
  MDICLOSE: TBitmap32 = nil;

  COMBOBOX : TBitmap32 = nil;
  SPINBUTTONBACKGROUNDRIGHT : TBitmap32 = nil;
  //TOOLBARBUTTONSImage : TBitmap32;
  TOOLBARBUTTONS: TBitmap32 = nil;
  TOOLBARBUTTONSSPLIT: TBitmap32 = nil;
  TOOLBARBUTTONSSPLITDROPDOWN: TBitmap32 = nil;
  SPINBUTTONBACKGROUNDUP: TBitmap32 = nil;
  SPINBUTTONBACKGROUNDDOWN: TBitmap32 = nil;
  CLOSEGLYPH: TBitmap32 = nil;
  MINIMIZEGLYPH: TBitmap32 = nil;
  MAXIMIZEGLYPH: TBitmap32 = nil;
//  TOOLBARBUTTONSSPLITDROPDOWNGLYPH: TBitmap32 = nil;
  CounterLock: Integer = 0;

procedure InitializeStock;
var
  ResStream: TResourceStream;
  P:TPngObject;
begin
  If Not Assigned(StockBitmap321) then
  Begin
    StockBitmap321:= TBitmap32.Create;
    StockBitmap321.DrawMode:=dmBlend;
    StockBitmap321.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(StockBitmap322) then
  Begin
    StockBitmap322:= TBitmap32.Create;
    StockBitmap322.DrawMode:=dmBlend;
    StockBitmap322.StretchFilter:= FStretchFilter;
  End;

  P:=TPngObject.Create;
  If Not Assigned(RadioM) then
  Begin
    ResStream := TResourceStream.Create(HInstance, 'RADIOM', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    RadioM:= TBitmap32.Create;
    PngObjectToBitmap32(P, RadioM);
    RadioM.DrawMode:=dmBlend;
    RadioM.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(CheckM) then
  Begin
    ResStream := TResourceStream.Create(HInstance, 'CHECKM', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    CheckM:= TBitmap32.Create;
    PngObjectToBitmap32(P, CheckM);
    CheckM.DrawMode:=dmBlend;
    CheckM.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(BOTON) then
  Begin
    ResStream := TResourceStream.Create(HInstance, 'BOTON', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    BOTON:= TBitmap32.Create;
    PngObjectToBitmap32(P, BOTON);
    BOTON.DrawMode:=dmBlend;
    BOTON.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(TOOLBARBUTTONS) then
  Begin
    ResStream := TResourceStream.Create(HInstance, 'TOOLBARBUTTONS', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    TOOLBARBUTTONS:= TBitmap32.Create;
    PngObjectToBitmap32(P, TOOLBARBUTTONS);
    TOOLBARBUTTONS.DrawMode:=dmBlend;
    TOOLBARBUTTONS.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(TOOLBARBUTTONSSPLIT) then
  Begin
    ResStream := TResourceStream.Create(HInstance, 'TOOLBARBUTTONSSPLIT', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    TOOLBARBUTTONSSPLIT:= TBitmap32.Create;
    PngObjectToBitmap32(P, TOOLBARBUTTONSSPLIT);
    TOOLBARBUTTONSSPLIT.DrawMode:=dmBlend;
    TOOLBARBUTTONSSPLIT.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(TOOLBARBUTTONSSPLITDROPDOWN) then
  Begin
    ResStream := TResourceStream.Create(HInstance, 'TOOLBARBUTTONSSPLITDROPDOWN', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    TOOLBARBUTTONSSPLITDROPDOWN:= TBitmap32.Create;
    PngObjectToBitmap32(P, TOOLBARBUTTONSSPLITDROPDOWN);
    TOOLBARBUTTONSSPLITDROPDOWN.DrawMode:=dmBlend;
    TOOLBARBUTTONSSPLITDROPDOWN.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(SPINBUTTONBACKGROUNDRIGHT) then
  Begin
    ResStream := TResourceStream.Create(HInstance, 'SPINBUTTONBACKGROUNDRIGHT', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    SPINBUTTONBACKGROUNDRIGHT:= TBitmap32.Create;
    PngObjectToBitmap32(P, SPINBUTTONBACKGROUNDRIGHT);
    SPINBUTTONBACKGROUNDRIGHT.DrawMode:=dmBlend;
    SPINBUTTONBACKGROUNDRIGHT.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(COMBOBOX) then
  Begin
    ResStream:= TResourceStream.Create(HInstance, 'COMBOBOX', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    COMBOBOX:= TBitmap32.Create;
    PngObjectToBitmap32(P, COMBOBOX);
    COMBOBOX.DrawMode:=dmBlend;
    COMBOBOX.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(MDICLOSE) then
  Begin
    ResStream:= TResourceStream.Create(HInstance, 'MDICLOSE', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    MDICLOSE:= TBitmap32.Create;
    PngObjectToBitmap32(P, MDICLOSE);
    MDICLOSE.DrawMode:=dmBlend;
    MDICLOSE.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(SPINBUTTONBACKGROUNDUP) then
  Begin
    ResStream:= TResourceStream.Create(HInstance, 'SPINBUTTONBACKGROUNDUP', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    SPINBUTTONBACKGROUNDUP:= TBitmap32.Create;
    PngObjectToBitmap32(P, SPINBUTTONBACKGROUNDUP);
    SPINBUTTONBACKGROUNDUP.DrawMode:=dmBlend;
    SPINBUTTONBACKGROUNDUP.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(SPINBUTTONBACKGROUNDDOWN) then
  Begin
    ResStream:= TResourceStream.Create(HInstance, 'SPINBUTTONBACKGROUNDDOWN', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    SPINBUTTONBACKGROUNDDOWN:= TBitmap32.Create;
    PngObjectToBitmap32(P, SPINBUTTONBACKGROUNDDOWN);
    SPINBUTTONBACKGROUNDDOWN.DrawMode:=dmBlend;
    SPINBUTTONBACKGROUNDDOWN.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(CLOSEGLYPH) then
  Begin
    ResStream:= TResourceStream.Create(HInstance, 'CLOSEGLYPH', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    CLOSEGLYPH:= TBitmap32.Create;
    PngObjectToBitmap32(P, CLOSEGLYPH);
    CLOSEGLYPH.DrawMode:=dmBlend;
    CLOSEGLYPH.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(MINIMIZEGLYPH) then
  Begin
    ResStream:= TResourceStream.Create(HInstance, 'MINIMIZEGLYPH', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    MINIMIZEGLYPH:= TBitmap32.Create;
    PngObjectToBitmap32(P, MINIMIZEGLYPH);
    MINIMIZEGLYPH.DrawMode:=dmBlend;
    MINIMIZEGLYPH.StretchFilter:= FStretchFilter;
  End;
  If Not Assigned(MAXIMIZEGLYPH) then
  Begin
    ResStream:= TResourceStream.Create(HInstance, 'MAXIMIZEGLYPH', RT_RCDATA);
    P.LoadFromStream(ResStream);
    ResStream.Free;
    MAXIMIZEGLYPH:= TBitmap32.Create;
    PngObjectToBitmap32(P, MAXIMIZEGLYPH);
    MAXIMIZEGLYPH.DrawMode:=dmBlend;
    MAXIMIZEGLYPH.StretchFilter:= FStretchFilter;
  End;
  P.Free;
end;

procedure FinalizeStock;
begin
end;

procedure DrawCaptionArea(DC: HDC; R: TRect; Color: TColor; Vertical: Boolean);
var
  T: Integer;
begin
  if Vertical then
  begin
    T := (2 * R.Top + R.Bottom) div 3;
    GradFill(DC, Rect(R.Left, R.Top, R.Right, T), Lighten(Color, 24), Color, gkVert);
    GradFill(DC, Rect(R.Left, T, R.Right, R.Bottom), Color, Lighten(Color, -8), gkVert);
  end
  else
  begin
    T := (2 * R.Left + R.Right) div 3;
    GradFill(DC, Rect(R.Left, R.Top, T, R.Bottom), Lighten(Color, 24), Color, gkHorz);
    GradFill(DC, Rect(T, R.Top, R.Right, R.Bottom), Color, Lighten(Color, -8), gkHorz);
  end;
end;

constructor TTBXMacOSXg32Theme.Create(const AName: string);
begin
  inherited;
  if CounterLock = 0 then InitializeStock;
  Inc(CounterLock);
//  FInterpolationMode:= InterpolationModeHighQuality;//InterpolationModeHighQualityBicubic;//InterpolationModeNearestNeighbor;//
  SetupColorCache;
end;

destructor TTBXMacOSXg32Theme.Destroy;
begin
  Dec(CounterLock);
  if CounterLock = 0 then FinalizeStock;
  inherited;
end;

procedure TTBXMacOSXg32Theme.DrawImage(Source: TBitmap32; Target: TCanvas;
  SourceRect:TRect; x, y: Integer);
begin
  //DrawBitmap32(Target.Handle, Rect(x,y,x+Source.
  DrawBitmap32Rect(Target.Handle, x,y, Source, SourceRect);

{  graphic:= TGPgraphics.Create(Target.Handle);
  //graphic.SetInterpolationMode(FInterpolationMode);
  With SourceRect do
    graphic.DrawImage(Source,x,y,
      Left,Top,Right-Left,Bottom-Top,UnitPixel);
  graphic.Free;{}
end;

procedure TTBXMacOSXg32Theme.DrawStripeBG(Target: TCanvas; R: TRect; AColor:TColor);
const
  STRIPE_STEP = 4; {3}
var
  Y, I: Integer;
  HighlightColor,ShadowColor:TColor;
  DC: HDC;
Begin
  DC:= Target.Handle;

  I := ColorIntensity(AColor);
  if I < 200 then I := (200 - I) div 20
  else I := 0;
  HighlightColor := GetNearestColor(DC, Lighten(AColor, 11 + I));
  ShadowColor := GetNearestColor(DC, Lighten(AColor, -8)); {8}

  //if not Transparent then
  begin
    {Target.Brush.Color := AColor;
    Target.FillRect(R);}
    FillRectEx(DC, R, AColor);
  end;


    Y:= R.Top mod (STRIPE_STEP);
    Y := R.Top - Y;
    while Y < R.Bottom do
    begin
      DrawLineEx(DC, R.Left, Y, R.Right, Y, ShadowColor);
      Inc(Y, 2);
      DrawLineEx(DC, R.Left, Y, R.Right, Y, HighlightColor);
      Inc(Y, 2);
    end;


{  Y:= R.Top mod (STRIPE_STEP*2);
  Y := R.Top - Y;
  R1:= Rect(R.Left,Y,R.Right,Y+STRIPE_STEP);
  while R1.Bottom< R.Bottom do
  begin
    FillRectEx(DC,R1,HighlightColor);
    OffsetRect(R1,0,STRIPE_STEP);
//    Inc(Y,STRIPE_STEP);
    FillRectEx(DC,R1,ShadowColor);
    OffsetRect(R1,0,STRIPE_STEP);
//    Inc(Y,STRIPE_STEP);
  end;}
end;

procedure TTBXMacOSXg32Theme.EnlargeBitmap(Source: TBitmap32; Target: TCanvas;
  SourceRect, TargetRect: TRect; VSideSize, HSideSize: Integer);
Var
  R1:TRect;
  R2:TRect;
  tv2, th2: Integer;
  trgWidth, trgHeight: Integer;
  srcWidth, srcHeight: Integer;
begin
  srcWidth:= SourceRect.Right-SourceRect.Left;
  srcHeight:= SourceRect.Bottom-SourceRect.Top;
  If srcWidth-HSideSize*2<2 then
    HSideSize:=(srcWidth div 2)-1;
  If srcHeight-VSideSize*2<2 then
    VSideSize:=(srcHeight div 2)-1;

  trgWidth := TargetRect.Right- TargetRect.Left;
  trgHeight:= TargetRect.Bottom-TargetRect.Top;
  tv2:= trgHeight div 2;
  tv2:= Min(tv2, VSideSize);
  th2:= trgWidth div 2;
  th2:= Min(th2, HSideSize);
  StockBitmap321.SetSize(trgWidth, trgHeight);
  StockBitmap321.Clear($00000000);
  With SourceRect do
  Begin
    //Source.DrawTo(StockBitmap321, StockBitmap321.BoundsRect, SourceRect);
    // center
    r1:= Rect(th2,tv2,trgWidth-th2,trgHeight-tv2);
    r2:= Rect(Left+HSideSize,Top+VSideSize,Right-HSideSize,Bottom-VSideSize);
    Source.DrawTo(StockBitmap321, R1, R2);
    // left
    r1:= Rect(0,tv2,th2,trgHeight-tv2);
    r2:= Rect(Left,Top+VSideSize,Left+HSideSize,Bottom-VSideSize);
    Source.DrawTo(StockBitmap321, R1, R2);
    // top
    r1:= Rect(th2,0,trgWidth-th2,tv2);
    r2:= Rect(Left+HSideSize,Top,Right-HSideSize,Top+VSideSize);
    Source.DrawTo(StockBitmap321, R1, R2);
    // right
    r1:= Rect(trgWidth-th2,tv2,trgWidth,trgHeight-tv2);
    r2:= Rect(Right-HSideSize,Top+VSideSize,Right,Bottom-VSideSize);
    Source.DrawTo(StockBitmap321, R1, R2);
    // bottom
    r1:= Rect(th2,trgHeight-tv2,trgWidth-th2,trgHeight);
    r2:= Rect(Left+HSideSize,Bottom-VSideSize,Right-HSideSize,Bottom);
    Source.DrawTo(StockBitmap321, R1, R2);
    // left top
    r1:= Rect(0, 0, th2, tv2);
    r2:= Rect(Left,Top,Left+HSideSize,Top+VSideSize);
    Source.DrawTo(StockBitmap321, R1, R2);
    // right top
    r1:= Rect(trgWidth-th2, 0, trgWidth, tv2);
    r2:= Rect(Right-HSideSize,Top,Right,Top+VSideSize);
    Source.DrawTo(StockBitmap321, R1, R2);
    // left bottom
    r1:= Rect(0, trgHeight-tv2, th2, trgHeight);
    r2:= Rect(Left,Bottom-VSideSize,Left+HSideSize,Bottom);
    Source.DrawTo(StockBitmap321, R1, R2);
    // right bottom
    r1:= Rect(trgWidth-th2,trgHeight-tv2, trgWidth, trgHeight);
    r2:= Rect(Right-HSideSize,Bottom-VSideSize,Right,Bottom);
    Source.DrawTo(StockBitmap321, R1, R2);
  End;
  DrawBitmap32(Target.Handle, TargetRect, StockBitmap321);
end;

function TTBXMacOSXg32Theme.GetBtnColor(const ItemInfo: TTBXItemInfo;
  ItemPart: TItemPart): TColor;
const
  BFlags1: array[Boolean] of TBtnItemState = (bisDisabled, bisDisabledHot);
  BFlags2: array[Boolean] of TBtnItemState = (bisSelected, bisSelectedHot);
  BFlags3: array[Boolean] of TBtnItemState = (bisNormal, bisHot);
var
  B: TBtnItemState;
  Embedded: Boolean;
begin
  with ItemInfo do
  begin
    Embedded := (ViewType and VT_TOOLBAR = VT_TOOLBAR) and
      (ViewType and TVT_EMBEDDED = TVT_EMBEDDED);
    if not Enabled then B := BFlags1[HoverKind = hkKeyboardHover]
    else if ItemInfo.IsPopupParent then
      B := bisPopupParent
    else if Pushed then B := bisPressed
    else if Selected then B := BFlags2[HoverKind <> hkNone]
    else B := BFlags3[HoverKind <> hkNone];
    Result := BtnItemColors[B, ItemPart];
    if Embedded then
    begin
      if (ItemPart = ipBody) and (Result = clNone) then Result := ToolbarColor;
      if ItemPart = ipFrame then
      begin
        if Selected then Result := clWindowFrame
        else if (Result = clNone) then Result := clBtnShadow;
      end;
    end;
  end;
end;

function TTBXMacOSXg32Theme.GetIntegerMetrics(Index: Integer): Integer;
begin
  case Index of
    TMI_EDIT_BTNWIDTH: Result := 18;
  else
    Result := Inherited GetIntegerMetrics(Index);
  end;
end;

function TTBXMacOSXg32Theme.GetItemColor(
  const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetPartColor(ItemInfo, ipBody);
  if Result = clNone then Result := GetViewColor(ItemInfo.ViewType);
end;

function TTBXMacOSXg32Theme.GetItemImageBackground(
  const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetBtnColor(ItemInfo, ipBody);
  if Result = clNone then result := GetViewColor(ItemInfo.ViewType);
end;

function TTBXMacOSXg32Theme.GetItemTextColor(
  const ItemInfo: TTBXItemInfo): TColor;
begin
  Result := GetPartColor(ItemInfo, ipText);
end;

function TTBXMacOSXg32Theme.GetPartColor(const ItemInfo: TTBXItemInfo;
  ItemPart: TItemPart): TColor;
const
  MFlags1: array[Boolean] of TMenuItemState = (misDisabled, misDisabledHot);
  MFlags2: array[Boolean] of TMenuItemState = (misNormal, misHot);
  BFlags1: array[Boolean] of TBtnItemState = (bisDisabled, bisDisabledHot);
  BFlags2: array[Boolean] of TBtnItemState = (bisSelected, bisSelectedHot);
  BFlags3: array[Boolean] of TBtnItemState = (bisNormal, bisHot);
var
  IsMenuItem, Embedded: Boolean;
  M: TMenuItemState;
  B: TBtnItemState;
begin
  with ItemInfo do
  begin
    IsMenuItem := ((ViewType and PVT_POPUPMENU) = PVT_POPUPMENU) and
      ((ItemOptions and IO_TOOLBARSTYLE) = 0);
    Embedded := ((ViewType and VT_TOOLBAR) = VT_TOOLBAR) and
      ((ViewType and TVT_EMBEDDED) = TVT_EMBEDDED);
    if IsMenuItem then
    begin
      if not Enabled then M := MFlags1[HoverKind = hkKeyboardHover]
      else M := MFlags2[HoverKind <> hkNone];
      Result := MenuItemColors[M, ItemPart];
    end
    else
    begin
      if not Enabled then B := BFlags1[HoverKind = hkKeyboardHover]
      else if ItemInfo.IsPopupParent then B := bisPopupParent
      else if Pushed then B := bisPressed
      else if Selected then B := BFlags2[HoverKind <> hkNone]
      else B := BFlags3[HoverKind <> hkNone];
      Result := BtnItemColors[B, ItemPart];
      if Embedded and (Result = clNone) then
      begin
        if ItemPart = ipBody then Result := ToolbarColor;
        if ItemPart = ipFrame then Result := clBtnShadow;
      end;
    end;
  end;
end;

function TTBXMacOSXg32Theme.GetViewColor(AViewType: Integer): TColor;
begin
  Result := clBtnFace;
  if (AViewType and VT_TOOLBAR) = VT_TOOLBAR then
  begin
    if (AViewType and TVT_MENUBAR) = TVT_MENUBAR then Result := MenubarColor
    else Result := ToolbarColor;
  end
  else if (AViewType and VT_POPUP) = VT_POPUP then
  begin
    if (AViewType and PVT_LISTBOX) = PVT_LISTBOX then Result := clWindow
    else Result := PopupColor;
  end
  else if (AViewType and VT_DOCKPANEL) = VT_DOCKPANEL then Result := DockPanelColor;
end;

procedure TTBXMacOSXg32Theme.PaintBackgnd(Canvas: TCanvas; const ADockRect,
  ARect, AClipRect: TRect; AColor: TColor; Transparent: Boolean;
  AViewType: Integer);
var
  R: TRect;
begin
  if TBXLoColor then inherited
  else with Canvas do
    begin
      IntersectRect(R, ARect, AClipRect);
      {if not Transparent then
      begin
        Brush.Color := AColor;
        FillRect(R);
      end;}
      DrawStripeBG(Canvas, R, AColor);
    end;
end;

procedure TTBXMacOSXg32Theme.PaintButton(Canvas: TCanvas; const ARect: TRect;
  const ItemInfo: TTBXItemInfo);
var
//  DC: HDC;
  R: TRect;
//  C: TColor;
  ShowHover, Embedded: Boolean;
//  RL, RR: Integer;
  DrawStyle: TDrawStyle;
//  State: TBtnItemState;
  y, yInc, yStart: Integer;
  biRect:TRect;
begin
//  DC := Canvas.Handle;
  R := ARect;
  with ItemInfo, Canvas do
  begin
//    State:= bisNormal;
    DrawStyle:= bsDefault;
    If Not Enabled then
      DrawStyle:= bsDisabled
    Else If Pushed then
      DrawStyle:= bsPushed
    Else If (HoverKind <> hkNone) and (Not Selected) then
      DrawStyle:= bsHover
    Else If Selected then
      If (HoverKind <> hkNone) then
        DrawStyle:= bsSelectedHover
      Else
        DrawStyle:= bsSelected
    ;

    //Brush.Style:= bsClear;//bsSolid;//
//    graphic:= TGPgraphics.Create(Canvas.Handle);
    Embedded := (ViewType and VT_TOOLBAR = VT_TOOLBAR) and
      (ViewType and TVT_EMBEDDED = TVT_EMBEDDED);
    ShowHover := (Enabled and (HoverKind <> hkNone)) or
      (not Enabled and (HoverKind = hkKeyboardHover));
    If ((ViewType and TVT_MENUBAR) = TVT_MENUBAR) then
    Begin
      if ((Pushed or Selected) and Enabled) or ShowHover then
        //PaintBackgnd(Canvas, RECT(0,0,0,0), ARect, ARect, 0, False, VT_UNKNOWN);
        DrawStripeBG(Canvas, ARect, MenuItemColors[misHot, ipBody]);
    End else
    if ComboPart = cpSplitRight then
    Begin
      // DropDown Right
      yStart:= 0;
      yInc:= TOOLBARBUTTONSSPLITDROPDOWN.Height div 6;
      y:=0;
      Case DrawStyle of
        bsDefault:       If Embedded then  y:= 1 Else y:= 0;
        bsHover:         y:= 1;
        bsDisabled:      y:= 3;
        bsPushed:        y:= 5;
        bsSelected:      y:= 4;
        bsSelectedHover: y:= 5;
      End;//CASE
      biRect:= Rect(0,yStart+yInc*y,TOOLBARBUTTONSSPLITDROPDOWN.Width,yStart+yInc*(y+1));
      EnlargeBitmap(TOOLBARBUTTONSSPLITDROPDOWN, Canvas, biRect, R, 9, 5);
      //Canvas.Draw(R.Left, R.Top, StockBMP);
      PaintDropDownArrow(Canvas, R, ItemInfo);
      //EnlargeBitmap(BOTON, Canvas, biRect, R, 10, 12);
      //EnlargeBitmap(BOTON, Canvas, biRect, R, 12);
    End Else
    if ComboPart = cpSplitLeft then
    Begin
      // Dropdown Left
      yStart:= 0;
      yInc:= TOOLBARBUTTONSSPLIT.Height div 6;
      y:=0;
      Case DrawStyle of
        bsDefault:       If Embedded then  y:= 1 Else y:= 0;
        bsHover:         y:= 1;
        bsDisabled:      y:= 3;
        bsPushed:        y:= 5;
        bsSelected:      y:= 4;
        bsSelectedHover: y:= 5;
      End;//CASE
      biRect:= Rect(0,yStart+yInc*y,TOOLBARBUTTONSSPLIT.Width,yStart+yInc*(y+1));
      EnlargeBitmap(TOOLBARBUTTONSSPLIT, Canvas, biRect, R, 8, 3);
      //Canvas.Draw(R.Left, R.Top, StockBMP);
    End Else
    Begin
      If Embedded then
      Begin
        // Button
        yStart:= 0;
        yInc:= BOTON.Height div 5;
        y:=0;
        Case DrawStyle of
          bsDefault:  //Pen.Color:= clWhite;
            y:= 0;
          bsHover:    //Pen.Color:= clLime;
            y:= 1;
          bsDisabled: //Pen.Color:= clBlack;
            y:= 3;
          bsPushed:   //Pen.Color:= clRed;
            y:= 2;
          bsSelected: //Pen.Color:= clBlue;
            y:= 4;
          bsSelectedHover:
            y:= 1;
        End;//CASE
        biRect:= Rect(0,yStart+yInc*y,BOTON.Width,yStart+yInc*(y+1));
        EnlargeBitmap(BOTON, Canvas, biRect, R, 11, 11);
      End Else
      Begin
        // Tool Button
        yStart:= 0;
        yInc:= TOOLBARBUTTONS.Height div 6;
        y:=0;
        Case DrawStyle of
          bsDefault:      y:= 0;
          bsHover:        y:= 1;
          bsDisabled:     y:= 3;
          bsPushed:       y:= 2;
          bsSelected:     y:= 4;
          bsSelectedHover:y:= 5;
        End;//CASE
        biRect:= Rect(0,yStart+yInc*y,TOOLBARBUTTONS.Width,yStart+yInc*(y+1));
        EnlargeBitmap(TOOLBARBUTTONS, Canvas, biRect, R, 7, 5);
      End;
    End;
  end;
end;

procedure TTBXMacOSXg32Theme.PaintComboArrow(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  X, Y: Integer;
begin
  with ARect, Canvas, ItemInfo do
  begin
    X := (Left + Right) div 2 - 1;
    Y := (Top + Bottom) div 2 - 1;
    {If Not Enabled then
      Pen.Color := clLtGray
    Else
      Pen.Color := clBlack;//GetPartColor(ItemInfo, ipText);{}
    Pen.Color := GetPartColor(ItemInfo, ipText);
    Brush.Color := Pen.Color;
    if ItemInfo.IsVertical then
    Begin
      Polygon([Point(X, Y + 2), Point(X, Y - 2), Point(X - 2, Y)]);
      Polygon([Point(X, Y + 2), Point(X, Y - 2), Point(X - 2, Y)]);
    End else
    Begin
      Y:= Y-1;
      Polygon([Point(X - 2, Y), Point(X + 2, Y), Point(X, Y - 2)]);
      Y:= Y+3;
      Polygon([Point(X - 2, Y), Point(X + 2, Y), Point(X, Y + 2)]);
    End;
  end;
end;

procedure TTBXMacOSXg32Theme.PaintDock(Canvas: TCanvas; const ClientRect,
  DockRect: TRect; DockPosition: Integer);
begin
  DrawStripeBG(Canvas, DockRect, ToolbarColor);//MenuItemColors[misHot, ipBody]);//
end;

procedure TTBXMacOSXg32Theme.PaintDockPanelNCArea(Canvas: TCanvas; R: TRect;
  const DockPanelInfo: TTBXDockPanelInfo);
var
  DC: HDC;
  Sz: Integer;
  R2: TRect;
  biRect:TRect;
  Flags: Integer;
  y, yStart, yInc:Integer;
  CloseButtonDown, CloseButtonHover: Boolean;

  procedure CaptionFill(R: TRect);
  const
    GRAD: array [Boolean] of TGradientKind = (gkHorz, gkVert);
  begin
    if USE_THEMES then
      GradFill(DC, R, Lighten(ToolbarColor, 12), Lighten(ToolbarColor, -12), GRAD[DockPanelInfo.IsVertical])
    else
      FillRectEx(DC, R, ToolbarColor);
  end;

begin
  DC := Canvas.Handle;
  with Canvas, DockPanelInfo do
  begin
    Sz := GetSystemMetrics(SM_CYSMCAPTION);

    { Border }
    FrameRectEx(DC, R, ToolbarColor, True);
    R2 := R;
    if ShowCaption then
      if IsVertical then Inc(R2.Top, Sz)
      else Inc(R2.Left, Sz);
    FrameRectEx(DC, R2, clWindow, False);

    if not ShowCaption then Exit;

    { Caption area }
    if IsVertical then R.Bottom := R.Top + Sz
    else R.Right := R.Left + Sz;
    Windows.DrawEdge(Handle, R, BDR_RAISEDINNER, BF_RECT or BF_ADJUST);

    { Close button }
    if (CDBS_VISIBLE and CloseButtonState) <> 0 then
    begin
      CloseButtonDown := (CloseButtonState and CDBS_PRESSED) <> 0;
      CloseButtonHover := (CloseButtonState and CDBS_HOT) <> 0;
      R2 := R;
      Brush.Color := ToolbarColor;
      if IsVertical then
      begin
        R2.Left := R2.Right - Sz;
        R.Right := R2.Left;
        CaptionFill(R2);
        {InflateRect(R2, -1, -1);}
        Inc(R2.Left,2);
      end
      else
      begin
        R2.Top := R2.Bottom - Sz;
        R.Bottom := R2.Top;
        CaptionFill(R2);
        {InflateRect(R2, -1, -1);}
        Dec(R2.Bottom,2);
      end;

      Flags := TS_NORMAL;
      if CloseButtonDown then Flags := TS_PRESSED
      else if CloseButtonHover then Flags := TS_HOT;
      {DrawThemeBackground(TOOLBAR_THEME, DC, TP_BUTTON, Flags, R2, nil);
      if CloseButtonDown then OffsetRect(R2, 1, 1);
      InflateRect(R2, -2, -2);}

      yStart:= 0;
      yInc:= MDICLOSE.Height div 4;
//      y:=0;
      Case Flags of
        TS_NORMAL : y:=0;
        TS_PRESSED: y:=2;
        TS_HOT    : y:=1;
        Else        y:=3;
      End;//CASE
      biRect:= Rect(0,yStart+yInc*y,MDICLOSE.Width,yStart+yInc*(y+1));
      InflateRect(R2, (((biRect.Right-biRect.Left)-(R2.Right-R2.Left)) div 2), (((biRect.Bottom-biRect.Top)-(R2.Bottom-R2.Top)) div 2));
      OffsetRect(R2, 0, -1);
      //EnlargeBitmap(MDICLOSE, Canvas, biRect, R2, 8,8);
      DrawImage(MDICLOSE, Canvas, biRect, R2.Left, R2.Top);
//      DrawButtonBitmap(Canvas, R2);
    end;

    { Caption }
    CaptionFill(R);
    if IsVertical then InflateRect(R, -2, 0)
    else Inflaterect(R, 0, -2);
    Font.Assign(SmCaptionFont);
    Font.Color := clBtnText;
    Brush.Style := bsClear;
    Flags := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX;
    if IsVertical then DrawText(Canvas.Handle, Caption, -1, R, Flags)
    else DrawRotatedText(Canvas.Handle, string(Caption), R, Flags);
    Brush.Style := bsSolid;
  end;
end;

procedure TTBXMacOSXg32Theme.PaintDropDownArrow(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
var
  X, Y: Integer;

  procedure Draw(AColor: TColor);
  begin
    Canvas.Pen.Color := AColor;
    Canvas.Brush.Color := AColor;
    if ItemInfo.IsVertical then Canvas.Polygon([Point(X, Y + 2), Point(X, Y - 2), Point(X - 2, Y)])
    else Canvas.Polygon([Point(X - 2, Y), Point(X + 2, Y), Point(X, Y + 2)]);
  end;

begin
  with ItemInfo, ARect do
  begin
    X := (Left + Right) div 2;
    Y := (Top + Bottom) div 2 - 1;

    if (Pushed or Selected) and (ComboPart <> cpSplitRight) then
    begin
      Inc(X); Inc(Y);
    end;

    if Enabled then
    begin
      {if Boolean(ItemOptions and IO_TOOLBARSTYLE) then Draw(clPopupText)
      else Draw(GetPartColor(ItemInfo, ipText));}
      Draw(GetPartColor(ItemInfo, ipText));
    end
    else
    begin
      //Inc(X); Inc(Y);
      Draw(GetPartColor(ItemInfo, ipText));//clBtnHighlight);
      {Dec(X); Dec(Y);
      Draw(GetPartColor(ItemInfo, ipText));//clBtnHighlight);}
    end;
  end;
end;

procedure TTBXMacOSXg32Theme.PaintEditButton(Canvas: TCanvas;
  const ARect: TRect; var ItemInfo: TTBXItemInfo;
  ButtonInfo: TTBXEditBtnInfo);
var
//  DC: HDC;
  BtnDisabled, BtnHot, BtnPressed, Embedded: Boolean;
//  StateFlags: Integer;
  R, BR, biRect: TRect;
//  C: TColor;
  X, Y, yInc: Integer;
begin
//  DC := Canvas.Handle;
  R := ARect;
  with Canvas, ItemInfo do
  begin
    Embedded := ((ViewType and VT_TOOLBAR) = VT_TOOLBAR) and
      ((ViewType and TVT_EMBEDDED) = TVT_EMBEDDED);

    if ButtonInfo.ButtonType = EBT_DROPDOWN then
    begin
      { DropDown button }
      BtnDisabled := (ButtonInfo.ButtonState and EBDS_DISABLED) <> 0;
      BtnHot := (ButtonInfo.ButtonState and EBDS_HOT) <> 0;
      BtnPressed := (ButtonInfo.ButtonState and EBDS_PRESSED) <> 0;

      // Combo BOX
      yInc:= SPINBUTTONBACKGROUNDRIGHT.Height div 4;
      if BtnDisabled then y:=3
      else if BtnPressed then y:=2
      else if BtnHot then y:=1
      else if Embedded then y:= 1
      else y:= 0;
      biRect:= Rect(0,yInc*y,SPINBUTTONBACKGROUNDRIGHT.Width,yInc*(y+1));

      if BtnHot or BtnPressed then InflateRect(R, -1, -1)
      else InflateRect(R, -2, -2);
      EnlargeBitmap(SPINBUTTONBACKGROUNDRIGHT, Canvas, biRect, R, 7, 5);
      PaintComboArrow(Canvas, R, ItemInfo);
    end
    else if ButtonInfo.ButtonType = EBT_SPIN then
    begin
      { Paint spin buttons }
      BtnDisabled := (ButtonInfo.ButtonState and EBSS_DISABLED) <> 0;
      BtnHot := (ButtonInfo.ButtonState and EBSS_HOT) <> 0;
      BtnPressed := (ButtonInfo.ButtonState and EBDS_PRESSED) <> 0;
      //if BtnHot then InflateRect(R, 1, 1);
      if BtnHot or BtnPressed then InflateRect(R, -1, -1)
      else InflateRect(R, -2, -2);

      { Upper }
      BR := R;
      BR.Bottom := (R.Top + R.Bottom - 1) div 2;
      BtnPressed := (ButtonInfo.ButtonState and EBSS_UP) <> 0;
      {if BtnDisabled then StateFlags := UPS_DISABLED
      else if BtnPressed then StateFlags := UPS_PRESSED
      else if BtnHot then StateFlags := UPS_HOT
      else StateFlags := UPS_NORMAL;
      DrawThemeBackground(SPIN_THEME, Handle, SPNP_UP, StateFlags, BR, nil);}
      yInc:= SPINBUTTONBACKGROUNDUP.Height div 4;
      if BtnDisabled then y:=3
      else if BtnPressed then y:=2
      else if BtnHot then y:=1
      else if Embedded then y:= 1
      else y:= 0;
      biRect:= Rect(0,yInc*y,SPINBUTTONBACKGROUNDUP.Width,yInc*(y+1));
      EnlargeBitmap(SPINBUTTONBACKGROUNDUP, Canvas, biRect, BR, 4, 3);
      X := (BR.Left + BR.Right) div 2;
      Y := (BR.Top + BR.Bottom - 1) div 2;
      If BtnDisabled then Pen.Color := clBtnShadow
      Else                Pen.Color := clBtnText;
      Brush.Color := Pen.Color;
      Polygon([Point(X - 2, Y + 1), Point(X + 2, Y + 1), Point(X, Y - 1)]);

      { Lower }
      BR := R;
      BR.Top := (R.Top + R.Bottom) div 2;
      BtnPressed := (ButtonInfo.ButtonState and EBSS_DOWN) <> 0;
      {if BtnDisabled then StateFlags := DNS_DISABLED
      else if BtnPressed then StateFlags := DNS_PRESSED
      else if BtnHot then StateFlags := DNS_HOT
      else StateFlags := DNS_NORMAL;
      DrawThemeBackground(SPIN_THEME, Handle, SPNP_DOWN, StateFlags, BR, nil);}
      yInc:= SPINBUTTONBACKGROUNDDOWN.Height div 4;
      if BtnDisabled then y:=3
      else if BtnPressed then y:=2
      else if BtnHot then y:=1
      else if Embedded then y:= 1
      else y:= 0;
      biRect:= Rect(0,yInc*y,SPINBUTTONBACKGROUNDDOWN.Width,yInc*(y+1));
      EnlargeBitmap(SPINBUTTONBACKGROUNDDOWN, Canvas, biRect, BR, 4, 3);
      X := (BR.Left + BR.Right) div 2;
      Y := (BR.Top + BR.Bottom) div 2;
      If BtnDisabled then Pen.Color := clBtnShadow
      Else                Pen.Color := clBtnText;
      Brush.Color := Pen.Color;
      Polygon([Point(X - 2, Y - 1), Point(X + 2, Y - 1), Point(X, Y + 1)]);
    end;
  end;
end;

procedure TTBXMacOSXg32Theme.PaintEditFrame(Canvas: TCanvas;
  const ARect: TRect; var ItemInfo: TTBXItemInfo;
  const EditInfo: TTBXEditInfo);
Var
//  C:TColor;
  R: TRect;
begin
  //inherited;
  R:= ARect;
  with ItemInfo do
  Begin
    if Enabled then
    begin
      if not ((ViewType and TVT_EMBEDDED) = TVT_EMBEDDED) and
        not (Pushed or Selected or (HoverKind <> hkNone)) then
      begin
        InflateRect(R, -1, -1);
        Canvas.Brush.Color:= clWindow;
        Canvas.Brush.Style:= bsSolid;
        Canvas.FillRect(R);
      end Else
      Begin
        If not (Pushed or Selected or (HoverKind <> hkNone)) then
          InflateRect(R, -1, -1);
        EnlargeBitmap(COMBOBOX, Canvas, Rect(0,0,COMBOBOX.Width,COMBOBOX.Height), R, 6, 3);
      End;
    end Else
    Begin
      InflateRect(R, -1, -1);
      Canvas.Pen.Color:= clWhite;
      Canvas.Brush.Style:= bsClear;
      Canvas.Rectangle(R);
    End;
  End;
  if EditInfo.RightBtnWidth > 0 then
  Begin
    R := ARect;
    R.Left := R.Right - EditInfo.RightBtnWidth;
    PaintEditButton(Canvas, R, ItemInfo, EditInfo.RightBtnInfo);
  End;
//  Canvas.Rectangle(ARect);
end;

procedure TTBXMacOSXg32Theme.PaintFloatingBorder(Canvas: TCanvas;
  const ARect: TRect; const WindowInfo: TTBXWindowInfo);
var
  DC: HDC;
  BorderColor, C: TColor;
  I: Integer;
  Sz: TPoint;
  R,R2: TRect;
  Size: TSize;
  CaptionString: string;
  IsPushed, IsHovered: Boolean;
  BtnItemState: TBtnItemState;
  SaveIndex: Integer;
  y, yStart, yInc:Integer;
  CloseButtonDown, CloseButtonHover: Boolean;
  biRect:TRect;
  Flags: Integer;

  function GetBtnItemState(BtnState: Integer): TBtnItemState;
  begin
    if not WindowInfo.Active then Result := bisDisabled
    else if (BtnState and CDBS_PRESSED) <> 0 then Result := bisPressed
    else if (BtnState and CDBS_HOT) <> 0 then Result := bisHot
    else Result := bisNormal;
  end;

begin
  DC := Canvas.Handle;
  with Canvas do
  begin
    if (WRP_BORDER and WindowInfo.RedrawPart) <> 0  then
    begin
      R := ARect;
      FrameRectEx(DC, R, WinFrameColors[wfsActive, wfpBorder], True);
      FillRectEx(DC, R, GetViewColor(WindowInfo.ViewType));
      //BtnItemColors[bisSelected, ipFrame]
    end;

    if not WindowInfo.ShowCaption then Exit;

    { Caption }
    if (WRP_CAPTION and WindowInfo.RedrawPart) <> 0 then
    begin
      R:= ARect;
      R.Bottom:= R.Top+GetSystemMetrics(SM_CYSMCAPTION)+WindowInfo.FloatingBorderSize.Y;
      FrameRectEx(DC, R, BtnItemColors[bisSelected, ipFrame], True);
      DrawCaptionArea(Handle, R, WinFrameColors[wfsActive, wfpBorder], True);

      Font.Assign(SmCaptionFont);
      Font.Color := clBtnText;
      CaptionString := string(WindowInfo.Caption);
      Size := TextExtent(CaptionString);
      if Size.cx > 0 then Inc(Size.cx, 16);

      InflateRect(R, -2, 0);
      Dec(R.Top, 2);

      Brush.Style := bsClear;
      DrawText(Canvas.Handle, PChar(CaptionString), Length(CaptionString), R,
        DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_HIDEPREFIX);
      Brush.Style := bsSolid;
    end;

    { Close button }
    if (CDBS_VISIBLE and WindowInfo.CloseButtonState) <> 0 then
    begin
      CloseButtonDown := (WindowInfo.CloseButtonState and CDBS_PRESSED) <> 0;
      CloseButtonHover := (WindowInfo.CloseButtonState and CDBS_HOT) <> 0;

      R := Rect(0, 0, WindowInfo.ClientWidth, GetSystemMetrics(SM_CYSMCAPTION));
      with Windowinfo.FloatingBorderSize do OffsetRect(R, X, Y);
      R.Left := R.Right - (R.Bottom - R.Top) - 1;
      {Dec(R.Bottom, 2);
      Inc(R.Left, 3); Dec(R.Right);
      Inc(R.Top);
      Dec(R.Bottom);}

      Flags := TS_NORMAL;
      if CloseButtonDown then Flags := TS_PRESSED
      else if CloseButtonHover then Flags := TS_HOT;
      yStart:= 0;
      yInc:= MDICLOSE.Height div 4;
//      y:=0;
      Case Flags of
        TS_NORMAL : y:=0;
        TS_PRESSED: y:=2;
        TS_HOT    : y:=1;
        Else        y:=3;
      End;//CASE
      biRect:= Rect(0,yStart+yInc*y,MDICLOSE.Width,yStart+yInc*(y+1));
      InflateRect(R, (((biRect.Right-biRect.Left)-(R.Right-R.Left)) div 2), (((biRect.Bottom-biRect.Top)-(R.Bottom-R.Top)) div 2));
      OffsetRect(R, 0, -1);
      //EnlargeBitmap(MDICLOSE, Canvas, biRect, R, 8,8);
      DrawImage(MDICLOSE, Canvas, biRect, R.Left, R.Top);
    end;
  end;
end;

procedure TTBXMacOSXg32Theme.PaintFrameControl(Canvas: TCanvas; R: TRect;
  Kind, State: Integer; Params: Pointer);
Var
//  graphic: TGPgraphics;
  y, yInc, yStart: Integer;
  DrawStyle: TDrawStyle;
  biRect: TRect;
begin
  with Canvas do
  begin
    //graphic:= TGPgraphics.Create(Canvas.Handle);
    //graphic.SetInterpolationMode(FInterpolationMode);
    DrawStyle:= bsDefault;
    If Boolean(State and PFS_DISABLED) then
      DrawStyle:= bsDisabled
    Else If Boolean(State and PFS_PUSHED) then
      DrawStyle:= bsPushed
    Else If Boolean(State and PFS_HOT) then
      DrawStyle:= bsHover
    ;

    case Kind of
      PFC_CHECKBOX:
        Begin
          if Boolean(State and PFS_CHECKED) then
            yStart:= CheckM.Height div 3
          Else if Boolean(State and PFS_MIXED) then
            yStart:= (CheckM.Height div 3) * 2
          Else
            yStart:= 0;
          yInc:= CheckM.Height div 12;
          y:= 0;
          Case DrawStyle of
            bsDefault:  y:= 0;
              //graphic.DrawImage(CheckM, Rect(R), 0,yStart+yInc*0,CheckM.Width,yInc, UnitPixel);
              //graphic.DrawImage(CheckM, R.Left,R.Top, 0,yStart+yInc*0,CheckM.Width,yInc, UnitPixel);
            bsHover:    y:= 2;
              //graphic.DrawImage(CheckM, Rect(R), 0,yStart+yInc*2,CheckM.Width,yInc, UnitPixel);
              //graphic.DrawImage(CheckM, R.Left,R.Top, 0,yStart+yInc*2,CheckM.Width,yInc, UnitPixel);
            bsDisabled: y:= 3;
              //graphic.DrawImage(CheckM, Rect(R), 0,yStart+yInc*3,CheckM.Width,yInc, UnitPixel);
              //graphic.DrawImage(CheckM, R.Left,R.Top, 0,yStart+yInc*3,CheckM.Width,yInc, UnitPixel);
            bsPushed:   y:= 1;
              //graphic.DrawImage(CheckM, Rect(R), 0,yStart+yInc*1,CheckM.Width,yInc, UnitPixel);
              //graphic.DrawImage(CheckM, R.Left,R.Top, 0,yStart+yInc*1,CheckM.Width,yInc, UnitPixel);
          End;//CASE
          biRect:= Rect(0,yStart+yInc*y,CheckM.Width,yStart+yInc*(y+1));
          DrawImage(CheckM, Canvas, biRect, R.Left, R.Top);
        End;
      PFC_RADIOBUTTON:
        Begin
          if Boolean(State and PFS_CHECKED) then
            yStart:= RadioM.Height div 2
          Else
            yStart:= 0;
          yInc:= RadioM.Height div 8;
          Case DrawStyle of
            bsDefault:  y:= 0;
              //graphic.DrawImage(RadioM, Rect(R), 0,yStart+yInc*0,RadioM.Width,yInc, UnitPixel);
              //graphic.DrawImage(RadioM, R.Left,R.Top, 0,yStart+yInc*0,RadioM.Width,yInc, UnitPixel);
            bsHover:    y:= 2;
              //graphic.DrawImage(RadioM, Rect(R), 0,yStart+yInc*2,RadioM.Width,yInc, UnitPixel);
              //graphic.DrawImage(RadioM, R.Left,R.Top, 0,yStart+yInc*2,RadioM.Width,yInc, UnitPixel);
            bsDisabled: y:= 3;
              //graphic.DrawImage(RadioM, Rect(R), 0,yStart+yInc*3,RadioM.Width,yInc, UnitPixel);
              //graphic.DrawImage(RadioM, R.Left,R.Top, 0,yStart+yInc*3,RadioM.Width,yInc, UnitPixel);
            bsPushed:   y:= 1;
              //graphic.DrawImage(RadioM, Rect(R), 0,yStart+yInc*1,RadioM.Width,yInc, UnitPixel);
              //graphic.DrawImage(RadioM, R.Left,R.Top, 0,yStart+yInc*1,RadioM.Width,yInc, UnitPixel);
          End;//CASE
          biRect:= Rect(0,yStart+yInc*y,RadioM.Width,yStart+yInc*(y+1));
          DrawImage(RadioM, Canvas, biRect, R.Left, R.Top);
        End;
      Else
        inherited;
    end;//case
//    graphic.Free;{}
  End;
end;

procedure TTBXMacOSXg32Theme.PaintImage(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ImageList: TCustomImageList;
  ImageIndex: Integer);
var
  HiContrast: Boolean;
begin
  with ItemInfo do
  begin
    if ImageList is TTBCustomImageList then
    begin
      TTBCustomImageList(ImageList).DrawState(Canvas, ARect.Left, ARect.Top,
        ImageIndex, Enabled, (HoverKind <> hkNone), Selected);
      Exit;
    end;
    HiContrast := ColorIntensity(GetItemImageBackground(ItemInfo)) < 80;
    if not Enabled then
    begin
      if not HiContrast then
        DrawTBXIconShadow(Canvas, ARect, ImageList, ImageIndex, 0)
      else
        DrawTBXIconFlatShadow(Canvas, ARect, ImageList, ImageIndex, clBtnShadow);
    end
    else if Selected or Pushed or (HoverKind <> hkNone) then
    begin
      if not (Selected or Pushed and not IsPopupParent) then
      begin
        DrawTBXIconShadow(Canvas, ARect, ImageList, ImageIndex, 1);
        OffsetRect(ARect, 1, 1);
        DrawTBXIconShadow(Canvas, ARect, ImageList, ImageIndex, 1);
        OffsetRect(ARect, -2, -2);
      end;
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast);
    end
    else if HiContrast or TBXHiContrast or TBXLoColor then
      DrawTBXIcon(Canvas, ARect, ImageList, ImageIndex, HiContrast)
    else
      //HighlightTBXIcon(Canvas, ARect, ImageList, ImageIndex, clWindow, 178);
      BlendTBXIcon(Canvas, ARect, ImageList, ImageIndex, 178);
  end;
end;

procedure TTBXMacOSXg32Theme.PaintMDIButton(Canvas: TCanvas; ARect: TRect;
  const ItemInfo: TTBXItemInfo; ButtonKind: Cardinal);
Var
  y, yinc:Integer;
  img: TBitmap32;
  biRect, r: TRect;
begin
  case ButtonKind of
    DFCS_CAPTIONMIN:     img:= MINIMIZEGLYPH;
    DFCS_CAPTIONRESTORE: img:= MAXIMIZEGLYPH;
    DFCS_CAPTIONCLOSE:   img:= CLOSEGLYPH;
  else
    Exit;
  end;

  yinc:= img.Height div 4;
  If Not ItemInfo.Enabled then
    y:= 3
  Else If ItemInfo.Pushed or ItemInfo.Selected then
    y:= 2
  Else If ItemInfo.HoverKind<>hkNone then
    y:= 1
  Else
    y:= 0;

  biRect:= Rect(0,0+yInc*y,img.Width,0+yInc*(y+1));
  R:= ARect;
  InflateRect(R, (((biRect.Right-biRect.Left)-(R.Right-R.Left)) div 2), (((biRect.Bottom-biRect.Top)-(R.Bottom-R.Top)) div 2));
  OffsetRect(R, 0, -1);
  DrawImage(img, Canvas, biRect, R.Left, R.Top);
end;

procedure TTBXMacOSXg32Theme.PaintMenuItem(Canvas: TCanvas; const ARect: TRect; var ItemInfo: TTBXItemInfo);
var
  R, R2: TRect;
  X, Y: Integer;
  ArrowWidth: Integer;
  ClrText: TColor;

  procedure DrawArrow(AColor: TColor);
  begin
    Canvas.Pen.Color := AColor;
    Canvas.Brush.Color := AColor;
    Canvas.Polygon([Point(X, Y - 3), Point(X, Y + 3), Point(X + 3, Y)]);
  end;
begin
  with Canvas, ItemInfo do
  begin
    ArrowWidth := GetSystemMetrics(SM_CXMENUCHECK);
    PaintMenuItemFrame(Canvas, ARect, ItemInfo);
    ClrText := GetPartColor(ItemInfo, ipText);
    R := ARect;

    if (ItemOptions and IO_COMBO) <> 0 then
    begin
      X := R.Right - ArrowWidth - 1;
      if not ItemInfo.Enabled then Pen.Color := ClrText
      else if HoverKind = hkMouseHover then Pen.Color := clWhite //GetPartColor(ItemInfo, ipFrame)
      else Pen.Color := PopupSeparatorColor;
      MoveTo(X, R.Top + 1);
      LineTo(X, R.Bottom - 1);
    end;

    if (ItemOptions and IO_SUBMENUITEM) <> 0 then
    begin
      Y := ARect.Bottom div 2;
      X := ARect.Right - ArrowWidth * 2 div 3 - 1;
      DrawArrow(ClrText);
    end;

    R2:= ARect;
    //InflateRect(R2, -1, -1);
    if ((Selected) and (Enabled)) then
    begin
      R.Left := R2.Left;
      R.Right := R.Left + ItemInfo.PopupMargin;
      //InflateRect(R, -1, -1);
      PaintButton(Canvas, R, ItemInfo);
    end;
  end;
end;

procedure TTBXMacOSXg32Theme.PaintMenuItemFrame(Canvas: TCanvas;
  const ARect: TRect; const ItemInfo: TTBXItemInfo);
const
  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
begin
  with ItemInfo do if (Enabled and (HoverKind <> hkNone)) or
    (not Enabled and (HoverKind = hkKeyboardHover)) then
    begin
      PaintBackgnd(Canvas, ZERO_RECT, ARect, ARect, MenuItemColors[misHot, ipBody], False, VT_UNKNOWN);
    end;
end;

procedure TTBXMacOSXg32Theme.PaintSeparator(Canvas: TCanvas; ARect: TRect;
  ItemInfo: TTBXItemInfo; Horizontal, LineSeparator: Boolean);
begin
  with ItemInfo, ARect, Canvas do
  begin
    if Horizontal then
    begin
      InflateRect(ARect, -2,0);
      Top := (Bottom div 2);
      while Left < Right do
      begin
        Canvas.Pixels[Left, Top] := clBlack;
        Left := Left + 3;
      end;
    end else if enabled then
    begin
      InflateRect(ARect, 0,-2);
      Left := (Right div 2); // - 1;
      while Top < Bottom do
      begin
        Canvas.Pixels[Left, Top] := clBlack;
        Top := Top + 3;
      end;
    end;
  end;
end;

procedure TTBXMacOSXg32Theme.PaintToolbarNCArea(Canvas: TCanvas; R: TRect;
  const ToolbarInfo: TTBXToolbarInfo);
const
  DragHandleSizes: array [Boolean, DHS_DOUBLE..DHS_SINGLE] of Integer = ((9, 0, 6), (14, 14, 14));
  DragHandleOffsets: array [Boolean, DHS_DOUBLE..DHS_SINGLE] of Integer = ((2, 0, 2), (3, 0, 5));
  GripperPart: array [Boolean] of Cardinal = (RP_GRIPPER, RP_GRIPPERVERT);
  Pattern: array [0..15] of Byte = (0, 0, $CC, 0, $78, 0, $30, 0, $78, 0, $CC, 0, 0, 0, 0, 0);
var
//  DC: HDC;
  DHSize: Integer;
//  Sz: TSize;
  R2: TRect;
  Flags: Cardinal;
  Z: Integer;
  BtnVisible, Horz, CloseButtondown, CloseButtonHover: Boolean;
  y, yStart, yInc:Integer;
  biRect:TRect;
begin
  Canvas.FillRect(R);

  { Border }
  if ToolbarInfo.BorderStyle = bsSingle then
    Frame3D(Canvas.Handle, R, Lighten(ToolbarInfo.EffectiveColor, 24), Lighten(ToolbarInfo.EffectiveColor, -32), False);
  if not ToolbarInfo.AllowDrag then Exit;

  BtnVisible := (ToolbarInfo.CloseButtonState and CDBS_VISIBLE) <> 0;
  Horz := not ToolbarInfo.IsVertical;

  DHSize := GetTBXDragHandleSize(ToolbarInfo);
  if Horz then R.Right := R.Left + DHSize
  else R.Bottom := R.Top + DHSize;

  { Drag handle area }
  if ToolbarInfo.DragHandleStyle <> DHS_NONE then
  begin
    R2 := R;
    if Horz then Inc(R2.Top, 2)
    else Inc(R2.Left, 2);
    if BtnVisible then
      if Horz then Inc(R2.Top, DHSize - 1)
      else Dec(R2.Right, DHSize - 1);
    With R2 do
    if Not Horz then
    begin
      Top := (Bottom div 2);
      while Left < Right do
      begin
        Canvas.Pixels[Left, Top] := clBlack;
        Left := Left + 3;
      end;
    end else
    begin
      Left := (Right div 2); // - 1;
      while Top < Bottom do
      begin
        Canvas.Pixels[Left, Top] := clBlack;
        Top := Top + 3;
      end;
    end;
  end;

  { Close Button }
  if BtnVisible then
  begin
    With Canvas do
    Begin
      CloseButtonDown := (ToolbarInfo.CloseButtonState and CDBS_PRESSED) <> 0;
      CloseButtonHover := (ToolbarInfo.CloseButtonState and CDBS_HOT) <> 0;
      R2 := GetTBXDockedCloseButtonRect(ToolbarInfo);
      Brush.Color := ToolbarColor;
      Flags := TS_NORMAL;
      if CloseButtonDown then Flags := TS_PRESSED
      else if CloseButtonHover then Flags := TS_HOT;
      {DrawThemeBackground(TOOLBAR_THEME, DC, TP_BUTTON, Flags, R2, nil);
      if CloseButtonDown then OffsetRect(R2, 1, 1);
      InflateRect(R2, -2, -2);}

      yStart:= 0;
      yInc:= MDICLOSE.Height div 4;
//      y:=0;
      Case Flags of
        TS_NORMAL : y:=0;
        TS_PRESSED: y:=2;
        TS_HOT    : y:=1;
        Else        y:=3;
      End;//CASE
      biRect:= Rect(0,yStart+yInc*y,MDICLOSE.Width,yStart+yInc*(y+1));
      InflateRect(R2, (((biRect.Right-biRect.Left)-(R2.Right-R2.Left)) div 2), (((biRect.Bottom-biRect.Top)-(R2.Bottom-R2.Top)) div 2));
      OffsetRect(R2, 0, -1);
      //EnlargeBitmap(MDICLOSE, Canvas, biRect, R2, 8,8);
      DrawImage(MDICLOSE, Canvas, biRect, R2.Left, R2.Top);
//      DrawButtonBitmap(Canvas, R2);
    End;
  end;
end;

procedure TTBXMacOSXg32Theme.SetupColorCache;
var
  DC: HDC;
  HotBtnFace, DisabledText: TColor;

  procedure Undither(var C: TColor);
  begin
    if C <> clNone then C := GetNearestColor(DC, ColorToRGB(C));
  end;
begin
  DC := StockCompatibleBitmap.Canvas.Handle;

{  gradCol1 := Blend(BaseColor, clWhite, 80);
  gradCol2 := clWhite;

  gradHandle1 := clSilver;
  gradHandle2 := clGray;
  gradHandle3 := clWhite;

  gradBL := NearestMixedColor(clGray, gradCol1, 64);}

  MenubarColor := $00F7F7F7;
  ToolbarColor := $00F7F7F7;

  PopupColor := MenuBarColor;
  DockPanelColor := PopupColor;
  PopupFrameColor := clSilver;

{  BarSepColor := $A0A0A0;

  EditFrameColor := Blend(clSilver, clWhite, 80);
  EditFrameDisColor := Blend(clSilver, clWhite, 50);}

{  if Aqua then
    BaseColor := $00E0A030 // Aqua
  else
    BaseColor := $00A8A8A8; // Discret}
  BaseColor := $00E0A030; // Aqua
  HotColor := clBlack;
  PopupSeparatorColor := clBlack;

  HotBtnFace := Blend(BaseColor, clWhite, 80);
  SetContrast(HotBtnFace, ToolbarColor, 50);
  DisabledText := Blend(clBtnshadow, clWindow, 90);

  WinFrameColors[wfsActive, wfpBorder] := clSilver; //Blend(clGray, clWhite, 80);
  //SetContrast(WinFrameColors[wfsActive, wfpBorder], ToolbarColor, 120);
  WinFrameColors[wfsActive, wfpCaption] := clSilver;
  WinFrameColors[wfsActive, wfpCaptionText] := HotColor; //clWhite;
  SetContrast(WinFrameColors[wfsActive, wfpCaptionText], clGray, 180);

  WinFrameColors[wfsInactive, wfpBorder] := WinFrameColors[wfsActive, wfpBorder];
  WinFrameColors[wfsInactive, wfpCaption] := BaseColor;
  WinFrameColors[wfsInactive, wfpCaptionText] := clSilver;
  SetContrast(WinFrameColors[wfsInactive, wfpCaptionText], clSilver, 120);

  PnlFrameColors[wfsActive, wfpBorder] := clSilver; //Blend(clGray, clWhite, 80);
  PnlFrameColors[wfsActive, wfpCaption] := clSilver;
  PnlFrameColors[wfsActive, wfpCaptionText] := WinFrameColors[wfsActive, wfpCaptionText];

  PnlFrameColors[wfsInactive, wfpBorder] := clSilver; //clGray;
  PnlFrameColors[wfsInactive, wfpCaption] := clSilver;
  PnlFrameColors[wfsInactive, wfpCaptionText] := clSilver;
  SetContrast(PnlFrameColors[wfsInactive, wfpCaptionText], clGray, 120);

  BtnItemColors[bisNormal, ipBody] := clNone;
  BtnItemColors[bisNormal, ipText] := clBlack;
  SetContrast(BtnItemColors[bisNormal, ipText], ToolbarColor, 180);
  BtnItemColors[bisNormal, ipFrame] := clNone;

  BtnItemColors[bisDisabled, ipBody] := clWhite;
  BtnItemColors[bisDisabled, ipText] := Blend(clGray, clWhite, 70);
  SetContrast(BtnItemColors[bisDisabled, ipText], ToolbarColor, 80);
  BtnItemColors[bisDisabled, ipFrame] := Blend(clSilver, clWhite, 50);

  BtnItemColors[bisSelected, ipBody] := clSilver;
  SetContrast(BtnItemColors[bisSelected, ipBody], ToolbarColor, 5);
  BtnItemColors[bisSelected, ipText] := BtnItemColors[bisNormal, ipText];
  BtnItemColors[bisSelected, ipFrame] := clDkGray;//Blend(clSilver, clWhite, 50);

  BtnItemColors[bisPressed, ipBody] := Blend(BaseColor, clWhite, 50);
  BtnItemColors[bisPressed, ipText] := clBlack;
  BtnItemColors[bisPressed, ipFrame] := BaseColor;

  BtnItemColors[bisHot, ipBody] := HotBtnFace;
  BtnItemColors[bisHot, ipText] := HotColor; //clWhite;
  BtnItemColors[bisHot, ipFrame] := Blend(BaseColor, clWhite, 80);
  //SetContrast(BtnItemColors[bisHot, ipFrame], ToolbarColor, 100);

  BtnItemColors[bisDisabledHot, ipBody] := HotBtnFace;
  BtnItemColors[bisDisabledHot, ipText] := DisabledText;
  BtnItemColors[bisDisabledHot, ipFrame] := clNone;

  BtnItemColors[bisSelectedHot, ipBody] := Blend(BaseColor, clWhite, 25);
  SetContrast(BtnItemColors[bisSelectedHot, ipBody], ToolbarColor, 30);
  BtnItemColors[bisSelectedHot, ipText] := clWhite;
  SetContrast(BtnItemColors[bisSelectedHot, ipText], BtnItemColors[bisSelectedHot, ipBody], 180);
  BtnItemColors[bisSelectedHot, ipFrame] := Blend(BaseColor, clWhite, 25);
  SetContrast(BtnItemColors[bisSelectedHot, ipFrame], BtnItemColors[bisSelectedHot, ipBody], 100);

  BtnItemColors[bisPopupParent, ipBody] := Blend(BaseColor, clWhite, 80);
  BtnItemColors[bisPopupParent, ipText] := clBlack;
  BtnItemColors[bisPopupParent, ipFrame] := BaseColor;

  MenuItemColors[misNormal, ipBody] := clNone;
  MenuItemColors[misNormal, ipText] := clBlack;
  SetContrast(MenuItemColors[misNormal, ipText], PopupColor, 180);
  MenuItemColors[misNormal, ipFrame] := clNone;

  MenuItemColors[misDisabled, ipBody] := clNone;
  MenuItemColors[misDisabled, ipText] := Blend(clGray, clWhite, 70);
  SetContrast(MenuItemColors[misDisabled, ipText], PopupColor, 80);
  MenuItemColors[misDisabled, ipFrame] := clNone;

  MenuItemColors[misHot, ipBody] := BaseColor;
  MenuItemColors[misHot, ipText] := clWhite;
  MenuItemColors[misHot, ipFrame] := BtnItemColors[bisHot, ipFrame];

  MenuItemColors[misDisabledHot, ipBody] := PopupColor;
  MenuItemColors[misDisabledHot, ipText] := Blend(clGray, clWhite, 50);
  MenuItemColors[misDisabledHot, ipFrame] := clNone;

{  DragHandleColor := Blend(clGray, clWhite, 75);
  SetContrast(DragHandleColor, ToolbarColor, 85);
  IconShadowColor := Blend(clBlack, HotBtnFace, 25);}

{  ToolbarSeparatorColor := clBlack;
  PopupSeparatorColor := ToolbarSeparatorColor;}

  Undither(MenubarColor);
  Undither(ToolbarColor);
  Undither(PopupColor);
  Undither(DockPanelColor);
  Undither(PopupFrameColor);
  Undither(WinFrameColors[wfsActive, wfpBorder]);
  Undither(WinFrameColors[wfsActive, wfpCaption]);
  Undither(WinFrameColors[wfsActive, wfpCaptionText]);
  Undither(WinFrameColors[wfsInactive, wfpBorder]);
  Undither(WinFrameColors[wfsInactive, wfpCaption]);
  Undither(WinFrameColors[wfsInactive, wfpCaptionText]);
  Undither(PnlFrameColors[wfsActive, wfpBorder]);
  Undither(PnlFrameColors[wfsActive, wfpCaption]);
  Undither(PnlFrameColors[wfsActive, wfpCaptionText]);
  Undither(PnlFrameColors[wfsInactive, wfpBorder]);
  Undither(PnlFrameColors[wfsInactive, wfpCaption]);
  Undither(PnlFrameColors[wfsInactive, wfpCaptionText]);
  Undither(BtnItemColors[bisNormal, ipBody]);
  Undither(BtnItemColors[bisNormal, ipText]);
  Undither(BtnItemColors[bisNormal, ipFrame]);
  Undither(BtnItemColors[bisDisabled, ipBody]);
  Undither(BtnItemColors[bisDisabled, ipText]);
  Undither(BtnItemColors[bisDisabled, ipFrame]);
  Undither(BtnItemColors[bisSelected, ipBody]);
  Undither(BtnItemColors[bisSelected, ipText]);
  Undither(BtnItemColors[bisSelected, ipFrame]);
  Undither(BtnItemColors[bisPressed, ipBody]);
  Undither(BtnItemColors[bisPressed, ipText]);
  Undither(BtnItemColors[bisPressed, ipFrame]);
  Undither(BtnItemColors[bisHot, ipBody]);
  Undither(BtnItemColors[bisHot, ipText]);
  Undither(BtnItemColors[bisHot, ipFrame]);
  Undither(BtnItemColors[bisDisabledHot, ipBody]);
  Undither(BtnItemColors[bisDisabledHot, ipText]);
  Undither(BtnItemColors[bisDisabledHot, ipFrame]);
  Undither(BtnItemColors[bisSelectedHot, ipBody]);
  Undither(BtnItemColors[bisSelectedHot, ipText]);
  Undither(BtnItemColors[bisSelectedHot, ipFrame]);
  Undither(BtnItemColors[bisPopupParent, ipBody]);
  Undither(BtnItemColors[bisPopupParent, ipText]);
  Undither(BtnItemColors[bisPopupParent, ipFrame]);
  Undither(MenuItemColors[misNormal, ipBody]);
  Undither(MenuItemColors[misNormal, ipText]);
  Undither(MenuItemColors[misNormal, ipFrame]);
  Undither(MenuItemColors[misDisabled, ipBody]);
  Undither(MenuItemColors[misDisabled, ipText]);
  Undither(MenuItemColors[misDisabled, ipFrame]);
  Undither(MenuItemColors[misHot, ipBody]);
  Undither(MenuItemColors[misHot, ipText]);
  Undither(MenuItemColors[misHot, ipFrame]);
  Undither(MenuItemColors[misDisabledHot, ipBody]);
  Undither(MenuItemColors[misDisabledHot, ipText]);
  Undither(MenuItemColors[misDisabledHot, ipFrame]);
//  Undither(DragHandleColor);
//  Undither(IconShadowColor);
//  Undither(ToolbarSeparatorColor);
//  Undither(PopupSeparatorColor);
//  Undither(StatusPanelFrameColor);
end;

initialization
  RegisterTBXTheme('MacOSx', TTBXMacOSXg32Theme);
end.
