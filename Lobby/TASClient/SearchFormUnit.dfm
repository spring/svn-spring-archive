object SearchForm: TSearchForm
  Left = 655
  Top = 168
  Width = 204
  Height = 179
  Caption = 'SearchForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainDisplayPanel: TSpTBXPanel
    Left = 0
    Top = 0
    Width = 196
    Height = 152
    Caption = 'MainDisplayPanel'
    Align = alClient
    TabOrder = 0
    Borders = False
    TBXStyleBackground = True
    object SpTBXLabel1: TSpTBXLabel
      Left = 24
      Top = 8
      Width = 106
      Height = 13
      Caption = 'Search for keyword(s):'
    end
    object KeywordEdit: TSpTBXEdit
      Left = 32
      Top = 24
      Width = 129
      Height = 21
      TabOrder = 1
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 24
      Top = 56
      Width = 48
      Height = 13
      Caption = 'Search in:'
    end
    object CategorySearchBox: TSpTBXComboBox
      Left = 32
      Top = 72
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = 'All'
      Items.Strings = (
        'All'
        'Title'
        'File Name'
        'Description')
    end
    object SpTBXButton1: TSpTBXButton
      Left = 16
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Go!'
      TabOrder = 4
      OnClick = SpTBXButton1Click
      Default = True
    end
    object SpTBXButton2: TSpTBXButton
      Left = 104
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 5
      OnClick = SpTBXButton2Click
      Cancel = True
    end
  end
end
