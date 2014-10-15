object SpringSettingsProfileForm: TSpringSettingsProfileForm
  Left = 489
  Top = 110
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Spring settings profiles'
  ClientHeight = 435
  ClientWidth = 398
  Color = clBtnFace
  Constraints.MaxHeight = 1000
  Constraints.MaxWidth = 1680
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 398
    Height = 435
    Caption = 'Spring settings profiles'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object gbPlaying: TSpTBXGroupBox
      Left = 16
      Top = 64
      Width = 369
      Height = 41
      Caption = 'Playing profile '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      TBXStyleBackground = True
      object bePlaying: TSpTBXButtonEdit
        Left = 8
        Top = 16
        Width = 353
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        EditButton.Left = 329
        EditButton.Top = 0
        EditButton.Width = 20
        EditButton.Height = 17
        EditButton.Caption = '...'
        EditButton.Align = alRight
        EditButton.OnClick = bePlayingSubEditButton0Click
      end
    end
    object SpTBXLabel1: TSpTBXLabel
      Left = 16
      Top = 40
      Width = 369
      Height = 17
      Caption = 'Pick a Spring Settings file to use according to the situation :'
      AutoSize = False
      Wrapping = twWrap
    end
    object gbSpectator: TSpTBXGroupBox
      Left = 16
      Top = 112
      Width = 369
      Height = 41
      Caption = 'Spectator profile'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      TBXStyleBackground = True
      object beSpectator: TSpTBXButtonEdit
        Left = 8
        Top = 16
        Width = 353
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        EditButton.Left = 329
        EditButton.Top = 0
        EditButton.Width = 20
        EditButton.Height = 17
        EditButton.Caption = '...'
        EditButton.Align = alRight
        EditButton.OnClick = beSpectatorSubEditButton0Click
      end
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 16
      Top = 160
      Width = 172
      Height = 13
      Caption = '(leave empty to use the default one )'
    end
    object CustomGroupBox: TSpTBXGroupBox
      Left = 16
      Top = 184
      Width = 369
      Height = 161
      Caption = 'Custom profiles'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      TBXStyleBackground = True
      object lstCustom: TSpTBXListBox
        Left = 8
        Top = 40
        Width = 353
        Height = 113
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 0
      end
      object btAdd: TSpTBXButton
        Left = 96
        Top = 16
        Width = 89
        Height = 25
        Caption = 'Add'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btAddClick
      end
      object btEdit: TSpTBXButton
        Left = 184
        Top = 16
        Width = 89
        Height = 25
        Caption = 'Edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btEditClick
      end
      object btDelete: TSpTBXButton
        Left = 272
        Top = 16
        Width = 89
        Height = 25
        Caption = 'Delete'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btDeleteClick
      end
    end
    object btClose: TSpTBXButton
      Left = 155
      Top = 400
      Width = 89
      Height = 25
      Caption = 'Close'
      TabOrder = 6
      OnClick = btCloseClick
    end
    object gbCustomExe: TSpTBXGroupBox
      Left = 16
      Top = 352
      Width = 369
      Height = 41
      Caption = 'Custom Spring Executable'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      TBXStyleBackground = True
      object beCustomSpringExe: TSpTBXButtonEdit
        Left = 8
        Top = 16
        Width = 353
        Height = 21
        TabOrder = 0
        EditButton.Left = 330
        EditButton.Top = 0
        EditButton.Width = 19
        EditButton.Height = 17
        EditButton.Caption = '...'
        EditButton.Align = alRight
        EditButton.OnClick = beCustomSpringExeSubEditButton0Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'cfg'
    Filter = 'Spring settings file|*.cfg'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 240
    Top = 160
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'Spring exe'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 272
    Top = 160
  end
end
