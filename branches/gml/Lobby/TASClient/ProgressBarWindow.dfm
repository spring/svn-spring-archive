object ProgressBarForm: TProgressBarForm
  Left = 353
  Top = 515
  Width = 433
  Height = 92
  Caption = 'ProgressBarForm'
  Color = clBtnFace
  Constraints.MaxHeight = 1000
  Constraints.MaxWidth = 1680
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 425
    Height = 65
    Caption = 'SpTBXTitleBar1'
    FixedSize = True
    Options.Close = False
    Options.Minimize = False
    Options.Maximize = False
    object pb: TSpTBXProgressBar
      Left = 8
      Top = 32
      Width = 345
      Height = 25
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      CaptionGlowColor = clBlack
      Smooth = True
      ThemeType = thtTBX
    end
    object CancelButton: TSpTBXButton
      Left = 360
      Top = 32
      Width = 57
      Height = 25
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = CancelButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
