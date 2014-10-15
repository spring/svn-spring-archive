unit TipsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, JvGIF, ExtCtrls, StdCtrls, SpTBXControls,
  TntStdCtrls,JclUnicode, Math;

type
  TTip = record
    Msg: string;
    Form: integer;
  end;
  PTip = ^TTip;

  TTipsForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    btNextTip: TSpTBXButton;
    chkShowTips: TSpTBXCheckBox;
    SpTBXPanel1: TSpTBXPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    mmTip: TTntMemo;
    procedure FormCreate(Sender: TObject);
    procedure btNextTipClick(Sender: TObject);
  protected
    TipList: TList;
    CurrentFormTipList: TList;
    currentForm: integer;
    currentTip: integer;
  private
    { Private declarations }
  public
    property Tips : TList read TipList;
    procedure LoadTips;
    procedure ShowTips(tipType: integer = 0; forceShow: boolean = false);
  end;

var
  TipsForm: TTipsForm;

implementation

uses Misc,MainUnit, StrUtils, BattleFormUnit, ReplaysUnit, PreferencesFormUnit, gnugettext;

{$R *.dfm}

procedure TTipsForm.LoadTips;
var
  rawTips : string;
  rawTipsList: TStringList;
  rawTip: string;
  t : PTip;
  i,j: integer;
  tipAdded: boolean;
begin
  try
    rawTips := ReadFile2(ExtractFilePath(Application.ExeName) + TIPS_FILE);
  except
    MessageDlg(ExtractFilePath(Application.ExeName) + VAR_FOLDER+_('\tips.txt not found.'),mtError,[mbOK],0);
    Exit;
  end;

  rawTipsList := TStringList.Create;
  ParseDelimited(rawTipsList,rawTips,EOL+'##','');

  for i:=0 to rawTipsList.Count-1 do
  begin
    rawTip := rawTipsList[i];
    if rawTip = '' then
      Continue;

    New(t);
    t.Msg := MidStr(rawTip,3,High(Integer));
    t.Form := StrToInt(rawTip[1]);

    TipList.Add(t);

  end;
end;

procedure TTipsForm.ShowTips(tipType: integer = 0; forceShow: boolean = false);
var
  i: integer;
begin
  if TipList.Count = 0 then Exit;
  if not chkShowTips.Checked and not forceShow then Exit;

  currentForm := tipType;

  CurrentFormTipList.Clear;
  for i := 0 to TipList.Count-1 do
    if PTip(TipList[i]).Form = currentForm then
      CurrentFormTipList.Add(TipList[i]);

  if CurrentFormTipList.Count > 0 then
  begin
    currentTip := -1;
    btNextTipClick(nil);
    Show;
  end;
end;

procedure TTipsForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  
  TipList := TList.Create;
  CurrentFormTipList := TList.Create;
end;

procedure TTipsForm.btNextTipClick(Sender: TObject);
var
  i: integer;
  firstPrio0 : integer;
  rnd : integer;
begin
  rnd := RandomRange(0,CurrentFormTipList.Count-1);;
  while (rnd = currentTip) and (CurrentFormTipList.Count > 1) do
    rnd := RandomRange(0,CurrentFormTipList.Count-1);
  currentTip := rnd;

  mmTip.Text := PTip(CurrentFormTipList[currentTip]).Msg;
end;

end.
