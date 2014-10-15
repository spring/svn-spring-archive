unit AddNotificationFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SpTBXControls, SpTBXEditors, TntStdCtrls,
  SpTBXItem,Misc;

type
  TAddNotificationForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    NotifsComboBox: TSpTBXComboBox;
    Edit1: TSpTBXEdit;
    Edit2: TSpTBXEdit;
    AddButton: TSpTBXButton;
    CancelButton: TSpTBXButton;
    SpTBXLabel1: TSpTBXLabel;
    FieldLabel1: TSpTBXLabel;
    FieldLabel2: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormCreate(Sender: TObject);
    procedure NotifsComboBoxChange(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddNotificationForm: TAddNotificationForm;

implementation

uses NotificationsUnit, PreferencesFormUnit, gnugettext;

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
  TranslateComponent(self);

  NotifsComboBox.ItemIndex := 0;
end;

procedure TAddNotificationForm.NotifsComboBoxChange(Sender: TObject); // it doesn't get called when we programmatically change ItemIndex property!
begin
  case NotifsComboBox.ItemIndex of
    Ord(nfJoinedChannel):
    begin
      FieldLabel1.Caption := 'Player';
      FieldLabel1.Visible := True;
      Edit1.Text := 'player';
      Edit1.Visible := True;
      FieldLabel2.Caption := 'Channel';
      FieldLabel2.Visible := True;
      Edit2.Text := '#main';
      Edit2.Visible := True;
    end;

    Ord(nfJoinedBattle):
    begin
      FieldLabel1.Visible := False;
      Edit1.Visible := False;
      FieldLabel2.Visible := False;
      Edit2.Visible := False;
    end;

    Ord(nfJoinedMyHostedBattle):
    begin
      FieldLabel1.Visible := False;
      Edit1.Visible := False;
      FieldLabel2.Visible := False;
      Edit2.Visible := False;
    end;

    Ord(nfStatusInBattle):
    begin
      FieldLabel1.Caption := 'Player';
      FieldLabel1.Visible := True;
      Edit1.Text := 'player';
      Edit1.Visible := True;
      FieldLabel2.Visible := False;
      Edit2.Visible := False;
    end;

    Ord(nfModHosted):
    begin
      FieldLabel1.Caption := 'Mod';
      FieldLabel1.Visible := True;
      Edit1.Text := 'mod';
      Edit1.Visible := True;
      FieldLabel2.Visible := False;
      Edit2.Visible := False;
    end;
  end; // end of case

end;

procedure TAddNotificationForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAddNotificationForm.AddButtonClick(Sender: TObject);
begin

  case NotifsComboBox.ItemIndex of
    Ord(nfJoinedChannel):
    begin
      if (Edit2.Text = '') or (Edit2.Text[1] <> '#') then
      begin
        MessageDlg(_('Invalid channel name. Make sure you use # in front of channel''s name!'), mtWarning, [mbOK], 0);
        Exit;
      end;

      if not NotificationsForm.AddNotification(nfJoinedChannel, [AnsiString(Edit1.Text), AnsiString(Edit2.Text)]) then
      begin
        MessageDlg(_('Unable to add notification. Equivalent notification probably exists already.'), mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    Ord(nfJoinedBattle):
    begin
      if not NotificationsForm.AddNotification(nfJoinedBattle, []) then
      begin
        MessageDlg(_('Unable to add notification. Equivalent notification probably exists already.'), mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    Ord(nfJoinedMyHostedBattle):
    begin
      if not NotificationsForm.AddNotification(nfJoinedMyHostedBattle, []) then
      begin
        MessageDlg(_('Unable to add notification. Equivalent notification probably exists already.'), mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    Ord(nfStatusInBattle):
    begin
      if not NotificationsForm.AddNotification(nfStatusInBattle, [AnsiString(Edit1.Text)]) then
      begin
        MessageDlg(_('Unable to add notification. Equivalent notification probably exists already.'), mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    Ord(nfModHosted):
    begin
      if not NotificationsForm.AddNotification(nfModHosted, [AnsiString(Edit1.Text)]) then
      begin
        MessageDlg(_('Unable to add notification. Equivalent notification probably exists already.'), mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

  end; // end of case

  ModalResult := mrOK;
end;

end.
