object DisableUnitsForm: TDisableUnitsForm
  Left = 353
  Top = 247
  BorderStyle = bsDialog
  Caption = 'Disable units dialog'
  ClientHeight = 456
  ClientWidth = 592
  Color = clBtnFace
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
    Width = 592
    Height = 456
    Caption = 'Disable units dialog'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object Label1: TSpTBXLabel
      Left = 8
      Top = 40
      Width = 233
      Height = 13
      Caption = 'Note: put an X in front of units you wish to disable'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpeedButton1: TSpTBXSpeedButton
      Left = 512
      Top = 40
      Width = 73
      Height = 22
      Caption = 'Clear all'
      OnClick = SpeedButton1Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpeedButton2: TSpTBXSpeedButton
      Left = 336
      Top = 40
      Width = 73
      Height = 22
      Caption = 'Save ...'
      OnClick = SpeedButton2Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpeedButton3: TSpTBXSpeedButton
      Left = 424
      Top = 40
      Width = 73
      Height = 22
      Caption = 'Open ...'
      OnClick = SpeedButton3Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Button1: TSpTBXButton
      Left = 176
      Top = 416
      Width = 105
      Height = 25
      Caption = 'Close'
      TabOrder = 5
      OnClick = Button1Click
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object VDTUnits: TVirtualDrawTree
      Left = 8
      Top = 64
      Width = 577
      Height = 337
      Header.AutoSizeIndex = 2
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
      TabOrder = 6
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnDrawNode = VDTUnitsDrawNode
      OnInitNode = VDTUnitsInitNode
      Columns = <
        item
          Position = 0
          Width = 33
          WideText = 'Dis.'
        end
        item
          Position = 1
          Width = 300
          WideText = 'Unit name'
        end
        item
          Position = 2
          Width = 240
          WideText = 'Code name'
        end>
    end
    object Button2: TSpTBXButton
      Left = 312
      Top = 416
      Width = 105
      Height = 25
      Caption = 'Update selection'
      TabOrder = 7
      OnClick = Button2Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'sel'
    Filter = 'Selection|*.sel'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 40
    Top = 384
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'sel'
    Filter = 'Selection|*.sel'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 80
    Top = 384
  end
end
