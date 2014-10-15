unit AwayMessageFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, StdCtrls, SpTBXEditors, SpTBXItem,SpTBXSkins,
  ComCtrls,Misc;

type
  TAwayMessageForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    TitleEdit: TSpTBXEdit;
    SpTBXLabel1: TSpTBXLabel;
    SpTBXLabel2: TSpTBXLabel;
    CancelButton: TSpTBXButton;
    SaveAndUseButton: TSpTBXButton;
    UseButton: TSpTBXButton;
    MessageRichEdit: TRichEdit;
    procedure CancelButtonClick(Sender: TObject);
    procedure UseButtonClick(Sender: TObject);
    procedure SaveAndUseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AwayMessageForm: TAwayMessageForm;

implementation

uses MainUnit, gnugettext, PreferencesFormUnit;

{$R *.dfm}

procedure TAwayMessageForm.CancelButtonClick(Sender: TObject);
begin
  PostMessage(Handle, WM_CLOSE, 0, 0); // close form
end;

procedure TAwayMessageForm.UseButtonClick(Sender: TObject);
var
  i:integer;
begin
  if (StrLen(MessageRichEdit.Lines.GetText) < 4) then begin
    MessageDlg(_('You must enter a message (4 char min) !'),mtWarning,[mbOk],0);
    Exit;
  end;
  for i:=0 to AllClients.Count-1 do
    TClient(AllClients[i]).AwayMessageSent := False;
  if Status.Me = nil then Exit; // should not happen!
  if not Status.Me.GetAwayStatus then // no need to set to away if already away
  begin
    Status.Me.SetAwayStatus(True);
    MainForm.TryToSendCommand('MYSTATUS', IntToStr(Status.Me.Status));
  end;
  Status.CurrentAwayMessage := Misc.JoinStringList(MessageRichEdit.Lines,' ');
  Status.CurrentAwayItem := -1;
  Status.AutoAway := False;
  PostMessage(Handle, WM_CLOSE, 0, 0); // close form
end;

procedure TAwayMessageForm.SaveAndUseButtonClick(Sender: TObject);
var
  i: integer;
begin
  if (TitleEdit.Text = '') or (StrLen(MessageRichEdit.Lines.GetText) < 4) then begin
    MessageDlg(_('You must enter a title and a message (4 char min) !'),mtWarning,[mbOk],0);
    Exit;
  end;
  AwayMessages.Titles.Add(TitleEdit.Text);
  AwayMessages.Messages.Add(Misc.JoinStringList(MessageRichEdit.Lines,' '));
  MainForm.SetAway(AwayMessages.Titles.Count-1);
  MainForm.SaveAwayMessages;
  PostMessage(Handle, WM_CLOSE, 0, 0); // close form
end;

procedure TAwayMessageForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
