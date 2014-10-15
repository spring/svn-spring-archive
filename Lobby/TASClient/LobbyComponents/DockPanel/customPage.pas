unit customPage;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls, Graphics;

type
  tCstPage = class(TPageControl)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); override;    
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('cEdit', [tCstPage]);
end;

procedure AngleTextOut(ACanvas: TCanvas; Angle, X, Y, TabHeight, TabWidth: Integer; Str: string);
var
  LogRec: TLogFont;
  OldFontHandle,
  NewFontHandle: hFont;
  txtRect: Trect;
begin
  GetObject(ACanvas.Font.Handle, SizeOf(LogRec), Addr(LogRec));
  LogRec.lfEscapement := Angle*10;
  NewFontHandle := CreateFontIndirect(LogRec);
  OldFontHandle := SelectObject(ACanvas.Handle, NewFontHandle);
  with txtRect do begin
    Left := x + TabHeight;
    Right := x;
    Top := y + TAbWidth;
    Bottom := y;
  end;
  //ACanvas.TextRect(txtRect, X, Y, Str);
  Acanvas.TextOut(X,y, Str);
  NewFontHandle := SelectObject(ACanvas.Handle, OldFontHandle);
  DeleteObject(NewFontHandle);
end;

procedure DrawRaisedEdge (DC: HDC; R: TRect; const FillInterior: Boolean);
  const
    FillMiddle: array[Boolean] of UINT = (0, BF_MIDDLE);
  begin
    DrawEdge (DC, R, BDR_RAISEDINNER, BF_RECT or FillMiddle[FillInterior]);
  end;

procedure TCstPage.DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  ar, ar2: TRect;
  imgX, imgY, txtX, txtY: Integer;

begin
  Canvas.Pen.Color := clBtnFace;
  Canvas.FillRect(Rect);
  if (TabPosition = tpLeft) or (TabPosition = tpRight) then
    TabWidth := (Height div PageCount) - 10;


  if Active then begin
    if TabPosition = tpTop then begin
      With ar do begin
        Left := rect.Left + 7;
        Right := rect.Left + 9;
        Bottom := rect.Bottom - 9;
        Top := rect.Top + 7;
      end;
      With ar2 do begin
        Left := rect.Left + 10;
        Right := rect.Left + 12;
        Bottom := rect.Bottom - 9;
        Top := rect.Top + 7;
      end;
    end
    else if TabPosition = tpBottom then begin
      With ar do begin
        Left := rect.Left + 7;
        Right := rect.Left + 9;
        Bottom := rect.Bottom - 7;
        Top := rect.Top + 9;
      end;
      With ar2 do begin
        Left := rect.Left + 10;
        Right := rect.Left + 12;
        Bottom := rect.Bottom - 7;
        Top := rect.Top + 9;
      end;
    end
    else begin
      With ar do begin
        Left := rect.Left + 9;
        Right := Rect.Right - 7;
        Bottom := rect.Bottom - 10;
        Top := rect.Bottom - 12;
      end;
      With ar2 do begin
        Left := rect.Left + 9;
        Right := Rect.Right - 7;
        Bottom := rect.Bottom - 7;
        Top := rect.Bottom - 9;
      end;

    end;
  end
  else begin
    if (TabPosition = tpBottom) or (TabPosition = tpTop) then begin
       With ar do begin
         Left := rect.Left + 3;
         Right := rect.Left + 5;
         Bottom := rect.Bottom - 5;
         Top := rect.Top + 5;
       end;
       With ar2 do begin
         Left := rect.Left + 6;
         Right := rect.Left + 8;
         Bottom := rect.Bottom - 5;
         Top := rect.Top + 5;
       end;
    end
    else begin
       With ar do begin
         Left := rect.Left + 6;
         Right := rect.Right - 3;
         Bottom := rect.Bottom - 3;
         Top := rect.Bottom - 5;
       end;
       With ar2 do begin
         Left := rect.Left + 6;
         Right := rect.Right - 3;
         Bottom := rect.Bottom - 6;
         Top := rect.Bottom - 8;
       end;
    end;
  end;
  //Canvas.FrameRect(ar);
  DrawRaisedEdge(canvas.Handle, ar , True);
  DrawRaisedEdge(canvas.Handle, ar2 , True);
  if Active then begin
    if (TabPosition = tpBottom) or (TabPosition = tpTop) then begin
      imgX := Rect.Left + 16;
      imgY := rect.Top + 6;
    end
    else begin
      imgX := Rect.Left + 10;
      imgY := Rect.Bottom - 32;
    end;
  end
  else begin
    if (TabPosition = tpBottom) or (TabPosition = tpTop) then begin
      imgX := Rect.Left + 12;
      imgY := rect.Top + 4;
    end
    else begin
      imgX := Rect.Left + 8;
      imgY := rect.Bottom - 28;
    end;
  end;
    Self.Images.Draw(Canvas, imgX, imgY, Integer(Pages[TabIndex].ImageIndex));

  if (DockHandler.TabType = TTTextIcon) or (DockHandler.Tabtype = ttText) then begin
    if (DockHandler.TType = TTTextIcon) then begin
      if (TabPosition = tpBottom) or (TabPosition = tpTop) then begin
        if Active then begin
          txtX := Rect.Left + 38;
          txtY := Rect.Top + 8;
        end
        else begin
          txtX := Rect.Left + 34;
          txtY := Rect.Top + 6;
        end;
      end
      else begin
        if Active then begin
          txtX := Rect.Left + 10;
          txtY := Rect.Bottom - 38;
        end
        else begin
          txtX := Rect.Left + 8;
          txtY := Rect.Bottom - 34;
        end;
      end;
    end
    else begin
      if (TabPosition = tpBottom) or (TabPosition = tpTop) then begin
        txtX := Rect.Left + 16;
        txtY := Rect.Top + 6;
      end
      else begin
        txtX := Rect.Left + 8;
        txtY := Rect.Bottom - 16;
      end;

   end;
     if (TabPosition = tpBottom) or (TabPosition = tpTop) then
       Canvas.TextOut(txtX, txtY, Pages[TabIndex].Caption)
     else begin
       //TextRotate(Pages[TabIndex].Caption, txtX, txtY, 270);
       AngleTextOut(Canvas, 90, txtX, txtY, TabHeight, TabWidth,Pages[TabIndex].Caption);
     end;

  end;


end;

end.
