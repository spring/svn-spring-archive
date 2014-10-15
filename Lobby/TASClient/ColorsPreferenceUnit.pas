unit ColorsPreferenceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, SpTBXControls, ExtCtrls, Misc,MainUnit,IniFiles,
  TntComCtrls,SpTBXEditors,RichEdit2, ExRichEdit,TntStdCtrls, TB2Item,
  Menus;

type
  TColorsPreference = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    btOk: TSpTBXButton;
    btRest: TSpTBXButton;
    btCancel: TSpTBXButton;
    SpTBXGroupBox1: TSpTBXGroupBox;
    SpTBXLabel1: TSpTBXLabel;
    Panel0: TPanel;
    SpTBXButton0: TSpTBXButton;
    SpTBXButton1: TSpTBXButton;
    Panel1: TPanel;
    SpTBXLabel3: TSpTBXLabel;
    SpTBXLabel4: TSpTBXLabel;
    Panel2: TPanel;
    SpTBXButton2: TSpTBXButton;
    SpTBXButton3: TSpTBXButton;
    Panel3: TPanel;
    SpTBXLabel5: TSpTBXLabel;
    SpTBXLabel6: TSpTBXLabel;
    Panel4: TPanel;
    SpTBXButton4: TSpTBXButton;
    SpTBXButton5: TSpTBXButton;
    Panel5: TPanel;
    SpTBXLabel7: TSpTBXLabel;
    SpTBXLabel8: TSpTBXLabel;
    Panel6: TPanel;
    SpTBXButton6: TSpTBXButton;
    SpTBXLabel9: TSpTBXLabel;
    SpTBXLabel10: TSpTBXLabel;
    SpTBXLabel11: TSpTBXLabel;
    Panel7: TPanel;
    SpTBXButton7: TSpTBXButton;
    Panel8: TPanel;
    SpTBXButton8: TSpTBXButton;
    Panel9: TPanel;
    SpTBXButton9: TSpTBXButton;
    SpTBXGroupBox2: TSpTBXGroupBox;
    SpTBXButton10: TSpTBXButton;
    Panel10: TPanel;
    SpTBXLabel2: TSpTBXLabel;
    SpTBXLabel12: TSpTBXLabel;
    Panel11: TPanel;
    SpTBXButton11: TSpTBXButton;
    SpTBXLabel14: TSpTBXLabel;
    Panel12: TPanel;
    SpTBXButton12: TSpTBXButton;
    SpTBXLabel13: TSpTBXLabel;
    Panel13: TPanel;
    SpTBXButton13: TSpTBXButton;
    SpTBXLabel15: TSpTBXLabel;
    Panel14: TPanel;
    SpTBXButton14: TSpTBXButton;
    SpTBXGroupBox3: TSpTBXGroupBox;
    lblFontName: TSpTBXLabel;
    SpTBXButton15: TSpTBXButton;
    FontDialog1: TFontDialog;
    SpTBXLabel16: TSpTBXLabel;
    Panel15: TPanel;
    SpTBXButton16: TSpTBXButton;
    SpTBXLabel17: TSpTBXLabel;
    Panel16: TPanel;
    SpTBXButton17: TSpTBXButton;
    SpTBXLabel18: TSpTBXLabel;
    Panel17: TPanel;
    SpTBXButton18: TSpTBXButton;
    btLoad: TSpTBXButton;
    btSave: TSpTBXButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ResetColorsPopupMenu: TSpTBXPopupMenu;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    SpTBXLabel19: TSpTBXLabel;
    Panel18: TPanel;
    SpTBXButton19: TSpTBXButton;
    SpTBXLabel20: TSpTBXLabel;
    Panel19: TPanel;
    SpTBXButton20: TSpTBXButton;
    Panel20: TPanel;
    SpTBXButton21: TSpTBXButton;
    SpTBXLabel21: TSpTBXLabel;
    Panel21: TPanel;
    SpTBXButton22: TSpTBXButton;
    SpTBXLabel22: TSpTBXLabel;
    SpTBXLabel23: TSpTBXLabel;
    Panel22: TPanel;
    SpTBXButton23: TSpTBXButton;
    SpTBXButton24: TSpTBXButton;
    Panel23: TPanel;
    SpTBXLabel24: TSpTBXLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpTBXButton0Click(Sender: TObject);
    procedure SpTBXButton1Click(Sender: TObject);
    procedure SpTBXButton2Click(Sender: TObject);
    procedure SpTBXButton3Click(Sender: TObject);
    procedure SpTBXButton4Click(Sender: TObject);
    procedure SpTBXButton5Click(Sender: TObject);
    procedure SpTBXButton7Click(Sender: TObject);
    procedure SpTBXButton6Click(Sender: TObject);
    procedure SpTBXButton8Click(Sender: TObject);
    procedure SpTBXButton9Click(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure SpTBXButton10Click(Sender: TObject);
    procedure SpTBXButton11Click(Sender: TObject);
    procedure SpTBXButton12Click(Sender: TObject);
    procedure SpTBXButton13Click(Sender: TObject);
    procedure SpTBXButton15Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpTBXButton14Click(Sender: TObject);
    procedure SpTBXButton16Click(Sender: TObject);
    procedure SpTBXButton17Click(Sender: TObject);
    procedure SpTBXButton18Click(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure SpTBXItem1Click(Sender: TObject);
    procedure SpTBXItem2Click(Sender: TObject);
    procedure SpTBXButton19Click(Sender: TObject);
    procedure SpTBXButton20Click(Sender: TObject);
    procedure SpTBXButton24Click(Sender: TObject);
    procedure SpTBXButton23Click(Sender: TObject);
    procedure SpTBXButton22Click(Sender: TObject);
    procedure SpTBXButton21Click(Sender: TObject);
  protected
    mLocalFont: TFont;
  public
    procedure ApplyFont;
    procedure LoadColors(FileName: String);
  end;

var
  ColorsPreference: TColorsPreference;

implementation

uses ColorPicker, BattleFormUnit, gnugettext, PreferencesFormUnit, SplashScreenUnit;

{$R *.dfm}

procedure TColorsPreference.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);

  mLocalFont := TFont.Create;
end;

procedure TColorsPreference.SpTBXButton0Click(Sender: TObject);
begin
  Panel0.Color := InputColor(_('Choose a color ...'),Panel0.Color);
end;

procedure TColorsPreference.SpTBXButton1Click(Sender: TObject);
begin
  Panel1.Color := InputColor(_('Choose a color ...'),Panel1.Color);
end;

procedure TColorsPreference.SpTBXButton2Click(Sender: TObject);
begin
  Panel2.Color := InputColor(_('Choose a color ...'),Panel2.Color);
end;

procedure TColorsPreference.SpTBXButton3Click(Sender: TObject);
begin
  Panel3.Color := InputColor(_('Choose a color ...'),Panel3.Color);
end;

procedure TColorsPreference.SpTBXButton4Click(Sender: TObject);
begin
  Panel4.Color := InputColor(_('Choose a color ...'),Panel4.Color);
end;

procedure TColorsPreference.SpTBXButton5Click(Sender: TObject);
begin
  Panel5.Color := InputColor(_('Choose a color ...'),Panel5.Color);
end;

procedure TColorsPreference.SpTBXButton7Click(Sender: TObject);
begin
  Panel7.Color := InputColor(_('Choose a color ...'),Panel7.Color);
end;

procedure TColorsPreference.SpTBXButton6Click(Sender: TObject);
begin
  Panel6.Color := InputColor(_('Choose a color ...'),Panel6.Color);
end;

procedure TColorsPreference.SpTBXButton8Click(Sender: TObject);
begin
  Panel8.Color := InputColor(_('Choose a color ...'),Panel8.Color);
end;

procedure TColorsPreference.SpTBXButton9Click(Sender: TObject);
begin
  Panel9.Color := InputColor(_('Choose a color ...'),Panel9.Color);
end;

procedure TColorsPreference.btOkClick(Sender: TObject);
begin
  Colors.Normal := Panel0.Color;
  Colors.Data := Panel1.Color;
  Colors.Error := Panel2.Color;
  Colors.Info := Panel3.Color;
  Colors.MinorInfo := Panel4.Color;
  Colors.ChanJoin := Panel5.Color;
  Colors.ChanLeft := Panel6.Color;
  Colors.MOTD := Panel7.Color;
  Colors.SayEx := Panel8.Color;
  Colors.Topic := Panel9.Color;
  Colors.ClientAway := Panel10.Color;
  Colors.MapModUnavailable := Panel11.Color;
  Colors.BotText := Panel12.Color;
  Colors.MyText := Panel13.Color;
  Colors.AdminText := Panel14.Color;
  Colors.OldMsgs := Panel15.Color;
  Colors.BattleDetailsNonDefault := Panel16.Color;
  Colors.BattleDetailsChanged := Panel17.Color;
  Colors.ClientIngame := Panel18.Color;
  Colors.ReplayWinningTeam := Panel19.Color;
  Colors.SkillVeryHighUncertainty := Panel20.Color;
  Colors.SkillHighUncertainty := Panel21.Color;
  Colors.SkillAvgUncertainty := Panel22.Color;
  Colors.SkillLowUncertainty := Panel23.Color;

  CommonFont.Assign(mLocalFont);
  ApplyFont;

  ModalResult := mrOk;
end;

procedure TColorsPreference.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TColorsPreference.SpTBXButton10Click(Sender: TObject);
begin
  Panel10.Color := InputColor(_('Choose a color ...'),Panel10.Color);
end;

procedure TColorsPreference.SpTBXButton11Click(Sender: TObject);
begin
  Panel11.Color := InputColor(_('Choose a color ...'),Panel11.Color);
end;

procedure TColorsPreference.SpTBXButton12Click(Sender: TObject);
begin
  Panel12.Color := InputColor(_('Choose a color ...'),Panel12.Color);
end;

procedure TColorsPreference.SpTBXButton13Click(Sender: TObject);
begin
  Panel13.Color := InputColor(_('Choose a color ...'),Panel13.Color);
end;

procedure TColorsPreference.SpTBXButton15Click(Sender: TObject);
begin
  if FontDialog1.Execute then
  begin
    lblFontName.Caption := FontDialog1.Font.Name+'@'+IntToStr(FontDialog1.Font.Size);
    mLocalFont.Name := FontDialog1.Font.Name;
    mLocalFont.Size := FontDialog1.Font.Size;
  end;
end;

procedure TColorsPreference.ApplyFont;
var
  i : integer;
begin
  // hack to set the battle form chat font
  if not BattleForm.Visible then
  begin
    LockWindowUpdate(BattleForm.Handle);
    BattleForm.Show;
    BattleForm.ChatRichEdit.Font.Assign(CommonFont);
    BattleForm.Hide;
  end
  else
    BattleForm.ChatRichEdit.Font.Assign(CommonFont);

  //BattleForm.AutoHostMsgsRichEdit.Font.Assign(CommonFont);
  BattleForm.InputEdit.Font.Assign(CommonFont);
  BattleForm.InputEdit.Height := CommonFont.Size*2+5;
  PreferencesForm.UpdateTntMemo(BattleForm.InputEdit);

  for i:=0 to MainForm.ChatTabs.Count-1 do
  begin
    (TMyTabSheet(MainForm.ChatTabs[i]).FindChildControl('RichEdit') as TExRichEdit).Font.Assign(CommonFont);
    (TMyTabSheet(MainForm.ChatTabs[i]).FindChildControl('InputEdit') as TTntMemo).Font.Assign(CommonFont);
    (TMyTabSheet(MainForm.ChatTabs[i]).FindChildControl('InputEdit') as TTntMemo).Height := CommonFont.Size*2+5;
    PreferencesForm.UpdateTntMemo((TMyTabSheet(MainForm.ChatTabs[i]).FindChildControl('InputEdit') as TTntMemo));
  end;

  MainForm.ClientsListBox.Font.Assign(CommonFont);
  MainForm.ClientsListBox.ItemHeight := 2*CommonFont.Size ;

  MainForm.BattlePlayersListBox.Font.Assign(CommonFont);
  MainForm.BattlePlayersListBox.ItemHeight := 2*CommonFont.Size ;
end;

procedure TColorsPreference.FormShow(Sender: TObject);
begin
  Panel0.Color := Colors.Normal;
  Panel1.Color := Colors.Data;
  Panel2.Color := Colors.Error;
  Panel3.Color := Colors.Info;
  Panel4.Color := Colors.MinorInfo;
  Panel5.Color := Colors.ChanJoin;
  Panel6.Color := Colors.ChanLeft;
  Panel7.Color := Colors.MOTD;
  Panel8.Color := Colors.SayEx;
  Panel9.Color := Colors.Topic;
  Panel10.Color := Colors.ClientAway;
  Panel11.Color := Colors.MapModUnavailable;
  Panel12.Color := Colors.BotText;
  Panel13.Color := Colors.MyText;
  Panel14.Color := Colors.AdminText;
  Panel15.Color := Colors.OldMsgs;
  Panel16.Color := Colors.BattleDetailsNonDefault;
  Panel17.Color := Colors.BattleDetailsChanged;
  Panel18.Color := Colors.ClientIngame;
  Panel19.Color := Colors.ReplayWinningTeam;
  Panel20.Color := Colors.SkillVeryHighUncertainty;
  Panel21.Color := Colors.SkillHighUncertainty;
  Panel22.Color := Colors.SkillAvgUncertainty;
  Panel23.Color := Colors.SkillLowUncertainty;

  mLocalFont.Assign(CommonFont);
  lblFontName.Caption := CommonFont.Name+'@'+IntToStr(CommonFont.Size);
end;

procedure TColorsPreference.SpTBXButton14Click(Sender: TObject);
begin
  Panel14.Color := InputColor(_('Choose a color ...'),Panel14.Color);
end;

procedure TColorsPreference.SpTBXButton16Click(Sender: TObject);
begin
  Panel15.Color := InputColor(_('Choose a color ...'),Panel15.Color);
end;

procedure TColorsPreference.SpTBXButton17Click(Sender: TObject);
begin
  Panel16.Color := InputColor(_('Choose a color ...'),Panel16.Color);
end;

procedure TColorsPreference.SpTBXButton18Click(Sender: TObject);
begin
  Panel17.Color := InputColor(_('Choose a color ...'),Panel17.Color);
end;

procedure TColorsPreference.btSaveClick(Sender: TObject);
var
  FileName: String;
  Ini : TIniFile;
begin
  try
    SaveDialog1.Filter := 'Skin file|*.skn';
    SaveDialog1.Title := _('Save skin to ...');
    SaveDialog1.InitialDir := ExtractFilePath(Application.ExeName);
    if not SaveDialog1.Execute then Exit;
    FileName := SaveDialog1.FileName;
    Ini := TIniFile.Create(FileName);
    Ini.WriteInteger('TASClientColor','Normal',Colors.Normal);
    Ini.WriteInteger('TASClientColor','Data',Colors.Data);
    Ini.WriteInteger('TASClientColor','Error',Colors.Error);
    Ini.WriteInteger('TASClientColor','Info',Colors.Info);
    Ini.WriteInteger('TASClientColor','MinorInfo',Colors.MinorInfo);
    Ini.WriteInteger('TASClientColor','ChanJoin',Colors.ChanJoin);
    Ini.WriteInteger('TASClientColor','ChanLeft',Colors.ChanLeft);
    Ini.WriteInteger('TASClientColor','MOTD',Colors.MOTD);
    Ini.WriteInteger('TASClientColor','SayEx',Colors.SayEx);
    Ini.WriteInteger('TASClientColor','Topic',Colors.Topic);
    Ini.WriteInteger('TASClientColor','ClientAway',Colors.ClientAway);
    Ini.WriteInteger('TASClientColor','MapModUnavailable',Colors.MapModUnavailable);
    Ini.WriteInteger('TASClientColor','BotText',Colors.BotText);
    Ini.WriteInteger('TASClientColor','MyText',Colors.MyText);
    Ini.WriteInteger('TASClientColor','AdminText',Colors.AdminText);
    Ini.WriteInteger('TASClientColor','OldMsgs',Colors.OldMsgs);
    Ini.WriteInteger('TASClientColor','BattleDetailsNonDefault',Colors.BattleDetailsNonDefault);
    Ini.WriteInteger('TASClientColor','BattleDetailsChanged',Colors.BattleDetailsChanged);
    Ini.WriteInteger('TASClientColor','ClientIngame',Colors.ClientIngame);
    Ini.WriteInteger('TASClientColor','ReplayWinningTeam',Colors.ReplayWinningTeam);
    Ini.WriteInteger('TASClientColor','SkillLowUncertainty',Colors.SkillLowUncertainty);
    Ini.WriteInteger('TASClientColor','SkillAvgUncertainty',Colors.SkillAvgUncertainty);
    Ini.WriteInteger('TASClientColor','SkillHighUncertainty',Colors.SkillHighUncertainty);
    Ini.WriteInteger('TASClientColor','SkillVeryHighUncertainty',Colors.SkillVeryHighUncertainty);
    Ini.Free;
  except
    MessageDlg(_('An error occured while saving.'),mtError,[mbOK],0);
  end;
end;

procedure TColorsPreference.btLoadClick(Sender: TObject);
var
  FileName: String;
begin
  OpenDialog1.Filter := 'Skin file|*.skn';
  OpenDialog1.Title := _('Open skin to ...');
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);
  if not OpenDialog1.Execute then Exit;
  LoadColors(OpenDialog1.FileName);
