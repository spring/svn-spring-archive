object ChannelsListForm: TChannelsListForm
  Left = 969
  Top = 334
  Width = 724
  Height = 455
  Caption = 'Channels list'
  Color = clBtnFace
  Constraints.MaxHeight = 1150
  Constraints.MaxWidth = 1920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 716
    Height = 428
    Caption = 'Channels list'
    Active = False
    object VDTChannels: TVirtualStringTree
      Left = 0
      Top = 22
      Width = 716
      Height = 406
      Align = alClient
      Header.AutoSizeIndex = 2
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoShowSortGlyphs, hoVisible]
      Header.SortColumn = 0
      Header.Style = hsFlatButtons
      TabOrder = 1
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnCompareNodes = VDTChannelsCompareNodes
      OnDblClick = VDTChannelsDblClick
      OnDrawText = VDTChannelsDrawText
      OnGetText = VDTChannelsGetText
      OnPaintText = VDTChannelsPaintText
      OnHeaderClick = VDTChannelsHeaderClick
      OnHeaderDraw = VDTChannelsHeaderDraw
      Columns = <
        item
          Position = 0
          Width = 150
          WideText = 'Name'
        end
        item
          Position = 1
          WideText = '#Users'
        end
        item
          Position = 2
          Width = 512
          WideText = 'Topic'
        end>
    end
  end
end
