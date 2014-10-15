object DebugForm: TDebugForm
  Left = 884
  Top = 138
  BorderStyle = bsDialog
  Caption = 'Debug options'
  ClientHeight = 296
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 83
    Top = 256
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 16
    Width = 297
    Height = 17
    Caption = 'Enable debug mode'
    TabOrder = 1
  end
  object CheckBox2: TCheckBox
    Left = 24
    Top = 40
    Width = 297
    Height = 17
    Caption = 'Filter ping-pong in debug mode'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 171
    Top = 256
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 176
    Width = 209
    Height = 58
    Caption = 'Traffic (cumulative)'
    TabOrder = 4
    object Label2: TLabel
      Left = 8
      Top = 36
      Width = 53
      Height = 13
      Caption = 'Data recv.:'
    end
    object Label1: TLabel
      Left = 8
      Top = 19
      Width = 49
      Height = 13
      Caption = 'Data sent:'
    end
    object DataSentLabel: TLabel
      Left = 112
      Top = 19
      Width = 34
      Height = 13
      Caption = '0 bytes'
    end
    object DataReceivedLabel: TLabel
      Left = 112
      Top = 36
      Width = 34
      Height = 13
      Caption = '0 bytes'
    end
  end
  object CheckBox3: TCheckBox
    Left = 24
    Top = 64
    Width = 305
    Height = 17
    Caption = 'Ignore server version incompatibility'
    TabOrder = 5
  end
  object CheckBox4: TCheckBox
    Left = 24
    Top = 88
    Width = 297
    Height = 17
    Caption = 'Login with password on lan server'
    TabOrder = 6
  end
  object CheckBox5: TCheckBox
    Left = 24
    Top = 112
    Width = 297
    Height = 17
    Caption = 'Ignore redirects'
    TabOrder = 7
  end
  object Button3: TButton
    Left = 24
    Top = 136
    Width = 209
    Height = 25
    Caption = 'Open debug script form'
    TabOrder = 8
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'LUA script|*.lua'
    Left = 280
    Top = 224
  end
  object TrafficTimer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TrafficTimerTimer
    Left = 16
    Top = 224
  end
end
