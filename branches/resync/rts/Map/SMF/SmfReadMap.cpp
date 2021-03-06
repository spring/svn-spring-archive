#include "StdAfx.h"
#include "SmfReadMap.h"
#include "mapfile.h"
#include "Rendering/GL/myGL.h"
#include <GL/glu.h>
#include "FileSystem/FileHandler.h"
#include "Platform/ConfigHandler.h"
#include "BFGroundTextures.h"
#include "BFGroundDrawer.h"
#include "LogOutput.h"
#include "Sim/Misc/FeatureHandler.h"
#include "myMath.h"
#include "Platform/errorhandler.h"
#include "Rendering/Textures/Bitmap.h"
#include "Game/Camera.h"
#include "bitops.h"
#include "mmgr.h"

using namespace std;

CR_BIND_DERIVED(CSmfReadMap, CReadMap, (""))

CBaseGroundDrawer* CSmfReadMap::GetGroundDrawer ()
{
	return groundDrawer;
}


CSmfReadMap::CSmfReadMap(std::string mapname)
{
	PrintLoadMsg("Opening map file");

	string smdfile = string("maps/")+mapname.substr(0,mapname.find_last_of('.'))+".smd";
	mapDefParser.LoadFile(smdfile);
	TdfParser resources("gamedata/resources.tdf");
	ParseSettings(resources);

	mapDefParser.GetDef(detailTexName, "", "MAP\\DetailTex");
	if(detailTexName.empty())
		detailTexName = "bitmaps/"+resources.SGetValueDef("detailtex2.bmp","resources\\graphics\\maps\\detailtex");
	else
		detailTexName = "maps/" + detailTexName;

	for(int a=0;a<1024;++a){
		for(int b=0;b<3;++b){
			float c=max(waterMinColor[b],waterBaseColor[b]-waterAbsorb[b]*a);
			waterHeightColors[a*4+b]=(unsigned char)(c*210);
		}
		waterHeightColors[a*4+3]=1;
	}

	PUSH_CODE_MODE;
	ENTER_MIXED;
	ifs=SAFE_NEW CFileHandler(string("maps/")+mapname);
	if(!ifs->FileExists())
		throw content_error("Couldn't open map file " + mapname);
	POP_CODE_MODE;
	READPTR_MAPHEADER(header,ifs);

	if(strcmp(header.magic,"spring map file")!=0 || header.version!=1 || header.tilesize!=32 || header.texelPerSquare!=8 || header.squareSize!=8)
		throw content_error("Incorrect map file " + mapname);

	width=header.mapx;
	height=header.mapy;
	gs->mapx=header.mapx;
	gs->mapy=header.mapy;
	gs->mapSquares = gs->mapx*gs->mapy;
	gs->hmapx=gs->mapx/2;
	gs->hmapy=gs->mapy/2;
	gs->pwr2mapx=next_power_of_2(gs->mapx);
	gs->pwr2mapy=next_power_of_2(gs->mapy);

//	logOutput.Print("%i %i",gs->mapx,gs->mapy);
	float3::maxxpos=gs->mapx*SQUARE_SIZE-1;
	float3::maxzpos=gs->mapy*SQUARE_SIZE-1;

	heightmap=SAFE_NEW float[(gs->mapx+1)*(gs->mapy+1)];//SAFE_NEW float[(gs->mapx+1)*(gs->mapy+1)];

	//CFileHandler ifs((string("maps/")+stupidGlobalMapname).c_str());

	float base=header.minHeight;
	float mod=(header.maxHeight-header.minHeight)/65536.0f;

	int hmx=gs->mapx+1, hmy=gs->mapy+1;
	unsigned short* temphm=SAFE_NEW unsigned short[hmx * hmy];
	ifs->Seek(header.heightmapPtr);
	ifs->Read(temphm,hmx*hmy*2);

	for(int y=0;y<hmx*hmy;++y){
		heightmap[y]=base+swabword(temphm[y])*mod;
	}

	delete[] temphm;

	CReadMap::Initialize();

	for(unsigned int a=0;a<mapname.size();++a){
		mapChecksum+=mapname[a];
		mapChecksum*=mapname[a];
	}

	PrintLoadMsg("Loading detail textures");

	CBitmap bm;
	if (!bm.Load(detailTexName))
		throw content_error("Could not load detail texture from file " + detailTexName);
	glGenTextures(1, &detailTex);
	glBindTexture(GL_TEXTURE_2D, detailTex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
	gluBuild2DMipmaps(GL_TEXTURE_2D,GL_RGBA8 ,bm.xsize, bm.ysize, GL_RGBA, GL_UNSIGNED_BYTE, bm.mem);

	PrintLoadMsg("Creating overhead texture");

	unsigned char* buf=SAFE_NEW unsigned char[MINIMAP_SIZE];
	ifs->Seek(header.minimapPtr);
	ifs->Read(buf,MINIMAP_SIZE);
	glGenTextures(1, &minimapTex);
	glBindTexture(GL_TEXTURE_2D, minimapTex);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
	//glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA8 ,512, 512, 0, GL_RGBA, GL_UNSIGNED_BYTE, buf);
	int offset=0;
	for(unsigned int i=0; i<MINIMAP_NUM_MIPMAP; i++)
	{
		int mipsize = 1024>>i;

		int size = ((mipsize+3)/4)*((mipsize+3)/4)*8;

		glCompressedTexImage2DARB(GL_TEXTURE_2D, i, GL_COMPRESSED_RGBA_S3TC_DXT1_EXT, mipsize, mipsize, 0, size, buf + offset);

		offset += size;
	}
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, MINIMAP_NUM_MIPMAP-1 );
	
	delete[] buf;

	PrintLoadMsg("Creating ground shading");

	glGenTextures(1, &shadowTex);
	glBindTexture(GL_TEXTURE_2D, shadowTex);
//	unsigned char* tempMem=SAFE_NEW unsigned char[1024*1024*4];
	glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA8 ,gs->pwr2mapx, gs->pwr2mapy, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
//	delete [] tempMem;

	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);

	HeightmapUpdated(0, gs->mapx, 0, gs->mapy);

	groundDrawer=SAFE_NEW CBFGroundDrawer(this);

	ReadFeatureInfo ();
}

