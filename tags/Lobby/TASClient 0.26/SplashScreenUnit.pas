unit SplashScreenUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TSplashScreenForm = class(TForm)
    Image1: TImage;

    procedure CreateParams(var Params: TCreateParams); override;

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

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  // detach form from Application and hide Application's taskbar button:

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;

  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong (Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;


end.
