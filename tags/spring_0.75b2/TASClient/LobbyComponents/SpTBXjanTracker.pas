unit SpTBXjanTracker;

{
  28/09/06
  This is a quick fix for TjanTracker transparency problem. Background is drawn using TBX themes
  rather than preset color/bitmap. The code here barely works, this is only a temporary fix so that
  the component would be "compatible" with TASClient 0.30!
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SpTBXControls, SpTBXItem, TBXThemes, TBX, Math;

type
  TonChangedValue= procedure (sender:TObject;NewValue:integer) of object;
  TOnMouseUpAfterChange = procedure (Sender: TObject) of object;

  TjtbOrientation=(jtbHorizontal,jtbVertical);

  TSpTBXjanTracker = class(TCustomControl)
  private
    FThemeType: TSpTBXThemeType;

    FHitRect:TRect;
    FTrackRect:TRect;
    FTumbRect:TRect;
    FTumbPosition:integer;
    FTumbMin:integer;
    FTumbmax:integer;
    FValue: integer;
    FMinimum: integer;
    FMaximum: integer;
    FTrackColor: TColor;
    FTumbColor: TColor;
    FBackColor: TColor;
    FTumbWidth: integer;
    FTumbHeight: integer;
    FTrackHeight: integer;
    FonChangedValue: TonChangedValue;
    FOnMouseUpAfterChange: TOnMouseUpAfterChange;
    FShowCaption: boolean;
    FCaptionColor: TColor;
    FTrackBorder: boolean;
    FTumbBorder: boolean;
    FBackBorder: boolean;
    FCaptionBold: boolean;
    FOrientation: TjtbOrientation;
    FBackBitmap: TBitmap;
    { Added By Steve Childs, 18/4/00 }
    FbClickWasInRect : Boolean;
    FBorderColor: Tcolor;
    FTrackPositionColor: boolean; // Was the original mouse click in the Track Rect ?

    procedure SetThemeType(const Value: TSpTBXThemeType);
//***    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
    procedure ForceRepaint;

{    ala:
    function DoDrawChannel(ACanvas: TCanvas; ARect: TRect; const PaintStage: TSpTBXPaintStage): Boolean; virtual;
    function DoDrawChannelTics(ACanvas: TCanvas; X, Y: Integer): Boolean; virtual;
    function DoDrawThumb(ACanvas: TCanvas; ARect: TRect; const PaintStage: TSpTBXPaintStage): Boolean; virtual;

    property ThemeType: TSpTBXThemeType read FThemeType write SetThemeType default thtWindows;

    *** uporablji procedure SpDrawXPTrackBar(ACanvas: TCanvas; ARect: TRect; Part: Cardinal; Vertical, Pushed: Boolean; TickMark: TSpTBXTickMark; Min, Max, SelStart, SelEnd: Integer; ThemeType: TSpTBXThemeType);
        morda?
}


    procedure SetMaximum(const Value: integer);
    procedure SetMinimum(const Value: integer);
    procedure SetValue(const Value: integer);
    procedure SetBackColor(const Value: TColor);
    procedure SetTrackColor(const Value: TColor);
    procedure SetTumbColor(const Value: TColor);
    procedure SetTumbWidth(const Value: integer);
    procedure SetTrackRect;
    procedure SetTumbMinMax;
    procedure SetTumbRect;
    procedure SetTumbHeight(const Value: integer);
    procedure SetTrackHeight(const Value: integer);
    procedure UpdatePosition;
    procedure SetOnChangedValue(const Value: TonChangedValue);
    procedure SetOnMouseUpAfterChange(const Value: TOnMouseUpAfterChange);
    procedure UpdateValue;
    procedure SetCaptionColor(const Value: TColor);
    procedure SetShowCaption(const Value: boolean);
    procedure SetBackBorder(const Value: boolean);
    procedure SetTrackBorder(const Value: boolean);
    procedure SetTumbBorder(const Value: boolean);
    procedure SetCaptionBold(const Value: boolean);
    procedure SetOrientation(const Value: TjtbOrientation);
    procedure SetBackBitmap(const Value: TBitmap);
    procedure BackBitmapChanged(sender:TObject);
    { Added By Steve Childs, 18/4/00 }
    procedure WMEraseBkgnd(var Msg: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure SetBorderColor(const Value: Tcolor);
    procedure SetTrackPositionColor(const Value: boolean);

    { Private declarations }
  protected
    { Protected declarations }
    procedure doChangedValue(NewValue:integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    { Added By Steve Childs, 18/4/00 }
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);override;
    { Added By Steve Childs, 18/4/00 }
    procedure MouseUp(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);override;
    procedure Resize; override;

  public
    { Public declarations }
    constructor Create (AOwner:TComponent);override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    { Published declarations }

    property ThemeType: TSpTBXThemeType read FThemeType write SetThemeType default thtTBX;

    property Minimum:integer read FMinimum write SetMinimum;
    property Maximum:integer read FMaximum write SetMaximum;
    property Value:integer read FValue write SetValue;
    property Orientation:TjtbOrientation read FOrientation write SetOrientation;
    property BackBitmap:TBitmap read FBackBitmap write SetBackBitmap;
    property BackColor:TColor read FBackColor write SetBackColor;
    property BackBorder:boolean read FBackBorder write SetBackBorder;
    property TrackColor:TColor read FTrackColor write SetTrackColor;
    property TrackPositionColor:boolean read FTrackPositionColor write SetTrackPositionColor;
    property TrackBorder:boolean read FTrackBorder write SetTrackBorder;
    property BorderColor:Tcolor read FBorderColor write SetBorderColor;
    {
      Changed Next 4 By Steve Childs, 18/4/00, Corrects Spelling Mistake
      Although, this may cause more trouble than it's worth with exisiting users
      So you might want to comment these out
    }
    property ThumbColor:TColor read FTumbColor write SetTumbColor;
    property ThumbBorder:boolean read FTumbBorder write SetTumbBorder;
    property ThumbWidth:integer read FTumbWidth write SetTumbWidth;
    property ThumbHeight:integer read FTumbHeight write SetTumbHeight;


    property TrackHeight:integer read FTrackHeight write SetTrackHeight;
    property ShowCaption:boolean read FShowCaption write SetShowCaption;
    property CaptionColor:TColor read FCaptionColor write SetCaptionColor;
    property CaptionBold:boolean read FCaptionBold write SetCaptionBold;
    property onChangedValue:TonChangedValue read FonChangedValue write SetOnChangedValue;
    property OnMouseUpAfterChange: TOnMouseUpAfterChange read FOnMouseUpAfterChange write SetOnMouseUpAfterChange;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Spring lobby', [TSpTBXjanTracker]);
end;

{ TSpTBXjanTracker }

constructor TSpTBXjanTracker.Create(AOwner: TComponent);
begin
  inherited;
  
  FThemeType := thtWindows;
  AddThemeNotification(Self);

  width:=150;
  height:=24;
  FOrientation:=jtbHorizontal;
  FTrackHeight:=6;
  FTumbWidth:=20;
  FTumbHeight:=16;
  FBackColor:=clsilver;
  FTrackColor:=clgray;
  FTrackBorder:=true;
  FBorderColor:=clblack;
  FTumbColor:=clsilver;
  FCaptioncolor:=clblack;
  FShowCaption:=true;
  FMinimum:=0;
  FMaximum:=100;
  FValue:=0;
  FBackBitmap := TBitmap.Create;
  FBackBitmap.OnChange := BackBitmapChanged;
end;

destructor TSpTBXjanTracker.Destroy;
begin
  RemoveThemeNotification(Self);
  inherited;
end;

procedure TSpTBXjanTracker.ForceRepaint;
begin
  // NM_CUSTOMDRAW messages are not sent when calling Invalidate, we must
  // recreate the window
  if HandleAllocated then RecreateWnd;
end;

procedure TSpTBXjanTracker.SetThemeType(const Value: TSpTBXThemeType);
begin
  if Value <> FThemeType then begin
    FThemeType := Value;
    ForceRepaint;
  end;
end;

procedure TSpTBXjanTracker.TBMThemeChange(var Message: TMessage);
begin
  inherited;
  if Message.WParam = TSC_AFTERVIEWCHANGE then
    ForceRepaint;
end;

{ ***
hmmm tole bo treba še pogruntat èe sploh potrebujem. Namreè ostale sptbx komponente
tega eventa sploh ne handlajo!
procedure TSpTBXjanTracker.CNNotify(var Message: TWMNotify);
var
  Info: PNMCustomDraw;
  ACanvas: TCanvas;
  R: TRect;
  Rgn: HRGN;
  Offset: Integer;
begin
  if Message.NMHdr.code = NM_CUSTOMDRAW then begin
    Message.Result := CDRF_DODEFAULT;
    Info := Pointer(Message.NMHdr);
    case Info.dwDrawStage of
      CDDS_PREPAINT:
        Message.Result := CDRF_NOTIFYITEMDRAW;
      CDDS_ITEMPREPAINT:
        begin
          ACanvas := TCanvas.Create;
          ACanvas.Lock;
          try
            ACanvas.Handle := Info.hdc;
            Case Info.dwItemSpec of
              TBCD_TICS:
                begin
                  R := ClientRect;
                  SpDrawParentBackground(Self, ACanvas.Handle, R);
                  if Focused then
                    SpDrawFocusRect(ACanvas, R);
                  if FTickMarks = tmxCenter then
                    Message.Result := CDRF_SKIPDEFAULT;
                end;
              TBCD_THUMB:
                begin
                  SendMessage(Handle, TBM_GETTHUMBRECT, 0, Integer(@R));
                  if DoDrawThumb(ACanvas, R, pstPrePaint) then
                    SpDrawXPTrackBar(ACanvas, R, TBCD_THUMB, Orientation = trVertical, MouseInThumb, FTickMarks, Min, Max, SelStart, SelEnd, FThemeType);
                  DoDrawThumb(ACanvas, R, pstPostPaint);
                  Message.Result := CDRF_SKIPDEFAULT;
                end;
              TBCD_CHANNEL:
                begin
                  SendMessage(Handle, TBM_GETTHUMBRECT, 0, Integer(@R));
                  Offset := 0;
                  if Focused then
                    Inc(Offset);
                  if Orientation = trHorizontal then begin
                    R.Left := ClientRect.Left + Offset;
                    R.Right := ClientRect.Right - Offset;
                  end
                  else begin
                    R.Top := ClientRect.Top + Offset;
                    R.Bottom := ClientRect.Bottom - Offset;
                  end;
                  with R do
                    Rgn := CreateRectRgn(Left, Top, Right, Bottom);
                  SelectClipRgn(Info.hDC, Rgn);
                  try
                    SpDrawParentBackground(Self, ACanvas.Handle, ClientRect);
                    R := ChannelRect;

                    if DoDrawChannel(ACanvas, R, pstPrePaint) then
                      SpDrawXPTrackBar(ACanvas, R, TBCD_CHANNEL, Orientation = trVertical, False, FTickMarks, Min, Max, SelStart, SelEnd, FThemeType);
                    DoDrawChannel(ACanvas, R, pstPostPaint);

                    // Draw channel tics
                    if FTickMarks = tmxCenter then
                      DrawChannelTics(ACanvas);
                  finally
                    DeleteObject(Rgn);
                    SelectClipRgn(Info.hDC, 0);
                  end;
                  Message.Result := CDRF_SKIPDEFAULT;
                end;
            end;
          finally
            ACanvas.Unlock;
            ACanvas.Handle := 0;
            ACanvas.Free;
          end;
        end;
    end;
  end;
end;
}

procedure TSpTBXjanTracker.UpdateValue;
begin
  FValue:=round(FMinimum+(FTumbPosition-FTumbMin)/(FTumbMax-FTumbMin)*(FMaximum-FMinimum));
end;

procedure TSpTBXjanTracker.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
  if (ssleft in shift) then
    if ptinRect(FHitRect,point(x,y)) or ptinRect(FTumbRect,point(x,y)) then // fix by Betalord
    begin
      {
       Added By Steve Childs 18/04/00 - Set Flag To Tell MouseMove event that
       the mouse was originally clicked in the Track Rect
      }
      FbClickWasInRect := True;
      case Orientation of
        jtbHorizontal: FTumbPosition:=Max(FHitRect.Left, Min(x, FHitRect.Right)); // fix by Betalord
        jtbVertical  : FTumbPosition:=Max(FHitRect.Top, Min(y, FHitRect.Bottom)); // fix by Betalord
      end;
      UpdateValue;
      SetTumbRect;
      invalidate;
      dochangedValue(FValue);
    end;
end;

procedure TSpTBXjanTracker.SetTumbMinMax;
begin
  case Orientation of
  jtbHorizontal:
    begin
      FTumbMin:=5+(FTumbwidth div 2);
      FTumbMax:=Width-FTumbMin;
    end;
  jtbVertical:
    begin
      FTumbMin:=5+(FTumbHeight div 2);
      FTumbMax:=Height-FTumbMin;
    end;
  end;
end;

procedure TSpTBXjanTracker.SetTrackRect;
var dy,dx:integer;
begin
  case Orientation of
  jtbHorizontal:
  begin
    dy:=(height-FTrackHeight) div 2;
    FTrackRect:=Rect(FTumbMin,dy,FTumbMax,height-dy);
    FHitRect:=FTrackrect;
    inflateRect(FHitRect,0,(FTumbHeight-FTrackHeight) div 2);
  end;
  jtbVertical:
  begin
    dx:=(Width-FTrackHeight) div 2;
    FTrackRect:=Rect(dx,FTumbMin,Width-dx,FTumbMax);
    FHitRect:=FTrackrect;
    inflateRect(FHitRect,(FTumbWidth-FTrackHeight) div 2,0);
  end;
  end;
end;

procedure TSpTBXjanTracker.SetTumbRect;
var dx,dy:integer;
begin
  case Orientation of
  jtbHorizontal:
    begin
      dx:=FTumbWidth div 2;
      dy:=(height-FTumbHeight) div 2;
      FTumbrect:=Rect(FTumbPosition-dx,dy,FTumbPosition+dx,height-dy);
    end;
  jtbVertical:
    begin
      dy:=FTumbHeight div 2;
      dx:=(Width-FTumbWidth) div 2;
      FTumbrect:=Rect(dx,FTumbPosition-dy,Width-dx,FTumbPosition+dy);
    end;
  end;
end;


procedure TSpTBXjanTracker.Paint;
var
  s : string;
  {Added By Steve Childs 18/04/00 - Double Buffer Bitmap}
  Buffer : TBitmap;
  col:TColor;
  r,g,b:Byte;
  fact:double;

  procedure DrawBackBitmap;
  var
    ix, iy: Integer;
    BmpWidth, BmpHeight: Integer;
    hCanvas, BmpCanvas: THandle;
    bm: Tbitmap;
  begin
    bm := FBackBitmap;
    begin
      BmpWidth := bm.Width;
      BmpHeight := bm.Height;
      BmpCanvas := bm.Canvas.Handle;
      { Changed By Steve Childs 18/04/00 - Now Points To Buffer.Canvas Bitmap}
      hCanvas := THandle(Buffer.canvas.handle);
      for iy := 0 to ClientHeight div BmpHeight do
        for ix := 0 to ClientWidth div BmpWidth do
          BitBlt(hCanvas, ix * BmpWidth, iy * BmpHeight,
            BmpWidth, BmpHeight, BmpCanvas,
            0, 0, SRCCOPY);
    end;

   { Old Code!!}
{      hCanvas := THandle(canvas.handle);
      for iy := 0 to ClientHeight div BmpHeight do
        for ix := 0 to ClientWidth div BmpWidth do
          BitBlt(hCanvas, ix * BmpWidth, iy * BmpHeight,
            BmpWidth, BmpHeight, BmpCanvas,
            0, 0, SRCCOPY);
    end;}
  end;

  procedure DrawBackGround;
  begin
    { Changed By Steve Childs 18/04/00 - Now Refers To Buffer Bitmap}
    if FBackBorder then begin
      Buffer.canvas.pen.color:=FBorderColor;  // modified 2-jul-2000 by Jan Verhoeven
    end
    else begin
      Buffer.canvas.pen.color:=FBackColor;
    end;
    Buffer.canvas.brush.color:=FBackColor;
    Buffer.canvas.Rectangle (rect(0,0,width,height));
  end;

  procedure DrawTrack;
  begin
    { Changed By Steve Childs 18/04/00 - Now Refers To Buffer Bitmap}
    if FTrackPositionColor then begin  // 2-jul-2000 Jan Verhoeven
      fact:=value/(maximum-minimum);
      r:=getrvalue(FtrackColor);
      g:=getgvalue(FtrackColor);
      b:=getbvalue(FtrackColor);
      col:=rgb(trunc(fact*r),trunc(fact*g),trunc(fact*b));
      Buffer.canvas.brush.color:=col;
    end
    else
      Buffer.canvas.brush.color:=FTrackColor;
    Buffer.canvas.FillRect(FTrackRect);
    Buffer.canvas.pen.style:=pssolid;
    if FTrackBorder then
      Frame3D( Buffer.Canvas, FTrackRect, clBlack, clBtnHighlight, 1 );
  end;

  procedure DrawCaption;
  begin
    { Changed By Steve Childs 18/04/00 - Now Refers To Buffer Bitmap}
    s := intToStr(FValue);
    Buffer.canvas.brush.style:=bsclear;
    if FCaptionBold then
      Buffer.canvas.font.style:=canvas.font.style+[fsbold]
    else
      Buffer.canvas.font.style:=canvas.font.style-[fsbold];
    Buffer.canvas.font.color:=FCaptionColor;
    drawText(Buffer.canvas.handle,pchar(s),-1,FTumbRect,DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
  end;

  procedure DrawTumb;
  begin
    { Changed By Steve Childs 18/04/00 - Now Refers To Buffer Bitmap}
    Buffer.canvas.brush.color:=FTumbColor;
    Buffer.canvas.FillRect(FTumbRect);
    Buffer.canvas.pen.style:=pssolid;
    Frame3D( Buffer.Canvas, FTumbRect, clBtnHighlight, clBlack, 1 );
  end;
  
  var
    ItemInfo: TTBXItemInfo;

begin
  { Added By Steve Childs 18/04/00 - Added Double Buffering}
  Buffer := TBitmap.Create;
  Try
    { Added By Steve Childs 18/04/00 - Setup DoubleBuffer Bitmap}
    Buffer.Width := ClientWidth;
    Buffer.Height := ClientHeight;

    SetTumbMinMax;
    SetTumbRect;
    SetTrackRect;
{
    if assigned(FBackBitmap) and (FBackBitmap.Height <> 0) and (FBackBitmap.Width <> 0) then
      DrawBackBitmap
    else
      DrawBackground;
}
    case ThemeType of
      thtNone: DrawBackground;
      thtTBX:
      begin
        SpFillItemInfo(True, False, True, False, ItemInfo);
        CurrentTheme.PaintButton(Buffer.Canvas, Rect(0, 0, Width, Height), ItemInfo);
      end;
      thtWindows: DrawBackground; //*** fix this! see SpDrawXPTrackBar on how to draw it correctly!
    end; // of case

    DrawTrack;
    DrawTumb;
    if FShowCaption then
      DrawCaption;
  Finally
    { Added By Steve Childs 18/04/00 - Finally, Draw the Buffer Onto Main Canvas}
    Canvas.Draw(0,0,Buffer);
    { Added By Steve Childs 18/04/00 - Free Buffer}
    Buffer.Free;
  End;
end;

procedure TSpTBXjanTracker.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TSpTBXjanTracker.SetMaximum(const Value: integer);
begin
  if value>FMinimum then
  begin
    FMaximum := Value;
    if FValue>FMaximum then
      FValue:=FMaximum;
    UpdatePosition;
  end;
end;

procedure TSpTBXjanTracker.SetMinimum(const Value: integer);
begin
  if value<FMaximum then
  begin
    FMinimum := Value;
    if FValue<FMinimum then
      FValue:=FMinimum;
    UpdatePosition;
  end;
end;

procedure TSpTBXjanTracker.UpdatePosition;
var fac:extended;
begin
  fac:=(FValue-FMinimum)/(FMaximum-FMinimum);
  FTumbPosition:=FTumbMin+round((FTumbMax-FTumbMin)*fac);
  invalidate;
end;

procedure TSpTBXjanTracker.SetTrackColor(const Value: TColor);
begin
  FTrackColor := Value;
  invalidate;
end;

procedure TSpTBXjanTracker.SetTumbColor(const Value: TColor);
begin
  FTumbColor := Value;
  invalidate;
end;

procedure TSpTBXjanTracker.SetValue(const Value: integer);
begin
  if (FValue>=FMinimum) and (FValue<=FMaximum) then
  begin
    FValue := Value;
    UpdatePosition;
    invalidate;
  end;
end;

procedure TSpTBXjanTracker.SetTumbWidth(const Value: integer);
begin
  FTumbWidth := Value;
  SetTumbMinMax;
  SetTumbrect;
  SetTrackRect;
  invalidate;
end;

procedure TSpTBXjanTracker.SetTumbHeight(const Value: integer);
begin
  if value<height then
  begin
    FTumbHeight := Value;
    SetTumbMinMax;
    SetTumbrect;
    SetTrackrect;
    invalidate;
  end;
end;

procedure TSpTBXjanTracker.SetTrackHeight(const Value: integer);
begin
  case Orientation of
  jtbHorizontal:
  begin
    if value<(Height) then
    begin
    FTrackHeight := Value;
    setTrackrect;
    invalidate;
    end;
  end;
  jtbVertical:
  begin
    if value<(Width) then
    begin
    FTrackHeight := Value;
    setTrackrect;
    invalidate;
    end;
  end;
  end;
end;

procedure TSpTBXjanTracker.SetOnChangedValue(const Value: TonChangedValue);
begin
  FonChangedValue := Value;
end;

procedure TSpTBXjanTracker.SetOnMouseUpAfterChange(const Value: TOnMouseUpAfterChange);
begin
  FOnMouseUpAfterChange := Value;
end;

procedure TSpTBXjanTracker.doChangedValue(NewValue: integer);
begin
  if assigned(onChangedValue) then
   onchangedvalue(self,NewValue);
end;

procedure TSpTBXjanTracker.Resize;
begin
  inherited;
  SetTumbMinMax;
  SetTrackRect;
  UpdatePosition;
end;

procedure TSpTBXjanTracker.SetCaptionColor(const Value: TColor);
begin
  FCaptionColor := Value;
  invalidate;
end;

procedure TSpTBXjanTracker.SetShowCaption(const Value: boolean);
begin
  FShowCaption := Value;
  invalidate;
end;

procedure TSpTBXjanTracker.SetBackBorder(const Value: boolean);
begin
  FBackBorder := Value;
  invalidate
end;

procedure TSpTBXjanTracker.SetTrackBorder(const Value: boolean);
begin
  FTrackBorder := Value;
  invalidate
end;

procedure TSpTBXjanTracker.SetTumbBorder(const Value: boolean);
begin
  FTumbBorder := Value;
  invalidate;
end;

procedure TSpTBXjanTracker.SetCaptionBold(const Value: boolean);
begin
  FCaptionBold := Value;
  invalidate;
end;

procedure TSpTBXjanTracker.SetOrientation(const Value: TjtbOrientation);
var
  tmp:integer;
  change: Boolean;
begin
  change := FOrientation <> Value;
  FOrientation:= Value;
  if (csDesigning in ComponentState) and (change) and  not (csReading in ComponentState) then
  begin
    tmp:=width;
    width:=height;
    height:=tmp;
  end;

  if (csDesigning in ComponentState) then
  begin
    SetTumbMinMax;
    UpdatePosition;
    SetTumbRect;
  end; //*** am not sure if this is right. It works more or less though.
  invalidate;
end;

procedure TSpTBXjanTracker.SetBackBitmap(const Value: TBitmap);
begin
  FBackBitmap.assign(Value);
end;

procedure TSpTBXjanTracker.BackBitmapChanged(sender: TObject);
begin
  invalidate;
end;

procedure TSpTBXjanTracker.WMEraseBkgnd(var Msg: TWmEraseBkgnd);
{ Added By Steve Childs 18/04/00
  This elimates the flickering background when the thumb is updated
}
Begin
{ Added By Steve Childs 18/04/00 - Tell Windows that we have cleared background }
  msg.Result := -1
End;

procedure TSpTBXjanTracker.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
 inherited;
 if (ssleft in shift) then
  if FbClickWasInRect then
  begin
    {
      - Added By Steve Childs 18/04/00
      OK, we know that when the mouse button went down, the
      click was in the rect. So, we only need to check that it's now
      within the bounds of the track (otherwise the button goes off the
      end of the track!!)

    }
//    If (X >= FTrackRect.Left) and (X <= FTrackRect.Right) then
    if ptinrect(FTrackRect,point(x,y)) then  // 2-jul-2000 Jan Verhoeven
     If Orientation = jtbHorizontal then
       FTumbPosition := x
     else
       FTumbPosition := y
    Else
    Begin
      { Added By Steve Childs 18/04/00
        If it's off the edges - Set Either to left or right, depending on
        which side the mouse is!!
      }
      // 2-jul-2000 Jan Verhoeven
      if Orientation=jtbHorizontal then begin
        if x<FTrackRect.left then
          FTumbPosition := FTrackRect.Left-1
        else if x>FTrackRect.right then
          FTumbPosition := FTrackRect.Right+1
        else
          FTumbPosition:=x;
      end
      else begin
        if y<FTrackRect.top then
          FTumbPosition := FTrackRect.top-1
        else if y>FTrackRect.bottom then
          FTumbPosition := FTrackRect.bottom+1
        else
          FTumbPosition:=y;
      end;
{      If X < FTrackRect.Left then
        FTumbPosition := FTrackRect.Left-1
      else
        // Must Be Off Right
        FTumbPosition := FTrackRect.Right+1;}
    End;
    UpdateValue;
    SetTumbRect;
    invalidate;
    dochangedValue(FValue);
  end;
end;

procedure TSpTBXjanTracker.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if FbClickWasInRect then
    if Assigned(OnMouseUpAfterChange) then OnMouseUpAfterChange(Self);

  { Added By Steve Childs 18/04/00 -  Clear Flag}
  FbClickWasInRect := False;
  inherited;
end;

procedure TSpTBXjanTracker.SetBorderColor(const Value: Tcolor);
begin
  FBorderColor := Value;
end;

procedure TSpTBXjanTracker.SetTrackPositionColor(const Value: boolean);
begin
  FTrackPositionColor := Value;
  invalidate;
end;

end.
