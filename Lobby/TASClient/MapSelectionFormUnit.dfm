object MapSelectionForm: TMapSelectionForm
  Left = 728
  Top = 171
  Width = 243
  Height = 355
  Caption = 'MapSelectionForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainDisplayPanel: TSpTBXPanel
    Left = 0
    Top = 0
    Width = 235
    Height = 328
    Caption = 'MainDisplayPanel'
    Align = alClient
    TabOrder = 0
    Borders = False
    TBXStyleBackground = True
    DesignSize = (
      235
      328)
    object MapListBox: TSpTBXListBox
      Left = 4
      Top = 40
      Width = 221
      Height = 284
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 16
      TabOrder = 0
      OnDblClick = MapListBoxDblClick
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 8
      Top = 10
      Width = 28
      Height = 13
      Caption = 'Filter :'
    end
    object FilterTextBox: TSpTBXEdit
      Left = 40
      Top = 8
      Width = 177
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      OnChange = FilterTextBoxChange
    end
    object Panel1: TPanel
      Left = 8
      Top = 33
      Width = 209
      Height = 2
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvLowered
      TabOrder = 3
    end
  end
end
