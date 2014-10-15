object LoginProgressForm: TLoginProgressForm
  Left = 399
  Top = 343
  BorderStyle = bsDialog
  Caption = 'Logging in to the server ...'
  ClientHeight = 93
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 298
    Height = 93
    Caption = 'Logging in to the server ...'
    FixedSize = True
    Options.Close = False
    Options.Minimize = False
    Options.Maximize = False
    Options.SystemMenu = False
    TBXStyleBackground = True
    DesignSize = (
      298
      93)
    object ProgressLabel: TSpTBXLabel
      Left = 68
      Top = 48
      Width = 150
      Height = 16
      Caption = 'Logging in to the server ...'
      Anchors = [akTop]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
