object WaitForAckForm: TWaitForAckForm
  Left = 518
  Top = 582
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Waiting for acknowledgement'
  ClientHeight = 114
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
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 270
    Height = 114
    Caption = 'Waiting for acknowledgement'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object StatusLabel: TSpTBXLabel
      Left = 8
      Top = 32
      Width = 257
      Height = 41
      Caption = 'Status: Waiting for server to approve your battle ...'
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Wrapping = twWrap
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object CloseButton: TSpTBXButton
      Left = 96
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = CloseButtonClick
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 0
    OnTimer = Timer1Timer
    Left = 40
    Top = 48
  end
end
