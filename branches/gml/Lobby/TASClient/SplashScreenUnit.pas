unit SplashScreenUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg,Math,Misc;

type
  TSplashScreenForm = class(TForm)
    Image1: TImage;
    InfoLabel: TLabel;
    VersionLabel: TLabel;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateText(Text: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashScreenForm: TSplashScreenForm;

implementation

uses PreferencesFormUnit;

{$R *.dfm}

procedure TSplashScreenForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  // detach form from Application and hide Application's taskbar button:

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW or CS_DROPSHADOW;
    WndParent := GetDesktopWindow;
  end;
  if IsWindowsXP or IsWindowsVista then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;

  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong (Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

procedure TSplashScreenForm.UpdateText(Text: string);
begin
  InfoLabel.Caption := 'Progress: ' + Text;
  //InfoLabel.Left := SplashScreenForm.Width div 2 - InfoLabel.Width div 2;
  Update;
end;

end.
