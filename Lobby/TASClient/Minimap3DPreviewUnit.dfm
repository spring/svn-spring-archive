object Minimap3DPreview: TMinimap3DPreview
  Left = 408
  Top = 180
  Width = 1195
  Height = 781
  Caption = 'Minimap3DPreview'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXTitleBar1: TSpTBXTitleBar
    Left = 0
    Top = 0
    Width = 1187
    Height = 754
    Caption = 'Minimap3DPreview'
    Active = False
    Options.Minimize = False
    object GLSceneViewer: TGLSceneViewer
      Left = 0
      Top = 22
      Width = 1187
      Height = 732
      Camera = Camera
      VSync = vsmSync
      Buffer.BackgroundColor = clBlack
      Buffer.FaceCulling = False
      Buffer.AntiAliasing = aaNone
      Buffer.DepthPrecision = dp32bits
      FieldOfView = 152.023437500000000000
      Align = alClient
      OnMouseDown = GLSceneViewerMouseDown
      OnMouseMove = GLSceneViewerMouseMove
      OnMouseUp = GLSceneViewerMouseUp
    end
  end
  object GLScene: TGLScene
    Left = 8
    Top = 16
    object Plinth: TGLPlane
      Material.BackProperties.Ambient.Color = {CDCC0C3FD7A3F03E295C0F3E0000803F}
      Material.BackProperties.Diffuse.Color = {CDCC0C3FD7A3F03E295C0F3E0000803F}
      Material.BackProperties.Shininess = 100
      Material.BackProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
      Material.FrontProperties.Ambient.Color = {CDCC0C3FD7A3F03E295C0F3E0000803F}
      Material.FrontProperties.Diffuse.Color = {CDCC0C3FD7A3F03E295C0F3E0000803F}
      Material.FrontProperties.Shininess = 100
      Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
      Position.Coordinates = {0000000000008040000000000000803F}
      Up.Coordinates = {000000000000803F0000008000000000}
      Height = 103.000000000000000000
      Width = 103.000000000000000000
      XTiles = 0
      YTiles = 0
      NoZWrite = False
    end
    object CenterPoint: TGLRenderPoint
    end
    object DummyCube: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
    object Minimap: TGLTerrainRenderer
      Material.MaterialLibrary = TextureLib
      Material.LibMaterialName = 'GroundTexture'
      VisibilityCulling = vcNone
      Direction.Coordinates = {0000000000000000000080BF00000000}
      Position.Coordinates = {00005CC200005CC2000000000000803F}
      Scale.Coordinates = {CDCCCC3DCDCCCC3DCDCCCC3D00000000}
      Up.Coordinates = {000000800000803F0000000000000000}
      HeightDataSource = HeightMap
      TileSize = 512
      TilesPerTexture = 2.000000000000000000
      QualityDistance = 10000.000000000000000000
      MaxCLODTriangles = 100000
      CLODPrecision = 3
    end
    object Light: TGLLightSource
      Ambient.Color = {000000000000000000000000CDCCCC3D}
      ConstAttenuation = 1.000000000000000000
      Diffuse.Color = {0000803F0000803F0000803FCDCCCC3D}
      Position.Coordinates = {0000000000000000000020410000803F}
      Specular.Color = {000000000000000000000000CDCCCC3D}
      SpotCutOff = 180.000000000000000000
    end
    object Water: TGLCube
      Material.BackProperties.Ambient.Color = {00000000A3A2223F0000803FF0A7263F}
      Material.FrontProperties.Ambient.Color = {CDCC4C3ECDCC4C3F0000803F1283203F}
      Material.FrontProperties.Diffuse.Color = {00000000CBCA4A3FCDCC4C3FF0A7263F}
      Material.FrontProperties.Shininess = 3
      Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
      Material.BlendingMode = bmTransparency
      Material.FaceCulling = fcNoCull
      Position.Coordinates = {0000000000008040000000000000803F}
      Scale.Coordinates = {0000CE420000CE420000803F00000000}
    end
    object Camera: TGLCamera
      DepthOfView = 3000.000000000000000000
      FocalLength = 91.174522399902350000
      TargetObject = DummyCube
      CameraStyle = csInfinitePerspective
      Position.Coordinates = {00004842000048420000C8420000803F}
      Direction.Coordinates = {000000000000803F0000000000000000}
      Up.Coordinates = {00000000000000000000803F00000000}
    end
  end
  object HeightMap: TGLBitmapHDS
    InfiniteWrap = False
    MaxPoolSize = 0
    Left = 8
    Top = 48
  end
  object TextureLib: TGLMaterialLibrary
    Materials = <
      item
        Name = 'GroundTexture'
        Material.FrontProperties.Ambient.Color = {A9A5253FB1A8283EB1A8283ECDCCCC3D}
        Material.FrontProperties.Diffuse.Color = {6666263F6666263F6666263F00000000}
        Material.FrontProperties.Emission.Color = {000000000000000000000000CDCCCC3D}
        Material.FrontProperties.Specular.Color = {BEBEBE3E999F1F3F999F1F3FCDCCCC3D}
        Material.Texture.Image.Picture.Data = {
          07544269746D617046000000424D460000000000000036000000280000000200
          000002000000010018000000000010000000130B0000130B0000000000000000
          00004C858849818400004C85874981840000}
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.MappingSCoordinates.Coordinates = {0000A041000000000000000000000000}
        Material.Texture.Disabled = False
        Tag = 0
      end
      item
        Name = 'GroundMetalTexture'
        Material.Texture.FilteringQuality = tfAnisotropic
        Material.Texture.Disabled = False
        Tag = 0
      end>
    Left = 8
    Top = 80
  end
  object GLCadencer: TGLCadencer
    Scene = GLScene
    Enabled = False
    TimeReference = cmExternal
    Mode = cmApplicationIdle
    SleepLength = 10
    Left = 8
    Top = 112
  end
end
