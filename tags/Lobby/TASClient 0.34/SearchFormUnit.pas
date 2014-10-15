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
  case CategorySearchBox.ItemIndex of
    0: url := 'http://spring.unknown-files.net/page/search/1/0/' + KeywordEdit.Text; // general
    1: url := 'http://spring.unknown-files.net/page/search/1/13/' + KeywordEdit.Text; // maps
    2: url := 'http://spring.unknown-files.net/page/search/1/14/' + KeywordEdit.Text; // mods
  end; // case
  FixURL(url);
  Misc.OpenURLInDefaultBrowser(url);
end;

end.
