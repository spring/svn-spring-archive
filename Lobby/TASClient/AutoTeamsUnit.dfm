object AutoTeamsForm: TAutoTeamsForm
  Left = 508
  Top = 492
  BorderStyle = bsDialog
  Caption = 'Auto-teams settings'
  ClientHeight = 309
  ClientWidth = 591
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
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 591
    Height = 309
    Caption = 'Auto-teams settings'
    Active = False
    Options.Minimize = False
    object SpTBXPanel1: TSpTBXPanel
      Left = 4
      Top = 26
      Width = 583
      Height = 279
      Caption = 'SpTBXPanel1'
      Align = alClient
      TabOrder = 1
      TBXStyleBackground = True
      DesignSize = (
        583
        279)
      object ApplyButton: TSpTBXButton
        Left = 16
        Top = 246
        Width = 75
        Height = 25
        Caption = 'Apply'
        Anchors = [akLeft, akBottom]
        TabOrder = 0
        OnClick = ApplyButtonClick
        Default = True
      end
      object SpTBXGroupBox1: TSpTBXGroupBox
        Left = 8
        Top = 8
        Width = 185
        Height = 145
        Caption = 'Settings'
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
          Top = 64
          Width = 83
          Height = 13
          Caption = 'Number of teams:'
        end
        object SpTBXLabel2: TSpTBXLabel
          Left = 8
          Top = 88
          Width = 113
          Height = 13
          Caption = 'Players per commander:'
        end
        object RandomizeButton: TSpTBXSpeedButton
          Left = 8
          Top = 115
          Width = 169
          Height = 22
          Caption = 'Randomize'
          OnClick = RandomizeButtonClick
        end
        object NumOfAlliesSpin: TSpTBXSpinEdit
          Left = 136
          Top = 64
          Width = 41
          Height = 21
          TabOrder = 4
          SpinButton.Left = 22
          SpinButton.Top = 0
          SpinButton.Width = 15
          SpinButton.Height = 17
          SpinButton.Align = alRight
          SpinOptions.Value = 1.000000000000000000
          OnValueChanged = NumOfAlliesSpinValueChanged
        end
        object PlayersPerCommSpin: TSpTBXSpinEdit
          Left = 136
          Top = 88
          Width = 41
          Height = 21
          TabOrder = 5
          SpinButton.Left = 22
          SpinButton.Top = 0
          SpinButton.Width = 15
          SpinButton.Height = 17
          SpinButton.Align = alRight
          SpinOptions.Value = 1.000000000000000000
          OnValueChanged = PlayersPerCommSpinValueChanged
        end
        object NoNewIdsCheckBox: TSpTBXCheckBox
          Left = 8
          Top = 40
          Width = 90
          Height = 15
          Caption = 'Keep player ids'
          TabOrder = 6
          OnClick = NoNewIdsCheckBoxClick
        end
      end
      object SpTBXPanel3: TSpTBXPanel
        Left = 200
        Top = 14
        Width = 377
        Height = 256
        Caption = 'SpTBXPanel3'
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        TBXStyleBackground = True
        DesignSize = (
          377
          256)
        object SpTBXLabel6: TSpTBXLabel
          Left = 8
          Top = 8
          Width = 41
          Height = 13
          Caption = 'Preview:'
        end
        object ScrollBox1: TScrollBox
          Left = 8
          Top = 24
          Width = 361
          Height = 224
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
      object CancelButton: TSpTBXButton
        Left = 112
        Top = 246
        Width = 75
        Height = 25
        Caption = 'Cancel'
        Anchors = [akLeft, akBottom]
        TabOrder = 3
        OnClick = CancelButtonClick
        Cancel = True
      end
    end
  end
end
