object PreferencesForm: TPreferencesForm
  Left = 425
  Top = 392
  BorderStyle = bsDialog
  Caption = 'Preferences'
  ClientHeight = 262
  ClientWidth = 321
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
  object ApplyAndCloseButton: TButton
    Left = 16
    Top = 200
    Width = 289
    Height = 25
    Caption = 'Apply and close'
    TabOrder = 0
    OnClick = ApplyAndCloseButtonClick
  end
  object PageControl1: TPageControl
    Left = 16
    Top = 16
    Width = 289
    Height = 177
    ActivePage = TabSheet3
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Server'
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 74
        Height = 13
        Caption = 'Server address:'
      end
      object Label2: TLabel
        Left = 16
        Top = 48
        Width = 55
        Height = 13
        Caption = 'Server port:'
      end
      object AddressSpeedButton: TSpeedButton
        Left = 232
        Top = 24
        Width = 23
        Height = 21
        Caption = '>>'
        OnClick = AddressSpeedButtonClick
      end
      object Edit1: TEdit
        Left = 96
        Top = 24
        Width = 137
        Height = 21
        TabOrder = 0
        Text = '127.0.0.1'
      end
      object Edit2: TEdit
        Left = 96
        Top = 48
        Width = 41
        Height = 21
        TabOrder = 1
        Text = '8200'
      end
      object CheckBox2: TCheckBox
        Left = 16
        Top = 96
        Width = 153
        Height = 17
        Caption = 'Connect on startup'
        TabOrder = 2
      end
      object CheckBox7: TCheckBox
        Left = 16
        Top = 112
        Width = 249
        Height = 17
        Caption = 'Join #main once connected (recommended)'
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Account'
      ImageIndex = 1
      object Label4: TLabel
        Left = 24
        Top = 32
        Width = 51
        Height = 13
        Caption = 'Username:'
      end
      object Label5: TLabel
        Left = 24
        Top = 64
        Width = 49
        Height = 13
        Caption = 'Password:'
      end
      object SpeedButton1: TSpeedButton
        Left = 88
        Top = 96
        Width = 121
        Height = 33
        Caption = 'Register this account'
        OnClick = SpeedButton1Click
      end
      object UsernameEdit: TEdit
        Left = 88
        Top = 32
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object PasswordEdit: TEdit
        Left = 88
        Top = 64
        Width = 121
        Height = 21
        PasswordChar = '*'
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Program'
      ImageIndex = 2
      object Label6: TLabel
        Left = 16
        Top = 24
        Width = 46
        Height = 13
        Caption = 'Tab style:'
      end
      object GameSettingsButton: TSpeedButton
        Left = 152
        Top = 112
        Width = 113
        Height = 22
        Caption = 'Game settings'
        OnClick = GameSettingsButtonClick
      end
      object SpeedButton2: TSpeedButton
        Left = 16
        Top = 112
        Width = 113
        Height = 22
        Caption = 'Reset registry data'
        OnClick = SpeedButton2Click
      end
      object SpeedButton3: TSpeedButton
        Left = 152
        Top = 88
        Width = 113
        Height = 22
        Caption = 'Notifications ...'
        OnClick = SpeedButton3Click
      end
      object RadioButton4: TRadioButton
        Left = 16
        Top = 48
        Width = 89
        Height = 17
        Caption = 'tabs'
        TabOrder = 0
      end
      object RadioButton5: TRadioButton
        Left = 16
        Top = 64
        Width = 89
        Height = 17
        Caption = 'buttons'
        TabOrder = 1
      end
      object RadioButton6: TRadioButton
        Left = 16
        Top = 80
        Width = 89
        Height = 17
        Caption = 'flat buttons'
        Checked = True
        TabOrder = 2
        TabStop = True
      end
      object CheckBox8: TCheckBox
        Left = 128
        Top = 48
        Width = 113
        Height = 17
        Caption = 'Enable logging'
        TabOrder = 3
      end
      object CheckBox9: TCheckBox
        Left = 128
        Top = 64
        Width = 145
        Height = 17
        Caption = 'Use sound notifications'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Misc'
      ImageIndex = 3
      object UDPSourcePortEdit: TEdit
        Left = 32
        Top = 64
        Width = 57
        Height = 21
        Enabled = False
        TabOrder = 0
        Text = '0'
      end
      object RadioButton1: TRadioButton
        Left = 16
        Top = 24
        Width = 249
        Height = 17
        Caption = 'Use default UDP source port (recommended)'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = RadioButton1Click
      end
      object RadioButton2: TRadioButton
        Left = 16
        Top = 40
        Width = 241
        Height = 17
        Caption = 'Use the following UDP source port:'
        TabOrder = 2
        OnClick = RadioButton2Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Interface'
      ImageIndex = 4
      object CheckBox1: TCheckBox
        Left = 8
        Top = 24
        Width = 129
        Height = 17
        Caption = 'Timestamp events'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object CheckBox3: TCheckBox
        Left = 8
        Top = 40
        Width = 137
        Height = 17
        Caption = 'Filter join/left messages'
        TabOrder = 1
      end
      object CheckBox4: TCheckBox
        Left = 8
        Top = 56
        Width = 121
        Height = 17
        Caption = 'Show country flags'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object CheckBox5: TCheckBox
        Left = 8
        Top = 72
        Width = 129
        Height = 17
        Caption = 'Mark unknown maps'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object CheckBox6: TCheckBox
        Left = 8
        Top = 88
        Width = 257
        Height = 17
        Caption = 'Use taskbar button for each form (requires restart)'
        TabOrder = 4
      end
    end
  end
  object CancelAndCloseButton: TButton
    Left = 16
    Top = 232
    Width = 289
    Height = 25
    Cancel = True
    Caption = 'Cancel and close'
    TabOrder = 2
    OnClick = CancelAndCloseButtonClick
  end
  object AddressPopupMenu: TPopupMenu
    Left = 284
    Top = 48
    object Item1: TMenuItem
      Caption = 'Official host (taspringmaster.clan-sy.com)'
      OnClick = Item1Click
    end
    object Item2: TMenuItem
      Caption = 'Backup host (cheetah.sentvid.org)'
      OnClick = Item2Click
    end
    object Item3: TMenuItem
      Caption = 'Local server (localhost)'
      OnClick = Item3Click
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdEffects, fdNoSizeSel, fdNoStyleSel]
    Left = 252
    Top = 48
  end
end
