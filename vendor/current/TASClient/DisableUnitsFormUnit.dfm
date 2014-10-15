object DisableUnitsForm: TDisableUnitsForm
  Left = 342
  Top = 134
  BorderStyle = bsDialog
  Caption = 'Disable units dialog'
  ClientHeight = 423
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 233
    Height = 13
    Caption = 'Note: put an X in front of units you wish to disable'
  end
  object SpeedButton1: TSpeedButton
    Left = 512
    Top = 8
    Width = 73
    Height = 22
    Caption = 'Clear all'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 336
    Top = 8
    Width = 73
    Height = 22
    Caption = 'Save ...'
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 424
    Top = 8
    Width = 73
    Height = 22
    Caption = 'Open ...'
    OnClick = SpeedButton3Click
  end
  object Button1: TButton
    Left = 176
    Top = 384
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 0
    OnClick = Button1Click
  end
  object VDTUnits: TVirtualDrawTree
    Left = 8
    Top = 32
    Width = 577
    Height = 337
    Header.AutoSizeIndex = 2
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
    TabOrder = 1
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
  object Button2: TButton
    Left = 312
    Top = 384
    Width = 105
    Height = 25
    Caption = 'Update selection'
    TabOrder = 2
    OnClick = Button2Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'sel'
    Filter = 'Selection|*.sel'
    Left = 40
    Top = 384
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'sel'
    Filter = 'Selection|*.sel'
    Left = 80
    Top = 384
  end
end
