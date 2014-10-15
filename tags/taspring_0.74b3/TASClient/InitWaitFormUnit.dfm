object InitWaitForm: TInitWaitForm
  Left = 627
  Top = 597
  BorderStyle = bsDialog
  Caption = 'Loading ...'
  ClientHeight = 88
  ClientWidth = 246
  Color = clBtnFace
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
    Height = 88
    Caption = 'Loading ...'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object InfoLabel: TSpTBXLabel
      Left = 48
      Top = 46
      Width = 154
      Height = 16
      Caption = 'Here comes the caption ...'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
  object GetUDPPortTimer: TTimer
    Interval = 500
    OnTimer = GetUDPPortTimerTimer
    Left = 8
    Top = 16
  end
end
