object ReplaysForm: TReplaysForm
  Left = 374
  Top = 303
  BorderStyle = bsDialog
  Caption = 'Replays'
  ClientHeight = 414
  ClientWidth = 536
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
  object ReloadButton: TSpeedButton
    Left = 272
    Top = 8
    Width = 97
    Height = 22
    Caption = 'Reload'
    Enabled = False
    OnClick = ReloadButtonClick
  end
  object PlayersLabel: TLabel
    Left = 392
    Top = 88
    Width = 37
    Height = 13
    Caption = 'Players:'
  end
  object DeleteButton: TSpeedButton
    Left = 272
    Top = 32
    Width = 97
    Height = 22
    Caption = 'Delete'
    Enabled = False
    OnClick = DeleteButtonClick
  end
  object SaveButton: TSpeedButton
    Left = 272
    Top = 80
    Width = 97
    Height = 22
    Caption = 'Save'
    Enabled = False
    OnClick = SaveButtonClick
  end
  object Label1: TLabel
    Left = 272
    Top = 112
    Width = 32
    Height = 13
    Caption = 'Grade:'
  end
  object RenameButton: TSpeedButton
    Left = 272
    Top = 56
    Width = 97
    Height = 22
    Caption = 'Rename'
    Enabled = False
    OnClick = RenameButtonClick
  end
  object WatchButton: TButton
    Left = 152
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Watch'
    TabOrder = 0
    OnClick = WatchButtonClick
  end
  object CloseButton: TButton
    Left = 312
    Top = 384
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 1
    OnClick = CloseButtonClick
  end
  object ReplaysListBox: TListBox
    Left = 8
    Top = 8
    Width = 257
    Height = 177
    Style = lbOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 2
    OnClick = ReplaysListBoxClick
    OnDblClick = ReplaysListBoxDblClick
    OnDrawItem = ReplaysListBoxDrawItem
  end
  object PlayersListBox: TListBox
    Left = 392
    Top = 104
    Width = 121
    Height = 81
    ItemHeight = 13
    TabOrder = 3
  end
  object GradeComboBox: TComboBox
    Left = 272
    Top = 128
    Width = 113
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    TabOrder = 4
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
  object PageControl1: TPageControl
    Left = 8
    Top = 192
    Width = 521
    Height = 185
    ActivePage = TabSheet1
    TabOrder = 5
    object TabSheet1: TTabSheet
      Caption = 'Comments'
      object CommentsRichEdit: TRichEdit
        Left = 0
        Top = 0
        Width = 513
        Height = 157
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
        OnChange = CommentsRichEditChange
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Script'
      ImageIndex = 1
      object ScriptRichEdit: TRichEdit
        Left = 0
        Top = 0
        Width = 513
        Height = 157
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object Panel1: TPanel
    Left = 376
    Top = 8
    Width = 153
    Height = 65
    TabOrder = 6
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 24
      Height = 13
      Caption = 'Map:'
    end
    object MapLabel: TLabel
      Left = 40
      Top = 8
      Width = 47
      Height = 13
      Caption = 'MapLabel'
    end
    object Label4: TLabel
      Left = 8
      Top = 24
      Width = 24
      Height = 13
      Caption = 'Mod:'
    end
    object GameTypeLabel: TLabel
      Left = 42
      Top = 24
      Width = 78
      Height = 13
      Caption = 'GameTypeLabel'
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 23
      Height = 13
      Caption = 'Size:'
    end
    object SizeLabel: TLabel
      Left = 40
      Top = 40
      Width = 46
      Height = 13
      Caption = 'SizeLabel'
    end
  end
  object HostReplayButton: TButton
    Left = 160
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Host replay'
    TabOrder = 7
    Visible = False
    OnClick = HostReplayButtonClick
  end
  object LoadingPanel: TPanel
    Left = 400
    Top = 360
    Width = 129
    Height = 41
    Caption = 'Please wait while building replay list ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
end
