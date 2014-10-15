unit UploadReplayUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, StdCtrls, ComCtrls, SpTBXControls, TBXDkPanels,MsMultiPartFormData,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdAntiFreezeBase, IdAntiFreeze,Misc,Clipbrd, SpTBXEditors,MainUnit;

type
  TUploadReplayForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    SpTBXLabel1: TSpTBXLabel;
    SpTBXLabel2: TSpTBXLabel;
    CancelButton: TSpTBXButton;
    UploadButton: TSpTBXButton;
    DescriptionRtBox: TRichEdit;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    TitleEdit: TSpTBXEdit;
    procedure UploadButtonClick(Sender: TObject);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure FormActivate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    Title : string;
    FileName : string;
    MapName : string;
    ModName : string;
    NbPlayers : string;
    UploadedReplayId : string;
  end;
  TUploadThread = class(TDialogThread)
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

uses ProgressBarWindow, ReplaysUnit;

{$R *.dfm}

procedure TUploadReplayForm.UploadButtonClick(Sender: TObject);
begin
  if (TitleEdit.Text = '') then begin
    MessageDlg('You must enter a title before upload !',mtWarning,[mbOk],0);
    Exit;
  end;
  if Length(TitleEdit.Text) < 8 then begin
    MessageDlg('Title too short (8char min) !',mtWarning,[mbOk],0);
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
    MultiPartFormDataStream.AddFormField('title', TitleEdit.Text);
    MultiPartFormDataStream.AddFormField('description', DescriptionRtBox.Text);
    MultiPartFormDataStream.AddFormField('submit', 'submit');
    MultiPartFormDataStream.AddFormField('MAX_FILE_SIZE', '2097152');
    MultiPartFormDataStream.AddFile('replay', FileName , 'application/octet-stream');
    { You must make sure you call this method *before* sending the stream }
    MultiPartFormDataStream.PrepareStreamForDispatch;
    MultiPartFormDataStream.Position := 0;
    ProgressBarForm.Refresh;
    ProgressBarForm.pb.Max := MultiPartFormDataStream.Size;
    ProgressBarForm.pb.Position := 0;
    IdHTTP1.Post('http://replays.unknown-files.net/upload_bot.php', MultiPartFormDataStream, ResponseStream);
    ResponseStream.Seek(0,0);
    SetLength(ResponseStr, ResponseStream.Size);
    ResponseStream.ReadBuffer(Pointer(ResponseStr)^, ResponseStream.Size);
  except
    MultiPartFormDataStream.Free;
    ResponseStream.Free;
    PostMessage(ProgressBarForm.Handle, WM_CLOSE, 0, 0); // close form
    MainForm.AddMainLog('Replays server unavailable !',Colors.Error);
    MessageDlgThread('Replays server unavailable !',mtError,[mbOK],0);
    PostMessage(Handle, WM_CLOSE, 0, 0); // close form
  end;
  MultiPartFormDataStream.Free;
  ResponseStream.Free;
  PostMessage(ProgressBarForm.Handle, WM_CLOSE, 0, 0); // close form
  Misc.ParseDelimited(ResponseStrList,ResponseStr,' ','');
  if (ResponseStrList.Count > 0) and (ResponseStrList[0] = 'SUCCESS') then begin
    MessageDlgThread('Your replay has been successfully uploaded. Its link has been added to your clipboard.', mtInformation,[mbOk], 0);
    Clipboard.Open;
    Clipboard.SetTextBuf(PChar('http://replays.unknown-files.net/?'+ResponseStrList[1]));
    Clipboard.Close;
    UploadedReplayId := ResponseStrList[1];
  end
  else
    MessageDlgThread(ResponseStr, mtError,[mbOk], 0);
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
  DescriptionRtBox.Text := '';
  if Title <> '' then
    TitleEdit.Text := Title
  else
    TitleEdit.Text := NbPlayers +' @ ' +MapName+' @ '+ModName;
  Title := '';
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
  PostMessage(Handle, WM_CLOSE, 0, 0); // close form
end;

end.
