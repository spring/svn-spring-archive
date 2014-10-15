object HostBattleForm: THostBattleForm
  Left = 1150
  Top = 12
  Width = 442
  Height = 421
  Caption = 'Host battle'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
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
    Width = 434
    Height = 394
    Caption = 'Host battle'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object Label1: TSpTBXLabel
      Left = 16
      Top = 40
      Width = 112
      Height = 13
      Caption = 'Max. number of players:'
    end
    object Label2: TSpTBXLabel
      Left = 16
      Top = 248
      Width = 73
      Height = 13
      Caption = 'UDP Host Port:'
    end
    object Label3: TSpTBXLabel
      Left = 272
      Top = 160
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object Label4: TSpTBXLabel
      Left = 16
      Top = 88
      Width = 56
      Height = 13
      Caption = 'Description:'
    end
    object Label5: TSpTBXLabel
      Left = 16
      Top = 160
      Width = 24
      Height = 13
      Caption = 'Mod:'
    end
    object SpeedButton1: TSpTBXSpeedButton
      Left = 206
      Top = 352
      Width = 33
      Height = 25
      Caption = '?'
      OnClick = SpeedButton1Click
    end
    object Label6: TSpTBXLabel
      Left = 280
      Top = 40
      Width = 49
      Height = 13
      Caption = 'Rank limit:'
    end
    object Label7: TSpTBXLabel
      Left = 72
      Top = 266
      Width = 75
      Height = 13
      Caption = '(default is 8452)'
    end
    object Label8: TSpTBXLabel
      Left = 272
      Top = 200
      Width = 94
      Height = 13
      Caption = '(use blank for none)'
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
      Left = 272
      Top = 176
      Width = 145
      Height = 21
      TabOrder = 11
    end
    object TitleEdit: TSpTBXEdit
      Left = 16
      Top = 104
      Width = 401
      Height = 21
      TabOrder = 12
    end
    object ModsComboBox: TSpTBXComboBox
      Left = 16
      Top = 176
      Width = 249
      Height = 21
      Style = csDropDownList
      DropDownCount = 32
      ItemHeight = 13
      TabOrder = 13
    end
    object RankComboBox: TSpTBXComboBox
      Left = 280
      Top = 56
      Width = 137
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 14
      OnDrawItem = RankComboBoxDrawItem
    end
    object NATRadioGroup: TSpTBXRadioGroup
      Left = 208
      Top = 232
      Width = 209
      Height = 65
      Caption = 'NAT traversal'
      TabOrder = 15
      OnClick = NATRadioGroupClick
      ItemIndex = 0
      Items.Strings = (
        'None (default)'
        'Hole punching'
        'Fixed source ports')
    end
    object CancelButton: TSpTBXButton
      Left = 250
      Top = 352
      Width = 103
      Height = 25
      Caption = 'Cancel'
      TabOrder = 16
      OnClick = CancelButtonClick
      Cancel = True
    end
    object AutoSendDescCheckbox: TSpTBXCheckBox
      Left = 16
      Top = 128
      Width = 248
      Height = 15
      Caption = 'Auto send description in battle when a player join'
      TabOrder = 17
    end
    object RefreshModListButton: TSpTBXButton
      Left = 16
      Top = 200
      Width = 121
      Height = 25
      Caption = 'Refresh mod list'
      TabOrder = 18
      OnClick = RefreshModListButtonClick
    end
    object PlayersTracker: TSpTBXSpinEdit
      Left = 16
      Top = 56
      Width = 49
      Height = 21
      TabOrder = 19
      SpinButton.Left = 30
      SpinButton.Top = 0
      SpinButton.Width = 15
      SpinButton.Height = 17
      SpinButton.Align = alRight
      SpinOptions.Value = 4.000000000000000000
    end
    object HostButton: TSpTBXButton
      Left = 72
      Top = 352
      Width = 105
      Height = 25
      Caption = 'Host battle'
      TabOrder = 20
      OnClick = HostButtonClick
    end
    object HostTypeButton: TSpTBXButton
      Left = 176
      Top = 352
      Width = 18
      Height = 25
      TabOrder = 21
      DropDownMenu = HostPopupMenu
    end
    object RelayChatCheckBox: TSpTBXCheckBox
      Left = 16
      Top = 328
      Width = 358
      Height = 15
      Caption = 
        'Relay the chat between the lobby and spring / Enable mid game (r' +
        'e) join'
      TabOrder = 22
    end
    object pnlRelayHosting: TSpTBXPanel
      Left = 16
      Top = 304
      Width = 401
      Height = 21
      Caption = 'pnlRelayHosting'
      TabOrder = 23
      Borders = False
      object RelayHostCheckBox: TSpTBXCheckBox
        Left = 0
        Top = 0
        Width = 68
        Height = 21
        Caption = 'Relay host'
        Align = alLeft
        TabOrder = 0
        OnClick = RelayHostCheckBoxClick
      end
      object cmbRelayList: TSpTBXComboBox
        Left = 81
        Top = 0
        Width = 231
        Height = 19
        Align = alClient
        Style = csOwnerDrawFixed
        ItemHeight = 13
        TabOrder = 1
        OnDrawItem = cmbRelayListDrawItem
      end
      object btRefreshRelayManagersList: TSpTBXButton
        Left = 312
        Top = 0
        Width = 89
        Height = 21
        Caption = 'Refresh'
        Align = alRight
        TabOrder = 2
        OnClick = btRefreshRelayManagersListClick
      end
      object SpTBXPanel2: TSpTBXPanel
        Left = 68
        Top = 0
        Width = 13
        Height = 21
        Caption = 'SpTBXPanel2'
        Align = alLeft
        TabOrder = 3
        Borders = False
      end
    end
    object DownloadModButton: TSpTBXButton
      Left = 144
      Top = 200
      Width = 121
      Height = 25
      Caption = 'Download mod ...'
      TabOrder = 24
      OnClick = DownloadModButtonClick
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
    ServerAuth = httpAuthNone
    ProxyAuth = httpAuthNone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Options = []
    SocksAuthentication = socksNoAuthentication
    Left = 652
    Top = 467
  end
  object HostPopupMenu: TSpTBXPopupMenu
    AutoHotkeys = maManual
    Left = 120
    Top = 376
    object mnuHost: TSpTBXItem
      Caption = 'Host a game'
      GroupIndex = 1
      RadioItem = True
      OnClick = Host1Click
    end
    object mnuHostReplay: TSpTBXItem
      Caption = 'Host a replay'
      GroupIndex = 1
      RadioItem = True
      OnClick = HostReplay1Click
    end
  end
end
