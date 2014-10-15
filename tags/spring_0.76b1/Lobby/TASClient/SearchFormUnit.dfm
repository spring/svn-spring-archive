object SearchForm: TSearchForm
  Left = 396
  Top = 300
  Width = 205
  Height = 187
  Caption = 'SearchForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXButton1: TSpTBXButton
    Left = 16
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Go!'
    TabOrder = 1
    OnClick = SpTBXButton1Click
    Default = True
    LinkFont.Charset = DEFAULT_CHARSET
    LinkFont.Color = clBlue
    LinkFont.Height = -11
    LinkFont.Name = 'MS Sans Serif'
    LinkFont.Style = [fsUnderline]
  end
  object SpTBXButton2: TSpTBXButton
    Left = 104
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = SpTBXButton2Click
    Cancel = True
    LinkFont.Charset = DEFAULT_CHARSET
    LinkFont.Color = clBlue
    LinkFont.Height = -11
    LinkFont.Name = 'MS Sans Serif'
    LinkFont.Style = [fsUnderline]
  end
  object KeywordEdit: TSpTBXEdit
    Left = 32
    Top = 24
    Width = 129
    Height = 21
    TabOrder = 0
  end
  object SpTBXLabel1: TSpTBXLabel
    Left = 24
    Top = 8
    Width = 106
    Height = 13
    Caption = 'Search for keyword(s):'
    LinkFont.Charset = DEFAULT_CHARSET
    LinkFont.Color = clBlue
    LinkFont.Height = -11
    LinkFont.Name = 'MS Sans Serif'
    LinkFont.Style = [fsUnderline]
  end
  object SpTBXLabel2: TSpTBXLabel
    Left = 24
    Top = 56
    Width = 48
    Height = 13
    Caption = 'Search in:'
    LinkFont.Charset = DEFAULT_CHARSET
    LinkFont.Color = clBlue
    LinkFont.Height = -11
    LinkFont.Name = 'MS Sans Serif'
    LinkFont.Style = [fsUnderline]
  end
  object CategorySearchBox: TSpTBXComboBox
    Left = 32
    Top = 72
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 5
    Text = 'Title'
    Items.Strings = (
      'Title'
      'File Name'
      'Description')
  end
end
