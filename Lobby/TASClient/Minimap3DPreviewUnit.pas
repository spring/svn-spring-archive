unit Minimap3DPreviewUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLCadencer, GLTexture, jpeg, GLHeightData, GLScene,OpenGL1x,
  GLTerrainRenderer, GLObjects, GLMisc, GLWin32Viewer, GLVectorFileObjects,
  GLPortal,VectorTypes,VectorGeometry, SpTBXItem,SpTBXSkins, Math,GIFImage,
  GpIFF,MapListFormUnit;

type
  TMinimap3DPreview = class(TForm)
    GLScene: TGLScene;
    CenterPoint: TGLRenderPoint;
    DummyCube: TGLDummyCube;
    Minimap: TGLTerrainRenderer;
    Light: TGLLightSource;
    Camera: TGLCamera;
    HeightMap: TGLBitmapHDS;
    TextureLib: TGLMaterialLibrary;
    GLCadencer: TGLCadencer;
    SpTBXTitleBar1: TSpTBXTitleBar;
    GLSceneViewer: TGLSceneViewer;
    Plinth: TGLPlane;
    Water: TGLCube;
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure GLSceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure MouseWheelHandler(var AMessage: TMessage); override;
  public
    mx, my : Integer;
    buttonDown: boolean;

    procedure SwitchMetalMap;
    procedure UpdateMiniMap(currentMap: TMapItem;heightBitmap: TBitmap; textureBitmap: TBitmap; metalBitmap: TBitmap;displayMetalMap: Boolean);
  end;

var
  Minimap3DPreview: TMinimap3DPreview;

implementation

uses BattleFormUnit, PreferencesFormUnit,
  MinimapZoomedFormUnit, Misc, MainUnit, Utility;

{$R *.dfm}

procedure TMinimap3DPreview.GLSceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   mx:=x;
   my:=y;
   buttonDown := True;
end;

procedure TMinimap3DPreview.GLSceneViewerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  vX,vY,vT: TVector3f;
  currentMap: TMapItem;
  panSpeed: Single;
begin
  if not buttonDown then
    Exit;
  if ssLeft in Shift then
  begin
    vY := VectorSubtract(Camera.Position.AsAffineVector,DummyCube.Position.AsAffineVector);
    panSpeed := VectorLength(vY);
    vY[2] := 0;
    NormalizeVector(vY);
    vX := VectorCrossProduct(vY,Camera.Up.AsAffineVector);
    NormalizeVector(vX);

    vY[0] := vY[0]*(my-y)*0.2;
    vY[1] := vY[1]*(my-y)*0.2;

    vX[0] := vX[0]*(mx-x)*-0.2;
    vX[1] := vX[1]*(mx-x)*-0.2;

    vT := VectorAdd(vX,vY);

    vT := VectorScale(vT,panSpeed/100);

    GLSceneViewer.Cursor := crSizeAll;

    Camera.Position.Translate(vT);
    DummyCube.Position.Translate(vT);
    mx:=x;
    my:=y;
    Exit;
  end;
  if not buttonDown then Exit;
  if (ssLeft in Shift) and (ssCtrl in Shift) then
  begin
    currentMap := GetMapItem(BattleForm.CurrentMapIndex);
    Minimap.Scale.Z := Minimap.Scale.Z - (my-y)/10000;
    //Water.Position.Z := 128*Minimap.Scale.Z+256*Minimap.Scale.Z*GetMapItem(BattleForm.CurrentMapIndex).MinHeight/(GetMapItem(BattleForm.CurrentMapIndex).MaxHeight-GetMapItem(BattleForm.CurrentMapIndex).MinHeight);
    Water.Scale.Z := 256*Minimap.Scale.Z*currentMap.MinHeight/(currentMap.MaxHeight-currentMap.MinHeight);
    Water.Position.Z := 128.1*Minimap.Scale.Z+Water.Scale.Z/2;
    Plinth.Position.Z := 128.2*Minimap.Scale.Z;
    mx:=x;
    my:=y;
    Exit;
  end;
  if ssRight in Shift then
  begin
    Camera.MoveAroundTarget((my-y)*0.5, (mx-x)*0.5);
    mx:=x;
    my:=y;
    Exit;
  end;
  if ssMiddle in Shift then
  begin
    if ((Camera.DistanceToTarget > 10) or (my-y < 0)) and ((Camera.DistanceToTarget < 200) or (my-y > 0)) then
    begin
      Camera.MoveInEyeSpace((my-y),0,0);
    end;
    mx:=x;
    my:=y;
    Exit;
  end;
