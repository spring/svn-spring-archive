unit HttpGetUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OverbyteIcsHttpProt, StdCtrls, Buttons, ComCtrls, MainUnit, Misc, ShellAPI,
  SpTBXControls, SpTBXItem,StrUtils, SevenZipVCL,Utility,
  OverbyteIcsWndControl,IniFiles;

type
  THttpGetForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    HttpCli1: THttpCli;
    SevenZip1: TSevenZip;
    pnlMain: TSpTBXPanel;
    Label1: TSpTBXLabel;
    StatusLabel: TSpTBXLabel;
    Label2: TSpTBXLabel;
    FileNameLabel: TSpTBXLabel;
    ProgressBar: TSpTBXProgressBar;
    ReceivedLabel: TSpTBXLabel;
    CancelButton: TSpTBXSpeedButton;

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
    HeaderReceived: boolean;
  end;

  FileStream: TFileStream;

  DownloadStatus:
  record
    Downloading: Boolean;
    Success: Boolean;
  end;


implementation

uses
  PreferencesFormUnit, BattleFormUnit, SpringDownloaderFormUnit, gnugettext;

{$R *.dfm}

procedure THttpGetForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  {with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;}

  {if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;
  if Preferences.TaskbarButtons then HttpGetForm.FormStyle := fsNormal
  else HttpGetForm.FormStyle := fsStayOnTop;

  }
end;

function THttpGetForm.StartDownload(URL: string): Boolean;
var
  i:integer;
  paramList: TStringList;
  appExePath: string;
  e: integer;
  errorList: TStringList;
  Ini : TIniFile;
  deleteFileName: String;
  regExpDelete: string;
  deleteWholeDirName: string;
  defaultRegExp: string;
