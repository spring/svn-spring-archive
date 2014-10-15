unit SplashScreenUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg,Math,Misc, IniFiles, TntStdCtrls,gnugettext;

type
  TSplashScreenForm = class(TForm)
    Image1: TImage;
    VersionLabel: TLabel;
    InfoLabel: TTntLabel;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateText(Text: WideString);
    function MsgBox(const Msg: WideString; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashScreenForm: TSplashScreenForm;

implementation

uses PreferencesFormUnit,MainUnit, StrUtils;

{$R *.dfm}

procedure TSplashScreenForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  // detach form from Application and hide Application's taskbar button:

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;// or CS_DROPSHADOW;
    WndParent := GetDesktopWindow;
  end;
  if IsWindowsXP or IsWindowsVista then
    Params.WindowClass.Style := Params.WindowClass.Style;// or CS_DROPSHADOW;

  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong (Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

procedure TSplashScreenForm.UpdateText(Text: WideString);
begin
  InfoLabel.Caption := _('Progress: ') + Text;
  //InfoLabel.Left := SplashScreenForm.Width div 2 - InfoLabel.Width div 2;
  Update;
end;

function TSplashScreenForm.MsgBox(const Msg: WideString; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
  Result := MessageDlg(Msg,DlgType,Buttons,HelpCtx);
end;

procedure TSplashScreenForm.FormShow(Sender: TObject);
begin
  SplashScreenForm.ClientWidth := Image1.Width;
  SplashScreenForm.ClientHeight := Image1.Height;
end;

procedure TSplashScreenForm.FormCreate(Sender: TObject);
begin
  TP_Ignore (self,'VersionLabel');
  TranslateComponent(self);
end;

end.
