object SearchPlayerForm: TSearchPlayerForm
  Left = 722
  Top = 441
  Width = 205
  Height = 161
  Caption = 'SearchPlayerForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXLabel1: TSpTBXLabel
    Left = 24
    Top = 8
    Width = 86
    Height = 13
    Caption = 'Search for player :'
  end
  object KeywordEdit: TSpTBXEdit
    Left = 32
    Top = 24
    Width = 129
    Height = 21
    TabOrder = 0
    OnKeyUp = KeywordEditKeyUp
  end
  object btCancel: TSpTBXButton
    Left = 104
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btCancelClick
    Cancel = True
  end
  object btGO: TSpTBXButton
    Left = 16
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Go!'
    TabOrder = 3
    OnClick = btGOClick
    Default = True
  end
  object SpTBXLabel2: TSpTBXLabel
    Left = 16
    Top = 88
    Width = 161
    Height = 33
    Caption = 'Hint : Click on GO and then hit F3 to get the next result.'
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Wrapping = twWrap
  end
end
