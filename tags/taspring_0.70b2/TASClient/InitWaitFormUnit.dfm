object InitWaitForm: TInitWaitForm
  Left = 627
  Top = 597
  BorderStyle = bsDialog
  Caption = 'Loading ...'
  ClientHeight = 65
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
  object InfoLabel: TLabel
    Left = 48
    Top = 24
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
  object GetUDPPortTimer: TTimer
    Interval = 500
    OnTimer = GetUDPPortTimerTimer
    Left = 8
    Top = 16
  end
end
