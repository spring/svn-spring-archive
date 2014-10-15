unit ProgressBarWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, TBXDkPanels, SpTBXControls,ReplaysUnit,UploadReplayUnit,BattleFormUnit;

type
  TProgressBarForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    pb: TSpTBXProgressBar;
    CancelButton: TSpTBXButton;
    procedure FormActivate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    ThreadUp :TUploadThread;
    ThreadLadderUp : TUploadLadderDataThread;
  public
    TakeAction : byte;
  end;

var
  ProgressBarForm: TProgressBarForm;

implementation

//uses ;

{$R *.dfm}

procedure TProgressBarForm.FormActivate(Sender: TObject);
begin
  ProgressBarForm.Visible := True;
  ProgressBarForm.Show;
  ProgressBarForm.Refresh;
  CancelButton.Enabled := True;
  if TakeAction = 1 then begin
    ProgressBarForm.SpTBXTitleBar1.Caption := 'Uploading your replay ...';
    ThreadUp := TUploadThread.Create(False);
  end
  else if TakeAction = 2 then begin
    ProgressBarForm.SpTBXTitleBar1.Caption := 'Uploading ladder report ...';
    ThreadLadderUp := TUploadLadderDataThread.Create(False);
    CancelButton.Enabled := False;
  end;
end;

procedure TProgressBarForm.CancelButtonClick(Sender: TObject);
begin
  UploadReplayForm.IdHTTP1.Disconnect;
end;

end.
