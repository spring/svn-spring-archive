object AddBotForm: TAddBotForm
  Left = 339
  Top = 165
  BorderStyle = bsDialog
  Caption = 'Add bot dialog'
  ClientHeight = 223
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 65
    Height = 13
    Caption = 'Choose AI dll:'
  end
  object ReloadButton: TSpeedButton
    Left = 168
    Top = 32
    Width = 73
    Height = 22
    Caption = 'Reload'
    OnClick = ReloadButtonClick
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 55
    Height = 13
    Caption = 'Bot'#39's name:'
  end
  object BotTeamColorButton: TSpeedButton
    Left = 136
    Top = 112
    Width = 105
    Height = 21
    Caption = 'Team color'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000}
    Transparent = False
    OnClick = BotTeamColorButtonClick
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 48
    Height = 13
    Caption = 'Team no.:'
  end
  object Label4: TLabel
    Left = 16
    Top = 136
    Width = 37
    Height = 13
    Caption = 'Ally no.:'
  end
  object BotSideLabel: TLabel
    Left = 136
    Top = 136
    Width = 24
    Height = 13
    Cursor = crHandPoint
    Caption = 'Side:'
    OnClick = BotSideLabelClick
  end
  object AIComboBox: TComboBox
    Left = 16
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object AddBotButton: TButton
    Left = 40
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Add bot'
    Enabled = False
    TabOrder = 1
    OnClick = AddBotButtonClick
  end
  object Button2: TButton
    Left = 144
    Top = 184
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
  object BotNameEdit: TEdit
    Left = 88
    Top = 72
    Width = 113
    Height = 21
    TabOrder = 3
    Text = 'Bot'
  end
  object BotTeamComboBox: TComboBox
    Left = 72
    Top = 112
    Width = 41
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 4
    Text = '1'
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10')
  end
  object BotAllyComboBox: TComboBox
    Left = 72
    Top = 136
    Width = 41
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 5
    Text = '1'
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10')
  end
  object BotSideComboBox: TComboBox
    Left = 164
    Top = 136
    Width = 77
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 6
    OnDrawItem = BotSideComboBoxDrawItem
  end
end
