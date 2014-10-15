object ManageGroupsForm: TManageGroupsForm
  Left = 518
  Top = 522
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Manage groups'
  ClientHeight = 466
  ClientWidth = 596
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 596
    Height = 466
    Caption = 'Manage groups'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object lstClients: TSpTBXCheckListBox
      Left = 8
      Top = 72
      Width = 225
      Height = 313
      DragMode = dmAutomatic
      ItemHeight = 16
      TabOrder = 1
      OnDragDrop = lstClientsDragDrop
      OnDragOver = lstClientsDragOver
    end
    object cmbGroups: TSpTBXComboBox
      Left = 8
      Top = 40
      Width = 225
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      TabOrder = 2
      OnChange = cmbGroupsChange
    end
    object SpTBXPanel1: TSpTBXPanel
      Left = 8
      Top = 396
      Width = 577
      Height = 41
      Caption = 'SpTBXPanel1'
      TabOrder = 3
      TBXStyleBackground = True
      DesignSize = (
        577
        41)
      object btRemove: TSpTBXButton
        Left = 128
        Top = 8
        Width = 113
        Height = 25
        Hint = 'Remove selected players from the group'
        Caption = 'Remove players'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btRemoveClick
      end
      object btRemoveGroup: TSpTBXButton
        Left = 248
        Top = 8
        Width = 113
        Height = 25
        Caption = 'Remove group'
        TabOrder = 1
        OnClick = btRemoveGroupClick
      end
      object btClose: TSpTBXButton
        Left = 456
        Top = 8
        Width = 113
        Height = 25
        Caption = 'Close'
        Anchors = [akTop, akRight]
        TabOrder = 2
        OnClick = btCloseClick
      end
      object btAddPlayer: TSpTBXButton
        Left = 8
        Top = 8
        Width = 113
        Height = 25
        Caption = 'Add player'
        TabOrder = 3
        OnClick = btAddPlayerClick
      end
    end
    object SpTBXPanel2: TSpTBXPanel
      Left = 240
      Top = 40
      Width = 345
      Height = 345
      Caption = 'SpTBXPanel2'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 4
      object ColorPanel: TPanel
        Left = 232
        Top = 32
        Width = 73
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 0
      end
      object SpTBXLabel1: TSpTBXLabel
        Left = 8
        Top = 12
        Width = 193
        Height = 13
        Caption = 'Name :'
        AutoSize = False
        Alignment = taRightJustify
      end
      object btChooseColor: TSpTBXButton
        Left = 312
        Top = 32
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 2
        OnClick = btChooseColorClick
      end
      object AutoSpecCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 80
        Width = 212
        Height = 15
        Caption = 'Auto-spec :'
        AutoSize = False
        TabOrder = 3
        OnClick = AutoSpecCheckBoxClick
        Alignment = taRightJustify
      end
      object AutoKickCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 58
        Width = 212
        Height = 15
        Caption = 'Auto-kick :'
        AutoSize = False
        TabOrder = 4
        OnClick = AutoKickCheckBoxClick
        Alignment = taRightJustify
      end
      object NotifyOnHostCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 104
        Width = 212
        Height = 15
        Caption = 'Notify on host :'
        AutoSize = False
        TabOrder = 5
        OnClick = NotifyOnHostCheckBoxClick
        Alignment = taRightJustify
      end
      object NotifyOnJoinCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 128
        Width = 212
        Height = 15
        Caption = 'Notify on join :'
        AutoSize = False
        TabOrder = 6
        OnClick = NotifyOnJoinCheckBoxClick
        Alignment = taRightJustify
      end
      object NotifyOnBattlEndCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 152
        Width = 212
        Height = 15
        Caption = 'Notify on battle end :'
        AutoSize = False
        TabOrder = 7
        OnClick = NotifyOnBattlEndCheckBoxClick
        Alignment = taRightJustify
      end
      object NotifyOnConnectCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 176
        Width = 212
        Height = 15
        Caption = 'Notify on connect :'
        AutoSize = False
        TabOrder = 8
        OnClick = NotifyOnConnectCheckBoxClick
        Alignment = taRightJustify
      end
      object txtName: TSpTBXEdit
        Left = 208
        Top = 10
        Width = 129
        Height = 21
        TabOrder = 9
        OnChange = txtNameChange
      end
      object HighlightBattlesCheckbox: TSpTBXCheckBox
        Left = 8
        Top = 200
        Width = 212
        Height = 15
        Caption = 'Highlight battles :'
        AutoSize = False
        TabOrder = 10
        OnClick = HighlightBattlesCheckboxClick
        Alignment = taRightJustify
      end
      object ChatColorPanel: TPanel
        Left = 232
        Top = 222
        Width = 73
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 11
      end
      object btChooseChatColor: TSpTBXButton
        Left = 312
        Top = 222
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 12
        OnClick = btChooseChatColorClick
      end
      object ChatColorCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 224
        Width = 212
        Height = 15
        Caption = 'Chat color :'
        AutoSize = False
        TabOrder = 13
        OnClick = ChatColorCheckBoxClick
        Alignment = taRightJustify
      end
      object ReplaceRankCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 248
        Width = 212
        Height = 15
        Caption = 'Replace rank :'
        AutoSize = False
        TabOrder = 14
        OnClick = ReplaceRankCheckBoxClick
        Alignment = taRightJustify
      end
      object ReplaceRankCmb: TSpTBXComboBox
        Left = 232
        Top = 245
        Width = 105
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 15
        OnChange = ReplaceRankCmbChange
        OnDrawItem = ReplaceRankCmbDrawItem
      end
      object BalanceInSameTeamCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 272
        Width = 212
        Height = 15
        Hint = 
          'Act like if all member of the group were in the same clan when b' +
          'alancing teams.'
        Caption = 'Balance in same team :'
        AutoSize = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        OnClick = BalanceInSameTeamCheckBoxClick
        Alignment = taRightJustify
      end
      object IgnoreCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 296
        Width = 212
        Height = 15
        Caption = 'Ignore :'
        AutoSize = False
        TabOrder = 17
        OnClick = IgnoreCheckBoxClick
        Alignment = taRightJustify
      end
      object ColorCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 36
        Width = 212
        Height = 15
        Caption = 'Color :'
        AutoSize = False
        TabOrder = 18
        OnClick = ColorCheckBoxClick
        Alignment = taRightJustify
      end
      object ExecSpecCommandsCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 318
        Width = 212
        Height = 15
        Hint = 
          'Will execute special commands sent by users from this group such' +
          ' as "!join host"'
        Caption = 'Execute special commands :'
        AutoSize = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 19
        OnClick = ExecSpecCommandsCheckBoxClick
        Alignment = taRightJustify
      end
    end
    object SpTBXLabel13: TSpTBXLabel
      Left = 8
      Top = 440
      Width = 411
      Height = 13
      Caption = 
        'Tips : you can drag players from the main window or the battle w' +
        'indow to the above list.'
    end
  end
end
