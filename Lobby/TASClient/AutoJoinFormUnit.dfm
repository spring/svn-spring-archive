object AutoJoinForm: TAutoJoinForm
  Left = 470
  Top = 116
  BorderStyle = bsSingle
  Caption = 'AutoJoin'
  ClientHeight = 565
  ClientWidth = 736
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
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 736
    Height = 565
    Caption = 'AutoJoin'
    Active = False
    FixedSize = True
    Options.Maximize = False
    DesignSize = (
      736
      565)
    object gbAutoPlay: TSpTBXGroupBox
      Left = 192
      Top = 40
      Width = 536
      Height = 169
      Caption = 'Autoplay preset list'
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      DesignSize = (
        536
        169)
      object VSTAutoplayPresetList: TVirtualStringTree
        Left = 8
        Top = 16
        Width = 488
        Height = 145
        Anchors = [akLeft, akTop, akRight, akBottom]
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoVisible]
        Header.Style = hsFlatButtons
        TabOrder = 0
        TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toFullVertGridLines]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnDrawText = VSTAutoplayPresetListDrawText
        OnGetText = VSTAutoplayPresetListGetText
        OnPaintText = VSTAutoplayPresetListPaintText
        OnHeaderDraw = VSTAutoplayPresetListHeaderDraw
        Columns = <
          item
            Position = 0
            WideText = 'Priority'
          end
          item
            Position = 1
            Width = 200
            WideText = 'Filters preset name'
          end
          item
            Position = 2
            Width = 100
            WideText = 'Sorting'
          end
          item
            Position = 3
            Width = 60
            WideText = 'Sort. dir.'
          end>
      end
      object btAutoplayPriorityUp: TSpTBXButton
        Left = 503
        Top = 16
        Width = 25
        Height = 33
        Anchors = [akTop, akRight]
        TabOrder = 1
        OnClick = btAutoplayPriorityUpClick
        Images = MainForm.ArrowList
        ImageIndex = 0
      end
      object btAutoplayPriorityDown: TSpTBXButton
        Left = 503
        Top = 56
        Width = 25
        Height = 33
        Anchors = [akTop, akRight]
        TabOrder = 2
        OnClick = btAutoplayPriorityDownClick
        Images = MainForm.ArrowList
        ImageIndex = 1
      end
      object btAutoplayRemovePreset: TSpTBXButton
        Left = 503
        Top = 136
        Width = 25
        Height = 25
        Caption = 'X'
        Anchors = [akRight, akBottom]
        TabOrder = 3
        OnClick = btAutoplayRemovePresetClick
      end
    end
    object gbAddPreset: TSpTBXGroupBox
      Left = 8
      Top = 40
      Width = 177
      Height = 345
      Caption = 'Add preset'
      TabOrder = 2
      object SpTBXLabel1: TSpTBXLabel
        Left = 8
        Top = 112
        Width = 60
        Height = 13
        Caption = 'Filter preset :'
      end
      object cmbFilterPresetList: TSpTBXComboBox
        Left = 32
        Top = 128
        Width = 137
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
      object SpTBXLabel2: TSpTBXLabel
        Left = 8
        Top = 152
        Width = 39
        Height = 13
        Caption = 'Sorting :'
      end
      object cmbSortingList: TSpTBXComboBox
        Left = 32
        Top = 168
        Width = 137
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 5
        TabOrder = 3
        Text = 'Players'
        Items.Strings = (
          'Host'
          'Map name'
          'State'
          'Mod name'
          'Avg rank'
          'Players'
          'Players/MaxPlayers')
      end
      object SpTBXLabel3: TSpTBXLabel
        Left = 8
        Top = 192
        Width = 82
        Height = 13
        Caption = 'Sorting direction :'
      end
      object cmbSortDir: TSpTBXComboBox
        Left = 32
        Top = 208
        Width = 137
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 5
        Text = 'Asc'
        Items.Strings = (
          'Asc'
          'Desc')
      end
      object btAddPresetToAutoplay: TSpTBXButton
        Left = 8
        Top = 16
        Width = 161
        Height = 33
        Caption = 'Add autoplay'
        TabOrder = 6
        OnClick = btAddPresetToAutoplayClick
        Images = MainForm.MiscImageList
        ImageIndex = 4
      end
      object btAddPresetToAutospec: TSpTBXButton
        Left = 16
        Top = 304
        Width = 153
        Height = 33
        Caption = 'Add autospec'
        TabOrder = 7
        OnClick = btAddPresetToAutospecClick
        Images = MainForm.MiscImageList
        ImageIndex = 4
      end
    end
    object gbAutoSpec: TSpTBXGroupBox
      Left = 192
      Top = 216
      Width = 536
      Height = 169
      Caption = 'Autospec preset list'
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      DesignSize = (
        536
        169)
      object VSTAutospecPresetList: TVirtualStringTree
        Left = 8
        Top = 16
        Width = 488
        Height = 145
        Anchors = [akLeft, akTop, akRight, akBottom]
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoVisible]
        Header.Style = hsFlatButtons
        TabOrder = 0
        TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages, toFullVertGridLines]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnDrawText = VSTAutospecPresetListDrawText
        OnGetText = VSTAutospecPresetListGetText
        OnPaintText = VSTAutospecPresetListPaintText
        OnHeaderDraw = VSTAutospecPresetListHeaderDraw
        Columns = <
          item
            Position = 0
            WideText = 'Priority'
          end
          item
            Position = 1
            Width = 200
            WideText = 'Filters preset name'
          end
          item
            Position = 2
            Width = 100
            WideText = 'Sorting'
          end
          item
            Position = 3
            Width = 60
            WideText = 'Sort. dir.'
          end>
      end
      object btAutospecPriorityUp: TSpTBXButton
        Left = 503
        Top = 16
        Width = 25
        Height = 33
        Anchors = [akTop, akRight]
        TabOrder = 1
        OnClick = btAutospecPriorityUpClick
        Images = MainForm.ArrowList
        ImageIndex = 0
      end
      object btAutospecPriorityDown: TSpTBXButton
        Left = 503
        Top = 56
        Width = 25
        Height = 33
        Anchors = [akTop, akRight]
        TabOrder = 2
        OnClick = btAutospecPriorityDownClick
        Images = MainForm.ArrowList
        ImageIndex = 1
      end
      object btAutospecRemovePreset: TSpTBXButton
        Left = 503
        Top = 136
        Width = 25
        Height = 25
        Caption = 'X'
        Anchors = [akRight, akBottom]
        TabOrder = 3
        OnClick = btAutospecRemovePresetClick
      end
    end
    object btClose: TSpTBXButton
      Left = 311
      Top = 528
      Width = 113
      Height = 25
      Caption = 'Close'
      TabOrder = 4
      OnClick = btCloseClick
    end
    object gbOptions: TSpTBXGroupBox
      Left = 8
      Top = 392
      Width = 424
      Height = 129
      Caption = 'Options'
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      object chkKeepLookingAfterJoining: TSpTBXCheckBox
        Left = 16
        Top = 24
        Width = 296
        Height = 15
        Caption = 'Keep looking for the best battle after joining until I am ready'
        TabOrder = 0
      end
      object chkLeaveNotFittingBattles: TSpTBXCheckBox
        Left = 16
        Top = 40
        Width = 128
        Height = 15
        Caption = 'Leave battles not fitting'
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 1
      end
      object chkStopAutoJoinWhenLeaving: TSpTBXCheckBox
        Left = 16
        Top = 56
        Width = 245
        Height = 15
        Caption = 'Stop autojoin when I leave or join a battle myself'
        TabOrder = 2
      end
    end
    object gbPresets: TSpTBXGroupBox
      Left = 439
      Top = 392
      Width = 289
      Height = 129
      Caption = 'Presets'
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      object btSavePreset: TSpTBXButton
        Left = 8
        Top = 40
        Width = 97
        Height = 25
        Caption = 'Save'
        TabOrder = 0
        OnClick = btSavePresetClick
      end
      object btDeletePreset: TSpTBXButton
        Left = 8
        Top = 72
        Width = 97
        Height = 25
        Caption = 'Delete'
        TabOrder = 1
        OnClick = btDeletePresetClick
      end
      object txtPresetName: TSpTBXEdit
        Left = 8
        Top = 16
        Width = 97
        Height = 21
        TabOrder = 2
        Text = 'preset name'
      end
      object btClearPresets: TSpTBXButton
        Left = 8
        Top = 96
        Width = 97
        Height = 25
        Caption = 'Clear'
        TabOrder = 3
        OnClick = btClearPresetsClick
      end
      object lstPresetList: TSpTBXListBox
        Left = 112
        Top = 16
        Width = 169
        Height = 105
        ItemHeight = 16
        Items.Strings = (
          'current')
        TabOrder = 4
        OnClick = lstPresetListClick
        OnDblClick = lstPresetListDblClick
      end
    end
  end
end
