object AutoTeamsForm: TAutoTeamsForm
  Left = 700
  Top = 446
  Width = 599
  Height = 335
  BorderStyle = bsSizeToolWin
  Caption = 'Auto-teams settings'
  Color = clBtnFace
  Constraints.MinHeight = 228
  Constraints.MinWidth = 448
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
  object SpTBXPanel1: TSpTBXPanel
    Left = 0
    Top = 0
    Width = 591
    Height = 308
    Caption = 'SpTBXPanel1'
    Align = alClient
    TabOrder = 0
    TBXStyleBackground = True
    DesignSize = (
      591
      308)
    object ApplyButton: TSpTBXButton
      Left = 16
      Top = 275
      Width = 75
      Height = 25
      Caption = 'Apply'
      Anchors = [akLeft, akBottom]
      TabOrder = 0
      OnClick = ApplyButtonClick
      Default = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXGroupBox1: TSpTBXGroupBox
      Left = 8
      Top = 8
      Width = 185
      Height = 137
      Caption = 'Settings'
      Color = clNone
      ParentColor = False
      TabOrder = 1
      TBXStyleBackground = True
      object ClansCheckBox: TSpTBXCheckBox
        Left = 8
        Top = 24
        Width = 145
        Height = 15
        Caption = 'Try to team up clan players'
        TabOrder = 0
        OnClick = ClansCheckBoxClick
        Checked = True
        State = cbChecked
      end
      object SpTBXLabel1: TSpTBXLabel
        Left = 8
        Top = 56
        Width = 78
        Height = 13
        Caption = 'Number of allies:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object NumOfAlliesButton: TTBXButton
        Left = 96
        Top = 54
        Width = 41
        Height = 20
        AutoSize = False
        Caption = '2'
        Images = MainForm.MiscImageList
        Layout = blGlyphRight
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        OnClick = NumOfAlliesButtonClick
      end
      object PlayersPerCommButton: TTBXButton
        Left = 128
        Top = 78
        Width = 41
        Height = 20
        AutoSize = False
        Caption = '1'
        Images = MainForm.MiscImageList
        Layout = blGlyphRight
        ParentShowHint = False
        ShowHint = False
        TabOrder = 3
        OnClick = PlayersPerCommButtonClick
      end
      object SpTBXLabel2: TSpTBXLabel
        Left = 8
        Top = 80
        Width = 113
        Height = 13
        Caption = 'Players per commander:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object RandomizeButton: TSpTBXSpeedButton
        Left = 8
        Top = 107
        Width = 169
        Height = 22
        Caption = 'Randomize'
        OnClick = RandomizeButtonClick
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
    end
    object SpTBXPanel3: TSpTBXPanel
      Left = 200
      Top = 14
      Width = 384
      Height = 284
      Caption = 'SpTBXPanel3'
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      TBXStyleBackground = True
      DesignSize = (
        384
        284)
      object SpTBXLabel6: TSpTBXLabel
        Left = 8
        Top = 8
        Width = 41
        Height = 13
        Caption = 'Preview:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object ScrollBox1: TScrollBox
        Left = 8
        Top = 24
        Width = 368
        Height = 252
        HorzScrollBar.Smooth = True
        HorzScrollBar.Tracking = True
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        Color = clCream
        ParentColor = False
        TabOrder = 1
        OnMouseDown = ScrollBox1MouseDown
        OnMouseMove = ScrollBox1MouseMove
        OnMouseUp = ScrollBox1MouseUp
      end
    end
    object AutoApplyCheckBox: TSpTBXCheckBox
      Left = 8
      Top = 227
      Width = 185
      Height = 41
      Caption = 'Automatically apply this configuration on button click'
      Anchors = [akLeft, akBottom]
      AutoSize = False
      TabOrder = 3
      Visible = False
      Wrapping = twWrap
    end
    object CancelButton: TSpTBXButton
      Left = 112
      Top = 275
      Width = 75
      Height = 25
      Caption = 'Cancel'
      Anchors = [akLeft, akBottom]
      TabOrder = 4
      OnClick = CancelButtonClick
      Cancel = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
