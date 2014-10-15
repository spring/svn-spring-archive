object PerformForm: TPerformForm
  Left = 305
  Top = 281
  BorderStyle = bsDialog
  Caption = 'Perform'
  ClientHeight = 358
  ClientWidth = 397
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
    Width = 397
    Height = 358
    Caption = 'Perform'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object Label1: TSpTBXLabel
      Left = 16
      Top = 40
      Width = 361
      Height = 41
      Caption = 
        'Here you can add commands you want to be performed upon connecti' +
        'ng to the server (e.g. /join #mychannel, etc.)'
      AutoSize = False
      Wrapping = twWrap
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label2: TSpTBXLabel
      Left = 8
      Top = 240
      Width = 50
      Height = 13
      Caption = 'Command:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpeedButton1: TSpTBXSpeedButton
      Left = 336
      Top = 256
      Width = 49
      Height = 22
      Caption = 'Add'
      OnClick = SpeedButton1Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label3: TSpTBXLabel
      Left = 8
      Top = 288
      Width = 215
      Height = 13
      Caption = '(To remove item, select it and press DELETE)'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object CommandsListBox: TSpTBXListBox
      Left = 8
      Top = 88
      Width = 377
      Height = 137
      ItemHeight = 13
      TabOrder = 5
      OnKeyUp = CommandsListBoxKeyUp
    end
    object CmdEdit: TSpTBXEdit
      Left = 8
      Top = 256
      Width = 329
      Height = 21
      TabOrder = 6
    end
    object Button1: TSpTBXButton
      Left = 144
      Top = 320
      Width = 105
      Height = 25
      Caption = 'Close'
      TabOrder = 7
      OnClick = Button1Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
