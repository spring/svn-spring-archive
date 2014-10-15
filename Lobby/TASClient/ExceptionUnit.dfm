object ExceptionDialog: TExceptionDialog
  Tag = 1
  Left = 1353
  Top = 181
  ActiveControl = OkBtn
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'ExceptionDialog'
  ClientHeight = 284
  ClientWidth = 513
  Color = clBtnFace
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    513
    284)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 3
    Top = 91
    Width = 509
    Height = 9
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 8
    Top = 104
    Width = 393
    Height = 13
    Caption = 
      'Please send us this crash report and so help us improve the prog' +
      'ram!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object OkBtn: TButton
    Left = 392
    Top = 4
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object DetailsMemo: TMemo
    Left = 4
    Top = 128
    Width = 505
    Height = 154
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    WantReturns = False
    WordWrap = False
  end
  object DetailsBtn: TButton
    Left = 392
    Top = 60
    Width = 116
    Height = 25
    Hint = 'Show or hide additional information|'
    Anchors = [akTop, akRight]
    Caption = '&Details'
    Enabled = False
    TabOrder = 2
    OnClick = DetailsBtnClick
  end
  object TextLabel: TMemo
    Left = 56
    Top = 8
    Width = 291
    Height = 75
    Hint = 'Use Ctrl+C to copy the report to the clipboard'
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    Ctl3D = True
    Lines.Strings = (
      'TextLabel')
    ParentColor = True
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    WantReturns = False
  end
  object SendBtn: TButton
    Left = 392
    Top = 32
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Send report'
    TabOrder = 4
    OnClick = SendBtnClick
  end
end
