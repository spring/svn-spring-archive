object HostBattleForm: THostBattleForm
  Left = 461
  Top = 317
  BorderStyle = bsDialog
  Caption = 'Host battle'
  ClientHeight = 336
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
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 331
    Height = 336
    Caption = 'Host battle'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object Label1: TSpTBXLabel
      Left = 16
      Top = 40
      Width = 112
      Height = 13
      Caption = 'Max. number of players:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label2: TSpTBXLabel
      Left = 16
      Top = 224
      Width = 73
      Height = 13
      Caption = 'UDP Host Port:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label3: TSpTBXLabel
      Left = 224
      Top = 144
      Width = 49
      Height = 13
      Caption = 'Password:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label4: TSpTBXLabel
      Left = 16
      Top = 88
      Width = 56
      Height = 13
      Caption = 'Description:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label5: TSpTBXLabel
      Left = 16
      Top = 144
      Width = 24
      Height = 13
      Caption = 'Mod:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpeedButton1: TSpTBXSpeedButton
      Left = 152
      Top = 296
      Width = 33
      Height = 25
      Caption = '?'
      OnClick = SpeedButton1Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label6: TSpTBXLabel
      Left = 176
      Top = 40
      Width = 49
      Height = 13
      Caption = 'Rank limit:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label7: TSpTBXLabel
      Left = 72
      Top = 242
      Width = 75
      Height = 13
      Caption = '(default is 8452)'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label8: TSpTBXLabel
      Left = 224
      Top = 184
      Width = 94
      Height = 13
      Caption = '(use blank for none)'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object PortEdit: TSpTBXEdit
      Left = 16
      Top = 240
      Width = 49
      Height = 21
      TabOrder = 10
      Text = '8452'
    end
    object PasswordEdit: TSpTBXEdit
      Left = 224
      Top = 160
      Width = 89
      Height = 21
      TabOrder = 11
    end
    object PlayersTracker: TjanTracker
      Left = 16
      Top = 56
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
    object TitleEdit: TSpTBXEdit
      Left = 16
      Top = 104
      Width = 297
      Height = 21
      TabOrder = 13
    end
    object ModsComboBox: TSpTBXComboBox
      Left = 16
      Top = 160
      Width = 201
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 14
    end
    object RankComboBox: TSpTBXComboBox
      Left = 176
      Top = 56
      Width = 137
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 15
      OnDrawItem = RankComboBoxDrawItem
    end
    object NATRadioGroup: TRadioGroup
      Left = 160
      Top = 208
      Width = 153
      Height = 57
      Caption = 'NAT traversal'
      ItemIndex = 0
      Items.Strings = (
        'None (default)'
        'Hole punching'
        'Fixed source ports')
      TabOrder = 16
      OnClick = NATRadioGroupClick
    end
    object RefreshModListButton: TJvXPButton
      Left = 16
      Top = 184
      Width = 113
      Caption = 'Refresh mod list'
      TabOrder = 17
      OnClick = RefreshModListButtonClick
    end
    object HostButton: TTBXButton
      Left = 56
      Top = 296
      Width = 89
      Height = 25
      AutoSize = False
      Caption = 'Host'
      DropDownCombo = True
      DropDownMenu = HostPopupMenu
      SmartFocus = False
      TabOrder = 18
      OnClick = HostButtonClick
    end
    object CancelButton: TSpTBXButton
      Left = 192
      Top = 296
      Width = 73
      Height = 25
      Caption = 'Cancel'
      TabOrder = 19
      OnClick = CancelButtonClick
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
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
