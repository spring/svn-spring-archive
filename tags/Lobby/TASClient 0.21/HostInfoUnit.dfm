object HostInfoForm: THostInfoForm
  Left = 374
  Top = 294
  BorderStyle = bsDialog
  Caption = 'Help'
  ClientHeight = 304
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 287
    Height = 15
    Caption = 'Important notes if you are hosting for the first time:'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 337
    Height = 33
    AutoSize = False
    Caption = 
      '* If you are behind a router, you must forward the port you spec' +
      'ified in the host battle dialog before hosting a game.'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label3: TLabel
    Left = 16
    Top = 200
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
  end
  object Label4: TLabel
    Left = 16
    Top = 96
    Width = 337
    Height = 33
    AutoSize = False
    Caption = 
      '* if you are behind a firewall, make sure it doesn'#39't block TASCl' +
      'ient.exe or spring.exe before launching game.'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 16
    Top = 224
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
  end
  object Label6: TLabel
    Left = 16
    Top = 144
    Width = 321
    Height = 33
    AutoSize = False
    Caption = 
      '* Consider reading FAQ page at official Spring web site if you c' +
      'an'#39't resolve your hosting problems (see link bellow).'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Button1: TButton
    Left = 144
    Top = 264
    Width = 83
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 0
    OnClick = Button1Click
  end
end
