unit AgreementUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SpTBXControls, SpTBXItem,Misc,
  TntStdCtrls, RichEdit2, ExRichEdit;

type
  TAgreementForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    RadioButton1: TSpTBXRadioButton;
    RadioButton2: TSpTBXRadioButton;
    Button1: TSpTBXButton;
    RichEdit1: TExRichEdit;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AgreementForm: TAgreementForm;

implementation

uses
  PreferencesFormUnit, MainUnit, gnugettext;

var
  UserClickedContinue: Boolean = False;

{$R *.dfm}

procedure TAgreementForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TAgreementForm.Button1Click(Sender: TObject);
begin
  UserClickedContinue := True;
  Close;
end;

procedure TAgreementForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not UserClickedContinue then Action := caNone;

  if RadioButton1.Checked then
  begin
    if (Status.ConnectionState <> Connected) then
    begin
      MainForm.AddMainLog(_('Unable to send Agreement confirmation to server... Retry later!'), Colors.Info);
      Exit;
    end;

    MainForm.TryToSendCommand('CONFIRMAGREEMENT');
    MainForm.TryToLogin(Preferences.Username, Preferences.Password);
  end
  else
  begin
    MainForm.AddMainLog(_('User has rejected the Agreement ... Disconnecting'), Colors.Info);
    MainForm.TryToDisconnect;
    Exit;
  end;
end;

procedure TAgreementForm.FormShow(Sender: TObject);
begin
  UserClickedContinue := False;
  RadioButton2.Checked := True;
  RadioButton2.SetFocus;
end;

procedure TAgreementForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
