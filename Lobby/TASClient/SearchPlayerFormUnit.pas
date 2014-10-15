unit SearchPlayerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, StdCtrls, SpTBXEditors, SpTBXItem;

type
  TSearchPlayerForm = class(TForm)
    SpTBXLabel1: TSpTBXLabel;
    KeywordEdit: TSpTBXEdit;
    btCancel: TSpTBXButton;
    btGO: TSpTBXButton;
    SpTBXLabel2: TSpTBXLabel;
    procedure btCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btGOClick(Sender: TObject);
    procedure KeywordEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SearchPlayerForm: TSearchPlayerForm;

implementation

uses MainUnit, gnugettext;

{$R *.dfm}

procedure TSearchPlayerForm.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TSearchPlayerForm.FormShow(Sender: TObject);
begin
  SetFocus;
  KeywordEdit.SetFocus;
  KeywordEdit.SelectAll;
end;

procedure TSearchPlayerForm.btGOClick(Sender: TObject);
var
  i:integer;
  Clients : TList;
begin
  if MainForm.lastActiveTab.Caption = LOCAL_TAB then
    Clients := AllClients
  else
    Clients := MainForm.lastActiveTab.Clients;
  for i:=0 to Clients.Count-1 do
    if Pos(LowerCase(KeywordEdit.Text),LowerCase(TClient(Clients[i]).Name)) > 0 then
    begin
      MainForm.ClientsListBox.ItemIndex := i;
      Close;
      MainForm.ClientsListBox.SetFocus;
      Exit;
    end;
  Close;
end;

procedure TSearchPlayerForm.KeywordEditKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
    btGOClick(nil);
end;

procedure TSearchPlayerForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
