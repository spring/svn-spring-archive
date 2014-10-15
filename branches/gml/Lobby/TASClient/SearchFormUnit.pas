{ This form gets displayed as a popup form (see TSpTBXFormPopupMenu component) }

unit SearchFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TBXDkPanels, SpTBXControls, StdCtrls, SpTBXEditors, TntStdCtrls;

type
  TSearchForm = class(TForm)
    SpTBXButton1: TSpTBXButton;
    SpTBXButton2: TSpTBXButton;
    KeywordEdit: TSpTBXEdit;
    SpTBXLabel1: TSpTBXLabel;
    SpTBXLabel2: TSpTBXLabel;
    CategorySearchBox: TSpTBXComboBox;
    procedure SpTBXButton2Click(Sender: TObject);
    procedure SpTBXButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SearchForm: TSearchForm;

implementation

uses Misc;

{$R *.dfm}

procedure TSearchForm.SpTBXButton2Click(Sender: TObject);
begin
  Close;
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
end;

end.
