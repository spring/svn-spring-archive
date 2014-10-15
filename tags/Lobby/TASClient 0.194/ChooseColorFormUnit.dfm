object ChooseColorForm: TChooseColorForm
  Left = 479
  Top = 391
  BorderStyle = bsDialog
  Caption = 'Team color'
  ClientHeight = 132
  ClientWidth = 232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CancelButton: TButton
    Left = 80
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = CancelButtonClick
  end
end
