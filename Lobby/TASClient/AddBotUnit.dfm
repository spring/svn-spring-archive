object AddBotForm: TAddBotForm
  Left = 632
  Top = 178
  Width = 464
  Height = 509
  Caption = 'Add bot dialog'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 456
    Height = 482
    Caption = 'Add bot dialog'
    Active = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 456
      Height = 460
      Align = alClient
      TabOrder = 1
      Borders = False
      DesignSize = (
        456
        460)
      object Label1: TSpTBXLabel
        Left = 8
        Top = 16
        Width = 67
        Height = 13
        Caption = 'Choose an AI:'
      end
      object ReloadButton: TSpTBXSpeedButton
        Left = 334
        Top = 8
        Width = 114
        Height = 22
        Caption = 'Reload'
        Anchors = [akTop, akRight]
        OnClick = ReloadButtonClick
      end
      object VSTAIList: TVirtualStringTree
        Left = 8
        Top = 32
        Width = 442
        Height = 286
        Anchors = [akLeft, akTop, akRight, akBottom]
        ButtonStyle = bsTriangle
        ClipboardFormats.Strings = (
          'Unicode text')
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoShowHint]
        HintAnimation = hatFade
        HintMode = hmHint
        ParentShowHint = False
        PopupMenu = AIListPopupMenu
        ShowHint = True
        TabOrder = 2
        TreeOptions.AnimationOptions = [toAnimatedToggle]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines]
        TreeOptions.SelectionOptions = [toDisableDrawSelection, toFullRowSelect, toRightClickSelect]
        OnDrawText = VSTAIListDrawText
        OnGetText = VSTAIListGetText
        OnPaintText = VSTAIListPaintText
        OnGetHint = VSTAIListGetHint
        OnHeaderDraw = VSTAIListHeaderDraw
        Columns = <>
      end
      object Label2: TSpTBXLabel
        Left = 8
        Top = 329
        Width = 113
        Height = 13
        Caption = 'Bot'#39's name:'
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Alignment = taRightJustify
      end
      object BotNameEdit: TSpTBXEdit
        Left = 128
        Top = 327
        Width = 137
        Height = 21
        Anchors = [akLeft, akBottom]
        TabOrder = 4
        Text = 'Bot'
      end
      object Label3: TSpTBXLabel
        Left = 8
        Top = 371
        Width = 15
        Height = 13
        Caption = 'Id :'
        Anchors = [akLeft, akBottom]
      end
      object Label4: TSpTBXLabel
        Left = 8
        Top = 395
        Width = 33
        Height = 13
        Caption = 'Team :'
        Anchors = [akLeft, akBottom]
      end
      object BotAllyButton: TSpTBXSpinEdit
        Left = 80
        Top = 391
        Width = 49
        Height = 21
        Anchors = [akLeft, akBottom]
        TabOrder = 7
        SpinButton.Left = 30
        SpinButton.Top = 0
        SpinButton.Width = 15
        SpinButton.Height = 17
        SpinButton.Align = alRight
        SpinOptions.Value = 1.000000000000000000
      end
      object BotTeamButton: TSpTBXSpinEdit
        Left = 80
        Top = 367
        Width = 49
        Height = 21
        Anchors = [akLeft, akBottom]
        TabOrder = 8
        SpinButton.Left = 30
        SpinButton.Top = 0
        SpinButton.Width = 15
        SpinButton.Height = 17
        SpinButton.Align = alRight
        SpinOptions.Value = 1.000000000000000000
      end
      object BotSideButton: TSpTBXSpeedButton
        Left = 144
        Top = 367
        Width = 121
        Height = 22
        Caption = 'Side'
        Anchors = [akLeft, akBottom]
        OnClick = BotSideButtonClick
      end
      object BotTeamColorButton: TSpTBXSpeedButton
        Left = 144
        Top = 391
        Width = 121
        Height = 21
        Caption = 'Team color'
        Anchors = [akLeft, akBottom]
        DropDownMenu = ColorPopupMenu
        Images = MainForm.ColorImageList
      end
      object AddBotButton: TSpTBXButton
        Left = 219
        Top = 427
        Width = 111
        Height = 25
        Caption = 'Add bot'
        Anchors = [akRight, akBottom]
        Enabled = False
        TabOrder = 11
        OnClick = AddBotButtonClick
      end
      object Button2: TSpTBXButton
        Left = 339
        Top = 427
        Width = 111
        Height = 25
        Caption = 'Cancel'
        Anchors = [akRight, akBottom]
        TabOrder = 12
        OnClick = Button2Click
        Cancel = True
      end
    end
  end
  object AIListPopupMenu: TSpTBXPopupMenu
    OnPopup = AIListPopupMenuPopup
    Left = 176
    Top = 72
    object mnuCopyItem: TSpTBXItem
      Caption = 'Copy'
      OnClick = mnuCopyItemClick
    end
    object mnuGotoUrl: TSpTBXItem
      Caption = 'Goto url'
      Visible = False
      OnClick = mnuGotoUrlClick
    end
  end
  object ColorPopupMenu: TSpTBXPopupMenu
    AutoHotkeys = maManual
    Left = 168
    Top = 440
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
