object InitWaitForm: TInitWaitForm
  Left = 803
  Top = 416
  Width = 254
  Height = 113
  Caption = 'Loading ...'
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 246
    Height = 86
    Caption = 'Loading ...'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 246
      Height = 64
      Align = alClient
      TabOrder = 1
      BorderType = pbrFramed
      TBXStyleBackground = True
      object InfoLabel: TSpTBXLabel
        Left = 46
        Top = 18
        Width = 154
        Height = 16
        Caption = 'Here comes the caption ...'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object GetUDPPortTimer: TTimer
    Interval = 500
    OnTimer = GetUDPPortTimerTimer
    Left = 8
    Top = 16
  end
end
