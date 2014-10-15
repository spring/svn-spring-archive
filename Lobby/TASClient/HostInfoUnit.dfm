object HostInfoForm: THostInfoForm
  Left = 1185
  Top = 563
  Width = 592
  Height = 435
  Caption = 'Help'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 584
    Height = 408
    Caption = 'Help'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
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
    end
    object Label2: TSpTBXLabel
      Left = 16
      Top = 128
      Width = 553
      Height = 49
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
    end
    object Label3: TSpTBXLabel
      Left = 16
      Top = 320
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
    object Label4: TSpTBXLabel
      Left = 16
      Top = 192
      Width = 553
      Height = 57
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
    end
    object Label5: TSpTBXLabel
      Left = 16
      Top = 344
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
    object Label6: TSpTBXLabel
      Left = 16
      Top = 248
      Width = 553
      Height = 57
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
    end
    object Button1: TSpTBXButton
      Left = 250
      Top = 368
      Width = 83
      Height = 25
      Caption = 'Close'
      TabOrder = 7
      OnClick = Button1Click
      Cancel = True
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 16
      Top = 64
      Width = 553
      Height = 57
      Caption = 
        '* If you can'#39't host because you are behind a rooter and can'#39't fo' +
        'rward the port and NAT traversal doesn'#39't work, you can relay the' +
        ' hosting throw an automated host'
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Wrapping = twWrap
    end
  end
end
