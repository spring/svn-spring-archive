object PreferencesForm: TPreferencesForm
  Left = 954
  Top = 302
  Width = 600
  Height = 552
  Caption = 'Preferences'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 592
    Height = 525
    Caption = 'Preferences'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    DesignSize = (
      592
      525)
    object LayoutDefault: TTntEdit
      Left = 568
      Top = 720
      Width = 97
      Height = 21
      TabOrder = 1
      Text = 
        '"PageControlHosts=""MainForm.MainPCH=""""DockedControls=""""""""' +
        'MainForm.TabSheet_Internal_Local_0=Left=16,Top=140,Width=575,Hei' +
        'ght=153,Visible=TRUE,Floating=FALSE"""""""""""",ActivePage=$Loca' +
        'l,Left=16,Top=140,Width=583,Height=181,TabPos=0,Visible=TRUE,Flo' +
        'ating=FALSE""","DockPanels=""MainForm.MainDockPanel=""""DockClie' +
        'nts=""""""""MainForm.PlayerListPanel=Left=603,Top=140,Width=231,' +
        'Height=382,Visible=TRUE,Floating=FALSE"""""""",""""""""MainForm.' +
        'BattlesPanel=Left=16,Top=337,Width=583,Height=185,Visible=TRUE,F' +
        'loating=FALSE"""""""",""""""""MainForm.MainPCH=Left=16,Top=140,W' +
        'idth=583,Height=181,Visible=TRUE,Floating=FALSE"""""""""""",Widt' +
        'h=818,Height=394,iWidth=404,DockingData=000004000000000032030000' +
        '00000000028A0100000000000001000000014B020000000000000200000000C5' +
        '000000070000004D61696E50434802000000008A0100000C000000426174746C' +
        '657350616E656C0100000000320300000F000000506C617965724C6973745061' +
        '6E656CFFFFFFFF"",""BattleForm.BattleMiddlePanel=""""DockClients=' +
        '""""""""BattleForm.MapPanel=Left=14,Top=47,Width=558,Height=222,' +
        'Visible=TRUE,Floating=FALSE"""""""",""""""""BattleForm.BattleOpt' +
        'ionsPanel=Left=576,Top=47,Width=335,Height=222,Visible=TRUE,Floa' +
        'ting=FALSE"""""""",""""""""BattleForm.MyOptionsPanel=Left=14,Top' +
        '=285,Width=897,Height=54,Visible=TRUE,Floating=FALSE"""""""","""' +
        '"""""BattleForm.BattlePlayerListPanel=Left=504,Top=355,Width=407' +
        ',Height=210,Visible=TRUE,Floating=FALSE"""""""",""""""""BattleFo' +
        'rm.BattleChatPanel=Left=14,Top=355,Width=486,Height=210,Visible=' +
        'TRUE,Floating=FALSE"""""""""""",Width=897,Height=530,iWidth=530,' +
        'DockingData=0000040000000000120200000000000001810300000000000001' +
        '00000002EE00000000000000020000000032020000080000004D617050616E65' +
        '6C02000000008103000012000000426174746C654F7074696F6E7350616E656C' +
        '0100000000340100000E0000004D794F7074696F6E7350616E656C0100000002' +
        '12020000000000000200000000EA0100000F000000426174746C654368617450' +
        '616E656C02000000008103000015000000426174746C65506C617965724C6973' +
        '7450616E656CFFFFFFFF""",Version=1'
    end
    object LanguageCombobox: TSpTBXComboBox
      Left = 447
      Top = 32
      Width = 130
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 2
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 216
      Top = 34
      Width = 221
      Height = 13
      Caption = 'Language :'
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Alignment = taRightJustify
    end
    object SpTBXTabControl1: TSpTBXTabControl
      Left = 8
      Top = 56
      Width = 569
      Height = 421
      Anchors = [akLeft, akTop, akRight, akBottom]
      ActiveTabIndex = 0
      TabAutofit = True
      HiddenItems = <>
      object SpTBXTabItem6: TSpTBXTabItem
        Caption = 'Server'
        Wrapping = twWrap
        Checked = True
        CustomWidth = 80
        CustomHeight = 40
      end
      object SpTBXTabItem5: TSpTBXTabItem
        Caption = 'Account'
        Wrapping = twWrap
        CustomWidth = 80
      end
      object SpTBXTabItem4: TSpTBXTabItem
        Caption = 'Program'
        Wrapping = twWrap
        CustomWidth = 80
      end
      object SpTBXTabItem3: TSpTBXTabItem
        Caption = 'Interface'
        Wrapping = twWrap
        CustomWidth = 80
      end
      object SpTBXTabItem2: TSpTBXTabItem
        Caption = 'Proxy'
        Wrapping = twWrap
        CustomWidth = 80
      end
      object SpTBXTabItem1: TSpTBXTabItem
        Caption = 'Skins'
        Wrapping = twWrap
        CustomWidth = 80
      end
      object SpTBXTabItem7: TSpTBXTabItem
        Caption = 'Scripts'
        Wrapping = twWrap
        CustomWidth = 80
      end
      object SpTBXTabSheet7: TSpTBXTabSheet
        Left = 0
        Top = 44
        Width = 569
        Height = 377
        Caption = 'Scripts'
        ImageIndex = -1
        DesignSize = (
          569
          377)
        TabItem = 'SpTBXTabItem7'
        object ScriptsDebugWindowBt: TSpTBXButton
          Left = 160
          Top = 56
          Width = 246
          Height = 25
          Caption = 'Debug Window'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnClick = ScriptsDebugWindowBtClick
        end
        object ScriptsReloadBt: TSpTBXButton
          Left = 160
          Top = 88
          Width = 246
          Height = 25
          Caption = 'Reload scripts'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnClick = ScriptsReloadBtClick
        end
        object ScriptsLoadNewBt: TSpTBXButton
          Left = 160
          Top = 120
          Width = 246
          Height = 25
          Caption = 'Load new scripts'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          OnClick = ScriptsLoadNewBtClick
        end
        object ScriptsAdvancedOptionsBt: TSpTBXButton
          Left = 160
          Top = 152
          Width = 246
          Height = 25
          Caption = 'Advanced options'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
          Visible = False
          OnClick = ScriptsAdvancedOptionsBtClick
        end
        object EnableScriptsCheckBox: TSpTBXCheckBox
          Left = 180
          Top = 24
          Width = 193
          Height = 15
          Caption = 'Enable scripts BETA (requires restart)'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 4
        end
      end
      object SpTBXTabSheet2: TSpTBXTabSheet
        Left = 0
        Top = 44
        Width = 569
        Height = 377
        Caption = 'Proxy'
        ImageIndex = -1
        DesignSize = (
          569
          377)
        TabItem = 'SpTBXTabItem2'
        object GroupBox6: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 545
          Height = 349
          Caption = 'Proxy settings'
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          object UseProxyCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 32
            Width = 65
            Height = 15
            Caption = 'Use proxy'
            TabOrder = 0
            OnClick = UseProxyCheckBoxClick
            Checked = True
            State = cbChecked
          end
          object ProxyPanel: TSpTBXPanel
            Left = 24
            Top = 56
            Width = 321
            Height = 113
            Caption = 'ProxyPanel'
            TabOrder = 1
            object ProxyEdit: TSpTBXEdit
              Left = 96
              Top = 8
              Width = 209
              Height = 21
              TabOrder = 0
            end
            object Label7: TSpTBXLabel
              Left = 8
              Top = 8
              Width = 41
              Height = 13
              Caption = 'Address:'
            end
            object Label8: TSpTBXLabel
              Left = 8
              Top = 32
              Width = 22
              Height = 13
              Caption = 'Port:'
            end
            object ProxyUserEdit: TSpTBXEdit
              Left = 96
              Top = 56
              Width = 121
              Height = 21
              TabOrder = 3
            end
            object Label9: TSpTBXLabel
              Left = 8
              Top = 56
              Width = 51
              Height = 13
              Caption = 'Username:'
            end
            object Label10: TSpTBXLabel
              Left = 8
              Top = 80
              Width = 49
              Height = 13
              Caption = 'Password:'
            end
            object ProxyPassEdit: TSpTBXEdit
              Left = 96
              Top = 80
              Width = 121
              Height = 21
              TabOrder = 6
            end
            object JvProxyPortEdit: TSpTBXSpinEdit
              Left = 96
              Top = 32
              Width = 57
              Height = 21
              TabOrder = 7
              SpinButton.Left = 39
              SpinButton.Top = 0
              SpinButton.Width = 14
              SpinButton.Height = 17
              SpinButton.Align = alRight
            end
          end
        end
      end
      object SpTBXTabSheet5: TSpTBXTabSheet
        Left = 0
        Top = 44
        Width = 569
        Height = 377
        Caption = 'Account'
        ImageIndex = -1
        DesignSize = (
          569
          377)
        TabItem = 'SpTBXTabItem5'
        object GroupBox2: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 545
          Height = 349
          Caption = 'Account details'
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          object RegisterAccountButton: TSpTBXSpeedButton
            Left = 156
            Top = 136
            Width = 217
            Height = 25
            Caption = 'Create new account'
            OnClick = RegisterAccountButtonClick
          end
          object Label4: TSpTBXLabel
            Left = 24
            Top = 40
            Width = 51
            Height = 13
            Caption = 'Username:'
          end
          object Label5: TSpTBXLabel
            Left = 24
            Top = 72
            Width = 49
            Height = 13
            Caption = 'Password:'
          end
          object UsernameEdit: TSpTBXEdit
            Left = 160
            Top = 40
            Width = 185
            Height = 21
            TabOrder = 0
          end
          object PasswordEdit: TSpTBXEdit
            Left = 160
            Top = 72
            Width = 185
            Height = 21
            TabOrder = 1
            OnChange = PasswordEditChange
            PasswordCharW = '*'
          end
          object RememberPasswordsCheckBox: TSpTBXCheckBox
            Left = 160
            Top = 104
            Width = 117
            Height = 15
            Caption = 'remember passwords'
            TabOrder = 5
          end
        end
      end
      object SpTBXTabSheet4: TSpTBXTabSheet
        Left = 0
        Top = 44
        Width = 569
        Height = 377
        Caption = 'Program'
        ImageIndex = -1
        DesignSize = (
          569
          377)
        TabItem = 'SpTBXTabItem4'
        object GroupBox3: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 545
          Height = 349
          Caption = 'Program settings'
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          DesignSize = (
            545
            349)
          object ResetRegistryButton: TSpTBXSpeedButton
            Left = 296
            Top = 313
            Width = 238
            Height = 22
            Caption = 'Reset registry data'
            Anchors = [akLeft, akRight, akBottom]
            OnClick = ResetRegistryButtonClick
          end
          object NotificationsButton: TSpTBXSpeedButton
            Left = 296
            Top = 40
            Width = 238
            Height = 22
            Caption = 'Notifications ...'
            Anchors = [akLeft, akTop, akRight]
            OnClick = NotificationsButtonClick
          end
          object HighlightingButton: TSpTBXSpeedButton
            Left = 296
            Top = 16
            Width = 238
            Height = 22
            Caption = 'Highlighting ...'
            Anchors = [akLeft, akTop, akRight]
            OnClick = HighlightingButtonClick
          end
          object IgnoreListButton: TSpTBXSpeedButton
            Left = 296
            Top = 64
            Width = 238
            Height = 22
            Caption = 'Ignore list ...'
            Anchors = [akLeft, akTop, akRight]
            OnClick = IgnoreListButtonClick
          end
          object Label6: TSpTBXLabel
            Left = 16
            Top = 32
            Width = 46
            Height = 13
            Caption = 'Tab style:'
          end
          object RadioButton4: TSpTBXRadioButton
            Left = 16
            Top = 56
            Width = 38
            Height = 15
            Caption = 'tabs'
            TabOrder = 0
            TabStop = True
            Checked = True
          end
          object RadioButton5: TSpTBXRadioButton
            Left = 16
            Top = 72
            Width = 53
            Height = 15
            Caption = 'buttons'
            TabOrder = 1
          end
          object RadioButton6: TSpTBXRadioButton
            Left = 16
            Top = 88
            Width = 70
            Height = 15
            Caption = 'flat buttons'
            TabOrder = 2
          end
          object CheckBox8: TSpTBXCheckBox
            Left = 16
            Top = 319
            Width = 88
            Height = 15
            Caption = 'Enable logging'
            Anchors = [akLeft, akBottom]
            TabOrder = 3
            Checked = True
            State = cbChecked
          end
          object CheckBox9: TSpTBXCheckBox
            Left = 16
            Top = 303
            Width = 128
            Height = 15
            Caption = 'Use sound notifications'
            Anchors = [akLeft, akBottom]
            TabOrder = 4
            Checked = True
            State = cbChecked
          end
          object CheckForNewVersionCheckBox: TSpTBXCheckBox
            Left = 16
            Top = 287
            Width = 168
            Height = 15
            Caption = 'Auto update lobby to latest beta'
            Anchors = [akLeft, akBottom]
            TabOrder = 10
          end
          object ColorsButton: TSpTBXButton
            Left = 296
            Top = 88
            Width = 238
            Height = 22
            Caption = 'Colors and font ...'
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 11
            OnClick = ColorsButtonClick
          end
          object ManageGroupsButton: TSpTBXButton
            Left = 296
            Top = 112
            Width = 238
            Height = 22
            Caption = 'Manage groups ...'
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 12
            OnClick = ManageGroupsButtonClick
          end
          object EnableSpringDownloaderCheckBox: TSpTBXCheckBox
            Left = 16
            Top = 271
            Width = 162
            Height = 15
            Caption = 'Enable Integrated Downloader'
            Anchors = [akLeft, akBottom]
            TabOrder = 13
            Checked = True
            State = cbChecked
          end
          object UseLogonFormCheckBox: TSpTBXCheckBox
            Left = 16
            Top = 255
            Width = 89
            Height = 15
            Caption = 'Use logon form'
            Anchors = [akLeft, akBottom]
            TabOrder = 14
            Checked = True
            State = cbChecked
          end
          object TipsButton: TSpTBXButton
            Left = 296
            Top = 136
            Width = 238
            Height = 22
            Caption = 'Tips ...'
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 15
            OnClick = TipsButtonClick
          end
          object SpringSettingsProfilesButton: TSpTBXButton
            Left = 296
            Top = 160
            Width = 238
            Height = 22
            Caption = 'Spring Settings profiles'
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 16
            OnClick = SpringSettingsProfilesButtonClick
          end
        end
      end
      object SpTBXTabSheet3: TSpTBXTabSheet
        Left = 0
        Top = 44
        Width = 569
        Height = 377
        Caption = 'Interface'
        ImageIndex = -1
        DesignSize = (
          569
          377)
        TabItem = 'SpTBXTabItem3'
        object GroupBox4: TSpTBXGroupBox
          Left = 8
          Top = 8
          Width = 545
          Height = 349
          Caption = 'Interface preferences'
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          DesignSize = (
            545
            349)
          object CheckBox1: TSpTBXCheckBox
            Left = 24
            Top = 16
            Width = 104
            Height = 15
            Caption = 'Timestamp events'
            TabOrder = 0
            Checked = True
            State = cbChecked
          end
          object CheckBox3: TSpTBXCheckBox
            Left = 24
            Top = 32
            Width = 128
            Height = 15
            Caption = 'Filter join/left messages'
            TabOrder = 1
          end
          object CheckBox4: TSpTBXCheckBox
            Left = 24
            Top = 64
            Width = 108
            Height = 15
            Caption = 'Show country flags'
            TabOrder = 2
            Checked = True
            State = cbChecked
          end
          object CheckBox5: TSpTBXCheckBox
            Left = 24
            Top = 80
            Width = 147
            Height = 15
            Caption = 'Mark unknown maps/mods'
            TabOrder = 3
            Checked = True
            State = cbChecked
          end
          object CheckBox6: TSpTBXCheckBox
            Left = 24
            Top = 96
            Width = 251
            Height = 15
            Caption = 'Use taskbar button for each form (requires restart)'
            TabOrder = 4
          end
          object WarnNATCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 112
            Width = 271
            Height = 15
            Caption = 'Display warning icons on battles using NAT traversing'
            TabOrder = 5
            Checked = True
            State = cbChecked
          end
          object AutoFocusOnPMCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 128
            Width = 262
            Height = 15
            Caption = 'Automatically switch focus to new private messages'
            TabOrder = 6
            Checked = True
            State = cbChecked
          end
          object DisableAllSoundsCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 144
            Width = 103
            Height = 15
            Caption = 'Disable all sounds'
            TabOrder = 7
          end
          object UploadReplayCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 240
            Width = 227
            Height = 15
            Caption = 'Ask what to do with replays after each battle'
            TabOrder = 8
          end
          object SortLocalCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 160
            Width = 132
            Height = 15
            Caption = 'Sort the $local player list'
            TabOrder = 9
          end
          object DisplayQuickJoinPanelCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 176
            Width = 131
            Height = 15
            Caption = 'Display Quick join panel'
            TabOrder = 10
          end
          object FilterBattleJoinLeftCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 48
            Width = 157
            Height = 15
            Caption = 'Filter battle join/left messages'
            TabOrder = 11
          end
          object AutoCompletionCurrentChannelCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 192
            Width = 252
            Height = 15
            Caption = 'Auto-completion from current channel'#39's players list'
            TabOrder = 12
          end
          object ChatLogsLimitCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 208
            Width = 145
            Height = 15
            Caption = 'Limit chat logs to 800 lines '
            TabOrder = 13
          end
          object ChatLogsLimitTracker: TSpTBXTrackBar
            Left = 400
            Top = 208
            Width = 134
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Max = 3000
            Min = 50
            Frequency = 100
            Position = 800
            TabOrder = 14
            ThumbLength = 10
            OnChange = ChatLogsLimitTrackerChange
          end
          object DisplayUnitsIconsAndNamesCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 224
            Width = 251
            Height = 15
            Caption = 'Load units icons and names when joining (slower)'
            TabOrder = 15
          end
          object DisableNewsCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 256
            Width = 159
            Height = 15
            Caption = 'Disable news (requires restart)'
            TabOrder = 16
          end
          object DoNotLoadMapInfos: TSpTBXCheckBox
            Left = 24
            Top = 272
            Width = 240
            Height = 15
            Caption = 'Disable minimaps and maps info loading at start'
            TabOrder = 17
          end
          object LoadMetalHeightMaps: TSpTBXCheckBox
            Left = 24
            Top = 288
            Width = 295
            Height = 15
            Caption = 'Load metal and height minimaps (enables 3D map preview)'
            TabOrder = 18
          end
          object DisplayAutoHostInterfaceCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 304
            Width = 158
            Height = 15
            Caption = 'Display the autohost interface'
            TabOrder = 19
          end
          object ChatLogLoadingTracker: TSpTBXTrackBar
            Left = 400
            Top = 320
            Width = 134
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Max = 1000
            Min = 2
            Frequency = 50
            Position = 30
            TabOrder = 20
            ThumbLength = 10
            OnChange = ChatLogLoadingTrackerChange
          end
          object ChatLogLoadingCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 320
            Width = 162
            Height = 15
            Caption = 'Load the last 30 chat log lines '
            TabOrder = 21
          end
        end
      end
      object SpTBXTabSheet1: TSpTBXTabSheet
        Left = 0
        Top = 44
        Width = 569
        Height = 377
        Caption = 'Skins'
        ImageIndex = -1
        DesignSize = (
          569
          377)
        TabItem = 'SpTBXTabItem1'
        object GroupBox5: TSpTBXGroupBox
          Left = 8
          Top = 16
          Width = 545
          Height = 349
          Caption = 'Skin manager'
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          DesignSize = (
            545
            349)
          object ThemesComboBox: TSpTBXComboBox
            Left = 48
            Top = 144
            Width = 177
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = ThemesComboBoxChange
          end
          object SpTBXRadioButton1: TSpTBXRadioButton
            Left = 48
            Top = 56
            Width = 44
            Height = 15
            Caption = 'None'
            TabOrder = 1
            TabStop = True
            OnClick = SpTBXRadioButton1Click
            Checked = True
          end
          object SpTBXRadioButton2: TSpTBXRadioButton
            Left = 48
            Top = 72
            Width = 62
            Height = 15
            Caption = 'Windows'
            TabOrder = 2
            OnClick = SpTBXRadioButton2Click
          end
          object Label3: TSpTBXLabel
            Left = 32
            Top = 120
            Width = 85
            Height = 13
            Caption = 'Choose TBX skin:'
          end
          object SpTBXRadioButton3: TSpTBXRadioButton
            Left = 48
            Top = 88
            Width = 76
            Height = 15
            Caption = 'TBX themes'
            TabOrder = 4
            OnClick = SpTBXRadioButton3Click
          end
          object Label11: TSpTBXLabel
            Left = 32
            Top = 32
            Width = 60
            Height = 13
            Caption = 'Theme style:'
          end
          object LoadSkinButton: TSpTBXButton
            Left = 32
            Top = 176
            Width = 193
            Height = 25
            Caption = 'Load skin'
            TabOrder = 6
            OnClick = LoadSkinButtonClick
          end
          object AdvancedSkinningCheckBox: TSpTBXCheckBox
            Left = 32
            Top = 208
            Width = 187
            Height = 15
            Caption = 'Advanced skinning (requires restart)'
            TabOrder = 7
          end
          object SkinEditorButton: TSpTBXButton
            Left = 192
            Top = 316
            Width = 345
            Height = 25
            Caption = 'SkinEditor'
            Anchors = [akRight, akBottom]
            TabOrder = 8
            OnClick = SkinEditorButtonClick
          end
          object SpTBXWebsiteButton: TSpTBXButton
            Left = 192
            Top = 284
            Width = 345
            Height = 25
            Caption = 'SpTBX website : http://www.silverpointdevelopment.com/'
            Anchors = [akRight, akBottom]
            TabOrder = 9
            OnClick = SpTBXWebsiteButtonClick
          end
          object SkinnedTitlebarsCheckBox: TSpTBXCheckBox
            Left = 32
            Top = 224
            Width = 174
            Height = 15
            Caption = 'Skinned titlebars (requires restart)'
            TabOrder = 10
          end
        end
      end
      object SpTBXTabSheet6: TSpTBXTabSheet
        Left = 0
        Top = 44
        Width = 569
        Height = 377
        Caption = 'Server'
        ImageIndex = -1
        DesignSize = (
          569
          377)
        TabItem = 'SpTBXTabItem6'
        object GroupBox1: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 545
          Height = 349
          Caption = 'Server settings'
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          DesignSize = (
            545
            349)
          object Label1: TSpTBXLabel
            Left = 16
            Top = 32
            Width = 74
            Height = 13
            Caption = 'Server address:'
          end
          object Label2: TSpTBXLabel
            Left = 16
            Top = 56
            Width = 55
            Height = 13
            Caption = 'Server port:'
          end
          object ServerPortEdit: TSpTBXEdit
            Left = 128
            Top = 56
            Width = 41
            Height = 21
            TabOrder = 1
            Text = '8200'
          end
          object CheckBox10: TSpTBXCheckBox
            Left = 16
            Top = 128
            Width = 197
            Height = 15
            Caption = 'Connect to backup host if primary fails'
            TabOrder = 2
            Checked = True
            State = cbChecked
          end
          object CheckBox2: TSpTBXCheckBox
            Left = 16
            Top = 144
            Width = 108
            Height = 15
            Caption = 'Connect on startup'
            TabOrder = 3
          end
          object CheckBox7: TSpTBXCheckBox
            Left = 16
            Top = 160
            Width = 226
            Height = 15
            Caption = 'Join #main once connected (recommended)'
            TabOrder = 4
          end
          object ServerAddressEdit: TSpTBXButtonEdit
            Left = 128
            Top = 32
            Width = 398
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            EditButton.Left = 374
            EditButton.Top = 0
            EditButton.Width = 20
            EditButton.Height = 17
            EditButton.Caption = '...'
            EditButton.Align = alRight
            EditButton.DropDownArrow = False
            EditButton.DropDownMenu = AddressPopupMenu
          end
          object PerformButton: TSpTBXSpeedButton
            Left = 413
            Top = 56
            Width = 113
            Height = 21
            Caption = 'Perform ...'
            Anchors = [akTop, akRight]
            OnClick = PerformButtonClick
          end
          object AutoSaveChansSessionCheckbox: TSpTBXCheckBox
            Left = 16
            Top = 176
            Width = 285
            Height = 15
            Caption = 'Automatically join the channels from the previous session'
            TabOrder = 8
          end
        end
      end
    end
    object ApplyAndCloseButton: TSpTBXButton
      Left = 7
      Top = 484
      Width = 275
      Height = 25
      Caption = 'Apply and close'
      Anchors = [akLeft, akBottom]
      TabOrder = 5
      OnClick = ApplyAndCloseButtonClick
    end
    object CancelAndCloseButton: TSpTBXButton
      Left = 307
      Top = 484
      Width = 270
      Height = 25
      Caption = 'Cancel and close'
      Anchors = [akRight, akBottom]
      TabOrder = 6
      OnClick = CancelAndCloseButtonClick
      Cancel = True
    end
    object memoTASClientSkin: TTntMemo
      Left = 687
      Top = 32
      Width = 401
      Height = 153
      Anchors = [akTop, akRight]
      Lines.Strings = (
        '[Skin]'
        'Name=TASClient Skin'
        'Author=Satirik'
        'ColorBtnFace=clBtnFace'
        'FloatingWindowBorderSize=4'
        'OfficeIcons=0'
        'OfficeMenu=0'
        'OfficeStatusBar=0'
        ''
        '[Dock]'
        'Normal.Body=3, $00524743, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[DockablePanel]'
        'Normal.Body=3, $00524743, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=0, $00333333, clBlack, $0030302F, $0030302F'
        'Normal.TextColor=$007B919F'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[DockablePanelTitleBar]'
        'Normal.Body=3, $00524743, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=0, $00333333, clBlack, $0030302F, $0030302F'
        'Normal.TextColor=$007B919F'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[MenuBar]'
        'Normal.Body=1, $00404040, $00292929, clNone, clNone'
        'Normal.Borders=0, clBlack, clBlack, $00666666, $00333333'
        'Normal.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Panel]'
        'Normal.Body=1, $00404040, $00292929, clNone, clNone'
        'Normal.Borders=0, $00404040, $00404040, clNone, clNone'
        'Normal.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Popup]'
        'Normal.Body=10, $0043646B, $007EA7AF, $00729DA7, $0043646B'
        'Normal.Borders=0, $0031474D, $0031474D, clNone, clNone'
        'Normal.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Separator]'
        'Normal.Body=0, $002C4245, $003E5B62, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Splitter]'
        'Normal.Body=1, $00404040, $00292929, clNone, clNone'
        'Normal.Borders=2, $00404040, $00404040, clNone, clNone'
        'Normal.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[StatusBarGrip]'
        'Normal.Body=0, $004F767D, $00729EA6, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[TabBackground]'
        'Normal.Body=1, $001A1A1A, $00404040, $0030302F, $00454545'
        'Normal.Borders=0, $001A1A1A, $001A1A1A, clNone, clNone'
        'Normal.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[TabToolbar]'
        'Normal.Body=0, $00333333, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Toolbar]'
        'Normal.Body=1, $00404040, $00292929, clNone, clNone'
        'Normal.Borders=0, clBlack, clBlack, $00666666, $00333333'
        'Normal.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[ToolbarGrip]'
        'Normal.Body=0, $004F767D, $00729EA6, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Window]'
        'Normal.Body=1, $00404040, $00292929, clNone, clNone'
        'Normal.Borders=0, $002F2F2F, $004D4D4D, $00666666, $004D4D4D'
        'Normal.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[WindowTitleBar]'
        'Normal.Body=7, $00524743, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[MenuBarItem]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=$00729EA6'
        'HotTrack.Body=5, $00C1FCFF, $007DE2FF, $002FD0FF, $0079E1FF'
        'HotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'HotTrack.TextColor=clNone'
        'Pushed.Body=5, $00C1FCFF, $007DE2FF, $002FD0FF, $0079E1FF'
        'Pushed.Borders=0, clNone, clNone, clNone, clNone'
        'Pushed.TextColor=clNone'
        'Checked.Body=3, $00CCF4F2, $00729EA6, $00537C84, $004B93A7'
        'Checked.Borders=0, $0059858E, $0031474D, clNone, clNone'
        'Checked.TextColor=clBlack'
        
          'CheckedAndHotTrack.Body=3, $00C1FCFF, $007DE2FF, $002FD0FF, $007' +
          '9E1FF'
        'CheckedAndHotTrack.Borders=1, $00003F51, $00003F51, $002FD0FF, '
        '$002FD0FF'
        'CheckedAndHotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[MenuItem]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clBlack'
        'HotTrack.Body=0, $00729EA6, clNone, clNone, clNone'
        'HotTrack.Borders=0, $00406066, $00537C84, clNone, clNone'
        'HotTrack.TextColor=clBlack'
        'Checked.Body=0, clNone, $00729EA6, $00537C84, $004B93A7'
        'Checked.Borders=0, clNone, clNone, clNone, clNone'
        'Checked.TextColor=clBlack'
        'CheckedAndHotTrack.Body=0, $00729EA6, clNone, clNone, clNone'
        
          'CheckedAndHotTrack.Borders=0, $00406066, $00537C84, clNone, clNo' +
          'ne'
        'CheckedAndHotTrack.TextColor=clBlack'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=$0038545A'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.Body=0, clNone, clNone, clNone, clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.Borders=0, clNone, clNone, clNone, clNone'
        'Pushed.TextColor=clNone'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[ToolbarItem]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=$00CCFFFF'
        'HotTrack.Body=3, $00729EA6, $00568087, $003C5960, $00407C8E'
        'HotTrack.Borders=2, $0036302E, $0036302E, clBlack, clBlack'
        'HotTrack.TextColor=clWhite'
        'Pushed.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Pushed.Borders=2, $000D5A71, $000D5A71, $00729EA6, $00729EA6'
        'Pushed.TextColor=clWhite'
        'Checked.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Checked.Borders=2, $000D5A71, $000D5A71, $00729EA6, $00729EA6'
        'Checked.TextColor=clWhite'
        
          'CheckedAndHotTrack.Body=5, $00524743, $00463E3B, $0030302F, $004' +
          '54545'
        'CheckedAndHotTrack.Borders=2, $000D5A71, $000D5A71, $00729EA6, '
        '$00729EA6'
        'CheckedAndHotTrack.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[Button]'
        'Normal.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=2, $0036302E, $0036302E, clBlack, clBlack'
        'Normal.TextColor=$00A2E0EB'
        'Disabled.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Disabled.Borders=2, $0036302E, $0036302E, clBlack, clBlack'
        'Disabled.TextColor=clNone'
        'HotTrack.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'HotTrack.Borders=2, $000D5A71, $000D5A71, $00729EA6, $00729EA6'
        'HotTrack.TextColor=$00A2E0EB'
        'Pushed.Body=3, $00729EA6, $00568087, $003C5960, $00407C8E'
        'Pushed.Borders=2, $0036302E, $0036302E, clBlack, clBlack'
        'Pushed.TextColor=clWhite'
        'Checked.Body=3, $00729EA6, $00568087, $003C5960, $00407C8E'
        'Checked.Borders=2, $0036302E, $0036302E, clBlack, clBlack'
        'Checked.TextColor=clWhite'
        
          'CheckedAndHotTrack.Body=5, $00524743, $00463E3B, $0030302F, $004' +
          '54545'
        'CheckedAndHotTrack.Borders=2, $000D5A71, $000D5A71, $00729EA6, '
        '$00729EA6'
        'CheckedAndHotTrack.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[CheckBox]'
        'Normal.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=2, clBlack, clBlack, $00729EA6, $00729EA6'
        'Normal.TextColor=$00A2E0EB'
        'Disabled.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Disabled.Borders=2, clBlack, clBlack, $003E6775, $003E6775'
        'Disabled.TextColor=$00515F6A'
        'HotTrack.Body=3, $003C5960, $00407C8E, $00729EA6, $00568087'
        'HotTrack.Borders=2, $00003F51, $00003F51, $00729EA6, $00407C8E'
        'HotTrack.TextColor=clWhite'
        'Pushed.Body=5, $00007EA4, $000D5A71, $000D5A71, $000D5A71'
        'Pushed.Borders=2, clBlack, clBlack, $00729EA6, $00729EA6'
        'Pushed.TextColor=$00A2E0EB'
        'Checked.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Checked.Borders=2, clBlack, clBlack, $00729EA6, $00729EA6'
        'Checked.TextColor=$00A2E0EB'
        
          'CheckedAndHotTrack.Body=3, $002C4045, $00336371, $00365156, $004' +
          '86A71'
        'CheckedAndHotTrack.Borders=2, $0000232D, $0000232D, $0059858C, '
        '$00366978'
        'CheckedAndHotTrack.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[EditButton]'
        'HotTrack.Body=5, $00C1FCFF, $007DE2FF, $002FD0FF, $0079E1FF'
        'HotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'HotTrack.TextColor=clBlack'
        'Pushed.Body=3, $002FD0FF, $0079E1FF, $00C1FCFF, $007DE2FF'
        'Pushed.Borders=1, $00003F51, $00003F51, $002FD0FF, $002FD0FF'
        'Pushed.TextColor=clNone'
        'Normal.Body=3, $00CCF4F2, $00729EA6, $00537C84, $004B93A7'
        'Normal.Borders=0, $0059858E, $0031474D, clNone, clNone'
        'Normal.TextColor=clBlack'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clBlack, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.Body=0, clNone, clNone, clNone, clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.Borders=0, clNone, clNone, clNone, clNone'
        'Checked.TextColor=clNone'
        'Checked.MarkColor=clNone'
        'CheckedAndHotTrack.Body=0, clNone, clNone, clNone, clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'CheckedAndHotTrack.TextColor=clNone'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[EditFrame]'
        'Normal.Body=0, $001A1A1A, clNone, clNone, clNone'
        'Normal.Borders=2, $00313131, $00313131, $00151515, $00151515'
        'Normal.TextColor=$00A2E0EB'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.Borders=2, $00313131, $00313131, $00151515, $00151515'
        'Disabled.TextColor=clNone'
        'HotTrack.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'HotTrack.Borders=2, $000D5A71, $000D5A71, $00729EA6, $00729EA6'
        'HotTrack.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        ''
        '[Header]'
        'Normal.Body=1, $00404040, $00292929, clNone, clNone'
        'Normal.Borders=0, $00292929, $00292929, clNone, clNone'
        'Normal.TextColor=$00A2E0EB'
        'HotTrack.Body=3, $00729EA6, $00568087, $003C5960, $00407C8E'
        'HotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'HotTrack.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.Body=0, clNone, clNone, clNone, clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.Borders=0, clNone, clNone, clNone, clNone'
        'Pushed.TextColor=clNone'
        'Pushed.MarkColor=clNone'
        ''
        '[Label]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        ''
        '[ListItem]'
        'Normal.Body=0, $001A1A1A, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=$00729EA6'
        'HotTrack.Body=3, $00729EA6, $00568087, $003C5960, $00407C8E'
        'HotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'HotTrack.TextColor=clWhite'
        'Checked.Body=0, $00729EA6, clNone, clNone, clNone'
        'Checked.Borders=0, clNone, clNone, clNone, clNone'
        'Checked.TextColor=clBlack'
        'CheckedAndHotTrack.Body=0, $00568087, clNone, clNone, clNone'
        'CheckedAndHotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'CheckedAndHotTrack.TextColor=clWhite'
        'Disabled.Body=3, $00333333, $00333333, $00333333, $00333333'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.Body=0, clNone, clNone, clNone, clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.Borders=0, clNone, clNone, clNone, clNone'
        'Pushed.TextColor=clNone'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[ProgressBar]'
        'Normal.Body=1, $00404040, $00292929, clNone, clNone'
        'Normal.Borders=2, $00404040, $00404040, clNone, clNone'
        'Normal.TextColor=$00A2E0EB'
        'HotTrack.Body=3, $00CCF4F2, $00729EA6, $00537C84, $004B93A7'
        'HotTrack.Borders=0, $0059858E, $0031474D, clNone, clNone'
        'HotTrack.TextColor=clBlack'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        ''
        '[RadioButton]'
        'Normal.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=2, clBlack, clBlack, $00729EA6, $00729EA6'
        'Normal.TextColor=$00A2E0EB'
        'Disabled.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Disabled.Borders=2, clBlack, clBlack, $003E6775, $003E6775'
        'Disabled.TextColor=$00515F6A'
        'HotTrack.Body=3, $003C5960, $00407C8E, $00729EA6, $00568087'
        'HotTrack.Borders=2, $00003F51, $00003F51, $00729EA6, $00407C8E'
        'HotTrack.TextColor=clWhite'
        'Pushed.Body=5, $00007EA4, $000D5A71, $000D5A71, $000D5A71'
        'Pushed.Borders=2, clBlack, clBlack, $00729EA6, $00729EA6'
        'Pushed.TextColor=$00A2E0EB'
        'Checked.Body=5, $00524743, $00463E3B, $0030302F, $00454545'
        'Checked.Borders=2, clBlack, clBlack, $00729EA6, $00729EA6'
        'Checked.TextColor=$00A2E0EB'
        
          'CheckedAndHotTrack.Body=3, $002C4045, $00336371, $00365156, $004' +
          '86A71'
        'CheckedAndHotTrack.Borders=2, $0000232D, $0000232D, $0059858C, '
        '$00366978'
        'CheckedAndHotTrack.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[Tab]'
        'Normal.Body=0, $00404040, $00292929, clNone, clNone'
        'Normal.Borders=2, clBlack, clBlack, $00524743, $0036302E'
        'Normal.TextColor=$00CCCCCC'
        'Disabled.Body=0, $00DBDFE4, clNone, clNone, clNone'
        'Disabled.Borders=2, $00B8C2CA, $00B8C2CA, $00E1E4E8, $00E1E4E8'
        'Disabled.TextColor=clNone'
        'HotTrack.Body=3, $00CCF4F2, $00729EA6, $00537C84, $004B93A7'
        'HotTrack.Borders=2, $001A1A1A, $001A1A1A, clNone, clNone'
        'HotTrack.TextColor=clBlack'
        'Pushed.Body=3, $00CCF4F2, $00729EA6, $00537C84, $004B93A7'
        'Pushed.Borders=2, $001A1A1A, $001A1A1A, clNone, clNone'
        'Pushed.TextColor=clBlack'
        'Checked.Body=1, $00373737, $00171717, clNone, clNone'
        'Checked.Borders=2, clBlack, clBlack, $00524743, $0036302E'
        'Checked.TextColor=$00A2E0EB'
        
          'CheckedAndHotTrack.Body=3, $00CCF4F2, $00729EA6, $00537C84, $004' +
          'B93A7'
        
          'CheckedAndHotTrack.Borders=2, $001A1A1A, $001A1A1A, clNone, clNo' +
          'ne'
        'CheckedAndHotTrack.TextColor=clBlack'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[TrackBar]'
        'Normal.Body=3, $00524743, $00463E3B, $0030302F, $00454545'
        'Normal.Borders=2, clBlack, $00333333, $0030302F, $0030302F'
        'Normal.TextColor=$007B919F'
        'HotTrack.Body=5, $00C1FCFF, $007DE2FF, $002FD0FF, $0079E1FF'
        'HotTrack.Borders=2, $0036302E, $0036302E, clBlack, clBlack'
        'HotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        ''
        '[TrackBarButton]'
        'Normal.Body=3, $00CCF4F2, $00729EA6, $00537C84, $004B93A7'
        'Normal.Borders=2, $0059858E, $0031474D, clNone, clNone'
        'Normal.TextColor=clBlack'
        'Pushed.Body=5, $00C1FCFF, $007DE2FF, $002FD0FF, $0079E1FF'
        'Pushed.Borders=2, $00333333, $00333333, $004CD7FF, $004CD7FF'
        'Pushed.TextColor=clBlack'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        ''
        '[OpenToolbarItem]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=$00A2E0EB'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Gutter]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[TASClientColor]'
        'Normal=7511718'
        'Data=32768'
        'Error=3289801'
        'Info=16762273'
        'MinorInfo=13716813'
        'ChanJoin=32768'
        'ChanLeft=16762273'
        'MOTD=5855610'
        'SayEx=8738949'
        'Topic=5855610'
        'ClientAway=5526612'
        'MapModUnavailable=11028383'
        'BotText=8421504'
        'MyText=10674411'
        'AdminText=11135906'
        'OldMsgs=5526612'
        'BattleDetailsNonDefault=11028383'
        'BattleDetailsChanged=16762273'
        'ClientIngame=13716813'
        'ReplayWinningTeam=2900515'
        ''
        '[StatusBar]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone')
      TabOrder = 7
      Visible = False
    end
    object memoTASClientLightSkin: TTntMemo
      Left = 687
      Top = 192
      Width = 401
      Height = 153
      Anchors = [akTop, akRight]
      Lines.Strings = (
        '[Skin]'
        'Name=TASCLient Light Skin'
        'Author=Satirik'
        'ColorBtnFace=clBtnFace'
        'FloatingWindowBorderSize=4'
        'OfficeIcons=0'
        'OfficeMenu=0'
        'OfficeStatusBar=0'
        ''
        '[Dock]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[DockablePanel]'
        'Normal.Body=0, clBlack, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[DockablePanelTitleBar]'
        'Normal.Body=1, $00D8D8D8, clWhite, clNone, clNone'
        'Normal.Borders=0, $00A6A6A6, $00A6A6A6, clWhite, clNone'
        'Normal.TextColor=$00484848'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=$00484848'
        ''
        '[MenuBar]'
        'Normal.Body=0, $00EAEAEA, clNone, clNone, clNone'
        'Normal.Borders=0, clWhite, $00B7C1CB, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Panel]'
        'Normal.Body=1, $00E4E4E4, clWhite, clNone, clNone'
        'Normal.Borders=0, $00E4E4E4, $00E4E4E4, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Popup]'
        'Normal.Body=10, $00333333, $00666666, $005F5F5F, $00333333'
        'Normal.Borders=0, $00737373, $003E3E3E, clNone, clNone'
        'Normal.TextColor=$00C6C6C6'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Separator]'
        'Normal.Body=0, clBlack, $00666666, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Splitter]'
        'Normal.Body=1, $00B9B9B9, $006E6E6E, clNone, clNone'
        'Normal.Borders=0, $00E4E4E4, $00E4E4E4, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[StatusBar]'
        'Normal.Body=0, $00EAEAEA, clNone, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[StatusBarGrip]'
        'Normal.Body=0, $00B7C1CB, clWhite, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[TabBackground]'
        'Normal.Body=1, $00FCFCFC, $00D8D8D8, clNone, clNone'
        'Normal.Borders=0, $00747474, $00747474, clWhite, $00E0E0E0'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Toolbar]'
        'Normal.Body=0, $00EAEAEA, clNone, clNone, clNone'
        'Normal.Borders=0, clWhite, $00B7C1CB, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[ToolbarGrip]'
        'Normal.Body=0, $00333333, $00CCCCCC, clNone, clNone'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[Window]'
        'Normal.Body=1, $00E4E4E4, clWhite, clNone, clNone'
        'Normal.Borders=0, $006B6B6B, $00CCCCCC, clWhite, clWhite'
        'Normal.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[WindowTitleBar]'
        'Normal.Body=5, clWhite, $00E4E4E4, $00CACACA, $00E4E4E4'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clBlack'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        ''
        '[MenuBarItem]'
        'HotTrack.Body=1, $00D4D4D4, $00B7B7B7, clNone, clNone'
        'HotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'HotTrack.TextColor=clNone'
        'Pushed.Body=1, $00D4D4D4, $00B7B7B7, clNone, clNone'
        'Pushed.Borders=0, clNone, clNone, clNone, clNone'
        'Pushed.TextColor=clNone'
        'Checked.Body=1, $00D4D4D4, $00B7B7B7, clNone, clNone'
        'Checked.Borders=0, clNone, clNone, clNone, clNone'
        'Checked.TextColor=clNone'
        'CheckedAndHotTrack.Body=1, $00D4D4D4, $00B7B7B7, clNone, clNone'
        'CheckedAndHotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'CheckedAndHotTrack.TextColor=clNone'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[MenuItem]'
        'HotTrack.Body=0, $00999999, $00666666, $005F5F5F, $00333333'
        'HotTrack.Borders=0, $00333333, $00333333, clNone, clNone'
        'HotTrack.TextColor=clBlack'
        'Checked.Body=0, clNone, clNone, clNone, clNone'
        'Checked.Borders=0, clNone, clNone, clNone, clNone'
        'Checked.TextColor=clWhite'
        
          'CheckedAndHotTrack.Body=0, $00999999, $00666666, $005F5F5F, $003' +
          '33333'
        
          'CheckedAndHotTrack.Borders=0, $00333333, $00333333, clNone, clNo' +
          'ne'
        'CheckedAndHotTrack.TextColor=clBlack'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clWhite'
        'Normal.MarkColor=clWhite'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clBlack'
        'Pushed.Body=0, clNone, clNone, clNone, clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.Borders=0, clNone, clNone, clNone, clNone'
        'Pushed.TextColor=clWhite'
        'Pushed.MarkColor=clWhite'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clWhite'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clBlack'
        ''
        '[ToolbarItem]'
        'HotTrack.Body=1, $007A7A7A, $002D2D2D, clNone, clNone'
        'HotTrack.Borders=0, clNone, clNone, clBlack, clBlack'
        'HotTrack.TextColor=clWhite'
        'Pushed.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Pushed.Borders=2, $00787878, $00787878, clBlack, clBlack'
        'Pushed.TextColor=clNone'
        'Checked.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Checked.Borders=2, $00787878, $00787878, clBlack, clBlack'
        'Checked.TextColor=clNone'
        
          'CheckedAndHotTrack.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAE' +
          'AEA'
        
          'CheckedAndHotTrack.Borders=2, $00787878, $00787878, clBlack, clB' +
          'lack'
        'CheckedAndHotTrack.TextColor=clNone'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[Button]'
        'Normal.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Normal.Borders=2, $00D4D4D4, $00D4D4D4, $00696969, $00696969'
        'Normal.TextColor=clNone'
        'Disabled.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Disabled.Borders=2, $00D0D4D8, $00D0D4D8, $00606A73, $00606A73'
        'Disabled.TextColor=clNone'
        'HotTrack.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'HotTrack.Borders=2, $00787878, $00787878, clBlack, clBlack'
        'HotTrack.TextColor=clNone'
        'Pushed.Body=1, $007A7A7A, $002D2D2D, clNone, clNone'
        'Pushed.Borders=0, $00E9E9E9, $00E9E9E9, clWhite, clWhite'
        'Pushed.TextColor=clWhite'
        'Checked.Body=1, $007A7A7A, $002D2D2D, clNone, clNone'
        'Checked.Borders=0, $00E9E9E9, $00E9E9E9, clWhite, clWhite'
        'Checked.TextColor=clWhite'
        
          'CheckedAndHotTrack.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAE' +
          'AEA'
        'CheckedAndHotTrack.Borders=2, $009E9E9E, $009E9E9E, $001B1B1B, '
        '$001B1B1B'
        'CheckedAndHotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[CheckBox]'
        'Normal.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Normal.Borders=2, $00666666, $00666666, $00F1F1F1, $00F1F1F1'
        'Normal.TextColor=clNone'
        'Disabled.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Disabled.Borders=2, $00D0D4D8, $00D0D4D8, $00606A73, $00606A73'
        'Disabled.TextColor=clNone'
        'HotTrack.Body=1, clBlack, $00333333, clNone, clNone'
        'HotTrack.Borders=2, $00333333, $00333333, clBlack, clBlack'
        'HotTrack.TextColor=clNone'
        'Pushed.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Pushed.Borders=2, $00666666, $00666666, $00F1F1F1, $00F1F1F1'
        'Pushed.TextColor=clNone'
        'Checked.Body=1, $00999999, $00666666, clNone, clNone'
        'Checked.Borders=2, $00333333, $00333333, $00999999, $00999999'
        'Checked.TextColor=clNone'
        'CheckedAndHotTrack.Body=1, clBlack, $00333333, clNone, clNone'
        
          'CheckedAndHotTrack.Borders=2, $00333333, $00333333, clBlack, clB' +
          'lack'
        'CheckedAndHotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clWhite'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clWhite'
        ''
        '[EditButton]'
        'HotTrack.Body=1, $00BBBBBB, $00919191, clNone, clNone'
        'HotTrack.Borders=0, $008C8C8C, $008C8C8C, $00C5C5C5, $00C5C5C5'
        'HotTrack.TextColor=clNone'
        'Pushed.Body=1, $00999999, $00555555, clNone, clNone'
        'Pushed.Borders=0, $008C8C8C, $008C8C8C, $00C5C5C5, $00C5C5C5'
        'Pushed.TextColor=clWhite'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.Body=0, clNone, clNone, clNone, clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.Borders=0, clNone, clNone, clNone, clNone'
        'Checked.TextColor=clNone'
        'Checked.MarkColor=clNone'
        'CheckedAndHotTrack.Body=0, clNone, clNone, clNone, clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'CheckedAndHotTrack.TextColor=clNone'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[EditFrame]'
        'Normal.Body=0, $00EFEFEF, clNone, clNone, clNone'
        'Normal.Borders=1, $00868686, $00868686, $00E6E6E6, $00E6E6E6'
        'Normal.TextColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.Borders=1, clNone, clNone, $00E6E6E6, $00E6E6E6'
        'Disabled.TextColor=clNone'
        'HotTrack.Body=0, $00EFEFEF, clNone, clNone, clNone'
        'HotTrack.Borders=2, $00787878, $00787878, clBlack, clBlack'
        'HotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        ''
        '[Header]'
        'Normal.Body=1, $00E4E4E4, clWhite, clNone, clNone'
        'Normal.Borders=0, clWhite, $00AEAEAE, clNone, clNone'
        'Normal.TextColor=clNone'
        'HotTrack.Body=1, clWhite, $00E4E4E4, clNone, clNone'
        'HotTrack.Borders=0, $00AEAEAE, $00AEAEAE, clNone, clNone'
        'HotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.Body=0, clNone, clNone, clNone, clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.Borders=0, clNone, clNone, clNone, clNone'
        'Pushed.TextColor=clNone'
        'Pushed.MarkColor=clNone'
        ''
        '[ListItem]'
        'HotTrack.Body=1, $00333333, $00585858, $00535353, $00333333'
        'HotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'HotTrack.TextColor=clWhite'
        'Checked.Body=1, $00C1C1C1, $00A3A3A3, clNone, clNone'
        'Checked.Borders=0, clNone, clNone, clNone, clNone'
        'Checked.TextColor=clNone'
        
          'CheckedAndHotTrack.Body=1, $005B5B5B, $00999999, $00535353, $003' +
          '33333'
        'CheckedAndHotTrack.Borders=0, clNone, clNone, clNone, clNone'
        'CheckedAndHotTrack.TextColor=clWhite'
        'Normal.Body=0, $00E4E4E4, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, $00E4E4E4, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.Body=0, $00E4E4E4, clNone, clNone, clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.Borders=0, clNone, clNone, clNone, clNone'
        'Pushed.TextColor=clNone'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[ProgressBar]'
        'Normal.Body=5, clWhite, $00EDF0F3, $00E2E7EC, $00E7EBEF'
        'Normal.Borders=2, $00D0D4D8, $00D0D4D8, $00606A73, $00606A73'
        'Normal.TextColor=clNone'
        'HotTrack.Body=5, $00CDCDCD, $00AFAFAF, $00898989, $00B1B1B1'
        'HotTrack.Borders=2, $00D0D4D8, $00D0D4D8, $00606A73, $00606A73'
        'HotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        ''
        '[RadioButton]'
        'Normal.Body=5, clWhite, $00EDF0F3, $00E2E7EC, $00E7EBEF'
        'Normal.Borders=2, $00666666, $00666666, $00F1F1F1, $00F1F1F1'
        'Normal.TextColor=clNone'
        'Disabled.Body=5, clWhite, $00EDF0F3, $00E2E7EC, $00E7EBEF'
        'Disabled.Borders=2, $00D0D4D8, $00D0D4D8, $00606A73, $00606A73'
        'Disabled.TextColor=clNone'
        'HotTrack.Body=1, clBlack, $00333333, clNone, clNone'
        'HotTrack.Borders=2, $00333333, $00333333, clBlack, clBlack'
        'HotTrack.TextColor=clNone'
        'Pushed.Body=5, clWhite, $00EDF0F3, $00E2E7EC, $00E7EBEF'
        'Pushed.Borders=2, $00666666, $00666666, $00F1F1F1, $00F1F1F1'
        'Pushed.TextColor=clNone'
        'Checked.Body=1, $00999999, $00666666, clNone, clNone'
        'Checked.Borders=2, $00333333, $00333333, $00999999, $00999999'
        'Checked.TextColor=clNone'
        'CheckedAndHotTrack.Body=1, clBlack, $00333333, clNone, clNone'
        
          'CheckedAndHotTrack.Borders=2, $00333333, $00333333, clBlack, clB' +
          'lack'
        'CheckedAndHotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clWhite'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clWhite'
        ''
        '[Tab]'
        'Normal.Body=0, $00EAEAEA, clNone, clNone, clNone'
        'Normal.Borders=2, $00A4A4A4, $00A4A4A4, $00E4E4E4, $00E4E4E4'
        'Normal.TextColor=clNone'
        'Disabled.Body=0, $00DBDFE4, clNone, clNone, clNone'
        'Disabled.Borders=2, $00B8C2CA, $00B8C2CA, $00E1E4E8, $00E1E4E8'
        'Disabled.TextColor=clNone'
        'HotTrack.Body=1, $007A7A7A, $002D2D2D, clNone, clNone'
        'HotTrack.Borders=2, clWhite, clWhite, $007A7A7A, $007A7A7A'
        'HotTrack.TextColor=clWhite'
        'Checked.Body=1, $00D8D8D8, clWhite, clNone, clNone'
        'Checked.Borders=2, $00677883, $00677883, clWhite, $00DCE0E4'
        'Checked.TextColor=clNone'
        'CheckedAndHotTrack.Body=1, $007A7A7A, $002D2D2D, clNone, clNone'
        
          'CheckedAndHotTrack.Borders=2, clWhite, clWhite, $007A7A7A, $007A' +
          '7A7A'
        'CheckedAndHotTrack.TextColor=clWhite'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        'Pushed.Body=1, $007A7A7A, $002D2D2D, clNone, clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.Borders=2, clWhite, clWhite, $007A7A7A, $007A7A7A'
        'Pushed.TextColor=clWhite'
        'Pushed.MarkColor=clNone'
        'Checked.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Checked.MarkColor=clNone'
        
          'CheckedAndHotTrack.TexturedBody=0, "", "", "", "", "", "", "", "' +
          '", ""'
        'CheckedAndHotTrack.MarkColor=clNone'
        ''
        '[TrackBar]'
        'Normal.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Normal.Borders=2, $00D4D4D4, $00D4D4D4, $00696969, $00696969'
        'Normal.TextColor=clNone'
        'HotTrack.Body=5, $00CDCDCD, $00AFAFAF, $00898989, $00B1B1B1'
        'HotTrack.Borders=2, $00D0D4D8, $00D0D4D8, $00606A73, $00606A73'
        'HotTrack.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'HotTrack.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'HotTrack.MarkColor=clNone'
        ''
        '[TrackBarButton]'
        'Normal.Body=5, clWhite, $00F0F0F0, $00E6E6E6, $00EAEAEA'
        'Normal.Borders=2, $00D4D4D4, $00D4D4D4, $00696969, $00696969'
        'Normal.TextColor=clNone'
        'Pushed.Body=5, $00CDCDCD, $00AFAFAF, $00898989, $00B1B1B1'
        'Pushed.Borders=2, $00D0D4D8, $00D0D4D8, $00606A73, $00606A73'
        'Pushed.TextColor=clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.MarkColor=clNone'
        'Pushed.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Pushed.MarkColor=clNone'
        ''
        '[Gutter]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone'
        ''
        '[OpenToolbarItem]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone'
        ''
        '[TabToolbar]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone'
        ''
        '[Label]'
        'Normal.Body=0, clNone, clNone, clNone, clNone'
        'Normal.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Normal.Borders=0, clNone, clNone, clNone, clNone'
        'Normal.TextColor=clNone'
        'Normal.MarkColor=clNone'
        'Disabled.Body=0, clNone, clNone, clNone, clNone'
        'Disabled.TexturedBody=0, "", "", "", "", "", "", "", "", ""'
        'Disabled.Borders=0, clNone, clNone, clNone, clNone'
        'Disabled.TextColor=clNone'
        'Disabled.MarkColor=clNone'
        ''
        '[TASClientColor]'
        'Normal=0'
        'Data=32768'
        'Error=255'
        'Info=16711680'
        'MinorInfo=8388608'
        'ChanJoin=32768'
        'ChanLeft=8388608'
        'MOTD=128'
        'SayEx=8388736'
        'Topic=128'
        'ClientAway=10461087'
        'MapModUnavailable=15532245'
        'BotText=8421504'
        'MyText=9597550'
        'AdminText=222883'
        'OldMsgs=12829635'
        'BattleDetailsNonDefault=11739556'
        'BattleDetailsChanged=14177792'
        'ClientIngame=10424593'
        'ReplayWinningTeam=12116153')
      TabOrder = 8
      Visible = False
    end
  end
  object AddressPopupMenu: TSpTBXPopupMenu
    Left = 372
    Top = 88
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
    Left = 412
    Top = 691
  end
  object OpenDialog1: TOpenDialog
    Left = 336
    Top = 324
  end
end
