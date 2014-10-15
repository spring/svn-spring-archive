object TemplateEditorForm: TTemplateEditorForm
  Left = 1024
  Top = 142
  Width = 446
  Height = 374
  Caption = 'Template editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 438
    Height = 259
    Align = alClient
    Caption = 'Layout profile template'
    ParentBackground = False
    TabOrder = 0
    object ProfileTemplate: TMemo
      Left = 2
      Top = 79
      Width = 434
      Height = 178
      Align = alClient
      Lines.Strings = (
        'import lobbyscript'
        ''
        'api = lobbyscript.Callback()'
        'gui = lobbyscript.GUI()'
        ''
        'opList = []'
        'newControlList = []'
        ''
        'def addOperationToList(control,property,subprop,oldValue):'
        #9'op = dict()'
        #9'op['#39'Control'#39'] = control'
        #9'op['#39'Property'#39'] = property'
        #9'op['#39'SubProperty'#39'] = subprop'
        #9'op['#39'OldValue'#39'] = oldValue'
        #9'opList.append(op)'
        ''
        'def changeControlProp(control,prop,subProp,value, undo = True):'
        #9'p = gui.GetControlProperties(control,prop)'
        ''
        #9'if undo:'
        #9#9'if subProp == '#39'Align'#39':'
        
          #9#9#9'#  if the align changes we must save the previous pos and siz' +
          'e'
        #9#9#9'addOperationToList(control,prop,'#39'Top'#39',p['#39'Top'#39'])'
        #9#9#9'addOperationToList(control,prop,'#39'Left'#39',p['#39'Left'#39'])'
        #9#9#9'addOperationToList(control,prop,'#39'Width'#39',p['#39'Width'#39'])'
        #9#9#9'addOperationToList(control,prop,'#39'Height'#39',p['#39'Height'#39'])'
        #9#9
        #9#9'addOperationToList(control,prop,subProp,p[subProp])'
        ''
        #9'p[subProp] = value'
        #9'return gui.SetControlProperties(control,prop,p)'
        ''
        'def loadLayout():'
        #9'gui.StackLayoutChanges(True)'
        '${loadProfileContent}'
        #9'gui.StackLayoutChanges(False)'
        #9
        'def unloadLayout():'
        #9'global opList'
        #9'global newControlList'
        #9
        #9'for i in range(len(opList)):'
        #9#9'op = opList.pop()'
        
          #9#9'changeControlProp(op['#39'Control'#39'],op['#39'Property'#39'],op['#39'SubProperty' +
          #39'],op['#39'OldValue'#39'],False)'
        #9
        #9'for controlName in newControlList:'
        #9#9'gui.DeleteControl(controlName)'
        ''
        '${unloadProfileContent}'
        #9
        #9'opList = []'
        #9'newControlList = []')
      ScrollBars = ssHorizontal
      TabOrder = 0
      WordWrap = False
    end
    object LayoutPropertyChange: TMemo
      Left = 2
      Top = 15
      Width = 434
      Height = 64
      Align = alTop
      Lines.Strings = (
        #9'changeControlProp("$control","$subprop","$propname",$newvalue)')
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 259
    Width = 438
    Height = 88
    Align = alBottom
    Caption = 'Record template'
    ParentBackground = False
    TabOrder = 1
    object RecordPropertyChange: TMemo
      Left = 2
      Top = 15
      Width = 434
      Height = 66
      Align = alTop
      Lines.Strings = (
        
          #9'gui.SetControlProperties ('#39'$control'#39', '#39'$subprop'#39', {'#39'$propname'#39':' +
          '$newvalue})')
      TabOrder = 0
    end
  end
end
