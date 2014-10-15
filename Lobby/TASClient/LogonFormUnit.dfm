object LogonForm: TLogonForm
  Left = 467
  Top = 430
  Width = 385
  Height = 352
  Caption = 'Logon'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 377
    Height = 325
    Caption = 'Logon'
    Active = False
    FixedSize = True
    Options.Maximize = False
    object gbServerSettings: TSpTBXGroupBox
      Left = 16
      Top = 32
      Width = 345
      Height = 81
      Caption = 'Server settings'
      TabOrder = 1
      TBXStyleBackground = True
      object lblServer: TSpTBXLabel
        Left = 16
        Top = 24
        Width = 37
        Height = 13
        Caption = 'Server :'
      end
      object txtPort: TSpTBXEdit
        Left = 88
        Top = 48
        Width = 57
        Height = 21
        TabOrder = 1
        Text = '8200'
        OnKeyPress = txtPortKeyPress
      end
      object lblPort: TSpTBXLabel
        Left = 16
        Top = 48
        Width = 25
        Height = 13
        Caption = 'Port :'
      end
      object beServer: TSpTBXButtonEdit
        Left = 88
        Top = 24
        Width = 249
        Height = 21
        TabOrder = 3
        EditButton.Left = 225
        EditButton.Top = 0
        EditButton.Width = 20
        EditButton.Height = 17
        EditButton.Caption = '...'
        EditButton.Align = alRight
        EditButton.DropDownArrow = False
        EditButton.DropDownMenu = PreferencesForm.AddressPopupMenu
      end
    end
    object gbAccountDetails: TSpTBXGroupBox
      Left = 16
      Top = 120
      Width = 345
      Height = 105
      Caption = 'Account details'
      TabOrder = 2
      TBXStyleBackground = True
      object lblLogin: TSpTBXLabel
        Left = 16
        Top = 24
        Width = 54
        Height = 13
        Caption = 'Username :'
      end
      object txtLogin: TSpTBXEdit
        Left = 152
        Top = 24
        Width = 185
        Height = 21
        TabOrder = 1
        OnKeyPress = txtLoginKeyPress
      end
      object txtPassword: TSpTBXEdit
        Left = 152
        Top = 48
        Width = 185
        Height = 21
        TabOrder = 2
        OnChange = txtPasswordChange
        OnKeyPress = txtPasswordKeyPress
        PasswordCharW = '*'
      end
      object lblPassword: TSpTBXLabel
        Left = 16
        Top = 48
        Width = 52
        Height = 13
        Caption = 'Password :'
      end
      object chkRememberPasswords: TSpTBXCheckBox
        Left = 152
        Top = 72
        Width = 117
        Height = 15
        Caption = 'remember passwords'
        TabOrder = 4
      end
    end
    object btRegister: TSpTBXButton
      Left = 16
      Top = 248
      Width = 169
      Height = 25
      Caption = 'Register'
      TabOrder = 3
      OnClick = btRegisterClick
    end
    object btLogin: TSpTBXButton
      Left = 192
      Top = 248
      Width = 169
      Height = 57
      Caption = 'Login'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = btLoginClick
      Images = MainForm.ConnectionStateImageList
      ImageIndex = 0
    end
    object chkUseLogonForm: TSpTBXCheckBox
      Left = 16
      Top = 282
      Width = 89
      Height = 15
      Caption = 'Use logon form'
      TabOrder = 5
    end
  end
end