CSmfReadMap::~CSmfReadMap(void)
{
	delete[] featureTypes;
	delete groundDrawer;
	delete ifs;
	delete[] heightmap;
	if (detailTex) glDeleteTextures (1, &detailTex);
	if (minimapTex) glDeleteTextures (1, &minimapTex);
	if (shadowTex) glDeleteTextures (1, &shadowTex);
}

void CSmfReadMap::HeightmapUpdated(int x1, int x2, int y1, int y2)
{
	x1-=x1&3;
	x2+=(20004-x2)&3;

	y1-=y1&3;
	y2+=(20004-y2)&3;

	int xsize=x2-x1;
	int ysize=y2-y1;

	//logOutput.Print("%i %i %i %i",x1,x2,y1,y2);
	unsigned char* tempMem=SAFE_NEW unsigned char[xsize*ysize*4];
	for(int y=0;y<ysize;++y){
		for(int x=0;x<xsize;++x){
			float height = centerheightmap[(x+x1)+(y+y1)*gs->mapx];

			if(height<0){
				int h=(int)-height;

				if(height>-10){
					float3 light = GetLightValue(x+x1,y+y1)*210.0f;
					float wc=-height*0.1f;
					tempMem[(y*xsize+x)*4+0] = (unsigned char)(waterHeightColors[h*4+0]*wc+light.x*(1-wc));
					tempMem[(y*xsize+x)*4+1] = (unsigned char)(waterHeightColors[h*4+1]*wc+light.y*(1-wc));
					tempMem[(y*xsize+x)*4+2] = (unsigned char)(waterHeightColors[h*4+2]*wc+light.z*(1-wc));
				} else if(h<1024){
					tempMem[(y*xsize+x)*4+0] = waterHeightColors[h*4+0];
					tempMem[(y*xsize+x)*4+1] = waterHeightColors[h*4+1];
					tempMem[(y*xsize+x)*4+2] = waterHeightColors[h*4+2];
				} else {
					tempMem[(y*xsize+x)*4+0] = waterHeightColors[1023*4+0];
					tempMem[(y*xsize+x)*4+1] = waterHeightColors[1023*4+1];
					tempMem[(y*xsize+x)*4+2] = waterHeightColors[1023*4+2];
				}
				tempMem[(y*xsize+x)*4+3] = EncodeHeight(height);
			} else {
				float3 light = GetLightValue(x+x1,y+y1)*210.0f;
				tempMem[(y*xsize+x)*4] = (unsigned char)light.x;
				tempMem[(y*xsize+x)*4+1] = (unsigned char)light.y;
				tempMem[(y*xsize+x)*4+2] = (unsigned char)light.z;
				tempMem[(y*xsize+x)*4+3] = 255;
			}
		}
	}
	glBindTexture(GL_TEXTURE_2D, shadowTex);
	glTexSubImage2D(GL_TEXTURE_2D,0,x1,y1,xsize,ysize,GL_RGBA,GL_UNSIGNED_BYTE,tempMem);

	delete[] tempMem;

}

