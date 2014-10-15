object AgreementForm: TAgreementForm
  Left = 268
  Top = 310
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Agreement'
  ClientHeight = 425
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 8
    Top = 8
    Width = 569
    Height = 297
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object RadioButton1: TRadioButton
    Left = 16
    Top = 320
    Width = 417
    Height = 17
    Caption = 'I have read the agreement and agree to the above terms.'
    TabOrder = 1
  end
  object RadioButton2: TRadioButton
    Left = 16
    Top = 344
    Width = 417
    Height = 17
    Caption = 'I do not agree to these terms.'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object Button1: TButton
    Left = 224
    Top = 384
    Width = 137
    Height = 25
    Caption = 'Continue'
    TabOrder = 3
    OnClick = Button1Click
  end
end
