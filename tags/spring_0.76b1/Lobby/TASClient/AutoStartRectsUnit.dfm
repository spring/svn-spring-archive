object AutoStartRectsForm: TAutoStartRectsForm
  Left = 652
  Top = 433
  BorderStyle = bsToolWindow
  Caption = 'Start rectangles options'
  ClientHeight = 255
  ClientWidth = 385
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXPanel1: TSpTBXPanel
    Left = 0
    Top = 0
    Width = 385
    Height = 255
    Caption = 'SpTBXPanel1'
    Align = alClient
    TabOrder = 0
    TBXStyleBackground = True
    object SpTBXGroupBox2: TSpTBXGroupBox
      Left = 8
      Top = 8
      Width = 185
      Height = 193
      Caption = 'Starting positions'
      Color = clNone
      ParentColor = False
      TabOrder = 0
      TBXStyleBackground = True
      object PosTypeComboBox: TSpTBXComboBox
        Left = 48
        Top = 30
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'North vs. south'
        OnChange = PosTypeComboBoxChange
        Items.Strings = (
          'North vs. south'
          'West vs. east')
      end
      object SpTBXLabel3: TSpTBXLabel
        Left = 8
        Top = 32
        Width = 27
        Height = 13
        Caption = 'Type:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel4: TSpTBXLabel
        Left = 8
        Top = 96
        Width = 36
        Height = 13
        Caption = 'Length:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object SpTBXLabel1: TSpTBXLabel
        Left = 8
        Top = 138
        Width = 52
        Height = 13
        Caption = 'Thickness:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
      object LengthTracker: TSpTBXjanTracker
        Left = 6
        Top = 110
        Width = 169
        Height = 25
        ThemeType = thtWindows
        Minimum = 1
        Maximum = 100
        Value = 100
        Orientation = jtbHorizontal
        BackColor = clBtnFace
        BackBorder = False
        TrackColor = clGray
        TrackPositionColor = False
        TrackBorder = True
        BorderColor = clBlack
        ThumbColor = clSilver
        ThumbBorder = False
        ThumbWidth = 30
        ThumbHeight = 16
        TrackHeight = 6
        ShowCaption = True
        CaptionColor = clBlack
        CaptionBold = False
        onChangedValue = LengthTrackerChangedValue
      end
      object ThicknessTracker: TSpTBXjanTracker
        Left = 6
        Top = 152
        Width = 171
        Height = 25
        ThemeType = thtWindows
        Minimum = 1
        Maximum = 100
        Value = 30
        Orientation = jtbHorizontal
        BackColor = clBtnFace
        BackBorder = False
        TrackColor = clGray
        TrackPositionColor = False
        TrackBorder = True
        BorderColor = clBlack
        ThumbColor = clSilver
        ThumbBorder = False
        ThumbWidth = 30
        ThumbHeight = 16
        TrackHeight = 6
        ShowCaption = True
        CaptionColor = clBlack
        CaptionBold = False
        onChangedValue = ThicknessTrackerChangedValue
      end
      object GroupsComboBox: TSpTBXComboBox
        Left = 88
        Top = 58
        Width = 81
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 6
        Text = '2 ally teams'
        OnChange = GroupsComboBoxChange
        Items.Strings = (
          '2 ally teams'
          '4 ally teams')
      end
      object SpTBXLabel2: TSpTBXLabel
        Left = 8
        Top = 60
        Width = 67
        Height = 13
        Caption = 'No. of groups:'
        LinkFont.Charset = DEFAULT_CHARSET
        LinkFont.Color = clBlue
        LinkFont.Height = -11
        LinkFont.Name = 'MS Sans Serif'
        LinkFont.Style = [fsUnderline]
      end
    end
    object SpTBXPanel2: TSpTBXPanel
      Left = 208
      Top = 14
      Width = 169
      Height = 187
      Caption = 'SpTBXPanel2'
      TabOrder = 1
      TBXStyleBackground = True
      object PreviewImage: TImage
        Left = 8
        Top = 24
        Width = 150
        Height = 150
      end
      object SpTBXLabel5: TSpTBXLabel
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
    end
    object CloseButton: TSpTBXButton
      Left = 208
      Top = 216
      Width = 81
      Height = 25
      Caption = 'Close'
      TabOrder = 2
      OnClick = CloseButtonClick
      Cancel = True
      Default = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
    object SpTBXButton1: TSpTBXButton
      Left = 112
      Top = 216
      Width = 81
      Height = 25
      Caption = 'Apply'
      TabOrder = 3
      OnClick = SpTBXButton1Click
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'MS Sans Serif'
      LinkFont.Style = [fsUnderline]
    end
  end
end
