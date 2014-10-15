object ProgressBarForm: TProgressBarForm
  Left = 353
  Top = 515
  Width = 433
  Height = 101
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'ProgressBarForm'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 425
    Height = 74
    Caption = 'SpTBXTitleBar1'
    Active = False
    FixedSize = True
    Options.Close = False
    Options.Minimize = False
    Options.Maximize = False
    object TBControlItem1: TTBControlItem
    end
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 425
      Height = 52
      Align = alClient
      TabOrder = 1
      BorderType = pbrFramed
      TBXStyleBackground = True
      object pb: TSpTBXProgressBar
        Left = 8
        Top = 10
        Width = 345
        Height = 25
        Caption = '0%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        CaptionGlow = gldBottomRight
        CaptionGlowColor = clBlack
        Smooth = True
      end
      object CancelButton: TSpTBXButton
        Left = 360
        Top = 10
        Width = 57
        Height = 25
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = CancelButtonClick
      end
    end
  end
end
