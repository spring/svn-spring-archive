unit CrashDetailsUnit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TCrashDetailsDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    RichEdit1: TRichEdit;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CrashDetailsDialog: TCrashDetailsDialog;

implementation

{$R *.dfm}

end.
