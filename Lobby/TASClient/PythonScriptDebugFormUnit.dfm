object PythonScriptDebugForm: TPythonScriptDebugForm
  Left = 726
  Top = 521
  Width = 693
  Height = 477
  Caption = 'PythonScriptDebug'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 248
    Width = 685
    Height = 10
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
    Color = clBtnFace
    ParentColor = False
    ResizeStyle = rsUpdate
  end
  object Output: TMemo
    Left = 0
    Top = 25
    Width = 685
    Height = 223
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object pnlTopToolbar: TPanel
    Left = 0
    Top = 0
    Width = 685
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btClear: TButton
      Left = 0
      Top = 0
      Width = 129
      Height = 25
      Caption = '&Clear'
      TabOrder = 0
      OnClick = btClearClick
    end
    object btReloadScripts: TButton
      Left = 136
      Top = 0
      Width = 129
      Height = 25
      Caption = '&Reload'
      TabOrder = 1
      OnClick = btReloadScriptsClick
    end
    object btLoadNewScripts: TButton
      Left = 272
      Top = 0
      Width = 137
      Height = 25
      Caption = '&Load new scripts'
      TabOrder = 2
      OnClick = btLoadNewScriptsClick
    end
  end
  object pnlTestCode: TPanel
    Left = 0
    Top = 258
    Width = 685
    Height = 192
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblTestCode: TLabel
      Left = 0
      Top = 0
      Width = 685
      Height = 16
      Align = alTop
      Caption = 'Test code :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object memCode: TMemo
      Left = 0
      Top = 16
      Width = 685
      Height = 151
      Align = alClient
      Lines.Strings = (
        'import lobbyscript'
        ''
        'api = lobbyscript.Callback()'
        'gui = lobbyscript.GUI()'
        ''
        'print api.GetVersion()')
      TabOrder = 0
    end
    object pnlBottomToolbar: TPanel
      Left = 0
      Top = 167
      Width = 685
      Height = 25
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        685
        25)
      object btExecute: TButton
        Left = 592
        Top = 0
        Width = 89
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&Execute'
        TabOrder = 0
        OnClick = btExecuteClick
      end
    end
  end
end
