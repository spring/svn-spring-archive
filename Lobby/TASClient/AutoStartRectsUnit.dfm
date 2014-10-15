object AutoStartRectsForm: TAutoStartRectsForm
  Left = 788
  Top = 370
  Width = 393
  Height = 301
  Caption = 'Start rectangles options'
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
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 385
    Height = 274
    Caption = 'Start rectangles options'
    Active = False
    FixedSize = True
    Options.Minimize = False
    Options.Maximize = False
    object SpTBXGroupBox2: TSpTBXGroupBox
      Left = 8
      Top = 32
      Width = 185
      Height = 193
      Caption = 'Starting positions'
      TabOrder = 1
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
      end
      object SpTBXLabel4: TSpTBXLabel
        Left = 8
        Top = 96
        Width = 36
        Height = 13
        Caption = 'Length:'
      end
      object SpTBXLabel1: TSpTBXLabel
        Left = 8
        Top = 138
        Width = 52
        Height = 13
        Caption = 'Thickness:'
      end
      object GroupsComboBox: TSpTBXComboBox
        Left = 88
        Top = 58
        Width = 81
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 4
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
      end
      object LengthTracker: TSpTBXTrackBar
        Left = 80
        Top = 96
        Width = 97
        Height = 25
        Max = 100
        Frequency = 10
        Position = 100
        TabOrder = 6
        ThumbLength = 15
        OnChange = LengthTrackerChange
      end
      object ThicknessTracker: TSpTBXTrackBar
        Left = 80
        Top = 136
        Width = 97
        Height = 25
        Max = 100
        Frequency = 10
        Position = 20
        TabOrder = 7
        ThumbLength = 15
        OnChange = ThicknessTrackerChange
      end
    end
    object SpTBXPanel2: TSpTBXPanel
      Left = 208
      Top = 38
      Width = 169
      Height = 187
      Caption = 'SpTBXPanel2'
      TabOrder = 2
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
      end
    end
    object SpTBXButton1: TSpTBXButton
      Left = 112
      Top = 240
      Width = 81
      Height = 25
      Caption = 'Apply'
      TabOrder = 3
      OnClick = SpTBXButton1Click
    end
    object CloseButton: TSpTBXButton
      Left = 208
      Top = 240
      Width = 81
      Height = 25
      Caption = 'Close'
      TabOrder = 4
      OnClick = CloseButtonClick
      Cancel = True
      Default = True
    end
  end
end
