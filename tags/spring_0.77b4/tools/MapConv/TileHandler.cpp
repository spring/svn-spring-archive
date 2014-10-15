#include "TileHandler.h"
#include "FileHandler.h"
#include "ddraw.h"
#include "mapfile.h"
#include <iostream.h>
#include <IL/ilut.h>
#include <IL/ilu.h>
#include <IL/il.h>
#include <string>

extern string stupidGlobalCompressorName;
using namespace std;
string prog;

CTileHandler tileHandler;

CTileHandler::CTileHandler()
{
}

CTileHandler::~CTileHandler(void)
{
	for(int a=0;a<usedTiles;++a)
		delete tiles[a];
}

void CTileHandler::LoadTexture(string name,unsigned int x,unsigned int y,int filter)
{
	printf("Loading texture\n");
	
	bigTex.Load(name,255,x,y,filter,false,1,true,(bool)false,false);
	
	xsize=bigTex.xsize/8;
	ysize=bigTex.ysize/8;
}

void CTileHandler::ProcessTiles(float compressFactor,int quality,string format)
{
	meanThreshold=(int)(2000*compressFactor);
	meanDirThreshold=(int)(20000*compressFactor);
	borderThreshold=(int)(80000*compressFactor);

	system("mkdir temp");

	usedTiles=0;
	unsigned char buf[SMALL_TILE_SIZE];

	for(vector<string>::iterator fi=externalFiles.begin();fi!=externalFiles.end();++fi){
		ifstream ifs(fi->c_str(),ios::in | ios::binary);
		if(!ifs.is_open()){
			printf("Couldnt find tile file %s\n",fi->c_str());
			continue;
		}
		TileFileHeader tfh;
		ifs.read((char*)&tfh,sizeof(TileFileHeader));

		if(strcmp(tfh.magic,"spring tilefile")!=0 || tfh.version!=1 || tfh.tileSize!=32){
			printf("Error opening tile file %s\n",fi->c_str());
			continue;
		}
		externalFileTileSize.push_back(tfh.numTiles);

		printf("Loading %i tiles from %s\n",tfh.numTiles,fi->c_str());
		for(int a=0;a<tfh.numTiles;++a){
			ifs.read((char*)buf,SMALL_TILE_SIZE);
			CBitmap* bm=new CBitmap();
			bm->CreateFromDXT1(buf,32,32);

			fastStats[usedTiles]=CalcFastStat(bm);
			tiles[usedTiles++]=bm;
		}
	}

	numExternalTile=usedTiles;

	unsigned char* data=new unsigned char[1024*1024*4];
	int tilex=xsize/4;
	int tiley=ysize/4;

	for(int a=0;a<(tilex*tiley)/1024;++a){
		int startTile=a*1024;
		for(int b=0;b<1024;++b){
			int x=b%32;
			int y=b/32;
			int xb=(startTile+b)%tilex;
			int yb=(startTile+b)/tilex;
			for(int y2=0;y2<32;++y2){
				for(int x2=0;x2<32;++x2){
					data[((y*32+y2)*1024+x*32+x2)*4+0]=bigTex.mem[((yb*32+y2)*bigTex.xsize+xb*32+x2)*4+0];
					data[((y*32+y2)*1024+x*32+x2)*4+1]=bigTex.mem[((yb*32+y2)*bigTex.xsize+xb*32+x2)*4+1];
					data[((y*32+y2)*1024+x*32+x2)*4+2]=bigTex.mem[((yb*32+y2)*bigTex.xsize+xb*32+x2)*4+2];
					data[((y*32+y2)*1024+x*32+x2)*4+3]=bigTex.mem[((yb*32+y2)*bigTex.xsize+xb*32+x2)*4+3];
				}
			}
		}
		CBitmap square(data,1024,1024);
		char name[100];
		if (format.substr(0,format.length())=="bmp") sprintf(name,"temp\\Temp%03i.bmp",a);
		if (format.substr(0,format.length())=="png") sprintf(name,"temp\\Temp%03i.png",a);
		if (format.substr(0,format.length())=="jpg") sprintf(name,"temp\\Temp%03i.jpg",a);
		if (format.substr(0,format.length())=="tga") sprintf(name,"temp\\Temp%03i.tga",a);
		if (format.substr(0,format.length())=="raw") sprintf(name,"temp\\Temp%03i.raw",a);
		if (format.substr(0,format.length())=="ppm") sprintf(name,"temp\\Temp%03i.ppm",a);
		if (format.substr(0,format.length())=="dds") sprintf(name,"temp\\Temp%03i.dds",a);
		if (format.substr(0,format.length())=="rgb") sprintf(name,"temp\\Temp%03i.rgb",a);
		if (format.substr(0,format.length())=="tif") sprintf(name,"temp\\Temp%03i.tif",a);

		square.Save(name,quality);
		printf("Writing tile files %i%%\n", (((a+1)*1024)*100)/(tilex*tiley));
	}
	printf("Creating dds files\n");
	string execstring=stupidGlobalCompressorName.c_str();
	char program[32];
	
	execstring.copy(program,execstring.find_first_of('-'),0);
	
	prog+=program;
	
	if (prog == "nvdxt.exe ")	
	   cout << "texture program: nvdxt." << endl;
	if (prog == "nvcompress.exe ")   
	   cout << "texture program: nvcompress" << endl;
	if ( prog == "texconv.exe ")
	   cout << "texture program: texconv" << endl;
	if ( prog == "texcompress.exe ")
	   cout << "texture program: texcompress" << endl;
	if ( prog == "old_nvdxt.exe ")
	   cout << "texture program: the old nvdxt" << endl;
	
	system(execstring.c_str());
	
	delete[] data;
}


