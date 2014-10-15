object SetStringsForm: TSetStringsForm
  Left = 192
  Top = 107
  Width = 237
  Height = 225
  Caption = 'SetStringsForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    229
    198)
  PixelsPerInch = 96
  TextHeight = 13
  object StringsMemo: TTntMemo
    Left = 8
    Top = 8
    Width = 209
    Height = 177
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = StringsMemoChange
  end
end