float3 CSmfReadMap::GetLightValue(int x, int y)
{
	float3 n1=facenormals[(y*gs->mapx+x)*2]+facenormals[(y*gs->mapx+x)*2+1];
	n1.Normalize();

	float3 light=sunColor*gs->sunVector.dot(n1);
	for(int a=0;a<3;++a)
		if(light[a]<0)
			light[a]=0;

	light+=ambientColor;
	for(int a=0;a<3;++a)
		if(light[a]>1)
			light[a]=1;

	return light;
}


void CSmfReadMap::DrawMinimap ()
{
	glEnable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glDisable(GL_ALPHA_TEST);
	glBindTexture(GL_TEXTURE_2D, shadowTex);
	glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE0_RGB_ARB,GL_PREVIOUS_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE1_RGB_ARB,GL_TEXTURE);
	glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB_ARB,GL_MODULATE);
	glTexEnvi(GL_TEXTURE_ENV,GL_RGB_SCALE_ARB,2);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE_ARB);

	glActiveTextureARB(GL_TEXTURE1_ARB);
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, minimapTex);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);		
	glActiveTextureARB(GL_TEXTURE0_ARB);

	if(groundDrawer->DrawExtraTex()){
		glActiveTextureARB(GL_TEXTURE2_ARB);
		glEnable(GL_TEXTURE_2D);
		glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB_ARB,GL_ADD_SIGNED_ARB);
		glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE_ARB);
		glBindTexture(GL_TEXTURE_2D, groundDrawer->infoTex);
		glActiveTextureARB(GL_TEXTURE0_ARB);
	}

	float isx=gs->mapx/float(gs->pwr2mapx);
	float isy=gs->mapy/float(gs->pwr2mapy);

	glBegin(GL_QUADS);
		glTexCoord2f(0,isy);
		glMultiTexCoord2fARB(GL_TEXTURE1_ARB,0,1);
		glMultiTexCoord2fARB(GL_TEXTURE2_ARB,0,isy);
		glVertex2f(0,0);
		glTexCoord2f(0,0);
		glMultiTexCoord2fARB(GL_TEXTURE1_ARB,0,0);
		glMultiTexCoord2fARB(GL_TEXTURE2_ARB,0,0);
		glVertex2f(0,1);
		glTexCoord2f(isx,0);
		glMultiTexCoord2fARB(GL_TEXTURE1_ARB,1,0);
		glMultiTexCoord2fARB(GL_TEXTURE2_ARB,isx,0);
		glVertex2f(1,1);
		glTexCoord2f(isx,isy);
		glMultiTexCoord2fARB(GL_TEXTURE1_ARB,1,1);
		glMultiTexCoord2fARB(GL_TEXTURE2_ARB,isx,isy);
		glVertex2f(1,0);
	glEnd();

	glTexEnvi(GL_TEXTURE_ENV,GL_RGB_SCALE_ARB,1);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
	glActiveTextureARB(GL_TEXTURE1_ARB);
	glDisable(GL_TEXTURE_2D);
	glActiveTextureARB(GL_TEXTURE2_ARB);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);		
	glDisable(GL_TEXTURE_2D);
	glActiveTextureARB(GL_TEXTURE0_ARB);
}


void CSmfReadMap::GridVisibility (CCamera *cam, int quadSize, float maxdist, CReadMap::IQuadDrawer *qd, int extraSize)
{
	int cx=(int)(cam->pos.x/(SQUARE_SIZE*quadSize));
	int cy=(int)(cam->pos.z/(SQUARE_SIZE*quadSize));

	int drawSquare=int(maxdist/(SQUARE_SIZE*quadSize))+1;

	int drawQuadsX = header.mapx / quadSize;
	int drawQuadsY = header.mapy / quadSize;

	int sy=cy-drawSquare;
	if(sy<0)
		sy=0;
	int ey=cy+drawSquare;
	if(ey>=header.mapy/quadSize)
		ey=header.mapy/quadSize-1;

	for(int y=sy;y<=ey;y++){
		int sx=cx-drawSquare;
		if(sx<0)
			sx=0;
		int ex=cx+drawSquare;
		if(ex>drawQuadsX-1)
			ex=drawQuadsX-1;
		float xtest,xtest2;

		std::vector<CBFGroundDrawer::fline>::iterator fli;
		for(fli=groundDrawer->left.begin();fli!=groundDrawer->left.end();fli++){
			xtest=((fli->base/SQUARE_SIZE+fli->dir*(y*quadSize)));
			xtest2=((fli->base/SQUARE_SIZE+fli->dir*((y*quadSize)+quadSize)));
			if(xtest>xtest2)
				xtest=xtest2;
			xtest=xtest/quadSize;
			if(xtest-extraSize>sx)
				sx=((int)xtest)-extraSize;
		}
		for(fli=groundDrawer->right.begin();fli!=groundDrawer->right.end();fli++){
			xtest=((fli->base/SQUARE_SIZE+fli->dir*(y*quadSize)));
			xtest2=((fli->base/SQUARE_SIZE+fli->dir*((y*quadSize)+quadSize)));
			if(xtest<xtest2)
				xtest=xtest2;
			xtest=xtest/quadSize;
			if(xtest+extraSize<ex)
				ex=((int)xtest)+extraSize;
		}

		for(int x=sx;x<=ex;x++)
			qd->DrawQuad (x,y);
	}
}

