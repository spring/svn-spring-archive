unit TemplateEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, gnugettext;

type
  TTemplateEditorForm = class(TForm)
    GroupBox1: TGroupBox;
    ProfileTemplate: TMemo;
    LayoutPropertyChange: TMemo;
    GroupBox2: TGroupBox;
    RecordPropertyChange: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TemplateEditorForm: TTemplateEditorForm;

implementation

{$R *.dfm}

end.
