object PreferencesForm: TPreferencesForm
  Left = 582
  Top = 238
  BorderStyle = bsDialog
  Caption = 'Preferences'
  ClientHeight = 339
  ClientWidth = 377
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
    Width = 377
    Height = 339
    Caption = 'Preferences'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object SpTBXTabControl1: TSpTBXTabControl
      Left = 8
      Top = 40
      Width = 361
      Height = 238
      ActiveTabIndex = 3
      TabAutofit = True
      HiddenItems = <>
      object SpTBXTabItem6: TSpTBXTabItem
        CustomWidth = 59
        CaptionW = 'Server'
      end
      object SpTBXTabItem5: TSpTBXTabItem
        CustomWidth = 59
        CaptionW = 'Account'
      end
      object SpTBXTabItem4: TSpTBXTabItem
        CustomWidth = 59
        CaptionW = 'Program'
      end
      object SpTBXTabItem3: TSpTBXTabItem
        Checked = True
        CustomWidth = 59
        CaptionW = 'Interface'
      end
      object SpTBXTabItem2: TSpTBXTabItem
        CustomWidth = 59
        CaptionW = 'HTTP'
      end
      object SpTBXTabItem1: TSpTBXTabItem
        Enabled = False
        CustomWidth = 59
        CaptionW = 'Skins'
      end
      object SpTBXTabSheet2: TSpTBXTabSheet
        Left = 0
        Top = 23
        Width = 361
        Height = 215
        Caption = 'HTTP'
        ImageIndex = -1
        TabItem = 'SpTBXTabItem2'
        object GroupBox6: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 329
          Height = 193
          Caption = 'Proxy settings'
          Color = clNone
          ParentColor = False
          TabOrder = 0
          object UseProxyCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 32
            Width = 67
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
            Width = 249
            Height = 113
            Caption = 'ProxyPanel'
            Color = clNone
            ParentColor = False
            TabOrder = 1
            object ProxyEdit: TSpTBXEdit
              Left = 64
              Top = 8
              Width = 177
              Height = 21
              TabOrder = 0
            end
            object Label7: TSpTBXLabel
              Left = 8
              Top = 8
              Width = 41
              Height = 13
              Caption = 'Address:'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object Label8: TSpTBXLabel
              Left = 8
              Top = 32
              Width = 22
              Height = 13
              Caption = 'Port:'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object JvProxyPortEdit: TJvValidateEdit
              Left = 64
              Top = 32
              Width = 49
              Height = 21
              Alignment = taLeftJustify
              EditText = '0'
              TabOrder = 3
            end
            object ProxyUserEdit: TSpTBXEdit
              Left = 64
              Top = 56
              Width = 89
              Height = 21
              TabOrder = 4
            end
            object Label9: TSpTBXLabel
              Left = 8
              Top = 56
              Width = 51
              Height = 13
              Caption = 'Username:'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object Label10: TSpTBXLabel
              Left = 8
              Top = 80
              Width = 49
              Height = 13
              Caption = 'Password:'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object ProxyPassEdit: TSpTBXEdit
              Left = 64
              Top = 80
              Width = 89
              Height = 21
              TabOrder = 7
            end
          end
        end
      end
      object SpTBXTabSheet5: TSpTBXTabSheet
        Left = 0
        Top = 23
        Width = 361
        Height = 215
        Caption = 'Account'
        ImageIndex = -1
        TabItem = 'SpTBXTabItem5'
        object GroupBox2: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 329
          Height = 193
          Caption = 'Account details'
          Color = clNone
          ParentColor = False
          TabOrder = 0
          object RegisterAccountButton: TSpTBXSpeedButton
            Left = 24
            Top = 112
            Width = 185
            Height = 25
            Caption = 'Create new account'
            OnClick = RegisterAccountButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object Label4: TSpTBXLabel
            Left = 24
            Top = 40
            Width = 51
            Height = 13
            Caption = 'Username:'
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object Label5: TSpTBXLabel
            Left = 24
            Top = 72
            Width = 49
            Height = 13
            Caption = 'Password:'
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object UsernameEdit: TSpTBXEdit
            Left = 88
            Top = 40
            Width = 121
            Height = 21
            TabOrder = 0
          end
          object PasswordEdit: TSpTBXEdit
            Left = 88
            Top = 72
            Width = 121
            Height = 21
            TabOrder = 1
            PasswordCharW = '*'
          end
        end
      end
      object SpTBXTabSheet4: TSpTBXTabSheet
        Left = 0
        Top = 23
        Width = 361
        Height = 215
        Caption = 'Program'
        ImageIndex = -1
        TabItem = 'SpTBXTabItem4'
        object GroupBox3: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 329
          Height = 193
          Caption = 'Program settings'
          Color = clNone
          ParentColor = False
          TabOrder = 0
          object ResetRegistryButton: TSpTBXSpeedButton
            Left = 184
            Top = 152
            Width = 113
            Height = 22
            Caption = 'Reset registry data'
            OnClick = ResetRegistryButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object GameSettingsButton: TSpTBXSpeedButton
            Left = 184
            Top = 80
            Width = 113
            Height = 22
            Caption = 'Game settings'
            OnClick = GameSettingsButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object NotificationsButton: TSpTBXSpeedButton
            Left = 184
            Top = 56
            Width = 113
            Height = 22
            Caption = 'Notifications ...'
            OnClick = NotificationsButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object HighlightingButton: TSpTBXSpeedButton
            Left = 184
            Top = 32
            Width = 113
            Height = 22
            Caption = 'Highlighting ...'
            OnClick = HighlightingButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object IgnoreListButton: TSpTBXSpeedButton
            Left = 184
            Top = 104
            Width = 113
            Height = 22
            Caption = 'Ignore list ...'
            OnClick = IgnoreListButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object Label6: TSpTBXLabel
            Left = 16
            Top = 32
            Width = 46
            Height = 13
            Caption = 'Tab style:'
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object RadioButton4: TSpTBXRadioButton
            Left = 16
            Top = 56
            Width = 40
            Height = 15
            Caption = 'tabs'
            TabOrder = 0
          end
          object RadioButton5: TSpTBXRadioButton
            Left = 16
            Top = 72
            Width = 55
            Height = 15
            Caption = 'buttons'
            TabOrder = 1
          end
          object RadioButton6: TSpTBXRadioButton
            Left = 16
            Top = 88
            Width = 72
            Height = 15
            Caption = 'flat buttons'
            TabOrder = 2
            Checked = True
          end
          object CheckBox8: TSpTBXCheckBox
            Left = 16
            Top = 144
            Width = 90
            Height = 15
            Caption = 'Enable logging'
            TabOrder = 3
            Checked = True
            State = cbChecked
          end
          object CheckBox9: TSpTBXCheckBox
            Left = 16
            Top = 160
            Width = 130
            Height = 15
            Caption = 'Use sound notifications'
            TabOrder = 4
            Checked = True
            State = cbChecked
          end
        end
      end
      object SpTBXTabSheet1: TSpTBXTabSheet
        Left = 0
        Top = 23
        Width = 361
        Height = 215
        Caption = 'Skins'
        ImageIndex = -1
        TabItem = 'SpTBXTabItem1'
        object GroupBox5: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 329
          Height = 193
          Caption = 'Skin manager'
          Color = clNone
          ParentColor = False
          TabOrder = 0
          object SpTBXThemesComboBox: TSpTBXComboBox
            Left = 48
            Top = 56
            Width = 145
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = SpTBXThemesComboBoxChange
          end
          object SpTBXRadioButton1: TSpTBXRadioButton
            Left = 48
            Top = 120
            Width = 46
            Height = 15
            Caption = 'None'
            TabOrder = 1
            OnClick = SpTBXRadioButton1Click
            Checked = True
          end
          object SpTBXRadioButton2: TSpTBXRadioButton
            Left = 48
            Top = 136
            Width = 64
            Height = 15
            Caption = 'Windows'
            TabOrder = 2
            OnClick = SpTBXRadioButton2Click
          end
          object Label3: TSpTBXLabel
            Left = 32
            Top = 32
            Width = 61
            Height = 13
            Caption = 'Choose skin:'
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object SpTBXRadioButton3: TSpTBXRadioButton
            Left = 48
            Top = 152
            Width = 78
            Height = 15
            Caption = 'TBX themes'
            TabOrder = 4
            OnClick = SpTBXRadioButton3Click
          end
          object Label11: TSpTBXLabel
            Left = 32
            Top = 96
            Width = 60
            Height = 13
            Caption = 'Theme style:'
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
        end
      end
      object SpTBXTabSheet6: TSpTBXTabSheet
        Left = 0
        Top = 23
        Width = 361
        Height = 215
        Caption = 'Server'
        ImageIndex = -1
        TabItem = 'SpTBXTabItem6'
        object GroupBox1: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 329
          Height = 193
          Caption = 'Server settings'
          Color = clNone
          ParentColor = False
          TabOrder = 0
          object AddressButton: TSpTBXSpeedButton
            Left = 232
            Top = 32
            Width = 23
            Height = 21
            Caption = '>>'
            OnClick = AddressButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object Label1: TSpTBXLabel
            Left = 16
            Top = 32
            Width = 74
            Height = 13
            Caption = 'Server address:'
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object Label2: TSpTBXLabel
            Left = 16
            Top = 56
            Width = 55
            Height = 13
            Caption = 'Server port:'
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object ServerAddressEdit: TSpTBXEdit
            Left = 96
            Top = 32
            Width = 137
            Height = 21
            TabOrder = 0
            Text = '127.0.0.1'
          end
          object JvXPButton1: TJvXPButton
            Left = 184
            Top = 56
            Caption = 'Perform ...'
            TabOrder = 1
            OnClick = JvXPButton1Click
          end
          object ServerPortEdit: TSpTBXEdit
            Left = 96
            Top = 56
            Width = 41
            Height = 21
            TabOrder = 2
            Text = '8200'
          end
          object CheckBox10: TSpTBXCheckBox
            Left = 16
            Top = 128
            Width = 199
            Height = 15
            Caption = 'Connect to backup host if primary fails'
            TabOrder = 3
            Checked = True
            State = cbChecked
          end
          object CheckBox2: TSpTBXCheckBox
            Left = 16
            Top = 144
            Width = 110
            Height = 15
            Caption = 'Connect on startup'
            TabOrder = 4
          end
          object CheckBox7: TSpTBXCheckBox
            Left = 16
            Top = 160
            Width = 228
            Height = 15
            Caption = 'Join #main once connected (recommended)'
            TabOrder = 5
          end
        end
      end
      object SpTBXTabSheet3: TSpTBXTabSheet
        Left = 0
        Top = 23
        Width = 361
        Height = 215
        Caption = 'Interface'
        ImageIndex = -1
        TabItem = 'SpTBXTabItem3'
        object GroupBox4: TSpTBXGroupBox
          Left = 16
          Top = 8
          Width = 329
          Height = 193
          Caption = 'Interface preferences'
          Color = clNone
          ParentColor = False
          TabOrder = 0
          object CheckBox1: TSpTBXCheckBox
            Left = 24
            Top = 40
            Width = 106
            Height = 15
            Caption = 'Timestamp events'
            TabOrder = 0
            Checked = True
            State = cbChecked
          end
          object CheckBox3: TSpTBXCheckBox
            Left = 24
            Top = 56
            Width = 130
            Height = 15
            Caption = 'Filter join/left messages'
            TabOrder = 1
          end
          object CheckBox4: TSpTBXCheckBox
            Left = 24
            Top = 72
            Width = 110
            Height = 15
            Caption = 'Show country flags'
            TabOrder = 2
            Checked = True
            State = cbChecked
          end
          object CheckBox5: TSpTBXCheckBox
            Left = 24
            Top = 88
            Width = 119
            Height = 15
            Caption = 'Mark unknown maps'
            TabOrder = 3
            Checked = True
            State = cbChecked
          end
          object CheckBox6: TSpTBXCheckBox
            Left = 24
            Top = 104
            Width = 253
            Height = 15
            Caption = 'Use taskbar button for each form (requires restart)'
            TabOrder = 4
          end
          object WarnNATCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 120
            Width = 273
            Height = 15
            Caption = 'Display warning icons on battles using NAT traversing'
            TabOrder = 5
            Checked = True
            State = cbChecked
          end
          object AutoFocusOnPMCheckBox: TSpTBXCheckBox
            Left = 24
            Top = 136
            Width = 264
            Height = 15
            Caption = 'Automatically switch focus to new private messages'
            TabOrder = 6
            Checked = True
            State = cbChecked
          end
        end
      end
    end
    object ApplyAndCloseButton: TSpTBXButton
      Left = 24
      Top = 296
      Width = 145
      Height = 25
      Caption = 'Apply and close'
      TabOrder = 2
      OnClick = ApplyAndCloseButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object CancelAndCloseButton: TSpTBXButton
      Left = 208
      Top = 296
      Width = 145
      Height = 25
      Caption = 'Cancel and close'
      TabOrder = 3
      OnClick = CancelAndCloseButtonClick
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
  object AddressPopupMenu: TSpTBXPopupMenu
    Left = 340
    Top = 32
  end
end
