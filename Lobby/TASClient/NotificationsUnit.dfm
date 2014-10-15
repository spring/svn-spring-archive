object NotificationsForm: TNotificationsForm
  Left = 950
  Top = 618
  BorderStyle = bsDialog
  Caption = 'Notification Manager'
  ClientHeight = 272
  ClientWidth = 320
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 320
    Height = 272
    Caption = 'Notification Manager'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object Label1: TSpTBXLabel
      Left = 16
      Top = 40
      Width = 71
      Height = 13
      Caption = 'Notification list:'
    end
    object SpeedButton1: TSpTBXSpeedButton
      Left = 240
      Top = 56
      Width = 65
      Height = 22
      Caption = 'Add'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpTBXSpeedButton
      Left = 240
      Top = 80
      Width = 65
      Height = 22
      Caption = 'Remove'
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpTBXSpeedButton
      Left = 240
      Top = 104
      Width = 65
      Height = 22
      Caption = 'Clear'
      OnClick = SpeedButton3Click
    end
    object Button1: TSpTBXButton
      Left = 120
      Top = 232
      Width = 81
      Height = 25
      Caption = 'Close'
      TabOrder = 5
      OnClick = Button1Click
      Cancel = True
    end
    object NotificationListBox: TSpTBXListBox
      Left = 16
      Top = 56
      Width = 217
      Height = 137
      ItemHeight = 13
      TabOrder = 6
    end
    object CheckBox1: TSpTBXCheckBox
      Left = 16
      Top = 200
      Width = 145
      Height = 15
      Caption = 'Notify on private messages'
      TabOrder = 7
      Checked = True
      State = cbChecked
    end
  end
end