end;

procedure TMinimap3DPreview.FormCreate(Sender: TObject);
var
  sector: TSectorMeshObject;
begin
  if Preferences.ThemeType = sknSkin then
  begin
    SpTBXTitleBar1.Active := True;
    BorderStyle := bsNone;
  end;

  buttonDown := False;
  GLScene.Objects.Remove(Minimap,False);
end;

procedure TMinimap3DPreview.GLSceneViewerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  buttonDown := False;
  GLSceneViewer.Cursor := crDefault;
end;

procedure TMinimap3DPreview.FormShow(Sender: TObject);
begin
  GLScene.Objects.AddChild(Minimap);
  GLCadencer.Enabled := True;
end;

procedure TMinimap3DPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  GLCadencer.Enabled := False;
  GLScene.Objects.Remove(Minimap,False);
end;

procedure TMinimap3DPreview.SwitchMetalMap;
begin
  if Minimap.Material.LibMaterialName = 'GroundMetalTexture' then
    Minimap.Material.LibMaterialName := 'GroundTexture'
  else
    Minimap.Material.LibMaterialName := 'GroundMetalTexture';
end;

procedure TMinimap3DPreview.UpdateMiniMap(currentMap: TMapItem;heightBitmap: TBitmap; textureBitmap: TBitmap; metalBitmap: TBitmap;displayMetalMap: Boolean);
var
  hMap: TBitmap;
  texture: TBitmap;
  textureMetal: TBitmap;
  i,j: integer;
  linePixels1,linePixels2 : pColorData;
