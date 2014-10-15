object MinimapZoomedForm: TMinimapZoomedForm
  Left = 636
  Top = 360
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderStyle = bsDialog
  Caption = 'Minimap'
  ClientHeight = 485
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 512
    Height = 512
    OnMouseDown = Image1MouseDown
  end
  object LocalConnection1: TLocalConnection
    Left = 544
    Top = 120
  end
end
