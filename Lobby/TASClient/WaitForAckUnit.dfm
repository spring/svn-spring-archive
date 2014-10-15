object WaitForAckForm: TWaitForAckForm
  Left = 518
  Top = 582
  Width = 278
  Height = 141
  BorderIcons = [biSystemMenu]
  Caption = 'Waiting for acknowledgement'
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 270
    Height = 114
    Caption = 'Waiting for acknowledgement'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 270
      Height = 92
      Align = alClient
      TabOrder = 1
      BorderType = pbrFramed
      TBXStyleBackground = True
      object StatusLabel: TSpTBXLabel
        Left = 8
        Top = 8
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
      end
      object CloseButton: TSpTBXButton
        Left = 96
        Top = 51
        Width = 75
        Height = 25
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = CloseButtonClick
        Cancel = True
      end
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