void CTileHandler::ProcessTiles2(void)
{
	unsigned char* data=new unsigned char[1024*1024*4];
	bigTex=CBitmap(data,1,1);	/// /free big tex memory
	int tilex=xsize/4;
	int tiley=ysize/4;

	for(int a=0;a<(tilex*tiley)/1024;++a){
		int startTile=a*1024;

		char name[100];
		DDSURFACEDESC2 ddsheader;
		int ddssignature;
		CFileHandler file;
		
		if (prog == "nvdxt.exe " || prog == "nvcompress.exe " || prog == "texconv.exe " || prog == "old_nvdxt.exe "){	
			sprintf(name,"Temp%03i.dds",a);	
		    file.Open(name);
			file.Read(&ddssignature, sizeof(int));
			file.Read(&ddsheader, sizeof(DDSURFACEDESC2));
		} 
		if (prog == "texcompress.exe "){
		    sprintf(name, "temp\\Temp%03i.png.raw", a);
		    file.Open(name);
		}    

		char bigtile[696320]; // /1024x1024 and 4 mipmaps
		file.Read(bigtile, 696320);

		for(int b=0;b<1024;++b){
			int x=b%32;
			int y=b/32;
			int xb=(startTile+b)%tilex;
			int yb=(startTile+b)/tilex;

			char* ctile=new char[SMALL_TILE_SIZE];
			ReadTile(x*32,y*32,ctile,bigtile);
			CBitmap* bm=new CBitmap();
			bm->CreateFromDXT1((unsigned char*)ctile,32,32);

			int t1=tileUse[max(0,(yb-1)*tilex+xb)];
			int t2=tileUse[max(0,yb*tilex+xb-1)];
			int ct=FindCloseTile(bm,t1==t2?t1:-1);
			if(ct==-1){
				tileUse[yb*tilex+xb]=usedTiles;
				tiles[usedTiles++]=bm;
				newTiles.push_back(ctile);
			} else {
				tileUse[yb*tilex+xb]=ct;
				delete bm;
				delete[] ctile;
			}
		}
		printf("Creating tiles %i/%i %i%%\n", usedTiles-numExternalTile,(a+1)*1024,(((a+1)*1024)*100)/(tilex*tiley));
	}

	delete[] data;
}

void CTileHandler::SaveData(ofstream& ofs)
{
	//write tile header
	MapTileHeader mth;
	mth.numTileFiles=(int)externalFiles.size()+1;
	mth.numTiles=usedTiles;
	ofs.write((char*)&mth,sizeof(MapTileHeader));

	//write external tile files used
	for(int fileNum=0;fileNum<(int)externalFiles.size();++fileNum){
		ofs.write((char*)&externalFileTileSize[fileNum],4);
		ofs.write(externalFiles[fileNum].c_str(),externalFiles[fileNum].size()+1);
	}
	//write new tile file to be created
	int internalTiles=usedTiles-numExternalTile;
	ofs.write((char*)&internalTiles,4);
	ofs.write(myTileFile.c_str(),myTileFile.size()+1);

	//write tiles
	for(int y=0; y<ysize/4; y++){
		for(int x=0; x<xsize/4; x++){
			int num = tileUse[x+y*xsize/4];
			ofs.write((char*)&num, sizeof(int));
		}
	}

	//create new tile file

	ofstream tf(myTileFile.c_str(),ios::binary | ios::out);

	TileFileHeader tfh;
	strcpy(tfh.magic,"spring tilefile");
	tfh.version=1;
	tfh.tileSize=32;
	tfh.compressionType=1;
	tfh.numTiles=internalTiles;

	tf.write((char*)&tfh,sizeof(TileFileHeader));

	for(int a=0;a<internalTiles;++a){
		tf.write(newTiles[a],SMALL_TILE_SIZE);
		delete[] newTiles[a];
	}
}

