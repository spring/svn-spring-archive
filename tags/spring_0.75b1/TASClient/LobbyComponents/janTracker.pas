unit janTracker;

{

Modification by Betalord, 26/07/05:

This is a slightly modified version of janTracker component. It contains new
event which is triggered when user releases mouse button once he is finished
setting the value (event is not triggered if value is changed programatically).
I also fixed a bug when width and height got mixed up in design state when
opening the project. Nevertheless, thumb still doesn't get positioned
correctly when you open the project (it's a bit too much to the left).

24/08/06:
Fixed jtbVertical positioned trackers changing their width/height in
design state upon opening the project. This was fixed by taking in account
csReading state in ComponentState.

---------------------------------------------------------------------------

  Version 1.2
    2-jul-2000 by Jan Verhoeven
      bugfixes: border-line and vertical orientation behavior.

  Version 1.1
    18/04/00 - Changed Made By Steve Childs (Steve@childs-play-software.co.uk)
    * Added Double Buffering to elimate flicker when the control repaints
    * Improved Mouse interaction, it now continues to update the position
      of the position indicator outside of the the Track Rect, aslong as the
      first click was inside the Track Rect. i.e. it captures the mouse like
      a normal windows trackbar.
}


interface

uses                             
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TonChangedValue= procedure (sender:TObject;NewValue:integer) of object;
  TOnMouseUpAfterChange = procedure (Sender: TObject) of object;

  TjtbOrientation=(jtbHorizontal,jtbVertical);

  TjanTracker = class(TCustomControl)
  private
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
    procedure Paint; override;
  published
    { Published declarations }
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
  RegisterComponents('Spring lobby', [TjanTracker]);
end;

{ TjanTracker }

constructor TjanTracker.Create(AOwner: TComponent);
begin
  inherited;
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

procedure TjanTracker.UpdateValue;
begin
  FValue:=round(FMinimum+(FTumbPosition-FTumbMin)/(FTumbMax-FTumbMin)*(FMaximum-FMinimum));
end;

procedure TjanTracker.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
  if (ssleft in shift) then
    if ptinRect(FHitRect,point(x,y)) then
    begin
      {
       Added By Steve Childs 18/04/00 - Set Flag To Tell MouseMove event that
       the mouse was originally clicked in the Track Rect
      }
      FbClickWasInRect := True;
      case Orientation of
        jtbHorizontal: FTumbPosition:=x;
        jtbVertical  : FTumbPosition:=y;
      end;
      UpdateValue;
      SetTumbRect;
      invalidate;
      dochangedValue(FValue);
    end;
end;

procedure TjanTracker.SetTumbMinMax;
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

procedure TjanTracker.SetTrackRect;
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

procedure TjanTracker.SetTumbRect;
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


procedure TjanTracker.Paint;
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
    if assigned(FBackBitmap) and (FBackBitmap.Height <> 0) and (FBackBitmap.Width <> 0) then
      DrawBackBitmap
    else
      DrawBackground;
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

procedure TjanTracker.SetBackColor(const Value: TColor);
begin
  FBackColor := Value;
  invalidate;
end;

procedure TjanTracker.SetMaximum(const Value: integer);
begin
  if value>FMinimum then
  begin
    FMaximum := Value;
    if FValue>FMaximum then
      FValue:=FMaximum;
    UpdatePosition;
  end;
end;

procedure TjanTracker.SetMinimum(const Value: integer);
begin
  if value<FMaximum then
  begin
    FMinimum := Value;
    if FValue<FMinimum then
      FValue:=FMinimum;
    UpdatePosition;
  end;
end;

procedure TjanTracker.UpdatePosition;
var fac:extended;
begin
  fac:=(FValue-FMinimum)/(FMaximum-FMinimum);
  FTumbPosition:=FTumbMin+round((FTumbMax-FTumbMin)*fac);
  invalidate;
end;

procedure TjanTracker.SetTrackColor(const Value: TColor);
begin
  FTrackColor := Value;
  invalidate;
end;

procedure TjanTracker.SetTumbColor(const Value: TColor);
begin
  FTumbColor := Value;
  invalidate;
end;

procedure TjanTracker.SetValue(const Value: integer);
begin
  if (FValue>=FMinimum) and (FValue<=FMaximum) then
  begin
    FValue := Value;
    UpdatePosition;
    invalidate;
  end;
end;

procedure TjanTracker.SetTumbWidth(const Value: integer);
begin
  FTumbWidth := Value;
  SetTumbMinMax;
  SetTumbrect;
  SetTrackRect;
  invalidate;
end;

procedure TjanTracker.SetTumbHeight(const Value: integer);
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

procedure TjanTracker.SetTrackHeight(const Value: integer);
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

procedure TjanTracker.SetOnChangedValue(const Value: TonChangedValue);
begin
  FonChangedValue := Value;
end;

procedure TjanTracker.SetOnMouseUpAfterChange(const Value: TOnMouseUpAfterChange);
begin
  FOnMouseUpAfterChange := Value;
end;

procedure TjanTracker.doChangedValue(NewValue: integer);
begin
  if assigned(onChangedValue) then
   onchangedvalue(self,NewValue);
end;

procedure TjanTracker.Resize;
begin
  inherited;
  SetTumbMinMax;
  SetTrackRect;
  UpdatePosition;
end;

procedure TjanTracker.SetCaptionColor(const Value: TColor);
begin
  FCaptionColor := Value;
  invalidate;
end;

procedure TjanTracker.SetShowCaption(const Value: boolean);
begin
  FShowCaption := Value;
  invalidate;
end;

procedure TjanTracker.SetBackBorder(const Value: boolean);
begin
  FBackBorder := Value;
  invalidate
end;

procedure TjanTracker.SetTrackBorder(const Value: boolean);
begin
  FTrackBorder := Value;
  invalidate
end;

procedure TjanTracker.SetTumbBorder(const Value: boolean);
begin
  FTumbBorder := Value;
  invalidate;
end;

procedure TjanTracker.SetCaptionBold(const Value: boolean);
begin
  FCaptionBold := Value;
  invalidate;
end;

procedure TjanTracker.SetOrientation(const Value: TjtbOrientation);
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

procedure TjanTracker.SetBackBitmap(const Value: TBitmap);
begin
  FBackBitmap.assign(Value);
end;

procedure TjanTracker.BackBitmapChanged(sender: TObject);
begin
  invalidate;
end;

procedure TjanTracker.WMEraseBkgnd(var Msg: TWmEraseBkgnd);
{ Added By Steve Childs 18/04/00
  This elimates the flickering background when the thumb is updated
}
Begin
{ Added By Steve Childs 18/04/00 - Tell Windows that we have cleared background }
  msg.Result := -1
End;

procedure TjanTracker.MouseMove(Shift: TShiftState; X, Y: Integer);
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

procedure TjanTracker.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if FbClickWasInRect then
    if Assigned(OnMouseUpAfterChange) then OnMouseUpAfterChange(Self);

  { Added By Steve Childs 18/04/00 -  Clear Flag}
  FbClickWasInRect := False;
  inherited;
end;

procedure TjanTracker.SetBorderColor(const Value: Tcolor);
begin
  FBorderColor := Value;
end;

procedure TjanTracker.SetTrackPositionColor(const Value: boolean);
begin
  FTrackPositionColor := Value;
  invalidate;
end;

end.
