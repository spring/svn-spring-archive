object NewAccountForm: TNewAccountForm
  Left = 1117
  Top = 802
  BorderStyle = bsDialog
  Caption = 'Create new account'
  ClientHeight = 199
  ClientWidth = 303
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
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 303
    Height = 199
    Caption = 'Create new account'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object UsernameEdit: TSpTBXEdit
      Left = 168
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 8
      Top = 40
      Width = 155
      Height = 13
      Caption = 'Username:'
      AutoSize = False
      Alignment = taRightJustify
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 8
      Top = 64
      Width = 153
      Height = 13
      Caption = 'Password:'
      AutoSize = False
      Alignment = taRightJustify
    end
    object PasswordEdit: TSpTBXEdit
      Left = 168
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 4
      PasswordCharW = '*'
    end
    object SpTBXLabel3: TSpTBXLabel
      Left = 8
      Top = 88
      Width = 152
      Height = 13
      Caption = 'Re-type password:'
      AutoSize = False
      Alignment = taRightJustify
    end
    object ConfirmPasswordEdit: TSpTBXEdit
      Left = 168
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 6
      PasswordCharW = '*'
    end
    object RegisterButton: TSpTBXButton
      Left = 23
      Top = 127
      Width = 257
      Height = 25
      Caption = '&Register account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = RegisterButtonClick
      CaptionGlowColor = clSkyBlue
    end
    object SpTBXButton1: TSpTBXButton
      Left = 23
      Top = 159
      Width = 257
      Height = 25
      Caption = '&Cancel'
      TabOrder = 8
      Cancel = True
      ModalResult = 2
    end
  end
end
