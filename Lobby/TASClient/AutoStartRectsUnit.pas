unit AutoStartRectsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, SpTBXFormPopupMenu, ComCtrls, SpTBXControls, StdCtrls,
  TntStdCtrls, SpTBXEditors, ExtCtrls, SpTBXItem, SpTBXSkins;

type
  TStartRectangleInfo = class(TObject)
    Rect: TRect; // normalized to 100x100 field
    Ally: Integer; // 0-based
  end;

  TAutoStartRectsForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    SpTBXGroupBox2: TSpTBXGroupBox;
    PosTypeComboBox: TSpTBXComboBox;
    SpTBXLabel3: TSpTBXLabel;
    SpTBXLabel4: TSpTBXLabel;
    SpTBXLabel1: TSpTBXLabel;
    GroupsComboBox: TSpTBXComboBox;
    SpTBXLabel2: TSpTBXLabel;
    LengthTracker: TSpTBXTrackBar;
    ThicknessTracker: TSpTBXTrackBar;
    SpTBXPanel2: TSpTBXPanel;
    PreviewImage: TImage;
    SpTBXLabel5: TSpTBXLabel;
    SpTBXButton1: TSpTBXButton;
    CloseButton: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure RecreatePreview;
    procedure ApplyCurrentConfiguration;

    procedure CloseButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PosTypeComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupsComboBoxChange(Sender: TObject);
    procedure SpTBXButton1Click(Sender: TObject);
    procedure ThicknessTrackerChange(Sender: TObject);
    procedure LengthTrackerChange(Sender: TObject);

  private
    LastConfiguration: TList; // last set of rectangles generated
  public
    { Public declarations }
  end;

var
  AutoStartRectsForm: TAutoStartRectsForm;

implementation

uses BattleFormUnit, PreferencesFormUnit, MainUnit, Misc, gnugettext;

{$R *.dfm}

procedure TAutoStartRectsForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TAutoStartRectsForm.RecreatePreview;
var
  tmp: TStartRectangleInfo;
  Rects: TList; // list of start rectangles
  ScaleX, ScaleY: Single;
  i: Integer;

  procedure DrawRectangle(Rect: TStartRectangleInfo);
  var
    s: string;
    CenterX, CenterY: Integer;
  begin
    // draw the rectangle on the preview image:
    PreviewImage.Picture.Bitmap.Canvas.Pen.Color := $00A2E0EB;
    PreviewImage.Picture.Bitmap.Canvas.Brush.Color := clBlack;
    PreviewImage.Picture.Bitmap.Canvas.Rectangle(Round(Rect.Rect.TopLeft.X * ScaleX), Round(Rect.Rect.TopLeft.Y * ScaleY), Round(Rect.Rect.BottomRight.X * ScaleX), Round(Rect.Rect.BottomRight.Y * ScaleY));

    s := IntToStr(Rect.Ally);
    with PreviewImage.Picture.Bitmap.Canvas do
    begin
      Brush.Style := bsClear;
      Font.Style := [fsBold];
      Font.Color := $00A2E0EB;
      CenterX := Round((Rect.Rect.Left + (Rect.Rect.Right - Rect.Rect.Left) div 2) * ScaleX);
      CenterY := Round((Rect.Rect.Top + (Rect.Rect.Bottom - Rect.Rect.Top) div 2) * ScaleY);
      TextOut(CenterX - TextWidth(s) div 2, CenterY - TextHeight(s) div 2, s);
    end;
  end;

  procedure SwapValues(var v1, v2: Integer);
  var
    temp: Integer;
  begin
    temp := v1;
    v1 := v2;
    v2 := temp;
  end;

