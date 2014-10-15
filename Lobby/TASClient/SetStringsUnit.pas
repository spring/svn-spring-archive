unit SetStringsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls,CustomizeGUIFormUnit,gnugettext;

type
  TSetStringsForm = class(TForm)
    StringsMemo: TTntMemo;
    procedure StringsMemoChange(Sender: TObject);
  private
    { Private declarations }
  public
    DisplayedProperty: TStringsProperty;
  end;

var
  SetStringsForm: TSetStringsForm;

implementation

{$R *.dfm}

procedure TSetStringsForm.StringsMemoChange(Sender: TObject);
begin
  if StringsMemo.Focused then
    DisplayedProperty.ChangeValue(StringsMemo.Lines);
end;

end.
