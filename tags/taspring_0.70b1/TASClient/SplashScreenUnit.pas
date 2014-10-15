unit SplashScreenUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TSplashScreenForm = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashScreenForm: TSplashScreenForm;

implementation

{$R *.dfm}

end.