begin
  Result := False;

  ReceivedLabel.Visible := True;

  if (DownloadFile.ServerOptions and 4) = 4 then
    HttpGetForm.Caption := _('Auto-updating lobby ...')
  else if (DownloadFile.ServerOptions and 8) = 8 then
    HttpGetForm.Caption := _('Downloading map ...')
  else
    HttpGetForm.Caption := _('File download');

  SpTBXTitleBar1.Caption := HttpGetForm.Caption;


  if DownloadStatus.Downloading then Exit;
  UpdateReceivedStatus;
  DownloadStatus.Downloading := True;
  DownloadStatus.Success := False;

  FixURL(URL);
  HttpCli1.URL := URL;
  {if Preferences.UseProxy then
  begin
    HttpCli1.Proxy := Preferences.ProxyAddress;
    HttpCli1.ProxyPort := IntToStr(Preferences.ProxyPort);
    HttpCli1.ProxyUsername := Preferences.ProxyUsername;
    HttpCli1.ProxyPassword := Preferences.ProxyPassword;
  end
  else }HttpCli1.Proxy := '';
  CancelButton.Enabled := True;
  StatusLabel.Caption := _('Loading ');

  try

    try
      HttpCli1.Get;
      StatusLabel.Caption := _('Done.');
      DownloadStatus.Success := True;
    except
      on E: EHttpException do
      begin
        StatusLabel.Caption := _('Failed : ') + IntToStr(HttpCli1.StatusCode) + ' ' + HttpCli1.ReasonPhrase;
      end
      else
        raise;
    end;

  finally
    CancelButton.Enabled := False;
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
      if MessageDlg(_('Server says you should now open this file. Would you like to do that now?'), mtInformation, [mbYes, mbNo], 0) = mrYes then
      begin
        ShellExecute(MainForm.Handle, 'open', PChar(AnsiString(DownloadFile.FileName)), nil, PChar(ExtractFilePath(Application.ExeName)), SW_SHOWNORMAL);
        if (DownloadFile.ServerOptions and $2) = 2 then MainForm.Close;
      end;
    end
    else if (DownloadFile.ServerOptions and $4) = 4 then
    begin
        //StatusLabel.Caption := _('Download complete, extracting new files ...');
        ReceivedLabel.Visible := False;
        appExePath := Application.ExeName;

        SevenZip1.SZFileName := DownloadFile.FileName;
        DelTree(ExtractFilePath(appExePath)+'TASClientUpdateTemp\');
        SevenZip1.ExtrBaseDir := ExtractFilePath(appExePath)+'TASClientUpdateTemp\';
        e := SevenZip1.Extract(false);

        DeleteFile(DownloadFile.FileName);
        if e=0 then
        begin
          // delete tasclient.exe.old
          if FileExists(Application.ExeName+'.old') then
            DeleteFile(Application.ExeName+'.old');

          // renames tasclient.exe
          if not RenameFile(Application.ExeName,Application.ExeName+'.old') then
          begin
            MessageDlg('Error : cannot rename '+Application.ExeName, mtError, [mbOK], 0);
            Exit;
          end;

          // unloads the 7z dll
          SevenZip1.SZFileName := '';
          SevenZip1.Destroy;

          // closes springdownloader
          CloseSpringDownloader;

          // change translation to default
          UseLanguage('en_us');

          // uninit unitsync
          Utility.DeInitLib;

          if FileExists(ExtractFilePath(appExePath)+'TASClientUpdateTemp\update.ini') then
          begin
            Ini := TIniFile.Create(ExtractFilePath(appExePath)+'TASClientUpdateTemp\update.ini');

            if Ini.ValueExists('Warning','Message') then
              MessageDlg(Ini.ReadString('Warning','Message',_('TASClient is about to update and delete some files in the lobby folder, please backup everything you don''t want to loose')),mtWarning,[mbOK],0);

            // delete whole dir
            i := 1;
            while Ini.ValueExists('DeleteWholeDir','Dir'+IntToStr(i)) do
            begin
              deleteWholeDirName := Ini.ReadString('DeleteWholeDir','Dir'+IntToStr(i),'');
              if (deleteWholeDirName <> '') and (Pos('..',deleteWholeDirName) = 0) then // reverse path is forbidden for security issue
                Misc.DelTree(ExtractFilePath(appExePath)+'Lobby\'+deleteWholeDirName);
              Inc(i);
            end;

            // delete outdated files
            i := 1;
            while Ini.ValueExists('Delete','File'+IntToStr(i)) do
            begin
              deleteFileName := Ini.ReadString('Delete','File'+IntToStr(i),'');
              if Pos('..',deleteFileName) = 0 then // reverse path is forbidden for security issue
              begin
                deleteFileName := ExtractFilePath(appExePath)+'Lobby\'+deleteFileName;
                if FileExists(deleteFileName) then
                  DeleteFile(deleteFileName);
              end;
              Inc(i);
            end;

            defaultRegExp := '^'+StringReplace(LowerCase(ExtractFilePath(appExePath)+'Lobby\'),'\','\\',[rfReplaceAll]);

            // regex delete outdated files
            i := 1;
            while Ini.ValueExists('RegExDelete','RegEx'+IntToStr(i)) do
            begin
              regExpDelete := Ini.ReadString('RegExDelete','RegEx'+IntToStr(i),'');
              if regExpDelete <> '' then
                Misc.DeleteFilesRegExp(ExtractFilePath(appExePath)+'Lobby',defaultRegExp+regExpDelete);
              Inc(i);
            end;

            DeleteFile(ExtractFilePath(appExePath)+'TASClientUpdateTemp\update.ini');
          end;

          // updates files
          MoveTree(ExtractFilePath(appExePath)+'TASClientUpdateTemp\',ExtractFilePath(appExePath));

          // reconstructs the parameters string
          paramList := TStringList.Create;
          for i:=1 to ParamCount do
            paramList.Add(ParamStr(i));

          // executes the new tasclient.exe
          ShellExecute(0,'open',PChar(appExePath),PChar(JoinStringList(paramList,' ')),PChar(ExtractFilePath(appExePath)), SW_SHOWNORMAL);
          MainForm.Close;
        end
        else
        begin
          if (SevenZip1.LastError >= 0) and (SevenZip1.LastError <= 11) then
            MessageDlg(_('Error ')+IntToStr(e) + ','+IntToStr(SevenZip1.LastError)+' : '+c7zipResMsg[SevenZip1.LastError], mtError, [mbOK], 0)
          else
            MessageDlg(_('Error ')+IntToStr(e) + ','+IntToStr(SevenZip1.LastError), mtError, [mbOK], 0);
        end;
    end
    else if (DownloadFile.ServerOptions and 8) = 8 then
    begin
      BattleForm.ReloadMapListButtonClick(nil);
      HttpGetForm.Close;
    end
    else
      MessageDlg(_('Download complete!'), mtInformation, [mbOK], 0);
  end;
  Result := True;

end;


procedure THttpGetForm.CancelDownload;
begin
  HttpCli1.Abort;
end;

procedure THttpGetForm.UpdateReceivedStatus;
var
  currentSize: integer;
  fileSize: integer;
begin
  if not DownloadStatus.Downloading then
  begin
    ReceivedLabel.Caption := _('Received 0 byte');
    ProgressBar.Position := 0;
    Exit;
  end;

  currentSize := HttpCli1.RcvdStream.Size;
  fileSize := HttpCli1.ContentLength;

  try
    ReceivedLabel.Caption := Format(_('Received %s (%d%%)'),[Misc.FormatFileSize3([currentSize, fileSize],'%s/%s %u'),Round(currentSize / fileSize * 100)])
  except
    ReceivedLabel.Caption := Format('Received %s (%d%%)',[Misc.FormatFileSize3([currentSize, fileSize],'%s/%s %u'),Round(currentSize / fileSize * 100)])
  end;
  if fileSize = 0 then
    ProgressBar.Position := 0
  else
    ProgressBar.Position := Round(currentSize / fileSize * 100);
end;

procedure THttpGetForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  HttpCli1.SocksLevel := '5';
  DownloadStatus.Downloading := False;
  DownloadStatus.Success := False;
end;

procedure THttpGetForm.OnStartDownloadMessage(var Msg: TMessage); // responds to WM_STARTDOWNLOAD message
begin
  if (DownloadFile.ServerOptions and 4) = 4 then
    HttpGetForm.ShowModal
  else
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
  StatusLabel.Caption := _('Transfering ...');

  try
    if not DownloadFile.HeaderReceived then
    begin
      if DownloadFile.FileName = '*' then
        DownloadFile.FileName := ExtractFilePath(Application.ExeName) + HttpCli1.DocName
      else
        DownloadFile.FileName := ExtractFilePath(Application.ExeName) + DownloadFile.FileName;
      DownloadFile.HeaderReceived := True;
    end;
    FileNameLabel.Caption := ExtractFileName(DownloadFile.FileName);
    FileStream := TFileStream.Create(DownloadFile.FileName, fmCreate);
    HttpCli1.RcvdStream := FileStream;
  except
    HttpCli1.Abort;
    MessageDlg(_('Unable to create file: ') + DownloadFile.FileName + _('. Download cancelled!'), mtWarning, [mbOK], 0);
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
    if MessageDlg(_('If you close this window your download will be cancelled. Are you sure you wish to do that?'), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    begin
      Action := caNone;
      Exit;
    end;
    CancelDownload;
  end;
end;

end.
