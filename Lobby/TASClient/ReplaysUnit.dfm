object ReplaysForm: TReplaysForm
  Left = 948
  Top = 69
  Width = 883
  Height = 605
  Caption = 'Replays'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Constraints.MinHeight = 100
  Constraints.MinWidth = 100
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 875
    Height = 578
    Caption = 'Replays'
    Active = False
    DesignSize = (
      875
      578)
    object SpTBXItem2: TSpTBXItem
    end
    object SpTBXItem1: TSpTBXItem
    end
    object VDTReplays: TVirtualDrawTree
      Left = 0
      Top = 270
      Width = 875
      Height = 49
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Header.AutoSizeIndex = 8
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.MainColumn = 1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoShowSortGlyphs, hoVisible]
      Header.SortColumn = 1
      Header.SortDirection = sdDescending
      Header.Style = hsFlatButtons
      HintMode = hmHint
      ParentShowHint = False
      PopupMenu = ReplayListPopupMenu
      ShowHint = True
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnClick = VDTReplaysClick
      OnColumnDblClick = VDTReplaysColumnDblClick
      OnCompareNodes = VDTReplaysCompareNodes
      OnDrawHint = VDTReplaysDrawHint
      OnDrawNode = VDTReplaysDrawNode
      OnGetHintSize = VDTReplaysGetHintSize
      OnHeaderClick = VDTReplaysHeaderClick
      OnHeaderDraw = VDTReplaysHeaderDraw
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
    object SpTBXSplitter1: TSpTBXSplitter
      Left = 0
      Top = 319
      Width = 875
      Height = 10
      Cursor = crSizeNS
      Align = alBottom
    end
    object BottomPanel: TSpTBXPanel
      Left = 0
      Top = 329
      Width = 875
      Height = 249
      Align = alBottom
      TabOrder = 4
      Borders = False
      TBXStyleBackground = True
      DesignSize = (
        875
        249)
      object PageControl1: TSpTBXTabControl
        Left = 158
        Top = 0
        Width = 701
        Height = 209
        Anchors = [akLeft, akTop, akRight, akBottom]
        ActiveTabIndex = 1
        HiddenItems = <>
        object PlayersTab: TSpTBXTabItem
          Caption = 'Players'
        end
        object GraphsTab: TSpTBXTabItem
          Caption = 'Graphs'
          Checked = True
        end
        object SpTBXTabItem3: TSpTBXTabItem
          Caption = 'Game settings'
        end
        object CommentsTab: TSpTBXTabItem
          Caption = 'Comments'
        end
        object SpTBXTabItem1: TSpTBXTabItem
          Caption = 'Script'
        end
        object SpTBXTabSheet1: TSpTBXTabSheet
          Left = 0
          Top = 23
          Width = 701
          Height = 186
          Caption = 'Script'
          ImageIndex = -1
          TabItem = 'SpTBXTabItem1'
          object ScriptRichEdit: TRichEdit
            Left = 2
            Top = 0
            Width = 697
            Height = 184
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
          Width = 701
          Height = 186
          Caption = 'Comments'
          ImageIndex = -1
          TabItem = 'CommentsTab'
          object CommentsRichEdit: TRichEdit
            Left = 2
            Top = 0
            Width = 697
            Height = 184
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
          Width = 701
          Height = 186
          Caption = 'Game settings'
          ImageIndex = -1
          DesignSize = (
            701
            186)
          TabItem = 'SpTBXTabItem3'
          object frmGameOptions: TSpTBXGroupBox
            Left = 16
            Top = 8
            Width = 289
            Height = 169
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
            end
            object lblGameEnd: TSpTBXLabel
              Left = 8
              Top = 32
              Width = 110
              Height = 13
              Caption = 'Game end condition : ?'
            end
            object lblMetal: TSpTBXLabel
              Left = 8
              Top = 48
              Width = 65
              Height = 13
              Caption = 'Start metal : ?'
            end
            object lblEnergy: TSpTBXLabel
              Left = 8
              Top = 64
              Width = 72
              Height = 13
              Caption = 'Start energy : ?'
            end
            object lblMaxUnits: TSpTBXLabel
              Left = 8
              Top = 80
              Width = 60
              Height = 13
              Caption = 'Max units : ?'
            end
            object chkLimiteDGun: TSpTBXCheckBox
              Left = 264
              Top = 96
              Width = 14
              Height = 15
              Enabled = False
              TabOrder = 5
              AllowGrayed = True
            end
            object chkGhosted: TSpTBXCheckBox
              Left = 264
              Top = 112
              Width = 14
              Height = 15
              Enabled = False
              TabOrder = 6
              AllowGrayed = True
            end
            object chkDiminishing: TSpTBXCheckBox
              Left = 264
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
            end
            object SpTBXLabel3: TSpTBXLabel
              Left = 8
              Top = 112
              Width = 93
              Height = 13
              Caption = 'Ghosted buildings : '
            end
            object SpTBXLabel4: TSpTBXLabel
              Left = 8
              Top = 128
              Width = 154
              Height = 13
              Caption = 'Diminishing metal maker returns :'
            end
          end
          object frmDisabledUnits: TSpTBXGroupBox
            Left = 312
            Top = 8
            Width = 153
            Height = 169
            Caption = 'Disabled units'
            Anchors = [akLeft, akTop, akBottom]
            TabOrder = 1
            TBXStyleBackground = True
            DesignSize = (
              153
              169)
            object lstDisabledUnits: TSpTBXListBox
              Left = 8
              Top = 16
              Width = 137
              Height = 145
              Anchors = [akLeft, akTop, akBottom]
              ItemHeight = 16
              TabOrder = 0
            end
          end
          object SpTBXGroupBox1: TSpTBXGroupBox
            Left = 472
            Top = 8
            Width = 217
            Height = 169
            Caption = 'Map/Mod options'
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 2
            object lstLuaOptions: TSpTBXListBox
              Left = 2
              Top = 15
              Width = 213
              Height = 152
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
          Width = 701
          Height = 186
          Caption = 'Players'
          ImageIndex = -1
          TabItem = 'PlayersTab'
          object VDTPlayers: TVirtualDrawTree
            Left = 2
            Top = 0
            Width = 697
            Height = 184
            Align = alClient
            Header.AutoSizeIndex = 7
            Header.DefaultHeight = 17
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'MS Sans Serif'
            Header.Font.Style = []
            Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoShowHint, hoShowSortGlyphs, hoVisible]
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
            OnHeaderDraw = VDTPlayersHeaderDraw
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
                Width = 163
                WideText = 'ACS'
                WideHint = 'Averange commands size (units affected per command)'
              end>
          end
        end
        object SpTBXTabSheet7: TSpTBXTabSheet
          Left = 0
          Top = 23
          Width = 701
          Height = 186
          Caption = 'Graphs'
          ImageIndex = -1
          TabItem = 'GraphsTab'
          object rscTSGChart: TRSChartPanel
            Left = 355
            Top = 0
            Width = 346
            Height = 186
            Align = alClient
            TabOrder = 0
            Color = clWhite
            ScalingFlags = []
            OnDblClick = rscTSGChartDblClick
            BevelEdges = []
            UseDockManager = True
            BevelOuter = bvNone
            DoubleBuffered = True
            ChartShadow.Brush.Color = clBlack
            ChartShadow.Size = 2
            ChartShadow.Visible = False
            Background.Brush.Color = clBtnFace
            Background.ImageMode = imCenter
            Background.Visible = False
            ChartBackground.Brush.Color = clBtnFace
            ChartBackground.ImageMode = imCenter
            ChartBackground.Transparent = True
            ChartBackground.Visible = False
            Foreground.Brush.Color = clBtnFace
            Foreground.ImageMode = imCenter
            Foreground.Transparent = True
            Foreground.Visible = False
            BottomAxis.Format = '#,##0.###'
            BottomAxis.Grid.GridPen.Style = psDot
            BottomAxis.Grid.MinorGridPen.Color = clInactiveBorder
            BottomAxis.Grid.TicksPen.Color = clGray
            BottomAxis.Grid.Visible = True
            BottomAxis.Labels.Font.Charset = DEFAULT_CHARSET
            BottomAxis.Labels.Font.Color = clWindowText
            BottomAxis.Labels.Font.Height = -11
            BottomAxis.Labels.Font.Name = 'MS Sans Serif'
            BottomAxis.Labels.Font.Style = []
            BottomAxis.Labels.Visible = True
            BottomAxis.LogarithmicType = ltCompressRight
            BottomAxis.MinStepIncrement = 0.100000000000000000
            BottomAxis.Options = [axAutomaticMinimum, axAutomaticMaximum, axShowLabels, axShowGrid]
            BottomAxis.Title.Font.Charset = DEFAULT_CHARSET
            BottomAxis.Title.Font.Color = clWindowText
            BottomAxis.Title.Font.Height = -11
            BottomAxis.Title.Font.Name = 'MS Sans Serif'
            BottomAxis.Title.Font.Style = []
            BottomAxis.Title.Visible = False
            BottomAxis.Title.Text = 'caBottom'
            BottomAxis.Brush.Style = bsClear
            BottomAxis.Visible = True
            TopAxis.Format = '#,##0.###'
            TopAxis.Grid.GridPen.Style = psDot
            TopAxis.Grid.MinorGridPen.Color = clInactiveBorder
            TopAxis.Grid.TicksPen.Color = clGray
            TopAxis.Grid.Visible = True
            TopAxis.Labels.Font.Charset = DEFAULT_CHARSET
            TopAxis.Labels.Font.Color = clWindowText
            TopAxis.Labels.Font.Height = -11
            TopAxis.Labels.Font.Name = 'MS Sans Serif'
            TopAxis.Labels.Font.Style = []
            TopAxis.Labels.Visible = True
            TopAxis.LogarithmicType = ltCompressRight
            TopAxis.Options = [axAutomaticMinimum, axAutomaticMaximum, axShowLabels, axShowGrid, axShowTitle]
            TopAxis.Title.Font.Charset = DEFAULT_CHARSET
            TopAxis.Title.Font.Color = clWindowText
            TopAxis.Title.Font.Height = -11
            TopAxis.Title.Font.Name = 'MS Sans Serif'
            TopAxis.Title.Font.Style = []
            TopAxis.Title.Visible = True
            TopAxis.Title.Text = 'caTop'
            TopAxis.Brush.Style = bsClear
            TopAxis.Visible = False
            LeftAxis.Format = '#,##0.###'
            LeftAxis.Grid.GridPen.Style = psDot
            LeftAxis.Grid.MinorGridPen.Color = clInactiveBorder
            LeftAxis.Grid.TicksPen.Color = clGray
            LeftAxis.Grid.Visible = True
            LeftAxis.Labels.Font.Charset = DEFAULT_CHARSET
            LeftAxis.Labels.Font.Color = clWindowText
            LeftAxis.Labels.Font.Height = -11
            LeftAxis.Labels.Font.Name = 'MS Sans Serif'
            LeftAxis.Labels.Font.Style = []
            LeftAxis.Labels.Visible = True
            LeftAxis.LogarithmicType = ltCompressRight
            LeftAxis.Options = [axAutomaticMinimum, axAutomaticMaximum, axShowLabels, axShowGrid]
            LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
            LeftAxis.Title.Font.Color = clWindowText
            LeftAxis.Title.Font.Height = -11
            LeftAxis.Title.Font.Name = 'Arial'
            LeftAxis.Title.Font.Style = []
            LeftAxis.Title.Angle = 90
            LeftAxis.Title.Visible = False
            LeftAxis.Title.Text = 'caLeft'
            LeftAxis.Brush.Style = bsClear
            LeftAxis.Visible = True
            RightAxis.Format = '#,##0.###'
            RightAxis.Grid.GridPen.Style = psDot
            RightAxis.Grid.MinorGridPen.Color = clInactiveBorder
            RightAxis.Grid.TicksPen.Color = clGray
            RightAxis.Grid.Visible = True
            RightAxis.Labels.Font.Charset = DEFAULT_CHARSET
            RightAxis.Labels.Font.Color = clWindowText
            RightAxis.Labels.Font.Height = -11
            RightAxis.Labels.Font.Name = 'MS Sans Serif'
            RightAxis.Labels.Font.Style = []
            RightAxis.Labels.Visible = True
            RightAxis.LogarithmicType = ltCompressRight
            RightAxis.Options = [axAutomaticMinimum, axAutomaticMaximum, axShowLabels, axShowGrid, axShowTitle]
            RightAxis.Title.Font.Charset = DEFAULT_CHARSET
            RightAxis.Title.Font.Color = clWindowText
            RightAxis.Title.Font.Height = -11
            RightAxis.Title.Font.Name = 'Arial'
            RightAxis.Title.Font.Style = []
            RightAxis.Title.Angle = 270
            RightAxis.Title.Visible = True
            RightAxis.Title.Text = 'caRight'
            RightAxis.Brush.Style = bsClear
            RightAxis.Visible = False
            Gradient.Visible = False
            Footer.Text = 'Footer'
            Footer.Font.Charset = DEFAULT_CHARSET
            Footer.Font.Color = clRed
            Footer.Font.Height = -11
            Footer.Font.Name = 'MS Sans Serif'
            Footer.Font.Style = []
            Footer.Font.Deltas = [daColor]
            Footer.Height = 24
            Footer.Width = 0
            Footer.Brush.Style = bsClear
            Footer.ImageOptions = [ioStretch]
            Footer.Visible = False
            Header.Text = 'Chart'
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clBlue
            Header.Font.Height = -11
            Header.Font.Name = 'MS Sans Serif'
            Header.Font.Style = []
            Header.Font.Deltas = [daColor]
            Header.Height = 24
            Header.Width = 0
            Header.Brush.Style = bsClear
            Header.ImageOptions = [ioStretch]
            Header.Visible = False
            Legend.Alignment = taLeftJustify
            Legend.Font.Charset = DEFAULT_CHARSET
            Legend.Font.Color = clWindowText
            Legend.Font.Height = -11
            Legend.Font.Name = 'MS Sans Serif'
            Legend.Font.Style = []
            Legend.Visible = False
            Legend.Shadow.Brush.Color = clBlack
            Legend.Shadow.Visible = True
            Legend.LegendStyle = lsChartNames
            UserPan = [ssRight]
            UserSelect = [ssCtrl, ssRight]
          end
          object pnlTSGOptions: TSpTBXPanel
            Left = 0
            Top = 0
            Width = 335
            Height = 186
            Caption = 'pnlTSGOptions'
            Align = alLeft
            TabOrder = 1
            BorderType = pbrFramed
            object gbTSGLine: TSpTBXGroupBox
              Left = 2
              Top = 2
              Width = 100
              Height = 182
              Caption = 'Bold'
              Align = alLeft
              TabOrder = 0
              object cmbTSGEnableLine: TSpTBXCheckBox
                Left = 2
                Top = 15
                Width = 96
                Height = 15
                Caption = 'Enable'
                Align = alTop
                TabOrder = 0
                OnClick = cmbTSGEnableLineClick
                Checked = True
                State = cbChecked
              end
              object lstTSGLineStat: TSpTBXListBox
                Left = 2
                Top = 30
                Width = 96
                Height = 150
                Align = alClient
                ItemHeight = 16
                Items.Strings = (
                  'Metal Used'
                  'Energy Used'
                  'Metal Produced'
                  'Energy Produced'
                  'Metal Received'
                  'Energy Received'
                  'Metal Sent'
                  'Energy Sent'
                  'Damage Dealt'
                  'Damage Received'
                  'Units Produced'
                  'Units Died'
                  'Units Received'
                  'Units Sent'
                  'Units Captured'
                  'Units Out Captured'
                  'Units Killed')
                TabOrder = 1
                OnClick = lstTSGLineStatClick
              end
            end
            object gbTSGDashed: TSpTBXGroupBox
              Left = 102
              Top = 2
              Width = 100
              Height = 182
              Caption = 'Thin'
              Align = alLeft
              TabOrder = 1
              object cmbTSGEnableDashed: TSpTBXCheckBox
                Left = 2
                Top = 15
                Width = 96
                Height = 15
                Caption = 'Enable'
                Align = alTop
                TabOrder = 0
                OnClick = cmbTSGEnableDashedClick
              end
              object lstTSGDashedStat: TSpTBXListBox
                Left = 2
                Top = 30
                Width = 96
                Height = 150
                Align = alClient
                ItemHeight = 16
                Items.Strings = (
                  'Metal Used'
                  'Energy Used'
                  'Metal Produced'
                  'Energy Produced'
                  'Metal Received'
                  'Energy Received'
                  'Metal Sent'
                  'Energy Sent'
                  'Damage Dealt'
                  'Damage Received'
                  'Units Produced'
                  'Units Died'
                  'Units Received'
                  'Units Sent'
                  'Units Captured'
                  'Units Out Captured'
                  'Units Killed')
                TabOrder = 1
                OnClick = lstTSGDashedStatClick
              end
            end
            object gbTSGPlayers: TSpTBXGroupBox
              Left = 202
              Top = 2
              Width = 131
              Height = 182
              Caption = 'Players'
              Align = alClient
              TabOrder = 2
              object lstTSGPlayers: TSpTBXCheckListBox
                Left = 2
                Top = 15
                Width = 127
                Height = 147
                Align = alClient
                ItemHeight = 16
                TabOrder = 0
                OnClick = lstTSGPlayersClick
                OnDrawItem = lstTSGPlayersDrawItem
              end
              object SpTBXPanel4: TSpTBXPanel
                Left = 2
                Top = 162
                Width = 127
                Height = 18
                Caption = 'SpTBXPanel4'
                Align = alBottom
                TabOrder = 1
                Borders = False
                DesignSize = (
                  127
                  18)
                object btTSGAll: TSpTBXButton
                  Left = 0
                  Top = 0
                  Width = 57
                  Height = 17
                  Caption = 'All'
                  TabOrder = 0
                  OnClick = btTSGAllClick
                end
                object btTSGNone: TSpTBXButton
                  Left = 56
                  Top = 0
                  Width = 57
                  Height = 17
                  Caption = 'None'
                  Anchors = [akTop, akRight]
                  TabOrder = 1
                  OnClick = btTSGNoneClick
                end
              end
            end
          end
          object btTSGCollapse: TSpTBXButton
            Left = 338
            Top = 0
            Width = 17
            Height = 186
            Align = alLeft
            TabOrder = 2
            OnClick = btTSGCollapseClick
            Images = MainForm.ArrowList
            ImageIndex = 2
          end
          object sptTSGOptions: TSpTBXSplitter
            Left = 335
            Top = 0
            Width = 3
            Height = 186
            Cursor = crSizeWE
          end
        end
      end
      object WatchButton: TSpTBXButton
        Left = 618
        Top = 216
        Width = 115
        Height = 25
        Caption = 'Watch'
        Anchors = [akRight, akBottom]
        TabOrder = 1
        OnClick = WatchButtonClick
      end
      object CloseButton: TSpTBXButton
        Left = 744
        Top = 216
        Width = 115
        Height = 25
        Caption = 'Close'
        Anchors = [akRight, akBottom]
        TabOrder = 2
        OnClick = CloseButtonClick
        Cancel = True
      end
      object GradeComboBox: TSpTBXComboBox
        Left = 0
        Top = 192
        Width = 129
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 3
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
      object SpTBXLabel1: TSpTBXLabel
        Left = 0
        Top = 176
        Width = 32
        Height = 13
        Caption = 'Grade:'
      end
      object DownloadButton: TSpTBXButton
        Left = 0
        Top = 150
        Width = 153
        Height = 22
        Caption = 'Dowload replays'
        TabOrder = 5
        OnClick = DownloadButtonClick
      end
      object UploadButton: TSpTBXButton
        Left = 0
        Top = 126
        Width = 153
        Height = 22
        Caption = 'Upload'
        Enabled = False
        TabOrder = 6
        OnClick = UploadButtonClick
      end
      object DeleteAllVisibleButton: TSpTBXButton
        Left = 0
        Top = 99
        Width = 153
        Height = 25
        Caption = 'Delete all visible'
        TabOrder = 7
        OnClick = DeleteAllVisibleButtonClick
      end
      object DeleteButton: TSpTBXSpeedButton
        Left = 0
        Top = 75
        Width = 153
        Height = 22
        Caption = 'Delete'
        Enabled = False
        OnClick = DeleteButtonClick
      end
      object SaveButton: TSpTBXSpeedButton
        Left = 0
        Top = 51
        Width = 153
        Height = 22
        Caption = 'Save'
        Enabled = False
        OnClick = SaveButtonClick
      end
      object RenameButton: TSpTBXSpeedButton
        Left = 0
        Top = 27
        Width = 153
        Height = 22
        Caption = 'Rename'
        Enabled = False
        OnClick = RenameButtonClick
      end
      object ReloadButton: TSpTBXSpeedButton
        Left = 0
        Top = 3
        Width = 153
        Height = 22
        Caption = 'Refresh list'
        Enabled = False
        OnClick = ReloadButtonClick
      end
      object HostReplayButton: TSpTBXButton
        Left = 618
        Top = 216
        Width = 115
        Height = 25
        Caption = 'Host replay'
        Anchors = [akRight, akBottom]
        TabOrder = 12
        Visible = False
        OnClick = HostReplayButtonClick
      end
    end
    object PanelTop: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 875
      Height = 248
      Caption = 'PanelTop'
      Align = alTop
      UseDockManager = True
      TabOrder = 5
      Borders = False
      object FiltersTabs: TSpTBXTabControl
        Left = 0
        Top = 0
        Width = 875
        Height = 225
        Align = alTop
        ActiveTabIndex = 0
        HiddenItems = <>
        object FiltersTab: TSpTBXTabItem
          Caption = 'Filters'
          Checked = True
        end
        object PresetsTab: TSpTBXTabItem
          Caption = 'Presets'
        end
        object SpTBXTabSheet6: TSpTBXTabSheet
          Left = 0
          Top = 23
          Width = 875
          Height = 202
          Caption = 'Presets'
          ImageIndex = -1
          DesignSize = (
            875
            202)
          TabItem = 'PresetsTab'
          object SpTBXGroupBox2: TSpTBXGroupBox
            Left = 8
            Top = 8
            Width = 137
            Height = 185
            Caption = 'Options'
            TabOrder = 0
            object btDeletePreset: TSpTBXButton
              Left = 8
              Top = 72
              Width = 121
              Height = 25
              Caption = 'Delete'
              TabOrder = 1
              OnClick = btDeletePresetClick
            end
            object btSavePreset: TSpTBXButton
              Left = 8
              Top = 40
              Width = 121
              Height = 25
              Caption = 'Save'
              TabOrder = 2
              OnClick = btSavePresetClick
            end
            object PresetNameTextbox: TSpTBXEdit
              Left = 8
              Top = 18
              Width = 121
              Height = 21
              TabOrder = 3
              Text = 'Preset name'
            end
            object btClearPreset: TSpTBXButton
              Left = 8
              Top = 96
              Width = 121
              Height = 25
              Caption = 'Clear'
              TabOrder = 0
              OnClick = btClearPresetClick
            end
          end
          object SpTBXLabel5: TSpTBXLabel
            Left = 152
            Top = 8
            Width = 64
            Height = 16
            Caption = 'Preset list :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object PresetListbox: TSpTBXListBox
            Left = 152
            Top = 26
            Width = 704
            Height = 167
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 16
            Items.Strings = (
              'current')
            TabOrder = 2
            OnClick = PresetListboxClick
            OnDblClick = PresetListboxDblClick
          end
        end
        object SpTBXTabSheet5: TSpTBXTabSheet
          Left = 0
          Top = 23
          Width = 875
          Height = 202
          Caption = 'Filters'
          ImageIndex = -1
          TabItem = 'FiltersTab'
          object SpTBXGroupBox4: TSpTBXGroupBox
            Left = 8
            Top = 0
            Width = 257
            Height = 89
            Caption = 'Game end condition'
            TabOrder = 0
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
            Top = 94
            Width = 257
            Height = 66
            Caption = 'SpTBXPanel1'
            TabOrder = 1
            TBXStyleBackground = True
            object chkFilterLimitDGunFilter: TSpTBXCheckBox
              Left = 4
              Top = 8
              Width = 46
              Height = 15
              Caption = 'Filter :'
              TabOrder = 0
              OnClick = chkFilterLimitDGunFilterClick
            end
            object chkFilterGhostedFilter: TSpTBXCheckBox
              Left = 4
              Top = 24
              Width = 46
              Height = 15
              Caption = 'Filter :'
              TabOrder = 1
              OnClick = chkFilterGhostedFilterClick
            end
            object chkFilterDiminishingFilter: TSpTBXCheckBox
              Left = 4
              Top = 40
              Width = 46
              Height = 15
              Caption = 'Filter :'
              TabOrder = 2
              OnClick = chkFilterDiminishingFilterClick
            end
            object chkFilterGhosted: TSpTBXCheckBox
              Left = 57
              Top = 24
              Width = 102
              Height = 15
              Caption = 'Ghosted buildings'
              TabOrder = 3
              OnClick = chkFilterGhostedClick
            end
            object chkFilterLimitDGun: TSpTBXCheckBox
              Left = 57
              Top = 8
              Width = 128
              Height = 15
              Caption = 'Limit D-Gun to start pos'
              TabOrder = 4
              OnClick = chkFilterLimitDGunClick
            end
            object chkFilterDiminishing: TSpTBXCheckBox
              Left = 57
              Top = 40
              Width = 166
              Height = 15
              Caption = 'Diminishing metal maker returns'
              TabOrder = 5
              OnClick = chkFilterDiminishingClick
            end
          end
          object SpTBXGroupBox5: TSpTBXGroupBox
            Left = 272
            Top = 6
            Width = 201
            Height = 187
            TabOrder = 2
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
              Left = 120
              Top = 56
              Width = 17
              Height = 20
              Caption = '>'
              TabOrder = 3
              OnClick = btFilterUnitsClick
            end
            object btFilterEnergy: TSpTBXButton
              Left = 120
              Top = 32
              Width = 17
              Height = 20
              Caption = '>'
              TabOrder = 4
              OnClick = btFilterEnergyClick
            end
            object btFilterMetal: TSpTBXButton
              Left = 120
              Top = 8
              Width = 17
              Height = 20
              Caption = '>'
              TabOrder = 5
              OnClick = btFilterMetalClick
            end
            object chkFilterPlayers: TSpTBXCheckBox
              Left = 8
              Top = 82
              Width = 52
              Height = 15
              Caption = 'Players'
              TabOrder = 6
              OnClick = chkFilterPlayersClick
            end
            object btFilterPlayers: TSpTBXButton
              Left = 120
              Top = 80
              Width = 17
              Height = 20
              Caption = '>'
              TabOrder = 7
              OnClick = btFilterPlayersClick
            end
            object chkFilterLength: TSpTBXCheckBox
              Left = 8
              Top = 106
              Width = 76
              Height = 15
              Caption = 'Length (min)'
              TabOrder = 8
              OnClick = chkFilterLengthClick
            end
            object btFilterLength: TSpTBXButton
              Left = 120
              Top = 104
              Width = 17
              Height = 20
              Caption = '>'
              TabOrder = 9
              OnClick = btFilterLengthClick
            end
            object btFilterFileSize: TSpTBXButton
              Left = 120
              Top = 128
              Width = 17
              Height = 20
              Caption = '>'
              TabOrder = 10
              OnClick = btFilterFileSizeClick
            end
            object chkFilterFileSize: TSpTBXCheckBox
              Left = 8
              Top = 130
              Width = 77
              Height = 15
              Caption = 'File size (kB)'
              TabOrder = 11
              OnClick = chkFilterFileSizeClick
            end
            object chkFilterGrade: TSpTBXCheckBox
              Left = 8
              Top = 154
              Width = 47
              Height = 15
              Caption = 'Grade'
              TabOrder = 12
              OnClick = chkFilterGradeClick
            end
            object btFilterGrade: TSpTBXButton
              Left = 120
              Top = 152
              Width = 17
              Height = 20
              Caption = '>'
              TabOrder = 13
              OnClick = btFilterGradeClick
            end
            object speFilterMetal: TSpTBXSpinEdit
              Left = 140
              Top = 8
              Width = 57
              Height = 21
              TabOrder = 14
              OnChange = speFilterMetalChange
              SpinButton.Left = 39
              SpinButton.Top = 0
              SpinButton.Width = 14
              SpinButton.Height = 17
              SpinButton.Align = alRight
              SpinOptions.MaxValue = 10000.000000000000000000
              SpinOptions.Value = 5000.000000000000000000
              OnValueChanged = speFilterMetalChange
            end
            object speFilterEnergy: TSpTBXSpinEdit
              Left = 140
              Top = 32
              Width = 57
              Height = 21
              TabOrder = 15
              OnChange = speFilterEnergyChange
              SpinButton.Left = 39
              SpinButton.Top = 0
              SpinButton.Width = 14
              SpinButton.Height = 17
              SpinButton.Align = alRight
              SpinOptions.MaxValue = 10000.000000000000000000
              SpinOptions.Value = 5000.000000000000000000
              OnValueChanged = speFilterEnergyChange
            end
            object speFilterUnits: TSpTBXSpinEdit
              Left = 140
              Top = 56
              Width = 57
              Height = 21
              TabOrder = 16
              OnChange = speFilterUnitsChange
              SpinButton.Left = 39
              SpinButton.Top = 0
              SpinButton.Width = 14
              SpinButton.Height = 17
              SpinButton.Align = alRight
              SpinOptions.MaxValue = 10000.000000000000000000
              SpinOptions.Value = 3000.000000000000000000
              OnValueChanged = speFilterUnitsChange
            end
            object speFilterPlayers: TSpTBXSpinEdit
              Left = 140
              Top = 80
              Width = 57
              Height = 21
              TabOrder = 17
              OnChange = speFilterPlayersChange
              SpinButton.Left = 39
              SpinButton.Top = 0
              SpinButton.Width = 14
              SpinButton.Height = 17
              SpinButton.Align = alRight
              SpinOptions.MaxValue = 200.000000000000000000
              SpinOptions.Value = 16.000000000000000000
              OnValueChanged = speFilterPlayersChange
            end
            object speFilterLength: TSpTBXSpinEdit
              Left = 140
              Top = 104
              Width = 57
              Height = 21
              TabOrder = 18
              OnChange = speFilterLengthChange
              SpinButton.Left = 39
              SpinButton.Top = 0
              SpinButton.Width = 14
              SpinButton.Height = 17
              SpinButton.Align = alRight
              SpinOptions.MaxValue = 1440.000000000000000000
              SpinOptions.Value = 20.000000000000000000
              OnValueChanged = speFilterLengthChange
            end
            object speFilterFileSize: TSpTBXSpinEdit
              Left = 140
              Top = 128
              Width = 57
              Height = 21
              TabOrder = 19
              OnChange = speFilterFileSizeChange
              SpinButton.Left = 39
              SpinButton.Top = 0
              SpinButton.Width = 14
              SpinButton.Height = 17
              SpinButton.Align = alRight
              SpinOptions.MaxValue = 10000.000000000000000000
              SpinOptions.Value = 1500.000000000000000000
              OnValueChanged = speFilterFileSizeChange
            end
            object speFilterGrade: TSpTBXSpinEdit
              Left = 140
              Top = 152
              Width = 57
              Height = 21
              TabOrder = 20
              OnChange = speFilterGradeChange
              SpinButton.Left = 39
              SpinButton.Top = 0
              SpinButton.Width = 14
              SpinButton.Height = 17
              SpinButton.Align = alRight
              SpinOptions.MaxValue = 10.000000000000000000
              SpinOptions.Value = 5.000000000000000000
              OnValueChanged = speFilterGradeChange
            end
          end
          object SpTBXGroupBox3: TSpTBXGroupBox
            Left = 480
            Top = 0
            Width = 185
            Height = 73
            Caption = 'Start position'
            TabOrder = 3
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
          object SpTBXPanel2: TSpTBXPanel
            Left = 480
            Top = 88
            Width = 185
            Height = 105
            Caption = 'SpTBXPanel2'
            TabOrder = 4
            TBXStyleBackground = True
            object FilterListCombo: TSpTBXComboBox
              Left = 8
              Top = 8
              Width = 121
              Height = 19
              Style = csOwnerDrawFixed
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                'Host'
                'Map'
                'Mod'
                'Disabled units'
                'Spring Version'
                'File Name'
                'Players'
                'Map/Mod option')
            end
            object ContainsRadio: TSpTBXRadioButton
              Left = 8
              Top = 36
              Width = 58
              Height = 15
              Caption = 'contains'
              TabOrder = 1
            end
            object DoNotContainsRadio: TSpTBXRadioButton
              Left = 8
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
              Width = 121
              Height = 21
              Hint = 
                'For map/mod option type '#39'key=value'#39' or just '#39'key'#39' or just '#39'value' +
                #39'. Regexp are supported.'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
            end
            object AddToFilterListButton: TSpTBXButton
              Left = 136
              Top = 8
              Width = 41
              Height = 25
              Caption = '->'
              TabOrder = 4
              OnClick = AddToFilterListButtonClick
            end
            object RemoveFromFilterListButton: TSpTBXButton
              Left = 136
              Top = 40
              Width = 41
              Height = 25
              Caption = '<-'
              TabOrder = 5
              OnClick = RemoveFromFilterListButtonClick
            end
            object ClearFilterListButton: TSpTBXButton
              Left = 136
              Top = 72
              Width = 41
              Height = 25
              Caption = 'Clear'
              TabOrder = 6
              OnClick = ClearFilterListButtonClick
            end
          end
          object FilterList: TVirtualStringTree
            Left = 672
            Top = 8
            Width = 183
            Height = 185
            Align = alCustom
            Anchors = [akLeft, akTop, akRight]
            CheckImageKind = ckSystemFlat
            ClipboardFormats.Strings = (
              'Unicode text')
            DragOperations = []
            EditDelay = 150
            Header.AutoSizeIndex = 3
            Header.DefaultHeight = 17
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'MS Sans Serif'
            Header.Font.Style = []
            Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoShowSortGlyphs, hoVisible]
            Header.SortColumn = 1
            Header.Style = hsFlatButtons
            TabOrder = 5
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
            TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toFullRowSelect]
            OnChecking = FilterListChecking
            OnClick = FilterListClick
            OnCompareNodes = FilterListCompareNodes
            OnDrawText = FilterListDrawText
            OnEditing = FilterListEditing
            OnGetText = FilterListGetText
            OnPaintText = FilterListPaintText
            OnHeaderClick = FilterListHeaderClick
            OnHeaderDraw = FilterListHeaderDraw
            OnNewText = FilterListNewText
            Columns = <
              item
                CheckBox = True
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
                Width = 16
                WideText = 'Value'
              end>
          end
        end
      end
      object EnableFiltersPanel: TSpTBXPanel
        Left = 0
        Top = 229
        Width = 875
        Height = 19
        Align = alBottom
        TabOrder = 1
        Borders = False
        object chkEnableFilters: TSpTBXCheckBox
          Left = 9
          Top = 0
          Width = 110
          Height = 19
          Caption = 'Enable filters'
          Align = alLeft
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = chkEnableFiltersClick
        end
        object FiltersButton: TSpTBXButton
          Left = 128
          Top = 0
          Width = 747
          Height = 19
          Align = alClient
          TabOrder = 1
          OnClick = FiltersButtonClick
          Images = MainForm.ArrowList
          ImageIndex = 1
        end
        object SpacerPanel2: TSpTBXPanel
          Left = 119
          Top = 0
          Width = 9
          Height = 19
          Caption = 'SpTBXPanel1'
          Align = alLeft
          TabOrder = 2
          Borders = False
        end
        object SpacerPanel1: TSpTBXPanel
          Left = 0
          Top = 0
          Width = 9
          Height = 19
          Align = alLeft
          TabOrder = 3
          Borders = False
        end
      end
    end
    object LoadingPanel: TSpTBXPanel
      Left = 368
      Top = 256
      Width = 87
      Height = 71
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnResize = LoadingPanelResize
      TBXStyleBackground = True
      DesignSize = (
        87
        71)
      object LoadingLabel: TSpTBXLabel
        Left = 2
        Top = 50
        Width = 84
        Height = 20
        Caption = 'Please wait while building replay list ...'
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Alignment = taCenter
      end
    end
  end
  object ReplayListPopupMenu: TSpTBXPopupMenu
    AutoHotkeys = maManual
    Left = 784
    Top = 520
  end
end
