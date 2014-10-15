object AddBotForm: TAddBotForm
  Left = 627
  Top = 287
  BorderStyle = bsDialog
  Caption = 'Add bot dialog'
  ClientHeight = 246
  ClientWidth = 258
  Color = clBtnFace
  Constraints.MaxHeight = 998
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 258
    Height = 246
    Caption = 'Add bot dialog'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object Label1: TSpTBXLabel
      Left = 16
      Top = 40
      Width = 65
      Height = 13
      Caption = 'Choose AI dll:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object ReloadButton: TSpTBXSpeedButton
      Left = 168
      Top = 56
      Width = 73
      Height = 22
      Caption = 'Reload'
      OnClick = ReloadButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label2: TSpTBXLabel
      Left = 16
      Top = 96
      Width = 55
      Height = 13
      Caption = 'Bot'#39's name:'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object BotTeamColorButton: TSpTBXSpeedButton
      Left = 136
      Top = 160
      Width = 105
      Height = 21
      Caption = 'Team color'
      OnClick = BotTeamColorButtonClick
      Images = MainForm.ConnectionStateImageList
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label3: TSpTBXLabel
      Left = 16
      Top = 136
      Width = 15
      Height = 13
      Caption = 'Id :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Label4: TSpTBXLabel
      Left = 16
      Top = 160
      Width = 33
      Height = 13
      Caption = 'Team :'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object AIComboBox: TSpTBXComboBox
      Left = 16
      Top = 56
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
    end
    object AddBotButton: TSpTBXButton
      Left = 40
      Top = 208
      Width = 75
      Height = 25
      Caption = 'Add bot'
      Enabled = False
      TabOrder = 7
      OnClick = AddBotButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object Button2: TSpTBXButton
      Left = 144
      Top = 208
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 8
      OnClick = Button2Click
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object BotNameEdit: TSpTBXEdit
      Left = 88
      Top = 96
      Width = 113
      Height = 21
      TabOrder = 9
      Text = 'Bot'
    end
    object BotAllyButton: TTBXButton
      Left = 72
      Top = 162
      Width = 41
      Height = 20
      AutoSize = False
      Caption = '1'
      Images = MainForm.MiscImageList
      Layout = blGlyphRight
      ParentShowHint = False
      ShowHint = False
      TabOrder = 10
      OnClick = BotAllyButtonClick
    end
    object BotTeamButton: TTBXButton
      Left = 72
      Top = 138
      Width = 41
      Height = 20
      AutoSize = False
      Caption = '1'
      Images = MainForm.MiscImageList
      Layout = blGlyphRight
      ParentShowHint = False
      ShowHint = False
      TabOrder = 11
      OnClick = BotTeamButtonClick
    end
    object BotSideButton: TSpTBXSpeedButton
      Left = 136
      Top = 136
      Width = 105
      Height = 22
      Caption = 'Side'
      OnClick = BotSideButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
