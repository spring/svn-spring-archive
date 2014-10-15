unit WaitForAckUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MainUnit, SpTBXControls, SpTBXItem,SpTBXSkins;

type
  TWaitForAckForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    Timer1: TTimer;
    pnlMain: TSpTBXPanel;
    StatusLabel: TSpTBXLabel;
    CloseButton: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure OnCancelHosting(Reason: string);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    Waiting: Boolean; // True if we are currently waiting for acknowledgement from server
  end;

const
  ACKTIMEOUT = 10; // in seconds

var
  WaitForAckForm: TWaitForAckForm;

resourcestring
  STATUS_TEXT_WAITING = 'Status: Waiting for acknowledgement from server ...';
  STATUS_TEXT_FAILED = 'Status: Failed. Reason: ';

implementation

uses BattleFormUnit, PreferencesFormUnit, LobbyScriptUnit, gnugettext, Misc;

{$R *.dfm}

procedure TWaitForAckForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TWaitForAckForm.OnCancelHosting(Reason: string);
begin
  if not Waiting then Exit;

  StatusLabel.Caption := STATUS_TEXT_FAILED + Reason;
  Waiting := False;
  Timer1.Enabled := False;
  CloseButton.Caption := _('Close');

  if LobbyScriptUnit.ScriptHostingRunning  then ModalResult := mrCancel;
end;

procedure TWaitForAckForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled := False;
end;

procedure TWaitForAckForm.FormShow(Sender: TObject);
begin
  Waiting := True;
  CloseButton.Caption := _('Cancel');
  Timer1.Interval := ACKTIMEOUT * 1000; // must be in milliseconds
  Timer1.Enabled := True;
  StatusLabel.Caption := STATUS_TEXT_WAITING;
end;

procedure TWaitForAckForm.Timer1Timer(Sender: TObject);
begin
  (Sender as TTimer).Enabled := False;
  if not Waiting then Exit;
  StatusLabel.Caption := STATUS_TEXT_FAILED + _('Timed out.');
  Waiting := False;
  CloseButton.Caption := _('Close');
end;

procedure TWaitForAckForm.CloseButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TWaitForAckForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
