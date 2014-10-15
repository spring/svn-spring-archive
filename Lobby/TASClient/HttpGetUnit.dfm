object HttpGetForm: THttpGetForm
  Left = 895
  Top = 662
  Width = 406
  Height = 164
  Caption = 'File download 4'
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 398
    Height = 137
    Caption = 'File download'
    Active = False
    Options.Minimize = False
    Options.Maximize = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 398
      Height = 115
      Caption = 'pnlMain'
      Align = alClient
      TabOrder = 1
      Borders = False
      TBXStyleBackground = True
      DesignSize = (
        398
        115)
      object Label1: TSpTBXLabel
        Left = 16
        Top = 8
        Width = 33
        Height = 13
        Caption = 'Status:'
      end
      object StatusLabel: TSpTBXLabel
        Left = 112
        Top = 8
        Width = 6
        Height = 13
        Caption = '?'
      end
      object Label2: TSpTBXLabel
        Left = 16
        Top = 24
        Width = 47
        Height = 13
        Caption = 'FileName:'
      end
      object FileNameLabel: TSpTBXLabel
        Left = 112
        Top = 24
        Width = 6
        Height = 13
        Caption = '?'
      end
      object ProgressBar: TSpTBXProgressBar
        Left = 16
        Top = 48
        Width = 367
        Height = 28
        Caption = '0%'
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        CaptionGlow = gldBottomRight
        CaptionGlowColor = clBlack
        Smooth = True
      end
      object ReceivedLabel: TSpTBXLabel
        Left = 16
        Top = 78
        Width = 72
        Height = 13
        Caption = 'Received 0 KB'
        Anchors = [akLeft, akBottom]
      end
      object CancelButton: TSpTBXSpeedButton
        Left = 208
        Top = 81
        Width = 175
        Height = 26
        Caption = 'Cancel download'
        Anchors = [akRight, akBottom]
        Enabled = False
        OnClick = CancelButtonClick
      end
    end
  end
  object HttpCli1: THttpCli
    LocalAddr = '0.0.0.0'
    ProxyPort = '80'
    Agent = 'Mozilla/4.0 (compatible; ICS)'
    Accept = 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*'
    NoCache = False
    ContentTypePost = 'application/x-www-form-urlencoded'
    MultiThreaded = False
    RequestVer = '1.0'
    FollowRelocation = True
    LocationChangeMaxCount = 5
    ServerAuth = httpAuthNone
    ProxyAuth = httpAuthNone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Options = []
    OnHeaderData = HttpCli1HeaderData
    OnDocBegin = HttpCli1DocBegin
    OnDocData = HttpCli1DocData
    SocksAuthentication = socksNoAuthentication
    Left = 120
    Top = 120
  end
  object SevenZip1: TSevenZip
    SFXCreate = False
    SFXModule = '7z.sfx'
    AddOptions = []
    ExtractOptions = [ExtractOverwrite]
    LZMACompressType = LZMA
    LZMACompressStrength = SAVE
    LZMAStrength = 0
    LPPMDmem = 0
    LPPMDsize = 0
    NumberOfFiles = -1
    VolumeSize = 0
    Left = 288
    Top = 32
  end
end
