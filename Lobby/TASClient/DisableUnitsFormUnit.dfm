object DisableUnitsForm: TDisableUnitsForm
  Left = 1128
  Top = 439
  Width = 670
  Height = 436
  Caption = 'Disable units dialog'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 662
    Height = 409
    Caption = 'Disable units dialog'
    Active = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 662
      Height = 387
      Caption = 'pnlMain'
      Align = alClient
      TabOrder = 1
      BorderType = pbrFramed
      TBXStyleBackground = True
      DesignSize = (
        662
        387)
      object SpeedButton2: TSpTBXSpeedButton
        Left = 302
        Top = 8
        Width = 113
        Height = 22
        Caption = 'Save ...'
        Anchors = [akTop, akRight]
        OnClick = SpeedButton2Click
      end
      object SpeedButton3: TSpTBXSpeedButton
        Left = 422
        Top = 8
        Width = 113
        Height = 22
        Caption = 'Open ...'
        Anchors = [akTop, akRight]
        OnClick = SpeedButton3Click
      end
      object SpeedButton1: TSpTBXSpeedButton
        Left = 542
        Top = 8
        Width = 113
        Height = 22
        Caption = 'Clear all'
        Anchors = [akTop, akRight]
        OnClick = SpeedButton1Click
      end
      object VDTUnits: TVirtualDrawTree
        Left = 8
        Top = 32
        Width = 647
        Height = 313
        Anchors = [akLeft, akTop, akRight, akBottom]
        CheckImageKind = ckSystemFlat
        DefaultNodeHeight = 70
        Header.AutoSizeIndex = 2
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoShowSortGlyphs, hoVisible]
        Header.SortColumn = 2
        Header.Style = hsFlatButtons
        TabOrder = 3
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnColumnResize = VDTUnitsColumnResize
        OnCompareNodes = VDTUnitsCompareNodes
        OnDrawNode = VDTUnitsDrawNode
        OnHeaderClick = VDTUnitsHeaderClick
        OnHeaderDraw = VDTUnitsHeaderDraw
        OnInitNode = VDTUnitsInitNode
        Columns = <
          item
            CheckBox = True
            Position = 0
            Width = 33
            WideText = 'Dis.'
          end
          item
            Position = 1
            Width = 70
            WideText = 'Icon'
          end
          item
            Position = 2
            Width = 350
            WideText = 'Unit name'
          end
          item
            Position = 3
            Width = 190
            WideText = 'Code name'
          end>
      end
      object Button1: TSpTBXButton
        Left = 358
        Top = 354
        Width = 145
        Height = 25
        Caption = 'Close'
        Anchors = [akRight, akBottom]
        TabOrder = 4
        OnClick = Button1Click
        Cancel = True
      end
      object Button2: TSpTBXButton
        Left = 510
        Top = 354
        Width = 145
        Height = 25
        Caption = 'Update selection'
        Anchors = [akRight, akBottom]
        TabOrder = 5
        OnClick = Button2Click
      end
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
    Left = 72
    Top = 384
  end
end
