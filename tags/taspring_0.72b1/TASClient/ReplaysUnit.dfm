object ReplaysForm: TReplaysForm
  Left = 284
  Top = 195
  BorderStyle = bsDialog
  Caption = 'Replays'
  ClientHeight = 444
  ClientWidth = 538
  Color = clBtnFace
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
    Width = 538
    Height = 444
    Caption = 'Replays'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object ReloadButton: TSpTBXSpeedButton
      Left = 272
      Top = 32
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
    object PlayersLabel: TSpTBXLabel
      Left = 392
      Top = 112
      Width = 37
      Height = 13
      Caption = 'Players:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object DeleteButton: TSpTBXSpeedButton
      Left = 272
      Top = 56
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
    object SaveButton: TSpTBXSpeedButton
      Left = 272
      Top = 104
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
      Left = 272
      Top = 80
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
    object WatchButton: TSpTBXButton
      Left = 152
      Top = 408
      Width = 75
      Height = 25
      Caption = 'Watch'
      TabOrder = 6
      OnClick = WatchButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object CloseButton: TSpTBXButton
      Left = 312
      Top = 408
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 7
      OnClick = CloseButtonClick
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object ReplaysListBox: TSpTBXListBox
      Left = 8
      Top = 32
      Width = 257
      Height = 177
      ItemHeight = 16
      TabOrder = 8
      OnClick = ReplaysListBoxClick
      OnDblClick = ReplaysListBoxDblClick
      OnDrawItem = ReplaysListBoxDrawItem
    end
    object PlayersListBox: TSpTBXListBox
      Left = 392
      Top = 128
      Width = 121
      Height = 81
      ItemHeight = 13
      TabOrder = 9
    end
    object GradeComboBox: TSpTBXComboBox
      Left = 272
      Top = 152
      Width = 113
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 13
      TabOrder = 10
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
    object Panel1: TSpTBXPanel
      Left = 376
      Top = 32
      Width = 153
      Height = 65
      Color = clNone
      ParentColor = False
      TabOrder = 11
      BorderType = pbrRaised
      object Label3: TSpTBXLabel
        Left = 8
        Top = 8
        Width = 24
        Height = 13
        Caption = 'Map:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object MapLabel: TSpTBXLabel
        Left = 40
        Top = 8
        Width = 47
        Height = 13
        Caption = 'MapLabel'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Label4: TSpTBXLabel
        Left = 8
        Top = 24
        Width = 24
        Height = 13
        Caption = 'Mod:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object GameTypeLabel: TSpTBXLabel
        Left = 42
        Top = 24
        Width = 78
        Height = 13
        Caption = 'GameTypeLabel'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Label2: TSpTBXLabel
        Left = 8
        Top = 40
        Width = 23
        Height = 13
        Caption = 'Size:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SizeLabel: TSpTBXLabel
        Left = 40
        Top = 40
        Width = 46
        Height = 13
        Caption = 'SizeLabel'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
    end
    object HostReplayButton: TSpTBXButton
      Left = 160
      Top = 408
      Width = 75
      Height = 25
      Caption = 'Host replay'
      TabOrder = 12
      Visible = False
      OnClick = HostReplayButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object PageControl1: TSpTBXTabControl
      Left = 8
      Top = 216
      Width = 521
      Height = 185
      ActiveTabIndex = 1
      HiddenItems = <>
      object SpTBXTabItem2: TSpTBXTabItem
        CaptionW = 'Comments'
      end
      object SpTBXTabItem1: TSpTBXTabItem
        Checked = True
        CaptionW = 'Script'
      end
      object SpTBXTabSheet2: TSpTBXTabSheet
        Left = 0
        Top = 23
        Width = 521
        Height = 162
        Caption = 'Comments'
        ImageIndex = -1
        TabItem = 'SpTBXTabItem2'
        object CommentsRichEdit: TRichEdit
          Left = 2
          Top = 0
          Width = 517
          Height = 160
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          OnChange = CommentsRichEditChange
        end
      end
      object SpTBXTabSheet1: TSpTBXTabSheet
        Left = 0
        Top = 23
        Width = 521
        Height = 162
        Caption = 'Script'
        ImageIndex = -1
        TabItem = 'SpTBXTabItem1'
        object ScriptRichEdit: TRichEdit
          Left = 2
          Top = 0
          Width = 517
          Height = 160
          Align = alClient
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
    end
    object LoadingPanel: TSpTBXPanel
      Left = 400
      Top = 392
      Width = 129
      Height = 41
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 13
      OnResize = LoadingPanelResize
      TBXStyleBackground = True
      object LoadingLabel: TSpTBXLabel
        Left = 2
        Top = 2
        Width = 279
        Height = 20
        Caption = 'Please wait while building replay list ...'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 272
      Top = 136
      Width = 32
      Height = 13
      Caption = 'Grade:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
