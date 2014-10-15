unit HostInfoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SpTBXControls, SpTBXItem;

type
  THostInfoForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    Label1: TSpTBXLabel;
    Label2: TSpTBXLabel;
    Label3: TSpTBXLabel;
    Label4: TSpTBXLabel;
    Label5: TSpTBXLabel;
    Label6: TSpTBXLabel;
    Button1: TSpTBXButton;
    SpTBXLabel1: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure Label3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HostInfoForm: THostInfoForm;

implementation

uses
  MainUnit, PreferencesFormUnit, BattleFormUnit, Misc, gnugettext;

{$R *.dfm}

procedure THostInfoForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure THostInfoForm.Label3Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(_('http://www.portforward.com/routers.htm'));
end;

procedure THostInfoForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure THostInfoForm.Label5Click(Sender: TObject);
begin
  Misc.OpenURLInDefaultBrowser(_('http://taspring.clan-sy.com/wiki/FAQ'));
end;

procedure THostInfoForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
