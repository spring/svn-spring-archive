object ColorsPreference: TColorsPreference
  Left = 1155
  Top = 606
  Width = 650
  Height = 465
  Caption = 'Color Preferences'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 634
    Height = 427
    Caption = 'Colors and Font Preference'
    Active = False
    FixedSize = True
    Options.Maximize = False
    object btOk: TSpTBXButton
      Left = 440
      Top = 392
      Width = 88
      Height = 25
      Caption = 'Ok'
      TabOrder = 1
      OnClick = btOkClick
    end
    object btRest: TSpTBXButton
      Left = 22
      Top = 392
      Width = 107
      Height = 25
      Caption = 'Reset'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      DropDownMenu = ResetColorsPopupMenu
    end
    object btCancel: TSpTBXButton
      Left = 531
      Top = 392
      Width = 88
      Height = 25
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = btCancelClick
    end
    object SpTBXGroupBox1: TSpTBXGroupBox
      Left = 24
      Top = 40
      Width = 265
      Height = 337
      Caption = 'Chat colors'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      TBXStyleBackground = True
      object SpTBXLabel1: TSpTBXLabel
        Left = 16
        Top = 45
        Width = 39
        Height = 13
        Caption = 'Normal :'
      end
      object Panel0: TPanel
        Left = 173
        Top = 44
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 1
      end
      object SpTBXButton0: TSpTBXButton
        Left = 232
        Top = 44
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 2
        OnClick = SpTBXButton0Click
      end
      object SpTBXButton1: TSpTBXButton
        Left = 232
        Top = 92
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 3
        OnClick = SpTBXButton1Click
      end
      object Panel1: TPanel
        Left = 173
        Top = 92
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 4
      end
      object SpTBXLabel3: TSpTBXLabel
        Left = 16
        Top = 93
        Width = 29
        Height = 13
        Caption = 'Data :'
      end
      object SpTBXLabel4: TSpTBXLabel
        Left = 16
        Top = 117
        Width = 28
        Height = 13
        Caption = 'Error :'
      end
      object Panel2: TPanel
        Left = 173
        Top = 115
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 7
      end
      object SpTBXButton2: TSpTBXButton
        Left = 232
        Top = 115
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 8
        OnClick = SpTBXButton2Click
      end
      object SpTBXButton3: TSpTBXButton
        Left = 232
        Top = 139
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 9
        OnClick = SpTBXButton3Click
      end
      object Panel3: TPanel
        Left = 173
        Top = 138
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 10
      end
      object SpTBXLabel5: TSpTBXLabel
        Left = 16
        Top = 140
        Width = 24
        Height = 13
        Caption = 'Info :'
      end
      object SpTBXLabel6: TSpTBXLabel
        Left = 16
        Top = 165
        Width = 53
        Height = 13
        Caption = 'Minor Info :'
      end
      object Panel4: TPanel
        Left = 173
        Top = 162
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 13
      end
      object SpTBXButton4: TSpTBXButton
        Left = 232
        Top = 162
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 14
        OnClick = SpTBXButton4Click
      end
      object SpTBXButton5: TSpTBXButton
        Left = 232
        Top = 187
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 15
        OnClick = SpTBXButton5Click
      end
      object Panel5: TPanel
        Left = 173
        Top = 186
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 16
      end
      object SpTBXLabel7: TSpTBXLabel
        Left = 16
        Top = 189
        Width = 64
        Height = 13
        Caption = 'Channel join :'
      end
      object SpTBXLabel8: TSpTBXLabel
        Left = 16
        Top = 213
        Width = 62
        Height = 13
        Caption = 'Channel left :'
      end
      object Panel6: TPanel
        Left = 173
        Top = 210
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 19
      end
      object SpTBXButton6: TSpTBXButton
        Left = 232
        Top = 210
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 20
        OnClick = SpTBXButton6Click
      end
      object SpTBXLabel9: TSpTBXLabel
        Left = 16
        Top = 237
        Width = 38
        Height = 13
        Caption = 'MOTD :'
      end
      object SpTBXLabel10: TSpTBXLabel
        Left = 16
        Top = 262
        Width = 36
        Height = 13
        Caption = 'SayEx :'
      end
      object SpTBXLabel11: TSpTBXLabel
        Left = 16
        Top = 284
        Width = 33
        Height = 13
        Caption = 'Topic :'
      end
      object Panel7: TPanel
        Left = 173
        Top = 234
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 24
      end
      object SpTBXButton7: TSpTBXButton
        Left = 232
        Top = 234
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 25
        OnClick = SpTBXButton7Click
      end
      object Panel8: TPanel
        Left = 173
        Top = 258
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 26
      end
      object SpTBXButton8: TSpTBXButton
        Left = 232
        Top = 259
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 27
        OnClick = SpTBXButton8Click
      end
      object Panel9: TPanel
        Left = 173
        Top = 283
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 28
      end
      object SpTBXButton9: TSpTBXButton
        Left = 232
        Top = 283
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 29
        OnClick = SpTBXButton9Click
      end
      object SpTBXLabel13: TSpTBXLabel
        Left = 16
        Top = 20
        Width = 40
        Height = 13
        Caption = 'My text :'
      end
      object Panel13: TPanel
        Left = 173
        Top = 19
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 31
      end
      object SpTBXButton13: TSpTBXButton
        Left = 232
        Top = 19
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 32
        OnClick = SpTBXButton13Click
      end
      object SpTBXLabel15: TSpTBXLabel
        Left = 16
        Top = 69
        Width = 55
        Height = 13
        Caption = 'Admin text :'
      end
      object Panel14: TPanel
        Left = 173
        Top = 68
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 34
      end
      object SpTBXButton14: TSpTBXButton
        Left = 232
        Top = 68
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 35
        OnClick = SpTBXButton14Click
      end
      object SpTBXLabel16: TSpTBXLabel
        Left = 16
        Top = 308
        Width = 72
        Height = 13
        Caption = 'Old messages :'
      end
      object Panel15: TPanel
        Left = 173
        Top = 307
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 37
      end
      object SpTBXButton16: TSpTBXButton
        Left = 232
        Top = 307
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 38
        OnClick = SpTBXButton16Click
      end
    end
    object SpTBXGroupBox2: TSpTBXGroupBox
      Left = 296
      Top = 40
      Width = 321
      Height = 281
      Caption = 'Other colors'
      TabOrder = 5
      TBXStyleBackground = True
      object SpTBXButton10: TSpTBXButton
        Left = 288
        Top = 19
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 0
        OnClick = SpTBXButton10Click
      end
      object Panel10: TPanel
        Left = 229
        Top = 19
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 1
      end
      object SpTBXLabel2: TSpTBXLabel
        Left = 16
        Top = 20
        Width = 63
        Height = 13
        Caption = 'Away player :'
      end
      object SpTBXLabel12: TSpTBXLabel
        Left = 16
        Top = 44
        Width = 116
        Height = 13
        Caption = 'Map/Mod not available :'
      end
      object Panel11: TPanel
        Left = 229
        Top = 43
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 4
      end
      object SpTBXButton11: TSpTBXButton
        Left = 288
        Top = 43
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 5
        OnClick = SpTBXButton11Click
      end
      object SpTBXLabel14: TSpTBXLabel
        Left = 16
        Top = 68
        Width = 48
        Height = 13
        Caption = 'Bot color :'
      end
      object Panel12: TPanel
        Left = 229
        Top = 67
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 7
      end
      object SpTBXButton12: TSpTBXButton
        Left = 288
        Top = 67
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 8
        OnClick = SpTBXButton12Click
      end
      object SpTBXLabel17: TSpTBXLabel
        Left = 16
        Top = 92
        Width = 148
        Height = 13
        Caption = 'Battle details non default color :'
      end
      object Panel16: TPanel
        Left = 229
        Top = 91
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 10
      end
      object SpTBXButton17: TSpTBXButton
        Left = 288
        Top = 91
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 11
        OnClick = SpTBXButton17Click
      end
      object SpTBXLabel18: TSpTBXLabel
        Left = 16
        Top = 116
        Width = 114
        Height = 13
        Caption = 'Battle details changed  :'
      end
      object Panel17: TPanel
        Left = 229
        Top = 115
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 13
      end
      object SpTBXButton18: TSpTBXButton
        Left = 288
        Top = 115
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 14
        OnClick = SpTBXButton18Click
      end
      object SpTBXLabel19: TSpTBXLabel
        Left = 16
        Top = 140
        Width = 75
        Height = 13
        Caption = 'Ingame player  :'
      end
      object Panel18: TPanel
        Left = 229
        Top = 139
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 16
      end
      object SpTBXButton19: TSpTBXButton
        Left = 288
        Top = 139
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 17
        OnClick = SpTBXButton19Click
      end
      object SpTBXLabel20: TSpTBXLabel
        Left = 16
        Top = 164
        Width = 104
        Height = 13
        Caption = 'Replay winning team :'
      end
      object Panel19: TPanel
        Left = 229
        Top = 163
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 19
      end
      object SpTBXButton20: TSpTBXButton
        Left = 288
        Top = 163
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 20
        OnClick = SpTBXButton20Click
      end
      object Panel20: TPanel
        Left = 229
        Top = 259
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 21
      end
      object SpTBXButton21: TSpTBXButton
        Left = 288
        Top = 259
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 22
        OnClick = SpTBXButton21Click
      end
      object SpTBXLabel21: TSpTBXLabel
        Left = 16
        Top = 260
        Width = 153
        Height = 13
        Caption = 'TrueSkill Very High Uncertainty :'
      end
      object Panel21: TPanel
        Left = 229
        Top = 235
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 24
      end
      object SpTBXButton22: TSpTBXButton
        Left = 288
        Top = 235
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 25
        OnClick = SpTBXButton22Click
      end
      object SpTBXLabel22: TSpTBXLabel
        Left = 16
        Top = 236
        Width = 129
        Height = 13
        Caption = 'TrueSkill High Uncertainty :'
      end
      object SpTBXLabel23: TSpTBXLabel
        Left = 16
        Top = 212
        Width = 150
        Height = 13
        Caption = 'TrueSkill Average Uncertainty  :'
      end
      object Panel22: TPanel
        Left = 229
        Top = 211
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 28
      end
      object SpTBXButton23: TSpTBXButton
        Left = 288
        Top = 211
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 29
        OnClick = SpTBXButton23Click
      end
      object SpTBXButton24: TSpTBXButton
        Left = 288
        Top = 187
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 30
        OnClick = SpTBXButton24Click
      end
      object Panel23: TPanel
        Left = 229
        Top = 187
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 31
      end
      object SpTBXLabel24: TSpTBXLabel
        Left = 16
        Top = 188
        Width = 127
        Height = 13
        Caption = 'TrueSkill Low Uncertainty :'
      end
    end
    object SpTBXGroupBox3: TSpTBXGroupBox
      Left = 296
      Top = 328
      Width = 321
      Height = 49
      Caption = 'Chat font'
      TabOrder = 6
      TBXStyleBackground = True
      object lblFontName: TSpTBXLabel
        Left = 8
        Top = 24
        Width = 59
        Height = 13
        Caption = 'lblFontName'
      end
      object SpTBXButton15: TSpTBXButton
        Left = 280
        Top = 16
        Width = 33
        Height = 25
        Caption = '...'
        TabOrder = 1
        OnClick = SpTBXButton15Click
      end
    end
    object btLoad: TSpTBXButton
      Left = 136
      Top = 392
      Width = 97
      Height = 25
      Caption = 'Load'
      TabOrder = 7
      OnClick = btLoadClick
    end
    object btSave: TSpTBXButton
      Left = 240
      Top = 392
      Width = 97
      Height = 25
      Caption = 'Save'
      TabOrder = 8
      OnClick = btSaveClick
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 384
    Top = 344
  end
  object OpenDialog1: TOpenDialog
    Left = 168
    Top = 368
  end
  object SaveDialog1: TSaveDialog
    Left = 272
    Top = 368
  end
  object ResetColorsPopupMenu: TSpTBXPopupMenu
    Left = 8
    Top = 400
    object SpTBXItem2: TSpTBXItem
      Caption = 'Reset to default dark skin colors'
      OnClick = SpTBXItem2Click
    end
    object SpTBXItem1: TSpTBXItem
      Caption = 'Reset to default light skin colors'
      OnClick = SpTBXItem1Click
    end
  end
end
