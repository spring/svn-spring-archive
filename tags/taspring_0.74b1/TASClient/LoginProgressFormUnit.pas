unit LoginProgressFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, TBXDkPanels, SpTBXControls;

type
  TLoginProgressForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    ProgressLabel: TSpTBXLabel;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateCaption(NewCaption: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginProgressForm: TLoginProgressForm;

implementation

uses Unit1, PreferencesFormUnit;

{$R *.dfm}

procedure TLoginProgressForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := MainForm.Handle;
  end;
end;

procedure TLoginProgressForm.UpdateCaption(NewCaption: string);
begin
  ProgressLabel.Caption := NewCaption;
  ProgressLabel.Left := LoginProgressForm.ClientWidth div 2 - ProgressLabel.Width div 2;
  LoginProgressForm.Update;
end;

end.
 