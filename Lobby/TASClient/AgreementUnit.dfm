object AgreementForm: TAgreementForm
  Left = 447
  Top = 119
  Width = 592
  Height = 478
  BorderIcons = []
  Caption = 'Agreement'
  Color = clBtnFace
  Constraints.MaxHeight = 750
  Constraints.MaxWidth = 1280
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 584
    Height = 451
    Caption = 'Agreement'
    Active = False
    FixedSize = True
    Options.Close = False
    Options.Minimize = False
    Options.Maximize = False
    Options.SystemMenu = False
    object RadioButton1: TSpTBXRadioButton
      Left = 16
      Top = 352
      Width = 288
      Height = 15
      Caption = 'I have read the agreement and agree to the above terms.'
      TabOrder = 1
    end
    object RadioButton2: TSpTBXRadioButton
      Left = 16
      Top = 376
      Width = 156
      Height = 15
      Caption = 'I do not agree to these terms.'
      TabOrder = 2
      TabStop = True
      Checked = True
    end
    object Button1: TSpTBXButton
      Left = 224
      Top = 416
      Width = 137
      Height = 25
      Caption = 'Continue'
      TabOrder = 3
      OnClick = Button1Click
    end
    object RichEdit1: TExRichEdit
      Left = 8
      Top = 40
      Width = 569
      Height = 297
      AutoURLDetect = adNone
      CustomURLs = <
        item
          Name = 'e-mail'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'http'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'file'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'mailto'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'ftp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'https'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'gopher'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'nntp'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'prospero'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'telnet'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'news'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end
        item
          Name = 'wais'
          Color = clWindowText
          Cursor = crDefault
          Underline = True
        end>
      LangOptions = [loAutoFont]
      Language = 1036
      ReadOnly = True
      ScrollBars = ssVertical
      ShowSelectionBar = False
      TabOrder = 4
      URLColor = clBlue
      URLCursor = crHandPoint
      InputFormat = ifRTF
      OutputFormat = ofRTF
      SelectedInOut = False
      PlainRTF = True
      UndoLimit = 0
      AllowInPlace = False
    end
  end
end
