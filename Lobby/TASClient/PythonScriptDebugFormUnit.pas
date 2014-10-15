unit PythonScriptDebugFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, PythonEngine, MainUnit;

type
  TPythonScriptDebugForm = class(TForm)
    Output: TMemo;
    pnlTopToolbar: TPanel;
    btClear: TButton;
    btReloadScripts: TButton;
    btLoadNewScripts: TButton;
    Splitter1: TSplitter;
    pnlTestCode: TPanel;
    lblTestCode: TLabel;
    memCode: TMemo;
    pnlBottomToolbar: TPanel;
    btExecute: TButton;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure btClearClick(Sender: TObject);
    procedure btReloadScriptsClick(Sender: TObject);
    procedure btLoadNewScriptsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure OnRefreshOutputMessage(var Msg: TMessage); message WM_REFRESHOUTPUT;
    procedure btExecuteClick(Sender: TObject);
  private
    { Private declarations }
  public
    debugOutput: TFileStream;
  end;

var
  PythonScriptDebugForm: TPythonScriptDebugForm;
  printList: TStringList;

implementation

uses LobbyScriptUnit, PreferencesFormUnit, gnugettext, Misc;

{$R *.dfm}

procedure TPythonScriptDebugForm.btClearClick(Sender: TObject);
begin
  Output.Clear;
end;

procedure TPythonScriptDebugForm.btReloadScriptsClick(Sender: TObject);
begin
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers._reloadall; except end;
  ReleaseMainThread;
end;

procedure TPythonScriptDebugForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TPythonScriptDebugForm.btLoadNewScriptsClick(Sender: TObject);
begin
  AcquireMainThread;
  try if not Preferences.ScriptsDisabled then handlers._load; except end;
  ReleaseMainThread;
end;

procedure TPythonScriptDebugForm.FormCreate(Sender: TObject);
var
  s: string;
  FileName: string;
  fh: integer;
begin
  TranslateComponent(self);

  FileName := ExtractFilePath(Application.ExeName)+'TASClient_Scripts.log';
  
  printList := TStringList.Create;
  try
    if not FileExists(FileName) then
    begin
      fh := FileCreate(FileName);
      if fh = -1 then Exit;
      FileClose(fh);
    end;

    debugOutput := TFileStream.Create(FileName,fmOpenReadWrite or fmShareDenyNone);
    debugOutput.Position := debugOutput.Size;
    Misc.TryToAddLog(debugOutput,EOL+'--------------------');
    Misc.TryToAddLog(debugOutput,DateToStr(Date)+' - '+TimeToStr(Time));
    Misc.TryToAddLog(debugOutput,'--------------------'+EOL);
  except
    debugOutput := nil;
  end;

end;

procedure TPythonScriptDebugForm.OnRefreshOutputMessage(var Msg: TMessage);
var
  s: string;
begin
  if printList.Count = 0 then Exit;
  Output.Lines.AddStrings(printList);
  Misc.TryToAddLog(debugOutput,printList.GetText);
  //printList.BeginUpdate;
  printList.Clear;
  //printList.EndUpdate;
  Output.SelStart := Output.GetTextLen;
  Output.Perform(EM_SCROLLCARET,0,0);
end;



procedure TPythonScriptDebugForm.btExecuteClick(Sender: TObject);
begin
  AcquireMainThread;
  GetPythonEngine.ExecStrings(memCode.Lines);
  ReleaseMainThread;
end;

end.
