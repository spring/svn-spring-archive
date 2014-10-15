{
  We use this form when we wait for unitsync.dll to finish reinitialization or when getting unit
  list, etc.
}
unit InitWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TInitWaitForm = class(TForm)
    InfoLabel: TLabel;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure ChangeCaption(Caption: string);

    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    TakeAction: Byte; // 0 - load mod, 1 - get unit lists, 2 - load minimap
  end;

const
  MSG_MODCHANGE = 'Reading mod file ...';
  MSG_GETUNITS = 'Generating unit list ...';

var
  InitWaitForm: TInitWaitForm;
  InProgress: Boolean = False;

implementation

uses BattleFormUnit, Utility, HostBattleFormUnit, PreferencesFormUnit;

{$R *.dfm}

procedure TInitWaitForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not PreferencesFormUnit.Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := BattleForm.Handle;
  end;
end;

procedure TInitWaitForm.ChangeCaption(Caption: string);
begin
  InfoLabel.Caption := Caption;
  InfoLabel.Left := InitWaitForm.ClientWidth div 2 - InitWaitForm.Canvas.TextWidth(InfoLabel.Caption) div 2;
end;

procedure TInitWaitForm.FormActivate(Sender: TObject);
var
  time: cardinal;
begin
  if InProgress then Exit;

  InProgress := True;

  InitWaitForm.Repaint;

  time := gettickcount;
  if TakeAction = 0 then
    BattleForm.ChangeCurrentMod(HostBattleForm.ModsComboBox.Text)
  else if TakeAction = 1 then
    GetUnitList(UnitNames, UnitList)
  else ; // ?
  //*** showmessage(inttostr(gettickcount - time) + ' ms');

  PostMessage(Handle, WM_CLOSE, 0, 0); // close form

  InProgress := False;
end;

procedure TInitWaitForm.FormCreate(Sender: TObject);
begin
  InitWaitForm.Font.Assign(InfoLabel.Font); // we need this because we call Canvas.GetTextWidth!
end;

end.
