object CustomizeGUIForm: TCustomizeGUIForm
  Left = 1166
  Top = 340
  Width = 712
  Height = 520
  Caption = 'Poweruser window'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = TopMenu
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ControlsPanel: TSpTBXPanel
    Left = 0
    Top = 0
    Width = 272
    Height = 474
    SkinType = sknWindows
    Align = alLeft
    TabOrder = 0
    BorderType = pbrFramed
    object VDTControls: TVirtualStringTree
      Left = 2
      Top = 25
      Width = 268
      Height = 414
      Align = alClient
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
      TabOrder = 0
      OnClick = VDTControlsClick
      OnGetText = VDTControlsGetText
      Columns = <
        item
          Position = 0
          Width = 264
        end>
    end
    object FormsPanel: TSpTBXPanel
      Left = 2
      Top = 2
      Width = 268
      Height = 23
      SkinType = sknWindows
      Align = alTop
      TabOrder = 1
      BorderType = pbrFramed
      object FormSelectionComboBox: TSpTBXComboBox
        Left = 2
        Top = 2
        Width = 167
        Height = 21
        Align = alClient
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = FormSelectionComboBoxChange
        SkinType = sknWindows
      end
      object RefreshFormListButton: TSpTBXButton
        Left = 169
        Top = 2
        Width = 97
        Height = 19
        Caption = 'Refresh'
        Align = alRight
        TabOrder = 1
        OnClick = RefreshFormListButtonClick
        SkinType = sknWindows
      end
    end
    object PickButton: TSpTBXButton
      Left = 2
      Top = 439
      Width = 268
      Height = 33
      Hint = 
        'Push that button then move your mouse cursor to one control in t' +
        'he current form then release the mouse button to select that con' +
        'trol in the list automaticaly.'
      Caption = 'Pick'
      Align = alBottom
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnMouseUp = PickButtonMouseUp
      SkinType = sknWindows
    end
  end
  object VerticalSplitter: TSpTBXSplitter
    Left = 272
    Top = 0
    Width = 9
    Height = 474
    Cursor = crSizeWE
    SkinType = sknWindows
  end
  object PropertiesScrollBox: TTntScrollBox
    Left = 281
    Top = 0
    Width = 423
    Height = 474
    Align = alClient
    BevelInner = bvNone
    BorderStyle = bsNone
    TabOrder = 2
    object PropertiesListEditor: TValueListEditor
      Left = 0
      Top = 0
      Width = 423
      Height = 474
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      DisplayOptions = [doAutoColResize, doKeyColFixed]
      KeyOptions = [keyEdit]
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goThumbTracking]
      ScrollBars = ssVertical
      Strings.Strings = (
        '=')
      TabOrder = 0
      OnEditButtonClick = PropertiesListEditorEditButtonClick
      OnStringsChange = PropertiesListEditorStringsChange
      ColWidths = (
        150
        271)
    end
    object ResizerControl: TStxControlResizer
      Left = 32
      Top = 232
      Width = 28
      Height = 28
      OnControlResize = ResizerControlControlResize
      ResizeObject = roSquare
      StepX = 4
      StepY = 4
      Visible = False
    end
  end
  object SetValuesPopupMenu: TSpTBXFormPopupMenu
    BorderStyle = pbsSizeableBottom
    PopupFocus = True
    SkinType = sknWindows
    OnClosePopup = SetValuesPopupMenuClosePopup
    Left = 49
    Top = 152
  end
  object TopMenu: TMainMenu
    Left = 81
    Top = 152
    object File1: TMenuItem
      Caption = 'File'
      object Profile1: TMenuItem
        Caption = 'Layout Profile'
        object Saveprofile1: TMenuItem
          Caption = 'Save profile'
          OnClick = Saveprofile1Click
        end
        object Save1: TMenuItem
          Caption = 'Save'
          Enabled = False
          OnClick = Save1Click
        end
      end
      object Resetchanges1: TMenuItem
        Caption = 'Reset changes ( Unstable )'
        OnClick = Resetchanges1Click
      end
      object emplateEditor1: TMenuItem
        Caption = 'Template Editor'
        OnClick = emplateEditor1Click
      end
      object ExportChanges1: TMenuItem
        Caption = 'Start recording'
        OnClick = ExportChanges1Click
      end
      object Save2: TMenuItem
        Caption = 'Save'
        Enabled = False
        OnClick = Save2Click
      end
    end
    object Control1: TMenuItem
      Caption = 'Control'
      object Add1: TMenuItem
        Caption = 'Add'
        object Form1: TMenuItem
          Caption = 'Form'
          OnClick = Form1Click
        end
        object DockableForm1: TMenuItem
          Caption = 'Dockable Form'
          OnClick = DockableForm1Click
        end
        object Control2: TMenuItem
          Caption = 'Control'
          OnClick = Control2Click
        end
        object itleBar1: TMenuItem
          Caption = 'TitleBar'
          OnClick = itleBar1Click
        end
        object Panel1: TMenuItem
          Caption = 'Panel'
          OnClick = Panel1Click
        end
        object abs1: TMenuItem
          Caption = 'Tabs'
          OnClick = abs1Click
        end
        object ab1: TMenuItem
          Caption = 'Tab'
          OnClick = ab1Click
        end
        object InputBox1: TMenuItem
          Caption = 'InputBox'
          OnClick = InputBox1Click
        end
        object Label1: TMenuItem
          Caption = 'Label'
          OnClick = Label1Click
        end
        object CheckBox1: TMenuItem
          Caption = 'CheckBox'
          OnClick = CheckBox1Click
        end
        object Radio1: TMenuItem
          Caption = 'RadioButton'
          OnClick = Radio1Click
        end
        object Button1: TMenuItem
          Caption = 'Button'
          OnClick = Button1Click
        end
        object ProgressBar1: TMenuItem
          Caption = 'ProgressBar'
          OnClick = ProgressBar1Click
        end
        object rackBar1: TMenuItem
          Caption = 'TrackBar'
          OnClick = rackBar1Click
        end
        object Splitter1: TMenuItem
          Caption = 'Splitter'
          OnClick = Splitter1Click
        end
        object GroupBox1: TMenuItem
          Caption = 'GroupBox'
          OnClick = GroupBox1Click
        end
        object SpinEdit1: TMenuItem
          Caption = 'SpinEdit'
          OnClick = SpinEdit1Click
        end
        object ComboBox1: TMenuItem
          Caption = 'ComboBox'
          OnClick = ComboBox1Click
        end
        object ListBox1: TMenuItem
          Caption = 'ListBox'
          OnClick = ListBox1Click
        end
        object CheckListBox1: TMenuItem
          Caption = 'CheckListBox'
          OnClick = CheckListBox1Click
        end
        object WebBrowser1: TMenuItem
          Caption = 'WebBrowser'
          OnClick = WebBrowser1Click
        end
        object ScrollBox1: TMenuItem
          Caption = 'ScrollBox'
          OnClick = ScrollBox1Click
        end
        object Image1: TMenuItem
          Caption = 'Image'
          OnClick = Image1Click
        end
        object Image321: TMenuItem
          Caption = 'Image32'
          OnClick = Image321Click
        end
        object Memo1: TMenuItem
          Caption = 'Memo'
          OnClick = Memo1Click
        end
        object Coloreditor1: TMenuItem
          Caption = 'Color edit'
          OnClick = Coloreditor1Click
        end
        object FontComboBox1: TMenuItem
          Caption = 'Font ComboBox'
          OnClick = FontComboBox1Click
        end
        object DockPanel1: TMenuItem
          Caption = 'Dock Panel'
          OnClick = DockPanel1Click
        end
      end
      object Move1: TMenuItem
        Caption = 'Move'
        ShortCut = 16463
        OnClick = Move1Click
      end
      object Delete1: TMenuItem
        Caption = 'Delete'
        ShortCut = 16452
        OnClick = Delete1Click
      end
      object DisplayResizer1: TMenuItem
        AutoCheck = True
        Caption = 'Display Resizer'
        ShortCut = 16466
        OnClick = DisplayResizer1Click
      end
      object Copycontrolpath1: TMenuItem
        Caption = 'Copy control path'
        OnClick = Copycontrolpath1Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.py'
    Filter = 'Python files|*.py'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 361
    Top = 72
  end
  object OpenDialog1: TOpenDialog
    Left = 401
    Top = 72
  end
  object MultiActionPopupMenu: TPopupMenu
    Left = 449
    Top = 176
  end
  object SetStringsPopupMenu: TSpTBXFormPopupMenu
    BorderStyle = pbsSizeableRightBottom
    PopupFocus = True
    SkinType = sknWindows
    Left = 48
    Top = 184
  end
end
