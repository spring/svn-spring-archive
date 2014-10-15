object PageControlHost: TPageControlHost
  Left = 315
  Top = 218
  Width = 396
  Height = 264
  BorderStyle = bsSizeToolWin
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 388
    Height = 237
    Align = alClient
    DockSite = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = PageControlChange
    OnDockDrop = PageControlDockDrop
    OnDrawTab = PageControlDrawTab
    OnGetSiteInfo = PageControlGetSiteInfo
    OnUnDock = PageControlUnDock
  end
  object tmr: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmrTimer
    Left = 16
    Top = 16
  end
  object img: TImageList
    Left = 184
    Top = 128
  end
end
