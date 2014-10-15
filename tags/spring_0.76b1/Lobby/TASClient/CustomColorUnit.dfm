object CustomColorForm: TCustomColorForm
  Left = 352
  Top = 311
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Custom color dialog'
  ClientHeight = 290
  ClientWidth = 389
  Color = clBtnFace
  Constraints.MaxHeight = 910
  Constraints.MaxWidth = 1280
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 389
    Height = 290
    Caption = 'Custom color dialog'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object JvGammaPanel1: TJvGammaPanel
      Left = 320
      Top = 32
      OnChangeColor = JvGammaPanel1ChangeColor
    end
    object ColorToolbar: TSpTBXToolbar
      Left = 8
      Top = 40
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
    object SpTBXButton1: TSpTBXButton
      Left = 120
      Top = 256
      Width = 83
      Height = 25
      Caption = 'Done'
      TabOrder = 3
      OnClick = SpTBXButton1Click
      Cancel = True
      Default = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXButton2: TSpTBXButton
      Left = 8
      Top = 104
      Width = 153
      Height = 25
      Caption = 'Reset all colors to default'
      TabOrder = 4
      OnClick = SpTBXButton2Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel4: TSpTBXLabel
      Left = 112
      Top = 32
      Width = 201
      Height = 49
      Caption = 
        'To adjust static color, select it in color grid and then choose ' +
        'a new color in the color menu at the right'
      AutoSize = False
      Wrapping = twWrap
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
