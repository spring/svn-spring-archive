object WaitForAckForm: TWaitForAckForm
  Left = 527
  Top = 443
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Waiting for acknowledgement'
  ClientHeight = 88
  ClientWidth = 270
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusLabel: TLabel
    Left = 16
    Top = 16
    Width = 218
    Height = 32
    Caption = 'Status: Waiting for server to approve your battle ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object CloseButton: TButton
    Left = 96
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = CloseButtonClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 0
    OnTimer = Timer1Timer
    Left = 40
    Top = 48
  end
end
