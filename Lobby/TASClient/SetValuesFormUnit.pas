unit SetValuesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, Grids, ValEdit, CustomizeGUIFormUnit,
  gnugettext;

type
  TSetValuesForm = class(TForm)
    SetValues: TValueListEditor;
    procedure SetValuesStringsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    DisplayedProperty: TSetProperty;
  end;

var
  SetValuesForm: TSetValuesForm;

implementation

{$R *.dfm}

procedure TSetValuesForm.SetValuesStringsChange(Sender: TObject);
var
  i: integer;
  s: string;
begin
  if DisplayedProperty = nil then
    Exit;
  
  for i:=0 to SetValues.RowCount-1 do
    if SetValues.Cells[1,i] = 'True' then
      if s = '' then
        s := SetValues.Cells[0,i]
      else
        s := s + ','+SetValues.Cells[0,i];

   DisplayedProperty.ChangeValue(s);
end;

procedure TSetValuesForm.FormCreate(Sender: TObject);
begin
  DisplayedProperty := nil;
end;

end.
