object BotOptionsForm: TBotOptionsForm
  Left = 498
  Top = 356
  Width = 433
  Height = 470
  Caption = 'AIOptions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 425
    Height = 443
    Caption = 'AI Options'
    Active = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 425
      Height = 421
      Align = alClient
      TabOrder = 1
      Borders = False
      DesignSize = (
        425
        421)
      object gbGameOptions: TSpTBXGroupBox
        Left = 8
        Top = 10
        Width = 409
        Height = 71
        Caption = 'Game options'
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TBXStyleBackground = True
        object lblId: TSpTBXLabel
          Left = 8
          Top = 22
          Width = 127
          Height = 13
          Caption = 'Id :'
          AutoSize = False
          Alignment = taRightJustify
        end
        object BotTeamButton: TSpTBXSpinEdit
          Left = 144
          Top = 18
          Width = 49
          Height = 21
          TabOrder = 1
          OnExit = BotTeamButtonExit
          SpinButton.Left = 30
          SpinButton.Top = 0
          SpinButton.Width = 15
          SpinButton.Height = 17
          SpinButton.Align = alRight
          SpinOptions.Decimal = 0
          SpinOptions.MinValue = 1.000000000000000000
        end
        object BotSideButton: TSpTBXSpeedButton
          Left = 200
          Top = 17
          Width = 121
          Height = 22
          Caption = 'Side'
          OnClick = BotSideButtonClick
        end
        object lblTeam: TSpTBXLabel
          Left = 8
          Top = 46
          Width = 129
          Height = 13
          Caption = 'Team :'
          AutoSize = False
          Alignment = taRightJustify
        end
        object BotAllyButton: TSpTBXSpinEdit
          Left = 144
          Top = 42
          Width = 49
          Height = 21
          TabOrder = 4
          OnExit = BotAllyButtonExit
          SpinButton.Left = 30
          SpinButton.Top = 0
          SpinButton.Width = 15
          SpinButton.Height = 17
          SpinButton.Align = alRight
          SpinOptions.Decimal = 0
          SpinOptions.MinValue = 1.000000000000000000
        end
        object BotTeamColorButton: TSpTBXSpeedButton
          Left = 200
          Top = 42
          Width = 121
          Height = 21
          Caption = 'Team color'
          DropDownMenu = ColorPopupMenu
          Images = MainForm.ColorImageList
        end
      end
      object gpOtherOptions: TSpTBXGroupBox
        Left = 8
        Top = 88
        Width = 409
        Height = 321
        Caption = 'Other options'
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 1
        object AIOptionsScrollBox: TTntScrollBox
          Left = 2
          Top = 15
          Width = 405
          Height = 304
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          BiDiMode = bdLeftToRight
          BorderStyle = bsNone
          Color = clBtnFace
          Ctl3D = False
          ParentBiDiMode = False
          ParentBackground = True
          ParentColor = False
          ParentCtl3D = False
          TabOrder = 0
        end
      end
    end
  end
  object ColorPopupMenu: TSpTBXPopupMenu
    AutoHotkeys = maManual
    Left = 336
    Top = 56
    object mnuTeamColorPalette: TSpTBXColorPalette
      CustomColors = True
      ColCount = 5
      RowCount = 4
      OnCellClick = mnuTeamColorPaletteCellClick
      OnGetColor = mnuTeamColorPaletteGetColor
    end
    object mnuTeamColorCustomize: TSpTBXItem
      Caption = 'Customize ...'
      OnClick = mnuTeamColorCustomizeClick
    end
    object SpTBXSeparatorItem1: TSpTBXSeparatorItem
    end
    object mnuTeamColorCancel: TSpTBXItem
      Caption = 'Cancel'
    end
  end
end
