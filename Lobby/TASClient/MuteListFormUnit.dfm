object MuteListForm: TMuteListForm
  Left = 258
  Top = 186
  BorderStyle = bsDialog
  Caption = 'Mute list'
  ClientHeight = 212
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MuteListBox: TListBox
    Left = 0
    Top = 0
    Width = 354
    Height = 193
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 193
    Width = 354
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object CloseButton: TButton
    Left = 272
    Top = 160
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 2
    OnClick = CloseButtonClick
  end
end
