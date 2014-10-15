object AwayMessageForm: TAwayMessageForm
  Left = 566
  Top = 224
  BorderStyle = bsDialog
  Caption = 'AwayMessageForm'
  ClientHeight = 198
  ClientWidth = 356
  Color = clBtnFace
  Constraints.MaxHeight = 910
  Constraints.MaxWidth = 1280
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 356
    Height = 198
    Caption = 'New away message ...'
    FixedSize = True
    Options.Maximize = False
    object TitleEdit: TSpTBXEdit
      Left = 64
      Top = 40
      Width = 281
      Height = 21
      TabOrder = 1
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 8
      Top = 40
      Width = 26
      Height = 13
      Caption = 'Title :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 8
      Top = 64
      Width = 49
      Height = 13
      Caption = 'Message :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object CancelButton: TSpTBXButton
      Left = 256
      Top = 160
      Width = 89
      Height = 25
      Caption = 'Cancel'
      TabOrder = 4
      OnClick = CancelButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SaveAndUseButton: TSpTBXButton
      Left = 160
      Top = 160
      Width = 89
      Height = 25
      Caption = 'Save and Use'
      TabOrder = 5
      OnClick = SaveAndUseButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object UseButton: TSpTBXButton
      Left = 64
      Top = 160
      Width = 89
      Height = 25
      Caption = 'Use'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = UseButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object MessageRichEdit: TRichEdit
      Left = 64
      Top = 64
      Width = 281
      Height = 89
      TabOrder = 7
    end
  end
end
