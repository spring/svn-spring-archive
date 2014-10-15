object HttpGetForm: THttpGetForm
  Left = 387
  Top = 319
  BorderStyle = bsDialog
  Caption = 'File download'
  ClientHeight = 178
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
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
    Width = 281
    Height = 178
    Caption = 'File download'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object CancelButton: TSpTBXSpeedButton
      Left = 168
      Top = 104
      Width = 97
      Height = 22
      Caption = 'Cancel download'
      Enabled = False
      OnClick = CancelButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label1: TSpTBXLabel
      Left = 16
      Top = 40
      Width = 33
      Height = 13
      Caption = 'Status:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object StatusLabel: TSpTBXLabel
      Left = 56
      Top = 40
      Width = 6
      Height = 13
      Caption = '?'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object ReceivedLabel: TSpTBXLabel
      Left = 16
      Top = 104
      Width = 72
      Height = 13
      Caption = 'Received 0 KB'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label2: TSpTBXLabel
      Left = 16
      Top = 56
      Width = 47
      Height = 13
      Caption = 'FileName:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object FileNameLabel: TSpTBXLabel
      Left = 72
      Top = 56
      Width = 6
      Height = 13
      Caption = '?'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object CloseButton: TSpTBXButton
      Left = 104
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Close'
      Enabled = False
      TabOrder = 7
      OnClick = CloseButtonClick
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object ProgressBar: TSpTBXProgressBar
      Left = 16
      Top = 80
      Width = 249
      Height = 17
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      CaptionGlow = False
      Smooth = True
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
    Options = []
    OnHeaderData = HttpCli1HeaderData
    OnDocBegin = HttpCli1DocBegin
    OnDocData = HttpCli1DocData
    SocksAuthentication = socksNoAuthentication
    Left = 208
    Top = 120
  end
end
