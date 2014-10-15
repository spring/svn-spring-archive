object IgnoreListForm: TIgnoreListForm
  Left = 1183
  Top = 694
  Width = 307
  Height = 295
  BorderIcons = [biSystemMenu]
  Caption = 'Ignore list'
  Color = clBtnFace
  Constraints.MaxHeight = 1000
  Constraints.MaxWidth = 1680
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 299
    Height = 268
    Caption = 'Ignore list'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object EnableIgnoresCheckBox: TSpTBXCheckBox
      Left = 24
      Top = 48
      Width = 117
      Height = 15
      Caption = 'Enable ignore list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object DoneButton: TSpTBXButton
      Left = 104
      Top = 232
      Width = 89
      Height = 25
      Caption = 'Done'
      TabOrder = 2
      OnClick = DoneButtonClick
      Cancel = True
    end
    object SpTBXLabel3: TSpTBXLabel
      Left = 24
      Top = 72
      Width = 215
      Height = 13
      Caption = '(To remove item, select it and press DELETE)'
    end
    object IgnoreListBox: TSpTBXListBox
      Left = 24
      Top = 88
      Width = 249
      Height = 137
      ItemHeight = 16
      TabOrder = 4
      OnKeyUp = IgnoreListBoxKeyUp
    end
  end
end
