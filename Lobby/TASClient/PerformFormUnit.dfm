object PerformForm: TPerformForm
  Left = 1050
  Top = 557
  Width = 405
  Height = 385
  Caption = 'Perform'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 397
    Height = 358
    Caption = 'Perform'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
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
    end
    object Label2: TSpTBXLabel
      Left = 8
      Top = 240
      Width = 50
      Height = 13
      Caption = 'Command:'
    end
    object SpeedButton1: TSpTBXSpeedButton
      Left = 288
      Top = 256
      Width = 97
      Height = 22
      Caption = 'Add'
      OnClick = SpeedButton1Click
    end
    object Label3: TSpTBXLabel
      Left = 8
      Top = 288
      Width = 215
      Height = 13
      Caption = '(To remove item, select it and press DELETE)'
    end
    object CommandsListBox: TSpTBXListBox
      Left = 8
      Top = 88
      Width = 353
      Height = 137
      ItemHeight = 13
      TabOrder = 5
      OnKeyUp = CommandsListBoxKeyUp
    end
    object CmdEdit: TSpTBXEdit
      Left = 8
      Top = 256
      Width = 281
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
    end
    object UpButton: TSpTBXButton
      Left = 368
      Top = 88
      Width = 17
      Height = 65
      TabOrder = 8
      OnClick = UpButtonClick
      Bitmap.Data = {
        32010000424D3201000000000000360000002800000009000000090000000100
        180000000000FC000000120B0000120B00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000
        0000000000000000000000000000FFFFFF000000000000000000000000000000
        000000000000FFFFFF00FFFFFFFFFFFF000000000000000000000000000000FF
        FFFFFFFFFF00FFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFF
        FF00FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF00FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00}
      Images = MainForm.ArrowList
      ImageIndex = 0
    end
    object SpTBXButton1: TSpTBXButton
      Left = 368
      Top = 160
      Width = 17
      Height = 65
      TabOrder = 9
      OnClick = SpTBXButton1Click
      Images = MainForm.ArrowList
      ImageIndex = 1
    end
  end
end
