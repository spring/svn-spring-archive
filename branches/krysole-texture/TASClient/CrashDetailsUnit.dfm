object CrashDetailsDialog: TCrashDetailsDialog
  Left = 250
  Top = 283
  BorderStyle = bsDialog
  Caption = 'Enter details'
  ClientHeight = 247
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 297
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 282
    Height = 13
    Caption = 'Enter the details and (if possible) a way to recreate the error:'
  end
  object OKBtn: TButton
    Left = 79
    Top = 212
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 159
    Top = 212
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object RichEdit1: TRichEdit
    Left = 16
    Top = 48
    Width = 281
    Height = 145
    TabOrder = 2
  end
end
