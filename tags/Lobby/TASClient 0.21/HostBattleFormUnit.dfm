object HostBattleForm: THostBattleForm
  Left = 461
  Top = 317
  BorderStyle = bsDialog
  Caption = 'Host battle'
  ClientHeight = 309
  ClientWidth = 331
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 112
    Height = 13
    Caption = 'Max. number of players:'
  end
  object Label2: TLabel
    Left = 16
    Top = 200
    Width = 73
    Height = 13
    Caption = 'UDP Host Port:'
  end
  object Label3: TLabel
    Left = 224
    Top = 120
    Width = 49
    Height = 13
    Caption = 'Password:'
  end
  object Label4: TLabel
    Left = 16
    Top = 64
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object Label5: TLabel
    Left = 16
    Top = 120
    Width = 24
    Height = 13
    Caption = 'Mod:'
  end
  object SpeedButton1: TSpeedButton
    Left = 152
    Top = 272
    Width = 33
    Height = 25
    Caption = '?'
    OnClick = SpeedButton1Click
  end
  object Label6: TLabel
    Left = 176
    Top = 16
    Width = 49
    Height = 13
    Caption = 'Rank limit:'
  end
  object JvHostArrowButton: TJvArrowButton
    Left = 64
    Top = 272
    Width = 81
    Height = 25
    DropDown = HostPopupMenu
    Caption = 'Host'
    FillFont.Charset = DEFAULT_CHARSET
    FillFont.Color = clWindowText
    FillFont.Height = -11
    FillFont.Name = 'MS Sans Serif'
    FillFont.Style = []
    OnClick = JvHostArrowButtonClick
  end
  object Label7: TLabel
    Left = 72
    Top = 218
    Width = 75
    Height = 13
    Caption = '(default is 8452)'
  end
  object Label8: TLabel
    Left = 224
    Top = 160
    Width = 94
    Height = 13
    Caption = '(use blank for none)'
  end
  object CancelButton: TButton
    Left = 192
    Top = 272
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = CancelButtonClick
  end
  object PortEdit: TEdit
    Left = 16
    Top = 216
    Width = 49
    Height = 21
    TabOrder = 1
    Text = '8452'
  end
  object PasswordEdit: TEdit
    Left = 224
    Top = 136
    Width = 89
    Height = 21
    TabOrder = 2
  end
  object PlayersTracker: TjanTracker
    Left = 16
    Top = 32
    Width = 145
    Height = 24
    Minimum = 2
    Maximum = 16
    Value = 4
    Orientation = jtbHorizontal
    BackColor = clBtnFace
    BackBorder = False
    TrackColor = clGray
    TrackPositionColor = False
    TrackBorder = True
    BorderColor = clBlack
    ThumbColor = clSilver
    ThumbBorder = False
    ThumbWidth = 20
    ThumbHeight = 16
    TrackHeight = 6
    ShowCaption = True
    CaptionColor = clBlack
    CaptionBold = False
  end
  object TitleEdit: TEdit
    Left = 16
    Top = 80
    Width = 297
    Height = 21
    TabOrder = 4
  end
  object ModsComboBox: TComboBox
    Left = 16
    Top = 136
    Width = 201
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
  object RankComboBox: TComboBox
    Left = 176
    Top = 32
    Width = 137
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 6
    OnDrawItem = RankComboBoxDrawItem
  end
  object NATRadioGroup: TRadioGroup
    Left = 160
    Top = 184
    Width = 153
    Height = 57
    Caption = 'NAT traversal'
    ItemIndex = 0
    Items.Strings = (
      'None (default)'
      'Hole punching'
      'Fixed source ports')
    TabOrder = 7
    OnClick = NATRadioGroupClick
  end
  object JvXPButton1: TJvXPButton
    Left = 16
    Top = 160
    Width = 113
    Caption = 'Refresh mod list'
    TabOrder = 8
    OnClick = JvXPButton1Click
  end
  object HostPopupMenu: TPopupMenu
    Left = 272
    Top = 272
    object Host1: TMenuItem
      AutoHotkeys = maAutomatic
      Caption = 'Host'
      Checked = True
      RadioItem = True
      OnClick = Host1Click
    end
    object HostReplay1: TMenuItem
      AutoHotkeys = maAutomatic
      Caption = 'Host Replay'
      RadioItem = True
      OnClick = HostReplay1Click
    end
  end
end
