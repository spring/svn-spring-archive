object ColorPickerForm: TColorPickerForm
  Left = 246
  Top = 230
  Width = 505
  Height = 436
  Caption = 'ColorPickerForm'
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
    Width = 497
    Height = 409
    Caption = 'Color Picker'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object SpTBXPanel1: TSpTBXPanel
      Left = 8
      Top = 32
      Width = 481
      Height = 369
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
        Top = 74
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
        Top = 72
        Width = 41
        Height = 21
        TabOrder = 1
        Text = 'txtH'
        OnKeyUp = txtHKeyUp
      end
      object SpTBXLabel1: TSpTBXLabel
        Left = 464
        Top = 72
        Width = 5
        Height = 20
        Caption = #176
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpTBXLabel2: TSpTBXLabel
        Left = 461
        Top = 96
        Width = 12
        Height = 16
        Caption = '%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpTBXLabel3: TSpTBXLabel
        Left = 461
        Top = 120
        Width = 12
        Height = 16
        Caption = '%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object txtS: TSpTBXEdit
        Left = 416
        Top = 96
        Width = 41
        Height = 21
        TabOrder = 5
        Text = 'txtS'
        OnKeyUp = txtSKeyUp
      end
      object rdS: TSpTBXRadioButton
        Left = 384
        Top = 98
        Width = 31
        Height = 15
        Caption = 'S :'
        Enabled = False
        TabOrder = 6
      end
      object rdL: TSpTBXRadioButton
        Left = 384
        Top = 122
        Width = 30
        Height = 15
        Caption = 'L :'
        Enabled = False
        TabOrder = 7
      end
      object txtL: TSpTBXEdit
        Left = 416
        Top = 120
        Width = 41
        Height = 21
        TabOrder = 8
        Text = 'txtL'
        OnKeyUp = txtLKeyUp
      end
      object SpTBXLabel4: TSpTBXLabel
        Left = 400
        Top = 154
        Width = 14
        Height = 13
        Caption = 'R :'
      end
      object txtR: TSpTBXEdit
        Left = 416
        Top = 152
        Width = 41
        Height = 21
        TabOrder = 10
        Text = 'txtR'
        OnKeyUp = txtRKeyUp
      end
      object SpTBXLabel5: TSpTBXLabel
        Left = 400
        Top = 178
        Width = 14
        Height = 13
        Caption = 'G :'
      end
      object txtG: TSpTBXEdit
        Left = 416
        Top = 176
        Width = 41
        Height = 21
        TabOrder = 12
        Text = 'txtG'
        OnKeyUp = txtGKeyUp
      end
      object SpTBXLabel6: TSpTBXLabel
        Left = 400
        Top = 202
        Width = 13
        Height = 13
        Caption = 'B :'
      end
      object txtB: TSpTBXEdit
        Left = 416
        Top = 200
        Width = 41
        Height = 21
        TabOrder = 14
        Text = 'txtB'
        OnKeyUp = txtBKeyUp
      end
      object SpTBXLabel7: TSpTBXLabel
        Left = 394
        Top = 234
        Width = 16
        Height = 13
        Caption = '#'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsItalic]
        ParentFont = False
      end
      object txtColorHex: TSpTBXEdit
        Left = 408
        Top = 232
        Width = 49
        Height = 21
        Hint = 'Hit Enter to validate'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        Text = 'FFFFFF'
        OnKeyDown = txtColorHexKeyDown
      end
      object btReset: TSpTBXButton
        Left = 313
        Top = 344
        Width = 145
        Height = 25
        Caption = 'Reset all colors to default'
        TabOrder = 17
        OnClick = btResetClick
      end
      object btCancel: TSpTBXButton
        Left = 160
        Top = 344
        Width = 81
        Height = 25
        Caption = 'Cancel'
        TabOrder = 18
        OnClick = btCancelClick
        ModalResult = 2
      end
      object btDone: TSpTBXButton
        Left = 82
        Top = 344
        Width = 73
        Height = 25
        Caption = 'Done'
        TabOrder = 19
        OnClick = btDoneClick
        ModalResult = 1
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
    end
  end
end
