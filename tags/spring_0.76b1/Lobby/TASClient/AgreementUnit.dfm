object AgreementForm: TAgreementForm
  Left = 472
  Top = 303
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Agreement'
  ClientHeight = 451
  ClientWidth = 584
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
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 584
    Height = 451
    Caption = 'Agreement'
    FixedSize = True
    Options.Close = False
    Options.Minimize = False
    Options.Maximize = False
    Options.SystemMenu = False
    TBXStyleBackground = True
    object RichEdit1: TRichEdit
      Left = 8
      Top = 40
      Width = 569
      Height = 297
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object RadioButton1: TSpTBXRadioButton
      Left = 16
      Top = 352
      Width = 288
      Height = 15
      Caption = 'I have read the agreement and agree to the above terms.'
      TabOrder = 2
    end
    object RadioButton2: TSpTBXRadioButton
      Left = 16
      Top = 376
      Width = 156
      Height = 15
      Caption = 'I do not agree to these terms.'
      TabOrder = 3
      TabStop = True
      Checked = True
    end
    object Button1: TSpTBXButton
      Left = 224
      Top = 416
      Width = 137
      Height = 25
      Caption = 'Continue'
      TabOrder = 4
      OnClick = Button1Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
