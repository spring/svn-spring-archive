object ColorPickerForm: TColorPickerForm
  Left = 453
  Top = 132
  BorderStyle = bsDialog
  Caption = 'ColorPickerForm'
  ClientHeight = 387
  ClientWidth = 497
  Color = clBtnFace
  Constraints.MaxHeight = 1000
  Constraints.MaxWidth = 1680
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
    Width = 497
    Height = 387
    Caption = 'Color Picker'
    Options.Minimize = False
    Options.Maximize = False
    object Bevel2: TBevel
      Left = 335
      Top = 39
      Width = 28
      Height = 303
    end
    object SndGradiant: TImage
      Left = 336
      Top = 40
      Width = 25
      Height = 300
      Cursor = crVSplit
      OnMouseDown = SndGradiantMouseDown
      OnMouseMove = SndGradiantMouseMove
      OnMouseUp = SndGradiantMouseUp
    end
    object Bevel1: TBevel
      Left = 15
      Top = 39
      Width = 303
      Height = 303
    end
    object MainGradiant: TImage
      Left = 16
      Top = 40
      Width = 300
      Height = 300
      Cursor = crCross
      Proportional = True
      OnMouseDown = MainGradiantMouseDown
      OnMouseMove = MainGradiantMouseMove
      OnMouseUp = MainGradiantMouseUp
    end
    object rdH: TSpTBXRadioButton
      Left = 392
      Top = 106
      Width = 32
      Height = 15
      Caption = 'H :'
      Enabled = False
      TabOrder = 1
      TabStop = True
      Checked = True
    end
    object rdS: TSpTBXRadioButton
      Left = 392
      Top = 130
      Width = 31
      Height = 15
      Caption = 'S :'
      Enabled = False
      TabOrder = 2
    end
    object rdL: TSpTBXRadioButton
      Left = 392
      Top = 154
      Width = 30
      Height = 15
      Caption = 'L :'
      Enabled = False
      TabOrder = 3
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 472
      Top = 104
      Width = 5
      Height = 20
      Caption = #176
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 472
      Top = 128
      Width = 12
      Height = 16
      Caption = '%'
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
    object SpTBXLabel3: TSpTBXLabel
      Left = 472
      Top = 152
      Width = 12
      Height = 16
      Caption = '%'
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
    object SpTBXLabel4: TSpTBXLabel
      Left = 408
      Top = 194
      Width = 14
      Height = 13
      Caption = 'R :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel5: TSpTBXLabel
      Left = 408
      Top = 218
      Width = 14
      Height = 13
      Caption = 'G :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel6: TSpTBXLabel
      Left = 408
      Top = 242
      Width = 13
      Height = 13
      Caption = 'B :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel7: TSpTBXLabel
      Left = 402
      Top = 274
      Width = 16
      Height = 13
      Caption = '#'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsItalic]
      ParentFont = False
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object btDone: TSpTBXButton
      Left = 90
      Top = 352
      Width = 73
      Height = 25
      Caption = 'Done'
      TabOrder = 11
      OnClick = btDoneClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
      ModalResult = 1
      ThemeType = thtTBX
    end
    object btReset: TSpTBXButton
      Left = 321
      Top = 352
      Width = 145
      Height = 25
      Caption = 'Reset all colors to default'
      TabOrder = 12
      OnClick = btResetClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object txtH: TSpTBXEdit
      Left = 424
      Top = 104
      Width = 41
      Height = 21
      TabOrder = 13
      Text = 'txtH'
      OnKeyUp = txtHKeyUp
    end
    object txtS: TSpTBXEdit
      Left = 424
      Top = 128
      Width = 41
      Height = 21
      TabOrder = 14
      Text = 'txtS'
      OnKeyUp = txtSKeyUp
    end
    object txtL: TSpTBXEdit
      Left = 424
      Top = 152
      Width = 41
      Height = 21
      TabOrder = 15
      Text = 'txtL'
      OnKeyUp = txtLKeyUp
    end
    object txtR: TSpTBXEdit
      Left = 424
      Top = 192
      Width = 41
      Height = 21
      TabOrder = 16
      Text = 'txtR'
      OnKeyUp = txtRKeyUp
    end
    object txtG: TSpTBXEdit
      Left = 424
      Top = 216
      Width = 41
      Height = 21
      TabOrder = 17
      Text = 'txtG'
      OnKeyUp = txtGKeyUp
    end
    object txtB: TSpTBXEdit
      Left = 424
      Top = 240
      Width = 41
      Height = 21
      TabOrder = 18
      Text = 'txtB'
      OnKeyUp = txtBKeyUp
    end
    object txtColorHex: TSpTBXEdit
      Left = 416
      Top = 272
      Width = 49
      Height = 21
      TabOrder = 19
      Text = 'FFFFFF'
      OnKeyDown = txtColorHexKeyDown
    end
    object btCancel: TSpTBXButton
      Left = 168
      Top = 352
      Width = 81
      Height = 25
      Caption = 'Cancel'
      TabOrder = 20
      OnClick = btCancelClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
      ModalResult = 2
    end
  end
  object ColorPanel: TPanel
    Left = 384
    Top = 40
    Width = 81
    Height = 49
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clBlack
    TabOrder = 1
  end
  object ColorToolbar: TSpTBXToolbar
    Left = 376
    Top = 304
    Width = 90
    Height = 36
    Caption = 'ColorToolbar'
    TabOrder = 2
    object TBXColorPalette1: TTBXColorPalette
      ColorSet = BattleForm.TBXTeamColorSet
      PaletteOptions = []
      OnCellClick = TBXColorPalette1CellClick
    end
  end
end