begin

  Camera.Position.X := -50;
  Camera.Position.Y := 50;
  Camera.Position.Z := 50;

  // manually adjusted according to DSD (1280 = dsd width 20*64)
  Minimap.Scale.Z := -0.03*(currentMap.MaxHeight-currentMap.MinHeight)/600/Max(currentMap.MapInfo.Width,currentMap.MapInfo.Height)*1280;
  if Minimap.Scale.Z = 0 then
    Minimap.Scale.Z := -0.03;

  hMap := TBitmap.Create;
  texture := TBitmap.Create;

  with currentMap do
    if MapInfo.Width > MapInfo.Height then
    begin
      Minimap.Scale.X := 0.1;
      Minimap.Scale.Y := 0.1*MapInfo.Height/MapInfo.Width;
    end
    else
    begin
      Minimap.Scale.X := 0.1*MapInfo.Width/MapInfo.Height;
      Minimap.Scale.Y := 0.1;
    end;

  hMap.Width := 1024;
  hMap.Height := 1024;
  hMap.PixelFormat := pf24bit;

  texture.Width := 1024;
  texture.Height := 1024;
  texture.PixelFormat := pf24bit;

  hMap.Canvas.Brush.Color := clBlack;
  hMap.Canvas.FillRect(hMap.Canvas.ClipRect);

  texture.Canvas.Brush.Color := clBlack;
  texture.Canvas.FillRect(texture.Canvas.ClipRect);

  hMap.Canvas.StretchDraw(Rect(1,1,hMap.Width,hMap.Height),heightBitmap);
  texture.Canvas.StretchDraw(Rect(1,1,texture.Width,texture.Height),textureBitmap);

  textureMetal := TBitmap.Create;
  textureMetal.Width := 1024;
  textureMetal.Height := 1024;
  textureMetal.PixelFormat := pf24bit;
  textureMetal.Canvas.StretchDraw(Rect(1,1,texture.Width,texture.Height),metalBitmap);
  for i:=0 to textureMetal.Height-1 do
  begin
    linePixels1 := textureMetal.ScanLine[i];
    linePixels2 := texture.ScanLine[i];

    for j:=0 to textureMetal.Width-1 do
    begin
      linePixels1[j].rgbtBlue :=  Min(255,Floor(linePixels2[j].rgbtBlue*0.3));
      linePixels1[j].rgbtRed :=  Min(255,Floor(linePixels2[j].rgbtRed*0.3));
      linePixels1[j].rgbtGreen :=  Min(255,Floor(linePixels2[j].rgbtGreen*0.3+linePixels1[j].rgbtGreen*0.7));
    end;
  end;

  HeightMap.Picture.Bitmap.Width := texture.Width;
  HeightMap.Picture.Bitmap.Height := texture.Height;
  HeightMap.Picture.Bitmap.Assign(ReduceColors(hMap,rmGrayScale,dmFloydSteinberg,0,0));

  TextureLib.LibMaterialByName('GroundTexture').Material.Texture.Image.GetBitmap32(GL_TEXTURE_2D).Assign(texture);
  TextureLib.LibMaterialByName('GroundMetalTexture').Material.Texture.Image.GetBitmap32(GL_TEXTURE_2D).Assign(textureMetal);

  Minimap.HeightDataSource := nil;
  Minimap.HeightDataSource := HeightMap;

  Minimap.Position.X := 51*Minimap.Scale.X*10;
  Minimap.Position.Y := -47.5*Minimap.Scale.Y*10;
  Minimap.Position.Z := 0;

  TextureLib.LibMaterialByName('GroundTexture').Material.Texture.Image.NotifyChange(TextureLib.LibMaterialByName('GroundTexture').Material.Texture.Image);
  TextureLib.LibMaterialByName('GroundMetalTexture').Material.Texture.Image.NotifyChange(TextureLib.LibMaterialByName('GroundMetalTexture').Material.Texture.Image);

  if displayMetalMap then
    Minimap.Material.LibMaterialName := 'GroundMetalTexture'
  else
    Minimap.Material.LibMaterialName := 'GroundTexture';

  GLSceneViewer.Invalidate;

  Water.Scale.X := 103*10*Minimap.Scale.X;
  Water.Scale.Y := 103*10*Minimap.Scale.Y;
  with currentMap do
    Water.Position.Y := IFF(MapInfo.Height/MapInfo.Width <= 1,4 * MapInfo.Height/MapInfo.Width,4);

  Water.Scale.Z := 256*Minimap.Scale.Z*currentMap.MinHeight/(currentMap.MaxHeight-currentMap.MinHeight);
  Water.Position.Z := 128.1*Minimap.Scale.Z+Water.Scale.Z/2;
  Plinth.Position.Assign(Water.Position);
  Plinth.Scale.X := 10*Minimap.Scale.X;
  Plinth.Scale.Y := 10*Minimap.Scale.Y;
  Plinth.Position.Z := 128.2*Minimap.Scale.Z;
  DummyCube.Position.X := 0;
  DummyCube.Position.Y := 0;
  DummyCube.Position.Z := Water.Position.Z;

  Water.Visible := currentMap.MinHeight < 0;

  texture.Free;
  textureMetal.Free;
  hMap.Free;
end;

procedure TMinimap3DPreview.MouseWheelHandler(var AMessage: TMessage);
var
  Control: TWinControl;
begin
  Control := FindVCLWindow(SmallPointToPoint(TWMMouseWheel(AMessage).Pos));
  if Control = GLSceneViewer then
  begin
    if ((Camera.DistanceToTarget > 10) or (TWMMouseWheel(AMessage).WheelDelta < 0)) and ((Camera.DistanceToTarget < 200) or (TWMMouseWheel(AMessage).WheelDelta > 0)) then
    begin
      Camera.MoveInEyeSpace( TWMMouseWheel(AMessage).WheelDelta/Max(10,30-VectorLength(VectorSubtract(Camera.Position.AsAffineVector,DummyCube.Position.AsAffineVector))/10) ,0,0);
    end;
  end
  else
    inherited MouseWheelHandler(AMessage);
end;

end.