end;

procedure TColorsPreference.LoadColors(FileName: String);
var
  Ini : TIniFile;
begin
  try
    Ini := TIniFile.Create(FileName);
    Colors.Normal := Ini.ReadInteger('TASClientColor','Normal',Colors.Normal);
    Colors.Data := Ini.ReadInteger('TASClientColor','Data',Colors.Data);
    Colors.Error := Ini.ReadInteger('TASClientColor','Error',Colors.Error);
    Colors.Info := Ini.ReadInteger('TASClientColor','Info',Colors.Info);
    Colors.MinorInfo := Ini.ReadInteger('TASClientColor','MinorInfo',Colors.MinorInfo);
    Colors.ChanJoin := Ini.ReadInteger('TASClientColor','ChanJoin',Colors.ChanJoin);
    Colors.ChanLeft := Ini.ReadInteger('TASClientColor','ChanLeft',Colors.ChanLeft);
    Colors.MOTD := Ini.ReadInteger('TASClientColor','MOTD',Colors.MOTD);
    Colors.SayEx := Ini.ReadInteger('TASClientColor','SayEx',Colors.SayEx);
    Colors.Topic := Ini.ReadInteger('TASClientColor','Topic',Colors.Topic);
    Colors.ClientAway := Ini.ReadInteger('TASClientColor','ClientAway',Colors.ClientAway);
    Colors.MapModUnavailable := Ini.ReadInteger('TASClientColor','MapModUnavailable',Colors.MapModUnavailable);
    Colors.BotText := Ini.ReadInteger('TASClientColor','BotText',Colors.BotText);
    Colors.MyText := Ini.ReadInteger('TASClientColor','MyText',Colors.MyText);
    Colors.AdminText := Ini.ReadInteger('TASClientColor','AdminText',Colors.AdminText);
    Colors.OldMsgs := Ini.ReadInteger('TASClientColor','OldMsgs',Colors.OldMsgs);
    Colors.BattleDetailsNonDefault := Ini.ReadInteger('TASClientColor','BattleDetailsNonDefault',Colors.BattleDetailsNonDefault);
    Colors.BattleDetailsChanged := Ini.ReadInteger('TASClientColor','BattleDetailsChanged',Colors.BattleDetailsChanged);
    Colors.ClientIngame := Ini.ReadInteger('TASClientColor','ClientIngame',Colors.ClientIngame);
    Colors.ReplayWinningTeam := Ini.ReadInteger('TASClientColor','ReplayWinningTeam',Colors.ReplayWinningTeam);
    Colors.SkillLowUncertainty := Ini.ReadInteger('TASClientColor','SkillLowUncertainty',Colors.SkillLowUncertainty);
    Colors.SkillAvgUncertainty := Ini.ReadInteger('TASClientColor','SkillAvgUncertainty',Colors.SkillAvgUncertainty);
    Colors.SkillHighUncertainty := Ini.ReadInteger('TASClientColor','SkillHighUncertainty',Colors.SkillHighUncertainty);
    Colors.SkillVeryHighUncertainty := Ini.ReadInteger('TASClientColor','SkillVeryHighUncertainty',Colors.SkillVeryHighUncertainty);
    FormShow(nil);
    Ini.Free;
  except
    MessageDlg(_('An error occured while saving.'),mtError,[mbOK],0);
  end;
