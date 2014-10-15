object DebugForm: TDebugForm
  Left = 285
  Top = 195
  BorderStyle = bsDialog
  Caption = 'Debug options'
  ClientHeight = 108
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 80
    Top = 72
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 16
    Width = 297
    Height = 17
    Caption = 'Enable debug mode'
    TabOrder = 1
  end
  object CheckBox2: TCheckBox
    Left = 24
    Top = 40
    Width = 297
    Height = 17
    Caption = 'Filter ping-pong in debug mode'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 176
    Top = 72
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'LUA script|*.lua'
    Left = 280
    Top = 72
  end
end
