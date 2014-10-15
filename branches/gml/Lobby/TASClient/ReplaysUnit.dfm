object ReplaysForm: TReplaysForm
  Left = 889
  Top = 190
  Width = 809
  Height = 640
  Caption = 'Replays'
  Color = clBtnFace
  Constraints.MaxHeight = 1000
  Constraints.MaxWidth = 1680
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
    Width = 801
    Height = 613
    Caption = 'Replays'
    TBXStyleBackground = True
    DesignSize = (
      801
      613)
    object VDTReplays: TVirtualDrawTree
      Left = 4
      Top = 262
      Width = 793
      Height = 106
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Header.AutoSizeIndex = 8
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.MainColumn = 1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Header.SortColumn = 1
      Header.SortDirection = sdDescending
      Header.Style = hsFlatButtons
      HintMode = hmHint
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnClick = VDTReplaysClick
      OnColumnDblClick = VDTReplaysColumnDblClick
      OnCompareNodes = VDTReplaysCompareNodes
      OnDrawHint = VDTReplaysDrawHint
      OnDrawNode = VDTReplaysDrawNode
      OnGetHintSize = VDTReplaysGetHintSize
      OnHeaderClick = VDTReplaysHeaderClick
      OnKeyUp = VDTReplaysKeyUp
      Columns = <
        item
          Position = 0
          Width = 25
          WideText = 'Grade'
        end
        item
          Position = 1
          Width = 120
          WideText = 'Date'
        end
        item
          Position = 2
          Width = 100
          WideText = 'Host'
        end
        item
          Position = 3
          Width = 120
          WideText = 'Mod'
        end
        item
          Position = 4
          Width = 120
          WideText = 'Map'
        end
        item
          Position = 5
          Width = 80
          WideText = 'Size'
        end
        item
          Position = 6
          Width = 60
          WideText = 'Length'
        end
        item
          Position = 7
          Width = 60
          WideText = 'Spring Version'
        end
        item
          MinWidth = 60
          Position = 8
          Width = 60
          WideText = 'Players'
        end
        item
          Position = 9
          Width = 200
          WideText = 'File Name'
        end>
    end
    object BottomPanel: TPanel
      Left = 4
      Top = 378
      Width = 793
      Height = 231
      Align = alBottom
      BevelOuter = bvNone
      Constraints.MinHeight = 231
      TabOrder = 3
      DesignSize = (
        793
        231)
      object SpTBXLabel1: TSpTBXLabel
        Left = 0
        Top = 148
        Width = 32
        Height = 13
        Caption = 'Grade:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object GradeComboBox: TSpTBXComboBox
        Left = 0
        Top = 164
        Width = 97
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 1
        OnChange = GradeComboBoxChange
        Items.Strings = (
          '0 - Unrated'
          '1 - Not interesting'
          '2 - Not interesting'
          '3 - Not interesting'
          '4 - Not interesting'
          '5 - Instructive'
          '6 - Instructive'
          '7 - Instructive'
          '8 - Instructive'
          '9 - A must-see'
          '10 - A must-see')
      end
      object PageControl1: TSpTBXTabControl
        Left = 104
        Top = 0
        Width = 686
        Height = 193
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBtnFace
        ActiveTabIndex = 0
        HiddenItems = <>
        object PlayersTab: TSpTBXTabItem
          Caption = 'Players'
          Checked = True
        end
        object SpTBXTabItem3: TSpTBXTabItem
          Caption = 'Game settings'
        end
        object SpTBXTabItem2: TSpTBXTabItem
          Caption = 'Comments'
        end
        object SpTBXTabItem1: TSpTBXTabItem
          Caption = 'Script'
        end
        object SpTBXTabSheet1: TSpTBXTabSheet
          Left = 0
          Top = 23
          Width = 686
          Height = 170
          Caption = 'Script'
          ImageIndex = -1
          TabItem = 'SpTBXTabItem1'
          object ScriptRichEdit: TRichEdit
            Left = 2
            Top = 0
            Width = 682
            Height = 168
            Align = alClient
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
        end
        object SpTBXTabSheet2: TSpTBXTabSheet
          Left = 0
          Top = 23
          Width = 686
          Height = 170
          Caption = 'Comments'
          ImageIndex = -1
          TabItem = 'SpTBXTabItem2'
          object CommentsRichEdit: TRichEdit
            Left = 2
            Top = 0
            Width = 682
            Height = 168
            Align = alClient
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
            OnChange = CommentsRichEditChange
          end
        end
        object SpTBXTabSheet4: TSpTBXTabSheet
          Left = 0
          Top = 23
          Width = 686
          Height = 170
          Caption = 'Game settings'
          ImageIndex = -1
          DesignSize = (
            686
            170)
          TabItem = 'SpTBXTabItem3'
          object frmGameOptions: TSpTBXGroupBox
            Left = 16
            Top = 8
            Width = 289
            Height = 153
            Caption = 'Game options'
            Anchors = [akLeft, akTop, akBottom]
            TabOrder = 0
            TBXStyleBackground = True
            object lblStartPos: TSpTBXLabel
              Left = 8
              Top = 16
              Width = 76
              Height = 13
              Caption = 'Start position : ?'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object lblGameEnd: TSpTBXLabel
              Left = 8
              Top = 32
              Width = 110
              Height = 13
              Caption = 'Game end condition : ?'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object lblMetal: TSpTBXLabel
              Left = 8
              Top = 48
              Width = 65
              Height = 13
              Caption = 'Start metal : ?'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object lblEnergy: TSpTBXLabel
              Left = 8
              Top = 64
              Width = 72
              Height = 13
              Caption = 'Start energy : ?'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object lblMaxUnits: TSpTBXLabel
              Left = 8
              Top = 80
              Width = 60
              Height = 13
              Caption = 'Max units : ?'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object chkLimiteDGun: TSpTBXCheckBox
              Left = 176
              Top = 96
              Width = 14
              Height = 15
              Enabled = False
              TabOrder = 5
              AllowGrayed = True
            end
            object chkGhosted: TSpTBXCheckBox
              Left = 176
              Top = 112
              Width = 14
              Height = 15
              Enabled = False
              TabOrder = 6
              AllowGrayed = True
            end
            object chkDiminishing: TSpTBXCheckBox
              Left = 176
              Top = 128
              Width = 14
              Height = 15
              Enabled = False
              TabOrder = 7
              AllowGrayed = True
            end
            object SpTBXLabel2: TSpTBXLabel
              Left = 8
              Top = 96
              Width = 116
              Height = 13
              Caption = 'Limit D-Gun to start pos :'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object SpTBXLabel3: TSpTBXLabel
              Left = 8
              Top = 112
              Width = 93
              Height = 13
              Caption = 'Ghosted buildings : '
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
            object SpTBXLabel4: TSpTBXLabel
              Left = 8
              Top = 128
              Width = 154
              Height = 13
              Caption = 'Diminishing metal maker returns :'
              LinkFont.Charset = DEFAULT_CHARSET
              LinkFont.Color = clBlue
              LinkFont.Height = -11
              LinkFont.Name = 'MS Sans Serif'
              LinkFont.Style = [fsUnderline]
            end
          end
          object frmDisabledUnits: TSpTBXGroupBox
            Left = 312
            Top = 8
            Width = 153
            Height = 153
            Caption = 'Disabled units'
            Anchors = [akLeft, akTop, akBottom]
            TabOrder = 1
            TBXStyleBackground = True
            DesignSize = (
              153
              153)
            object lstDisabledUnits: TSpTBXListBox
              Left = 8
              Top = 16
              Width = 137
              Height = 129
              Anchors = [akLeft, akTop, akBottom]
              ItemHeight = 16
              TabOrder = 0
            end
          end
          object SpTBXGroupBox1: TSpTBXGroupBox
            Left = 472
            Top = 8
            Width = 202
            Height = 153
            Caption = 'Map/Mod options'
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 2
            object lstLuaOptions: TSpTBXListBox
              Left = 3
              Top = 16
              Width = 196
              Height = 134
              Align = alClient
              BorderStyle = bsNone
              Color = clBtnFace
              ItemHeight = 16
              TabOrder = 0
            end
          end
        end
        object SpTBXTabSheet3: TSpTBXTabSheet
          Left = 0
          Top = 23
          Width = 686
          Height = 170
          Caption = 'Players'
          ImageIndex = -1
          TabItem = 'PlayersTab'
          object VDTPlayers: TVirtualDrawTree
            Left = 2
            Top = 0
            Width = 682
            Height = 168
            Align = alClient
            Header.AutoSizeIndex = 7
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'MS Sans Serif'
            Header.Font.Style = []
            Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowHint, hoShowSortGlyphs, hoVisible]
            Header.SortColumn = 2
            Header.Style = hsFlatButtons
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toFullRowSelect]
            OnCompareNodes = VDTPlayersCompareNodes
            OnDrawNode = VDTPlayersDrawNode
            OnHeaderClick = VDTPlayersHeaderClick
            Columns = <
              item
                Position = 0
                Width = 200
                WideText = 'Player'
              end
              item
                Position = 1
                WideText = 'Id'
              end
              item
                Position = 2
                Width = 60
                WideText = 'Team'
              end
              item
                Position = 3
                Width = 60
                WideText = 'MP/M'
                WideHint = 'Mouse movement in pixel per minute'
              end
              item
                Position = 4
                WideText = 'MC/M'
                WideHint = 'Mouse clicks per minute'
              end
              item
                Position = 5
                WideText = 'KP/M'
                WideHint = 'Keyboard presses per minute'
              end
              item
                Position = 6
                Width = 60
                WideText = 'Cmds/M'
                WideHint = 'Commands per minute'
              end
              item
                Position = 7
                Width = 148
                WideText = 'ACS'
                WideHint = 'Averange commands size (units affected per command)'
              end>
          end
        end
      end
      object HostReplayButton: TSpTBXButton
        Left = 635
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Host replay'
        Anchors = [akRight, akBottom]
        TabOrder = 3
        Visible = False
        OnClick = HostReplayButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object WatchButton: TSpTBXButton
        Left = 627
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Watch'
        Anchors = [akRight, akBottom]
        TabOrder = 4
        OnClick = WatchButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object CloseButton: TSpTBXButton
        Left = 715
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Close'
        Anchors = [akRight, akBottom]
        TabOrder = 5
        OnClick = CloseButtonClick
        Cancel = True
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object DownloadButton: TSpTBXButton
        Left = 0
        Top = 123
        Width = 97
        Height = 22
        Caption = 'Dowload replays'
        TabOrder = 6
        Visible = False
        OnClick = DownloadButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object UploadButton: TSpTBXButton
        Left = 0
        Top = 99
        Width = 97
        Height = 22
        Caption = 'Upload'
        Enabled = False
        TabOrder = 7
        Visible = False
        OnClick = UploadButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SaveButton: TSpTBXSpeedButton
        Left = 0
        Top = 51
        Width = 97
        Height = 22
        Caption = 'Save'
        Enabled = False
        OnClick = SaveButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object RenameButton: TSpTBXSpeedButton
        Left = 0
        Top = 27
        Width = 97
        Height = 22
        Caption = 'Rename'
        Enabled = False
        OnClick = RenameButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object DeleteButton: TSpTBXSpeedButton
        Left = 0
        Top = 75
        Width = 97
        Height = 22
        Caption = 'Delete'
        Enabled = False
        OnClick = DeleteButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object ReloadButton: TSpTBXSpeedButton
        Left = 0
        Top = 3
        Width = 97
        Height = 22
        Caption = 'Reload'
        Enabled = False
        OnClick = ReloadButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
    end
    object SpTBXSplitter1: TSpTBXSplitter
      Left = 4
      Top = 368
      Width = 793
      Height = 10
      Cursor = crSizeNS
      Caption = 'SpTBXSplitter1'
      Align = alBottom
    end
    object PanelTop: TPanel
      Left = 4
      Top = 30
      Width = 793
      Height = 232
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
      object FiltersButton: TSpTBXButton
        Left = 0
        Top = 220
        Width = 793
        Height = 12
        Align = alBottom
        TabOrder = 0
        OnClick = FiltersButtonClick
        Images = MainForm.ArrowList
        ImageIndex = 1
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object frmFilters: TSpTBXGroupBox
        Left = 0
        Top = 0
        Width = 793
        Height = 219
        Caption = 'Filters'
        Align = alTop
        TabOrder = 1
        OnResize = frmFiltersResize
        TBXStyleBackground = True
        object SpTBXGroupBox3: TSpTBXGroupBox
          Left = 432
          Top = 16
          Width = 161
          Height = 73
          Caption = 'Start position'
          TabOrder = 0
          TBXStyleBackground = True
          object chkFilterFixed: TSpTBXCheckBox
            Left = 8
            Top = 16
            Width = 43
            Height = 15
            Caption = 'Fixed'
            TabOrder = 0
            OnClick = chkFilterFixedClick
            Checked = True
            State = cbChecked
          end
          object chkFilterRandom: TSpTBXCheckBox
            Left = 8
            Top = 32
            Width = 58
            Height = 15
            Caption = 'Random'
            TabOrder = 1
            OnClick = chkFilterRandomClick
            Checked = True
            State = cbChecked
          end
          object chkFilterChooseInGame: TSpTBXCheckBox
            Left = 8
            Top = 48
            Width = 94
            Height = 15
            Caption = 'Choose in game'
            TabOrder = 2
            OnClick = chkFilterChooseInGameClick
            Checked = True
            State = cbChecked
          end
        end
        object SpTBXGroupBox4: TSpTBXGroupBox
          Left = 8
          Top = 16
          Width = 241
          Height = 89
          Caption = 'Game end condition'
          TabOrder = 1
          TBXStyleBackground = True
          object chkFilterGameContinues: TSpTBXCheckBox
            Left = 8
            Top = 24
            Width = 183
            Height = 15
            Caption = 'Game continues if commander dies'
            TabOrder = 0
            OnClick = chkFilterGameContinuesClick
            Checked = True
            State = cbChecked
          end
          object chkFilterComEnd: TSpTBXCheckBox
            Left = 8
            Top = 40
            Width = 160
            Height = 15
            Caption = 'Game ends if commander dies'
            TabOrder = 1
            OnClick = chkFilterComEndClick
            Checked = True
            State = cbChecked
          end
          object chkFilterLineage: TSpTBXCheckBox
            Left = 8
            Top = 56
            Width = 85
            Height = 15
            Caption = 'Lineage mode'
            TabOrder = 2
            OnClick = chkFilterLineageClick
            Checked = True
            State = cbChecked
          end
        end
        object SpTBXPanel1: TSpTBXPanel
          Left = 8
          Top = 118
          Width = 241
          Height = 66
          Caption = 'SpTBXPanel1'
          TabOrder = 2
          TBXStyleBackground = True
          object chkFilterLimitDGunFilter: TSpTBXCheckBox
            Left = 11
            Top = 8
            Width = 46
            Height = 15
            Caption = 'Filter :'
            TabOrder = 0
            OnClick = chkFilterLimitDGunFilterClick
          end
          object chkFilterGhostedFilter: TSpTBXCheckBox
            Left = 11
            Top = 24
            Width = 46
            Height = 15
            Caption = 'Filter :'
            TabOrder = 1
            OnClick = chkFilterGhostedFilterClick
          end
          object chkFilterDiminishingFilter: TSpTBXCheckBox
            Left = 11
            Top = 40
            Width = 46
            Height = 15
            Caption = 'Filter :'
            TabOrder = 2
            OnClick = chkFilterDiminishingFilterClick
          end
          object chkFilterGhosted: TSpTBXCheckBox
            Left = 65
            Top = 24
            Width = 102
            Height = 15
            Caption = 'Ghosted buildings'
            TabOrder = 3
            OnClick = chkFilterGhostedClick
          end
          object chkFilterLimitDGun: TSpTBXCheckBox
            Left = 65
            Top = 8
            Width = 128
            Height = 15
            Caption = 'Limit D-Gun to start pos'
            TabOrder = 4
            OnClick = chkFilterLimitDGunClick
          end
          object chkFilterDiminishing: TSpTBXCheckBox
            Left = 65
            Top = 40
            Width = 166
            Height = 15
            Caption = 'Diminishing metal maker returns'
            TabOrder = 5
            OnClick = chkFilterDiminishingClick
          end
        end
        object SpTBXGroupBox5: TSpTBXGroupBox
          Left = 256
          Top = 22
          Width = 169
          Height = 187
          TabOrder = 3
          TBXStyleBackground = True
          object chkFilterMetal: TSpTBXCheckBox
            Left = 8
            Top = 10
            Width = 68
            Height = 15
            Caption = 'Start metal'
            TabOrder = 0
            OnClick = chkFilterMetalClick
          end
          object chkFilterEnergy: TSpTBXCheckBox
            Left = 8
            Top = 34
            Width = 75
            Height = 15
            Caption = 'Start energy'
            TabOrder = 1
            OnClick = chkFilterEnergyClick
          end
          object chkFilterUnits: TSpTBXCheckBox
            Left = 8
            Top = 58
            Width = 63
            Height = 15
            Caption = 'Max units'
            TabOrder = 2
            OnClick = chkFilterUnitsClick
          end
          object btFilterUnits: TSpTBXButton
            Left = 88
            Top = 56
            Width = 17
            Height = 20
            Caption = '>'
            TabOrder = 3
            OnClick = btFilterUnitsClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object btFilterEnergy: TSpTBXButton
            Left = 88
            Top = 32
            Width = 17
            Height = 20
            Caption = '>'
            TabOrder = 4
            OnClick = btFilterEnergyClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object btFilterMetal: TSpTBXButton
            Left = 88
            Top = 8
            Width = 17
            Height = 20
            Caption = '>'
            TabOrder = 5
            OnClick = btFilterMetalClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object speFilterMetal: TJvSpinEdit
            Left = 104
            Top = 8
            Width = 57
            Height = 20
            ButtonKind = bkStandard
            MaxValue = 10000.000000000000000000
            Value = 5000.000000000000000000
            TabOrder = 6
            OnChange = speFilterMetalChange
          end
          object speFilterEnergy: TJvSpinEdit
            Left = 104
            Top = 32
            Width = 57
            Height = 20
            ButtonKind = bkStandard
            MaxValue = 10000.000000000000000000
            Value = 5000.000000000000000000
            TabOrder = 7
            OnChange = speFilterEnergyChange
          end
          object speFilterUnits: TJvSpinEdit
            Left = 104
            Top = 56
            Width = 57
            Height = 20
            ButtonKind = bkStandard
            MaxValue = 10000.000000000000000000
            Value = 3000.000000000000000000
            TabOrder = 8
            OnChange = speFilterUnitsChange
          end
          object chkFilterPlayers: TSpTBXCheckBox
            Left = 8
            Top = 82
            Width = 52
            Height = 15
            Caption = 'Players'
            TabOrder = 9
            OnClick = chkFilterPlayersClick
          end
          object btFilterPlayers: TSpTBXButton
            Left = 88
            Top = 80
            Width = 17
            Height = 20
            Caption = '>'
            TabOrder = 10
            OnClick = btFilterPlayersClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object speFilterPlayers: TJvSpinEdit
            Left = 104
            Top = 80
            Width = 57
            Height = 20
            ButtonKind = bkStandard
            MaxValue = 16.000000000000000000
            MinValue = 1.000000000000000000
            Value = 16.000000000000000000
            TabOrder = 11
            OnChange = speFilterPlayersChange
          end
          object chkFilterLength: TSpTBXCheckBox
            Left = 8
            Top = 106
            Width = 76
            Height = 15
            Caption = 'Length (min)'
            TabOrder = 12
            OnClick = chkFilterLengthClick
          end
          object btFilterLength: TSpTBXButton
            Left = 88
            Top = 104
            Width = 17
            Height = 20
            Caption = '>'
            TabOrder = 13
            OnClick = btFilterLengthClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object speFilterLength: TJvSpinEdit
            Left = 104
            Top = 104
            Width = 57
            Height = 20
            ButtonKind = bkStandard
            MaxValue = 1440.000000000000000000
            Value = 1440.000000000000000000
            TabOrder = 14
            OnChange = speFilterLengthChange
          end
          object speFilterFileSize: TJvSpinEdit
            Left = 104
            Top = 128
            Width = 57
            Height = 20
            ButtonKind = bkStandard
            MaxValue = 10000.000000000000000000
            Value = 3000.000000000000000000
            TabOrder = 15
            OnChange = speFilterFileSizeChange
          end
          object btFilterFileSize: TSpTBXButton
            Left = 88
            Top = 128
            Width = 17
            Height = 20
            Caption = '>'
            TabOrder = 16
            OnClick = btFilterFileSizeClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object chkFilterFileSize: TSpTBXCheckBox
            Left = 8
            Top = 130
            Width = 77
            Height = 15
            Caption = 'File size (kB)'
            TabOrder = 17
            OnClick = chkFilterFileSizeClick
          end
          object chkFilterGrade: TSpTBXCheckBox
            Left = 8
            Top = 154
            Width = 47
            Height = 15
            Caption = 'Grade'
            TabOrder = 18
            OnClick = chkFilterGradeClick
          end
          object btFilterGrade: TSpTBXButton
            Left = 88
            Top = 152
            Width = 17
            Height = 20
            Caption = '>'
            TabOrder = 19
            OnClick = btFilterGradeClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object speFilterGrade: TJvSpinEdit
            Left = 104
            Top = 152
            Width = 57
            Height = 20
            ButtonKind = bkStandard
            MaxValue = 10.000000000000000000
            MinValue = 1.000000000000000000
            Value = 10.000000000000000000
            TabOrder = 20
            OnChange = speFilterGradeChange
          end
        end
        object FilterList: TVirtualStringTree
          Left = 601
          Top = 24
          Width = 184
          Height = 185
          Align = alCustom
          CheckImageKind = ckSystem
          ClipboardFormats.Strings = (
            'Unicode text')
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
          TabOrder = 4
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
          OnChecking = FilterListChecking
          OnCompareNodes = FilterListCompareNodes
          OnGetText = FilterListGetText
          OnHeaderClick = FilterListHeaderClick
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
              Width = 17
              WideText = 'Value'
            end>
        end
        object SpTBXPanel2: TSpTBXPanel
          Left = 432
          Top = 104
          Width = 161
          Height = 105
          Caption = 'SpTBXPanel2'
          TabOrder = 5
          TBXStyleBackground = True
          object FilterListCombo: TSpTBXComboBox
            Left = 8
            Top = 8
            Width = 105
            Height = 19
            Style = csOwnerDrawFixed
            ItemHeight = 13
            ItemIndex = 1
            TabOrder = 0
            Text = 'Map'
            Items.Strings = (
              'Host'
              'Map'
              'Mod'
              'Disabled units'
              'Spring Version'
              'File Name'
              'Players')
          end
          object ContainsRadio: TSpTBXRadioButton
            Left = 15
            Top = 36
            Width = 58
            Height = 15
            Caption = 'contains'
            TabOrder = 1
          end
          object DoNotContainsRadio: TSpTBXRadioButton
            Left = 16
            Top = 52
            Width = 97
            Height = 15
            Caption = 'does not contain'
            TabOrder = 2
            TabStop = True
            Checked = True
          end
          object FilterValueTextBox: TSpTBXEdit
            Left = 8
            Top = 72
            Width = 105
            Height = 21
            TabOrder = 3
          end
          object AddToFilterListButton: TSpTBXButton
            Left = 120
            Top = 8
            Width = 33
            Height = 25
            Caption = '->'
            TabOrder = 4
            OnClick = AddToFilterListButtonClick
            LinkFont.Charset = DEFAULT_CHARSET
            LinkFont.Color = clBlue
            LinkFont.Height = -11
            LinkFont.Name = 'MS Sans Serif'
            LinkFont.Style = [fsUnderline]
          end
          object RemoveFromFilterListButton: TSpTBXButton
            Left = 120
            Top = 40
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
            Left = 120
            Top = 72
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
        end
        object chkEnableFilters: TSpTBXCheckBox
          Left = 8
          Top = 192
          Width = 110
          Height = 18
          Caption = 'Enable filters'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = chkEnableFiltersClick
        end
      end
    end
    object LoadingPanel: TSpTBXPanel
      Left = 176
      Top = 286
      Width = 233
      Height = 75
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 2
      OnResize = LoadingPanelResize
      TBXStyleBackground = True
      object LoadingLabel: TSpTBXLabel
        Left = 2
        Top = 2
        Width = 262
        Height = 20
        Caption = 'Please wait while building replay list ...'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
    end
  end
end
