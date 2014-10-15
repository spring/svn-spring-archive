unit DebugUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TDebugForm = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    TrafficTimer: TTimer;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    DataSentLabel: TLabel;
    DataReceivedLabel: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure TrafficTimerTimer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DebugForm: TDebugForm;

implementation

uses
  MainUnit, PreferencesFormUnit, Misc, PythonScriptDebugFormUnit, gnugettext;

{$R *.dfm}

procedure TDebugForm.Button1Click(Sender: TObject);
begin
  Debug.Enabled := CheckBox1.Checked;
  Debug.FilterPingPong := CheckBox2.Checked;
  Debug.IgnoreVersionIncompatibility := CheckBox3.Checked;
  Debug.LoginWithPasswordOnLan := CheckBox4.Checked;
  Debug.IgnoreRedirects := CheckBox5.Checked;

  Close;
end;

procedure TDebugForm.FormShow(Sender: TObject);
begin
  CheckBox1.Checked := Debug.Enabled;
  CheckBox2.Checked := Debug.FilterPingPong;
  CheckBox3.Checked := Debug.IgnoreVersionIncompatibility;
  CheckBox4.Checked := Debug.LoginWithPasswordOnLan;
  CheckBox5.Checked := Debug.IgnoreRedirects;

  TrafficTimer.Enabled := True;
end;

procedure TDebugForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TDebugForm.FormHide(Sender: TObject);
begin
  TrafficTimer.Enabled := False;
end;

procedure TDebugForm.TrafficTimerTimer(Sender: TObject);
begin
  DataSentLabel.Caption := Misc.FormatFileSize2(Status.CumulativeDataSent);
  DataReceivedLabel.Caption := Misc.FormatFileSize2(Status.CumulativeDataRecv);
end;

procedure TDebugForm.Button3Click(Sender: TObject);
begin
  PythonScriptDebugForm.Show;
end;

procedure TDebugForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
