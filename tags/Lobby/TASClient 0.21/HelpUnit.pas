unit HelpUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, JvExControls, JvComponent,
  JvXPCore, JvXPButtons;

type
  THelpForm = class(TForm)
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label29: TLabel;
    Image4: TImage;
    Image1: TImage;
    Label8: TLabel;
    Image2: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Image3: TImage;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    TabSheet2: TTabSheet;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Image5: TImage;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Button2: TButton;
    Button3: TButton;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    TabSheet3: TTabSheet;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label34: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Image6: TImage;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Image7: TImage;
    Label63: TLabel;
    Label64: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label65: TLabel;
    Image8: TImage;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    JvXPButton1: TJvXPButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure JvXPButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HelpForm: THelpForm;

implementation

uses Unit1, ShellAPI;

{$R *.dfm}

procedure THelpForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure THelpForm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure THelpForm.Button3Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := (PageControl1.ActivePageIndex + 1) mod PageControl1.PageCount;
end;

procedure THelpForm.Button2Click(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 0 then PageControl1.ActivePageIndex := PageControl1.PageCount-1
  else PageControl1.ActivePageIndex := PageControl1.ActivePageIndex - 1;
end;

procedure THelpForm.JvXPButton1Click(Sender: TObject);
begin
  ShellExecute(MainForm.Handle, nil, WIKI_PAGE_LINK, '', '', SW_SHOW);
end;

end.
