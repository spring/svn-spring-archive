object HttpGetForm: THttpGetForm
  Left = 387
  Top = 319
  BorderStyle = bsDialog
  Caption = 'File download'
  ClientHeight = 156
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
  object CancelButton: TSpeedButton
    Left = 168
    Top = 80
    Width = 97
    Height = 22
    Caption = 'Cancel download'
    Enabled = False
    OnClick = CancelButtonClick
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 33
    Height = 13
    Caption = 'Status:'
  end
  object StatusLabel: TLabel
    Left = 56
    Top = 16
    Width = 6
    Height = 13
    Caption = '?'
  end
  object ReceivedLabel: TLabel
    Left = 16
    Top = 80
    Width = 72
    Height = 13
    Caption = 'Received 0 KB'
  end
  object Label2: TLabel
    Left = 16
    Top = 32
    Width = 47
    Height = 13
    Caption = 'FileName:'
  end
  object FileNameLabel: TLabel
    Left = 72
    Top = 32
    Width = 6
    Height = 13
    Caption = '?'
  end
  object ProgressBar: TProgressBar
    Left = 16
    Top = 56
    Width = 249
    Height = 16
    Smooth = True
    TabOrder = 0
  end
  object CloseButton: TButton
    Left = 104
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Enabled = False
    TabOrder = 1
    OnClick = CloseButtonClick
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
