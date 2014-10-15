object ManageGroupsForm: TManageGroupsForm
  Left = 507
  Top = 281
  BorderStyle = bsDialog
  Caption = 'ManageGroupsForm'
  ClientHeight = 374
  ClientWidth = 473
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
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 473
    Height = 374
    Caption = 'Manage groups'
    FixedSize = True
    Options.Maximize = False
    object lstClients: TSpTBXCheckListBox
      Left = 8
      Top = 72
      Width = 225
      Height = 241
      ItemHeight = 16
      TabOrder = 1
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
      Top = 325
      Width = 456
      Height = 41
      Caption = 'SpTBXPanel1'
      TabOrder = 3
      DesignSize = (
        456
        41)
      object btRemove: TSpTBXButton
        Left = 8
        Top = 8
        Width = 89
        Height = 25
        Caption = 'Remove clients'
        TabOrder = 0
        OnClick = btRemoveClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object btRemoveGroup: TSpTBXButton
        Left = 102
        Top = 8
        Width = 97
        Height = 25
        Caption = 'Remove group'
        TabOrder = 1
        OnClick = btRemoveGroupClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object btClose: TSpTBXButton
        Left = 376
        Top = 8
        Width = 73
        Height = 25
        Caption = 'Close'
        Anchors = [akTop, akRight]
        TabOrder = 2
        OnClick = btCloseClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
    end
    object SpTBXPanel2: TSpTBXPanel
      Left = 240
      Top = 40
      Width = 225
      Height = 273
      Caption = 'SpTBXPanel2'
      TabOrder = 4
      DesignSize = (
        225
        273)
      object ColorPanel: TPanel
        Left = 120
        Top = 32
        Width = 57
        Height = 21
        Anchors = [akTop, akRight]
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 0
      end
      object SpTBXLabel1: TSpTBXLabel
        Left = 8
        Top = 12
        Width = 34
        Height = 13
        Caption = 'Name :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel2: TSpTBXLabel
        Left = 8
        Top = 36
        Width = 30
        Height = 13
        Caption = 'Color :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel3: TSpTBXLabel
        Left = 8
        Top = 58
        Width = 51
        Height = 13
        Caption = 'Auto-kick :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel4: TSpTBXLabel
        Left = 8
        Top = 80
        Width = 54
        Height = 13
        Caption = 'Auto-spec :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object btChooseColor: TSpTBXButton
        Left = 184
        Top = 32
        Width = 25
        Height = 20
        Caption = '...'
        Anchors = [akTop, akRight]
        TabOrder = 5
        OnClick = btChooseColorClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object AutoSpecCheckBox: TSpTBXCheckBox
        Left = 120
        Top = 80
        Width = 14
        Height = 15
        TabOrder = 6
        OnClick = AutoSpecCheckBoxClick
      end
      object AutoKickCheckBox: TSpTBXCheckBox
        Left = 120
        Top = 58
        Width = 14
        Height = 15
        TabOrder = 7
        OnClick = AutoKickCheckBoxClick
      end
      object NotifyOnHostCheckBox: TSpTBXCheckBox
        Left = 120
        Top = 104
        Width = 14
        Height = 15
        TabOrder = 8
        OnClick = NotifyOnHostCheckBoxClick
      end
      object SpTBXLabel5: TSpTBXLabel
        Left = 8
        Top = 104
        Width = 71
        Height = 13
        Caption = 'Notify on host :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel6: TSpTBXLabel
        Left = 8
        Top = 128
        Width = 67
        Height = 13
        Caption = 'Notify on join :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object NotifyOnJoinCheckBox: TSpTBXCheckBox
        Left = 120
        Top = 128
        Width = 14
        Height = 15
        TabOrder = 11
        OnClick = NotifyOnJoinCheckBoxClick
      end
      object NotifyOnBattlEndCheckBox: TSpTBXCheckBox
        Left = 120
        Top = 152
        Width = 14
        Height = 15
        TabOrder = 12
        OnClick = NotifyOnBattlEndCheckBoxClick
      end
      object SpTBXLabel7: TSpTBXLabel
        Left = 8
        Top = 152
        Width = 98
        Height = 13
        Caption = 'Notify on battle end :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel8: TSpTBXLabel
        Left = 8
        Top = 176
        Width = 90
        Height = 13
        Caption = 'Notify on connect :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object NotifyOnConnectCheckBox: TSpTBXCheckBox
        Left = 120
        Top = 176
        Width = 14
        Height = 15
        TabOrder = 15
        OnClick = NotifyOnConnectCheckBoxClick
      end
      object txtName: TSpTBXEdit
        Left = 120
        Top = 10
        Width = 89
        Height = 21
        TabOrder = 16
        OnChange = txtNameChange
      end
      object SpTBXLabel9: TSpTBXLabel
        Left = 8
        Top = 200
        Width = 81
        Height = 13
        Caption = 'Highlight battles :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object HighlightBattlesCheckbox: TSpTBXCheckBox
        Left = 120
        Top = 200
        Width = 14
        Height = 15
        TabOrder = 18
        OnClick = HighlightBattlesCheckboxClick
      end
    end
  end
end