void CTileHandler::ReadTile(int xpos, int ypos, char *destbuf, char *sourcebuf)
{
	int doffset = 0;
	int soffset = 0;

	for(int i=0; i<4; i++)
	{
		int div = 1<<i;
		int xp = 8/div;
		int yp = 8/div;
		for(int y=0; y<yp; y++)
		{
			for(int x=0; x<xp; x++)
			{
				char *destptr = &destbuf[(x+y*xp)*8 + doffset];
				char *srcptr = &sourcebuf[((x+xpos/div/4)+((y+ypos/div/4))*(256/(div)))*8 + soffset];

				for(int i=0; i<8; i++)
					destptr[i] = srcptr[i];
			}
		}
		doffset += 512/(1<<(i*2));
		soffset += 524288/(1<<(i*2));
	}
}

int CTileHandler::FindCloseTile(CBitmap* bm,int forbidden)
{
	FastStat fs=CalcFastStat(bm);
	for(int a=0;a<usedTiles;++a){
		if(a!=forbidden &&
			abs(fs.r-fastStats[a].r)<meanThreshold && abs(fs.g-fastStats[a].g)<meanThreshold && abs(fs.b-fastStats[a].b)<meanThreshold
		&& abs(fs.rx-fastStats[a].rx)<meanDirThreshold && abs(fs.gx-fastStats[a].gx)<meanDirThreshold && abs(fs.bx-fastStats[a].bx)<meanDirThreshold
		&& abs(fs.ry-fastStats[a].ry)<meanDirThreshold && abs(fs.gy-fastStats[a].gy)<meanDirThreshold && abs(fs.by-fastStats[a].by)<meanDirThreshold
		&& CompareTiles(bm,tiles[a]))
			return a;
	}
	fastStats[usedTiles]=fs;
	return -1;
}


CTileHandler::FastStat CTileHandler::CalcFastStat(CBitmap* bm)
{
	FastStat fs;
	fs.r=0;
	fs.g=0;
	fs.b=0;

	fs.rx=0;
	fs.gx=0;
	fs.bx=0;

	fs.ry=0;
	fs.gy=0;
	fs.by=0;

	for(int y=0;y<32;++y){
		for(int x=0;x<32;++x){
			fs.r+=bm->mem[(y*32+x)*4+0];
			fs.g+=bm->mem[(y*32+x)*4+1];
			fs.b+=bm->mem[(y*32+x)*4+2];

			fs.rx+=bm->mem[(y*32+x)*4+0]*(x-16);
			fs.gx+=bm->mem[(y*32+x)*4+1]*(x-16);
			fs.bx+=bm->mem[(y*32+x)*4+2]*(x-16);

			fs.ry+=bm->mem[(y*32+x)*4+0]*(y-16);
			fs.gy+=bm->mem[(y*32+x)*4+1]*(y-16);
			fs.by+=bm->mem[(y*32+x)*4+2]*(y-16);
		}
	}
	return fs;
}

bool CTileHandler::CompareTiles(CBitmap* bm, CBitmap* bm2)
{
	int totalerror=0;
	for(int y=0;y<32;++y){
		for(int x=0;x<32;++x){
			if(!(y==0 || y==31 || x==0 || x==31))
				continue;
			int rdif=bm->mem[(y*32+x)*4+0]-bm2->mem[(y*32+x)*4+0];
			int gdif=bm->mem[(y*32+x)*4+1]-bm2->mem[(y*32+x)*4+1];
			int bdif=bm->mem[(y*32+x)*4+2]-bm2->mem[(y*32+x)*4+2];
			int error=rdif*rdif+gdif*gdif+bdif*bdif;
			totalerror+=error;
		}
		if(totalerror>borderThreshold)
			return false;
	}
	return true;
}

int CTileHandler::GetFileSize(void)
{
	int size=xsize*ysize/4;		//space needed for tile map
	size+=sizeof(MapTileHeader);
	for(vector<string>::iterator fi=externalFiles.begin();fi!=externalFiles.end();++fi){
		size+=5;		//overhead per file (including 0 termination of string)
		size+=(int)fi->size();		//size for filename
	}
	size+=(int)myTileFile.size()+5;	//size and overhead of new tilefile name
	return size;
}

void CTileHandler::AddExternalTileFile(string file)
{
	externalFiles.push_back(file);
}

void CTileHandler::SetOutputFile(string file)
{
	myTileFile=file.substr(0,file.find_last_of('.'))+".smt";
}
