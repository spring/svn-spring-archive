unit AddNotificationFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAddNotificationForm = class(TForm)
    ComboBox1: TComboBox;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddNotificationForm: TAddNotificationForm;

implementation

uses NotificationsUnit, PreferencesFormUnit;

{$R *.dfm}

procedure TAddNotificationForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopwindow;
  end;
end;

procedure TAddNotificationForm.FormCreate(Sender: TObject);
begin
  ComboBox1.ItemIndex := 0;
end;

procedure TAddNotificationForm.ComboBox1Change(Sender: TObject); // it doesn't get called when we programmatically change ItemIndex property!
begin
  case ComboBox1.ItemIndex of
    Ord(nfJoinedChannel):
    begin
      Label1.Visible := True;
      Edit1.Visible := True;
      Label2.Visible := True;
      Edit2.Visible := True;
    end;

    Ord(nfJoinedBattle):
    begin
      Label1.Visible := False;
      Edit1.Visible := False;
      Label2.Visible := False;
      Edit2.Visible := False;
    end;

    Ord(nfStatusInBattle):
    begin
      Label1.Visible := True;
      Edit1.Visible := True;
      Label2.Visible := False;
      Edit2.Visible := False;
    end;

  end; // end of case

end;

procedure TAddNotificationForm.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAddNotificationForm.Button1Click(Sender: TObject);
begin

  case ComboBox1.ItemIndex of
    Ord(nfJoinedChannel):
    begin
      Label1.Visible := True;
      Edit1.Visible := True;
      Label2.Visible := True;
      Edit2.Visible := True;
      if (Edit2.Text = '') or (Edit2.Text[1] <> '#') then
      begin
        MessageDlg('Invalid channel name. Make sure you use # in front of channel''s name!', mtWarning, [mbOK], 0);
        Exit;
      end;

      if not NotificationsForm.AddNotification(nfJoinedChannel, [Edit1.Text, Edit2.Text]) then
      begin
        MessageDlg('Unable to add notification. Equivalent notification probably already exists.', mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    Ord(nfJoinedBattle):
    begin
      Label1.Visible := False;
      Edit1.Visible := False;
      Label2.Visible := False;
      Edit2.Visible := False;

      if not NotificationsForm.AddNotification(nfJoinedBattle, []) then
      begin
        MessageDlg('Unable to add notification. Equivalent notification probably already exists.', mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    Ord(nfStatusInBattle):
    begin
      Label1.Visible := True;
      Edit1.Visible := True;
      Label2.Visible := False;
      Edit2.Visible := False;

      if not NotificationsForm.AddNotification(nfStatusInBattle, [Edit1.Text]) then
      begin
        MessageDlg('Unable to add notification. Equivalent notification probably already exists.', mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

  end; // end of case

  ModalResult := mrOK;
end;

end.
