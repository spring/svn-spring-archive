unit RapidDownloaderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXControls, StdCtrls, SpTBXEditors, TntStdCtrls, SpTBXItem,
  SpringDownloaderFormUnit;

type
  TRapidListThread = class(TRapidDownloadThread)
  protected
    procedure TagsListingDone; override;
  public
    constructor Create(Suspended : Boolean; Filter: String);
  end;

  TRapidDownloaderForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    DownloadListBox: TSpTBXListBox;
    FilterTextBox: TSpTBXEdit;
    ResultsLabel: TSpTBXLabel;
    UpdateListButton: TSpTBXButton;
    DownloadButton: TSpTBXButton;
    procedure FormShow(Sender: TObject);
    procedure FilterTextBoxKeyPress(Sender: TObject; var Key: Char);
    procedure DownloadListBoxDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateListButtonClick(Sender: TObject);
    procedure DownloadButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    m_DownloadList: TStringList;
  end;

var
  RapidDownloaderForm: TRapidDownloaderForm;

implementation

{$R *.dfm}

procedure TRapidListThread.TagsListingDone;
var
  i: integer;
begin
  RapidDownloaderForm.DownloadListBox.Clear;
  RapidDownloaderForm.m_DownloadList.Clear;
  for i:=0 to FTagsList.Count-1 do
  begin
    RapidDownloaderForm.DownloadListBox.Items.Add( TStringList(FTagsList[i])[3] + '      [' + TStringList(FTagsList[i])[0] + ']' );
    RapidDownloaderForm.m_DownloadList.Add(TStringList(FTagsList[i])[0]);
  end;
  RapidDownloaderForm.FilterTextBox.Enabled := true;
  RapidDownloaderForm.DownloadListBox.Enabled := true;
  RapidDownloaderForm.ResultsLabel.Caption := IntToStr(FTagsList.Count)+' results';
  RapidDownloaderForm.FilterTextBox.SetFocus;
  RapidDownloaderForm.FilterTextBox.SelectAll;
end;

constructor TRapidListThread.Create(Suspended : Boolean; Filter: String);
begin
  inherited Create(Suspended,nil,Filter,'',True);
  RapidDownloaderForm.ResultsLabel.Caption := 'Updating list ...';
end;

procedure TRapidDownloaderForm.FormShow(Sender: TObject);
begin
  if DownloadListBox.Count = 0 then
  begin
    TRapidListThread.Create(false,FilterTextBox.Text);
  end;
end;

procedure TRapidDownloaderForm.FilterTextBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateListButtonClick(nil);
  end;
end;

procedure TRapidDownloaderForm.DownloadListBoxDblClick(Sender: TObject);
begin
  DownloadButtonClick(nil);
end;

procedure TRapidDownloaderForm.FormCreate(Sender: TObject);
begin
  m_DownloadList := TStringList.Create;
end;

procedure TRapidDownloaderForm.UpdateListButtonClick(Sender: TObject);
begin
    DownloadListBox.Clear;
    DownloadListBox.Enabled := false;
    FilterTextBox.Enabled := false;
    TRapidListThread.Create(false,FilterTextBox.Text);
end;

procedure TRapidDownloaderForm.DownloadButtonClick(Sender: TObject);
begin
  if DownloadListBox.ItemIndex >= 0 then
    DownloadRapid(m_DownloadList[DownloadListBox.ItemIndex],false,'');
end;

end.
