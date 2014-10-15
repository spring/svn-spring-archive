unit ProgressBarWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, SpTBXControls,ReplaysUnit,UploadReplayUnit,
  BattleFormUnit, TB2Item;

type
  TProgressBarForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    TBControlItem1: TTBControlItem;
    pnlMain: TSpTBXPanel;
    pb: TSpTBXProgressBar;
    CancelButton: TSpTBXButton;
    procedure FormActivate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    ThreadUp :TUploadThread;
  public
    TakeAction : byte;
  end;

var
  ProgressBarForm: TProgressBarForm;

implementation

uses Misc, gnugettext;

{$R *.dfm}

procedure TProgressBarForm.FormActivate(Sender: TObject);
begin
  ProgressBarForm.Visible := True;
  ProgressBarForm.Show;
  ProgressBarForm.Refresh;
  CancelButton.Enabled := True;
  if TakeAction = 1 then begin
    ProgressBarForm.SpTBXTitleBar1.Caption := _('Uploading your replay ...');
    ThreadUp := TUploadThread.Create(False);
  end;
end;

procedure TProgressBarForm.CancelButtonClick(Sender: TObject);
begin
  UploadReplayForm.IdHTTP1.Disconnect;
end;

procedure TProgressBarForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
