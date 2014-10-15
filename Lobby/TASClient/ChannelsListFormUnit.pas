unit ChannelsListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, VirtualTrees, class_TIntegerList, PreferencesFormUnit,
  Menus, TB2Item;

type
  TChannelsListForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    VDTChannels: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure VDTChannelsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VDTChannelsCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VDTChannelsDblClick(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure VDTChannelsDrawText(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: WideString; const CellRect: TRect;
      var DefaultDraw: Boolean);
    procedure VDTChannelsHeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure VDTChannelsHeaderDraw(Sender: TVTHeader;
      HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
      Pressed: Boolean; DropMark: TVTDropMarkMode);
    procedure VDTChannelsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
  private
    //nothing
  public
    isRetreiving: Boolean;
    channelsName: TStringList;
    channelsNbUsers: TIntegerList;
    channelsTopics: TStringList;
    channelsNode: TList;

    procedure AddChannel(name: string; topic: string; nbUsers: integer);
    procedure ClearnChannels;
  end;

var
  ChannelsListForm: TChannelsListForm;

implementation

uses Math, MainUnit, gnugettext, Misc;

{$R *.dfm}

procedure TChannelsListForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  channelsName := TStringList.Create;
  channelsNbUsers := TIntegerList.Create;
  channelsTopics := TStringList.Create;
  channelsNode := TList.Create;

  isRetreiving := False;

  FixFormSizeConstraints(self);
end;

procedure TChannelsListForm.AddChannel(name: string; topic: string; nbUsers: integer);
begin
  if not isRetreiving then
  begin
    isRetreiving := True;
    ClearnChannels;
  end;
  channelsName.Add(name);
  channelsNbUsers.Add(nbUsers);
  channelsTopics.Add(topic);
  channelsNode.Add(VDTChannels.AddChild(VDTChannels.RootNode));
end;

procedure TChannelsListForm.ClearnChannels;
begin
  VDTChannels.Clear;
  channelsName.Clear;
  channelsNbUsers.Clear;
  channelsTopics.Clear;
  channelsNode.Clear;
end;

procedure TChannelsListForm.VDTChannelsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  index: integer;
begin
  index := channelsNode.IndexOf(Node);
  if index = -1 then
    Exit;
  case Column of
    0: CellText := channelsName[index];
    1: CellText := IntToStr(channelsNbUsers.Items[index]);
    2: CellText := channelsTopics[index];
  end;
  if CellText = '' then CellText := ' ';
end;

procedure TChannelsListForm.VDTChannelsCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  index1,index2: integer;
begin
  index1 := channelsNode.IndexOf(Node1);
  index2 := channelsNode.IndexOf(Node2);
  if (index1 = -1) or (index2 = -1) then
    Result := CompareValue(index1,index2)
  else
    case Column of
      0: Result := CompareStr(channelsName[index1],channelsName[index2]);
      1: Result := CompareValue(channelsNbUsers.Items[index1],channelsNbUsers.Items[index2]);
      2: Result := CompareStr(channelsTopics[index1],channelsTopics[index2]);
    end;
end;

procedure TChannelsListForm.VDTChannelsDblClick(Sender: TObject);
begin
  if VDTChannels.FocusedNode = nil then Exit;
  MainForm.ProcessCommand('JOIN #'+channelsName[channelsNode.indexOf(VDTChannels.FocusedNode)],False);
end;

procedure TChannelsListForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopwindow;
  end;
end;

procedure TChannelsListForm.VDTChannelsDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: WideString; const CellRect: TRect; var DefaultDraw: Boolean);
begin
  MainForm.FilterListDrawText(Sender,TargetCanvas,Node,Column,Text,CellRect,DefaultDraw);
end;

procedure TChannelsListForm.VDTChannelsHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if VDTChannels.Header.SortColumn = HitInfo.Column then
    if VDTChannels.Header.SortDirection = sdDescending then
      VDTChannels.Header.SortDirection := sdAscending
    else
      VDTChannels.Header.SortDirection := sdDescending
  else
  begin
    VDTChannels.Header.SortColumn := HitInfo.Column;
    VDTChannels.Header.SortDirection := sdAscending
  end;
end;

procedure TChannelsListForm.VDTChannelsHeaderDraw(Sender: TVTHeader;
  HeaderCanvas: TCanvas; Column: TVirtualTreeColumn; R: TRect; Hover,
  Pressed: Boolean; DropMark: TVTDropMarkMode);
begin
  MainForm.VDTBattlesHeaderDraw(Sender,HeaderCanvas,Column,R,Hover,Pressed,DropMark);
end;

procedure TChannelsListForm.VDTChannelsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Style := [];
  inherited;
end;

end.
