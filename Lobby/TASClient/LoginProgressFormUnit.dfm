object LoginProgressForm: TLoginProgressForm
  Left = 496
  Top = 417
  Width = 306
  Height = 112
  BorderIcons = [biSystemMenu]
  Caption = 'Logging in to the server ...'
  Color = clBtnFace
  Constraints.MaxHeight = 1000
  Constraints.MaxWidth = 1680
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
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 298
    Height = 85
    Caption = 'Logging in to the server ...'
    Active = False
    FixedSize = True
    Options.Close = False
    Options.Minimize = False
    Options.Maximize = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 298
      Height = 63
      Align = alClient
      TabOrder = 1
      BorderType = pbrFramed
      TBXStyleBackground = True
      DesignSize = (
        298
        63)
      object ProgressLabel: TSpTBXLabel
        Left = 76
        Top = 15
        Width = 150
        Height = 16
        Caption = 'Logging in to the server ...'
        Anchors = [akTop]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
  end
end
