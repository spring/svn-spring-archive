unit MapSelectionFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, SpTBXEditors, SpTBXControls, SpTBXFormPopupMenu,
  TntStdCtrls, SpTBXItem;

type
  TMapSelectionForm = class(TForm)
    MainDisplayPanel: TSpTBXPanel;
    MapListBox: TSpTBXListBox;
    SpTBXLabel1: TSpTBXLabel;
    FilterTextBox: TSpTBXEdit;
    Panel1: TPanel;
    procedure FilterTextBoxChange(Sender: TObject);
    procedure MapListBoxDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  MapSelectionForm: TMapSelectionForm;

implementation

uses BattleFormUnit, gnugettext;

{$R *.dfm}

procedure TMapSelectionForm.FilterTextBoxChange(Sender: TObject);
begin
  BattleForm.PopulatePopupMenuMapListF(FilterTextBox.Text);
end;

procedure TMapSelectionForm.MapListBoxDblClick(Sender: TObject);
begin
  BattleForm.MapsPopupMenuItemClick(nil);
  if Assigned(ActiveFormPopupMenu) then
    ActiveFormPopupMenu.ClosePopup(True);
end;

procedure TMapSelectionForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
