object ColorsPreference: TColorsPreference
  Left = 496
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Color Preferences'
  ClientHeight = 395
  ClientWidth = 490
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 490
    Height = 395
    Caption = 'Colors Preference'
    FixedSize = True
    Options.Maximize = False
    object btOk: TSpTBXButton
      Left = 311
      Top = 360
      Width = 73
      Height = 25
      Caption = 'Ok'
      TabOrder = 1
      OnClick = btOkClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object btRest: TSpTBXButton
      Left = 22
      Top = 360
      Width = 88
      Height = 25
      Caption = 'Reset'
      TabOrder = 2
      OnClick = btRestClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object btCancel: TSpTBXButton
      Left = 397
      Top = 360
      Width = 70
      Height = 25
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = btCancelClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXGroupBox1: TSpTBXGroupBox
      Left = 24
      Top = 40
      Width = 193
      Height = 313
      Caption = 'Chat colors'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      object SpTBXLabel1: TSpTBXLabel
        Left = 16
        Top = 45
        Width = 39
        Height = 13
        Caption = 'Normal :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel0: TPanel
        Left = 101
        Top = 44
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 1
      end
      object SpTBXButton0: TSpTBXButton
        Left = 160
        Top = 44
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 2
        OnClick = SpTBXButton0Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object SpTBXButton1: TSpTBXButton
        Left = 160
        Top = 92
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 3
        OnClick = SpTBXButton1Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object Panel1: TPanel
        Left = 101
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
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel4: TSpTBXLabel
        Left = 16
        Top = 117
        Width = 28
        Height = 13
        Caption = 'Error :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel2: TPanel
        Left = 101
        Top = 115
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 7
      end
      object SpTBXButton2: TSpTBXButton
        Left = 160
        Top = 115
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 8
        OnClick = SpTBXButton2Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object SpTBXButton3: TSpTBXButton
        Left = 160
        Top = 139
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 9
        OnClick = SpTBXButton3Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object Panel3: TPanel
        Left = 101
        Top = 140
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
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel6: TSpTBXLabel
        Left = 16
        Top = 165
        Width = 53
        Height = 13
        Caption = 'Minor Info :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel4: TPanel
        Left = 101
        Top = 162
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 13
      end
      object SpTBXButton4: TSpTBXButton
        Left = 160
        Top = 162
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 14
        OnClick = SpTBXButton4Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object SpTBXButton5: TSpTBXButton
        Left = 160
        Top = 187
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 15
        OnClick = SpTBXButton5Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object Panel5: TPanel
        Left = 101
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
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel8: TSpTBXLabel
        Left = 16
        Top = 213
        Width = 62
        Height = 13
        Caption = 'Channel left :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel6: TPanel
        Left = 101
        Top = 210
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 19
      end
      object SpTBXButton6: TSpTBXButton
        Left = 160
        Top = 210
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 20
        OnClick = SpTBXButton6Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object SpTBXLabel9: TSpTBXLabel
        Left = 16
        Top = 237
        Width = 38
        Height = 13
        Caption = 'MOTD :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel10: TSpTBXLabel
        Left = 16
        Top = 262
        Width = 36
        Height = 13
        Caption = 'SayEx :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel11: TSpTBXLabel
        Left = 16
        Top = 284
        Width = 33
        Height = 13
        Caption = 'Topic :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel7: TPanel
        Left = 101
        Top = 234
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 24
      end
      object SpTBXButton7: TSpTBXButton
        Left = 160
        Top = 234
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 25
        OnClick = SpTBXButton7Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object Panel8: TPanel
        Left = 101
        Top = 258
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 26
      end
      object SpTBXButton8: TSpTBXButton
        Left = 160
        Top = 259
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 27
        OnClick = SpTBXButton8Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object Panel9: TPanel
        Left = 101
        Top = 283
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 28
      end
      object SpTBXButton9: TSpTBXButton
        Left = 160
        Top = 283
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 29
        OnClick = SpTBXButton9Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object SpTBXLabel13: TSpTBXLabel
        Left = 16
        Top = 20
        Width = 40
        Height = 13
        Caption = 'My text :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel13: TPanel
        Left = 101
        Top = 19
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 31
      end
      object SpTBXButton13: TSpTBXButton
        Left = 160
        Top = 19
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 32
        OnClick = SpTBXButton13Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object SpTBXLabel15: TSpTBXLabel
        Left = 16
        Top = 69
        Width = 55
        Height = 13
        Caption = 'Admin text :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel14: TPanel
        Left = 101
        Top = 68
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 34
      end
      object SpTBXButton14: TSpTBXButton
        Left = 160
        Top = 68
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 35
        OnClick = SpTBXButton9Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
    end
    object SpTBXGroupBox2: TSpTBXGroupBox
      Left = 224
      Top = 40
      Width = 241
      Height = 313
      Caption = 'Other colors'
      TabOrder = 5
      object SpTBXButton10: TSpTBXButton
        Left = 208
        Top = 19
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 0
        OnClick = SpTBXButton10Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object Panel10: TPanel
        Left = 149
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
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel12: TSpTBXLabel
        Left = 16
        Top = 44
        Width = 116
        Height = 13
        Caption = 'Map/Mod not available :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel11: TPanel
        Left = 149
        Top = 43
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 4
      end
      object SpTBXButton11: TSpTBXButton
        Left = 208
        Top = 43
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 5
        OnClick = SpTBXButton11Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
      object SpTBXLabel14: TSpTBXLabel
        Left = 16
        Top = 68
        Width = 48
        Height = 13
        Caption = 'Bot color :'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object Panel12: TPanel
        Left = 149
        Top = 67
        Width = 57
        Height = 21
        BevelOuter = bvNone
        BorderStyle = bsSingle
        Color = clBlack
        TabOrder = 7
      end
      object SpTBXButton12: TSpTBXButton
        Left = 208
        Top = 67
        Width = 25
        Height = 20
        Caption = '...'
        TabOrder = 8
        OnClick = SpTBXButton12Click
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
        ThemeType = thtTBX
      end
    end
  end
end
