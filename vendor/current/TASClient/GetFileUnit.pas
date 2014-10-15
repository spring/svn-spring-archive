unit GetFileUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit1, ComCtrls;

type
  TGetFileForm = class(TForm)
    CloseButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    FilenameLabel: TLabel;
    SizeLabel: TLabel;
    DownloadProgressBar: TProgressBar;
    Label3: TLabel;
    ProgressLabel: TLabel;
    CancelButton: TButton;
    Label4: TLabel;
    StatusLabel: TLabel;

    procedure OnStartTransferMessage(var Msg: TMessage); message WM_STARTTRANSFER;
    procedure OnUpdateTransferMessage(var Msg: TMessage); message WM_UPDATETRANSFER;

    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GetFileForm: TGetFileForm;

  GetFile:
  record
    ToFile: file of Byte; // must be initialized by sender of WM_STARTTRANSFER message
    Receiving: Boolean;
    Size: Integer;        // must be initialized by sender of WM_STARTTRANSFER message
    Options: Integer;     // must be initialized by sender of WM_STARTTRANSFER message
    Filename: string;     // must be initialized by sender of WM_STARTTRANSFER message
    Position: Integer;
  end;

implementation

uses
  ShellAPI;

{$R *.dfm}             

procedure TGetFileForm.OnStartTransferMessage(var Msg: TMessage); // responds to WM_STARTTRANSFER message
begin
  GetFile.Position := 0;
  FilenameLabel.Caption := GetFile.Filename;
  SizeLabel.Caption := IntToStr(GetFile.Size) + ' bytes';
  StatusLabel.Caption := 'Transfering ...';
  ProgressLabel.Caption := '0 / ' + IntToStr(GetFile.Size) + ' bytes';
  CloseButton.Enabled := False;
  CancelButton.Enabled := True;
  GetFileForm.ShowModal;
end;

procedure TGetFileForm.OnUpdateTransferMessage(var Msg: TMessage); // responds to WM_UPDATETRANSFER message
var
  s: string;
begin
  DownloadProgressBar.Position := Round((GetFile.Position / GetFile.Size) * 100);
  ProgressLabel.Caption := IntToStr(GetFile.Position) + ' / ' + IntToStr(GetFile.Size) + ' bytes';
  if GetFile.Position = GetFile.Size then
  begin
    GetFile.Receiving := False;
    StatusLabel.Caption := 'Transfer complete.';
    MainForm.AddMainLog('File transfer complete (' + GetFile.Filename + ')', Colors.Info);
    CancelButton.Enabled := False;
    CloseButton.Enabled := True;
    CloseFile(GetFile.ToFile);
    s := GetFile.Filename;

    if (GetFile.Options and $1) = 1 then
    begin
      if MessageDlg('Server says you should now open this file. Would you like to do that now?', mtInformation, [mbYes, mbNo], 0) = mrYes then
      begin
        ShellExecute(Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + s), nil, nil, SW_SHOWNORMAL);
        if (GetFile.Options and $2) = 2 then MainForm.Close;
      end;
    end
    else
      MessageDlg('Download complete!', mtInformation, [mbOK], 0);

  end;
end;

procedure TGetFileForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TGetFileForm.FormCreate(Sender: TObject);
begin
  GetFile.Receiving := False;
end;

procedure TGetFileForm.CancelButtonClick(Sender: TObject);
begin
  GetFile.Receiving := False;
  StatusLabel.Caption := 'Transfer cancelled.';
  CancelButton.Enabled := False;
  CloseButton.Enabled := True;
  MainForm.TryToSendData('CANCELTRANSFER');
  MainForm.AddMainLog('File transfer cancelled (' + GetFile.Filename + ')', Colors.Info);
  CloseFile(GetFile.ToFile);
end;

end.
