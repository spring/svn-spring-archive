unit LogonFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, StdCtrls, SpTBXEditors, SpTBXItem;

type
  TLogonForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    gbServerSettings: TSpTBXGroupBox;
    lblServer: TSpTBXLabel;
    txtPort: TSpTBXEdit;
    lblPort: TSpTBXLabel;
    beServer: TSpTBXButtonEdit;
    gbAccountDetails: TSpTBXGroupBox;
    lblLogin: TSpTBXLabel;
    txtLogin: TSpTBXEdit;
    txtPassword: TSpTBXEdit;
    lblPassword: TSpTBXLabel;
    chkRememberPasswords: TSpTBXCheckBox;
    btRegister: TSpTBXButton;
    btLogin: TSpTBXButton;
    chkUseLogonForm: TSpTBXCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure txtPasswordChange(Sender: TObject);
    procedure btRegisterClick(Sender: TObject);
    procedure txtLoginKeyPress(Sender: TObject; var Key: Char);
    procedure txtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure txtPortKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogonForm: TLogonForm;

implementation

uses PreferencesFormUnit,MainUnit, Misc, NewAccountUnit, gnugettext;

{$R *.dfm}

procedure TLogonForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TLogonForm.btLoginClick(Sender: TObject);
begin
  if Status.ReceivingLoginInfo then Exit;

  if (txtLogin.Text = '') or (txtPassword.Text = '') then
  begin
    MessageDlg(_('"Username" and "Password" fields should not be left empty!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if (not VerifyName(txtLogin.Text)) or (not VerifyName(txtPassword.Text) and PasswordChanged) then
  begin
    MessageDlg(_('Your username and/or password consists of illegal characters!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if PasswordChanged then
    txtPassword.Text := Misc.GetMD5Hash(txtPassword.Text);

  Preferences.ServerIP := beServer.Text;
  Preferences.ServerPort := txtPort.Text;
  Preferences.Username := txtLogin.Text;
  Preferences.Password := txtPassword.Text;
  Preferences.RememberPasswords := chkRememberPasswords.Checked;
  Preferences.UseLogonForm := chkUseLogonForm.Checked;

  PreferencesForm.UpdatePreferencesFrom(Preferences);

  if Status.LoggedIn and ((Status.Username <> txtLogin.Text) or (MainForm.Socket.Addr <> beServer.Text) or (MainForm.Socket.Port <> txtPort.Text)) then
  begin
    MainForm.TryToDisconnect;
  end
  else
    if Status.LoggedIn then
    begin
      Close;
      Exit;
    end;

  MainForm.TryToConnect;
  Close;
end;

procedure TLogonForm.FormShow(Sender: TObject);
begin
  PasswordChanged := False;
end;

procedure TLogonForm.txtPasswordChange(Sender: TObject);
begin
  PasswordChanged := True;
end;

procedure TLogonForm.btRegisterClick(Sender: TObject);
begin
  if Status.ConnectionState = Connected then
  begin
    MessageDlg(_('You are not allowed to register new account while being logged-in!'), mtError, [mbOK], 0);
    Exit;
  end;

  NewAccountForm.UsernameEdit.Text := txtLogin.Text;
  NewAccountForm.PasswordEdit.Text := '';
  NewAccountForm.ConfirmPasswordEdit.Text := '';

  if NewAccountForm.ShowModal = mrCancel then Exit;

  // now let's start account registration process:

  txtLogin.Text := NewAccountForm.UsernameEdit.Text;
  txtPassword.Text :=  NewAccountForm.PasswordEdit.Text;

  PasswordChanged := true;
  Status.Registering := True;

  btLoginClick(nil);
end;

procedure TLogonForm.txtLoginKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btLoginClick(nil);
end;

procedure TLogonForm.txtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btLoginClick(nil);
end;

procedure TLogonForm.txtPortKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btLoginClick(nil);
end;

end.
