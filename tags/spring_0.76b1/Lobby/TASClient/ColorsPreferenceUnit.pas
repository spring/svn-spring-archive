unit ColorsPreferenceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SpTBXItem, SpTBXControls, ExtCtrls, TBXDkPanels,Misc,MainUnit;

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
    procedure btRestClick(Sender: TObject);
    procedure SpTBXButton10Click(Sender: TObject);
    procedure SpTBXButton11Click(Sender: TObject);
    procedure SpTBXButton12Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ColorsPreference: TColorsPreference;

implementation

uses ColorPicker;

{$R *.dfm}

procedure TColorsPreference.FormCreate(Sender: TObject);
begin
  if not SpTBXTitleBar1.Active then
    RemoveSpTBXTitleBarMarges(self);
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
end;

procedure TColorsPreference.SpTBXButton0Click(Sender: TObject);
begin
  Panel0.Color := InputColor('Choose a color ...',Panel0.Color);
end;

procedure TColorsPreference.SpTBXButton1Click(Sender: TObject);
begin
  Panel1.Color := InputColor('Choose a color ...',Panel1.Color);
end;

procedure TColorsPreference.SpTBXButton2Click(Sender: TObject);
begin
  Panel2.Color := InputColor('Choose a color ...',Panel2.Color);
end;

procedure TColorsPreference.SpTBXButton3Click(Sender: TObject);
begin
  Panel3.Color := InputColor('Choose a color ...',Panel3.Color);
end;

procedure TColorsPreference.SpTBXButton4Click(Sender: TObject);
begin
  Panel4.Color := InputColor('Choose a color ...',Panel4.Color);
end;

procedure TColorsPreference.SpTBXButton5Click(Sender: TObject);
begin
  Panel5.Color := InputColor('Choose a color ...',Panel5.Color);
end;

procedure TColorsPreference.SpTBXButton7Click(Sender: TObject);
begin
  Panel7.Color := InputColor('Choose a color ...',Panel7.Color);
end;

procedure TColorsPreference.SpTBXButton6Click(Sender: TObject);
begin
  Panel6.Color := InputColor('Choose a color ...',Panel6.Color);
end;

procedure TColorsPreference.SpTBXButton8Click(Sender: TObject);
begin
  Panel8.Color := InputColor('Choose a color ...',Panel8.Color);
end;

procedure TColorsPreference.SpTBXButton9Click(Sender: TObject);
begin
  Panel9.Color := InputColor('Choose a color ...',Panel9.Color);
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

  ModalResult := mrOk;
end;

procedure TColorsPreference.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TColorsPreference.btRestClick(Sender: TObject);
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
  Panel11.Color := clRed;
  Panel12.Color := clGray;
end;

procedure TColorsPreference.SpTBXButton10Click(Sender: TObject);
begin
  Panel10.Color := InputColor('Choose a color ...',Panel10.Color);
end;

procedure TColorsPreference.SpTBXButton11Click(Sender: TObject);
begin
  Panel11.Color := InputColor('Choose a color ...',Panel11.Color);
end;

procedure TColorsPreference.SpTBXButton12Click(Sender: TObject);
begin
  Panel12.Color := InputColor('Choose a color ...',Panel12.Color);
end;

end.
