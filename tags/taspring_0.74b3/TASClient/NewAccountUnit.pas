unit NewAccountUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, TBXDkPanels, StdCtrls, SpTBXEditors, SpTBXItem;

type
  TNewAccountForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    UsernameEdit: TSpTBXEdit;
    SpTBXLabel1: TSpTBXLabel;
    SpTBXLabel2: TSpTBXLabel;
    PasswordEdit: TSpTBXEdit;
    SpTBXLabel3: TSpTBXLabel;
    ConfirmPasswordEdit: TSpTBXEdit;
    RegisterButton: TSpTBXButton;
    SpTBXButton1: TSpTBXButton;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure RegisterButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewAccountForm: TNewAccountForm;

implementation

uses PreferencesFormUnit, Misc;

{$R *.dfm}

procedure TNewAccountForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TNewAccountForm.RegisterButtonClick(Sender: TObject);
begin

  if (UsernameEdit.Text = '') or (PasswordEdit.Text = '') then
  begin
    MessageDlg('Username/password should not be blank!', mtError, [mbOK], 0);
    Exit;
  end;

  if (not VerifyName(UsernameEdit.Text)) or (not VerifyName(PasswordEdit.Text)) then
  begin
    MessageDlg('Your username and/or password consists of illegal characters!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if PasswordEdit.Text <> ConfirmPasswordEdit.Text then
  begin
    MessageDlg('Passwords differ! Please retype your password.', mtWarning, [mbOK], 0);
    PasswordEdit.Text := '';
    ConfirmPasswordEdit.Text := '';
    Exit;
  end;

  ModalResult := mrOK;

end;

end.
