unit HttpGetUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, HttpProt, StdCtrls, Buttons, ComCtrls, MainUnit, Misc, ShellAPI,
  SpTBXControls, TBXDkPanels, SpTBXItem;

type
  THttpGetForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    CancelButton: TSpTBXSpeedButton;
    Label1: TSpTBXLabel;
    StatusLabel: TSpTBXLabel;
    ReceivedLabel: TSpTBXLabel;
    Label2: TSpTBXLabel;
    FileNameLabel: TSpTBXLabel;
    CloseButton: TSpTBXButton;
    HttpCli1: THttpCli;
    ProgressBar: TSpTBXProgressBar;

    procedure CreateParams(var Params: TCreateParams); override;

    function StartDownload(URL: string): Boolean;
    procedure CancelDownload;
    procedure UpdateReceivedStatus;

    procedure OnStartDownloadMessage(var Msg: TMessage); message WM_STARTDOWNLOAD;
    procedure OnStartDownloadMessage2(var Msg: TMessage); message WM_STARTDOWNLOAD2;

    procedure FormCreate(Sender: TObject);
    procedure HttpCli1DocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure CancelButtonClick(Sender: TObject);
    procedure HttpCli1HeaderData(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HttpCli1DocBegin(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HttpGetForm: THttpGetForm;

  DownloadFile: // fields must be initialized by sender of WM_STARTDOWNLOAD message
  record
    URL: string;
    FileName: string; // to where the file from url should be saved
    ServerOptions: Integer;
  end;

  FileStream: TFileStream;

  DownloadStatus:
  record
    Downloading: Boolean;
    Success: Boolean;
  end;


implementation

uses
  PreferencesFormUnit, BattleFormUnit;

{$R *.dfm}

procedure THttpGetForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;
  if Preferences.TaskbarButtons then HttpGetForm.FormStyle := fsNormal
  else HttpGetForm.FormStyle := fsStayOnTop;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

function THttpGetForm.StartDownload(URL: string): Boolean;
begin
  Result := False;

  if DownloadStatus.Downloading then Exit;
  UpdateReceivedStatus;
  DownloadStatus.Downloading := True;
  DownloadStatus.Success := False;

  FixURL(URL);
  HttpCli1.URL := URL;
  if Preferences.UseProxy then
  begin
    HttpCli1.Proxy := Preferences.ProxyAddress;
    HttpCli1.ProxyPort := IntToStr(Preferences.ProxyPort);
    HttpCli1.ProxyUsername := Preferences.ProxyUsername;
    HttpCli1.ProxyPassword := Preferences.ProxyPassword;
  end
  else HttpCli1.Proxy := '';
  CancelButton.Enabled := True;
  CloseButton.Enabled := False;
  StatusLabel.Caption := 'Loading ';

  try

    try
      HttpCli1.Get;
      StatusLabel.Caption := 'Done.';
      DownloadStatus.Success := True;
    except
      on E: EHttpException do
      begin
        StatusLabel.Caption := 'Failed : ' + IntToStr(HttpCli1.StatusCode) + ' ' + HttpCli1.ReasonPhrase;
      end
      else
        raise;
    end;

  finally
    CancelButton.Enabled := False;
    CloseButton.Enabled := True;
    try
      HttpCli1.RcvdStream.Destroy;
    except
    end;
    HttpCli1.RcvdStream := nil;
    DownloadStatus.Downloading := False;
  end;

  if DownloadStatus.Success then
  begin
    // try to open the file:
    if (DownloadFile.ServerOptions and $1) = 1 then
    begin
      if MessageDlg('Server says you should now open this file. Would you like to do that now?', mtInformation, [mbYes, mbNo], 0) = mrYes then
      begin
        ShellExecute(MainForm.Handle, 'open', PChar(AnsiString(DownloadFile.FileName)), nil, PChar(ExtractFilePath(Application.ExeName)), SW_SHOWNORMAL);
        if (DownloadFile.ServerOptions and $2) = 2 then MainForm.Close;
      end;
    end
    else
      MessageDlg('Download complete!', mtInformation, [mbOK], 0);
  end;

  Result := True;

end;

procedure THttpGetForm.CancelDownload;
begin
  HttpCli1.Abort;
end;

procedure THttpGetForm.UpdateReceivedStatus;
begin
  if not DownloadStatus.Downloading then
  begin
    ReceivedLabel.Caption := 'Received 0 KB';
    ProgressBar.Position := 0;
    Exit;
  end;

  ReceivedLabel.Caption := 'Received ' + Misc.FormatFileSize(HttpCli1.RcvdStream.Size) + ' KB (' + IntToStr(Round(HttpCli1.RcvdStream.Size / HttpCli1.ContentLength * 100)) + '%)';
  if HttpCli1.ContentLength = 0 then ProgressBar.Position := 0 else
    ProgressBar.Position := Round(HttpCli1.RcvdStream.Size / HttpCli1.ContentLength * 100);
end;

procedure THttpGetForm.FormCreate(Sender: TObject);
begin
  HttpCli1.SocksLevel := '5';
  DownloadStatus.Downloading := False;
  DownloadStatus.Success := False;
end;

procedure THttpGetForm.OnStartDownloadMessage(var Msg: TMessage); // responds to WM_STARTDOWNLOAD message
begin
  HttpGetForm.Show;
end;

procedure THttpGetForm.OnStartDownloadMessage2(var Msg: TMessage); // responds to WM_STARTDOWNLOAD2 message
begin
  StartDownload(DownloadFile.URL);
end;


procedure THttpGetForm.HttpCli1DocData(Sender: TObject; Buffer: Pointer;
  Len: Integer);
begin
  UpdateReceivedStatus;
end;

procedure THttpGetForm.CancelButtonClick(Sender: TObject);
begin
  CancelDownload;
end;

procedure THttpGetForm.HttpCli1HeaderData(Sender: TObject);
begin
  StatusLabel.Caption := StatusLabel.Caption + '.';
end;

procedure THttpGetForm.FormShow(Sender: TObject);
begin
  FileNameLabel.Caption := '?';
  PostMessage(Handle, WM_STARTDOWNLOAD2, 0, 0);
end;

procedure THttpGetForm.HttpCli1DocBegin(Sender: TObject);
begin
  StatusLabel.Caption := 'Transfering ...';

  try
    if DownloadFile.FileName = '*' then DownloadFile.FileName := ExtractFilePath(Application.ExeName) + HttpCli1.DocName
    else DownloadFile.FileName := ExtractFilePath(Application.ExeName) + DownloadFile.FileName;
    FileNameLabel.Caption := ExtractFileName(DownloadFile.FileName);
    FileStream := TFileStream.Create(DownloadFile.FileName, fmCreate);
    HttpCli1.RcvdStream := FileStream;
  except
    HttpCli1.Abort;
    MessageDlg('Unable to create file: ' + DownloadFile.FileName + '. Download cancelled!', mtWarning, [mbOK], 0);
    Exit;
  end;

end;

procedure THttpGetForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure THttpGetForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if DownloadStatus.Downloading then
  begin
    if MessageDlg('If you close this window your download will be cancelled. Are you sure you wish to do that?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    begin
      Action := caNone;
      Exit;
    end;
    CancelDownload;
  end;
end;

end.
