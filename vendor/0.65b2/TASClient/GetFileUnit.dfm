object GetFileForm: TGetFileForm
  Left = 433
  Top = 273
  BorderStyle = bsDialog
  Caption = 'Get file dialog'
  ClientHeight = 235
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 45
    Height = 13
    Caption = 'Filename:'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 23
    Height = 13
    Caption = 'Size:'
  end
  object FilenameLabel: TLabel
    Left = 72
    Top = 24
    Width = 68
    Height = 13
    Caption = 'FilenameLabel'
  end
  object SizeLabel: TLabel
    Left = 72
    Top = 48
    Width = 46
    Height = 13
    Caption = 'SizeLabel'
  end
  object Label3: TLabel
    Left = 32
    Top = 88
    Width = 44
    Height = 13
    Caption = 'Progress:'
  end
  object ProgressLabel: TLabel
    Left = 144
    Top = 136
    Width = 67
    Height = 13
    Caption = 'ProgressLabel'
  end
  object Label4: TLabel
    Left = 16
    Top = 168
    Width = 33
    Height = 13
    Caption = 'Status:'
  end
  object StatusLabel: TLabel
    Left = 56
    Top = 168
    Width = 56
    Height = 13
    Caption = 'StatusLabel'
  end
  object CloseButton: TButton
    Left = 136
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = CloseButtonClick
  end
  object DownloadProgressBar: TProgressBar
    Left = 32
    Top = 112
    Width = 281
    Height = 16
    Smooth = True
    TabOrder = 1
  end
  object CancelButton: TButton
    Left = 208
    Top = 16
    Width = 105
    Height = 25
    Caption = 'Cancel transfer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = CancelButtonClick
  end
end
