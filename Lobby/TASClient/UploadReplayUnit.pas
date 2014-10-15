unit UploadReplayUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, StdCtrls, ComCtrls, SpTBXControls, MsMultiPartFormData,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdAntiFreezeBase, IdAntiFreeze,Misc,Clipbrd, SpTBXEditors,MainUnit;

type
  TUploadReplayForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    SpTBXGroupBox1: TSpTBXGroupBox;
    DescriptionRtBox: TRichEdit;
    SpTBXGroupBox2: TSpTBXGroupBox;
    UploadButton: TSpTBXButton;
    CancelButton: TSpTBXButton;
    DeleteButton: TSpTBXButton;
    procedure UploadButtonClick(Sender: TObject);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure FormActivate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations }
  public
    Description : string;
    FileName : string;
    MapName : string;
    ModName : string;
    NbPlayers : string;
    UploadedReplayId : string;
    AutoUpload: boolean;
  end;
  TUploadThread = class(TTASClientThread)
  private
    procedure UploadReplay;
    procedure OnTerminateProcedure(Sender : TObject);
 
  protected
    procedure Execute; override;
  public
    constructor Create(Suspended : Boolean);
  end;
var
  UploadReplayForm: TUploadReplayForm;

implementation

uses ProgressBarWindow, ReplaysUnit, PreferencesFormUnit, gnugettext;

{$R *.dfm}

procedure TUploadReplayForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TUploadReplayForm.UploadButtonClick(Sender: TObject);
begin
  if not PreferencesForm.isLoggedOnOfficialServer then
  begin
    MessageDlg(_('You need to be logged into the official server to be able to upload replays using the lobby.'),mtWarning,[mbOk],0);
    Exit;
  end;
  ProgressBarForm.TakeAction := 1;
  ProgressBarForm.ShowModal;
end;

procedure TUploadThread.UploadReplay;
var
  ResponseStream: TMemoryStream;
  ResponseStr : string;
  MultiPartFormDataStream: TMsMultiPartFormDataStream;
  ResponseStrList : TStrings;
begin
  with UploadReplayForm do begin
  MultiPartFormDataStream := TMsMultiPartFormDataStream.Create;
  ResponseStream := TMemoryStream.Create;
  ResponseStrList := TStringList.Create;
  try
    IdHttp1.Request.ContentType := MultiPartFormDataStream.RequestContentType;
    MultiPartFormDataStream.AddFormField('postdata[lobbynick]', Preferences.Username);
    MultiPartFormDataStream.AddFormField('postdata[description]', DescriptionRtBox.Text);
    MultiPartFormDataStream.AddFormField('submit', 'submit');
    MultiPartFormDataStream.AddFile('tiedosto', FileName , 'application/octet-stream');
    { You must make sure you call this method *before* sending the stream }
    MultiPartFormDataStream.PrepareStreamForDispatch;
    MultiPartFormDataStream.Position := 0;
    ProgressBarForm.Refresh;
    ProgressBarForm.pb.Max := MultiPartFormDataStream.Size;
    ProgressBarForm.pb.Position := 0;

    IdHTTP1.Post('http://replays.adune.nl/?act=upload&do=upload&secretzon=lamafaarao', MultiPartFormDataStream, ResponseStream);
    ResponseStream.Seek(0,0);
    SetLength(ResponseStr, ResponseStream.Size);
    ResponseStream.ReadBuffer(Pointer(ResponseStr)^, ResponseStream.Size);
  except
    MultiPartFormDataStream.Free;
    ResponseStream.Free;
    PostMessage(ProgressBarForm.Handle, WM_CLOSE, 0, 0); // close form
    MainForm.AddMainLog(_('Replays server unavailable or upload cancelled !'),Colors.Error);
    MessageDlgThread(_('Replays server unavailable or upload cancelled !'),mtError,[mbOK],0);
    PostMessage(Handle, WM_CLOSE, 0, 0); // close form
  end;
  MultiPartFormDataStream.Free;
  ResponseStream.Free;
  PostMessage(ProgressBarForm.Handle, WM_CLOSE, 0, 0); // close form
  Misc.ParseDelimited(ResponseStrList,ResponseStr,' ','');
  if (ResponseStrList.Count > 0) and (ResponseStrList[0] = 'SUCCESS') then begin
    MessageDlgThread(_('Your replay has been successfully uploaded. Its link has been added to your clipboard.'), mtInformation,[mbOk], 0);
    Clipboard.Open;
    Clipboard.SetTextBuf(PChar(ResponseStrList[1]));
    Clipboard.Close;
    UploadedReplayId := ResponseStrList[1];
  end
  else if ResponseStrList[0] = 'FAILURE' then
    if ResponseStrList[1] = '1' then
      MessageDlgThread(_('The upload failed : check the replay filetype. Contact TradeMark in the lobby to get help.'), mtError,[mbOk], 0)
    else if ResponseStrList[1] = '2' then
      MessageDlgThread(_('The upload failed : error while uploading the file. Contact TradeMark in the lobby to get help.'), mtError,[mbOk], 0)
    else if ResponseStrList[1] = '3' then
      MessageDlgThread(_('The upload failed : this replay has already been uploaded. Contact TradeMark in the lobby to get help.'), mtError,[mbOk], 0)
    else if ResponseStrList[1] = '4' then
      MessageDlgThread(_('The upload failed : wrong file format. Contact TradeMark in the lobby to get help.'), mtError,[mbOk], 0)
    else
      MessageDlgThread(Format(_('The upload failed : "%s"%sContact TradeMark in the lobby to get help.'),[ResponseStr,EOL]), mtError,[mbOk], 0)
  else
      MessageDlgThread(Format(_('The upload failed : "%s"%sContact TradeMark in the lobby to get help.'),[ResponseStr,EOL]), mtError,[mbOk], 0);
  PostMessage(Handle, WM_CLOSE, 0, 0); // close form
  end;
end;

procedure TUploadReplayForm.IdHTTP1Work(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  ProgressBarForm.pb.Position := AWorkCount;
  ProgressBarForm.Refresh;
end;

procedure TUploadReplayForm.FormActivate(Sender: TObject);
begin
  DescriptionRtBox.Text := Description;
  Description := '';
end;

constructor TUploadThread.Create(Suspended: Boolean);
begin
   FreeOnTerminate := True;
   inherited Create(Suspended);      
   OnTerminate := OnTerminateProcedure;
end;

procedure TUploadThread.Execute;
begin
  UploadReplay;
end;

procedure TUploadThread.OnTerminateProcedure(Sender: TObject);
begin
  // nothing
end;

procedure TUploadReplayForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TUploadReplayForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TUploadReplayForm.DeleteButtonClick(Sender: TObject);
begin
  DeleteFile(FileName);
  if not AutoUpload then
    ReplaysForm.ReloadButtonClick(nil);
  Close;
end;

end.
