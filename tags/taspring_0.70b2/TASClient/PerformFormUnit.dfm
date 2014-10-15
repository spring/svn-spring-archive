object PerformForm: TPerformForm
  Left = 305
  Top = 281
  BorderStyle = bsDialog
  Caption = 'Perform'
  ClientHeight = 332
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 361
    Height = 41
    AutoSize = False
    Caption = 
      'Here you can add commands you want to be performed upon connecti' +
      'ng to the server (e.g. /join #mychannel, etc.)'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 216
    Width = 50
    Height = 13
    Caption = 'Command:'
  end
  object SpeedButton1: TSpeedButton
    Left = 336
    Top = 232
    Width = 49
    Height = 22
    Caption = 'Add'
    OnClick = SpeedButton1Click
  end
  object Label3: TLabel
    Left = 8
    Top = 264
    Width = 215
    Height = 13
    Caption = '(To remove item, select it and press DELETE)'
  end
  object CommandsListBox: TJvListBox
    Left = 8
    Top = 64
    Width = 377
    Height = 137
    ItemHeight = 13
    Background.FillMode = bfmTile
    Background.Visible = False
    TabOrder = 0
    OnKeyUp = CommandsListBoxKeyUp
  end
  object CmdEdit: TEdit
    Left = 8
    Top = 232
    Width = 329
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 144
    Top = 296
    Width = 105
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = Button1Click
  end
end
