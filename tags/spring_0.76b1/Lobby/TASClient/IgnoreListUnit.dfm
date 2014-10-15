object IgnoreListForm: TIgnoreListForm
  Left = 468
  Top = 418
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Ignore list'
  ClientHeight = 383
  ClientWidth = 298
  Color = clBtnFace
  Constraints.MaxHeight = 910
  Constraints.MaxWidth = 1280
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 298
    Height = 383
    Caption = 'Ignore list'
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    TBXStyleBackground = True
    object SpTBXLabel1: TSpTBXLabel
      Left = 24
      Top = 280
      Width = 249
      Height = 49
      Caption = 
        'Note: ignoring a user means filtering out his channel and privat' +
        'e messages, but not his battle window messages'
      AutoSize = False
      Wrapping = twWrap
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object EnableIgnoresCheckBox: TSpTBXCheckBox
      Left = 24
      Top = 48
      Width = 117
      Height = 15
      Caption = 'Enable ignore list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object DoneButton: TSpTBXButton
      Left = 104
      Top = 344
      Width = 89
      Height = 25
      Caption = 'Done'
      TabOrder = 3
      OnClick = DoneButtonClick
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object IgnoreListBox: TSpTBXCheckListBox
      Left = 24
      Top = 88
      Width = 249
      Height = 137
      ItemHeight = 16
      TabOrder = 4
      OnKeyUp = IgnoreListBoxKeyUp
    end
    object AddIgnoreEdit: TSpTBXEdit
      Left = 24
      Top = 232
      Width = 177
      Height = 21
      TabOrder = 5
    end
    object AddButton: TSpTBXSpeedButton
      Left = 200
      Top = 232
      Width = 73
      Height = 22
      Caption = 'Add'
      OnClick = AddButtonClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel2: TSpTBXLabel
      Left = 24
      Top = 256
      Width = 169
      Height = 13
      Caption = '(all names are case-sensitive)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXLabel3: TSpTBXLabel
      Left = 24
      Top = 72
      Width = 215
      Height = 13
      Caption = '(To remove item, select it and press DELETE)'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
