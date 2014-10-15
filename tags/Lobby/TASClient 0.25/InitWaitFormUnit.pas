{
  We use this form when we wait for unitsync.dll to finish reinitialization or when getting unit
  list, etc.
}
unit InitWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Unit1, Misc, TBXDkPanels, SpTBXControls,
  SpTBXItem;

type
  TInitWaitForm = class(TForm)
    GetUDPPortTimer: TTimer;
    SpTBXTitleBar1: TSpTBXTitleBar;
    InfoLabel: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure OnUDPPortAcquiredMessage(var Msg: TMessage); message WM_UDP_PORT_ACQUIRED;

    procedure ChangeCaption(Caption: string);

    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GetUDPPortTimerTimer(Sender: TObject);
  private
    EnquiryStartTime: Cardinal; // time when we started to send out UDP packets to acquire our UDP source port from server (part of "hole punching" method)
  public
    TakeAction: Byte; // 0 - load mod, 1 - get unit lists, 2 - get host udp port, 3 - Utility.ReInitLib, 4 - reload replay list from disk. With 0, you also have to set ChangeToMod string!
    ChangeToMod: string; // used with MSG_MODCHANGE. Caller of that message must also set ChangeToMod string to appropriate value.
  end;

const
  MSG_MODCHANGE = 'Reading mod file ...';
  MSG_GETUNITS = 'Generating unit list ...';
  MSG_GETHOSTPORT = 'Acquiring UDP host port from server ...';
  MSG_REINITLIB = 'Initializing archive scanner ...';
  MSG_RELOADREPLAYS = 'Reading replay list ...';

var
  InitWaitForm: TInitWaitForm;
  InProgress: Boolean = False;

implementation

uses BattleFormUnit, Utility, HostBattleFormUnit, PreferencesFormUnit,
  ReplaysUnit;

{$R *.dfm}

procedure TInitWaitForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

procedure TInitWaitForm.OnUDPPortAcquiredMessage(var Msg: TMessage); // responds to WM_UDP_PORT_ACQUIRED message
begin
  if not InProgress then Exit;
  if TakeAction <> 2 then Exit;

  // ok close it down and return success:

  NATTraversal.MyPublicUDPSourcePort := Msg.WParam;
  GetUDPPortTimer.Enabled := False;
  InProgress := False;
  InitWaitForm.ModalResult := mrOK;
end;

procedure TInitWaitForm.ChangeCaption(Caption: string);
begin
  InfoLabel.Caption := Caption;
  InfoLabel.Left := InitWaitForm.ClientWidth div 2 - InitWaitForm.Canvas.TextWidth(InfoLabel.Caption) div 2;
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
    ReplaysForm.EnumerateReplayList
  else ; // ?
  //*** showmessage(inttostr(gettickcount - time) + ' ms');

  PostMessage(Handle, WM_CLOSE, 0, 0); // close form

  InProgress := False;
end;

procedure TInitWaitForm.FormCreate(Sender: TObject);
begin
  InitWaitForm.Font.Assign(InfoLabel.Font); // we need this because we call Canvas.GetTextWidth!
end;

procedure TInitWaitForm.GetUDPPortTimerTimer(Sender: TObject);
begin
  if GetTickCount - EnquiryStartTime > 5000 then
  begin
    GetUDPPortTimer.Enabled := False;
    InProgress := False;
    ModalResult := mrCancel;
    Exit;
  end;

  { the first time we will send UDP packet we will use 0 as private source port, but SendUDPStr function will
    change it to the one assigned by the operating system. On any subsequent packets SendUDPStr function will
    not change our private source port anymore. }
  SendUDPStr(MainForm.Socket.Addr, Status.NATHelpServerPort, NATTraversal.MyPrivateUDPSourcePort, Status.Username);
end;

end.
