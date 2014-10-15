object SetValuesForm: TSetValuesForm
  Left = 1059
  Top = 480
  Width = 228
  Height = 239
  Caption = 'SetValuesForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  DesignSize = (
    220
    212)
  PixelsPerInch = 96
  TextHeight = 13
  object SetValues: TValueListEditor
    Left = 8
    Top = 8
    Width = 199
    Height = 191
    Anchors = [akLeft, akTop, akBottom]
    Color = clBtnFace
    DefaultColWidth = 110
    DisplayOptions = [doAutoColResize, doKeyColFixed]
    TabOrder = 0
    OnStringsChange = SetValuesStringsChange
    ColWidths = (
      110
      83)
  end
end
