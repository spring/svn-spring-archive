object NotificationsForm: TNotificationsForm
  Left = 298
  Top = 231
  BorderStyle = bsDialog
  Caption = 'Notification Manager'
  ClientHeight = 236
  ClientWidth = 322
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 71
    Height = 13
    Caption = 'Notification list:'
  end
  object SpeedButton1: TSpeedButton
    Left = 240
    Top = 24
    Width = 65
    Height = 22
    Caption = 'Add'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 240
    Top = 48
    Width = 65
    Height = 22
    Caption = 'Remove'
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 240
    Top = 72
    Width = 65
    Height = 22
    Caption = 'Clear'
    OnClick = SpeedButton3Click
  end
  object Button1: TButton
    Left = 120
    Top = 200
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 0
    OnClick = Button1Click
  end
  object NotificationListBox: TListBox
    Left = 16
    Top = 24
    Width = 217
    Height = 137
    ItemHeight = 13
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 168
    Width = 209
    Height = 17
    Caption = 'Notify on private messages'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
end
