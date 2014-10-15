unit WaitForAckUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Unit1;

type
  TWaitForAckForm = class(TForm)
    StatusLabel: TLabel;
    CloseButton: TButton;
    Timer1: TTimer;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure OnCancelHosting(Reason: string);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
  public
    Waiting: Boolean; // True if we are currently waiting for acknowledgement from server
  end;

const
  ACKTIMEOUT = 10; // in seconds

  STATUS_TEXT_WAITING = 'Status: Waiting for acknowledgement from server ...';
  STATUS_TEXT_FAILED = 'Status: Failed. Reason: ';

var
  WaitForAckForm: TWaitForAckForm;

implementation

uses BattleFormUnit, PreferencesFormUnit;

{$R *.dfm}

procedure TWaitForAckForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

procedure TWaitForAckForm.OnCancelHosting(Reason: string);
begin
  if not Waiting then Exit;

  StatusLabel.Caption := STATUS_TEXT_FAILED + Reason;
  Waiting := False;
  Timer1.Enabled := False;
  CloseButton.Caption := 'Close';
end;

procedure TWaitForAckForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled := False;
end;

procedure TWaitForAckForm.FormShow(Sender: TObject);
begin
  Waiting := True;
  CloseButton.Caption := 'Cancel';
  Timer1.Interval := ACKTIMEOUT * 1000; // must be in milliseconds
  Timer1.Enabled := True;
  StatusLabel.Caption := STATUS_TEXT_WAITING;
end;

procedure TWaitForAckForm.Timer1Timer(Sender: TObject);
begin
  (Sender as TTimer).Enabled := False;
  if not Waiting then Exit;
  StatusLabel.Caption := STATUS_TEXT_FAILED + 'Timed out.';
  Waiting := False;
  CloseButton.Caption := 'Close';
end;

procedure TWaitForAckForm.CloseButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
