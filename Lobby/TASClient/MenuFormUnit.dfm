object MenuForm: TMenuForm
  Left = 939
  Top = 218
  BorderStyle = bsNone
  Caption = 'TASClient SP'
  ClientHeight = 671
  ClientWidth = 907
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Minimap: TImage
    Left = 24
    Top = 40
    Width = 73
    Height = 97
    Visible = False
  end
  object MP1: TMediaPlayer
    Left = 184
    Top = 176
    Width = 253
    Height = 33
    Visible = False
    TabOrder = 0
  end
  object MP2: TMediaPlayer
    Left = 184
    Top = 216
    Width = 253
    Height = 33
    Visible = False
    TabOrder = 1
  end
  object GameTimer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = GameTimerTimer
    Left = 560
    Top = 428
  end
  object tmrMusic: TTimer
    Interval = 500
    OnTimer = tmrMusicTimer
    Left = 88
    Top = 112
  end
  object SevenZip1: TSevenZip
    SFXCreate = False
    SFXModule = '7z.sfx'
    AddOptions = []
    ExtractOptions = []
    LZMACompressType = LZMA
    LZMACompressStrength = SAVE
    LZMAStrength = 0
    LPPMDmem = 0
    LPPMDsize = 0
    NumberOfFiles = -1
    VolumeSize = 0
    Left = 176
    Top = 304
  end
end
