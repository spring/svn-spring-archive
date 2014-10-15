unit BotOptionsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, SpTBXControls, StdCtrls, SpTBXEditors, TB2Item, Menus,
  TntForms, SpTBXSkins;

type
 
  TBotOptionsForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    ColorPopupMenu: TSpTBXPopupMenu;
    mnuTeamColorPalette: TSpTBXColorPalette;
    mnuTeamColorCustomize: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    mnuTeamColorCancel: TSpTBXItem;
    pnlMain: TSpTBXPanel;
    gbGameOptions: TSpTBXGroupBox;
    lblId: TSpTBXLabel;
    BotTeamButton: TSpTBXSpinEdit;
    BotSideButton: TSpTBXSpeedButton;
    lblTeam: TSpTBXLabel;
    BotAllyButton: TSpTBXSpinEdit;
    BotTeamColorButton: TSpTBXSpeedButton;
    gpOtherOptions: TSpTBXGroupBox;
    AIOptionsScrollBox: TTntScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormShow(Sender: TObject);
    procedure mnuTeamColorCustomizeClick(Sender: TObject);
    procedure mnuTeamColorPaletteCellClick(Sender: TObject; ACol,
      ARow: Integer; var Allow: Boolean);
    procedure BotAllyButtonExit(Sender: TObject);
    procedure BotTeamButtonExit(Sender: TObject);
    procedure mnuTeamColorPaletteGetColor(Sender: TObject; ACol,
      ARow: Integer; var Color: TColor; var Name: WideString);
    procedure BotSideButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    Bot: TObject;
    procedure UpdateBot;
  end;

var
  BotOptionsForm: TBotOptionsForm;

implementation

uses PreferencesFormUnit, MainUnit, BattleFormUnit, Misc;

{$R *.dfm}

procedure TBotOptionsForm.FormCreate(Sender: TObject);
begin
  if Preferences.ThemeType = sknSkin then
  begin
    SpTBXTitleBar1.Active := True;
    BorderStyle := bsNone;
    BotAllyButton.Color := SkinManager.CurrentSkin.Options(skncEditFrame,sknsNormal).Body.Color1;
    BotAllyButton.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal);
    BotTeamButton.Color := SkinManager.CurrentSkin.Options(skncEditFrame,sknsNormal).Body.Color1;
    BotTeamButton.Font.Color := SkinManager.CurrentSkin.GetTextColor(skncEditFrame,sknsNormal);
    AIOptionsScrollBox.Color := PreferencesForm.IfNotClNone(SkinManager.CurrentSkin.Options(skncTabBackground).Body.Color1,clBtnFace);
  end;
  BotAllyButton.SpinOptions.MaxValue := MAX_TEAMS;
  BotTeamButton.SpinOptions.MaxValue := MAX_TEAMS;
end;

procedure TBotOptionsForm.CreateParams(var Params: TCreateParams);
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


procedure TBotOptionsForm.FormShow(Sender: TObject);
begin
  MainForm.UpdateColorImageList;
  BotTeamColorButton.ImageIndex := Length(TeamColors)*2+1+BattleState.Battle.Bots.IndexOf(Bot);  
end;

procedure TBotOptionsForm.mnuTeamColorCustomizeClick(Sender: TObject);
begin
  TBot(Bot).SetTeamColor(Misc.InputColor(TBot(Bot).Name+' color',TBot(Bot).TeamColor));
  UpdateBot;
end;

procedure TBotOptionsForm.UpdateBot;
begin
  MainForm.TryToSendCommand('UPDATEBOT', TBot(Bot).Name + ' ' + IntToStr(TBot(Bot).BattleStatus) + ' ' + IntToStr(TBot(Bot).TeamColor));
end;

procedure TBotOptionsForm.mnuTeamColorPaletteCellClick(Sender: TObject;
  ACol, ARow: Integer; var Allow: Boolean);
begin
  TBot(Bot).SetTeamColor(TeamColors[ARow*5+ACol]);
  UpdateBot;
end;

procedure TBotOptionsForm.BotAllyButtonExit(Sender: TObject);
begin
  TBot(Bot).SetAllyNo(BotAllyButton.SpinOptions.ValueAsInteger-1);
  UpdateBot;
end;

procedure TBotOptionsForm.BotTeamButtonExit(Sender: TObject);
begin
  TBot(Bot).SetTeamNo(BotTeamButton.SpinOptions.ValueAsInteger-1);
  UpdateBot;
end;

procedure TBotOptionsForm.mnuTeamColorPaletteGetColor(Sender: TObject;
  ACol, ARow: Integer; var Color: TColor; var Name: WideString);
begin
  Color := TeamColors[ARow*5+ACol];
end;

procedure TBotOptionsForm.BotSideButtonClick(Sender: TObject);
var
  SideIndex: Integer;
begin
  SideIndex := BattleForm.ChooseSideDialog(Sender as TControl, TBot(Bot).GetSide);
  if SideIndex = -1 then Exit;

  TBot(Bot).SetSide(SideIndex);
end;

end.