int CSmfReadMap::GetNumFeatures ()
{
	return featureHeader.numFeatures;
}

int CSmfReadMap::GetNumFeatureTypes ()
{
	return featureHeader.numFeatureType;
}

void CSmfReadMap::GetFeatureInfo (MapFeatureInfo* f)
{
	ifs->Seek (featureFileOffset);
	for(int a=0;a<featureHeader.numFeatures;++a){
		MapFeatureStruct ffs;
		READ_MAPFEATURESTRUCT(ffs, ifs);

		f[a].featureType = ffs.featureType;
		f[a].pos = float3(ffs.xpos, ffs.ypos, ffs.zpos);
		f[a].rotation = ffs.rotation;
	}
}

const char *CSmfReadMap::GetFeatureType (int typeID)
{
	assert (typeID >= 0 && typeID < featureHeader.numFeatureType);
	return featureTypes[typeID].c_str();
}

unsigned char *CSmfReadMap::GetInfoMap (const std::string& name, MapBitmapInfo* bmInfo)
{
	if (name == "grass") {
		bmInfo->width = header.mapx / 4;
		bmInfo->height = header.mapy / 4;

		unsigned char *data = SAFE_NEW unsigned char[bmInfo->width*bmInfo->height];
		ReadGrassMap (data);
		return data;
	}
	else if(name == "metal") {
		bmInfo->width = header.mapx/2;
		bmInfo->height = header.mapy/2;

		unsigned char *data = SAFE_NEW unsigned char[bmInfo->width*bmInfo->height];
		ifs->Seek(header.metalmapPtr);
		ifs->Read(data,header.mapx/2*header.mapy/2);
        return data;
	}
	else if(name == "type") {
		bmInfo->width = header.mapx/2;
		bmInfo->height = header.mapy/2;
		unsigned char *data = SAFE_NEW unsigned char[bmInfo->width*bmInfo->height];
		ifs->Seek(header.typeMapPtr);
		ifs->Read(data,gs->mapx*gs->mapy/4);
		return data;
	}

	return false;
}

void CSmfReadMap::FreeInfoMap (const std::string& name, unsigned char *data)
{
	delete[] data;
}


void CSmfReadMap::ReadGrassMap(void *data)
{
	CFileHandler* fh=ifs;
	fh->Seek(sizeof(MapHeader));

	for(int a=0;a<header.numExtraHeaders;++a){
		int size;
		fh->Read(&size,4);
		size=swabdword(size);
		int type;
		fh->Read(&type,4);
		type=swabdword(type);
		if(type==MEH_Vegetation){
			int pos;
			fh->Read(&pos,4);
			pos=swabdword(pos);
			fh->Seek(pos);
			fh->Read(data,gs->mapx*gs->mapy/16);
			/* char; no swabbing. */
			break;	//we arent interested in other extensions anyway
		} else {
			unsigned char buf[100];	//todo: fix this if we create larger extensions
			fh->Read(buf,size-8);
		}
	}
}

void CSmfReadMap::ReadFeatureInfo()
{
	ifs->Seek(header.featurePtr);
	READ_MAPFEATUREHEADER(featureHeader, ifs);

	featureTypes=SAFE_NEW string[featureHeader.numFeatureType];

	for(int a=0;a<featureHeader.numFeatureType;++a){
		char c;
		ifs->Read(&c,1);
		while(c){
			featureTypes[a]+=c;
			ifs->Read(&c,1);
		}
	}
	featureFileOffset = ifs->GetPos();
}
