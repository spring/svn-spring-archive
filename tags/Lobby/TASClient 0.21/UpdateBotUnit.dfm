object UpdateBotForm: TUpdateBotForm
  Left = 354
  Top = 284
  BorderStyle = bsDialog
  Caption = 'Update bot options'
  ClientHeight = 171
  ClientWidth = 296
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BotTeamColorButton: TSpeedButton
    Left = 152
    Top = 15
    Width = 105
    Height = 22
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
    Left = 32
    Top = 16
    Width = 48
    Height = 13
    Caption = 'Team no.:'
  end
  object Label4: TLabel
    Left = 32
    Top = 40
    Width = 37
    Height = 13
    Caption = 'Ally no.:'
  end
  object BotSideLabel: TLabel
    Left = 152
    Top = 40
    Width = 24
    Height = 13
    Cursor = crHandPoint
    Caption = 'Side:'
    OnClick = BotSideLabelClick
  end
  object Label1: TLabel
    Left = 32
    Top = 72
    Width = 49
    Height = 13
    Caption = 'Handicap:'
  end
  object Button1: TButton
    Left = 24
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Update bot'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object BotTeamComboBox: TComboBox
    Left = 88
    Top = 16
    Width = 41
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
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
    Left = 88
    Top = 40
    Width = 41
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 3
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
    Left = 180
    Top = 40
    Width = 77
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 4
    OnDrawItem = BotSideComboBoxDrawItem
  end
  object Button3: TButton
    Left = 112
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Kick bot'
    TabOrder = 5
    OnClick = Button3Click
  end
  object HandicapTracker: TjanTracker
    Left = 40
    Top = 88
    Width = 233
    Height = 24
    Minimum = 0
    Maximum = 100
    Value = 0
    Orientation = jtbHorizontal
    BackColor = clBtnFace
    BackBorder = False
    TrackColor = clGray
    TrackPositionColor = False
    TrackBorder = True
    BorderColor = clBlack
    ThumbColor = clSilver
    ThumbBorder = False
    ThumbWidth = 40
    ThumbHeight = 16
    TrackHeight = 6
    ShowCaption = True
    CaptionColor = clBlack
    CaptionBold = False
  end
end
