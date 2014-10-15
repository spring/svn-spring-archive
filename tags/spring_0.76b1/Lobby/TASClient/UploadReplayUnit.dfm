object UploadReplayForm: TUploadReplayForm
  Left = 586
  Top = 410
  Width = 410
  Height = 328
  Caption = 'UploadReplayForm'
  Color = clBtnFace
  Constraints.MaxHeight = 908
  Constraints.MaxWidth = 1280
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 402
    Height = 301
    Caption = 'Upload replay'
    Options.Maximize = False
    object SpTBXLabel1: TSpTBXLabel
      Left = 16
      Top = 32
      Width = 26
      Height = 13
      Caption = 'Title :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 16
      Top = 64
      Width = 59
      Height = 13
      Caption = 'Description :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object CancelButton: TSpTBXButton
      Left = 213
      Top = 264
      Width = 73
      Height = 25
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = CancelButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object UploadButton: TSpTBXButton
      Left = 117
      Top = 264
      Width = 73
      Height = 25
      Caption = 'Upload'
      TabOrder = 4
      OnClick = UploadButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object DescriptionRtBox: TRichEdit
      Left = 88
      Top = 64
      Width = 305
      Height = 193
      Lines.Strings = (
        'DescriptionRtBox')
      TabOrder = 5
    end
    object TitleEdit: TSpTBXEdit
      Left = 88
      Top = 32
      Width = 305
      Height = 21
      TabOrder = 6
    end
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
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
    Left = 408
    Top = 208
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 24
    Top = 112
  end
end
