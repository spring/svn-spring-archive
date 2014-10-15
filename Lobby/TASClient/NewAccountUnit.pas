unit NewAccountUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, StdCtrls, SpTBXEditors, SpTBXItem;

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

    procedure RegisterButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewAccountForm: TNewAccountForm;

implementation

uses PreferencesFormUnit, Misc, gnugettext;

{$R *.dfm}

procedure TNewAccountForm.RegisterButtonClick(Sender: TObject);
begin

  if (UsernameEdit.Text = '') or (PasswordEdit.Text = '') then
  begin
    MessageDlg(_('Username/password should not be blank!'), mtError, [mbOK], 0);
    Exit;
  end;

  if (not VerifyName(UsernameEdit.Text)) or (not VerifyName(PasswordEdit.Text)) then
  begin
    MessageDlg(_('Your username and/or password consists of illegal characters!'), mtWarning, [mbOK], 0);
    Exit;
  end;

  if PasswordEdit.Text <> ConfirmPasswordEdit.Text then
  begin
    MessageDlg(_('Passwords differ! Please retype your password.'), mtWarning, [mbOK], 0);
    PasswordEdit.Text := '';
    ConfirmPasswordEdit.Text := '';
    Exit;
  end;

  ModalResult := mrOK;

end;

procedure TNewAccountForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
