object NewAccountForm: TNewAccountForm
  Left = 519
  Top = 493
  BorderStyle = bsDialog
  Caption = 'Create new account'
  ClientHeight = 199
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 268
    Height = 199
    Caption = 'Create new account'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object UsernameEdit: TSpTBXEdit
      Left = 120
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 56
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
    object SpTBXLabel2: TSpTBXLabel
      Left = 56
      Top = 64
      Width = 49
      Height = 13
      Caption = 'Password:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object PasswordEdit: TSpTBXEdit
      Left = 120
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 4
      PasswordCharW = '*'
    end
    object SpTBXLabel3: TSpTBXLabel
      Left = 16
      Top = 88
      Width = 88
      Height = 13
      Caption = 'Re-type password:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object ConfirmPasswordEdit: TSpTBXEdit
      Left = 120
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 6
      PasswordCharW = '*'
    end
    object RegisterButton: TSpTBXButton
      Left = 24
      Top = 128
      Width = 217
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
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXButton1: TSpTBXButton
      Left = 24
      Top = 160
      Width = 217
      Height = 25
      Caption = '&Cancel'
      TabOrder = 8
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
      ModalResult = 2
    end
  end
end
