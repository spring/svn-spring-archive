#include "StdAfx.h"

#include "Sm3Map.h"
#include "Sm3GroundDrawer.h"

#include "Game/UI/InfoConsole.h"
#include <GL/glew.h>
#include <IL/il.h>
#include "Rendering/ShadowHandler.h"
#include "Platform/ConfigHandler.h"
#include "Platform/errorhandler.h"

#include <stdexcept>
#include "bitops.h"

using namespace std;

CSm3ReadMap::CSm3ReadMap()
{
	groundDrawer=0;
}

CSm3ReadMap::~CSm3ReadMap()
{
	delete groundDrawer;
}

struct Sm3LoadCB : terrain::ILoadCallback
{
	void Write(const char *msg) { info->AddLine (msg); }
};

void CSm3ReadMap::Initialize (const char *mapname)
{
	try {
		string lmsg = "Loading " + string(mapname);
		PrintLoadMsg(lmsg.c_str());
		int tu;
		glGetIntegerv(GL_MAX_TEXTURE_UNITS, &tu);

		if (false) {//tu < 4) {
			tr.config.cacheTextures=true;
			tr.config.cacheTextureSize=256;
		}
		else {
			tr.config.cacheTextures=false;

			if (GLEW_ARB_fragment_shader && GLEW_ARB_shading_language_100) {
				tr.config.useBumpMaps=false;

				tr.config.anisotropicFiltering = 0.0f;
			}
			tr.config.terrainNormalMaps = false;
			tr.config.normalMapLevel = 3;
		}

		if (shadowHandler->drawShadows)
			tr.config.useShadowMaps = true;

		tr.config.useStaticShadow=true;

		// Load map info from TDF
		std::string fn = std::string("maps/") + mapname;
		mapDefParser.LoadFile (fn);
		TdfParser resources("gamedata/resources.tdf");
		ParseSettings(resources);

		Sm3LoadCB loadcb;
		terrain::LightingInfo lightInfo;
		lightInfo.ambient = ambientColor;
		terrain::StaticLight light;
		light.color = sunColor;
		light.directional = false;
		light.position = gs->sunVector * 10000;
		lightInfo.staticLights.push_back (light);
		tr.Load (mapDefParser, &lightInfo, &loadcb);

		height = width = tr.GetHeightmapWidth ()-1;

		// Set global map info
		gs->mapx=width;
		gs->mapy=height;
		gs->mapSquares = width*height;
		gs->hmapx=width/2;
		gs->hmapy=height/2;
		gs->pwr2mapx=next_power_of_2(width);
		gs->pwr2mapy=next_power_of_2(height);

		float3::maxxpos=width*SQUARE_SIZE-1;
		float3::maxzpos=height*SQUARE_SIZE-1;

		heightmap=new float[(width+1)*(height+1)];
		tr.GetHeightmap (0,0,width+1,height+1,heightmap);

		CalcHeightfieldData();
		
		groundDrawer = new CSm3GroundDrawer (this);
	}
	catch(content_error& e)
	{
		ErrorMessageBox(e.what(), "Error:", MBF_OK);
	}
}


CBaseGroundDrawer *CSm3ReadMap::GetGroundDrawer ()
{
	return groundDrawer;
}

void CSm3ReadMap::HeightmapUpdated(int x1, int x2, int y1, int y2)
{
	// heightmap is [width+1][height+1]
	if (x1<0) x1=0;
	if (x1>width) x1=width;
	if (x2<0) x2=0;
	if (x2>width) x2=width;

	if (y1<0) y1=0;
	if (y1>width) y1=height;
	if (y2<0) y2=0;
	if (y2>width) y2=height;

	tr.SetHeightmap(x1,y1, x2-x1,y2-y1, heightmap, width+1, height+1);
}

void CSm3ReadMap::Update() {}
void CSm3ReadMap::Explosion(float x,float y,float strength) {}
void CSm3ReadMap::ExplosionUpdate(int x1,int x2,int y1,int y2) {}
unsigned int CSm3ReadMap::GetShadingTexture () { return 0; } // a texture with RGB for shading and A for height
void CSm3ReadMap::DrawMinimap () 
{
	 // draw the minimap in a quad (with extends: (0,0)-(1,1))
}

// Determine visibility for a rectangular grid
void CSm3ReadMap::GridVisibility(CCamera *cam, int quadSize, float maxdist, IQuadDrawer *cb, int extraSize)
{
}


// Feature creation
int CSm3ReadMap::GetNumFeatures () { return 0; }
int CSm3ReadMap::GetNumFeatureTypes () { return 0; }
void CSm3ReadMap::GetFeatureInfo (MapFeatureInfo* f) {} // returns MapFeatureInfo[GetNumFeatures()]
const char *CSm3ReadMap::GetFeatureType (int typeID) { return ""; }

CSm3ReadMap::InfoMap::InfoMap () {
	w = h = 0;
	data = 0;
}
CSm3ReadMap::InfoMap::~InfoMap () {
	if(data) delete[] data;
}

// Bitmaps (such as metal map, grass map, ...), handling them with a string as type seems flexible...
// Some map types:
//   "metal"  -  metalmap
//   "grass"  -  grassmap
unsigned char *CSm3ReadMap::GetInfoMap (const std::string& name, MapBitmapInfo* bm) 
{ 
	std::string map;
	if (!mapDefParser.SGetValue(map, "MAP\\INFOMAPS\\" + name))
		return 0;

	// all infomaps are grayscale (new interfaces don't yet support grayscale memtextures)
	MemTexture mtx = TextureLoader::Instance().LoadMemTexture(map);
	if (!mtx) {
		return 0;
	}

	unsigned char *mem = new unsigned char[mtx.Total()];
	for (std::size_t i = 0; i < mtx.Total(); ++i) {
		mem[i] = mtx.Bytes()[i * 4]; // just use red channel to pull greyscale value
	}

	InfoMap& im = infoMaps[name];

	bm->width = im.w = mtx.Width();
	bm->height = im.h = mtx.Height();
	im.data = mem;

	return im.data;
}


void CSm3ReadMap::FreeInfoMap (const std::string& name, unsigned char *data)
{
	infoMaps.erase (name);
}

