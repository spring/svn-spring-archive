object UploadReplayForm: TUploadReplayForm
  Left = 500
  Top = 334
  Width = 486
  Height = 354
  Caption = 'Upload replay'
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
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 478
    Height = 327
    Caption = 'Upload replay'
    Active = False
    FixedSize = True
    Options.Maximize = False
    object SpTBXGroupBox1: TSpTBXGroupBox
      Left = 16
      Top = 24
      Width = 449
      Height = 233
      Caption = 'Upload Description'
      TabOrder = 1
      object DescriptionRtBox: TRichEdit
        Left = 8
        Top = 24
        Width = 433
        Height = 201
        TabOrder = 0
      end
    end
    object SpTBXGroupBox2: TSpTBXGroupBox
      Left = 16
      Top = 264
      Width = 449
      Height = 49
      Caption = 'Action'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object UploadButton: TSpTBXButton
        Left = 12
        Top = 16
        Width = 137
        Height = 25
        Caption = 'Upload && Keep'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = UploadButtonClick
      end
      object CancelButton: TSpTBXButton
        Left = 156
        Top = 16
        Width = 137
        Height = 25
        Caption = 'Keep'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = CancelButtonClick
      end
      object DeleteButton: TSpTBXButton
        Left = 300
        Top = 16
        Width = 137
        Height = 25
        Caption = 'Delete'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = DeleteButtonClick
      end
    end
  end
  object IdHTTP1: TIdHTTP
    MaxLineLength = 32768
    MaxLineAction = maException
    ReadTimeout = 0
    RecvBufferSize = 65536
    SendBufferSize = 65536
    OnWork = IdHTTP1Work
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 480
    Top = 208
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 56
    Top = 120
  end
end
