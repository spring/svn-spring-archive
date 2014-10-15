object ColorPickerForm: TColorPickerForm
  Left = 246
  Top = 230
  BorderStyle = bsDialog
  Caption = 'ColorPickerForm'
  ClientHeight = 398
  ClientWidth = 497
  Color = clBtnFace
  Constraints.MaxHeight = 998
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
    Height = 398
    Caption = 'Color Picker'
    Options.Minimize = False
    Options.Maximize = False
    object SpTBXPanel1: TSpTBXPanel
      Left = 8
      Top = 32
      Width = 481
      Height = 361
      Caption = 'SpTBXPanel1'
      TabOrder = 1
      Borders = False
      object Bevel1: TBevel
        Left = 7
        Top = 15
        Width = 303
        Height = 303
      end
      object Bevel2: TBevel
        Left = 327
        Top = 15
        Width = 28
        Height = 303
      end
      object MainGradiant: TImage
        Left = 8
        Top = 16
        Width = 300
        Height = 300
        Cursor = crCross
        Proportional = True
        OnMouseDown = MainGradiantMouseDown
        OnMouseMove = MainGradiantMouseMove
        OnMouseUp = MainGradiantMouseUp
      end
      object SndGradiant: TImage
        Left = 328
        Top = 16
        Width = 25
        Height = 300
        Cursor = crVSplit
        OnMouseDown = SndGradiantMouseDown
        OnMouseMove = SndGradiantMouseMove
        OnMouseUp = SndGradiantMouseUp
      end
      object rdH: TSpTBXRadioButton
        Left = 384
        Top = 82
        Width = 32
        Height = 15
        Caption = 'H :'
        Enabled = False
        TabOrder = 0
        TabStop = True
        Checked = True
      end
      object txtH: TSpTBXEdit
        Left = 416
        Top = 80
        Width = 41
        Height = 21
        TabOrder = 1
        Text = 'txtH'
        OnKeyUp = txtHKeyUp
      end
      object SpTBXLabel1: TSpTBXLabel
        Left = 464
        Top = 80
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
        Left = 461
        Top = 104
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
        Left = 461
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
      object txtS: TSpTBXEdit
        Left = 416
        Top = 104
        Width = 41
        Height = 21
        TabOrder = 5
        Text = 'txtS'
        OnKeyUp = txtSKeyUp
      end
      object rdS: TSpTBXRadioButton
        Left = 384
        Top = 106
        Width = 31
        Height = 15
        Caption = 'S :'
        Enabled = False
        TabOrder = 6
      end
      object rdL: TSpTBXRadioButton
        Left = 384
        Top = 130
        Width = 30
        Height = 15
        Caption = 'L :'
        Enabled = False
        TabOrder = 7
      end
      object txtL: TSpTBXEdit
        Left = 416
        Top = 128
        Width = 41
        Height = 21
        TabOrder = 8
        Text = 'txtL'
        OnKeyUp = txtLKeyUp
      end
      object SpTBXLabel4: TSpTBXLabel
        Left = 400
        Top = 170
        Width = 14
        Height = 13
        Caption = 'R :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object txtR: TSpTBXEdit
        Left = 416
        Top = 168
        Width = 41
        Height = 21
        TabOrder = 10
        Text = 'txtR'
        OnKeyUp = txtRKeyUp
      end
      object SpTBXLabel5: TSpTBXLabel
        Left = 400
        Top = 194
        Width = 14
        Height = 13
        Caption = 'G :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object txtG: TSpTBXEdit
        Left = 416
        Top = 192
        Width = 41
        Height = 21
        TabOrder = 12
        Text = 'txtG'
        OnKeyUp = txtGKeyUp
      end
      object SpTBXLabel6: TSpTBXLabel
        Left = 400
        Top = 218
        Width = 13
        Height = 13
        Caption = 'B :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object txtB: TSpTBXEdit
        Left = 416
        Top = 216
        Width = 41
        Height = 21
        TabOrder = 14
        Text = 'txtB'
        OnKeyUp = txtBKeyUp
      end
      object SpTBXLabel7: TSpTBXLabel
        Left = 394
        Top = 250
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
      object txtColorHex: TSpTBXEdit
        Left = 408
        Top = 248
        Width = 49
        Height = 21
        TabOrder = 16
        Text = 'FFFFFF'
        OnKeyDown = txtColorHexKeyDown
      end
      object btReset: TSpTBXButton
        Left = 313
        Top = 328
        Width = 145
        Height = 25
        Caption = 'Reset all colors to default'
        TabOrder = 17
        OnClick = btResetClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object btCancel: TSpTBXButton
        Left = 160
        Top = 328
        Width = 81
        Height = 25
        Caption = 'Cancel'
        TabOrder = 18
        OnClick = btCancelClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ModalResult = 2
      end
      object btDone: TSpTBXButton
        Left = 82
        Top = 328
        Width = 73
        Height = 25
        Caption = 'Done'
        TabOrder = 19
        OnClick = btDoneClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ModalResult = 1
        ThemeType = thtTBX
      end
      object ColorPanel: TPanel
        Left = 384
        Top = 16
        Width = 81
        Height = 49
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 20
      end
      object ColorToolbar: TSpTBXToolbar
        Left = 376
        Top = 280
        Width = 90
        Height = 36
        Caption = 'ColorToolbar'
        TabOrder = 21
        object TBXColorPalette1: TTBXColorPalette
          ColorSet = BattleForm.TBXTeamColorSet
          PaletteOptions = []
          OnCellClick = TBXColorPalette1CellClick
        end
      end
    end
  end
end
