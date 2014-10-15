unit MuteListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TMuteListForm = class(TForm)
    MuteListBox: TListBox;
    StatusBar: TStatusBar;
    CloseButton: TButton;
    procedure CreateParams(var Params: TCreateParams); override;
    constructor Create(ChanName: string);
    procedure Reset;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    ChanName: string;
  end;

var
  MuteListForm: TMuteListForm;

implementation

uses PreferencesFormUnit, MainUnit, gnugettext;

{$R *.dfm}

procedure TMuteListForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

constructor TMuteListForm.Create(ChanName: string);
begin
  inherited Create(Application);

  Self.ChanName := ChanName;
  Caption := 'Mute list of #' + ChanName;
  Reset;

  MuteListForms.Add(Self);
end;

procedure TMuteListForm.Reset;
begin
  MuteListBox.Clear;
  StatusBar.SimpleText := _('Receiving mute list ...');
end;

procedure TMuteListForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree; // close and free the form
end;

procedure TMuteListForm.FormDestroy(Sender: TObject);
begin
  MuteListForms.Remove(Self);
end;

procedure TMuteListForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMuteListForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
