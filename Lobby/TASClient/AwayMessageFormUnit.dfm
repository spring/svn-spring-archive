object AwayMessageForm: TAwayMessageForm
  Left = 566
  Top = 224
  Width = 460
  Height = 225
  BorderIcons = [biSystemMenu]
  Caption = 'AwayMessageForm'
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
    Width = 452
    Height = 198
    Caption = 'New away message ...'
    Active = False
    FixedSize = True
    Options.Maximize = False
    object TitleEdit: TSpTBXEdit
      Left = 64
      Top = 40
      Width = 377
      Height = 21
      TabOrder = 0
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 8
      Top = 40
      Width = 26
      Height = 13
      Caption = 'Title :'
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 8
      Top = 64
      Width = 49
      Height = 13
      Caption = 'Message :'
    end
    object CancelButton: TSpTBXButton
      Left = 320
      Top = 160
      Width = 121
      Height = 25
      Caption = 'Cancel'
      TabOrder = 4
      OnClick = CancelButtonClick
    end
    object SaveAndUseButton: TSpTBXButton
      Left = 192
      Top = 160
      Width = 121
      Height = 25
      Caption = 'Save and Use'
      TabOrder = 3
      OnClick = SaveAndUseButtonClick
    end
    object UseButton: TSpTBXButton
      Left = 64
      Top = 160
      Width = 121
      Height = 25
      Caption = 'Use'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = UseButtonClick
    end
    object MessageRichEdit: TRichEdit
      Left = 64
      Top = 64
      Width = 377
      Height = 89
      TabOrder = 1
    end
  end
end