end;

procedure TColorsPreference.SpTBXItem1Click(Sender: TObject);
begin
  Panel0.Color := clBlack;
  Panel1.Color := clGreen;
  Panel2.Color := clRed;
  Panel3.Color := clBlue;
  Panel4.Color := clNavy;
  Panel5.Color := clGreen;
  Panel6.Color := clNavy;
  Panel7.Color := clMaroon;
  Panel8.Color := clPurple;
  Panel9.Color := clMaroon;
  Panel10.Color := $009F9F9F;
  Panel11.Color := $00ed00d5;
  Panel12.Color := clGray;
  Panel13.Color := $0092726e;
  Panel14.Color := $000366A3;
  Panel15.Color := $00c3c3c3;
  Panel16.Color := $00b321a4;
  Panel17.Color := $00d85600;
  Panel18.Color := $009F1111;
  Panel19.Color := 12116153;
  Panel20.Color := $00AAAAAA;
  Panel21.Color := $00545454;
  Panel22.Color := $00000000;
  Panel23.Color := $0000A000;

  CommonFont.Name := 'Fixedsys';
  CommonFont.Size := 8;
  lblFontName.Caption := CommonFont.Name;
end;

procedure TColorsPreference.SpTBXItem2Click(Sender: TObject);
begin
  Panel0.Color := $00729EA6;
  Panel1.Color := clGreen;
  Panel2.Color := $003232C9;
  Panel3.Color := $00FFC5A1;
  Panel4.Color := $00D14D4D;
  Panel5.Color := clGreen;
  Panel6.Color := $00FFC5A1;
  Panel7.Color := $0059597A;
  Panel8.Color := $00855885;
  Panel9.Color := $0059597A;
  Panel10.Color := $00545454;
  Panel11.Color := $00A8479F;
  Panel12.Color := $00808080;
  Panel13.Color := $00A2E0EB;
  Panel14.Color := $00A9EBA2;
  Panel15.Color := $00545454;
  Panel16.Color := $00A8479F;
  Panel17.Color := $00FFC5A1;
  Panel18.Color := $00D14D4D;
  Panel19.Color := 2900515;
  Panel20.Color := $00384547;
  Panel21.Color := $005C7478;
  Panel22.Color := $00729EA6;
  Panel23.Color := $0000A000;

  CommonFont.Name := 'Fixedsys';
  CommonFont.Size := 8;
  lblFontName.Caption := CommonFont.Name;
end;

procedure TColorsPreference.SpTBXButton19Click(Sender: TObject);
begin
  Panel18.Color := InputColor(_('Choose a color ...'),Panel18.Color);
end;

procedure TColorsPreference.SpTBXButton20Click(Sender: TObject);
begin
  Panel19.Color := InputColor(_('Choose a color ...'),Panel19.Color);
end;

procedure TColorsPreference.SpTBXButton24Click(Sender: TObject);
begin
  Panel23.Color := InputColor(_('Choose a color ...'),Panel23.Color);
end;

procedure TColorsPreference.SpTBXButton23Click(Sender: TObject);
begin
  Panel22.Color := InputColor(_('Choose a color ...'),Panel22.Color);
end;

procedure TColorsPreference.SpTBXButton22Click(Sender: TObject);
begin
  Panel21.Color := InputColor(_('Choose a color ...'),Panel21.Color);
end;

procedure TColorsPreference.SpTBXButton21Click(Sender: TObject);
begin
  Panel20.Color := InputColor(_('Choose a color ...'),Panel20.Color);
end;

end.
