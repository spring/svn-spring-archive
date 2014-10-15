object MinimapZoomedForm: TMinimapZoomedForm
  Left = 293
  Top = 215
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderStyle = bsDialog
  Caption = 'Minimap'
  ClientHeight = 512
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 512
    Height = 512
    Cursor = crHandPoint
    Stretch = True
    OnMouseDown = Image1MouseDown
  end
end
