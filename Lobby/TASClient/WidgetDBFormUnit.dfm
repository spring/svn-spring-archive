object WidgetDBForm: TWidgetDBForm
  Left = 741
  Top = 184
  Width = 835
  Height = 603
  Caption = 'Widget database'
  Color = clBtnFace
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
    Width = 827
    Height = 576
    Caption = 'Widget database'
    Active = False
    object pnlMain: TSpTBXPanel
      Left = 0
      Top = 22
      Width = 827
      Height = 554
      Caption = 'pnlMain'
      Align = alClient
      TabOrder = 1
      Borders = False
      TBXStyleBackground = True
      object SpTBXSplitter1: TSpTBXSplitter
        Left = 0
        Top = 176
        Width = 827
        Height = 9
        Cursor = crSizeNS
        Align = alBottom
      end
      object vstWidgetList: TVirtualStringTree
        Left = 0
        Top = 25
        Width = 827
        Height = 151
        Align = alClient
        CheckImageKind = ckSystemFlat
        DragOperations = []
        Header.AutoSizeIndex = 1
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoShowHint, hoShowSortGlyphs, hoVisible]
        Header.SortColumn = 1
        Header.Style = hsFlatButtons
        HintMode = hmHint
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
        TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnChecking = vstWidgetListChecking
        OnCompareNodes = vstWidgetListCompareNodes
        OnDrawText = vstWidgetListDrawText
        OnFocusChanged = vstWidgetListFocusChanged
        OnGetText = vstWidgetListGetText
        OnPaintText = vstWidgetListPaintText
        OnGetHint = vstWidgetListGetHint
        OnHeaderClick = vstWidgetListHeaderClick
        OnHeaderDraw = vstWidgetListHeaderDraw
        Columns = <
          item
            CheckBox = True
            MaxWidth = 20
            MinWidth = 20
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coShowDropMark, coVisible]
            Position = 0
            Width = 20
            WideText = 'Installed'
          end
          item
            Position = 1
            Width = 168
            WideText = 'Name'
          end
          item
            Position = 2
            Width = 100
            WideText = 'Category'
          end
          item
            Position = 3
            WideText = 'DLs'
          end
          item
            Position = 4
            Width = 100
            WideText = 'Games'
          end
          item
            Position = 5
            Width = 45
            WideText = 'Rating'
          end
          item
            Position = 6
            Width = 45
            WideText = 'Votes'
          end
          item
            Position = 7
            WideText = 'Comments'
          end
          item
            Position = 8
            Width = 125
            WideText = 'Author'
          end
          item
            Position = 9
            Width = 120
            WideText = 'Entry date'
          end>
      end
      object pnlWidgetInfo: TSpTBXPanel
        Left = 0
        Top = 185
        Width = 827
        Height = 369
        Align = alBottom
        TabOrder = 2
        Borders = False
        TBXStyleBackground = True
        object pnlMiddle: TSpTBXPanel
          Left = 0
          Top = 0
          Width = 827
          Height = 38
          Caption = 'pnlMiddle'
          Align = alTop
          TabOrder = 0
          Borders = False
          BorderType = pbrFramed
          TBXStyleBackground = True
          object lblWidgetName: TSpTBXLabel
            Left = 0
            Top = 4
            Width = 0
            Height = 0
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -24
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object btUninstall: TSpTBXButton
            Left = 485
            Top = 0
            Width = 171
            Height = 38
            Caption = 'Uninstall'
            Align = alRight
            Enabled = False
            TabOrder = 2
            OnClick = btUninstallClick
          end
          object btInstall: TSpTBXButton
            Left = 656
            Top = 0
            Width = 171
            Height = 38
            Caption = 'Install'
            Align = alRight
            TabOrder = 1
            OnClick = btInstallClick
          end
          object gbRate: TSpTBXGroupBox
            Left = 376
            Top = 0
            Width = 109
            Height = 38
            Caption = 'Rate'
            Align = alRight
            TabOrder = 3
            object btRate5: TSpTBXButton
              Left = 86
              Top = 15
              Width = 21
              Height = 21
              Caption = '5'
              Align = alLeft
              TabOrder = 0
              OnClick = btRate5Click
            end
            object btRate4: TSpTBXButton
              Left = 65
              Top = 15
              Width = 21
              Height = 21
              Caption = '4'
              Align = alLeft
              TabOrder = 1
              OnClick = btRate4Click
            end
            object btRate3: TSpTBXButton
              Left = 44
              Top = 15
              Width = 21
              Height = 21
              Caption = '3'
              Align = alLeft
              TabOrder = 2
              OnClick = btRate3Click
            end
            object btRate2: TSpTBXButton
              Left = 23
              Top = 15
              Width = 21
              Height = 21
              Caption = '2'
              Align = alLeft
              TabOrder = 3
              OnClick = btRate2Click
            end
            object btRate1: TSpTBXButton
              Left = 2
              Top = 15
              Width = 21
              Height = 21
              Caption = '1'
              Align = alLeft
              TabOrder = 4
              OnClick = btRate1Click
            end
          end
        end
        object SpTBXSplitter2: TSpTBXSplitter
          Left = 0
          Top = 38
          Width = 827
          Height = 9
          Cursor = crSizeNS
          Align = alTop
          Visible = False
        end
        object tcWidgetInfo: TSpTBXTabControl
          Left = 0
          Top = 47
          Width = 827
          Height = 322
          Align = alClient
          ActiveTabIndex = 0
          HiddenItems = <>
          object tabWidgetDescription: TSpTBXTabItem
            Caption = 'Description'
            Checked = True
          end
          object tabWidgetChangelog: TSpTBXTabItem
            Caption = 'Changelog'
          end
          object tabWidgetComments: TSpTBXTabItem
            Caption = 'Comments'
          end
          object tsWidgetChangelog: TSpTBXTabSheet
            Left = 0
            Top = 23
            Width = 827
            Height = 299
            Caption = 'Changelog'
            ImageIndex = -1
            TabItem = 'tabWidgetChangelog'
            object reChangelog: TRichEdit
              Left = 2
              Top = 0
              Width = 823
              Height = 297
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object tsWidgetComments: TSpTBXTabSheet
            Left = 0
            Top = 23
            Width = 827
            Height = 299
            Caption = 'Comments'
            ImageIndex = -1
            TabItem = 'tabWidgetComments'
            object reComments: TRichEdit
              Left = 2
              Top = 0
              Width = 823
              Height = 258
              Align = alClient
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object pnlPostComment: TSpTBXPanel
              Left = 2
              Top = 258
              Width = 823
              Height = 39
              Align = alBottom
              TabOrder = 1
              TBXStyleBackground = True
              object reMyComment: TRichEdit
                Left = 2
                Top = 2
                Width = 740
                Height = 35
                Align = alClient
                ScrollBars = ssVertical
                TabOrder = 0
              end
              object btSendComment: TSpTBXButton
                Left = 742
                Top = 2
                Width = 79
                Height = 35
                Caption = 'Send'
                Align = alRight
                TabOrder = 1
                OnClick = btSendCommentClick
              end
            end
          end
          object tsWidgetDescription: TSpTBXTabSheet
            Left = 0
            Top = 23
            Width = 827
            Height = 299
            Caption = 'Description'
            ImageIndex = -1
            TabItem = 'tabWidgetDescription'
          end
        end
      end
      object mmDescriptionHtml: TMemo
        Left = 96
        Top = 272
        Width = 281
        Height = 81
        Lines.Strings = (
          '<html>'
          '        <head>'
          '                <style type="text/css">'
          '                        body {'
          '                                background-color: $bgcolor;'
          '                                color: $textcolor;'
          '                                font-family: Arial;'
          '                                overflow: auto;'
          '                        }'
          '                        a:link {color: $linkcolor;}'
          '                        a:visited {color: $linkcolor;}'
          '                        a:hover {color: $linkcolor;}'
          '                        a:active {color: $linkcolor;}'
          '                </style>'
          '        </head>'
          '        <body>'
          '        $content'
          '        </body>'
          '</html>')
        TabOrder = 3
        Visible = False
      end
      object mmScreenshotsHtml: TMemo
        Left = 384
        Top = 272
        Width = 281
        Height = 81
        Lines.Strings = (
          '<html>'
          '        <head>'
          '                <style type="text/css">'
          '                        body {'
          '                                background-color: $bgcolor;'
          '                                color: $textcolor;'
          '                                font-family: Arial;'
          '                                overflow: auto;'
          '                                margin: 0;'
          '                        }'
          '                        a:link {color: $linkcolor;}'
          '                        a:visited {color: $linkcolor;}'
          '                        a:hover {color: $linkcolor;}'
          '                        a:active {color: $linkcolor;}'
          '                        img.ScreenshotItem {'
          '                                height: 100%;'
          '                                width: auto;'
          '                                margin-right: 4px;'
          '                                margin-bottom: -4px;'
          '                        }'
          '                        a img {'
          '                                border: 0;'
          '                        }'
          '                </style>'
          '        </head>'
          '        <body>'
          '        $content'
          '        </body>'
          '</html>')
        TabOrder = 4
        Visible = False
      end
      object pnlTop: TSpTBXPanel
        Left = 0
        Top = 0
        Width = 827
        Height = 25
        Align = alTop
        TabOrder = 5
        BorderType = pbrFramed
        TBXStyleBackground = True
        object btRefresh: TSpTBXButton
          Left = 654
          Top = 2
          Width = 171
          Height = 21
          Caption = 'Refresh'
          Align = alRight
          TabOrder = 0
          OnClick = btRefreshClick
        end
        object lblFilter: TSpTBXLabel
          Left = 2
          Top = 2
          Width = 71
          Height = 21
          Caption = 'Filter :'
          Align = alLeft
          AutoSize = False
          Alignment = taRightJustify
        end
        object txtFilter: TSpTBXButtonEdit
          Left = 80
          Top = 2
          Width = 225
          Height = 21
          TabOrder = 2
          OnChange = txtFilterChange
          EditButton.Left = 202
          EditButton.Top = 0
          EditButton.Width = 19
          EditButton.Height = 17
          EditButton.Caption = 'X'
          EditButton.Align = alRight
          EditButton.OnClick = txtFilterSubEditButton0Click
        end
      end
    end
    object mmScreenshotItemHtml: TMemo
      Left = 384
      Top = 384
      Width = 281
      Height = 81
      Lines.Strings = (
        '<a href="$url"><img class="ScreenshotItem" src="$url" '
        'alt="Screen Shot"/></a>')
      TabOrder = 2
      Visible = False
    end
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 56
    Top = 120
  end
  object IdHTTP1: TIdHTTP
    MaxLineLength = 32768
    MaxLineAction = maException
    ReadTimeout = 0
    RecvBufferSize = 65536
    SendBufferSize = 65536
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 344
    Top = 128
  end
end
