unit LoginProgressFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, SpTBXControls,Misc,SpTBXSkins;

type
  TLoginProgressForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    pnlMain: TSpTBXPanel;
    ProgressLabel: TSpTBXLabel;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateCaption(NewCaption: string);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginProgressForm: TLoginProgressForm;

implementation

uses MainUnit, PreferencesFormUnit, gnugettext;

{$R *.dfm}

procedure TLoginProgressForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TLoginProgressForm.UpdateCaption(NewCaption: string);
begin
  ProgressLabel.Caption := NewCaption;
  ProgressLabel.Left := LoginProgressForm.ClientWidth div 2 - ProgressLabel.Width div 2;
  LoginProgressForm.Update;
end;

procedure TLoginProgressForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
 