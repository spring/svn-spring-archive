unit DebugUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TDebugForm = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DebugForm: TDebugForm;

implementation

uses
  Unit1, PreferencesFormUnit;

{$R *.dfm}

procedure TDebugForm.Button1Click(Sender: TObject);
begin
  Debug.Enabled := CheckBox1.Checked;
  Debug.FilterPingPong := CheckBox2.Checked;

  Close;
end;

procedure TDebugForm.FormShow(Sender: TObject);
begin
  CheckBox1.Checked := Debug.Enabled;
  CheckBox2.Checked := Debug.FilterPingPong;
end;

procedure TDebugForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TDebugForm.SpeedButton1Click(Sender: TObject);
begin
  PreferencesForm.SpTBXTabControl1.Items[5].Enabled := True;
end;

end.
