object MainForm: TMainForm
  Left = 302
  Top = 312
  Width = 789
  Height = 548
  Caption = 'TASClient'
  Color = clBtnFace
  Constraints.MaxHeight = 1000
  Constraints.MaxWidth = 1680
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainTitleBar: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 781
    Height = 521
    Caption = 'TASClient'
    object Splitter1: TSplitter
      Left = 619
      Top = 30
      Width = 4
      Height = 487
      Align = alRight
      AutoSnap = False
      ResizeStyle = rsUpdate
    end
    object Panel2: TSpTBXPanel
      Left = 623
      Top = 30
      Width = 154
      Height = 487
      Align = alRight
      Color = clNone
      ParentColor = False
      TabOrder = 1
      Borders = False
      BorderType = pbrFramed
      DesignSize = (
        154
        487)
      object Bevel1: TBevel
        Left = 2
        Top = 2
        Width = 150
        Height = 24
        Align = alTop
        Style = bsRaised
      end
      object SortLabel: TLabel
        Left = 120
        Top = 8
        Width = 24
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = 'Sort'
        Color = clNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnClick = SortLabelClick
      end
      object PlayersLabel: TSpTBXLabel
        Left = 8
        Top = 8
        Width = 37
        Height = 13
        Caption = 'Players:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object ClientsListBox: TListBox
        Left = 2
        Top = 26
        Width = 150
        Height = 459
        Style = lbOwnerDrawFixed
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Fixedsys'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = ClientsListBoxClick
        OnDblClick = ClientsListBoxDblClick
        OnDrawItem = ClientsListBoxDrawItem
        OnMouseDown = ClientsListBoxMouseDown
        OnMouseMove = ClientsListBoxMouseMove
        OnMouseUp = ClientsListBoxMouseUp
      end
    end
    object Panel1: TSpTBXPanel
      Left = 4
      Top = 30
      Width = 615
      Height = 487
      Caption = 'Panel1'
      Align = alClient
      TabOrder = 2
      Borders = False
      BorderType = pbrRaised
      object Splitter2: TSplitter
        Left = 2
        Top = 252
        Width = 611
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        AutoSnap = False
        ResizeStyle = rsUpdate
      end
      object Bevel2: TBevel
        Left = 2
        Top = 43
        Width = 611
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel3: TPanel
        Left = 2
        Top = 256
        Width = 611
        Height = 229
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object VDTBattles: TVirtualDrawTree
          Left = 0
          Top = 0
          Width = 611
          Height = 44
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          CheckImageKind = ckCustom
          CustomCheckImages = ButtonImageList
          Header.AutoSizeIndex = 7
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'MS Sans Serif'
          Header.Font.Style = []
          Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
          Header.Style = hsFlatButtons
          HintMode = hmHint
          ParentShowHint = False
          PopupMenu = BattleListPopupMenu
          ShowHint = True
          TabOrder = 0
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnChecked = VDTBattlesChecked
          OnDblClick = VDTBattlesDblClick
          OnDrawHint = VDTBattlesDrawHint
          OnDrawNode = VDTBattlesDrawNode
          OnGetHintSize = VDTBattlesGetHintSize
          OnGetNodeWidth = VDTBattlesGetNodeWidth
          OnHeaderClick = VDTBattlesHeaderClick
          OnInitNode = VDTBattlesInitNode
          OnMouseDown = VDTBattlesMouseDown
          Columns = <
            item
              Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 0
              Width = 37
              WideText = 'Join'
            end
            item
              Position = 1
              Width = 85
              WideText = 'Description'
            end
            item
              Position = 2
              Width = 60
              WideText = 'Host'
            end
            item
              Position = 3
              Width = 100
              WideText = 'Map'
            end
            item
              Position = 4
              Width = 60
              WideText = 'State'
            end
            item
              Position = 5
              Width = 90
              WideText = 'Mod'
            end
            item
              MaxWidth = 50
              MinWidth = 2
              Position = 6
              Width = 45
              WideText = 'AVG Players rank'
            end
            item
              Position = 7
              Width = 130
              WideText = 'Players'
            end>
        end
        object FilterGroup: TSpTBXGroupBox
          Left = 0
          Top = 56
          Width = 611
          Height = 173
          Caption = 'Filters'
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnResize = FilterGroupResize
          object FilterValueTextBox: TSpTBXEdit
            Left = 216
            Top = 16
            Width = 161
            Height = 21
            TabOrder = 0
          end
          object ContainsRadio: TSpTBXRadioButton
            Left = 112
            Top = 12
            Width = 58
            Height = 15
            Caption = 'contains'
            TabOrder = 1
          end
          object DoNotContainsRadio: TSpTBXRadioButton
            Left = 112
            Top = 28
            Width = 97
            Height = 15
            Caption = 'does not contain'
            TabOrder = 2
            TabStop = True
            Checked = True
          end
          object AddToFilterListButton: TSpTBXButton
            Left = 384
            Top = 16
            Width = 33
            Height = 25
            Caption = '->'
            TabOrder = 3
            OnClick = AddToFilterListButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object FilterListCombo: TSpTBXComboBox
            Left = 16
            Top = 16
            Width = 89
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 1
            TabOrder = 4
            Text = 'Map'
            Items.Strings = (
              'Host'
              'Map'
              'Mod'
              'Description')
          end
          object RemoveFromFilterListButton: TSpTBXButton
            Left = 384
            Top = 48
            Width = 33
            Height = 25
            Caption = '<-'
            TabOrder = 5
            OnClick = RemoveFromFilterListButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object ClearFilterListButton: TSpTBXButton
            Left = 384
            Top = 80
            Width = 33
            Height = 25
            Caption = 'Clear'
            TabOrder = 6
            OnClick = ClearFilterListButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object EnableFilters: TSpTBXCheckBox
            Left = 8
            Top = 150
            Width = 110
            Height = 18
            Caption = 'Enable filters'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 7
            OnClick = EnableFiltersClick
          end
          object FilterList: TVirtualStringTree
            Left = 424
            Top = 16
            Width = 177
            Height = 145
            CheckImageKind = ckSystem
            ClipboardFormats.Strings = (
              'Unicode text')
            CustomCheckImages = ButtonImageList
            DragOperations = []
            Header.AutoSizeIndex = 3
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'MS Sans Serif'
            Header.Font.Style = []
            Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
            Header.SortColumn = 1
            Header.Style = hsFlatButtons
            TabOrder = 8
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
            OnChecking = FilterListChecking
            OnCompareNodes = FilterListCompareNodes
            OnGetText = FilterListGetText
            OnHeaderClick = FilterListHeaderClick
            OnResize = FilterListResize
            Columns = <
              item
                MaxWidth = 20
                MinWidth = 20
                Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible, coFixed]
                Position = 0
                Width = 20
              end
              item
                Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
                Position = 1
                Width = 80
                WideText = 'Type'
              end
              item
                Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
                Position = 2
                Width = 63
                WideText = ' '
              end
              item
                Position = 3
                Width = 10
                WideText = 'Value'
              end>
          end
          object SpTBXPanel1: TSpTBXPanel
            Left = 8
            Top = 48
            Width = 369
            Height = 97
            Caption = 'SpTBXPanel1'
            ThemeType = thtWindows
            TabOrder = 9
            BorderType = pbrRaised
            object FullFilter: TSpTBXCheckBox
              Left = 8
              Top = 8
              Width = 34
              Height = 15
              Caption = 'Full'
              TabOrder = 0
              OnClick = FullFilterClick
            end
            object InProgressFilter: TSpTBXCheckBox
              Left = 8
              Top = 24
              Width = 70
              Height = 15
              Caption = 'In progress'
              TabOrder = 1
              OnClick = InProgressFilterClick
            end
            object LadderFilter: TSpTBXCheckBox
              Left = 8
              Top = 40
              Width = 51
              Height = 15
              Caption = 'Ladder'
              TabOrder = 2
              OnClick = LadderFilterClick
            end
            object LockedFilter: TSpTBXCheckBox
              Left = 8
              Top = 56
              Width = 54
              Height = 15
              Caption = 'Locked'
              TabOrder = 3
              OnClick = LockedFilterClick
            end
            object PasswordedFilter: TSpTBXCheckBox
              Left = 8
              Top = 72
              Width = 76
              Height = 15
              Caption = 'Passworded'
              TabOrder = 4
              OnClick = PasswordedFilterClick
            end
            object RankLimitFilter: TSpTBXCheckBox
              Left = 88
              Top = 72
              Width = 114
              Height = 15
              Caption = 'Rank limit > My rank'
              TabOrder = 5
              OnClick = RankLimitFilterClick
            end
            object ReplaysFilter: TSpTBXCheckBox
              Left = 88
              Top = 56
              Width = 51
              Height = 15
              Caption = 'Replay'
              TabOrder = 6
              OnClick = ReplaysFilterClick
            end
            object ModsNotAvailableFilter: TSpTBXCheckBox
              Left = 88
              Top = 40
              Width = 102
              Height = 15
              Caption = 'Mod not available'
              TabOrder = 7
              OnClick = ModsNotAvailableFilterClick
            end
            object MapsNotAvailableFilter: TSpTBXCheckBox
              Left = 88
              Top = 24
              Width = 102
              Height = 15
              Caption = 'Map not available'
              TabOrder = 8
              OnClick = MapsNotAvailableFilterClick
            end
            object NatTraversalFilter: TSpTBXCheckBox
              Left = 88
              Top = 8
              Width = 78
              Height = 15
              Caption = 'Nat traversal'
              TabOrder = 9
              OnClick = NatTraversalFilterClick
            end
            object PlayersSignButton: TSpTBXButton
              Left = 296
              Top = 8
              Width = 25
              Height = 20
              Caption = '<'
              TabOrder = 10
              OnClick = PlayersSignButtonClick
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object PlayersValueTextBox: TJvSpinEdit
              Left = 320
              Top = 8
              Width = 41
              Height = 20
              ButtonKind = bkStandard
              MaxValue = 16.000000000000000000
              Value = 10.000000000000000000
              TabOrder = 11
              OnChange = PlayersValueTextBoxChange
            end
            object MaxPlayersSignButton: TSpTBXButton
              Left = 296
              Top = 39
              Width = 25
              Height = 20
              Caption = '<'
              TabOrder = 12
              OnClick = MaxPlayersSignButtonClick
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object MaxPlayersValueTextBox: TJvSpinEdit
              Left = 320
              Top = 39
              Width = 41
              Height = 20
              ButtonKind = bkStandard
              MaxValue = 16.000000000000000000
              MinValue = 1.000000000000000000
              Value = 10.000000000000000000
              TabOrder = 13
              OnChange = MaxPlayersValueTextBoxChange
            end
            object MaxPlayersFilter: TSpTBXCheckBox
              Left = 216
              Top = 40
              Width = 78
              Height = 15
              Caption = 'Max Players '
              TabOrder = 14
              OnClick = MaxPlayersFilterClick
            end
            object PlayersFilter: TSpTBXCheckBox
              Left = 216
              Top = 10
              Width = 55
              Height = 15
              Caption = 'Players '
              TabOrder = 15
              OnClick = PlayersFilterClick
            end
          end
        end
        object FiltersButton: TSpTBXButton
          Left = 0
          Top = 44
          Width = 611
          Height = 12
          Align = alBottom
          TabOrder = 2
          OnClick = FiltersButtonClick
          Images = ArrowList
          ImageIndex = 0
          LinkFont.Charset = DEFAULT_CHARSET
          LinkFont.Color = clBlue
          LinkFont.Height = -11
          LinkFont.Name = 'MS Sans Serif'
          LinkFont.Style = [fsUnderline]
        end
      end
      object Panel4: TSpTBXPanel
        Left = 2
        Top = 2
        Width = 611
        Height = 41
        Align = alTop
        Color = clNone
        ParentColor = False
        TabOrder = 1
        BorderType = pbrRaised
        TBXStyleBackground = True
        object DefaultSideImage: TImage
          Left = 0
          Top = 0
          Width = 25
          Height = 25
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            000010000000010018000000000000030000120B0000120B0000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF00FFFF00000000
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF000000FFFF00FFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF00FFFFFF000000000000FFFFFF
            FFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
            00FFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000FFFF00FFFFFFFFFFFF000000000000FFFFFF
            FFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
            00FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFF00000000FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000FFFF00FFFFFF000000FFFFFF000000000000
            FFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
            00FFFF00FFFFFF000000000000FFFFFFFFFF00FFFF00000000FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFF00FFFF00FFFF00FFFF00
            000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Transparent = True
          Visible = False
        end
        object DefaultArmImage: TImage
          Left = 32
          Top = 0
          Width = 25
          Height = 25
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            000010000000010018000000000000030000120B0000120B0000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8460CFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFA8460CFFFFFFA8460CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8460CFFFFFFA8460CFFFFFF
            A8460CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8460CA846
            0CA8460CFFFFFFA8460CA8460CA8460CFFFFFFA8460CA8460CA8460CFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8460CA8460CA8460CA8460C
            A8460CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8460CA846
            0CA8460CFFFFFFA8460CA8460CA8460CFFFFFFA8460CA8460CA8460CFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8460CFFFFFFA8460CFFFFFF
            A8460CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFA8460CFFFFFFA8460CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Transparent = True
          Visible = False
        end
        object DefaultCoreImage: TImage
          Left = 64
          Top = 0
          Width = 25
          Height = 25
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            000010000000010018000000000000030000120B0000120B0000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF02EDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF02EDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2A00D902ED
            FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF02EDFD2A00D9FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF2A00D91081F0FFFFFF117CEF2206E02206E0117CEF
            FFFFFF1081F02A00D9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF02EDFD2C00D70BA1
            F5117CEF1B44E62206E02206E01B44E6117CEF0BA1F52C00D702EDFDFFFFFFFF
            FFFFFFFFFFFFFFFF02EDFD2A00D90D97F305DAFB2110E12400DE2400DE2110E1
            05DAFB0D97F32A00D902EDFDFFFFFFFFFFFFFFFFFFFFFFFF02EDFD2701DC240B
            DE09B1F702EDFD2017E22017E202EDFD09B1F7240BDE2702DC02EDFDFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF208DF22502DD2601DD09B3F700F4FF00F4FF09B3F7
            2601DD2503DD1A87F1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1087
            F12502DD2600DD09B1F709B1F72600DD2502DD0F8BF2FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF05C9FA01F2FE1087F02500DD2600DC2600DC2500DD
            1087F001F2FE05CAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1560EC1E3B
            E300FEFF0F8BF12600DD2600DD0F8BF100FEFF1E3BE31560ECFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF0EE6FE2416DF1E2FE401F2FF0F8BF20F8BF201F2FF
            1E2FE42416DF0EE6FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0CE7
            FE1189F003D9FDFFFFFFFFFFFF03D9FD1189F00CE7FEFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Transparent = True
          Visible = False
        end
        object BotImage: TImage
          Left = 88
          Top = 0
          Width = 36
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D6170F6060000424DF60600000000000036000000280000002400
            0000100000000100180000000000C0060000120B0000120B0000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000FFFFFF0000005C5C5C
            5C5C5C5C5C5C5C5C5C5C5C5C5C5C5C5C5C5CC9C9C9C9C9C9C9C9C9C9C9C9C9C9
            C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9
            C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9
            C9C9C90000000000005C5C5CC1C1C1C1C1C1C1C1C1C1C1C1C1C1C15C5C5C5C5C
            5CDBDBDBDBDBDBA6A6A68D8D8D8D8D8D8D8D8D8D8D8D8D8D8DA6A6A6B4B4B4C9
            C9C9A6A6A68D8D8D8D8D8D8D8D8D8D8D8DA6A6A6C9C9C9C9C9C9C9C9C9A5A5A5
            8A8A8A878787999999ADADAD9D9D9D0000000000005C5C5CC1C1C100FF000000
            FF00FF00C1C1C15C5C5CC1C1C15C5C5CE9E9E998989800FFFF00FFFF00FFFF00
            FFFF00FFFF989898A0A0A0B4B4B498989800FFFF00FFFF00FFFF00FFFF989898
            B4B4B4DBDBDBDBDBDB97979700FFFF00FFFF8E8E8EB9B9B9A5A5A50000000000
            005C5C5CC1C1C1C1C1C1C1C1C1C1C1C1C1C1C15C5C5CC1C1C15C5C5CEEEEEEA0
            A0A000FFFF00FFFFA0A0A0A0A0A000FFFF00FFFFA3A3A3A0A0A000FFFF00FFFF
            A0A0A0A0A0A000FFFF00FFFFA0A0A0E9E9E9E9E9E9A0A0A000FFFF00FFFF9494
            94BFBFBFADADAD0000000000005C5C5CC1C1C1C1C1C1C1C1C1C1C1C1C1C1C15C
            5C5CC1C1C15C5C5CEEEEEEA3A3A300FFFF00FFFFA3A3A3A3A3A300FFFF00FFFF
            A3A3A3A3A3A300FFFF00FFFFA3A3A3A3A3A300FFFF00FFFFA3A3A3EEEEEEEEEE
            EEA3A3A300FFFF00FFFF979797C8C8C8B6B6B60000000000005C5C5CC1C1C1C1
            C1C1C1C1C1C1C1C1C1C1C15C5C5CC1C1C15C5C5CEEEEEEA3A3A300FFFF00FFFF
            A3A3A3A3A3A300FFFFA3A3A3C3C3C3A3A3A300FFFF00FFFFA3A3A3A3A3A300FF
            FF00FFFFA3A3A3EEEEEEEEEEEEA3A3A300FFFF00FFFF989898CACACAB8B8B800
            00000000005C5C5CC1C1C17E7E7E7E7E7E7E7E7EC1C1C15C5C5CC1C1C15C5C5C
            EEEEEEA3A3A300FFFF00FFFF00FFFF00FFFF00FFFF00FFFFA3A3A3A3A3A300FF
            FF00FFFFA3A3A3A3A3A300FFFF00FFFFA3A3A3EEEEEEEEEEEEA3A3A300FFFF00
            FFFF9A9A9ACBCBCBB9B9B90000000000005C5C5CC1C1C1C1C1C1C1C1C1C1C1C1
            C1C1C15C5C5CC1C1C15C5C5CEEEEEEA3A3A300FFFF00FFFFA3A3A3A3A3A300FF
            FF00FFFFA3A3A3A3A3A300FFFF00FFFFA3A3A3A3A3A300FFFF00FFFFA3A3A3EE
            EEEEEEEEEEA3A3A300FFFF00FFFF9B9B9BCECECEBCBCBC0000000000005C5C5C
            C1C1C17E7E7E7E7E7E7E7E7EC1C1C15C5C5CC1C1C15C5C5CEEEEEEA3A3A300FF
            FF00FFFFA3A3A3A3A3A300FFFF00FFFFA3A3A3A3A3A300FFFF00FFFFA3A3A3A3
            A3A300FFFF00FFFFA3A3A3C3C3C3A3A3A3A3A3A300FFFF00FFFF9D9D9D939393
            9F9F9F0000000000005C5C5CC1C1C1C1C1C1C1C1C1C1C1C1C1C1C15C5C5CC1C1
            C15C5C5CEEEEEEA3A3A300FFFF00FFFF00FFFF00FFFF00FFFFA3A3A3C3C3C3C3
            C3C3A3A3A300FFFF00FFFF00FFFF00FFFFA3A3A3C3C3C3A3A3A300FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF8C8C8C0000000000005C5C5C5C5C5C5C5C5C5C5C
            5C5C5C5C5C5C5C5C5C5CC1C1C15C5C5CEFEFEFC3C3C3A4A4A4A4A4A4A4A4A4A4
            A4A4A4A4A4C3C3C3EFEFEFEFEFEFC3C3C3A4A4A4A4A4A4A4A4A4A4A4A4C3C3C3
            EFEFEFC3C3C3A4A4A4A4A4A4A4A4A4A3A3A3A0A0A09A9A9AABABAB0000000000
            00F3F3F35C5C5CC1C1C1C1C1C1C1C1C1C1C1C1C1C1C15C5C5C5C5C5CF0F0F0F0
            F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0
            F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0EEEEEEEBEB
            EBE4E4E4D8D8D8000000FFFFFF00000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          Transparent = True
          Visible = False
        end
        object OptionsSpeedButton: TSpTBXSpeedButton
          Left = 288
          Top = 8
          Width = 97
          Height = 25
          Caption = 'Options'
          OnClick = OptionsSpeedButtonClick
          LinkFont.Charset = DEFAULT_CHARSET
          LinkFont.Color = clBlue
          LinkFont.Height = -11
          LinkFont.Name = 'MS Sans Serif'
          LinkFont.Style = [fsUnderline]
        end
        object BattleScreenSpeedButton: TSpTBXSpeedButton
          Left = 64
          Top = 8
          Width = 97
          Height = 25
          Caption = 'Host battle'
          DropDownMenu = HostBattlePopupMenu
          LinkFont.Charset = DEFAULT_CHARSET
          LinkFont.Color = clBlue
          LinkFont.Height = -11
          LinkFont.Name = 'MS Sans Serif'
          LinkFont.Style = [fsUnderline]
          ThemeType = thtTBX
        end
        object HelpButton: TSpTBXSpeedButton
          Left = 400
          Top = 8
          Width = 97
          Height = 25
          Caption = 'Help / Links'
          DropDownMenu = HelpPopupMenu
          LinkFont.Charset = DEFAULT_CHARSET
          LinkFont.Color = clBlue
          LinkFont.Height = -11
          LinkFont.Name = 'MS Sans Serif'
          LinkFont.Style = [fsUnderline]
        end
        object ReplaysButton: TSpTBXSpeedButton
          Left = 176
          Top = 8
          Width = 97
          Height = 25
          Caption = 'Replays'
          OnClick = ReplaysButtonClick
          LinkFont.Charset = DEFAULT_CHARSET
          LinkFont.Color = clBlue
          LinkFont.Height = -11
          LinkFont.Name = 'MS Sans Serif'
          LinkFont.Style = [fsUnderline]
        end
        object SearchButton: TSpTBXSpeedButton
          Left = 512
          Top = 8
          Width = 97
          Height = 25
          Caption = 'Search files'
          DropDownMenu = SearchFormPopupMenu
          LinkFont.Charset = DEFAULT_CHARSET
          LinkFont.Color = clBlue
          LinkFont.Height = -11
          LinkFont.Name = 'MS Sans Serif'
          LinkFont.Style = [fsUnderline]
        end
        object ConnectButton: TTBXButton
          Left = 8
          Top = 8
          Width = 41
          Height = 26
          BorderSize = 3
          DropDownCombo = True
          DropDownMenu = ConnectionPopupMenu
          Images = ConnectionStateImageList
          TabOrder = 5
          OnClick = ConnectButtonClick
        end
      end
      object PageControl1: TPageControl
        Left = 2
        Top = 47
        Width = 611
        Height = 205
        Align = alClient
        Style = tsButtons
        TabOrder = 2
        TabStop = False
        OnChange = PageControl1Change
        OnMouseDown = PageControl1MouseDown
      end
    end
  end
  object ButtonImageList: TImageList
    Left = 176
    Top = 312
    Bitmap = {
      494C010119001D00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000008000000001002000000000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004242
      4200636363006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006363
      6300424242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000052525200B5B5
      B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
      B500B5B5B5005252520000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000393939007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0039393900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000031313100313131003131
      3100313131002121210010101800313131003131310031313100212121002929
      2900313131003131310031313100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      10000808080010105A0010084200101010001010100010101000080839000808
      3900101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      10000808080021188400211094000808080010101000000010002110A5001810
      6B00101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      100010101000080829002110B50010087B00080029001808A5002110AD000808
      2100101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      10001010100010101000080042002108CE002100DE001800BD00080029001010
      1000101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      1000101010000808080010086B002108CE002100D60018009400080810001010
      1000101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      100008081000181884002110B5001008730010005A002108C6002110A5000808
      4200080810001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      1000101042002118940010085200080808001010100008003900211094001810
      6B00080810001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      10000808180018186B0008080800101010001010100010101000080808000808
      0800101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000010101000101010001010
      1000101010000000000010101000101010001010100010101000101010001010
      1000101010001010100010101000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008080800101010001010
      1000101010001010100010101000101010001010100010101000101010001010
      1000101010001010100008080800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000080808001010
      1000101010001010100010101000101010001010100010101000101010001010
      1000101010000808080000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004242
      4200080808000808080008080800080808000808080008080800080808000808
      0800424242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004242
      4200636363006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006363
      6300424242000000000000000000000000000000000000000000000000004242
      4200636363006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006363
      6300424242000000000000000000000000000000000000000000000000004242
      4200313131003939390039393900393939003939390039393900393939003131
      3100424242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000052525200B5B5
      B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
      B500B5B5B500525252000000000000000000000000000000000052525200B5B5
      B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
      B500B5B5B5005252520000000000000000000000000000000000313131007373
      73007B7B7B008484840084848400848484008484840084848400848484007B7B
      7B00737373003131310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000393939007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B00393939000000000000000000393939007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0039393900000000000000000021212100525252006363
      63006B6B6B007373730073737300737373007373730073737300737373006B6B
      6B00636363005252520021212100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000031313100313131003131
      3100313131003131310052525200424242003131310031313100313131003131
      3100313131003131310031313100000000000000000031313100313131003131
      3100313131003131310042393100393931003131310031313100313131003131
      3100313131003131310031313100000000000000000021212100292929003131
      3100313131003131310042393100393931003131310031313100313131003131
      3100313131002929290021212100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      1000101010001010100052525200D6D6D6002121210010101000101010001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000945A08002118100010101000101010001010
      1000101010001010100010101000080808000000000010101000101010001010
      1000101010001010100039291000945A08002118100010101000101010001010
      1000101010001010100010101000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      1000101010001010100052525200FFFFFF00D6D6D60021212100101010001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000B56B1000A56B290021181800101010001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000B56B1000A56B290021181800101010001010
      1000101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      100010101000101010004A4A4A00F7F7F700F7F7F700CECECE00212121001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000CE8C4200E7B57300BD946300212118001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000CE8C4200E7B57300BD946300212118001010
      1000101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      100010101000101010004A4A4A00EFEFEF00EFEFEF00EFEFEF00ADADAD001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100042311800D6A55A00F7D69400EFCE8C009C7342001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100042311800D6A55A00F7D69400EFCE8C009C7342001010
      1000101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      1000101010001010100042424200D6D6D600D6D6D600CECECE00393939001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000CE8C4200E7B57300D6A56B00393121001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000CE8C4200E7B57300D6A56B00393121001010
      1000101010001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      1000101010001010100039393900ADADAD00A5A5A50031313100101010001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000B56B1000B57B290039292100101010001010
      1000101010001010100010101000080808000808080010101000101010001818
      1800101010001010100039291000B56B1000B57B290039292100101010001010
      1000181818001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      10001010100010101000292929006B6B6B002929290010101000101010001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100039291000AD6300003121100010101000101010001010
      1000101010001010100010101000080808000808080010101000101010002121
      2100101010001010100039291000AD6300003121100010101000101010001010
      1000212121001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080010101000101010001010
      1000101010001010100010101000181818001010100010101000101010001010
      1000101010001010100010101000080808000808080010101000101010001010
      1000101010001010100031211000312110001010100010101000101010001010
      1000101010001010100010101000080808000808080010101000101010003939
      3900181818001010100031211000312110001010100010101000101010001818
      1800393939001010100010101000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000010101000101010001010
      1000101010001010100010101000101010001010100010101000101010001010
      1000101010001010100010101000000000000000000010101000101010001010
      1000101010001010100010101000101010001010100010101000101010001010
      1000101010001010100010101000000000000000000010101000101010006B6B
      6B00424242002121210018181800101010001010100018181800212121004242
      42006B6B6B001010100010101000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008080800101010001010
      1000101010001010100010101000101010001010100010101000101010001010
      1000101010001010100008080800000000000000000008080800101010001010
      1000101010001010100010101000101010001010100010101000101010001010
      1000101010001010100008080800000000000000000008080800101010007373
      7300BDBDBD00B5B5B500ADADAD00ADADAD00ADADAD00ADADAD00B5B5B500BDBD
      BD00737373001010100008080800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000080808001010
      1000101010001010100010101000101010001010100010101000101010001010
      1000101010000808080000000000000000000000000000000000080808001010
      1000101010001010100010101000101010001010100010101000101010001010
      1000101010000808080000000000000000000000000000000000080808001010
      10004A4A4A007B7B7B008C8C8C008C8C8C008C8C8C008C8C8C007B7B7B004A4A
      4A00101010000808080000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004242
      4200080808000808080008080800080808000808080008080800080808000808
      0800424242000000000000000000000000000000000000000000000000004242
      4200080808000808080008080800080808000808080008080800080808000808
      0800424242000000000000000000000000000000000000000000000000004242
      4200080808000808080008080800080808000808080008080800080808000808
      0800424242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000800000000100010000000000000400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E007000000000000C003000000000000
      8001000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008001000000000000
      C003000000000000E007000000000000FFFFE007E007E007FFFFC003C003C003
      FFFF800180018001FFFF000000000000FFFF000000000000FFFF000000000000
      FFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000
      FFFF000000000000FFFF000000000000FFFF000000000000FFFF800180018001
      FFFFC003C003C003FFFFE007E007E007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PlayerStateImageList: TImageList
    Left = 209
    Top = 311
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5A5A5008484
      8400636363008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00B5B5
      B50084848400D6D6D60063636300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5B5B500BDBDBD00000000000000
      0000B5B5B500D6D6D6005A5A5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063636300ADADAD00000000000000
      000084848400D6D6D60084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063636300848484009C9C9C005A5A
      5A0084848400D6D6D6008C8C8C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006363630063636300848484009C9C
      9C00D6D6D60084848400D6D6D600A5A5A5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      840073737300D6D6D60000000000D6D6D6008C8C8C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000094949400D6D6D60000000000D6D6D6009C9C9C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000073737300D6D6D60000000000D6D6D600848484008484
      8400636363007373730000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084848400D6D6D60084848400D6D6D600D6D6
      D600D6D6D600D6D6D600ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063636300D6D6D600848484005A5A
      5A00ADADAD00848484008C8C8C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000636363009C9C9C007B7B7B000000
      000000000000A5A5A5009C9C9C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006363630084848400B5B5B5000000
      000000000000C6C6C600CECECE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000636363005A5A5A00848484009C9C
      9C00CECECE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063636300636363008484
      8400C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000635A5A00AD946B00946B39009C7B4A00ADA58C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000081000000810000008100000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000008000000080000000800000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000052423100E7BD8400EFDECE00FFFFFF00FFF7E700DEBD9400AD8C63000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000390000004200000039000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000810000021420000214A000021420000081000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000800000039080800390808003908080008000000000000000000
      0000000000000000000000000000000000000000000000000000000000004242
      3900DEB58400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700DEBD9400ADA5
      8C00000000000000000000000000000000000000000000000000000000000000
      000000000000003900000063000000A500000042000000390000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000810000021420000396B000063BD000029520000214200000810000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008000000390808005A1010009C1821004208100039080800080000000000
      0000000000000000000000000000000000000000000000000000000000003121
      1000EFD6BD00FFFFFF00FFFFFF00FFFFFF00CEAD8400EFE7D600FFEFE7009C7B
      4A00000000000000000000000000000000000000000000000000000000000000
      00000000000000BD000000FF000000FF000000EF000000940000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000001021000073DE002194FF002194FF00088CFF000052AD00000818000000
      0000000000000000000000000000000000000000000000000000000000000000
      000021000000BD212900F7293900F7293900E72931008C182100100000000000
      0000000000000000000000000000000000000000000000000000000000002918
      0000FFE7D600FFFFFF00FFFFFF00C6946300FFFFF700FFFFFF00FFFFFF00946B
      3900000000000000000000000000000000000000000000000000000000000000
      00000000000031EF31007BFF7B006BFF6B005AFF5A0000E70000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000183900319CFF008CCEFF007BC6FF006BBDFF000084FF00001831000000
      0000000000000000000000000000000000000000000000000000000000000000
      000031000000E7525A00FF949C00FF848C00FF737B00DE293100290000000000
      0000000000000000000000000000000000000000000000000000000000004231
      2900E7CEA500FFFFFF00FFFFFF00C69C7300FFFFFF00FFFFFF00EFE7CE00AD94
      6B00000000000000000000000000000000000000000000000000000000000000
      0000000000004A4A4A0084EF8400BDFFBD005AEF5A0018181800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000063C6007BC6FF00C6E7FF005AB5FF0000396B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000073525200E7949C00FFCECE00E77B7B004A182100000000000000
      0000000000000000000000000000000000000000000000000000000000001818
      2100CEAD7B00F7E7D600FFFFFF00C69C7300FFFFFF00FFFFFF00E7BD8400635A
      5A00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000848484009C9C9C006B6B6B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000299CFF0042A5FF000084FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A58C8C00AD9C9C008C6B6B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008000000CEAD7B00EFCEAD00F7E7CE00EFD6BD00DEB58C00524231000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001818210042312900291800003121100042423900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000C3FF000000000000C1FF000000000000
      31FF00000000000031FF00000000000001FF00000000000000FF000000000000
      827F000000000000F93F000000000000FC83000000000000FE01000000000000
      FF01000000000000FF19000000000000FF19000000000000FF07000000000000
      FF87000000000000FFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF83FFC7FFC7FFC7FF01F
      F83FF83FF83FE00FF01FF01FF01FE00FF01FF01FF01FE00FF01FF01FF01FE00F
      F83FF83FF83FE00FFC7FFC7FFC7FF01FFFFFFFFFFFFFF83FFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ConnectionStateImageList: TImageList
    Height = 20
    Width = 20
    Left = 145
    Top = 311
    Bitmap = {
      494C010103000400040014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000500000001400000001002000000000000019
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000084000000FF000000
      00000000000000FFFF0000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000FFFF00000000000000000000FF0000008C00000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000008C000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000008484
      84007B7B7B007373730073737300737373007373730073737300737373007373
      73007373730073737300737373007B7B7B0084848400000000000000FF000000
      00000000000000FFFF0000000000848484007B7B7B0073737300737373007373
      7300737373007373730073737300737373007373730073737300737373007B7B
      7B00848484000000000000FFFF00000000000000000000FF0000000000008C8C
      8C0084848400848484007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0084848400848484008C8C8C000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000008C8C
      8C00949494009494940094949400949494009494940094949400949494009494
      9400949494009494940094949400949494008C8C8C00000000000000FF000000
      00000000000000FFFF00000000008C8C8C004A00000094949400949494009494
      9400949494009494940094949400949494009494940094949400949494009494
      94008C8C8C000000000000FFFF00000000000000000000FF0000000000009C9C
      9C004A000000A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5
      A500A5A5A500A5A5A500A5A5A5009C9C9C009C9C9C000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000009C9C
      9C00ADADAD00B5B5B5005A00000063000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00630000005A0000005A000000520000009C9C9C00000000000000FF000000
      00000000000000FFFF00000000009C9C9C0052000000B5B5B500BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD0063000000630000005A0000005A000000ADAD
      AD009C9C9C000000000000FFFF00000000000000000000FF000000000000ADAD
      AD005A000000C6C6C600CECECE00CECECE00CECECE00CECECE00CECECE006300
      0000630000006300000063000000B5B5B500ADADAD000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF0000000000ADAD
      AD00630000006B000000EFC67B0073000000EFEFEF00EFEFEF00EFEFEF007300
      0000EFCE7B00EFC67B00D6B56B00BDA5630052000000000000000000FF000000
      00000000000000FFFF0000000000ADADAD0063000000D6D6D600EFEFEF00EFEF
      EF00EFEFEF007300000073000000EFCE7B0073000000EFC67B00D6B56B006300
      0000ADADAD000000000000FFFF00000000000000000000FF000000000000B5B5
      B50063000000E7E7E700EFEFEF00EFEFEF00EFEFEF007B0000007B000000EFCE
      7B007B000000EFCE7B00E7BD730063000000B5B5B5000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000005A00
      000063000000E7C67300FFD68400840000008400000084000000000000008400
      0000FFD684007B000000E7C67300CEAD6B005A000000000000000000FF000000
      00000000000000FFFF0000000000B5B5B50063000000E7E7E700FFFFFF000000
      00008400000084000000FFD68400FFD68400840000007B000000E7C673006300
      0000B5B5B5000000000000FFFF00000000000000000000FF000000000000C6C6
      C6006B000000EFEFEF00FFFFFF00000000008400000084000000FFD68400FFD6
      8400840000007B000000EFCE7B006B000000C6C6C6000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000005A00
      0000CEAD6B00E7C67300FFD68400840000000000000000000000000000008400
      0000FFD684007B00000073000000CEAD6B005A000000000000000000FF000000
      00000000000000FFFF0000000000B5B5B50063000000E7E7E700FFFFFF000000
      000084000000FFD68400FFD68400FFD68400840000007B000000E7C673006300
      0000B5B5B5000000000000FFFF00000000000000000000FF000000000000C6C6
      C6006B000000EFEFEF00FFFFFF000000000084000000FFD68400FFD68400FFD6
      8400840000007B000000EFCE7B006B000000C6C6C6000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000005A00
      0000CEAD6B00E7C67300FFD68400840000000000000000000000000000008400
      0000FFD68400FFD68400E7C67300CEAD6B005A000000000000000000FF000000
      00000000000000FFFF0000000000B5B5B500CECECE0073000000FFFFFF000000
      000084000000FFD68400FFD68400FFD6840084000000FFD68400E7C673006300
      0000B5B5B5000000000000FFFF00000000000000000000FF000000000000C6C6
      C600DEDEDE007B000000FFFFFF000000000084000000FFD68400FFD68400FFD6
      840084000000FFD68400EFCE7B006B000000C6C6C6000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000005A00
      0000CEAD6B00E7C67300FFD68400840000000000000000000000000000008400
      0000FFD68400FFD68400E7C67300CEAD6B005A000000000000000000FF000000
      00000000000000FFFF0000000000B5B5B500CECECE00E7E7E7007B0000008400
      000084000000FFD68400FFD68400FFD6840084000000FFD68400E7C673006300
      0000B5B5B5000000000000FFFF00000000000000000000FF000000000000C6C6
      C600DEDEDE00EFEFEF007B0000008400000084000000FFD68400FFD68400FFD6
      840084000000FFD68400EFCE7B006B000000C6C6C6000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000005A00
      0000CEAD6B00E7C67300FFD68400840000000000000000000000000000008400
      0000FFD684007B000000E7C67300CEAD6B005A000000000000000000FF000000
      00000000000000FFFF0000000000B5B5B500CECECE00E7E7E700FFFFFF000000
      000084000000FFD68400FFD68400FFD68400840000007B000000E7C673006300
      0000B5B5B5000000000000FFFF00000000000000000000FF000000000000C6C6
      C600DEDEDE00EFEFEF00FFFFFF000000000084000000FFD68400FFD68400FFD6
      8400840000007B000000EFCE7B006B000000C6C6C6000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000005A00
      000063000000E7C67300FFD68400840000008400000084000000000000008400
      0000FFD684007B00000073000000CEAD6B005A000000000000000000FF000000
      00000000000000FFFF0000000000B5B5B500CECECE00E7E7E700FFFFFF000000
      00008400000084000000FFD68400FFD68400840000007B000000E7C673006300
      0000B5B5B5000000000000FFFF00000000000000000000FF000000000000C6C6
      C600DEDEDE00EFEFEF00FFFFFF00000000008400000084000000FFD68400FFD6
      8400840000007B000000EFCE7B006B000000C6C6C6000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF0000000000B5B5
      B5006B00000073000000FFE7B500CE9C9C00000000000000000000000000CE9C
      9C00FFF7D600FFE7B500EFCE7B00D6AD6B005A000000000000000000FF000000
      00000000000000FFFF0000000000B5B5B500D6D6D600EFEFEF00000000000000
      000000000000CE9C9C00CE9C9C00FFF7D600CE9C9C00FFE7B500EFCE7B006B00
      0000B5B5B5000000000000FFFF00000000000000000000FF000000000000C6C6
      C600E7E7E700FFFFFF00000000000000000000000000CE9C9C00CE9C9C00FFEF
      CE00CE9C9C00FFEFC600FFD6840073000000C6C6C6000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF0000000000C6C6
      C600DEDEDE00F7F7F700BD737300CE9C9C000000000000000000000000000000
      0000CE9C9C00BD7373007B0000006B000000C6C6C600000000000000FF000000
      00000000000000FFFF0000000000C6C6C600DEDEDE00F7F7F700000000000000
      0000000000000000000000000000CE9C9C00CE9C9C00BD7373007B000000DEDE
      DE00C6C6C6000000000000FFFF00000000000000000000FF000000000000D6D6
      D600F7F7F700000000000000000000000000000000000000000000000000F7EF
      EF00F7EFEF00F7EFEF00C6848400F7F7F700D6D6D6000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF0000000000CECE
      CE00E7E7E700F7F7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00F7F7F700E7E7E700CECECE00000000000000FF000000
      00000000000000FFFF0000000000CECECE00E7E7E700F7F7F700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7F700E7E7
      E700CECECE000000000000FFFF00000000000000000000FF000000000000E7E7
      E700FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00E7E7E7000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF0000000000D6D6
      D600E7E7E700E7E7E700EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEF
      EF00EFEFEF00EFEFEF00E7E7E700E7E7E700D6D6D600000000000000FF000000
      00000000000000FFFF0000000000D6D6D600E7E7E700E7E7E700EFEFEF00EFEF
      EF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00EFEFEF00E7E7E700E7E7
      E700D6D6D6000000000000FFFF00000000000000000000FF000000000000F7F7
      F700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F7F7F7000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000D6000000FF000000
      00000000000000FFFF0000D6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000D6D60000FFFF00000000000000000000FF000000F700000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000F7000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000050000000140000000100010000000000F00000000000000000000000
      000000000000000000000000FFFFFF00C0003C0003C000300000000080001800
      0180001000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000200010000100000000000000E00010000100000000000000E00010
      000100000000000000E00000000000000000000000E000100001000000000000
      00200010000100000000000000E00038000380000000000000F0003E0007E000
      00000000000000000007FE000000000000000000000FFF000000000000000000
      0000000000000000800018000180001000000000C0003C0003C0003000000000
      00000000000000000000000000000000000000000000}
  end
  object Socket: TWSocket
    LineMode = False
    LineLimit = 65536
    LineEnd = #13#10
    LineEcho = False
    LineEdit = False
    OnLineLimitExceeded = SocketLineLimitExceeded
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalPort = '0'
    LastError = 0
    MultiThreaded = False
    MultiCast = False
    MultiCastIpTTL = 1
    ReuseAddr = False
    ComponentOptions = [wsoTcpNoDelay]
    ListenBacklog = 5
    ReqVerLow = 1
    ReqVerHigh = 1
    OnDataAvailable = SocketDataAvailable
    OnSessionConnected = SocketSessionConnected
    OnChangeState = SocketChangeState
    FlushTimeout = 120
    SendFlags = wsSendNormal
    LingerOnOff = wsLingerOn
    LingerTimeout = 0
    KeepAliveOnOff = wsKeepAliveOnSystem
    KeepAliveTime = 30000
    KeepAliveInterval = 1000
    SocksLevel = '5'
    SocksAuthentication = socksNoAuthentication
    Left = 288
    Top = 168
  end
  object KeepAliveTimer: TTimer
    OnTimer = KeepAliveTimerTimer
    Left = 256
    Top = 168
  end
  object ReadyStateImageList: TImageList
    Left = 241
    Top = 311
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C009494940094949400949494009494940094949400949494009C9C
      9C00000000000000000000000000000000000000000000000000000000000000
      0000DEA50000DEAD0000DEB50000DEB50000DEB50000DEAD0000DEB50000DEA5
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C
      9C00000000000000000000000000000000000000000000000000000000000000
      0000E7AD0000E7C60000E7DE0000E7E70000E7E70000E7E70000E7CE0000E7B5
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A5A5A5009C9C9C009494940094949400949494009C9C9C00A5A5A500A5A5
      A500000000000000000000000000000000000000000000000000000000000000
      0000E7B50000EFEF0000F7F70000F7F70000F7F70000F7F70000EFEF0000E7BD
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A5A5A500A5A5A5009C9C9C00949494009C9C9C00A5A5A500A5A5A500A5A5
      A500000000000000000000000000000000000000000000000000000000000000
      0000EFBD0000F7F70000FFFF0000FFFF0000FFFF0000FFFF0000F7F70000EFCE
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A5A5A500ADADAD00A5A5A500B5B5B500B5B5B5009C9C9C00A5A5A500A5A5
      A500000000000000000000000000000000000000000000000000000000000000
      0000F7C60000FFFF0000FFFF0000FFFF9400FFFF9400FFFF0000FFFF0000F7CE
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000ADADAD00ADADAD00BDBDBD00D6D6D600D6D6D600BDBDBD00A5A5A500ADAD
      AD00000000000000000000000000000000000000000000000000000000000000
      0000F7C60000FFFF0000FFFF9C00FFFFDE00FFFFDE00FFFF9400FFFF0000F7C6
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000ADADAD00B5B5B500CECECE00DEDEDE00DEDEDE00CECECE00B5B5B500ADAD
      AD00000000000000000000000000000000000000000000000000000000000000
      0000FFC60000FFE70000FFFFAD00FFFFD600FFFFD600FFFFAD00FFEF0000FFD6
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B5B5B500B5B5B500C6C6C600CECECE00CECECE00C6C6C600B5B5B500B5B5
      B500000000000000000000000000000000000000000000000000000000000000
      0000FFBD0000FFBD2100FFDE9400FFE7AD00FFE7AD00FFDE9400FFCE2100FFBD
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000E007E00700000000E007E00700000000E007E00700000000
      E007E00700000000E007E00700000000E007E00700000000E007E00700000000
      E007E00700000000E007E00700000000E007E00700000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object BattleStatusImageList: TImageList
    Left = 273
    Top = 311
    Bitmap = {
      494C010112001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000FFF70000DED60000DED600005A5A00008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      730000006B000000630000006300000063000000630000006300000063000000
      6B00000073000000000000000000000000000000000000000000000000000000
      000000000000000000000084840000FFF700005A5A0000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      9400000094000000940000009400000094000000940000009400000094000000
      9400000094000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000DED6000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      B5000000C6000000B500000018000000310000006B000000420000005A000000
      C6000000B5000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000DED6000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CE000000DE000000EF000000390000007B000000F7000000F700000084000000
      DE000000CE000000000000000000000000000000000000000000000000000000
      000000000000000000000084840000FFF700005A5A0000848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CE000000E7000000F7000000390000007B000000FF000000FF000000F7000000
      E7000000CE000000000000000000000000000000000000000000000000000000
      00000000000000848400ADFFFF0000FFF70000DED600005A5A00008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CE000000E7000000FF000000390000007B000000FF000000FF000000FF000000
      E7000000CE000000000000000000000000000000000000000000000000000000
      00000084840000848400ADFFFF0000FFF70000DED600005A5A00008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      D6000000EF000000FF000000390008087B001010FF001010FF000000FF000000
      EF000000D6000000000000000000000000000000000000000000000000000084
      84000000000000848400ADFFFF0000FFF70000DED600005A5A00008484000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      E7000008FF002129CE0008081800101039003939DE004242FF002931FF000008
      FF000000E7000000000000000000000000000000000000000000000000000084
      84000000000000848400ADFFFF0000FFF70000DED600005A5A00008484000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF003942FF006363FF007373FF007373FF007373FF007373FF006363FF003942
      FF000000FF000000000000000000000000000000000000000000000000000084
      84000000000000848400ADFFFF0000FFF70000DED600005A5A00008484000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003939
      FF00636BFF007B84FF00848CFF008C8CFF008C8CFF00848CFF007B84FF00636B
      FF003939FF000000000000000000000000000000000000000000000000000084
      84000084840000848400ADFFFF0000FFF70000DED600005A5A00008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000313131005A5A
      5A00737373007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007373
      73005A5A5A003131310000000000000000000000000000000000000000000000
      0000000000000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008494A5006B8C9C005A7B94005A849C005A849C0052738C00526B
      7B000000000000000000000000000000000000000000B5B5B500181818000000
      0000000000000000000000000000001818000018180000000000000000000000
      00000000000018181800B5B5B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008CA5BD00ADD6EF0094C6E7008CC6E70073ADD6007BADCE006B94
      AD0000000000000000000000000000000000000000001018180021B5B50029DE
      DE0029DEDE0029DEDE0029DEDE00189494001894940021DEDE0010DEDE0008DE
      DE0000DEDE0000B5B50010181800000000000000000000000000000000000073
      0000006B0000006300000063000000630000006300000063000000630000006B
      0000007300000000000000000000000000000000000000000000000000000063
      730000526B000052630000526300005263000052630000526300005263000052
      6B00006373000000000000000000000000000000000000000000000000000000
      0000ADBDCE00BDDEF700B5DEFF0094D6F7008CCEF7006BB5DE007BBDE700639C
      BD006394AD0000000000000000000000000000000000A5A5A500298C8C004AFF
      FF0042FFFF0042FFFF0042FFFF00296363001052520031FFFF0021FFFF0018FF
      FF0008FFFF00088C8C00A5A5A500000000000000000000000000000000000094
      0000009400000094000000940000009400000094000000940000009400000094
      000000940000000000000000000000000000000000000000000000000000007B
      9C00007B9C00007B9C00007B9C00007B9400007B9400007B9C00007B9C00007B
      9C00007B9C00000000000000000000000000000000000000000000000000ADBD
      C600BDCEDE00D6F7FF00ADE7FF008CD6FF0084D6FF0073C6F70073C6EF0084C6
      EF00427B9C000000000000000000000000000000000000000000737B7B004AE7
      E70052FFFF0052FFFF0052FFFF004AFFFF0042FFFF0039FFFF0029FFFF0021FF
      FF0010E7E7006B7B7B00000000000000000000000000000000000000000000B5
      000000C6000000B500000018000000310000006B000000420000005A000000C6
      000000B500000000000000000000000000000000000000000000000000000094
      B50000A5C6000094B500001018000029310000526B0000314200004A5A0000A5
      C6000094B500000000000000000000000000000000000000000000000000A5AD
      B500CEE7EF0084A5BD00ADDEFF009CE7FF0084D6FF0084D6FF0073C6EF0084C6
      E700317394000000000000000000000000000000000000000000EFEFEF00296B
      6B006BFFFF0063FFFF0063FFFF00319C9C00299C9C004AFFFF0031FFFF0029FF
      FF00106B6B00EFEFEF00000000000000000000000000000000000000000000CE
      000000DE000000EF000000390000007B000000F7000000F700000084000000DE
      000000CE000000000000000000000000000000000000000000000000000000A5
      CE0000B5DE0000C6EF000031390000637B0000CEF70000CEF700006B840000B5
      DE0000A5CE00000000000000000000000000000000000000000000000000ADAD
      B500D6DEE7009CB5CE00B5E7FF0094DEFF0094E7FF007BCEFF007BCEEF008CCE
      EF00427B9C000000000000000000000000000000000000000000000000008484
      84005ACECE0073FFFF0073FFFF00296363002163630052FFFF0042FFFF0021CE
      CE008484840000000000000000000000000000000000000000000000000000CE
      000000E7000000F7000000390000007B000000FF000000FF000000F7000000E7
      000000CE000000000000000000000000000000000000000000000000000000AD
      CE0000BDE70000CEFF0000313900006B7B0000D6FF0000D6FF0000CEFF0000BD
      E70000ADCE00000000000000000000000000000000000000000000000000ADAD
      B500D6DEE70094ADBD00B5DEF700ADEFFF0094DEFF00A5EFFF008CD6F7008CC6
      DE006394AD00000000000000000000000000000000000000000000000000FFFF
      FF003963630084FFFF007BFFFF00214A4A00184A4A005AFFFF0042FFFF002163
      6300FFFFFF0000000000000000000000000000000000000000000000000000CE
      000000E7000000FF000000390000007B000000FF000000FF000000FF000000E7
      000000CE000000000000000000000000000000000000000000000000000000AD
      D60000BDE70000CEFF0000313900006B7B0000D6FF0000D6FF0000CEFF0000BD
      E70000ADD600000000000000000000000000000000000000000000000000B5B5
      B500D6DEDE0094ADB500CEEFFF0052849C009CD6EF00397394008CC6DE00638C
      A500C6E7FF000000000000000000000000000000000000000000000000000000
      00009C9C9C0063B5B5008CFFFF00294242001842420063FFFF0031B5B500A5A5
      A5000000000000000000000000000000000000000000000000000000000000D6
      000000EF000000FF000000390000087B080010FF100010FF100000FF000000EF
      000000D6000000000000000000000000000000000000000000000000000000AD
      D60000C6EF0000D6FF0000313900086B7B0010D6FF0010D6FF0000D6FF0000C6
      EF0000ADD600000000000000000000000000000000000000000000000000B5AD
      AD00ADB5B500ADBDBD00B5CEDE0052849400ADDEF7004A7B9400C6EFFF005273
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000425A5A008CFFFF00314A4A00294242005AFFFF00395A5A000000
      00000000000000000000000000000000000000000000000000000000000000E7
      000000FF000021CE2100081808001039100039DE390042FF420029FF290000FF
      000000E7000000000000000000000000000000000000000000000000000000BD
      E70000D6FF0021B5CE00081818001031390039C6DE0042DEFF0029DEFF0000D6
      FF0000BDE7000000000000000000000000000000000000000000000000000000
      0000000000009CA5AD00D6EFFF0063849400BDDEEF005A7B8C00ADCEDE007B8C
      9400000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD004AADAD004A7B7B00397B7B0039ADAD00BDBDBD000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000039FF390063FF630073FF730073FF730073FF730073FF730063FF630039FF
      390000FF000000000000000000000000000000000000000000000000000000D6
      FF0039DEFF0063E7FF0073E7FF0073E7FF0073E7FF0073E7FF0063E7FF0039DE
      FF0000D6FF000000000000000000000000000000000000000000000000000000
      000000000000A5ADB500CEDEEF006B849400C6DEEF006B849400C6D6E700636B
      7300000000000000000000000000000000000000000000000000000000000000
      000000000000000000005263630063F7F7005AF7F7004A636300000000000000
      00000000000000000000000000000000000000000000000000000000000039FF
      390063FF63007BFF7B0084FF84008CFF8C008CFF8C0084FF84007BFF7B0063FF
      630039FF390000000000000000000000000000000000000000000000000039DE
      FF0063E7FF007BEFFF0084EFFF008CEFFF008CEFFF0084EFFF007BEFFF0063E7
      FF0039DEFF000000000000000000000000000000000000000000000000000000
      000000000000A5ADB500D6E7F70063738400D6EFFF006B7B8C00D6DEEF008484
      8C00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DEDEDE003184840031848400DEDEDE00000000000000
      0000000000000000000000000000000000000000000000000000313131005A5A
      5A00737373007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007373
      73005A5A5A003131310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5B5BD009CA5B500A5B5C6008C9CAD00A5ADBD009CA5AD007B7B
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000525252005252520000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00F7F7FF00EFEFFF00D6D6FF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      F70000000000FFFFF700FFFFEF00FFF7DE00FFE7B50000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFFF
      FF0000000000EFFFFF00B5FFFF008CF7FF0000EFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00F7F7FF00EFEFFF00D6D6FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF00F7F7FF00EFEFFF00DEDEFF00D6D6FF009C9CFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFF7000000
      0000FFFFF700FFF7E700FFF7D600FFEFC600FFE7AD00F7D66B00000000000000
      0000000000000000000000000000000000000000000000000000DEFFFF000000
      0000DEFFFF00B5FFFF008CF7FF0039F7FF0000EFFF0000CED600000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF00F7F7FF00EFEFFF00DEDEFF00D6D6FF009C9CFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00F7F7FF00EFEFFF00D6D6FF00CEC6FF00BDBDFF00ADA5FF008484FF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      F700ADAD9C00524A42005A5A4A00FFE7AD00FFDE9400F7D67B00F7C64A000000
      0000000000000000000000000000000000000000000000000000F7FFFF00D6FF
      FF00638C9400294A5200188C940000EFF70000DEEF0000D6DE0000B5BD000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF008C8C94004A4A52007B7B9400CEC6FF00BDBDFF00ADA5FF008484FF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00F7F7
      FF00EFEFFF00D6D6FF00CEC6FF00B5B5FF00ADA5FF009C9CFF008484FF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFF700FFF7
      E700FFEFCE0010101000FFE7A500FFDE9400F7D67B00F7CE6300F7C64A000000
      00000000000000000000000000000000000000000000F7FFFF00CEFFFF00A5F7
      FF0042B5BD00104A520000E7F70000DEEF0000D6DE0000C6CE0000B5BD000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00F7F7
      FF00B5B5C60042425200CEC6FF00B5B5FF00ADA5FF009C9CFF008484FF000000
      00000000000000000000000000000000000000000000F7F7FF00EFEFFF00DEDE
      FF00D6D6FF00CEC6FF00B5ADFF00ADA5FF009494FF008484FF007B73FF000000
      00000000000000000000000000000000000000000000FFFFEF00FFF7DE00FFEF
      CE00FFEFBD00101010003129210031291800AD8C4200F7C64A00F7BD31000000
      00000000000000000000000000000000000000000000C6FFFF008CF7FF0052F7
      FF0018B5BD0010101000102929001039390000ADB50000B5BD0000ADB5000000
      00000000000000000000000000000000000000000000F7F7FF00EFEFFF00DEDE
      FF00A59CC6001010100021213100292942008484DE008484FF007B73FF000000
      00000000000000000000000000000000000000000000EFEFFF00DEDEFF00D6D6
      FF00CEC6FF00B5ADFF009C9CFF00948CFF008484FF007B73FF006B63FF000000
      00000000000000000000000000000000000000000000FFF7DE00FFEFCE00FFE7
      B500FFE7A50010101000F7D673008C7339008C732900F7BD3100F7BD21000000
      000000000000000000000000000000000000000000008CF7FF0042F7FF0000EF
      FF0008ADB500104A4A0000CED60010424200088C940000ADB50000A5AD000000
      00000000000000000000000000000000000000000000EFEFFF00DEDEFF00D6D6
      FF009C94C600393952009C9CFF00313152006363C6007B73FF006B63FF000000
      00000000000000000000000000000000000000000000DEDEFF00D6D6FF00BDBD
      FF00B5ADFF009C9CFF00948CFF007B7BFF007B73FF006B63FF006363FF000000
      00000000000000000000000000000000000000000000FFEFC600FFE7B500FFE7
      9C00F7DE840010101000AD8C4200393118008C6B2100F7B51800F7B518000000
      0000000000000000000000000000000000000000000042F7FF0000EFFF0000E7
      EF0008A5AD0010212100089494001018210008848400009CA500009CA5000000
      00000000000000000000000000000000000000000000DEDEFF00D6D6FF00BDBD
      FF008C84C600181821006B6BC600181821005A5AC6006B63FF006363FF000000
      00000000000000000000000000000000000000000000D6D6FF00BDBDFF00B5AD
      FF009C9CFF00948CFF007B7BFF00736BFF00635AFF005A52FF005A52FF000000
      00000000000000000000000000000000000000000000FFE7AD00FFDE9C00F7D6
      8400AD944A005A4A29005A4A2100A5842100F7B51800F7B50800F7B508000000
      0000000000000000000000000000000000000000000000EFFF0000E7EF0000D6
      DE0008737B0008525A001039420000949C00009CA50000949C0000949C000000
      00000000000000000000000000000000000000000000D6D6FF00BDBDFF00B5AD
      FF005A5A94004242730029295200635ADE00635AFF005A52FF005A52FF000000
      0000000000000000000000000000000000000000000000000000ADA5FF009C9C
      FF008C84FF007B73FF00736BFF00635AFF005A52FF005A52FF00000000000000
      0000000000000000000000000000000000000000000000000000F7D67B00F7CE
      6300F7C65200F7C63900F7BD2900F7B51800F7B50800F7B50000000000000000
      000000000000000000000000000000000000000000000000000000D6DE0000C6
      D60000BDC60000ADB50000A5AD00009CA50000949C0000949C00000000000000
      0000000000000000000000000000000000000000000000000000ADA5FF009C9C
      FF008C84FF007B73FF00736BFF00635AFF005A52FF005A52FF00000000000000
      0000000000000000000000000000000000000000000000000000000000009C9C
      FF007B73FF00736BFF00635AFF005A52FF00635AFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7CE
      6300F7BD3900F7BD2100F7B51000F7B50800F7B5100000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000C6
      D60000ADB50000A5AD000094A50000949C0000949C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C9C
      FF007B73FF00736BFF00635AFF005A52FF00635AFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000063
      730000526B000052630000526300005263000052630000526300005263000052
      6B00006373000000000000000000000000000000000000000000000000000000
      730000006B000000630000006300000063000000630000006300000063000000
      6B00000073000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000007B
      9C00007B9C00007B9C00007B9C00007B9400007B9400007B9C00007B9C00007B
      9C00007B9C000000000000000000000000000000000000000000000000000000
      9400000094000000940000009400000094000000940000009400000094000000
      9400000094000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000094
      B50000A5C600007B940000000000000000000031390000ADD60000ADCE0000A5
      C6000094B5000000000000000000000000000000000000000000000000000000
      B5000000C600000094000000000000000000000039000000D6000000CE000000
      C6000000B500000000000000000000000000000000000000000000000000FFFF
      F70000000000FFFFF700FFFFEF00FFF7DE00FFE7B50000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFFF
      FF0000000000EFFFFF00B5FFFF008CFFFF0000F7FF0000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000A5
      CE0000B5DE0000C6EF00006B8400006B840000CEF70000CEF70000C6EF0000B5
      DE0000A5CE000000000000000000000000000000000000000000000000000000
      CE000000DE000000EF0000008400000084000000F7000000F7000000EF000000
      DE000000CE000000000000000000000000000000000000000000FFFFF7000000
      0000FFFFF700FFF7E700FFF7D600FFEFC600FFE7AD00F7D66B00000000000000
      0000000000000000000000000000000000000000000000000000DEFFFF000000
      0000DEFFFF00B5FFFF008CFFFF0039F7FF0000F7FF0000CED600000000000000
      00000000000000000000000000000000000000000000000000000000000000AD
      CE0000BDE70000CEFF0000738C0000000000000000000039420000A5C60000BD
      E70000ADCE000000000000000000000000000000000000000000000000000000
      CE000000E7000000F700000084000000000000000000000042000000C6000000
      E7000000CE000000000000000000000000000000000000000000FFFFFF00FFFF
      F700FFF7E700FFF7D600FFEFBD00FFE7AD00FFDE9400F7D67B00F7C64A000000
      0000000000000000000000000000000000000000000000000000FFFFFF00D6FF
      FF00A5FFFF0063F7FF0018F7FF0000EFFF0000E7EF0000D6DE0000B5C6000000
      00000000000000000000000000000000000000000000000000000000000000AD
      D60000BDE70000CEFF0000738C0000738C0000D6FF00007B9C000052630000BD
      E70000ADD6000000000000000000000000000000000000000000000000000000
      CE000000E7000000FF000000840000008C000000FF0000009C00000063000000
      E7000000CE0000000000000000000000000000000000FFFFFF00FFFFF700FFF7
      E700FFEFCE00FFEFBD00FFE7A500FFDE9400F7D67B00F7CE6300F7C64A000000
      00000000000000000000000000000000000000000000FFFFFF00CEFFFF00A5FF
      FF0052F7FF0018F7FF0000EFF70000DEEF0000D6DE0000C6CE0000B5C6000000
      00000000000000000000000000000000000000000000000000000000000000AD
      D60000C6EF0000C6F700005A6B00005A6B0000A5CE00005A6B0000526B0000C6
      EF0000ADD6000000000000000000000000000000000000000000000000000000
      D6000000EF000000EF0000086300080863000810BD0000086300000063000000
      EF000000D60000000000000000000000000000000000FFFFEF00FFF7DE00FFEF
      CE00FFEFBD00FFE7A500FFDE8C00F7D67300F7CE6300F7C64A00F7BD31000000
      00000000000000000000000000000000000000000000C6FFFF008CFFFF0052F7
      FF0010F7FF0000EFF70000DEE70000D6DE0000C6CE0000B5BD0000ADB5000000
      00000000000000000000000000000000000000000000000000000000000000BD
      E70000D6FF0000C6F700004252000042520000425200007B940018D6FF0000D6
      FF0000BDE7000000000000000000000000000000000000000000000000000000
      E7000008FF002129CE00101042001010420010104200181873002929EF000008
      FF000000E70000000000000000000000000000000000FFF7DE00FFEFCE00FFE7
      B500FFE7A500FFDE8C00F7D67300F7CE5A00F7C64200F7BD3100F7BD21000000
      000000000000000000000000000000000000000000008CFFFF0042F7FF0000F7
      FF0000E7F70000D6E70000CED60000C6CE0000B5BD0000ADB50000A5AD000000
      00000000000000000000000000000000000000000000000000000000000000D6
      FF0039DEFF0063E7FF0073E7FF0073E7FF0073E7FF0073E7FF0063E7FF0039DE
      FF0000D6FF000000000000000000000000000000000000000000000000000000
      FF003942FF006363FF007373FF007373FF007373FF007373FF006363FF003942
      FF000000FF0000000000000000000000000000000000FFEFC600FFE7B500FFE7
      9C00F7DE8400F7D66B00F7CE5A00F7C64200F7BD3100F7B51800F7B518000000
      0000000000000000000000000000000000000000000042F7FF0000F7FF0000E7
      F70000D6E70000CED60000BDCE0000B5BD0000ADB500009CA500009CA5000000
      00000000000000000000000000000000000000000000000000000000000039DE
      FF0063E7FF007BEFFF0084EFFF008CEFFF008CEFFF0084EFFF007BEFFF0063E7
      FF0039DEFF000000000000000000000000000000000000000000000000003939
      FF00636BFF007B84FF00848CFF008C8CFF008C8CFF00848CFF007B84FF00636B
      FF003939FF0000000000000000000000000000000000FFE7AD00FFDE9C00F7D6
      8400F7D66B00F7CE5200F7C64200F7BD2900F7B51800F7B50800F7B508000000
      0000000000000000000000000000000000000000000000F7FF0000E7F70000D6
      E70000CED60000BDC60000B5BD0000ADB500009CA50000949C0000949C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000313131005A5A
      5A00737373007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007373
      73005A5A5A003131310000000000000000000000000000000000F7D67B00F7CE
      6300F7C65200F7C63900F7BD2900F7B51800F7B50800F7B50000000000000000
      000000000000000000000000000000000000000000000000000000D6DE0000CE
      D60000BDC60000B5BD0000A5AD00009CA50000949C0000949C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7CE
      6300F7BD3900F7BD2100F7B51000F7B50800F7B5100000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000CE
      D60000ADB50000A5AD00009CA50000949C0000949C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000073
      0000006B0000006300000063000000630000006300000063000000630000006B
      0000007300000000000000000000000000000000000000000000000000000063
      730000526B000052630000526300005263000052630000526300005263000052
      6B00006373000000000000000000000000000000000000000000000000000000
      730000006B000000630000006300000063000000630000006300000063000000
      6B00000073000000000000000000000000000000000000000000000000000073
      0000006B0000006300000063000000630000006300000063000000630000006B
      0000007300000000000000000000000000000000000000000000000000000094
      0000009400000094000000940000009400000094000000940000009400000094
      000000940000000000000000000000000000000000000000000000000000007B
      9C00007B9C00007B9C00007B9C00007B9400007B9400007B9C00007B9C00007B
      9C00007B9C000000000000000000000000000000000000000000000000000000
      9400000094000000940000009400000094000000940000009400000094000000
      9400000094000000000000000000000000000000000000000000000000000094
      0000009400000094000000940000009400000094000000940000009400000094
      00000094000000000000000000000000000000000000000000000000000000B5
      000000C6000000CE000000D6000000D6000000D6000000D6000000CE000000C6
      000000B500000000000000000000000000000000000000000000000000000094
      B50000A5C60000ADCE0000ADD60000ADD60000ADD60000ADD60000ADCE0000A5
      C6000094B5000000000000000000000000000000000000000000000000000000
      B5000000C6000000CE000000D6000000D6000000D6000000D6000000CE000000
      C6000000B50000000000000000000000000000000000000000000000000000B5
      000000C600000094000000000000000000000039000000D6000000CE000000C6
      000000B5000000000000000000000000000000000000000000000000000000CE
      000000DE000000EF000000F7000000F7000000F7000000F7000000EF000000DE
      000000CE000000000000000000000000000000000000000000000000000000A5
      CE0000B5DE0000C6EF0000CEF70000CEF70000CEF70000CEF70000C6EF0000B5
      DE0000A5CE000000000000000000000000000000000000000000000000000000
      CE000000DE000000EF000000F7000000F7000000F7000000F7000000EF000000
      DE000000CE0000000000000000000000000000000000000000000000000000CE
      000000DE000000EF0000008400000084000000F7000000F7000000EF000000DE
      000000CE000000000000000000000000000000000000000000000000000000CE
      000000E7000000F7000000FF000000FF000000FF000000FF000000F7000000E7
      000000CE000000000000000000000000000000000000000000000000000000AD
      CE0000BDE70000CEFF0000D6FF0000D6FF0000D6FF0000D6FF0000CEFF0000BD
      E70000ADCE000000000000000000000000000000000000000000000000000000
      CE000000E7000000F7000000FF000000FF000000FF000000FF000000F7000000
      E7000000CE0000000000000000000000000000000000000000000000000000CE
      000000E7000000F700000084000000000000000000000042000000C6000000E7
      000000CE000000000000000000000000000000000000000000000000000000CE
      000000E7000000FF000000FF000000FF000000FF000000FF000000FF000000E7
      000000CE000000000000000000000000000000000000000000000000000000AD
      D60000BDE70000CEFF0000D6FF0000D6FF0000D6FF0000D6FF0000CEFF0000BD
      E70000ADD6000000000000000000000000000000000000000000000000000000
      CE000000E7000000FF000000FF000000FF000000FF000000FF000000FF000000
      E7000000CE0000000000000000000000000000000000000000000000000000CE
      000000E7000000FF000000840000008C000000FF0000009C00000063000000E7
      000000CE000000000000000000000000000000000000000000000000000000D6
      000000EF000000FF000010FF100010FF100010FF100010FF100000FF000000EF
      000000D6000000000000000000000000000000000000000000000000000000AD
      D60000C6EF0000D6FF0010D6FF0010D6FF0010D6FF0010D6FF0000D6FF0000C6
      EF0000ADD6000000000000000000000000000000000000000000000000000000
      D6000000EF000000FF001010FF001010FF001010FF001010FF000000FF000000
      EF000000D60000000000000000000000000000000000000000000000000000D6
      000000EF000000EF0000006300000863080008BD0800006300000063000000EF
      000000D6000000000000000000000000000000000000000000000000000000E7
      000000FF000029FF290042FF420042FF420042FF420042FF420029FF290000FF
      000000E7000000000000000000000000000000000000000000000000000000BD
      E70000D6FF0029DEFF0042DEFF0042DEFF0042DEFF0042DEFF0029DEFF0000D6
      FF0000BDE7000000000000000000000000000000000000000000000000000000
      E7000008FF002931FF004242FF004242FF004242FF004242FF002931FF000008
      FF000000E70000000000000000000000000000000000000000000000000000E7
      000000FF000021CE21001042100010421000104210001873180029EF290000FF
      000000E7000000000000000000000000000000000000000000000000000000FF
      000039FF390063FF630073FF730073FF730073FF730073FF730063FF630039FF
      390000FF000000000000000000000000000000000000000000000000000000D6
      FF0039DEFF0063E7FF0073E7FF0073E7FF0073E7FF0073E7FF0063E7FF0039DE
      FF0000D6FF000000000000000000000000000000000000000000000000000000
      FF003942FF006363FF007373FF007373FF007373FF007373FF006363FF003942
      FF000000FF0000000000000000000000000000000000000000000000000000FF
      000039FF390063FF630073FF730073FF730073FF730073FF730063FF630039FF
      390000FF000000000000000000000000000000000000000000000000000039FF
      390063FF63007BFF7B0084FF84008CFF8C008CFF8C0084FF84007BFF7B0063FF
      630039FF390000000000000000000000000000000000000000000000000039DE
      FF0063E7FF007BEFFF0084EFFF008CEFFF008CEFFF0084EFFF007BEFFF0063E7
      FF0039DEFF000000000000000000000000000000000000000000000000003939
      FF00636BFF007B84FF00848CFF008C8CFF008C8CFF00848CFF007B84FF00636B
      FF003939FF0000000000000000000000000000000000000000000000000039FF
      390063FF63007BFF7B0084FF84008CFF8C008CFF8C0084FF84007BFF7B0063FF
      630039FF39000000000000000000000000000000000000000000313131005A5A
      5A00737373007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007373
      73005A5A5A003131310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000313131005A5A
      5A00737373007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007373
      73005A5A5A003131310000000000000000000000000000000000313131005A5A
      5A00737373007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007373
      73005A5A5A003131310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      C003F81F00000000C003FC3F00000000C003FE7F00000000C003FE7F00000000
      C003FC3F00000000C003F81F00000000C003F00F00000000C003E81700000000
      C003E81700000000C003E81700000000C003E00700000000C003F81F00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      F80F8001C003C003F80F8001C003C003F0078001C003C003E007C003C003C003
      E007C003C003C003E007E007C003C003E007E007C003C003E007F00FC003C003
      E00FF81FC003C003F80FF81FC003C003F80FFC3FC003C003F80FFC3FC003C003
      F80FFE7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFF9FFF9FFF9
      FFF1FFF1FFF1FFF1FFE3FFE3FFE3FFE3E047E047E047E047C80FC80FC80FC80F
      901F901F901F901F400F400F400F400F000F000F000F000F000F000F000F000F
      000F000F000F000F000F000F000F000F000F000F000F000F801F801F801F801F
      C03FC03FC03FC03FE07FE07FE07FE07FFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFF9
      C003C003FFF1FFF1C003C003FFE3FFE3C003C003E047E047C003C003C80FC80F
      C003C003901F901FC003C003400F400FC003C003000F000FC003C003000F000F
      C003C003000F000FC003C003000F000FC003C003000F000FC003C003801F801F
      FFFFFFFFC03FC03FFFFFFFFFE07FE07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      C003C003C003C003C003C003C003C003C003C003C003C003C003C003C003C003
      C003C003C003C003C003C003C003C003C003C003C003C003C003C003C003C003
      C003C003C003C003C003C003C003C003C003C003C003C003C003C003C003C003
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object SyncImageList: TImageList
    Left = 305
    Top = 311
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000008080800080808000808080000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000218484002184840010848C0010848C0021848400218484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000428C7300428C7300428C7300428C7300428C7300428C73000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002139AD001831A50018298C00182994002131940029397B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002184
      8400108C940010949C0010848C0008B5AD0008D6CE0010BDBD0010949C00108C
      9400218484000000000000000000000000000000000000000000000000000094
      6B0000946B0000946300003931000010000000735200008C6300008C6300008C
      630000845A000000000000000000000000000000000000000000000000002139
      A5001831C6001831CE001831CE002142DE00214ADE002142D6002142D6001029
      9C00183194000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000010949C00109C
      9C00109CA50010A5AD0008C6C600007B7B000039390008EFE70010A5AD00109C
      A500109C9C0010949C0000000000000000000000000000000000008C5A00008C
      5A00008C5A00006B4200000000000000000000000000008C5A00008C5A000084
      52000084520000845200000000000000000000000000000000001829AD001021
      C6000821DE000810B5000010EF000010EF000010EF000010EF000010E7000010
      E7000818C6000810730000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000010A5A50010A5
      AD0010B5BD0018BDC60010C6CE0008DED60008CEC60010D6D60018BDC60010B5
      BD0010A5AD0010A5A50000000000000000000000000000000000009C6300009C
      630000420800000000000000000000392100000000000000000000945A000094
      5A00008C5A00008C5200000000000000000000000000000000000810C6000810
      DE0018107B0021184A00181084000000EF000800CE0018106B000000C6000000
      E7000810DE000810DE0008104A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000010A5AD0010ADB50018BD
      C60018C6CE0018CED60018D6DE0008CEC600089C940010F7EF0010DEDE0018C6
      CE0018BDC60010ADB50010A5AD00000000000000000000A5630000A5630000A5
      630000AD6300004A18000063310000AD6B00006342000000000000000000009C
      630000945A0000945A00008C520000000000000000001010C6001010DE001000
      E7001000B50010083900181031001000A5001810310018103100181073001000
      E7001000E7001000E7001010DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000018B5BD0018BDC60018CE
      D60018D6DE0018D6DE0018DEE70008BDB500001818000039390010F7EF0018D6
      DE0018CED60018BDC60018B5BD00000000000000000000AD630000AD6B0000B5
      6B0000B56B0000BD730000BD730000BD730000BD730000844A00000000000000
      0000008C5200009C6300009C5A0000000000000000001000EF001000EF001000
      EF001000EF001000E7001010390018103100100842001000D6001000EF001000
      EF001000EF001000EF001000EF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000018C6C60018CED60018D6
      DE005AE7EF0073E7EF0063E7EF0031F7EF0008EFE70000181800007B7B0031F7
      EF0018D6DE0018CED60018C6C600000000000000000000B56B0000BD6B0000BD
      730000C6730000DE840010DE8C0018DE940008DE8C0000C6730000A55A00004A
      3100000000000063310000A5630000000000000000001000F7001000FF001000
      FF001000FF001000DE001810310018103100181039001000E7001000FF001000
      FF001000FF001000FF001000F700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000021CED60021D6DE0029DE
      E7008CEFF700BDF7F700BDF7F70094F7F70042FFF700004A4A000039390029F7
      EF0029DEE70021D6DE0021CED600000000000000000000BD730000C6730000D6
      7B0021DE94004AE7A50063EFB50063EFB5005AE7AD0031E79C0000DE840000C6
      73000084420000000000007B390000000000000000002108FF002110FF003939
      FF002110FF0021184A0021214A001808EF0021184A00211842002918B5002110
      FF003939FF002110FF002110FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003131310021D6DE0029DE
      E7008CEFF700BDF7F700BDF7F70094F7F70042FFF700004A4A000039390029F7
      EF0029DEE70021D6DE003131310000000000000000000000000000C6730000D6
      7B0021DE94004AE7A50063EFB50063EFB5005AE7AD0031E79C0000DE840000C6
      730000C6730000844200000000000000000000000000000000003939FF003939
      FF003939FF0052428C004A39D6004242FF002929FF004A429C002929F7003939
      FF003939FF003939FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000029D6DE0029DE
      E70073EFEF00ADF7F7005AFFF70008CEC600005A5A000000000008ADA50042DE
      DE0029DEE70029D6DE000000000000000000000000000000000000DE8C0029E7
      A50052EFB5007BEFC6008CF7CE0094F7CE0084EFCE0063EFBD0039E7A50000DE
      8C0000C67B0000BD7300000000000000000000000000313131003939FF003939
      FF003939FF002918FF003929F7003929FF003929FF003121FF002918FF003939
      FF003939FF003939FF0031313100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000029DE
      E70039DEE70052EFEF0008CEC60000000000004A4A0008BDB50031F7EF0039DE
      E70029DEE70000000000000000000000000000000000000000000000000052EF
      BD0073EFCE0094F7D600A5F7DE00A5F7DE009CF7D6007BF7CE0052EFBD0021E7
      AD0000CE8C000000000000000000000000000000000000000000000000003939
      FF003939FF003942FF005252FF00525AFF005252FF004A4AFF003942F7003939
      FF003939FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084EFF70042FFF70008FFF70039FFF7006BF7F70084EFF7000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B5F7E700C6FFE700C6FFE700BDFFE700ADF7DE0094F7D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B94FF007B94EF00849CF7007B94EF00738CF7007B94FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000F81FF81FF81F0000
      E007E007E0070000C003C003C003000080018001800100008001800180010000
      0000000000000000000000000000000000000000000000000000000000000000
      80018001800100008001800180010000C003C003C0030000E007E007E0070000
      F81FF81FF81F0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object ApplicationEvents1: TApplicationEvents
    OnActivate = ApplicationEvents1Activate
    OnDeactivate = ApplicationEvents1Deactivate
    OnMessage = ApplicationEvents1Message
    OnShortCut = ApplicationEvents1ShortCut
    Left = 216
    Top = 168
  end
  object OpenDialog1: TOpenDialog
    Left = 112
    Top = 168
  end
  object RanksImageList: TImageList
    Left = 337
    Top = 311
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6C6
      C600C6ADAD00DECECE00DED6DE00D6BDBD00D6C6C600CEBDB500C6A59C00BD9C
      9400FFF7F70000000000000000000000000000000000000000000000000000AD
      DE00008CDE0000B5E70000B5E700009CDE0000A5DE00009CDE000084D6000073
      D60073CEEF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7EFEF00DEC6
      CE00D6B5B500BDA5A500CEADAD00D6B5B500C6A5A500BD9C9C00C6ADAD00CEAD
      AD0000000000000000000000000000000000000000000000000031C6E70018C6
      EF006BE7F70042DEF70063E7F70063E7F70052DEF70042DEF70052E7F700008C
      DE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009494
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFF7F700C6A5
      A500DEC6C600D6B5B500BD949400EFD6DE00DEC6C600D6BDBD00EFE7EF00845A
      5200CEBDBD00000000000000000000000000000000000000000063CEEF0052DE
      F7007BEFFF006BE7F70042DEEF00ADF7FF008CEFF7006BE7F700BDF7FF00005A
      C60000A5DE000000000000000000000000000000000000000000F7EFF7005A5A
      5A00000000000000000000000000000000000000000000000000848484008C8C
      8C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7D6DE00CEB5
      B500BD9CA500E7D6D600D6BDBD00CEB5B500D6BDBD00EFD6D600DECED600D6BD
      C600D6BDB500000000000000000000000000000000000000000008B5E70063E7
      F70008A5E70008B5E70008BDEF0063E7F70010BDE70008B5E70000ADE70008BD
      EF00009CDE000000000000000000000000000000000000000000000000008484
      840042424200ADADAD0000000000000000000000000063636300636363000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DECED600D6B5
      B500EFDEDE0000000000FFFFFF00EFD6DE00FFF7F7000000000000000000BD94
      9400D6C6BD00000000000000000000000000000000000000000000B5E7006BE7
      F70008BDE7000000000073D6EF0008B5E7005ACEEF0000000000000000000073
      D60000A5DE00000000000000000000000000000000000000000000000000B5B5
      B50063636300525252007373730000000000736B73008C8C8C00848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFF7F700D6BD
      BD00F7EFEF000000000000000000000000000000000000000000FFF7F700DECE
      D600DECEC600000000000000000000000000000000000000000073CEEF006BEF
      F70039C6E700000000000000000000000000000000000000000073CEEF0018CE
      EF0000ADE7000000000000000000000000000000000000000000000000000000
      0000737373006B6B6B0039393900525252008484840094949400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00D6BD
      C600D6BDBD000000000000000000000000000000000000000000DECED600CEAD
      A500FFFFFF00000000000000000000000000000000000000000073D6EF0010BD
      EF00009CDE00000000000000000000000000000000000000000000B5E700008C
      DE008CD6EF000000000000000000000000000000000000000000000000000000
      00008C8C8C006B6B6B006363630063636300A5A5A5008C8C8C008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00C6ADAD00B5948C00000000000000000000000000AD8C8400DEC6BD000000
      0000000000000000000000000000000000000000000000000000000000008CD6
      EF0008ADE700006BCE00000000000000000000000000005ACE0000A5DE000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006B6B6B008C8C8C006B6B6B008C8C8C008C8C8C00737373008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7EFF7008C635A00C6A59C00DECEC6008C5A5200B5847B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000021C6EF000063CE000084D60000ADE7000039AD00004AC600000000000000
      00000000000000000000000000000000000000000000000000008C8C8C005252
      5200636363009C9C9C009C9C9C009C9C9C00636363007373730063636300847B
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B5948C00A57B730094736B009C6B6300FFE7E700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000006BCE0021CEEF0010CEEF0018C6E70094C6E700000000000000
      00000000000000000000000000000000000000000000ADADAD008C8C8C00B5B5
      B500E7E7E700E7E7E700BDBDBD00D6D6D600DEDEDE00A5A5A500737373006B6B
      6B007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D6C6C6006B3931008C5A5A00B5949C00CEADAD00F7CECE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000A5DE000052AD0010BDE70031DEF70063E7F70039ADE700000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00F7F7F700CECECE00A5A5A500CECECE00F7F7F700FFFFFF00FFFFFF00D6D6
      D600ADADAD008C8C8C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFE7E700A584
      840094636300A57B7B00CEA5A500D6C6C600CEADAD00BD9C9400DEB5AD00F7DE
      DE0000000000000000000000000000000000000000000000000008C6E700004A
      CE000063CE0021CEEF0052E7F70073EFF7005AE7F700089CDE000094DE0031BD
      E700000000000000000000000000000000000000000000000000000000000000
      000000000000EFEFEF00C6C6C600949494008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFDEDE00EFE7
      DE00E7D6CE00EFD6D600BD9C9C00CEADAD00EFC6C600DEBDB500DEBDBD00DEC6
      BD00EFE7DE00000000000000000000000000000000000000000008BDE70008BD
      E70008B5E70008B5E70000A5DE0052E7F70042C6EF0000A5DE0000A5DE0000A5
      DE0008BDE7000000000000000000000000000000000000000000000000000000
      00000000000000000000D6D6D6009C9C9C009C9C9C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6CECE00C69C9C00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000ADE70008A5DE0094CEEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DEDEDE009C9C9C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFE7E700CEADAD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000008C6E700008CDE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F7F7F700B5B5B5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00E7D6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084D6EF0008BDE7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009C848400393131000031310000393900313131008C7373000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004A42
      4200FFEFEF00000000000000000000000000000000000000000000000000FFE7
      E700524A4A00000000000000000000000000000000000000000000000000FFFF
      FF000000000000B5B50000FFFF0000D6D60000D6D60000FFFF0000D6D6000000
      0000FFF7F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EFEFEF000000000000000000000000000000000000000000000000004239
      3900D6CECE00000000000000000000000000000000000000000000000000E7DE
      DE0031212100000000000000000000000000000000000000000000000000005A
      5A00008484008C6B6B0000000000000000000000000000000000846B6B00008C
      8C00106363000000000000000000000000000000000000000000000000003131
      310000FFFF00007B7B0000000000000000000000000000000000005A5A0000FF
      FF00182121000000000000000000000000000000000000000000000000000000
      00009C8C8C000000000000000000000000000000000000000000000000009484
      8400000000000000000000000000000000000000000000000000000000001863
      6300003131008C6B6B00000000000000000000000000000000008C7373000031
      3100107373000000000000000000000000000000000000000000000000000000
      000000C6C60000EFEF003129290000000000000000003131310000F7F70000AD
      AD00100000000000000000000000000000000000000000000000000000001884
      8400005A5A000000000000000000000000000000000000000000000000000063
      630018848400000000000000000000000000000000000000000000000000006B
      6B00007B7B0063424200000000000000000000000000000000005A4242000084
      8400005252000000000000000000000000000000000000000000000000001810
      100000F7F700008484004A29290000000000000000004A292900007B7B0000FF
      FF0010101000000000000000000000000000000000000000000000000000005A
      5A00006B6B000042420000FFFF00212929002139390000FFFF00003131000073
      7B0008636300000000000000000000000000000000000000000000000000214A
      520000FFFF0000393900000000000000000000000000000000000063630000FF
      FF00183939000000000000000000000000000000000000000000000000008473
      730000C6C60000A5A5006342420000000000000000005231310000A5A50000C6
      C600847373000000000000000000000000000000000000000000000000002163
      63000018180000C6C600008C8C005A3939006B4A4A00009C9C0000D6D6000018
      1800086363000000000000000000000000000000000000000000000000000000
      000000CECE0000BDBD000008080000FFFF0000FFFF000008080000CECE0000C6
      C600000000000000000000000000000000000000000000000000000000002139
      39000018180000FFFF0000ADAD00000000000000000000D6D60000F7F7000018
      1800184A4A000000000000000000000000000000000000000000000000000000
      00009473730000C6C600008484008463630094737300008C8C0000BDBD00A584
      840000000000000000000000000000000000000000000000000000000000394A
      4A0000FFFF000029290000C6C600007B7B000073730000D6D6000018180000FF
      FF0021393900000000000000000000000000000000000000000000000000005A
      5A00004242000094940000BDBD00002121000010100000E7E700008484000052
      520000525A000000000000000000000000000000000000000000000000002152
      520000FFFF000018180000B5B50000D6D60000D6D60000B5B5000029290000FF
      FF00183131000000000000000000000000000000000000000000000000000000
      0000000000008463630000EFEF00003939000039390000EFEF00846363000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002121210000FFFF000010100000DEDE0000F7F7000008080000FFFF002131
      3100000000000000000000000000000000000000000000000000000000004A42
      420000FFFF00005A5A00008C8C0000ADAD0000BDBD00008484000063630000FF
      FF004A4242000000000000000000000000000000000000000000000000002942
      42000008080000FFFF0000525200008C8C00008C8C00004A4A0000FFFF000010
      1000185252000000000000000000000000000000000000000000000000000000
      000000000000000000003939390000FFFF0000FFFF0039393900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001831310000FFFF00000000000000000000FFFF00102929000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005239390000FFFF000039390000ADAD0000ADAD00004A4A0000F7F7006352
      5200000000000000000000000000000000000000000000000000000000003163
      630000FFFF000008080000FFFF00006363000031310000FFFF000000000000FF
      FF00215252000000000000000000000000000000000000000000000000000000
      00000000000000000000FFF7F70000737300005A5A00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFF7F7000052520000DEDE0000CECE00005A5A00FFEFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003931310000FFFF00000000000010100000FFFF004A3131000000
      000000000000000000000000000000000000000000000000000000000000FFEF
      EF000039390000FFFF000010100000FFFF0000FFFF000008080000FFFF001839
      3900FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000736B6B007373730000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD9C9C0000C6C60000CECE00AD848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000842420000F7F70000F7F70008393900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFF7F7000039390000FFFF00001818000018180000FFFF0000393900FFF7
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFF7F700F7F7F70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000215252001842420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6BDBD0000ADAD0000949400DEC6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFE7E700006B6B0000D6D60000A5A50000848400FFE7E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDB5B500ADADAD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000039525200394A4A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BD9C9C0000C6CE0000EFEF00947B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CECECE00D6D6D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000183939001042420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600B5ADAD0000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E007E007FFFF0000C00FC00FFFEF0000
      C007C007CFCF0000C007C007E39F0000C467C467E11F0000C7C7C7C7F01F0000
      C7C7C7C7F01F0000E39FE39FF01F0000F03FF03FC00F0000F83FF83F80070000
      F03FF03FE0030000C00FC00FF87F0000C007C007FC7F0000FC7FFC7FFCFF0000
      FCFFFCFFFCFF0000FCFFFCFFFEFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF81F
      FFFFFFFFE7E7E007FFF7E7E7E3C7E007E7E7E3C7E187E007E3C7E187E007E007
      E187E007E007E007F00FE007E007E007F81FF00FE007E007FC3FF81FF00FE007
      FC3FF81FF81FE007FE7FFC3FFC3FF00FFE7FFE7FFC3FF81FFFFFFE7FFE7FFC3F
      FFFFFFFFFE7FFE7FFFFFFFFFFFFFFE7F00000000000000000000000000000000
      000000000000}
  end
  object SortPopupMenu: TPopupMenu
    Left = 584
    Top = 80
    object Nosorting1: TMenuItem
      Caption = 'Don'#39't sort'
    end
    object Sortbyname1: TMenuItem
      Caption = 'Sort by name'
    end
    object Sortbystatus1: TMenuItem
      Caption = 'Sort by status'
    end
    object Sortbyrank1: TMenuItem
      Caption = 'Sort by rank'
    end
    object Sortbycountry1: TMenuItem
      Caption = 'Sort by country'
    end
    object Sortbygroup1: TMenuItem
      Caption = 'Sort by group'
    end
  end
  object GradesImageList: TImageList
    Left = 369
    Top = 311
    Bitmap = {
      494C01010B000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000008C6B00007B6300006B
      5A00006B5200006B5200006352000063520000634A00005A4A00005A4A00005A
      4A00005A420000524200004A390000000000000000000094520000844A000073
      420000734200006B3900006B3900006B3900006B390000633900006339000063
      3100005A3100005A310000522900000000000000000000AD0800009C00000094
      000000940000008C0000008C0000008C0000008C0000008C0000008C0000008C
      0000008C000000840000007B0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001010100000B5940000A58400009C
      7B0000947B0000947300008C7300008C730000846B0000846B0000846B00007B
      6300007B630000735A0000635200000000001010100000C66B0000B5630000A5
      5A0000A55A00009C5A00009C52000094520000945200008C5200008C4A00008C
      4A0000844A00007B4200006B3900000000001010100000D6080000CE080000C6
      080000BD080000BD080000BD080000BD080000BD080000BD080000B5080000B5
      080000B5080000AD0800009C0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929290000EFBD0000CEA50000B5
      940000B58C0063E7CE00DEDEDE00DEDEDE00DEDEDE00DEDEDE006BD6BD000094
      7B0000947300008C6B0000735A00000000002929290000F78C0000DE7B0000C6
      730052FFB500DEDEDE00DEDEDE00DEDEDE004AFFB50000AD630000A55A0000A5
      5A00009C5A0000945200007B4A00000000002929290021E7290084DE8C00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE0084D68400DEDEDE00DEDEDE00DEDEDE00DEDE
      DE0084D6840000C6080000AD0800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929290000F7C60000DEB50000C6
      9C0063EFD600DEDEDE0000000000000000000000000000000000DEDEDE006BDE
      C600009C840000947B0000846300000000002929290000FF940000EF840000D6
      7B00DEDEDE00000000000000000000000000DEDEDE00DEDEDE004AFFAD0000AD
      630000AD6300009C5A00008C5200000000002929290021E72900DEDEDE000000
      0000000000000000000000000000DEDEDE000000000000000000000000000000
      0000DEDEDE0084D6840000AD0800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929290000FFCE0000EFBD0000D6
      AD00DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE0000AD8C0000A58400008C7300000000002929290010FF9C0000F78C0000E7
      84005AFFBD00DEDEDE00DEDEDE00000000000000000000000000DEDEDE0000BD
      6B0000BD6B0000AD630000945200000000002929290021E7290084DE8C00DEDE
      DE000000000000000000DEDEDE000000000000000000DEDEDE00DEDEDE000000
      000000000000DEDEDE0000B50800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929290010FFD60000FFCE0000E7
      BD00DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE0000BD940000AD8C0000947B00000000002929290021FFA50008FF940000F7
      8C0000EF8C0063FFBD00DEDEDE00DEDEDE000000000000000000DEDEDE0052FF
      BD0000C6730000BD6B0000A55A00000000002929290021EF290010E71800DEDE
      DE000000000000000000DEDEDE000000000000000000DEDEDE00DEDEDE000000
      000000000000DEDEDE0000B50800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929290021FFD60008FFD60000FF
      CE006BFFDE00DEDEDE0000000000000000000000000000000000DEDEDE0063F7
      D60000CEA50000BD940000A58400000000002929290031FFA50018FF9C0008FF
      94006BFFBD00DEDEDE000000000000000000000000000000000000000000DEDE
      DE0000D67B0000CE730000AD6300000000002929290029EF310010E72100DEDE
      DE000000000000000000DEDEDE000000000000000000DEDEDE00DEDEDE000000
      000000000000DEDEDE0000BD0800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929290031FFD60018FFD60008FF
      D60073FFDE00DEDEDE0000000000000000000000000000000000DEDEDE0063FF
      DE0000D6AD0000CEA50000AD8C00000000002929290039FFAD0029FFA50018FF
      9C00DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE0000E7840000D67B0000BD6B00000000002929290031EF390018EF2100DEDE
      DE000000000000000000DEDEDE000000000000000000DEDEDE00DEDEDE000000
      000000000000DEDEDE0000BD0800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929290042FFDE0029FFD60018FF
      D600DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE0000E7BD0000DEAD0000BD940000000000292929004AFFB50039FFAD0029FF
      A500DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE0000F78C0000EF840000CE7300000000002929290031EF390021EF2900DEDE
      DE000000000000000000DEDEDE000000000000000000DEDEDE00DEDEDE000000
      000000000000DEDEDE0000C60800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002929290052FFDE0039FFDE0029FF
      D600DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE0000FFCE0000EFBD0000CEA50000000000292929005AFFBD004AFFB50039FF
      AD00DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE0008FF940000FF8C0000DE7B00000000002929290039EF420094E79400DEDE
      DE000000000000000000DEDEDE000000000000000000DEDEDE00DEDEDE000000
      000000000000DEDEDE0000C60800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000292929005AFFE7004AFFDE0039FF
      DE008CF7DE00DEDEDE0000000000000000000000000000000000DEDEDE007BFF
      E70008FFD60000FFCE0000DEB50000000000292929006BFFBD0052FFBD004AFF
      B50084FFCE00DEDEDE0000000000000000000000000000000000DEDEDE0073FF
      C60018FF9C0008FF940000E78400000000002929290039EF4200DEDEDE000000
      00000000000000000000DEDEDE00DEDEDE000000000000000000000000000000
      0000DEDEDE0084DE8C0008C61000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000292929006BFFE7005AFFDE004AFF
      DE0042FFDE008CF7E700DEDEDE00DEDEDE00DEDEDE00DEDEDE0084F7DE0021FF
      D60021FFD60008FFCE0000EFBD00000000002929290073FFC60063FFBD0052FF
      B50052FFB5008CFFCE00DEDEDE00DEDEDE00DEDEDE00DEDEDE0084FFCE0031FF
      A50029FFA50018FF9C0000F78C00000000002929290042EF4A0094E79400DEDE
      DE00DEDEDE00DEDEDE008CE794008CE78C00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE008CE78C0010DE180008C61000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003939390084FFE7007BFFE70073FF
      E7006BFFE7006BFFE70063FFE70063FFE7005AFFE7005AFFDE0052FFDE0052FF
      DE004AFFDE0039FFDE0010FFD60000000000393939008CFFCE0084FFCE0073FF
      C60073FFC60073FFC6006BFFC6006BFFC60063FFBD0063FFBD0063FFBD005AFF
      BD0052FFB50042FFAD0018FF9C0000000000393939005AEF63004AEF520042EF
      4A0042EF4A0042EF4A0039EF420039EF420039EF420039EF420039EF420039EF
      420039EF420021EF310010DE1800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005A5A5A00A5FFEF00A5FFEF009CFF
      EF0094FFEF0094FFEF0094FFEF0094FFEF008CFFEF008CFFEF008CFFEF0084FF
      E70084FFE70073FFE7004AFFDE00000000005A5A5A00ADFFDE00A5FFDE009CFF
      D6009CFFD6009CFFD6009CFFD60094FFD60094FFD60094FFD6008CFFCE008CFF
      CE008CFFCE007BFFC6005AFFBD00000000005A5A5A0084F784007BF7840073F7
      7B0073F77B0073F77B0073F77B0073F7730073F7730073F773006BF773006BF7
      73006BF773005AF7630031EF3900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000010087B0010086B001008
      63001008630010085A0010085A0010085A001008520010085200080852000808
      52001008520010084A0008084200000000000000000000318C0000297B000021
      6B0000216B0000216B0000216300002163000021630000215A0000215A000021
      5A0000215A000021520000184A00000000000000000000638C00005A7B00004A
      6B00004A6B00004A6B00004A6300004263000042630000425A0000425A000042
      5A0000425A000039520000394A000000000000000000007B8C00006B7B000063
      6B0000636B0000636B00005A6300005A6300005A6300005A5A0000525A000052
      5A0000525A0000525200004A4A0000000000101010002110A500181094001810
      8C0018088400180884001808840018087B0010087B0010087300100873001008
      730010086B001008630010085A0000000000101010000042B5000039A5000039
      9C00003194000031940000318C0000318C000031840000318400003184000031
      7B0000297B00002973000021630000000000101010000084B5000073A500006B
      9C00006B9400006B9400006B8C0000638C00005A840000638400005A8400005A
      7B00005A7B0000527300004A6300000000001010100000ADB500009CA500008C
      9C00008C9400008C940000848C0000848C00007B8400007B8400007B84000073
      7B0000737B00006B7300005A630000000000292929003931B5002921AD001810
      A5001810A50018109C0018109C008C84BD00DEDEDE00DEDEDE008C84BD001808
      84001808840018087B0010086B000000000029292900215AC600084AC6000042
      B5007B9CCE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE008494BD000031
      94000031940000318C00002973000000000029292900219CC600088CC6000084
      B5000084B50084B5CE00DEDEDE00DEDEDE00DEDEDE00DEDEDE0084ADBD00006B
      9400006B940000638C0000527300000000002929290000DEEF0000C6CE0000AD
      B50000ADB5004AF7FF00DEDEDE00DEDEDE0042F7FF0000949C0000949C00008C
      9400008C940000848C00006B730000000000292929003931C6002921BD002110
      B5002110AD002110AD002110A500DEDEDE000000000000000000DEDEDE001810
      940018108C00180884001008730000000000292929002163D6000852CE00004A
      C600DEDEDE000000000000000000000000000000000000000000DEDEDE007B9C
      C60000399C000031940000298400000000002929290021A5D600089CCE000094
      C60084BDCE00DEDEDE0000000000000000000000000000000000DEDEDE0084B5
      C60000739C00006B9400005A8400000000002929290000E7F70000CEDE0000BD
      C60000B5C600DEDEDE000000000000000000DEDEDE0042F7FF00009CA500009C
      A50000949C00008C9400007B840000000000292929004231CE003121C6008C8C
      CE00DEDEDE00DEDEDE00DEDEDE00DEDEDE000000000000000000DEDEDE008C84
      C60018109C0018108C0018087B000000000029292900216BE700085ADE00004A
      D6007B9CD600DEDEDE00DEDEDE00DEDEDE00DEDEDE000000000000000000DEDE
      DE000042AD000039A50000318C00000000002929290021ADE70008A5DE00009C
      D600DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE00007BAD000073A50000638C00000000002929290000EFFF0000DEEF0000C6
      D60000C6CE0052F7FF00DEDEDE000000000000000000DEDEDE0000ADB50000A5
      B50000A5AD000094A50000848C0000000000292929004A42CE003929CE00DEDE
      DE0000000000000000000000000000000000000000000000000000000000DEDE
      DE002110A50018109C001808840000000000292929002973E7001863E7000052
      DE000052DE00004ADE00004AD600004AD600DEDEDE000000000000000000DEDE
      DE000042BD000039AD0000319400000000002929290031B5E70018A5E70000A5
      DE00DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE000084BD00007BAD00006B9400000000002929290010F7FF0000EFFF0000D6
      E70000D6DE0000CEDE00DEDEDE000000000000000000DEDEDE0000BDC60000B5
      BD0000ADBD0000A5AD00008C940000000000292929005A52D6004239CE00DEDE
      DE000000000000000000DEDEDE00DEDEDE000000000000000000DEDEDE008C8C
      CE002110B5002110AD00181094000000000029292900397BE700216BE7001063
      E700105AE700085AE7000052DE007BA5DE00DEDEDE000000000000000000DEDE
      DE00004ACE000042BD000039A500000000002929290039BDE70029B5E70018AD
      E700DEDEDE00000000000000000000000000DEDEDE000000000000000000DEDE
      DE000094CE00008CBD000073A500000000002929290021F7FF0008F7FF0000EF
      FF0000E7F70000DEEF00DEDEDE000000000000000000DEDEDE0052F7FF0000BD
      CE0000BDCE0000B5BD000094A50000000000292929006B5AD6005A4AD6009C9C
      D600DEDEDE000000000000000000DEDEDE000000000000000000DEDEDE002110
      C6002110C6002110B50018109C0000000000292929004A84E7003973E700216B
      E7008CADDE00DEDEDE00DEDEDE00DEDEDE000000000000000000DEDEDE007BA5
      DE000052D600004ACE000039AD0000000000292929004ABDE70039B5E70029AD
      E700DEDEDE000000000000000000000000000000000000000000DEDEDE0084C6
      DE00009CD6000094CE00007BAD00000000002929290031F7FF0018F7FF0008F7
      FF0000EFFF0000EFFF0063F7FF00DEDEDE000000000000000000DEDEDE0000CE
      DE0000CED60000BDCE0000A5AD000000000029292900736BDE00635AD600524A
      D600A59CD600DEDEDE0000000000000000000000000000000000DEDEDE003121
      CE002918CE002118BD001810A50000000000292929005A8CEF004284E7003173
      E700DEDEDE0000000000000000000000000000000000DEDEDE0084A5DE00085A
      E7000852DE000052D6000042BD0000000000292929005ABDEF004ABDE70039B5
      E70094CEDE00DEDEDE000000000000000000DEDEDE00DEDEDE008CC6DE0008A5
      DE0008A5DE00009CD6000084BD00000000002929290042F7FF0029F7FF0073F7
      FF00DEDEDE00DEDEDE006BF7FF00DEDEDE000000000000000000DEDEDE0063F7
      FF0000DEE70000CEDE0000ADBD0000000000292929007B73DE006B63DE006352
      D6005A52D600A5A5D600DEDEDE00000000000000000000000000DEDEDE004231
      CE003929CE003129C6002921AD0000000000292929006394EF00528CEF00427B
      E7009CB5DE00DEDEDE000000000000000000DEDEDE00DEDEDE00DEDEDE008CAD
      DE001863E700105AD600084ABD00000000002929290063C6EF0052BDEF0042BD
      E70042BDE700DEDEDE00000000000000000000000000DEDEDE00DEDEDE008CC6
      DE0018ADE70010A5D600088CBD00000000002929290052F7FF0039F7FF00DEDE
      DE000000000000000000DEDEDE00DEDEDE00DEDEDE000000000000000000DEDE
      DE0000E7FF0000DEEF0000BDCE000000000029292900847BDE007B73DE006B63
      DE006B63DE00635AD600A5A5D600DEDEDE000000000000000000DEDEDE004A42
      D6004A39D6004231C6003129AD000000000029292900739CEF006394EF00528C
      EF00528CEF00DEDEDE000000000000000000000000000000000000000000DEDE
      DE00296BE7002163DE001852BD00000000002929290073CEEF0063C6EF0052BD
      EF0052BDEF009CCEDE00DEDEDE00DEDEDE00000000000000000000000000DEDE
      DE0029B5E70021A5DE001894BD0000000000292929005AF7FF004AF7FF0084F7
      FF00DEDEDE00000000000000000000000000000000000000000000000000DEDE
      DE0008F7FF0000EFFF0000CEDE0000000000292929008C84E700847BDE007B6B
      DE00736BDE00736BDE006B63DE00ADA5DE00DEDEDE00DEDEDE00A5A5D6005A52
      D600524AD6005242CE004239B50000000000292929007BA5EF006B9CEF006394
      EF005A8CEF00A5BDE700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE009CB5
      DE00397BE7003173DE002963C60000000000292929007BCEEF006BCEEF0063C6
      EF005AC6EF005AC6EF0052C6EF00A5CEDE00DEDEDE00DEDEDE00DEDEDE009CCE
      DE0039B5E70031ADDE002994C60000000000292929006BF7FF005AF7FF004AF7
      FF0084F7FF00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE007BF7
      FF0021F7FF0008F7FF0000DEEF000000000039393900A59CE7009C94E700948C
      E700948CE7008C84E7008C84E7008C7BE700847BDE00847BDE007B73DE007B73
      DE007B6BDE006B63DE00524AC600000000003939390094B5F7008CADEF007BAD
      EF007BA5EF007BA5EF0073A5EF00739CEF006B9CEF006B9CEF006B9CEF006394
      EF006394EF00528CEF003973D600000000003939390094D6F7008CD6EF0084D6
      EF007BCEEF007BCEEF0073CEEF0073CEEF0073CEEF006BCEEF006BCEEF0063C6
      EF0063C6EF0052BDEF0039ADD600000000003939390084FFFF007BF7FF0073F7
      FF006BF7FF006BF7FF0063F7FF0063F7FF005AF7FF005AF7FF0052F7FF0052F7
      FF004AF7FF0039F7FF0010F7FF00000000005A5A5A00BDB5EF00BDB5EF00B5AD
      EF00B5ADEF00ADADEF00ADADEF00ADA5EF00ADA5EF00ADA5EF00A5A5E700A59C
      E700A59CE700948CE7007B73DE00000000005A5A5A00ADCEF700ADC6F700A5C6
      F700A5BDF700A5BDF7009CBDF7009CBDF7009CBDF7009CBDF70094B5F70094B5
      F70094B5F70084ADEF006394EF00000000005A5A5A00B5E7F700ADE7F700A5DE
      F700A5DEF700A5DEF700A5DEF7009CDEF7009CDEF7009CDEF70094DEF70094D6
      F70094D6F70084D6EF0063C6EF00000000005A5A5A00A5FFFF00A5FFFF009CFF
      FF0094FFFF0094FFFF0094FFFF0094FFFF008CFFFF008CFFFF008CFFFF0084F7
      FF0084FFFF0073F7FF004AF7FF00000000007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600ADADAD00A5A5
      A5009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C
      9C009C9C9C00949494008C8C8C00000000000000000010101000101010001010
      1000101010001010100010101000101010001010100008080800080808000808
      0800080808000808080008080800000000000000000042424200393939003939
      3900313131003131310031313100313131003131310031313100313131002929
      290029292900292929002121210000000000000000006B6B6B005A5A5A005252
      52005252520052525200525252004A4A4A004A4A4A004A4A4A004A4A4A004A4A
      4A004242420042424200393939000000000010101000EFEFEF00E7E7E700D6D6
      D600D6D6D600D6D6D600D6D6D600CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00BDBDBD00ADADAD00000000001010100018181800181818001818
      1800181818001818180018181800101010001010100010101000101010001010
      100010101000101010001010100000000000101010005A5A5A00525252004A4A
      4A004A4A4A004A4A4A004A4A4A004A4A4A004242420042424200424242004242
      420039393900393939003131310000000000101010008C8C8C00848484007B7B
      7B007373730073737300737373006B6B6B006B6B6B006B6B6B00636363006363
      6300636363005A5A5A00525252000000000029292900F7F7F700F7F7F700F7F7
      F700EFEFEF00EFEFEF00E7E7E700DEDEDE00DEDEDE00DEDEDE00E7E7E700E7E7
      E700E7E7E700D6D6D600BDBDBD00000000002929290039393900292929001818
      1800181818008C8C8C00DEDEDE00DEDEDE00DEDEDE00DEDEDE008C8C8C001818
      18001818180010101000101010000000000029292900737373006B6B6B005A5A
      5A00A5A5A500DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE009C9C
      9C004A4A4A0042424200393939000000000029292900A5A5A5009C9C9C009494
      9400BDBDBD00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00B5B5B5007373
      7300737373006B6B6B005A5A5A000000000029292900FFFFFF00F7F7F700F7F7
      F700F7F7F700F7F7F700DEDEDE000000000000000000DEDEDE00EFEFEF00EFEF
      EF00E7E7E700DEDEDE00C6C6C600000000002929290039393900292929002121
      210018181800DEDEDE0000000000000000000000000000000000DEDEDE001818
      180018181800181818001010100000000000292929007B7B7B006B6B6B006363
      6300DEDEDE00000000000000000000000000000000000000000000000000DEDE
      DE00525252004A4A4A00424242000000000029292900ADADAD00A5A5A5009C9C
      9C00DEDEDE000000000000000000000000000000000000000000DEDEDE00B5B5
      B5007B7B7B0073737300636363000000000029292900FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00E7E7E700DEDEDE00DEDEDE00E7E7E700EFEFEF00EFEF
      EF00EFEFEF00E7E7E700C6C6C600000000002929290042424200292929002121
      2100212121008C8C8C00DEDEDE000000000000000000DEDEDE008C8C8C001818
      1800181818001818180010101000000000002929290084848400737373006B6B
      6B00ADADAD00DEDEDE000000000000000000DEDEDE000000000000000000DEDE
      DE005A5A5A0052525200424242000000000029292900BDBDBD00ADADAD00A5A5
      A500C6C6C600DEDEDE00DEDEDE00DEDEDE00DEDEDE000000000000000000DEDE
      DE008C8C8C007B7B7B006B6B6B000000000029292900FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00DEDEDE000000000000000000DEDEDE00F7F7F700F7F7
      F700F7F7F700E7E7E700CECECE0000000000292929004A4A4A00393939002929
      29002121210021212100DEDEDE000000000000000000DEDEDE00212121001818
      180018181800181818001818180000000000292929008C8C8C007B7B7B007373
      730073737300ADADAD00DEDEDE000000000000000000DEDEDE00DEDEDE00ADAD
      AD005A5A5A005A5A5A004A4A4A000000000029292900BDBDBD00B5B5B500B5B5
      B500ADADAD00ADADAD00ADADAD00C6C6C600DEDEDE000000000000000000DEDE
      DE00949494008C8C8C00737373000000000029292900FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00DEDEDE000000000000000000DEDEDE00E7E7E700FFFF
      FF00F7F7F700EFEFEF00CECECE0000000000292929005A5A5A00424242003939
      39003131310029292900DEDEDE000000000000000000DEDEDE00212121002121
      21002121210018181800181818000000000029292900949494008C8C8C007B7B
      7B007B7B7B007B7B7B00B5B5B500DEDEDE000000000000000000DEDEDE00ADAD
      AD006363630063636300525252000000000029292900C6C6C600BDBDBD00B5B5
      B500B5B5B500B5B5B500CECECE00DEDEDE00000000000000000000000000DEDE
      DE009C9C9C00949494007B7B7B000000000029292900FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEFEF00DEDEDE000000000000000000DEDEDE00EFEF
      EF00FFFFFF00F7F7F700D6D6D600000000002929290063636300525252004242
      42004242420039393900DEDEDE000000000000000000DEDEDE00212121002121
      210021212100212121001818180000000000292929009C9C9C00949494008C8C
      8C0084848400848484007B7B7B00B5B5B500DEDEDE000000000000000000DEDE
      DE006B6B6B00636363005A5A5A000000000029292900C6C6C600C6C6C600BDBD
      BD00BDBDBD00B5B5B500DEDEDE00000000000000000000000000DEDEDE00C6C6
      C600ADADAD009C9C9C008C8C8C000000000029292900FFFFFF00FFFFFF00FFFF
      FF00EFEFEF00DEDEDE00DEDEDE00EFEFEF00DEDEDE000000000000000000DEDE
      DE00FFFFFF00F7F7F700DEDEDE00000000002929290073737300636363005252
      5200525252004A4A4A00DEDEDE000000000000000000DEDEDE00313131003131
      31002929290021212100181818000000000029292900A5A5A5009C9C9C009494
      9400BDBDBD00DEDEDE00DEDEDE00B5B5B500DEDEDE000000000000000000DEDE
      DE00737373006B6B6B00636363000000000029292900CECECE00C6C6C600BDBD
      BD00CECECE00DEDEDE00DEDEDE00DEDEDE000000000000000000DEDEDE00CECE
      CE00B5B5B500A5A5A500949494000000000029292900FFFFFF00FFFFFF00FFFF
      FF00DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE00FFFFFF00F7F7F700DEDEDE0000000000292929007B7B7B006B6B6B006363
      63005A5A5A00A5A5A500DEDEDE000000000000000000DEDEDE00424242003939
      39003939390031313100292929000000000029292900ADADAD00A5A5A5009C9C
      9C00DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE00848484007B7B7B006B6B6B000000000029292900CECECE00CECECE00C6C6
      C600DEDEDE000000000000000000DEDEDE00DEDEDE000000000000000000DEDE
      DE00B5B5B500ADADAD00949494000000000029292900FFFFFF00FFFFFF00FFFF
      FF00DEDEDE000000000000000000000000000000000000000000DEDEDE00EFEF
      EF00FFFFFF00F7F7F700DEDEDE000000000029292900848484007B7B7B006B6B
      6B006B6B6B00DEDEDE00000000000000000000000000DEDEDE00525252004A4A
      4A004A4A4A0042424200313131000000000029292900B5B5B500ADADAD00A5A5
      A500C6C6C600DEDEDE0000000000000000000000000000000000DEDEDE00BDBD
      BD008C8C8C00848484006B6B6B000000000029292900D6D6D600CECECE00CECE
      CE00D6D6D600DEDEDE0000000000000000000000000000000000DEDEDE00CECE
      CE00BDBDBD00B5B5B5009C9C9C000000000029292900FFFFFF00FFFFFF00FFFF
      FF00EFEFEF00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00EFEFEF00FFFF
      FF00FFFFFF00F7F7F700DEDEDE0000000000292929008C8C8C00848484007373
      730073737300ADADAD00DEDEDE00DEDEDE00DEDEDE00ADADAD005A5A5A005A5A
      5A00525252004A4A4A00424242000000000029292900B5B5B500ADADAD00A5A5
      A500A5A5A500C6C6C600DEDEDE00DEDEDE00DEDEDE00DEDEDE00BDBDBD009494
      9400949494008C8C8C00737373000000000029292900D6D6D600D6D6D600CECE
      CE00CECECE00D6D6D600DEDEDE00DEDEDE00DEDEDE00DEDEDE00D6D6D600C6C6
      C600C6C6C600B5B5B500A5A5A5000000000039393900FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00EFEFEF000000000039393900A5A5A5009C9C9C009494
      94008C8C8C008C8C8C008C8C8C008484840084848400848484007B7B7B007B7B
      7B007B7B7B006B6B6B00525252000000000039393900C6C6C600BDBDBD00BDBD
      BD00B5B5B500B5B5B500B5B5B500B5B5B500ADADAD00ADADAD00ADADAD00ADAD
      AD00A5A5A5009C9C9C008C8C8C000000000039393900DEDEDE00DEDEDE00D6D6
      D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600CECECE00CECE
      CE00CECECE00CECECE00B5B5B500000000005A5A5A00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000005A5A5A00BDBDBD00B5B5B500B5B5
      B500B5B5B500ADADAD00ADADAD00ADADAD00ADADAD00ADADAD00A5A5A500A5A5
      A500A5A5A500949494007B7B7B00000000005A5A5A00D6D6D600D6D6D600CECE
      CE00CECECE00CECECE00CECECE00CECECE00C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600BDBDBD00ADADAD00000000005A5A5A00E7E7E700E7E7E700E7E7
      E700E7E7E700E7E7E700E7E7E700DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00D6D6D600CECECE00000000007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484007373730052525200181818007B7B7B008C8C8C00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400737373005252520018181800424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object NumbersImageList: TImageList
    Left = 401
    Top = 311
    Bitmap = {
      494C010110001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5B5B5004A4A4A00000000004A4A
      4A00A5A5A5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5A5A500000000004A4A
      4A00A5A5A5000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5B500000000000000
      0000A5A5A5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A5A5A5000000000000000000000000000000
      000000000000A5A5A50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A5A5A50000000000000000000000
      000000000000A5A5A50000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD0000000000000000000000
      000000000000A5A5A50000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7E7E70000000000E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000004A4A4A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004A4A4A0000000000EFEFEF00EFEF
      EF00000000004A4A4A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000EFEFEF00EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEDE
      DE00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD0000000000BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF00EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004A4A
      4A00A5A5A5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004A4A4A004A4A4A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004A4A4A0000000000000000000000
      0000000000008C8C8C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009C9C9C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006B6B6B00DEDEDE0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD0000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009C9C9C00000000008C8C8C000000
      00006B6B6B00EFEFEF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009C9C9C000000
      00008C8C8C00F7F7F70000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7E7E70000000000E7E7
      E700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006B6B6B004A4A4A000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD0000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8C8C0000000000DEDEDE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A5A5A5000000000000000000000000000000
      0000000000008C8C8C0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6D6D600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7E7E70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6D6D60000000000000000000000
      0000000000006B6B6B0000000000000000000000000000000000E7E7E7007B7B
      7B0000000000000000000000000000000000BDBDBD006B6B6B00000000004A4A
      4A00A5A5A5000000000000000000000000000000000000000000E7E7E7007B7B
      7B000000000000000000000000000000000000000000000000006B6B6B000000
      0000000000000000000000000000000000000000000000000000E7E7E7007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E7007B7B7B0000000000000000000000000000000000BDBDBD004A4A4A000000
      00007B7B7B00EFEFEF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFEFEF007B7B7B00000000004A4A4A00BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5B500000000000000
      0000B5B5B5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006B6B6B0000000000000000000000000000000000D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD0000000000000000000000
      000000000000BDBDBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEDEDE00000000008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000DEDEDE00DEDE
      DE00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF00000000008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7F7F7008C8C8C00000000009C9C9C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFEFEF004A4A4A006B6B
      6B00E7E7E7000000000000000000000000000000000000000000000000000000
      0000000000009C9C9C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7F7F7007B7B
      7B0000000000D6D6D60000000000000000000000000000000000000000000000
      0000000000000000000000000000EFEFEF00EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006B6B6B0000000000000000000000000000000000000000000000
      0000000000000000000000000000EFEFEF00EFEFEF00000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000DEDEDE00DEDE
      DE00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFEFEF00EFEF
      EF00000000000000000000000000000000000000000000000000000000000000
      000000000000A5A5A50000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD0000000000000000000000
      000000000000BDBDBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009C9C9C0000000000000000000000
      0000000000008C8C8C0000000000000000000000000000000000000000000000
      00000000000000000000A5A5A5000000000000000000B5B5B500000000000000
      000000000000000000000000000000000000000000000000000000000000E7E7
      E7007B7B7B0000000000000000000000000000000000B5B5B500000000000000
      0000B5B5B500000000000000000000000000000000000000000000000000E7E7
      E7007B7B7B000000000000000000000000000000000000000000E7E7E7007B7B
      7B0000000000000000000000000000000000000000000000000000000000E7E7
      E7007B7B7B00000000000000000000000000000000009C9C9C00000000000000
      0000A5A5A5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A5A5A500000000004A4A4A00A5A5A500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B5B5B5000000000000000000A5A5A500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004A4A4A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009C9C9C0000000000000000009C9C9C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A5A5A50000000000000000000000000000000000A5A5A5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD0000000000000000000000000000000000A5A5A5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C8C8C0000000000E7E7E70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C00000000000000000000000000000000008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A4A4A0000000000EFEFEF00EFEFEF00000000004A4A4A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B0000000000EFEFEF00EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD0000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EFEFEF00EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EFEFEF00EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F7F7F700000000009C9C9C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A4A4A0000000000EFEFEF00EFEFEF00000000004A4A4A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A4A4A00000000000000000000000000000000008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009C9C9C000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008C8C8C0000000000F7F7F700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6D6D6004A4A4A00000000000000000000000000D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009C9C9C00000000008C8C8C00000000006B6B6B00EFEFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009C9C9C00000000008C8C8C00F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E7E7E70000000000A5A5A500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B5B5B50000000000000000000000000000000000B5B5B5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD0000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C0000000000DEDEDE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5B5B50000000000EFEFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F7F7F700F7F7F70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E7E7E70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6D6D600000000000000000000000000000000006B6B6B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD004A4A4A00000000007B7B7B00EFEFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFEFEF009C9C9C0000000000000000009C9C9C00EFEFEF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B5B5B5004A4A4A00000000004A4A4A00A5A5A500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A5A5A5000000000000000000000000000000000000000000A5A5A5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFEFEF00000000008C8C8C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7E7E70000000000E7E7E70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004A4A4A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000EFEFEF004A4A4A006B6B6B00E7E7E700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEDEDE00000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD0000000000BDBDBD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F7F7F7007B7B7B0000000000D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004A4A4A00A5A5A500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A4A4A004A4A4A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006B6B6B000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006B6B6B00DEDEDE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD0000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EFEFEF00EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7E7E70000000000E7E7E70000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006B6B6B004A4A4A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009C9C9C00000000000000000000000000000000008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A5A5A50000000000000000000000000000000000000000008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6D6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009C9C9C000000000000000000A5A5A500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD006B6B6B00000000004A4A4A00A5A5A500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B6B6B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E7E7E7007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFE707E7E7E787F387E603E603E703F303E623E603E703F303
      E7E3E627E7E3F303E787E727E703F303E783E707E703F30386238787871FC31F
      860387878703C303C707C7C7C783E383FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFF83FF387F3E7F303F81FF303F3E7F303FF1FF303F3E7F31F
      F81FF333F3E7F387F81FF333F3E7F3C3F81FF333F3E7F3F3F81FC303C387C303
      F81FC303C387C303FC3FE387E3C7E387FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFC3FFC3FFCFFFC3FF81FF81FFC7FF81FF81FF81FFC7FF81F
      FF1FF81FFC7FF81FF81FF81FFE3FF81FF81FF81FFE3FF81FF8FFF8FFFF1FF81F
      F81FF81FF01FF81FFC1FFC1FF01FF81FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF81FF83FFF3FFE7FF81FF01FF01FFE7FF8FFF11FF01F
      FE7FFC3FFF1FF13FFE7FFE1FFC3FF93FFE7FFF9FFC1FF83FFE7FF81FF11FFC3F
      F87FF81FF01FFC3FF87FFC3FF83FFE3FFC7FFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object MiscImageList: TImageList
    Left = 433
    Top = 311
    Bitmap = {
      494C01010D000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      00000000000000000000000000000000000052A5C600398CAD0008738C00108C
      A500006B8C00007B940000849C0000738C00006B8400006B8400007384001073
      8400528C9C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005AB5CE008CEFFF008CF7FF008CFF
      FF0063E7FF0052EFFF0042EFFF0029DEF70031DEEF0039D6EF004ACEDE0052B5
      C6004A8494000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000021849C0084EFFF0084F7FF006BEF
      FF0042CEE70039D6EF0029D6EF0018CEDE0018CEDE0021C6D60039C6CE0052C6
      CE00216373000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039A5B5009CFFFF0084F7FF005ADE
      F70042D6EF0042E7F70029D6E70021D6E70018C6D60010BDC60021B5BD0063CE
      DE0010636B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319CAD0094FFFF007BF7FF006BEF
      FF0063EFFF0052EFFF0029D6E70029DEE70031DEEF0021CED60031C6C60073E7
      EF00186B73000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039A5AD0094FFFF008CFFFF0084FF
      FF006BF7FF005AE7F70039D6E7004AEFFF0031D6DE0029C6CE0039C6C6006BDE
      DE00085A5A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004AA5B500A5FFFF009CFFFF008CF7
      FF0073E7F7006BE7F7005ADEE70063EFF7005AE7EF005ADEE7005AD6D60073D6
      DE00186363000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005AA5AD00ADFFFF00ADFFFF00ADFF
      FF00A5FFFF00A5FFFF008CF7FF0073E7EF007BEFF70073DEE7006BD6D60084D6
      D600397373000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007BB5BD006BA5AD005A949C00528C
      940052949C0052949C00428C940039848C0031848C00297B7B0042848C00316B
      6B008CB5B5006B848400636B6B00847B84000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004A848400C6F7F700427373000000
      0000000000007B848400B5B5B5007B7373000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000637B8400E7FFFF005A7373000000
      0000000000008C848400D6CECE0073636B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084949400E7F7EF007B8C8C000000
      000000000000736B6B00C6BDBD008C737B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009C9C9C00F7FFFF009CA5A5000000
      00000000000073737300EFE7E700948484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5B5B500DEE7DE00BDCEC6008C94
      94008C948C00A5ADAD00BDBDBD00A5A59C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFEFEF009CA59C00C6D6CE00C6DE
      D600B5C6BD00B5C6BD0073847B00D6E7DE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEEFE700ADBDB500849C
      940084948C009CB5AD00D6E7DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007BADC6004A94A5003184
      9C002184A50000738C0000738C00007B940000849C00006B8400006B8400006B
      7B0008738C00106B7B005A9CB500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000073ADBD009CDEF70094EF
      FF0094FFFF0073F7FF005AEFFF004AEFFF0039E7FF0031DEF70042DEF7004AD6
      EF005ACEDE004AA5B500428C9C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484000000
      000000000000000000000000000000000000000000005294AD00ADFFFF008CEF
      FF007BEFFF005ADEF70042DEF70031DEEF0018CEE70018CEDE0021C6DE0031C6
      D60042BDCE0052B5C600186B7B0000000000006363009CFFFF0000CEFF0000CE
      FF0000CEFF0000CEFF00009CCE0000CEFF00009CCE0000CEFF00009CCE00009C
      CE00639C9C00009CCE0000000000000000000000000000000000000000008484
      8400848484000000FF000000FF000000FF000000FF000000FF00848484008484
      8400000000000000000000000000000000000000000000000000000000008484
      84008484840000FF000000FF000000FF000000FF000000FF0000848484008484
      8400000000000000000000000000000000000000000042949C00ADFFFF0084E7
      FF006BE7F70052DEF70042DEF70031DEF70029DEEF0021D6E70018C6D60021BD
      CE0039B5C6006BD6DE00106B730000000000006363009CFFFF0000CEFF0000CE
      FF0000CEFF0000CEFF0000CEFF00FF00000000CEFF00009CCE0000CEFF00009C
      CE00009CCE00639C9C0000000000000000000000000000000000848484000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF008484840000000000000000000000000000000000000000008484840000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      00008484840000000000000000000000000000000000217B8400ADFFFF0084EF
      FF0073EFFF0063EFFF004AE7F70031DEEF0029D6E70029D6E70021CED60029C6
      CE0039BDC6006BD6E700004A5A0000000000006363009CFFFF009CFFFF0000CE
      FF0000CEFF00FF00000000CEFF00FF00000000CEFF00FF000000009CCE0000CE
      FF00009CCE00009CCE0000000000000000000000000000000000848484000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF008484840000000000000000000000000000000000000000008484840000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000848484000000000000000000000000000000000039949C00ADFFFF009CFF
      FF0084F7FF007BFFFF005AEFF70042DEEF0039DEEF0039DEE70039D6DE0042CE
      DE0052CED6007BE7EF00106B730000000000006363009CFFFF0000CEFF009CFF
      FF0000CEFF0000CEFF00FF000000FF000000FF00000000CEFF0000CEFF00009C
      CE0000CEFF00009CCE00000000000000000000000000848484000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00848484000000000000000000000000008484840000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000084848400000000000000000000000000428C9400A5F7FF009CF7
      FF0084E7EF0084F7FF006BEFF7006BEFF7005AEFF7005AE7EF004AD6DE0052CE
      D6005AC6C6006BC6CE0018636B0000000000006363009CFFFF00FFFFFF0000CE
      FF00FF000000FF000000FF00000000FFFF00FF000000FF000000FF00000000CE
      FF00009CCE00009CCE00000000000000000000000000848484000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00848484000000000000000000000000008484840000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF0000848484000000000000000000000000006BA5AD00C6FFFF00C6FF
      FF00ADFFFF00ADFFFF008CEFFF0084F7FF007BEFF7007BEFF7007BEFEF007BE7
      EF0084D6DE0084CED60039737B0000000000006363009CFFFF0000CEFF00FFFF
      FF0000CEFF0000CEFF00FF000000FF000000FF00000000CEFF0000CEFF00009C
      CE0000CEFF00009CCE00000000000000000000000000848484000000FF000000
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00848484000000000000000000000000008484840000FF000000FF
      0000FFFFFF0000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000084848400000000000000000000000000B5DEE700638C94006B9C
      A50052848C005A949C00529CA500428C940031848C00429CA50031848400317B
      8400316B7300396B73009CBDC60000000000006363009CFFFF00FFFFFF0000CE
      FF00FFFFFF00FF00000000CEFF00FF00000000CEFF00FF00000000CEFF0000CE
      FF00009CCE00009CCE00000000000000000000000000848484000000FF000000
      FF00FFFFFF00FFFFFF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00848484000000000000000000000000008484840000FF000000FF
      0000FFFFFF00FFFFFF0000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00008484840000000000000000000000000000000000637B8400E7FF
      FF0073949C000000000000000000000000000000000000000000000000004A7B
      8400D6F7FF004A6B73000000000000000000006363009CFFFF0000CEFF00FFFF
      FF0000CEFF00FFFFFF0000CEFF00FF00000000CEFF0000CEFF0000CEFF0000CE
      FF0000CEFF00009CCE00000000000000000000000000848484000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000FF000000FF000000
      FF000000FF00848484000000000000000000000000008484840000FF000000FF
      0000FFFFFF00FFFFFF00FFFFFF0000FF000000FF000000FF000000FF000000FF
      000000FF00008484840000000000000000000000000000000000636B7300FFFF
      FF005A636B000000000000000000000000000000000000000000000000004A63
      6B00BDD6DE006B737B000000000000000000006363009CFFFF009CFFFF009CFF
      FF009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFFFF009CFF
      FF009CFFFF009CFFFF0000000000000000000000000000000000848484000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000FF000000
      FF008484840000000000000000000000000000000000000000008484840000FF
      000000FF0000FFFFFF00FFFFFF00FFFFFF0000FF000000FF000000FF000000FF
      000084848400000000000000000000000000000000000000000094949C00FFFF
      FF00ADA5AD000000000000000000000000000000000000000000000000007B84
      8C00BDC6CE006B6B6B0000000000000000000063630000636300006363000063
      6300006363000063630000636300006363000063630000636300006363000063
      6300006363000063630000000000000000000000000000000000848484000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF008484840000000000000000000000000000000000000000008484840000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000848484000000000000000000000000000000000000000000CECECE00F7EF
      F700CECECE008C8C8C00000000000000000000000000000000007B84840094A5
      A500ADADB500A59CA500000000000000000000000000006363009CFFFF009CFF
      FF009CFFFF009CFFFF009CFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484000000FF000000FF000000FF000000FF000000FF00848484008484
      8400000000000000000000000000000000000000000000000000000000008484
      84008484840000FF000000FF000000FF000000FF000000FF0000848484008484
      8400000000000000000000000000000000000000000000000000BDBDBD00C6C6
      C600FFF7F700DED6D600A59C9C006B6B6B006B736B00A5ADAD009CADA500D6DE
      DE007B848400BDBDBD0000000000000000000000000000000000006363000063
      6300006363000063630000636300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00ADADAD00CEC6C600DEDED600DEDEDE00DEDEDE00BDC6C6009CADAD007384
      7B00ADB5B5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CEC6C600ADADAD009CA59C00848C8C008C9C940094A5A5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000009C0000009C0000009C0000009C0000009C0000009C000000
      000000000000000000000000000000000000000000000000000084848400CECE
      CE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00CECECE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000CE00009CFF000000CE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000009C000000
      CE000000CE000000CE000000CE000000CE000000CE000000CE0000009C000000
      9C0000009C00000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF009CFFFF00FFFFFF009CFFFF00009C31009CFFFF00FFFFFF009CFF
      FF00FFFFFF00CECECE0000000000000000000000000000000000000000000000
      00000000000084840000FF00000084840000FF00000084840000000000000000
      CE0063CEFF006300FF000000CE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000009C000000CE000063
      FF003100FF003100FF003100FF003100FF003100FF000000CE000000CE000000
      CE0000009C0000009C000000000000000000000000000000000084848400FFFF
      FF009CFFFF00FFFFFF009CFFFF00009C3100009C3100FFFFFF009CFFFF00FFFF
      FF009CFFFF00CECECE0000000000000000000000000000000000009C31000063
      31000063310000840000848400000000000000000000000000000000000063CE
      FF006300FF000000CE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000009C000063FF003100
      FF003100FF003100FF003100FF003100FF003100FF003100FF003100FF000000
      CE000000CE0000009C000000000000000000000000000000000084848400FFFF
      FF00FFFFFF009CFFFF00009C3100009C3100009C3100009C3100009C31009CFF
      FF00FFFFFF00CECECE00000000000000000000000000009C310063CE310063CE
      3100009C3100009C31004A4A4A0084848400CE9C3100CE9C31009C6331000000
      00000000CE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF6331000000
      00000000000000000000000000000000000000009C006363FF000063FF003100
      FF003100FF003100FF003100FF003100FF003100FF003100FF003100FF003100
      FF000000CE0000009C0000009C0000000000000000000000000084848400FFFF
      FF009CFFFF00FFFFFF009CFFFF00009C3100009C3100FFFFFF00639C00006363
      00009CFFFF00CECECE00000000000000000000000000009C310063FF310063FF
      310063CE31004A4A4A0084848400FFCE9C00FFCE3100FFCE3100CE9C31009C63
      3100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF9C3100FF63
      31000000000000000000000000000000000000009C006363FF00319CFF003100
      FF003100FF00FFFFFF00FFFFFF003100FF003100FF00FFFFFF00FFFFFF003100
      FF000000CE000000CE0000009C0000000000000000000000000084848400FFFF
      FF00FFFFFF009CFFFF00FFFFFF009CFFFF00009C31009CFFFF00FFFFFF006363
      0000FFFFFF00CECECE000000000000000000009C31009CFFCE0063FF310063CE
      3100008400004A4A4A00FFCE9C00FFFFCE00FFFF9C00FFFF9C00FFCE3100CE9C
      3100000000009C00310000000000000000000000000000000000FF633100FF9C
      3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FFCE
      3100FF63310000000000000000000000000000009C006363FF00319CFF003100
      FF003100FF003100FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003100FF003100
      FF003100FF000000CE0000009C0000000000000000000000000084848400FFFF
      FF009CFFFF00636300009CFFFF00FFFFFF009CFFFF00FFFFFF009CFFFF006363
      00009CFFFF00CECECE000000000000000000009C31009CFFCE0063FF3100009C
      3100FF9C00004A4A4A00FFCE9C00FFFFFF00FFFFCE00FFFF9C00FFCE3100CE9C
      310000000000FF00000000000000000000000000000000000000FF633100FFFF
      CE00FFFFCE00FFFFCE00FFFFCE00FFFFCE00FFFFCE00FFFFCE00FFFFCE00FFFF
      9C00FFCE310000000000000000000000000000009C006363FF00319CFF003100
      FF003100FF003100FF003100FF00FFFFFF00FFFFFF003100FF003100FF003100
      FF003100FF000000CE0000009C0000000000000000000000000084848400FFFF
      FF00FFFFFF0063630000FFFFFF009CFFFF00009C31009CFFFF00FFFFFF009CFF
      FF00FFFFFF00CECECE000000000000000000009C3100009C3100009C3100FFCE
      3100FFCE31004A4A4A0084848400FFFFFF00FFFFFF00FFFFCE00FFCE9C008484
      840000000000FF63310000000000000000000000000000000000FF633100FF63
      3100FF633100FF633100FF633100FF633100FF633100FF633100FFFFCE00FFCE
      31000000000000000000000000000000000000009C006363FF00319CFF000063
      FF003100FF003100FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003100FF003100
      FF003100FF000000CE0000009C0000000000000000000000000084848400FFFF
      FF009CFFFF0063630000639C0000FFFFFF00009C3100009C31009CFFFF00FFFF
      FF009CFFFF00CECECE000000000000000000FF633100FFFFCE00FFFF3100FFCE
      3100FFCE3100FF9C00004A4A4A0084848400FFCE9C00FFCE9C00848484000000
      0000FF633100FF63310000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF633100FFCE31000000
      00000000000000000000000000000000000000009C006363CE00319CFF000063
      FF003100FF00FFFFFF00FFFFFF003100FF003100FF00FFFFFF00FFFFFF003100
      FF003100FF000000CE0000009C0000000000000000000000000084848400FFFF
      FF00FFFFFF009CFFFF00009C3100009C3100009C3100009C3100009C31009CFF
      FF00FFFFFF00CECECE000000000000000000FF633100FFFFCE00FF9C00000084
      000000840000FFCE3100FF9C00004A4A4A004A4A4A004A4A4A004A4A4A00FF9C
      0000FF6331009C00310000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF633100000000000000
      0000000000000000000000000000000000000000000000009C006363FF00319C
      FF000063FF003100FF003100FF003100FF003100FF003100FF003100FF003100
      FF003100FF000000CE000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00009C3100009C31009CFFFF00FFFF
      FF00CECECE00CECECE00000000000000000000000000FF6331000084000063CE
      3100009C3100FF633100FF9C0000FF9C0000FF9C0000FF633100FF9C0000FF63
      3100FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF633100000000000000
      0000000000000000000000000000000000000000000000009C006363CE00319C
      FF00319CFF000063FF000063FF003100FF003100FF003100FF003100FF003100
      FF003100FF0000009C000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00009C31009CFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000006331009CFFCE0063FF
      310063CE310000840000FF633100FF9C0000FF9C0000FF9C0000FF633100FF9C
      0000FF6331000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000009C006363
      CE006363FF00319CFF00319CFF000063FF000063FF003100FF003100FF003100
      FF000000CE00000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009CFFFF00FFFFFF009CFFFF008484
      8400FFFFFF000000000000000000000000000000000000000000006331009CFF
      CE0063FF310063CE3100009C31000084000000840000FF6331009C9C0000FF63
      3100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      9C0000009C006363CE006363FF006363FF006363FF006363FF000000CE000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      8400000000000000000000000000000000000000000000000000000000000063
      31000063310063FF310063FF310063CE3100009C310000840000FF633100FF63
      3100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000009C0000009C0000009C0000009C0000009C0000009C000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000633100006331000063310000633100FF633100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5A5A5008484
      8400636363008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000081800000818000000100000001000000018000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00B5B5
      B50084848400D6D6D60063636300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000800000010004AC6DE0031D6E70031DEEF0021CEDE0042D6E7000000
      1800000010000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5B5B500BDBDBD00000000000000
      0000B5B5B500D6D6D6005A5A5A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000010
      100042BDC60063EFFF0031D6E70018CEDE0010DEE70021F7FF0008CEDE0042D6
      E70063CEE7000000100000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063636300ADADAD00000000000000
      000084848400D6D6D60084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000080042C6
      D60021D6E70031E7FF0039E7F7000010180000292100001818000010100039EF
      F70031CEE7004AC6D60000001800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063636300848484009C9C9C005A5A
      5A0084848400D6D6D6008C8C8C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000010004AE7
      FF0029E7FF0029DEFF000008210052EFEF0052EFE70052F7EF0039EFE7000018
      29004AEFFF0042D6F70000001800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006363630063636300848484009C9C
      9C00D6D6D60084848400D6D6D600A5A5A5000000000000000000000000000000
      00000000000000000000000000000000000000000000001000005ADED60021CE
      DE0029D6FF000000310042DEFF0042FFFF0010F7EF0018FFF70021EFFF0031CE
      F7000008390042D6FF005ACEE700000000000000000000000000000000000000
      000000000000FF9C310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      840073737300D6D6D60000000000D6D6D6008C8C8C0000000000000000000000
      000000000000000000000000000000000000000000000018000039DECE004AFF
      FF0031E7FF00000031004AF7FF0000EFF70000FFFF0000FFFF0010F7FF0042E7
      FF0000184A0029D6F70042CEDE00000800000000000000000000000000000000
      0000FF9C3100FF9C310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000094949400D6D6D60000000000D6D6D6009C9C9C00000000000000
      000000000000000000000000000000000000000000000021000039FFE70029FF
      FF0018EFFF0029F7FF0018EFFF0000F7FF0000FFFF0008FFFF0010FFFF0018EF
      FF0018DEFF0018DEFF0021C6D60000080000000000000000000000000000FF9C
      3100FFCE3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C
      3100FF9C31000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000073737300D6D6D60000000000D6D6D600848484008484
      840063636300737373000000000000000000000000000031100039EFDE0029FF
      FF0021FFFF0010DEFF0018EFFF0021FFFF0031FFFF0029FFFF0029FFFF0021EF
      FF0018DEFF0018D6F70042DEEF00001010000000000000000000FF633100FFFF
      9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF
      9C00FF9C31000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084848400D6D6D60084848400D6D6D600D6D6
      D600D6D6D600D6D6D600ADADAD000000000000000000000800007BFFFF0018DE
      E70018EFFF005AFFFF0000082100001818004AE7DE005AFFF700001010000008
      210052DEFF004ADEFF0042BDDE0000001000000000000000000000000000FF63
      3100FFFF9C00FFFF9C0000000000FF633100FF633100FF633100FF633100FF63
      3100FF6331000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000063636300D6D6D600848484005A5A
      5A00ADADAD00848484008C8C8C000000000000000000000000000010100042EF
      F70039FFFF0039DEEF00001021000010100063FFFF0042EFE700002121000018
      290042C6E70039B5D60000102900000000000000000000000000000000000000
      0000FF633100FFFF9C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000636363009C9C9C007B7B7B000000
      000000000000A5A5A5009C9C9C000000000000000000000000000008000073FF
      EF004AFFFF0031FFFF0021FFFF0018FFFF0018FFFF0010F7FF0010EFF70010D6
      DE0039DEEF006BDEEF0000000800000000000000000000000000000000000000
      000000000000FF63310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006363630084848400B5B5B5000000
      000000000000C6C6C600CECECE00000000000000000000000000000000000008
      000063EFDE0031E7E70029FFFF0021FFFF0010EFF70029FFFF0010DEE70031DE
      E70052D6E7000000080000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000636363005A5A5A00848484009C9C
      9C00CECECE000000000000000000000000000000000000000000000000000000
      0000001008000008080063EFE70052F7F70052EFF7004AD6DE006BD6DE000000
      1000000010000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063636300636363008484
      8400C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000080000001010000010080000101800000008000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000070000000000000007000000000000
      0007000000000000000700000000000000070000000000000007000000000000
      000700000000000000070000000000000000000000000000FF18000000000000
      FF18000000000000FF18000000000000FF18000000000000FF00000000000000
      FF00000000000000FF81000000000000FFFFFFFFFFFF8001FFFFFFFFFFFF8001
      0001F81FF81F80010001E00FE00F80010001C007C00780010001C007C0078001
      000180038003800100018003800380010001800380038001000180038003C7E3
      000180038003C7E30001C007C007C7E30001C007C007C3C380FFE00FE00FC003
      C1FFF83FF83FE007FFFFFFFFFFFFF81FFFFFF81FC001FFF9FFFFE007C001F830
      FFFFC003C001E000FFBF8001C001C001FF9F8001C0018003FF8F0000C0018003
      C0070000C0010001C0030000C0010001C0030000C0010001C0070000C0010001
      FF8F0000C0010001FF9F8001C0018003FFBF8001C0018003FFFFC003C003C007
      FFFFE007C007E00FFFFFF81FC00FF83FFFFFC3FFFC1FFFFFFFFFC1FFF007FFFF
      FFFF31FFE003FFFFFFFF31FFC001FDFFFFFF01FFC001F9FFFFFF00FF8000F1FF
      FEFF827F8000E003FC7FF93F8000C003F83FFC838000C003FFFFFE018000E003
      FFFFFF01C001F1FFFFFFFF19C001F9FFFFFFFF19E003FDFFFFFFFF07F007FFFF
      FFFFFF87FC1FFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ColorImageList: TImageList
    Left = 465
    Top = 312
  end
  object ClientPopupMenu2: TSpTBXPopupMenu
    Left = 576
    Top = 192
    object PlayerSubMenu: TSpTBXSubmenuItem
      Caption = 'PlayerSubMenu'
      object mnuOpenPrivateChat: TSpTBXItem
        Caption = 'Chat with'
        ImageIndex = 2
        Images = MiscImageList
        OnClick = mnuOpenPrivateChatClick
      end
      object SpTBXItem1: TSpTBXItem
        Caption = 'Play with'
        OnClick = SpTBXItem1Click
      end
      object mnuSelectBattle: TSpTBXItem
        Caption = 'Find battle'
        OnClick = mnuSelectBattleClick
      end
      object ModerationSubmenuItem: TSpTBXSubmenuItem
        Caption = 'Moderation'
        ImageIndex = 1
        Images = MiscImageList
        object SpTBXLabelItem1: TSpTBXLabelItem
          Caption = 'Servimus et servamus'
          FontSettings.Bold = tsTrue
        end
        object SpTBXSeparatorItem1: TSpTBXSeparatorItem
        end
        object mnuKick: TSpTBXItem
          Caption = 'Kick'
          OnClick = mnuKickClick
        end
        object mnuKickReason: TSpTBXItem
          Caption = 'Kick (+reason)'
          OnClick = mnuKickReasonClick
        end
        object SpTBXSeparatorItem12: TSpTBXSeparatorItem
        end
        object MuteSubitemMenu: TSpTBXSubmenuItem
          Caption = 'Mute'
          object mnuMute5Min: TSpTBXItem
            Caption = '5 Min'
            OnClick = mnuMute5MinClick
          end
          object mnuMute30Min: TSpTBXItem
            Caption = '30 Min'
            OnClick = mnuMute30MinClick
          end
          object mnuMute1Hour: TSpTBXItem
            Caption = '1 Hour'
            OnClick = mnuMute1HourClick
          end
          object mnuMute1Day: TSpTBXItem
            Caption = '1 Day'
            OnClick = mnuMute1DayClick
          end
          object mnuMute1Week: TSpTBXItem
            Caption = '1 Week'
            OnClick = mnuMute1WeekClick
          end
          object SpTBXSeparatorItem6: TSpTBXSeparatorItem
          end
          object mnuMuteCustom: TSpTBXItem
            Caption = 'Custom'
            OnClick = mnuMuteCustomClick
          end
        end
        object mnuUnmute: TSpTBXItem
          Caption = 'Unmute'
          OnClick = mnuUnmuteClick
        end
        object SpTBXSeparatorItem13: TSpTBXSeparatorItem
        end
        object SpTBXItem2: TSpTBXItem
          Caption = 'IP'
          OnClick = SpTBXItem2Click
        end
        object mnuFindIP: TSpTBXItem
          Caption = 'Get usernames by IP'
          OnClick = mnuFindIPClick
        end
      end
      object SpTBXSeparatorItem11: TSpTBXSeparatorItem
      end
      object mnuIgnore: TSpTBXItem
        Caption = 'Ignore'
        OnClick = mnuIgnoreClick
      end
      object mnuAddToGroup: TSpTBXSubmenuItem
        Caption = 'Add to group'
        object mnuNewGroup: TSpTBXItem
          Caption = 'New group ...'
          OnClick = mnuNewGroupClick
        end
        object SpTBXSeparatorItem4: TSpTBXSeparatorItem
        end
      end
      object mnuRemoveFromGroup: TSpTBXItem
        Caption = 'Remove from group'
        OnClick = mnuRemoveFromGroupClick
      end
      object SpTBXSeparatorItem3: TSpTBXSeparatorItem
      end
      object mnuManageGroups: TSpTBXItem
        Caption = 'Manage groups'
        OnClick = mnuManageGroupsClick
      end
    end
  end
  object SearchFormPopupMenu: TSpTBXFormPopupMenu
    PopupFocus = True
    Left = 548
    Top = 78
  end
  object BattleListPopupMenu: TSpTBXPopupMenu
    OnInitPopup = BattleListPopupMenuInitPopup
    Left = 280
    Top = 248
    object mnuBattleHost: TSpTBXSubmenuItem
      Caption = 'Host'
      LinkSubitems = PlayerSubMenu
    end
    object mnuBattleAddToFilters: TSpTBXSubmenuItem
      Caption = 'Add to filters'
      object mnuDisplayOnly: TSpTBXSubmenuItem
        Caption = 'Display only battles with this'
        object mnuDisplayOnlyHost: TSpTBXItem
          Caption = 'Host'
          OnClick = mnuDisplayOnlyHostClick
        end
        object mnuDisplayOnlyMod: TSpTBXItem
          Caption = 'Mod'
          OnClick = mnuDisplayOnlyModClick
        end
        object mnuDisplayOnlyMap: TSpTBXItem
          Caption = 'Map'
          OnClick = mnuDisplayOnlyMapClick
        end
      end
      object mnuHideEvery: TSpTBXSubmenuItem
        Caption = 'Hide every battles with this'
        object mnuHideEveryHost: TSpTBXItem
          Caption = 'Host'
          OnClick = mnuHideEveryHostClick
        end
        object mnuHideEveryMod: TSpTBXItem
          Caption = 'Mod'
          OnClick = mnuHideEveryModClick
        end
        object mnuHideEveryMap: TSpTBXItem
          Caption = 'Map'
          OnClick = mnuHideEveryMapClick
        end
      end
    end
    object mnuBattleDlMap: TSpTBXItem
      Caption = 'Download map'
      OnClick = mnuBattleDlMapClick
    end
    object mnuBattleDlMod: TSpTBXItem
      Caption = 'Download mod'
      OnClick = mnuBattleDlModClick
    end
    object SpTBXSeparatorItem14: TSpTBXSeparatorItem
    end
    object mnuDisplayFilters: TSpTBXItem
      Caption = 'Display filters'
      OnClick = mnuDisplayFiltersClick
    end
  end
  object HelpPopupMenu: TSpTBXPopupMenu
    Left = 444
    Top = 86
    object mnuHelp: TSpTBXItem
      Caption = 'Help'
      FontSettings.Bold = tsTrue
      OnClick = mnuHelpClick
    end
    object mnuForceLobbyUpdateCheck: TSpTBXItem
      Caption = 'Check for Lobby Update'
      OnClick = mnuForceLobbyUpdateCheckClick
    end
    object SpTBXSeparatorItem7: TSpTBXSeparatorItem
    end
    object SubMenuWiki: TSpTBXSubmenuItem
      Caption = 'Wiki / Online help'
      object mnuFAQ: TSpTBXItem
        Caption = 'FAQ'
        OnClick = mnuFAQClick
      end
      object mnuPlayingSpring: TSpTBXItem
        Caption = 'Playing spring'
        OnClick = mnuPlayingSpringClick
      end
      object mnuStrategyAndTactics: TSpTBXItem
        Caption = 'Strategy and Tactics'
        OnClick = mnuStrategyAndTacticsClick
      end
      object mnuGlossary: TSpTBXItem
        Caption = 'Glossary'
        OnClick = mnuGlossaryClick
      end
    end
    object SpTBXItem6: TSpTBXItem
      Caption = 'Quick start'
      OnClick = SpTBXItem6Click
    end
    object SpTBXSeparatorItem5: TSpTBXSeparatorItem
    end
    object mnuSpringHomePage: TSpTBXItem
      Caption = 'Spring Home Page'
      OnClick = mnuSpringHomePageClick
    end
    object mnuMessageboard: TSpTBXItem
      Caption = 'Messageboard'
      OnClick = mnuMessageboardClick
    end
    object mnuBugTracker: TSpTBXItem
      Caption = 'Report a bug'
      Hint = 'Bug tracker'
      OnClick = mnuBugTrackerClick
    end
    object mnuUnknownFiles: TSpTBXItem
      Caption = 'Download maps,mods,scripts'
      Hint = 'uknown-files.net'
      OnClick = mnuUnknownFilesClick
    end
    object mnuSpringReplays: TSpTBXItem
      Caption = 'Spring Replays'
      Visible = False
      OnClick = mnuSpringReplaysClick
    end
    object mnuSpringLadder: TSpTBXItem
      Caption = 'Spring Ladder'
      OnClick = mnuSpringLadderClick
    end
    object SpTBXItem3: TSpTBXItem
      Caption = 'Beta lobby changelog'
      OnClick = SpTBXItem3Click
    end
  end
  object HttpCli1: THttpCli
    LocalAddr = '0.0.0.0'
    ProxyPort = '80'
    Agent = 'Mozilla/4.0 (compatible; ICS)'
    Accept = 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*'
    NoCache = False
    ContentTypePost = 'application/x-www-form-urlencoded'
    MultiThreaded = False
    RequestVer = '1.0'
    FollowRelocation = True
    LocationChangeMaxCount = 5
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Options = []
    SocksAuthentication = socksNoAuthentication
    Left = 324
    Top = 163
  end
  object HostBattlePopupMenu: TSpTBXPopupMenu
    Left = 100
    Top = 86
    object menuHostBattle: TSpTBXItem
      Caption = 'Host battle'
      OnClick = menuHostBattleClick
    end
    object mnuHostLadderBattle: TSpTBXItem
      Caption = 'Host ladder battle'
      OnClick = mnuHostLadderBattleClick
    end
    object mnuHostReplay: TSpTBXItem
      Caption = 'Host replay'
      OnClick = mnuHostReplayClick
    end
    object SpTBXSeparatorItem8: TSpTBXSeparatorItem
    end
    object mnuBattleScreen: TSpTBXItem
      Caption = 'Battle screen'
      ShortCut = 113
      OnClick = mnuBattleScreenClick
    end
  end
  object ConnectionPopupMenu: TSpTBXPopupMenu
    OnPopup = ConnectionPopupMenuPopup
    Left = 20
    Top = 86
    object mnuBack: TSpTBXItem
      Caption = 'Available'
      Checked = True
      OnClick = mnuBackClick
    end
    object mnuAway: TSpTBXItem
      Caption = 'Away'
      OnClick = mnuAwayClick
    end
    object SpTBXSeparatorItem10: TSpTBXSeparatorItem
    end
    object mnuNewAwayMsg: TSpTBXItem
      Caption = 'New away message ...'
      OnClick = mnuNewAwayMsgClick
    end
    object RemoveMenu: TSpTBXSubmenuItem
      Caption = 'Delete'
    end
    object SpTBXSeparatorItem2: TSpTBXSeparatorItem
    end
  end
  object RichEditPopupMenu: TSpTBXPopupMenu
    OnPopup = RichEditPopupMenuPopup
    Left = 180
    Top = 166
    object Copy1: TSpTBXItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object SpTBXSeparatorItem9: TSpTBXSeparatorItem
    end
    object Clearwindow1: TSpTBXItem
      Caption = 'Clear window'
      OnClick = Clearwindow1Click
    end
    object AutoScroll1: TSpTBXItem
      Caption = 'Auto Scroll'
      Visible = False
      OnClick = AutoScroll1Click
    end
    object AutoJoin1: TSpTBXItem
      Caption = 'Auto Join'
      OnClick = AutoJoin1Click
    end
  end
  object ArrowList: TImageList
    Left = 496
    Top = 312
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      E00FFEFF00000000F01FFC7F00000000F83FF83F00000000FC7FF01F00000000
      FEFFE00F00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object HighlighBattlesTimer: TTimer
    OnTimer = HighlighBattlesTimerTimer
    Left = 148
    Top = 166
  end
  object HttpCli2: THttpCli
    LocalAddr = '0.0.0.0'
    ProxyPort = '80'
    Agent = 'Mozilla/4.0 (compatible; ICS)'
    Accept = 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*'
    NoCache = False
    ContentTypePost = 'application/x-www-form-urlencoded'
    MultiThreaded = False
    RequestVer = '1.0'
    FollowRelocation = True
    LocationChangeMaxCount = 5
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Options = []
    SocksAuthentication = socksNoAuthentication
    Left = 356
    Top = 163
  end
  object LadderCups: TImageList
    Left = 528
    Top = 312
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000793AC000793AC000793AC000793AC000793AC000793AC000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006A6B6B006A6A6B00696A6A006868690067676700656565000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000159A8000159A8000159A8000159A8000159A8000159A8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000793AC0001ECE0008EFEFE0001DEE80000B1A4000793AC000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007070710077787800C9C9CA00757676005252520069696A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000159A80000AFCB0063C3DE0000A2D0000075A2000159A8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000793AC000793AC000793AC000793AC00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007474750073737300717272006F707000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000159A8000159A8000159A8000159A800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000793AC000793AC0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000777878007676760000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000159A8000159A80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000793AC000793AC0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007C7C7D007A7A7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000159A8000159A80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000793AC0000ACA8000492AB000793AC00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008383830060606000787979007C7C7D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000159A8000070A4000058A7000159A800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000793AC0000E0FE0000D2FE000091CC000098A7000793AC000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000898A8A00898A8A0087888800707070006B6C6C007D7D7E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000159A80000A3DE000095DE000057BE00005DA3000159A8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000793AC0000E1FE0000E3DE009EFEFE0000D0CE00029EE9000084CA000793
      AC00000000000000000000000000000000000000000000000000000000000000
      0000909091009A9A9A0089898900000000007475750094949500717272007D7E
      7E00000000000000000000000000000000000000000000000000000000000000
      00000159A80000A4DE0000A7CA006FC3DE000093BF000062D100004BBC000159
      A800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000793
      AC000793AC0000E7FE0090FBFE0076EBDA0001F3FE0000D2FE000490CA000793
      AC000793AC000000000000000000000000000000000000000000000000009797
      9800959696009596960000000000F2F3F400A2A2A2008A8A8B008B8B8C008181
      82007D7D7D000000000000000000000000000000000000000000000000000159
      A8000159A80000ABDE0064BFDE0053AEC70000B7DE000095DE000056BC000159
      A8000159A8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000793AC000000
      00000793AC000AE1FE0047E6F300B2FEF50000E2F00000DEF60000A0A6000793
      AC00000000000793AC00000000000000000000000000000000009E9F9F000000
      00009A9B9B00C5C5C600EEEFEF00000000008B8B8B008B8B8C00626263008485
      8500000000007B7B7C00000000000000000000000000000000000159A8000000
      00000159A80002A4DE0030A9D7007CC3D80000A5D50000A2D9000064A3000159
      A800000000000159A80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000793AC00000000000000
      00000793AC0000C5FB008EFEFE00DDFEE10001DEF00000D7FE00009CD2000793
      AC0000000000000000000793AC000000000000000000A6A7A700000000000000
      00009FA0A0009E9F9F000000000000000000A2A2A3009B9C9C007B7C7C008888
      880000000000000000007878790000000000000000000159A800000000000000
      00000159A8000088DC0063C3DE0099C3CB0000A2D500009ADE000061C2000159
      A80000000000000000000159A800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000793AC00000000000000
      00000793AC0000F3FE0085EDFE00E1FCEC0000CEFE0000CFFE000085BE000793
      AC0000000000000000000793AC000000000000000000ACADAE00000000000000
      0000A5A5A600ADAEAE000000000000000000A9A9AA009C9D9D00808080008B8C
      8C0000000000000000007A7B7B0000000000000000000159A800000000000000
      00000159A80000B7DE005DB1DE009CC0D2000091DE000092DE00004CB4000159
      A80000000000000000000159A800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000793AC000793
      AC000793AC0000E9DC00D1ECFE00A0E9F10000ECFE0000E0FE0000A9AA000793
      AC000793AC000793AC0000000000000000000000000000000000B0B1B100AEAE
      AF00AAABAB009F9FA00000000000000000009F9FA000A2A2A300707071008E8F
      8F00898A8A0083838400000000000000000000000000000000000159A8000159
      A8000159A80000ADC80092AFDE0070ADD60000AFDE0000A3DE00006DA6000159
      A8000159A8000159A80000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000793AC000793AC000793AC000793AC000793AC000793AC000793AC000793
      AC00000000000000000000000000000000000000000000000000000000000000
      0000B0B1B100ADADAE00A8A9AA00A5A5A600A0A1A1009C9C9D00979798009292
      9300000000000000000000000000000000000000000000000000000000000000
      00000159A8000159A8000159A8000159A8000159A8000159A8000159A8000159
      A800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000F81FF81FF81F0000
      F81FF81FF81F0000FC3FFC3FFC3F0000FE7FFE7FFE7F0000FE7FFE7FFE7F0000
      FC3FFC3FFC3F0000F81FF81FF81F0000F00FF10FF00F0000E007E207E0070000
      D00BD10BD00B0000B00DB30DB00D0000B00DB30DB00D0000C003C303C0030000
      F00FF00FF00F0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object LadderCupsRefresh: TTimer
    Interval = 120000
    OnTimer = LadderCupsRefreshTimer
    Left = 388
    Top = 166
  end
  object ClientPopupMenu: TSpTBXPopupMenu
    LinkSubitems = PlayerSubMenu
    OnInitPopup = ClientPopupMenuInitPopup
    Left = 540
    Top = 190
  end
end