begin
  PreviewImage.Canvas.StretchDraw(Rect(0, 0, PreviewImage.Width, PreviewImage.Height), BattleForm.MapImage.Picture.Bitmap);
  ScaleX := PreviewImage.Picture.Bitmap.Width / 100;
  ScaleY := PreviewImage.Picture.Bitmap.Height / 100;
  Rects := TList.Create;

  case GroupsComboBox.ItemIndex of
    0:
    begin // 2 ally teams
      // upper rect:
      tmp := TStartRectangleInfo.Create;
      tmp.Rect.TopLeft.X := (100 - LengthTracker.Position) div 2;
      tmp.Rect.TopLeft.Y := 0;
      tmp.Rect.BottomRight.X := (100 - LengthTracker.Position) div 2 + LengthTracker.Position;
      tmp.Rect.BottomRight.Y := ThicknessTracker.Position div 2;
      tmp.Ally := 0;
      Rects.Add(tmp);

      // bottom rect:
      tmp := TStartRectangleInfo.Create;
      tmp.Rect.TopLeft.X := (100 - LengthTracker.Position) div 2;
      tmp.Rect.TopLeft.Y := 100 - ThicknessTracker.Position div 2;
      tmp.Rect.BottomRight.X := (100 - LengthTracker.Position) div 2 + LengthTracker.Position;
      tmp.Rect.BottomRight.Y := 100;
      tmp.Ally := 1;
      Rects.Add(tmp);
    end;
    1: // 4 ally teams
    begin
      // top-left rect:
      tmp := TStartRectangleInfo.Create;
      tmp.Rect.TopLeft.X := 0;
      tmp.Rect.TopLeft.Y := 0;
      tmp.Rect.BottomRight.X := LengthTracker.Position div 2;
      tmp.Rect.BottomRight.Y := ThicknessTracker.Position div 2;
      tmp.Ally := 0;
      Rects.Add(tmp);

      // top-right rect:
      tmp := TStartRectangleInfo.Create;
      tmp.Rect.TopLeft.X := 100 - LengthTracker.Position div 2;
      tmp.Rect.TopLeft.Y := 0;
      tmp.Rect.BottomRight.X := 100;
      tmp.Rect.BottomRight.Y := ThicknessTracker.Position div 2;
      tmp.Ally := 1;
      Rects.Add(tmp);

      // bottom-left rect:
      tmp := TStartRectangleInfo.Create;
      tmp.Rect.TopLeft.X := 0;
      tmp.Rect.TopLeft.Y := 100 - ThicknessTracker.Position div 2;
      tmp.Rect.BottomRight.X := LengthTracker.Position div 2;
      tmp.Rect.BottomRight.Y := 100;
      tmp.Ally := 2;
      Rects.Add(tmp);

      // bottom-right rect:
      tmp := TStartRectangleInfo.Create;
      tmp.Rect.TopLeft.X := 100 - LengthTracker.Position div 2;
      tmp.Rect.TopLeft.Y := 100 - ThicknessTracker.Position div 2;
      tmp.Rect.BottomRight.X := 100;
      tmp.Rect.BottomRight.Y := 100;
      tmp.Ally := 3;
      Rects.Add(tmp);
    end;
  end; // case

  if PosTypeComboBox.ItemIndex = 1 then // west vs. east
  begin
    // rotate by 90 degrees left (anti-clockwise):
    for i := 0 to Rects.Count-1 do
    begin
      SwapValues(TStartRectangleInfo(Rects[i]).Rect.Left, TStartRectangleInfo(Rects[i]).Rect.Top);
      SwapValues(TStartRectangleInfo(Rects[i]).Rect.Right, TStartRectangleInfo(Rects[i]).Rect.Bottom);
    end;
  end;

  // draw rects:
  for i := 0 to Rects.Count-1 do
    DrawRectangle(Rects[i]);

  // free last configuration and reassign it:
  while LastConfiguration.Count > 0 do
  begin
    TObject(LastConfiguration[0]).Free;
    LastConfiguration.Delete(0);
  end;
  LastConfiguration.Free;
  LastConfiguration := Rects;
end;

procedure TAutoStartRectsForm.ApplyCurrentConfiguration;
var
  i: Integer;
  tmpRect: TRect;
  ScaleX, ScaleY: Single;
begin
  if LastConfiguration = nil then Exit; // this should not really happen!

  if BattleState.Status <> Hosting then
  begin
    BattleForm.AddTextToChat(_('Unable to add start rectangles - only host is allowed change it!'), Colors.Info, 1);
    Exit;
  end;

  if LastConfiguration.Count = 0 then // this should not really happen
  begin
    BattleForm.AddTextToChat(_('Unable to add start rectangles - no rectangles specified!'), Colors.Info, 1);
    Exit;
  end;

  // do it:

  // clear all current start rects:
  for i := 0 to High(BattleState.StartRects) do if BattleState.StartRects[i].Enabled then
  begin
    MainForm.TryToSendCommand('REMOVESTARTRECT', IntToStr(i));
    BattleForm.RemoveStartRect(i);
  end;

  // add new start rects:
  BattleForm.StartPosRadioGroup.ItemIndex := 2; // automatically switch to "Choose in game" startpos if not already set
  for i := 0 to LastConfiguration.Count-1 do
  begin
    tmpRect := TStartRectangleInfo(LastConfiguration[i]).Rect;

    BattleForm.AddStartRect(TStartRectangleInfo(LastConfiguration[i]).Ally, tmpRect);

    with BattleState.StartRects[TStartRectangleInfo(LastConfiguration[i]).Ally] do
      MainForm.TryToSendCommand('ADDSTARTRECT', IntToStr(TStartRectangleInfo(LastConfiguration[i]).Ally) + ' ' + IntToStr(tmpRect.Left*2) + ' ' + IntToStr(tmpRect.Top*2) + ' ' + IntToStr(tmpRect.Right*2) + ' ' + IntToStr(tmpRect.Bottom*2) + ' ');
  end;
end;

procedure TAutoStartRectsForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TAutoStartRectsForm.FormShow(Sender: TObject);
begin
  if PosTypeComboBox.ItemIndex = -1 then
    PosTypeComboBox.ItemIndex := 0;
  if GroupsComboBox.ItemIndex = -1 then
    GroupsComboBox.ItemIndex := 0;
  RecreatePreview;
end;

procedure TAutoStartRectsForm.PosTypeComboBoxChange(Sender: TObject);
begin
  RecreatePreview;
end;

procedure TAutoStartRectsForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  LastConfiguration := TList.Create;
end;

procedure TAutoStartRectsForm.GroupsComboBoxChange(Sender: TObject);
begin
  RecreatePreview;
end;

procedure TAutoStartRectsForm.SpTBXButton1Click(Sender: TObject);
begin
     ApplyCurrentConfiguration
end;

procedure TAutoStartRectsForm.ThicknessTrackerChange(Sender: TObject);
begin
  RecreatePreview;
end;

procedure TAutoStartRectsForm.LengthTrackerChange(Sender: TObject);
begin
  RecreatePreview;
end;

end.
