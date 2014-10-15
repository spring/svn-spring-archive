object RapidDownloaderForm: TRapidDownloaderForm
  Left = 666
  Top = 212
  Width = 514
  Height = 545
  Caption = 'Rapid Downloader'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 506
    Height = 518
    Caption = 'Rapid Downloader'
    DesignSize = (
      506
      518)
    object DownloadListBox: TSpTBXListBox
      Left = 8
      Top = 56
      Width = 481
      Height = 409
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 16
      TabOrder = 1
      OnDblClick = DownloadListBoxDblClick
    end
    object FilterTextBox: TSpTBXEdit
      Left = 8
      Top = 32
      Width = 393
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      Text = ':stable|:latest'
      OnKeyPress = FilterTextBoxKeyPress
    end
    object ResultsLabel: TSpTBXLabel
      Left = 8
      Top = 470
      Width = 483
      Height = 13
      Caption = '0 results'
      Anchors = [akRight, akBottom]
      AutoSize = False
      Alignment = taRightJustify
    end
    object UpdateListButton: TSpTBXButton
      Left = 408
      Top = 32
      Width = 81
      Height = 21
      Caption = 'Update'
      Anchors = [akTop, akRight]
      TabOrder = 4
      OnClick = UpdateListButtonClick
    end
    object DownloadButton: TSpTBXButton
      Left = 8
      Top = 488
      Width = 481
      Height = 25
      Caption = 'Download'
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 5
      OnClick = DownloadButtonClick
    end
  end
end
