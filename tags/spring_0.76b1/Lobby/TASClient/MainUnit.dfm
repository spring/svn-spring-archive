object MainForm: TMainForm
  Left = 305
  Top = 149
  Width = 789
  Height = 548
  Caption = 'TASClient'
  Color = clBtnFace
  Constraints.MaxHeight = 974
  Constraints.MaxWidth = 1280
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
          Header.AutoSizeIndex = 6
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
              Position = 6
              Width = 175
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
          DesignSize = (
            611
            173)
          object FilterValueTextBox: TSpTBXEdit
            Left = 216
            Top = 16
            Width = 137
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
            Left = 360
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
            ItemIndex = 0
            TabOrder = 4
            Text = 'Host'
            Items.Strings = (
              'Host'
              'Map'
              'Mod'
              'Description')
          end
          object RemoveFromFilterListButton: TSpTBXButton
            Left = 360
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
            Left = 360
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
            Left = 400
            Top = 16
            Width = 201
            Height = 145
            Anchors = [akLeft, akTop, akRight]
            ClipboardFormats.Strings = (
              'Unicode text')
            CustomCheckImages = ButtonImageList
            DragOperations = []
            Header.AutoSizeIndex = 2
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'MS Sans Serif'
            Header.Font.Style = []
            Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
            Header.SortColumn = 0
            Header.Style = hsFlatButtons
            TabOrder = 8
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
            OnCompareNodes = FilterListCompareNodes
            OnGetText = FilterListGetText
            OnHeaderClick = FilterListHeaderClick
            Columns = <
              item
                Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
                Position = 0
                Width = 80
                WideText = 'Type'
              end
              item
                Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
                Position = 1
                WideText = ' '
              end
              item
                Position = 2
                Width = 67
                WideText = 'Value'
              end>
          end
          object SpTBXPanel1: TSpTBXPanel
            Left = 8
            Top = 48
            Width = 345
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
              Width = 120
              Height = 15
              Caption = 'My rank >= Rank limit'
              TabOrder = 5
              OnClick = RankLimitFilterClick
              Checked = True
              State = cbChecked
            end
            object ReplaysFilter: TSpTBXCheckBox
              Left = 88
              Top = 56
              Width = 78
              Height = 15
              Caption = 'ReplaysFilter'
              TabOrder = 6
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
            object SpTBXLabel1: TSpTBXLabel
              Left = 208
              Top = 12
              Width = 37
              Height = 13
              Caption = 'Players '
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object PlayersSignButton: TSpTBXButton
              Left = 272
              Top = 8
              Width = 25
              Height = 20
              Caption = '<'
              TabOrder = 11
              OnClick = PlayersSignButtonClick
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object PlayersValueTextBox: TJvSpinEdit
              Left = 296
              Top = 8
              Width = 41
              Height = 20
              ButtonKind = bkStandard
              MaxValue = 16.000000000000000000
              Value = 10.000000000000000000
              TabOrder = 12
              OnChange = PlayersValueTextBoxChange
            end
            object SpTBXLabel2: TSpTBXLabel
              Left = 208
              Top = 40
              Width = 60
              Height = 13
              Caption = 'Max Players '
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object MaxPlayersSignButton: TSpTBXButton
              Left = 272
              Top = 39
              Width = 25
              Height = 20
              Caption = '<'
              TabOrder = 14
              OnClick = MaxPlayersSignButtonClick
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object MaxPlayersValueTextBox: TJvSpinEdit
              Left = 296
              Top = 39
              Width = 41
              Height = 20
              ButtonKind = bkStandard
              MaxValue = 16.000000000000000000
              MinValue = 1.000000000000000000
              Value = 10.000000000000000000
              TabOrder = 15
              OnChange = MaxPlayersValueTextBoxChange
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
          Caption = 'Search UF'
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
      0000000000003600000028000000400000008000000001001000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000008218C31AD35AD35
      AD35AD35AD35AD358C3108210000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004A29D65AD65AD65AD65A
      D65AD65AD65AD65AD65AD65A4A29000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000E71CEF3DEF3DEF3DEF3DEF3D
      EF3DEF3DEF3DEF3DEF3DEF3DEF3DE71C00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000C618C618C618C6188410420C
      C618C618C6188410A514C618C618C61800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000021044208420842082104422C2220
      420842084208211C211C42084208420821040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208210464404448
      2104420800084450433442084208420821040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420821144458
      223C011423504454211042084208420821040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420842080120
      2464046C035C0114420842084208420821040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420821042234
      2464046803482108420842084208420821040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208210863404458
      2238022C24604450212021084208420821040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208422064482228
      21044208011C4448433421084208420821040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208210C63342104
      4208420842082104210442084208420821040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000420842084208420800004208
      4208420842084208420842084208420800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000210442084208420842084208
      4208420842084208420842084208210400000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000021044208420842084208
      4208420842084208420842082104000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000821210421042104
      2104210421042104210408210000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000008218C31AD35AD35
      AD35AD35AD35AD358C31082100000000000000000000000008218C31AD35AD35
      AD35AD35AD35AD358C3108210000000000000000000000000821C618E71CE71C
      E71CE71CE71CE71CC61808210000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004A29D65AD65AD65AD65A
      D65AD65AD65AD65AD65AD65A4A2900000000000000004A29D65AD65AD65AD65A
      D65AD65AD65AD65AD65AD65A4A290000000000000000C618CE39EF3D10421042
      1042104210421042EF3DCE39C618000000000000000000000000000000000000
      0000000000000000000000000000000000000000E71CEF3DEF3DEF3DEF3DEF3D
      EF3DEF3DEF3DEF3DEF3DEF3DEF3DE71C00000000E71CEF3DEF3DEF3DEF3DEF3D
      EF3DEF3DEF3DEF3DEF3DEF3DEF3DE71C0000000084104A298C31AD35CE39CE39
      CE39CE39CE39CE39AD358C314A29841000000000000000000000000000000000
      0000000000000000000000000000000000000000C618C618C618C618C6184A29
      0821C618C618C618C618C618C618C61800000000C618C618C618C618C618E818
      E718C618C618C618C618C618C618C618000000008410A514C618C618C618E818
      E718C618C618C618C618C618A514841000000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420842084A29
      5A6B84104208420842084208420842082104210442084208420842084208A708
      720564084208420842084208420842082104000042084208420842084208A708
      7205640842084208420842084208420800000000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420842084A29
      FF7F5A6B8410420842084208420842082104210442084208420842084208A708
      B609B415640C420842084208420842082104210442084208420842084208A708
      B609B415640C4208420842084208420821040000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420842082925
      DE7BDE7B3967841042084208420842082104210442084208420842084208A708
      3922DC3A5732840C42084208420842082104210442084208420842084208A708
      3922DC3A5732840C420842084208420821040000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420842082925
      BD77BD77BD77B55642084208420842082104210442084208420842084208C80C
      9A2E5E4B3D47D32142084208420842082104210442084208420842084208C80C
      9A2E5E4B3D47D321420842084208420821040000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420842080821
      5A6B5A6B3967E71C42084208420842082104210442084208420842084208A708
      3922DC3A9A36C71042084208420842082104210442084208420842084208A708
      3922DC3A9A36C710420842084208420821040000000000000000000000000000
      000000000000000000000000000000000000210442084208420842084208E71C
      B5569452C618420842084208420842082104210442084208420842084208A708
      B609F615A710420842084208420842082104210442084208630C42084208A708
      B609F615A71042084208630C4208420821040000000000000000000000000000
      000000000000000000000000000000000000210442084208420842084208A514
      AD35A5144208420842084208420842082104210442084208420842084208A708
      950186084208420842084208420842082104210442084208841042084208A708
      9501860842084208420884104208420821040000000000000000000000000000
      0000000000000000000000000000000000002104420842084208420842084208
      630C420842084208420842084208420821042104420842084208420842088608
      860842084208420842084208420842082104210442084208E71C630C42088608
      8608420842084208630CE71C4208420821040000000000000000000000000000
      0000000000000000000000000000000000000000420842084208420842084208
      4208420842084208420842084208420800000000420842084208420842084208
      420842084208420842084208420842080000000042084208AD3508218410630C
      42084208630C84100821AD354208420800000000000000000000000000000000
      0000000000000000000000000000000000000000210442084208420842084208
      4208420842084208420842084208210400000000210442084208420842084208
      420842084208420842084208420821040000000021044208CE39F75ED65AB556
      B556B556B556D65AF75ECE394208210400000000000000000000000000000000
      0000000000000000000000000000000000000000000021044208420842084208
      4208420842084208420842082104000000000000000021044208420842084208
      42084208420842084208420821040000000000000000210442082925EF3D3146
      314631463146EF3D292542082104000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000821210421042104
      2104210421042104210408210000000000000000000000000821210421042104
      2104210421042104210408210000000000000000000000000821210421042104
      2104210421042104210408210000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      0000000000003600000028000000400000003000000001001000000000000018
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000945210428C3110420000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F75ED65A10425A6B8C31
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D65AF75E00000000D65A5A6B6B2D
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C31B5560000000010425A6B1042
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C311042734E6B2D10425A6B3146
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C318C311042734E5A6B10425A6B
      9452000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000104210421042CE395A6B0000
      5A6B314600000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000524A5A6B
      00005A6B734E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CE39
      5A6B00005A6B104210428C31CE39000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      10425A6B10425A6B5A6B5A6B5A6BB55600000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C315A6B10426B2DB5561042314600000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C31734EEF3D000000009452734E00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C311042D65A000000001863396700000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C316B2D1042734E39670000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000008C318C31104218630000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000006C2D5536
      B21DF32595460000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002008
      2008200800000000000000000000000000000000000000000000000000000100
      01000100000000000000000000000000000000000000000000000A19FC427D67
      FF7FDF73FB4A353200000000000000000000000000000000000000000000E000
      0001E00000000000000000000000000000000000000000000000000020088020
      8024802020080000000000000000000000000000000000000000000001002704
      270427040100000000000000000000000000000000000000081DDB42FF7FFF7F
      FF7FFF7FFF7BFB4A9546000000000000000000000000000000000000E0008001
      80020001E000000000000000000000000000000000000000000020088020E034
      805DA02880202008000000000000000000000000000000000000010027044B08
      73102808270401000000000000000000000000000000000086085D5FFF7FFF7F
      FF7FB9429D6BBF73F325000000000000000000000000000000000000E002E003
      E003A003400200000000000000000000000000000000000000004010C06D447E
      447E217E4055200C00000000000000000000000000000000000004009714BE1C
      BE1CBC18711002000000000000000000000000000000000065009F6BFF7FFF7F
      5832FF7BFF7FFF7FB21D000000000000000000000000000000000000A61BEF3F
      ED37EB2F80030000000000000000000000000000000000000000601C667E317F
      0F7FED7E007E601800000000000000000000000000000000000006005C2D5F4E
      1F46DF3DBB18050000000000000000000000000000000000C8143C53FF7FFF7F
      783AFF7FFF7F9D6755360000000000000000000000000000000000002925B043
      F75FAB2F630C0000000000000000000000000000000000000000000080610F7F
      987FCB7EE034000000000000000000000000000000000000000000004E295C4E
      3F67FC3D69100000000000000000000000000000000000006310B93E9E6BFF7F
      783AFF7FFF7FFC426C2D00000000000000000000000000000000000000001042
      734EAD350000000000000000000000000000000000000000000000000000657E
      887E007E00000000000000000000000000000000000000000000000000003446
      754EB135000000000000000000000000000000000000000000000100B93E3D57
      9E675D5FDB460A19000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000006310C814
      65008608081D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      000000000000360000002800000050000000140000000100100000000000800C
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000007C007C007C007C007C
      007C007C007C007C007C007C007C007C007C007C007C0000000000000000E07F
      E07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07F0000
      000000000000E003E003E003E003E003E003E003E003E003E003E003E003E003
      E003E003E0030000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00400000000000000000
      00000000000000000000000000000000000000000040007C00000000E07F0042
      000000000000000000000000000000000000000000000000000000000042E07F
      00000000E0032002000000000000000000000000000000000000000000000000
      000000002002E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00001042EF3DCE39CE39
      CE39CE39CE39CE39CE39CE39CE39CE39EF3D10420000007C00000000E07F0000
      1042EF3DCE39CE39CE39CE39CE39CE39CE39CE39CE39CE39EF3D10420000E07F
      00000000E0030000314610421042EF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3D1042
      104231460000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00003146524A524A524A
      524A524A524A524A524A524A524A524A524A31460000007C00000000E07F0000
      31460900524A524A524A524A524A524A524A524A524A524A524A31460000E07F
      00000000E0030000734E09009452945294529452945294529452945294529452
      734E734E0000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C0000734EB556D65A0B00
      0C00F75EF75EF75EF75E0C000B000B000A00734E0000007C00000000E07F0000
      734E0A00D65AF75EF75EF75EF75EF75E0C000C000B000B00B556734E0000E07F
      00000000E0030000B5560B001863396739673967396739670C000C000C000C00
      D65AB5560000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C0000B5560C000D001D3F
      0E00BD77BD77BD770E003D3F1D3FDA3697320A000000007C00000000E07F0000
      B5560C005A6BBD77BD77BD770E000E003D3F0E001D3FDA360C00B5560000E07F
      00000000E0030000D65A0C009C73BD77BD77BD770F000F003D3F0F003D3FFC3A
      0C00D65A0000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00000B000C001C3B5F43
      100010001000000010005F430F001C3BB9360B000000007C00000000E07F0000
      D65A0C009C73FF7F0000100010005F435F4310000F001C3B0C00D65A0000E07F
      00000000E003000018630D00BD77FF7F0000100010005F435F4310000F003D3F
      0D0018630000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00000B00B9361C3B5F43
      100000000000000010005F430F000E00B9360B000000007C00000000E07F0000
      D65A0C009C73FF7F000010005F435F435F4310000F001C3B0C00D65A0000E07F
      00000000E003000018630D00BD77FF7F000010005F435F435F4310000F003D3F
      0D0018630000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00000B00B9361C3B5F43
      100000000000000010005F435F431C3BB9360B000000007C00000000E07F0000
      D65A39670E00FF7F000010005F435F435F4310005F431C3B0C00D65A0000E07F
      00000000E003000018637B6F0F00FF7F000010005F435F435F4310005F433D3F
      0D0018630000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00000B00B9361C3B5F43
      100000000000000010005F435F431C3BB9360B000000007C00000000E07F0000
      D65A39679C730F00100010005F435F435F4310005F431C3B0C00D65A0000E07F
      00000000E003000018637B6FBD770F00100010005F435F435F4310005F433D3F
      0D0018630000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00000B00B9361C3B5F43
      100000000000000010005F430F001C3BB9360B000000007C00000000E07F0000
      D65A39679C73FF7F000010005F435F435F4310000F001C3B0C00D65A0000E07F
      00000000E003000018637B6FBD77FF7F000010005F435F435F4310000F003D3F
      0D0018630000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00000B000C001C3B5F43
      100010001000000010005F430F000E00B9360B000000007C00000000E07F0000
      D65A39679C73FF7F0000100010005F435F4310000F001C3B0C00D65A0000E07F
      00000000E003000018637B6FBD77FF7F0000100010005F435F4310000F003D3F
      0D0018630000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C0000D65A0D000E009F5B
      794E000000000000794EDF6B9F5B3D3FBA360B000000007C00000000E07F0000
      D65A5A6BBD77000000000000794E794EDF6B794E9F5B3D3F0D00D65A0000E07F
      00000000E003000018639C73FF7F000000000000794E794EBF67794EBF635F43
      0E0018630000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C000018637B6FDE7BD739
      794E0000000000000000794ED7390F000D0018630000007C00000000E07F0000
      18637B6FDE7B00000000000000000000794E794ED7390F007B6F18630000E07F
      00000000E00300005A6BDE7B000000000000000000000000BE77BE77BE771842
      DE7B5A6B0000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C000039679C73DE7BFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FDE7B9C7339670000007C00000000E07F0000
      39679C73DE7BFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FDE7B9C7339670000E07F
      00000000E00300009C73FF7F0000000000000000000000000000000000000000
      FF7F9C730000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00005A6B9C739C73BD77
      BD77BD77BD77BD77BD77BD77BD779C739C735A6B0000007C00000000E07F0000
      5A6B9C739C73BD77BD77BD77BD77BD77BD77BD77BD779C739C735A6B0000E07F
      00000000E0030000DE7B00000000000000000000000000000000000000000000
      0000DE7B0000E003000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000007C00680000000000000000
      00000000000000000000000000000000000000000068007C00000000E07F406B
      00000000000000000000000000000000000000000000000000000000406BE07F
      00000000E003C003000000000000000000000000000000000000000000000000
      00000000C003E003000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000007C007C007C007C007C
      007C007C007C007C007C007C007C007C007C007C007C0000000000000000E07F
      E07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07FE07F0000
      000000000000E003E003E003E003E003E003E003E003E003E003E003E003E003
      E003E003E0030000000000000000000000000000000000000000000000000000
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
      0000000000003600000028000000400000001000000001001000000000000008
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000734E524A524A
      524A524A524A524A734E000000000000000000000000000000009B02BB02DB02
      DB02DB02BB02DB029B0200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000734E734E734E
      734E734E734E734E734E00000000000000000000000000000000BC021C037C03
      9C039C039C033C03DC0200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009452734E524A
      524A524A734E9452945200000000000000000000000000000000DC02BD03DE03
      DE03DE03DE03BD03FC0200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094529452734E
      524A734E94529452945200000000000000000000000000000000FD02DE03FF03
      FF03FF03FF03DE033D0300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009452B5569452
      D65AD65A734E94529452000000000000000000000000000000001E03FF03FF03
      FF4BFF4BFF03FF033E0300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B556B556F75E
      5A6B5A6BF75E9452B556000000000000000000000000000000001E03FF03FF4F
      FF6FFF6FFF4BFF031E0300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B556D65A3967
      7B6F7B6F3967D65AB556000000000000000000000000000000001F039F03FF57
      FF6BFF6BFF57BF035F0300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D65AD65A1863
      396739671863D65AD65A00000000000000000000000000000000FF02FF127F4B
      9F579F577F4B3F13FF0200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      0000000000003600000028000000400000005000000001001000000000000028
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000042E07B
      606B606B602D0042000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000038003400300030
      0030003000300030003400380000000000000000000000000000000000000042
      E07B602D00420000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000048004800480048
      0048004800480048004800480000000000000000000000000000000000000000
      606B004200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000005800600058000C
      001800340020002C006000580000000000000000000000000000000000000000
      606B004200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000064006C0074001C
      003C007800780040006C00640000000000000000000000000000000000000042
      E07B602D00420000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000006400700078001C
      003C007C007C007800700064000000000000000000000000000000000042F57F
      E07B606B602D0042000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000640070007C001C
      003C007C007C007C00700064000000000000000000000000000000420042F57F
      E07B606B602D0042004200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000680074007C001C
      213C427C427C007C00740068000000000000000000000000004200000042F57F
      E07B606B602D0042000000420000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000070207CA464210C
      421CE76C087DC57C207C0070000000000000000000000000004200000042F57F
      E07B606B602D0042000000420000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000007C077D8C7DCE7D
      CE7DCE7DCE7D8C7D077D007C000000000000000000000000004200000042F57F
      E07B606B602D0042000000420000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000E77CAC7D0F7E307E
      317E317E307E0F7EAC7DE77C000000000000000000000000004200420042F57F
      E07B606B602D0042004200420000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6186B2DCE39EF3DEF3D
      EF3DEF3DEF3DEF3DCE396B2DC618000000000000000000000000000000420042
      0042004200420042000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000050522D4E
      EB490B4E0B4ECA45AA3D00000000000000000000D65A630C0000000000000000
      600C600C0000000000000000630CD65A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000915E5577
      12731173AE6AAF664D5600000000000000000000620CC45A656F656F656F656F
      434A434A646F626F616F606FC05A620C0000000000000000C001A00180018001
      8001800180018001A001C0010000000000000000000000008039403540314031
      4031403140314031403580390000000000000000000000000000F566777B767F
      527B317BCD6EEF726C5E4C56000000000000000094522546E97FE87FE87FE87F
      85314229E67FE47FE37FE17F2146945200000000000000004002400240024002
      400240024002400240024002000000000000000000000000E04DE04DE04DE04D
      E049E049E04DE04DE04DE04D000000000000000000000000F562376FDA7F957F
      517F507F0E7B0E771077E84D00000000000000000000EE3D8973EA7FEA7FEA7F
      E97FE87FE77FE57FE47F8273ED3D00000000000000000000C0020003C0026000
      C000A001000160010003C002000000000000000000000000405A8062405A400C
      A0184035C020202D8062405A000000000000000000000000B45A9977905E757F
      937F507F507F0E771073C64900000000000000000000BD77A535ED7FEC7FEC7F
      664E654EE97FE67FE57FA235BD770000000000000000000020036003A003E000
      E001C003C0030002600320030000000000000000000000008066C06E0077C01C
      803D207B207BA041C06E8066000000000000000000000000B55A7A73D366967F
      727F927F2F7F2F773177E84D00000000000000000000000010422B67EE7FEE7F
      85318431EA7FE87F2467104200000000000000000000000020038003C003E000
      E001E003E003C00380032003000000000000000000000000A066E072207FC01C
      A03D407F407F207FE072A066000000000000000000000000B55A7A73B25E767B
      B57F727FB47F517B116F4C56000000000000000000000000FF7F8731F07FEF7F
      24252325EB7FE87F8431FF7F00000000000000000000000020038003E003E000
      E001E003E003E00380032003000000000000000000000000A06AE072207FC01C
      A03D407F407F207FE072A06A000000000000000000000000D65A7A6FB25AB97F
      0A4E5377C749116F2C52987F0000000000000000000000000000734ECC5AF17F
      05210321EC7FC65A945200000000000000000000000000004003A003E003E000
      E105E20BE20BE003A0034003000000000000000000000000A06A0077407FC01C
      A13D427F427F407F0077A06A000000000000000000000000B656D55AF55E366F
      0A4A757BE949B87FCA41000000000000000000000000000000000000682DF17F
      26250521EB7F672D000000000000000000000000000000008003E00324136104
      E208671FE823E517E0038003000000000000000000000000E072407FC466610C
      C21C076F687F657F407FE072000000000000000000000000000000009356BA7F
      0C4A7777EB45356F2F4A000000000000000000000000000000000000F75EA956
      E93DE73DA756F75E00000000000000000000000000000000E003E71FEC33EE3B
      EE3BEE3BEE3BEC33E71FE003000000000000000000000000407F677F8C7F8E7F
      8E7F8E7F8E7F8C7F677F407F00000000000000000000000000000000B45A7977
      0D4A78770D4A5873AC3900000000000000000000000000000000000000008A31
      CC7BCB7B8931000000000000000000000000000000000000E71FEC33EF3FF043
      F147F147F043EF3FEC33E71F000000000000000000000000677F8C7FAF7FB07F
      B17FB17FB07FAF7F8C7F677F00000000000000000000000000000000B45A9A7B
      CC41BA7FED457A77104600000000000000000000000000000000000000007B6F
      064206427B6F00000000000000000000000000000000C6186B2DCE39EF3DEF3D
      EF3DEF3DEF3DEF3DCE396B2DC618000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000D45E935A
      D4627156B45E9356EF4100000000000000000000000000000000000000000000
      4A294A2900000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF7F0000FF7FDE7F
      BD7F5A7F0000000000000000000000000000000000000000FF7B0000FF7BFF77
      DF6F9F5B0000000000000000000000000000000000000000FD7F0000FD7FF67F
      D17FA07F0000000000000000000000000000000000000000FF7F0000FF7FDE7F
      BD7F5A7F000000000000000000000000000000000000FF7F0000FF7FDE7FBD7F
      7B7F5A7F737E00000000000000000000000000000000FF7B0000FF7BDF73DF6B
      BF639F575E3700000000000000000000000000000000FB7F0000FB7FF67FD17F
      C77FA07F206B00000000000000000000000000000000FF7F0000FF7FDE7FBD7F
      7B7F5A7F737E00000000000000000000000000000000FF7FFF7FDE7FBD7F5A7F
      197FF77E957E107E0000000000000000000000000000FF7FFF7BB54E2A216B25
      9F577F4B5E3F1E270000000000000000000000000000FE7FFA7F2C4A2529234A
      A07B6077406FC05E0000000000000000000000000000FF7FFF7F314A2929EF49
      197FF77E957E107E000000000000000000000000FF7FFF7FDE7FBD7F5A7F197F
      D67E957E737E107E000000000000000000000000FF7FFF7BDF73BF6742089F53
      7F4B5E3F3E331E27000000000000000000000000FE7FF97FD47FC85E2229807B
      6077406F0067C05E000000000000000000000000FF7FFF7FDE7FD6620829197F
      D67E957E737E107E000000000000000000000000DE7FBD7F7B7F5A7F197FB67E
      957E527E107ECF7D000000000000000000000000FF77DF6FBF67BF5F4208A610
      A60C35221E27FE1A000000000000000000000000F87FD17FCA7FC35E4208A214
      E21CA05AC05EA05A000000000000000000000000DE7FBD7F7B7F746242088418
      A520106E107ECF7D000000000000000000000000BD7F7B7F5A7F197FB67E737E
      327E107ECF7D8D7D000000000000000000000000DF6FBF679F5B9F5342085E3B
      D11DD115FE1AFE12000000000000000000000000D17FC87FA07FA15A2225206B
      0221214AA05A8056000000000000000000000000BD7F7B7F5A7F5362E728737E
      C6288C61CF7D8D7D0000000000000000000000007B7F5A7FF77EB67E737E327E
      EF7DCF7D8D7D8C7D000000000000000000000000BF639F5B9F4F7E4342083522
      C70CB111DE0EDE0E000000000000000000000000C87FA07F807781568210414A
      62100142605260520000000000000000000000007B7F5A7FF77E11626310AD61
      63106B618D7D8C7D0000000000000000000000005A7FF77EB67E737E327EEF7D
      AE7D6C7D4B7D4B7D0000000000000000000000009F577F4F5E4355262B152B11
      1412DE0EDE06DE06000000000000000000000000A07F8077406FC13D412DE220
      404E6052404E404E0000000000000000000000005A7FF77EB67E6B490839A528
      6C6D6C7D4B7D4B7D0000000000000000000000000000957E737E117ECF7DAE7D
      6C7D4B7D4B7D000000000000000000000000000000005E3F3E331E2B1E1FFE16
      DE0EDE06DE0200000000000000000000000000000000406F006BE062A05A8056
      6052404E404E00000000000000000000000000000000957E737E117ECF7DAE7D
      6C7D4B7D4B7D000000000000000000000000000000000000737ECF7DAE7D6C7D
      4B7D6C7D00000000000000000000000000000000000000003E33FE1EFE12DE0A
      DE06DE0A0000000000000000000000000000000000000000006BA05A80564052
      404E404E0000000000000000000000000000000000000000737ECF7DAE7D6C7D
      4B7D6C7D00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008039403540314031
      4031403140314031403580390000000000000000000000000038003400300030
      0030003000300030003400380000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000E04DE04DE04DE04D
      E049E049E04DE04DE04DE04D0000000000000000000000000048004800480048
      0048004800480048004800480000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000405A8062E0490000
      0000C01CA06AA0668062405A0000000000000000000000000058006000480000
      0000001C0068006400600058000000000000000000000000FF7B0000FF7BFF77
      DF6F9F5B0000000000000000000000000000000000000000FD7F0000FD7FF67F
      F17FC07F00000000000000000000000000000000000000008066C06E0077A041
      A041207B207B0077C06E80660000000000000000000000000064006C00740040
      0040007800780074006C006400000000000000000000FF7B0000FF7BDF73DF6B
      BF639F575E3700000000000000000000000000000000FB7F0000FB7FF67FF17F
      C77FC07F206B000000000000000000000000000000000000A066E072207FC045
      00000000E0208062E072A0660000000000000000000000000064007000780040
      00000000002000600070006400000000000000000000FF7FFF7BDF73DF6BBF5F
      9F577F4B5E3F1E270000000000000000000000000000FF7FFA7FF47FCC7FC37F
      A07F8077406FC06200000000000000000000000000000000A06AE072207FC045
      C045407FE04D4031E072A06A00000000000000000000000000640070007C0040
      0044007C004C0030007000640000000000000000FF7FFF7BDF73BF67BF5F9F53
      7F4B5E3F3E331E27000000000000000000000000FF7FF97FF47FCA7FC37FA07B
      6077406F0067C06200000000000000000000000000000000A06A0077007B6035
      60358066603540350077A06A0000000000000000000000000068007400742030
      2130415C20300030007400680000000000000000FF77DF6FBF67BF5F9F537F47
      5E3B3E331E27FE1A000000000000000000000000F87FF17FCA7FC27FA07B6073
      406F0067C05EA05A00000000000000000000000000000000E072407F007B0029
      00290029E049437F407FE0720000000000000000000000000070207CA4644220
      422042206338A574207C00700000000000000000DF6FBF679F5B9F537F475E3B
      3E2F1E23FE1AFE12000000000000000000000000F17FC87FC07F807B4073206B
      0067C05EA05A805600000000000000000000000000000000407F677F8C7F8E7F
      8E7F8E7F8E7F8C7F677F407F000000000000000000000000007C077D8C7DCE7D
      CE7DCE7DCE7D8C7D077D007C0000000000000000BF639F5B9F4F7E435E373E2F
      1E23FE1ADE0EDE0E000000000000000000000000C87FC07F807B4073206BE066
      C05EA05A6052605200000000000000000000000000000000677F8C7FAF7FB07F
      B17FB17FB07FAF7F8C7F677F000000000000000000000000E77CAC7D0F7E307E
      317E317E307E0F7EAC7DE77C00000000000000009F577F4F5E435E373E2B1E23
      FE16DE0EDE06DE06000000000000000000000000C07F807B4073206BE062C05E
      A05A6052404E404E000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6186B2DCE39EF3DEF3D
      EF3DEF3DEF3DEF3DCE396B2DC61800000000000000005E3F3E331E2B1E1FFE16
      DE0EDE06DE0200000000000000000000000000000000406F206BE062C05E8056
      6052404E404E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000003E33FE1EFE12DE0A
      DE06DE0A0000000000000000000000000000000000000000206BA05A80566052
      404E404E00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000C001A00180018001
      8001800180018001A001C0010000000000000000000000008039403540314031
      4031403140314031403580390000000000000000000000000038003400300030
      003000300030003000340038000000000000000000000000C001A00180018001
      8001800180018001A001C0010000000000000000000000004002400240024002
      400240024002400240024002000000000000000000000000E04DE04DE04DE04D
      E049E049E04DE04DE04DE04D0000000000000000000000000048004800480048
      0048004800480048004800480000000000000000000000004002400240024002
      400240024002400240024002000000000000000000000000C002000320034003
      40034003400320030003C002000000000000000000000000405A8062A066A06A
      A06AA06AA06AA0668062405A0000000000000000000000000058006000640068
      006800680068006400600058000000000000000000000000C002000340020000
      0000E000400320030003C00200000000000000000000000020036003A003C003
      C003C003C003A003600320030000000000000000000000008066C06E0077207B
      207B207B207B0077C06E80660000000000000000000000000064006C00740078
      0078007800780074006C006400000000000000000000000020036003A0030002
      0002C003C003A0036003200300000000000000000000000020038003C003E003
      E003E003E003C00380032003000000000000000000000000A066E072207F407F
      407F407F407F207FE072A066000000000000000000000000006400700078007C
      007C007C007C00780070006400000000000000000000000020038003C0030002
      00000000000100038003200300000000000000000000000020038003E003E003
      E003E003E003E00380032003000000000000000000000000A06AE072207F407F
      407F407F407F207FE072A06A00000000000000000000000000640070007C007C
      007C007C007C007C0070006400000000000000000000000020038003E0030002
      2002E00360028001800320030000000000000000000000004003A003E003E20B
      E20BE20BE20BE003A0034003000000000000000000000000A06A0077407F427F
      427F427F427F407F0077A06A00000000000000000000000000680074007C427C
      427C427C427C007C007400680000000000000000000000004003A003A0038001
      8105E10680018001A00340030000000000000000000000008003E003E517E823
      E823E823E823E517E0038003000000000000000000000000E072407F657F687F
      687F687F687F657F407FE0720000000000000000000000000070207CC57C087D
      087D087D087DC57C207C00700000000000000000000000008003E00324130209
      02090209C30DA517E0038003000000000000000000000000E003E71FEC33EE3B
      EE3BEE3BEE3BEC33E71FE003000000000000000000000000407F677F8C7F8E7F
      8E7F8E7F8E7F8C7F677F407F000000000000000000000000007C077D8C7DCE7D
      CE7DCE7DCE7D8C7D077D007C000000000000000000000000E003E71FEC33EE3B
      EE3BEE3BEE3BEC33E71FE003000000000000000000000000E71FEC33EF3FF043
      F147F147F043EF3FEC33E71F000000000000000000000000677F8C7FAF7FB07F
      B17FB17FB07FAF7F8C7F677F000000000000000000000000E77CAC7D0F7E307E
      317E317E307E0F7EAC7DE77C000000000000000000000000E71FEC33EF3FF043
      F147F147F043EF3FEC33E71F00000000000000000000C6186B2DCE39EF3DEF3D
      EF3DEF3DEF3DEF3DCE396B2DC618000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6186B2DCE39EF3DEF3D
      EF3DEF3DEF3DEF3DCE396B2DC6180000000000000000C6186B2DCE39EF3DEF3D
      EF3DEF3DEF3DEF3DCE396B2DC618000000000000000000000000000000000000
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
      0000000000003600000028000000400000001000000001001000000000000008
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002104
      2104210400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000004420442
      02460246044204420000000000000000000000000000000000000000283A283A
      283A283A283A283A0000000000000000000000000000000000000000E454C350
      A344A348C448E53C000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000442224A424E0246
      C1564167E25E424E224A0442000000000000000000000000403640364032E018
      4000C029203220322032002E000000000000000000000000E450C360C364C364
      046D246D04690469A24CC3480000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000424E624E625282560163
      E03DE01CA17382566252624E424E0000000000000000202E202E202EA0210000
      00000000202E202E002A002A002A0000000000000000A3548260816C41584074
      4074407440744070407061604138000000000000000000000000000000000000
      0000000000000000000000000000000000000000000082528256C25EE3620267
      616B2163426BE362C25E82568252000000000000000060326032000500000000
      E01000000000402E402E202E202A00000000000000004160416C433C64244340
      00740164433400600070416C416C412400000000000000000000000000000000
      00000000000000000000000000000000000000008256A25AE3620367236B436F
      2163614AC277626F0367E362A25A825600000000803280328032A032200D8019
      A0368021000000006032402E402E202A000000004260426C02700258221C4318
      0250431843184338027002700270426C00000000000000000000000000000000
      0000000000000000000000000000000000000000C35EE362236B436F436F6373
      E15A600CE01CC277436F236BE362C35E00000000A032A036C036C036E03AE03A
      E03AE03A002600000000202A6032602E0000000002740274027402740270421C
      4318222002680274027402740274027400000000000000000000000000000000
      00000000000000000000000000000000000000000363236B436F8B778E778C77
      C677A173600CE03DC677436F236B036300000000C036E036E03A003B60436247
      634B6147003B802E2019000080198032000000000278027C027C027C026C4318
      4318431C0270027C027C027C027C027800000000000000000000000000000000
      0000000000000000000000000000000000000000246B446F6573B17BD77BD77B
      D27BE87B2025E01CC5776573446F246B00000000E03A003B403F644B8953AC5B
      AC5B8B57864F6043003B00220000E01D00000000247C447CE77C447C64248424
      2374642464206558447CE77C447C447C00000000000000000000000000000000
      0000000000000000000000000000000000000000C618446F6573B17BD77BD77B
      D27BE87B2025E01CC5776573446FC618000000000000003B403F644B8953AC5B
      AC5B8B57864F6043003B003B00220000000000000000E77CE77CE77C0A45E968
      087DA57C094DA578E77CE77CE77C000000000000000000000000000000000000
      00000000000000000000000000000000000000000000456F6573AE77D57BEB7B
      2163602D0000A152686F6573456F000000000000000060478553AA5BAF63D167
      D267B067AC5F87536047003FE03A000000000000C618E77CE77CE77C657CA778
      A77CA77C867C657CE77CE77CE77CC61800000000000000000000000000000000
      00000000000000000000000000000000000000000000000065736773AA772163
      00002025E15AC67767736573000000000000000000000000AA5FAE67D26BD46F
      D46FD36BCF67AA5F84572047000000000000000000000000E77CE77C077D4A7D
      6A7D4A7D297D0779E77CE77C0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000B07BE87B
      E17BE77BCD7BB07B0000000000000000000000000000000000000000D673F873
      F873F773D56FD26B00000000000000000000000000000000000000004F7E4F76
      707A4F762E7A4F7E000000000000000000000000000000000000000000000000
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
      0000000000003600000028000000400000003000000001001000000000000018
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001A63B8563B675B6F
      FA5E1A63F95A984E774ADF7B000000000000000000000000A06E206EC072C072
      606E806E606E006AC0692E770000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BE771B67DA5A9752B956
      DA5A9852774EB856B956000000000000000000000000067303778D7B687B8C7B
      8C7B6A7B687B8A7B206E00000000000000000000000000000000000000000000
      0000000000000000524A00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DF7B98521B63DA5A574A
      5D6F1B63FA5E9D777029F95E000000000000000000002C776A7BAF7F8D7B6877
      D57FB17B8D7BD77F6061806E00000000000000000000BE7B6B2D000000000000
      0000000000001042314600000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C6FD95A77525C6BFA5E
      D95AFA5E5D6B3B6BFA62FA5A00000000000000000000C1728C7B8172C172E176
      8C7BE272C172A072E176606E00000000000000000000000010420821B5560000
      000000008C318C31000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003B6BDA5A7D6F0000FF7F
      5D6FDF7B00000000574A1A5F00000000000000000000C0728D7BE17200004E77
      C1722B7700000000C069806E000000000000000000000000D65A8C314A29CE39
      0000AE3931461042000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DF7BFA5EBE7700000000
      000000000000DF7B3B6B3B63000000000000000000002E77AD7B077300000000
      0000000000002E772377A0720000000000000000000000000000CE39AD35E71C
      4A291042524A1042000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF7FFA62FA5E00000000
      0000000000003B6BB952FF7F000000000000000000004E77E276606E00000000
      000000000000C072206E517700000000000000000000000000003146AD358C31
      8C31945231463146000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF7FB85656460000
      0000000035421B5F000000000000000000000000000000005177A172A0650000
      000000006065806E000000000000000000000000000000000000AD353146AD35
      31463146CE393146000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BE7B912D984E
      3B637129163E000000000000000000000000000000000000000004778065006A
      A072E05420610000000000000000000000000000000031464A298C31734E734E
      734E8C31CE398C31F04100000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000005646F439
      D235B3319F7300000000000000000000000000000000000000000000A0652477
      2277037312730000000000000000000000000000B5563146D65A9C739C73F75E
      5A6B7B6F9452CE39AD35EF3D0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A63ED18712D
      564EB9563E670000000000000000000000000000000000000000806E4055E272
      667B8C7BA772000000000000000000000000000000000000FF7FDE7B39679452
      3967DE7BFF7FFF7F5A6BB5563146000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D7314429231F43D9952
      1A63B956774ADB567E6F00000000000000000000000001732065806524778A7B
      AE7B8B7B616E406EE672000000000000000000000000000000000000BD771863
      524A104200000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007D6F9D6F5C675D6B774E
      B9561D63FB5AFB5E1B5F9D6F00000000000000000000E172E172C172C172806E
      8A7B0877806E806E806EE1720000000000000000000000000000000000005A6B
      734E734E00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003A67
      784EFF7F0000000000000000000000000000000000000000000000000000A072
      816E327700000000000000000000000000000000000000000000000000007B6F
      734E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009D73
      B956000000000000000000000000000000000000000000000000000000000173
      206E00000000000000000000000000000000000000000000000000000000DE7B
      D65A000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF7F
      5C6B000000000000000000000000000000000000000000000000000000005077
      E172000000000000000000000000000000000000000000000000000000000000
      1863000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000001342C718
      C018E01CC618D139000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000921BF7700000000
      00000000000000009F732A25000000000000000000000000FF7F0000C05AE07F
      406B406BE07F406B0000DF7B0000000000000000000000000000000000000000
      00000000000000000000BD77000000000000000000000000E81C3A6700000000
      00000000000000007C6F8610000000000000000000000000602D0042B1350000
      000000000000B03520468231000000000000000000000000C618E07FE03D0000
      000000000000602DE07F83100000000000000000000000000000334600000000
      0000000000000000124200000000000000000000000000008331C018B1350000
      000000000000D139C018C23900000000000000000000000000000063A077A614
      00000000C618C07BA05602000000000000000000000000000342602D00000000
      000000000000000080310342000000000000000000000000A035E03D0C210000
      0000000000000B21004240290000000000000000000000004308C07B0042A914
      00000000A914E03DE07F4208000000000000000000000000602DA0350021E07F
      A414E41CE07FC018C03D81310000000000000000000000002429E07FE01C0000
      0000000000008031E07FE31C000000000000000000000000D039006380520C21
      00000000CA1880520063D0390000000000000000000000008431600C00632046
      EB1C2D25604E406B600C813100000000000000000000000000002067E05E2004
      E07FE07F2004206700630000000000000000000000000000E41C600CE07FA056
      00000000406BC07B600C23250000000000000000000000000000D23900630042
      9031D2392046E05E144200000000000000000000000000002725E07FA0140063
      E03DC039406B600CE07FE41C000000000000000000000000602D0021404AE05E
      80104008807300424029402D0000000000000000000000004429E07F600CC05A
      406B406BC05AA014E07FC318000000000000000000000000000000009031A077
      E01CE01CA07790310000000000000000000000000000000000008410E07F4008
      606FC07B2004E07FC41800000000000000000000000000000921E07F602D2046
      A056E05E00428031E07F092100000000000000000000000005212004E07F4029
      204620462025E07F40084329000000000000000000000000000000000000E71C
      E07FE07FE71C00000000000000000000000000000000000000000000C318E07F
      00000000E07FA214000000000000000000000000000000000000EA1CE07FE01C
      A056A0562025C07B4C2900000000000000000000000000008631E07F2004E07F
      8031C018E07F0000E07F4429000000000000000000000000000000000000DF7B
      C039602DFF7F00000000000000000000000000000000000000000000DF7B4029
      606F2067602DBF770000000000000000000000000000000000000000C718E07F
      00004008E07FC91800000000000000000000000000000000BF77E01CE07F4008
      E07FE07F2004E07FE31CFF7F0000000000000000000000000000000000000000
      AE35CE390000000000000000000000000000000000000000000000000000774E
      0063206715420000000000000000000000000000000000000000000000000121
      C07BC07BE11C0000000000000000000000000000000000000000DF7BE01CE07F
      600C600CE07FE01CDF7B00000000000000000000000000000000000000000000
      DF7BDE7B00000000000000000000000000000000000000000000000000000000
      442903210000000000000000000000000000000000000000000000000000FA5E
      A056404A1B63000000000000000000000000000000000000000000009F73A035
      406B805200429F73000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      D75AB55600000000000000000000000000000000000000000000000000000000
      472927250000000000000000000000000000000000000000000000000000774E
      0067A077F23D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      39675A6B00000000000000000000000000000000000000000000000000000000
      E31C022100000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      1863B6560000000000000000000000000000424D3E000000000000003E000000
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
      0000000000003600000028000000400000004000000001001000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000002036E031A02DA029A0298029
      8029802560256025602560214021201D00000000402A0026C021C021A01DA01D
      A01DA01D801D801D801960196019401500000000A00660024002400220022002
      2002200220022002200220020002E00100000000000000000000000000000000
      0000000000000000000000000000000000004208C04A8042603E403E403A203A
      203A003600360036E031E031C02D8029000042080037C032802E802E602E602A
      402A402A202A202620260026E021A01D00004208400720070007E006E006E006
      E006E006E006C006C006C006A006600200000000000000000000000000000000
      000000000000000000000000000000000000A514A05F2053C04AC0468C677B6F
      7B6F7B6F7B6F4D5F403E403A2036C02D0000A514C047603F003BEA5B7B6F7B6F
      7B6FE95BA032802E802E602E402AE0250000A514841770477B6F7B6F7B6F7B6F
      50437B6F7B6F7B6F7B6F50430007A00600000000000000000000000000000000
      000000000000000000000000000000000000A514C063605B004FAC6B7B6F0000
      0000000000007B6F6D636042403E00320000A514E04BA043403F7B6F00000000
      00007B6F7B6FE957A032A032602E202A0000A51484177B6F0000000000000000
      7B6F00000000000000007B6F5043A00600000000000000000000000000000000
      000000000000000000000000000000000000A514E067A05F40577B6F00000000
      7B6F7B6F000000007B6FA0468042203A0000A514E24FC0478043EB5F7B6F7B6F
      0000000000007B6FE036E036A032402A0000A514841770477B6F000000007B6F
      000000007B6F7B6F000000007B6FC00600000000000000000000000000000000
      000000000000000000000000000000000000A514E26BE067805F7B6F00000000
      7B6F7B6F000000007B6FE04AA046403E0000A514E453E14BC047A047EC5F7B6F
      7B6F000000007B6FEA5F003BE036802E0000A514A417820F7B6F000000007B6F
      000000007B6F7B6F000000007B6FC00600000000000000000000000000000000
      000000000000000000000000000000000000A514E46BE16BE067ED6F7B6F0000
      0000000000007B6FCC6B2053E04A80420000A514E653E34FE14BED5F7B6F0000
      00000000000000007B6F403F203BA0320000A514A51B82137B6F000000007B6F
      000000007B6F7B6F000000007B6FE00600000000000000000000000000000000
      000000000000000000000000000000000000A514E66BE36BE16BEE6F7B6F0000
      0000000000007B6FEC6F40572053A0460000A514E757E553E34F7B6F00000000
      7B6F7B6F000000007B6F8043403FE0360000A514A61FA3137B6F000000007B6F
      000000007B6F7B6F000000007B6FE00600000000000000000000000000000000
      000000000000000000000000000000000000A514E86FE56BE36B7B6F00000000
      7B6F7B6F000000007B6F805F6057E04A0000A514E95BE757E5537B6F00000000
      7B6F7B6F000000007B6FC047A043203B0000A514A61FA4177B6F000000007B6F
      000000007B6F7B6F000000007B6F000700000000000000000000000000000000
      000000000000000000000000000000000000A514EA6FE76FE56B7B6F00000000
      7B6F7B6F000000007B6FE067A05F20530000A514EB5FE95BE7577B6F00000000
      7B6F7B6F000000007B6FE14BE047603F0000A514A723924B7B6F000000007B6F
      000000007B6F7B6F000000007B6F000700000000000000000000000000000000
      000000000000000000000000000000000000A514EB73E96FE76FD16F7B6F0000
      0000000000007B6FEF73E16BE067605B0000A514ED5FEA5FE95BF0677B6F0000
      0000000000007B6FEE63E34FE14B80430000A514A7237B6F0000000000007B6F
      7B6F00000000000000007B6F7047010B00000000000000000000000000000000
      000000000000000000000000000000000000A514ED73EB6FE96FE86FD1737B6F
      7B6F7B6F7B6FD06FE46BE46BE167A05F0000A514EE63EC5FEA5BEA5BF1677B6F
      7B6F7B6F7B6FF067E653E553E34FC0470000A514A827924B7B6F7B6F7B6F914B
      91477B6F7B6F7B6F7B6F9147620F010B00000000000000000000000000000000
      000000000000000000000000000000000000E71CF073EF73EE73ED73ED73EC73
      EC73EB73EB6FEA6FEA6FE96FE76FE26B0000E71CF167F067EE63EE63EE63ED63
      ED63EC5FEC5FEC5FEB5FEA5BE857E34F0000E71CAB33A92BA827A827A827A723
      A723A723A723A723A723A723A41B620F00000000000000000000000000000000
      0000000000000000000000000000000000006B2DF477F477F377F277F277F277
      F277F177F177F177F073F073EE73E96F00006B2DF56FF46FF36BF36BF36BF36B
      F26BF26BF26BF167F167F167EF63EB5F00006B2DD043CF43CE3FCE3FCE3FCE3F
      CE3BCE3BCE3BCD3BCD3BCD3BCB33A61F00000000000000000000000000000000
      000000000000000000000000000000000000EF3D314610421042104210421042
      104210421042104210421042CE394A29630CEF3D314610421042104210421042
      104210421042104210421042CE394A29630CEF3D314610421042104210421042
      104210421042104210421042CE394A29630C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000223C223422302230222C222C
      222C222822282128212822282224212000000000C044A03C8034803480348030
      80308030802C802C802C802C80286024000000008045603D2035203520352031
      00310031002D002D002D002DE028E02400000000E045A03D8035803580356031
      60316031602D402D402D402D4029202500004208445043484344234023402340
      233C223C22382238223822342230222C000042080059E050E04CC048C048C044
      C044C040C040C040C03CA03CA038803000004208005AC051A04DA049A049A045
      8045604180416041603D603D4039203100004208A05A6052204E204A204A0046
      0046E041E041E041C03DC03DA03960310000A514C758855443504350434C434C
      115E7B6F7B6F115E23402340233C22340000A5146461216100596F667B6F7B6F
      7B6F7B6F7B6F505EC048C048C044A0380000A51464622162005A005AD0667B6F
      7B6F7B6F7B6FB05EA049A049804540390000A51460770067A05AA05AC97F7B6F
      7B6FC87F404E404E204A204A0046A0390000A514C760855C4458445444544450
      7B6F000000007B6F43484344234022380000A5148469416520617B6F00000000
      0000000000007B6F6F62E04CC048A0400000A514846A61664062F0667B6F0000
      0000000000007B6FD062C04DA04960410000A514807B206FE062C0627B6F0000
      00007B6FC87F60526052404E204AE0410000A514C864866031667B6F7B6F7B6F
      7B6F000000007B6F1162434C4344233C0000A514A471616D20696F6A7B6F7B6F
      7B6F7B6F000000007B6F0055E050C0440000A514A472816E606A7B6F00000000
      7B6F7B6F000000007B6FE055C05180450000A514A07F6077006B0067CA7F7B6F
      000000007B6FA05A805A8056405200460000A5140965A7647B6F000000000000
      00000000000000007B6F4450434C23400000A514C5718371406D406D206D2069
      20697B6F000000007B6F005DE054C0480000A514C6728372806E7B6F00000000
      7B6F7B6F000000007B6F005EE055A0490000A514C27FA07F4073406F206F7B6F
      000000007B6FE062C05EA05E8056204A0000A5144B69E8647B6F000000007B6F
      7B6F000000007B6F31664458445443480000A514E771A471827162716171406D
      8F6E7B6F000000007B6F2065005DE0500000A514E772C572A3727B6F00000000
      00007B6F000000007B6F4066205EC0510000A514C47FC17FA07F807B60777B6F
      000000007B6FCA7FE066E066C05E40520000A5146D692B69736A7B6F00000000
      7B6F000000007B6F446044604458434C0000A5140972C771A471B16E7B6F7B6F
      7B6F000000007B6F8F6E40692065E0540000A514E972C772A5727B6F00000000
      0000000000007B6F106F606A4066E0550000A514C67FC37FC17FA07FA07FCC7F
      7B6F000000007B6F206F206BE06680560000A514AE6D6C692A69746A7B6F0000
      0000000000007B6F86646564645C43500000A5142B760872C6717B6F00000000
      000000007B6F906E6171416D4069005D0000A514EB76E972C772326F7B6F0000
      00007B6F7B6F116F816E816E606A005E0000A514C87FC57FCE7F7B6F7B6FCD7F
      7B6F000000007B6FCC7F6073206FA05E0000A514CF6D8D6D4C694B69946A7B6F
      0000000000007B6FC864A764A66085540000A5144C762A76E871D36E7B6F0000
      00007B6F7B6F7B6FB16E83716269215D0000A5140C77EA76E872E8727B6F0000
      000000007B6F7B6F116FA372826A215E0000A514CA7FC77F7B6F000000007B6F
      7B6F7B6F000000007B6F807F6077E0660000A514F06DCF6D8D6D8D6D6C69946A
      7B6F000000007B6F0969E968C860A6540000A5146E764C762A762A767B6F0000
      00000000000000007B6FA571846D435D0000A5142E770C77EA76EA76336F7B6F
      7B6F0000000000007B6FC572846E435E0000A514CB7FC97FD07F7B6F00000000
      00000000000000007B6FC17FA07F206F0000A5141172F06DAF6DAE6DAE6D8D6D
      956E7B6F7B6F946A4B692A690A65E8580000A5148F766D764C762B76F4727B6F
      7B6F7B6F7B6F7B6FD36EE771C66D85610000A5142F772D770C770B770B770A77
      346F7B6F7B6F7B6F336FC772A66E45620000A514CD7FCB7FC97FD07F7B6F7B6F
      7B6F7B6F7B6F7B6FCF7FC47FC17F60770000E71C747253723272327211721172
      F171F06DF06DCF6DCF6DAF6D8D6D2A610000E71CD27AB176AF768F768F768E76
      6E766D766D766D764C764C762A76C7690000E71C527B517750772F772F772E77
      2E772E772D772D770C770C77EA76A76A0000E71CF07FCF7FCE7FCD7FCD7FCC7F
      CC7FCB7FCB7FCA7FCA7FC97FC77FC27F00006B2DD776D776B676B676B576B576
      9576957695769472747274723272CF6D00006B2D357B157B147BF47AF47AF37A
      F37AF37AF37AD27AD27AD27AB0764C7600006B2D967B957B747B747B747B747B
      737B737B737B727B527B527B50770C7700006B2DF47FF47FF37FF27FF27FF27F
      F27FF17FF17FF17FD07FF07FCE7FC97F0000EF3D314610421042104210421042
      104210421042104210421042CE394A29630CEF3D314610421042104210421042
      104210421042104210421042CE394A29630CEF3D314610421042104210421042
      104210421042104210421042CE394A29630CEF3D314610421042104210421042
      104210421042104210421042CE394A29630C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000001863B5569452734E734E734E
      734E734E734E734E734E734E524A314600000000420842084208420842084208
      42084208210421042104210421042104000000000821E71CE71CC618C618C618
      C618C618C618C618A514A514A514841000000000AD356B2D4A294A294A294A29
      2925292529252925292508210821E71C00004208BD779C735A6B5A6B5A6B5A6B
      396739673967396739673967F75EB55600004208630C630C630C630C630C630C
      42084208420842084208420842084208000042086B2D4A292925292529252925
      29250821082108210821E71CE71CC6180000420831461042EF3DCE39CE39CE39
      AD35AD35AD358C318C318C316B2D4A290000A514DE7BDE7BDE7BBD77BD779C73
      7B6F7B6F7B6F9C739C739C735A6BF75E0000A514E71CA514630C630C31467B6F
      7B6F7B6F7B6F3146630C630C420842080000A514CE39AD356B2D94527B6F7B6F
      7B6F7B6F7B6F7B6F734E29250821E71C0000A5149452734E524AF75E7B6F7B6F
      7B6F7B6F7B6FD65ACE39CE39AD356B2D0000A514FF7FDE7BDE7BDE7BDE7B7B6F
      000000007B6FBD77BD779C737B6F18630000A514E71CA5148410630C7B6F0000
      0000000000007B6F630C630C630C42080000A514EF3DAD358C317B6F00000000
      00000000000000007B6F4A29292508210000A514B5569452734E7B6F00000000
      0000000000007B6FD65AEF3DCE398C310000A514FF7FFF7FFF7FFF7FFF7F9C73
      7B6F7B6F9C73BD77BD77BD779C7318630000A5140821A5148410841031467B6F
      000000007B6F3146630C630C630C42080000A5141042CE39AD35B5567B6F0000
      00007B6F000000007B6F6B2D4A2908210000A514F75EB556945218637B6F7B6F
      7B6F7B6F000000007B6F3146EF3DAD350000A514FF7FFF7FFF7FFF7FFF7F7B6F
      000000007B6FDE7BDE7BDE7B9C7339670000A5142925E71CA514841084107B6F
      000000007B6F8410630C630C630C630C0000A5143146EF3DCE39CE39B5567B6F
      000000007B6F7B6FB5566B2D6B2D29250000A514F75ED65AD65AB556B556B556
      18637B6F000000007B6F524A3146CE390000A514FF7FFF7FFF7FFF7FFF7F7B6F
      000000007B6F9C73FF7FDE7BBD7739670000A5146B2D0821E71CC618A5147B6F
      000000007B6F841084108410630C630C0000A514524A3146EF3DEF3DEF3DD65A
      7B6F000000007B6FB5568C318C314A290000A5141863F75ED65AD65AD65A3967
      7B6F0000000000007B6F734E524AEF3D0000A514FF7FFF7FFF7FFF7FFF7FBD77
      7B6F000000007B6FBD77FF7FDE7B5A6B0000A5148C314A2908210821E71C7B6F
      000000007B6F8410841084108410630C0000A514734E524A314610421042EF3D
      D65A7B6F000000007B6FAD358C316B2D0000A51418631863F75EF75ED65A7B6F
      0000000000007B6F1863B556734E31460000A514FF7FFF7FFF7FBD777B6F7B6F
      BD777B6F000000007B6FFF7FDE7B7B6F0000A514CE398C314A294A2929257B6F
      000000007B6FC618C618A5148410630C0000A5149452734E524AF75E7B6F7B6F
      D65A7B6F000000007B6FCE39AD358C310000A51439671863F75E39677B6F7B6F
      7B6F000000007B6F3967D65A9452524A0000A514FF7FFF7FFF7F7B6F00000000
      7B6F7B6F000000007B6FFF7FDE7B7B6F0000A514EF3DAD358C316B2D94527B6F
      000000007B6F0821E71CE71CC618A5140000A514B5569452734E7B6F00000000
      7B6F7B6F000000007B6F1042EF3DAD350000A5143967396718637B6F00000000
      7B6F7B6F000000007B6FD65AB556524A0000A514FF7FFF7FFF7F7B6F00000000
      0000000000007B6FBD77FF7FDE7B7B6F0000A5141042EF3DAD35AD357B6F0000
      000000007B6F4A29292529250821C6180000A514D65AB556945218637B6F0000
      0000000000007B6FF75E31461042AD350000A5145A6B396739675A6B7B6F0000
      0000000000007B6F3967F75ED65A734E0000A514FF7FFF7FFF7FBD777B6F7B6F
      7B6F7B6F7B6FBD77FF7FFF7FDE7B7B6F0000A51431461042CE39CE39B5567B6F
      7B6F7B6FB5566B2D6B2D4A29292508210000A514D65AB5569452945218637B6F
      7B6F7B6F7B6FF75E524A524A3146CE390000A5145A6B5A6B396739675A6B7B6F
      7B6F7B6F7B6F5A6B18631863D65A94520000E71CFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FBD770000E71C9452734E524A314631463146
      104210421042EF3DEF3DEF3DAD354A290000E71C1863F75EF75ED65AD65AD65A
      D65AB556B556B556B5569452734E31460000E71C7B6F7B6F5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B3967396739673967D65A00006B2DFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00006B2DF75ED65AD65AD65AB556B556
      B556B556B556945294529452524AEF3D00006B2D5A6B5A6B3967396739673967
      396718631863186318631863F75EB55600006B2D9C739C739C739C739C739C73
      7B6F7B6F7B6F7B6F7B6F7B6F5A6B39670000EF3D314610421042104210421042
      104210421042104210421042CE394A29630CEF3D314610421042104210421042
      104210421042104210421042CE394A29630CEF3D314610421042104210421042
      104210421042104210421042CE394A29630CEF3D314610421042104210421042
      104210421042104210421042CE394A29630C424D3E000000000000003E000000
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
      0000000000003600000028000000400000005000000001001000000000000028
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D65A29250000292594520000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000094520000292594520000000000000000000000000000000000000000
      00000000D65A0000000094520000000000000000000000000000000000000000
      9452000000000000000000009452000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000945200000000000000009452000000000000000000000000000000000000
      0000F75E00000000000000009452000000000000000000000000000000000000
      000000009C7300009C7300000000000000000000000000000000000000000000
      2925000000000000000000000000000000000000000000000000000000000000
      000029250000BD77BD7700002925000000000000000000000000000000000000
      0000EF3D0000BD77BD7700000000000000000000000000000000000000000000
      00000000000000007B6F0000EF3D000000000000000000000000000000000000
      F75E0000F75E0000000000000000000000000000000000000000000000000000
      0000000000000000BD7700000000000000000000000000000000000000000000
      000000000000BD77BD7700000000000000000000000000000000000000000000
      0000000000000000292594520000000000000000000000000000000000000000
      0000292529250000000000000000000000000000000000000000000000000000
      0000292500000000000000003146000000000000000000000000000000000000
      000000000000000000000000734E000000000000000000000000000000000000
      00000000000000000000AD357B6F000000000000000000000000000000000000
      0000F75E0000F75E000000000000000000000000000000000000000000000000
      0000734E000031460000AD35BD77000000000000000000000000000000000000
      000000000000734E00003146DE7B000000000000000000000000000000000000
      000000009C7300009C7300000000000000000000000000000000000000000000
      00000000AD352925000000000000000000000000000000000000000000000000
      0000F75E0000F75E000000000000000000000000000000000000000000000000
      0000314600007B6F000000000000000000000000000000000000000000000000
      9452000000000000000000003146000000000000000000000000000000000000
      000000005A6B0000000000000000000000000000000000000000000000000000
      00009C7300000000000000000000000000000000000000000000000000000000
      00005A6B0000000000000000AD3500000000000000009C73EF3D000000000000
      0000F75EAD35000029259452000000000000000000009C73EF3D000000000000
      000000000000AD3500000000000000000000000000009C73EF3D000000000000
      0000000000000000000000000000000000000000000000009C73EF3D00000000
      00000000F75E29250000EF3DBD77000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000BD77EF3D
      00002925F75E0000000000000000000000000000000000000000000000000000
      00000000D65A00000000D65A0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000AD350000
      0000000000005A6B000000000000000000000000000000000000000000000000
      0000F75E0000000000000000F75E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EF3D00000000000000000000000000000000000000000000000000000000
      00007B6F00003146000000000000000000000000000000000000000000000000
      0000EF3D00007B6F7B6F0000EF3D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BD77000031460000000000000000000000000000000000000000DE7B3146
      0000734E00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000BD772925AD359C7300000000000000000000000000000000734E0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DE7BEF3D00005A6B000000000000000000000000000000000000
      BD77BD7700000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000AD35000000000000000000000000000000000000
      BD77BD770000EF3D000000000000000000000000000000000000000000000000
      0000EF3D00007B6F7B6F0000EF3D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BD77BD7700000000000000000000000000000000000094520000
      000000000000F75E000000000000000000000000000000000000000000000000
      0000F75E0000000000000000F75E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000734E00000000000000003146000000000000000000000000000000009452
      00000000D65A0000000000000000000000000000000000009C73EF3D00000000
      00000000D65A00000000D65A0000000000000000000000009C73EF3D00000000
      0000000000009C73EF3D00000000000000000000000000009C73EF3D00000000
      00000000734E0000000094520000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009452
      000029259452000000000000000000000000000000000000000000000000D65A
      0000000094520000000000000000000000000000000000000000000000002925
      000000000000000000000000000000000000000000000000000000000000734E
      00000000734E0000000000000000000000000000000000000000000094520000
      00000000000094520000000000000000000000000000000000000000F75E0000
      0000000000009452000000000000000000000000000000000000000000003146
      00009C7300000000000000000000000000000000000000000000000031460000
      0000000000003146000000000000000000000000000000000000000029250000
      BD77BD77000029250000000000000000000000000000000000000000EF3D0000
      BD77BD770000000000000000000000000000000000000000000000000000F75E
      0000186300000000000000000000000000000000000000000000000000000000
      BD77BD7700000000000000000000000000000000000000000000000000000000
      0000BD7700000000000000000000000000000000000000000000000000000000
      BD77BD770000000000000000000000000000000000000000000000000000DE7B
      0000734E00000000000000000000000000000000000000000000000029250000
      BD77BD7700002925000000000000000000000000000000000000000029250000
      0000000000003146000000000000000000000000000000000000000000000000
      000000000000734E000000000000000000000000000000000000000000000000
      31460000DE7B000000000000000000000000000000000000000000005A6B2925
      0000000000005A6B0000000000000000000000000000000000000000734E0000
      31460000AD35BD77000000000000000000000000000000000000000000000000
      734E00003146DE7B000000000000000000000000000000000000000000000000
      9C730000945200000000000000000000000000000000000000000000D65A0000
      000000000000D65A0000000000000000000000000000000000000000F75E0000
      F75E000000000000000000000000000000000000000000000000000031460000
      7B6F000000000000000000000000000000000000000000000000000000000000
      0000D65A0000BD77000000000000000000000000000000000000000000000000
      DE7BDE7B0000000000000000000000000000000000000000000000009C730000
      000000000000000000000000000000000000000000000000000000005A6B0000
      000000000000AD35000000000000000000000000000000000000000000000000
      000000000000EF3D0000000000000000000000000000000000000000EF3D0000
      000000000000EF3D000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F75E
      29250000EF3DBD77000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000BD77734E
      00000000734EBD77000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000D65A2925
      0000292594520000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000EF3D0000
      0000000000000000000000000000000000000000000000000000945200000000
      0000000000009452000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000BD770000
      3146000000000000000000000000000000000000000000000000000000009C73
      00009C7300000000000000000000000000000000000000000000292500000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BD77
      2925AD359C730000000000000000000000000000000000000000000000000000
      00007B6F0000EF3D000000000000000000000000000000000000F75E0000F75E
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      DE7BEF3D00005A6B000000000000000000000000000000000000000000000000
      0000292594520000000000000000000000000000000000000000000029252925
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AD35000000000000000000000000000000000000000000000000
      00000000AD357B6F0000000000000000000000000000000000000000F75E0000
      F75E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      BD77BD7700000000000000000000000000000000000000000000000000009C73
      00009C730000000000000000000000000000000000000000000000000000AD35
      2925000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000734E0000
      0000000000003146000000000000000000000000000000000000945200000000
      0000000000003146000000000000000000000000000000000000000000005A6B
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000734E
      00000000945200000000000000000000000000000000000000000000F75EAD35
      0000292594520000000000000000000000000000000000000000000000000000
      AD35000000000000000000000000000000000000000000000000000000009C73
      EF3D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      0000000000003600000028000000400000004000000001001000000000000020
      0000000000000000000000000000000000008A622756C1452252A045E049004E
      C045A041A041C041C2412A4E0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CB66B17FD17FF17F8C7FAA7FA87F
      657B66774777296FCA62094A0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000044EB07FD07FAD7F287347774577
      236F236F046B07670A6784390000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000875AF37FD07F6B7B4877887B4573
      4473036BE262C45E2C6F82350000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006656F27FCF7FAD7FAC7FAA7F4573
      65736677246B06638E77A3390000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008756F27FF17FF07FCD7F8B7B4773
      A97F466F056707636D6F612D0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000895AF47FF37FD17F8E7B8D7B6B73
      AC7B8B776B734B6B4E6F83310000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B56F57FF57FF57FF47FF47FD17F
      8E77AF7B6E734D6B506BC7390000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CF5E8D564B4E2A4A4A4E4A4E284A
      07460646E53D0846A635D15A0D42AC35F0410000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000942D87BC839000000000F42D65ACF390000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EC41FC7FCB390000000011423A678E350000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000504ADC772F4600000000AE35F85ED13D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000734EFE7F935200000000CE399D7312420000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D65A9B6F3763514A5146B456F75E944E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BD77934E5867786B165F165F0E3E9A6F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000BB73F55A704A5046D3569A6F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000AF624952064E0452C045C045
      E049004EA041A041A03DC145A23D6B5A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000AE5E737BB27FF27FCE7FAB7F
      A97F877F667B687B49772B6F895A284E00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000010421042
      1042104210421042000000000000000000000000000000000000000010421042
      10421042104210420000000000000000000000004A56F57FB17FAF7F6B7B687B
      66772373236F046F066BE866CA62A33D00008031F37F207F207F207F207F6066
      207F6066207F606660666C4E60660000000000000000000010421042007C007C
      007C007C007C10421042000000000000000000000000000010421042E003E003
      E003E003E0031042104200000000000000000000484EF57F907F8D7B6A7B687B
      667B65774473036BE466C7624D6FA23900008031F37F207F207F207F207F207F
      1F00207F6066207F606660666C4E00000000000000001042007C007C007C007C
      007C007C007C007C007C1042000000000000000000001042E003E003E003E003
      E003E003E003E003E00310420000000000000000E441F57FB07FAE7FAC7F897B
      667745734573246B0567E7624D73202D00008031F37FF37F207F207F1F00207F
      1F00207F1F006066207F6066606600000000000000001042007C007C007C007C
      007C007C007C007C007C1042000000000000000000001042E003E003E003E003
      E003E003E003E003E00310420000000000000000474EF57FF37FD07FEF7FAB7B
      687767776773476F286F2A6B8F77A23900008031F37F207FF37F207F207F1F00
      1F001F00207F207F6066207F60660000000000001042007C007C007C007C007C
      007C007C007C007C007C007C10420000000000001042E003E003E003E003E003
      E003E003E003E003E003E0031042000000000000284AD47FD37F9077D07FAD7B
      AD7BAB7B8B77496F2A6B0B630D67833500008031F37FFF7F207F1F001F001F00
      E07F1F001F001F00207F606660660000000000001042007C007C007C007C007C
      007C007C007C007C007C007C10420000000000001042E003E003E003E003E003
      E003E003E003E003E003E00310420000000000008D56F87FF87FF57FF57FB17F
      D07FAF7BAF7BAF778F77506F306BC73D00008031F37F207FFF7F207F207F1F00
      1F001F00207F207F6066207F60660000000000001042007C007CFF7F007C007C
      007C007C007C007C007C007C10420000000000001042E003E003FF7FE003E003
      E003E003E003E003E003E003104200000000000076732C4A6D520A464B4E6A52
      284A064668520642E641A639A739F36200008031F37FFF7F207FFF7F1F00207F
      1F00207F1F00207F207F606660660000000000001042007C007CFF7FFF7F007C
      007C007C007C007C007C007C10420000000000001042E003E003FF7FFF7FE003
      E003E003E003E003E003E00310420000000000000000EC41FC7F4E4E00000000
      0000000000000000E941DA7FA939000000008031F37F207FFF7F207FFF7F207F
      1F00207F207F207F207F207F60660000000000001042007C007CFF7FFF7FFF7F
      007C007C007C007C007C007C10420000000000001042E003E003FF7FFF7FFF7F
      E003E003E003E003E003E00310420000000000000000AC39FF7F8B3500000000
      00000000000000008935576FCD3D000000008031F37FF37FF37FF37FF37FF37F
      F37FF37FF37FF37FF37FF37FF37F00000000000000001042007C007CFF7FFF7F
      FF7F007C007C007C007C1042000000000000000000001042E003E003FF7FFF7F
      FF7FE003E003E003E003104200000000000000000000524EFF7F955600000000
      00000000000000000F461767AD35000000008031803180318031803180318031
      803180318031803180318031803100000000000000001042007C007C007C007C
      007C007C007C007C007C1042000000000000000000001042E003E003E003E003
      E003E003E003E003E0031042000000000000000000003967BE7B396731460000
      0000000000000F429252B55A74520000000000008031F37FF37FF37FF37FF37F
      00000000000000000000000000000000000000000000000010421042007C007C
      007C007C007C10421042000000000000000000000000000010421042E003E003
      E003E003E00310421042000000000000000000000000F75E1863DF7B5B6B744E
      AD35CD35B456B3527A6F0F42F75E000000000000000080318031803180318031
      0000000000000000000000000000000000000000000000000000000010421042
      1042104210420000000000000000000000000000000000000000000010421042
      104210421042000000000000000000000000000000000000F75EB55619637B6B
      7B6F7B6F1763B3560E3ED55A0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000001963B556
      934E3046714A9252000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000004C004C
      004C004C004C004C000000000000000000000000000010423967396739673967
      3967396739673967396739673967000000000000000000000000000000000000
      000000000000000000000064607E006400000000000000000000000000000000
      00000000000000000000000000000000000000000000004C0064006400640064
      006400640064004C004C004C000000000000000000001042FF7FFF7FF37FFF7F
      F37F601AF37FFF7FF37FFF7F3967000000000000000000000000000010021F00
      10021F001002000000642C7F0C7C006400000000000000000000000000000000
      0000000000000000000000000000000000000000004C0064807D067C067C067C
      067C067C006400640064004C004C00000000000000001042FF7FF37FFF7FF37F
      601A601AFF7FF37FFF7FF37F39670000000000000000601A8019801900021002
      00000000000000002C7F0C7C0064000000000000000000000000000000000000
      0000000000000000000000000000000000000000004C807D067C067C067C067C
      067C067C067C067C00640064004C00000000000000001042FF7FFF7FF37F601A
      601A601A601A601AF37FFF7F3967000000000000601A2C1B2C1B601A601A2925
      1042791A791A9319000000640000000000000000000000000000000000000000
      0000000000009F1900000000000000000000004C8C7D807D067C067C067C067C
      067C067C067C067C067C0064004C004C0000000000001042FF7FF37FFF7FF37F
      601A601AFF7F6C028C01F37F3967000000000000601AEC1BEC1B2C1B29251042
      3F4F3F1B3F1B791A931900000000000000000000000000000000000000000000
      0000000000007F1A9F190000000000000000004C8C7D667E067C067CFF7FFF7F
      067C067CFF7FFF7F067C00640064004C0000000000001042FF7FFF7FF37FFF7F
      F37F601AF37FFF7F8C01FF7F396700000000601AF367EC1B2C1B000229253F4F
      FF67FF4FFF4F3F1B791A0000131800000000000000009F197F1A7F1A7F1A7F1A
      7F1A7F1A7F1A7F1A3F1B9F19000000000000004C8C7D667E067C067C067CFF7F
      FF7FFF7FFF7F067C067C067C0064004C0000000000001042FF7FF37F8C01F37F
      FF7FF37FFF7FF37F8C01F37F396700000000601AF367EC1B601A7F0229253F4F
      FF7FFF67FF4F3F1B791A00001F0000000000000000009F19FF67FF67FF67FF67
      FF67FF67FF67FF67FF4F3F1B000000000000004C8C7D667E067C067C067C067C
      FF7FFF7F067C067C067C067C0064004C0000000000001042FF7FFF7F8C01FF7F
      F37F601AF37FFF7FF37FFF7F396700000000601A601A601A3F1B3F1B29251042
      FF7FFF7FFF673F4F104200009F1900000000000000009F199F199F199F199F19
      9F199F199F19FF673F1B0000000000000000004C8C7D667E807D067C067CFF7F
      FF7FFF7FFF7F067C067C067C0064004C0000000000001042FF7FF37F8C016C02
      FF7F601A601AF37FFF7FF37F3967000000009F19FF67FF1B3F1B3F1B7F022925
      10423F4F3F4F104200009F199F19000000000000000000000000000000000000
      000000009F193F1B00000000000000000000004C8C65667E807D067CFF7FFF7F
      067C067CFF7FFF7F067C067C0064004C0000000000001042FF7FFF7FF37F601A
      601A601A601A601AF37FFF7F3967000000009F19FF677F02000200023F1B7F02
      29252925292529257F029F191318000000000000000000000000000000000000
      000000009F190000000000000000000000000000004C8C7D667E807D067C067C
      067C067C067C067C067C067C006400000000000000001042FF7FFF7FFF7FFF7F
      FF7F601A601AF37FFF7F396739670000000000009F1900022C1B601A9F197F02
      7F027F029F197F029F191F000000000000000000000000000000000000000000
      000000009F190000000000000000000000000000004C8C65667E667E807D807D
      067C067C067C067C067C067C004C00000000000000001042FF7FFF7FFF7FFF7F
      FF7F601AF37FFF7F0000000000000000000000008019F367EC1B2C1B00029F19
      7F027F027F029F197F029F190000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000004C8C658C7D667E667E
      807D807D067C067C067C0064000000000000000000001042FF7FFF7FFF7FFF7F
      FF7FF37FFF7FF37F1042FF7F000000000000000000008019F367EC1B2C1B601A
      000200029F1973029F1900000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000004C004C8C658C7D
      8C7D8C7D8C7D006400000000000000000000000000001042FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7F1042000000000000000000000000000080198019EC1BEC1B
      2C1B601A00029F199F1900000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000004C004C
      004C004C004C004C000000000000000000000000000010421042104210421042
      1042104210421042104200000000000000000000000000000000000080198019
      801980199F190000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000945210428C3110420000
      000000000000000000000000000000000000000000000000000000000000200C
      200C00080008000C000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F75ED65A10425A6B8C31
      000000000000000000000000000000000000000000000000000000040008096F
      46736677246F4873000C00080000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D65AF75E00000000D65A5A6B6B2D
      0000000000000000000000000000000000000000000000004008E862AC7F4673
      236F6273C47F216F48732C730008000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C31B5560000000010425A6B1042
      000000000000000000000000000000000000000000000004086B4473867F877B
      400CA010600C4008A77B2673096B000C00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C311042734E6B2D10425A6B3146
      000000000000000000000000000000000000000000000008897F857F657F2010
      AA77AA73CA77A7736014A97F487B000C00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C318C311042734E5A6B10425A6B
      945200000000000000000000000000000000000040006B6B246F457F0018687F
      E87FC277E37BA47F267B201C487F2B730000000000000000000000007F1A0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000104210421042CE395A6B0000
      5A6B31460000000000000000000000000000000060006767E97F867F0018C97F
      A07BE07FE07FC27F887F6024457B286F200000000000000000007F1A7F1A0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000524A5A6B
      00005A6B734E00000000000000000000000000008000E773E57FA37FC57FA37F
      C07FE07FE17FE27FA37F637F637F046B20000000000000007F1A3F1B7F1A7F1A
      7F1A7F1A7F1A7F1A7F1A7F1A0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CE39
      5A6B00005A6B104210428C31CE39000000000000C008A76FE57FE47F627FA37F
      E47FE67FE57FE57FA47F637F437B68774008000000009F19FF4FFF4FFF4FFF4F
      FF4FFF4FFF4FFF4FFF4F7F1A0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      10425A6B10425A6B5A6B5A6B5A6BB556000000002000EF7F6373A37FEB7F2010
      600C896FEB7B400820106A7F697FE86E00080000000000009F19FF4FFF4F0000
      9F199F199F199F199F199F190000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C315A6B10426B2DB556104231460000000000004008A87BE77F67774010
      4008EC7FA873801060140873C76A4014000000000000000000009F19FF4F0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C31734EEF3D000000009452734E0000000000002000EE77E97FE67FE47F
      E37FE37FC27FA27B426F67776D7700040000000000000000000000009F190000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C311042D65A000000001863396700000000000000002000AC6F8673E57F
      E47FA27BE57F627366734A730004000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008C316B2D1042734E3967000000000000000000000000000040042004AC73
      CA7BAA7B496F4D6F000800080000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000008C318C31104218630000000000000000000000000000000000002000
      40084004400C0004000000000000000000000000000000000000000000000000
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
  object ClientPopupMenu: TSpTBXPopupMenu
    OnInitPopup = ClientPopupMenuInitPopup
    Left = 576
    Top = 192
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
      object SpTBXItem2: TSpTBXItem
        Caption = 'Kick'
      end
      object SpTBXItem4: TSpTBXItem
        Caption = 'Kick (+reason)'
      end
      object SpTBXItem3: TSpTBXItem
        Caption = 'Ban'
      end
      object SpTBXItem5: TSpTBXItem
        Caption = 'Ban (+reason)'
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
  object SearchFormPopupMenu: TSpTBXFormPopupMenu
    PopupFocus = True
    Left = 548
    Top = 78
  end
  object BattleListPopupMenu: TSpTBXPopupMenu
    Left = 276
    Top = 246
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
      0000000000003600000028000000400000001000000001001000000000000008
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
end
