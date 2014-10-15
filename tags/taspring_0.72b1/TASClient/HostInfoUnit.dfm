object HostInfoForm: THostInfoForm
  Left = 374
  Top = 294
  BorderStyle = bsDialog
  Caption = 'Help'
  ClientHeight = 324
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 370
    Height = 324
    Caption = 'Help'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object Label1: TSpTBXLabel
      Left = 16
      Top = 40
      Width = 287
      Height = 15
      Caption = 'Important notes if you are hosting for the first time:'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label2: TSpTBXLabel
      Left = 16
      Top = 72
      Width = 337
      Height = 33
      Caption = 
        '* If you are behind a router, you must forward the port you spec' +
        'ified in the host battle dialog before hosting a game.'
      AutoSize = False
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Wrapping = twWrap
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label3: TSpTBXLabel
      Left = 16
      Top = 224
      Width = 172
      Height = 13
      Cursor = crHandPoint
      Caption = 'How do I configure my router?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = Label3Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label4: TSpTBXLabel
      Left = 16
      Top = 120
      Width = 337
      Height = 33
      Caption = 
        '* if you are behind a firewall, make sure it doesn'#39't block TASCl' +
        'ient.exe or spring.exe before launching game.'
      AutoSize = False
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Wrapping = twWrap
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label5: TSpTBXLabel
      Left = 16
      Top = 248
      Width = 156
      Height = 13
      Cursor = crHandPoint
      Caption = 'Frequently asked questions'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = Label5Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label6: TSpTBXLabel
      Left = 16
      Top = 168
      Width = 321
      Height = 33
      Caption = 
        '* Consider reading FAQ page at official Spring web site if you c' +
        'an'#39't resolve your hosting problems (see link bellow).'
      AutoSize = False
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Wrapping = twWrap
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Button1: TSpTBXButton
      Left = 144
      Top = 288
      Width = 83
      Height = 25
      Caption = 'Close'
      TabOrder = 7
      OnClick = Button1Click
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
