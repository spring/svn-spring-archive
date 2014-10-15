object HostBattleForm: THostBattleForm
  Left = 386
  Top = 194
  BorderStyle = bsDialog
  Caption = 'Host battle'
  ClientHeight = 355
  ClientWidth = 331
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
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 331
    Height = 355
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
      Top = 248
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
      Top = 160
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
      Top = 160
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
      Top = 312
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
      Top = 266
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
      Top = 200
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
      Top = 264
      Width = 49
      Height = 21
      TabOrder = 10
      Text = '8452'
    end
    object PasswordEdit: TSpTBXEdit
      Left = 224
      Top = 176
      Width = 89
      Height = 21
      TabOrder = 11
    end
    object PlayersTracker: TSpTBXjanTracker
      Left = 16
      Top = 56
      Width = 145
      Height = 24
      ThemeType = thtWindows
      Minimum = 2
      Maximum = 16
      Value = 4
      Orientation = jtbHorizontal
      BackColor = clBtnFace
      BackBorder = False
      TrackColor = clGray
      TrackPositionColor = False
      TrackBorder = True
      BorderColor = clGray
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
      Top = 176
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
    object NATRadioGroup: TSpTBXRadioGroup
      Left = 160
      Top = 224
      Width = 153
      Height = 65
      Caption = 'NAT traversal'
      Color = clNone
      ParentColor = False
      TabOrder = 16
      OnClick = NATRadioGroupClick
      ItemIndex = 0
      Items.Strings = (
        'None (default)'
        'Hole punching'
        'Fixed source ports')
    end
    object HostButton: TTBXButton
      Left = 56
      Top = 312
      Width = 89
      Height = 25
      AutoSize = False
      Caption = 'Host'
      DropDownCombo = True
      DropDownMenu = HostPopupMenu
      SmartFocus = False
      TabOrder = 17
      OnClick = HostButtonClick
    end
    object CancelButton: TSpTBXButton
      Left = 192
      Top = 312
      Width = 73
      Height = 25
      Caption = 'Cancel'
      TabOrder = 18
      OnClick = CancelButtonClick
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object AutoSendDescCheckbox: TSpTBXCheckBox
      Left = 16
      Top = 128
      Width = 248
      Height = 15
      Caption = 'Auto send description in battle when a player join'
      TabOrder = 19
    end
    object LadderComboBox: TSpTBXComboBox
      Left = 16
      Top = 104
      Width = 297
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 20
      Visible = False
      OnChange = LadderComboBoxChange
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 16
      Top = 88
      Width = 39
      Height = 13
      Caption = 'Ladder :'
      Visible = False
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object RefreshButton: TSpTBXButton
      Left = 224
      Top = 128
      Width = 89
      Height = 25
      Caption = 'Refresh'
      TabOrder = 22
      Visible = False
      OnClick = RefreshButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object RefreshModListButton: TSpTBXButton
      Left = 16
      Top = 200
      Width = 113
      Height = 21
      Caption = 'Refresh mod list'
      TabOrder = 23
      OnClick = RefreshModListButtonClick
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
    object HostLadder1: TMenuItem
      Caption = 'Host a ladder game'
      RadioItem = True
      OnClick = HostLadder1Click
    end
    object HostReplay1: TMenuItem
      AutoHotkeys = maAutomatic
      Caption = 'Host Replay'
      RadioItem = True
      OnClick = HostReplay1Click
    end
  end
  object HttpCli1: THttpCli
    LocalAddr = '0.0.0.0'
    ProxyPort = '80'
    Agent = 'Mozilla/4.0 (compatible; ICS)'
    Accept = 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*'
    NoCache = False
    ContentTypePost = 'application/x-www-form-urlencoded'
    MultiThreaded = False
    RequestVer = '1.0'
    FollowRelocation = True
    LocationChangeMaxCount = 5
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Options = []
    SocksAuthentication = socksNoAuthentication
    Left = 652
    Top = 467
  end
end
