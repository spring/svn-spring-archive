object SpringDownloaderForm: TSpringDownloaderForm
  Left = 1218
  Top = 634
  Width = 429
  Height = 153
  Caption = 'Downloading ...'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 421
    Height = 126
    Caption = 'Downloading ...'
    Active = False
    Options.Maximize = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 421
      Height = 104
      Align = alClient
      TabOrder = 1
      BorderType = pbrFramed
      TBXStyleBackground = True
      DesignSize = (
        421
        104)
      object lblInfo: TSpTBXLabel
        Left = 8
        Top = 8
        Width = 163
        Height = 13
        Caption = 'Retreiving download information ...'
      end
      object ProgressBar: TSpTBXProgressBar
        Left = 8
        Top = 32
        Width = 407
        Height = 8
        Caption = '0%'
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        CaptionGlow = gldBottomRight
        CaptionGlowColor = clBlack
        Smooth = True
      end
      object lblRemainingTime: TSpTBXLabel
        Left = 8
        Top = 49
        Width = 93
        Height = 13
        Caption = 'Remaining time : ??'
        Anchors = [akLeft, akBottom]
      end
      object lblProgress: TSpTBXLabel
        Left = 8
        Top = 65
        Width = 62
        Height = 13
        Caption = 'Progress : ??'
        Anchors = [akLeft, akBottom]
      end
      object joinBattleCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 81
        Width = 195
        Height = 15
        Caption = 'Join battle after download is complete'
        Anchors = [akLeft, akBottom]
        TabOrder = 4
        Visible = False
      end
      object PauseResumeButton: TSpTBXButton
        Left = 312
        Top = 48
        Width = 105
        Height = 21
        Caption = 'Pause'
        Anchors = [akRight, akBottom]
        Enabled = False
        TabOrder = 6
        OnClick = PauseResumeButtonClick
      end
      object CancelButton: TSpTBXButton
        Left = 312
        Top = 72
        Width = 105
        Height = 25
        Caption = 'Cancel'
        Anchors = [akRight, akBottom]
        TabOrder = 5
        OnClick = CancelButtonClick
      end
    end
  end
  object tmrProgress: TTimer
    Enabled = False
    Interval = 300
    OnTimer = tmrProgressTimer
    Left = 296
    Top = 32
  end
  object tmrTimeout: TTimer
    Enabled = False
    OnTimer = tmrTimeoutTimer
    Left = 328
    Top = 32
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
    OnDocBegin = HttpCli1DocBegin
    OnDocData = HttpCli1DocData
    SocksAuthentication = socksNoAuthentication
    Left = 296
    Top = 104
  end
  object MultisourceHttpDownloader1: TMultisourceHttpDownloader
    PartCount = 0
    ServerAuth = httpAuthNone
    ProxyAuth = httpAuthNone
    OnDisplay = MultisourceHttpDownloader1Display
    OnRequestDone = MultisourceHttpDownloader1RequestDone
    Left = 264
    Top = 104
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
    Left = 232
    Top = 78
  end
end
