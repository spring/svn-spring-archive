object AddNotificationForm: TAddNotificationForm
  Left = 459
  Top = 374
  BorderStyle = bsDialog
  Caption = 'Add notification'
  ClientHeight = 213
  ClientWidth = 305
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
  object Label3: TLabel
    Left = 16
    Top = 16
    Width = 79
    Height = 13
    Caption = 'Notification type:'
  end
  object Label1: TLabel
    Left = 24
    Top = 88
    Width = 32
    Height = 13
    Caption = 'Player:'
  end
  object Label2: TLabel
    Left = 24
    Top = 112
    Width = 42
    Height = 13
    Caption = 'Channel:'
  end
  object ComboBox1: TComboBox
    Left = 24
    Top = 40
    Width = 257
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBox1Change
    Items.Strings = (
      '<player> joins <channel>'
      'Player joins battle user is participating in'
      '<player> changes his status to in-battle')
  end
  object Edit1: TEdit
    Left = 88
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Player'
  end
  object Edit2: TEdit
    Left = 88
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '#main'
  end
  object Button1: TButton
    Left = 64
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Button2Click
  end
end
