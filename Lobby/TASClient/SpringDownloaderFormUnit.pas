unit SpringDownloaderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, SpTBXControls, JclRegistry, ExtCtrls,ShellAPI,
  LobbyScriptUnit, Math, SpTBXSkins,IdHTTP, InvokeRegistry, Rio,
  SOAPHTTPClient, xmldom, XMLIntf, msxmldom, XMLDoc, OverbyteIcsHttpProt,GpIFF,RegExpr,
  OverbyteIcsWndControl, OverbyteIcsMultisourceHttpDownloader,
  OverbyteIcsMultipartHttpDownloader, xmlrpctypes, xmlrpcclient,
  SevenZipVCL;

type
  TRapidFileInfo =
  record
    Size: Cardinal;
    Md5: string;
    crc: Cardinal;
    realName: string;
    poolPath: string;
  end;
  PRapidFileInfo = ^TRapidFileInfo;

  TProgressEvent = procedure(snc: PScriptDownloadCallback;progress: integer) of object;

  TRapidDownloadThread = class;

  TSpringDownloaderForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    tmrProgress: TTimer;
    tmrTimeout: TTimer;
    HttpCli1: THttpCli;
    MultisourceHttpDownloader1: TMultisourceHttpDownloader;
    pnlMain: TSpTBXPanel;
    lblInfo: TSpTBXLabel;
    ProgressBar: TSpTBXProgressBar;
    lblRemainingTime: TSpTBXLabel;
    lblProgress: TSpTBXLabel;
    joinBattleCheckBox: TSpTBXCheckBox;
    CancelButton: TSpTBXButton;
    PauseResumeButton: TSpTBXButton;
    SevenZip1: TSevenZip;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure tmrProgressTimer(Sender: TObject);
    procedure tmrTimeoutTimer(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DetailsButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HttpCli1DocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure HttpCli1DocBegin(Sender: TObject);
    procedure MultisourceHttpDownloader1RequestDone(Sender: TObject;
      ErrorCode: Integer; const Reason: String);
    procedure MultisourceHttpDownloader1Display(Sender: TObject;
      const Msg: String);
    procedure PauseResumeButtonClick(Sender: TObject);
  private
    { Private declarations }
  protected
    downloadType: string;
    downloadHash: integer;
    downloadName: string;
    joinBattleId : Integer;
    fileName: string;
    downloadEngineVersion: string;
    downloadLinks: TStringList;
    parentDownloadForm: TSpringDownloaderForm;
    dependenciesDlForm: TList;
    downloadCanceled: boolean;
    FNormalDownload: Boolean;
    FDownloadCurrent: Int64;
    FDownloadTotal: Int64;
    FDownloadStartTime: TDateTime;
    FDownloadCurSpeed: Extended;
    FDownloadLastSpeedUpdate: TDateTime;
    FDownloadLastSizeUpdate: Int64;
    FRapidDownloadThread: TRapidDownloadThread;

    downloading: boolean;
    timeOutCounter: integer;

    FOnProgress: TProgressEvent;

    procedure TryNextLink;
    procedure DependencyDownloadComplete(Sender: TSpringDownloaderForm);
  public
    cbInfo: PScriptDownloadCallback;
    makeSDD: boolean;
    sddDirName: string;

    procedure StartDownload(dlType: string; dlHash : integer; dlName: string; joinBattleWhenDownloadComplete : integer = 0; engineVersion: string = '');
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    procedure NormalDownload;
    procedure DownloadProgress(current: Int64; total: Int64;done: boolean = False; failed: boolean = False; rapidFailed: boolean = False; failedMsg: string = '');
  end;

  TRapidDownloadThread = class(TThread)
  private
    procedure OnTerminateProcedure(Sender : TObject);

  protected
    FModName: string;
    FRapidName: string;
    FExceptionMsg: string;
    FDlerForm: TSpringDownloaderForm;
    FhttpGet: THttpCli;
    FhttpPost: THttpCli;
    FAbord: Boolean;
    FDep: string;
    FListTagsOnly: Boolean;
    FTagsList: TList;
    FMakeSDD: Boolean;
    FSDDDir: string;

    procedure RaiseException;virtual;
    procedure DownloadStart;virtual;
    procedure DownloadDone;virtual;
    procedure DownloadDep;virtual;
    procedure TagsListingDone;virtual;
    procedure Execute; override;
    procedure DownloadDocData(Sender: TObject; Buffer: Pointer; Len: Integer);virtual;

    procedure ExceptionRaised(msg: string);
    procedure RapidDownload(modName: string; rapidName: string = ''; listTagsOnly: boolean = False);
    procedure MakeSDD( packageSdpFilePath: string ;sddName: string);
  public
    constructor Create(Suspended : Boolean; dlerForm: TSpringDownloaderForm; modName: string; rapidName: string = ''; listTagsOnly: boolean = False; makeSDD: boolean = false; sddDir: string = '');
    procedure Abort;
  end;

  TScriptRapidListThread = class(TRapidDownloadThread)
  protected
    FCallBack: PScriptSimpleCallback;

    procedure TagsListingDone; override;
  public
    constructor Create(Suspended : Boolean; callBack : PScriptSimpleCallback);
  end;

  function GetEngineDownloadLinks(name: string): TStringList;
  function GetDownloadLinks(name: string; var dependencies: TStringList): TStringList;
  function DownloadMod(modHash : integer; modName: string; noRapidDownload: boolean = false; joinBattleWhenDownloadComplete : integer = 0; scriptCallBack: PScriptDownloadCallback = nil; cb: TCallback=nil):TSpringDownloaderForm;
  function DownloadRapid(rapidName: string; makeSdd: Boolean; sddDirName: string; scriptCallBack: PScriptDownloadCallback = nil; cb: TCallback=nil):TSpringDownloaderForm;
  function DownloadMap(mapHash : integer; mapName: string; noBrowser : boolean = False; scriptCallBack: PScriptDownloadCallback = nil; cb: TCallback=nil):TSpringDownloaderForm;
  function DownloadEngine(engineName: string; engineVersion: string;  noBrowser: boolean = False; joinBattleWhenDownloadComplete : integer = 0; scriptCallBack: PScriptDownloadCallback = nil; cb: TCallback=nil):TSpringDownloaderForm;
  procedure StartSpringDownloader;
  procedure CloseSpringDownloader;
  procedure CleanUnusedDownloadForms;
var
  DownloadList: TStringList;
  ClosedDownloadFormList: TList;
  SpringDownloaderProcess:
  record
    proc_info: TProcessInformation;
    startinfo: TStartupInfo;
    ExitCode: Cardinal;
  end;
  //SpringDownloaderForm: TSpringDownloaderForm;

implementation

uses  BattleFormUnit,PreferencesFormUnit, MainUnit, StrUtils, Misc, ComObj, gnugettext,
      Utility,BitList,ZLibExGZ, PythonEngine;

{$R *.dfm}

procedure TSpringDownloaderForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;
  if Preferences.TaskbarButtons then Self.FormStyle := fsNormal
  else Self.FormStyle := fsStayOnTop;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TSpringDownloaderForm.TryNextLink;
var
  battle: TBattle;
  i: integer;
  RegExpr: TRegExpr;
  destDir: string;
begin
  if downloadLinks.Count=0 then
  begin
    lblInfo.Caption := _('Download failed (')+downloadName+')';
    lblInfo.Font.Color := clRed;
    CancelButton.Caption := _('Exit');
    if Assigned(FOnProgress) then
      FOnProgress(cbInfo,-2);
    Exit;
  end;

  MultisourceHttpDownloader1.URLS.Clear;
  MultisourceHttpDownloader1.URLS.AddStrings(downloadLinks);

  Randomize;
  i := RandomRange(0,downloadLinks.Count-1);
  HttpCli1.URL := downloadLinks[i];
  downloadLinks.Delete(i);

  try
      HttpCli1.Head;
      RegExpr := TRegExpr.Create;
      RegExpr.Expression := 'Content-Disposition: attachment; filename="([^"]+)"';

      if downloadType = 'ENGINE' then
        destDir := 'engine'
      else if downloadType = 'MAP' then
        destDir := 'maps'
      else
        destDir := 'mods';

      if RegExpr.Exec(HttpCli1.RcvdHeader.Text) and (RegExpr.SubExprMatchCount = 1) then
      begin
        fileName := ExtractFilePath(Application.ExeName)+destDir+'\'+URLDecode(RegExpr.Match[1]);
      end
      else
      begin
        fileName := ExtractFilePath(Application.ExeName)+destDir+'\'+URLDecode(HttpCli1.DocName);
      end;
      HttpCli1.Abort;

      try
        MultisourceHttpDownloader1.FileStream := TFileStream.Create(fileName,fmCreate or fmOpenWrite);
      except
        lblInfo.Caption := _('Unable to create file: ') + fileName + _('. Download cancelled!');
        lblInfo.Font.Color := clRed;
        Exit;
      end;
      MultisourceHttpDownloader1.Start;
  except
    TryNextLink;
  end;
end;

procedure TSpringDownloaderForm.DependencyDownloadComplete(Sender: TSpringDownloaderForm);
var
  battle: TBattle;
begin
  dependenciesDlForm.Remove(Sender);
  if dependenciesDlForm.Count = 0 then
  begin
    if joinBattleCheckBox.Checked then
    begin
      battle := MainForm.GetBattle(joinBattleId);
      if battle <> nil then
        MainForm.JoinBattle(battle);
    end;

    if Assigned(FOnProgress) then
      FOnProgress(cbInfo,-1);

    Close;
  end;
end;

procedure TSpringDownloaderForm.StartDownload(dlType: string; dlHash : integer; dlName: string; joinBattleWhenDownloadComplete : integer = 0; engineVersion: string = '');
var
  sl: TStringList;
  path : string;
begin
  DownloadList.BeginUpdate;
  DownloadList.Add(dlName);
  DownloadList.EndUpdate;

  downloadType := dlType;
  downloadHash := dlHash;
  downloadName := dlName;
  downloadEngineVersion := engineVersion;
  joinBattleId := joinBattleWhenDownloadComplete;

  joinBattleCheckBox.Visible := joinBattleId <> 0;
  joinBattleCheckBox.Checked := joinBattleId <> 0;

  lblInfo.Caption := Format(_('Downloading %s %s'),[LowerCase(dlType),dlName]);
  SpTBXTitleBar1.Caption := lblInfo.Caption;
  Self.Caption := lblInfo.Caption;

  ShowAndSetFocus(CancelButton);

  if dlType = 'MOD' then
  begin
    FNormalDownload := False;
    FRapidDownloadThread := TRapidDownloadThread.Create(false,Self,dlName);
  end
  else if dlType = 'RAPID' then
  begin
    FNormalDownload := False;
    FRapidDownloadThread := TRapidDownloadThread.Create(false,Self,'',dlName,false,makeSDD,sddDirName);
  end
  else
    NormalDownload;
end;

function DownloadRapid(rapidName: string; makeSdd: Boolean; sddDirName: string; scriptCallBack: PScriptDownloadCallback = nil; cb: TCallback=nil):TSpringDownloaderForm;
var
  url: string;
  cancel: boolean;
begin
  CleanUnusedDownloadForms;
  if DownloadList.IndexOf(rapidName) <> -1 then
    Exit;
  Application.CreateForm(TSpringDownloaderForm, Result);
  if scriptCallBack <> nil then
  begin
    Result.cbInfo := scriptCallBack;
    Result.cbInfo.form := Result;
    Result.OnProgress := cb.DownloadCallbackEvent;
  end;
  cancel := False;
  if AcquireMainThread then
  begin
    try if not Preferences.ScriptsDisabled then cancel := handlers.onDownloadRapidStart(LobbyScriptUnit.GetStringFromComponent(Result),rapidName); except end;
    ReleaseMainThread;
  end;
  if cancel then
    Result.CancelButtonClick(nil)
  else
  begin
    Result.makeSDD := makeSdd;
    Result.sddDirName := sddDirName;
    Result.StartDownload('RAPID',0,rapidName,0);
  end;
end;

function DownloadMod(modHash : integer; modName: string; noRapidDownload: boolean = false; joinBattleWhenDownloadComplete : integer = 0; scriptCallBack: PScriptDownloadCallback = nil; cb: TCallback=nil):TSpringDownloaderForm;
var
  url: string;
  cancel: boolean;
begin
  CleanUnusedDownloadForms;
  if not Preferences.EnableSpringDownloader then
  begin
    url := 'http://spring.jobjol.nl/search_result.php?search='+modName+'&select=select_all';
    FixURL(url);
    Misc.OpenURLInDefaultBrowser(url);
    Exit;
  end;
  if not noRapidDownload and (DownloadList.IndexOf(modName) <> -1) then
    Exit;
  Application.CreateForm(TSpringDownloaderForm, Result);
  if scriptCallBack <> nil then
  begin
    Result.cbInfo := scriptCallBack;
    Result.cbInfo.form := Result;
    Result.OnProgress := cb.DownloadCallbackEvent;
  end;
  cancel := False;
  if AcquireMainThread then
  begin
    try if not Preferences.ScriptsDisabled then cancel := handlers.onDownloadModStart(LobbyScriptUnit.GetStringFromComponent(Result),modHash,modName); except end;
    ReleaseMainThread;
  end;
  if cancel then
    Result.CancelButtonClick(nil)
  else
  begin
    if noRapidDownload then
      Result.StartDownload('MODARCHIVE',modHash,modName,joinBattleWhenDownloadComplete)
    else
      Result.StartDownload('MOD',modHash,modName,joinBattleWhenDownloadComplete);
    //Misc.ShowAndSetFocus(Result.CancelButton);
  end;
end;

function GetEngineDownloadLinks(name: string): TStringList;
var
  RpcCaller: TRpcCaller;
  RpcFunction: IRpcFunction;
  RpcArgs: IRpcStruct;
  RpcResult: IRpcResult;
  RpcArrayResult: IRpcArray;
  RpcStructResultItem: IRpcStruct;
  MirrorsIndex: integer;
  RpcMirrorsArray: IRpcArray;
  i: integer;
begin
  Result := TStringList.Create;
  
  RpcCaller := TRpcCaller.Create;
  try
    RpcCaller.EndPoint := '/xmlrpc.php';
    RpcCaller.HostName := 'api.springfiles.com';
    RpcCaller.HostPort := 80;

    RpcFunction := TRpcFunction.Create;
    RpcFunction.ObjectMethod := 'springfiles.search';

    RpcArgs := TRpcStruct.Create;
    RpcArgs.AddItem('springname',name);
    RpcArgs.AddItem('category','engine_windows');


    RpcFunction.AddItem(RpcArgs);

    RpcResult := RpcCaller.Execute(RpcFunction);
    if not RpcResult.IsError then
    begin
      if RpcResult.IsArray then
      begin
        RpcArrayResult := RpcResult.AsArray;
        if (RpcArrayResult.Count > 0) and RpcArrayResult.Items[0].IsStruct then
        begin
          RpcStructResultItem := RpcArrayResult.Items[0].AsStruct;
          MirrorsIndex := RpcStructResultItem.IndexOf('mirrors');
          if (MirrorsIndex > -1) and RpcStructResultItem.Items[MirrorsIndex].IsArray then
          begin
            RpcMirrorsArray := RpcStructResultItem.Items[MirrorsIndex].AsArray;
            for i:= 0 to RpcMirrorsArray.Count-1 do
            begin
              if RpcMirrorsArray.Items[i].IsString then
              begin
                if Debug.Enabled then
                  MainForm.AddMainLog('Engine download link found: '+RpcMirrorsArray.Items[i].AsString,Colors.Info);
                Result.Add(RpcMirrorsArray.Items[i].AsString);
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    RpcCaller.Free;
  end;
end;

function GetDownloadLinks(name: string; var dependencies: TStringList): TStringList;
var
  idHttp: TIdHTTP;
  xmlRequest : TStringList;
  xmlRequestStream: TStringStream;
  responseStream: TStringStream;
  xmlDoc: TXMLDocument;
  test: string;
  valueNode: IXMLNode;
  i:integer;
begin
  idHttp := TIdHTTP.Create(MainForm);
  idHttp.Port := 80;
  idHttp.Request.ContentType := 'application/soap+xml';
  idHttp.Request.ContentEncoding := 'utf-8';

  xmlRequest := TStringList.Create;
  xmlRequest.Add('<?xml version="1.0" encoding="utf-8"?>');
  xmlRequest.Add('<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">');
  xmlRequest.Add('  <soap12:Body>');
  xmlRequest.Add('    <DownloadFile xmlns="http://tempuri.org/">');
  xmlRequest.Add('      <internalName>'+name+'</internalName>');
  xmlRequest.Add('    </DownloadFile>');
  xmlRequest.Add('  </soap12:Body>');
  xmlRequest.Add('</soap12:Envelope>');


  xmlRequestStream := TStringStream.Create('');
  xmlRequestStream.WriteString(xmlRequest.Text);

  responseStream := TStringStream.Create('');

  idHttp.Post(SPRINGDOWNLOADER_SERVICE_URL,xmlRequestStream,responseStream);

  xmlDoc := TXMLDocument.Create(MainForm);
  xmlDoc.LoadFromStream(responseStream);

  result := TStringList.Create;

  try
    valueNode := xmlDoc.DocumentElement.ChildNodes.FindNode('soap:Body').ChildNodes.First.ChildNodes.FindNode('links');
    for i:=0 to valueNode.ChildNodes.Count-1 do
    begin
      result.Add(StringReplace(valueNode.ChildNodes.Nodes[i].Text,' ','%20',[rfReplaceAll]));
      if Debug.Enabled then
        MainForm.AddMainLog('Normal download link found: '+result[result.Count-1],Colors.Info);
    end;
  except
  end;

  try
    valueNode := xmlDoc.DocumentElement.ChildNodes.FindNode('soap:Body').ChildNodes.First.ChildNodes.FindNode('dependencies');
    for i:=0 to valueNode.ChildNodes.Count-1 do
    begin
      dependencies.Add(valueNode.ChildNodes.Nodes[i].Text);
      if Debug.Enabled then
        MainForm.AddMainLog('Normal download dependency found: '+dependencies[dependencies.Count-1],Colors.Info);
    end;
  except
  end;
end;

procedure CleanUnusedDownloadForms;
var
  i:integer;
begin
  for i:=0 to ClosedDownloadFormList.Count-1 do
    TSpringDownloaderForm(ClosedDownloadFormList[i]).Destroy;
  ClosedDownloadFormList.Clear;
end;

function DownloadMap(mapHash : integer; mapName: string; noBrowser : boolean = False; scriptCallBack: PScriptDownloadCallback = nil; cb: TCallback=nil):TSpringDownloaderForm;
var
  url: string;
  cancel: boolean;
begin
  CleanUnusedDownloadForms;
  if not Preferences.EnableSpringDownloader then
  begin
    url := 'http://spring.jobjol.nl/search_result.php?search='+StringReplace(mapName,'.smf','',[rfReplaceAll, rfIgnoreCase])+'&select=select_all';
    FixURL(url);
    if not noBrowser then
      Misc.OpenURLInDefaultBrowser(url);
    Exit;
  end;
  if DownloadList.IndexOf(mapName) <> -1 then
    Exit;
  Application.CreateForm(TSpringDownloaderForm, Result);
  if scriptCallBack <> nil then
  begin
    Result.cbInfo := scriptCallBack;
    Result.cbInfo.form := Result;
    Result.OnProgress := cb.DownloadCallbackEvent;
  end;
  cancel := false;
  if AcquireMainThread then
  begin
    try if not Preferences.ScriptsDisabled then cancel := handlers.onDownloadMapStart(LobbyScriptUnit.GetStringFromComponent(Result),mapHash,mapName); except end;
    ReleaseMainThread;
  end;
  if cancel then
    Result.CancelButtonClick(nil)
  else
  begin
    Result.StartDownload('MAP',mapHash,mapName);
    //Misc.ShowAndSetFocus(Result.CancelButton);
  end;
end;

function DownloadEngine(engineName: string; engineVersion: string;  noBrowser: boolean = False; joinBattleWhenDownloadComplete : integer = 0; scriptCallBack: PScriptDownloadCallback = nil; cb: TCallback=nil):TSpringDownloaderForm;
var
  downloadName: string;
  url: string;
  cancel: boolean;
begin
  downloadName := engineName+' '+engineVersion;
  CleanUnusedDownloadForms;
  if not Preferences.EnableSpringDownloader then
  begin
    url := 'http://spring.jobjol.nl/search_result.php?search='+downloadName+'&select=select_all';
    FixURL(url);
    if not noBrowser then
      Misc.OpenURLInDefaultBrowser(url);
    Exit;
  end;
  if DownloadList.IndexOf(downloadName) <> -1 then
    Exit;
  Application.CreateForm(TSpringDownloaderForm, Result);
  if scriptCallBack <> nil then
  begin
    Result.cbInfo := scriptCallBack;
    Result.cbInfo.form := Result;
    Result.OnProgress := cb.DownloadCallbackEvent;
  end;
  cancel := False;
  if AcquireMainThread then
  begin
    try if not Preferences.ScriptsDisabled then cancel := handlers.onDownloadEngineStart(LobbyScriptUnit.GetStringFromComponent(Result),engineName,engineVersion); except end;
    ReleaseMainThread;
  end;
  if cancel then
    Result.CancelButtonClick(nil)
  else
  begin
    Result.StartDownload('ENGINE',0,downloadName,joinBattleWhenDownloadComplete, engineVersion);
  end;
end;

procedure TSpringDownloaderForm.tmrProgressTimer(Sender: TObject);
var
  remainingMS: integer;
  percentDone: Extended;
begin
  if FNormalDownload then
  begin
    FDownloadTotal := Max(1,MultisourceHttpDownloader1.ContentLength);
    FDownloadCurrent := MultisourceHttpDownloader1.TotalCount;
    FDownloadStartTime := MultisourceHttpDownloader1.StartTime;
    FDownloadCurSpeed := MultisourceHttpDownloader1.CurSpeed;
  end
  else
  begin
    FDownloadCurSpeed := 8*(FDownloadCurrent-FDownloadLastSizeUpdate)/(Now-FDownloadLastSpeedUpdate)/100000000;
    FDownloadLastSpeedUpdate := Now;
    FDownloadLastSizeUpdate := FDownloadCurrent;
  end;

  percentDone := 100*FDownloadCurrent/FDownloadTotal;

  remainingMS := Floor(min(86400,(FDownloadTotal-FDownloadCurrent)/(1024*FDownloadCurrent/((Now-FDownloadStartTime)*86400000))));
  ProgressBar.Position := Floor(percentDone);
  if Assigned(FOnProgress) then
    FOnProgress(cbInfo,Floor(percentDone));
  try
    lblProgress.Caption := _('Progress : ')+Format(_('Received %s (%d%%)'),[Misc.FormatFileSize3([Integer(FDownloadCurrent),Integer(FDownloadTotal)],'%s/%s %u'),Round(percentDone)])+' '+Format(_(' - %dkB/s'),[Round(FDownloadCurSpeed/8)]);
    if remainingMS > 60 then
      lblRemainingTime.Caption := _('Remaining time : ')+Format('%d min %d seconds',[remainingMS div 60,remainingMS mod 60])
    else
      lblRemainingTime.Caption := _('Remaining time : ')+Format('%d seconds',[remainingMS]);
  except
    lblProgress.Caption := 'Progress : '+Format('Received %s (%d%%)',[Misc.FormatFileSize3([Integer(FDownloadCurrent),Integer(FDownloadTotal)],'%s/%s %u'),Round(percentDone)])+' '+Format(' - %dkB/s',[Round(FDownloadCurSpeed/8)]);
  end;
end;

procedure TSpringDownloaderForm.tmrTimeoutTimer(Sender: TObject);
begin
  if downloading then
    tmrTimeout.Enabled := False
  else
  begin
    timeOutCounter := timeOutCounter+1;
    if timeOutCounter >= 8 then
    begin
      lblInfo.Caption := _('Download failed (')+downloadName+')';
      lblInfo.Font.Color := clRed;
      tmrProgress.Enabled := False;
      tmrTimeout.Enabled := False;
      CancelButton.Caption := _('Exit');
      if Assigned(FOnProgress) then
        FOnProgress(cbInfo,-2);
    end;
  end;
end;

procedure TSpringDownloaderForm.CancelButtonClick(Sender: TObject);
begin
  if downloadCanceled then Exit; // already canceled
  downloadCanceled := True;
  Close;
end;

procedure TSpringDownloaderForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  if Preferences.ThemeType = sknSkin then
  begin
    SpTBXTitleBar1.Active := True;
    BorderStyle := bsNone;
  end;

  downloadLinks := TStringList.Create;
  dependenciesDlForm := TList.Create;
  parentDownloadForm := nil;
  downloadCanceled := False;
  PauseResumeButton.Enabled := False;

  FOnProgress := nil;
end;

procedure TSpringDownloaderForm.DetailsButtonClick(Sender: TObject);
var
  sl: TStringList;
  path : string;
begin

  sl := TStringList.Create;
  sl.Add('display');

  path := StringReplace(ExtractFilePath(Application.ExeName),'\','/',[rfReplaceAll]);
  path := LeftStr(path,Length(path)-1);

  RegWriteMultiSz(HKCU,'\Software\SpringDownloader\'+path+'\request\',downloadName,sl);
end;

procedure TSpringDownloaderForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  sl: TStringList;
  path : string;
  i: integer;
begin
  if downloadCanceled then
  begin
    if FRapidDownloadThread <> nil then
      FRapidDownloadThread.Abort;
    try
      downloadLinks.Clear;
      HttpCli1.Abort;
      MultisourceHttpDownloader1.Abort;
      if HttpCli1.RcvdStream <> nil then
        HttpCli1.RcvdStream.Destroy;
      HttpCli1.RcvdStream := nil;
      MultisourceHttpDownloader1.FileStream.Destroy;
      if FileExists(fileName) then
        DeleteFile(filename);
    except
    end;
    {sl := TStringList.Create;
    sl.Add('stop');

    path := StringReplace(ExtractFilePath(Application.ExeName),'\','/',[rfReplaceAll]);
    path := LeftStr(path,Length(path)-1);

    RegWriteMultiSz(HKCU,'\Software\SpringDownloader\'+path+'\request\',downloadName,sl);}
  end;
  //tmrProgress.Enabled := False;
  //tmrTimeout.Enabled := False;
  if Assigned(FOnProgress) then
    FOnProgress(cbInfo,-3);
  DownloadList.BeginUpdate;
  try DownloadList.Delete(DownloadList.IndexOf(downloadName)); except end;
  DownloadList.EndUpdate;
  for i:=0 to dependenciesDlForm.Count-1 do
    TSpringDownloaderForm(dependenciesDlForm[i]).parentDownloadForm := nil;
  dependenciesDlForm.Clear;
  ClosedDownloadFormList.Add(Self);
end;

procedure StartSpringDownloader;
var
  path : string;
  tmp: integer;
begin
  Exit;
  if MainUnit.Debug.Enabled then
    Misc.TryToAddLog(MainUnit.StartDebugLog,'Starting SpringDownloader ...');
  if not RegKeyExists(HKLM,'Software\Microsoft\NET Framework Setup\NDP\v2.0.50727') or not RegReadBool(HKLM,'Software\Microsoft\NET Framework Setup\NDP\v2.0.50727','Install') then
  begin
    if MessageDlg(_('You need the .NET Framework 2.0 to use SpringDownloader, do you want to download it now ?'),mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      MessageDlg(_('Restart the lobby when the .NET Framework is installed.'),mtInformation,[mbOk],0);
      OpenURLInDefaultBrowser('http://www.microsoft.com/downloads/details.aspx?FamilyID=0856eacb-4362-4b0d-8edd-aab15c5e04f5');
    end;
    Exit;
  end;


  path := StringReplace(ExtractFilePath(Application.ExeName),'\','/',[rfReplaceAll]);
  path := LeftStr(path,Length(path)-1);
  try DeleteRegKey('Software\SpringDownloader\'+path+'\request\ExitRequest',HKCU); except end;

  tmp := ShellExecute(0,'open',PChar(ExtractFilePath(Application.ExeName) + 'SpringDownloader.exe'),PChar('-silentstart'),PChar(ExtractFilePath(Application.ExeName)),SW_SHOWNORMAL);

  if (tmp > 0) and (tmp < 32) then MessageDlg(_('Couldn''t execute SpringDownloader'), mtWarning, [mbOK], 0);
end;
procedure CloseSpringDownloader;
var
  sl: TStringList;
  path : string;
begin
  Exit;
  sl := TStringList.Create;
  sl.Add('exit');

  path := StringReplace(ExtractFilePath(Application.ExeName),'\','/',[rfReplaceAll]);
  path := LeftStr(path,Length(path)-1);

  RegWriteMultiSz(HKCU,'\Software\SpringDownloader\'+path+'\request\','ExitRequest',sl);
end;

procedure TSpringDownloaderForm.NormalDownload;
var
  dep: TStringList;
  i: integer;
  dlForm: TSpringDownloaderForm;
  searchString: String;
begin
  FNormalDownload := True;

  if Debug.Enabled then
     MainForm.AddMainLog('Normal download started: '+downloadName,Colors.Info);

  if downloadType = 'ENGINE' then
  begin
    searchString := downloadName;
    if length(searchString) > 8 then
      searchString := searchString + '*';
    downloadLinks := GetEngineDownloadLinks(searchString);
  end
  else
  begin
    dep := TStringList.Create;
    downloadLinks := GetDownloadLinks(downloadName,dep);

    for i:=0 to dep.Count-1 do
      if Utility.ModList.IndexOf(dep[i]) = -1 then
      begin
        dlForm := DownloadMod(0,dep[i]);
        dependenciesDlForm.Add(dlForm);
        dlForm.parentDownloadForm := Self;
      end;
  end;

  PauseResumeButton.Enabled := True;
  tmrProgress.Enabled := True;

  TryNextLink;
end;

procedure TSpringDownloaderForm.DownloadProgress(current: Int64; total: Int64;done: boolean; failed: boolean; rapidFailed: boolean; failedMsg: string);
var
  i: integer;
  battle: TBattle;
begin
  lblInfo.Caption := Format(_('Downloading %s ...'),[downloadName]);
  if done then
  begin
    tmrProgress.Enabled := False;
    ProgressBar.Position := ProgressBar.Max;
    lblInfo.Caption := _('Done.');
    if parentDownloadForm <> nil then
      parentDownloadForm.DependencyDownloadComplete(Self);
    If downloadType = 'MAP' then
      BattleForm.ReloadMapListButtonClick(nil);
    if joinBattleCheckBox.Checked and (dependenciesDlForm.Count = 0) then
    begin
      battle := MainForm.GetBattle(joinBattleId);
      if battle <> nil then
        MainForm.JoinBattle(battle);
    end;
    if dependenciesDlForm.Count > 0 then
    begin
      lblInfo.Caption := _('Downloading dependencies ...');
    end
    else
    begin
      if Assigned(FOnProgress) then
        FOnProgress(cbInfo,-1);
      Close;
    end;
  end
  else if failed then
  begin
    lblInfo.Caption := _('Download failed (')+downloadName+')';
    if failedMsg <> '' then
      lblInfo.Caption := lblInfo.Caption + ' : ' + failedMsg;
    lblInfo.Font.Color := clRed;
    CancelButton.Caption := _('Exit');
    if Assigned(FOnProgress) then
      FOnProgress(cbInfo,-2);
  end
  else
  begin
    if current = -1 then
    begin
      FDownloadCurrent := 0;
      FDownloadTotal := 1;
      FDownloadStartTime := Now;
      FDownloadCurSpeed := 1;
      tmrProgress.Enabled := True;
      FDownloadLastSizeUpdate := 0;
      FDownloadLastSpeedUpdate := Now;
    end
    else
    begin
      FDownloadCurrent := current;
      FDownloadTotal := total;
    end;
  end;
end;

procedure TSpringDownloaderForm.HttpCli1DocData(Sender: TObject;
  Buffer: Pointer; Len: Integer);
begin
  DownloadProgress(THttpCli(Sender).RcvdStream.Size,THttpCli(Sender).ContentLength);
end;

procedure TSpringDownloaderForm.HttpCli1DocBegin(Sender: TObject);
var
  FileStream: TFileStream;
begin
  if fileName = '' then
  begin
    DownloadProgress(0,0,true);
  end;

  try
    FileStream := TFileStream.Create(fileName, fmCreate);
    HttpCli1.RcvdStream := FileStream;
  except
    try HttpCli1.Abort; except end;
    lblInfo.Caption := _('Unable to create file: ') + fileName + _('. Download cancelled!');
    lblInfo.Font.Color := clRed;
    Exit;
  end;
end;

procedure TSpringDownloaderForm.MultisourceHttpDownloader1RequestDone(
  Sender: TObject; ErrorCode: Integer; const Reason: String);
var
  e: integer;
begin
  tmrProgress.Enabled := False;

  if ErrorCode <> 200 then
  begin
    MultisourceHttpDownloader1.FileStream.Destroy;
    if FileExists(fileName) then
      DeleteFile(fileName);
    DownloadProgress(0,0,true);
    Exit;
  end;

  try
    MultisourceHttpDownloader1.FileStream.Destroy;
  except
  end;
  MultisourceHttpDownloader1.FileStream := nil;

  // extract the engine and delete the archive
  if downloadType = 'ENGINE' then
  begin
    SevenZip1.SZFileName := fileName;
    SevenZip1.ExtrBaseDir := ExtractFilePath(Application.ExeName)+'engine\'+downloadEngineVersion;
    e := SevenZip1.Extract(false);
    if e <> 0 then
    begin
      MainForm.AddMainLog(_('The engine files extraction failed with the following error code:')+IntToStr(e),Colors.Error);
    end
    else
    begin
      if not DeleteFile(fileName) then
        MainForm.AddMainLog(_('Could not delete the engine archive file after extraction'),Colors.Error);

      // create symbolic link between engine maps/mods/packages/pool directories and main ones
      try
        ShellExecute(0,'open',PChar('cmd.exe'),PChar(String('/C mklink /D "'+ExtractFilePath(Application.ExeName)+'engine\'+downloadEngineVersion+'\maps" ..\..\maps')),nil,SW_SHOWNORMAL);
        ShellExecute(0,'open',PChar('cmd.exe'),PChar(String('/C mklink /D "'+ExtractFilePath(Application.ExeName)+'engine\'+downloadEngineVersion+'\mods" ..\..\mods')),nil,SW_SHOWNORMAL);
        ShellExecute(0,'open',PChar('cmd.exe'),PChar(String('/C mklink /D "'+ExtractFilePath(Application.ExeName)+'engine\'+downloadEngineVersion+'\packages" ..\..\packages')),nil,SW_SHOWNORMAL);
        ShellExecute(0,'open',PChar('cmd.exe'),PChar(String('/C mklink /D "'+ExtractFilePath(Application.ExeName)+'engine\'+downloadEngineVersion+'\pool" ..\..\pool')),nil,SW_SHOWNORMAL);
      except
        MainForm.AddMainLog(_('Failed to create the engine symbolic links'),Colors.Error);
      end;
    end;
  end;

  DownloadProgress(0,0,true);
end;

procedure TSpringDownloaderForm.MultisourceHttpDownloader1Display(
  Sender: TObject; const Msg: String);
begin
  if Debug.Enabled then
    MainForm.AddMainLog(Msg,Colors.Info);
end;

procedure TSpringDownloaderForm.PauseResumeButtonClick(Sender: TObject);
begin
  if MultisourceHttpDownloader1.isPaused then
  begin
    MultisourceHttpDownloader1.Resume;
    PauseResumeButton.Caption := _('Pause');
  end
  else
  begin
    MultisourceHttpDownloader1.Pause;
    PauseResumeButton.Caption := _('Resume');
  end;
end;


procedure TRapidDownloadThread.OnTerminateProcedure(Sender : TObject);
begin
  inherited;
end;

procedure TRapidDownloadThread.Execute;
begin
  RapidDownload(FModName,FRapidName,FListTagsOnly);
end;

procedure TRapidDownloadThread.DownloadStart;
begin
  if FDlerForm <> nil then
    FDlerForm.DownloadProgress(-1,0);
end;

procedure TRapidDownloadThread.DownloadDone;
begin
  if FDlerForm <> nil then
    FDlerForm.DownloadProgress(0,0,true);

  if Debug.Enabled then
     MainForm.AddMainLog('Rapid download started: '+FModName+' ['+FRapidName+']',Colors.Info);
end;

procedure TRapidDownloadThread.DownloadDep;
var
  dlForm: TSpringDownloaderForm;
begin
  dlForm := DownloadMod(0,FDep);
  if FDlerForm <> nil then
  begin
    FDlerForm.dependenciesDlForm.Add(dlForm);
    dlForm.parentDownloadForm := FDlerForm;
  end;
end;

procedure TRapidDownloadThread.TagsListingDone;
var
  i: integer;
begin
  MainForm.AddMainLog('',Colors.Info);
  MainForm.AddMainLog('----------------------------------------',Colors.Info);
  MainForm.AddMainLog('Rapid list'+IfThen(FModName <> '',' (Filter='+FModName+')',''),Colors.Info);
  MainForm.AddMainLog('----------------------------------------',Colors.Info);

  for i:=0 to FTagsList.Count-1 do
  begin
    MainForm.AddMainLog(TStringList(FTagsList[i])[3]+' ['+TStringList(FTagsList[i])[0]+']'+IfThen(TStringList(FTagsList[i])[2] <> '',' (Dependency: '+TStringList(FTagsList[i])[2]+')','')+ ' - ' + TStringList(FTagsList[i])[1] ,Colors.Info);
    TStringList(FTagsList[i]).Free;
  end;
end;

procedure TRapidDownloadThread.MakeSDD(packageSdpFilePath: string ; sddName: string);
var
  sdpFileStream: TFileStream;
  fileStream: TFileStream;
  decompressedStream: TMemoryStream;
  decompressedFileStream: TFileStream;
  fileNameLength: Byte;
  fileRealName: string;
  fileMd5: array[0..15] of Char;
  fileMd5Str: string;
  fileCRC: Cardinal;
  fileSize: Cardinal;
  fileMd5Path: string;

  sddPath: string;
  destFilePath: string;
  srcFilePath: string;
begin
  try
    if sddName = '' then
      raise Exception.Create('SDD name not specified, sdd creation canceled');

    sdpFileStream := TFileStream.Create(packageSdpFilePath, fmOpenRead);

    decompressedStream := TMemoryStream.Create;
    GZDecompressStream(sdpFileStream,decompressedStream);
    decompressedStream.Seek(0,soFromBeginning);

    SetLength(fileMd5Str,32);

    sddPath := ExtractFilePath(Application.ExeName) + 'mods\' + sddName + '.sdd\';

    while decompressedStream.Position < decompressedStream.Size do
    begin
      if FAbord then
        raise Exception.Create('Download aborted');
      if decompressedStream.Read(fileNameLength,1) <> 1 then
        raise Exception.Create('Corrupted sdp');
      SetLength(fileRealName,fileNameLength);
      if decompressedStream.Read(fileRealName[1],fileNameLength) <> fileNameLength then
        raise Exception.Create('Corrupted sdp');
      if decompressedStream.Read(fileMd5,16) <> 16 then
        raise Exception.Create('Corrupted sdp');
      if decompressedStream.Read(fileCRC,4) <> 4 then
      raise Exception.Create('Corrupted sdp');
      if decompressedStream.Read(fileSize,4) <> 4 then
      raise Exception.Create('Corrupted sdp');
      fileSize := SwapEndian(fileSize);

      BinToHex(@fileMd5[0],PAnsiChar(fileMd5Str),16);

      fileMd5Str := LowerCase(fileMd5Str);

      fileMd5Path :='pool\'+LeftStr(fileMd5Str,2)+'\'+MidStr(fileMd5Str,3,50)+'.gz';

      destFilePath := sddPath+StringReplace( fileRealName, '/', '\', [rfReplaceAll] );   // file real name include the destination relative dir with '/' instead of '\'

      if FileExists(GetMyDocuments+'\My Games\Spring\'+fileMd5Path) then
      begin
        srcFilePath := GetMyDocuments+'\My Games\Spring\'+fileMd5Path;
      end
      else if FileExists(ExtractFilePath(Application.ExeName)+fileMd5Path) then
      begin
        srcFilePath := ExtractFilePath(Application.ExeName)+fileMd5Path;
      end
      else
        raise Exception.Create('Missing package file');

      // make sure the destination file path exists (if not create it)
      MakePath( ExtractFilePath(destFilePath) );

      // decompress the file to its destination
      fileStream := TFileStream.Create(srcFilePath, fmOpenRead);
      decompressedFileStream := TFileStream.Create(destFilePath, fmOpenWrite or fmCreate);
      GZDecompressStream(fileStream,decompressedFileStream);
      FreeAndNil(fileStream);
      FreeAndNil(decompressedFileStream);
    end;
    FreeAndNil(sdpFileStream);
    FreeAndNil(decompressedStream);
  except
    on E:Exception do
    begin
      FreeAndNil(fileStream);
      FreeAndNil(sdpFileStream);
      FreeAndNil(decompressedStream);
      FreeAndNil(decompressedFileStream);

      ExceptionRaised(E.Message);
    end;
  end;
end;

procedure TRapidDownloadThread.RapidDownload(modName: string; rapidName: string; listTagsOnly: boolean);
var
  decompressedStream: TMemoryStream;
  tagListStr: string;
  reposListStr: string;
  reposList: TStringList;
  i: integer;
  decompressedStreamSize: integer;
  tagValue: string;
  tagValues: TStringList;
  currentTagUrl: string;
  tagFound: boolean;
  cp: PChar;
  fileNameLength: Byte;
  fileRealName: string;
  fileMd5: array[0..15] of Char;
  fileMd5Str: string;
  fileCRC: Cardinal;
  fileSize: Cardinal;
  filesBitArray: TBitList;
  fileMd5Path: string;
  fileInfo: PRapidFileInfo;
  bitArrayStream: TMemoryStream;
  compressedBitArray: TMemoryStream;
  filesStream: TFileStream;
  filesList: TList;
  fileContent: string;
  fileStream: TFileStream;
  fileIntSize: integer;
  sdpMemoryStream: TMemoryStream;
  sdpFileStream: TFileStream;
  rcvdStream: TMemoryStream;
  unknownModName: Boolean;
  tagInfo: TStringList;
  sdpFilePath: string;
begin
  try

    FhttpGet := THttpCli.Create(MainForm);

    // first get the repos list from the repos master
    rcvdStream := TMemoryStream.Create;
    FhttpGet.RcvdStream := rcvdStream;
    FhttpGet.URL := RAPID_DOWNLOADER_URL;
    FhttpGet.Get;
    if FAbord then
      Raise Exception.Create('Download aborted');
    decompressedStream := TMemoryStream.Create;
    FhttpGet.RcvdStream.Seek(0,soFromBeginning);
    GZDecompressStream(FhttpGet.RcvdStream,decompressedStream);
    decompressedStream.Seek(0,soFromBeginning);
    decompressedStreamSize := decompressedStream.Size;
    SetLength(reposListStr,decompressedStreamSize);
    decompressedStream.Read(reposListStr[1],decompressedStreamSize);
    FreeAndNil(decompressedStream);
    FreeAndNil(rcvdStream);
    FhttpGet.RcvdStream := nil;

    reposList := TStringList.Create;
    ParseDelimited(reposList,reposListStr,',','');

    // create the tags list
    tagValues := TStringList.Create;

    // then get the tags
    tagFound := false;
    i:=1;
    while i < reposList.Count do
    begin
      try
        currentTagUrl := reposList[i];
        rcvdStream := TMemoryStream.Create;
        FhttpGet.RcvdStream := rcvdStream;
        FhttpGet.URL := currentTagUrl + '/versions.gz';
        FhttpGet.Get;
        if FAbord then
          Raise Exception.Create('Download aborted');
        decompressedStream := TMemoryStream.Create;
        FhttpGet.RcvdStream.Seek(0,soFromBeginning);
        GZDecompressStream(FhttpGet.RcvdStream,decompressedStream);
        decompressedStream.Seek(0,soFromBeginning);
        decompressedStreamSize := decompressedStream.Size;
        SetLength(tagListStr,decompressedStreamSize);
        decompressedStream.Read(tagListStr[1],decompressedStreamSize);
        FreeAndNil(decompressedStream);
        FreeAndNil(rcvdStream);
        FhttpGet.RcvdStream := nil;

        cp := @tagListStr[1];
        while true do
        begin
          tagValue := '';
          tagValues.Clear;
          while (cp^ <> #10) and (cp^ <> #0) do
          begin
            if cp^ = ',' then
            begin
              tagValues.Add(tagValue);
              tagValue := '';
            end
            else
              tagValue := tagValue + cp^;
            Inc(cp);
          end;
          tagValues.Add(tagValue);

          if listTagsOnly then
          begin
            if (tagValues.Count = 4) and ((modName = '') or RegExpr.ExecRegExpr(LowerCase(modName),LowerCase(tagValues[0]) ) or RegExpr.ExecRegExpr(LowerCase(modName),LowerCase(tagValues[2]) ) or RegExpr.ExecRegExpr(LowerCase(modName),LowerCase(tagValues[3]) ) ) then
            begin
              tagInfo := TStringList.Create;
              tagInfo.Assign(tagValues);
              FTagsList.Add(tagInfo);
            end;
          end
          else if (tagValues.Count = 4) and (((tagValues[3] = modName) and (rapidName = '')) or (rapidName = tagValues[0])) then
          begin
            tagFound := true;
            break;
          end;

          if cp^ = #0 then
            break;
          Inc(cp);
        end;

      except
        on E:Exception do
        begin
          FreeAndNil(decompressedStream);
          FreeAndNil(rcvdStream);
          FhttpGet.RcvdStream := nil;

          ExceptionRaised(E.Message);
        end;
      end;

      if tagFound then
        break;

      i := i + 3;
    end;

    if listTagsOnly then
    begin
      Synchronize(TagsListingDone);
      FreeAndNil(FhttpGet);
      FreeAndNil(tagValues);
      Exit;
    end;

    SetLength(fileMd5Str,32);

    unknownModName := False;
    if (tagValues.Count = 4) and (((tagValues[3] = modName) and (rapidName = '')) or (rapidName = tagValues[0])) then
    begin
      FDep := tagValues[2];
      if FDep <> '' then
        Synchronize(DownloadDep);

      sdpMemoryStream := TMemoryStream.Create;
      FhttpGet.RcvdStream := sdpMemoryStream;
      FhttpGet.URL := currentTagUrl+'/packages/'+tagValues[1]+'.sdp';
      FhttpGet.Get;
      if FAbord then
        Raise Exception.Create('Download aborted');
      decompressedStream := TMemoryStream.Create;
      FhttpGet.RcvdStream.Seek(0,soFromBeginning);
      GZDecompressStream(FhttpGet.RcvdStream,decompressedStream);
      FhttpGet.RcvdStream := nil;

      decompressedStream.Seek(0,soFromBeginning);
      filesBitArray := TBitList.Create;
      filesList := TList.Create;
      while decompressedStream.Position < decompressedStream.Size do
      begin
        if FAbord then
          Raise Exception.Create('Download aborted');
        if decompressedStream.Read(fileNameLength,1) <> 1 then
          raise Exception.Create('Corrupted sdp');
        SetLength(fileRealName,fileNameLength);
        if decompressedStream.Read(fileRealName[1],fileNameLength) <> fileNameLength then
          raise Exception.Create('Corrupted sdp');
        if decompressedStream.Read(fileMd5,16) <> 16 then
          raise Exception.Create('Corrupted sdp');
        if decompressedStream.Read(fileCRC,4) <> 4 then
          raise Exception.Create('Corrupted sdp');
        if decompressedStream.Read(fileSize,4) <> 4 then
          raise Exception.Create('Corrupted sdp');
        fileSize := SwapEndian(fileSize);

        BinToHex(@fileMd5[0],PAnsiChar(fileMd5Str),16);

        fileMd5Str := LowerCase(fileMd5Str);

        fileMd5Path :='pool\'+LeftStr(fileMd5Str,2)+'\'+MidStr(fileMd5Str,3,50)+'.gz';

        if not (FileExists(GetMyDocuments+'\My Games\Spring\'+fileMd5Path) or FileExists(ExtractFilePath(Application.ExeName)+fileMd5Path)) then
        begin
          New(fileInfo);
          fileInfo.Size := fileSize;
          fileInfo.Md5 := fileMd5Str;
          fileInfo.crc := fileCRC;
          fileInfo.realName := fileRealName;
          fileInfo.poolPath := fileMd5Path;
          filesList.Add(fileInfo);
          filesBitArray.AddBit(True);
        end
        else
          filesBitArray.AddBit(False);
      end;

      bitArrayStream := TMemoryStream.Create;
      filesBitArray.WriteDataToStream(bitArrayStream);
      FreeAndNil(filesBitArray);
      bitArrayStream.Seek(0,soFromBeginning);
      compressedBitArray := TMemoryStream.Create;
      GZCompressStream(bitArrayStream,compressedBitArray);
      FreeAndNil(bitArrayStream);
      compressedBitArray.Seek(0,soFromBeginning);

      FhttpPost := THttpCli.Create(MainForm);
      filesStream := TFileStream.Create(tagValues[1]+'.bin',fmOpenWrite or fmCreate);
      FhttpPost.RcvdStream := filesStream;
      FhttpPost.SendStream := compressedBitArray;
      FhttpPost.URL := currentTagUrl+'/streamer.cgi?'+tagValues[1];
      FhttpPost.OnDocData := DownloadDocData;
      Synchronize(DownloadStart);
      FhttpPost.Post;
      if FAbord then
        Raise Exception.Create('Download aborted');

      filesStream.Seek(0,soFromBeginning);

      i := 0;
      while filesStream.Read(fileSize,4) = 4 do
      begin
        if FAbord then
          Raise Exception.Create('Download aborted');
        if i >= filesList.Count then
          raise Exception.Create('Too many files streamed');
        fileSize := SwapEndian(fileSize);
        if fileSize > MaxInt then
          Exception.Create('Incorrect streamed file size');
        fileIntSize := fileSize;

        SetLength(fileContent,fileIntSize);
        if filesStream.Read(fileContent[1],fileIntSize) <> fileIntSize then
          raise Exception.Create('Corrupted streamer data');

        MakePath(ExtractFilePath(ExtractFilePath(Application.ExeName)+PRapidFileInfo(filesList[i]).poolPath));
        fileStream := TFileStream.Create(ExtractFilePath(Application.ExeName)+PRapidFileInfo(filesList[i]).poolPath,fmOpenWrite or fmCreate);
        if fileStream.Write(fileContent[1],fileIntSize) <> fileIntSize then
        begin
          FreeAndNil(fileStream);
          DeleteFile(ExtractFilePath(Application.ExeName)+PRapidFileInfo(filesList[i]).poolPath);
          raise Exception.Create('Rapid file writing failed');
        end;
        FreeAndNil(fileStream);

        Inc(i);
      end;
      if i < filesList.Count then
        raise Exception.Create('Incorrect number of files received');

      sdpMemoryStream.Seek(0,soFromBeginning);
      MakePath(ExtractFilePath(Application.ExeName)+'packages');
      sdpFilePath := ExtractFilePath(Application.ExeName)+'packages\'+tagValues[1]+'.sdp';
      sdpFileStream := TFileStream.Create(sdpFilePath, fmOpenWrite or fmCreate);
      if sdpFileStream.CopyFrom(sdpMemoryStream,sdpMemoryStream.Size) <> sdpMemoryStream.Size then
      begin
        FreeAndNil(sdpMemoryStream);
        DeleteFile(ExtractFilePath(Application.ExeName)+'packages\'+tagValues[1]+'.sdp');
        raise Exception.Create('Sdp file write failed');
      end;
      FreeAndNil(sdpMemoryStream);
      FreeAndNil(sdpFileStream);

      for i:=0 to filesList.Count-1 do
        FreeMem(PRapidFileInfo(filesList[i]));
      FreeAndNil(filesList);
      FreeAndNil(filesStream);
      FreeAndNil(compressedBitArray);
      FreeAndNil(FhttpPost);
      DeleteFile(tagValues[1]+'.bin');
    end
    else
      unknownModName := True;

    if FAbord then
      Raise Exception.Create('Download aborted');

    FreeAndNil(tagValues);
    FreeAndNil(FhttpGet);

    if FDlerForm <> nil then
      if unknownModName then
      begin
        if Debug.Enabled then
          MainForm.AddMainLog('Rapid download failed: unknown mod name',Colors.Info);
        Synchronize(FDlerForm.NormalDownload);
      end
      else
      begin
        if FMakeSDD then
          MakeSDD(sdpFilePath, FSDDDir);
        Synchronize(DownloadDone);
      end;
  except
    on E:Exception do
    begin
      FreeAndNil(filesStream);
      if tagValues <> nil then
        if tagValues.Count = 4 then
          if FileExists(tagValues[1]+'.bin') then
            DeleteFile(tagValues[1]+'.bin');

      FreeAndNil(rcvdStream);
      if filesList <> nil then
        for i:=0 to filesList.Count-1 do
          FreeMem(PRapidFileInfo(filesList[i]));
      FreeAndNil(filesList);
      FreeAndNil(compressedBitArray);
      FreeAndNil(decompressedStream);
      FreeAndNil(FhttpPost);
      FreeAndNil(tagValues);
      FreeAndNil(FhttpGet);
      FreeAndNil(sdpMemoryStream);
      FreeAndNil(sdpFileStream);
      FreeAndNil(fileStream);
      FreeAndNil(bitArrayStream);
      FreeAndNil(filesBitArray);

      ExceptionRaised(E.Message);
    end;
  end;
end;

constructor TRapidDownloadThread.Create(Suspended : Boolean; dlerForm: TSpringDownloaderForm; modName: string; rapidName: string; listTagsOnly: boolean; makeSDD: boolean ; sddDir: string );
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);
   OnTerminate := OnTerminateProcedure;

   FModName := modName;
   FRapidName := rapidName;
   FDlerForm := dlerForm;
   FAbord := False;
   FListTagsOnly := listTagsOnly;
   FTagsList := TList.Create;
   FMakeSDD := makeSDD;
   FSDDDir := sddDir;

  if Debug.Enabled then
     MainForm.AddMainLog('Rapid download started: '+FModName+' ['+FRapidName+']',Colors.Info);
end;

procedure TRapidDownloadThread.Abort;
begin
  try
    if FhttpGet <> nil then
      FhttpGet.Abort;
  except
  end;
  try
    if FhttpPost <> nil then
      FhttpPost.Abort;
  except
  end;
  FAbord := True;
end;

procedure TRapidDownloadThread.RaiseException;
begin
  if FDlerForm <> nil then
    FDlerForm.DownloadProgress(0,0,false,true,true,FExceptionMsg);
  if Debug.Enabled then
     MainForm.AddMainLog('Rapid download failed: '+FExceptionMsg,Colors.Info);
end;

procedure TRapidDownloadThread.ExceptionRaised(msg: string);
begin
  FExceptionMsg := msg;
  Synchronize(RaiseException);
end;

procedure TRapidDownloadThread.DownloadDocData(Sender: TObject; Buffer: Pointer; Len: Integer);
begin
  if FDlerForm <> nil then
    FDlerForm.DownloadProgress(THttpCli(Sender).RcvdStream.Size,THttpCli(Sender).ContentLength);
end;

procedure TScriptRapidListThread.TagsListingDone;
var
  i: integer;
  pyTagsList: PPyObject;
  pyTag: PPyObject;
begin
  AcquireMainThread;
  with GetPythonEngine do
  begin
    pyTagsList := PyList_New(FTagsList.Count);
    for i:=0 to FTagsList.Count-1 do
    begin
      pyTag := PyDict_New();

      PyDict_SetItemStringDecRef( pyTag, 'FullName', TStringList(FTagsList[i])[3] );
      PyDict_SetItemStringDecRef( pyTag, 'Tag', TStringList(FTagsList[i])[0] );
      PyDict_SetItemStringDecRef( pyTag, 'Dependency', TStringList(FTagsList[i])[2] );
      PyDict_SetItemStringDecRef( pyTag, 'Hash', TStringList(FTagsList[i])[1] );

      PyList_Insert(pyTagsList,i,pyTag);
      Py_XDECREF(pyTag);

      TStringList(FTagsList[i]).Free;
    end;

    PyList_Insert(FCallBack.args,0,pyTagsList);
    try
      EvalPyFunction(FCallBack.func,PyList_AsTuple(FCallBack.args))
    except
    end;


    FreeMem(FCallBack);
  end;
  ReleaseMainThread;
end;

constructor TScriptRapidListThread.Create(Suspended : Boolean; callBack : PScriptSimpleCallback);
begin
  inherited Create(Suspended,nil,'','',True);

  FCallBack := callBack;
end;

end.
