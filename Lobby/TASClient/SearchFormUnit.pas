{ This form gets displayed as a popup form (see TSpTBXFormPopupMenu component) }

unit SearchFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, StdCtrls, SpTBXEditors, TntStdCtrls, SpTBXItem,
  SpTBXFormPopupMenu;

type
  TSearchForm = class(TForm)
    MainDisplayPanel: TSpTBXPanel;
    SpTBXLabel1: TSpTBXLabel;
    KeywordEdit: TSpTBXEdit;
    SpTBXLabel2: TSpTBXLabel;
    CategorySearchBox: TSpTBXComboBox;
    SpTBXButton1: TSpTBXButton;
    SpTBXButton2: TSpTBXButton;
    procedure SpTBXButton2Click(Sender: TObject);
    procedure SpTBXButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SearchForm: TSearchForm;

implementation

uses Misc, gnugettext;

{$R *.dfm}

procedure TSearchForm.SpTBXButton2Click(Sender: TObject);
begin
  if Assigned(ActiveFormPopupMenu) then
    ActiveFormPopupMenu.ClosePopup(False);
end;

procedure TSearchForm.SpTBXButton1Click(Sender: TObject);
var
  url: string;
begin
  url := 'http://spring.jobjol.nl/search_result.php?search=' + KeywordEdit.Text;
  case CategorySearchBox.ItemIndex of
    0: url := url + '&select=select_all'; // all
    1: url := url + '&select=select_file_subject'; // title
    2: url := url + '&select=select_file_name'; // file name
    3: url := url + '&select=select_file_description'; // description
  end; // case
  FixURL(url);
  Misc.OpenURLInDefaultBrowser(url);
  if Assigned(ActiveFormPopupMenu) then
    ActiveFormPopupMenu.ClosePopup(True);
end;

procedure TSearchForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  CategorySearchBox.ItemIndex := 0;
end;

procedure TSearchForm.FormShow(Sender: TObject);
begin
  if CategorySearchBox.ItemIndex = -1 then
    CategorySearchBox.ItemIndex := 0;
  Self.KeywordEdit.SetFocus;
end;

end.
