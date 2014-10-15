unit CustomColorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvGammaPanel, StdCtrls, JvExStdCtrls,
  JvButton, JvStartMenuButton, JvColorBox, JvColorButton, ExtCtrls,
  JvExExtCtrls, JvOfficeColorButton, JvPanel, JvOfficeColorPanel, TB2Dock,
  TB2Toolbar, TBX, SpTBXItem, TB2Item, TBXToolPals, TBXDkPanels,
  SpTBXControls;

type

  TTBXColorPaletteHack = class(TTBXColorPalette)
  end;

  TCustomColorForm = class(TForm)
    SpTBXTitleBar1: TSpTBXTitleBar;
    JvGammaPanel1: TJvGammaPanel;
    ColorToolbar: TSpTBXToolbar;
    TBXColorPalette1: TTBXColorPalette;
    SpTBXButton1: TSpTBXButton;
    SpTBXButton2: TSpTBXButton;
    SpTBXLabel4: TSpTBXLabel;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure TBXColorPalette1CellClick(Sender: TTBXCustomToolPalette;
      var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure JvGammaPanel1ChangeColor(Sender: TObject; Foreground,
      Background: TColor);
    procedure SpTBXButton2Click(Sender: TObject);
    procedure SpTBXButton1Click(Sender: TObject);

  private
    FSelectedColorIndex: Integer;
  public
    { Public declarations }
  end;

var
  CustomColorForm: TCustomColorForm;

implementation

uses BattleFormUnit, PreferencesFormUnit, MainUnit;

{$R *.dfm}

procedure TCustomColorForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  if not Preferences.TaskbarButtons then Exit;

  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
    WndParent := GetDesktopWindow;
  end;
end;

procedure TCustomColorForm.TBXColorPalette1CellClick(
  Sender: TTBXCustomToolPalette; var ACol, ARow: Integer;
  var AllowChange: Boolean);
begin
  FSelectedColorIndex := ACol + ARow * TBXColorPalette1.ColorSet.ColCount;
  JVGammaPanel1.ForegroundColor := TBXColorPalette1.ColorSet.GetColor(ACol, ARow);
end;

procedure TCustomColorForm.FormCreate(Sender: TObject);
begin
  FSelectedColorIndex := -1;
end;

procedure TCustomColorForm.JvGammaPanel1ChangeColor(Sender: TObject;
  Foreground, Background: TColor);
begin
  if FSelectedColorIndex = -1 then Exit; // we haven't selected a color yet

  TeamColors[FSelectedColorIndex] := Foreground;
  MainForm.UpdateColorImageList;
  ColorToolbar.Repaint;
end;

procedure TCustomColorForm.SpTBXButton2Click(Sender: TObject);
begin
  TeamColors := DefaultTeamColors;
  MainForm.UpdateColorImageList;
  ColorToolbar.Repaint;
end;

procedure TCustomColorForm.SpTBXButton1Click(Sender: TObject);
begin
  Close;
end;

end.
