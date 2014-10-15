{
  We use this form when we wait for unitsync.dll to finish reinitialization or when getting unit
  list, etc.
}
unit InitWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MainUnit, Misc, SpTBXControls,SpTBXSkins,
  SpTBXItem,gnugettext;

type
  TInitWaitForm = class(TForm)
    GetUDPPortTimer: TTimer;
    SpTBXTitleBar1: TSpTBXTitleBar;
    pnlMain: TSpTBXPanel;
    InfoLabel: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure OnUDPPortAcquiredMessage(var Msg: TMessage); message WM_UDP_PORT_ACQUIRED;
    procedure WMLoadNextMinimap(var Msg: TMessage); message WM_LOAD_NEXT_MINIMAP;

    procedure ChangeCaption(Caption: string);
    procedure CloseInitWaitForm(ModalResult: TModalResult);

    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GetUDPPortTimerTimer(Sender: TObject);
  private
    EnquiryStartTime: Cardinal; // time when we started to send out UDP packets to acquire our UDP source port from server (part of "hole punching" method)
  public
    TakeAction: Byte; // 0 - load mod, 1 - get unit lists, 2 - get host udp port, 3 - Utility.ReInitLib, 4 - reload replay list from disk, 5 - reload map list, 6 - load missing minimaps in MapListForm, 7 - receiving login info. With 0, you also have to set ChangeToMod string!
    ChangeToMod: string; // used with MSG_MODCHANGE. Caller of that message must also set ChangeToMod string to appropriate value.
  end;

var
  InitWaitForm: TInitWaitForm;
  InProgress: Boolean = False;
  MSG_MODCHANGE: string = 'Reading mod file ...';
  MSG_GETUNITS: string = 'Generating unit list ...';
  MSG_GETHOSTPORT: string = 'Acquiring UDP host port from server ...';
  MSG_REINITLIB: string = 'Initializing archive scanner ...';
  MSG_RELOADREPLAYS: string = 'Reading replay list ...';
  MSG_RELOADMAPLIST: string = 'Reloading map list ...';

implementation

uses BattleFormUnit, Utility, HostBattleFormUnit, PreferencesFormUnit,
  ReplaysUnit, MapListFormUnit;

{$R *.dfm}

procedure TInitWaitForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TInitWaitForm.OnUDPPortAcquiredMessage(var Msg: TMessage); // responds to WM_UDP_PORT_ACQUIRED message
begin
  if not InProgress then Exit;
  if TakeAction <> 2 then Exit;

  // ok close it down and return success:

  NATTraversal.MyPublicUDPSourcePort := Msg.WParam;
  GetUDPPortTimer.Enabled := False;

  CloseInitWaitForm(mrOK);
end;

procedure TInitWaitForm.WMLoadNextMinimap(var Msg: TMessage); // responds to WM_LOAD_NEXT_MINIMAP
var
  i: Integer;
begin
  if not InProgress then Exit;
  if TakeAction <> 6 then Exit;

  for i := 0 to MapListForm.Maps.Count-1 do
    if not GetMapItem(i).MapImageLoaded then
    begin
      ChangeCaption('Loading minimap for ' + GetMapItem(i).MapName + ' ...');
      InitWaitForm.Repaint;
      GetMapItem(i).LoadMinimap(False);
      PostMessage(InitWaitForm.Handle, WM_LOAD_NEXT_MINIMAP, 0, 0);
      Exit;
    end;

  // ok we are finished:
  CloseInitWaitForm(mrOK);
end;

procedure TInitWaitForm.ChangeCaption(Caption: string);
begin
  InfoLabel.Caption := Caption;
  if InfoLabel.Width > InitWaitForm.Width then InitWaitForm.Width := InfoLabel.Width + 10;
  InfoLabel.Left := InitWaitForm.ClientWidth div 2 - InitWaitForm.Canvas.TextWidth(InfoLabel.Caption) div 2;
end;

procedure TInitWaitForm.CloseInitWaitForm(ModalResult: TModalResult);
begin
  InProgress := False;
  InitWaitForm.ModalResult := ModalResult;
end;

procedure TInitWaitForm.FormActivate(Sender: TObject);
var
  time: cardinal;
begin
  if InProgress then Exit;

  InProgress := True;

  InitWaitForm.Repaint;

  time := gettickcount;
  if TakeAction = 0 then
    BattleForm.ChangeCurrentMod(ChangeToMod)
  else if TakeAction = 1 then
    ReloadUnitList
  else if TakeAction = 2 then
  begin
    NATTraversal.MyPrivateUDPSourcePort := 0;
    EnquiryStartTime := GetTickCount;
    GetUDPPortTimer.Interval := 500;
    GetUDPPortTimer.Enabled := True;
    Exit; // exit from this method and wait for WM_UDP_PORT_ACQUIRED
  end
  else if TakeAction = 3 then
    Utility.ReInitLib
  else if TakeAction = 4 then
  begin
    ReplaysForm.InitVDTForRefresh;
    ReplaysForm.EnumerateReplayList;
    ReplaysForm.TerminateVDTRefresh;
  end
  else if TakeAction = 5 then
    Utility.ReloadMapList(False)
  else if TakeAction = 6 then
  begin
    PostMessage(InitWaitForm.Handle, WM_LOAD_NEXT_MINIMAP, 0, 0);
    Exit; // exit from this method and respond to WM_LOAD_NEXT_MINIMAP
  end
  else ; // ?
  //*** showmessage(inttostr(gettickcount - time) + ' ms');

  MainForm.PrintUnitsyncErrors;

  PostMessage(Handle, WM_CLOSE, 0, 0); // close form

  InProgress := False;
end;

procedure TInitWaitForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  MSG_MODCHANGE := _('Reading mod file ...');
  MSG_GETUNITS := _('Generating unit list ...');
  MSG_GETHOSTPORT := _('Acquiring UDP host port from server ...');
  MSG_REINITLIB := _('Initializing archive scanner ...');
  MSG_RELOADREPLAYS := _('Reading replay list ...');
  MSG_RELOADMAPLIST := _('Reloading map list ...');
    
  InitWaitForm.Font.Assign(InfoLabel.Font); // we need this because we call Canvas.GetTextWidth!
end;

procedure TInitWaitForm.GetUDPPortTimerTimer(Sender: TObject);
begin
  if GetTickCount - EnquiryStartTime > 5000 then
  begin
    GetUDPPortTimer.Enabled := False;
    CloseInitWaitForm(mrCancel);
    Exit;
  end;

  { the first time we will send UDP packet we will use 0 as private source port, but SendUDPStr function will
    change it to the one assigned by the operating system. On any subsequent packets SendUDPStr function will
    not change our private source port anymore. }
  SendUDPStr(MainForm.Socket.Addr, Status.NATHelpServerPort, NATTraversal.MyPrivateUDPSourcePort, Status.Username);
end;

end.
